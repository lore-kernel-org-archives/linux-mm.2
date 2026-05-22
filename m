Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69380CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 20:24:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 936486B00A6; Fri, 22 May 2026 16:24:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C4716B00A7; Fri, 22 May 2026 16:24:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7377C6B00A8; Fri, 22 May 2026 16:24:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 623D56B00A6
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:24:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2A35914072E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:24:25 +0000 (UTC)
X-FDA: 84796183290.03.B54BF4B
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5A43DC000A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:24:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jk4hCrRQ;
	spf=pass (imf28.hostedemail.com: domain of 3dbsQaggKCIYnwk3vkmuqyyqvo.mywvsx47-wwu5kmu.y1q@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3dbsQaggKCIYnwk3vkmuqyyqvo.mywvsx47-wwu5kmu.y1q@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779481463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ELGOGHy4/KVLZOwsmSfN8vqnsYItcEyHVrWWGLC9A+w=;
	b=2Rg2wIKnDHfossUA6u5s7FHgTz2yWN5SF1dj/1969HxKIWJqtYOv+SRCu3bQf6lwU4bZsd
	W8wusBElL8Q8MixPcU5/xzEalBCO+rhwBzUewD89Ht4SoJV/z2H4kB5PAfHpN1lcAs7lxI
	V0OIyhL191ghnPZpTsADVTgNfPa/TQ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779481463; a=rsa-sha256;
	cv=none;
	b=HVcz5hYSsTm5rPE1jaYE/HKyzGV0+OViBgp/MXB7F2Yzr+UTWR3hv/8YKxtrPl+IInaSPv
	fqU5Te8kLBSi/Vk4dEoSCh5YJy3qmh6jBK0Sab3uHOqvjJmgirnZX7aQ57s6FIbo5WbHkJ
	0DRaUg/aaYp8lLlO7e/DckbJzn4KM84=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jk4hCrRQ;
	spf=pass (imf28.hostedemail.com: domain of 3dbsQaggKCIYnwk3vkmuqyyqvo.mywvsx47-wwu5kmu.y1q@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3dbsQaggKCIYnwk3vkmuqyyqvo.mywvsx47-wwu5kmu.y1q@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2babc42244aso180266415ad.3
        for <linux-mm@kvack.org>; Fri, 22 May 2026 13:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779481462; x=1780086262; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ELGOGHy4/KVLZOwsmSfN8vqnsYItcEyHVrWWGLC9A+w=;
        b=jk4hCrRQ/2bqGu+UnCJOPpKOeeyCfcht4tX0cX+w7feDigTXuKHcXr0gPl46kJg28p
         i/4WJ1L+raMhVp6LI904sDXkQnqECMnDTErYsw2nZiyCKhok1GvZoqUCYJoENQZrT8me
         7V1qHdsDstyHj/MMirs4EijXuFxJskLsFCNO5jHxX2eDh/S6IJps5871wZuiSH8nQFqO
         h6dQsrJ2UK1GD3CBzPfnTXnyKO8xodNW1ajtUg/eU4v6QEwq7my37EHIo08ZtxyQFHmS
         Yyq92XS+5dao4zo3f39pbqXtH/L2Ka5UWBGaX/APhP8gb9wY7AHoDVS/t9szYsXHNnvs
         w23Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779481462; x=1780086262;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ELGOGHy4/KVLZOwsmSfN8vqnsYItcEyHVrWWGLC9A+w=;
        b=QWo+0JrsAnKm0g2/WVHWJP9topaN+wZhY5bQqGKZjMuG1IYLRoyL7njKTKURy86mB+
         nFUV6B4OGYBdtSFalTIZppjTgrhdxKWM1xksGTXy7LLLG3BO+8Bt3azKHAL+QCZH4kVP
         sCRffV3VSLeVsVGsdxKimogEhBN3+umx6XyGqSpYQA7O9a6u27iFlR+HtJyBaq97P+A7
         8lnwp0vbgSLJxz6d+l9GeWS+P7WSZaSF6s5wUlO1EVp41B+/Z4oCBGmiPi6atagIiEvg
         WHrTeXLoEOs8I39Oa8gNFZ3avrrh+o3YlGScW/p6eONqRIdS7A8Bl3jfqsX8APisRpeh
         fj2A==
X-Forwarded-Encrypted: i=1; AFNElJ+IHNvsNJ5hjqSBzPtBzfSAemerTwmgBGB/Zt5245upipOmnKBTm4mSNkZYpk0pm1Uy4Rk/HbplpA==@kvack.org
X-Gm-Message-State: AOJu0YwFFEbjgJCNmxFcISp2huH7kJ//QN+SYJHtIHWmMEZ2GKV2YvOk
	3YFnJWIbugAU8WK0AvEUn32WATOJ5IhCMxmPCHhjPeKkedlTebjrmwfGYxz1U6neryWt1zOhMJ+
	IVLfQ60giQfZvkg==
X-Received: from plgm11.prod.google.com ([2002:a17:902:f64b:b0:2ae:c50f:f4ec])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2b0e:b0:2bc:7c62:187 with SMTP id d9443c01a7336-2beb06133f5mr57599895ad.29.1779481461788;
 Fri, 22 May 2026 13:24:21 -0700 (PDT)
Date: Fri, 22 May 2026 20:24:09 +0000
In-Reply-To: <20260522202410.3104264-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260522202410.3104264-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260522202410.3104264-12-dmatlack@google.com>
Subject: [PATCH v6 11/12] PCI: liveupdate: Do not disable bus mastering on
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
X-Rspamd-Server: rspam11
X-Stat-Signature: xda9ppr159hz6fzmuopwnrijbbf73np8
X-Rspamd-Queue-Id: 5A43DC000A
X-Rspam-User: 
X-HE-Tag: 1779481463-246870
X-HE-Meta: U2FsdGVkX1/8FSCK9h09UAJfgBoCMZxi1ppsVoC3n2Hw8FPdglVqLYuRMAAlvqmawYh9S0hxbEBYQjXBY22RlO8Jt9RJll+iisT4f6oDyJ1tg48txIBs1Rd0tbUDxstIkwvjOD67QUFlz5HTRvGXy0y9zaBiKTLuXkVKbGkF+SaFyQlajNrBw/9tqSYt0R6BDRFQiBfyjob0VB3K0cR9Jdq2paMakomOt+nSs/bYPb/eOMA/ETYsngvofpg18M/ZFoMaUqU7+KOH1ddrTNJTmNsrUPhZhjr8fJ3/BU2NKCKHJQSRJij6bp8aCqdH1/KN7INJEzrKssEpkjhNMhcA5RGqTl5/pHhs/4XkQA7v0df+mHHWZIrlDTXxUfGeQ8HpT6o1K8RDQxS+hyeTGMY/i5WezfHv/rxx45xSI/AkZo3OlDsVjaASZmUHmBqiwYcruaRZTaFznGJYDODb1wH4U5L4Hn1YRBJwINd+Le2hNGfiocW65jyZ9tQBAh7Rue5aQlBdcT/wQt1aftewjb9rPLOmGv9aEuEZraM4Xsyne1O/dkcoXTd0rb0zBQ51c4dnEZk4EOr3Ivd9uO0M+hZLJDu+Ga0nSfjvYYdF04keDTvV66C0L5sTWQBNsrz8SPoc2H8XrALcXPtiL5LJEwvqgIcRap664Vjbd5f9NRaXn8dWbfbtPkvOprxh3Y2DOF46cK3y0dscIeEofIzwh2X8hv9PvG8qZgjMKNT+JRop9oqO16dizzitgeGN2NCVGBDAdcanhKtzc72N4Gb/nCRYO768gHZOPKLQAfuiGnMzM0+rfPJAteICrdkmeT25tr1PWzmCHtXHrWrRUUuvsnRuOSMUGy3Ijc8kTowHOrY5ZfjpPYEInPB+u9xt5yKI5phw5NvFwXMYcCyo4Xdo45IDNYDJ4Ok4kbtpDGGSErxuJe2yFcjAd81jPmnHjaB+gIae43rjiX323luW5xjV6rp
 4zNkKF7c
 e23/xNOTdwNfeyDhGIwRIj0KQKl5xpTyvIK6hkU004PkA1pFkV1MZpuWJDUkNaIM6FQxTGJXpWSgJPBzlGCZXXaW7cJNIaPsylF8a9V6VxrOW0oycXOkAbns20f8JArXUA9StSawEzDDYE0JrAzprx+fV9WNLBhVjdYNEyTRMOxpiwvLio7UmZflOlI802DPv9cZ/7UHW/u5Vas5G6b6nui6WDZyY6tF+8uxjohf1KK7IRo522XEJ89FIQMCldBRdRoBpu/xnoU4iFeHLoIhoWKPDetgr/rGSjfEuOKNruLZOfEPgfnZjtG6XC5ccqR7m5SyJHYVzm3+CrpuvaNsZy/M9cuP9tG3POEDTLebwLn2+eylRGSp4vIn5g99en2Wo+3cOCpg338LHtuRl8u+24pREBFc/NfULihcWyYJvlbzz5EAo4NAHmzTPckTgPadlXo8MWP/+Dz4HGw4Iu4e0i4B6yIc1VXCDKtz8igeoFow1egI047n8XcjAxE+QHATgwMz0OVUwhQbTKOUr9Gz4ED6pLkk4awQsc2N27W/eLeWSDmuqQU4RXPzf3g==
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

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c | 11 +++++++++++
 drivers/pci/liveupdate.h |  6 ++++++
 drivers/pci/pci-driver.c |  7 +++++--
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index d404e64a4e55..a6f2790bc1bf 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -132,6 +132,10 @@
  *  * The PCI core inherits ARI Forwarding Enable on all bridges with downstream
  *    preserved devices to ensure that all preserved devices on the bridge's
  *    secondary bus are addressable after the Live Update.
+ *
+ *  * The PCI core does not disable bus mastering on outgoing preserved devices
+ *    during kexec. This allows preserved devices to issue memory transactions
+ *    throughout the Live Update.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -790,6 +794,13 @@ int pci_liveupdate_configure_ari(struct pci_dev *dev)
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
index bcb0bc73d684..b266406aaac8 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -20,6 +20,7 @@ void pci_liveupdate_scan_bridge_end(struct pci_dev *dev, int pass);
 void pci_liveupdate_init_acs(struct pci_dev *dev);
 int pci_liveupdate_enable_acs(struct pci_dev *dev);
 int pci_liveupdate_configure_ari(struct pci_dev *dev);
+bool pci_liveupdate_is_outgoing(struct pci_dev *dev);
 #else
 static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
 {
@@ -57,6 +58,11 @@ static inline int pci_liveupdate_configure_ari(struct pci_dev *dev)
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
index f7a5e65a7c75..0b1f8d01d7a5 100644
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
2.54.0.746.g67dd491aae-goog


