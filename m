Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9DC4C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 06:39:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98EB56B008A; Mon, 29 Jun 2026 02:39:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93F3C6B0092; Mon, 29 Jun 2026 02:39:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82F456B0093; Mon, 29 Jun 2026 02:39:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4770D6B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:39:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BD1738F255
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:39:34 +0000 (UTC)
X-FDA: 84931999068.20.FB67B9A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id E03BD40007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:39:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R3k9YUwH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782715173;
	b=47wxI4IGBfrYPucKPkG5xc7q2SPXR62BAYvKpq+//YjSt/KGUxcGDDusDqtUfXGsnR3ZXg
	CfC1EKj3R8zS4y22Gc4eH8VSh0duILm6MkRIDfPAjtWk2urFsCigLjHEgqFbCGQNL0xnPh
	nSfQz//OnW99M7Shwo/9S8vzEGvVW48=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782715173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cQw1a/kEB3mNmeLx7vc6yl8U+kM7fc1WO7NLhI45kwo=;
	b=bPnEzh1ELQ6Azxg+nG8H4yvcx47xc7sfz0kUMob0OX48UQZcV5sX1xt/zaMY0EsxQOUZg+
	qqs16G6iaA/ah4Pvvpvp2RHX3ndJvkN1Dec0p+0Q32WpBZnB5t1VYmASS2ZTNce9t5cKI6
	iSchMLlRaW1e03aVBcZ1Q7EG0v8A+xI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R3k9YUwH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 10FA5438DF;
	Mon, 29 Jun 2026 06:39:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023571F000E9;
	Mon, 29 Jun 2026 06:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782715171;
	bh=cQw1a/kEB3mNmeLx7vc6yl8U+kM7fc1WO7NLhI45kwo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=R3k9YUwHvqJr6hD5xfkx9NumEmjX/ilAxlkpJG1EZuq6alPxC5Y9iZKiztOuO4ZgQ
	 KPTxcb0fnk4uvqc7kShBOFHJhIHT/H/PDyoUn1nQ9cQlaXtnenyJEdQrmYVXHlTY7c
	 0MTnR9v6SajCC4vyDUw4TTkZUVIabyhlvg1njEulBEvfAD43hvmqvBa9uXtu/jx+cz
	 EP4CoCIVcWDTNEH85CmoXAoxoU/GFlSAv77Ou2u3u7mYSGdATE5wuxfTbLNXhBqQVl
	 PL8tAsTqKpriFyHM89UR4f6pbPL4F7+hd97SAL/RqTCS9Ui+Idf8ILiZYg4gUZviYE
	 niz6wrb/7SBvg==
Message-ID: <98f3aedd-de11-4a83-81b8-f3e3c9380e49@kernel.org>
Date: Mon, 29 Jun 2026 08:39:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] mm/page_vma_mapped: use huge_ptep_get() for hugetlb
To: Lance Yang <lance.yang@linux.dev>, dev.jain@arm.com
Cc: linmiaohe@huawei.com, muchun.song@linux.dev, osalvador@suse.de,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 kas@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 rcampbell@nvidia.com, apopple@nvidia.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 mel@csn.ul.ie, nao.horiguchi@gmail.com, ak@linux.intel.com,
 j-nomura@ce.jp.nec.com, pfalcato@suse.de, dave.hansen@intel.com,
 tglx@kernel.org, jpoimboe@kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <82395f5a-31d4-406b-b7ec-10d1a9d067d4@arm.com>
 <20260628054402.76978-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260628054402.76978-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E03BD40007
X-Stat-Signature: qzzm5rudkrkxycn5r3qyw4gnzj7k8s6e
X-HE-Tag: 1782715172-828794
X-HE-Meta: U2FsdGVkX1/MF6Wkm1rJnhXjAznmTEE824UT8X/PAt0pw1zuBBT25fQQS6VJ6b08nxpqZPt5Fi8hsnrTIMvdsqcarh0BHw7MmRD5DFVanh1j9gvsbXV9jyQQNQwBrKCEwRWafd/shVvP/eqFeyji1LDp7yjBJvCwjxitFlRXvnKUzfAziQVe09mbeLmPGJJqqM+9bpRB2nXkgtXRyKlijTM+yVZWjtJqcxASnA0hXAuBVkz3vsryubLyS3tBeXlXn+k/LmX2qAUlNKD9RP18xgl+8w3wu6wTzo4seTd8JiY19bA67sdHwopYaH6bQxmgv7axIDwtVYN15Acuth0niviVMaQf86peGpBPE3dTkXbek+chb6LPBlgEY67jeuKGxjwDR1Eem36HYwOPLk2JbPGlBsQIGMheJu/f55+O5rGpJypBBHNHUGS0vKN0avW2flf1t6tt8u5rVGuy2eDJ7xNBOOg6WvwXhoq3PKmPj0SqofkN/KIT8v5XtX20K0xs0slWi831IYLIvHFCrFv8s2GSbc95LvnHZFaooVKvh3wTd1DQjRm92ZDMmFVKrtZpi5oYlE8e9z3xZBfP2ZqO+3IMVN+5mDT467PI9IehlL/bTq/GRp3hQLuFfrcwF8hJcGlYT2YUuGJTiLYdFUGnw5w3CsXel4G1MWv7ZYiabslFx7Ig0HQz5pHstHmfhPe9gNNXxVP5TE0pRFNOnnBY9RFw+zOtnwdkfLqmI9a2UmGglySNX70iTvUHexXeHsKlOEz6wN4+3U4a2YolMR5AfRyGwz/Bw2ITEr83+w3q/ZpjU3MbBb8GTmkQmeECEav2106NMU6AZ07ywQO2xio1vXeBRrDRsq0Owh0vaavUhE8rA9M95ua+4B6KLvr2shKSwPzfQ2zdV2XvdX8JAPcI3I/GwpR03zuwchGyPTEIvZcUIVQe7ra0meRbPvraCiDno6FWVwZtOsRY04D3lUa
 9qMvswIJ
 8UQ8PqF4tB4AxIMzrQGOvd0Q2PlezlSMStIKpTVVZl3SoDW9Z0VcRLYA6TkBR9Tf2vhnpcOgx5isxv6uvl5E2wwfrHjFG8h39rrvFYMPyUDl29XDRzmbVleHKU/Yxx7Hp3mOswHPhbpNg4OHjf9c0EvEyUxIPfe0Q1J0h9fiGPJc3/9tOX1iF3b6qlBLc4GGg24vhxV19p+w4YKhcdC+dnNi60uldky9d80SbHCjC8brqZ8Xk7P0AfV/CcgI5Fxj5Ux8gdcguyeCL8COQhTkb+lxWjlpc1vj6t+lesPIF7CRKAJxCI2ZXMqzoZLnHl+Lv8L2O0MWJFN4JZ7rxRv5YOhOoA9gXGfCi3MMRLdRgkT0Az0e1X2SYZonF7rnvMqnGK0e8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/28/26 07:44, Lance Yang wrote:
> 
> On Sat, Jun 27, 2026 at 12:43:31PM +0530, Dev Jain wrote:
>>
>>
>> On 26/06/26 10:16 pm, Lance Yang wrote:
> [...]
>>>
>>> Just thinking out loud: given that huge_ptep_get() already assumes that
>>> addr matches the huge pte, at least on arm64, would it make sense to
>>> have a small hugetlb wrapper around it that takes hstate and aligns
>>> the address before calling the arch helper?
>>>
>>> Might make the rule clearer, and a bit harder to get wrong again :)
>>
>> Are you suggesting something like:
> 
> Yes, that's what I had in mind :) thanks!
> 
>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>> index fdb7bdf7645c..xxxxxxxxxxxx 100644
>> --- a/include/linux/hugetlb.h
>> +++ b/include/linux/hugetlb.h
>> @@ -825,6 +825,15 @@ static inline struct folio *filemap_lock_hugetlb_folio(struct hstate *h,
>>
>> #include <asm/hugetlb.h>
> 
> Maybe worth spelling out the rule as well: 
> 
> For arch helpers that use addr, huge_ptep_get() assumes addr is the
> address for the hugetlb entry ptep points to. arm64 already makes that
> assumption.
> 
> Callers where addr may not be hugepage-aligned should use
> hugetlb_ptep_get() instead.

Do we have any examples where code would do that? I would think that all code
must properly align addr ahead of times.

-- 
Cheers,

David

