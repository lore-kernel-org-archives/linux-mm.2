Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5BCCCAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 10:33:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F08528E0007; Mon, 22 Sep 2025 06:33:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDF488E0001; Mon, 22 Sep 2025 06:33:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF5B88E0007; Mon, 22 Sep 2025 06:33:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CBD268E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:33:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7FFD51A058D
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:33:18 +0000 (UTC)
X-FDA: 83916524076.29.F2B1AA6
Received: from fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com [35.158.23.94])
	by imf06.hostedemail.com (Postfix) with ESMTP id 574B4180009
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:33:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=kovy5iRK;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf06.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758537196; a=rsa-sha256;
	cv=none;
	b=sSRnSRCwyPDsvRB1HtYRonrZafLQ538kgo76ThQlbvWCQWvRrT2ggc+kR1P1jFYsbXmdG0
	m4u7NVHhRBnrqT3+jEmOz9zuzxB9PpUS6k+O8C1zhAp9+4SrV7uiMLMtJRzx94p8Hjwyet
	dVQ4oLWcTTWDssXuAnuipvDOqeaqgbc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=kovy5iRK;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf06.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758537196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zVSnvTXkXiuh+OW/uVNUL4x1ADt15TY9E6leiyfAL50=;
	b=vdswTCovFl5frkfchd+reUv6EuZ9nWe3xGvCom8oEEAEtobBwTxDR7zVZEZbV/SQQddJkd
	1pJPxBLtBbKaJtfw17fx3FXOhyIm53106Fdt7cqQVdWP5vXeN+co3t9v3wA0eoE2wpq+Ut
	Kfpr0kD++cF/PO7CHVGEQDfmOmI1efg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758537196; x=1790073196;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zVSnvTXkXiuh+OW/uVNUL4x1ADt15TY9E6leiyfAL50=;
  b=kovy5iRKK4xF4Qw1axLc2YTf3rwuzDa5RIDzIr+nzW/e9Z2DQxPtXkdj
   iSb11DNa+gpxMQc86JKUQTHJeiFGC6RdLvDp7AFH4IFyF5DU2okdSOGtT
   Yn+WYnWt1qvTKRsNKop3SmyiFrXPg0xZnZ1Lwzmn5OtPWnVAFLtX57NVK
   TTq6m3BQHWFy417AX32hKSMf1QpFaXyNnGEK0xhYa3z6NqpOGqr1DxoWn
   gh5XcBKKMAjRza1MR3+/yWodsk5JilLNetFAltAD7SLGh2MA9vHTiL036
   VbIbkcT0Jvwp02Do1hxE6/Rx8aMov7unRsFkkw4RDnp0BtwtfqvgUKOkq
   A==;
X-CSE-ConnectionGUID: SA7Bpc9VQgG1HmOijFiFuw==
X-CSE-MsgGUID: 7eapTz9/SuG/x2ufntC2mg==
X-IronPort-AV: E=Sophos;i="6.18,284,1751241600"; 
   d="scan'208";a="2478632"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 10:33:14 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:4640]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.10.226:2525] with esmtp (Farcaster)
 id c0c65c16-13cf-4fa2-a5a8-1f23642ff95a; Mon, 22 Sep 2025 10:33:14 +0000 (UTC)
X-Farcaster-Flow-ID: c0c65c16-13cf-4fa2-a5a8-1f23642ff95a
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 22 Sep 2025 10:33:13 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Mon, 22 Sep 2025
 10:32:49 +0000
From: Eliav Farber <farbere@amazon.com>
To: <richard@nod.at>, <anton.ivanov@cambridgegreys.com>,
	<johannes@sipsolutions.net>, <dave.hansen@linux.intel.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <x86@kernel.org>, <hpa@zytor.com>,
	<tony.luck@intel.com>, <qiuxu.zhuo@intel.com>, <james.morse@arm.com>,
	<mchehab@kernel.org>, <rric@kernel.org>, <harry.wentland@amd.com>,
	<sunpeng.li@amd.com>, <Rodrigo.Siqueira@amd.com>,
	<alexander.deucher@amd.com>, <christian.koenig@amd.com>,
	<Xinhui.Pan@amd.com>, <airlied@gmail.com>, <daniel@ffwll.ch>,
	<evan.quan@amd.com>, <maarten.lankhorst@linux.intel.com>,
	<mripard@kernel.org>, <tzimmermann@suse.de>, <jdelvare@suse.com>,
	<linux@roeck-us.net>, <linus.walleij@linaro.org>,
	<dmitry.torokhov@gmail.com>, <wens@csie.org>, <jernej.skrabec@gmail.com>,
	<samuel@sholland.org>, <agk@redhat.com>, <snitzer@kernel.org>,
	<dm-devel@lists.linux.dev>, <mailhol.vincent@wanadoo.fr>,
	<wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<alexandre.torgue@foss.st.com>, <joabreu@synopsys.com>,
	<mcoquelin.stm32@gmail.com>, <krzysztof.kozlowski@linaro.org>,
	<malattia@linux.it>, <hdegoede@redhat.com>, <ilpo.jarvinen@linux.intel.com>,
	<markgross@kernel.org>, <artur.paszkiewicz@intel.com>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>, <sakari.ailus@linux.intel.com>,
	<gregkh@linuxfoundation.org>, <clm@fb.com>, <josef@toxicpanda.com>,
	<dsterba@suse.com>, <luc.vanoostenryck@gmail.com>, <rostedt@goodmis.org>,
	<mhiramat@kernel.org>, <pmladek@suse.com>,
	<andriy.shevchenko@linux.intel.com>, <linux@rasmusvillemoes.dk>,
	<senozhatsky@chromium.org>, <minchan@kernel.org>,
	<akpm@linux-foundation.org>, <dsahern@kernel.org>, <shuah@kernel.org>,
	<keescook@chromium.org>, <wad@chromium.org>, <farbere@amazon.com>,
	<David.Laight@ACULAB.COM>, <arnd@kernel.org>, <linux-um@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>,
	<amd-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
	<linux-hwmon@vger.kernel.org>, <linux-input@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-sunxi@lists.linux.dev>,
	<linux-media@vger.kernel.org>, <linux-can@vger.kernel.org>,
	<netdev@vger.kernel.org>, <linux-stm32@st-md-mailman.stormreply.com>,
	<platform-driver-x86@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-staging@lists.linux.dev>, <linux-btrfs@vger.kernel.org>,
	<linux-sparse@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>,
	<bpf@vger.kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH 00/15 v6.6.y] Backport minmax.h updates from v6.17-rc7
Date: Mon, 22 Sep 2025 10:32:26 +0000
Message-ID: <20250922103241.16213-1-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D039UWB002.ant.amazon.com (10.13.138.79) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 574B4180009
X-Stat-Signature: 36jurf6cr1amzqod1953qpf6mstg5od6
X-Rspam-User: 
X-HE-Tag: 1758537196-510983
X-HE-Meta: U2FsdGVkX18QBtF9LVOA2OOuaFMKzSMhbmkPRkd1/KJ+XiZ6eTBHN2is7eBL/LVFaNDD0l+wOhV+9ENBCcX/bDIlWxxeYL7HNPLSojrv+9N6pc1USVwCZV1Eyd25MOBJcyhAn34fE6dcZlb0P03D5/kZ5ZfMwthiY2Bb7YkoevdNEAD3nQUvpIbOZY12uVt4XwvTD6lloYsh26Fnkt/SbH+e207mbe4Erh4Mbr6uD+SfSd0lfy/Vs1Gtt8vYGp1QMn8yAuxrsZlruif+t/gt1V2CxuPrFq7R+xbMNT6yFXT/UsODh4P5NDVn8HVpE2Dqza2sc7qCVKqq/zsECt0foEBJuSG7nWbev0NblHRwrTMwoi15KXOpT9JZlA/t5+kziIoJaW5DQ/85aDrlfj+Dp8wlai1au9vI2c4Vs0EDflwJH0NmTAGK1xMIELJtulpFDxrU+njb8Hre/dCFlzBcve1wTjgj4jIL3EnoA3ZBXPX2OXlCgf5kpAKDv0GCdowGqCGWl4wHxnKsVs+6OBQIuFUXAHFQhPXeA+t+Y05Dgvo1ZjdPW2FG4PiaXWx2jFW1fV4WyVIIxTcgWfRdBxCJ59noHJWUT5nBmIDdQqhjw+7q/LYE6ssypMAZ6BYvzjhw/ofo3mKNdvuQ92nQqCKXV5Qp0W1d9/Zva6axOZ25iHG5Yj4H1Igt5tbjXltSGZrG0vE/AIni6QTNsjW/b+7xmuR7eECnztlT78osBqJAI0djBzgeW4o839y7qrQrFW8q6ITowaGYNV5ZdPq9nD/PN8Us1mQ30VltXqM5lAsTwJw59WcfAiRSTfAaPL4ttJzg9pLuHL7yvjqslV1sOcKWBtL+dtt5HgJXV60UlmhSuCJNyErRafJjduWFSsOkOJcASzhYfFLLXJB0wgg0Naod7gt+v5/14RruBixwVeYPo1sfEzstEyeQt6Dtm/MtiV3DV54MZQ19HeynY2O3gXk
 ktUFFwzb
 z0PwKn7FshLJDEW2EgYQRlCVjcWbl57Ldz4dCKWuNV9Ih3zAvXrnb1AnOjRT6NRV7aPRj8NAAbCUklxhrTJE4UZOhApVdUbW+rYCrThg6ZIKjDXryEJugmfFQfdeY2ZHU5hs/rFX+Checdr0x0DVfXjEmh8RE/e5C+3GL5ocKWkZok1DDsRcxqWKOmP4U6D00DM7c/t6dr1y4t+kVVGy2/BsQsaxEpXz6BcBSrlOA+AvAhBnrrUwBhRYhET/kFmXz9ivV8NqqjSnPjZRfbrXTmmnNg+41fMf2bcranax1Xe4ZtqGHZO99WDsf/NTCjbYD8JlzdH7KYN1QIll3CouiLybiNM+RSAXAOC0zKNC3ic21yIz6Iv2CG71WRkZ5C8iMaRzw0M8Ol/rWhjyTKnYL91zcVCmrR1BphjAMaGtS6QrWYRmUJrutZ+MCZaEk2xNVqrwB03xfbsgrCjk9qEJiXzy6J1sf4sNqYeZZtIdczKdhg0sfSgZzZ6+89Fz78rT5ALQhLftb+nBfGIJviieGnTKL+yYDokMGeYNvfqveE2F/IzKDS/lUwQL8CHHn/hZ8+zmzJFkPk4lS6rrJCZhufMRj8HIBbpJsm6LknxuatBXKf2ELQGJ7L+Tdj6ej/nib3SCcoChENZRAPSbcfTnWYV8txry0USqbBLUgYzcUVfVNbUpp38hpuD2QcLBoeevSGc5THcT0pe9XfPtCPM3wJpafiDQaIwTWZwjBkk/6Kha7uyfe6e/PBgGn5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series backports 15 patches to update minmax.h in the 6.6.y branch,
aligning it with v6.17-rc7.

The ultimate goal is to synchronize all longterm branches so that they
include the full set of minmax.h changes.

The key motivation is to bring in commit d03eba99f5bf ("minmax: allow
min()/max()/clamp() if the arguments have the same signedness"), which
is missing in older kernels.

In mainline, this change enables min()/max()/clamp() to accept mixed
argument types, provided both have the same signedness. Without it,
backported patches that use these forms may trigger compiler warnings,
which escalate to build failures when -Werror is enabled.

David Laight (7):
  minmax.h: add whitespace around operators and after commas
  minmax.h: update some comments
  minmax.h: reduce the #define expansion of min(), max() and clamp()
  minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()
  minmax.h: move all the clamp() definitions after the min/max() ones
  minmax.h: simplify the variants of clamp()
  minmax.h: remove some #defines that are only expanded once

Linus Torvalds (8):
  minmax: avoid overly complicated constant expressions in VM code
  minmax: simplify and clarify min_t()/max_t() implementation
  minmax: add a few more MIN_T/MAX_T users
  minmax: make generic MIN() and MAX() macros available everywhere
  minmax: simplify min()/max()/clamp() implementation
  minmax: don't use max() in situations that want a C constant
    expression
  minmax: improve macro expansion and type checking
  minmax: fix up min3() and max3() too

 arch/um/drivers/mconsole_user.c               |   2 +
 arch/x86/mm/pgtable.c                         |   2 +-
 drivers/edac/sb_edac.c                        |   4 +-
 drivers/edac/skx_common.h                     |   1 -
 .../drm/amd/display/modules/hdcp/hdcp_ddc.c   |   2 +
 .../drm/amd/pm/powerplay/hwmgr/ppevvmath.h    |  14 +-
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c        |   2 +-
 drivers/gpu/drm/drm_color_mgmt.c              |   2 +-
 drivers/gpu/drm/radeon/evergreen_cs.c         |   2 +
 drivers/hwmon/adt7475.c                       |  24 +-
 drivers/input/touchscreen/cyttsp4_core.c      |   2 +-
 drivers/irqchip/irq-sun6i-r.c                 |   2 +-
 drivers/md/dm-integrity.c                     |   6 +-
 drivers/media/dvb-frontends/stv0367_priv.h    |   3 +
 .../net/can/usb/etas_es58x/es58x_devlink.c    |   2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   2 +-
 drivers/net/fjes/fjes_main.c                  |   4 +-
 drivers/nfc/pn544/i2c.c                       |   2 -
 drivers/platform/x86/sony-laptop.c            |   1 -
 drivers/scsi/isci/init.c                      |   6 +-
 .../pci/hive_isp_css_include/math_support.h   |   5 -
 fs/btrfs/tree-checker.c                       |   2 +-
 include/linux/compiler.h                      |   9 +
 include/linux/minmax.h                        | 228 +++++++++++-------
 include/linux/pageblock-flags.h               |   2 +-
 kernel/trace/preemptirq_delay_test.c          |   2 -
 lib/btree.c                                   |   1 -
 lib/decompress_unlzma.c                       |   2 +
 lib/vsprintf.c                                |   2 +-
 mm/zsmalloc.c                                 |   2 -
 net/ipv4/proc.c                               |   2 +-
 net/ipv6/proc.c                               |   2 +-
 tools/testing/selftests/mm/mremap_test.c      |   2 +
 tools/testing/selftests/seccomp/seccomp_bpf.c |   2 +
 34 files changed, 202 insertions(+), 146 deletions(-)

-- 
2.47.3


