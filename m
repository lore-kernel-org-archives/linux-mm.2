Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06590606A327
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 08:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Da3pOnl9
Received: by kanga.kvack.org (Postfix)
	id 222B86B092D; Wed, 25 Nov 2026 03:20:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D3036B092F; Wed, 25 Nov 2026 03:20:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C22A6B0930; Wed, 25 Nov 2026 03:20:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D45286B092D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 03:20:21 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EDE87160D74
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:20:20 +0000 (UTC)
X-FDA: 85472944200.30.26CB1F4
Received: from mta0.migadu.com (out-121.mta0.migadu.com [91.218.175.121])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6C8B020007
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:20:17 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Da3pOnl9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.121 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795594819;
	b=rf/HybteW82ookC7u3vECmbYlgWu/Ty8B2ns0GQHa6qcEE6GQVp200oxFN3WAIdrT/Go6V
	uSGGyrhuv4Nercsb3SZ/BJAVpSu5Wov0/b59RCf742aFo/zTYHlKgFNcOubF/wL06c8wSP
	8hLMSS1Qm4ItskvCEoh+M/9/nT7nZtk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795594819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QfZ3lG2uOxeiODVkla0mMOvEHpv7y5P99cIsSRHzDec=;
	b=u3+VstHjr3nIfoYY94vzy/jr489lciVy2VItsSEnyJ7jqBCX5GGeboPV2Wi58tI/O0pUye
	nf5O8e8yAAJ8f7D2kTT6+KNkvaPXJ7htJr4q8ar7R5RV4PotZzddyp15h70VBam6s85bYD
	20FIQl0n62pcmnoqjDPwVaOwUDQmwdY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Da3pOnl9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.121 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/919UxKRMyPlULBGJtfj9Q5QU8pqqMoGwH6XL9fnwpU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795594816; v=1; x=1796199616;
 b=Da3pOnl9Gf0AWhT1Vu8ErTtaArajV5RpoAc31hU4vyNE28S0RLbWnFnojRgMN0HZ4a4x5Hn3
 QvX2dpUEXzgX7fgp9D1vqrCfZk99zFht4TD6rO8fZD3g6gksnD4ABKparYeGJeihO0qUF2oUkMG
 VN8A/1fo6m4fjtTmIyJFjH7A=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 523a68c985d1740f;
	Wed, 25 Nov 2026 08:20:11 +0000
X-Mizu-Trace-ID: 523a68c985d1740f
X-Migadu-Flow: FLOW_OUT
Message-ID: <b63bc354-0f29-49fb-84ec-313bf4283360@linux.dev>
Date: Wed, 25 Nov 2026 16:20:00 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/11] mm/kmsan: undo the shadow mapping when the
 origin mapping fails
From: Hao Ge <hao.ge@linux.dev>
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
 kasan-dev@googlegroups.com, linux-mm@kvack.org, stable@vger.kernel.org
References: <20261116071325.263682-1-hao.ge@linux.dev>
 <20261116071325.263682-3-hao.ge@linux.dev>
 <CAJuCfpHOZS6mp_no3wKmU3-S4HKspnbriUw8Mwtxf3nmw0-pfw@mail.gmail.com>
 <CAJuCfpFv=sCeib+SDWJNW6oqbNnhT+m3YjnfKh8jNkquzuYORg@mail.gmail.com>
 <793d63ff-c48b-431d-8a2a-4044feb45721@linux.dev>
 <81b05a10-1b20-4132-8cc6-c71b88f21414@linux.dev>
Content-Language: en-US
In-Reply-To: <81b05a10-1b20-4132-8cc6-c71b88f21414@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 6C8B020007
X-Stat-Signature: 37jmzuhcnwfk3xczmohd67fye51cit63
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795594817-935677
X-HE-Meta: U2FsdGVkX1/89VlOwWWWyGVJiTDif9KR0yAMjOQRYDT/B4OFyxkz8fbe48BXYG0Mrnlo+nSnSndYZpEC8y4WZuGL5Y0fMyN+TGHJjGe3/5mUKE5VdqlsR+hZstCoulE7AczBcbeWlZuzVdMefmS2b+hSWRdfsSjPV0drS25JvqS1IprTWL8p3O2U+kRh2bKrCa7QkQy2GcTxBTJamqF2JxL8koL6BY1O+lc+dcGY6E3XlvqJOHbD0m6irkY2TQzXJyXVhelaCH6otwubhXI12Spv4+2uk6kDa0ZITCwTw5OTR5B1vfR8xVfpFkH9dgsW8gUABG6l8+oIB5IERi2RizYY5QV3ohAC1BsD10UUQNNHgHXFf9PBBAK640fnwY5oCxaVRDLhOmNytzPSIjGJct9aniJxFr7ay/a7i4dnntQLdUBeiV73IAhSsSmZxC9+D4rFPAj15Z2J897HlZAW67tGzSqYMJx7QhDtl6S74UxbRChVztyMdDKac2Nj4OMNpOSoT3bjuTmxomUzBdhRAUf9zA5/Rum/brSPXJvWWktf7cnFtjRaKT7m2SiKGSDkIzET/cWPrhMo9MaPuylBIctZThSpgWhzfEC0tc5w/wzDc/JE1jTB+1FC2jcwWjt+XX9NlV04qSQlllLBDeELXBRu3TvhqslLgEta8U6UgOsNIY14ia+8Tyhn9ChPEHCILOGvfom0mH8ZnU+QSgTgPLoaxpyJkjukY/IvyUAl5fpemDpHbRANiDyc5tv6t1TJ9HHOZHnDjDVk9zmlJIb7aMzqyuJNfMIdMuLLjX7BIMuyOa87BBkWtxfnoUzBXPMN5fvsMgBWnuKXrVHX3QDjs+ngcu4BHGpZXokYDcbr/twVSIr8bZ+8P6P4kDK6njWgkt50atf303ErRl5rcs8FH8CnZIhdcAIXLRynLn3oxLKYlw/iRVW6+pxw54VMPIops39WbE8KLnD2e07BhZv
 uB7W0L5v
 2vca+HfxblLdFVn/pILlABG/mdDuzr8Ng8UrJdZIQUzFXb7VKTzwHm79P4//D5T1mxDEwjrsSUynOwZF7ae5vGBj/G+lhckOHCIe7bpVqrRgXpq42AsZaGHYZTOxmlH+dNK1HBoD/xFrtC2U2oTgPiYH+WGu7QOQU2ZusRzcaA0jFRnvcIml4FjXwAV8Uww11PvQrcjKm08CO7IbnqncLHfbw+bc6XMNmRzj0mA6VJVvqr4jWFnfqzCCqQ+cU4jV0Uk/NBYKxeJ1QRIEFcOZss6FMIJIOBtDesPNWLpVaRhyjwwD9NtPOToQ2XFIc07Owo8oS+ffU3XTWOlYYDnoDr7CH3MtyrbHeXvbbATzqe1Ii4LPQVDfrbHQ4G/AlH4+9gT89Ha3JRuCgdyZqK84Dbz3dogxUy7ImDOkNO3+bQy2AhGRyv35DyKqsoXAgyWbwOfhVZHRC9rXaCg6NB2FC6R9oKidxC/tJXtOR8kJNQRdQSngrIWi6RXBfxk1Gk1QxwNeR2hWfrQtn/yyt+6nL4kM3Tq5EU/qirhNj4QV3NM3bA70YbvMnxXVOUgT0L/x9EaF3DjqGXhzFzVyoutwZ8kNs/1yYIqiejV3/iYt7wPeRS9PoCE3BqtXoRtHVEPB/ckoczzh8wxKHRw5KACh3ncHUsKqLI+w9EWguqMOEz8v0BB+e/mXFj9D/QMpDMo0Fo1XFojSl7LEHnXjGyym7XJc2lNtTDIzv5+FSgnPrPeb6oyUT8p+tjLMIJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Suren


On 2026/11/23 18:15, Hao Ge wrote:
> 
> 
> On 2026/11/23 16:12, Hao Ge wrote:
>> Hi Suren
>>
>> On 2026/11/21 05:49, Suren Baghdasaryan wrote:
>>> On Fri, Nov 20, 2026 at 9:14 PM Suren Baghdasaryan <surenb@google.com> wrote:
>>>>
>>>> On Mon, Nov 16, 2026 at 7:13 AM Hao Ge <hao.ge@linux.dev> wrote:
>>>>>
>>>>> kmsan_vmap_pages_range_noflush() first maps the shadow pages and then
>>>>> the origin pages. If the second mapping fails, the first one is left
>>>>> mapped, and the callers do not roll it back. The next vmap of the
>>>>> same metadata range hits the stale PTEs again and fails with a
>>>>> WARN_ON() and -EBUSY in vmap_pages_pte_range().
>>>>>
>>>>> Undo the shadow mapping on that error path, the same way
>>>>> kmsan_ioremap_page_range() cleans up after a partial failure.
>>>>> __vunmap_range_noflush() only clears the PTEs; nothing has touched
>>>>> the shadow mapping, so no TLB flush is needed.
>>>
>>> After a second thought, kmsan_ioremap_page_range() does not skip TLB
>>> flushing. __vunmap_range_noflush() comment at
>>> https://elixir.bootlin.com/linux/v7.4-rc1/source/mm/vmalloc.c#L497
>>> says:
>>>
>>> The caller is responsible for calling flush_cache_vmap() before
>>> calling this function, and flush_tlb_kernel_range after it has
>>> returned successfully ...". There are no mentions of guarantees that
>>> mapped PTEs require explicit access to be cached. Please double-check
>>> if this is safe.
>>
>> That's a subtle detail. I've looked up the relevant documentation.
>> You are right, and my "no TLB flush is needed" was wrong.
>>
>> The Arm "Learn the architecture" AArch64 memory management guide says it
>> in "TLBs and Changing translations":
>>
>> https://support.arm.com/documentation/101811/0106/TLBs-and-Changing-translations
>>
>> If you change a translation table entry, or the controls that affect how entries
>> are interpreted, then you need to invalidate the affected entries in the TLB. If
>> you do not invalidate those entries, then the processor might continue to use the
>> old translation.
>>
>> The undo changes the shadow PTEs, so the TLB has to be invalidated.
>>
>> I also checked the Arm Architecture Reference Manual:
>> https://support.arm.com/documentation/ddi0487/md/-Part-D-The-AArch64-System-Level-Architecture/-Chapter-D8-The-AArch64-Virtual-Memory-System-Architecture/-D8-16-Translation-Lookaside-Buffers
>> rule R SQBCS:
>>
>> If a stage of translation is enabled for a translation regime that is not out-of-context,
>> any translation table entry for that stage that does not cause a Translation fault,
>> an Address size fault, or an Access flag fault is permitted to be cached in a TLB or
>> intermediate TLB caching structure as the result of an explicit or speculative access.
>>
>> So it may already be cached by speculative access even if there was no explicit access.
>>
>> For the kernel side,  Documentation/core-api/cachetlb.rst
>> https://elixir.bootlin.com/linux/v7.4-rc1/source/Documentation/core-api/cachetlb.rst
>> says that The "TLB" is abstracted under Linux as something the cpu uses to cache
>> virtual-->physical address translations obtained from the software page tables.
>> Meaning that if the software page tables change, it is possible for stale translations
>> to exist in this "TLB" cache. Therefore when software page table changes occur, the kernel will
>> invoke one of the following flush methods _after_ the page table changes occur:
>>
>> The condition there is the page table change, not whether the range was accessed.
>>
>> Likewise, I believe flush_cache_vmap() is also required.
>> The sequence in cachetlb.rst is
>> flush_cache_range()
>> change_range_of_page_tables()
>> flush_tlb_range()
>> so the cache flush has to happen before the unmap.
>> This is exactly the contract that the __vunmap_range_noflush() comment you quoted spells out,
>> the caller is responsible for calling flush_cache_vmap() before the call and flush_tlb_kernel_range()
>> after it.
>>
>> The code will do:
>>
>> --- a/mm/kmsan/shadow.c
>> +++ b/mm/kmsan/shadow.c
>> @@ -258,6 +258,13 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
>>                                             o_pages, page_shift);
>>         kmsan_leave_runtime();
>>         if (mapped) {
>> +               /* Undo the shadow mapping set up above. */
>> +               flush_cache_vmap(shadow_start, shadow_end);
> 
> Sorry, this should be flush_cache_vunmap.
> 
>> +               kmsan_enter_runtime();
>> +               __vunmap_range_noflush(shadow_start, shadow_end,
>> +                                      gfpflags_allow_blocking(gfp_mask));
>> +               kmsan_leave_runtime();
>> +               flush_tlb_kernel_range(shadow_start, shadow_end);
>>                 err = mapped;
>>                 goto ret;
>>         }
>>
>> Thanks a lot for catching this, I learned quite a bit about the TLB
>> along the way. 
>>

Let's revisit this. Unless I'm missing something, the unmap counterpart,
kmsan_vunmap_range_noflush(), appears to be missing its TLB flush.

Taking vmalloc as the example:

vmalloc
    __vmalloc_area_node()
        vmap_pages_range()
            vmap_pages_range_noflush()
                kmsan_vmap_pages_range_noflush()
		    installs the shadow/origin and flushes
		    their TLB at the tail /* flushed */

vfree
    remove_vm_area
        free_unmap_vmap_area
            vunmap_range_noflush /*shadow/origin PTEs cleared,
				   no TLB flush */
            free_vmap_area_noflush() /* area -> lazy list

    ... later, when the lazy list is settled: 
    __purge_vmap_area_lazy
        flush_tlb_kernel_range(start, end);
        /* no shadow/origin tlb flush */

So unlike the normal paths, KMSAN performs the TLB flush when the range
is reused and re-mapped, rather than flushing it immediately after unmap.

I'm not sure this is safe. Reading the documentation, this should not be safe,
perhaps I have misinterpreted the documentation.
If this was intentional, maybe a TLB flush is not required here, but if so I would
expect it in the purge instead, together with the main range. After all, vmalloc is
frequently called, and lazy TLB flushing is an existing optimization for vmalloc.

Would you mind taking a look at this concern, or letting me know who I could ask?
This would be a good opportunity for me to brush up on my TLB knowledge, and I would
greatly appreciate your input.

Thanks
Best Regards
Hao

>> Thanks
>> Best Regards
>> Hao
>>>
>>>>>
>>>>> Fixes: 47ebd0310e89 ("mm: kmsan: handle alloc failures in kmsan_vmap_pages_range_noflush()")
>>>>> Cc: stable@vger.kernel.org
>>>>> Suggested-by: Suren Baghdasaryan <surenb@google.com>
>>>>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>>>>
>>>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>>>>
>>>>> ---
>>>>>  mm/kmsan/shadow.c | 5 +++++
>>>>>  1 file changed, 5 insertions(+)
>>>>>
>>>>> diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
>>>>> index 0c88d89bf0d6..212449db34a1 100644
>>>>> --- a/mm/kmsan/shadow.c
>>>>> +++ b/mm/kmsan/shadow.c
>>>>> @@ -258,6 +258,11 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
>>>>>                                             o_pages, page_shift);
>>>>>         kmsan_leave_runtime();
>>>>>         if (mapped) {
>>>>> +               /* Undo the shadow mapping set up above. */
>>>>> +               kmsan_enter_runtime();
>>>>> +               __vunmap_range_noflush(shadow_start, shadow_end,
>>>>> +                                      gfpflags_allow_blocking(gfp_mask));
>>>>> +               kmsan_leave_runtime();
>>>>>                 err = mapped;
>>>>>                 goto ret;
>>>>>         }
>>>>> --
>>>>> 2.25.1
>>>>>

