Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69DA7CA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 20:29:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D5466B0088; Fri,  9 Oct 2026 16:29:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AC186B008A; Fri,  9 Oct 2026 16:29:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49AB86B008C; Fri,  9 Oct 2026 16:29:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E9276B0088
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:29:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 877BC1601ED
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:29:42 +0000 (UTC)
X-FDA: 85304228604.23.1008A59
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id A1624100005
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:29:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VWrw1TpL;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791577780;
	b=tEA5kBKmWhF+NYyDqvZChAval2Z2LkHg1sjY9x+xtlAD3aIWXz4xh1HTC60f6OVSdPI2oH
	eEiHvqAg+wB95W3WOb8QL8LhZdt/7Jn30Sw3RB5Bvr1hmMKC0VLmj4coUtVybJgB3iBtxL
	2FMt0jpIjt31SBTlPI4UOU9hrPLUmmg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VWrw1TpL;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791577780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u1g0SvFtSgoEeipo5pslivKZoZ99W+lzQ5LbgYZ+mbE=;
	b=EQM81eiwuwUUuvxpgSJ72lwBAiC8gKtoIdirf6Fs0AfFAVun1kiWYTpp7D4ABQEX6Pstvb
	VL2iGtWo8qgI6N+EQ6YgDVTL69sgEMZ3qUpjmfmcoXgirj94CMJUKqqFge0WW36c1arR+f
	Wo6v0phdGkxeW3Fhucq61V99S96d6aU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D0B8240F01;
	Fri,  9 Oct 2026 20:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774BD1F000FF;
	Fri,  9 Oct 2026 20:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791577779;
	bh=u1g0SvFtSgoEeipo5pslivKZoZ99W+lzQ5LbgYZ+mbE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VWrw1TpLt7fsJsfUReaMK/xfbuUimAtU/wsqb4NmTXYGEMibdlTCMOjp4yLzx5bWw
	 bYXFJ075+OS5qBU57lcr+O3mr1igWRZSgsgBqPR0EcyrFYU3BgDBfK+6B4paACiTWG
	 9Mr37E76WBFvA4UFAftI4savVj105aeAQ+cet/DtVBRN1JnAoQ5gIpwcY5GXe3J+rf
	 B7lzPr5P++51lX6doOqbwwqefTHSmzx6gKaQkWoo9RDxfZ9so/GkhNz5jBvwSOwHy4
	 6ZRikiPr8fM30rFvSV+jwP9Edp1VDQIjbn4K2VW68pCpW/rNyaKpcSfveDIEQ56w51
	 voBxssDX0NHOQ==
Message-ID: <1a0f51d9-7931-45a3-ab36-e0642c199a37@kernel.org>
Date: Fri, 9 Oct 2026 22:29:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] x86/mm: fix missing pgtable destructor for vmemmap
 tables
To: Muchun Song <muchun.song@linux.dev>,
 Muchun Song <songmuchun@bytedance.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, stable@vger.kernel.org,
 osalvador@suse.de, dave.hansen@linux.intel.com, luto@kernel.org,
 peterz@infradead.org, tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 x86@kernel.org, hpa@zytor.com, catalin.marinas@arm.com, will@kernel.org,
 mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 linux-riscv@lists.infradead.org, agordeev@linux.ibm.com,
 kevin.brodsky@arm.com, bjorn@rivosinc.com, apopple@nvidia.com,
 linux-kernel@vger.kernel.org
References: <20261008073021.2512665-1-songmuchun@bytedance.com>
 <20261008073021.2512665-2-songmuchun@bytedance.com>
 <ECC604FF-E74D-43B1-9105-A6683EEDE558@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ECC604FF-E74D-43B1-9105-A6683EEDE558@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A1624100005
X-Rspam-User: 
X-Stat-Signature: jhujpwbuaxennct7tchrsoooetpoyqok
X-HE-Tag: 1791577780-924748
X-HE-Meta: U2FsdGVkX1/kUyLsJJuEeU3PSF8t4zIFM+qAkFJ5kZKi8aUkUkTLY0YWrMkW8GUyU8nnrgNtH0OXyhkSbbWLzmcfZDUZqsmzHnR3Bb6w88S2mwneMU+6cIcKd3RxvKzdZMqI7rnUfn962YRt4Ac5F+JWtjnEZwJpm/4C+uaU3Q5UyceVEQA4Tw0NvgrW6f2gLPz7V8M2o7aZlNz6a66pkEIJOiug8RPqkTZKKmBMRerXMwuJ6Bx0UOggxs6F/fgvUgNKgzVlTo4prT9H9XymaRgscqTGrSHJu7H7EqQOmsWhCB7bJc8xf7ifSrs4W+0kD4kMf31fCAlUBh0JzYajaxjeDAoKd5bEjPpSULQI9NCk/pLaQJ0suGzYfuJy4sEy+o4bXXzh2Eq/WhouKwT9bzpycJ07L9zC4NExpfDRn+Ui56V1s32bmx7av6Gn/cgDDYXl8ZwnPw1Y1qrzmGQy81Pv+JkwObDtYdy4baUtWARgzvywZT+iyPPp2C04vI5ZDC0RMI8+halMQv1jTsYOMVAf0QB/iKH2VSGJsmpfFiyEMfOFL5uMN7SgJJqmwHqwZbKi6tRxgNn3a+9Wx8oWHW9JbYDBElOg3nbPQHhcg+KDREXreKSSKhp+OBC7I12GoFkYwNUo/zVBCwGAv4A8Kve7gkS6VZlzCyZPxoAgeEvIiSLh4lPe1pFpeD7noJS5QTyf7101hBFLN8N+nscTJF19Sc9iRVXf8jpaTEKuZQu+L3iMw3ODjfkY9x1NVhpdvZiomE1vsyq+UasslVvB+TzZng5eEkYRRxFDPzuuyQ+NdU0SafmAuOhQat1juFhSiMOAxH1SPOFaMqdNcZGQRuYYfhBVytEOlDQf4XjoSr5LyENlpJp4c4lQOClJzO9heIS1bL5vquLlGPCdYHfPcZ/cXIRPK1zD2YDkCenn7TG0StY8pKrgAvoPluPtQy9HmgQagDKv0L4sTMawp7P
 ZmKAnq1k
 Om8nQjpG1fuvwNBb49SpNl8Rr8vmPn09JXjRLS5fRqV1UUxEkUbVVJPRrjlwqtNJsrbJsO7mlgp9cxyoCDCwwtJPvmtHCkuNuSQ8LQa3VUr+tlGF73FPGjqaOCFN0dxA5KfTmAv7sDX8roYA3tA92V8f3qO07qw7YF75x0p9zvuBXKOjPF0sU6DgH8bpEs4oPOrMqNWDLbiET38KUHbvEuZatZXPjABhwnTLolnLU8uXrGc32RIBw1zq4zn9IF5NPWJG/tIsXJPy61iakloUcnqAC/xJ2TpOuGR7JGFUpbA0OGMRLZZoDbCqWdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/8/26 10:32, Muchun Song wrote:
> 
> 
>> On Oct 8, 2026, at 09:30, Muchun Song <songmuchun@bytedance.com> wrote:
>>
>> Since commit 49f599666420 ("mm: call ctor/dtor for kernel PTEs"),
>> pte_alloc_one_kernel() runs the page-table constructor for kernel PTE
>> tables.
>>
>> HugeTLB vmemmap optimization uses pte_alloc_one_kernel() when splitting
>> a PMD. Restoring the vmemmap backing pages does not collapse the PTE
>> table, so a later memory hot-remove eventually frees that table through
>> free_pagetable(). That path currently calls pagetable_free() directly
>> without decrementing NR_PAGETABLE.
>>
>> Use PageTable() to identify constructor-backed tables and run the
>> matching destructor before freeing them. Keep reserved and
>> constructor-free tables on their existing paths. This also prepares
>> vmemmap teardown for generic runtime allocations through the normal
>> pgalloc helpers.
>>
>> Fixes: 49f599666420 ("mm: call ctor/dtor for kernel PTEs")
>> Cc: stable@vger.kernel.org
>> Assisted-by: LLM
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> arch/x86/mm/init_64.c | 2 ++
>> 1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
>> index 70e682180291..a3ea627157ab 100644
>> --- a/arch/x86/mm/init_64.c
>> +++ b/arch/x86/mm/init_64.c
>> @@ -1003,6 +1003,8 @@ static void __meminit free_pagetable(struct page *page)
>> {
>> 	if (PageReserved(page))
>> 		free_reserved_page(page);
>> + 	else if (PageTable(page))
>> + 		pagetable_dtor_free(page_ptdesc(page));
> 
> Sashiko mentioned that kernel page table pages and vmemmap pages are
> freed to the buddy allocator before their parent entries are cleared
> and before the TLB is flushed, creating a dangling pointer window.
> 
> That's a a real but pre-existing issue, I will not fix that in this
> series.

Memory is getting removed, concurrent access to directmap+vmemmap is not
expected unless BUG I think. That should make this less critical I think ...
(except speculation? not sure if that applies)

-- 
Cheers,

David

