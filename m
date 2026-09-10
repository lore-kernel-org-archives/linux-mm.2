Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CE5FC88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D41D26B00D5; Thu, 10 Sep 2026 19:55:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEDFC6B00D7; Thu, 10 Sep 2026 19:55:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B698E6B00D8; Thu, 10 Sep 2026 19:55:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72F2E6B00D5
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 647D2C05ED
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:56 +0000 (UTC)
X-FDA: 85199513112.29.25819A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4D06240007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nPRjTZCc;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084554;
	b=U6vVt8LmZw+Wa32/99TF98TJIjQmnxOeI7/UFXJU+0+nK58L7CGxBoL2UxgRZMGPHtPHc+
	00fU7weiPseb2ZLmmn6uQlskC8KWnbh/UIhUtryD0BIuFDg6KmmkUXxOmwvbKCWrCfwPuf
	RZQQnv6EQSgVbe0QD3VaU+LMXy9DmtU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nPRjTZCc;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084554;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CFFN7zkyTezuARgb1Js0QxwS7LpM+SiVjHHN8JSbMe4=;
	b=zhkSdhD57fNFdFA4YkFBKZdtmlr5XJM/wO3a7Rt/JXk9a7XNc/GNXbcnc8Boi9W293ifYM
	4e37Ndv06pieXaseF00J0OLiQO7dpm2mfLdRwmIFzLz4wweFueEBgqX2NieywcKsq/Lk0K
	hr1InUVMBhzi4TZn9fKy2US+mgY2CTM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CAFAD449AD;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A11F8C4AF1C;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084540;
	bh=IAZo60kA184BW6/I59GGoCCrVsK831Wr+/J62tEoc38=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=nPRjTZCczx+WiSTCHMJ+wWn6RjWwQXUFN42bkNAUBXEyFuk1oCIl4AZ6kxEpUK12M
	 0+Of5EHpwVvpHtk1ABMqlfYmqMPOZ9IWOg+Z5FykbstIVyulHUYlxr2Fg2Q9/lAy1p
	 FbdaIpPXMn44xKP91xPsUDjKoJZ3RhRKXuXuJJEih4gBMfVAo5sjV3wvmxXOG7Ps5F
	 R5Eo5ZRVvVlvgsyzYc0OmJrJ4ANKlG4fytATldml34BdkjgQHx0H3fp/DzhcCMPNVs
	 orgwo7ahUr/+PMXZS3Tv+yXnXrj6ka5LnYbtno4nclOcVza42vH2ll+F1TQk6gHjfs
	 hCl43Ie2MfxJA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88FA8C88E4C;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:56:05 -0700
Subject: [PATCH v13 39/44] KVM: selftests: Provide function to look up
 guest_memfd details from gpa
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-39-dd6fbf94f4e1@google.com>
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
In-Reply-To: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
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
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=3995;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=HSauTj2w2jA3RK3leMSubmEg+e4MlwXYfxTN1L91oE4=;
 b=W7NgC85hOZf2fR1ZAWajVVHMCGzpf/2GXof/HcztYoe8px/j+SXUUp0iiFyASBLiaMMXq90WT
 tSexMppioAjDh+XT41l+MKCB9rHsb2OW2S3gMp3VSrS4jxetqNT5OKd
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4D06240007
X-Stat-Signature: fhw35kc84t4x5xqsbba7jcgo8de7f5pa
X-HE-Tag: 1789084554-131378
X-HE-Meta: U2FsdGVkX193XIAtYGUzWKKYKk4Yt13U2jt6PcvBaDV5UQhD3KLti2WfWk0nXjL7ydcQG3aPRq2tyka5xkF20zhltmE0ceM90IFfcd9EL1x41+NWlXm92U1YXguW12KYcynCDqHCRtZF23zfwqq5b+HjZsvGSkIWkxoXQZXgW2k/SnZjopxO+N0PyjMiLajmBs/b7oaOAEVYiVNWlhs6jHP2v/3/joACnApuOzOLih5/Zu1Ngy4Cw1NU8N9Rh0FP8zmzj93E9knS3EpJtbow0ChSs/Wj+l9cMFiy0zkvZfvtpume2T3IHuXI0AIcHj5tpF3ggwlwlWXUaAOX9O8UxTMbQ7bzp1lBIGAPDBPYTUzZslmfz7A8y4zWlwlyGwS0GG0LqPI7l+cUqKPqCo6qoxKbgXq5oVqofQpZGzOsROpnf/gufHmUCD+z1zQBQrZZVJDdO2tz5SVVe1r7B6xQenfndRlSTxoQkDn8/2ULwPCeVZ40tY8A+Jg9JzNJo1VXeRGnwJpZwUxOxRsD36w4bQ20UOQFul9+D07ISFhNvKrQzmHB7EC2E/MWnJo6h0ug1DJvy/sz3lZX/J72KZ3iTFFWldu+5Di5LZtrpe7juW5ZMSgdgruJJd333XUpwahNXcB9SnVgS6syqc7zBVSoaJ3/UvQVSudWxrtazWcTK+8AAGNAnnEnyxWyhNK4+2IUdzG79cV4r/r76B5VwNEDx+UfWuyGEUDz5MowRJqhZe2XekvDNMmnbCzZyhiJUXwb2i7qoKrGI//WSxV6n8SpK/zBUWIUMXJJ0653qjfy9UB66metB7+RXk873dif24G1xlDK4oRE6FyJZcqmCGmQxzjvTh5J5U79k6TWcPNWv+QruVBCWqeMDeKQ6VMp+0olYBTliX4mBnL3vQ3Cx+4SdQXrmlhUvQxPVZFePEkR/B/Dn8r9+KFjblnGNqMWSIFs3nK6Y18HekneKXnD1ls
 K5EbSeqJ
 cAdxJ5meobYvvLg8cXueoG9dYQtAgtc/35mXfYwRip9mTbu7EpNYZSxlWVvSmu217z8FQc3Py3btLmNaa5GPZrL2fLqGM4Db9Pi2xoUog8XonZoXtkbk+/JkxTxV63mjF8Pz+TkhG01Cp7c5cHtMMCOT5wkSiHMiGrpbwJH3JvSLL+QHZy/+Hfoplz+Saj1W4ft8DBV0lDf+3pr1DGeGh48n9BEoGnlc21605f3TSmVmKsi9ScECcDWsP/vfjMfDdm2oRPbwqdev6dhkSgpKz9OEBm34c9usbMiieruqRJgWoJN5n97158LTCDWeY+++ou4GvkkgSK0h+mRGnYlw8beIORV0LTwjdQxK+o17sNNQvI7kyrYEuZjYqXpr1052h2+L+gCDu9EUnPpVhgZQpvBZPYbfo023sh7+LsduaPLUegI4IzitMp+QQ+D04fOcifHHucUZ3glAhlBuOtU488Ztw0mMWvwRMLs5jdjSm42c7jyBnVyTo+wDbaDJBDYT4TdZwY9iuD1cGcBRkdqpeL0JMCQ==
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

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
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
2.55.0.1007.g17ff1f9808-goog



