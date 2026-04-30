Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FA69FF886F
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 07:13:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AD1A6B0088; Thu, 30 Apr 2026 03:13:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25DDA6B008A; Thu, 30 Apr 2026 03:13:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 173566B008C; Thu, 30 Apr 2026 03:13:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 03CFB6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:13:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8B6218BBA9
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:13:01 +0000 (UTC)
X-FDA: 84714355362.22.F68D7E4
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9179E4000A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:12:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fdBDf2sv;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777533179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gr6kV2S8/pIIk5nQOyl2HyoYuX7aTD9lGss4TIfvIBo=;
	b=4coQcyqWLkog2yVpOuO3z6fvXnfvdkz7ALPP/b5JH+MMfGiARQySvGr8DeXiBM7eLRCpNX
	6ibtATEDUw+AiBXS1cYRnTg9P2ln14BoMTwVjK28uDDQ3cMq5cg2uMnpINU5B8rdcgAZDR
	y/IVdgPSVO9pHtTuPFDvQQ+mkHwmaDs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fdBDf2sv;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777533179; a=rsa-sha256;
	cv=none;
	b=GYrTmu6y2Dnl1m8B0YBPihxvZ2fDF+Ew6HToel1BT1BEy/d8EMaMlOEtajMyyy/lgcY7Nc
	layJJ+Xz/5oh1wx+ovbzvAIjaYaJdXtZI78IaxenDPcznKjKoxD4YObcwNUN1l9xR3/U7J
	0I55ZhRhXMTxVbJjPId1vShmaLXhXk8=
Message-ID: <9bbd24c9-35d2-481e-95cc-459696221ad5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777533177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gr6kV2S8/pIIk5nQOyl2HyoYuX7aTD9lGss4TIfvIBo=;
	b=fdBDf2svHXrLC/3tVDKmwK2VODqqQ/i4sqxbhyouF3IAcbgY4qOaK5KkdytUNT9VICYPEp
	BgyS5bMsDpGOHW1YAhfbPdkWUFtFj7gTV9rHmKTsphwx0OwKyyk20d35sPdc/KKC3KEhmH
	IFxifgIGZfqY69y1+ScDw924Mv+PxpA=
Date: Thu, 30 Apr 2026 15:12:33 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/huge_memory: skip huge_zero_pmd in
 zap_huge_pmd_folio()
Content-Language: en-US
To: maobibo@loongson.cn
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <e3f542dd-f22b-fc8c-b376-72ab5909b6c8@loongson.cn>
 <20260430070217.39679-1-lance.yang@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260430070217.39679-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ik61ozafzue65gd8oawu3fce4ei34rrm
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9179E4000A
X-Rspam-User: 
X-HE-Tag: 1777533179-41278
X-HE-Meta: U2FsdGVkX1/SeLiECywIQxYeV3ZjJ0P1fkHAb3Bg3qNv3Is68889vvlCN1OD9kBJorZCxlY/nM6tdeYggnRNvwB4Sk1hfP8wJzQBjs/zKJxQSjSbO1HIiiejJHmxRoIROJ82tp3nLuY3B36OefsKYVd0OzbWR7GnWUJ4Dkl9AbUBaeKOvFF5ka+Z4aDjKMM1RNMuJMHzOK18urliKVIxv46DN9JqbXwTqQ5z1cFqlGzptpCVNIJTV8egCGPMR9jevkhkbqR0pQXE6JZ32dJW/Q2gTmEF45AzJFbGFXQklu77AN82gq8a5oH4goHgqMhQpHsv6DMu7Sv9EaKnuoY2x+5QRybkkf6BiRcpjE+lYECM/XHnShNjsyVY5NJzaH9Kl2HH0rYLRRnKjt22gv0nvIF+c9N8ASdR2JAPozaNwHAbDNe8OPh+J4EoxNU6aaF8ADCupTkGwT04KWXw9AoNz2NLYbCmvm3ogfqUqCDvdA4TxtzteuZFvkTV364lhk/HfK400k1HDWyOWhSzju16e86Z1EBfK2llE52oasjcxNis1bVzYyP1ouW2vWTAfiEC1voa7C4qcNcbaZ7WVbxsOwpuXHJ9tTRIFEq4cTrrlsLyK+p/1u8epl0xSriZpmcEwW5qFu3VtUUYGvodB4ptPyfYaKGgPJwuT0yqYg97W2GCWJuRigWCmYWnjrgcjPd6eMRLCa+x6cJDKn7EQwqRapis3jypgsETDILRlY61zQObeAdwX6txlM1aDiq9TYxBfh9oBrresP99vs+lG6/33LVPBqATxGt99948k5LDU2AshTs42tOMEEaRnp8ba5aHBXXRR55HrGxAq2Wl34uMOYDKntMHTMVQheF7o+sSVU737QI5GG/PShUqEh3RZypJcb1TNFAeWHOox4n35coTz5o59c5Lqf3VOVqpZti1cHRNUop4ABvko4yX4Yea7HYILTppQRrBCMP38vUALDl
 C/BY4cuy
 +Rbu5BuqLMVqlZQXiH8qLuHUXM/EDO3GSCeonYXjpRHsEyZnIZv6MCLomzOblhyfgLuJ/HkjdK7J1ZNV6KEAOFSZB3dBepAsJccxc3AhEc9VvSPWA7xKHRYLE/zJs+XMO66DSKzKMbnLVTTFb8STMOainNdAlSjWGD+zoUgUlV1XexmjhSCmigRH1VcNa7Rb0ezy4OlW0HZ2MWCZZWdM2V2Rbd2V/LkNYOBEZtz5lBTX6Qy1boOzq4KVshk/4JS+UxRPgZ4G61aaFPTALQQRTz9SomtUYImsXT/3j1e4C1HuJlBwx01S775E49aicWZMkbvjamnH0P4eERwk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/30 15:02, Lance Yang wrote:
> 
> On Thu, Apr 30, 2026 at 02:34:20PM +0800, Bibo Mao wrote:
>>
>>
>> On 2026/4/30 下午12:28, Lance Yang wrote:
>>>
>>> On Thu, Apr 30, 2026 at 12:11:20PM +0800, Bibo Mao wrote:
>>>> when executing command "make check" with qemu software, there is
>>>> error report like this:
>>>> BUG: Bad rss-counter state mm:00000000972846bc type:MM_FILEPAGES val:-4096 Comm:bios-tables-tes Pid:27802
>>>> BUG: Bad rss-counter state mm:00000000752180c5 type:MM_FILEPAGES val:-2048 Comm:worker Pid:27815
>>>> BUG: Bad rss-counter state mm:000000009c2f6a61 type:MM_FILEPAGES val:-2048 Comm:qom-test Pid:27825
>>>
>>> Good catch!
>>>
>>>> The problem is that when application exits, rss counter is calculated
>>>> with huge_zero_pmd huge page, instead it should be skipped.
>>>
>>> Looks like the same problem[1] we discussed recently.
>>>
>>> [1] https://lore.kernel.org/linux-mm/74a75b59-2e13-3985-ee99-d5521f39df2a@google.com/
>>>
>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>>> ---
>>>> mm/huge_memory.c | 3 +++
>>>> 1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index 970e077019b7..3cbea344d4a2 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -2423,6 +2423,9 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
>>>> {
>>>> 	const bool is_device_private = folio_is_device_private(folio);
>>>>
>>>> +	if (is_huge_zero_pmd(pmdval))
>>>> +		return;
>>>> +
>>>
>>> The huge zero PMD should not be returned by vm_normal_page_pmd() or
>>> vm_normal_folio_pmd() as a normal folio. If it reaches
>>> zap_huge_pmd_folio(), we already made the wrong normal-vs-special
>>> decision ...
>>>
>>> So I don't think we should special-case it in zap_huge_pmd_folio(). That
>>> only avoids this RSS decrement :)
>>>
>>> Could you please check whether the fix[2] also fixes your QEMU test?
>>>
>>> [2] https://lore.kernel.org/linux-mm/ea1453a6-14c9-4334-ac7e-2758586393b2@kernel.org/
>> yes, I think it will solve this problem.
>>
>> Only that I think that there should be tlb flush operation after
>> pmdp_huge_get_and_clear_full() even with huge_zero_pmd page, so
>> tlb_remove_page_size() should be called. Is that right?
> 
> Calling tlb_remove_page_size() is not necessary there :)
> 
> zap_huge_pmd() already marks the PMD range for TLB invalidation right
> after clearing the entry:
> 
> 	orig_pmd = pmdp_huge_get_and_clear_full(...);
> 	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
> 
> The later tlb_remove_page_size() is guarded by "is_present && folio",
> and is for the normal folio case after normal_or_softleaf_folio_pmd()
> return one :)

Forgot to add:

tlb_remove_page_size() queues the folio for freeing via mmu_gather.
The shared huge zero folio only needs PMD TLB invalidation, not the
delayed freeing :)

> 
> Please correct me if I missed something :D
> 
> Cheers, Lance


