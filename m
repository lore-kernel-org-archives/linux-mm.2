Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49D93C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 16:36:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EED46B00FC; Fri, 26 Jun 2026 12:36:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C7226B00FE; Fri, 26 Jun 2026 12:36:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5BA6B00FF; Fri, 26 Jun 2026 12:36:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E6BFE6B00FC
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:36:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6D7691204F8
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:36:05 +0000 (UTC)
X-FDA: 84922615890.13.AF9E494
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7AEAA14000F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:36:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mQ3b33Rt;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782491763;
	b=p+Ip/cfznuNkO6U8IIgg7IMn8HdT/KY4Pb3uXDSk/kzNPjoQnnUnjXabsnOmwg4sSUs34s
	zaNE/BWamy8UN3CL3VloREFmJf79xDSnkyKglHzHWLpABRG+m5tQLyDHdnR6NVymPRKkTS
	ItD/tr1tksCUQAHfwWvZ+uP8PTzNHeA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782491763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qPvLxcG0grrH18rtYxN/ib3m110h2uI/oSNgSCAF3J0=;
	b=O8b/REWoXsGdeUO3/yRIQIMKH56JrJxSqWIgQB6S/zWhs/hw05gkwF0KcpMlTe+DtnuvBC
	NFYb6HLCwjLW2Hc5qpOCirniE84XTWR6qQtbz2SwdhgoBV/T5grNr+IVSPgOcUTy+M61au
	8+AZb4f7BRX5yoatiT8D4BHqho89e9A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mQ3b33Rt;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 78EFC41395;
	Fri, 26 Jun 2026 16:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CFC61F000E9;
	Fri, 26 Jun 2026 16:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782491762;
	bh=qPvLxcG0grrH18rtYxN/ib3m110h2uI/oSNgSCAF3J0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mQ3b33RtK+P4LPpthlxcWBG+UXAE3+Pvfx34gbD3hy0zZCvd3BErhlyEEukdC9ZmN
	 iiHyZT8uzmSzPZ5T79YLxLxHO6Wc1Gm65y/BcgLJ3IwN1duRiztdKAHBWeYeTK8XE0
	 Et6/NBK3v1kPTs6ujv1DHf/46UYsUfr1wN2KRH3QMEH1KvtIBg0DaGQ/c4ESBRAFnY
	 RUDc4RLKRA/n8eY50ZjBgg6bBbPr1Bu4pS0RdjRRUCeRkMnWOyxRL2ugrI2zWuSC4M
	 r58dHmNl2BW3NzVSvzhl6QIxOLrM2QNnr9qxOocSrnR7eFsZgr3A9XaOpkRGqRMj9X
	 tm/ZZBtU0LGJQ==
Message-ID: <c16bd777-6dfa-48f9-8dc5-2b56bebe67ad@kernel.org>
Date: Fri, 26 Jun 2026 18:35:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm: try to free swapcache for non-LRU folios
To: Kairui Song <ryncsn@gmail.com>, Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, baoquan.he@linux.dev,
 chrisl@kernel.org, jp.kobryn@linux.dev, kasong@tencent.com,
 liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org,
 mhocko@suse.com, nphamcs@gmail.com, rppt@kernel.org, shakeel.butt@linux.dev,
 shikemeng@huaweicloud.com, surenb@google.com, usama.arif@linux.dev,
 vbabka@kernel.org, youngjun.park@lge.com
References: <20260623231635.43086-1-baohua@kernel.org>
 <20260623231635.43086-5-baohua@kernel.org>
 <e56c4d73-ed4a-48bb-8d0a-97b1200d4a35@kernel.org>
 <CAGsJ_4y3yC1DCsHfCn5FP6vK3jqNRbqU5pbBqHnb5LB7GgtWOA@mail.gmail.com>
 <ajzm3pHq-wQlLNmm@KASONG-MC4>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ajzm3pHq-wQlLNmm@KASONG-MC4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: z8jj9dkgyhhzrqq6i9y9dotdbcqhi84z
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7AEAA14000F
X-HE-Tag: 1782491763-653984
X-HE-Meta: U2FsdGVkX19njEjwlO6mJ7xGjUfESMUoFjVvip3nG8gi7K1n2GeOsCsONvW/XrKFXSuVabavs6OQlAd9u5czq0cBUcFqzK7uVvIrKMibibtCNEdWPDSCEgfepIzU350fBYBQeLloeR8HVyIf8xdp/TMBAEkhEnsz9QaZUDYJcyNAGVKqKxwmig9kXvHeMk8DqCE4yR7gvS/yRVMJF78O3QvXjnIbLsv4gzZzr1QDKiAxq7Am1EN+QHZjFNT5xSr68vvWBrIHFyDoL+1DnkK6Ueo5On/OtQRHIXwr/wouQQqUf15CWObWjFl0hND9Bk+uio6jiWuR0tCFWclClKR8rEAURTiYjgjvReMc2ympjqJB++xhqOK0TnLDlT8Uzp7ZOEuzsrJRlGGYzi928GMU+1CVpuz8qckqTGuHy8qWBqVY2yqXsvKuBjMgMRFE3tKJJA8Vi/icfkAlwmrlWDq3ENtA4kKKyI1ujYJKd1xWYxURPfXCBfa8L+W1pVFiSDw6i++nhmFtLduVR5+FxUjby9uU6hu9yMpyU+nB04eaAruzSIC0vsCi5cwExEORS2fjwmLtwSuEgINK89RT1EmZJ6V7SoeZxtr+8XykqN+HoLhpP5l5DkjrBcYp275FgMH5otHVIzcOwYv54xZq4rb3RoSDnkNuTdd9PneuGW3doZT26RHSsx3UZlZsOG2Hy1ud/O+RcLCkBmp7VlAugEL6rqH8hmv/f3rY1BS23Wswl0D8MKnsDBhbcUOfCuB+Zg6oqWH7McFxgdM+BfdDKdYrvfQnCOQ2DdnU9VfdR8H4HCuaulNjRTKAX7VFzP+X/Er4NJJk6uhkvrDtStQ5REJw6S96yP3ZfNmIvOM/wVR0FxC00PkQqaL6zMsq6Toe7MWDV5teuPYh8n4H9ATxF07zgVJeAZ2I23q2O9FNizwr8ImsDhIvA/t+IibyELSDXXxLk2x32R0oK6FohwqTqAY
 QKiAcwRx
 Tvkmrk1YIjPe8iPmhhePeyucwmXKAN012yhlUcuyvI3VbKzk6JtRInqpbKzjPLDxEwN4KIAylgfYNn335aXtwlzfe0QYCqj0Y/WTcYnpBtgAHcV8+7iKUuTK7G7w00V5lwHrHxw4582D76I3u6U0wwPDFdaAenQQyH0sR9A9wXzlF0tjg5b+kE2c7TjbXmhwZ0Ls69fwRFEYCRrx3X6UstWv9PnglzJBGnkzXh5UA0VNAqdrKrTeaXQLiHoJD6dRN+BXsm7sa0JS9M0TdjOgOJV6vHXHgv4SBmfcXL1JupSwMgmIlRRTB6rGgQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>> That changed that behavior such that we *must* now always fallback to do_wp_page().
>>>
>>> What a mess (I didn't ack)
> 
> That's awkward, my bad, terribly sorry about this :(
> 
> I sincerely apologize for the oversight and the trouble this has caused.
> 

All good, I was just surprised to see a previous optimization partially
reverted without a clear reasoning :)

Because it should have removed the handling in should_try_to_free_swap() as well.

It's good that we are discussing it now!

> I haven't seen any performance regression in any workload recently
> though, or any correctness issue, perhaps the round trip of
> do_wp_page wasn't that bad. It should still catch the reuse folios,
> just more costly than doing things in-place.

Right, do_wp_page() handles it, after the page was mapped. It adds some overhead,
but fortunately no TLB flush if we're just upgrading write permissions.

The optimization dates back to pre PageAnonExclusive handling.

> 
> I think we should restore the original check first. We might also want to
> avoid dropping the swap cache if the folio will not be reused, which
> was discussed here:
> 
> https://lore.kernel.org/linux-mm/CAMgjq7BDfvNXdWH0cqarsujjUn3i3tDDhDkmSg01TR4h-tDorQ@mail.gmail.com/
> 
> Maybe extracting some common part into a helper can help make this
> cleaner.
> 
>>
>> So it seems we need a patch before patch 4 to fix the missed
>> swapcache freeing on write faults, because the write bit has already
>> been cleared by the time the folio is mapped and reused?
>>
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 14577c67c61a..e8fc5a86f6ea 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -4752,6 +4752,7 @@ static void check_swap_exclusive(struct folio
>> *folio, swp_entry_t entry,
>>   */
>>  vm_fault_t do_swap_page(struct vm_fault *vmf)
>>  {
>> +       enum fault_flag fault_flags = vmf->flags;
>>         struct vm_area_struct *vma = vmf->vma;
>>         struct folio *swapcache = NULL, *folio;
>>         struct page *page;
>> @@ -5091,7 +5092,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>>          * an additional reference to the folio.
>>          */
>>         if (should_try_to_free_swap(si, folio, vma, nr_pages +
>> -                       !folio_test_lru(folio), vmf->flags))
>> +                       !folio_test_lru(folio), fault_flags))
>>                 folio_free_swap(folio);
>>
>>         folio_unlock(folio);
>>
>>
>> Best Regards
>> Barry
> 
> Hi Barry,
> 
> The problem is more than that, the `exclusive || folio_ref_count(folio) == 1`
> in do_swap_page is also ineffective now.

Exactly.

If the roundtrip through do_wp_page() is good enough today, we can just do

@@ -4512,7 +4516,6 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
 static inline bool should_try_to_free_swap(struct swap_info_struct *si,
                                           struct folio *folio,
                                           struct vm_area_struct *vma,
-                                          unsigned int extra_refs,
                                           unsigned int fault_flags)
 {
        if (!folio_test_swapcache(folio))
@@ -4528,14 +4531,7 @@ static inline bool should_try_to_free_swap(struct swap_info_struct *si,
        if (mem_cgroup_swap_full(folio) || (vma->vm_flags & VM_LOCKED) ||
            folio_test_mlocked(folio))
                return true;
-       /*
-        * If we want to map a page that's in the swapcache writable, we
-        * have to detect via the refcount if we're really the exclusive
-        * user. Try freeing the swapcache to get rid of the swapcache
-        * reference only in case it's likely that we'll be the exclusive user.
-        */
-       return (fault_flags & FAULT_FLAG_WRITE) && !folio_test_ksm(folio) &&
-               folio_ref_count(folio) == (extra_refs + folio_nr_pages(folio));
+       return false;
 }
 
 static vm_fault_t pte_marker_clear(struct vm_fault *vmf)
@@ -5095,7 +5091,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
         * Do it after mapping, so raced page faults will likely see the folio
         * in swap cache and wait on the folio lock.
         */
-       if (should_try_to_free_swap(si, folio, vma, nr_pages, vmf->flags))
+       if (should_try_to_free_swap(si, folio, vma, vmf->flags))
                folio_free_swap(folio);
 
        folio_unlock(folio);

But then, one question is whether we'd actually want to try removing the swapcache when
we mapped the page writable (iow: exclusive)?


@@ -4512,7 +4516,7 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
 static inline bool should_try_to_free_swap(struct swap_info_struct *si,
                                           struct folio *folio,
                                           struct vm_area_struct *vma,
-                                          unsigned int extra_refs,
+                                          bool exclusive,
                                           unsigned int fault_flags)
 {
        if (!folio_test_swapcache(folio))
@@ -4529,13 +4533,11 @@ static inline bool should_try_to_free_swap(struct swap_info_struct *si,
            folio_test_mlocked(folio))
                return true;
        /*
-        * If we want to map a page that's in the swapcache writable, we
-        * have to detect via the refcount if we're really the exclusive
-        * user. Try freeing the swapcache to get rid of the swapcache
-        * reference only in case it's likely that we'll be the exclusive user.
+        * We have an exclusive page that was mapped writable or will soon
+        * be mapped writable (as we are in a write fault). Let's just try
+        * to reclaim swap immediately.
         */
-       return (fault_flags & FAULT_FLAG_WRITE) && !folio_test_ksm(folio) &&
-               folio_ref_count(folio) == (extra_refs + folio_nr_pages(folio));
+       return (fault_flags & FAULT_FLAG_WRITE) && exclusive;
 }
 
 static vm_fault_t pte_marker_clear(struct vm_fault *vmf)
@@ -5095,7 +5097,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
         * Do it after mapping, so raced page faults will likely see the folio
         * in swap cache and wait on the folio lock.
         */
-       if (should_try_to_free_swap(si, folio, vma, nr_pages, vmf->flags))
+       if (should_try_to_free_swap(si, folio, vma, exclusive, vmf->flags))
                folio_free_swap(folio);
 
        folio_unlock(folio);


-- 
Cheers,

David

