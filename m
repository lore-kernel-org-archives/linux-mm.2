Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A756CDC19C
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 13:22:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F8436B008A; Tue,  6 Jan 2026 08:22:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D0826B0093; Tue,  6 Jan 2026 08:22:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DC1C6B0095; Tue,  6 Jan 2026 08:22:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C5E46B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 08:22:09 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8632B9E28
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:22:08 +0000 (UTC)
X-FDA: 84301602336.06.DD02E27
Received: from mail-ed1-f66.google.com (mail-ed1-f66.google.com [209.85.208.66])
	by imf01.hostedemail.com (Postfix) with ESMTP id DE0C240008
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:22:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NOyBhyR+;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.66 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767705727;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AnaTrYgO4HShbHNfxp0Gz+GzpJfxlGJKnBUzxWHLg+w=;
	b=46tceZ25bYEd/A0YfAaW6lm7buKLKxLRlkKbxN345lm5d679RgeehwfDAmDK8AA3nOiixB
	CrprcEh7a0hjRjxPmwW9LRPPL79T6wqybJJkSHmSsnZpx7w1qJZ1JnJfzBKSngCZyu7gPw
	OpN8TccHi0Gp9dylJ+76aH0fE+Vazzk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NOyBhyR+;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.66 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767705727; a=rsa-sha256;
	cv=none;
	b=RoC6V0Ws9DHbJPNAyp9sQqjX3zQCQxEjHiSDCPg6G16eb750l22HF4f/Gc+PZdxtsTtQEN
	yb9uGG5uMLSXX4R5gMZff4sFTq0BCNLkiTgSBN1BykG/nMppHAyCK4XrQcJRYbYiqvGriC
	8FkasfOZ9XdluEuWWo+xG3d7kmYQrqQ=
Received: by mail-ed1-f66.google.com with SMTP id 4fb4d7f45d1cf-65063a95558so1332883a12.0
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 05:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767705725; x=1768310525; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AnaTrYgO4HShbHNfxp0Gz+GzpJfxlGJKnBUzxWHLg+w=;
        b=NOyBhyR+tZgrCIH+pWmnYd4uEuOCUvHI2Fuhkv0S2r4lT24HvHf5XOjSGKBug/Q2Pv
         wS9PXzQ1SxOHE8jVEVGDP211cZDcBjZ7hmFm+D08KLsPdZV4PHrdGaDs7wYdFzM5pBo1
         kwaAp4RSlZ06mF/2Juep+K4JsuLfIAvxtg8UJuqCu1CJzD2RjpfGUaWU5kLG+w67AxIG
         OfWmvQjByFPa48sYh3d/knGp6sxqzvqvaWnF/kHzJuEgPcqmhNAcc3Pzih/WKpSGivDn
         K0qQUX1IPDmrN8QfS8XidMJZejRJ/n+xrmfHUSPowVqBmVFBnL7wwNy4WXDosqMWA1cz
         f9PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767705725; x=1768310525;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AnaTrYgO4HShbHNfxp0Gz+GzpJfxlGJKnBUzxWHLg+w=;
        b=USgmgpa0ao4vdjK2jR6yyTVLz+KdVJGO9jAFyyrx+8MMIUzOrdB7K0WXkk3kbJFmKr
         mdN6EdDuB89Naf4uPzNRTLzfGbjVXVgHgcvI/YND5mbVLMuI8mzE36xCmxZ6PTh2ZzXr
         hADLRzLLAsKKJqhMg7V5qnx/4BF5R2ovglNnSLJGR8nxGukli39vy8NajY8QKezOo4R8
         ze7ehMsg+OEC8snY5Z7jCyHvEDgEgXugPacZGBZtrtz7V9kYsQQOpJ3PgL+eDslHEjuR
         pSbx8VN6g3fyARDmJI2sRNFeMlOO1EY21Iw1nkQa7dYPFpfTTmW2QEEQOe+MtENjh/2g
         srMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUV+hHqVMeYO+Ur8zOilX7Xf/5sUQ/7if0RMkQpHro5U/RFNMvl3f2F5s0jdr1FH5WobiGegvnjWQ==@kvack.org
X-Gm-Message-State: AOJu0YxHoAWFK0qNjXnauzbn66WYqCTpI8QSkVjiMbuBf6Qb+gN3XECG
	DpkpuBa7fgYbkVZk5up7pSgxrXRPQTsFgsp8QC53M7YkSXsqwO3q/v2b
X-Gm-Gg: AY/fxX7WuIZB4iDzLNQNRQhtApm457GDWOauIQu+rzYfUgERm0e0AtSbo17N0y9NbvI
	sbbXj8RSBf8/zthXOt1y7D3i0Ku5j4AqIgxOJc0r90214oUcXq+B4WSOiQCzj/w0Mhy58Vns4IO
	ZDEU0KP3iUQJlGNA0Lb4DB4JjhvuB4vzCrcRdCO+6czZd4HDlEY/fJ1gBAYK7GC95OQFr1thi6W
	Uqw2uo6Jqsa6TQMbJmEIi7chQHJiPjOZs4yMtDuRTUxhLxYE5OZyR46Pyufmv2MqFkUp8xa2Iif
	Uryoi8By7pXiRfd8I55m39e0du9AIQBW67tsgLyMftkHghOAc1+9F+3Gc7/UDxSpilOve4g7IbB
	iQWHNC+JsvpsnSwZPEtZwrEfFbTxibbG9sbEh3Y561mi5lt+lt0hSsxpV4LO+Bk01lPbDV8r6Gd
	Gx/L5QIaPtaA==
X-Google-Smtp-Source: AGHT+IGOQUwp29CuBStqL9lweYRQ0EBUwNwC7bXQ4+jGDqmOepHg0UTslUPPgNQcAc0Gl4FJ2lkzvg==
X-Received: by 2002:a17:907:7242:b0:b7a:1bdd:3311 with SMTP id a640c23a62f3a-b8426c4a81cmr316783366b.62.1767705724583;
        Tue, 06 Jan 2026 05:22:04 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a2cffa4sm225646466b.30.2026.01.06.05.22.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 06 Jan 2026 05:22:04 -0800 (PST)
Date: Tue, 6 Jan 2026 13:22:03 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com,
	will@kernel.org, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, riel@surriel.com,
	harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
	baohua@kernel.org, dev.jain@arm.com, linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 5/5] mm: rmap: support batched unmapping for file
 large folios
Message-ID: <20260106132203.kdxfvootlkxzex2l@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: x9b6gs3arrjfcxfmcjeowf4ngpdywcsz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DE0C240008
X-HE-Tag: 1767705726-604810
X-HE-Meta: U2FsdGVkX1/E5KAZ2VJaYriyqtDMNTmmDbVdUt4MGtZyvNtKAcsIXkYbdjeNc3ePKI4rwbxIrAceN2/4fYHTdY6+ct5JB0jh/+TNVXgElTWAhUb+nAT/IbQ6emy6UxjdlZRhzwhsIEq+3VXoSIoSGgSMU9tye/jVPQETB0P2+B4uQCuVhV5YL6XhvV7iTHNp83NRqpAyDGnw1Y3nyO6lLGC7o9gFsH1WZBQnSny8JCO72Q4oB/zuECDWh+6aLcGypx2diCblQCKZoabWkZ/zSrHyCCHCVV6wYmMGN3osjZLPnY+fj48I/hgVShL2xiXafMYisZXhoXFJYv9y1Uvj38PvTPQwZHxNxGcMBO5sgrbe7EJz8H9ZEUFaJ42W6LsSMCYIdEe5eqghm4nKKQDLvJJmmbyV3loh9oF/UjIvsBU8fwkKH18uOPdQu4NFc2pdofqdrzyL7P1JfsH+zHSXvuJP1puo8EBUK+ARU1mP6zzbse+ethklst7SGsVr6LOv82HtgZk54ugxHagAyGxZObxQ5oFH10x28R3Ld5tjwLGj4zkeJ0ZHkmqUl2j1voFDEXIqwUmxY9murLy0oe92+aNl+Zjc9ce6Bb5uc53b+1WbwDqTTO6SX0sb8AhgCH3mIe7eodI0szH//E/XDYiGTZPlZxKomjfG2LNbMV/tZaX/2xkQIMUAejvscYUlH50Cwbdhu/JWLde1HrIT7CL7mPUAPDYGKKBSD/RO+2fO7RzRK0xz+wScZU0lUybbI9nTA9MgTB82z4VHDH7fsBtVhLX/Qriv9dqPzhfLnmqYjgfAhHnrDqWLAV29W/IC48KiOBvgzNB6ovLQvhY4r9cRiCjqFIPOaMZIhrswotMSlzg11eweE/CRzbY+OnkMVcz+HVPnuROzeeY7zmiUscr3VNB8ZiH/0ip+UxOw7P84u7feJnv8dIs4xH7VFW6mFjQo1c8gcSTC6xWe5XZ2+39
 MrJvomhD
 AqZrx8Tatu35xDNhE7rGU76idyMQoWusZ4B11RiOKOUZXMFEBURDrU98s0iPBKgMuvX1AWPxzJ0PIyvRp8RzgObzHBfiN3w/mHjRpsC2bIKJlaTah1wnK4KzXVBFyY+IHMtv/eMxqBcrOeQsI6i5VzzLCUedz7AA2ML1nnbdC3tlJhWVy91G0bPXsd3jAiDn0hA3p8saCY9ZB41eIUw1kzrxoI8KLZvJ1MHtBtyLSPx1gSgQW7MNrhu+OM7E/QqboZIZIMn+CjQ4gwYO4KVbCA/E7DU9wsp+DLYe+bZj4w1r0jADMgpmueDn+FyU5m7emFJlJLFFkus3qIRpxLNO6TnqIwXZQy22/Xvq5xRgeBgATu/pXVJCaPwFjcE4d+MMlmOs63uzUpRLVxnibkHdJoFdGeFAGhs5T+w1BC3efEBwUzQSUXHcUcwiyDlaNuHeL64wBvgQ9Y9s/QiPr/ppRengpZLsL7RClcZGP4tqKXJljxrmoL868uzjrHc3XyFlNc3+XEJnQnidazVr3+dlCF4DmaTSBgvDTjhHnNPYKeLVNwe9Dg3ogTRoflRDn0nPW6m3NLml5uigm0r7BI9dIGRKbjwlw8ZJVq0lHWcilWLuIN8il6ZaVqdhVHIjhh8hpw9/i+ADo7ZPB8cwAkV9KtXTeSKurVxAK1eZyXr6YgkIfNk2vW/uRXqaC8EypXXapi4Ucc7WbCv0T7L34KV82RquKfhvii4uQ9nrJIhGmE7XajjXB267MXVbvePAR3/ujU2PlCdu14XQtdX+a/k3OA/CSlR/eVcltWpz8XVGPnNxSB3w3GtOY6ACULN8BcT8LGfFIuAnBLeKE8XLhdecbbRjyGeZVq0UrvKvF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 26, 2025 at 02:07:59PM +0800, Baolin Wang wrote:
>Similar to folio_referenced_one(), we can apply batched unmapping for file
>large folios to optimize the performance of file folios reclamation.
>
>Barry previously implemented batched unmapping for lazyfree anonymous large
>folios[1] and did not further optimize anonymous large folios or file-backed
>large folios at that stage. As for file-backed large folios, the batched
>unmapping support is relatively straightforward, as we only need to clear
>the consecutive (present) PTE entries for file-backed large folios.
>
>Performance testing:
>Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
>reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
>75% performance improvement on my Arm64 32-core server (and 50%+ improvement
>on my X86 machine) with this patch.
>
>W/o patch:
>real    0m1.018s
>user    0m0.000s
>sys     0m1.018s
>
>W/ patch:
>real	0m0.249s
>user	0m0.000s
>sys	0m0.249s
>
>[1] https://lore.kernel.org/all/20250214093015.51024-4-21cnbao@gmail.com/T/#u
>Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
>Acked-by: Barry Song <baohua@kernel.org>
>Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>---
> mm/rmap.c | 7 ++++---
> 1 file changed, 4 insertions(+), 3 deletions(-)
>
>diff --git a/mm/rmap.c b/mm/rmap.c
>index 985ab0b085ba..e1d16003c514 100644
>--- a/mm/rmap.c
>+++ b/mm/rmap.c
>@@ -1863,9 +1863,10 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
> 	end_addr = pmd_addr_end(addr, vma->vm_end);
> 	max_nr = (end_addr - addr) >> PAGE_SHIFT;
> 
>-	/* We only support lazyfree batching for now ... */
>-	if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
>+	/* We only support lazyfree or file folios batching for now ... */
>+	if (folio_test_anon(folio) && folio_test_swapbacked(folio))
> 		return 1;
>+
> 	if (pte_unused(pte))
> 		return 1;
> 
>@@ -2231,7 +2232,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
> 			 *
> 			 * See Documentation/mm/mmu_notifier.rst
> 			 */
>-			dec_mm_counter(mm, mm_counter_file(folio));
>+			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
> 		}
> discard:
> 		if (unlikely(folio_test_hugetlb(folio))) {
>-- 
>2.47.3
>

Hi, Baolin

When reading your patch, I come up one small question.

Current try_to_unmap_one() has following structure:

    try_to_unmap_one()
        while (page_vma_mapped_walk(&pvmw)) {
            nr_pages = folio_unmap_pte_batch()

            if (nr_pages = folio_nr_pages(folio))
                goto walk_done;
        }

I am thinking what if nr_pages > 1 but nr_pages != folio_nr_pages().

If my understanding is correct, page_vma_mapped_walk() would start from
(pvmw->address + PAGE_SIZE) in next iteration, but we have already cleared to
(pvmw->address + nr_pages * PAGE_SIZE), right?

Not sure my understanding is correct, if so do we have some reason not to
skip the cleared range?

-- 
Wei Yang
Help you, Help me

