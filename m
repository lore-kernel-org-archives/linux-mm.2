Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5516010AB82B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:25:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FD916B00B8; Thu, 26 Mar 2026 18:25:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D4EB6B00BA; Thu, 26 Mar 2026 18:25:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EB566B00BB; Thu, 26 Mar 2026 18:25:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 388CF6B00B8
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D163E1405B2
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:06 +0000 (UTC)
X-FDA: 84589645812.13.F16A722
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0E1BC120004
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L7tT0tET;
	spf=pass (imf29.hostedemail.com: domain of 3P7LFaQsKCBAqs0u71uE93ww44w1u.s421y3AD-220Bqs0.47w@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3P7LFaQsKCBAqs0u71uE93ww44w1u.s421y3AD-220Bqs0.47w@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N0AfLg74ibzAu140IbuS6KqPXC4lmrO5NcvdvIrpN3Y=;
	b=Ev+1H8g7p5mgCZBTlmgRU7+6jG7Jeqq+e1ZZv9jBhBK3AhqWBp6Pl/w5MUpC4NP8Zl8rI1
	hASyCXzFN1wpLk2BwvLWJHi1IfkoS9efW6UIT9rVK4d5pgjMveNpstoVcGx26Q5saqhnG1
	0mkKZRDhzKIsIBNcv+6qzP/oWMlBYns=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563905; a=rsa-sha256;
	cv=none;
	b=OM6P3oaiqTN56fACc7IrfueFhjsN6F2knnnFhh1sui8ssGCxaawzdHokPdg0sDQR/DHGQ6
	BNCT/Fg/9uJpYP8WuaPAFE3rKMgu4BA21f6szkUFk9WnPaxm00UxSPz+iMZbHWa/HPTRCq
	BKGc4GInlBDqrzB8dd5mlkY6B72ga5M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L7tT0tET;
	spf=pass (imf29.hostedemail.com: domain of 3P7LFaQsKCBAqs0u71uE93ww44w1u.s421y3AD-220Bqs0.47w@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3P7LFaQsKCBAqs0u71uE93ww44w1u.s421y3AD-220Bqs0.47w@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35845fcf0f5so1980063a91.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:25:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563904; x=1775168704; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=N0AfLg74ibzAu140IbuS6KqPXC4lmrO5NcvdvIrpN3Y=;
        b=L7tT0tET+CIKf+/Omz1KI1JKhq/VcYAtmkBj2xURQq1sB01UlRCfiZircbjCsJ2/Li
         L0o2cjsA2hBOmTxaJ+pNCMtXks9TsGTAXfk8T67+853HOPjacbL5YEONyxI8pxqIDvcH
         vQOw3HQ0aKHn/VyWMb7s+xgPd5RvrsY0QtdDH76Q3kZZm4PTh70260eUBEJeY029EqQ1
         zv9l5SnBOwFVdO91TXkyw8QnHo0wjQtdOuuuCfihoVVRGB3Zbeca+4JDqJuBDXMd/u4+
         TsPequNAsMQg5YMHRzFtzoccsdtPsi+CZsAmwokmt6kUteoWC6q8hK+wd0w0vLmZAlR5
         Al2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563904; x=1775168704;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N0AfLg74ibzAu140IbuS6KqPXC4lmrO5NcvdvIrpN3Y=;
        b=JivCYwV9JU79Go/oRWov2s4xcanP29E4P57JmMZHMeiZUrtBvKFoiYBgZ20IJnTz3P
         yp1ReoU4vjA5rqiykVIMtu25lwsAEXjJ7ccBD4/xj71BUTbSeUgqVel/DgLmAdA7IFMR
         KJU9JJz4GmREa8Y0ZuJr8rKCrz27uZOTlVkTTKuqLQsJ4Jp5cWGBJmt4aL4fitVbhAL3
         AUZGZUHG/6P+Shi+ypibrP6UgXMiWvva0AEpNE1UTIuk5PkQywbviZSD8JJRDLOpHw2f
         O8Y1ofLmpoQBNNNcvDFAYzP0cfuGrbQ+0BgfX6607N8uHohIwh+arGZGMpkI1IlyW+2O
         YLgg==
X-Forwarded-Encrypted: i=1; AJvYcCUF+USmDScYhBIYmJdV8/HRhNZPMXAlzvqunXkWdXmbdsRFOHEF8L9EvIxrY/CojqldTmyamwp8QA==@kvack.org
X-Gm-Message-State: AOJu0YzoME5JIb4iwOeAqKByfOjiHnDQ8mGwvOEJ4Zl5Yg9lG1u6YIoc
	ZKZbt68wYfM3pw9U3lrAJx7+84TXLbh4GcUlsNJeeonxeoZ6Toid31Sh18nysR0Lu9l0RBKdXl6
	IvfzpwIZZR6tnNjhTTlb+0MJJjg==
X-Received: from pgkk190.prod.google.com ([2002:a63:24c7:0:b0:c74:0:159])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:d814:b0:35c:2c52:36fd with SMTP id 98e67ed59e1d1-35c2c52382fmr821726a91.6.1774563903368;
 Thu, 26 Mar 2026 15:25:03 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:28 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=5219;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=dxbgvaJqRZzv2vGZ9u5pjomGspaIbZaRbW4aKAljf7k=; b=wV0d4J61F+88MMmUOEj8SB8tpW2u2ELih6nXIkge/TuEF4oY1ccRCo7VZ9HK9VqJJRu358hu/
 9pcZhQytEw+C/MBAPE/saZD1ovxLtloKGpZJ2GX1KLWmd0vnkFDA9wg
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-19-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 19/44] KVM: selftests: Rename guest_memfd{,_offset} to gmem_{fd,offset}
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 0E1BC120004
X-Stat-Signature: syqk4cna9fea1frhggbiomkpcnk693tt
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774563904-854053
X-HE-Meta: U2FsdGVkX19LYtvTWielJXkcsb+wxbNn1s+OO8+1RfNpEOUvZEi9dsFxzgbyWjjAXxyCPMVF9xtJmkIgnegg+fqpGBeyZxvLJXC0jI27naychKIhriCl4riJL86dzJxX3ITlT2xw3Nmly9/yUh89Cym3bZLU2JgAhxYuYdBaX9Zob9ujHQfVyd1ILCxsRjZefR5fZWoKLPCAeHjcXq1oTibvRTX8ANKGAIIZ8RmogpgKxHLjnwce6OerKvEZOq8pW6eCipOkZQ4qCmC9rhK2PuK023DikvaEKl3mnrR3FwSnrEYXbFwE1N6kmUWH9JQUNMdgqnxvOJAhBujnQFz3QnMmeQLWN3bnSC0NQO8rFA5vDDwKw2hOdy4qaiyIQwIsMa81i1dHpWs0uMNOdL48lS9XL5L1qm5ctaetEPLjJOLxLd55iRcModWuqjSPoWvCMQr9XGlHmoZk50xEOUtzaYZfc5A/+ogXubtOlXrPtT080tKDFqor7P6B+ojrwMg5Dv+HhVzzBoPvfdO3yqf2bsm7i+3jcXI9cFr6fpgvPJO56I/XZPk4Kn4CmaIp1m6QG92YjMvFRGcRTpN8AA+C4MDTVUXNkFQOnN4Eq3mZDqZ4jc1z9jmaCiIeVKzOTYdmXjoj5ki4FcyRxF6jTXJ1fB9i5dNrMIWtlKbaevtkClFhfbZWA0dnF2epoYBiwcskjnaGK9Eq6ozBfhc5XjWjxapOB5+akmuqZMaC2Q1E2A++CrNsoHIkgyHVrMqM7D8TBzK7imyCirGZb7uuGlESW4VDHfrBNXG9XdcgO1RKd/1CD8xym514Wd4FotucwXrN/Pf7HDjL8ZXxj5s4VXkzaK6SjDu6HHYhnmBh2WoboHYIboNYSMP3iwYTGqxyY5GKpGgG1ODARpI2m6hWicetq/2i7uS5uFf7dSk5VwF3BAhYO7tIuUSUKj2ylUDhELI0vm7+bsjyihKnMuNNaD0
 iEeJXrQk
 dr7VcgM13jYRKYaKw58X55+MJ410ey96qhR4UUNp9aQuMo/ifbq9r981AwrHK8wdenUMi4Ek/yiMj7aw8noek1GCMyLwdYEdVRbLs/yzZS2amObMrVPgpWGvesWa4YgpOOg8UErR9ZeZUmM4IUFhV3fAhwr+P8Oi+oEu1rklJ0XP4U+Xz17UDAEFtvW/ZkDg7WsRNm+iV7Kria6Ix4kNMobtmJ7rp+bscRJoqHAITzkA8+TJHDD+a6Ickiou2X+McAexVAyRV8lCsidrcEQqRdto7UaojHk4QNzXUTSQILoYKbJRa+PhhN+DH1RV3DnDtGEEPrYwykOI6dznXeFTZIALlP9yrlAXHK+7u0IcGT7KCYXSDjWkVg6+xYnCqkcOGKC8qC5izCKrENPZ4Q/ECC+qq0JRgUnzZYqKhgI/4eoMcsaw+zVnz/TY34XUuwG1Hw1pvflRiOu+Ey59jf0l9lleR7735AHfuV+xNIjRpCadBhOmk7iY/prPdCw0UT61Ka/r/JQTbz4ECJhzlmWG5DBzGyFiQ4QP0OajHf1qo49uFZTfXWAf3EL+zB9i1cFVH+tFUAediV486WW5xO9W2v3l5a8gs7rbpN6vIvdi2QjWM+68ncAcSfBRvUrwPMIHgrvmYwyS4Te+Uzgm/H0cb9Dg0+IcDKY7zoSaozhPp/LXGrV5gauN6rvBjGEg2H1jEtckIjlAGOJSazwLJAr44W4DNcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Rename local variables and function parameters for the guest memory file
descriptor and its offset to use a "gmem_" prefix instead of
"guest_memfd_".

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h |  6 +++---
 tools/testing/selftests/kvm/lib/kvm_util.c     | 26 +++++++++++++-------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 8b39cb919f4fc..b2d35824f2a72 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -690,10 +690,10 @@ int __vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags
 				uint64_t gpa, uint64_t size, void *hva);
 void vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
 				uint64_t gpa, uint64_t size, void *hva,
-				uint32_t guest_memfd, uint64_t guest_memfd_offset);
+				uint32_t gmem_fd, uint64_t gmem_offset);
 int __vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
 				 uint64_t gpa, uint64_t size, void *hva,
-				 uint32_t guest_memfd, uint64_t guest_memfd_offset);
+				 uint32_t gmem_fd, uint64_t gmem_offset);
 
 void vm_userspace_mem_region_add(struct kvm_vm *vm,
 				 enum vm_mem_backing_src_type src_type,
@@ -701,7 +701,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 				 uint32_t flags);
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		uint64_t gpa, uint32_t slot, uint64_t npages, uint32_t flags,
-		int guest_memfd_fd, uint64_t guest_memfd_offset);
+		int gmem_fd, uint64_t gmem_offset);
 
 #ifndef vm_arch_has_protected_memory
 static inline bool vm_arch_has_protected_memory(struct kvm_vm *vm)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 610cb32ff207e..3b64fbadcd88d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -947,7 +947,7 @@ void vm_set_user_memory_region(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
 
 int __vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
 				 uint64_t gpa, uint64_t size, void *hva,
-				 uint32_t guest_memfd, uint64_t guest_memfd_offset)
+				 uint32_t gmem_fd, uint64_t gmem_offset)
 {
 	struct kvm_userspace_memory_region2 region = {
 		.slot = slot,
@@ -955,8 +955,8 @@ int __vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flag
 		.guest_phys_addr = gpa,
 		.memory_size = size,
 		.userspace_addr = (uintptr_t)hva,
-		.guest_memfd = guest_memfd,
-		.guest_memfd_offset = guest_memfd_offset,
+		.guest_memfd = gmem_fd,
+		.guest_memfd_offset = gmem_offset,
 	};
 
 	TEST_REQUIRE_SET_USER_MEMORY_REGION2();
@@ -966,10 +966,10 @@ int __vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flag
 
 void vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags,
 				uint64_t gpa, uint64_t size, void *hva,
-				uint32_t guest_memfd, uint64_t guest_memfd_offset)
+				uint32_t gmem_fd, uint64_t gmem_offset)
 {
 	int ret = __vm_set_user_memory_region2(vm, slot, flags, gpa, size, hva,
-					       guest_memfd, guest_memfd_offset);
+					       gmem_fd, gmem_offset);
 
 	TEST_ASSERT(!ret, "KVM_SET_USER_MEMORY_REGION2 failed, errno = %d (%s)",
 		    errno, strerror(errno));
@@ -979,7 +979,7 @@ void vm_set_user_memory_region2(struct kvm_vm *vm, uint32_t slot, uint32_t flags
 /* FIXME: This thing needs to be ripped apart and rewritten. */
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		uint64_t gpa, uint32_t slot, uint64_t npages, uint32_t flags,
-		int guest_memfd, uint64_t guest_memfd_offset)
+		int gmem_fd, uint64_t gmem_offset)
 {
 	int ret;
 	struct userspace_mem_region *region;
@@ -1062,12 +1062,12 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		region->mmap_size += alignment;
 
 	if (flags & KVM_MEM_GUEST_MEMFD) {
-		if (guest_memfd < 0) {
-			uint32_t guest_memfd_flags = 0;
+		if (gmem_fd < 0) {
+			uint32_t gmem_flags = 0;
 
-			TEST_ASSERT(!guest_memfd_offset,
+			TEST_ASSERT(!gmem_offset,
 				    "Offset must be zero when creating new guest_memfd");
-			guest_memfd = vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);
+			gmem_fd = vm_create_guest_memfd(vm, mem_size, gmem_flags);
 		} else {
 			/*
 			 * Install a unique fd for each memslot so that the fd
@@ -1075,11 +1075,11 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 			 * needing to track if the fd is owned by the framework
 			 * or by the caller.
 			 */
-			guest_memfd = kvm_dup(guest_memfd);
+			gmem_fd = kvm_dup(gmem_fd);
 		}
 
-		region->region.guest_memfd = guest_memfd;
-		region->region.guest_memfd_offset = guest_memfd_offset;
+		region->region.guest_memfd = gmem_fd;
+		region->region.guest_memfd_offset = gmem_offset;
 	} else {
 		region->region.guest_memfd = -1;
 	}

-- 
2.53.0.1018.g2bb0e51243-goog


