Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84C74C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 22:10:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE60E6B0095; Tue, 28 Jul 2026 18:10:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A96D66B0096; Tue, 28 Jul 2026 18:10:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ABDD6B0098; Tue, 28 Jul 2026 18:10:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 226D56B0095
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 18:10:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5FA2616052A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:10:26 +0000 (UTC)
X-FDA: 85039580052.09.B4B477F
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by imf07.hostedemail.com (Postfix) with ESMTP id A5CC740006
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:10:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lcxvwMLY;
	spf=pass (imf07.hostedemail.com: domain of 3zyhpaggKCCA9I6PH68GCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--dmatlack.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3zyhpaggKCCA9I6PH68GCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785276624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WBGGp3NNtpYgk9Q2kiQw/pkm7DbF0Q30FPkZ7rMim4s=;
	b=wgkl464HDK+tm2tlmqYOKf7/2zMKwv8m7X0c2T9EJLjUnReQS91rZbd49r+bFiDuxa/yoT
	OBgZdkWVNfSVZUan3tGHJdCpRidbyzquWTXzCG3hfozs/YrXPOqTdAk/AZ0rdXhhHnRkl5
	dtxyD+PgfvAT2zednrTZqW2SOEI37Lg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785276624;
	b=v49u868bNBDIoPzZ4YW/uf80Ife+0d+fyRSbRS8wx0YiW+KyDmmODxtsQSoP7puTm0lrXE
	Fz6hU1p/gbCdICjh7tFJ6MdsP5fwaMcj80dh8ovtQJibCHVsIXqeKXUt/8xVn4/SFYvglT
	sYUcEgWQMpHkevAYuETyHMKHialXhvQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lcxvwMLY;
	spf=pass (imf07.hostedemail.com: domain of 3zyhpaggKCCA9I6PH68GCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--dmatlack.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=3zyhpaggKCCA9I6PH68GCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-84e048a801dso414386b3a.3
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785276623; x=1785881423; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WBGGp3NNtpYgk9Q2kiQw/pkm7DbF0Q30FPkZ7rMim4s=;
        b=lcxvwMLY7GNytFES3v/Fmn7olc48Z7JczNysVcXc70JKx3JLew2Le7HnEWnuwwX7hb
         0YB3FiXvKQODDkDeubAO2D5Z6pBiLSqOh2wsEEvOpFy61gihDJHbyKxhkrLI4YnPefyI
         bYD26bBjHhtnvFUERbfzZIKNeEdZaQyBb6r8YoKapLonLLnU25+YsJOXSBmhIgoDa7CO
         3SfaTiG0+eo26iw+KSmJBTH4puoBc6nyJrFRV7r9NYfRQkMQLLSGSsqlptaeOHw0JxzT
         RG2msv0ADvNDId5gV8yj4R5jcbL5fNND314hWaqjdEblBOLc4YvU25F3nhSh3RZAtFoC
         xH3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785276623; x=1785881423;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WBGGp3NNtpYgk9Q2kiQw/pkm7DbF0Q30FPkZ7rMim4s=;
        b=d6Gb+IH/iXHqfWEy1cZuupx8Nkdf6VJ4ryEZDE/KLHX2nb5zWgjPyKu2RE5Y57uvoE
         TKeHtG+AUG5KwgptfkszDkm5X11h0cxcds3OAKx3H0ZnI1DnpoMMMQE3dno/3GtcgEnk
         QXFgXbgnC08+glg5vNohIZ3UiG4Ow1dyxOok5V5B8krUHujjL+zLTWVHvlBzkjrkQHNW
         qvtPpHes2lBHTC4jQumaoUIQ4sjCEHwiOeIg1KBwc5kstCeILbDoUFDTlRQAdFPp3GYx
         LnGXVK+uiPzUZuqaziwm/2QAhZ/d8hInCa3uab2CF2q0eFYhQnEoGlV4S96M03+XFWV4
         04/g==
X-Forwarded-Encrypted: i=1; AHgh+RpZSKhRFVjg8hfpxEp43STMmtlv2HLZUbGprX08emHS4oSYKKe9TLPNziSWj1GPrRWosvFwiKd+pw==@kvack.org
X-Gm-Message-State: AOJu0YxHYeGwvugm2rh4yU359ik1cFaT3ZNSqtS+kRWqWyMmMuQFgPzR
	HOmAJm/lLEHLTKpRNmyvRlDwaGzqkmxKAvAahX4ZMF9dlrMZm7Fo8zqVzOoYpk7xFJNPY4iBazv
	aCwbg+KHwZnGOIw==
X-Received: from pfgr18.prod.google.com ([2002:a05:6a00:c492:b0:845:c4b8:9730])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:ccb:b0:848:4c0c:9482 with SMTP id d2e1a72fcca58-84e933b0569mr4329533b3a.35.1785276623197;
 Tue, 28 Jul 2026 15:10:23 -0700 (PDT)
Date: Tue, 28 Jul 2026 22:09:57 +0000
In-Reply-To: <20260728221007.2098560-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260728221007.2098560-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.487.gaf234c4eb3-goog
Message-ID: <20260728221007.2098560-4-dmatlack@google.com>
Subject: [PATCH v8 03/12] PCI: liveupdate: Track incoming preserved PCI devices
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A5CC740006
X-Stat-Signature: 6waeqiccowxme7oqtfutwxhbk7juanb1
X-HE-Tag: 1785276624-656331
X-HE-Meta: U2FsdGVkX18mT+QNuOEdOP+ARzxEHW4kgHhkXP2ozuM3lKsf6YqHAvxNM7opCVrGH6ZYCA/qAZXZ3MAoL+ZzCw53AID+28bZ8GrjFQl4BZGCPH8lqz/qV/SkGlopMvLEApEj3n5kTdQX8ZNjxlQlDu/OyKXrINNJTHN9/9zavTBISNBI9ZpioSR2RgHvT+KZqjVKey4UTH5SOWdIPj+RXhDvrjra8JRYCJGmoipj0h+iz6UmnLztXB9sCY6ai9xB0Lt2GsOL/K4xZi38Zl+vLKwIcNubfSTDlXdkuMFHohX+ngjtGgp14TojwaPh7jUqywhuYkfENwE8rcfUaSiDdcl6cA3ot7LhuQyddojXxLKQQOzOg6nn14l7jBjIC2MXaQKFmav6FjfdRiVE7f5dhCYFH33rKw3UNyrh082eyOVPMMWdprRwfshzTMclX3tQyZGN6i07reJv37RViO1PgwY4IFcW6eAox75tE00I3DMBgVwPb0vdS3Tswp/uzWtQAQ8zNUuphcEmotW5PF1Dj6Ej7dbYBE/PW+gboo/Fs8DVcGDOEL4JGFVfiC/ctxnVK2mqZr5vBed/B4R/8DcPHVsMT51eaxkHzohxTuiMwoosRkPcvz+3l/tBY6rwmr5m6KDb2cNx0gvfvEwgDWWVLk9Jrkc4aRH6iViqWS1wxuFiOXSBT5yT7HpqZZXZ5Fn8Gejbq/ebvXLDy3YyZ2y1k9JjjsfhkGG2BtuYBkv8mI1ODXGYYPof1yCy3RhQdYszjCrgtVjqHwNkOgqAjbwKZfANTXY3So8g5Ba4/5baA7hVlbUr8X/e6rcTOCsNGWEL5QZ7gOKq3HdymkZdY+CojoETsR2dvIImtFAAJb4KKPzw6pxJgWRFGMRRxigwbssXUNpnfwWOARRNa80b6inaQd7eEk4irJLJUV169wec3Rg77U/DQLPyu8yLCeJMuTgMTwgrJJvHWMkV1mYhyUH
 4OGSXatA
 mzIZ0mL8KPCKwYdOC0NEdfbn7rpQBf2HUe1mwMnG6PuNr+mSoGWptHMJ95j5YoJzIMtqbyb2ke1zefELUW8skMkIkWgde1jlFrSEDxRodvDhYdoR/M7nL6vBtBcBXqCtlE5b1m6qsekmBR0+2IYN7/sgn4yBP0ABmUG8bbQ4kkaqeU4JsESGZEm6VD7mZX/XDniLPioPobMVP0rddp0Tgl4oh0xn8UlWpwhyNEqZoaLt+O7WDNS18tW9kWiTbWtwllXhoShz/o47SglDktfPRoikBLg7Uc6vY0EcU2SvvvNA92yKa4OSHUEd2SXB6Fk+A4MkED51AjndSxz7LlIEHDnlx028hTlET1fl1fOsHFigvEyGmHcOXANq+fcG/dfYzsuZ6Djo8x7jniVt0dN2/KSghOf8lN+Son/bJN01V/GuswRswONXa3CNwfUYob/lRTQ3XYBxlXnmgBUPHV80VtJfxBxSr3WAcFSXsY9+bO2ARgvMZJvN+pAsqaLY0eWp0Fqdb/1+fyjtKLMwsVzLGNiI83ZId1OSh3Igb1YSxQRmcprWV5zbq5oW1T4+/nZZgsVldK0FtTZCvPXYMpZOMM3OuKp8q8PRl4A1g0M/BVssAy/w3C4uzDL4yLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During PCI enumeration, the previous kernel might have passed state about
devices that were preserved across kexec. The PCI core needs to fetch
this state to identify which devices are "incoming" and require special
handling.

Add pci_liveupdate_setup_device() which is called during device setup
to fetch the serialized state (struct pci_ser) from the Live Update
Orchestrator. The first time this happens, pci_flb_retrieve() will run
and convert the array of pci_dev_ser structs into an xarray so that it
can be looked up efficiently.

If a device is found in the xarray, the PCI core stores a pointer to its
state in dev->liveupdate_incoming until pci_liveupdate_finish() is
called by the driver. This pointer allows the PCI core and drivers to
apply Live Update-specific logic to incoming devices in subsequent
commits.

Drivers can check if a device is an incoming preserved device (e.g.
during probe) by calling pci_liveupdate_is_incoming().

CONFIG_64BIT is now required to enable CONFIG_PCI_LIVEUPDATE so that the
domain and bdf can be guaranteed to fit in an unsigned long and be used
as the xarray key.

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 MAINTAINERS                    |   1 +
 drivers/pci/Kconfig            |   2 +-
 drivers/pci/liveupdate.c       | 256 ++++++++++++++++++++++++++++++++-
 drivers/pci/liveupdate.h       |   5 +
 drivers/pci/probe.c            |   3 +
 include/linux/pci_liveupdate.h |  13 ++
 6 files changed, 277 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9cc7b9291ace..08a724b860dc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20834,6 +20834,7 @@ L:	linux-pci@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
 F:	drivers/pci/liveupdate.c
+F:	drivers/pci/liveupdate.h
 F:	include/linux/kho/abi/pci.h
 F:	include/linux/pci_liveupdate.h
 
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 3781e2b5f095..8af20f558086 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -273,7 +273,7 @@ config VGA_ARB_MAX_GPUS
 
 config PCI_LIVEUPDATE
 	bool "PCI Live Update Support"
-	depends on PCI && LIVEUPDATE
+	depends on PCI && LIVEUPDATE && 64BIT
 	help
 	  Enable PCI core support for preserving PCI devices across Live
 	  Update. This, in combination with support in a device's driver,
diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index b003b7069cdb..5ce5f8b36902 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -49,6 +49,20 @@
  * This allows the PCI core to keep its FLB data (struct pci_ser) up to date
  * with the list of **outgoing** preserved devices for the next kernel.
  *
+ * After kexec, whenever a device is enumerated, the PCI core will check if it
+ * is an **incoming** preserved device (i.e. preserved by the previous kernel)
+ * by checking the incoming FLB data (struct pci_ser).
+ *
+ * Drivers must notify the PCI core when an **incoming** device is done
+ * participating in the incoming Live Update with the following API:
+ *
+ *  * ``pci_liveupdate_finish(pci_dev)``
+ *
+ * The PCI core does not enforce any ordering of ``pci_liveupdate_finish()`` and
+ * ``pci_liveupdate_preserve()``. i.e. A PCI device can be **outgoing**
+ * (preserved for next kernel) and **incoming** (preserved by previous kernel)
+ * at the same time.
+ *
  * Restrictions
  * ============
  *
@@ -100,6 +114,26 @@ struct pci_flb_outgoing {
 	struct kho_block_set block_set;
 };
 
+/**
+ * struct pci_flb_incoming - Incoming PCI FLB object
+ * @ser: The incoming struct pci_ser from the previous kernel.
+ * @xa: Xarray used to quickly lookup devices in @ser.
+ * @block_set: The KHO block set holding the incoming devices.
+ *
+ * This structure holds the runtime state for the incoming PCI Live Update
+ * state. It wraps the serialized pci_ser, the block_set used to restore
+ * the serialized entries, and an xarray for fast lookups.
+ */
+struct pci_flb_incoming {
+	struct pci_ser *ser;
+	struct xarray xa;
+	struct kho_block_set block_set;
+};
+
+static unsigned long pci_ser_xa_key(u32 domain, u16 bdf)
+{
+	return (unsigned long)domain << 16 | bdf;
+}
 static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
 {
 	struct pci_flb_outgoing *outgoing __free(kfree) = NULL;
@@ -140,15 +174,91 @@ static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
 
 static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
 {
+	struct pci_ser *ser = phys_to_virt(args->data);
+	struct pci_flb_incoming *incoming;
+	struct pci_dev_ser *dev_ser;
+	struct kho_block_set_it it;
+	int ret;
+
 	pr_debug("Retrieving struct pci_ser (0x%llx)\n", args->data);
-	args->obj = phys_to_virt(args->data);
+
+	if (ser->version != PCI_LUO_FLB_VERSION) {
+		pr_err("Incoming PCI FLB version (v%d) is incompatible with this kernel (v%d)\n",
+		       ser->version, PCI_LUO_FLB_VERSION);
+		ret = -EINVAL;
+		goto err_restore_free;
+	}
+
+	incoming = kzalloc_obj(*incoming);
+	if (!incoming) {
+		ret = -ENOMEM;
+		goto err_restore_free;
+	}
+
+	incoming->ser = ser;
+	xa_init(&incoming->xa);
+
+	kho_block_set_init(&incoming->block_set, sizeof(struct pci_dev_ser));
+	ret = kho_block_set_restore(&incoming->block_set, ser->devices);
+	if (ret)
+		goto err_free_incoming;
+
+	kho_block_set_it_init(&it, &incoming->block_set);
+	while ((dev_ser = kho_block_set_it_read_entry(&it))) {
+		unsigned long key;
+
+		if (!dev_ser->refcount)
+			continue;
+
+		key = pci_ser_xa_key(dev_ser->domain, dev_ser->bdf);
+		ret = xa_insert(&incoming->xa, key, dev_ser, GFP_KERNEL);
+		if (ret)
+			goto err_block_set_destroy;
+	}
+
+	args->obj = incoming;
 	return 0;
+
+err_block_set_destroy:
+	kho_block_set_destroy(&incoming->block_set);
+err_free_incoming:
+	xa_destroy(&incoming->xa);
+	kfree(incoming);
+err_restore_free:
+	kho_restore_free(ser);
+	return ret;
+}
+
+static void pci_check_all_devices_finished(struct pci_flb_incoming *incoming)
+{
+	struct pci_dev *dev = NULL;
+
+	if (READ_ONCE(incoming->ser->nr_devices) == 0)
+		return;
+
+	for_each_pci_dev(dev) {
+		if (READ_ONCE(dev->liveupdate.incoming))
+			pci_emerg(dev, "Preserved device was never finished!\n");
+	}
+
+	/*
+	 * This should only happen if a driver violated the contract to call
+	 * pci_liveupdate_finish() (something is extremely broken).
+	 */
+	panic("Some preserved devices were never finished!\n");
 }
 
 static void pci_flb_finish(struct liveupdate_flb_op_args *args)
 {
+	struct pci_flb_incoming *incoming = args->obj;
+
 	pr_debug("Finished struct pci_ser (0x%llx)\n", args->data);
-	kho_restore_free(args->obj);
+	pci_check_all_devices_finished(incoming);
+
+	xa_destroy(&incoming->xa);
+	kho_block_set_destroy(&incoming->block_set);
+	kho_restore_free(incoming->ser);
+	kfree(incoming);
 }
 
 static struct liveupdate_flb_ops pci_liveupdate_flb_ops = {
@@ -325,6 +435,75 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev)
 }
 EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
 
+static struct pci_flb_incoming *pci_liveupdate_flb_get_incoming(void)
+{
+	struct pci_flb_incoming *incoming = NULL;
+	int ret;
+
+	ret = liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **)&incoming);
+
+	/* Live Update is not enabled. */
+	if (ret == -EOPNOTSUPP)
+		return NULL;
+
+	/* Live Update is enabled, but there is no incoming FLB data. */
+	if (ret == -ENODATA)
+		return NULL;
+
+	/*
+	 * Live Update is enabled and there is incoming FLB data, but none of it
+	 * matches pci_liveupdate_flb.compatible.
+	 */
+	if (ret == -ENOENT)
+		return NULL;
+
+	/*
+	 * There is incoming FLB data that matches pci_liveupdate_flb.compatible
+	 * but retrieve failed (pci_flb_retrieve() returned an error or LUO
+	 * failed to acquire a reference to pci_liveupdate_flb_ops.owner).
+	 */
+	if (ret)
+		panic("Failed to retrieve incoming FLB data (%d)\n", ret);
+
+	return incoming;
+}
+
+static void pci_liveupdate_flb_put_incoming(void)
+{
+	liveupdate_flb_put_incoming(&pci_liveupdate_flb);
+}
+
+void pci_liveupdate_setup_device(struct pci_dev *dev)
+{
+	struct pci_flb_incoming *incoming;
+	struct pci_dev_ser *dev_ser;
+	unsigned long key;
+
+	guard(rwsem_write)(&pci_liveupdate.rwsem);
+
+	incoming = pci_liveupdate_flb_get_incoming();
+	if (!incoming)
+		return;
+
+	key = pci_ser_xa_key(pci_domain_nr(dev->bus), pci_dev_id(dev));
+	dev_ser = xa_load(&incoming->xa, key);
+
+	/*
+	 * This device was not preserved across Live Update, or it was preserved
+	 * but has already been probed and gone through pci_liveupdate_finish(),
+	 * e.g. due to removing and re-adding the device. Either way, it's not
+	 * treated as incoming-preserved.
+	 */
+	if (!dev_ser || !dev_ser->refcount) {
+		pci_liveupdate_flb_put_incoming();
+		return;
+	}
+
+	pci_info(dev, "Device was preserved by previous kernel across Live Update\n");
+	dev->liveupdate.incoming = dev_ser;
+	pci_liveupdate_flb_put_incoming();
+}
+
 void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 {
 	/*
@@ -336,7 +515,80 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 	 */
 	if (READ_ONCE(dev->liveupdate.outgoing))
 		pci_WARN(dev, 1, "Destroying outgoing-preserved device!\n");
+
+	if (READ_ONCE(dev->liveupdate.incoming))
+		pci_WARN(dev, 1, "Destroying incoming-preserved device!\n");
+}
+
+static void pci_liveupdate_finish_device(struct pci_ser *ser, struct pci_dev *dev)
+{
+	if (!dev->liveupdate.incoming) {
+		pci_warn(dev, "Cannot finish preserving an unpreserved device\n");
+		return;
+	}
+
+	if (dev->liveupdate.incoming->refcount != 1) {
+		pci_WARN(dev, 1, "Preserved device has a corrupted refcount!\n");
+		return;
+	}
+
+	/*
+	 * Drop the refcount so this device does not get treated as an incoming
+	 * device again, e.g. in case pci_liveupdate_setup_device() gets called
+	 * again because the device is hot-plugged.
+	 */
+	dev->liveupdate.incoming->refcount = 0;
+
+	pci_info(dev, "Device is finished participating in Live Update\n");
+	dev->liveupdate.incoming = NULL;
+	ser->nr_devices--;
+}
+
+/**
+ * pci_liveupdate_finish() - Finish the preservation of a PCI device
+ * @dev: The PCI device
+ *
+ * pci_liveupdate_finish() notifies the PCI core that a PCI device that was
+ * preserved across the previous Live Update has finished participating in Live
+ * Update. Drivers must call pci_liveupdate_finish() from their struct
+ * liveupdate_file_handler finish() callback to ensure the incoming struct
+ * pci_ser is allocated.
+ */
+void pci_liveupdate_finish(struct pci_dev *dev)
+{
+	struct pci_flb_incoming *incoming;
+
+	guard(rwsem_write)(&pci_liveupdate.rwsem);
+
+	incoming = pci_liveupdate_flb_get_incoming();
+	if (!incoming) {
+		pci_warn(dev, "Cannot finish preserving device without incoming FLB\n");
+		return;
+	}
+
+	pci_liveupdate_finish_device(incoming->ser, dev);
+	pci_liveupdate_flb_put_incoming();
+}
+EXPORT_SYMBOL_GPL(pci_liveupdate_finish);
+
+/**
+ * pci_liveupdate_is_incoming() - Check if a device is incoming-preserved
+ * @dev: The PCI device to check
+ *
+ * Check if a device was preserved across Live Update by the previous kernel,
+ * i.e. the device is incoming-preserved. Note that a device is only considered
+ * incoming-preserved prior to pci_liveupdate_finish(). It is up to drivers to
+ * synchronize usage of pci_liveupdate_is_incoming() with their own call to
+ * pci_liveupdate_finish() to avoid acting on stale data.
+ *
+ * Returns: True if the device is incoming-preserved, false otherwise.
+ */
+bool pci_liveupdate_is_incoming(struct pci_dev *dev)
+{
+	guard(rwsem_read)(&pci_liveupdate.rwsem);
+	return dev->liveupdate.incoming;
 }
+EXPORT_SYMBOL_GPL(pci_liveupdate_is_incoming);
 
 /**
  * pci_liveupdate_register_flb() - Register a file handler with the PCI core
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
index b2335581f8d0..eaaa3559fd77 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -11,8 +11,13 @@
 #include <linux/pci.h>
 
 #ifdef CONFIG_PCI_LIVEUPDATE
+void pci_liveupdate_setup_device(struct pci_dev *dev);
 void pci_liveupdate_cleanup_device(struct pci_dev *dev);
 #else
+static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
+{
+}
+
 static inline void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 {
 }
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 14b66acbdb15..5dc9d86e3597 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2065,6 +2065,8 @@ int pci_setup_device(struct pci_dev *dev)
 	if (pci_early_dump)
 		early_dump_pci_device(dev);
 
+	pci_liveupdate_setup_device(dev);
+
 	/* Need to have dev->class ready */
 	dev->cfg_size = pci_cfg_space_size(dev);
 
@@ -2188,6 +2190,7 @@ int pci_setup_device(struct pci_dev *dev)
 	default:				    /* unknown header */
 		pci_err(dev, "unknown header type %02x, ignoring device\n",
 			dev->hdr_type);
+		pci_liveupdate_cleanup_device(dev);
 		pci_release_of_node(dev);
 		return -EIO;
 
diff --git a/include/linux/pci_liveupdate.h b/include/linux/pci_liveupdate.h
index 894052ad6961..710026ada2d5 100644
--- a/include/linux/pci_liveupdate.h
+++ b/include/linux/pci_liveupdate.h
@@ -16,9 +16,11 @@
 /**
  * struct pci_liveupdate - PCI Live Update state for a struct pci_dev
  * @outgoing: State preserved for the next kernel.
+ * @incoming: State preserved by the previous kernel.
  */
 struct pci_liveupdate {
 	struct pci_dev_ser *outgoing;
+	struct pci_dev_ser *incoming;
 };
 
 struct pci_dev;
@@ -28,6 +30,8 @@ int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh);
 void pci_liveupdate_unregister_flb(struct liveupdate_file_handler *fh);
 int pci_liveupdate_preserve(struct pci_dev *dev);
 void pci_liveupdate_unpreserve(struct pci_dev *dev);
+void pci_liveupdate_finish(struct pci_dev *dev);
+bool pci_liveupdate_is_incoming(struct pci_dev *dev);
 #else
 static inline int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
 {
@@ -46,6 +50,15 @@ static inline int pci_liveupdate_preserve(struct pci_dev *dev)
 static inline void pci_liveupdate_unpreserve(struct pci_dev *dev)
 {
 }
+
+static inline void pci_liveupdate_finish(struct pci_dev *dev)
+{
+}
+
+static inline bool pci_liveupdate_is_incoming(struct pci_dev *dev)
+{
+	return false;
+}
 #endif
 
 #endif /* LINUX_PCI_LIVEUPDATE_H */
-- 
2.55.0.487.gaf234c4eb3-goog


