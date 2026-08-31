Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75C13C61DE4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86DB36B00C1; Sun, 30 Aug 2026 20:25:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D0656B00C2; Sun, 30 Aug 2026 20:25:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 621EE6B00C3; Sun, 30 Aug 2026 20:25:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2C5F86B00C1
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 88B5D1203DB
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:46 +0000 (UTC)
X-FDA: 85159671492.11.6AF7E51
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9539B20008
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:43 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qLdd0WYG;
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135943;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f44BZmoGM2Z5mL+2hXpZYIoU0kFITasZv2kHEBARFZc=;
	b=Nh/JO/vFlUbY6FJN9gtRrnYbXStY3b/zo38I1KKuch7CNjdQcA0EBP9rqZCPB8fbzxTeg3
	Ll3Yk92IiEQefo+GafK10musQ3ynUmiFwb4VioOAfWJ1XUxYFnmwnibiSQB64M3nyfyMcv
	Me7s0rPkgCadvmC/XjGT2D2S5zze9GU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135943;
	b=YvYBDuqKGt+F61+kNJ3TWtlu4+8PdHWElkGX86AxSJZgkYTgzbYAXYWjvoW50k4LakTfwa
	ICAplulr4T5u9elsl7vBTaU9adMNJEA84mao+CQxA2Bn+6Q4gWzZfuXMK0n9W/vzQn+djK
	toyluAW6az7K4UWQvyp4kMjFrGoWoxk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qLdd0WYG;
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0CF35449D2;
	Mon, 31 Aug 2026 00:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BD9EBC2BCC7;
	Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135923;
	bh=tbu5H941T3WFmTkcFYkjGccJoW2TPAMlO8ekt00YDMs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=qLdd0WYG07wxjmoTmvbspYTXLe89JNFssEMi+/rkuZGYIRdzdKg7RubQxPC5eEDUl
	 xWPTTAwNH4hVWxT3FqNU/Vbec3rXeaie2lyXwjrK+h4G9GHlzAc5jCWlFMnGfzYFP0
	 xRBQZUgqZqIdMbazPBh5dLiCtF3oFuLW1uPBIX7DgzhRL0FGgCACrjgUBx+J1jrhJU
	 A5dwzkyx6yZuROIt8d5vl2jcvZdQ0M3L3hgfECB+WmB+Iq6k7EUx2kh2men14JXQEu
	 Ejed8kqKvgMVxdfNM3soweAU5SAeUNYmfa5/nhl0TN563MUzz87i6EEZf477JX/bMa
	 c+KgOuJdDlLtQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B894C624C2;
	Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:41 -0700
Subject: [PATCH v12 40/45] KVM: selftests: Provide function to look up
 guest_memfd details from gpa
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-40-85e5fd25252a@google.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
In-Reply-To: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135916; l=3994;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=aODtj3bXiyKjP4uoEZrBjbprOQXjj5kFxo+MyuHmpxU=;
 b=814LT748FADHWK7t5YnPGMVd2fhYxt4cbFtAGUXwoXEic+bZE3wurSvaMhHeph8EyNcGn/JJt
 Y4jxXfT+FFPDaK7q3wrjhxRlMZ2eNvl2G3nr6Qflsl9ATYEbd1JM9x1
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: 5qxki1ezi1ruut6zj9oc9xd6aegfcct8
X-Rspamd-Queue-Id: 9539B20008
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788135943-192543
X-HE-Meta: U2FsdGVkX18qLuFkNNfi6NuaQ+bkSAQ9Enztqw9bAKSfDnC1o+ahiFCAaqxIZbyejzXxXpW4xbnJiflyoR0lCAv2tATVfMkyuwy8IYqNl5OjaN6at9M97y5FZ79YWb5UXOHinqLvxecLLZYpyL5qW1+0uYb7B7KHYIPiGLZ2345FVgBe+sxM2L3xu9yTP1UDHOw74u97pSquFTOPwlggPpnxrj+OSPwqWWPv2AbXEJabAAUdmV2nWikfO2BN6GXGdjlQWJxKKs9HgyUDzQHPgU7oj12Q+vEaZDixAJQ6bGuVPvzZaQ/+w3rg4cI1bNT1fFjCYU/atPbl637UnxK2TUYWG9EKe0/FduGCO/HvQphrDnho0oPFE4o/i8MJENvVUoH6/0R5PBJJkzJV7mmaf3vW69nOsSZZzKOzo6ovD/W8tRJ0IDqAsnxyXPyEDx9DrGamhvDaffv5zu7xQkymepMN5/H0iEir4Q1hQEyvjVmwcSXOIknJ6VSoRhPkLBA7vjglneVJkPWJpxZGsj3Hjhw9rk9UQZYRH0GPG8a0/X5B8A3yST1xomZHoXin1VvPKFfY3sxNGYY+1GK6zuMl5brshteUnHl/CvrlbvFUJ+375YyGndO2tdPfskJT0TwbydUfp3c+wGxCu+YGvbYJjO/cqvUDIudCYWXsGgIaXFKUiqDfjhnrWEpWkZLI7+yTgdF6qRp1TQiuH/EWcpww9tzDQZwRUqUqA2PhX6PllxryejukVzFSG/XpRsFvFmlc+CKCQoMK8dux3/xVk9o3bJGqeaxpO6uQmjG98Wl+oOnhvApX5YdKycgqiHVBKlmJaQoIniynGmCrDy0EYxxhIsmU20pI/92ydm5264kirinyJY9zGYdzUkRDCHIDgCcKO+s0Kocqh7AoseVlA3xX51TtrtQKUOLasvy4LeEVSwJDSchlsYO7i5lBozE/+y4SwrjQyB0VAwhurKWj77e
 ECU02HJB
 o0pgyYEjXS/PosJhFRFInbQ/Mm9U8NPczft9Dzqxy1XIvmJ+sUGaeDJeXjEW7A+KJWnIf5VUrJ64iSLA1BvZMhh7PSneSlE4weHvVvXRIhhpkO/pYLqkwSwj2NNkg2IP1Dtl4za8U0ShugtjdGYnWAHA/LRN9Q53D6+bNjZaKFpNynHUP9iog+cRjORJ48/xoAC5Vn5AvNpKYTf/tAcvMRv8My5bdy/imXaCbF0V9PShhnH+A8qnSkejKm5sjTcOsuuo1LlWTDfecqCGDR6XS+ALZ6nLQiXJ8WKymJ+nxKHUyuZJ8xMytu5GkC2zSHYf+abFU3UIbiF4t+CJdembiAMcYf7QdWA3++lwJeIf9XKWbN8rGt+iHioY6etc4Kc1YL4s6wLSXj55DCRbCByBIK/PjMCgT+YfMg7e2o/K8kRtTKpwFlii5GREcs2OIsUH2JGIUM97anZRA7P0cOXEeKbSiIStLGrKIopZ14u7VhJmafCi/tiUUOo7YtupB6K+mMP/+pcrc30XUNnBAGJRk5KtM3w==
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
2.55.0.897.gb25b4bd76c-goog



