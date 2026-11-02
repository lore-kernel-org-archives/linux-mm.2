Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1D5960A8C02
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=EML+UahA
Received: by kanga.kvack.org (Postfix)
	id 9280C6B064C; Mon,  2 Nov 2026 10:37:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D8476B064E; Mon,  2 Nov 2026 10:37:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72E106B064C; Mon,  2 Nov 2026 10:37:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C6966B064C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:37:18 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D10C6160156
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:17 +0000 (UTC)
X-FDA: 85390582914.16.00B12B2
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf05.hostedemail.com (Postfix) with ESMTP id 186FB10000E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=EML+UahA;
	spf=pass (imf05.hostedemail.com: domain of 3Kq7oagcKCIc6t0ty3srzzrwp.nzxwty58-xxv6lnv.z2r@flex--vipinsh.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3Kq7oagcKCIc6t0ty3srzzrwp.nzxwty58-xxv6lnv.z2r@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633836;
	b=RenDFjZjy3IHrKoNcY+Cgmy8kz2iuSOhHrX9hRPUU4ctY3j8g62W9AUIkV35GRCENVDHny
	CzvLcKPRmKS0EiJOsnXfNI+S9rQj21BXhOzw+qWXwdtBlL6RUDtiBr5t2OEZy9sHVgbl1X
	xNsC0KFqKzWFeBN0ifmmLdavYFkIi08=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=EML+UahA;
	spf=pass (imf05.hostedemail.com: domain of 3Kq7oagcKCIc6t0ty3srzzrwp.nzxwty58-xxv6lnv.z2r@flex--vipinsh.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3Kq7oagcKCIc6t0ty3srzzrwp.nzxwty58-xxv6lnv.z2r@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7oNMxFcokvWOq1vpjD6EaSwY983MmsMnjeXj/vNf0HQ=;
	b=BeCjElVRV4N4JU7/iAOFkGgxkDSRM2gp6yIbUKO2EchGsAeLpXKaQan0WyEiutlMhIwI7M
	vYgWNfuNcz1sbYFSS7p8TPr/oKmDyLmd3XP0rofi7s7Gr+P/LI8zuud0h/BC4jOSBm12/i
	yQBtu61h3n3PA3QTgmGj5BTJHDQf93Q=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e869e00005so49837535ad.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633835; x=1794238635; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7oNMxFcokvWOq1vpjD6EaSwY983MmsMnjeXj/vNf0HQ=;
        b=EML+UahAwdJowfAcTcPuezGMadGaGVEN6T9Iq56eRwYjDda1k5pdStLP+REDxSOtfG
         l6H5Yb0mGK4s3KVazFfCr8MxztX9rEb2kWYiNf8d4o5KQ0TzOX3fN1x0xkV/8Z98QlZm
         34sT9t3WFLux+i2VVcmYZE4LxhpDb8h1YhHDmkdsKsOE6Gd4YXDdKgaLXGkOBncGBtyE
         MaQ5htFXAVeRJ6iJFnAc0ga2MMwt2FxPBfBXRd5SAk02aX0fqwbjvJ9cCVtiOsq7JJUx
         A9AMnEbeUBLyp7SQmxLbQsM+wHk0INnSqRNj1l4PFYx1JSDhJgbN8CQTwbGGUiiaM7HL
         2HPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633835; x=1794238635;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7oNMxFcokvWOq1vpjD6EaSwY983MmsMnjeXj/vNf0HQ=;
        b=QO+eKUKjy9kNeML94MlOK2FXz+7nZ+azQft39bgx4epC+s6dSjoVOGBUxH3WFpQm2P
         qVZnVGvtUXyzRfTwN2SOJ+HZJJe+zhP6fDxi2L8KlrDDKTj/R7J5Dh7NCRopJ7KhPRlM
         dnCrMwaGlkWjkvFUGxtO5shBk3pyFan4XJNiHtsNqNGYqPzobJVC5TycuLlAzcbPolKC
         Bw9N1qZdMn1+4nvQFEtvO9Q5XhMNLYdtmkNaVLyk4Sm3yDqT3KAWI1F6jOnAJwJaNbwf
         QiA9kKtU48ykELJonG4ryznrH2a5g9OwHAoI30B8l6GfcM1n8igBVbr663ER1IDU/rjA
         8rOQ==
X-Forwarded-Encrypted: i=1; AKwUvByXjj/jZVpjhgoxnR9pVVQSTIyTZZ2fVdMC1jAwEabizL8ZNCcCbnSCSA56+Y5L/1nlBd8pEG/mvw==@kvack.org
X-Gm-Message-State: APuU4Z+5cehl6TgysOY7P+jvFELr9lDG2bIJ0PugeGmDMqXDCwcu67Fo
	8l/W/PUkXxBOnglVGsRm5mUTjdXPAGuimtJWbPcjQ7Gncwuw+ksItTv6HHDAsaILMFjuEybnKxy
	wiCHxPNP4uw==
X-Received: from plbkn5.prod.google.com ([2002:a17:903:785:b0:2e9:6e08:e249])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:390d:b0:2e2:dd98:59e8
 with SMTP id d9443c01a7336-2eb36395c06mr94444135ad.3.1793633834806; Mon, 02
 Nov 2026 07:37:14 -0800 (PST)
Date: Mon,  2 Nov 2026 07:36:43 -0800
In-Reply-To: <20261102153656.1431701-1-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261102153656.1431701-1-vipinsh@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102153656.1431701-15-vipinsh@google.com>
Subject: [PATCH v6 14/27] vfio/pci: Take over preserved devices without
 resetting them
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rdunlap@infradead.org, rientjes@google.com, 
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com, 
	schnelle@linux.ibm.com, skhan@linuxfoundation.org, skhawaja@google.com, 
	vipinsh@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, 
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 186FB10000E
X-Stat-Signature: urjxdutgnfnb4pyt676n5qjnhyma7x53
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793633835-261186
X-HE-Meta: U2FsdGVkX18bfI4/YOXvMaEoOl5A4SCv/wgNvxVSoKBacRHzrUfw0MHJ2JOy09a5ExTWY/0muWv8m2ec+Fx8Y1kY8AKXFAD5cu9UHQ3oIYnvI3XamPD8jCgEidLheggNRlr7/DyiUiq71phtX1w6gsnUQPvB7e9ILjA5ouAUNje6FSZb+BfTwhW3sL60wzPXl0PBPXxaui4Ss6rOHi8d4g+b2Bhun1FoISW7OlL3kEJEAOhx5OOhyxPl0bNr4zsthzDhtFsPYeHc4SEDqq8+w/4SEBEu4o5JpOXfFChKoIiQetnm+tWsaS+U2eomO3kzKPY5iYpIxRZPzK8C1DAnoMmKbCeDR1mue2vNzy/QhWsJdAddzRizVWuoLgofCf084Snw0IDQRPyMH74jAAsaNGWkcaFA7ikJSNJ6qmA/DFJOKK8UZoocfCRSDGADItb9nF0J5/joR5TeyONF+feedHcd1qoTjg3Oi0Advr7ktXLfDEME4GiVVYCdPdRtn0BqUUgxqqsHyweGcefHhN/aFj1PwxMUpD/wtvD9JPvlzjlrebhDpSXq3Vc9XAXMPhyx8C/8baRpek+sCqdojL9N4FWXAPHWThL6wCNS3O8ZYCLi8UT/MIqWzqT2ICKeQt0YnMQivoSpVo7WN4wQy423evO6tevukIgtrcVohcdYuK/l7bOxzXMB8dhD6buckfCfQE4ZQFJbTiZuNLRskbRtO8Nfb46tfNruJyqeBjDfuDETpUEr54LIzuP8Qta/gHkVCKJNUmXElwBpk7QLvsxpypyPTdohrnq9Wl3a5gU43zdLBXEbVZIm0qZL/MNES70B8KbuYdHsqHri9TToVMhfz0qWHH3/z3RbJ1/YsxpsppzmXznFqsmyIVa6q7k7gmwKG2+RlbboY1CNNoSVw0/5IxmLh0qtWZvisluIWcsNxZ1ZwdrbCQcBZcBe8K3GeNts8wGagsaPn15FtDkBvhR
 kfjMPSyj
 yU3aDkvvIBHx7yR0cMgXNHORAuUr2kh45Z0bwDV1atvePf2N8DivRiRSdCcT4AJtv2S2rRzr0/xbPOgjNXXxS1a1ys+PAhnT3sPHLNIIvrKeEniB+Vgfk7LyO/ME1/3VDQbPyDdyVd2ZO0Jgs/UlMvbX4JHiQVI0B2K13XYJRhjjLbFaNWSSo+gywR4RN+OckJx5ZlFHucbvomXLlBhP+EjDxwOTl9h5drXK3dyVYto4ndA1VEcwvxX4xbec46thoMWsF66YJHbcxYZ0/zWTAS3N0bq4m4o+/bk1Ggr0NY/KVJF2vBY95Wi2bpJV/sq6JFrmJDcmb4S3XwGAHv5l96o3Vup18AqpvmX7BxDMIyNcDW1XQ9TqSQhYdDEJxHnVfK0JjjrKa+Wk3VMaGNegKxZIoT/+tJxs3myeb32rv51bj4OInVaFlelOLieLtP+In9SJcwXjyjget4cTznSr6yt/KfjHiLdN9NfWhmFEFP5rEra1XLxLiMWBO+CDe9qi+QHWzriMzCr9ZCsRL3CW1sjFHbjoqRgekU/kdjmO42A83CN6Cndq9OVd4At9YvSAmOamPTCdh9d9PBIdv6z7RV5x9IiGDBhrVszKU6wj53jOwOYs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When userspace binds a retrieved VFIO cdev file descriptor via
VFIO_DEVICE_BIND_IOMMUFD after kexec, take over the running device in
vfio_pci_core_enable() via vfio_pci_liveupdate_take_over() without
resetting it or clearing bus mastering:

- Skip pci_clear_master(), pci_try_reset_function(), and
  pci_save_state().
- Save PCI_COMMAND before pci_enable_device() and restore the memory and
  I/O decode bits afterwards so pci_enable_device() does not re-enable
  BAR decode (such as I/O port decode) that was disabled before kexec.
- Also restore PCI_COMMAND_INTX_DISABLE, which freeze() set before
  kexec, when vfio-pci uses PCI 2.3 INTx masking for the device
  (vdev->pci_2_3) or masks its broken INTx (vdev->nointx), so INTx stays
  masked until userspace configures interrupts. Otherwise vfio-pci masks
  INTx at the interrupt controller (e.g. with vfio_pci.nointxmask=1), so
  leave DisINTx cleared by pci_enable_device() as a normal open does.
- Build pci_config_map via vfio_config_init(), verify that it matches
  the preserved config map snapshot, and overlay the preserved vconfig
  snapshot onto vdev->vconfig.
- Perform all fallible take-over setup before adopting the preserved
  state. If take-over fails before the device is claimed, leave the
  running device untouched (keeping bus mastering, decode bits, and
  liveupdate_incoming intact) so userspace can retry binding the
  retrieved FD or let the session finish/close reset the unclaimed
  device.
- Once vfio_pci_liveupdate_take_over() succeeds, adopt the preserved
  pci_saved_state and reset_works flag, clear liveupdate_kept_running,
  and free the temporary incoming state; any subsequent error or final
  device close follows the normal vfio_pci_core_disable() path and
  resets the device.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 drivers/vfio/pci/vfio_pci_core.c       | 117 +++++++++++++++++++++----
 drivers/vfio/pci/vfio_pci_liveupdate.c |  23 ++++-
 drivers/vfio/pci/vfio_pci_priv.h       |  23 ++++-
 3 files changed, 141 insertions(+), 22 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 828d620cf836..63f484c0654c 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -595,8 +595,68 @@ static const struct dev_pm_ops vfio_pci_core_pm_ops = {
 			   NULL)
 };
 
+/*
+ * Take over a device that was kept running across a Live Update. The device
+ * is enabled only after every step that can fail, because unwinding with
+ * pci_disable_device() would clear bus mastering on the running device. A
+ * failed take-over thus leaves the device untouched and can be retried.
+ */
+static int vfio_pci_liveupdate_take_over(struct vfio_pci_core_device *vdev,
+					 struct vfio_pci_liveupdate_incoming *in)
+{
+	const u8 *vconfig = in->data;
+	const u8 *config_map = in->data + in->cfg_size;
+	struct pci_dev *pdev = vdev->pdev;
+	u16 orig, cmd, keep;
+	int ret;
+
+	if (in->cfg_size != pdev->cfg_size ||
+	    memcmp(config_map, vdev->pci_config_map, in->cfg_size)) {
+		pci_warn(pdev,
+			 "Config map mismatch during Live Update take-over\n");
+		return -EINVAL;
+	}
+
+	pci_read_config_word(pdev, PCI_COMMAND, &orig);
+	ret = pci_enable_device(pdev);
+
+	/*
+	 * pci_enable_device() enables memory and I/O decode for all assigned
+	 * BARs and clears PCI_COMMAND_INTX_DISABLE. Restore the decode settings
+	 * the device was running with and keep INTx masked, as freeze() left
+	 * it, until userspace configures interrupts. If vfio-pci does not use
+	 * PCI 2.3 INTx masking for the device, it masks INTx at the interrupt
+	 * controller instead, so leave PCI_COMMAND_INTX_DISABLE as a normal
+	 * open does. If enabling failed, restore everything.
+	 */
+	keep = PCI_COMMAND_IO | PCI_COMMAND_MEMORY;
+	if (ret || vdev->pci_2_3 || vdev->nointx)
+		keep |= PCI_COMMAND_INTX_DISABLE;
+	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
+	if ((cmd ^ orig) & keep)
+		pci_write_config_word(pdev, PCI_COMMAND,
+				      (cmd & ~keep) | (orig & keep));
+	if (ret)
+		return ret;
+
+	memcpy(vdev->vconfig, vconfig, in->cfg_size);
+	/*
+	 * Redo the virtual BAR fixup: the snapshot may hold a BAR sizing write
+	 * not fixed up yet, or a fixup half done by a config read racing with
+	 * freeze(), as config reads do not take vdev->igate.
+	 */
+	vdev->bardirty = true;
+	cmd = le16_to_cpu(*(__le16 *)&vdev->vconfig[PCI_COMMAND]);
+	vdev->virq_disabled = !!(cmd & PCI_COMMAND_INTX_DISABLE);
+	vdev->reset_works = in->reset_works;
+
+	return 0;
+}
+
 int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 {
+	struct vfio_pci_liveupdate_incoming *in =
+		vfio_pci_liveupdate_incoming(vdev);
 	struct pci_dev *pdev = vdev->pdev;
 	int ret;
 	u16 cmd;
@@ -608,23 +668,30 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 			return ret;
 	}
 
-	/* Don't allow our initial saved state to include busmaster */
-	pci_clear_master(pdev);
+	/*
+	 * A device kept running across a Live Update is enabled later, without
+	 * a reset, by vfio_pci_liveupdate_take_over().
+	 */
+	if (!in) {
+		/* Don't allow our initial saved state to include busmaster */
+		pci_clear_master(pdev);
 
-	ret = pci_enable_device(pdev);
-	if (ret)
-		goto out_power;
+		ret = pci_enable_device(pdev);
+		if (ret)
+			goto out_power;
 
-	/* If reset fails because of the device lock, fail this path entirely */
-	ret = pci_try_reset_function(pdev);
-	if (ret == -EAGAIN)
-		goto out_disable_device;
+		/* If reset fails because of the device lock, fail this path entirely */
+		ret = pci_try_reset_function(pdev);
+		if (ret == -EAGAIN)
+			goto out_disable_device;
 
-	vdev->reset_works = !ret;
-	pci_save_state(pdev);
-	vdev->pci_saved_state = pci_store_saved_state(pdev);
-	if (!vdev->pci_saved_state)
-		pci_dbg(pdev, "%s: Couldn't store saved state\n", __func__);
+		vdev->reset_works = !ret;
+		pci_save_state(pdev);
+		vdev->pci_saved_state = pci_store_saved_state(pdev);
+		if (!vdev->pci_saved_state)
+			pci_dbg(pdev, "%s: Couldn't store saved state\n",
+				__func__);
+	}
 
 	if (likely(!vdev->nointxmask)) {
 		if (vfio_pci_nointx(pdev)) {
@@ -635,10 +702,12 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 			vdev->pci_2_3 = pci_intx_mask_supported(pdev);
 	}
 
-	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
-	if (vdev->pci_2_3 && (cmd & PCI_COMMAND_INTX_DISABLE)) {
-		cmd &= ~PCI_COMMAND_INTX_DISABLE;
-		pci_write_config_word(pdev, PCI_COMMAND, cmd);
+	if (!in) {
+		pci_read_config_word(pdev, PCI_COMMAND, &cmd);
+		if (vdev->pci_2_3 && (cmd & PCI_COMMAND_INTX_DISABLE)) {
+			cmd &= ~PCI_COMMAND_INTX_DISABLE;
+			pci_write_config_word(pdev, PCI_COMMAND, cmd);
+		}
 	}
 
 	ret = vfio_pci_zdev_open_device(vdev);
@@ -649,6 +718,12 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 	if (ret)
 		goto out_free_zdev;
 
+	if (in) {
+		ret = vfio_pci_liveupdate_take_over(vdev, in);
+		if (ret)
+			goto out_free_config;
+	}
+
 	msix_pos = pdev->msix_cap;
 	if (msix_pos) {
 		u16 flags;
@@ -675,13 +750,17 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 
 	return 0;
 
+out_free_config:
+	vfio_config_free(vdev);
 out_free_zdev:
 	vfio_pci_zdev_close_device(vdev);
 out_free_state:
 	kfree(vdev->pci_saved_state);
 	vdev->pci_saved_state = NULL;
 out_disable_device:
-	pci_disable_device(pdev);
+	/* A take-over enables the device only once nothing can fail. */
+	if (!in)
+		pci_disable_device(pdev);
 out_power:
 	if (!vdev->disable_idle_d3)
 		pm_runtime_put(&pdev->dev);
diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
index ad757acac400..00c008117259 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -120,7 +120,28 @@
  *
  * ``LIVEUPDATE_SESSION_RETRIEVE_FD`` validates the handed-over serialized state
  * and returns a new unbound VFIO cdev file descriptor. The device is claimed on
- * the first ``VFIO_DEVICE_BIND_IOMMUFD`` on that file descriptor.
+ * the first ``VFIO_DEVICE_BIND_IOMMUFD`` on that file descriptor without
+ * resetting it or clearing ``PCI_COMMAND_MASTER``:
+ *
+ *  * ``vfio_pci_core_enable()`` skips ``pci_clear_master()``,
+ *    ``pci_try_reset_function()``, and ``pci_save_state()``. It builds
+ *    ``pci_config_map`` normally via ``vfio_config_init()`` and verifies that
+ *    it matches the preserved snapshot before it enables the device. It keeps
+ *    the memory and I/O decode settings and ``PCI_COMMAND_MASTER`` the device
+ *    was running with, and keeps physical INTx masked until userspace
+ *    configures interrupts. On devices for which vfio-pci does not use PCI
+ *    2.3 INTx masking (e.g. with ``vfio_pci.nointxmask=1``), vfio-pci masks
+ *    INTx at the interrupt controller, so ``PCI_COMMAND_INTX_DISABLE`` is left
+ *    as on a normal open. It then overlays the preserved ``vconfig`` snapshot
+ *    and adopts the preserved ``pci_saved_state`` and ``reset_works`` flag for
+ *    subsequent resets or device close.
+ *
+ *  * If the take-over in ``vfio_pci_core_enable()`` fails,
+ *    ``VFIO_DEVICE_BIND_IOMMUFD`` fails and leaves the device running
+ *    untouched, and userspace can retry the bind. If the ioctl fails after
+ *    the device was claimed, it closes the device, which resets it like any
+ *    other close. A device that is never claimed is reset when the session
+ *    is finished or closed, as described below.
  *
  * ``LIVEUPDATE_SESSION_FINISH`` (or closing a retrieved session file
  * descriptor) always completes:
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 39ea26402312..2549a5321fce 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -203,6 +203,12 @@ vfio_pci_liveupdate_check_noiommu(struct vfio_pci_core_device *vdev)
 	}
 }
 
+static inline struct vfio_pci_liveupdate_incoming *
+vfio_pci_liveupdate_incoming(struct vfio_pci_core_device *vdev)
+{
+	return vdev->liveupdate_incoming;
+}
+
 static inline void
 vfio_pci_liveupdate_free_incoming(struct vfio_pci_core_device *vdev)
 {
@@ -219,6 +225,8 @@ vfio_pci_liveupdate_free_incoming(struct vfio_pci_core_device *vdev)
 static inline void
 vfio_pci_liveupdate_claim_incoming(struct vfio_pci_core_device *vdev)
 {
+	struct vfio_pci_liveupdate_incoming *in = vdev->liveupdate_incoming;
+
 	/*
 	 * A reset that finish() left for unbind is not needed once the device
 	 * is opened after finish(): the open resets the device if it can, and
@@ -226,10 +234,15 @@ vfio_pci_liveupdate_claim_incoming(struct vfio_pci_core_device *vdev)
 	 */
 	vdev->liveupdate_reset_pending = false;
 
-	if (!vdev->liveupdate_incoming)
+	if (!in)
 		return;
 
-	vfio_pci_liveupdate_free_incoming(vdev);
+	vdev->pci_saved_state = in->saved_state;
+	if (!vdev->pci_saved_state)
+		pci_dbg(vdev->pdev, "%s: Couldn't store saved state\n",
+			__func__);
+	kfree(in);
+	vdev->liveupdate_incoming = NULL;
 	vdev->liveupdate_kept_running = false;
 }
 
@@ -288,6 +301,12 @@ vfio_pci_liveupdate_check_noiommu(struct vfio_pci_core_device *vdev)
 {
 }
 
+static inline struct vfio_pci_liveupdate_incoming *
+vfio_pci_liveupdate_incoming(struct vfio_pci_core_device *vdev)
+{
+	return NULL;
+}
+
 static inline void
 vfio_pci_liveupdate_free_incoming(struct vfio_pci_core_device *vdev)
 {
-- 
2.56.0.317.g454f8302e1-goog


