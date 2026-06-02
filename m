Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5860CD6E61
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 03:17:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 476096B04AC; Mon,  1 Jun 2026 23:17:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44D8E6B04AF; Mon,  1 Jun 2026 23:17:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 347136B04B1; Mon,  1 Jun 2026 23:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15F9C6B04AC
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:17:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C59B9919BD
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:17:26 +0000 (UTC)
X-FDA: 84833512092.04.82B76C0
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0D3B0100009
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:17:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JC+Cpo4a;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780370245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6dIvXcFtnsq21AdbL6IuUE0knwOnoW1aNxCP2lCoxdM=;
	b=uAmo/oqFoBHheWFV8SJvvXi4HenkGWkGtmyrdtVl/e6fiUEmXS6xzb8zR/CfghCinJ3tc3
	5Vw4r4oXVcsSNHgabsbvnqP/O8Hevv0fmKQvwSYOe5E73HbmSVmZGJOhjG2CzCckpVI0+R
	iLtSSemC709iDwCqLg2iFelr5O4T4dI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JC+Cpo4a;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780370245;
	b=H6OyjzR93QskD5weDxLpT9fWV34zQT8k7ESUuQopYeUPe2Uo0mvGEed6rsxwIIVqQc/2wv
	9ka4FNKiBvR2yVOLaWL7zGRx1mT8YxQ7cEklkzjTnarAXMRrxblO25r3Ru3dTEHK09ZkeS
	LPYNe57q8Rp7u/HrXDyHPnbHhFnzKkc=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5176b9c476aso1447651cf.3
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 20:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780370244; x=1780975044; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6dIvXcFtnsq21AdbL6IuUE0knwOnoW1aNxCP2lCoxdM=;
        b=JC+Cpo4a6moW4NfkXYkfxP/a5+g03JiW/R16jSPHEP4KCmw9SuFFkSoGeGV5jBHB7Z
         7j61CjapnzuoKDzzDKvvCZ3RynyKEgJ+75BgGUDkyFzbJIfKhjpZawCXlEfQvcqiSeWE
         o/FQuQ7rX+BnZY/OWw2EkXrh7YhfpD0YQjJLONMUzjTOGVr9pQh0y+vt9KlIrSXgvikv
         J9NZrI/5EXCSPu/qnLC2pdxwFhSKpx10wenrPtjCSaMm780XHuc5FW5Cu0ARfWqEPWqc
         YytpjCtFcFoL9m1M9pjLJtCQPrX6P2pXtwjVNkGCbxSn6DwN/5e6hAffuZYUz0NoBLR3
         sZJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780370244; x=1780975044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6dIvXcFtnsq21AdbL6IuUE0knwOnoW1aNxCP2lCoxdM=;
        b=FbxwRVP5wP5SXlcQOVIo84XYKrWQgbDeDjdmBJ2PCH4m0s950MIXmIzxwseqTkREup
         EUVOty0WWXvGTHynHyL+2DtBdix6BDb7ko7/UdglUtvd1y+LSZkPODQ5NJ8H1dAbrsjC
         9SXLvSmx7YYvS3dE0vzJ4tWbkcOl8SjjJ7AQg7NWLkrfbzcc5g4ib5rAruLVp5Ji6M2y
         5dFAT6jjaGDA+F3BIpJeZKpfYpnElSLqKGOdDArauOXh6Jp43UtEwc8KyFuUbZDO7oQZ
         orvnjnBabbspgy+d5SbTL7+ZVgc9cm+FIOKynMIqqNh0paeYFKD6Jmfg3jirFfx3X+cn
         SsJw==
X-Forwarded-Encrypted: i=1; AFNElJ/LmiH9jdiJ+02fkG+83cbPRKBTSJgqZXY7c1WDBTuOqUJ2MKv3oGTqBDib4PPB63i9FgbA4yujaA==@kvack.org
X-Gm-Message-State: AOJu0YzVk8m1VEcA2hzY81R/aZHRdzGEnwcxCmoJtxqpNOzutRxmxwUE
	5VeLbLUSo3ovjEIdbi7gCVkvqvOO+3IT/E1cA788RERcPObfPsU6xPL3/6VdHYFhHsU=
X-Gm-Gg: Acq92OFP0nkMA79UpX1cGuavoYkFkaYhGjF7cVI4WdwNXbP5w4zNt27j5HFD915Xai3
	ZKrJIoankiziFji0r0sfKZyKq/2b8FU2dTsvzxXixFnXXWduKVmY/27CdN4pxxeyJBRlNPiwLU4
	XPuLJp8jsA+T4UgN7Wxcp0ujKgqSIQX/AjWtWJL8V3WsngrcrFtnxWg08XvBMoJCyCcIKQGsRQH
	92Ogk9AyPOnvAZ9U+XqMwABBCzZTQFqb2Pzm32ojVVOHtCUcBfEN5eqDzFnNRGesL70mE1pyr35
	Ejxgzh889KORz+vI/o7fj2y3aSKh/1mRiwRQEEfnLu+c0/bQEz+W4UHtCd5hBdvHFJscmz34R/U
	Q/9tg3DdoqDBhly34nHJxpKahHmbPWwU91d72O8LNlHVZWIpPW26chjnelJils3B23XCWnYFFsH
	7VL+gUZFXyxvTm5xOduVRVSAr0ZNri2NjO/A2tMbdK4/kE9EXNGynZRUV7bGbnfA==
X-Received: by 2002:a05:622a:1882:b0:517:6c96:8f1a with SMTP id d75a77b69052e-5176c968ff0mr8717501cf.10.1780370244108;
        Mon, 01 Jun 2026 20:17:24 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51741b29745sm71219081cf.8.2026.06.01.20.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 20:17:23 -0700 (PDT)
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
Subject: [PATCH v5 04/13] liveupdate: register luo_ser as KHO subtree
Date: Tue,  2 Jun 2026 03:17:08 +0000
Message-ID: <20260602031717.197696-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260602031717.197696-1-pasha.tatashin@soleen.com>
References: <20260602031717.197696-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0D3B0100009
X-Stat-Signature: c4nioztxprafqotdrbjnpft7g4yuu15x
X-Rspam-User: 
X-HE-Tag: 1780370244-904635
X-HE-Meta: U2FsdGVkX18owY8+x42Vp8RrLBhUuqOS07XBxNLWgX+HxjlW+gv5fDHoUwhx9+1ZEy5W+g4cooJkbS/o1chJrElkMFx6I/iXMZREeZmff2CxPgg2nIDUBdb75JcM3RMc8rpzZkSzeKRwQKzS7B+g907q99eIuGeEQRNQ0lZyD8BIE3SN1jSrR0mf4hKab5l1eUi9x2AJ9/+X5PyDo6Av3JwmXvQY2QrweHuzI/uCODIU33q/8fARTdg9OQ6J/vYWECe6/o6htvUdJeISga7kr4NjulvN3Upgvja5x82+oPL+Z9cYTpuWDmC/w1iyjNGEHfbEpKjJ+EK1h6eK9YbgWuPn8u9lJflZdP8sGdtMUFGiujEewY+JKtWOwFPkoGwWyfei4wp+fTQfpNyo0U4IPmBOIkQJnNeu17smeXQRlae+x3Lsu+OfYzPNq5Nr6WUFD9OdPaN/LsstBP+KJmsHOtjQUOZUQE0fxeLHeDiI3ZjyCx2cHuV6iz8xPWcuCMWDcCCo6QwCftDDNPyvTbozKs2TbasMqqXTv57EPkIrRwM3Dfu7e8Y3h4X2wCNd9HEn2pNIVuvvheLTogehhpuM3rMtjnZVXeI8VwbGjnPU1SCQfPkjtWsMdVWt2VObNb+jSoJ2BSk3L8JiCI4L8ZRcYoISQi2e5bA+lDWxn6U/Jq8tRNEa/mV/u0WM7A9IePXr2SCzgaYOBuSKOsEsL034rZ0Oi/8Vc+pRAkzJyAFCi0YjM76AwurvHpxuxFsTb4GYrFACE3pGpnTN6qN3tFM2qYLffVJJN7oR04ptVGakWDhiScbSpfekZ2mbvYM4X6DG0a5ubUSE4HZ+1iOQ0/uZ+H4964/NL/yNx9cW57n9sb3l1dehh1XHcrlCTmROVe60ydkBI3u7hwcMCAVsAS7u67fphD7tU5oZaPA/YbOEyNUASe8YqO3opy0UwKGx0CCjozqPpZ5E17Rk5QzF1mF
 XUL8i22i
 RVxQEHuZIfn98vF654n++okm/P8xJaBCOVX5puIQklQsa0dOUYsiQf3tZxQLatbV8AzeFv9f45B6axw6sD7mL1fuFg4dujvb7/Fy9CIY+ZSoJbRqaih1b0fI3h9BHuCeUy4zPKFRDYcn88gxbY/CAkmrvTCpHkqI7n+qDJcF8dN/oizfj04Xb+z7y7OKkMQqBJAlr8WA2VVCndxZfmLXO7us6BD2FFNEs1nW1wWfl0kCC/IsqbtYbUtzzQw58RQnWfajYr3B2rV33Ea1cNZPfDYneoFcGed5qzWtvrr3UY2lFP7HkTEp+25kkfh/HwZBwK2YnLfGARBcDbNKjKV65sjG8opfFdKoxkdBgEyWoRcQKB7NBK7YqJz6cbw==
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


