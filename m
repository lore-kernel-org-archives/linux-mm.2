Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1652C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:26:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF7456B00B6; Fri, 10 Jul 2026 17:26:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACE376B00B7; Fri, 10 Jul 2026 17:26:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96EC96B00B8; Fri, 10 Jul 2026 17:26:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5575C6B00B6
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:26:29 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C0C3016980A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:28 +0000 (UTC)
X-FDA: 84974150856.12.4342F7A
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf29.hostedemail.com (Postfix) with ESMTP id 148E7120002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YEIm3Gjz;
	spf=pass (imf29.hostedemail.com: domain of 3gWNRaggKCOYLUIbTIKSOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--dmatlack.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3gWNRaggKCOYLUIbTIKSOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783718787;
	b=mEZNHZlJcmn2wgQf8K5/OvM+e9ZWOm0h13fiJ/dxQP3f7NOeSECfs00re4fKSYoN7tzOaZ
	HnLJfS8EpE3vLIGmy3lNABbdVMzcLHFNSV82+C6kOqd9hm3O0vTZgFHzp0cTg6T+ARXWVF
	7HsNEe1j0pNyHDFw1evdYcg9Pno/xEU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YEIm3Gjz;
	spf=pass (imf29.hostedemail.com: domain of 3gWNRaggKCOYLUIbTIKSOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--dmatlack.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3gWNRaggKCOYLUIbTIKSOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783718787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OQrpvHKyfewFed1C96fmigU0fqx5g50RgiJpnH3PBzY=;
	b=oI8trFk0Z7+nJDCRquWhGCmtoQWv5NWSinGsfUbRcV+a+4OjYyVzFCCZIKoR7yOd6TuVnQ
	AFjxYZY2a2xrna2zxN/kN7/+gn37pQ1CbHYcfEdbD690ril4AlMkTPQrjQhxQ4w14Mu5n8
	pi3WjQXor1nLl2HgRdFo8eHmKKG2AWM=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2cce02cb769so15588905ad.1
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783718786; x=1784323586; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OQrpvHKyfewFed1C96fmigU0fqx5g50RgiJpnH3PBzY=;
        b=YEIm3GjzBbWauB+QdX4PQSxhMd8cs70o7TQrjEyHeRc7k2h1RdEQI9LE4FSlvu6bx7
         LDM1/oaImLf7UgbAlH6KNn85LUu7QUq8COQJkpgHD+5uLlstjUOVfjWHIuNnYX03WGAv
         WBakTq4nj/69MRqqTfJjHpllm/mB1eY30ab0xYDJhpNZhQw7iTW3J+lO5Xr4kafBkcEt
         x/Wb23lK9PW5lddpaTfQyXg7mesi969LFukoKqMXfWkWR8NQ/CC2j47j968kYf+VsJ8R
         wG9/Eg3/INuOCCJ1K1P2jd0oWLukJf4OlqO3iGJ9XesnXwgJvYD9fTvyAiwNxIM8+IZd
         Pniw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718786; x=1784323586;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OQrpvHKyfewFed1C96fmigU0fqx5g50RgiJpnH3PBzY=;
        b=L9vB8i0hehk4oEyCqhUGDJkP+VTqed81c0Fl73nos6P0+7qlNNMpIHi9eQtU3b6I24
         Cbr48q4Qzlv7Qw5B8rx1TqFpwdGYN1aXnmad5GnYcqy68hDK2r1VtQW/3GaP6S3FSwcX
         QPni7FNJ4FK5WBDcbiqgcTQBYvI9F2rdXhA11KHxfKvyCDlc7IhPGElWbyxxhZkEVqGS
         Q3MR3Sb+k/azc8gXSEfpKXltDZ6/qXZNkqQdf8N21VErBXx9nhm/ZhK3dT26X6aUEM1x
         /+AyqX+AG6vN+o6vhmdrZgOrY4johWFr9tRMe+Q3NW+Q/yt3PcG+kxgIwfGmrIVO4dKs
         DkjA==
X-Forwarded-Encrypted: i=1; AHgh+Rpo6uBTc0Mrx4Ieo0GepK7M7EO/nczftqCuMiqxC5MOjentUVHWOZSEH0rQuFn8/ujdsggTMK/mgQ==@kvack.org
X-Gm-Message-State: AOJu0Yy8GbyC7lfqXXsGHEjytqb7KOjmZLoZzgUiBmx28Tz7KrLa/1Zq
	gSAXnzbrUXY8Zv/fas4EhjQG2FmO8npJFHEqJGVt+jFsk/BBtrkBJUkeCKftccy5ZWWfoU+3KWD
	5vU8uNnof8s4psQ==
X-Received: from plrf24.prod.google.com ([2002:a17:902:ab98:b0:2cc:622b:5b52])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:120f:b0:2c9:97a7:f540 with SMTP id d9443c01a7336-2ce9f059398mr6625505ad.38.1783718785688;
 Fri, 10 Jul 2026 14:26:25 -0700 (PDT)
Date: Fri, 10 Jul 2026 21:26:06 +0000
In-Reply-To: <20260710212616.1351130-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260710212616.1351130-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260710212616.1351130-4-dmatlack@google.com>
Subject: [PATCH v7 03/12] PCI: liveupdate: Track incoming preserved PCI devices
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 148E7120002
X-Stat-Signature: uq6fywneh65q5y65y9ewxas94zc9u54n
X-HE-Tag: 1783718786-892951
X-HE-Meta: U2FsdGVkX1/64HDEHWR7IZwc7UyRLiAXwLMLdD2ejpzv72G8wzwnzh67tnPX7AFlI5Ng0A+C7NvGAFciIjOd7NVZTJOoghhEa6FlTnmaPqTSHBkFN9NyyK3Gxm7pMhsDlP8HWDKfTgSRwYbft8vs1EPwPq6JPGAGqMKZq5ju8Ze0iC1lsvBYurdnLZe5jhy8JYAZnlGYdOJRmf+mDOT53Ls+V8qQclsK2lrKi0P7HpJLg+4F3YfvimI+YlMFaXvR5/LuNKaAGolZZevFq4Lz9ZbEnKAIhT3GngwhPEg6TAa1L1SzBtWOC3DQxcq0JDEN8C4QMkSkj+hMkNJxTASEBL1GgLWPntyGV6/ysQoJ3rUr2dRk+I6UbZ4k216oBEE01LFkqQWqD+QcDzPSiJkYN9WOh/Q271jRky/xDCEhO811B2HvWBZBY0t8CB0ysaA1Z29kwhrPoGqSaE8rl4I3GYyMtvwAZNSTddUgHvYvV9/Tz2EexrKN9w0onYHbXhxSntbXKjSwq8crSur9q6tLlj6/3n0k04QbnBwpL2UUnza+eRhu1E+/mTz8hmssyKp5zDwpD+icvDmF5ESnvoAcxYVUSbnsXVxgdLqOjyM+LXmUK7vh6cMfYPPxShx7AzT0HEWELZzj2dPF4OG595gizECbxIj9Nx1lqLGUDsU7oZMIxBc1U90nFFG+R/ukVNaR5GGeGqUij1nGZKkOj7d5idA5eoxX5c9fC7Im9vpbNNtXb3VQsprL2m9c43VU+oDiLf48fW2IEUe9tvb52P2lvUa5XezRYwHbUf85f0NLtkMxDvJRY+wDbRhDlP0e/1f0p/Soynw5Iiff9vnfRy9SWvyhiHbFEUMcge7VPwGUur7IZFHD/YG0+V9jaeLGm/t07aEv55/bafo/VDJ4un7PczsqGnodyZ7xVvGiX7PFHzLuCmG9TExLlhB2N86t1Evx140ZXvZyBQXI7P+x/yn
 9uPTrQ+V
 DqWQRxKYOCP3+AXkYxznOkyMlNIcCyiuo8ZvLhycOSzq5ikow+ABaaHYngFBKYGmpXonN92UZIHnshWFz2vWY63Hr33YROkG6oG+CWQFzmZAhlvC53bh8rV2kz9R97/OJCMYnl4jjO8MCZadSwPF9V2A9I2Y3bBUc1MyvBamoSbT9JOQSTDNupCuQcDywTVdh/hQIy1axBwqDGakXDLz/vkTAuSUSUlKMoQdlz25ZlNgTf0c3YMfhN7HY3E5XC5oCdIxFKqejz6vBhQTPv9G0J6CWg/TvAVJLV/eox0gMbA/r3AT9STGteSr0G3USsBjvft4akAEKJPDKqZVcgqOZahbGAW5xg1zTr77pIH69hK7eJqHHQjue7lMgeotdHPvhxzcA0x/os9vDe2dic6Sbc1zNbUjTQDCkr7EOfCXejfnFTqMwXPsCo61IVxXECFGJkHtgcWUoBllPFbkoKI0DnvWfbbbUMxqzt7WJuouQiVcC0G207o7YgPIHpHLHEzLDpQBakk1sJhIMtBmrc9F9Q3fF637nnxv5/F+d/4OGMy0EgwufjlZvGrYcs81b62Kpjn94fQe45e9P2DC4dujnEPlsSGQxwM6sZQjidl+b9e65It5kMa5udOHtTg==
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

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 MAINTAINERS                    |   1 +
 drivers/pci/Kconfig            |   2 +-
 drivers/pci/liveupdate.c       | 240 ++++++++++++++++++++++++++++++++-
 drivers/pci/liveupdate.h       |   5 +
 drivers/pci/probe.c            |   3 +
 include/linux/pci_liveupdate.h |  13 ++
 6 files changed, 261 insertions(+), 3 deletions(-)

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
index 03075ce06ac9..df6a02240aa4 100644
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
@@ -99,6 +113,26 @@ struct pci_flb_outgoing {
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
 	struct pci_flb_outgoing *outgoing;
@@ -138,13 +172,58 @@ static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
 
 static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
 {
-	args->obj = phys_to_virt(args->data);
+	struct pci_ser *ser = phys_to_virt(args->data);
+	struct pci_flb_incoming *incoming;
+	struct pci_dev_ser *dev_ser;
+	struct kho_block_set_it it;
+	int ret = -ENOMEM;
+
+	incoming = kzalloc_obj(*incoming);
+	if (!incoming)
+		goto err_restore_free;
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
 }
 
 static void pci_flb_finish(struct liveupdate_flb_op_args *args)
 {
-	kho_restore_free(args->obj);
+	struct pci_flb_incoming *incoming = args->obj;
+
+	xa_destroy(&incoming->xa);
+	kho_block_set_destroy(&incoming->block_set);
+	kho_restore_free(incoming->ser);
+	kfree(incoming);
 }
 
 static struct liveupdate_flb_ops pci_liveupdate_flb_ops = {
@@ -298,6 +377,87 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev)
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
+
+	pci_info(dev, "Device was preserved by previous kernel across Live Update\n");
+	dev->liveupdate.incoming = dev_ser;
+
+	/*
+	 * Hold the ref on the incoming FLB until pci_liveupdate_finish() so
+	 * that dev->liveupdate.incoming cannot get freed while the PCI core
+	 * has a pointer to it. It's better to leak the incoming FLB than do a
+	 * use-after-free if driver does not call pci_liveupdate_finish().
+	 */
+}
+
 void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 {
 	/*
@@ -309,7 +469,83 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 	 */
 	if (READ_ONCE(dev->liveupdate.outgoing))
 		pci_WARN(dev, 1, "Destroying outgoing-preserved device!\n");
+
+	if (READ_ONCE(dev->liveupdate.incoming)) {
+		pci_WARN(dev, 1, "Destroying incoming-preserved device!\n");
+		pci_liveupdate_flb_put_incoming();
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
2.55.0.795.g602f6c329a-goog


