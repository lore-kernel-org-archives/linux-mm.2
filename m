Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B73160A2619
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 22:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=KdKethW2
Received: by kanga.kvack.org (Postfix)
	id 9DC9A6B0614; Wed, 18 Nov 2026 17:37:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F1566B0616; Wed, 18 Nov 2026 17:37:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76D0C6B0617; Wed, 18 Nov 2026 17:37:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 393F26B0614
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:37:22 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 89BFDC08C3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:37:21 +0000 (UTC)
X-FDA: 85449702282.04.9C9D69C
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	by imf30.hostedemail.com (Postfix) with ESMTP id BB82680008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:37:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=KdKethW2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3nij-aggKCEcmvj2ujltpxxpun.lxvurw36-vvt4jlt.x0p@flex--dmatlack.bounces.google.com designates 209.85.210.69 as permitted sender) smtp.mailfrom=3nij-aggKCEcmvj2ujltpxxpun.lxvurw36-vvt4jlt.x0p@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795041439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KVjRZjTDUQlUGtechd3ID8jkuJ5EsKID0iByl55GGz4=;
	b=UfnAuyssYOTQwC7F8GHz41qjCZOJQhqTujnSHHIEhk3A+hgfDKfYQ0T54AMKjB0xc07Gdv
	y0S6rXjtWwCXAAXvwd/K9dIzqplmtmaJDmDUn/BxSpmrbC+Qm2+5PmNlkKrNRUEXpbxxjQ
	elU7c1iIhK9xtEGIsDZnJsC9qtHqGA0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=KdKethW2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3nij-aggKCEcmvj2ujltpxxpun.lxvurw36-vvt4jlt.x0p@flex--dmatlack.bounces.google.com designates 209.85.210.69 as permitted sender) smtp.mailfrom=3nij-aggKCEcmvj2ujltpxxpun.lxvurw36-vvt4jlt.x0p@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795041439;
	b=u5F637YqGvWaURH0Hsd41ve/1hnhfUe+9Mcylt3JQPLn1GO7YMiuK+8w5r9M3Ycjrkz3Kc
	LcbE3aV335ba1J2EG+F88ZYxPclSbSCow5UT8onmqlgXqFC2mMRMdG2W/i+Qx6qsyQLZSr
	QbXRDoYc7MtUERGvlLAu9MWJXFRS64E=
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-8628955a085so1847105a34.3
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795041439; x=1795646239; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KVjRZjTDUQlUGtechd3ID8jkuJ5EsKID0iByl55GGz4=;
        b=KdKethW2uRyJ53EktAhrRezGJVTr976fFMAksRYkeVk/yA/umQdv4h/x2WsdfxnGyd
         KRraxomNnlmH+4jcb2OPVjKDNEY+lx/XIyv00mRuBCiDcSn9ugJkbEksQnPDfhMl/Sic
         fzCv64wb6WIT/fg7MD+mQUv8WtecV8lrL672jpSvShzlVl5HlvNdIfYAPVT+lmZfMALv
         aQtSt9cQbThPWCP0KbpHfsEcjko+M6B6JRZRm2hCnEF1to5Qg7fFlu/sOZS4J/TKcMh1
         uvReyvLRFbNN/E/0mmAaPiOV8F8B6hHOQtiMs2PYirDuFQQIlW1y6kve2sJhLUtTS0D7
         BIkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795041439; x=1795646239;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KVjRZjTDUQlUGtechd3ID8jkuJ5EsKID0iByl55GGz4=;
        b=2x0ChJOZ/idT0VAkMs2zHVnyApHhN2CrdN5IGnScsO37BdCdcU2rxBCB5Ii+5lAwxp
         j/DaczNc4GprP0iWIRDEcpAMFR1ZcKoSO59GjBv8V/BrOl0P3BBxJbha47cPaIFVSFsl
         VXNLtdoKf2QdwlT3Y8OUpPaeyd2WRHSn+L9WIuHn7LKWnuTZ30gxa4Byd0xBU1m55bMo
         idTDzCB6d25S0F/nmlxkDTcwbdno1PSx5TjqRuNqmh1Ipwzgxrm0igSMdJlTwcQJcRby
         K2WKucEHy1xzQKqau/EQ0DZZUwt1frB6nIPliX1oq4JPhqAdyYVWipDwJ4KuMld/qI97
         eGgw==
X-Forwarded-Encrypted: i=1; AL+hErGeqnVbgonnLp58k3KqeCyLe75oBbdXEgpBTtvxWAKqC+6N4WR8CmeKwfPLyctbyMZsAfC+YySBsw==@kvack.org
X-Gm-Message-State: APuU4Z8Z1Msmr/NMZNDA0F4OquPPiGxPqLpLF1SKpGOuOORwJlk2GExN
	+akuAazCF+wRw1alJ3RA5Re+nhRYvo1uFZxDL9toAIUrOD87/WMKFFr4IZuDhABnpcv+pFA6Nlo
	e628L2FyWsWUldA==
X-Received: from ilb5-n2.prod.google.com ([2002:a05:6e02:5305:20b0:53c:e043:6f2d])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:13c4:b0:572:a102:ad54 with SMTP id 5614622812f47-5773d028248mr4248721b6e.40.1795041438457;
 Wed, 18 Nov 2026 14:37:18 -0800 (PST)
Date: Wed, 18 Nov 2026 22:37:00 +0000
In-Reply-To: <20261118223704.3286085-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261118223704.3286085-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118223704.3286085-10-dmatlack@google.com>
Subject: [PATCH v11 09/13] PCI: liveupdate: Adopt ACS controls in incoming
 preserved devices
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Alex Williamson <alex.williamson@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Down <chris@chrisdown.name>, Chris Li <chrisl@kernel.org>, 
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
X-Rspamd-Queue-Id: BB82680008
X-Stat-Signature: s4tu37zjwx6nkyy6tikpxgcmb1g3bg8e
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795041439-679385
X-HE-Meta: U2FsdGVkX18nx+wnD+L5OeO1o3rbOJF9IG/G21XmFGn5NKUdMfzxEJMXu5fqH+s5nYetxj19HLIymd3rPXvSe8wtd2m4hWpMEMvnxw3rv3Ly/E2XxECzqisBo9uU/KngvzSftVuR8LRIi/xhUj3LU1Ey6FRz4/4IBxjH67FUXXrY8lXPF28ov49JjEWsY+9LPvjD3/+89T2CnJ90C12W3kbYe1gQgOOVClcSvMv7lp5YIzFIXTIz9xRrW6gvTRcOSvXAEC7/piXU3TYntV09SZ86qj89esf8Ry9JXe+xMNZqW3+MX2zaaVN+u8UlpEugF7AOr4sd3S81kdhh5R0GGAmXYvxEaF2aGaoc8j1F/KNRPP6voJ6r90WilR9o2l7cdJuHdv+CuSOmSQ5+CxCDjF0di5ze4Z1Z7Xj+HKCXNeqAFdZa7Fft5oyBw65MMvgie0fQvhaSXyTXkKzNa9tj5lEwmUfQPH19CJckBDyvoKP2A59pBLu/YqBoJA/otoNF6EVufSLG7zS5ldxbu5sNQLzcJemwdbHg1Ovu1TDi/4T0tgLg+863xBHhMUipxYqxVag6fnBwR60FN8kEOOYuZSJrBANFlKYecOGpS6zsR92IkKm8yM1dsu7fnxeDfCrq6O1SOQ3LBDX17JfKtBFZFl2BNyU3cSmX1Ou27mqye+66OfGevrWpUoQVaZIoDya3PwPbPmQMb1xUG7RN2uaSoVM7o/F9zuGvFqwPSDTI5B3GpUUZ08ID+IfOjuXH8adUswyNufgE+1oE9Z97L1CyRAMK4ncCGgq6+taMWgMteaXyEXbbeguaGwkgsBPcMmWzZ80wZyUk2qD8AR5Yi9XqDkHEEzQtP17iB1KEYCQpF2czZPKUXJEQa9wQm6pxCslAxIl5u/GgWoSfjlgKZ4WvAUn2M0R8yygMTcyX0XTfCIHVUvwmpK/h6niGZQAxJ1xulrd249rBq2xRdweJNyT
 KNthfY2t
 WBmCXgmPA+qEpPXggzodPotXqHjC1s1vz2bOAqplr7JZIstbOHJgHECeESbF9RhsehjvbXMiL0kgPjGuPbaD13auPVtAqrvudSB/iyVHHyvQTXjFAWjPqDgLZvScsq89pU8ObDT8gsrgxAl3SjRWcVboFocJ4BTaWVUIpQyt9RgszZE28B/WDNVmZkrvKs3mX+Byr37Jjyhoc4O3+Po9f2xsgl6i3wm9cbYcXDjfIRtSk5tflzU81GV8CnA+0ojYUsHpqmrqf7eRqyqKOKXLownskQq2VfOSPj+WVUL3LU3fBJv/xX+q+xBMODbAddeCTl7FXGLS8uVK8ZHl9UgHlES3FvB1+XHCfcQO327d2Wc0oIXFbRKJDKIv/AT76zEXAydnEI97nJfP37m1m0qPcz9IQO7pLep0J0068B7ZNPnQtIwE8np+B5v+XgOaoAHw6gdGg1n8rNlGorEKU+cHSXXwLfDNKPaXuZHNxmkIf0dqTFI3HsIt9HgKZ97r6ZpWWe9tWQuYn0UJ7mv0Ovw5zHdmvGXgdWp4XdMLcPXcmLkxh7ttjog6mDODQTvF2WYU9acgtZhC9OkNoM00Wz79bbxpuMtcOUFBf4qYAxTDceooNJD8jK5/v3XGC+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Adopt Access Control Services (ACS) controls on all incoming preserved
devices (endpoints and upstream bridges) during a Live Update.

Adopting ACS controls avoids changing routing rules while memory
transactions are in flight from preserved devices. It also keeps IOMMU
groups from changing during or after Live Update.

The adopted controls are recorded by the pci_save_state() call in
pci_bus_add_device(), which runs before drivers bind, so they are
reapplied by pci_restore_state() if the device is reset. Allocate the
ACS save buffer for incoming preserved devices even if they match a
device-specific ACS quirk, since their adopted controls live in the ACS
capability, and panic if it could not be allocated.

To simplify ACS adoption, reject preserving any devices that require
quirks to enable ACS as those quirks would also have to take Live Update
into account. If such a quirk matches an incoming preserved device
anyway, e.g. because it was added in the new kernel, log a warning and
adopt the device's ACS controls regardless, rather than reprogram a
device in the path of a preserved device's memory transactions.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c | 75 ++++++++++++++++++++++++++++++++++++++++
 drivers/pci/liveupdate.h | 16 +++++++++
 drivers/pci/pci.c        | 13 +++++--
 3 files changed, 102 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 00d6fa5236e9..b99a88c2c199 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -123,6 +123,9 @@
  *
  *  * The device cannot be a Virtual Function (VF).
  *
+ *  * The device cannot require device-specific quirks to enable Access
+ *    Control Services (ACS).
+ *
  * Driver Binding
  * ==============
  *
@@ -174,6 +177,17 @@
  * bus, since the bus numbers of the failed bridge can no longer be read from
  * hardware and handing them to another bridge would let an unrelated device
  * inherit the BDF of a preserved device.
+ *
+ * Handling Preserved Devices
+ * ==========================
+ *
+ * The PCI core handles preserved devices differently in the following ways:
+ *
+ *  * The PCI core adopts all ACS controls enabled on incoming preserved devices
+ *    rather than assigning new ones, so TLP routing and IOMMU groups stay the
+ *    same after Live Update. Note that a device will use its adopted ACS
+ *    controls for the lifetime of its struct pci_dev (i.e. even after
+ *    pci_liveupdate_finish()).
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -189,6 +203,7 @@
 #include <linux/slab.h>
 
 #include "liveupdate.h"
+#include "pci.h"
 
 /**
  * struct pci_liveupdate_global - Global state for PCI Live Update support
@@ -540,6 +555,15 @@ static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
 		return -EINVAL;
 	}
 
+	/*
+	 * Do not preserve devices that rely on device-specific ACS equivalents
+	 * since that would complicate keeping ACS constant across Live Update.
+	 */
+	if (pci_need_dev_specific_enable_acs(dev)) {
+		pci_warn(dev, "Refusing to preserve device that relies on ACS quirks\n");
+		return -EINVAL;
+	}
+
 	if (dev_ser) {
 		/*
 		 * Endpoint devices can only be preserved once. Bridges are
@@ -816,6 +840,57 @@ void pci_liveupdate_finish(struct pci_dev *dev)
 }
 EXPORT_SYMBOL_GPL(pci_liveupdate_finish);
 
+/**
+ * pci_liveupdate_adopt_acs() - Adopt ACS controls
+ * @dev: The PCI device to adopt ACS controls for
+ *
+ * For devices preserved across a Live Update, leave the ACS controls
+ * established by the previous kernel alone instead of programming new ones.
+ * The adopted controls are recorded by the pci_save_state() call in
+ * pci_bus_add_device(), so they are reapplied by pci_restore_state() if the
+ * device is subsequently reset.
+ *
+ * Panics if the device has an ACS capability but no ACS save buffer, since the
+ * adopted controls would be lost on the first reset.
+ *
+ * Return: 0 if the ACS controls were adopted, or -EINVAL if the device was not
+ * preserved.
+ */
+int pci_liveupdate_adopt_acs(struct pci_dev *dev)
+{
+	/*
+	 * Check if the device was preserved over a previous Live Update (even
+	 * if it has already gone through pci_liveupdate_finish()). This ensures
+	 * that the device continues to use the ACS controls established by the
+	 * previous kernel.
+	 */
+	if (!dev->liveupdate.was_incoming)
+		return -EINVAL;
+
+	/*
+	 * The previous kernel does not preserve devices that require
+	 * device-specific quirks to enable ACS, so the controls being adopted
+	 * live entirely in the ACS capability. If such a quirk matches anyway
+	 * (e.g. it was added in the current kernel), ignore it rather than
+	 * reprogram a device in the path of a preserved device's memory
+	 * transactions.
+	 */
+	if (pci_need_dev_specific_enable_acs(dev))
+		pci_warn(dev, "Ignoring device-specific ACS quirk, adopting ACS controls from previous kernel\n");
+
+	/*
+	 * The adopted controls must be captured in the ACS save buffer so that
+	 * they are reapplied if the device is later reset. Without it, e.g.
+	 * because it could not be allocated, the first reset would silently
+	 * drop them.
+	 */
+	if (dev->acs_cap && !pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_ACS))
+		panic("%s: No ACS save buffer for preserved device\n",
+		      pci_name(dev));
+
+	return 0;
+}
+
 /**
  * pci_liveupdate_is_incoming() - Check if a device is incoming-preserved
  * @dev: The PCI device to check
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
index e5d2a19d2ca2..c643f2664296 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -15,6 +15,12 @@ void pci_liveupdate_setup_device(struct pci_dev *dev);
 void pci_liveupdate_cleanup_device(struct pci_dev *dev);
 bool pci_liveupdate_preserve_bus_numbers(void);
 bool pci_liveupdate_refuse_bus_numbers(struct pci_bus *bus, struct pci_dev *dev);
+int pci_liveupdate_adopt_acs(struct pci_dev *dev);
+
+static inline bool pci_liveupdate_was_incoming(struct pci_dev *dev)
+{
+	return dev->liveupdate.was_incoming;
+}
 #else
 static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
 {
@@ -34,6 +40,16 @@ static inline bool pci_liveupdate_refuse_bus_numbers(struct pci_bus *bus,
 {
 	return false;
 }
+
+static inline int pci_liveupdate_adopt_acs(struct pci_dev *dev)
+{
+	return -EINVAL;
+}
+
+static inline bool pci_liveupdate_was_incoming(struct pci_dev *dev)
+{
+	return false;
+}
 #endif
 
 #endif /* DRIVERS_PCI_LIVEUPDATE_H */
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index fc4307a2327d..ebc565b4780a 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -35,6 +35,8 @@
 #include <linux/aer.h>
 #include <linux/bitfield.h>
 #include <linux/suspend.h>
+
+#include "liveupdate.h"
 #include "pci.h"
 
 DEFINE_MUTEX(pci_slot_mutex);
@@ -1071,9 +1073,13 @@ static void pci_allocate_acs_save_buffer(struct pci_dev *dev)
 	/*
 	 * Devices that rely on device-specific quirks to enable an ACS
 	 * equivalent keep that configuration outside of the ACS Control
-	 * register, so they are configured from scratch on restore.
+	 * register, so they are configured from scratch on restore. The
+	 * exception is devices preserved across a Live Update, which always
+	 * adopt the ACS controls established by the previous kernel and need
+	 * the buffer to keep them across resets.
 	 */
-	if (pci_need_dev_specific_enable_acs(dev))
+	if (pci_need_dev_specific_enable_acs(dev) &&
+	    !pci_liveupdate_was_incoming(dev))
 		return;
 
 	/* dev->acs_cap is not set yet, pci_acs_init() runs later */
@@ -1170,6 +1176,9 @@ void pci_enable_acs(struct pci_dev *dev)
 	bool enable_acs = false;
 	int pos;
 
+	if (!pci_liveupdate_adopt_acs(dev))
+		return;
+
 	/* If an iommu is present we start with kernel default caps */
 	if (pci_acs_enable) {
 		if (pci_dev_specific_enable_acs(dev))
-- 
2.56.1.703.gf848ed807c-goog


