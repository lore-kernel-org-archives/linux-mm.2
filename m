Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B2B8606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 17:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=MnHjnuMr
Received: by kanga.kvack.org (Postfix)
	id C8AB26B05BB; Mon, 26 Oct 2026 13:42:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9D146B05BC; Mon, 26 Oct 2026 13:42:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3E766B05BD; Mon, 26 Oct 2026 13:42:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6FA3B6B05BA
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:42:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0492816082B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:42:27 +0000 (UTC)
X-FDA: 85365496776.07.7A94FA4
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	by imf25.hostedemail.com (Postfix) with ESMTP id 405E2A0003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:42:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MnHjnuMr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3_pDfagkKCPswduxqvdkxjrrjoh.frpolqx0-ppnydfn.ruj@flex--tarunsahu.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=3_pDfagkKCPswduxqvdkxjrrjoh.frpolqx0-ppnydfn.ruj@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793036546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YNhavcwMmnkc/7Ctxrs7vPIYiccZaS2q3CINRB+03cg=;
	b=ehyBavbmLY82kaxjDzYOOw9qRpV6jSNxT7PD5SLjaniJFPfDx0rneNbr/g1IQ6OD/tKjHD
	CsTsIp0VjnNUr8hknfXj/Q+DCUgY6xtm/VuqMvKhqmA6KeDN5uCy7S3T6qMDj7yVm2vANt
	FF47H00UbHvdncdGCWyw3Ti/JTZAZQs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=MnHjnuMr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3_pDfagkKCPswduxqvdkxjrrjoh.frpolqx0-ppnydfn.ruj@flex--tarunsahu.bounces.google.com designates 209.85.208.71 as permitted sender) smtp.mailfrom=3_pDfagkKCPswduxqvdkxjrrjoh.frpolqx0-ppnydfn.ruj@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793036546;
	b=XyX5glQcF1B+HgbaTtj6Q7DgosPTFp0IWn979uw1/nd0FbT58WGo9u4FQufShFI0s0OQE0
	t3FhU25i5VSMyCfIFwb8Ng6LsThqZ3kAWBSorFbmm8MmIY11YqAv+0LQLRcPRvCcbnxVNS
	9ck+TJO55stF+bvIVQOgrO3BthLDNRU=
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6b20352f43eso142841a12.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793036545; x=1793641345; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YNhavcwMmnkc/7Ctxrs7vPIYiccZaS2q3CINRB+03cg=;
        b=MnHjnuMrzy/3AP8TFBtcZAX/D7clGfZF6WJ2MTDo1/NgZ0wvvkCFVMV4e3Hj/VpUnI
         1aPocwbTzeI5NKRDWQkxrgPhDAFqr4prabGvWSq6tfkveXoJHqmlqNO5YY/FVGxXgCZk
         Xj/+GR5YCbHygIGRAfQ15ToznGAIRAwWuLISUHeIh9YNta+UXquk11LRO8DNASJNO/N8
         xS5pKtrCOFt7EceiMQ6JPRSn3hSqlXWOQFroB3nO/X3qi7BOLSi7RMsSxNLFb5TFwOQ2
         0WiZ4Brcf3XD9wZ/QUFI89BYZDsE+l+HsnIemAwXgCqXNoXLgASBpP0VlnFNXJp4PRDF
         jBjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793036545; x=1793641345;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YNhavcwMmnkc/7Ctxrs7vPIYiccZaS2q3CINRB+03cg=;
        b=ygRfgi1LC4PANWZOZLmllJGP8lq97CUBGKYbDIpcv6rFoE1+Vj30LJm57/BU6e3zUM
         Zqmtiti1EKJ+7xQqTqknYOLzK+fq9mCguw6zzcZhpD0z709Pj8kbrIqJeVEQGCIkLxr3
         V8uXyikocQGl3PZ4YsXR7gDyCKhoJ2vNU0f3IccKghuCKdNWOrtmFH2hF5SlD3+zM1ax
         oK2hSOFntWQg8eAM5lLtC/OyDHUPJfVn5ct1I0YTcqJa4SWEg0yGIUyk+9spTryZCzOf
         7RfqOHk3EmAHBhK6yqmpuSLXXCTUuWVHop1mKkcmUj+/qjzfD9k8Z4xzE1Z7i93sRiMV
         6+wA==
X-Forwarded-Encrypted: i=1; AKwUvBz3IOTEdMkm0Uwc7dy0S+9AX1hv0mcSXutop3iUmBxfLsAaHdZ1k7y1nTSACBrT+o+YYlbOSSE8ew==@kvack.org
X-Gm-Message-State: AFq9FYKpHgI6oqN9rlX+fosKT1czyEQprbzBi1AgMae4zrqu7vo//kmA
	A2g6FV3US6vKrJbt7RWdYoYkNwCwhxaTg++33RSy1aQsyEOiulQl6+o6glu7oGEvWTdi1fe4o0A
	gtzZbVflWZkd56PFIMw==
X-Received: from ejyz9.prod.google.com ([2002:a17:906:d009:b0:c31:667b:ebec])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:7fa7:b0:c2d:c6e7:9e9a with SMTP id a640c23a62f3a-c49a72250d3mr35398966b.11.1793036542749;
 Mon, 26 Oct 2026 10:42:22 -0700 (PDT)
Date: Mon, 26 Oct 2026 17:42:16 +0000
In-Reply-To: <20261026174217.603114-1-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261026174217.603114-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261026174217.603114-4-tarunsahu@google.com>
Subject: [RFC PATCH v3 3/4] mm: memfd_luo: Add the feature header
From: Tarun Sahu <tarunsahu@google.com>
To: loganodell@google.com, alex@shazbot.org, dwmw2@infradead.org, 
	seanjc@google.com, Mike Rapoport <rppt@kernel.org>, will@kernel.org, pbonzini@redhat.com, 
	jgg@nvidia.com, Pasha Tatashin <pasha.tatashin@soleen.com>, arnd@arndb.de, 
	linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, oupton@kernel.org, 
	baolu.lu@linux.intel.com, David Matlack <dmatlack@google.com>, robin.murphy@arm.com, 
	maz@kernel.org, Alexander Graf <graf@amazon.com>, joro@8bytes.org, 
	Bjorn Helgaas <bhelgaas@google.com>, kevin.tian@intel.com, 
	Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 405E2A0003
X-Stat-Signature: b4tjamzfguxp3i8m386qhwmhts5c933m
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793036546-269092
X-HE-Meta: U2FsdGVkX1++Qg9zRMnclFAic6gxinjUR40iqX407/BgRI7Eb9BE85V+QiN7q4nBMO6j8jy19nHduGvLUz/26FUPcHYZ1eJTf9rxs9Y1efHNEUWSFuEHnKWKJv9rkFh7xS02ilWwfOeXqCO3OGCU+Q6gxG6so/uIKyylJztlmCQOLW80lIBKXqlx9XT4a7dQBh922cdiHKG+67RvRd41q3v26uRKN5XxwY5/a5QHlp+4CJ2Ee7XoZx9Cv9XQYTXnGimvCJlv6Msq0rHC/OgbFn/3zi8nTcpxamXwlTnKxdkZHajGfAKoJbbNm41UYnGSPY1N0iV3YzyUXneC5U+1lF5wlW3+JLjdjqw8u2bRqoGnF1ZF5Xmhre1/24EDCeDz1KALW594/KN19sJ6Ji6zGJlq8XpvZLfn5/R5cudjiXfxZhNaRVItbbGNarUoyPrlIJDRWieey2RlFZ6y+AIe2uyEBPqReQU+rUjQ46xTOvOtXjvePlGE+/J2L1WcY0e6uEBDPRbsFiA9kp3RRGfbGr6w8ZeyX2xrb34ThkvpSG1WXHFg+iJaFosACeXvC4hzRGGmMc/N4Co630IZ2S0Vw7ZdtRbRFCSAnA5dFiwVsU+7P95EieZny/Oqu+Bb1/gNU4GQsXhs0a1LeCdAR6bYJ8bdvpedfbscRgRvHsRiT7mcCIjUgIb6+x1Z/89hNUnQYs1huYu+4C1LIYznexwBK2DhTuc0W6aIh0QM+3OMaE2PogJjhuYDAQr6AV4/qOjAFqajYUfxCFGqaYoCzlh7Pd08NrBhCBzWe+gqJscSCyZFkUI1znd2B3iC/CLXVBkBjEORz3CL9bSYqQMkkJgkFi8abRPRBbtwZPguMUaEjQSbe8GZFar6IXSWHJFUXMy5qAO7TirM+O6WsAtZtc62nkl9PDsNGYFSFrmbdfKB9W3h7Ia2fyVWQpCs4/1ffyfQafqUIHFOC5Z2/8CTgrr
 JTzR3Tt8
 dO1sQY8h4lwnSLesIOMgZcupoJ2OwebG7XLj99ULdJYO/fsMEEPWlDgz+PRdPNVKAUEncMBm9LLKFz9u3HBn/r4x9GnLdJ3AGm8xJgpwIgNMfjs5EV0UG1EoOCdEKvQj+j+Mzx13TWCgk/nFXSyIgJm+HFVLs9ye3Mqt2YBaZSvJJk0wgOB62nfAfYNN56V+bwNZNSLANhWaZRFx3JDaYCJhZS6fGT8eg8ccA5zTy3NCNJkKo5geL7sBc5tcyNRUuuiBq0mPrEznm4+v8QhQFes+XHWeqxixI3AA7uwgTBdfjr3vimSpAJZNwTucLLtXidpYAr0K8eKlkIHKFT0FguCq+n7AHQdgTALJcvaA3KYChiNY3aAMENQNq6KYaxlvUzwZ1FkKOkwd3OeRkSupd6ZijwHt3hlBGxU2QccDGqVH1gSedlGuYF4qTSrnmH9xarpG/rIP5wSk8gY7X5ETE8vIaYfK1n+f1ExaKHo1RP1IDm7kJ3wYx3/nn5uZBhRpyAYc2E5cnfpQ7xqSzLzAz7Y+KLmj1/25WnWnA1Qr83NLWCOgXK+01Oc91aOWEeyyK8QGpv7uwKq06p4tryBcTzWUV3ulsKv9QY5ByOr1BMIRYYONHqo4ms0mggYkS9u7u0jOIUqgcAwHE+MphVZC/xjHZvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Precede struct memfd_luo_ser with the 8-byte struct luo_ser_hdr for
memfd preservation. The source kernel writes the state through struct
memfd_luo_ser_wrap, declared with DECLARE_LUO_SER_WRAP():

  DECLARE_LUO_SER_WRAP(memfd_luo_ser, 64, MEMFD_LUO_FEAT_MAX);

This consists of hdr + memfd_luo_ser (payload).

The existing struct memfd_luo_ser fields (pos, size, seals, flags,
nr_folios, folios, and MEMFD_LUO_ALL_SEALS) form MEMFD_LUO_FEAT_CORE
(index 0 of enum memfd_luo_feature). The source kernel marks it as
LUO_FEAT_REQUIRED when preserving state, and the target kernel marks it
as supported (true) in its memfd_luo_supported_feats table passed to
luo_ser_hdr_validate(). Future changes append any new fields to the end
of struct memfd_luo_ser under a new feature index so existing field
offsets never shift.

memfd_luo_retrieve() and memfd_luo_finish() validate the incoming header
against memfd_luo_supported_feats with luo_ser_hdr_validate() before
accessing any payload field; finish warns and skips discarding the folios
when the header is invalid.

Prepending the header shifts every field of the serialized memfd state,
so bump MEMFD_LUO_FH_COMPATIBLE from memfd-v2 to memfd-v3.

Signed-off-by: Logan Odell <loganodell@google.com>
Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/memfd.h | 32 +++++++++++++++--
 mm/memfd_luo.c                | 68 ++++++++++++++++++++++++-----------
 2 files changed, 77 insertions(+), 23 deletions(-)

diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
index 7115a8a77cfd..d467d18fe6e8 100644
--- a/include/linux/kho/abi/memfd.h
+++ b/include/linux/kho/abi/memfd.h
@@ -14,6 +14,7 @@
 #include <linux/build_bug.h>
 #include <linux/types.h>
 #include <linux/kho/abi/kexec_handover.h>
+#include <linux/kho/abi/luo.h>
 
 /**
  * DOC: memfd Live Update ABI
@@ -22,9 +23,18 @@
  * reboot using the LUO.
  *
  * The state is serialized into `struct memfd_luo_ser`
- * which is handed over to the next kernel via the KHO mechanism.
+ * which is handed over to the target kernel via the KHO mechanism.
  *
- * This interface is a contract. Any modification to the structure layout
+ * This interface is a contract. The serialized state starts with an
+ * 8-byte `struct luo_ser_hdr` followed by `struct memfd_luo_ser`.
+ * The relative order and offsets of fields must remain unchanged as
+ * features are added or retired: new fields are appended at the end of
+ * `struct memfd_luo_ser` under a new feature flag, and retired fields are
+ * kept in place so subsequent offsets never shift. In the target kernel,
+ * the fields of a feature are read only after `luo_ser_get_feat()` shows
+ * the feature present.
+ *
+ * Any modification to the structure layout beyond feature extensions
  * constitutes a breaking change. Such changes require incrementing the
  * version number in the MEMFD_LUO_FH_COMPATIBLE string.
  */
@@ -70,6 +80,17 @@ static_assert(sizeof(struct memfd_luo_folio_ser) == 16);
 			     F_SEAL_FUTURE_WRITE | \
 			     F_SEAL_EXEC)
 
+/**
+ * enum memfd_luo_feature - Feature indices for &struct memfd_luo_ser.
+ * @MEMFD_LUO_FEAT_CORE: Core feature covering `pos`, `size`, `seals`, `flags`,
+ *                       `nr_folios`, `folios`, and %MEMFD_LUO_ALL_SEALS.
+ * @MEMFD_LUO_FEAT_MAX:  Number of defined &enum memfd_luo_feature features.
+ */
+enum memfd_luo_feature {
+	MEMFD_LUO_FEAT_CORE = 0,
+	MEMFD_LUO_FEAT_MAX,
+};
+
 /**
  * struct memfd_luo_ser - Main serialization structure for a memfd.
  * @pos:       The file's current position (f_pos).
@@ -80,6 +101,8 @@ static_assert(sizeof(struct memfd_luo_folio_ser) == 16);
  * @nr_folios: Number of folios in the folios array.
  * @folios:    KHO vmalloc descriptor pointing to the array of
  *             struct memfd_luo_folio_ser.
+ *
+ * Preceded by &struct luo_ser_hdr.
  */
 struct memfd_luo_ser {
 	u64 pos;
@@ -92,7 +115,10 @@ struct memfd_luo_ser {
 
 static_assert(sizeof(struct memfd_luo_ser) == 48);
 
+/* memfd state written by this kernel. Never cast incoming state to it. */
+DECLARE_LUO_SER_WRAP(memfd_luo_ser, 64, MEMFD_LUO_FEAT_MAX);
+
 /* The compatibility string for memfd file handler */
-#define MEMFD_LUO_FH_COMPATIBLE	"memfd-v2"
+#define MEMFD_LUO_FH_COMPATIBLE	"memfd-v3"
 
 #endif /* _LINUX_KHO_ABI_MEMFD_H */
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 6b68220275eb..85424a5fbc20 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -84,6 +84,10 @@
 
 #include "internal.h"
 
+static const bool memfd_luo_supported_feats[MEMFD_LUO_FEAT_MAX] = {
+	[MEMFD_LUO_FEAT_CORE] = true,
+};
+
 static int memfd_luo_preserve_folios(struct file *file,
 				     struct kho_vmalloc *kho_vmalloc,
 				     struct memfd_luo_folio_ser **out_folios_ser,
@@ -258,6 +262,7 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 {
 	struct inode *inode = file_inode(args->file);
 	struct memfd_luo_folio_ser *folios_ser;
+	struct memfd_luo_ser_wrap *wrap;
 	struct memfd_luo_ser *ser;
 	u64 nr_folios, inode_size;
 	int err = 0, seals;
@@ -266,9 +271,9 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 	shmem_freeze(inode, true);
 
 	/* Allocate the main serialization structure in preserved memory */
-	ser = kho_alloc_preserve(sizeof(*ser));
-	if (IS_ERR(ser)) {
-		err = PTR_ERR(ser);
+	wrap = kho_alloc_preserve(sizeof(*wrap));
+	if (IS_ERR(wrap)) {
+		err = PTR_ERR(wrap);
 		goto err_unlock;
 	}
 
@@ -284,6 +289,10 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 		goto err_free_ser;
 	}
 
+	memfd_luo_ser_wrap_init(wrap);
+	luo_ser_set_feat(&wrap->hdr, MEMFD_LUO_FEAT_CORE, LUO_FEAT_REQUIRED);
+
+	ser = &wrap->ser;
 	ser->pos = args->file->f_pos;
 	inode_size = i_size_read(inode);
 
@@ -308,12 +317,12 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 	inode_unlock(inode);
 
 	args->private_data = folios_ser;
-	args->serialized_data = virt_to_phys(ser);
+	args->serialized_data = virt_to_phys(wrap);
 
 	return 0;
 
 err_free_ser:
-	kho_unpreserve_free(ser);
+	kho_unpreserve_free(wrap);
 err_unlock:
 	shmem_freeze(inode, false);
 	inode_unlock(inode);
@@ -322,18 +331,18 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 
 static int memfd_luo_freeze(struct liveupdate_file_op_args *args)
 {
-	struct memfd_luo_ser *ser;
+	struct memfd_luo_ser_wrap *wrap;
 
 	if (WARN_ON_ONCE(!args->serialized_data))
 		return -EINVAL;
 
-	ser = phys_to_virt(args->serialized_data);
+	wrap = phys_to_virt(args->serialized_data);
 
 	/*
 	 * The pos might have changed since prepare. Everything else stays the
 	 * same.
 	 */
-	ser->pos = args->file->f_pos;
+	wrap->ser.pos = args->file->f_pos;
 
 	return 0;
 }
@@ -341,7 +350,7 @@ static int memfd_luo_freeze(struct liveupdate_file_op_args *args)
 static void memfd_luo_unpreserve(struct liveupdate_file_op_args *args)
 {
 	struct inode *inode = file_inode(args->file);
-	struct memfd_luo_ser *ser;
+	struct memfd_luo_ser_wrap *wrap;
 
 	if (WARN_ON_ONCE(!args->serialized_data))
 		return;
@@ -349,12 +358,12 @@ static void memfd_luo_unpreserve(struct liveupdate_file_op_args *args)
 	inode_lock(inode);
 	shmem_freeze(inode, false);
 
-	ser = phys_to_virt(args->serialized_data);
+	wrap = phys_to_virt(args->serialized_data);
 
-	memfd_luo_unpreserve_folios(&ser->folios, args->private_data,
-				    ser->nr_folios);
+	memfd_luo_unpreserve_folios(&wrap->ser.folios, args->private_data,
+				    wrap->ser.nr_folios);
 
-	kho_unpreserve_free(ser);
+	kho_unpreserve_free(wrap);
 	inode_unlock(inode);
 }
 
@@ -385,6 +394,7 @@ static void memfd_luo_discard_folios(const struct memfd_luo_folio_ser *folios_se
 
 static void memfd_luo_finish(struct liveupdate_file_op_args *args)
 {
+	struct luo_ser_hdr *hdr;
 	struct memfd_luo_folio_ser *folios_ser;
 	struct memfd_luo_ser *ser;
 
@@ -396,10 +406,17 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
 	if (args->retrieve_status)
 		return;
 
-	ser = phys_to_virt(args->serialized_data);
-	if (!ser)
+	if (WARN_ON_ONCE(!args->serialized_data))
 		return;
 
+	hdr = phys_to_virt(args->serialized_data);
+	if (luo_ser_hdr_validate(hdr, memfd_luo_supported_feats,
+				 ARRAY_SIZE(memfd_luo_supported_feats))) {
+		pr_warn("invalid feature header, folios not discarded\n");
+		goto out;
+	}
+
+	ser = luo_ser_payload(hdr);
 	if (ser->nr_folios) {
 		folios_ser = kho_restore_vmalloc(&ser->folios);
 		if (!folios_ser)
@@ -410,7 +427,7 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
 	}
 
 out:
-	kho_restore_free(ser);
+	kho_restore_free(hdr);
 }
 
 static int memfd_luo_retrieve_folios(struct file *file,
@@ -516,15 +533,26 @@ static int memfd_luo_retrieve_folios(struct file *file,
 
 static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 {
+	struct luo_ser_hdr *hdr;
 	struct memfd_luo_folio_ser *folios_ser;
 	struct memfd_luo_ser *ser;
 	struct file *file;
 	int err;
 
-	ser = phys_to_virt(args->serialized_data);
-	if (!ser)
+	if (WARN_ON_ONCE(!args->serialized_data))
 		return -EINVAL;
 
+	hdr = phys_to_virt(args->serialized_data);
+	err = luo_ser_hdr_validate(hdr, memfd_luo_supported_feats,
+				   ARRAY_SIZE(memfd_luo_supported_feats));
+	if (err) {
+		pr_err("memfd_luo_ser feature header validation failed (size=%u, nr_features=%u): %pe\n",
+		       hdr->size, hdr->nr_features, ERR_PTR(err));
+		goto free_ser;
+	}
+
+	ser = luo_ser_payload(hdr);
+
 	/* Make sure the file only has seals supported by this version. */
 	if (ser->seals & ~MEMFD_LUO_ALL_SEALS) {
 		err = -EOPNOTSUPP;
@@ -565,14 +593,14 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	}
 
 	args->file = file;
-	kho_restore_free(ser);
+	kho_restore_free(hdr);
 
 	return 0;
 
 put_file:
 	fput(file);
 free_ser:
-	kho_restore_free(ser);
+	kho_restore_free(hdr);
 	return err;
 }
 
-- 
2.56.0.307.g5fe7bd680c-goog


