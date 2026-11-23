Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E867606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 10:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Tp8Y+6DM
Received: by kanga.kvack.org (Postfix)
	id 813C76B05B0; Mon, 23 Nov 2026 05:15:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EBA56B05B1; Mon, 23 Nov 2026 05:15:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 701A76B05B3; Mon, 23 Nov 2026 05:15:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 46F1E6B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:15:49 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BBFFD120830
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:15:48 +0000 (UTC)
X-FDA: 85465977576.04.001BB21
Received: from mta0.migadu.com (out-32.mta0.migadu.com [91.218.175.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id ACD4C4000C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:15:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tp8Y+6DM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.32 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795428947;
	b=c/zL8halS73pVTCp6UTauW1PfQfZTbgP0MM0jYKqq1sY/+KCfWrgmVKyUAHSuMQ3x/AceD
	VFCAKWF4rbyuMdnTA36w7ku8+jqqI8OzN+6i1eX72ReyQXLv2MF27tVpfxk8KvbpNN8S+V
	wj4BbrJRQowpq5woAcWENqMTPpE9Z+M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795428947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5VZam8o1y0qDbPb40lL86ri5OnzIJLEYJQ5jktXiFv0=;
	b=sR5Wi3cnW/GBBNJiuJ06d6QkskjnCnOMEN1xOF/xL2VLBkcKLYY1VGF3GQvxFuds9t1e9M
	+s5UCE0UMWFzQNEY3Hs1u1+WegM1lIVc/bClZK3uMCs1N9lEXagyGtEJ+lpjm0bLhHRzky
	yK2u0emgVyB7XzudBU8TzdlvV/C8dzs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Tp8Y+6DM;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.32 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JunA8M01hnMz3RMuM3CcwD3rgeX5dq0GUnfQcSCgCqU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795428942; v=1; x=1796033742;
 b=Tp8Y+6DMuRHYwvurMY48qyDWbd0vw0TdktcTwlx10+Xqft7yl2FVn9qY0rDgNlLWbF0XNToB
 GBhGZchj5OMfOz2RTBBzVPpi9wsdgt9b4V7ZM4Q6v6ZhHgYUJg4+jYEmGnUrFy87utwC32ikWLn
 ZtgoR+mE8u5I1g4F9/UpnX4M=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8cf77738964f3f07;
	Mon, 23 Nov 2026 10:15:35 +0000
X-Mizu-Trace-ID: 8cf77738964f3f07
X-Migadu-Flow: FLOW_OUT
Message-ID: <81b05a10-1b20-4132-8cc6-c71b88f21414@linux.dev>
Date: Mon, 23 Nov 2026 18:15:29 +0800
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
Content-Language: en-US
In-Reply-To: <793d63ff-c48b-431d-8a2a-4044feb45721@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: ACD4C4000C
X-Stat-Signature: sgegx4s3e45478cmykeoe44mey38iten
X-HE-Tag: 1795428946-226935
X-HE-Meta: U2FsdGVkX1/bctjDQ2F8kSjqx0up49UL0BjszaNUYa/MmnAzG3MbvPLt/ofyoMX9S9sznAZkPO+OjJ0Cl3WGxYUtKv6CzKaXXVDjWUbRdXyCZxaeix6mSzn/K8Pv1LDwPN2hVyqQL7Trm8bs7gdDTkaNdwnMSA4R00DqyWG5Uo83XKGIjETeeuobvZUZLm+bFkLD4MyV5UniRDeE8wyCg3svM2KU7/UAaBE19qk4qXI4wSSi9+3N13hk3zHIbJ6FdIkMNg6wkZd2zqsY7LLccSon11eWxzxg4uo0mI23VnruChGFAzaFgYMv9W1APn7aKYsSyD2ZIAOJB5VWZtnzbGEEAWtVzXlE8WigAcM6D6WMXDM8iwCxz4GPZI/bcpXMSmsDqGhkJr8EQe7AaCn5Bjo+kij+M/P35Eo3k8KlEIzyJZ2HiE27TETQJOfoSvS1cfopESQkFNqDM4t+n85daiDz7ACIJZtxHshiK0QCl0EHdTJWiWlY663fAy3MO38EzU8UeHPVhMOcFrwTyzfHQi57jpQtI280iOM/9CmdpOZcdK08qevMglXLu7JUgMo8Riv/xrvwBzaJsAEO/HYVV/Dm94H9MRIFRJ0bhpuIdelqfQqk7eLSEZZEvn9wItUUEF28C2zzpiyzUW3Egn6NysyJmTLPTdbPAU5vV8xDWxg3Gj2u743k7Gf2k649zcYdtkMgxTptZcSPaLgx55d29+7h4ZqYaHQsGdvG1jvPpkrzhCYfOFnm6FO+otK76dtJZAFOA07TAnSAOweB/9wAw4Lr/sPt6EQ+4H/zUFCqKmjweY6AzZliaYeP3JnXd0/CpLcF5efkKS4CeAYB1rUOIk/iZjUVj2zIewwLC6vj67GZVnMQD1PcK+FO3nNTCvgGe0jxcrLmoQE5DxjaymoVKqlnQmxTgUNjw+4i+QcobIh7RVtzuEwTaGwIDnaIoEGiNWI+jJVixvVlToAQGsB
 N3OC1CAG
 yqT4Fn2BgHgiinYnmnWZrwrDVagWdjmIg1//DsfSMWw8OrcIW+WlCSYuB1bG4Vg+Lso9GsvgEHxw4UHwzsKolmS757H6R71cBNfxj9V4M+K0J7q5Yc1Ee6V2jXHRJFn3d6YCzkCcxtKsMFiHsxytBHyTlX/wGkkHukrYYsRcfWU55CGL6RMtpG1inWBTLdwf2ptSbuQgiIl6RjB55jr1Lh4h9XYYCnXL5j/y7uLXLzGGrvrQAns45PKxgA6shUgyFEAdvnaoCkVq9IxJ/0mpzNkHPQuCP3QaxYYdqQnL9bCLDRgRsu4NxgemNR7YkIDL2sy6MCpYrz31xROUnmSBbf838t1meZ1MLiQbFeQJdQXPt8AsLUNhBdMaSnl9uirnWu6lDyj+vKJ/tYm6q10x8Nvs1ckZecGsaCpiNJcJkKIALSsAYO+NUa5MKSvju35/U007HjQkLNQUpEbb+/hLKd9Xii4/WwweSGZMohUuGZtmTIvdOeQWaaTLHGHHCJsBdaYKJVcc+VPh4r8QMIStq0h6ysqSzvYxPJZKFfM9tzHeUvizsEWSjR0HhI4WoC36W9IXMjhyusRhYBvFllnque99W0ULINzFdP9YEN4yiY8Tr5ic1fPefziclmQIstUfWNItv+njmDzRi5IEyUN/kgu67eHmW/SKHK8dJK9buFiV9dmq+oXjN8/m5Uc+KyINtmTo79gwLN2kcKBrTpL0FxSb85WKDo7NcxnrkdfVofAXan1zwRuXjDgsvyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/11/23 16:12, Hao Ge wrote:
> Hi Suren
> 
> On 2026/11/21 05:49, Suren Baghdasaryan wrote:
>> On Fri, Nov 20, 2026 at 9:14 PM Suren Baghdasaryan <surenb@google.com> wrote:
>>>
>>> On Mon, Nov 16, 2026 at 7:13 AM Hao Ge <hao.ge@linux.dev> wrote:
>>>>
>>>> kmsan_vmap_pages_range_noflush() first maps the shadow pages and then
>>>> the origin pages. If the second mapping fails, the first one is left
>>>> mapped, and the callers do not roll it back. The next vmap of the
>>>> same metadata range hits the stale PTEs again and fails with a
>>>> WARN_ON() and -EBUSY in vmap_pages_pte_range().
>>>>
>>>> Undo the shadow mapping on that error path, the same way
>>>> kmsan_ioremap_page_range() cleans up after a partial failure.
>>>> __vunmap_range_noflush() only clears the PTEs; nothing has touched
>>>> the shadow mapping, so no TLB flush is needed.
>>
>> After a second thought, kmsan_ioremap_page_range() does not skip TLB
>> flushing. __vunmap_range_noflush() comment at
>> https://elixir.bootlin.com/linux/v7.4-rc1/source/mm/vmalloc.c#L497
>> says:
>>
>> The caller is responsible for calling flush_cache_vmap() before
>> calling this function, and flush_tlb_kernel_range after it has
>> returned successfully ...". There are no mentions of guarantees that
>> mapped PTEs require explicit access to be cached. Please double-check
>> if this is safe.
> 
> That's a subtle detail. I've looked up the relevant documentation.
> You are right, and my "no TLB flush is needed" was wrong.
> 
> The Arm "Learn the architecture" AArch64 memory management guide says it
> in "TLBs and Changing translations":
> 
> https://support.arm.com/documentation/101811/0106/TLBs-and-Changing-translations
> 
> If you change a translation table entry, or the controls that affect how entries
> are interpreted, then you need to invalidate the affected entries in the TLB. If
> you do not invalidate those entries, then the processor might continue to use the
> old translation.
> 
> The undo changes the shadow PTEs, so the TLB has to be invalidated.
> 
> I also checked the Arm Architecture Reference Manual:
> https://support.arm.com/documentation/ddi0487/md/-Part-D-The-AArch64-System-Level-Architecture/-Chapter-D8-The-AArch64-Virtual-Memory-System-Architecture/-D8-16-Translation-Lookaside-Buffers
> rule R SQBCS:
> 
> If a stage of translation is enabled for a translation regime that is not out-of-context,
> any translation table entry for that stage that does not cause a Translation fault,
> an Address size fault, or an Access flag fault is permitted to be cached in a TLB or
> intermediate TLB caching structure as the result of an explicit or speculative access.
> 
> So it may already be cached by speculative access even if there was no explicit access.
> 
> For the kernel side,  Documentation/core-api/cachetlb.rst
> https://elixir.bootlin.com/linux/v7.4-rc1/source/Documentation/core-api/cachetlb.rst
> says that The "TLB" is abstracted under Linux as something the cpu uses to cache
> virtual-->physical address translations obtained from the software page tables.
> Meaning that if the software page tables change, it is possible for stale translations
> to exist in this "TLB" cache. Therefore when software page table changes occur, the kernel will
> invoke one of the following flush methods _after_ the page table changes occur:
> 
> The condition there is the page table change, not whether the range was accessed.
> 
> Likewise, I believe flush_cache_vmap() is also required.
> The sequence in cachetlb.rst is
> flush_cache_range()
> change_range_of_page_tables()
> flush_tlb_range()
> so the cache flush has to happen before the unmap.
> This is exactly the contract that the __vunmap_range_noflush() comment you quoted spells out,
> the caller is responsible for calling flush_cache_vmap() before the call and flush_tlb_kernel_range()
> after it.
> 
> The code will do:
> 
> --- a/mm/kmsan/shadow.c
> +++ b/mm/kmsan/shadow.c
> @@ -258,6 +258,13 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
>                                             o_pages, page_shift);
>         kmsan_leave_runtime();
>         if (mapped) {
> +               /* Undo the shadow mapping set up above. */
> +               flush_cache_vmap(shadow_start, shadow_end);

Sorry, this should be flush_cache_vunmap.

> +               kmsan_enter_runtime();
> +               __vunmap_range_noflush(shadow_start, shadow_end,
> +                                      gfpflags_allow_blocking(gfp_mask));
> +               kmsan_leave_runtime();
> +               flush_tlb_kernel_range(shadow_start, shadow_end);
>                 err = mapped;
>                 goto ret;
>         }
>
> Thanks a lot for catching this, I learned quite a bit about the TLB
> along the way. 
> 
> Thanks
> Best Regards
> Hao
>>
>>>>
>>>> Fixes: 47ebd0310e89 ("mm: kmsan: handle alloc failures in kmsan_vmap_pages_range_noflush()")
>>>> Cc: stable@vger.kernel.org
>>>> Suggested-by: Suren Baghdasaryan <surenb@google.com>
>>>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>>>
>>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>>>
>>>> ---
>>>>  mm/kmsan/shadow.c | 5 +++++
>>>>  1 file changed, 5 insertions(+)
>>>>
>>>> diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
>>>> index 0c88d89bf0d6..212449db34a1 100644
>>>> --- a/mm/kmsan/shadow.c
>>>> +++ b/mm/kmsan/shadow.c
>>>> @@ -258,6 +258,11 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
>>>>                                             o_pages, page_shift);
>>>>         kmsan_leave_runtime();
>>>>         if (mapped) {
>>>> +               /* Undo the shadow mapping set up above. */
>>>> +               kmsan_enter_runtime();
>>>> +               __vunmap_range_noflush(shadow_start, shadow_end,
>>>> +                                      gfpflags_allow_blocking(gfp_mask));
>>>> +               kmsan_leave_runtime();
>>>>                 err = mapped;
>>>>                 goto ret;
>>>>         }
>>>> --
>>>> 2.25.1
>>>>

