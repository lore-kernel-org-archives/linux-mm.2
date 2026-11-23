Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 095BD606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 10:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=oR3Dklxi
Received: by kanga.kvack.org (Postfix)
	id 2D5666B05B3; Mon, 23 Nov 2026 05:50:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2866A6B05B6; Mon, 23 Nov 2026 05:50:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 175876B05B7; Mon, 23 Nov 2026 05:50:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E0A516B05B3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:50:53 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6C3741602C4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:50:53 +0000 (UTC)
X-FDA: 85466065986.16.5D66D98
Received: from mta1.migadu.com (out-128.mta1.migadu.com [95.215.58.128])
	by imf24.hostedemail.com (Postfix) with ESMTP id C658D180003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:50:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oR3Dklxi;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.128 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795431050;
	b=VxdpHCMzZXF6cCMf513bpP6Ci6IF1z5U6CiM+y6HVnzOhDxq4wRxYHmnldy9ZGTvXWZcjG
	JybKmRgA13DB1Mz/salno5VhSiaB7EYZ0J8vnvItuLQlGJg2ylv+vagotIg+ClVZRgxF87
	p+LH7RIfGoOpgIg1InXM76+FlWgfUOg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795431050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vhvizTOCvV4TIlk2GcF40P/D+TPRIEQFdThENdsfieo=;
	b=4arwV0x0QDUHbfgwCGOXN9/7S8aEDnBPSLa4PeI1yMItC16z7AMaO5tWbYOFpEpzfcBfAb
	ljQ5PH8Ibaz1lkkCJXTMSzrwB9b5NBWqD72hIXj7hFtH5+isI2gjKTbeD0giZRiSzwqf6l
	a1MtAbjTCYxM2t+n88ER4IsrqbzRWxA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oR3Dklxi;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.128 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=viMFF8KDVrzt4/XX4zUzvKF7yd+58lRueswEeUuhWIA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795431048; v=1; x=1796035848;
 b=oR3DklxiA5CoSXAZwGsWaPrByW1kvROR7Kr3EoFwViPCxlgljJ+wob3xqCEsNUDPT8i4+ST3
 L7NIxTpQLucT7oY9wprkbBPdYbIZjVyg2v7V1n+r5GQj/tG3KRlrJvckZeMy4Jcr7lQV2yd5Ln4
 1fKa6HHBU/ZzBB6IKR2uZSHY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6aa3c8c191b175a9;
	Mon, 23 Nov 2026 10:50:35 +0000
X-Mizu-Trace-ID: 6aa3c8c191b175a9
X-Migadu-Flow: FLOW_OUT
Message-ID: <7fad5338-7e9e-4fcf-b369-20f80639a9e4@linux.dev>
Date: Mon, 23 Nov 2026 18:50:28 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/11] mm/vmalloc: undo what
 __vmap_pages_range_noflush() mapped on failure
To: Suren Baghdasaryan <surenb@google.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org
References: <20261116071325.263682-1-hao.ge@linux.dev>
 <20261116071325.263682-8-hao.ge@linux.dev>
 <CAJuCfpFvA5oqop2tovy33fKydx7n8Sm=X-hE0sJxpcR1gg5hMA@mail.gmail.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpFvA5oqop2tovy33fKydx7n8Sm=X-hE0sJxpcR1gg5hMA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: C658D180003
X-Stat-Signature: fud6wxq44ff7xpgroy9h851zcnpbd1o1
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795431049-537395
X-HE-Meta: U2FsdGVkX18HbzWMWoq+9m7cVD9H+PFJ7JGVlygVElCDSc04vw3faRh7hPY/FcqEWgW9PbvvzFa2szRyDf8mrQkdKwvzDHB55HlHmUeBTBpPoehrYZFx9fs5gySMGuh2hJ+8JramwPIqLlzXIE6iXLRE6dK2ZGa9144MAk4wXLIZefT5OSU5169tOKct+5WdAyHc5OVYfdzTAT3Fy4vvol1l1bG9KAbHIFtT8k+hKsbXGmGLcQg/sDi4+HN3ea0+4g6ihalWszgqNaNDkA+MbNURnKNfHnchJNy2JJK8KyWyg3GcN3vKSzHzNY2RRk891ClWlFudm0EHd4f/stx1SyCjlBew4cHbCqMC0G2YioALQCwHDuQk8MuHxWe0OCzOWEJm1jdUxj3s9nFCoO/yMtzTStPyiued1MwqffX7+R0XoDBNeCmILCR3qq6vuIXAkgLLO3lvz/jCRbbJYNXhVtIIeXRRqqc9wg2h4Uq0EMyNUHPYemBRyr/Lq+Zo2rMYkt0LdI5v+HOeCsn4AdEmIJukO7UnXkBYTr5uvhyTArqKSRU1W3V3esLr8co58r6wik4FGAUUYz6I+drCj4B44iL7bGlN9wVNQUUSoNrcsl19yEiLc3UCcFsh6MVC8t3aJ1nbPQ+Y9174l9C4BRltS4DMmIJgH6jXZUW5GIFu3cF9X0zwLYsHguc19+F6WyM1z4D5BgtiVYOVJIMxayPBmTyh3MLcoPQaVHz2m9FoiTAayk/a2ktmYPut+iQkZ1HdjC78/59bIU0HaciMNwzV/EQRRpv6reX7gLVHj3q29Wdm8InJxJlsSQb+PB5F/CSaEfHHVNqUguuAwvcpmQncyI+mL9lTYzRsZQf02irwYQgral4CRM5H73qIppv2WDgevfwCFJFqkJMCUDSe42tdk6jOHXthOKOQ4pK/+e4ibRhHL3DbagUQ10MbNvkcXy606NLE3W2sOFypPBn6oO3
 UvzKHOB0
 tStO63TwdJebcx9ICFFbuglrRS5tFeDDNkhcUs3rX0hGaanW5xgCOZqRIE307tFOE1SCw7jEyYbDYEfJehAOm57BnLwSvSxbhSgza1eKexafjFRLMxRZ4xG95NtGse6X0xUUtXefLaaC5OpZCoHz4Y2y/x376LFGjrkQOvcVqLlaCttTg7rSNknZn6+cQBM5U3hRX6AAYeeZBCjQKDVFenb18/0235TB+g6f/G5pSMSV1gFYjTZkoUlff9QJ6Rk/AuXTi1WvsY+8uluvNEXycgBwvjgu7QcJP+9vaEA+oyiA1E8YnkskkpsRFfVtiydNAh5zCatnQ2REgnQfiZv/KvA90qogkrQP5uaJESGeQIV4m00MrVK44Kw7nN7pn3eJMH1/qLaVwP0ZP3PqtNciwIoM7GK7IrPVn1JFzaiVTeoSt9yNJcerBqaNeCMTAUut9YOH//iYyWisxVjUMZiAGoLhXlodgPiRqCm0OgYrmQfzW1yBQLU3tUZxUVb5vDuzSpUXNLzcG1RUWf858IXNefz3p52KIbKtBREUQbFncEbvjLevomGTxVNNLumQrPiMewvaIKRlBUJ4X0xveaoec0mTE1pDpGyyDdNe5CttpwKCfLoo2H+FByVhkD0MWdi9lTCgixhSdfNVjlMtH1TW/+x019UiRv/oMPzDANFBAPykDF1l4GP6WM5ka3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Suren

On 2026/11/22 11:58, Suren Baghdasaryan wrote:
> On Sun, Nov 15, 2026 at 11:14 PM Hao Ge <hao.ge@linux.dev> wrote:
>>
>> __vmap_pages_range_noflush() maps a struct page array and may fail
>> half way. The ptes installed so far stay behind, so a retry of the
>> same range, the __GFP_NOFAIL loop in __vmalloc_area_node() or the
>> module tags populate, trips the WARN_ON(!pte_none()) in
>> vmap_pages_pte_range() and fails with -EBUSY.
>>
>> vmap_pages_range_noflush_walk() now reports how many pages it
>> installed through its running index into the pages array, and
>> __vmap_pages_range_noflush() undoes [addr, addr + mapped_pages *
>> PAGE_SIZE) on failure. vmap_pages_pte_range() fails with -EBUSY
>> instead of installing over a pte that is already set, so the ptes
>> below that point are all ours, while a pte above it can only have
>> been put there by somebody else, for example when the caller's range
>> overlaps an existing mapping. Going further would clear ptes that
>> are not ours.
>>
>> This path can run with a non-blocking gfp mask, the undo passes
>> gfpflags_allow_blocking() as can_resched.
>>
>> Suggested-by: Suren Baghdasaryan <surenb@google.com>
>> Suggested-by: Uladzislau Rezki <urezki@gmail.com>
>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>> ---
>>  mm/kmsan/hooks.c  |  4 ++--
>>  mm/kmsan/shadow.c |  4 ++--
>>  mm/vmalloc.c      | 36 +++++++++++++++++++++++++++++-------
>>  mm/vmalloc.h      |  3 ++-
>>  4 files changed, 35 insertions(+), 12 deletions(-)
>>
>> diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
>> index 69008b085658..d830a4e649f1 100644
>> --- a/mm/kmsan/hooks.c
>> +++ b/mm/kmsan/hooks.c
>> @@ -208,7 +208,7 @@ int kmsan_ioremap_page_range(unsigned long start, unsigned long end,
>>                 mapped = __vmap_pages_range_noflush(
>>                         vmalloc_shadow(start + off),
>>                         vmalloc_shadow(start + off + PAGE_SIZE), prot, &shadow,
>> -                       PAGE_SHIFT);
>> +                       PAGE_SHIFT, gfp_mask);
>>                 if (mapped) {
>>                         err = mapped;
>>                         goto ret;
>> @@ -218,7 +218,7 @@ int kmsan_ioremap_page_range(unsigned long start, unsigned long end,
>>                 mapped = __vmap_pages_range_noflush(
>>                         vmalloc_origin(start + off),
>>                         vmalloc_origin(start + off + PAGE_SIZE), prot, &origin,
>> -                       PAGE_SHIFT);
>> +                       PAGE_SHIFT, gfp_mask);
>>                 if (mapped) {
>>                         err = mapped;
>>                         goto ret;
>> diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
>> index 212449db34a1..452760a333e4 100644
>> --- a/mm/kmsan/shadow.c
>> +++ b/mm/kmsan/shadow.c
>> @@ -247,7 +247,7 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
>>         origin_end = vmalloc_meta((void *)end, KMSAN_META_ORIGIN);
>>         kmsan_enter_runtime();
>>         mapped = __vmap_pages_range_noflush(shadow_start, shadow_end, prot,
>> -                                           s_pages, page_shift);
>> +                                           s_pages, page_shift, gfp_mask);
>>         kmsan_leave_runtime();
>>         if (mapped) {
>>                 err = mapped;
>> @@ -255,7 +255,7 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
>>         }
>>         kmsan_enter_runtime();
>>         mapped = __vmap_pages_range_noflush(origin_start, origin_end, prot,
>> -                                           o_pages, page_shift);
>> +                                           o_pages, page_shift, gfp_mask);
>>         kmsan_leave_runtime();
>>         if (mapped) {
>>                 /* Undo the shadow mapping set up above. */
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index 5c1eacc2a0ac..4f3c320a4849 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -725,7 +725,8 @@ static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
>>   * may have contiguous chunks, as hinted by @shift.
>>   */
>>  static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned long end,
>> -               pgprot_t prot, struct page **pages, unsigned int shift)
>> +               pgprot_t prot, struct page **pages, unsigned int shift,
>> +               unsigned int *mapped_pages)
>>  {
>>         unsigned long start = addr;
>>         pgd_t *pgd;
>> @@ -748,6 +749,7 @@ static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned long end,
>>         if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
>>                 arch_sync_kernel_mappings(start, end);
>>
>> +       *mapped_pages = nr;
>>         return err;
>>  }
>>
>> @@ -758,18 +760,36 @@ static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned long end,
>>   * The caller is responsible for calling flush_cache_vmap() after this
>>   * function returns successfully and before the addresses are accessed.
>>   *
>> + * On failure the PTEs installed by this call are torn down before
>> + * returning, so a retry sees a clean range; PTEs that were already
>> + * there when the walk failed are left alone. When @gfp_mask cannot
>> + * block, the teardown skips cond_resched(), it may run in atomic
>> + * context.
>> + *
>>   * This is an internal function only. Do not use outside mm/.
>>   */
>>  int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>> -               pgprot_t prot, struct page **pages, unsigned int page_shift)
>> +               pgprot_t prot, struct page **pages, unsigned int page_shift,
>> +               gfp_t gfp_mask)
>>  {
>> +       int err;
>> +       unsigned int mapped_pages = 0;
>> +
>>         if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
>>                 return -EINVAL;
>>
>>         if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC))
>>                 page_shift = PAGE_SHIFT;
>>
>> -       return vmap_pages_range_noflush_walk(addr, end, prot, pages, page_shift);
>> +       err = vmap_pages_range_noflush_walk(addr, end, prot, pages, page_shift,
>> +                                           &mapped_pages);
>> +
>> +       /* Undo the PTEs installed before the failure. */
>> +       if (err && mapped_pages)
>> +               __vunmap_range_noflush(addr, addr + (mapped_pages * PAGE_SIZE),
>> +                                      gfpflags_allow_blocking(gfp_mask));
>> +
>> +       return err;
>>  }
>>
>>  int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>> @@ -781,7 +801,8 @@ int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>>
>>         if (ret)
>>                 return ret;
>> -       return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
>> +       return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift,
>> +                                         gfp_mask);
>>  }
>>
>>  static int __vmap_pages_range(unsigned long addr, unsigned long end,
>> @@ -3715,7 +3736,7 @@ static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
>>                 pgprot_t prot, struct page **pages)
>>  {
>>         const unsigned int nr_pages = (end - addr) >> PAGE_SHIFT;
>> -       unsigned int prev_shift = 0, batch_idx = 0;
>> +       unsigned int prev_shift = 0, batch_idx = 0, nr_mapped;
>>         unsigned long batch_start = addr, batch_end = addr;
>>         int err;
>>
>> @@ -3734,7 +3755,8 @@ static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
>>
>>                 if (shift != prev_shift) {
>>                         err = vmap_pages_range_noflush_walk(batch_start, batch_end,
>> -                                       prot, pages + batch_idx, prev_shift);
>> +                                       prot, pages + batch_idx, prev_shift,
>> +                                       &nr_mapped);
>>                         if (err)
>>                                 goto out;
>>                         prev_shift = shift;
>> @@ -3756,7 +3778,7 @@ static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
>>         /* Remaining */
>>         if (batch_start < end)
>>                 err = vmap_pages_range_noflush_walk(batch_start, end, prot,
>> -                               pages + batch_idx, prev_shift);
>> +                               pages + batch_idx, prev_shift, &nr_mapped);
>>
>>  out:
>>         if (!err)
> 
> So, you are recording nr_mapped but not undoing
> vmap_pages_range_batched() partial mappings yet. You do that in patch
> #9. It's weird to fix one place but leave the other one until later. I
> would suggest merging patches 7 and 9 to have a complete fix.

Yes, that looks correct when revisiting these patches.

Thanks
Best Regards
Hao

> 
>> diff --git a/mm/vmalloc.h b/mm/vmalloc.h
>> index 4ec114a75f04..9ea28845f713 100644
>> --- a/mm/vmalloc.h
>> +++ b/mm/vmalloc.h
>> @@ -40,7 +40,8 @@ void clear_vm_uninitialized_flag(struct vm_struct *vm);
>>
>>  int __must_check __vmap_pages_range_noflush(unsigned long addr,
>>                 unsigned long end, pgprot_t prot,
>> -               struct page **pages, unsigned int page_shift);
>> +               struct page **pages, unsigned int page_shift,
>> +               gfp_t gfp_mask);
>>
>>  void vunmap_range_noflush(unsigned long start, unsigned long end);
>>
>> --
>> 2.25.1
>>

