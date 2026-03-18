Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90F91FCD0CC
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 07:55:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 039C66B0111; Wed, 18 Mar 2026 03:55:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2C7E6B0113; Wed, 18 Mar 2026 03:55:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E42C16B0114; Wed, 18 Mar 2026 03:55:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D1B646B0111
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:55:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 78BDE1605F6
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:55:18 +0000 (UTC)
X-FDA: 84558423516.27.2AA1306
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id BCA43C0006
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:55:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qa87uBHG;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773820516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HMd/Kv020DdGhBH0Z06dwvDjpCospLnPf8uw37I4IuU=;
	b=m2/gx5x9xc+gI3/Iyg0/ucdyQ7Voz++uNse7yBkWEIw+JGbz4vuuqLOOuIXklfUk/twCTx
	k7NwSagbSQS+JmsjLFTOvjaAjSmTpup9nEn3nncu1KAV4ZUhO4vFlD2jBcbuZYa1eAzgTu
	P3w6E8GZGKzvJJ4h22G8ZQLXcgkQzUM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qa87uBHG;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773820516; a=rsa-sha256;
	cv=none;
	b=iUsDbztZyRD751lfCxV7T+P5wjItRxMsVufCHKaERPnwj8ta/CMY64y3J8pX6Q2NhT9Fnf
	2pYA7uJF7TnKePPEvr2dQlI+fniI6JTEHE7h9a+2MeaxFxOfsKYSGJx4ZC77s4vCheaaGY
	qJyS1ZaAbm8+WtUJ0o38VO4FrcUD+NA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BE72243B8B;
	Wed, 18 Mar 2026 07:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369B2C19421;
	Wed, 18 Mar 2026 07:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773820515;
	bh=393sZvR/gqTP0vkDNjf01M+bgmlTncpIIPSe+0jujU4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qa87uBHGvCKrjka/oAwuJqQUG3jiZBm346/TSkvdTVAmDymvQKrv58X67MzKzTCLI
	 GOjv+L8f3tgf06T335Ln0r20UuvjG4fTwAfaQbMTAFp76VpkhkSsAz4v7YXaQLcW78
	 KkfRAacm47ueuWtSSvZrkjLqoKrh/cFZVA/6J0VZ/PeI+S38NdPODimoTOxeFM7GZS
	 GVo/KZ8U4ZA9yEZn5L/GzlPCOwViswc4NDtBQQZm8/69vvKmR5+XOV9tif3R0JM7Kl
	 Sv7Y4WtnDsIU0lfx6eMJfmo/X906W74olhjxCYHorRM+Ep8Yx4xnHi2tgx8BLBt/y0
	 Akxv9+WGEBu9Q==
Date: Wed, 18 Mar 2026 09:55:07 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 03/14] mm/Kconfig: make CONFIG_MEMORY_HOTPLUG depend on
 CONFIG_SPARSEMEM_VMEMMAP
Message-ID: <abpaW74xEcNMJJXU@kernel.org>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-4-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317165652.99114-4-david@kernel.org>
X-Stat-Signature: gm4x1xjobd9waas6o8oq7hejtg4ggb3d
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: BCA43C0006
X-HE-Tag: 1773820516-376760
X-HE-Meta: U2FsdGVkX1/vP/R+Kzkf5ICYMgXJSXaZP61zx2Xj8gG/vPZq1qeEjom4g7mAmcsgPtxUf7IEFnr5bUgvBxjeOruP1Fystlro9z/bRya5NICy0JMfglrwDepfFS4LEji+BHTj3WzOObnjvG+WeNVliBtndrLOPvmPZK1OXPThvAff/vtLDDzJ8bq1hrJdHyx/YpvqwCnWQ566Zmhblk6hheiSXbu/Ud/ORsZ99RuX8pV9DuH/2x54yxTBrznWmc/to+muhangbECbCd6n7ETLz69ItEtC8pgfQDYxCkdLgIGy3ObDOLhIwAbdvUX1Y9SulXo0p0betr2yDqsTuHeXU/yzTrqLXJH7FmNEHR5BPZaBfOkl2PoBKEM/lbOR2apjfP20PmYjjD5weSJlBnbuuym6KxWyoVoYr3WFIo8U5i8qCCfWe2zxtWPtaQcaPLDvKJM8EZ/YhyuSmt2TW4/T9I6OTTCaTZ/I85OFbqsJe8mBr27/+qpNQVtvofhc7yA2eP8TXHPqMPfWQd835s0q8hElBODRJPX6xRa4IRFjpZ3wj+iCZjtasBjQSstkamD03yIJf6CbKLuzjzwZbUgjVzBk84gmDurEEM7EHt8/00bBfdXthY/d0q9aqvVHDSET6sE6759ZaKaVBZeqiiYGSkDWkVoopEf0/sLbliR3NJZoQuFVxEDCvOlimgb8W8k9Th0RHygg5YsCByJC6/74pueG2vnJ2GvlakMQ2AE6dsM1eFxTm/T+KZAIzk6ZCv9Q/fgNpjeRK61jrCAtkwBkC4gMVVfGAo80NNcVk7s8m7Zk6dHC0T0jwVF+CjulDL6dEoqpO3QBThCsuvKQN/M9yFjTxly0ZxT+643qFtg9/9NfnHAoQOSC4vGCqXybatVKe44aykv42VQJAxjrGX0T6FfrRZztFIMm/yffb781zp/wgoh+C2LFlwQXeZDIpg5Y1eQn1M4adxQvJrEA6U+
 HZ+Deof8
 adhdgYhJQzuDX/owLkSouDDeZodk3UJnvySGQAfBPSvuqa0n7s/owqT0eUsER0zL5gbuCk7tgEG0/B829B2cAWSdceZjpw+4ub0ar6I95TUUCDLyZ13QBMAEjHAGeThacpRMQYZGAEIOV9tp2E4tdqSBAu6oBU5IZq1rWmFjV5NsDAdz2VKcVvi83Z5R3hOmcoGwApd9eDRNIHj4Q2YnIkag+jd9Z4CEqJmxlIKj+tCnxaohIN6mZU9IkVo6twiL00qYASR1ro8sVElr9SuDxsaFPHw5F02x4tQUFZO8JclDwnTo36U64fZEwJiCc9hF1UbbJ3403B5tdORg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 05:56:41PM +0100, David Hildenbrand (Arm) wrote:
> Ever since commit f8f03eb5f0f9 ("mm: stop making SPARSEMEM_VMEMMAP
> user-selectable"), an architecture that supports CONFIG_SPARSEMEM_VMEMMAP
> (by selecting SPARSEMEM_VMEMMAP_ENABLE) can no longer enable
> CONFIG_SPARSEMEM without CONFIG_SPARSEMEM_VMEMMAP.
> 
> Right now, CONFIG_MEMORY_HOTPLUG is guarded by CONFIG_SPARSEMEM.
> 
> However, CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG is only enabled by
> * arm64: which selects SPARSEMEM_VMEMMAP_ENABLE
> * loongarch: which selects SPARSEMEM_VMEMMAP_ENABLE
> * powerpc (64bit): which selects SPARSEMEM_VMEMMAP_ENABLE
> * riscv (64bit): which selects SPARSEMEM_VMEMMAP_ENABLE
> * s390 with SPARSEMEM: which selects SPARSEMEM_VMEMMAP_ENABLE
> * x86 (64bit): which selects SPARSEMEM_VMEMMAP_ENABLE
> 
> So, we can make CONFIG_MEMORY_HOTPLUG depend on CONFIG_SPARSEMEM_VMEMMAP
> without affecting any setups.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index ebd8ea353687..c012944938a7 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -472,7 +472,7 @@ config ARCH_ENABLE_MEMORY_HOTREMOVE
>  menuconfig MEMORY_HOTPLUG
>  	bool "Memory hotplug"
>  	select MEMORY_ISOLATION
> -	depends on SPARSEMEM
> +	depends on SPARSEMEM_VMEMMAP
>  	depends on ARCH_ENABLE_MEMORY_HOTPLUG
>  	depends on 64BIT
>  	select NUMA_KEEP_MEMINFO if NUMA
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

