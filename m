Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FA10C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:15:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B912A6B00D6; Tue, 14 Jul 2026 11:15:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1CA86B00DE; Tue, 14 Jul 2026 11:15:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FBB26B00E0; Tue, 14 Jul 2026 11:15:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 463EE6B00D6
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:15:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C802D1403D3
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:13 +0000 (UTC)
X-FDA: 84987730506.25.4993EAF
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf27.hostedemail.com (Postfix) with ESMTP id 134CB40002
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RHRav1UR;
	spf=pass (imf27.hostedemail.com: domain of 3flJWagcKCNUM9G9EJ87FF7C5.3FDC9ELO-DDBM13B.FI7@flex--vipinsh.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3flJWagcKCNUM9G9EJ87FF7C5.3FDC9ELO-DDBM13B.FI7@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784042112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OET28Pw7Tm9U8SptXyUJqzCGyMYvQ/PVMzqx3Tt4yN8=;
	b=LscB3BBKbCm+vo3qBOKvWRgiS9kWZ1KFFKh+/C29ZyJmQzb+pGSH6W9dEBfFZmkqp5Sqb5
	nL3exB4YOf8HEw0ox3RCEGmr00aJfnfNdqTV7/V4ncWVCeKsC+l2aFGCq7i4L52SAhDdyq
	iRUeCI8IAqfGhI6zThgu7vYalWBaFvU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RHRav1UR;
	spf=pass (imf27.hostedemail.com: domain of 3flJWagcKCNUM9G9EJ87FF7C5.3FDC9ELO-DDBM13B.FI7@flex--vipinsh.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3flJWagcKCNUM9G9EJ87FF7C5.3FDC9ELO-DDBM13B.FI7@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784042112;
	b=33HnMYJS+EOkTPlIP2EZbEhCfO/I7PogE6GfhmZjO3UtHiLkMcRda3krzC0o+fby0b2QyG
	zE6nYkWZHC5uT6gjlFXDtZI/zrOwHfFEyjvJ5udqGozZzFbn4J33fVl3Iu43V9RGLT2C5G
	m+fQ67qh0m8+ry2XQ9qUsCEzViy1bDQ=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2cacd6d37edso63564875ad.0
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784042111; x=1784646911; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OET28Pw7Tm9U8SptXyUJqzCGyMYvQ/PVMzqx3Tt4yN8=;
        b=RHRav1URHC0f+et8rB96LCEHkMB4gtMmLkuPANcrQoImIox+OF9PUNr0KJkugKMACE
         WUU5dCPs7LtvZJaJpM4RDJZGrZGhM7a3ocmEfZsKPSy/pRhJlGcFLfn++Al+dZSjeXZE
         0KC/9LhfSw9qYjSSMILP/eVO8ato4XwCCHvueTB4TR/jTrAHpXcLgV0AL5Tvz+Mc+8ds
         TN0mq5Nz1/U9R2cO7RK2zu57TErZhtfHcLw+/gcNwv34t9wBd8Mvo5OYCKpQ4fN0U9o4
         IVei9skpyJajHGrSJkVfBzVGaWMf+40RAJn6oZWMjd39++4OT+EeQZJqAQJ4vUzbUTxA
         gOJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784042111; x=1784646911;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OET28Pw7Tm9U8SptXyUJqzCGyMYvQ/PVMzqx3Tt4yN8=;
        b=EzYupgIG+qX/lImhBsdIUggENA2OALhsVHmG3Qaurpy9nCds5/qhYeY2bDZJvh6+Pt
         /M27yiTNmqIbavY8uYxs0u6KakQsulKjxZDybn4FSWBb/xEQd6/bhZDY12V8vbIKyC9t
         fSpPLWNUmAlxcCdDLKlBqS6nb4XqfREDrhHztWdts1eKFr8DYnNPnZd5JEORzFCH4VeN
         OmB/ZCsQDqLI+/yFGrQKbF0FcYEWH9SlLSVLAcPhsxS7dTIFpjbU0eBqh2xwmYhblYR1
         ZeB7Coc3aCm3Y2phzZ02lvGBx3wQUtr2G91Wb84LME6+BDHswq0sjEu0sRhYgJHJlfsN
         IqOw==
X-Forwarded-Encrypted: i=1; AHgh+RohlrAZ6rT9JSsk+vPWr6iK4ZDfKSxarQ/CjiQGeM0KlZZ+Eb2ocd9fc/xZtnxVnVSII2+bDz0BrA==@kvack.org
X-Gm-Message-State: AOJu0Yzoz/Y4Tv/yoEmLCwLKOHceYodIjA3rCNnA/rn8IR+1w/u1Wcii
	+ZcaDXmPjcxChWXCmQB/fKe3q+CBRyRoDmX5DeVZX9Sdr2jyubsijiQXWx2RNC3yFGRk+SPu5X8
	o6bkEPWzy4w==
X-Received: from pldu11.prod.google.com ([2002:a17:903:108b:b0:2c7:e06e:86f6])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:b85:b0:2c9:ae0b:61e3
 with SMTP id d9443c01a7336-2ce9e9a6ed8mr116458815ad.2.1784042110624; Tue, 14
 Jul 2026 08:15:10 -0700 (PDT)
Date: Tue, 14 Jul 2026 08:14:46 -0700
In-Reply-To: <20260714151505.3466855-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20260714151505.3466855-1-vipinsh@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260714151505.3466855-2-vipinsh@google.com>
Subject: [PATCH v5 01/20] vfio/pci: Factor out the reset logic in VFIO PCI
 device close path
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rientjes@google.com, rodrigo.vivi@intel.com, 
	rppt@kernel.org, saeedm@nvidia.com, schnelle@linux.ibm.com, 
	skhan@linuxfoundation.org, skhawaja@google.com, vipinsh@google.com, 
	vivek.kasireddy@intel.com, witu@nvidia.com, yanjun.zhu@linux.dev, 
	yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 134CB40002
X-Stat-Signature: rasamgabncgsr83zhyzqtycteunqqpts
X-HE-Tag: 1784042111-716262
X-HE-Meta: U2FsdGVkX18r+dKQUpvZczJjEt79BKQqjxXDqaUrgwn3kUSmWJIsmthrrOzQ00rkU/EFoYCBbpa3OfZwYFo3zRRUI6OwugSV5iZYcnE0FzEH1Lj17QyQyLdOEryCk0y0UlMRWEZecCp+RHr7By1XGxFbHV6cjNNgNEKmef/oK8ckLDR8lVeY9zPKkTV+2mkVYYwXYUsrrWLI7QcxaPdRdTMUUWW70psLSNcjOSuD9EqlrdYv127CkJ4GvWOXIn5YPwY9rVF9iZlj1XHPT5HzT9WjOT75OEnoc6mcmpTz8KFOi62ASX4CynBe/KoQ5davSBkao0wiEcEzGO9W176G0bhtKvZhHDcMleKThn17ZzVNeZiwtfW9KEh69XJYiJ8p5uiICg6eBqgI9M5W5Uyaa57OxFdgzKvTFZvGqPF03IOxNs0yp+rgxfebh8cy4YN85iNh4rRybz0aGHE8jYgv7hw9D4zPVxcO6Tdz0YaWh9tBDU04LlTTiKQXSm9DOCeDYD6/AwkcWShRJ5VocByS5EZDetNYo5Zoc7PpUQWAJEA2lEQH8CBzoTPzDcTUUBTp43pUnG1sVVEvIxJ7OGW5jJWb/ZJvTBVNYPptBlvoJ1oTflglJN+l69F7NRSrnq3k9s0+NlF8mMPa+XHUcuVMDJ+7WilQ+u+koHqueSGnPQb47vzJV5uv/j/gNBBIrv859avRQHyVpmbx8yeFDVmk75IFXYJTcudgvkPXkSF+fg1gyYeISB/5wclql/LptQuXhLXMdkxe1o3AufflGC7D7n54y3Cnf3qQYSB7uGrPEWJuAvfG2VAyyvHKGWZjE8pgWoo1W6yCtWYogAX+j65lPNoOitabeiVSGzkgLfghz+sxjHRNVY+TQKF3Vn/vJGr/c4bZbarZQsYmZOK2S2iN6CYYYUhx4eVzYZwV7MRJCIDCm/vHBe9FhU6T6OoHUc8hxYEZb6WJnV4GNmBSeqg
 Eekjylhs
 SFLJvM4Gz348fXXG75Zix4rWFhx/PyMQXIslAh7lkl85h5sQ4A0ZBEgTY3LLd2xqNT2PpmIy/s3w7lm2aVu1kxw0QhLdPasC4eljT4vBD+3yGUqaRNrb9xoOTo2F461gTUuotMIIOnQgcQknbL/F266ZaHvSYqyyFy6g3ojUqcMdHmSuz2JJj7g7F+CMTNq6E2FtPO5h3EG8kktZc4DGakJNr0ODYqtuZEGpF5iO9Gu2/Dqbvwn350+w1csOYvNIx5y8Mm0rWiYR6fRPQiQZjAcRteRS/gO+x58+sf09UeFHtNZ+HePUCxcGBjNAO9U1IqBKILc1BZ+TYIRFhzmUEIf8kJIDPXrxpnQsb7BQPnkd5ND9HezTIDUYKIkBApaRxD/anSe1D8fZ2AUb2twWAyV03c4OthRfvhF1IxxkY33FOunB2UQUt74KIxA8ykISKZlENAhxk81FHVpTOsr25+z0kaIOpKROUotu05tXc5FCJWHaWmWCVtxH39U67a3nIhcOTomMzFmG12qe4ICxVnNisZ9UgafOD/PnwTvXISn9PUtJY2+nVeZieD55YXLjQ704F/+PObo3Ks/OfB8cCua9mxLTniAMjMif7kLEqR+S4GMM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
index a28f1e99362c..3c8b990ee92f 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -623,9 +623,60 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
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
@@ -700,54 +751,9 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
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
2.55.0.795.g602f6c329a-goog


