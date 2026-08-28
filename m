Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAF10C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 16:51:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 024C56B008A; Fri, 28 Aug 2026 12:51:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F17D26B008C; Fri, 28 Aug 2026 12:51:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2E1D6B0092; Fri, 28 Aug 2026 12:51:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B76ED6B008A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 12:51:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 34DADC047E
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 16:51:19 +0000 (UTC)
X-FDA: 85151268678.05.64B6219
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1688080003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 16:51:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="d/1vtvYC";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf02.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787935877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xPKA4dqMFkjx4RSuFvBFENsWoT8+rV2iEBjMHZL6H5Y=;
	b=UCmQfS4GCRYIaq6HERXCUtbHlgQG0JKV09xAIsSc8AKXgwL8BXjFWc8ZCRP7OhMAe47fVU
	Y20HaQu+P8GaT2Hp+maWs35jiLy4NtmkCGgBviS2foUQ6Y8VQiLaMAo3w8NMtzkAviNIhu
	SiC906o6JDq8//IFxBiutLlPr1wPPb0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="d/1vtvYC";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf02.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787935877;
	b=3/8+Ik16cavTHh1FoNrU4aqHaBXupMRqi2Q1iXY0CQ2aSXFa+c67AOlhiICSg/8iol+1iO
	cNKIkOzMuy0cZB8UhjSwV+hEb2EpQDxfDu/STfP99lSUDxpeiGnF5YJDtxxjL9SPLtIXvu
	rjmPe8tbuhun684UDM0egn8qjzigt7I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=xPKA4dqMFkjx4RSuFvBFENsWoT8+rV2iEBjMHZL6H5Y=; b=d/1vtvYCyw2ZRdg3dvLwcagxFd
	8dxh+CV4TIZTC2NLYU2cNkV2DJ6/6HaA9CKjFeu5Rl00igONQvT0ID4r4scRd5Cn8Y+rKF6tePtkx
	PpBujuzC2V2rjTVKBS3RYF7lDZnwF89heFzZjjLB+0FfzLDeLH3nWsAbUFKtZNBAGmf1mY7GI3uME
	lPQE85hv0dsonNETIMEoZ4Jba+ZAh/Ehx6/Os/hG6vcaPW5ivLUjuEVnnybi4IkAjUvBedjzL/+5d
	m5wX0yEfWN2A9ON1vUIklnnzAcAdzgBZRgDB5q7Pm/DXi4lp92+Bi8+Vwt/qLm2EabXsYEBgmtIm6
	sFOgFJWQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wzznP-0000000F8I0-2KJ6;
	Fri, 28 Aug 2026 16:51:15 +0000
Date: Fri, 28 Aug 2026 17:51:15 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [GIT PULL] Remove dependencies on pagemap.h
Message-ID: <apG8g-5krNRUFUuD@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: a3zem1fpjhf18xqnjhk9tu9ajsrakd6i
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1688080003
X-Rspam-User: 
X-HE-Tag: 1787935876-562296
X-HE-Meta: U2FsdGVkX1+/Jx0NnCwl9DjumQ5aiOH5LF52VsjiRbBSRqNgHgDkmXEl8LjFqYFSevhkUzDwuOuuoGCTkJN1IHggLutdrhRVRGwMHIQVJB4N4jGWWzNfhQmES1gGaP4izurt7P9pVhEf+j3wMMNh/LNBwEy7kP3PT0o4J8A+OvaNBgNHdL2U/2QCBLCWnz1WEoEAgEyzJPIJYSVLuUW87t5eMFcqxM3iZlh0hkpxOwJab2u3VaCe0pSuWay3sqwSGoOI60NzDqUMg1fHo5vE9AZCqetSzxGzk3NF3T01G/L8QNlHS7IofBL7VEr9wjUafuD0v7XCRSJN9JUIYoFbpEGnxI1tiqeRhDtOTyFMk6PnIvkOSQInC7EQxZDLI681d1TODLKo5ICByAgq7yxFMlpXmaNxIUTeipKwu3w/vKjR1LsCb9c5NWauX0J2+BwPe4zQgBTvRnlgeBj+MXyGKMSo0TNdh8IbJKH7VW/il6UFDYA7ULksi02bus09BOjRXmXBy/C/IkKG/K1cTDhdlQrwNl9apgtR1l4vxhbh3ql3tB/f+JzqWjPnHD8b/jpaz5oWp+DjAtSY9lA5vEOg1joJWIM9U/KM4g2AFA+Bm8W6NofWMNkcg1x3LdeMTlTJiheWy4h2uWtGx9giawneFXJ92mjVQmnFnqM/x3P/AstKcnosOiCYcwcNgcdJxgSAr/dACqDd541LXgBoKzxDy4ZVThwVEY6Nt3MEIB/nn2oMThEFAl8KEtOM4wU0VOWZqaVQoAExcRl/2U66TJ8C+ykhWTSGIehvUPPYLIcbbjWu+fUL5oNCxmnicf6eq7JW8YGrgr3T97xg0z2fuGJpNkLjIGmYCEBwJOi0n8PI78v0zQ7pQuJSMMgBsz53ioZaduNN4R7+ckzjz0K4v2zj3loNi++kEB0B9j0kBsuMj/etOOMS4b2GQctCnYjp1slsJ3GnkVhFVahlWJqGETM
 Fi287b0b
 Kb5sgCDAlxBj/lt057SMC5LaK9Gk3r0/Mxl+Ettv0bc4EgBiRg3w7bHaMfN2l/qKXWte8rbsKSKivBXFoD1qhiMKmbOAA5EGEB5Czypq0Vo88aCp/nhcKUPjooWOkdjpYfW6qkjjxANhlFoCyYDNSZTSAn53y0eojIWe6S7IMDIed300n88iaLxAJVGkm7r4RnoUpQg9+46DoKnE7KqqMOTXHGB1gHl2O4uiSWapWMKlDpZAEjvgZp9GJa1miQe5laplDbkqQuTMOFjiw96XS4oKdCwFPysogg8rbFxUBKVYEQ8acaeInzAX97lnMdcSAf+V44PoGXUYIV04=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

My apologies for not sending you a signed tag.  I haven't used it in so
long that I've forgotten my passphrase on that key.  Here's what would
have been in the commit tag message:

Remove unnecessary dependencies on pagemap.h

pagemap.h contains primarily page cache functions.  Currently around
9100 files (x86 allmodconfig) depend on it, mostly unnecessarily.
This series reduces that to around 1400 and unsnarls a few other headers
a little.

The following changes since commit b6b019a1d9b90ac51174f0ca15b1338b61506bf9:

  Merge tag 'parisc-for-7.3-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux (2026-08-23 10:30:02 -0700)

are available in the Git repository at:

  git://git.infradead.org/users/willy/pagecache.git tags/headers-7.2

for you to fetch changes up to e02cb91d4644dfff593146f89e70d2008cc6ac16:

  ksm: Remove pagemap.h include (2026-08-25 15:12:27 -0400)

----------------------------------------------------------------
Matthew Wilcox (Oracle) (21):
      alpha: Fix pgd_t dependency
      arc: Fix pgd_t dependency
      microblaze: Fix pgd_t dependency
      sh: Fix pgd_t dependency
      sparc: Fix pgd_t dependency
      headers: Remove swap.h from suspend.h
      agp: Remove pagemap includes
      arch: Remove pagemap.h from arch includes
      security: Remove pagemap.h includes
      mm: Remove pagemap.h from mempolicy.h
      balloon: Remove pagmap.h include
      drivers/net: Remove includes of pagemap.h
      drivers/media: Remove pagemap.h includes
      drivers/mmc: Remove pagemap.h includes
      drm: Remove pagemap from ttm_tt.h header
      drm/amd: Remove pagemap.h includes
      headers: Remove pagemap.h from swap.h
      sunrpc: Remove pagemap.h
      net: Remove includes of pagemap.h
      nfs: Remove pagemap.h from includes
      ksm: Remove pagemap.h include

 arch/alpha/include/asm/pgtable.h                   |  2 +-
 arch/arc/include/asm/Kbuild                        |  1 +
 arch/arc/include/asm/pgtable-levels.h              |  2 ++
 arch/arc/include/asm/tlb.h                         | 12 ----------
 arch/arm/include/asm/pgalloc.h                     |  2 --
 arch/arm/include/asm/tlb.h                         |  2 --
 arch/arm/mach-pxa/pxa3xx.c                         |  1 +
 arch/arm64/include/asm/tlb.h                       |  3 ---
 arch/hexagon/include/asm/tlb.h                     |  1 -
 arch/microblaze/include/asm/pgtable.h              |  2 +-
 arch/nios2/include/asm/tlb.h                       |  1 -
 arch/openrisc/include/asm/Kbuild                   |  1 +
 arch/openrisc/include/asm/tlb.h                    | 26 ----------------------
 arch/powerpc/include/asm/tlb.h                     |  2 --
 arch/sh/include/asm/pgtable.h                      |  2 +-
 arch/sh/include/asm/tlb.h                          |  1 -
 arch/sparc/include/asm/pgtable_64.h                |  2 +-
 arch/sparc/include/asm/tlb_64.h                    |  1 -
 arch/x86/include/asm/pgalloc.h                     |  1 -
 arch/x86/virt/vmx/tdx/tdx.c                        |  1 +
 arch/xtensa/kernel/hibernate.c                     |  1 +
 block/fops.c                                       |  1 +
 drivers/char/agp/backend.c                         |  1 -
 drivers/char/agp/generic.c                         |  1 -
 drivers/char/agp/intel-agp.c                       |  1 -
 drivers/char/agp/intel-gtt.c                       |  1 -
 drivers/char/agp/uninorth-agp.c                    |  3 ++-
 drivers/dma/ste_dma40.c                            |  1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |  1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |  1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c            |  1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |  3 +--
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c           |  1 +
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h              |  1 -
 drivers/gpu/drm/display/drm_dp_cec.c               |  1 +
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c              |  1 +
 drivers/gpu/drm/i915/display/intel_display_power.c |  1 +
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c        |  1 +
 drivers/gpu/drm/msm/msm_fb.c                       |  2 ++
 drivers/gpu/drm/msm/msm_gem_shrinker.c             |  2 ++
 drivers/gpu/drm/nouveau/nouveau_dmem.c             |  1 +
 drivers/gpu/drm/omapdrm/dss/hdmi4.c                |  1 +
 drivers/gpu/drm/omapdrm/dss/hdmi5.c                |  1 +
 drivers/gpu/drm/panel/panel-ilitek-ili9806e-core.c |  1 +
 drivers/gpu/drm/panfrost/panfrost_gem.c            |  2 ++
 drivers/gpu/drm/panthor/panthor_gem.c              |  3 +++
 drivers/hwmon/pmbus/pmbus_core.c                   |  1 +
 drivers/i2c/busses/i2c-amd-asf-plat.c              |  1 +
 drivers/i2c/busses/i2c-gxp.c                       |  1 +
 drivers/i2c/busses/i2c-k1.c                        |  1 +
 drivers/i2c/busses/i2c-pasemi-platform.c           |  1 +
 drivers/iio/accel/fxls8962af-core.c                |  1 +
 drivers/iio/adc/nct7201.c                          |  1 +
 drivers/iio/adc/ti-ads1298.c                       |  1 +
 drivers/iio/light/rohm-bu27034.c                   |  1 +
 drivers/iio/pressure/bmp280-core.c                 |  1 +
 drivers/iio/pressure/bmp280.h                      |  1 +
 drivers/input/misc/aw86927.c                       |  1 +
 drivers/input/touchscreen/goodix_berlin_core.c     |  1 +
 drivers/input/touchscreen/hynitron_cstxxx.c        |  1 +
 drivers/input/touchscreen/imagis.c                 |  1 +
 drivers/leds/leds-turris-omnia.c                   |  1 +
 drivers/media/common/videobuf2/frame_vector.c      |  1 -
 drivers/media/pci/cx18/cx18-driver.h               |  1 -
 drivers/media/pci/ivtv/ivtv-driver.h               |  2 +-
 drivers/media/platform/st/stm32/stm32-csi.c        |  1 +
 drivers/media/platform/ti/omap3isp/ispvideo.c      |  1 -
 drivers/media/usb/go7007/go7007-v4l2.c             |  1 -
 drivers/media/usb/gspca/gspca.c                    |  1 -
 drivers/mfd/88pm886.c                              |  1 +
 drivers/mfd/abx500-core.c                          |  1 +
 drivers/mfd/adp5585.c                              |  1 +
 drivers/mfd/cs40l50-core.c                         |  1 +
 drivers/mfd/cs42l43.c                              |  1 +
 drivers/mfd/rt5120.c                               |  1 +
 drivers/mfd/tps65219.c                             |  1 +
 drivers/mfd/twl-core.c                             |  2 +-
 drivers/mmc/core/core.c                            |  1 -
 drivers/mmc/core/host.c                            |  1 -
 drivers/mmc/host/renesas_sdhi_internal_dmac.c      |  1 -
 drivers/mmc/host/renesas_sdhi_sys_dmac.c           |  1 -
 drivers/mmc/host/sh_mmcif.c                        |  1 -
 drivers/mmc/host/tmio_mmc.h                        |  1 -
 drivers/mmc/host/tmio_mmc_core.c                   |  1 -
 drivers/mmc/host/usdhi6rol0.c                      |  1 -
 drivers/net/ethernet/atheros/atl1c/atl1c.h         |  1 -
 drivers/net/ethernet/atheros/atl1e/atl1e.h         |  1 -
 drivers/net/ethernet/intel/e1000/e1000.h           |  1 -
 drivers/net/ethernet/intel/e1000e/netdev.c         |  1 -
 drivers/net/ethernet/intel/igb/igb_main.c          |  1 -
 drivers/net/ethernet/intel/igbvf/netdev.c          |  1 -
 drivers/phy/st/phy-stm32-combophy.c                |  1 +
 drivers/pinctrl/pinctrl-sx150x.c                   |  1 +
 drivers/platform/arm64/huawei-gaokun-ec.c          |  1 +
 drivers/platform/arm64/lenovo-yoga-c630.c          |  2 +-
 .../platform/x86/intel/int3472/clk_and_regulator.c |  1 +
 drivers/power/supply/bq25630_charger.c             |  1 +
 drivers/power/supply/rk817_charger.c               |  2 +-
 drivers/regulator/fixed.c                          |  1 +
 drivers/regulator/fp9931.c                         |  1 +
 drivers/regulator/mt6360-regulator.c               |  1 +
 drivers/regulator/qcom-labibb-regulator.c          |  1 +
 drivers/regulator/rtq2208-regulator.c              |  1 +
 drivers/regulator/tps65185.c                       |  1 +
 drivers/regulator/tps65219-regulator.c             |  1 +
 drivers/regulator/tps6594-regulator.c              |  1 +
 drivers/soc/xilinx/zynqmp_power.c                  |  1 +
 drivers/ufs/host/ufs-mediatek.c                    |  1 +
 drivers/ufs/host/ufs-qcom.c                        |  1 +
 drivers/usb/core/hcd.c                             |  1 +
 drivers/usb/typec/mux/it5205.c                     |  1 +
 drivers/usb/typec/wusb3801.c                       |  1 +
 drivers/video/fbdev/core/fb_procfs.c               |  1 +
 drivers/xen/balloon.c                              |  1 +
 fs/aio.c                                           |  1 +
 fs/buffer.c                                        |  1 +
 fs/file_table.c                                    |  1 +
 fs/inode.c                                         |  1 +
 fs/nfs/blocklayout/blocklayout.c                   |  1 +
 fs/nfs/nfs42proc.c                                 |  1 +
 fs/nfs/nfstrace.h                                  |  1 +
 fs/nfs/pnfs.c                                      |  1 +
 fs/nfsd/nfs4proc.c                                 |  1 +
 include/drm/drm_print.h                            |  1 +
 include/drm/ttm/ttm_tt.h                           |  1 -
 include/linux/balloon.h                            |  1 -
 include/linux/ceph/libceph.h                       |  1 -
 include/linux/i3c/master.h                         |  1 +
 include/linux/ksm.h                                |  1 -
 include/linux/mempolicy.h                          |  1 -
 include/linux/nfs_fs.h                             |  1 -
 include/linux/nfs_page.h                           |  1 -
 include/linux/suspend.h                            |  1 -
 include/linux/swap.h                               |  1 -
 include/sound/cs35l41.h                            |  1 +
 kernel/power/snapshot.c                            |  1 +
 net/ceph/osd_client.c                              |  1 -
 net/ceph/pagevec.c                                 |  1 +
 net/core/datagram.c                                |  1 -
 net/rds/rdma.c                                     |  1 -
 net/sunrpc/auth_gss/auth_gss.c                     |  1 -
 net/sunrpc/auth_gss/gss_krb5_crypto.c              |  1 -
 net/sunrpc/auth_gss/gss_krb5_wrap.c                |  1 -
 net/sunrpc/auth_gss/svcauth_gss.c                  |  1 -
 net/sunrpc/cache.c                                 |  1 -
 net/sunrpc/rpc_pipe.c                              |  1 -
 net/sunrpc/socklib.c                               |  1 -
 net/sunrpc/xdr.c                                   |  1 -
 net/sunrpc/xprtsock.c                              |  1 -
 security/commoncap.c                               |  3 ---
 security/inode.c                                   |  1 -
 security/selinux/hooks.c                           |  1 -
 security/selinux/selinuxfs.c                       |  1 -
 security/smack/smack_lsm.c                         |  1 -
 sound/soc/codecs/cs35l41-lib.c                     |  1 +
 155 files changed, 98 insertions(+), 118 deletions(-)
 delete mode 100644 arch/arc/include/asm/tlb.h
 delete mode 100644 arch/openrisc/include/asm/tlb.h


