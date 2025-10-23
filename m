Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 879D0CCD1AB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 03:32:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B57C8E0009; Wed, 22 Oct 2025 23:32:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93E418E0006; Wed, 22 Oct 2025 23:32:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82CCE8E0009; Wed, 22 Oct 2025 23:32:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6E1DC8E0006
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:32:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EFC981A09CE
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 03:32:43 +0000 (UTC)
X-FDA: 84027957006.13.C723501
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id BD0F61C0007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 03:32:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761190362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nh3hshQ+ysIn5MUGT4KGHVcRBUUeXdFaGOkh3qi4U6A=;
	b=49rbQlwhpUbUfVGYxfQLULGu5Go30f+Ewr3gkU/oT4lF7/esH/wB2abBEQUS6pRQ+b4QsE
	3nxBSjCwRc/CxSOSCNkklnZP4oWUxg1LBkMeVg6JIfqMfi8h0FKQgtCI58bzUQQNeILlTr
	M4nJ/vDWiLq1Wn4cCQIYbVbB1jUUGSw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761190362; a=rsa-sha256;
	cv=none;
	b=ZgQenzDruSoNjDUQIqjSq2ddnFjBbY/agISZwSU0XbUSh0FQKaP3K88QzYm4jP0bXWZ34z
	X68yWFiCre6deGGchKY4NABsIOH8C4+R500sfaByaFDgoUuqFsRYmbx6BspFD1hhcdLWAB
	JQjdsb7UVDiCbXS3jmltzvzpBJJrUNk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AAAD31516;
	Wed, 22 Oct 2025 20:32:32 -0700 (PDT)
Received: from [10.163.71.44] (unknown [10.163.71.44])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 930813F63F;
	Wed, 22 Oct 2025 20:32:38 -0700 (PDT)
Message-ID: <f9104ef2-8ff2-4111-9a44-33f4d361a416@arm.com>
Date: Thu, 23 Oct 2025 09:02:35 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] mm/debug_vm_pgtable: Add [pte|pmd]_mkwrite_novma()
 tests
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>
References: <20251022032951.3498553-1-anshuman.khandual@arm.com>
 <87ms5i2z8t.fsf@DESKTOP-5N7EMDA>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <87ms5i2z8t.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BD0F61C0007
X-Stat-Signature: x54so16kc1zh3fmjbha9x5x6gm14c91r
X-Rspam-User: 
X-HE-Tag: 1761190361-152911
X-HE-Meta: U2FsdGVkX18kqm4HE/mBZLy/UtnGSiKEqBEx3EmJQKHcBiONmSlVawIVzFTCt+n0uAiEf6qcGKaggNxVb7V8lllcj+Qwe/4pN47UIx+UyE8o+Tsev4iZ+x98eb+bgKapwJAF0G2B1GqXZFFNPqX/NxNb6s4Eg0v6AA7COm3OGKdpnWgj4vOLY3JNxSh7MbhlrZsUMOrgDswXAUSB2MSG8HmmmRyL48SUTS+zOo1aE2ue7zUeWOIgURvNm7VuehXZ+uMSBRSQGhUX9Q9Ym1zXeHT5DUVKz/CBRcfCcUPA6wB8fIOJhEDeYCKdeAtwHJ3X8IZzEadNrs7VJRRChPFidPCRhqlH5N4WOcSRYwW6SKkqYfsBsMTetyv5iamyrF1ks3B1pJK4w5fDHTR52aPVOgPgb6LHPg3VQw1nKptH3MZRugRom6e/wjeVoMRiS01RqmZzxONS/QfFPr1NUnjjaCjGij5OYpL/O3sAtxGdOEU3l41Wn7uecpk/N7vUgZVjZ6ZzCuaP4Gj64p8gf9dcLRIdyXEBokH8w+WW0jbbpJiBCH8tDW4OGpQdB4TTP+30zvOSJDmTKLmtOQkVJMvCGHAFItBwRIs4cPgQquUeedVjOfnEYLBdvpRWtHR5Dc90ViBEXn7/S6PRiYkA2lENBsJ2hphQpaYxqcrk8M5eMfD7BHSbg4k3EBUkoAo9FkjchNQ1q669Syn1I8N6OPqGfhOvEVY5Ub0JFO0b5Q1ltKk1vB//5B6T8vh/cOn+MLY8IzbUrC8i2O4ELYtzqjSvkFr+PqVBnT8u0RBwMF65kmMumVOWpQQ1EO5uUlQrjYK9xbL/CIAWf8AVcyt96LYruZ6EFFd5PQ4k0poLy2mJB8XDnRXYhi4OKoAMrpjckk4PCjRE27GK1TQ1bTR/W6l85So20DMZp9jfuNP++oPh/D0ntlJFiEAUQZkVYTybdY6pwgRYA47TCVSaberPPsL
 1yCE61qT
 66hpNpJELjjJws29+S0QgtRMWV+xLz1w4Bby9f9C8klqQRauxdjGHAnPJ4ypvRmNhphWqx2RM3WcUMhh5s2/rulo3XUbkguagu+9gPJN/rA+YK1ziFuMx2wMH1WpdgCTWBbF50ZNX4rBt8FSaGLvuwkzLwc5ecPB6FXLXCgBZRwJb8wQoxsoLubkTfh50zUeFxQqnKe5EX0VIiFzlX9Jq8KpRbFMmOwHBHXzwbHxAVc9yZ1NataIYYtvJfB29K3GxRoYJweZX527BjMhYYbiQIdlPkMB4pYrFGSHqP62hBU09mssebW9ABxpgrghCiAPwyuhjH52EVyIJ0KDmx9/OW//EAxO+VtF30qPB+uI9jAbs5nVxf9XciBFVG5e5qPPq/u4jpAvSmg8RFvXouVPbNZChoI6pE+84x6cREA5EljtJ0r9uApdXiA5uwQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23/10/25 6:47 AM, Huang, Ying wrote:
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
>> +	WARN_ON(!pte_write(pte_mkwrite_novma(pte_wrprotect(pte))));
>> +	WARN_ON(pte_write(pte_wrprotect(pte_mkwrite_novma(pte))));
>>  }
>>  
>>  static void __init pte_advanced_tests(struct pgtable_debug_args *args)
>> @@ -195,6 +201,12 @@ static void __init pmd_basic_tests(struct pgtable_debug_args *args, int idx)
>>  	WARN_ON(pmd_write(pmd_wrprotect(pmd_mkwrite(pmd, args->vma))));
>>  	WARN_ON(pmd_dirty(pmd_wrprotect(pmd_mkclean(pmd))));
>>  	WARN_ON(!pmd_dirty(pmd_wrprotect(pmd_mkdirty(pmd))));
>> +
>> +	WARN_ON(pmd_dirty(pmd_mkwrite_novma(pmd_mkclean(pmd))));
>> +	WARN_ON(!pmd_write(pmd_mkdirty(pmd_mkwrite_novma(pmd))));
>> +	WARN_ON(!pmd_write(pmd_mkwrite_novma(pmd_wrprotect(pmd))));
>> +	WARN_ON(pmd_write(pmd_wrprotect(pmd_mkwrite_novma(pmd))));
> 
> Why not add
> 
>         WARN_ON(!pmd_dirty(pmd_mkwrite_novma(pmd_mkdirty(pte))));
> 
> too?

Sure will add the above test which will also be symmetrical with a
similar PTE test being proposed here.

