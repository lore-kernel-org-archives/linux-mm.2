Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 861EBD74961
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 07:12:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3A956B0088; Fri, 19 Dec 2025 02:12:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9786B0089; Fri, 19 Dec 2025 02:12:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CB886B008A; Fri, 19 Dec 2025 02:12:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B8406B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:12:17 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1BC151325F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:12:17 +0000 (UTC)
X-FDA: 84235351914.19.19B95D1
Received: from mail-yw1-f194.google.com (mail-yw1-f194.google.com [209.85.128.194])
	by imf10.hostedemail.com (Postfix) with ESMTP id 26C75C0004
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:12:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KN6A4Fcj;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.194 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766128335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6QLENq4Vv2SQsAQ4s6mi75aJFbGZLylufA139w0/C0s=;
	b=1D56Cp+fzHQmqbbwNBD997a1bDuBvFqxiqoZqdJqVulASKYaSyKqS4ZnRVf7jILt3nIEMZ
	53RrsNTNQryH2lzHTOn22pCaaZ7ErUg297xYZrOQwhLK01fN0Bty9z5eX+Ojfis/1+5B+O
	d61s7TXBUdpGhB3Der6VG5TuSO2vvF8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=KN6A4Fcj;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.194 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766128335; a=rsa-sha256;
	cv=none;
	b=8DvtuOuFqaCHU7oADBCirMH7olZUYdkraU+P4dd2iZcSCcVRSi9pOUn9c3xUTEKgrTY4xw
	kv6z+pWTfT2mLQwt1arMzAf4vKnHbPQvraNVvSbzQJxh/3+yoRtl4ffAarBrK4YKmWRLVZ
	6UzN3g0/n6eDXJhLDkxSXFyluLeczC4=
Received: by mail-yw1-f194.google.com with SMTP id 00721157ae682-78d6dc596eeso11359437b3.0
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 23:12:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766128334; x=1766733134; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=6QLENq4Vv2SQsAQ4s6mi75aJFbGZLylufA139w0/C0s=;
        b=KN6A4FcjlIcEIigpDJ9GeqCsZiWSiDNscECtY69iIQg6osalzkf5Y8veSwSjUC+taF
         8xFtd1aV0HGr8qCsknp0/iXxxENuqz7cKnGWP8Y4Jcy+uLQBDv3n6b8rL9uXryq5Rree
         SfVQWkpK9J0BgXBookRpisDw3y60pid1s615AzttgXCzX2pbHspc36nJr6dLkyc1Jl61
         raQBQF2MbvXwJxuwn+eiPjGTS0amMeKrlmbVLajUKk5YBiJ559fQEUxEtV6gWVb4H/2J
         qp/2IKm67pg3/fmzqqR9fzikbCz2qZZv5zYO4AKhjvFCXAnFCwFrqKkGUrU1yDC0I06S
         akuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766128334; x=1766733134;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6QLENq4Vv2SQsAQ4s6mi75aJFbGZLylufA139w0/C0s=;
        b=PidzWrZqD+7j0JPCtDE6p4o8bNVGxP/NdQFUUjgh1xMApEByPn9qAbh5kAXVpMxM4W
         x7wcsjxPYI/88Vhzwn7VgK5icjipm/6oGhyd6Yxb/36V/ccFQE1tk6VhOGu08iLEP3CX
         /ZkBqMMU5R1QC14ZrcxTIPCgZoz8EiR8wq+Zlorsmi/imZOFsc64VtAYYDDpWnJClrmk
         7wLt139Uh62I8z24aN5QIyajob/1Sw9Dbfltt0GPG+h+du2DQA7VznImy7kDt6P9wpBT
         W0juokl/EQNro/V7lg8SQEyuyI1DV5SrUFQskCb/cU0RE16+oaziVjRkZbOO1CHkjutg
         jIYw==
X-Forwarded-Encrypted: i=1; AJvYcCWqJxm2ri8b6xKYGcR0vN9gNIafETDpkyt9ae1BkxWzndX2VBPMZmTGswnF7Z9C4JxaQ5+lbn07LA==@kvack.org
X-Gm-Message-State: AOJu0YwA8GNWr/raCWRdhgjytOxPPoogoff+p1AdiqyKBJk1dV6xqGHa
	FSDu8d72p+7huBWBAV9rPeFHYj+5HQpk4T32arECOngT27Xq8QxV4YrnRqHJiSmz3Tg=
X-Gm-Gg: AY/fxX7sthA0ruZBZ/7wx8TNdSFqucJ2TYKPGGiz2kVTAzM7FXJ5Xt1/pKgo3AGPjZC
	TxQb6oCyifWkgWvssGTzOXh6HecdRxeh7zRcMnqO6kAmlAGXg1WHL/hnUSGopQJnbWAYs7dbB5T
	MIMlK+562NwJW3YumAO4/nOaq/0WuuqsbY8WKqUw0H74rKH5fxdBrNMTOwDCUBRuxZwuN8DUupS
	O8es0anTqFIbgM23iwBvd6aXB6eM9wxVmit19IubFlzxW+hqBg+JaVZq5IR3I0zy0+oDUNLKezd
	ibsDLQC6oi+h25TnGvcLb0el3MRDen1iNnKB0CSydvp4wYAv/wy4MUZdQx/aTJmQZnC+R4bYcCh
	CV++ye2uabcLY8SluzL75dEdBbYCeEZIj3huyqqMbKKIlfE1b5tJOJOkifU8XuN/W41tD+fpJfM
	0wQ9mFq1pTsO4rd2ySZCnZ8Vk+avZxr2pRhzfo/GXg6/AzOy/m0Kv6L86mV3taQ2eBpaYjfuYYp
	PFYb0+ayqb8lcFoBDi567faHxrumOBPbFt0Fg==
X-Google-Smtp-Source: AGHT+IEWVVc2D1cqR3AcZS0yhRsNlUTKLbAvt0ocD1LffHnt0W3gu7vYKX6GCKHep/ypCYEXliKiAQ==
X-Received: by 2002:a05:690c:368f:b0:787:febb:7f82 with SMTP id 00721157ae682-78fb3ecce81mr19078597b3.8.1766128334090;
        Thu, 18 Dec 2025 23:12:14 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78fb44f0d57sm6743917b3.31.2025.12.18.23.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 23:12:13 -0800 (PST)
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
Subject: [PATCH v3] kho: validate preserved memory map during population
Date: Fri, 19 Dec 2025 02:12:09 -0500
Message-ID: <20251219071209.3696755-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 26C75C0004
X-Stat-Signature: jampe9q4euqxngacjycqf7q3oujae8nw
X-HE-Tag: 1766128334-548627
X-HE-Meta: U2FsdGVkX1+rRC2SFcJ7VgIQoIoDz0QPb2ElNFRJIYoXYYfLjzzvy+bxNTC7ixx3nN5oN7HjDyZ+pkUcQknEklAqdnejK4PG2yUTikuEVNlg6UxaI1EBxIeqHPPZaaDA22gDKAGzM8y/tyX76OKii/t588Fov8ljO5uUYubSE5n3HDlsD528b7ZepUHTsYxvOSPr+uTAYd2DgXrMaHPeaMg5mA7cGpXoVvpme+j8rTIWGflHHv3NH64yrDpb2v7n3E2pS2IZIorp3FJvQMSS6DrjCs8Dbpas88iAXn9TqyBm1UP3edE6Twgd7hApLzTsyTe+XkuVf+xHm1eEzpoUCunXR79ORCdI3Dp5ktuF3MvjAH7J7wdZpNm21rXguO40rj8n06SiAxQQHsDsTFRc7W1yfORSWeDFPhG0+/cJj0Jgcb9WuSpsHks1dFDJQ0rxWF4aOKhTctZE3WGfLI6tsGygygjrcenpBTbLXcCkI+fFTWZpXeJP+agCChaTmFoJg9OceJi3Hxy0X+qSVlqb4LMas8A6keRunnUrqHuNxc4CiDZAI6/4j9NsmiPft2IQ2X0qL7PztFBF+XU0iP0UJgRiC5UMD3x4URHKZUP9EiMMf7u0Jxd1J2Lc/pkasnUaHP469AHsFnUB0P+P54UJfvDPaqB2W+UNyF4saiBIdKOyftmVlPZU0p0wUWFSksU2XDtOhZU2uwlo2O8qgEm4QQhqaJfxfbvS633mjAMTKfAtVfj1+we5reYcdF4dDB6ehOXeV65P/VHsRCYblM7IWcIWUSL8bpU81CbGn4zQt7Rn5+cA9mjhReKzEhqjqRKc6I+ylvmsDQN/UFrIcSPkNvt8oRvAbtWk9jKYZ6BLFNmJMCLnqm+QxD42c6X2U15jx3eKyeovZeCdL8SmNDSUT7ctEWprYdOMjG49VA4G0MBo5WUMsve6Qlkn+4aszH1aXYzL6k2IlIc1p/89Ky5
 p10rz+we
 mm5dyYhdijpn+Bxij2ols5F3imvY0GpDuldL8YPgEPpuigpW8kf6NrLsHSjJHR+cYzdTF2P+zaHpJ3Ov8LztBF0F4ZIyuN+iN0qRyeg9BBODqmdXw0yr8HP10univbLv6aBCWxIB+aVGOmqE6+K8WW0DeWDB2g5vZIBZIJ/HDzLKiiA5hBs3alhnHyzdS2+rd2fVXRT57b8Qhdq6KbzXTXzQ5WmoEkSfdneOFwemgs375CS0yWP4t25Gp6IeCd6gfmoiY5s2fMsAe6nDC8W7Ot8A49s9V/UacBVSA1rjbWuQRtFtWudIfDe7WVongCRMQGm8okciMjy0xbL1qFekTYiedUpk96viQutHrW96NfuEmNMMQF3R2eQi7gh/y8kgbFkltu16eIdBuHZS4sl/wkfQVbiCeFklTw5FH/G89nL/aQsLEBUj/npvqoQy623qNX91elBr0OazA9ik=
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
initialization and subsequent list corruption (double-free) during
kho_init().

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
---
Changes v3:
- Addressed review comments, and added review-by from Mike

 kernel/liveupdate/kexec_handover.c | 39 ++++++++++++++++--------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 9dc51fab604f..2d9ce33c63dc 100644
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
 
@@ -1475,6 +1469,14 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 		goto out;
 	}
 
+	mem_map_phys = kho_get_mem_map_phys(fdt);
+	if (!mem_map_phys) {
+		pr_warn("setup: handover FDT (0x%llx) present but no preserved memory found\n",
+			fdt_phys);
+		err = -ENOENT;
+		goto out;
+	}
+
 	scratch = early_memremap(scratch_phys, scratch_len);
 	if (!scratch) {
 		pr_warn("setup: failed to memremap scratch (phys=0x%llx, len=%lld)\n",
@@ -1515,6 +1517,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 
 	kho_in.fdt_phys = fdt_phys;
 	kho_in.scratch_phys = scratch_phys;
+	kho_in.mem_map_phys = mem_map_phys;
 	kho_scratch_cnt = scratch_cnt;
 	pr_info("found kexec handover data.\n");
 

base-commit: ea1013c1539270e372fc99854bc6e4d94eaeff66
-- 
2.52.0.322.g1dd061c0dc-goog


