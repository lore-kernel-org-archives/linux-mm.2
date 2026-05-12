Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E563FCD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 18:49:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F0016B009E; Tue, 12 May 2026 14:49:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 379BD6B009F; Tue, 12 May 2026 14:49:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B7EB6B00A0; Tue, 12 May 2026 14:49:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A2466B009E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:49:03 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DC2771C0452
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:49:02 +0000 (UTC)
X-FDA: 84759654924.19.34DB970
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf06.hostedemail.com (Postfix) with ESMTP id 30540180011
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:49:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BqnbBxbO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3G3YDaggKCGwNWKdVKMUQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--dmatlack.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3G3YDaggKCGwNWKdVKMUQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778611741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zAKIEIbekI8e2jyBQPj/1aDykzqqCbaXW0rj6vQUpoI=;
	b=8eixRVM3Y13n+Gk2hbbQhYoZ6vF+xQWbDW+LxqnOZ14u1R4KSq+Dqwko2DEASM6Wk+1V3f
	ubzK+8x7iYNgIBSEs7BUVpnvOu+07FPG0xlNmzxG97zBUnoTGZ53dtKAoqIYutHAwOS2+j
	+U+k6uV67Dv/oKcF1S671SW8IC3UzVg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778611741; a=rsa-sha256;
	cv=none;
	b=4fEvHrOGtLfMixqDijC2iwG9DlQ+kFkNY10VFMzKcQbxu1OJHoEV2CHqA/tzzyGUhZEyat
	0Trp9n8rgGGRcFL/008/LjXuGE6qtiOudWndAbdUWpOjKf3J445oCJgspVC1axw+RIzCof
	45niYfV8OD2EHmP6AkZAv0DPPyP4oXU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BqnbBxbO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3G3YDaggKCGwNWKdVKMUQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--dmatlack.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3G3YDaggKCGwNWKdVKMUQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--dmatlack.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-837c4eb3bdfso3989862b3a.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 11:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778611740; x=1779216540; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zAKIEIbekI8e2jyBQPj/1aDykzqqCbaXW0rj6vQUpoI=;
        b=BqnbBxbOzuiBlqEMV7ND4eX15pmck4GVnWnHI1OiWVWOkqSgz8wB+PXEUPhmbbHbyZ
         52V0VDIgLkFUHqz/0kZbu7WsTWaf4Th35bmkyGjuVIFE7quPPY+zjs5xafrIUX2e7Bnl
         Mfme7IFMNbCNh7MQ8W8bloImjss88dJGihHTzy6v6Sm+bcCuw1UTqXH/KM7Q50wTRQYP
         wlE3ipoiBGHuz3uuI7oxlmTU38yYQkozI7vTxO0+umxltHjqmXwNadjmjvhsdXdLXk7X
         lbgpj+Q9PRLfn9j4A5vH1ZcNGJ2rgSzYfxil7+m8gyVYZ9w9jGSX5gqiuqJqZ0WFb53+
         fxow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778611740; x=1779216540;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zAKIEIbekI8e2jyBQPj/1aDykzqqCbaXW0rj6vQUpoI=;
        b=clDzxSw8Z9tpFdzSlxnoCWgovpUM0mms3eFs2ro0g4Lqa/hcV25wPcn4oqgGFMMRv2
         7R2DiXnJleM3k2EAOsKHQPGNQnMFLfA/UHsxVJ4ns2xuhi9wli5bnIjT0H8+YJgDl5lN
         V6V6L6BLRgcGFH2qc/P4VQQ1m9T27XMXYe7qJFGJGD0Tw2AzrcdbX/BXnY4Z8S4+hE8y
         I2gTRDHAE9GAtygb2rqjVGH2oCNFijJvXv33B8QQDZems2MFg4WYeRt3kihZsL+B5rPb
         3XfX7nZYv33AaOOgjBOSnQpEeyL7GYyoRrtkhzFuvcLZVYYnakZzdkPcra/bVBlQVPx6
         qBfQ==
X-Forwarded-Encrypted: i=1; AFNElJ/4Fe+JeTr+v7euP2XCTJcYIQpC71CekQxDPOmGixxMiOAVCsIfZ9+Gcdo12AqkuIf6ucLmNG0CWw==@kvack.org
X-Gm-Message-State: AOJu0Yw9PLOYPF7qjwqoIQBasXg5HrU0MSmIYBnUzSQ/Fz8EEj/xLE/E
	JNjwKPN68gCv+WfGD7qheUS33rofwQt0RWkXkD8JCXQu8WqUGiLEaLdmA18R7sffPXGLAkEBWWo
	3E5aiXZDTli/iew==
X-Received: from pfbks2.prod.google.com ([2002:a05:6a00:4b82:b0:82f:b296:c01b])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:12e4:b0:82c:f035:6748 with SMTP id d2e1a72fcca58-83a5dd560e6mr29210159b3a.42.1778611739675;
 Tue, 12 May 2026 11:48:59 -0700 (PDT)
Date: Tue, 12 May 2026 18:48:45 +0000
In-Reply-To: <20260512184846.119396-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260512184846.119396-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260512184846.119396-11-dmatlack@google.com>
Subject: [PATCH v5 10/11] PCI: liveupdate: Do not disable bus mastering on
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 30540180011
X-Rspamd-Server: rspam04
X-Stat-Signature: 75rjokizwdhtis8w3gr9pbqt15w3owih
X-HE-Tag: 1778611741-344500
X-HE-Meta: U2FsdGVkX19nLnawgOVv6tEB5r+t+P4GdsCW4MRav6Se0hlR9VsYHgKzXPSjNbRvvuSjhTuVKeLiNqhJTSqNq+RUE86Kif8TPcTeiB90WW2Tte26UvcuH8Sid2sLS3ZaPsUgEFqwQxlyH6o50GMn1TrXmdITfEkbzltHNjrbtshFYHuFQKce7Us0CzNWzSxB2lVmigsvibcfOzUfxfmzDdLHaMmh1vdRHKkGcgf94eGSEolkgvx+yUmui25rTNfG9qDociUfHoxJRLiGB7QdzxRZIB8xaNlvOSz1hDybm7CT4+6i3WlarejSApN8DIvbLg/PZaXRRbE5ryemOTxxzY6WkIldEXs0fXZityTyS0SfTx/P/9gYjMhk/4/FTTYYtsXwNXvP219Gk5pAO5siN/dSlGmbGHRnkY8e/hYqQymwbz7Mm4WjymVde9Fq26a1/pqZ3E+ZsC4qjT0AzVOxCqpaEH+Jo0DUOGKSc1hj6+ngEAmcjWUuo0udFOQRnBpItqHjxl0sG90MmIG0Yhx0mSFDqMY/xEh8Uz1hrrLuKkfQOTMiDyt8tnyu56p8SP6hZW4kJNtAHN8HaiVi3MPgQtK8KHYxf15/JrE+M5OwMhoDSMhQ1JG4awfnSqJG+OqPiEbmxY2nqSCYDjiIpJ8Hgtj6gCXtNKLFCR6ErDtIOJJcfPlK7uI1YMv/f3FHIuR/kDZGWWbYo88F5Pi0NUB9uN8N61Ni/njx4diKxL7IHHFBmKE5YRxlcXb6KM9IpkfFCxPBGQbiBMGb0g0NvnmGOJZbH7pYo6T0RGQfAx0V6S0mFKguMW8flpbfNpBPXSgFxMxLR+elMMbElrmGIQ6AeAA3DhjPGLB6ixAqdN7pjBbMNDi8TZ+89UdPqnk0g2/pWzCMPT+kWwARp5uRQo/8xCl3njL4OoOfkepq4ztx76TimvTrGFd7hIoyqDbem3Oxdh8kPuBsmBh06lkE2M3
 jYZihPhZ
 HJ0p9ZzbXCaszgK9pL+FJbLU83hvTI8o8RMrmH9TYMsnYyG0dwRISV1PrOT4sFY24k0xf7vbxxF+z5XHnk+TPV3zr3lbYaa3btgQ6jNPJeoc2+n9t/M97q/VqBRYddmHrGbogFKsCGqmBzY+LSozrE4XHeGpipCNWy4xELoo4rYZtbk9w+Iwd2dR/JlB1WRPG0a/p1EDBaSphkjcL3szhB8L4HD13xZgd9l+g7YwyQXveH2WAEB3t82PfS4eQOtYHSsuhLfPiThK0CuBOe1HOcAEq3vsuEHlN3I4+s5waQCTUtCQOPm2MvYz66OCxmjHZGxAPycrUEf3TKbHHevFX9BhV2pimX1N88SBmoSmjL8ng1mt8lAmuSY9fafkbQjiIGRl6PFu5NWNT5E6TdL/SZe7JP2TU768u0I9fsxMhF+Ir23l0WqMxrsj/0TLl+s+hjUujrZ5rqAbIF2/uxbS8y+6++qQMDW0L8kg97q7jDayedo/kjDxdotMyl2EzMF6xvpt4ApVEQ50y2Gu4cZk7cvgPVdhWyPITNwoeHo+M6ZuxWK2knutLjRjz3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Do not disable bus mastering on outgoing preserved devices during
pci_device_shutdown() for kexec.

Preserved devices must be allowed to perform memory transactions during
a Live Update to minimize downtime and ensure continuous operation.
Clearing the bus mastering bit would prevent these devices from issuing
any memory requests while the new kernel boots.

Because bridges upstream of preserved endpoint devices are also
automatically preserved, this change also avoids clearing bus mastering
on them. This is critical because clearing bus mastering on an upstream
bridge prevents the bridge from forwarding memory requests upstream (i.e.
it would prevent the endpoint device from accessing system RAM and doing
peer-to-peer transactions with devices not downstream of the bridge).

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c |  4 ++++
 drivers/pci/liveupdate.h | 12 ++++++++++++
 drivers/pci/pci-driver.c | 31 ++++++++++++++++++++++---------
 3 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 825166a57913..6c4b57d8f780 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -136,6 +136,10 @@
  *  * The PCI core inherits ARI Forwarding Enable on all bridges with downstream
  *    preserved devices to ensure that all preserved devices on the bridge's
  *    secondary bus are addressable after the Live Update.
+ *
+ *  * The PCI core does not disable bus mastering on outgoing preserved devices
+ *    during kexec. This allows preserved devices to issue memory transactions
+ *    throughout the Live Update.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
index 30deaa673efe..8ad404307a70 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -18,6 +18,13 @@ bool pci_liveupdate_inherit_buses(void);
 void pci_liveupdate_init_acs(struct pci_dev *dev);
 bool pci_liveupdate_inherit_acs(struct pci_dev *dev);
 bool pci_liveupdate_inherit_ari(struct pci_dev *dev);
+
+static inline bool pci_liveupdate_is_outgoing(struct pci_dev *dev)
+{
+	guard(read_lock)(&dev->liveupdate.lock);
+	pci_WARN_ONCE(dev, !dev->liveupdate.frozen, "Preservation status is unstable!\n");
+	return dev->liveupdate.outgoing;
+}
 #else
 static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
 {
@@ -49,6 +56,11 @@ static inline bool pci_liveupdate_inherit_ari(struct pci_dev *dev)
 {
 	return false;
 }
+
+static inline bool pci_liveupdate_is_outgoing(struct pci_dev *dev)
+{
+	return false;
+}
 #endif
 
 #endif /* DRIVERS_PCI_LIVEUPDATE_H */
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index f7a5e65a7c75..b6c931ebd3be 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -532,6 +532,27 @@ static void pci_device_remove(struct device *dev)
 	pci_dev_put(pci_dev);
 }
 
+/*
+ * Disable bus mastering on the device so that it does not perform memory
+ * transactions during kexec.
+ *
+ * Don't touch devices that are being preserved across kexec for Live
+ * Update or that are in D3cold or unknown states.
+ */
+static void pci_clear_master_for_shutdown(struct pci_dev *pci_dev)
+{
+	if (!kexec_in_progress)
+		return;
+
+	if (pci_liveupdate_is_outgoing(pci_dev))
+		return;
+
+	if (pci_dev->current_state > PCI_D3hot)
+		return;
+
+	pci_clear_master(pci_dev);
+}
+
 static void pci_device_shutdown(struct device *dev)
 {
 	struct pci_dev *pci_dev = to_pci_dev(dev);
@@ -543,15 +564,7 @@ static void pci_device_shutdown(struct device *dev)
 	if (drv && drv->shutdown)
 		drv->shutdown(pci_dev);
 
-	/*
-	 * If this is a kexec reboot, turn off Bus Master bit on the
-	 * device to tell it to not continue to do DMA. Don't touch
-	 * devices in D3cold or unknown states.
-	 * If it is not a kexec reboot, firmware will hit the PCI
-	 * devices with big hammer and stop their DMA any way.
-	 */
-	if (kexec_in_progress && (pci_dev->current_state <= PCI_D3hot))
-		pci_clear_master(pci_dev);
+	pci_clear_master_for_shutdown(pci_dev);
 }
 
 #ifdef CONFIG_PM_SLEEP
-- 
2.54.0.563.g4f69b47b94-goog


