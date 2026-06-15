Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2564CD98C5
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 06:39:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 156A66B008A; Mon, 15 Jun 2026 02:39:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 107726B008C; Mon, 15 Jun 2026 02:39:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 044966B0092; Mon, 15 Jun 2026 02:39:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBF7E6B008A
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 02:39:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7BA471C32D6
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 06:39:50 +0000 (UTC)
X-FDA: 84881196540.20.562E501
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6A08E1A0009
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 06:39:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=kgwFdMeG;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781505588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hY8+k6kcJNKwzCIC9WhJ1T70bUQwv+uxIXjEOx4iuEY=;
	b=R1wT13QDELITFNas7ITU/2Aw1wV4p+IqIx4k5VAreNkwAAUKpLGz0eT41uhQ4ZNIi8hDzz
	DEUIERypLHFkJZc5R9Z3jnN92Zz5L8oZHvbQX+wAmFfY9OLb1j7wVUUrZksrMafGbtvelq
	VaMD304ztEiVFBm9V9jglrsnydMcmKI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=kgwFdMeG;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781505588;
	b=QCmA3kW5Hk2lkeo4av9oxaQmcwagMNiCe6/tSApIZp9o2tYXs4b/y5S1Z9N2MKf1CedG3q
	egxjTdmkOWL7W9h0zPUzFN0kezFhufsoZvqWAibe3uhAPiWq80g751OB4HcEIJb7Xbeaec
	WjzJA53VHXzP/PGkuAGpdcTKLEu6NjA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781505583; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=hY8+k6kcJNKwzCIC9WhJ1T70bUQwv+uxIXjEOx4iuEY=;
	b=kgwFdMeGl4r3zenIzX+SYyB3VF5TafMx/DFzj74yg0vEDUtHVcqZlDylfkt2hAid7vne1FFhK3E2kper8HCjsmf6ADNoMuA/CNomRl4zVAaIoa+pQYhrANIxC5YTaDEsrEUfYxH+rMky0C/tnkXM8H5znmvUVgBtANboF42mpzQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X4qIdAG_1781505581;
Received: from 30.74.144.140(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X4qIdAG_1781505581 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 15 Jun 2026 14:39:42 +0800
Message-ID: <3a724359-b80f-4344-9a01-74c9f1459503@linux.alibaba.com>
Date: Mon, 15 Jun 2026 14:39:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 02/11] mm: khugepaged: generalize collapse_file()
 for shmem mTHP support
To: Nico Pache <npache@redhat.com>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, hughd@google.com
Cc: willy@infradead.org, ziy@nvidia.com, liam@infradead.org,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
 <1274846e121e74f8db53950bec64f8f1938f2ec9.1781083630.git.baolin.wang@linux.alibaba.com>
 <5eba8380-6fbc-4c0d-b267-cd39c24ffeea@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <5eba8380-6fbc-4c0d-b267-cd39c24ffeea@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: mtjfsneiij8ffyx4aeyduptpxzdynk75
X-Rspamd-Queue-Id: 6A08E1A0009
X-HE-Tag: 1781505587-463304
X-HE-Meta: U2FsdGVkX1//pVac+/9ZWuOH+8ojzl3raAenFvpcpe58BX2DpqLGSEdGZtlcaxhEK/j0+OjyOAVti/x/EGgbOIyowF65Cqz3fFE1XFM9Zjo6LAYYgrpiA4/WPudPldfrQkEmhbRRpCeC+ufmHLF3wAet591AYj68d/+SD3JO6iKhA/uM2rWEUX/s6u9vrCF5k0Wu6Ou7PzGkfVNEVrGO8j9EucgAbl/KGlqy3cJYTURYoBJSjBeIyS0ggvC+rFk7w8TYp+xvECHftVuHXbUbcooqccM2sNuo2ssuFcH+AUToJ4IBdaxxswnScAzfYutU+D7q4J+w2p8LJHqM3AUD/Ntu4H+0tlbXcMtyT3rn85BEHcvyb+TPYzGxYY7OpWIw8SiZXl7OmGh1wcf15e2eQoRgw7RXIhFZ51pEpJfYHIUCNW8cXgHzyrJvl8wfZs7zVzkJ1ADMmDEUfXsutnKcKHTu/PDjx1Zz/fFliar79ZJ56qEmGvvVqR6u4ICNBgay79QyXwd35mUs1OEaFz7fruu1lZBJ9I1nm1PcN5kBp3pfIadIxdz+B0X+eoUMD8XZ5lc5u0eWMj6MzjpPUuRxsz0F01AnIAVu5S1tUQ3XOpJpTy+EaedMPn1eYkKqt/errir8Jx0fH8Yat8g8YxEk7MI8gDbydxBqtLFPMmfIqwFtBsZhRgKl0CmAzVkhH6gQZ1QBQW/+a1rXzQXNd5mfc9Vdw98EdKBTEyCjCVL0VMf59+l7VcDomB4kuHyBlRLJ9sC+34oTOGLAowLG2afMe7jts0bSm1FkY/mMNQMIobMjSWhMOMTHhZDbSFj+JBIc/VmLN2c9OE+xiYwqDyu9JOui6uWBr6cV12Y17cfHLOrG2xXSS/EwFrLb3+1w+xK+WGEhzpz+W7FwS8Z2N5wH3RX1DqF873/Hvg5UWfZC5ZzDXyA42FcG+q1x0nGqtzhesHJklPHs+7Ra3AsozEc
 BisVPR1O
 IacMdcT3bLF/O/JosXjCz/S2MRe7bQDwe/de8DtK03kjg0jolIo346jWNEukrLMTWIvL8vi0MLKyu7A3PvqmVEj4tZDPgl4HwkAX2FQ0ItN+FF4RAVJKhTWFco2se0PW9gbppk6Jj6LutKj/VVHDpwNt7WYsoVQpX+TUZnMwshq1Ia7u7g8Ovk/VYN8yUa9/T0WnocO0G7BVzaLqDkehy8GlIOLm75urkMEmGg+VK6+kxA2ZWvCgDwlQMFPeI8QXXSS6+SpeL1Ru3dK4W0jd1SzR6qslPrcpW12xFg7RM89OOovGamVZya7olfOHdoHmPXGgy+Jjlr08Qo9Q120G4QFwbIMlNOI+7Gxlo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/12/26 6:16 PM, Nico Pache wrote:
> 
> 
> On 6/10/26 4:29 AM, Baolin Wang wrote:
>> Generalize the order of the collapse_file() function to support future
>> shmem mTHP collapse.
>>
>> No functional changes in this patch.
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   mm/khugepaged.c | 27 +++++++++++++++------------
>>   1 file changed, 15 insertions(+), 12 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 631459172e19..4adc8c6de062 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -2214,6 +2214,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
>>    * @file: file that collapse on
>>    * @start: collapse start address
>>    * @cc: collapse context and scratchpad
>> + * @order: folio order being collapsed to
>>    *
>>    * Basic scheme is simple, details are more complex:
>>    *  - allocate and lock a new huge page;
>> @@ -2232,15 +2233,17 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
>>    *    + unlock and free huge page;
>>    */
>>   static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>> -		struct file *file, pgoff_t start, struct collapse_control *cc)
>> +		struct file *file, pgoff_t start, struct collapse_control *cc,
>> +		int order)
>>   {
>> -	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL, HPAGE_PMD_ORDER);
>> +	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
>>   	struct address_space *mapping = file->f_mapping;
>> +	const unsigned long nr_pages = 1UL << order;
>>   	struct page *dst;
>>   	struct folio *folio, *tmp, *new_folio;
>> -	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
>> +	pgoff_t index = 0, end = start + nr_pages;
>>   	LIST_HEAD(pagelist);
>> -	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
>> +	XA_STATE_ORDER(xas, &mapping->i_pages, start, order);
>>   	enum scan_result result = SCAN_SUCCEED;
>>   	int nr_none = 0;
>>   	bool is_shmem = shmem_file(file);
>> @@ -2252,9 +2255,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>   	 * mapping, the shmem check can be removed.
>>   	 */
>>   	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_folio_support(mapping));
>> -	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
>> +	VM_WARN_ON_ONCE(start & (nr_pages - 1));
>>   
>> -	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
>> +	result = alloc_charge_folio(&new_folio, mm, cc, order);
>>   	if (result != SCAN_SUCCEED)
>>   		goto out;
>>   
>> @@ -2591,12 +2594,12 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>   	}
>>   
>>   	if (is_shmem) {
>> -		lruvec_stat_mod_folio(new_folio, NR_SHMEM, HPAGE_PMD_NR);
>> +		lruvec_stat_mod_folio(new_folio, NR_SHMEM, nr_pages);
>>   		lruvec_stat_mod_folio(new_folio, NR_SHMEM_THPS, HPAGE_PMD_NR);
> 
> Is this a accounting bug? (not your changes) but
> 
> lruvec_stat_mod_folio(new_folio, NR_SHMEM_THPS, HPAGE_PMD_NR);
> 
> If this stat is in THPs why are we iterating it by 512? shouldnt it just be +- 1

This is not a bug and this is intended behavior. Please refer to commit 
57b2847d3c1d ("mm: memcontrol: convert NR_SHMEM_THPS account to pages") 
for details.

