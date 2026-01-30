Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3412D73EAA
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 01:31:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96A1C6B0089; Thu, 29 Jan 2026 20:31:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 917F16B008A; Thu, 29 Jan 2026 20:31:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82AAB6B008C; Thu, 29 Jan 2026 20:31:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6DC3B6B0089
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 20:31:46 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 118661B14A8
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 01:31:46 +0000 (UTC)
X-FDA: 84386903412.26.C22D9A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7238320005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 01:31:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W8waZ2ss;
	spf=pass (imf13.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769736704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=orhcYQFl+8+GbMKPpo4Ol2P1+lFUXQlAlTXx9mfMEek=;
	b=miH7TFuV2M3daM5JTA4KROMv/fTtjhZ+7RsCZWHrAyBIThZJ0mLT5/8xvZA/f5BYys8Pwl
	xyyCzl6x0zABSOQRpxFWaQ6CZO9wG2NL1eka7kqxOp2+vZ6xDhPdpEZSFc/lJRLccOkH5O
	zrJJ+AEG8XPDNeyJtvZFMPIgJPOTC4o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W8waZ2ss;
	spf=pass (imf13.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769736704; a=rsa-sha256;
	cv=none;
	b=BF7oCK6CXE6ZW1NqJWTOfEc2AZ/8Q9Zjpvq6f9EuXnNDX9l3Q3etdDka1MHFWKtE7yeDwY
	ccyu8wHA54UrIjMybfyHW8bqkwqpLiRWqHRnq1+A6p8DPSUyUjlBajGQ0XXi3TrWk3bnBy
	BLU0IAEnRWCmUJGmjq/xmKTManoJwTM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 461BE4031A;
	Fri, 30 Jan 2026 01:31:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254BCC4CEF7;
	Fri, 30 Jan 2026 01:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769736703;
	bh=8cKq9AUozNFDXxvISOg02yWkfQ7EXvQvA0V9S9ELwWA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W8waZ2ssLE2mo86qQyqJx1jIYseMIoKmqdeKhqgBjTisvD6JjmovazsvkCaQD3SPO
	 Oyc4XHPvIrQQ5Rs3tAUaQEGu33G3lNKHlxwgUDCC4WIMgZd48CqUaKdjssr0kwOuHg
	 xZ03Wx3Ulkb7KFqFYGg0QNf7tJjMX5685hWMHnDX5qItlpF/qngrddtN82JBiA3wcV
	 pKAYnzDZxAth8PBVh+lIAiReXY2EBCC/HTmcXKJ5NJ8kg126eGgXE7YVHDKY1Us4wZ
	 06piOKS8Asrw5pa1goM5lu8X4TyOlkhn4EG1O/f6VVT8HitALTO0PTOlDDCLP3gKBU
	 3v8PvXzd2/3cQ==
Date: Thu, 29 Jan 2026 17:31:42 -0800
From: Kees Cook <kees@kernel.org>
To: Paul Moore <paul@paul-moore.com>
Cc: linux-security-module@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com
Subject: Re: [PATCH] lsm: preserve /proc/sys/vm/mmap_min_addr when
 !CONFIG_SECURITY
Message-ID: <202601291730.45120C1A@keescook>
References: <20260129225132.420484-2-paul@paul-moore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129225132.420484-2-paul@paul-moore.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7238320005
X-Stat-Signature: 5ur56mu4dw5jofut3tio17s35ofpp5gq
X-Rspam-User: 
X-HE-Tag: 1769736704-967917
X-HE-Meta: U2FsdGVkX1/6XrLFY/+mXApzNFjE5TS4LBMOk3o3C2UId+AVFyMagdIttgJ+JvTUvHJrx4tU1SVfU3IuM44Jj7tS4eyOjgBq42W/2SRkg8TMFBagFNMyIgQoEGGPO6fNCA3xGkUI2/gZfPSXaFb3F2rqlBo8eC6qh8LYFQQrzobK8wq8YAMvkhi9ZOusl40w7xZD/XdJBom79jYjAeI0v8h4Ih4di+0708njENyodN7g5gFOu+zBXUKY5dHYuxW0JGNbKauNEyICxtiiGC0Pd8PxYjWgLDaCJrEJ1eU1hw/7PJ6cJknAiRhvjVdDXAIvM7gr1UO3jAWnelWzAXCOjmcGnzDF8kMq3ZhCPMCxJpgPDScx2zQZNqZB370vxGKxPXJDUBS+H2B4Ufi3HnuMRt8qkQ+LZbJnV0XiG3V/hbsCZp9x3tTYL2WpMyddWTdwuqviUtMKpT9MsJmy6liuWXxDreBkleicirkDQzjzh38p8AVCL2G/PleOsxgF6J0GGbNgRYsXXI6Va7rghMtxrS903Q4dBLrezKwuz5SeyxJqEMGqyB3z2BPwm5TzC4dWjTO2BiCjUhLdzK7yjs+BaOQPV1hCOlt9d1mJBoZeRDyDcG8UuLaDSVRimWHOTDEWhi1M/JJ+vcYhk8D1ZifqASe2xWA42CNGxoglk1/d9SfhSimieXWzOM/NHIjDotSbXDdpbTAw13RvD9jxsQnMu0rut4jKF8L50J5w4D3xfyJ/3fIJdYi/z6tzSMnluzMb7zbpm+9izO96PykWNk1kc1GxyPnpzBiFrgNhUzbfXwwunDsMJzpPYjd5SWeyIm8EYudY00QsxwTNWyxomULcD72TFw8MvPXMgJGXKhEnI59QTBY2kdvHVUB2kLNRIdfBYF5i6dUMcGVtbEGULR5YMNOHQjXIk2svU0+LRcekM496adahsMY1D6hMV8Vtp6EMJH1Ibjqpb0pwaB9xCJI
 EqY3Mip/
 k2+arV0Da8Quzkg02EV994uWlJHlqVjsv3f2McambEMU2Azk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 05:51:33PM -0500, Paul Moore wrote:
> While reworking the LSM initialization code the
> /proc/sys/vm/mmap_min_addr handler was inadvertently caught up in the
> change and the procfs entry wasn't setup when CONFIG_SECURITY was not
> selected at kernel build time.  This patch restores the previous behavior
> and ensures that the procfs entry is setup regardless of the
> CONFIG_SECURITY state.
> 
> Future work will improve upon this, likely by moving the procfs handler
> into the mm subsystem, but this patch should resolve the immediate
> regression.
> 
> Fixes: 4ab5efcc2829 ("lsm: consolidate all of the LSM framework initcalls")
> Reported-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Paul Moore <paul@paul-moore.com>

Good catch and fix!

Reviewed-by: Kees Cook <kees@kernel.org>

-Kees

> ---
>  security/lsm.h      | 9 ---------
>  security/lsm_init.c | 7 +------
>  security/min_addr.c | 5 ++---
>  3 files changed, 3 insertions(+), 18 deletions(-)
> 
> diff --git a/security/lsm.h b/security/lsm.h
> index 81aadbc61685..db77cc83e158 100644
> --- a/security/lsm.h
> +++ b/security/lsm.h
> @@ -37,15 +37,6 @@ int lsm_task_alloc(struct task_struct *task);
>  
>  /* LSM framework initializers */
>  
> -#ifdef CONFIG_MMU
> -int min_addr_init(void);
> -#else
> -static inline int min_addr_init(void)
> -{
> -	return 0;
> -}
> -#endif /* CONFIG_MMU */
> -
>  #ifdef CONFIG_SECURITYFS
>  int securityfs_init(void);
>  #else
> diff --git a/security/lsm_init.c b/security/lsm_init.c
> index 05bd52e6b1f2..573e2a7250c4 100644
> --- a/security/lsm_init.c
> +++ b/security/lsm_init.c
> @@ -489,12 +489,7 @@ int __init security_init(void)
>   */
>  static int __init security_initcall_pure(void)
>  {
> -	int rc_adr, rc_lsm;
> -
> -	rc_adr = min_addr_init();
> -	rc_lsm = lsm_initcall(pure);
> -
> -	return (rc_adr ? rc_adr : rc_lsm);
> +	return lsm_initcall(pure);
>  }
>  pure_initcall(security_initcall_pure);
>  
> diff --git a/security/min_addr.c b/security/min_addr.c
> index 0fde5ec9abc8..56e4f9d25929 100644
> --- a/security/min_addr.c
> +++ b/security/min_addr.c
> @@ -5,8 +5,6 @@
>  #include <linux/sysctl.h>
>  #include <linux/minmax.h>
>  
> -#include "lsm.h"
> -
>  /* amount of vm to protect from userspace access by both DAC and the LSM*/
>  unsigned long mmap_min_addr;
>  /* amount of vm to protect from userspace using CAP_SYS_RAWIO (DAC) */
> @@ -54,10 +52,11 @@ static const struct ctl_table min_addr_sysctl_table[] = {
>  	},
>  };
>  
> -int __init min_addr_init(void)
> +static int __init mmap_min_addr_init(void)
>  {
>  	register_sysctl_init("vm", min_addr_sysctl_table);
>  	update_mmap_min_addr();
>  
>  	return 0;
>  }
> +pure_initcall(mmap_min_addr_init);
> -- 
> 2.52.0
> 

-- 
Kees Cook

