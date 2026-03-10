Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC277EB1055
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:55:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DC026B009D; Tue, 10 Mar 2026 07:55:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13B8E6B009F; Tue, 10 Mar 2026 07:55:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 026726B00A0; Tue, 10 Mar 2026 07:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D88496B009D
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A218E55CBC
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:30 +0000 (UTC)
X-FDA: 84529998420.08.27AB463
Received: from mail.avm.de (mail.avm.de [212.42.244.120])
	by imf21.hostedemail.com (Postfix) with ESMTP id 75FFE1C0006
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=TfMCcK8c;
	spf=pass (imf21.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x3fJnbtkYl6K0I0NQZZfdxYUdlec3ZKNUOa5GtYQQpw=;
	b=DcycDQLy9LZplWvNUxwq+r7AEDAaNtWgLovXcChH8vRHZC5c/8YGz7lQYqorbNB7qMiQeF
	8TjZL4YinArIXq0GFD/4YC3tAUMcX7FS3ZzTfXVHiqXLeVgEbD45WTzBe7nHX0EonRZWD1
	YTrdpDJxCmdvZq+IrErwzI0JVqQKCdM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=TfMCcK8c;
	spf=pass (imf21.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143728; a=rsa-sha256;
	cv=none;
	b=N46LDUN3HVgnzXxRuE5ZK7uMT/7hGSiP+3UmTNpdzOfWore9NuxoaUYHwn7k6tQXyXrLxm
	3f9PHhgFHSP6ItdJr0QnIE9xz6chHfEUZo7ZyFrd/OBpj46pJLmMv8ev3DLCDJsE3meWHJ
	BCafSatuIaBdnvkK4SLijlNAAmum4A4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143724; bh=I6Je7s2Ep1qm9Op1Es8XHv3XLRiGLKRoF2kXcmkzRQ8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=TfMCcK8cpiyaOKFFZdA9Md6WNn5KRFS8tSOkSqLD2Jxk5OZPSDDv9UFoUEeAaWCfO
	 ihOoPJUrphZnBRuSVIXmC+zIb35xahiq+vRkcauUTds8dKZ24Y/dr6SYjxVJU0FDdx
	 AKL6kc8+lTp5jQ7C+ooCXPOvtrcw/oxBU6qxFp7Q=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ab-b734-7f0000032729-7f000001c010-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:23 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:23 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:45 +0100
Subject: [PATCH 19/61] kvm: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-19-bd63b656022d@avm.de>
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
Cc: Paolo Bonzini <pbonzini@redhat.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=938; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=I6Je7s2Ep1qm9Op1Es8XHv3XLRiGLKRoF2kXcmkzRQ8=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAYW4R9Fa4g/yA6j9ZuKFu5I9Vr4Ret7hyOjN
 JwNhe7zVlGJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGFgAKCRA0LQZT0ays
 20QXB/4yM/Evr0C2rYQNWNfwS8E/cG5fl6s9dPrv/gvVYGXSEh8UExGqU9cLwxKHIKVMA5Lse9f
 LrwiXfgnVbG/jY2aDVr8SKAe8jTMddJh/8QeSjkaMwizAfr4QJuiagDa0h2xOKqhGpCOZN//1dy
 f1A425zzalFgQcP/cTon5ZDxtSFbyqutr29XmKKCwwHv2Q8Ku8umjOLZX7dw/4OhOp8cL1xvis1
 1HNcIwV+v3AkQdaY3X17qkaSSKgp3UINnn82IlkzUYd1D589D9+xD3Ra8N0AS0tymC/zbV06vOe
 lGeSrKAmlJiZ7dD4DXHr90X7Cpb/daCyNPsSKKM+Lq3HwsE1
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143723-DFDD6A3D-9438E50C/0/0
X-purgate-type: clean
X-purgate-size: 940
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Queue-Id: 75FFE1C0006
X-Rspamd-Server: rspam07
X-Stat-Signature: zt8549wqu31snd6ne5dc61j11wzty547
X-Rspam-User: 
X-HE-Tag: 1773143728-25118
X-HE-Meta: U2FsdGVkX19lebTmB8Me3NG8XSnrIIft0/c+pA8NkJeJGIrjyEadzSJHIs15ZZ8lxHiB8yI4RoAsgfUTz84bDOy/JfXh1FtrAynhB5AOdgFA96p0+kJ83g6nlhEu9oLiRuEem9jvCG7rRY5s+1CGsWf5mq/21NcCPeOu/Rwz6D362WzYfjBgdwRc7KbJuH52povrZtB+oHzs0jxCaJ7ZkNMyvwMkLMXukT3uonaIElSY2W6gxriuzoWOXsUwSq8SO5yIC5lneR/M8GFOUxV/q5ZQLHSAnY1Zug5IIcf4QOM2mPAasQxFR33HCcbanHfewiCKlPLyA3MVfquNSIHyQ1beFgh3p6QH7XRG9tR9T+oNqaPpTBv415GvyHPbGYt2VwxsLjV5jNOEKZx9YDf8tD7K6+a+YFk9LQ712XZQb3KNMBuM4VD6PwH5bq6oMNcvO0v1nEKJyjSQqLq3aMSMPS5PMFqzS2k5T9jB6kFQhfjKd8VuTQASp6LREx76V8dUmhMK9xQ0Yb8sOkaKM/BcXS4rdGNkAamR9/z+s0cys/hEQdlqS2HxbuHKz1673ACW20HIRLozNOtLkzOLla2hXLMwsnQzG+ilnZKE6qJlI5FBFJZP7yr51bNcOOMVaRsi37rY5qlGgyT6EL+ju4y+kI89D8UuCT6Q82mt1gFjGKSVSbC+cPwQi+6JIcAju9fErFIL7MZW2NtSQ1T3Lzk138atn8Yt2StaSXSjsigP04lD8kpLMxioFAKGVV/mWSHuYK/f3ve8Mw2aSA9Xq4KG7dgjgSf2NPnc1Ayho+yt5H8HVhkC+1MkGEXBnfZl5HrCt13z6yTs/oVr8m2JUPuUdxL2D8662TjfGlT0dGd81QpDg1HsdM0G1pqa+cehOR2i+PvqNlfGzNJN3DgNJ5RupAjTgPVMELzwavU3SoQR5TeOwXDQyqH5FPl58TyzEK2f2eB1xaIJWNhQ8zqogCv
 uFr/XimT
 ZbZG10oKB/jgS/DAz912EnW27/hdwcbaCCSZb9pTAapfTnh66/3PNauaziKcSuMrlUenIwNk1SVTUjYuxirEyuDuRV1yaJQH2gyA3lRm5rHNC1N4u3EQmujSFJjMpLyVXtbkK2UVywJ4BgKjjOcSvyRWhDHekssc2RLt/vgBMJNCs+aUjhnoftHQAYPMMguplp1yjLR5YKEDHSDw+yiLXyFyBKJxbsEIvXZ5L6xpyIprU2EIiUSzgBwnKJHVSAiyrq1CjtbOVSMC+5eXYdny1vYzmssc47sDKbgMwIi/VBploVMVxj7Ytr2MNiWDkFPMn6aRYmaYQF+XobVA5YJjwNiPs5bU+rB/BGYBGw/PRB/AUa5mHU8MRIV77kgeqq1sSYjG/Xz7qv3A8512q9frkQt0CqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 virt/kvm/eventfd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 0e8b8a2c5b791243e230a91124d32fcc0250a0c6..4099dd11626009a3497ad09994ba6bc1b8211536 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -508,10 +508,10 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	if (irqfd->resampler)
 		irqfd_resampler_shutdown(irqfd);
 
-	if (resamplefd && !IS_ERR(resamplefd))
+	if (!IS_ERR_OR_NULL(resamplefd))
 		eventfd_ctx_put(resamplefd);
 
-	if (eventfd && !IS_ERR(eventfd))
+	if (!IS_ERR_OR_NULL(eventfd))
 		eventfd_ctx_put(eventfd);
 
 out:

-- 
2.43.0


