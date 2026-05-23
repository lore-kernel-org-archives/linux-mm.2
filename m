Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A099CD5BC2
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:18:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C98C76B00A7; Fri, 22 May 2026 20:18:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C22756B00AC; Fri, 22 May 2026 20:18:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A48996B00A7; Fri, 22 May 2026 20:18:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 898256B00A6
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 538131C0097
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:10 +0000 (UTC)
X-FDA: 84796772340.11.03BF202
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 66ADD140009
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eFLpf7aQ;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495488;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T67rUd3leUtAUBhFa4aGeKcYLS/5n2b/prJ93xBetMc=;
	b=1QsuOizCfOxGF+mXoQApkwo8uz62/oknuRtyYDZ+yuTNHqO3/Kp+EdYz2tLF/p+EOSLX0m
	gXPwVbt2CnpSDY9zgWravSpk2Zk7KMfc53snpAhJWTox8Bay1/6rhzOnjTjUHkqpVSABhp
	LS6KOmftHgSzvEX8qU8ET6mKQhEqGbI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eFLpf7aQ;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495488; a=rsa-sha256;
	cv=none;
	b=KlhsyqYa/gjwuODW/MYDHWQy9S2W4od4mhujUcGGZJxg83y6w56Cp0GvjPnC1AuHT41Eti
	LohXgGbOPYHW+Nv5WYeKyyRJrcuvxsT2nBQKP8jTIuOQQ6zoBcs6u0iOsyP9dKwblQYmUn
	hpYIk8BOgw0kp5O7EDd+sWxaif0zqzM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E63F60545;
	Sat, 23 May 2026 00:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8069FC4AF15;
	Sat, 23 May 2026 00:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495486;
	bh=C3t5VpSydGVao7BOyP1kYFhAQKgwXJNsQGh4PkyvZuo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=eFLpf7aQLsyzllJ1r1mZsTzqdmSwjUsW5/h4sPxQPJlpAbAFoJRUJYmAh/SZjJuaM
	 vfKnEPWrpVOS1gpbgvht9abH7tZooZVKtnwZt/7xAs6Yw+hIt08dEAW9WLPMaRvw4q
	 deJkEQTggfkUh2YegK7Xzrs87H1RCaz4FGhDB9fCDUvEAx5DX0oAUwD3KstYm3nS4U
	 9szPx+ZZ9htgcpOi+7sh9L18mK81HsQWEfJbD9qLNy2+BT8r3S3TCDQ0tMXP1Oxvoz
	 bN/IP+k82lIzbL1N5d0W3NBEN4zoErgXFokPayw8EZOg/jvvHtyvujJjK1reYbeOOl
	 8SzrUUxWszdbQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F8A7CD5BC2;
	Sat, 23 May 2026 00:18:06 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:18:18 -0700
Subject: [PATCH v7 36/42] KVM: selftests: Provide function to look up
 guest_memfd details from gpa
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-36-2f0fae496530@google.com>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
In-Reply-To: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, liam@infradead.org, 
 Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=3906;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=ZLnoGcDfqNw3kHT/TlO+PwYEkmRf1VQWR0gq99QAOkY=;
 b=sPiB5t9mzr5qSyR/c7L/sj4zmaknkm99SLKpEp6epGoJHPkQ0DV6A08nMw+VfjrmCZwQLUdrO
 rL97L3obu5FCV53ZZY0pvD+6HYJSmdFDgZXyy3ulWSeuN8e3Ngpl92N
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 66ADD140009
X-Rspam-User: 
X-Stat-Signature: 5dkxqwjx3he63reuj5egrdd6gbum9tez
X-HE-Tag: 1779495488-447955
X-HE-Meta: U2FsdGVkX1+kscNYKSbra45mplZJCPBiNVck6RI7tTDUASwTTiEAsCieTiAKWpd+NYsHd5CjFFE5oba45pEEI/O5nW+o7Pt1KGw1o4yLpK4/asMYdkcidvluTqdQ05xpfCf/Em0D3U3SQC0yoIrU44FHKIdjJFlV5P7oLt2gxj4faeQE4baoi0RwUrsRdI0/yu9Pkldv9KNAwFu25bCAQSo+510vpWd0ZN9yncYRQVIYyoyuqrvANMNjVDfPILu6HygbxXxwoBkbVbiel27TBpEI7yqJk+/lOxFdp/cu6LxfqX3rKndiBUvYEiXGUxS5gUFRw2w8wlKnBNE8Pk1sc9BGe60AGIeQ1N3AAl/pJQS1TnkSwSzPL/X72VHKhiiNTPqu2mGc6/4lskjTXojq11AifKg+O8cAX07xkSN8A5xVdu8E8LQZGtOCuVnA3yTuCj7OBjwUwX09NCN7MI//LsLoAVGFHun6OXA1TMoP4VIDnOXLnKrFMZYPCX7punbwT18v/kMsf7TZiPDT1YsuEYBds6wwjxtz81y8nW6VI6HtyjF/ak5rhx5bkylmFQRHr9lz0mxNOQHoLV++NYUWFNluUkWV45OIybKVD+uh1sMzabEhmhesMX4Ri2UfubWXxmXLplp+O2tx8npdYLoqr+F3DjM/8JMIZylVub5Qi7jVPsJrDip/V27ZnfbBjtbIm6F22LacrnxSMThxPKB5zsKwxZMmY2CfnBZwnsCJe8lm7zYZQEwlZTUSoq9C0MoEWO2VQVFscbbYD9YMmlBYHvcGRCUKvwi5ocfNE5R2d6HX/FDqRco4EK8SBzILku+VcQDD63UKAIfBR9MeSgGoNnFk3w/GuTSb1UjUn3LN5vFKn7wl74ucj200QYGt7IVPOHZgwZ8++kVyL9qEFKq1LfPEcVVrJYfVbtF0EtEobEGXUZJaO6N6iwDJmcodRkO4MRey7XgwAZvEuOCOHsJ
 GIxUnHUZ
 9QDifmVPZ61pUB9jfCIkQ2M8xzpQ6+giXgAdwvPB67b4nS4s9FKU9mFqWaQhOEXKRC3X8R8yi7MnfNI/I+rOvj6yV3mlCwsPgwNnYZaLtrpptcLBcXB0Dq02+Hla0ODWAlvGbEaGQ42FXg74aHBMi1agiR9iSc0BKcHnjmtxEHxJ6RrJzgozAVupvYADCN1ui+kviUki1mCi0kXRiP500wFgV0L7CTKrcpvHMTbSrvBlDGEZVfNYYtM+gt9I64r3cErHYBRHeNycwX4nF1zDJPkB1Sh5f+KA8fN4DqsuNGFg7XmLOyELq8GynOdBGu+0XaYYEwxyoLRMIAZlDw0Qb9ps4BpoKBSrFJrVLGDZleLalMfQsQ91xx9360DBfnCGcUd6ObA+bjvh1Ary+op5JJx3xkeTRlJxmb4aRoRG1vr91JQAtaCCDMT6ACMHKhdJInkXILWxmr/FnNfO+sHwYkRrCCeCu97ZSHqscyI1CC39UDKcnDPHtZ3uU0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Introduce a new helper, kvm_gpa_to_guest_memfd(), to find the
guest_memfd-related details of a memory region that contains a given guest
physical address (GPA).

The function returns the file descriptor for the memfd, the offset into
the file that corresponds to the GPA, and the number of bytes remaining
in the region from that GPA.

kvm_gpa_to_guest_memfd() was factored out from vm_guest_mem_fallocate();
refactor vm_guest_mem_fallocate() to use the new helper.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h |  3 +++
 tools/testing/selftests/kvm/lib/kvm_util.c     | 37 ++++++++++++++++----------
 2 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index d4c285c6fbe44..e9b4ae9596e05 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -428,6 +428,9 @@ static inline void vm_enable_cap(struct kvm_vm *vm, u32 cap, u64 arg0)
 	vm_ioctl(vm, KVM_ENABLE_CAP, &enable_cap);
 }
 
+int kvm_gpa_to_guest_memfd(struct kvm_vm *vm, gpa_t gpa, off_t *fd_offset,
+			   size_t *nr_bytes);
+
 /*
  * KVM_SET_MEMORY_ATTRIBUTES{,2} overwrites _all_ attributes.  These
  * flows need significant enhancements to support multiple attributes.
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index daa0c1e835a71..f8f0cd62f2f17 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1283,27 +1283,20 @@ void vm_guest_mem_fallocate(struct kvm_vm *vm, u64 base, u64 size,
 			    bool punch_hole)
 {
 	const int mode = FALLOC_FL_KEEP_SIZE | (punch_hole ? FALLOC_FL_PUNCH_HOLE : 0);
-	struct userspace_mem_region *region;
 	u64 end = base + size;
-	gpa_t gpa, len;
 	off_t fd_offset;
-	int ret;
+	int fd, ret;
+	size_t len;
+	gpa_t gpa;
 
 	for (gpa = base; gpa < end; gpa += len) {
-		u64 offset;
-
-		region = userspace_mem_region_find(vm, gpa, gpa);
-		TEST_ASSERT(region && region->region.flags & KVM_MEM_GUEST_MEMFD,
-			    "Private memory region not found for GPA 0x%lx", gpa);
+		fd = kvm_gpa_to_guest_memfd(vm, gpa, &fd_offset, &len);
+		len = min(end - gpa, len);
 
-		offset = gpa - region->region.guest_phys_addr;
-		fd_offset = region->region.guest_memfd_offset + offset;
-		len = min_t(u64, end - gpa, region->region.memory_size - offset);
-
-		ret = fallocate(region->region.guest_memfd, mode, fd_offset, len);
+		ret = fallocate(fd, mode, fd_offset, len);
 		TEST_ASSERT(!ret, "fallocate() failed to %s at %lx (len = %lu), fd = %d, mode = %x, offset = %lx",
 			    punch_hole ? "punch hole" : "allocate", gpa, len,
-			    region->region.guest_memfd, mode, fd_offset);
+			    fd, mode, fd_offset);
 	}
 }
 
@@ -1640,6 +1633,22 @@ void *addr_gpa2alias(struct kvm_vm *vm, gpa_t gpa)
 	return (void *) ((uintptr_t) region->host_alias + offset);
 }
 
+int kvm_gpa_to_guest_memfd(struct kvm_vm *vm, gpa_t gpa, off_t *fd_offset,
+			   size_t *nr_bytes)
+{
+	struct userspace_mem_region *region;
+	gpa_t gpa_offset;
+
+	region = userspace_mem_region_find(vm, gpa, gpa);
+	TEST_ASSERT(region && region->region.flags & KVM_MEM_GUEST_MEMFD,
+		    "guest_memfd memory region not found for GPA 0x%lx", gpa);
+
+	gpa_offset = gpa - region->region.guest_phys_addr;
+	*fd_offset = region->region.guest_memfd_offset + gpa_offset;
+	*nr_bytes = region->region.memory_size - gpa_offset;
+	return region->region.guest_memfd;
+}
+
 /* Create an interrupt controller chip for the specified VM. */
 void vm_create_irqchip(struct kvm_vm *vm)
 {

-- 
2.54.0.794.g4f17f83d09-goog



