Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D82CDCCD195
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 07:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AF6C8E0005; Wed, 22 Oct 2025 03:58:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 187758E0002; Wed, 22 Oct 2025 03:58:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C4B18E0005; Wed, 22 Oct 2025 03:58:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F08248E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:58:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9044813BA1D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:58:51 +0000 (UTC)
X-FDA: 84024998862.09.A44CC10
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 98C2F180002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:58:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761119930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iz62cHlVvJrUCfZyete/eVuTH0uggulS4hgXpv/KDQQ=;
	b=Yv6YN8B4TMQTsWO4S51nG8ftKg9mPKj96DxCVx9Lp8t5/mhcLlkiB/cdc5UfAXN1nWpSRT
	YBK3NV99sVp9clkoMJ/nncnCfWlaJktOtQ4HDabb2Z9/ZrF9VEfJ/GPKPuM2yjat+kckks
	6nbDmJmYBOhs0j2MLJSVH8Krz+ZpS+4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761119930; a=rsa-sha256;
	cv=none;
	b=SeApk6wTqCfrvayRgf2w8NTs2qT1XUMZil+/JSfxL4KtCYpd0PEThB+saxoM7GvxIANdgn
	1MjP51WN/uNAz1nyowYE0VhC/marG/kcAr3fq4wipD31qstQ+IXbf4R7bXc8dmHi1EVwXB
	MDY2UbVMdmh4lQD+SA4dlxse6PxHpuo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AE4201063;
	Wed, 22 Oct 2025 00:58:40 -0700 (PDT)
Received: from [10.164.18.45] (unknown [10.164.18.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9864A3F63F;
	Wed, 22 Oct 2025 00:58:46 -0700 (PDT)
Message-ID: <b5a1b52c-75ef-4915-a254-a502b9f78eeb@arm.com>
Date: Wed, 22 Oct 2025 13:28:43 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] mm/debug_vm_pgtable: Add [pte|pmd]_mkwrite_novma()
 tests
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>
References: <20251022032951.3498553-1-anshuman.khandual@arm.com>
 <87ecqve6gg.fsf@DESKTOP-5N7EMDA>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <87ecqve6gg.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 98C2F180002
X-Stat-Signature: 9i8jaerc67ncfbpz9z6uqrrhd4jbkzfs
X-Rspam-User: 
X-HE-Tag: 1761119929-900760
X-HE-Meta: U2FsdGVkX18GkhWA+4raI6PEZyU8Ce73DmwteJ+JTHdUsKfEXhbFHXv8qJYo8I38AHDp65sJ90GbzIETPRW5w1T3KBps29yfP1uVKJkO0yQrrauzs2dIrxwmL5U0DUVJhZ99/LAop6+gv7rTmdkHIbOuwxBFIz7pRhGfcIMSkNwRLEb5gTzceq0n3o+1N2/8G6P/jIDwRje92Ez9p+D0AAMDAAPpjJbdM6zWaYKZ/HDvz7rbxO7YpzjRJNplb3Pgch/qCuusOjPO5qPZIvmQOE/yGwciVf2vs88pHT79MhImdrVMqPS5ECRIlQsCuPTaM5cQWAkriehr2k3bGcUkvky/TIdLD/GkoECIgIN9n9jFdbY6rjEbZE2LFYs9BLonOqUpe2l7XXgHsYrzJpXxyy/pLHYBZucHb82uRS3SVG7+EKUxeBH2Q7ZjyN1XgF8cNz0DeMX1Me+kVAuqMaVOiSLo4lsnIo70eTxUxaowVApyWYJJCeuVAuu84EzcO7wQXjI787oGyEQFJrdm97fyY0N3qFn0jGxlmlbnyGsVbAqOMsl/ofHdE8KuaUFS9AdzUuzYf+DQ+/BxuHz2aOgKPm2m/9dpmOqDpb4f3IcZnAGBRZ6IQz+Bo1jqb85MypyhLcw0gdrNZnjDcBgvm+0He/yzWw6yMWJba2wBUc/xKp1LoXCI3lYOsL9OJrGLARVBa8cCP+KQuvajtSxRq6aGM/0z+0mAbeelfC472xC4Z/M3RIvixgrTHyBIi6RDTm1E84c0TReSAQTrs0R9H7oEBLX8lsXpBpolw3Iu9HI8sG0o2Gpl0yESI6FlzGwxm0dHqk0u+LPm6vOw6ZYK6dN/cZrE7soNZCO/hPk9Hfe3pDMKAEkQXJYWyv3JiH6hyTu8JcT1XAsuhsRGpdd1zzYaETPEpeyOos2oZTeuT4uc6R3btMsHAuP/TMgiE87UBgSwppd7uImc0uB312uPtqw
 wwmiZZGZ
 hZjsd4R6pQkKI2dXuBTioalVl8w9NvDULJ2Q4yPBJVvi4dgWEUSQ1lvFZR/OyT+Ew9RU7WmPR7L8OLiV9zrkEALjjd2gZslIEN8c2UxHijTTjoDQ31u2O6zIQahEZwXzRUESCjFnP2dwwx5WiusJaTRDpXdbVnp2lV/r48npI0seg6KWJZvUffByvOYj25qSiSO/1DYYDjJ47bTG3GqfH85ywHP10PYiD48b9jhcDqTngG7XG2gHdbVA5Z2J66o7c7v0bHJrKH2qlzNZPyePx/5qoFigLwGok1A9dZ0SlhbnfsvyFFLkIQ7sSMUx/js3YRayitt0b3gfZFv7qpJi8R//n614OumhkYAZ7Xw+X4B0HyC/zCHENfyXsvFyhCmVWO5cBKUFwnSoKr08=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22/10/25 1:03 PM, Huang, Ying wrote:
> Anshuman Khandual <anshuman.khandual@arm.com> writes:
> 
>> Add some [pte|pmd]_mkwrite_novma() relevant tests.
>>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Huang Ying <ying.huang@linux.alibaba.com>
>> Cc: linux-mm@kvack.org
>> Cc: linux-kernel@vger.kernel.org
>> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>> These tests clear on arm64 platform after the following recent patch.
>>
>> https://lore.kernel.org/all/20251015023712.46598-1-ying.huang@linux.alibaba.com/
>>
>> Changes in V2:
>>
>> - Added a new test combination per Huang
>>
>> Changes in V1:
>>
>> https://lore.kernel.org/all/20251021024424.2390325-1-anshuman.khandual@arm.com/
>>
>>  mm/debug_vm_pgtable.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
>> index 830107b6dd08..def344bb4a32 100644
>> --- a/mm/debug_vm_pgtable.c
>> +++ b/mm/debug_vm_pgtable.c
>> @@ -102,6 +102,12 @@ static void __init pte_basic_tests(struct pgtable_debug_args *args, int idx)
>>  	WARN_ON(pte_write(pte_wrprotect(pte_mkwrite(pte, args->vma))));
>>  	WARN_ON(pte_dirty(pte_wrprotect(pte_mkclean(pte))));
>>  	WARN_ON(!pte_dirty(pte_wrprotect(pte_mkdirty(pte))));
>> +
>> +	WARN_ON(!pte_dirty(pte_mkwrite_novma(pte_mkdirty(pte))));
>> +	WARN_ON(pte_dirty(pte_mkwrite_novma(pte_mkclean(pte))));
>> +	WARN_ON(!pte_write(pte_mkdirty(pte_mkwrite_novma(pte))));
> 
> Why do you use
> 
> pte_mkwrite_novma(pte)
> 
> instead of
> 
> pte_mkwrite(pte, args->vma)
Just wanted to have more coverage for pte_mkwrite_novma() helper which was missing
till now in this test. But just wondering is there a specific reason for replacing
this with pte_mkwrite() helper instead here ? Also we could probably add tests for
both these helper variations if that is preferred.

