Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0294CC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 10:01:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D07906B0005; Mon, 13 Jul 2026 06:01:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB8E06B0088; Mon, 13 Jul 2026 06:01:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B596D6B008A; Mon, 13 Jul 2026 06:01:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 830776B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:01:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 848BE1C9772
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:01:36 +0000 (UTC)
X-FDA: 84983311392.20.CA41EA5
Received: from mail-pz2-f1.google.com (mail-pz2-f1.google.com [74.125.228.1])
	by imf20.hostedemail.com (Postfix) with ESMTP id 91AF01C0002
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:01:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BAcy74zv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783936894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FSlUy9WbjXtCnNvsD1TwPaFSZEhEdPhXQRv5pMImEzA=;
	b=g5j5HXYZpXaTBH7/Z5BnfYSS7oGtgC9JAkHuA/jK8AP4nrJc+LZv2lC2hyj3bH5qxq74AB
	i+Zasy9+1zlj5iW1eM5umA3SyMLuJcJR6sERederrKI8CNxU5Wny+HR8J0n16WuW4Q7phS
	Xu7fOj6fo3N7c1POWH3lZs6S+S+HhEw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BAcy74zv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783936894;
	b=NvmrhWyCf7xfeltFAYqBuycB7UjgKNjROqnWBp+k4zd+SPL7TEiCYaqkQfiEFNlqpZqNd4
	Bw0YhvHxu3EB16s3c6nGprOSoSD6e6x+zv1spHf8cmD0axZs9iVwrXqVoxgIz3Y4AV5KiW
	9D2ZmZo7ShLW2WUY6vZP0Mx3kx0L8Y8=
Received: by mail-pz2-f1.google.com with SMTP id 41be03b00d2f7-ca00ea47337so1370834a12.0
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783936893; x=1784541693; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FSlUy9WbjXtCnNvsD1TwPaFSZEhEdPhXQRv5pMImEzA=;
        b=BAcy74zvMee0dOlR3V8PsoU01CeiSRekHYd3QZH7kRzhbrRcvayOW5Rbzy9KX49L8/
         76f4nKnzzSaXg5Jqt2UGp1tCxk40e4wrCulks4OnprxGwVpNbyvH2qmnugWP+dbz0CbX
         P0yythLNmUrSDTsZwqPKgrcPqzEhsKD9jB5hnWNdIv26uY4spdpqn9PT5bvlLzTptLZC
         sRyXIGaez8OHIwY/ATO8LMuncs+IESq8kGsXwKhkcKbyP19LRXGcVxe8ZUMFZNncYu/Z
         slAY2eY0/4tpIsEiQ/OXGk9C73Rf2mHUOQqKwIr8mBn3dYXAmMchkODDdWg9VrcZmw8S
         tfLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783936893; x=1784541693;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FSlUy9WbjXtCnNvsD1TwPaFSZEhEdPhXQRv5pMImEzA=;
        b=YueB3LfsMNyOV/e0R4Eg9wMlK5PbZwcDAENmwkyyoyHU/ghOaC6PeI0XvDJPLScr9D
         7YPwcB7mSgCUEyNyHhSHAYD3s4z3aNYcqHi/b/PVHcyO8prsdgwqhnqh5LMNfvufpfNo
         q2FdTVMQbPaEzBnSKG254jQlI5bM4HzK4tylpfwI4bJGpyMeatTYL+mtvjfIInCwr5ED
         3b/u74Hd2Mp6vDdmDpKRoGwL8a1jKs/nmqdWbdJkFRZk+6IxKORbBk5cFBq46SxetT6P
         KVxzSydqOnVV8vYSJwnv9DxjiapxSs94QHbBnHj/WFICIwsv7H+VbtFGHro6kfWJp3E6
         MrnQ==
X-Forwarded-Encrypted: i=1; AHgh+RozZI3//KgD5ApSZhVXK7yMV+W3U/Fj7RZTPD3qYTWnS8fxhXWCwoNSs8Z6EHWzld7LoAKL/voBMQ==@kvack.org
X-Gm-Message-State: AOJu0YyPO0h0TaXja9qbUjPqEV0s+t1PsNrazmRhGfumWoKDf84OBPT3
	CNqSr86wgdoj6w8xB/1j6c+ecZUufgvOVXIivrmppGCtFtnwt+rNaRzQ
X-Gm-Gg: AfdE7cmijbp1FMV0045sgDqIl4Jq/LwVGZ1d+JVw7jBUS3w2qDd6e4bS9j9sYScaoB6
	WARrIDnjwjnprVqY/L9F5QPb0DCDY6Gdhc1Fa+qvi1nqdzIPN3M/SeytrlpfQ603f6hJQvOJnUJ
	FTViMGwhsc8yTBL3XdGli00P0od0+jT1ECoYZlbZLwEtjxlGJfJuoEfsZmch85JxhhqxRxGY1SK
	YezZLdOTnfAJ97bQ9hc/Kv391Wb83dHeCe29z/5d2df6tPdDO5R+Ryq75myMHpglPA7FE9cikk7
	T1qZIwBrOBCguQdV+US4bjG+UAXzyfYReGcVTb+dMDnSBTMj/Ktb4/YBjVdsQ9gViXaSHz2Idp9
	Fiaj+NPWKHI4MpRiXPmggMOgZrGVrdqyQvNIxHIOl0AuQ+vdGYd0SWclizL4szzkanBj84mGjaA
	mfqC8L733V6dmfKE9eAug2CavYgRoGEk0=
X-Received: by 2002:a05:6a00:b4a:b0:845:31a6:d84d with SMTP id d2e1a72fcca58-848896c3a47mr6968494b3a.7.1783936893057;
        Mon, 13 Jul 2026 03:01:33 -0700 (PDT)
Received: from [10.125.112.20] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6d4dbdesm13719717b3a.31.2026.07.13.03.01.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2026 03:01:32 -0700 (PDT)
Message-ID: <11416999-ee51-4775-b346-c9b9d5ee42d4@gmail.com>
Date: Mon, 13 Jul 2026 18:01:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Wandun <chenwandun1@gmail.com>
Subject: Re: [PATCH v2 4/4] mm/mlock: migrate folios out of CMA when mlocking
 a range
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: vbabka@kernel.org, david@kernel.org, rostedt@goodmis.org,
 mhiramat@kernel.org, Alexander.Krabler@kuka.com, hughd@google.com,
 fvdl@google.com, bigeasy@linutronix.de, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, akpm@linux-foundation.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, riel@surriel.com, liam@infradead.org, harry@kernel.org,
 jannh@google.com, lance.yang@linux.dev, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, pfalcato@suse.de
References: <20260707125925.3725177-1-chenwandun1@gmail.com>
 <20260707125925.3725177-5-chenwandun1@gmail.com> <ak0OZKzapUefmA3v@lucifer>
Content-Language: en-US
In-Reply-To: <ak0OZKzapUefmA3v@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 91AF01C0002
X-Stat-Signature: cwcqrbdz7rearc7g7sszb7kadqrg8job
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783936894-940067
X-HE-Meta: U2FsdGVkX198OkWgH4ZKY8vqEp8zUCgpnHuutdKMQw/5wsn1GQ98Fc5GDJSEd6liJF9OoiEf1pz7MVxsJazHLYV6Wn5aQ/YdzRgDL5/FxnE9h/H2jNX+NUTH4SsygvSh6ess0gx7QWRYe/dclmF7n48FZP/I9KmzideiQR0na0ZVFjC6S1m9TWKY1U1Mgdw3tyOzUwJLUSkAUlQ/7ZoP/VNXW6BlHsa7o9Tz2D1nY4WkGj9smYDfkujnybAn24yj6s5/wnBkQA58T2EdtnHHk/jyuRBJJCPEEmsfeFK8SWEeLUgW/dTpfxHfxU7AOsvyaNSd5F5lKjuhSEuTfLvAldWlzbBQlwamoWkQNubQ7PLQD8k/FIfFFBqu78WaretQaYTqb3wul1JMbvITTZiwgA2Q0t6fMfMNAJtt3vRzILEnzlpQ8ezGpkMBR3JdrE/6dBrBf9qeDLNAVrhJBrHA7nRxe8/gXSxNAVOcp1cduhyDs4l2MIpInT05ThG9AfnhmvvGXzYEunSVTf/FnoAA4dyY7m8XvxyqKSK80EhH7+6mm36PrNebn/3T24IynjhCr671KZJrvAiNNvVITDMQFZBq1Snv8iPy65Ml7FR8zbHVhWC2IB/3c63DwCofrhvABssXHbJ2VwB9KOkH+5RQBse0QaovcRSbqK7VqnPORGd/mz1BaLYuQg5fcl8JBkonziB7YxdfPbH95f6Xxss9bUm2O7MfDYKmxSaYZaDYJpr6EcZezS2HTAnvNichj49nwxTNkpgEVIamAGOSbCmaniH5UKcw+FFAQwTsdMNrmjAmh9BGFzQ4GzeYOpRwCdYqj1w9/niMnrCVFUYhf8Yi15o5Ui99Kn/xrEGoXL/BmTWepKf3E2bvnadj3RQkQQFRdVujT2q5bwNRrHMKNCwCIFymhwXGDmv+tARRbYNrQCYD/lvjaaPktqyHilnvHUMmciIiwvxaIsQOKhd0FRw
 Gut1NuvB
 nFn15KmCSBO1hkRRwuHbhqAIZ+J1IZbVrwDJqUgi1+5M7xletw+cf+UI1AArkk4CHxbB3zd9hxLXCWmMWCS3/HKE7a8tIA+/AiUT+l+aO+/DuP4HvSTkAjR4W7s4iITXHe9/IW3Ymr1KwH0mZBkTEK8qU7nmCUdXYVMwbaYfblVH5b6dazlJTzqAvHmFEY+A3RRbKFGsCcfpttySetJvjbvIHmurOwCsssSdXypOHUoGABRMaIkSQLuT/zac1+BFueT3e1dDA0ZRcDdI9z4ysIjfNzh4PzZ/y1My2hbgT9DWV3GER2RlQN3Ry/s0CBR/i1x/JXxGJ3gn0doXbzVIkzKsT7UlrwFHKFgj9IGic/GqqICI5bk68bcTn/aisTWtZOa+Xw5JTvbiGgsnujLj9HOHRH0XbC8oXQAqTj4Ds6vzBlEn8OnrsjJEXpgMstjb33RA+b5Zg/YUqUO0Qr8OVoM9Oir6Iz5PBgAxJnL90V0NXVEzRsR6rGVN4Em7x5DjCsWQJ0iwxz4TsCIVCcX7uGOkRC3dy+QfIgR1vvvApyQEaxbs+BR+X45LutsVW3WBXOgiMR+MXy6k+EUvuLZqqRII568C5W9dlB+5HxoYVzBpEXIX6PD0mhXCc/p0WTsZNqhZCb7V1zVgC6eM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/7/26 22:54, Lorenzo Stoakes wrote:
> On Tue, Jul 07, 2026 at 08:59:25PM +0800, Wandun Chen wrote:
>> From: Wandun Chen <chenwandun@lixiang.com>
>>
>> The region covered by mlock[all] may contain CMA pages. cma_alloc installs
>> migration entries in the page table, if a memory access occurs at this
>> point, it must wait for the migration to complete, which may cause
>> latency spikes on the RT kernels.
>>
>> Try to move the migration cost into the mlock[all] caller, which is
>> typically a setup path. So reduce the chance of latency spikes on RT
>> kernels by migrating the currently mapped CMA pages out of CMA region.
> 
> 'reduce the chances of latency' so do you have any data to back this invasive
> change or not?
> 
> And for RT, but nothing in here at all checks for RT? You're using this
> compaction sysctl as an RT check somehow? That's gross.

sysctl_compact_unevictable_allowed is set to zero by default in RT kernels.
Also, sysctl_compact_unevictable_allowed can also be set to 1 in the RT
kernel, though this will produce a warning.

When sysctl_compact_unevictable_allowed is set to 1, my understanding is
that the mlock region should not contain CMA pages; otherwise, migration
entries will appear during CMA migration, and have to wait for the
migration to complete.

> 
> This doesn't feel like the right solution.
> 
>>
>> Suggested-by: Frank van der Linden <fvdl@google.com>
>> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
>> Link: https://lore.kernel.org/all/CAPTztWZpnX1j8-7yeppVUsxE=O9hbVeqricDjZt8_pnN7a-kBQ@mail.gmail.com/#t
>> ---
>>  mm/mlock.c | 119 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 118 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/mlock.c b/mm/mlock.c
>> index ac65de40b22b..f56c685533f5 100644
>> --- a/mm/mlock.c
>> +++ b/mm/mlock.c
>> @@ -25,6 +25,7 @@
>>  #include <linux/memcontrol.h>
>>  #include <linux/mm_inline.h>
>>  #include <linux/secretmem.h>
>> +#include <linux/migrate.h>
>>  #include <linux/compaction.h>
>>
>>  #include "internal.h"
>> @@ -428,6 +429,119 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
>>  	return 0;
>>  }
>>
>> +#ifdef CONFIG_CMA
> 
> Ugh yuck. This is horrible. Why are we polluting mlock.c with CMA stuff?
Will move to the relevant CMA file, if the CMA migration approach is acceptable.
> 
> Also no comment?
> 
>> +static int mlock_collect_migratable_pte_range(pmd_t *pmd, unsigned long addr,
>> +			unsigned long end, struct mm_walk *walk)
>> +{
> 
> You've literally copy/pasted mlock_pte_range(), this is disgusting.
> 
> Please don't copy/paste code like this, this isn't PHP, it's the kernel, it's
> completely unacceptable.
> 
>> +	struct vm_area_struct *vma = walk->vma;
>> +	struct list_head *folio_list = walk->private;
>> +	spinlock_t *ptl;
>> +	pte_t *start_pte, *pte;
>> +	pte_t ptent;
>> +	struct folio *folio;
>> +	unsigned int step = 1;
>> +
>> +	if (!(vma->vm_flags & VM_LOCKED))
> 
> Once again vma_test(vma, VMA_LOCKED_BIT) please.
> 
> But also, again (since you copy/pasted), why? You're literally mlocking here...
> 
> You going for that 'mlocking already mlocked ranges' sweet spot or am I missing
> something?
Will remove this check in next version.
> 
>> +		return 0;
>> +
>> +	ptl = pmd_trans_huge_lock(pmd, vma);
>> +	if (ptl) {
>> +		if (!pmd_present(*pmd)) {
>> +			if (unlikely(softleaf_is_migration(softleaf_from_pmd(*pmd)))) {
> 
> OK so you're not actually checking for CMA here at all, you're just doing the
> migration wait stuff... again here? What?

This is to prevent CMA pages from being migrated by cma_alloc at this point,
with migration entries already installed. If there are multiple CMA regions
in the system, after the wait completes the page could still be a CMA page,
so wait and recheck again.

> 
>> +				spin_unlock(ptl);
>> +				pmd_migration_entry_wait(vma->vm_mm, pmd);
>> +				walk->action = ACTION_AGAIN;
>> +				return 0;
>> +			}
>> +			goto out;
>> +		}
>> +		if (is_huge_zero_pmd(*pmd))
>> +			goto out;
>> +		folio = pmd_folio(*pmd);
>> +		if (folio_is_zone_device(folio))
>> +			goto out;
>> +		if (is_migrate_cma_page(&folio->page))
> 
> Err isn't this per-page, and you just checked that this is a huge folio, and
> you're only checking the first page? That seems wrong?

Not wrong. IIUC there are two cases:

If folio_order(folio) < pageblock_order, the folio fits entirely within a
single pageblock, so the first page is sufficient.

If folio_order(folio) >= pageblock_order, __free_one_page() prevents any
buddy merge across a CMA/non-CMA boundary.

> 
>> +			isolate_folio_to_list(folio, folio_list);
> 
> Then you just take the whole folio?
> 
> It's really horrible that you're burying this in copy/pasted code from the rest.
> 
>> +		goto out;
>> +	}
>> +
>> +	start_pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
>> +	if (!start_pte) {
>> +		walk->action = ACTION_AGAIN;
>> +		return 0;
>> +	}
>> +
>> +	for (pte = start_pte; addr != end; pte += step, addr += step * PAGE_SIZE) {
>> +		step = 1;
>> +		ptent = ptep_get(pte);
>> +		if (!pte_present(ptent)) {
>> +			if (unlikely(softleaf_is_migration(softleaf_from_pte(ptent)))) {
>> +				pte_unmap_unlock(start_pte, ptl);
>> +				migration_entry_wait(vma->vm_mm, pmd, addr);
> 
> BTW I also wonder if we have guaranteed forward progress here if say a migration
> happened to migrate back and forth again across a range...?

In theory, it is possible to keep waiting here repeatedly:
if there are multiple CMA regions, a cma_alloc() from CMA region A installs a
migration entry; once that migration completes, the page lands in CMA region B;
then a cma_alloc() from CMA region B installs another migration entry, and so on,
this function keep seeing a migration entry indefinitely. I suspect this is an
extremely rare scenario in practice, but I will add a retry limit in a follow-up
to guard against it.


Pages migrated out by mlock_migrate_cma_range() itself will not land in CMA
(allocated via alloc_migration_target with GFP_HIGHUSER which avoids CMA),
so this function always make forward progress.

> 
>> +				walk->action = ACTION_AGAIN;
>> +				return 0;
>> +			}
> 
> Again, since you copy/pasted, same comment - this is disgusting.
> 
> And again I'm confused why you're waiting here again after you did it previously
> due to the previous commit that already does it?
> 
> And why for a non-CMA range, if somebody happens to set CONFIG_CMA they now get
> this done twice?

The previous commit prevents page migration triggered by kcompactd, but cannot
prevent page migration triggered by cma_alloc().

compact_unevictable_allowed only prevents kcompactd-driven migration.
For an RT application, migration triggered by kcompactd is outside the
application's own behavior and can impact real-time latency. However,
cma_alloc() does not check compact_unevictable_allowed, so CMA-driven
migration will still migrate pages in the mlocked range, even if the RT
application has already called mlock().

The idea of this patch is to migrate CMA pages out of the locked range
at mlock() time. After that, even if cma_alloc() is called later, it
will no longer affect the mlocked range.

Perhaps I should describe this more thoroughly in the commit message, will
add this info in next version.


> 
>> +			continue;
>> +		}
>> +		folio = vm_normal_folio(vma, addr, ptent);
>> +		if (!folio || folio_is_zone_device(folio))
>> +			continue;
>> +		step = folio_mlock_step(folio, pte, addr, end);
>> +		if (is_migrate_cma_page(&folio->page))
>> +			continue;
> 
> You mean ! surely?
> 
> Why are you inverting this vs. the above? you replied to the patch so maybe you
> correct this there.
> 
>> +		isolate_folio_to_list(folio, folio_list);
> 
> And again you bury the actual point of this in one easily missed line and zero
> comments.

I will add some comments in the next version.

> 
> No.
> 
>> +	}
>> +	pte_unmap(start_pte);
>> +out:
>> +	spin_unlock(ptl);
>> +	cond_resched();
>> +	return 0;
>> +}
> 
> Yeah this is just completely unacceptable. You have to find a way to deduplicate
> code. Copy/paste code dumps are not ok.

Will refactor it in the next version to share the logic with mlock_pte_range().

> 
> But at the same time, you're dumping CMA crap in core mm mlock code which is
> horrible, you've also dumped some migration code so you're really mixing things
> up here horribly, and it doesn't seem justified?
>

As mentioned earlier, the migration entry handling here is intentional, we need to
wait for any in-flight migration to complete before checking whether the page is
CMA, otherwise we might miss CMA pages that are temporarily hidden behind a
migration entry.

>> +
>> +static const struct mm_walk_ops mlock_collect_migratable_ops = {
>> +	.pmd_entry	= mlock_collect_migratable_pte_range,
>> +	.walk_lock	= PGWALK_RDLOCK,
>> +};
>> +
>> +static void mlock_migrate_cma_range(unsigned long start, unsigned long len)
>> +{
>> +	struct mm_struct *mm = current->mm;
>> +	unsigned long end = start + len;
>> +	LIST_HEAD(folio_list);
>> +	struct migration_target_control mtc = {
>> +		.nid = NUMA_NO_NODE,
>> +		.gfp_mask = GFP_HIGHUSER | __GFP_NOWARN,
>> +		.reason = MR_SYSCALL,
>> +	};
>> +
>> +	if (compaction_allow_unevictable())
>> +		return;
> 
> Again you're assuming compaction for some reason. Why?

If compact_unevictable_allowed is true, it means the system allows kcompactd
to migrate pages in mlocked ranges, implying that the latency impact of such
migration is acceptable. In that case, there is no need to proactively migrate
CMA pages out of the mlocked range either.

> 
> It feels like you're just gating specific behaviour for your workload on this
> flag and assuming that's ok.
> 
>> +
>> +	lru_cache_disable();
> 
> What, why?

IIUC if folios have not been drained to the LRU, the isolation will fail.

> 
>> +
>> +	if (mmap_read_lock_killable(mm))
>> +		goto out;
> 
> OK so you got a fatal signal and you don't bother telling anybody about it and
> just skip migration?...
Oh, here should return -EINTR, will fix in next version.
> 
>> +
> 
> Weird whitespace...
> 
>> +	walk_page_range(mm, start, end, &mlock_collect_migratable_ops,
>> +			&folio_list);
>> +	mmap_read_unlock(mm);
>> +
>> +	if (list_empty(&folio_list))
>> +		goto out;
>> +
>> +	if (migrate_pages(&folio_list, alloc_migration_target, NULL,
>> +			  (unsigned long)&mtc, MIGRATE_SYNC, MR_SYSCALL, NULL))
>> +		putback_movable_pages(&folio_list);
>> +out:
>> +	lru_cache_enable();
>> +}
>> +#else
>> +static inline void mlock_migrate_cma_range(unsigned long start,
> 
> inline in a .c file? Why? Drop it.
Got it.
> 
>> +					   unsigned long len)
>> +{
>> +}
>> +#endif /* CONFIG_CMA */
>> +
>>  /*
>>   * mlock_vma_pages_range() - mlock any pages already in the range,
>>   *                           or munlock all pages in the range.
>> @@ -678,6 +792,7 @@ static __must_check int do_mlock(unsigned long start, size_t len, vm_flags_t fla
>>  	error = __mm_populate(start, len, 0);
>>  	if (error)
>>  		return __mlock_posix_error_return(error);
>> +	mlock_migrate_cma_range(start, len);
> 
> Err, unconditionally?

In mlock_migrate_cma_range(), the decision of whether to actually perform the
migration is gated by compact_unevictable_allowed.

> 
>>  	return 0;
>>  }
>>
>> @@ -790,8 +905,10 @@ SYSCALL_DEFINE1(mlockall, int, flags)
>>  	    capable(CAP_IPC_LOCK))
>>  		ret = apply_mlockall_flags(flags);
>>  	mmap_write_unlock(current->mm);
>> -	if (!ret && (flags & MCL_CURRENT))
>> +	if (!ret && (flags & MCL_CURRENT)) {
>>  		mm_populate(0, TASK_SIZE);
>> +		mlock_migrate_cma_range(0, TASK_SIZE);
> 
> Err what? Why are you doing this? You're forcing a wait on migration of
> literally everything across the whole of the process whether or not they're CMA
> ranges, but as a one time thing?

mm_populate(0, TASK_SIZE) operates on the entire process address space, so
mlock_migrate_cma_range() needs to scan the same range to find and migrate
any CMA pages.

We are aware that this operation can be time-consuming. On RT systems,
mlockall() is typically called during the application's initialization
phase, so the cost is paid upfront at setup time rather than at runtime.
The goal is to ensure that there are no latency spikes during the real-time
execution phase.

> 
> 
>> +	}
>>
>>  	return ret;
>>  }
>> --
>> 2.43.0
>>
> 
> In general this feels like the wrong solution for a specific workload that
> sticks horrible stuff in core mm and I don't really love it :)
> 
> Thanks, Lorenzo

Thanks,
Wandun


