Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21D5EC61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 00:28:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60C8D6B00C3; Sun, 30 Aug 2026 20:25:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C3A66B00C2; Sun, 30 Aug 2026 20:25:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29F826B00C4; Sun, 30 Aug 2026 20:25:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C3A7D6B00C2
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 20:25:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0FF231C1DC2
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:47 +0000 (UTC)
X-FDA: 85159671534.19.96AC8D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id EC5D320006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:25:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gHjsbYh5;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788135945;
	b=oYiz2tNyHX4qAuAF/n5Z0uGJ2ONmuY6r1tJuknLE0uMRMr46Yx11H45KgpKp7Q7cTHxxV2
	VK5ZuRqPYZ0sToyzQiZD/wuNG+DW6aD6vnEzr6RpcdozYel7CE3fXX/UwVHBibM0xslsNo
	QgwxXcOYAsYApQtVdRUGczG9rjpWYWs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gHjsbYh5;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788135945;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v5w+s3kCjyIl6oYE76B2RAE2924tJq8Zq7kNSpYdP2o=;
	b=qOZ36i1kzuqY3d553Fd2cH15NfjUe0dhaBLOupbDrdRQAe0bZjlkTAWYpuhW5Dfn0EWGA+
	vAEHhOvDImPlvaf8BgYZUoc4vr/tsCvUIizgXKGmTnRqS9dVxb7mI4dHDcwNeFJvSyBk7o
	MjTU5grUdbfHyNUJmHhUOgCbQc0JGZs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A122449F3;
	Mon, 31 Aug 2026 00:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D7931C4DDE3;
	Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788135924;
	bh=cexXrOxEwxsSXxGvJ8HyqJerH22y1Xrx1Bofk7vx/tU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=gHjsbYh5k68Td95Qf5csBpAZ8wS6LrH1hg9ScJ8atCIgNL68EjJieRpZA7s/r9v2e
	 5RQRMMnoDDkzqp5PsUYJhLv/pYGI370ogX0OiZpe+FOb3QYyR0NMHlHzbSH2yyEPks
	 g5USb3Bj1bCT2g7EmNzj86z3Jv7lCh5aOpmEj34NmSpqKaPxc3Xbi+YE42e6blpAM4
	 YojOCZIwT3P1jQcculWxoz01l7im5FMKWDp3RAhGCfiTl/1n87uE9UUgOpm2BiVVZN
	 Ugcjee7SrYxJcUAtQKpnalO59P9EkJoX/a5P6L8WtXeKHBS2UVA/z7WeeK/FhY2jOt
	 oikH61TQ1Bwyw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4967C61DE2;
	Mon, 31 Aug 2026 00:25:23 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Sun, 30 Aug 2026 17:25:42 -0700
Subject: [PATCH v12 41/45] KVM: selftests: Provide common function to set
 memory attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-gmem-inplace-conversion-v12-41-85e5fd25252a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788135916; l=2853;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=oZL5zDgCEKFycuVBPQBHjILKCAfxW/6ACiO1HnvozsQ=;
 b=1CjiFY3VuzGw0xAenTUSTcXrsv6CaFEldIqZtdOHaRPqeX00Q0helBtVFwlfAJBh8N2vzV6j7
 0GQXLuLZAYrAGSUh790JSJenF9H5v9AwVpAW6qLxEJf5KPAHFld+9PJ
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EC5D320006
X-Stat-Signature: h3cbu3szcz7wmq8i9dtt45psk5gy9cpg
X-HE-Tag: 1788135944-333476
X-HE-Meta: U2FsdGVkX18KX2eKQbzi+i6ITHOUl3BaB6j3iTdeEFBAOMSE3iBpKyWhCfS5HIWs1uqDqFYgembPukxkAISQbxuHiVJlZXXBpcoHrXzqbCWKkC/cmR43Zb82pFkcqaJVX61XqBL/UOjc3mIQw9Sqt2EDIX2gTtnrFks1JsK69a8ZUIC5TFuQgW9Lqle2rkn0gApcdNS+zc77W7++IvOZ0sMJVXg8OiUNKLeGKZneQ/wToAyNG5ck5ElD0YQk1eI1aHajRSKE4/Y/jSeuDAB1frjIakrIWK826tpEk3Px/QkoMdwFbaGStv4SqlBBDGIJgp5OCphu0qxectDp2doH1ME4mS6KFEd5cTr/cMFRPqD4fmvcm2yDpVm2rkOHsOGCkE2fNthNSJi/qSJVkqXC5mrIgQWft77orXUQdSBBmINTmK/+JHCghA7mTpzXpwr30U90N2Ek7QSFx8mv3nKL9JiAM3+RynbT5RhpydxGBMxGvaE5wSHxNuQcdJnif5P52SzcUZvfHNvPbnh4JSJI2QaJU+ky+tB+PCYklKqH4seqbsNT1QyiKckLHNhWx5qevBnLRVhEd2VHAfVlJLLlh8mk/jemOpxxTzXoyKXYN/MC0FEkBY3f0/qUlELE+C7f0MmtblqvNagaIlfTRr4rzKWS7X7gfIiGy3L0fn650kLoWGXBkY9z9aVAteRrMpM/H26F//hPFHOb/yxQA3UF7yiqCms9C9YqFENY4YILsNSFkBrvkOF7vXDhgW7RHdVmGZi0tsacEQHhQf8U4L7pvSzCCVEpDfqsoYk7ijUHizx53o1AZmFi6EI0rJC6p2UTIjJT66dYsXHKkxoPbl6oWAf0IjXG7+/OLpAWKB3/jqXMtG30SUk2jKr5bjeqqfvSmJGLwTSJde/WRYig7kbiA8rfNaogtg7hF2jJIPrQ9GecHLvmCsnvq9aryPILoxW6mT4I8A03Z8fiR2zah4T
 KMfMgcbF
 02AZxW/08DLRjcwgmPAD93GBgsBCCnklYLHQ1xMGBkqjguc1E/s+okNWqzWlhQaTBZMrEWwY45M9Nz03oeq/7nbL73BrCEI3BXeUrpuQH8BHpZ63evPz2U+oBF+Jozrr8KP8c/N6XzM8xkgAEXHlDK704rMXsj+2MPRsPO0AtuJWOARcKwsRbjBtrGaZVwvq8N/V48gAWBtuEOPP3QbJiLedTZ3mjLD/UxbbXsr8opShoROyCjlHHEa3Lo3R6XzH6w8PkNG67CI+9dnQyEA8il+VMLY9EAM0yuiiX7zJI+reSqQxmENxnujPLyCaYyvdCEaNQqhK4iUXTND4QFXc/TMvcbwB64C9fYkuASJnoghw8ztxTgFRErbvAjYvkvui72GjuUbmZAWYHXTD9QfFav9AQQpTYgvu7JJ7ztUi9UUGi8cDEdarnrzSd6NJM8rYJgPbp6Kjly4hYzSxCRg5+CPkb0XXQkK1i3KCW
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
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 46 +++++++++++++++++++-------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 795c9eb311071..777fa3dbf88d6 100644
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
2.55.0.897.gb25b4bd76c-goog



