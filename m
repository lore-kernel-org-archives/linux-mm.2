Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 629E1D1266D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 09:01:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF68F6B002E; Wed,  3 Dec 2025 04:01:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA69D6B002F; Wed,  3 Dec 2025 04:01:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABC826B0031; Wed,  3 Dec 2025 04:01:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9707B6B002E
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 04:01:44 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 516A81A04EA
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:01:44 +0000 (UTC)
X-FDA: 84177566928.03.10EB901
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4E58416001A
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:01:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764752502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ebkk4jlA0UD1pecLyBguvxjl7WD02dLutsa2pBEDqpo=;
	b=Wt7l4hpNrBWQuXeZVTLdr16NLoyd9u3fXnFh+VBQzs5tpUATKAxpGviBJEVmm1gcLl21RL
	TAwbvxiZq8ubBZJkkesig4yo6AQz2CNgJ4o0Elw3WwbZxIBYrrA6HTENNJNOtqPIO0BOpX
	vJpuBAXDvDL2rdQyKLacSRQcLgbKhjg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764752502; a=rsa-sha256;
	cv=none;
	b=iDSg5df17zZGYFkm1UCGzTyUvl5QsnzJ+TAvOPlmWNY809E/IsHvBIGGmgTzT3GexE8a1G
	bVmRMQADYHMHQpPoBbK9cZOnoWYgx4zHPbDRapOeA6PTV7GIKLK2BwWAZ1MT44/+ZQX25w
	o2RuIMtYYnn9vvpL5RAeQIuPa2qZKqo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B4E6339;
	Wed,  3 Dec 2025 01:01:34 -0800 (PST)
Received: from [10.163.49.22] (unknown [10.163.49.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6AF5A3F59E;
	Wed,  3 Dec 2025 01:01:38 -0800 (PST)
Message-ID: <caea8801-0691-4ff2-aa7c-9b39b13e9240@arm.com>
Date: Wed, 3 Dec 2025 14:31:35 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/mm_init: Introduce a boot parameter for check_pages
To: Joshua Hahn <joshua.hahnjy@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, SeongJae Park <sj@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Mike Rapoport <rppt@kernel.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kernel-team@meta.com
References: <20251201180739.2330474-1-joshua.hahnjy@gmail.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20251201180739.2330474-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4E58416001A
X-Stat-Signature: bn1x1sfp9q4exmhqq9xmc1prz6bkm1t5
X-Rspam-User: 
X-HE-Tag: 1764752502-274503
X-HE-Meta: U2FsdGVkX1+pIsuNyjBL2ZnYcmE3bNZ+gvzTtsm+2EluFA4yCv9SEm6/jxm0tBDNlIQRZSy8b6D4mf2zD1OB31VuSc8tdQ4oNNVMPpPG5m296c0lle+Qq0y7dxrX4sCf3qe667BDjNRiE+aN+JBG/INwwZKfZwIQX9cdtDi1VOyT6pdZ/58iqRcyk7PBbovydTjLt8qond6Y7o95EE6Ii0kJj/dXM3PxODVNSqV8MEYjd9AGNLK/dTnu13QBWkDoo8ANw8MWj0jbrMJZ1l3/agfErJRihpsr6QyvUdDjuo0HjRRl+DB2QGG18Cmw16rsInO03pDSk0bME2JHQOt7+HYwI28TsPIckeYLSkAj+uFN901JbsZGukW7ryvtl2E0paPNpRLjXQeyGPtEJsYDP+AfLNXET0+/h4yrNUz1lVq+HybxQK0F6JOpZF23gmcxcUoPS/D0cVxtBdxPTNKG3mWd4uA2dbX3oCieK0DOak9u7F7XJB1b4W9OdY1Wee6d7POdJl4so9FUMBC76MpLuVxQMCdZwXnp2RLQuacBl5FIc008USAaFlddIxbMeIDAtCBw8ELOEC6VC1bstuVJil6hfN065B5p1cTb9H5xZmEfoO8EkCkW+XQFtI3wAH2faEsbBaDUBcPhGDVy2d1FT657l/w6wBcb3h2U0hutpCp7uhvTCAwZmoYJAzqWptngjOvwnp8+ddJH9Sv1INp3g8tAB0oVLtt59msgwoHKfujsOazWGzK5pEw1PdQ2UQPfJFQvw4rJmLYEUkzrpwCYmRBqHyOJ0xl4EVVwxeAdtkp5PanGaCJ+56g0/wnDeRAE0vWjs7tqQeYJ66CKmmOYpmTBqdjYvBqZEiiOcbJcWKKobXPt4PyzJzqd4Fq3ORpWOsU0JJLVRSC6cZzHGga5kpvH2wetQ7swgeXLqPkt3Nh8r35l3kJs9USXGODJSCQfePKdMs7yUBY+FAkoDKx
 Pcp1pmG8
 bj5qEomEJCD3WM9ayCC5dxE61Nuy8r+TtKXBVLwPsgI4jNaQMs8xaBRU2fWiIBXXZ8ITU5LBaFer8p8+l0rR7rXNANjGoR0ybcUPvUGbYiLEiFZZhyIkeu9OguLGdLWBAYJ/t39AvsK/UMOhnJvk2S8GMoESWi3+00275WhkpGlOdpL9xIVP8+lDOpwUeVp/bjxp68Pdr4sLcDMAs4fnb+evhw0jTCaBRT9+NlDi94UTu6OizrBStHGI669wJMq1qzwvcSTcXPPEcUPqCZw8d8HP0xCMlffjI0MnypbiznH/sB5m6NbGBwksCojzfpON1W61NHnm8IhnPsoIXgGQZmln3+vTeJ5UQaqBvkUQS4+kOBjyuylcTWTwZ6II5tLtUXEUDK18X06vdiab8XEIogP9adJ4JenOc8hOybzCHh7AE8bA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 01/12/25 11:37 PM, Joshua Hahn wrote:
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
> Acked-by: SeongJae Park <sj@kernel.org>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
> v2 --> v3:
> - Dropped the second patch. I may pursue it at another time : -)
> - Variable renaming (dropping leading _) and cleaner check in
>   mem_debugging_and_hardening_init, as suggested by Mike Rapoport
> v1 --> v2:
> - Changed check_pages from a build config into a boot config, as suggested
>   by Vlastimil.
> - Introduced the second patch, which decouples page checking from 
>   init_on_page_alloc and init_on_page_free.
> ---
>  Documentation/admin-guide/kernel-parameters.txt |  8 ++++++++
>  mm/mm_init.c                                    | 10 +++++++++-
>  2 files changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 6c42061ca20e..acdc7fbdecac 100644
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
> index c6812b4dbb2e..fc2a6f1e518f 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2525,6 +2525,14 @@ early_param("init_on_free", early_init_on_free);
>  
>  DEFINE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
>  
> +static bool check_pages_enabled_early __initdata;
> +
> +static int __init early_check_pages(char *buf)
> +{
> +	return kstrtobool(buf, &check_pages_enabled_early);
> +}
> +early_param("check_pages", early_check_pages);
> +
>  /*
>   * Enable static keys related to various memory debugging and hardening options.
>   * Some override others, and depend on early params that are evaluated in the
> @@ -2534,7 +2542,7 @@ DEFINE_STATIC_KEY_MAYBE(CONFIG_DEBUG_VM, check_pages_enabled);
>  static void __init mem_debugging_and_hardening_init(void)
>  {
>  	bool page_poisoning_requested = false;
> -	bool want_check_pages = false;
> +	bool want_check_pages = check_pages_enabled_early;
>  
>  #ifdef CONFIG_PAGE_POISONING
>  	/*

LGTM.

Also a very nice write up for the commit message explaining
the new kernel parameter rationale comprehensively.

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>



