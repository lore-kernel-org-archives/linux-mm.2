Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAA1F606D80D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 00:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dGa3oejv
Received: by kanga.kvack.org (Postfix)
	id D78DF6B05B1; Thu,  5 Nov 2026 19:43:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D50336B05B6; Thu,  5 Nov 2026 19:43:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3F0D6B05B7; Thu,  5 Nov 2026 19:43:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 969C76B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:43:02 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 27C72140C99
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:02 +0000 (UTC)
X-FDA: 85402844604.26.F8D6BB4
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6404D160005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 00:43:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=dGa3oejv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3kiLtaggKCOkOXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3kiLtaggKCOkOXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793925780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9TeYNqUtAtF6n34aqlWHHhJICz9k52m76OgmaY1FMKQ=;
	b=3qorCbhYJF1K5ipFM21B85dX1rd6xzFbq8a7zcdlryJ4fFWYMnrKjil2CvHNp2LGROSj6i
	bVbvv8t12rqGLGQZnebf9sjIThTa214Sc3N7u5zxjvORtFVoZomhzDHAroEzel1PGCMfmA
	jnsOezH5HLwjW2rDjWNaa1t8fARDnb0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=dGa3oejv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3kiLtaggKCOkOXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3kiLtaggKCOkOXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793925780;
	b=7G1wvllrYPOSb5bm8m4ODaPQJ0LVlZwp//s5gI9oZjatcl85N13Wnk6NF7b6iiy7eHJg0A
	vzwSLuWJ/nYMt9T8JqB5+zb6hhNc3A8CBmALEZIWp3/e+uLrJ83D41rcycf83Tnb/EA1Jb
	neWT8sTV1rLnriWyVqvVEihW0mzq/04=
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4cc89e86e4dso86665b6e.2
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 16:43:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793925779; x=1794530579; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9TeYNqUtAtF6n34aqlWHHhJICz9k52m76OgmaY1FMKQ=;
        b=dGa3oejvOHJmo94uTartpG9HEr7Xup7usjg0pm6Iv0M7Gl/fAjHlQMuxP6aaQauEbo
         YpZ3ul07c6RKue580O953cgCbCK1602zFx3tcMR6JVpUWzsQDCOHEAQ9u2yY6FK3a+uU
         2IKnMubcQ16bJ6VBj5LN6aLWMH3v141Ylj+kfpaJTu6tSOhgfi2LELaCe+x9wadS2xfw
         EPcMXnKiqS07+Z3ejuRxur/Eluv7dIbPmkYRWR5arAqaRQ7jqUHGwf2Z7sEXL8AYcO7U
         9P4Nkf25eeT/CtLTCKFEOTw5Di39RZw2jrQqKGaDnzHKtrsyg3Wtoz8doXxmhiUaW49G
         F+TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793925779; x=1794530579;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9TeYNqUtAtF6n34aqlWHHhJICz9k52m76OgmaY1FMKQ=;
        b=YqSZVNA4WIh7cIqAtF49YIo9C39HcOYklrGMNTK+NMc8CeV0ZLoct87mgvSvi6M8MD
         suwHbDdeWapKS4B0Rjbu5oJln+3SNvtNc+PcbfQK98KtWdX7y8B8SzsNFiA7qjvC8bDd
         kyNp7eVtcUCXyYJku+Qk3/laqeFlqyZm55wTq+6bMP2GJbvEPx4xxuuIS8Dn+tJYl+09
         FZpVnFCE5CBTqIsSVAa5SyqHZvlss5ITPsh3Bh9hUIQhXXmnd1NQB9cbeGmLAcR5BA/Y
         yI0yipDGTROq8P5StbZ7NuToRzGzBreKULH8PEm/hdY2GzZ7FaPIMLwRqY7IslDaX9aO
         huAQ==
X-Forwarded-Encrypted: i=1; AKwUvBzPIhDv88+u/z9AO1BVaSs9jKpVcQAooYwMbCiTvGU6+6S5BbWUTlfeH9v9dBK170jMht9ohRJjkQ==@kvack.org
X-Gm-Message-State: APuU4Z9LotL/LjrN/sEz4vVOoYgfKnp5nKfu+0WuLsITqEv24no/H0zB
	B/xQzc/hkKEeAKzawTESdDgSB8DmsHSFzOvzTzHdXYxfSsKUfZfS2uZwDy5hfBztV3NcBf1rT3s
	h+XtCAZELy3YM+Q==
X-Received: from ilb5-n1.prod.google.com ([2002:a05:6e02:5305:10b0:524:59d2:f0f6])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1509:b0:561:fa43:1b17 with SMTP id 5614622812f47-567e156641dmr681989b6e.42.1793925778751;
 Thu, 05 Nov 2026 16:42:58 -0800 (PST)
Date: Fri,  6 Nov 2026 00:42:03 +0000
In-Reply-To: <20261106004218.604799-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261106004218.604799-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261106004218.604799-3-dmatlack@google.com>
Subject: [PATCH v2 02/17] PCI: Add an offset-indexed store for saved
 capability registers
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org
Cc: Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, David Matlack <dmatlack@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Lukas Wunner <lukas@wunner.de>, Mahesh J Salgaonkar <mahesh@linux.ibm.com>, Mike Rapoport <rppt@kernel.org>, 
	"Oliver O'Halloran" <oohall@gmail.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6404D160005
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: mmg8ucqkdipk3urj4embj3bjy8k1hupy
X-HE-Tag: 1793925780-969797
X-HE-Meta: U2FsdGVkX1/EZbsVVfs6HWbAztjEyYzLBlsst5Yi1q6py6QtUvNRMO+g/kR9v2vvMSWq2uJr8hk5WHge3tQ5PbWKiMYi0vHKF15gPDoWA89cPyl0ri3jfCSUR0U451FedOiTbsILJs1rma6jBoVHfdEXDM+6/IYz16VV+wdSKQw6WhVwO5jfPUCxV0sRv0ZFSfxtix/JWUGtovE0FtkX2oyLO8jDDrGNzmLyYBhuIM5zE2XAMx63d0K6dGWRC6YWtVMfEKXLuyk88Vhp5E8y+t1aMKbABVeAcFddzEd+RFjeegImmNijiZ4CJ3sE/14FB/gZqRM1s10gVhcoSZpRHPDxPubh1Lw+XSYjWthP/0lQY0FPoYGZErYFlTOv1EpBKgnuPItGryEagKOUSlTCy9rWz6EXZLgfdWII9E110Dx1i6uXk/W6cKgweAhbnttinfq7jM3U6mez/mrrVmLi6dXzu7YyAgsRmQuARo/eKMvF84yoW30pfxOGC4irL0baE3WFbgpmJhMqppp3LORpFk+vFAt3sKS9v691ztbxMwYy1C5r2DKoCM/wkdKIp6bSkPQxc8jXHAVSBSsMW76NcdoNPAOlDEv0rf0psIfcI+Hpb52DfRLqtBjstGxC1/HZk+36+tvYY63Ku4H9qpgp2fpHlFccfYmlZm9S4H42oQkzhciK41wLC79cXywWXhS7HMnyohPD8XF/DxED8GelpQ6dy0MYGBjKilOrZhpehd8euqw4lvX9afnQ6f7AyLnelBfJ1mCoY1zF3hkKXpkDhOWt2Ihl21+bxesZJu6epzkBcSd68DW+RMNzeeNgFjGxmphNV0kyL0Hz03vKJwXBNGOS1lShySPwXGcXkQHBvdPDfq46GeyedYHwSs+fQDJdd+v6Je7gdoW2B8rwAY5NaP3hyfMkhuJYyZzHNhR8uMCwOGv5bgyWC26sNtsH5acDcJ8dUBdUAdgmaPYapiB
 Xlyo0g+R
 GnlJnoSRYTHmA7zRDhdyUvL3VvSlHHT2d5w+kceNicG06TbauyLqYeTMumargznUwgRU1aJF+Dy08OnGo5YW/C7kw9Z8wVaTRIZKnM7eRS0WgHaFdJwSGKRV4PhRyQUtngQ3qU1IUrhhfS3cuEvmKkdhX6aesDpXMDXiLzV7IuzitQajjHtqEKP6srxZSvmKlXJJ/uJObPejZMBYmubQzfK/amryGpnn2QMj7W0z+YM3NuRAGyaz/IJtRq4zDdCe7Hsw+SYEQc8HM9ec/OibgoHG2Tv1wG5+Bhkhs7HDdrK8EXx1/IoRA9dVE0aKTFXylj9m8lFR/5th8j5hnubTs21PywPU2xwJ9Re8ZtFJyiU1OEQ79Qn73ZBYzTF3qpynFICy0jEssG5wN31uGKmSjhPddip/ogWnADxXTW4/zxeJR9STsQeqMvOnSwD7JEdSpGPlO7I24oL8Qny+2kgzmrjubIAheueuREcx1U3xPwWP27EzUib4qAr1a4rXcgTeBVU6O4YjO/GxHyvG05SQsE4ELMekVvp51vkF0r7FU4OGcZsF7AEDwmPfKe50DLpNIJ2GijMjmda+AbPKo+2t5SRMDKAWqOSUHWGpH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a per-device store for saved capability registers that is indexed by
the offset of the register in configuration space, and whose values are
allocated in one piece during device setup.

The store holds capability registers only. The configuration space header
continues to be saved in pci_dev.saved_config_space, which is embedded in
struct pci_dev so that saving it cannot fail.

Today each capability that has state to preserve across a reset owns a
separate save buffer, allocated by pci_add_cap_save_buffer() and found
by capability ID. The layout of each buffer is private to the code that
saves and restores that capability: a dense array of whichever registers
that code happens to save, in whichever order it saves them.

That has a few consequences:

  - Each capability allocates its own buffer, at ten call sites (plus
    one hand-built by a quirk) that can each fail independently. Three
    of them (AER, PTM, TPH) ignore the failure, and the save paths for
    those capabilities return quietly when the buffer is missing, so a
    failed allocation leaves the capability unsaved without any message.

  - The layout is defined by the kernel rather than by the device, so it
    changes whenever the core starts or stops saving a register.

  - Nothing ties a saved value back to the register it came from, which
    makes the buffers unusable outside the kernel version that produced
    them.

Reserve registers by configuration space offset during device setup
instead, and allocate the values in a single array once every capability
has been initialized. Reserving a register sets a bit in a per-device
bitmap indexed by DWORD, so a register's position in the store is
derived from the device's own layout, and "was this register saved?" is
a property of the store rather than of which buffers happened to be
allocated.

Embed the bitmap in struct pci_dev rather than allocating it. Every
device needs one during enumeration, so allocating it separately saves
nothing and only adds a failure path that every caller has to tolerate.
The values remain the one allocation, since their number is not known
until enumeration is complete.

Save registers a DWORD at a time, since configuration space reads have
no side effects, but restore them at their own width: neighbouring
registers within a DWORD may be RW1C or may not tolerate being written,
e.g. PCI_EXP_DEVCTL and PCI_EXP_DEVSTA share a DWORD.

Offsets and sizes can come from the device, so refuse a reservation that
runs past the end of configuration space without a WARN and let the
caller report it. WARN only on misuse that indicates a kernel bug, such
as restoring a register that was never reserved.

No capability uses this yet. Subsequent patches convert them one at a
time, after which the per-capability buffers are removed.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/Makefile     |   3 +-
 drivers/pci/pci.h        |  12 ++
 drivers/pci/probe.c      |   4 +
 drivers/pci/saved-caps.c | 273 +++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h      |  30 +++++
 5 files changed, 321 insertions(+), 1 deletion(-)
 create mode 100644 drivers/pci/saved-caps.c

diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index e8d003cb6757..278092ba2b6e 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -5,7 +5,8 @@
 obj-$(CONFIG_PCI)		+= access.o bus.o probe.o host-bridge.o \
 				   remove.o pci.o pci-driver.o search.o \
 				   rebar.o rom.o setup-res.o irq.o vpd.o \
-				   setup-bus.o vc.o mmap.o devres.o
+				   setup-bus.o vc.o mmap.o devres.o \
+				   saved-caps.o
 
 obj-$(CONFIG_PCI)		+= msi/
 obj-$(CONFIG_PCI)		+= pcie/
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 037c1674f164..6676177706ba 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -258,6 +258,18 @@ struct pci_cap_saved_state *pci_find_saved_cap(struct pci_dev *dev, char cap);
 struct pci_cap_saved_state *pci_find_saved_ext_cap(struct pci_dev *dev,
 						   u16 cap);
 
+void pci_saved_caps_finalize(struct pci_dev *dev);
+void pci_saved_caps_release(struct pci_dev *dev);
+int pci_reserve_saved_cap(struct pci_dev *dev, unsigned int off, unsigned int len);
+bool pci_saved_cap_reserved(struct pci_dev *dev, unsigned int off);
+void pci_save_cap_word(struct pci_dev *dev, unsigned int off);
+void pci_save_cap_dword(struct pci_dev *dev, unsigned int off);
+void pci_restore_cap_word(struct pci_dev *dev, unsigned int off);
+void pci_restore_cap_dword(struct pci_dev *dev, unsigned int off);
+bool pci_read_saved_cap_word(struct pci_dev *dev, unsigned int off, u16 *val);
+bool pci_read_saved_cap_dword(struct pci_dev *dev, unsigned int off, u32 *val);
+void pci_write_saved_cap_word(struct pci_dev *dev, unsigned int off, u16 val);
+
 #define PCI_PM_D2_DELAY         200	/* usec; see PCIe r4.0, sec 5.9.1 */
 #define PCI_PM_D3HOT_WAIT       10	/* msec */
 #define PCI_PM_D3COLD_WAIT      100	/* msec */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index debe0ad1ef68..62ce1e461098 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2476,6 +2476,7 @@ static void pci_release_capabilities(struct pci_dev *dev)
 	pci_rcec_exit(dev);
 	pci_iov_release(dev);
 	pci_free_cap_save_buffers(dev);
+	pci_saved_caps_release(dev);
 }
 
 /**
@@ -2685,6 +2686,9 @@ static void pci_init_capabilities(struct pci_dev *dev)
 
 	pcie_report_downtraining(dev);
 	pci_init_reset_methods(dev);
+
+	/* No capability may reserve saved registers after this */
+	pci_saved_caps_finalize(dev);
 }
 
 /*
diff --git a/drivers/pci/saved-caps.c b/drivers/pci/saved-caps.c
new file mode 100644
index 000000000000..92865891514e
--- /dev/null
+++ b/drivers/pci/saved-caps.c
@@ -0,0 +1,273 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Saved capability registers.
+ *
+ * The capability registers that the PCI core saves and restores across resets
+ * and power transitions are kept in a per-device store indexed by the offset
+ * of the register in the device's configuration space. The layout of the
+ * store is therefore described by the device rather than by the kernel, and
+ * does not change when the core starts or stops saving a given register.
+ *
+ * The store covers capability registers only. The configuration space header
+ * is saved in pci_dev.saved_config_space, which is embedded in struct pci_dev
+ * so that saving it cannot fail.
+ *
+ * Only registers that have been reserved during device setup are saved. All
+ * reservations must be made before the store is finalized, which lets the
+ * values be held in a single allocation.
+ *
+ * Registers are stored a DWORD at a time, since reading configuration space
+ * has no side effects and a DWORD read is always safe. Restoring is done at
+ * the width of the register being restored, because neighbouring registers
+ * within the same DWORD may not tolerate being written.
+ */
+
+#include <linux/bitmap.h>
+#include <linux/pci.h>
+#include <linux/slab.h>
+
+#include "pci.h"
+
+/*
+ * Return the slot holding the value saved for the DWORD containing @off, or
+ * NULL if there is nowhere to save it. Reservations that do not fit in the
+ * device's configuration space and a failure to allocate the values were
+ * reported during setup, so return NULL quietly for those. Reaching any other
+ * register that was not reserved is a kernel bug.
+ */
+static u32 *pci_saved_cap_slot(struct pci_dev *dev, unsigned int off)
+{
+	struct pci_saved_caps *caps = &dev->saved_caps;
+	unsigned int dword = off / sizeof(u32);
+
+	if (dword >= PCI_CFG_SPACE_EXP_DWORDS)
+		return NULL;
+
+	if (!test_bit(dword, caps->dword_map)) {
+		WARN_ONCE(!caps->incomplete,
+			  "%s: config space offset %#x was not reserved\n",
+			  pci_name(dev), off);
+		return NULL;
+	}
+
+	if (!caps->dword_val)
+		return NULL;
+
+	return &caps->dword_val[bitmap_weight(caps->dword_map, dword)];
+}
+
+/**
+ * pci_saved_cap_reserved - test whether a register can be saved
+ * @dev: the PCI device
+ * @off: offset of the register in configuration space
+ *
+ * Return: true if the DWORD containing @off has a slot in the store, false
+ * if nothing reserved it or the values could not be allocated.
+ */
+bool pci_saved_cap_reserved(struct pci_dev *dev, unsigned int off)
+{
+	struct pci_saved_caps *caps = &dev->saved_caps;
+	unsigned int dword = off / sizeof(u32);
+
+	if (!caps->dword_val || dword >= PCI_CFG_SPACE_EXP_DWORDS)
+		return false;
+
+	return test_bit(dword, caps->dword_map);
+}
+
+/**
+ * pci_reserve_saved_cap - reserve space to save a capability register
+ * @dev: the PCI device
+ * @off: offset of the register in configuration space
+ * @len: size of the register in bytes
+ *
+ * Reserve room to save the register at @off, which may then be saved with
+ * pci_save_cap_word() and friends. Must be called during device setup, before
+ * the store is finalized.
+ *
+ * Return: 0 on success, negative errno otherwise.
+ */
+int pci_reserve_saved_cap(struct pci_dev *dev, unsigned int off, unsigned int len)
+{
+	struct pci_saved_caps *caps = &dev->saved_caps;
+	unsigned int first, last;
+
+	if (WARN_ON(caps->finalized))
+		return -EBUSY;
+
+	/*
+	 * The configuration space header is saved in
+	 * pci_dev.saved_config_space, so only capability registers may be
+	 * reserved here.
+	 */
+	if (WARN_ON(!len || off < PCI_STD_HEADER_SIZEOF))
+		return -EINVAL;
+
+	/*
+	 * Capability sizes and table offsets can come from the device, so a
+	 * malformed or unresponsive device can describe a range that runs past
+	 * the end of configuration space. That is not a kernel bug, so fail
+	 * quietly and let the caller report it.
+	 */
+	if (off + len > PCI_CFG_SPACE_EXP_SIZE) {
+		caps->incomplete = true;
+		return -EINVAL;
+	}
+
+	first = off / sizeof(u32);
+	last = (off + len - 1) / sizeof(u32);
+
+	bitmap_set(caps->dword_map, first, last - first + 1);
+
+	return 0;
+}
+
+/**
+ * pci_save_cap_dword - save a 32-bit capability register
+ * @dev: the PCI device
+ * @off: offset of the register in configuration space
+ */
+void pci_save_cap_dword(struct pci_dev *dev, unsigned int off)
+{
+	u32 *slot = pci_saved_cap_slot(dev, off);
+
+	if (!slot)
+		return;
+
+	pci_read_config_dword(dev, ALIGN_DOWN(off, sizeof(u32)), slot);
+}
+
+/**
+ * pci_save_cap_word - save a 16-bit capability register
+ * @dev: the PCI device
+ * @off: offset of the register in configuration space
+ */
+void pci_save_cap_word(struct pci_dev *dev, unsigned int off)
+{
+	pci_save_cap_dword(dev, ALIGN_DOWN(off, sizeof(u32)));
+}
+
+/**
+ * pci_read_saved_cap_dword - read the saved value of a 32-bit register
+ * @dev: the PCI device
+ * @off: offset of the register in configuration space
+ * @val: where to store the saved value
+ *
+ * Return: true if a saved value was available, false otherwise.
+ */
+bool pci_read_saved_cap_dword(struct pci_dev *dev, unsigned int off, u32 *val)
+{
+	u32 *slot = pci_saved_cap_slot(dev, off);
+
+	if (!slot)
+		return false;
+
+	*val = *slot;
+
+	return true;
+}
+
+/* Bit offset of the register at @off within its containing DWORD */
+static unsigned int pci_saved_cap_shift(unsigned int off)
+{
+	return 8 * (off & (sizeof(u32) - 1));
+}
+
+/**
+ * pci_read_saved_cap_word - read the saved value of a 16-bit register
+ * @dev: the PCI device
+ * @off: offset of the register in configuration space
+ * @val: where to store the saved value
+ *
+ * Return: true if a saved value was available, false otherwise.
+ */
+bool pci_read_saved_cap_word(struct pci_dev *dev, unsigned int off, u16 *val)
+{
+	u32 dword;
+
+	if (!pci_read_saved_cap_dword(dev, ALIGN_DOWN(off, sizeof(u32)), &dword))
+		return false;
+
+	*val = dword >> pci_saved_cap_shift(off);
+
+	return true;
+}
+
+/**
+ * pci_write_saved_cap_word - change the saved value of a 16-bit register
+ * @dev: the PCI device
+ * @off: offset of the register in configuration space
+ * @val: value to save
+ */
+void pci_write_saved_cap_word(struct pci_dev *dev, unsigned int off, u16 val)
+{
+	unsigned int shift = pci_saved_cap_shift(off);
+	u32 *slot = pci_saved_cap_slot(dev, off);
+
+	if (!slot)
+		return;
+
+	*slot &= ~((u32)U16_MAX << shift);
+	*slot |= (u32)val << shift;
+}
+
+/**
+ * pci_restore_cap_dword - restore a 32-bit capability register
+ * @dev: the PCI device
+ * @off: offset of the register in configuration space
+ */
+void pci_restore_cap_dword(struct pci_dev *dev, unsigned int off)
+{
+	u32 val;
+
+	if (pci_read_saved_cap_dword(dev, off, &val))
+		pci_write_config_dword(dev, off, val);
+}
+
+/**
+ * pci_restore_cap_word - restore a 16-bit capability register
+ * @dev: the PCI device
+ * @off: offset of the register in configuration space
+ */
+void pci_restore_cap_word(struct pci_dev *dev, unsigned int off)
+{
+	u16 val;
+
+	if (pci_read_saved_cap_word(dev, off, &val))
+		pci_write_config_word(dev, off, val);
+}
+
+/**
+ * pci_saved_caps_finalize - allocate room for a device's saved registers
+ * @dev: the PCI device
+ *
+ * Called once every capability that reserves registers has been initialized.
+ * No register may be reserved after this.
+ */
+void pci_saved_caps_finalize(struct pci_dev *dev)
+{
+	struct pci_saved_caps *caps = &dev->saved_caps;
+
+	caps->finalized = true;
+
+	caps->nr_dwords = bitmap_weight(caps->dword_map, PCI_CFG_SPACE_EXP_DWORDS);
+	if (!caps->nr_dwords)
+		return;
+
+	caps->dword_val = kzalloc_objs(*caps->dword_val, caps->nr_dwords, GFP_KERNEL);
+	if (!caps->dword_val)
+		pci_err(dev, "unable to allocate %u saved capability registers\n",
+			caps->nr_dwords);
+}
+
+/**
+ * pci_saved_caps_release - free a device's saved capability registers
+ * @dev: the PCI device
+ */
+void pci_saved_caps_release(struct pci_dev *dev)
+{
+	struct pci_saved_caps *caps = &dev->saved_caps;
+
+	kfree(caps->dword_val);
+	caps->dword_val = NULL;
+}
diff --git a/include/linux/pci.h b/include/linux/pci.h
index b35ac263c451..2c27124c81e5 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -334,6 +334,35 @@ struct pci_vpd {
 	u8		cap;
 };
 
+/*
+ * Reservations are tracked for the largest configuration space a device can
+ * have, since quirks can still change pci_dev.cfg_size after the device has
+ * been enumerated.
+ */
+#define PCI_CFG_SPACE_EXP_DWORDS	(PCI_CFG_SPACE_EXP_SIZE / sizeof(u32))
+
+/**
+ * struct pci_saved_caps - a device's saved capability registers
+ * @nr_dwords: number of DWORDs reserved, i.e. entries in @dword_val
+ * @finalized: set once @dword_val has been allocated, after which nothing
+ *	       may be reserved
+ * @incomplete: set if the device described a register that does not fit
+ *		in its configuration space, so the reservation was refused
+ * @dword_val: saved values, in ascending configuration space offset order
+ * @dword_map: one bit per DWORD of configuration space, set if that DWORD
+ *	       has a slot in @dword_val
+ *
+ * Private to the PCI core, defined here only so that it can be embedded in
+ * struct pci_dev. Use the pci_{save,restore}_cap_*() accessors.
+ */
+struct pci_saved_caps {
+	u16		nr_dwords;
+	bool		finalized;
+	bool		incomplete;
+	u32		*dword_val;
+	unsigned long	dword_map[BITS_TO_LONGS(PCI_CFG_SPACE_EXP_DWORDS)];
+};
+
 struct irq_affinity;
 struct pcie_bwctrl_data;
 struct pcie_link_state;
@@ -521,6 +550,7 @@ struct pci_dev {
 	spinlock_t	pcie_cap_lock;		/* Protects RMW ops in capability accessors */
 	u32		saved_config_space[16]; /* Config space saved at suspend time */
 	struct hlist_head saved_cap_space;
+	struct pci_saved_caps saved_caps; /* Saved capability registers */
 
 #ifdef CONFIG_HOTPLUG_PCI_PCIE
 	unsigned int	broken_cmd_compl:1;	/* No compl for some cmds */
-- 
2.56.0.455.g6c5a503b38-goog


