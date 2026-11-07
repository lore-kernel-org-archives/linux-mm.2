Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECC70606A82E
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dvs8XSJw
Received: by kanga.kvack.org (Postfix)
	id A45D96B05F6; Fri,  6 Nov 2026 19:37:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 934056B05FA; Fri,  6 Nov 2026 19:37:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84E486B05F9; Fri,  6 Nov 2026 19:37:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 61C276B05F7
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:21 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0C9901401B4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:21 +0000 (UTC)
X-FDA: 85406459082.18.E596BAC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 03E8440003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dvs8XSJw;
	spf=pass (imf11.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011839;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1yhjNyj3/BoIPNrr5QaqSNYhh97TgzkTIFZS4O4kbNc=;
	b=Ry0ccjRB1hqu/cGOc9a8lrwD5C9ATzVBMJiLKpJlZJSKYQBbz0j4OhOdkJCBV0JHs8g/3R
	vBy3eGUVX5f51gLWOVVdisbCUIWgTrtuYaERFp3Zv5cNUC7xVsN9rbrLOC4A9AFHAp6zGH
	2YKQYO4yBX6fZNyM1+W/tXvFNzm65AY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011839;
	b=XUirz91oum/MiKc19DklDAMR8/D3kZ8vTfbOpZ08n8wBXcy0INcy2eQL92MAxMCVlIgbGU
	O0ywCQAKpQ7+Ta3hCKtJFKRUbzmIBvSYhj7MnjYlHkvfbPmGKra0bydf+3/F8DlugbO4Em
	Pm39PXDs6hXpmgsBcByfeLvrE5RhVuM=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dvs8XSJw;
	spf=pass (imf11.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C99344406A;
	Sat,  7 Nov 2026 00:37:18 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011838;
	b=yKGwQwrAsSYI/ZlGRVJyCuhGtUX6HUHnMCPB9BLXj8PK9rOS3E/rlfsM3+V7sqGpxhjI
	 6bQVJ4CZauffBHlEw5V/PPIa9dC2M4wonIbvnTcaqCBo50p8/0qQnghDwYQM+hSqjBlQ7
	 Yge3M5ynSHROi6wFzUTv/x9BcwPctOJiK2Zr+OdWRLTEsmwlKsMtY5evD5bH8wB5w02zI
	 KA4Gi7EqU68oMZxD8ZIBp7I3hTqcigD9TWQZYkBFf5VkOwUI8l1M77ZaC0v7X7wfz8OZC
	 t2QehGof9In6zSrMJvCLdqkplYquGQNUHFiBx4+ur4xLPtxqfsmJnrXGDXdBsqCAnSQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011838;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=1yhjNyj3/BoIPNrr5QaqSNYhh97TgzkTIFZS4O4kbNc=;
	b=O4+/CAhbbB80Dij8DyEhlQH8XdFo00AsW3sMJWo7lE59sHAC5f+Sy7Qe53gcjslURkCu
	 uN6wp1F6t5DIo96qPRNSYTsPZz79it8ax5syqOsFVo99G3TU+/JMgUMmx7EWC0+st99x/
	 Pk/Gi/lSAK8q+Ls/aRo8ngdX8dgt2vPOw/KOJYOkS9+a+SvTpu8z4H1iz19yMPPQO4bWP
	 zVQfXnE4yiNJYU/QofLt6FfoskRXiCxm2nuJQ19962v4+jKu/LDvpGbiSO4+42q6MR8XP
	 kFnUxAS3MRdy29yWSlTvK7W9rV9b7G5/Pm32M05F5salWOmOKAGr70nibdWx8AMx6ew==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id AE5451F00923;
	Sat,  7 Nov 2026 00:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011838;
	bh=1yhjNyj3/BoIPNrr5QaqSNYhh97TgzkTIFZS4O4kbNc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Dvs8XSJw1uvRquFNJg74CFQsSO0MNECXR9zkyDFNOjKu+EwjRlJTknGja3BwpRTs6
	 AntXPiQswJQ0Wa4132XPYDJXWcTojnzo345j3WO2TbomBBxtP46V6SVx2OGbFJj96I
	 CnGkpmjxegBYEY8aBfsrZeFjIEd7zToos5aXL4kJk2VUPdfGvdkyfJOMTtTDpbER+P
	 MQb8jrhSI+E2O0pOBNuLYD+muEBQL2xj6ZQVWmD3rxWBNC+0PNUnqqH/uL208YQePO
	 hrgNQlYZsgOnsYnwqtpz9RnwWRLZxoctCZFTvfFyPAGedW3GaBziNMuOG45RhjYxKq
	 fr8q8vWQDFvag==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 52B8A47A4E;
	Sat,  7 Nov 2026 00:36:58 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:55 -0800
Subject: [PATCH RFC v3 81/88] KVM: selftests: Verify guest mapping for VFIO
 BAR
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-81-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
In-Reply-To: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
To: Alexey Kardashevskiy <aik@amd.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jianxiong Gao <jxgao@google.com>, 
 John Starks <John.Starks@microsoft.com>, 
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Vishal Annapurve <vannapurve@google.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=3180;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=m4gF/NigbTTRmt1klBzGGAJYev1gT2d44wz8V7VRpDo=;
 b=zdGRZlDZLizTZQ1sf9kanhtrpiiPGavV3vK3pt5pgWOiRuUUNwCJkOqlBk0Zqm0r0efwGYG8O
 6Zwph+ETe6BAHoQR7qCnY3ys92kB4Rzn66P5rjxM8p+6owCgf2vlFB7
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6tg8af8e4ekobs4piefwq3xx3e7g8ket
X-Rspamd-Queue-Id: 03E8440003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794011838-753315
X-HE-Meta: U2FsdGVkX1+rJCbeeEIfwsHplUapobiZA3RFZdUIArMPfUiXs24SKnWouvxvBcv+PP6fK5P0ziG13Lq5EyiwAepCNA6XJlbiH81KpKgJcJ6yDqgTJqNZh2XE4vUHeKISTbUJ/0pwT1SHkUPS4QHF+sF4x90mE2W0gemifBrMQdG/oWlNof9TYbnhSI0TYIVuKnZ4lgg7ISLduNg8boGDlREly3vdsFnRzERouW/geACIb3Rmq9ccYCOsu+zCKVrF0BYHZh3b9F/tZdVzm7Kf3dWZpcrW2IB3VxuxL6UdMyQGcBN5jUnIT3nyKatmuh92DYSxiVWLe/JAqrwe53HZWfEb04lLreSXTYIxbbXJu6Ze0rBA2qi0pvZcoHLMZf7sCAZ6exis1fla/fIO3VE4NJFDbOPoe0Wlvd2EvbuAt6zmnmXWKDaP8Xb7mshlgKtby9xR0yjp2xm/mSJBN9qGTw/GSQFnkMm5O2+/2rZSyOqfSnjJFW9+RRcpCmLJK7fPXXpS8XchcjQC2N0INhRWSQJtPQDdi4JRyg4mRz3uNOZ9ciLWMCEy9ujlgTZRyv8N4xgBYI4CQ7gGu+/5C7bDJWiPj8GlpgV5jHxOO8JDtFvuVvY5B8QjYkINAvXYpJ06G/nwpIFNfuPirjxlRYQNSe1xOr4V167/2G3LzCjTdid+yq6vbI9uB0F6Jp18SiTdWzG3IZIre3/TjJ/AGkXxk91LZdgjx8naUwEv0J5sko0MNFX/CedC7HPC7ljJTTnIA+qj8UfKLc9ohqbzvdn1mwh3PgUqmRLi+vbb8JwUagzOezTvj+kOkTYi/r6VktpTeAxJWb14qAxikFnqNTomA3xCfxyKmVs+jodIDAQ8rMqoiLU41clVcYZmBY323NsVedqz5FYrN4TwaH6hY3Xpq7zNM4NBwV/t4iu7x1OCwfay+SPwhdsoX9/jT+CgOeXm3ydtdST0GutZcKbKspD
 tSu/8K5H
 U0rjvwFNfXIJpAK72FV8Xuz6wXg/jsQfnpjzmHbdr/GnDhPRkfNzdzUrZ1HWvKV04daeGoYU0PdVOVO0k/8ivI/vI5dimynGvikRiAGwXiatplqMcm7tSHjlxjlfmaX/9nJcfOuLMpvCmYUmlR+mUgTGrrq3vd9SdTmhq0a5r56KEmHvhLske+YTmn08o6TM4ZdTHIZA1dy++xsKVCEQNAq6qu135OQvQ9plP6waLX+bMdZ+sPVpx8QHMyYqy17Ve5jLBTEYgOjB4cf4iwkZ566OqeRqdDuRkdBNzgo3+LMsAGD3FLKIPF8GYHom9YUlGb9reBMOHMgx4P1tgobhXNwU0HJrkDAkWjUygYluq8ZHczz2Aq7ajWJuUVTN2seaUm/6dT/Y7XAX8RtJbesEF1w4gd/hYYQJCCF4zC+Ni4oUykuUqGsQo9RPPDhUwn+0hn6jgExgn6Dh3mcZj2jg+8ukh8UulTfY2LVUUHI5CO1DLg9gc6rQnVS3a8/M/PcQ/K/FOsVGL586P137WPGHptPZypQATwhj6sJTURb9jhEjPdeuEYwKqdJ35EQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Add a test verifying guest execution and stage-2 mapping over a VFIO
device BAR.

Enable PCI memory space decoding on the bound device to allow the fault
handler to insert the PFN into host userspace page tables. Configure the
mapped memory region into a KVM memslot and execute a guest vCPU accessing
the BAR through its page tables.

Verify that the guest executes successfully without memory faults, read
the device status register directly via the guest virtual address, and
verify that the leaf page table entry for the BAR GPA is present.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/guest_memfd_vfio_test.c      | 57 ++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
index 79a0001ca1733..0339794fb6dd3 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
@@ -22,6 +22,7 @@
 
 #include "kselftest_harness.h"
 #include "kvm_util.h"
+#include "processor.h"
 
 #define PCI_VENDOR_ID_INTEL 0x8086
 #define PCI_DEVICE_ID_INTEL_82576 0x10C9
@@ -594,4 +595,60 @@ TEST_F(guest_memfd_vfio, host_vma_flags)
 	ASSERT_EQ(0, munmap(bar0_mmap, bar0_info.size));
 }
 
+static void guest_memslot_cacheability_code(uint64_t bar_gpa)
+{
+	uint32_t *reg = (uint32_t *)(bar_gpa + E1000_STATUS);
+	uint32_t val;
+
+	val = READ_ONCE(*reg);
+	GUEST_ASSERT(val != 0xFFFFFFFF);
+
+	GUEST_DONE();
+}
+
+TEST_F(guest_memfd_vfio, guest_mapping)
+{
+	struct vfio_region_info bar0_info = {};
+	uint64_t bar_gpa = 0xc0000000;
+	struct kvm_vcpu *vcpu;
+	void *bar0_mmap;
+	uint64_t *pte;
+	int ret;
+
+	vfio_pci_enable_memory_and_bus_master(_metadata, self->vfio_fd);
+
+	bar0_info.argsz = sizeof(bar0_info);
+	bar0_info.index = VFIO_PCI_BAR0_REGION_INDEX;
+	ret = ioctl(self->vfio_fd, VFIO_DEVICE_GET_REGION_INFO, &bar0_info);
+	ASSERT_EQ(0, ret);
+	ASSERT_TRUE(bar0_info.flags & VFIO_REGION_INFO_FLAG_MMAP);
+
+	/* mmap the VFIO BAR directly into host userspace for memslot config */
+	bar0_mmap = mmap(NULL, bar0_info.size, PROT_READ | PROT_WRITE,
+			 MAP_SHARED, self->bar_fd, bar0_info.offset);
+	ASSERT_NE(MAP_FAILED, bar0_mmap);
+
+	vcpu = vm_vcpu_add(self->vm, 0, guest_memslot_cacheability_code);
+	if (variant->use_gmem)
+		vm_set_user_memory_region2(self->vm, 1, KVM_MEM_GUEST_MEMFD,
+					   bar_gpa, bar0_info.size, bar0_mmap,
+					   self->gmem_fd, bar0_info.offset);
+	else
+		vm_set_user_memory_region(self->vm, 1, 0, bar_gpa,
+					  bar0_info.size, bar0_mmap);
+
+	virt_map(self->vm, bar_gpa, bar_gpa, bar0_info.size >> self->vm->page_shift);
+
+	/* Run guest to fault in the page via stage 2, then verify S2 PTE */
+	vcpu_args_set(vcpu, 1, bar_gpa);
+	vcpu_run(vcpu);
+	ASSERT_EQ(UCALL_DONE, get_ucall(vcpu, NULL));
+
+	pte = vm_get_pte(self->vm, bar_gpa);
+	ASSERT_NE(NULL, pte);
+	ASSERT_TRUE(is_present_pte(&self->vm->mmu, pte));
+
+	ASSERT_EQ(0, munmap(bar0_mmap, bar0_info.size));
+}
+
 TEST_HARNESS_MAIN

-- 
2.56.0.455.g6c5a503b38-goog



