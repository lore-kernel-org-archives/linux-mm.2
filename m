Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBE6A109316E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 03:09:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 509756B0421; Thu, 19 Mar 2026 23:09:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BAA06B042D; Thu, 19 Mar 2026 23:09:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D0576B042E; Thu, 19 Mar 2026 23:09:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 299816B0421
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:09:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E7D661DD00
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:09:35 +0000 (UTC)
X-FDA: 84564961110.28.3DD621F
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf24.hostedemail.com (Postfix) with ESMTP id AC618180006
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:09:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=j7VGs8Kj;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773976174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VWrUuwn6/3D2jBpHTBrix7nCaDc+sDPWfC/Ra1XXa8Q=;
	b=DS5UG8f4D8h1Uv0KmFO8qVoumj4rYXWNfYvetwZKWCF6E7rEQ2tIVcH3yy85yPeT4IDwB/
	NAA/cuBsmeiyU4GL/XM5LbP+1G8TSSeo9rzI5ve1tJVw94sVfNU7tot9neI/g3gnMWxDTv
	pgf+NyEh7wVdpwKnTNVV3nRvMgmaUy4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=j7VGs8Kj;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773976174; a=rsa-sha256;
	cv=none;
	b=mFcAuyNriwvre/gr5UESWomUh9kc1y4pMYSV/FfW5j5pjvD+2DBW9B+LnA3kQKWCpDMyMm
	WERsJeij1YZxt05RJiFABvxGv24lquCfoPfju0yIIrt70lRF7c8parV0lphVo3Scz/5dA7
	1HZnw76WQG94fihB5w4+hETrd0WHmmQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773976170; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=VWrUuwn6/3D2jBpHTBrix7nCaDc+sDPWfC/Ra1XXa8Q=;
	b=j7VGs8KjVuuuzQ1cQvvGaD/P/rZRDoIb2hSGGkSaYazWS9aMVrPy3EM/GFinsa3FmB7EW832UoPIAb/fL86fZER3F0IzAPD1PgXdbnNkseuF4Rbd+3Rol4vmur4hB+4+FPxap/HdH3kkREaQoCnvwpj4j0jLo6ern/fcRlfe6os=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R681e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X.K9Y71_1773976168;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.K9Y71_1773976168 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 20 Mar 2026 11:09:29 +0800
Message-ID: <a745d7ad-5d6b-4bef-b102-09139f56556c@linux.alibaba.com>
Date: Fri, 20 Mar 2026 11:09:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] mm: change to return bool for
 pmdp_clear_flush_young()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-arm-kernel@lists.infradead.org, x86@kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 kvm@vger.kernel.org, open <linux-mm@kvack.org>, linux-kernel@vger.kernel.org
References: <cover.1773890510.git.baolin.wang@linux.alibaba.com>
 <eb513ed809685f78e0abdeb7f7b6ebdec0fcca18.1773890510.git.baolin.wang@linux.alibaba.com>
 <60e7cc1b-1459-44d8-8088-30b7ba3e9b44@lucifer.local>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <60e7cc1b-1459-44d8-8088-30b7ba3e9b44@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AC618180006
X-Stat-Signature: k1wxhd1eh73qmzdjzjnxa6r3thchddms
X-Rspam-User: 
X-HE-Tag: 1773976173-534626
X-HE-Meta: U2FsdGVkX19RA+9yyDYo71y/kx1K9yIKTlkohsNNexcwWYZFqVCReQrrjayVHI0xbew/E6lRlkb+UeJtdBrbnsb99g5cVFUXLcqGHUKtORFLCbzpSA3VRmHigNmdUQaIlqAmqD1x9565YJ0ZupTKFKMrW/qsSi/P3V/HwBWUYo20ud+bbgwJrytxU+Nd6R10sDUVoebemJE8AFlvMkFXOSqnDkCCQA9pE1jCARQvxXTyr3zrWCv6K3SBxlUBwBk5O9A01y21aQNA3+xT92pHPmYaWC2ZWzZ0ioj7XVyN/wCnRklnsGOsid479RT9fCYJOh0xRj3vrY1v/+jO94OYzglBKjExjC0Pu2LMC2R+G5qfn/2/KA0twX3okMQCvglCEv1jJk9NqVHcwyTGe5P7TMEkObiU2g1mv201WFqFMkg7A+Yeu1vr4bxpHYgJLJzeUiR5Ekn6LuNDY6AN8KiAPLR9HnxzXiRvZ2CoNmpwm2UG0dTkRV8VDrHryreRhvx2k8cWj4rC0rOrY2MOReUPoAdbT31a/Sde+thO2eHph5d/MGnY4Na+G172K/aLBxczfNG8iknqWy9/lnt9EALCZ5gRmOm5XRc+PA3Lc1FHBaj9BOpkGiUrL5uFxK0AF37agbHAzvVCKm3W7OAVgxijsHef3vBbKNIVZeJTOcJL7+2xcGvMCPcv5rQeLE6mr47XEddBCvsN6lJ6bJa8wFOGz55nXKza551fJkEN1Zq0YvJS6Jzu5yFebNFtAocEXTFKSM8DpKCO8s/vJBYLOcicTxM6obrHxf5S+lfaJjr8zpK0NTPgm8DYEb0PPHm8m79T2DAtlVSlZtl9pKhffQCK4aU4MuI2VA+5yojvzhwfNT140dYy+MDBgrgMAwaCwy3JbXiI051mcElQYoQ0XHfeTA76EagyD48DISjwR3PqxiLKkPCVt84o+2uZ2tzfy9ytuL7dWVUkwdWxPhx+Z9R
 jCYGdZDX
 wu11r+sq3UM/STLeki1073fEUnbQGKLLqWJO/8EGviKfu3WOgPayOUa+jJirYkeSqOWC64Besr+h0rBC2zEYTZMgY9rAfIyU2/WTz2o9BIpXitLyvrtl84K8S1uYai9e2dc8qKAxCpTfgGVsR8sZLWPYRuaEGTmyNmgbLh9V5D7yMyFGCG5wTgzY0AiWwM/8r/GeMPPtvydWF7y3JCOnpgkuwBYoxdYxF7x2lJv8/hhDWarep8P7Av9WYlATZBCJgHoqWYhbl2mV7B2oIhfjLCa+AgbHRFq1F5J4sv6MNtF72o8RXzwBeskFUZlk4LMkxMLlO+rLHdzoAj7ORnFs0yfcd4fUjYJjOjnTwhFxhAiRyflY9P17tr9+IRTeSOGuH0kkH/HZTu2fsuW7x/Rxz1lmR6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/19/26 7:33 PM, Lorenzo Stoakes (Oracle) wrote:
> On Thu, Mar 19, 2026 at 11:24:03AM +0800, Baolin Wang wrote:
>> The pmdp_clear_flush_young() is used to clear the young flag and flush the
>> TLB, returning whether the young flag was set for this PMD entry. Change
>> the return type to bool to make the intention clearer.
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> 
> Some nits, but otherwise LGTM, so:
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> 
>> ---
>>   arch/s390/include/asm/pgtable.h |  4 ++--
>>   arch/x86/include/asm/pgtable.h  |  4 ++--
>>   arch/x86/mm/pgtable.c           |  6 +++---
>>   include/linux/pgtable.h         | 10 +++++-----
>>   mm/pgtable-generic.c            |  7 ++++---
>>   5 files changed, 16 insertions(+), 15 deletions(-)
>>
>> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
>> index 1f5efb7be71d..90bba85ca4b8 100644
>> --- a/arch/s390/include/asm/pgtable.h
>> +++ b/arch/s390/include/asm/pgtable.h
>> @@ -1693,8 +1693,8 @@ static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
>>   }
>>
>>   #define __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
>> -static inline int pmdp_clear_flush_young(struct vm_area_struct *vma,
>> -					 unsigned long addr, pmd_t *pmdp)
>> +static inline bool pmdp_clear_flush_young(struct vm_area_struct *vma,
>> +					  unsigned long addr, pmd_t *pmdp)
> 
> Same indentation comment as with other patches, 2 tabs you know the drill :)
> applies to all such in this patch.
> 
>>   {
>>   	VM_BUG_ON(addr & ~HPAGE_MASK);
>>   	return pmdp_test_and_clear_young(vma, addr, pmdp);
>> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
>> index bd02ee730a23..f9439449c9bd 100644
>> --- a/arch/x86/include/asm/pgtable.h
>> +++ b/arch/x86/include/asm/pgtable.h
>> @@ -1301,8 +1301,8 @@ extern int pudp_test_and_clear_young(struct vm_area_struct *vma,
>>   				     unsigned long addr, pud_t *pudp);
>>
>>   #define __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
>> -extern int pmdp_clear_flush_young(struct vm_area_struct *vma,
>> -				  unsigned long address, pmd_t *pmdp);
>> +extern bool pmdp_clear_flush_young(struct vm_area_struct *vma,
>> +				   unsigned long address, pmd_t *pmdp);
> 
> Drop the extern please!

Ack.

>>   #define __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR
>> diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
>> index 10a5e0b2be36..8c336edf0e65 100644
>> --- a/arch/x86/mm/pgtable.c
>> +++ b/arch/x86/mm/pgtable.c
>> @@ -503,10 +503,10 @@ bool ptep_clear_flush_young(struct vm_area_struct *vma,
>>   }
>>
>>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> -int pmdp_clear_flush_young(struct vm_area_struct *vma,
>> -			   unsigned long address, pmd_t *pmdp)
>> +bool pmdp_clear_flush_young(struct vm_area_struct *vma,
>> +			    unsigned long address, pmd_t *pmdp)
>>   {
>> -	int young;
>> +	bool young;
>>
>>   	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
>>
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index e53220b0a9a3..8b8838f19af3 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -536,18 +536,18 @@ bool ptep_clear_flush_young(struct vm_area_struct *vma,
>>
>>   #ifndef __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
>>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> -extern int pmdp_clear_flush_young(struct vm_area_struct *vma,
>> -				  unsigned long address, pmd_t *pmdp);
>> +bool pmdp_clear_flush_young(struct vm_area_struct *vma,
>> +		unsigned long address, pmd_t *pmdp);
> 
> Ahh! Here you drop the extern :) AND use 2 tabs :)) thanks!

Right. Because this is the mm subsystem, and I know the maintainers' 
preferences:)

