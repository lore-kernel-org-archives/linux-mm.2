Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DC32C54F57
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 22:10:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 678E86B0093; Tue, 28 Jul 2026 18:10:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 650B76B0095; Tue, 28 Jul 2026 18:10:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53F4D6B0096; Tue, 28 Jul 2026 18:10:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 117F76B0095
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 18:10:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 754CD1C0D44
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:10:25 +0000 (UTC)
X-FDA: 85039580010.12.50C75B3
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by imf11.hostedemail.com (Postfix) with ESMTP id B5DB040011
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:10:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=r8ZYLs75;
	spf=pass (imf11.hostedemail.com: domain of 3zihpaggKCB88H5OG57FBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--dmatlack.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3zihpaggKCB88H5OG57FBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785276623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZGAhZMzqBLCDQKhaJ1H7fxzxpkTMhw4CZknznVqC8zM=;
	b=eTfqwdQxMk6WOMtrcZcSk1NBEXWC5xEDfHzaitd3qmm8DXCEH3nWa/8asNcrLU+WQs2aXu
	3/ld4V9VCDPe0M4g+7ljsEWTIAkrO9jo+u+zvX+GiYDaU8POBiVxqpgILE635SpvnbhR7g
	N7yD8ljgqTZQ3E3xg30rLT0RUVvMCdM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785276623;
	b=cuqpCBEcK9pMwg8sRobTq9FBfg5OyNjt7TDAD7KYIGuHgFPyYY1YyKPLECuvx3rvxa72+t
	Zn4yUDkR4sQcrXN1w8sJKE3W2z+Uw27tJGmhWx7yacxIq6z3RIoSFOlkSbUKCKx60QJKJk
	1EdwJ61IQ5GhYpBSERbM7UraTTg4zTI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=r8ZYLs75;
	spf=pass (imf11.hostedemail.com: domain of 3zihpaggKCB88H5OG57FBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--dmatlack.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3zihpaggKCB88H5OG57FBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8482b95574dso368413b3a.1
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785276623; x=1785881423; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZGAhZMzqBLCDQKhaJ1H7fxzxpkTMhw4CZknznVqC8zM=;
        b=r8ZYLs75EzqepNDC/w2AMcIP6iTUuX9pYzGMUMpuPUgmOFyc3w/h6zUayQhtv3Z7FU
         GT+zpw1rlsi6ewZ6K2F69DerbZKDYTE+vO/R3ql1QolqNxA8XFOm/d5qyniiZfssmOSh
         scvoj5F1slNX1o94rKnfPg7lIbdVIwQgwOc9WoCBIfQA0PUa+6WMZ3600D6BVE/uXBrm
         QZ+TjXkpMo3a0VCBclp1wRvqbwWV9FyqPhibJT7KmeEyPCslaDJTaRjegxzCsAVwGcAN
         N/PcqzkBN2SgS8NPKqYEjhZ3uH4gDxRTwl8CuFtEOLg3dK+qpvKhtC/hiW9HJqw+IWhk
         geXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785276623; x=1785881423;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZGAhZMzqBLCDQKhaJ1H7fxzxpkTMhw4CZknznVqC8zM=;
        b=g+9sDSxfrEhU2EeKsl870LR3S+F01DBpd3P8YGclvW9xKrG29So4W/9vZD8ib8V9go
         iwxQFH9GntK55pXWX1D6Nhv1v5CmsLfqLZj88gUXt7B9cTzjMPRiJldalDZmE1AwpzWO
         IenhxSfUgfdldeqFuKOwY0JbEhDCg34I+uqyOTqBYGwKgkU/EYEX6jjcstZZMMi1phB0
         lV/l6rcS6uSFS9QNiUBnSaLXAwBu18B7UcJZc5c4iA/6d0/dE1NYTHiKwg+lfc8upK2m
         zxhj7zp70kb90+/RIBWZlwcj8zcMw5tw6cUnAQPrvKQ2TLYlI38bNXa09bM+4bWVhmyS
         AGGw==
X-Forwarded-Encrypted: i=1; AHgh+RrFqxj172GumwgTmyMuLa6ffPUf/HI843Bxt9l/5dftdKKQgzCg+sGuTbd4mJNP1Yxia2BktF6n8A==@kvack.org
X-Gm-Message-State: AOJu0YzSNBu8E/bAoJblSuhm3VQE/S1CH7OIH3HJey6QEpzhpIzUirzg
	WBpac7qyE82OM6bLpL4P9GAcXKQeH9Znh30QcYHrpSs0m73JHC3qz8+bnc/5GjKM4z6gDcS0wYo
	8ISZFy847sGLf1g==
X-Received: from pfhx23.prod.google.com ([2002:a05:6a00:1897:b0:848:4e44:7f19])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:a222:b0:848:584f:7e41 with SMTP id d2e1a72fcca58-84e933ada35mr4409226b3a.78.1785276622323;
 Tue, 28 Jul 2026 15:10:22 -0700 (PDT)
Date: Tue, 28 Jul 2026 22:09:56 +0000
In-Reply-To: <20260728221007.2098560-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260728221007.2098560-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.487.gaf234c4eb3-goog
Message-ID: <20260728221007.2098560-3-dmatlack@google.com>
Subject: [PATCH v8 02/12] PCI: liveupdate: Track outgoing preserved PCI devices
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
X-Stat-Signature: 7dam5a6rbjfst46asep99a8j8xuoeb3r
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B5DB040011
X-HE-Tag: 1785276623-879475
X-HE-Meta: U2FsdGVkX1+NfzMMSQqWtBYStOvsxRH4XRIKIXB+cWuS8TjeGNI3+fKdNgF54WJsAHzP/ApSohmnNHVl2QkrnY5clqGhCjwUGGbhrlJiVQKRHp06HuUqcbe4l2FdaCPa+Y94h56nrkSHrHXSI9tlMX201/xhl2zUsAOaACIsUl+sxqBXdXLQN4r0REmu38B/SQ4C3Khpk9H7B4Mv1l+FRD73Ht6qC+v2jI7M48PaCgOl2IDGG63kzY5fRT3OOtVre7eGfXI9pP442umJvmAN2P8XT6Xoy1KDZ37S2sl/9v3jplH5jKKbPYpp5J3aM/SpBG3I0V7eUCLEPZfLhBbdShP59iEva+bfVdy7kqq44nINOgRaGQskVTMcQFUOWMONlQMzFiqyKcAI+pk+Yw0LUxPM/EtawvvVoHqdMfRTGqeWU5BdLGw6SrvrsIjO9VDcBIPqglNatWPTRx3qCtTXakkB3rEMQMUzwo/7P0I6WAmevmqelLmMbWaVEmd8LtFnav7O7wcSTi7Cq6f6jbH0xB3WW3Sl52LYGKJJGPTrN2Icy7gCKNwJ/pm0ke/j/VPPp3E7VixxnBDcW072/PO4ApxL2LFtUXm9MdMChHHWcYaGHt/7bHr23rtsFneqeHsbP6mlyH0ARIhriCuUEac7wjJxR/YDrTO7nHwXvUiCK6HtWRYKGzq9VHQi7J25P2pIE/qMFdSb7GHXFJFpYSM29xrH8H1J0FsPMIfvl9QqNFlIDyz8MVTZmTcpCboGZhBWdmCMHcIcL7SoS2x7HPYIxf4BUNhh9tCs9h+DFm23z/LXNE/CjcM76W2cFEVPMhVHGEMlrsBz1KAlcXyiAKXGEaHTy/vVT129T7m3FCld9TlZR1zVWUsRK6d2CoFO1iexfxpUROpwbzqnE9evnqoQhEB6XjW3f1EIeRki51OCV+pn9xevfPTbn36rmNUd4J+I3+TCzMYVdg2iib1jAEH
 NrK2RdoU
 icXEGjMyuKMTIUVbmgdL10rugQLwvxnV0osATwBBCFMWmK1JVbenjeMuR/rZMV5/wNNS67l9OMYgjPHSajxUqnjKasd5OKhcaKENurHaKvN5H1Ov60hJ/fKl0l1Nuspy5od6c72ZBOdKBbh5hcvHrNqPHTPYRyKSxdVGGArbk2HPIwzn7VQtY2HEvbj9aYyufmLaXjz89AaeMLjg/j/WwfNtKE2rb5RrvZRcDXyspTisP2M6FPpegpGaaTv7GgIB2GtPWZ8pc8KsP4lhX0zBFf3h+QFuDN8KEROF9s4GQz4HSjiWK16aKoUBvAoPglNIhEX7HM1e0kl13o0YaTU/ObmseJ3LWP71GLXVsTyHMwfRipVHeMiL6fT9pU/cSBLMNbJ983qdMJ4idqoptrHAFakBbA3U2+susoIrU3pHTy+Cyj9f5EOYYxL1Cf5jYq3m79b9zKVuHc4zm8Q1CORBWnMTqMtoyC3Aw2Q8nRAkdG7ORy/OIyuyd8foG396/pHlrF8FIibwF7bE6Lc10uUGimjVgGeZDqbeCIIyGEJm6ncL2LeqnGyO1y2hM116qOzgsq6sZ6nv72VB/+KFgTUcfz/pzj2N2u5wUKUD5+35Bj/WZK4LyMdDc2EoszUP/Ckz9HIuT4+EE6V5ox4rViDlDzM0YoG5Prae1onjuHpwdCTpnfzTFFJAZNVK5rA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add APIs to allow drivers to notify the PCI core of which devices are
being preserved across a Live Update for the next kernel, i.e.
"outgoing" devices.

Drivers must notify the PCI core when devices are preserved so that the
PCI core can update its FLB data (struct pci_ser) and track the list of
outgoing devices. pci_liveupdate_preserve() notifies the PCI core that a
device must be preserved across Live Update. pci_liveupdate_unpreserve()
reverses this (cancels the preservation of the device).

This tracking ensures the PCI core is fully aware of which devices may
need special handling during shutdown and kexec, and so the list of
preserved devices can be handed off to the next kernel.

For now, the API only supports preserving non-VF devices on a root bus
(not behind an PCI-to-PCI bridges).

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c       | 210 +++++++++++++++++++++++++++++++++
 drivers/pci/liveupdate.h       |  21 ++++
 drivers/pci/probe.c            |   2 +
 include/linux/pci.h            |   3 +
 include/linux/pci_liveupdate.h |  21 ++++
 5 files changed, 257 insertions(+)
 create mode 100644 drivers/pci/liveupdate.h

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index fffb41a66ca7..b003b7069cdb 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -36,6 +36,27 @@
  *
  *  * ``pci_liveupdate_register_flb(driver_file_handler)``
  *  * ``pci_liveupdate_unregister_flb(driver_file_handler)``
+ *
+ * Device Tracking
+ * ===============
+ *
+ * Drivers must notify the PCI core when specific devices are preserved or
+ * unpreserved with the following APIs:
+ *
+ *  * ``pci_liveupdate_preserve(pci_dev)``
+ *  * ``pci_liveupdate_unpreserve(pci_dev)``
+ *
+ * This allows the PCI core to keep its FLB data (struct pci_ser) up to date
+ * with the list of **outgoing** preserved devices for the next kernel.
+ *
+ * Restrictions
+ * ============
+ *
+ * The PCI core enforces the following restrictions on which devices can be
+ * preserved. These may be relaxed in the future:
+ *
+ *  * The device cannot be a Virtual Function (VF).
+ *  * The device cannot be behind a PCI-to-PCI bridge.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -50,6 +71,21 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 
+#include "liveupdate.h"
+
+/**
+ * struct pci_liveupdate_global - Global state for PCI Live Update support
+ * @rwsem: Reader/writer semaphore used to protect the incoming and outgoing
+ *         FLBs, and the references to them in struct pci_dev.
+ */
+struct pci_liveupdate_global {
+	struct rw_semaphore rwsem;
+};
+
+static struct pci_liveupdate_global pci_liveupdate = {
+	.rwsem = __RWSEM_INITIALIZER(pci_liveupdate.rwsem),
+};
+
 /**
  * struct pci_flb_outgoing - Outgoing PCI FLB object
  * @ser: Pointer to the preserved struct pci_ser.
@@ -128,6 +164,180 @@ static struct liveupdate_flb pci_liveupdate_flb = {
 	.compatible = PCI_LUO_FLB_COMPATIBLE,
 };
 
+static void pci_liveupdate_flb_put_outgoing(void)
+{
+	liveupdate_flb_put_outgoing(&pci_liveupdate_flb);
+}
+
+static struct pci_flb_outgoing *pci_liveupdate_flb_get_outgoing(void)
+{
+	struct pci_flb_outgoing *outgoing = NULL;
+	int ret;
+
+	ret = liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **)&outgoing);
+	if (ret)
+		return ERR_PTR(ret);
+
+	if (!outgoing)
+		return ERR_PTR(-ENOENT);
+
+	return outgoing;
+}
+
+static struct pci_dev_ser *pci_flb_alloc_dev_ser(struct pci_flb_outgoing *outgoing)
+{
+	struct pci_dev_ser *dev_ser;
+	struct kho_block_set_it it;
+	u64 count = 0;
+	int err;
+
+	kho_block_set_it_init(&it, &outgoing->block_set);
+
+	/* Try to find an existing, previously unpreserved, entry. */
+	while ((dev_ser = kho_block_set_it_read_entry(&it))) {
+		if (!dev_ser->refcount)
+			return dev_ser;
+
+		count++;
+	}
+
+	/* Otherwise grow the block set and reserve a new entry. */
+	err = kho_block_set_grow(&outgoing->block_set, count + 1);
+	if (err)
+		return ERR_PTR(err);
+
+	if (!count)
+		kho_block_set_it_init(&it, &outgoing->block_set);
+
+	/* This should always succeed since kho_block_set_grow() succeeded. */
+	dev_ser = kho_block_set_it_reserve_entry(&it);
+	if (WARN_ON_ONCE(!dev_ser))
+		return ERR_PTR(-ENOSPC);
+
+	return dev_ser;
+}
+
+static void pci_liveupdate_unpreserve_device(struct pci_flb_outgoing *outgoing,
+					     struct pci_dev *dev)
+{
+	struct pci_dev_ser *dev_ser = dev->liveupdate.outgoing;
+
+	if (!dev_ser) {
+		pci_warn(dev, "Cannot unpreserve device that is not preserved\n");
+		return;
+	}
+
+	pci_info(dev, "Device will no longer be preserved across next Live Update\n");
+	outgoing->ser->nr_devices--;
+	memset(dev_ser, 0, sizeof(*dev_ser));
+	dev->liveupdate.outgoing = NULL;
+}
+
+static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
+					  struct pci_dev *dev)
+{
+	struct pci_dev_ser *dev_ser;
+
+	if (dev->is_virtfn) {
+		pci_warn(dev, "Cannot preserve Virtual Functions\n");
+		return -EINVAL;
+	}
+
+	if (dev->liveupdate.outgoing) {
+		pci_warn(dev, "Device is already preserved\n");
+		return -EBUSY;
+	}
+
+	if (!pci_is_root_bus(dev->bus)) {
+		pci_warn(dev, "Cannot preserve devices behind bridges\n");
+		return -EINVAL;
+	}
+
+	dev_ser = pci_flb_alloc_dev_ser(outgoing);
+	if (IS_ERR(dev_ser))
+		return PTR_ERR(dev_ser);
+
+	pci_info(dev, "Device will be preserved across next Live Update\n");
+	outgoing->ser->nr_devices++;
+	outgoing->ser->devices = kho_block_set_head_pa(&outgoing->block_set);
+
+	dev_ser->domain = pci_domain_nr(dev->bus);
+	dev_ser->bdf = pci_dev_id(dev);
+	dev_ser->refcount = 1;
+
+	dev->liveupdate.outgoing = dev_ser;
+	return 0;
+}
+
+/**
+ * pci_liveupdate_preserve() - Preserve a PCI device across Live Update
+ * @dev: The PCI device to preserve.
+ *
+ * pci_liveupdate_preserve() notifies the PCI core that a PCI device should be
+ * preserved across the next Live Update. Drivers are expected to call
+ * pci_liveupdate_preserve() from their struct liveupdate_file_handler
+ * preserve() callback to ensure the outgoing struct pci_ser is already set up.
+ *
+ * Returns: 0 on success, <0 on failure.
+ */
+int pci_liveupdate_preserve(struct pci_dev *dev)
+{
+	struct pci_flb_outgoing *outgoing = NULL;
+	int ret;
+
+	guard(rwsem_write)(&pci_liveupdate.rwsem);
+
+	outgoing = pci_liveupdate_flb_get_outgoing();
+	if (IS_ERR(outgoing))
+		return PTR_ERR(outgoing);
+
+	ret = pci_liveupdate_preserve_device(outgoing, dev);
+
+	pci_liveupdate_flb_put_outgoing();
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_preserve);
+
+/**
+ * pci_liveupdate_unpreserve() - Cancel preservation of a PCI device
+ * @dev: The PCI device to unpreserve.
+ *
+ * pci_liveupdate_unpreserve() notifies the PCI core that a PCI device should no
+ * longer be preserved across the next Live Update. Drivers are expected to call
+ * pci_liveupdate_unpreserve() from their struct liveupdate_file_handler
+ * unpreserve() callback to ensure the outgoing struct pci_ser is already set
+ * up.
+ */
+void pci_liveupdate_unpreserve(struct pci_dev *dev)
+{
+	struct pci_flb_outgoing *outgoing = NULL;
+
+	guard(rwsem_write)(&pci_liveupdate.rwsem);
+
+	outgoing = pci_liveupdate_flb_get_outgoing();
+	if (IS_ERR(outgoing)) {
+		pci_warn(dev, "Cannot unpreserve device without outgoing Live Update state\n");
+		return;
+	}
+
+	pci_liveupdate_unpreserve_device(outgoing, dev);
+	pci_liveupdate_flb_put_outgoing();
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
+
+void pci_liveupdate_cleanup_device(struct pci_dev *dev)
+{
+	/*
+	 * It should be safe to READ_ONCE() outside of the rwsem during cleanup
+	 * since there should no longer be any references to @dev on the system.
+	 *
+	 * This should never happen in practice. Drivers should block removal
+	 * while a device is preserved.
+	 */
+	if (READ_ONCE(dev->liveupdate.outgoing))
+		pci_WARN(dev, 1, "Destroying outgoing-preserved device!\n");
+}
+
 /**
  * pci_liveupdate_register_flb() - Register a file handler with the PCI core
  * @fh: The file handler to register.
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
new file mode 100644
index 000000000000..b2335581f8d0
--- /dev/null
+++ b/drivers/pci/liveupdate.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * PCI Live Update support (core API)
+ *
+ * Copyright (c) 2026, Google LLC.
+ * David Matlack <dmatlack@google.com>
+ */
+#ifndef DRIVERS_PCI_LIVEUPDATE_H
+#define DRIVERS_PCI_LIVEUPDATE_H
+
+#include <linux/pci.h>
+
+#ifdef CONFIG_PCI_LIVEUPDATE
+void pci_liveupdate_cleanup_device(struct pci_dev *dev);
+#else
+static inline void pci_liveupdate_cleanup_device(struct pci_dev *dev)
+{
+}
+#endif
+
+#endif /* DRIVERS_PCI_LIVEUPDATE_H */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index dd0abbc63e18..14b66acbdb15 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -24,6 +24,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/bitfield.h>
 #include <trace/events/pci.h>
+#include "liveupdate.h"
 #include "pci.h"
 
 static struct resource busn_resource = {
@@ -2485,6 +2486,7 @@ static void pci_release_dev(struct device *dev)
 
 	pci_dev = to_pci_dev(dev);
 	pci_release_capabilities(pci_dev);
+	pci_liveupdate_cleanup_device(pci_dev);
 	pci_release_of_node(pci_dev);
 	pcibios_release_device(pci_dev);
 	pci_bus_put(pci_dev->bus);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index da58aa101e4c..b41dd572a2d6 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -593,6 +593,9 @@ struct pci_dev {
 	u8		tph_mode;	/* TPH mode */
 	u8		tph_req_type;	/* TPH requester type */
 #endif
+#ifdef CONFIG_PCI_LIVEUPDATE
+	struct pci_liveupdate liveupdate;
+#endif
 };
 
 static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
diff --git a/include/linux/pci_liveupdate.h b/include/linux/pci_liveupdate.h
index 8ec98beefcb4..894052ad6961 100644
--- a/include/linux/pci_liveupdate.h
+++ b/include/linux/pci_liveupdate.h
@@ -8,14 +8,26 @@
 #ifndef LINUX_PCI_LIVEUPDATE_H
 #define LINUX_PCI_LIVEUPDATE_H
 
+#include <linux/kho/abi/pci.h>
 #include <linux/liveupdate.h>
+#include <linux/spinlock_types.h>
 #include <linux/types.h>
 
+/**
+ * struct pci_liveupdate - PCI Live Update state for a struct pci_dev
+ * @outgoing: State preserved for the next kernel.
+ */
+struct pci_liveupdate {
+	struct pci_dev_ser *outgoing;
+};
+
 struct pci_dev;
 
 #ifdef CONFIG_PCI_LIVEUPDATE
 int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh);
 void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh);
+int pci_liveupdate_preserve(struct pci_dev *dev);
+void pci_liveupdate_unpreserve(struct pci_dev *dev);
 #else
 static inline int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
 {
@@ -25,6 +37,15 @@ static inline int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh
 static inline void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh)
 {
 }
+
+static inline int pci_liveupdate_preserve(struct pci_dev *dev)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void pci_liveupdate_unpreserve(struct pci_dev *dev)
+{
+}
 #endif
 
 #endif /* LINUX_PCI_LIVEUPDATE_H */
-- 
2.55.0.487.gaf234c4eb3-goog


