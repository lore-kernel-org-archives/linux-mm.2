Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52BF0C88E56
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 05:22:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 727E86B008C; Sun, 13 Sep 2026 01:21:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 700D56B0092; Sun, 13 Sep 2026 01:21:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63CDE6B0093; Sun, 13 Sep 2026 01:21:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 471926B008C
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 01:21:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CC186805E1
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 05:21:54 +0000 (UTC)
X-FDA: 85207592148.21.DBE1141
Received: from mta0.migadu.com (out-19.mta0.migadu.com [91.218.175.19])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9DEA41C0002
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 05:21:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="CB/xRpGq";
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.19 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789276913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1aIoJzlExqCQlIqAQRBNKKVr8UFzQ0N5gvHtcl2/Qdo=;
	b=moRLOUgv4pfFR09Xu5HG0ZILL+G3VbyhMVRkbbgzKSsuSa08ctRJqzUozt7wNm2/NWVzgb
	Xdh4wJSJUtlD1EmHK2j97cCzOLsWpxR1Rr5Pkg5+8ENQLOGkVhJyUJUyNHrNEf/AY0ulHo
	nEBa9WbOT4oYHZJF+jtbTFrOGEusKz0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="CB/xRpGq";
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.19 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789276913;
	b=FRth0+hzy1cpGiT6UY6ptyFGUW2/8trWG34GWlBM18F8wtQH/hfPyNOo7Fk5zBacOeLHVk
	B4ZZkiEYYJOr9ZciFgyJbZEOGr6gtHBC5lCfChp84E4Mr7DEtF0YHnDczD5xScRiu157XI
	8132GEHN4aEW2Rg9d8JUSNQibu5vduA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RKmcLz7tqw9BoAn8ncge1YXquNNNISh1dupWXKD795U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789276911; v=1; x=1789881711;
 b=CB/xRpGqoCSpRxco6zev68F1o832sH5JYz6qf01yJJnISdcr0zpFAqczIM3ZnXssJacHdwLa
 RMCl4VCaXKIeiwv9Xon6rxzySloQpUyLV4PxycxQCocuHCQHgfCdePODcm/PW3UcL8XaDgm4L+D
 stxS9/G70hcMDoLzIpb3B8FY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4087794f270a1a0a;
	Sun, 13 Sep 2026 05:21:51 +0000
X-Mizu-Trace-ID: 4087794f270a1a0a
X-Migadu-Flow: FLOW_OUT
Message-ID: <afafcdd7-3854-4860-a12d-35498a007106@linux.dev>
Date: Sun, 13 Sep 2026 13:21:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 4/9] mm/huge_memory: use
 normal_or_softleaf_folio_pmd() in the PMD split path
To: yintirui@gmail.com
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, david@kernel.org,
 ljs@kernel.org, dev.jain@arm.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, baohua@kernel.org, ryan.roberts@arm.com,
 nico.pache@linux.dev, usama.arif@linux.dev, liam@infradead.org,
 wangkefeng.wang@huawei.com, chenjun102@huawei.com,
 linux-kernel@vger.kernel.org
References: <efae5222ad43f749c40aaca9b759b41844fdded8.1787941780.git.yintirui@gmail.com>
 <20260912073755.8403-1-lance.yang@linux.dev>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260912073755.8403-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9DEA41C0002
X-Stat-Signature: gc48rzquitokfhoz6ketj3bgsufzqu1i
X-Rspam-User: 
X-HE-Tag: 1789276912-345258
X-HE-Meta: U2FsdGVkX1+ZRbr/OErdhDrah3LHpE13L66HEM7c+yAjVWhD4hZRYJ3lMdoofXmwbf33EeoMu9dSaf/IPsuGjx9q6MFc/2o6Jv0Q2ti9ycp4wbHnlU1YdmUZkT/ldltak5Fe6rquyVe7f00eFxQveoTi2LrlIT4JT+dOCNpHh9sJchCWCMR2rsLAY9u4LSEX50p/2onOPAMNuFd3ZmFsDo3bqy0G4DnpWtHoiJTbXnJ0XAKqxBVehasOBRQqIxWKwrSuJeUBb9u7JPaDqv2IvFqnPTnFT2umvld/xxLTFgQUvG7YKe3CQU86H6yBqiPGyFXGvt/2589X8N+FALCZXuzp4Nr/wBpkS35VN8Vms0/A0Yqscjh4fkJOd7djPVfD6ucuEMtd7NI4fhoOREok0K/T78NXtAwWh82JLCLBlZQuzSHihSNleYn1a9kd7ZL2ie4Uehto3CGScOdNodLVsLBUCTtWWvGErjVGq0Gc6ySB4Ia+fb0/GPvBTLOnUs42qTD7agaI4WwDaAJ1/yktrhrtwnNNPzr9HbLgmc0/uWxLGAzZmH/yrX5zZryu84KZXPJug5jVwlyXPQ7zeKg17IZrRtNhiZnmZw+DaQhJN5XADGO4u6RzMkO2HwzjxS+rEJqHCipo7huTc+SVp67A+s6u1t3c/CdhucS9UUtFlEAGIz/CUZ3WQJvJrNIL80HqJGE+axFxBsxOmNhVJ9/1OyNKZxQnWo9TZcJggQv2hixyUX4SG01KO9OFTqLZGEbGtuHpb95n/geX0ejCPALYR4s8DshKcZQd0mhbTtfgW8Govp9GFIZl2yCXpIGqMQsco+mizFL9hMxpywM4Kz1stm7bAT/EFvnuXDWr6zg2JFWDvMhjZndvCkEB4up2Vl1wfNu7MlUWpYATzvejrm2BPg+vzzNdaGdLgWXAigpJtw7GTempaH6d39FeP286falAS/+MMWcu9dqmQZhidXB
 pB6OECSA
 8BbICozCyIqeiRtXy2X8ce/tvz6pB/ur4X3FHjl53XWoBmKR0Y7Uvso/7xWAdftc/vlPpxW2o5n7NnYAl11sZgEXyUNUMj1DueKvYtqfzA4x4PNPDWi+yjuAHTNxM05ywteF/Pue1xuZ6yym+vYhLWtOduVMY96scKExYCcGBlf1KoT0c7Z8RdaOkB2Ne4Y6P/6w1N4X9rBPcVdD0VVWFanTMwRudaCsiClpo50kS2AOPRvwfce38gFJHD31k2DAfV1ROfu9+KRpt1t4ajG6Lt8yNFbQpP3ItztL2vYohGvI+BPO9waqSh4e9XKG13k8CgholeYvYhQxlGKf887txkzeqfDYsm+jErInYttRf5IuQS+HJi2G9hW8kng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/9/12 15:37, Lance Yang wrote:
> 
> On Sat, Aug 29, 2026 at 02:33:14AM +0800, Yin Tirui wrote:
>> Get the folio once with normal_or_softleaf_folio_pmd() and decide the
>> deposit once with has_deposited_pgtable(), as zap_huge_pmd() does. That
>> makes split and zap classify an entry the same way, and drops
>> vma_is_special_huge() from this path.
>>
>> Behaviour changes only where the entry and the VMA flags disagree, which no
>> in-tree path produces.
>>
>> Signed-off-by: Yin Tirui <yintirui@gmail.com>
>> ---
>> mm/huge_memory.c | 21 ++++++++++++---------
>> 1 file changed, 12 insertions(+), 9 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index aefd62827139..b2ede9a6ae5d 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3172,7 +3172,7 @@ static void unmap_huge_pmd_entry(struct vm_area_struct *vma,
>> 	 * We are going to unmap this huge page. So
>> 	 * just go ahead and zap it
>> 	 */
>> -	if (arch_needs_pgtable_deposit())
>> +	if (has_deposited_pgtable(vma, old_pmd, folio))
>> 		zap_deposited_table(mm, pmd);
> 
> Staring at this ... I think we're missing raw PFN mappings of the huge
> zero folio ...
> 
> static bool has_deposited_pgtable(struct vm_area_struct *vma, pmd_t pmdval,
> 		struct folio *folio)
> {
> 	/* Some architectures require unconditional depositing. */
> 	if (arch_needs_pgtable_deposit())
> 		return true;
> 
> ...
> 	if (is_huge_zero_pmd(pmdval))
> 		return !vma_is_dax(vma);
> 
> ...
> 	return folio && folio_test_anon(folio);
> }
> 
> If a non-DAX raw PFN mapping on x86 (say, via mshv_vtl_low) matches
> huge_zero_pfn, vmf_insert_pfn_pmd() won't deposit a page table, but
> has_deposited_pgtable() will return true ...
> 
> Before this patch, arch_needs_pgtable_deposit() skips withdrawal when
> splitting this mapping on x86. The new check would instead reach
> pgtable_trans_huge_withdraw() and dereference NULL through pgtable->lru
> if pmd_huge_pte(mm, pmd) is NULL.
> 
> The helper already causes the same bug in zap_huge_pmd(), but extending
> it to split is a regression introduced by this patch. I'll send a separate
> fix, and we need it landed first :D

https://lore.kernel.org/linux-mm/20260913051942.40889-1-lance.yang@linux.dev/T/#u


