Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 225BFEC1430
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:12:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64B4E6B0104; Tue,  3 Mar 2026 06:12:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 622386B0110; Tue,  3 Mar 2026 06:12:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 558CA6B0113; Tue,  3 Mar 2026 06:12:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 44BDF6B0104
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:12:48 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AA1F91C510
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:12:47 +0000 (UTC)
X-FDA: 84504489174.30.547B56C
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6745A40007
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:12:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=ykPP5llD;
	spf=pass (imf12.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772536365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KWwpTG4ziQIkxPyMAvmgDBqeguwQv3n8C1cOCmmRHTY=;
	b=upZWa024YfEM8WdInIP6KoZWjJ7ANVK/TrRN/PSHyx6q1y8GD5EQJp79c4H+WgyqTvX9Sp
	Yvw7yns3ygAZZhlXLlK7SyBkkAm6UQKq26NYJI0UWdwgIRDGcGQkvPlfzM+23rdKFsptRx
	R5LT+s4VMSVepCEDytCLU0r7hYDdLQs=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=ykPP5llD;
	spf=pass (imf12.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772536365; a=rsa-sha256;
	cv=pass;
	b=Y+KtqmLFhfds1lwghQYBsi38x8ph7v7/PdogO6kOSwo0AZnbLD5Myz3M+q0oVojF8W3k1Y
	HbPHJoxIrxEbQviE6lg+KZw8WSB5yfTd1XYgkq9SqOCQP9YFhpPGlaRwsLmUHkblOmJgjE
	76hE973mYn50dRd4cuYVWFYFxalcryY=
ARC-Seal: i=1; a=rsa-sha256; t=1772536353; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=Xk8XOS4NcXpcY8i28EJdCkkRNf9BHS0cGIW9LBUun6Z+/BGaWGSJkG76BgU9sxAUodKdzqfXC1L26l7hNatTm4gBwX2OTnKZBWyNufTbkmu8hMbIndMOwhtwnbD70u8zQQhWTPUnoO0GVpFOeo0OXkfj7O+rxfoD6Y9ldEMLjFE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1772536353; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=KWwpTG4ziQIkxPyMAvmgDBqeguwQv3n8C1cOCmmRHTY=; 
	b=Aa0TfMVFfmq252EoPEIXCBl6vdBZH+RzAYkX7uMUMCfwsTkKpwspY5d0Z/jV83SsxzHr+ILg5cZ1ZgrcFvGuVy7/XfUmTBpPxCJBJfe/8jxKkG8+Xeryc4XisE5CXXWeha9FYYYrFIQH685jj7q0GGT+HPAcJWjMiR3aIRaT6YY=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1772536353;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=KWwpTG4ziQIkxPyMAvmgDBqeguwQv3n8C1cOCmmRHTY=;
	b=ykPP5llD9FiY+Gv8m7kQnW77XE/UaukiN67+3es5091EmZzPczIY5NKD1ByiZmFF
	C361lxIw8uppOygNK0V7GUf2cRt7vbIxlp3EXObSM7obEE8L9/q3XpSZSeE9h9Ndc8W
	tQEZVYYHPIdLAsMVwBdolRSivGrx1CojzLzeGrmk=
Received: by mx.zoho.in with SMTPS id 1772536350446260.9400578620058;
	Tue, 3 Mar 2026 16:42:30 +0530 (IST)
Message-ID: <57b0ef75-59c2-44b4-90fc-d1b50cc1e9ed@zohomail.in>
Date: Tue, 3 Mar 2026 16:42:29 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/vmalloc: free unused pages on vrealloc() shrink
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260302-vmalloc-shrink-v1-0-46deff465b7e@zohomail.in>
 <20260302-vmalloc-shrink-v1-2-46deff465b7e@zohomail.in>
 <CAH5fLggLgRJL_5a2Ky-Ag7E6iRdY1wAVA=yx4wtz16-q+CMAGg@mail.gmail.com>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <CAH5fLggLgRJL_5a2Ky-Ag7E6iRdY1wAVA=yx4wtz16-q+CMAGg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Queue-Id: 6745A40007
X-Stat-Signature: iz6h5h7nmg5jee1xk3ftw16kyxujdwxu
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772536365-942691
X-HE-Meta: U2FsdGVkX1/CI8dyyypnRm3HumAHTDWnhIck5YVeDsNkw/LWf9YlURbOa9vBLpSjyvj3y/0FliHlttjNJ4cCwuj+UGmRLRPEvd2c6kCqvv+a6yDX8lhGDlZwCk4BejMNy8r5ldfmQGH4NHrOF9AQZSVQ16iW+tKMotY4TjJ0vJ7K1F8IG13cxMsskl0VPzTxEBsoXiP01a71kDwdWE3I0xZW/UGRKnnQ2X3n6CqIxCyEfWAvXzjSHkCBd71DuiwBqUJGG+TKefnHdRvpYsyMtsOFc86jD1CD0/fPjCsJhsHoNFTa42FjncL47BHKOsBB0/M7YiCqf1ZRQUAlPuxQrQM3rNfw7myzVuJHo1epO4EpRWSBcl1Lf1R68KCDrVgylg0BQ2ZZ4a9lNIW0zfEU/0ELU5uJF1n7HEaNns8Gy9e0fcH37+FBqqoPMhEEaX3H02+YrBScdD9BzMlUQJlH7d9/OrZayF0xuxyuj8IUBMzy24qVQRHQCSEWjmfzGmtTpvdDlSyKspqWSyP0mJR7MbmN+PIDFy9fJVfo6V+CurLzIl8FqH3hWrz8NVfvjL8u5Rtltle1vEn4qZc4wxAiQWuB1h8N84V09cAzkLz9rnma5FqnsLcNUPeVkULPYs8LXk2Ve+RQjhByQcYg1XLV2MAzm550d560rCv30Ml7aLKPhAoQZXREVteNGIsbzZidk8GC40ZBi5QgBJClV585BYD0ZphWSADKMES+NvK9BMhGUU2tdIbTs0HqdSvAbgCAg2QzvS0NPBUdo5ztk2F/+nMMYf40Cs085/8mzm8ocJTqcs8tZRDJlo/e8clffm4fEVpjB63JwloR6T0upC8vns2PCcl09JSjAVTwyfiQ4iOiK1bN4/jwbPkUG+3j1MYxKatdRiPfpJNUZQvZk1SOmwrJkY+CmVgr7MbF/5uP3lp1Pay2HiVQjONUtRX5quKUINFBrBzh58Ke2jmI32g
 Ek/n05C8
 3cpCR1txt28MYe7C5MuVQkAq5qEPw4vQxsS9OyYKKKyRjUp8wQ26RvDUwgvjvUWkagPbQR65o9nTs+oCVe09DPMmctTrfXV4MJfp/0BfLonCw4BRGz1LEIELik8NwjFZ1p1ZB+3dZeYtGTXy+XGS4/SKM+4E79q5TToCBmQwch8DFM4AJYam7VpXGl+LdlobaaLl3jJJ+uzdVQOPe09qgVe6YI8F5yfw/gOd3vPDhiMGdG0ROebTkM3Txy6QNSl7Q2L9A/sMHKgP37iY/fhMaLB4/TRyHgS2IgyFuL/jfZx6kX+W+/IG2hOiNdw2W6ihWkpyNfi5ZjIn0UZIWYZMkK6j9FeX7P9VuLWFCRFtNRLQs15ZYwLtjJs2RX7OsMidXq2nLmxcGmFX/maphwTf5RmfeEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/03/26 14:40, Alice Ryhl wrote:
> On Mon, Mar 2, 2026 at 3:03 PM Shivam Kalra via B4 Relay
> <devnull+shivamkalra98.zohomail.in@kernel.org> wrote:
>>
>> From: Shivam Kalra <shivamkalra98@zohomail.in>
>>
>> When vrealloc() shrinks an allocation and the new size crosses a page
>> boundary, unmap and free the tail pages that are no longer needed. This
>> reclaims physical memory that was previously wasted for the lifetime
>> of the allocation.
>>
>> The heuristic is simple: always free when at least one full page becomes
>> unused. Huge page allocations (page_order > 0) are skipped, as partial
>> freeing would require splitting.
>>
>> The virtual address reservation (vm->size / vmap_area) is intentionally
>> kept unchanged, preserving the address for potential future grow-in-place
>> support.
>>
>> Fix the grow-in-place check to compare against vm->nr_pages rather than
>> get_vm_area_size(), since the latter reflects the virtual reservation
>> which does not shrink. Without this fix, a grow after shrink would
>> access freed pages.
>>
>> Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
>> ---
>>  mm/vmalloc.c | 25 ++++++++++++++++++++-----
>>  1 file changed, 20 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index 54e76a47e995..7a4c59422638 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -4327,14 +4327,29 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
>>                         goto need_realloc;
>>         }
>>
>> -       /*
>> -        * TODO: Shrink the vm_area, i.e. unmap and free unused pages. What
>> -        * would be a good heuristic for when to shrink the vm_area?
>> -        */
>>         if (size <= old_size) {
>> +               unsigned int new_nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
>> +
>>                 /* Zero out "freed" memory, potentially for future realloc. */
>>                 if (want_init_on_free() || want_init_on_alloc(flags))
>>                         memset((void *)p + size, 0, old_size - size);
>> +
>> +               /* Free tail pages when shrink crosses a page boundary. */
>> +               if (new_nr_pages < vm->nr_pages &&
>> +                   !vm_area_page_order(vm)) {
>> +                       unsigned long addr = (unsigned long)p;
>> +
>> +                       vunmap_range(addr + (new_nr_pages << PAGE_SHIFT),
>> +                                    addr + (vm->nr_pages << PAGE_SHIFT));
>> +
>> +                       kasan_poison_vmalloc(
>> +                               (void *)(addr + (new_nr_pages << PAGE_SHIFT)),
>> +                               (vm->nr_pages - new_nr_pages) << PAGE_SHIFT);
> 
> There is a kasan_poison_vmalloc() call here.
> 
>> +                       vmalloc_free_pages(vm, new_nr_pages, vm->nr_pages);
>> +                       vm->nr_pages = new_nr_pages;
>> +               }
>> +
>>                 vm->requested_size = size;
>>                 kasan_poison_vmalloc(p + size, old_size - size);
> 
> And there is a kasan_poison_vmalloc() call here.
> 
> Furthermore, they seem to touch overlapping ranges. Perhaps the first
> call can be dropped?
> 
> Alice
Thanks for the feedback Alice. I will do two things for v2.
1. Update the base-commit to the recent most commit on char-misc-next
2. Keep only a single `kasan_vrealloc` call after the rebase.

