Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77E5ECAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 20:52:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D42268E0016; Thu,  2 Oct 2025 16:52:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF2AB8E0001; Thu,  2 Oct 2025 16:52:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE1AD8E0016; Thu,  2 Oct 2025 16:52:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9A5C8E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:52:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 627125A227
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:52:54 +0000 (UTC)
X-FDA: 83954373468.12.478AB9A
Received: from fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.132.221])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1E6C64000A
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:52:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=j8OfMbEc;
	spf=pass (imf11.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759438372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Un1JE7toeI83ffXaasUfHmeV127z9Znvwu1ZeiNJbjk=;
	b=gANDCf2bfbjhzPMJ3rpTYUxHMSML7YWou9G2O9a5Ah/+qHqLEwVUq9RHTu+Ts9T0Db0nNn
	MefpasRgLATXaCBZcX4jX8UlhjOKqL2dOolt50p9NRh7CgOCBBXlyLMRZVl1pkXRSdRcen
	s46o0geDy9C0IwfgKUYlmuMOtgVnkHk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759438372; a=rsa-sha256;
	cv=none;
	b=wfvT86TzlIT2Nl4c3qj0nVau/5V93driwJxTFRTUm0+Y1Tq1nRFsmt5HQNoyBL6bIisCoz
	EqNtL9w0OUYCyP1ruAVikOo2lD0C1zfSBuzYIPekNWh3U5xuBsWvYkBOEebS5d190QoxUw
	35/yzZ08nxEzsdqxYGAFflq5VOpVajE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=j8OfMbEc;
	spf=pass (imf11.hostedemail.com: domain of "prvs=363ba725c=farbere@amazon.com" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=363ba725c=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759438372; x=1790974372;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Un1JE7toeI83ffXaasUfHmeV127z9Znvwu1ZeiNJbjk=;
  b=j8OfMbEcX8DLb7Xl/D0BZ5AzkST6EHrYh2L8G2Z4oAz2DZEEDPKbgySb
   WI+G7t2/PSzTymVPI9Xz440aYttAUpfAmJSvyViZVAui4z8Nf63FluqUn
   /+uzxCwYfuhQPDgXI97KJfArr7WjYVOzRf3V2VgdLFnC2ECx/PG0R8jTr
   qnLSr1LtXgaHv9rN7A06DlXMhuDMGLdbwjqhBD5nCjeZtHnV3UF5RQ/aS
   HAtJW3NzKAtwkSg8iL8PISWGzCsR8IO4tX5GRj+rhJqoVGs1yscb1u3Gl
   SYEQx+p3HDMk7gv3ZN2x5EiuNQDfQF5rn8n6YPJZ983+F3QcO4F7l5+Po
   A==;
X-CSE-ConnectionGUID: BzOfTle9S/ibfKWpe4OT9Q==
X-CSE-MsgGUID: /RqtyI9PR8iuPOQCBhiMZQ==
X-IronPort-AV: E=Sophos;i="6.18,310,1751241600"; 
   d="scan'208";a="2929338"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2025 20:52:50 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:26575]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.19.222:2525] with esmtp (Farcaster)
 id 5fc78996-e298-416e-acbb-dfd880666c7b; Thu, 2 Oct 2025 20:52:50 +0000 (UTC)
X-Farcaster-Flow-ID: 5fc78996-e298-416e-acbb-dfd880666c7b
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Thu, 2 Oct 2025 20:52:48 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Thu, 2 Oct 2025
 20:52:23 +0000
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
CC: Linus Torvalds <torvalds@linux-foundation.org>, David Laight
	<David.Laight@aculab.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 10/19 5.15.y] minmax: don't use max() in situations that want a C constant expression
Date: Thu, 2 Oct 2025 20:47:24 +0000
Message-ID: <20251002204733.35652-11-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251002204733.35652-1-farbere@amazon.com>
References: <20251002204733.35652-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D045UWC001.ant.amazon.com (10.13.139.223) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Stat-Signature: 34qnfmedmhmm1c4rz9uybtr89fhui6qh
X-Rspamd-Queue-Id: 1E6C64000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759438371-71176
X-HE-Meta: U2FsdGVkX1+sKevvpEypz9g/xYyAxHYjaQ92HOp3Lg8VztsvTJ0tklZwyIMqJLsIvIYhhCGk6En0cC4y2snw/RP3+4QpBUJfKe/eFw9tzdvxjEfUqdPqaP/ehbXmdAe/g6c9USj0fRrkIVfVUTrpBU0vSM+KQpColFYp6JJ1ZT18jHaj6UHwIX84wxr53oITRFAHltqKjVXBrh7HErQBmh6my9L2N9WsRlcGd4o8mKzTi/THiN3i+ZSEcEgLU4DTrfsghqiTYLTzsKUsN+2BmxFO0U3xRsF0yvQsA7ViTB+yfEDSKVIys3VqIz9GXwJWPku8xWB+RJJoyRubSwTrpNNYSYg90G546RQSouKq3zOb8XBoU0D8ZBBZAzRH0KHeluqH3xlTbTgJ/wJAO7rI9cSETVAjNKNmu5GUb85LUFiak2k0JKCPraL4R2R1N/DutmpoNh5aTndAK5LDdeFRpKa/uy3q+TlFVkOH9BaSiW+INuRvJKgmKD0AuhlOBwIqyAOHeYl/K5NeC7P8ccUOAl8buHy37Oh8jDIkPXZ8G4Ys7sklUdA7lmoEhQU4PNcpUB39eChm+8BMCb+YtgpHfNWaMc5SdgTlYxMyWt0CaC+xgI+q/QTdJHkUmVGhKI7LqtC8yEa+xfQAMVr/mUt39Pe0kKl8cDfkRDnqjGFlhm/ekqltBGbaqJ4nYmx9cr1fNdxh8RsvMCo1XR8otZKmgn2VsGxs9g12OusnyD/RuySdJunoc/Tpe0Xfa9yr75xAkhoG/wjKf3A9TUy9jbfO1pGq/njsOlL+Nc8U+Fha5eFvoLlr3M5ooV/hNtB9tjZEh1riMoDQSecfexmeEO0MEjJjtbQzceAlklVkSmcst9LmgsA8cVi/Xt6E/w/tbXEro6j1vN9j9uANMkkQGGO7/lbW3IgD9lnIGfEHN9hDrdYW9g100Dcx6pTVD7x3Se8rcI5thm2GFolSM52wZ1e
 1Vs9YU0c
 FyBnpernjsfcKtnkfGRxGsHs9Yw+2DzUmTgr4eFnMDavrtYpYkkJoigv7VnIn2+majmzFS5sEbtTCx6t6KK5v7n8c4jpFclDroHqS83UxanUDq3r/LBsSy3akswXEoctnag8rk6HeNDfx3B+P7EdABBoaH3oNtsKsan5L4jNT/3Yhq0UjSEez7ptM/O4Voq5e+b0sRiv9b55ksoqRnSmUUXlsI6A7elElknhIez2Gwi57wlE9/DyadZVWoC/U0Y93ozhiM2u+sG93v5ACpELGPIc45+cI/drm7rE8KKABm6i2EAZO/BLjX4oFuOQYd+14qFSKFfnFD/d1JX0I6OL70+Yj5pGoezol8uSyt0l6RIeCUzy4PGuNPKfjzt9mPoPRn9uGjkrRkXjbfwHpTKW6LGOs4tNzFEoMshZsV+u/V8J8KZhFdAecnHLr39pPfcpCRPEj3GxUvnY/eXDvxt2BcXPOXAdulhavdkjnYmNfZrcDABUsqdhmasnPZY7R7DMfBbIEy2l5W7TbIOrS58AtWEWyO22vo85ZuoXRXu7fLSp5BqU+yPzwhOqpLpRR88SXBYS7oek5kj0ddDXI062rc0LyfTplSdNn49Xdx0iywO4uaSTgM7GXNJcLi+0rBry95ypuFiXTfr5WWpht3iZ6epYKXTsi0/k4Kk/1p6b7o9qiLg1V+FAp8lSimMXg5SSoOy3/yoiBzcySV2qEpBLp1GpclIwEUx2pSRbxxF9LzzKgmFDyM2maVxgo6djmD2jsXECqDJWbu3aHP4zvZ9+MQKKNS72NJSk0ckhftdT5OR1gvxYYfFaCDP/bz/TS336jatyt2s5oKUBlij7gdDKp0ntGPZ9x0OdwX2B3GdkanxyRmXVi7So4uODtX+qJ4Gdd4pj17jD/gvAl4mBhcKBxglxROg==
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
 drivers/input/touchscreen/cyttsp4_core.c | 2 +-
 drivers/irqchip/irq-sun6i-r.c            | 2 +-
 drivers/md/dm-integrity.c                | 2 +-
 fs/btrfs/tree-checker.c                  | 2 +-
 lib/vsprintf.c                           | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/input/touchscreen/cyttsp4_core.c b/drivers/input/touchscreen/cyttsp4_core.c
index dccbcb942fe5..936d69da3bda 100644
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
index 4cd3e533740b..74b1bd331425 100644
--- a/drivers/irqchip/irq-sun6i-r.c
+++ b/drivers/irqchip/irq-sun6i-r.c
@@ -268,7 +268,7 @@ static const struct irq_domain_ops sun6i_r_intc_domain_ops = {
 
 static int sun6i_r_intc_suspend(void)
 {
-	u32 buf[BITS_TO_U32(max(SUN6I_NR_TOP_LEVEL_IRQS, SUN6I_NR_MUX_BITS))];
+	u32 buf[BITS_TO_U32(MAX(SUN6I_NR_TOP_LEVEL_IRQS, SUN6I_NR_MUX_BITS))];
 	int i;
 
 	/* Wake IRQs are enabled during system sleep and shutdown. */
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 8e2b00536c3e..9e2bbfe328f0 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1705,7 +1705,7 @@ static void integrity_metadata(struct work_struct *w)
 		struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
 		char *checksums;
 		unsigned extra_space = unlikely(digest_size > ic->tag_size) ? digest_size - ic->tag_size : 0;
-		char checksums_onstack[max((size_t)HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
+		char checksums_onstack[MAX(HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 		sector_t sector;
 		unsigned sectors_to_process;
 
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 51e04efe3e20..8f96ddaceb9a 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -608,7 +608,7 @@ static int check_dir_item(struct extent_buffer *leaf,
 		 */
 		if (key->type == BTRFS_DIR_ITEM_KEY ||
 		    key->type == BTRFS_XATTR_ITEM_KEY) {
-			char namebuf[max(BTRFS_NAME_LEN, XATTR_NAME_MAX)];
+			char namebuf[MAX(BTRFS_NAME_LEN, XATTR_NAME_MAX)];
 
 			read_extent_buffer(leaf, namebuf,
 					(unsigned long)(di + 1), name_len);
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index d86abdc77c26..e46eb93c115d 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1100,7 +1100,7 @@ char *resource_string(char *buf, char *end, struct resource *res,
 #define FLAG_BUF_SIZE		(2 * sizeof(res->flags))
 #define DECODED_BUF_SIZE	sizeof("[mem - 64bit pref window disabled]")
 #define RAW_BUF_SIZE		sizeof("[mem - flags 0x]")
-	char sym[max(2*RSRC_BUF_SIZE + DECODED_BUF_SIZE,
+	char sym[MAX(2*RSRC_BUF_SIZE + DECODED_BUF_SIZE,
 		     2*RSRC_BUF_SIZE + FLAG_BUF_SIZE + RAW_BUF_SIZE)];
 
 	char *p = sym, *pend = sym + sizeof(sym);
-- 
2.47.3


