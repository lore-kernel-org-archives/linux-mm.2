Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8124CD711CD
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 00:08:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB7426B0088; Thu, 18 Dec 2025 19:08:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3B656B0089; Thu, 18 Dec 2025 19:08:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B46996B008A; Thu, 18 Dec 2025 19:08:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A23EB6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:08:06 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5D03B13AB42
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:08:06 +0000 (UTC)
X-FDA: 84234282972.15.5E9916F
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id 564C8C000D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:08:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ONvW83z6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766102884; a=rsa-sha256;
	cv=none;
	b=0IV/t05/IeDCY+K54FzvOPEluPLJzDziHDZCCKGfVs7C4gNfvlgYgLBXsydEhiKi/5kwDG
	5s1Ridd/i/Khi6AQbW2mEDMNMTUDuPHol5Btfzz5BUy1eUeozHad9fI/yVHVMOPmQFw62X
	3gDhWN9YGsoqBpS6S8pKXJLo2PQlf1A=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ONvW83z6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766102884;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XCAP50irZ/VU2CViej2qFkT1BTEl/kl/JteGqqPW+cs=;
	b=mfZyQ/dXvkLC/yiWPmEPVEzfBnRZhD9AhrgwhQHasgBb5U108XTrvUTe0SdiEr+YaA1IPe
	h9PUHuntyDu6RjGphclMWrLDjs2Glg7zEeSbruVBonYlLYUd6ylpmg3DcL9X8E3Y3YT4Wh
	Z9gTH8FjO0fcB80zxiC1Tu0TLNVvY2o=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-64b8123c333so1113960a12.3
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 16:08:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766102883; x=1766707683; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XCAP50irZ/VU2CViej2qFkT1BTEl/kl/JteGqqPW+cs=;
        b=ONvW83z6x5GAoib4MoIGaYwh6btD1Tk1JoTAZrONk1WE0/F0mUHZ1tBtH4IayudqGW
         N6l2NGuOuurkg6TtVnpTvw0/Ysyk/TqggT0TYwl+Jw+aR6kCsZXlmKrNso3s7vxvOo6M
         0e/yUTkQLD4SX9AtwssOiIp3os3Lz5ltM3T+ir2Sgggj2gMgzHfZ00ic9Zp0s5av42CO
         lVfCUL0bN+p0gQX70o9dGj75E2MhbiCPi7ijExPJBp/4Jm/nbXFq9IxG+t6dJTWbd65g
         ICEWBJLPRRb2ZHJpnbqS4KB7mHLwo3iIfwQDi3UxrcqVYtgcY0pB/sUKpoLDIA5fVsKZ
         IcaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766102883; x=1766707683;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XCAP50irZ/VU2CViej2qFkT1BTEl/kl/JteGqqPW+cs=;
        b=DTxT2MWviXhbJPVCVMUFWPyLf/9OtdPvKlI/u99do7o058c9TyEs5tVky2AiXt8oPK
         +aiakzranwhtCmUHufANo+w4Dg/1g7I9dlYwgBREngr4qHKliqhkHdF3oAml6+jUkpOp
         M/iRiTvNugUKMAgCROvLctLCQ6zY/zfP+UaTarKYARpgpGO1JEijEymMBsMfJ4PQ/28G
         HahggwBS1Ba8dUFK1sbVUWXDZE74ldm4KPUiujGKWW1pi54C16RySYsXDy3TX5WPdX5e
         JdJEbo1dRaFr4LSm1iKxOPLhz8dofZt/S6Pd+wtwFEcwL3A0VtZYnYl3MVyl15lQqf4x
         Nmlw==
X-Gm-Message-State: AOJu0Yyg+MY7jnkWhZ3ztOrlcmkQPhNzE3J3djkj9S8wevhQqBIGyq8t
	oIEJr9M3JwZ6FN8vSqiYEQnixzLgkJSapQGt39O5ePBd0cJVq/1rl868
X-Gm-Gg: AY/fxX44tVwDgu7f+WnlThew5oqViPFQ/JAhlAl6qyewi/L4Co3BFrAlCB5e/UkInGX
	wiTwSclQs8HrnN9z+ela4DF6lX52GTulZWPGsPycVgVurUWKSemnbntstR4xJndE4y3NghNrlxX
	Lkb4vO8qKShdhU0frGNNhC62MI+4P6sti/b/cwyy/Jgdx0sYy6Cwr4sLzJhnsLkyUOK1XTNvite
	9HrQZLP2C5CT5GmusIaeq4OyHmiEfh68Q3C05sp9+CmNV5ZV7nPsmRMROeeHJyq/EVgV+qycngO
	t+nOGDvlqcETC95fB3op7YkkZZleZyWW+x6xOKyBw2LQXFQwGzbequEsxyeemW6XHAir4BTUzan
	I1Lw5YAK8b1W37ZFmwAOml1rAbOXkGbxyiXbe3wpn38in29pnmSA4D8YHoOeloU4zcIusc8vmjf
	O6GgMBYeMwyw==
X-Google-Smtp-Source: AGHT+IG5XujdJGl2wz4kIxzCrUSWspKCEBh/ORj6MONC6VI1zBsgVlXgDRFf1dkzETmR/VTE4zcmXg==
X-Received: by 2002:a17:907:970f:b0:b80:3445:f4be with SMTP id a640c23a62f3a-b80371744d4mr114740266b.38.1766102882298;
        Thu, 18 Dec 2025 16:08:02 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037f089fesm71913266b.46.2025.12.18.16.08.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 18 Dec 2025 16:08:01 -0800 (PST)
Date: Fri, 19 Dec 2025 00:08:00 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, richard.weiyang@gmail.com, osalvador@suse.de,
	rientjes@google.com, david@redhat.com, joshua.hahnjy@gmail.com,
	fvdl@google.com
Subject: Re: [PATCH v6] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Message-ID: <20251219000800.tnpqzvcdyeqcwryt@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251218233804.1395835-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218233804.1395835-1-gourry@gourry.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: 564C8C000D
X-Rspamd-Server: rspam10
X-Stat-Signature: c9x14s5kfh9pyt9g9sryz1kwio4yuenq
X-HE-Tag: 1766102884-542740
X-HE-Meta: U2FsdGVkX198sQUEAz3EiPWeqp6LmvY/Vv9vIaC9I4bCXaBXE1oqOYmeK0UBhjJp4v4J2mTEiBOJ3KFeR6vsONgHzOmkuR7LxAy3JVW39+Wn1c8GP5Dc3q1IyLnPlIGzlX9XNhJZSbFUXIK8C5ZoYo2uRB/vZYcI7G1AybW8v+e9CBCiCXT6q9C21cTsD1X/ODl4cGpJexGL8VOtoxsQDqx2UEr5lpHZ7deIdlC5dNXre/+ZqdklG2VUmogXi+8S4AilNkD6FNsfuwmCZTAGSXMaJOgyYDsPAkNNwftgGjbkyajOY4TlVF2axPFYT/0mPDh3na8M4QEArvN0Pem8JlBv0QpXWbEtRk6EPbhnCGy8j8FAUfdHfazMhNrScz7JtquSkk5vQ8q9uDjniz0qsHSTkv+eO3fSRUkFY0+2ahtGx92CriobXijlCIV/FQLlqYcc28Ujv/mLxPoqO9T35yRQK5qpaMtPtq5oKG6CgmhzleS6fHvyb9paFCfvU1teBxrGISVg4I2E/tSinc+1NTKhmifrArY/1/A9D9ZY+cNnPTc3EmYDtb6kKFa9dxpntXMH+XBbStic/rYu0BjANTYeHSBpxsEFRrwSxZqgiF4CbX1DQRl6SPrhhgJjnM92KUhngGTerIeGafiaVfKS4jbg1ImAqsWcNYVBZTxr5WmMcftRLk7OmCjWqNn+88YhAERuqVpTgjkSWuBeNk5gcDc6Uv3tXvZahgA5EE+tLLmMKArvwGratxpfOvUfUNO65WKRlKgxvmjrSezBTCC0NS9bQ1vHVBbAi/pjB6UWXg2TIGiYmw0asfJ1XjXHf5duzCq7S2UeETxAHUBH3oV8xPFSYTAp+z65kt/++m07MhVaOiv3tL3TJP+NnA9b93+pKKsqQXZUPFgVauu246gayRhnWaG8NfgXEXGR2LdI7Qr2ytyYlDzuYNmTWIq2rAiUOvnPw1EvhY+B+PKF9Lt
 CPdWtZJF
 fyXazTa+0x3wxaSpISfnt70pFBAAgCwddMOliqLyV9a/U3Ss9mnI9OfLll9AlNBCplw/46UzR7Br8kSTG14lXutZ+yA+LtlJ9UZLLWQjHR9bMDKjReCHEiOWgCWWYXf9Kca2uZAY+IUiQ8vOQMzaGwZLMFxrL1ipj7wB0IuJYIydefw3ahGbyEzy1vgLds97MytLZ5oOBTf/yfB+GZIT0BkVWK0Kwi41AmAEoKkCmE+iSKHMaNe9Tpr5JLrHhETf38zHARe250Yv6uJ2HqvhlyI4Y2u12eiOG9kaxKJBqvsx1a8O0tUCz9dY+pH/WgNeRwJlowbKNtCo2iVMKV4RyOwIuSlP37xCt7eEXryDJiSRwMhL/kncoAArgwY/oFu1hx+1lSnyeD/qqkGoSyq3sPFfUz1f0RUPI/hX1T7bPpkQFfmRaJxE4vglQrCGuK7kAgq+0snhFusQf+ZYO3RPgIUQeo8HSNYiZBFDzdjRIZqaCF+wcGwgMU3syCrr+T95epkcj4umIgYOpJejKH/mYBq6UGgqYtov0gzDExa3fYIWJt9oqVUD6yW92Ulfc27JCAKMKyoXX4MoYIXwU9mHVaDENshkbYAIHBitdC2crjc2T0LHxTEkt1fpgXiqd9V3hQd1SuAG/hHgJeN6fUpFv/XNefd6x2bUTu3RxClh3yKVwAoKkCnpjRXvxMDAoRwSw63KiWEi1IVnUClMX3ooeFL2EZwWQN18Y3WXI/5pDwM5J0lP6qeRCPcewcSherR58oX/25eFBYoX7GbctgjIfdCzKfEN8lbs2j1j6pMNYeoRUHDXjy/DoT2FU1RuKIjkIZDENfvjVL0B/TkgwnYYFTEZfHEyrex9zgUOHV080wuKhdNc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 06:38:04PM -0500, Gregory Price wrote:
>We presently skip regions with hugepages entirely when trying to do
>contiguous page allocation.  This will cause otherwise-movable
>2MB HugeTLB pages to be considered unmovable, and makes 1GB gigantic
>page allocation less reliable on systems utilizing both.
>
>Commit 4d73ba5fa710 ("mm: page_alloc: skip regions with hugetlbfs pages
>when allocating 1G pages") skipped all HugePage containing regions
>because it can cause significant delays in 1G allocation (as HugeTLB
>migrations may fail for a number of reasons).
>
>Instead, if hugepage migration is enabled, consider regions with
>hugepages smaller than the target contiguous allocation request
>as valid targets for allocation.
>
>We optimize for the existing behavior by searching for non-hugetlb
>regions in a first pass, then retrying the search to include hugetlb
>only on failure.  This allows the existing fast-path to remain the
>default case with a slow-path fallback to increase reliability.
>
>We only fallback to the slow path if a hugetlb region was detected,
>and we do a full re-scan because the zones/blocks may have changed
>during the first pass (and it's not worth further complexity).
>
>isolate_migrate_pages_block() has similar hugetlb filter logic, and
>the hugetlb code does a migratable check in folio_isolate_hugetlb()
>during isolation.  The code servicing the allocation and migration
>already supports this exact use case.
>
>To test, allocate a bunch of 2MB HugeTLB pages (in this case 48GB)
>and then attempt to allocate some 1G HugeTLB pages (in this case 4GB)
>(Scale to your machine's memory capacity).
>
>echo 24576 > .../hugepages-2048kB/nr_hugepages
>echo 4 > .../hugepages-1048576kB/nr_hugepages
>
>Prior to this patch, the 1GB page reservation can fail if no contiguous
>1GB pages remain.  After this patch, the kernel will try to move 2MB
>pages and successfully allocate the 1GB pages (assuming overall
>sufficient memory is available). Also tested this while a program had
>the 2MB reservations mapped, and the 1GB reservation still succeeds.
>
>folio_alloc_gigantic() is the primary user of alloc_contig_pages(),
>other users are debug or init-time allocations and largely unaffected.
>- ppc/memtrace is a debugfs interface
>- x86/tdx memory allocation occurs once on module-init
>- kfence/core happens once on module (late) init
>- THP uses it in debug_vm_pgtable_alloc_huge_page at __init time
>
>Suggested-by: David Hildenbrand <david@redhat.com>
>Link: https://lore.kernel.org/linux-mm/6fe3562d-49b2-4975-aa86-e139c535ad00@redhat.com/
>Signed-off-by: Gregory Price <gourry@gourry.net>
>---
> mm/page_alloc.c | 52 +++++++++++++++++++++++++++++++++++++++++++++----
> 1 file changed, 48 insertions(+), 4 deletions(-)
>
>diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>index 822e05f1a964..adf579a0df3e 100644
>--- a/mm/page_alloc.c
>+++ b/mm/page_alloc.c
>@@ -7083,7 +7083,8 @@ static int __alloc_contig_pages(unsigned long start_pfn,
> }
> 
> static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>-				   unsigned long nr_pages)
>+				   unsigned long nr_pages, bool skip_hugetlb,
>+				   bool *skipped_hugetlb)
> {
> 	unsigned long i, end_pfn = start_pfn + nr_pages;
> 	struct page *page;
>@@ -7099,8 +7100,35 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
> 		if (PageReserved(page))
> 			return false;
> 
>-		if (PageHuge(page))
>-			return false;
>+		/*
>+		 * Only consider ranges containing hugepages if those pages are
>+		 * smaller than the requested contiguous region.  e.g.:
>+		 *     Move 2MB pages to free up a 1GB range.
>+		 *     Don't move 1GB pages to free up a 2MB range.
>+		 *
>+		 * This makes contiguous allocation more reliable if multiple
>+		 * hugepage sizes are used without causing needless movement.
>+		 */
>+		if (PageHuge(page)) {
>+			unsigned int order;
>+
>+			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
>+				return false;
>+
>+			if (skip_hugetlb) {
>+				*skipped_hugetlb = true;
>+				return false;
>+			}
>+
>+			page = compound_head(page);
>+			order = compound_order(page);

The order is get from head page.

>+			if ((order >= MAX_FOLIO_ORDER) ||
>+			    (nr_pages <= (1 << order)))
>+				return false;
>+
>+			/* No need to check the pfns for this page */
>+			i += (1 << order) - 1;

So this advance should based on "head page" instead of original page, right?

>+		}
> 	}
> 	return true;
> }
>@@ -7143,7 +7171,10 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
> 	struct zonelist *zonelist;
> 	struct zone *zone;
> 	struct zoneref *z;
>+	bool skip_hugetlb = true;
>+	bool skipped_hugetlb = false;
> 
>+retry:
> 	zonelist = node_zonelist(nid, gfp_mask);
> 	for_each_zone_zonelist_nodemask(zone, z, zonelist,
> 					gfp_zone(gfp_mask), nodemask) {
>@@ -7151,7 +7182,9 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
> 
> 		pfn = ALIGN(zone->zone_start_pfn, nr_pages);
> 		while (zone_spans_last_pfn(zone, pfn, nr_pages)) {
>-			if (pfn_range_valid_contig(zone, pfn, nr_pages)) {
>+			if (pfn_range_valid_contig(zone, pfn, nr_pages,
>+						   skip_hugetlb,
>+						   &skipped_hugetlb)) {
> 				/*
> 				 * We release the zone lock here because
> 				 * alloc_contig_range() will also lock the zone
>@@ -7170,6 +7203,17 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
> 		}
> 		spin_unlock_irqrestore(&zone->lock, flags);
> 	}
>+	/*
>+	 * If we failed, retry the search, but treat regions with HugeTLB pages
>+	 * as valid targets.  This retains fast-allocations on first pass
>+	 * without trying to migrate HugeTLB pages (which may fail). On the
>+	 * second pass, we will try moving HugeTLB pages when those pages are
>+	 * smaller than the requested contiguous region size.
>+	 */
>+	if (skip_hugetlb && skipped_hugetlb) {
>+		skip_hugetlb = false;
>+		goto retry;
>+	}
> 	return NULL;
> }
> #endif /* CONFIG_CONTIG_ALLOC */
>-- 
>2.52.0

-- 
Wei Yang
Help you, Help me

