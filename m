Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22D58EDB7CC
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 08:57:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B2BA6B0088; Tue,  7 Apr 2026 04:57:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 463C86B0089; Tue,  7 Apr 2026 04:57:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 351ED6B008A; Tue,  7 Apr 2026 04:57:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 237466B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 04:57:19 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A7EE91A0511
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:57:18 +0000 (UTC)
X-FDA: 84631155756.15.094441C
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf07.hostedemail.com (Postfix) with ESMTP id D497640011
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:57:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=RZP7wrMK;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf07.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775552236; a=rsa-sha256;
	cv=none;
	b=iGlvYnyEl/nEQt5MLdwHEqXyf0+d33viZcCNTyCXfsbTnwq5jhOwdqnb5c+yP4b7G4LUQH
	L3vPVFnQuREharJP3ynyyrtMq9ZgF7u4NWICqDGXr4OKJp0DDHl2FBaQYlTDO2VZtU+pVT
	awkiliuof9c/hhMFy2UJ/RxoQdVtmQE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=RZP7wrMK;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf07.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775552236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j6bI40rFXjnNi4xEhtGuTS96Jn2uqw2dljQ1TolNlrY=;
	b=izw34AFrUTG4bwpdQGu3/Bsz7gSFrfs47mh0tRMlyuK4WO1wAfdv3QXgLrR/VHvDJtS/SD
	OoqibzYxkGYwBc2Gdjt0jZliVq9I6JhVZ/7nPX/bytHwGQ667P7Sjz+SxAqOZTd1gkD5NU
	m1Y1loQFx057Ifdn6ToHSTQ3+oHNbFQ=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260407085713euoutp02484e5c0096fb3401393786106c0ad46c~kB1lTWUb70378703787euoutp02j
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:57:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260407085713euoutp02484e5c0096fb3401393786106c0ad46c~kB1lTWUb70378703787euoutp02j
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1775552233;
	bh=j6bI40rFXjnNi4xEhtGuTS96Jn2uqw2dljQ1TolNlrY=;
	h=Date:From:Subject:To:Cc:In-Reply-To:References:From;
	b=RZP7wrMKzjWpTNSEshTsXiJTw8AOOP1zOFBBv3tS71vQiKtLXKVltuDeWF8EcIlfM
	 zElp9QyxfncUuCiEwOUWl9FjZN1RcG+kB8hUgcqxg2h6EcoSs1h0Ivn4/iGzNp9W9Y
	 Hbg61O3FN+HxRRDMyEpK+gegKhATJxWzq1dImPGc=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260407085713eucas1p2511c88350d65a30746d62a99c13306c5~kB1lHOMuj1628516285eucas1p2J;
	Tue,  7 Apr 2026 08:57:13 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260407085711eusmtip2e1ec49f71f6ce486832315b6cf927c28~kB1jYPioW0291302913eusmtip27;
	Tue,  7 Apr 2026 08:57:11 +0000 (GMT)
Message-ID: <e65750d2-7e1a-4e4a-acd9-ab4c4d0a2055@samsung.com>
Date: Tue, 7 Apr 2026 10:57:10 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v5 0/9] driver core: Fix some race conditions
To: Douglas Anderson <dianders@chromium.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>, Alan Stern <stern@rowland.harvard.edu>
Cc: Leon Romanovsky <leon@kernel.org>, Christoph Hellwig <hch@lst.de>, Robin
	Murphy <robin.murphy@arm.com>, driver-core@lists.linux.dev,
	iommu@lists.linux.dev, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org, linux-usb@vger.kernel.org,
	linux@armlinux.org.uk
Content-Language: en-US
In-Reply-To: <20260406232444.3117516-1-dianders@chromium.org>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260407085713eucas1p2511c88350d65a30746d62a99c13306c5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260406232527eucas1p2faa678aa90f0636bd17e0a7f4cb8fa28
X-EPHeader: CA
X-CMS-RootMailID: 20260406232527eucas1p2faa678aa90f0636bd17e0a7f4cb8fa28
References: <CGME20260406232527eucas1p2faa678aa90f0636bd17e0a7f4cb8fa28@eucas1p2.samsung.com>
	<20260406232444.3117516-1-dianders@chromium.org>
X-Rspamd-Queue-Id: D497640011
X-Stat-Signature: a9h1xrg1so1e5x76aczmedh4ontjf5h3
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775552235-116915
X-HE-Meta: U2FsdGVkX1828k3iSCMqrYFHldsa8DXRVQ7RSCMsQDTacW4aDOHy4l3xgvRt54sU9WVA93twDRIVzMeiDV47xdjNf2qRrrNobNXNSkC40vZ233OLdusC9BQo2t3iND+t+HC9KRLrEktWyIyAb92npFFayfkMAKzERPDTHDLD5GHDDvF+pM4aurTV4LF1vDwQcZZPFImSiBx2sf1yoKild/+C7dlg0/RqG6uoFIY2DZEsOZz7wgfMOlTR+a6cHvdPom5qMKuclBDY5n+BW9qey1/l/oFAy/gQMVbtMnawNp95u4Y8dDp6/sTyBP+AEp8LJkgqso29Yk4OU4pqzG+1oapiNeZ075yuc/NEmUv8/9TlvHaH2MwkTUupMEuRVpTYMmgBklAePIGVWqLT70R+5KxUg9QC68S8LxCKEKTZ0iCytvK88wwcux/1RLQeOAtTCznCNHH64uOAoY/antBV/XxSqfXxypUzlS2k4PVSp8onK43IvROd8L7UtLWgr6y75L5tdnK6ohN0jGUCIKsMgwu6aw37xm5KJ8tBq0KxxbmPIDopCBE9HiDXCUUO3KsuDgXOsIO8gN1NW3pVXJPX/NgiohmQGaW3IEaehMhxDYR7YXTiJQpC5vOjqpbH6iNboKmDr5/1Sf6Byik3vcNSrge8VhN9t5j5LtDml7rsxl6Q3lMhAen2moxX59d2vI4+QNjWrISRMcptvHwQyWEnbR55cpnco57mC4Zs6/KPaej6FneI+prDrjXxNNyeD+m3alqB1tEZzRNyf/p003XDS6F5w8GKr42RCBPoYZSD/kKAwhmI09aH++0R7vmpvLnwAE71Xp8tDa/0zzqhKYTHEXpZlFqisu1fXqzUkE8U/VLhnOS3wQZClBpovj4ZpDlZO7xtgV+jE95PAm8N27hQB7qtvebbkgDRHjMekGyRKx+c8N6Up0MeA7j42UbB2wS1yhRuJxmU+ROB9+Q/NJc
 qOk2EBUj
 /yw3t2OOruTN4m8bP8BWUEPPiEhmNnANDhWcnli10rrX8SljJZWcwrmfTMLS7S6PKnG8ghYLGcTFbatQubr+N1cbrQu4oU7VpqikXiNMn0KlG4UTJu+PNnaIBmlTP81+pTYZHXCc6z3ESqieIUY5/c/BmdJZFxdGBXeAa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 07.04.2026 01:22, Douglas Anderson wrote:
> The main goal of this series is to fix the observed bug talked about
> in the first patch ("driver core: Don't let a device probe until it's
> ready"). That patch fixes a problem that has been observed in the real
> world and could land even if the rest of the patches are found
> unacceptable or need to be spun.
>
> That said, during patch review Danilo correctly pointed out that many
> of the bitfield accesses in "struct device" are unsafe. I added a
> bunch of patches in the series to address each one.
>
> Danilo said he's most worried about "can_match", so I put that one
> first. After that, I tried to transition bitfields to flags in reverse
> order to when the bitfield was added.
>
> Even if transitioning from bitfields to flags isn't truly needed for
> correctness, it seems silly (and wasteful of space in struct device)
> to have some in bitfields and some as flags. Thus I didn't spend time
> for each bitfield showing that it's truly needed for correctness.
>
> Transition was done semi manually. Presumably someone skilled at
> coccinelle could do a better job, but I just used sed in a heavy-
> handed manner and then reviewed/fixed the results, undoing anything my
> script got wrong. My terrible/ugly script was:
>
> var=can_match
> caps="${var^^}"
> for f in $(git grep -l "[>\.]${var}[^1-9_a-zA-Z\[]"); do
>   echo $f
>   sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)->${var} = true/set_bit(DEV_FLAG_${caps}, \&\\1->flags)/" "$f"
>   sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)\.${var} = true/dev_set_${caps}(\&\\1)/" "$f"
>   sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)->${var} = false/clear_bit(DEV_FLAG_${caps}, \&\\1->flags)/" "$f"
>   sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)\.${var} = false/dev_clear_${caps}(\&\\1)/" "$f"
>   sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)->${var} = \([^;]*\)/assign_bit(DEV_FLAG_${caps}, \&\\1->flags, \\2)/" "$f"
>   sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)\.${var} = \([^;]*\)/dev_assign_${caps}(\&\\1, \\2)/" "$f"
>   sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)->${var}\([^1-9_a-zA-Z\[]\)/test_bit(DEV_FLAG_${caps}, \&\\1->flags)\\2/" "$f"
>   sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)\.${var}\([^1-9_a-zA-Z\[]\)/dev_${caps}(\&\\1)\\2/" "$f"
> done
>
> From v3 to v4, I transitioned to accessor functions with another ugly
> sed script. I had git format the old patches, then transformed them
> with:
>
> for f in *.patch; do
>   echo $f
>   sed -i~ -e "s/test_and_set_bit(DEV_FLAG_\([^,]*\), \&\(.*\)->flags)/dev_test_and_set_\\L\\1(\\2)/" "$f"
>   sed -i~ -e "s/test_and_set_bit(DEV_FLAG_\([^,]*\), \(.*\)\.flags)/dev_test_and_set_\\L\\1(\\2)/" "$f"
>   sed -i~ -e "s/test_bit(DEV_FLAG_\([^,]*\), \&\(.*\)->flags)/dev_\\L\\1(\\2)/" "$f"
>   sed -i~ -e "s/test_bit(DEV_FLAG_\([^,]*\), \(.*\)\.flags)/dev_\\L\\1(\\2)/" "$f"
>   sed -i~ -e "s/set_bit(DEV_FLAG_\([^,]*\), \&\(.*\)->flags)/dev_set_\\L\\1(\\2)/" "$f"
>   sed -i~ -e "s/set_bit(DEV_FLAG_\([^,]*\), \(.*\)\.flags)/dev_set_\\L\\1(\\2)/" "$f"
>   sed -i~ -e "s/clear_bit(DEV_FLAG_\([^,]*\), \&\(.*\)->flags)/dev_clear_\\L\\1(\\2)/" "$f"
>   sed -i~ -e "s/clear_bit(DEV_FLAG_\([^,]*\), \(.*\)\.flags)/dev_clear_\\L\\1(\\2)/" "$f"
>   sed -i~ -e "s/assign_bit(DEV_FLAG_\([^,]*\), \&\(.*\)->flags, \(.*\))/dev_assign_\\L\\1(\\2, \\3)/" "$f"
>   sed -i~ -e "s/assign_bit(DEV_FLAG_\([^,]*\), \(.*\)\.flags, \(.*\))/dev_assign_\\L\\1(\\2, \\3)/" "$f"
> done
>
> ...and then did a few manual touchups for spacing.
>
> I only marked the first patch as a "Fix" since it is the only one
> fixing observed problems. Other patches could be considered fixes too
> if folks want.
>
> I tested the first patch in the series backported to kernel 6.6 on the
> Pixel phone that was experiencing the race. I added extra printouts to
> make sure that the problem was hitting / addressed. The rest of the
> patches are tested with allmodconfig with arm32, arm64, ppc, and
> x86. I boot tested on an arm64 Chromebook running mainline.
The dma-mapping related bits are probably not race prone, but if you plan
to refactor that part I won't object.

Acked-by: Marek Szyprowski


> Changes in v5:
> - ready_to_prove => ready_to_probe typo
> - device_lock() while calling dev_set_ready_to_probe()
> - Add comment before "can_match = true" from Danilo.
> - undef __create_dev_flag_accessors
>
> Changes in v4:
> - Use accessor functions for flags
>
> Changes in v3:
> - Use a new "flags" bitfield
> - Add missing \n in probe error message
>
> Changes in v2:
> - Instead of adjusting the ordering, use "ready_to_probe" flag
>
> Douglas Anderson (9):
>   driver core: Don't let a device probe until it's ready
>   driver core: Replace dev->can_match with dev_can_match()
>   driver core: Replace dev->dma_iommu with dev_dma_iommu()
>   driver core: Replace dev->dma_skip_sync with dev_dma_skip_sync()
>   driver core: Replace dev->dma_ops_bypass with dev_dma_ops_bypass()
>   driver core: Replace dev->state_synced with dev_state_synced()
>   driver core: Replace dev->dma_coherent with dev_dma_coherent()
>   driver core: Replace dev->of_node_reused with dev_of_node_reused()
>   driver core: Replace dev->offline + ->offline_disabled with accessors
>
>  arch/arc/mm/dma.c                             |   4 +-
>  arch/arm/mach-highbank/highbank.c             |   2 +-
>  arch/arm/mach-mvebu/coherency.c               |   2 +-
>  arch/arm/mm/dma-mapping-nommu.c               |   4 +-
>  arch/arm/mm/dma-mapping.c                     |  28 ++--
>  arch/arm64/kernel/cpufeature.c                |   2 +-
>  arch/arm64/mm/dma-mapping.c                   |   2 +-
>  arch/mips/mm/dma-noncoherent.c                |   2 +-
>  arch/powerpc/kernel/dma-iommu.c               |   8 +-
>  .../platforms/pseries/hotplug-memory.c        |   4 +-
>  arch/riscv/mm/dma-noncoherent.c               |   2 +-
>  drivers/acpi/scan.c                           |   2 +-
>  drivers/base/core.c                           |  55 +++++---
>  drivers/base/cpu.c                            |   4 +-
>  drivers/base/dd.c                             |  36 ++++--
>  drivers/base/memory.c                         |   2 +-
>  drivers/base/pinctrl.c                        |   2 +-
>  drivers/base/platform.c                       |   2 +-
>  drivers/dma/ti/k3-udma-glue.c                 |   6 +-
>  drivers/dma/ti/k3-udma.c                      |   6 +-
>  drivers/iommu/dma-iommu.c                     |   9 +-
>  drivers/iommu/iommu.c                         |   5 +-
>  drivers/net/pcs/pcs-xpcs-plat.c               |   2 +-
>  drivers/of/device.c                           |   6 +-
>  drivers/pci/of.c                              |   2 +-
>  drivers/pci/pwrctrl/core.c                    |   2 +-
>  drivers/regulator/bq257xx-regulator.c         |   2 +-
>  drivers/regulator/rk808-regulator.c           |   2 +-
>  drivers/tty/serial/serial_base_bus.c          |   2 +-
>  drivers/usb/gadget/udc/aspeed-vhub/dev.c      |   2 +-
>  include/linux/device.h                        | 122 ++++++++++++------
>  include/linux/dma-map-ops.h                   |   6 +-
>  include/linux/dma-mapping.h                   |   2 +-
>  include/linux/iommu-dma.h                     |   3 +-
>  kernel/cpu.c                                  |   4 +-
>  kernel/dma/mapping.c                          |  12 +-
>  mm/hmm.c                                      |   2 +-
>  37 files changed, 218 insertions(+), 142 deletions(-)
>
Best regards

-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


