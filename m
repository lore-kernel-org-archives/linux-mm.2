Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5B56D64079
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 06:44:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFDE16B0005; Wed, 17 Dec 2025 01:44:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAB566B0089; Wed, 17 Dec 2025 01:44:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB7E66B008A; Wed, 17 Dec 2025 01:44:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B9BE36B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 01:44:43 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4FFCA8B663
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 06:44:43 +0000 (UTC)
X-FDA: 84228024846.09.F81DD41
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 549C840007
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 06:44:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rt6RdONG;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765953881; a=rsa-sha256;
	cv=none;
	b=du6ieixuH7gGTKZ5ibLTYV/o4UivOF1TTovEPSFOeAHechYIYyDu5P6Yj6tze8JXSvPmb4
	2hhDBVdNcXN9hQlpCJI4K9Ck7FEyRnJX/lYdjbZJIuL+HdVf5YTq6CXecgrIOu1sYS3iTP
	MkD9u8aZTyBPDa64bItGyHQYhK7VvmQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rt6RdONG;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765953881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k11HXNGhgQ+qa2nrzsTblXusICoL85lOX63vXQEX4po=;
	b=507qtCiiUiVKZAlzisE51E0/w+osCiiJrbpOL9tDDgyo95qeaWFMW0kLN4dpCfFYlAVQQ9
	rCeISF80rXGOMIFIC+KENdma1PGBOBB+yIHZqmAZBPdKNiFoFN3priXfLYqDbSX8DlHPkB
	xuOaNqWio6U5rDliS8GSsqeahUXQZ1k=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765953876; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=k11HXNGhgQ+qa2nrzsTblXusICoL85lOX63vXQEX4po=;
	b=rt6RdONGyARYk+jIVU3Wr8rV2hPWWXNI0NRJ4upc9BJpcI8QmvFxz972VZOVTSIwu83vS1Gf/WSA5G+dev/2vZzdAG547Ytdlg89sJPXYH/rQ9u+GEca9YWwkHRkQfkeU3j+3UBra4j1DtWzGhaVUGDV7DVBMBnmpWwMgV2GfLQ=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wv2EYSN_1765953875 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 17 Dec 2025 14:44:36 +0800
Message-ID: <abba55d3-08f9-41c0-9870-4bdbc705d647@linux.alibaba.com>
Date: Wed, 17 Dec 2025 14:44:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm: rmap: support batched checks of the references
 for large folios
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, david@kernel.org,
 catalin.marinas@arm.com, will@kernel.org
Cc: lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
 <545dba5e899634bc6c8ca782417d16fef3bd049f.1765439381.git.baolin.wang@linux.alibaba.com>
 <17380b96-3a9e-46f9-b22b-0e770f7f1b4f@arm.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <17380b96-3a9e-46f9-b22b-0e770f7f1b4f@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 549C840007
X-Stat-Signature: 5ybaby7fim3yozioe4u5puuut48s3gcz
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765953879-368917
X-HE-Meta: U2FsdGVkX18SuamFOY/XzHit4BLj2QZotZDgHABAdCIlTcQRXXVM3SUV07tlv4OJfnzyXEhyoulG2TVmON6S7/swxGlGLn4AoBcQTEAKiCo7EiXTUCjhsJZ1BlPpoSr4fwm+/kQoILe7KDVo2i9aBRJ71Gf5CF4cukAbc+W9KoOGk1jJL2Ffha1Fx2TKecbQSq92+eTSB9oguGr+4CRR+wBSDLCJ1yNEkdSXEqYaQqBftPxP/yR/kBZrD11Kcmj0FM+GfnmOeZJ2no3zAbKZ/1KPNItlE4AV8gRlUF9an+UvurjMc0/RTeGOOTsNUgd4jV4xf9JzNnnGNoD8DseW/7TZ6p4NaVgqztOpAWGuKI1hbIXsm+wgtZTlRkMXQlyM9L4nc0AplLqQIEHBL0DG6aI0/SmS50gTYYtERAAmPC9Qz6TyVgtSe2kkP2YpkJ2xT3o/2OXhnv4nFS2++pwEGlbVWNctWP9Wfc2nCP7s9IO6ZHdcW5OlocAEvxr4byK1ofLW4bTmA5Xv3CYLwW+d4X2FK1T4fV+aOlkSbyZj+zsPnJ5EY/JABeYPV2IvV7oI17hSpFgHWqHcBzu2FqroahJyYlg+cS7UtB26Ftw0iVtOXYvruqoc6qnh209JayTd5cJMHT9zQ3Sf2PB0WQtqSsRZX+fSSFcPNPFBD3vjnWifISFrjCwYhlKTzKdyCEQlsqKU7uMjGePZt0+hJI7yoBXcMsDd3kzNmotyb2kYQMGVqYuvVSVRCFFFb1T9O9j+wzYPKr5DK3KpCYPdPB3fGJBcK6P46sDB3bYrdNrBFDUgg/QYYD0NZw0xP0O0f7iwk/gtHwbp+D/uGNoSLjwiZZ26z+SpRuwdZzhcxUy/Fb61kVdzs1LU8OhQBJYbmTbSBgW6eslXJrl/o5RbuSgHm9+2SXfTsDIhAm+2dpPvADrw9GB7rrLYuyaUSyuxEBP+3nt3DdNbSsYZMAo5SX1
 W4rQWF6J
 1VHtZSWg4kcSZrmrU3xpkracpXDWqCap7Mfdu9ZcSPRwJxSwI1DzZZZsTRTw95v/PDQOXm2mx/WNafGhS77nvZDtwHbutcZhy4oNvv8F7Di9gP+D0WtWJP+leQVYgP9Twx4w/dhiznX+ClZ+n4wjNER6BTCbmbKNKvFQ88leD+0vnSMc7PxwxvSbx7GNYb17jekUGgcRAYmtxBf+NyCj2EKxqq053xO5xU56OuC785Ewv82baMbHKOm3U/vlat2Q81VOn+rmVXrNAz6r3RNEuOwc87xLxiSA7GmKB6b26z05wRnk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/17 14:23, Dev Jain wrote:
> 
> On 11/12/25 1:46 pm, Baolin Wang wrote:
>> Currently, folio_referenced_one() always checks the young flag for each PTE
>> sequentially, which is inefficient for large folios. This inefficiency is
>> especially noticeable when reclaiming clean file-backed large folios, where
>> folio_referenced() is observed as a significant performance hotspot.
>>
>> Moreover, on Arm architecture, which supports contiguous PTEs, there is already
>> an optimization to clear the young flags for PTEs within a contiguous range.
>> However, this is not sufficient. We can extend this to perform batched operations
>> for the entire large folio (which might exceed the contiguous range: CONT_PTE_SIZE).
>>
>> Introduce a new API: clear_flush_young_ptes() to facilitate batched checking
>> of the young flags and flushing TLB entries, thereby improving performance
>> during large folio reclamation.
>>
>> Performance testing:
>> Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
>> reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
>> 33% performance improvement on my Arm64 32-core server (and 10%+ improvement
>> on my X86 machine). Meanwhile, the hotspot folio_check_references() dropped
>> from approximately 35% to around 5%.
>>
>> W/o patchset:
>> real	0m1.518s
>> user	0m0.000s
>> sys	0m1.518s
>>
>> W/ patchset:
>> real	0m1.018s
>> user	0m0.000s
>> sys	0m1.018s
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   arch/arm64/include/asm/pgtable.h | 11 +++++++++++
>>   include/linux/mmu_notifier.h     |  9 +++++----
>>   include/linux/pgtable.h          | 19 +++++++++++++++++++
>>   mm/rmap.c                        | 22 ++++++++++++++++++++--
>>   4 files changed, 55 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index e03034683156..a865bd8c46a3 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -1869,6 +1869,17 @@ static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
>>   	return contpte_clear_flush_young_ptes(vma, addr, ptep, CONT_PTES);
>>   }
>>   
>> +#define clear_flush_young_ptes clear_flush_young_ptes
>> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
>> +					unsigned long addr, pte_t *ptep,
>> +					unsigned int nr)
>> +{
>> +	if (likely(nr == 1))
>> +		return __ptep_clear_flush_young(vma, addr, ptep);
>> +
>> +	return contpte_clear_flush_young_ptes(vma, addr, ptep, nr);
>> +}
>> +
>>   #define wrprotect_ptes wrprotect_ptes
>>   static __always_inline void wrprotect_ptes(struct mm_struct *mm,
>>   				unsigned long addr, pte_t *ptep, unsigned int nr)
>> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
>> index d1094c2d5fb6..be594b274729 100644
>> --- a/include/linux/mmu_notifier.h
>> +++ b/include/linux/mmu_notifier.h
>> @@ -515,16 +515,17 @@ static inline void mmu_notifier_range_init_owner(
>>   	range->owner = owner;
>>   }
>>   
>> -#define ptep_clear_flush_young_notify(__vma, __address, __ptep)		\
>> +#define ptep_clear_flush_young_notify(__vma, __address, __ptep, __nr)	\
>>   ({									\
>>   	int __young;							\
>>   	struct vm_area_struct *___vma = __vma;				\
>>   	unsigned long ___address = __address;				\
>> -	__young = ptep_clear_flush_young(___vma, ___address, __ptep);	\
>> +	unsigned int ___nr = __nr;					\
>> +	__young = clear_flush_young_ptes(___vma, ___address, __ptep, ___nr);	\
>>   	__young |= mmu_notifier_clear_flush_young(___vma->vm_mm,	\
>>   						  ___address,		\
>>   						  ___address +		\
>> -							PAGE_SIZE);	\
>> +						nr * PAGE_SIZE);	\
>>   	__young;							\
>>   })
> 
> Do we have an existing bug here, in that mmu_notifier_clear_flush_young() should
> have been called for CONT_PTES length if the folio was contpte mapped?

I can't call it a bug, because folio_referenced_one() does iterate 
through each PTE of the large folio, but it is indeed inefficient.

