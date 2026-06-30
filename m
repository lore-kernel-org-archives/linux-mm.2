Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0BCDC43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 05:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C3656B00A6; Tue, 30 Jun 2026 01:48:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8744D6B00A7; Tue, 30 Jun 2026 01:48:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78AA36B00AA; Tue, 30 Jun 2026 01:48:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 526AE6B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:48:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C5E201A0390
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:48:40 +0000 (UTC)
X-FDA: 84935499600.13.092877A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 03BCF10000A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:48:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kIRh9tiq;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782798519;
	b=GY0xn7DGEwJWHI6/VNa0LEB1hyy8vLuJ/HBTdJduDw9hwTdWnW/PNcUpT1ALMmTsQJb9Ar
	sbtVkxqEN7PN7XMdtuw9vUHc4LX8gJjVRtcY2M5+fYOvNiu6JsEMZp0gm759SoUXec47yX
	n+pFOsAsgvbOSHtd/m/gyuB+dvJb9ZM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782798519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jupNvdmFnR/Px+8NpmjXUojkBHAB6uqajDM8/BZw794=;
	b=06PciDCbuSxle+E9aw3ZziJ2IC68a4r5J0mo2PFYwQxf32Wmk8jZY4/n8CI0aKfwmf2E94
	jnxrB2mNvdFS1RNBpcBxDNi3Fa+knzb2RaMm/Lg8y4w+qK9lAR/cu3smcLujhfXHthOT7T
	wuOTlFQgmU2pjB5ZYbpd8yYjOcpVYa8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kIRh9tiq;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F22F408B3;
	Tue, 30 Jun 2026 05:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F4A1F000E9;
	Tue, 30 Jun 2026 05:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782798518;
	bh=jupNvdmFnR/Px+8NpmjXUojkBHAB6uqajDM8/BZw794=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kIRh9tiqXn8no/E4hXCG4xXv7n5WlJFXAoWv/Yjzf2+lGRElBKyyydjumSSmjdhzV
	 6YaZZHr5VBWeaVZVU6ofy9SCnaUrVabh/MiB9it3pplV8JZ2x3kx/VNBNOGErrEt+L
	 EpWEMnO+X13LV5/0xIGUlZP9BFP4g34Ur7B7x6wODFtqLmXNw/X5uMuMlIg3r+bWVy
	 zTDHJU20r7mPHPCEnVjNCOJeiE17x5hjblndbBZ1xz3GHLg6ZU5a8wlulEkK2ypZbu
	 YHx6sXvLpLw808UB+1N9Hju/JEcWrXRSoI65d4KZFWz/QyiEla1R2pbSnbqXNHnCZy
	 0LbRQAmHlHHyw==
Message-ID: <1e7a712b-33f4-44c2-85ed-6333ddca421c@kernel.org>
Date: Tue, 30 Jun 2026 07:48:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm: try to free swapcache for non-LRU folios
To: Barry Song <baohua@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org, baoquan.he@linux.dev, chrisl@kernel.org,
 jp.kobryn@linux.dev, kasong@tencent.com, liam@infradead.org,
 linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
 nphamcs@gmail.com, rppt@kernel.org, shakeel.butt@linux.dev,
 shikemeng@huaweicloud.com, surenb@google.com, usama.arif@linux.dev,
 vbabka@kernel.org, youngjun.park@lge.com
References: <20260623231635.43086-1-baohua@kernel.org>
 <20260623231635.43086-5-baohua@kernel.org>
 <e56c4d73-ed4a-48bb-8d0a-97b1200d4a35@kernel.org>
 <CAGsJ_4y3yC1DCsHfCn5FP6vK3jqNRbqU5pbBqHnb5LB7GgtWOA@mail.gmail.com>
 <ajzm3pHq-wQlLNmm@KASONG-MC4>
 <c16bd777-6dfa-48f9-8dc5-2b56bebe67ad@kernel.org>
 <CAGsJ_4xh1P1yw3JogQxTS=Vu8kLEiMMh8si2YnCc9qnoKWLwjA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAGsJ_4xh1P1yw3JogQxTS=Vu8kLEiMMh8si2YnCc9qnoKWLwjA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e4mazjedrofykfic7dw88hy8yef9i7up
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 03BCF10000A
X-HE-Tag: 1782798518-781944
X-HE-Meta: U2FsdGVkX19HSvhNTsv9xjYHA0DVdxpSohQD4QVDpiMnTZsVKpYMzhXNLoRmoQAz0L40YyQSFzFrRkTFwkIwkgRpW5/cC3Ul4cQSZJkbE9ryrUqVVD7aGso/HJByAAe+tvX4pCAOYfmou+T7zkYjiwB1Ph18qs/kWrDVKtaE3GmYhK3+hIq6xomRUg5Oil0dbqSh8k4/QunMyyXsU+A6D4QxzzXG6STnZd2S7JkOlsce7XBiZxqv3H2Uzq30AMsAvA0SqMIqjL9gDZuyA4yQ7LQ8ZjWRh9UyIeFhM9iZtKyrtd6xAq2U1TktXZV1fjXdAIkzhWGt6b4xVsEQdHEuCPARHS/hNk+LUz5pV6Fyl7ZAsDi65nBAtBtePWVW78unM3eDcVltJl/UWz9MROv9RBMI5GM3NrJpVDEAnOxtMRTM2k0JqvZSPPbds3Mqy8UOTLOIwQoAbdVFPm5QHwpSOhL6vx+GMpKV93bDIhaldR4s5ni+ufkoqGQsu3EGXx+oioA/qmRvdlfBRSehPin8WRWom5B4ftTtLeTijgxCnwYVbUT2xiyjMslwEae30bC4WOMlaKItKktWaM0GxENynz/Mqh4zkG27Y6z8d/4us9J3doqsxsYr2ckMr6MA7fD0ryZkDW8M00RUL5nEM/BBzhKRYKw2ooYkNifkEpFYuc2m/WJ5ORYNdxzyjWPI981miWUbaTSz2mAtrubZLnRLB0eppA/j4P6gAPjNw5m3A+y9alfim500vp+d0y8iR0Wxbf+seaEhW/4hsTZ06vdS+EDM0XkiP+EnZmcGAaGTcZl7SDoN9J2vaRAtUoT5Yq8MGekxOgyQZMC+4CqG1/8BiUN0yr4yoBrlYfi54NaC/PrqGfhDRYrGqsFoTjQioeJl1gsQxirj0pCFpHQLva8HLlF/tJfgh3K14y2ndWYJs5yAKM8IAp5bpvSjynPjZFA1G94+tBN2bCZ3mRr0hHm
 y+dATmF+
 FWgtOD0oolHkHiKU+B14qmiM4mqg+sPoZZhFq0P+qlO5Rgtmj3tM+Qp42s2wAZennMZOkpjQm8kn3eq1jOh9zi2aCu2OZZ5CFvPBWQEIKl/MrIPH95w7agnXGMdSVrd+gmn81LGYvGI3e2i45J8QmFIbCcigNQO6dbUA66yrJSDZ3GeJF60qQIsW4bqBvV8QkMBXplDD1C6gyoIZvsErR52Z4KCqvsq5Ak5H5yLAy+Kj0N05rgGAey9c/EnBJ2T2ECm/k1OOmx40KIJeX10yl6DC+6+20UK3xCkPzhzpFVsGS8Z9Kpum3WXT0voUPakGbkvSkpDFG4otWTr8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 01:59, Barry Song wrote:
> On Sat, Jun 27, 2026 at 12:36 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>>>
>>> That's awkward, my bad, terribly sorry about this :(
>>>
>>> I sincerely apologize for the oversight and the trouble this has caused.
>>>
>>
>> All good, I was just surprised to see a previous optimization partially
>> reverted without a clear reasoning :)
>>
>> Because it should have removed the handling in should_try_to_free_swap() as well.
>>
>> It's good that we are discussing it now!
>>
>>> I haven't seen any performance regression in any workload recently
>>> though, or any correctness issue, perhaps the round trip of
>>> do_wp_page wasn't that bad. It should still catch the reuse folios,
>>> just more costly than doing things in-place.
>>
>> Right, do_wp_page() handles it, after the page was mapped. It adds some overhead,
>> but fortunately no TLB flush if we're just upgrading write permissions.
>>
>> The optimization dates back to pre PageAnonExclusive handling.
>>
>>>
>>> I think we should restore the original check first. We might also want to
>>> avoid dropping the swap cache if the folio will not be reused, which
>>> was discussed here:
>>>
>>> https://lore.kernel.org/linux-mm/CAMgjq7BDfvNXdWH0cqarsujjUn3i3tDDhDkmSg01TR4h-tDorQ@mail.gmail.com/
>>>
>>> Maybe extracting some common part into a helper can help make this
>>> cleaner.
>>>
>>>
>>> Hi Barry,
>>>
>>> The problem is more than that, the `exclusive || folio_ref_count(folio) == 1`
>>> in do_swap_page is also ineffective now.
>>
>> Exactly.
>>
>> If the roundtrip through do_wp_page() is good enough today, we can just do
>>
>> @@ -4512,7 +4516,6 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
>>  static inline bool should_try_to_free_swap(struct swap_info_struct *si,
>>                                            struct folio *folio,
>>                                            struct vm_area_struct *vma,
>> -                                          unsigned int extra_refs,
>>                                            unsigned int fault_flags)
>>  {
>>         if (!folio_test_swapcache(folio))
>> @@ -4528,14 +4531,7 @@ static inline bool should_try_to_free_swap(struct swap_info_struct *si,
>>         if (mem_cgroup_swap_full(folio) || (vma->vm_flags & VM_LOCKED) ||
>>             folio_test_mlocked(folio))
>>                 return true;
>> -       /*
>> -        * If we want to map a page that's in the swapcache writable, we
>> -        * have to detect via the refcount if we're really the exclusive
>> -        * user. Try freeing the swapcache to get rid of the swapcache
>> -        * reference only in case it's likely that we'll be the exclusive user.
>> -        */
>> -       return (fault_flags & FAULT_FLAG_WRITE) && !folio_test_ksm(folio) &&
>> -               folio_ref_count(folio) == (extra_refs + folio_nr_pages(folio));
>> +       return false;
>>  }
>>
>>  static vm_fault_t pte_marker_clear(struct vm_fault *vmf)
>> @@ -5095,7 +5091,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>>          * Do it after mapping, so raced page faults will likely see the folio
>>          * in swap cache and wait on the folio lock.
>>          */
>> -       if (should_try_to_free_swap(si, folio, vma, nr_pages, vmf->flags))
>> +       if (should_try_to_free_swap(si, folio, vma, vmf->flags))
>>                 folio_free_swap(folio);
>>
>>         folio_unlock(folio);
>>
>> But then, one question is whether we'd actually want to try removing the swapcache when
>> we mapped the page writable (iow: exclusive)?
> 
> I guess this question comes from my earlier commit c18160dba5ff
> ("mm: swap: reuse exclusive folio directly instead of wp page faults"),
> where the folio is reused even for READ faults. In that case, we
> would miss do_wp_page(), which could later drop the swapcache?
> Also, again, nobody has reported any regression for this.
> 
> Holding swapcache for a clean folio for non-sync swap I/O has the
> benefit of avoiding a potential pageout(). Now, reuse even for read
> faults and always dropping swapcache seems to somewhat defeat that
> benefit. On the other hand, we always drop swapcache for sync I/O
> to avoid the copy in zRAM or elsewhere consuming memory, so it seems
> safe enough to always enable reuse in do_swap_page() for sync I/O.

Right, I meant during write faults, when a write is expected. See below.

> 
>>
>>
>> @@ -4512,7 +4516,7 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
>>  static inline bool should_try_to_free_swap(struct swap_info_struct *si,
>>                                            struct folio *folio,
>>                                            struct vm_area_struct *vma,
>> -                                          unsigned int extra_refs,
>> +                                          bool exclusive,
>>                                            unsigned int fault_flags)
>>  {
>>         if (!folio_test_swapcache(folio))
>> @@ -4529,13 +4533,11 @@ static inline bool should_try_to_free_swap(struct swap_info_struct *si,
>>             folio_test_mlocked(folio))
>>                 return true;
>>         /*
>> -        * If we want to map a page that's in the swapcache writable, we
>> -        * have to detect via the refcount if we're really the exclusive
>> -        * user. Try freeing the swapcache to get rid of the swapcache
>> -        * reference only in case it's likely that we'll be the exclusive user.
>> +        * We have an exclusive page that was mapped writable or will soon
>> +        * be mapped writable (as we are in a write fault). Let's just try
>> +        * to reclaim swap immediately.
>>          */
>> -       return (fault_flags & FAULT_FLAG_WRITE) && !folio_test_ksm(folio) &&
>> -               folio_ref_count(folio) == (extra_refs + folio_nr_pages(folio));
>> +       return (fault_flags & FAULT_FLAG_WRITE) && exclusive;
> 
> I assume you mean (fault_flags & FAULT_FLAG_WRITE) || exclusive, or

No, I meant "we are serving a write fault (write is definitely going to happen)
and we are definitely reusing the page (exclusive).

> we can just remove (fault_flags & FAULT_FLAG_WRITE) and use
> "exclusive" instead since we are always using do_wp_page() now,

If you drop the "FAULT_FLAG_WRITE", you'd remove clean pages (that will likely
stay clean as no write fault) from the swapcache, As you correctly say above,
can avoid a pageout(), so I think we should keep that.

> and FAULT_FLAG_WRITE in fault_flags could have been cleared
> by the reuse of do_swap_page().

Ah, yes, that existing handling is nasty. We should look into not messing with
fault flags. Something like the following

diff --git a/mm/memory.c b/mm/memory.c
index ff338c2abe923..b0d8f3674525b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5052,10 +5052,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
                if ((vma->vm_flags & VM_WRITE) && !userfaultfd_pte_wp(vma, pte) &&
                    !pte_needs_soft_dirty_wp(vma, pte)) {
                        pte = pte_mkwrite(pte, vma);
-                       if (vmf->flags & FAULT_FLAG_WRITE) {
+                       if (vmf->flags & FAULT_FLAG_WRITE)
                                pte = pte_mkdirty(pte);
-                               vmf->flags &= ~FAULT_FLAG_WRITE;
-                       }
                }
                rmap_flags |= RMAP_EXCLUSIVE;
        }
@@ -5112,7 +5110,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
                folio_put(swapcache);
        }

-       if (vmf->flags & FAULT_FLAG_WRITE) {
+       if ((vmf->flags & FAULT_FLAG_WRITE) && !pte_write(pte)) {
                ret |= do_wp_page(vmf);
                if (ret & VM_FAULT_ERROR)
                        ret &= VM_FAULT_ERROR;


-- 
Cheers,

David

