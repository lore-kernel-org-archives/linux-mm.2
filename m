Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F48CCDB466
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:34:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DD736B00C1; Thu, 18 Jun 2026 20:32:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B5456B00C2; Thu, 18 Jun 2026 20:32:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CADF6B00C3; Thu, 18 Jun 2026 20:32:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 257976B00C2
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:32:12 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 726731402CB
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:11 +0000 (UTC)
X-FDA: 84894785262.29.99A7687
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5FD9E180008
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:32:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N6Vfe1Rf;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829129;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L2AWilvfEaDU0aXP2CI5XYxjn0UnRN58vQXIJlKCig8=;
	b=FDdvrFB3RtuisT6ZSeKxd8eDMVewBbrPnXOXFg/IvbflLvFUcTDVLxMYJW8Ime9m8MtDF0
	jAgo8jrVC/ThoJ8C0r3maxniKP2aIExXjujnwd6sr/JekO+GTG7Ch6pgTimZMQ12As0u9y
	ghV9MDTbf/nYQL6Lblg3Hm+PGUWp/So=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N6Vfe1Rf;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829129;
	b=C/kgnAbfB3Hnka7/GtCBBhLGg5tP4pIMo9Zc/9K43DFXNQm36x0ZYptyHUxXzOtC0F0bKR
	RSokttjK6lO0KnHb5BSR5jL9CYfUmuu3LdcVlMFLuQmuyn8/PAfsOKu4qcGkN9p6Ra7sIJ
	ma5DiPf3aGXpP49X4F7bzhiUgMe9jEc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 651F944E48;
	Fri, 19 Jun 2026 00:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1E80AC2BCF7;
	Fri, 19 Jun 2026 00:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829111;
	bh=g5NEVCxHRsOa4CTjsg5/9FyDY9gWl8MzjGmoFnMyMko=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=N6Vfe1Rfx/Q3zOt4vBLMk/dsXezbrog4XC51mILGxQALSyY7ZYMxgHVqgATbtiP60
	 5m2hCIgbycNA0OCAVjtmSN4IVQIs9D6aix6Qbc4Nrln9z5Of3zD0IOYG97gSrnriAW
	 yreaWpMCRwiE1MyhNK1pyBUzKu8dX7P6zkoB2KyP9cwX9ar7nl2j5RbKDv6CWdyGB2
	 0y3K0XNI7w2v0ZpYAqIZHtNAkP2d06lDbG1JIBOWF1C7ahJBTnpGrE8MvPx1sCOXLu
	 uDBaLjEyx/F4mAB5fe8ARhNojqp4kaPNRIVHymFbMN8n8tNh0kwJHj4bo1jSvy0Bom
	 OSxkFsQwNwvgw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12E92CD98FA;
	Fri, 19 Jun 2026 00:31:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:32:19 -0700
Subject: [PATCH v8 42/46] KVM: selftests: Provide common function to set
 memory attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-42-9d2959357853@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=2769;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=tiVNAEU1I7TfvtHyuf+7WL+w7fPIZRZXHt2nl9FHIO0=;
 b=YB1PtYY8FjnKeEVp75aeYj8b21mZ2F9NvGoH6fo1UZR4SkYTRD4lJmExGEyLzFBdpKcL4RiCt
 df311fbyn4zDKj3VyN8CaknxJBCuXqd12tAZSO0ouixgtK0j1lQkc/j
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5FD9E180008
X-Stat-Signature: m3gdadtth6d8jgm8fiqbat4brfips9bu
X-Rspam-User: 
X-HE-Tag: 1781829129-767956
X-HE-Meta: U2FsdGVkX1+GwC+2/92dPY7GOwaC6+lX7bE3Oece9xZsSO7kgGXHDntvk20Hb4ryuNazMMBhYqp+WffS3q/dKER5p0cLkqamfX7dN+nXA1DZ5efuopVZIV/8MYYhTFe8otoWjSpF5y8kgDcP5NW9ZhF5oXIEE8qWkzC9M+SeKuG5ktXhhbB4kev3XK0cKcnCvU7QNcL2GT1Axm1aG9XRB/98ovqbc/pHYkaNI1jskZIk/VtTMHLrt3dc/uxGnff50pmY9A2U7L7w7wlAKSZFMPz30giz6pWWbopc29pWaqb1K4v/ff7dBBIT2ijsX0yo4Scs1aiLfnxnUMEAtOXbVUVFI0UQ6/A94Ce1j8OdYemYrJcGwNixeGwtiYXcrCYzzKCIAatuKwKHeNI16tUGBTrmsnhBfxFyXYmPQitLfaMQqwtYdh7OSUPwZ4tL0VXOSGgNIk3VMuBaxj7hT/Y5arQUIjdYom9F6ED6JtlKgwXoRAgVd4qFgGdGOPIN7fnXPP+hlQtPGO3YUgipGPyiE6ngSK1JIQN7J4jpH2+UCG/soXBxlQXV8AfLXi89FvjajnRwARmhQfQDZUN7nTMFsleoBmEyPmGhAFj8sg0EmDZn5UzcGACGqgs5vAvn5j/gTpARUnTwxMuWWWqqDtriK98Me1x19jUiCgXctBZP+7Zwz7g46/rVRHnk8TgKsp+hxyKF7x5ZrspoaTSm9SK+1NBt/2Bgn2ZtjHMTEcbV8lOHQ7qn88JkcZVeI1EMdU6D3QvR0rsIHEcV8wDr824DbBM2yqX/BpTo9m7nJ2Zs+EWjBJkBufK+0KepGHk5NmeMvNH6f9LsBE3hLJYVUeFdge48ps0Zm+8YqfY2YyAaP6ancBd/834B6ZyMIurnp39hfsbZjUIIs9g4rmJj0bKobfi+z9f4Udtmx7PkXoI2aoGaSFvI/XF1a/oqdC0IluzGgw/iJPMskCTf7Ib+o56
 BcKWLeZ1
 /ZBFNotO7KouIXm2MhlEcZDpLcgs9/4D5NZ+P3dhiEXRTsLo6SfqxLI0mzAcjkp97oL4CZRblQWfbsYIvZxyxvDGC7O9fShSSH7yyGjCEL4wC2GhsNyEnhmH9SY8su/B1b+IHVZAEhZEVBbbcpEzdaienyfkVdxaLvoFDDOj16DMyBlT4hn6kbvKHiTQXe560cSDpVFUPbPNOeWTJNasMjsvcS8BSgCH4YVCSh9Tls6hRLVsW5ixPql/NJ9ZcR9vogBHDamUezegJ5Vm/GHN2jPtB8cWpCLK0A4GIbs2LoE/j4BkBhg54W+o+FkHndoiOtCKwCX/YT7BIVwfEB9X1LLo/TPH+9IIqniH7gAM1U4MLsDg4guS4CWNkjKxVWoJcL4Fb6rtdTmsTCoBTMqWZQsIdpPz7gvhDkZHJTXMm7ZOw5Tzd/FRndNH9OrHQviJsGQ/w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Introduce vm_mem_set_memory_attributes(), which handles setting of memory
attributes for a range of guest physical addresses, regardless of whether
the attributes should be set via guest_memfd or via the memory attributes
at the VM level.

Refactor existing vm_mem_set_{shared,private} functions to use the new
function. Opportunistically update the size parameter to use size_t instead
of u64.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 46 +++++++++++++++++++-------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 3a6b1fa7f26ef..db1442da21bb1 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -454,18 +454,6 @@ static inline void vm_set_memory_attributes(struct kvm_vm *vm, gpa_t gpa,
 	vm_ioctl(vm, KVM_SET_MEMORY_ATTRIBUTES, &attr);
 }
 
-static inline void vm_mem_set_private(struct kvm_vm *vm, gpa_t gpa,
-				      u64 size)
-{
-	vm_set_memory_attributes(vm, gpa, size, KVM_MEMORY_ATTRIBUTE_PRIVATE);
-}
-
-static inline void vm_mem_set_shared(struct kvm_vm *vm, gpa_t gpa,
-				     u64 size)
-{
-	vm_set_memory_attributes(vm, gpa, size, 0);
-}
-
 static inline int __gmem_set_memory_attributes(int fd, u64 offset,
 					       size_t size, u64 attributes,
 					       u64 *error_offset)
@@ -532,6 +520,40 @@ static inline void gmem_set_shared(int fd, u64 offset, size_t size)
 	gmem_set_memory_attributes(fd, offset, size, 0);
 }
 
+static inline void vm_mem_set_memory_attributes(struct kvm_vm *vm, gpa_t gpa,
+						size_t size, u64 attrs)
+{
+	if (kvm_has_gmem_attributes) {
+		gpa_t end = gpa + size;
+		off_t fd_offset;
+		gpa_t addr;
+		size_t len;
+		int fd;
+
+		for (addr = gpa; addr < end; addr += len) {
+			fd = kvm_gpa_to_guest_memfd(vm, addr, &fd_offset, &len);
+			len = min(end - addr, len);
+
+			gmem_set_memory_attributes(fd, fd_offset, len, attrs);
+		}
+	} else {
+		vm_set_memory_attributes(vm, gpa, size, attrs);
+	}
+}
+
+static inline void vm_mem_set_private(struct kvm_vm *vm, gpa_t gpa,
+				      size_t size)
+{
+	vm_mem_set_memory_attributes(vm, gpa, size,
+				     KVM_MEMORY_ATTRIBUTE_PRIVATE);
+}
+
+static inline void vm_mem_set_shared(struct kvm_vm *vm, gpa_t gpa,
+				     size_t size)
+{
+	vm_mem_set_memory_attributes(vm, gpa, size, 0);
+}
+
 void vm_guest_mem_fallocate(struct kvm_vm *vm, gpa_t gpa, u64 size,
 			    bool punch_hole);
 

-- 
2.55.0.rc0.738.g0c8ab3ebcc-goog



