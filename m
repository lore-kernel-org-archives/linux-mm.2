Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC97DEB1059
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:57:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 578416B00C8; Tue, 10 Mar 2026 07:55:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ADCF6B00C2; Tue, 10 Mar 2026 07:55:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D566C6B00CB; Tue, 10 Mar 2026 07:55:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 046DC6B00CC
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C9120C016A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:35 +0000 (UTC)
X-FDA: 84529998630.27.967EB48
Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	by imf30.hostedemail.com (Postfix) with ESMTP id 899E580018
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=ykq5xCtC;
	dmarc=pass (policy=quarantine) header.from=avm.de;
	spf=pass (imf30.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uE139u5zoua9TnetiXGtcYlFuz9R+VpXRn5VBlrCpnQ=;
	b=t2XBIsxLggFBonQ3Sw2guUb3uf/cCZqqH+swYyTfbPoOPmQ/92elJxyxCAGC2U1rDpFywN
	oM3QoZYI2M9hCfTx30+lWBI2jF/D720AeOF7OaDYE72iyODxdDNWtdoM/uzssSGihkcahK
	6nk0JSQYtUO9x9Y22BKST87xy8XSYtc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=ykq5xCtC;
	dmarc=pass (policy=quarantine) header.from=avm.de;
	spf=pass (imf30.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143733; a=rsa-sha256;
	cv=none;
	b=7evtRkhXEWazZC7JuUwzT0PuJZp1aEFjvD8dvKoO+jxDh23Ez5U+PgN/tZr4KYwYAyQqpn
	gQtLPjJjrbNuCJuwyewTMomdtMnyOUsrvoNmVC8Cs1Br1clt0vTJmEGZdcuolhRkT13iuF
	WN0eSVx40GEDLxgCKcqK5x8Q8U0NkuY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143728; bh=u291MpoQyOoQ8laFPzXzGEOIKYw0K1QgWZAkzpMyO94=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ykq5xCtCLnpuisjh7yCkntpXVoj7+lenTonMwnNyj3HEswqyJb7tAewrRcpMAVrss
	 htdRzuKIhEkY2u9z8HmZVLAVG9LXQEK5KzfFb+glv/mPDwZDOJWP8p2pGfwANfwg8Y
	 cyh+Ai5Y49rs9bC9KZyLfdR4nR4N9Gt4Gg3G9z8A=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006af-e21d-7f0000032729-7f000001ba8e-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:27 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:27 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:11 +0100
Subject: [PATCH 45/61] thermal: Prefer IS_ERR_OR_NULL over manual NULL
 check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-45-bd63b656022d@avm.de>
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
Cc: Eduardo Valentin <edubezval@gmail.com>, Keerthy <j-keerthy@ti.com>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>, 
 Lukasz Luba <lukasz.luba@arm.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1238; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=u291MpoQyOoQ8laFPzXzGEOIKYw0K1QgWZAkzpMyO94=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAZv85jT8mK77P0DgzyoB3jbjqxnd52qin/43
 73TECCS4NSJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGbwAKCRA0LQZT0ays
 2zstCACwpYJlOocsZ3HBVMWCF0IhNq09wby5LkvAsENXavKVYKWH0lNK553mHyG2L0hqOjwgfmQ
 2R6ChfeUAdB1pLjTViMeeaIXq4AlyCRjEyAsVR/bQ5/US1JrFGhJzXarTPhODhjHiBoPAuzZhOB
 8fipmcjA1HLbJFaREcynXwQWmFtG9ouLXgkvipVtzsg9HQdQPWOUefHLkAAvMOKdk+hmDB4ECbB
 NiykkLaAUziz7cfWSAQQRPcA1Gr6EaK8Vw6tF4Kl2S0zRlJlORdN+u8vB04XH9TW/DB1ISJvpll
 cqhryBZ8g4FfGeREfmgUyiQqqlzXdeOdKWH1FU8uNB4YFH+q
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143727-7DE07F2F-8C4B41F9/0/0
X-purgate-type: clean
X-purgate-size: 1240
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 899E580018
X-Stat-Signature: jj7z7a1dy6rbz4kcqdr35a8nwugriej9
X-Rspam-User: 
X-HE-Tag: 1773143733-8934
X-HE-Meta: U2FsdGVkX182T9a4YMiT4YFqvnAJsmp95SdiXqJVd0gONAvjnLyVQJcPBAOj560dNNVuZrdmMdRnGOkEaPknBsfrJ6Ub4GPwFmeCcRBLO2vLUXbrK7YVV1XvGXLfQAvsXjQHlcayouYP8UuavHWBS/UY8qpPj+p7CER30Ij3c49EWpIWCb8Kjb1ihTu9iOYwyfqZK2f715CiBJEqE+LvHT7uJvZz0dBZEYtVGKlDRBASH0AHZrxc7NCGO/FTZK/H8R4o7dVXkwlSXBj4FpKZT7Y5/GBMKSWUHrtOAHzdzipE/IDPMzQBj6DpQXI5F8kwtYU/7xWCfp4PtoxDza6M1a1ZIOn6wb3p9sg9O20BocgJU5LYEHLSXoInoiQ8L1XXOUvAim6IWiaTPa6j69MFXGsEgzWqAaOFNgvXGDc1/iiexCIiCRGQsHFWT//ymkIXpEbb2T3pTQ8he7nJXp4G1gzuGckhoeFITO/SDZxp0LAdK6/nO2u7+AX2ygoDBUt0+izvQqRlCBhndgiU4zbpQPoYm/346equrheatRJINpp1DzMOyCuVdqgTusUSSuE24uwDzVcznADSYY/GvSo++uA77eu9zzgLto4KIW4DD3hTl28FZBXZFnAbPcdAoGe8QjoWL3pV7P0Hq2Y+Cn4nWttFnZ9cKbggdM44xx0GCasJQTnrQ4CzuP2hVU5sy9Q1wDHqx/4V5xUk4zn9tAqbp9QgNkb7rxQ4qQMfR6EPd0G+WovOUn+0ZKizlYWIexs+wFw8KTmDRYf1lbncEyhW6pMMHvaYBSEEiM8Jw8SMK1KPQF1W74NzlULGG6LpxrI2+sVKFv6qXi9qGn5byMiiHoVekj7aSKKmWAxw+0MYQ5WmFLF6y7gRp42EHjm4KhJd0b6Lo01pMe6Kvsg4DabV1AdmYZ/4xeLLnJUZ3vbvmgWAJoNEwScBsPQbdPc5hkHDQIGwMJzHRCQR6+6cMVO
 uDz0pesZ
 3h8QI8FbhjcIhiyW/HXI2KC95+33b1NPHmR4GSyF4OWsP8G6iitWwABbJTWGlPIZyOqTE6EPwYuUURenHMZS2tKEGk5olOuAWW2Gu7CeqHunZpE1jroAtoDrXdpy1xMzg0j5oHffXdsiw1gAqOV+C5CZj7mj1YkGtZzxvqddMwf36q/+JHi63QBCWOxMera20E1Hv4zhauedfsu+8Po++UqpQ0ZCakUXdY26G8puJSSklscHZs1ARrfvEdAbYxSQpQAU4nm4Yh8HPhciDgfWjv9jlvyMn4LJCgDvTb0yhAcrbOYkHcB2qhw9YEnQEHwUP2D5m0xfDHSqOpQh67uhYG3yPbgeX6ca3QOk6gj5pDVPEz6WYB4yiCE8QE+pS1mhrw6sCHkPmm3d/GPJJspqO9X4FILiHPswCuMSIbgxa4zqdhl7sTnTgfzbkwuWXokx0AtxOoPywTO2/ziR+2Z0C36gnT+Zs9P0kSlXrmHsFC5PHAvPoaNtyEXj5Hd5EB0gflmz470gJ5EfdBtc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Eduardo Valentin <edubezval@gmail.com>
To: Keerthy <j-keerthy@ti.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>
To: Daniel Lezcano <daniel.lezcano@kernel.org>
To: Zhang Rui <rui.zhang@intel.com>
To: Lukasz Luba <lukasz.luba@arm.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 drivers/thermal/ti-soc-thermal/ti-thermal-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
index 0cf0826b805a998abd0d4e2cfa6938de8a46c4f0..9218417e6d923ec370e032f5b91f9a839fd293f4 100644
--- a/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
+++ b/drivers/thermal/ti-soc-thermal/ti-thermal-common.c
@@ -228,7 +228,7 @@ int ti_thermal_register_cpu_cooling(struct ti_bandgap *bgp, int id)
 		return 0;
 
 	data = ti_bandgap_get_sensor_data(bgp, id);
-	if (!data || IS_ERR(data))
+	if (IS_ERR_OR_NULL(data))
 		data = ti_thermal_build_data(bgp, id);
 
 	if (!data)

-- 
2.43.0


