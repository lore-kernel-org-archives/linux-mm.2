Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B5BAEB105D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:57:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CE6B6B00C2; Tue, 10 Mar 2026 07:55:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52FC06B00B9; Tue, 10 Mar 2026 07:55:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2733B6B00CB; Tue, 10 Mar 2026 07:55:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F11A6B00C3
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 102F1160148
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:36 +0000 (UTC)
X-FDA: 84529998672.01.D454FF8
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	by imf16.hostedemail.com (Postfix) with ESMTP id CF68818000F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=FuoIkm8y;
	dmarc=pass (policy=quarantine) header.from=avm.de;
	spf=pass (imf16.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PYVbgZ2nKxN5YxfS32Q6BrkzgM9oUAmR+BouSLEtSW0=;
	b=YPc2/pFnPPR9awhN+jxO0jKdcSxh3BOAtbTqfnxWFBujY+Zl7+65vxRE2r0M5Qj6wykK01
	Epk79RRdez0poOtxmsRF5YAnTtDgTvYQzevQPmd9NEPakBxoq2D71W0b41GTKzLnSLsK3O
	mSc26/mkSRgxZePHwxduzNN/steG8RY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=FuoIkm8y;
	dmarc=pass (policy=quarantine) header.from=avm.de;
	spf=pass (imf16.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143734; a=rsa-sha256;
	cv=none;
	b=RHaKxG4qL59jii4vl27BQoNgqPCcZu/8wm54RPMXLHdKUKMce7GDixQZfyiBz1TO9YPTww
	LUA3XEYSFwWulqpVU2SvK6aTh8pqRSVjAWnTEKRSh/hJB1iBKVEsEyqPluk5MbpebxicP0
	FH+XPK4H4hct9K7nTdOLsVN/3REKIUM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143729; bh=D3MT7fsInTbF+Q1IcBY1KlhxZOhv8n1GbgMEryPc1iY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=FuoIkm8y1r9jmy9XkB/nIcxLjk6bi+LjK6sb5O5ohjTjMY18sKNe5fNP8s8fr+eSE
	 cVA8MM9YDRtdE2+c+3jQLNZHyd4epnj5ZDnSjfPWRMAs2R10VO12Ss6TLbgdzang/C
	 IuQfXi2yHqFGvraOYFSaQFSWS/mBIxmUmEAiJKQg=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006b0-2367-7f0000032729-7f000001ca2a-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:29 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:28 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:22 +0100
Subject: [PATCH 56/61] clk: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-56-bd63b656022d@avm.de>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
To: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
 bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
 dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
 gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, 
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
 linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-leds@vger.kernel.org, linux-media@vger.kernel.org, 
 linux-mips@vger.kernel.org, linux-mm@kvack.org, 
 linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
 linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
 linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
 linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, samba-technical@lists.samba.org, 
 sched-ext@lists.linux.dev, target-devel@vger.kernel.org, 
 tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev, 
 Philipp Hahn <phahn-oss@avm.de>
Cc: Michael Turquette <mturquette@baylibre.com>, 
 Stephen Boyd <sboyd@kernel.org>, Daniel Lezcano <daniel.lezcano@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1921; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=D3MT7fsInTbF+Q1IcBY1KlhxZOhv8n1GbgMEryPc1iY=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAaUcbSjlqDNveOR0T7quZaIRE99Gs4Y40VBm
 M+JmB4D/wiJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGlAAKCRA0LQZT0ays
 29iMCACZFg0QUOFeRuYtY3bNuohm/w3gB25wtydzkEpw1y51B0CHIEYO2D+JTSeLzAXWxzoBnW9
 HXPmPssLJbvCLWKHMMkr0gAWPlZj2r2H5W9oWdTzVn7prfkWfj3QlC8PF6krEUlEdaF6S2eKHnY
 z1zuimMLbUrpcxQrqC7ES4i2d/Rp5LYwIEnS9CU2G4AgF3dSj7KUVqb2Lo1UirL++DC+eGcQfPA
 Ura0HOmvOdmbreSMPuxW3hgubjzqbYDJe+u22CiDbkdU8O1mLNiEw60lO04uucHvbyqPHMrNt0s
 Po0xv5cdM7Uk0fq2L3KaKWcmaytoRStiJNfwvalXm+okYQVa
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143729-974B6E1F-DBF721A0/0/0
X-purgate-type: clean
X-purgate-size: 1923
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CF68818000F
X-Stat-Signature: 65joh6tq5qaj6x7tejyezgptmoybis5a
X-Rspam-User: 
X-HE-Tag: 1773143733-80446
X-HE-Meta: U2FsdGVkX1+2J9Do2B1HcGZbFn2YTc28BkL3uDYlirqkcjFGuniSkb/h93rWBfS6ANO8NsrjJt7PF5AkyxiJURyAApuAAlHAMAdAKfDsvxrOXbu8sV+w/UQN8vrSYz/NWqs0Rr/ImphMhXhMggJhEXd5L6iPdpxLn9TcjdCHFck+SB9y9fpmeDJ7Bv5V2PnGm6J6w17WopN9LjzV2epYdhbZ22Y1sNFHVApFI3XmOPrTaidOw2N+N4SVwS6dzUqb7DwK+5HlKHCENgVkGThMLoqRvllnUACfbFYHlZCjN6KrBtTIgW+1l4X45oGTDJ7MEg+5EOVA4iDlXmwLdOh7zW23iCxUtLWQmnWAOvXaIR0/tJiMtW5fggSu5qvADhpH2Sj0D6Ggp0tn3qmTSnBxlNrtfZ7MoJmNhXgfNKZzHZIZblUFQTJF/DJPfDaJ2SVJ8EZ6ESz2lUGM5TwnXxerh6OEXxcIivYvv7wCIBOfd9EhvJaomfPCgwbyG3JmJHYDBPrGi7jcNSALp47xQQYIe34heUQt35qmr1RxaNo+jMnlTYxpIrElSoNcjPQl+DCmyY5aJj2MQyfmylebphz/Uu1njBzMkElZEjfprzBFQ+IVw6OEU3RJvGLGk/Ndaw0eWoi36cEP8j6hdNC+ClkDmIJFoqRJWZuCdlQuw1H86B4Xs+1v8dOvhtApOqEBasqfslWIB9zSbD5NG8eWMf3kZT+Vwb1xB5hLUtzg1oj0UecqF6c5WBEdaWPcvpgf6UO77B7KXEcS06oo/B00VYVFT5X5u+Dvhq1m7/YEJTfvCkAq4iiw3Jw6TWVwHT9tfM039B/nM0Gog6q9VwuY0S9GwMKg8DhaW4lByY5qmIHxT0g1z3TGqkcEnskej2myxxRpEr1mYf6n0/I0MATPX+eOkVWV77rUGBQHfAdRS51f0KNJyVhc2ATnoDIIQqUG3MOJctPUYXCbzT9vrCObHRX
 TQ2Aawn1
 hvMdQRiCnaV6blG2t1ibnUaQtrkrk4EzF8zR8FTy4xJJBSvEaevvGkAL0u81JxXU3FrW5r/9sZH+VtuHkg2czjieJvpsJjNR7tDtGVnFk2IElaVybKe0ZJmWvqyfl8JWObGbSXRRbQLtYS8mC/325B9L6WWUO6LXvtCYopccmB5sUH7Jd+dHkXCUBNVkJIKdZv+NmxND8EUs/PNxNxNDrwLj8rJZMaxz4y77nOhudANcGEvBMP8zvuPKlVJ/z6vA4UCsdLcrfYJZM51DydTbenFKEZRq70+vfUX47aOZTL+iAoR/crTeg6NVaBzK6022qIexhOWgCJbPMp4kvZVtf9vahH2qV+JdGbwnCek18X0EBYexILvywIR7XIWeDcFPBGnXgHCmfReaJFE09aLnW8y12pmhKJbJa4KFdCBaHSQikpPQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Semantich change: Previously the code only printed the warning on error,
but not when the pointer was NULL. Now the warning is printed in both
cases!

Change found with coccinelle.

To: Michael Turquette <mturquette@baylibre.com>
To: Stephen Boyd <sboyd@kernel.org>
To: Daniel Lezcano <daniel.lezcano@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>
Cc: linux-clk@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 drivers/clk/clk.c               | 4 ++--
 drivers/clocksource/timer-pxa.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 47093cda9df32223c1120c3710261296027c4cd3..35146e3869a7dd93741d10b7223d4488a9216ed1 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -4558,7 +4558,7 @@ void clk_unregister(struct clk *clk)
 	unsigned long flags;
 	const struct clk_ops *ops;
 
-	if (!clk || WARN_ON_ONCE(IS_ERR(clk)))
+	if (WARN_ON_ONCE(IS_ERR_OR_NULL(clk)))
 		return;
 
 	clk_debug_unregister(clk->core);
@@ -4744,7 +4744,7 @@ void __clk_put(struct clk *clk)
 {
 	struct module *owner;
 
-	if (!clk || WARN_ON_ONCE(IS_ERR(clk)))
+	if (WARN_ON_ONCE(IS_ERR_OR_NULL(clk)))
 		return;
 
 	clk_prepare_lock();
diff --git a/drivers/clocksource/timer-pxa.c b/drivers/clocksource/timer-pxa.c
index 7ad0e5adb2ffac4125c34710fc67f4b45f30331d..f65fb0b7fc318b766227e5e7a4c0fb08ba11c8f9 100644
--- a/drivers/clocksource/timer-pxa.c
+++ b/drivers/clocksource/timer-pxa.c
@@ -218,7 +218,7 @@ void __init pxa_timer_nodt_init(int irq, void __iomem *base)
 
 	timer_base = base;
 	clk = clk_get(NULL, "OSTIMER0");
-	if (clk && !IS_ERR(clk)) {
+	if (!IS_ERR_OR_NULL(clk)) {
 		clk_prepare_enable(clk);
 		pxa_timer_common_init(irq, clk_get_rate(clk));
 	} else {

-- 
2.43.0


