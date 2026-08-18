Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B4A1C5DF67
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 03:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B7896B0145; Mon, 17 Aug 2026 23:54:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98F4F6B0146; Mon, 17 Aug 2026 23:54:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87EBD6B0147; Mon, 17 Aug 2026 23:54:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5EE996B0145
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 23:54:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 58FC3409D6
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:54:28 +0000 (UTC)
X-FDA: 85113023016.22.B65DD43
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf13.hostedemail.com (Postfix) with ESMTP id C755420006
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:54:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=eIPkgRsq;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787025266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VoCWHLN0b2TBHZx2AKnPa0V1F1II07CEG4GPygei01o=;
	b=1tamVdGIVi5i2nAtljhk6QL4G43hmFM3Fkpxpzz3fgFdIPF9u5bFYaPLtXsyT+CoRBRt4U
	I8NLe6c8zlSSebjo816vd/0YJoG8RcWN1TQN3NprUkqQdEqYhwNPoRQq2S/jJIsJPPkfQA
	pz/fahVwRiQNo2dmjVDVw4Oq/H3wqx8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=eIPkgRsq;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787025266;
	b=crK86bUda2mJf+ktbd5EiP8g71IAAo3fKtWhakuXli5bAKRQ3h8dKENtb6ehed+oTTxjxB
	WdgpINS0lg5fJcA1rBD5/ANjJkIfgIVfLXWcQLZWWnxW8MQn3xaycW+TgYlyK71wwBK/Jo
	sBSQzHrNuqS8oBye6LlS3AWTT9a8/r0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1787025262; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=VoCWHLN0b2TBHZx2AKnPa0V1F1II07CEG4GPygei01o=;
	b=eIPkgRsq47HtKi+cHjNG81pxUOqxIG1OVNHkJDCqAxv0Us0E9VXum0M1rt/WFEq3/bqw3Ri+4CDXcy/KU9b7CnUO9dxKDlRwhuq9/U02fEEcb8yp22fYIcj5nER4jn5pD/eXqYDjuUuwieQw7jbmaRGatnOG95ErK5SayK1rsIE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X9BvG2d_1787025258;
Received: from 30.74.144.114(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X9BvG2d_1787025258 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 18 Aug 2026 11:54:19 +0800
Message-ID: <5e409803-f69e-4f09-bb15-9c2a7e85ac92@linux.alibaba.com>
Date: Tue, 18 Aug 2026 11:54:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] mm: shmem: make unused huge shrinker memcg aware
To: Qi Zheng <qi.zheng@linux.dev>, hughd@google.com, usama.arif@linux.dev,
 brauner@kernel.org, akpm@linux-foundation.org, david@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1786955972.git.zhengqi.arch@bytedance.com>
 <94cc7fe1fd645254ae90effc1c0687678438d940.1786955972.git.zhengqi.arch@bytedance.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <94cc7fe1fd645254ae90effc1c0687678438d940.1786955972.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ntfxre5k5jrpnsqhzwfugdxoesnxubkm
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C755420006
X-HE-Tag: 1787025264-333561
X-HE-Meta: U2FsdGVkX1+45pDk1Fn9rSLqbnSdOxVOEYOg5lMABvWliKVOJLa4btN/EhcLSkMikAKfPjsE0UCnYdcdTW7MKv1+EHsRUm+nzNWxcN1hgoGqzXOKWQiwFL9uygNN1neH8zKE2xij6XbazjTn/1eiY61YGPtUjcHOAG4Xu0FDu5s2B6MHAi246FSBOgD7vw8U7ayhqBs5Uv91B4gtpprMsW6i6PQ06an660eQMebYsiaqm8Jg+Ex2jtJPe9YbSDL4N0wDXFf1GRzFflWzSIi6nrB4ipE8de3gR9bdRzacKvEo1b4PT6diaGyfvmMigt9sJdwUh6VL8OHKgp3S5ZWk56QmAD9Fey0gn3yDzquhomB14lNqDhfiW5gGPvseY/eBCGyyPcND2KsGvLuIQsGDuxArbtU/ruCe7AGCyr2UqyB6QHy0O0qeQaOE7oub57+f4ushINTu8FH6C8I2LtJdpB1ll0gQ8KOZjQ/1ce0oV8s2Ii6SSalBRaXbTdeUyk5IrF32gYDGRkCROWsX0Sa8GrvsNsalfQXdJf2jb/UyJA9APyhilZfXg6vB+9zF7soNb2LNar5ISjCp+eArJFJIDcjXYN3ZMcDqVsHHYeJL1Ipsu2yDLRuqkHoka15u+Es7+d00QI1BLDjGdRvODj3Uze3rpMQjRR2ZRLvmBvV9cx5RHsPTdyusmFnSj4hE2sFva73s5SSHPPJmf9/bb/PoORB9o/TNQcOULAzPrvH9p+9gHX124q0hicycKT6yurZcWL5/QKlzKxSyFC6BZ5JkjeIQBjk5IFyxQFTVOKyzjDZzPMuBOeQbdT1DfzucA2GGlOBBlfD8KQcS6SGEHCCUsf3oKLFcKH1E3JTCvTK5FwDrBej276Jla+1TFcV8bM+gTpp1b4TLg5PVkHS9BsEVWazaAoq89K72bx/D4Rzjq1K5YQvIr0U8yxl/etka9bwfYs1mltY+lVtLqZUi//U
 AmZl96KZ
 YOU/2MZ7RzHoyiJDXhwtXNTq/noI1Ymu9uFENLQaYrvxeWQaAC2PL8iZyipcs1buI77ozJTDSgxXBAfemjIJpfWk1sWbwaQpo+GEgw58knGZdsUqQ9598hxutibxR14FhIRaq+qdXACbP7NmClxNbHGVwyKuXVyGFLF5g871/bjoWfzHkCPzihWQoI16cJwAdpQ7ad19gBC50fHRgg51/5OL4cpkCQ4uhztfSCeA1wOaWAFGkjYPooSb5hCHj8NCYU5F3Id7LQU7Pt/SL/W6sHh8+ZyYjT01B6rO517OlD53uBjr8sfUMxRmT0K/rFgsVzQN3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/17/26 5:03 PM, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> The shmem unused huge shrinker keeps a per-superblock list of inodes whose
> tail huge folio extends beyond i_size. Since that list is not memcg aware,
> reclaim triggered by one memcg can scan inodes from the whole superblock
> and split shmem huge folios charged to unrelated memcgs.
> 
> Convert the shrink list to a memcg-aware list_lru. Queue each inode on the
> list_lru sublist matching the memcg and node of the current tail huge
> folio, so non-root memcg reclaim only walks candidates charged to the
> reclaiming memcg. Global reclaim, root memcg reclaim and shmem quota
> reclaim keep global semantics.
> 
> Rather than pinning a struct mem_cgroup reference in shmem_inode_info,
> store a struct obj_cgroup reference instead.  The list_lru add and delete
> paths resolve the current memcg from the objcg under RCU, so that memcg
> offline and list_lru entry migration remain consistent: list_lru migrates
> entries to the parent memcg sublist on offline, and obj_cgroup_memcg()
> follows the same reparenting, ensuring the correct sublist is always found
> at delete time.  This avoids pinning a dying memcg through a long-lived
> CSS reference.
> 
> The list_lru still tracks inodes while the actual split target is the
> current tail huge folio, so validate the folio memcg/node during scan. If
> the folio no longer matches the reclaim context or splitting cannot
> proceed, requeue the inode according to the current tail folio; if the
> inode is no longer shrinkable, drop the scan entry.
> 
> This can be tested with the shrinker debugfs interface by allocating 32
> tmpfs tail THPs in each of two memcgs, then scanning the sb-tmpfs shrinker
> with memcg A's cgroup id:
> 
>                 before A scan    after A scan
>    base         A=64M, B=64M     A=64M, B=64M (per-memcg count is skipped)
>    patched      A=64M, B=64M     A=0,   B=64M
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---

Nothing else jumped out at me. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

