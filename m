Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23BB0CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:13:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 684CC6B0363; Mon,  1 Jun 2026 08:13:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62E1F6B0365; Mon,  1 Jun 2026 08:13:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56B6A6B0366; Mon,  1 Jun 2026 08:13:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 483B86B0363
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:13:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 16EB440671
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:13:51 +0000 (UTC)
X-FDA: 84831235062.07.9704978
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 74321C000C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:13:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TZRidC+b;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780316029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gaM+ZFJskzkNMbbcD87GolPGXRySl7TkoUIMe8nmQIA=;
	b=cmHJW5erBKUSKuJzQDoR0SsR+iLSrzwXuX15OMD/rSb2rB279+b0XVtiw0a4+11QXyV4+n
	ezEnnqP/1O95O5MPehGD/FC4/pZobQ4x5TBnFHHncCa+NP+DWdbWK5D85QsLO81SWOFtN8
	sa66LMJACftfNa1XrjO5uhieIUY1iFU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TZRidC+b;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780316029; a=rsa-sha256;
	cv=none;
	b=d1lqtlhatKkFYbKcce3+2QZlzMBZXXx/EyR4RMHU0D0mriI9s/d+xmYfcMcAkqeCVRNV7y
	BojthpEi0u1r8vyi20Ig3LfpZcCUzVPafY+2Tg9LbEjeT0QTpBOkBUEONSkP8NMBqS/o2a
	Zaj63fraxp7va4ylsY3JYhvrkcKG8c4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0894B6001A;
	Mon,  1 Jun 2026 12:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A6D1F00893;
	Mon,  1 Jun 2026 12:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780316028;
	bh=gaM+ZFJskzkNMbbcD87GolPGXRySl7TkoUIMe8nmQIA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TZRidC+bBReXJGOIcRAhgNYZKdunkQHNqsS0wIaZG1Dn+0uUah4zNhkJI5ij1HBz8
	 j/+nZGpF0hlfdnvEhzrjwl2eMlp+3u99zYxVmjap5FdcbUBr//gLi8urfuKgNKlrhf
	 zN+Vp1KY6wnnYQmVD4dM7yqP0/Su6Nu8X7XyW0cGPpdOTHIEk+Gx4yit866+HaiCYO
	 EM1rnO1ombQ8wnwmlzKuysfVAT/vzYpGpex6xGbD75sQcqFTkF6I095qzfDP8x0dzP
	 jscWS2XQYSNgg2sWX082CGZLzVO8ydUGmCIyPhGdMbiIOqJ5+prZqZRI7cONCDQ2uL
	 pmqfGtuAYsFzg==
Date: Mon, 1 Jun 2026 13:13:42 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Christoph Lameter <cl@gentwo.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: delete stale comment about cachelines
Message-ID: <ah13Y4KYISpkkLch@lucifer>
References: <20260601-zone_stat_item-comment-v1-1-f452dd91d5eb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601-zone_stat_item-comment-v1-1-f452dd91d5eb@google.com>
X-Stat-Signature: 73x8pdum3tjxdjgx7ouz5x673j8fpdtj
X-Rspamd-Queue-Id: 74321C000C
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780316029-359477
X-HE-Meta: U2FsdGVkX1/HLVLDeEqKZ8EVt06f1t8z3rUOI5xyB+yeFaVSeTyFRvAEyTY55V52Zk3tmsVNVlJbc1khIQgxzqr4v3jvSShq97oDVFwt3ub911VvpO08yA/wx1lNigVxD4rtbuuQyidqFdvZZ7qoVQjomTkuLR9ajklXT4NDbt4QNOcmkLtXWlxBJEHwlD8FhduMde4Vy822NOObvQpqxAJJYVXgwPmIWfF+U/WL4ZzpLo4LqNv1TeGK5ckO8+N/TaXYp0sOSsiycFWalkkiLbyG789VXCROYDM0xTCySDAyQvZ90i8I3zNLiW2AdqeudfJIWkdZh0mmTUXgjb4L0aIlaX02ezkoSemhF01FwThWTYgUcqvktwQFiOj9S1V1dQeabGkhztMmVHh4UNYB0KBvBSyYXrQAiJXsFLnfq8yNAvRqrB7J51Xv+rZgY1Z6KNYjkGpWpiWY08Sl8NgKz7gYRgQU21ssr9oZuLB2RTFCtACAD+kvSNPFRjPnUF3l4fQvhHunaxbTA4pnKCJHeoXlsGbz1HCMfeIR6M9FbWecAeW3QjJ8aRqX6K3wReVxE53Mg08UPKoE7X59yyt/JUzndr+4TBSJ8rwEoKCmlal21ybGwGrHONd3JDCS5i9LSvKLtd3ByPejYGFMPDr+GGRMWqDOycskK0ZWLg0wBRgtEinxhVhGwUH0R0VLJobE28lAIeTF0h5VJbkFrhgkYW1BMKcdYPAh2xzHxEAqRPC66dUU5YnELGBMDJ2V97+vuqAPY9U7ptnpPsw0ggwPTlRZKOKjr85T7wZLGZJ6CUpAIqzkwcFqIW1sTU1XyQ4ozyUwUfhHklZsFvWWncuuZJZw/1zkZvum81tryqXiimFDooxqGO/GgsZJ01YoRA+WQePEmahsB+6trZV+08nKPMhuVPnoDWmLX+nkTbAa77DbDKlHaLk5b4zyIk1l7I1J1X0Y/1YOx9nYBdVnJOJ
 8Px6SSfp
 rYRF5YSz40eu+4KEp1G1+NPrqH78EFk+JtaRsR1iSSzq/LeYD7x/esIkQqdJ8J7veY+s4Sc/eOTsgXKz/4OwcKOKWGx60L1P6hw6FUYajttfIXnNt3a/zg+hF/r3Y0OS9t0N5P+E5nEC9NFKerb3XCBFumSgmUmfDtEZwKPPvGangTXqPLRRsShbM/5Al1kMwJ40o4S1fqq3g1bvZdSS0GrARqJ0qQpuQbPhLmjFoI3H/gWdi5HPUF92qyZL9S0k/JJMbMxyhaFobkirp5WKG0a3FwG0JDnN2ce4OUMkLieYEsXY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 11:40:09AM +0000, Brendan Jackman wrote:
> These comments have been wrong since commit a211c6550efc ("mm:
> page_alloc: defrag_mode kswapd/kcompactd watermarks") added
> NR_FREE_PAGES_BLOCKS. Since nobody has complained about it in the last
> year, it seems unlikely these comments were particularly useful anyway,
> so delete them.
>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Ah, bitrot :)

LGTM so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  include/linux/mmzone.h | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 1331a7b93f33c..e308f5ac7950a 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -214,7 +214,6 @@ enum numa_stat_item {
>  #endif
>
>  enum zone_stat_item {
> -	/* First 128 byte cacheline (assuming 64 bit words) */
>  	NR_FREE_PAGES,
>  	NR_FREE_PAGES_BLOCKS,
>  	NR_ZONE_LRU_BASE, /* Used only for compaction and reclaim retry */
> @@ -225,7 +224,6 @@ enum zone_stat_item {
>  	NR_ZONE_UNEVICTABLE,
>  	NR_ZONE_WRITE_PENDING,	/* Count of dirty, writeback and unstable pages */
>  	NR_MLOCK,		/* mlock()ed pages found and moved off LRU */
> -	/* Second 128 byte cacheline */
>  #if IS_ENABLED(CONFIG_ZSMALLOC)
>  	NR_ZSPAGES,		/* allocated in zsmalloc */
>  #endif
>
> ---
> base-commit: 4aedd91eef75addec6eb2702aa0d94625d01458d
> change-id: 20260601-zone_stat_item-comment-45d660892420
>
> Best regards,
> --
> Brendan Jackman <jackmanb@google.com>
>

Cheers, Lorenzo

