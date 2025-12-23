Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D903AE6F093
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 14:01:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA20D6B0005; Tue, 23 Dec 2025 09:01:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A79D86B0089; Tue, 23 Dec 2025 09:01:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97C806B008A; Tue, 23 Dec 2025 09:01:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 889BB6B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:01:49 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 568B913A7BB
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 14:01:49 +0000 (UTC)
X-FDA: 84250899138.30.65CBD5E
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	by imf24.hostedemail.com (Postfix) with ESMTP id AF88918002C
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 14:01:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BZFA9s4w;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766498507; a=rsa-sha256;
	cv=none;
	b=umJPGmu5c1RugVYTNotkAuRAGPzsAdEmPQ4d6ao7KXgzxRUy+gxrNYW9N1Yesmah/rWgPE
	/EejKoWUHkmxwC7zyTqZPWH8Zc7Z3Vhcc3USbJkJAy/Oy9aVFkHRUvyGFzIatXjprdhUHq
	swKykmBywU9GGgllTPEVHRBZJ+K40Wk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BZFA9s4w;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766498507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vshIKu39IbphKk1hyt1uS5BaulPgmjMjuk5AnSSvw9w=;
	b=e0mjS+yCxHMMUIZmDdk2q74rO5Fpi3q+pJXIc0DEd8CWXn2Tj64DVUC5aEk4tP+f8NHM+B
	KGQiazhz2GgGzrBR4IndfYyDJ7qfzVS48gVlXD4NLDVXWzC6B+ib5Z4EAJZ6Yg5j0DwRLH
	1dDjWi4sw8yg8noFGBmZmGbXpoyG24c=
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-64471fcdef0so4023399d50.1
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 06:01:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766498506; x=1767103306; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=vshIKu39IbphKk1hyt1uS5BaulPgmjMjuk5AnSSvw9w=;
        b=BZFA9s4we5LZoSa8+/Lt0mRt50CHAtgptjIwp//fZFpTl7szAlBqPVQJRQlph84URO
         jbcvdqnKI6zAUwMddaFYLBG8gDRqEPl1pFeYsFEul0L3m9aOk27M0h7LWLfAacrW/i/H
         ydlcep9kC6q4uxZd5/Y983Vby9Ni91Gjn39IBBJbVDWsc+QNlIgNkzhjdP97Q3loyqh1
         Xw/yZnLgWON9UpEscUNzcXCtF2vmvYPNfe9VQxg+RLKqC3a6f/X2e06SJChWX7GY7GH7
         0n+JXaZzsiPbKJscDlBCba/2k5JA4/MojPt+z/w3gYfeanEPu6c1edKueKsQs6+8Q2na
         Xwxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766498506; x=1767103306;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vshIKu39IbphKk1hyt1uS5BaulPgmjMjuk5AnSSvw9w=;
        b=Wte9b2XMpDwO8UTYvXpJPA/DEbdCxVk+GNcm3MN55DaiY9bc6We4Y6fbkwzc95HsC4
         6ZNMgv2rABqX7LpF0UbHB7+TK+jhDtx2R/49NsTjh3EGeRPlYciJWpiuym1Io0YJttjT
         2AlpPy7ljEC3Zl1/RJ7K8R0JI11ZiV/DCwSLhFUFyO2ekFtGpnuieJ54d1CxKFJwvV+m
         TsMwp0ANzreY0m5yi2cQbJbfL5RtXTindYLL1FJ/zPMyzhJkt43GT47BlIswMbKcV5aq
         eAFCCXyZ10/7ICmmTnuCzU1mcFZKsu4+7ReHjQduk5WzstGlAzw8q57h3VcuJqI9L+pT
         4xOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZ4hrs6tGBMSy1iYKhyOc16czg+gGTPAm6sattoKsVyo3oBmjZZSZQvErCbx15qpZVJS0sk+Fslw==@kvack.org
X-Gm-Message-State: AOJu0YxVF6p1JYFyxsTYiv27fP3Htx/tM73L8lmY+8M+XHZckt3MRjCz
	0XUd1n+djgpkvdLJRbdAK+EnAidvZoR5vdkKjG+9PmrdbE32puiIrC5gtJjPsrVA1KI=
X-Gm-Gg: AY/fxX4MqSIpowkJuD3HSAN2SJSUEMcdWLZwk/ClW7RyNmrVa0iTrLSf9uMGPeoCtvo
	OZ6ajXq5lCNjGPuDIiyr17oj63Z5wq9Kvu81HRphnNXIHKsdv/tJndKCYaSNH+LlkABNr3RQOSP
	6RL4AIJd6yVowHIxrJ9G4F8DjiYVAHcfsvNLIW8H/LDC8lzc760iA69g4SnCuvE1X39xE7qyA4h
	Z+CN/QiDXCyluQyJ3x40237+3+5R6pSO6LgZhZ5qfJ1fdFt9qzgqiywr2RdJz0HtbNEZZv0r+C/
	3HfUH6PnpknRVBoZnlUb2VujS9Vt4e3DCU9eMg/+LmO5V8q7D2sSE+59J4emZePw6eSyORmWzl6
	+PAIUqltILxIdow5k+S9sHEyqLkokrXRCrklfNMtu7dSNEEMt136iYYOgxD50VT162bT8UfhyLP
	uxeB2nTnI3ZWo1jH71LuMo4tl4zJPiOTZ+w1KUP8hkGujXa9zOLLCfpf6sTzI6ozY8da9d6WcCb
	ESu9emcVPJO9caTLYrNTTY2ZUBYhdlMTF8tbw==
X-Google-Smtp-Source: AGHT+IH5CPaJf1hFF18a7CLmrmSafeqmgYVCXu6LIDTysGZNKbl/h5bcqgxuwkcD9gwaFkH2YgNd4A==
X-Received: by 2002:a05:690c:4b88:b0:78c:6664:3104 with SMTP id 00721157ae682-78fb3f05364mr244887467b3.5.1766498506252;
        Tue, 23 Dec 2025 06:01:46 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78ffebd2690sm1244367b3.15.2025.12.23.06.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 06:01:45 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	graf@amazon.com,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	pratyush@kernel.org,
	ricardo.neri-calderon@linux.intel.com
Subject: [PATCH v4] kho: validate preserved memory map during population
Date: Tue, 23 Dec 2025 09:01:40 -0500
Message-ID: <20251223140140.2090337-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AF88918002C
X-Rspamd-Server: rspam10
X-Stat-Signature: n4i53ewfoo8j8gtswhk97gnypb7p8b91
X-HE-Tag: 1766498507-825646
X-HE-Meta: U2FsdGVkX1/3A6Hy0otWMhL++xJNftTOPfwe2rE45J4deDBimIFLQSye+DRnB1izwVpi5mZKuTZHlAgnpPTJy6ov2SEtv9NlB4rD78rJjJa9HVJfDqqawxRap5q8YnG58Q/WTB3bmErCTPa8/eQ3GA0sHtiG4crTjY+8vsCt7+PxCZtNjodILNvvYSOW7uXR/x0HVtgBIiqXywvSiH+gOE/nwMur+yKRXCqmV83XWxGlycs0qgbAA1VGypjrYSvwoA19wZ/u7c5hWPoXwzvVc/ITM+qCMJIDoJUBABAe3unTdKKrMhX46lgaBUE/O/nguNnV0vZi+y9eAzb+TiQdi4roO0mCswmXQgTcxesJKogoJlHSHCpC6Gst0xnGBWc2UbOQhtLmXm/LXm7G93DCuMEY/VDHDgzYQFrED+NH5u2A3hoIy5CEqpZGGbXOa/YIbjoJE7z/U3S5IZAt/hnrLavFuZ29ekJ3OGpALwIGjPPFC7cTjI4RC6fe/QYxtR1V1zELt1/Ab4F4CRY2ku9vxk9wasm5HY7FTH27lc40tts35VqxyMfIOLme+PhL8BTv7xIdknFwbFJLdMbFa2u2wX51ywc4ZHCSI1BRrqPZBaNAZbQ9viPvBp5XTlhhsDCEiTzedu3tp6Ey+lhAAU4NQFY9CVMSWTSDxUC+Q4dmqvWyKqZ08UDOGG0MA24D64DDpWmik/bVOS38ECZSa6s42ID9T/hLMnCZ1Eqkc3zaNuYc2UaV9HPfELW9VlL1GFPy2ZZc73LcPdXd301WJp8oIrlQ9TItxRuECzYcPymOx8sc2GBqD7Xf9gvcWyv7TTi4J3SxhSQEO55m/v38hEjRmw53wLIZjYYJbCSLEaK39DZ4pd1B6zgoSNbY5uKEiZgByMYGp5PxjyH+dCKVTWWt4BIQyz0HnJniGjtpuwqINWS6rKwi+5ZPIcqJtswxaKn3IlUgB3dWYe8DQKBes0O
 tYGBluFw
 NJ0OwNpjvOeWeqZg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If the previous kernel enabled KHO but did not call kho_finalize()
(e.g., CONFIG_LIVEUPDATE=n or userspace skipped the finalization step),
the 'preserved-memory-map' property in the FDT remains empty/zero.

Previously, kho_populate() would succeed regardless of the memory map's
state, reserving the incoming scratch regions in memblock. However,
kho_memory_init() would later fail to deserialize the empty map. By that
time, the scratch regions were already registered, leading to partial
initialization and subsequent list corruption (freeing scratch area
twice) during kho_init().

Move the validation of the preserved memory map earlier into
kho_populate(). If the memory map is empty/NULL:
1. Abort kho_populate() immediately with -ENOENT.
2. Do not register or reserve the incoming scratch memory, allowing the new
   kernel to reclaim those pages as standard free memory.
3. Leave the global 'kho_in' state uninitialized.

Consequently, kho_memory_init() sees no active KHO context
(kho_in.mem_chunks_phys is 0) and falls back to kho_reserve_scratch(),
allocating fresh scratch memory as if it were a standard cold boot.

Fixes: de51999e687c ("kho: allow memory preservation state updates after finalization")
Reported-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Closes: https://lore.kernel.org/all/20251218215613.GA17304@ranerica-svr.sc.intel.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
---
Changes v4:
- Addressed Tested-by
- Addressed review comments from Pratyush.

 kernel/liveupdate/kexec_handover.c | 37 +++++++++++++++---------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 9dc51fab604f..d4482b6e3cae 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -460,27 +460,23 @@ static void __init deserialize_bitmap(unsigned int order,
 	}
 }
 
-/* Return true if memory was deserizlied */
-static bool __init kho_mem_deserialize(const void *fdt)
+/* Returns physical address of the preserved memory map from FDT */
+static phys_addr_t __init kho_get_mem_map_phys(const void *fdt)
 {
-	struct khoser_mem_chunk *chunk;
 	const void *mem_ptr;
-	u64 mem;
 	int len;
 
 	mem_ptr = fdt_getprop(fdt, 0, PROP_PRESERVED_MEMORY_MAP, &len);
 	if (!mem_ptr || len != sizeof(u64)) {
 		pr_err("failed to get preserved memory bitmaps\n");
-		return false;
+		return 0;
 	}
 
-	mem = get_unaligned((const u64 *)mem_ptr);
-	chunk = mem ? phys_to_virt(mem) : NULL;
-
-	/* No preserved physical pages were passed, no deserialization */
-	if (!chunk)
-		return false;
+	return get_unaligned((const u64 *)mem_ptr);
+}
 
+static void __init kho_mem_deserialize(struct khoser_mem_chunk *chunk)
+{
 	while (chunk) {
 		unsigned int i;
 
@@ -489,8 +485,6 @@ static bool __init kho_mem_deserialize(const void *fdt)
 					   &chunk->bitmaps[i]);
 		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
 	}
-
-	return true;
 }
 
 /*
@@ -1253,6 +1247,7 @@ bool kho_finalized(void)
 struct kho_in {
 	phys_addr_t fdt_phys;
 	phys_addr_t scratch_phys;
+	phys_addr_t mem_map_phys;
 	struct kho_debugfs dbg;
 };
 
@@ -1434,12 +1429,10 @@ static void __init kho_release_scratch(void)
 
 void __init kho_memory_init(void)
 {
-	if (kho_in.scratch_phys) {
+	if (kho_in.mem_map_phys) {
 		kho_scratch = phys_to_virt(kho_in.scratch_phys);
 		kho_release_scratch();
-
-		if (!kho_mem_deserialize(kho_get_fdt()))
-			kho_in.fdt_phys = 0;
+		kho_mem_deserialize(phys_to_virt(kho_in.mem_map_phys));
 	} else {
 		kho_reserve_scratch();
 	}
@@ -1448,8 +1441,9 @@ void __init kho_memory_init(void)
 void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 			 phys_addr_t scratch_phys, u64 scratch_len)
 {
-	void *fdt = NULL;
 	struct kho_scratch *scratch = NULL;
+	phys_addr_t mem_map_phys;
+	void *fdt = NULL;
 	int err = 0;
 	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
 
@@ -1475,6 +1469,12 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 		goto out;
 	}
 
+	mem_map_phys = kho_get_mem_map_phys(fdt);
+	if (!mem_map_phys) {
+		err = -ENOENT;
+		goto out;
+	}
+
 	scratch = early_memremap(scratch_phys, scratch_len);
 	if (!scratch) {
 		pr_warn("setup: failed to memremap scratch (phys=0x%llx, len=%lld)\n",
@@ -1515,6 +1515,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 
 	kho_in.fdt_phys = fdt_phys;
 	kho_in.scratch_phys = scratch_phys;
+	kho_in.mem_map_phys = mem_map_phys;
 	kho_scratch_cnt = scratch_cnt;
 	pr_info("found kexec handover data.\n");
 

base-commit: cc3aa43b44bdb43dfbac0fcb51c56594a11338a8
-- 
2.52.0.351.gbe84eed79e-goog


