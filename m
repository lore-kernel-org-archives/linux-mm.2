Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F19ACD5BCF
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 07:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2472B6B0005; Tue, 26 May 2026 03:56:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F09C6B0088; Tue, 26 May 2026 03:56:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 106066B008A; Tue, 26 May 2026 03:56:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0352C6B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:56:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6C0001C1339
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:56:22 +0000 (UTC)
X-FDA: 84808813404.17.8B20A7E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 48344C000A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:56:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=f0E1fC40;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779782180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j2VWht/h5yGShBUEzS+HKCJP5W7VL9KNvGon0gQ1GqU=;
	b=58lCT1MOWHBkUje7sMU9hZhmvgcJzaJCbgfPw3plxhZPC/vJpskV6+idKGNqsa8fEoB6YA
	MAUt0oPZC3glsYKPpC+1yzegZyL7TbbcOdn/fTh7IsWZbtCgkMjQRol+CUoePSxVJ1XMBJ
	0ilMKkCDHEeytUk914y5NIMRA9dw1A4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=f0E1fC40;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779782180; a=rsa-sha256;
	cv=none;
	b=EPixagEuqmgm9c+Gyip+qi6rTzilLfHWylooMcnE+3ic70yybyg9mdfavG0Ahe8FfyjkEQ
	EjjKwQAA+wmQHMHvewv7pxTKjzM6bCNxuR+Qw4d3codxS4VByxjVRr7EoECtCa5tjpqPaZ
	PpxP/7QRFY+P9PJhQMY1+h50xBY0D5A=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1925216F3;
	Tue, 26 May 2026 00:56:14 -0700 (PDT)
Received: from [10.164.19.7] (unknown [10.164.19.7])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A39FB3F7B4;
	Tue, 26 May 2026 00:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779782179; bh=6hzmwGTSHEaB23fFB7ucXxNiSw0m1Yr4kYVhH9sPBlk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=f0E1fC40TQfywE5hwctAqYLLb+iyQKgjGBgeEyteNh1NRYKEPt6LHj3JW/6RtfygU
	 LWBQL3f2e4m8jNT4r1Wim6XN++G6bIO/VnmXWIhtR0zR0oKOLl5dp+MIK1crrGwiOh
	 A33o7d00SJobM3X00BTLuUcWl5uxeZu1Kdtg8vNc=
Message-ID: <cb0b4c9d-24d7-44b7-a4fc-a6ff5020111e@arm.com>
Date: Tue, 26 May 2026 13:26:10 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] arm64/hugetlb: Extend batching of multiple
 CONT_PTE in a single PTE setup
To: Wen Jiang <jiangwenxiaomi@gmail.com>, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
 will@kernel.org, akpm@linux-foundation.org, urezki@gmail.com
Cc: baohua@kernel.org, Xueyuan.chen21@gmail.com, rppt@kernel.org,
 david@kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com,
 ajd@linux.ibm.com, linux-kernel@vger.kernel.org, jiangwen6@xiaomi.com
References: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
 <20260522053146.83209-2-jiangwenxiaomi@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260522053146.83209-2-jiangwenxiaomi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 48344C000A
X-Stat-Signature: ay6f5du9mjypa776pqs7z6m7cmdx5mrp
X-HE-Tag: 1779782180-253854
X-HE-Meta: U2FsdGVkX1+K2dufbFD4mduLcES2MHXt9aVGymG7dU4ou/CDbd3aoy3Y5+hJH2uAVlPaPB7VSVadsYaxU9O2UK0/dYOoZ3dIBWwrVh0jiwc9lgdf+byl5GwTRnzcdYj6PwCeXsCc9QUKx/VZwn3pGqTWJr486RxHxFS8I0QxaOunYneeiGUJfCWmrsDmhji9BjKR82qr61MEGoTAzr82IaC9bQreCayReH9q4+N6H5u9SHwl0ZKEEvx1vYZBrXpjk6wTfxmgTf0odU1g4vvyAV3Sw6tzLYo+litJ6lPtf9cCc5bOYMYb+fj6RmjymLhWzKwWdieI+8MUbUrMDX1Gn8Z/59I1kDcgvErIpKXJDaThppr/eV9h8Oj/5GjkYr6zKyYRXwy5W2foRt0UzNcjoRTZXFt11BN2ecizUi8KAyGR6ZxtDUDYUv0cc/qQZCetB6P+3EKv3Jmmm/hP77BpTH/3xOGvY/sNQr9Fmoa/J2cgujqPuHBcZmkEgJCnhPOFmHKxo/nitJ3dlQAGLdCLy/6LnMvJtzlY/27RjF36MCFEfUNXQd/ChmRznlLHkjcJBHNbSzlBbXK0eetGmsROBVvPOvKAd2mPotdYIOU4QjL1nq6wC2OAjmk2Qu5SYPIton43es+8OgYrAzv48mbkQP1bGYgogCsLaJSi82QTTuQ0X+38+jDn99H2DkzegJvqMk0CeODtEnoP9QIx4ACmXTNk11DT3Q5J8XnVlqAtc1kF/0uE0T5FKCv0KoBnRa7sq0wyXyf34bhFVKYViO75Oky82ATwX6O3h8PyYMTq/a5wjbFucrbpFmUClj5KAIXU92d3NyqWOjLbdrxu4oUYokuLsedlq5lSE0FdJN1b8V8K8Cb3ohA/nwtkjByeDvo9Yd+IjsVTULUEiuxn2afMyhZSNMJcWQc2bk6hi0i4ykQgbQh/dd5C6wroBOqfpbYrFWhneUOUKu8n6jtkA1H
 QHLOL1bu
 rftU3TsfIFXufh9VNv1Y/jdSZtMZoIrbk/vnR7LSxIpKCc0nWCrJ+xlkjWJD/CTUlBoIOP3p5ZWud7iPUUw9OIc1X2KDEui8k/yCXKmHsXz9uKQNdSqB+z1BcceEX8sby+atPu9Tq8EBncIAi2ebKgVPv6pgUEWs+vcNv4LvtB6z5sm2u6wF49VwbrmavweYKuCPqDZagqmpoT4vOiNtp1UmmanjkjZl8z/DSY++r2CAFLArvVZ/RC2sYSOxDqmQyn5K2AKK47XSEMWjoaRWX8+EH1nz4spb4BNqvRewofoZDC5NzwJ7Yq1/Nmis0eUvzsp0RVU0l2x3P3Cnl+uJXe+OP4kCAi8Q+iaHzRk5Cy3BUuVmbkGdR7RdVKZ+Zcn7+7mjmLuQ5tO5Mrln8LM1u26OBWiQ2RVetWDxHwsLbiwqD8ZA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 22/05/26 11:01 am, Wen Jiang wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> For sizes aligned to CONT_PTE_SIZE and smaller than PMD_SIZE,
> we can batch CONT_PTE settings instead of handling them individually.

Better wording: "we can handle CONT_PTE_SIZE groups together"

> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  arch/arm64/mm/hugetlbpage.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> index a42c05cf56408..c4d8b226126cb 100644
> --- a/arch/arm64/mm/hugetlbpage.c
> +++ b/arch/arm64/mm/hugetlbpage.c
> @@ -110,6 +110,12 @@ static inline int num_contig_ptes(unsigned long size, size_t *pgsize)
>  		contig_ptes = CONT_PTES;
>  		break;
>  	default:
> +		if (size > 0 && size < PMD_SIZE &&
> +				IS_ALIGNED(size, CONT_PTE_SIZE)) {
> +			contig_ptes = size >> PAGE_SHIFT;
> +			*pgsize = PAGE_SIZE;
> +			break;
> +		}
>  		WARN_ON(!__hugetlb_valid_size(size));
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


