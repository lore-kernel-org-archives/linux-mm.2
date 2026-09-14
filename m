Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37871C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 09:46:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F7F96B008C; Mon, 14 Sep 2026 05:46:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A9186B009D; Mon, 14 Sep 2026 05:46:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 399126B009E; Mon, 14 Sep 2026 05:46:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 156BE6B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 05:46:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4A155A3B69
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:46:16 +0000 (UTC)
X-FDA: 85211887152.05.60F3E17
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 94B56140002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:46:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PoSdDPpd;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789379174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/w/yGurtybehOwgo3KZ5MtwGNopaX2l3ZWxQhrI/85Y=;
	b=WzI6cBtTvXuFjW2vSV10UkxVWT9O7JRr48ZoK+VyWG7W7Wo/IRmJcAEKvWP5T+whEZUgkb
	cc+mRv3b2buFavC5lt1rovI/fMGpo6nbZJeQ8CxqPY6N7xgTaSZV2Sn4xBAQGwl4WhIUnP
	VjoWWVXYEOE2wAwx/o91uM0tyGqXNpc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789379174;
	b=CSquOi0FVHwmyS1tNG1Wltc/qVqVPxTIFEojXy8A7Iay+EbYAW9DPK9Orph2MQygdqdwcD
	Wv/ZST9wI4gaWEtsB47oDEFaqzr55kI792JaYRr1z8jDWKDRI3baHgzqTaxYI5fXWlzKdl
	2Ly4rfwv/I+ldJuXtqxAmlNg5I7bcCY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PoSdDPpd;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D75FA4123C;
	Mon, 14 Sep 2026 09:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BEDD1F000FF;
	Mon, 14 Sep 2026 09:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789379173;
	bh=/w/yGurtybehOwgo3KZ5MtwGNopaX2l3ZWxQhrI/85Y=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=PoSdDPpdW32kxBczwsKCrd5toPOsoIyhPcPK9FiUfGkj3x5y0v+SAosM+sn1cnDum
	 o25n96uPkUuGm029v1FSIAaIFNGwsKSE8Vb6kK4Y9yyJZh7yChPVBiR2j44yBszqy6
	 JP0a6pKr6Z1buyENK3qx0dh9Qki64F5P3Tyl3hply3f01IVFpKWer+YCMfg4w6zJGN
	 Fmoe15bYffq8L4eom5ZuV/gKwhuM0MsDYBfgReyUMKCHel9Dj7DgtQN006rLmQRQQ1
	 Y7oafEqq5E/ldoHhGaj4k0iKCxD62L+jMME8zge0K3eerMm0gKFowRRpt1FAJwlFYJ
	 yP44ZVUvsctfw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 08/12] mm/sparse: move __highest_used_section_nr
 handling
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org, 
 driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-8-008fc8d579fe@kernel.org>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-8-008fc8d579fe@kernel.org>
Date: Mon, 14 Sep 2026 12:45:42 +0300
Message-Id: <178937914266.4188640.2229667310976793135.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: 8jus9ztw68qtq4nwn7y9h6ugeg9gfxo4
X-Rspam-User: 
X-Rspamd-Queue-Id: 94B56140002
X-Rspamd-Server: rspam03
X-HE-Tag: 1789379174-924806
X-HE-Meta: U2FsdGVkX1/f+JXIwSdutqa90r1X5kTcMvkWI51EyOh5UBiYhpa4ZTCiEK8aLsPr6NInU9LiuSY2o+kJUPrCVGjyCrTeqBciirAYX1pCF1aZ5ARHd1bUiZXH8z8h1FO2xjr71F9uVeqKrv86uF/XfUYL9kRlU/PFWq7BERR85cv22D5nCmNwpVknGn5cBWWC84ntXI0ill9u2j/sA49quLMlTgqXcJlhqBck/WP8sROS4ZLE2tOExKTY0he0sWDKKz0FiWCczSkwsRl1RWUu0YVcdsGB0qYBQlYp52rHQzb//4b1v6M2KmEPUnfhaWAJhca4eCDt3bAZ6fm87BptOmKHtU/FXkXWqw0a+hBV/Sn17gqQbOD8r3b+YGKDwGr7iabqpWwjVCeEGtxQQ2/F+rMxZmD0UNhK+zBSKfqf8jnmpVJE5WFVL6sSs7wGMcSSzxKLdjJ547xdmaQKpAVtXr596x1IXEqiROMpar2WIXbda8oNabayDG11KWmA5iIJDz0cVLa9i3tkdnWKff3rbQsxaDWmeoeJgwUBsLYod1ltJMbfWHX3AbZKND89JodRecDCo49kDXr34OIa0BbQzrbaaBsVgG9zK6h3BJR3dS1dEgELq3xgQbgXs/NawbuTD9X13hr6To3YuF88FejcOwmoBrVmRIJdoZ6fCirE0nXRsfSFLRzoOgKfElqNcGLOTnIR1TeSmQIcTUe+pC8XROBg2lG+fPO1c0XNDBwU5gtriER1CK8I29U7qgNLbIqTT96bmOf7Go0wN8gsNlnPcKtZDGQS3JOND/glWf7hDAce7wlhtfnJvKa7LeqCUlFvJONnGeiI19zPiT2HG8l3wovGu5hjukJL1ZGVPl7hj1uBVaVnEdMVN9ro7GCfSlfAHIKWudIvJkemEDadfkVnB7IY/CqIa4fr0hNH/bVYWE01bmV/MmUSbWboU84Uzn2I6UzOkIDwuQLX5fHAtYw
 HjKtivok
 tqSTe78AuTdLV9joauWnTtvIZwEWlGcFTs8MGGdzjV34pPanwgaO6U4ZtwfoxkewgiaXbIi/AFiySrSJv5H4FdItHjbenBWRU4pSQiBX9Wh28T8SlQsOYVLqxPDZCRQTRA9vKkK/vAfo0cmTl1ltIb/bzJ93+C3/oIkmgfuXH7TJA7XJsHnkR9tGiZ2EfESxcLVjBdicZvTaXboDP4pdAc4iQ28HxYTs4rjPVpvIBuuaQX3Re2UGCGc3ktuo60czpd0KLnQuxXWmlyCQwGvIGUKk/g5EexDtZXYg4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Let's move it to sparse_init_one_section(). However, to keep early
> boot processing working, we also have to initialize it in
> sparse_sections_init().
> 
> Should we use READ_ONCE/WRITE_ONCE with __highest_used_section_nr?
> Probably, something for another day.

Surely not in sparse_sections_init() ;-)

> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 2b41ae36f20b8..2d0f2db34f4cf 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -177,7 +177,7 @@ static inline unsigned long first_present_section_nr(void)
>  
>  void __init sparse_sections_init(void)
>  {
> -	unsigned long pfn, start_pfn, end_pfn;
> +	unsigned long pfn, start_pfn, end_pfn, section_nr;
>  	int i, nid;
>  
>  	sparse_extreme_init();
> @@ -187,9 +187,9 @@ void __init sparse_sections_init(void)
>  		mminit_validate_memmodel_limits(&start_pfn, &end_pfn);
>  
>  		for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
> -			unsigned long section_nr = pfn_to_section_nr(pfn);
>  			struct mem_section *ms;
>  
> +			section_nr = pfn_to_section_nr(pfn);
>  			sparse_index_init(section_nr, nid);
>  			ms = __nr_to_section(section_nr);
>  			if (ms->section_mem_map)
> @@ -201,6 +201,7 @@ void __init sparse_sections_init(void)
>  			__section_mark_present(ms, section_nr);
>  		}
>  	}
> +	__highest_used_section_nr = section_nr;
>  }
>  
>  #ifndef CONFIG_SPARSEMEM_VMEMMAP
> diff --git a/mm/sparse.h b/mm/sparse.h
> index 7c5d82ceb7142..a3af4967fd5c5 100644
> --- a/mm/sparse.h
> +++ b/mm/sparse.h
> @@ -97,6 +97,9 @@ static inline void sparse_init_one_section(struct mem_section *ms,
>  
>  	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
>  
> +	if (section_nr > __highest_used_section_nr)
> +		__highest_used_section_nr = section_nr;
> +
>  	/*
>  	 * We encode the start PFN of the section into the mem_map such that
>  	 * page_to_pfn() on !CONFIG_SPARSEMEM_VMEMMAP can simply subtract it
> @@ -114,9 +117,6 @@ static inline void sparse_init_one_section(struct mem_section *ms,
>  static inline void __section_mark_present(struct mem_section *ms,
>  		unsigned long section_nr)
>  {
> -	if (section_nr > __highest_used_section_nr)
> -		__highest_used_section_nr = section_nr;
> -
>  	ms->section_mem_map |= SECTION_MARKED_PRESENT;
>  }
>  

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


