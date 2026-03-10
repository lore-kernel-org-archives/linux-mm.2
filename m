Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8B51EB1053
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:55:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1DA96B0096; Tue, 10 Mar 2026 07:55:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2E2D6B0093; Tue, 10 Mar 2026 07:55:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80E5A6B0095; Tue, 10 Mar 2026 07:55:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B28E6B0093
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DCA771366C4
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:28 +0000 (UTC)
X-FDA: 84529998336.13.3240377
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9234A40004
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=bIWX9HTo;
	spf=pass (imf01.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kFNnc0fM/uj/UTRfoSSwiw1Kve/S6tlLTERJUkGw2mk=;
	b=NZ13PStpjrnaTTDKoFKlI2pbsAiVz4H6HGIu20brBRhjYszriKBRfjR0MPcGJuiaoMh99o
	crRQRyyMGfR+LlDyTcdE/z/+X8Xyj8BbGxRP8MgNdcCfVfXoVO8ytkuPEzjQAK7h4zBv7c
	rF3GVXi9fXO3eVzuGJtz3DEmdFtuvuo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143726; a=rsa-sha256;
	cv=none;
	b=kCLhwA3sl2H+eBYJYWJACRCqb9+d4lVh7CLdI532uHg2ci4n9Vdz+gvcXY7h1Bd0keXCpv
	JSd0V7FDiP7IeFAHiOk/g/7ZYqfAWlYqVBvOe1Tlc1jzuC5tHXtvmMTSXPghKmB+QgQoYY
	lENh69w+UVLbkX377XD7UC0o1tJ4HH0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=bIWX9HTo;
	spf=pass (imf01.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143723; bh=pg0bcAlKCqGzZYxxvjTHT3BjuiImw/JCztrCxw0OaYk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=bIWX9HTo18B4ZE3sIquR8sbft3qzxzntZILxo7B74pgnu0rbeOHxAC7dlzZUeUKhf
	 HyziuuxI8v1FJdI0XETgMVlTILYL71/sVzADfcPBmDn0JPtGKUshimXXHFg01f3FBK
	 jYVNQFVbnSBvARzQ5cTWzBurkew0k16ZhIWvNTOE=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006aa-2367-7f0000032729-7f0000019cb8-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:23 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:22 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:27 +0100
Subject: [PATCH 01/61] Coccinelle: Prefer IS_ERR_OR_NULL over manual NULL
 check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-1-bd63b656022d@avm.de>
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
Cc: Julia Lawall <Julia.Lawall@inria.fr>, 
 Nicolas Palix <nicolas.palix@imag.fr>
X-Developer-Signature: v=1; a=openpgp-sha256; l=3942; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=pg0bcAlKCqGzZYxxvjTHT3BjuiImw/JCztrCxw0OaYk=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAXSiE/1KQSdimAccvhjPksfwMRe29ZGV0WmQ
 dc68UTm4wOJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAF0gAKCRA0LQZT0ays
 23P4B/sHBnCDcdVo4QHtyw/PgaWkSZpnGi/FADclDF/JNscwRsXCrFWzhKgn3xZ7GBKm9yEUANd
 kHYMMKsDVZ5Sq7xOrshFMfBSWpA+0BsCM8pKaxoj2QHBKIDA4UgN93hm4YvutplfF9/q6gdQOqR
 x0WpQkBc7InCLdKCwpXNhcL/HWVvBtzqT2nSOrbK1Rd5xcaVOko56aV82Fnst/bFUZLKttOBTCU
 bLU0LprdbSKp+PN7eyMO37tBs3H4QuuQgnRmZxd8L6mNXEFIpj0UqSFvKNrDWZBtTjurbiwItHZ
 +OYdOt4ryN9C08iNZEaNQULUxcRTzE4KumgPWWtIEShH9ICc
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143723-D8CB5E1F-6C1339D5/0/0
X-purgate-type: clean
X-purgate-size: 3944
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspam-User: 
X-Stat-Signature: 3pgkwzyybxmg5wk77f9c13aifxrf68go
X-Rspamd-Queue-Id: 9234A40004
X-Rspamd-Server: rspam03
X-HE-Tag: 1773143726-553263
X-HE-Meta: U2FsdGVkX18UcFBdcfWBvTEd2159ul1vz7r7OIqgzTk2SSmZGiwi6w3Dbeg36VZjVMDoDfz6gAdN8OOhaSVbaPXXhDk+gBTWA+RrAfrhWXhBh5x3DYF+98ewu53M5wEybWiKnL/FdzEP1271v5NYHMf3InP/LqbEvd89X7qH/NCdarIA9jzHKRW9hPh0NHtXQKj07+x+xkvpU92nWTWP8WejTfhL66KihoErJzwaOYxC/tTfZMQ3ki0LL6zjnxEGqMT/Rt1LNWTEzRWcgG49uPKMdgBlKgxxuDbQ2i7ypd75DhzFfs8NSG22gV2ns8XvSZY/BHKtzi076lltAHMB6CRgDXRGQ7e9nVpQRNG4TxLu5ePPG7Tvnc4lwZYy9echWWQ5aXWKaQslPPeAiqVsacvCb0PvRRaBFy2r4AVUR/kyoUGYDxIvtKpiLet1foKwKa4XYEgmL994pcS5p7L5mKmeN+cV1qmMKq8g7PH0gdr9A8PgHNzeuUsff2NMv7R71RzMW/6t4d/ThhEwtJIYvrYW+F+6rOFRxbIK/BSFAea4zktDAAED+Mfy2snXU3wbBs/f0UZG0V9apB35NebWwmUh/bSjX/6UATJLNLl3T1YB3Hy2FjEQ4s/gDvHUHEjJo3+hT6H53RMUZsnapnRiVUhgKJJPIGwZABoixGe4V65TqhIC14/UnahfIuOaxwGejdyt+vRHi1ekLOqBhv/5MJO2pDBorG8Pr+tOkYIFlbDK3dm3K4IwrCtjcJovuH5YjyJDP5iZQ7bp28tcxMBa/7t9cnfGoZaaLLYiwgC0bbRknDZf42Hc3/InKVZu47+RPv46uzMMaYtpkf1CkaoJCteMUp8qFx6k7BMa6YCIOJ7FLQHeP/y4zsjs0hVzcKc/jQ2jDNENh/LGWpUL31EX7o62NA/wMWuHAB+YqlBDHfcZFYk83vxOReuAmIs/A9zsxRp7ri4KJrjpkvmNyqL
 DT30ByYo
 EtgUess3ppM4XGzjP+55Twzmk7RFR++ZRTHG2TniRfpqjBUYSgn86GiSUsAIZlGa/f5R3Cdta1j7KSPoLtGj+bPxVcI34Y6v35oEsvuhHQO5LzTcKrwKIa1MHWTb6PBV6cHSAojZrlXJP+LMddzZ3qxsiSGG2iJlMSYP/nud/SuiyCkHrzBV4pAAdl/aRqiT5mj4l6YJsbx7J2rSmcr4XiB5EIU4OiJSckzPwwET/HrxBY9/dNgCKCPS/eoLgZPOOoTNRgOVw3W30gmOapKRe3pbiuoQc3Q6j9WI2gIY6K3ps1DBS3mtdPl82ROAV489qJWKBAvv2B0NqC8smiEY8adpQAauUzPKjUY/HHwTo+bcPo5VFi/70mR+XOTy2BLCgWJ24Viq6gfXEUWDaaETlBc0xKGLXEOdfd3p+ysmfdPxsrHLvsvKvDLRrJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Find and convert uses of IS_ERR() plus NULL check to IS_ERR_OR_NULL().

There are several cases where `!ptr && WARN_ON[_ONCE](IS_ERR(ptr))` is
used:
- arch/x86/kernel/callthunks.c:215 WARN_ON_ONCE
- drivers/clk/clk.c:4561 WARN_ON_ONCE
- drivers/interconnect/core.c:793 WARN_ON
- drivers/reset/core.c:718 WARN_ON
The change is not 100% semantical equivalent as the warning will now
also happen when the pointer is NULL.

To: Julia Lawall <Julia.Lawall@inria.fr>
To: Nicolas Palix <nicolas.palix@imag.fr>
Cc: cocci@inria.fr
Cc: linux-kernel@vger.kernel.org

---
drivers/clocksource/mips-gic-timer.c:283 looks suspicious: ret != clk,
but Daniel Lezcano verified it as cottect.

There are some cases where the checks are part of a larger expression:
- mm/kmemleak.c:1095
- mm/kmemleak.c:1155
- mm/kmemleak.c:1173
- mm/kmemleak.c:1290
- mm/kmemleak.c:1328
- mm/kmemleak.c:1241
- mm/kmemleak.c:1310
- mm/kmemleak.c:1258
- net/netlink/af_netlink.c:2670
Thanks to Julia Lawall for the help to also handle them.

Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 scripts/coccinelle/api/is_err_or_null.cocci | 125 ++++++++++++++++++++++++++++
 1 file changed, 125 insertions(+)

diff --git a/scripts/coccinelle/api/is_err_or_null.cocci b/scripts/coccinelle/api/is_err_or_null.cocci
new file mode 100644
index 0000000000000000000000000000000000000000..7a430eadccd9f9f28b1711d67dd87a817a45bd52
--- /dev/null
+++ b/scripts/coccinelle/api/is_err_or_null.cocci
@@ -0,0 +1,125 @@
+// SPDX-License-Identifier: GPL-2.0-only
+///
+/// Use IF_ERR_OR_NULL() instead of IS_ERR() plus a check for (not) NULL
+///
+// Copyright: (C) 2026 Philipp Hahn, FRITZ! Technology GmbH.
+// Confidence: High
+// Options: --no-includes --include-headers
+// Keywords: IS_ERR, IS_ERR_OR_NULL
+
+virtual patch
+virtual report
+virtual org
+
+@p1 depends on patch@
+expression E;
+@@
+(
+-	E != NULL && !IS_ERR(E)
++	!IS_ERR_OR_NULL(E)
+|
+-	E == NULL || IS_ERR(E)
++	IS_ERR_OR_NULL(E)
+|
+-	!IS_ERR(E) && E != NULL
++	!IS_ERR_OR_NULL(E)
+|
+-	IS_ERR(E) || E == NULL
++	IS_ERR_OR_NULL(E)
+)
+
+@p2 depends on patch@
+expression E;
+@@
+(
+-	E == NULL || WARN_ON(IS_ERR(E))
++	WARN_ON(IS_ERR_OR_NULL(E))
+|
+-	E == NULL || WARN_ON_ONCE(IS_ERR(E))
++	WARN_ON_ONCE(IS_ERR_OR_NULL(E))
+)
+
+@p3 depends on patch@
+expression E,e1;
+@@
+(
+-	e1 && E != NULL && !IS_ERR(E)
++	e1 && !IS_ERR_OR_NULL(E)
+|
+-	e1 || E == NULL || IS_ERR(E)
++	e1 || IS_ERR_OR_NULL(E)
+|
+-	e1 && !IS_ERR(E) && E != NULL
++	e1 && !IS_ERR_OR_NULL(E)
+|
+-	e1 || IS_ERR(E) || E == NULL
++	e1 || IS_ERR_OR_NULL(E)
+)
+
+@r1 depends on report || org@
+expression E;
+position p;
+@@
+(
+ 	E != NULL && ... && !IS_ERR@p(E)
+|
+ 	E == NULL || ... || IS_ERR@p(E)
+|
+ 	!IS_ERR@p(E) && ... && E != NULL
+|
+ 	IS_ERR@p(E) || ... || E == NULL
+)
+
+@script:python depends on report@
+p << r1.p;
+@@
+coccilib.report.print_report(p[0], "opportunity for IS_ERR_OR_NULL()")
+
+@script:python depends on org@
+p << r1.p;
+@@
+coccilib.org.print_todo(p[0], "opportunity for IS_ERR_OR_NULL()")
+
+@p4 depends on patch@
+identifier I;
+expression E;
+@@
+(
+-	(I = E) != NULL && !IS_ERR(I)
++	!IS_ERR_OR_NULL((I = E))
+|
+-	(I = E) == NULL || IS_ERR(I)
++	IS_ERR_OR_NULL((I = E))
+)
+
+@r2 depends on report || org@
+identifier I;
+expression E;
+position p;
+@@
+(
+*	(I = E) != NULL && ... && !IS_ERR@p(I)
+|
+*	(I = E) == NULL || ... || IS_ERR@p(I)
+)
+
+@script:python depends on report@
+p << r2.p;
+@@
+coccilib.report.print_report(p[0], "opportunity for IS_ERR_OR_NULL()")
+
+@script:python depends on org@
+p << r2.p;
+@@
+coccilib.org.print_todo(p[0], "opportunity for IS_ERR_OR_NULL()")
+
+@p5 depends on patch disable unlikely @
+expression E;
+@@
+-\( likely \| unlikely \)(
+(
+ IS_ERR_OR_NULL(E)
+|
+ !IS_ERR_OR_NULL(E)
+)
+-)

-- 
2.43.0


