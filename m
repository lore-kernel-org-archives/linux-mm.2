Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09BC0C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:37:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEEFB6B00BF; Tue, 28 Jul 2026 20:35:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCDBC6B00C0; Tue, 28 Jul 2026 20:35:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDBBE6B00C1; Tue, 28 Jul 2026 20:35:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 918A56B00BF
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2EB20A0561
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:27 +0000 (UTC)
X-FDA: 85039945494.04.332DD36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3AB8D4000D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d4+oatgn;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285325;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=83f93xHuSKXixPez64uhaW9s4vLwFRLsGgaEzUtjQVM=;
	b=Ez+F+UckOpahI2aSSGgWdT3yZfDDT9yHUZ81+1MiXQcoqt04iXrNPY01FF6+ednoUKxY77
	2KPBOCMD+X2F2j2/uPh3fwUn20lrbsrdlEYOSWCNrVeCr0a+OJzkaIQDdYmwgbxTh3qaH1
	Q4NhqlZ6afRvNF7Q3pECQ4WpX6yKrsA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d4+oatgn;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285325;
	b=MzPMi3B2BAznGT++9JbLAuEwV2D8OCEnj4RgJo/n5M01BQXD5z52rJWxsSbsbdUwxYqWA3
	bh6L5FQjCyz4WNIiW9TfgXD4Xnl7/qPUonKG4IWSBUzQ4r466/hoCKnUCPKKKQlQBV75lr
	+HDvKstbU8N6L4zyjmfKSsGC/80eYPQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A94145333;
	Wed, 29 Jul 2026 00:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F35B1C2BCFD;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285311;
	bh=rKIY4sXDq1J4jVGfzg5WxbhHUwRgT53KjAPpWOjyG7w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=d4+oatgnV51RsK7VUu9IWRdfuhJvK2QpIooBgxy4Pj6HHGutV9gbwsRBaO49dm/3P
	 FLdVxH/UAarOoYh46cDnAGY49dfdJO4fL/72spqD9lpfyHFNP5DFT8Olx0D/UciSDn
	 rD6g3H9QCmQvKsomvcvBhw2gVTXHp3G52oQqQ1taKqXOc0Y0knBBCt9/5aqO0INirS
	 TQUFarcvntwEK/heA66LgRMr1zWW1t9WP6r8aIsVt46/bUH74kk/1JYy3V98dNgmLQ
	 6s5oipFGrqY9afe+LRhlPZR3kJPgsjRZe1SO9A4iqvstxSSUqSWP6PryNdHcqJSPQz
	 06EWjXpbLCuSQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D528AC54F5C;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:36 -0700
Subject: [PATCH v9 37/41] KVM: selftests: Provide function to look up
 guest_memfd details from gpa
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-37-35f9aec2aed2@google.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
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
 Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=3994;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=hD3ailDpep/KXzMK4epkF6ag+laFkxTXHf8WBn3ggUQ=;
 b=LNfSHlBDBlcGNiTXD24yv0QIbjlePoGVUKk2F2qWC8536yF4NspZm84e5sWXooyFOaMXM2bB3
 53kyB2FJgeBBMeey+f+PS+6i3ZwXM0LcUIGjpZ/suPD570DJgqKxnhr
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3AB8D4000D
X-Stat-Signature: ws5pmyw313gu77hd4tew8hfeitkzdmfp
X-HE-Tag: 1785285325-652565
X-HE-Meta: U2FsdGVkX1/WNo8Fxp9KDyj9tR2aq4DhcDi51zVyVX77kce5JRNUuckjZqkcVOwvtO4u+lBkbVkrFjv200TScUP3RvohN9431r7rsbIBshA5Iy2bmyTz0Qg/veIDdEVgfm0OvtMCWCiFP8wco0tY0Nh8Ry8gmRRRWZ87KJcJUJtDo9g1pUKm5TyzPQFt1OHNi/v2FCacgVQtWGEPpPi5YqYWc/ltgkPDUv5HNQnDUeJqXe3qBW828j61CWCpwUpqBLOg5W46iO/fhZzhhAsemTMHUIpGTetYrR5Aj54zAMw1B6EWQY10XtsRCrYWapZRMs6013KHIjY98m1cmvWRPwtnPD7TUMmvGVJgvahLJ85Tx9q5e/cRX2siVOl4bwJ0yqhGCf6xKPkJl39syJ+qKg3pdzYi7bFIu8x7mTmhdg30BG9ut5OrQC4sBMPICZQlh+oYT85SUv+p3FRtyiJzUKZociaNizDf1hQbzrvAWTLoPhpquahed/AR7rhixFB7PJAsgQk/uhqyJsUdjXJ838THPp2RTukSwAeFsmpYBudcS/H92zIcbbryN1hjKCv2KWecAJ9zOAItt4bODYAf5lNWO1ureM915UD0FQPXBVkGqX9c5XrxqlP+C1v0b8LCUoiRehwr4nLvFe0xT69Liqgt7G6/Ydbkr53/UPRSfJ4b1jtf8yn6/ZiJzWyIHDzJGfidd6fsn/eVGQPcNCFnAERQLsUiZa55vjJsErsayF+IXaYMqqjq1vg9grV80qifx1V7Gf+vuLrAb1IgH/fw48bdymcPM2r79KLADxNVpTnGPpTgh/NAp37skydnw9+HSWTYHXwIpl1yn8Sb+oaAX/XeF/IetCRrpF9hLapkhYYoOvsM+KXfMQMBeCoansg98HMcS6ewOtsz9yyhycstJNOX05ppmGKCbSyl6Gu9a2gZ5vfmOGH5AUhZxrLcQ3/0qkCFDfGSzjy/QsLqIa5
 yh9wwIY2
 7CnZgF0cU65G+i/t4Sw7xP286eIq3Aby8yMgceufy/fWINgKL3+ezdRQ5jzVKshCcLRe2+WGz+bR5+/h4JEmt1UED/jrB+0VFqBXyrejqvHXNSVRQak9r15sStA++5RN2WGq0FnE7PVbNtc3x+VVK21jTS96wbwxxWqoH99sOAM3LA2sF5DZYidefFbQC1wB7NJYQbvb/OeZIooSiY994HfOk7VDoFsqzXmdK6GbEcJesduJumtmG2XR/RoDR+xwbO8PmwJ76P1d74XZxenb9B8fUtj+DK6XwWkARBd2VeRLyHzURYLT9gH09RgeDuqVT/FF39QOyTCFWBWYcfqmTqnjWXABaMmeGd9DfbCprc/nAlblLomlTQPZg1lbHVOdNV7DzNirzVKhsvlYxNjgfkhveRyhv97Gf7jTRPq8uXfnr4wu+QjvFYO2IKD8craVebmDcZ6eIEqwUwBo0PBip3TDcM5W+QjJqvQ8NnQQEK0xiTpKo9s36owSeOFHDtsUTqHTgd2H0uybz0BniNXXvipFIWVwZC6HNhP6bhnkhAQFRsT41S8IHuOeUTw==
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
index b726e49a3cfcf..5f71eccf3565c 100644
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
index ae0d7ff13f9f5..083717a11ff2d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1334,27 +1334,20 @@ void vm_guest_mem_fallocate(struct kvm_vm *vm, u64 base, u64 size,
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
 
@@ -1691,6 +1684,22 @@ void *addr_gpa2alias(struct kvm_vm *vm, gpa_t gpa)
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
2.55.0.508.g3f0d502094-goog



