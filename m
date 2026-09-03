Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61D29C624DA
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 02:35:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01B136B00F4; Wed,  2 Sep 2026 22:35:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F34D16B00F6; Wed,  2 Sep 2026 22:35:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E71466B00F7; Wed,  2 Sep 2026 22:35:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D25D6B00F4
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 22:35:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B50CEA0436
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:35:00 +0000 (UTC)
X-FDA: 85170883560.19.8E7DBB3
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0B2D7100008
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:34:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OQk0YaGx;
	spf=pass (imf05.hostedemail.com: domain of 30dyYagoKCEox0smz0pqxxs00sxq.o0yxuz69-yyw7mow.03s@flex--loganodell.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=30dyYagoKCEox0smz0pqxxs00sxq.o0yxuz69-yyw7mow.03s@flex--loganodell.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788402899;
	b=gWPONDGyNTVPaRlgMBxSrEW1HXiLw8Ha+FRS/SWtwNBou4EXliXEPTJMjb2bJwYDPaYd3Q
	oO+ZR5brJ1Z7eLbtu6E0PjmSj6CRiNXs4QI9450tHqdhwT0wBmnsIe5uJx2G1C5f2AkYJy
	5kRp7cSc9YRSxs8aTipZLtXGauCuLkw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OQk0YaGx;
	spf=pass (imf05.hostedemail.com: domain of 30dyYagoKCEox0smz0pqxxs00sxq.o0yxuz69-yyw7mow.03s@flex--loganodell.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=30dyYagoKCEox0smz0pqxxs00sxq.o0yxuz69-yyw7mow.03s@flex--loganodell.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788402899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t1Sj3SZIoFO1IrO+MibWwCI7jpIestNZ9bFRqEQ8nhA=;
	b=SVFFm96T4GGwOhfKLytssyDIt/Sr4+Ogb/YTsx7bY7Nroe4UTq3U16xTxB+KxI6y7WRtNm
	iKRcsJ6PBRMS0zMxOMV/W8i9/zEQxFtQhzTQbXDCrKAekSTDevUSWYCZmOzO1q5tEPKTQE
	Tzpt0JlSGuM3QEoGmQWT0QbWjRC+aSw=
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-39af92138f9so895186a91.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 19:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788402898; x=1789007698; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t1Sj3SZIoFO1IrO+MibWwCI7jpIestNZ9bFRqEQ8nhA=;
        b=OQk0YaGxvHsBlOkHeoRhbK3sVo4dm4njM6IV7xePdXSpmRFrbORwuYzpqnCmVYtMc1
         m5i2tRaH96sfPUMoZ5kyqDOa9nVtKxP+zlChxZUU2Vf84V33mGj/XMTR4xkY4ymXt8vJ
         hXOzdGKfiYHZr9gM2wO1Xzu9iezkoyMk1IhT7KXNszc8Ho+FHEUlgHqPk05wHn6QN+Yu
         WineRBs2a6erNgsW/OQpXbJvtJPG4rdO9X7QukQRa9AmMKT4nRrGVXJusJGL66Ky0wJn
         TG7aeGpeC9P3vJPCjBoHgtkvEiYY1uCaT1EFlYgtls99oP5ZdF3EWHJJbRx8j+F7/dzU
         S2yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788402898; x=1789007698;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t1Sj3SZIoFO1IrO+MibWwCI7jpIestNZ9bFRqEQ8nhA=;
        b=nlJRufJ7b54gjLIf3iiXAE28eydiiCd9DMGOkvu+1pbTZs+k+0HSr28sD6dHFjsDfd
         aDtIKYf9dhU+hwEGgisje/TuIrRYQ2yaB0s4qwMxO7gIWOJFdmnDjZCtWusLn+/+68WM
         hcz6tyylUOJwrn1/YI/mzigJAQeSQkaeAI4hfQkt7k/MqAPk5vcx4oiEPr72t9didsme
         FHZu2ZuBwv7hegSQk2LNdwi9vrCZPXMIN1n14IIHs79/kTb38uv3/F5RwqXA+DhxQnen
         +hSDVYRRZgWFhw3JL61aC2/dmtZFld+dnKv+eGo/jF3TJ5sO/PW2yV+HCCin7WnGZ4Cn
         qnsg==
X-Forwarded-Encrypted: i=1; AKwUvByYE2hbXiRGuD7A1uR1PfLAAAxjJWEwp/xY+IZ5rmX9k3kuwR477w3xMwfeoBQ4KT+zBY4lmvdHbA==@kvack.org
X-Gm-Message-State: AFuF++lHAFGMAKGCUDngUt/QHc9toNCX3uMsldGxCGarbYpTga/2EQmY
	raH8/A8zoSQS8FaFSMHTbHISnQaRis34EAGt+oqYHNp1XnAXXfu7BkZGni4+C+kisfSe6NOGcfL
	T/nNUqHUglZ/ZU/QwImSIxQ==
X-Received: from dybdb19.prod.google.com ([2002:a05:7300:b093:b0:328:684d:3f7])
 (user=loganodell job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4b04:b0:396:4ce0:6400 with SMTP id 98e67ed59e1d1-39b07f33963mr3591851a91.2.1788402897557;
 Wed, 02 Sep 2026 19:34:57 -0700 (PDT)
Date: Wed,  2 Sep 2026 19:34:51 -0700
In-Reply-To: <20260903023452.721732-1-loganodell@google.com>
Mime-Version: 1.0
References: <20260903023452.721732-1-loganodell@google.com>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260903023452.721732-3-loganodell@google.com>
Subject: [RFC PATCH 2/3] luo: Export feature support to vmlinux section
From: Logan Odell <loganodell@google.com>
To: arnd@arndb.de, pasha.tatashin@soleen.com, rppt@kernel.org, 
	pratyush@kernel.org, graf@amazon.com, akpm@linux-foundation.org, 
	pbonzini@redhat.com, maz@kernel.org, oupton@kernel.org, seanjc@google.com, 
	bhelgaas@google.com, alex@shazbot.org, jgg@nvidia.com, kevin.tian@intel.com, 
	dwmw2@infradead.org, baolu.lu@linux.intel.com, joro@8bytes.org, 
	will@kernel.org, robin.murphy@arm.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-pci@vger.kernel.org, iommu@lists.linux.dev, 
	Logan Odell <loganodell@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: ggswmuxgjwmy1dxyitg4eq6mmup8h9nz
X-Rspamd-Queue-Id: 0B2D7100008
X-Rspamd-Server: rspam06
X-HE-Tag: 1788402898-431043
X-HE-Meta: U2FsdGVkX1/iTyAfAxCsIYNDUxjvzGU8C6T0xMHGLGm2eSgAY/GhHKTBcc+iMI0X25XbJk+BaN9PcGwB5qsZIFwnLYIbn6o9hx7Hu8/aFNoh2zsykoFBlVo8aE8FJS9al0PdeHq0iOKmLDiMc4ZflYBVaz+Kl2xX1Nl2j/Stnj/39w+Bo4CoN6J5BolBPwJ2OQMpQfN6qH0X3KaUsOo7944pY0t8DyTF6+hE6o0ggU8V2vUcH0LmiAVFhW8zEQg/jWpefNFT5PsTiTN8dA/b1hLRqkPyzpVYFOF/li68N6BWbxpbMqzqG6SRNIAUQpOM6bC/KPtLQmTWNiuRzfolC4raT2yo0HP3SWuitrsa3GLc7vplPWSWx1SHmTmATC+1zY50KS2EPc4k7oMO4C68EOTmx9AXkiQHgpnAKTK2hEvBtK96iZBgixaXUlYQmYu4t39+Gi2zKfjsmJl6tb7a4NMFGQ6S6GJkaymWoQN1oIhqt4h+Q5gGX7cEW1mX4k2i/5FFuS9Q9pfjnUmUQ39UT9H5K8stfM3XIIHyOZqjgIESAM8DDjM/j6FCJaTS5Etf7uADrt0JHdLgSEaGkYU6ofcM5gBdHU1fGQ87o+MDIq2dgPHC672J29X5lUTioWQcnkaNbLfw9zTzXOJfMN5RFEzm+2MHHBVFvAaC/52SYuVFJyKq9KA5bhrYY78bwk+p7wVHz/lrIpj8iaEGwk9iSY+rFy8eCVLO3sCeUvvrGXmDZN8Ic6Pv9WflnRQTXq2lJ9Di0GDLZl6XXLS3/LHDm9gP1/2WV/3yezU3RqPZTolmQQK79WAFDHQS6E7ZufqBMjKo3C0Aplr3Vd5kStd64ONRtsG0cLKLMKehz0l4pNUSXtKZvQp8DWTTfLkJxSuD4U3b2jctzwCamOX1eg+1sD9UP+YcH6n6q/O2JLqudXWpMgbSNmUFcnJFJ2mUpFWOlP6HwsLeyQSNJhWVCy9
 QfoCoPNc
 Yin2yO4/cn7LdhuvRe0y0StutoTHgHvFosCWhKxEwvdYZrqudG2jeoXZXlmDVG3OFuImG6rI3s1MeV/Y+5UnYOb2tHnos44oKbkJH1AMjIpiVEWGsj8oUheA+lnvH3aD7w4JCan4/e95xqSHVY8BXFpWgXDPELEP7CNuJptkxeOa12BFeGfi0UsOnBhxUiFn0pBgvLyz7TCTaLxv8FB+TX/fXtIKNUqP5jnCVproSB8qgkyN9PVTVlk7TU7Hra/NgUiTNhwz+I6wwucd/VZM4xMhYvBjhncUj02DILoW4C5eEKZEH/pSBsfURqseuZYhKxkIZ3I66v0T5/98wfZ0ovKw1pChbLU2BZwJcqCEVOtE6Ip1Uhyfsfuj7bgDCDjfVzgsZalTbKxCAJvTyfnMfkwsTrYsWvV9hJ2JrhGNgHjLwo9q6qZIlWpvjXsRMIBgFbxvBal0tcgn3qUZVrTEDQIoaiYEjA8eRnqARwzYdCD6RpEW+Ml4dhNhpoRVf5zA352HOrkDHHEJxI+TGp54BL9dqVz24Breeb9fKoqe7xX4rXEAKhr70S724m0j49JRIKEJkNKch+oo+uTDPcvVDts/NdPxZ/VnkPRNZOoUxzlNlvf6nhIIRzD6SCFB/o/9/aKSGE/ZCGk64YZ2hAIHEz7JInyRVWozPJkTuyXH1MKReQ6Bdmd+TXyBAdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Create a liveupdate_features section that contains the feature
information for a given liveupdate component. Add the LUO component
first. These can be compared between two kernels to determine live
update compatibility. Features marked as required in the running kernel
will need to have that feature marked as supported in the next kernel to
be eligible for compatibility.

Suggested-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Logan Odell <loganodell@google.com>
---
 include/asm-generic/vmlinux.lds.h | 12 +++++++++++
 include/linux/kho/abi/luo.h       | 34 +++++++++++++++++++++++++++++++
 include/linux/liveupdate.h        | 12 +++++++++++
 kernel/liveupdate/luo_core.c      | 16 +++++++++++++++
 4 files changed, 74 insertions(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 5659f4b5a125..aed4e282a78c 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -359,6 +359,17 @@
 #define THERMAL_TABLE(name)
 #endif
 
+#ifdef CONFIG_LIVEUPDATE
+#define LIVEUPDATE_FEATURES						\
+	. = ALIGN(8);							\
+	.liveupdate_features : AT(ADDR(.liveupdate_features) - LOAD_OFFSET) {	\
+		KEEP(*(.liveupdate_sec_hdr))				\
+		KEEP(*(.liveupdate_features))				\
+	}
+#else
+#define LIVEUPDATE_FEATURES
+#endif
+
 #define KERNEL_DTB()							\
 	STRUCT_ALIGN();							\
 	__dtb_start = .;						\
@@ -554,6 +565,7 @@
 	RO_EXCEPTION_TABLE						\
 	NOTES								\
 	BTF								\
+	LIVEUPDATE_FEATURES						\
 									\
 	. = ALIGN((align));						\
 	__end_rodata = .;
diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index 0a7662a0cf9a..5b25e1b48cf5 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -230,4 +230,38 @@ struct luo_flb_ser {
 #define LIVEUPDATE_TEST_FLB_COMPATIBLE(i)	"liveupdate-test-flb-v" #i
 #endif
 
+#define LIVEUPDATE_VER_HDR_MAGIC	0x4c565550 /* 'LVUP' */
+#define LIVEUPDATE_VER_HDR_VER		1
+
+/**
+ * struct liveupdate_ver_hdr - Header of vmlinux section with version lists
+ * @magic:     Magic number ('LVUP').
+ * @version:   Version of the header format.
+ *
+ * This struct is the header for the vmlinux section ".liveupdate_features". The
+ * section contains the list of feature/version entries that the kernel supports.
+ */
+struct liveupdate_ver_hdr {
+	u32 magic;
+	u32 version;
+} __packed;
+
+/**
+ * struct liveupdate_feature_entry - Live update feature/version entry
+ * @name:       Name of the subsystem or feature ("luo" for core).
+ * @feat_bytes: Number of bytes covered by supp, req, and active bitmaps (e.g. 8).
+ * @reserved:   Reserved / padding for alignment.
+ * @supp:       Bitmask of supported features.
+ * @req:        Bitmask of required features.
+ * @active:     Bitmask of active features.
+ */
+struct liveupdate_feature_entry {
+	char name[LIVEUPDATE_HNDL_COMPAT_LENGTH];
+	u32 feat_bytes;
+	u32 reserved;
+	u64 supp;
+	u64 req;
+	u64 active;
+} __packed;
+
 #endif /* _LINUX_KHO_ABI_LUO_H */
diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 6051abc0612c..e058df23fed1 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -229,6 +229,16 @@ struct liveupdate_flb {
 
 #ifdef CONFIG_LIVEUPDATE
 
+#define LIVEUPDATE_FEATURE_ENTRY(_id, _name, _supp, _req, _active)	\
+	static const struct liveupdate_feature_entry __lu_feat_##_id	\
+	__used __section(".liveupdate_features") __aligned(8) = {	\
+		.name       = _name,					\
+		.feat_bytes = sizeof(u64),				\
+		.supp       = (_supp),					\
+		.req        = (_req),					\
+		.active     = (_active),				\
+	}
+
 /* Return true if live update orchestrator is enabled */
 bool liveupdate_enabled(void);
 
@@ -259,6 +269,8 @@ int liveupdate_get_token_outgoing(struct liveupdate_session *s,
 
 #else /* CONFIG_LIVEUPDATE */
 
+#define LIVEUPDATE_FEATURE_ENTRY(_id, _name, _supp, _req, _active)
+
 static inline bool liveupdate_enabled(void)
 {
 	return false;
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 6add1ecc463f..27413f895174 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -64,6 +64,22 @@
 #include "kexec_handover_internal.h"
 #include "luo_internal.h"
 
+/*
+ * This is the header for the ".liveupdate_features" section in vmlinux.
+ * The linker makes sure that this header precedes the entries.
+ */
+static const struct liveupdate_ver_hdr ver_hdr
+	__used __section(".liveupdate_sec_hdr") __aligned(8) = {
+	.magic   = LIVEUPDATE_VER_HDR_MAGIC,
+	.version = LIVEUPDATE_VER_HDR_VER,
+};
+
+/* Core LUO features */
+LIVEUPDATE_FEATURE_ENTRY(luo_core, "luo",
+			 LUO_CORE_FEATURES_SUPP,
+			 LUO_CORE_FEATURES_REQ,
+			 LUO_CORE_FEATURES_ACTIVE);
+
 static struct {
 	bool enabled;
 	struct luo_ser *luo_ser_out;
-- 
2.55.0.979.g7e5102b832-goog


