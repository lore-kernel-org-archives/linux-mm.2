Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15DD7C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 14:11:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28BC56B0506; Thu, 13 Aug 2026 10:11:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23C376B0507; Thu, 13 Aug 2026 10:11:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 155616B0508; Thu, 13 Aug 2026 10:11:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EADA86B0506
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:10:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C01D401A6
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:10:59 +0000 (UTC)
X-FDA: 85096432638.14.6DB4439
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id E6F2340002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:10:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ee49KQAt;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786630257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W7c3IxzjZ1zVUumVwqgmmdKFeZT6O1JUGmcuJI+wfq0=;
	b=6pMH91Ix7RtCZ6Zgn+hEJFn72KhJHwOfOK86QwZLsGQyZXh9nQxdxq1JVHXU/kFZ9G67k9
	9UPS8gD02tAoocFPTA0q3/mbS9ptMBiFSrw9YIicULv8hvjdhrL3PaAMrXuTCkW8e5UTJq
	W/NSJVskWtj4WomRMBw/Xu2Rg6r9ysw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786630257;
	b=oXfI7zg2/TH+puXQp8kZa9h05aCqCoZiMEcRCjkJrs47KCmieNgoVh/moHuD1IpDHeo0uc
	LBzbKsFD3NAzvfUAocNQRGmQalY2BlDAiMRK/V9YX9PBTs/MQ0mnYJ3c/KMZ0BhE3X19aX
	3p7YGV9ZIfLIAE2imCyon0xDzq5TxUY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ee49KQAt;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 77339618A1;
	Thu, 13 Aug 2026 14:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB25C1F000E9;
	Thu, 13 Aug 2026 14:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786630257;
	bh=W7c3IxzjZ1zVUumVwqgmmdKFeZT6O1JUGmcuJI+wfq0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ee49KQAtsE++notyN1nLPwO0jpLIS+PyvCcTGaH/2F0IF0oOKRDN+WFM27vwkNTUq
	 NDK5NITnltajeiXaM7rMwzdQWt1UPNBkUHKKOzVpRX66CvNrBeIQcTJjDF/hmxQfM/
	 S573gzHgkXvXzBX2keOh3kzTnzWgq7iOhFcGVO1LNhO4ywK1+qh+isUa/VIoDvjWFf
	 zmNoPKJFIbRJ9awXVO8ThzlmOA2f7Wsl0CDxF64yXxqd4O6gNLJZhJITPEdXo11+87
	 BTUIJp//+24Y8e69zElxFTAkdofu10esk0uuMZztALuITcEKw7/GOWXNcWTMxojxYC
	 RrIMJa595Y8lg==
Date: Thu, 13 Aug 2026 17:10:45 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, linmiaohe@huawei.com,
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, nao.horiguchi@gmail.com, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, gourry@gourry.net, tony.luck@intel.com,
	bp@alien8.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	liaohua4@huawei.com, lilinjie8@huawei.com
Subject: Re: [PATCH v2] mm/Kconfig: make MEMORY_FAILURE select MIGRATION
Message-ID: <an3QZQKpU4AnXIP6@kernel.org>
References: <20260813134916.292733-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813134916.292733-1-xieyuanbin1@huawei.com>
X-Rspam-User: 
X-Stat-Signature: 18panfzmka3yyspkgb3qusd6q9xcrd8r
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E6F2340002
X-HE-Tag: 1786630257-25044
X-HE-Meta: U2FsdGVkX1/gN7+sbbpOuMgfkT410A+ImrAuQ3IbKNh0fEjto6Ct7SoOPRH204EaDO32qFDcwYIzseCTW7kMuGtdPRYM+zh7gQygriictrA08NXeqcwJazoxhMjnsS6FHAi58ivVGQLvhxcYMRo4hWeeaLkbEr5+eCrFPrcI/LG8SMNalYEpyFfBHu4xlwOikufbvtZeiyfBNS/dCutxithtSPl2TEB6b/9YC7obT3BZ85xG5XVFP5a+j5I4Rw5TK/y/hWY7MSVvA57Nlvc5ySz3Cf7t21nFv1Z5lx5/4sBzxjD9i6tyzXrr9jPGwj9sMmRJWke3c3wgtsbtPs+AHo8lT4t36oGJvFhOzS5GY+MWYN7awOY9MNIvox3k4REzQkEkm7B0Nr+o1GZaDoRkfh7cDcPXv53C3iiAmJ068rH/wJQKoGz7Ip1FaJq9RAcKulBjXpGkR8XwIR4K3ygu8hXx8yS0SjbSzSmV5zx2cZR4d5NKRKHt9LYqm8LKsgiYp02Q5HnO3GSHOqe4vFLTSjsGIjuAyvNT/Ov3WF+mozFWhp7arW/eALUdSTP/sh9nqIokKC1BrBpx0B/nL/6JuLei8qpPE5NLARdpvwthgDMGqM+KdydoY5Ei23vmv7yBUK0VeOeMC++zXib5VF8u9BXMVUnrpM5FjijX2wgrMRLgUQi+8XdgT/to5FCaXdNnxbD/Y/DYy14ardeW4bbgwZM1+I4bPwjJYm9QrDOCtJpTEyBBWvFg7FpORJ5lh+xZ58xsGyypVK3PWDbJ3vXhE1FGIv/3u4dXsaGnXNufiux8g8p4KSfntb4NzStxYn03qfHHu63qOAe6c8chufNzf+UTrSmTYgZknGLQQkGifjGR3Gb/xCBlhXLMOW+QzKIwovYBrb6rosautuyTO6IhJeNuFvTCt+ocabcTEjZXuONS/DVhBCavYMsyK5Zp2Fqd2DZTPhcYob1SYHLTjib
 o58/jH0J
 43T+M8SrImOklX3M9Xv0YOH250st09///dDFzFvlmOO4/EDyvMJBPnq4T9tagCv9343iy8n5lejKMWtOvBd82rZgwNmy6WcSPX40Oo228bWKGM+6401t4lTiSBpcKoKsVZ82TSbuZQaEnST36Y0Ld2UW80DL/my1uXFHh1mnaFMevTVygsMs2J+XO0IC5PwmY+X0SJXLMCCXWRzGx+vpC1WbJDMPsg9yyFeJGeVM21oSuZ2dNvImYlOJG7EO6haPjsxzRlvNeaUu0ir7jXftMyogup44e9U55LA7nlmum2zlpRS0xFQNmHDYoB0YGyyv8EiuIh4h14bme9xtxngTw6yHQF+FV0y7cMIhkXxRggNkrfATyEaeKp9wfJFzajycZewjBFNrN/Jss7tFC89idvLD1sFW3CcPnpX2d7qTZLvLaoWk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 09:49:16PM +0800, Xie Yuanbin wrote:
> For embedded devices, lacking support for NUMA, memory hotplug/hotremove,
> CMA and huge pages is a quite common scenario. In this scenario, the
> demand for contiguous physical memory allocation is very low. To reduce
> the kernel image size, some devices disable the compaction. However,
> their SoCs do support DDR ECC, meaning that memory-failure may be needed.
> 
> Migration is very useful for soft_offline_page() in memory-failure, which
> may be triggered by correctable memory errors. Most anonymous and
> file-mapped faulty pages can be migrated to other healthy pages.
> 
> Currently, MEMORY_FAILURE does not explicitly select MIGRATION. When
> COMPACTION, MEMORY_HOTREMOVE, NUMA_MIGRATION and CMA are all disabled,
> MEMORY_FAILURE can be enabled, but MIGRATION cannot be selected.
> 
> Make MEMORY_FAILURE select MIGRATION to handle this situation.
> 
> Suggested-by: Mike Rapoport <rppt@kernel.org>
> Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Cc: David Hildenbrand (Arm) <david@kernel.org>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> By the way, as DRAM prices continue to rise, memory-failure becomes
> more important, and we are trying to enable this feature on more devices.
> 
> V1->V2: https://lore.kernel.org/20260812091644.224299-1-xieyuanbin1@huawei.com
>         Do not expose the MIGRATION config to users.
> 
>  mm/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 8a24c130d008..604c58199acb 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -767,6 +767,7 @@ config MEMORY_FAILURE
>  	depends on ARCH_SUPPORTS_MEMORY_FAILURE
>  	bool "Enable recovery from hardware memory errors"
>  	select INTERVAL_TREE
> +	select MIGRATION
>  	help
>  	  Enables code to recover from some memory failures on systems
>  	  with MCA recovery. This allows a system to continue running
> -- 
> 2.55.0
> 

-- 
Sincerely yours,
Mike.

