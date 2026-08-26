Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C648C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C104C6B00B8; Wed, 26 Aug 2026 05:18:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B48516B00B9; Wed, 26 Aug 2026 05:18:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9503A6B00BA; Wed, 26 Aug 2026 05:18:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6BB116B00B8
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:18:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC924C02E7
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:56 +0000 (UTC)
X-FDA: 85142871072.01.6F6B6BA
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2CD44100004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:18:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pJr7t3gu;
	spf=pass (imf14.hostedemail.com: domain of 3fa-OagsKCHIQSaUhbUojdWWeeWbU.SecbYdkn-ccalQSa.ehW@flex--ackerleytng.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3fa-OagsKCHIQSaUhbUojdWWeeWbU.SecbYdkn-ccalQSa.ehW@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nW/Bx4P2jJT94oLQdzkm368Cs7uj0juF0EvPF05mG7A=;
	b=e2d8nVtFHob4kMIEvZHKtLKLshsTrayxIuEAhSGD2Lq8THorKZN/4cJDvSKAyXIr/sZ1yG
	+VB+fE2TtjB5Rjios1xaniw27HXWN+M7odMMIptSIx0EsisVaa438eCVcBzqiSqnMt8nsV
	4HJK503isoQXlMf1HX8cQXLC8MTp0TU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pJr7t3gu;
	spf=pass (imf14.hostedemail.com: domain of 3fa-OagsKCHIQSaUhbUojdWWeeWbU.SecbYdkn-ccalQSa.ehW@flex--ackerleytng.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3fa-OagsKCHIQSaUhbUojdWWeeWbU.SecbYdkn-ccalQSa.ehW@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735935;
	b=ZEJHa6LJyWWL3g9nSkcAGseiPs97Cdzdmf6ZdJrls3Y/9zOnHPJwtNt3RbZ7mStKCLOkk7
	MdnuROTNw8AsduOLuRlDfw6yGLi+PGknC1zrRA53U5ddQtSnyzwyffrT3Y8b0YqieiS9Zu
	2b9NnWaEWMsMBkTJQCl2198L9STJp/Y=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2d02df2bf09so8166965ad.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735934; x=1788340734; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nW/Bx4P2jJT94oLQdzkm368Cs7uj0juF0EvPF05mG7A=;
        b=pJr7t3guUVhmgfBRTYQ20A3zQrwfJW8GxEGKp6DWG07fRIym2uA9dw9IpS4MROuaLe
         +KuimtuqyQ9GmIGYR1SI9+5bagFDi5W1j/ydJfX6hGrRXsoqx6jhgC3faKIl7H79qiQF
         u2GZmTvgCoKvILU1QAdHqaZm+7VH5FC7c4fh6YY6GgCSuRhFuRMgOr0oBdwRfsVTDTKp
         VWj250eV1ZWmb72IFw9DmTVIIDkS/lZ72c4ykg6vB+OARsQ/dnZB//NuiR6uIxeUM2NG
         7s4kjIfU0+/J7QvIJYMgZ9th3YvMTWEAnORdk48DBZH9yEXrfIGoFPnB0seAtOrlxOZe
         8nlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735934; x=1788340734;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nW/Bx4P2jJT94oLQdzkm368Cs7uj0juF0EvPF05mG7A=;
        b=eeAmS6GPA/7JItFYyJ7vAcbwPE8XCTSKcRGYZoPZ4oM0Ut28t1sRXH9vDO3goiOZnX
         iBC01CWYuj0SKpnJXln3C2m6i/KW+4yZ+AhLvW3oQyTauWateQqBXsMl7jdWYI3jijif
         Bxh2sNAMewS78zzcZk98v+VkM4ARckHLc4u84dJ92yGp22PsLZQNOZSy2PyeTjGk+qZA
         lB5rppE0Soi7NBYzJGufsrbKkkVb9GeHWTe18CeEB/9zMJI95hb8urimAv7M4OJkP+SV
         bk4sCag9xLHFH6hQRZJ/UFAgZmc8CCv/uLLR+I571ojuUYvghykeKdzsQoYMq/M4YPjz
         NgFg==
X-Forwarded-Encrypted: i=1; AHgh+RqJDtBdKp+H+seiw8VOWRsoGZ39GLpMSV2Te8wY0NjCkYxcfk/3zIok2x1q43MM7AiXvSMXslAsLQ==@kvack.org
X-Gm-Message-State: AFuF++kMm8FdOdivsMgPimyEa+Z5g3XkFf80ibk4MLLUJwdEsuVvaSXB
	hN+5mRLMNQ4dIjtntXLdeDQ7PouRGepCD3Uh/E4FQOrKKXO+UKUb473biIQcNTsdIDsabHSEkCs
	gnFBuWw45Qe2NM4UPpMn1qu15Ew==
X-Received: from plma15.prod.google.com ([2002:a17:902:7d8f:b0:2c7:f19d:bb15])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1104:b0:2d6:e401:9676 with SMTP id d9443c01a7336-2d707955aa3mr86624575ad.1.1787735933588;
 Wed, 26 Aug 2026 02:18:53 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:25 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=6306;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=iH6mV6vz9nv+7yGhH2glpEiB5Axbc8NLNwkfFuGS8bc=; b=eeGISm57LUVrThy3WYFRGn0ADNhx8cOa1mhGNQcmpPGa+nPA+FZFKYI6zPgeud/R7Bz1UVu2i
 A8ITRzICJzPAmUnWNb5K4m8g1JY/EWxBUD1EWrzSGQgoaH1E6OTBAWA
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-27-0a15d8a799aa@google.com>
Subject: [PATCH v11 27/46] KVM: selftests: Add support for mmap() on
 guest_memfd in core library
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
	suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
	Fuad Tabba <fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: qxnckbxpntsxfpok4zkkt9mda4kup1mn
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2CD44100004
X-Rspam-User: 
X-HE-Tag: 1787735934-251629
X-HE-Meta: U2FsdGVkX1+Gaqis2T1rJpUZ1EwhwH1C3uFCpUYBAIiSKhIdt3GpcPulfEVs7mZPVRmhaqmu2vYSvE/hlJfM7FrXG+XkCQqtHDM6q91vvDG0BWuFc66b0f3ZfvWp7DbH7/2BAdtG889zWPx1jpcaW2ttYPFFNGH9R4YfzOfhZmsPyoVlA156C85u9vulNV8QCYwHydjJAOsmrcv6Unk0Om7b01sIqIoqQonHCnDRylqwBhMr04xYU5e0NjFk+ZiiC/3t9e6n6xl8+5tbnOORq0HSKAkPsjv5K49gzfYS++0Kp28WkAA1Q4jsHxAwdxtss49ig3/9dZDQcleyeTDPNR9UsBiMuphSiAPWgZYJyt6AfRad6C7GcgKePltw+DIYOozDHIPol2nf5n8fwh2fgZZ4OG5bnyqsCQMAxmG233huRUW9v2XqMvRTiab7RW8lh5SqDeIq2eSnr6kWhFg+BNXkjUtRORZjXXGMHpjH4R5Ld2Q89MZXse1ikx0xcklwmhwsLHfgcskOf0JVR7vDbuD0BCpB7ytDqB+8Z9OgxPE4jLub85hfMWUXNa38+2dZ5KnNng5MAqYOj9CABk1pBQPoyg7eUyGr+/zS2F89HxhCNOD4PB2XZbz71cQDV5A1uhRHnqDTceW7P6iIFEE6NjgRpac2V3KA2jiYAXA+CyokRHaw6Lt8aFyRwOuO/d79AAUZxUPVJNnJZw5OiU5362LqaOr05lcJKmWEbFWnUtXRfcffy/jx1lspthGeFxMcKZIhBy81Xg1g2KAxvqUNe6WNgAvefepeK+PXecnCKZrvAJfU1mR+abibww08vyiNGgrfR9m16RKh9SNX+HelYegYSVHKEcWUQTJXdfQHheADCfgfsJbx2G7/6ei+LQ+s8b3dbXdwBI47sEJZv4mkwJiX8exGqKFNtage4MjloZpUGe24KMh/eLrfGCca9/m14vdv1LgIMLl0BZXCSHl
 3aIaGPmt
 LogevUfzZi+P1ebW/hI3MuS+67FB+SjqyNMccYSAzEC4Nq0ZjQRSavsgNMeP/9YCoSE2+eBVWHbbXc/tFYrqfXZVxr3+HpQjsE7B4NDTMrunBcEvR5HEISETKGu0rmO9oLMoDXww6tBNTEjzDBSo8DayQcux6BRAMNanH0MNCHQCWspHartYRm11jv2m3MrcJTT8UbJhX2+V9WV8cK9c0nl4fA7zHDX2NqrfUp+gIOttYOoMSfWlsbZTmLMe5dCKYmJKbgVW4ynd72ko05XbR99/72D98ATtj+rcswtj3Y9zbKXwFM+OtUhMhwtCim6GpTJGk57uPwRp3oLuygyEMiswbBOifGfOeUaMDWMb9yXwsLdW35cyS71gl+LtztaPlVuEKPu9vwE4bwZKrSKNoCBjYKEaOEETjJPYKysW2IKqqjdARkdWv/Ohi87MJnd4TF67iU0AwBimCDPWfvuHYUP3V9N0AdZ4FLo64Q91QZqzrg6WfWIPMiP4qJUYyKEc9fjcFsJBfDGrgDW75mLNSBJwH3X9DJJO916xOijxl17aLC96pfvXqMRM6tZK1cpvLnJp0i2hDEPzUhlRPZUkAFdsfcYI7mZYgGhk6I3D//DZW2hhvuESVzgR1bCG3D4NHXai5tmT6JKQqq+ZFx78k/Lcr9X5h8mt/rKTo2eihnq8tiFenRq2+/flg/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Accept gmem_flags in vm_mem_add() to be able to create a guest_memfd within
vm_mem_add().

When vm_mem_add() is used to set up a guest_memfd for a memslot, set up the
provided (or created) gmem_fd as the fd for the user memory region. This
makes it available to be mmap()-ed from just like fds from other memory
sources.

For guest_memfds, mmap() using gmem_offset instead of 0 all the time.

Always use MAP_SHARED if mmap-ing from guest_memfd instead of reading flag
from the configured src_type, which doesn't include guest_memfd.

Add a kvm_slot_to_fd() helper to provide convenient access to the file
descriptor of a memslot.

Update existing callers of vm_mem_add() to pass 0 for gmem_flags to
preserve existing behavior.

Signed-off-by: Sean Christopherson <seanjc@google.com>
[mmap() with gmem_offset, and always with MAP_SHARED.]
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h     |  7 +++++-
 tools/testing/selftests/kvm/lib/kvm_util.c         | 28 ++++++++++++----------
 .../kvm/x86/private_mem_conversions_test.c         |  2 +-
 3 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index cf49a84de02e8..a091c495442a1 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -700,7 +700,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 				 gpa_t gpa, u32 slot, u64 npages, u32 flags);
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		gpa_t gpa, u32 slot, u64 npages, u32 flags,
-		int gmem_fd, u64 gmem_offset);
+		int gmem_fd, u64 gmem_offset, u64 gmem_flags);
 
 #ifndef vm_arch_has_protected_memory
 static inline bool vm_arch_has_protected_memory(struct kvm_vm *vm)
@@ -732,6 +732,11 @@ void *addr_gva2hva(struct kvm_vm *vm, gva_t gva);
 gpa_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
 void *addr_gpa2alias(struct kvm_vm *vm, gpa_t gpa);
 
+static inline int kvm_slot_to_fd(struct kvm_vm *vm, u32 slot)
+{
+	return memslot2region(vm, slot)->fd;
+}
+
 #ifndef vcpu_arch_put_guest
 #define vcpu_arch_put_guest(mem, val) do { (mem) = (val); } while (0)
 #endif
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index af501a27211a2..08d0bbcd421ea 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1002,12 +1002,14 @@ void vm_set_user_memory_region2(struct kvm_vm *vm, u32 slot, u32 flags,
 /* FIXME: This thing needs to be ripped apart and rewritten. */
 void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 		gpa_t gpa, u32 slot, u64 npages, u32 flags,
-		int gmem_fd, u64 gmem_offset)
+		int gmem_fd, u64 gmem_offset, u64 gmem_flags)
 {
 	int ret;
 	struct userspace_mem_region *region;
 	size_t backing_src_pagesz = get_backing_src_pagesz(src_type);
+	int mmap_flags = vm_mem_backing_src_alias(src_type)->flag;
 	size_t mem_size = npages * vm->page_size;
+	off_t mmap_offset = 0;
 	size_t alignment = 1;
 
 	TEST_REQUIRE_SET_USER_MEMORY_REGION2();
@@ -1079,8 +1081,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
 	if (flags & KVM_MEM_GUEST_MEMFD) {
 		if (gmem_fd < 0) {
-			u32 gmem_flags = 0;
-
 			TEST_ASSERT(!gmem_offset,
 				    "Offset must be zero when creating new guest_memfd");
 			gmem_fd = vm_create_guest_memfd(vm, mem_size, gmem_flags);
@@ -1101,13 +1101,17 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 	}
 
 	region->fd = -1;
-	if (backing_src_is_shared(src_type))
+	if (flags & KVM_MEM_GUEST_MEMFD && gmem_flags & GUEST_MEMFD_FLAG_MMAP) {
+		region->fd = kvm_dup(gmem_fd);
+		mmap_flags = MAP_SHARED;
+		mmap_offset = gmem_offset;
+	} else if (backing_src_is_shared(src_type)) {
 		region->fd = kvm_memfd_alloc(region->mmap_size,
 					     src_type == VM_MEM_SRC_SHARED_HUGETLB);
+	}
 
-	region->mmap_start = kvm_mmap(region->mmap_size, PROT_READ | PROT_WRITE,
-				      vm_mem_backing_src_alias(src_type)->flag,
-				      region->fd);
+	region->mmap_start = __kvm_mmap(region->mmap_size, PROT_READ | PROT_WRITE,
+					mmap_flags, region->fd, mmap_offset);
 
 	TEST_ASSERT(!is_backing_src_hugetlb(src_type) ||
 		    region->mmap_start == align_ptr_up(region->mmap_start, backing_src_pagesz),
@@ -1153,10 +1157,10 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backing_src_type src_type,
 
 	/* If shared memory, create an alias. */
 	if (region->fd >= 0) {
-		region->mmap_alias = kvm_mmap(region->mmap_size,
-					      PROT_READ | PROT_WRITE,
-					      vm_mem_backing_src_alias(src_type)->flag,
-					      region->fd);
+		region->mmap_alias = __kvm_mmap(region->mmap_size,
+						PROT_READ | PROT_WRITE,
+						mmap_flags, region->fd,
+						mmap_offset);
 
 		/* Align host alias address */
 		region->host_alias = align_ptr_up(region->mmap_alias, alignment);
@@ -1167,7 +1171,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 				 enum vm_mem_backing_src_type src_type,
 				 gpa_t gpa, u32 slot, u64 npages, u32 flags)
 {
-	vm_mem_add(vm, src_type, gpa, slot, npages, flags, -1, 0);
+	vm_mem_add(vm, src_type, gpa, slot, npages, flags, -1, 0, 0);
 }
 
 /*
diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index 3aa0673f79f33..f3de2a4ab0551 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
@@ -399,7 +399,7 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, u32 nr_v
 	for (i = 0; i < nr_memslots; i++)
 		vm_mem_add(vm, src_type, BASE_DATA_GPA + slot_size * i,
 			   BASE_DATA_SLOT + i, slot_size / vm->page_size,
-			   KVM_MEM_GUEST_MEMFD, memfd, slot_size * i);
+			   KVM_MEM_GUEST_MEMFD, memfd, slot_size * i, 0);
 
 	for (i = 0; i < nr_vcpus; i++) {
 		gpa_t gpa =  BASE_DATA_GPA + i * per_cpu_size;

-- 
2.55.0.887.g758fc8c411-goog


