Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C55ACAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9C698E0010; Fri,  3 Oct 2025 09:05:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4C5F8E000E; Fri,  3 Oct 2025 09:05:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9141F8E0010; Fri,  3 Oct 2025 09:05:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 784F88E000E
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:05:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 40B171A07D8
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:05:08 +0000 (UTC)
X-FDA: 83956823496.22.27277AA
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	by imf29.hostedemail.com (Postfix) with ESMTP id D8E6F120019
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:05:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=eS09I1y7;
	spf=pass (imf29.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759496706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Un1JE7toeI83ffXaasUfHmeV127z9Znvwu1ZeiNJbjk=;
	b=QRexHc/dvkDVOpNOylMcu8sqEDpWYH7TRMQz2zjy1NIEjtbmI+Vsoe7yrqF7SFy4B4AjQ8
	5hMXyRAkFhp+BpMa9JAQL4TCdZq0kFpNToSBxVoKa0rnpNUUY3JidzMtax/XLWyDCy8kgL
	dVy0IF5DXJTIekMmUU64jzYFCdhv6GY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=eS09I1y7;
	spf=pass (imf29.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759496706; a=rsa-sha256;
	cv=none;
	b=WsLDT+6AzNekKojT5UGKqiI/tJX7yevoqAvufpoubSO7TmpAYDDxIu0KUMfI8pDKQAnauy
	gpEqXAy/YSXM7QL998hj57Fn0iYrXK6hBhSIAh3ZN9B+7LC5hrt6LtfLK8tB1SKE5YpgUH
	WVvnqP69QxN+Ei6SfslJzqKHXlEy/aI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759496706; x=1791032706;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Un1JE7toeI83ffXaasUfHmeV127z9Znvwu1ZeiNJbjk=;
  b=eS09I1y7kgTISphGzClBMADKM582ILMCpITPAiG1PnRKpSq+o0Gyg8u5
   t753jNWfbozBLZ2/Rv0LUmi2PTRk+oQZH95VCx9yJwf74BeWGWosk4J3g
   hI3Qv5LmkOzGV96b2lnEYc89bCK2ggtZI0o+Yf+WMVyMjMFkz7PFrZJ+/
   3ECpAHd/1FUKoWpjtqGD2ZcMhj0duGisUTnzjndJSWli1OHrwlF6KHe9y
   cGRPRspO4J4cs8F5FmBh0yPFcgWK64ILTdv8sqFjV4H59FvACUSVajHh2
   LmoBF+LsfxQc8Kgjbw7/+5ouPIipNM15FGAhn3bB3u+ffE/LBwF4m2upO
   w==;
X-CSE-ConnectionGUID: 6R4CGBMrRRGA1NnFWvKwdg==
X-CSE-MsgGUID: bMMiRLiJRyytxeFDcKdX/w==
X-IronPort-AV: E=Sophos;i="6.18,312,1751241600"; 
   d="scan'208";a="3063483"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 13:04:55 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:25758]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.4.140:2525] with esmtp (Farcaster)
 id 41f1e6ba-7354-4550-b09f-a78bf412bfba; Fri, 3 Oct 2025 13:04:55 +0000 (UTC)
X-Farcaster-Flow-ID: 41f1e6ba-7354-4550-b09f-a78bf412bfba
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 3 Oct 2025 13:04:52 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 3 Oct 2025
 13:04:26 +0000
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
Subject: [PATCH v2 09/19 5.15.y] minmax: don't use max() in situations that want a C constant expression
Date: Fri, 3 Oct 2025 12:59:56 +0000
Message-ID: <20251003130006.41681-10-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251003130006.41681-1-farbere@amazon.com>
References: <20251003130006.41681-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D040UWB003.ant.amazon.com (10.13.138.8) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: D8E6F120019
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: k6uez1yf5izkwqp4xkoi7cmtce9tii4w
X-HE-Tag: 1759496705-76510
X-HE-Meta: U2FsdGVkX18ccWrIV56nuEb3Tb8MIWa4S0foG970rURRI0H9xDIzzARBJtnjwiG5hTHO9ezErlYYCkrkEuYd8TnNhPC1s8q0Wad4uej9baVRaNys5xF62iZT9ERoDoxJwxEXwnzkmYUwhD/VYXDPDOGBtOZAN2QcSyqip+Cppg7Rs5Fb4WgWosXTlR+ynGdILEaawbcl4Q1kj0/vkayW0M21eZtgACay+wcH+DGa/6PXtu+BdCi2PO7hoLpSKHEvNisaEauywjLfzXiR+LerVNQkAfDz5BaspzIU9QsAOkjw7waFKz2B0qxmWhXG12D9vxfFg1NXBIcgixcdKsJYvnTIN9fogr71PweSDOSI8BFpxjki9djddd8JqxExkvNR2vFqOD5+lR2juaXywTwHtcCzcTO9kPDx2KCg1+8JZjBIpuTV+len6K3xRQIS+7cywOxCAAcKJdNJFRTjYmVUhb6ALwS313XRAtBmiD3hkodNcyoEPQLKfwnVY9ZdVvRr7X+/L6C332YuGmBGJs49K1XRh6yWjEFWj1+qOPkufi/GEW6hMfSofyMqxSO3l9IH8pkg2TWgL5V/muqlpLW4oVlZEefnvzfZOnpBx/fT1hRpVuLoIlZiM9Ifj6QthhCpoWL5KD4ImICzzw4slJMpgGudf0Tvh4Fyx0Qobq8qAVF0hUT/kMouOpr9DDmo+tjLxxumDFwIJq2ODuy3gCLMTfofVLL7vsSrzSSQKYwAqVX4XRrfXkYnW9pFT93Yqm5TmgRJcoNpHq7zjq7X3nyh16BF+uQq769SW90eD0/P8Sbu+0rqtHH5Uqix5zKKJqY8vXzaZ03GFXUl3utWsMBaeaQXhERyC1HC25LkN5/7er3Q33Qhya2jdjf8IluFBJoJFJBM6BD0oWFA6+bkWBeSieuq3T6/b0AXscYmruNIu/QO0xrVdN53j4zUIFPnvUoM3kXYMezOaOAPBl315Q+
 aHBoPxNw
 bYa16SHTzd/K1sjqo33yR+VVwXmx3M7EZ03EPeeCzzQKxwDlhPBIPTx6PYfHUPJak78+8U/A4RsdrokI5lVpNTZlF4YzoEbce+ugqsSyoaixYdi+sKUiWBs46MWgGDczxwfl3+39h0V6XRQxJ0qTcOWla94OX2LBPGwzGeXA9TqEsQkJfkQqVt7TNXmlvNP36sN2FQap+O3Q4ruEKJUhWBjHFaveriEOUt6nAV+3c4IwOmxL9trKJPZ29Fc15wOK2mIJ0xmtn7sXf/T5MvUgoEaokTbEwoqIroMBz4pzb9aIXSkVB4TaW+hRxxsPaNYRePNL1LmIvj/20qAFhcLSvNKaBzBMiGG7DTqh0uUmBWfa4xCeOk2Vz1Un7ByMZ1Qc5StvKRHNa4jbXqdxbDZBNuru2aIjtrU72rFJDUd7HOYj0jvG4RlWovteuRQyWKWDsjJTK/SFWIKUAyPJPXyhHfLlFmfpYFUdHGrI5MDSx7cFSCPvOrP8VKpIISl6MFxDYSzNXg0XVaQ0iz7IJZMjbyKs0Q1JBNicRlRGO5QsOASFah1VsVBI9dmN+35/zSu3zb5sfk07w2tk/SyrJHrnJHMH/IuhhvaWfT8tPA1f3mm3H4tRqIzR0yT2VVqb9FIceye5EZ/6wC0H0MiZj4ckUSKGyqsBmgM3rp7HGtA9phhF5Qea/3USaHc3uxQUmzBN5L9NIoIaK2QeEpDvG3Zwvi6t2twR12wEKiFrciLFXIr+wg5Ze3/ehzABPuK/We30PazrutKYih1iZ4T29hwg4whS+Pclgm+ak02zFQm45J+pYyxvGKYeKMhaxsOoDut16AG/XxcTeFiOzV0bk1douZe2gI9BPQWP1c5aR32Wn/7U9caBMLXcIEtuKrPhdcgNxsB9cA/QGly0u8k+hAT351+ZQbOEv0oGno7hQbPnuk5PYXQ1j5jOAioB13p3qgDe2fH8RMZvGewQn4oh52ck0gpYGRpQc
 zTUCXArN
 mh5E+/83WV/nvPWQWPXPKC4eK/4xQFsFXWVPj0wPNY+PD4q/V9Lxzw==
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


