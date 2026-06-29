Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 419F5C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 07:48:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBD216B0005; Mon, 29 Jun 2026 03:48:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6E016B0088; Mon, 29 Jun 2026 03:48:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B83E56B008A; Mon, 29 Jun 2026 03:48:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 900CC6B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:48:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F0039120593
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:48:29 +0000 (UTC)
X-FDA: 84932172738.06.3889068
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0136C20002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:48:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Rql5VEcf;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782719308;
	b=02BdDr91m+5Zt0oTZjvIqz/aChzONzORqOuPR0XCdcHssEaU5LtnKPxNUy1ne+4NRuslCK
	vutvarzFNM9qVeLrnOWCL+nDsI1uYNvN/3HkPz80YJoYu6XSqTm5bUs0haklYCJ00vELWF
	3NhRwhtFRjam41pLZ4ExGF9D2QuYmVI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782719308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xGFa9gooeOspYp4vl0A+wPqxGnfwbnKJ6LWOLsX6z/o=;
	b=ohjQ9WvAxQ4P97a6qGlFM5yB8/BFjzufQSceYZ5KMnO+WsloHOfmtMqciyTbNBTNyP0rQD
	40Hlb80EJVhZ/KoxhSZBI5KnMJWt/ES6Lim7hdpf8lnFNXGJk4j02XrTVbsdHLuz/HjoVO
	yILqfmeenTL6B0kwJWgO6bsQQC4zgCc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Rql5VEcf;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782719304;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xGFa9gooeOspYp4vl0A+wPqxGnfwbnKJ6LWOLsX6z/o=;
	b=Rql5VEcfNlXPZKFLS7y5qlk8EU6IZxaJbezHUrEyFyoHcx4/+RH5ALnqLEtQaRrosJUh6V
	BUq7TMwlCe6PqgxaxGQgzR9vWrUGXjjgzDOCu2JvphUiefbDAjbSVDH2YOibNL+UhyRAsZ
	46K/CszOdo5gTI0MkiYa172hVlOhyMI=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org,
	dev.jain@arm.com
Cc: linmiaohe@huawei.com,
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
	stable@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH 4/5] mm/page_vma_mapped: use huge_ptep_get() for hugetlb
Date: Mon, 29 Jun 2026 15:48:02 +0800
Message-Id: <20260629074802.42727-1-lance.yang@linux.dev>
In-Reply-To: <0fabee2a-edb7-41c8-91ec-8cf0646c9e83@kernel.org>
References: <0fabee2a-edb7-41c8-91ec-8cf0646c9e83@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: ywe9zu4ca4uoi47krzsgtpj61z67xh5b
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0136C20002
X-HE-Tag: 1782719307-995855
X-HE-Meta: U2FsdGVkX19govrqQ+ZF+swmNE2TwaqRytDiiPzP+bBOuxP1dm4VOCw0Cot6yriN4zaYEmbf89A+azEaDAFpqQer01D3k7k4IzMgJwmHzYg9gsmoM2eoLp86bkd4WUq+Xb+aq6v8g5m2VVIazwjyB/bwlFHlgGBLgFE29H7KP4Dr6Mp0KsSC8oxTkYOqIi8sckbo0BCAK7BEU39TPUqGgTrgFv61lo3IBRWTdULmqr5yyW+WHFZQDJ/HEXVdY3x0NQaomeAo699XHIoolr44QB90py2y36/73xobOg3V1oukwvZPK3GNdB0jA1lejU2uxsU2OEEd2wtBJlMa4xUuOCUSevjuD2FdYXa4qf3L9lcUMxbbQ0WYQt2U0/669HEx1EQeM/KAkbuAbFcwmxImu6i7eagB7Bb48slX6GLMnMZRbKrjTeOLT2o1rbUclEf8F8Z/eFl8EHwpyE3tQfTPzbS8YI6tQRUnjyoD0uVdnRmvXHBWUpqo8a/wuDeCXjXSDsPD/lH4qDnp+jjeWYA4FKQA9Xq7NIjbnjY0nb6oFNL2aIylhdexMFfGW/EnerlD9oFyg09FUvjRypbPEjXDhKnwZ7KH3dCTK0I/K6TpxC3TPE3lWQKu96ctuRIkFLgs+NJNZTJqJrJfQ325rPkxL3nV+aE2G5yg4ktZwh6egG2L8dr8K5VHUtjojCN+hnn1xMvnerkd4gjbL4J0Bbv3L8BHN3PQ1VS79Bsp4O8L0K5Y4qy7RgwAOC3svHpMr1FeFBgZqOCGeR9dXO46iyktG3gDcN3tOOPro4CZMzGxIhGp811vR2xWeFNqyC9LpCr0Z79vSa0TGZay8SyMNWtJXxEHYjXQQ1RrI9V6xoX3lwgO4+hLkzoEWlBLL66GpLH2ugLLfuuDKjkkY3zjeOWHe60ACYZLaNdxMepFZE173sOevKVLDckJQz6ID2Jt/5jGxEsSGK3oj7bHlG8+MtS
 PlhBUEq/
 3uUijpiVC4Ytml475CSCR5Ifp4yzY6aD2k9AFIjRHuBFAMAnBA397UJpu3AKN4HT0etWZdrCGomG16pa/6ND17fUq3b/7Zt2bzSTWYZLX0WxnxwPimmlKdIK9E09IJUFHbdsRHOp3RM6iVgZwdihhI03Ea0cVwe/8jvUg76CFFtqmE5a7gRdxYWdXWzwgEpK+6hHDi223WWgGM0hZQ87GYoDqmFfAaR74/v4JXVhwdjPZtp1JsDUG/7kZPKGPkFWsmUXZFDF2geqvhlSc3u9DeWh7Nys6NQQ5Glv4Spi/HeWC/buFSnX2uOd0GLdzk/FxOb2+4uFYNWe1afKsmhzWG+Dqa2F8nAjHg1y2DXHSRA4e9or2enpra68o0QVxmws/hS1lFhiQby1ZdhL+mOR7dS/8yaSvr9IKUDIOF5aGLyKBXsc/sj1FZ7hfkWIle1bEwTuEJwglhqB9bzU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, Jun 29, 2026 at 09:25:48AM +0200, David Hildenbrand (Arm) wrote:
>On 6/29/26 08:48, Dev Jain wrote:
>> 
>> 
>> On 29/06/26 12:09 pm, David Hildenbrand (Arm) wrote:
>>> On 6/28/26 07:44, Lance Yang wrote:
>>>>
>>>> [...]
>>>>
>>>> Yes, that's what I had in mind :) thanks!
>>>>
>>>>
>>>> Maybe worth spelling out the rule as well: 
>>>>
>>>> For arch helpers that use addr, huge_ptep_get() assumes addr is the
>>>> address for the hugetlb entry ptep points to. arm64 already makes that
>>>> assumption.
>>>>
>>>> Callers where addr may not be hugepage-aligned should use
>>>> hugetlb_ptep_get() instead.
>>>
>>> Do we have any examples where code would do that? I would think that all code
>>> must properly align addr ahead of times.
>> 
>> Sashiko notes other places:
>> 
>> https://sashiko.dev/#/patchset/20260625112955.3254283-1-dev.jain%40arm.com
>
>Yeah, that looks shaky. We do seem to have a bunch of these cases, primarily
>from pagewalk code (where some users like pagemap need the actual address).

Indeed ...

>I think we have two options
>
>1) To prevent any (further) issues, make huge_ptep_get() always consume the
>hstate, and let the arch code deal with aligning it. Invasive.

Kinda lean toward option 1, even if it's more invasive. If we pass the
hstate down, each arch can figure out the right addr from there.

>2) Make the arch code handle aligning without the hstate.
>
>diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
>index 30772a909aea3..303a1b74796c9 100644
>--- a/arch/arm64/mm/hugetlbpage.c
>+++ b/arch/arm64/mm/hugetlbpage.c
>@@ -126,6 +126,9 @@ pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
>                return orig_pte;
> 
>        ncontig = find_num_contig(mm, addr, ptep, &pgsize);
>+       ptep = PTR_ALIGN_DOWN(ptep, sizeof(*ptep) * ncontig);
>+       orig_pte = __ptep_get(ptep);
>+
>        for (i = 0; i < ncontig; i++, ptep++) {
>                pte_t pte = __ptep_get(ptep);
> 
>(nshift/order instead of ncontig might avoid a multiplication, but not sure if that matters in practice)
>
>IIUC, that's similar to what huge_ptep_get() does on ppc.
>
>
>static inline pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
>{
>	if (ptep_is_8m_pmdp(mm, addr, ptep))
>		ptep = pte_offset_kernel((pmd_t *)ptep, ALIGN_DOWN(addr, SZ_8M));
>	return ptep_get(ptep);
>}
>
>I'd assume we could do the same on riscv. Besides that, I don't think any arch has cont
>entries.

AFAICT, for huge_ptep_get() the addr users are arm64 and powerpc, riscv
doesn't really care about addr there. Looks mostly arm64-specific ... 

>
>
>Interestingly, huge_pte_clear() / huge_ptep_get_and_clear() and friends would be all
>wrong when the wrong address is passed. But that code really is called from hugetlb.c
>where we should take better care of that. (e.g., partially zapping a hugetlb page is not
>possible)
>
>-- 
>Cheers,
>
>David
>

