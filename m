Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D97ECD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 03:21:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D27616B008A; Thu, 28 May 2026 23:21:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB0876B008C; Thu, 28 May 2026 23:21:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B784C6B0092; Thu, 28 May 2026 23:21:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A89D86B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 23:21:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6AB999B18D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:21:13 +0000 (UTC)
X-FDA: 84819006426.27.8AAC243
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9F32D20009
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:21:11 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=P0jrU5M5;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780024871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XlF+4nIJqGhSWvyi1zvFIxVHRsseY6Zy+d1V9eOuO1Y=;
	b=h5CEYluvc//9jlt+2LVLCMq+UuvJBl31efzyl7IQ02Hf5OC2Sw5BskOLX4NpXymPCBzC9X
	Faot4hGmBOzRbFyNTcHnZH0a3E/ftABd84dS5aqJmbpuojdIEmg49DGBZRvwPhlF5LW792
	zWfDPBNaapGYIVC7/kvO81VtRVuxwZU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=P0jrU5M5;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780024871; a=rsa-sha256;
	cv=none;
	b=0h0KOlkfcU0Eekv+U81XysMXSb8fcM5ZLddYOKIXl6qJNlzuNwLtp4tRMLuOz4zPLyZjcn
	qPHltAVdqJsbNWEFudELQTLrj4jY/vwIrrh0tA6bFhzpzAaCxklDDZDFpiTPULYovXGLSu
	jM51Sspy+GpHhFLktNDfZk2MXOYj+Yo=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8ccd1f57b32so16988196d6.2
        for <linux-mm@kvack.org>; Thu, 28 May 2026 20:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780024871; x=1780629671; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XlF+4nIJqGhSWvyi1zvFIxVHRsseY6Zy+d1V9eOuO1Y=;
        b=P0jrU5M5iuVIke8BAN797L9i6ML9wo8dB3mMJGqqwrZZ9qgEIjgCdmi6XUk6vpscmH
         oTb/yU5liy6eC8Ff7x9WMVU6tir7F92wPrxUmrQVLapSEngCRoUt26HGTvFWeJX9aeAg
         CcsnaIS23C+/LpLy1M/DY7Rip7J71BPSncEEypnQ45sHEP+mlKU+O1+5TQXP1X8KJTi1
         21RMluZBOhiSLrIDgHL0okDSKQGZW/mm8KRYqNLRjge0P7HU1Xf+jELBe5sobMszt+VE
         LhpVPZmYzeoVB4+DtftsMhUiaox2msWhqquwoE8OE0gCvpJk1SW6E2FngUvEBRp/w/a4
         UFDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780024871; x=1780629671;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XlF+4nIJqGhSWvyi1zvFIxVHRsseY6Zy+d1V9eOuO1Y=;
        b=YsES/eD+DXTGaXKCWR6lr/VMO8pZwAwcnZYLxgScmYM55wKT33sBsR8FrQnT6yJ9cF
         2FxrhGqHfqmhNqmEwT7lAH7t3WzS8pnXwfRpdKrWZCyN5fg+Y3zw/lFJDw7xhpi9aHxG
         BZFPML47HqZhr8eyBGT6t4AssvSbX+dSvYpj0nNiXQj76C579TA8XT+RB+HGO77KfH+F
         qr/2z1TvlIN2sICArGLxxD+k0ynnxAGEYfn8X2F4KW4OjlidPXZRdFDwY7MnM0SlX40H
         e7xWgmh5q8m8V3Yne59H2D/+GO5vC8o9p6ZwB9Kgv6LjKxa58cDRyn0DvlmYHRWyEnAF
         HuCg==
X-Forwarded-Encrypted: i=1; AFNElJ8GV57gVJdORxDwx4MK5VRRjVjW4MLVr7gqrh0LM3SagxobWMthRP4Dr3QXDwW3AZzdEywRDOgS1A==@kvack.org
X-Gm-Message-State: AOJu0YxkGwRXZiS6RGsqbWZCP/rLbICFLhY4yEWtoSI/zA2PPrZUc3cv
	CWj7wN2RTMSC6qygSKG/lHghnAdQCTHchPk5ZtdlW54Ueobl42p1hxM1AZVIxWgVKLtiKf1FtrG
	oni3f
X-Gm-Gg: Acq92OEKEY0VFKyc198sa2UAgPnj4vBrpvZ7ADJ5PXB0PzOLWQ7ikRBEd9BseCBe428
	MYV5Cb4TwLL4wlAjTPcm+PjYKhy717cej9+HESQTN+EHjxw2GEaDRldT+FAWzp2O0s53SHAIaCw
	EXJEroo9BAVfVh8l6KHBxQz5J01URocFf1J/WnBUhxiWvaDts0tahFXphdWOxrBc6p0Ny65YX14
	mAiNnxHf1yA4Ipqmib861zxpvfTZCubcRuXl0HE1CkvPuuJp5MTHESuRtUjF5WQW7DUsTqOhtNw
	iDmwrJqCkHqNeDPInNHwgdaqk5ScRDjHMd+ROHVdHeegh1OxwAvzgLuzJ3rzc7gFf61wdnXIUgt
	wpZJppfrAdwR+YWmq02GXdpkkmbJTPH4bRGmdMHJs9hYbpzIdZFE7xUce2c3e8EedG6ANG5sxKf
	IkbKL23UdWHF8TAE1NynPPfRccfIgXePEKe3NOLmWris5xzquRFNcLJ37LS/LL5g==
X-Received: by 2002:a05:6214:528d:b0:8cc:6c08:552f with SMTP id 6a1803df08f44-8cce7b6873fmr12860586d6.9.1780024870731;
        Thu, 28 May 2026 20:21:10 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ccea26d286sm1179476d6.48.2026.05.28.20.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 20:21:10 -0700 (PDT)
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
Subject: [PATCH v3 02/11] liveupdate: register luo_ser as KHO subtree
Date: Fri, 29 May 2026 03:20:57 +0000
Message-ID: <20260529032106.1505796-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260529032106.1505796-1-pasha.tatashin@soleen.com>
References: <20260529032106.1505796-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zp4sqkzjjjxfwsey34iyghr49df9zxwj
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9F32D20009
X-Rspam-User: 
X-HE-Tag: 1780024871-222272
X-HE-Meta: U2FsdGVkX19bNpe13tEU0AlCrgD9IEe/bp82M+dtCM5gYIHnM4vqbQRcf1cXj5lCsfJY35YS82y91IoeMZEPsYHeOrbK3lpzZbqVUB+uw8WbwrRCRbOQwGxTQby9y8PEoHNqayF/xlJBwLNcCHotBS5lO28SSnoX7B84jgZXMIOjbDDiqLZHDhWvEHXTn1FXK57g9MsC4RRpNwyTTSmzGDlw+FwZUgcYLCVk3dQX5Px8tPJnfSaAd1w/1WYp/9K1xqAm4c8taLxzms5UkMxjtwppgObW/uL7G1Ly6Shfx+YaSMq1zG+8sr5LCTRR5j+PVcmIafsIFsrtUtb1s3cSRv+TFmeP4SBGEMGeyvljy9V5YIUXQPH0dE1nXP/7RpPk/hs3eYa/hPHunTdci9d5ZNdJHQLFMWhjVvGVT4Ci7bLgAr7fZbb/n8RM87XJRZ9roG87TzTMamuEhHwBZquGQmqKfYykHQW7ljvAH+H0dRa4gHNWveaj/dZoseQMPlmGECnTTMIxM/NowR5QkH3uVHg4XqZ8ud0DlmfB0SYOMkUBPpLnCZ/rHupP5XWFwQB2xJCF+NOW2Xns/AVgazATWZR691Y8ToizVW1wO0w2Ei3oovZGgVNrp0AEdMOviqQA5T+PX+cRoNfY5Os1FgqpYKq+MosOdL3dORtUtFS9PMCoNj3NiOD9ZW6B1oE9mNsIL14JL2gc3TJI/pRRS8QbemJvyaxUQBsSylbgi2p/x1dEqiURzppi2NaN6Ozur+OtpS+jGq1ELlaqm10o99uS2xgvgxR1wLlpsEzwr4jmAC76zG7tcPX6Py+eSu8X1nhrB0lgAJ4qGnLZK59mRDVV+DoVvrMthtUY6hyRw8EUk2w1nybkUPsQXGbH8fLc1wBo0sf1L99zk2tHg2hfGznDS3EtgjVfGuzGkaoeYeqsQcpZuv6fqsIcsnPkxtVzrCIf5hIjOCYquXrvwcDgmUw
 PVLnMpDR
 MKl9eGKAYIi75FE/CUMVaYM8KPZ3rXWjryXNX4k3IZ2KvxXrDWk6JsDsEI0UmIUlS9ukHVL3Vu5Voe/VevPanzdpzPwUBbCkjjUINhtinOAWzd88RNhRWyghK4kSiL6gdXfVWXM6iNPfjBKiO6I1Ig3/MwxhVkhZmLWK7YZe9iIYV9lKHr21x3aF510pLFlSgHqZF1P91GDfFOec2mOpm5EnAd3m2brEl9EhTV20sl9APgTgBHXmea6h1uDVasFtyer5bBQTNrko5jFVg9v2TxOhhJurBHL5fuaCmAMpBXDKYLm1UxhHl9tvn34epNORW8hV4woHumxCyJBvptx56aTfWhp2+H9urhQ9s8371Kq+k8TmTxrq9PhUWhQ==
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
index c1c290aefc76..5e12c8f8669b 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -50,7 +50,6 @@
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/luo.h>
 #include <linux/kobject.h>
-#include <linux/libfdt.h>
 #include <linux/liveupdate.h>
 #include <linux/miscdevice.h>
 #include <linux/mm.h>
@@ -63,8 +62,7 @@
 
 static struct {
 	bool enabled;
-	void *fdt_out;
-	void *fdt_in;
+	struct luo_ser *luo_ser_out;
 	u64 liveupdate_num;
 } luo_global;
 
@@ -81,11 +79,10 @@ early_param("liveupdate", early_liveupdate_param);
 
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
@@ -94,40 +91,29 @@ static int __init luo_early_startup(void)
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
@@ -156,37 +142,20 @@ static int __init liveupdate_early_init(void)
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
@@ -196,21 +165,17 @@ static int __init luo_fdt_setup(void)
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
@@ -226,7 +191,7 @@ static int __init luo_late_startup(void)
 	if (!liveupdate_enabled())
 		return 0;
 
-	err = luo_fdt_setup();
+	err = luo_state_setup();
 	if (err)
 		luo_global.enabled = false;
 
-- 
2.53.0


