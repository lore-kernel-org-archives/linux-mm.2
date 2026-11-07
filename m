Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A273606A808
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I7vOcxIF
Received: by kanga.kvack.org (Postfix)
	id BCC1E6B0606; Fri,  6 Nov 2026 19:37:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7C3A6B060A; Fri,  6 Nov 2026 19:37:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A638A6B0607; Fri,  6 Nov 2026 19:37:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7F1C46B0605
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:24 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 22A85A0214
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:24 +0000 (UTC)
X-FDA: 85406459208.03.CB05B83
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0895940005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I7vOcxIF;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011842;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9SeL/ZiEo1JNFa6uJldLRoyMRqFFh5GFWRQajcrSB+U=;
	b=QcP5eeIBDqUMFostCdK8aNAMYNEiv40zsBBuBLzdj8l9PeDk3vLzKednIra81weuy32nf0
	qZq08IlyN5qNFIf/qVrXuZcBbPoC5GHN3f0MC7QSGgB89qVDEzjfeQttdlIvlph2nOJS8k
	rOBsQJ5Mt3e/JtkAiZPm0Ej9tkM4Xig=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011842;
	b=2f4MwvRFufgtOma0QnrXdOE81Pnh4Gv7KHrArXBknisazkYeYnw7SJDemSqRy5jH938vr7
	lHW2toC2z/HZX5dGd1zainecIg0OCSc+RWvrOMRugWaeLp/Xuce9O4jdGHF5mONmOwP+ae
	EiXExySdbrVv7ji8ExiVytmyA7G++EI=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I7vOcxIF;
	spf=pass (imf17.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AC36D4406A;
	Sat,  7 Nov 2026 00:37:21 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011841;
	b=xuBuVHOw3B27Mps1cafEnHg4JhdM7f7FaAW+UnilnXm+6hfIK/ifZm3JtXWFs6zika5Y
	 GhT436agRRAKtmPSzKi/llAInBvuXOwtdrE/6vyW2bYOAg6nRGLBeNvLNWjvZW5qDmfVo
	 ZWHmjXEPs30bbyi7VlYT01Xp5SPxATrnfn8peHTPDeaZ5XmJBiDcBo3i8wP35lT7k5s+v
	 JnN5JfqfyC8VoUAfcMlxcRToRUGfD0+BPwyOw+hpnLSOFw4wwlrUkxqHGzJEQpcMqd+ye
	 bA+jb25y5hHuHCxl7LWFmKLwNiygZuSumUeDPqm642P4FCSwv/6D7IO4LzVhEfVktMw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011841;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=9SeL/ZiEo1JNFa6uJldLRoyMRqFFh5GFWRQajcrSB+U=;
	b=LCWgrOyVZbhP/NpZ9bbl8BAs7oF/by8cg0CcoaI1IWSVhMHrBG8R/RBUNraffgovGoI/
	 8rUQNj4uu05ympegFr8C6mzBwxGjd+9E7KySCoeSVNp2t7W0tNizFG1n1MTugas+ZnTDp
	 XRjDW+G8VxTKWvCm12HMgO2B611ug9yxrkeNCBiCAIXMJGFynrHesf9BAd3WOEZcuw3F4
	 ix2UdWkJdzmGfQm+mlMz6LH9mg8S/mfIIpUUL+QnjGTmRVRdEN99rd/ldtk5q2Q6qNxzI
	 RBHtEZf6pvh2H/SsFEvFNwcGuBwdim/Woi97Ho97nWEyYa9bDVs1eeS8y0/kOqh7EAA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 899E51F008AB;
	Sat,  7 Nov 2026 00:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011841;
	bh=9SeL/ZiEo1JNFa6uJldLRoyMRqFFh5GFWRQajcrSB+U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=I7vOcxIFHL5E6ZIo+hKvEMkq5XPe2+sRl/+U24PXDo2j+rgwUgOzjpL6J0ErFf/dZ
	 fNZQGfmB/IAwMXQvYiT2cypxB1fcTE4HKmSWUiyTb768HNOa0TmSo6Bkpz08zMc8T3
	 u/w4Ep7pdORe+5Mb1+imXkyyaQDOyM8zMV7Hico5FlepNd9hQbnQrCmiA3/Ey3husJ
	 A+DOv2XKgzvE2nMmAtF+lnzU9n2Q78AHxkWAotnfcNYsUiulANXVX1U7qCpOfUaT6+
	 006kToY9nUAcEJjIJYuiQRvrmi8jzBWtZ2/phxj0O+f6MsusemwsjMioF4t1E3/FiJ
	 AcYORGjCahE5g==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 8D01F47A5C;
	Sat,  7 Nov 2026 00:36:58 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:59 -0800
Subject: [PATCH RFC v3 85/88] KVM: selftests: Verify shared and private
 mmap access for VFIO BARs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-85-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=5917;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=yUySByGqxzqT+Oxfxi3dJk8aiTpxLOKEtbuq/Vzm03I=;
 b=VqBOv4KmhHTpFhYWjDlROlLzM9MRdZp2uwmZyBVP69w5BMEFrucxqf7UGKtcrD4c4NU99K12n
 wWDeO9xZmwvCEAtS9rYITeg/7NOxvTnZdLrUEPPNtklmStGGeLHfVew
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uwdah5twswqo8hxp4d5iikxecnzmxd4y
X-Rspamd-Queue-Id: 0895940005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794011841-984902
X-HE-Meta: U2FsdGVkX19trc+vuA/Nz/pJJQHoOROHDVjdraYfyW5N+L8YvCZDfEgChTIGkJv1U7kmNZaruUG6KJqfUe19AHs2KtaGNLoIii2mK5EMta/beNg/2MXf9plYL0tF+7dNg8p7mPewOMLl2gCjnMzX1ktCC6mriG10wylZ+YR7KS4FJMR4rqNz6/f7+6YZhHlnZLj7gwl8+RaJ3BgGf+FOyZOAuXwPuQF4XD9OV2xQ2O1AAu62YhrmKpVlJvXn4NM/P3/BKK8p+pM/Q7BLhf6i+Lkvh1aku007N0K/VJCcJYDFe0UK6XlTTP3YhXh3T3jrBmmCNXPEyo4DkZjg8iFX+5p2OfDcmxsaetmrx9LibqHqmiAXaFNCgvjF8Lzrafcr7x/UjbTiV4wE/60+7JyvFcNJ4/N9RnjKChc4bUlYMb+wCJJKBfRRKj6SqdIFh/MuHx3JpwppWG7NnG6srHD/nPqu8fm6LR+hC97nYoH2KRDJLkJF/DEi/kFVwc5dfSC0rbKU83cxrCVaEWCGpFpPwq8zrRtQxZ3rCH058sL9UyzcHbmCFQyXCaseK0fcNCGCrGhbKTXmKoqKsy5isDiLfsCaQ+cc+n44l3aS6atVTYyIo+WDsDNnY5YwBJxwep4s3rYzIRzSps+zz56XfmKzQnjFqM4fQRt5LbBdIzKxn3pN7MHfEcLuphNgIl5Bi1ysMygkLnsb4RonPFN+N3b0MSDN+4vF4VUVp8TwLUZdJXMmhHxhW+qEPeGIIHFUoMkAtzRb3sCiX4yETbY0Cx4kad71egxf9iN1v4+z0FEyHPnPZE763Pdw18lVB9UB0Xfbd3c9wCtyz235Op21twm9kvAPobIiFBHZDCxfZHwrFyd34CLvo1mrBaFjGcFeP90zO1H24BNH3UdzCrsNQpO1L97HtuFy0/t3zntyDdyjaA7Onoj7G8NveSMUc+AQiJ9EQJV/eKOPbjzMLDxli/m
 BIxPfDj2
 QKjglx3j3gdxOBZ8LwYgvGYYTpC3kX8VfkPkGo9WaobA1Hm5FMkxqCrjdvtdIsxf1y/OXcoCMXxT7HSMjqkwsarb+wdUAsl0ztH4cGE+cTSkIr9zydkTp+wShFBulyYA6XOZLj3ZdJz/S3ok58qCZZtguOUqbhabMA2GSBsKlM6VmidprPzJSF2TYh9reiRMxhFnEfWBRID0jUW2g/ycBPDGo8v2X1Cql+33wblKKAV1pF0XB0fGeLw1e9uJ/7VtG4VDAoBpxGNTIEuMhIFCbfBf7aEWTPTI7+sT2BrzDuKiG7avpcvpYuEF27WaJM8tN8RmiWkfb8RB77ECXQoEDCq6hBWYNXt3qhoZRh7W87FnDnigCUGXPK5NmL0mt1wf2eAApENXPhKWn+3ErgSE/U0eK+2dl4wKPbTcqcCrazYXaOQ69+8zJeR4rhxPOsQDcmDDfgVVofAGdz5T6046TnMNGkGPIgnaZ/ASGxHZ7aaRoLUTsnsgVccc0QJBOk9LUkL5llV1K5OORhhrz3pHoMh/rE6Nq4az9YtCddkaCsI/NlobSPR/w0LC5bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Add a subtest to verify read and write access to VFIO device BAR memory
mmap-ed via guest_memfd across shared and private states from both host
and guest perspectives.

Map an operational device BAR (BAR0) through guest_memfd and configure
it into a KVM memslot for a software-protected VM.

In shared state, verify that host userspace reads the device status
register and performs read-write verification on the scratch receive
address low register (RAL0). Add and initialize the guest vCPU with
a guest loop synchronized via GUEST_SYNC to perform read and write
operations over the BAR GPA and confirm that changes made by the guest
are visible to the host.

Convert the BAR memory to private. Verify that host userspace reads and
writes to the mmap-ed region are blocked and trigger SIGBUS, as
unmediated host access to private memory is disallowed. Verify that the
guest vCPU continues to have full read and write access to the private
BAR registers without exiting.

Convert the BAR memory back to shared. Verify that host userspace
access is restored, that host reads observe updates made by the guest
while private, and that guest operations continue normally.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/guest_memfd_vfio_test.c      | 130 +++++++++++++++++++++
 1 file changed, 130 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
index 18fab1a39041e..a520cf45fccb8 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
@@ -814,4 +814,134 @@ TEST_F(guest_memfd_vfio, conversions)
 	ASSERT_EQ(0, ret);
 }
 
+static uint32_t guest_write_val;
+
+static void guest_rw_test_code(uint64_t bar_gpa)
+{
+	uint32_t *ral0 = (uint32_t *)(bar_gpa + E1000_RAL0);
+	uint32_t *status = (uint32_t *)(bar_gpa + E1000_STATUS);
+	uint32_t val;
+
+	for (;;) {
+		uint32_t write_val = READ_ONCE(guest_write_val);
+
+		/* Read read-only device STATUS register */
+		val = READ_ONCE(*status);
+		GUEST_ASSERT(val != 0xFFFFFFFF);
+
+		/* Write and read-back read-write RAL0 register */
+		WRITE_ONCE(*ral0, write_val);
+		val = READ_ONCE(*ral0);
+		GUEST_ASSERT_EQ(val, write_val);
+
+		GUEST_SYNC(0);
+	}
+}
+
+TEST_F(guest_memfd_vfio, mmap_shared_private_rw)
+{
+	struct vfio_region_info bar0_info = {};
+	uint64_t bar_gpa = 0xc0000000;
+	struct kvm_vcpu *vcpu;
+	void *bar0_mmap;
+	uint32_t *h_ral0;
+	uint32_t *h_status;
+	uint32_t val;
+	int ret;
+
+	if (!variant->use_gmem)
+		SKIP(return, "Shared and private attribute rw test only applies to guest_memfd");
+
+	vfio_pci_enable_memory_and_bus_master(_metadata, self->vfio_fd);
+
+	bar0_info.argsz = sizeof(bar0_info);
+	bar0_info.index = VFIO_PCI_BAR0_REGION_INDEX;
+	ret = ioctl(self->vfio_fd, VFIO_DEVICE_GET_REGION_INFO, &bar0_info);
+	ASSERT_EQ(0, ret);
+	ASSERT_TRUE(bar0_info.flags & VFIO_REGION_INFO_FLAG_MMAP);
+
+	/* mmap the VFIO BAR through guest_memfd descriptor */
+	bar0_mmap = mmap(NULL, bar0_info.size, PROT_READ | PROT_WRITE,
+			 MAP_SHARED, self->bar_fd, bar0_info.offset);
+	ASSERT_NE(MAP_FAILED, bar0_mmap);
+
+	h_status = (uint32_t *)((uintptr_t)bar0_mmap + E1000_STATUS);
+	h_ral0 = (uint32_t *)((uintptr_t)bar0_mmap + E1000_RAL0);
+
+	/* Configure KVM guest memslot backed by guest_memfd */
+	vcpu = vm_vcpu_add(self->vm, 0, guest_rw_test_code);
+	vm_set_user_memory_region2(self->vm, 1, KVM_MEM_GUEST_MEMFD,
+				   bar_gpa, bar0_info.size, bar0_mmap,
+				   self->gmem_fd, bar0_info.offset);
+	virt_map(self->vm, bar_gpa, bar_gpa, bar0_info.size >> self->vm->page_shift);
+
+	/*
+	 * Phase 1: Shared memory access from Host and Guest.
+	 * Initially, the entire guest_memfd resource is shared.
+	 */
+	/* Host read from STATUS and write/read-back to RAL0 */
+	val = READ_ONCE(*h_status);
+	ASSERT_NE(0xFFFFFFFF, val);
+	WRITE_ONCE(*h_ral0, 0x11223344);
+	val = READ_ONCE(*h_ral0);
+	ASSERT_EQ(0x11223344, val);
+
+	/* Guest read/write to shared BAR memory */
+	vcpu_args_set(vcpu, 1, bar_gpa);
+	guest_write_val = 0xaabbccdd;
+	sync_global_to_guest(self->vm, guest_write_val);
+	vcpu_run(vcpu);
+	ASSERT_EQ(UCALL_SYNC, get_ucall(vcpu, NULL));
+
+	/* Verify host sees the value written by guest in shared mode */
+	val = READ_ONCE(*h_ral0);
+	ASSERT_EQ(0xaabbccdd, val);
+
+	/*
+	 * Phase 2: Convert BAR0 memory to Private.
+	 */
+	gmem_set_private(self->gmem_fd, bar0_info.offset, bar0_info.size);
+
+	/*
+	 * Host accesses to private guest_memfd memory must fail with SIGBUS.
+	 */
+	TEST_EXPECT_SIGBUS((void)READ_ONCE(*h_status));
+	TEST_EXPECT_SIGBUS(WRITE_ONCE(*h_ral0, 0x12345678));
+
+	/*
+	 * Guest read and write access to private BAR memory must succeed.
+	 */
+	guest_write_val = 0x55667788;
+	sync_global_to_guest(self->vm, guest_write_val);
+	vcpu_run(vcpu);
+	ASSERT_EQ(UCALL_SYNC, get_ucall(vcpu, NULL));
+
+	/*
+	 * Phase 3: Convert BAR0 memory back to Shared.
+	 */
+	gmem_set_shared(self->gmem_fd, bar0_info.offset, bar0_info.size);
+
+	/* Host read/write access must now succeed again */
+	val = READ_ONCE(*h_status);
+	ASSERT_NE(0xFFFFFFFF, val);
+	/* Host sees the value written by the guest while private */
+	val = READ_ONCE(*h_ral0);
+	ASSERT_EQ(0x55667788, val);
+
+	WRITE_ONCE(*h_ral0, 0x99aabbcc);
+	val = READ_ONCE(*h_ral0);
+	ASSERT_EQ(0x99aabbcc, val);
+
+	/* Guest read/write access continues to succeed in shared mode */
+	guest_write_val = 0xdeedbeef;
+	sync_global_to_guest(self->vm, guest_write_val);
+	vcpu_run(vcpu);
+	ASSERT_EQ(UCALL_SYNC, get_ucall(vcpu, NULL));
+
+	val = READ_ONCE(*h_ral0);
+	ASSERT_EQ(0xdeedbeef, val);
+
+	ASSERT_EQ(0, munmap(bar0_mmap, bar0_info.size));
+}
+
 TEST_HARNESS_MAIN

-- 
2.56.0.455.g6c5a503b38-goog



