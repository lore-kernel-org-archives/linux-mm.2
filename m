Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71B08CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:00:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6CC68E0005; Fri,  3 Oct 2025 09:00:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1D4B8E0003; Fri,  3 Oct 2025 09:00:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90C1A8E0005; Fri,  3 Oct 2025 09:00:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 788EE8E0003
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:00:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1729014078A
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:00:51 +0000 (UTC)
X-FDA: 83956812702.10.5C3745B
Received: from fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.74.81.189])
	by imf21.hostedemail.com (Postfix) with ESMTP id D53DB1C0004
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:00:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="mBKV/N6H";
	spf=pass (imf21.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759496449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DpRzthrnz6JTHsOC4O+aqLHWM/bhaI69F/+S/FagesY=;
	b=A+iFltc1unlNJRBEwRDNMscYREZgy2IDiVVyqfh7PWBJWTFRfJwoQxAmwb8e6izjZxRZzQ
	MO++wDyLIs1CKAInwUoO7g/lBiOAjfrhxrLMP32me3fjmV0A5HGC+aU2vwK5HuK13VMkSq
	eKTfbdNvHVc+BBfJEvG67DGp4A7pME8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759496449; a=rsa-sha256;
	cv=none;
	b=iIin/ToYiNlOSwIycQFyKO5p1RUi57N4zJ1aAqhDFLbvYl/qy9RvmNzko28Ma5ZvVZ9tjy
	lhiXVxGGXm2SrBmfTZGbJm9jRrLli387ArK00chnWWpMuwQQG5Z2jkZKJszjK/Mg8i+tjS
	P8EmX+sEhQ9ceCl9zWmKyqfuPGNYy/s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="mBKV/N6H";
	spf=pass (imf21.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759496448; x=1791032448;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DpRzthrnz6JTHsOC4O+aqLHWM/bhaI69F/+S/FagesY=;
  b=mBKV/N6HluHl/2BfwHLl94UsZOq6MtnSOFUrZvr4fxl/Gcpsd3WnafW9
   WNM/vJUL5xR2Y0KPgJ/XdlLORb+4wLoTeL36lBlMJnlvG90QBgUxuiOoR
   5VMz5qxU9Fm+DDYtM4gqhYcp/ka1w0u/x3iOyvOAo2fd7dZr6YL7oCf00
   WRKNWMEeSpMxV/+ZKttkNVw5x5A7+hvQ+9QyIGhEufjID2AJ4pK0Rj+GG
   GMQ0h36OscyDg3DfmilEOxQsHnJi91/VD2AuozbdYri5edxrZhbh7cCei
   wiTaKxPeYSgdmbigChBs+4SuRLcIW49aErmdP85bT5/vwvyiBnMCeQU8l
   Q==;
X-CSE-ConnectionGUID: aBCG9PMxQNqBMtPRKr77WA==
X-CSE-MsgGUID: pZYBUhUbSjiqEaIzSZznhg==
X-IronPort-AV: E=Sophos;i="6.18,312,1751241600"; 
   d="scan'208";a="3062608"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 13:00:38 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:5201]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.1.16:2525] with esmtp (Farcaster)
 id 102aa012-5090-4986-8c7d-754292fc7b11; Fri, 3 Oct 2025 13:00:38 +0000 (UTC)
X-Farcaster-Flow-ID: 102aa012-5090-4986-8c7d-754292fc7b11
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 3 Oct 2025 13:00:38 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 3 Oct 2025
 13:00:13 +0000
From: Eliav Farber <farbere@amazon.com>
To: <gregkh@linuxfoundation.org>, <jdike@addtoit.com>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <dave.hansen@linux.intel.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>,
	<tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>,
	<rric@kernel.org>, <airlied@linux.ie>, <daniel@ffwll.ch>,
	<maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>,
	<tzimmermann@suse.de>, <robdclark@gmail.com>, <sean@poorly.run>,
	<jdelvare@suse.com>, <linux@roeck-us.net>, <linus.walleij@linaro.org>,
	<dmitry.torokhov@gmail.com>, <maz@kernel.org>, <wens@csie.org>,
	<jernej.skrabec@gmail.com>, <agk@redhat.com>, <snitzer@redhat.com>,
	<dm-devel@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@canonical.com>,
	<malattia@linux.it>, <hdegoede@redhat.com>, <mgross@linux.intel.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<sakari.ailus@linux.intel.com>, <clm@fb.com>, <josef@toxicpanda.com>,
	<dsterba@suse.com>, <jack@suse.com>, <tytso@mit.edu>,
	<adilger.kernel@dilger.ca>, <dushistov@mail.ru>,
	<luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>, <pmladek@suse.com>,
	<senozhatsky@chromium.org>, <andriy.shevchenko@linux.intel.com>,
	<linux@rasmusvillemoes.dk>, <minchan@kernel.org>, <ngupta@vflare.org>,
	<akpm@linux-foundation.org>, <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
	<pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
	<jmaloy@redhat.com>, <ying.xue@windriver.com>, <shuah@kernel.org>,
	<willy@infradead.org>, <farbere@amazon.com>, <sashal@kernel.org>,
	<quic_akhilpo@quicinc.com>, <ruanjinjie@huawei.com>,
	<David.Laight@ACULAB.COM>, <herve.codina@bootlin.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-um@lists.infradead.org>, <linux-edac@vger.kernel.org>,
	<amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	<linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>,
	<linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>,
	<linux-sunxi@lists.linux.dev>, <linux-media@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <linux-sparse@vger.kernel.org>,
	<linux-mm@kvack.org>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <tipc-discussion@lists.sourceforge.net>,
	<linux-kselftest@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v2 00/19 5.15.y] Backport minmax.h updates from v6.17-rc7
Date: Fri, 3 Oct 2025 12:59:47 +0000
Message-ID: <20251003130006.41681-1-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D032UWA002.ant.amazon.com (10.13.139.81) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D53DB1C0004
X-Stat-Signature: 4sokqgwqka6w91355tpxabht813hpwa8
X-Rspam-User: 
X-HE-Tag: 1759496448-639677
X-HE-Meta: U2FsdGVkX19T6/yCQlP+EcPwU42B2z9LVmQf++loku+NxCYlR24v7aVAeZJ2nMb2nnCmGL8jdugQD5mhSasOmTCgU+/VrPqeutls8orXZIdCZDyRTZLqJwX5GX2s6moyfv/yI6Z/7sInRR1Be1ncgIlthFCb0QfIrKZUVhDFx3Qp0Dfa4i6ehoCWYhOt5Ibgk73A9hePCpT42w7hZ+R0j++FsuQduYnvEnaqG5tAi0VlFQmq8ZwvzFQ3rmPrlNYltcRaTOHK0JHWXkMMmVeTJ+GYM+EA7dbJJnbYqZFAGtDVcmjLPYngKnzY7JjFPhxJBzgRCi9s1DD7aKSiasNJnJ7BMVO8Wxv6ilopzbuKG3/nk6K+BMwYoTrYYKtVEVZfkarelWc5xg27xbKJNwgB7wvkBThQGsb+lN6Z6O9dK5+uGJbjkz+7BYxRLpMHLt44ea7/loUDRmJw/kN4fX7NeMw6KRiIJErecKrEnNz/75Fr1Ti8WngllWvurhoXRbWZZNMDUkZFcJIaS/Y1d3Yk+jK2PttoYPvrrbSR0MbqYDJuNRW6I+OuCCuJGtTAk2qIb9F0MeQxQ7EmhNCRzmB6znp2maCeegBHb5wAf1JXxaeaUHhfVtHRTWYuR7esYNos6OHleIDjREd+/cY9+BlbRq1F0++PTjJnpif4J6R+um0rX7q4RlQlpf+9lweFHN7AyL1zSoodHYRFBiTqAxhhimWpZN1Pimx8HDXYPGVQOIFmbYhfM+iN4i+LAYyEo/X4QrZNC3HIQIV2wL+Fj0anErUDO00d0rB60nsrm7v2mM+0L2iwmdHUwaHHiPYSQE+mwx41ILysH1sAk2rW1mFZkLkz0tcAc0j10LBL9dGwrg/F4MjwT3firlsOJWFcH14QFNSzqnEPNxjWRS3cYma3K76bjbsd+vdf+HCuRLe2CAb+j2bzo07Y1JfYJN2oSMj1+xIJD5jhrtT4E0+1la2
 YlDqlsNv
 5tVL1TQXWa4bI/cNdauSHoQX7OA0yVmbrCctdDNS6ekggOPBoWpKdu+G4URnWf0asLJocKu7kvjJ0mghfSyibc49S8FwQta+pVqB2+TjVs23eEBbpEzm0jronYA1jrLl4t8rjpescnDtgdkb+AhXwqjCxl6nxABbEnBNxJ2PAuUiv41bPemA9vfJYOS5/teu06IYCIy89wfrZkz8ghraH5+EvZQ7+6cu/9LUVbfAMi/F13ZVuORN4XynSJRGvN8zt6Pw8hWgk8XO5yUZRFJuGkWymNQyrxYgqyPu3ksjVyqQjPHrKB7hrPo1oG/JSR1mdSzoMANc4htKAz5rc49u1jwiP9H+0xbOQRz+dUGMQ4mZ4r6Yz1qsk53N3imiDOWbuILDSYXLWntbSn4jstMc+9bmVuV6PWtOnvEHDC0A0WoHf9Dl9MG2xp3hhGfpZt6uu0waERyrG2zScsXfINfklgfHkrOydl0bfBHjT77T5+qPW/cVOdZIFJXKPYtEOzuzmW+OdpkfIBbi9QN7vvnf5cKWLuZ0cxev0wRUhWUTKZGxk795XHKtmCqUnjf39wW/htuVoAVcC842/LHJbo4do3QjdwIwQki3AqiEcy4qkS2kgRHppBeZgGstnxeXNhRp8uxVyLxzVc+8iZhdGGbVSjTvZS3yjgCvT+olD8HKsgU+tdOu7b8yjHBS6h2/DOJ3tLbqf7YHb6WYdAf55TVYnA6Zp2qGmGI2jRafd5Rb6Be0BD6c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series backports 19 patches to update minmax.h in the 5.15.y branch,
aligning it with v6.17-rc7.

The ultimate goal is to synchronize all longterm branches so that they
include the full set of minmax.h changes (6.12.y and 6.6.y were already
backported by me and are now aligned, 6.1.y is in progress).

The key motivation is to bring in commit d03eba99f5bf ("minmax: allow
min()/max()/clamp() if the arguments have the same signedness"), which
is missing in kernel 5.10.y.

In mainline, this change enables min()/max()/clamp() to accept mixed
argument types, provided both have the same signedness. Without it,
backported patches that use these forms may trigger compiler warnings,
which escalate to build failures when -Werror is enabled.

Changes in v2:
- Fix the order of patches 6 - 10 according to order in mainline branch.
- Use same style of [ Upstream commit <HASH> ] in all patches.

Andy Shevchenko (1):
  minmax: deduplicate __unconst_integer_typeof()

David Laight (8):
  minmax: fix indentation of __cmp_once() and __clamp_once()
  minmax.h: add whitespace around operators and after commas
  minmax.h: update some comments
  minmax.h: reduce the #define expansion of min(), max() and clamp()
  minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()
  minmax.h: move all the clamp() definitions after the min/max() ones
  minmax.h: simplify the variants of clamp()
  minmax.h: remove some #defines that are only expanded once

Herve Codina (1):
  minmax: Introduce {min,max}_array()

Linus Torvalds (8):
  minmax: avoid overly complicated constant expressions in VM code
  minmax: add a few more MIN_T/MAX_T users
  minmax: simplify and clarify min_t()/max_t() implementation
  minmax: make generic MIN() and MAX() macros available everywhere
  minmax: don't use max() in situations that want a C constant
    expression
  minmax: simplify min()/max()/clamp() implementation
  minmax: improve macro expansion and type checking
  minmax: fix up min3() and max3() too

Matthew Wilcox (Oracle) (1):
  minmax: add in_range() macro

 arch/arm/mm/pageattr.c                        |   6 +-
 arch/um/drivers/mconsole_user.c               |   2 +
 arch/x86/mm/pgtable.c                         |   2 +-
 drivers/edac/sb_edac.c                        |   4 +-
 drivers/edac/skx_common.h                     |   1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu.h           |   2 +
 .../drm/amd/display/modules/hdcp/hdcp_ddc.c   |   2 +
 .../drm/amd/pm/powerplay/hwmgr/ppevvmath.h    |  14 +-
 .../amd/pm/swsmu/smu11/sienna_cichlid_ppt.c   |   2 +
 .../drm/arm/display/include/malidp_utils.h    |   2 +-
 .../display/komeda/komeda_pipeline_state.c    |  24 +-
 drivers/gpu/drm/drm_color_mgmt.c              |   2 +-
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c         |   6 -
 drivers/gpu/drm/radeon/evergreen_cs.c         |   2 +
 drivers/hwmon/adt7475.c                       |  24 +-
 drivers/input/touchscreen/cyttsp4_core.c      |   2 +-
 drivers/irqchip/irq-sun6i-r.c                 |   2 +-
 drivers/md/dm-integrity.c                     |   4 +-
 drivers/media/dvb-frontends/stv0367_priv.h    |   3 +
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |  18 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   2 +-
 drivers/net/fjes/fjes_main.c                  |   4 +-
 drivers/nfc/pn544/i2c.c                       |   2 -
 drivers/platform/x86/sony-laptop.c            |   1 -
 drivers/scsi/isci/init.c                      |   6 +-
 .../pci/hive_isp_css_include/math_support.h   |   5 -
 drivers/virt/acrn/ioreq.c                     |   4 +-
 fs/btrfs/misc.h                               |   2 -
 fs/btrfs/tree-checker.c                       |   2 +-
 fs/ext2/balloc.c                              |   2 -
 fs/ext4/ext4.h                                |   2 -
 fs/ufs/util.h                                 |   6 -
 include/linux/compiler.h                      |   9 +
 include/linux/minmax.h                        | 264 +++++++++++++-----
 kernel/trace/preemptirq_delay_test.c          |   2 -
 lib/btree.c                                   |   1 -
 lib/decompress_unlzma.c                       |   2 +
 lib/logic_pio.c                               |   3 -
 lib/vsprintf.c                                |   2 +-
 lib/zstd/zstd_internal.h                      |   2 -
 mm/zsmalloc.c                                 |   1 -
 net/ipv4/proc.c                               |   2 +-
 net/ipv6/proc.c                               |   2 +-
 net/netfilter/nf_nat_core.c                   |   6 +-
 net/tipc/core.h                               |   2 +-
 net/tipc/link.c                               |  10 +-
 tools/testing/selftests/vm/mremap_test.c      |   2 +
 47 files changed, 289 insertions(+), 183 deletions(-)

-- 
2.47.3


