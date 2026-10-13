Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 657CECC6B12
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 16:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41B1E6B00A1; Tue, 13 Oct 2026 12:25:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F2546B00A2; Tue, 13 Oct 2026 12:25:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BA486B00A3; Tue, 13 Oct 2026 12:25:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDCFF6B00A1
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:25:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7251D140D16
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:52 +0000 (UTC)
X-FDA: 85318129344.21.6246C9A
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf06.hostedemail.com (Postfix) with ESMTP id A699418000B
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CcP8uxQ9;
	spf=pass (imf06.hostedemail.com: domain of 3jVvOaggKCNo9I6PH68GCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--dmatlack.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3jVvOaggKCNo9I6PH68GCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791908750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GUqD4Ux5OAYgjaajPXSrWaI1PYIhs/xbAlAZjVaS8QQ=;
	b=VhjGZdSDFRccXpoBOPqv06dcUs1jsHX39TtruEyK1/f68wLneCuoWNgjD2/yyioTG0gqGM
	ZleWyHzc8WPZauUBHhjAqGKRQV03klD2DeFmwrTrNj0lOxum0LNuPcH0YRzAaVy0ZoAVYK
	AWU2fK/Ng43aE9Mf33vKyFWoG48JHiM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CcP8uxQ9;
	spf=pass (imf06.hostedemail.com: domain of 3jVvOaggKCNo9I6PH68GCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--dmatlack.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3jVvOaggKCNo9I6PH68GCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791908750;
	b=ijdOk735nzCCKYcR5e1L0w66zfUgbl6pzqw7dyji1F9KqO02UQSsiZqkux/s++H3W4Giok
	jRMyJ8Yzapenu5nMCxuPCO6XNxldINQ6rk3vpPA5M+hn6gKujTEmP/OnJpOs5k//gKH9KB
	6sUIX7T5ZA7FBDwvPxYy15H1sk+Xyo4=
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2e8ba4757caso16832755ad.1
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791908749; x=1792513549; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GUqD4Ux5OAYgjaajPXSrWaI1PYIhs/xbAlAZjVaS8QQ=;
        b=CcP8uxQ9NB6OrT4VEy3NokNvIx8KiOztQOKc2tU3dCcclI0hKdn8mKBpi2jOj625GH
         Rp2SfFaYnDCkv1Agqo823SFFjczFZHbgIKfLIaxYcsTDXRp5SdSbh9QjIVJmIIFOV4PP
         GqckilfkQzA1Za67GTZQXqUHb8J4T/3CDlpmb6d27A8m6OPwre+dPFCbHYXiZ5YJhUHG
         658TYwz/RgKH6wlHFNywX0uyfvtxll+rwGrCfur6OlDhZHrWCkfKdQkjDUB5jZZ+SD+2
         tHT6bvjnujINJgxtHURSi3is5SWI16oKeKae3Gkemnx8i9BKfcapato4kBMqlWOiiQbE
         1X8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791908749; x=1792513549;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GUqD4Ux5OAYgjaajPXSrWaI1PYIhs/xbAlAZjVaS8QQ=;
        b=LSQcizvp7Nt59epFULQ77w5vDtt7UsLWDX9+V91djbzdkaJbqS/cJxYzxN5an4vSf8
         OZSYchUF4ziNPVklr/55AiTj7893DgXfiuy7Ejnqfvd9zb/9eP9pwz6qvuRt4lPc1q2o
         XnwkDMic3bGlaWAIXsEJChmmUfidBQqNK9R3LAD0DRBancBZkFhQzfK4m1dcJF9PrEGt
         JhyhURk0PDrU5CJW2E3DIxCnZJYda3pB4EGo3tZaQUUgtZH3XPwO1OPTH03E3xq4N+bO
         9w8s7ZRvxRDI5CPz307blzM6bSURbbB/68R+gttHiCaiS29fyIfxp4PUHOYWUx7ll5yg
         cLPw==
X-Forwarded-Encrypted: i=1; AKwUvBw7V62azYcDBZdF9kYSiDqj0de5w855U+5ogHME9iGveU1kyjIF8r9P69b8JA1d4R2RHF0XY6DEyw==@kvack.org
X-Gm-Message-State: AFq9FYLOTA5u6RT4EMexD4PR88oPAPeM3TDq2yRDknRSoWqhiBOqjJcY
	snYle0/gVF0M3OeGv5OaHpPy3GU+nOE4o1GesMKXTrGlaY2v6g0Rb/LYWUIWxqCufeQTukLcEX/
	RCngUPIEEywXJpw==
X-Received: from plbg2.prod.google.com ([2002:a17:902:d1c2:b0:2e8:31af:11b0])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2305:b0:2dd:ad73:5b56 with SMTP id d9443c01a7336-2e842cd12bamr86769775ad.17.1791908749286;
 Tue, 13 Oct 2026 09:25:49 -0700 (PDT)
Date: Tue, 13 Oct 2026 16:25:28 +0000
In-Reply-To: <20261013162529.1928093-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20261013162529.1928093-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261013162529.1928093-13-dmatlack@google.com>
Subject: [PATCH v10 12/13] PCI: liveupdate: Do not disable bus mastering on
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
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A699418000B
X-Rspam-User: 
X-Stat-Signature: 6uuo9o545i95zr7xf1w6x6etcg3k8fnw
X-HE-Tag: 1791908750-544226
X-HE-Meta: U2FsdGVkX1+fqJ43ctD/tZkS/Z6+zlemTt2SsH0nWSnWjvC0SqrebFIGny7f8fGpxHLI9UMCiwxfuvI9A/OoNg+rmIW0WZ4B4H05qZeSR+SmLaOEF7dDU5iy+xAacE66nGCHotE+YZ8UmdDL/RGJL/LePP26dPTK3+2WYrkK/LiL0WT/CkygViNfB5GlPiGQLhTBF6O0cRGN1j1ySuMNKgfo12p+mKfv7qQOB2sSD7urZRyAEpCJkF/YoK4sTReRerjN4ZEGuHM/IwDyNy67b6tEhcaKHZPujBG6qqERjK/OjB/7EMVq0UeQBgjuLXxkhEsh1+Z/Crp7IcroGgHo8uKlfPtMZPi8bDqufOX2nZ844j5HtowKoo0093X9BNy8JlS4GBX1HxL6ZK609NMcLc7ISxXlX7hdOkcvh1ww+DvdSApdWrYaIEaoWA6yV0usdgCPMxFqrAkdQ+6rgmYMPm7MtzisxmS4ZfJ08SQspnl2iQ8kWVNJ7zIxejFzLoAjKLCLsvWhaaJLScsV6MFYR21A4k6MJ2woF27/ZxdVUrSxM1nDZywcFCOgRRxii3T9JErN+hp4tLNaBjyt1bDZi/KtPDXoRgdJA+0m3VzdG1cBVzX8FLad2xaM6rrJg5c37+qtcZSs4YwcPpfvaL+5NKHz3nHeOoMtcWOar1I9/afcRlCJeRJX1bwCPPD86Rj2RjOOtvBq6w2hHHAE9UYsRBV2mcH3Wn5AG+r3k60cmmtb4b1QyTeqT7OmIrohMl/DYI3TG0RjB6Q+g8GWe/dU8fGb4WHcPApc2u99lQ/tgOOqVILUGiqb0svYyVrZqofN5MDMvtLJtHToyPn5ecrC19y/8N59ARporoiR+h23pNTHkmbAO/TvHuRkjNEFOebCjpOkGToGTCa+CoBCYX7xZh25+D2Zl+keQal6v5x2rPEzKS8DzXl4BPhxB4604P0GWYE2eS8G6gpxJxUkU+U
 V7pDFSss
 QgfyomxYjmAc7H94yK5HDMcryRPTLv+SFJM40GsvAgQLncsNKNYBA+4xltkHcWOY672q7HwgYfNoUDXOWe4BO8SQRTJVRUbSwmHncMfOUq4hHIfxsm4Tx2Sf9E3jINavc7wozW5rbBY3ywZWJ185E273l1lrqIT27pfp37PU6TVShlFwjCtngbxztcTgXZpqcCyxyHpzfsoHJTBc3ywbxUNqRanYsY7s7GYbqXRHFwSZ4I5vbLSWjvZjiSTcEWt0Qdppxgtd10yxWpWX6dcs+QBNQ/CqoTX/qGWpGppYk33OMtXUqbXzQc201GA/JiW39zhaccAPStanyYndAP5VTMErDO3aruZO+UgJ3t0XY2TSfstJSHq87BNW/B+t13TE1geI14Jmpw/kVNPDmF0G3ytltazGKSjyo30OYJQbezp50cyAmbyp1/FgPdnLPZX7Ex8yV9AyceII/CSuzyddmGXtO0RxIocjNfb4WRkB8scW6PbhkHd0rWGO1tuh/Ou7AmZ2S92Q26kUv7byN7GudeJSbd7f2Mo03MGQMr0nRZT/e9/UNdped8XbUUXkhSMQAgvJlBTLxs8j2JmiLLOcOSzsVWrF/Vq+2JzyLVkQ3ffdpe2vG3D7re5KLcETl0iHR92lxmGTNyKThE+2AkBFRx8Lwpg==
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
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c | 11 +++++++++++
 drivers/pci/liveupdate.h |  6 ++++++
 drivers/pci/pci-driver.c |  7 +++++--
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 38b7815fe7d4..6f92d4ddca2b 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -193,6 +193,10 @@
  *  * The PCI core adopts ARI Forwarding Enable on all bridges with downstream
  *    preserved devices to ensure that all preserved devices on the bridge's
  *    secondary bus are addressable after the Live Update.
+ *
+ *  * The PCI core does not disable bus mastering on outgoing preserved devices
+ *    during kexec. This allows preserved devices to issue memory transactions
+ *    throughout the Live Update.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -973,6 +977,13 @@ int pci_liveupdate_adopt_ari(struct pci_dev *dev)
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
index 5aac19f7bee6..333ddd8f36c5 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -18,6 +18,7 @@ bool pci_liveupdate_preserve_bus_numbers(void);
 bool pci_liveupdate_refuse_bus_numbers(struct pci_bus *bus, struct pci_dev *dev);
 int pci_liveupdate_adopt_acs(struct pci_dev *dev);
 int pci_liveupdate_adopt_ari(struct pci_dev *dev);
+bool pci_liveupdate_is_outgoing(struct pci_dev *dev);
 #else
 static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
 {
@@ -51,6 +52,11 @@ static inline int pci_liveupdate_adopt_ari(struct pci_dev *dev)
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
index dff60a03204f..c1ac2ef025e2 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -569,11 +569,14 @@ static void pci_device_shutdown(struct device *dev)
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
2.56.0.385.gd3acb90ef8-goog


