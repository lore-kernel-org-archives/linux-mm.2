Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52EDE60A383C
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 21:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=sb+Sk6rb
Received: by kanga.kvack.org (Postfix)
	id 9F9CE6B038C; Mon, 19 Oct 2026 17:31:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D1816B038E; Mon, 19 Oct 2026 17:31:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E7B56B038F; Mon, 19 Oct 2026 17:31:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 499246B038C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:31:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA6C2A087F
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:31:25 +0000 (UTC)
X-FDA: 85340672130.01.76AEECB
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0EEE91C0003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:31:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sb+Sk6rb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3KozWaggKCPkenbumbdlhpphmf.dpnmjovy-nnlwbdl.psh@flex--dmatlack.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3KozWaggKCPkenbumbdlhpphmf.dpnmjovy-nnlwbdl.psh@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792445484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lTYTkWMi5xcceVhwhueApgEoPQA4CpHfxU1jS/q1Tmw=;
	b=fQMOHWb64oZUgRB9LSG5WaqPZC829Fye5Qaxju8cGu+oUzhlTY95pZusfoFwRr71zqa78L
	gwr0Kv8FBo57EcC3AgSsxbjaWjHhkUpMqddmKpciz3OuckYnaKgEK0KI0trE88271RhM/8
	Sf600k8DwO4clR9MXXMYgHvkzeRf3IE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sb+Sk6rb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3KozWaggKCPkenbumbdlhpphmf.dpnmjovy-nnlwbdl.psh@flex--dmatlack.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3KozWaggKCPkenbumbdlhpphmf.dpnmjovy-nnlwbdl.psh@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792445484;
	b=Pa7tDtlM5Z+o5fN7LvZzmHD/fALyhtQR3nrTG8CNpa5BL710HjKDotKDyBkpYIlnycjXwE
	GwavWEvyBwupnaEn52grKtUUw23YydsWBLSjQCWyPaz+BOpR5woK3t3h28QW9PwBbgDyK5
	WUJ5Kk1eoh4n6mAizxkvvrfZCn+3Y/A=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cd60e4e8bc3so1440255a12.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792445483; x=1793050283; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lTYTkWMi5xcceVhwhueApgEoPQA4CpHfxU1jS/q1Tmw=;
        b=sb+Sk6rbJh2iIjkUnE5j9rAGNYjvkV0xvfNKi9HqByOFpV7C1yuq8q+/NQzY+lQ4/5
         TMamjuvcAEb6JotrkOTqcDY0D245YMp/JUGTaOH0v6BRLrbmgONpaZx9hlAg8YlULdAg
         xGxblpiKU0D7WdHNzRb0e07J5U44rQzai3Llo0YzopSvN5A5QSkKTe8Na35frzWnSXQz
         cBDwpVjfHChmvcc8TdTZH//RaifuCc2fVGu/INu99Wi/Ylb40ER473R0IhGPMOlPECEU
         /ZZpFEf7gt7Ud/oqENRkIDP37R9nGPMUdVCDqVrCerUm5hSo1J73q8rjEcLOV/KXvyPy
         CJTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792445483; x=1793050283;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lTYTkWMi5xcceVhwhueApgEoPQA4CpHfxU1jS/q1Tmw=;
        b=yq9CIBoOgIkSNmqK3q9LTeIzAaNRf+7EHauGydNE7X55qK7GkearLZE+xmcHdxIoI1
         lrpa8DcwvqyhKDICpDcJbZAYgUUyJaUt7r25/y9Ej3E9C2JCuE1WOnY9NQFD573QHVCx
         OwwJRe7B5OZKyVed9dimbWOXrn/gt2zDeEYK1ly97Hjj4FaLLi4UJ2Ljys91xGxTJENM
         Sk6+nLfSPEPqxkuBw8Lf3sA4MqPGN+UzDLu6RraR/V7QxeSDFZ/DjKVrdNrh5NHdc3jA
         v6d9E8TVPJPBvctcre/i+cWF0BJHcRW58cuKSPxlw6zh/gJnM5x0R6QzGeHcnPHVD7Fc
         3llA==
X-Forwarded-Encrypted: i=1; AKwUvByDblhzUsxkCzlbvexQUhY4I+VBJGsPzyinWFbEzFVjfWiAIj/8nA48jOz3+537rZLi35Hy+tyFOw==@kvack.org
X-Gm-Message-State: AFq9FYKxYC7mzDMt82o/+uA9Wm9Df3iBtcMetcyOyL48yrT+XnZoi0+4
	6vUb22AiOAFbBfLgRQGOz962NLmXOOYamXhDNAC5DrWv5AbyZ7OV9XH6lqfEK9wu57+N6IxuHXh
	zcckvmm3AANkZQA==
X-Received: from pgni18-n1.prod.google.com ([2002:a05:6a02:6a52:10b0:cd6:1e55:140d])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:3295:b0:3de:48ca:c578 with SMTP id adf61e73a8af0-3e225f843c1mr6648063637.33.1792445482515;
 Mon, 19 Oct 2026 14:31:22 -0700 (PDT)
Date: Mon, 19 Oct 2026 21:30:46 +0000
In-Reply-To: <20261019213054.3157159-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261019213054.3157159-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261019213054.3157159-3-dmatlack@google.com>
Subject: [PATCH 02/10] PCI: liveupdate: Avoid sizing BARs of incoming devices
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	David Matlack <dmatlack@google.com>, 
	"=?UTF-8?q?Ilpo=20J=C3=A4rvinen?=" <ilpo.jarvinen@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Logan Gunthorpe <logang@deltatee.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 0EEE91C0003
X-Stat-Signature: z4nrh6wr9dhhsg999b1669ap331n898y
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792445483-892763
X-HE-Meta: U2FsdGVkX1+6z94MxZGofp6F6ilze4Vw9TJYIuScfcScFmSjuffGNOo316QNDUa+bMH3M4KhNjac1BfVeMq3C8ZqhXRoPX7rhjk40El6OZUQdMgOOavoAIEKCZk/vVp7k/p9exMJEvJ2mf3H6hoBZgQnt2zxNU6MM70GcQ4QtIPysx662m3Kp+Q2L//akj9TAXnMKSfy6een0iUEJTBcv5SLSnCgpYsKT2ITWhC2i/i5gOjyIz2Wk3cRfRxajz90F+/X5u22kOT3X3pUb3WWzbeijd8O5QNuaDGDZoQzWxMEoDmGPvKDzIv0k5WImi/xNSAxbk0jNv04Yr4U8Bhj8zdEzyAfDQoiFxvZEwFfentqvaUZnbOl/468ix5Czx6A9ZTTpajxoOpydOwwVzZApSkc36RpDu94lYTDO94tBwPVWMFLaYXr/1LlMWMYafQrgchLcx/5lq/ObjehRLq3WpV6Dn1BCIRMAB9GIDuc4fsjvMO34yaRI87ilNWRS4jU8RklSYDZmNHtCVWZz0+SQrBv4ko5y4uEg/0qLBw1CoA3AUSXXoPjy05S6sdf4XhMaMKCrqDWURyq33Fz33YUTjMY/s1Q/gFe+pJlsmfSzMTiYyp0HOFeq4sO3VztuQoDmvOkXz9h/9EbpanBaE2ooEuq2qY1K6BIPhVZsoFICRC/a4Fz5nQag8iaaVKgAuknRL620xdrhkD2nC0QSAlm0dGyNCHA/zw/+fxWbVq8DwU+/i7JOfAdQXCC4DQQkrDTW5qK0QQVrP1NIvEgYIJc/Z/xHDIkJNyCONv9JDHE95AMhbz8bEGL/F4s05R04S6+0GnznJCUCKVQoa1Tj5WzH7RCd7ZsH4mTavdiSOqcCgyPlnQXkbKAs8SfE0iT0kZXdM1C9SjnTWb1EHkzOeT7ilkDZef88gmykbxLkZ/zkrBLpLm/gZON3COCjpOG75L29jc8wqrJNdaS8cxBwfY
 Rq59qswd
 FW2pmQ2jYx+dkRTTn/Djxro57RJNk60LHnMfSqi1SrWtD2mDDis7s/MmIZAH8O6eo9un/FYtNgLSM69Eh0gGlMTdLoV6db0FzScQ/95TtO2WSI7vvvBjfZqymiQYUmj3ewuMI5d2abOfPJ5OvK9yGSsz7Gj53i0gkQMUPQZwtJSI0rkLapZgArILIJQEazE5ijFi/YN/dQdnv8OuIJdDEbXYYt22bt+ybMrsUUe4ycnkXAVdUZY/2XjiW/zYZU/q/KXyIkE2eK4CcuDa/O/uv8wRK3FIgUFkthInTjab0dmOPILpabpHPYSmxXfn/cq//2mD8/nR0ZKB92VamU4cq7HB/nB05KqKhtiv2OHarFr8P2/+svIhL6RdgZnBitNxHMLW5leWQqCX8HcbMaluzMKfIu1BG54boIvqjfSJXgzASXg4Wxm+noPzitZhDymWbP+igxcVx+BIr/DQ7CIPHDiU17eiBjViuiL+dr0ZdsE8rXIIAElebZqgH1wLFQ+FXE4Oeiy2u92kYjoYt7XtWyEeo0Pcccc73VPK3G88y34a31YkeSOpBh2xkV2E1MPVKbqrb1CnqHJRWyCkcAcyPg23yhoOEnJziykT9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Avoid sizing the BARs of incoming preserved devices during enumeration.
Instead, have the previous kernel pass the BAR masks in struct
pci_dev_ser and use those in place of sizing.

Sizing a BAR requires disabling decoding. While decoding is disabled,
the device does not respond to memory transactions targeting its BARs:
Posted Writes are silently dropped and Reads fail with Unsupported
Request. This would disrupt anything that keeps accessing a preserved
device across Live Update, such as P2PDMA from other preserved devices,
or MMIO from VMs whose vCPUs keep running during kexec.

Sizing is the only part of reading a BAR that requires writing to it.
The address and type of each BAR can be read from the device without
disturbing it. So pass only the result of sizing across Live Update:
for each BAR register, the value it returns when read after writing all
1s to it (its mask). Append the masks to struct pci_dev_ser and
advertise their presence with a new optional feature flag,
PCI_SER_OPTIONAL_BAR_MASKS. The next kernel then decodes the BARs as if
it had sized them, so the ABI does not depend on any kernel-internal
state such as IORESOURCE_* flags.

Compute the masks from the size of each resource in
pci_liveupdate_freeze(), once preservation status can no longer change
and just before kexec, rather than when the device is preserved. A BAR
can change size after the device is preserved, e.g. via Resizable BAR,
in which case the next kernel would decode the BAR with the wrong size.

Cache the optional features of the incoming FLB that this kernel
supports in struct pci_liveupdate_global when the FLB is retrieved, so
they can be checked without getting a reference to the incoming FLB,
and verify that the incoming struct pci_dev_ser entries are large
enough to contain the fields of those features.

If the previous kernel did not pass BAR masks, fall back to sizing the
BARs.

Assisted-by: LLM
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c    | 138 +++++++++++++++++++++++++++++++++++-
 drivers/pci/liveupdate.h    |   9 +++
 drivers/pci/probe.c         |  10 +++
 include/linux/kho/abi/pci.h |  25 ++++++-
 4 files changed, 178 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 6f92d4ddca2b..f48cab3cc232 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -197,6 +197,13 @@
  *  * The PCI core does not disable bus mastering on outgoing preserved devices
  *    during kexec. This allows preserved devices to issue memory transactions
  *    throughout the Live Update.
+ *
+ *  * The PCI core does not size the BARs of incoming preserved devices, since
+ *    sizing requires disabling decoding, which would disrupt memory
+ *    transactions targeting the device (e.g. P2PDMA, or MMIO from VMs whose
+ *    vCPUs keep running during kexec). Instead, the previous kernel passes the
+ *    size of each BAR in struct pci_dev_ser. Everything else about the BARs
+ *    (e.g. their addresses and types) is read from the device as usual.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -221,10 +228,14 @@
  * @had_incoming: True if the previous kernel preserved at least one PCI device.
  *                Set when the incoming FLB is retrieved and never cleared, so
  *                it stays true after Live Update finishes.
+ * @incoming_optional_flags: The optional features in the incoming FLB
+ *                           (struct pci_ser::optional_flags) that this kernel
+ *                           supports. Set when the incoming FLB is retrieved.
  */
 struct pci_liveupdate_global {
 	struct rw_semaphore rwsem;
 	bool had_incoming;
+	u64 incoming_optional_flags;
 };
 
 static struct pci_liveupdate_global pci_liveupdate = {
@@ -267,6 +278,26 @@ struct pci_flb_incoming {
  */
 #define PCI_SER_REQUIRED_FLAGS_SUPPORTED	0ULL
 
+/*
+ * Bits in struct pci_ser::optional_flags that this kernel knows how to handle.
+ * This kernel also provides all of them to the next kernel.
+ */
+#define PCI_SER_OPTIONAL_FLAGS_SUPPORTED	PCI_SER_OPTIONAL_BAR_MASKS
+
+/*
+ * The minimum size of struct pci_dev_ser given the optional features that are
+ * present in it.
+ */
+static u32 pci_dev_ser_min_size(u64 optional_flags)
+{
+	u32 size = PCI_DEV_SER_MIN_SIZE;
+
+	if (optional_flags & PCI_SER_OPTIONAL_BAR_MASKS)
+		size = max(size, offsetofend(struct pci_dev_ser, rom_mask));
+
+	return size;
+}
+
 /* PCI_LIVEUPDATE depends on 64BIT, so domain and bdf always fit. */
 static unsigned long pci_ser_xa_key(u32 domain, u16 bdf)
 {
@@ -287,7 +318,7 @@ static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
 		return PTR_ERR(ser);
 
 	ser->required_flags = 0;
-	ser->optional_flags = 0;
+	ser->optional_flags = PCI_SER_OPTIONAL_FLAGS_SUPPORTED;
 	ser->dev_ser_size = sizeof(struct pci_dev_ser);
 	ser->nr_devices = 0;
 	ser->devices = 0;
@@ -325,6 +356,7 @@ static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
 	struct pci_flb_incoming *incoming;
 	struct pci_dev_ser *dev_ser;
 	struct kho_block_set_it it;
+	u64 optional_flags;
 	int ret;
 
 	pr_debug("Retrieving struct pci_ser (0x%llx)\n", args->data);
@@ -333,12 +365,16 @@ static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
 		panic("Incoming PCI FLB requires unsupported features (0x%llx)\n",
 		      ser->required_flags & ~PCI_SER_REQUIRED_FLAGS_SUPPORTED);
 
+	/* Ignore any optional features that this kernel does not support. */
+	optional_flags = ser->optional_flags & PCI_SER_OPTIONAL_FLAGS_SUPPORTED;
+
 	/*
 	 * The previous kernel may have appended fields to struct pci_dev_ser,
 	 * which this kernel ignores, but every entry must be at least the
-	 * minimum size.
+	 * minimum size, including the fields of the optional features that
+	 * are present.
 	 */
-	if (ser->dev_ser_size < PCI_DEV_SER_MIN_SIZE)
+	if (ser->dev_ser_size < pci_dev_ser_min_size(optional_flags))
 		panic("Incoming PCI FLB has unsupported struct pci_dev_ser size (%u)\n",
 		      ser->dev_ser_size);
 
@@ -378,6 +414,8 @@ static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
 	if (!xa_empty(&incoming->xa))
 		pci_liveupdate.had_incoming = true;
 
+	pci_liveupdate.incoming_optional_flags = optional_flags;
+
 	args->obj = incoming;
 	return 0;
 }
@@ -541,6 +579,53 @@ static void pci_liveupdate_unpreserve_path(struct pci_flb_outgoing *outgoing,
 	}
 }
 
+/*
+ * Compute the value that the BAR backing resource @resno of @dev returns when
+ * read after writing all 1s to it, from the size of the resource.
+ */
+static u64 pci_liveupdate_bar_mask(struct pci_dev *dev, int resno)
+{
+	struct resource *res = &dev->resource[resno];
+	resource_size_t size = resource_size(res);
+
+	if (!res->flags || !size)
+		return 0;
+
+	/* Skip resources that are not decoded by the BAR. */
+	if (res->flags & IORESOURCE_PCI_EA_BEI)
+		return 0;
+
+	if (resno == PCI_ROM_RESOURCE && (res->flags & IORESOURCE_ROM_SHADOW))
+		return 0;
+
+	/* The size of a BAR is always a power of 2. */
+	pci_WARN_ONCE(dev, size & (size - 1),
+		      "%s %pR: Size is not a power of 2\n",
+		      pci_resource_name(dev, resno), res);
+
+	return ~((u64)size - 1);
+}
+
+static void pci_liveupdate_save_bar_masks(struct pci_dev *dev,
+					  struct pci_dev_ser *dev_ser)
+{
+	u64 mask;
+	int i;
+
+	for (i = 0; i < PCI_STD_NUM_BARS; i++) {
+		mask = pci_liveupdate_bar_mask(dev, i);
+		dev_ser->bar_masks[i] = lower_32_bits(mask);
+
+		/* The upper half of a 64-bit BAR is in the next register. */
+		if ((dev->resource[i].flags & IORESOURCE_MEM_64) &&
+		    i + 1 < PCI_STD_NUM_BARS)
+			dev_ser->bar_masks[++i] = upper_32_bits(mask);
+	}
+
+	mask = pci_liveupdate_bar_mask(dev, PCI_ROM_RESOURCE);
+	dev_ser->rom_mask = lower_32_bits(mask);
+}
+
 static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
 					  struct pci_dev *dev)
 {
@@ -833,6 +918,14 @@ void pci_liveupdate_freeze(struct pci_dev *dev)
 {
 	guard(rwsem_write)(&pci_liveupdate.rwsem);
 	dev->liveupdate.frozen = true;
+
+	/*
+	 * Save the BAR masks of outgoing devices now that preservation status
+	 * is frozen, rather than when the devices are preserved, in case the
+	 * size of a BAR changes in between (e.g. via Resizable BAR).
+	 */
+	if (dev->liveupdate.outgoing)
+		pci_liveupdate_save_bar_masks(dev, dev->liveupdate.outgoing);
 }
 
 static int pci_liveupdate_finish_device(struct pci_ser *ser, struct pci_dev *dev)
@@ -984,6 +1077,45 @@ bool pci_liveupdate_is_outgoing(struct pci_dev *dev)
 	return dev->liveupdate.outgoing;
 }
 
+/**
+ * pci_liveupdate_read_bar_masks() - Get the BAR masks of an incoming device
+ * @dev: The PCI device
+ * @nr_bars: The number of standard BARs to get masks for
+ * @bar_masks: Array of @nr_bars entries to fill with the standard BAR masks
+ * @rom_mask: Filled with the Expansion ROM BAR mask, if not NULL
+ *
+ * Get the BAR masks passed by the previous kernel, i.e. the values that the
+ * BARs of @dev return when read after writing all 1s to them, so that the BARs
+ * do not need to be sized.
+ *
+ * Return: 0 on success, or <0 if @dev is not incoming-preserved or the
+ * previous kernel did not pass BAR masks.
+ */
+int pci_liveupdate_read_bar_masks(struct pci_dev *dev, unsigned int nr_bars,
+				  u32 *bar_masks, u32 *rom_mask)
+{
+	struct pci_dev_ser *dev_ser;
+	unsigned int i;
+
+	guard(rwsem_read)(&pci_liveupdate.rwsem);
+
+	dev_ser = dev->liveupdate.incoming;
+	if (!dev_ser)
+		return -EINVAL;
+
+	if (!(pci_liveupdate.incoming_optional_flags &
+	      PCI_SER_OPTIONAL_BAR_MASKS))
+		return -EOPNOTSUPP;
+
+	for (i = 0; i < nr_bars; i++)
+		bar_masks[i] = dev_ser->bar_masks[i];
+
+	if (rom_mask)
+		*rom_mask = dev_ser->rom_mask;
+
+	return 0;
+}
+
 /**
  * pci_liveupdate_is_incoming() - Check if a device is incoming-preserved
  * @dev: The PCI device to check
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
index 333ddd8f36c5..80749f14beea 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -19,6 +19,8 @@ bool pci_liveupdate_refuse_bus_numbers(struct pci_bus *bus, struct pci_dev *dev)
 int pci_liveupdate_adopt_acs(struct pci_dev *dev);
 int pci_liveupdate_adopt_ari(struct pci_dev *dev);
 bool pci_liveupdate_is_outgoing(struct pci_dev *dev);
+int pci_liveupdate_read_bar_masks(struct pci_dev *dev, unsigned int nr_bars,
+				  u32 *bar_masks, u32 *rom_mask);
 #else
 static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
 {
@@ -57,6 +59,13 @@ static inline bool pci_liveupdate_is_outgoing(struct pci_dev *dev)
 {
 	return false;
 }
+
+static inline int pci_liveupdate_read_bar_masks(struct pci_dev *dev,
+						unsigned int nr_bars,
+						u32 *bar_masks, u32 *rom_mask)
+{
+	return -EINVAL;
+}
 #endif
 
 #endif /* DRIVERS_PCI_LIVEUPDATE_H */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 9187f1d91766..3cb2e481eddf 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -328,6 +328,16 @@ static void pci_size_bases(struct pci_dev *dev, unsigned int howmany, int rom,
 {
 	u16 orig_cmd;
 
+	/*
+	 * Sizing BARs requires disabling decoding, which would disrupt memory
+	 * transactions targeting devices preserved across Live Update (e.g.
+	 * P2PDMA, or MMIO from VMs whose vCPUs keep running during kexec), so
+	 * use the BAR masks passed by the previous kernel for those devices.
+	 */
+	if (!pci_liveupdate_read_bar_masks(dev, howmany, stdbars,
+					   rom ? rombar : NULL))
+		return;
+
 	/* No printks while decoding is disabled! */
 	if (!dev->mmio_always_on) {
 		pci_read_config_word(dev, PCI_COMMAND, &orig_cmd);
diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
index c2e3a5949f73..5fa2ecfe5b6d 100644
--- a/include/linux/kho/abi/pci.h
+++ b/include/linux/kho/abi/pci.h
@@ -8,8 +8,10 @@
 #ifndef _LINUX_KHO_ABI_PCI_H
 #define _LINUX_KHO_ABI_PCI_H
 
+#include <linux/bits.h>
 #include <linux/bug.h>
 #include <linux/compiler.h>
+#include <linux/pci_regs.h>
 #include <linux/stddef.h>
 #include <linux/types.h>
 
@@ -56,11 +58,24 @@
  *            reference count is equal to the number of preserved devices at or
  *            below it in the PCI hierarchy when the struct pci_dev_ser is in
  *            use, and 0 otherwise.
+ * @bar_masks: The value each standard BAR register returns when read after
+ *             writing all 1s to it, i.e. the mask that encodes the size of the
+ *             BAR. Only the address bits are meaningful. A 64-bit BAR uses two
+ *             entries, like it uses two registers. 0 if the BAR is not
+ *             implemented. Used by the next kernel instead of sizing the BARs,
+ *             which requires disabling decoding and would disrupt memory
+ *             transactions targeting the device.
+ * @rom_mask: Same as @bar_masks, but for the Expansion ROM BAR.
+ *
+ * Each field after @refcount is only present if the ``PCI_SER_OPTIONAL_*``
+ * flag that covers it is set in ``pci_ser.optional_flags``.
  */
 struct pci_dev_ser {
 	u32 domain;
 	u16 bdf;
 	u16 refcount;
+	u32 bar_masks[PCI_STD_NUM_BARS];
+	u32 rom_mask;
 } __packed;
 
 /*
@@ -80,7 +95,7 @@ struct pci_dev_ser {
  * @required_flags: Features that the next kernel must support to take over
  *                  the preserved devices. No flags are currently defined.
  * @optional_flags: Features that the next kernel may ignore if it does not
- *                  support them. No flags are currently defined.
+ *                  support them (``PCI_SER_OPTIONAL_*``).
  * @dev_ser_size: The size in bytes of each struct pci_dev_ser in @devices.
  * @nr_devices: The number of devices that were preserved.
  * @devices: Physical address of the first KHO block containing pci_dev_ser.
@@ -93,4 +108,12 @@ struct pci_ser {
 	u64 devices;
 } __packed;
 
+/*
+ * Bits in struct pci_ser::optional_flags. If a bit is set, @dev_ser_size is
+ * large enough to contain the fields of struct pci_dev_ser that it covers:
+ *
+ *  * PCI_SER_OPTIONAL_BAR_MASKS: @bar_masks and @rom_mask
+ */
+#define PCI_SER_OPTIONAL_BAR_MASKS	BIT_ULL(0)
+
 #endif /* _LINUX_KHO_ABI_PCI_H */
-- 
2.56.0.212.g129ede20d9-goog


