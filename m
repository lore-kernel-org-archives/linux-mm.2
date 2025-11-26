Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC7EDD10F5F
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 14:46:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05E616B0027; Wed, 26 Nov 2025 09:46:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 010476B0028; Wed, 26 Nov 2025 09:46:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3FC46B0029; Wed, 26 Nov 2025 09:46:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CF8DF6B0027
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:46:50 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7EFEE13B6A9
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:46:50 +0000 (UTC)
X-FDA: 84153034980.10.18AC565
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id ACBFF1C000C
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:46:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Knb6dB6K;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764168408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LLkwzHjXHyUMpIuJUHvgZU0gRIFR90IzknnUKd9E6iU=;
	b=ozVfhO6DL3xRDXhOYLhy9DY962KR36InpIV+0FZKjbtcOtZ0iBq79+OM6DYsAFerl/DTpm
	4k6wFWEW6a11VcOrjRoPd7xuajAkH82eFLuNcVoBqkRiRGMb9ISTPfqbw3OE6+Kzdkwuyo
	uNwxXxRIYVLNFmPVyLcsIfXWk28Vor8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Knb6dB6K;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764168408; a=rsa-sha256;
	cv=none;
	b=PddxiRKoeEWuTA8Ger/E7bnbfAjJr993ti5iGwOJVjiPY3RaKcgCzvFmf9F13HfhRt1eUK
	YesR4BqmGAxM3ES+z7laq84NpxgZgCcDXXYohAuyxZuLhLP96fEb8u/cDm4K7eAnFQVQmJ
	RGlooCFejXUlkmEKipVsem7ZoC0WRxs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A908F41A3B;
	Wed, 26 Nov 2025 14:46:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D951FC4CEF7;
	Wed, 26 Nov 2025 14:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764168407;
	bh=rN8uuyU8RJxsQK9SI2vsik5bVZRYdR4fDfMryS9LdTo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Knb6dB6KKmlnmfJpGMk6rLZZg/Xct6yBU+L1A5tJGCzb90ZgbFIwltq2rnJrqAlb7
	 1m5cTDHSno9KWGcw9J9xR1Vx6XYBkWdCJzainHhBbiuiOXeYZyf1CNuUDvRsEFpkVV
	 7IJu0+1HHJuTC+uWYmKLKfGHbKpiReXDB7NMDr5kMlBx9faWmr3mgZ6PD6RzEcGh6y
	 wtbFL4cEKyAzFnXjBZeg4brZpmGf/C3fwJost64KZLAqrMU0dQsh+XijAoVcsQU8Ij
	 3VZVb7gospy7DoVSKnuqOIyjQ0D9N3e2LKLO3PtlK7etI21gf96UYXggvB3TqwbADK
	 adsHLAl4WA45A==
Message-ID: <6b966403-91e0-4f06-86a9-a4f7780b9557@kernel.org>
Date: Wed, 26 Nov 2025 15:46:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/22] mm: Always use page table accessor functions
To: Ryan Roberts <ryan.roberts@arm.com>, Wei Yang <richard.weiyang@gmail.com>
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
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <ee5f5da3-8c6b-4381-aee8-b0fab56cbf83@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: ACBFF1C000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 9whcwbbszibbiahyx1oiz6yne4fzjs6y
X-HE-Tag: 1764168408-181922
X-HE-Meta: U2FsdGVkX18ZZ6bYN9RtYHIsdsufpUffPCFFjkoDwP37/GXntbDvpq7IHyVGb5RPY/w3Di9AEAHgP3Ae0t95dzHNHOu4gYLlZVdR2jkhSAxYJI6SNEWq59aFOfYAvATNqLB2+/EJGEOufvcNBbCEVVfpNc/VEj7BDXy0Re9HmvJCN/TVrCjReGnp5Zipd78gM50wVTgUxhtfC6X59M77CX4gxBHMJYANKv0H3t5BE/pSucTMK14GXe1ExMd0KVt++XkEQJDHoajTWv55XVZapjwnadSme6zMDlgTyBLGpo1AWN9JCC5rtE9sbHDi9K8rC+HXn8W78diG92an5O2/2cnK8itkEHFEY2h3O59NdUbobTAM80zOC5DpMhDcCbmslK2jfALSSPn4L3BO2xk25Avf3jVzkCibTsS3vZGsr1cn3ov0H+5cMGUD9APcVYXtmwZ3Xqgu5WAbYyd5KMKtTR17GTtw2+nMt41fWQpOte9QZEtkldYElrd93SUL3t2Gp9DuItdV7Dbtsmvg1/wKxn8dlPeSxNTGrGEY+6vtQ6DUdHB4x2a8UXZVnVw9YkeQayt7yGyPR4da4YGpDU6FU+HZrrtfzHZYkAnMp3bfzKgP561t8CMWv4yPKCCUq3I1JzxtD/QKfpiFz32B09s6RjMAGcGSj33UCvfuZyK4fCZ6IPp8zoJbqtzkN9Xivu5ddgPufexyeIzfnQNb72zfY2lBpiE3Dw/cMCUo+TxD7U4dKsxWHEv1oIstkVOwRcgnLDfYM8JLaLBEkanxFy7XtxYpIV5l6l09ZMFSTSALls2mUMwhxdmFDMev8KzQzlVH81U1sU0U3yiP8S7xIs8d3Z9viXr3DNAFQG3pS09cWgSgx5teTOmHdH89MqC9ux9m2FcgHslvaoE3NyzKmnobPYas1nj/qCzYX8ZF53JfwPf0KM1l9IJ8Nh3c73/x5supaP5whNPBPGfC4T2ysmK
 QYD9hCjM
 RhK7RqA06j8iaf77eVyXMqmgAkkrMvdoxsJP07I4h2MEbWvP2JT9YxhPgxwc9G6F8X5hO1EFj/MiqCSSPdHvwpyk4TxUbK0d4O+/HO1MAPLCB+1Mr2PX8oxElzO2yTmbVij87mjw0i85w6UwXwOpIy7UDOkjfjkNeb4hUSiifSO9y6Ub6K0ZWPjs2iVYdhyRPbnBp85WwZKd9Yx/ur9eJrKKaGPNlF3JZEenYX0pAul4gGjUqB2exLQIgygDeCqBPELLWFldqXG5GpWoc8BoIHjJlK2+6ROm/E7NZZqZxdbBJxxofT8pbAfHv9XCGlN01+SIJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/26/25 15:22, Ryan Roberts wrote:
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
>>>>>> https://lkml.kernel.org/r/0019d675-ce3d-4a5c-89ed-f126c45145c9@kernel.org
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

Yeah, I'm also still trying to understand how it could work.

> 
> I *think* (but please correct me if I'm wrong) if the PMD is folded, the PUD and
> P4D must also be folded, and you effectively have a 2 level pgtable consisting
> of the PGD table and the PTE table. p4dp_get(), pudp_get() and pmdp_get() are
> all effectively duplicating the load of the pgd entry? So assuming pgdp_get()
> was already called and used READ_ONCE(), you might hope the compiler will just
> drop the other loads and just use the value returned by READ_ONCE(). But I doubt
> there is any guarantee of that and you might be in a situation where pgdp_get()
> never even got called (perhaps you already have the pmd pointer).
With __PAGETABLE_PMD_FOLDED we treat the PUD to be fake-present, like

static inline int pud_present(pud_t pud)	{ return 1; }

And obtaining the pmd_t* is essentially  cast of the pud_t*

static inline pmd_t * pmd_offset(pud_t * pud, unsigned long address)
{
	return (pmd_t *)pud;
}

So in that case we might want to have the READ_ONCE() remove from the 
pudp_get(), not the pmdp_get()?

IOW, push the READ_ONCE() down to the lowest level so the previous ones 
(that will get essentially ignore?) will get folded into the last 
READ_ONCE()?

But my head still hurts and I am focusing on something else concurrently :)

-- 
Cheers

David

