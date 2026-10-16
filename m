Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BAAFCCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 03:10:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8F296B009B; Thu, 15 Oct 2026 23:10:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A66DA6B009D; Thu, 15 Oct 2026 23:10:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97C4B6B009E; Thu, 15 Oct 2026 23:10:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70E366B009B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:10:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 181A8140266
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:10:06 +0000 (UTC)
X-FDA: 85327010412.16.132CD8E
Received: from mail-pj2-f11.google.com (mail-pj2-f11.google.com [74.125.227.139])
	by imf01.hostedemail.com (Postfix) with ESMTP id 43E974000B
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:10:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Vij1i6K2;
	spf=pass (imf01.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792120204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s7Fb6KtcWAXnUfcecLaSQ1H6J8YKvEJFUWN8A6hcpOc=;
	b=cxjy2Z85Z57l4r5IvMLOlzPQx9V8CRYUNHDGTM8yHD60YUQ79QghxMfdQnFoFAJZq1C7uO
	RaJks0iNc5F479b2XXLMF3AQL5Z0QmrIL4/Uaen9jLDdlT9HgrOFk4ZE/2ctFnxWWXf4Fg
	88AVE2FD7BPMcTgW8nwLQf+qSkvCDV8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Vij1i6K2;
	spf=pass (imf01.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792120204;
	b=Srbnu9NPw6O3GmyMNHiuGIhVJP/zLaKCyQrPaEn3sBh4W4pWk8tFSDkAmkEYWJkufXS9Rr
	uMMh0qnYUVKynZTfHtJltGbwvGA2wvFmkDuJ7ZNlbEkycMZLigNtFSwRdxIAx2wqu1NYHE
	HoSDS+r+c3HjW13WUCrh2+a4zU7Rdc8=
Received: by mail-pj2-f11.google.com with SMTP id 98e67ed59e1d1-398a0a87595so1267859a91.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792120203; x=1792725003; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s7Fb6KtcWAXnUfcecLaSQ1H6J8YKvEJFUWN8A6hcpOc=;
        b=Vij1i6K2Gq4uyy9PpmTb+lswhqgAK72BpquGIwhaPq3XKIa7+G5axgb/2WM3HB0C6c
         2VQ9JI4k64DgonYP6QF5lLjHvmbrpd7i06y1AyqphjPuZwgoF0sfZWcHGTxHkNj9tlCi
         /X6pkU2z2X1K09SP0NEWThKQN2TLYj2QjRPamN9eJq9C2Jhp3ln7Byw/elJNygzVvFQe
         Q9fRczsoyyme0hpy1TiPTN6gr9DLKchnc7NQD7MWuSUULmV46i0TYMth0wCk4I3tMulZ
         2yqAoJyIkfLx28AWalehCMx8kmayYl5Tp1VVn9iPKDjtq/lXycYbdL/TXQSjqEiKbvmk
         /a9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792120203; x=1792725003;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=s7Fb6KtcWAXnUfcecLaSQ1H6J8YKvEJFUWN8A6hcpOc=;
        b=AFzC7JGVEjQd6W8QohwWoCwu0/r+a/q0zeXyBQT+jNZAA7H/re0n9deGhq4G5le389
         Mbs0CvHCTru9HR9fwMyHa24en81dmt11EnspQzfZBfyGmnAVIMIjigPPe+K2W1AyCndy
         jRmdftOWhEGthoKejoqSM7V/O7pzk2IS32dLWb7UrnCi8/3Vpl0y3Syf2aZiqAaAWpby
         v7Wi6mXC/j0BZkSQ9dVr8Pl3IGXVz6UEQoukPqIjJUKHJZV3zYGRfFiOmTQ8vRaAKlJ9
         iENF8WuDjWdFouzXkFFFfpYfNHqSRuyoVnXS6Sf+VbPAPohf3FcTXqdTry2Vh8CySR2b
         5xuw==
X-Forwarded-Encrypted: i=1; AKwUvBwJ2+Y4e4JKkD5BTxNIrqR1+xmWsP6OceFkfYN9fK76EECer9Xl4A1MCyaUoEIX94fgU47AXiwz5Q==@kvack.org
X-Gm-Message-State: AFq9FYLundYMXE0nCBQRcVh4SYLnT/gUUVlEjOttTxXusMmcMw2uHciy
	Z/bwGXsCPhTKKrIyMWYbm1yEVG/deVacctykJvKSTIUlbA2c/fxv8J3c
X-Gm-Gg: AYBFou1RR/kZIbSAL9q0DlQ0tER9u4OtbF29xok17D3U0aK27+neIcSrkwFX/2FwaX2
	Xl8mI6tcjtMn2eZCDdjeCUTgcF632HMGB9na/XfXcxrZMs4rY4F88ZrBgNBzygxt+sbq/76g7oF
	5aMj0MZPzlMvPb3NPSUT6KEU3g76qeKuzC3bm/CGmZ4mQknzctoO8LCfbZFxtLpIFnWlHVBqInF
	M7vHsmp5I7zYJX02mUJ4uF2kFPb6AaVTQ1jmYRmDkQh8z+0onWIEbOr4dV0qI4trdGuuJSLiAHC
	N3C5Qt8wMjcX/Dy8my3gUOb8sNWk/HACyv3kLJJXnpVgmnaGsT1W4myBSk0vN/UlcweudDwVKyz
	EMUk0gL5g7H08GLVOMqq6NzU59CLWdlKxs24by0qKr2ctTwM4tYzZExGB55wpuFYNLonHa76mt0
	7JGq2jCX357EZ+3UBqAniX32ofpjXLNsZhCbqJ0erqdP7M8HE3ZQvgQ44SJyrvCk2rWWvOD9f7S
	3dTSN+8B+0=
X-Received: by 2002:a17:90b:35c2:b0:3ac:7c52:fae5 with SMTP id 98e67ed59e1d1-3ac7c52fe5amr6152592a91.50.1792120203082;
        Thu, 15 Oct 2026 20:10:03 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acd3cc73c7sm370085a91.4.2026.10.15.20.09.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 20:10:02 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [PATCH v8 4/8] crash_core: replace for_each_mem_range() with for_each_mem_region()
Date: Fri, 16 Oct 2026 11:08:51 +0800
Message-ID: <20261016030855.4062882-5-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016030855.4062882-1-chenwandun1@gmail.com>
References: <20261016030855.4062882-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 43E974000B
X-Rspam-User: 
X-Stat-Signature: jx85s8jkuw19ooepwkizr7yo5d9wqtpf
X-HE-Tag: 1792120204-136321
X-HE-Meta: U2FsdGVkX1/xdFW8TF1zgN1Crl2LQWS3liEaCtFG6bbIQo/RhX/Ld90QRuRXASAqIEsbIfGnvebu5XUKuG6qkqW3AJTmNtzdjo/2kYBc2LxendtpXi0lv62WYRHEGUrpOYOaU5X4W09Mgi83u08nZrEzySKBcr8Y5DAeqtQ1XbnApOIkRwymM9omqiwar+8QrF/J0N31oyGAbAtwifk4L9TKY0a02eKROGOiOtWBSY4pfugQvdwGKEFJZHMAYlLp5xN/BJza9HJti5jFQjol/NFZUaq2+bBJXaGAEJXvk4ly2dCiZKK+ayE2HdbVQrA71ElPbbStFzgf2O/HBwWjf2I/oZWgYX5ObaaD6ppBJhqwUGN+OQobB4HYBJptk0k8NVp63TcCcg6V7y5ZWshjHWOQBmzEEhRht92oesiCbAfE/gYaMXTxylLaueh1uyDynzKN1nV2YKz5E8AVcyZdQD33w4aIcc4OI94y/gmqLCO6sX+Ux8zMGVHjQWMfRiJweBLCZqIkkjz9KfA2FZYzu0BDEEvjv/qI8MfG9fHv9L42tybWVgzsgDMrUN1uDxqN7rPveZqdOXnMU0weLvJwQL/NEcAu89WgMTwgESYWWnqjnExeSXV5xGKZ+WddUszE/aH5Mgsv4LTxoJUhm7v+QLosfgFH91zwu3Bh02HcpYKTUtivd/FFRAzMVXFnjFJP6lOksp8CVW2MOaNpzEJRCVIo6+vaqPtSZCfsAMY1Ea4VbcQwalAaW0Di6nSW2cpG1aQyJo1GW6u4Zi82WoMUf/ZscSERNbERJqOmIXaPjEwAEIef0NILLPJjY0SuGLnXiqElItdK+lseHpkbghLR2UuQPCYuX690sexp9i3D1NBz3yFqGYSaywAvppF1UWzJvIJlqKK02ebZ0e87f6UzTuCz+lJv1e3EHkljaPG4Lv1jRRXHuvvphn1bGTlbBBo9J38KSGvHzzZ3NBo5ROw
 fEvnmt10
 fUq6+hXLImAX3gR9/SrKPdoW0i1SiySVCIUvWa9cNnJBIGPW/LmAZAOQB3CQJVof7VQoRpZ4rFUKY2AgMIFJN+/wHmtUAh2KFSxmgMv2c/bHGNqwu1bk8S9lZzmhKvd8xccqBm2XyMDbpJ8xqWWUQHQy0PVHCkKV2Y9IDg/DRMUUre/IHNKhQaYuyc6ZeP5GFUwvKMCIEPMPXKHCh55vZ1zbWO8SCveoP2RU2hrzCENm0RsZ4pVmAXzuodXUSbkblVU9RS2PVUsjoQrcwPO3HbaBvjw9qXG+842iKQr/UOmOaiqZ+jANYsPODQ6LGsUHFo8M7WswECclYvko0GrkUTaa7RVum1nA8BhlAgCWByQz4FMhMxQlqAXvwgky46cnGYIB6q5DtoRc3NzrgzRBHKv8eSWUslgv68eBWBUYcBBmwu6AaTnsMhIeyRzIF6/lfZkJwVhDhzMotK86Nhtk9X9FCJaUa03UGPbPqRO1oT7lKnKtRNsVVq8ZuN1cUmeFsbcfU5cNvHyaSuLV3yx2XW6YLCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

for_each_mem_range() skips MEMBLOCK_NOMAP regions implicitly. Switch the
weak defaults to for_each_mem_region(), which exposes struct
memblock_region and per-region flags, and filter NOMAP regions explicitly
via the new crash_should_skip_region() helper. This prepares for a
subsequent patch to extend the skip filter.

No functional change.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
Acked-by: Baoquan He <baoquan.he@linux.dev>
---
 kernel/crash_core.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index 8a861a946e26..e161c8b65e00 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -283,25 +283,34 @@ static struct crash_mem *alloc_cmem(unsigned int nr_ranges)
 }
 
 #ifdef CONFIG_ARCH_KEEP_MEMBLOCK
+/* Exclude NOMAP regions from the vmcore. */
+static bool crash_should_skip_region(struct memblock_region *reg)
+{
+	return memblock_is_nomap(reg);
+}
+
 unsigned int __weak arch_get_system_nr_ranges(void)
 {
 	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* crashk_res + crashk_low_res, +CMA splits */
-	phys_addr_t start, end;
-	u64 i;
+	struct memblock_region *reg;
 
-	for_each_mem_range(i, &start, &end)
+	for_each_mem_region(reg) {
+		if (crash_should_skip_region(reg))
+			continue;
 		nr_ranges++;
+	}
 	return nr_ranges;
 }
 
 int __weak arch_crash_populate_cmem(struct crash_mem *cmem)
 {
-	phys_addr_t start, end;
-	u64 i;
+	struct memblock_region *reg;
 
-	for_each_mem_range(i, &start, &end) {
-		cmem->ranges[cmem->nr_ranges].start = start;
-		cmem->ranges[cmem->nr_ranges].end = end - 1;
+	for_each_mem_region(reg) {
+		if (crash_should_skip_region(reg))
+			continue;
+		cmem->ranges[cmem->nr_ranges].start = reg->base;
+		cmem->ranges[cmem->nr_ranges].end = reg->base + reg->size - 1;
 		cmem->nr_ranges++;
 	}
 	return 0;
-- 
2.43.0


