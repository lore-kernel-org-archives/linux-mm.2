Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E17C2606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lyGfQwRb
Received: by kanga.kvack.org (Postfix)
	id 574356B05C9; Tue, 10 Nov 2026 00:02:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5227A6B05CA; Tue, 10 Nov 2026 00:02:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C2BB6B05CB; Tue, 10 Nov 2026 00:02:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E4EFA6B05C9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:02:26 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6A65D12089D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:26 +0000 (UTC)
X-FDA: 85418013492.16.3F60E0D
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	by imf19.hostedemail.com (Postfix) with ESMTP id AF17D1A0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=lyGfQwRb;
	spf=pass (imf19.hostedemail.com: domain of 3X6XyagkKCNIHyFIBGy5I4CC492.0CA96BIL-AA8Jy08.CF4@flex--tarunsahu.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=3X6XyagkKCNIHyFIBGy5I4CC492.0CA96BIL-AA8Jy08.CF4@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794286944;
	b=xvu5GLG5h4WkeTLvL+YG7arar95mPzc8KptkL6DRhPXaKS78X4qlMEnvpUaFHavvUTuuWM
	pA6Ff0JVULbgYVMY1AsdtklBHiYbkRDIfNK+NrW914zrUXiWzfcg/eQd3Z0fVPOAsDH20E
	u+vr7n2iWSPflGnN5HB2l7g8/+jzlZ0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=lyGfQwRb;
	spf=pass (imf19.hostedemail.com: domain of 3X6XyagkKCNIHyFIBGy5I4CC492.0CA96BIL-AA8Jy08.CF4@flex--tarunsahu.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=3X6XyagkKCNIHyFIBGy5I4CC492.0CA96BIL-AA8Jy08.CF4@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794286944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mz4A0EINz7FXiOtg+LRLaTUicVm3TZtwZy9VYgokgFo=;
	b=I0U2rRc7bJiwfnsNpazG/K9kQ1TJnoSt1qPVnML2D7AZjXvhimJJjS6EK+DphsLo761FzF
	bIsB8Q4Ay/4I85DNFQc/QO+lRB+uYV+jjI6KRnRGiYuZJpOmFtAwwfpLHhO/2ZMJVMvr6M
	1nlG64QsCOvVWdr841S8l/mLnciqlv8=
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6b42827bb4bso1152545a12.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794286943; x=1794891743; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Mz4A0EINz7FXiOtg+LRLaTUicVm3TZtwZy9VYgokgFo=;
        b=lyGfQwRbmI0X1iMxm51WvVhRvdY1M48iSBB/qcLSLT1xn6mvz6Q450yaPTZJtq3ufn
         k63FQaHJbEAgdyW/HU3zoiZUCIafgnLWgWVXitkFfk3zRF1DA86nfjMfAO+VV6/iSh32
         KWSkCSaYU0cU1Pai4xZrtg2J4eIZAsBLXh37idYSMzeT90E8YDdO5r6tiOH+H2eDzAxi
         nk29J/shkxTWZBGHuM5MnVuDZhfzCLxi2j4qwfDQCx417sNs+Gux5LR3VllyeNHtz5ri
         LeWaZysL85WTp31WBmSqEy11JMAIRCaKYL+gwG831C4V+c8gOcl8TgzoI/gmuUec1i1u
         rDZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794286943; x=1794891743;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mz4A0EINz7FXiOtg+LRLaTUicVm3TZtwZy9VYgokgFo=;
        b=tvSwSuHog9wyAZINuItfnSjH6C5w/JB/pB/djg0tsPWdP5cTLQzEsKoJ+Zk6AUdkLT
         JL95XpZmHqOdGy/52GoLwAkoSo4A/cEzTPVIos9qi2K2CrvCIoqNXVHu3BFOv18kuicq
         c4QE1D2To+CA9mBGRxH2FxzfO1/bU11rruC+s8xc/xlvpc49YlpaAY4+eAEPZThE+pFB
         Y49PGMF9oxTEDQIIvOFqBVh8PJiuTDQ+HAFhaaV3UgBxXv1euqkF5hPs7AEdxygejrfF
         YRQ8ppwQCkwvUTU6jxji/kpVM2xPI8ee3miHCUms3Jj6nHN//Yj/stevK239Yd4KEBqt
         wGYQ==
X-Forwarded-Encrypted: i=1; AL+hErEjI+IPWOlDRuyLqbReZlOD/Br8mRX3xxGBhrsPH5PmrHGI/5uzcNhUv5GwHNcKzrTG+lHJk/t/dQ==@kvack.org
X-Gm-Message-State: APuU4Z9/GZ+cog50g5iaQMfByxrBCgFnJH/swVQ+9y02Q39oFJ/ROR7D
	HwGaVW7Qbnj60aItiRpZW7GcHHKsCXdrOifm+4RxCm5S/fWXOQrC5QlSubk4AtCsalpiV24Qkk0
	tXTt7HmuchFYy7VUxiw==
X-Received: from edt12.prod.google.com ([2002:a05:6402:454c:b0:6a8:1d4c:399])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:1ecf:b0:6b5:6522:de39 with SMTP id 4fb4d7f45d1cf-6b756ae247dmr1199083a12.22.1794286943216;
 Mon, 09 Nov 2026 21:02:23 -0800 (PST)
Date: Tue, 10 Nov 2026 05:01:59 +0000
In-Reply-To: <20261110050202.529473-1-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110050202.529473-17-tarunsahu@google.com>
Subject: [PATCH v4 16/19] PCI: liveupdate: Add feature header to struct pci_dev_ser
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
X-Stat-Signature: qektw8uunc1thn5munt7eqffj1ks6cxz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AF17D1A0005
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794286944-195236
X-HE-Meta: U2FsdGVkX195T9kkLeDgTZPXteJ4MxXctpiyIViAg8jQfSX+53FWxiC4svwBbBZf5qYfNFYNID3j+9b9inyjsXuQUOvYq1TEmmW/HdY21RjkpjF/zEPRyPLV0yKx3ZuuYKbecieBR0w8OVl/kKJw73E9WIKfCdAzTv6OXh+70Fh4gON0hY4lCg7Jnws0q9ojZDGngCWTtjICKS+GPRenaF7+LWJH5cJQ54n5hMbkNHET6H86n+hXqc2p2BZMs7U+IOKTjlmgHb+jOPRFPHozch3NQrhkgvYo/ZAAjzXbpzZFD2LzmgWKZUeto7FXzelL/Er0Pi+i1St/sn/1HllxSHOkCYA/qB8xeW5sUHNRWzmOdDlbnGDO3fJVP/MfcbPqZew03dvsFCAtw7Nz7KQ9q6sLQnOj/pEIf7yBgQgmR1YEL3Fr/oz0J7hWwYrLLxZptWt73CHylOHHGzoJEkNVOJhQxsXB0vc8xUol73eI4dxAkNL26IrLm6wnl0KsYPUaADMmHjm9ked4HBe9uSnIQDIxuiwkvpMTzPZKNj1Gm+rJHu8Hb0gvSTiwPfWlFXsIYoGiq5AOwLtV73sPDyJgMW3c5PR8ASpke7yYW6IQm3+awwvIcA2VZpsR2L4BlW/X1h8xM6snBQ9o+kJl+kPmvWARzcnug6cLcBFYVkcni/PL+RU2Ut6Np4alZ7uwcF05l8H3HTs3Be/dA0Jl5viUnEOo53yrb3jhM2YApqee8qYNbKjgxKlhS/6Yv6ZxOtdi771xQuuygROD6yKDYg58b5VK48BTXCDN+Ex20YydM6bSobcRp0xXrtc4uMYogKohULI0cfwOOgazkKUfFRISkvWro+HmDPzDZssoexTd6BWhQyP9XRWjK/IHOTw+4eq2Z8w2axc2dGx+TlWkFCUPJJ6Ffki7iBvacigZfvldhs3s3CZaPO/ErDehY8u9Dm0Ydm7HXMVAkB8iMicQMM7
 tk+gmayl
 yu93ec66PF64DwGTKRVJK5pOGqYP27hwm7936VGwo6ZgBNPNMApjyHkh9QuW763sPGdet2eIuSzfPgvC5Iu+RPdbaHvQ30HsFNWmvZ/k4BZZeOCDiy+nqAPI4twSvC704Sp3jzr+vyEKqesSe97H3rlB34oBAMYd3v/eX06YtY5vYhZAfZvgmxdDi4StJYa+L0ieZBAwpCAzr5bVjrcFi4lfkAO+mPxN58M+8xYnDqZw+2BGUW/qYbb6zfXxu/ZGfqnQvL+J9a46ayJ2xg+FF9VifXs68Wf18ntWRFDMr0ptchxXTyFC9NayyEalqCPFA8JU7jaK3guJJFQdg4tsEF4IpM/5E5IUlYWjvptHFWlSLzAz8uPhL6UwdbUL2AhvoTaIee4Xm5E6pLvZz0sSd8uJe/0F/eH3guUcOo4pqLKoGUFVKlhqxjNsxxLoQtkYSKeat6J524ldZlcWT9FqjsnbgJ8D8pcZKrtTeMkrYQnxqZr2qzEH9A3j8aLAAKeL5kj+qvH1hZGwT+e2jDv9E2MqFctAxTWMnutjvWKs5bfD3A1VAeM0q3unIuwWV8eOBZOeskOwTP0pkL1W727T5qNnVfMbSPTMzSV7yRIymlWBWgB94nIEEXgcTVYA7hRkOTYbWLWnZITxD25ScwVSF0or8PA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Precede each serialized PCI device entry in the PCI Live Update KHO block
set with struct kho_ser_hdr via DECLARE_KHO_SER so future per-device PCI
Live Update features can append fields to struct pci_dev_ser without
breaking compatibility between adjacent kernels.

Mark struct pci_dev_ser as 8-byte aligned since its largest member is u32,
initialize the device block sets with kho_ser_size(pci_dev_ser),
initialize each entry feature header in pci_flb_alloc_dev_ser(), and
validate incoming device feature headers in pci_flb_retrieve() before
accessing the struct pci_dev_ser payload.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 drivers/pci/liveupdate.c    | 27 +++++++++++++++++++--------
 include/linux/kho/abi/pci.h |  9 ++++++---
 2 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 0bda94f4a7e4..f4c84bcc0629 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -288,7 +288,7 @@ static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
 	ser->devices = 0;
 
 	outgoing->fhdr = fhdr;
-	kho_block_set_init(&outgoing->block_set, sizeof(struct pci_dev_ser));
+	kho_block_set_init(&outgoing->block_set, kho_ser_size(pci_dev_ser));
 
 	args->obj = no_free_ptr(outgoing);
 	args->data = virt_to_phys(fhdr);
@@ -318,6 +318,7 @@ static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
 {
 	DECLARE_KHO_SER_HDR(pci_ser, *fhdr) = phys_to_virt(args->data);
 	struct pci_flb_incoming *incoming;
+	DECLARE_KHO_SER_HDR(pci_dev_ser, *dev_fhdr);
 	struct pci_dev_ser *dev_ser;
 	struct kho_block_set_it it;
 	struct pci_ser *ser;
@@ -338,15 +339,20 @@ static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
 	incoming->fhdr = fhdr;
 	xa_init(&incoming->xa);
 
-	kho_block_set_init(&incoming->block_set, sizeof(struct pci_dev_ser));
+	kho_block_set_init(&incoming->block_set, kho_ser_size(pci_dev_ser));
 	ret = kho_block_set_restore(&incoming->block_set, ser->devices);
 	if (ret)
 		panic("Failed to restore devices KHO block set (%d)\n", ret);
 
 	kho_block_set_it_init(&it, &incoming->block_set);
-	while ((dev_ser = kho_block_set_it_read_entry(&it))) {
+	while ((dev_fhdr = kho_block_set_it_read_entry(&it))) {
 		unsigned long key;
 
+		ret = kho_ser_validate(dev_fhdr, pci_dev_ser);
+		if (ret)
+			panic("Failed to validate incoming PCI device feature header (%d)\n", ret);
+
+		dev_ser = kho_ser_payload(dev_fhdr, pci_dev_ser);
 		if (!dev_ser->refcount)
 			continue;
 
@@ -456,6 +462,7 @@ static struct pci_flb_outgoing *pci_liveupdate_flb_get_outgoing(void)
 
 static struct pci_dev_ser *pci_flb_alloc_dev_ser(struct pci_flb_outgoing *outgoing)
 {
+	DECLARE_KHO_SER_HDR(pci_dev_ser, *fhdr);
 	struct pci_dev_ser *dev_ser;
 	struct kho_block_set_it it;
 	u64 count = 0;
@@ -464,9 +471,12 @@ static struct pci_dev_ser *pci_flb_alloc_dev_ser(struct pci_flb_outgoing *outgoi
 	kho_block_set_it_init(&it, &outgoing->block_set);
 
 	/* Try to find an existing, previously unpreserved, entry. */
-	while ((dev_ser = kho_block_set_it_read_entry(&it))) {
-		if (!dev_ser->refcount)
+	while ((fhdr = kho_block_set_it_read_entry(&it))) {
+		dev_ser = kho_ser_payload(fhdr, pci_dev_ser);
+		if (!dev_ser->refcount) {
+			kho_ser_init(fhdr, pci_dev_ser);
 			return dev_ser;
+		}
 
 		count++;
 	}
@@ -480,11 +490,12 @@ static struct pci_dev_ser *pci_flb_alloc_dev_ser(struct pci_flb_outgoing *outgoi
 		kho_block_set_it_init(&it, &outgoing->block_set);
 
 	/* This should always succeed since kho_block_set_grow() succeeded. */
-	dev_ser = kho_block_set_it_reserve_entry(&it);
-	if (WARN_ON_ONCE(!dev_ser))
+	fhdr = kho_block_set_it_reserve_entry(&it);
+	if (WARN_ON_ONCE(!fhdr))
 		return ERR_PTR(-ENOSPC);
 
-	return dev_ser;
+	kho_ser_init(fhdr, pci_dev_ser);
+	return kho_ser_payload(fhdr, pci_dev_ser);
 }
 
 static int pci_liveupdate_unpreserve_device(struct pci_flb_outgoing *outgoing,
diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
index f53f6350e53d..77ddf5938822 100644
--- a/include/linux/kho/abi/pci.h
+++ b/include/linux/kho/abi/pci.h
@@ -19,7 +19,8 @@
  * File-Lifecycle Bound (FLB) data, identified by the compatible string
  * ``"pci-v2"`` and laid out as described by the structs below.
  *
- * struct pci_ser is preceded by &struct kho_ser_hdr, which records the
+ * Both &struct pci_ser and each &struct pci_dev_ser entry are preceded by
+ * &struct kho_ser_hdr, which records the
  * total size of the serialization and feature flags. See
  * include/linux/kho/abi/feature.h for the feature header layout, feature
  * rules, and validation.
@@ -42,14 +43,16 @@
  *            reference count is equal to the number of preserved devices at or
  *            below it in the PCI hierarchy when the struct pci_dev_ser is in
  *            use, and 0 otherwise.
+ *
+ * Preceded by &struct kho_ser_hdr.
  */
 struct pci_dev_ser {
 	u32 domain;
 	u16 bdf;
 	u16 refcount;
-};
+} __aligned(8);
 
-static_assert(sizeof(struct pci_dev_ser) == 8);
+DECLARE_KHO_SER(pci_dev_ser, 8, 0, 0);
 
 /**
  * struct pci_ser - PCI Subsystem Live Update State
-- 
2.56.0.506.g506a7eabc5-goog


