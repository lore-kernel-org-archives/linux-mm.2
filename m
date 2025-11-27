Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41253D111A8
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 19:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 859786B0010; Thu, 27 Nov 2025 14:44:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 831186B008C; Thu, 27 Nov 2025 14:44:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76E596B0095; Thu, 27 Nov 2025 14:44:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67FCC6B0010
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:44:28 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 17460139BD0
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 19:44:28 +0000 (UTC)
X-FDA: 84157413816.20.2B6BB86
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 74C11A0005
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 19:44:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="DHhD/aQh";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764272666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GdDuTvTnfEpx4mgFT/vHpVsJR1D+SimXyQpYnhx4Jqs=;
	b=jpa9XtksiUzQTFcCmR6jni0hgZAutOUZmhJCecTFtVLpfxvl3DIJTAIoXgSzL6/Uhq/4wW
	EDAG0HH+DIbMcq5Brsv1OSv+KwUrEUAdm2X5maM1lbCAWDh12X7/bGUYloM+NKFrJZ1zdG
	55VW7SFIah1Ifj0WEm8hwSX6htd/9Q8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="DHhD/aQh";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764272666; a=rsa-sha256;
	cv=none;
	b=mlBoD3rzHAlbdGfYf5KGoeeiwQTnZ9KxznDnTjf9Uy5USAEDmYlOvDXHyUWx84YcIxmId0
	NmWsm3OWlN/EyFJoGoETAY33MlrUThhjKezPmC7gkzFrk5GsdchfowbUWJ0udPYKe//iR7
	WiPe18ojotdaUjpkrTYxJqa9kcb3lP0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E304E60172;
	Thu, 27 Nov 2025 19:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF0FC4CEF8;
	Thu, 27 Nov 2025 19:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764272665;
	bh=2FTP2tPXd1GWQFRneLLYDqFrpGOgQxqB103gyOVSA4k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DHhD/aQhOyARXtDI0hb53vOA6x8+UUybsf+r7ell6SNfujszItV4w+dfeFIi0VVvp
	 SfUh8H3uoek+9MTu+QV4uvODoSpGySXi0o6d5frjsPAj15Of1utMh7nsvJb974rQD6
	 F4niZwOZzwHFDuJtR/LiKuHlg7eHU7BRGLvv18H42Kw9FviKkVKPvJALmGQ/V+VhNO
	 Gdb9h5b6Acg/uJQzdygl3tGNU7KMzqs4YfOU3R9/nzYTx1T8Fo7IgVylHkbTf2yBLR
	 qH2rfGWT4eDqkPvd+NlC1Xr49i1FAUs47DzrgHd5fldJ4zKIhqGNc++3zPYYD4TB9K
	 fox1xbw6MnYrQ==
Message-ID: <f27429f3-9dd8-4006-b2d8-702436ade805@kernel.org>
Date: Thu, 27 Nov 2025 20:44:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/22] mm: Always use page table accessor functions
To: Ryan Roberts <ryan.roberts@arm.com>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
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
References: <bc88d132-452a-42a1-9ee5-5407334d8aac@kernel.org>
 <df7d10ba-bb42-4ea1-8c5b-5db88a18eccb@kernel.org>
 <6bdf2b89-7768-4b90-b5e7-ff174196ea7b@lucifer.local>
 <71123d7a-641b-41df-b959-88e6c2a3a441@kernel.org>
 <c0818f5b-b8a1-4730-aa1d-df0f547a3d47@arm.com>
 <20251126134726.yrya5xxayfcde3kl@master>
 <ee5f5da3-8c6b-4381-aee8-b0fab56cbf83@arm.com>
 <6b966403-91e0-4f06-86a9-a4f7780b9557@kernel.org>
 <ab39d448-aa1c-4c93-8e2b-5d97a9c76af5@lucifer.local>
 <1ca9f99f-6266-47ca-8c94-1a9b9aaa717f@kernel.org>
 <37973e21-e8f4-4603-b93d-4e0b1b2499fa@lucifer.local>
 <a1d25bde-3ab6-46b5-a957-db80da7e737b@kernel.org>
 <4505a93b-2bac-4ce1-8971-4c31f1ce1362@arm.com>
 <150ffcb7-2df2-4f3a-a12e-9807f13c6ab9@arm.com>
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Content-Language: fr-FR
In-Reply-To: <150ffcb7-2df2-4f3a-a12e-9807f13c6ab9@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 74C11A0005
X-Rspamd-Server: rspam11
X-Stat-Signature: f9bhdkrmsdnx948u867tczfj538gyk8o
X-HE-Tag: 1764272666-636715
X-HE-Meta: U2FsdGVkX19y8K/T+auuAlUkjS2VKZXoM0YAhLMa8NHDngWVpSR+0oD2kes4eynacfFnVBZddR/R4QXg9nP6QOR1YuYjy2T2LDEv8Dpbesf12lwGAXun5QV/2teP5U3PCfqqj7fAfGglS6y/ZkkNHbzKzQnu6GKLcQzcGMpSJxCIstjhlft5rlFFgyaMeJcw4ood/QJDJZRBZYtWy7hTloLPzXLaqeCzl0q3U6RzlUnZdbZ99cBS1/lYQVLHzfu5to5+/1ENNfakcoCKOGBT7861Nm3HboeRazDSykCVDYRy2/fpYaQTu11MhI2b7V1eBuwPP3gGl6rLqvb5uRWm81qoyzuPVlZux8EqdJ27MQaLYqqffIiwaa7ZciNYo12SGJuN6k1mfjAERySKbe8J/QPiqHQHtfxfdaPUYlM23z9vnE7zNYd2yXpa9k2TW5LOe/ZpLXIlZmy7RFaBL4Wnz80RAW1MDLrVHvFsJKhlWHJ+4/Ax1Qn0WRl5sG4pEue3F+W+LEdB+GOW/jQeUCARtSse/zvETqELkEs3Yk+izr2kzmdBiof75aQiLhH6iFiD6NbuPGyMO7W30jsnbIsIN7d1346CM9I9vIrARyP84YA5Atb7grF1EmJzdZ99eyqFzDrYEVfwxBTgyLuti7HR9OEd52Ht/lj5DekoX3WqBKvkCHfo7zvPuoOvlKmrIfXH2p9gRRJuK7GIAkpMb5eQoNRHf7acARNeK4fzCO6E28f3b0EPmW3YC7GoOc42kR1j8dpx9cE31AUIpSilJ6wxowNwL79BwitMCFBd0p7RxuUbj5cRD9MJukpu78yGBd/okB4s2v7/G9cPBklHFSjrnpIzatGYlUSqq9Ffw4FzmVkF9rP21flfZ4/9bv/Hfd9atHAQzX5DTzPV0MTgBFdnMUi8xmDse4Wezul4iRgncYOnyeD/nlojYON663gRXfYWaMy9tG5EfAy3dnAMtZd
 B0lpfV4g
 hHJWUsmsqvb4m8VOX3M9kmKJ5PzAcGuFjRLeVkN6vxhJDWW5uD1roPrM6a4mj+g18dJXfnSbJM8UORAPyS1SEvvXU+SX8Si+v5/1FA6WGWMwyJeFkHOo84Xr+y2QE+TcmNQOteA4U96oBO0nV4BuScCG4ZJidbA+qc3RwNncYlDJ9Cmni/DuzkHWZ12zt5LXtL1QRJcAHLLIJSg0o2u7rbYvxHhYUKC9jBv3jsc5WkRiWGrQQCQ4/IU5DDo/BG6VFANipbp/g6/7AUdja24hHiN2ZS3OEu2ub46epRCcG5tzS3LsMrCFuL60ZX1lwyjPiCRUR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 26/11/2025 à 17:34, Ryan Roberts a écrit :
> On 26/11/2025 16:07, Ryan Roberts wrote:
>> On 26/11/2025 15:12, David Hildenbrand (Red Hat) wrote:
>>> On 11/26/25 16:08, Lorenzo Stoakes wrote:
>>>> On Wed, Nov 26, 2025 at 03:56:13PM +0100, David Hildenbrand (Red Hat) wrote:
>>>>> On 11/26/25 15:52, Lorenzo Stoakes wrote:
>>>>>>
>>>>>> Would the pmdp_get() never get invoked then? Or otherwise wouldn't that end up
>>>>>> requiring a READ_ONCE() further up the stack?
>>>>>
>>>>> See my other reply, I think the pmdp_get() is required because all pud_*
>>>>> functions are just simple stubs.
>>>>
>>>> OK, thought you were saying we should push further down the stack? Or up
>>>> depending on how you view these things :P as in READ_ONCE at leaf?
>>>
>>> I think at leaf because I think the previous ones should essentially be only
>>> used by stubs.
>>>
>>> But I haven't fully digested how this is all working. Or supposed to work.
>>>
>>> I'm trying to chew through the arch/arm/include/asm/pgtable-2level.h example to
>>> see if I can make sense of it,
>>
>> I wonder if we can think about this slightly differently;
>>
>> READ_ONCE() has two important properties:
>>
>>   - It guarrantees that a load will be issued, *even if output is unused*
>>   - It guarrantees that the read will be single-copy-atomic (no tearing)
>>
>> I think for the existing places where READ_ONCE() is used for pagetable reads we
>> only care about:
>>
>>   - It guarrantees that a load will be issued, *if output is used*
>>   - It guarrantees that the read will be single-copy-atomic (no tearing)
>>
>> I think if we can weaken to the "if output is used" property, then the compiler
>> will optimize out all the unneccessary reads.
>>
>> AIUI, a C dereference provides neither of the guarrantees so that's no good.
>>
>> What about non-volatile asm? I'm told (thought need to verify) that for
>> non-volatile asm, the compiler will emit it if the output is used and remove it
>> otherwise. So if the asm contains the required single-copy-atomic, perhaps we
>> are in business?
>>
>> So we would need a new READ_SCA() macro that could default to READ_ONCE() (which
>> is stronger) and arches could opt in to providing a weaker asm version. Then the
>> default pXdp_get() could be READ_SCA(). And this should work for all cases.
>>
>> I think.
> 
> I'm not sure this works. It looks like the compiler is free to move non-volatile
> asm sections which might be problematic for places where we are currently using
> READ_ONCE() in lockless algorithms, (e.g. GUP?). We wouldn't want to end up with
> a stale value.

What about adding a memory clobber to the non-volatile asm ? Compiler 
shouldn't move the asm section in that case.

Christophe


