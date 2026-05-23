Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5A3DCD5BB1
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 07:53:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC9D56B0005; Sat, 23 May 2026 03:53:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9FEF6B0096; Sat, 23 May 2026 03:53:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB5B96B0098; Sat, 23 May 2026 03:53:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C61206B0005
	for <linux-mm@kvack.org>; Sat, 23 May 2026 03:53:20 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 53A4D1407AD
	for <linux-mm@kvack.org>; Sat, 23 May 2026 07:53:20 +0000 (UTC)
X-FDA: 84797919360.05.F96E2E3
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id 706CA80002
	for <linux-mm@kvack.org>; Sat, 23 May 2026 07:53:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B8fmTG0M;
	spf=pass (imf30.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779522798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zd0pyH4JyTVrhWiF/m1kbVJHvnAmP0kTBiQpkGCTOkE=;
	b=D22kuj1ebGVF7sgdzcGMBWJA63x/Gx2ql9UA3SBPLPRmQJ7YFYdilytomLi7cE270hNJ4e
	rgPxhEJBjnTvj/LmdVPUVNjf6eUpu2zLWplrfP2FLS8gaXffeQQ4IEBDeRG97urqkb5o+z
	WkoqKgTpMPZU7NrqsczRHWnyrIzwh7I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B8fmTG0M;
	spf=pass (imf30.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779522798; a=rsa-sha256;
	cv=none;
	b=IoI+8gTjws9pT3E6XQOkSjd5x4JGxho1IkKpJ3dN+cve3FcYQWZDXb6QCc/k1IhZ3TcGcC
	pXYBkrEW2TynpBSQpq7EhrFOTtx9Gc2D54j3KRIOXhO4Mwq4JkYRG8+AiLUF61P8cJO9Qg
	2iy2CJu34Pz+elrnNVZKMp7Bqsfy8zo=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5a88de2b52eso10617363e87.2
        for <linux-mm@kvack.org>; Sat, 23 May 2026 00:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779522796; x=1780127596; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zd0pyH4JyTVrhWiF/m1kbVJHvnAmP0kTBiQpkGCTOkE=;
        b=B8fmTG0McHvQkX/Oku6kYP09wH0hOk85uHRrNVC+Vk3WsBYnildqDGQiA0YLekvrcZ
         eqsNGbj/vI65YDLlIypYo8utzjQZAaGszeMdPLuGZ6RTMoT9ak3oYo3dBI5p+OLokRkQ
         qK6mmFyz8Y8KbxcoaC0qXbvleD9jaei3RzO+RHjAFCfzOX1ThXwAJVS4KEJVp5PLwJ+R
         LOJ9UtY91k1BPIeY4GHqd9dHDZfAbRdau0cGKoenG2QVYT/bC2x5NYsiS22nG0HD8KTi
         nwVai5Rorlzuik39H39YjtK41cGCy/SfFY2xudpls1zqmHaXKeoSj4F5ZoK24rsCDNRm
         74Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779522796; x=1780127596;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zd0pyH4JyTVrhWiF/m1kbVJHvnAmP0kTBiQpkGCTOkE=;
        b=p+GcfWlEIH8FwM+Bbs91b7ySILf0QkeHOpAcvE3IQbjVIo+/C0EF+IlqqSrqmJpA1b
         5HrcINn2XrNjBY67viodc3j07RbOt0HMNwQqhIkS/kGY2y+oRsetFyUol0kuWWg3aO5s
         l6kEasYUk5KbVNnxxEpUgq5XBWQw6QE4tJ+V0fZXDPWyx0YyKLwNPsoD4zXus3Vuhcyr
         X3/9v87Qp4NHEjMgB/zCCHVRF91jR+MSSAX41rMKWs7FO0Eix/KC5WxKB40APBtHBwUX
         t/4mnrofizVXNw4rX3N8tM9KTWxZpAE3ckhW2L6182Nj2nPGR7NWROnUSpkeFKdk/VoU
         +k7w==
X-Gm-Message-State: AOJu0YxjFJ69uZ8uf5/bFrvR7QvK8rejDdciS/u0d8pISE+damanej8m
	Eo4U15Ln8CqyZpAWwrimtacvQs5rmc00+a1pUJchoajq75E1JbM9M7bN
X-Gm-Gg: Acq92OEsRC7sBiTMiDmeQUMnmOo1LiYyEPXNX1iaYS9N8e8JfOvo3wdYa6A1d4QzvIs
	21bbguf/q1ZL2pUvGsyH90UtiU20dF/XS/yTqGYSE+6JD7b2Q9f9pshZOyIyXXOr2ZNULFSzFGJ
	i4/jsz1vi1ZhdjQmHjoPE6Z1hOfWX8YbQ9zPAcIZRrz0rukehdipyw6XtPAnahpv8hE/aQtLF30
	rNJvZP2/cALuZmzdw1zLVV/1inw9guiTp74bQhNzvk+I7GtNz3guqFqMW4o0gSZpYOLMOvG52xC
	57/aNDGFIqzaePkLh/RjR1AV4h5mTdDrzGRFYvKw1fkG6ujxO8JMI+u1NhzF7jbxAAnDzb6p+pk
	orhHs/gzgozJpdLxpk4IZsaFFGiiTkzfhh9fBMG5eWsO3ZvncB7lXM7piKrb5Nm+C/ITozwpdij
	VDDecR/AxzJyZObnmvhMY8J9Aox0+SM27zBRD6QE+6/apuYDqYo2tSDgZ4er+x/Q==
X-Received: by 2002:ac2:4312:0:b0:5a8:a754:4b57 with SMTP id 2adb3069b0e04-5aa323b28e6mr1722088e87.41.1779522796191;
        Sat, 23 May 2026 00:53:16 -0700 (PDT)
Received: from pc636 (host-90-238-28-226.mobileonline.telia.com. [90.238.28.226])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aa32cb37a7sm981873e87.2.2026.05.23.00.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 00:53:15 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Sat, 23 May 2026 09:53:12 +0200
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
	urezki@gmail.com, baohua@kernel.org, Xueyuan.chen21@gmail.com,
	dev.jain@arm.com, rppt@kernel.org, david@kernel.org,
	ryan.roberts@arm.com, anshuman.khandual@arm.com, ajd@linux.ibm.com,
	linux-kernel@vger.kernel.org, jiangwen6@xiaomi.com
Subject: Re: [PATCH v3 6/6] mm/vmalloc: align vm_area so vmap() can batch
 mappings
Message-ID: <ahFc6KfVIoI2w8Uu@pc636>
References: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
 <20260522053146.83209-7-jiangwenxiaomi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522053146.83209-7-jiangwenxiaomi@gmail.com>
X-Stat-Signature: fqafnihotwupxyb1bp9t5asbn67t8ja7
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 706CA80002
X-HE-Tag: 1779522798-582497
X-HE-Meta: U2FsdGVkX19u67sGI/4va7tvK9+nyTgjCRRA9ggAKhPcCJXdHQAwcvUOIbtY9fDxnfPeVeJD2vO2fSrLIt93BHqsz89VeUcJJMlkkxLCi6m4gi17BdyfYGINyn/w4EjzrFKIDPPJM+MSTdwTUBAnMf0dPdcjzUvmhYzTxXwPVbYSjCJ4OUo2E5Kkdwa/ezDfMkyI9S48w/Ff+FoLbC5yrqG6+kWUT9QHjRF+zJZZX0ZHOFZ4ZH1dYzxtHUHsPlovrld+qCugl1vexR60HD/fTj73w1+SJrYkLa5Yw/9C/morKH7bXrjXMfVKyVee/hV5pPZkF0ZrJgtSoxlMih2+ZyeXA5XRFt3uA69BvbPfIlp7+m3kkk2xvnE/Q5th/pPZEHPNW6jBBnXwcgDVA2GrRKBkvUyZDouvq5CpAQTKpOwZ0X1+Ywez1PofI34zQANhWGI7uRVOq5YmPuigoIMcG8dzJrlyZ0XLpEbRxccXHDHAbPzGl/RO9CEA+7sulKwjFFXE5xgKfmNQeXvvCTCZIP2QoSKXhg5R0soyQWl8/sG4QFfkVU8gHEVDf81bX+w86Lk/JKLq9vK7x9KFCEC0EBiD3ZSMiCnmD3WUkMKGK1XSSec9cL4a0WjxjM0LkaC6uxuYeptdPkRvjzBDStTKIr4uSpD/y6AFUbg6rUBUIFB1iTA+M1pfVLqc98YWJHCdXMsvcl2dJDZiBnPgo3CO7K1IRBKSE1SBHXuhlTFTxP5MrN1KEhd8yRXDmlF4xqSSAmZ+y8y/hcdz4BlAqHYEeO7u2jZB8RLdM8E/6URCUjz5bfO4gZdVNNqwTuhV8S00Us6SXelNvX1HkeDEomgAqbBs+TYgfkhs44qEX7jibIbF1c4rNd4EgBlNGNFHOl8fkEMsgCVVf+ij5vpGrhFjXnIMvJHZDorZruL7Z+7lsj1LPIXmYRpwcYiIgdrDfYAWj2fAPdHA0J5FOLuShci
 GWFKGYrt
 KCKsVQM15tZSZPcs3sA+7fa9AqZ68Azqo21/6BdbK8iCK6zHJFfK4PBv9wKHY+Lsj0YK9tK+UVhSQEDZ/mcoHdLr7VxZQ0+8VebbDpY7Z5+phEQgHiFvoOX/RtSB1tvgOS7WBhrsM3I60I3seqe6Arxyq8OtCl4RwyxTISuVyq7Mkq7T07W6+mttiD2Y4G087TBjJiwDX8tU/KLOJS2cBIAex0F1+qWfBqoNJCCxZEHWDwH38wKaS6msLg9RWZqU0NC5nhj6Qh91QQYDwTaT+Y9qVuNoaB5leNADkNYQgkCZvyE1SRoxa4BONpupD3AdrtlX7qRPUajQ+BCMLabjCZc5AsJNRkU99X+NHo3jwqgK/tapjlN3epQTm/8bm0BRLR9+Jb37Rj8DgtCByOqgpsFsthZLGg00shAnZ1hdxY59qHOti6mlZu70syCtFg50XyE9NCQEXg7lRr/9drnoBw3MVrCU6xGreS3s3vbn1K3vBXU+Sopj33hTJbPNNV4PR2yPtphSTG9zpzCq0Akuxczcv3/oOMDDoswVgNXFuB5e1wQgbMmMAzJqgdvRNS6ynTA2uRQ73rqznY3tK1buCgQgiaO+jOKNmNWhwzrDviuoIRQYpVQMpis1RxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 01:31:46PM +0800, Wen Jiang wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> Try to align the vmap virtual address to PMD_SHIFT or a
> larger PTE mapping size hinted by the architecture, so
> contiguous pages can be batch-mapped when setting PMD or
> PTE entries.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  mm/vmalloc.c | 33 ++++++++++++++++++++++++++++++++-
>  1 file changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 50642246f4d40..040d400928aab 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3620,6 +3620,37 @@ static int vmap_batched(unsigned long addr, unsigned long end,
>  	return err;
>  }
>  
> +static struct vm_struct *get_aligned_vm_area(unsigned long size,
> +		unsigned long flags, const void *caller)
> +{
> +	struct vm_struct *vm_area;
> +	unsigned int shift;
> +
> +	/* Try PMD alignment for large sizes */
> +	if (size >= PMD_SIZE) {
> +		vm_area = __get_vm_area_node(size, PMD_SIZE, PAGE_SHIFT, flags,
> +				VMALLOC_START, VMALLOC_END,
> +				NUMA_NO_NODE, GFP_KERNEL, caller);
> +		if (vm_area)
> +			return vm_area;
> +	}
> +
> +	/* Try CONT_PTE alignment */
> +	shift = arch_vmap_pte_supported_shift(size);
> +	if (shift > PAGE_SHIFT) {
> +		vm_area = __get_vm_area_node(size, 1UL << shift, PAGE_SHIFT, flags,
> +				VMALLOC_START, VMALLOC_END,
> +				NUMA_NO_NODE, GFP_KERNEL, caller);
> +		if (vm_area)
> +			return vm_area;
> +	}
> +
> +	/* Fall back to page alignment */
> +	return __get_vm_area_node(size, PAGE_SIZE, PAGE_SHIFT, flags,
> +			VMALLOC_START, VMALLOC_END,
> +			NUMA_NO_NODE, GFP_KERNEL, caller);
> +}
> +
>  /**
>   * vmap - map an array of pages into virtually contiguous space
>   * @pages: array of page pointers
> @@ -3658,7 +3689,7 @@ void *vmap(struct page **pages, unsigned int count,
>  		return NULL;
>  
>  	size = (unsigned long)count << PAGE_SHIFT;
> -	area = get_vm_area_caller(size, flags, __builtin_return_address(0));
> +	area = get_aligned_vm_area(size, flags, __builtin_return_address(0));
>  	if (!area)
>  		return NULL;
>  
> -- 
> 2.34.1
> 
This one LGTM:

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

