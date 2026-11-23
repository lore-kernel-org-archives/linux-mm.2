Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 300CC606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 06:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hUDhkCJR
Received: by kanga.kvack.org (Postfix)
	id 372A56B05B4; Mon, 23 Nov 2026 01:17:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3220D6B05B5; Mon, 23 Nov 2026 01:17:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 211756B05B6; Mon, 23 Nov 2026 01:17:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1DF86B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:17:39 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4E26780782
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:17:39 +0000 (UTC)
X-FDA: 85465377438.25.D38C298
Received: from mta1.migadu.com (out-248.mta1.migadu.com [95.215.58.248])
	by imf19.hostedemail.com (Postfix) with ESMTP id DD6131A0005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:17:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hUDhkCJR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.248 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795414657;
	b=T+3BXjP9lYRozp9caCNqGXHUEs6h33cGaaWKFJygpH/CFCKIqKTAyAa6mMqqsSByGDqSYF
	MXUBHWPlR7hMF7DbIgQBW7c2xhbL5WjfOLxLngHQHokK64vFxvVElHyKFDDdJnYWDsTDAF
	Hy23Z3XT+cOlg06SZTfhbOoGJE6HUoM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795414657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GOBYmPtzam1T+nLf6ejQStpL9HX+CL/GMBMiRQwuJ6c=;
	b=vZAFHzyzz1lQvlUW4GYN24diSDuWktcQFqCZsLDSko1upZpOMKWFX7EuyNzheZWAO4Ix89
	rEx+yLTZ8Taw29Kl/xXHeah0xChhkm2A2TQc5hR6mSpEvQE1B0DFI8BJWyqcRIB3dbzRWe
	o1OM+8mNMvlP4F1wT6+WHIySzlvInBo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hUDhkCJR;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.248 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=rT8PoeGFDS38g2QMBHWcyADCpxGK0iuLhNyiv06a55Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795414655; v=1; x=1796019455;
 b=hUDhkCJRJuq6GeK9Zq6uh6m/zJKtkdGuFCnx04R25XKiQCL5rCaV9TdCjE9O4YyqH5jQPyG6
 BVTlf03uMu+fI49r44TjKeRqNnnE0rqJeaTU04+25Y6ExypoKD7AF0avjsGnjNnLyF4dyrnDSSV
 kcL2eULvkj4+ZwXExaD5w7uA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7ae97a7f2b73cb9e;
	Mon, 23 Nov 2026 06:17:34 +0000
X-Mizu-Trace-ID: 7ae97a7f2b73cb9e
X-Migadu-Flow: FLOW_OUT
Message-ID: <cb8d8dc5-4ccc-408f-acaf-2f1faa0a1983@linux.dev>
Date: Mon, 23 Nov 2026 14:17:17 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/11] mm/vmalloc: skip cond_resched() in the vmap
 unmap paths when atomic
To: Suren Baghdasaryan <surenb@google.com>, Dev Jain <dev.jain@arm.com>
Cc: Uladzislau Rezki <urezki@gmail.com>,
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
 kasan-dev@googlegroups.com, linux-mm@kvack.org, stable@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>
References: <20261116071325.263682-1-hao.ge@linux.dev>
 <20261116071325.263682-2-hao.ge@linux.dev>
 <1020e36e-83bb-407b-8a6b-7669f04c26c3@arm.com>
 <CAJuCfpHtWJvs4F2L+QCMe9gMJ-qmcj4Q1G4hqVqFe6Z6gPoQ1Q@mail.gmail.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpHtWJvs4F2L+QCMe9gMJ-qmcj4Q1G4hqVqFe6Z6gPoQ1Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DD6131A0005
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: cx9w1ke7i4yzppdffyz8b3qhejsbb394
X-Rspam-User:
X-HE-Tag: 1795414656-471300
X-HE-Meta: U2FsdGVkX185m8HgFsXwrvQNJ6HdbPD5s5EZWA6iDkTCHDbUlGHRcGBs6kr5+7rXGK242Ha25Ppndk/FvZ1L2X8bJ7U26QLzkvEu7iLtPe2yoA0Q8zuFNgzT20TXsVRlmbIIdMp4XnP5vBi5pznsLi+DdpXUqQMaw+zZskFo0N9/CjUBee+/L4e0mp7v37S6H7NXi5k5Tp3aHK45nlabnH1rN3pjDpWgnpXHzsJezYmX6Xn8RMteOVoSmUtWV5IyAO3vj2F6o2cViFw0Sa8Su0SzHbWy8qyUDlzzszGTd9+cCIruJatloByF7XwWkd6Kc1cBSddPOgVgk6v4RephOyjRGcf53xVQoM4h/lHq2cmyz28aok73fu30CKAcuxTgKrk/fCUCZujZ1Pfijh66LdNj2itdjO3FdRyzOcHnlnfburLrMDry6j20q1zxvgzuAPFsDOHY7sPhlKlq2z7yCIiXrDdIcqLMG2xB13kY47G54rxTOzARs8ZNJR3I1YLu7zFK9CgHjJac+oO2BsGFaR94Cj0baUXxHRlHIns+YN/1f43qvJbSte2pbZ563GwlxjB4ofVaWI03h1gf/29NsaKIcl2nUyAgXSQgrzuoYPTZTnajfSPDyMtx91DWp7IopNBdnwDS4Tt21Kb+mM976AJXcyFgTXUdZu6tRN6jK6WqcC1w7r7n9+17Oy4VRXlxwx6hzT3KZbiSww8kTDQ0q1/v7nu1lvgJRviOtHnjopXfOGPAx6rwEerousLgHd3bxc6fpM0UEUKrnFx0iARH9LcFjnTXSiqNlH1tmRZxApQLVVLtvXpX06sZCx7iL0kYZTa0vGauHOqmvkRcGCzd7OdACDRrmPdbhZqC3fhQgEPkgZ3WPTHdjUz21aIH/LqIyeEHDC/XPNoFWoUY9bisYbrlvfOwKhiSDy5VXs6bptumYH7/+dbnd2Zc4JHKFQ1wxDitWByk8FT3tW236vi
 pWTw1lLg
 /I0Jx6Skc0ox7ypAHZ04x7SKwOSN3rL9we4DOuNfrrOHhKiKUYqEJx6oWxJd1VipDONv0qMpXOGEgwvF7rg6kc1pMW5Fkilu46dGsBai+cVZSfn85f2/xfv8U4z2dPvdBrBuQX7uSwlnByozNlkUOTTZU0eZxfgCc2zH1aUUWuh7mJHYEXFgJqUh+daMlsbvkKaNMD5Pg1l8By+NnO+LeaAPb+Z8eX0wIJ+/Xfyl7FUdIqBaDwvCqleWG2NESU7xvqFAYz9bEnw1koKHzPCw6wfvMH4+JpjJNqFk10muwY4in7sbcmtCqp4/m1xqCIkj0TN3KyhY9kHl08lIgwUQgVo+Xh6VE+4WESlFFEPhTf5Pc3PwxlmBjtaGD5oVxgno0/cfVNAVw7N1+mODujE3LyPOJ44RjZ1I5G6vVOtFyFbmHeJzk91vueVmmy3QY/oGKyOqSAwi7VIgpLtxa03PZ1EhHWkN6c/Q9XV0Z7MsJmDszdpPqPrZu4xinLzXhbxb6Ll4gbTBxq55oWFCDJq9l7TeNaBlg3H45WPn5qCOsFP+pvEdrW8F03qB6LUT+N0Gcl5FhXNsfJ0uEF9gZ9txV+s2NYR6y9W8YNLk+4bvYE9u3x5wi2Rkv9DcEa2/a07HYfOmw23Ax8yFWdyByEobgfa6hQJ5fcsNQY5hd3biFV8cWdFJUTzAJ/IqPlrAu1APjdh64QwevOfYQbmX1E8tcSrgwpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Suren and Dev

Thanks for the review.

On 2026/11/21 05:07, Suren Baghdasaryan wrote:
> On Thu, Nov 19, 2026 at 5:02 AM Dev Jain <dev.jain@arm.com> wrote:
>>
>>
>>
>> On 16/11/26 12:43 pm, Hao Ge wrote:
>>> The vmap failure paths can be reached with GFP_ATOMIC or GFP_NOWAIT
>>> since commit b186a94227b7 ("kmsan: remove hard-coded GFP_KERNEL
>>> flags") and commit 8da89ba18ed4 ("mm/vmalloc: handle non-blocking
>>> GFP in __vmalloc_area_node()"), so an undo of a partially installed
>>
>> You mention this commit too, implying that vunmap_range_noflush() can
>> be called in atomic context right now, but in this patch in
>> vunmap_range_noflush() you pass 'true' unconditionally to
>> __vunmap_range_noflush()?
>>
>> Can you give me the call chain existing in current kernel which makes
>> this bug trigger? In case it does not exist but is only triggered when
>> you add the rollback code later, then this patch is not fixing a bug.
> 
> Yeah, IIUC this is a prep patch for later changes and does not fix any
> existing issues, therefore should not have any Fixes tags and should
> not be CC'ed to stable.
> 
> Other than that LGTM.

Right, this is a prep patch for later changes. I will drop the
Fixes tag, this patch fixes nothing by itself. 

I would keep the stable Cc though. The next patch, "mm/kmsan: undo
the shadow mapping when the origin mapping fails", is the real fix
and it depends on this one. Per stable-kernel-rules.rst, patch1 in
a series should be marked for stable inclusion when patch2 depends
on it, otherwise the fix lands in stable without its prerequisite.

Or did I misread the rules?

Thanks
Best Regards
Hao

> 
>>
>>
>>> mapping may have to run in atomic context, where the cond_resched()
>>> in vunmap_pmd_range() cannot schedule.
>>>
>>> Give __vunmap_range_noflush() and kmsan_vunmap_range_noflush() a
>>> can_resched argument and skip the cond_resched() when it is false.
>>> The existing callers are on sleepable paths and pass true, so nothing
>>> changes for them.
>>>
>>> Fixes: 47ebd0310e89 ("mm: kmsan: handle alloc failures in kmsan_vmap_pages_range_noflush()")
>>> Cc: stable@vger.kernel.org
>>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>>> Closes: https://lore.kernel.org/all/sashiko-outbox-178439@kernel.org/
>>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>>> ---
>>>  include/linux/kmsan.h |  8 ++++++--
>>>  mm/kmsan/hooks.c      | 14 +++++++++-----
>>>  mm/vmalloc.c          | 24 ++++++++++++++----------
>>>  mm/vmalloc.h          |  3 ++-
>>>  4 files changed, 31 insertions(+), 18 deletions(-)
>>>
>>> diff --git a/include/linux/kmsan.h b/include/linux/kmsan.h
>>> index 7da9fd506b39..0016c032d1e7 100644
>>> --- a/include/linux/kmsan.h
>>> +++ b/include/linux/kmsan.h
>>> @@ -150,11 +150,14 @@ int __must_check kmsan_vmap_pages_range_noflush(unsigned long start,
>>>   * kmsan_vunmap_kernel_range_noflush() - Notify KMSAN about a vunmap.
>>>   * @start: start of vunmapped range.
>>>   * @end:   end of vunmapped range.
>>> + * @can_resched: whether the unmap walk may call cond_resched(); pass
>>> + * false from atomic context.
>>>   *
>>>   * KMSAN unmaps the contiguous metadata ranges created by
>>>   * kmsan_map_kernel_range_noflush().
>>>   */
>>> -void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end);
>>> +void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end,
>>> +                             bool can_resched);
>>>
>>>  /**
>>>   * kmsan_ioremap_page_range() - Notify KMSAN about a ioremap_page_range() call.
>>> @@ -355,7 +358,8 @@ static inline int __must_check kmsan_vmap_pages_range_noflush(
>>>  }
>>>
>>>  static inline void kmsan_vunmap_range_noflush(unsigned long start,
>>> -                                           unsigned long end)
>>> +                                           unsigned long end,
>>> +                                           bool can_resched)
>>>  {
>>>  }
>>>
>>> diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
>>> index a706666db097..69008b085658 100644
>>> --- a/mm/kmsan/hooks.c
>>> +++ b/mm/kmsan/hooks.c
>>> @@ -136,10 +136,13 @@ static unsigned long vmalloc_origin(unsigned long addr)
>>>                                                KMSAN_META_ORIGIN);
>>>  }
>>>
>>> -void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end)
>>> +void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end,
>>> +                             bool can_resched)
>>>  {
>>> -     __vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(end));
>>> -     __vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(end));
>>> +     __vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(end),
>>> +                            can_resched);
>>> +     __vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(end),
>>> +                            can_resched);
>>>       flush_cache_vmap(vmalloc_shadow(start), vmalloc_shadow(end));
>>>       flush_cache_vmap(vmalloc_origin(start), vmalloc_origin(end));
>>>  }
>>> @@ -168,8 +171,9 @@ static void kmsan_iounmap_pages(unsigned long start, unsigned long end)
>>>               if (origin)
>>>                       __free_pages(origin, KMSAN_IOREMAP_META_ORDER);
>>>       }
>>> -     __vunmap_range_noflush(shadow_start, shadow_end);
>>> -     __vunmap_range_noflush(origin_start, origin_end);
>>> +     /* ioremap metadata mappings are always GFP_KERNEL, so resched is safe. */
>>> +     __vunmap_range_noflush(shadow_start, shadow_end, true);
>>> +     __vunmap_range_noflush(origin_start, origin_end, true);
>>>       flush_tlb_kernel_range(shadow_start, shadow_end);
>>>       flush_tlb_kernel_range(origin_start, origin_end);
>>>  }
>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>> index ccaf158c5b7f..3c0d9e69b886 100644
>>> --- a/mm/vmalloc.c
>>> +++ b/mm/vmalloc.c
>>> @@ -429,7 +429,7 @@ static void vunmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>>>  }
>>>
>>>  static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
>>> -                          pgtbl_mod_mask *mask)
>>> +                          pgtbl_mod_mask *mask, bool can_resched)
>>>  {
>>>       pmd_t *pmd;
>>>       unsigned long next;
>>> @@ -451,12 +451,14 @@ static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
>>>                       continue;
>>>               vunmap_pte_range(pmd, addr, next, mask);
>>>
>>> -             cond_resched();
>>> +             /* The undo path may run in atomic context. */
>>> +             if (can_resched)
>>> +                     cond_resched();
>>>       } while (pmd++, addr = next, addr != end);
>>>  }
>>>
>>>  static void vunmap_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
>>> -                          pgtbl_mod_mask *mask)
>>> +                          pgtbl_mod_mask *mask, bool can_resched)
>>>  {
>>>       pud_t *pud;
>>>       unsigned long next;
>>> @@ -476,12 +478,12 @@ static void vunmap_pud_range(p4d_t *p4d, unsigned long addr, unsigned long end,
>>>               }
>>>               if (pud_none_or_clear_bad(pud))
>>>                       continue;
>>> -             vunmap_pmd_range(pud, addr, next, mask);
>>> +             vunmap_pmd_range(pud, addr, next, mask, can_resched);
>>>       } while (pud++, addr = next, addr != end);
>>>  }
>>>
>>>  static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
>>> -                          pgtbl_mod_mask *mask)
>>> +                          pgtbl_mod_mask *mask, bool can_resched)
>>>  {
>>>       p4d_t *p4d;
>>>       unsigned long next;
>>> @@ -496,7 +498,7 @@ static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
>>>
>>>               if (p4d_none_or_clear_bad(p4d))
>>>                       continue;
>>> -             vunmap_pud_range(p4d, addr, next, mask);
>>> +             vunmap_pud_range(p4d, addr, next, mask, can_resched);
>>>       } while (p4d++, addr = next, addr != end);
>>>  }
>>>
>>> @@ -512,7 +514,8 @@ static void vunmap_p4d_range(pgd_t *pgd, unsigned long addr, unsigned long end,
>>>   *
>>>   * This is an internal function only. Do not use outside mm/.
>>>   */
>>> -void __vunmap_range_noflush(unsigned long start, unsigned long end)
>>> +void __vunmap_range_noflush(unsigned long start, unsigned long end,
>>> +                         bool can_resched)
>>>  {
>>>       unsigned long next;
>>>       pgd_t *pgd;
>>> @@ -527,7 +530,7 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end)
>>>                       mask |= PGTBL_PGD_MODIFIED;
>>>               if (pgd_none_or_clear_bad(pgd))
>>>                       continue;
>>> -             vunmap_p4d_range(pgd, addr, next, &mask);
>>> +             vunmap_p4d_range(pgd, addr, next, &mask, can_resched);
>>>       } while (pgd++, addr = next, addr != end);
>>>
>>>       if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
>>> @@ -536,8 +539,9 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end)
>>>
>>>  void vunmap_range_noflush(unsigned long start, unsigned long end)
>>>  {
>>> -     kmsan_vunmap_range_noflush(start, end);
>>> -     __vunmap_range_noflush(start, end);
>>> +     /* The unmap paths are sleepable, keep the resched point. */
>>> +     kmsan_vunmap_range_noflush(start, end, true);
>>> +     __vunmap_range_noflush(start, end, true);
>>>  }
>>>
>>>  /**
>>> diff --git a/mm/vmalloc.h b/mm/vmalloc.h
>>> index d8372a4f65c4..4ec114a75f04 100644
>>> --- a/mm/vmalloc.h
>>> +++ b/mm/vmalloc.h
>>> @@ -44,6 +44,7 @@ int __must_check __vmap_pages_range_noflush(unsigned long addr,
>>>
>>>  void vunmap_range_noflush(unsigned long start, unsigned long end);
>>>
>>> -void __vunmap_range_noflush(unsigned long start, unsigned long end);
>>> +void __vunmap_range_noflush(unsigned long start, unsigned long end,
>>> +                         bool can_resched);
>>>
>>>  #endif /* __MM_VMALLOC_H */
>>

