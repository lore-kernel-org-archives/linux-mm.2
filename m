Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69DBCCCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:03:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B83ED8E000D; Fri,  3 Oct 2025 09:03:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33B78E0003; Fri,  3 Oct 2025 09:03:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FB638E000D; Fri,  3 Oct 2025 09:03:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 84FB78E0003
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:03:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2871DBB7A2
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:03:35 +0000 (UTC)
X-FDA: 83956819590.12.C9BBED9
Received: from fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.72.182.33])
	by imf20.hostedemail.com (Postfix) with ESMTP id D36E11C0012
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:03:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=FSEwAztK;
	spf=pass (imf20.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759496613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h6eaybfUIHri1PQa3DaCeMW0pLnOJiawM1CfNxoKB4M=;
	b=hCawreGZC8gwtodtB2ou4uUHIsX6iIHVt/Lq/whr0kBeYuXAkpNeqw+3GeqS4u7exzhj45
	gRS5eyP0zFdVvwZ20oCvaNKam+tucwHuLnCC6MiECm7EitqkuKVxLJ1G2HDm1RYin9583Y
	ZGtDnS+vnHlxUeQyZqNuBZb1mRxoUvU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=FSEwAztK;
	spf=pass (imf20.hostedemail.com: domain of "prvs=364745ad6=farbere@amazon.com" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=364745ad6=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759496613; a=rsa-sha256;
	cv=none;
	b=CaGyFkAu75ZhiLqrFvbRFtqenQr9NHa4jT1bmdYzo80ci3VuQL71TmncwFZ8+mgepuIruX
	cD2q0dxMzu8rrE/34Qj3VvxolEm+lWpCX1DZZQX0mugGujKikkIGs/E0PIVFhYXQrT7lCM
	57kzyG6wGSXD8ai/Q/mnqgAyISuuCdU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1759496613; x=1791032613;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h6eaybfUIHri1PQa3DaCeMW0pLnOJiawM1CfNxoKB4M=;
  b=FSEwAztK2GTyI6aWnUgxdeHx0es6/7dK1tsbnenlA2sfVtm7kzlv2Zc/
   3vVRK4CpEGHmJkjJnaDsog8unvsOHFDkYjgxtuo3sVGh0ChJEeNUgQpJl
   8Z6cESZs5+ylVI3QZ2pbzTHQFkQ55XhMiltuL7sGiJymzLsjHO/bpNEJN
   0gI6QWW3SRIOzzaeobSrL9uyDbPvTnwb3ReOsxvX6AiYepWlyNNkh95D2
   YSgoUwHL3Di8g9ExtgKlxk5iZUIix7oJ2748qybWa0yeRwgqptSBB6H7c
   8h/XeqQ4tHFtELTrsoa3g95g4IJsv6Ctxy6eZ+WweM9GpJpGRLQwYKPfN
   Q==;
X-CSE-ConnectionGUID: 74q0E1CMQNe1HznF+PW+Kw==
X-CSE-MsgGUID: FbynHC9uSg2SJQ/xlEwpUw==
X-IronPort-AV: E=Sophos;i="6.18,312,1751241600"; 
   d="scan'208";a="3064066"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 13:03:31 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:7571]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.19.222:2525] with esmtp (Farcaster)
 id aa31f62f-7712-4dd4-807d-ed7270cb9a85; Fri, 3 Oct 2025 13:03:31 +0000 (UTC)
X-Farcaster-Flow-ID: aa31f62f-7712-4dd4-807d-ed7270cb9a85
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 3 Oct 2025 13:03:22 +0000
Received: from dev-dsk-farbere-1a-46ecabed.eu-west-1.amazon.com
 (172.19.116.181) by EX19D018EUA004.ant.amazon.com (10.252.50.85) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Fri, 3 Oct 2025
 13:02:57 +0000
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
Subject: [PATCH v2 06/19 5.15.y] minmax: add a few more MIN_T/MAX_T users
Date: Fri, 3 Oct 2025 12:59:53 +0000
Message-ID: <20251003130006.41681-7-farbere@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251003130006.41681-1-farbere@amazon.com>
References: <20251003130006.41681-1-farbere@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.116.181]
X-ClientProxiedBy: EX19D043UWA002.ant.amazon.com (10.13.139.53) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)
X-Rspamd-Queue-Id: D36E11C0012
X-Stat-Signature: 1t6w5ub9pme1sh3xsqp3wss8qbymuaqi
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759496612-187269
X-HE-Meta: U2FsdGVkX195QDx9pUTG+1KLSOPKfX/4JHBYbeFj+EBBOpJsDIJ4NnnCgH19WQD9hTzIUeTq6Vtk7k1LiO4J49/XY1UdEfQy+2B56O3syNub3zP42DUoXAAAQbwzHDqRlU4tJFGlpyxxj9Ol1HQHvBUiq3ZDKrmW7DHTgnNDhMCQ+K0QEA24/+m7SBS7sITt7wc5VtHcNRRwij4fKqqeg4SoPP81bXXw+zUFlp/pZEJD3dpIVKMcTp2wvkN5AT73km4cPBlU4VKVMmJe/pKqFvZZEIlbNmgDgllYnQX+M44CcihOfc/LKgnW2j3EuJjPBm2eDLsG3fWaSkDejVeMLtaMZiQpR71RZDyrwU1jsYOGH+1nzeP9ZJitYn9qagcun+H6sYbFsjfKM4E6Yr/Yh0udQl9kSI+hZqhIX5to/jFzOGfOW1LhRIDwjYt/T8qlCxmsjI7/BD/ZxNNRDrlRaMBoRY/+EECrMHCLcNAOtganDpE/M3RB6kniKT49cPYKXF/tt1c4w86GwJ4OuyTPogmy1eoyLKU4ckcj60NxZ8W28U/EGH/gUjKedyW+Z0Shu4iCGASxttabyhX8VINZyEj77R2uQ5lI0Vawr3fif9l390ewy259w2WQT5a7Ixq6I2vRneHDSrNDKLCPIcEwMfTrpmt0gHVPwLexGCA8kHHoagg9YHI9dlT7bcIt04ePm7gWHXItSZ9Z/9l+IIyZtDOYxUHS/tTuYm+X7hNR9Q0XEpbykZ6ro43cAbCup9S6NVQiki4cjaDV16WklsARaNJGjfdXW57CmvGrIRh+KHtaQRsO2ifBbPxtwMTOM++kvOiKA8XZoS0+7pLYc/s1liIgk+f4N+COzPWN1xP7O61NjGXJ73Bnm7l/rvGcpLrTktrsCU5lFy8yiFA86BIZlt1CkG8RnZD1mEVi6b4rAEyLiyvdb7tRKLIfWhY4Dbhs9ucpKUHGP3Qk2hDlIUB
 2bq34rsq
 LIJi6u+/qOQmsBoK34N7VsTq8z9Os8sFDQXKO3qXHLvioVbTM//h5OPu93o/csqet7/yjVYTY4oHPCky3BEanbypP1RrCOTk3Ad2XK3ajEHXW5SknwnsDifJRVem5ud+9NcqqWqz6EEdg5XDhYAIiRnrULqy/JUgOfOzqMgZUKWjq5QCNY6WpnNUEGK//Vmn+zMoi+Z9Xxbug4Vl3t96GqPxlKcYPofP67l4YE+Mcv4RduWc+HZ5THv6/9GsY5t6/kxeKIZ6Y7I1vCjc6Fph/gRNeKqRC7mvuKB59ni8VSSYwoC9pDlTNQqDqnSYlGsEFReEIiRIHQ4/qrfzUQg8ITKiEG1GA77LK10JzkTMX41fwsNrFMp6mFeU+IdCVxkoMmlGAdZ4TIZ/E8yEyybVMngng6buOuxeX1jDIVWFu2Je4Es1oUR+WfbwYSaudsg3PH+i/TuB5hpjcwmam0/S5n6kDRsrXICysbBcSzJzjr3rXpHXVmvhVKy59/bE2CSPfSUM9jdFp3t8rNlpXpAy/pLfuwYFNXt19HeyFiHKwe7GBEUAwgEsjTccVL+UEKve6LSUCKzKXPFb7I9LlIQ3CpujLkHSyYmKkThcUS4sLcOgTpGusYGsi8x/sdmpSAcwZKMo3qPbj8rpX7hMbCTVL500P76HxPoEctZ+tik15CE7jx4cNOBL/BjyUbR79et71lIEH/IQFDhOneMylz7VJo2V4FRP0h5q9Xj+PmVP323iM++AisUaYWyUmk5UHXS4O8AZpyT272gD+J/BL88dd9RlWFEPe4UnOob80itncPM2VK8RzoZS7yoYNs1oP+wx6+nT4UWhkPNhh62y7GpLtKEE4wsqdonMZt/EdEPXnkE0T9pc+6sZLTYUrAT6J/YBZM7jDrnkR8pu5eL65hbahAd4Vm2Ud3ur8kl5D2JAhK1DGhX/nhtNfLOhBOzt5mdKzrFU/sGL7DO8UfYVD/OS6SVkYKKOB
 3UiEgC9K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 4477b39c32fdc03363affef4b11d48391e6dc9ff ]

Commit 3a7e02c040b1 ("minmax: avoid overly complicated constant
expressions in VM code") added the simpler MIN_T/MAX_T macros in order
to avoid some excessive expansion from the rather complicated regular
min/max macros.

The complexity of those macros stems from two issues:

 (a) trying to use them in situations that require a C constant
     expression (in static initializers and for array sizes)

 (b) the type sanity checking

and MIN_T/MAX_T avoids both of these issues.

Now, in the whole (long) discussion about all this, it was pointed out
that the whole type sanity checking is entirely unnecessary for
min_t/max_t which get a fixed type that the comparison is done in.

But that still leaves min_t/max_t unnecessarily complicated due to
worries about the C constant expression case.

However, it turns out that there really aren't very many cases that use
min_t/max_t for this, and we can just force-convert those.

This does exactly that.

Which in turn will then allow for much simpler implementations of
min_t()/max_t().  All the usual "macros in all upper case will evaluate
the arguments multiple times" rules apply.

We should do all the same things for the regular min/max() vs MIN/MAX()
cases, but that has the added complexity of various drivers defining
their own local versions of MIN/MAX, so that needs another level of
fixes first.

Link: https://lore.kernel.org/all/b47fad1d0cf8449886ad148f8c013dae@AcuMS.aculab.com/
Cc: David Laight <David.Laight@aculab.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eliav Farber <farbere@amazon.com>
---
V1 -> V2:
Use `[ Upstream commit <HASH> ]` instead of `commit <HASH> upstream.`
like in all other patches.

 arch/x86/mm/pgtable.c                             | 2 +-
 drivers/edac/sb_edac.c                            | 4 ++--
 drivers/gpu/drm/drm_color_mgmt.c                  | 2 +-
 drivers/md/dm-integrity.c                         | 2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 +-
 net/ipv4/proc.c                                   | 2 +-
 net/ipv6/proc.c                                   | 2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 3481b35cb4ec..e649161eb6fc 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -107,7 +107,7 @@ static inline void pgd_list_del(pgd_t *pgd)
 #define UNSHARED_PTRS_PER_PGD				\
 	(SHARED_KERNEL_PMD ? KERNEL_PGD_BOUNDARY : PTRS_PER_PGD)
 #define MAX_UNSHARED_PTRS_PER_PGD			\
-	max_t(size_t, KERNEL_PGD_BOUNDARY, PTRS_PER_PGD)
+	MAX_T(size_t, KERNEL_PGD_BOUNDARY, PTRS_PER_PGD)
 
 
 static void pgd_set_mm(pgd_t *pgd, struct mm_struct *mm)
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 1522d4aa2ca6..714020e7405a 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -109,8 +109,8 @@ static const u32 knl_interleave_list[] = {
 	0x104, 0x10c, 0x114, 0x11c,   /* 20-23 */
 };
 #define MAX_INTERLEAVE							\
-	(max_t(unsigned int, ARRAY_SIZE(sbridge_interleave_list),	\
-	       max_t(unsigned int, ARRAY_SIZE(ibridge_interleave_list),	\
+	(MAX_T(unsigned int, ARRAY_SIZE(sbridge_interleave_list),	\
+	       MAX_T(unsigned int, ARRAY_SIZE(ibridge_interleave_list),	\
 		     ARRAY_SIZE(knl_interleave_list))))
 
 struct interleave_pkg {
diff --git a/drivers/gpu/drm/drm_color_mgmt.c b/drivers/gpu/drm/drm_color_mgmt.c
index bb14f488c8f6..1ff572d8744e 100644
--- a/drivers/gpu/drm/drm_color_mgmt.c
+++ b/drivers/gpu/drm/drm_color_mgmt.c
@@ -528,7 +528,7 @@ int drm_plane_create_color_properties(struct drm_plane *plane,
 {
 	struct drm_device *dev = plane->dev;
 	struct drm_property *prop;
-	struct drm_prop_enum_list enum_list[max_t(int, DRM_COLOR_ENCODING_MAX,
+	struct drm_prop_enum_list enum_list[MAX_T(int, DRM_COLOR_ENCODING_MAX,
 						       DRM_COLOR_RANGE_MAX)];
 	int i, len;
 
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index e9d553eea9cd..8e2b00536c3e 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2536,7 +2536,7 @@ static void do_journal_write(struct dm_integrity_c *ic, unsigned write_start,
 				    unlikely(from_replay) &&
 #endif
 				    ic->internal_hash) {
-					char test_tag[max_t(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
+					char test_tag[MAX_T(size_t, HASH_MAX_DIGESTSIZE, MAX_TAG_SIZE)];
 
 					integrity_sector_checksum(ic, sec + ((l - j) << ic->sb->log2_sectors_per_block),
 								  (char *)access_journal_data(ic, i, l), test_tag);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 2478caeec763..21cc8cd9e023 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2805,7 +2805,7 @@ static void stmmac_dma_interrupt(struct stmmac_priv *priv)
 	u32 channels_to_check = tx_channel_count > rx_channel_count ?
 				tx_channel_count : rx_channel_count;
 	u32 chan;
-	int status[max_t(u32, MTL_MAX_TX_QUEUES, MTL_MAX_RX_QUEUES)];
+	int status[MAX_T(u32, MTL_MAX_TX_QUEUES, MTL_MAX_RX_QUEUES)];
 
 	/* Make sure we never check beyond our status buffer. */
 	if (WARN_ON_ONCE(channels_to_check > ARRAY_SIZE(status)))
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index 4b9280a3b673..d849f61b7519 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -43,7 +43,7 @@
 #include <net/sock.h>
 #include <net/raw.h>
 
-#define TCPUDP_MIB_MAX max_t(u32, UDP_MIB_MAX, TCP_MIB_MAX)
+#define TCPUDP_MIB_MAX MAX_T(u32, UDP_MIB_MAX, TCP_MIB_MAX)
 
 /*
  *	Report socket allocation statistics [mea@utu.fi]
diff --git a/net/ipv6/proc.c b/net/ipv6/proc.c
index d6306aa46bb1..e07c43bd5cb0 100644
--- a/net/ipv6/proc.c
+++ b/net/ipv6/proc.c
@@ -27,7 +27,7 @@
 #include <net/ipv6.h>
 
 #define MAX4(a, b, c, d) \
-	max_t(u32, max_t(u32, a, b), max_t(u32, c, d))
+	MAX_T(u32, MAX_T(u32, a, b), MAX_T(u32, c, d))
 #define SNMP_MIB_MAX MAX4(UDP_MIB_MAX, TCP_MIB_MAX, \
 			IPSTATS_MIB_MAX, ICMP_MIB_MAX)
 
-- 
2.47.3


