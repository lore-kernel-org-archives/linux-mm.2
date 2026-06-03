Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63327CD6E6C
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 03:29:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83A886B0093; Tue,  2 Jun 2026 23:29:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811526B0095; Tue,  2 Jun 2026 23:29:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63E416B0096; Tue,  2 Jun 2026 23:29:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 524416B0093
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:29:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 25C041A0217
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:29:16 +0000 (UTC)
X-FDA: 84837170712.18.6D4E037
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5A353180004
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:29:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=N+pbse99;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780457354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6dIvXcFtnsq21AdbL6IuUE0knwOnoW1aNxCP2lCoxdM=;
	b=bYpLgOiV3+wU4kc1BJlmiJaFaUR8dcjG+vYamqjXXbYmdbWUCFdUBnOIwrarTpI5YU+LZr
	0kZLmcVbTxevOQMZaPY5pTfZXi/Ats4xKX7of6G+rDlFOa4+JQUA7s0bg7Gyex/hIpArJs
	FNs8nqH7iFV+AwojApD3MfrZ11HIJAU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=N+pbse99;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780457354;
	b=3HMBtV3pntDSbiJGmOZaVFEa2kjHzqV4RkPRMvFTqlN4YVEBxuUlGy/6PBSVDxk4uoCmxp
	W6ubfre5laRF0UkP8Z9VcP/t/bZaKUi2Y5n+kwDrEoo/MNXkMU/437ZK4HzeBF8mTey4c9
	CcTINu5t/NDkyfXLfe0fdUU9eJq2pJY=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8cce77eb087so44717086d6.1
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 20:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780457353; x=1781062153; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6dIvXcFtnsq21AdbL6IuUE0knwOnoW1aNxCP2lCoxdM=;
        b=N+pbse998atF7xa+GXL6cHS2mVam6L/p2PFsXJUnLdE00RHES0ezHNTOaqgO+QTJQ9
         +MD0H6wEerjDGHWB2jVT+6XVL3VPZvbSshFWSRn12lRRtVg7G9NgVihjwhJHl2O/tNE5
         otiQMAQ0hRjAYilKPbiBZIegNL7qjjzzauBoVO+r/y3fjjiPNT3lHr+PtPT0B945eX2z
         wvs3NBqw9pN5FASG0Ka3YrbPtQlhSakFAftjjMpZMOc3umGBy7cZ32t5WIezjAfz4s8i
         fPmO0SqyFw+bYIDAgQNfTSLnEw/Pv1CSKhbr6q8LT38/9puUgU96yE/udUAk8Hygao2G
         jIlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780457353; x=1781062153;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6dIvXcFtnsq21AdbL6IuUE0knwOnoW1aNxCP2lCoxdM=;
        b=FYUokkKElg681UtJwtoyp2FJk2JjzluEuvZpuJh8KyYpAIaNwR6S8xM6Cfvk1vHrlA
         pHvuwZGiAvEgvdgXR693UOakl9FMXV5lvD5a+ITcJrppIIcrcy1j08o8fUr5ZK9URmfY
         KlPqX4+fNqDvWu3M1yGjEKaz+WgI4UMb5qe4B8/S4hngrvnMDN93qpixYEdWDcnLtdTl
         rMvps1YqlZFP4zhGtpVLnZaFAUZfZPRlHfemBrZ1mdeLGSmQgrjIbYM2hLaGU7ugWFHt
         7aFHitNBPAAlx19+i7aetLeypySRv/FR0jBeH05tDS9gZ+McGbXb+sXBIR4+nRyywz8o
         c0LA==
X-Forwarded-Encrypted: i=1; AFNElJ+306Ec04N6vmeC8v71wHgxTYTuKqbHISicYxpeNYqBveMpMAa7oRyKqjZBuoVULsor26aqun0eYQ==@kvack.org
X-Gm-Message-State: AOJu0YynrGtId0q2NFe1bwgzUrx6VVvecq/pUd2mfvA/SouX82cWtOTx
	KKvlZJOK1L4OX3wTaTz7gO7lJ7N/5AlerjT2V71C7W0dq407EnxqJ1dkoad5hsXOGDs=
X-Gm-Gg: Acq92OHllsymAl2QT8gqDnjAFUvJDareCa2iHIPufq4ZJF8GuynVWbIXA96idJL1f77
	pOK1igsAefHarxn4yNEld8xebhqdhK7wjqnAJRuAp4pk31cuFE7RlQVQ+/bFk5ofv6gpoCZsOc6
	zFgKPA5dFsq070WjINMis+p0IMpLrAQ7f6XXL6kH6u7uMpVau+5GWm+fFbevXlvC77EgKRXCBEk
	tlArbKF50mfGETJmbJGW2fMxcVSxbfr5QWxh8ZsDjpc0pHvqxNnNlpE/CeRF+2m1hqydp2VpGrY
	pTy7tKvfpIgKAi4UjQ4YEUeiLDjCDoaejK/n7OmRAJSbaSbzbiDjqx5SFHFdUnE/+auyoRX7H0V
	grpM+iAz5VxtNlwVytAsnUqDHlXIKo6QqVXSwB7RRdC85SOPEwecP3VvOHmCXhoc1/YW6FWV6Ej
	9C6G6FKqzuLNO9MzBPWhVHCXhBdEdYbBYx2z07lmz12eXLBMfEvjouje285OJfbQ==
X-Received: by 2002:a05:6214:3d10:b0:8ce:b018:89e1 with SMTP id 6a1803df08f44-8cecdcbfd20mr21165026d6.32.1780457353365;
        Tue, 02 Jun 2026 20:29:13 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd26b3b9sm9244566d6.45.2026.06.02.20.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 20:29:12 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	skhawaja@google.com,
	graf@amazon.com
Subject: [PATCH v6 04/13] liveupdate: register luo_ser as KHO subtree
Date: Wed,  3 Jun 2026 03:28:55 +0000
Message-ID: <20260603032905.344462-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603032905.344462-1-pasha.tatashin@soleen.com>
References: <20260603032905.344462-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5A353180004
X-Rspam-User: 
X-Stat-Signature: h7sshtk7upbkcbh6i3e5k1rcngjjzwy1
X-Rspamd-Server: rspam09
X-HE-Tag: 1780457354-650301
X-HE-Meta: U2FsdGVkX18fZ1SlDLqZbsRMCwfCHTMDDPEEBJDSctJX2P61UTWlL7NAXdtmk0lW8zwt/u0fhM1Fr4gEsRW7+53RZX3xyNNHAWddOYaU5zMp6D8qJ5pycnf45MbEotcLOoCSu1jFVayxTL+Rge+2AhZazEOxuKQ+8yDp3O/FxyHd4vXJ1d+0eLqCgdjLvKGbftb4pRF4Ja7Y5uZJDJaxNmuCPjt7svfuBD+MXbaxk1YLgSH8G6TmpQGzc3nWkfHEtVnNseeTof0VGNQY880JEDoHodRNwFYvj/423vdLuPC7OC0KbWhtduU7b7Cq8G/blyS/M6TatnbiA45V0rF7mAi62HgCi9qIf4haRZDAXSsRRSMlwoD4idTZs3OUmT1UEn4m8dSpnMlstbO2TRnEHvTpLxAUQ5BNmKLvt5wZG0nDNWCytGjUUc5lSJ0KVd51C7Naqpbdj29gfp1GV9GLR4Wiym3RrL1ZCGtdocrf3cfrq7knhHrofqpeplEy15MMhAlVLcbN5xwyZ7sBrkJfvMxxw0gBE/bRNRPaaGuuenUc7Ftpp2vZXCF++Ag+VZz96m6mgIdiXKLL+Kr6k0cLLfCZqV2LhEERQAfSkoEFBfonQ2PXJZLQ57iYaEp748A8ewWeTqdLZmNk+C5ZDUfFM3b6ZOaQu4vo4XBpkTLEeUapvx0nF+dwzt09OtbAElBWyqQkYrj6fWzzMJsCYmHaPb83Hiu5yZuvQD37YAHj/7DfJkjYe8NT5k1p9kSoEXLCq9o0zO8mRZJAxhKeg5gxZtdGljSWH+F8k8c/nYGjhd4C1LaJd2JgnrBMtmVocFv0CwK6aYtq2w6fqtDiKCyjmTrTUaMKhyFIXSs6dW8M/ZumowNaMMyVWEUquMa4ZU1PKD9hfi2cqWaugnIDjaFjN+1oFslw2kagyJApK3fmgs9fu++rVluhk++9hagQQ7NU0Pqew1dChvhiqU23v2a
 z6eZspmv
 ZnhOnp4jp9J0/FTBkz70Mu14wqeb1BeLGZXv7a/+I3Bpzv/vWWIakHtKgZxE48a06BTlV7AS8GrH0r++n1bXSjOekXPYFzRC6nyv0swdw4O7pnVNKIftnl5SwnHTXSB/mo8QNiu1xXCcf5gFzGTUdqu2Ckxl2icaa8Q9qWddOAz/MP19k18ULl0sbpDhTKexWgQIcUgONZ3X8QK6lyQTUCOxDtk6hocIqXTU9UE30VKV7XsQp1JJKIuaBM6U3XjtoSzjrJOgq2Ns4OxY/hezhyM2jOHTQd2TITBsnlSCzxoLAMCeXzY+1I3GOnuG/IvBy4f4KyylyziY1/B+llCxwUeWzIbGJTYuTI3GeXSC0xTyjWQduqVBnR5VgvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Entirely remove the LUO FDT wrapper since the FDT only carries the
compatible string and the pointer to the centralized struct luo_ser.
Instead, register the struct luo_ser via the KHO raw subtree
API, placing the compatibility string inside the structure itself.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kho/abi/luo.h  | 57 +++++++++---------------
 kernel/liveupdate/luo_core.c | 85 +++++++++++-------------------------
 2 files changed, 46 insertions(+), 96 deletions(-)

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index 1b2f865a771a..9a4fe491812b 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -10,11 +10,11 @@
  *
  * Live Update Orchestrator uses the stable Application Binary Interface
  * defined below to pass state from a pre-update kernel to a post-update
- * kernel. The ABI is built upon the Kexec HandOver framework and uses a
- * Flattened Device Tree to describe the preserved data.
+ * kernel. The ABI is built upon the Kexec HandOver framework and registers
+ * the central `struct luo_ser` via the KHO raw subtree API.
  *
- * This interface is a contract. Any modification to the FDT structure, node
- * properties, compatible strings, or the layout of the `__packed` serialization
+ * This interface is a contract. Any modification to the structure fields,
+ * compatible strings, or the layout of the `__packed` serialization
  * structures defined here constitutes a breaking change. Such changes require
  * incrementing the version number in the relevant `_COMPATIBLE` string to
  * prevent a new kernel from misinterpreting data from an old kernel.
@@ -23,31 +23,15 @@
  * however, backward/forward compatibility is only guaranteed for kernels
  * supporting the same ABI version.
  *
- * FDT Structure Overview:
+ * KHO Structure Overview:
  *   The entire LUO state is encapsulated within a single KHO entry named "LUO".
- *   This entry contains an FDT with the following layout:
- *
- *   .. code-block:: none
- *
- *     / {
- *         compatible = "luo-v2";
- *         luo-abi-header = <phys_addr_of_luo_ser>;
- *     };
- *
- * Main LUO Node (/):
- *
- *   - compatible: "luo-v2"
- *     Identifies the overall LUO ABI version.
- *   - luo-abi-header: u64
- *     The physical address of `struct luo_ser`.
+ *   This entry contains the `struct luo_ser` structure.
  *
  * Serialization Structures:
- *   The FDT properties point to memory regions containing arrays of simple,
- *   `__packed` structures. These structures contain the actual preserved state.
- *
  *   - struct luo_ser:
  *     The central ABI structure that contains the overall state of the LUO.
- *     It includes the liveupdate-number and pointers to sessions and FLBs.
+ *     It includes the compatibility string, the liveupdate-number, and pointers
+ *     to sessions and FLBs.
  *
  *   - struct luo_session_header_ser:
  *     Header for the session array. Contains the total page count of the
@@ -78,26 +62,27 @@
 #ifndef _LINUX_KHO_ABI_LUO_H
 #define _LINUX_KHO_ABI_LUO_H
 
+#include <linux/align.h>
 #include <uapi/linux/liveupdate.h>
 
 /*
- * The LUO FDT hooks all LUO state for sessions, fds, etc.
+ * The LUO state is registered under this KHO entry name.
  */
-#define LUO_FDT_SIZE		PAGE_SIZE
-#define LUO_FDT_KHO_ENTRY_NAME	"LUO"
-#define LUO_FDT_COMPATIBLE	"luo-v2"
-#define LUO_FDT_ABI_HEADER	"luo-abi-header"
+#define LUO_KHO_ENTRY_NAME	"LUO"
+#define LUO_ABI_COMPATIBLE	"luo-v3"
+#define LUO_ABI_COMPAT_LEN	ALIGN(sizeof(LUO_ABI_COMPATIBLE), 8)
 
 /**
  * struct luo_ser - Centralized LUO ABI header.
+ * @compatible:     Compatibility string identifying the LUO ABI version.
  * @liveupdate_num: A counter tracking the number of successful live updates.
  * @sessions_pa:    Physical address of the first session block header.
  * @flbs_pa:        Physical address of the FLB header.
  *
- * This structure is the root of all preserved LUO state. It is pointed to by
- * the "luo-abi-header" property in the LUO FDT.
+ * This structure is the root of all preserved LUO state.
  */
 struct luo_ser {
+	char compatible[LUO_ABI_COMPAT_LEN];
 	u64 liveupdate_num;
 	u64 sessions_pa;
 	u64 flbs_pa;
@@ -111,7 +96,7 @@ struct luo_ser {
  * @data:        Private data
  * @token:       User provided token for this file
  *
- * If this structure is modified, LUO_SESSION_COMPATIBLE must be updated.
+ * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
  */
 struct luo_file_ser {
 	char compatible[LIVEUPDATE_HNDL_COMPAT_LENGTH];
@@ -142,7 +127,7 @@ struct luo_file_set_ser {
  * physical memory preserved across the kexec. It provides the necessary
  * metadata to interpret the array of session entries that follow.
  *
- * If this structure is modified, `LUO_FDT_COMPATIBLE` must be updated.
+ * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
  */
 struct luo_session_header_ser {
 	u64 count;
@@ -159,7 +144,7 @@ struct luo_session_header_ser {
  * session) is created and passed to the new kernel, allowing it to reconstruct
  * the session context.
  *
- * If this structure is modified, `LUO_FDT_COMPATIBLE` must be updated.
+ * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
  */
 struct luo_session_ser {
 	char name[LIVEUPDATE_SESSION_NAME_LENGTH];
@@ -180,7 +165,7 @@ struct luo_session_ser {
  * This structure is located at the physical address specified by the
  * flbs_pa in luo_ser.
  *
- * If this structure is modified, `LUO_FDT_COMPATIBLE` must be updated.
+ * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
  */
 struct luo_flb_header_ser {
 	u64 pgcnt;
@@ -202,7 +187,7 @@ struct luo_flb_header_ser {
  * passed to the new kernel. Each entry allows the LUO core to restore one
  * global, shared object.
  *
- * If this structure is modified, `LUO_FDT_COMPATIBLE` must be updated.
+ * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
  */
 struct luo_flb_ser {
 	char name[LIVEUPDATE_FLB_COMPAT_LENGTH];
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 085c0dfc1ef1..69b00e7d0f8f 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -54,7 +54,6 @@
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/luo.h>
 #include <linux/kobject.h>
-#include <linux/libfdt.h>
 #include <linux/liveupdate.h>
 #include <linux/miscdevice.h>
 #include <linux/mm.h>
@@ -67,8 +66,7 @@
 
 static struct {
 	bool enabled;
-	void *fdt_out;
-	void *fdt_in;
+	struct luo_ser *luo_ser_out;
 	u64 liveupdate_num;
 } luo_global;
 
@@ -85,11 +83,10 @@ early_param("liveupdate", early_liveupdate_param);
 
 static int __init luo_early_startup(void)
 {
+	phys_addr_t luo_ser_phys;
 	struct luo_ser *luo_ser;
-	int err, header_size;
-	phys_addr_t fdt_phys;
-	const void *ptr;
-	u64 luo_ser_pa;
+	size_t len;
+	int err;
 
 	if (!kho_is_enabled()) {
 		if (liveupdate_enabled())
@@ -98,40 +95,29 @@ static int __init luo_early_startup(void)
 		return 0;
 	}
 
-	/* Retrieve LUO subtree, and verify its format. */
-	err = kho_retrieve_subtree(LUO_FDT_KHO_ENTRY_NAME, &fdt_phys, NULL);
+	/* Retrieve LUO state from KHO. */
+	err = kho_retrieve_subtree(LUO_KHO_ENTRY_NAME, &luo_ser_phys, &len);
 	if (err) {
 		if (err != -ENOENT) {
-			pr_err("failed to retrieve FDT '%s' from KHO: %pe\n",
-			       LUO_FDT_KHO_ENTRY_NAME, ERR_PTR(err));
+			pr_err("failed to retrieve LUO state '%s' from KHO: %pe\n",
+			       LUO_KHO_ENTRY_NAME, ERR_PTR(err));
 			return err;
 		}
 
 		return 0;
 	}
 
-	luo_global.fdt_in = phys_to_virt(fdt_phys);
-	err = fdt_node_check_compatible(luo_global.fdt_in, 0,
-					LUO_FDT_COMPATIBLE);
-	if (err) {
-		pr_err("FDT '%s' is incompatible with '%s' [%d]\n",
-		       LUO_FDT_KHO_ENTRY_NAME, LUO_FDT_COMPATIBLE, err);
-
+	if (len < sizeof(*luo_ser)) {
+		pr_err("LUO state is too small (%zu < %zu)\n", len, sizeof(*luo_ser));
 		return -EINVAL;
 	}
 
-	header_size = 0;
-	ptr = fdt_getprop(luo_global.fdt_in, 0, LUO_FDT_ABI_HEADER, &header_size);
-	if (!ptr || header_size != sizeof(u64)) {
-		pr_err("Unable to get ABI header '%s' [%d]\n",
-		       LUO_FDT_ABI_HEADER, header_size);
-
+	luo_ser = phys_to_virt(luo_ser_phys);
+	if (strncmp(luo_ser->compatible, LUO_ABI_COMPATIBLE, LUO_ABI_COMPAT_LEN)) {
+		pr_err("LUO state is incompatible with '%s'\n", LUO_ABI_COMPATIBLE);
 		return -EINVAL;
 	}
 
-	luo_ser_pa = get_unaligned((u64 *)ptr);
-	luo_ser = phys_to_virt(luo_ser_pa);
-
 	luo_global.liveupdate_num = luo_ser->liveupdate_num;
 	pr_info("Retrieved live update data, liveupdate number: %lld\n",
 		luo_global.liveupdate_num);
@@ -164,37 +150,20 @@ static int __init liveupdate_early_init(void)
 }
 early_initcall(liveupdate_early_init);
 
-/* Called during boot to create outgoing LUO fdt tree */
-static int __init luo_fdt_setup(void)
+/* Called during boot to create outgoing LUO state */
+static int __init luo_state_setup(void)
 {
 	struct luo_ser *luo_ser;
-	u64 luo_ser_pa;
-	void *fdt_out;
 	int err;
 
-	fdt_out = kho_alloc_preserve(LUO_FDT_SIZE);
-	if (IS_ERR(fdt_out)) {
-		pr_err("failed to allocate/preserve FDT memory\n");
-		return PTR_ERR(fdt_out);
-	}
-
 	luo_ser = kho_alloc_preserve(sizeof(*luo_ser));
 	if (IS_ERR(luo_ser)) {
-		err = PTR_ERR(luo_ser);
-		goto exit_free_fdt;
+		pr_err("failed to allocate/preserve LUO state memory\n");
+		return PTR_ERR(luo_ser);
 	}
-	luo_ser_pa = virt_to_phys(luo_ser);
-
-	err = fdt_create(fdt_out, LUO_FDT_SIZE);
-	err |= fdt_finish_reservemap(fdt_out);
-	err |= fdt_begin_node(fdt_out, "");
-	err |= fdt_property_string(fdt_out, "compatible", LUO_FDT_COMPATIBLE);
-	err |= fdt_property(fdt_out, LUO_FDT_ABI_HEADER, &luo_ser_pa,
-			    sizeof(luo_ser_pa));
-	err |= fdt_end_node(fdt_out);
-	err |= fdt_finish(fdt_out);
-	if (err)
-		goto exit_free_luo_ser;
+
+	strscpy(luo_ser->compatible, LUO_ABI_COMPATIBLE, sizeof(luo_ser->compatible));
+	luo_ser->liveupdate_num = luo_global.liveupdate_num + 1;
 
 	err = luo_session_setup_outgoing(&luo_ser->sessions_pa);
 	if (err)
@@ -204,21 +173,17 @@ static int __init luo_fdt_setup(void)
 	if (err)
 		goto exit_free_luo_ser;
 
-	luo_ser->liveupdate_num = luo_global.liveupdate_num + 1;
-
-	err = kho_add_subtree(LUO_FDT_KHO_ENTRY_NAME, fdt_out,
-			      fdt_totalsize(fdt_out));
+	err = kho_add_subtree(LUO_KHO_ENTRY_NAME, luo_ser, sizeof(*luo_ser));
 	if (err)
 		goto exit_free_luo_ser;
-	luo_global.fdt_out = fdt_out;
+
+	luo_global.luo_ser_out = luo_ser;
 
 	return 0;
 
 exit_free_luo_ser:
 	kho_unpreserve_free(luo_ser);
-exit_free_fdt:
-	kho_unpreserve_free(fdt_out);
-	pr_err("failed to prepare LUO FDT: %d\n", err);
+	pr_err("failed to prepare LUO state: %d\n", err);
 
 	return err;
 }
@@ -234,7 +199,7 @@ static int __init luo_late_startup(void)
 	if (!liveupdate_enabled())
 		return 0;
 
-	err = luo_fdt_setup();
+	err = luo_state_setup();
 	if (err)
 		luo_global.enabled = false;
 
-- 
2.53.0


