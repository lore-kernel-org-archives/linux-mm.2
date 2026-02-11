Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 004B8EB5954
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 09:31:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56F676B0005; Wed, 11 Feb 2026 04:31:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51CE06B0089; Wed, 11 Feb 2026 04:31:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 449C66B008A; Wed, 11 Feb 2026 04:31:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 314906B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 04:31:52 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C4EBC58388
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:31:51 +0000 (UTC)
X-FDA: 84431658822.30.3E0473A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 25127140003
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:31:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JtJyX6PO;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770802310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rU1KAvAo1H7MiW39m0oU47bA0IRaQrNpi750xrEsxDc=;
	b=c2JyW1mVB4XW5er0y/tmxWrHXf6i3WideGEw/pWXB6q01EhlRAIUOAts95GKM4pQXW+ygv
	AY+xljmb5oX1JfUbataHnfEouhhbP3s0c/DO9fjTPSfJ0C9IOaKTA26oQSUA7mzXzhOgRo
	YMWOAqDG9gfG810lsk9/PqaP6LxvxhQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JtJyX6PO;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770802310; a=rsa-sha256;
	cv=none;
	b=HHYYb2mPf0aGWuqOGhjGEsZyKzlFQZQK+kzsQ6B/d+TpvYHx06VCMVUrBmq9a2W9dJvbch
	C/oEhevBSFC+RHA4mpVWAQHKqRpsmjJ52JcD0+XTjaW5xXsl0Hnp9NPvrgFpvGqExX9ztU
	MqYncqkS1Qi8REXu7XKgjDQqyRQWqeI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3912D43801;
	Wed, 11 Feb 2026 09:31:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E968C4CEF7;
	Wed, 11 Feb 2026 09:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770802309;
	bh=BohRPRiY3VE+/X8kSB1tjVdVbZoLXjZP2UZzgT4RPtI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=JtJyX6PORi1H5S7yfts2K92qjyIudjo1Q8JLoaiC3KIOs/Cqwib4Ng76J9VdM4rxA
	 gC6DO/zlY3MQSnfUzi/7+2hiKjgfBB3y4mbOjnhKCxWfNlXSzC4Sm3RxD53i+vmKiM
	 KbqMYkulTmZnk8Oj1FrYCeHF2SY6CX6Swi+puBCFg2j4BUc3IRS9+ZzSxeFBRv9t0T
	 Ddzn/n9qOjY1ygk9t0kKLVfLbAbB8wblHYEIIgtacr7pSTrXq3UE7UizWu7qMgo+F3
	 tRH4j1AWvVvzFt+DkxR4WchbuX/UMm0qdupf3bKFNHY8ZziRGgBMxkKZA1CAP8Ou3r
	 ta1sEcm3fEBsQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: ranxiaokai627@163.com
Cc: graf@amazon.com,  rppt@kernel.org,  pasha.tatashin@soleen.com,
  pratyush@kernel.org,  akpm@linux-foundation.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  ran.xiaokai@zte.com.cn
Subject: Re: [PATCH v2 1/2] kho: fix missing early_memunmap() call in
 kho_populate()
In-Reply-To: <20260211032937.208353-2-ranxiaokai627@163.com> (ranxiaokai's
	message of "Wed, 11 Feb 2026 03:29:36 +0000")
References: <20260211032937.208353-1-ranxiaokai627@163.com>
	<20260211032937.208353-2-ranxiaokai627@163.com>
Date: Wed, 11 Feb 2026 10:31:45 +0100
Message-ID: <2vxzy0kzr5ha.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: nd3g7a3gmawpfymp9jyjsaxmx6iacr8t
X-Rspamd-Queue-Id: 25127140003
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770802309-670277
X-HE-Meta: U2FsdGVkX1/yy29ZXSmM+jD8KL91oSsTnPFTrqODsQpYhXcUsZsXdzS4Dft2IwUBvCAJF0M7stHLKnHDhRBKVCg+7OJ4geF2pjcHtFKH7pyZ1glZRRZvN0kL/nRq1Ea4F8od7IGKhoSzpFWPskQxRHZ6SHoDULG7DtglBtr1vFdrWDSHyvrPSELHl3kYyeVSXbv1L7VXgknutsODguPzJJTk/GDbWjBgtALttd6IrC1mJFFqupbIWZMudFCMWbl2VVZnPvEBp3FtM1k52ELgNQU+VeX7dLhi7md0jW+FEzX53vgBbEfWurSN1hkbxsbj/M9N7FCNtY2ZXGWXifTTNMjICpMiRkmNb5G0HXzIGNZ/MSgJEuck8iSugzfCO4gSBbBidufKCrXgt80i38fBpoChuLHezTBYE+wp9oNbikuewLRzfXOaJSuIJWP2yNc4ymmPZVPV7VvptsYrc/qVONKNkOn2nIKE4UViVw5vmYRAUKx4XZM/Rv/vNn3T/zFp2deyggj1aEuYC+VbrGJ0y6/q9oI0XJAfv4AyV2WM2iB2TEh3Fs8CHyy063AlStSV5xtJWOCKqkCGGSIMI3q5NsYhInOYqoXgqrofHNIVYqGr22aYahaWYRfMFR90YwtRxNY+ituE+AryUkGKDDYWlk64H61C+FcDsheRCSbPYbuxAUvQhX0awZts6wG+1H4va1RmbVGiYeaZh67FqFtAiHByZOjccFBC8xNNF4LyUkKDfJqOkKf4F5OA96jYNO0BMTXIsT6X5eoni3BSZzymBmwkML1TScildXOKLhN+9eKqVHhMyvvamMLqFORzwM6BqIHI2c+LkG/sHdn9r0G9a/90IMPDO0bhrIUdqLJmHg8mmk6kLhLaTe/6Cwtfz8Pvg+qTzgpp96rrOCfygoa+eOF4MxYUW5mddtHsqjbjOzwJDQMclyo/P+MGFSspEO6nKm/0ThBi98IsqQKFHuH
 inhHjNT1
 ABUNDpZDDFlu3jFPVOpb8nx9x1xmT/UNYAK4bFu7FU5dKA2M13J5zeX1r6f9mSzYmXHeOLJD05OJ0NZOH2SHzexy6q2T/cJjEulB4rhTWQ6/WrPbo+TovGrpGZuw9Bz+KS4XdTF4OUDatvFUn/O935K906Lh4nJkh1qg6hAS75AuWbWTPUmc0l+TZQOvGCsLZcxQlv99f3iIMcELNWKngIV+8VTTVnMwv3JjJkRNNEf2xAFbWA/kPqcrqqQR7PZvcYoJoFRPeUp5DTkfpL99o0shRvPjveuafkMVI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ran,

On Wed, Feb 11 2026, ranxiaokai627@163.com wrote:

> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>
> kho_populate() returns without calling early_memunmap() on success
> path, this will cause early ioremap virtual address space leak.
>
> Fixes: b50634c5e84a ("kho: cleanup error handling in kho_populate()")
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> ---
>  kernel/liveupdate/kexec_handover.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index fb3a7b67676e..3c705b08a489 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1463,13 +1463,14 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>  	struct kho_scratch *scratch = NULL;
>  	phys_addr_t mem_map_phys;
>  	void *fdt = NULL;
> +	bool populated = false;
>  	int err;
>  
>  	/* Validate the input FDT */
>  	fdt = early_memremap(fdt_phys, fdt_len);
>  	if (!fdt) {
>  		pr_warn("setup: failed to memremap FDT (0x%llx)\n", fdt_phys);
> -		goto err_report;
> +		goto report;
>  	}
>  	err = fdt_check_header(fdt);
>  	if (err) {
> @@ -1529,16 +1530,17 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>  	kho_in.scratch_phys = scratch_phys;
>  	kho_in.mem_map_phys = mem_map_phys;
>  	kho_scratch_cnt = scratch_cnt;
> -	pr_info("found kexec handover data.\n");
>  
> -	return;
> +	populated = true;
> +	pr_info("found kexec handover data.\n");
>  
>  err_unmap_scratch:
>  	early_memunmap(scratch, scratch_len);
>  err_unmap_fdt:
>  	early_memunmap(fdt, fdt_len);

I meant to say all these labels should be renamed, not just err_report.
So "err_unmap_scratch" should be "unmap_scratch", and "err_unmap_fdt"
should be "unmap_fdt".

> -err_report:
> -	pr_warn("disabling KHO revival\n");
> +report:
> +	if (!populated)
> +		pr_warn("disabling KHO revival\n");
>  }
>  
>  /* Helper functions for kexec_file_load */

-- 
Regards,
Pratyush Yadav

