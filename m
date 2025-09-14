Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94DAECAC582
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 08:45:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C9898E0007; Sun, 14 Sep 2025 04:45:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8530E8E0001; Sun, 14 Sep 2025 04:45:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 741DD8E0007; Sun, 14 Sep 2025 04:45:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5DD308E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 04:45:22 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EC5098570C
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 05:06:00 +0000 (UTC)
X-FDA: 83886668880.18.DD985CB
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id 01D38100005
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 05:05:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ldTQliaO;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757826359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wXTazR1bMiiIWVoUXZwEiKf3sZ28IYgq0QdmLVGmRII=;
	b=Xq/9Chci/u7aSjTzvc5iw8TSs/P0kC0fJ4PP1TMDz3mySKnvz0FB8OzDsutLtg1DkcNsnl
	+GE6dX8+Ca2PSb0TFJI92NQnObsNEH3xS1Dvon3tX1NFpHTjWeatVIdhgBSnmG/tPBSWwJ
	IyPq62S33m3OpUW61R00LwDT3xCfUtQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757826359; a=rsa-sha256;
	cv=none;
	b=lwpYnIvdJEHpCOjVIOAvqwMXyXc/cwX+ZxhgaFT/BzZwfo5Nx30FCCNeCNH+sq1BdAOtQu
	jBwPp5TXmt3XHfscainy5xvJcUqu57e/KQbprtxcFhj1jE64UCdeQho7mzSlaDef63uFh/
	jG43ETm55KGd05Cpe7/Y/9RJTmFDexg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ldTQliaO;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <3a1adf4c-9931-4cdb-a024-37c856b1702b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757826356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wXTazR1bMiiIWVoUXZwEiKf3sZ28IYgq0QdmLVGmRII=;
	b=ldTQliaOPaux1Q2OwnJRnhQAAx3FVcycptNAQYwKW+l4O8wNd0DlA5TEPxRJNH6sZYhC21
	LWTA0tNNhHI8odKA2jApM0Hwcay8DtNAXTr7IEF87yFSfiWZfbK8ifzhY6SK1xEblPjbpQ
	3v8bD81pYbIkGRGXX3bA8MUvz9O78UM=
Date: Sun, 14 Sep 2025 13:05:48 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/mm_slot: make sure slot is the first element of its
 wrapper structure
Content-Language: en-US
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, chengming.zhou@linux.dev, ryan.roberts@arm.com,
 baohua@kernel.org, xu.xin16@zte.com.cn, dev.jain@arm.com, npache@redhat.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 akpm@linux-foundation.org, ziy@nvidia.com, david@redhat.com,
 baolin.wang@linux.alibaba.com
References: <20250914000026.17986-1-richard.weiyang@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20250914000026.17986-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 01D38100005
X-Stat-Signature: mnzmebd9nd1uekme6cbn4etpitwjbg6f
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757826358-339855
X-HE-Meta: U2FsdGVkX18/RMbcsvi8WGlUZCl9Rv6WzQDrHebj4tCFX73XkCNdiZ3pyADxB4VU6KleOv+UOmDrbutM9zB3kX2xuse3HobSwEgVUjgVZqtgiaZbOpeB6b0GkGpW2NALTaBLjm74tzRyXvxNzHBR+sI6/NcSJTKyHrgec2ulyzZ8bew7RVczvK/mJP1dJsLh0iePUdkhtIbNdzcrbA+xAmCDxd+3g/GTd09EPfSPAJ86kHs/Vvjr0eDknGvgi0ToaSgay4b1PiW4Y5o86j+e7qcsAIu7dVAxP7CiEmhtttGiWmal77ccMpxdOYw9FVeVCgNseKbOj5gF8UBEVPc/umCm5HsO75Oy6xnofcNWsILxkSCkS+DyvhoNR6XI0XZp7TzqsvI6o/Lp0r64hMpnlhDK5rUfaIFQ2kgOX0qBsa48Id24w/6tr3nZYRDSdyyWKLeTwRh88d+4eo0rLTpI7C6O+8tzjIAecihhFNCA/bOjKeo04Y+sK9AUHtNWr/i7wEmQw8JDWV+x3FIImcNp3RalHZz8XxqZmuS3tw4a8/8Hwiev609oL+ILRpUfPQrN4URp1q9C0pxobHl63EdqcJsr8iAhwBDyxZZRWzGdOSF4M4R9EHdzQaCD4f7yBfy0llbwTlqIeqwEZxLl9I2nrfhLwFpVy2OuQERJTMVwU/doRmq6plHsr4g3YoIsTOIj22jz6ZqZqpLGYgES7PG8/kX6LfCS/0aUsPNxypmYz1TqG+Q4RnOkoQX7JYWUjgldmcPTQmjty9yfjtuvPwup4LKFUzmq3S43RiVy2W+ZK0XCL2/MY22NOeJMq7eUNzjof0qahk2r0kwAzuM2cppDdT2YoRAq8vZm7FFsiJb+1u3kbhaje77F/9i7ABWWCRLHiRdcKBn1FhAZWIDqyVzX+I7EnOdcQqmbYWwXfbc555QLAv6PmBmoC+hjd2WYILAoPkxbwlmwnvGlD4K12UU
 GfWlGtA/
 3JXVP8kqGk/3pjXYH2YOqa/xfUjkeBShZMPjkSgdd3lHTnB8mlER74M8fy/K2HTT2eYkmU3eDCIQGNz4XQwyervQnZhrYabJ4y8dRtzwAizTAYqTZIU+r7JVFtQB+VeEB2O9gLGOs5W3S7+/bJV3aHjU2GcE7B2FB/iS3tq5/GrkAPmXHVARIE/7JXDmzrxgeDpHDDYRsSHqLFTKBvVpkjllL2Czll1+PalqN/G+LxfyW2BU7WFO7VG62hj45ZzEB4juqijf1f72bpPQdg/qVe/BgDBKGjLG1/RQe4/f+n+z5wr2xFdlMyfEA1eocGwbi/v55VEawAopfcd7Yhhsqy9jNUxX9Y2yPDJqM2xfDEY94JJnmUuBqtHcLW7+ghOfR6uZHsoLhepSr5eXG3s+xsRnY6sOwpeQJKwr9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Wei,

On 2025/9/14 08:00, Wei Yang wrote:
> When using mm_slot in ksm/khugepaged, there is code snip like:
> 
> 	slot = mm_slot_lookup(mm_slots_hash, mm);
> 	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
> 	if (mm_slot && ..) {
> 	}
> 
> This is only valid when mm_slot is the first element of its wrapper
> structure, otherwise a NULL slot would converted to a mm_slot with
> negative value. And current code thinks it is valid and continue.
> 
> Current code works since mm_slot is the first element, but make sure it
> won't be disturbed.

Good catch! That's indeed quite brittle ;)

Just one nit below.

> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> ---
>   mm/khugepaged.c | 5 ++++-
>   mm/ksm.c        | 5 ++++-
>   2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index af5f5c80fe4e..668e74ad33b7 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -108,7 +108,7 @@ struct collapse_control {
>    * @slot: hash lookup from mm to mm_slot
>    */
>   struct khugepaged_mm_slot {
> -	struct mm_slot slot;
> +	struct mm_slot slot;	/* keep it the first element */
>   };
>   
>   /**
> @@ -2382,6 +2382,9 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>   	struct vm_area_struct *vma;
>   	int progress = 0;
>   
> +	BUILD_BUG_ON_MSG(mm_slot_entry(NULL, struct khugepaged_mm_slot, slot),
> +			"slot should be the first element");
> +

I wonder if this BUILD_BUG_ON_MSG() in khugepaged_scan_mm_slot() would
be better placed in khugepaged_init(), like you did in ksm_init()?

Cheers,
Lance

>   	VM_BUG_ON(!pages);
>   	lockdep_assert_held(&khugepaged_mm_lock);
>   	*result = SCAN_FAIL;
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 2ef29802a49b..0d486dbdf7d3 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -124,7 +124,7 @@ typedef u8 rmap_age_t;
>    * @rmap_list: head for this mm_slot's singly-linked list of rmap_items
>    */
>   struct ksm_mm_slot {
> -	struct mm_slot slot;
> +	struct mm_slot slot;	/* keep it the first element */
>   	struct ksm_rmap_item *rmap_list;
>   };
>   
> @@ -3842,6 +3842,9 @@ static int __init ksm_init(void)
>   	struct task_struct *ksm_thread;
>   	int err;
>   
> +	BUILD_BUG_ON_MSG(mm_slot_entry(NULL, struct ksm_mm_slot, slot),
> +			"slot should be the first element");
> +
>   	/* The correct value depends on page size and endianness */
>   	zero_checksum = calc_checksum(ZERO_PAGE(0));
>   	/* Default to false for backwards compatibility */


