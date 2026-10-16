Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7573ACCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 07:54:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 701846B008A; Fri, 16 Oct 2026 03:54:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D9296B008C; Fri, 16 Oct 2026 03:54:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EE226B0092; Fri, 16 Oct 2026 03:54:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A8BA6B008A
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:54:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9912340227
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:54:41 +0000 (UTC)
X-FDA: 85327727562.14.84B6E18
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id C8753180009
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:54:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D0GM1obR;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792137279;
	b=EL9rLzMQO2rGLv79b/dKkb1wCBiqiX7ggVsr4yWOp2lFOPq8zhHoxcASkciSZUu9XqQ8tY
	+Cd8bzufgtxCDezQ+b56ib9zO7vp2tRg5z8aBiShA/6zk4V+S6EjPpLzF25btrlAJCQ6Ae
	oPRY6jtYR4lu9xfoOC+N08r1762z+UE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D0GM1obR;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792137279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wv9SRxWQ25pNAKGW38KUgKHliKUCOnNxndAUVFEo+TI=;
	b=BWNRBi+3HqC7PsyKFRvijT56SLGyXlI6q3kmq+pVXz7zDhKvN+QJHqLCAlsp1w+ck8BIFJ
	CdPAItCmZWk3kujbIX4Zs1HoNJH8ydhehVlWqMVNkXP8ggaXdNa7z6gi6eYRpWOXNgWZKO
	9eKAWq94Hd+8LxevCm0KsJPCN3rvwcc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 41B3443701;
	Fri, 16 Oct 2026 07:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B5A11F000C4;
	Fri, 16 Oct 2026 07:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792137278;
	bh=Wv9SRxWQ25pNAKGW38KUgKHliKUCOnNxndAUVFEo+TI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=D0GM1obRxZ4b+2H3T7h8p3NTacDTVcwAIILo+zsG155txmJVR0hYAeEhM3EjzFNgK
	 q3QqupxRe4rlN7PsfyTnw7+EHeQk/iO51sInKcpFSLeeoYkkzadGPbKkIYsRMoCa1B
	 szn6S8d9BmJkfgNSifEZHYcK/+HCAEwtnsZTFSLtW4WDJ8kFfJkApP9tF628X13zXv
	 ZBMoYlI4FQLjEdH0qePl2xrzo/Biurt/B00shjQjUc2mX4u9zoFjVEiJmFEub8P0pW
	 se/FmSO13DVkBrklvuqt5CM1HjH0OWA9hUVY8yhttkeraQi3Wkmh+5qvoIQz3mSS6t
	 be3Zn5Qpdy/lw==
Message-ID: <b64e2b5d-d880-4ea9-ab2c-c04a0963427f@kernel.org>
Date: Fri, 16 Oct 2026 09:54:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mempolicy: convert mempolicy refcnt to refcount_t
To: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, ziy@nvidia.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, ying.huang@linux.alibaba.com,
 kernel test robot <lkp@intel.com>
References: <20261015231322.3392551-1-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261015231322.3392551-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xp1mwyboy7uezwgrbhgwxtxwzwp8uge8
X-Rspamd-Queue-Id: C8753180009
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792137279-186762
X-HE-Meta: U2FsdGVkX18S0benXOOITFMNnkp52U6t/+i6hKVTEqG7GL3ZOUuE+QucnF/MYVWr1cLiHIU44Aaxxs8PYm/4J2lt0yQXxcQcWu9ymnh2iDrat15P8D1RunmAFWfAVAtyPRULnrAh3aVE+4qg8rswC9c75OpwnI/muq/Jg8mQ2c2zeW3bMiG861lPjiDgdfYQw8Zm+aTXS+0R8guKy/i5u7pBUPIrf8/XTwi14Hneuj8113seqmFIWZMaGKoufow5IiJkeHUZdhSoiV/4+Dx6SJ97Gfz2aHdr8RK8yyn9hgs6KAJBnJfZZ4mDcUv6gEKcwQKkT0MElpCdLv83BpFjKU2Lbu69GR3ZrXscCHLfvS388HnutNPNw/asJwRxmt1wFFn6jpm3cqAhdcCxdn80UbzUDsdIKlGNBmpDG31rzbsKcMKYclq1ENCesho/557y+ZNo92pu7BdX4cS9dZ7o555/CGEAyW9YrW1CfLeKgtVmOfd7wvKn1Fem8qNsr9NWs4iRzGsDhTwYtwvNqM+H70+loFSi7w+7DRalzKD4r1ZCv95lBl8ydd7EjtNVqZDk7J3Bmne7cM2f4BYo3ITUdhRJGlsepX05ZbwgrIA4UaI3hadRT6laF7u0rteFwYXgx5YLjJ1+PkNTCMB/rmWEaQzsTaf0YyFxzCiT+c6jc4a0nfBZV68KGmhKDvFasP/hLqzDjvzD9sMR3KBpxHwxpPzkVYhtcJcdC/bf+O+vmh8tg1alqjTTxzxgcgVYD9R9p+prZD51SA6CSiKFhff+JiHX/DKkJvAKhl9zJQjXRW9TF55nRJWjf+/4z9zchsxIwX2eat0uP98f0c88T96QHyjuJGARJymZF/ban+b7ov2hx7RSrGgnwmt6S26CJ+lK5ZJweKJIf4XoQztH5/WARTJMm4PqAOTGU8QYI433RdZbFn4LgzgJC50Ftpkn9WLiqPR+HRoQf2YD4pN1x1n
 sXq4LLcb
 +uwvaHygVwRbGgeKBhhFuF+tFrk5OO1+tDZxPvljtxjkbNRTN0J3un+AosIdmNx9XRdYpC4iltxe5eoolRmy4ppN/geFfKYnbj+lBp+AQ9Rz2NdQG7q8KQEX657umLxXvpCRcyWwDTUrF18D8zAIjcZuokQn5u1RTxGar3Pl7w+X/UmegIRHP+9XnrF7zXUhLZ1R0HSNwjbDc8K7/yl1M7gTbG9VtecrLV87GORKa7jm++xOSaRqdKE7zCMT3jAyh5e/75JEBMD2rof329lLAu/xzsb7Nx6f2QmXqoWF89qa/lZdCDSHNyNg8x/k5bkjW1WurzPFCJB9Iea0jtViJI0YJ3SHnI6smfJag9wgLSUIXdAD+12ETSFWFSQYxj89U5d0U/jhlVJkwx7MeVDlw2mfaiBjcMMSkMcaV5gKPUKoMOi6TUVcrrQ1Nmv2v+lEoWXzo5+V0xcbc+mMfiAx9FDK9etkJ/l4HKzm3gy2dZ8EfJAY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/16/26 01:13, Gregory Price (Meta) wrote:
> struct mempolicy uses an atomic_t as a pure reference counter.
> 
> Convert it to refcount_t so that overflow and underflow are caught
> by the refcount saturation checks.
> 
> This silences the atomic_as_refcounter.cocci warning, which started
> matching __mpol_put() when it switched kmem_cache_free() to kfree_rcu().
> 
> No functional change for correct callers.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202610061946.Bx22ZFrw-lkp@intel.com/
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---

Wondering if we want a Fixes? If this only fixes cocci warnings I guess not.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

