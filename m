Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30DD5CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 01:52:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 682FE8E000D; Mon, 10 Nov 2025 20:51:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65AF58E0002; Mon, 10 Nov 2025 20:51:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 598D38E000D; Mon, 10 Nov 2025 20:51:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45E598E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 20:51:59 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E64B212CD28
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:51:58 +0000 (UTC)
X-FDA: 84096650316.05.2AA8D2D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id CEDA14000A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:51:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762825917; a=rsa-sha256;
	cv=none;
	b=QvFJKAG4KubJZ5PxrkPVyUWWhc/30sBHK2SGQF8FKj2oQCEoRLlzT+LumJo2w6SLymKVWR
	OBvU2v/vZZxjq2b/iUHGLWE+4Ck4ox/nFMDscz3lTnopwN4piFwjV/cO2b0JhC4miE2Lci
	JF1LPPd/TJtMfn9w2W+TLMuuvKaMbTo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762825917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CA2LV1PfpewH25kilTED98zMl0rqhb3DbDe4FwzSNAM=;
	b=xSW6pjsmkb0sCrWwdnUROxsddIdW0tOWpBpXB6jA7ch8mamerym4DZiL/oghc2jD3/n9O3
	feZS0Ak/f4YXhB6QSZtEXEidOAml4aQSWDzUjJeQYt8b2O6LZQWyTSU8tyZNIYDGI3cv3J
	lr6OND5KHtVCv8lF4smu8TD3oz9/CQo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1952E2F;
	Mon, 10 Nov 2025 17:51:48 -0800 (PST)
Received: from [10.163.74.35] (unknown [10.163.74.35])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E0AB23F66E;
	Mon, 10 Nov 2025 17:51:51 -0800 (PST)
Message-ID: <73cd2390-f4c9-4b65-95da-a3b20994f958@arm.com>
Date: Tue, 11 Nov 2025 07:21:48 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/ptdesc: Derive from the compound head in page_ptdesc()
To: "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>,
 linux-mm@kvack.org
Cc: vishal.moola@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org
References: <20251110063725.3118037-1-anshuman.khandual@arm.com>
 <048f6173-f538-46eb-b0dd-70f1aaa79562@gmail.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <048f6173-f538-46eb-b0dd-70f1aaa79562@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CEDA14000A
X-Stat-Signature: znz8unbjteyhnpib76ngdwnerwnf1s75
X-HE-Tag: 1762825916-87053
X-HE-Meta: U2FsdGVkX1+MWGECbApUG86DqQj0tyXmt+T0QZEr+CCE6Y3K1idRwr7D4njjl/so54e1TvJAhWfuQxEnSfuNbVH/SlgmDW8CEUV2SoOxsKIHMb+1h9Vm/Vwj+y0h7QZHKD2BPOcjwIJFnhvNiqzU4O9qaeX2lQarl7trtU3sUE0wSQvVUPpZQY/rRFESpORpkAMd7zxiWsXpXmc1EPMj12de2lJSvCXyQkakuTrWiqo8z80+kx13Tm/8v2/BXqw53/oYIhACX08nl074flGbc2ZbIfGNVfGGN/6HT+RIbQEfvGBE8dAiWcUh14xRNDLMRmHNaEZk5M9gYUpu6DOj/rGTGWW1dkcIgvDbjFshbd2WqJ4HK1XCyO6KadYdXK6GelQH48HZRM6kYYLZxx14zETiC+PdRHj+TRr27FjS3PTyc/Kdf32XK96qdvEvab4tM3TPNbuKzFZFcmPGsUC/A8aIbrR7NWu73oTw4tNZmq+8phvfqwinH8LgaA9M6vumSskVEA3o9wbx1lIv7zLu8SPLa+KSwe9UjLfiHjmr04lJm8QZ+ScLadw/+5fKDW2Dz28pH2ERJXVghGYtNhXN2SXkYO0hyl3oIrgklDUU79XpKgMYZxuCY+3MUCgj2NaPzj0OtoJkZN0/z0O/p+k1XyNSP42buzN9tsI9OVpUudetPYJY/G7CvbvQGYN3XZ7bPMKvb8fBndk9cGMFw+ePAel3zSn6b5vdHLTwB9refTGG1vZUFYAYYnv7PkoQSjgY+qWJMmXOzHO8s52DfS3+Ko+kwqn7iUsEsCskv1zFUDQCg7UrOXWl38r3gV50U5PzgdxaUfVgbOYHlIc7Sz2Z7wfbiBKsSXmofsRH69eWSRQYuskUQppx+7yBc8Uy2rm/VOp/mCDs9kCyXun4iar0SRhBxRYw+hUpDMCN04/jAloDkBo7Wy8vQrfPyKcLJk0L6yJSKCmI6kLh916cBxI
 d9QiRusJ
 eWyVFnTve7d7pN0Q2DTB/AxY+dtT8K4GrZRe7CFCfPfdcv+ZCLxy3PYl+ye+EaQI6S29byi0xJLw9KGUjXXkFxoV0gJBatD3rDig/Vpi7WCmsJAYlnTKj7qwA4Zk8h32t5fjn1/eaUnkfqckc6pgplxBpgs5YzMxk+FRUVJpCxwxtfHVTzfoaWBJaUos557WbQr6bPadokeFmulkYhYb8eK6idRX0K4djsizSnshqGdgmDeEqpCZW1GkPOSxJeJMoi9GjodxyobCjCQmcQjqbvyxhAJkCSKuXEvCoIHELwoQR8X1kzEk/dmLgIFT4D6op8180hDtu476yksimDjfHbTbPEVMe0DvPBlqA5OK30KY1BkaN3kY8Wq4EPfIpmgAFK9qTBhf9Pdw6rHHNYzMeIUxodcAjhixY2YAT4LlP0kfkC8lNd3vt+RjmrfZXhQisszdmyU8Fn9o1VC/kyvGPqPfyzum6aOgmlzXoqAgsaZPyqcuUHyuMNViM0rX45YKkqf+HM6hZr3adW7fKqyZrgwoNyJjdH4BzlgR6POYjKRT+BlHFdbH2Q6sKuDTG/V6XYBPeSO1sTyL8g7j4MzonJZHRBCnhaaz/69nWvl0ruGh5xrcoTcHCOlepimwsp+DbboqkYxZOZYnE39vSEavI6dCBR0KOp9VLeeotNU7mrgMAYeY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/11/25 2:23 PM, David Hildenbrand (Red Hat) wrote:
> On 10.11.25 07:37, Anshuman Khandual wrote:
>> struct ptdesc (including all relevant helpers) support multi order compound
>> pages. But page_ptdesc() coverts given page into its own ptdesc rather than
>> deriving from its compound head as would have been expected otherwise. Just
>> change the macro to fetch the struct ptdesc from the compound head instead,
>> so that the same struct ptdesc is reached from all tail pages.
>>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Mike Rapoport <rppt@kernel.org>
>> Cc: Suren Baghdasaryan <surenb@google.com>
>> Cc: Michal Hocko <mhocko@suse.com>
>> Cc: Matthew Wilcox <willy@infradead.org>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>> This applies on v6.18-rc5
>>
>> Found via code inspection. Apparently struct ptdesc could represent a page
>> table page which is multi order looking into helpers as ptdesc_nr_pages(),
>> __pagetable_ctor/dtor() and pagetable_free() etc. Am I missing something ?
>>
>>   include/linux/mm_types.h | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
>> index 90e5790c318f..f7107bc55d1e 100644
>> --- a/include/linux/mm_types.h
>> +++ b/include/linux/mm_types.h
>> @@ -604,9 +604,9 @@ static_assert(sizeof(struct ptdesc) <= sizeof(struct page));
>>       const struct ptdesc *:        (const struct folio *)(pt),    \
>>       struct ptdesc *:        (struct folio *)(pt)))
>>   -#define page_ptdesc(p)            (_Generic((p),            \
>> -    const struct page *:        (const struct ptdesc *)(p),    \
>> -    struct page *:            (struct ptdesc *)(p)))
>> +#define page_ptdesc(p)            (_Generic((p),                    \
>> +    const struct page *:        (const struct ptdesc *)_compound_head(p),    \
>> +    struct page *:            (struct ptdesc *)_compound_head(p)))
> 
> Well, this adds overhead :)
> 
> The real question is when we would be converting from a tail page to a ptdesc.
> 
> Take a look at pmd_ptdesc()->pmd_pgtable_page() where we avoid looking up a tail page in the first place.
> 

Agreed - it does avoid looking into the tail pages. Currently there
are no instances where tail pages are converted into struct ptdesc.
But on its own page_ptdesc() does not look right and would not work
when applied on a tail page.

static inline struct page *pmd_pgtable_page(pmd_t *pmd)
{
        unsigned long mask = ~(PTRS_PER_PMD * sizeof(pmd_t) - 1);
        return virt_to_page((void *)((unsigned long) pmd & mask));
}

static inline struct ptdesc *pmd_ptdesc(pmd_t *pmd)
{
        return page_ptdesc(pmd_pgtable_page(pmd));
}

