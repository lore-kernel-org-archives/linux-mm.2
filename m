Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7238C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 13:47:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 812566B00DA; Tue,  4 Aug 2026 09:47:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EA826B00DC; Tue,  4 Aug 2026 09:47:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72B336B00DD; Tue,  4 Aug 2026 09:47:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 521966B00DA
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 09:47:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0DD731A0170
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:09:27 +0000 (UTC)
X-FDA: 85063618374.04.2DFCA57
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5B19818000E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:09:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ui7t6UYn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785848965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4f7ucuIUW8vF4hICwF+LuP1Ke4k5i/LOY8wkqoppgQU=;
	b=vtpVGGd5xIHEAP3PwCJq5keymW8bAdmJlCU4JvCr9aPBh7110AKmdBo9HgrQkdmciDdiYU
	DJndBBy+vKgFrEyiE5mT5EDTFKa8us+5lsYhHhr6V5F7nkg4yMcfzwyiY/nCA7yJaVBjeL
	erSM/g6hCJt+izfBV0S4cVyTLT/OlKo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ui7t6UYn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785848965;
	b=cSj0JqKT0lhpW1fHK7PFZSdqzBi7/XkpVIUN32icelYCMyktFhgwU+aoWqYF4B+IiZuCAd
	hxvAnF+eNP95UhBPN6CjEumxcyN6csYeqw/KfriRDlX3c0N0kDavvZcfQ3mFwh12m2VZBF
	SxkJZVfylGhEel+dFQh/oIbkPPMZdUk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C209E60A59;
	Tue,  4 Aug 2026 13:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61BCF1F000E9;
	Tue,  4 Aug 2026 13:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785848964;
	bh=4f7ucuIUW8vF4hICwF+LuP1Ke4k5i/LOY8wkqoppgQU=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=Ui7t6UYnjDGA7jUXdMOZJ6Axzrun5isfzKVm2Uxl2vfraDeFP2914FnkkgGhu02mt
	 voOMjZW+YQ46kAl40nY5yZAVMVTwc2qmAKmCz9LQhk5ulRqhzZ/m3BmyZQAM9NVgx8
	 FwOD9Y8T/fvcC5vlvAad/UEgX4uXdJMGHYQlatXXVZVZd+jSgiNaUDo3eXIDHUpHPb
	 H9f3aviudsPqRTHHXbL4Vk5hI08JKwkf42AE7BMOT0rqjFGPcbbnzBwf1XrdOxPL93
	 HRXzP9YkSZKmWwWsTd+SDFdFB4YbPaM8pEuJ0zHw4olpd2r+ILT02xSPpdClMWKtk7
	 45CLGnbTDgBTw==
Message-ID: <6bd4f498-6699-4d54-a43a-57c954bff958@kernel.org>
Date: Tue, 4 Aug 2026 15:09:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Subject: Re: [PATCH v2 3/6] mm/powerpc/8xx: constify ptep_get() argument
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kevin Brodsky <kevin.brodsky@arm.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
References: <20260803164400.531199-1-pfalcato@suse.de>
 <20260803164400.531199-4-pfalcato@suse.de> <anHI4B-lMu6AJJfA@lucifer>
 <dcdb8cab-c18c-4995-ad1d-2f2d4700e7c1@kernel.org> <anHgw2Z-d-OQk9qs@lucifer>
Content-Language: fr-FR
In-Reply-To: <anHgw2Z-d-OQk9qs@lucifer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8a8ad87bixc9td5hat45zie93zrwr9ep
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5B19818000E
X-Rspam-User: 
X-HE-Tag: 1785848965-857781
X-HE-Meta: U2FsdGVkX1+5px5hoWt6PoMD6YlytZvBh/r/kxYX9e6uAGAnyq1NYR0HfmjWknlz2gqYJmGTW3MK0YvZ4wlP4mKV7ir4KXGGYFfNlettufll1jVVk9CcZ7PuOITfcUqJfcqX4oi8fqIaj9RrpTJHtnp+O3qz2A6U7fQtsaoKPXEU0oIj23ewET1EVAf68tzgkTHCk1QLgruveDSJLKCPHvl4qrbzi5f+3A5fdXx4umq4u2pbXZMZtKKX5xM0L+7nhE0xzaxpn4QLSjeyZh2GobO6XlyrS57rHqRSqc/KMHNk3/ZrK7RaiXmKPsFFrZaau0HHi4h96ORL0JInNBM8z+oatIh2ZoByBvp7CXZmsIHbS/bERpFyPdMQweE+WurCzjDtHYGiTI1RyZyDd7W6kWd2Bg90GYSt05wrOHKgj/lliHZdmrp8PXEtrPLdAgVxo+8GyalC5Z5K0Jj+Ie1llMStvyC/6ixN9sPINmofxGIUXSu5tlntsG18XoRtGPMgqfC2gmSLoMCo6lLO8IjRmayC2CjOptdkXGRG1Ilb0s6v2TqkCHV0MnHZ0IMeBhXCluA3TS6weN/jJfnvbbcFjfLvDm9su8SdI5mJemh02Zm3aw9bx3Dc+4phGHFiO7BgQGA0tNIeAPxYYfAuIRqdSWTmnjHAxY/XYySYhzzozWGJbr9ExkBh0QK+/iPkbBIn/LFAWFEgHwd2Na5i7Mpqun68VVcogTuvf8CzGMJCX8Pw1U0xVuf8L98WNsYNyzaRakk/z0LVorx49TBeWFuU4chkvYoAtvDz/QPhjB7OtBkziyRSCq/eeNGszGU74B79sjSXnRaljmf0jZ54b29k0UEnZbV/9XQ8Vaa4dIpqg4zGyHhtO18wFA5Nf0olrWo40HOvEd2KE7AqTi7pnIAgm80sCJwWf4qI/+GQVgcHS37F1qlwa9iihKcnzjAepvzGs8Jj4GTMF1wYqbwpNe/
 mERflapX
 8WMZv397AdYGdks9SMzAWH+uYqSdnj0480RIPeW7S+Rw427d+meYTZpOWy1JA1GOzgWYF4ddm26mxFiKcw9rTfKhRc6+JDmvCW2TWvLPqI9BfNt4D/aXHKQisVk7VAxf5UBAdLFh+hpvsxZlgwr+Gd+/GkpIPgw+OJBzFYW9m4WZlWTOjyUFHeQnt5uzgb7uUKyJC6EaQHmBiOwi21Y96tM+UpUFFfY4yJWp8ZyfS1wMC0wk9+/XLwL3BiNqFkISMhVY1k1KUB20muHrjFhvQwlNCfjwbJzzcjz/S7/uXF/76GoKQ8gOaSIpQPnpSIdoR11VWxtYFWPWyk53uiKe4RZjyzVOUnh0i2zTASV10qvxdWXUwSJtltpLvNmpAkVhPduJg1DHsqWAybLeu1rcF+wYJKmZzPE4ovjr4onuNFGgLjBc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 04/08/2026 à 14:59, Lorenzo Stoakes (ARM) a écrit :
> On Tue, Aug 04, 2026 at 02:50:19PM +0200, Christophe Leroy (CS GROUP) wrote:
>> Hi Lorenzo,
>>
>> Le 04/08/2026 à 13:13, Lorenzo Stoakes (ARM) a écrit :
>>> On Mon, Aug 03, 2026 at 05:43:57PM +0100, Pedro Falcato wrote:
>>>> There is no need for write access to the PTE.
>>>>
>>>> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
>>>
>>> With below addressed LGTM so:
>>>
>>> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>>>
>>>> ---
>>>>    arch/powerpc/include/asm/nohash/32/pte-8xx.h | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/powerpc/include/asm/nohash/32/pte-8xx.h b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
>>>> index e2ea8ba9f8ca..f2bab31040c7 100644
>>>> --- a/arch/powerpc/include/asm/nohash/32/pte-8xx.h
>>>> +++ b/arch/powerpc/include/asm/nohash/32/pte-8xx.h
>>>> @@ -226,7 +226,7 @@ static inline pte_basic_t pte_update(struct mm_struct *mm, unsigned long addr, p
>>>>
>>>>    #ifdef CONFIG_PPC_16K_PAGES
>>>>    #define ptep_get ptep_get
>>>> -static inline pte_t ptep_get(pte_t *ptep)
>>>> +static inline pte_t ptep_get(const pte_t *ptep)
>>>>    {
>>>>    	pte_basic_t val = READ_ONCE(ptep->pte);
>>>>    	pte_t pte = {val, val, val, val};
>>>
>>> Worth making these const too (that {val, val, val, val} horrifies me btw :)?
>>
>> Any suggestion welcome.
> 
> I'm being super nitty, all I mean is:
> 
> -   	pte_basic_t val = READ_ONCE(ptep->pte);
> -  	pte_t pte = {val, val, val, val};
> +   	const pte_basic_t val = READ_ONCE(ptep->pte);
> +  	const pte_t pte = {val, val, val, val};
> 
> :)

I'm fine with that, I was reacting on the "horrifying".

> 
>>
>> powerpc 8xx page table is independant on page size. When you use 16k pages,
>> depending on the address you hit the page for the first time, the HW assist
>> page table walk will fetch one of four 4k cells in page table that need to
>> be identical as they all four define the same 16k page. Not sure I'm clear.
> 
> No that's clear, thanks!
> 
> (I say 'horrifying' because I am looking into RCU page table freeing which this
> may complicate, though perhaps not in practice, to be continued :)

A few more details here if needed: 55c8fc3f4930 ("powerpc/8xx: 
reintroduce 16K pages with HW assistance")

Christophe


