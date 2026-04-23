Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18D6EFDEE4D
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 21:23:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F9D46B009F; Thu, 23 Apr 2026 17:23:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A9F16B00A0; Thu, 23 Apr 2026 17:23:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 588606B00A1; Thu, 23 Apr 2026 17:23:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 430BF6B009F
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:23:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F40F040518
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:23:40 +0000 (UTC)
X-FDA: 84691097442.21.4FFB1C4
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf20.hostedemail.com (Postfix) with ESMTP id 286671C0008
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:23:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L63dESQs;
	spf=pass (imf20.hostedemail.com: domain of 32Y3qaQgKCPQZiWphWYgckkcha.Ykihejqt-iigrWYg.knc@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=32Y3qaQgKCPQZiWphWYgckkcha.Ykihejqt-iigrWYg.knc@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776979419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NDSmr3KzvFf45fqXLLacm4Nig+LS/n/kl38OHtIvfGo=;
	b=Qa6JFWVoss9hscJ2gK/syxLj8V4+/+uRHvZiRJlZlAifYx12pwoRlSMa77Ns1Ops9E5V8g
	kbP1omXg9yCZmGpXBvW5nvhtud6FIDnaoLE21uQ4xYpny1/2PLXqHNsH0V+CE76vreJcUM
	fagH3cXyt3oGSMmGHQTy1S2HvW1R42U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L63dESQs;
	spf=pass (imf20.hostedemail.com: domain of 32Y3qaQgKCPQZiWphWYgckkcha.Ykihejqt-iigrWYg.knc@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=32Y3qaQgKCPQZiWphWYgckkcha.Ykihejqt-iigrWYg.knc@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776979419; a=rsa-sha256;
	cv=none;
	b=w461hh0Sl5ypepw/GDIPjT+tJogf5N9yTY364aiUPsEwwHTvZeY+EF1swLFGBs1hImB8m/
	Ru/MMN9Rgd+3hYc4A1TjBgaEFYzIahe2SkjDTUQPATuHiU044GplxdtlN07S4YngVnUg/2
	xYPQ2iN2qgJ07YEn+s49nmwgFJW7DZ0=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2b24a00d12cso72920645ad.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776979418; x=1777584218; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NDSmr3KzvFf45fqXLLacm4Nig+LS/n/kl38OHtIvfGo=;
        b=L63dESQsWYEn01XZDhQKwfnmx72Z4jJUx5fTQSOsbAdZnz3Pf7arC91fD5TwrESWPq
         DyjMbtPeeOtFysf8RtP243MaEFszws7PhYKgqgltZh8u5W4qeIby58bXK7CZ9FS1coTK
         zs5JwIR5fowUgY5YX+fqrqZz/e2u6PfgA4/ETG7I+OWV9Qxjc2CF6boSxYODIMjt1Pj2
         XszIehBC+Y4uvljlRt2JtYGDhAWU1E2pRz8+tREaNKo2hfmBk4sdb25i7jG1YBLJDxXt
         cPWp1Df+9ysvkV2Lr/AZsuiukpY6r71dZse6IoY0k54oXb3cZ1nudVHvnhDcK7NTR9dh
         wr3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776979418; x=1777584218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NDSmr3KzvFf45fqXLLacm4Nig+LS/n/kl38OHtIvfGo=;
        b=NvWaKaufyVWbjhp/CiF7JLc0vAdedNt2mfatz8xADHfB4qEJPwWqDkxUrUg8VYoiIW
         kUhfsYtxV/eoT7CwaRjifQKBESF/Qx2VQDyuCyN1idvkE79RvvOwhl6hs3P7FkI/qH7Y
         KE+jgw5R3bOq1skjm54MePegMgigrQojdZhFdRpVLBx244FpJpUv08CJoXDh0BY82Yq6
         +TE2iXCYVrIg8+Q054H2GxjHUdoQP2+lDDnV219hSs2eK1RjCxviQsUqqfwzv8tko/Xv
         /I7/DavSa81azihHxFllGv74QtWBZIdVxohTHmKqENENnhNnU7DzT9YxIrW9YgoguNte
         CrmA==
X-Forwarded-Encrypted: i=1; AFNElJ8V0y5dampW/3dTqefQtuEeM+4AfMCjc5VIQpC91DZP6vpqxm8ZVEpiCis6XHR7HbdZ7MdAc9rkSQ==@kvack.org
X-Gm-Message-State: AOJu0YyFGJDAKw+qWCAuIz8reVmWeh/TaJfNTsU6gTjb0zFh079ui2p/
	1lf/hjD4CG1ffhTkrSxRs4ckf5CcQQpAyCI22p5CPIVOh9UOR+iYL+ggP3PAa3zq3jekKNucPgi
	5lRd5s4Bd7fCIwQ==
X-Received: from plov1.prod.google.com ([2002:a17:902:8d81:b0:2ae:c54f:d5ad])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ba94:b0:2b4:5c0d:314b with SMTP id d9443c01a7336-2b5f9f83342mr210260195ad.38.1776979417788;
 Thu, 23 Apr 2026 14:23:37 -0700 (PDT)
Date: Thu, 23 Apr 2026 21:23:14 +0000
In-Reply-To: <20260423212316.3431746-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260423212316.3431746-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423212316.3431746-11-dmatlack@google.com>
Subject: [PATCH v4 10/11] PCI: liveupdate: Do not disable bus mastering on
 preserved devices during kexec
From: David Matlack <dmatlack@google.com>
To: iommu@lists.linux.dev, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: fjqbwhpdfnnxiifsozqf5yzs4gee8s9j
X-Rspamd-Queue-Id: 286671C0008
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776979418-503691
X-HE-Meta: U2FsdGVkX1/oZSYNJki0gtBalff1EkbnhuBmY/L/D0d7y17/x67KVOHDdTYhGte/bImWySYLuHjR25/UAGfzcmsqxR+Y9YdavWOb5q1VyDo4w7iG26uC4bTICkCuY8BORl5YfsQbxFrQMgyOiSD1xDYd0EqU83ot9T329NF1GpPThSC735CrE5kTKbTiq0T4gpic+SwuPTK1vX0kqK7tfQiszWL2oSRw90Kt+s2iO4+QT004SWfgcAiGGFdY46TygXtuN5YkaHF6MN1vgDSsT8vFg8WszlSyf/CRAHYzs+QJq6HNGtjSiS4hCQ2fwoWSskRUDlw6tkScX/j49MOo+JpVNwGaTjaXVsXtN41Y0LBFb7BaDGr0zmudteLjqN54d1nlFzIQE6QhpAK2IeMl9dbxEI9PRFpnkyaI9jImIIjFNeD2jC1gxAtggnrdSPuNfjNaGvjMwCsJIM1Y+spqKfLJNPYf7Iwle3f4hGLqohLyPuVBOc1cO2KT3Ypyw1FPTnv12SwPmHEuLTVweyFfp96yBvJgt+qmPZBGFkAs2qcMmHBaBaRvaA/0m9VETnFqcu8GNbtI9mlg8jp0IQSX42UbEQhb+PgcS27/sQ61J1faei7HLgprVx51eUPSv37ruZCNcxW4Wnk2bpBdmlnYdOD9lXUx+sZJ+tAyWw6LVwK8yEsPpxMyhnuaO5SHMeVb3IApk1FL0m1iqafF5kYwWnpfG2Za1Q2iwY7jfo8vF/TH2xzu/GOMU3LyKXJ9ox4CJ3jV5pPOtgrbY32WxoxU6O7q36QH4y9pyDhWGnKE6uikYpmH7KkrL2mkkUFddgt4PZofj6PTSwaPDweKP2eQvoc2J8vTSGgOvCfnDqJQZVB0WKYJ5igjSY7xUJ45huHibBnPT7EJ3htXJLM5pE5i2OhA+MfTzIokDEs6ptmm2ZEV1VNI8N+aaZA9YN/t/ZBxR7bk/HROIjiZ5BW2Gse
 dTD8hscf
 ocZTDk0fVSjFSgdN0mtqKYK58FQ2ulPAf1dKAi7NKVrPMBxqKS1poZAZQbed1a5AEO3a5FDe1Ce9vAJG9r+QWYO6/7tI8WcLzPfOQEzEZ9A/DhX53NqyTxNw3wOKJVJzvSabUcJG1CrmZqpgWR4epvd/rxFS2E+PCiuhjn+Sx1UgbXB38AfwB7XypwoKytUL+6bsKU0PMNj9SWk9Pp2AWuWU1QJyU1Io0RWupSSDwRBreaiUnptInTioFEcFyL9Hept5X2yCBTPQBb1aM5Ju33u3IyPXlx6DqWTO04RUmcR0CYlsq8qau1BEj6Cz+l9FPkNbG5Q4U6HOPqMGPajnEf3fVyVA8eJOrw6GPs7bX2I+EkqHFPuF0Ze5NbK0XfeB2vl4XIv5Uq/tff9MxdJ+oSrvCqdQUYjb/0kSxw6JaqDoM53pd/ZIGB1ZryXhbi/qjl6w38FoM6VZsDIUfPiQbpDxnH4FzKVdWGD5v6Yb8wi/fkMD0oTyC4MS6ZH/xQS7apZuUM96iuD8GXdssew205vhPM/2EEJt0ZyRdMUd08uJGw76ufifB/BX9WzglqjvPrSUFbpAf62kKY+F7S7mnv/lwUf71VUnmw0h9b/WDw+BuFuTQRIH0RNa0g0XmpZr/5z52ff9WVzUEcB7BG3HjYoNtIQ==
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
 drivers/pci/pci-driver.c | 31 ++++++++++++++++++++++---------
 2 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 25c86cd4c173..2a4a139623a6 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -132,6 +132,10 @@
  *  * The PCI core inherits ARI Forwarding Enable on all bridges with downstream
  *    preserved devices to ensure that all preserved devices on the bridge's
  *    secondary bus are addressable after the Live Update.
+ *
+ *  * The PCI core does not disable bus mastering on outoing preserved devices
+ *    during kexec. This allows preserved devices to issue memory transactions
+ *    throughout the Live Update.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index d10ece0889f0..05584bc76332 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -531,6 +531,27 @@ static void pci_device_remove(struct device *dev)
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
+	if (pci_liveupdate_outgoing(pci_dev))
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
@@ -541,15 +562,7 @@ static void pci_device_shutdown(struct device *dev)
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
2.54.0.rc2.544.gc7ae2d5bb8-goog


