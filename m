Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8895DCCD1A5
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 00:57:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AD1E8E000A; Tue, 21 Oct 2025 20:57:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4858C8E0002; Tue, 21 Oct 2025 20:57:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39D1A8E000A; Tue, 21 Oct 2025 20:57:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2867A8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 20:57:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D71091406BB
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:57:26 +0000 (UTC)
X-FDA: 84023936892.16.D50306C
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0FB4E40005
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:57:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eXP2IDo+;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761094645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OvCKFxa6vImrc7itzom7XLQjDWDOVx6Kf2lD/YWuxDQ=;
	b=V7Z6Kvv35np2/9FzXmXY+6P4GU8lt+Oby0OMnUAColxe30SNAWp33Aax2HyBZ75eyKZjXO
	hAlvrasTeY8gOX05ejoE5bBweRqukHfspsas82cxl2c0bsQZgItXe55S4zCciP7zFRTR59
	65qP1PlAROgB1Lnej0qFAuareNqj5EE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eXP2IDo+;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761094645; a=rsa-sha256;
	cv=none;
	b=Anbg1Kw5IwKLtlXbD3PezElZtnKPrj6/zCmU2a1LVWL7ckuZLMYWkkzOcKLG1tIN62/h2i
	fWNrdkWZahd86bgS7L09K/tQZ9f64zGvdYImC3A41qWZ9oRkd9ug2/qVA5QwWKsD3wQ7cy
	g83DCw+vK3IijuZUwsEv+OsKFwoOfEY=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4e896e91368so6089711cf.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761094644; x=1761699444; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OvCKFxa6vImrc7itzom7XLQjDWDOVx6Kf2lD/YWuxDQ=;
        b=eXP2IDo+1cIS0NjldsvSV7tzuOmUeuN6Psv7yA/IoWYHkR4Qr4sg/b9JCsmVJGezdn
         aoji3mUuPZzig6Y1oaD/emqzm4843En9+qyHkREEAEar7SRJqoahvq+aQRSMriq2NnsO
         1z9ZBQ1Pu2vivI3pcoGiywZ+fpV74+LnvMwIPzDLj7tjbRXkxGGkKWSnuwLqSnTemeMj
         O7AfD1wvnId6jpIEMU6rSYfnbU2PxXqLsBhXzEhFYLw2WPY6cXc/GeGO/7gSh+RwGpym
         tGl/Q5M0DPk7IwpsnJwDjy5Pvb+KYkLdlhWFV/uk8O1hN9mb3lJXZyRNwxDbnfhLQgbI
         xnhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761094644; x=1761699444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OvCKFxa6vImrc7itzom7XLQjDWDOVx6Kf2lD/YWuxDQ=;
        b=LIwhM+tHp8WJ1IjfObTwenwerGOBEFThLAibNKRloKQV/mp9th8PZrvd4x21dQMV3X
         q9xSkh3TBXGGJ2aRdKy5j+wq4ZyDDjuR5ltWRzD82SPOhGcbeo8q4aOojJDR8M+HMM5+
         h7MH5mNJOcxMdked+z3D/Ko2ygAgz+UVJ076UaMYNpjbx4Kmp0M3XX3cTz8+h4kAImkJ
         fhAThohyUQYQ2I42C8+TigYfhf7uMPiK7sDzVnBzX1rXDFM7iJG+rT6SujbELgrdq9ZV
         hKaxfXGByU38Qfh9mybwQCXeZmglNbEaFDOfWqq+pnXf/gkxB5CUIGkbJM9PHuedeQqV
         7bMw==
X-Forwarded-Encrypted: i=1; AJvYcCUjf1Dc2UFtijP16q/76xaXDx6iKhLGR2Grr7zAEvTtlY+CiwdpN+c+RxpJxYk5wRIyvwf7nF+vBA==@kvack.org
X-Gm-Message-State: AOJu0YxLfBCbZOvBf74HpQBHBjYtlrxO80J3SNd6xRqg7OPhVwD9BErC
	Hul9Gd01j8CFSa4i4m/gISpd/aOdihc6OjnWMLDSLB+sFagwUBfy7xKCQ64XAik1n0w=
X-Gm-Gg: ASbGncviTVb71udxJUI1rY+sL4vJvgO+jlWofg5l7dQzseoM8NfyGjWJq+9MpQD0mEE
	UrALbDCk0kk1IvgjhhRHFppUu7AF0q50CY+LGm3QZymNfOPn8yR9JDy1pZ3pvl9mZAAKC71gsCc
	xDJ1v5NB50LaKq3Cz0rfHQKWP1FRLvdt6CXarFDIBGG1wK9krqub1iUzy2OVI3boRvolt8huhue
	XMYMHYUl5bHWfavKMWrvuSKKadLQWkHZOG8etLp1VV3vQg0MVsNWNtBb/6I0yYNTKhGjqcopRRW
	iceow/a9hVImiCTA3DoPpUdrOFBFbfQTlQ9m0VuUjIFB1ByxRkc7ZE7WDscJ0rFIb7Q7gbq7I5q
	qf/P7N2DfuDggfmZxmxd3YRjseFF+6jQrlwtMUbmNNP3IVFc09E+Xi5rCDn7R4JzITbZ68ibjOU
	y2FagafwsZ0uYPwGgezeDB/Kfgo7iPApjp8lWIBGXHIFZB1/jI7fiTUtSM1+c9ZwfBv0E1Ia9mw
	6B/oL/7RIKK9fnLke/Hj8Mxn1ie5xON
X-Google-Smtp-Source: AGHT+IEkF4NxRop9PUR4cBO4VtWbdt8BmHF+ZRLpywe4q/M7Dx81KpSdt3p8Ex2ZGVlVDs7zZrazYA==
X-Received: by 2002:ac8:5708:0:b0:4de:515e:6215 with SMTP id d75a77b69052e-4e89d357933mr246458351cf.46.1761094644059;
        Tue, 21 Oct 2025 17:57:24 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4e8aaf3432dsm84169501cf.2.2025.10.21.17.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 17:57:23 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	brauner@kernel.org,
	corbet@lwn.net,
	graf@amazon.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	masahiroy@kernel.org,
	ojeda@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	rppt@kernel.org,
	tj@kernel.org
Subject: [PATCHv7 3/7] kho: drop notifiers
Date: Tue, 21 Oct 2025 20:57:15 -0400
Message-ID: <20251022005719.3670224-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.915.g61a8936c21-goog
In-Reply-To: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
References: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j87p4b6urd6xjxpntdj6388gi1thhy6c
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0FB4E40005
X-HE-Tag: 1761094644-107040
X-HE-Meta: U2FsdGVkX1/1XOUU0W2CejO+8RbjRlN+irS9xQWrQGfLMi64u4/ij6FFXEETUbobEF/m31jffOXPH45Iy9BwC1lMeEj0+dJdE0LU9ilrsTW+PEjvsGq3tNAiqr5TfGpWyKrT/DMuXgqlwkVFbTikzW5bsJHgdoKmKPdvkqwdrZfqt1jBKFEuhYkWRIYaH9g6jZCzxCxikOPCCqD637J8Y5bg4gbBC6ob2KBISQyh1HRzaTmH/8DDU4n3OJBThdbP4QKwuJN2z8yV23n8wMapNL8bBNMi8b1vxoE/WwZZBe4OMdFI4chT/LT3qEQ95GIjBocyyjepKlA87Q3JmmAgoGbmIc9gGluBIjQsT5pxWN/240iwZ+6dW94CFqUXLMD6pXx/viLy+6jCUTeewlYaOEsGRhNeeP2g+ZJA+dRCXMtVIYwn0cPni3HKRnwQqMLw4qKIBCq/ifWjKy1KpBwxT8Kow2zMRrSoTqUwjDNWvWLPGdwaXoiLzbFPytlYpLeRBTkNs6lJjSmlSpwH25FEGX0u/e8zZPfRlg6KVCiKbx1RaeMIC+3jZ/1zJTTf8sl5j6+kgPEDV/mTnKl55UlG1cEndnZlbv9X/FAMziic0YFUDy2Cafn1CSiupLhqBtH3bIwKtAWeB6tXXQXyFj6GTegrJ7sKMa4F921Hn4LkhBKGgaxikxsK3EpAXIcHdS8TNRwm4VlZCPSh8FJJ5dwr36AskXfsVyIb5ynuyg+ioowBntMgXmquYD/DnZUkjoZa7lT8DT6gNaEbO2bQdQesm7w/A2v290hIVf6BhJzoVCf9/q8ksZXcdVwaChXNSA7NkWQr/pFlQ4Ebs7T5SLQN+IOG/APPLwmjHVc+fTsaL4m3xAETJPBXRybDE3A8bjEdIHqxuARzJA7m8YRwwyLrxocglOU0+mm/BBup8RArEPD33pp0PqhlNSoqaaxD5fAoHeNghMT5p745F38MiE/
 cJUfn0wJ
 TYUNeumxrGpr6L9p3YoI9VzpiHR8lBHBzN/sOZOW3XAIU8xN9QGZWZt+t9559VQuoCKLWuGpdRWb50JZfqhsX2yY7yAWdLl8g5R99bXW4u0g8ZPhieDvXPHzH+i5uzOVxGYEufHQoYChBDOlrZloU6AXp8vF4DPlTJn6aFVGw4lndxxZjJ8oy2/dw4x5raHcVhA3Lr1pFwRg1t172ebSLD76N9YgHbugAFIb5LcHBSXMqtZCeWwA/gRYQf1uu6Cc1Lh2ePeU9iowKFLSb7gXxt8yqFVLieZ40QQMkbsahViXMvuFsZIYEZbHU5LkxXBwdvxI17GviIMo6M6sUpHXQcLLy5dpCczPPzf+q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

The KHO framework uses a notifier chain as the mechanism for clients to
participate in the finalization process. While this works for a single,
central state machine, it is too restrictive for kernel-internal
components like pstore/reserve_mem or IMA. These components need a
simpler, direct way to register their state for preservation (e.g.,
during their initcall) without being part of a complex,
shutdown-time notifier sequence. The notifier model forces all
participants into a single finalization flow and makes direct
preservation from an arbitrary context difficult.
This patch refactors the client participation model by removing the
notifier chain and introducing a direct API for managing FDT subtrees.

The core kho_finalize() and kho_abort() state machine remains, but
clients now register their data with KHO beforehand.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Co-developed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kexec_handover.h   |  28 +-----
 kernel/kexec_handover.c          | 164 +++++++++++++++++--------------
 kernel/kexec_handover_debugfs.c  |  17 ++--
 kernel/kexec_handover_internal.h |   5 +-
 lib/test_kho.c                   |  30 +-----
 mm/memblock.c                    |  62 +++---------
 6 files changed, 127 insertions(+), 179 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 04d0108db98e..2faf290803ce 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -10,14 +10,7 @@ struct kho_scratch {
 	phys_addr_t size;
 };
 
-/* KHO Notifier index */
-enum kho_event {
-	KEXEC_KHO_FINALIZE = 0,
-	KEXEC_KHO_ABORT = 1,
-};
-
 struct folio;
-struct notifier_block;
 struct page;
 
 #define DECLARE_KHOSER_PTR(name, type) \
@@ -37,8 +30,6 @@ struct page;
 		(typeof((s).ptr))((s).phys ? phys_to_virt((s).phys) : NULL); \
 	})
 
-struct kho_serialization;
-
 struct kho_vmalloc_chunk;
 struct kho_vmalloc {
 	DECLARE_KHOSER_PTR(first, struct kho_vmalloc_chunk *);
@@ -57,12 +48,10 @@ int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation);
 struct folio *kho_restore_folio(phys_addr_t phys);
 struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages);
 void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
-int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt);
+int kho_add_subtree(const char *name, void *fdt);
+void kho_remove_subtree(void *fdt);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
 
-int register_kho_notifier(struct notifier_block *nb);
-int unregister_kho_notifier(struct notifier_block *nb);
-
 void kho_memory_init(void);
 
 void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t scratch_phys,
@@ -114,23 +103,16 @@ static inline void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 	return NULL;
 }
 
-static inline int kho_add_subtree(struct kho_serialization *ser,
-				  const char *name, void *fdt)
+static inline int kho_add_subtree(const char *name, void *fdt)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
+static inline void kho_remove_subtree(void *fdt)
 {
-	return -EOPNOTSUPP;
 }
 
-static inline int register_kho_notifier(struct notifier_block *nb)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int unregister_kho_notifier(struct notifier_block *nb)
+static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index da071277d85e..0a4234269fe5 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -16,7 +16,6 @@
 #include <linux/libfdt.h>
 #include <linux/list.h>
 #include <linux/memblock.h>
-#include <linux/notifier.h>
 #include <linux/page-isolation.h>
 #include <linux/vmalloc.h>
 
@@ -103,29 +102,34 @@ struct kho_mem_track {
 
 struct khoser_mem_chunk;
 
-struct kho_serialization {
-	struct page *fdt;
-	struct kho_mem_track track;
-	/* First chunk of serialized preserved memory map */
-	struct khoser_mem_chunk *preserved_mem_map;
+struct kho_sub_fdt {
+	struct list_head l;
+	const char *name;
+	void *fdt;
 };
 
 struct kho_out {
-	struct blocking_notifier_head chain_head;
-	struct mutex lock; /* protects KHO FDT finalization */
-	struct kho_serialization ser;
+	void *fdt;
 	bool finalized;
+	struct mutex lock; /* protects KHO FDT finalization */
+
+	struct list_head sub_fdts;
+	struct mutex fdts_lock;
+
+	struct kho_mem_track track;
+	/* First chunk of serialized preserved memory map */
+	struct khoser_mem_chunk *preserved_mem_map;
+
 	struct kho_debugfs dbg;
 };
 
 static struct kho_out kho_out = {
-	.chain_head = BLOCKING_NOTIFIER_INIT(kho_out.chain_head),
 	.lock = __MUTEX_INITIALIZER(kho_out.lock),
-	.ser = {
-		.track = {
-			.orders = XARRAY_INIT(kho_out.ser.track.orders, 0),
-		},
+	.track = {
+		.orders = XARRAY_INIT(kho_out.track.orders, 0),
 	},
+	.sub_fdts = LIST_HEAD_INIT(kho_out.sub_fdts),
+	.fdts_lock = __MUTEX_INITIALIZER(kho_out.fdts_lock),
 	.finalized = false,
 };
 
@@ -369,7 +373,7 @@ static void kho_mem_ser_free(struct khoser_mem_chunk *first_chunk)
 	}
 }
 
-static int kho_mem_serialize(struct kho_serialization *ser)
+static int kho_mem_serialize(struct kho_out *kho_out)
 {
 	struct khoser_mem_chunk *first_chunk = NULL;
 	struct khoser_mem_chunk *chunk = NULL;
@@ -377,7 +381,7 @@ static int kho_mem_serialize(struct kho_serialization *ser)
 	unsigned long order;
 	int err = -ENOMEM;
 
-	xa_for_each(&ser->track.orders, order, physxa) {
+	xa_for_each(&kho_out->track.orders, order, physxa) {
 		struct kho_mem_phys_bits *bits;
 		unsigned long phys;
 
@@ -409,7 +413,7 @@ static int kho_mem_serialize(struct kho_serialization *ser)
 		}
 	}
 
-	ser->preserved_mem_map = first_chunk;
+	kho_out->preserved_mem_map = first_chunk;
 
 	return 0;
 
@@ -670,7 +674,6 @@ static void __init kho_reserve_scratch(void)
 
 /**
  * kho_add_subtree - record the physical address of a sub FDT in KHO root tree.
- * @ser: serialization control object passed by KHO notifiers.
  * @name: name of the sub tree.
  * @fdt: the sub tree blob.
  *
@@ -684,34 +687,45 @@ static void __init kho_reserve_scratch(void)
  *
  * Return: 0 on success, error code on failure
  */
-int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt)
+int kho_add_subtree(const char *name, void *fdt)
 {
-	int err = 0;
-	u64 phys = (u64)virt_to_phys(fdt);
-	void *root = page_to_virt(ser->fdt);
+	struct kho_sub_fdt *sub_fdt;
+	int err;
 
-	err |= fdt_begin_node(root, name);
-	err |= fdt_property(root, PROP_SUB_FDT, &phys, sizeof(phys));
-	err |= fdt_end_node(root);
+	sub_fdt = kmalloc(sizeof(*sub_fdt), GFP_KERNEL);
+	if (!sub_fdt)
+		return -ENOMEM;
 
-	if (err)
-		return err;
+	INIT_LIST_HEAD(&sub_fdt->l);
+	sub_fdt->name = name;
+	sub_fdt->fdt = fdt;
 
-	return kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false);
+	mutex_lock(&kho_out.fdts_lock);
+	list_add_tail(&sub_fdt->l, &kho_out.sub_fdts);
+	err = kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false);
+	mutex_unlock(&kho_out.fdts_lock);
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(kho_add_subtree);
 
-int register_kho_notifier(struct notifier_block *nb)
+void kho_remove_subtree(void *fdt)
 {
-	return blocking_notifier_chain_register(&kho_out.chain_head, nb);
-}
-EXPORT_SYMBOL_GPL(register_kho_notifier);
+	struct kho_sub_fdt *sub_fdt;
+
+	mutex_lock(&kho_out.fdts_lock);
+	list_for_each_entry(sub_fdt, &kho_out.sub_fdts, l) {
+		if (sub_fdt->fdt == fdt) {
+			list_del(&sub_fdt->l);
+			kfree(sub_fdt);
+			kho_debugfs_fdt_remove(&kho_out.dbg, fdt);
+			break;
+		}
+	}
+	mutex_unlock(&kho_out.fdts_lock);
 
-int unregister_kho_notifier(struct notifier_block *nb)
-{
-	return blocking_notifier_chain_unregister(&kho_out.chain_head, nb);
 }
-EXPORT_SYMBOL_GPL(unregister_kho_notifier);
+EXPORT_SYMBOL_GPL(kho_remove_subtree);
 
 /**
  * kho_preserve_folio - preserve a folio across kexec.
@@ -726,7 +740,7 @@ int kho_preserve_folio(struct folio *folio)
 {
 	const unsigned long pfn = folio_pfn(folio);
 	const unsigned int order = folio_order(folio);
-	struct kho_mem_track *track = &kho_out.ser.track;
+	struct kho_mem_track *track = &kho_out.track;
 
 	if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
 		return -EINVAL;
@@ -747,7 +761,7 @@ EXPORT_SYMBOL_GPL(kho_preserve_folio);
  */
 int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 {
-	struct kho_mem_track *track = &kho_out.ser.track;
+	struct kho_mem_track *track = &kho_out.track;
 	const unsigned long start_pfn = page_to_pfn(page);
 	const unsigned long end_pfn = start_pfn + nr_pages;
 	unsigned long pfn = start_pfn;
@@ -848,7 +862,7 @@ static struct kho_vmalloc_chunk *new_vmalloc_chunk(struct kho_vmalloc_chunk *cur
 
 static void kho_vmalloc_unpreserve_chunk(struct kho_vmalloc_chunk *chunk)
 {
-	struct kho_mem_track *track = &kho_out.ser.track;
+	struct kho_mem_track *track = &kho_out.track;
 	unsigned long pfn = PHYS_PFN(virt_to_phys(chunk));
 
 	__kho_unpreserve(track, pfn, pfn + 1);
@@ -1030,11 +1044,11 @@ EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
 
 static int __kho_abort(void)
 {
-	int err;
+	int err = 0;
 	unsigned long order;
 	struct kho_mem_phys *physxa;
 
-	xa_for_each(&kho_out.ser.track.orders, order, physxa) {
+	xa_for_each(&kho_out.track.orders, order, physxa) {
 		struct kho_mem_phys_bits *bits;
 		unsigned long phys;
 
@@ -1044,17 +1058,13 @@ static int __kho_abort(void)
 		xa_destroy(&physxa->phys_bits);
 		kfree(physxa);
 	}
-	xa_destroy(&kho_out.ser.track.orders);
+	xa_destroy(&kho_out.track.orders);
 
-	if (kho_out.ser.preserved_mem_map) {
-		kho_mem_ser_free(kho_out.ser.preserved_mem_map);
-		kho_out.ser.preserved_mem_map = NULL;
+	if (kho_out.preserved_mem_map) {
+		kho_mem_ser_free(kho_out.preserved_mem_map);
+		kho_out.preserved_mem_map = NULL;
 	}
 
-	err = blocking_notifier_call_chain(&kho_out.chain_head, KEXEC_KHO_ABORT,
-					   NULL);
-	err = notifier_to_errno(err);
-
 	if (err)
 		pr_err("Failed to abort KHO finalization: %d\n", err);
 
@@ -1077,7 +1087,8 @@ int kho_abort(void)
 		return ret;
 
 	kho_out.finalized = false;
-	kho_debugfs_cleanup(&kho_out.dbg);
+
+	kho_debugfs_fdt_remove(&kho_out.dbg, kho_out.fdt);
 
 	return 0;
 }
@@ -1086,41 +1097,46 @@ static int __kho_finalize(void)
 {
 	int err = 0;
 	u64 *preserved_mem_map;
-	void *fdt = page_to_virt(kho_out.ser.fdt);
+	void *root = kho_out.fdt;
+	struct kho_sub_fdt *fdt;
 
-	err |= fdt_create(fdt, PAGE_SIZE);
-	err |= fdt_finish_reservemap(fdt);
-	err |= fdt_begin_node(fdt, "");
-	err |= fdt_property_string(fdt, "compatible", KHO_FDT_COMPATIBLE);
+	err |= fdt_create(root, PAGE_SIZE);
+	err |= fdt_finish_reservemap(root);
+	err |= fdt_begin_node(root, "");
+	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
 	/**
 	 * Reserve the preserved-memory-map property in the root FDT, so
 	 * that all property definitions will precede subnodes created by
 	 * KHO callers.
 	 */
-	err |= fdt_property_placeholder(fdt, PROP_PRESERVED_MEMORY_MAP,
+	err |= fdt_property_placeholder(root, PROP_PRESERVED_MEMORY_MAP,
 					sizeof(*preserved_mem_map),
 					(void **)&preserved_mem_map);
 	if (err)
 		goto abort;
 
-	err = kho_preserve_folio(page_folio(kho_out.ser.fdt));
+	err = kho_preserve_folio(virt_to_folio(kho_out.fdt));
 	if (err)
 		goto abort;
 
-	err = blocking_notifier_call_chain(&kho_out.chain_head,
-					   KEXEC_KHO_FINALIZE, &kho_out.ser);
-	err = notifier_to_errno(err);
+	err = kho_mem_serialize(&kho_out);
 	if (err)
 		goto abort;
 
-	err = kho_mem_serialize(&kho_out.ser);
-	if (err)
-		goto abort;
+	*preserved_mem_map = (u64)virt_to_phys(kho_out.preserved_mem_map);
+
+	mutex_lock(&kho_out.fdts_lock);
+	list_for_each_entry(fdt, &kho_out.sub_fdts, l) {
+		phys_addr_t phys = virt_to_phys(fdt->fdt);
 
-	*preserved_mem_map = (u64)virt_to_phys(kho_out.ser.preserved_mem_map);
+		err |= fdt_begin_node(root, fdt->name);
+		err |= fdt_property(root, PROP_SUB_FDT, &phys, sizeof(phys));
+		err |= fdt_end_node(root);
+	}
+	mutex_unlock(&kho_out.fdts_lock);
 
-	err |= fdt_end_node(fdt);
-	err |= fdt_finish(fdt);
+	err |= fdt_end_node(root);
+	err |= fdt_finish(root);
 
 abort:
 	if (err) {
@@ -1149,7 +1165,7 @@ int kho_finalize(void)
 	kho_out.finalized = true;
 
 	return kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
-				   page_to_virt(kho_out.ser.fdt), true);
+				  kho_out.fdt, true);
 }
 
 bool kho_finalized(void)
@@ -1232,15 +1248,17 @@ static __init int kho_init(void)
 {
 	int err = 0;
 	const void *fdt = kho_get_fdt();
+	struct page *fdt_page;
 
 	if (!kho_enable)
 		return 0;
 
-	kho_out.ser.fdt = alloc_page(GFP_KERNEL);
-	if (!kho_out.ser.fdt) {
+	fdt_page = alloc_page(GFP_KERNEL);
+	if (!fdt_page) {
 		err = -ENOMEM;
 		goto err_free_scratch;
 	}
+	kho_out.fdt = page_to_virt(fdt_page);
 
 	err = kho_debugfs_init();
 	if (err)
@@ -1268,8 +1286,8 @@ static __init int kho_init(void)
 	return 0;
 
 err_free_fdt:
-	put_page(kho_out.ser.fdt);
-	kho_out.ser.fdt = NULL;
+	put_page(fdt_page);
+	kho_out.fdt = NULL;
 err_free_scratch:
 	for (int i = 0; i < kho_scratch_cnt; i++) {
 		void *start = __va(kho_scratch[i].addr);
@@ -1280,7 +1298,7 @@ static __init int kho_init(void)
 	kho_enable = false;
 	return err;
 }
-late_initcall(kho_init);
+fs_initcall(kho_init);
 
 static void __init kho_release_scratch(void)
 {
@@ -1416,7 +1434,7 @@ int kho_fill_kimage(struct kimage *image)
 	if (!kho_out.finalized)
 		return 0;
 
-	image->kho.fdt = page_to_phys(kho_out.ser.fdt);
+	image->kho.fdt = virt_to_phys(kho_out.fdt);
 
 	scratch_size = sizeof(*kho_scratch) * kho_scratch_cnt;
 	scratch = (struct kexec_buf){
diff --git a/kernel/kexec_handover_debugfs.c b/kernel/kexec_handover_debugfs.c
index a91b279f1b23..46e9e6c0791f 100644
--- a/kernel/kexec_handover_debugfs.c
+++ b/kernel/kexec_handover_debugfs.c
@@ -61,14 +61,17 @@ int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
 	return __kho_debugfs_fdt_add(&dbg->fdt_list, dir, name, fdt);
 }
 
-void kho_debugfs_cleanup(struct kho_debugfs *dbg)
+void kho_debugfs_fdt_remove(struct kho_debugfs *dbg, void *fdt)
 {
-	struct fdt_debugfs *ff, *tmp;
-
-	list_for_each_entry_safe(ff, tmp, &dbg->fdt_list, list) {
-		debugfs_remove(ff->file);
-		list_del(&ff->list);
-		kfree(ff);
+	struct fdt_debugfs *ff;
+
+	list_for_each_entry(ff, &dbg->fdt_list, list) {
+		if (ff->wrapper.data == fdt) {
+			debugfs_remove(ff->file);
+			list_del(&ff->list);
+			kfree(ff);
+			break;
+		}
 	}
 }
 
diff --git a/kernel/kexec_handover_internal.h b/kernel/kexec_handover_internal.h
index 28c0e971613d..17ae101dc6ae 100644
--- a/kernel/kexec_handover_internal.h
+++ b/kernel/kexec_handover_internal.h
@@ -30,7 +30,7 @@ void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt);
 int kho_out_debugfs_init(struct kho_debugfs *dbg);
 int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
 			const void *fdt, bool root);
-void kho_debugfs_cleanup(struct kho_debugfs *dbg);
+void kho_debugfs_fdt_remove(struct kho_debugfs *dbg, void *fdt);
 #else
 static inline int kho_debugfs_init(void) { return 0; }
 static inline void kho_in_debugfs_init(struct kho_debugfs *dbg,
@@ -38,7 +38,8 @@ static inline void kho_in_debugfs_init(struct kho_debugfs *dbg,
 static inline int kho_out_debugfs_init(struct kho_debugfs *dbg) { return 0; }
 static inline int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
 				      const void *fdt, bool root) { return 0; }
-static inline void kho_debugfs_cleanup(struct kho_debugfs *dbg) {}
+static inline void kho_debugfs_fdt_remove(struct kho_debugfs *dbg,
+					  void *fdt) { }
 #endif /* CONFIG_KEXEC_HANDOVER_DEBUGFS */
 
 #ifdef CONFIG_KEXEC_HANDOVER_DEBUG
diff --git a/lib/test_kho.c b/lib/test_kho.c
index 60cd899ea745..8d57049e8c8c 100644
--- a/lib/test_kho.c
+++ b/lib/test_kho.c
@@ -39,33 +39,17 @@ struct kho_test_state {
 
 static struct kho_test_state kho_test_state;
 
-static int kho_test_notifier(struct notifier_block *self, unsigned long cmd,
-			     void *v)
+static int kho_test(void)
 {
 	struct kho_test_state *state = &kho_test_state;
-	struct kho_serialization *ser = v;
 	int err = 0;
 
-	switch (cmd) {
-	case KEXEC_KHO_ABORT:
-		return NOTIFY_DONE;
-	case KEXEC_KHO_FINALIZE:
-		/* Handled below */
-		break;
-	default:
-		return NOTIFY_BAD;
-	}
-
 	err |= kho_preserve_folio(state->fdt);
-	err |= kho_add_subtree(ser, KHO_TEST_FDT, folio_address(state->fdt));
+	err |= kho_add_subtree(KHO_TEST_FDT, folio_address(state->fdt));
 
 	return err ? NOTIFY_BAD : NOTIFY_DONE;
 }
 
-static struct notifier_block kho_test_nb = {
-	.notifier_call = kho_test_notifier,
-};
-
 static int kho_test_save_data(struct kho_test_state *state, void *fdt)
 {
 	phys_addr_t *folios_info __free(kvfree) = NULL;
@@ -102,6 +86,9 @@ static int kho_test_save_data(struct kho_test_state *state, void *fdt)
 	if (!err)
 		state->folios_info = no_free_ptr(folios_info);
 
+	if (!err)
+		err = kho_test();
+
 	return err;
 }
 
@@ -203,14 +190,8 @@ static int kho_test_save(void)
 	if (err)
 		goto err_free_folios;
 
-	err = register_kho_notifier(&kho_test_nb);
-	if (err)
-		goto err_free_fdt;
-
 	return 0;
 
-err_free_fdt:
-	folio_put(state->fdt);
 err_free_folios:
 	kvfree(folios);
 	return err;
@@ -326,7 +307,6 @@ static void kho_test_cleanup(void)
 
 static void __exit kho_test_exit(void)
 {
-	unregister_kho_notifier(&kho_test_nb);
 	kho_test_cleanup();
 }
 module_exit(kho_test_exit);
diff --git a/mm/memblock.c b/mm/memblock.c
index e23e16618e9b..e3bef9b35d63 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2444,53 +2444,18 @@ int reserve_mem_release_by_name(const char *name)
 #define MEMBLOCK_KHO_FDT "memblock"
 #define MEMBLOCK_KHO_NODE_COMPATIBLE "memblock-v1"
 #define RESERVE_MEM_KHO_NODE_COMPATIBLE "reserve-mem-v1"
-static struct page *kho_fdt;
-
-static int reserve_mem_kho_finalize(struct kho_serialization *ser)
-{
-	int err = 0, i;
-
-	for (i = 0; i < reserved_mem_count; i++) {
-		struct reserve_mem_table *map = &reserved_mem_table[i];
-		struct page *page = phys_to_page(map->start);
-		unsigned int nr_pages = map->size >> PAGE_SHIFT;
-
-		err |= kho_preserve_pages(page, nr_pages);
-	}
-
-	err |= kho_preserve_folio(page_folio(kho_fdt));
-	err |= kho_add_subtree(ser, MEMBLOCK_KHO_FDT, page_to_virt(kho_fdt));
-
-	return notifier_from_errno(err);
-}
-
-static int reserve_mem_kho_notifier(struct notifier_block *self,
-				    unsigned long cmd, void *v)
-{
-	switch (cmd) {
-	case KEXEC_KHO_FINALIZE:
-		return reserve_mem_kho_finalize((struct kho_serialization *)v);
-	case KEXEC_KHO_ABORT:
-		return NOTIFY_DONE;
-	default:
-		return NOTIFY_BAD;
-	}
-}
-
-static struct notifier_block reserve_mem_kho_nb = {
-	.notifier_call = reserve_mem_kho_notifier,
-};
 
 static int __init prepare_kho_fdt(void)
 {
 	int err = 0, i;
+	struct page *fdt_page;
 	void *fdt;
 
-	kho_fdt = alloc_page(GFP_KERNEL);
-	if (!kho_fdt)
+	fdt_page = alloc_page(GFP_KERNEL);
+	if (!fdt_page)
 		return -ENOMEM;
 
-	fdt = page_to_virt(kho_fdt);
+	fdt = page_to_virt(fdt_page);
 
 	err |= fdt_create(fdt, PAGE_SIZE);
 	err |= fdt_finish_reservemap(fdt);
@@ -2499,7 +2464,10 @@ static int __init prepare_kho_fdt(void)
 	err |= fdt_property_string(fdt, "compatible", MEMBLOCK_KHO_NODE_COMPATIBLE);
 	for (i = 0; i < reserved_mem_count; i++) {
 		struct reserve_mem_table *map = &reserved_mem_table[i];
+		struct page *page = phys_to_page(map->start);
+		unsigned int nr_pages = map->size >> PAGE_SHIFT;
 
+		err |= kho_preserve_pages(page, nr_pages);
 		err |= fdt_begin_node(fdt, map->name);
 		err |= fdt_property_string(fdt, "compatible", RESERVE_MEM_KHO_NODE_COMPATIBLE);
 		err |= fdt_property(fdt, "start", &map->start, sizeof(map->start));
@@ -2507,13 +2475,16 @@ static int __init prepare_kho_fdt(void)
 		err |= fdt_end_node(fdt);
 	}
 	err |= fdt_end_node(fdt);
-
 	err |= fdt_finish(fdt);
 
+	err |= kho_preserve_folio(page_folio(fdt_page));
+
+	if (!err)
+		err = kho_add_subtree(MEMBLOCK_KHO_FDT, fdt);
+
 	if (err) {
 		pr_err("failed to prepare memblock FDT for KHO: %d\n", err);
-		put_page(kho_fdt);
-		kho_fdt = NULL;
+		put_page(fdt_page);
 	}
 
 	return err;
@@ -2529,13 +2500,6 @@ static int __init reserve_mem_init(void)
 	err = prepare_kho_fdt();
 	if (err)
 		return err;
-
-	err = register_kho_notifier(&reserve_mem_kho_nb);
-	if (err) {
-		put_page(kho_fdt);
-		kho_fdt = NULL;
-	}
-
 	return err;
 }
 late_initcall(reserve_mem_init);
-- 
2.51.0.915.g61a8936c21-goog


