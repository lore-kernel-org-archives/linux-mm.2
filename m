Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7A18CD5BB1
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 20:24:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B09F96B00A3; Fri, 22 May 2026 16:24:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9AC46B00A5; Fri, 22 May 2026 16:24:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90CCC6B00A4; Fri, 22 May 2026 16:24:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 807BA6B00A2
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:24:22 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 510381C0178
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:24:22 +0000 (UTC)
X-FDA: 84796183164.14.8D3F244
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf16.hostedemail.com (Postfix) with ESMTP id 823DE180003
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:24:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e9Zo5Mir;
	spf=pass (imf16.hostedemail.com: domain of 3c7sQaggKCIQlui1tiksowwotm.kwutqv25-uus3iks.wzo@flex--dmatlack.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3c7sQaggKCIQlui1tiksowwotm.kwutqv25-uus3iks.wzo@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779481460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SPpQo5/8o8XmqfCxBMhae2hXoPWQwl78O5LFi9BXZl8=;
	b=5QGK1jEHjhYVXlpQKMELAkTuADMklgWBChNvRVNNdhFp0juyM69Xg8eL9px/OPhAT/sUmb
	D4y2Sji3XhpsIblBPzfbsHFvXP5pjO9HkXvKy77Z2VdgBr0PCp+GfWUo2zwr6coYshxwWI
	GjnZy0vsmHnbEm6pKlw/klvqy2lINxo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=e9Zo5Mir;
	spf=pass (imf16.hostedemail.com: domain of 3c7sQaggKCIQlui1tiksowwotm.kwutqv25-uus3iks.wzo@flex--dmatlack.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3c7sQaggKCIQlui1tiksowwotm.kwutqv25-uus3iks.wzo@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779481460; a=rsa-sha256;
	cv=none;
	b=IBuVNR8TUWwxIl8qT9RF0u3edGBQEGsLrK4ffo8svMsOtFjYfDHa+67Y23ja3TUlSUcTti
	ImcS633Ef+yASj9O2o1E+D9+Tdw4NRY02YEmqAksIuhP2RuSWDRuVSiEmj2UQ5N5d2yuAi
	hb3jOjO7S6wI14ovK472MpyWt9RxNiI=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2b4654f9bb6so79139945ad.2
        for <linux-mm@kvack.org>; Fri, 22 May 2026 13:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779481459; x=1780086259; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SPpQo5/8o8XmqfCxBMhae2hXoPWQwl78O5LFi9BXZl8=;
        b=e9Zo5MiroM6aCxWQWxcF7kj98ocgwzzcaBBqES1+AZqGkNhyResYxKOTRS4QZZh4Le
         RjRVYULj2dOUREpK4MXo3tfJRJZD71Q/gNtpgZq0YghwAopR1jAxYwnNdI2GKpbThBUw
         rXO7QBEvfNUZs8BHq5WJaXGYOboNOse/+mJCze81l6bq4stCInPWubL51Rmr1ev4zpYA
         B0Va51zLRwiguFNyg8Hl/RJIyrmlS9pq6lrZhXGe1qlRHXUaj0zEFHBaSoCQ69tOxxd4
         EfrV8CYByuqbPTpK4z+/YE0kCie7V3Ikf+gXUIVkOe9r8HjPyoP9exYqLX5xkE6BmhWk
         MShw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779481459; x=1780086259;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SPpQo5/8o8XmqfCxBMhae2hXoPWQwl78O5LFi9BXZl8=;
        b=G3j8BgmVt7+rxiRYWhekATN2mZZ1U7/plaOxZP5sk4EGzAkeRe1yRfwkA9j7YSHlH2
         6arWSs+SK39r7D1B5zb+JL2/Lgq6Biy2jBGPUiqUiwRZXf2J0ZlV1IXcUS0FxexoBkz1
         0SNLHDhgmuwdV8tXs047SY2Tncwq0mH7y5goCxnWJ90gnJ0KdsN/jEMCTEKJIpUQ8RJu
         /16zbfVw1aCAQgRiQVcMHjAYm6AV7L7cCbusOAbXxVddMp8I6z6v/7DObAD3TwBGZ6vu
         J0puGHtJ5KzSYHFK7rct7sjMn5dtzROELbks9lJ1dRYKoJQ/ixk6qZ7OJ+T/KJJNeDzz
         K1yQ==
X-Forwarded-Encrypted: i=1; AFNElJ+0Y+6av+a9jRal45n65X4wTW6lD1lx+rMdYRtSkusFcFxSxN1AV+K3sJl7VQVZdqbs+uPeyk7eOA==@kvack.org
X-Gm-Message-State: AOJu0YyCmQJ8R+KxsOiRYiPZkTWBbUMe1zDeJeNlrIykdqnwJIBK+qbK
	1cSAzulGa4iECninGRv9oKiwE7fst6In3tCV4+rOHGzxC7e/9CLmPVazKYFVOOeVQyJy0wjoQ35
	m/d3CT4AsNR4/WA==
X-Received: from plqu9.prod.google.com ([2002:a17:902:a609:b0:2bd:9b10:8067])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:354b:b0:2bc:db91:f5a7 with SMTP id d9443c01a7336-2beb0735023mr53621445ad.11.1779481459064;
 Fri, 22 May 2026 13:24:19 -0700 (PDT)
Date: Fri, 22 May 2026 20:24:06 +0000
In-Reply-To: <20260522202410.3104264-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260522202410.3104264-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260522202410.3104264-9-dmatlack@google.com>
Subject: [PATCH v6 08/12] PCI: liveupdate: Inherit ACS flags in incoming
 preserved devices
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 823DE180003
X-Stat-Signature: 3p7s9nd53gh5sc9cfinctmuf5f8dz4bn
X-HE-Tag: 1779481460-100998
X-HE-Meta: U2FsdGVkX1/FL6spUJwGttz37JAlcBv2+jHFw6XfFCoIhKonvJhnj+/IVb7goo9MWxuks+cI5TUBkm/eQx47QVKEXpRKSk5rV+Pg3Y9wJkRnbEHx/LJ7p4WsZH0Cfi3D9uMaLSFPTKBTIu7A4dBQbDAHPzOfTuDGRge66YfjIBYhQPRXfNep0UdCpV9tbPueb0KxhOl+8+rByQ+Ob8ShQBnUwoiUkBbM2nNC0jlmJc1tW24UCeslyg0ZPFt/x/OBMmhc0TBxxAQPjTKu/mCOS4J35XMuTVguTQdMHksVhgV2AKA/96J3PaUKhRcWB8Xjqahoe/bsxhQBxcSP623D48cbuv3acykYNe42+30SN9USzRWfHAFIAAgSNuZxjaQBFzV/os83G/gDbqpT0mG7/wZ6bv2fSlTRb+1JM8rCxLDHFNaHma8RqtqYgPhHCCGeVPCgK4OOT3B5Ha1B3qWODJuZTO5dtxCBDeTelHRS0X44LYbpOWixnhI8a4DOPpxrWoUUx8rKd1Tk35chmXjBkRcHGVG/aQYpus0jgzAMgL742wK8JwN1cczrp+AsUcCWdRthf3+X/D2HOMZ56uV9mW2z7Fyduu54MZwymMLHH/DqIiRjuAHLRa3Z6Xq+cUlY6tPl8rhDABh3x9kRrSVjSH4AhvYIeET7GLLolKvpDlc/5LGHd/nexlLSzPv+j+9nrw31q3EjbYSi+L8ooJbex+Fsnv6FVnLazCvlBuD/RwyyxcrbBJEbnJvhVFrIkGCH+/NU4b2tX4IrZ1GFQxVb1q7Acc4CulSeZBHeeyBH7cgUaMvnxfzg9VLEs5TS1bPK8RncH2zbaFsyxxchpY7iwH8EFc/KlmxnbkbvKC9ei5IjfToy0aKy36OwuYgq9jsOSFUXV7cgN80pqY7EExAGZdUHk7zewLhtabYq8IPVQjz2E3rulmLfFy64uO26acS+XyzK6FjExOV/oqcH0+g
 RuTrxvuB
 h2zvz9uvPIjOqq1adMa8bvQYOF/cb6eInJjsBZTNmFkuqA1UeCoods/0nptD/YoUOQzy62KL36qtRh+9VVmNCBR5yLwTSYrk8kKi1P+DItTmSs/PiQB9XL6YB1Pa8+ux/fO/qtupVcq4SUP+HjCxkvtmBdUzyB258I3itnIpF54DkA7Sy714fcTxAAdldea3CsiJbENPzZm++V6LTMBujhEHnwJ0pkxXdAL/Ikv7Q3uN1BkBNyIuaevL1AL6ZdqLnVpqKSAoVrdgkinOHIbJVMAIxbTP2ZdTzUssAYC1jkKQtCIDTU34v+8t2vkrQnlVbmqj48XwahUphKQMXcV9WNMT/YdysttgIyCPmBIhj3ngxDBIM3J80EZ8Jz4BaQk+n7pBcbdyOXNmq7kc6EQvoqavx2Y0QK7tNqLeVMr9XWYnAFSJsTDD3vaxicwd73pB3SO2OUrgp/jJ+OjbNMolvC3LQMbX33PeDMfly8YCg6VBRDAy1BCkgLiRGEHufnbnKtkPJcSFSiiBxPITUtGXYp8fmad09VQmajK8AQ69GKoBkgMZfK7G1qL8NmLfj+iad5FBv1COj8EiSNkKQhrJl6mSqvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Inherit Access Control Services (ACS) flags on all incoming preserved
devices (endpoints and upstream bridges) during a Live Update.

Inheriting ACS flags avoids changing routing rules while memory
transactions are in flight from preserved devices. This is also strictly
necessary to ensure that IOMMU group assignments do not change across
a Live Update for preserved devices, as changing ACS configurations can
split or merge IOMMU groups.

Cache the inherited ACS controls established by the previous kernel in
struct pci_dev so that ACS controls do not change after a reset
(pci_restore_state() calls pci_enable_acs()).

To simplify ACS inheritance, reject preserving any devices that require
quirks to enable ACS as those quirks would also have to take Live Update
into account.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c       | 68 ++++++++++++++++++++++++++++++++++
 drivers/pci/liveupdate.h       | 11 ++++++
 drivers/pci/pci.c              |  5 +++
 drivers/pci/pci.h              |  5 +++
 drivers/pci/quirks.c           |  7 ++++
 include/linux/pci_liveupdate.h |  6 +++
 6 files changed, 102 insertions(+)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 4c79e19b7f98..a93b7ef065f2 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -71,6 +71,9 @@
  *
  *  * The device cannot be a Virtual Function (VF).
  *
+ *  * The device cannot require device-specific quirks to enable Access
+ *    Control Services (ACS).
+ *
  * Driver Binding
  * ==============
  *
@@ -113,6 +116,18 @@
  * This enables the PCI core and any drivers bound to the bridge to participate
  * in the Live Update so that preserved endpoints can continue issuing memory
  * transactions during the Live Update.
+ *
+ * Handling Preserved Devices
+ * ==========================
+ *
+ * The PCI core treats preserved devices differently than non-preserved devices.
+ * This section enumerates those differences.
+ *
+ *  * The PCI core inherits all ACS flags enabled on incoming preserved devices
+ *    rather than assigning new ones. This ensures that TLPs are routed the same
+ *    way after Live Update and ensures that IOMMU groups do not change. Note
+ *    that a device will use its inherited ACS flags for the lifetime of its
+ *    struct pci_dev (i.e. even after pci_liveupdate_finish()).
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -126,6 +141,7 @@
 #include <linux/pci.h>
 
 #include "liveupdate.h"
+#include "pci.h"
 
 /**
  * struct pci_liveupdate_global - Global state for PCI Live Update support
@@ -319,6 +335,16 @@ static int __pci_liveupdate_preserve_device(struct pci_ser *ser, struct pci_dev
 {
 	int i;
 
+	/*
+	 * Do not preserve devices that rely on device-specific ACS equivalents
+	 * (for now) since that would complicate keeping ACS constant across
+	 * Live Update.
+	 */
+	if (pci_need_dev_specific_enable_acs(dev)) {
+		pci_warn(dev, "Refusing to preserve device that relies on ACS quirks\n");
+		return -EINVAL;
+	}
+
 	if (ser->nr_devices == ser->max_nr_devices)
 		return -ENOSPC;
 
@@ -598,6 +624,7 @@ void pci_liveupdate_setup_device(struct pci_dev *dev)
 
 	pci_info(dev, "Device was preserved by previous kernel across Live Update\n");
 	dev->liveupdate.incoming = dev_ser;
+	dev->liveupdate.was_preserved = true;
 
 	/*
 	 * Hold the ref on the incoming FLB until pci_liveupdate_finish() so
@@ -688,6 +715,47 @@ void pci_liveupdate_finish(struct pci_dev *dev)
 }
 EXPORT_SYMBOL_GPL(pci_liveupdate_finish);
 
+void pci_liveupdate_init_acs(struct pci_dev *dev)
+{
+	guard(rwsem_read)(&pci_liveupdate.rwsem);
+
+	if (!dev->acs_cap || !dev->liveupdate.incoming)
+		return;
+
+	pci_read_config_word(dev, dev->acs_cap + PCI_ACS_CTRL, &dev->liveupdate.acs_ctrl);
+}
+
+int pci_liveupdate_enable_acs(struct pci_dev *dev)
+{
+	u16 acs_ctrl = dev->liveupdate.acs_ctrl;
+	u16 acs_cap = dev->acs_cap;
+
+	/*
+	 * Use liveupdate.was_preserved instead of liveupdate.incoming since the
+	 * device's ACS controls should not change even after the device is
+	 * finished participating in the Live Update.
+	 */
+	if (!dev->liveupdate.was_preserved)
+		return -EINVAL;
+
+	/*
+	 * The previous kernel should not have preserved any devices that
+	 * require device-specific quirks to enable ACS, but if such a device is
+	 * detected, log a big warning and fall back to the normal enable ACS
+	 * path.
+	 */
+	if (pci_need_dev_specific_enable_acs(dev)) {
+		pci_warn(dev, "Device-specific quirk required to enable ACS!\n");
+		WARN_ON_ONCE(true);
+		return -EINVAL;
+	}
+
+	if (acs_cap)
+		pci_write_config_word(dev, acs_cap + PCI_ACS_CTRL, acs_ctrl);
+
+	return 0;
+}
+
 /**
  * pci_liveupdate_is_incoming() - Check if a device is incoming-preserved
  * @dev: The PCI device to check
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
index c763255a8de4..4e8a01bcb4bb 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -16,6 +16,8 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev);
 bool pci_liveupdate_scan_bridge_begin(struct pci_bus *bus, struct pci_dev *dev,
 				      int pass);
 void pci_liveupdate_scan_bridge_end(struct pci_dev *dev, int pass);
+void pci_liveupdate_init_acs(struct pci_dev *dev);
+int pci_liveupdate_enable_acs(struct pci_dev *dev);
 #else
 static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
 {
@@ -35,6 +37,15 @@ static inline bool pci_liveupdate_scan_bridge_begin(struct pci_bus *bus,
 static inline void pci_liveupdate_scan_bridge_end(struct pci_dev *dev, int pass)
 {
 }
+
+static inline void pci_liveupdate_init_acs(struct pci_dev *dev)
+{
+}
+
+static inline int pci_liveupdate_enable_acs(struct pci_dev *dev)
+{
+	return -EINVAL;
+}
 #endif
 
 #endif /* DRIVERS_PCI_LIVEUPDATE_H */
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 8f7cfcc00090..211df4618164 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -33,6 +33,7 @@
 #include <asm/dma.h>
 #include <linux/aer.h>
 #include <linux/bitfield.h>
+#include "liveupdate.h"
 #include "pci.h"
 
 DEFINE_MUTEX(pci_slot_mutex);
@@ -1017,6 +1018,9 @@ void pci_enable_acs(struct pci_dev *dev)
 	bool enable_acs = false;
 	int pos;
 
+	if (!pci_liveupdate_enable_acs(dev))
+		return;
+
 	/* If an iommu is present we start with kernel default caps */
 	if (pci_acs_enable) {
 		if (pci_dev_specific_enable_acs(dev))
@@ -3657,6 +3661,7 @@ void pci_acs_init(struct pci_dev *dev)
 
 	pci_read_config_word(dev, pos + PCI_ACS_CAP, &dev->acs_capabilities);
 	pci_disable_broken_acs_cap(dev);
+	pci_liveupdate_init_acs(dev);
 }
 
 /**
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 4a14f88e543a..b55f3deddd57 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -1062,6 +1062,7 @@ void pci_acs_init(struct pci_dev *dev);
 void pci_enable_acs(struct pci_dev *dev);
 #ifdef CONFIG_PCI_QUIRKS
 int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags);
+bool pci_need_dev_specific_enable_acs(struct pci_dev *dev);
 int pci_dev_specific_enable_acs(struct pci_dev *dev);
 int pci_dev_specific_disable_acs_redir(struct pci_dev *dev);
 void pci_disable_broken_acs_cap(struct pci_dev *pdev);
@@ -1072,6 +1073,10 @@ static inline int pci_dev_specific_acs_enabled(struct pci_dev *dev,
 {
 	return -ENOTTY;
 }
+static inline bool pci_need_dev_specific_enable_acs(struct pci_dev *dev)
+{
+	return false;
+}
 static inline int pci_dev_specific_enable_acs(struct pci_dev *dev)
 {
 	return -ENOTTY;
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 171caec2bc47..59b0b19c3783 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5482,6 +5482,13 @@ static const struct pci_dev_acs_ops *pci_dev_acs_ops_get(struct pci_dev *dev)
 	return NULL;
 }
 
+bool pci_need_dev_specific_enable_acs(struct pci_dev *dev)
+{
+	const struct pci_dev_acs_ops *p = pci_dev_acs_ops_get(dev);
+
+	return p && p->enable_acs;
+}
+
 int pci_dev_specific_enable_acs(struct pci_dev *dev)
 {
 	const struct pci_dev_acs_ops *p = pci_dev_acs_ops_get(dev);
diff --git a/include/linux/pci_liveupdate.h b/include/linux/pci_liveupdate.h
index 2be98819e313..2446c6d237ca 100644
--- a/include/linux/pci_liveupdate.h
+++ b/include/linux/pci_liveupdate.h
@@ -17,14 +17,20 @@
  * struct pci_liveupdate - PCI Live Update state for a struct pci_dev
  * @outgoing: State preserved for the next kernel.
  * @incoming: State preserved by the previous kernel.
+ * @acs_ctrl: ACS features established by the previous kernel.
  * @inherit_buses: True if the PCI core should inherit the secondary and
  *                 subordinate bus numbers assigned to this device due to
  *                 an ongoing Live Update.
+ * @was_preserved: True if this struct pci_dev was preserved by the previous
+ *                 kernel. Unlike @incoming, this field is not cleared after
+ *                 the device is finished participating in Live Update.
  */
 struct pci_liveupdate {
 	struct pci_dev_ser *outgoing;
 	struct pci_dev_ser *incoming;
+	u16 acs_ctrl;
 	bool inherit_buses;
+	bool was_preserved;
 };
 
 struct pci_dev;
-- 
2.54.0.746.g67dd491aae-goog


