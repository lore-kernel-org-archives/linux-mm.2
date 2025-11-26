Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F829D11195
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 20:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C6E96B0010; Wed, 26 Nov 2025 15:32:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 877306B0011; Wed, 26 Nov 2025 15:32:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 766916B0012; Wed, 26 Nov 2025 15:32:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5EDC46B0011
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 15:32:13 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EA866140741
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 20:32:12 +0000 (UTC)
X-FDA: 84153905304.09.F6E292D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 38ADD140014
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 20:32:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Jx/Kgk+5";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764189131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T7aY121qgdlo7tVaxg7djllP6yLRJB74p6ieQk7JtJU=;
	b=pzHJHkxhglNH4/p6Lz7X1BaJ4SmuwxAZRCuRb9Zu4xgfHSk36x+KdJtnrBydoLBP68Btn/
	Oer1zeFM+mnLi54/vC94perutKmC28aTxtBhumRCU3Ym/7tCLNtgdBdW20tcVIcHdw5n1e
	T8AygIhIoKuv4QPVvieojWnticZ06Ac=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Jx/Kgk+5";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764189131; a=rsa-sha256;
	cv=none;
	b=ac/jQQpYc1iwC6KpjIk1MxqxAZ5m8t/fU8Qipljak9J2BBByhifydcpFeyzLfrywGQTJJq
	2XP8i2k/qVSgUoTsZA0grgrWlnSeMx0kX/vgiEA6C1q6E9B1sq3L9JH1/stVdg/1Scuuzh
	m/b2CMbhpntxpFcS6Y5NnJzpC43bwnA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C98D60240;
	Wed, 26 Nov 2025 20:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3847CC4CEF7;
	Wed, 26 Nov 2025 20:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764189129;
	bh=khfCF391HTb9ZHzqQ+60+gHc4LAP9io5EVEWBl7iijM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Jx/Kgk+52Vj2FhMiZ6roXAU107DOPSpYbR54l0SQDWU1t4R7bMm8s+HInc6989b/V
	 2cDeU+ZWwLLmnlIHfOpksf+IBP4hNK1ffXi/vUjPpjPeMUHWhngzJAH08bkmRCtygB
	 JQYHqUKbcZT0vUQ9yMZl+kC9/gmskU6bpNYXfnQDKqkyCGA0RSgB7OzgPbQ8c3/498
	 Hj59w7VENc7+o6gJI8CLIr1pUNoVV+wBzyXoI68l0omVxKWgWCP/hDOMsqKxthd0sc
	 wzgbPhsCM4izLtPHPs9w/dlr+8C1vK0GSmWsZcSnhl5za7yLVxWM4Vlo72RSYvYAyJ
	 DvL8Jn/H8RkGQ==
Message-ID: <b2fbe58e-f47b-4a76-879b-fd38a915c2ce@kernel.org>
Date: Wed, 26 Nov 2025 21:31:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/22] mm: Always use page table accessor functions
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
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <150ffcb7-2df2-4f3a-a12e-9807f13c6ab9@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 38ADD140014
X-Rspamd-Server: rspam02
X-Stat-Signature: qisfro8wewpg57amufpggna4dq6akgne
X-Rspam-User: 
X-HE-Tag: 1764189131-349632
X-HE-Meta: U2FsdGVkX18yzl9tlFfDxmO+oxnJpZqMkkOzm5KPRm00RDhSvDQbWvsnui7JB33Nhgf+MxQGCwB57LR5CVgGHMvsypWFUfE9wd3l+m/31dk8z3bztVnzuHgIviSY4dbQC22Gomg/HR1xh2Ji7GtuxEMqzxZ6QV+QtWABczFdJDjB8uP1wYzrh7j1a3foTap2tFHayuaWLUa8pwFoPxAQA2p3ICBsZpw9SeF/c8Us0BwsbwNLu32H5Rfh5QmEyJl0KWuj1lQL+QwY0gT1FMKVMzkM8AqcidMfi1ZyFCJot2Bqowe5aBpqAIoyy+/fplTqJ3LAoQghVSJ1fV9vSSEOj9q2ZLY23BeSrivmSoC7UOHBlFM0iTnoT6kepevLcRVUT79kocSiTbh/ZohETe8lgtk5erijgy+8aslYnQYAgeBMnOiJxj1QdrmnxzcIlLA/HbUjPFfh82amFF9eskbLQJCsqJBwqNpBsvKPGRCN1wJRRvO3AjhCp9dC8f3wcZWLejKKsBR+1Wpu7m58Z2UXO3enGXI3gD26/MQeRJcQBHSVB6FpfoiEDXcfhtx87CDmfskY5zBkc/lzK0FV/73t78w54KBprQwPbKDvm7JwnAlRHzV4xU0X0hrs5llRxDIMzSST+gVdXqiOMa89sJgVPXJjdDoeMZzYmYzWY21BS21pAG8VmtLM9Jy+258HLfweDUjDfZiP5gJwBrCD2mSu2/U8sKnmkkSf0WM8yWWP2AGDde5nscSCJJak6smVGLwdFRfAsAZJCI72mPKr56N2JJ2c5/T7w2DPWzBaCbaZBNt/HORgyGw5ZQaOsnNGqmYA5gQU+/4te3jWfHN7L560SDf5yuEKxw+Ue1nj5udWqkQGz8SuDoRD1TGvhaw2E2uDxMp/oPUf7M1ZeFS1qugvWClbBHCyp5nRWCWRAPUb/zDP0Kr6BIQaGqLEI78czZ5w7ZbmORPIlwUrySi1Kbk
 X/OL7zad
 ksAW7/eFCOCQGHDkJDXbbTqLgUiWbxIosA/0wj2/HRq2ggfRMX5afpMkX/1J6ZI7Xyqjhnl3GkmKlUp0abs4isZjWFDpNnvn/BuupqasK6TZvyBCJa2mLIv8/0mkMmxKbcdTxQTwgYtIqR0mDWwQUJ/+14qBNM5zV7kYCvxIeDhne1NnRtRU7TJD6jqoQxD585GXFcyVgJ6XYnSzrpef7GAVO0y0Ea8EXC+Nuyoo44YN0C1dE87lFZsYUeF3EdDO9OpOZN+6k0B4gzQAHuOpv05IUhehKuuLQfLU3aAK/Ybqbyzc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/26/25 17:34, Ryan Roberts wrote:
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
> 
> Another idea:
> 
> Given the main pattern where we are aiming to optimize out the read is something
> like:
> 
> if (!pud_present(*pud))
> 
> where for a folded pmd:
> 
> static inline int pud_present(pud_t pud)	{ return 1; }
> 
> And we will change it to this:
> 
> if (!pud_present(pudp_get(pud)))
> 
> ...
> 
> perhaps we can just define the folded pXd_present(), pXd_none(), pXd_bad(),
> pXd_user() and pXd_leaf() as macros:
> 
> #define pud_present(pud)	1
> 

Let's take a step back and realize that with __PAGETABLE_PMD_FOLDED

(a) *pudp does not make any sense

For a folded PMD, *pudp == *pmdp and consequently we would actually
get a PMD, not a PUD.

For this reason all these pud_* helpers ignore the passed value
completely. It would be wrong.

(b) pmd_offset() does *not* consume a pud but instead a pudp.

That makes sense, just imagine what would happen if someone would pass
*pudp to that helper (we'd dereference twice ...).


So I wonder if we can just teach get_pudp() and friends to ... return
true garbage instead of dereferencing something that does not make sense?

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 32e8457ad5352..c95d0d89ab3f1 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -351,7 +351,13 @@ static inline pmd_t pmdp_get(pmd_t *pmdp)
  #ifndef pudp_get
  static inline pud_t pudp_get(pud_t *pudp)
  {
+#ifdef __PAGETABLE_PMD_FOLDED
+       pud_t dummy = { 0 };
+
+       return dummy;
+#else
         return READ_ONCE(*pudp);
+#endif
  }
  #endif
  
set_pud/pud_page/pud_pgtable helper are confusing, I would
assume they are essentially unused (like documented for set_put)
and only required to keep compilers happy.

-- 
Cheers

David

