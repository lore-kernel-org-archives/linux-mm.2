Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3C95606A321
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=DQhjO5Sr
Received: by kanga.kvack.org (Postfix)
	id E05E36B05CE; Tue, 27 Oct 2026 08:21:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDE016B06F0; Tue, 27 Oct 2026 08:21:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1AA06B06F1; Tue, 27 Oct 2026 08:21:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B1CAF6B05CE
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:21:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5A101A09D8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:21:10 +0000 (UTC)
X-FDA: 85368315900.24.093AC0B
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9159740006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:21:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=DQhjO5Sr;
	spf=pass (imf07.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793103668;
	b=DcV0OqT/PaiBeTqIW7Qw/4b9uAGVU6aOunoMqElPJ+THNublbemnzhdOAretqcTpVvGEq3
	hYpLHbd6wIkWl+tHYjApSeOsQCFC94Fa/Z5rxYUoX82FgKtS5jZi6WjOOTnwxiwf/s+NWt
	ZDpl4mP9jTQxXmqEIqxGhpccJc0lh/g=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=DQhjO5Sr;
	spf=pass (imf07.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793103668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fpqousJYIlQZ4Y3NCFJMRs4UmIAmFoTsGgfAJYD4+7Y=;
	b=cNR0f7sHZC44IXKijd9fV9myM+3dWhoIDDKVi/+zi+kK/W2Vzftbcm5zbBOK+2tcq1Hhsi
	mWZygtZ7AEK7JZMPs2Wirmu2E/np1Lko9rT4guHA/8Zwl8Wpc1E6mliD7HYWsauiBfwJmg
	wDKCR9UiKAGfhkyGl3EtlWDpYML3SaQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793103663; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=fpqousJYIlQZ4Y3NCFJMRs4UmIAmFoTsGgfAJYD4+7Y=;
	b=DQhjO5SrN/mEKiK43o+b173HaGW7RC2cfhyryD4U99KMAgD1Q6uwbzirqTPaQ6Ygy99puyjLUPbw26LIHl5zoZWqcB2BU91CkV6Le64soUbLJqMmtecefu5z3yvV/iw+xDnf1PJzYDHqrkqe2d3Li/Hcgs9mesR7CWZ5MtcuPgY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R541e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=xiangzao@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0XDdtXlO_1793103651;
Received: from banye.tbsite.net(mailfrom:xiangzao@linux.alibaba.com fp:SMTPD_---0XDdtXlO_1793103651 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Oct 2026 20:21:01 +0800
From: Yuanhe Shu <xiangzao@linux.alibaba.com>
To: "Garg, Shivank" <shivankg@amd.com>
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	"Huang, Ying" <ying.huang@linux.alibaba.com>,
	"Kaitao Cheng" <kaitao.cheng@linux.dev>,
	vbabka@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	ziy@nvidia.com,
	wangkefeng.wang@huawei.com,
	tujinjiang@huawei.com,
	mgorman@techsingularity.net,
	chengkaitao@kylinos.cn,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	xiangzao@linux.alibaba.com
Subject: Re: [PATCH] mm/highmem: refuse to copy hwpoisoned folios in the !copy_mc fallbacks
Date: Tue, 27 Oct 2026 20:20:51 +0800
Message-ID: <20261027122051.1234963-1-xiangzao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <d1de051d8c3150df7dd0b963a51176e5221a2006.camel@amd.com>
References: <20261026025724.1430747-1-xiangzao@linux.alibaba.com> <d1de051d8c3150df7dd0b963a51176e5221a2006.camel@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y8ktin6oiru8wnfy86cqj9zj7xjrfuq5
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9159740006
X-Rspam-User: 
X-HE-Tag: 1793103667-168664
X-HE-Meta: U2FsdGVkX183HYOEHavW1Z77tknjGdLPkQiEgIn6vlRW6Mo9uuUjWxFlZ7LEEfq6ciR+TaQpoa2fcV+uxsSxzv9B5TvMkHmnRUFGrB/tJLXaCrI5HpOwf1ma3u8G74PvwKseDbrGOu6Kuv6445AWkHsa+dwJF4H3akwXtqTylI5MHTwz5ypNokokvxsMzGykzg5v9gOZ/HuUjn4i88CJSF0Tissx5i4+qrnZpyxPcCRFBoA6R3AQFqDnwMw4tupnLjnK/VtzRmE5RpiAX7NearD6od9xUKi8/he8R6pBQj6uBuMyK+JIewLGaoBDlJ1kJRS5jGpxXCg3P4lmrgvy81RtwDD2Je1hN83ppReaIeLjhYihBuAUDZ6AAJU7VE6tpvyfdzReZr9KsJSxMoWCVwPTqm1NF50Zx2vCgVlrLkpGaE2EuRtNS36eQ0vcxPFNuAxRy8K0WP1aGdmPi35ubb7RRHQfo6G8S4xxAxKBWwBtSPLS67fdw/vHYn/4S/stG6LrNSYDy1iQa9rsGikqc/bAB5SjIrgItQdwU/y5tCu3YJj6hZYaNxoy/4AlvWcu3pU/sSibyD3m8ymg5ainWysLnPNUTSioLo8KgJDi1yXncE7HYALWmIqNTgSt4whhr41Oc62YRhdW6CW4QnM70ZSSizu6heccF5MExBNFKkd8vufgz3m9zCNupMdkm7E5EWOa0b1Fzave87XjssCFYvEyC5+yWWjGmfYmQMQahBpQ1Fq6Qemeb6e/FN5uqrsV/cEG8DX5TmIND9um8ULp1jZscnwOu6oZobnoL//plbDrMjrU3yB7g3Vh/TNkx6sqDosWRR+45cXOU0YpRqj6CjWLHbTmJVOnuMruwlLgS3pLZJcgqXqJ8UOWSIS7U8ecESP2teGM52VNL5CZFyEcStnk8oc4QFXPxrmAczuKyWbEBLVJPMPFn3BKpQaWTFyxCrwzTl1E1LV1DA6PwdS
 48AcMjrF
 kpFweUwQFNK65NbOuYbWVPi/xiEuYzYKDWJuqaHRWo+/xrIkXTC9zXU11CKH/NKVg0JpLE83XUInQberJX7UZwkXPIlS3xuR7INKRG5sxSH/mp4MOKPu1GKX372I7krY8Z8xaVWCkNYuwmGSB/Hpuu3knw/aBM5Rlw4wkdjdAQLmP+rRjz/NJfRvQInbgbKvkgvuegrUiCdX/GEP71AYnNlkqTHS9OWDTJE6Q+o6qxeaxeMBraUwC1G1J3RzPWuQ1I3dNm05FyHWD+9ukpe2gIV67AdftTqTA2CxW+DPFi6YLi2Lr6rfBp5d+ATHHh7ygHoMzW8BtyozLWFd8Rb04zF+P0rv41bB3RKIq9vCOmYY3dsUvqjnd+qqRqWkFld3xOwZq0Uwbs1hZ7HTsqr5gB+aULOOX7pLgMfmq+oHfWjvOIiE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/26/26 12:10, Garg, Shivank wrote:
> Should we use is_page_hwpoison() instead? It looks simpler and more
> reliable.

Agreed.  The next version checks is_page_hwpoison(from) before
and after the copy, so the race is refused at the first check and a
flag landing during the copy at the second.

-- 
Yuanhe

