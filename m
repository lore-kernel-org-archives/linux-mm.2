Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46D2AC88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:58:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E5636B00D8; Thu, 10 Sep 2026 19:55:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01F8F6B00D7; Thu, 10 Sep 2026 19:55:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2AA26B00D9; Thu, 10 Sep 2026 19:55:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 99E026B00D6
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E6D9E1A067C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:56 +0000 (UTC)
X-FDA: 85199513112.08.D7AC9AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id D6CC6140002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MLOuInRY;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084555;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NPgRleDZmf8uZc/j7Tjbl44+bF4o0zwF37uMP/68mSw=;
	b=OsGsaQYy4zDspKDVEYSgvWApgNDPEpjRFwd8j/I7Sq2VDIDgEL7WbTUe5QB/pRV5W417hj
	aARDYWcuN5vfCXHWk5OUvPnFfc5nsGW+sqqVkWsTQgTSSJBzJumf3SNN85FaaqiFZ3xr6I
	jZ4oDl7R3thyHO2KS8pJl+CYf3u3MuU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MLOuInRY;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084555;
	b=R8WgA4cjnPfiYYY6439p7wIDuoQuaqwQvaLRNZHA0gpuBkidkqZPobi0w0zqN0mxgXvK8r
	WEbGGyw/asIJIUQtzeyIx/lYAvzxIMYXxJQDheGSuroOkXFbKIqrF6iP7EchmENzeXPp2+
	t6zdSM7TqqlYzMDlB+THe1gEBZdUJIg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DD0DB44799;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6016C4AF49;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084540;
	bh=krA5hz7HtcdL/2AO1w6qL3n6q6NoIrwy3rbPjUAX5AI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=MLOuInRYDOp3UBSoH8bjPqq7UNtBADH1SSqAX2pd1G5DSOivsT8j2lcKEtCsv6ohv
	 bFQQyfvuid9Z3u1BPQnuGlu9Raeec2piHqsNkhKRyIJA4eK4AkyB3u8+xBa7GSqyO7
	 aBxPoiGJ7ZhwxFs/h+RbdCewwqp2cv4b57WmLczuUiJJuYrVUnbi9LYexYH4Szhdaz
	 FeckWnGHt72p83matkv3KmEgkk3jYg3/HTfJPK/phBb132gSrQIawL4m3Vso0pWyFm
	 mNYStyaQA2iuvN4IVLx/DhqUlJTrCscFaLYMzjueup3ORYGv+8zBfLjYXyFEDlWwox
	 0Q957upj4oucQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D737C88E45;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:56:06 -0700
Subject: [PATCH v13 40/44] KVM: selftests: Provide common function to set
 memory attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-40-dd6fbf94f4e1@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=2854;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=1/PrFhR+Jcqortt/tjzyF2GiLLRo3REbU1R1OOJ5JCc=;
 b=ZQXLccx4nDO/MrYnHXsjXfzJv1NeYR1fbq8hVTmY+W0WJw/rKoaBlB4rG4gxTXmgJytCd0NOF
 RKxxuWhagzFCrxb50Fzh8k3TGNQ0hZxyl83FyW6OSubla17D5tH/Z+/
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D6CC6140002
X-Stat-Signature: 17psrc9sa1x33naqyfokr84wsq437rnq
X-Rspam-User: 
X-HE-Tag: 1789084554-9645
X-HE-Meta: U2FsdGVkX1/dW7V6aAmkiDOOI5aBFqup5Tiq6INNU/HI4w3MjKa/JHIaI/1Bel5eO1Rr7ulfdHSK3/Tlcr53SPsq9Rrv17w4Tg6V6miCmjdQDsR0ERgPBQKdSADUCD+Z10OUmIxRjx2ZttS+yMdwv9QbV31x9LKIAr0wNhqujDCPSrfK0IR5RhKJbh82xRnb5ZkD0aGbiOQ5vyoZKpfKXiQ3OGRdhAMasiFYQfCWm5tK1Zu+wxsUbT4f5GVU2Jy+ocrGfKMmYe01ixNWFsBAw+xqjl63JfbcjPhsI1JuuRD3JWFgxIKs1HQ1FLwJFPYnQPqSfaVbyxe9s6Cn9upGV4Ejm3RRUyhWwWyUbGXSbOM+pyU3im/4RjrqzeWWBlVG+aIa5t9+rkarZTTJJbkkbf2wCmzNqGoVgusqMOqCwv3jKI0umq3UUDBVMSjdMIjU2A/41i9obtjyUZqSHJMTG3PXSlp2pwrXq8Z9B3DLrqan8mZ63mCWKxXHc5YgeRMhlvhsJYsPjf94jqFckFIBrZG3FY3zGcEgf5gOWLeEqXM6le735+8x0MIjpiz7t2mx38JaksUbu5Sz+P6I3d5xDBcvpj6yJqhhvxyWXtO7iRATPuXHN/tXL+dhY3Y5BtHENbOOBLRcUBspsNbW0NafSsySbopeRoJ9Wyouf2v6BzMDvmwlpGaZTiD9wtnCeJmOU79OkF6IcAkk8i6jicQJAELqZ2xGjBvER2bpEIwKsNzoP9uu3phcdw9P0qc3Jxo73b4aTiAqoP593wExY4taXjUSK2kr09NbEQWzzNTgQxpqWlTwUpT7wmpJ9gYO/va9qSMCL9Rj/cYSHccFOxChhBlhQT8FwvKGwhZaYcLb+94KxGTnD3bkzVaoWsUsZG3FnkhP2a1SbJnIB0vzoxNYHjpdTJefaSDQSZk5miNplLfKFLKdwosk9HQ1C7ausYfUZL9rcwSVJ/6z+VH93U9
 +lIe/Scn
 /XSIZQX0VbaAh40zMykMLkXwFfTafJrtfEeLwE1LWsWgYPsIrJKwHnTbWEpvoywL4Io+OxULUjy9Bkz1uDmaLIAHBLHQ56zogEZGc3taNZgupVYOlvrxXksvfQV95s/57PenPCRtPq8N45ZjK4Ieyylh868nTHO6OAfijzusFXPUDfD6LMXZU6etyirT3FXUPCk6k2OTkMFpvJ7767SW+8wyRBxUl1IBjKTcWIlyWnx3ahZ+DhfcbfX26sklE3llgSBER+RsVGwmjaLo/gVuphuqZWqDn1HPHJ8I1OynrwAsEh6a7kXixNgQVuodd1zPPTCWhVhIsF58gNFm7uvE/oOVEZDD/Qsldc8AvHWLToR8oMzhfVAA7gk+EjkfA4ktLDxsn/lITZeW+OCapWxvSArpU4WhD9YYj8rMIexHPQfobcwYzTgg/OWLdFgrTKo6XpZa+03Wdwche+c9qD2sc/LGO4/lvBI8sQI9C
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

Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Tested-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
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
2.55.0.1007.g17ff1f9808-goog



