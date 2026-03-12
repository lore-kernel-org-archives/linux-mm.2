Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A73F1106ACE5
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 19:54:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15AC86B00A5; Thu, 12 Mar 2026 15:54:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FE796B00A7; Thu, 12 Mar 2026 15:54:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 004C86B00A8; Thu, 12 Mar 2026 15:54:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E35C16B00A5
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:54:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7B1ED585BA
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:54:46 +0000 (UTC)
X-FDA: 84538463772.14.8011158
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9B69D180008
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:54:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iSzk4avl;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773345284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PfkOcqhXFxA9PiSl14DA3G1JNqOSdTvV2t/DRJQEYDU=;
	b=FfGKvQ+5Eg6f+/HQcbS5lQ/wioUxglhTGJSBreAaPQ8qPLmw+DdSbpBJgA+J8jkHTaYzDj
	wTKActo+qudhOhpyF/8QLOXARCSIFVWWKm09eWuNpdh+NDD8kjV7GnfMZoPxBggLFJTF9F
	xS0UAcsCvLoviwRhQ/jGVaBhmIRoseo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iSzk4avl;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773345284; a=rsa-sha256;
	cv=none;
	b=wV29by6ojCPD/i43+5BDFLe0BFgS5l4TrmUMhy2Oh+tfIla5iioVsTLi6nIy2ryL8bDIfz
	ALdHYOUdYzzCYE+zi2YUl1dvPLsc+J+HymZl9SWuJcsIdMTOhqEHCZmLtxY8rKU9voziBT
	x9pnKHMNy0MA/4V6jECZWhb6EfAakkg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A77984441A;
	Thu, 12 Mar 2026 19:54:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1A3C4CEF7;
	Thu, 12 Mar 2026 19:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773345283;
	bh=OBCfG9u3DvXwt1MtllXM5gETtRktObPfLgkWnIlyb+M=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=iSzk4avlrOlfEVM4USEyeYBoWRm+qcJUIdyTVAkiCGccUnxBLT2ozYh694LRjNcSl
	 yE5/I/pQwTbe/scPpoqiiq/w8grtIXOHd6DueNrsu3q1fxq2gTr8f84403lWWgek0/
	 4ZJqFJXu/B97G2XklnJ+Bo9FUzdDR+fgg8YQiXHdGVsJo6DKKkrsLeuyYZ6euFRkIc
	 7L1CihLA7xiZAJpgra0LNFhrP5KKR8qVCF4STk3TN3/sK+jyZ4D4UubbLO3bScMzz0
	 YlNxJxCdafMWaznDB0r9lh17u2idN7EduC+ODZM+SQcpORT5IGhs6xTVj4GTzombgf
	 BPWLC1FlPwTqQ==
Message-ID: <39436a71-adc3-4ca1-8c4a-87dd4cc955d2@kernel.org>
Date: Thu, 12 Mar 2026 20:54:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/11] mm: Relocate the page table ceiling and floor
 definitions
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Suren Baghdasaryan <surenb@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Pedro Falcato <pfalcato@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
 bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
 Matthew Wilcox <willy@infradead.org>, SeongJae Park <sj@kernel.org>
References: <20260121164946.2093480-1-Liam.Howlett@oracle.com>
 <20260121164946.2093480-2-Liam.Howlett@oracle.com>
 <231fd45e-3c0a-4c9f-917d-255d03fed6f2@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <231fd45e-3c0a-4c9f-917d-255d03fed6f2@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9B69D180008
X-Stat-Signature: xbexqxja97yxeybdied7aedyrxieq969
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773345284-244175
X-HE-Meta: U2FsdGVkX1+3i+ne0oKkbR19OzBRUPozVBzFHe7CUAnphSY9wqGXqFjFMUjgkIrA8Is5CUSxCJJJ7MUT1kkR9HxGArKsgHu2lUDC4T6zRxUpHK2tHs6XnJT2PbeAQYMtGvZDDb4tiF6ft3u7/US1WM5fZKh8IUbCfTx+vvCU6tWWuqFUa3ZP/j88Psfz0sXa+ynBcvHAWeNGO4cmeoAXzwIOXA6evgacNuJSR6bhwzr5Voj1cNjaRMm0wLGYdfINhxNTWdVGJmP3OH5joYMC38NUjQhQ4Q4HzyO/me8sktyl5HY3Ud0AoyNIrAElYXSgTtIU0wTCLjgiIgGSTPjLhmvvugRNWJsUsw4JNw2jvLHwXMjOp6qScUmdE6KNEMrgdl77vm8EVT9FmI6+6s4sLJ7No1XjApeIN0HkR9aEdynw1J6TI98yi5jj26qmpArLndSc+zHL3ujAQmV4NeNENXu5s7Bz1kJ7wSg3gnJ2FEitcJpl82KRFOqYTPhsCGCp3CLD3AuQ/NuZXbVa1tqKy8Uwur8E2gjb2rdox8j6pGrIAR3XwK7wFuprib2NDQOBflNfYpZHNcskD2s0YdKB/g2fodAl93TEL89E/+4awv3VaIvAYhYZA4I8ZkM7z5rZ+6o00ZjPNVSny8dCcXWX2zKQh210I3hZw/n19m+Yde8PIAy6Fg7lFfih9QWvvNzrCC7G9wWk1SgyciVKh/ZOqnTeYDRj0uozyeDTACzF4FfCbjQFFwBcwrz5GPGfNTYsOnYgUWeCi5WO5pVv6VX2VUW8XCGYlPwB3/eKMeQYy97y8ol+f9k4Ol4aKqaCiHlMVd1jh4NwbM7HPzfmInestMMRfNIy4DPProfch6ydcVl/shfU4Paq0QhExKye6JvwGR6txbDONkJZ7DLFYdu/9QzBXorZd/iRzsYuEUr9V16LubA2AVhvCqFuHHlj66LBkeEyW8Cy5kUabq1+oRV
 yBNSIoUk
 rUVe/uh9KUEd1Ej7JSVf5sF2d0u96/Pqx5V6Ip3kO/lsmkySWo6S4CU97+ntFcJdxbDtYj/55rmpqL4JqebeNaotSodsbcvsUELqjIbyLjzRA2cmEWd5YmfGNTPlT/Eszl6eSqs7nh1VxE50V42knhhxIRzortwcTDxyL47dJSTs35+GsZ22et5aIrJU1IwXqxrbOU1osXot4r8AQYFUBzQwgAbBC/6fCFiCQ442EbfcOChgWOsA1IpdMruWQu5brRiHODsT4jYsCxA0yOr/XtTE5SNkaw4zdoae17qnOd8glBcvSDH0m1gmXUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/12/26 20:53, David Hildenbrand (Arm) wrote:
> On 1/21/26 17:49, Liam R. Howlett wrote:
>> pgtables.h defines a fallback for ceiling and floor of the page tables
>> within the CONFIG_MMU section.  Moving the definitions to outside the
>> CONFIG_MMU Allows for using them in generic code.
>>
>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Suggested-by: SeongJae Park <sj@kernel.org>
>> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
>> ---
> 
> 
> [...]
> 
>> +
>>  /*
>>   * No-op macros that just return the current protection value. Defined here
>>   * because these macros can be used even if CONFIG_MMU is not defined.
>> diff --git a/mm/vma_internal.h b/mm/vma_internal.h
>> index 2f05735ff190c..2da6d224c1a85 100644
>> --- a/mm/vma_internal.h
>> +++ b/mm/vma_internal.h
>> @@ -46,6 +46,7 @@
>>  #include <linux/swap.h>
>>  #include <linux/uprobes.h>
>>  #include <linux/userfaultfd_k.h>
>> +#include <linux/pgtable.h>
>>  
>>  #include <asm/current.h>
>>  #include <asm/tlb.h>
> 
> I was also confused by that change. But it's not worth a respin :)
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> 

Ah, and now realizing that this already hit upstream.

-- 
Cheers,

David

