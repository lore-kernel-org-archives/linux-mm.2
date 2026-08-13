Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5BAFC5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 00:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96D9A6B034C; Wed, 12 Aug 2026 20:19:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91F296B034D; Wed, 12 Aug 2026 20:19:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 836666B034E; Wed, 12 Aug 2026 20:19:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5823F6B034C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 20:19:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C79301404E7
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:19:10 +0000 (UTC)
X-FDA: 85094336460.12.7AA56B1
Received: from mta1.migadu.com (out-225.mta1.migadu.com [95.215.58.225])
	by imf18.hostedemail.com (Postfix) with ESMTP id 916C11C0009
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:19:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PIBXMJyd;
	spf=pass (imf18.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.225 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786580349;
	b=BLeM0Dw1llhGfod5Bva400i54pdi+SWf1hA46Yq63XUlbYzh7nCdGJU169C+iqyATDAgQf
	+mrlL0yyXDqw4/5P0836S8kY1WANboqfEH5aZvSUKG5oTLh56aalJNpgv3tiSHhNFN4kjU
	sa7IdpyZWRyK560xULryLuXlZ/UBshQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PIBXMJyd;
	spf=pass (imf18.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.225 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786580349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=01zg7q0TiaX9CIXombBTCWggr4FsazCPyESy5TD1+nQ=;
	b=0CVNUr2AINTOCzNwo16+KcofQ9IKNLXD0dWlr+dJrkLYes64878dgzNn6Nz9vH8zMFtLsc
	1s95uIbugDw+AS6HYgGzkDVez/mrXWk6JFgR9fck9U7VAdV7gYYkfmZuR6Z+s1QJVTdzo6
	l0YL/w6eQrDxOPd61/FnXB/pNSJ423A=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=o3kTi8xtJn486U9ig8F6Tlpu1rP9cqJ5DKdg5YgjGIQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786580345; v=1; x=1787185145;
 b=PIBXMJydsnwjR0et0+3llQuIQWY0U2P/88YMrEsKWzSXC5TzH5gDkLh7nKZvmPqzZljAWMmV
 TOT6y0FeEQG9aFv6HJR/Ip2xix1v+vku89QQn5BaN2Txkl7/Q3HEz8jkeF1BHNVsyognq795Jht
 Cs/Fu62lKDri7v5QaDi6iLEM=
X-Envelope-To: linux-mm@kvack.org
Received: from [IPV6:2601:282:1e00:c920::47f] (2601:282:1e00:c920::47f)
	by smtp.migadu.com with ESMTPS id ad50254a494f5427;
	Thu, 13 Aug 2026 00:19:05 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <b4b24576-507b-4617-b1b3-f03ef31934bd@linux.dev>
Date: Wed, 12 Aug 2026 18:19:01 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/7] mm/khugepaged: extract reference check into
 folio_pte_referenced() helper
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-2-ddac39d61c4a@linux.dev>
 <a23dd413-1462-4b7a-9ce1-136e1d806ed8@kernel.org>
Content-Language: en-US, en-ZM
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
In-Reply-To: <a23dd413-1462-4b7a-9ce1-136e1d806ed8@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 916C11C0009
X-Stat-Signature: 9bmxo8ba3b3xobqpteaj4kx9upnm8dyt
X-HE-Tag: 1786580348-305614
X-HE-Meta: U2FsdGVkX18zaLNvInre1BLfuStrGYMBI6jbHvf3v6X6WGGzSX6zTe3xpMtSu5ii7WzsAAy5nCd7UDRJwi7HRwwx5HX+qgIwb6uQU6S5on6+IVq61QG1QxdNTHg4lCIWcznY00tuUEDCMu/dfyMWmUKGbaFXFcE/2rlXTNUO5AvugdCWfU8UElBMfRy7YqIyG59FbPPc0s0R8EqJ3w92/bG7VQi+d6u9PL3TmGpD1zbPXulGP7Em2aywfqDHToUnKCG+2Ny3pFSjNjquKGHn0i620et+HpL7eZeoq/MBPSpBmYfZTJ8m6x8Xzme2KtmzeWYctwcUQmj5INXoR9EpVJXuib8Ea9uEeaKNXBX6oPMM8xAIEnwhunxJf8pQ6VFBXzlq+rkDIx9kScsaAbGDgU+L6jobZl2idn0VGc+PpaLV4YRJS6R5O2HJU+mUblHU3paNVySk12rxVwjbrZZ9uepX+X6XE8tJkzYqP8ogdBklpfqvCXYROmZ6Lkt79GQvOnm97QVlvu7SrZwKJ2lc2SEdUA2eG+XCfWY8twgKhKPTOaqPgsk04+pAN8p0WXLmJJTxsxhIdE/ecS4rLiGGKzCxxgrHwc1W/sGeaIbFhyL5IcN7Evdx7dEuKg7RpoOkGh9h8Aiig2/M6vG++b1LiTDLu4A4R5zKntBEIMhJEHpK9mXOE9CRSfkmtpIj2jvqZ9xzk14JCmI0gkTM/fyA2UHsE+FEvRIqgg+j2US1xen/MwRrYjM0IDoz0sJeFa1W9WalWyuIJIWFvdX28v3qMlOqOBwq1XK/jv49f9Qr2UOzzJd6iyFkPpgnAkh9u4i4HIbvf7r9y+mS44fwhvKaQfOnHjpiB5jLkzMDdvEIGjIXShteixfRZ3Ow5P4f7XmbVHMZMHtT2LjacIE1R3qWWG8boys+6/BSu8jipStiCisO0+K9YbQOkVARwVAWHGvecBuBourAPmWx8qH3MT6
 LbN2AzxW
 9r1yGRattb6zciNKS3f5QwAX/Ys2hwpIFs5hP2OUc7xWkDC5E0DpPQFCiJE6tVLueDF4adrkAPunVVFGsXWJORgatDA7RTCSQfK/b52+OPsTsCsXFZAaRVFvasZlSO5JWbqvi2a9VX+//2HwEgFEY3PBsSEGeduNI1w4ngVHbbAX3zpQWmowZmaL1y5oNOhrr1OLB4a5KFqltCbT1/eccVAdUgc3DWtSqDI89lciY1k5l75S42wcSawlSAiuM2EfUeJsSZqFCp+suUx8sO0sGTUXor54p73zl3bAkvFowYJSPRZWvEKEGvDpm6x8Woja6xd5JeVxeEqOy3xyNZ1PWTH25Np0B/EQXIjV9bM+OmrSycwFCac7TACSuUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/11/26 9:47 AM, David Hildenbrand (Arm) wrote:
> On 8/11/26 14:48, Nico Pache (Red Hat) wrote:
>> This change deduplicates the "is this PTE/folio referenced enough to be
>> considered for a collapse" condition that was repeated in both
>> __collapse_huge_page_isolate() and collapse_scan_pmd(), extracting it into
>> a single inline helper function.
>>
>> Also move the comment and use it as the function header. While we are at
>> it, updated the comment to clarify that a young pte is a recently accessed
>> one.
>>
>> Acked-by: Usama Arif <usama.arif@linux.dev>
>> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
>> ---
>>  mm/khugepaged.c | 32 ++++++++++++++++++--------------
>>  1 file changed, 18 insertions(+), 14 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 1e26ea97381a..8babd4c97db6 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -672,6 +672,22 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>>  	}
>>  }
>>  
>> +/*
>> + * folio_pte_referenced() - Check if a folio or its PTE mapping was recently used
>> + *
>> + * Return: true if recent access was observed through either the folio state
>> + * or the current PTE mapping.
>> + */
> 
> No need for doc for such a trivial internal helper :)

Ok sounds good I can send a fixup to remove it. Lorenzo has often asked for
these when I've introduced functions, so I've got in the habit of including them.

> 
>> +static inline bool folio_pte_referenced(struct folio *folio,
>> +		struct vm_area_struct *vma, unsigned long addr, pte_t pteval)
>> +{
>> +	/* The folio was referenced previously ... */
>> +	if (folio_test_young(folio) || folio_test_referenced(folio))
>> +		return true;
>> +	/* ... or the PTE mapping was recently used */
>> +	return pte_young(pteval) || mmu_notifier_test_young(vma->vm_mm, addr);
>> +}
>> +
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thank you :)

> 


