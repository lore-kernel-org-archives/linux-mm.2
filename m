Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8489E63FEB
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 17:12:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB4F96B0088; Sat,  4 Apr 2026 13:12:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D65CB6B0089; Sat,  4 Apr 2026 13:12:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C54D16B008A; Sat,  4 Apr 2026 13:12:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B4BA16B0088
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 13:12:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 403C81B8B2A
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 17:12:16 +0000 (UTC)
X-FDA: 84621516672.10.6896A79
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 71F8C40002
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 17:12:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GcgJMoZ0;
	spf=pass (imf04.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775322734; a=rsa-sha256;
	cv=none;
	b=MjZ/lo6xhOJDVFiQSZuF5ckp/dKCfWldm+Dhv+5ZrgpY1sfDWwb5/Clt7aVwM1rkbqHIoK
	sHtaI67i91SEV1KxzixS0HSdaTKgg0D9rO/oGoYRdSxvZUS4RCJYOzg/HN3664pWABfx/L
	1Wky3ziQPPdCvsZ0nDO4lZiGD/Xyrno=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775322734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rjMH1/SsUECEYlZino7gffNjLbrHGi2A1dFabhVdjMs=;
	b=GwV87RALCBe3rOKq1OCB+inT7Jz2WW9EbFeqDSsw8VLnOjJZTYYE8Fw44Jo4c8bFoiftuH
	Cana9KdcbkDJqNCoGWxJkjhIgcftt10AMjnxTZ5RD8XKYxCvK96Frb/PburKLZnWSeh1rF
	vuGMHoGSWF1xYbUTc2iH/mBanttgETU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GcgJMoZ0;
	spf=pass (imf04.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 614ED4455B
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 17:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CEB8C2BCB9
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 17:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775322733;
	bh=6HWbdXTvY5ARCKQw/mJejk6jJkYYvhLGzuFZu/CMKrk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GcgJMoZ0JuCk1oE2p1uOznAEPZR6CrHmU63ZoUxVtxnX8mJab0r4uPFFxlAmTqcZA
	 myj15f5ytltHO0slbfE7HO6gmrYbw3URX3zm5Ch5rWSlVdR401ec5dfg7RfsH5oBN4
	 PnqK3oN/0RY4LZWR+knx2bZtXfIc8cep3MmTai8iVDgIiE9nPWWVN8CVFPKdI3F70S
	 gC8kQiqGR2CuAUPcJ/9Yaydp3RzrBUC+10/bPsY353+aL5ufFQEdpAgg8xvos3Up3I
	 owNuHEnPhFIkScgSgy7tm8cpYaSl2vK6VDp57FI0G+Yzb2m579C7WS8lt58GdxocpN
	 fGfJdiBZK7yLg==
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-40ede943bf0so1601773fac.2
        for <linux-mm@kvack.org>; Sat, 04 Apr 2026 10:12:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUWLiOqHMDv2iMno8Wk36yGrgOrNjKNW50Vte9FvTESYcRKm3+YLNyh9dv6lCidHWWFtAA5WAad0A==@kvack.org
X-Gm-Message-State: AOJu0Yx61OVphaSgSncyFRZSuFfU7y4yYJmNpa7MA+5VoO7OfQUEnLlj
	coo2xs/3zBA/hXzP4qb/fMqb+W5fDIacU/MjLHtSLJOflM8NWWSl/Ng0tY4c0jNsEFOHP759szu
	INZeELgzjA1ua6kphuxWBgqTXF9uQrzo=
X-Received: by 2002:a05:6871:581e:b0:422:cd76:929d with SMTP id
 586e51a60fabf-4230fd2d9e4mr3996409fac.18.1775322730928; Sat, 04 Apr 2026
 10:12:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260404000644.522677-1-dianders@chromium.org>
In-Reply-To: <20260404000644.522677-1-dianders@chromium.org>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Sat, 4 Apr 2026 19:11:59 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0hRKyPesMGKGoDZEMDCX-GVw6Z-dxMLhNhwy6Kjz=7MCQ@mail.gmail.com>
X-Gm-Features: AQROBzCS1sK1yep87rT-2xolltVfQ4j4qlt-9lHai0wQJnu4V3tzUHOX8_7jVCo
Message-ID: <CAJZ5v0hRKyPesMGKGoDZEMDCX-GVw6Z-dxMLhNhwy6Kjz=7MCQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/9] driver core: Fix some race conditions
To: Douglas Anderson <dianders@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Alan Stern <stern@rowland.harvard.edu>, 
	Saravana Kannan <saravanak@kernel.org>, Christoph Hellwig <hch@lst.de>, Eric Dumazet <edumazet@google.com>, 
	Johan Hovold <johan@kernel.org>, Leon Romanovsky <leon@kernel.org>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Alexey Kardashevskiy <aik@ozlabs.ru>, 
	Robin Murphy <robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Frank.Li@kernel.org, 
	Jason Gunthorpe <jgg@ziepe.ca>, alex@ghiti.fr, alexander.stein@ew.tq-group.com, 
	andre.przywara@arm.com, andrew@codeconstruct.com.au, andrew@lunn.ch, 
	andriy.shevchenko@linux.intel.com, aou@eecs.berkeley.edu, ardb@kernel.org, 
	bhelgaas@google.com, brgl@kernel.org, broonie@kernel.org, 
	catalin.marinas@arm.com, chleroy@kernel.org, davem@davemloft.net, 
	david@kernel.org, devicetree@vger.kernel.org, dmaengine@vger.kernel.org, 
	driver-core@lists.linux.dev, gbatra@linux.ibm.com, 
	gregory.clement@bootlin.com, hkallweit1@gmail.com, iommu@lists.linux.dev, 
	jirislaby@kernel.org, joel@jms.id.au, joro@8bytes.org, kees@kernel.org, 
	kevin.brodsky@arm.com, kuba@kernel.org, lenb@kernel.org, lgirdwood@gmail.com, 
	linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-aspeed@lists.ozlabs.org, linux-cxl@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-serial@vger.kernel.org, linux-snps-arc@lists.infradead.org, 
	linux-usb@vger.kernel.org, linux@armlinux.org.uk, 
	linuxppc-dev@lists.ozlabs.org, m.szyprowski@samsung.com, maddy@linux.ibm.com, 
	mani@kernel.org, maz@kernel.org, miko.lenczewski@arm.com, mpe@ellerman.id.au, 
	netdev@vger.kernel.org, npiggin@gmail.com, osalvador@suse.de, 
	oupton@kernel.org, pabeni@redhat.com, palmer@dabbelt.com, 
	peter.ujfalusi@gmail.com, peterz@infradead.org, pjw@kernel.org, 
	robh@kernel.org, sebastian.hesselbarth@gmail.com, tglx@kernel.org, 
	tsbogend@alpha.franken.de, vgupta@kernel.org, vkoul@kernel.org, 
	will@kernel.org, willy@infradead.org, yangyicong@hisilicon.com, 
	yeoreum.yun@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 71F8C40002
X-Stat-Signature: epm1zha7k5mqzr14m8okf93qi9inwgk4
X-HE-Tag: 1775322734-71862
X-HE-Meta: U2FsdGVkX18lfe/RXj/AFm6GmR9YJu/phEeaLpHfbCLxA12e+KciGmhFHMSEPIzKv44YyeqkqSy6auZn51BvlpPUbQP1h8yhvhHRf6ts1eUk/jqevQ8ubAoiNWy2P+q4PEhwRiV8BvbxFf3ea1bwj5UzzyFeEn7hKOkYgwmI2EEo6qFf7FUEoJ5Q/SGDZPSwL0yYTpVlaAisrjE5aVDqI60ruQrVGujztwBatLcn+aYrp6RIvIWxpXDwKOxGZtahQHJlMWTPgJYBBE7ZeN8Mgb3Gvhs/gcFfwDKkg0/ydK4XQduSfv4miPz9a3Rb/J0aqLUqVF7/DoKua3XLZO1RncZ4047q0FDwiGtGIN9Xn4sIBmpqsMszjR2ROqn9UvXB/ZVlz9gXMQOonE9UqKrNrMz1aPqEUG2JOgaFndNjjA0bvPTQ42AvlTnHAJvxc31g9mpjyiPPs7KoPHJau4o03jEeuZthtcgZej01SguEPtH70YGb6uVZb7DceReHWGAOqNilk8z+/QXkExzsOkNqrELnv2DjK9/acvl07Hnqj5+gbwYsLLGwxZVfZZ57T0Y7dOcfKmhMo1boMH3LrRusKSb9ZcMYqC4hhFlz9rAnfx4aMIgfuROfrE/TAxgWAVgA5/DnnxQcmW2geYyxkjgGhsUMCs3KF1GRpvtUvxJci/G66u7cz0Gng74pwQx/K6NtNN+/tklryRgKxb2Iuo5YRZkCViQVNDGfmx/9wVxqQ9u8KhN+itATkoIQtnd8kekwjljAW1AvAS1KKIHS48AZ96RSoABsIkFReGDJuCx9mRmkcWuqRwrHHD57fnMnQ4cR3UlAyDo+3I7tc4PRP3VPfz6Q1+d5k0Kv88CkWCwhPYXgbKUBwzvOPH4FbDUIcJCeGBFM837dWUo3LcW9zZHnAVeIBitgZJpnkOE7AxJRNClOg4G2xHYyDj2MxJGjZfz1Fz7ylM3Tjz2tabZQkvU
 daGytuJY
 VmvkfrDfV3h0ukRkDLNKKmt7SIgtyeVTWNuYh/0Lc67jb8WOFANiDm69VyqZ5o+h+n7vN0pShUP8Fl+BkHCTbaxTy7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 4, 2026 at 2:07=E2=80=AFAM Douglas Anderson <dianders@chromium.=
org> wrote:
>
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
> var=3Dcan_match
> caps=3D"${var^^}"
> for f in $(git grep -l "[>\.]${var}[^1-9_a-zA-Z\[]"); do
>   echo $f
>   sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)->${var} =3D tru=
e/set_bit(DEV_FLAG_${caps}, \&\\1->flags)/" "$f"
>   sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)\.${var} =3D tru=
e/dev_set_${caps}(\&\\1)/" "$f"
>   sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)->${var} =3D fal=
se/clear_bit(DEV_FLAG_${caps}, \&\\1->flags)/" "$f"
>   sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)\.${var} =3D fal=
se/dev_clear_${caps}(\&\\1)/" "$f"
>   sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)->${var} =3D \([=
^;]*\)/assign_bit(DEV_FLAG_${caps}, \&\\1->flags, \\2)/" "$f"
>   sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)\.${var} =3D \([=
^;]*\)/dev_assign_${caps}(\&\\1, \\2)/" "$f"
>   sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)->${var}\([^1-9_=
a-zA-Z\[]\)/test_bit(DEV_FLAG_${caps}, \&\\1->flags)\\2/" "$f"
>   sed -i~ -e "s/\([a-zA-Z_0-9\.>()-][a-zA-Z_0-9\.>()-]*\)\.${var}\([^1-9_=
a-zA-Z\[]\)/dev_${caps}(\&\\1)\\2/" "$f"
> done
>
> From v3 to v4, I transitioned to accessor functions with another ugly
> sed script. I had git format the old patches, then transformed them
> with:
>
> for f in *.patch; do
>   echo $f
>   sed -i~ -e "s/test_and_set_bit(DEV_FLAG_\([^,]*\), \&\(.*\)->flags)/dev=
_test_and_set_\\L\\1(\\2)/" "$f"
>   sed -i~ -e "s/test_and_set_bit(DEV_FLAG_\([^,]*\), \(.*\)\.flags)/dev_t=
est_and_set_\\L\\1(\\2)/" "$f"
>   sed -i~ -e "s/test_bit(DEV_FLAG_\([^,]*\), \&\(.*\)->flags)/dev_\\L\\1(=
\\2)/" "$f"
>   sed -i~ -e "s/test_bit(DEV_FLAG_\([^,]*\), \(.*\)\.flags)/dev_\\L\\1(\\=
2)/" "$f"
>   sed -i~ -e "s/set_bit(DEV_FLAG_\([^,]*\), \&\(.*\)->flags)/dev_set_\\L\=
\1(\\2)/" "$f"
>   sed -i~ -e "s/set_bit(DEV_FLAG_\([^,]*\), \(.*\)\.flags)/dev_set_\\L\\1=
(\\2)/" "$f"
>   sed -i~ -e "s/clear_bit(DEV_FLAG_\([^,]*\), \&\(.*\)->flags)/dev_clear_=
\\L\\1(\\2)/" "$f"
>   sed -i~ -e "s/clear_bit(DEV_FLAG_\([^,]*\), \(.*\)\.flags)/dev_clear_\\=
L\\1(\\2)/" "$f"
>   sed -i~ -e "s/assign_bit(DEV_FLAG_\([^,]*\), \&\(.*\)->flags, \(.*\))/d=
ev_assign_\\L\\1(\\2, \\3)/" "$f"
>   sed -i~ -e "s/assign_bit(DEV_FLAG_\([^,]*\), \(.*\)\.flags, \(.*\))/dev=
_assign_\\L\\1(\\2, \\3)/" "$f"
> done
>
> ...and then did a few manual touchups for spacing.
>
> NOTE: one potentially "controversial" choice I made in some patches
> was to always reserve a flag ID even if a flag is only used under
> certain CONFIG_ settings. This is a change from how things were
> before. Keeping the numbering consistent and allowing easy
> compile-testing of both CONFIG settings seemed worth it, especially
> since it won't take up any extra space until we've added a lot more
> flags.
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
>  drivers/base/core.c                           |  53 +++++---
>  drivers/base/cpu.c                            |   4 +-
>  drivers/base/dd.c                             |  28 ++--
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
>  include/linux/device.h                        | 120 ++++++++++++------
>  include/linux/dma-map-ops.h                   |   6 +-
>  include/linux/dma-mapping.h                   |   2 +-
>  include/linux/iommu-dma.h                     |   3 +-
>  kernel/cpu.c                                  |   4 +-
>  kernel/dma/mapping.c                          |  12 +-
>  mm/hmm.c                                      |   2 +-
>  37 files changed, 206 insertions(+), 142 deletions(-)
>
> --

For the whole set

Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>

