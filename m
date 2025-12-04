Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93E55D2A551
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 22:10:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF51D6B0024; Thu,  4 Dec 2025 17:10:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCD4C6B0026; Thu,  4 Dec 2025 17:10:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D09DC6B0028; Thu,  4 Dec 2025 17:10:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF9FE6B0024
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 17:10:03 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 35ADA50449
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 22:10:03 +0000 (UTC)
X-FDA: 84183182286.19.4B0DA8C
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6A474140014
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 22:10:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MZ82etb6;
	spf=pass (imf26.hostedemail.com: domain of 3uAYyaQYKCN0RTQDMAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--surenb.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3uAYyaQYKCN0RTQDMAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764886201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=54oIStPr/s4vJcJKPPdjRiweYi2k8HSZohU+IbZP+5k=;
	b=xKE3Joh9MwPdHdgq9YqS+JkKCJdheiKj1CZtrta8iVCQsmD9rAT2C39auBsSIomkJYmrBK
	bp7MmhG++fa51KR+Ge+WoFVIVCG+Px+z43QOr+OQ+QRy8MCr0t4QENo39iKPLCY8Vqec1Z
	4OheNmQHm8A5ZeF7obaviuVMXaIWbdo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MZ82etb6;
	spf=pass (imf26.hostedemail.com: domain of 3uAYyaQYKCN0RTQDMAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--surenb.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3uAYyaQYKCN0RTQDMAFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764886201; a=rsa-sha256;
	cv=none;
	b=m+dcpNJMEIbgEc1qNd8gA5ID8nH4Fot+HQURkeF55/ZmT43eUu5pU1RzJdP1dm5Sph5G3t
	WP3qVSyYXejuxOnW+kdBu2OGVxXduYr+nCyJqSA9a3W8AKtggm4oD8T5ElRm++CII5qIkn
	ACjr94hHNh1dYteZTSvWt90zEhc9PPU=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-ba4c6ac8406so1195564a12.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 14:10:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764886200; x=1765491000; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=54oIStPr/s4vJcJKPPdjRiweYi2k8HSZohU+IbZP+5k=;
        b=MZ82etb6JzEnvZo4jauVBADNZ06Mci9vrN6C2nysSqLd6Zjv/fT78cHqfFltbU/dKJ
         7xK28qQf1bjqBZV5ibHilkQLlMeCNT9PWxjD17sMEMhTCUIHpctvP4WfzhSqjr3laCpZ
         iCrpSKfjWUM5IlM4xDgFfglVJaa2SZ+x33z7F+x2PKrqLYzeOhbIPnua3fGlubQXfab1
         tgBAQYVcNqlLGUI2Z0TfehFivyJYftQGgjIOmXMg6bbLKcLw5epfSqeOkiRlM+RPdikR
         XwHbfARZQY7MsqmtmNkhDsxzOsutAEvMGbbyefve3qfv/FiXyedNzrJYleFpWhbA7eo3
         Jpww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764886200; x=1765491000;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=54oIStPr/s4vJcJKPPdjRiweYi2k8HSZohU+IbZP+5k=;
        b=C8eDbo4DLZq7iJn/egqPvO5sU43upWxVAtq7v6CJdxJn+MBygmmR0rsa4t6puz0tQ/
         FdfJGPovRM4MFgd67RARicshCeq7Fi6KTCi1CSQmGb3QWEr4xAn0DQ8ei8QNTpugg2GS
         XSwNApNkWbqDI4zs70syxvTuOrKF0H6aVbu8uKhHeSf3NnVpEcZwe+0KthyayGfQzGVi
         ocDH68ril3/QDYwkefCZKwQXP2u1p9+fkpOWiMQyFLOvHuoGkwHNcjV6q3zRXjY6riDL
         gKRP8yNq+R25JvBouTN6vlCtXZlK3nZH6ns1fhcm2XaH0pBsY8iSykOPj2/IxjSrMW33
         ROTg==
X-Forwarded-Encrypted: i=1; AJvYcCUGs7SSdlZmaGf93DPDEp7D2qEr7ZxkK9dYoSSdiBet3a+9ybTKQRaoxTZIgCwNEnk1TBAryMd5fA==@kvack.org
X-Gm-Message-State: AOJu0YwpjJWYT2KSGm28/FwlsvrgE4+A5RH5H1Q1jWDAiiLKs8DzgOAY
	/YOL2lkvDkmxz2c7SG+Y5TfATfUts14qWLzxYwUZ/AOUmJmfBe8ut2za1VBUhJLm6QvfVmI2eFC
	OQV7BGw==
X-Google-Smtp-Source: AGHT+IHLhrKsU7MdJp99+KvZZ/xCoXmF9qcszyx5DJq3SSgN+PpZivt51xKlhmqSsW0XWVKbU/tASHuysvs=
X-Received: from dynm33.prod.google.com ([2002:a05:7300:2aa1:b0:2a4:664f:e91d])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7301:4d10:b0:2a4:3593:ddf2
 with SMTP id 5a478bee46e88-2ab92e671a4mr4465065eec.31.1764886200002; Thu, 04
 Dec 2025 14:10:00 -0800 (PST)
Date: Thu,  4 Dec 2025 14:09:56 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251204220957.360838-1-surenb@google.com>
Subject: [PATCH 1/1] alloc_tag: skip rcu barrier on module unload if profiling
 was not enabled
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, vbabka@suse.cz, harry.yoo@oracle.com, 
	da.gomez@kernel.org, jonathanh@nvidia.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 6A474140014
X-Rspamd-Server: rspam02
X-Stat-Signature: w6nrrbi4grd75g6swsqc7ahzjutn3dtc
X-Rspam-User: 
X-HE-Tag: 1764886201-575755
X-HE-Meta: U2FsdGVkX18u5xgSFNfJ9Zuv15HvTPoq7qyrsk6zIHuWYAGx4v3LWq/+/7ClS7Zz8Fxgxk97ctiPD7XvqYEyVUURPRoYz8iRjjuLbRLlApnRzFsOCZ9CjWfjiy6jILagl8SExELi0u/yUPuPk8i49RLaZE+3+EFx/c4IJLXIe5dEXVwldmbET6fd36uNWumNBGDoo2Y4E+ndhs7i0NKk4F4pnHHgqvzzqxk5QPcFdOZlLbaUT4cUv4M1RgumZHMNIrJK+eRfkJ8fdRZCnA+63bkUkUjZ5fXQwPj00obT8LdN6fUk/sZFM9JaBcIq28/LcEbG1ERng1nYFALzR35O8B8+QuaUIPm9ciDvyJZjcK6C1bitoiv8Two/vHVmktP3zL5VHbYNvdOqCLOomT4E2VB5m2idivrpJGfIQAcFFk8Iby3GAca4yphaeMI8KfpL3ICm1jtTEztExp9UIBKh1HVW8P5VbcFUO+cDUwxw0S3cYKlzkd39nnY/OFlWunfCcuvZt59VLkVDLr/mQlhrrYATg0LuN6uxZPpAYMa9La1pxdK0q1Jd+zDIrGQXiMS2My6Q/et8ByIedYq6jRIDuau0ou5Yb0CuX0B0XpggQHLtXAkHrZjxUBSDuj9vXL4U6KOXl1ESKwxaOWHgHXorcT6AJtxcoXrFKAleiBNnfpu3XE+Ka1fcJJo6laUKC1vL0R9IqxtPSn6E5SdGg0Y1sLfRSqmJzQd5Iqs41a8MB3M9OSWbgl3KB19w8QggMG7C4KUrkgegpDAFiP2+zD+ttqH296WDtcfKHHs8FJQ4DZyIr7f8ewyS9nu7Sl+hZP5Rus8NFLxsa/C4MjHOYge+DFUJV+wq750hCQvSnbkBlJz+5ARISiwLtxoHJJsz7+79hZCfSyxsOr/zw1U76toiu3Z3F8oyjZlcVq93LWwBN5yuwv0xa7CjlydlVE5fbzpFZR0EG37FkSmZqp3TXA4
 oXIsNman
 KvypyowBAhLXkQw2B3srmJ3hxkmcKQwFQK+i80S+71LQSNSECqZPl8gCCeezRxFHFZG+rDMWqyF5v3opmPCTWDdqs9plqwyyd8b9m7mtoMEYmXfwyAjMDkYHVs5J5LRCXYqX+fhU39FFQnAkqTaFMNQmXrHKDxu7oJFqTfP+q/xlIbUWyVeALKkYbx868KvUZdEF0rn9Rem35jd3MQI7HEqJH23tCMc++LuSJEizWNU/UGmqm/SLZpnWoZ2RPfhLu2Og6cI7qoikPpschq0SmZwyn+ZpTOZ2MgdLPX8rBdbWtdQfyln7vPrWn5f8+12tGJwTXxgxHmhxsAB8KjceYclK7c6wTwPxxXjRKPfGgf9TQCr6N4gNeAYW9YRODWEGCVl+1NZTG8sGOBijq9jZ9f3xFZkdJs3B4k9x6eAZ9EQ8i4W0ZsQh4bdfsi5T9twz9ohcmpLbL5vXadNnfClsYws68tdR0Ycqtw4vBK8ArVUIeAM6wotBsY2cOPfIbZZRLEmspxl4T5MURx8Cfl6JmTgo1SiHq37sEipi0LmJ96WO0vC3x1AqVPd5znUbaayVs0vPg1ofZwncj7oHGtOaZyiUPfA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

RCU barrier in the module unload path is needed to ensure all kfree_rcu
operations which modify tag counters are complete before we free the tags.
However this is not necessary if memory allocation profiling was never
enabled on the system. Introduce a sticky flag that records whether memory
profiling was ever enabled and make the RCU barrier conditional.

Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
Applies over mm-new

 include/linux/codetag.h |  2 ++
 lib/alloc_tag.c         | 11 ++++++++++-
 lib/codetag.c           | 14 ++++++++++++--
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/include/linux/codetag.h b/include/linux/codetag.h
index 8ea2a5f7c98a..8a07a83cabdd 100644
--- a/include/linux/codetag.h
+++ b/include/linux/codetag.h
@@ -95,6 +95,7 @@ void codetag_free_module_sections(struct module *mod);
 void codetag_module_replaced(struct module *mod, struct module *new_mod);
 int codetag_load_module(struct module *mod);
 void codetag_unload_module(struct module *mod);
+void codetag_flush_rcu_on_module_unload(void);
 
 #else /* defined(CONFIG_CODE_TAGGING) && defined(CONFIG_MODULES) */
 
@@ -109,6 +110,7 @@ static inline void codetag_free_module_sections(struct module *mod) {}
 static inline void codetag_module_replaced(struct module *mod, struct module *new_mod) {}
 static inline int codetag_load_module(struct module *mod) { return 0; }
 static inline void codetag_unload_module(struct module *mod) {}
+static inline void codetag_flush_rcu_on_module_unload(void) {}
 
 #endif /* defined(CONFIG_CODE_TAGGING) && defined(CONFIG_MODULES) */
 
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index 27fee57a5c91..173eebfacb1e 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -776,10 +776,16 @@ EXPORT_SYMBOL(page_alloc_tagging_ops);
 static int proc_mem_profiling_handler(const struct ctl_table *table, int write,
 				      void *buffer, size_t *lenp, loff_t *ppos)
 {
+	int ret;
+
 	if (!mem_profiling_support && write)
 		return -EINVAL;
 
-	return proc_do_static_key(table, write, buffer, lenp, ppos);
+	ret = proc_do_static_key(table, write, buffer, lenp, ppos);
+	if (!ret && write && mem_alloc_profiling_enabled())
+		codetag_flush_rcu_on_module_unload();
+
+	return ret;
 }
 
 
@@ -829,6 +835,9 @@ static int __init alloc_tag_init(void)
 		return 0;
 	}
 
+	if (mem_alloc_profiling_enabled())
+		codetag_flush_rcu_on_module_unload();
+
 	if (!proc_create_seq_private(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_seq_op,
 				     sizeof(struct allocinfo_private), NULL)) {
 		pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NAME);
diff --git a/lib/codetag.c b/lib/codetag.c
index 545911cebd25..ed6d6425b62a 100644
--- a/lib/codetag.c
+++ b/lib/codetag.c
@@ -34,6 +34,7 @@ struct codetag_module {
 
 static DEFINE_MUTEX(codetag_lock);
 static LIST_HEAD(codetag_types);
+static bool flush_rcu_on_module_unload;
 
 void codetag_lock_module_list(struct codetag_type *cttype, bool lock)
 {
@@ -335,6 +336,11 @@ int codetag_load_module(struct module *mod)
 	return ret;
 }
 
+void codetag_flush_rcu_on_module_unload(void)
+{
+	flush_rcu_on_module_unload = true;
+}
+
 void codetag_unload_module(struct module *mod)
 {
 	struct codetag_type *cttype;
@@ -342,8 +348,12 @@ void codetag_unload_module(struct module *mod)
 	if (!mod)
 		return;
 
-	/* await any module's kfree_rcu() operations to complete */
-	kvfree_rcu_barrier();
+	/*
+	 * Await any module's kfree_rcu() operations to complete
+	 * if profiling was ever enabled.
+	 */
+	if (flush_rcu_on_module_unload)
+		kvfree_rcu_barrier();
 
 	mutex_lock(&codetag_lock);
 	list_for_each_entry(cttype, &codetag_types, link) {

base-commit: 3f43be96f919cc611dcb2a4e38dd464831f4513e
-- 
2.52.0.223.gf5cc29aaa4-goog


