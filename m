Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48C8CCF9C40
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 16:17:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A347D6B002E; Thu, 20 Nov 2025 11:17:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BEE46B00A2; Thu, 20 Nov 2025 11:17:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ADC16B00AE; Thu, 20 Nov 2025 11:17:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 751E06B002E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 11:17:34 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2DD021A020A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 16:17:34 +0000 (UTC)
X-FDA: 84131490828.04.EBD3738
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 886E0C0005
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 16:17:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aeotwaVP;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763655452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5sjrMVguqYtKBqGhH4ECYdIUD8k3FOXNKADzIAX6Ncg=;
	b=XSo0WFO7qtD0/BgT9KGeB7I6303OZYfzZlVXQ0rlI5HjDzD2y2j86r3ffNxMZkdqPBhTRf
	KdfM/d022LC+O36DlzgwjluK1fmbqjI0jz/mHXG5rkt68mr2BVs1DpcZy+S5AXAfiJHE3D
	OPj4rBjCm8LEuER9u8xYEKRFk1/L6D4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aeotwaVP;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763655452; a=rsa-sha256;
	cv=none;
	b=SMTxS/uk2dXx5Ujv9bKQoFWiENH6yiTrTiWsxdG3PBYFCSuSSnuw/j14gvcCmdmOt1cADG
	mmOgvSzL3ApB3KkO1nZdOhHbMKHlhUEmH1yBhdOnmuM4pXzJj6fwAyhTCTyyc4MnJ3Qgom
	iocUhk8mNkWdyPz+bcGpbgpEzp0W8Ew=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E6A8B60146;
	Thu, 20 Nov 2025 16:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8D9C116D0;
	Thu, 20 Nov 2025 16:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763655451;
	bh=NxStlN0sykH1gh6u/oPgxyBdh3fqUB6K49dDrBU3dDY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=aeotwaVP/quTK59YtQvEIkiP8/BGxEN9pfdawUrjnS7OkA05j2AJyR4Ra/g5VQSv5
	 UehQfPQbBNvFe4Nk6zt/Ny7nUGJFLrYk4ZX6FD1zR6Zxhu19BmdG1h5WDGqRP/I7E/
	 Kghk8ZEdsMQTqZUDbFhym+ftH4FtEVQvoikKhr5Or2WcufcL4kauCfQlf6O6onaBy5
	 gYpZP/5gEiXN/o59nqfT22nZgjQpRiIWLiNnmmcj4ufXfZdlv7nQ/FeTSTj8eV26Sb
	 a32axiyrfZPbjLgueRCrAjQWV+iKHqBW0YXxyqvt/8f684TLg3o9rWW7gbQKL9PgZ+
	 To+wTcRhvXj5g==
From: Pratyush Yadav <pratyush@kernel.org>
To: ranxiaokai627@163.com
Cc: catalin.marinas@arm.com,  akpm@linux-foundation.org,  graf@amazon.com,
  rppt@kernel.org,  pasha.tatashin@soleen.com,  pratyush@kernel.org,
  changyuanl@google.com,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org,  kexec@lists.infradead.org,  ran.xiaokai@zte.com.cn
Subject: Re: [PATCH 2/2] liveupdate: Fix boot failure due to kmemleak access
 to unmapped pages
In-Reply-To: <20251120144147.90508-3-ranxiaokai627@163.com> (ranxiaokai's
	message of "Thu, 20 Nov 2025 14:41:47 +0000")
References: <20251120144147.90508-1-ranxiaokai627@163.com>
	<20251120144147.90508-3-ranxiaokai627@163.com>
Date: Thu, 20 Nov 2025 17:17:28 +0100
Message-ID: <mafs05xb43ch3.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 886E0C0005
X-Stat-Signature: 36up98zamcqk7mpkofhpbnr68mgmngck
X-Rspam-User: 
X-HE-Tag: 1763655452-459235
X-HE-Meta: U2FsdGVkX19Z6TuOBN009I1mP/rUp1ig1vfgH2bWhsTdSER1cPQujAQ4tooXHIaBmpP9XDlqMMDf/aZumyp/YVpw+gwQUhNYYpOpFPL4ngTH+mn9WOWjztCbha1+U1HsnpC+/PPk5osg3LfGiz/WE0NxN6O6rkqo6wpLFpc5GO1rPt2fo82eaB0oGRKTUTXo6r00C8eJep36/YeBnsxlqsVF8c2LMUgxHjPQf+BlQ/DLThmPpOKSJMfivnRwHo0AUbVBb7qPKhiiYoe2kSDq5ynBmHeZwgdY7Qrca6nL4AmuDv8YN8yNKSSxL5C9Wfoezdrf0XfAhKaGutPNI/ZBjhOwiRJZFvaKizOJUdTfJD6UiLRdUEPokvNnbclXXB9voLea69YIuaT1yPGNDTy6k3zJjAnTutG2dNAVjzwa46cNkf1QGtSAkAXTmXSDmRu8EXlmmnpMaScvg3eNOVwVsfUwNBiTxOmB2gvELN0fLxYJTtooTXAw6Wbdr8Wkw3Mh4R6eyBuyv5xgIdCajcQi45NwIfkpPO/Z8sUeJNqpTv4GNgTF2SI+PaBpIEoq/ZVJ9FWAEq1Y+OPPq1V3iQGC95b60SEqPIfBpygzZZ1jAJW9SC0KF9Ri3MN/7Huvgy6b2/xZK+OVFNhrk2TtRneYVNNwuSOKEp72c9qsaA+0fa2rNAphZR+xPtzEpBJVVzeE/qrLe1FML4SabM6RbAxxRdwX1LpZ9kuAVvcrzY4GtSyFdMKoqcK3NAvlgQ9XEWp06fKwVoMPf/NVPtzuhO4MjyaPI9H4AH4+kaOq05AylVv5AYcqT+Ff0Gbzukiu8W8RiXQa/7S7PE5hUEBMIW6AqdM4NgOdH1fSbTRuS9+Xc7b6USgiYBtjNZUefW6STEtg/TDJTV6axoDucpLtTCyzdmqErnX5g969mqIFFwaTC2btmwHGTwG7s+EdVImc3Q1ZZxX6xX/+/ZTFYG6ccRa
 /FxdaYtx
 BTleuR4RTCAfIKVlVk+pqfLyfOOhfs4KoppPJc3ZdiA88vnQUFWWwgf2xZrucdBUsLikbrrUARId3KkLt7wZsOrcTdkTKwNE+CTFJKhJvSfOOWmEaywrthw5uF2m3z0iSu9NwubbHMEI9cHCtS4H4xPwfkbx3BRMeDQOpKbnCCQ4wKFH/xQWD9wI02e90uCrgWpePSucJfuQOIsK2mhbe570Yag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20 2025, ranxiaokai627@163.com wrote:

> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>
> When booting with debug_pagealloc=on while having:
> CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y
> CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=n
> the system fails to boot due to page faults during kmemleak scanning.
>
> This occurs because:
> With debug_pagealloc enabled, __free_pages() invokes
> debug_pagealloc_unmap_pages(), clearing the _PAGE_PRESENT bit for
> freed pages in the direct mapping.
> Commit 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
> releases the KHO scratch region via init_cma_reserved_pageblock(),
> unmapping its physical pages. Subsequent kmemleak scanning accesses
> these unmapped pages, triggering fatal page faults.

I don't know how kmemleak works. Why does kmemleak access the unmapped
pages? If pages are not mapped, it should learn to not access them,
right?

>
> Call kmemleak_no_scan_phys() from kho_reserve_scratch() to
> exclude the reserved region from scanning before
> it is released to the buddy allocator.

kho_reserve_scratch() is called on the first boot. It allocates the
scratch areas for subsequent boots. On every KHO boot after this,
kho_reserve_scratch() is not called and kho_release_scratch() is called
instead since the scratch areas already exist from previous boot.

Eventually both paths converge to kho_init() and call
init_cma_reserved_pageblock().

So shouldn't you call kmemleak_no_scan_phys() from kho_init() instead?
This would reduce code duplication and cover both paths.

>
> Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> ---
>  kernel/liveupdate/kexec_handover.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 224bdf5becb6..dd4942d1d76c 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -11,6 +11,7 @@
>  
>  #include <linux/cleanup.h>
>  #include <linux/cma.h>
> +#include <linux/kmemleak.h>
>  #include <linux/count_zeros.h>
>  #include <linux/kexec.h>
>  #include <linux/kexec_handover.h>
> @@ -654,6 +655,7 @@ static void __init kho_reserve_scratch(void)
>  	if (!addr)
>  		goto err_free_scratch_desc;
>  
> +	kmemleak_no_scan_phys(addr);
>  	kho_scratch[i].addr = addr;
>  	kho_scratch[i].size = size;
>  	i++;
> @@ -664,6 +666,7 @@ static void __init kho_reserve_scratch(void)
>  	if (!addr)
>  		goto err_free_scratch_areas;
>  
> +	kmemleak_no_scan_phys(addr);
>  	kho_scratch[i].addr = addr;
>  	kho_scratch[i].size = size;
>  	i++;
> @@ -676,6 +679,7 @@ static void __init kho_reserve_scratch(void)
>  		if (!addr)
>  			goto err_free_scratch_areas;
>  
> +		kmemleak_no_scan_phys(addr);
>  		kho_scratch[i].addr = addr;
>  		kho_scratch[i].size = size;
>  		i++;

-- 
Regards,
Pratyush Yadav

