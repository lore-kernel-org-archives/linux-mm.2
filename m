Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF14F60A261B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NvlodKFH
Received: by kanga.kvack.org (Postfix)
	id 520BF6B0A2B; Thu, 22 Oct 2026 19:27:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F7486B0A2A; Thu, 22 Oct 2026 19:27:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36F966B0A2D; Thu, 22 Oct 2026 19:27:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 010C46B0A2A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:27:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B2AEA7D2B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:27:57 +0000 (UTC)
X-FDA: 85351852194.24.F795A5F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 61916140007
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:27:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NvlodKFH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711675;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AhsCAHeF4G1bvxTGW5DQU1iaZNYIowM6jP+PHs3NHqY=;
	b=SrnVvMT1FzY7aGaOVsLkGNhiOiIuy6pjYMQLIZakWCA0LEuzV/V6WQpbNxJYxQ4SsHAvA9
	DIIR8fjAX1RXnxiL1oHQKXClBjoMVIj+rk8lpn4+TS3sp/ZC+3KATjIUasjTNJreTOGtaj
	IQExmkFw6qymhsXBnXVsLsdq606GhVQ=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NvlodKFH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711675;
	b=miGafkfhAxAMFl3fsSlWhUzihKdDpdJMsLmps8e7e0m85LWaHo03epzkkhY87Q1NsWz+sr
	pb3/VAnPv3qIJTmfhjTmaW8kmF55X8dKLQCAoJqa2hJ3G/IH80fL96b4pdt6gZkv+fyLN6
	L6VpJRHOIgtH1acUCRJT9a6HTaY87Qc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6018A44780;
	Thu, 22 Oct 2026 23:27:54 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711674;
	b=kAvkIVgJX/85PFczqeqqwwesdWdUzpTa+xIVks8xVD+GwFtFQlWoM6OOIw784fDeUBYq
	 f/CzFMhLjRwIRYU9L3MaY0uUPqepuh9GiWFM+dG6LEUuVmCHONytPgcwGy3NOzw/YGDF9
	 CrRxfQS9KD5URCgDvVB6j7JjuMGfPVNip6Nt+JljV0RHUz3/3THQKnUyAxzFu2nupeQy2
	 Qv9tfqBsLGYUsQk7A8SE+FKEu3iEdpW5nVlL65Xk8eXCrNhERwau5rhEwRl1J0qc4zRQe
	 aGmjMwWzjLZn+cC7LGJRbcQDcNCQDQmKD5jKR1Yaaxl516AWZzYA/kJKNh3KpmpyoHA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711674;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=AhsCAHeF4G1bvxTGW5DQU1iaZNYIowM6jP+PHs3NHqY=;
	b=aa52iYCp1aeGNUKfGBSAIErbKWF8C9mFWDa0k+DRi3wXyYONo4Y8Cr16sQMD8PE4JS05
	 uNYxPRa1lfEUToIeyNlNpB1/E//mQ8pxEdPVMoFI7004PN33pexfKlX8TeDFyNoL7DeLR
	 dLNPJp0Kt8WuViJoQYYPJuJYNAYLff0rHm2XIETwDkaZIj41yQWmqxbMnluvlRwpdN+3U
	 sOSEh4emtdKI2poDbTtWUFYXkC+kIAuUaaIhwse8FEVOln8qkpAc56sZfrF6usW3IfjHi
	 ePNHcf2gTX+2Tt+ASPkGk3HIvyKfEuwAM4e/Lwo3z6K2hhvItyF1KB2gY3vbXDI40bg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 206C41F031E5;
	Thu, 22 Oct 2026 23:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711674;
	bh=AhsCAHeF4G1bvxTGW5DQU1iaZNYIowM6jP+PHs3NHqY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=NvlodKFHMmqTJm5Nn4kb2D0wCFCqukSV3v1vnBN4ayxWgFnVce7cvKD07h5yJ3951
	 FHIbEK7cZD9NU4VC/oMD8I6UShqOwa9qVDM2eamGdkMMPSg4FrRlpaGmku2pzfHd5k
	 1GGf/l6CAYUEke2MrM99KsVJkRQkgzMqU3KpkO4clUYC3INAtjCjVoU0y/aPJrmVn3
	 afklF7tYTZtR/Ta8CuUC0N/RSyu0KjWrn1dcB2wnvlI3JeZ3i/6y52gOiNpI6R4xs8
	 D4ClpayiO3FsYxF8vB37v9Fn/4MZL4jk/qqaSd44U5LQ0ysSnq8+lAJSui98oiTuPr
	 AX/4K2vSAQlLQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 837C442059;
	Thu, 22 Oct 2026 23:27:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:27:38 -0700
Subject: [PATCH RFC v2 06/50] KVM: selftests: Add helper to create
 guest_memfd with a resource file
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-6-5dd1dc6c660a@google.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
In-Reply-To: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
To: Alex Williamson <alex@shazbot.org>, Alexander Graf <graf@amazon.de>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Alexey Kardashevskiy <aik@amd.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Ashish Kalra <ashish.kalra@amd.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Baolu Lu <baolu.lu@linux.intel.com>, Bill Wendling <morbo@google.com>, 
 Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, 
 Christian Brauner <brauner@kernel.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Connor Williamson <connordw@amazon.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, David Hildenbrand <david@kernel.org>, 
 David Rientjes <rientjes@google.com>, David Woodhouse <dwmw2@infradead.org>, 
 Erdem Aktas <erdemaktas@google.com>, Frank van der Linden <fvdl@google.com>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, Fred Griffoul <griffoul@gmail.com>, 
 Gregory Price <gourry@gourry.net>, "H. Peter Anvin" <hpa@zytor.com>, 
 Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, 
 James Houghton <jthoughton@google.com>, Jan Kara <jack@suse.cz>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Jianxiong Gao <jxgao@google.com>, 
 Joerg Roedel <joro@8bytes.org>, Joey Gouly <joey.gouly@arm.com>, 
 John Starks <John.Starks@microsoft.com>, Jonathan Corbet <corbet@lwn.net>, 
 Justin Stitt <justinstitt@google.com>, Kevin Tian <kevin.tian@intel.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Michael Roth <michael.roth@amd.com>, Mike Rapoport <rppt@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Nicolin Chen <nicolinc@nvidia.com>, Oliver Upton <oupton@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Pratyush Yadav <pratyush@kernel.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Robin Murphy <robin.murphy@arm.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
 Steffen Eiden <seiden@linux.ibm.com>, Steven Price <steven.price@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Tom Lendacky <thomas.lendacky@amd.com>, Tycho Andersen <tycho@kernel.org>, 
 Vishal Annapurve <vannapurve@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, x86@kernel.org, 
 Shuah Khan <skhan@linuxfoundation.org>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=2914;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=wQedx/S6RxZ5UzC/bx0PyQVruBvMuVfyn7u3LMl/3ZU=;
 b=EZ/IOKpg7KrAdS+lcfSuSMk9DELGjm3sYsNs1mz6sm7ZEuVpMp37oLH+u11yOwKkXF2Xnz8Tj
 3g1yoTCZwRKCsclSrPBbeDHUK9cbqEbMDHc35h0WidAbFngykeYbEVn
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 61916140007
X-Rspam-User: 
X-Stat-Signature: awozxkqijcajsnj1hyrigoob5aa8wdic
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792711675-335140
X-HE-Meta: U2FsdGVkX18OnTi21RhAb1Y3yxAfKTluAp+HOaJNu+3FGlD8EHkMf+1IYuzbD0JBqMONyEsZqxcBAoIvqUD7qau9K8A8CoaOlXQNEChxkzoDe0/aakdVbmlMHakbLR9oVNyNgpBzA1kpbHOBfxwGO7vUGhhGsI1p1VGguqEmpb0EnPgd6DQZocqpu8QOeSbI36G1YlwwGmhuf+TnfGth783dFcPa1TBLzvLZjjPjVqxnC01NYRH5lAcVG1GSnHgKfu/58K6e/6h8/vDh3K43WT7I3B0bOwGujO6GI1T8ZSugXi51vSM0MrarvNBm46sgDe82dKCHPcYZN4DS1YuIJ8+RTu9pElxMWJfQ/HyWDOa0XSFJK9YYQZp/u0bUoJE66Kqh8T1J+YqyHaAxU/pMHOv2BiFnvrgDKDdhCuSdifXZWNLVuFtE3y1TpueGfVTw58JME/XJ9IS/+YwunW34nQG9208GAYB6PAo5wWZUUOglWNFJr4xzy8PxaDtki2LPn9Jbm8aC3gZwu84BftnVX3281EwxMwUNzBp/Qj4tJngAPx2/+ec/cHbSOZnnkiiAkWbLZKav6YqzC+9IVtTGsHbF4P13dRntEphIbk/JpS1rNTaUFSRf43CkV1xfrNGNv3EphY6OHl2jYndNWpkX6gToGIOJZXzjFtFd18lfVoCoj7ptEL8sEw30SoB43iq617yGZQQ/aKqzXKp16dgN3qWeRqQWgxG1b2tbV8oFiPIGpwX5/f70xQce43xeX14gTCKa8wBoTTCSQvTN+QXs2f47vnEOeC7k4JpMGD+obBhrsMaHc3grLuI3VqMz/gJLG9jbOQNcpZ0yZbScwieR/qdQdZadRoAYHUeyH/wHECbNw6f6+4mmt0S2fkart07BqYC7/iHIrS1ckApit82BKGUb4R5hjxVlAZ08ePljemfviTGtlZ9HDLXXtb30HYsUFEiCRZQgU+OXTec/Win
 hpbcjDM3
 f76lv89mp7KjVkvPFYNnh6/VSy73KDL0tPmbULitoeK5rZzJTqCPTMrI5QTrVgsHlSngFaQEOlnJ0Gt199UxFwxznWLSmsqghQEHYcWo06B7VYIfSYjrDsH/j8jqQsEf+UmHy+uxqwenrghNZ1JLzHj0Ybn7hy+UXRx2S86WqZsfTJsuiM+n4C0IxzG6LGZwXYxN/GgRVmil6U210EOjKQRcAEWLLkKOYfgu0aj3TFLDfWTwjPpClvdR6iRM2BAJlBOa+YMbu+V0ahjTifLzE2KbBLQGBgD2+bGFoEuJiliQ5xVin9bSac9g19F4B2U8e49t50BIA9VBfgBEy0WNZ80uASvBB/IeKEVN7h5Gb9Hok2G85hwcnt3PiDMvV9Jc6Aba5XDYSE5WUQQ0amxCUGzl0ieS4rxv63lF+Y8ZonYRh98v+hcF4G12BjVQeAJqVfX0gMkH4fecgUmhqiJ9/8UMfmwECmGkgthJMxEkYj/H+8oavsi9ux/bXlhcbmHaz8DauJIgqtShr3l//lJfpvBSuv6R72BNYLIdkt/CcEqa5o38H95wYqIeVt1IvAKZKnUjP1MqVkOx00u/AO5Vjq0YcPMWOaN7jrdQG
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
2.56.0.257.gf7497c7d27-goog



