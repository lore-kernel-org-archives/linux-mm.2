Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A07D4CD6E54
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 22:19:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1419F6B00B2; Sat, 30 May 2026 18:19:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CC7B6B00B3; Sat, 30 May 2026 18:19:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EADCE6B00B4; Sat, 30 May 2026 18:19:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D4DD56B00B2
	for <linux-mm@kvack.org>; Sat, 30 May 2026 18:19:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 716278DB53
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:19:54 +0000 (UTC)
X-FDA: 84825504708.19.173AAC9
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id AA55CC0009
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:19:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="J1L/57GG";
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780179592; a=rsa-sha256;
	cv=none;
	b=YsoDEvfSat3LyLJ2sHJjykEO4omGQjb5W8I5H7oEV4tKtXBdKYLZoi2P7EhHNV6c4h8NUv
	wx/N0S0u0mJ7ebcxtKoKDB4Z+xwNM0l8ZHta9DQgi/X1gyM6TLur3HTKwkmi/ByYB6gdu1
	Fl4fbf3q47Ux+3VFjVh9WAdskxoElMY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="J1L/57GG";
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780179592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZQTZtc/bGyoFmxW6tJMa2O74TD8r2del+d8HujN8mY=;
	b=623FEWeEG/rwU7meNKAzVMeBuY81qq/jXESrDBKIHlH51yNP3z2Sv6p2S7IeVjXc0Je8Oz
	MZ/rrdKDQuVtgnL4HarEiKNkSZZEEDR9QglRnZsDuIph8UElfFxdlVYr5gk9GXAZH173Ti
	DWsqIxoPVsIc3Gw8oMIFO8/+/qiRQaw=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-914b03e42b2so1100157685a.0
        for <linux-mm@kvack.org>; Sat, 30 May 2026 15:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780179592; x=1780784392; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XZQTZtc/bGyoFmxW6tJMa2O74TD8r2del+d8HujN8mY=;
        b=J1L/57GGbGUJtqxIa39HdvKif7t/qw8+Iwd3ZCjULax35RMHFFQPBP/SJkvi9x1WBx
         BSNbXujhFWh952RwZPxKK8aRbO7JdHOrqhlrT2QJ0HBCCx5CuxNmoe6quKVydmEPqLos
         xrsglmmk9iYHATKFAPkiyHuuOzRv8/iXxAEvXQJSelPhFc0HY2IxpMvGyqG6vNGhOVBt
         h1/1t2JBajFoa0gPRj98uz6ZJ6w0RGd+aFTrmxmbJU6ffq0DStEZmf5fyqNyiDJQrFkm
         A6JkQp2cJHquW3zOfLmudyzt0N8VaU1QqYW/Vc+3m0ZwGxrjB7Q60nFyqHpJZYtOVbJe
         bMMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780179592; x=1780784392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=XZQTZtc/bGyoFmxW6tJMa2O74TD8r2del+d8HujN8mY=;
        b=QbUa5JMRRR/2/+pCm0fDNcW74s7kGiy58sMeH1AqXhQ0oXpWIVwTzB4Z3ymCCfbKOW
         m4KKndvU5oveNufLzHIlM7JblDUx0IT/xkbyJ7TcOV4bSOAIUGBMEsW+KjvlS0UvbtiX
         FUlI94Y3YVnXQ+TPhgHC3/Sqs2I1fUL52x7BUz27YEJFXyNrGahuuMuvqbIfER80InTH
         /g1TwVSh+HLXzGWLI8ifNnvQ8qBuv3b3SNJ+SJoTsVRktDQH7K82hMHUxfM8J/Xu5mcQ
         ygUebCzPuMwqMAOFMuptCcKqDXsvoPNs1zA67xh3sMKBS32qyfUolWtO8LwZCS1wwxon
         Mr1Q==
X-Forwarded-Encrypted: i=1; AFNElJ9Nl7YyCdOSgqazbZmB5VjF2Y2ZwssHTcaOoVdqW0H0F3KcoDBL4X/2TwVdSSCxL6QXauNRrqrJHw==@kvack.org
X-Gm-Message-State: AOJu0YzUF4b24XDTOUU14idZU0LWYLMOizQQR6h/vaz7Z6Yuipa8kPFO
	8k71ykYHXfPv4ZVyNTjQQs4r+1KYxajipLemootQ9azVIavAjnQiXMoS1uAgMItQoWk=
X-Gm-Gg: Acq92OE0ROKuQ9PhZIQEilj6JFxQnRecN/IsUBmET0FTHATWj8lkdGTY+5+ulU5JVhY
	2jIYt7UwKBvJqHeNwYY7uQe46tbqUKFLuZB0jBA/GBQuSRI7d61RsVAfpBTczC24vrYTRve4A+O
	J/cRIBj/+pastn0Eo+YLuOjL62JTPa4xPGx47Y/RPfjPaI20eI6cqQVLwGyKiKnokH58046KkwV
	1/DrMosvxkW52mXLGh8FZUKYWOqFMU0+0/l0EhRs8V2YBaG5CHZBtE1NBZsFQYBG2pAcVQy6YP/
	IJoLR6vMfJZn1BsPfOZGS1ncuC51Yw9QIZrTJxL5B7xbHjQPVVFsrcDfJ9XO+Eun5PpmpWI0Fhv
	ZFX09SKvnL8H7U3oGbNSNfz2Nqt5XbQnmOqVcZdsX+Ky1K52qkbuOKM/TbZfbVwpd4b8km7Y9E5
	Mq7rzPV66oo14csbL0SJ55KRsvrUuzv3+YG0vDcN8o83kml0M8oKxNPvx7lfYYcw==
X-Received: by 2002:a05:620a:4549:b0:914:b9a2:f280 with SMTP id af79cd13be357-9153da34967mr740573085a.36.1780179591610;
        Sat, 30 May 2026 15:19:51 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-915324868a0sm651790085a.18.2026.05.30.15.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2026 15:19:51 -0700 (PDT)
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
Subject: [PATCH v4 04/13] liveupdate: register luo_ser as KHO subtree
Date: Sat, 30 May 2026 22:19:29 +0000
Message-ID: <20260530221938.115978-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530221938.115978-1-pasha.tatashin@soleen.com>
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AA55CC0009
X-Stat-Signature: 85nmwurkbxdx4sczczp66dqcwqmgx33a
X-HE-Tag: 1780179592-865681
X-HE-Meta: U2FsdGVkX1+NVoKLNLQ8QEYsk8503f3ZADKd3x5FXI4Z0IUzXMBUGoTmELmnbgcZBVkWb3s3Wn4OxeBSGq7YhtVtvnvyiUMLoE0+swNcg8nm1gNA0+wU2UVQHD+IKe3KDTnZ2v1WrSBo0955x0/mUKn5UjhUe3XcU/zyJTP9kHNrvBEp4CdF2aWCtGv587Bik0Y4uqIjMYSPIUAKm8VtfXdmYgUHKz6HG3O2FyVNJWWgu6zzT+Gltv/uzdOYbYe1OA4aj27D26xvZArM+XC1Al0eLDP1baxjPIVb70ARG68scF8/2Zu+3GetUI/J7SkQeMV48sIfVuDwU8hJjY+JKPHmmej1CKsjgFtG7CsSm6OivYLNy7120Pvq1gxBf1Q9bx1JG17PCDDbKwA6wNxWGvkVPMG2NwCa1PB+TzuKrr4dQ0vVHiaOUp6x+RMhcVDnz3WDECETEZxjEMKb4RCoYqIz1fxqS/OOET+pOkiFl3Jwp8HepQY3MgbNjWSramfd9uzGmvBuN6keFwUQ+FfHw1EkzNmGP+sQqbI5CxN3xZIOdJCNppn5LobFySk+dQV5HhUtGRohjX4IvVhQrVQVDoMuawEmQ4HuBJ64xEXiXEE7Vz4khz8s3qtobaOA3xgenQA8O4/xLbxvHRVWPGmeccGbUOtwQqKUmVOeiXCQzAcvD1h7CdK94R1cjd1Hqc8+OWtW4lRu1LHRMv3qvvu4fpq8NRlrVQJx7c75nytAGEWvZTkXfzgIV/nGAQSNClRRE5nut+YHEGl0PIEv7bK8zP/erSzdZSC8J6ND9K1xl6NVud/jUOfpD3GepfXZJGbAzXSC+UGq0Lwfe+WfyXLb/5ukDKnFy+AcXDLPmwnirq/5yyZliFFDm/93BesP1pRJHcfg5LPA5h8MjRL+eW6IbL+YQh+69lAe32l2/xLM4ra1Ot07B3LEYYJ3fhNxOGqZdGfTjETqkiPoTX5HOqm
 R4SXkKfD
 bpLgb9kD1qiuPi5CQ7jpBK0hmpdB3OXzhs+xXsrcWJTjZhg6t0u+ZXaDweLKUVECSN+EEX2kg4RFSLZ0VmUDNgeUJp5zcEvJWymS2cVJolzP7fmpDQci9DaQ425VJKmIQeP1FsDrpnfDsA81F1hkAbuk/eYL5IiJ0pBqvv47ohvjXVN+Ra1dRuMzAFUiwuIq3G6MafC4gLH60X1zCrnUquHkNphUAGmIQeBdk2L5QE7Ba0xYaIWtVaZB134xb20hpe3iTJ1xp+eCOkWKA2ggPZdxK0DIN/gs5vmqvQr/Z/PR1HRWuev68zRLWzTLTqfCJG+joPCgKXHoZ1zDLoQE8MpD73M2uIJt0fvP7FIe5Q76XLST5bg37dciJ4w==
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
index fbc18c5f4230..e261a03a1b47 100644
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
@@ -160,37 +146,20 @@ static int __init liveupdate_early_init(void)
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
@@ -200,21 +169,17 @@ static int __init luo_fdt_setup(void)
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
@@ -230,7 +195,7 @@ static int __init luo_late_startup(void)
 	if (!liveupdate_enabled())
 		return 0;
 
-	err = luo_fdt_setup();
+	err = luo_state_setup();
 	if (err)
 		luo_global.enabled = false;
 
-- 
2.53.0


