Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33CD710AB82B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:25:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7C2B6B00DD; Thu, 26 Mar 2026 18:25:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B54766B00DF; Thu, 26 Mar 2026 18:25:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6A0A6B00E0; Thu, 26 Mar 2026 18:25:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8C45E6B00DD
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6537113C2F2
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:45 +0000 (UTC)
X-FDA: 84589647450.26.4510B36
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7A80140014
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LJBKe4HT;
	spf=pass (imf11.hostedemail.com: domain of 3ZbLFaQsKCDYSUcWjdWqlfYYggYdW.Ugedafmp-eecnSUc.gjY@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3ZbLFaQsKCDYSUcWjdWqlfYYggYdW.Ugedafmp-eecnSUc.gjY@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NdTzJ2knx/A8nF/dOxU4yhfVKOq5sU9Aj61j8WPVqZE=;
	b=ifNMqd3JaE/VBDl9uf5rUp7G2rfmDmKK6Aq7uLeJTAGHLQ8eqGzZMeKjjbITQzKHYp1XHJ
	8do3AtkGQt8p5MVuE+DNr8u5hHv8lXNnuRilO1WfSKCBRZ4Hy+qB8eyLiqGpj5BNTrGwjj
	JbBEdPbAbW6AYiOuionk9UlZw4xyo+I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563943; a=rsa-sha256;
	cv=none;
	b=zaHVTN2TQ/A6T1YdMtxyxXs3N/ZhFhaS/FJVy6Rlxvrl30N0eQ5g77GVelHyhu2WxTN+EE
	uLZHLxjYfIbXenwSSfK/XGDfR/vCQhLH5x3qcf30pvySqtcqrYvhckme+nJX1y1JpH6zAT
	g6t80GFxlQb9d5ztXWSFLUMnKxz7090=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LJBKe4HT;
	spf=pass (imf11.hostedemail.com: domain of 3ZbLFaQsKCDYSUcWjdWqlfYYggYdW.Ugedafmp-eecnSUc.gjY@flex--ackerleytng.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3ZbLFaQsKCDYSUcWjdWqlfYYggYdW.Ugedafmp-eecnSUc.gjY@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2b0b0aae381so18137995ad.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563942; x=1775168742; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NdTzJ2knx/A8nF/dOxU4yhfVKOq5sU9Aj61j8WPVqZE=;
        b=LJBKe4HTQA5YuIF7qWvRHG96vtMzTu1DuQ0cK/yBbnb824hWp4iuzkcvEhFgs6XVx4
         efy3oA3W00j2V+FRVFVxR7ce9XzgDK3hELL+2m2F7Y03KxhfrAk28mdsqMy3otc3L49k
         Y5coKhE9s4KFY0uu55K+58HGtbRU259zp1joYqWqYynDayEOSqND6ZIzx0XOEK/MPZvK
         x/lN4zpdS0ttYBSKTUy14GPIjtsSJIoPzgBNnnlCzBzEAx1cvZ9Ysn943UafiSai9g0g
         9CRkjmZMVdQY8+HoxbDb1bRB1p3VMfTiqC7XRtWHkv2LLcPbBBPmUElIahjWS9ISVbyd
         6uOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563942; x=1775168742;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NdTzJ2knx/A8nF/dOxU4yhfVKOq5sU9Aj61j8WPVqZE=;
        b=Xenc0in/2CxRIHwKO63/B81IwKn2pHnKigkiY7pBGMCHF3z5CjF/4P0ZQSkIM2bj7K
         LopSsU/i6aa5MvgPBYq66g4+zK6XimTax48+so+5FTPggmxxa+rNNqrFihFliu2FMlq/
         rhrGmCk+1pUCRmNlfwcKlrubNyVIrumAAPbq7YkZrdRHypwgXEK/7KJR81gGcmxYgqXv
         IqDIDJwyI1XLIZka7LlNZwDeBlcpj0/bxvbHCz0HVWGHv/uFnwqCY7dFe8s/mCtKqeoW
         LbFIy5ZitcK5WRcl9UaD5tphyDQvvk1SRJiMAFKEPjXmtJpi2MaL6VUPBvvRBhRyk1ne
         +wrA==
X-Forwarded-Encrypted: i=1; AJvYcCXuR+E7R6XeV2NTrNSJAhvsjxdDF8i31B1bxCEP3RJUeddpn2q/0U9EKDtXPPZp/GcLYT6O3JFM9A==@kvack.org
X-Gm-Message-State: AOJu0YycEWdm8K3pxZifVXTCR3YXIUsfkTZSbQjWH4tdKrXnDdahTK0K
	pra8/O5II1poD1qycxbnJAZc28oS5eJd2+dmfjQ+DIEn8sHXLSuBUYTjOV5tAEEkwQLoK2r0V5h
	LehlVrWJ6OQ+CaXsLADKWxymIoQ==
X-Received: from pgmc18.prod.google.com ([2002:a63:1c52:0:b0:c62:b045:9c6])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:a613:b0:39b:8dcb:f36d with SMTP id adf61e73a8af0-39c87b62ed8mr216909637.35.1774563941902;
 Thu, 26 Mar 2026 15:25:41 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:47 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=6049;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=HTZEVC19RcC53M2zFJOXKx3E4yoW/HTjTM3xN8ow870=; b=uEc48GV8on+0fQ8uBTGhWcrb0PLgSO+WOxNKaWbY/+7Aqk0ReLt7gB+ydu3HEXGauVkuxE5ig
 nsML4IvRgkLAnNEduyZAUtxVKvwTGuIvP0C83uzA53a/ilyROx1iLj0
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-38-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 38/44] KVM: selftests: Provide common function to set
 memory attributes
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam12
X-Stat-Signature: 5ip3gk8ihzmjnpiqr598bc6ncgg93urw
X-Rspamd-Queue-Id: 7A80140014
X-Rspam-User: 
X-HE-Tag: 1774563943-598983
X-HE-Meta: U2FsdGVkX19Of0nP9LtCq1U375tEaiTBqsqUNwK6wmtAMiLAr7n2NawNufHP3xDx7R+JNd+WYDbkvCKGVAvgfzWPlvZ5XRvYQUxIBv4Aad3guXK+DSWkIA2ExAr+IyTSHZzvbU/er09RtjlmgYZEGwQkqszF+XZWrAKkNlEMdJgkZR7WI/jC+8suNQVwk7QIjcpcYqRA65+ePSG0ESUIsOf6wY8GaCBhUdIQiWNg8JJgfjp1oOpT24JX+7gFp4HMcjGjiqylV58+7PK4QUWQ0FVv7x/y/5RH6AY2rDApA4VFeTaiG5Oc+0NrH9eeLBJZc8EG7quEA5W+aR2/QvnQjr99JJFazaedy97ZCtcu9hNkg2PWKqAkdgpcUkFMS7/7NMqT37b2UmDuO0tXg6ssiL/lfVc0y0q89KIiT8Bc8iYY+Zz5zgWTznHu4O5hF2woG0Y2DBJua/e8QDTx62alTrXuwzPnSXB2n2CHuQUKt/JY3FPPF2LhDgEnfgfKydRU6RyEmRQ9I5jxGy1faDdW9IgG+Fh9LFqHjDSpQCBPZ1nvWrUKAtzItQnuCk/KB2hd8j6W53WEbMED/Rq6Cj3m/lUgwJhKMhq72nSzAF3GAquzK1srbc1ydTvs1U5BMuWMfnOv1f/rCoItrwVMbskiHliWOtGuUb49cvCemKIyJIlHRizinwfL0JOu8JoImWP61dLufCqbiUdQ6d3ygGedl/FJU88nRtULY41gU8gpbOwAMJ+rHw6/0v6MCkchiLufg4Crda8ehZ7qHGQ56eI8Vryn7HEmB//KJBI4l3LfNIyWC7euLSZ6e4YU/Zk2yiwcfIRts4Hy5iqTmvqjqSHDO3361/Xg410BRj5xpWJxvjokmm/FF/AkT/UJtuuumQptw8w7LXXgdlkfZaVrtvr/kzdlMrOM4gIC+HQmEJXM5dHlqMBWqbWO6k/ugA//QFE2nbBNrjOUeHtSz92iuxj
 XRgeZA/X
 fGGhIMqh5MojG7n/3da0kAeKL1qVe6wzwfs2FNwwYDV3tu2t0gx5EXyFcAxzQcYPe185J1c+MJE+I+1kaYXqsICai3y63RDwN3gxO0ZjeonEmNlPOnWRml609nBMZ+410yB5P+vHQ4eLmlW9xLFibvy6xPE5gGRSOlsZ6l8aojzltnWq69iFsmvQEb7bXyj1LOBlucumJGJ0U6uPszGpMEIlakvFa2GlMk0O+NyjtoccbpfGl6WGC0MySBHdYBeCYAiuLOOSkyIRvN6SXwFLJ7kbyzPjrzayFLFJLwklKdS6Sgi7JUgRwnLnXLSewb8SUxPfbX4+Hc+sa/daAx9ScnT0mqWvXGEIgpv3pdfsuQzzRjmUnqqynzC6KZWJN+xshoAqPaHY+3sqrFIPbJuZXBYgf4izhxMuf11t8m2Jqc5ks4Hy5g/r/VNFNKo2BpkNyju45pJCIbL0D+YdYA1NPISVGGp5nYW28Dx7s1O1BOAHWqCiC3p3B0QBiN2HUZ1B313XqDy95m+ha9TzmKcW+ArJ3r8asesR44IHvLK6Ks3ndU6Am1u1JHeLuukBw91UmpEsuk/fmg4vnrwpFvGKjrK22bk3EKZLXW8kWMYg21CivAHVD3YWr1AXJIyL1i8RXm1pwFS5lW5dQ31pMZ5TMgDkFG9uhgMvh+5dC4PC0GRmePDc=
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
function.

Update existing caller of vm_mem_set_private().

Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c     |  2 +-
 tools/testing/selftests/kvm/include/kvm_util.h     | 47 ++++++++++++++++------
 tools/testing/selftests/kvm/lib/x86/sev.c          |  2 +-
 .../testing/selftests/kvm/pre_fault_memory_test.c  |  2 +-
 .../selftests/kvm/x86/private_mem_kvm_exits_test.c |  4 +-
 5 files changed, 40 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 10b57fd4fa9ba..ff8c0c56399dd 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -506,7 +506,7 @@ static void test_guest_private_mem(void)
 		   fd, 0, 0);
 
 	virt_map(vm, gpa, gpa, npages);
-	vm_mem_set_private(vm, gpa, page_size);
+	vm_mem_set_private(vm, gpa, page_size, 0);
 
 	vcpu_args_set(vcpu, 1, gpa);
 	vcpu_run(vcpu);
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 3434f3df028b0..d975cc3047a2d 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -456,18 +456,6 @@ static inline void vm_set_memory_attributes(struct kvm_vm *vm, uint64_t gpa,
 	vm_ioctl(vm, KVM_SET_MEMORY_ATTRIBUTES2, &attr);
 }
 
-static inline void vm_mem_set_private(struct kvm_vm *vm, uint64_t gpa,
-				      uint64_t size)
-{
-	vm_set_memory_attributes(vm, gpa, size, KVM_MEMORY_ATTRIBUTE_PRIVATE);
-}
-
-static inline void vm_mem_set_shared(struct kvm_vm *vm, uint64_t gpa,
-				     uint64_t size)
-{
-	vm_set_memory_attributes(vm, gpa, size, 0);
-}
-
 static inline int __gmem_set_memory_attributes(int fd, loff_t offset,
 					       uint64_t size,
 					       uint64_t attributes,
@@ -536,6 +524,41 @@ static inline void gmem_set_shared(int fd, loff_t offset, uint64_t size, u64 fla
 	gmem_set_memory_attributes(fd, offset, size, 0, flags);
 }
 
+static inline void vm_mem_set_memory_attributes(struct kvm_vm *vm, uint64_t gpa,
+						uint64_t size, uint64_t attrs,
+						u64 flags)
+{
+	if (kvm_has_gmem_attributes) {
+		uint64_t end = gpa + size;
+		uint64_t addr, len;
+		off_t fd_offset;
+		int fd;
+
+		for (addr = gpa; addr < end; addr += len) {
+			fd = kvm_gpa_to_guest_memfd(vm, addr, &fd_offset, &len);
+			len = min(end - addr, len);
+
+			gmem_set_memory_attributes(fd, fd_offset, len, attrs, flags);
+		}
+	} else {
+		TEST_ASSERT(!flags, "Flags are not supported.");
+		vm_set_memory_attributes(vm, gpa, size, attrs);
+	}
+}
+
+static inline void vm_mem_set_private(struct kvm_vm *vm, uint64_t gpa,
+				      uint64_t size, u64 flags)
+{
+	vm_mem_set_memory_attributes(vm, gpa, size,
+				     KVM_MEMORY_ATTRIBUTE_PRIVATE, flags);
+}
+
+static inline void vm_mem_set_shared(struct kvm_vm *vm, uint64_t gpa,
+				     uint64_t size, u64 flags)
+{
+	vm_mem_set_memory_attributes(vm, gpa, size, 0, flags);
+}
+
 void vm_guest_mem_fallocate(struct kvm_vm *vm, uint64_t gpa, uint64_t size,
 			    bool punch_hole);
 
diff --git a/tools/testing/selftests/kvm/lib/x86/sev.c b/tools/testing/selftests/kvm/lib/x86/sev.c
index c3a9838f4806a..d3a7241e5fc13 100644
--- a/tools/testing/selftests/kvm/lib/x86/sev.c
+++ b/tools/testing/selftests/kvm/lib/x86/sev.c
@@ -33,7 +33,7 @@ static void encrypt_region(struct kvm_vm *vm, struct userspace_mem_region *regio
 		const uint64_t offset = (i - lowest_page_in_region) * vm->page_size;
 
 		if (private)
-			vm_mem_set_private(vm, gpa_base + offset, size);
+			vm_mem_set_private(vm, gpa_base + offset, size, 0);
 
 		if (is_sev_snp_vm(vm))
 			snp_launch_update_data(vm, gpa_base + offset,
diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/testing/selftests/kvm/pre_fault_memory_test.c
index 93e603d91311c..3b2c4179d42ee 100644
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c
@@ -188,7 +188,7 @@ static void __test_pre_fault_memory(unsigned long vm_type, bool private)
 	virt_map(vm, gva, gpa, TEST_NPAGES);
 
 	if (private)
-		vm_mem_set_private(vm, gpa, TEST_SIZE);
+		vm_mem_set_private(vm, gpa, TEST_SIZE, 0);
 
 	pre_fault_memory(vcpu, gpa, 0, SZ_2M, 0, private);
 	pre_fault_memory(vcpu, gpa, SZ_2M, PAGE_SIZE * 2, PAGE_SIZE, private);
diff --git a/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c b/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
index 13e72fcec8dd2..cbcb5d6d04436 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_kvm_exits_test.c
@@ -63,7 +63,7 @@ static void test_private_access_memslot_deleted(void)
 	virt_map(vm, EXITS_TEST_GVA, EXITS_TEST_GPA, EXITS_TEST_NPAGES);
 
 	/* Request to access page privately */
-	vm_mem_set_private(vm, EXITS_TEST_GPA, EXITS_TEST_SIZE);
+	vm_mem_set_private(vm, EXITS_TEST_GPA, EXITS_TEST_SIZE, 0);
 
 	pthread_create(&vm_thread, NULL,
 		       (void *(*)(void *))run_vcpu_get_exit_reason,
@@ -99,7 +99,7 @@ static void test_private_access_memslot_not_private(void)
 	virt_map(vm, EXITS_TEST_GVA, EXITS_TEST_GPA, EXITS_TEST_NPAGES);
 
 	/* Request to access page privately */
-	vm_mem_set_private(vm, EXITS_TEST_GPA, EXITS_TEST_SIZE);
+	vm_mem_set_private(vm, EXITS_TEST_GPA, EXITS_TEST_SIZE, 0);
 
 	exit_reason = run_vcpu_get_exit_reason(vcpu);
 

-- 
2.53.0.1018.g2bb0e51243-goog


