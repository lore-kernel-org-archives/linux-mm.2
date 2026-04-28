Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 124C5FF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FF916B00E1; Tue, 28 Apr 2026 19:31:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D7686B00E2; Tue, 28 Apr 2026 19:31:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ED516B00E3; Tue, 28 Apr 2026 19:31:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 629246B00E1
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:31:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D79071BA24F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:45 +0000 (UTC)
X-FDA: 84709549050.18.03587CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id A77A3100006
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rp401V6E;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418743;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PcFtlrYJ/ZH97pUq1XmAFuc4sRtKoDwE3GuWuwCKYJU=;
	b=Yq8NaQLODxjQqkDiFOXzRpNPZ48QYOwVHaDIywOo512bEphS2CXlDD3dWz9fpipbvqSAx5
	tGLLW0Uf93KCdq7nCal/dYGExq9KBKGB7KQyDXz89E4OuzdcuSZ5ZgQpfXlkw8ckd98zwV
	gzR0yR8Vg6E2v2GHaoHK8hSJ8bDqv0E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rp401V6E;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418743; a=rsa-sha256;
	cv=none;
	b=xkZNGPa2zCTIMdV9YuY2O0IerNLZESZuato5exUA+i0LL6y9Es8wbcOam8khFK4MoqbMuH
	KQZCsqKg6n2J7jwEtrNPTsxhecfWdN4Rd1ayikoNVhFjDctsknx+8eHNFTcR0CCrkig/1Z
	qV94cm+50Kym15IBt8CJpX8D2Jx+Q+E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3672744B5D;
	Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11784C2BCF7;
	Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418721;
	bh=mwkgk7A8hFc2PxDEeFm6pEnfqmPWkj5TqPujEB8TS+w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Rp401V6ECX1gEsLEV0pf4PelPwAttxOwivufPzzsFK8aTbzDeJ9a6Ak/BWLzVv9Ax
	 M2SbzjBE6/+Q3tz6O7UJEhputyg261KcRHxp6J2LFGYIXNg35pTo+Q4IATJNrSk7Wd
	 tVMCESXsE0P6tZQWNpba/YRrlPnOu+4D+J4TF04k0nnxvZr3K0ryvTsCxLFx1A7UlF
	 xa7pxZ/W94Iztd6sNrmUhPjcW6gHXjeelgo0gKZJWCCqS0D1AlM7Ggt56J6b5xafmm
	 KDVOc/SlT7c2EXDB3SNaKZOnTTxlMj3tExcjxTWpwpiH15g+jKzMl8b6gtybuKbLYx
	 Tv+4jjYPfb3Jw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0740BFF887E;
	Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:41 -0700
Subject: [PATCH RFC v5 46/53] KVM: selftests: Provide function to look up
 guest_memfd details from gpa
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-46-d8608ccfca22@google.com>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
In-Reply-To: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=3877;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Xc+MUzeFyBLqIxQeeove1J/69O/NRCP9DFI9k+NHIr0=;
 b=W1wuVqqKA/T+YKlV9bCqGjI4UHZ9nsom3khaNv6fjoqr4kJjIUCGS7SXpK1EaP4DvoNqg9660
 JNsOz0AnsxQDhxWPEMKtEImjgwdIt1LCW9dYvUMi4MOuu95MmbCZLK2
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: A77A3100006
X-Rspamd-Server: rspam06
X-Stat-Signature: yqgoisznyrioud3jkkzdnupae93mntzh
X-HE-Tag: 1777418743-119056
X-HE-Meta: U2FsdGVkX19gyf7Mfw4CmpojwwH8N0iewxWMYXZdrtSlPgU/vvrYrBLK9176x4+S9VN2L4KEQ8m7GZvVloetJJnZ5v5o8CcbznzcD9rYm0JoaeEMg4Tw97ga9MYcA2IHCx0Vh48pDWTguhBX7xLDh5EqvaRE7pSrjqMXlxovSrkNo9SXvLFVhDQZIGxzXADpIhSwrJAO4cGCBZS/lFO8HK7SHy/yrOuHgqjH3S+anCP5HtYzzLA3IE7uknNH8xIp9CMRJtRdYC6ekfKUOeL4TxIYogI5C9vc6Oy/RxQWGjNDWFAbqd1RsLKrF00VGMU9NgFHNvITovQHcsIJwWTi9pjBnyo3q+uZmXVFDfSjE58vdUlxgZgSQW1W3nk1BqLdS4hljHBDYqgBe5uJZmFhuRaFQ+RONR1KQhwH5/PR92LPoXyBdjbf5DrSeyCEomdnnEvkrIFWllIk9RnMDdDcNiC7fBzlSg5Meg4ZLBRJZzYqoNhEhyzhF+k/WBYY69GzxQP+mQU/BWiHvOQ8M5o06KvepmxR4IDS8D6R9du13WCKe+zfYhqr18uuH0/JwIcYaCzsEZDUeiiNUYB8mEOQDRgO/qsxcjLo6lET4WczhPz9NH4hTMJeYFlThQOnbwTsCwgdSo1P3J4rTdB8GFCQpC4JtYiNQ3LddaxLWL0LQRDNymM4MZ+NCY17kBdRctFJ33RskfSPbfpIh8Iu714fcCqlth9syCsDC38iGQD5ZVsExYPqhK+lbStq1dtoObEthGz7rnRT7YpuRCMM2KRh/5OiHrU4wxKTXUleULIe264UXDBXmvc/GOIk9D6enUx9562fNbiEkjpwFn0LPsjPNHui6FOpXzkqVN5oIsMS3/g0bHaxOfqy8pk7g6riOT6/MFf+WyyS8HPHNjyku1snuhp7vXf655HWCpCsJ3X9f6D7j1Mgb6JImfRW4DNFxsJAxzJvJlRLHSB0uQcqoel
 Iuwyph/H
 1BZZiO153fXBUBM7J1peDU3MxnzCR+qRc4ChtmEaa171bb2XL1ZXVsShLqLAe4wWPduGNklCJ1F7d9XUxeaEGOnkGoLjqXfbVZ3bnJbQKJEKfmPGNNgznHRyrfPf/60xe4e0nUyNttMHkmKPl/kYqWPxa3e1l+rwi1KiaYaGRF2sweBX6a0Ypa1SKyy311hEFjP1mfQ1L125U+ZZMxBmqOgExBihFHUHu922m9tppASRgmT4wsHsujTAyrsWWV/xACUHFWvargRfxuJ7Uponb3K1uKtSd3R5FLVf7hbM4u4WFeQNAFDkuOqEg4UoS0XQkjYh0PQXEFKc6ljuDhW6VbXo6JynIuJeL7QnuPyhO5bwPqrJkLPJUR2ThpoZRh1E8X9Q7C2gabRCosc2Onk7PhuiZH/sf0Qq6Jg0nH6SoFA74fZcGlvvv0g+rIP/KYGXE79OZxhgyey9yH9soBPPHjY7tQNex/Jo5BtAOtl2nft6U46iiTXTz68PzeQ==
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
 tools/testing/selftests/kvm/lib/kvm_util.c     | 34 ++++++++++++++++----------
 2 files changed, 24 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 62d917a2d2b19..7de88cbdfd2b8 100644
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
index 5e34593ad79c4..12e031a8fc20d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1283,27 +1283,19 @@ void vm_guest_mem_fallocate(struct kvm_vm *vm, u64 base, u64 size,
 			    bool punch_hole)
 {
 	const int mode = FALLOC_FL_KEEP_SIZE | (punch_hole ? FALLOC_FL_PUNCH_HOLE : 0);
-	struct userspace_mem_region *region;
 	u64 end = base + size;
 	gpa_t gpa, len;
 	off_t fd_offset;
-	int ret;
+	int fd, ret;
 
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
 
@@ -1640,6 +1632,22 @@ void *addr_gpa2alias(struct kvm_vm *vm, gpa_t gpa)
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
2.54.0.545.g6539524ca2-goog



