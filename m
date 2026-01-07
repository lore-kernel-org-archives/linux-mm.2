Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E463FCF6BE2
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 01:46:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 225306B0092; Tue,  6 Jan 2026 20:46:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D2E16B0093; Tue,  6 Jan 2026 20:46:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D1E36B0095; Tue,  6 Jan 2026 20:46:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED5B56B0092
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 20:46:06 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 91D43141104
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 01:46:06 +0000 (UTC)
X-FDA: 84303477132.12.3F99D58
Received: from mail-ej1-f68.google.com (mail-ej1-f68.google.com [209.85.218.68])
	by imf02.hostedemail.com (Postfix) with ESMTP id 794D380006
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 01:46:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MiG204+O;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.68 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767750364; a=rsa-sha256;
	cv=none;
	b=cUsy5MG76NrJ5mRgkJS3qlHdBRZy58Q9yaTd0zxi2pKbi2MJIJ2h4tO/9npWI5ZIp8rGO8
	rr/dSuTEKpMNlqf6N67roJRAAOWNsd7WHogq7Sv47t/9lJc2idTa94Qp/WyyykfB67deeK
	4TDo38yvoaL+SBWJeYUxYUqLKdWY1+g=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MiG204+O;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.68 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767750364;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IeLz8B+FFA+xmUGLHkiMAf9w6+beNxbYkBoeeKfR+nQ=;
	b=OeW0dsS8pO6gmLN31gFGKbPoIipMMxmSdW+jw4evpINEAM9Is9/C82Kgb4PwjuK+EPk7d6
	jWbYZ3MNl0C8juALBlU+JHDVZkbOjczdpOXzcl35AiVhbvUSEYhC94QU4Bo0m4OIXIAEcE
	deHKw6AF4pWmZbncHENUKPZUYjWJ0dU=
Received: by mail-ej1-f68.google.com with SMTP id a640c23a62f3a-b7eff205947so217484266b.1
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 17:46:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767750363; x=1768355163; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IeLz8B+FFA+xmUGLHkiMAf9w6+beNxbYkBoeeKfR+nQ=;
        b=MiG204+OneyFP7L7hwaIhvARx0i/oLxNtfl1tirOoIHwLmk3VBI1lmNyWzNmG5/uWM
         meK3x2S4s6aLA9vSGh+KA+ePlG73lT8UHqHyIQumH8Nfx9T7k/J15jCZXfNAHfC0Yfzr
         EuQwHmBEZyL++GzyZMHXfeWFHHvDWlCGq4gqzYBisJv4LAnO2J/hvLjnzWe/3KALrrYs
         JGawnwABtRXbreAfYyB5ZyJEwhimW9nQoFgF96MPVegzAsgpQ90RcBqZcGVC+GJa33uN
         Xpoelab7cY/+tZ/LXMEUsq335UjXppB16QJkcnFZbm7U+Wy6Q6H3r9lMnz8bjHIk0PhN
         5/FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767750363; x=1768355163;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IeLz8B+FFA+xmUGLHkiMAf9w6+beNxbYkBoeeKfR+nQ=;
        b=eGvbzPQXgaoRIm5Fk4Ggc6v8cuuo8R+aS0JE0ouJUktAbq+nrI7cIz6sswNxxCW7sA
         SxK5nuSbuRCsRcwLgzr4XShaZ+3dZ5zLosMx+kkcYPpA/sAh1BCWnTGL9dHz75132IcW
         Qiam6XlTur6HoK+lUzY+j5uM49a+yNcsK+Ts+MZoQ52y1wzGuSOv4DEn1fM5nz80N13k
         JPMT+PHb9enrg67vDMuwC6Yt7tKRw+y4RAXJpoM6EeXiTzl1WQ5WZ6IC7dY7j5oB5nrH
         KuNjBWF9KrOX3gQR2R3KDxcLuKsQSykqk4qcsRYhLFiZ29dVHFU4tozBwOxlfSZXkw7c
         DSBg==
X-Forwarded-Encrypted: i=1; AJvYcCX0sQ2ac6Rwi0HdCKfmI+B0y6zzqmnGG8i0BexYcPfKWbOsvCaidLEXmWZiCC+NuB3tCpXjtBTKpQ==@kvack.org
X-Gm-Message-State: AOJu0Ywa8sYMuQWzZKwjEJZ0gwYkWeL3FGS8zIPVNaAU0tM9BI6WiLpS
	V8GLWGi+v+WVTrGIE0Gqh5CN7DNIJEfbkJ2fj+ePhENGuOxMf7kugi5u
X-Gm-Gg: AY/fxX607F/de7woNi/3eSvWzXPTJvTTCpwamHzY9h+eIfGZDoCLA+9c/oKZGa1Eclp
	NqSe/wADtTQfXY4q9tBuP/KqqUQYHYJ29eSgLRHRH1tpg0jnfSvYgxvjP0PyUMt3oNVTpXFaBGm
	SMxV0Wuxdoqn81jo0HmZz8IlZQpfPujwi08r7rOEpQvJ6Q4NKX0eifbV3qHDRSblO3+1VD7bg/x
	JtZsUAZN4FOd9sM/zl7c8QFoNnfDsSJW3iWHDhmAFLOkX5KuPoYCQizwTqDT83TeTqAFoyXGYgf
	LEkzWgPQwfUN2AYJKZcAhz3DQ0oo/9gKM/p3cAQ0VLBX3W6NCCWsZVfSwcBY0JWH75J3pi1AMBi
	Qbd3LjNdaJvyj8oIRqdxk+VnN6JuDpKrjFYs3jVjrgYEkKTnksK84VpiZud5AoGLYdW3L7vZime
	OLv6a2q5encWt93d5e7BGq
X-Google-Smtp-Source: AGHT+IFeA6mkv79CriXKt6qQAcQGV8CynmdXfqBxQvsbb+Aj2IP7Z2BA07re20HuxUP8m4dAAyg8xw==
X-Received: by 2002:a17:906:ef02:b0:b80:751:ee62 with SMTP id a640c23a62f3a-b8444c8e95bmr98318966b.14.1767750362536;
        Tue, 06 Jan 2026 17:46:02 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a230db0sm375951066b.2.2026.01.06.17.46.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 06 Jan 2026 17:46:02 -0800 (PST)
Date: Wed, 7 Jan 2026 01:46:01 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Barry Song <21cnbao@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	akpm@linux-foundation.org, david@kernel.org,
	catalin.marinas@arm.com, will@kernel.org,
	lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, riel@surriel.com,
	harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
	dev.jain@arm.com, linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 5/5] mm: rmap: support batched unmapping for file
 large folios
Message-ID: <20260107014601.dxvq6b7ljgxwg7iu@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com>
 <20260106132203.kdxfvootlkxzex2l@master>
 <CAGsJ_4yKRtyADU2ZxUMgvqdrhAEL4SpZxCMRt28gNJfUf--5zQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4yKRtyADU2ZxUMgvqdrhAEL4SpZxCMRt28gNJfUf--5zQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 794D380006
X-Stat-Signature: ajz5noksi9wobh3s15z716ye4fhueqk7
X-Rspam-User: 
X-HE-Tag: 1767750364-252668
X-HE-Meta: U2FsdGVkX1/OLaMOi9aQdvFhIRGJ/sUrymHHkaXrqG9oWXkkwGLmwHmohEWIY/++Ne1bww88CtLJXPu27SRAcUNaWSF0E5FwGHmZ3LPhD1RmX7BgqwKa40YQU3Su4AnQUFNg09t7gffdPZ67z04NPrjJil4dxG4ZZ1O2AG8XKxnekOyxLgU+8yGS776ztVoI53ZZuMivF34PpdjwF3ZF0rD+RDZq2Y4Zz0htRCWmLsPOh4jXxN3XrldpPEFDuxARwsSymjDSdB78aDm/5fgkzgxdNVs6j8CnD/TSG6PEaMiImAPWEDdFZpC6Zn0tDn9cjkH5i4reDq4jcZv77XEdToutAZEoeAm1/BAWYuh8+evcp/7sBaYqN94d6k87uDW5TUhGkk8Zdvns1zMXpzAWJ4Au7I2ifNGAM4QEoKt8oLfBOJolXH00oxnaAknnGifNJMoFG/n1H5LoqERNVVwBQDbZ9pYOjU0oHt5MiE63g0a61GqQqEwdt0s3Lvavmedn54SzSvr6v+c4OjS6NV0j1stCwmEVikh2baq5clUVoBcG/gXF9ZMBM2jP6M0H56gdC2jMkimtGkWD2SoOG84EVZ0WJDjLRoPEg2Sug6n+tif1RWns/B0SR2JexxayuoSpkYRfZmHcBDVb+Oy/DW2R/6pIVChCwI6tuoZxO+ortyIXP2BhafCqMawyqFdXPnWqzrCBpoEHw4GJ1uul/xNVY5wZ/3ESMyfBIsWLXrtRGctBSQ/8zlbMGc69EW4W99neeMPfcHXX7JbvyqZk+VIOB5cGqfRcNlDG5bPFektk6XhMi+13Y4R3bxBbOBMuBYrVNWaJhkOpLX9SWjrDOnHawElksXKXtW5xDwO0sBNEnzGxp/Y+qfSG1ThzcgN3jNPYDU1op5LBEmPcV+RbY/8OiOZarptfaBzmNIEvZ55aYgCDQE5bFHM1KV2Q0EzlxlWoZhuu0a2n5Copj4cMlK4
 cbsw3Xc4
 78g97Bso00AtIzEmd2KVf5/6sbM68peZ3gYMP7UsLSCD8Hkpy5wMjviY9BgG4otmfsLHaDorbsnSkr7YZYlzJaHbd7x2j57vstD6sxN0BvCFsQbhLYJhkhUH8gKx6a13PUtiWIE3Y8Zl3qbcFKnkklS131OsyJTTkOZOq8K43ws+0mbtoq03CcI7O+zOOUcB0fvgecDOqZ5+rmuEat+hkPtkPVmAn/Ho1ATn5+86A+Rv12cQ57jeZ+SSpAXzMYVbFbjN8cp9m1BcN036E2HwAk/bJ9SQSdR7QwTUi4o80c1u+icWIOEkHpKGevMqDBd1Kc5Mn4gJo2dIlhb8o6FBcvdQAaAEvdpouplNeHJOXrYiLCCeP3I3S+s7xuVvGtNQZQ8mWshyAN7nNx/tKDuLNdzUQbUUNaNwWTvZ2ux9uMnPQ07K07lLxrEtJzVQqdZaokypftlaOiTxkDGnE4mv8VyKBvWWjcwcXZqsohoNbfcSv+IyUUVrsyNn6igvio/duvCepFf8MGXnPowMVPPjeyOdKL59L4KLQU4/aXTI3xmaSfG/kk5WaeHpL68iFkpmf6ieIo0iczAoHccRmep81z0GTbDDxUN8kB5/kiXxKlvNFjm0QJCtpU5xjBb6/LGTehH1e6awIL3z7u+tymnyCKjZyQvXGxjtZb8t4L2lndoVGm07TL/cPt6FohplX9d0M/jahDn+pwrDD2+myTYebZTQZjcK5PAvA6GCvl375ycv/IbOVF8O572etLim5trsapb4i++R6653f+s3B+erzSozzVAhO4WewNYvRoMucHMra0m5gVwTmLtPxlQNHWyiyaxVCosBnoLl6WM7oYdtiAO/g6XAMYGnSkoVUmfiIqXLuzaVcNS5QZHYvZStdcPvlePkSoDzUtHKwCVhTAE4izrjUPHd5bh/aoVAr+P/ZZ3OAwh3HTL1SsgCUC7jShAqEcZRE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 10:29:25AM +1300, Barry Song wrote:
>On Wed, Jan 7, 2026 at 2:22 AM Wei Yang <richard.weiyang@gmail.com> wrote:
>>
>> On Fri, Dec 26, 2025 at 02:07:59PM +0800, Baolin Wang wrote:
>> >Similar to folio_referenced_one(), we can apply batched unmapping for file
>> >large folios to optimize the performance of file folios reclamation.
>> >
>> >Barry previously implemented batched unmapping for lazyfree anonymous large
>> >folios[1] and did not further optimize anonymous large folios or file-backed
>> >large folios at that stage. As for file-backed large folios, the batched
>> >unmapping support is relatively straightforward, as we only need to clear
>> >the consecutive (present) PTE entries for file-backed large folios.
>> >
>> >Performance testing:
>> >Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
>> >reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
>> >75% performance improvement on my Arm64 32-core server (and 50%+ improvement
>> >on my X86 machine) with this patch.
>> >
>> >W/o patch:
>> >real    0m1.018s
>> >user    0m0.000s
>> >sys     0m1.018s
>> >
>> >W/ patch:
>> >real   0m0.249s
>> >user   0m0.000s
>> >sys    0m0.249s
>> >
>> >[1] https://lore.kernel.org/all/20250214093015.51024-4-21cnbao@gmail.com/T/#u
>> >Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
>> >Acked-by: Barry Song <baohua@kernel.org>
>> >Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> >---
>> > mm/rmap.c | 7 ++++---
>> > 1 file changed, 4 insertions(+), 3 deletions(-)
>> >
>> >diff --git a/mm/rmap.c b/mm/rmap.c
>> >index 985ab0b085ba..e1d16003c514 100644
>> >--- a/mm/rmap.c
>> >+++ b/mm/rmap.c
>> >@@ -1863,9 +1863,10 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>> >       end_addr = pmd_addr_end(addr, vma->vm_end);
>> >       max_nr = (end_addr - addr) >> PAGE_SHIFT;
>> >
>> >-      /* We only support lazyfree batching for now ... */
>> >-      if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
>> >+      /* We only support lazyfree or file folios batching for now ... */
>> >+      if (folio_test_anon(folio) && folio_test_swapbacked(folio))
>> >               return 1;
>> >+
>> >       if (pte_unused(pte))
>> >               return 1;
>> >
>> >@@ -2231,7 +2232,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>> >                        *
>> >                        * See Documentation/mm/mmu_notifier.rst
>> >                        */
>> >-                      dec_mm_counter(mm, mm_counter_file(folio));
>> >+                      add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
>> >               }
>> > discard:
>> >               if (unlikely(folio_test_hugetlb(folio))) {
>> >--
>> >2.47.3
>> >
>>
>> Hi, Baolin
>>
>> When reading your patch, I come up one small question.
>>
>> Current try_to_unmap_one() has following structure:
>>
>>     try_to_unmap_one()
>>         while (page_vma_mapped_walk(&pvmw)) {
>>             nr_pages = folio_unmap_pte_batch()
>>
>>             if (nr_pages = folio_nr_pages(folio))
>>                 goto walk_done;
>>         }
>>
>> I am thinking what if nr_pages > 1 but nr_pages != folio_nr_pages().
>>
>> If my understanding is correct, page_vma_mapped_walk() would start from
>> (pvmw->address + PAGE_SIZE) in next iteration, but we have already cleared to
>> (pvmw->address + nr_pages * PAGE_SIZE), right?
>>
>> Not sure my understanding is correct, if so do we have some reason not to
>> skip the cleared range?
>
>I don’t quite understand your question. For nr_pages > 1 but not equal
>to nr_pages, page_vma_mapped_walk will skip the nr_pages - 1 PTEs inside.
>
>take a look:
>
>next_pte:
>                do {
>                        pvmw->address += PAGE_SIZE;
>                        if (pvmw->address >= end)
>                                return not_found(pvmw);
>                        /* Did we cross page table boundary? */
>                        if ((pvmw->address & (PMD_SIZE - PAGE_SIZE)) == 0) {
>                                if (pvmw->ptl) {
>                                        spin_unlock(pvmw->ptl);
>                                        pvmw->ptl = NULL;
>                                }
>                                pte_unmap(pvmw->pte);
>                                pvmw->pte = NULL;
>                                pvmw->flags |= PVMW_PGTABLE_CROSSED;
>                                goto restart;
>                        }
>                        pvmw->pte++;
>                } while (pte_none(ptep_get(pvmw->pte)));
>

Yes, we do it in page_vma_mapped_walk() now. Since they are pte_none(), they
will be skipped.

I mean maybe we can skip it in try_to_unmap_one(), for example:

diff --git a/mm/rmap.c b/mm/rmap.c
index 9e5bd4834481..ea1afec7c802 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2250,6 +2250,10 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		 */
 		if (nr_pages == folio_nr_pages(folio))
 			goto walk_done;
+		else {
+			pvmw.address += PAGE_SIZE * (nr_pages - 1);
+			pvmw.pte += nr_pages - 1;
+		}
 		continue;
 walk_abort:
 		ret = false;

Not sure this is reasonable.


-- 
Wei Yang
Help you, Help me

