Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D89C3CD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:24:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B201C6B00BC; Thu,  7 May 2026 16:23:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF7A86B00BD; Thu,  7 May 2026 16:23:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BF896B00BE; Thu,  7 May 2026 16:23:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8BD176B00BC
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:23:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4B516120639
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:13 +0000 (UTC)
X-FDA: 84741748266.27.3539895
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 440921A000C
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nz3uru72;
	spf=pass (imf19.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185391;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=guZjJdp+vzqo6wSU4K/ncfR1buwPEZ3I/SM7amEy7BI=;
	b=oc6m1WXZDJ/Sx0i3JsuyelW+W8ZpOTmjydYQXb3zKEfcYELMkXsBw/i492qBE1z49Lmtk3
	YXeD6pJ9pgp7UzrHM4+rfY7JpcsqGx+SEDqeUd3l4oZLsmvYYKB72K4KA0enEhSPjU+K9M
	iMNOYnCFjfoa3IPhUKyNcy5Op8ojO40=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185391; a=rsa-sha256;
	cv=none;
	b=c29x81ZNNAvm/YxqSsQLShfjLZsQdjfHoDibc4cYAxwJ4NpAo0tuQHXvjYGxsCVRpncDM0
	ah3wY93EQFUPpF5HEGWIXv19CVOb8/IwRehppmRWOht4bhIfX9U7AYPWWPmSzmWqeF9z8I
	DSKNnuDEvBQdMskmv197U7mgKhZvArg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nz3uru72;
	spf=pass (imf19.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 54D3C448CC;
	Thu,  7 May 2026 20:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1FB6FC4AF0E;
	Thu,  7 May 2026 20:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185373;
	bh=1iZUHvV1nAJj+S20+wkMJz59misyAkbJrByqYzbRY5s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Nz3uru72CSrBDALFFjKZ/1vxnaJ0hKszHHNhQaHaCOjJXC+nU4OBdLgfON4nfYFnL
	 XZN4w/T6e9Fga8vlP7SCEUU9MRg/TxGJC7CenPKZHjueJvXYLOQZ4sA07Yq/ENpws2
	 K55V98K5UTqSLJExIhi0PHlxwpnT+o/Ai6MWlx6KYvi7Up811YBAwCObz/RQvJGtuW
	 NJ4LXjQnJinlTSJAiukdL38SmvoP1GcYLlM0ZKTm8mbtG3SUa428wkKmEzx4syF1aw
	 gxohbFtG9TSqEhd5gRGp/deWQASB8w4841MeI30j478j9wH4J0eaHjXOyl7hG7peG+
	 TnJiffZwh1Eig==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D1ECCD37AD;
	Thu,  7 May 2026 20:22:53 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:57 -0700
Subject: [PATCH v6 38/43] KVM: selftests: Provide common function to set
 memory attributes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-38-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=2774;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=jmZfY46J7y2Leu9SRzNbI32lb9j/HWWUaawmFVaRNAQ=;
 b=3soo/y7LDycbDXw/5KVOyC4jjl8VC0kBHTb4LZv7r5Rfv+oQ9H6TWYLsjny4w59AA5NcFkEjZ
 DpEq28y2KykCJhatuGgutpq/MYg2mYLMdfciFk2Hlw3CazMdFMP1vMV
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 440921A000C
X-Rspam-User: 
X-Stat-Signature: 4ocjwyjk5iaogiyj19rrnxekxd7fkm9i
X-HE-Tag: 1778185391-986144
X-HE-Meta: U2FsdGVkX19JnR7nBiAZ6Y6XD3lviBkWrqUfEjZr+91hAOuXAk2gX+c4nmnxKowicESP+NeV5wLI4UeB7SnqM8IjI0yHvAKgAabGccA5nnm7YbOYSo0XGvosb+XSDXL2Wx7gRAhVI2s14FOWHwQ8N39rl1asmkl0l0XrO2YAF8OWKQJC3fSwe7+951g/34kKwyZ40VVjPM0YDaa7xytf3M3ELTRwwABQjB93ZNIVblF3C+CDYMra6UH6blrw5S2Ivb4DOy1xOKhZPG+bs8HLoj6/+QYj7/P6kliepFvW/JlLc8xQvhcGfnHsxFnulmAVGJVJAIhzGw0bCytxsmjwGDlYrbSMnMWdkx7Uk/IYjMBZQ0iVt+umBWEhXiGXL9fqknjfetFNLaknmZesh62s261kebMHZz7ojCSokyIMufxh6kYeqnGsZS94245ppJ2cvPqftYn3v4OQ7nXm5//Ac/+OOStxNZvsFruW+kiXmMN1DDPejjfYWcUeziip7EsfcMSe6eBDeJh/S6o1WslkA4/c8Mb/NAkewOAWcmX0iyEUJD/1HhrqOWPL7KMo5QThKk10nbim7c2BgpLh979J0BkSt2DgEktVao0pGETzdngRNP7FhlV8k4/mnweWOuj2A/mKQFtYAyzIhLiUQsrd4WCRSpR/AG4Ks3Z8TKRiQA1Jw/F7IVkIzfpoOn+25IwwT99QLR7TiJhI3hQyUCFLk9OA905ixVoHzOKa1vnx6294Op/HtMtcsN79aWWi0ou8WobijmZRmNRzAcjSR3SWTH5AuHvQiOxVRV2boSvb+8zdtZ4YAsZfpUn9B58pzHCiu1MMt+FNZjgbAjYNZMVwWfe1eP/ie8ZGANMtbhbZXM/kxxswYzYUKUPDVjPoiYs+B+d27msCVzxkaxB01+S8C0jHQJlxxmdqrF6oL10XftMgMApCqYyByvyzaKL6mGgsXncMgoKfqx0iTTd4enr
 gZSqzhVq
 QhWls3u3IYmXe7iq5+PO+3NwADHKDoogMb3UKhVr0AiDGiP9OgwliUAA27wd/NFQS+pFDNlXpcxxbj80uF53tU+jvzZKwr4va9HOm/Is0dbry7GUC55ex88DvlfPhMqpBPGEELr4/NjMoGIo2a6msNGUufgKRgcQ7yIQ8q4KNA288kqn2D+pmSKNysTyiKecZPUHC9JmjXtxbFrb2buL6/B2EUo2EzuWUE0ucRFkoqN9ad+ZB8r08baochUY6FU+tnpcbRUvZ/laE0/MgiiYw3tEBKtg8JKybI0b0ZFSv7q0/6GIb7ojouX2+5L0bFHXYtMxxLo4Sptoo8ztEgnAnmOgBUIvWSDHMvEzqlRiE6sSItBsD8ABLPCG6D54Q6JAtq7plczcXB4S+20/bHNXG1hp10Pt/jQP+FJas
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
index 4ad184ce3df68..dc70c6da63fa9 100644
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
 static inline int __gmem_set_memory_attributes(int fd, loff_t offset,
 					       size_t size, u64 attributes,
 					       loff_t *error_offset)
@@ -534,6 +522,40 @@ static inline void gmem_set_shared(int fd, loff_t offset, size_t size)
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
2.54.0.563.g4f69b47b94-goog



