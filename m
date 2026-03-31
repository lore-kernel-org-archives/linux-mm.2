Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62A2510F92FA
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 20:01:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8EFC6B0092; Tue, 31 Mar 2026 16:01:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A67EC6B0095; Tue, 31 Mar 2026 16:01:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97D376B0096; Tue, 31 Mar 2026 16:01:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 871516B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:01:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 54182C44A9
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:01:19 +0000 (UTC)
X-FDA: 84607427478.02.7D62949
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3FD18140013
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:01:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TdQhZogG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774987277; a=rsa-sha256;
	cv=none;
	b=Wrr0zQYzVurRwwWJoB2cUdVVVxGQNFqFJcu/34S0FImdiKNeiJhuSpcJ9isKTlM50xGFuF
	vWlaD/TB9NAg49aplM/4A2xzxcKfeAik0TuO5wWRcKQgT6UQdLbhP/JNQxke5l2SYku8im
	DFUBe4mB87vKypcOtyIXs5dVgEJ0ieI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TdQhZogG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774987277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L0f5F8q74CGLC+VH7hEjAcOx4xejY//woHRN/9kA/pU=;
	b=R9jjt3bahiR8LklzDs1+VgV9kczsPW8JfVIEWPRV1HWDRQQv8FkWYsSDnvNyg9HK5Ljssl
	RSj3HZ2g5xWQHpPVMD7xe3q4WhoB0k6I6cb6BR6t9DQ42a1VI9wF2lSXCuQwJJDvl1dMrU
	aeYwbHNOFUG7BwhFdHX9yV4bV+IBOX8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C2C1439B4;
	Tue, 31 Mar 2026 20:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F526C19423;
	Tue, 31 Mar 2026 20:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774987275;
	bh=kuEwNYJuHC5gEhU4Iai/CMNylkeBV67na+CIWWZy6No=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TdQhZogGxkhyUrr0rvgQYaHWDAY9Q7VMYbbQPkUz5koC6tSVAY3L72IGlMIPgYvo6
	 0hdshX27WRBpoluEOxy/Tx0NgDG97okbPAC424BFRM4/MroKRapiIZ6Tp/LVXsFDp5
	 XyN4JoAlxgkrXz2Yb3xH4CgOYLUbc9ToR0jDmmf46tGVswvN5UjD5Dyy+RRTBdb6A/
	 YuAlYOoCQUxezDcYdqfPkYInqCg3aYhz1XQK+PL9hLrTOymNvXpw/xwWEUu5kTip3X
	 qIb/5c/3rPSB9oqB9Uv65FK0rUAHgku0i6WOP2ViR91X1oQk9Jirf+ui3a9lz3e6Zk
	 qxUtvkvz0HmNQ==
Message-ID: <26fcec86-ee78-4f5c-8ca5-0e6230699cfd@kernel.org>
Date: Tue, 31 Mar 2026 22:00:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v4 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
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
References: <20260325114022.444081-1-npache@redhat.com>
 <20260325114022.444081-6-npache@redhat.com>
 <7760c811-e100-4d40-9217-0813c28314be@lucifer.local>
 <0223d45b-e8b4-49a7-882b-477250d0c14d@kernel.org>
 <fef63b28-a364-4e7c-bdbd-6d0403632920@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <fef63b28-a364-4e7c-bdbd-6d0403632920@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xc7zdfpogzjaci7gqrt9sxtbp4r8bx4r
X-Rspamd-Queue-Id: 3FD18140013
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774987277-967705
X-HE-Meta: U2FsdGVkX1/s65Vohh0pM7cnTlzGQqYHNxqFTRrnwV9nIC7p5hbUqTQrbYJ3XYXWuPjXel2gKRqZSvirM0uCSSzP5uR8Fr2AXtyQRU7buLTLRaU4X4HmXWgWo+OA0e+XlLqxYZhIglpz3pskiwJ/4aYQA/Y4baxkWoDRF626IzalixZ5Ee4MULebpvTsYIBHscU5yu+f0KL6zOtj+ryh5LvHSsdJGrws3xQpOKzKGz7Z9QB39xGnHpkQOLcIAJzQCTtlruNbxsfjRUWYDzLujLUnM3NyxH+EAE81+JgQjZXwk8TMI4jzlnCkVdWn2/GHObyICIT6z5U19Ys1ebZ1V+cKWSxQpGtQjeHWnCX89sv+dCnUOJ/C7Bi1NVt0LYmv0kRywfaB1Ul/022feXl+G4Nfp6GkNkwoyb8avkU9Okj7Fw3/9dpu6rrs9GPQbmy1+IsqujTku6cPL2tyYbtmh2gVNUbqjM7y7/XkJycnLkG5FZlD1/fb4+TucIm/gyVOxQZF3X6fc8Oj96k1nDKlqFt5mg57IeazPzjW3WHcfrQGKYcN+OhH8fTzFKNo1CKqT8rTsIwx7bFQKQaSCmguLoEsinY+eLxpvpoaeuksGKtJwPhlPcTWseGbTxLxEdBU6PpyGs5eEzmkZxAMUjP6Baz1plIY5PFAnCV+pfG94897AokzAAHNcXjBxTxPpAcYehipj1cG0pxhNzLqSZHywpqg1S15jGvHwcZ99kYSSyhbUv36EEJzeY8Oxn3PQccaZSw2iE55HgorFyQaQ82tB/TzQWaWbecxKZMbi3j9HSMLwk6dw4IFQZVIDLSobxurH4ZO2hxb0MwGEMqEkqCZ9AvsRdGRhU2xGh14dgEWwoNqgkHjKKtyFNCiPRK6syHIiYJbDhWqigDbIF2lGiHVbvQF4GkD/TE8IDcchsUtJ/EijcAlESitoRFpYUgnu6/E/YhAL88udk3PRHczqAh
 7POTuW8M
 EqaiK9L6XXpajRh0ZJeGbUEvC60jWeL+90LLNdlOMwpX0k+Hx2hXPzJW6Sf2gL7fjYtjFEJUdayBWk9LMq9Yb5PxOishK7YExJBfRAdo+OjlY5O0UT/F9odB3Q2dbYfb82hLVszDSWkKtn52XqjnP9Xf26zvOd8C2umkWBwIwVe+s5NUA6XMJRM7NWHTe6lUjvsQx4123j4vjwmuiYCv9vqfcU6SRzZ8fSsV5W+KEsIqUoH9hBccrz9il7fMXpz/ICJa9RcjJ6iE70pYlRxcFG1QU9Y7xqW/JuwemhHF75o+5ZEHGfqY+OhQ7lWtyonEiaGOsB173GcyVeSaUQ4b/FSdT1nqMAgjdJ2EAr8LOyM+q2Ui4kwmzV820yAT6nA+vudlhaddpt6/RlbPL/R1EeQv2kA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/31/26 16:15, Lorenzo Stoakes (Oracle) wrote:
> On Tue, Mar 31, 2026 at 04:13:29PM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> So this is the bug. 'lock_dropped' needs to record if the lock was _ever_
>>> dropped, not if it is _currently_ dropped.
>>
>> Ah, well spotted. I thought we discussed that at some point during
>> review ...
>>
>> Thanks for tackling this!
>>
>> [...]
>>
>>>
>>> ----8<----
>>> From a4dfc7718a15035449f344a0bc7f58e449366405 Mon Sep 17 00:00:00 2001
>>> From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
>>> Date: Tue, 31 Mar 2026 13:11:18 +0100
>>> Subject: [PATCH] mm/khugepaged: fix issue with tracking lock
>>>
>>> We are incorrectly treating lock_dropped to track both whether the lock is
>>> currently held and whether or not the lock was ever dropped.
>>>
>>> Update this change to account for this.
>>>
>>> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>>> ---
>>>  mm/khugepaged.c | 12 ++++++++----
>>>  1 file changed, 8 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index d21348b85a59..b8452dbdb043 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -2828,6 +2828,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>>  	unsigned long hstart, hend, addr;
>>>  	enum scan_result last_fail = SCAN_FAIL;
>>>  	int thps = 0;
>>> +	bool mmap_unlocked = false;
>>>
>>>  	BUG_ON(vma->vm_start > start);
>>>  	BUG_ON(vma->vm_end < end);
>>> @@ -2850,10 +2851,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>>  	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>>>  		enum scan_result result = SCAN_FAIL;
>>>
>>> -		if (*lock_dropped) {
>>> +		if (mmap_unlocked) {
>>>  			cond_resched();
>>>  			mmap_read_lock(mm);
>>> -			*lock_dropped = false;
>>> +			mmap_unlocked = false;
>>> +			*lock_dropped = true;
>>>  			result = hugepage_vma_revalidate(mm, addr, false, &vma,
>>>  							cc);
>>>  			if (result  != SCAN_SUCCEED) {
>>> @@ -2864,7 +2866,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>>
>> (in hurry so I might be wrong)
>>
>> Do we have to handle when collapse_single_pmd() dropped the lock as well?
> 
> That updates mmap_unlocked which will be handled in the loop or on exit:
> 
> 		if (mmap_unlocked) {
> 			...
> 			mmap_read_lock(mm);
> 			mmap_unlocked = false;
> 			*lock_dropped = true;
> 			...
> 		}
> 
> 		result = collapse_single_pmd(addr, vma, &mmap_unlocked, cc);
> 
> ...
> 
> out_maybelock:
> 	/* Caller expects us to hold mmap_lock on return */
> 	if (mmap_unlocked) {
> 		*lock_dropped = true;
> 		mmap_read_lock(mm);
> 	}
> 

Right.

The original code used

	bool mmap_locked = true;

If the fix get squashed, maybe we should revert to that handling to
minimize the churn?

(this is not in stable, right?)

-- 
Cheers,

David

