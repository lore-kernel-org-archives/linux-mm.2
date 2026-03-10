Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 511C2EB1057
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:57:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C3726B00D0; Tue, 10 Mar 2026 07:55:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19E216B00C5; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEF296B00BE; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 988A26B00B9
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 68CC954FE8
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:35 +0000 (UTC)
X-FDA: 84529998630.07.F0758A3
Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4E05BC0006
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b="Pw5J/ZKa";
	spf=pass (imf22.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v9QVCffpCG3XK0BPU9sg9EjWtze/5MDgO50jcyU8Kb4=;
	b=Bl2AATfBoc6twnRFx5oFXZgeh+NF0AQzh0P8Qq+g0gdXqGk2LAjqtkR3I3s4u+R+6bjQkF
	GQf9rjECRO4xCto1C2AEtKn/UIWiet99VNPkus7hMIvpyC0UQRkyhePB67Q20OZLQTKWAT
	Jc5qcRZ27Pr5FyN4iw/orx8/sBr1V+8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b="Pw5J/ZKa";
	spf=pass (imf22.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143733; a=rsa-sha256;
	cv=none;
	b=nP49XiFCC2Zcf5PDjxIKdIBq23V72y+VJuw+4GNlBPwbuS2CH/FU7BzeBNPN2NyhwhaOxC
	4Xdz9PxAXNRx8K2+zuH0zi6JjaT2nmz2HxbcX+zDZ5llY91L/5dZ+CLzpRgRoH7EfAqsrA
	s9hfbvG7G2ZB4z55BOX/j/6EceNcotQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143728; bh=P8RHvB1pDU6Ba6KZR0cIN2NAbDWAknWQIRz8JMX8gns=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Pw5J/ZKa7qdOD/KHliFHGAPgoeYPtxmoMsaCQF/FKai+LG5vkmyJowXsEzkD3cPot
	 34kvrGSUxg1JnjFKHY6NsLgrOVug3M9Be4rVveawRMrk6MR1C1BR6jP8hIlA4X3hU4
	 jr1s0kl9i2R1ifgZ0ZoS8j1AZYiWtKMhO7fCyfSs=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006af-e21d-7f0000032729-7f000001bab8-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:28 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:27 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:14 +0100
Subject: [PATCH 48/61] mtd: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-48-bd63b656022d@avm.de>
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
Cc: Miquel Raynal <miquel.raynal@bootlin.com>, 
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1817; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=P8RHvB1pDU6Ba6KZR0cIN2NAbDWAknWQIRz8JMX8gns=;
 b=kA0DAAoBNC0GU9GsrNsByyZiAGmwBnnIluZqwXeZ26oYYynjfBoy02QQTmlYcSsBV5M99kkBR
 okBMwQAAQoAHRYhBDls8G2tYNRwNAKmmDQtBlPRrKzbBQJpsAZ5AAoJEDQtBlPRrKzbhhQIALOH
 7GGUb7lDbOgP/8xq1PNX4SyEuog4C5Kqug0EL27yDZ5DTcHtYtEWvTOVFh3DoBIg9oWZIhltbqf
 zQqvypi0p020OQBz5OD/FKYzR1JLtT/NpVkDjTnrh0FIsLPISsJn9k8DorrTpQE5Fk5zPEGhmlk
 HlvpEuSvvQD0MQibzxJjUYSjgq+Ll386Twc/QQfm3hFYZT/c4I4Yb80f4z0CM2WhT7S3udW5nGM
 BjGFdYImnQ9uAgWz45BEBVAwZb3P7349MoFLUJ9ZHvqc+4UOIWn+5d35lrOEZcvkJpfol2G0RFZ
 WFsYepS2AbdMtsza99K9TLlncKCIQLIaXnPIWJM=
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143728-90660F2F-3D7E05AD/0/0
X-purgate-type: clean
X-purgate-size: 1819
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Queue-Id: 4E05BC0006
X-Stat-Signature: bayxmfdueg5nrkthxxngc65gwq7fwx4a
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773143733-481762
X-HE-Meta: U2FsdGVkX19ZJ5J46dTvVBF4wDPtxzyNuXqwrTqaNpIfAZ9WDvn8c2VuOujAVQtY+2qzqJzEI13sZVormCkdXGGplB5Wh6hRpb3qm6W66kxdt3885HyR/Im4Y/p7zvAYctXkunrobNYzF9dDKWddcng2VS2em+8yPnX9EOHYkTkLVjCCJcXWuwCMToiPhaVu+1BuPvakZ2nPhmFEx9dSzSwfUnUzpVHZ9ed2wE9Kh81ENxySLFOPNTZpBOOAO9cuZM1s+ydvwcDycgCknBJqMUIEOvzHutVEh686VMwpihZumq9eteOQm3QV7KFGwxrugrx3ZIwW1yst9IP3nIWoYMa/uNavfO0dRdJ5UJU0w47/sB81MbQdnswsVv3LQjOw6b7CrWTkEHRuw858HbrmNkTeLdsAU0zCl6WJATRKk4hd9svRbhAUBAh80NIV53OymRF5oYJVW8VG2DPCUfhlk9aadz905kTlvF64r2mEqTGS1MgLlY37AHqxsZX68dCObIJA2Do19srXDKbn5zB/eOCtq3JHfGalWaF8kflgx+IEXLCDH0F4+DTnGjrP4xy471GU6jVnnIpkMNiv3vKWSgGZw/Dg9r8t0rtpCcHypp98TPN2xOxWx2x/FLfooKn84P0ckQFmbEKD+0S4lojWS/x4xef6eJW49L6WgU69hUymG+bsMN9dpPtu4whQIqkxB4gTnVJO2iKQ/wDee86t0uE9fc/6L2g0OpXQBHOND3xfg8Hb50luMHpd8fouzR+ui9U1ItV0vRTYe/IvdgRQXnhLzjWbcu6GpJzMMb5rxtfUXxTpRcOQ05p9yMFl33QJT2AyeiH/iyssQS+Vx/FvWCKpEKIR78g/fzWaG1yOym12ZRaBzyaIwoiOLxx5+cJfN546ZG/KkeweMA0/tpNmdkg/Q6Ndbfxsg667NYtU8ufHrDJRHNTHUg7ykh8b+FtFGumHCRoROj+kdGwsW0E
 3+taCan5
 Y23fLzrnmHTHUa59wWvHURLl7DgXFzHuEMrVSL6SO9V1rWbHOvY1NUAq3A1INUH7ibFExh/ZCtZi3m6tweBKiCK1tj1XSWDZuF5gsKhxZgNvZknF1KUny+K/XuE2mmeX4RfDsgodTJwEHADUXF5BnTy0u2nDITcXBn1qwvCwwWFJHH6X8MU3TGmUVQMIjvho8JbO2Q5yuZWB8r9TbRIcYUTfS7usDT/TqkDFGm2gy6CImY/h4tCZbQcMcZsZLmm2RWgewKL6c5KQf0xa47viNoLJe+EfTvhbnBbG4ETkGloya3eqIhGnViLr4f8PS19cOb0UEvTxiN7GroPcul8y0ZvYzTZ/rn0T0pPKeda+L9A4kJsex0N37NC/kHEB7WaL4pQMkzADKhRdasBcZ6f48JMqYJMRcTZLK7trFZTqBneKR02UZwE/yVAdolV5Vw4dRYOa6NCHTiXV1olkccMcSKmHTLSHDApFQxxmRIexu47mQ/cwHPXbh0X9rcCHN/CoBs9sMVcWUu9/1xKycfQsa/mrgNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Miquel Raynal <miquel.raynal@bootlin.com>
To: Richard Weinberger <richard@nod.at>
To: Vignesh Raghavendra <vigneshr@ti.com>
Cc: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 drivers/mtd/nand/raw/gpio.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/nand/raw/gpio.c b/drivers/mtd/nand/raw/gpio.c
index 69e5e43532a448aa6273f3df79f53145784ccc05..86a8b62fb9e8510d36f925b8b468ec17c77e26d8 100644
--- a/drivers/mtd/nand/raw/gpio.c
+++ b/drivers/mtd/nand/raw/gpio.c
@@ -276,9 +276,9 @@ static void gpio_nand_remove(struct platform_device *pdev)
 	nand_cleanup(chip);
 
 	/* Enable write protection and disable the chip */
-	if (gpiomtd->nwp && !IS_ERR(gpiomtd->nwp))
+	if (!IS_ERR_OR_NULL(gpiomtd->nwp))
 		gpiod_set_value(gpiomtd->nwp, 0);
-	if (gpiomtd->nce && !IS_ERR(gpiomtd->nce))
+	if (!IS_ERR_OR_NULL(gpiomtd->nce))
 		gpiod_set_value(gpiomtd->nce, 0);
 }
 
@@ -358,7 +358,7 @@ static int gpio_nand_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, gpiomtd);
 
 	/* Disable write protection, if wired up */
-	if (gpiomtd->nwp && !IS_ERR(gpiomtd->nwp))
+	if (!IS_ERR_OR_NULL(gpiomtd->nwp))
 		gpiod_direction_output(gpiomtd->nwp, 1);
 
 	/*
@@ -381,10 +381,10 @@ static int gpio_nand_probe(struct platform_device *pdev)
 		return 0;
 
 err_wp:
-	if (gpiomtd->nwp && !IS_ERR(gpiomtd->nwp))
+	if (!IS_ERR_OR_NULL(gpiomtd->nwp))
 		gpiod_set_value(gpiomtd->nwp, 0);
 out_ce:
-	if (gpiomtd->nce && !IS_ERR(gpiomtd->nce))
+	if (!IS_ERR_OR_NULL(gpiomtd->nce))
 		gpiod_set_value(gpiomtd->nce, 0);
 
 	return ret;

-- 
2.43.0


