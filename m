Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24F2BC624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 19:47:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A6B16B00E2; Wed,  2 Sep 2026 15:47:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15E636B00E4; Wed,  2 Sep 2026 15:47:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 047256B00E5; Wed,  2 Sep 2026 15:47:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BDE6F6B00E2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:47:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 387781A0378
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:47:11 +0000 (UTC)
X-FDA: 85169855862.23.73498F8
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7A489A0006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:47:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="T/06PPcE";
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788378429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z0iWDp9wFRQQy4gDc5F5inYbcQx9NkSfWa5yO100B34=;
	b=Z16d7nucS5ibOnPYMPuf4Ttf5QZy3YECVI2r1WKB0d3/XU13iqu6IUBiDEMcFmUbtuRq5f
	04o2SejaQFfihqDPD4ZIeWrylIUnLUOCgwlPjchFr8LXdwUFzLI4rYmbLAYFoUYcE+O2qO
	M1snhaIb5fNrkYuN+KagJ3XcDjBifGU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788378429;
	b=QNZCYqXBCblXaB0hUPo/ZEkggw0+DTM54UUR7nKH4ORtn4v+zN6cYtd6IVhynY0kAMVobe
	3ZodI65Eq5v6T1HePXloldBl5IhGGGJV39EpmJziGHk/1unWeyy51j2uhpxgkwKHslmE0v
	uABGpyFXDtZBB/MBuBQLQJH6l63lAMw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="T/06PPcE";
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-9087fb771d3so13119976d6.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 12:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788378429; x=1788983229; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z0iWDp9wFRQQy4gDc5F5inYbcQx9NkSfWa5yO100B34=;
        b=T/06PPcEgU+vMqnpxRDnDDeRQkc+jPpAAQZ9M2TkXCtuwNlCX8cjHQHriYAUPHPps5
         81hu2aX8Cj4xiygczrKV6K90oJjmHzMfBnv/f8Xxi46FJpEx36QSgO8VufOwKtaXFJZl
         SA+z/wSs8/F87vA2SNpRJSVQVGwMTE6ecONaRdlj0PeyDvx8Br+ToyTXxok6p1fpnH4f
         Fs4pauYXSZNh7BIJ++I8q8b0VPS0KaeXwMiuXPba6O6WjI9hGhjrbnszQ7cKew7hHUff
         J+9oHXEs880EEIFCOMeqrJkHhIu9IXxPsDmx6IdRSzGRroMBEvei4new314TOyfpcRx2
         5/LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788378429; x=1788983229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z0iWDp9wFRQQy4gDc5F5inYbcQx9NkSfWa5yO100B34=;
        b=XjxuLY4ZQXh91B8d/tRmJWPC6zh7ulmwEUcF+VG68g180ftmI+9XQsDL87ORhFvpgp
         3C+JrPma/4OfZwBrCeSrN7LYk6QkN14WpCESIJ6Lax/czlTC2WXs8zG3OvNpt7cVIIaL
         A6F54WdE50gPSEhw9XoNHqE3AWfeVriLYfBdmxaY4w7BtDP7hSaBY8nw4RJx8yvuKMT4
         ThkAcc1tiQPsXVJUbFcrJE98BkO720msmku/9XyoUZRAREYegA95T5tTmzA0psHBozpp
         yNz+Gz3BtrevnKY4qrdqeJh84Gh/uR0W3kVO2Y28jA5TvkNKFEwXhJNkP9SqmXNy82/y
         Sp6g==
X-Gm-Message-State: AFuF++m/QMCc577Y085me5kdgp44CNhKOnNQBxIJTrv/YqloC9AX5ynn
	OlhB9YeGPXxXVLhia+xaJ1Xw0RQNFGNWb7SexIFcqZjefBycz7pIc1KjsbeCLlsXRKT/wwDOb4n
	Z/iL1czw=
X-Gm-Gg: AYBFou0Rl2L93dlKfonEEYfVNAyUPSZ8iCD9l9Dpf9YAevrkltIuAjeGeoFLVzjdLo1
	8fypa4FGrS3GeJ9kffI88pOOZZhTmMzuU4oTMAOXbcyA1BToGInfFxzOzpaHgzKC33ZlSYGlwGM
	TOBacP3sfQtYDVgVVB83536QLPafM2XD7YMwqyUiQI0kWQF3XOcbW+rMk+YSAqf+f6f48gLJSlX
	y//a/czkdc8tnk0vaIm9SWMMGLeLSVBv6YwCol+l1HTt83tIBgtHz2oPQIyVpiOwEnKmQmXlWMZ
	a5aw4RYjWM6ou1CdmqK2urjGAxtkxQi3gfTS40fzV7GFMaQYY4un5CNsrAIICg5WzRGvBIMaUOS
	QQNQPXMEsHyJAJ2ZeIOmO03byJzSzHbIoTYoLFPYxZboSOaiocKzAWpr6xGhrFDpnuVyKawZ8a2
	vrSXlSrD6WrfJvOlrsSIxleH1nBCKy2hCS0cA03cI1/+nx5XwXrObWtYn8iX/YFBkPaYGYmoZQr
	Xn29Q3YSLynD5+zEwjCRcPifkJmFJ+03qPh2tc35xJ9XrWUrg==
X-Received: by 2002:a05:620a:7002:b0:933:aa0:bb83 with SMTP id af79cd13be357-93960f69d21mr852874685a.34.1788378428558;
        Wed, 02 Sep 2026 12:47:08 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9395f18801asm299300585a.16.2026.09.02.12.47.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:47:07 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	shuah@kernel.org
Subject: [PATCH 5/5] selftests: KVM: guest_memfd: test GUEST_MEMFD_FLAG_BIND_NODE
Date: Wed,  2 Sep 2026 15:46:57 -0400
Message-ID: <20260902194657.79075-6-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260902194657.79075-1-gourry@gourry.net>
References: <20260902194657.79075-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z7hbpfgw48ziqjwqgn5muy15pjfr5rzf
X-Rspamd-Queue-Id: 7A489A0006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788378429-835737
X-HE-Meta: U2FsdGVkX1+R2ZSdeMVxmKO1zp0HgzboSAf0QBZQGicwb/LrodLyXNhotwZDUT2IFhInZfdQNGNnvc6SxAqG+kGYQMar6/Rlsa5usTeE7J4OkVsHmm1A8NSduRgzXJgNDGnAj0+C8e6aRVdPZ+H/0qYETuRiAll1WcCmWk4/0sgWnZWOdCm8DOGy/65Tjsfat6ijsn0pS+uwyCTBHgXdXL+zIOD+9sHvJXayk+j4p8hio4NupQoOlar6aezi8izTB+E9hEQAnN2e5MrGHGbdHrUJigREjW+GeKG03n4wv5VutKoFQf1+5hTD5vHtMYip6/2jRyHkj+Ve/sXMsTqXh/OIAu5gnrEYa1SB8eu9dNaQy7IOU3vJQRmMk0Kqvd8gymdZcYPGGODXMEpen+N58TJOSUTJvH8ggL2xEfkELOt3wDhLiVSmkbxwYZBuGTVpi37at8exyX5TQoSfiLcbK8M6vIhYFuiHnoswkRY+KGoEY+nbZ62OBj7kR2OOQyRBpSFq21ANWTr6A/UvrdR0SiJeHslny8XOOo1cjMhahTyvf7pPz2kgHxZSip8ZTyYQ89oNx7iKnX4/zQiDpEap9DJsYy/FTdYByZtwj0oq9mXf/PEBrjMwTkHuIUOaPC7teZIUAM3mKspYoat2TyxhJvvD5gle9d4TFPXbYVvj2js8HQ07NG6n18QzBRAMYA7LQk7l0UvjzVsRbDOv7AM02KNDpTR+PfkWCSy7pT2rRwrmlO4/mDIQ+lmQamsZZ2Y1Sg2zHPEF3xmwKWRGe/fNVsucCzWccLPCP5KcBn0xmhrJ4ttOTA9v2RlqTMWtKBWVNR47kPfxbjIhxW/WPlwckN2GKkaSiRQNGafdHGwrvgP2DofA+IMsHnzMr+3ztorEXkxtvqMh0Ds/2wUyr7aNWEz9MzBg6VIQRhAGxt4ciRxEy+WJHtPtEXH6tc7iahW2+2/waIBpvmX6qkurDwi
 Lsf4OJNP
 lQ9hKsokCuToPBqJm0cbK0dH2Srtw8lfMThRCAEVqRwm5d9p9it/3o7ckvSU2tGoKrgJVDsDn5ya8kxSVepJYevxxwa2n0vdaj+oG9VrjXbmtiAVa0NjFPw3TgoAyVQi3uRlh9X1iN0vNtS14wZAvJsJ1Bh0mG+lI6nSIvNE7niFHjJxC92eCiQMyBwVdjOpvKPb3C6RerlRdFNDPDZZ2/Z1VNkzW7N5Vs5T8/vvdAWez0+ky7WL2kL+8UXB5Ig/lUzPS+LFIdj/Tvm3syd3mJETTX/JLNUZ9KvDIfr767XbZBrfVYLBgG3N6hvNE8nZFnSloA2xFRbOKFt9jwkGYwhv+v1ZdZwAmV9nhCEuZdctwaxGjvZ0N7F3XblApfrZ4ZbK/Ec/UR4evm8NlbPVYd0AYJS3btcoCgMaZAAYYp/ohFKc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add tests for an umapped guest_memfd mempolicy configured at
creation via GUEST_MEMFD_FLAG_BIND_NODE.

Handles:
  - !CONFIG_NUMA (skips)
  - single node system
  - multi-node system (faults onto remote node)
  - invalid arguments (non-zero pad, bad node, node w/o flag).

BIND_NODE is skipped in test_guest_memfd_flags() and testing later
because that loop asserts every advertised flag succeeds on its own,
but BIND_NODE is the only flag that depends on a second field.

Signed-off-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-5
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 84 +++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 1818e0fea5690..b333cb42fab29 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -196,6 +196,83 @@ static void test_numa_allocation(int fd, size_t total_size)
 	kvm_munmap(mem, total_size);
 }
 
+static bool has_bind_node(struct kvm_vm *vm)
+{
+	return vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS) &
+	       GUEST_MEMFD_FLAG_BIND_NODE;
+}
+
+static void test_bind_node_invalid(struct kvm_vm *vm, u64 flags)
+{
+	int fd;
+
+	if (!has_bind_node(vm))
+		return;
+
+	fd = __create_guest_memfd_node(vm, page_size,
+				       flags | GUEST_MEMFD_FLAG_BIND_NODE, 0, 1);
+	TEST_ASSERT(fd < 0 && errno == EINVAL,
+		    "guest_memfd() with non-zero pad should fail with EINVAL");
+
+	fd = __create_guest_memfd_node(vm, page_size,
+				       flags | GUEST_MEMFD_FLAG_BIND_NODE,
+				       1 << 20, 0);
+	TEST_ASSERT(fd < 0 && errno == EINVAL,
+		    "guest_memfd() with out-of-range node should fail with EINVAL");
+
+	fd = __create_guest_memfd_node(vm, page_size, flags, 1, 0);
+	TEST_ASSERT(fd < 0 && errno == EINVAL,
+		    "guest_memfd() with a node but no BIND_NODE flag should fail with EINVAL");
+}
+
+static void test_bind_node(int fd, size_t total_size, int node)
+{
+	const unsigned long other_mask = 1UL << (node ? 0 : 1);
+	const unsigned long maxnode = BITS_PER_TYPE(other_mask);
+	bool steer_away = is_multi_numa_node_system();
+	void *pages[4];
+	int status[4];
+	char *mem;
+	int i;
+
+	mem = kvm_mmap(total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
+	for (i = 0; i < 4; i++)
+		pages[i] = mem + page_size * i;
+
+	/*
+	 * Bind on a different node if possible order to check whether faulting
+	 * happens as desired. Without a second node use the local node and
+	 * just get coverage of create/mmap/fault paths.
+	 */
+	if (steer_away)
+		kvm_set_mempolicy(MPOL_BIND, &other_mask, maxnode);
+
+	/* Deliberately no mbind() on this mapping. */
+	memset(mem, 0xaa, total_size);
+
+	kvm_move_pages(0, 4, pages, NULL, status, 0);
+	for (i = 0; i < 4; i++)
+		TEST_ASSERT(status[i] == node,
+			    "Expected page %d on node %d, got it on node %d",
+			    i, node, status[i]);
+
+	/* Dropped memory should fault back onto the same node */
+	kvm_fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0,
+		      total_size);
+	memset(mem, 0xaa, total_size);
+
+	kvm_move_pages(0, 4, pages, NULL, status, 0);
+	for (i = 0; i < 4; i++)
+		TEST_ASSERT(status[i] == node,
+			    "Expected page %d back on node %d, got it on node %d",
+			    i, node, status[i]);
+
+	if (steer_away)
+		kvm_set_mempolicy(MPOL_DEFAULT, NULL, 0);
+
+	kvm_munmap(mem, total_size);
+}
+
 static void test_collapse(int fd, u64 flags)
 {
 	const size_t pmd_size = get_trans_hugepagesz();
@@ -429,6 +506,10 @@ static void test_guest_memfd_flags(struct kvm_vm *vm)
 	int fd;
 
 	for (flag = BIT(0); flag; flag <<= 1) {
+		/* BIND_NODE depends on a valid node field, test separately */
+		if (flag == GUEST_MEMFD_FLAG_BIND_NODE)
+			continue;
+
 		fd = __vm_create_guest_memfd(vm, page_size, flag);
 		if (flag & valid_flags) {
 			TEST_ASSERT(fd >= 0,
@@ -476,6 +557,7 @@ static void __test_guest_memfd(struct kvm_vm *vm, u64 flags)
 {
 	test_create_guest_memfd_multiple(vm);
 	test_create_guest_memfd_invalid_sizes(vm, flags);
+	test_bind_node_invalid(vm, flags);
 
 	gmem_test(file_read_write, vm, flags);
 
@@ -486,6 +568,8 @@ static void __test_guest_memfd(struct kvm_vm *vm, u64 flags)
 			gmem_test(mmap_supported, vm, flags);
 			gmem_test(fault_overflow, vm, flags);
 			gmem_test(numa_allocation, vm, flags);
+			if (has_bind_node(vm))
+				gmem_test_node(bind_node, vm, flags, 0);
 			__gmem_test(collapse, vm, flags, pmd_size);
 		} else {
 			gmem_test(fault_private, vm, flags);
-- 
2.53.0-Meta


