Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32CCEEB1054
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A1A96B00BC; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A1036B00B8; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6FBD6B00B8; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A0A56B00AA
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65A35B58F5
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:34 +0000 (UTC)
X-FDA: 84529998588.14.774690C
Received: from mail.avm.de (mail.avm.de [212.42.244.120])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2B92410000E
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=nh38mtwH;
	spf=pass (imf14.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FfSzQd7kv4UrwUhbLdoRlPs9cYP9/YWD1INFReBo/3M=;
	b=SuwDeOgT+aA/XjR+sBBoIOj5BidPcALGhmvxUrvPJJlMQ58lp/vqlmuc76thbQgNJvBwxK
	iCTGrsIVPGhxItOYFvUIfZozxJHs/3ecCq56iDd49/WJgRE9n3NFoWvsE8z8LkTAOcOxJy
	B1yH/M/FphsqQ/dBiBb+XaBCsunsOfA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=nh38mtwH;
	spf=pass (imf14.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143732; a=rsa-sha256;
	cv=none;
	b=QKmXQZvIiR4be3QLMixcTcgdHC6PCXJUsWnGacNXj5/iwwr4RNYtGBFSWESNA1OJVHCOZB
	vKT5Fk/hI2HHg68b+SzWEBbAaLzG04Z69gjz/lDBqJ1RnW9vJM7Kt9nKjS6dIFtPULOISZ
	RgqJ6/qqtdDK6aBib5AYSQEcCynqsDA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143726; bh=7kdqP+tYIFKXEbW/CcutoIH+BaTJGO9lG8xGd+KBKlA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=nh38mtwHyUV9SKw+BNpXSRFMzfO8/FcrsieQzDWw9oji2O+z7Psbni6v7KAffehjx
	 qmid8HatIGHMRnktoTMo9XRdUV6Ztkx3lRZel+NdFrmuz3TY6gos5gVQP+DoaQPsNi
	 ndWgzemtoyfAka1Tah5hiKpjxy0BL5dDr2HvKeZc=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ae-b734-7f0000032729-7f000001c0a2-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:26 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:26 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:09 +0100
Subject: [PATCH 43/61] s390: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-43-bd63b656022d@avm.de>
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
Cc: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1168; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=7kdqP+tYIFKXEbW/CcutoIH+BaTJGO9lG8xGd+KBKlA=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAZn1sZXeMLIPVJuPMvtIFyA6+Lb/ZSleHAPf
 T0qLrc6EciJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGZwAKCRA0LQZT0ays
 20K6B/45z034OMVnc7IW5eSlZRm22idjp9lRSYx7bSAgasz9Q69aq8L0v4zLmsPUTUANCklIZV3
 Ky9LpL/JQ27BKEBlPFUkZv7HOQgdozWfUf51X/x0BdMhEpEPDFIJUTovRoUphEHN8rw1r9KUQDQ
 dRKeWS5ua07ZtP69du+2qOW1Bjj55fWBu+uxvI7fohNlQeSwssQzt0rpy3r+7xRxxg0LdKDF+Eo
 Y+QuFzLHRhLpEtgPju+jKGgQPeWyFuaSnteU1ZzTdDhjn5fvjXBJ7IuXzcVk6epAYwi3YolC11O
 rwheclTeEca9nqJY9eYYhG9OXtZeHQ7d173Po939eVnoDlQn
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143726-E3DCEA3D-4F569189/0/0
X-purgate-type: clean
X-purgate-size: 1170
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Stat-Signature: mwisjzocpwiej4ap3h4qts7fsp3s79uh
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B92410000E
X-HE-Tag: 1773143731-26041
X-HE-Meta: U2FsdGVkX18rKWFeMIIfQtKi2ufIKyVW+YWR9jFRvDDgufwiQhADhmedbMaykuhoRq8lqj5RDxkOrEh9NKarKOL9tlhRcYmaetDs7m3YsWqJoCdbuQC9YPyxDExzMmJU897qG9DaBOEbyQ0jInIUCdGpkH2jRimWK1aJw5Qv5/cVO39ppPpuWz5Oumgj6YreFv/zhqIVb+5XNGLLlTE5wZV1q+8k0Eg3l16AKH/Y1dk1WZXWtBRwH7CBnfiulPXIxZ0pVNLCmTEJNRcc0fr4Tl7mP//eYA+jDzVajg13g1BfEqOsZ2EG/04Rfo8pMHqCgywvTMbErAX5Na2UfOeLlsRppjqlONbgvqNZHm2UGirPludKM/fq9SwmHHITo1JE7KUkg5/Wd8K7QOxurR6VY1nOfjbI230Gif0WjMiIhZYX7Lqj6ocDbcT5LyZnRbHNqE6On8auOtpzxfFVp/aerPpkDwDKubOZ6asR1wX6lR2ycG5EzgAVRiN+dTdX+z3V51M4QiSvxfStVenmZTMArWtcNqnoLjqacjlqIhpBREuKmc4g3I3ooZbJPEFvOf2Dxps32Iia8XFcZic410sq30m1Hb/SxG4bKYlRNVBq3gLSk/6UpNvfStHGJyP+jcGbjmTIsD2m2b+wD80ChnPz/vJQPuQIEazT3uZ5ApFKYQPGSUCPXgT4tr5Mv8XhyX77YQRZlK26PlJWYMx3oEoR8Z7Uu/AjigfKnVzc7LHBRWjhgYxjVX10coXT2deGqH+r0dMiXHUtRkPH9VQeri/8JyTwapDP+JWeBR8K+vPsM4RL19MbDkpf6t+m5S57cBVS6yF+KnAwHvhfM+LzCPaw7CD70Ta8VBcB/oRivvWBFbsDbqAYRvrP8eZ8Gr+eFozkY1WrPxtwhQqyE/3oyLxb7iH0Z5u5wE3BkA8nlsJNEdhjv2enMlPFX4Tc74CzLn19GS8hkl8UChqi5mfT54E
 Yge3kEap
 RjCn+PrAiEkRZ9d9hB736rYX+KmmrfGv54WZ63D2dWTIXoFiOl/10TgrO8s2tGcPrFdSxIUNRg3B2ukDYF3UGDsYG7ZlUw6hYRmqJGDzK5XRgKjiBoc3OE4sw38r5LadBL9B6F34FozUWEVoH0UC97b1vXAd5+JqYPFXcqR24ibEhyPWXhwv9MSc6wo8nBr1ooCCDD0Ro1Z5N9co5p8i94wJfvn8/D/TkvVoROBEB4UObqimDMzUS85K8rUKW1B/fB4IGAD28o4lUu8PYYb797MNYtk/oF3pDfoMiT+K/UMZzWhCYdEIZGjHS+YK1J+dDnfKqHeLUv/nxZMZlXQug0ExLZKpqAhKUwbBuqEt3GX95Wi7d9ewdGRI/ThYNh8RHSo+K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Heiko Carstens <hca@linux.ibm.com>
To: Vasily Gorbik <gor@linux.ibm.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>
To: Sven Schnelle <svens@linux.ibm.com>
Cc: linux-s390@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 drivers/s390/char/tape_class.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/char/tape_class.c b/drivers/s390/char/tape_class.c
index b69430220a813e764ec1514c27ad486ac9e95575..aad4fff1faea69ae055b517910ec6467b14cb6e8 100644
--- a/drivers/s390/char/tape_class.c
+++ b/drivers/s390/char/tape_class.c
@@ -100,7 +100,7 @@ EXPORT_SYMBOL(register_tape_dev);
 
 void unregister_tape_dev(struct device *device, struct tape_class_device *tcd)
 {
-	if (tcd != NULL && !IS_ERR(tcd)) {
+	if (!IS_ERR_OR_NULL(tcd)) {
 		sysfs_remove_link(&device->kobj, tcd->mode_name);
 		device_destroy(&tape_class, tcd->char_device->dev);
 		cdev_del(tcd->char_device);

-- 
2.43.0


