Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FF27EB1048
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 10:36:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A02ED6B008A; Tue, 10 Mar 2026 06:36:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ACA76B008C; Tue, 10 Mar 2026 06:36:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DA486B0092; Tue, 10 Mar 2026 06:36:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7DCDD6B008A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 06:36:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 348788BAE0
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:36:50 +0000 (UTC)
X-FDA: 84529800180.24.BE4C4CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6829D80011
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:36:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="c4P/dioT";
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773139008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8MSL+w0v7oyItZmGWWs64QhONDOI35vXCXF222iDqVM=;
	b=4kY9SL0RCaRAZzzD1Yh528MBPOF9IZyioyX4rQDl+9iN2p2VN93sWVCQra8US9jPLICcWb
	53589kxYeqf7zgoEYLUoaDs8emIBqbwBf3KmLkZeiWoaAj3Ojj8WlGF3HTqd3B7t2uu1wF
	bepwvEiTKVhCHATe/O13Fps+GTu/NJg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773139008; a=rsa-sha256;
	cv=none;
	b=1qLtU6+u7JNPyQcMhtTu6j325Wmr+TPAOvR1vEqqMs2e/6sVBq/rZRg9D9AwYS8emVMS12
	1KR9oCbAIj8ilwbLsqDUeFX/e0zrUYSsGw5NpFd5mk6Vpiarocep6igi26sSa8o50PItVC
	hTE4v7XyUcsYmlOCAc1l0dCQaFYTjt4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="c4P/dioT";
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 50C8244393;
	Tue, 10 Mar 2026 10:36:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9FB4C19423;
	Tue, 10 Mar 2026 10:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773139007;
	bh=W9mAwkbLlYnKfeePBjebcYRdBnJ6E2MpSEq54ioYRzw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c4P/dioTx1zil8ozOzqhL6X/9iGKpOVhuU526quBqtwWSPwFQSEZoIJMVmJJUsOF5
	 nwKORBgb0pGbSD59iNFGvajMzeEB+l90b66z07ro+54oDBh7pDJRwjyM2jjW4fM4pO
	 xcrbr14WA961xY1LpW+mTGorEMhcXxAR0O15Tg8HHIiCiRG8dLKVGWu/HHvBcZENzO
	 hXNLQnxrOmRnWvmMOMFR0ufoj3F6tuAXdD9kMzpfuGtqhlfmHXyrwOwBlv9FFYu/7d
	 +22JF3UWxgN3RP3N9VaBWLPofEMoo6/DvR+oB87o/Sqvkiy5/LNe5KvzyURJyMqiFq
	 a8o+ZkcX6YwPg==
Date: Tue, 10 Mar 2026 12:36:40 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	usamaarif642@gmail.com, SeongJae Park <sj@kernel.org>,
	kernel-team@meta.com
Subject: Re: [PATCH v8 4/6] kho: fix kho_in_debugfs_init() to handle non-FDT
 blobs
Message-ID: <aa_0OESNkyp8V2eF@kernel.org>
References: <20260309-kho-v8-0-c3abcf4ac750@debian.org>
 <20260309-kho-v8-4-c3abcf4ac750@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309-kho-v8-4-c3abcf4ac750@debian.org>
X-Rspam-User: 
X-Stat-Signature: gaqhnnijwpkqs91hmt4qysxiytxuogxs
X-Rspamd-Queue-Id: 6829D80011
X-Rspamd-Server: rspam03
X-HE-Tag: 1773139008-855311
X-HE-Meta: U2FsdGVkX18XJZ31vZMlOxrHsx57/ZzjA6/uAqMrHKx43cYSecVYwn9TfYMEwh52T6C9uXBoa4bPPLdv28P0SWC/WDw3wBhJ1kq8JH+XI9Rxf39lDUE/pF0Y7FZjxOBVyr+W2BlE0K9XUgR29+APlGCwz2I3WtPIoexoJKWPpwLIvtezNlUaXLmUMsdC5vdwwWg8g2UcZiVZMvltUUfUCA6RX1qlIgHhlt3u9kIubD2PClM/Kfac14MRh+bMxcSsbbpz9ZE2wS22BnKI5ViZBcJ4pd0UGbTi0Ndk8XlMUCOpBHzw+Bxme/E+xZD2t2kpWmBEmxjmutKeNImhSlCpP37OQIzfbKx9CXXyLgDh1XjWlfIbJkJFGhcOVF8tO9//INeK16MdHwG44MH6Fuo21TMC7sYWtBqUJtlXvSWyjLfdEzmy47zkgyK5oD0oys1mexNsQXNb/ntVtmjNwm6nm9VpzQYhltqnnUnboRl5SzkKouftHCWYRTQsthKqrPhdGfztEnb94p1iaox0FMSg7JC9PdlF4T4XbajqHznav0cEiKRoMA+M6Nl7O+ohw50RJrZw5LxDGt0IfQZBHt0essGdufCnbeni/UKhImxhV8ZshDoWMCLPjJoIvPE9hl2RUkhb/KPYTFQrEydIzO/d1v5oELs5cYGcomcBUqFLHx3ZGQWdUbVH12T2YG9Yh4QPTwmnSN5Bs2bLmueJDF4iDrFh7hLY4179wmLMhMlf4NXF4Z8U1vWbzCKpx2ggC5g2Hf2QvMc+aT3OZvv293Eh/sTfBt0YZSwsPpTcDbqp0Qj0+O194poOw7ZKIHMNGXTb/w5BlWrNJ0c/n+leSa0UCH+874+BDKbrVRVoQRD72tK9EJtqFPBs2DsfKK8W9UFsUvBunuY/H0AATfoRu0uUDwj3/FQ7oIrx0O2nqUfjEhGUrvV1vZ5pEoOqfFYIfMMpYTVRzVV7mOkeDxnXg57
 5Nz861Ht
 oKSer9+vTsaBqTCeD/2Hx77qh7x6HR8f4chTHBj4j3YBkLcVL1nyP3WUUFsCZS9ZnTqOVZl/qzYAH3BQwbAggOALB6qcaYnKsBdMcvrEnsg33gEYK4uuMoPJ7UHA9+pb6wwIK1+xG41VAhnAbH1Uvs4T0jbsOo0nuXWo8s/o8yKevjpp7XF3aznlZ/gvf6JNauuo9xWeP3nU/VJ/14kAKj3Sru8j/cb7RUkO57G6HHUdVe0P+oSKCLTawEsBFQN3YQm2tc4sOlWAMa+FFQKwlboT8NmV+V+UyS4ASPEObR70qfQfBVSboj/XzVwkE7yJH2ktrSjs+oy+N//iyMae7JE9y6a9p+musSmug
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 06:41:47AM -0700, Breno Leitao wrote:
> kho_in_debugfs_init() has two problems when displaying incoming
> sub-blobs in debugfs:
> 
> 1. It uses the hardcoded property name "fdt" instead of
>    KHO_SUB_TREE_PROP_NAME ("preserved-data"), so it never finds
>    subtrees stored by the current kho_add_subtree().
> 
> 2. It calls fdt_totalsize() to determine blob sizes, which assumes
>    all blobs are FDTs. This breaks for non-FDT blobs like struct
>    kho_kexec_metadata.
> 
> Fix both issues by using KHO_SUB_TREE_PROP_NAME to find subtrees
> and reading the "blob-size" property from the FDT (persisted by
> kho_add_subtree()) instead of calling fdt_totalsize().
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/liveupdate/kexec_handover_debugfs.c | 34 ++++++++++++++++++++----------
>  1 file changed, 23 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
> index 7a100f2bf3947..257ee8a52be66 100644
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
> @@ -121,23 +122,34 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
>  	fdt_for_each_subnode(child, fdt, 0) {
>  		int len = 0;
>  		const char *name = fdt_get_name(fdt, child, NULL);
> -		const u64 *fdt_phys;
> -		void *sub_fdt;
> +		const u64 *blob_phys;
> +		const u64 *blob_size;
> +		void *blob;
>  
> -		fdt_phys = fdt_getprop(fdt, child, "fdt", &len);
> -		if (!fdt_phys)
> +		blob_phys = fdt_getprop(fdt, child,
> +					KHO_SUB_TREE_PROP_NAME, &len);
> +		if (!blob_phys)
>  			continue;
> -		if (len != sizeof(*fdt_phys)) {
> -			pr_warn("node %s prop fdt has invalid length: %d\n",
> -				name, len);
> +		if (len != sizeof(*blob_phys)) {
> +			pr_warn("node %s prop %s has invalid length: %d\n",
> +				name, KHO_SUB_TREE_PROP_NAME, len);
>  			continue;
>  		}
> -		sub_fdt = phys_to_virt(*fdt_phys);
> +
> +		blob_size = fdt_getprop(fdt, child,
> +					KHO_SUB_TREE_SIZE_PROP_NAME, &len);
> +		if (!blob_size || len != sizeof(*blob_size)) {
> +			pr_warn("node %s missing or invalid %s property\n",
> +				name, KHO_SUB_TREE_SIZE_PROP_NAME);
> +			continue;
> +		}
> +
> +		blob = phys_to_virt(*blob_phys);
>  		err = __kho_debugfs_blob_add(&dbg->fdt_list, sub_fdt_dir, name,
> -					     sub_fdt, fdt_totalsize(sub_fdt));
> +					     blob, *blob_size);
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

-- 
Sincerely yours,
Mike.

