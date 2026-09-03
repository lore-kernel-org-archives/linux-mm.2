Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B966C624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 02:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DE756B00F8; Wed,  2 Sep 2026 22:35:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B6F76B00FA; Wed,  2 Sep 2026 22:35:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F360D6B00FB; Wed,  2 Sep 2026 22:35:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8D8756B00F8
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 22:35:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DE0D3C038E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:34:59 +0000 (UTC)
X-FDA: 85170883518.24.0867D30
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2B24420009
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:34:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=COot912A;
	spf=pass (imf03.hostedemail.com: domain of 30NyYagoKCEkwzrlyzopwwrzzrwp.nzxwty58-xxv6lnv.z2r@flex--loganodell.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=30NyYagoKCEkwzrlyzopwwrzzrwp.nzxwty58-xxv6lnv.z2r@flex--loganodell.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788402898;
	b=XpVIdkBlc31Jyc8U/GLWNeWnzgHM3qBPOpCWPqJ/7xXMyw1sBIBIxAVy9t6GQG7AE6NLYa
	u4mxIHMNnVAwZPTtbjg8WxS1IIAf/hsYBqFguhlcJ8znrQJlg95KO6+wEeLYqbTxO9wxPD
	1HVDQgbvm5L3nlOuouaBY+TbXZ5vtX4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=COot912A;
	spf=pass (imf03.hostedemail.com: domain of 30NyYagoKCEkwzrlyzopwwrzzrwp.nzxwty58-xxv6lnv.z2r@flex--loganodell.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=30NyYagoKCEkwzrlyzopwwrzzrwp.nzxwty58-xxv6lnv.z2r@flex--loganodell.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788402898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NXIsSz+mo8g74Vp8Vf3mNp3/WCeSzCYf+BKqQ2Sb8NU=;
	b=fSiWCpr1h/cOzDUMvFvbmhOmUonMcXx4n7biu2EuzVsUn0lbHDrZ9t/RO6Ezi+Cmv9qOoG
	EhrsbjpZ8CoVDiV2vh/L0hhCavL0cHi0qQ7zZmV2jueGSa1GRS5+MUWqgQHl8Ltt+2uZpG
	s/+j4nzbznM57TaRhQ2NkNXZmacslqg=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3823dcc1647so2389773a91.3
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 19:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788402897; x=1789007697; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NXIsSz+mo8g74Vp8Vf3mNp3/WCeSzCYf+BKqQ2Sb8NU=;
        b=COot912AeQ0l+aBWtJyDsin52HgSWaV8cT49U7cbXy+O7zKZm0ziw8YXAD9xDEixgp
         wkMORzzJrXIoJKfC8XIGfxmMsWbmh5STuk37Jmwat4newTcWCuP+J0bvSqHF8bSL4XZ4
         6X95MDyGgN40+xnD4xDdNLZlo624V9N4rcHhPa9oLqrB/p2rxigGhn35bb2U896pG7lT
         rNXM7FPzXZtL2oP5U0qKrh+J9ndZoly52oG5adqAFdLkyOj0JfFgROwneI39WDYXDTO3
         GCWmaozp/6o70SfEGJW1anHe7vdlqvPQljY4coEvoUSlDimgmuKSdAzEVNXjAdWqft+A
         AStQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788402897; x=1789007697;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NXIsSz+mo8g74Vp8Vf3mNp3/WCeSzCYf+BKqQ2Sb8NU=;
        b=dNV4oHNsPFoMcCRJIAsVPv3p6zC/8zDt29mkZyfMeRFJCLkUTdeD/F1v8Zg3619+1p
         P2Od2hgE7pczNvu2mbO+gAN+FqIdV3wTviY7F8UGOUfUQM8ZPUC00IDYrZabs/UmRhPn
         +gTvQzM4RLVKgrI8lXrZ7UiBy3HUMMKO5t0PyduR9QzyprcUemxJbSUBGPISdVyawz/u
         5poL0OTaBw5bhpqssvvWXpA3pptoNkpT2GW8FJaBjIc7k/WbH0sm/FXXwUb84ihtIIK9
         mgGahudMpK0vUFoCin50N0bt7ZC45T33W0AXM5nwh13UWatpuwMteWSg3QZYpAkpiITw
         Gezg==
X-Forwarded-Encrypted: i=1; AKwUvBz5T0sMQ2DTNobj/QERvPBlsyqQ0aPD4Af3wqyeutZPlJgqKU4ilOGEEk1a9Ddte+IBTxnMTDriyg==@kvack.org
X-Gm-Message-State: AFuF++nm6jgTVbxW/bVJkkV6pp9fjeHi2BI1icJ2gP/HnufoER10JOHy
	n7qamRmuLjzMZOsI3iyaL3SDCxN/UHUC1wDfL86WLhIp6k3bbndLHG05xtNJJe6d3Kj//5sLS4z
	2uzmiLlmcs5OCAAVN/jXUMA==
X-Received: from dld23.prod.google.com ([2002:a05:7022:317:b0:13b:9d65:a542])
 (user=loganodell job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2d83:b0:38f:5801:dc0e with SMTP id 98e67ed59e1d1-39aee049464mr14969285a91.15.1788402896637;
 Wed, 02 Sep 2026 19:34:56 -0700 (PDT)
Date: Wed,  2 Sep 2026 19:34:50 -0700
In-Reply-To: <20260903023452.721732-1-loganodell@google.com>
Mime-Version: 1.0
References: <20260903023452.721732-1-loganodell@google.com>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260903023452.721732-2-loganodell@google.com>
Subject: [RFC PATCH 1/3] luo: Move to feature flags instead of compatibility strings
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2B24420009
X-Stat-Signature: kz8fuwoi63csgaq4k3irwkpk4iuxgwog
X-Rspam-User: 
X-HE-Tag: 1788402898-263194
X-HE-Meta: U2FsdGVkX1/14U7sFRcjNcqCj4OeXUkLH4hSSN1ACnkips+Ouw3VzlfuLk7Pqrek7yugUZAQCsTI1XAuMNMEpA55m6fIpdjkWQda5EN0R5HF/7uEWWtTHalLQxstj7D+4NH4mrvNUZRWqBXrKw+XCCB9MniU9PAm+3nqPHO4diayVLxZHmSzsd+QxdUHpaydsCSKOLBzIM/BT5ots3dgJek2+5i70zPPLux9m9jQ5aUpXgqXBFQXfse0TdI5e4t1MO0TP9Cs8acV+WXju/5U0jNbt5E2pNZ2v19wdr38Kmu9Ows1XrEMXvVFVJzRojanz7h/GKvILfTZUaSDCIL+smytBfKbxs3w6gv+ZOPjjCausCmOH2brinZ544yxsmjgFLgzJe2b9A1MN7BngTTz6p9JS28Yv6yGxhstDOc/mfHNsrYfc2tlbb31jXJURG82dsm8nxh93BOQbjeo4rrdYEnRVix9Qh4oLbD8jey9q6lJ92a5gHzNeApE/eOilYeygc2VC1Nv4iZ003kWoFbwNBGaJfZR865jeeJ0ZVAZonUzzxSEYDg0BekkQD5huhT59JVm29VuqZ1TcWAgkouKlBfvfJMxkw8rSY/M0OmSG1x6kWYaAfXpVLdRlkMRZ4poIL8k75Bz8zRUr2G9V5YnURUDbSqCauEwKPvsxH/FOjhROEC2hRUH+d0TWLszLAzIf8zCvktjg0usLVzJPDvHFw5bx8aJ6q2KVWnD/J/zMRDM8Pwq8DM5ZrWgDXrW+zEHVoo7SzeF6D6AqQSvLMOD4MfDtEVd1lISuYD1KHingA73huJXdfQMW57xd2pCMxA02S/TJRQVZNu//nyg/wU3TECXjxl6QaHrFtbPO8AeId1k9aOP4styHbK5oU0pBRUlpi60xc7mBi8Pv3r7fzEd7DT7mDww92FKbaO6HgGfad3QkCYai8VwkXtZyoNLjw/SRQmU4pwItt8GdKB7PZU
 BpfWZeZc
 9IJq3T9uMeZHxtnfqO2nGY8HozPE8o6/BGdsxZntZ7es2I3r+GEvv8dLHY2aKP0Z1YIE/JSvwFMMmWjbvrdURftkYQyPMpm0VRbuOG6lgD04EWPn8nlmxAiaJR/AvrAtuu8Di/0LHqJuYic4tXzt3dOybvw6g5lYqU4WrgaUopw3d4EFFpWkvEtLaBEoE6ta54hAAlgx6iI2QieAETQzZgjNjkiotbj18i8qxF8Bg9rlL6TfSAJ0fftlQi4gBzx+UD/EJd4D5GDtZrzdo1SWb7g9YnbkvmBIQEEk8KhKA2Ac2tqX0WKQMKY+ev6RiowHu4xw3Bq5Z+3p6HFFXTICPTYXRlLiz+3OqIjPqqh9eklD3ZRPVuJBYzWTHm20jYtiVcodzIAceWtBTG3gSftqLbGm1rUCgMDreMJE8SFc+3Ds1w4+2fMteY3PZzThmx7HMMdZXLMn+gEFs/J33GkbMAPd4viGeMgIvWjwOhGqbi5mSOiZzjmgHgBALU8sitbJYKqZv997PATQVqiJjXP0zreMU1gFTRcK2BtaVxMhNFfHomampRtoB7iJX0QaiHZqh+KmmI1n3a1geY8RF920kKoHu/vOKvcuPtXUD109eSW2CBn8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Define a 128 byte header that can be used by all live update serialized
structures. In this header, we reserve room for 64 features with
supported, active, and required bits. Update the top level luo struct to
use this instead of compatibility strings. Previous versions of the
struct had smaller sizes, so add a minimum size check to avoid
collisions with older kernels.

Signed-off-by: Logan Odell <loganodell@google.com>
---
 include/linux/kho/abi/luo.h  | 74 +++++++++++++++++++++++++++++-------
 kernel/liveupdate/luo_core.c | 44 +++++++++++++--------
 2 files changed, 90 insertions(+), 28 deletions(-)

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index 288076de6d4a..0a7662a0cf9a 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -13,15 +13,17 @@
  * kernel. The ABI is built upon the Kexec HandOver framework and registers
  * the central `struct luo_ser` via the KHO raw subtree API.
  *
- * This interface is a contract. Any modification to the structure fields,
- * compatible strings, or the layout of the `__packed` serialization
- * structures defined here constitutes a breaking change. Such changes require
- * incrementing the version number in the relevant `_COMPATIBLE` string to
- * prevent a new kernel from misinterpreting data from an old kernel.
+ * This interface is a contract. To ensure the stability of moving between
+ * kernel versions, any changes to the structures should only be additive
+ * and should utilize the feature flags to denote the supported, active, and
+ * required status of the feature.
+ *
+ * Features that are entirely optional can be added with the supported and
+ * active flags both asserted, and the required flag cleared. Features that
+ * require that the next kernel supports the feature should only be added as
+ * supported to allow compatible transition kernels. At a later time, the
+ * active and required flag should be asserted.
  *
- * Changes are allowed provided the compatibility version is incremented;
- * however, backward/forward compatibility is only guaranteed for kernels
- * supporting the same ABI version.
  *
  * KHO Structure Overview:
  *   The entire LUO state is encapsulated within a single KHO entry named "LUO".
@@ -30,7 +32,7 @@
  * Serialization Structures:
  *   - struct luo_ser:
  *     The central ABI structure that contains the overall state of the LUO.
- *     It includes the compatibility string, the liveupdate-number, and pointers
+ *     It includes the feature flags, the liveupdate-number, and pointers
  *     to sessions and FLBs.
  *
  *   - struct luo_session_ser:
@@ -58,19 +60,65 @@
 #define _LINUX_KHO_ABI_LUO_H
 
 #include <linux/align.h>
+#include <linux/bits.h>
 #include <linux/kho/abi/block.h>
 #include <uapi/linux/liveupdate.h>
 
+/**
+ * struct luo_feature_hdr - Feature negotiation and versioning header.
+ * @supp:     Bitmask of features supported by the producing subsystem.
+ * @req:      Bitmask of features required for safe deserialization by the
+ *            receiving subsystem.
+ * @active:   Bitmask of features actually active/used in the serialized payload.
+ * @reserved: Reserved for future use.
+ *
+ * This header can be embedded at the beginning of any serialized structure to
+ * provide forward and backward compatibility via feature negotiation across
+ * live update.
+ */
+struct luo_feature_hdr {
+	u64 supp;
+	u64 req;
+	u64 active;
+	u64 reserved[13];
+} __packed;
+
+#define LUO_FEATURE_ACTIVE(s, f)		\
+	do {					\
+		(s)->features.supp |= (u64)(f);	\
+		(s)->features.active |= (u64)(f);	\
+	} while (0)
+#define LUO_FEATURE_SUPPORTED(s, f)	((s)->features.supp |= (u64)(f))
+#define LUO_FEATURE_REQUIRED(s, f)	((s)->features.req |= (u64)(f))
+#define LUO_FEATURE_IS_ACTIVE(s, f)	(!!((s)->features.active & (u64)(f)))
+#define LUO_FEATURE_IS_SUPPORTED(s, f)	(!!((s)->features.supp & (u64)(f)))
+#define LUO_FEATURE_IS_REQUIRED(s, f)	(!!((s)->features.req & (u64)(f)))
+
 /*
  * The LUO state is registered under this KHO entry name.
  */
 #define LUO_KHO_ENTRY_NAME	"LUO"
-#define LUO_ABI_COMPATIBLE	"luo-v5"
-#define LUO_ABI_COMPAT_LEN	ALIGN(sizeof(LUO_ABI_COMPATIBLE), 8)
+
+/*
+ * Bits associated with the luo_feature_hdr values.
+ */
+#define LUO_FEATURE_NUMBER    BIT_ULL(0)
+#define LUO_FEATURE_SESSIONS  BIT_ULL(1)
+#define LUO_FEATURE_FLBS      BIT_ULL(2)
+
+#define LUO_CORE_FEATURES_SUPP		(LUO_FEATURE_NUMBER | \
+					 LUO_FEATURE_SESSIONS | \
+					 LUO_FEATURE_FLBS)
+#define LUO_CORE_FEATURES_REQ		(LUO_FEATURE_NUMBER | \
+					 LUO_FEATURE_SESSIONS | \
+					 LUO_FEATURE_FLBS)
+#define LUO_CORE_FEATURES_ACTIVE	(LUO_FEATURE_NUMBER | \
+					 LUO_FEATURE_SESSIONS | \
+					 LUO_FEATURE_FLBS)
 
 /**
  * struct luo_ser - Centralized LUO ABI header.
- * @compatible:     Compatibility string identifying the LUO ABI version.
+ * @features:       Bit mask of supported and active features.
  * @liveupdate_num: A counter tracking the number of successful live updates.
  * @sessions_pa:    Physical address of the first session block header.
  * @flbs_pa:        Physical address of the FLB header.
@@ -78,7 +126,7 @@
  * This structure is the root of all preserved LUO state.
  */
 struct luo_ser {
-	char compatible[LUO_ABI_COMPAT_LEN];
+	struct luo_feature_hdr features;
 	u64 liveupdate_num;
 	u64 sessions_pa;
 	u64 flbs_pa;
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 1b2bda22902d..6add1ecc463f 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -107,26 +107,37 @@ static int __init luo_early_startup(void)
 		return 0;
 	}
 
-	if (len < sizeof(*luo_ser)) {
-		pr_err("LUO state is too small (%zu < %zu)\n", len, sizeof(*luo_ser));
-		return -EINVAL;
+	luo_ser = phys_to_virt(luo_ser_phys);
+
+	if (len < sizeof(struct luo_feature_hdr)) {
+		pr_err("LUO state is too small (%zu < %zu)\n",
+		       len, sizeof(struct luo_feature_hdr));
+		err = -EINVAL;
+		goto out_free_ser;
 	}
 
-	luo_ser = phys_to_virt(luo_ser_phys);
-	if (strncmp(luo_ser->compatible, LUO_ABI_COMPATIBLE, LUO_ABI_COMPAT_LEN)) {
-		pr_err("LUO state is incompatible with '%s'\n", LUO_ABI_COMPATIBLE);
-		return -EINVAL;
+	if (luo_ser->features.req & ~LUO_CORE_FEATURES_SUPP) {
+		pr_err("Unsupported required LUO feature (req: 0x%llx, supp: 0x%llx)\n",
+		       luo_ser->features.req, (u64)LUO_CORE_FEATURES_SUPP);
+		err = -EOPNOTSUPP;
+		goto out_free_ser;
 	}
 
-	luo_global.liveupdate_num = luo_ser->liveupdate_num;
-	pr_info("Retrieved live update data, liveupdate number: %lld\n",
-		luo_global.liveupdate_num);
+	if (LUO_FEATURE_IS_ACTIVE(luo_ser, LUO_FEATURE_NUMBER)) {
+		luo_global.liveupdate_num = luo_ser->liveupdate_num;
+		pr_info("Retrieved live update data, liveupdate number: %lld\n",
+			luo_global.liveupdate_num);
+	}
 
-	err = luo_session_setup_incoming(luo_ser->sessions_pa);
-	if (err)
-		goto out_free_ser;
 
-	luo_flb_setup_incoming(luo_ser->flbs_pa);
+	if (LUO_FEATURE_IS_ACTIVE(luo_ser, LUO_FEATURE_SESSIONS)) {
+		err = luo_session_setup_incoming(luo_ser->sessions_pa);
+		if (err)
+			goto out_free_ser;
+	}
+
+	if (LUO_FEATURE_IS_ACTIVE(luo_ser, LUO_FEATURE_FLBS))
+		luo_flb_setup_incoming(luo_ser->flbs_pa);
 
 	err = 0;
 
@@ -162,7 +173,10 @@ static int __init luo_state_setup(void)
 		return PTR_ERR(luo_ser);
 	}
 
-	strscpy(luo_ser->compatible, LUO_ABI_COMPATIBLE, sizeof(luo_ser->compatible));
+	luo_ser->features.supp = LUO_CORE_FEATURES_SUPP;
+	luo_ser->features.req = LUO_CORE_FEATURES_REQ;
+	luo_ser->features.active = LUO_CORE_FEATURES_ACTIVE;
+
 	luo_ser->liveupdate_num = luo_global.liveupdate_num + 1;
 
 	luo_session_setup_outgoing(&luo_ser->sessions_pa);
-- 
2.55.0.979.g7e5102b832-goog


