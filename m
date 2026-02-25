Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9386AFD375E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 13:44:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3D4D6B00A4; Wed, 25 Feb 2026 08:44:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F157C6B00A6; Wed, 25 Feb 2026 08:44:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E17EB6B00A7; Wed, 25 Feb 2026 08:44:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CC5B36B00A4
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:44:18 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 801541C683
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:44:18 +0000 (UTC)
X-FDA: 84483098196.21.12CA056
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 00C0BC0007
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:44:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SpAiFJPc;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772027057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iKI5d80iNf5DVAtuh41BHGC4rcIetjz8N0i4qx5NPy8=;
	b=Y/0S+bJ/dVtl9wJkWXV5Y8bKQpvRHFRNLcd0/LH7c5R+VJBlHEAn4ZAcNv20ZmFTQNMb8i
	IlhHvrOK54rc+MpI8vxVnvx8rMx7cGTSdzru839GxF8wL0M3t992ioENGkfC8E3Y7/+FIu
	mBV92xd9JjRdA82gMJI+d+cqV0sjuYE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772027057; a=rsa-sha256;
	cv=none;
	b=L9gZIHOxCTJffDEY/xRk6uWSWpvcW6rTPgp8kIfWXG6TBaGWlydJM9DGGbQjdggHFtv8rr
	FhIZ6ylXGBVZCA6M/pxurzL2FeXmUlarlaeKsDfqmXFCNu9s2SGwOLUnVOqTkUKx2iSlNv
	nZMCX2YZsWerk1GsSQ5e8D9SOuFFbLs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SpAiFJPc;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 56EC86011F;
	Wed, 25 Feb 2026 13:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA52C116D0;
	Wed, 25 Feb 2026 13:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772027056;
	bh=ARdXTG2KcXABGnV51bTk0sFa9t4kT06+4nvw4wTpA2g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SpAiFJPcWumzD9KUnk4LIR5Dx1RgP30kUnv/949Qg4Z7M7bmOz+XsdkwxIDXRevbv
	 HJ7okfgYwgEdHbF4B4JOU0D3Iiurwg/f3vNNkD4VIE8c7hJ+kOKY+RkFphuKHx6M2n
	 Ml8B8RoTqArrzuNGEmUgASaIKhZl8GMjNuz+gemb6AZpnmTry012Rgxw/xmUykJBeY
	 Kua4nATj7VxPSDtZAzNQGoyXN2qydoIZzCx1SyV9zLbDgR93DVsyfACSji314wsrFc
	 UZvZw76SrM/MWpMn3DPNq0HhyVcnw90NZWIOThRlljQkacEQGvmWa+DWPRm6qlO0eh
	 o2gpt/qUgetag==
Message-ID: <cd29096d-7d99-446f-9371-df19c2eb5927@kernel.org>
Date: Wed, 25 Feb 2026 14:44:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v1 3/5] mm/khugepaged: define
 COLLAPSE_MAX_PTES_LIMIT as HPAGE_PMD_NR - 1
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, jack@suse.cz,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com,
 lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260212021835.17755-1-npache@redhat.com>
 <20260212021835.17755-4-npache@redhat.com>
 <493d7898-c959-42ee-ad09-35ffc631ec21@kernel.org>
 <CAA1CXcApttZPka9EDdo1fV_ZtktRcXKivQYmLQ=xiwrYFfL4-w@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAA1CXcApttZPka9EDdo1fV_ZtktRcXKivQYmLQ=xiwrYFfL4-w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 3oy8hmb1fnh8jx4zd4ikpwc4yyoqkear
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 00C0BC0007
X-HE-Tag: 1772027056-350867
X-HE-Meta: U2FsdGVkX18X6RmT/+A7FXOfKKWEmDGj5xfqYb33CSJAqek4/m8DX9uvv2JbLC9NXOhOL55f3Dq314G6ldZfXN8wGJJMyXkP2cgOb+yNinyNrdLwSz8mBmrXDOcHXYa6jqKLHYKlaPss78q+DvdJgrQ0OXbwqmRtL99rJqbFAR7n54nb+14YH5yH/pE6x4ycvJe2wLt2GQ3ZZnDf6/Cu48Wf43txbZnkL2hdaGsbNLxBjltC7KjZbNtjQgphJ2BW5k7us3vVbmAUJKpPkPyZeaaGL5wy2Q0fbgqxflLGKL2w2qwhPmJ4fBmXHoQVJTwiOSn5xAt9z4DLVIca8XnMy73hOlUrPINPM+4ycmCC84Aoz3gRbdIlfA8TLlM+48AysPzeSQkua+80L1Q0ccWl8BTpGdyuBcErR3F5PsSc/RFBWwuekSRl5kwHYpBG0SSLGjSKZFeGXWVtwFGdeiazEUxSdcqoCLQ+0Ag/jqZQ+ZLhKjwvatGKPJNvJXhn79bzVVHtR996AqDii4Z/Ly7w64UZQhybkXOv69BoS2FTkyHHFGaPLBTRlPzqIjBKnuOnweCsQbI23CQz5DiRJ/yLq/Jhv2VR59y3eSOaZ+YN+Qvu7h/MFybzS2HkI14AsT02wM2ijK7YeC2SPLo8n770OVUSbSeSBWU15mtUygXaK8xMgizFXe5e6D1saJZKhGfbME6xscZS46ij26gHFWM4WatLMyIjpKSImIC1cvypIEopwgFiyNxKQ1l428zvy7P1aoQ/pW5S0pNyRMi2uY7XIQH/UDkYMGLyFj+7jdWbk6BI+1XNaZLxuCxR2jIlWTqD08I0dQPNCsdPDJKhu8qmP4i7yx4QPBV2VEywBrc6SYaE8nHPss9Nqojv0hXtgDl1mWdVFejn/1H1NO0PWoyuzRDiUE+cFeUVyEWnqwoi/UR/Hc8TQ4phjlGorS3PLSW6SLrDJ+h03MK6b/vJTXv
 xKBSUgEG
 o1KqUGAgSUGj3Uj9wk2/evUeSZCJW+nRJKPhbB2RqTYPC5V4dSf5xHpYsBTjBtBl0Gm3S3Ee3FHs4qPM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/25/26 01:35, Nico Pache wrote:
> On Thu, Feb 12, 2026 at 12:51 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 2/12/26 03:18, Nico Pache wrote:
>>> The value (HPAGE_PMD_NR - 1) is used often in the khugepaged code to
>>> signify the limit of the max_ptes_* values. Add a define for this to
>>> increase code readability and reuse.
>>>
>>> Signed-off-by: Nico Pache <npache@redhat.com>
>>> ---
>>>   mm/khugepaged.c | 15 ++++++++-------
>>>   1 file changed, 8 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index c362b3b2e08a..3dcce6018f20 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -85,6 +85,7 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepaged_wait);
>>>    *
>>>    * Note that these are only respected if collapse was initiated by khugepaged.
>>>    */
>>> +#define COLLAPSE_MAX_PTES_LIMIT (HPAGE_PMD_NR - 1)
>>>   unsigned int khugepaged_max_ptes_none __read_mostly;
>>>   static unsigned int khugepaged_max_ptes_swap __read_mostly;
>>>   static unsigned int khugepaged_max_ptes_shared __read_mostly;
>>> @@ -252,7 +253,7 @@ static ssize_t max_ptes_none_store(struct kobject *kobj,
>>>       unsigned long max_ptes_none;
>>>
>>>       err = kstrtoul(buf, 10, &max_ptes_none);
>>> -     if (err || max_ptes_none > HPAGE_PMD_NR - 1)
>>> +     if (err || max_ptes_none > COLLAPSE_MAX_PTES_LIMIT)
>>>               return -EINVAL;
>>>
>>>       khugepaged_max_ptes_none = max_ptes_none;
>>> @@ -277,7 +278,7 @@ static ssize_t max_ptes_swap_store(struct kobject *kobj,
>>>       unsigned long max_ptes_swap;
>>>
>>>       err  = kstrtoul(buf, 10, &max_ptes_swap);
>>> -     if (err || max_ptes_swap > HPAGE_PMD_NR - 1)
>>> +     if (err || max_ptes_swap > COLLAPSE_MAX_PTES_LIMIT)
>>>               return -EINVAL;
>>>
>>>       khugepaged_max_ptes_swap = max_ptes_swap;
>>> @@ -303,7 +304,7 @@ static ssize_t max_ptes_shared_store(struct kobject *kobj,
>>>       unsigned long max_ptes_shared;
>>>
>>>       err  = kstrtoul(buf, 10, &max_ptes_shared);
>>> -     if (err || max_ptes_shared > HPAGE_PMD_NR - 1)
>>> +     if (err || max_ptes_shared > COLLAPSE_MAX_PTES_LIMIT)
>>>               return -EINVAL;
>>>
>>>       khugepaged_max_ptes_shared = max_ptes_shared;
>>> @@ -384,7 +385,7 @@ int __init khugepaged_init(void)
>>>               return -ENOMEM;
>>>
>>>       khugepaged_pages_to_scan = HPAGE_PMD_NR * 8;
>>> -     khugepaged_max_ptes_none = HPAGE_PMD_NR - 1;
>>> +     khugepaged_max_ptes_none = COLLAPSE_MAX_PTES_LIMIT;
>>>       khugepaged_max_ptes_swap = HPAGE_PMD_NR / 8;
>>>       khugepaged_max_ptes_shared = HPAGE_PMD_NR / 2;
>>
>>
>> Changing these is ok. I don't like the name either.
> 
> Yeah I prefer COLLAPSE_MAX_PTES as others suggested, its shorter and
> more general.
> 

COLLAPSE_MAX_PTES is misleading. We will happily collapse for 512 PTEs.

It's all about khugepaged_max_ptes_* semantics.

>>
>> It should be clear that they all belong to the "khugepaged_max_ptes" *
>> values. (see below)
>>
>>>
>>> @@ -1869,7 +1870,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>>       bool is_shmem = shmem_file(file);
>>>
>>>       VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
>>> -     VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
>>> +     VM_BUG_ON(start & (COLLAPSE_MAX_PTES_LIMIT));
>>>
>>>       result = alloc_charge_folio(&new_folio, mm, cc);
>>>       if (result != SCAN_SUCCEED)
>>> @@ -2209,7 +2210,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>>        * unwritten page.
>>>        */
>>>       folio_mark_uptodate(new_folio);
>>> -     folio_ref_add(new_folio, HPAGE_PMD_NR - 1);
>>> +     folio_ref_add(new_folio, COLLAPSE_MAX_PTES_LIMIT);
>>>
>>>       if (is_shmem)
>>>               folio_mark_dirty(new_folio);
>>> @@ -2303,7 +2304,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
>>>       memset(cc->node_load, 0, sizeof(cc->node_load));
>>>       nodes_clear(cc->alloc_nmask);
>>>       rcu_read_lock();
>>> -     xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
>>> +     xas_for_each(&xas, folio, start + COLLAPSE_MAX_PTES_LIMIT) {
>>>               if (xas_retry(&xas, folio))
>>>                       continue;
>>>
>>
>> Changing these is not. They are semantically something different.
> 
> With the new name these are ok right? given we dropped the LIMIT
> aspect. The only thing that comes to mind is that COLLAPSE_MAX_PTES
> would seemingly refer to 512 not 511, but I'm ok with that if no one
> objects.

Just leave it at HPAGE_PMD_NR - 1, any magical constant will make this
code only more confusing.

-- 
Cheers,

David

