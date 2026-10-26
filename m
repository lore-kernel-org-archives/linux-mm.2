Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96F89606A327
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 17:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=iXfDunGr
Received: by kanga.kvack.org (Postfix)
	id 9EE566B05B7; Mon, 26 Oct 2026 13:42:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A12B6B05B8; Mon, 26 Oct 2026 13:42:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7E66B05BA; Mon, 26 Oct 2026 13:42:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67F0A6B05B8
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:42:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CD6671407D4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:42:25 +0000 (UTC)
X-FDA: 85365496650.05.B7ADA7A
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	by imf24.hostedemail.com (Postfix) with ESMTP id 113E2180006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:42:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iXfDunGr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3_JDfagkKCPkubsvotbivhpphmf.dpnmjovy-nnlwbdl.psh@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3_JDfagkKCPkubsvotbivhpphmf.dpnmjovy-nnlwbdl.psh@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793036544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3G8QhvNEpQ3sy+r1BDzvVBq/AXAxP3+qa6H4bl6GlDI=;
	b=6UskOkOx6CHbw3+DkJIPMa7iN3YheR2J3MzlYJQ3tx+Fs5zL7dq04AZzhkRsxPKToY7cEO
	3QaHM4aBzS6VMj762ljtcjxyqXYGGxaubbIfMpxyghNduKjJ3MW3xk0+cJ/I0raTgr0KYO
	x9nv3B65bwYhPAJq5RKjrrD24tOXdx4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iXfDunGr;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3_JDfagkKCPkubsvotbivhpphmf.dpnmjovy-nnlwbdl.psh@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3_JDfagkKCPkubsvotbivhpphmf.dpnmjovy-nnlwbdl.psh@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793036544;
	b=VKufJBtygRrFYSD8eong6SA9m9DbiBQpP6jP3PBIOinCXBFZPizUkny/u7KgCe4JW5DFRK
	92JhTCFlPY0e8Lho/h2jloHBipFuGiHaD17iFglhd0zqrmkVbzxRFmFY+ZLwDgRJaf6Z2z
	QUPiihIpR7I7659eBS61tXzUMLHgKA8=
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c4322d31021so359603466b.3
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793036543; x=1793641343; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3G8QhvNEpQ3sy+r1BDzvVBq/AXAxP3+qa6H4bl6GlDI=;
        b=iXfDunGrEUHnc6YOAgZozAZzAApGD61gmr0+1htPnIpA8/7muQmkKFOaQ41ik7ays9
         N2fRS32J7NIRRnrMA5Ms73Cg8aA1fSG5nRN7ktizJ7kIsY+cVAyX9SwxbJrpEaJP+Lyc
         TIullJWJCoTJFa9iku+d9WkSzq2cp9wiUtGchKT+oEVqDz15Lw36TWgDCC7V5EtAO+F4
         HJdDVD4Bl1I+wW6QpYhCL0rJ9GkRypZJ0W/6k2jjCIj3iq/U8SuNzn6M65yWsKDi+7MW
         EsCJ/UibBxR6F4FrhT1j0er3YhV6CTZSnLgH3WESjwg8i3c7EmwsLot3toAkjirUJf4e
         P8BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793036543; x=1793641343;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3G8QhvNEpQ3sy+r1BDzvVBq/AXAxP3+qa6H4bl6GlDI=;
        b=rjdoeoWB1hTCKz0E95dl09Jok+l1tftsjFq57NBTTmJQ0ox8KTYRcIfPmq3vl5KBxc
         AROCaNP7jxISDsoMhFr6tFPQXtK/qZhrVj1oQ1XmPjOJs06dPBXy2FR1GmvOpxeoHvJ0
         X198xilifP+X9yXgg5tN7+D/TLfJrOvNysram2yc2kdGJk/7UE82VD0TXbf7AXcpIhgc
         ovL6ECSriFiBiqDmVS/KUkSp+GeNKD7hYs+uLdFEMFK2p/Gj21skNbtPoOaZ8t85Vzkp
         JsJQpoDnwxLIQ6SQxcrtRE7FSHrsjOEWTZheyUPBN9udhcCSEhOXNUXj1H40PrJIxnsZ
         Odkw==
X-Forwarded-Encrypted: i=1; AKwUvBxi9LEC4S1eObHMpRTWuzp1tcEDueEmL14YUaop+BgyqsroEvOj6IXzR1PZXE2v5r5QjQoswcdsVA==@kvack.org
X-Gm-Message-State: AFq9FYJeNQfwS9Umbxn5uPTrCYXI3+sBoRBK+S7O4/mYPyZ5sQxDjVZ7
	+V1GPNm2o7JaPCfrpBauCp4GXHXnq5IH/Lm9qM3j4lW2sb1pWEcwRBr8C+V+hBQCNV+mzVZiMRw
	+tBX2fnOVK+O4XTEyiw==
X-Received: from ejaw11.prod.google.com ([2002:a17:906:33cb:b0:c35:60c7:1880])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:d18:b0:c3f:c856:fb7a with SMTP id a640c23a62f3a-c46bdaf85d7mr817347766b.3.1793036540600;
 Mon, 26 Oct 2026 10:42:20 -0700 (PDT)
Date: Mon, 26 Oct 2026 17:42:14 +0000
In-Reply-To: <20261026174217.603114-1-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261026174217.603114-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261026174217.603114-2-tarunsahu@google.com>
Subject: [RFC PATCH v3 1/4] liveupdate: Remove __packed from LUO and memfd ABI structures
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
X-Rspamd-Queue-Id: 113E2180006
X-Stat-Signature: 7igqgdzr6imt4xa338kjdw1i5jzzix51
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793036543-451912
X-HE-Meta: U2FsdGVkX1+7pOKe3e9DgDjjX743QAjrYAkE8dQ/sa+3M7D5aaX754KCfnKYexuoIE8ut+0WYlEebPQpGO6Lclc4HRPAZyjCgLOskFv3HhoTJ8saxj6RfCsqQyTVgYQfm3x5CoHUEtTilXjxtxqDdWlkvyw/SJCRPfQKHPoZWJKZ8Sl1mvTi5Yk7JCpEK/6bLmUhxaoEIsGBTOKdx2p3KqtTU+lgNZY/pbJ/z0DiGojqVlD7nf2D7KhptVbqmpfX8U5F8BYf2taAr8cRQ2yiR4MEBKUQYtadPOREw54h9sM3+2XcM//lp5aLpMGF+LRYzPrBn+ldJiHCDpCTgAgdeFyM57CPb2x7vHX9q2MkKbAr6j04bt3VkWdxytDVdrLZdlVT7aIxf4KBPXYxYLrHSHfB8+pcEKco1c89qtxjpCIuCQxrUArLciIMNJFhLL97R+1xO6tgoxXbQslEt1SLIrKbCexDa2OoDNv7QqsbRBT/Bk0CjbS8CgPgqYM69GfKMDRAaQNZDgwhGqRON/0s0jS5jy3Z0Pv9mW/X5H9EIf8TQ3yITyj6NTkPAcs7f3JND4stu4qPwnEq4n25BhWoQ370Y7O1+yfCn+q0SjujNtZNo9u1UIkyZCix1j3qxLV72r29pqir4IlKksJydUtSHt1CzN+SRdavngt6mqf7gMv1OYXbYUlB7wBv12achB7uMOPUyCFhpnda17KCCO5VTc/jKhv7zJwTx12/PW3RoNspOrc5SV5SCbqxy6HsLFKAgszW5Na3vTV5YJPYUSmyLvVZYQOnOHpu70n8zTOBuNAlvbjeb3d7QMBwRJiMl7SBWkoP2hamCeKg2UVceH3P4YBbS85Zlc0IZTPK+CYRSI2sTJ3cETwgRa5Ugkr5K2RVhRwDUOJDH7QL+/hjuKX6fzKImyT09PuGKlTh+Nm0hyc89s1NIZQ34g4SGy+iDeqqqZ7G6l9DlMAfhstjiMN
 J3tTE/ZC
 8lMgadBkPiEUznMiVzOI/fsOc4pL5sYLeaB2o8PZdlMW6X0KVMdKh2cabVERqe4DVi+1iqczu7J6hBRI2dj7Y8Zpx04VEPD6v8gPg4ooKLc6tTZzBTsR+Y09p03EXTBKtQxxqdRZjuJds7wFWtQmoL71m4Y3FEY46rMOH53ocBYZ28EtCrVwuOO/3cw4zB4fKI+8vm9SumGLdo80gniOz7kXU2xH+UzUG8iuaDFZuwDxPe9GSvlVpWPK69/8ZvFsh2vNHfWmPSk0a/gFOhKgWkMTZaTfkHB+MshLTUfawT1mliwLvaR0EFXl/SVmo46/1Fr3RMOTRPfWfIw5hrLmTUY4zB9d2x35c+7oGEF8oIxzJCqlRvbsLXZHbAJwyh3qM/VPlwW71itGCjsxUwF3QWgzB4DDMC0sBM0UbH64NejlxcqGG1giK8dlZk4fKc1KKBudq52CfI074DATihH7+MXt02Ps5OglAzwlRic5ztqjVqfd6PDztpkVRcAE/q7HmknW8wTicK4jTJfBLubCsOXXxQuAuxU5iVV3bKZkfyP2aQ+CyvSFZKEsognHwd8MPiJPeOcSJZEIHB/Q3Ur81WGydtl6412jGpRVtDziyDqXjKiMEW8FkwBdqDMWWRgAUdxIEgUOTBqLkQ2kHy9v0u8BhgLQlT8pW0ZhNtiIgqHRPhBYz9gT5OyzfjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

All structures in include/linux/kho/abi/luo.h (struct luo_ser, struct
luo_file_ser, struct luo_file_set_ser, struct luo_session_ser, struct
luo_flb_header_ser, struct luo_flb_ser) and include/linux/kho/abi/memfd.h
(struct memfd_luo_folio_ser, struct memfd_luo_ser) have naturally aligned
fields on 64-bit architectures, with no padding holes between fields or
tail padding. Any future unaligned field addition should come with
reserved field to keep the structure aligned.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/luo.h   | 25 +++++++++++++++++++------
 include/linux/kho/abi/memfd.h | 11 ++++++++---
 2 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index 288076de6d4a..899943877e41 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -58,6 +58,7 @@
 #define _LINUX_KHO_ABI_LUO_H
 
 #include <linux/align.h>
+#include <linux/build_bug.h>
 #include <linux/kho/abi/block.h>
 #include <uapi/linux/liveupdate.h>
 
@@ -82,7 +83,9 @@ struct luo_ser {
 	u64 liveupdate_num;
 	u64 sessions_pa;
 	u64 flbs_pa;
-} __packed;
+};
+
+static_assert(sizeof(struct luo_ser) == 32);
 
 #define LIVEUPDATE_HNDL_COMPAT_LENGTH	48
 
@@ -98,7 +101,9 @@ struct luo_file_ser {
 	char compatible[LIVEUPDATE_HNDL_COMPAT_LENGTH];
 	u64 data;
 	u64 token;
-} __packed;
+};
+
+static_assert(sizeof(struct luo_file_ser) == 64);
 
 /**
  * struct luo_file_set_ser - Represents the serialized metadata for file set
@@ -113,7 +118,9 @@ struct luo_file_ser {
 struct luo_file_set_ser {
 	u64 files;
 	u64 count;
-} __packed;
+};
+
+static_assert(sizeof(struct luo_file_set_ser) == 16);
 
 /**
  * struct luo_session_ser - Represents the serialized metadata for a LUO session.
@@ -131,7 +138,9 @@ struct luo_file_set_ser {
 struct luo_session_ser {
 	char name[LIVEUPDATE_SESSION_NAME_LENGTH];
 	struct luo_file_set_ser file_set_ser;
-} __packed;
+};
+
+static_assert(sizeof(struct luo_session_ser) == 80);
 
 /* The max size is set so it can be reliably used during in serialization */
 #define LIVEUPDATE_FLB_COMPAT_LENGTH	48
@@ -152,7 +161,9 @@ struct luo_session_ser {
 struct luo_flb_header_ser {
 	u64 pgcnt;
 	u64 count;
-} __packed;
+};
+
+static_assert(sizeof(struct luo_flb_header_ser) == 16);
 
 /**
  * struct luo_flb_ser - Represents the serialized state of a single FLB object.
@@ -175,7 +186,9 @@ struct luo_flb_ser {
 	char name[LIVEUPDATE_FLB_COMPAT_LENGTH];
 	u64 data;
 	u64 count;
-} __packed;
+};
+
+static_assert(sizeof(struct luo_flb_ser) == 64);
 
 /* Kernel Live Update Test ABI */
 #ifdef CONFIG_LIVEUPDATE_TEST
diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
index 08b10fea2afc..7115a8a77cfd 100644
--- a/include/linux/kho/abi/memfd.h
+++ b/include/linux/kho/abi/memfd.h
@@ -11,6 +11,7 @@
 #ifndef _LINUX_KHO_ABI_MEMFD_H
 #define _LINUX_KHO_ABI_MEMFD_H
 
+#include <linux/build_bug.h>
 #include <linux/types.h>
 #include <linux/kho/abi/kexec_handover.h>
 
@@ -20,7 +21,7 @@
  * memfd uses the ABI defined below for preserving its state across a kexec
  * reboot using the LUO.
  *
- * The state is serialized into a packed structure `struct memfd_luo_ser`
+ * The state is serialized into `struct memfd_luo_ser`
  * which is handed over to the next kernel via the KHO mechanism.
  *
  * This interface is a contract. Any modification to the structure layout
@@ -54,7 +55,9 @@ struct memfd_luo_folio_ser {
 	u64 pfn:52;
 	u64 flags:12;
 	u64 index;
-} __packed;
+};
+
+static_assert(sizeof(struct memfd_luo_folio_ser) == 16);
 
 /*
  * The set of seals this version supports preserving. If support for any new
@@ -85,7 +88,9 @@ struct memfd_luo_ser {
 	u32 flags;
 	u64 nr_folios;
 	struct kho_vmalloc folios;
-} __packed;
+};
+
+static_assert(sizeof(struct memfd_luo_ser) == 48);
 
 /* The compatibility string for memfd file handler */
 #define MEMFD_LUO_FH_COMPATIBLE	"memfd-v2"
-- 
2.56.0.307.g5fe7bd680c-goog


