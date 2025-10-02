Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEDC4CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 20:48:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 150FA8E000B; Thu,  2 Oct 2025 16:48:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 101628E0001; Thu,  2 Oct 2025 16:48:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0B828E000B; Thu,  2 Oct 2025 16:48:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA3488E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:48:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9CE9044EBF
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:48:18 +0000 (UTC)
X-FDA: 83954361876.27.73D7A79
Received: from fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.199.210.3])
	by imf30.hostedemail.com (Postfix) with ESMTP id 76CFB80017
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:48:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Uw4rIFoh;
	spf=pass (imf30.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759438096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=M+i/1aQ96wGM9M7nei+/gyTh3TBikkVX3xpo2CVnia0=;
	b=6VMgEJV+9JtiJpjfFw2Jyz8xSyThjKfBw5thNdZWIolIMr3pTIZnV4SfMkZ9h2uUxTziqI
	O7of+wLKcmMZ4XyF0frxWSRKO4sU7FGBfytUQKuXJAmR8bF2gBFfzop8xXy1FUdyJGiF33
	E+v9V5R/o2TZ6pAehf3gv498y7fnHfY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Uw4rIFoh;
	spf=pass (imf30.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759438096; a=rsa-sha256;
	cv=none;
	b=hg51TV1zono0eM7aIJMRxPpQyIzxeo1LooSmQzPe0f0st3IQXn0U/OtQ4/jLoEHO/qqaey
	svxI2wdWEkq4gbXAjZTRnrv571JeinuF6oDNz3yHyPYOplJ8Rt7dolhIJQXhpjqgyG5+tB
	mzeWEjamEEfbHNA+ChIXOIYn2Winan8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759438096; x=1790974096;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=M+i/1aQ96wGM9M7nei+/gyTh3TBikkVX3xpo2CVnia0=;
  b=Uw4rIFohNDeSyoNDu5bspRH8tbL0OT1FzV+ANApv0dXm6UAtY8TUcO8F
   8sPWTVeyfSoaMdUXnbpPwSPPh/ujvJuF4/YrlQkJsNwHLcV8BbLAVHMN+
   A7YCkAs1nFVV3TalPTtbju/qt2xkczSt31rxMprkiEp6/D4JLnWkX1+CU
   VzN8xtxhPBT2eU7mxeHgyhOTf18Z9+KpdAKkq3+Nosg/TcrgUZ8MHuuMm
   0FWYYKv3lfq6JQfjHeXxviH9Q1XmVN7u6TdYVUgUUiAh8XyzEGL2DlQPe
   xtjQWFXfwiveKiUthAzZJLLNEUmLFIGm5hufLLhbVoTvtq6wiVov6NfZg
   w==;
X-CSE-ConnectionGUID: IhyaDtzFRjGPZrRB0Zf/EA==
X-CSE-MsgGUID: UEvTypAIRPKTvxOhrDEKZg==
X-IronPort-AV: E=Sophos;i="6.18,310,1751241600"; 
   d="scan'208";a="2924446"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 20:48:06 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:13797]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.1.121:2525] with esmtp (Farcaster)
 id e9c967fc-a9f5-44c3-bb48-79cf233e2e24; Thu, 2 Oct 2025 20:48:06 +0000 (UTC)
X-Farcaster-Flow-ID: e9c967fc-a9f5-44c3-bb48-79cf233e2e24
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 2 Oct 2025 20:48:05 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Thu, 2 Oct 2025
 20:47:40 +0000
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
Subject: [PATCH 00/19 5.15.y] Backport minmax.h updates from v6.17-rc7
Date: Thu, 2 Oct 2025 20:47:14 +0000
Message-ID: <20251002204733.35652-1-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D035UWA004.ant.amazon.com (10.13.139.109) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: 76CFB80017
X-Rspamd-Server: rspam05
X-Stat-Signature: sf63qdja4exyph6t3bh9k3in6xk4sr4e
X-Rspam-User: 
X-HE-Tag: 1759438096-846528
X-HE-Meta: U2FsdGVkX1+0SZ9KDdSxEA+OmMgVnr9jBi4BlYuUMJj9rGw7BO65HIPYWhpkfwXEoYLpvOMZpBSHK/GyeW94d6oEam8PNA7y6C7JRnhvd9KF5sdW9qWR20Pc1oGACgBQ8PnZA0j2CLcvt1G3Pl9lyUIJh9xZSIeLJu2vXHQJNRq1RgQDE+wkiBudC0l7TW2dBYCngl3Z6U/uN09sbGst81ZYQ11W33Hu5Uie+Y9/wBnwFRySkDqLt44IEanHD36dmcNkf4yYZaKCQfHYtRX6BXRjPJ/kSGrjs9WoJjKYXdrWIIymkiESpUHPOqxB+Q0JXm+2sz/W+dNtsq411bOjzQAuiD3OtxmzBzoEXN5NPXLYMxn2BNeNRLlwy8KhFzgcxNXiyKeXYJcday5kT7ClyfxCD0KSmGRTBmITsMRJWfVRdp/eSXye6s0+jLLFXUp99ikguCWBoQDLWQhNZBtIqW3A7jbWX6U9W0AmfYjCYhYK0aZoPQGqRRwaiccL/NHxykve6MmJq/6e/82PELl5TnQrfDuuEU/SYMhBgTd3sNVgATjjM+RyCTf5RelC9F68xKNiih3kMmXXqSPm5RJs6WXv62H6B/4GiA9mSo1SYltfRwJuFeOztYUMUbuXOwYNYJEnzlrwXUOk0Rvf58IQofWSkPACcNtJ29hRtln9Ii6EA6QfoiS3wLxN/wWcJ25tiDFJ4PTOL5+rXeT279enU0FngNooThk3MBcOCBjScenB0TtRuKFNhYMpw7U+2/qo2RF82wZCXlRE68Jr3JM282n1PqW4uL3gK726n64VwROXYKIBjFXmRg7+gJ1a1mPytBwxGaB8ScgJdf1/0OUeSY4gb+Fj5pyVDGzlBMNjViO9XAt6MLe/Sloxp87Ma8GX563ik2pjfsT8FK6a5TVFFplvEC0RuU776tFoLKiso6CmPrXsRLLTQkMRjcAj33dGdSCu3M6Up3bTZXhK9Hx
 bXGGZNVf
 1I4Fh+SKvWDjT7rPpjQD2pih7LUQymYllx9x7Ai77bbf1pu3ZyIWwp/sAmQ5+8y1I2pi4QmRokiZcRCXM9MH1MxjNyfhFAb58BOmmUZ2Z0tTmjwccpZuJredh3WaFiVXYC/68KH9MEH0B0wORL86XYz83GtkP0DdYacHITkLbA7yHSlunz9WdsK0coAzei2ZScz0UCxHkxE7CfgGg/IpGJkwDmJrmrcfuYKlW75yc1wRGzcW9i7XbkvPvAdDKa0xCkQKKzgxegdCELsePJczxyWpCX7u1y4HcwpxotBqeenECvLTfHFj3nouDXQmyLlIjw63EOovLrC1bosPNbRirLBKIoLjvNhbLAq6QwQxj8CSL4IoG0/j/lNTQW4zc8H7CqrebKQ69EfIx1DuHRiVhH3m1e6FkxAjxszBQT5FAh95B8PVcJS7CV3M8fjfEFpRpVMmwat+afnl+9Hg66cxG3FJXWFNFvpTjM5Hdrz0t2chhVPitTnEBZI6q6ORBbb0WA1H8KazC4xZllb+UBDrcRgv+I0NKucUWrGBpd4CmYX2M0bwT518CxE5CyXKn15G3axJbsTyK24og7UH4yIV23uvgiBLAIqg2MM3oG7nhLGyPTmw9l/KfMPb9IcC1pF0mr6nW/kusb+Qh++VF8h/XLmIO9kocEeRl07Htg3kPR8J/g424pxLmgUgty0fr3V+hSV7BtueCA3nohqu9DCGPg5qZ9ir+yoyc1BcplOLANUj0WlDLEGnceKR7ww==
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
  minmax: make generic MIN() and MAX() macros available everywhere
  minmax: add a few more MIN_T/MAX_T users
  minmax: simplify and clarify min_t()/max_t() implementation
  minmax: simplify min()/max()/clamp() implementation
  minmax: don't use max() in situations that want a C constant
    expression
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


