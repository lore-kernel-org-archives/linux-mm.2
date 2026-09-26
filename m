Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 123CAC9830E
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 00:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B1B46B009B; Fri, 25 Sep 2026 20:50:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 162AB6B0099; Fri, 25 Sep 2026 20:50:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF98B6B009B; Fri, 25 Sep 2026 20:50:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB3F86B0092
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:50:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1F690160811
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:55 +0000 (UTC)
X-FDA: 85254083670.19.CE4C1A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1E831180005
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VlIbi7CG;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790383853;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YC6qSpKIC1f8L6AZJWv/YkddRwRb4W4tDh9n2fP7InI=;
	b=qtFX1qGI6AUOti00XdfjeTE9xi9Uxbtt7xBU8sSZiqVGtqohLnvJoOjd8lC7nQ5LqYaJQi
	xjeypgKBLHHeHFQQtcuWAf5j2WTF86p4QH6vTWqW8byO9gV/Ozxf6PF940H7KKhHIu/WQI
	P3P0jtCf3qHIQXHJIIP0mR75NLr/Glo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VlIbi7CG;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790383853;
	b=k5VGGlKL7Z/2MVSY6YZxHvgf0vnrR+d0pVXBtOOFZGvoj7WckNeb0zyStWBgu65CJPKuuE
	qDn0hXqazm2Gt1W4NrPV36nKQLPe9rc/mtvgX5A2XAc4bZAstczxAfVJ4LIax55WzgPw3n
	gleIjnyrtphf9bvneb7h3KjWtebErUA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C7F1B447B0;
	Sat, 26 Sep 2026 00:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98520C2BCB8;
	Sat, 26 Sep 2026 00:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790383851;
	bh=scd7V/LVJivphFiPiDvRuz42sItWihE//ekPollR9ww=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=VlIbi7CGBVC1DMNetWyfB8xLyeMaQt84miSWHEyYRFw2SrAcS1IRXzGZVD5kNFnZe
	 Qfr6jxWfKyVOu48L8NI+6XNPbbhz8RVqxXXlnN5MebjdTS8FuQ5+V5vM3tb5XV7tFy
	 AhAspGmk90sOGAvjNcOvafwN6KcwenYmLqgrVqW3ept76WgZB5Uq1aPlFBaRGWLm2y
	 KpaDU6EMC4s3Q3Ff3NWr3Vs63iTil8M9KskZXA5AV7U4njaOlke/AB9jMUeo87fdub
	 wXahmRd/iKQKGwuJMbdSWgMIX4PoED9dGX33IzOpkkKUJNrZW5LcSpqdVdZGSRrFJ+
	 0eZKZbqdZ5A0A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80CC7C98326;
	Sat, 26 Sep 2026 00:50:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 25 Sep 2026 17:50:52 -0700
Subject: [PATCH RFC 05/17] KVM: selftests: Add helper to create guest_memfd
 with a resource file
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-gmem-tmpfs-backend-v1-5-d36159822d18@google.com>
References: <20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com>
In-Reply-To: <20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com>
To: Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand <david@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Shuah Khan <shuah@kernel.org>, 
 vannapurve@google.com, erdemaktas@google.com, jxgao@google.com, 
 rientjes@google.com, fvdl@google.com, jthoughton@google.com, 
 tarunsahu@google.com, pratyush@kernel.org, fuad.tabba@linux.dev, 
 Gregory Price <gourry@gourry.net>, David Woodhouse <dwmw2@infradead.org>, 
 yan.y.zhao@intel.com, michael.roth@amd.com, suzuki.poulose@arm.com, 
 Christian Brauner <brauner@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Nicolin Chen <nicolinc@nvidia.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
 aik@amd.com, aneesh.kumar@kernel.org, Vlastimil Babka <vbabka@kernel.org>
Cc: kernel-team@android.com, kernel-team@meta.com, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790383850; l=2918;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=a/IEkQZJisftLh4S+E8BZovfShlWauj9NzlVULRnFLg=;
 b=7ARebru5UbY4aUsqapWdwIr6jjRLvLKYLPWf3bBzdcMmZAQ4uzWyZEWPEWNPpEI+RT7Pue/c9
 2nchVurQunNCDcbczxcNhXiAZELx4OWz4fTcupDdwsNJ/jvk1VphSOc
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1E831180005
X-Stat-Signature: 56xwandize8xpdsudjcs856bucqo88fn
X-Rspam-User: 
X-HE-Tag: 1790383852-974561
X-HE-Meta: U2FsdGVkX1/H9/LaPWwRXTfYUE3SC4S5TejwKmYZ1kx34CIywgVrOiG+KIA3PNsV8swDVUw7t8FstuyNawHa0qDJ6oiBMdipfKi5WLsV5m7rkpQ215w4n1uSQx6FMDG8bb1dj3iaNViTTWJ78uXEDsxlqEE85TfWuKBxkjPqfSu2ZkMQorFdUKO9q1r4mAHhK2WRt47PkroTRGInAz5/e5E+cGyBwru21GICiBKdSZQRBhTmclbwBHfu9pib8TXCv5mLuWYSx5zLlLF8F5QUgPqhuslUU3xkxE75MuW4Qyh9QuP1QyrE27DlwqCFKOuTf2DGpHuUs1HQIrsxeDRcdaxbN6dYpajGSGQIMhZ2kVPMuHvHfiRhvYuHC/f/ftt6KFUXpXUHvwEgGyU5HYtXqUNRwiyjxJuXQ33QWRDBdoRIosG6ogYjxQEDlSsmOufN7+cOEuvESwWGKN1FItvrHLri+St3ut18/J0dw0lFZcTnFnDrSyCiyfaxnvRL7fXpUhDd97FhR2EJiEGs7XUBVDGW9LSKP/ex6VolMtyESSUTIVaYHXPhP2zfhDk9yOjDWq+2ju+lnznlmbEf3mWET3803dWwG+agki7KkelunvKaZ+dCgkDbuu+zrhpXrwbFLapKMQ/mIRuJz5roWo3+PM8aoKO13d7IhNCYRaxu/LavtgC16WB9/WbNASC2e0cLsuzi4vwbimUyYi6eUxk4jhXYD7+aCF0lbdCRaHCEk+7Ff3DITFXqoX7doqX/tRfvGDt9PUN6RJGvTPhjr8ylW7NxNbILu5iQKduaAKQj4jQJ4p1SVpXC74fqazyEI5/DqVSyYX6thHmQ+zcOthq2l50XNixmiLSG9aW7wfc/nukkn2UsFsHzGy5ch53Wzk7jxkKIsHmy160uDMt9eUqAjy305xbJ3NgsXE/vWzN4/Yt34Fq8jTKCWdnAIOussVn8+raTLH1kYVDn9GVsyeP
 +2loU87F
 DrfSgH5nHlOhjLJTpqARF7yqcTyNP7frRJstqpsn3El66X7cTp7BDT/3eEwjHD9iEwlma80k3b4jb7UHgM1hoO8wHwWMX3SGq/sGhsvk6BqpGDFUU8v1joo+Y+92YqlqiET8AS+ATH9Y8/Juit/teyDu7Oqf6SiZJRdq+hZNbkKc+XLhSWYb9kL+qx1NxGbfMoJC7Y9GrAqJvr6GZ+nifhhngXnOpl7S5O8tYOXqwvfbRjlGn4/cADHCO/FddGq1u2uubC44UTnELhGXmc4+xC24s+T9AwWN2YYMbi0rzhu8nAoOCXhqkKaWiiqRNUCJ7e4ouiY6/BSQv/r61aOtz8bmerPEylUo3kZQMV6v4wYp1aUL6HZXmCRhVxbZ+14uTrqqPQN3kw72JILKIIJTvmQfGn5KxeV4gjXaGkh3OvRN5qE1sOvRLvqlr7MM5Zn+Av5d/SNqY6y/jOLddbMn0knC9rYpyvhSzhAb3+ajsqDG9Qx8uANnynbEdG2mnrCkjRDUJpLlBz3vN9YKhpJ620iQ4++9M7LEaovGU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
index 777fa3dbf88d6..9eeaefe5a1839 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -767,26 +767,39 @@ static inline bool is_smt_on(void)
 
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
2.56.0.rc1.315.gc6ed9934b7-goog



