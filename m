Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC246C54F51
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 22:11:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 122116B00A1; Tue, 28 Jul 2026 18:10:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F9A26B00A2; Tue, 28 Jul 2026 18:10:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 035EA6B00A3; Tue, 28 Jul 2026 18:10:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B997F6B00A1
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 18:10:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3F6231C0D50
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:10:33 +0000 (UTC)
X-FDA: 85039580346.09.6C933F8
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by imf19.hostedemail.com (Postfix) with ESMTP id 886DA1A000E
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:10:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=l3dMOCQK;
	spf=pass (imf19.hostedemail.com: domain of 31ihpaggKCCcGPDWODFNJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--dmatlack.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=31ihpaggKCCcGPDWODFNJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785276631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kK9fmvYx94bqGyeMgzsYcbMKuj2faWTY3fQuvgNhZiw=;
	b=Xm88usUO485rCf+pQ29ekdcZDSy0FXsX8BrjEKRL4MKP9f3vjXlLMFsP2FjdcWKYgsJ50v
	CR3UXblD1+UXDmfPglGoRTzVLHiDXdmlCAA1r73KJLpQatC2drBdp5AEHNHH/UqwR+tajV
	d8FUkFLeB8uQrMGVpxNMhq2sUsPkAVc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=l3dMOCQK;
	spf=pass (imf19.hostedemail.com: domain of 31ihpaggKCCcGPDWODFNJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--dmatlack.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=31ihpaggKCCcGPDWODFNJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785276631;
	b=4r3orqZAQTHyDcQW/awAli1l4EpO1+4WPsGXyFKzQRsiR3RI8UXtw4OyXVbMZeNG4h03oD
	YWRwx6ZujQKABs4I2xWsOwaL5qb72G0dY63/+mX6U/VlmgI+6fyy1EAdv1vTIoUx7qYNsO
	K7YxcVcGWDZ8h+nfvj8drM5QVcpEInc=
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8484b9fb055so724932b3a.0
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785276630; x=1785881430; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kK9fmvYx94bqGyeMgzsYcbMKuj2faWTY3fQuvgNhZiw=;
        b=l3dMOCQKCz8wTCdcVrooZbBOevSZPDQfvDi7U4OeRfm50MpNvonz25LvAjfhW4ayCH
         TOAv8AFpJ5t+Ng6Mbulc3hAAJ4FZznYov+QrHzf9cPQbdgY1RNL08JmigeGG+vGUYKQC
         V6iD/pTciEuEjl3O4un8GUpM3xbXYtCNGkngncU2gG1aOhLYjGz+uDd89nEYs1CP/qFl
         MZ4wrFKM6g6OgxwNTs7GGoGNtPj0LZme6ywyIVucWdqxYCN2Lza6RgjEaBsA7r5a5CP2
         tuskz4ctjTRFDBoT9buCO+rsp+3jnrszp3Vj4nmRifrmZ+D2DtQSYgeh0vr6ZbwYGF8l
         HIMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785276630; x=1785881430;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kK9fmvYx94bqGyeMgzsYcbMKuj2faWTY3fQuvgNhZiw=;
        b=AHBUq/fEphh4I3b2mL4THPLwsHV4dkyLMekA/wVt8qHVQ/o3tSB62GoDpTdq+0w5+F
         7uFdK3fBoHKhxTfEterRAPHlWJLGrbkvcK6TZ7E3INtg7CdtC61cy9KNOCUJZmb3pPxR
         MJl0NtDEZ3GEWc2tQGmQQFkwv8CLWCKs58a9UDpaNriXtHTGu5UAs/C7tHify8AhKDpN
         iGFxNIOZI2y+1M3rFleeD0KFj7+qr9O00Q11vXzv1qnz5Ot70D8HxKLb1991zvf5RAC8
         LbBYMMGPHq730JMy43P6DXwBYTxw93ade5HLzYaO/1ZBrLddi3ZKmRGdei4U7jy2O6mP
         zOrw==
X-Forwarded-Encrypted: i=1; AHgh+Rqiosks7udGKDrbFHtdjfM12BAQqaQwcdP/WUDTVp7acIll7hnjrftBSP/uObRWjJ1ciCDwrqNqWw==@kvack.org
X-Gm-Message-State: AOJu0Yx4DGE4DRLqTP4SUFy6NMFfTwN7/QoUR6etfbaTm72fD49u6jge
	4tq3+UmTLglt2FxahkCFBnNJILDK0+KwYq0ALZbp1qjFY+yrGLet4425hW/FyXufsD/4OSEAd98
	YKzFcl96u57y4Yg==
X-Received: from pfik11.prod.google.com ([2002:aa7:820b:0:b0:84e:40d2:2e74])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:39a9:b0:845:3914:f039 with SMTP id d2e1a72fcca58-84e93203c18mr4669411b3a.26.1785276630227;
 Tue, 28 Jul 2026 15:10:30 -0700 (PDT)
Date: Tue, 28 Jul 2026 22:10:05 +0000
In-Reply-To: <20260728221007.2098560-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260728221007.2098560-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.487.gaf234c4eb3-goog
Message-ID: <20260728221007.2098560-12-dmatlack@google.com>
Subject: [PATCH v8 11/12] PCI: liveupdate: Do not disable bus mastering on
 preserved devices during kexec
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 886DA1A000E
X-Rspam-User: 
X-Stat-Signature: ojbik3ms9aae1bxcnfgxibfyjrj3pc4c
X-Rspamd-Server: rspam04
X-HE-Tag: 1785276631-541394
X-HE-Meta: U2FsdGVkX1+Cn6pJk3WMxfOQ8kuUBH8zpJmrEntWmPZ7Qp+7m9x3NRQxaoZVWl0gxn2fI08jYYlFV8zIX+QDDx6jmLirPmNEYVlEGvTXtlEVceN7oGZD2KZoJZHjRf3IPr4tBSwGRR0cdfe/CnMFrvnSIZuficiMy1yyzJclfAfh8cZsN4dgv7A8zpu/SeD6b00iobhvbxX/0Dkhi7SNtn0W2IuFq8YqT/+Y7XEKy7u5Qfviwblprcovk67huIiGct7lvIyUUi3Nc87s1LLO0R9PXFm3T3tWBTGKyjSOcuoOidw6HTm2SmSQ3EnPowWi2QbO5RXfLeqhRQeR2TjxWIim5+Wrt6E0ddCxdP/ovXawK61C3GaSzTbYe6w4BFP9G9LSmmA8ls6z1C2GWGjqlLDTKb/Df+tELz87z3o9okXnbR+Nl001as7xP9UPi77WQao60LprhA/mo77Vz/3gJP/sLx+QH0RyFjJ3TYqKAlXANWRcIF36ZPuepY4KWe0LDK85XkERkx37d2ScJMB2GCvLqLcR1bl0QRuxAUYiLhplzHan8ziHazsvHUAugtCXXWRlAvFl5BBNgJPYMduyGbfZZ+CUvtZrhX4Na/8ab7ywMnLnEshhybO2WODmfz0EjoPmm/9eKQmYNr69+LO8r+KVBhYJZRhH1XbRKoQRNrn+E4cV2S/X07hACd8bDaqSkKagUEZn2FB6Ol4Xao60VbO51qjstoSLW2t6qHv5aNAyxudiR014Xsyd2lk3VEaBbB3vi+GYfeRZko8cnFRizTDeYEkQbxdyb69Rqjco4ULhTgeT+mqRsSoyBfHTVvZJLJj0m5Le8wxBP8h+LnkZzKVVabWw/jbwHqMX9zmesN/IFgOOxuldnMy1Twdd81gH8tVjPHbeFkqU757bQv1SQeYanuK7pc+Y8851v4Xfy1797GrCzveO+TDXRUJl9qUBcEz22tT4UqBdcsLMja9
 +wD3Gbp/
 zZvGHS4XsdSnRP9rix/XMcgiBd+GE42yDCywj6Twp1MBuF6GOjzqqtc+OnCJlvqtNwwsgELr3MI2L3YASK5i1h31ya3jIe82Bbpc/385s/U9gHtxMGemMS6sDo/oFePb00r34U8Jyyeg7APST2/6jDj/7Dav4pPbPqIp7ZQcH0D1+DW2UeMLrvEQTXQGwpQp6vvWHaw5JULEyc6PVilsbs2c4L6A3Ntcx53Zn11BMR9z+EOdyo9pT5OS4J4b1FkddjNagaZMVJnLFfeTIuxcyi1IZbAHSNX4u0dEjgKmpntuRLGlQIozQc6sTDiza6NEH6rgqPHWgumRa5L1jPF59WucZ4Y2op9TPvQQ+vNFeNJvQsB8t84z7GTQDrmx1mzNMEdeycsbE5iUGuHK6iMUnlThN5jCGstSmInhVI/zswvuLERTivd5ubgCwWvV35adfiu3ilyXJFdG6oohADZjwulByoGVxgYWXG+VMNpNeo1nQ7/CXZ3ILFsuUMMbBNxocpl7igsCBKfbkimBwiTLPqo4Eyr2R3QQXAMo5VabHAJWi+v7rHzn0RxG8vZFCUOCFONyFQqB87vTFnKjeK7rMoniOMA7O6GgCk72erStLGIS89ATRRXZvT/jNCorvxm6MqJrUn0AXT282DLpBIHwjcNSmGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Do not disable bus mastering on outgoing preserved devices during
pci_device_shutdown() for kexec.

Preserved devices must be allowed to perform memory transactions during
a Live Update to ensure continuous operation.  Clearing the bus
mastering bit would prevent these devices from issuing any memory
requests while the new kernel boots.

Because bridges upstream of preserved endpoint devices are also
automatically preserved, this change also avoids clearing bus mastering
on them. This is critical because clearing bus mastering on an upstream
bridge prevents the bridge from forwarding memory requests upstream (i.e.
it would prevent the endpoint device from accessing system RAM and doing
peer-to-peer transactions with devices not downstream of the bridge).

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c | 11 +++++++++++
 drivers/pci/liveupdate.h |  6 ++++++
 drivers/pci/pci-driver.c |  7 +++++--
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 65bcecb1b64e..32b73ebf71f7 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -132,6 +132,10 @@
  *  * The PCI core adopts ARI Forwarding Enable on all bridges with downstream
  *    preserved devices to ensure that all preserved devices on the bridge's
  *    secondary bus are addressable after the Live Update.
+ *
+ *  * The PCI core does not disable bus mastering on outgoing preserved devices
+ *    during kexec. This allows preserved devices to issue memory transactions
+ *    throughout the Live Update.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -879,6 +883,13 @@ int pci_liveupdate_adopt_ari(struct pci_dev *dev)
 	return 0;
 }
 
+bool pci_liveupdate_is_outgoing(struct pci_dev *dev)
+{
+	guard(rwsem_read)(&pci_liveupdate.rwsem);
+	pci_WARN_ONCE(dev, !dev->liveupdate.frozen, "Preservation status is unstable!\n");
+	return dev->liveupdate.outgoing;
+}
+
 /**
  * pci_liveupdate_is_incoming() - Check if a device is incoming-preserved
  * @dev: The PCI device to check
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
index 49d07fd02132..9c31fb60207d 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -20,6 +20,7 @@ void pci_liveupdate_scan_bridge_end(struct pci_dev *dev);
 void pci_liveupdate_cache_adopted_acs_controls(struct pci_dev *dev);
 int pci_liveupdate_enable_adopted_acs_controls(struct pci_dev *dev);
 int pci_liveupdate_adopt_ari(struct pci_dev *dev);
+bool pci_liveupdate_is_outgoing(struct pci_dev *dev);
 #else
 static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
 {
@@ -55,6 +56,11 @@ static inline int pci_liveupdate_adopt_ari(struct pci_dev *dev)
 {
 	return -EINVAL;
 }
+
+static inline bool pci_liveupdate_is_outgoing(struct pci_dev *dev)
+{
+	return false;
+}
 #endif
 
 #endif /* DRIVERS_PCI_LIVEUPDATE_H */
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 51616e4327d3..47cb3dcaa927 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -546,11 +546,14 @@ static void pci_device_shutdown(struct device *dev)
 	/*
 	 * If this is a kexec reboot, turn off Bus Master bit on the
 	 * device to tell it to not continue to do DMA. Don't touch
-	 * devices in D3cold or unknown states.
+	 * devices being preserved for Live Update or in D3cold or
+	 * unknown states.
+	 *
 	 * If it is not a kexec reboot, firmware will hit the PCI
 	 * devices with big hammer and stop their DMA any way.
 	 */
-	if (kexec_in_progress && (pci_dev->current_state <= PCI_D3hot))
+	if (kexec_in_progress && !pci_liveupdate_is_outgoing(pci_dev) &&
+	    pci_dev->current_state <= PCI_D3hot)
 		pci_clear_master(pci_dev);
 }
 
-- 
2.55.0.487.gaf234c4eb3-goog


