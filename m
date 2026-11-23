Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EDD9606A6B6
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 08:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=TYs5lfQf
Received: by kanga.kvack.org (Postfix)
	id 9520D6B05B4; Mon, 23 Nov 2026 03:10:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 902256B05B5; Mon, 23 Nov 2026 03:10:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 818516B05B6; Mon, 23 Nov 2026 03:10:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 623496B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:10:33 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B03FA0861
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:10:33 +0000 (UTC)
X-FDA: 85465661946.30.0D624EF
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1DB2340009
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:10:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TYs5lfQf;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795421431;
	b=6yt97KogK0ievJ51Hs+ucgzDptVck8r4Pt6h164aPSLmI8TXE1T4Eby/S27IgLrQOLDo3a
	+lTYhkCRar41v8w6K9nFt8rdRHhL2RimSSazF9OHSJFIR8ZqTnMw3hT9cYU73l1EIYnHmJ
	8crZL6JjAUkh1UUFgAIMna9olMaKdik=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795421431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=io+R8nylQ8N0ce8qGKxvEayHLfY/AXHUCgLh+o2geRg=;
	b=6IxvTMQtBXp3xp1YAX9TekaqzD0tWJIzR7rm7ecm+sGCyO623g391vupyENjhod4kCl3er
	Hpn1eUyw9fRl9I1wAO4wta93lTkrTvzpOCmi3oNnNVJ2fHVa6xoSXHl+4UUszirfjx9bXj
	DObk2x6dgV+1dU/CfccRrDzzUlKG7Ls=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TYs5lfQf;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795421425; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=io+R8nylQ8N0ce8qGKxvEayHLfY/AXHUCgLh+o2geRg=;
	b=TYs5lfQfGR4PsAOPSC5x+bwbgRtsCLUT9abM9Ji7b0xhBLTYFGmZQQDbLct76XGZN62dPTpIUovXaoRu97bVh7Gwxn84qpMhB2u5oQ73Rd0n/QvoAZVe12l8l6T3AxS+HmJQuNhfrz80jAgS9zTSuFEBGgM5o4aYhrqT7yK2cJc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XFFKcI._1795421422;
Received: from 30.74.144.153(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XFFKcI._1795421422 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 23 Nov 2026 16:10:23 +0800
Message-ID: <8ff56e5a-498e-44df-9548-604909d4b84d@linux.alibaba.com>
Date: Mon, 23 Nov 2026 16:10:22 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm/shmem: don't use the memcg of an uncharged
 folio
To: Chris Mason <mason@kernel.org>, hughd@google.com, david@kernel.org,
 akpm@linux-foundation.org, qi.zheng@linux.dev, qinyuntan@linux.alibaba.com,
 shakeel.butt@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261120195057.50031-1-mason@kernel.org>
 <20261120195057.50031-2-mason@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261120195057.50031-2-mason@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fpxooddwm5afb3nppdyj8qkd34f7qd1g
X-Rspamd-Queue-Id: 1DB2340009
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795421428-765381
X-HE-Meta: U2FsdGVkX19hesIKFrf6YO4idCZkv8RdsPW8Z24ghA11gZYYudAxjOi/m8wk/9ftEo8ixHSg9CkbyjREw//c7EsWUTGEOZgtMiH/K0tgGvvQhyRfgHxltR6cLikYjk1rsUpTNFNE8UygXjDgDK3HoKjvRubBQ4sdvkzCIQiCI6MO+xAFMTU5wQl4NxIiHVvEODes+/HSncpt4KVEoTQHt785lExrbT+Ts+fBdtD7WzS7WFLx4BMc9TSMuN5IIusVGiFCX4P4SzWDkScS1cSh3uMDg6F0tsfZmoB+kgyzMd76fERJs0k6eYEoWmHAATs0bDBogu838MiZ9V+9UBgV4rOD3nOQm6qie0/wYoW8xoFbqREmmct55D7+84mpuUWhRIxGk+0Qxye0FDkgBHy9Utq8dJ8nLHmhBEgYk2a0GoJsLULaT63Q+RxS+BfQ5ET68/qOXPjB4/ws10pTs+QAmRkB48HfsainCpAtL82bs5cWbfHH88yZBLgAze5vQ5+WTnk4nfJdgI2jtfnEtNnZSU/h/kn2d4dtqRbGvkKESz/jnDrI8YdaCWZxSzQeWg2hubn9FNQRPLhmi9jmh8RhWcO5PBi7Vfv/IzxueQPIN2PepSyX+Wb6QG5Jel79izZT+k7hmneiNZI93YA54z5YsMFs0j/NnobcrlwNC9u8Jw+Q1lXsshbptYkEqWHuZdJ0gsAoMYdaCv1hGTQFaIExQRCol4NCP8KM1GRzIPMBcphDmNZqQsSPDLKJxpC3uoObMM4/c9M6rDC1L6b2JoklLw/CI2o+dYJOd1VlT9slZX7QalPkBeIu6uJ8X1mdklicZN0eypHtcDucmJMwvSfwiDOkM+8lZQNZrh+dVkZRaD3bcDLbM1Jp9M8LQ1PlWViUD3dC8DNBUedffkwfAxC7Y8sGUauZ+riUBZ9xVmmIekPXnEMgBQLOIn/hPCgowcIONg1iYSIwO/b2AaaKOMp
 dwh84ATq
 H3oVlhMq2qSfW5ERRMN7sXpBBIDpVwqJU29ffwLyVWtt88jRifCbl96muQaCZKQZ59jB8RRCB5n9yU73Zxldax6lFlVXQRZWCkNJ4zX9PzkjIq3wmCKAMqKOqwYSeWiwpsbKtWSj2Tw7u6xZ2+orVJyJUrLVpwxav3w+ec872fP4bzOMvsHVzYqkBpqFXkHpqAghVYe/vhaRidUQS4ZDpyYPmum5kFP6isDS/VJxAyzdEdsu0+3yjt/9IsnZKaiNwQhcbdRqJiW5L1zcP3cSwB2Jht0YJk1ZtT/7OygMdXVwo+Cx75ntl50lya/1Iw0Qzt8Bdvq3qApdYnAsRCv7BJkX+NdNRtAAAMQfQtp9pPrN+np2ibGR+gjhHzRbxuKk2oe6E/MURGBbhJQY/mvPZ2+WUzdfV0LxFPddvOTDCsFMzF3q5E/OizjsglC+YUyZFSG8P8K2IkddZGfPqICmOwCvJ+mKpe6JXrHYZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/21/26 3:50 AM, Chris Mason wrote:
> The shrinker for unused huge tmpfs folios can dereference a NULL memcg
> if it races with the migration of the folio at the end of a file.
> 
> folio_memcg_list_lru_alloc() assumes that folio_memcg() is never NULL.
> But it is NULL until the folio is charged, and a migration target can be
> in the page cache before charging.
> 
> shmem_unused_huge_shrink() looks the folio up without the folio lock,
> so we can race with migration:
> 
>      __migrate_folio()               shmem_unused_huge_shrink()
>      =================               ==========================
>      __folio_migrate_mapping()
>        xas_store(newfolio)
>                                      filemap_get_entry()
>                                        returns newfolio
>                                      folio_trylock() fails
>                                      shmem_unused_huge_requeue()
>                                        folio_memcg_list_lru_alloc()
>                                          folio_memcg() is NULL
>                                          memcg->kmemcg_id
>      folio_migrate_flags()
>        mem_cgroup_migrate()
>          commit_charge(newfolio)
> 
> Fix it by keeping the original objcg around while the inode is isolated.
> 
> Fixes: 743e7d025d2f ("mm: shmem: make unused huge shrinker memcg aware")
> Suggested-by: Qi Zheng <qi.zheng@linux.dev>
> Signed-off-by: Chris Mason <mason@kernel.org>
> ---

Good catch. LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

