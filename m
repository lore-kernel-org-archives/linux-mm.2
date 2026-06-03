Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19E1CCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 15:44:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8497B6B00A7; Wed,  3 Jun 2026 11:44:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F9EF6B00A8; Wed,  3 Jun 2026 11:44:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C2976B00A9; Wed,  3 Jun 2026 11:44:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5842F6B00A7
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:44:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 28A1AA03FA
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:44:54 +0000 (UTC)
X-FDA: 84839024508.09.BB671EB
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4898D180006
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:44:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ez+d1ZSd;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780501492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ysXJwhFF5ZMhelrNqugrHKhMpfhNNGitYhajZTivsf4=;
	b=f+BM446aBOx1paoPxNPdFnh5FY7/mpTWv9tAD4jLjWu7c//OTa4mD1M30iLEDlwgugZdYZ
	gDc/cFkyESQvOHB3ixbomtVQZzygZt3GIaMTkq5N6pXUfw66wtgzGYxiAZc+7G/lQGYZ1K
	sku+dTQtKo07y6bEFRfIkPO4VF1jWWE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780501492;
	b=IVdrGBCBgfHikuDEYCT/A8bGWptbwLCJLsEHfpnEEPRgLj3p/YpKA0rCcu6FgT1g9HKn3m
	Zq961EBDtoeuTMgLkMXLjFu7pv3pKWOJ5filptYeckNDYJL6D+VsIXYjVW8uR8EeSdN7og
	9/uCrjsOPNj7Fdu52ZeMNQ5UC9FOyL4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=ez+d1ZSd;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8ccf6a63a45so54931416d6.3
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 08:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780501491; x=1781106291; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ysXJwhFF5ZMhelrNqugrHKhMpfhNNGitYhajZTivsf4=;
        b=ez+d1ZSd61Ry5njq7WvB4pFo6hg9k0ypp50fG1/btoIBwUgOHQC9AQ7g+pndTcKWzz
         nIeOnJiMbF6LqFMlhyjpaRS7r7So1ZjvFl255dkc3mMCb10T8VgzVo5cfRG1ziuyzopA
         v6qLasAOhNasxxBQPWmNw9BeuLWNVPLlpAMhddD0kO5Gx74WQ9v8pjFir6MAjwghf57L
         YUyJr8z6fQ/lg800lyGeUuz0y8eCqWlQY0vMSpDh6Kao3cuwg0VDUtNwRME/15g7pSyH
         AG7ZyioulIqKZNt1hGjbGnst9DVCx5L8QM3GSGcorOj/ZjmlJzI2J6XA/WmbuDLhx/RP
         etbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780501491; x=1781106291;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ysXJwhFF5ZMhelrNqugrHKhMpfhNNGitYhajZTivsf4=;
        b=F6w/f9hfJE1OYkLIkMpk3VPwgUKjHj7lTdCcvZHpjHsk1hOZ2T6Ccbb3bPIt8aGipB
         cv/vZehjzliEysOoeEczxt6RxkGy1O2yUonaWVPBYbQ6vMb9IaE9+451hUWuwZLOQh3O
         c6Yg7bNNKA+eJ5+pgDxtFfrS+s1FcjEJ54hMi/y0t5oOgeCsIJIDTv3XM8ONdVtl7dHt
         ILayH6Xd2oLk6UytjkvQX0fQN6fdFEQqLUlTFdim2qYZM+AL0NOAozgO+o2YTyPqmmcz
         XO8KLX+LW3nv7Uqg8WMd7HLmCBm+O5cufTrIoQSSgRZ7ntakch3mp11zy6st6zz8mjh/
         Cq9A==
X-Forwarded-Encrypted: i=1; AFNElJ+rA7CE3W8GxgnNuNL3hQI0I8mOAp2/FIFMxQhCiIMdqLAOn5/0GLb4NUJn98Mz+xn6GY6OfF7law==@kvack.org
X-Gm-Message-State: AOJu0YzW8sGQe7WGxy2yYBToP2uW7lGYFqz4STBf6Sg5x6iRTCERJQcx
	7q56U6h7/uo4NJNvkILjLk9BJls/5AhHANxkMNo50tJda1WwgY961N5YzLI6BGWpCyw=
X-Gm-Gg: Acq92OG3t215DRCo+T0YSJ0Q9MLy0JcSO9eZPoVr4KassASeW/04oXRINfAGCl9vKk2
	yivUngU7fT27CpN/NEBC6KINWAsU+2oI/Zhozmu97lj38kbLuWR500zfLoiqcJ64kHsouYtqllC
	9g7Qmu9w1by4ywc2Kf3kwHcVNn/9C/N3vAo19PO8vPdTIkqAJ7iNR+OCQjhbpRBwYWbhh16WhBK
	tD2fcRS3zCq2F9z3+Ob6dM+Yx316ShbXKJ6qvOTRHn6bDgvIcslt8O+I4uklkW7Qa3ANaD2hJsx
	7c4BZqX4ceSPjZrMotvpA43UO6c+4jKs3Q8TobZB2pdqQP6vxd9NDI68XZe4UpC4xm/37sngYLF
	L0OC0V3hl2lK4S3Bh7w25cDZ1DnoPLsu6dbdTjI4tSEIAmyo5dyRMROtxef3ay4YiMyyCqXWRIs
	6ef7uAS/KBnyA5SUcMY5RKJP8+Vmt50Ng7txePjldB8q2QyCGCr7CGNckUvyHvJfQ8oF0ZhYRI
X-Received: by 2002:a05:6214:40a:b0:8ce:cda0:4c69 with SMTP id 6a1803df08f44-8cecdca714bmr61767996d6.27.1780501491307;
        Wed, 03 Jun 2026 08:44:51 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd07629dsm23188206d6.39.2026.06.03.08.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 08:44:50 -0700 (PDT)
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
Subject: [PATCH v7 04/13] liveupdate: register luo_ser as KHO subtree
Date: Wed,  3 Jun 2026 15:43:53 +0000
Message-ID: <20260603154402.468928-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603154402.468928-1-pasha.tatashin@soleen.com>
References: <20260603154402.468928-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4898D180006
X-Rspam-User: 
X-Stat-Signature: agea67x6k6y9e84dy7nr9kdnpdo98wmb
X-Rspamd-Server: rspam08
X-HE-Tag: 1780501492-710429
X-HE-Meta: U2FsdGVkX1+Eo3gAhkxkRqxu/LeyewebMuKVCc+VVRWTdX7aVeb8o2XSh+N576dU5rc9MTutX9D75ydbOlQULRB+wixPssEL7FFVSWWS/sXDS7RZt4Y0PiMzbEe8MFYexfk9ieUfp0FCPGysyrcvI8x17KR9yRWzQ4BToE18YjlgmGqe3NsSZtF/X0O08e17AA5M8ypgWFlFVbyl5p1sp0uh4E2oV9iZ1l4ScuXk+715XYYhLLNYSfCkuJ5XENUw38peU+21qcPqhL0VdUXyY6RD1tjAg45NuS2kAQyTxawEmuezHEDiy39kpzO/wpdn17do8cE52viZWuHS+OAa7VjJdv8T3IgSRc1/JwDMjHrDSoo4paEy6ob1u0apLU0DJgTeEwPLyI4Nu4FxI6TPZD0PKZXVeUDk/efTMwpN6Bs36C//ElMSRjs8sdIykJTowrdHmBYbblA4dOwQkFdG1kz0AdBkXpQiuivq2jQSeqetI3TpG6Xp1dcOotKvXiyZ5HVbfjC/bNboUEyBjNKZc/Z41f/kU4xPzxtiZOJBNePNUe4mNkZft5Mxcd7qtGPBFuFt9jTv14A89f+CxuKVjTgkxPRju23Mboj2/O28H/KsUy+D26dwXJvdxjyhT/K8D0LXqa+mLpTNOjNGLVGuT+81tKYxQpU0nVpMdZ0gOkf/cySrAZmdkhSyG8xqX7XmiNlNKgMPUWsZxdU4ePOhGzoNys5kz5dH/pH1nu3hW0tW/DCal8q9xhFmbOlPFlxotHu2r/Z8y17dC/vNkWxXv2sj1KXjjMJLRYh6vKQhQmm6r+weg/TOvWZo0OEm8WcJ6FJX8brVDPGrIlIPxijEO9aKWpbtEP0BKDpa00Fnat4uzmshnwq+YmCA0OFOhO3chLGVVXJ2KchTF+yXwk1O23AEqXOtaOQrcmEBKp8NTIgeihCBAUNJiY9ylKrUUsJXavFe/rki7lVs6YgNKXG
 LR3Ic26e
 PvzwlRj69WkbCF9aO73HjQGn9isPdiUesSdnam2p0cqVAE9KCJEqmJfc43jaYYk5KP2E8rjztVUYTh85LG9Sw9C54JHftAiB9BRBktUXifGQIaTrlS/9FbDD6uRhUYfzQe9SxBowKZgGb26rkzZKIp7aQ2RqVvhznwou+juLKPRJbH0ApnbYiOd0YGFli7EeTY/yjWtdQFzZfP9lNROV89I3Tw80IS/6guIZUSLORx5lnR1PdbA4NWtu9YH59lSns+T9vN+fq0MO2bPRoRY0B/kRlOCjxMWqxplsi9A0USRtbB8p1Hc3nFKyHL4yOtooE8qsAmZG0KptQb3gfa+f8M8glVfEjA1SMflCWYbqNF12b6+piSS9N3oCJR7w2O0mTDEs2Xlsw4vVq7xkQq8QBXpRR5w==
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

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
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


