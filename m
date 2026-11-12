Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96B7A606A33D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 06:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xdv6OXXd
Received: by kanga.kvack.org (Postfix)
	id 8FD416B05B7; Thu, 12 Nov 2026 01:26:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D5926B05B8; Thu, 12 Nov 2026 01:26:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EA636B05B9; Thu, 12 Nov 2026 01:26:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 545ED6B05B7
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 01:26:34 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CC4C2140285
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:26:33 +0000 (UTC)
X-FDA: 85425483066.30.FA69928
Received: from mta0.migadu.com (out-190.mta0.migadu.com [91.218.175.190])
	by imf19.hostedemail.com (Postfix) with ESMTP id 95CDD1A0002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:26:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xdv6OXXd;
	spf=pass (imf19.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.190 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794464792;
	b=USzt07MZcKUBtNnWBL4IZzW7gedxTSEM70whviqj3CtIY/mcWA73uxe0tEPChbuWs6nxxq
	IoCya+CP+730KgBbJUWqCxGq2Wk5iWv+ddXHFH9ffSp3F3G/eQ2EQ232mqPNVJKUK92UQs
	daCzjy1Cj8V35dN7HiUu5j7qnrpHgQY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xdv6OXXd;
	spf=pass (imf19.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.190 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794464792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FzuBWSCpGeQukn6FXOSBWpNu0IM30YG8f/xbcMJEj9M=;
	b=BbkmFWil/RenlOVsttEGEpdPecAi8X7nyoc61g4JEmuvsJHOaNpgEGlWrU4hGng/iSC0LM
	IGbsxctxR5dKi/ZDJJ76A7KfbMoBi/lPVib9CM8U3WBg9/KOgwfK9sNfUH+dKaWGE1+1w8
	De2asAOZ2Z8JyWllE6EDEKiWl0+zRdg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YSdVHcPOxp7Mxpr75S83EeGKEHU4uT3ofCAOXt4L8qg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794464790; v=1; x=1795069590;
 b=xdv6OXXdejomL8Jyz21uc0ZO1TWdK2t3WFcFLwxceXm+B0C0fNYTeZ7LwgHTkmy16OJ29GNk
 izgILyNfylss6MC2zDXOz4c+0rS0DOdEGwM0hqjnTrytoKxV3wbmWkq74DfSFK34no72/4fqXNT
 YodGPR3YUvWpYFCabU8JqSAg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8df4261c904f80f8;
	Thu, 12 Nov 2026 06:26:30 +0000
X-Mizu-Trace-ID: 8df4261c904f80f8
X-Migadu-Flow: FLOW_OUT
Message-ID: <73501214-76ff-4716-bb8e-f83fff26bfba@linux.dev>
Date: Thu, 12 Nov 2026 14:27:55 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/9] mm/vmalloc: undo partial mappings inside the
 mapping functions
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
References: <20261110112546.261415-1-hao.ge@linux.dev>
 <20261110112546.261415-8-hao.ge@linux.dev>
 <CAJuCfpFHaahsCNkXCOn8ks65yj_bPy33cOLZ5BW=rtTOuedLqw@mail.gmail.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpFHaahsCNkXCOn8ks65yj_bPy33cOLZ5BW=rtTOuedLqw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7nmirj13188tudu8r58687i4g8yeug8g
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 95CDD1A0002
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794464791-224290
X-HE-Meta: U2FsdGVkX19+a98IaAl3JLqNKUi0Nkrak1hdB0RtOrET1ZehPgcUoK4ZFETV7BJmqcG5eeMg1aPjLnsOALLBb3HxpG54/4ol7wGp6J71unpoAfsIyecipZ9/IPG8ZwM61oI7OSwrnyBs5U3+T90OkSwWomI34XPqC7iR41j2meH27JmXSWLLwwfdQl2kqULSRhXvRnMFzSAKR9EjtZygseFVgW4UQ7YY/RN5WMLaUQMXnBPw0x3Mf0/9hmkrSqwZhq0LU73Bb7InAvTgfgVc6jBiEIufygpbNqZhNE18z1ekh0tEHR+kLTo8Ov7HUBI9HngWfgN7qUEG/zwZLC94c5nZ7lF9qhJostr+TpP7cdAgUvOKuQQ/l21Pg96RFnlZKxuCzZ/w3vJCuYeEAQTFAhzy7morU+2Sz/dv+99x/bR0qW15+YD0B5xtqaPAC3BnJNKv/PRGRLEdnCZE+jb2BbPy4VWZagucm8QAr8fzMEGP74rhyrW1Pnpvl0qpzT5aGcIggwSUlDaMUMroRs5c6vpRqjYy1yt5xMcP0vwzI1Nk1bHLve/4PdoR/+GCto+/mJomJLUobxKZIOf6ey++KXtP3AJ0+MHJI/R52diwhEpzFfnYpvvfIkhyeyWm/+OwbqSOdmjjRHWNZKtphFT6I3pxaMjIeZKXSxfWE4XVi9YbP3QuvuW3rhR0KMAeVvofH+yomqmK/7Ek8cmzCDeEe5/HelK88JdmcnaCkISlGRfmwTWf3bHQDXDjlTnMsv8bYIyTSlLkaIJh3Bq97KB+EoUsBa+6TgJT9/f6ACqop1SRoZKFqWes1PfVy6d+ppGch4eZCP2NwAHUFVnLaVTfoAdgdPibOGI6DpctgzSITeBhM0Akpen3UXvOUzKoX2ciJqI2tpXMNbKY1K+xW8cYYoXVPRCB2jrSK9ixE2F1mzzoaqIeuenBAxh98sW/iJOWJ9DUIoLp8Ei5GJgSs0O
 Em/cnlXn
 h9pbC3P6E3FVPph8Uj79Eps+B/xonrjXvqmAx7j/A3ZyMM8b1bKpheNr2dIiScbIwHR4PiPeaph3iXvib7cWUb4FjsmwFix1KYQBm/gXvZ13BiHbXWG6tgThNNnt0I3zEsRVqBchw05kf1fBSuzGAYlTRVVtDrunLz7bVdhr51WiXKAOCz/xQS1KqrljhVo4HbEjmLru1RGLQKkhoOQfDg7wA7tfSWXat2+lTfRlF4MQrgMWhzDZcl0dgwsGN7kYZFQRwShmKrH4wh5qLeZh7wBKlZ2Zfq26wVHRVA+ZW6Mgaf/e8YnGUs7+xoCq5nIviX54LJ6Oje5Bzw80vUZuWa+wibjawNrl+dE3ugg0GfLLbd68dPX7YOFyFeeOqiU1yM4ohwSdr4eU9Vvd6o4n2piirYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Suren

Thanks for your review.

On 2026/11/12 09:15, Suren Baghdasaryan wrote:
> On Tue, Nov 10, 2026 at 11:25 AM Hao Ge <hao.ge@linux.dev> wrote:
>>
>> The vmap entry points may install some PTEs and then fail, leaving a
>> partial mapping behind.
>>
>> The callers do not agree on who cleans it up. pcpu_map_pages() and
>> kmsan_ioremap_page_range() roll back what they mapped, while
>> vm_module_tags_populate() and the __GFP_NOFAIL retry loop in
>> __vmalloc_area_node() expect a clean range from the mapping function.
>> For them the leftovers stay mapped, and the next attempt to map the
>> same range trips the WARN_ON(!pte_none()) in vmap_pages_pte_range().
>> A leftover huge pmd is even worse. During the retry, vmap_try_huge_pmd()
>> calls pmd_free_pte_page() on it, and the x86 implementation cannot
>> tell a leaf entry from a page table and frees the mapped page.
>>
>> After discussing with Suren and Ulad, we decided to put the rollback
>> into the entry points of the vmap API rather than into every
>> low-level helper. __vmap_pages_range_noflush() undoes the whole range
>> it was asked to map when it fails, and vmap_page_range() undoes its
>> range for the ioremap-style mappings.
>>
>> The rollback is __vunmap_range_noflush(), which only clears the PTEs.
>> No TLB flush is needed, nothing has touched the mapping yet.
>> vmap_pages_range_noflush() also drops the KMSAN metadata of the
>> failed mapping.
>>
>> The undo walk skips its cond_resched() when the caller's gfp mask
>> cannot block. __vmalloc() with GFP_ATOMIC or GFP_NOWAIT can run in
>> atomic context, where cond_resched() cannot schedule.
>> __vunmap_range_noflush() takes a can_resched argument for that, which
>> the sleepable callers pass as true.
>>
>> Suggested-by: Uladyslau Rezki <urezki@gmail.com>
>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>> ---
>>  include/linux/kmsan.h |  8 ++++--
>>  mm/kmsan/hooks.c      | 18 ++++++++-----
>>  mm/kmsan/shadow.c     |  7 ++---
>>  mm/vmalloc.c          | 61 +++++++++++++++++++++++++++++++++----------
>>  mm/vmalloc.h          |  6 +++--
>>  5 files changed, 72 insertions(+), 28 deletions(-)
>>
>> diff --git a/include/linux/kmsan.h b/include/linux/kmsan.h
>> index 7da9fd506b39..0016c032d1e7 100644
>> --- a/include/linux/kmsan.h
>> +++ b/include/linux/kmsan.h
>> @@ -150,11 +150,14 @@ int __must_check kmsan_vmap_pages_range_noflush(unsigned long start,
>>   * kmsan_vunmap_kernel_range_noflush() - Notify KMSAN about a vunmap.
>>   * @start: start of vunmapped range.
>>   * @end:   end of vunmapped range.
>> + * @can_resched: whether the unmap walk may call cond_resched(); pass
>> + * false from atomic context.
>>   *
>>   * KMSAN unmaps the contiguous metadata ranges created by
>>   * kmsan_map_kernel_range_noflush().
>>   */
>> -void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end);
>> +void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end,
>> +                               bool can_resched);
>>
>>  /**
>>   * kmsan_ioremap_page_range() - Notify KMSAN about a ioremap_page_range() call.
>> @@ -355,7 +358,8 @@ static inline int __must_check kmsan_vmap_pages_range_noflush(
>>  }
>>
>>  static inline void kmsan_vunmap_range_noflush(unsigned long start,
>> -                                             unsigned long end)
>> +                                             unsigned long end,
>> +                                             bool can_resched)
>>  {
>>  }
>>
>> diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
>> index 107f66841274..0cd1edaa1120 100644
>> --- a/mm/kmsan/hooks.c
>> +++ b/mm/kmsan/hooks.c
>> @@ -136,13 +136,16 @@ static unsigned long vmalloc_origin(unsigned long addr)
>>                                                  KMSAN_META_ORIGIN);
>>  }
>>
>> -void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end)
>> +void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end,
>> +                               bool can_resched)
>>  {
>>         if (!kmsan_enabled)
>>                 return;
>>
>> -       __vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(end));
>> -       __vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(end));
>> +       __vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(end),
>> +                              can_resched);
>> +       __vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(end),
>> +                              can_resched);
>>         flush_cache_vmap(vmalloc_shadow(start), vmalloc_shadow(end));
>>         flush_cache_vmap(vmalloc_origin(start), vmalloc_origin(end));
>>  }
>> @@ -171,8 +174,9 @@ static void kmsan_iounmap_pages(unsigned long start, unsigned long end)
>>                 if (origin)
>>                         __free_pages(origin, KMSAN_IOREMAP_META_ORDER);
>>         }
>> -       __vunmap_range_noflush(shadow_start, shadow_end);
>> -       __vunmap_range_noflush(origin_start, origin_end);
>> +       /* ioremap metadata mappings are always GFP_KERNEL, so resched is safe. */
>> +       __vunmap_range_noflush(shadow_start, shadow_end, true);
>> +       __vunmap_range_noflush(origin_start, origin_end, true);
>>         flush_tlb_kernel_range(shadow_start, shadow_end);
>>         flush_tlb_kernel_range(origin_start, origin_end);
>>  }
>> @@ -207,7 +211,7 @@ int kmsan_ioremap_page_range(unsigned long start, unsigned long end,
>>                 mapped = __vmap_pages_range_noflush(
>>                         vmalloc_shadow(start + off),
>>                         vmalloc_shadow(start + off + PAGE_SIZE), prot, &shadow,
>> -                       PAGE_SHIFT);
>> +                       PAGE_SHIFT, gfp_mask);
>>                 if (mapped) {
>>                         err = mapped;
>>                         goto ret;
>> @@ -217,7 +221,7 @@ int kmsan_ioremap_page_range(unsigned long start, unsigned long end,
>>                 mapped = __vmap_pages_range_noflush(
>>                         vmalloc_origin(start + off),
>>                         vmalloc_origin(start + off + PAGE_SIZE), prot, &origin,
>> -                       PAGE_SHIFT);
>> +                       PAGE_SHIFT, gfp_mask);
>>                 if (mapped) {
>>                         err = mapped;
>>                         goto ret;
>> diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
>> index 2166086d3dc3..452760a333e4 100644
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
>> @@ -255,12 +255,13 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
>>         }
>>         kmsan_enter_runtime();
>>         mapped = __vmap_pages_range_noflush(origin_start, origin_end, prot,
>> -                                           o_pages, page_shift);
>> +                                           o_pages, page_shift, gfp_mask);
>>         kmsan_leave_runtime();
>>         if (mapped) {
>>                 /* Undo the shadow mapping set up above. */
>>                 kmsan_enter_runtime();
>> -               __vunmap_range_noflush(shadow_start, shadow_end);
>> +               __vunmap_range_noflush(shadow_start, shadow_end,
>> +                                      gfpflags_allow_blocking(gfp_mask));
>>                 kmsan_leave_runtime();
>>                 err = mapped;
>>                 goto ret;
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index 3f98056f8c7e..d1986f68eab4 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -372,8 +372,12 @@ int vmap_page_range(unsigned long addr, unsigned long end,
>>         if (!err)
>>                 err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
>>                                                ioremap_max_page_shift);
>> -       if (!err)
>> +       if (err) {
>> +               /* Callers are ioremap and arch setup code, always sleepable. */
>> +               __vunmap_range_noflush(addr, end, true);
>> +       } else {
>>                 flush_cache_vmap(addr, end);
>> +       }
>>
>>         return err;
>>  }
>> @@ -429,7 +433,7 @@ static void vunmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>>  }
>>
>>  static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
>> -                            pgtbl_mod_mask *mask)
>> +                            pgtbl_mod_mask *mask, bool can_resched)
>>  {
>>         pmd_t *pmd;
>>         unsigned long next;
>> @@ -451,12 +455,14 @@ static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
>>                         continue;
>>                 vunmap_pte_range(pmd, addr, next, mask);
>>
>> -               cond_resched();
>> +               /* The undo path may run in atomic context. */
>> +               if (can_resched)
>> +                       cond_resched();
>>         } while (pmd++, addr = next, addr != end);
>>  }
>>
>>  static void vunmap_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
>> -                            pgtbl_mod_mask *mask)
>> +                            pgtbl_mod_mask *mask, bool can_resched)
>>  {
>>         pud_t *pud;
>>         unsigned long next;
>> @@ -476,12 +482,12 @@ static void vunmap_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
>>                 }
>>                 if (pud_none_or_clear_bad(pud))
>>                         continue;
>> -               vunmap_pmd_range(pud, addr, next, mask);
>> +               vunmap_pmd_range(pud, addr, next, mask, can_resched);
>>         } while (pud++, addr = next, addr != end);
>>  }
>>
>>  static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
>> -                            pgtbl_mod_mask *mask)
>> +                            pgtbl_mod_mask *mask, bool can_resched)
>>  {
>>         p4d_t *p4d;
>>         unsigned long next;
>> @@ -496,7 +502,7 @@ static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
>>
>>                 if (p4d_none_or_clear_bad(p4d))
>>                         continue;
>> -               vunmap_pud_range(p4d, addr, next, mask);
>> +               vunmap_pud_range(p4d, addr, next, mask, can_resched);
>>         } while (p4d++, addr = next, addr != end);
>>  }
>>
>> @@ -512,7 +518,8 @@ static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
>>   *
>>   * This is an internal function only. Do not use outside mm/.
>>   */
>> -void __vunmap_range_noflush(unsigned long start, unsigned long end)
>> +void __vunmap_range_noflush(unsigned long start, unsigned long end,
>> +                           bool can_resched)
>>  {
>>         unsigned long next;
>>         pgd_t *pgd;
>> @@ -529,7 +536,7 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end)
>>                         mask |= PGTBL_PGD_MODIFIED;
>>                 if (pgd_none_or_clear_bad(pgd))
>>                         continue;
>> -               vunmap_p4d_range(pgd, addr, next, &mask);
>> +               vunmap_p4d_range(pgd, addr, next, &mask, can_resched);
>>         } while (pgd++, addr = next, addr != end);
>>
>>         if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
>> @@ -538,8 +545,9 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end)
>>
>>  void vunmap_range_noflush(unsigned long start, unsigned long end)
>>  {
>> -       kmsan_vunmap_range_noflush(start, end);
>> -       __vunmap_range_noflush(start, end);
>> +       /* The unmap paths are sleepable, keep the resched point. */
>> +       kmsan_vunmap_range_noflush(start, end, true);
>> +       __vunmap_range_noflush(start, end, true);
>>  }
>>
>>  /**
>> @@ -727,18 +735,32 @@ static int vmap_pages_range_noflush_walk(unsigned long addr, unsigned long end,
>>   * The caller is responsible for calling flush_cache_vmap() after this
>>   * function returns successfully and before the addresses are accessed.
>>   *
>> + * On failure the mapping is torn down before returning, so a retry
>> + * sees a clean range. When @gfp_mask cannot block, the teardown
>> + * skips cond_resched(), it may run in atomic context.
>> + *
>>   * This is an internal function only. Do not use outside mm/.
>>   */
>>  int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>> -               pgprot_t prot, struct page **pages, unsigned int page_shift)
>> +               pgprot_t prot, struct page **pages, unsigned int page_shift,
>> +               gfp_t gfp_mask)
>>  {
>> +       int err;
>> +
>>         if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
>>                 return -EINVAL;
>>
>>         if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC))
>>                 page_shift = PAGE_SHIFT;
>>
>> -       return vmap_pages_range_noflush_walk(addr, end, prot, pages, page_shift);
>> +       err = vmap_pages_range_noflush_walk(addr, end, prot, pages, page_shift);
>> +
>> +       /* Undo the PTEs installed before the failure. */
>> +       if (err)
>> +               __vunmap_range_noflush(addr, end,
>> +                                      gfpflags_allow_blocking(gfp_mask));
> 
> I remember we discussed this before that __vunmap_range_noflush() will
> be unmapping the entire range between addr and end instead of the
> range vmap_pages_range_noflush_walk() actially mapped and your reply
> was that this keeps things simple and avoids adding extra code in the
> common path when we do not fail. This was bothering me, so I looked a
> bit deeper and I think there is an issue with this approach.
> vmap_pages_pte_range() fails with -EBUSY if it encounters an already
> installed PTE. So, if this happens, we immediately bail out of mapping
> the range and will be unmapping the entire range, including these
> existing PTEs. I don't think that's ok.
>

You were right, I did not really think the -EBUSY case through.
when the walk trips over a PTE that is already there, everything
from that point on is somebody else's mapping, and the undo as
it stood would clear it. sorry for this.


> A fix might be quite simple. vmap_pages_range_noflush_walk() already
> counts how many pages we processed in nr variable. If we propagate
> that one level up then we could unmap only the range we actually
> mapped.

Right, thank you very much for helping sort this out. This makes
it a lot clearer.

Thanks
Best Regards
Hao

> 
>> +
>> +       return err;
>>  }
>>
>>  int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>> @@ -750,7 +772,18 @@ int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>>
>>         if (ret)
>>                 return ret;
>> -       return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
>> +
>> +       ret = __vmap_pages_range_noflush(addr, end, prot, pages, page_shift,
>> +                                        gfp_mask);
>> +       /*
>> +        * The page tables undo themselves on failure. Tear down the
>> +        * metadata that was fully set up before the mapping failed.
>> +        */
>> +       if (ret)
>> +               kmsan_vunmap_range_noflush(addr, end,
>> +                                          gfpflags_allow_blocking(gfp_mask));
>> +
>> +       return ret;
>>  }
>>
>>  static int __vmap_pages_range(unsigned long addr, unsigned long end,
>> diff --git a/mm/vmalloc.h b/mm/vmalloc.h
>> index d8372a4f65c4..9ea28845f713 100644
>> --- a/mm/vmalloc.h
>> +++ b/mm/vmalloc.h
>> @@ -40,10 +40,12 @@ void clear_vm_uninitialized_flag(struct vm_struct *vm);
>>
>>  int __must_check __vmap_pages_range_noflush(unsigned long addr,
>>                 unsigned long end, pgprot_t prot,
>> -               struct page **pages, unsigned int page_shift);
>> +               struct page **pages, unsigned int page_shift,
>> +               gfp_t gfp_mask);
>>
>>  void vunmap_range_noflush(unsigned long start, unsigned long end);
>>
>> -void __vunmap_range_noflush(unsigned long start, unsigned long end);
>> +void __vunmap_range_noflush(unsigned long start, unsigned long end,
>> +                           bool can_resched);
>>
>>  #endif /* __MM_VMALLOC_H */
>> --
>> 2.25.1
>>

