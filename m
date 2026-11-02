Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9EBA60A884F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=jS/9AkpQ
Received: by kanga.kvack.org (Postfix)
	id 94F206B0649; Mon,  2 Nov 2026 10:37:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FD0E6B064B; Mon,  2 Nov 2026 10:37:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72BAB6B064A; Mon,  2 Nov 2026 10:37:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3FF086B0647
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:37:15 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CB6B18018A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:14 +0000 (UTC)
X-FDA: 85390582788.17.095F43B
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1AE9180010
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="jS/9AkpQ";
	spf=pass (imf02.hostedemail.com: domain of 3J67oagcKCIQ3qxqv0powwotm.kwutqv25-uus3iks.wzo@flex--vipinsh.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3J67oagcKCIQ3qxqv0powwotm.kwutqv25-uus3iks.wzo@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d9AP9+h3Vm5Lv0UYDFXf9dAmgO6It2Nsi1syTC+DAOg=;
	b=B2sK6TDkTUueM/wF0V1AyLsyVBXMNDYNRFQRONjbJ8Fj2J+ZVDgKL8uS2NZxBtrfNx0Ert
	i8HEyt5u2997INagEWq8j8F3iwYZnAOgAqfsDw8tjoHfPq5oLv5Zqr3cPmbcOD1stj1NwT
	0SNy+eyptlfszeu/CU2GxjdhSo0lvbw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="jS/9AkpQ";
	spf=pass (imf02.hostedemail.com: domain of 3J67oagcKCIQ3qxqv0powwotm.kwutqv25-uus3iks.wzo@flex--vipinsh.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3J67oagcKCIQ3qxqv0powwotm.kwutqv25-uus3iks.wzo@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633833;
	b=av1/QC0j22HGW7C2h4Vt0N5gu82qvecgovtTKvimy+3TmIJpYlXdQxw2WhcbyPTse1v8ql
	2aWX59oz9Q2x41o+WXOwkNirqjpxzowacocZEM2aZwqlg9O+MtoIBWqbiGymy/2RRE+Qe+
	wrROpjPqRsLH4PkmRdyfwOj/umkf7qs=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e9d52f684fso31581735ad.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633832; x=1794238632; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d9AP9+h3Vm5Lv0UYDFXf9dAmgO6It2Nsi1syTC+DAOg=;
        b=jS/9AkpQ1Lu0L4lbdHWiqR6Hvqu8alKJmdN4OmgNobxSHEQbpcgUCUIofIxtKuOaUH
         HqGXw6uIO2DhEYRueb8FRO2naVz4jT0gzU3bWY0ZuhecboQ2XKqN/fHM6VauUYRqADF0
         HXHl8bC5QKy6jwS2lssn3DJluWNBeo/Zc12sJBVGRdozz/Izke/p/QTC7eYF9KqN9BEA
         v5Ew+444lnruouY7Lx0D2KM7Byou7nNe1Y4x+T3B+MTAWFNAscMKLou23slqq+xYJfmE
         Rj2WHtWT+aGHj1imZHPdCLvnYqFl08WV8c7rl6mRJljASpT4smJAKKHCa91ke35A9YsT
         2z4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633832; x=1794238632;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d9AP9+h3Vm5Lv0UYDFXf9dAmgO6It2Nsi1syTC+DAOg=;
        b=RLgTrHe+IE0B12hSqUEQ4A6eYsR2PAFLqb39VnkPt1a6B2YJpaX7hYvs2kMroA/+lW
         LB6QGNdzVxZ+2khI8iMWClUtakbH7z9rZuUsFYCoHPUu9VfGEfX27FWNygPdQF9u16Sv
         z8c+VE/rUq97bUW2BjL9CA6EcqC0/vp3Pwxywc1OvVBkox486YZP3u2vdehKUR463Zpd
         knRsWzP3J/PAUbPPoNAO2K3A4LXyGBsR1l80PJAs/m076leKzIDQCe8/UW/Gy7MLT+xq
         cUrNHqr4I8uN+jwEp2i5Ww/uJC16nomS+tIKcgD7PEz/2AdyNySvZsRGzhNIGb2zKJjr
         ztOw==
X-Forwarded-Encrypted: i=1; AKwUvBzKtycgkkkt0nmdFQCF5y7ngp9/nzHLDVgkeWzLjqibXVYlBpZlPlxJsmWgMTzc86NC9jOC/OX3Dg==@kvack.org
X-Gm-Message-State: APuU4Z/H59WMo5bbjeu3gumlLcW26liaYqkMh47U/GtQRFGDqspNMeRT
	NSjz6bBwcs1ZyVBqwXrubXSP2uv1Y+zHh8iMpIoMzYxDjsWnJEvIROKrM/hFXI/p1GtDfIzq61c
	3xvUN5tR20w==
X-Received: from pltm3.prod.google.com ([2002:a17:902:6bc3:b0:2e5:ffbf:77d8])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3c4e:b0:2e9:9c65:1af9
 with SMTP id d9443c01a7336-2eb364e8187mr97004705ad.53.1793633831668; Mon, 02
 Nov 2026 07:37:11 -0800 (PST)
Date: Mon,  2 Nov 2026 07:36:40 -0800
In-Reply-To: <20261102153656.1431701-1-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261102153656.1431701-1-vipinsh@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102153656.1431701-12-vipinsh@google.com>
Subject: [PATCH v6 11/27] vfio/pci: Retrieve preserved device files after Live Update
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1AE9180010
X-Stat-Signature: y8zq6jgb5rfepcbdj5ucdumfypjh5xyo
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793633832-586652
X-HE-Meta: U2FsdGVkX1+RUtvCN3aaHYl8kFPU/lVGJnTbdCtdi5SVoHR6bpaEbnVyOJiCX4n3g+MdTOaDAbaZUBb8Vv2+tR0ZXqWSvY7gMC7Nws3QHQbEK6dk0lqCMNsj4hsNAr2MwGJY4WPOW5ish9KL1u4mWfRMWK10OOwfBSF9OW9KnuUa2x1fqtCWAX5xD3Y03B31Wu2DTez4tcCtEMi/MpoV7bx1EjNCIgnRTVtukkY/X5OOXSTtVn4VMc22cSI36WBf8AUDNE4D7J0viA+A1wWq8sgf6W6RbIoZGXpvtjJV/0pNDRLoG4/70K+kTaOBOLBzdAoPQEjXsi2nyB5kwbdrZh9jD7U6C7gSG33GXIGiEoSJp51tiZ6zL9htjfcH9ZjGrNtZfjE0RInZYBBAxITuCIR0Y+QYh2nW7X9IxOv3XgiCSgfJtS0GrdnMtUjUZJRtsMNrnDcGGVESwhTQ0UOyIW5w8zyziPfXkmQMwRAGZIJ503uQ8ezgm4072GF6BhI5nA/fpYX9FZPwcp+1NoFDBT9PlnCbluKqjS8iAamstze4J35wXgrZvSf0X0cbFK/DO0xkhj2yEbcYx73xLSC+TUEADUcUv/aB4f5rQKbZG7ZJB+kdwO0U86xifaoGTw9KKDTyOHCGtERG3CHOMLlxHwSe6U7vzRukgckVrJO8BxYf6vINnoLo/UwTeEuOPaILNH8H87HgyfkYjwaTMzrRfkgS/FZk/6SPbvVcnBeXwagqZUSVyw6sbY5BU8pm2kA72FvtEDI4bILob2tE0d/cmpuhSCM4k0zRMDHwj3plR0taXXFoXyogJea+lPjfyY9RVYdJf+3SLdqZuSTibKrjAzXZ6Kk2EkX6vTCmy4nO4GiB569zR0qNdJSW0uYVNYDCuFNuJFEfxWX1+K18VMIy/NFRT/3OoDJ7u05ruV2EHh1FRYHCBWVNlJUcUmdmGDCZwdsqBE9drgF8RT2CrVZ
 WOicApnG
 ggsVmvM/61JKgcPzucJlfpiIlrQjgyTBeeY0RD61XZ382IwBQTImPPreyeOAVpH/77nt9ethklXQ9uQZiKYPSoYD/Xw48MjD8XGu8K4USlfJkxDalYPE55HGB6A08ReGkYhzl8It5sG1hjbwCDZuXKuDA+XVh04/mI4BxhelOF8GhDFnwahNAklOeOXo7WyDW/rpZuL0ncYjPGwMIYuzkeSceorGrPu+GExvPwCZRDNW8J369xaVAgomj6elPbWfMOlXWTC2wj32HB3FNBcE4KRrueK0/kSjUkvl2peM3NRjjoKRCAGGuQdgotLVuNdAvCBECzqA1xa8Kq4hwMtDOJo2uDmWRV7tC4FtlTP7W3dJr4aeMHhBW41ETS72qjdI/SANm/7L7EVlKM4yPnJC7hyfix+xIJQ0Zw0erkCMXIgAMzVDT6KS3wHcEi+q0kL4JBjrgonHNkLbV3chxGz5T1xlLXbwpBxjnGaiUnf57D8szgM9hpHH/EKD6z7PYa4050Xbmz5sbT6JPH0u+Mm4HJDSDCvbCiRx/sPnGLA8xkIkHb/Hv3VBI56xkds+vYyinAhs9wzkfhkqK+HgaEfwqOA8JTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Enable userspace to retrieve preserved VFIO device files after a Live
Update by implementing the retrieve() and finish() file handler
callbacks.

During retrieve():
 * Validate the handed-over struct vfio_pci_core_device_ser header,
   sizes, and flags.
 * Locate the registered vfio-pci device matching the serialized domain
   and BDF (requiring device->ops == &vfio_pci_ops) under the device
   lock. vfio-pci registers the vfio device before its probe completes,
   and the probe holds that lock, so a device that is still being probed
   is not returned.
 * Require the device to be in noiommu mode in the new kernel (returning
   -EOPNOTSUPP otherwise), still marked incoming by the PCI Live Update
   core, and matching the serialized PCI config space size.
 * Deserialize the inherited struct pci_saved_state and copy the
   handed-over vconfig and pci_config_map into a kernel-owned struct
   vfio_pci_liveupdate_incoming attached to vdev under dev_set->lock via
   vfio_pci_liveupdate_attach_incoming(), leaving the KHO serialized
   buffer read-only.
 * Open and return an anonymous VFIO cdev file via
   vfio_device_liveupdate_cdev_open().

Do not implement can_finish(): closing a retrieved LUO session invokes
finish, and refusing can_finish() would leak the session and leave
unclaimed devices running. Instead, finish() always completes:
 * If the retrieved device was claimed by opening it via
   VFIO_DEVICE_BIND_IOMMUFD (which consumes vdev->liveupdate_incoming;
   subsequent patches replace the open-time reset with non-reset
   take-over, reject opening incoming devices other than via retrieve(),
   and protect incoming kept-running devices across runtime PM, dev_set
   resets, and non-noiommu boots), finish() simply completes its PCI
   Live Update participation.
 * If the device was not claimed (never retrieved, retrieve() failed, or
   retrieved but never bound via VFIO_DEVICE_BIND_IOMMUFD),
   vfio_pci_core_liveupdate_reset() logs one pci_warn() naming the
   device, clears PCI_COMMAND_MASTER, resets the function, and restores
   the inherited pci_saved_state just as closing the device would. If
   the device has a function reset but is not reset, e.g. because
   pci_dev_trylock() contends with a concurrent driver unbind, latch
   vdev->liveupdate_reset_pending so vfio_pci_core_unregister_device()
   completes the function reset and state restoration via
   vfio_pci_core_liveupdate_reset_locked() under the device lock held by
   device_release_driver(). Opening the device after finish() resets it
   like any open, so it drops the latch.
 * If the device was not retrieved, look it up under pci_dev_lock(),
   which waits for a vfio-pci probe in progress. If it is bound to
   vfio-pci, finish it as above. If it has no driver, clear bus
   mastering and reset it. Otherwise leave it to the bound driver.
 * Call pci_liveupdate_finish() and kho_restore_free() on every path.

Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 drivers/vfio/pci/vfio_pci_core.c       |  65 +++++
 drivers/vfio/pci/vfio_pci_liveupdate.c | 342 ++++++++++++++++++++++++-
 drivers/vfio/pci/vfio_pci_priv.h       |  75 ++++++
 include/linux/vfio_pci_core.h          |   6 +
 4 files changed, 484 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 5f8c882d5778..60ada3bbb6ff 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -671,6 +671,8 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 
 	vfio_pci_core_map_bars(vdev);
 
+	vfio_pci_liveupdate_claim_incoming(vdev);
+
 	return 0;
 
 out_free_zdev:
@@ -739,6 +741,63 @@ static void vfio_pci_core_try_reset(struct vfio_pci_core_device *vdev)
 	pci_restore_state(pdev);
 }
 
+/*
+ * Reset a device that was kept running across a Live Update but not taken over,
+ * from the Live Update finish() of the device. Return true if the device was
+ * reset, false if it could not be reset, e.g. because its device lock could
+ * not be taken.
+ */
+bool vfio_pci_core_liveupdate_reset(struct vfio_pci_core_device *vdev,
+				    struct pci_saved_state *saved_state,
+				    bool reset_works, const char *reason)
+{
+	struct pci_dev *pdev = vdev->pdev;
+
+	lockdep_assert_held(&vdev->vdev.dev_set->lock);
+
+	if (reason)
+		pci_warn(pdev,
+			 "Resetting device not taken over after Live Update (%s)\n",
+			 reason);
+
+	pci_clear_master(pdev);
+	if (!saved_state)
+		pci_save_state(pdev);
+	kfree(vdev->pci_saved_state);
+	vdev->pci_saved_state = saved_state;
+	vdev->reset_works = reset_works;
+	vfio_pci_core_try_reset(vdev);
+
+	return !vdev->needs_reset;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_core_liveupdate_reset);
+
+/*
+ * Reset a device preserved across a Live Update from its remove() path, where
+ * the driver core holds the device lock. Save and restore the config space
+ * around the reset like vfio_pci_core_try_reset(), and block user config
+ * access while doing so. Like pci_reset_function_locked(), do not take the
+ * upstream bridge lock: remove() cannot wait for it without inverting the
+ * bridge -> device lock order, and the Live Update finish() of an unbound
+ * device holds it while it waits for the device lock held here.
+ */
+void vfio_pci_core_liveupdate_reset_locked(struct vfio_pci_core_device *vdev)
+{
+	struct pci_dev *pdev = vdev->pdev;
+
+	device_lock_assert(&pdev->dev);
+	lockdep_assert_held(&vdev->vdev.dev_set->lock);
+
+	pci_clear_master(pdev);
+	pci_cfg_access_lock(pdev);
+	pci_save_state(pdev);
+	pci_write_config_word(pdev, PCI_COMMAND, PCI_COMMAND_INTX_DISABLE);
+	if (!__pci_reset_function_locked(pdev))
+		vdev->needs_reset = false;
+	pci_restore_state(pdev);
+	pci_cfg_access_unlock(pdev);
+}
+
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
@@ -2362,6 +2421,12 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 
 	vfio_unregister_group_dev(&vdev->vdev);
 
+	/*
+	 * Must follow vfio_unregister_group_dev(), which waits for the
+	 * references a Live Update finish() of the device may hold.
+	 */
+	vfio_pci_liveupdate_unregister_dev(vdev);
+
 	vfio_pci_vf_uninit(vdev);
 	vfio_pci_vga_uninit(vdev);
 
diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
index ac77241ffb1e..f13c757b4567 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -35,7 +35,13 @@
  *    preserved, so there is no way for the file to be destroyed or the device
  *    to be unbound from the vfio-pci driver while it is preserved.
  *
- * Retrieving the file after kexec is not yet supported.
+ * After kexec, the preserved VFIO device file can be retrieved from the session
+ * just like any other preserved file::
+ *
+ *   ioctl(session_fd, LIVEUPDATE_SESSION_RETRIEVE_FD, &arg);
+ *   device_fd = arg.fd;
+ *   ...
+ *   ioctl(session_fd, LIVEUPDATE_SESSION_FINISH, ...);
  *
  * Restrictions
  * ============
@@ -97,6 +103,36 @@
  * the ``unfreeze()`` callback restores the physical INTx mask and clears the
  * frozen state, leaving the existing file descriptor immediately usable again.
  *
+ * Retrieval and Finish Behavior After Kexec
+ * =========================================
+ *
+ * After kexec, userspace must ensure the preserved PCI device is bound to
+ * ``vfio-pci`` in noiommu mode before invoking
+ * ``LIVEUPDATE_SESSION_RETRIEVE_FD`` (for example, via ``vfio-pci.ids=...`` on
+ * the kernel command line). A failed ``LIVEUPDATE_SESSION_RETRIEVE_FD`` call is
+ * cached permanently by LUO for that file.
+ *
+ * ``LIVEUPDATE_SESSION_RETRIEVE_FD`` validates the handed-over serialized state
+ * and returns a new unbound VFIO cdev file descriptor. The device is claimed on
+ * the first ``VFIO_DEVICE_BIND_IOMMUFD`` on that file descriptor.
+ *
+ * ``LIVEUPDATE_SESSION_FINISH`` (or closing a retrieved session file
+ * descriptor) always completes:
+ *
+ *  * If the device was retrieved and claimed via ``VFIO_DEVICE_BIND_IOMMUFD``,
+ *    ``finish()`` simply completes its Live Update participation.
+ *  * If the device was not claimed (never retrieved, ``retrieve()`` failed, or
+ *    retrieved but never bound via ``VFIO_DEVICE_BIND_IOMMUFD``), ``finish()``
+ *    logs one ``pci_warn()`` naming the device, clears ``PCI_COMMAND_MASTER``,
+ *    resets the function and restores the initial PCI saved state just as
+ *    closing the device would, and finishes its Live Update participation so
+ *    the device can be opened normally afterwards. If ``finish()`` cannot
+ *    reset a device that has a function reset, for example because it cannot
+ *    take the device lock while the device is being unbound from
+ *    ``vfio-pci``, it still clears ``PCI_COMMAND_MASTER``, and the function
+ *    reset is retried when the device is unbound, unless the device is opened
+ *    (which resets it) before that.
+ *
  * DMA Memory Ordering Contract
  * ============================
  *
@@ -110,8 +146,9 @@
  *    preserving the VFIO device. LUO finishes files within a session in reverse
  *    preservation order (LIFO), guaranteeing that if the device is not taken
  *    over in the new kernel, VFIO's ``finish()`` callback stops bus mastering
- *    and resets the device before the ``memfd``'s ``finish()`` callback releases
- *    its folios. Cross-session ordering is the responsibility of userspace.
+ *    before the ``memfd``'s ``finish()`` callback releases its folios. It
+ *    normally resets the device at that point too (see above for when it
+ *    cannot). Cross-session ordering is the responsibility of userspace.
  *
  *  * After retrieving a preserved ``memfd`` in the new kernel, its folios are
  *    ordinary unpinned shmem page cache until pinned again; userspace must keep
@@ -124,6 +161,7 @@
 
 #include <linux/cleanup.h>
 #include <linux/errno.h>
+#include <linux/file.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/vfio_pci.h>
 #include <linux/liveupdate.h>
@@ -131,6 +169,7 @@
 #include <linux/overflow.h>
 #include <linux/pci.h>
 #include <linux/pci_liveupdate.h>
+#include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/vfio.h>
 
@@ -327,13 +366,308 @@ static void vfio_pci_liveupdate_unfreeze(struct liveupdate_file_op_args *args)
 	smp_store_release(&vdev->liveupdate_frozen, false);
 }
 
+static int vfio_pci_liveupdate_validate_ser(const struct vfio_pci_core_device_ser *ser)
+{
+	size_t expected;
+
+	if (ser->reserved)
+		return -EINVAL;
+
+	if (ser->flags & ~VFIO_PCI_SER_KNOWN_FLAGS)
+		return -EOPNOTSUPP;
+
+	if (ser->cfg_size != PCI_CFG_SPACE_SIZE &&
+	    ser->cfg_size != PCI_CFG_SPACE_EXP_SIZE)
+		return -EINVAL;
+
+	expected = size_add(sizeof(*ser),
+			    size_add(size_mul(2, ser->cfg_size),
+				     ser->saved_state_size));
+	if (expected != ser->size)
+		return -EINVAL;
+
+	return 0;
+}
+
+static struct pci_saved_state *
+vfio_pci_liveupdate_parse_saved_state(struct pci_dev *pdev,
+				      const struct vfio_pci_core_device_ser *ser)
+{
+	const void *blob;
+
+	if (!ser->saved_state_size)
+		return NULL;
+
+	blob = ser->data + 2 * (size_t)ser->cfg_size;
+	return pci_liveupdate_deserialize_saved_state(pdev, blob,
+						      ser->saved_state_size);
+}
+
+static int match_device(struct device *dev, const void *arg)
+{
+	struct vfio_device *device = container_of(dev, struct vfio_device, device);
+	const struct vfio_pci_core_device_ser *ser = arg;
+	struct pci_dev *pdev;
+
+	if (device->ops != &vfio_pci_ops)
+		return false;
+
+	pdev = dev_is_pci(device->dev) ? to_pci_dev(device->dev) : NULL;
+	if (!pdev)
+		return false;
+
+	return ser->bdf == pci_dev_id(pdev) &&
+	       ser->domain == pci_domain_nr(pdev->bus);
+}
+
+/*
+ * vfio-pci makes the vfio device visible before its probe completes, and the
+ * probe runs under the device lock. Look the device up with that lock held, so
+ * that a device found here has completed its probe, and the reset done by
+ * finish() does not contend with the probe for that lock. Return the device
+ * with a registration reference held.
+ */
+static struct vfio_device *
+vfio_pci_liveupdate_find_probed(const struct vfio_pci_core_device_ser *ser)
+{
+	struct vfio_device *device;
+	struct pci_dev *pdev;
+
+	pdev = pci_get_domain_bus_and_slot(ser->domain, PCI_BUS_NUM(ser->bdf),
+					   ser->bdf & 0xff);
+	if (!pdev)
+		return NULL;
+
+	device_lock(&pdev->dev);
+	device = vfio_find_device(ser, match_device);
+	device_unlock(&pdev->dev);
+	pci_dev_put(pdev);
+	return device;
+}
+
+static int
+vfio_pci_liveupdate_attach_incoming(struct vfio_pci_core_device *vdev,
+				    struct vfio_pci_liveupdate_incoming *in)
+{
+	guard(mutex)(&vdev->vdev.dev_set->lock);
+
+	if (vdev->liveupdate_incoming || vdev->liveupdate_claimed ||
+	    !pci_liveupdate_is_incoming(vdev->pdev))
+		return -EBUSY;
+
+	vdev->liveupdate_incoming = in;
+	return 0;
+}
+
 static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
 {
-	return -EOPNOTSUPP;
+	struct pci_saved_state *saved_state = NULL;
+	const struct vfio_pci_core_device_ser *ser;
+	struct vfio_pci_liveupdate_incoming *in;
+	struct vfio_pci_core_device *vdev;
+	struct vfio_device *device;
+	struct pci_dev *pdev;
+	struct file *file;
+	size_t in_size;
+	int ret;
+
+	if (!args->serialized_data)
+		return -EINVAL;
+
+	ser = phys_to_virt(args->serialized_data);
+	ret = vfio_pci_liveupdate_validate_ser(ser);
+	if (ret)
+		return ret;
+
+	device = vfio_pci_liveupdate_find_probed(ser);
+	if (!device)
+		return -ENODEV;
+
+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
+	pdev = vdev->pdev;
+
+	if (!vfio_device_is_noiommu(device)) {
+		ret = -EOPNOTSUPP;
+		goto out_put_dev;
+	}
+
+	if (!pci_liveupdate_is_incoming(pdev) ||
+	    ser->cfg_size != pdev->cfg_size) {
+		ret = -EINVAL;
+		goto out_put_dev;
+	}
+
+	if (ser->saved_state_size) {
+		saved_state = vfio_pci_liveupdate_parse_saved_state(pdev, ser);
+		if (IS_ERR(saved_state)) {
+			ret = PTR_ERR(saved_state);
+			goto out_put_dev;
+		}
+	}
+
+	in_size = struct_size(in, data, size_mul(2, ser->cfg_size));
+	in = kzalloc(in_size, GFP_KERNEL);
+	if (!in) {
+		ret = -ENOMEM;
+		goto out_free_saved;
+	}
+
+	in->saved_state = saved_state;
+	in->reset_works = !!(ser->flags & VFIO_PCI_SER_RESET_WORKS);
+	in->cfg_size = ser->cfg_size;
+	memcpy(in->data, ser->data, 2 * (size_t)ser->cfg_size);
+
+	file = vfio_device_liveupdate_cdev_open(device);
+	if (IS_ERR(file)) {
+		ret = PTR_ERR(file);
+		goto out_free_in;
+	}
+
+	ret = vfio_pci_liveupdate_attach_incoming(vdev, in);
+	if (ret)
+		goto out_fput;
+
+	args->file = file;
+	vfio_device_put_registration(device);
+	return 0;
+
+out_fput:
+	fput(file);
+out_free_in:
+	kfree(in);
+out_free_saved:
+	kfree(saved_state);
+out_put_dev:
+	vfio_device_put_registration(device);
+	return ret;
+}
+
+static void vfio_pci_liveupdate_finish_vdev(struct vfio_pci_core_device *vdev,
+					    const struct vfio_pci_core_device_ser *ser,
+					    const char *reason)
+{
+	struct pci_dev *pdev = vdev->pdev;
+	struct pci_saved_state *saved_state = NULL;
+	bool reset_works = true;
+	bool was_reset;
+
+	scoped_guard(mutex, &vdev->vdev.dev_set->lock) {
+		if (!vdev->liveupdate_claimed &&
+		    pci_liveupdate_is_incoming(pdev)) {
+			if (vdev->liveupdate_incoming) {
+				saved_state = vdev->liveupdate_incoming->saved_state;
+				vdev->liveupdate_incoming->saved_state = NULL;
+				reset_works = vdev->liveupdate_incoming->reset_works;
+			} else if (!vfio_pci_liveupdate_validate_ser(ser) &&
+				   ser->cfg_size == pdev->cfg_size) {
+				reset_works = !!(ser->flags & VFIO_PCI_SER_RESET_WORKS);
+				saved_state = vfio_pci_liveupdate_parse_saved_state(pdev, ser);
+				if (IS_ERR(saved_state))
+					saved_state = NULL;
+			}
+
+			/*
+			 * An unbind of the device waits for the reference held
+			 * by finish() with the device lock held, so the reset
+			 * only tries to take that lock. If the device has a
+			 * function reset but was not reset, e.g. because that
+			 * lock was taken, bus mastering is still cleared, and
+			 * the function reset is retried when the device is
+			 * unbound, unless the device is opened before that. See
+			 * vfio_pci_liveupdate_unregister_dev() and
+			 * vfio_pci_liveupdate_claim_incoming().
+			 */
+			was_reset = vfio_pci_core_liveupdate_reset(vdev,
+								   saved_state,
+								   reset_works,
+								   reason);
+			vdev->liveupdate_reset_pending = reset_works &&
+							 !was_reset;
+		}
+		vfio_pci_liveupdate_free_incoming(vdev);
+	}
+
+	if (pci_liveupdate_is_incoming(pdev))
+		pci_liveupdate_finish(pdev);
+}
+
+/*
+ * Look up the vfio-pci device of a preserved device that was not retrieved,
+ * with the device lock held, like vfio_pci_liveupdate_find_probed(). If it is
+ * bound to vfio-pci, return the vfio-pci device with a registration reference
+ * held, so that the caller finishes it. Otherwise, finish the device here.
+ */
+static struct vfio_device *
+vfio_pci_liveupdate_finish_lookup(const struct vfio_pci_core_device_ser *ser)
+{
+	struct vfio_device *device = NULL;
+	struct pci_dev *pdev, *bridge;
+
+	pdev = pci_get_domain_bus_and_slot(ser->domain, PCI_BUS_NUM(ser->bdf),
+					   ser->bdf & 0xff);
+	if (!pdev)
+		return NULL;
+
+	bridge = pci_upstream_bridge(pdev);
+	if (bridge)
+		pci_dev_lock(bridge);
+	pci_dev_lock(pdev);
+
+	if (pci_liveupdate_is_incoming(pdev)) {
+		if (!pdev->dev.driver) {
+			pci_warn(pdev,
+				 "Resetting device not taken over after Live Update (not bound to vfio-pci)\n");
+			pci_clear_master(pdev);
+			pci_reset_function_locked(pdev);
+			pci_liveupdate_finish(pdev);
+		} else {
+			/*
+			 * A driver is bound and its probe has completed, as it
+			 * runs under the device lock. Holding the lock also
+			 * prevents an unbind until the registration reference
+			 * below is taken.
+			 */
+			device = vfio_find_device(ser, match_device);
+			if (!device) {
+				pci_warn(pdev,
+					 "Device not taken over after Live Update is bound to %s, not resetting it\n",
+					 dev_driver_string(&pdev->dev));
+				pci_liveupdate_finish(pdev);
+			}
+		}
+	}
+
+	pci_dev_unlock(pdev);
+	if (bridge)
+		pci_dev_unlock(bridge);
+	pci_dev_put(pdev);
+	return device;
 }
 
 static void vfio_pci_liveupdate_finish(struct liveupdate_file_op_args *args)
 {
+	struct vfio_pci_core_device_ser *ser = phys_to_virt(args->serialized_data);
+	struct vfio_pci_core_device *vdev;
+	struct vfio_device *device;
+	const char *reason;
+
+	if (args->retrieve_status > 0) {
+		device = vfio_device_from_file(args->file);
+		vdev = container_of(device, struct vfio_pci_core_device, vdev);
+		vfio_pci_liveupdate_finish_vdev(vdev, ser,
+						"retrieved but not opened");
+	} else {
+		reason = args->retrieve_status ? "retrieve failed" : "not retrieved";
+		device = vfio_pci_liveupdate_finish_lookup(ser);
+		if (device) {
+			vdev = container_of(device, struct vfio_pci_core_device,
+					    vdev);
+			vfio_pci_liveupdate_finish_vdev(vdev, ser, reason);
+			vfio_device_put_registration(device);
+		}
+	}
+
+	kho_restore_free(ser);
 }
 
 static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index 2c732cb1c189..d8670dc51bb4 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -150,6 +150,15 @@ static inline void vfio_pci_dma_buf_move(struct vfio_pci_core_device *vdev,
 }
 #endif
 
+struct vfio_pci_liveupdate_incoming {
+	struct pci_saved_state *saved_state;
+	bool reset_works;
+	u16 cfg_size;
+	u8 data[];
+};
+
+void vfio_pci_core_liveupdate_reset_locked(struct vfio_pci_core_device *vdev);
+
 #ifdef CONFIG_VFIO_PCI_LIVEUPDATE
 int __init vfio_pci_liveupdate_init(void);
 void vfio_pci_liveupdate_cleanup(void);
@@ -159,6 +168,57 @@ static inline bool vfio_pci_dev_is_frozen(struct vfio_pci_core_device *vdev)
 	/* Written in VFIO PCI Liveupdate during freeze()/unfreeze() */
 	return smp_load_acquire(&vdev->liveupdate_frozen);
 }
+
+static inline void
+vfio_pci_liveupdate_free_incoming(struct vfio_pci_core_device *vdev)
+{
+	struct vfio_pci_liveupdate_incoming *in = vdev->liveupdate_incoming;
+
+	if (!in)
+		return;
+
+	kfree(in->saved_state);
+	kfree(in);
+	vdev->liveupdate_incoming = NULL;
+}
+
+static inline void
+vfio_pci_liveupdate_claim_incoming(struct vfio_pci_core_device *vdev)
+{
+	/*
+	 * A reset that finish() left for unbind is not needed once the device
+	 * is opened after finish(): the open resets the device if it can, and
+	 * so does the close.
+	 */
+	vdev->liveupdate_reset_pending = false;
+
+	if (!vdev->liveupdate_incoming)
+		return;
+
+	vfio_pci_liveupdate_free_incoming(vdev);
+	vdev->liveupdate_claimed = true;
+}
+
+static inline void
+vfio_pci_liveupdate_unregister_dev(struct vfio_pci_core_device *vdev)
+{
+	struct pci_dev *pdev = vdev->pdev;
+
+	scoped_guard(mutex, &vdev->vdev.dev_set->lock) {
+		/*
+		 * Complete a reset that finish() could not do, see
+		 * vfio_pci_liveupdate_finish_vdev().
+		 */
+		if (vdev->liveupdate_reset_pending) {
+			vfio_pci_core_liveupdate_reset_locked(vdev);
+			vdev->liveupdate_reset_pending = false;
+		}
+		vfio_pci_liveupdate_free_incoming(vdev);
+	}
+
+	if (pci_liveupdate_is_incoming(pdev))
+		pci_liveupdate_finish(pdev);
+}
 #else
 static inline int vfio_pci_liveupdate_init(void)
 {
@@ -173,6 +233,21 @@ static inline bool vfio_pci_dev_is_frozen(struct vfio_pci_core_device *vdev)
 {
 	return false;
 }
+
+static inline void
+vfio_pci_liveupdate_free_incoming(struct vfio_pci_core_device *vdev)
+{
+}
+
+static inline void
+vfio_pci_liveupdate_claim_incoming(struct vfio_pci_core_device *vdev)
+{
+}
+
+static inline void
+vfio_pci_liveupdate_unregister_dev(struct vfio_pci_core_device *vdev)
+{
+}
 #endif /* CONFIG_VFIO_PCI_LIVEUPDATE */
 
 #endif
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 6bae7581f4f4..f5c279d0df1e 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -152,6 +152,9 @@ struct vfio_pci_core_device {
 #ifdef CONFIG_VFIO_PCI_LIVEUPDATE
 	bool			liveupdate_frozen;
 	bool			liveupdate_intx_disabled;
+	bool			liveupdate_claimed;
+	bool			liveupdate_reset_pending;
+	struct vfio_pci_liveupdate_incoming *liveupdate_incoming;
 #endif
 };
 
@@ -197,6 +200,9 @@ int vfio_pci_core_match_token_uuid(struct vfio_device *core_vdev,
 int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
 void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
+bool vfio_pci_core_liveupdate_reset(struct vfio_pci_core_device *vdev,
+				    struct pci_saved_state *saved_state,
+				    bool reset_works, const char *reason);
 pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
 						pci_channel_state_t state);
 ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
-- 
2.56.0.317.g454f8302e1-goog


