Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C189CD98FA
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:34:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 210E86B00C0; Thu, 18 Jun 2026 20:32:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14CFA6B00C1; Thu, 18 Jun 2026 20:32:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0621A6B00C2; Thu, 18 Jun 2026 20:32:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A8F896B00C0
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:32:11 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 14A8C1C17F3
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:11 +0000 (UTC)
X-FDA: 84894785262.01.E2A4E48
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 15E5620003
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ncfSZIx+;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829129;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XejDDS/MkueorqjDkXPJhAHOwrXj5Sl4r3MiRnuiKm8=;
	b=PJEHz1zLfpFupfekJja+8rEjX/8ZzCVvTYjVtQGZmBSXfffPDyLCjYQjAN1ZHnJaIS27ta
	eMge5aXOS2AXTH6z//P5hhaXG04vS3bvkiVka2zhD5V/Y2ajUiDPD992s0xKBwOXWoDUo4
	XT6ihiuZpPa+AnXmmoYL0xmAkIxsTFU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829129;
	b=tNw3lY3fUZmgXB0v+nS1QZCVFH5H6tHPpZa4QFaNwcvFKAPuRS65whyaxXGMelFxKN6Vnc
	vhPjeSOS/vWjyrmOsDTojmRKzlgPvc72RkB8Zmxc8mKH1lhFPan7Y34cp7PLZfO5ldtm4P
	YKdxRJDkXmUzJanqaI7ZNGdywCOJlvg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ncfSZIx+;
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5BF8F44E41;
	Fri, 19 Jun 2026 00:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0E3CBC4AF0C;
	Fri, 19 Jun 2026 00:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829111;
	bh=ZTq2T3Wn3LuB9dKrDl1PFQHIqHvHZCuXHBQhPZXIN2s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ncfSZIx+3xR7ILAFYfiK7inl0aErEXK0s+gbezz+/pMTqazbeuVfiSmBjJ9WrGI5v
	 XdFBT/IR1CurBF1nC7UA7abQUuRuoXM4MrtsJvvDplhxWT7mNFVwhB25aPniSwrFVm
	 NkwDhq41MuIBaRUhTHNz5g7BLwhRAzSfh8nKU1TPjtD4PhSLeawbvevC3Db5oRZj3X
	 cdLTt/8sGdBRjfDepemA4MiA/soqCkJBlOZCTdUoE6L3gqLhtpQyNuRy9YvLBOMQvL
	 ac9oocCY89bAjx2CfUMZCK/Ad5M8gjOvrN7t/P/evxvyAt4Ng4CKFRXRh8rVzaarJN
	 x4Kk8z9yyWj0A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F32BCCDB461;
	Fri, 19 Jun 2026 00:31:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:32:18 -0700
Subject: [PATCH v8 41/46] KVM: selftests: Provide function to look up
 guest_memfd details from gpa
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-41-9d2959357853@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, tabba@google.com, willy@infradead.org, 
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=3910;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=G4/jeqnX45Y2qBS1xuPu8CWWM3aYJX+9N9EegokihQI=;
 b=KL8322qHW62M09V2BpRSN9bHEeHain7M6RKxG6KBmMjewpJtRTIGZb+P2VYTApLzOJQ2WQsHQ
 agmJewUVFADB6Mrjz8lJ2yeiycRvi9C+fVZT1CFdRx5Jw+m4hXVr76G
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Queue-Id: 15E5620003
X-Stat-Signature: 3cbigan67atajubb87r34j446eq3uymk
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781829129-415066
X-HE-Meta: U2FsdGVkX1+m5UYNToB+CgJvaYCtNWt4JRlyMsey1WjQp6/nNjsiz7VI6HesOdyAnr2kV7XC2uuOKvhGbsM+eTwM0X9mZMRwZFDZHNUCvCfZ83Fs4tpSW8Hx0O4eqmbD7bA7DMvSybPAhVfdnwtgg/t0riGXGmoFclsB70y6+BHta7k/kQsGjCsuPOiTJgexQL4ZHgji48/IZdwEP7wWRMIxF+j/eRwFKdh2h7QUTRd3sN+Nod2MVzzZRMyZV4ME36TI3veOHUNjLbglgFn9G/dpjVnKcdAe6SkVp57/L35DvwvZfs9YEu/stR1Zq9n3FmuZQUzLtOxYCTfDujVx6xYhugpKX8krCBuDq5DekxrmQxaLeyeLYsBMZrKDfmiXath46aybCmdg8lBgbMKdiGikLc6vh3ug+beu/2/DZwicalJe91s2dyFiL+rjntHkaWhjR3IH1N/pl8U97sJavTgGtprAjv9W9C2vsA+hsXiZvpCWlYLG8zv38HsB7U5+DAmWNqk6YTFes1szw0MpymhHzBLwplqcvOtGo94t4JzKP7ScygMEJDBQFJOeeEqEt8BY6y73mLFGafEZrHa7ZWpzpbaGGVjjI2F7i6IsJuUGhLd9Y5AqyDVhF253woGqw9CvWix4c53+tco+qETbBsXrxRfwGP9VHaujNekxDWL496zKj5yuziBomfauypIIVSwl/e55jCRuFTGglF0Icw/kZgDA2OAkWN/8lUqiplbSmEfsvWDIUKip1202lHw8NyCoptNetsloCRClFAfN/qGgognulPKg54/6aSnx8H2rixqpUeav6+pGVWaIQVWzlcj64Xg9d1lYgpKX1uYpPXqIfFExfp2if2yIQPvRPd+dU14r3k5/gY2R1xGrpNznZC5ypVlNgE4aTdZorH51q+Tp0qW8PzpHGRe31QY/zos7k2jacP5qHHwRSzndGdWHjMX+Vqw+6jo5JtqRqoI
 ggq9rcw/
 XF+06zUxaNb4o4azMGwqMGvvejIQ1Rztbt+sVFmx6J0/KGEWAhMdNIKD/Fp+vPInDfGkspk5xQ4NebuY+wg/mUXpPalkIXE7iL4ss320++veTsJ6sVPAOfgsuNqvDQHZWeQMLY4jRnfSFDMTjMccb3wpBKmQJPO9jN83sqmhu8raM4h4xRjiDVgQE6qhaSdwKsX1NCWrFOU5Jrfes8xYbum9Jc3Ty13tUs0u31w15fY0Sr1rJXoJTN+ES+FTI08mqgCsjbTYaD5eOf9CKdjRNixC1+eqIEdmmIRsjoskMNbq7Hu6WAskQdTtBZcmQH/R2GtLAb1ZxYkIMYdi1XJrLSP69VAbYzPP66vaNlb/4RulUYNbp1ZHq7IzGzjWKGfzS48zCLIGR6ss5kbVkMdpLXEf6J4Nxts29oKRnvir7nmfR62VO58XK+06vSsgiaUfJqtVfHrAY90nG1utUm4g+hWquEghHBDkHkZHLiMpjRyHRFn9AQCbaHlYhhmmvpOxKySv7H1WVw9VI6/8Ua5L4PBs+HOFlwJxFs25P
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
index 79ab64ac8b869..3a6b1fa7f26ef 100644
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
index 524ef97d634bf..0b2256ea65ff9 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1305,27 +1305,20 @@ void vm_guest_mem_fallocate(struct kvm_vm *vm, u64 base, u64 size,
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
 
@@ -1662,6 +1655,22 @@ void *addr_gpa2alias(struct kvm_vm *vm, gpa_t gpa)
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
2.55.0.rc0.738.g0c8ab3ebcc-goog



