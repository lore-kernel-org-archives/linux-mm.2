Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D4DAC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:46:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 085B06B00BD; Thu,  9 Jul 2026 13:46:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05DC06B00C0; Thu,  9 Jul 2026 13:46:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB6FF6B00C1; Thu,  9 Jul 2026 13:46:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B35946B00BD
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:46:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3B8451A0248
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:46:03 +0000 (UTC)
X-FDA: 84969966606.17.9E4548B
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1F1FA40005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:46:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=DTF9PLtJ;
	spf=pass (imf17.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783619161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ARkFEEgQKbrHJZpn11PfpILDbZ2rflYjxDUaqEPQFVE=;
	b=AneQfofPi9yigfZvilRUMTO4GzOwPXLmLTHlx48JW9aezzE0DrfqfU4S0RuNS+oIEl76jk
	8MPYjPy0Bu+PqFqqPygPyuaWp2sT7lhScwa+gpLQy8IsMTChoYHEEcykUGpK++9L0UwB/W
	+FPlijpfRarjRsyPAf90Tp+pGApTNNM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=DTF9PLtJ;
	spf=pass (imf17.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783619161;
	b=1yDoT36KgCYuu+BCEv+j99L0wIWCmcHDLBqDl1aiR5Jw4WAHC4yVfin8Fk/tjhiZVtPoDJ
	uI6CJHdjuauQJE33yNZQG8sV+fSqMzhaq7JMhJ4HF6YJeOh6Itvq7e7kcfe+pG5bC/mevB
	0O1ACmXFcmB26tseKCNu7XlrjPF6FH4=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51c5382806fso339761cf.2
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 10:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1783619160; x=1784223960; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ARkFEEgQKbrHJZpn11PfpILDbZ2rflYjxDUaqEPQFVE=;
        b=DTF9PLtJJjeu2CvEuLDkQehVcTorCLDij2Tv0beKCa9x7z5sHKFWlW9vtiYcJ4Fkj1
         KXWUpfcMlVtn92Rbitnw0OyGqZh500e8Xu8BPcuT9a5wRiB9hz7qq/8OIk8OjJIsjvt7
         M4MxPoSD3t60bSxYklqVChhgMCRGymruXdv25w5WESUlrIxxMZQT9wCJeVkHa1qfcdHu
         /OzmfI283QuNcyBMfeLd04Wsas5T2siijGHcNHeU1LS2nY1kKq3sPltIZ0YtswqlY96e
         OfkDlwz7L68pkDh4As3DmOTaT3sG9VJeleK0/KzXmgqikpUoFk0Y30iCa50BC7AKZgLK
         aAIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783619160; x=1784223960;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ARkFEEgQKbrHJZpn11PfpILDbZ2rflYjxDUaqEPQFVE=;
        b=p3/ZuL2mroJaNUpCnbkjcGmHfApdPz3PQPqZPly8qUfwKXxLSOfmAvWsyh5bF0Fh5Q
         QgiZLoEbb5wdtYuVvybOW7Xf7La+I5kQXB6JJMGxkG9V5kJ/eXBSZD/pOjyECiIBTkIG
         y9XScCpbefFxpdJUG0+h3XP9I2qWx/HDALch7NU3nBvx/1T5JzuEuYyYLjmw9hblpcVp
         X3wH/AoRx2k1Mzdoh2/HViqGeuiB1bBpTgK4/qB/IQOt4fuvMW1J/mDVme07xNqBSoXM
         Us+u14rfawsgfLS/qbM2SeGoeJJurNvEGDP3s5VipeZm1XcZoAW3vQHcb7/t35D0YTjy
         TtQw==
X-Forwarded-Encrypted: i=1; AHgh+RqQwdFRFvuQ57Eu5qerHtP3CKbsLRgBvh+vD+k0WLggpDMeT/Rr+E5IEFsUgIfpuC7HylkQmNUZVg==@kvack.org
X-Gm-Message-State: AOJu0YyZchvt4IOPZl3ztZbg0xUtjgOOjRlAIkesQRm1RjDA50EcsVRb
	w7USucs1Ncr1N0+fxrqYn4tbbpqYYDFkhe5rRiXXQU16/L9Vnz9560T75AlERUCA8/8=
X-Gm-Gg: AfdE7cnLS4TN7ChXlXUXIwTN7Xldz7yA2uiPahhbcFfFXOMgXYE+94eMrgbhhqKKwUF
	UMzpcPGjE7ljmx3AD988SJnmg6C48TJi5Y4tKSOggERoYwG1RZN5Ku1WoW4nsffnSmhT19w69mS
	aW4zJomxRRTRPWmAHqdTfhAgoBCduDmlSy4Yp5YX93vb1VojygfvgMawHpqTf4xtSrN7IOWXtyU
	HBk74HTG0Lj4tcw19TYNEiI4zHjQshDwEY/HEJi0HzorrXekVyqOkn2Bmtskwzl6+QrD2T5UMbR
	bCkJkHfHhw4R3aJVOmTpHj0j71J/nGj4hdy54RlAZbmv9MM4kjbAVQQGNufJgl68+7baCdjTyc4
	u2Sw8gCQPXRbA2CS6Ui9m6bJDASw8rdLFNKx96rOf79CXxfWAo9flzjEkK/t7kMb4sJ2StNNjHx
	VfSsSmC79RXQg=
X-Received: by 2002:ac8:5741:0:b0:51c:1361:fead with SMTP id d75a77b69052e-51c8b4160c7mr98674671cf.37.1783619160101;
        Thu, 09 Jul 2026 10:46:00 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd50df5e2sm22716566d6.4.2026.07.09.10.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 10:45:58 -0700 (PDT)
Date: Thu, 9 Jul 2026 13:45:58 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] mm: page_alloc: move capture_control to the page
 allocator
Message-ID: <ak_eVpT_SpYytSSw@cmpxchg.org>
References: <20260626182215.1107966-1-hannes@cmpxchg.org>
 <20260626182215.1107966-4-hannes@cmpxchg.org>
 <c11c73ba-4422-4ef1-834d-6cc230146dea@kernel.org>
 <akV_VwtcvUN7Mq16@cmpxchg.org>
 <e63acfb5-c9d6-4e2a-b44c-417ad3a15b8b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e63acfb5-c9d6-4e2a-b44c-417ad3a15b8b@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1F1FA40005
X-Stat-Signature: usutj4ct4xgnu7n7h6zaccgpm99gx38x
X-HE-Tag: 1783619160-193325
X-HE-Meta: U2FsdGVkX191VPcJcFOH640HV5oMWX9DM90MNi0wb+vSOuqbucy09g5Hz1nprtvPIkUe9wohdi7HTE+5PLbk0m/ArkjcNbQ8Uj36QTa/pZ2z/9Tp1hT8jpzo0hQxabkANI9Nwtaf3n04zagbMMon+ik0s6swm0t5CDzvFLVZEFLOo40A5WF7dNJdP5VDwzDBU+IO+zS5Ffo2Mly8xVA7HG65xFWZTgGlqREHC66XdyrgArnIMZvAtgPx0nSrlQwdS1yrFiZCaY3wlzvDG/lxK+Rbs6d+KBHDQK2W9AREUm921qklMczzil+pGjHqjggiXQnGHh1O6LtmWjmUr+4khIOxEKi+6Z8bxBVZHH9/f9ERijZjZdraGv0rfiypW7Ira5Ml5Cg9zxcAcgNotnoMnQHXxwdADn/plVpvkv8nPGmgoqn08OwiQarWWj4EcRCKMmKHvlDxldwwMCqtUteIXx6jXtf3+dtc2PYvVUnxUBMHDfafI7hMSEJMr8WTUA++lRZm9YaIpifl73DrBAXwF7q5NXD0c70WN9mwIZTURaE0as5+lFwvs1p1CyXeT8egnacZBOf2sqUonaz2HKsnN/cc0TU2KYSbEQm4ylwxNbgSlqdWk0V/1dGg7fiNCk1iQd7Ebz8ZJALgmPlC1rMSBv/9KUsTE5De3cILN/4UlnWQGqiFyLGnyeqPiw+sv/yOLHsomKP75ZFrwRrNLAaefE0sJJ/TlcM7rr3C+ogdbQZPIPkvLHLrwvVWHeuRwvvX3TXntSSLOAoxVI/U4KWojGjqW4G9WDXOf5MDmuDaHe8fIP5diH8s63LAHiq5h7hreHpHWI0LdDJWXmxwQnnSU4g+Hne3wtS0kNW1tMO05QZDqwHr41Dj6jJpptqGa46CAO+LvJx04GJj9c+9HW/Gc0liCFTdqPkAcw5ZPmSAXFtPqUekWL4hUf+yf4c2SqOaY6wa339R3y51poi3gPs
 WLpF9dBH
 AMMlQODIudQfshX/SCnXp3NU/vPpMPoDd40o9NntZHSqaU7jc5pX6qnkBo3NkQhRQ9R0I/iQgtEhzXT1BdwIq6aA1YPdfzXbCS2KjVJPuo8kA4TdCLT5vmob7by7N5WcoqrAXaLPjT/Pu0cu4PkQtOzBt+A90EEY6GDb6yw6K1fb62ZyhumyKT0MVKD5Sr86UykvbS/95dDccxmQZd9C92wxBuXP9uOltiFTouW5tFQgWm7Dfk+i/vJWxD42ETLiw30WOIH/VgpVf0QQ1Vd73YS/JHH3WcKKdScTXI4/5YyY5OVXoJMeuxjpBlsSbwzkobo6XDRXElhq3POdO9TuRRH3rBYqoiDDJ1w/DaGZRBNWftEj4t7q83JsvTHruOMaRLbKzEa0Ji5LUHC7lZRVjIiGARhcDncLIZa5gHFXEjDNTTnvrgp5p3SDJPeltSw5GhGRF0L+4nlZVr30=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 12:20:48PM +0200, Vlastimil Babka (SUSE) wrote:
> Now my version (only compile tested):

Ah, now I get it. Thanks.

> diff --git a/include/linux/compaction.h b/include/linux/compaction.h
> index f29ef0653546..66a2f70e9e01 100644
> --- a/include/linux/compaction.h
> +++ b/include/linux/compaction.h
> @@ -58,6 +58,7 @@ enum compact_result {
>  };
>  
>  struct alloc_context; /* in mm/internal.h */
> +struct capture_control; /* in mm/internal.h */
>  
>  /*
>   * Number of free order-0 pages that should be available above given watermark
> @@ -92,7 +93,7 @@ extern int fragmentation_index(struct zone *zone, unsigned int order);
>  extern enum compact_result try_to_compact_pages(gfp_t gfp_mask,
>  		unsigned int order, unsigned int alloc_flags,
>  		const struct alloc_context *ac, enum compact_priority prio,
> -		struct page **page);
> +		struct capture_control *capc);
>  extern void reset_isolation_suitable(pg_data_t *pgdat);
>  extern bool compaction_suitable(struct zone *zone, int order,
>  				unsigned long watermark, int highest_zoneidx);
> diff --git a/mm/compaction.c b/mm/compaction.c
> index b7878e4a2c4b..902573797f99 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -2792,7 +2792,7 @@ compact_zone(struct compact_control *cc, struct capture_control *capc)
>  static enum compact_result compact_zone_order(struct zone *zone, int order,
>  		gfp_t gfp_mask, enum compact_priority prio,
>  		unsigned int alloc_flags, int highest_zoneidx,
> -		struct page **capture)
> +		struct capture_control *capc)
>  {
>  	enum compact_result ret;
>  	struct compact_control cc = {
> @@ -2809,36 +2809,8 @@ static enum compact_result compact_zone_order(struct zone *zone, int order,
>  		.ignore_skip_hint = (prio == MIN_COMPACT_PRIORITY),
>  		.ignore_block_suitable = (prio == MIN_COMPACT_PRIORITY)
>  	};
> -	struct capture_control capc = {
> -		.cc = &cc,
> -		.page = NULL,
> -	};
> -
> -	/*
> -	 * Make sure the structs are really initialized before we expose the
> -	 * capture control, in case we are interrupted and the interrupt handler
> -	 * frees a page.
> -	 */
> -	barrier();
> -	WRITE_ONCE(current->capture_control, &capc);
>  
> -	ret = compact_zone(&cc, &capc);
> -
> -	/*
> -	 * Make sure we hide capture control first before we read the captured
> -	 * page pointer, otherwise an interrupt could free and capture a page
> -	 * and we would leak it.
> -	 */
> -	WRITE_ONCE(current->capture_control, NULL);
> -	*capture = READ_ONCE(capc.page);
> -	/*
> -	 * Technically, it is also possible that compaction is skipped but
> -	 * the page is still captured out of luck(IRQ came and freed the page).
> -	 * Returning COMPACT_SUCCESS in such cases helps in properly accounting
> -	 * the COMPACT[STALL|FAIL] when compaction is skipped.
> -	 */
> -	if (*capture)
> -		ret = COMPACT_SUCCESS;
> +	ret = compact_zone(&cc, capc);

&capc, and I switched it to just return compact_zone(&cc, &capc);

But otherwise it looks clean to me. I'd just take this as-is with your
From: if you don't mind. Can I add your S-O-B?

