Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 008C6C79F9E
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 20:08:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 681DF6B0088; Sun,  6 Sep 2026 16:08:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 632856B008A; Sun,  6 Sep 2026 16:08:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5491F6B008C; Sun,  6 Sep 2026 16:08:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B9266B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 16:08:02 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2CD721605F0
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 20:08:00 +0000 (UTC)
X-FDA: 85184423520.26.0372DE6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 92473140005
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 20:07:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RqoOuRgR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788725278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6dLtZ4diiABDwf70eKATggUD/DCfK2UIavuZ29uFn94=;
	b=BPgDGS95/2egYg6QXPF8YJnFi+M0TWdbDzwwnnNzkU/xT24RMlIqQPb8x75rbaF0mSCviy
	pVQH9ptwvKWw4OazFS4ObJiX6c2E7ZV953BKFm46Ezr+soVuBvSysQK8YxWVKU74xNXOeG
	N7CdJUpNZzFApRFGirNrb26Wvoggke0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788725278;
	b=kpaStM3JC/p24msNnIihIP+lmZvTULNEL9wB0d2Tb/kF8HlADIIaDe84Dp3q8I0/HR3TDq
	dWPXnS4vHiIAxDCNyTV1b6/+G11hNIGI93s3m+lD6evM8xz6NGIUsEl0ZdCVePa9F4G3bD
	UryHiH/3T1BgjNCXrxX11VPp+Q9Mu9w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RqoOuRgR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2325B601F9;
	Sun,  6 Sep 2026 20:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96AFA1F00A3A;
	Sun,  6 Sep 2026 20:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788725277;
	bh=6dLtZ4diiABDwf70eKATggUD/DCfK2UIavuZ29uFn94=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RqoOuRgRG1enfRI1D9SjcgS9tKVhnFREjkX+IlSFfMW3MsqNns+AWPlyPdeEKBY7e
	 uG2BwFv3LXCAunkIOcVcViIXknbGSpB/bAjMbYO+mF2ZGpYOTTsSbcswzh6Fk7Bspk
	 xoRdD8yV3EJZtO7zX2zPJxTGqrjmO5vXSbfXu6LB+CQU0sfi3Y3uUHxZppAMqYvAoR
	 5eXN/m+EszZdq0meyMub1OCprX5zkG3e4PePLPkwZ7ydRDpkCPRWlF/F33DUyD2oX9
	 OdIfAzYrAWfx2F44BxBIa/LZtftjfA4FnjPC4YITR6DlSoZQynoO34dyoQrkzp6mLU
	 e9LTmn9kZa7gA==
Date: Sun, 6 Sep 2026 23:07:49 +0300
From: Mike Rapoport <rppt@kernel.org>
To: George Guo <dongtai.guo@linux.dev>
Cc: pasha.tatashin@soleen.com, pratyush@kernel.org, graf@amazon.com,
	changyuanl@google.com, akpm@linux-foundation.org,
	chenhuacai@kernel.org, liukexin@kylinos.cn, guodongtai@kylinos.cn,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] liveupdate: kho: calculate per-node scratch sizes
 before allocation
Message-ID: <ap3IFd2FVvfKkHkV@kernel.org>
References: <20260904025101.9959-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904025101.9959-1-dongtai.guo@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 92473140005
X-Stat-Signature: y4ka4z9ksq1g8ig6uc1w5doidt7tzmz5
X-Rspam-User: 
X-HE-Tag: 1788725278-819364
X-HE-Meta: U2FsdGVkX18CAlwaEAqvQhTS0sNL0AQZd6gkLvqdO/7MZIjcFw9V+JHZTDAOoLk8CtK+02yexmKmN2IpIQ3psjUxwIJsEmnDjjSQfRcZslcXgoCkwb4KKejH2vEvekXFn8TihxkK16GF+QqZwFJnJXIR4b58Ej/oVbqBvuk0uRSwaY63lHcmZH0YHTCZp65wXjVfnyt71e4wZhtlkSX7PKxMUwBRcFnEENdNw5Hzx7ATeNIWVYJmCGGIyX1OByV2EHwhJk/4gVsVI1rvC8lAf00fBPXxKlfyV6pE+q/LJqMgJeObuYD2CAAz6zCt3Xzi424kuqZlspA8b2lBpm3Y+Jhjy1itE9RJ1koBdydkC4cyo4ijBf3PD641lMXv344jPTPEQy7J4nA6V0NhNY4Sn6QFyCF0RNeFDcBrYIrRAYP8c9BycrL8pDqw3ZgaP5to2pvG96SuZYLXyDBkL1VoHXgXdjlE8lzgHO16prQVc8QzOk745cj/E+UReqkCncj9YfwNqM4JxEi4BNfHAXuaH/t61rHWACDsg6zpKGudxOya1dLSdyuJCAQelzSiyT6e6khzyEz/CLW7Opaaq/XhqTGvlBGHvfUCfD3IaIH12TNRtOTi6oBh8Ltj5kpIm5bcYzMZ1hrxrALLWDENY16a6ViWk76Vl86eH0v6bsqCUi8kOaYOdLpf4zbHtaWsl+FQJCZ+L7iQuNgL6KH9BS8uudblqdk2in3/e53ujcMd+isZfoC3DCbdC0rc4Nwv6y/4JhKXwxO4GazTCKjo7bmg6DzoUhAAIrxGchku34iYDMiqQSAXhEEMN1/pSdg9vKeRzlrgmTg4CA50qeAt1YxJv8/kHTxGa5q2CD1dfUiobqi029uEU7o5PIbNM7OkEFmaY8Juu0C/R1tJcIY2+zgZ//HCMBHnFZvCFJfY46B0R4ubSoOd2QhgZ+omozd5QAkotehAuLRdmEEBwe9Ht4Q
 ZhY0hRjE
 iV0jSlkH8FGhjIku6laKwNh7H0AXMWn8EC2WlTQf4Ff1AI+2geJxG8agL955wqmvlvbTVaXNaZNX1BaMbzbAt9vJ9nYzMEGd/GaIWKzXvslYgz0F02vtBErvupG2HJdUoHzyEiblY0bh+hEvGq2Cv585eJua9DcCr6cfQUva6dS8Bbn/5/YoMDrufFEwA4UxwVKouvRSXeOxJGb4+StInlmcwk6sZeEFAAYKzZFq2zDv/cRvHVl0XvH9aW39tVjkK/tej3pGKixI5VIeDY3GyPqVge3XEMrMZCAQj7nO5+4CQw9AJyMAkUlV7T7rsAqUqGIXckjuGRmtW43z068gSTeeSzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi George,

On Fri, Sep 04, 2026 at 10:51:01AM +0800, George Guo wrote:
> From: George Guo <guodongtai@kylinos.cn>
> 
> The default percentage-based policy sizes scratch areas from the current
> kernel's MEMBLOCK_RSRV_KERN footprint. This is a reasonable heuristic for
> predicting the early memory demand of the next kernel.
> 
> scratch_size_update() calculates the lowmem and global sizes before either
> area is allocated. However, kho_reserve_scratch() calculates each per-node
> size only after allocating the lowmem and global areas. Since memblock
> allocations are marked MEMBLOCK_RSRV_KERN, the per-node calculation
> includes those newly allocated scratch areas and scales them again.
> 
> This feedback substantially inflates the per-node request. On a 1 GiB
> LoongArch QEMU guest, the relevant reservation baseline is about
> 98.45 MiB. With the default 200% scale and 32 MiB alignment, the old
> ordering allocates 224 MiB of lowmem scratch, then requests 672 MiB for
> node 0, for a total of 896 MiB. The node allocation fails and KHO is
> disabled. The same incorrect calculation is hidden on the tested 1 GiB
> x86 guest because its baseline is smaller and its memory map can satisfy
> the inflated request.
> 
> Calculate and save all per-node sizes in the scratch descriptors before
> reserving any scratch areas, then use the saved sizes during allocation.
> This keeps the percentage heuristic while preventing scratch memory from
> becoming input to the sizing of more scratch memory. On the LoongArch
> guest, the aligned total is reduced from 896 MiB to 448 MiB.
> 
> The KHO vmtest passes on 1 GiB LoongArch and x86 QEMU guests with this
> change.

This reads as LLM-generated text. Please add LLM attribution as per 

https://docs.kernel.org/process/coding-assistants.html#attribution
 
> Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
> Reported-by: Kexin Liu <liukexin@kylinos.cn>
> Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: George Guo <guodongtai@kylinos.cn>
> ---
>  kernel/liveupdate/kexec_handover.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 7c4d86daf86d..39f489a258d9 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -847,6 +847,17 @@ static void __init kho_reserve_scratch(void)
>  		goto err_disable_kho;
>  	}
>  
> +	/*
> +	 * Calculate the per-node sizes before reserving any scratch areas.
> +	 * memblock allocations are marked MEMBLOCK_RSRV_KERN, so calculating
> +	 * them later would count the lowmem and global scratch areas as kernel
> +	 * allocations and scale them again.
> +	 */
> +	i = 2;
> +	for_each_node_state(nid, N_MEMORY)
> +		kho_scratch[i++].size = scratch_size_node(nid);
> +	i = 0;

Ugh, this really does not look nice.
Can't we just calculated all the sizes first and than do the allocations?

> +
>  	/*
>  	 * reserve scratch area in low memory for lowmem allocations in the
>  	 * next kernel
> @@ -880,7 +891,7 @@ static void __init kho_reserve_scratch(void)
>  	 * memoryless nodes, as we can not allocate scratch areas there.
>  	 */
>  	for_each_node_state(nid, N_MEMORY) {
> -		size = scratch_size_node(nid);
> +		size = kho_scratch[i].size;
>  		addr = memblock_alloc_range_nid(size, SCRATCH_ALIGNMENT_BYTES,
>  						0, MEMBLOCK_ALLOC_ACCESSIBLE,
>  						nid, true);
> -- 
> 2.53.0
> 

-- 
Sincerely yours,
Mike.

