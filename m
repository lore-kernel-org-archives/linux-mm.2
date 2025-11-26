Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEAD3D10F58
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 14:22:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCEAF6B0012; Wed, 26 Nov 2025 09:22:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA5E06B0023; Wed, 26 Nov 2025 09:22:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBB9E6B0024; Wed, 26 Nov 2025 09:22:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB1BE6B0012
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 09:22:21 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 603141313CA
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:22:21 +0000 (UTC)
X-FDA: 84152973282.04.957FE2B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1A5BEA0019
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 14:22:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764166939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YPSgYzLRryeEBBLSc3CiLOyFHla0A07eKXJgeADDYuM=;
	b=gNNVUayQBLlvI5NDb1E+4r2MnoO/a2jXh/ivmdpDIPMFySSf1k6yV7Gd8d6xMgdeCw0uGO
	4rC+ykvil0RUgGlVn8NXFX8we588gcJZ1kaqw5RZEwsmyItnDYJp/yiaokAvyqkTxZ7Uza
	VUSFEAr/x9o2sTX7e3CZ4mmmUcecztE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764166939; a=rsa-sha256;
	cv=none;
	b=2KyYkmhMK2OBtvnEwTVzA5n2CRye1h6wanfUE2XnABHyWQtw+AgZ581byCol2vfe9hBC2+
	boIoubJbg016jPszc+AQSdiy9G94Y+qJVQxKLnqeTx/BM3KiEBR//1FqtZpUW9pPmJQL/r
	i/lcAvyOtbrcFjAXHZYEi9NYWNGWG9g=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 51E64168F;
	Wed, 26 Nov 2025 06:22:10 -0800 (PST)
Received: from [10.1.33.153] (unknown [10.1.33.153])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EFFEE3F73B;
	Wed, 26 Nov 2025 06:22:14 -0800 (PST)
Message-ID: <ee5f5da3-8c6b-4381-aee8-b0fab56cbf83@arm.com>
Date: Wed, 26 Nov 2025 14:22:13 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/22] mm: Always use page table accessor functions
Content-Language: en-GB
To: Wei Yang <richard.weiyang@gmail.com>
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
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20251126134726.yrya5xxayfcde3kl@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1A5BEA0019
X-Stat-Signature: 6bfp3pzjzs1x14hihtfeytjar4cutm46
X-Rspam-User: 
X-HE-Tag: 1764166938-126160
X-HE-Meta: U2FsdGVkX190UwYjxry+edmj5Gosq6dJ+K8ruE4JV4IINKBdoraUIiy/+d/GvuYCIFaAAXhKIKeSVmovux46OvYvx0wkojWe+711mXNS160e3cfC5E5qdJF7UIZ6PP695bzv+kvpRTgOVamESat6agEzXJ9De0qZGYAPo05swuUhwZWcAEF9uf/Kz8jwi4Tff1dWuYtWMt0lIgG3ROzcdt8ZL/b16iqZk89jRdpfsoHrYhVErPawV1cH6hPlUOx7yV2rKX4tKYC7xYUykOgXeyTghfmDdKuq2gye6rT7CSVRSmfRBOC/SlEEvNTUZ4Qz5SA7PE+EcssrgWgM+stC7tHNNw3r9WXbQ/2Z4TxH1pKsZcMPYiD2vQqPKvafA9auS/FO+BYsrO9aqgNK8HivdFBM3Q859+AUxyQjGhNd+GLn0woGRQP35qwYyLIR/y8Ipm9GdRMdavYzD7Ye+H3Vjuaew1sBAfe7j0aY/wH71pJ2I8E7RuBr7MqtUQgKBHydVOFOMfPwJnaWhKL3hgyEY87emCHaIl/Q4vzERIIiwhDyVpxPq3c2kr2Vp+/Kx+fA+rXCCrqUil9fjv9BRiZbIIWntghNpHipFfEmOFVM96siabcFag3gk0qyKaNy9amNaUsxs1YKAqrSrS7TfwLztr7YJEk+r2z6EQJ+Dxn9mEwts9ga+LrhZB5cnFlt9ZFuZE0GI5zOBtEWOcEoaaPUzUf6N6Y7i6yzjsdlStT8OFOZpYzKWDM3IklVCDFl01poIhPl/qScYPeBHrgVu93cV4rEwlsiaColpe17aYWT07V1qoX9uQVdG5m3ozvIXMdXsuNcH2QO5LpjGk6tejO9xNWB3uiuzCJ5/VZiuNHqXNMuifOMdbhOLam5Ke+1a4DtL2n2np2iW+VnhFECUvZpAjhFZABQYQUot62EeoUazftceSVkedRg/FHF5ansoGm03etPFNXPuYrqBl9C3Fs
 b2ZIKYgH
 lQJI/ufCDSAfH6r+sX2nfwnd+inzTKVpxUfdVSowI6CoIio1WwHlFK1GOOif/R1PgphpqAdEzwNp3l1RPWGCOh2JdcptG7a1li2E4zAi045j2C3GLAke8CiqGWThPfO2ds1VigrLtBFmDAGNYO5UN1QbRxkcnet7SXFZTX1JpelvbNGa5sSVn8Up8ItjWJlcWBw/9/suX541kTMCgsCdxOZNe8aWK3715i+yOT8Dh/LqBRoYl274r9zVmsg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/11/2025 13:47, Wei Yang wrote:
> On Wed, Nov 26, 2025 at 01:03:42PM +0000, Ryan Roberts wrote:
>> On 26/11/2025 12:35, David Hildenbrand (Red Hat) wrote:
> [...]
>>>>>>> Hi,
>>>>>>>
>>>>>>> I've just come across this patch and wanted to mention that we could also
>>>>>>> benefit from this improved absraction for some features we are looking at for
>>>>>>> arm64. As you mention, Anshuman had a go but hit some roadblocks.
>>>>>>>
>>>>>>> The main issue is that the compiler was unable to optimize away the
>>>>>>> READ_ONCE()s
>>>>>>> for the case where certain levels of the pgtable are folded. But it can
>>>>>>> optimize
>>>>>>> the plain C dereferences. There were complaints the the generated code for arm
>>>>>>> (32) and powerpc was significantly impacted due to having many more
>>>>>>> (redundant)
>>>>>>> loads.
>>>>>>>
>>>>>>
>>>>>> We do have mm_pmd_folded()/p4d_folded() etc, could that help to sort
>>>>>> this out internally?
>>>>>>
>>>>>
>>>>> Just stumbled over the reply from Christope:
>>>>>
>>>>> https://lkml.kernel.org/r/0019d675-ce3d-4a5c-89ed-f126c45145c9@kernel.org
>>>>>
>>>>> And wonder if we could handle that somehow directly in the pgdp_get() etc.
>>
>> I certainly don't like the suggestion of doing the is_folded() test outside the
>> helper, but if we can push that logic down into pXdp_get() that would be pretty
>> neat. Anshuman and I did briefly play with the idea of doing a C dereference if
>> the level is folded and a READ_ONCE() otherwise, all inside each pXdp_get()
>> helper. Although we never proved it to be correct. I struggle with the model for
>> folding. Do you want to optimize out all-but-the-highest level's access or
>> all-but-the-lowest level's access? Makes my head hurt...
>>
>>
> 
> You mean sth like:
> 
> static inline pmd_t pmdp_get(pmd_t *pmdp)
> {
> #ifdef __PAGETABLE_PMD_FOLDED
> 	return *pmdp;
> #else
> 	return READ_ONCE(*pmdp);
> #endif
> }

Yes. But I'm not convinced it's correct.

I *think* (but please correct me if I'm wrong) if the PMD is folded, the PUD and
P4D must also be folded, and you effectively have a 2 level pgtable consisting
of the PGD table and the PTE table. p4dp_get(), pudp_get() and pmdp_get() are
all effectively duplicating the load of the pgd entry? So assuming pgdp_get()
was already called and used READ_ONCE(), you might hope the compiler will just
drop the other loads and just use the value returned by READ_ONCE(). But I doubt
there is any guarantee of that and you might be in a situation where pgdp_get()
never even got called (perhaps you already have the pmd pointer).

So I don't think it works.

Probably we either have to live with the extra loads or have 2 types of helper.

> 
>>>>
>>>> I find that kind of gross to be honest. Isn't the whole point of folding that we
>>>> don't have to think about it...
>>
>> Agreed, but if we can put it inside the default helper implementation, that
>> solves it, I think? An arch has to be careful if they are overriding the
>> defaults, but it's still well contained.
>>
>>>
>>> If we could adjust generic pgdp_get() and friends to not do a READ_ONCE() once
>>> folded we might not have to think about that in the callers.
>>>
>>> Just an idea, though, not sure if that would fly the way I envision it.
>>
>>
> 


