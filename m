Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E365D116F3
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 07:32:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6E216B000C; Thu, 27 Nov 2025 02:32:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1F826B000D; Thu, 27 Nov 2025 02:32:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0D426B000E; Thu, 27 Nov 2025 02:32:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC5C46B000C
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 02:32:03 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5504013BE2C
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 07:32:03 +0000 (UTC)
X-FDA: 84155568126.03.A570745
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id A21BC4000A
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 07:32:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ouf03M9U;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764228721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=96PUTPbKyX29XZ59hC1MBICUgATxkKZMiQ3+C7YSdUg=;
	b=WveHJbF/pnL8xpRj7TNTdVD2Gv/2fW0wkdwV5itpY5k+l2KV9U5L2WOLEfmcgozsIZRo0e
	qQMTDLHwfS6/T5xAIFXUgBrhEFWxzOvWPWE+uK7BG/s9mU45Ljjefvo1/819NkUnEWwEa9
	yzXjizSkaEAyC3jZLe2k1W4LujT2AiQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764228721; a=rsa-sha256;
	cv=none;
	b=1HGiBpClNj4yppIu8DoJxgtO88j7KworIlAKvf1f906pSkZefiHnci715+YfR41u3ztvfm
	qJF5l0aNMZIUMRe1393Vmfe5Z3MUADxwZu2I0gn0q7DdQJ0WskHInPst+fRYgwSFEC6M1R
	Y2j2mmfkZStk6Lfvywzxn0ImP13CU9U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ouf03M9U;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0CE9D60182;
	Thu, 27 Nov 2025 07:32:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0188FC4CEF8;
	Thu, 27 Nov 2025 07:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764228720;
	bh=QiLZ0ytg5DNB713odlGgPihhex3UHwBxH/QBLHPI5QM=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=ouf03M9UhTmrdYrBI9Rg68Ds2egIB5Eo2fkqNFaJj60mj+MZ1UpDU3dqMC5CDr4GZ
	 1e1gbHEEAg3GZX9zxrxJ5KqhDXcOhmLhpY7NEziDAEgzhE6YlqPGeBk8RiSPxSlsSa
	 F2AmTGyncDeM6RFOOttkf+LPPLRiELWkkHwOnudis6yd88kSiYYjwzNFzwrzcMcnE3
	 2SmtBdNPsXtGJnXzp0X2chXdyd/01FFiIsag/c9gEZZXoXmJrfLd03SpdDW+HPf69H
	 RoxGo8DTISAtMr5xSaJ2uJoznD6XMpaOBMkLlXyYlE7Obw1135MsaqTVAdJ2n+N2BU
	 TxSMaHEWH6ASA==
Message-ID: <bd4d746b-8929-4fd2-bd59-70654e794ee6@kernel.org>
Date: Thu, 27 Nov 2025 08:31:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/22] mm: Always use page table accessor functions
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: Ryan Roberts <ryan.roberts@arm.com>,
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
 <b2fbe58e-f47b-4a76-879b-fd38a915c2ce@kernel.org>
 <bcd2a49d-a42f-41e8-9f64-4fd24fc862c7@kernel.org>
Content-Language: en-US
In-Reply-To: <bcd2a49d-a42f-41e8-9f64-4fd24fc862c7@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: n1nbdgodckomt4fu4bj8mha118d143fu
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A21BC4000A
X-HE-Tag: 1764228721-80931
X-HE-Meta: U2FsdGVkX1/iCAOERDDyUOyNy6Glgp5u06pjVwOm+TFQI00XdxACFbdH/FhcGChguzskOJasUjlpNZ7SD/2kN02ISl+7jPpduUlO+81k4F9dMmF0w89d5gvC0QLwCGbRDoDBMhomWC+CZYzIhz9vNbXL7E/20K7Gm8pI7LsT2l0ikB9JGVOyKbFL+Bt3+9MZ9aXcfBpESit7UGz1xwNcSRmGp/lvOhBrtWO/Kn04jGlBqDY5o/a9Z8+6LIZAaYztG8C4Nyp1qtRx2KoEpV5RXA/ff+4QRimnIFsd1DR+if2NURv0ydhNxU5F0ALipTnfw/xF+jz0BAkc+HP+dGfvkeMzXZyIICmu6rmfJmCMiLmRrqWG/N3H00mVtew48yMjn37iQ5iy4CVGAYFzsWAt4xluacNV1lh486rSmYYDzPzaWS6UJeF1kJHdMwxDAon6oFKQZA5yk7gD+Ho1mclXop2VC49/EF0sKc86Sxs7ngxTiyiAMnrlq15aEMkg+udyWuYWye4o/tgfaMezvVKik6OI1M2579hLjduMAl74lkQaFHLju7NzeOM0PTRW/mg9xvJSP5JjJaY0IK8GwwN1fbwIMtJrsXCeGQy/6BRKCG0Q1mA8H0aoDkcFlf2u4wM1OjwkIqF4LRIKQSfdY9ZR+DI9ImhYds/NVfxKj5OyryZA+g4wa2BBFD6DoGkydq+q212bknUM3VP8XgIdII/L8w6SmljNCDdSIoFfxYcEZAkw1egyhnYQJBK6NGFcz4OQE2Egdt9ogMjnkXJRKxdO7qqodC5B5V/Oo0RM1Uo3Kl4isi421fDldcadBKim3pnLN7saHAWXZgDLaixc8oCskxkpD/xb1SciGiO9Tbqh4wOy+i4rqKXKJOmc2H/37SoB3nDUQJMawQnCAbKBo2zcZtvxpyt5jZgBjHUmzrpdN+KyK5fnAQjbMtViDDMgbRl8Iw+nOaCi6rhUV24Axja
 vk+eyDoB
 CfYACN0Ymu5vErLnwQPcTKYNymXQRqq1Jld/1glbPTkc0eaxbtc+lSDA7iWw0Qa00HONZ5WaCPIUuQNpxOED4sVbwCJ5zJIwNezURJiu2++MLRFPpoD8d32a1RwI4/jobJZwcTHDIXZgcxh2PlKEoBrGnEVytkCy4TJBYepxa5wlOrUDeGiH/n2VtoZ3SG3XNVYgTAKezHSJx9Cty6xUhRFJAKBeoOQJGxsUFPzZNKz2qkynMTMyeCOBdC2RDQ3g+ZQm289p9AlHUYRRHzsa42ZI9xsFqO3ADTRCI78K9vUa8O1s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/27/25 08:14, David Hildenbrand (Red Hat) wrote:
> On 11/26/25 21:31, David Hildenbrand (Red Hat) wrote:
>> On 11/26/25 17:34, Ryan Roberts wrote:
>>> On 26/11/2025 16:07, Ryan Roberts wrote:
>>>> On 26/11/2025 15:12, David Hildenbrand (Red Hat) wrote:
>>>>> On 11/26/25 16:08, Lorenzo Stoakes wrote:
>>>>>> On Wed, Nov 26, 2025 at 03:56:13PM +0100, David Hildenbrand (Red Hat) wrote:
>>>>>>> On 11/26/25 15:52, Lorenzo Stoakes wrote:
>>>>>>>>
>>>>>>>> Would the pmdp_get() never get invoked then? Or otherwise wouldn't that end up
>>>>>>>> requiring a READ_ONCE() further up the stack?
>>>>>>>
>>>>>>> See my other reply, I think the pmdp_get() is required because all pud_*
>>>>>>> functions are just simple stubs.
>>>>>>
>>>>>> OK, thought you were saying we should push further down the stack? Or up
>>>>>> depending on how you view these things :P as in READ_ONCE at leaf?
>>>>>
>>>>> I think at leaf because I think the previous ones should essentially be only
>>>>> used by stubs.
>>>>>
>>>>> But I haven't fully digested how this is all working. Or supposed to work.
>>>>>
>>>>> I'm trying to chew through the arch/arm/include/asm/pgtable-2level.h example to
>>>>> see if I can make sense of it,
>>>>
>>>> I wonder if we can think about this slightly differently;
>>>>
>>>> READ_ONCE() has two important properties:
>>>>
>>>>     - It guarrantees that a load will be issued, *even if output is unused*
>>>>     - It guarrantees that the read will be single-copy-atomic (no tearing)
>>>>
>>>> I think for the existing places where READ_ONCE() is used for pagetable reads we
>>>> only care about:
>>>>
>>>>     - It guarrantees that a load will be issued, *if output is used*
>>>>     - It guarrantees that the read will be single-copy-atomic (no tearing)
>>>>
>>>> I think if we can weaken to the "if output is used" property, then the compiler
>>>> will optimize out all the unneccessary reads.
>>>>
>>>> AIUI, a C dereference provides neither of the guarrantees so that's no good.
>>>>
>>>> What about non-volatile asm? I'm told (thought need to verify) that for
>>>> non-volatile asm, the compiler will emit it if the output is used and remove it
>>>> otherwise. So if the asm contains the required single-copy-atomic, perhaps we
>>>> are in business?
>>>>
>>>> So we would need a new READ_SCA() macro that could default to READ_ONCE() (which
>>>> is stronger) and arches could opt in to providing a weaker asm version. Then the
>>>> default pXdp_get() could be READ_SCA(). And this should work for all cases.
>>>>
>>>> I think.
>>>
>>> I'm not sure this works. It looks like the compiler is free to move non-volatile
>>> asm sections which might be problematic for places where we are currently using
>>> READ_ONCE() in lockless algorithms, (e.g. GUP?). We wouldn't want to end up with
>>> a stale value.
>>>
>>> Another idea:
>>>
>>> Given the main pattern where we are aiming to optimize out the read is something
>>> like:
>>>
>>> if (!pud_present(*pud))
>>>
>>> where for a folded pmd:
>>>
>>> static inline int pud_present(pud_t pud)	{ return 1; }
>>>
>>> And we will change it to this:
>>>
>>> if (!pud_present(pudp_get(pud)))
>>>
>>> ...
>>>
>>> perhaps we can just define the folded pXd_present(), pXd_none(), pXd_bad(),
>>> pXd_user() and pXd_leaf() as macros:
>>>
>>> #define pud_present(pud)	1
>>>
>>
>> Let's take a step back and realize that with __PAGETABLE_PMD_FOLDED
>>
>> (a) *pudp does not make any sense
>>
>> For a folded PMD, *pudp == *pmdp and consequently we would actually
>> get a PMD, not a PUD.
>>
>> For this reason all these pud_* helpers ignore the passed value
>> completely. It would be wrong.
>>
>> (b) pmd_offset() does *not* consume a pud but instead a pudp.
>>
>> That makes sense, just imagine what would happen if someone would pass
>> *pudp to that helper (we'd dereference twice ...).
>>
>>
>> So I wonder if we can just teach get_pudp() and friends to ... return
>> true garbage instead of dereferencing something that does not make sense?
>>
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index 32e8457ad5352..c95d0d89ab3f1 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -351,7 +351,13 @@ static inline pmd_t pmdp_get(pmd_t *pmdp)
>>     #ifndef pudp_get
>>     static inline pud_t pudp_get(pud_t *pudp)
>>     {
>> +#ifdef __PAGETABLE_PMD_FOLDED
>> +       pud_t dummy = { 0 };
>> +
>> +       return dummy;
>> +#else
>>            return READ_ONCE(*pudp);
>> +#endif
>>     }
>>     #endif
>>     
>> set_pud/pud_page/pud_pgtable helper are confusing, I would
>> assume they are essentially unused (like documented for set_put)
>> and only required to keep compilers happy.
> 
> Staring at GUP-fast and perf_get_pgtable_size()---which should better be
> converted to pudp_get() etc--I guess we might have to rework
> p4d_offset_lockless() to do something that doesn't rely on
> passing variables of local variables.
> 
> We might have to enlighten these walkers (and only these) about folded
> page tables such that they don't depend on the result of pudp_get() and
> friends.

Talking to myself (I know), handling this might be as simple as having

diff --git a/include/asm-generic/pgtable-nopmd.h b/include/asm-generic/pgtable-nopmd.h
index 8ffd64e7a24cb..60e5ba02bcf06 100644
--- a/include/asm-generic/pgtable-nopmd.h
+++ b/include/asm-generic/pgtable-nopmd.h
@@ -49,6 +49,13 @@ static inline pmd_t * pmd_offset(pud_t * pud, unsigned long address)
  }
  #define pmd_offset pmd_offset
  
+static inline pmd_t * pmd_offset_lockless(pud_t *pud, puf_t pud, unsigned long address)
+{
+       return (pmd_t *)pud;
+}
+#define pmd_offset_lcokless pmd_offset_lockless
+
+
  #define pmd_val(x)                             (pud_val((x).pud))
  #define __pmd(x)                               ((pmd_t) { __pud(x) } )
  

IOW, just like for pmd_offset() we cast the pointer and don't ever touch the pud.


As a reminder, the default is

#ifndef pmd_offset_lockless
#define pmd_offset_lockless(pudp, pud, address) pmd_offset(&(pud), address)
#endif

(isn't that nasty? :) )

-- 
Cheers

David

