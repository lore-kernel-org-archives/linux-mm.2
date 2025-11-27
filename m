Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E810CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 08:35:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD9A96B0022; Thu, 27 Nov 2025 03:35:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB1206B0023; Thu, 27 Nov 2025 03:35:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ED5C6B0024; Thu, 27 Nov 2025 03:35:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CEDB6B0022
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 03:35:49 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2687B140989
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 08:35:49 +0000 (UTC)
X-FDA: 84155728818.24.C0E54F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 505852000A
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 08:35:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JgZwtp8T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764232547; a=rsa-sha256;
	cv=none;
	b=pnYOJvEi/YqsMynVGivLplP43Lp0olZiJ6MUW3Y8ZYO3VmjfapSdMT+k88KZe+PojRJKhQ
	kG+n1MOMApNz3P3V+1UWUhb77D3cVh49MkkcFdLSiYxTqh3lWOV0Z4+51NUBuou0/Y1Vob
	HiXfqW4HlvXAom5uAUrKlk76AYu9L0c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JgZwtp8T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764232547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NN/qtxM9gQI/WFD3wEaliU/Ai+7zohP2JGTV+gE/dOA=;
	b=W0/VcRCK+YBNzBzvL9JBa9DyIQ2I3jF93tZTYdYML3t5obei0SuskRSPX9e0EbBLifbSdC
	lyiHDeZlArq591NIgpSXxMPdJ67XOlRJ8h+/YB/za6tz4E7WMRbwubwH8AR8U+fd5Ox9dL
	OpCCUpjH8MtWCui99QVrW1jhiiT+guI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3167540879;
	Thu, 27 Nov 2025 08:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E346C4CEF8;
	Thu, 27 Nov 2025 08:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764232546;
	bh=qx0VZrdqJksxpKXVCVyXb4JAI2P5dCq0KsV9HbIKGek=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JgZwtp8Tu+n8p3LaI0AsCxvsyQZRHcTfkmQ3l9GMb6+DsJHERvHrUAVvuNANZGssM
	 1M16aKThUv8pm2fpPqzK2E3IHdPvq+aq3wozuehRIzN/auBNvkuBrLr6jWjsAJGCMq
	 gKw7f/dbAyg/ijfp+HAJRn+vODfnzRDqa1NPE8PNzovArQpUEyQnNO9IlK9lVOFcaU
	 rIQPl3NMUd1o23B2Hqadw35UJ/5HrnWAquZp5u0emedD51lI/HoUp9yu7BgsLOvQ8k
	 XMwxnK1OciERhD8X2cpmZm/yFv7fG7M0DIasL3/JLatgVzgnVpA/FBj2y3iK0eiQu3
	 ClsmI9yWdvtIg==
Message-ID: <46ca641c-6a39-49e4-b1b2-23262841ecc8@kernel.org>
Date: Thu, 27 Nov 2025 09:35:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/22] mm: Always use page table accessor functions
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Wei Yang <richard.weiyang@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Samuel Holland <samuel.holland@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 linux-riscv@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org, devicetree@vger.kernel.org,
 Suren Baghdasaryan <surenb@google.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Conor Dooley <conor@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Alexandre Ghiti <alex@ghiti.fr>, Emil Renner Berthing <kernel@esmil.dk>,
 Rob Herring <robh+dt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Julia Lawall <Julia.Lawall@inria.fr>, Nicolas Palix <nicolas.palix@imag.fr>,
 Anshuman Khandual <anshuman.khandual@arm.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
 <20251113014656.2605447-7-samuel.holland@sifive.com>
 <02e3b3bd-ae6a-4db4-b4a1-8cbc1bc0a1c8@arm.com>
 <bc88d132-452a-42a1-9ee5-5407334d8aac@kernel.org>
 <df7d10ba-bb42-4ea1-8c5b-5db88a18eccb@kernel.org>
 <6bdf2b89-7768-4b90-b5e7-ff174196ea7b@lucifer.local>
 <71123d7a-641b-41df-b959-88e6c2a3a441@kernel.org>
 <c0818f5b-b8a1-4730-aa1d-df0f547a3d47@arm.com>
 <20251126134726.yrya5xxayfcde3kl@master>
 <ee5f5da3-8c6b-4381-aee8-b0fab56cbf83@arm.com>
 <a33b87ab-b24f-45d5-bd4a-646988b54a2b@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <a33b87ab-b24f-45d5-bd4a-646988b54a2b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 505852000A
X-Stat-Signature: btnkdiouekdu4eu19hkb1emsykztc4fi
X-Rspam-User: 
X-HE-Tag: 1764232547-682794
X-HE-Meta: U2FsdGVkX1+GFws04cmDhGpHuRRcAfT2dJWo4UWXwseb23+8gsd09TUYKpVIgMp4NifTJKw3Pa1JS3L5NqPpoiic0KG3Pn3+lbFuh9GtjfheveDw59YUg+qOl5MwmH78I1G0cbXSaB45u+SphmZq67WDljiZbD0PLZ5dzEKuV+GqpEcA85sNZz58UeNnSHkvONbUTVBdq8qdCVnSn2YS8qg2lcGuOrJNDBuvEZMKGrGTwfBYD5V92MOEIp2FdTK2C0jw14S2MmIo4334wvmlPcQWbaHRUixqO8SHx172B4/4sOEN59/5NLfJwYRVfR4BdnJhjhpczaxxfPb064mpPa79CYX0ekSN7zu67fVX/eS9qB8Yu8WlvdVRXfSpdt154YRIeD9Tz1OGZ4ejMvAcImKPMG1BuoBS0MMQkOTbr6rOGSP0qo/WQiLj+97+kkL4oTH0m0314GTsjID8b4S7sp5NcH/BJ1/gf7gt3ToEdkyRfHpXnSKSULMn8Mea/3MdbpirBQyRBJH007s8Gn3RI7hjGixX26yTFneWdEmxMcecAjFc2tdGJg2Be0MVvvYS496F9bXCMcbUXDUL5tgA5PEit8LqCONSjtMZlSnzkXYbs8j/TUTJ0s9KegDNCICcin1ipspOxulKl2YwOHf3zfP58X3nrq2khNSl8d/+5TiNsWiMEd7P2Bs+o9MwnmURC2uCcZKjuFNdndn7wn+m6x8kkK6pjiuxeGKAf9b1pq1lyHomwmrdzjG817DYSdrPEimYqT5ZCgxfRh7u5BZ8Fc7eWxDpm2ftsUqIOuVIzpLb3e2YNgNguPYeEALYjv1X7LIdBAWZPgS20j2C4eMlIDk/gaJaYhifqTB/WXJfZrjOmYV6Fm361PrdZKkl1XB+VpAnb7dSvtxvBklAP/LCP0eqXEWfxoxTuhgnu/Veed/qOlycbaeThhlhLtYCeWc9bwCthVNIDPcHwV5rB8b
 9fvrGh3X
 VHmd9EzGuED5ElEXxFv0xZYCS0+SvCCxcz0nahsgZ+7L+y5J3fTYYUF6mGXiya/qFVkghHOEAXNIFMKXSQ+9U1wPs9udLrceoWZSe2bmUQuaF++FzF/fhrpqMuprVtA596E/xKx1ZHUePhxlaZkfGks4HcBVaZlRL/IDBc1Hbb5R97s+MxWn7Ixhx451ZqKqd3Qtab87Lx+GDHIueXruAirj5Z8B0FqsFKPLv7Fvf8mtZhQcRbcd0dyW/AdT6KusnV6vVkRLt8fThJCSqpwIU5b4ufuKTxstPV7DpiIa+nUkBqFEesZPbVqt7NMN8K00GlyUKJECUTpNugKqAk6fa+1aTBy0YHRe2MGP4LxiMhCKGhaUmr++WS0LSq9BiVaPSAiqFxfyL5VP6xAUk7EdYSrQ9gs8iq3dHLN5tkbAyq9ofiX+CFA+iVaJ7NkCUEG7Mj0bihGzI9/hH8rM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/27/25 09:26, Christophe Leroy (CS GROUP) wrote:
> 
> 
> Le 26/11/2025 à 15:22, Ryan Roberts a écrit :
>> On 26/11/2025 13:47, Wei Yang wrote:
>>> On Wed, Nov 26, 2025 at 01:03:42PM +0000, Ryan Roberts wrote:
>>>> On 26/11/2025 12:35, David Hildenbrand (Red Hat) wrote:
>>> [...]
>>>>>>>>> Hi,
>>>>>>>>>
>>>>>>>>> I've just come across this patch and wanted to mention that we could also
>>>>>>>>> benefit from this improved absraction for some features we are looking at for
>>>>>>>>> arm64. As you mention, Anshuman had a go but hit some roadblocks.
>>>>>>>>>
>>>>>>>>> The main issue is that the compiler was unable to optimize away the
>>>>>>>>> READ_ONCE()s
>>>>>>>>> for the case where certain levels of the pgtable are folded. But it can
>>>>>>>>> optimize
>>>>>>>>> the plain C dereferences. There were complaints the the generated code for arm
>>>>>>>>> (32) and powerpc was significantly impacted due to having many more
>>>>>>>>> (redundant)
>>>>>>>>> loads.
>>>>>>>>>
>>>>>>>>
>>>>>>>> We do have mm_pmd_folded()/p4d_folded() etc, could that help to sort
>>>>>>>> this out internally?
>>>>>>>>
>>>>>>>
>>>>>>> Just stumbled over the reply from Christope:
>>>>>>>
>>>>>>> https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flkml.kernel.org%2Fr%2F0019d675-ce3d-4a5c-89ed-f126c45145c9%40kernel.org&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7C22d0a028b1ec4a8b678108de2cf73769%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C638997637481119954%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=ocR6usVgRHfue0MrtbQnDO8whINvy%2FDMAfNE3caiY8c%3D&reserved=0
>>>>>>>
>>>>>>> And wonder if we could handle that somehow directly in the pgdp_get() etc.
>>>>
>>>> I certainly don't like the suggestion of doing the is_folded() test outside the
>>>> helper, but if we can push that logic down into pXdp_get() that would be pretty
>>>> neat. Anshuman and I did briefly play with the idea of doing a C dereference if
>>>> the level is folded and a READ_ONCE() otherwise, all inside each pXdp_get()
>>>> helper. Although we never proved it to be correct. I struggle with the model for
>>>> folding. Do you want to optimize out all-but-the-highest level's access or
>>>> all-but-the-lowest level's access? Makes my head hurt...
>>>>
>>>>
>>>
>>> You mean sth like:
>>>
>>> static inline pmd_t pmdp_get(pmd_t *pmdp)
>>> {
>>> #ifdef __PAGETABLE_PMD_FOLDED
>>> 	return *pmdp;
>>> #else
>>> 	return READ_ONCE(*pmdp);
>>> #endif
>>> }
>>
>> Yes. But I'm not convinced it's correct.
>>
>> I *think* (but please correct me if I'm wrong) if the PMD is folded, the PUD and
>> P4D must also be folded, and you effectively have a 2 level pgtable consisting
>> of the PGD table and the PTE table. p4dp_get(), pudp_get() and pmdp_get() are
>> all effectively duplicating the load of the pgd entry? So assuming pgdp_get()
>> was already called and used READ_ONCE(), you might hope the compiler will just
>> drop the other loads and just use the value returned by READ_ONCE(). But I doubt
>> there is any guarantee of that and you might be in a situation where pgdp_get()
>> never even got called (perhaps you already have the pmd pointer).
> 
> I think you can't assume pgdp_get() was already called, because some
> parts of code will directly descend to PMD level using pmd_off() or
> pmd_off_k()
> 
> static inline pmd_t *pmd_off(struct mm_struct *mm, unsigned long va)
> {
> 	return pmd_offset(pud_offset(p4d_offset(pgd_offset(mm, va), va), va), va);
> }
> 
> static inline pmd_t *pmd_off_k(unsigned long va)
> {
> 	return pmd_offset(pud_offset(p4d_offset(pgd_offset_k(va), va), va), va);
> }

I'll note that these (nesty) helpers only work when you know that you 
have folded page tables.

And that's why I am arguing that the pmdp_get() must actually be kept as is.

-- 
Cheers

David

