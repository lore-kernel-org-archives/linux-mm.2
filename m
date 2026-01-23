Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF5B4D6CFD1
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 12:40:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E389B6B04C1; Fri, 23 Jan 2026 07:40:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0FAF6B04C2; Fri, 23 Jan 2026 07:40:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3BB36B04C3; Fri, 23 Jan 2026 07:40:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C00556B04C1
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 07:40:27 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6F0B11401F4
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 12:40:27 +0000 (UTC)
X-FDA: 84363186894.05.60E52D8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3C01840004
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 12:40:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769172025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GvyDQVfebXTqvzhLRVCV59E+qvKH3Kw+2l7LBCggEyw=;
	b=LZ8USZVMtfy+S3h/VmNfpY66KOHlEdCxiYDfKdEZ3QrK1lA7DPBgwxLovglZzSBie6xKTH
	GvHe49FRz2ErHK9YtSj2IC5TnZP1J+vzBkZDkm3KIQjqm4Fd7/zuhA3AEpmzjEbBk2azu+
	zQAEi/ecYtKrjvIjL7Ti7qVbs7nxbRg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769172025; a=rsa-sha256;
	cv=none;
	b=XJGL0Mhnob17zbf5IXOO3AtQDrLgRmx2fhmsyrZ+TPBwwhzoWHpacbvc6FcBVr9ESQCFCW
	aD9sIRkOjCeda/eTNtQKftDisjGLFpGFofieCqryk9m/UHdjXFfgTYWgZQSkXhSQ+QmW+J
	sJUqbO+1AxiQTqra90PSRz3l8lkCpeg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AD72D1476;
	Fri, 23 Jan 2026 04:40:17 -0800 (PST)
Received: from [10.164.136.38] (unknown [10.164.136.38])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F3D8C3F740;
	Fri, 23 Jan 2026 04:40:20 -0800 (PST)
Message-ID: <626132d6-360d-4655-804c-f36220b6f669@arm.com>
Date: Fri, 23 Jan 2026 18:10:11 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v5 5/5] mm: khugepaged: set to next mm direct when
 mm has MMF_DISABLE_THP_COMPLETELY
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20260123082232.16413-1-vernon2gm@gmail.com>
 <20260123082232.16413-6-vernon2gm@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260123082232.16413-6-vernon2gm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Stat-Signature: gaj76n445w4yxzzocc3e1oqqzcuzyzf4
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C01840004
X-HE-Tag: 1769172025-86763
X-HE-Meta: U2FsdGVkX18BSiXDBQ8eaTaTL95+gUARvugPvvzpkYUJko/QWlv/HyXbtdEWnctRur2sulVZJT24WABi7AB8SllKJTSwqa90EbTODOH5lDB4/pfwdsPiDn6/6UaVMcJy7XGXCb1YLSYI6x2J4tCOWDc/CMoqNM89mYsTe4kUoWhwl3YlPyDNUm82gtXEB84ShMbWXxcFinmd4usgiyF5/ZNGcxXBlkxqG6ZxCnIW0R1K7SYti2nOq9KoE73mKkLNQYsJo96HkoWWqwUyprNd2IUGGUYPZpmJ8sl0eOUDcVYdIPLwiYfyd+GczrYJ7hrhSWxQc+bgxEb1DYj1g056X+M1rK78p8oj4jXqEGks1e7pW/udLR+wkyeYd/eibBsjAOQppDvSZq0HYnW9gjqb48q9fmCmVcMoJIialYKBtwPOWScnQAhfM1SxPMeAC3XhBGVayL5TYNiFOHpR+W5tembM39G3Mj8HF4+STeBfx2PlcU/Ii9O7rHxkCNtQ+9q4seGHTrY6kf7iuH+8DpLuUekgsYMxWcQEt+og6zUWb1HxcHvkgKrfbLgyL2olgeWc09wqiMvo4c/XOhmSPh0mv8vojcBs0wwTbiLjjmmPuc8q7SxUA3VVKKwqKVKf5zrk+QtmzsxzYUKLQivUp9dc/ZdA+HsfenuPhrucNbpjEswir7VkERwnjBGKRafekVposuvXXAC8Ph32x8pV7pfZmgBTDQfhjXW9Psa9IuiZGdUR7fYwEeWeS4qwy45epyrfdsQMOdqPcPRH7kX9N0NwtLeCT1bzlSPTyOHOATKrQiX35SNgvXfnjfwuIusZlBNHwOjH70vd24D0f3il2zeZODpH3gLSrrZmaIq098W8Z3cC2lx4h80HCgYcZyuDd/qpPj5KdJjeN25M8N5ZMkgV9UQn0yacMXtCg3AOQMcIJkxR8fGndN08AFXjDOCPDRMi0JVDirxxi8efVXq6cns
 VH56Vf3b
 6NzYKiN398RabeRYPUtVMuaxuP7bz3v3bKc6BOo3jc0LGiuyVSFttHKU4VPu/9QU809JG856IzDgywDBIRcPwYOLYSNeOaktl8JkTjfJbwCFWQvK3bgZO+Cnc4EnJfp+uPqC5k6mmXep16l4VFu1NWId14/6Ya438V8wqS3vxftOkzPahWa0mGHpjtx6Zm7qWrPk+4bUVNXmMcorMfgi8mXePZvRt5QUkihbNTIlImFW/6oLIMHp5GujPUsGEGwZdxB+5CEzF4q5XT8E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 23/01/26 1:52 pm, Vernon Yang wrote:
> From: Vernon Yang <yanglincheng@kylinos.cn>
>
> When an mm with the MMF_DISABLE_THP_COMPLETELY flag is detected during
> scanning, directly set khugepaged_scan.mm_slot to the next mm_slot,
> reduce redundant operation.
>
> Without this patch, entering khugepaged_scan_mm_slot() next time, we
> will set khugepaged_scan.mm_slot to the next mm_slot.
>
> With this patch, we will directly set khugepaged_scan.mm_slot to the
> next mm_slot.
>
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> ---
>  mm/khugepaged.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index be1c09842ea2..1dc19c1b1f97 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2558,7 +2558,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>  	 * Release the current mm_slot if this mm is about to die, or
>  	 * if we scanned all vmas of this mm.
>  	 */

Need to update comment: "...or THP got disabled".

Reviewed-by: Dev Jain <dev.jain@arm.com>

> -	if (hpage_collapse_test_exit(mm) || !vma) {
> +	if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
>  		/*
>  		 * Make sure that if mm_users is reaching zero while
>  		 * khugepaged runs here, khugepaged_exit will find

