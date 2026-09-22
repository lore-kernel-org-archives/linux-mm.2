Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15BC0C982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 13:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D74586B009B; Tue, 22 Sep 2026 09:08:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4BA66B009D; Tue, 22 Sep 2026 09:08:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8AFA6B009E; Tue, 22 Sep 2026 09:08:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D8076B009B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:08:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 268F41604D8
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:08:21 +0000 (UTC)
X-FDA: 85241426802.26.C053F38
Received: from mta0.migadu.com (out-251.mta0.migadu.com [91.218.175.251])
	by imf03.hostedemail.com (Postfix) with ESMTP id D723220009
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:08:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tU7blQr8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.251 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790082499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vXH3psh98x4YI1o9dk0PnDbc2pw5/tnY8Y5fPRriv94=;
	b=NgNjbaBJHc4lVFoRg4tAoknqOdob5q7rbJSTpBdw2gzt8YouTQP0qRvXMq50PTtH0g6nxo
	BK+GTM+kpfF6R2quVFTXearN7engiEFW72Myzyhi5ts3XYDumu6GKID0vKbaY8lOhjUU4g
	78om1M8hh1s4KEibJBo/LyzQYtyH3L8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tU7blQr8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.251 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790082499;
	b=TlH+Vhh+s5WyxDuya+IVxq0+HR1RQsHFt7FrcwyYQcUOW6OtcqF19ciTFoh+SSgGhi+txV
	q8TM5tE194Z5g5xCns9tyCd1hmpdMTCNMqbiq3bF4HYww+fD8XyFmybXBO+aYCkjjkpd8I
	MOybCef4HvsWjoNqsMOfOdgXLbxVWrI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0Alsyxotn/BT24NUFO3uaJEACOJcA+aK/asZoGhrk7Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790082497; v=1; x=1790687297;
 b=tU7blQr8PWGgizHfk+JBKJU6XnHKl5+NXnM6gluYoGnW781aK07nXwarMf7TfEERxPO1qOID
 wGPrrp2oVRl3FlSu1gmZSXnag3z7sbw3qESgHgNeAVEf+nBDuoKTemgaHj6SgmYaQ0B3zS5WbyK
 eDk0ylRQ4Tfb+sEj67TvM6GI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 659ba7dc6cd41b5b;
	Tue, 22 Sep 2026 13:08:17 +0000
X-Mizu-Trace-ID: 659ba7dc6cd41b5b
X-Migadu-Flow: FLOW_OUT
Message-ID: <47ff450a-c2df-4520-8589-63dbb1746f80@linux.dev>
Date: Tue, 22 Sep 2026 14:08:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 08/29] mm: recognize PMD swap entries in the softleaf
 layer
To: "David Hildenbrand (Arm)" <david@kernel.org>,
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
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <bb4f8cf3-afb4-4497-adc8-6d8fa8982090@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: gk86fg514kh9byhap56hgdkmckmzf4af
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D723220009
X-HE-Tag: 1790082498-970608
X-HE-Meta: U2FsdGVkX18icnCZJv3yC1sU+whrRtl4EsnGpdhjsrzZ9L7X6jbBhVCJhoDcP51Ps+MmkoBRzC2ZLZk10C/dLk8SP0HkAvcY1alrflT7ou+Z6CEG1xtz3hPJTAGMtGTqflcp7Nfn65clPf7x58CxM9r2yy/OC3YQen7l4N1MFdFr/nPqfsiPOvLJ4gQrZIBquyt3KFvRTXWIGXm24YepsTA/7K8MNM3uUfdRN0IdtUygG3CgbRM35a/Aj9akgW6M6JeOZ1YNYwn6tPKFiyQOr2SJBYYqv0uqwSLNaaXjizp6b60hQnhrUrH52pYAGiaSsnmgtIGntRaWG8Vo67SE9nCUYHpLmZ5Hr/u1+ObnfhD81CngRzBE05wvwEO1FfPCkb9GSs4hvYu5FUu1lASgY7qT6b0Sxnm5NXlGm97yaVRDh9jmugVxF+KldE32VtQJCblfC46nCPky2dK9pEyWH74AFA96DlMr4U93CSebGlCMIzl5GM6/FuIT83zZe0V049249wbZcz3Te/l/UpM9ZQDUZyyQ8+U1bWBFPUtD+1yZPg84Vk2eldmC7VZPEcVLW6pjwP2IjYV56mCkkI4JDR6NU1PK6ykVf8GO3ADz8JtbKR2W6QpxVeKGBqlostPzywfbcb36SuR8vAOOimAhEpwMNKIpBGC1hqqggaLCgISEYNxbUVs2VGO/6cKdHpjeGQqRINGD4Ipirh9KiU9sZMb6aWWDc2Gf+M3OrLMSGkiCyDE3ghm/siWfXCvXg3OBSLt7WmFRCtB97CoYYASdYRMCv8Rn9j3iJZIuJTFSjMUMVMLH1dpxfhd4PbgomhE0v8Hj3ad4rhotge+0+fmmluv70trHK2xF9hCaDoBjMFc/Z4UCD8D17rMPp4NKfI4/M+54mfVweZN48KP+MoDF2UEs8yNSK2/vahKpl2EcFOnQVKnosWOjd0nrm14IFHXH3+cHHuY4Tw8DoYo3daq
 /fkdJs4B
 nhSLSGRJF6UBJTRstarqGuTcCVG8rbV8ECkWbwvFZPbrjImJjLTKv+A+xwViW1JMoUEZV1Q00407j8fracYVQtL0v1nIAVDShc/Go84UHMM0JG3bWuadcWFogqR6jDFlHARZ1FHGZbdlGG3ctKfWwy4rk4XHFABpir1hCKP1V7k3iKYvlb4ykUN5qAowTFNIsVNmXf6uUGctVzNF655v7Ctz3fyTPSCS1Diz24o78cNscxjGofvWzIndgudClx1G0M0kAk5z/g8bS0KZt/SCaeptvzWkcoHH0X5YOF5WkMWhAruJzlaZGgjSE/ahrgIU5MguV5Iy/RezWxSLFZVyBmIoUkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/09/2026 22:56, David Hildenbrand (Arm) wrote:
> On 9/14/26 14:27, Usama Arif wrote:
>> Reclaim splits a PMD-mapped anonymous THP into PTE-level swap entries
>> before unmapping it, so an ordinary swap entry has never had to appear in a
>> PMD. Later patches install one there instead, and the softleaf layer is
> 
> "Prepare for ..."
> 
>> where every consumer decodes non-present PMDs.
>>
>> Accept swap entries as valid PMD softleaves and add pmd_is_swap_entry().
>> A swap entry carries no PFN, so make pmd_softleaf_to_folio() warn and
>> return NULL rather than interpret a swap offset as a page frame number.
>>
>> Unlike migration and device-private entries, a PMD swap entry can also
>> carry the swap-exclusive marker, which softleaf_from_pmd() has to strip
>> before decoding. Strip all three overlays unconditionally while we are
>> here: each clear is a plain bit clear, so testing first only buys a branch.
>>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
> 
> 
> [...]
> 
>> +/**
>> + * pmd_is_swap_entry() - Does this PMD entry encode an actual swap entry?
>> + * @pmd: PMD entry.
>> + *
>> + * Returns: true if the PMD encodes a swap entry, otherwise false.
>> + */
>> +static inline bool pmd_is_swap_entry(pmd_t pmd)
>> +{
>> +	return softleaf_is_swap(softleaf_from_pmd(pmd));
>>  }
> 
> We don't have a pte_is_swap_entry(), I guess because we always want to handle
> different softleaf types through softleaf_from_pte() first.
> 
>>  
>>  /**
>>   * pmd_is_valid_softleaf() - Is this PMD entry a valid softleaf entry?
>>   * @pmd: PMD entry.
>>   *
>> - * PMD leaf entries are valid only if they are device private or migration
>> - * entries. This function asserts that a PMD leaf entry is valid in this
>> - * respect.
>> + * PMD leaf entries are valid only if they are device private, migration,
>> + * or swap entries. This function asserts that a PMD leaf entry is valid
>> + * in this respect.
>>   *
>>   * Returns: true if the PMD entry is a valid leaf entry, otherwise false.
>>   */
>> @@ -660,10 +670,12 @@ static inline bool pmd_is_valid_softleaf(pmd_t pmd)
>>   * pmd_softleaf_to_folio() - Convert the PMD softleaf entry to a folio.
>>   * @pmd: PMD entry.
>>   *
>> - * The PMD entry is expected to be a valid PMD softleaf entry.
>> + * The PMD entry is expected to be a valid PMD softleaf entry that references a
>> + * PFN, that is a migration or device private entry. A PMD swap entry is a valid
>> + * softleaf entry but encodes swap slots rather than a PFN, so it has no folio.
>>   *
>> - * Returns: the folio the softleaf entry references if this is a valid softleaf
>> - * entry, otherwise NULL.
>> + * Returns: the folio the softleaf entry references, or NULL if the entry is not
>> + * a valid PMD softleaf entry or does not reference a PFN.
>>   */
>>  static inline struct folio *pmd_softleaf_to_folio(pmd_t pmd)
>>  {
>> @@ -673,6 +685,10 @@ static inline struct folio *pmd_softleaf_to_folio(pmd_t pmd)
>>  		VM_WARN_ON_ONCE(true);
>>  		return NULL;
>>  	}
>> +	if (!softleaf_has_pfn(entry)) {
>> +		VM_WARN_ON_ONCE(true);
>> +		return NULL;
> softleaf_to_folio() does a
> 
> 	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
> 
> Just curious: why is that not sufficient? Which could would we expect to call
> into this fuction with nonesense? (same applies to the existing runtime check)
> 

Because softleaf_to_folio() warns after the damage:

  static inline struct folio *softleaf_to_folio(softleaf_t entry)
  {
          struct folio *folio = pfn_folio(softleaf_to_pfn(entry));

          VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));

pfn_folio() is page_folio(pfn_to_page(pfn)), and page_folio() is
_compound_head(), i.e. READ_ONCE(page->compound_info).  So a swap
offset interpreted as a PFN is already dereferenced by the time the
warning runs.

As for who would call it with nonsense: nobody today. zap_huge_pmd()
is the only path that reaches it with a non-present PMD and it takes
the pmd_is_swap_entry() branch first.


> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 


