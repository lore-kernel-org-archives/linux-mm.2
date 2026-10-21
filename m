Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D980C60A2601
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 15:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=vaBUumMr
Received: by kanga.kvack.org (Postfix)
	id C87176B0726; Wed, 21 Oct 2026 11:25:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5E436B0727; Wed, 21 Oct 2026 11:25:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4C886B0729; Wed, 21 Oct 2026 11:25:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 908696B0726
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:25:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 26E51140459
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:25:37 +0000 (UTC)
X-FDA: 85347007914.17.512A7E9
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	by imf26.hostedemail.com (Postfix) with ESMTP id 61FF0140004
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:25:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vaBUumMr;
	spf=pass (imf26.hostedemail.com: domain of 3bdnYagkKCOAVCTWPUCJWIQQING.EQONKPWZ-OOMXCEM.QTI@flex--tarunsahu.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3bdnYagkKCOAVCTWPUCJWIQQING.EQONKPWZ-OOMXCEM.QTI@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792596335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yVHoNG/F+MSh1AvSZ4DFO2pLKQWPL8PGoHBteE3nowI=;
	b=nHSqDpclxAMLaMzazvhW/a8fQiIbsjWuMsn1WiCywSYEzFegbenaaD665LSdv1iY2Q0mkQ
	Z8+z+8fVnqyFd1BZL3PorSncp5+7+Uyosmo1AZPmZTHYQblN/02y60VKlf0R/LgluJOaAV
	L2/K7zMgfFFNIi9QKTkbplrPEl4CmVQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vaBUumMr;
	spf=pass (imf26.hostedemail.com: domain of 3bdnYagkKCOAVCTWPUCJWIQQING.EQONKPWZ-OOMXCEM.QTI@flex--tarunsahu.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3bdnYagkKCOAVCTWPUCJWIQQING.EQONKPWZ-OOMXCEM.QTI@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792596335;
	b=s+/5dRbbTC8fdS08WV3zPulIihLS+W7LL2yAUFbZJYItJ/5VWj+ASsJNi4Cx3Y5YK1q/qR
	6BBgbbgIWZNfsnNcObtd5Zdg8mA5xICShdMtyI1jp7s2F+5Pk6zsO1TYMSblVUfQsQYREc
	yAv56uRHSSDBoDI45gWd7j/5+LhxO+k=
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c29c391bd2fso76673366b.2
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792596334; x=1793201134; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yVHoNG/F+MSh1AvSZ4DFO2pLKQWPL8PGoHBteE3nowI=;
        b=vaBUumMr0VcuKxwnGEzvcxHYX1vnqF93ELtWhwiuD4BtfBLY/tLJDND2ZeffNWZJQa
         Kfzlgtd6pND+c1do6L8Bfn6UCb19WyCGVRdSHyAt5owUZFxeUY1AZq3tDNwNNI4kVV5n
         RBhXxJb/hdgHbL1AZYmVSQOzoGbaOR9h8INxkkggKis+faqBlm12dAz7FdRJWIijFzTT
         WPzvpVgiyY8x0TQTFYPfCCJtkJpxjWBc2NHvHTc3moNVLFFZsa3Yi0Qje/mO5sfqdVqQ
         Nb6oHlfIDrgUlV53u9nnHnQpz8XmugAdR1D6EtWScrNqXqhUtne9JEY/x3reLGXb2+rE
         p7Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792596334; x=1793201134;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yVHoNG/F+MSh1AvSZ4DFO2pLKQWPL8PGoHBteE3nowI=;
        b=pNnAa1pjZv4jEY3j1LZsUXCWw2tOWgusK5ZMjbQM1nceD/aBsLO6JWIQRjRi1+AYcm
         /94FuBW8TlSqWBIwaqg8LMYV8KDk6+rf3Em5TqjlAeo5nk5QEFxnLWSMEffHLXZHv/9D
         xs5L8wr3NjgXEFASU9e+7fUbKSqDw9QOLTyaR3U9gckrgy9Nh4sdx5JhjBOJk2PRVcLR
         PvTDXCqIsAEGnVHWMzuMPiAhYorA5X5JmzkogY2ZTVYN5/jnwGXtweAs86ynL+jWvBez
         UKo4+BlB7ZG5Y05rcr+mc9Pollfk0PxEnRx36eR40LFruQQ4QHZym0IptJle1bcQCpas
         rxPQ==
X-Forwarded-Encrypted: i=1; AKwUvBzJjjQ3qRXoSEh7w8IEyS8H5CtCTD7BfKxeiPWrMMvluBXVA51kQRScu9hRaKIfXPAbi05VurZAbw==@kvack.org
X-Gm-Message-State: AFq9FYJ6AUT3dxXIH8AG1LJGsxkZlQ8KM+9dyT01sWpuDNxOuBr9yNlx
	RheH3dRLB6e+p2SpORN1LBuExZFjnroKq8U1GHBIfujGrwyujT0tS1we6aM21QW+Td7ZX+94RWz
	IZIDnzTfMvTLcK5cO7A==
X-Received: from ejeck13-n2.prod.google.com ([2002:a17:907:e1cd:20b0:c2e:8317:2af9])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:c64b:10b0:c46:7fa4:922b with SMTP id a640c23a62f3a-c467fa4a587mr117629166b.33.1792596333890;
 Wed, 21 Oct 2026 08:25:33 -0700 (PDT)
Date: Wed, 21 Oct 2026 15:25:27 +0000
In-Reply-To: <20261021152527.375070-1-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261021152527.375070-5-tarunsahu@google.com>
Subject: [RFC PATCH v2 4/4] mm: memfd_luo: Add the 2-bit pair feature header
From: Tarun Sahu <tarunsahu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	David Matlack <dmatlack@google.com>, jgg@nvidia.com, robin.murphy@arm.com, 
	loganodell@google.com, oupton@kernel.org, kevin.tian@intel.com, 
	alex@shazbot.org, dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, 
	will@kernel.org, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com
Cc: linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 61FF0140004
X-Stat-Signature: 84hgansi7ohnydh5y9fcc3e3hfx1i951
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792596335-221793
X-HE-Meta: U2FsdGVkX1/pGOYR6/dmKWY+o01cN1XvcHv0pYq9Syp1dMHg+PcSqfgqP9LgHBJuRDVDIs0UW7y5IyqSbc8teqgD2HO9f6uV/3QdfyN1bkP9QM3+QgaFHEzkXPe29ID94H+Kl0Is1B3FUIC1vZVcjFWYX9zBix3H20QC1ykM2NnX2II82W5fsoVfEmOXoKRjCXfwqVuYKkmBBm5hY/SKw/eyH7+zFqRkiqVRQbn9XT+HvGsds6n3DUkkCuEMe1SG+3t98bqNOSsXZGYOs9HreQweBB7pBILTM2SHHdqGmpWCtgr/wcyvCu0DGKur1cf20ZNPds142ZwNCZexn0WP3ArAwrd7Gl5mi2FNbkOtWOrBHn0f4Ql4YfL4ndTHJG9AHXW/N8NyEi8aFky9ZMJoOHBRUvG5a22mVgMdw71z0GfcqqsvXoXK7qNf6NpMC+BHKGQ9XP/0MaXiJMJ/XH6TKbsWkRvMMTrhBHgfxTaKcoaL/B2LGBHLE60URK68Cn+OkdYxLt69cUr96bKRwXfOC80+ufNKnh4SnCnk66KaAM3YeplXvUOuGZLS9018/G2I0m2AyIf3h0Md9Z1lB8cNyUDVi8uuOopWbxGJ2Y3uomO4kv1YKyuvkfbeE/JMvkWstJvyj9Quh9twS4Dgl0kOHYBffI9dUjoQHMfJg26bwd8Y6b2dXwsqnf2aCga/oGUXDadQv4Ky7viWQLK/BXt1uusAhTHykDo/7orL7nfDYD4KSqxshoPJ0lqprQ1EvfyXx4fEAMvGK9YU/UYUZI8C0pmF1ZO8TfGC+ASFwSEsLo1HC7Eo155jgqA+k1Aq3YzBppXl/t029qh/wfzhuJxqvx4vRyZHeKH1Hlz+V2Sp24qQCkDXjQjuVctPKsO5EhrnTqQ50YhEkP6kOzADzeZulYxOxZ1zXMbl2G0ippGCADis2ldZ36hvKZl+kI9O3brg/m5KjRwcCkPexSjB4P+
 yRsLAppK
 gJWOfCF1tP9akhEDO45ScDMFUwRnT5Fv1KkbzK/MQiCcc1b0vBy2Y368Bu5vb7P+ZWj0hEsfz56+DeeOsk0hDXqK6CUvxC0w/wuWEAbeyT9j1u5EU/CtM+Dw35jmGYywq5R5oJaq30VpTkjCUf6YkxUiIhdc0qoyYzVH9RLNnqiXxWsyyAPvXvq3CjLnv/FXKNqX+kuvp6ppV9MiuxgiecyhW1486aNU0GsdnyUHcVeoCo74U3Px3KN53H7w7ApGLKdcPvaMQvhmH4vWYXcTQhfJa/g51Ko5i6rAJ9UyZrenq3hJTMhO/c+sf95ZHcUoSBXlMJScatxl2REQPeqJyjGKzJhO32Jofe3tvzolsLA1rCq97WHEmVNfhDT0fWyqrDhXgsoLVNZlo34Bkgs1LLRQLE8xSWr5hqCXYPyekzgL3HolWbnH1c3prwd4AXy6jRtN/hjkiQ2emv1zLsitLipndVY3+h3B2r8P9nr5hgs/6V1Q2tn4Jfx3FYT6idUFRhgFSMWqoGg7wGRg7wNdCYqQjIHKsmbZGTZUyRZ1s1A1sl2mbLb17E81Wbpx1yYnkAWGbOZAx2X98HHpA1Cik+kShB+NlLwp/dzDUCRuPwRm1yCa89cDJ1vwzxNhvXVRlsII7aZ5lLDmERnDHPwbm0YhKEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Embed the fixed-size 128-byte struct luo_feature_hdr at the start of
struct memfd_luo_ser and define enum memfd_luo_feature
(MEMFD_LUO_FEAT_CORE and MEMFD_LUO_FEAT_MAX) for memfd preservation.

All current struct memfd_luo_ser fields (pos, size, seals, flags,
nr_folios, folios) and MEMFD_LUO_ALL_SEALS belong to
MEMFD_LUO_FEAT_CORE (LUO_FEAT_REQUIRED in memfd_luo_features). Future
changes add new entries to enum memfd_luo_feature before
MEMFD_LUO_FEAT_MAX and append any new fields to the end of struct
memfd_luo_ser so existing field offsets never shift.

Signed-off-by: Logan Odell <loganodell@google.com>
Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/memfd.h | 35 ++++++++++++++++++++++++++++++-----
 mm/memfd_luo.c                | 14 ++++++++++++++
 2 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
index 371ffd108a79..f0b5235a408d 100644
--- a/include/linux/kho/abi/memfd.h
+++ b/include/linux/kho/abi/memfd.h
@@ -13,6 +13,7 @@
 
 #include <linux/types.h>
 #include <linux/kho/abi/kexec_handover.h>
+#include <linux/kho/abi/luo.h>
 
 /**
  * DOC: memfd Live Update ABI
@@ -21,11 +22,20 @@
  * reboot using the LUO.
  *
  * The state is serialized into a packed structure `struct memfd_luo_ser`
- * which is handed over to the next kernel via the KHO mechanism.
+ * which is handed over to the target kernel via the KHO mechanism.
  *
- * This interface is a contract. Any modification to the structure layout
- * constitutes a breaking change. Such changes require incrementing the
- * version number in the MEMFD_LUO_FH_COMPATIBLE string.
+ * This interface is a contract. `struct memfd_luo_ser` starts with a fixed
+ * 128-byte `struct luo_feature_hdr`. The relative order and offsets of
+ * fields must remain unchanged as features are added or retired: new fields
+ * are appended at the end of `struct memfd_luo_ser` under a new feature
+ * flag in `enum memfd_luo_feature` (before `MEMFD_LUO_FEAT_MAX`), and
+ * retired fields are kept in place so subsequent offsets never shift. In
+ * the target kernel, fields of a `LUO_FEAT_REQUIRED` feature are guaranteed
+ * present once `luo_feature_hdr_validate()` succeeds, whereas fields of a
+ * `LUO_FEAT_OPTIONAL` feature should be accessed only after checking
+ * `luo_feature_is_active()`. All current fields (`pos`, `size`, `seals`,
+ * `flags`, `nr_folios`, `folios`) and `MEMFD_LUO_ALL_SEALS` belong to
+ * `MEMFD_LUO_FEAT_CORE` (`LUO_FEAT_REQUIRED` in `memfd_luo_features`).
  */
 
 /**
@@ -58,7 +68,7 @@ struct memfd_luo_folio_ser {
 
 /*
  * The set of seals this version supports preserving. If support for any new
- * seals is needed, add it here and bump version.
+ * seals is needed, gate them behind a new feature flag.
  */
 #define MEMFD_LUO_ALL_SEALS (F_SEAL_SEAL | \
 			     F_SEAL_SHRINK | \
@@ -67,8 +77,22 @@ struct memfd_luo_folio_ser {
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
+static_assert((int)MEMFD_LUO_FEAT_MAX <= LUO_FEAT_MAX);
+
 /**
  * struct memfd_luo_ser - Main serialization structure for a memfd.
+ * @features:  ABI feature and size header for memfd_luo_ser.
  * @pos:       The file's current position (f_pos).
  * @size:      The total size of the file in bytes (i_size).
  * @seals:     The seals present on the memfd. The seals are uABI so it is safe
@@ -79,6 +103,7 @@ struct memfd_luo_folio_ser {
  *             struct memfd_luo_folio_ser.
  */
 struct memfd_luo_ser {
+	struct luo_feature_hdr features;
 	u64 pos;
 	u64 size;
 	u32 seals;
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 64f8b8cb75bd..ea1f4c8cd259 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -84,6 +84,10 @@
 
 #include "internal.h"
 
+static const u8 memfd_luo_features[MEMFD_LUO_FEAT_MAX] = {
+	[MEMFD_LUO_FEAT_CORE] = LUO_FEAT_REQUIRED,
+};
+
 static int memfd_luo_preserve_folios(struct file *file,
 				     struct kho_vmalloc *kho_vmalloc,
 				     struct memfd_luo_folio_ser **out_folios_ser,
@@ -284,6 +288,8 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 		goto err_free_ser;
 	}
 
+	luo_feature_hdr_init(&ser->features, sizeof(*ser),
+			     memfd_luo_features);
 	ser->pos = args->file->f_pos;
 	inode_size = i_size_read(inode);
 
@@ -525,6 +531,14 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	if (!ser)
 		return -EINVAL;
 
+	err = luo_feature_hdr_validate(&ser->features, memfd_luo_features);
+	if (err) {
+		pr_err("memfd_luo_ser feature header validation failed (size=%llu, flags[0]=%#llx): %pe\n",
+		       ser->features.size, ser->features.flags[0],
+		       ERR_PTR(err));
+		goto free_ser;
+	}
+
 	/* Make sure the file only has seals supported by this version. */
 	if (ser->seals & ~MEMFD_LUO_ALL_SEALS) {
 		err = -EOPNOTSUPP;
-- 
2.56.0.212.g129ede20d9-goog


