Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCDD260A5BD5
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=RZZMZsht
Received: by kanga.kvack.org (Postfix)
	id A52F76B05B8; Tue, 10 Nov 2026 00:02:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93DD66B05BA; Tue, 10 Nov 2026 00:02:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7423A6B05B8; Tue, 10 Nov 2026 00:02:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CB096B05B8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:02:10 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AED60140516
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:09 +0000 (UTC)
X-FDA: 85418012778.09.EA1648E
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	by imf17.hostedemail.com (Postfix) with ESMTP id E39F640002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=RZZMZsht;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3TqXyagkKCME0hy1uzho1nvvnsl.jvtspu14-ttr2hjr.vyn@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3TqXyagkKCME0hy1uzho1nvvnsl.jvtspu14-ttr2hjr.vyn@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794286928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3vxLVeArTOU555NjIGXbAokcuidpkXwhlCffjRLrr3o=;
	b=YG3WgAbrCX77pfD8F1FNRWBpfe9fXvNTRRTnhTQ6LIMs8XJNK1SgMkqlaMRvRPY6TxT/B2
	V4dsIWDDf/C8NrZdfvTSRoauazuomO1iCzncX4oUpvQVRWXZ+ULkmMdfxAvYm8vl7J9Ll/
	2qnM5KFsYO9xhvRq7IjW9BfEcf/zg14=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=RZZMZsht;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3TqXyagkKCME0hy1uzho1nvvnsl.jvtspu14-ttr2hjr.vyn@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3TqXyagkKCME0hy1uzho1nvvnsl.jvtspu14-ttr2hjr.vyn@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794286928;
	b=2vPbdZqMM8JsQLh4I+RX85iX0NzzkUbKJgHisfHK6Mz8QZ1GBVyv16BpCvn3/ODhQM/zN3
	W/wT4o3ZBH9L1gEfhXZ5DaHTeYfykO/EK8I2bQ1MQTLdgHi0i3RLBX3QyOTyjDoNHvo65u
	/T5zs+wiUxAeALkj/YzRFky2H8icDpY=
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c414c206673so171014166b.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794286926; x=1794891726; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3vxLVeArTOU555NjIGXbAokcuidpkXwhlCffjRLrr3o=;
        b=RZZMZshtMD3//7zBoyIyi98EesAZ4KbWekkSJ7MDIJ8UZTTXCBlPuw6zVVlu524qyr
         FwqccAEs4/Dr7Wap5yYDPfllw6pRljaqLgWFi7VGIH0k+3kxozJ+zdDhRRUtqLYsHJJw
         E+r+rT1CvIQa08Yh5ietm4o3lEenMWX3ZOdLuk6TR4gWo81hc5OiieyB8DYWgP1EEHi0
         X772nHYvesmi88y2bxWQZWu5C48ie53RVSLM7jgoNZTsozF2qaVtwk82I9+cv01QdMOb
         dI/pfnvqVT5HOIAWPmMtNldD1PMdY88dlJ6V6ml8NZwnmvf1uVVynyoXlb8hpHf15Om8
         ZVRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794286926; x=1794891726;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3vxLVeArTOU555NjIGXbAokcuidpkXwhlCffjRLrr3o=;
        b=1WFvxrUqRFTjDVlD1Heq/c9QaCSv3wQrEP3CX6ojTy4j9jt7FqBAGhUE2xdLPuq2Rm
         dqDzLPpIrNsn783BBiAnVtfphrSYAvm0KZuRg2tbZkE6RQtARhxQkJEuDWY6tNVgPE4A
         vuhi7ANiO74HCt+4Kf+T0kn48rMBdpjr4HiKOI5pn+YW+TmhCJYcskJ+1de4tSvnGbcK
         75KALAfe1KSNzKrmx4KC94TkeGmw5ilbuFhY2TGNf98DSS/kUX31Sm4x+JCk9W9KhxsJ
         bWQmMfQjFATRq9N0b4fTMr2igb/jQKeWs3XhA8JeQ0Rs5qioMWwPD7bMrikDowyg/Kwo
         SBEA==
X-Forwarded-Encrypted: i=1; AL+hErFwTVcsNHioQemkMtsJN8QKpgXIELrswghlaCPggq1RR2pnky/MBHE4w/JNrlralCzUlspUI0RzXg==@kvack.org
X-Gm-Message-State: APuU4Z/1v07Gs/6yYzUaZuycmBqj0cpH5nSBVK4G472vj1LXSOj2zKub
	tXfANXIxH1xKUBuaIFuVVYX992dZTYmVprzFOajD7rabK8G/j1qEm5eoJ4OxJeAOwOoc3xAjSQb
	eBaFzWA/Td6Q4C4Dgxg==
X-Received: from ejcuu11-n1.prod.google.com ([2002:a17:907:c60b:10b0:c3f:fb8f:67f3])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:9694:b0:c31:fb29:a137 with SMTP id a640c23a62f3a-c5049525569mr113201966b.21.1794286926296;
 Mon, 09 Nov 2026 21:02:06 -0800 (PST)
Date: Tue, 10 Nov 2026 05:01:44 +0000
In-Reply-To: <20261110050202.529473-1-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110050202.529473-2-tarunsahu@google.com>
Subject: [PATCH v4 01/19] liveupdate, kho: Remove __packed from KHO, LUO and
 memfd ABI structures
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E39F640002
X-Stat-Signature: 8b7xaio7d43jcedmatx8yowm7zdrjsgy
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794286927-153695
X-HE-Meta: U2FsdGVkX1/tApdxZ/CB3OwztWrhFVClHDWMcvAkd3mMtt03Eyg/Ve4Cfl9ODmNrmf/cDewkzHPeUzmnrTNIFjxFddgWn2ypWtdw/TfS5SQ5r3ZVtMkDsW+3GRk+TJCFGxmo61GO3u9GIrVwYrahPSMKVc2/d/96hXYNb+dg8hoZdWQAg+TqeF0eU5vbE5DTyJ4JuO08WWvsqykQKWUuTyEY4TmwQKTKDcVgNAstRJwZ1yltob6kSYjZ0bkbUSZLyHRumtxTs1co/kG2xXVc+SAVUtz7sV1dwMuLxDmQNdkC1gsjU/5+p730sLT3R2nX6T85JlxGtcA4rO4nab4jFIq7isyoQUQ78vPyEwd1BmK2dpLGqP6KNR0W1Mq+klqmYoIZGqHltn4G/cgVQn4aJq0tyaGqxudnayKwSzzv4q/TOrNcYkO5gnQBG5OUOz51shAiaHniPvCGJi4ms4Gm6skToz/EJ0F1BiGpZQ0g9VCl3sNC18HZsZkIh5p0btJqWYsX7Y9eoQneUEGZgiq63qs1aoVpBfQ4+/vQFVh4u4F774h8JYGucnZ6D8uXRZeyOjDofPM53H242wqBh/JFKR44E1Jm6YgO9dmmq3V0a2LLG791FxJ8NCnYmZ5wLG+5iPONo4lvvHuFEPnruafnZl2ZbZ5QIwLaZ2dE/Sx2jGvmcFF58te4y8e9bwN/8kyczpsfapXwf5Cdvw97UN+EgB511OmgAvJdjvEIiDap44KKC0/8F0l0EnLV9u03+PE0v7pI1QQwigqiYvDTFO7nVSdvMB1UssPKEO/GlHLSGHVaK62cRmxEWuVnudKQaRHc/59B7IDx2PivINPoYHQdS4qAkrMALHf9dcKKdaPgo1U/0465wVIjdxRxic+NzGLBjRsx0wXj2MP8z1JhS8DIpBXzcoSIKDltqCa4SdRzHkcC2lk+rKWiv1ptmeqrf7OwxacBJLqjK9knXF4osFL
 S/QZ4eae
 WfYZidB7npjz/vqUXmPgxxQCl4FVakCi4id6UWV+Q2mRkKid7LnV3szYrVg2YsNRQKVh9Mm8RCudz6DH/CbPenABsJGtskhKPiWC3I0ChTLHx2akKYUkyjD88c0DKkCGFyNO7wuHc+SPb0gbR5Vh1kAVaKGQoAVp7StOQUh0Dsl0zTDskSTv8I2bHYQD1XoJY9qxx0tmmolBT+WhyuVsCeudfj6KejUbsWw3ZGEaU26pZxyz5zsqPhtVpeG6ZA7cBLVdjOu86AoWUkWcViGu0cITd3iE/VAb4c17oZ13xmNbek2lNwg+cz/WMl0gOq6lvO4axgtdQHR7TVYD/UElZ5NUEguv5TpOrvhDaOf7vSGQALBkDtOuO/JH0sK6dd1rMYWl42oR6UvkKtg9pJcgU3ikTn+YMdpJ/ca+u68Z4T/VKoU9x/0pPEJdQc3vHeFd1zinm3plQTcWtEYLf2ywkZED7uNuL5LLfNZUa0dod81ErEEa4Ol/q9qoqEv0mCq6Fz6KjiFIgY8APduLh6LEa7FF6N/8d+j3ye7zGeSHEtsdLmETT9Agnt1slBkLn/FvFy1Go5iqY3Lx04I+M0uCKSwPVMhH9z5wKZKmvBEJKV6yYtekmezHQMTWlO71voTIASrzEJisfcrOQVxJ8a8OhcbgalQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

All structures in include/linux/kho/abi/block.h (struct
kho_block_header_ser), include/linux/kho/abi/luo.h (struct luo_ser,
struct luo_file_ser, struct luo_file_set_ser, struct luo_session_ser,
struct luo_flb_header_ser, struct luo_flb_ser) and
include/linux/kho/abi/memfd.h (struct memfd_luo_folio_ser, struct
memfd_luo_ser) have naturally aligned fields on 64-bit architectures,
with no padding holes between fields or tail padding. Assert both the
structure size and 8-byte alignment under CONFIG_64BIT at compile time.
Any future unaligned field addition should come with reserved field to
keep the structure aligned.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/block.h | 10 +++++++--
 include/linux/kho/abi/luo.h   | 38 +++++++++++++++++++++++++++++------
 include/linux/kho/abi/memfd.h | 16 ++++++++++++---
 3 files changed, 53 insertions(+), 11 deletions(-)

diff --git a/include/linux/kho/abi/block.h b/include/linux/kho/abi/block.h
index d06d64b963be..36bdbaf9b3b8 100644
--- a/include/linux/kho/abi/block.h
+++ b/include/linux/kho/abi/block.h
@@ -12,7 +12,7 @@
  * pre-update kernel to a post-update kernel.
  *
  * This interface is a contract. Any modification to the structure fields,
- * compatible strings, or the layout of the `__packed` serialization
+ * compatible strings, or the layout of the serialization
  * structures defined here constitutes a breaking change. Such changes require
  * incrementing the version number in the `KHO_FDT_COMPATIBLE` string to
  * prevent a new kernel from misinterpreting data from an old kernel.
@@ -26,6 +26,8 @@
 #define _LINUX_KHO_ABI_BLOCK_H
 
 #include <asm/page.h>
+#include <linux/build_bug.h>
+#include <linux/kconfig.h>
 #include <linux/types.h>
 
 /**
@@ -49,6 +51,10 @@
 struct kho_block_header_ser {
 	u64 next;
 	u64 count;
-} __packed;
+};
+
+static_assert(sizeof(struct kho_block_header_ser) == 16);
+static_assert(!IS_ENABLED(CONFIG_64BIT) ||
+	      __alignof__(struct kho_block_header_ser) == 8);
 
 #endif /* _LINUX_KHO_ABI_BLOCK_H */
diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index 288076de6d4a..721949374fa1 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -58,6 +58,8 @@
 #define _LINUX_KHO_ABI_LUO_H
 
 #include <linux/align.h>
+#include <linux/build_bug.h>
+#include <linux/kconfig.h>
 #include <linux/kho/abi/block.h>
 #include <uapi/linux/liveupdate.h>
 
@@ -82,7 +84,11 @@ struct luo_ser {
 	u64 liveupdate_num;
 	u64 sessions_pa;
 	u64 flbs_pa;
-} __packed;
+};
+
+static_assert(sizeof(struct luo_ser) == 32);
+static_assert(!IS_ENABLED(CONFIG_64BIT) ||
+	      __alignof__(struct luo_ser) == 8);
 
 #define LIVEUPDATE_HNDL_COMPAT_LENGTH	48
 
@@ -98,7 +104,11 @@ struct luo_file_ser {
 	char compatible[LIVEUPDATE_HNDL_COMPAT_LENGTH];
 	u64 data;
 	u64 token;
-} __packed;
+};
+
+static_assert(sizeof(struct luo_file_ser) == 64);
+static_assert(!IS_ENABLED(CONFIG_64BIT) ||
+	      __alignof__(struct luo_file_ser) == 8);
 
 /**
  * struct luo_file_set_ser - Represents the serialized metadata for file set
@@ -113,7 +123,11 @@ struct luo_file_ser {
 struct luo_file_set_ser {
 	u64 files;
 	u64 count;
-} __packed;
+};
+
+static_assert(sizeof(struct luo_file_set_ser) == 16);
+static_assert(!IS_ENABLED(CONFIG_64BIT) ||
+	      __alignof__(struct luo_file_set_ser) == 8);
 
 /**
  * struct luo_session_ser - Represents the serialized metadata for a LUO session.
@@ -131,7 +145,11 @@ struct luo_file_set_ser {
 struct luo_session_ser {
 	char name[LIVEUPDATE_SESSION_NAME_LENGTH];
 	struct luo_file_set_ser file_set_ser;
-} __packed;
+};
+
+static_assert(sizeof(struct luo_session_ser) == 80);
+static_assert(!IS_ENABLED(CONFIG_64BIT) ||
+	      __alignof__(struct luo_session_ser) == 8);
 
 /* The max size is set so it can be reliably used during in serialization */
 #define LIVEUPDATE_FLB_COMPAT_LENGTH	48
@@ -152,7 +170,11 @@ struct luo_session_ser {
 struct luo_flb_header_ser {
 	u64 pgcnt;
 	u64 count;
-} __packed;
+};
+
+static_assert(sizeof(struct luo_flb_header_ser) == 16);
+static_assert(!IS_ENABLED(CONFIG_64BIT) ||
+	      __alignof__(struct luo_flb_header_ser) == 8);
 
 /**
  * struct luo_flb_ser - Represents the serialized state of a single FLB object.
@@ -175,7 +197,11 @@ struct luo_flb_ser {
 	char name[LIVEUPDATE_FLB_COMPAT_LENGTH];
 	u64 data;
 	u64 count;
-} __packed;
+};
+
+static_assert(sizeof(struct luo_flb_ser) == 64);
+static_assert(!IS_ENABLED(CONFIG_64BIT) ||
+	      __alignof__(struct luo_flb_ser) == 8);
 
 /* Kernel Live Update Test ABI */
 #ifdef CONFIG_LIVEUPDATE_TEST
diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
index 08b10fea2afc..376a724a1d8c 100644
--- a/include/linux/kho/abi/memfd.h
+++ b/include/linux/kho/abi/memfd.h
@@ -11,6 +11,8 @@
 #ifndef _LINUX_KHO_ABI_MEMFD_H
 #define _LINUX_KHO_ABI_MEMFD_H
 
+#include <linux/build_bug.h>
+#include <linux/kconfig.h>
 #include <linux/types.h>
 #include <linux/kho/abi/kexec_handover.h>
 
@@ -20,7 +22,7 @@
  * memfd uses the ABI defined below for preserving its state across a kexec
  * reboot using the LUO.
  *
- * The state is serialized into a packed structure `struct memfd_luo_ser`
+ * The state is serialized into `struct memfd_luo_ser`
  * which is handed over to the next kernel via the KHO mechanism.
  *
  * This interface is a contract. Any modification to the structure layout
@@ -54,7 +56,11 @@ struct memfd_luo_folio_ser {
 	u64 pfn:52;
 	u64 flags:12;
 	u64 index;
-} __packed;
+};
+
+static_assert(sizeof(struct memfd_luo_folio_ser) == 16);
+static_assert(!IS_ENABLED(CONFIG_64BIT) ||
+	      __alignof__(struct memfd_luo_folio_ser) == 8);
 
 /*
  * The set of seals this version supports preserving. If support for any new
@@ -85,7 +91,11 @@ struct memfd_luo_ser {
 	u32 flags;
 	u64 nr_folios;
 	struct kho_vmalloc folios;
-} __packed;
+};
+
+static_assert(sizeof(struct memfd_luo_ser) == 48);
+static_assert(!IS_ENABLED(CONFIG_64BIT) ||
+	      __alignof__(struct memfd_luo_ser) == 8);
 
 /* The compatibility string for memfd file handler */
 #define MEMFD_LUO_FH_COMPATIBLE	"memfd-v2"
-- 
2.56.0.506.g506a7eabc5-goog


