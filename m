Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71176C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:37:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B09016B00BE; Tue, 28 Jul 2026 20:35:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE1666B00C0; Tue, 28 Jul 2026 20:35:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9808E6B00C1; Tue, 28 Jul 2026 20:35:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 667256B00BE
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD2ABC040D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:26 +0000 (UTC)
X-FDA: 85039945452.25.FB1893A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E49C280008
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YFsw8o0b;
	spf=pass (imf30.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285325;
	b=b3rhO7fM4KJQhAbhsEqQZ54Vg4GLI5gGSHFrsZeLSoYaJTNFLKwgZ9Xjj9d/Iai7Y2YM5C
	YzEeKikgUq8VxTW2O4Oun5zff0AKntK4i7cpLV+X95BLteNRsBdFlwOfObafEUkoT1gTaN
	zUq5JNDDqacN6V3IRpsNevIKaBMjyfE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YFsw8o0b;
	spf=pass (imf30.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285325;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=haDneXeNIeBOr3tfCRzJcaBTgAp6a9lo/fdgIGEeQ8I=;
	b=5kXptOVPntDtY1rnJb0HtKwErcDY9binl3WOijwFVu6RwphtRLiAYc5OvpCzM4WQdoEz3E
	YKyAlwfRAYGT8kEUtJ0Tq88dJyAXdLuLo/ZjRW65vyruU9wICPMrhK6anzhxAPmMy7ClFn
	mfGMrQb1or9o0TTn6ewWnI0F8YBpmSo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 420B745336;
	Wed, 29 Jul 2026 00:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0A208C4AF15;
	Wed, 29 Jul 2026 00:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285311;
	bh=dzszWiRGtLXKzHSuwJn5Dj4Ijz0iehffvpdPpOhI3zU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=YFsw8o0b2mjxBqVkNTGF/LLV6fYCYwJETXcIIVH0PZ3LBr+oTXYUTGB8M4fyMxkkx
	 jd6mNOux+/J7vKzihBVgJitmH07aozzzQTedqMFSJ2ZgS5KiIR6ivDu/ypNSzv3PjV
	 OfZI8uZkBkMjIWa6WBrct8BSRK8QoFoP9Zrztc/KcEHd9/CxuVzvLouRaz9qqp2D0m
	 k+dxpXLXk6rzwhzDGds8ektb0UVABqZVTSgnDiJLEknoqr8wtHs1HfhFoFZSBa66tZ
	 3V7eRAWxYHNrKSr2wDJAEZL7OohYMd+9hqd+GXAuHWGXYSNpK2rC4fEOroPqtxmQjr
	 Kq57Cb6nbRcUQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7A5AC54F5E;
	Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:37 -0700
Subject: [PATCH v9 38/41] KVM: selftests: Provide common function to set
 memory attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-38-35f9aec2aed2@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=2853;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=ZFDNqJUV+JeCN3vi/JbLOJvKOagt8T6quWRhYQHhTZA=;
 b=pdsiL30E1oWM0/K4yIxCyZ9LQS18BX6NlnyCYNugaAj+BwGMSHZWYS9mnzLoh9aWmCEfihWIo
 +zwM5ZNADchDRgyJo0cqUBvA7jHRW/5LhN3iV7uDVcUPi4MKhnL4tJe
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: cm8dqsdkx1d44j7i7ttgebndqx5pcu4i
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E49C280008
X-Rspam-User: 
X-HE-Tag: 1785285324-600828
X-HE-Meta: U2FsdGVkX19dFXsyThSVllaIv9Gv6K3cIz2USiaivLlS/7VhlJRf36Y1tvstNimRDLZVPOaWzDsNQ61+G5bl0+AFHf+rNZ5Dg44TsGJ7IRXI4ovBEOspS84X7GlQwaMRnPxI2JSkF39BEt6Rc7SR5HZr1YQReFBbKVtNtaW2sYZS5LwRI68pMLa+33GfflSot7kainrC+AnqF1ZYuSRcMQHCCde7cOYpItTZjDA8/lEvvecImGCZlb706NCt6jW9P4D5vZQjgsLOgSziTW5mFnKDhFTBQ6DyL4+TRWon7CxuzmNw7RcdR6h8Ew6tyVlnnAgcAnIM2Wu8mxt5BnqUj8O0WIIeCgxmpzB1xEMk3eDVx19Q4LhvUIKt520rMCu0lbaJH7KHMWu+aPNsDSj7Gba9IzojJz/RQQEyJU7inybUF/4eKnZlL7LZNYUK9UMk7XOr1wFaiTyBX1O9vt930/2vZMtMwD5R0bpQEBI30yHjrzzexTL1ioqmD7R/Xuvcwmc9PN3RikhRcut+ps4tbD07gYKTpwS+c0AQwU0FoN2ZuvabK2turJ5uOsllDRZd1Kjjc8Q1cbH1knr4mkTgtO/M5rHPTjZ35Qsv39+VZ/+1KiiazPSwH+D9sXkWfgGKWAsAioshhwy7qx0VlzywZBtG/EqMSGpqWydGDqirdYx6TpbZ/XxspwD9ciPw2v0Z4ZpusJujpRqyLcos4MqwWY6SOMViu3W9AFZjEkV7z0DBZvgLl7t/YHDRfXA7u30CHRFxJruV1PaIJmzTfbnyCOak+iwanuGg4iyviZi+6ji0EyTGjKeXtPFVFMiRzsvLAekna3KIVgWju+IZbQ6al0rV7ckMuR/hiXulwA4IdiU5hSksqnHIHbZZiogGGIQbmBxeUr2NVGUU8rMj6Q0Py5x9Hg9k6o7D+bAp5UAbs1QnxoDsF+Kx8PSlSzoeCK26ELHyWv9nfHfDC0WlAKa
 b6Chk0UC
 gE4g9ODsd0fCWa2WasA8GT+zyo4qn03v1PwLz+W6ogJA1cFBDdqxwmT/FImFibI+3yjrCpeE4dul1lFoe+VXPv3eV4y/iDQzyqDwoLWKGnY5Z390xag0DnagmIRBVDY7wsyqz8lcqd2iXxqQXHePpfH7wpUY0qnQRmio/BPNeAG+BtVuqPBgxEJGlNrBDCg7bZdO/jWP2chvgEFnCiAlN4MeKUT8xH5mooB/eNbigsz+/jaRBx247tbEUHfiWdSYNpBppFVCS/iqnSVFPnUt9w+G4j330XSm9ou5938cgOl8pGx3x+qUpFVUlQ18ape8ecO4APSPWhrrYdbkTNMXayLQAhaj2Azlm/bbrgcHZqSkD5lvOELqFiCQlLvTCeulCAk/MKFOm3APm/iUzNtxehDy6Om7WqorORBa0Khypn91MFqpwYseA7DVxXmfO0yr0MZ9m1uk1XXQ3brZRjpGZ/HZoqxuHbPv9nQJMALWYY71FT1rtic/gub4y1Gg2wv+ZaDCImDQLXW/6Azk=
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
index 5f71eccf3565c..628379c363d82 100644
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
2.55.0.508.g3f0d502094-goog



