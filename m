Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13606C5AD05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:55:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2039E6B00EB; Fri,  7 Aug 2026 17:53:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EF4A6B00EC; Fri,  7 Aug 2026 17:53:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1F4A6B00EE; Fri,  7 Aug 2026 17:53:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C106A6B00EC
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:53:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3D6B51A0165
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:08 +0000 (UTC)
X-FDA: 85075824456.17.71F5329
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4C2014000C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:53:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E2OJ5DuU;
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786139586;
	b=7AKqHvf8mP+SQHSuld/+AwQyNEj880hDwNYXvgkltgZ/YdOoLP6U1sFqqR4PJfpsLSYmht
	VVnDkBcemvPPG3DsDWxpg4CE0VD3D5p5vLTZJQH6PQHZZCcOweRYMfkkztmkYS78utofgw
	EHNxGTk2x9KbibURZVryXB71pF/tUAA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E2OJ5DuU;
	spf=pass (imf01.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786139586;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n4S50/s9vux/6TdPWDzQlR/uL4AR2EDQiJXT5g2cp50=;
	b=ocPRIKJD0u4yyP6KfxbtlCKwSHvcUPFUly+G8CVfozNhQvZ3NmsFcgI9weXB/jPKYDL9lA
	mno3FJRxPUQkTHiXMFzL/zWZMCTVyCSP9OLfz2WCNqXn0Olld4tI54CgREHuZoRGzDoV9/
	8MjLdVLWVzvcjFEs2sGjFBBbt+6L1/E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A0EF7452C6;
	Fri,  7 Aug 2026 21:52:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5E0C3C4AF63;
	Fri,  7 Aug 2026 21:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786139571;
	bh=OGHjw3gqd8Gw/UtDSEmTOdDh610hKejY8AY6SlCRJw4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=E2OJ5DuUgF1tbkDn2eG5IV75+lg9bcWoGNskxe5xG/3kx9Gt1AXH5feMNA3RZcjN4
	 flMEaamYTsfQ1aBUFKIb3E6i0n6zX9Qh4xlcdVffPF8oYt5Gbs5oVS/CXgGU8HCYjo
	 oyYLMV1nYUGY3bAen//myTdplLWUoADgFjUQhopRdASXAXfZkPQ0oFn1vijiCOgDLj
	 I/BaDfHapOhoBO7bfuEz58Ud1tALKKVu4vbhm+cBpSumDStunW/1cpGqxqcv3qDflc
	 cwhbu3RH5AimEgthzRWeJ4ZulEol7PqYhKJ+awcbZj0fXrIRCoOKHHMcUCdAMXmEMi
	 k0fRtj+r7euzQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48441C5AD46;
	Fri,  7 Aug 2026 21:52:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 07 Aug 2026 14:53:16 -0700
Subject: [PATCH v10 37/41] KVM: selftests: Provide function to look up
 guest_memfd details from gpa
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-gmem-inplace-conversion-v10-37-2fc18ee6d3ba@google.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
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
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786139565; l=3994;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=nqVYNMaLLaXl0sqbjsCrLje7Yj2R93B42zAkuyAcDYE=;
 b=7nSV7pH1KcuwHuhDciDwmMBz12jLIK2P5ubeWQ/gQXDWkJZMzA/PmWfmc5gWbC2w4UoTpSF42
 YGKfZhiQH5sANXGTr++Xb9kLsjRgLJW+yDYkcQ02RRmeGlCJsRyeigg
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4C2014000C
X-Stat-Signature: mimgop5zrzidpqymyjbdqprz7gre5zjc
X-Rspam-User: 
X-HE-Tag: 1786139586-317793
X-HE-Meta: U2FsdGVkX19Zb/6tCeoOL2h88JUJHSmJJe52yNK0M3wE2ygm/MQrUpLOcIN/OWYBEJpzVHw9K7rLIG/53tLUQJxq7gyzWuehUjWcO46PygvX5aP7YtRykTXUVYKKVAkVi/iRf79XiD65KtwlRuyutOsszRYGxNgFPEWbCOuzZpSeIIDUJSEihtqBpXBSdwOObzSoFXP/8wW6dB5EPsJwVedqJrPVCG310BipLMtd/UNSSNn3K5H86woEiWAzGxUFfun0/4Cu9VYEs+ukX9vVjDFqZhQJHD4z3dkkkZxfw2dG+s+I1rfnvujTqxcEPhKT1aBZwlK0qZ2NDMxJhgMwY7mgLRILbyzLszwSIYrS7niqD+36MDdxGSsks9x8W7IVrKXzTFwTIv1e0rHtCmuZZd7PozhjkA0+4JHB7CTYbpUbP+e3cRTjrMMBCc3SJCDiJ26ej8mBdIFgDnzvOSzwL8xBgUrsFRy4WZB9t+t+hSJSMbOPGtrf/r5XRdO9lI2SXPZuWF4/1YZK0S0MPEVW0HM1LU9cVVd64PijCn3nKYgkvy4lW4r8kgS1xIvk6fFZShE5o1ZE4gdIcyGsLPsUdBRxBz4q6yD9CxPxKM1WxTKW+ymjOmIWQig5D4rbvvt+3mjA5E23AZ8M52M+XEZ3TV6g2WkNNhLvv1hZOhodYsQq2RdI/7h80XiniSb608+g61JqbBPW4RuE5kTHkwiffZkTuJIroGtwOjCXjX+u6ki4yOQ5To3Nv915aoanEmIpACofV7930GwozTHb0FNcmjp7Ys2xX7WmGYQZ2VzvsSGbt/KxWpdw1WKSug0ea7N+/q0BWcq/goywqbW0c7uEZofcLJuFQPzgW08MNDFG/DQJtsDNFfwznZEe5P2RYv2jXTC2Ky1b6oAdpgaesfAheXRp1HUFLJaktbIcI0S511+joTTKGt9cIzoJ7llAiyX+jjADtxzYHcQqMgfnmI9
 olTw0+Pq
 GoqofUL9EgIgIsuWXcD8RpLV70NtpeNvDOM3CacGsS+Rh1839Kug+fxyqW1S5x3P7V60p6A0waTLR2w2Tj9cuqLH0l1hhspxljn7B9xtOQyAk1kvvQQiTkSFTpDLVBTOJD1ZNEBLy5LfUF/ZkuP6Zm0N4dIwDhdIIMmcVJdV3cmqodfOXVzhqRRPnGp5XXRJ1abDoXH0AY1ivSn4tI0fwHwEy8Um7zjVVoS3XauTObEpJIjMo4FBxkJyZfFIqdkQV59G4bpB9Wz5K4EE8mAm4ug03VJ91YzFqah+ReMwonGssCQBVVZvKpnfKN7oMo++ecKg/Vq9g0bVPYpmGyyeZrpbInwzVYBuVvOhgULSV5xa2M08YlpnUKAugzg+Y2E5qjJrSeUsZXwCkAOHROssIEBmal3JdHT4vfHrp2BMGIet/SGAxdUL5WymZe21oKt6zN2sww+IN5owQdIo4tGopN9xC25sSL9Kz9xxIRGyYRy5duJWF9NZbMW8Xj0COLiWkyIIQ6HOV+aCtPe/898xgjT9T7DqKCcNd+FYYflPiljdrQH7mJQaqnBpNOQ==
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
2.55.0.654.g21b8a5bc05-goog



