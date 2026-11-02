Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C541A60E40A5
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MpXt7vzE
Received: by kanga.kvack.org (Postfix)
	id 6B5E96B0623; Mon,  2 Nov 2026 10:37:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 640AB6B0641; Mon,  2 Nov 2026 10:37:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B9556B0642; Mon,  2 Nov 2026 10:37:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 15B986B0623
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:37:05 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 487B7C0189
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:04 +0000 (UTC)
X-FDA: 85390582368.08.F46A585
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf24.hostedemail.com (Postfix) with ESMTP id 63A4918000E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=MpXt7vzE;
	spf=pass (imf24.hostedemail.com: domain of 3HK7oagcKCHksfmfkpedlldib.Zljifkru-jjhsXZh.lod@flex--vipinsh.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3HK7oagcKCHksfmfkpedlldib.Zljifkru-jjhsXZh.lod@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tWmkkGF65geeupdTZHwmY4vWlAPAJsehULkoIO9Oe60=;
	b=ADdKp4g/GGzpXupO1uCzq6iObRvCwDArxxyLinla6Hvq4M7zmdda/6rklzZi7KCLVb2vz0
	790gVO1aqM0L8Cp3Ba99oBcm/k6Ip+Mc2WzcKK6ZEKnmAWiYiYfbQj9wiEIxWlIbpLSFO1
	or2jjm/gWxwR0uK4N7q6b3LQM7kioJo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=MpXt7vzE;
	spf=pass (imf24.hostedemail.com: domain of 3HK7oagcKCHksfmfkpedlldib.Zljifkru-jjhsXZh.lod@flex--vipinsh.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3HK7oagcKCHksfmfkpedlldib.Zljifkru-jjhsXZh.lod@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633822;
	b=SvocAwN7Ayq4fyePCNLlJ4MjKNHy7hCAdvt+daButneWG40T4vkod9ArrBTunn31SB2GQZ
	xeIWLFLpNinTAc/48JWyKkpVbE2WKJqgbXpi3QCgZZRfXA6H/nYEhHcJtaqW0SJLUyVRwE
	62HCOctwph375/21u7KocvYdVsf2rgQ=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2ea71803effso33718495ad.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633821; x=1794238621; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tWmkkGF65geeupdTZHwmY4vWlAPAJsehULkoIO9Oe60=;
        b=MpXt7vzEqfgSlc9ijd6WIrdgk9D/77GtxE4YQFKjUEeKo9DMNR/Tg80V0or7zwThat
         lK7qzyxUX7SzZkcaL1D3XWavbVmrJ4ljT3c0Qj39h3A9ZI6RYplVXibABKVcco2CnIOo
         S/OGK0d4l5tpWuJWdHpkSOqmR0NLounZDomB+fw8y9sK/lTTTy8TLIvd+CyqhW4Cumvs
         IGnrxv+5ITlju3Gy4FHeVQKay7QBeoOp7BFB92Q73MG33DEJzVoDSmW9UhkAAb3TVP2N
         2396+afuV/YzMjwIFgZKkFhqKJphryT+Wv1CyrXP1NATbzactN9mr5lPU5D+tZ/vpjZB
         qRzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633821; x=1794238621;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tWmkkGF65geeupdTZHwmY4vWlAPAJsehULkoIO9Oe60=;
        b=XMtr15/BrRaJ0oAqRvywjsrEunD4Doalcy1ekl27zXzoSYhtZGtqbAr5cEAeBXkvaN
         PAQRNO+3xBbWO/tJcFXDvrhrwvSQoGSmoVx/gekcOpIcJ4zaHjenyvGKuDmPbMBp1Dhi
         3hrQorc0wMatgYLKFOgjAEYH9OlMijUk82UFD7tPByVZCgg7iI4KqH5uZP8j31T1PuyJ
         hgsAiqY/83aggEj5g4km8RVWtGs1NB04iX0GUGQWRaQp9Hsfl6r29ZTyRQg4vslTDoC5
         6paHm8JOJhhZNJshgj0I+/zTGkPemuOfd23RGOr4wZJfWRNvWdvC9sYtKowGi5tdllJm
         C+kg==
X-Forwarded-Encrypted: i=1; AKwUvBxgf/Qt/v6EYzHEwToA3wW+PljCHLOIJTk8wUz/BNquKNltMadx+OieEhdH/2PFQ0eaAjUMPS+vmg==@kvack.org
X-Gm-Message-State: APuU4Z91hRK7s8NctcXqJbNBGgqYP8RfRBPxsg2Kygd2UP3QiumKjDwI
	5jUbtIMwfFwb6FqCFBSfOJTTBwy6TXcM3WDN/VTbFrlTWXVuniCbKfRu6iw6gghpuM47SaWwhb0
	aJY19FGL+DA==
X-Received: from plblf11.prod.google.com ([2002:a17:902:fb4b:b0:2ea:7f9c:2ce])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:390c:b0:2ea:778e:8652
 with SMTP id d9443c01a7336-2eb36496179mr99072185ad.14.1793633820958; Mon, 02
 Nov 2026 07:37:00 -0800 (PST)
Date: Mon,  2 Nov 2026 07:36:30 -0800
In-Reply-To: <20261102153656.1431701-1-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261102153656.1431701-1-vipinsh@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102153656.1431701-2-vipinsh@google.com>
Subject: [PATCH v6 01/27] vfio/pci: Factor out the reset logic in VFIO PCI
 device close path
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
X-Rspamd-Queue-Id: 63A4918000E
X-Stat-Signature: w3431bkdy1u3u4aaew4z6pz3sa84zdx7
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793633822-988171
X-HE-Meta: U2FsdGVkX18/UI+TZDiZWb0+JS9r6wP/L+z/oLdOpZrDiVwEkZVXrghxT9N7ovojqzU1OqgWqGiN6IkuMwmFRmWr/3FiMUFJWu6EmC3GL9nv2VoT4SJmb1MZSFhgEcpbzyK9QQfm6ruoVlrDygI3NU/UrcLfloQ4CCFSyapksFjpWNIzQu1jSEMf5/aceqtnG9K03mUjF1SSB1M386k56OeeohJopdLf3dz/qhBRavAcvVR56TAyVN57mdP2aLODDmNNeMpA774c5B6sA+pp/orSnD+huV2cxgYbwCMWauwWtqq3+nC7x6KiEPp4avSY65YVlcZllii+AwYuq0T7LpP2fDW/h0NvbUefH8eZ+mIzENfNUvNiW+FCpB+WseiEvuC8Hg5Jhx/2TaDH+WIXr2Cp9LcK6m9kaKJiQtG2irv7vFB63+t/zUtrcsvTu8HWclsS8k5IhXhzOH19Fk6GQpLsISRkhp/GDqUGnyY1G28q/OLkakjIx0FRuKJiD8UDfEu194XhEHMn7ItB+L4/TPaUyhotoFfV+qOZDSzlYRnT25KVDh6jCYlQRHDusaiMadSEGmBfGQKpvA4gItoXlhDkuttRCaqkTgWzPxF26fzmvg9YpyPD9fB+AjQtlw7tb/O5RbnnK2C7JThA2c1F52iLiVQ2Whm131Lbtg61/hcnaFJikAnS4YIwzf/LzV7KY9k4tiwXqpDNgl/u0RAWQRgc847o1/sQigpdq2TLold55pXe2nFl5u1/YIlMSWLBP8aVTRa3WuxiAs9VkZEnKJrQkOn904i0F90PHWICNHY1kt+dHvDbG7mf6PdbcEHNYlnkgTfn791HCSTqtQ5e20Cy4fmj5szSsfmXYjds7gDbxbr5unWaW1hkOfUmx+r8gKjM3972KDduTAAUOrkuJO5TQppM8VgmbJkg8pPPcQd/zUoFLvJA0GZBqWBn6dEf1Bn46J+n4FqcOxu0b3a
 Jqs0UNeC
 dGDnBQXCwF0IGdBL7gQAncfAo5KCauhSBpzS1VNKJZ4FV59N/PQCw3KtOhkwRUJRdVz1M2WMXAgYJsYzWl7223XDM/5gJLfQhff041KIJCPjxNlnwkynxSC4SNcQ+PizJuVhjlQZdJnDj6UcchkvQiaHC1DMFJYRtAtjwuTXcQ7Q/U8juROwCg9hfzBtgAMwSShNVrt9bJJTuXCdayziJAl/GJFO0eFXAahVr+/QufS+7kauhhO9xfoBaGBwtYL0Fz//eHYr3lXFiLfLJOGyaARpZtsbm2/xiDwRyk4jQHMzWBBLINArjAf1DMCQcmOkcDJFqaD8ddsjs02kAFEOUwTGkXla8hn1ofrPdgkSyADiKcx97LxBV1TeOMRRSPmCmeCZJlx7am1GoXUkO9m9mLRVQEdMfI+coD4H3mXv8X+D2hmhm0KQiRjFJ/qhPGUZ/0I92BvkpSNVvECcbvAKaiqFxJhWp62bhh3XwPGu8SoyAZB2Jyt2xcXMaK9kY1doZ3XLsBzAXJr2Y8oBBsv3FmfAxUxXJdfOZn7e8WWC4kdYTziL1vWbS2Ij3DUjF83G71JJmCSfpX73MPCAGWpX8WEeCQ0ontKMnHL7MgY0bY/X0Bgg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vfio_pci_core_disable() is a very long function doing multiple things
like exiting runtime power management, setting device to D0 power,
clearing bus master, clearing irqs, freeing eventfds, releasing device
regions, unmapping PCI bars, and performing device/bus resets.

The upcoming VFIO Liveupdate feature will also need to utilize same
reset logic.

Extract device reset code to a new helper function,
vfio_pci_core_try_reset(), and update vfio_pci_core_disable() to use
this new function.

No functional change intended.

Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 100 ++++++++++++++++---------------
 1 file changed, 53 insertions(+), 47 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 6757054e9d87..7b003c3e5a3a 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -680,9 +680,60 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_enable);
 
-void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
+static void vfio_pci_core_try_reset(struct vfio_pci_core_device *vdev)
 {
+	struct pci_dev *pdev = vdev->pdev;
 	struct pci_dev *bridge;
+
+	vdev->needs_reset = true;
+
+	/*
+	 * If we have saved state, restore it.  If we can reset the device,
+	 * even better.  Resetting with current state seems better than
+	 * nothing, but saving and restoring current state without reset
+	 * is just busy work.
+	 */
+	if (pci_load_and_free_saved_state(pdev, &vdev->pci_saved_state)) {
+		pci_info(pdev, "%s: Couldn't reload saved state\n", __func__);
+
+		if (!vdev->reset_works)
+			return;
+
+		pci_save_state(pdev);
+	}
+
+	/*
+	 * Disable INTx and MSI, presumably to avoid spurious interrupts
+	 * during reset.  Stolen from pci_reset_function()
+	 */
+	pci_write_config_word(pdev, PCI_COMMAND, PCI_COMMAND_INTX_DISABLE);
+
+	/*
+	 * Try to get the locks ourselves to prevent a deadlock. The
+	 * success of this is dependent on being able to lock the device,
+	 * which is not always possible.
+	 * We can not use the "try" reset interface here, which will
+	 * overwrite the previously restored configuration information.
+	 */
+	if (vdev->reset_works) {
+		bridge = pci_upstream_bridge(pdev);
+		if (bridge && !pci_dev_trylock(bridge))
+			goto out_restore_state;
+		if (pci_dev_trylock(pdev)) {
+			if (!__pci_reset_function_locked(pdev))
+				vdev->needs_reset = false;
+			pci_dev_unlock(pdev);
+		}
+		if (bridge)
+			pci_dev_unlock(bridge);
+	}
+
+out_restore_state:
+	pci_restore_state(pdev);
+}
+
+void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
+{
 	struct pci_dev *pdev = vdev->pdev;
 	struct vfio_pci_dummy_resource *dummy_res, *tmp;
 	struct vfio_pci_ioeventfd *ioeventfd, *ioeventfd_tmp;
@@ -757,54 +808,9 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 		kfree(dummy_res);
 	}
 
-	vdev->needs_reset = true;
-
 	vfio_pci_zdev_close_device(vdev);
 
-	/*
-	 * If we have saved state, restore it.  If we can reset the device,
-	 * even better.  Resetting with current state seems better than
-	 * nothing, but saving and restoring current state without reset
-	 * is just busy work.
-	 */
-	if (pci_load_and_free_saved_state(pdev, &vdev->pci_saved_state)) {
-		pci_info(pdev, "%s: Couldn't reload saved state\n", __func__);
-
-		if (!vdev->reset_works)
-			goto out;
-
-		pci_save_state(pdev);
-	}
-
-	/*
-	 * Disable INTx and MSI, presumably to avoid spurious interrupts
-	 * during reset.  Stolen from pci_reset_function()
-	 */
-	pci_write_config_word(pdev, PCI_COMMAND, PCI_COMMAND_INTX_DISABLE);
-
-	/*
-	 * Try to get the locks ourselves to prevent a deadlock. The
-	 * success of this is dependent on being able to lock the device,
-	 * which is not always possible.
-	 * We can not use the "try" reset interface here, which will
-	 * overwrite the previously restored configuration information.
-	 */
-	if (vdev->reset_works) {
-		bridge = pci_upstream_bridge(pdev);
-		if (bridge && !pci_dev_trylock(bridge))
-			goto out_restore_state;
-		if (pci_dev_trylock(pdev)) {
-			if (!__pci_reset_function_locked(pdev))
-				vdev->needs_reset = false;
-			pci_dev_unlock(pdev);
-		}
-		if (bridge)
-			pci_dev_unlock(bridge);
-	}
-
-out_restore_state:
-	pci_restore_state(pdev);
-out:
+	vfio_pci_core_try_reset(vdev);
 	pci_disable_device(pdev);
 
 	vfio_pci_dev_set_try_reset(vdev->vdev.dev_set);
-- 
2.56.0.317.g454f8302e1-goog


