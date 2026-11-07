Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82D40606A32E
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 20:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LyMjq1S2
Received: by kanga.kvack.org (Postfix)
	id 6A9EA6B05B0; Sat,  7 Nov 2026 15:06:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65B7D6B05B1; Sat,  7 Nov 2026 15:06:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54A976B05B2; Sat,  7 Nov 2026 15:06:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F63A6B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 15:06:05 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9658240229
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:06:04 +0000 (UTC)
X-FDA: 85409404248.15.B7036C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id E0F0640007
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:06:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LyMjq1S2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794081963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z3oDyqgDBVuce1eKczb2I46fcE48/Nsk2k7Al2XC6OM=;
	b=yeKgHdXU93AmYJ0VsE+AjFV/skkWb7W22JHwr56tbyRQgSwXRVO3pG62ZGpBDzwnl+kU4n
	JMZR7uq5h5nrkBJTBcovhbGItDFErQT6DxEfLyjKLgegGlSRl/XpFEilP0c8oStxrqfp5F
	x2vnjEo8R6iTxmBw8PsiOPOzixqmFmg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LyMjq1S2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794081963;
	b=h/KhnlbgVoN4sN+7YiWR2Ck+7gAthpo47eiYJbNWa4HM9xM4z88iOxJzE0pMxEqBwgQj6c
	IQcc8nOGHAjsx0SZZd2qthc7jqla1QrxuMEPUJzaamXIRnJpZMfITFSL2daNRhOXq7+9QR
	pjAGEnPglPO+pH3nz5Kl5R2MzgKc5xM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 655B860D57;
	Sat,  7 Nov 2026 20:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002ED1F0089F;
	Sat,  7 Nov 2026 20:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794081962;
	bh=z3oDyqgDBVuce1eKczb2I46fcE48/Nsk2k7Al2XC6OM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LyMjq1S2WAolYZd76EhbJB1FgqYDBs7DcZjYqeRiLVsq1170bDG7Y12zYDonsbPNT
	 lg0M7URG6heOwJqV+kuEm9hYbeN2fBqeRkbCsLDZJb+9Wshgzn0MD9yugElny91E7X
	 oniUOhMLu8+2yu/SGKlFq1RU5j2rwn+wrQSFKSk2Qqgm5Rul2aojLZkR0kPjBbu69b
	 w4vuHY9dS2CsVAcqOpQSRfizM2bkHxp3rhKfZCEU1yb/CL1O3hFEMnwbldf+j6J2IJ
	 bC4MhtCahSKTQugMI1U+suda+qb8+wMVnoYcMsBB8hSCjfIFajD72Drg9MwmxdrpWR
	 sgwUb4M7M2R4A==
Message-ID: <47fee2b0-091f-4c20-9496-eff844ab2f6f@kernel.org>
Date: Sat, 7 Nov 2026 21:05:52 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: synchronize with PTE table reclaim for all folio
 sizes
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lance Yang <lance.yang@linux.dev>
Cc: baohua@kernel.org, akpm@linux-foundation.org, ljs@kernel.org,
 riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org,
 jannh@google.com, qi.zheng@linux.dev, pfalcato@suse.de, ayushr@modal.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <f06d2004-f3c5-46b0-b708-780ffd6727ce@linux.alibaba.com>
 <20261106023326.10838-1-lance.yang@linux.dev>
 <9916bea5-3b53-43a0-8f65-cc33995adb23@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <9916bea5-3b53-43a0-8f65-cc33995adb23@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E0F0640007
X-Stat-Signature: 7wr4g6znj3qd3s6m5nmj3dy5yn1tp7in
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794081962-501383
X-HE-Meta: U2FsdGVkX19y25cXXEvHffjyQNSXaz3Tl4f64ZJWPQ04lPhTTj1uFFUdtxY1vfrRUrkA5DExwlM5X6SHI11AbbwTjFp47G+iSrtkYqXI4zwZPqNJGnkyxAVxrC1qhI5r5z7TKPt3Nfxw5gM5pUjej+TgvjHxS1XAUSLyC8urT6o7UtBJ7JmqK/os4BhXFBWL5sfBJR3d+Z3yAZklcOS7NSI9A1zvS7mk7wJbZBRuJHSi8ysZ5fbdhJ+ZFgYk0s+qf/6Rb3uxADRBYm0SlJ9F9xq4aw/r4oeQ4Rihrpu/A9jbB1XGYvCVKq+e6yZwv4St2UGyMWEGMhBQEmtdtoDf+sYg99f16CwpOa5/9RY7fdxJUghwuphxjpLgDkM5btCIjxkLM/Gy0J0Rkpvuct/UvWtt4Az/g+F6BGERxiqgGOlOvZFMVNJdDJ18aaQbeT95WLCxB4HD/8kGutj/7MhZLG2IPwtHgZ+mFd8nr+BRx4rgtYJBq3mnt05A0DJCJ4NRQw17zXevDBEGyRkNgMbtFcntpsk43f65ZmNXWsr0XRaq4Lo80cQUs12qUU6QY+i5q56lXGl9YpUfEcAg2VZjWuMy3ZKiKJ1iwdyXuvQ7f9rtUe1zAytNfyWIDLy8YM/YmxhxsIFLjNfkfqxjA//R/8iAulTNRlRaMVhAouyb4FcW4RXh5gI8eqiIFK+Uta6C3pjeBAt1ZaLYNwN/Sq2XNUQ7BxYVRgAs3GrU2azj0A6gEEMOWZdTAl3dzC93aOrzXw/W1X3Lcro4zQB5S+ArV1YJ7BbFzGOydtOt5wWr+4FS9c7Q1vlxuOZPUlFhTyzHTytmcr4xWhMRRLHr5txlmYp/bRUukZDjG9zcrzGJivURA8w7cLkY+W7G+F2tTAaQcb0f9xNBUTmTIqjkPsP10C9yp51ev3SYkKoG0MZ0hWlucJ/tjgZmnPynCh1aT2JBhNjjK08FKNb62ZSmR7H
 yhI75zTy
 amp5l67jlwsCxUJX/1Ke9m9m2RSxOD4iT7W5xQbsEho6duvPJGumWOqmLpKmFp/Ic86R5aooithe9kggkFFGhhCY/AZWyP89l/xPJGuvKi7LYLzRR5Eh7qIFd+vEdQB247dVDNlmAZsrotTV6x1wokM2yzVipfu0pnhQaykXnIc9NZlfGoX7MlwDk72SJPOSrxGxBa0chHNBRsFCzFmVQkL/Z2GkgiTD80akyW4EObcBKs70FzVZva8GCv/4pq614iSnp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 03:54, Baolin Wang wrote:
> 
> 
> On 11/6/26 10:33 AM, Lance Yang wrote:
>>
>> On Fri, Nov 06, 2026 at 09:57:47AM +0800, Baolin Wang wrote:
>>>
>>>
>>>
>>> Thanks.
>>
>> Cheers!
>>
> 
> .......
> 
>>>
>>> I'm afraid the memory barrier here is subtle. __folio_remove_rmap() is
>>> complex, and in the CONFIG_NO_PAGE_MAPCOUNT branch,
>>> folio_sub_return_large_mapcount() doesn't provide full ordering, so we
>>> may still need smp_wmb().
>>
>> Yeah, agreed for large folios. In the diff above, only order-0 folios
>> use smp_rmb().
>>
>> Note that order-0 folios take the fully ordered atomic_add_negative()
>> branch and skip the CONFIG_NO_PAGE_MAPCOUNT branch entirely.
> 
> Yes.
> 
>> static __always_inline void __folio_remove_rmap(struct folio *folio,
>> 		struct page *page, int nr_pages, struct vm_area_struct *vma,
>> 		enum pgtable_level level)
>> {
>> 	...
>> 	switch (level) {
>> 	case PGTABLE_LEVEL_PTE:
>> 		if (!folio_test_large(folio)) {
>> 			nr = atomic_add_negative(-1, &folio->_mapcount);
>> 			break;
>> 		}
>>
>> 		if (IS_ENABLED(CONFIG_NO_PAGE_MAPCOUNT)) {
>> 			nr = folio_sub_return_large_mapcount(folio, nr_pages, vma);
>> 			...
>> 		}
>> 		...
>> 	}
>> 	...
>> }
>>
>> And large folios still take the PMD lock :D
> 
> IIUC, the memory barrier optimization targets all non-PMD-sized folios 
> (including large folios). That is, for PMD-sized large folios we still 
> use the original PMD lock, while for other non-PMD-sized folios we can 
> use memory barriers to sync.

It would be nice to prototype a patch and document the required memory barriers
and how it is expected to work.

-- 
Cheers,

David

