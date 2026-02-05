Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A77BEA794F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 01:13:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 383C26B008A; Wed,  4 Feb 2026 20:13:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 331A36B0092; Wed,  4 Feb 2026 20:13:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22FEC6B0093; Wed,  4 Feb 2026 20:13:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 113A56B008A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 20:13:41 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B38998B548
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 01:13:40 +0000 (UTC)
X-FDA: 84408630600.20.80CE676
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2AE1D8000B
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 01:13:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i4DBkxjm;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770254019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q0OG1vAikrWmmXBnDkAB69Jn79qWKe957R87TZcZ7C4=;
	b=a8rP8lEjiXncZVT5Ahe/w3PbhDCaPFvr4zHgpPbaxEfVr8yVxlJYwTaQE8XGd9y4HpOp6E
	1EImW0279OV6c9zW/RjBQtVXBvV6jpww3IgI2TqWWdx9riLzEOkqMLFbqS5Vk+DvcPrji7
	VgHxLQTSgQuljx487IbN+GD6RCJLSWM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i4DBkxjm;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770254019; a=rsa-sha256;
	cv=none;
	b=EvXgw1uBICu+uFG8BnGEMceV4a+9bl2f1EPpvg7Bnsc1p+Bg+BMdQ9o81gj4H7NosrQyq2
	rwTcuAFEZEeFE4KsUaiX4ebJP/cHHPixiMJvXgrJhgB2UFWHpwpycc97zGjd68Cfi3yhuA
	TprBgVFzTu7jXOsnOsa0SHYJ4yauGB0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B6DC60097;
	Thu,  5 Feb 2026 01:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3A0C16AAE;
	Thu,  5 Feb 2026 01:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770254017;
	bh=vJADyUOcqjwRV6DEcNkjCgVf8seqLpxNZ5PMOkYaC7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i4DBkxjmdmi4sT5jg+10apvdLNCHGIr2e9CyhIQXkMhznZKeJDP7ElGLSbSPtg23h
	 iWD0sRx4coGqbeGX8FRqYnnBcO8gFMgnON42tkPB7OXNF+ufUJ3TZXqX4BbsAIS0cj
	 dAIfs/1fH8fPGhkK6OHU8VilspUnIwLgT8GyraQbvok5eWnlPfZ1zHhC92lHF2IeRo
	 RnUyINkepqjbLrPqhs+Cs+cZ2sTj6HMsxxP/eTte22P3/YxgO4gfWzWzJqp0xtDBQH
	 zxFmYb6oUpoLPfd8SSwrYnuuEEAF9qAx/U8BcGzzFdgOZYmx3oIbBkS1Pm+86U+vjw
	 mctogAEhqcgPg==
From: SeongJae Park <sj@kernel.org>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: SeongJae Park <sj@kernel.org>,
	jane.chu@oracle.com,
	muchun.song@linux.dev,
	david@kernel.org,
	akpm@linux-foundation.org,
	osalvador@suse.de,
	william.roche@oracle.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] fs: hugetlb: simplify remove_inode_hugepages() return type
Date: Wed,  4 Feb 2026 17:13:29 -0800
Message-ID: <20260205011330.68096-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260204214741.3161520-1-jiaqiyan@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6mbzf57yh6kthxo78miotnc86nrq53gm
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2AE1D8000B
X-HE-Tag: 1770254019-110005
X-HE-Meta: U2FsdGVkX1/p1+DdJSxXLl5ectfnKgPaQ3NTlJa1TTWIFv0hwglQr6uzj8vfRRSYaoS8x/fmFIYKSUabEYw/CsktfUDS6K1fuA572We9kPmRPrpJ23TV2gEI4ByVyN9LkbBAS8vTck+zw/XXuOAALWBdAgl1CnZVVcxTtpg3T7EBce0DqwNil1SxNeysfOl0eRpx8UJXRp2sDNFG51QdD9BSXd7utxN5METU3XoWg0bduv0LT+vc5gFjcONsbolzjSc1IGu1TLrvBxHT426tBYZSsATZvWXu3uLvAQ+vAaEbr3oAPntBp+w/kReihnu+9VO1DwZ9mGlm8oruquEFgkDcUOXXD4LKPKI1cy47ohkdGSCt/wmdYM7bZ+FL39fjs2ikM+KZ343+VjXnLqG2CGCrVHqU2j7Ci+AYU2scBDw1BmqSo1JqgeTJklnS3Hk3zdOrF9MVt6CmDSCA+45Lw66Ie2zOXEobA/p+hDuihEX54uLr3Ls0mDB9m2MvFx9GvFiILfNrGCndo0u9s8LHCISE4AGSqt1fHtm5heocIWmhyIS92T8uwwgrAU96Pc0iDzQQ1PL0IpoN7Dy8DGIyEB7pbSfiuvfSUeHk2ZWx4o/uJnf3yICTM0PP+QTDVc/iZtA2G2wtmWzUc6C4ScKun+OdunluUq87wZCr3xhEikLSxCR62okE8NIAx+JNNRRiwTELDxZz3K0LvU86IJND9CWEqyfSSZ9M7VqzBUQaanns8P1aT6wPNbQpc4gpwkusHES41UNJcxDuRnuJRoTUzJVI+00uKAZ+A4NcHSsvoZUhbPV6netriL3EsoBWQXeEQXj0wDFgmHjuY0Zq9vyPGcgNthlWUEM1mivYTEXTMD/7aYytdP+s4SFZnqWhL+Z5Tg/bTkPm8jse85odExI173M5W/8g+iei6s88bBWUFO1+GnZxW1NuyOweqW7Zg8WfU+9mhb57h7Uefj3gO7Q
 GW+n3UMR
 rOujLUmZZiDMl1Irn2tgCHl6kCmLXrvRAnZEhtWymPHfjUFYJlzHweCZLmjsgs2BqRvExj9vMU3VoDEsp4RrUV4Pnu0KHtbD6B4ZH42ANh0I4Tyd5brkj3oIgseGOfjH70vimdf9V0ySTIOlEWp/d/ziIRBlITYxyZktwNdqgmiGbaA5FSaapwZcSwsPIYY9A++jAmdvw0pD+VH0Wnn/lUFIZa2thAiBGu8pj7Km0HRwD7aYWgyZW4BZQBd4iq6bsTQiin/0VQAk2sZMEMin3IUnPxryh7oZTRBkVwes+17sQXi+mEdwB0oVYzp4lWy7ZvbHP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  4 Feb 2026 21:47:41 +0000 Jiaqi Yan <jiaqiyan@google.com> wrote:

> When remove_inode_hugepages is introduced in
> commit c86272287bc6 ("hugetlb: create remove_inode_single_folio to remove single file folio")

Why don't you wrap the above line for the 75 columns limit [1]?

> it used to return a boolean to indicate if it bailed out due to race with
> page faults. However, since the race is already solved by [1],
> remove_inode_hugepages() doesn't have any path to return false anymore.
> 
> Simplify remove_inode_hugepages() return type to void, remove the
> unnecessary ret variable, and adjust the call site in
> remove_inode_hugepages(). No functional change in this commit.
> 
> Changelog
> =========
> 
> v2 -> v1 [2]
> 
> - Use two-tab alignment for parameters wrapped to new lines.
> 
> - Remove return type in remove_inode_hugepages()'s comment.
> 
> [1] https://lore.kernel.org/all/20220914221810.95771-10-mike.kravetz@oracle.com
> [2] https://lore.kernel.org/linux-mm/20260202233617.2350734-1-jiaqiyan@google.com

I found David and Andrew replied the changelog will be removed in the final
one, so will not add comment.

> 
> Suggested-by: Jane Chu <jane.chu@oracle.com>
> Reviewed-by: Jane Chu <jane.chu@oracle.com>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Acked-by: David Hildenbrand (arm) <david@kernel.org>
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>

The above comment is only trivial, and the diff looks good to me.  So,

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

