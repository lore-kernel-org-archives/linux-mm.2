Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36658CD5BB1
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 20:24:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A3166B009B; Fri, 22 May 2026 16:24:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 626506B009D; Fri, 22 May 2026 16:24:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A08C6B009E; Fri, 22 May 2026 16:24:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33A416B009B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:24:18 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EDFDC1C1D5C
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:24:17 +0000 (UTC)
X-FDA: 84796182954.24.742C3C0
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf04.hostedemail.com (Postfix) with ESMTP id 26C084000E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:24:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TpUR9h5o;
	spf=pass (imf04.hostedemail.com: domain of 3brsQaggKCH8gpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3brsQaggKCH8gpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779481456; a=rsa-sha256;
	cv=none;
	b=6ktt9I1YjmxcaiPfkSa44p/rdJ2esMf0LxQUB4eQckwFifon4Ha8goKwZFBd5pNAZc6pBt
	3Um0XiBdxq8bBbT7GltH9c7wHMI1LeLBw904nRpRBy5lgNrqg0BF3CQAMhlnjdgeIpVc6S
	yJr9jfBYEvHA42QLyJnzLj4h1FRi8Vo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TpUR9h5o;
	spf=pass (imf04.hostedemail.com: domain of 3brsQaggKCH8gpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3brsQaggKCH8gpdwodfnjrrjoh.frpolqx0-ppnydfn.ruj@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779481456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O7EM8yO5UABmCYyvloFksBNZ5H9Ralyj3Xc5krkoLm8=;
	b=L5NuIdZsGhSTPurFL4Fq6ytIWkSfUP9Hz3/D/GNnKWBD86ra1ekH9wojHwdn0ZzLdnZhBJ
	W+blEpSJFvgNyzcG04vk/aRAFh3mZD0FohGiV5XbX26k+6vPd4xfl8TU0jvUDr5cQ/gWz2
	MtlMWhuqUKomRKXzNGPa5DWt7veq1+0=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2b99eb06178so180063865ad.2
        for <linux-mm@kvack.org>; Fri, 22 May 2026 13:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779481455; x=1780086255; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O7EM8yO5UABmCYyvloFksBNZ5H9Ralyj3Xc5krkoLm8=;
        b=TpUR9h5oJHQ/Zi5WCmW4rkEsY6FbCIN9ppl9xreIIupQRL180G8eYkr11Q/RK1O15J
         OreKnMdYDDlnOz22dUVg7ztZYIYC6OKftC63+6xZ2M6iOjOOtFVx8y2rYn2nfTnCVjOE
         3agfsqNVtOj9tYlpaEUCUtZXygFLRVnC0oitOAz5bAC9qHk862HYlE0i3TIJn75lkJbg
         0AyNcjUM97PmmzvcBGIdENYIPnZWsWioHsf/C6afSG1RWAiatUkbJ0eyLMjPm8k6/HHu
         feLKjbP7nGj48/xlTew60SmkZ6ooxRtkFv3yhvjKUgaaBYxMiV0eG6Cp9Ns3iUoad4uZ
         DABQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779481455; x=1780086255;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O7EM8yO5UABmCYyvloFksBNZ5H9Ralyj3Xc5krkoLm8=;
        b=IK48BSBy03EyUiCFusykcpBy83NBSLoMqGCjXFICt6CQfqQiO1XR8RolYFiQRtT5vD
         WfAypCFP5WJmFsAYBR3fIszV2ky3qtZnK5EJVTKuoFUYK3TBd62sFujKcYzugFUjI16I
         eRB4l/IxjsnKuC0rfSwLfuVVoHILmWOjMXqsn+5lYolyLIH9tAKUmyRbMszfRdgbFhor
         nn0nOKkVqscQEY5PFUtUh3lRa2UGoRSW4vhIyavvrT+J6ONxUp1GNXTzO8yykDjwmom2
         pnTNSiDPXBcgHsgSe/zDc785jOQDPR+/6JCqStW0G8u3jhmvn5o36Ecli8b2pTnVZ86s
         pWeQ==
X-Forwarded-Encrypted: i=1; AFNElJ8FTLCmuuYVKNKvj4VcZLZ3CBMQaapU+QaZCogBhZHzneaKN8yuQoSSRqQuAlisMgMplSrwPEpbrg==@kvack.org
X-Gm-Message-State: AOJu0YwHhV6uD7PwQl1xkQdNMP8cbcY8voODW5IcJhumwTdjC358HW9U
	79AYdI0o15WLEEYJHdhPlIB4F7L6p56BeBrhlPJZtzzqqQYIIfU/FKq/3kxFaCTL3onsctTRXdB
	OqQdffE1z5YZ3mw==
X-Received: from pldw18.prod.google.com ([2002:a17:902:ca12:b0:2be:22cf:75b2])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1b43:b0:2b7:abc0:3bd7 with SMTP id d9443c01a7336-2beb035b8edmr57115215ad.9.1779481454632;
 Fri, 22 May 2026 13:24:14 -0700 (PDT)
Date: Fri, 22 May 2026 20:24:01 +0000
In-Reply-To: <20260522202410.3104264-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260522202410.3104264-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260522202410.3104264-4-dmatlack@google.com>
Subject: [PATCH v6 03/12] PCI: liveupdate: Track incoming preserved PCI devices
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
X-Rspamd-Queue-Id: 26C084000E
X-Rspamd-Server: rspam03
X-Stat-Signature: frh9erozx9ebjqm4o4g548rjbhp7qfqp
X-HE-Tag: 1779481455-524824
X-HE-Meta: U2FsdGVkX19ETOgbGeLB5N+h68jXK7Q+goODGyzo8uRFPMV3qddrTno8hjPy7RVtHkEavTwIunqq4our2/Jw7273qXuOMW937WKIk7+OowSHWU7duCNkrLPoRZj6rtfNG1Z1GXeS1GOGuyD/KZkisfd9nwrlFTvAWpmSGE/emH9A64Qt6mNR0HnuQedSORij9FU2NY/4K9QOoLQOq6CIpprkJjQg/f5tdzXgCUQ3wKBLD7wNcCbxQ5u+UqgGfCJeM+aTkBgs9lw9OeSVTONUp+feJtYnYNHqAEo7QdvEqmsfhWdOdHhG5k+C+FJmCqa/qVcKfxqjQrrWbBBXGKOM9PzYT11LvGyKcHxgg5mjaedEyrERh8xI7ou6Im2CUaESRJ8fqLjVYARCEaU6YWLKvakQqifNGYi353TTjb2OdJnBjfCtpRELxoKVbMNXOY2vqcmoems3oM5lCeOZZPiSWLfiD10Q7zga/OgExUcNnsa5HqhI4Z93F0NVZyz9xvg3PQpWEnv5cG0OZpz/zuESxqUK6D3KbKVra3uA6p8XouQojnP2M4ggwDqZa2C3OEHllnC6b8Y+vrQLY9F2GLJP39o28+4d7aadsV0wO5/bQZTEN/15IsxClNaSaKgEVJrbBnNVRl20kEya0zqK1hzDB1v/TpxzV9W/CPAo9tf0PR1/71wNNqYAd89zq408ZyoeBRCHVpj8Rf1eYx+hj+uHnbkW/CaTMtNLlf0YF8ML0wsFMoWMi4Ev/3FCpv3BuH0GUi4DjbtYCLTttHFTsdfJZxntYjgGdsR7MaF1GAshEFl824TG6CxUwbCgu++CyAusCnyeFY8E/kigxmaWhlc7J9eTfZFOJbtEIYBehzzEW1Oodo2ku7G6rAIwOn+0MfMkUPnKDkIiOCZ2D83U23lby3bRUt+YZ/zHsA4uUfescmd97z9GEQ4raTLBa2++7gs+1L5Nv4dEac1DOtvGxT8
 XoA88ggG
 6pjy9SuQgke9LsGsc86S8yN+/QVxq4HD26uiEwWWHz+Vvmy7wCr4cffAC2F5wwzfq4Gm17NhExUdX5mkgL7NC+704SNz7Xci58T474SY8kUfm1CRg8PxTEFCQ9cgyA5nRUvHdj+I2VL61bXIcfjiGnrSKyNCGabE2QvUjMnQhnkJ9vv1K9afo8M/3hm+r5vamlpbOjsmUuWDZHM8G4feE70PjGarPQxcfhA5G4cg15R7kpkEgFc5WM/SYZzpnSZpehai4abmQ7nbs4sarr6TiBKwPdV3SHQsofWqzo6wO7Nb0d39RrpOU0AdbIcc2UUOjggmJj+pLtWu2YxRC0ZF2JcjXpqlwjLOKeHaolxzpJsG++tlDfQegjH50vtUOzNUtZG8aBNQ4Gi3ubrCuaVBJjjR6fjYwna5urzIy61D6nYfNVZcklB8gYvkkgPqq22RBcV6M1gdiHvOdNmEcmSiEdsZOpA4o6iZI2/O50sgOOV4PxrCGMeqLwNarJJZXrRolQpPlN0jTPDU+Q9KYVr6T8gzVb6egXXee7s87xgbpCdb6Tk6q11qeORw5UHCwyDK4e/Yq3vgPELB3nCI=
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
state in dev->liveupdate_incoming and holds a reference to the incoming
FLB until pci_liveupdate_finish() is called by the driver.

This ensures proper lifecycle management for incoming preserved devices
and allows the PCI core and drivers to apply specific Live Update
logic to them in subsequent commits.

Drivers can check if a device is an incoming preserved device (e.g.
during probe) by calling pci_liveupdate_is_incoming().

CONFIG_64BIT is now required to enable CONFIG_PCI_LIVEUPDATE so that the
domain and bdf can be guaranteed to fit in an unsigned long and be used
as the xarray key.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 MAINTAINERS                    |   1 +
 drivers/pci/Kconfig            |   2 +-
 drivers/pci/liveupdate.c       | 230 ++++++++++++++++++++++++++++++++-
 drivers/pci/liveupdate.h       |   5 +
 drivers/pci/probe.c            |   3 +
 include/linux/pci_liveupdate.h |  13 ++
 6 files changed, 251 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6c618830cf61..0e262c0ceb43 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20537,6 +20537,7 @@ L:	linux-pci@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
 F:	drivers/pci/liveupdate.c
+F:	drivers/pci/liveupdate.h
 F:	include/linux/kho/abi/pci.h
 F:	include/linux/pci_liveupdate.h
 
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 10c9b65aa242..e68ae5c172d4 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -330,7 +330,7 @@ config VGA_ARB_MAX_GPUS
 
 config PCI_LIVEUPDATE
 	bool "PCI Live Update Support"
-	depends on PCI && LIVEUPDATE
+	depends on PCI && LIVEUPDATE && 64BIT
 	help
 	  Enable PCI core support for preserving PCI devices across Live
 	  Update. This, in combination with support in a device's driver,
diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 065d5af822f7..96c43b84532c 100644
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
@@ -83,6 +97,21 @@ static struct pci_liveupdate_global pci_liveupdate = {
 	.rwsem = __RWSEM_INITIALIZER(pci_liveupdate.rwsem),
 };
 
+/**
+ * struct pci_flb_incoming - Incoming PCI FLB object
+ * @ser: The incoming struct pci_ser from the previous kernel.
+ * @xa: Xarray used to quickly lookup devices in @ser.
+ */
+struct pci_flb_incoming {
+	struct pci_ser *ser;
+	struct xarray xa;
+};
+
+static unsigned long pci_ser_xa_key(u32 domain, u16 bdf)
+{
+	return (unsigned long)domain << 16 | bdf;
+}
+
 static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
 {
 	struct pci_dev *dev = NULL;
@@ -128,13 +157,49 @@ static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
 
 static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
 {
-	args->obj = phys_to_virt(args->data);
+	struct pci_ser *ser = phys_to_virt(args->data);
+	struct pci_flb_incoming *incoming;
+	int ret = -ENOMEM;
+	u32 i;
+
+	incoming = kmalloc_obj(*incoming);
+	if (!incoming)
+		goto err_restore_free;
+
+	incoming->ser = ser;
+	xa_init(&incoming->xa);
+
+	for (i = 0; i < incoming->ser->max_nr_devices; i++) {
+		struct pci_dev_ser *dev_ser = &incoming->ser->devices[i];
+		unsigned long key;
+
+		if (!dev_ser->refcount)
+			continue;
+
+		key = pci_ser_xa_key(dev_ser->domain, dev_ser->bdf);
+		ret = xa_insert(&incoming->xa, key, dev_ser, GFP_KERNEL);
+		if (ret)
+			goto err_xa_destroy;
+	}
+
+	args->obj = incoming;
 	return 0;
+
+err_xa_destroy:
+	xa_destroy(&incoming->xa);
+	kfree(incoming);
+err_restore_free:
+	kho_restore_free(ser);
+	return ret;
 }
 
 static void pci_flb_finish(struct liveupdate_flb_op_args *args)
 {
-	kho_restore_free(args->obj);
+	struct pci_flb_incoming *incoming = args->obj;
+
+	xa_destroy(&incoming->xa);
+	kho_restore_free(incoming->ser);
+	kfree(incoming);
 }
 
 static struct liveupdate_flb_ops pci_liveupdate_flb_ops = {
@@ -270,6 +335,91 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev)
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
+	 *
+	 * This could mean that no PCI FLB data was passed by the previous
+	 * kernel, but it could also mean the previous kernel used a different
+	 * compatibility string (i.e. a different ABI).
+	 */
+	if (ret == -ENOENT) {
+		pr_info_once("No incoming FLB matched %s\n", pci_liveupdate_flb.compatible);
+		return NULL;
+	}
+
+	/*
+	 * There is incoming FLB data that matches pci_liveupdate_flb.compatible
+	 * but it cannot be retrieved.
+	 */
+	if (ret) {
+		WARN_ONCE(ret, "Failed to retrieve incoming FLB data\n");
+		return NULL;
+	}
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
+	/* This device was not preserved across Live Update */
+	if (!dev_ser) {
+		pci_liveupdate_flb_put_incoming();
+		return;
+	}
+
+	/*
+	 * This device was preserved, but has already been probed and gone
+	 * through pci_liveupdate_finish(). This can happen if PCI core probes
+	 * the same device multiple times, e.g. due to hotplug.
+	 */
+	if (!dev_ser->refcount) {
+		pci_liveupdate_flb_put_incoming();
+		return;
+	}
+
+	pci_info(dev, "Device was preserved by previous kernel across Live Update\n");
+	dev->liveupdate.incoming = dev_ser;
+
+	/*
+	 * Hold the ref on the incoming FLB until pci_liveupdate_finish() so
+	 * that dev->liveupdate.incoming does not get freed while it is in use.
+	 */
+}
+
 void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 {
 	/*
@@ -280,7 +430,83 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 		pci_WARN(dev, 1, "Destroying outgoing-preserved device!\n");
 		pci_liveupdate_unpreserve(dev);
 	}
+
+	if (READ_ONCE(dev->liveupdate.incoming)) {
+		pci_WARN(dev, 1, "Destroying incoming-preserved device!\n");
+		pci_liveupdate_finish(dev);
+	}
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
+	pci_liveupdate_flb_put_incoming();
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
index b88109a8dfe4..2e2be8af6976 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2070,6 +2070,8 @@ int pci_setup_device(struct pci_dev *dev)
 	if (pci_early_dump)
 		early_dump_pci_device(dev);
 
+	pci_liveupdate_setup_device(dev);
+
 	/* Need to have dev->class ready */
 	dev->cfg_size = pci_cfg_space_size(dev);
 
@@ -2193,6 +2195,7 @@ int pci_setup_device(struct pci_dev *dev)
 	default:				    /* unknown header */
 		pci_err(dev, "unknown header type %02x, ignoring device\n",
 			dev->hdr_type);
+		pci_liveupdate_cleanup_device(dev);
 		pci_release_of_node(dev);
 		return -EIO;
 
diff --git a/include/linux/pci_liveupdate.h b/include/linux/pci_liveupdate.h
index cfcfbfa73af7..cfdc3d62ec02 100644
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
2.54.0.746.g67dd491aae-goog


