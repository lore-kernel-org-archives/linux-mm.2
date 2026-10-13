Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8726FCC6B1A
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 16:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10D5C6B0092; Tue, 13 Oct 2026 12:25:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E54B6B0095; Tue, 13 Oct 2026 12:25:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F154D6B0096; Tue, 13 Oct 2026 12:25:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9EADB6B0092
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:25:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1C60A0D5A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:41 +0000 (UTC)
X-FDA: 85318128882.14.D02E08E
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf29.hostedemail.com (Postfix) with ESMTP id 485DB120011
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lfGtHBT1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3gVvOaggKCM4x6uD5uw408805y.w86527EH-664Fuw4.8B0@flex--dmatlack.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3gVvOaggKCM4x6uD5uw408805y.w86527EH-664Fuw4.8B0@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791908740;
	b=EigMbanHS047I0qRMhA62MmiuukuX6+eoistlVCUg6wXjPazgaLEJlamhG1pafC6ehHg2l
	1vsYBewersc8NFEMVjqNmz3dDQH385kHqwoZD8BL7N/HCt3Rj9NAcFT6GHDhZKxUAB0TkB
	n0jlOcdTjF5WlJW1ZA6H0QhyxRDMeas=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lfGtHBT1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3gVvOaggKCM4x6uD5uw408805y.w86527EH-664Fuw4.8B0@flex--dmatlack.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3gVvOaggKCM4x6uD5uw408805y.w86527EH-664Fuw4.8B0@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791908740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7dIOTYFxAT6bXv1NTBVOEfLQAvggRVnLIDYqE+KS9Do=;
	b=fkBLZsveZIfGrM7Qb9cEjsGM2SKXWXSpQvOelgMukgwiutgstb/NfnAI4eYdhG66lErfMV
	AovUYuM85PaSIlMvi0/ZUYPjLlkDhADGriOYKW9cqvecDGySuYMZWTo/Gre7Uo/fV4JK4W
	82djHczUbX30YCtFZL9bLZTrBKWjgls=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e605efae40so40848585ad.1
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791908739; x=1792513539; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7dIOTYFxAT6bXv1NTBVOEfLQAvggRVnLIDYqE+KS9Do=;
        b=lfGtHBT17sq+D6KJ4gfpBT+BYIIIoppF1e9jLKSHowZvZf9FQIq3dsrb5eBnupvJ6b
         9a9ZMM9H0cCJp6g+Bk8/d9I09Bvm61YLQ1focLb8xyALHsxGYiTqAT8cSMfpLOsMhd+M
         Co3m6P4jaavwkggvTkIcT0MKRGzkOojd6GAS+2LC1KhzN5F+vCr+Wb/92kN9d2XpRoMA
         UQ4wJoqsCw7YaRETwQVFktz80Eju45Z7T8Nfe0LGLdWwuM9NLgH6lzOwjck1feNG+d2P
         P3okJkaX6wBOF9fS3fWtRNSbSq7oqK7MkGQvt4fe41UrpoojF4GTwomETloZ2MacIGyC
         MI+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791908739; x=1792513539;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7dIOTYFxAT6bXv1NTBVOEfLQAvggRVnLIDYqE+KS9Do=;
        b=HNPJ6gmJ+89fPHpDK7pIxAL5/tjhyGXJV8RKmJ3UHbsUizYqcdsbCLONTc/Ti0S9tu
         SFUAVBzXNyk+ZQezGUEYM/w7pvb1W9CIsXaJLcQjpUUtRZ/IV5byquOjNgU7itCFjFCq
         I+nVncU/8V52AvU3DH46xEgtHX48SRK+nPjnymUnPClAyWwXQOWsU0TIc0L943oDbtr2
         /Nbp40muuQYgF3ygblOov0Kd+lDyc2VMHQWsvz65D8DKM8Yt3h+xaTHKyxeIo3II0W2O
         F2imnYtFEILWqVpHUj3eYTlPXDcnQrC8ECrerl0Yf3XDyilNg1j1F+F2p2hT2ALIRX0C
         YC8A==
X-Forwarded-Encrypted: i=1; AKwUvBxIASrDpWh6SU1C8FT0NkJnqN0rCg6ue9/sPiQ+ZYLl5aiLFmgFZYucrT+p+GnfXs1aciqqnH7zAg==@kvack.org
X-Gm-Message-State: AFq9FYLlqIJiAKICO1NlBz7/NODZT2Q8AA8hxC/rI06TiltIbLUOXzbY
	7aWLy7IsXEkyqOMcsES8KgiyB+yNpla6kN5lXZotf5HwcW9sa4AI6oK7Qc/vJJpJqmr0xG72mH5
	hUQSybMs+Vyzq1A==
X-Received: from plse9.prod.google.com ([2002:a17:902:b789:b0:2e2:c780:1934])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f706:b0:2df:4dc5:e12e with SMTP id d9443c01a7336-2e842ab68afmr119020905ad.27.1791908737435;
 Tue, 13 Oct 2026 09:25:37 -0700 (PDT)
Date: Tue, 13 Oct 2026 16:25:19 +0000
In-Reply-To: <20261013162529.1928093-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20261013162529.1928093-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261013162529.1928093-4-dmatlack@google.com>
Subject: [PATCH v10 03/13] PCI: liveupdate: Track incoming preserved PCI devices
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
X-Stat-Signature: 7sz5ieptt8te61bzfh14zoa7387ut1y5
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 485DB120011
X-HE-Tag: 1791908740-73439
X-HE-Meta: U2FsdGVkX1+SnivQGfm4gEa3Qj62LOd8SrKE9qhQFelXu86iViFswRSwr8E5aJ8+eM5DauuisA2TWZCVhyORbX4hZ0lq2GtDrk4aohs6cxRkSgPKszcpQBbnMy0xSfR8gbnHfoFuoIXaSJzLk8iuuyQbeIccV3nL817gbsYifjWLKW+8m2VAS5LYc5WcOpmUJa468VzYbs4PRdigbIudapL9KmhaPwGuLyJycZ37KZSevCV9svVLKzAWEBa1qw/ofm7g8F2wAu9lsWQnJU3p7Ixdju5/qKaF+rR4FPP6ZZd6+GqI4uW6tX8bDKAm1SOpGGCftLs5anuvoj7FF+B6EQ8qaWKVaoksRIeaCPeSEQ8odQ0Yx06EmV+YEakmay9MWYBAZ5pGcJBioMiK4x/FowwyzSP56Taf0G9m+IpCqUbWxCe4fGWosCK6Bw83Zj4gqtPJszIxAF8ZWFIsAnvjNPeSHqedBiUhlmxkSOWUSgrJwiutC64Mie0FQmSocAK8uF+gboOdaq9C/T1Zs81YHczzvbbayTJHFp6TagZP94XPahyda3BOMTEN5OH6vmuMEg9FS+AIOX+YMGPWi/N0I9Nox90hIr8Oxd4ocbyOuF6JRt0wzYt4NgG2litXFDxrN9lycFes/BSzN4tIkccOZUMXbkdZBZMkEzno2nBnmEmqpgZCeqrd2CF3C/W+7Qet7iaJbfU1cIqwYIunBiDpfnSCVfKWMhBPr+gGuF8VCq7eBn5XVheHCWnMf+gM1OWIbiajH+A/Kohznf9X/IRHjqhAKc4QjHnspD4XOMx2HhDGG6WvP1++NLKb2ev3yKQUVNoSCAMqgji/+RM22lpp28PnjNNdKtOYK7IuBruLIvYQjfoEH5+VHbW+viuBEpXt0et6wwY5nwN5w5/p+DqVXm8Q72GyGXs/sM8chShMA3QZYaWLdAt8pKE1eq2uSQm7plpQuSRrNtc+wzsIYgy
 qvyE89dZ
 k8dqRWQDaproSnw20hf9W38WI0KwyJ691kXpuo0QMfsRPLE34wfno2hoIrMIrQvpKSZu0ToSBm+vtmLMtElA86TPUrMrO5gS2CaYySxuipqRrlKFAmUjhIIHQXyC0VBww2r8fl81flnWIhdZA/XoCv1nT4mITQp4mm9NYpdlzJyVeilV52zmZ15WTQKMVdAU5+nnEit4JA39nflc9V6ydPTLBpCwteXu+1u04PuOWm7WIfc1vWFNZAagQ6YWXzPOX72J9/dfSvWlNdXQEUo4YHBX7UmjT9ZLR1/mTr9bijKnIVKfYWFDLgfbmL6bBhccSOhH9sXyPncYpTn8LSA2SUZ1MmUFxGGX9c+0eHn8dlN1G/yMK/5CrB8EwYw8DI9swixJBIE9nJM1F7Cg0QEosZBHlfpQzxz2ASpVYNq91DoBV70vzmdg6jC/ZpPMcPXfhdfYQrLol9/eI5mR225EGRcfTN23d0vd26Nn3PxItOMIH34vTa/D6Fe2QhC81I+6V2X/E58zmq4ntGHauk4ggsqMNUF8B1aS2UXHSoJsPrGoNSKM/54OqFhnC51wq8mPzdTo7NqmLw5vPhB9/FXFMfgQP9iezKSXAp65OiNLN7ZXLLxrWF181kjYZYA==
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

pci_flb_retrieve() panics if the previous kernel set a bit in
required_flags that this kernel does not know how to handle, or if
struct pci_dev_ser entries are smaller than PCI_DEV_SER_MIN_SIZE. Fields
appended to struct pci_dev_ser by the previous kernel are ignored.

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 MAINTAINERS                    |   1 +
 drivers/pci/liveupdate.c       | 302 ++++++++++++++++++++++++++++++++-
 drivers/pci/liveupdate.h       |   5 +
 drivers/pci/probe.c            |   3 +
 include/linux/pci_liveupdate.h |  13 ++
 5 files changed, 318 insertions(+), 6 deletions(-)

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
 
diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 22d5d177e104..a1d9b2b1f9e3 100644
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
@@ -144,6 +166,34 @@ struct pci_flb_outgoing {
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
+/*
+ * Bits in struct pci_ser::required_flags that this kernel knows how to handle.
+ * No flags are currently defined.
+ */
+#define PCI_SER_REQUIRED_FLAGS_SUPPORTED	0ULL
+
+/* PCI_LIVEUPDATE depends on 64BIT, so domain and bdf always fit. */
+static unsigned long pci_ser_xa_key(u32 domain, u16 bdf)
+{
+	return (unsigned long)domain << 16 | bdf;
+}
+
 static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
 {
 	struct pci_flb_outgoing *outgoing __free(kfree) = NULL;
@@ -184,17 +234,115 @@ static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
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
+	if (ser->required_flags & ~PCI_SER_REQUIRED_FLAGS_SUPPORTED)
+		panic("Incoming PCI FLB requires unsupported features (0x%llx)\n",
+		      ser->required_flags & ~PCI_SER_REQUIRED_FLAGS_SUPPORTED);
+
+	/*
+	 * The previous kernel may have appended fields to struct pci_dev_ser,
+	 * which this kernel ignores, but every entry must be at least the
+	 * minimum size.
+	 */
+	if (ser->dev_ser_size < PCI_DEV_SER_MIN_SIZE)
+		panic("Incoming PCI FLB has unsupported struct pci_dev_ser size (%u)\n",
+		      ser->dev_ser_size);
+
+	incoming = kzalloc_obj(*incoming);
+	if (!incoming)
+		panic("Failed to allocate struct pci_flb_incoming\n");
+
+	incoming->ser = ser;
+	xa_init(&incoming->xa);
+
+	kho_block_set_init(&incoming->block_set, ser->dev_ser_size);
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
@@ -371,6 +519,75 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev)
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
@@ -382,7 +599,80 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev)
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
2.56.0.385.gd3acb90ef8-goog


