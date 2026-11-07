Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 013B3606B751
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iRbB3VvT
Received: by kanga.kvack.org (Postfix)
	id 6E9376B05B4; Fri,  6 Nov 2026 19:37:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64C366B05B5; Fri,  6 Nov 2026 19:37:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5133B6B05B7; Fri,  6 Nov 2026 19:37:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 162646B05B4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:00 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 809C14022A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:36:58 +0000 (UTC)
X-FDA: 85406458116.23.248FFC6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 666D7140004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:36:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iRbB3VvT;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011816;
	b=ax2EPjsdmM5iWvZOYSxX7rnIe7sVwcroOXCEZOUfk+LbfFnDoTlmkz8bdWbJeG32bSrCca
	lG3/aJe7WdKUvRsmRASnTDFVf6sK7H4ZHoyuYqPymPlZUwRoApZj944LadTh+4ZxalD+UM
	a0Pbu0CIrwSMeIae160pp6I00RRMgps=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iRbB3VvT;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011816;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IN2sJFI9lnAkbUW7jJR+0lDHR2zRdHCWKMolY+WnOwc=;
	b=aTTlFFb6nTLUAT6V3HmWz9eOFY+CeLakAHGwJtCJYVHokKdD0tVDzOwCP9h5RySyw1ftmJ
	MQ1tsfMlVXG7WtKozCx5wrJkKtQ5FrLIGFcLm1s1j7kCnnRFH+KBrSZ/ZRVhfcr0ewx+Eh
	JbNUQ3bP2XvwSvAGqh5HWVOhgIIBUlo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A08F343F19;
	Sat,  7 Nov 2026 00:36:55 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011815;
	b=WEcZAY7jJkRb50ZVg430HdQozIAcu4hA+Fd1+ZeSK3tXPM/Hh+zdfeQG8zS6tIR46z6v
	 7vtEqceZlCPjnMMXbAzfO26XwFWbAsgpo4SMBz4mLxT7BB3OYLssLBRr04ggh8oQQYPQY
	 lCWOWtk6HCYoFigSKJgOnsjH3QuYvggPp7h2ASUETzVh1QIoBwvpCE92GkJgJBkp7JkjX
	 Jjvtumc/FBT3ZW4SA5ermOAunzF5ttCGCKivst8R45wafyYAQg4jSCE7W+B32R5iA1mqN
	 5W9xMQevx7lOKBh3k1r/OpRhMRBsf053AsVfIHPMSxJUsmhietqGE2a85i469a35SSw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011815;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=IN2sJFI9lnAkbUW7jJR+0lDHR2zRdHCWKMolY+WnOwc=;
	b=lWgU/ogRVzsAWK86FnNReT5Ta++xpOcDyvBN5+kXx6IzqSa/J7NrDwOCw4RU8efad2JW
	 v1OHdUHHfPwJp4v7TYcYLv2EnmMTeO6dJ4Poe0kAzLfpY6SPihNTuc3fWoczVdda0cVnN
	 DK/GkJ1b0EBPVc4XqgTDAON/gCyYsMGXp9d/knf3/kOt3sPbj6+TzVpjWgVxZywaCXSkc
	 9v7g54rEcNHckt4THDvY5VyjCbJLGSt9jbXTxWrNwZyBWKuLtck3PEnj1S2K2AP2f0a66
	 wyR+PBWlvHmsc2AIhM8pCs+JzA+Wsi5I1bi6NjMyk9Z2W0VvTFppLSHuOtYHYZTTf+g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 946301F008A6;
	Sat,  7 Nov 2026 00:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011815;
	bh=IN2sJFI9lnAkbUW7jJR+0lDHR2zRdHCWKMolY+WnOwc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=iRbB3VvTzrRjBbUnEicb/F/Ws1M15cW+ocx3z0ai/CqoIkK48pDzG2e4zqIlmtBBA
	 Az5fpspzwFP3sCQqb5keFrKpn53/d0PRo8uoZwDBIoh2pDlEIY5GaESXi3vPmRkFFL
	 DfRynBIreU3egXppsVVqfTq8SeOW6zGURlHOZ/s0Uau+hiO3C3YO085ShO+Z1exZJl
	 7KDmfrVPqR+QAmZM7ZIy/reUqbtQXD9IXeBN+798a+6+IbQr8Xz2eJhARPaNX2JHjQ
	 u45u/oL4M26ofYc5kJD+mgTlf+NPS21TDqiPa5rHzC89jqhY1dbGYPkxmPr5GOdNxe
	 NMqyKY+PmcQBw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 3C6474792C;
	Sat,  7 Nov 2026 00:36:53 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:36:40 -0800
Subject: [PATCH RFC v3 06/88] KVM: selftests: Add helper to create
 guest_memfd with a resource file
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-6-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=2914;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=HwDv49TbFyLaQwz9LCOZA4aF7JG10mwskiDo7x6oZbQ=;
 b=LRwafGuWDlZtcnxWkVJ70Rhj/7Q+IRQTMyNt0B9dayGLhRnuP7AYKNdTopMWV1bHlGyYqCOdh
 TzYxk30Z1uWCqfWEU7YmqYxCdSfwDcACzHF2C/PgfcnHakawGmLu27l
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5o51qtjgzch7x6rqnf4hw5daf8orr8gx
X-Rspamd-Queue-Id: 666D7140004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794011816-316295
X-HE-Meta: U2FsdGVkX18Wn4r+88Z2vZEhPBmapwFGI/EUaXczigo97H7JD3jloPH+KZNbTORZ6SdeEPmal+6xTRJIqLRrvuA7yWovO65ZLIFRhk2l75hagJTB6TrpOSjqK9cDXiPQPzzn+eNBJDJyo4uvmSxGKlmOXSf6227qIe7JybieBw9ROmNT9gkU8ZXmXW+avD9c5t+w7C5nkTw/qJ6ZpBg8kwaIUVUIIDgtRv+o/YJaSUTL4LsdZDRkK/n+FmsxVHr8nxxd5ddsHalf23r5m2l0anKGlj0MHimONtRCzUzVL1ZpxJbi2bzDqzvPLITY8dPoqBokKbNDUVKJOdoiA7m379MSsWWvQri7A2I981vZxx38w111g9NFGozJeP71H76hh8h2YsYDIbPuRIeOXCrET0YRPJ2OR36yeGH4QXEfRo7tItAQZsXn6We7bqPEvME+WvNUn/8ruwPCLNWSg2xN6lJRqbvxY4vEops/W3rZ0XvLC5PYt+i/IxbjxjO6LGB8gHoJM8dD2BNs7+VibnxS2BHyIyTY2Oaho7qGEst9Lj/rrCLv8Fwpz7gMbbCL5pfqZ9h1SiZPnIKy2xaSmbncECNULdLG6TA+BL1JZ+RkJMf8zV5TY+eaA8GaAz/n1jPUb82C8FuF5AUF2wi0PQSGIHPb94+DtxRr6INIR46vapNbpW7zlev9cU5WoMx6N5XqTG2uwi/Dc5qqBCFwx4ibSvELWFM/d0f7VNhFHdlL7ykRbkhkSJJsvvmlAC0Koftw3keTk8aC591MX60uyEnKqVqMatXtfg132se1wqVQqzNBAycReVX46LVIawFIVTXpLmENfUuMi9uMTeXo5dg7YvQkuTZc7nuW/iR4D6MDhPXUMaSHrWQ73HoMHT8EaHH0Ws7olxmaU95FuWhvkF6TJ9aP+CkcPHyyMDts1lZLb/tAYYqJb/Njm+k+AOGHYzFkiUemIuL5anW/c3AN9dC
 AF5JMeFC
 aHVQMQF7mYcCEfByHJSevW4zQjz9EoGnSNbWf7QCKu81ppLK0Aq/Cl9MD+TtAy2hz9cV5F4xzEyz3Jsvw3LgE07qM1W82NQS6mrRbetS6Hqj5jI6dSKCddA+2tnMtNFGlFfd/aaL/LzqAtKQKvl3Lb5enLi68SjIHI5NaDI3aQJa0G7UyXrwUKF1OH5VfkUHbQtVprlbUpOfKoiN2DeGVVWs1Ja1hvgNs16bml2K6xY/wdtjo+Ai3qWko/1pOHd+ziyLDk18pHlK08vcffjJqVYPK1b3JpFLiRxAtKO1GlmMe3+2he803tI9vQxMZypBkmH9HvrYyxA0usp2b5feJ4m36rdigxdD2a9ttw9EEsuPbgzXRwzJ7aav7r57qg3Z+7WlSCkL7e90chHgxU7LHCzwA+PP+KxLVvWkSzoq4+cCZAHmp3NRvncyNLogJTKG6oefiSEIiiv6sg8AbDrG644xe1teDSsEPSsZmb6gpGoQAGfPbskw43XgvKYX2QMf3ZChK2oG3PnNoV6v515oeFzYvXAohLJkWOh32uY2kJ6HJBcQ5Puw72INYUYUL3CfbbQM381eIeQWStXgiwIYwz7Nwjky/nmB1zXnfWs/B/yF+zUs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Add a helper to create guest_memfd instances with a resource file
descriptor, and update the existing creation helper to pass a zero
resource file descriptor.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/include/uapi/linux/kvm.h                 |  5 ++++-
 tools/testing/selftests/kvm/include/kvm_util.h | 23 ++++++++++++++++++-----
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 419011097fa8e..66c1f40b50c29 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1654,11 +1654,14 @@ struct kvm_memory_attributes {
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
 #define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)
 #define GUEST_MEMFD_FLAG_INIT_SHARED	(1ULL << 1)
+#define GUEST_MEMFD_FLAG_USE_RESOURCE	(1ULL << 2)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
 	__u64 flags;
-	__u64 reserved[6];
+	__s32 resource_fd;
+	__u32 pad;
+	__u64 reserved[5];
 };
 
 #define KVM_PRE_FAULT_MEMORY	_IOWR(KVMIO, 0xd5, struct kvm_pre_fault_memory)
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index e2618877619e1..eca296539db79 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -809,26 +809,39 @@ static inline bool is_smt_on(void)
 
 void vm_create_irqchip(struct kvm_vm *vm);
 
-static inline int __vm_create_guest_memfd(struct kvm_vm *vm, u64 size,
-					  u64 flags)
+static inline int __vm_create_guest_memfd_resource(struct kvm_vm *vm, u64 size,
+						   u64 flags, int resource_fd)
 {
 	struct kvm_create_guest_memfd guest_memfd = {
 		.size = size,
 		.flags = flags,
+		.resource_fd = resource_fd,
 	};
 
 	return __vm_ioctl(vm, KVM_CREATE_GUEST_MEMFD, &guest_memfd);
 }
 
-static inline int vm_create_guest_memfd(struct kvm_vm *vm, u64 size,
-					u64 flags)
+static inline int __vm_create_guest_memfd(struct kvm_vm *vm, u64 size,
+					  u64 flags)
+{
+	return __vm_create_guest_memfd_resource(vm, size, flags, 0);
+}
+
+static inline int vm_create_guest_memfd_resource(struct kvm_vm *vm, u64 size,
+						 u64 flags, int resource_fd)
 {
-	int fd = __vm_create_guest_memfd(vm, size, flags);
+	int fd = __vm_create_guest_memfd_resource(vm, size, flags, resource_fd);
 
 	TEST_ASSERT(fd >= 0, KVM_IOCTL_ERROR(KVM_CREATE_GUEST_MEMFD, fd));
 	return fd;
 }
 
+static inline int vm_create_guest_memfd(struct kvm_vm *vm, u64 size,
+					u64 flags)
+{
+	return vm_create_guest_memfd_resource(vm, size, flags, 0);
+}
+
 void vm_set_user_memory_region(struct kvm_vm *vm, u32 slot, u32 flags,
 			       gpa_t gpa, u64 size, void *hva);
 int __vm_set_user_memory_region(struct kvm_vm *vm, u32 slot, u32 flags,

-- 
2.56.0.455.g6c5a503b38-goog



