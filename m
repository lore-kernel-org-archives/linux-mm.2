Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F24ACD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:19:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 604FC6B00C2; Fri, 22 May 2026 20:18:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 517A76B00C0; Fri, 22 May 2026 20:18:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 369C56B00C1; Fri, 22 May 2026 20:18:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1CCE96B00BF
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5702A0A4E
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:22 +0000 (UTC)
X-FDA: 84796772844.13.E439CDB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 00C13180003
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oXziKFIb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495501;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S8XkjFvmc2qh/xa0hU5U/K+bbea4k1FqCzp8wUdynso=;
	b=X6GFDQkzYLkB78sFAirn2HRvDRZ3LwRQ4X3/DB4O9RTqgHVVBIk1JZA2qxCofjWcQQeaTW
	tBgjVlLhAw6AkMMaWMFcDuZbkEzCF3WZNopLO4rS7ThuAYa0iEmT0b3DUqj6SlLqkG299m
	j1Xhc/T5ZCF89gfki9JMxMoWHg9d+08=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oXziKFIb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495501; a=rsa-sha256;
	cv=none;
	b=CnkFyy/EpWjjmBXRtZDNOlOMC9SL+H+Egu+ya4eLztiDENx1QKXxY5I6yUWObozmBlQRNH
	jWXsy1I8WSZsvBB1MZCZe/DNlSbB1Ck8bNcd9dE9keUN0gA79kods0ZVXuSJR09KLe6MRk
	d1FV2LdgEMVLEpUt/o8AlCJFyos0jJs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F56A44E26;
	Sat, 23 May 2026 00:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9B2ABC2BCB8;
	Sat, 23 May 2026 00:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495486;
	bh=ihuuOAajql3pIZuekHVnEZ6e6RknyFC+FqOsbbeQGLM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=oXziKFIbR/Opn/gdmzUCPL6mA4XO5Gy0PfyGT/PMNE7TtFVVfe4hIIgFTTBmntWSI
	 aoo4LOsvKnx3Lux5vyiVnWhVcV/GUIJkvPYqTxmX9+BmiwKE2/rgEANq6/XfFatY90
	 VOPlit80T8zh/sM8TbRTu0XMHhVv06VvLM+jvQS0YFa+AfQ4xOMwibq65sVDu4n0M2
	 UBN0tw/GJsYNuDPc8C8O2BFDsI9fNAd85xA5GZ3V8OOCAw71KFvKuDO+7STkcy3Z2k
	 QRcxeaOlS/HVUexhAQBsq9inLDio1dx5gXaRA7CE75FPByBrZBg9R8Nniuoj8/znPU
	 3WTi7OKNHT4KQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A314CD5BBF;
	Sat, 23 May 2026 00:18:06 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:18:19 -0700
Subject: [PATCH v7 37/42] KVM: selftests: Provide common function to set
 memory attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-37-2f0fae496530@google.com>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
In-Reply-To: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=2765;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=P/i9OiF2b5g5Q2hsxAIji7tf5p12/vG7B8qlTKdaF2Y=;
 b=ojLm0Fa4aVMz9nlHYaXyAQcTm/KMc2yKpOqcN37XwLAaV+jCH18FvoSe7wTOLK3cK4TNMVf+L
 ATiT6jIATf2B7PggYOioHimMlslytvU0+F5qIHueNsEUiiiktbYpebW
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 00C13180003
X-Stat-Signature: 9zobarn6sof9zfszo7yh9mq6wjwap9wk
X-Rspam-User: 
X-HE-Tag: 1779495500-31912
X-HE-Meta: U2FsdGVkX19Sq2IzfKo3oT6p5oWd5yiIODb8X3rUAt45e7urItOKxM/TEK84LDaQUY1W6Fs+cBgcE5u+I9VAOeE+d+z+GkYMVjqQYukxuGd5Z3szVAs+fXCbex+vXJJkHZBKqS2JgsKls1NNRL+On/hXmpwFmFKAOsotqMVDqMXe30YivQj47JnYzvLS+ZIvgysYxhS03xVem7imLE9fdV1i9ErwEJW1SYulpFUPr7Yx2Db7jDF2K3WXE0y8MCrKym0bNZoSu/BESMZ9jSItIMcbUpFsi/NkMgXIKjQWV7Duh/qgHAHZ/ML0bJz5C97SFZsPFe03ZQb5rqDjfwAlStIXVGZ70j/vU5USzTuU871mRQR0HxCBw7f6661oP43ljh2l+WhUparqJikf/sK2thDD4BkfDfO6OF+pCNsqJpOMTB8JaZAKcfCSKpt3oHPbZ/wj7i28DbvjbaEporFg3etx0lCKzA7YOQDIJBTfx5cFYPKsEXlcGwgmMwxj5066NsnqXvLYAAyNrJQ1dVX1ZOfRegOX4E3NN6YAf5fs7U+sf2zDAOiMidlbjCtUkkt+23srVnaDX5b+LN+6lA9/XISytoajXyrRaQq335MIyiUDSy26RDqjgzV25mWyJaj29vqtOzvR5oBninDErDnScw+t0vCt0O6vva3BIiLEiVPcSRy/Nsn3Uhz2hAqbGwqfh9xn91pW7jBsSa+mBm1vDmAZh5yy0hUGTMlwh4afoIOBziJEjhSaZ8Sw2txCdQ/OfmoWQnWkLWNYGZ9ddpouQ7p9uunIvjsgIM797IUX1RuhRgY3QU84kbYOi0sUxbqGECVjssn/OxhCXa9PHEW6NVaYeeH1x/AYF9g/95ySzSlyhEIRXb/01BSkd+mm/EicD0lTsK59YKMvva1cSfB2jxbKhZbocj9fT/dKocZIyUNbwPQy52UmUm0z82NEjE/fbKc1H2WqHVOBaxhsa2I
 OQuMPXvv
 ipnDgRIrEPpXPAuvASPRzq1ApxzC+XIlFxBP8qch+IlSROl6hGeWyUmH0CLw91QYnCWIb2U2XcDHTRc1pLqBkE/bW4p0NUYMv+a9IaM2FsP61fftss8TpSi2C01Bq59SXMtmdcplP64V5H0SAYSz58zj3qdbJWsEIvXc0a6k7Y6Vw3iQKVIEFNNsggB2IYtXGix+oZffnt5hs+zIyVZqm9l6aVTAu1bNQRRuCQpHpohvc3Z0k1hpFYodkba+jfxopHSCTqZwXFIzEv231y6oBFnGWxbcS13MeiD9cT1C3+kbBKssm4wdIYgSs1wv3gr9mqSMWlNTGX7Os34DpjeRMSw/qvIZrIKdPHJG242yjrutvR1AiD3h4n36TXQ==
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
index e9b4ae9596e05..a86418cdf5f4f 100644
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
2.54.0.794.g4f17f83d09-goog



