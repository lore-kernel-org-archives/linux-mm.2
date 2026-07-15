Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54714C4450A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 05:09:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4461D6B0096; Wed, 15 Jul 2026 01:08:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41D896B0099; Wed, 15 Jul 2026 01:08:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32BE06B0096; Wed, 15 Jul 2026 01:08:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF9C36B0096
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 01:08:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 152F0A072D
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 05:08:58 +0000 (UTC)
X-FDA: 84989831556.02.D161104
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6F9EA180003
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 05:08:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cYT2v8Id;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784092136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6GbtHelTP7pkNe4uUfynWB9OXy2SbldY0mNVacZ6jng=;
	b=IWAq62IsmqhUHNgbXVL26NEXSjbKqgV0+iCpo9EGFyDLfDSeBMWvOMo3J1s12N/xBy6R4y
	LjY1ZZoxd4TxgHs3A1MFxaaqliBpTRNFphoZB2ApdYZIOtXdQIasWY9waduI43A5h6W09W
	k+eRyo7WHYohrn6HiGE2HFw54Gb/JI0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cYT2v8Id;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784092136;
	b=GtNUhr4iTmzGZbl5vMEYPgqSF8Vb8EaFvS2KwWDUQQUDwig5+XqZW39SjgW82mEDuxrUp7
	HNbWY0DjWnHPRu/ZPr3rTsXcWHSyNaKCUhOEa7KIyCgJf5jjmO8gVpLMKXyJCnYvbluatp
	d1iPa3stVT6ZRjz2ILJTlZTqsVY18p8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EB25F6137C;
	Wed, 15 Jul 2026 05:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2298D1F000E9;
	Wed, 15 Jul 2026 05:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784092135;
	bh=6GbtHelTP7pkNe4uUfynWB9OXy2SbldY0mNVacZ6jng=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=cYT2v8Id7bE6K5KlsktV7m80GSat0eLH+yf9GE/CIqjZFuSC9/NcRTHSdtg2ZVEdP
	 xM+gaiITvUHbnaP+oKuCuD6w2bfAGeTkIFrDDi29U9SJbJRxrMJuEycmgWymMRSvCQ
	 5jGn5WLgvdHcMKzymfoX8WoKN5sE1FJIR3pCF1+j6sG1+cv2JJQDNRuzUA3EEkjt4m
	 j61l61YksUqlEN82RmeHhqUeafeYS94sbUSm/66zFF44TchyiEunM2V1TaRWfDmc1o
	 cWwbeEy8gEzRRd9QQ9lLQxBlGw+osS083wTVUxnL9LdvhL38vcdbIPZbv1e2FrbsFT
	 N7omm93+sTcbg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 03/17] mm/sparse-vmemmap: introduce folio-oriented
 vmemmap optimization macros
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
 linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org, 
 muchun.song@linux.dev
In-Reply-To: <20260702093821.2740183-4-songmuchun@bytedance.com>
References: <20260702093821.2740183-1-songmuchun@bytedance.com>
 <20260702093821.2740183-4-songmuchun@bytedance.com>
Date: Wed, 15 Jul 2026 08:08:42 +0300
Message-Id: <178409212283.638342.14256193145803309214.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6F9EA180003
X-Stat-Signature: 7ic1jg79ptni59qeu74nneaqxhc6nzoo
X-HE-Tag: 1784092136-535296
X-HE-Meta: U2FsdGVkX1+i37aPfAiNxwTeLvzD1ddXSVYplZhFMaK8ajfU3zOnNM/cMZAu8HYUMdt9x5wo8A3VMjS5qW5n8XkvlICtK1qVzcgQisKhmpdUUbpAPtNorBJ1hVLF/S1423Fj4hyk+zm3+dgBRd9wRh+0vxwjrPbHCsYrXfeXXIhpou/+qMn6IgvxffcEDoTOAE6sELl1wGSvfoMBaKmkYn5tvuu1GyWYV0bnRcBCtYeCslXSWv+pfbP0Q2bKiyF2o+MDLLdSu3TKTfGSxROZN17M6NBU/sKY57zb//u6hkzwfJQulGqmyRhh19qois6nLZO9h0iRa4qMiYOrbgJnc5uOCtSyXM3i76lshkw2cJuCPXxTuzTgZpssG73qP4Nk8KmGfYUfmWip4FKg5AJ27w7UB2tyyPCOv1Cwiw8WZRgLlADP6hJK33cLkc88/fJIzcB2xnzc29JhS6uHGBc5iQv7Y8XsWbayIhQ42eTgFUy5rAMD0wk6tNdDQ96ZyG5veeGqGPm4QVfewZ5mWYpIIPfdox7afP/A84fKUk36k6JSdmthQcuPlz85f+Qa++UJkrz+1+4hd6Hxi0Zksk2KYKkmyNr44P0Kds/ZNacxXe4JbjOsibctqROKAN5y85hZ34i3CTYJqz6CLy6YPrpynzqciTLXAtQMNHjviAS3/EyARQsNVrOIQ2Y6K5j4SrKCjOtFyiHewIQ6YVQg3t/HvqNiYieJUYyWFfb1UOnTKJ5RpA+gDs73W5MTJs3xy1ZdyQePndje3eMAvTMbJyuA4A23vJ8oeHAnFrIXHK5kRdSenKLWdWi3+OVaryi0F0ZTo6tOs04CjqBrENv7F0Ib/AVve0bmH4MqTZ2qV/ZwssJ7ooVoLykl2qAh6jzsqCixU8EryGXBmkK4VwFou6QPsUg/OWqVKlANxOhy13KE3RBf6UxE55pnmnjLvAUvl2C2SlglNUPlS7W44c1dwBX
 wSPWtUgh
 NoAaktsEfyCcurgPyr87Fz4r45LQ8LGCIjU+sIbZTwdvnjugG3qFIIY41jfr6NrrhBwbckbA90IDG+AB2nHxBszrRDrGFfS8RPTYFRT1bMXDPBqED4JyFSBa8Dqkl+gwmdZCMscKs/0nsdOWDxlMfNj4j8M3y/8NvALBLWFQCO+m489G66q0HoGAwwDTIxzaeS91qmVwGKZIhYOECyhpUnP2OQDg2FN5BusaSsN4vjNhbVlQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Introduce macros for those folio-oriented properties and use them to
> replace the tail-based names in the HVO paths. This makes the code read
> in terms of folio semantics instead of an implementation detail and
> better matches other folio-based users such as DAX.
> 
> No functional change intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index bacd89572c5c..ea884245f499 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -107,13 +107,15 @@
>  	 is_power_of_2(sizeof(struct page)) ? \
>  	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
>  
> -/*
> - * vmemmap optimization (like HVO) is only possible for page orders that fill
> - * two or more pages with struct pages.
> - */
> -#define VMEMMAP_TAIL_MIN_ORDER (ilog2(2 * PAGE_SIZE / sizeof(struct page)))
> -#define __NR_VMEMMAP_TAILS (MAX_FOLIO_ORDER - VMEMMAP_TAIL_MIN_ORDER + 1)
> -#define NR_VMEMMAP_TAILS (__NR_VMEMMAP_TAILS > 0 ? __NR_VMEMMAP_TAILS : 0)
> +/* The number of vmemmap pages required by a vmemmap-optimized folio. */
> +#define OPTIMIZED_FOLIO_VMEMMAP_PAGES		1
> +#define OPTIMIZED_FOLIO_VMEMMAP_SIZE		(OPTIMIZED_FOLIO_VMEMMAP_PAGES * PAGE_SIZE)
> +#define OPTIMIZED_FOLIO_VMEMMAP_NR_STRUCT_PAGES	(OPTIMIZED_FOLIO_VMEMMAP_SIZE / sizeof(struct page))
> +#define OPTIMIZABLE_FOLIO_MIN_ORDER		(ilog2(OPTIMIZED_FOLIO_VMEMMAP_NR_STRUCT_PAGES) + 1)
> +
> +#define __NR_OPTIMIZABLE_FOLIO_ORDERS		(MAX_FOLIO_ORDER - OPTIMIZABLE_FOLIO_MIN_ORDER + 1)
> +#define NR_OPTIMIZABLE_FOLIO_ORDERS		\
> +	(__NR_OPTIMIZABLE_FOLIO_ORDERS > 0 ? __NR_OPTIMIZABLE_FOLIO_ORDERS : 0)

I can't say I like the new names, they read like some folio optimization
rather than vmemmap optimization.

I think they should be namespaced with VMEMMAP_ or even
VMEMMAP_OPTIMIZATION_ (or VMEMMAP_OPT_) and should not mention folio.

I'd also drop intermediate defines OPTIMIZED_FOLIO_VMEMMAP_PAGES and
OPTIMIZED_FOLIO_VMEMMAP_SIZE and use 1 and PAGE_SIZE directly.

-- 
Sincerely yours,
Mike.


