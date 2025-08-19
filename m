Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3962DCA0EF5
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 09:52:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99EFE6B0102; Tue, 19 Aug 2025 05:52:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 976C06B0103; Tue, 19 Aug 2025 05:52:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88CA86B0104; Tue, 19 Aug 2025 05:52:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7591A6B0102
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 05:52:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 396001DDBDF
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:52:28 +0000 (UTC)
X-FDA: 83793041976.07.EA0F0B6
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf17.hostedemail.com (Postfix) with ESMTP id 413A840007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:52:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="LBR5G5/3";
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755597146; a=rsa-sha256;
	cv=none;
	b=gzXXTwyq2X3HXhbjMUGdEoGFbUiR90CdU+yi21fAqiEZndBqnLA2Qle5+pT1cR0N47LVBl
	QLpcyVnbIbMKlS6vR+XTvIBTrymjyQLFOL5nKmplRzI6pWRe5oeTLEQa6lui+3fQxdscyT
	iuKu/OmaNb7SFjs3lmDWclGgJiVvYB0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="LBR5G5/3";
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755597146;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DGKilKkH6ulJbbdDF/XnTU/jMrrNQ/OZzlvjuNWjrx4=;
	b=mBGMEz8hPr+Db/cATFlLXFNRmQAH/5PEFM+lnFIU7o1/008GKWlASMbi5JoyT+oMLo3nDy
	QZc2U6fl+XZU7TTZbmzlY1oRASXAzyOgfYOtjtPo3Jd1sHY1So4rI4CJc+I1Soh90Mcqcb
	LQ2zEIvKhiF9DCkWIsPqJ4iFbHOLxnI=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-afcb7a3a085so785744166b.2
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 02:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755597144; x=1756201944; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DGKilKkH6ulJbbdDF/XnTU/jMrrNQ/OZzlvjuNWjrx4=;
        b=LBR5G5/3TKHBsroofGjVceyeur9nI9tJH7VQyPk+ZQvIBVrnNlC1/cO9rmvATCSQOq
         6vPb90DpeZVtQPxPtp3iOgkCuIXKrvEjTFnKVxIS5X1RoWXruU98ScIDP+bC8HX7P1v5
         YcmsUFTKRdImzCjw+0E7/GZpjzeM/JowcexLDqvpoNOv5kZkFJUmXwJIIodvMK/yzObf
         a9Z6vVpkjixuYvQ1jRu3DKSmBIIbGvufjh3tE9ibUuEFhPkFi6WzFb9GjPMCmvidObwL
         d7fzww0Ixt7lomV6EITQqtEojj5l8f2Rsgo0cCO6+YmifDipzgIBUcL7/t51C4rAHGVD
         GBaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755597144; x=1756201944;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DGKilKkH6ulJbbdDF/XnTU/jMrrNQ/OZzlvjuNWjrx4=;
        b=W8aR2VyGb+eGM9K07+VBnrJF+NsO5kWOt2+xsFQllcgC76FPs1/40F0MCniyHJ1BOY
         8rYes3jFW2nFkXMlkM8oEbHhjV61GwDpTTlYXpbCBrM3CIPna50RDw/fNBxbUns2+ALz
         CBpP34si+kzwZXEiFuCIjzimsGtrnZ75+Z3oatgoFoBLaK39Nt2nb5Eqv5Uhzb4UCP+7
         c4pA3Ra6Hi205FIlX6PCozWEbf2/PQ7UlyuQGvvSk1vwpCz7QsNQb+32T3v3qQ9LCJKc
         NXroA08MFbZuLdxI8NRepKS8RFTHW3Sq+jzTOrRLA8QKY6KG6qEYD3YoRxtpiXvusTQf
         YtLA==
X-Gm-Message-State: AOJu0Yyw1sDGvIpD+UFFweb8myOuSPkorQGFUWTVNb1TNSQToRNjAk/l
	VFJET8v0+I8UAK+1WiYaO5NJWSLHAXD8SM+8V+1sge4/6HeH31oUie1+
X-Gm-Gg: ASbGncsIlxXLZHFaJVvPYcYvQWhpRVbSbJ9eOqXiwF0zLral+ONDUlMxSG9fNahz1A1
	VnJQ6Ny0ZcRKH73inRiaRecDCdVNxErSkEM1d/lje33a6EYP0Zb0PXSMa04Fn4oir7FRlzAkEif
	sQup6VUr7/yr+RjV6CpvIxINAwzGPo81om9RdnlnboNNh8FqY/ZUsLTG0XtNkYNWdaFpCgS5c6U
	fGaExfRMU7WiguC9mZ5jgGi4wlbzHgzJvHBppt40D3Yl2jGtX7u0Mahu6cLlIeqHTMyqh09UQL4
	l21EFOGP4Mkg4lvcoq5pHYJqfJ8zFfdZNMy9IHMI0QjW9TXjyHPKc1S4uVzIUrMPd8n23HuPTYu
	plws0MqdSK6tn81OIYpc/xg==
X-Google-Smtp-Source: AGHT+IGl4szIJa+BhsJtYd6B7f8e6cbRaIoS3/RZYsKJqrTQ2MNq/q3Jkblc6AIW/S6WMxr98PJw4A==
X-Received: by 2002:a17:907:d26:b0:af9:c31c:eeca with SMTP id a640c23a62f3a-afddd1ead43mr171516166b.48.1755597144172;
        Tue, 19 Aug 2025 02:52:24 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afcdd04e4d9sm980813666b.113.2025.08.19.02.52.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Aug 2025 02:52:23 -0700 (PDT)
Date: Tue, 19 Aug 2025 09:52:23 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Bill Wendling <morbo@google.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Justin Stitt <justinstitt@google.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH 1/4] mm/mm_init: use deferred_init_memmap_chunk() in
 deferred_grow_zone()
Message-ID: <20250819095223.ckjdsii4gc6u4nec@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250818064615.505641-1-rppt@kernel.org>
 <20250818064615.505641-2-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250818064615.505641-2-rppt@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 413A840007
X-Stat-Signature: nqhhuit9jkeck9ydm9f49hajocw9e6gx
X-Rspam-User: 
X-HE-Tag: 1755597146-536091
X-HE-Meta: U2FsdGVkX18VuZlUX7dqz/oEKcU0v1L7ZAWLbagPYdFblSqt1ivIDqbgt92ZVkiLj7YH33XzcBY4K0XcNk5/+Cs4J9QYsReC+RIxO18J7q1wzmTV51INQTS0I5NI3PZsNbhfXgLZJN4QzYeVziASpfuvEuQQfN+BTDxFrYRCElrUTbqobBNduzzRuECOu+dOwpKnFlaHOL5DCtUo2qEquG9B6Qo9/y7gk46xCtd6bHGEYtZ+gzo/FJIgAqvp/jSGab4XWZLlosswMTFj2SX3jJA/KekwAbeEyw8N8EzYOg2yrbVELapSthDDayGjn+5fcnu34+Kla53WFILZAzThuq/pp8HA9Ihfu1yYWZtyk+KoHS6f4WyBPR1HNjZsXooM/YR/KbPcK7y2yH1W4U+ifaeFdVLK0w9sUT5xc/zAHTQJP2aKJmxebJHThw1ibSdEXXCovWrQznz3SIcOXp+oBEejWIS45KFXz53fX2/LWKCRynGbAOyW1+FXlFhPkdGEUtoRCRNyOZCspNm2kpntAWmoQixhq7saJZ4aXX0Gt3K84hnoLAtxlPYH4Yyp6rru2ygxrL4mA4iZ5QEMWOvg3CISdDq4eRWqwGKZj38w/OVSPGjkHK6rZ4oACHy/xOsdp4/koEPAMz0VpwcnB1zYCZxacqFcQFGdzuYE67kE3dfAD8eUjeVx+SHYWTJjLdkbXLKOugDFlprKtiY6avlhCkPkGlstsd8VP0J0QDi/FOBelQFybdS/HDA+75lrkaYSsY+Py8pLO/2lJkF87n0wwZ46ceT9uFVUZzrtQHubEGt640VmG1Q53I/aO9S/SY4ZCaSGgxAPlb2eQzzCeQkgmYIxeOUNIQ2XWOiHNBhHbafEcR/BlcM4Zv8wnZJrcxj04tbVbC4wTwe6AaLh+R3DCSyQdkyEHI51ZbwfoUvqxRQkB1fhTm2vHDRAC/nrZZWsXxPysD+hBBXylOllL8M
 hGA5vrWA
 0xexblRCnGQerQOcbKRp106oYsSGFYfBir2T33AqDLRhH1b15GAV0URHwVxK0dXxOLGHb1swmDSd5xyO5A+TuCTXs02wWuPoDIzbp/xE9BtP9pSk4ilYZDEb/onTpy5cESXPe30og3QMo4l8Ws2sh4Furi7BmC4Jz6ba8YX0NuaGJ+00rIOFzh6gRcp070LKMSCRcnxYEINWIgeFC6myqx8XSkeZGlq3tVwYNwk5tryMygesC2rQ27ksYwrgBll8GXx7KedRs9B56WmlwXlLZOvKKLRwJMKT1wSAR878Q/Ifni5vl0MdcVmZdiV+3cn0Obigc39ukUqv2r0/+yNomVMFk3+u+xTmzQ2ozjqYzXILFyPlkSRvoCa3dqnWxK/QlhTq07W61RifO6KfKog+paJI1Csc8JoKwJWKGi8sLqakPjdXcsmbVmZduaNL8WNjwl1eDGkqeu2LpB/SRPRRl8jg53JHW7UO85+gaqyuOBFZqNi4FBikvCORCiQf4Fy/GtxIPoOhhMHyP5O1P4z02YJyLSC75h8Oqe4oxzdTKOhbW8K9A/xPDiMo3gJWuU278XZuEszjJP5KZqyuLvC11upLZVJIpWg34/VbXPURHw+do2WC/4mG4gqs1zUXrnwY0YnVTyg0WiSgNZUd5t8hnlEtXO5+Im5mlCy+8hTxhOsWUbI98PSkz9OFkYqXTg5nYDTQeegGif+xfchIIl6smUs+9uKdJfAA1bw6p/iQztpV4AqyPDbDxY+uYwBotybCGl+Gz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Mike

After going through the code again, I have some trivial thoughts to discuss
with you. If not right, please let me know.

On Mon, Aug 18, 2025 at 09:46:12AM +0300, Mike Rapoport wrote:
[...]
> bool __init deferred_grow_zone(struct zone *zone, unsigned int order)
> {
>-	unsigned long nr_pages_needed = ALIGN(1 << order, PAGES_PER_SECTION);
>+	unsigned long nr_pages_needed = SECTION_ALIGN_UP(1 << order);
> 	pg_data_t *pgdat = zone->zone_pgdat;
> 	unsigned long first_deferred_pfn = pgdat->first_deferred_pfn;
> 	unsigned long spfn, epfn, flags;
> 	unsigned long nr_pages = 0;
>-	u64 i = 0;
> 
> 	/* Only the last zone may have deferred pages */
> 	if (zone_end_pfn(zone) != pgdat_end_pfn(pgdat))
>@@ -2262,37 +2272,26 @@ bool __init deferred_grow_zone(struct zone *zone, unsigned int order)
> 		return true;
> 	}

In the file above this line, there is a compare between first_deferred_pfn and
its original value after grab pgdat_resize_lock.

I am thinking to compare first_deferred_pfn with ULONG_MAX, as it compared in
deferred_init_memmap(). This indicate this zone has already been initialized
totally.

Current code guard this by spfn < zone_end_pfn(zone). Maybe a check ahead
would be more clear?

> 
>-	/* If the zone is empty somebody else may have cleared out the zone */
>-	if (!deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn,
>-						 first_deferred_pfn)) {
>-		pgdat->first_deferred_pfn = ULONG_MAX;
>-		pgdat_resize_unlock(pgdat, &flags);
>-		/* Retry only once. */
>-		return first_deferred_pfn != ULONG_MAX;
>+	/*
>+	 * Initialize at least nr_pages_needed in section chunks.
>+	 * If a section has less free memory than nr_pages_needed, the next
>+	 * section will be also initalized.
>+	 * Note, that it still does not guarantee that allocation of order can
>+	 * be satisfied if the sections are fragmented because of memblock
>+	 * allocations.
>+	 */
>+	for (spfn = first_deferred_pfn, epfn = SECTION_ALIGN_UP(spfn + 1);

I am expecting first_deferred_pfn is section aligned. So epfn += PAGES_PER_SECTION
is fine?

Maybe I missed something.

>+	     nr_pages < nr_pages_needed && spfn < zone_end_pfn(zone);
>+	     spfn = epfn, epfn += PAGES_PER_SECTION) {
>+		nr_pages += deferred_init_memmap_chunk(spfn, epfn, zone);
> 	}
> 
> 	/*
>-	 * Initialize and free pages in MAX_PAGE_ORDER sized increments so
>-	 * that we can avoid introducing any issues with the buddy
>-	 * allocator.
>+	 * There were no pages to initialize and free which means the zone's
>+	 * memory map is completely initialized.
> 	 */
>-	while (spfn < epfn) {
>-		/* update our first deferred PFN for this section */
>-		first_deferred_pfn = spfn;
>-
>-		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
>-		touch_nmi_watchdog();
>-
>-		/* We should only stop along section boundaries */
>-		if ((first_deferred_pfn ^ spfn) < PAGES_PER_SECTION)
>-			continue;
>-
>-		/* If our quota has been met we can stop here */
>-		if (nr_pages >= nr_pages_needed)
>-			break;
>-	}
>+	pgdat->first_deferred_pfn = nr_pages ? spfn : ULONG_MAX;

If we come here because spfn >= zone_end_pfn(zone), first_deferred_pfn is left
a "valid" value and deferred_init_memmap() will try to do its job. But
actually nothing left to initialize.

For this case, I suggest to set it ULONG_MAX too. But this is really corner
case.

> 
>-	pgdat->first_deferred_pfn = spfn;
> 	pgdat_resize_unlock(pgdat, &flags);
> 
> 	return nr_pages > 0;
>-- 
>2.50.1
>

-- 
Wei Yang
Help you, Help me

