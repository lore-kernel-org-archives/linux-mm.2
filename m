Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4156CD37AD
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:24:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3F9E6B00BB; Thu,  7 May 2026 16:23:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E05616B00BC; Thu,  7 May 2026 16:23:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF4026B00BD; Thu,  7 May 2026 16:23:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BBF826B00BB
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:23:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 89CAE1C1352
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:12 +0000 (UTC)
X-FDA: 84741748224.18.8D97C88
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 85D4D4000A
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fzvd6/UO";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185389;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lISDKBvtYKcRLc2F9vK0dCohqFHois9EN9Zz7+OmGFk=;
	b=LAx3AMpctL5iFekhHax+qriUfW8vrU3NgjDlSz9ab3WgC851HlAqVMmPcYjnpY/9zwp5jZ
	mMGShgBfTluWx34+PeC9f/7O7LsXyaPIpEnON2hciIXwT+kwRZsjTsdNrioWWIZjvENUD3
	6EfU5YbTTb7o+Yg/bZ2MKmWxgsMFpbA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185389; a=rsa-sha256;
	cv=none;
	b=eD1uA/mIr7wLC54tPfzNC9I+ICzULqIV8Nxp4fglF3Jc0R1R7liIxVvms9XGMZYj9ejanZ
	ByOEYciNi4j2+KM0/3eWFWx39/JS/ygVv37nANQRB5x4UnflFFHY0K69DzxqKRMyCubaBL
	Ku0eMbvKRAJJmcfTZWsaqcDqkkgCe3M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fzvd6/UO";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 461C3448BD;
	Thu,  7 May 2026 20:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 078ECC4AF54;
	Thu,  7 May 2026 20:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185373;
	bh=pPQQU8ZquGDc5woI3IF9NwZh3hDz8qw/u9ovucBYlww=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=fzvd6/UOn3T/sQehRfu+1lMd8kE9n73lEEL6XOkOJn2OyiAFD292zjr0Hx0ISuEpl
	 FEcLEhNABOO5HT+hOJ54V6Bljg0KpG3TJzhP/BG7ebOVCk0/aLlVrH8rJBhZxr/2ji
	 l+/vJ9w00FcIyinWGnP6tqOKvgoaSvIbh7UfKvngcnDKIklAj1zXiZWYH1D8Wab1Jp
	 KsWdA3ZPm1ojAz14Jun7i8OPzrkKcoIuzKipxhgeVlgyh2cNStHWXVXZ0QQPHSuAVd
	 f9AuSNEqOt9prvLkfim3can4AbVbHjYj/eXhAbgVTaxZr9ZN337uWeLoBhqqKB7jXS
	 TyPq5jJxr7kmQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8E0ACD343F;
	Thu,  7 May 2026 20:22:52 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:56 -0700
Subject: [PATCH v6 37/43] KVM: selftests: Provide function to look up
 guest_memfd details from gpa
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-37-91ab5a8b19a4@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=3906;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=xNCKakm4lqe+pmjFgVS7wo4ZhPYHCXdFbzSjFPcag4M=;
 b=UCt2SNnICZlnJSPZnLmK/7mEn5zP0XIxOF5nvBDiH6wNJ4ztx+HYJvK2CEx5QGGYLQYJg8mwK
 4hprW9He5esBNRrL2NCxQ/In/x7MI0yA78dKT2W+HYPt+W/hGgOkwGp
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 85D4D4000A
X-Rspamd-Server: rspam04
X-Stat-Signature: 3x46jir69a4chk6gkkewby8fha7y7mpo
X-HE-Tag: 1778185389-673155
X-HE-Meta: U2FsdGVkX1/N325Ykq/+b3QNks6bXZ1fjWkiC51L3wMnoZzY8DELVL/zjMsVtKm+3GpAcC7WQFm3Q+pZWkJMV3zEe8FACA6xav//4AWRG3H36bNTq7CK8d7Wxxol/BOa1f5D3UVRcAyqjGJ/og+ASOygK//A0vmQHQ90BdXoggYhORlO16F3TD8yZAzNrW8gUujhCje11Np68rtHJRBzsxeDbFe0w6Te1GGNGrRYP3szl/jRm/Nq4PpfnhWSDLezAu+f2t6ROdmio/3Zxd2Gvl44BBY+zzVdSnRWD63Ymyr3AaoWgcMML8Dh2aY68FVgUKe27paGwNTkYxyZb/IJm8Y476PLZRdUKZtahU61/T9h9cFFfiR26Ix5VX4b65LzbhPyXZbniN41YAc1VI+TQlDhW1INT6iDhgdXwTZLWeOuz0VhsoICijJQopukOaEGwQIunAg1tX4kYtdu9JEzmPpjxjD2YgBzhL9BeeQ2YI2hMMITPjCNPH8wHGa30ZbGgSgYUMczd4O3QLQwTeDWnypoorUDwwApJ/uoKRyFkoSZKb+zMM2RPyG55pKzwhb27Z2j0RrGyQyBemfC33LZdClVs5hLgkuWc8LvFRd6ORL5f75S7CRraeLApmPEViNIiR7iJyl9kBOYq4iRscUUOwL5TvYQ39ExjYMiA7lvhR7Yroh5j0C+bp53tvwQqCqqm6oQQky/8c8dSQO0Yg2IbVKRN1KetbuWoVvwE0TjutVoCkd+IRpIwzMr225p6JDl/dAMzYtNhuRbbNjfsCxTr8mlcJpUvYESzaKwlx9uMlzW/V0/fEi4Xviluh8tA162wSqpbcreq5lXem8Rgc2PHAp6QoIDq3WD2GrUti0xrC7vVb7c+kZj7+fCo0EGzJD3bdF6jLYvpHlg8p5mCbSvnK4vjLfD1YhPDJHJ1aFHxnco1FufDuN+rrEKu/yqwn9mdm1WeQsL/rgrDoDSJql
 6dKDlg+L
 V46uptf5U+wr6xAs+jE52cD5tjL8lN54/TLAjupjIbxb1RDng9nHm2Ky9ZbotvfmlpDTjwPLM2uvtb0L7aVfEpTb3r0NJT86rK587h/V3dghvnTn0RB+bkj83vdUyhv+zxB2GLbD9DgJbrQFWQN0rm4kEsFoYmzfWFLXEEhEFBgf0J1R3RhUjaHgQ6N25jwjHQYO+DEc3N5Yg19ZBlOf4ERoiH8YbTPAz3frIk4onw1FmUuBhxvEAU5yluyTQWcFGGm8oLu3kOJP0UaRS+PVK7MqLYjBzAxkt2rGkxqIhV5hbgzRzjiMK12SIWNufVnvc9nw4DO0X+1HWfavXM+TNzFj9znqdIkgdw6Yg1AA6vyHRhTIsuxmrQW8yhEFnvtS5sebn4aMQjj/eWGn/+mWWtzm6fvrGrb0rOlvzrqcJiM+kg94QvfTmbSOqrCorzsouN+gvTAJxwXGOVk1/5jDOi5Rtue15F2hoEXx78iDBHy51AD9NL7AgTMN2+g==
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
index f7c49739e97b4..4ad184ce3df68 100644
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
index 5e34593ad79c4..8ff09e179ff5c 100644
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
2.54.0.563.g4f69b47b94-goog



