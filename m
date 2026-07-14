Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13B56C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 06:54:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EC656B0005; Tue, 14 Jul 2026 02:54:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09DD16B0088; Tue, 14 Jul 2026 02:54:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECE6A6B008A; Tue, 14 Jul 2026 02:54:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C22426B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:54:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 52F7AA029D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:54:24 +0000 (UTC)
X-FDA: 84986468448.15.E07ACA5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 762FD20007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:54:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=U9B78wj6;
	spf=pass (imf31.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784012062;
	b=4NA0RnLykRnSrBiekIT0Ez5VvR3Hmif1ulIwmo9JLlft8nrTn3Tm4egHkGruvS2MT8dRFR
	lSZiBzD3ndTEbO66BSHMwqpJtozlUEkqz0Be3A5MBUdSuJL+dfQkCROehk7gA+NJSFaxrW
	JiOuqsyE4qvE4Fq+Z/0ZytkROgLTBf0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=U9B78wj6;
	spf=pass (imf31.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784012062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o4BB4hwwI/NO63lqdqTN4yLFeptjjVtn3BYVUokdEM4=;
	b=qdOnmikeCFmK2EJs0OLutwhYu4dQLTp+w0XgwBdTizO4m9eTh4hVWJTa4Axgn0+1lVPkIc
	LGno2s+nnX5wdfgCanMhUOitoNAkS9dy+5OjX4MpumAe+0cH5nHBCSP1wJLndQH/AyLV6c
	8dvY9OcC79JFKeKd1dGVVLxmp9qQC0A=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 22A571477;
	Mon, 13 Jul 2026 23:54:17 -0700 (PDT)
Received: from [10.174.43.51] (unknown [10.174.43.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2C74A3F7B4;
	Mon, 13 Jul 2026 23:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784012061; bh=in4ByyebPfi3733abQ4MFG3t3pXhYQ74bHn20MaCl14=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=U9B78wj6W/NS4Oma+YkQO132UMhYDvp3jnpulHZsE9DTZHXSrHRmg24/qJTamec1V
	 UZR4BXyKuMC+1huPYshYfSBS6XkvHzvkGmxYd9kGDKcVGq2I5DyArZHpu3UUZZoaby
	 Cf5vrBTOV1clKaI6jS04gJMWblJxF9Sg6G9ZnFAU=
Message-ID: <4b3c1d3f-853d-46dc-bb15-37273fb07f61@arm.com>
Date: Tue, 14 Jul 2026 12:24:09 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/6] arm64/hugetlb: Extend batching of multiple
 CONT_PTE in a single PTE setup
To: Wen Jiang <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com,
 will@kernel.org
Cc: Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, david@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 rppt@kernel.org, ryan.roberts@arm.com, dev.jain@arm.com,
 "Barry Song (Xiaomi)" <baohua@kernel.org>, Wen Jiang <jiangwen6@xiaomi.com>,
 Leo Yan <leo.yan@arm.com>
References: <20260709073823.6643-1-jiangwen6@xiaomi.com>
 <20260709073823.6643-2-jiangwen6@xiaomi.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260709073823.6643-2-jiangwen6@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 762FD20007
X-Stat-Signature: irrdeicmwafsm6w45q79rxs1gmgtix8x
X-HE-Tag: 1784012062-919385
X-HE-Meta: U2FsdGVkX1+wIqnItcqX0ol6f1ewZz5EkxxWbgYbebogO1jCVEfQmpoRaDPg4NCV2eFT9zTxtJmqBVETgckseS3QGxdg8WNRyRH0Jd86SxoFieNcb0XphJ8wH6p2pAJbO5C/5pWua9CEGtKXkLa3QQff7zCmdK0VPMzDynYow/RIAe8hRAOBRJy3fKMwfiXyMzjCWplY+qzW1GwNEmUir6mQJqr/VZGfR1ZCsYZsSAYs8AttZo+49Re/oOpdH+Jj2LlPYtqaWF0eq8WWDtu5z9JVOMq3elQ01F32QT/kRbJBEAYm7ayCdQXln5tkfxHjfvDhmwysNzDNdiaXgqUz6usiqVQj5ARtGrs9LlTO9mmsNp+osZY4qt13KZPsGCAwhyubyv27g4OhlPlPZVNPR7+GyIpjIyAoeIv60F+VdmvDKzeMzjhK+Jkd+8oI/IbHpBj2DGOpPDfHxDDnxIrkFoN74fHhhR1+H5a+jT5v7P1g9R8pUzdNdS7xNRAJ329S1zpGSRGwo9W08NJl6qExoggWfI47rkSIwfktInOgnUzAbYdv+MtrJJ1H/C8uyS+fiwlaxZWTRMfKfDpqjN3as7VatN+RwtTwCCXSo5azRZeqCWDvicbU0P5+bBoSxk0/BDG9KzHeqC42s61LOkte0ypswSXJV+WzxPu6w94TsprhIRajw7L5lSiuH9+qSC5APaZbjhrYA7fgHRoHFp7z1Che/sVob9Msqd4uJFhkd2E4RqArc8w7k2EfCECz+tk5ct8pSYrBrvhHzzvRzm6K9uJpVAJ1cmFyV8j0bmFhVWKwrGyQZtwu7c1qlwwwp6GNIkNNYPOzCmkcEHn/uHPoG6EdFHNz72LAn8wgfX/BzcS9evTtj0gntn1x90rlolitxZSw57ZYJQVfH/i2wVmTZG5aqhywfF1XzMC1s+PuppnLcrbNnqBp6+pAcoVD/mOaOak9Ia/vBzkwdRKQnxV
 9KUUeN27
 E/6t8+nL4j5zzQimB4sBRtW1tJ3aRWd4I2hGCsrJ0ziTH2/psoSIkBh/m9OjQMC/Vgu5i6D+95Y2lptkU8Eu9Dqf9ec5FG3t/2cfcGxnG48vxqO472rfyeKkf5c/xXJ3sEf9V34by3mSGtFmDTh0+FBvYliM+SGUPo/Ejz0Nc7DFbceyB9HC0576ZQP1kI6D37PoAUF95VE9iWnBMVNfi3GSCTDZWmMMhIdBcL1r5iBA60gWeHeiKllEFHXVyXWQLLCVZmdJ5GuWsjn93pYUhpyTzPftuJV9AW9l8KCkvhYZhXw1oqo9LRpllHuvLNqIcQisgXVgfwYUfsIAXQTd6DJFNdXSlDVgCMu1mADUgejSXFbKsaGTj5ROAsv098QNR7huJHQTUBv0acaM2UM1X+Yd596YfSH9XgDAHuAO91mc7UDMeHG4jsSDmHbLQCM0h6GnPV305Njp0Gz9lJVccjM01hS0dtsb99rPyQkHRKiG00fM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/07/26 1:08 PM, Wen Jiang wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> For sizes aligned to CONT_PTE_SIZE and smaller than PMD_SIZE,
> we can handle CONT_PTE_SIZE groups together.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Tested-by: Leo Yan <leo.yan@arm.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> ---
>  arch/arm64/mm/hugetlbpage.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> index a42c05cf56408..0da746f729388 100644
> --- a/arch/arm64/mm/hugetlbpage.c
> +++ b/arch/arm64/mm/hugetlbpage.c
> @@ -110,6 +110,12 @@ static inline int num_contig_ptes(unsigned long size, size_t *pgsize)
>  		contig_ptes = CONT_PTES;
>  		break;
>  	default:
> +		if (size > 0 && size < PMD_SIZE &&

Is there a possibility for size <= 0 ? If not then
the above conditional check might be redundant.
> +				IS_ALIGNED(size, CONT_PTE_SIZE)) {
> +			*pgsize = PAGE_SIZE;
> +			contig_ptes = size >> PAGE_SHIFT;
> +			break;
> +		}
>  		WARN_ON(!__hugetlb_valid_size(size));

Would not these CONT_PTE_SIZE aligned sizes upto PMD_SIZE
trigger warning here because __hugetlb_valid_size() still
does not enumerate them ?
>  	}
>  
> @@ -359,6 +365,10 @@ pte_t arch_make_huge_pte(pte_t entry, unsigned int shift, vm_flags_t flags)
>  	case CONT_PTE_SIZE:
>  		return pte_mkcont(entry);
>  	default:
> +		if (pagesize > 0 && pagesize < PMD_SIZE &&
> +				IS_ALIGNED(pagesize, CONT_PTE_SIZE))
> +			return pte_mkcont(entry);
> +
>  		break;
>  	}
>  	pr_warn("%s: unrecognized huge page size 0x%lx\n",


