Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 123E5D11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 08:26:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4331B6B0005; Thu, 27 Nov 2025 03:26:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E4746B000D; Thu, 27 Nov 2025 03:26:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D2D66B0010; Thu, 27 Nov 2025 03:26:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 187E96B0005
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 03:26:49 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9377C14097E
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 08:26:48 +0000 (UTC)
X-FDA: 84155706096.09.B657DD0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id BBB274000F
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 08:26:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WcmFwl3B;
	spf=pass (imf17.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764232006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6a4TlV6aY36ltVUhIhukCUkbYrk9qvlQSVSRFBITCa0=;
	b=JDpifVj76hLkoZKcxWKKqc/7wJwH8IAYyvTeDCrjhWh0opUCpJQ8t5OFXGl0aOSa1ktBwG
	b+eH/PZtOJJCwuUSfTyn33qW5WWiGGeyRcSfAluRVYngxzbPvNoyWkZLP7troxwIEYa+Fz
	VFk+gLxxmlf3U/psfzBFvqq9ohArDXQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764232006; a=rsa-sha256;
	cv=none;
	b=oiAc+RmZ84Ja1Rd6nrdeC1bhgQCAnTgjwXTSMhV6vnfAsRmiQr5GbnFOTboxRZAmD5cGmZ
	6Hkyx9iIn0bETXHnMjmyJ3L9j9B/OH9Jd2l1eGlfn8/6Lpl1tQfpmUnQbOYWmHbs24dw0P
	qtrPl9AV5NOqAPPtl+AOLwvjIeogm8Y=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WcmFwl3B;
	spf=pass (imf17.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 86C9E423E4;
	Thu, 27 Nov 2025 08:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336B6C4CEF8;
	Thu, 27 Nov 2025 08:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764232005;
	bh=bcPfE1QJFfuPJbcIojv7Nn8Gaq58C6i7WGhcnOmsWd4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WcmFwl3BFSTa59/qQB3P8sjeCiQkh28Bx5X8iBQfaUe9YSkO9nM6cU7737TjnKOAp
	 JJkTOlBk92QSIZ2v8m6Y6XbVK9HWVET1oCn6iBF1FjQogwNkbb80I07YujudKOOV/w
	 jrIBVQvi9EmOYcwjbuxYPeKj4FIh8G+4H+CR5PI3EtQcfNOF6BBZM98kJDPYxtAGma
	 9DJFGkFyQVPcFXE1Z/hTrfVM345+WrNeKTmw1VLoc3DWXOvGUwLitd1sX0X02raP8b
	 M5NVBmYkjvj75YhwFp8eFNQl9M+E9BJCXFBZubd8BB0leNXs9KcXf5d4SR52xj4DCC
	 +M1Pg28PbX3VQ==
Message-ID: <a33b87ab-b24f-45d5-bd4a-646988b54a2b@kernel.org>
Date: Thu, 27 Nov 2025 09:26:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/22] mm: Always use page table accessor functions
To: Ryan Roberts <ryan.roberts@arm.com>, Wei Yang <richard.weiyang@gmail.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Content-Language: fr-FR
In-Reply-To: <ee5f5da3-8c6b-4381-aee8-b0fab56cbf83@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: BBB274000F
X-Stat-Signature: f64m7w5t9ufrdmjzep1dzcok95ipai34
X-HE-Tag: 1764232006-281143
X-HE-Meta: U2FsdGVkX1/qNCgAalY0jmyWISeg/OfFjqvncy0QYoyETzyAWI6cWny1wzRFxJ6jt8sjBfQJ9OqDADcZvjcbqrPwZvjiz83vnUMPFIAft5iP+8HjmdYFkRK4sMyBwpV3KD16dj7LGsQSGFMbLKDrTCGb0z7cTFzjOoEUAMS4ewpOWfB6TLV42dtdrbniVxJ5LLrMoipPCsjaGAEBlCSpcXsSJezi8ApNPuyi8KEgXES/VDQWzl83MXHUt4Vvubvo04mk6z69ws+REjDGML3dmwXNjy9zr6qSjleby3gAATfhXWlV/fWyZaXFq4EpNdMJ3CkSNgtiMS8h9IzqEDly40GwnVFmdW17Pz73j8AAyVaYSbKd/g7zPeRixp5h0hT61CUwRiIrEPeUl/38ZpmP3jdsX75CbunKiBfZSp7IRc+/ljTjj0fmXI/RkwwMHLmaS7fK5a26Qli5vbe1k8Yrj7xsq3yIc699pONYGIm2DZklJ9Xo66s979JIhdmJBPzLQXJm14fVySX55mhqYC48qKSNWkKdbkkMo3PhFZpPqBVQnOTroul+KZMj8eIhDVNt6Gfa+iifFqpz7dW4rrEzFM7rCdHWsRInRwf+U5dr0dAF17Wd6GomHWiSFzR3NYNoO2YxFqJ//dlbRUzDYZC6AgnwGc/+7ZrlW6Xbu0BzlJ0hiJvfLFX4GG7AgkwGW99ecl3tVE8W7qzY2xp/DEPiHCIHrqPw2jxlQq95sqG8khs+W0nOTZq73ConZ0xgYC6wElpRPyKgGZp4x/cz1bhT01nOjEVCBfPMn/VM/6EQR7BvRHe8M1C+LPE3QaLhrock/6SNdqu0qYm9sx/StrkidvPyv81Epft3aLBBkvjlUs0xc0JcMIhK//CEiMlWvtlBROUfI48xWg0ztXcjFFprLf8AJDkHEzKiur/p/BxF/arkS2VgFbeArNSAWC5oIoGStQaRYcpePYKmcFuNyri
 3gTFteK1
 fc28Hc/12x21upT3bSEPiIhprjEwHbWROzJhuVh7JtiVqkYKZZkOQuFLRYRvMElX8pe/luKC+r77uESDGulKepZyJByiKiMLcFZBqU0xDo2YSVC4W+U9N+/TkI7MuudH3j1K6wyh1/B/Sf7AmM3ix8pcMjRmdx0QiEUa9p1uiGPIRRJgQex9Cv5yvppdPJnhkeroJzKmEQ/C5aQJf7h7MlGMkd6S6ZBTplEWQptR6V899OpcFenTBg/yv+UC6IFXzq/GEvRh7KV4pGFscFdOMi+kqTYz12vYZzfMcHM41clcgLZ40fhauVBfewiYJIHQVFKrU6S2Gj92jiYAypqH6oxkvBMpjov+XpGa14/jgA8oOwx8ZgoBXOSscOWK4syN62fxS3/1c29U4waC6ivIrjsBudbvy9WyZn1en4xmDWUwdcxEUcIcOXkhkrVRf3C9BhV8c+OFTP8AYzgm6G+a7sknY48dt1kuXV1EGrExVXYuf1Iw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 26/11/2025 à 15:22, Ryan Roberts a écrit :
> On 26/11/2025 13:47, Wei Yang wrote:
>> On Wed, Nov 26, 2025 at 01:03:42PM +0000, Ryan Roberts wrote:
>>> On 26/11/2025 12:35, David Hildenbrand (Red Hat) wrote:
>> [...]
>>>>>>>> Hi,
>>>>>>>>
>>>>>>>> I've just come across this patch and wanted to mention that we could also
>>>>>>>> benefit from this improved absraction for some features we are looking at for
>>>>>>>> arm64. As you mention, Anshuman had a go but hit some roadblocks.
>>>>>>>>
>>>>>>>> The main issue is that the compiler was unable to optimize away the
>>>>>>>> READ_ONCE()s
>>>>>>>> for the case where certain levels of the pgtable are folded. But it can
>>>>>>>> optimize
>>>>>>>> the plain C dereferences. There were complaints the the generated code for arm
>>>>>>>> (32) and powerpc was significantly impacted due to having many more
>>>>>>>> (redundant)
>>>>>>>> loads.
>>>>>>>>
>>>>>>>
>>>>>>> We do have mm_pmd_folded()/p4d_folded() etc, could that help to sort
>>>>>>> this out internally?
>>>>>>>
>>>>>>
>>>>>> Just stumbled over the reply from Christope:
>>>>>>
>>>>>> https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flkml.kernel.org%2Fr%2F0019d675-ce3d-4a5c-89ed-f126c45145c9%40kernel.org&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7C22d0a028b1ec4a8b678108de2cf73769%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C638997637481119954%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=ocR6usVgRHfue0MrtbQnDO8whINvy%2FDMAfNE3caiY8c%3D&reserved=0
>>>>>>
>>>>>> And wonder if we could handle that somehow directly in the pgdp_get() etc.
>>>
>>> I certainly don't like the suggestion of doing the is_folded() test outside the
>>> helper, but if we can push that logic down into pXdp_get() that would be pretty
>>> neat. Anshuman and I did briefly play with the idea of doing a C dereference if
>>> the level is folded and a READ_ONCE() otherwise, all inside each pXdp_get()
>>> helper. Although we never proved it to be correct. I struggle with the model for
>>> folding. Do you want to optimize out all-but-the-highest level's access or
>>> all-but-the-lowest level's access? Makes my head hurt...
>>>
>>>
>>
>> You mean sth like:
>>
>> static inline pmd_t pmdp_get(pmd_t *pmdp)
>> {
>> #ifdef __PAGETABLE_PMD_FOLDED
>> 	return *pmdp;
>> #else
>> 	return READ_ONCE(*pmdp);
>> #endif
>> }
> 
> Yes. But I'm not convinced it's correct.
> 
> I *think* (but please correct me if I'm wrong) if the PMD is folded, the PUD and
> P4D must also be folded, and you effectively have a 2 level pgtable consisting
> of the PGD table and the PTE table. p4dp_get(), pudp_get() and pmdp_get() are
> all effectively duplicating the load of the pgd entry? So assuming pgdp_get()
> was already called and used READ_ONCE(), you might hope the compiler will just
> drop the other loads and just use the value returned by READ_ONCE(). But I doubt
> there is any guarantee of that and you might be in a situation where pgdp_get()
> never even got called (perhaps you already have the pmd pointer).

I think you can't assume pgdp_get() was already called, because some 
parts of code will directly descend to PMD level using pmd_off() or 
pmd_off_k()

static inline pmd_t *pmd_off(struct mm_struct *mm, unsigned long va)
{
	return pmd_offset(pud_offset(p4d_offset(pgd_offset(mm, va), va), va), va);
}

static inline pmd_t *pmd_off_k(unsigned long va)
{
	return pmd_offset(pud_offset(p4d_offset(pgd_offset_k(va), va), va), va);
}


Christophe

