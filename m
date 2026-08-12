Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6656BC5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:53:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FBC66B00D3; Wed, 12 Aug 2026 06:53:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AC226B00D5; Wed, 12 Aug 2026 06:53:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39B796B00D6; Wed, 12 Aug 2026 06:53:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D9AA6B00D3
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:53:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8C9D41C0B73
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:53:53 +0000 (UTC)
X-FDA: 85092307146.22.0D7F8CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id D91C1A0002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:53:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aV1nBK8V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786532032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bhh9+ggGVZyLW6J616MkrfItqyn/uEre1JGJoPa70uo=;
	b=R3Ebk7I1ogS/o715sk7qpgiWm3hDUlAqtTT8aZoezmzKFTiZx6wdAj0jLU737gR5WCCbob
	6mcJrRjEXJcAuUIxrkSP7JG5VDY5tLkO4ZUnHleHmrlA7T+GhwUqUnrwVhtkypjP7wsOEj
	aTKfSubFJR0U32qrtQxC7mqmFeaRh1g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aV1nBK8V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786532032;
	b=6Moiz9OEOiEn0E6oxpSye2VNi5jezRphAXqAzbtuZLOR5pMZa0xmtoQVgT1Vk6cgsnZjbe
	zAiqG7RIYH/yM7JS+neF278TC1ZqAzRfSMDqET/R6/SauMfFkl6+ZuLd4e1Zj/l3+MiBIY
	Anyly5jed3Ro2Xyyde97HgIg6nW+MbY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2BD6E40140;
	Wed, 12 Aug 2026 10:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E711F000E9;
	Wed, 12 Aug 2026 10:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786532031;
	bh=Bhh9+ggGVZyLW6J616MkrfItqyn/uEre1JGJoPa70uo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aV1nBK8Vd3PltJjpaGQ9HPLB5szWcVuyiq6kKcO8tEXHd5sLOWpG6+3DppswOUdGd
	 nNhN81TLlnMGVB6R3JA9oOTYhNDq86AxxJBQbmfpo3J4rpgDPz6xWvbbfJkEsVdVqc
	 mdehCDDjbWHCRXCkStYWtzB8m2J+w31zTkCl+5KsoLnC1y15sGk+SXNSBQTMosJai+
	 B1eNZ1TvxyXOGJ7xk6BLr6NpaYgurkNwHQyLDz8amMHgEs3s+6tfcraRfBQBNEJSR5
	 YJ2Bs3nlzGlZunSIGgRC6wKcSfTmpeVmvO2Qc4AGFkNh4k2GaGF7p07rkqt70V5bVw
	 3aeUOIu9r/5aw==
Date: Wed, 12 Aug 2026 11:53:29 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, linmiaohe@huawei.com, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, nao.horiguchi@gmail.com, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, gourry@gourry.net, 
	tony.luck@intel.com, bp@alien8.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	liaohua4@huawei.com, lilinjie8@huawei.com
Subject: Re: [PATCH] mm/Kconfig: allow user to select MIGRATION if
 MEMORY_FAILURE is enabled
Message-ID: <anxOOiuSIL6tjufA@lucifer>
References: <20260812091644.224299-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812091644.224299-1-xieyuanbin1@huawei.com>
X-Stat-Signature: pe4ugi7gwdat81grr81eqwjr4fe3fkr3
X-Rspamd-Queue-Id: D91C1A0002
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786532031-266265
X-HE-Meta: U2FsdGVkX18ctegaIlbX55THGBAFvpxmCTCqFqX2jzS29K9ld7rnSw65Ox+BxHirFiJznq+LwcmIKrLEOLz7dTZpcIF0Yg5k04QQyKSQphHfA3lneBVuwdNH1I8iWG777/g/kfdsur+6X6Wuu2ewCFVamhwrd2n2yLFiLI7+gek8teFXV4F1zGgA6Qvb4J1xoxaa3OgWOJgF0sXxohCHJpHwgt7ZLGBWzh1y7Y6af5+PLtBF40Z8v20LK8Rjg/kdIQ7NztJIIvyNRkBFTtTB+pRSfRxTtPACTnGSldorvwDQB9aEV2nKHondCBmD/fiS6ZL6ieFwC/J3cSdyLoSAJAndzAs+oUUyx41XNdoq/dTK0LswsIHoDYwySy/vTYCEN0lgfBwoe4xPRVhORLcecVaITjXK4kysfNvyKudjoWCtdtfglLKkHX38Othnob6vx5SyZvUzZDCgMnwP7JcAlJLqqt/mgVbIbOrWg6x4Ll8TJM2xN7kZQOijnzAUJ/o5zlwv8KduGG1C5w5o6Q6n0Esmi8yZVyRlejDQWHgwxuC5reg8YsNKUBTftz05CAGUBP0nNUwop+AfTJXOp4huLWsIK8zSbun8zcvTluchCviQCFv6Z+wlqbhyrPOfd3ooh9OZ1vd058lACdjOXpK+hm9Ib9MesotmYNZOs55Pu7fZxUY6bkFoTIjjkh7lSLCHop1YNvQr9BwvHjK+gz7IyT5Ikx1uwLmHfLgh/pEueohhxfMobh6NCvK3UVfDHKadg4jr5WcAszohUAWt3uwrs8AQq0uhG7OaupJmrnVei1tq1FK16uDz5BOZoORh8wMQnGaFSdoO+sPCo19vZNZvvOBCP8FuCG/xz3HyUPNNLm8rtDBnsHPLHsFxEQqKeb5uWU09me4CEZAYRTTD40XcveMCTJNinQ3t1XgBaf90++58u0YBnWvdW3kfDWt+QG/daH8QhnyzMdBneDN4WVK
 CX28rAAU
 /rAscv0CTLl8DZdIa2xQjRdK393Frxmer63+bfZEHrs9bMmYqBG3OIEPGNgMfa2zeu7j1lXcGlKz3t5UQlNO0+qqwWNWTLpwb1BTmAid23G3xK/W9z2xabBzO8NCweyetUIkH/3MnQx8Gl7Jp2ioCnfx09XyZqKGSF2MSxzsEaDI4MRIu+VLwINVY1uZY7L4VwwMsybFfbr/YcVrQn11SqAsSQYSB+tLuJ+ROyCSR0yh3D2H5r6tVElKmzmvJAW5Lyw95GAiw2+OjirC0YVtQ4eaPf/ta2/QNOAnffMfBHKi5AT4ipIEH1suHdP2gUKe/GCdtUCmTxBD2Xv6EHBIwJkEhPaYeDU0NPAOoUZVD6NOVafoBX/VcBTaI13KApdqbJhNFdFzEjrwzHFICdMoO0FSJ6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 05:16:44PM +0800, Xie Yuanbin wrote:
> Currently, memory-failure can be enabled without migration. However,
> migration cannot be selected by user when memory-failure is enabled.

What?

CONFIG_MIGRATION isn't user-selectable is it? So nobody can select it? It's
enabled by other stuff. So this is just incorrect anyway.

But you seem to be implying the two options cannot both be enabled, that's
untrue:

$ grep CONFIG_MIGRATION .config
CONFIG_MIGRATION=y
$ grep CONFIG_MEMORY_FAILURE .config
CONFIG_MEMORY_FAILURE=y

Have you disabled compaction somehow?

It sounds like your .config is broken and... you need to fix it yourself not
edit mm/Kconfig?

If not you need to spell out exactly what config it is you have where you must
not have one of the things that select migration, but do want it anyway.

I'm not sure we'd even support that?

Right now:

	CONFIG_COMPACTION (!)
	CONFIG_MEMORY_HOTREMOVE
	CONFIG_NUMA_MIGRATION
	CONFIG_CMA

All select CONFIG_MIGRATION. Why is it that you cannot select one of these? What
weird config needs CONFIG_COMPACTION disabled but does want migration just for
soft offline debugging?

Yet again it feels like debug stuff like ends up being production stuff here...

>
> Migration is very useful for soft_offline_page(), which may be triggered
> by correctable memory errors. Most of the anonymous or file-mapping
> faulty pages can be migrated to other healthy pages.

OK, so now you're wanting to enable a core kernel feature just for the sake of a
debug feature?...

>
> Allow user to select MIGRATION if MEMORY_FAILURE is enabled.

Users shouldn't select this at all. And this is an absolutely horrible way of
resolving whatever your real configuration issue is.

> Also, select MIGRATION by default if MEMORY_FAILURE is enabled.

Why? You've not made a case for this at all.

Tell us what your config actually is instead of doing a hack please.

>
> Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
> ---
>  mm/Kconfig | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 8a24c130d008..b4c217383b51 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -682,7 +682,8 @@ config NUMA_MIGRATION
>  	  demotion for memory tiering.
>
>  config MIGRATION
> -	bool
> +	bool "Enable page migration" if MEMORY_FAILURE
> +	default y if MEMORY_FAILURE

I hate hate hate this. This is just completely the wrong resolution.


>  	depends on MMU
>
>  config DEVICE_MIGRATION
> --
> 2.55.0
>

--
Cheers, Lorenzo

