Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9258ACAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 10:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC0758E0011; Mon, 22 Sep 2025 06:36:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E97818E0001; Mon, 22 Sep 2025 06:36:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAE538E0011; Mon, 22 Sep 2025 06:36:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C83578E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:36:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 95CFD13B76A
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:36:09 +0000 (UTC)
X-FDA: 83916531258.19.FAC3FF0
Received: from fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.143.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id 54074A0014
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:36:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=hCTNz7hl;
	spf=pass (imf25.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758537367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TDV161r/7qFlBicXIybWhTsXZSPWT6ddjPuQfDuVP8k=;
	b=FdijQJQ4MG0e/s13Cskc41peKKXn5okby9IW7AUDUR0BIhBGs6yRjwfwl2HmJAB/cbjkpi
	ARZk4NboZXIJaDUe4N/KsRsDAYbIXyvj8RHvosfwajO4KHDWgyYII7RuTS2m4b+LsVvRsY
	lD3Nam5jBS3J89t/j5hEoPRHmCrQDFE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=hCTNz7hl;
	spf=pass (imf25.hostedemail.com: domain of "prvs=353d6d59a=farbere@amazon.com" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=353d6d59a=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758537367; a=rsa-sha256;
	cv=none;
	b=53SJr371gfrYOVqwEaZqa4aL/IFPyGFarKrUIfxb+FtMUhEXpZs1oUNg5no3zrne4KGDbv
	jdkNEoYtRYtYxBfhwvWnlBzT0tyzPsz36pshyZOzosMazghwCdbrQCMwlRYIX+qYRrmjB4
	a/70Yb/tg2ZWAAO1yGgLTRq0P6UcfNA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1758537367; x=1790073367;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TDV161r/7qFlBicXIybWhTsXZSPWT6ddjPuQfDuVP8k=;
  b=hCTNz7hlPlQZZX1WFGMHUfznxnmZzU2K0JnSqYaa9sZLiqOqFdooylwA
   klgAS6mjjL4HR6+RY1egR4iZYE0tICOz84zPXH9hSsReHzM8OkM4l5B8C
   79mBigXYKObgPk0f0ZhZ+Pj3Vb1ERuqS/CM4VCPvIxJD+kQb12/r/wIiY
   +LOQk3hpYh3TMf15ghI2gqFqw21iEojIJl363H2knQmzpWoei6ANF+fTa
   Oxl1gbtIFwmmN95dHO6Un3R6vgXDLbBn+sfFU6twfIRgvF2ff0xAZXX3m
   KBVbUpqRaLyVVBl2C5E4E2OMLpZ6yIDhBmTBELWc35WoOUr78dzMm8p4G
   Q==;
X-CSE-ConnectionGUID: pka/5WaEQHaBLHh8hs/KKQ==
X-CSE-MsgGUID: muTRddmbTZqiICwUN3a3Bg==
X-IronPort-AV: E=Sophos;i="6.18,284,1751241600"; 
   d="scan'208";a="2370558"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 10:36:05 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:11459]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.21.238:2525] with esmtp (Farcaster)
 id e0f65cd7-e62a-4c83-8445-bc01acfd1bb4; Mon, 22 Sep 2025 10:36:05 +0000 (UTC)
X-Farcaster-Flow-ID: e0f65cd7-e62a-4c83-8445-bc01acfd1bb4
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 22 Sep 2025 10:36:04 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Mon, 22 Sep 2025
 10:35:38 +0000
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
CC: Linus Torvalds <torvalds@linux-foundation.org>, David Laight
	<David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 06/15 6.6.y] minmax: don't use max() in situations that want a C constant expression
Date: Mon, 22 Sep 2025 10:32:32 +0000
Message-ID: <20250922103241.16213-7-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250922103241.16213-1-farbere@amazon.com>
References: <20250922103241.16213-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D033UWA001.ant.amazon.com (10.13.139.103) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: 54074A0014
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 3yff54j7g4556k881dkikkzzttqnztjb
X-HE-Tag: 1758537367-517394
X-HE-Meta: U2FsdGVkX1+Yh2sTKDTHrkx4cNxcikWUHogYLsPRr8QDlXospTtSFfQa3wA37I/0jh3R6mfKs45FEvOYUjAJ/Ao1yqugsS45yRVmJ68HbhQh4y6bpeLmrem6Waksp8sCvoqOEfAWF5QYzfC8UQbl8iKT4c+9jXM2kYp7ifdpSEA4Y+o5fWSLm4Tv7LP8TWf7jScqVYrBB9X5AAZhyrnBoJIdOQa9D9jG7J7mn5zO+05ljIEjPEwZxrqxTY4LtTd+6JVp9vYtiU8T7Tb4/fzkevPeC4iHbr62LwXhuATXZIJQuGB6Bm9WK0ct0UjI0AKo1M+QK9su5rwOOG3qLe+wNqb6klIIu5GPaJjZgioREd9p7U/nPCemGVZ1JwqI57eJ7VNZteWoOHY2fCjjReFWdfKdoWDOMr6HReOJxRtYWgcCimCdO2roWu+gedxtZI61pPNA5L/2ZFSAKF1o8FVswmqPuhhoeWVi2mpB6XLTcuYoqU88L9eLmT2kD8hfTffP01QhBjHxJZJnPEbl4qhA0i5ewnl06IpS0OuJ4NFw+7Naxdj+59+pKJVB9y4tVB+O9fktZks3/v5MwjxBy2A8iK3kwZqOpAzqIKCgX6U65WCMJCbKz8lxmb5aniGBaAXKrgR0caKpzciqlhRcWQmVmw5I/BlsLaninBdEtrlO8QzYo7jxRR4eHH+KrQBoKNiNYZvB3O/kXxZnlye/Qfcegs687cEAvGdUs/9d786KwsveWMe8tvB8lMRcML/KSsyORXX8PJu9NIkDK3LUR2FaC5sIEmdl9/dK6CEKCyUxfQhfw7HMZRHlegoaHTEwym7rdy2bWkKi51FSNSEzTPxLuTDkI6Vd8jvrQVFULLseZKCM997VhY8JK0s+3TEf+vIkH4dAt07Gn8E8TMYyqyEJPC7XZ/jMo1bEvierxzk/lCZfahMP72uUql3SlTz9VOpkzZhj42xAbPOew7kP+fr
 FKgyePfk
 pg0YyadVVi670WXZ6X41p7v8FCRHN4Pp6xVRXsiJX/FznRK8wi7w0+x7WUnQ1fXL49calVVlQAqidFp3V+6FlxSpjBsx/0oJq4eFhsd4d4QKARy+daIZRp6UENXPQ5lNzOiPZ3xsWGdx0vOG5ELjkVD08DAP8HrwMCs81bTycTcncC6CyJ/k3sQnEEP0EWoi1n2ZAG4g0O1SD2F4TbE5/W9j1izs5kef8F+VkflfRWQzlKiO5p1k77tCX57cP6LSt+BD8hnDnTVQ6cAA5qLgmhhtJ70sI3ERm0oU6Uc0Fw4De53f+wHnNAPN8l0tIlu0hzwOgi+Gf9pV7rGANhJABG49x58PV1bQqBIIGbHafQv6w4l0pyMQkuucrsG/LQVkY9DwjbRaBU/ASrsEkLGlNyHoFcCXqb2z+LUqO3wbnDBhMwqtyATuY1/19SUF7/5UmcwQKw57nsKBSa6HU9KNOYmRTGZKHMPbAT5J8zQHHLg4cKXrxIp6jlVM6JAz0UL3v+MmWvHR3wDRgcqNROXm8bPeg80nISZxS1jelDx7enLEvPYq33QWzVwnuUQiGA2r6Cdp0Y7RGqaruXxBmf/IvFnMb99UJzOyP2DlGphbQf7i9iRxh4PFV4WaWPMF3byMeb94gNl7jTcmC70E6e9NkLZPy7JM3oiTbT5jLv4AULHyrrLHYdHWi9VxxE8rZseiJnAyFqFImQL5jZhmoHYxnkpP3jcx5DUzLe+8B0rwv9uTbx6/TSYO/Lil+0YxpgppRERTeRLgTvMH3qirTuvioGZxLJJgEIGb2Q/efPYPLCSvQjt1dCMdFJfpxX+jZpoLYASR/WR6K+uTcYemQbv9uY5/6nuc/0a04qmd6pUnHBGxvzdUjwyAK/fWx4OGLQCTzuo/82qQU65vElpA4CKcuwvwwz4STbK0gxfVXhEMUEveguqBi+VLJeAxqVKG2IS9cyKmU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit cb04e8b1d2f24c4c2c92f7b7529031fc35a16fed ]

We only had a couple of array[] declarations, and changing them to just
use 'MAX()' instead of 'max()' fixes the issue.

This will allow us to simplify our min/max macros enormously, since they
can now unconditionally use temporary variables to avoid using the
argument values multiple times.

Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c         | 2 +-
 drivers/input/touchscreen/cyttsp4_core.c       | 2 +-
 drivers/irqchip/irq-sun6i-r.c                  | 2 +-
 drivers/net/can/usb/etas_es58x/es58x_devlink.c | 2 +-
 fs/btrfs/tree-checker.c                        | 2 +-
 lib/vsprintf.c                                 | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
index 12618a583e97..c1962f1974c6 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
@@ -708,7 +708,7 @@ static const char *smu_get_feature_name(struct smu_context *smu,
 size_t smu_cmn_get_pp_feature_mask(struct smu_context *smu,
 				   char *buf)
 {
-	int8_t sort_feature[max(SMU_FEATURE_COUNT, SMU_FEATURE_MAX)];
+	int8_t sort_feature[MAX(SMU_FEATURE_COUNT, SMU_FEATURE_MAX)];
 	uint64_t feature_mask;
 	int i, feature_index;
 	uint32_t count = 0;
diff --git a/drivers/input/touchscreen/cyttsp4_core.c b/drivers/input/touchscreen/cyttsp4_core.c
index 7cb26929dc73..9dc25eb2be44 100644
--- a/drivers/input/touchscreen/cyttsp4_core.c
+++ b/drivers/input/touchscreen/cyttsp4_core.c
@@ -871,7 +871,7 @@ static void cyttsp4_get_mt_touches(struct cyttsp4_mt_data *md, int num_cur_tch)
 	struct cyttsp4_touch tch;
 	int sig;
 	int i, j, t = 0;
-	int ids[max(CY_TMA1036_MAX_TCH, CY_TMA4XX_MAX_TCH)];
+	int ids[MAX(CY_TMA1036_MAX_TCH, CY_TMA4XX_MAX_TCH)];
 
 	memset(ids, 0, si->si_ofs.tch_abs[CY_TCH_T].max * sizeof(int));
 	for (i = 0; i < num_cur_tch; i++) {
diff --git a/drivers/irqchip/irq-sun6i-r.c b/drivers/irqchip/irq-sun6i-r.c
index a01e44049415..99958d470d62 100644
--- a/drivers/irqchip/irq-sun6i-r.c
+++ b/drivers/irqchip/irq-sun6i-r.c
@@ -270,7 +270,7 @@ static const struct irq_domain_ops sun6i_r_intc_domain_ops = {
 
 static int sun6i_r_intc_suspend(void)
 {
-	u32 buf[BITS_TO_U32(max(SUN6I_NR_TOP_LEVEL_IRQS, SUN6I_NR_MUX_BITS))];
+	u32 buf[BITS_TO_U32(MAX(SUN6I_NR_TOP_LEVEL_IRQS, SUN6I_NR_MUX_BITS))];
 	int i;
 
 	/* Wake IRQs are enabled during system sleep and shutdown. */
diff --git a/drivers/net/can/usb/etas_es58x/es58x_devlink.c b/drivers/net/can/usb/etas_es58x/es58x_devlink.c
index e763a9904bed..0d155eb1b9e9 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_devlink.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_devlink.c
@@ -215,7 +215,7 @@ static int es58x_devlink_info_get(struct devlink *devlink,
 	struct es58x_sw_version *fw_ver = &es58x_dev->firmware_version;
 	struct es58x_sw_version *bl_ver = &es58x_dev->bootloader_version;
 	struct es58x_hw_revision *hw_rev = &es58x_dev->hardware_revision;
-	char buf[max(sizeof("xx.xx.xx"), sizeof("axxx/xxx"))];
+	char buf[MAX(sizeof("xx.xx.xx"), sizeof("axxx/xxx"))];
 	int ret = 0;
 
 	if (es58x_sw_version_is_valid(fw_ver)) {
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 6d16506bbdc0..6f4c42e66519 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -614,7 +614,7 @@ static int check_dir_item(struct extent_buffer *leaf,
 		 */
 		if (key->type == BTRFS_DIR_ITEM_KEY ||
 		    key->type == BTRFS_XATTR_ITEM_KEY) {
-			char namebuf[max(BTRFS_NAME_LEN, XATTR_NAME_MAX)];
+			char namebuf[MAX(BTRFS_NAME_LEN, XATTR_NAME_MAX)];
 
 			read_extent_buffer(leaf, namebuf,
 					(unsigned long)(di + 1), name_len);
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 2aa408441cd3..f4ab2750cfc1 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1079,7 +1079,7 @@ char *resource_string(char *buf, char *end, struct resource *res,
 #define FLAG_BUF_SIZE		(2 * sizeof(res->flags))
 #define DECODED_BUF_SIZE	sizeof("[mem - 64bit pref window disabled]")
 #define RAW_BUF_SIZE		sizeof("[mem - flags 0x]")
-	char sym[max(2*RSRC_BUF_SIZE + DECODED_BUF_SIZE,
+	char sym[MAX(2*RSRC_BUF_SIZE + DECODED_BUF_SIZE,
 		     2*RSRC_BUF_SIZE + FLAG_BUF_SIZE + RAW_BUF_SIZE)];
 
 	char *p = sym, *pend = sym + sizeof(sym);
-- 
2.47.3


