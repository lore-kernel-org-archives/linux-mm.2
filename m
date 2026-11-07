Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A677606A82F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GVWhU+w4
Received: by kanga.kvack.org (Postfix)
	id 4C8926B05FE; Fri,  6 Nov 2026 19:37:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4500B6B0603; Fri,  6 Nov 2026 19:37:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 340196B0601; Fri,  6 Nov 2026 19:37:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C33F6B05FF
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:23 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A36C8160259
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:22 +0000 (UTC)
X-FDA: 85406459124.04.B383119
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 98F5E100009
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GVWhU+w4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011840;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rynyKDSc0zUIf+ovCUTrOZiWmRXp4NT2kPlsY2Zv9nI=;
	b=CkD+mHPjuJ23dekpRyag285IoLq/4snAQqrpoFZEoVbVXDMP96QIRHhN2/0i1gxWQreBIW
	Nrpf4cfQM9Ejza1gXlfTSD5T/TnhXmkaJUc1Ws9Hdavn+w3o8AiFdCx3/UnfANPvPBxryc
	796LiL3dFfkDGFJTZemGdsk2REQEk9s=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GVWhU+w4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011840;
	b=cOG/TGpNOTJ1UxRaNGKyFdTxZrU4NET5WiFmUT9/a5egAY0nJ56BS36rovrOJFo2gRB/In
	Td8Rpu5CobDKTGDDUW8u2UpCeGvnFEwETgrSmpy6VBu19aD3hxtkhwDHt3ESxlDAeFiWG2
	J8/E+DOb2jO9I4EEewCQe0NevaP0GvA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13C00444F6;
	Sat,  7 Nov 2026 00:37:20 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011840;
	b=I03qTBEhMTxa3skxjm/RHt8UIFcsdm/Lv3oJ7wLwBykGpTWec8F3ksj64DvhNeSFcpxx
	 g1150VDTxyZGTkGU75uUrYa2EOKaQWiFq/ZeLA+Be2MFzbmTtN0v6Sz3CmDXyzx1SSBsp
	 KEejLc0PsD3LpsAqgW/X1fGhkSokrJvNdQJL6VgunaaTZMT4UGszzViKg+mQLS8wBtoAp
	 VFJqUATwkzcHBrMN4+Dn59gBXtgop+NbU1ADCoOtdjA1EeW7Qgx06jZl+jRFQQlne1bGa
	 hqYGMejYu84etdYyPO4MrCU1Cctny/GWxBFOIikJrmCnKJ1Hr7ijIHlQUhOSAsSS44w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011840;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=rynyKDSc0zUIf+ovCUTrOZiWmRXp4NT2kPlsY2Zv9nI=;
	b=AyYHDDTDavRiD+DTEwt9NCo6H9FsTvzhLico66j3F2msHSYmxvhe/aXmtqN9AcsQOy0X
	 vH87VNUGsdM141LNVejjHmFzePD7bWp+aMWPGREscc5iIau0Xb3Vup2ahL/m0+zB+wJM3
	 ct8YCmTiv10hJ+NbIcPTq+gV8qLSU/UA49uH08ChSGUAvYOHhYnpzSbo2DQr902LfrbY3
	 qJSLvBvPjAEVhBltCYq7m7V/PEzpiQrsZqY8w7SVulj/389febT/mqtLeoHw+xhT41oRt
	 6fQIXUKS2v1H/AaxQynfWEuLMqn7bLm4xvflhM51VhOKyf0N1ir179NxAi8cwE15QFw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BBCEF1F008BD;
	Sat,  7 Nov 2026 00:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011839;
	bh=rynyKDSc0zUIf+ovCUTrOZiWmRXp4NT2kPlsY2Zv9nI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=GVWhU+w4d3BSgjsBGPStNhlVwwTbKrmU/QDwqYjI87cXdTL3umZSMAxyTZ3grNQRe
	 TftFaOjtx85NEPT6+6ldNTzxx4jufKH3abviANVuRExBCfFkOclItVKpbxCZBzSxpc
	 cAFwWBHPmcW+P3JVaQzcriQia7C2649AJdpay8wc2GA8ekpuoYMjrqc2t9SLWVg8c9
	 cgxRNVJsJC1MuVzqJMLkHld/yEsMPm6pBrp/FyG5yuI/13kn6SW5uw0HbOBVp63pye
	 D7DAfiyF5usQjR2Th+15sxmnus1FA3IoFJvOOp50F5+B6gzPDpZsRRIBLQqQsQ0O3U
	 xLGNoB43ZJM0A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 2775747A42;
	Sat,  7 Nov 2026 00:36:58 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:52 -0800
Subject: [PATCH RFC v3 78/88] KVM: selftests: Verify VFIO access directly
 and via guest_memfd
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-78-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=6129;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=wMpfVe5pW5612uAirzjznbXSxcHXbU2mXBke4sAga64=;
 b=tdBMo5bwX2Uer41RpQmN0GH50JgBfYlCVTon4eNRJWYkAyazzOurorg07KXh3Jb95H9HI98uP
 YptA2UUYyosDFhRRnsmzi7EgQN+1UkGEJfe/r5Sb3/gVzYbH6wjyWS0
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 98F5E100009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 5zckzfiwztyjc9qqhk63a3jemq4cmyg7
X-HE-Tag: 1794011840-666914
X-HE-Meta: U2FsdGVkX1+dLYSw5FXPXDJUSTLMOQlSPnaua6+s5HpYXIAFCE9sWSIC6ofQVBQ95o936nV4lMjrUHGIajjT1L94SUGseAc9K6qKEb6W+Zd3XIEQDYdwuhs5LcwubrzdXVWp8fduua8NhfxEOP00I/aOULRF7F1shHrLycuN2rBTTqauBdP72CxUK0zfrDjRZMLoF5ljQhEEgsvE1swN+QYvjxDUD1ljAWx4aIVImHITTruSsmVEo4qedzyYL2oQfc3q8o4RTXYJSJtVNX32J+tMqs+0J9Qg5m6VlvLboNriNupQ0cJoqPZPizaE/rOgfbhuC7suH1Q/MN5uGE6RPOps2NAIqeDDaUHK8nJVx7YZ4gPlGLY42HhxcOzi10/kyxBBmUjG5NZE6QiMMA/a8DBAmwv/0ID5QmgKdtdD8ls+YzwI9/DU/TvygKND3AQadRtLWsbI699zQZz4GLGHZUd20EgCqv7Atbuo5akAE8F55elHRJRq2IY3905AajkrarkNszI0Nl5jidvQw10Tsw57vZD0wk/O72ntzm4FwCJN0Syw4ScQBz+Gd6hc4mJhC4K8BmXCyg3FQij41MJIyRasY6Q8PMX6Kgp7wDHslPIFpfo0ynwTkxjuJ1nf4gMQDmTd+13sgt7pO4A3Jd1c/YNM316/mE4YVPsfTNbevb4jlO/31vXfsZwcaQ4Jp5BvinHI5xzvoIXa+h9frhT4aJFe1c+LmX9sH6bJvaczIyCDU8AlUdanQuF+3sEltKZhg/6RDKtbre4LLBPvmCkz1suFN8GOBKP2+aXPVAhdyufJEKPB4o9oylJNa61nd8wQj+LdgMNDzxHq1DsuwIjzBvF25ADHiIl7cXpvHwhJfRO34atim9lcaHuWMdTj/t/uf31icm6cX9U8G7d+Xby4L7HdKrYEMEpZXIvBBk5Vg2HPw4jWgyP1qv/OwhxmeSs9MfsbaZ+seUIoKu8OfkE
 p13CmBYH
 f7xnlYx/coHO5ky6J3yP+XThj5A7xi4OFiAUry7deGO33GFetkQjdoRN2g+mGiD0tiAsQc7tHqeSskmKtzQ6OYvZJqtEafvCDAatoLcXhQmBLLX+I3nBth8qW2EJEDYmW3GtFwP3WnbzjSuN6vNNQwocnffRyMzf9wdk/5ch4XU2PU3MyYTonKGu+4XRZWES803fRt+2m+gcAaw3+ZfYI4kyWCU+oq3qGC+ubz3TvM7rlpG2TCuvfFHir5uCIp2vsNKDibm/K1jHE0zoOIay7spkDj+TAfz4gS49tC0kV7yin9egP82PdnJIY+2xPh0QhPkiJLO/5Wg/LkFnaGAWcrpNYnn3vOqRirPc26rEvy2LXJPcfieVc0Xp9hlKsLNcDVvExq6Urp9BEnHI4NWd7I/rk5WAyznGTrhu6x6KO8k5xZC0YYI67pqA/eepTbT9ReL5Nn1+VduJ+KygekwvQvOdgiWo7zvKYvqotGkdQ/reC+WIWh/+GEmmMpSZcX9lfEmWMYsjzeEstAeZXhlcfSdOvU9j3/EZJi34axR6NBpKRnfj3v8YcDIsvvZVa4WrLUh2DMQJiSpZ6IhCKUhmrFl3Cc0EGFdaG9BXs/oZD0fuE9Wk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Extend the VFIO igb device selftest suite to run across fixture variants
testing both direct VFIO access and mediated access via guest_memfd.

Define two fixture variants:
- direct: binds the device normally, exercising direct descriptor read,
  write, mmap, and reset.
- guest_memfd: binds with the control-only flag and attaches the device
  as a backing resource for a guest_memfd instance, validating that BAR
  read, write, mmap, and reset succeed through the guest_memfd
  descriptor.

Because guest_memfd delegation of VFIO regions relies on in-place
conversion (per-gmem memory attributes) so the entire sparse region
namespace can be initialized as shared via INIT_SHARED, require
kvm_has_gmem_attributes when setting up the guest_memfd variant.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/guest_memfd_vfio_test.c      | 77 ++++++++++++++++++++--
 1 file changed, 72 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
index 91cba359e4392..03c324f7f618d 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
@@ -21,6 +21,7 @@
 #include <linux/vfio.h>
 
 #include "kselftest_harness.h"
+#include "kvm_util.h"
 
 #define PCI_VENDOR_ID_INTEL 0x8086
 #define PCI_DEVICE_ID_INTEL_82576 0x10C9
@@ -96,10 +97,27 @@ static char *find_igb_cdev_path(void)
 	return NULL;
 }
 
+#define VFIO_PCI_OFFSET_SHIFT 40
+
 FIXTURE(guest_memfd_vfio) {
 	char *cdev_path;
+	struct kvm_vm *vm;
+	int gmem_fd;
 	int iommufd;
 	int vfio_fd;
+	int bar_fd;
+};
+
+FIXTURE_VARIANT(guest_memfd_vfio) {
+	bool use_gmem;
+};
+
+FIXTURE_VARIANT_ADD(guest_memfd_vfio, direct) {
+	.use_gmem = false,
+};
+
+FIXTURE_VARIANT_ADD(guest_memfd_vfio, guest_memfd) {
+	.use_gmem = true,
 };
 
 FIXTURE_SETUP(guest_memfd_vfio)
@@ -107,6 +125,10 @@ FIXTURE_SETUP(guest_memfd_vfio)
 	struct vfio_device_bind_iommufd bind_args = {};
 	int ret;
 
+	self->vm = NULL;
+	self->gmem_fd = -1;
+	self->bar_fd = -1;
+
 	self->cdev_path = find_igb_cdev_path();
 	if (!self->cdev_path)
 		SKIP(return, "Intel 82576 device bound to vfio not found\n");
@@ -123,12 +145,50 @@ FIXTURE_SETUP(guest_memfd_vfio)
 
 	bind_args.argsz = sizeof(bind_args);
 	bind_args.iommufd = self->iommufd;
+	if (variant->use_gmem)
+		bind_args.flags = VFIO_DEVICE_BIND_FLAG_CTRL_ONLY;
+
 	ret = ioctl(self->vfio_fd, VFIO_DEVICE_BIND_IOMMUFD, &bind_args);
 	ASSERT_EQ(0, ret);
+
+	/*
+	 * Create a SW_PROTECTED_VM with 1 runnable vCPU allocated for memslot0
+	 * and stack/page table allocation, so guest_mapping can execute vCPUs
+	 * and FIXTURE_TEARDOWN uniformly cleans up self->vm across both variants.
+	 */
+	self->vm = __vm_create((struct vm_shape){ .mode = VM_MODE_DEFAULT,
+						  .type = KVM_X86_SW_PROTECTED_VM },
+			       1, 0);
+
+	if (variant->use_gmem) {
+		uint64_t gmem_flags = GUEST_MEMFD_FLAG_USE_RESOURCE |
+				      GUEST_MEMFD_FLAG_PFN_MODE |
+				      GUEST_MEMFD_FLAG_MMAP |
+				      GUEST_MEMFD_FLAG_INIT_SHARED;
+		uint64_t gmem_size = (uint64_t)VFIO_PCI_NUM_REGIONS << VFIO_PCI_OFFSET_SHIFT;
+
+		/*
+		 * guest_memfd providers (including VFIO) is only intended to be
+		 * used with gmem_in_place_conversion.
+		 */
+		TEST_REQUIRE(kvm_has_gmem_attributes);
+
+		self->gmem_fd = vm_create_guest_memfd_resource(self->vm, gmem_size,
+							       gmem_flags,
+							       self->vfio_fd);
+		ASSERT_GE(self->gmem_fd, 0);
+		self->bar_fd = self->gmem_fd;
+	} else {
+		self->bar_fd = self->vfio_fd;
+	}
 }
 
 FIXTURE_TEARDOWN(guest_memfd_vfio)
 {
+	if (self->gmem_fd >= 0)
+		close(self->gmem_fd);
+	if (self->vm)
+		kvm_vm_free(self->vm);
 	if (self->vfio_fd >= 0)
 		close(self->vfio_fd);
 	if (self->iommufd >= 0)
@@ -236,6 +296,13 @@ TEST_F(guest_memfd_vfio, get_irq_info)
 	}
 }
 
+/*
+ * PCI Command register configuration belongs to the PCI configuration space
+ * region (VFIO_PCI_CONFIG_REGION_INDEX), which is accessed via the underlying
+ * VFIO device descriptor (vfio_fd). In guest_memfd mode, bar_fd refers to the
+ * guest_memfd descriptor representing memory BARs and cannot be used to read or
+ * write PCI configuration space.
+ */
 static void vfio_pci_enable_memory_and_bus_master(struct __test_metadata *_metadata,
 						  int vfio_fd)
 {
@@ -276,7 +343,7 @@ TEST_F(guest_memfd_vfio, bar_rw)
 	 * Confirm device is readable and does not return 0xFFFFFFFF.
 	 */
 	val = 0;
-	ret_bytes = pread(self->vfio_fd, &val, sizeof(val), bar0_info.offset + E1000_STATUS);
+	ret_bytes = pread(self->bar_fd, &val, sizeof(val), bar0_info.offset + E1000_STATUS);
 	ASSERT_EQ(sizeof(val), ret_bytes);
 	ASSERT_NE(0xFFFFFFFF, val);
 
@@ -285,11 +352,11 @@ TEST_F(guest_memfd_vfio, bar_rw)
 	 * it back via pread().
 	 */
 	val = 0xdeadbeef;
-	ret_bytes = pwrite(self->vfio_fd, &val, sizeof(val), bar0_info.offset + E1000_RAL0);
+	ret_bytes = pwrite(self->bar_fd, &val, sizeof(val), bar0_info.offset + E1000_RAL0);
 	ASSERT_EQ(sizeof(val), ret_bytes);
 
 	val = 0;
-	ret_bytes = pread(self->vfio_fd, &val, sizeof(val), bar0_info.offset + E1000_RAL0);
+	ret_bytes = pread(self->bar_fd, &val, sizeof(val), bar0_info.offset + E1000_RAL0);
 	ASSERT_EQ(sizeof(val), ret_bytes);
 	ASSERT_EQ(0xdeadbeef, val);
 }
@@ -310,7 +377,7 @@ TEST_F(guest_memfd_vfio, bar_mmap)
 	ASSERT_TRUE(bar0_info.flags & VFIO_REGION_INFO_FLAG_MMAP);
 
 	bar0 = mmap(NULL, bar0_info.size, PROT_READ | PROT_WRITE, MAP_SHARED,
-		    self->vfio_fd, bar0_info.offset);
+		    self->bar_fd, bar0_info.offset);
 	ASSERT_NE(MAP_FAILED, bar0);
 
 	/*
@@ -347,7 +414,7 @@ TEST_F(guest_memfd_vfio, device_reset)
 	ASSERT_EQ(0, ret);
 
 	bar0 = mmap(NULL, bar0_info.size, PROT_READ | PROT_WRITE, MAP_SHARED,
-		    self->vfio_fd, bar0_info.offset);
+		    self->bar_fd, bar0_info.offset);
 	ASSERT_NE(MAP_FAILED, bar0);
 
 	/* Write scratch test pattern to RAL0 */

-- 
2.56.0.455.g6c5a503b38-goog



