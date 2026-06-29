Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8912FC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 06:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 805A06B0005; Mon, 29 Jun 2026 02:59:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78FCA6B0088; Mon, 29 Jun 2026 02:59:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6589D6B008A; Mon, 29 Jun 2026 02:59:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3DEFD6B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:59:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3A6A8C2846
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:59:36 +0000 (UTC)
X-FDA: 84932049552.30.10CB940
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id B843FC0002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:59:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DDHiMsy5;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782716374;
	b=rBZixbMlXD/RdztxRYAj53tdKjtwRzWJ1zvj9X2l/1YyoP40tv+bpJ5lpAfVzpDBvom6pG
	+v11bZk4yM3+0FW4f4Sy8uf8YrLTgLirkbTR1qe9yGAkjBpS3z59RgP+1yl7c/0ZDkOOJl
	4/b8ellXiLKjfeYJgA1qytLacgTrwh4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782716374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PHRiMqDlFwcJe/A5WBZFbr9/kLEIZnbR25zBaf1Mgu0=;
	b=quQADXjfpB2pL7HKr0y1yiFtTuRupTii9vF/FS8pKmb4/9d3+bHYEoA+jR4qYJpqzo784I
	PHk133cNSfrpio86tDpV2Af/RGp0dbt/bfRxaCDHKGJ/LAg/iQNa/+qUJ7+5avD7TQOlUi
	QboiSHjR8EtYmsh0A4d4597kVtHKnTo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DDHiMsy5;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782716370;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PHRiMqDlFwcJe/A5WBZFbr9/kLEIZnbR25zBaf1Mgu0=;
	b=DDHiMsy5WoetwRHmMY/f3MDGJeEIiEiSQlfiqCsqhkXrK0G8y2nHgKhJ+WyQoOzkR1Pj3z
	1J61aO1SyLsadSXK780OpBUYjd2sESHNxRD5m8AOU9clPbLrFQ50R1UkprCNTQkAsxEVO3
	Oeum72prWOggU3P3Aw11HExUVqbfbYY=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: lance.yang@linux.dev,
	dev.jain@arm.com,
	linmiaohe@huawei.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	kas@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rcampbell@nvidia.com,
	apopple@nvidia.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	mel@csn.ul.ie,
	nao.horiguchi@gmail.com,
	ak@linux.intel.com,
	j-nomura@ce.jp.nec.com,
	pfalcato@suse.de,
	dave.hansen@intel.com,
	tglx@kernel.org,
	jpoimboe@kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: Re: [PATCH 4/5] mm/page_vma_mapped: use huge_ptep_get() for hugetlb
Date: Mon, 29 Jun 2026 14:59:09 +0800
Message-Id: <20260629065909.88972-1-lance.yang@linux.dev>
In-Reply-To: <98f3aedd-de11-4a83-81b8-f3e3c9380e49@kernel.org>
References: <98f3aedd-de11-4a83-81b8-f3e3c9380e49@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ozju8i9o9mnngp3qgtq1pfrr6n14tbyc
X-Rspamd-Queue-Id: B843FC0002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782716372-261864
X-HE-Meta: U2FsdGVkX1+NVQfY33OB53g6GkTyc8HLMEQJfYKFMiEU6ictuZ+L5oKqX6ZgVXr4frC8B3puAPBW/GH1QxZoP1F+6/MulK2x7z+maKHti2+BZUIQIS4nECZqIey+GN2RvQhNQbYZsVtZqBrEPnzchqVoV5lU8LhDiG0X/nlcFSqcgea6Cor0lG7gx9MbsWysdJwNZeQa1Svew3kAFBaVVVUCF/YBfnxGKwr/zLtvpM11XgnIoNSCzzn2C4sOyEs3HV1CAyqSfoKoTBsxGWdE9VXfdDT3x/OTJAVSSSgc+UE9BedfX9ZtzssZIcLTjjQ/OiMYwzv2IzMBioM1ooDI68QZA6tn4J3K13GoHotE852SQ+11y03ROsyzBpZ5bOk7PapAUv1q7roO0JpUNGYFcEg0mz289oiGCNAN6rOGktdP8jC1HKlTPcvH4e18vrZEXseykJJwLbwMlHLVutQzUs08I/Qp0ZN2C/wPw9uN77g1nf0DGPNiz19L8QXC5pJhSAbC0Si+OAcDd+NzuBAL0ZSuq80satmp4tsVlSUQDeLz0KE496HKMccS2hqwI9Ukp1XPEVnufTzM1XlBCi3S3BBDgPL3B0xYOAa6+R2h+twC26fpBK0LETPq+YyuujrF139hbvg2wAYdcyrXPuypKxOqabzo6e2V1tpWdYUPHKWjBQoZocrwy9AeEIV4uY1Q2F2I5RPKMR+0spQzrM3V0JbZiC75qoF4/IdfxunfBQpJ3C8W/r2Fe1i86CaIsvVlXoIeEdQ8aUY3Yrzwfk/aDylkoupSJoiw11pZV/3/xVp2ore0jEyXvzoxXMvIPAUm5cZSbn/+Ai39L8zn9iZrVlO9MXyvcX2zb+6uvs7kgRE4OLfzLtNlMXdKhmZDSgrgUfGeLT+K+1StK+d4vvYWOP922d2RATrHE+UUjbMRlz7BlKsCP6rrv/IUcyNotpOn2L3vn+aHs3hmtesfngS
 fof+XgZM
 L6OodGoAIIWYRqf4WwJ1b9qI8QXkwmN4HTDFxEISMCqbd1mjrP8Y2U39k++1gWy9oE8+Xt5ZKj97e9Ti5IJs33q4PnICc5qyuK0+c9rirCpACOr9rcWCX4sEqhmS2WPrriQJAyoBgqY7+vxTB0cwaG7SzyhdAHhyoscnonjgVPG0aClpfiz2poV2v4RzuMBpDaeFmoHy9KTNpPqzNzUHVA8bKMWIab5vfvh/PnhPGJWX7SGMIPocBznS2fzuOULNeOhfvXfcnyfMrtpNGohItjAONtFyj8DoI9AGpGIoGfnb5L59og11ZSSvxnf1BtR+e8i8cZgu1IxkrjS2Mxk2TOoU0BtIvVqMycV6t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, Jun 29, 2026 at 08:39:22AM +0200, David Hildenbrand (Arm) wrote:
>On 6/28/26 07:44, Lance Yang wrote:
>> 
>> On Sat, Jun 27, 2026 at 12:43:31PM +0530, Dev Jain wrote:
>>>
>>>
>>> On 26/06/26 10:16 pm, Lance Yang wrote:
>> [...]
>>>>
>>>> Just thinking out loud: given that huge_ptep_get() already assumes that
>>>> addr matches the huge pte, at least on arm64, would it make sense to
>>>> have a small hugetlb wrapper around it that takes hstate and aligns
>>>> the address before calling the arch helper?
>>>>
>>>> Might make the rule clearer, and a bit harder to get wrong again :)
>>>
>>> Are you suggesting something like:
>> 
>> Yes, that's what I had in mind :) thanks!
>> 
>>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>>> index fdb7bdf7645c..xxxxxxxxxxxx 100644
>>> --- a/include/linux/hugetlb.h
>>> +++ b/include/linux/hugetlb.h
>>> @@ -825,6 +825,15 @@ static inline struct folio *filemap_lock_hugetlb_folio(struct hstate *h,
>>>
>>> #include <asm/hugetlb.h>
>> 
>> Maybe worth spelling out the rule as well: 
>> 
>> For arch helpers that use addr, huge_ptep_get() assumes addr is the
>> address for the hugetlb entry ptep points to. arm64 already makes that
>> assumption.
>> 
>> Callers where addr may not be hugepage-aligned should use
>> hugetlb_ptep_get() instead.
>
>Do we have any examples where code would do that? I would think that all code
>must properly align addr ahead of times.

I was thinking of the memory-failure case from earlier:

https://lore.kernel.org/linux-mm/20260626141031.14309-1-lance.yang@linux.dev/

There, page_mapped_in_vma() can be called with the poisoned tail page,
so pvmw.address comes from page_pgoff(folio, page) and need not be
hugepage-aligned.

Cheers, Lance

