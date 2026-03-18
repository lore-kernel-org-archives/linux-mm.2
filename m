Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51A5C10775F4
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 17:22:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7AD56B02C0; Wed, 18 Mar 2026 13:22:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2BF46B02C2; Wed, 18 Mar 2026 13:22:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A42626B02C3; Wed, 18 Mar 2026 13:22:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9359F6B02C0
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 13:22:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 467211A0836
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 17:22:19 +0000 (UTC)
X-FDA: 84559852398.25.7FF6769
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id C42F720017
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 17:22:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AF6ZaBvK;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773854537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W45kMnLtC5MOWuTuvK3U+l7AgaOFnu4Qio9p76W/VgI=;
	b=X7siNMLpjzP9yiu89HJ36qcrDkfOPGSuIGO3VmUn4/jEGUMzH0Tc6a9FYtEUSdUmKj2Mg3
	d2nHwwW6n70DkD62ujcv649WkBDRN6P39qij2V+jjbVEqm+ocRxx++K2bG3p0f4gl+GFGr
	ygL7+IC8QkjQ93vz0mC6g1f2A/ByUaU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AF6ZaBvK;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773854537; a=rsa-sha256;
	cv=none;
	b=5Pw4fNeSRgcbPTQoNmxBPy+ZHofNAX0yoN/Y8Auj40o6sgd7buhRNhl51J/tU08oiUo+8j
	MT7nvyDM8pIhTkKQ4gryCOVHV7js1/wIdhRRQ1fLvph7xh0RI8qw6/eMxJ+U1tHUr8rCps
	lWdkQ7b4aibsuE4pvna4xI6ZTO2tTRM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773854536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W45kMnLtC5MOWuTuvK3U+l7AgaOFnu4Qio9p76W/VgI=;
	b=AF6ZaBvKNpfqSbOFuGyh+CoE5KhPcEDV/bEzPEuHjkDgbDdQvAwH6m8NI1uumsW5QIse5g
	gqSasqYrQens/eQlnx131O4ZnYPscdjFDZkT5vKH3cVfGYUgpYnB8yU0VxbsITC/bIYSyz
	3E0hJCNUpOsUrRwTGF3mAnyf0mR9xPw=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-436-zuUZmFNVOrCSjJsJKFCUHA-1; Wed, 18 Mar 2026 13:22:14 -0400
X-MC-Unique: zuUZmFNVOrCSjJsJKFCUHA-1
X-Mimecast-MFC-AGG-ID: zuUZmFNVOrCSjJsJKFCUHA_1773854534
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8cd81be6f05so99335785a.2
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:22:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773854534; x=1774459334;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W45kMnLtC5MOWuTuvK3U+l7AgaOFnu4Qio9p76W/VgI=;
        b=rHhmN0iypqdfi469dw3sVX7mfLahNNU3IJf5FadbN7glAi2s6hxTlOt8QQekqPaWwx
         Ypbw9Z7aMupiPUJe+9NNevvXk/vCvPsbMp9TY8ZKLK4MgN0xwl2pmCunGbXBiVBBySIo
         ExOJMG+92kq8kbnhZCr3JvzIp52MxtsUbmSu599cHvb/Sk6JtS8rCJH1zLdUgKxITk3G
         Ew+mLLSgBWFB917pt1tWLE9ybITn3Vr19r4KWlp68i8hflR55EKP6+jIHu+uS4TMCsYC
         AAh8iZqB6LNzl6RKwoyv4HdRSGyxS+RTy0BXRlPCGZnbaUhBONvBJIFGPpYnVujlZu4j
         6wCA==
X-Forwarded-Encrypted: i=1; AJvYcCW1RSCU4ZOjmBaQ0p6wY5JEx2BNs1AaviY8PgSWAH8KRWCm5fgQm4T02S7yS7p0MYQmfJe2tsCQWQ==@kvack.org
X-Gm-Message-State: AOJu0YxyBtKbbSnzPQ+5NZ7mnsgQgVUiHs3mS3gS7/4CzHLUmYR8gjet
	+Jcrkf4BdgWsbYPjKGdWonA2fc0Pt3N9CN+6VlFMiHA/QI8+1gBhmQC+0B/un6xY031JefE/1QX
	EqFIXSIwmtufikvvIuDRs0Tlfp06ScXfyX37gsNjWKURvCW/aF0BF
X-Gm-Gg: ATEYQzyvVnaGkUWccPFa5ykIf6dk/7SDprkLTlVEPO1Kb8QMp8KY9rmOqh/blCKj6Gx
	oG2oyYuKnxjrlgYy28GHcspQ7kC49pBEyIw1WD6Bzf1DWKFaI3hBYVsOuIYDtv0tdUVmK4X0CdN
	Jytp4UvYAzYHa4htuXyf6XF7tNkIp/HVWHmp4ACuNsvR6w4zGRQb+d2Hqr0DN8H1ElJOFXNhY96
	u3sccm6JwNxs3w12AM+UtIu0xJWBVAJhJ/kwbzGcb0iVULgCWdSRoldtAatDtAo6VcZRVmBECmy
	QeWbobUkoItuskQLCNvsmrta2dTW96gBXqQZlbxqv9j4Ltmr6ppC7Qb4v+a2U69A1iCdznZjNHn
	5ECsUx/y1mxKY4FdsVcZDHVx6N3w0RExPd7DApDUKv+67PEqzdOu3yaQFC5Zn
X-Received: by 2002:a05:620a:28c7:b0:8ca:363a:cd73 with SMTP id af79cd13be357-8cfad3b7093mr530908985a.68.1773854534138;
        Wed, 18 Mar 2026 10:22:14 -0700 (PDT)
X-Received: by 2002:a05:620a:28c7:b0:8ca:363a:cd73 with SMTP id af79cd13be357-8cfad3b7093mr530900885a.68.1773854533464;
        Wed, 18 Mar 2026 10:22:13 -0700 (PDT)
Received: from [192.168.10.111] (c-76-154-99-94.hsd1.co.comcast.net. [76.154.99.94])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfacdaeb88sm300378585a.5.2026.03.18.10.22.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 10:22:12 -0700 (PDT)
Message-ID: <9d9815ed-561b-4071-836f-4f2409830761@redhat.com>
Date: Wed, 18 Mar 2026 11:22:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v3 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jackmanb@google.com, jack@suse.cz, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260311211315.450947-1-npache@redhat.com>
 <20260311211315.450947-6-npache@redhat.com>
 <f6029c48-3e00-4efa-bb2d-579916029131@lucifer.local>
From: Nico Pache <npache@redhat.com>
In-Reply-To: <f6029c48-3e00-4efa-bb2d-579916029131@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GI1e4X6V_CZo0M2udO0nH_SN5K8bV_-UY4KSnnWYpbE_1773854534
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-ZM
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C42F720017
X-Stat-Signature: hnzi1ssw6qntqeezr3ykqmqxk9tx7w8z
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773854536-891720
X-HE-Meta: U2FsdGVkX18734BzQkoOs5IwaJRx0tYLDaJm+rs0WtZx/5K67Z66nI/C1wGmGsMpeiupTbtoaj9ti1dSUEKDGAVu6ep0zIGmutkcRXJzmniA9J0pG7OVxqUHeCxshWSjUhuAPgrAE/kILr6sotCjX0olTnc9GqugF7fHAbX0ctjc+AmxsXq9XJkF/hSbMC4ghDetlo4VJohDIvd2eHXX+vB9tR5kmYhFZwm/8QmgkmsfPo+oyDJNpyNoU5tGnPFFyzwmlB8sRr9UaSAhlk7B2R8PVjZ2DK5StB5XvaltYfnG/n7SvQJPBqXwpmiQSbWTumDiT/cUx69ganv2wxnhG0Q3EmdF0Daa2TlwX42lsaSeLbHTKZbwv/mbE4yLvD62zE2yIKQaY2b8oYs8JgRZt/ZNH3rS+Vc+OrEF3MCiFo45DZtHAH0Rxgw/AE5bOKmqhw2MJJ62okhkW6/Y76AieyjlHsledFN+tD3C3cPnJ3hfpYP4H243ev52mo/VhQ/nQ3qJL+WG7ZAXqmHQyC9GNywRbftNdu2I2ZRvzO6cnk3XxkbJLTax7IiDChDKYYly8pPa+Yr/Xoir0p4olaPwXhSA+ImuezJcACdrTBte419j0mpaIVWjaFR0jQDkty1XPtlEeiCEJlnU6yB+FoLlj8BBjLShHcl6dG3bdklXzHlGMIa9TpE2g8JYudnZVRmfcYXuNvUavxIcEx50iH9V6iMbWRMpjutsWhvgBj+OG+cYRZMv5j4SAsx5NMqyVVnwWxnEoAU5B/MV6LIt089W1fM3P8o5l0XktYw/SVoN1fsiJ5z7NzNQWstKk7wdT9O45/jTF/hrcEOvJ653pGRYSzv0JB1xh6Fx1ipV/i6MCVYG1ceFaEuqc+726TR78PEmu++x+Kk6qXfxxyuZ16nX+uqhWm7XkrPuB1bqI2d0Z3hds/iDGT+HqI5GA3F3t2BTx6EdZjaDnb+sZn5p2JR
 D8p+ym4k
 F7WptSaaUVzJyc/F58scRLDC30jvJsHJJ9zZ/PJBQG34sX3Yj6HqOGANaxeJl2HMxhw+BPKBVb3f5YbvgpZVzqp9MsY7tseTGmzkdKbsrifKhxfwjfk8Vvff3b74aPjIGQ5+nouE74DI6pSAUFc6kS9kswZL0n78eXPtpliyTR50EfklXvEHQ3GlrH7HkPTcATU4jZHjwMwbbLbZ1E0j82eZoGaC89MlgQ9HWuTEeEuus28lFOh+SpGXASyoD9rOIsTOYSuNSKSrai+qWBP7sMsosvQFifyd+QkUQJoVqhGFWORIXiZc47bQE2rIyUKidlOlzs/7xCHD6MQfdMFYcNFtWkCD1gvnaM2aDfa7uUNv4OL85B0A+XCugSUCS54MwiQKxs9KVTZpOWX0Jp/Qw4Q+zWGGOMOfbLUzldEdFWzKhkd9uOYAY0Pxegi0n4sQENt9/+d9N3K6Bx98L1zQve8U/OTGAQOIahLAH8aKLlc96jbiSoVnbV5X+WQQEI0WjcmzW8ZZlNTY/K9wpa/QvWFSM8sMiihqklgL56+hu0UQ0R8nTGiKag0Vplgb542cin+dbxtu4UIZOdBMiOI4Xpsth6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/16/26 12:54 PM, Lorenzo Stoakes (Oracle) wrote:
> On Wed, Mar 11, 2026 at 03:13:15PM -0600, Nico Pache wrote:
>> The khugepaged daemon and madvise_collapse have two different
>> implementations that do almost the same thing. Create collapse_single_pmd
>> to increase code reuse and create an entry point to these two users.
> 
> Ah this is nice :) Thanks!

Thanks :) hopefully more khugepaged cleanups to come after these series' land.

> 
>>
>> Refactor madvise_collapse and collapse_scan_mm_slot to use the new
>> collapse_single_pmd function. This introduces a minor behavioral change
>> that is most likely an undiscovered bug. The current implementation of
>> khugepaged tests collapse_test_exit_or_disable before calling
>> collapse_pte_mapped_thp, but we weren't doing it in the madvise_collapse
>> case. By unifying these two callers madvise_collapse now also performs
>> this check. We also modify the return value to be SCAN_ANY_PROCESS which
>> properly indicates that this process is no longer valid to operate on.
>>
>> By moving the madvise_collapse writeback-retry logic into the helper
>> function we can also avoid having to revalidate the VMA.
>>
>> We also guard the khugepaged_pages_collapsed variable to ensure its only
>> incremented for khugepaged.
>>
>> Signed-off-by: Nico Pache <npache@redhat.com>
> 
> The logic all seems correct to me, just a bunch of nits below really. This is
> a really nice refactoring! :)
> 
> With them addressed:
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Thanks I will address those!

> 
> Cheers, Lorenzo
> 
>> ---
>>  mm/khugepaged.c | 120 +++++++++++++++++++++++++-----------------------
>>  1 file changed, 63 insertions(+), 57 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 33ae56e313ed..733c4a42c2ce 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -2409,6 +2409,65 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>>  	return result;
>>  }
>>
>> +/*
>> + * Try to collapse a single PMD starting at a PMD aligned addr, and return
>> + * the results.
>> + */
>> +static enum scan_result collapse_single_pmd(unsigned long addr,
>> +		struct vm_area_struct *vma, bool *mmap_locked,
> 
> mmap_locked seems mildly pointless here, and it's a semi-code smell to pass 'is
> locked' flags I think.
> 
> You never read this, but the parameter implies somebody might pass in mmaplocked
> == false, but you know it's always true here.
> 
> Anyway I think it makes more sense to pass in lock_dropped and get rid of
> mmap_locked in madvise_collapse() and just pass in lock_dropped directly
> (setting it false if anon).
> 
> Also obviously update collapse_scan_mm_slot() to use lock_dropped instead just
> inverted.
> 
> That's clearer I think since it makes it a verb rather than a noun and the
> function is dictating whether or not the lock is dropped, it also implies the
> lock is held on entry.

Ok I will give this a shot!

> 
>> +		struct collapse_control *cc)
>> +{
>> +	struct mm_struct *mm = vma->vm_mm;
>> +	bool triggered_wb = false;
>> +	enum scan_result result;
>> +	struct file *file;
>> +	pgoff_t pgoff;
>> +
> 
> Maybe move the mmap_assert_locked() from madvise_collapse() to here? Then we
> assert it in both cases.

ack, Sounds like a good idea!

> 
>> +	if (vma_is_anonymous(vma)) {
>> +		result = collapse_scan_pmd(mm, vma, addr, mmap_locked, cc);
>> +		goto end;
>> +	}
>> +
>> +	file = get_file(vma->vm_file);
>> +	pgoff = linear_page_index(vma, addr);
>> +
>> +	mmap_read_unlock(mm);
>> +	*mmap_locked = false;
>> +retry:
>> +	result = collapse_scan_file(mm, addr, file, pgoff, cc);
>> +
>> +	/*
>> +	 * For MADV_COLLAPSE, when encountering dirty pages, try to writeback,
>> +	 * then retry the collapse one time.
>> +	 */
>> +	if (!cc->is_khugepaged && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
>> +	    !triggered_wb && mapping_can_writeback(file->f_mapping)) {
>> +		const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
>> +		const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
>> +
>> +		filemap_write_and_wait_range(file->f_mapping, lstart, lend);
>> +		triggered_wb = true;
>> +		goto retry;
> 
> Thinking through this logic I do agree that we don't need to revalidate here,
> which should be quite a nice win, I just don't know why we previously assumed
> we'd have to... or maybe it was just because it became too spaghetti to goto
> around it somehow??

I believe the latter, the retry went at the top of the loop, and the
revalidation was already being done.

> 
>> +	}
>> +	fput(file);
>> +
>> +	if (result == SCAN_PTE_MAPPED_HUGEPAGE) {
>> +		mmap_read_lock(mm);
>> +		if (collapse_test_exit_or_disable(mm))
>> +			result = SCAN_ANY_PROCESS;
>> +		else
>> +			result = try_collapse_pte_mapped_thp(mm, addr,
>> +							     !cc->is_khugepaged);
>> +		if (result == SCAN_PMD_MAPPED)
>> +			result = SCAN_SUCCEED;
>> +		mmap_read_unlock(mm);
>> +	}
>> +end:
>> +	if (cc->is_khugepaged && result == SCAN_SUCCEED)
>> +		++khugepaged_pages_collapsed;
>> +	return result;
>> +}
>> +
>>  static void collapse_scan_mm_slot(unsigned int progress_max,
>>  		enum scan_result *result, struct collapse_control *cc)
>>  	__releases(&khugepaged_mm_lock)
>> @@ -2479,34 +2538,9 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
>>  			VM_BUG_ON(khugepaged_scan.address < hstart ||
>>  				  khugepaged_scan.address + HPAGE_PMD_SIZE >
>>  				  hend);
> 
> Nice-to-have, but could we convert these VM_BUG_ON()'s to VM_WARN_ON_ONCE()'s
> while we're passing?

Yeah sure, I have a question about these, because they do concern me (perhaps
out of ignorance). does a WARN_ON_ONCE stop the daemon? I would be concerned
about a rogue khugepaged instance going through and messing with page tables
when it fails some assertion. Could this not lead to serious memory/file
corruptions?

Thanks for the reviews!

Cheers,
-- Nico

> 
>> -			if (!vma_is_anonymous(vma)) {
>> -				struct file *file = get_file(vma->vm_file);
>> -				pgoff_t pgoff = linear_page_index(vma,
>> -						khugepaged_scan.address);
>> -
>> -				mmap_read_unlock(mm);
>> -				mmap_locked = false;
>> -				*result = collapse_scan_file(mm,
>> -					khugepaged_scan.address, file, pgoff, cc);
>> -				fput(file);
>> -				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
>> -					mmap_read_lock(mm);
>> -					if (collapse_test_exit_or_disable(mm))
>> -						goto breakouterloop;
>> -					*result = try_collapse_pte_mapped_thp(mm,
>> -						khugepaged_scan.address, false);
>> -					if (*result == SCAN_PMD_MAPPED)
>> -						*result = SCAN_SUCCEED;
>> -					mmap_read_unlock(mm);
>> -				}
>> -			} else {
>> -				*result = collapse_scan_pmd(mm, vma,
>> -					khugepaged_scan.address, &mmap_locked, cc);
>> -			}
>> -
>> -			if (*result == SCAN_SUCCEED)
>> -				++khugepaged_pages_collapsed;
>>
>> +			*result = collapse_single_pmd(khugepaged_scan.address,
>> +						      vma, &mmap_locked, cc);
>>  			/* move to next address */
>>  			khugepaged_scan.address += HPAGE_PMD_SIZE;
>>  			if (!mmap_locked)
>> @@ -2806,9 +2840,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>
>>  	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>>  		enum scan_result result = SCAN_FAIL;
>> -		bool triggered_wb = false;
>>
>> -retry:
>>  		if (!mmap_locked) {
>>  			cond_resched();
>>  			mmap_read_lock(mm);
>> @@ -2823,46 +2855,20 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>  			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
>>  		}
>>  		mmap_assert_locked(mm);
>> -		if (!vma_is_anonymous(vma)) {
>> -			struct file *file = get_file(vma->vm_file);
>> -			pgoff_t pgoff = linear_page_index(vma, addr);
>>
>> -			mmap_read_unlock(mm);
>> -			mmap_locked = false;
>> -			*lock_dropped = true;
>> -			result = collapse_scan_file(mm, addr, file, pgoff, cc);
>> -
>> -			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
>> -			    mapping_can_writeback(file->f_mapping)) {
>> -				loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
>> -				loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
>> +		result = collapse_single_pmd(addr, vma, &mmap_locked, cc);
>>
>> -				filemap_write_and_wait_range(file->f_mapping, lstart, lend);
>> -				triggered_wb = true;
>> -				fput(file);
>> -				goto retry;
>> -			}
>> -			fput(file);
>> -		} else {
>> -			result = collapse_scan_pmd(mm, vma, addr, &mmap_locked, cc);
>> -		}
>>  		if (!mmap_locked)
>>  			*lock_dropped = true;
>>
>> -handle_result:
>>  		switch (result) {
>>  		case SCAN_SUCCEED:
>>  		case SCAN_PMD_MAPPED:
>>  			++thps;
>>  			break;
>> -		case SCAN_PTE_MAPPED_HUGEPAGE:
>> -			BUG_ON(mmap_locked);
>> -			mmap_read_lock(mm);
>> -			result = try_collapse_pte_mapped_thp(mm, addr, true);
>> -			mmap_read_unlock(mm);
>> -			goto handle_result;
>>  		/* Whitelisted set of results where continuing OK */
>>  		case SCAN_NO_PTE_TABLE:
>> +		case SCAN_PTE_MAPPED_HUGEPAGE:
>>  		case SCAN_PTE_NON_PRESENT:
>>  		case SCAN_PTE_UFFD_WP:
>>  		case SCAN_LACK_REFERENCED_PAGE:
>> --
>> 2.53.0
>>
> 


