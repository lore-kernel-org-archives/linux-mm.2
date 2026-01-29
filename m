Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5FB5D46C16
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 01:42:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C97AC6B0088; Wed, 28 Jan 2026 20:42:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C44556B0089; Wed, 28 Jan 2026 20:42:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B50CB6B008A; Wed, 28 Jan 2026 20:42:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A50476B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 20:42:21 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2329F8C0AE
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 01:42:21 +0000 (UTC)
X-FDA: 84383301282.27.E6A003B
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3F50440005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 01:42:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Br8Pn4NO;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769650939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1mooo+VFrXzT3ho52+vyVC3gkAOeJGRzvzapS1lW0iw=;
	b=lmC8oWHBkdMM7Y8ocVkV3v1gGZCITHhu810ioOazIBItcG+4duO0FYKwEir1DcrVTpAzh1
	lp8dGrdaeE2KVb3UEAWRmhZZaOOzaB48l4tGJfZcKu3ywtQ6ziTGx6vh8EoJo8hln9qNRt
	zTTrWfx1+f9pJvSyGRil2n25zgD8i0c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769650939; a=rsa-sha256;
	cv=none;
	b=Q9ttaAYngChWiVDxANLZC4Iv396OMVo4XsZ8+R2nxTPou/GNAQ8R5HPnwGGdiAxAHZcpfh
	PZ9iUl8fXquHWy6/Uwy3Sw7cT0bWpIYSpik3jNQh2rtOtyh09gDW26FGV6w7FjqALmW2IE
	2XX9FcTwUZSGlq5FzI6h7+aVi/wlqUs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Br8Pn4NO;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769650935; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=1mooo+VFrXzT3ho52+vyVC3gkAOeJGRzvzapS1lW0iw=;
	b=Br8Pn4NODrrLXM+Vcbw6tFOpFFqlJF2RPyEIvne3KBfw/VNcK6M+eH5Bu0z2PDdTuFl3nVXvhDVwjudI4PBPXR6Hb2a9Cw0YGvEGjLRlncsQKQJw3/Kc23ws48DRuUFck/j00f5iD32aEMD4M5kQQqvYYTwcyWDbv6OJ06NitdU=
Received: from 30.74.144.124(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wy5TwiT_1769650933 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 29 Jan 2026 09:42:14 +0800
Message-ID: <de141225-a0c1-41fd-b3e1-bcab09827ddd@linux.alibaba.com>
Date: Thu, 29 Jan 2026 09:42:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/5] arm64: mm: implement the architecture-specific
 clear_flush_young_ptes()
To: Chris Mason <clm@meta.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, dev.jain@arm.com,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <9d866a2644051e13a41ef4d6ca3909c6e1f9e229.1766631066.git.baolin.wang@linux.alibaba.com>
 <20260128114936.72280-1-clm@meta.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260128114936.72280-1-clm@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3F50440005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 9p53y47jojkfoy6wduitt4nncjay43n5
X-HE-Tag: 1769650937-120139
X-HE-Meta: U2FsdGVkX19m79Vz8yUt+1KrIPyTIvTM3EURQQpoqTgF9sySBNbQWQKsT+P4lVTPT8DZ7MRr4kHtmeKeBS2zS96fZX4ucIhK+VZXRwVtB14Hdzp9dKYTajvDRfiOMQZlyAeLgDA91gJbw0u9sHbXN1O9LPqMfZNPWgB8BSSC4a8ldlI0nia5gyCThyzKkyT8RbuxrLMbJpIfeuGgmC6/wRxOFpUoUvKKM46D/dw5mF5+9T4YXPiZLzYfhNa1PEvNlrF2E1oDfJ5cA3/I0LOfYmsnwzUenogNTg9jiW/ugs9WFfOiUrvHIjo+ESP6Th3+272Sbq7XVkSo0D++oADWM7MffGK1N53s+VeIxK+e+Gn30m98mNsgbHSLKlOm1rzN34KLfhniotxYOlPKE7xKIGIhsQ1eq31sPq7nG7qxDtDaoKYHu2LP6rfbXRuy0OBU1g3eAZBoq/QAAFcCxYhTZg3I28NEQWYuz1VhSpMgWseTJYUJhV+mtN3Lyuj1AvidBLKeA24RaZV2ijCPcJ3QRdFID2S6AcBHfCGmZohYY7wI+ybxFTGGIsztkZKsoQv4nvJOhYFT143lq0ipJs6MOHJIgB6dxIlacRGJu+MEQt3Ah05I/tIK9dk3IK4GV51OrI07CzBABXU48uHd/y7d1U/pwfZ2Lpq0qhZN++aqd3FDiA4vWTVQorK9b8vwtvQ5IKZwmYhtDxcEeb9GVktIZiug4013uvhBU+TCKu4mQDD2fsf0T47FFPIHsql64R/4poL6TeQnpuvSXGzMBCew05AVuqOMgLx3XZqtyFryoHb1Zt+hcOOzh7mBUmp7O66z7HJnovq7dQxG/alCG5gVHMa425eGUhQy9GIjXC7VSS+il+8/Xy99pyaJUsEwy4pNRmVhK7f680GmloUJdrRnA90m/zBIuAhHW4idG+oy+jW58qWemeHyZ2IbjeKF95ItSEdYw0VcdZuscko9Pb3
 TJvD2tRF
 U4RRNRpDlxTFTO6aroGT4BQaEPmEag50WRZgfiz5iVDgyVhJv4IIeT7UgAxYpCYkfr5coJcz32ZNLv+5ONsNAV5NSsTVFcA10q/SjJ0z8MgYXR/RRRgHupLlN88vEC9fKABOMTBN+llRdiYcz5uN4RjQGh3vjPh5j2aY3Ru1c7AWpITm1fOhaA6ITs6gpVAWGEzMISrkZb22xfCv4PHUYHNA0lOHWm1bZgrGpGsvpKU/Gd8njVo6t+los0XSiF9ULE3w35r4H03ejKUxtT/DBUa+OXktyI94PD7ukfGImKftERJL0/SsIda8VcsFDpR6Qmydzz0sudxJIkyrMyzRtOp26x1J6KtA6d4fqN9Y0QxN/ENZ/99vM0wgKLA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/28/26 7:47 PM, Chris Mason wrote:
> Baolin Wang <baolin.wang@linux.alibaba.com> wrote:
>> Implement the Arm64 architecture-specific clear_flush_young_ptes() to enable
>> batched checking of young flags and TLB flushing, improving performance during
>> large folio reclamation.
>>
>> Performance testing:
>> Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
>> reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
>> 33% performance improvement on my Arm64 32-core server (and 10%+ improvement
>> on my X86 machine). Meanwhile, the hotspot folio_check_references() dropped
>> from approximately 35% to around 5%.
> 
> Hi everyone, I ran mm-new through my AI review prompts and this one was
> flagged.  AI review below:
> 
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -1838,6 +1838,17 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
>>   	return contpte_clear_flush_young_ptes(vma, addr, ptep, 1);
>>   }
>>
>> +#define clear_flush_young_ptes clear_flush_young_ptes
>> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
>> +					 unsigned long addr, pte_t *ptep,
>> +					 unsigned int nr)
>> +{
>> +	if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))
>> +		return __ptep_clear_flush_young(vma, addr, ptep);
> 
> Should this be checking !pte_valid_cont() instead of !pte_cont()?
> 
> The existing ptep_clear_flush_young() above uses !pte_valid_cont() to
> determine when to take the fast path. The new function only checks
> !pte_cont(), which differs when handling non-present PTEs.
> 
> Non-present PTEs (device-private, device-exclusive) can reach
> clear_flush_young_ptes() through folio_referenced_one()->
> clear_flush_young_ptes_notify(). These entries may have bit 52 set as
> part of their encoding, but they aren't valid contiguous mappings.
> 
> With the current check, wouldn't such entries incorrectly trigger the
> contpte path and potentially cause contpte_clear_flush_young_ptes() to
> process additional unrelated PTEs beyond the intended single entry?

Indeed. I previously discussed with Ryan whether using pte_cont() was 
enough, and we believed that invalid PTEs wouldn’t have the PTE_CONT bit 
set. But we clearly missed the device-folio cases. Thanks for reporting.

Andrew, could you please squash the following fix into this patch? If 
you prefer a new version, please let me know. Thanks.

diff --git a/arch/arm64/include/asm/pgtable.h 
b/arch/arm64/include/asm/pgtable.h
index a17eb8a76788..dc16591c4241 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1843,7 +1843,7 @@ static inline int clear_flush_young_ptes(struct 
vm_area_struct *vma,
                                          unsigned long addr, pte_t *ptep,
                                          unsigned int nr)
  {
-       if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))
+       if (likely(nr == 1 && !pte_valid_cont(__ptep_get(ptep))))
                 return __ptep_clear_flush_young(vma, addr, ptep);

         return contpte_clear_flush_young_ptes(vma, addr, ptep, nr);

