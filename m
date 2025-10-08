Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1DD5CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 15:32:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 443B98E0033; Wed,  8 Oct 2025 11:32:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F3018E0002; Wed,  8 Oct 2025 11:32:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BB398E0033; Wed,  8 Oct 2025 11:32:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 162908E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 11:32:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E15C311A97E
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:32:30 +0000 (UTC)
X-FDA: 83975338860.13.A920161
Received: from pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.162.73.231])
	by imf25.hostedemail.com (Postfix) with ESMTP id E3426A000D
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:32:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=pW8wpnsG;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf25.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759937549; a=rsa-sha256;
	cv=none;
	b=NvVJIZQo22qS0XwMJtAouB82+NW0MXc4Pi+da/uOqj+Hru52vQiwXrNwhD4xe3BcmyDWKE
	RlauTWilFIwdPcR7aFqP+kSIo+bGGPTt1RZBxvExB2NKpEmVyzIHS1rcEr6i5Y5ZG58N9N
	npJsr/ZhjA3dwmh+sSxWJ5FtB6OV0HM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=pW8wpnsG;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf25.hostedemail.com: domain of "prvs=36971892a=farbere@amazon.com" designates 35.162.73.231 as permitted sender) smtp.mailfrom="prvs=36971892a=farbere@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759937549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Un1JE7toeI83ffXaasUfHmeV127z9Znvwu1ZeiNJbjk=;
	b=I392/t2vk6CCOXhiJSobINPHSeg8J2EIZpMOk/Ub0HDYP0c+y9abIAY0w+tEfjSL0c//Gy
	Q+pkGXuTUetyiBRSIKbFNAzvaQjHF/wXuIRIPtX9YQvbwuc31tFofxr90/Df374eJEVE7t
	UqxK7gMFXop68gbW/xem1ACqRBQJX1g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759937549; x=1791473549;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Un1JE7toeI83ffXaasUfHmeV127z9Znvwu1ZeiNJbjk=;
  b=pW8wpnsGyLMwUKKHzXTlX32nDSb9okK84uaKrcLvEey2XnDb70OXaNcl
   Qlsw9OnZSeQ7XrknbDP7m1GnXCgTOMiSnX2ieY7ZKRQOrl4y8T2rD8c81
   FgLWvr+78a1rZaCrskzfh2zLgzEZnfe+/zDOGxrLDKLWsuHliAuHK9YFJ
   TsSttJiimZH6UGkOb3tOd9O3rUdbdkb+oGZ2vdu3CE3Fu1U7oyfXC/Ynh
   LEh9MfEoRQJ6QVdqq4plAkR68KitZkJQUhlXviaWvHvn5Yce+L5u0aAxn
   Se7LeRC6oQX8/RrCW6/+UqHelolQnOvDA51dyIyFrrFAoIQWQMUd/PCjl
   Q==;
X-CSE-ConnectionGUID: VO6YsBsNSXaANBvNlh+3gQ==
X-CSE-MsgGUID: KH8LymOlQiKz7uJMMzNaRw==
X-IronPort-AV: E=Sophos;i="6.19,213,1754956800"; 
   d="scan'208";a="4335008"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-012.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 15:32:27 +0000
Received: from EX19MTAUWC001.ant.amazon.com [10.0.7.35:55614]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.25.156:2525] with esmtp (Farcaster)
 id 34c61748-f67e-47c8-8940-60a3a38f0fe7; Wed, 8 Oct 2025 15:32:27 +0000 (UTC)
X-Farcaster-Flow-ID: 34c61748-f67e-47c8-8940-60a3a38f0fe7
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 8 Oct 2025 15:32:26 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Wed, 8 Oct 2025
 15:32:13 +0000
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
Subject: [PATCH v3 09/19 5.15.y] minmax: don't use max() in situations that want a C constant expression
Date: Wed, 8 Oct 2025 15:29:34 +0000
Message-ID: <20251008152946.29285-10-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251008152946.29285-1-farbere@amazon.com>
References: <20251008152946.29285-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D042UWB004.ant.amazon.com (10.13.139.150) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E3426A000D
X-Stat-Signature: gykpmi5ygofitafy33f9kp7kox9hdzym
X-HE-Tag: 1759937548-212203
X-HE-Meta: U2FsdGVkX194yhgB7UwKMZZbIUqzpuGKzN347mlVMzBFRhBntmz5bneiVv4T4ykYLbKGvUsZ0mgJwmyIG2HQKY3dfOzbW55rDi61a7+ay5AcIZqXE/ixAlMTj5kFIdmvIVLBmaO5WTRIrJAVBkOqaJbh+BlaWi9zjudoiVmZgfqByZ2Y6Bq0RTYjgIV17bITK4F100xAjQzCxzqEtD7GJpAYhWT4mbMMld/hy6/73YRqIiIuseEeN77gCgxd7L7OTuQg2zqMCjGE59qh2DIt+pn8sZoNMs3pzmA+aVswKuwjapi2eJd2T3AzMMO7EY3AcZ24VQMWkIyRq7it7J+GmeKyEd/s7cT0WR6abSLgblhxgmGBwruPCL/S1PWJuPL9xH+NUJZdIpgt5wvHkxLVCrX1yyxJ0CpWEMIFe+RZWsXfqaGXV9CWrcOGXro6ZE7jTH3kxDPtwHpP1wVRQOObdzhHl1S0HSD30URgrE+w+8Qp8VgTqdSSprZ8p8yqzfjZDJvAJIhtkRQSiQW8V+jsJ5Y/24W3P5/UWfQTZ/yMX69mkoZw3Pq9muJIpb1bu/2btkn8xAZLLyWHfRQRskTCxJtXT11+Zvc1QE82zoUnUX0uFE0BUoesefcaDNDIkcoiCFAg6kXXFSsxSTng77GAhfzz05FzJAk1KyBx0+iBN9i8kcb38HPgQQ3sHg9Vee+tju+E/KfpuhWoCyXyZiWjF5eTOlD2aSPs6BUSUjmxyF3FRJaikIuYtgt9eZG0aTUipHzWfinI0L9dPpJiWPlO3avdD+Ctkz5O5ztj/LfnqvNJfX7KLDSaQj6IR5tSyygJ9IOshBw0l5lCPA6iL0rJ9Txm2ZkYd5e11I5SKwxvZLGN+Gk0vpuan7sc074ei+n5p/kmAN+f/1440r/CzqflipqH58TDxhybwSeSKxZ1ZAqicoDBfceHwaGoevC6hPhnIcFXzQAiX51tar53g7f
 0cpJWxmS
 shiocyuHUP2jM62G9ioYozM0FXlHcWwPaNvG+lKTgEWoVJtbjDu1dKgZa+H1sXi7wUC6YvpsHhENvZTDtcBqyvQWIWgfwd/oLpiIxIFsLouC/AtaIPlN5QVVa3gbSqu3+NNCj9hK3FxXguEkEEumB/Xc//RdnR+4257HNJrdtlJI+AjOkLqyTaNjWJHuzyEtD6oC9DbK/hnA1F+U6rddnIGxx2sK/GRDfICk4yi9o1RlMqWRTRylm338p3AuWLTt/7aCmwKqOtsTAe6LuxpNDyf7z6x3reCtx4z4orM3uI5OyU2rSQncR699XWA0i+GcGSWe4P4n6KvoVIDZeGX/zz9XPu88LievO39UiiAtnNT3ca+lEyKxdMBgnMs1BwZyWioLbUPsS1UKWu6EFdbO+HIUcpjKKkxULxXXWQ/GNsS+K+nxgOSZc0Bw5w8Qo8XLRkVSulw7f8nICPoo+upsCkBkj1ZSB/R/H+nvMfY53JlCGWbej2dUm8TtKVf73XlLhuB1hDUwgY/PgCmw=
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


