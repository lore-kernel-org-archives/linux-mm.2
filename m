Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73D66CFD37F
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 10:23:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAF946B0011; Tue, 25 Nov 2025 05:23:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C872E6B002F; Tue, 25 Nov 2025 05:23:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC4046B0030; Tue, 25 Nov 2025 05:23:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AA20F6B0011
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 05:23:24 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 658F513B8BB
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:23:24 +0000 (UTC)
X-FDA: 84148742328.19.3E133C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id B111740012
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:23:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d0cYjFcB;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764066202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fRNQMM0bXpIaWPLa/w3KH8tGaU7dPE2ryZviRFbGgDE=;
	b=BPqakxNBhzJAoJLsoXgaSr6f17m4qwX3dl2RAVOxyoHNVR4zSBvejlZCQZEI/Z54Fy+AAY
	9SWse5wAwFLNFZ284mGyOd9+hwvu4NLJAIcR/zUI84oxlgTvVQjbELE9FN9spJA7MDS6As
	rPQ770bQcsb5wmMZc6PLtFYrbYtY5zI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d0cYjFcB;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764066202; a=rsa-sha256;
	cv=none;
	b=ZZC2CqpBTLnVJxaQCts8PDSpimsK4jh+5D8T5PSm6T9vhisKLQK1K71y/OMPJzQRWVoX7Y
	lu/6nHuxafW+ZL3o1Obss9RU74mzLFeDYNL1KY8AJgwwioFBFc9yKDIyh57yEmzSEyqpHI
	qeTjqlGNq0WOgb+vc/Rarb6e2EaO5wU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A2FFC42A9A;
	Tue, 25 Nov 2025 10:23:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B05C4CEF1;
	Tue, 25 Nov 2025 10:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764066201;
	bh=53ruduyJmEZa17lWjXksTMAjCjoY41BSgCSmU8ZSx5M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d0cYjFcBVVSiEcYkxlP4OnCM79l3Mi5+cW2wkzbx6q98XMT9KbC3rUzbv/Oqg0q5u
	 +bk4Kr5fydN2ueaCMuuqHPXeqwH87MYhx15UgaTblj0KxXREGC+2Ft+poMatPP1mb5
	 7z7fuK9gC4XAsj4yEiqGZnPMlDEPSRnKpeTj77nV2MroItLH+slAmzeWrpN/k7uU2v
	 XH9/5UrYWMdCdhev8/Z1DR8cra2S3naAG4scq4BvRjppysiF0MQhbmoOdi9xZ57up+
	 Zp97Ono/2uKQEmsGmGW5ZZCeOuIsGMJOm8sM3gDEBkTQKWz/5Mpsmt1R5g6cReRSOd
	 avgaBBcHAneOw==
Date: Tue, 25 Nov 2025 12:23:14 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kernel-team@meta.com
Subject: Re: [PATCH v2 1/2] mm/mm_init: Introduce a boot parameter for
 check_pages
Message-ID: <aSWDkuJEdk9cdVCK@kernel.org>
References: <20251124225408.2243564-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124225408.2243564-1-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B111740012
X-Stat-Signature: cy7fkq6n37iabk3khhf1wps1g9p74bi3
X-Rspam-User: 
X-HE-Tag: 1764066202-115831
X-HE-Meta: U2FsdGVkX1/5eTkDLcol03rFFop2LmHYQAqDIbh72hy8VjL3igu2oBg+CQ+JxQlAU1gFh4PffyhP/GpGqkuqz7SwD0kVR+r5pQB+rGaqCaTsN+VKc6W9ekCglsYhkcY2sD9BazPOwfs3KSWVBprzwFiR6MVnJLsTDjl1UlU0STaxlr81E/8spcKjgulMts28coqqFr9Xyft//kBhzHciB/fkZ/uC35clYZLIh7f2aI6Ep2ajFBHJ2Sf1qID4kraySQsU8vADYj38pJZFyEpYEtUhTtVUNFQIto+og4nsKyZXeGVFz9+koJAsQkklFUaS/LphdeuKUZDUoOLqR6orvs6YjEKuALVGLh3MM8VfhcLuM9R2s5zvPdZvDvEmZZibD2wLkSPx3LMjy1bLeZOhqfN8RUyfv+K64xZ7YLz0Q8DtEycGyyxX2spQ+ZEX1PBy9S2hkh2ZfKSs4YVzc5ksi5O1VXT/Ma5c37225ripgH/W0hc7JnHmlmAA81ftWYFgCws3im4xERDlbQQrFYxL24Kah7/ne98J0AMqXZU5Ag2EIhPWMoL82KByknsa7b50CTkCnW4SqBPwtPNmTAn+z7f9a4BTo5yGIu28uf6LoEMS4tLnbdrWmeVwKvSLxBa4+IV03b1F47EfLKoyxUHlbVS+OKCelFZq2ZAOsjvpgNNR8GPaHF/q6P9X/H2i03qCe+zUHCQSMstHJQLZ6CSWinvut3gYPLe6qSpV6qglyBL7I2YmDCNuAM5FdLPSPiZW7+0NP4wvi3apWKVZpcN5sG0DYsreteICcOw5YSQ/9hIW653YHJx1WZD6XlNMZii7OzB4H59981dZCGcvy6rFV3Z5d8NFBbXT/koBEQlnTgdw6/XoiGhp/nEPky4LgMa0REonT9re42z8+p9Yg7yQhuMz93WPBINXfzVlCiaa0NA9Fo3RhA4uId4dXnk68WTo9vbhqmL98g09zXRdBB6
 Hcnj7cf0
 JrezB70BGsJDlwnj3qUrvJnBx2eZz+h1bScpg+WcZszwZkTcikf4+pmCj4xC8nZ19X0G4R+0CCuJlm6eUT6SZRR8mnoYL9gNE/wL1cBops04JVWFZx9BTz7pManwiUdjZCml+PJH9w73XVRlYFddRxyN2HlUWNTrXfP2c8LHZJJa66l3Jee8kcV7f2hydheW9Z6upxISMJiuoqTg7hcqaVRrcruBCwrNetYwjVc4sgi7JIx/glOFhiDti4mqe9+uGTsAr95UiN5iU9Lckryo+j0mTm0WQ/Z7gU4Bb4xNKlrsp04aBrsmX98Z/yf2OpQ9BoAyT6w1RmFY1CpAYtbInkrEVoQmzobSepk4ntgTULBH6JYMO/IiMNmjuYymOmA5dht6E0QlBhZZZLvA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 02:54:06PM -0800, Joshua Hahn wrote:
> Use-after-free and double-free bugs can be very difficult to track down.
> The kernel is good at tracking these and preventing bad pages from being
> used/created through simple checks gated behind "check_pages_enabled".
> 
> Currently, the only ways to enable this flag is by building with
> CONFIG_DEBUG_VM, or as a side effect of other checks such as
> init_on_{alloc, free}, page_poisoning, or debug_pagealloc among others.
> These solutions are powerful, but may often be too coarse in balancing
> the performance vs. safety that a user may want, particularly in
> latency-sensitive production environments.
> 
> Introduce a new boot parameter "check_pages", which enables page checking
> with no other side effects. It takes kstrbool-able inputs as an argument
> (i.e. 0/1, true/false, on/off, ...). This patch is backwards-compatible;
> setting CONFIG_DEBUG_VM still enables page checking.
> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
> v1 --> v2:
> - Changed check_pages from a build config into a boot config, as suggested
>   by Vlastimil.
> - Introduced the second patch, which decouples page checking from 
>   init_on_page_alloc and init_on_page_free.
> ---
> 
>  Documentation/admin-guide/kernel-parameters.txt |  8 ++++++++
>  mm/mm_init.c                                    | 11 ++++++++++-
>  2 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 6c42061ca20e..0ba9561440a7 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -669,6 +669,14 @@
>  			nokmem -- Disable kernel memory accounting.
>  			nobpf -- Disable BPF memory accounting.
>  
> +	check_pages=	[MM,EARLY] Enable sanity checking of pages after
> +			allocations / before freeing. This adds checks to catch
> +			double-frees, use-after-frees, and other sources of
> +			page corruption by inspecting page internals (flags,
> +			mapcount/refcount, memcg_data, etc.).
> +			Format: { "0" | "1" }
> +			Default: 0 (1 if CONFIG_DEBUG_VM is set)
> +
>  	checkreqprot=	[SELINUX] Set initial checkreqprot flag value.
>  			Format: { "0" | "1" }
>  			See security/selinux/Kconfig help text.
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index c6812b4dbb2e..01d46efc42b4 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2525,6 +2525,14 @@ early_param("init_on_free", early_init_on_free);
>  
>  DEFINE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
>  
> +static bool _check_pages_enabled_early __initdata;

No need in the leading underscore.

> +
> +static int __init early_check_pages(char *buf)
> +{
> +	return kstrtobool(buf, &_check_pages_enabled_early);
> +}
> +early_param("check_pages", early_check_pages);
> +
>  /*
>   * Enable static keys related to various memory debugging and hardening options.
>   * Some override others, and depend on early params that are evaluated in the
> @@ -2591,7 +2599,8 @@ static void __init mem_debugging_and_hardening_init(void)
>  	 * of struct pages being allocated or freed. With CONFIG_DEBUG_VM it's
>  	 * enabled already.
>  	 */
> -	if (!IS_ENABLED(CONFIG_DEBUG_VM) && want_check_pages)
> +	if (!IS_ENABLED(CONFIG_DEBUG_VM) && (_check_pages_enabled_early ||
> +					     want_check_pages))

You can initialize want_check_pages to check_pages_enabled_early, would be
clearer IMO.

>  		static_branch_enable(&check_pages_enabled);
>  }
>  
> -- 
> 2.47.3

-- 
Sincerely yours,
Mike.

