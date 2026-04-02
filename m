Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFC111112279
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 02:49:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA1216B0088; Wed,  1 Apr 2026 22:49:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2B056B0089; Wed,  1 Apr 2026 22:49:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A196E6B008A; Wed,  1 Apr 2026 22:49:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D1886B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 22:49:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D7E7B13A967
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:49:40 +0000 (UTC)
X-FDA: 84612085320.29.3941F6E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1471BC000B
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:49:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DaQU0+fV;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775098179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VQbIFWbj+RAYRmdOTtVpnlFU6VirOWN/yjIeCLJnPDY=;
	b=OIYoPFffWbvLxqHe/pTKt1X/Bpbv5VLJ9PrNYmen97AhK9gQ0ytzG4lWCTFlcmnjQX8swC
	yyeFESKT3lXWyte+CL/KfSi0lHfzS01a4gMgyRlZFgZaX1QqfazeKio0BMWMXNOlstBcUQ
	8VQ4jnMqypAyQqVGyUZqiDSLNlpd4zs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775098179; a=rsa-sha256;
	cv=none;
	b=gHnQoytJcaltpFB2Wl9QcR6lRioUlKjQ+OxQdFkhNsh5txvFUfPXEfppgjqbcp+N4xqfT5
	LG1bT5qId1JGKFTKakcgjxv53b+8HzGlelnVJZEQS6SrYQzrCmAhbT+OF9Lds4V0Za52Zj
	arxXrIYk0Eo77n/jXrtMPkd2VBMrXPw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DaQU0+fV;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F4171BCA;
	Wed,  1 Apr 2026 19:49:32 -0700 (PDT)
Received: from [10.164.18.48] (J09HK2D2RT.blr.arm.com [10.164.18.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 21A883F7D8;
	Wed,  1 Apr 2026 19:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775098177; bh=PWCLb79f++jP4a6gIbEzEcLLojpWQPTQXxqZizi7hZ0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DaQU0+fVeGSUmDt5Fvxa2+l6wILZfgQfNIvT6hHMixHx2D953BaGObCTjmwRNNadC
	 z2V5eZzb/5X3Ore48kA9YUakoABWe0AR9UTaAkMe1lRMSUsbHT0OmKEXaadRcWS47n
	 iaitu5wdvxFnaruc7ITfuIhlDNf62J170DIMhZ78=
Message-ID: <d7cb55d2-ea6b-4a76-be05-86ce38b7c3b0@arm.com>
Date: Thu, 2 Apr 2026 08:19:30 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/thp: dead code cleanup in Kconfig
To: Julian Braha <julianbraha@gmail.com>, akpm@linux-foundation.org,
 vbabka@kernel.org, hannes@cmpxchg.org
Cc: mhocko@suse.com, surenb@google.com, rppt@kernel.org,
 Liam.Howlett@oracle.com, ljs@kernel.org, david@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260331070730.33915-1-julianbraha@gmail.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260331070730.33915-1-julianbraha@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1471BC000B
X-Stat-Signature: podhamf5usrk3qudde13x7knd9w4dyib
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775098178-457185
X-HE-Meta: U2FsdGVkX18Mbk1O5blBzGbUTkVRKxDI2ov0zGD4KfeuWXotChqVj7HkqtXjW83PSI/jqfcApCdNbtzCdsc3bSP91mCO98vXzOpmQ8Wj395DygNEILTMvHKKNYj0BzEBXQS2y3dlr7G3XxPVN9QdPx2UGJZccqQag3JOHFQMOUFJmxbguYUqHY8py7+UxIolzI0v3DXlxzLf0WDJO2BpbUQWnICJKXOcR4n3SX3ony3PlElIB5c7Nw7Mruw64C/R1znZc5NIKg1RWxdEM3/y72wUqgtEmGQnW/miNtaWcyoYQlyEyq9sA1327Hvwm25PAXItOl4sRf6tzmi2rt1ic0wMW7FxoXpk+7QV6Y5x329LQXDSpm8rIDvvWnZPGocriA/j3T3D3a19T42FMkfHSAmOA2Bd9jlCMgWqXiJKDoy70bqeJuNqJEUe0T2PI8UzkvwaEmnDrN9my6uJoMJW/WhZHJPh5XZmIK6rxdgpEu9Fbm1ihLoyx86nVpFikigm5yOXxUKcVGWGyF8xBSta9hO1DAhdB3FaKq1a6woIuIpz46LeblXsZ8aBwXtceq/ijG/++oQj07Nr+srKLRezSKBgF4++vJOrmp8/Lwk4gq2L96tIMxSM+WzBEJQmpMsSmSx0/6wwJQ1/cYlLCQlQ/tXZ4yBoa/iu3ckUurrPTyys9w+r5Th2bxxcYL1UamwyC90bqhjunfdS0WmqHHwRyYVFAJVToKlRqtgOnZNPbIthjPSKUpUjacl8env/DsYfY07/nuRxuulRETtU95aXY9/b1iNonZFDUVCc2bUTQKZ3upYRAUwgVHnWrtW9ZV9naw2BBJortuv4d3imL8a/IHfBb4cZGdGRBQOuW8ilXCPE1AX1he4cvzNFK607Xue/X/oN5VvNYwSboGlNPt9YRVMoST2xinoNckWRRnxFcOb6kbYdMcM+0FvvNY7+iog0mU90F63SVrjJMCdrSRy
 SxNhu1X3
 LmOLzSYjOuSaR3Id8sUWVe4rtTWsccoIgAyonQ8C4az6sNOYmrv6210EZ/CSL1VFJBUEnRQTdpSgA1xsdRJlUsBlkNb3Bc7C9lGP5KAqVF05Cc183/5O6sKP6biwzKXb8qkqbGVYu46Nnu1MWOLYNk4IQ+Wr1XzcuS4yFmoz0M8kGH23pCusZSA+5xo0ztU3AzFCWT6BxthVguqt22OBjWJY/vw0VhbnRvtesJt3OPDSszvo59FtWuk8qk/IwUxK0es051LxCy5Izw9DI0OglfNqXUq0Cq5nCJroiHeZSTNKfkpkeL2B2M3lf9MrRm5ySjEtz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31/03/26 12:37 PM, Julian Braha wrote:
> There is already an 'if TRANSPARENT_HUGEPAGE' condition wrapping several
> config options e.g. 'READ_ONLY_THP_FOR_FS', making
> the 'depends on' statement for each of these a duplicate dependency
> (dead code).
> 
> I propose leaving the outer 'if TRANSPARENT_HUGEPAGE...endif' and removing
> the individual 'depends on TRANSPARENT_HUGEPAGE' statement from each
> option.
> 
> This dead code was found by kconfirm, a static analysis tool for Kconfig.
> 
> Signed-off-by: Julian Braha <julianbraha@gmail.com>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  mm/Kconfig | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index e8bf1e9e6ad9..29d2de0d5c06 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -810,7 +810,6 @@ if TRANSPARENT_HUGEPAGE
>  
>  choice
>  	prompt "Transparent Hugepage Support sysfs defaults"
> -	depends on TRANSPARENT_HUGEPAGE
>  	default TRANSPARENT_HUGEPAGE_ALWAYS
>  	help
>  	  Selects the sysfs defaults for Transparent Hugepage Support.
> @@ -840,7 +839,6 @@ endchoice
>  
>  choice
>  	prompt "Shmem hugepage allocation defaults"
> -	depends on TRANSPARENT_HUGEPAGE
>  	default TRANSPARENT_HUGEPAGE_SHMEM_HUGE_NEVER
>  	help
>  	  Selects the hugepage allocation policy defaults for
> @@ -886,7 +884,6 @@ endchoice
>  
>  choice
>  	prompt "Tmpfs hugepage allocation defaults"
> -	depends on TRANSPARENT_HUGEPAGE
>  	default TRANSPARENT_HUGEPAGE_TMPFS_HUGE_NEVER
>  	help
>  	  Selects the hugepage allocation policy defaults for
> @@ -931,7 +928,7 @@ endchoice
>  
>  config THP_SWAP
>  	def_bool y
> -	depends on TRANSPARENT_HUGEPAGE && ARCH_WANTS_THP_SWAP && SWAP && 64BIT
> +	depends on ARCH_WANTS_THP_SWAP && SWAP && 64BIT
>  	help
>  	  Swap transparent huge pages in one piece, without splitting.
>  	  XXX: For now, swap cluster backing transparent huge page
> @@ -941,7 +938,6 @@ config THP_SWAP
>  
>  config READ_ONLY_THP_FOR_FS
>  	bool "Read-only THP for filesystems (EXPERIMENTAL)"
> -	depends on TRANSPARENT_HUGEPAGE
>  
>  	help
>  	  Allow khugepaged to put read-only file-backed pages in THP.


