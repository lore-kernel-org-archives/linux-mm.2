Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B8E8C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 14:48:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A2176B0093; Tue, 22 Sep 2026 10:48:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 779A16B009D; Tue, 22 Sep 2026 10:48:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68ED96B009E; Tue, 22 Sep 2026 10:48:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 466966B0093
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:48:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C2FB0404C9
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:48:51 +0000 (UTC)
X-FDA: 85241680062.08.02EE2F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id E59451C0002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:48:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KlCNBB/p";
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790088530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2nC+4Iujr6aKs/X6DmrJUSeJqe7aXLMr7UtX3jEw9Y8=;
	b=DaauHgqN6WhV684+vGbg5kQstofEE3+NyaMVSKSXZHR3fuEZptFjk/gxmFA6PK8BQe1XyH
	nY5Xzu44PazN8PPhPgZYdFkUvNJjKgFjmSdEP8QNgDcaut5pfJsDAocSzgqQTLLWsmGrz8
	Q4PXSIYfbUciQSTEO4liBfVPfyZ8ONw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KlCNBB/p";
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790088530;
	b=E7844/kyWhdCJD1v2aSSN2dmbsqb4Run8008EeJ0votLsrcv5Eo/EWkS3Mx4uPL3aJmUv1
	KXmbRi9rxGLRlDsGJYwxOSos2+Ujql85CaW2RqyZwe9fB6SgXtfOR2gdjrManNTITMH2G8
	VDILzJnGvY7Wdp2UusLWzwI113DOrj0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BE6C41F9F;
	Tue, 22 Sep 2026 14:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEA11F000FF;
	Tue, 22 Sep 2026 14:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790088529;
	bh=2nC+4Iujr6aKs/X6DmrJUSeJqe7aXLMr7UtX3jEw9Y8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KlCNBB/pRmBcWRkN5rgO1CAIPNCqGtKjNZQDWlNRIpflyWihuVVSoB1WuY85jHBg2
	 i254OvM/DNaWmjsj294C5s6McXHOL9dxgMgQE69ZbesKz3zHghquFjmsm10I3dy/+N
	 7vKwjWbUCFw3R9s9cjoIs4y0qbACZUKITuIXJJAoLimblf7Ss16+tLRkP+GHhix5EW
	 YjwKbEhfOIPrS8ipScASQxJ6qcNXHz7ocvy2CIVE7E3I93XSMtoSJ/unpOtRx2nMs3
	 KT41buPpA6i8lEwxzora/x71CKTIGHAUT8Le8f5TbuxfcNs9441IqxMFKA5JWsETXo
	 pxd8tftqpLGVA==
Message-ID: <f4d4c4d6-cebb-43d7-b5de-c4a94662f081@kernel.org>
Date: Tue, 22 Sep 2026 16:48:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 08/29] mm: recognize PMD swap entries in the softleaf
 layer
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
 luizcap@redhat.com, kernel-team@meta.com
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-9-usama.arif@linux.dev>
 <bb4f8cf3-afb4-4497-adc8-6d8fa8982090@kernel.org>
 <47ff450a-c2df-4520-8589-63dbb1746f80@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <47ff450a-c2df-4520-8589-63dbb1746f80@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E59451C0002
X-Stat-Signature: bw7x5mqtsdkj8tq633u7oonqi9ntrxbd
X-Rspam-User: 
X-HE-Tag: 1790088529-30845
X-HE-Meta: U2FsdGVkX1/6m7aHKzwRYisyI4R9tJ3SsJqNLeRnfBvHClmnb9691vSy5s2RPmEi7iTLP9oiq2LLOlwlzMLarbSdOVVGiTRwJ4KhidbMx4iFasbkMT+pfBRZB+o1zSN8SopY4jsUMxMe3Qz9epuR2PvYgBSM4u6+2V+QPCkUh8sh/pgWLGIsGEplTuMrnnRf2i7rAscQQS4Fb1vwsbeWZ7uSmtoe5EhMceBxnKfVJiS9nDRM2JUJYcJUcrMeIh2yUGtG88zSUCemibyt8lsdJ1nni92oPlhvmzR4atDYnWUYsmnTKUISQdgvbL2ka+8meFE6PJjVVJxHQrVYtZ9N80s9V5q9oxSalJZ46hPBq1m0P0jEeMKpn5+wsSLwIG3jQ4KhVW5PVhVb/hEtR/kRv2Wrn18XAtSZcpSXPGV73RCb+CXt+iiSZB2aMUJKn5xu2JiAl9SzAlE/qN+dnidC2dpK5o5yEYjbyDLkqsNRwnx9y0p8M/mY4kWnLKCwhgNOqyY4jloF65wMcos3FQj801/WCPxaxu/Au0gwoMegEORz/OMVLcZsvai2v3crUhQNpgyahn5mZ5/2+KyKkZElS0ZEHUJbK3JOEQh5Q3s5gSsEhn0Z4pYY2lU7Th61WAIDfuvqskIN2uZCT8f9NS7Cpce+tDzoZPsK0XajbnXymtWHiDtlAdonX/mWj32MdAUZ3kBPwaKVcH5nVP7fTs3NfnF0GUpNhutfROHnLA44a1EzOQpfVz6Wgkyp3IPO/QFh8mu6F364ECcTuahEzSo+hUrHnkY1npaIe+sFQDPiykTPsbbsjqJYthz4dbH6VUG+UEYib2fbK1Pl+qb5oWZ9ZP3AENdTsTeIBbslbbkSGoy3wEWik3dtXopmMjwpecZjmxP1wvFXEmCRDG12HL8Jk+OKAhw7YnZ9r5qfmY16XYrSFOmE3NrOlFOTdJWTOwS/4G6RIjqBglTJxVJoH//
 Gu1gdSoE
 HmlcTT5i6dfhVWhJH2VtCEQF87DAKX5aCSiq0pqtcbus91pQjp5RH/vnnzRm7wcnDMdqCRgAfFo7cdCwMT10pBk8gG8e03qsfLShUZ0opjEJF43FOTXXJB4cl3SmX3d5S2SVm/jkOlhAt3pgZveD0bqeXorf4l89x+MMaDGQepWZvuE3FgeipC7jdIbWD1kgnrR1Sn6fnKs4+gucF7gMP+Kgoq2rm1wbF03QEuHBbqKFje7wc/hxWkcKO56pZ7ytnHwWd5+Aybgh+kRg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/26 15:08, Usama Arif wrote:
> 
> 
> On 18/09/2026 22:56, David Hildenbrand (Arm) wrote:
>> On 9/14/26 14:27, Usama Arif wrote:
>>> Reclaim splits a PMD-mapped anonymous THP into PTE-level swap entries
>>> before unmapping it, so an ordinary swap entry has never had to appear in a
>>> PMD. Later patches install one there instead, and the softleaf layer is
>>
>> "Prepare for ..."
>>
>>> where every consumer decodes non-present PMDs.
>>>
>>> Accept swap entries as valid PMD softleaves and add pmd_is_swap_entry().
>>> A swap entry carries no PFN, so make pmd_softleaf_to_folio() warn and
>>> return NULL rather than interpret a swap offset as a page frame number.
>>>
>>> Unlike migration and device-private entries, a PMD swap entry can also
>>> carry the swap-exclusive marker, which softleaf_from_pmd() has to strip
>>> before decoding. Strip all three overlays unconditionally while we are
>>> here: each clear is a plain bit clear, so testing first only buys a branch.
>>>
>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>> ---
>>
>>
>> [...]
>>
>>> +/**
>>> + * pmd_is_swap_entry() - Does this PMD entry encode an actual swap entry?
>>> + * @pmd: PMD entry.
>>> + *
>>> + * Returns: true if the PMD encodes a swap entry, otherwise false.
>>> + */
>>> +static inline bool pmd_is_swap_entry(pmd_t pmd)
>>> +{
>>> +	return softleaf_is_swap(softleaf_from_pmd(pmd));
>>>  }
>>
>> We don't have a pte_is_swap_entry(), I guess because we always want to handle
>> different softleaf types through softleaf_from_pte() first.
>>
>>>  
>>>  /**
>>>   * pmd_is_valid_softleaf() - Is this PMD entry a valid softleaf entry?
>>>   * @pmd: PMD entry.
>>>   *
>>> - * PMD leaf entries are valid only if they are device private or migration
>>> - * entries. This function asserts that a PMD leaf entry is valid in this
>>> - * respect.
>>> + * PMD leaf entries are valid only if they are device private, migration,
>>> + * or swap entries. This function asserts that a PMD leaf entry is valid
>>> + * in this respect.
>>>   *
>>>   * Returns: true if the PMD entry is a valid leaf entry, otherwise false.
>>>   */
>>> @@ -660,10 +670,12 @@ static inline bool pmd_is_valid_softleaf(pmd_t pmd)
>>>   * pmd_softleaf_to_folio() - Convert the PMD softleaf entry to a folio.
>>>   * @pmd: PMD entry.
>>>   *
>>> - * The PMD entry is expected to be a valid PMD softleaf entry.
>>> + * The PMD entry is expected to be a valid PMD softleaf entry that references a
>>> + * PFN, that is a migration or device private entry. A PMD swap entry is a valid
>>> + * softleaf entry but encodes swap slots rather than a PFN, so it has no folio.
>>>   *
>>> - * Returns: the folio the softleaf entry references if this is a valid softleaf
>>> - * entry, otherwise NULL.
>>> + * Returns: the folio the softleaf entry references, or NULL if the entry is not
>>> + * a valid PMD softleaf entry or does not reference a PFN.
>>>   */
>>>  static inline struct folio *pmd_softleaf_to_folio(pmd_t pmd)
>>>  {
>>> @@ -673,6 +685,10 @@ static inline struct folio *pmd_softleaf_to_folio(pmd_t pmd)
>>>  		VM_WARN_ON_ONCE(true);
>>>  		return NULL;
>>>  	}
>>> +	if (!softleaf_has_pfn(entry)) {
>>> +		VM_WARN_ON_ONCE(true);
>>> +		return NULL;
>> softleaf_to_folio() does a
>>
>> 	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
>>
>> Just curious: why is that not sufficient? Which could would we expect to call
>> into this fuction with nonesense? (same applies to the existing runtime check)
>>
> 
> Because softleaf_to_folio() warns after the damage:
> 
>   static inline struct folio *softleaf_to_folio(softleaf_t entry)
>   {
>           struct folio *folio = pfn_folio(softleaf_to_pfn(entry));
> 
>           VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
> 
> pfn_folio() is page_folio(pfn_to_page(pfn)), and page_folio() is
> _compound_head(), i.e. READ_ONCE(page->compound_info).  So a swap
> offset interpreted as a PFN is already dereferenced by the time the
> warning runs.


Heh, and in softleaf_to_pfn() we have another

	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));

So the one in softleaf_to_page() is rather useless already? :)

-- 
Cheers,

David

