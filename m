Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 544A2EF3716
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 08:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBD976B008A; Mon,  9 Mar 2026 04:23:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6B966B008C; Mon,  9 Mar 2026 04:23:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6E0F6B0092; Mon,  9 Mar 2026 04:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 930D96B008A
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 04:23:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 36E4FC4006
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:23:00 +0000 (UTC)
X-FDA: 84525834120.24.0794EF6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9FF2140008
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:22:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O3b92q7b;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773044578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P1lIZx7jxksyX/dRkyXna8WJ9zLTRrgGdsrdZAvKcRI=;
	b=xPAcDl70UmSWClZ0WJo2cYbhw30hmN12QTzwjXWcTQ+7OUINbl71rZLDpT9k0JjbfUGVpp
	yzFFbsqwPO+H+cEh2IicBo/KdOrI9l1sQwWNrrW0HB7GzSZ2n5YtojD7+FUIypOlbAH1qt
	K+T1smrjLjbsfRIHjFIhIpU7Vzpd/nM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O3b92q7b;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773044578; a=rsa-sha256;
	cv=none;
	b=FOrGDVqnP5m3K29lRkwBxp0AYN7uASUWDVxkXutEz3sjTZy8Ckw7uWhKmH6MEQ3bSRajz3
	y4THpfSYxVA3WVACRL+DJYts8cmyzQ3Ld5XQ4oeztQFJIeGlxbiyJJse1HpNROyDX6skXH
	dpJpweneGAlKKFb5T+xOCOKoPc4t9Dc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 18637600CB;
	Mon,  9 Mar 2026 08:22:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B623C4CEF7;
	Mon,  9 Mar 2026 08:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773044577;
	bh=V/B5tPmLCgAxbN8UIEDAM4TeuWOKraxmkgH51tGu4uw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O3b92q7bgFaOMmV3eGLdzebrY0/Sr+0bh6qjjVKefF860DvD1c1diA+xcCEQSmiek
	 bmvIjE53jg20sq2gBg+7p/LuokK09L0Giolq0uT/UOHHgc9MJtjIB3cMCqwPMGxlQ1
	 kX5mGd8TNaqCBYpqvuDW+pBSdtOiCO3aIlJ3gRxeTVW4PIsDnAMKzsytp0APqz3sWu
	 EKAYn6dGohnRiYx5K+hJUOYxUnxrL/rrDEhMnaLcIh50LQNGcc5aAZAKeUifPAWf5F
	 3ShdhuDfGkK99AG/vwbd1ulwOU2eX/UHbTTTevAfbcR3baUHGm7hpB+EXgW4vYHawr
	 pRWS78C/KKv8w==
Date: Mon, 9 Mar 2026 10:22:50 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	usamaarif642@gmail.com, SeongJae Park <sj@kernel.org>,
	kernel-team@meta.com
Subject: Re: [PATCH v7 4/6] kho: fix kho_in_debugfs_init() to handle non-FDT
 blobs
Message-ID: <aa6DWto0xY5EPyxK@kernel.org>
References: <20260306-kho-v7-0-404d14c188bb@debian.org>
 <20260306-kho-v7-4-404d14c188bb@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306-kho-v7-4-404d14c188bb@debian.org>
X-Rspamd-Queue-Id: 9FF2140008
X-Rspamd-Server: rspam07
X-Stat-Signature: 6xn71rtbi9spbyr6q4wprcjreguyud57
X-Rspam-User: 
X-HE-Tag: 1773044578-729080
X-HE-Meta: U2FsdGVkX18gISRDY9rUfJROKrHcQ13EHYGVRUxqNeJYbr0R8LZy3LfyqTFlSf9FqUVfJ+wHUmpcwuOU1NqZoi9mVIgQLetfKOGWXjFO4SRH+RUqtBfYunOCNQ34humJKi3lG7xIK5lgT04pwSUK0MIBh89Y7ou0fkPy3P31V1TAUvk6PKppjq8UKQuBYFzRd6wLS0P8GxnaCPci2hZYUiaFC+KBlYyk1BepBsvIQ8Fmqp5/HUcyasyxBr2BphCjBGrE1n8WT7eww1Od8+8utDykL7tURAuKYK3pa0KBJWs0vOwnJW4CazxGJT6PFpZ/PJ9rZRflsKfvrBYZQwSVu5d4wDbmrriDT2thKFtHPwI8HQ2sgG9V7ZPGDwLzfLMRcvJmzuDpm8CZbC9UwKXQZvvxuaFjbWuNS3vSZbwIQqAzSCdrSD3bA3HOxdHJos2bZ7UAw4XXaU9gKTtv0nJ11e+u+zuOuMPZ1SOIXknLbhledmCtfYHkDDrAx001T8HBW6M+V/piSxoPpYIMovNAcP0+yv2O/BAwxCuIp2ySWCzCBw7YrKt6c9CFFDBU4x6vDSTmq+X2Q6LtPBZZhKmj1No/hRJKru+vLROjAeNP537MzYkw66m4fWB88sF8YK0hp5m4xe3yvLybsant9WdC1XhOdGIn1ZMsKUb2Pt+LeHvboWYRzV53gSP/EcU2uSuZyUplDkI44qa/+1s5OWrHaycXZTBot0DW7a3xVPaHHSBLtfQMkhnGv2gfRK2D33hy76iB3rzfwFbYDwmXxDcxQgpuiQnsZEaIfgrMCh5t3rI06h+iz2CZynRws+T7QU8BPbb97n60E1Lg1tC+wtnDEGki5NdKSyHg4ws6c4j50RfCAvYLQ4fZjeMWdt2ucig0tv8u7WAwqv7sVKENL1S2SnamUFDxA8kC551jyaQX5DQKSovwV7nB9CEbKanTfSEpxDKjJQ2If25Kvb4QaT4
 wI4ApNkg
 9xlJC0wNxQKszoLt7OwRn6ZaI4ExM3+smWsUfCdQC88qoYH4fGkkawlFNzUXuMtzhm9kDVKiAukDFPOOQAxBNTi+u67hYK8pXdtH2h4TD7Bks41+4p+IIbKAEk738F6dZ6AYVIIs7w/jksy1ouY4kRw+UZRyLp7naGOOB/3zJAzda9rsfHuCRRqDgo6m9Y6n++O4mEcS5kmcsgGYU5jRP+oNiukF243rEA8YbmpctPsLSXPKvObKSZRnNRZwmsOR9/fQ/T9u05PvpEC2zx9dmBTxBl98O17vMVJ7Vt5SnExzOHhVQ3sVVFD94sJQ8DJyAPrIpS0ZeycFgG2EAok3PUUi4SYYTFL3MumvCPPilhCdU7nM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 04:39:23AM -0800, Breno Leitao wrote:
> kho_in_debugfs_init() has two problems when displaying incoming
> sub-blobs in debugfs:
> 
> 1. It uses the hardcoded property name "fdt" instead of
>    KHO_FDT_SUB_TREE_PROP_NAME ("preserved-data"), so it never finds
>    subtrees stored by the current kho_add_subtree().
> 
> 2. It calls fdt_totalsize() to determine blob sizes, which assumes
>    all blobs are FDTs. This breaks for non-FDT blobs like struct
>    kho_kexec_metadata.
> 
> Fix both issues by using KHO_FDT_SUB_TREE_PROP_NAME to find subtrees
> and reading the "blob-size" property from the FDT (persisted by
> kho_add_subtree()) instead of calling fdt_totalsize().
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  kernel/liveupdate/kexec_handover_debugfs.c | 38 ++++++++++++++++++++----------
>  1 file changed, 26 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
> index 7a100f2bf3947..fc2baa8b104fd 100644
> --- a/kernel/liveupdate/kexec_handover_debugfs.c
> +++ b/kernel/liveupdate/kexec_handover_debugfs.c
> @@ -13,6 +13,7 @@
>  #include <linux/io.h>
>  #include <linux/libfdt.h>
>  #include <linux/mm.h>
> +#include <linux/kho/abi/kexec_handover.h>
>  #include "kexec_handover_internal.h"
>  
>  static struct dentry *debugfs_root;
> @@ -121,23 +122,36 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
>  	fdt_for_each_subnode(child, fdt, 0) {
>  		int len = 0;
>  		const char *name = fdt_get_name(fdt, child, NULL);
> -		const u64 *fdt_phys;
> -		void *sub_fdt;
> -
> -		fdt_phys = fdt_getprop(fdt, child, "fdt", &len);
> -		if (!fdt_phys)
> +		const u64 *blob_phys;
> +		const u64 *blob_size;
> +		void *blob;
> +		size_t size;

Do we really need two size variables? Can't we just have u64 *size and pass
*size to __kho_debugfs_blob_add()?

> +
> +		blob_phys = fdt_getprop(fdt, child,
> +					KHO_FDT_SUB_TREE_PROP_NAME, &len);
> +		if (!blob_phys)
>  			continue;
> -		if (len != sizeof(*fdt_phys)) {
> -			pr_warn("node %s prop fdt has invalid length: %d\n",
> -				name, len);
> +		if (len != sizeof(*blob_phys)) {
> +			pr_warn("node %s prop %s has invalid length: %d\n",
> +				name, KHO_FDT_SUB_TREE_PROP_NAME, len);
>  			continue;
>  		}
> -		sub_fdt = phys_to_virt(*fdt_phys);
> +
> +		blob_size = fdt_getprop(fdt, child,
> +					KHO_FDT_SUB_TREE_SIZE_PROP_NAME, &len);
> +		if (!blob_size || len != sizeof(*blob_size)) {
> +			pr_warn("node %s missing or invalid %s property\n",
> +				name, KHO_FDT_SUB_TREE_SIZE_PROP_NAME);
> +			continue;
> +		}
> +		size = (size_t)*blob_size;
> +
> +		blob = phys_to_virt(*blob_phys);
>  		err = __kho_debugfs_blob_add(&dbg->fdt_list, sub_fdt_dir, name,
> -					     sub_fdt, fdt_totalsize(sub_fdt));
> +					     blob, size);
>  		if (err) {
> -			pr_warn("failed to add fdt %s to debugfs: %pe\n", name,
> -				ERR_PTR(err));
> +			pr_warn("failed to add blob %s to debugfs: %pe\n",
> +				name, ERR_PTR(err));
>  			continue;
>  		}
>  	}
> 
> -- 
> 2.47.3
> 
> 

-- 
Sincerely yours,
Mike.

