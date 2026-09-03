Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E6E6C624D4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 15:59:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AB6D6B0088; Thu,  3 Sep 2026 11:59:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30E416B008A; Thu,  3 Sep 2026 11:59:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D6336B008C; Thu,  3 Sep 2026 11:59:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D56746B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:59:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5438C14058A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:59:12 +0000 (UTC)
X-FDA: 85172910144.16.FDA2553
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	by imf14.hostedemail.com (Postfix) with ESMTP id 973C2100004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 15:59:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Lb8hpbMq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3TJmZagkKCEEwduxqvdkxjrrjoh.frpolqx0-ppnydfn.ruj@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3TJmZagkKCEEwduxqvdkxjrrjoh.frpolqx0-ppnydfn.ruj@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788451150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fqrjp7diFK7hTPI/YVRHNUU83H0HuCgE52mHERNgxw0=;
	b=1lbXCYwWpbyNHNmWMu3tKcmO3BwcJz85UWlm+GAXpda3Wi4/l05cz/pzTV5tVAnE/c4rn6
	Sw5txGK4CPCpzQGvDDhoFN1G71OqhQrK1+m+zoDYUJUlmVQ9Vsm+f0OV1pEIY9XrvcZ/J9
	4H+rxlAM2o57NHAT/KW75SIgTAEXVYw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Lb8hpbMq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3TJmZagkKCEEwduxqvdkxjrrjoh.frpolqx0-ppnydfn.ruj@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3TJmZagkKCEEwduxqvdkxjrrjoh.frpolqx0-ppnydfn.ruj@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788451150;
	b=Rb341b84v1CdBrGIEku8ftJ/ua7l5bQeNUuv+/zLByBXkGegZoI5TeF/iqZ1NVNyWK0tTT
	B2UkQ0zSJdQSZE20RcK/i0iz5Hvw3wf9okOy81YjAH2s7GGjVUHKcgfnLyJC9OwN0Xtmbi
	nDN+mWHSxhF42jpINTfLJ+hJx1geVHs=
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c252c2ffeb8so290860666b.2
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 08:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788451149; x=1789055949; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fqrjp7diFK7hTPI/YVRHNUU83H0HuCgE52mHERNgxw0=;
        b=Lb8hpbMqiMdMVJlx6wC3fqGZ7rggFOc2VstdKoZor3NFQFdorLJEqRXf6huKYyCgFU
         amg4QHYqjdJptOkkVLbudJjtnqZ7MhOnYhP2X8RwnkZgGWkqYrrsrS8PGXs+FTNmrn5w
         miw36ZVhMvZtHO5Ay81GU9A6adA4p/YbZmOhHiwxPICYIPs+RD98reR/1BjCzicjP9MF
         F8tiPHXQFohmy3Utz9HKTeuPCE4YU5xrWw/kaPPlSP21yQcUZx/7XU31fMSV105Fd1wo
         BDLDNZIwr2zhrQQf6BTS2eJRnKbQwYT1swd3ISWHb8KgWUpa0idy0nm7Wk3QAW+3praS
         j4Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788451149; x=1789055949;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fqrjp7diFK7hTPI/YVRHNUU83H0HuCgE52mHERNgxw0=;
        b=ihH/yCd66b1K5A098wpQr8axGBMYj6dNy7p8xSQW2lMZygv0sVYfhrD9Vt95vvpaoq
         wsuj1P6pYG9tv8lgejeLJd7p0COXPXb/FQmUklVGhuIeyshjJArQuQra/HY7TrckRJIt
         KmluKBKbhiOfY91NcVFLZHuIfxcc5PYNl2QlelbB8SSBR8H1kv+QqO4f/VArbkKVv7Ek
         rmyfutYZ1sl0lra55QMNv3e0cAy/iELQM/oOS+Mm2fJqJzIl6tqfPdafr46CuctVUEYQ
         9zWrAEGrGtOLn9JG10HoYE8WqS6IlSL/gvQuv/aHFOjTtLDYy9DMb3gqgGXbha72LJsj
         HB4A==
X-Forwarded-Encrypted: i=1; AKwUvBz6T8Kn8kNajQvtC8imUYvDjVmNKtcKKqSlFqHaJCmQvtmR+Cu57szCzijvrAGNpI1RoVoAhXcm7A==@kvack.org
X-Gm-Message-State: AFuF++lTddAzItPMxEntHt0/fy0bHQo/Qj3v0/iebHGUqbqKMF3FaBs+
	9r+7uUzJEeQY3KqiGUyZTlYYb+GIh0UmlPB1K6s18hDu+tlUDJCRyUtTH6pILO73XPs8I3UQg9o
	HKMBFBv7sodH93SkH5Q==
X-Received: from edev1-n2.prod.google.com ([2002:a05:6402:a2c1:20b0:6a6:92c9:46e5])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:24cf:b0:6a6:32fa:54f5 with SMTP id 4fb4d7f45d1cf-6a6832f4708mr8089142a12.20.1788451148809;
 Thu, 03 Sep 2026 08:59:08 -0700 (PDT)
Date: Thu,  3 Sep 2026 15:59:06 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.970.g62bdec98f9-goog
Message-ID: <20260903155907.1065681-1-tarunsahu@google.com>
Subject: [PATCH] memblock: use binary search to locate candidate regions
From: Tarun Sahu <tarunsahu@google.com>
To: dmatlack@google.com, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: j4ftd7nnorah8kyojoaqu1zxi48d41qg
X-Rspamd-Queue-Id: 973C2100004
X-HE-Tag: 1788451150-611358
X-HE-Meta: U2FsdGVkX19LGreXyw+YNFZLv2EdvQ3pNBprPiovyUkvEW2v1uhyhWWlevGt0yY2MBrl7nZ+ef5+mOdFpUwN4c3OcPUickdj2l74qcP61m0incGFKgyC5I2ITbX4UHAmGyxMwB3q58Zts9N8lQwF0xvtPTROcCP8R/t1V3Guiqi8zmPDYqvazTxgLtX7UL9eNs+s4ryo+5NB0TTiPY8PSiDQWZHKTO2hVCgwlzQjG4TJ+ieTsDv2Nobdg+8CCjVQ6BcjeuZPXwML3jV8gtfmHBqvkqcmWkNp+IdJQWU+rQ45QIVQ4D28pa+2gSKNAXYcvDdVpCxf21bn98lzsBLm3mTE2ZyJwlRDwl4fUrwIEGpO6DC04pOOt6EvrfS7iZLHI3vnXhp1baqiV8JsUSxgzLYwTmZL0wF+GnaRVjxrTp7v14MvXJkh+WjAf26se/7+e4cjmqrDoh2OJqNtCvAZV2/cuGyTf6P2EP9/JMtz0+XOVVCfQnsaDpJPZgweaHupY1E+qfoCfEPftw3Z8x0ftsJRjN/36Kt/HJWpv+bYaGKaXnCJsg8liMgQR06XFb5VzZryE57psSvkZ5J6yGCEm59CbeY1YQcBoiUL6bzRoczprkr1UBY1gLscJE4i0YOuvHf1nOtKgpKpEMzw5UuYAJIcIsuOWis4pp7+oJ56hYJkIbz3qsD1Aq1tdAeEiiuOTyZoK6IqOh7zu367VxoPM0mb6X0oGZitMZIVjyauNZ2YzrO4ZQe4D85H6ejziBf306uDrD1v0S5Y2xx6tPbtA5WG9JKakCOrpFGqX27lj5Qe+8nj73j2DnHqFTMRNvX/jVBSHduMmLnQNgRSstuEks5eh/s+3neOP/uScb1XC7dRtA6x9qh8YvCw34n4QF4V2YS7hASQNWJHCc4zDE32g9KpfrHvn7Iyrea+pNysKu8SriyZ7CZZEb1Tq0XpfHyQMfx21HQG5bBq3MvTypC
 +pp2H341
 FmPmZoi9hR8YF43LTHEKhlPWKgR+eEJePc8Hcc/oOhjPevY1BdaKDLmOfLGUiBz6ea9xwGeHyb0J/+AKiCqPSGKhF3YscHLUmrs+an7of8Oxdz5uJMW5zCzJwdz1Yv5nTN0QmZi2YdTxLvGeXCnMcBKFBQKtCJ9qaPLzEGqXHo61JiJ8d+Ap0POQ5PPDcpLV71ezGPeyrsU2RsFKvnt+nNx40KJIB/sz8SBbRgeTZphwcIgq94oHkaD1E73zdKD7K9mfBiFu7aFeUz3yt5nKQs+eRSdXQgKpLDMhf+o0vfzsRTWh7FE6L+8pwa8Y1T4M3hnlm6BfoMVhRQ8wuQCaYFadJIFhATnHbuw+UCjIEiUTJrkC6xF3B9HNxp/SeJcXiQo1dnJLxX0/YZzMBKCGyi4BRGqW4OrpIOBrJxGfG4Tj4CrjHCFZNokJNx+EM4IdlWqLFcmjrBS/0+tQlUKX8DgN6MYh5UBKgJOKWsYy7A8uhiztY7n/8n9CscD3m3u1mKdopEUnihgU8jHFtIpcE5UzQWkZpd9N0pX5gVlVLSEMUcPfDEajoBHwIqPGGrAUMsiFMBhSiVZRWhZzbr2FEJfJYKeBEiVqh5JkD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use binary search (memblock_bsearch_start) in memblock_add_range() and
memblock_isolate_range() to locate candidate regions instead of linearly
scanning from index 0.

Under heavy memory fragmentation (such as KHO page preservation registering
hundreds of thousands of disjoint folios), scanning from index 0 on every
insertion and isolation results in O(N^2) complexity, causing boot-time
memory retrieval to take several minutes (~268s for 393k pages).

Using binary search reduces the worst-case complexity to O(N log N)
(and O(N) for sequential appends), cutting KHO memory retrieval time
from ~268s to ~50ms.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 mm/memblock.c | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 9ce86349a29f..88940474b020 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -160,6 +160,11 @@ static __refdata struct memblock_type *memblock_memory = &memblock.memory;
 	     i < memblock_type->cnt;					\
 	     i++, rgn = &memblock_type->regions[i])
 
+#define for_each_memblock_type_from(i, memblock_type, rgn, start)	\
+	for (i = (start), rgn = &memblock_type->regions[i];		\
+	     i < memblock_type->cnt;					\
+	     i++, rgn = &memblock_type->regions[i])
+
 #define memblock_dbg(fmt, ...)						\
 	do {								\
 		if (memblock_debug)					\
@@ -591,6 +596,33 @@ static void __init_memblock memblock_insert_region(struct memblock_type *type,
 	type->total_size += size;
 }
 
+/**
+ * memblock_bsearch_start - Find the first region index where rend > base
+ * @type: memblock type to search
+ * @base: base physical address of the candidate range
+ *
+ * Returns the first region index that could potentially overlap @base.
+ */
+static int __init_memblock memblock_bsearch_start(struct memblock_type *type,
+						  phys_addr_t base)
+{
+	int mid, low = 0;
+	int high = type->cnt;
+
+	if (type->cnt && base >= type->regions[type->cnt - 1].base +
+				 type->regions[type->cnt - 1].size)
+		return type->cnt;
+
+	while (low < high) {
+		mid = (low + high) / 2;
+		if (type->regions[mid].base + type->regions[mid].size <= base)
+			low = mid + 1;
+		else
+			high = mid;
+	}
+	return low;
+}
+
 /**
  * memblock_add_range - add new memblock region
  * @type: memblock type to add new region into
@@ -651,7 +683,8 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
 	base = obase;
 	nr_new = 0;
 
-	for_each_memblock_type(idx, type, rgn) {
+	for_each_memblock_type_from(idx, type, rgn,
+				    memblock_bsearch_start(type, base)) {
 		phys_addr_t rbase = rgn->base;
 		phys_addr_t rend = rbase + rgn->size;
 
@@ -827,7 +860,8 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
 		if (memblock_double_array(type, base, size) < 0)
 			return -ENOMEM;
 
-	for_each_memblock_type(idx, type, rgn) {
+	for_each_memblock_type_from(idx, type, rgn,
+				    memblock_bsearch_start(type, base)) {
 		phys_addr_t rbase = rgn->base;
 		phys_addr_t rend = rbase + rgn->size;
 
-- 
2.55.0.970.g62bdec98f9-goog


