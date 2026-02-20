Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1718EC5DF66
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 23:54:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28C366B008A; Fri, 20 Feb 2026 18:54:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 223236B008C; Fri, 20 Feb 2026 18:54:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16D6C6B0092; Fri, 20 Feb 2026 18:54:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F140A6B008A
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 18:54:48 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BDE8F1B5420
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 23:54:48 +0000 (UTC)
X-FDA: 84466492656.09.97B7C0A
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf12.hostedemail.com (Postfix) with ESMTP id F2D6040004
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 23:54:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vd61WsB5;
	spf=pass (imf12.hostedemail.com: domain of 3RfSYaQsKCOQGIQKXRKeZTMMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3RfSYaQsKCOQGIQKXRKeZTMMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771631687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E9n+rIu6TMqcCjcRNbiRVZNUoVIfjXuiOSfksLOomjk=;
	b=MQxv2400DAL29I+xh4B94vqVgd9PcIWdBZBSYbLSyLsdR8Lzsj4e6VB/7h64vmbPGFsSde
	K5ouByDxXZ/6Uo9Af1PGuqXR/MqCGlR0ujRDv1CEbGCpTfC23t9oo2uXNz8AvFmOXbtKny
	QDmKVZVzrRwwqkylgI2O8f12EG4b1b8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vd61WsB5;
	spf=pass (imf12.hostedemail.com: domain of 3RfSYaQsKCOQGIQKXRKeZTMMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--ackerleytng.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3RfSYaQsKCOQGIQKXRKeZTMMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771631687; a=rsa-sha256;
	cv=none;
	b=dX61LXQP1HfuXcuJPWEcwlZAMGzNtGN2iP5llHzZ3EkL155yQKCHCq4CZNtZ1SsPYdN3Sp
	AiAPxfhrxnhVfM7XOsONC0OkPg6BHdCuymr9kOqqg2IWhH8k/XIY7k9uc77+nAaghs0dYD
	7YNu1eVoDcr+cPMgfyS9CCwYr8m9beM=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-824ae2c9ff4so8659651b3a.0
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 15:54:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771631686; x=1772236486; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E9n+rIu6TMqcCjcRNbiRVZNUoVIfjXuiOSfksLOomjk=;
        b=vd61WsB59V2CbqU+/4uB/XvZR+c3Via0cyfW06Xu9+NTLhpoGTvefXsE7YlIeLv9qL
         z89CVLnJMJn4OXueH1ZxKNaQ4l10qnz7cbDTxxIIS4roO5p8grpexy65RCBpfwvVpfkH
         5s2TbLFfN2hmXEKxkght+6pEGizOLBizHdcbSed8PH/MhKR5ho1Q1AupzGG4fmmG92dp
         vQPiO0lDAO4i1jC8dpZBDXOQn2ocrh3I4kU3OK1NyQcsrCU2oHwvr3yyBnVzE0U//mXl
         rgQF4qacGR2YPGn3YAiGyQVqp7tp84nzRbzu2EKJmPz0UbL5328kWdeB6Obz6xbEGJ7J
         Zo0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771631686; x=1772236486;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E9n+rIu6TMqcCjcRNbiRVZNUoVIfjXuiOSfksLOomjk=;
        b=BlkwXxzK2XSiCa0f964qeyVoc3t74ZFfCUVUrKwGSCv/oUAHaabXdYo6m7e/VNhajU
         RbP+N9nshqAekxMVFwOyeEZwg4XIGhhnS64DEa8dc34FJJaZ2HxW4Mgvm+27HwQptvq1
         5hc0MFnIPJLvGizBQzWDfdjkZdutkLUOfFIbvP4dRbRNU+ctFY25TNm2hPF12dZDxW71
         6sBnCqskRKQC9v1OjJKauLrSzXWK6s61/FAaQ4IhITonmy1CoGA2/oCHfsSPLCTuU/Tv
         QLu+Rr7qLebf63UQWyfDBY6/VMtSzUuIicR8yFHu5YrUHyEM/mZSfisrBSoFhivSnrIs
         tlaA==
X-Forwarded-Encrypted: i=1; AJvYcCXFHOnE5cDLyk+OehRjTFQmTyDF1AWuWXPVaeapkJrSAOsSox9mad8LMeMDiUh76FtmDjW2FTT7sA==@kvack.org
X-Gm-Message-State: AOJu0YziSKfIwJVPpkgB6MA+p10RKFRifwc9A+pu+CAR/ViJmLLE/64l
	FYLAgKn2kRUgrdkLnG4bEEUzvbyII7OP0HOeJaJgVi60DKUK9mIGTDEvUppAXvIxMcICec2tE4O
	+RnZi3kQeoVt8So6lWS6Wb6owxQ==
X-Received: from pfbjo15.prod.google.com ([2002:a05:6a00:908f:b0:824:bfe3:b54e])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:b92:b0:81f:b3ce:17a3 with SMTP id d2e1a72fcca58-826daa20081mr1165866b3a.48.1771631685524;
 Fri, 20 Feb 2026 15:54:45 -0800 (PST)
Date: Fri, 20 Feb 2026 23:54:36 +0000
In-Reply-To: <cover.1771630983.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1771630983.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <8048d04f150326d1e2231318aa9f1b3fce3e2e2c.1771630983.git.ackerleytng@google.com>
Subject: [PATCH v2 2/2] KVM: selftests: Test MADV_COLLAPSE on guest_memfd
From: Ackerley Tng <ackerleytng@google.com>
To: kartikey406@gmail.com, seanjc@google.com, pbonzini@redhat.com, 
	shuah@kernel.org, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: vannapurve@google.com, Liam.Howlett@oracle.com, ackerleytng@google.com, 
	akpm@linux-foundation.org, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	david@kernel.org, dev.jain@arm.com, i@maskray.me, lance.yang@linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, shy828301@gmail.com, 
	stable@vger.kernel.org, syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com, 
	ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: F2D6040004
X-Rspamd-Server: rspam02
X-Stat-Signature: e6smio8docbeywu33g7gngcrj18ribfs
X-HE-Tag: 1771631686-40113
X-HE-Meta: U2FsdGVkX19YTKDCLVOn4/j5ykU4BQPsaTkLyJFrUiTv8QOkfsI8y5BZerVSyNwbsNKr7PtL8DtRZpu/N64b/8lz0JUsy2h0wOsEbzK/U4VCBHp1hv5quph7j+dJu1Qg/0Ds6VHuLQ8YmDUsFUACMAF/VKTP1FzRZdzgpAsPSFA4UV54UNvoWv/vfD3tYmw3yCm5HZbT+ffO6uUB0nc0/A5S5bCfyh2IE0899NhvdK7XO8RsqfPP/Rl//VWot2Vj1XkG+CzRiZimz2kAlOsfDqnOOviNKDA03+RNt0gw1cl5fx9b1w1QpxfEfzic1DUcPxBi7H1e1GXORkDomNJMDNVsbbGVVmBAoXyA4ZjA/LTmSsjCyfGRejM/mnYPEeGu+groKBGuj0xPlEyG3wXldEjD+XZOrZJxrWVKjFs+yCm5TiP6c5QZxhrOu6eRDD716RfjvLrqEW5oFR/z4dB702oHcqa+OV1Hzc9lcFMRsgPX7lpCwofRvMW87NN4FTGvyuErCM64mnE6C6WQpYofZP5qIXZYM5BsD0My68Wd7GIGESUbgxIBoA/thumefX0Qj48H7wxhIacHtx71nToJ4pI9TtN6TFSWsgcCBAOtxIYUW5JMJ8B+SqYpxIAqN28g0yfMNEkiuFI5ApCOe26Iy9XCRKtEZor1LgVW/vj7x58xnc4EcdS1LDA2vyFRr+uGs8xSWWHq6bUlD9OD5/xROaJAy6sbmigqyOerbWwK64A/hSss/XpjaY9H3JSloh5cP799WHBLZX7rIWSblJec66lmAeHu1L0KEr2bLdEEzwkWxQun3Q4UmNL5pOPvhmAMFsRhjh2qVeuHesN16oOpu7LwKCpzfkhUmmx3mNiHEVqz6Ik7iF2x6r+1rL+nA3Wet7Ft93uU/Ffv1qMk8tFYNx57QB6+NJYNRPkgaMfkMERR9Hop7/1xY1WzgVfXp9w8vtDeTPa6bbh4HBvFAWS
 VjLDLbKY
 hwBHLV4FPJ2S/x/mSdIzv0647TEws70Be3lrj1Gm3XiuFFUfV5UUOLBNOfbYO0Rjmb9OJIHw5p6T1yuXFUu7EnbwGPqH9GT20jaNerdD7rCeFNermsfLPdjh82tZgH9IyCchlrFP1Soiw2tw4lBtOSVbP24G7yainBh2qJmv2GJSu3USJRSx98HGrB+p0F0PuF6mwPnY8Q2NnextFjiYbrEpN9MDMoya7M0WS/IA+463CuHvQ3Iojrha0r5gOwZw4zdMmgkmPgbHIDLo3pY1bFDRB3Fp5uwVTvVn4SpW+yRp1NMiouDR/eeSbw4qtACMLBfrv+ShN0XYd+oUVl7Z40NPKJ0SQce2o3lte3IjG2WYmaze2OWBT7jqXz28esUqG4h6vDpw6AMdEDJcnPC5Hx8+EzVH57SzbaLabKLyOta5g+ZpidZy6C47tLdvTUp/xdQuM26W6kgUUQXGIPxC7GYoNinE8TlAUUC7vQ/tIzQ4wabcqg1/FHkLd4JF+Ex2uW5uoq1YKxZ2EyTn7J68D/wAZOtX1jJ43ISb29feKA6e7CUb+RpAUfEyuAk5HIXHIN5tsNUpKY2qFdKUpyPO/6pA6S0ovW0nTocsmShdfAEnPMoYuWa7HzXQsmMkR5IVR5Bh693h4IbwQ1Bv4TvaQY0AcdOxFGtHhZ41T30ZHOZGLGi/YT91HCK63l5oz4yhmLibC1n6LJ9+orUL2s3BuJXtBBiD2TsbKbsVwW+GgnvfQX8+O6uujFm/rnOhAY91BtUB91JFxG6acmYa+TQsgIK7ELVjnzvivrsg7CJWvlNo3v85ioGFPgZSIQGabCIvhlOzC2LzBumt7YLjujvVkUMQAgaWzc9E2gmbEZfA/INxcX0wrpHj2B+k4lkO8EphXuVniSc8aUax6zPA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

guest_memfd only supports PAGE_SIZE pages, and khugepaged or MADV_COLLAPSE
collapsing pages may result in private memory regions being mapped into
host page tables.

Add test to verify that MADV_COLLAPSE fails on guest_memfd folios, and any
subsequent usage of guest_memfd memory faults in PAGE_SIZE folios. Running
this test should not result in any memory failure logs or kernel WARNings.

This selftest was added as a result of a syzbot-reported issue where
khugepaged operating on guest_memfd memory with MADV_HUGEPAGE caused the
collapse of folios, which then subsequently resulted in a WARNing.

Link: https://syzkaller.appspot.com/bug?extid=33a04338019ac7e43a44
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 70 ++++++++++++++++++-
 1 file changed, 67 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 618c937f3c90f..0edbc7cf6c1ad 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -171,6 +171,64 @@ static void test_numa_allocation(int fd, size_t total_size)
 	kvm_munmap(mem, total_size);
 }
 
+static void test_collapse(int fd, uint64_t flags)
+{
+	const size_t pmd_size = get_trans_hugepagesz();
+	void *reserved_addr;
+	void *aligned_addr;
+	char *mem;
+	off_t i;
+
+	/*
+	 * To even reach the point where the guest_memfd folios will
+	 * get collapsed, both the userspace address and the offset
+	 * within the guest_memfd have to be aligned to pmd_size.
+	 *
+	 * To achieve that alignment, reserve virtual address space
+	 * with regular mmap, then use MAP_FIXED to allocate memory
+	 * from a pmd_size-aligned offset (0) at a known, available
+	 * virtual address.
+	 */
+	reserved_addr = kvm_mmap(pmd_size * 2, PROT_NONE,
+				 MAP_PRIVATE | MAP_ANONYMOUS, -1);
+	aligned_addr = align_ptr_up(reserved_addr, pmd_size);
+
+	mem = mmap(aligned_addr, pmd_size, PROT_READ | PROT_WRITE,
+		   MAP_FIXED | MAP_SHARED, fd, 0);
+	TEST_ASSERT(IS_ALIGNED((u64)mem, pmd_size),
+		    "Userspace address must be aligned to PMD size.");
+
+	/*
+	 * Use reads to populate page table to avoid setting dirty
+	 * flag on page.
+	 */
+	for (i = 0; i < pmd_size; i += getpagesize())
+		READ_ONCE(mem[i]);
+
+	/*
+	 * Advising the use of huge pages in guest_memfd should be
+	 * fine...
+	 */
+	kvm_madvise(mem, pmd_size, MADV_HUGEPAGE);
+
+	/*
+	 * ... but collapsing folios must not be supported to avoid
+	 * mapping beyond shared ranges into host userspace page
+	 * tables.
+	 */
+	TEST_ASSERT_EQ(madvise(mem, pmd_size, MADV_COLLAPSE), -1);
+	TEST_ASSERT_EQ(errno, EINVAL);
+
+	/*
+	 * Removing from host page tables and re-faulting should be
+	 * fine; should not end up faulting in a collapsed/huge folio.
+	 */
+	kvm_madvise(mem, pmd_size, MADV_DONTNEED);
+	READ_ONCE(mem[0]);
+
+	kvm_munmap(reserved_addr, pmd_size * 2);
+}
+
 static void test_fault_sigbus(int fd, size_t accessible_size, size_t map_size)
 {
 	const char val = 0xaa;
@@ -350,14 +408,17 @@ static void test_guest_memfd_flags(struct kvm_vm *vm)
 	}
 }
 
-#define gmem_test(__test, __vm, __flags)				\
+#define __gmem_test(__test, __vm, __flags, __gmem_size)			\
 do {									\
-	int fd = vm_create_guest_memfd(__vm, page_size * 4, __flags);	\
+	int fd = vm_create_guest_memfd(__vm, __gmem_size, __flags);	\
 									\
-	test_##__test(fd, page_size * 4);				\
+	test_##__test(fd, __gmem_size);					\
 	close(fd);							\
 } while (0)
 
+#define gmem_test(__test, __vm, __flags) 				\
+	__gmem_test(__test, __vm, __flags, page_size * 4)
+
 static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
 {
 	test_create_guest_memfd_multiple(vm);
@@ -367,9 +428,12 @@ static void __test_guest_memfd(struct kvm_vm *vm, uint64_t flags)
 
 	if (flags & GUEST_MEMFD_FLAG_MMAP) {
 		if (flags & GUEST_MEMFD_FLAG_INIT_SHARED) {
+			size_t pmd_size = get_trans_hugepagesz();
+
 			gmem_test(mmap_supported, vm, flags);
 			gmem_test(fault_overflow, vm, flags);
 			gmem_test(numa_allocation, vm, flags);
+			__gmem_test(collapse, vm, flags, pmd_size);
 		} else {
 			gmem_test(fault_private, vm, flags);
 		}
-- 
2.53.0.345.g96ddfc5eaa-goog


