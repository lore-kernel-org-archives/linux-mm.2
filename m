Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CC43C982E2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:07:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FC366B009B; Fri, 18 Sep 2026 16:07:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ADDE6B009D; Fri, 18 Sep 2026 16:07:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C3086B009E; Fri, 18 Sep 2026 16:07:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03D186B009B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:06:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 85615A63A1
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:06:59 +0000 (UTC)
X-FDA: 85227966558.03.E96ECE2
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf29.hostedemail.com (Postfix) with ESMTP id C7D6B120004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:06:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wVZ6szjx;
	spf=pass (imf29.hostedemail.com: domain of 34JmtaggKCCcGPDWODFNJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--dmatlack.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=34JmtaggKCCcGPDWODFNJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vbzZGi55dJ2nAk/bTrq7kQJL43h4zsV8Aw0NUk1rJVg=;
	b=0RpxB5SV1l/FFizM6eI3tPW148jj7Arx5Nw2Se/bpbGIE0b5hfN7ZkcRe/PSgiqJ7H12a6
	A3DL6jjFxSyhV+JAcBb3lFh08PiBOT0wxsiBKFtaRp/rOwUOmzdAHxQt7SaWkmduCAqAoD
	VBPXBQzmDeUKwUhkBoOf3zkBgA14GOQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762017;
	b=3RVZYiBnD2GjfY2x0f62Xowtu1BJYOyUrpJ+bAxAwXeVfVR95tGGnvF4IBYvx6rnLwK6C9
	/imTAqcz4ukigBQhC6E233ienWqEMY256U1XR672HLGDFWNus3wN9/1KDDV/FqmgebYAu7
	gQ2gg8wDN2bociqu3wtN5OYt89tsy7s=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wVZ6szjx;
	spf=pass (imf29.hostedemail.com: domain of 34JmtaggKCCcGPDWODFNJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--dmatlack.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=34JmtaggKCCcGPDWODFNJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-39de4e72b33so1927911a91.2
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789762017; x=1790366817; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vbzZGi55dJ2nAk/bTrq7kQJL43h4zsV8Aw0NUk1rJVg=;
        b=wVZ6szjxBII8gjQapuVt1r+WIn8l5eTt6JkQesIBe7g/33fqNKJkciYRcmFJbxKdfY
         wJQtgYduBvwvcYKMTFjwcR41wFtQtDtXUzulKuCfGjwezgEzu++8GHt4sYXdwPGYULWS
         RyGSrRgEwJJ/PLSVpjogT38sn/yJ48lU1DgIa4sfC/YlUr0LoFaJ/rTMa3d9XmlqiZzl
         2ZrenjSxBQYiddOrEmSH1jwWoBVdspDzb9sZik38SPJqavMyTUgOQPBQXIgLYiSp7hTc
         hVc8IlDuLxbpxESwBR1lYQV10wD4H7T1Qf4ykBCEgGS/P4c5PXDpK8QVtvnt+Ee5LFUm
         3nfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789762017; x=1790366817;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vbzZGi55dJ2nAk/bTrq7kQJL43h4zsV8Aw0NUk1rJVg=;
        b=M4qXdlSAsqVlidvXzUcOgNXwfD5s+In+Z+1UAfvRoasOnUMQdhu8KJ2boEnJcvP5wf
         j9/tql/YQIfIrJAQG+TI30Uz3STWK2y8GKIHYNRthZxjCYj6x0pMzBSjq4OkVfazEhmQ
         eB9SpZnRDduAKtzNsWHfUBezPF52nko55i9ruQQ4CHsiIGO84mXwrmN5xWQkdluQvCWn
         CqaMztP/E/vntcHKxR/CDo4y3p5PZL8lJYn3vsDjqd+fpTrwaCb3Fn+noIZCMYqqaGh1
         fd19euvcSPB97/wcfQA9LeeKKMjf51eSwqM5k9wpMvo++GDM+rnrVs6i/wB2D/3k9bWU
         g51A==
X-Forwarded-Encrypted: i=1; AKwUvBwijRdp/zsGdTnBlKOs+Z7n9B5MLfNVO33JnODQZuDFMS/tUNP9miqy+cXTmzpNGskdd6PY0dCM2w==@kvack.org
X-Gm-Message-State: AFuF++nztev/y5c4Pmql8iu+lQ9QQ1slAUUpV7yy++xMIRAGYz9URmWG
	ryopTcr3FwZGBPYLY52TJfGeEN/oity3JIfXo0Zacd5Tb9kBFIUQMMi6DfH7zmJzXxAObQ0MQ/d
	aZHG/ZY+MUl3UPQ==
X-Received: from pgav24.prod.google.com ([2002:a05:6a02:2dd8:b0:cc5:a49:270f])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:35c6:b0:3dd:a248:9c1c with SMTP id adf61e73a8af0-3dda248a06fmr654547637.46.1789762016381;
 Fri, 18 Sep 2026 13:06:56 -0700 (PDT)
Date: Fri, 18 Sep 2026 20:06:29 +0000
In-Reply-To: <20260918200640.887030-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260918200640.887030-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260918200640.887030-4-dmatlack@google.com>
Subject: [PATCH v9 03/13] PCI: liveupdate: Track incoming preserved PCI devices
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
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: hijs6kthhh7y3sjddctzo1wagokfotme
X-Rspam-User: 
X-Rspamd-Queue-Id: C7D6B120004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789762017-595696
X-HE-Meta: U2FsdGVkX1+YhUYFQ+sIJ05qAOmnJRhOeIy6pk6q8dKgqBL/FjXp+Y0g27YiSzzy3V2RZhhfh84UAESml75Y+ihE0y0nu/nErhMxLA2dgaWgfJ+9vWXFW6Aot4fm2rL8QxcLTwn7Yq3AiBqmiH11ssokSvNTiN6npuKQUGBZMDNEqMtbrDXtCfuvU+TctyXKEI52LFnSy3Ko3fRrHAg/L+hA/WX1exP75Z6BoV/ihpQb3DcTDs7PvLu16QqOf3amQSGRkau7PIfmn2rhUympg0kcXVXErlChXywYPN+AydMwPP4mdfpehDU86OD7ij1MbC3RpJvRxTMeMA9f+/EnanGXWfU/UwJix7eeKHIJm13oC5OynWB7ksAW60xzQeyxfirEa3W+tg0x5SzsiujVrGnabtVl/Fwheuy5JbGMTSoAjm3xUIs9nGenJJZV/oaAfAwV9Rbp2/R2UQEZpR7iBeVxHYgAz0PYE3D/l9qPHVapD8Z6inlGb4BmHUxCj4EvUQfdxUQkJc2KzH7lhjqVZgnJfpHMg8q1+5KmI3gew9LhnGZJeAexMF7P85pzMb0iMFgZWgbk3NRIVS+SQIA59E+xQoWlIWcanPP/JyW87zpy/7iZoXdGwxwm9Efl3MVHmruj78+K42DSP8HHg4bWaJt4kO7lm4YqqQ7s8rQD+PFSI4yQ8ECpev+V5t7a5KxIxo+kBfTc1Bv59XLbJH9TWJxraZoSyTtRp93z3ui2bGrFeN0ayCBIzfqGZs2YdhW1iAZ6bSD8S6VKasqNpEEo2ud4rJxxPcXpsGZX1HhzSR0jm/e+/TK3exc27fcIRB3ZPJRXw95zwm/D/C0hBZcPAZ+W2LCfapCCWPbwF5MIUn6e9f2VKTBZU/43PwGDRyvAMg6xqwUHaMK8ztVjpijrTLM5XB1k7eCjtTsUktaHrirjgYoIWBf+ZmTA5sqGPxjNBvrxHHbFVCPGRpkLY8c
 OxRu8Wgp
 lLjQ1XTQYJXZPvyQ5EoHavy0FsJ0z1N+P4Hb8YzHcfiN6DdmAD4u66yNsXgbsN0FB9IjBWnezTujhygSBwwDZQ8pJ9qFWGrvyDD4qI/e+0c0R3emPI0Th94/HGOhn6xg+E6N5HJViiYx+byJ8lVWZBKj+ex9vbYz6MdQktW5ueuhsa/1lipDkF6qZ3KcEKuGeoy/puMfQ4fM6TARpe+P4zThRKwxAoKUJTbwsqLji0OO0AW2UX/hxH+C7yv+jG5KViRkkiEKm4BOTXQu5N8lfdEWrZMTTRoXM6rOzhCfn1s57ylyTolb4MTnuvuOMTyhYY5tTsBSU7EM9wPLPnxIabQDRZbAqku3p5romx5sUaF4K0Qs1KhSjet7tXSpIp5JHFi+I7GCaYy1zoJa65Q2Vu2jX5uQWkNBp2DPNF3nRO9dxnuB0xwklQR/+izeoesY1AR1/80+Juma8jiMlmEYwbBgTyiN/jaFjt+bhmMFkzDsW0dQz2ndx97nX5S3LsJi82qwMzb/Eg3y9Men6Tkx7o7iMjnehqf4ioUKv57KdWYXLuxRND6QWFJHmvsn+zcOnt33LgNhKDWTM/QpBBMJdXlRKbGuisP0Sy3zItbK/Kh5F+ppv7d17H9MosQ==
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

Note that any error during pci_flb_retrieve() must be treated as fatal.
The previous kernel handed off PCI devices that are performing DMA and
the current kernel cannot safely take over those devices without this
state.

CONFIG_64BIT is now required to enable CONFIG_PCI_LIVEUPDATE so that the
domain and bdf can be guaranteed to fit in an unsigned long and be used
as the xarray key.

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 MAINTAINERS                    |   1 +
 drivers/pci/Kconfig            |   2 +-
 drivers/pci/liveupdate.c       | 286 ++++++++++++++++++++++++++++++++-
 drivers/pci/liveupdate.h       |   5 +
 drivers/pci/probe.c            |   3 +
 include/linux/pci_liveupdate.h |  13 ++
 6 files changed, 303 insertions(+), 7 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bb9ef5460b5c..3eacaa98775c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21056,6 +21056,7 @@ L:	linux-pci@vger.kernel.org
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
index e0ca537d0cb3..00776260ad6f 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -45,6 +45,11 @@
  * it (e.g. during enumeration), and pci_flb_finish() frees it once the PCI
  * core is done with it.
  *
+ * State handed over by the previous kernel is trusted. The PCI core validates
+ * it only far enough to detect an incompatible or corrupt hand over, and makes
+ * no attempt to defend against deliberate modification, since a previous kernel
+ * able to corrupt preserved state is able to corrupt arbitrary memory anyway.
+ *
  * Call Flow
  * ---------
  *
@@ -69,14 +74,17 @@
  *
  *   # ---------------- kexec ----------------
  *
- *   # New kernel: the PCI core asks for the previous kernel's state
- *   liveupdate_flb_get_incoming()
- *     luo_flb_retrieve_one()             # first request only
- *       pci_flb_retrieve()               # previous kernel's struct pci_ser
+ *   # New kernel: PCI enumeration
+ *   pci_setup_device()
+ *     pci_liveupdate_setup_device()
+ *       liveupdate_flb_get_incoming()
+ *         luo_flb_retrieve_one()         # first request only
+ *           pci_flb_retrieve()           # previous kernel's struct pci_ser
  *
  *   # Userspace: ioctl(LIVEUPDATE_SESSION_FINISH)
  *   luo_file_finish_one()
  *     fh->ops->finish()                  # driver callback
+ *       pci_liveupdate_finish(dev)       # release this device's pci_dev_ser
  *     luo_flb_file_finish()
  *       liveupdate_flb_put_incoming()    # last incoming file only
  *         pci_flb_finish()               # free struct pci_ser
@@ -93,6 +101,20 @@
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
+ * ``pci_liveupdate_preserve()``, i.e., a PCI device can be **outgoing**
+ * (preserved for next kernel) and **incoming** (preserved by previous kernel)
+ * at the same time.
+ *
  * Restrictions
  * ============
  *
@@ -144,6 +166,27 @@ struct pci_flb_outgoing {
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
+
 static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
 {
 	struct pci_flb_outgoing *outgoing __free(kfree) = NULL;
@@ -182,17 +225,106 @@ static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
 	kfree(outgoing);
 }
 
+/*
+ * Any failure here is fatal. The previous kernel handed over devices that are
+ * still performing DMA, and this kernel cannot identify them without this
+ * state. Continuing would let the PCI core reassign bus numbers and rebind
+ * drivers underneath live devices, so fail loudly instead of unwinding.
+ */
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
+	if (ser->version != PCI_LUO_FLB_VERSION)
+		panic("Incoming PCI FLB version (v%d) is incompatible with this kernel (v%d)\n",
+		      ser->version, PCI_LUO_FLB_VERSION);
+
+	incoming = kzalloc_obj(*incoming);
+	if (!incoming)
+		panic("Failed to allocate struct pci_flb_incoming\n");
+
+	incoming->ser = ser;
+	xa_init(&incoming->xa);
+
+	kho_block_set_init(&incoming->block_set, sizeof(struct pci_dev_ser));
+	ret = kho_block_set_restore(&incoming->block_set, ser->devices);
+	if (ret)
+		panic("Failed to restore devices KHO block set (%d)\n", ret);
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
+			panic("Failed to insert PCI device %04x:%02x:%02x.%d into xarray (%d)\n",
+			      dev_ser->domain, PCI_BUS_NUM(dev_ser->bdf),
+			      PCI_SLOT(dev_ser->bdf), PCI_FUNC(dev_ser->bdf),
+			      ret);
+	}
+
+	args->obj = incoming;
 	return 0;
 }
 
+static void pci_check_all_devices_finished(struct pci_flb_incoming *incoming)
+{
+	struct pci_dev_ser *dev_ser;
+	unsigned long index;
+	u32 nr_devices;
+
+	/*
+	 * nr_devices is only decremented by pci_liveupdate_finish_device().
+	 * This runs once the last reference to the incoming FLB is dropped, so
+	 * there are no finishers left in flight.
+	 */
+	nr_devices = incoming->ser->nr_devices;
+	if (nr_devices == 0)
+		return;
+
+	/*
+	 * Report the unfinished devices from the incoming FLB rather than by
+	 * walking struct pci_dev, so that devices that never showed up after
+	 * kexec, or that were destroyed before they finished, are identified
+	 * as well.
+	 */
+	xa_for_each(&incoming->xa, index, dev_ser) {
+		if (!dev_ser->refcount)
+			continue;
+
+		pr_emerg("%04x:%02x:%02x.%d was never finished!\n",
+			 dev_ser->domain, PCI_BUS_NUM(dev_ser->bdf),
+			 PCI_SLOT(dev_ser->bdf), PCI_FUNC(dev_ser->bdf));
+	}
+
+	/*
+	 * This should only happen if a driver violated the contract to call
+	 * pci_liveupdate_finish() (something is extremely broken).
+	 */
+	panic("%u preserved device(s) were never finished!\n", nr_devices);
+}
+
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
@@ -369,6 +501,75 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev)
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
@@ -380,7 +581,80 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev)
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
index 2a37e5d3e8e3..ad7fdf0d56b6 100644
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
2.55.0.1082.g2b9226bbc0-goog


