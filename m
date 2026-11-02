Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 626F6606B1D1
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=N4/ivDCC
Received: by kanga.kvack.org (Postfix)
	id 8FFE76B064B; Mon,  2 Nov 2026 10:37:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B1776B064D; Mon,  2 Nov 2026 10:37:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74F126B064B; Mon,  2 Nov 2026 10:37:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CC566B064B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:37:17 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DBB2E1C1EFD
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:16 +0000 (UTC)
X-FDA: 85390582872.14.27C49BF
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1F7971C0005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="N4/ivDCC";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3Ka7oagcKCIY5szsx2rqyyqvo.mywvsx47-wwu5kmu.y1q@flex--vipinsh.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3Ka7oagcKCIY5szsx2rqyyqvo.mywvsx47-wwu5kmu.y1q@flex--vipinsh.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vbe7YkQSNXb/9uNAV7c/nc8RXxVT9Eq1KsmaqI9CwRI=;
	b=zWCCxyUFsfcPK6U3ApoHkHCa2QznKem/rtyuRibBWF8obN8eLDEMAinQ69YYOr9Wvp/bqG
	fqDd8g7PkRl7qUiDl1tGOU7fUG7UtpS+Te/Tvt8V3GfXq4TCRYiKsNqD3Nbb11DnYvwPg5
	nN0wAOo5sCgdrHNtxizjMw2i2dZyQxk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="N4/ivDCC";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3Ka7oagcKCIY5szsx2rqyyqvo.mywvsx47-wwu5kmu.y1q@flex--vipinsh.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3Ka7oagcKCIY5szsx2rqyyqvo.mywvsx47-wwu5kmu.y1q@flex--vipinsh.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633835;
	b=YYNd05RyR9L46ge/wQoUFbOhjgBqRRAjEJPEO796qZ8WE4DGbmX4pkfa+1q+cwATschXgi
	PuDqHqULuGaM3bIASHpKYhneJ54JwT6MVnM6azIXCCOIgztwLQ3m7abFhPX09DCVF2AkDq
	n9hzJEMTEvHLTK7Mxqo9mQ8ZxTnSPs8=
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2eb1f470a57so20749975ad.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:37:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633834; x=1794238634; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vbe7YkQSNXb/9uNAV7c/nc8RXxVT9Eq1KsmaqI9CwRI=;
        b=N4/ivDCCKg+wxyMh8AWsdFie6yvZshLh0Dkl2+x6JoYpaZkh3V+6cIHlM8brJ8MAIo
         aBXlvpLSLo6hZxBMQ97PM24An3uvstvUsJ9u16U3c/EcJPBk8t5/rzYARijnMBF7oYQU
         S6EkZVk1HpubN5tOyyvP62jOqbWzTSATvE57E45uHWE2TOfbuA/h59lPJJ/QOtr1Bxtw
         2HfOf27ITJNEXq40D41P74G2xUerwg2uOz6A4Fbb3EeJTproe+QjEe6En0Zf0UN4TsOx
         C/akINXFYDR4zzp0d25MrF6gjtTaNVRjImdVBD9AMuGu8zpyEwOhSGGtJKtdFVwLUzxA
         fFIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633834; x=1794238634;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Vbe7YkQSNXb/9uNAV7c/nc8RXxVT9Eq1KsmaqI9CwRI=;
        b=d0YALT3eXwi+YpBj1GHdj+1xN7TzFFLAEtoImSOqn/LsXsQyhFNPcB26Uo8VyK3+IA
         zrrPgEt/W44ydBPPC9Gs9doI4ZgprShNCkac1lvxlEN2eYa52b7ZfG0kBldbYLC6e0Gd
         OC/Kv8Kqx9ZsBPe8WPYvPdlAFUpPFLP4iFztISecukRSBCoCB3rgcQJIgefsuj++TPPc
         iDpaL+58HsQIwIa48vyUs6JvAxzsjMcbYH58GtrvzQtQ2GqInoReuZDjsjvzNe8DVVF9
         SUXT2MGrtyID/O8kCsR0zI6Xm0huwdk0KznelBkeYBvqroo5He9q8H4RY9sNX6WqMJJO
         0T1Q==
X-Forwarded-Encrypted: i=1; AKwUvBxB9dAtEpyX4buua+dK2sCVUtL/q2E5K0sWhasjiu6rWkR1d+Q6HPu1QZejuGlu4nbnnZwqF8ibhA==@kvack.org
X-Gm-Message-State: APuU4Z9+PPaXoA/+4A/09nVTGmZYavzDWZO/88r0cfvwnJ/eAAAOz/6a
	lmliQkixwu5ubiiWZEea0QGyvO/0j711K4OoAduRk1tjEMjJ3xMTAOCDCFp/c8o+nPeKVjzL6oM
	DvWx8zF+eWQ==
X-Received: from plkg13.prod.google.com ([2002:a17:903:19cd:b0:2e8:1f84:7c18])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:da8c:b0:2e9:4bf3:37a1
 with SMTP id d9443c01a7336-2eb36506822mr91361225ad.63.1793633833691; Mon, 02
 Nov 2026 07:37:13 -0800 (PST)
Date: Mon,  2 Nov 2026 07:36:42 -0800
In-Reply-To: <20261102153656.1431701-1-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261102153656.1431701-1-vipinsh@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102153656.1431701-14-vipinsh@google.com>
Subject: [PATCH v6 13/27] vfio/pci: Protect incoming preserved devices until
 they finish Live Update
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1F7971C0005
X-Stat-Signature: jc36ib8cct8qxmjhz53tq6pzbpedo5u1
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793633834-732740
X-HE-Meta: U2FsdGVkX1+Gw7Qd1GFn1xh5iiPPt1L+ZLjJ3aJoJWVcfDvm/4Kol9Rj2t4LzNjtQLOTfpHK+ZXGYeYe3TE4Aj9BgwS3oyZ2+05HToKfS1SyBhcwcuSJi649N3aeBpvJLntaTnAryeSdjXpzMVAjCirJauBfrnlqoWxRDcsqWW6iucf3k/vRhHmPXpRoKrpaOf2fSqneZPAVH0DipK4gOJjGkUVRnx4jwp3Zq/6qhkE8p+6myCh1/wJRN0kgPouavGNxjmWG8psRRNm1aOPiVIPEyQ1bbwMLU4JjJIv9bSwhh9tCKoFN1jHjHmIgmAJ+yrYGzGYKVJ+iDWK3MWFf1Xow+6A0LDqJ8qQIVJkEc1ppAEgaYxvYw7pmMHQRNPk9lTsJdoZvrkVYXBgvakhOMnCAlK8JvP7fB81Qphj5WH6UDpvHlKctrAxWDYJPGWbhxVIGWm0kLwb1192a24AP6TKMI28arl+aHPJdzDSaPjTl+NgNyRZPf5tzSj28Uzlt6IZH0Oq66diE7ksCTmXIiv5usTqNMYHN1YbsIFDHJU0AHx/aIi6CJMYmqntCMXdqsSic3KgHeWOQcJnLeQzNazlyZ6Yi/zzV5F0yFtLhxcL5PbdrjJdIzFHiv6K2PaBg/j2Rt5iyHY3W20FMz7m5/TPMjX5jrAj8/xkbmT8eqfZH8LQNnue38lrGz0dInWnw9qcfK31QzZs6+F6F1nuO2MrsNQpFlEyl8VlM0eo+cPi6gd3Cyl9KZ3jzh/6zNCJFSS1S/cKYOVSjnv8Pr1zWGepo4wCNKYJcxBVwJkrUTQhwXcFHWi5dLWdRtCBDoyNemPnArTm1YLGGwgFIv7OFCGUQW4qcimbwjBFnW9nvzDbMfImclkI6EtCzapaiM7mcTvAC8j4x7UtuQ2sXFVj5vl5zl3FMVUJl1Tl/oHIzPesxID+6vbeCzcuZK6LfPmAy6cCjQvHOlOvpxH4qtpL
 rLV6mzr8
 p8JTsvlNh1+gMEanDwZ+7/PvlRdl4s0hscYJVcYVSeA6z1J5xJRaq6pVM/W+Qcgo9ifdtLfIPPvmPsBuRHOAWwp51SrzJ7V/XoiSXAP/kp4l2WwRzilP+7hEl/tbleQK8bF6CDuL7er0QwjkCKgEQlxaB+p8xY1xRXnz2I5FRaHxpnWYiMyp99gtfIXpfyTxKEsZtKF0v+sHfKV9wDJHlT2SDxIM6CBjyoEBbCSnaELpJ9agESiak8uqZZXYO+IpGoV5vzXV7bUm2uVyXHiTL1026LIY2aNjsZW57nrJXo7Z7JBdP6ztcq8imv4KbZeaLPQkV5hEdNRARWocbTLSDcJWcddcOYnr9CJjgQpqOWmkXrvio2YYZczsDy0T5L/ET5OpmtWMbhIEPSYqvInJjl4i+nCg1+ttyKdlDkbvtl7R3k4nxAxzSO7sZmubExNGFUIPueHJmcurEqOioFII4lv0ci0ssptW2zjti63hGxGEKtSJVbZFtQWb5INbE7VbINsJZffK/xIZSqibOHhzYhPGRA9MEaB/vShFcOVNSJiVR4uRBlRtgD0tMfDmUVt9qQivvQv8aj/HGK0IirxnM8NavEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Protect incoming preserved devices that were kept running across kexec
from being disturbed before userspace either claims them or finishes the
Live Update session:

 * Runtime PM idle D3: In vfio_pci_init_dev(), when
   pci_liveupdate_is_incoming(pdev) is true, latch
   vdev->disable_idle_d3 = true and vdev->liveupdate_kept_running = true.
   Without this, vfio_pci_core_register_device() drops the runtime PM
   reference and allows the PCI runtime PM core to transition an idle
   incoming device into D3hot, stopping bus mastering and potentially
   triggering an internal reset on NoSoftRst- devices.

 * Non-noiommu boot fallback: In vfio_pci_core_register_device(), after
   vfio_register_group_dev() determines whether the device is in noiommu
   mode, if an incoming kept-running device is not in noiommu mode in
   this kernel, log a pci_warn(), clear PCI_COMMAND_MASTER immediately to
   stop untranslated DMA, and record liveupdate_stopped_early so
   finish() resets it without printing a duplicate warning.

 * Bus/slot reset guards: Refuse vfio_pci_dev_set_needs_reset() and
   vfio_pci_dev_set_hot_reset() (-EBUSY) while any device in the dev_set
   has liveupdate_kept_running set, preventing another device in the same
   dev_set from resetting an unclaimed kept-running device. When an
   unclaimed device finishes Live Update and no device in its dev_set is
   open, invoke vfio_pci_dev_set_try_reset() after clearing
   liveupdate_kept_running so devices without function-level reset still
   receive a bus/slot reset.

 * Unbind before finish: In vfio_pci_core_unregister_device(), if a
   still-unclaimed incoming device is unbound from vfio-pci before the
   session finishes (or if a concurrent finish() deferred its function
   reset via liveupdate_reset_pending), clear bus mastering, reset the
   function and restore config state via
   vfio_pci_core_liveupdate_reset_locked() under the device lock already
   held by remove(), and call pci_liveupdate_finish().

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 drivers/vfio/pci/vfio_pci.c            |  1 +
 drivers/vfio/pci/vfio_pci_core.c       | 19 +++++++-
 drivers/vfio/pci/vfio_pci_liveupdate.c | 16 +++++--
 drivers/vfio/pci/vfio_pci_priv.h       | 62 ++++++++++++++++++++++++--
 include/linux/vfio_pci_core.h          |  3 +-
 5 files changed, 91 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 9d48b250a5e8..d01b5cc9d4d2 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -139,6 +139,7 @@ static int vfio_pci_init_dev(struct vfio_device *core_vdev)
 	 */
 	vdev->nointxmask = nointxmask;
 	vdev->disable_idle_d3 = disable_idle_d3;
+	vfio_pci_liveupdate_init_dev(vdev);
 #ifdef CONFIG_VFIO_PCI_VGA
 	vdev->disable_vga = disable_vga;
 #endif
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 60ada3bbb6ff..828d620cf836 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -768,6 +768,15 @@ bool vfio_pci_core_liveupdate_reset(struct vfio_pci_core_device *vdev,
 	vdev->reset_works = reset_works;
 	vfio_pci_core_try_reset(vdev);
 
+	/*
+	 * Like vfio_pci_core_disable(), try a bus or slot reset for the devices
+	 * in the set that still need one, e.g. this device if it has no usable
+	 * function reset, or others whose reset was deferred while this device
+	 * was kept running. This device is not open, so none in the set may be.
+	 */
+	if (!vfio_device_set_open_count(vdev->vdev.dev_set))
+		vfio_pci_dev_set_try_reset(vdev->vdev.dev_set);
+
 	return !vdev->needs_reset;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_liveupdate_reset);
@@ -2399,6 +2408,8 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 	if (ret)
 		goto out_power;
 
+	vfio_pci_liveupdate_check_noiommu(vdev);
+
 	vfio_pci_core_debugfs_init(vdev);
 
 	return 0;
@@ -2642,7 +2653,8 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 	list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list) {
 		bool owned;
 
-		if (vfio_pci_dev_is_frozen(vdev)) {
+		if (vfio_pci_dev_is_frozen(vdev) ||
+		    vfio_pci_dev_is_kept_running(vdev)) {
 			ret = -EBUSY;
 			break;
 		}
@@ -2744,8 +2756,11 @@ static bool vfio_pci_dev_set_needs_reset(struct vfio_device_set *dev_set)
 	if (vfio_device_set_open_count(dev_set) > 1)
 		return false;
 
-	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list)
+	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
+		if (vfio_pci_dev_is_kept_running(cur))
+			return false;
 		needs_reset |= cur->needs_reset;
+	}
 	return needs_reset;
 }
 
diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
index 64810010f983..ad757acac400 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -457,7 +457,7 @@ vfio_pci_liveupdate_attach_incoming(struct vfio_pci_core_device *vdev,
 {
 	guard(mutex)(&vdev->vdev.dev_set->lock);
 
-	if (vdev->liveupdate_incoming || vdev->liveupdate_claimed ||
+	if (vdev->liveupdate_incoming || !vdev->liveupdate_kept_running ||
 	    !pci_liveupdate_is_incoming(vdev->pdev))
 		return -EBUSY;
 
@@ -558,8 +558,7 @@ static void vfio_pci_liveupdate_finish_vdev(struct vfio_pci_core_device *vdev,
 	bool was_reset;
 
 	scoped_guard(mutex, &vdev->vdev.dev_set->lock) {
-		if (!vdev->liveupdate_claimed &&
-		    pci_liveupdate_is_incoming(pdev)) {
+		if (vdev->liveupdate_kept_running) {
 			if (vdev->liveupdate_incoming) {
 				saved_state = vdev->liveupdate_incoming->saved_state;
 				vdev->liveupdate_incoming->saved_state = NULL;
@@ -572,6 +571,17 @@ static void vfio_pci_liveupdate_finish_vdev(struct vfio_pci_core_device *vdev,
 					saved_state = NULL;
 			}
 
+			/*
+			 * The device is stopped below, so stop shielding it from
+			 * the dev_set resets, including the fallback done by
+			 * vfio_pci_core_liveupdate_reset().
+			 */
+			vdev->liveupdate_kept_running = false;
+
+			/* A device stopped early was logged when it was stopped. */
+			if (vdev->liveupdate_stopped_early)
+				reason = NULL;
+
 			/*
 			 * An unbind of the device waits for the reference held
 			 * by finish() with the device lock held, so the reset
diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
index d8670dc51bb4..39ea26402312 100644
--- a/drivers/vfio/pci/vfio_pci_priv.h
+++ b/drivers/vfio/pci/vfio_pci_priv.h
@@ -169,6 +169,40 @@ static inline bool vfio_pci_dev_is_frozen(struct vfio_pci_core_device *vdev)
 	return smp_load_acquire(&vdev->liveupdate_frozen);
 }
 
+static inline bool vfio_pci_dev_is_kept_running(struct vfio_pci_core_device *vdev)
+{
+	return vdev->liveupdate_kept_running;
+}
+
+static inline void vfio_pci_liveupdate_init_dev(struct vfio_pci_core_device *vdev)
+{
+	struct pci_dev *pdev = to_pci_dev(vdev->vdev.dev);
+
+	if (pci_liveupdate_is_incoming(pdev)) {
+		vdev->disable_idle_d3 = true;
+		vdev->liveupdate_kept_running = true;
+	}
+}
+
+/*
+ * Called by probe once the device is registered, with the device lock held.
+ * retrieve() and finish() look the device up with that lock held, see
+ * vfio_pci_liveupdate_find_probed(), so they see the result of this check.
+ */
+static inline void
+vfio_pci_liveupdate_check_noiommu(struct vfio_pci_core_device *vdev)
+{
+	guard(mutex)(&vdev->vdev.dev_set->lock);
+
+	if (vdev->liveupdate_kept_running &&
+	    !vfio_device_is_noiommu(&vdev->vdev)) {
+		pci_warn(vdev->pdev,
+			 "Stopping device kept running across Live Update: not in noiommu mode\n");
+		pci_clear_master(vdev->pdev);
+		vdev->liveupdate_stopped_early = true;
+	}
+}
+
 static inline void
 vfio_pci_liveupdate_free_incoming(struct vfio_pci_core_device *vdev)
 {
@@ -196,7 +230,7 @@ vfio_pci_liveupdate_claim_incoming(struct vfio_pci_core_device *vdev)
 		return;
 
 	vfio_pci_liveupdate_free_incoming(vdev);
-	vdev->liveupdate_claimed = true;
+	vdev->liveupdate_kept_running = false;
 }
 
 static inline void
@@ -206,11 +240,17 @@ vfio_pci_liveupdate_unregister_dev(struct vfio_pci_core_device *vdev)
 
 	scoped_guard(mutex, &vdev->vdev.dev_set->lock) {
 		/*
-		 * Complete a reset that finish() could not do, see
-		 * vfio_pci_liveupdate_finish_vdev().
+		 * Reset a device unbound before finish(), or whose reset
+		 * finish() could not do, see vfio_pci_liveupdate_finish_vdev().
 		 */
-		if (vdev->liveupdate_reset_pending) {
+		if (vdev->liveupdate_kept_running ||
+		    vdev->liveupdate_reset_pending) {
+			if (vdev->liveupdate_kept_running &&
+			    !vdev->liveupdate_stopped_early)
+				pci_warn(pdev,
+					 "Resetting device not taken over after Live Update (vfio-pci unbound)\n");
 			vfio_pci_core_liveupdate_reset_locked(vdev);
+			vdev->liveupdate_kept_running = false;
 			vdev->liveupdate_reset_pending = false;
 		}
 		vfio_pci_liveupdate_free_incoming(vdev);
@@ -234,6 +274,20 @@ static inline bool vfio_pci_dev_is_frozen(struct vfio_pci_core_device *vdev)
 	return false;
 }
 
+static inline bool vfio_pci_dev_is_kept_running(struct vfio_pci_core_device *vdev)
+{
+	return false;
+}
+
+static inline void vfio_pci_liveupdate_init_dev(struct vfio_pci_core_device *vdev)
+{
+}
+
+static inline void
+vfio_pci_liveupdate_check_noiommu(struct vfio_pci_core_device *vdev)
+{
+}
+
 static inline void
 vfio_pci_liveupdate_free_incoming(struct vfio_pci_core_device *vdev)
 {
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index f5c279d0df1e..9bdbc8099bda 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -152,7 +152,8 @@ struct vfio_pci_core_device {
 #ifdef CONFIG_VFIO_PCI_LIVEUPDATE
 	bool			liveupdate_frozen;
 	bool			liveupdate_intx_disabled;
-	bool			liveupdate_claimed;
+	bool			liveupdate_kept_running;
+	bool			liveupdate_stopped_early;
 	bool			liveupdate_reset_pending;
 	struct vfio_pci_liveupdate_incoming *liveupdate_incoming;
 #endif
-- 
2.56.0.317.g454f8302e1-goog


