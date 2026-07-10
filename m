Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 347A9C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D40D06B00C1; Fri, 10 Jul 2026 17:26:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D18A86B00C2; Fri, 10 Jul 2026 17:26:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBEA56B00C3; Fri, 10 Jul 2026 17:26:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 86DB46B00C1
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:26:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 078961205AF
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:35 +0000 (UTC)
X-FDA: 84974151150.05.9D00F60
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4396840004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YzgcEK+K;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3h2NRaggKCOwRaOhZOQYUccUZS.QcaZWbil-aaYjOQY.cfU@flex--dmatlack.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3h2NRaggKCOwRaOhZOQYUccUZS.QcaZWbil-aaYjOQY.cfU@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783718793;
	b=PmHtdFc8Iq5+ByU1c7lHVbIhh1nXOoxs0/IKvlprZ0XC9C6uPlFoj77mpYWsOkda5jAijW
	/FMfLV6AbDv/cD5H+aaE4Zx0azanLoJXXQNyV6NPXmEJvgea65dPuUxrQ89H9qYEBndGmk
	WGgOuEXkwmKt53+revtrVLWOESEjDwQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YzgcEK+K;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 3h2NRaggKCOwRaOhZOQYUccUZS.QcaZWbil-aaYjOQY.cfU@flex--dmatlack.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3h2NRaggKCOwRaOhZOQYUccUZS.QcaZWbil-aaYjOQY.cfU@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783718793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kC0I5yGr+D5g0K5ia+KYUwEESYLYNJwODX2HQMDkX0U=;
	b=S9i7g4EEGc2C2md7Q51CXva8QqCZQeev5nU/xk5JfGXJ1qYraDNKvuuSdwyxYVGm84s+AC
	AwiecMwE+xpcm4/Cg0gPdQa4qJWzlJAuk8hqkb1Jql3z9Xn2zt9VAchhov503XPTwRgNrF
	CN1DeX+lxb3CYYFaMdu20GUMIVYZyUY=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8486389f71cso1668674b3a.3
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783718792; x=1784323592; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kC0I5yGr+D5g0K5ia+KYUwEESYLYNJwODX2HQMDkX0U=;
        b=YzgcEK+Kl1of/PqcCkyV4RVHQkmiuwTqfttzXuw10yPjTlZCYbTdK+FpBrQZ40p+vD
         /XHxoS73iQMmTsZ/Nyzx2n1izxLnUO7AWHaLCNEOnlSEcx+oXVW/5VyfSQ25cZ+k2xAF
         S5GltT0ten+xxK+I/6NpgEIbNnew5C6+4GdaPOVgHwm5TPZqlgiFU5k0dldF8iLaMMpC
         zaxJuB0N4XR8FqGvMB96pJ3z7Fi0v0wWfKfEcHy4dtgmE+oXhA9SObXA3U4xu+BIFS6N
         f9wO0tO46k0X+LOvj3TtftL+v1i5pL+HxU6lx+KmASglHZq1QN7oLPZeiHRuz3fPNdoM
         uwmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718792; x=1784323592;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kC0I5yGr+D5g0K5ia+KYUwEESYLYNJwODX2HQMDkX0U=;
        b=kJTmDTZ4b5Niwsx0VNMB5c56CImwYucH0tMDKc3lzNxKygjsBHgtctFatEaWF5PySO
         sl8F3u9OPueiIXRjq92OcCok4OGgURWc5o3qhfGFtvu1br5TT9gb2x3MwctlIOyjsVxW
         HGZ7BSUJuAOIqVKVQvephiTHQ3qtDNyaeOpr8qAhIah7MTDitZM4GhSXVQ3g1Fno391Q
         GnE6H8ajC2qSGJCKl4+4DpzcTMU5TvgwrkqQ+WZtDbLxHztYB/TzciUilm2ondd751xy
         f9fWHdzdZkU9raKh6O8AccoSqSDJK3Ia5l7QUMzXjKlNBssa4Fti+wKnEhs7gv/a5rtn
         3Rxw==
X-Forwarded-Encrypted: i=1; AHgh+Rr/SYIYwW81+ye2/lXd6OGWdfCvysl3r9FlMNCFNvgeA+9iJ9EeBaouczkjiC9MJ4XomboXGd1W4A==@kvack.org
X-Gm-Message-State: AOJu0YxAAoubI3U8a5LMkSm/gLPnc3D1+s2zulthBGf2W8ywrgaK8WGi
	ozXzsA2uaL/VxV4GAoJQAj+IiACyyXIjAGcnnkurTUWF0qfjmhCcmJcTYEDNmrLWQudMInvKCwU
	YLUbiHNRePFNjpg==
X-Received: from pfcs28.prod.google.com ([2002:a05:6a00:6fdc:b0:847:8189:3c6c])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:14ce:b0:848:2f73:8ff6 with SMTP id d2e1a72fcca58-84889770231mr613896b3a.63.1783718791956;
 Fri, 10 Jul 2026 14:26:31 -0700 (PDT)
Date: Fri, 10 Jul 2026 21:26:14 +0000
In-Reply-To: <20260710212616.1351130-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260710212616.1351130-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260710212616.1351130-12-dmatlack@google.com>
Subject: [PATCH v7 11/12] PCI: liveupdate: Do not disable bus mastering on
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
X-Rspamd-Queue-Id: 4396840004
X-Rspam-User: 
X-Stat-Signature: 813pq84zpohyex7o5xskur9kt6a3pyku
X-Rspamd-Server: rspam03
X-HE-Tag: 1783718793-885238
X-HE-Meta: U2FsdGVkX18F2dHxZy4m8KadD3wV6EIk8NQzkGQBXsMqopCiQNikioTf7g8odt9ZYM9DmDRO+EQUp+GLeYJpued4hIGXPdl0dUW559P08DTZ9j16n0IBTXSfdhUXJEZfljt05Nihk2JmK/TIatIxOW2bggkaHSA2wt6vYqs19TzkHhlTiYd6N5PIe33yiq6camT06IWDpBWA7strSMk96SLcGCAd5QC0y5ZYzp0DGNHmEXFd+JUmdFirL10QUo85cnUBNEmsl+0+cUdp2dX26LG5kgtz3ytkiVNSs0vYW4DCaigfERsBUl2yPH49FkhFYJk6f113f0kEYc/bmPOoj4YOfbWdNixRUb0ZWyyTQnAxNMi04twW4oflbxs2zdBOASJo0JBW72fC0okHPIZWTTaFXlr/gd/xOrx9GmFF8hqCj4gV7XGYZVZ3a8SBo18Xz7mKS11cn4mUlZduoGKJOZUSMU0DVswQBBFlHXwk6l0L7HnkBKg9vCK0HD7FBBlFUBLdaxf4HBxGbYaapnTGFH2qAdoAOcIthJCMmbWtJlkWh8bNUQDpu4Qwqfr8hxWgofhp8KSaznDgv4jXp5vJr9BCE433ZmTf5r2MYHcpekb8c3MR762ofNbYorBZQtpITm1Mp57G7tzdrJRipTl0MBJsfUjc2atzaIajTNQOjnF1/vhpZG28uF7ScRjP+w/X7fr23OxznBioPYxpuO08OSrJk+LB0zlCAyRIcxxFIoP8nlWFRTGVPn/0VmGMLeudKmxFfVZ4FaopYMtXwDsQ//OqbcaFJb0nmMS/kgGGV5E8mHXmwM8K6gWHPE5ZHYTCE7ilyRu80eAdijXHMNvZ/owcNi7m3RrYAYT2GCmrIL4YRh9vizW6NcJC5AkjaQF/yrbTFvmehsRUsesArx+SeMe+mtOmBPB+usCR8S7hHSXjkReHivuv2ymdrvNR0GWxvIHzztVYZsNrhxI9/AQ
 IsaM2MGL
 zljmBdpQNuUgLqANsPETN2biVGor4TAX/Uddgg6iZkxdIzk3Os8rk90Rp4uOvCNccADADCMm4MBSITEEoN5fCi0dITUiyW6Hc9hpZetjIWL/D1gvAHQxuFMIT0AveQD4aNx4sr6/hWvZL8z8+wXGinwAW3jD99OJnnXVnr1+uBcdt4TZuWDNFoBz6NafkiOZ3KFOw+jJ1I/YDazHSTZglNxrePvdsALwxRyu1m3r0ed23/tuYi4v6eVpGpvyQ97MhOO1bg4rzmYWEx88UMDJnxyorQG6pSWjVG+ljUy2dd1Ue4tgh34Q+YCgEPn3JRHhpNeKFv8yh9K+I5RoCocmR9Ws8lNNkS0vFRibgngUKTKGdrYc2EVQpfShz473y63G80ef4eRnp8MPP/7PNyzNy/MO+juDsUJ7AnvMxmwtJVYP/+E1onxgjsECXKcsv7Al8LDBKDaSP2JjqCqi/eG7VBfQkSeqEgfQ45b0MPsH1wYGaz1wT8gNE5vWwgtsEoMXMd9o41/oPSEbyyy3hdRd4j7MlK+dTc9PQQgTHOzK4WjI5LEKJmTcehp8Cfi6RhfCKURk+0EvgpbpzjF2kcoVHnt7697RBCW2XunPY
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
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c | 11 +++++++++++
 drivers/pci/liveupdate.h |  6 ++++++
 drivers/pci/pci-driver.c |  7 +++++--
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 64052892ea84..5935e88de073 100644
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
 
 #define pr_fmt(fmt) "PCI: " KBUILD_BASENAME ": " fmt
@@ -850,6 +854,13 @@ int pci_liveupdate_configure_ari(struct pci_dev *dev)
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
2.55.0.795.g602f6c329a-goog


