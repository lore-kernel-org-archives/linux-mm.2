Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D3EDC61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:21:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35DDF6B00C8; Wed, 26 Aug 2026 05:19:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 298726B00C9; Wed, 26 Aug 2026 05:19:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 112876B00CA; Wed, 26 Aug 2026 05:19:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA6C26B00C8
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:19:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2DC321602F4
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:19 +0000 (UTC)
X-FDA: 85142872038.01.9FE2914
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5518F20003
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:19:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=C5qo+ILs;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3k6-OagsKCIgmowq3xqA5zss00sxq.o0yxuz69-yyw7mow.03s@flex--ackerleytng.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3k6-OagsKCIgmowq3xqA5zss00sxq.o0yxuz69-yyw7mow.03s@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D76PmzCDeRV2p6N10w9hh+EAG0ujagtUtRrj7jnjsfc=;
	b=5u783GswHxVp/JH/d4pzC/83ZDC+KC8EanO3YRq+C6CDTRZI0K+MJx/rMPeR++UDZpTH9O
	CRSZK0+anQPNOLZYU3e/nkYCS0UiB1C6ziPmEunMlb1dOEUCnyjVLGsh5xsKhND6eqmVVw
	2i2NzRvjfdw7nuSRzyLvIYN6TlLBxyk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=C5qo+ILs;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3k6-OagsKCIgmowq3xqA5zss00sxq.o0yxuz69-yyw7mow.03s@flex--ackerleytng.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3k6-OagsKCIgmowq3xqA5zss00sxq.o0yxuz69-yyw7mow.03s@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787735957;
	b=O9yt9/uW9FZ4iU/ImPa8oKNruF9vD11w2jd2TdcT9nifBfgPLYFg5GWTnC4RTQwznhLvMx
	EIi2bkj1v06rpxAMYwNiF56GgGGPr6MTp/vRYApxNwLfZZfx5DU7Mzhrx9rulivca6HFCW
	I6wPcUYKXiA2xlINzEmObuFOSy98FwM=
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2ce7dfd33ffso6580195ad.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787735956; x=1788340756; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D76PmzCDeRV2p6N10w9hh+EAG0ujagtUtRrj7jnjsfc=;
        b=C5qo+ILs1nMZDpyyqFje3FdjKD59jEk73TrxJK4JnblOCc2WBq/1ufSGxzN2DHcceX
         OChPKaOzO2q+2IAqiBf01FfFnXegpCEFbWOXAi16LbvRFA7Xu+f6uQt69GUKnWtfZb06
         S66MG+W54FGZ0KFv8zmLTKBvM7u87/4DH5RePZfvWwH0UHtzlF/LjaaOR6CMoqISmcxa
         c+6ZrGPsWDJAFiucMo3tP/Tp8n4f19gWCY0QdrOxDyTjkwgeiyIWDUHhSgGGAvx1n8iB
         rsYrMhPwgbv+vdaTuhhO1JL9vdGWnrG2rDwPDsS8oqv4fCItJ+KgK5YQTt5oEuc/XdcT
         U2LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787735956; x=1788340756;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D76PmzCDeRV2p6N10w9hh+EAG0ujagtUtRrj7jnjsfc=;
        b=OO8gUZpnBfzgbav3DleRdHzfPApoZ64ylzmtHvOaa5Z6/JLkxIfadEcj//+DXPGO/p
         zuR4CVJvqlNFrx2ZQMwoR0S7AD3b79Lk5QTRLLUbxsh5w6VqPXNVdd2VzYoLmoA8YTdd
         pDuSX58pqDMR5TSTSE2EHFk4iQK1tQGdSWhbpKT0ONe2isr9DGMgaIbZqTrVyE5WQUUL
         yzhuqwuKgULXkuwMmkYGJvXd818NnrsYH5zzggmW9pYuEwxAw4IvkuoSJOiyA0oPnTWJ
         YJCb/4VpyuHr/IsCEszff8QgXZY1WgtbSSqwJDRo/wKRgpjTXWVZ46AXDgUxQv2Y2EU8
         iLMQ==
X-Forwarded-Encrypted: i=1; AHgh+RoNhHziBhZ6SkC2Qf4Zn084qHwFZ2IX2GH+v6/Ugf5uySYh+spvcfK5Eq4ZInhqk/7h1QmVN7OmoA==@kvack.org
X-Gm-Message-State: AFuF++kzq9KGrE+OWv/5ukqsDVxwnSEGkyZNsFhf1bzW2/jQRf1mp48T
	KAQe33BiAOdqlUxsgMePt4PehkWUwyd+ep+rXc1eCZXSW8JLvoigYJRsxfaQthDYfegQ9Ef86oc
	wzGQOPDzWbzADFNxn/vtjpE13FA==
X-Received: from plbkx3.prod.google.com ([2002:a17:902:f943:b0:2cc:b904:3255])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:8c5:b0:2d6:3c2f:69b with SMTP id d9443c01a7336-2d707aeb1b2mr107014985ad.8.1787735955894;
 Wed, 26 Aug 2026 02:19:15 -0700 (PDT)
Date: Wed, 26 Aug 2026 09:18:38 +0000
In-Reply-To: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
Mime-Version: 1.0
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787735885; l=3994;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=/CEIwjSGNwWClY4nJ2gvXOUmsoNiPZonugede79K7VY=; b=VKI0jpmA2fGtPo3ALkYanD2hZxdvdB4CI9YcTqovPUoBOfqUWyj8zXw9hejtH2j8l1NI1Y3qO
 tqEtPmAd+YVCTNJdT2Dv6V42I0jNgs6umWAkWlD4JbtNbw1o73F37Lt
X-Mailer: b4 0.16.0
Message-ID: <20260826-gmem-inplace-conversion-v11-40-0a15d8a799aa@google.com>
Subject: [PATCH v11 40/46] KVM: selftests: Provide function to look up
 guest_memfd details from gpa
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5518F20003
X-Stat-Signature: cik14udri336okw8qnhid8agbsghpxa8
X-Rspam-User: 
X-HE-Tag: 1787735957-203830
X-HE-Meta: U2FsdGVkX1+Mqoiv/nDRWD3M2QpsFmau6A2kKPaV0o7o3qWf8WdWd5C2V+r1fwWb7kBNujwHUyU9CQrVfvUF6RHk3qsueaSBWkGaOvmBr3Ne+gF+lEXsPtDu2pQA4Xm4cwa9XOxsJuIOJzgFSWC2gSisjB1Vn5Hh0NveQH6K5WeXVlp+Wu3wxDMoOLU5xnDpi57DwH89Tkifl/4+JLwoU/YboMKcJ3qYlRh5S6784so/IRljeOYh4W6TWBsuRBzI2eVx96cSBTPUuArdj9F/9Ag3+b5oGRpqI05ypYEFEs+3cNJYZXsukBltpZ5B/fhzwPNoTySF7NT/auCJ/46woceTQPvO2XzL0slJwW0IMx/wUiFvr0ithid1sRBxOQQTXCeFCoNni+kOlafGV1eK/Y45mKQuExhBXKuYQUy9gz+9dkqt/oF1PowSZbeRPmSv04OuoEmynZ3ylzSnVd25y2Y1DrjkF0sAbI24tPpSWV8V+878FeUqsoeZ7FQGCZiEIYrwHSFSKubA/djZXJs673A95gxf5UeVxgy/H8HR3+VgXxw1re3HE5AQLTWsO4OQYVJATp/+cg8EeQKV8X45XpV/eRk6VUrWsVCY3vu13uXXLDgelx5PahusXwSwR7V5ZGFVJzL/jHt1BcSkrIkZ1RQ6ive0Mr66uMcKY4qIWP5nH6xiE/bVQkTx8/rzx2chR1ul+3BfoAsy1sRuOCPXTORMDQe3LadPSxHyBafhVSqSxZAoxJUnZvtmQHnc/jmV+nyK0FhARrrjpTM88XqXRfcIx2P8luD7hsci9sZNr7rRNe1rXADpXWvsHhFTjbgSNUrYQj834xF3GFkNOyAgDWoUslUP4mN3pf1+CTDKXsmq0aRmQbUyqWGGuk3yZEjkje3OobS9P4m7IzqBcSi1ykcmA/+OqecQwQkSIZMIX/nVA4HZMpZ1zK8L6Iy7mjEdZ0Ogkdq101M7Ks3YERH
 THaL+N83
 h1Xx48Sl5xpcodIMaCGThCDV6kRBEBG38bf2BfK3ZoAsVSOLn0XZ4GGyMdOsTwi04RdgdYZ3J6k2w/+Eqtj6H3YDrUDFWePUbK4hNmxYgGNzsvR07/FEhi3qi4psTAskLgbKtJSFSXzPCFWOrfr/wJThqJAG5amKEQIgZfCz846Y838WD4DuF7heZZUqd612CmskDvrdwYY+TQ8K/xrogjrdkC8ctymLIJIcyIHbmEJPoEL1hrzERJqLsgx3KrluY/MvrJ9t7JU1UOzqLGB/yCgB+l5Qo+dGoDZzMwYRRNs72FgKUhV5BUfUjQy14q/0SeCL3e/I5+TI3tSH2D1EbUhqfYWdBdSo6uwChQr94mySCd36WEsNZB9ONRMrB5huUafInghwuv40yxddEfwUIsYzRw2s+Vio7m9f3EfifubJbCDjXmsXQ1cwnn0P/O2d6KL8+TtSYtCIl9pHIZbZP9HZhio2EV8AXlOmVNEb4mBwvXiEtYK34JcdhKW3Ctn9Zw2JXbGEVLBXDbXjjQVSfxPoA4AHuWGhTQATcw75x3IcNGjZ9rFuVmY8pDX9eAphenAGCHETMxgKbvX/otcM5WVvt3aA7Wf8PGnLW9sxSZ7Yool0qUa3ypnfX1E8EQsazUpkOJa9x9yF6CM3Ng2l1Mm72kfU37aFQpaMhTXMFZfsCz8CAz/8iYWOo3Xu1fJml78ls
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new helper, kvm_gpa_to_guest_memfd(), to find the
guest_memfd-related details of a memory region that contains a given guest
physical address (GPA).

The function returns the file descriptor for the memfd, the offset into
the file that corresponds to the GPA, and the number of bytes remaining
in the region from that GPA.

kvm_gpa_to_guest_memfd() was factored out from vm_guest_mem_fallocate();
refactor vm_guest_mem_fallocate() to use the new helper.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h |  3 +++
 tools/testing/selftests/kvm/lib/kvm_util.c     | 37 ++++++++++++++++----------
 2 files changed, 26 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 3cfe243d7c8b0..795c9eb311071 100644
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
index b1456ed76e27e..1188d0a6c0a5f 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1332,27 +1332,20 @@ void vm_guest_mem_fallocate(struct kvm_vm *vm, u64 base, u64 size,
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
+		fd = kvm_gpa_to_guest_memfd(vm, gpa, &fd_offset, &len);
+		len = min(end - gpa, len);
 
-		region = userspace_mem_region_find(vm, gpa, gpa);
-		TEST_ASSERT(region && region->region.flags & KVM_MEM_GUEST_MEMFD,
-			    "Private memory region not found for GPA 0x%lx", gpa);
-
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
 
@@ -1689,6 +1682,22 @@ void *addr_gpa2alias(struct kvm_vm *vm, gpa_t gpa)
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
2.55.0.887.g758fc8c411-goog


