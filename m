Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C383D606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Pj67eR6P
Received: by kanga.kvack.org (Postfix)
	id 5BFE16B05C8; Tue, 10 Nov 2026 00:02:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 549256B05C9; Tue, 10 Nov 2026 00:02:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39DE46B05CA; Tue, 10 Nov 2026 00:02:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED5926B05C8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:02:25 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6AD34160880
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:25 +0000 (UTC)
X-FDA: 85418013450.01.47898B6
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9D91B1C0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Pj67eR6P;
	spf=pass (imf20.hostedemail.com: domain of 3XaXyagkKCNAFwDG9Ew3G2AA270.yA8749GJ-886Hwy6.AD2@flex--tarunsahu.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3XaXyagkKCNAFwDG9Ew3G2AA270.yA8749GJ-886Hwy6.AD2@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794286943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vA8W8np9fXaskA2k2ROSy6+asR0jHvCl6wOsZYrc5lM=;
	b=fWzJPIquhZqaOGpooAu5WNHmJ5T6wbJzwt76TdXh02TvLKrjEucZFhgJ4ZjqrXk7XDlP9B
	OGK84jyWJ+7vkDqXigDYwei+GIhx/PJ4ZpwmfsriSmF4wW79XTz7tuiTrMtDuolvvLFDMv
	7kJD2yyzZPeZjlkY1hfYRoutbNiOX64=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Pj67eR6P;
	spf=pass (imf20.hostedemail.com: domain of 3XaXyagkKCNAFwDG9Ew3G2AA270.yA8749GJ-886Hwy6.AD2@flex--tarunsahu.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3XaXyagkKCNAFwDG9Ew3G2AA270.yA8749GJ-886Hwy6.AD2@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794286943;
	b=ITa3X9bx4TZXz/T19Pq1Xt11RgpWSaEWhIdkbAO8z5xDbOpjJIxhkErzftuPNpX7QzMcde
	QjqAQn/llbbgYAMEUlsQEv8+uiJmbZo2SgY21k2vqtJRyXqXLyYfm7wRGJuYMggQc/xEG2
	/N9evSRsdBdu71GbG3AcS+xwLohdlFk=
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6b6f881bcc4so1444280a12.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:02:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794286942; x=1794891742; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vA8W8np9fXaskA2k2ROSy6+asR0jHvCl6wOsZYrc5lM=;
        b=Pj67eR6PblZgxNyg5kaiU4CAeXa0adbenDj7g9OcjfAIatL0CTV2CbjsOV+zsCha2g
         qbRNE0U3QUnXvHON7MX+WXtkOMUodznwe1S4MSvVHby1HKTlXDYbhoV9EfnyGliszrux
         IYQm9RhbJ7cYtLYUmCc9Rc/ZHNrCllucoLAefwBogjb7Xs48b+YtnU2rVu/uIZLKJ309
         5GNU0TkNgJWQ8ZzQTjiV6Xjy8M5UI9c8IgiDxiZNmfh8+cbKAMw9oNgc4krGqAW2iolb
         plrQYljDf4i4F/hm8nKU/t9JfDU3NrnVEqwbBH4VUdAkqtCFCdNurFP1g2gh12rw0/Ib
         xV6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794286942; x=1794891742;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vA8W8np9fXaskA2k2ROSy6+asR0jHvCl6wOsZYrc5lM=;
        b=YvBvi+MS8h1I4CbXlzkl2yUxKJC+qu5zClRU+XtdKYEzeYqP2/kIXJ0UAOgLvG/nSh
         8G3tl7fLb99jufC/0lje9lLpoH07ay6QZFoLI5uPz+PXlhjEbBsWvDw4AY6MNQOMd2f3
         rYF94GTHyECCtXgtdPlMOsXNpuMa1XH9Zu+VV5NySirsSRPxaXxrTfvudTyqHMBA/4Xt
         UNkhgdrSrEWCjxTaH8iZbBxRBrxH8J7P0QHfQnd9tm/pvZ+mJYvi+c4DI9EwGLQeoni0
         H7/lInFF+Ch+c3arbW66EAAVE1zHPpPKxdkhY6gVY2cjad9gjHg/mESYhJ1zkxWXPk7t
         3W4A==
X-Forwarded-Encrypted: i=1; AL+hErE9TeHSt/qmiuufSE8ezdHteulmDlknqpREilmWXLLz8Pgbk1m0AgQWTHuAT9UavE2Cv2PPc4kVvQ==@kvack.org
X-Gm-Message-State: APuU4Z/fqw0rd7nYmrwADVjdjvBEXb+FMfxLsc0m7XDdchwYywFhvq/8
	p6lBeeZ6Nv1X+klX/ItCcTdRaSlMRA2XX2wdE3Tc+ZlYsQh4Oga2j09tezGf7r/AVvaGeJvJgfh
	b+Z+sa+rlJoN6QbyAcQ==
X-Received: from edty17.prod.google.com ([2002:aa7:ccd1:0:b0:6b5:5ee4:9030])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5516:b0:6b4:87b8:1348 with SMTP id 4fb4d7f45d1cf-6b756ae845cmr1164654a12.27.1794286941928;
 Mon, 09 Nov 2026 21:02:21 -0800 (PST)
Date: Tue, 10 Nov 2026 05:01:58 +0000
In-Reply-To: <20261110050202.529473-1-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110050202.529473-16-tarunsahu@google.com>
Subject: [PATCH v4 15/19] PCI: liveupdate: Add feature header to struct pci_ser
From: Tarun Sahu <tarunsahu@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, 
	maz@kernel.org, will@kernel.org, David Matlack <dmatlack@google.com>, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: md4ssyw581t3t55e5q9r8qk58f4z1eg4
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9D91B1C0005
X-HE-Tag: 1794286943-170732
X-HE-Meta: U2FsdGVkX194liVmnhM/RHHRH+r7h0glxGBlDecZQYWOBGeE/5entBJX6/mt+NLQG0hjVp9oaXnP5Op2MemWoM6T64Ve7zUOvETUHfbnDw3ssqNjPnoYHaO6YIqeY4Y9g717QV3FjFIYVDMkUoCVFil/oWrpq1xvYdxuVEKdxOajjeDHeI8uQ3V3LqN50d94TDGbSWK+W8XfQIHJwH3BDZxcbvs7bHvDBACJyRR9r4Mk1ftqMrQTmxliIsznpSdYZKdRa7zvH6z8R0wgKlJLJQRt0ae1gJ/NsbYRzImuR7ppcJs7laj1Rmt4FCotTOqVBdnUxiYIz9Hx0N1gaSUVHTWcDIsZMPDpmdQ05O82N8K0Qf8O8Ezn1pHEgl086B1za25GNDZJlN42uMlXH8hMKxkb/WCYSEl1MwPXHv41zBurhcoKIbQtV7g45KX8U8fKI6HMzD4/6Yj//4Nrh+Lu7T+ScD7cC98Wn+hM/5zXSabCUkXHaMboO+foMBD05FtOSeYUWiQMrdyosCTYJLPVFLtGWYwlCCkgPILrlOZskDkuM/uUA+mrtRWHGUgAVbS2iPOik/HMcX7SksD1+OhtE2sJcuAMgHI9GMrC6C//LhlUFg9W7SUObCEhv+U3Fbbux9PlvKw85ceiZJ5YWoWVQAjWZAU33FIaJCvlRB3NeyC/2aG/MO/6Jt/hENsUyE6ai5cEfjI76sRsoxoyH8kb+F1h8X3t7UWZ0qxFnZ+5NjeBcU+ru1oZ4zXduXPWUUAvhuBfr9v2tvdv4XRYWE7eUYkkuXpKdLSDAIVMMmV9QzrK0jL8e9wB3E5CwHWsGyuzs5voHB/zwAnyJkTnBr/3EEVS9wuzq3HWguy2TdKOrSM3FPM9vCKSIX3oaC78NZSRZWUQUQ8loJeF0Krf/1bdhVtucmxiQfByUzNDVIUK5ALuXdMMOqynvdGcbxA8S01iZzo9ST9BrOgqlF7RcWy
 HH8dK1aZ
 OCbvxPugFzFVzkSZH5J6iXoBWY4v05VeCBDBy1wsEi6VmWRwd9XIK+EQelnEsiR269z64lWsvMlHbEW0McqJAwsr6ImvxriFm79fbqg7OchO1ZhW4LL1x2inu8M2hFdURq2ihBcRyLhPwDGJMDuGh9gVTGDKp8esqnDP2UuvjkSLVfMwWaziEtF8IUjXO3CbjA1ydjvbBvO0Ww7821aXwhk/4/uXTpVweSotX+s9+UYnxw0nybjPKaqAJMoyu36xD5f0gsC8F1SAz0S2USiEMd0Q78KrKdvuhiEh0xnyLBLpcEaLlhqCwfCOhEyxWw6rJWDGRRANwUmKkfOM/OveUrJwO3JJA+J/0IO/nGf0wAcKoO+U4CQ+4kP06vsTzie64LlXxpN+bCl3k5TkkBOWTCOqziFBwjoir7J+AiBr4TGO8MR61s5dIpQ0HRmzVHH9rjOUzZfJhs8l9bkaN9enpi6nJwSUJOMmyQB7R6MyYnEqCG3i6So752tV8pIuzssqqDNkVvmk5J2w9Xy+qhXPqvZBDcRLp9V8AcGMZIs3EX8MBzCfR/mlsoeA9TEPeiJTjl8gx6DkzfKNSBHqzTmKmW0hBxAiteIueQ15F/o14tdmQmFNps+wf3JUuUMv4RYgtoPBipCjb5NZtFmIko7bQBUD79Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

struct pci_ser currently defines its own PCI-specific required_flags and
optional_flags bitmasks (capped at 64 bits without recorded structure
size) and stores dev_ser_size in the parent structure even though KHO
block headers now record entry_size directly. In addition, struct
pci_ser and struct pci_dev_ser still carry __packed despite having
naturally aligned fields on 64-bit architectures.

Precede struct pci_ser with struct kho_ser_hdr via DECLARE_KHO_SER,
removing required_flags, optional_flags, and
PCI_SER_REQUIRED_FLAGS_SUPPORTED. Remove dev_ser_size and
PCI_DEV_SER_MIN_SIZE so restoration derives the struct pci_dev_ser stride
from the KHO block header entry_size. Drop __packed from struct pci_ser
and struct pci_dev_ser, adding an explicit u32 reserved field to struct
pci_ser for 8-byte alignment, and bump PCI_LUO_FLB_COMPATIBLE from pci to
pci-v2.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 drivers/pci/liveupdate.c    | 74 +++++++++++++++++--------------------
 include/linux/kho/abi/pci.h | 63 +++++++++++--------------------
 2 files changed, 55 insertions(+), 82 deletions(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 6f92d4ddca2b..0bda94f4a7e4 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -233,7 +233,7 @@ static struct pci_liveupdate_global pci_liveupdate = {
 
 /**
  * struct pci_flb_outgoing - Outgoing PCI FLB object
- * @ser: Pointer to the preserved struct pci_ser.
+ * @fhdr: Pointer to the serialization feature header.
  * @block_set: The KHO block set holding the outgoing devices.
  *
  * This structure holds the runtime state for the outgoing PCI Live Update
@@ -241,14 +241,14 @@ static struct pci_liveupdate_global pci_liveupdate = {
  * the serialized entries.
  */
 struct pci_flb_outgoing {
-	struct pci_ser *ser;
+	DECLARE_KHO_SER_HDR(pci_ser, *fhdr);
 	struct kho_block_set block_set;
 };
 
 /**
  * struct pci_flb_incoming - Incoming PCI FLB object
- * @ser: The incoming struct pci_ser from the previous kernel.
- * @xa: Xarray used to quickly lookup devices in @ser.
+ * @fhdr: Pointer to the serialization feature header.
+ * @xa: Xarray used to quickly lookup preserved devices.
  * @block_set: The KHO block set holding the incoming devices.
  *
  * This structure holds the runtime state for the incoming PCI Live Update
@@ -256,17 +256,11 @@ struct pci_flb_outgoing {
  * the serialized entries, and an xarray for fast lookups.
  */
 struct pci_flb_incoming {
-	struct pci_ser *ser;
+	DECLARE_KHO_SER_HDR(pci_ser, *fhdr);
 	struct xarray xa;
 	struct kho_block_set block_set;
 };
 
-/*
- * Bits in struct pci_ser::required_flags that this kernel knows how to handle.
- * No flags are currently defined.
- */
-#define PCI_SER_REQUIRED_FLAGS_SUPPORTED	0ULL
-
 /* PCI_LIVEUPDATE depends on 64BIT, so domain and bdf always fit. */
 static unsigned long pci_ser_xa_key(u32 domain, u16 bdf)
 {
@@ -276,27 +270,28 @@ static unsigned long pci_ser_xa_key(u32 domain, u16 bdf)
 static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
 {
 	struct pci_flb_outgoing *outgoing __free(kfree) = NULL;
+	DECLARE_KHO_SER_HDR(pci_ser, *fhdr);
 	struct pci_ser *ser;
 
 	outgoing = kzalloc_obj(*outgoing);
 	if (!outgoing)
 		return -ENOMEM;
 
-	ser = kho_alloc_preserve(sizeof(*ser));
-	if (IS_ERR(ser))
-		return PTR_ERR(ser);
+	fhdr = kho_alloc_preserve(kho_ser_size(pci_ser));
+	if (IS_ERR(fhdr))
+		return PTR_ERR(fhdr);
 
-	ser->required_flags = 0;
-	ser->optional_flags = 0;
-	ser->dev_ser_size = sizeof(struct pci_dev_ser);
+	kho_ser_init(fhdr, pci_ser);
+	ser = kho_ser_payload(fhdr, pci_ser);
 	ser->nr_devices = 0;
+	ser->reserved = 0;
 	ser->devices = 0;
 
-	outgoing->ser = ser;
+	outgoing->fhdr = fhdr;
 	kho_block_set_init(&outgoing->block_set, sizeof(struct pci_dev_ser));
 
 	args->obj = no_free_ptr(outgoing);
-	args->data = virt_to_phys(ser);
+	args->data = virt_to_phys(fhdr);
 	pr_debug("Preserved struct pci_ser (0x%llx)\n", args->data);
 	return 0;
 }
@@ -307,9 +302,9 @@ static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
 
 	pr_debug("Unpreserving struct pci_ser (0x%llx)\n", args->data);
 
-	WARN_ON(outgoing->ser->nr_devices);
+	WARN_ON(kho_ser_payload(outgoing->fhdr, pci_ser)->nr_devices);
 	kho_block_set_destroy(&outgoing->block_set);
-	kho_unpreserve_free(outgoing->ser);
+	kho_unpreserve_free(outgoing->fhdr);
 	kfree(outgoing);
 }
 
@@ -321,35 +316,29 @@ static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
  */
 static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
 {
-	struct pci_ser *ser = phys_to_virt(args->data);
+	DECLARE_KHO_SER_HDR(pci_ser, *fhdr) = phys_to_virt(args->data);
 	struct pci_flb_incoming *incoming;
 	struct pci_dev_ser *dev_ser;
 	struct kho_block_set_it it;
+	struct pci_ser *ser;
 	int ret;
 
 	pr_debug("Retrieving struct pci_ser (0x%llx)\n", args->data);
 
-	if (ser->required_flags & ~PCI_SER_REQUIRED_FLAGS_SUPPORTED)
-		panic("Incoming PCI FLB requires unsupported features (0x%llx)\n",
-		      ser->required_flags & ~PCI_SER_REQUIRED_FLAGS_SUPPORTED);
+	ret = kho_ser_validate(fhdr, pci_ser);
+	if (ret)
+		panic("Failed to validate incoming PCI FLB feature header (%d)\n", ret);
 
-	/*
-	 * The previous kernel may have appended fields to struct pci_dev_ser,
-	 * which this kernel ignores, but every entry must be at least the
-	 * minimum size.
-	 */
-	if (ser->dev_ser_size < PCI_DEV_SER_MIN_SIZE)
-		panic("Incoming PCI FLB has unsupported struct pci_dev_ser size (%u)\n",
-		      ser->dev_ser_size);
+	ser = kho_ser_payload(fhdr, pci_ser);
 
 	incoming = kzalloc_obj(*incoming);
 	if (!incoming)
 		panic("Failed to allocate struct pci_flb_incoming\n");
 
-	incoming->ser = ser;
+	incoming->fhdr = fhdr;
 	xa_init(&incoming->xa);
 
-	kho_block_set_init(&incoming->block_set, ser->dev_ser_size);
+	kho_block_set_init(&incoming->block_set, sizeof(struct pci_dev_ser));
 	ret = kho_block_set_restore(&incoming->block_set, ser->devices);
 	if (ret)
 		panic("Failed to restore devices KHO block set (%d)\n", ret);
@@ -393,7 +382,7 @@ static void pci_check_all_devices_finished(struct pci_flb_incoming *incoming)
 	 * This runs once the last reference to the incoming FLB is dropped, so
 	 * there are no finishers left in flight.
 	 */
-	nr_devices = incoming->ser->nr_devices;
+	nr_devices = kho_ser_payload(incoming->fhdr, pci_ser)->nr_devices;
 	if (nr_devices == 0)
 		return;
 
@@ -428,7 +417,7 @@ static void pci_flb_finish(struct liveupdate_flb_op_args *args)
 
 	xa_destroy(&incoming->xa);
 	kho_block_set_destroy(&incoming->block_set);
-	kho_restore_free(incoming->ser);
+	kho_restore_free(incoming->fhdr);
 	kfree(incoming);
 }
 
@@ -522,7 +511,7 @@ static int pci_liveupdate_unpreserve_device(struct pci_flb_outgoing *outgoing,
 		return 0;
 
 	pci_info(dev, "Device will no longer be preserved across next Live Update\n");
-	outgoing->ser->nr_devices--;
+	kho_ser_payload(outgoing->fhdr, pci_ser)->nr_devices--;
 	memset(dev_ser, 0, sizeof(*dev_ser));
 	dev->liveupdate.outgoing = NULL;
 	return 0;
@@ -580,6 +569,7 @@ static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
 	}
 
 	if (!dev->liveupdate.outgoing) {
+		struct pci_ser *ser = kho_ser_payload(outgoing->fhdr, pci_ser);
 		struct pci_dev_ser *dev_ser;
 
 		dev_ser = pci_flb_alloc_dev_ser(outgoing);
@@ -587,8 +577,8 @@ static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
 			return PTR_ERR(dev_ser);
 
 		pci_info(dev, "Device will be preserved across next Live Update\n");
-		outgoing->ser->nr_devices++;
-		outgoing->ser->devices = kho_block_set_head_pa(&outgoing->block_set);
+		ser->nr_devices++;
+		ser->devices = kho_block_set_head_pa(&outgoing->block_set);
 
 		dev_ser->domain = pci_domain_nr(dev->bus);
 		dev_ser->bdf = pci_dev_id(dev);
@@ -876,6 +866,7 @@ static int pci_liveupdate_finish_device(struct pci_ser *ser, struct pci_dev *dev
 void pci_liveupdate_finish(struct pci_dev *dev)
 {
 	struct pci_flb_incoming *incoming;
+	struct pci_ser *ser;
 
 	guard(rwsem_write)(&pci_liveupdate.rwsem);
 
@@ -885,8 +876,9 @@ void pci_liveupdate_finish(struct pci_dev *dev)
 		return;
 	}
 
+	ser = kho_ser_payload(incoming->fhdr, pci_ser);
 	for_each_pci_dev_in_path(dev) {
-		if (pci_liveupdate_finish_device(incoming->ser, dev))
+		if (pci_liveupdate_finish_device(ser, dev))
 			break;
 	}
 
diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
index c2e3a5949f73..f53f6350e53d 100644
--- a/include/linux/kho/abi/pci.h
+++ b/include/linux/kho/abi/pci.h
@@ -8,9 +8,8 @@
 #ifndef _LINUX_KHO_ABI_PCI_H
 #define _LINUX_KHO_ABI_PCI_H
 
-#include <linux/bug.h>
-#include <linux/compiler.h>
-#include <linux/stddef.h>
+#include <linux/build_bug.h>
+#include <linux/kho/abi/feature.h>
 #include <linux/types.h>
 
 /**
@@ -18,33 +17,20 @@
  *
  * The PCI core preserves its state across kexec as Live Update
  * File-Lifecycle Bound (FLB) data, identified by the compatible string
- * ``"pci"`` and laid out as described by the structs below.
+ * ``"pci-v2"`` and laid out as described by the structs below.
  *
- * This layout is a contract between kernels. Rather than being versioned, it
- * is extended according to the following rules:
+ * struct pci_ser is preceded by &struct kho_ser_hdr, which records the
+ * total size of the serialization and feature flags. See
+ * include/linux/kho/abi/feature.h for the feature header layout, feature
+ * rules, and validation.
  *
- *  * Existing fields must never be moved, resized, removed, or have their
- *    meaning changed. New fields may only be appended to the end of a struct.
- *
- *  * A bit set in ``pci_ser.required_flags`` marks a feature that the next
- *    kernel must understand to safely take over the preserved devices. The
- *    next kernel panics if it finds a bit it does not know how to handle.
- *
- *  * A bit set in ``pci_ser.optional_flags`` marks a feature that the next
- *    kernel can safely ignore if it does not understand it.
- *
- *  * Fields appended to struct pci_ser must be accompanied by a flag that
- *    indicates they are present, since the size of struct pci_ser is not
- *    recorded.
- *
- *  * The size of each struct pci_dev_ser is recorded in
- *    ``pci_ser.dev_ser_size`` and is never smaller than
- *    ``PCI_DEV_SER_MIN_SIZE``. The next kernel ignores any fields beyond the
- *    ones it knows about, and must handle entries that are smaller than its
- *    own struct pci_dev_ser.
+ * Preserved devices are serialized as struct pci_dev_ser entries stored in
+ * a KHO block set. The block header records the entry size, allowing the
+ * next kernel to step through entries using the source kernel's stride
+ * even if fields are added in later versions.
  */
 
-#define PCI_LUO_FLB_COMPATIBLE "pci"
+#define PCI_LUO_FLB_COMPATIBLE "pci-v2"
 
 /**
  * struct pci_dev_ser - Serialized state about a single PCI device.
@@ -61,13 +47,9 @@ struct pci_dev_ser {
 	u32 domain;
 	u16 bdf;
 	u16 refcount;
-} __packed;
+};
 
-/*
- * The size of struct pci_dev_ser when this ABI was introduced. Since fields
- * can only be appended, every struct pci_dev_ser is at least this large.
- */
-#define PCI_DEV_SER_MIN_SIZE offsetofend(struct pci_dev_ser, refcount)
+static_assert(sizeof(struct pci_dev_ser) == 8);
 
 /**
  * struct pci_ser - PCI Subsystem Live Update State
@@ -77,20 +59,19 @@ struct pci_dev_ser {
  * core; the state a driver needs to resume its device is preserved separately
  * by that driver.
  *
- * @required_flags: Features that the next kernel must support to take over
- *                  the preserved devices. No flags are currently defined.
- * @optional_flags: Features that the next kernel may ignore if it does not
- *                  support them. No flags are currently defined.
- * @dev_ser_size: The size in bytes of each struct pci_dev_ser in @devices.
+ * Preceded by &struct kho_ser_hdr.
+ *
  * @nr_devices: The number of devices that were preserved.
+ * @reserved: Reserved for alignment.
  * @devices: Physical address of the first KHO block containing pci_dev_ser.
  */
 struct pci_ser {
-	u64 required_flags;
-	u64 optional_flags;
-	u32 dev_ser_size;
 	u32 nr_devices;
+	u32 reserved;
 	u64 devices;
-} __packed;
+};
+
+/* Register pci_ser with KHO serialization accessors */
+DECLARE_KHO_SER(pci_ser, 16, 0, 0);
 
 #endif /* _LINUX_KHO_ABI_PCI_H */
-- 
2.56.0.506.g506a7eabc5-goog


