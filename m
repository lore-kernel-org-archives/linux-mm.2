Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 132B3C9830E
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 00:51:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03E7A6B0099; Fri, 25 Sep 2026 20:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 004906B00A2; Fri, 25 Sep 2026 20:50:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C89C46B0099; Fri, 25 Sep 2026 20:50:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C53E6B009E
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:50:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0CBF38079B
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:57 +0000 (UTC)
X-FDA: 85254083754.26.6AF9348
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 138ED140004
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CIQ2+pr1;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790383855;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QfqfTRd9NErw2mh0hLzsBXn3eIE6lSnygb1VZDck+lc=;
	b=Wa1EfMAkLmAGPIHapjjnAz74dD0h+8bfg8bZazm8jwV2ioOwtkryubNteE+qzldEUE8qF2
	UaPMgD92cAKImeHpWPR2pXqZN72NO5E5VuHH7ZKMkZqSaSw7kGpvCewS4qxhseF9PoQI8p
	8yedrJkknB34dPUMOfAMfK8/SGavu5o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CIQ2+pr1;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790383855;
	b=4GQN6Yi39POEs2lMRtCzSCg49fpJhXFLJeAilGPToPX/HxpI6fvmRe5maUUbU+K9LkiMQP
	e+AgiDnxetczFfUODxNlFLY2nEb6n1Rwloc5vvJVyuD879TjzDmSLczgEBAxnSqb/o2uxU
	CS5u8bK+zZsnnM9zWUBNdFtnYDqsK40=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 35E0B447DF;
	Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0BB5FC4AF13;
	Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790383852;
	bh=clzJl7tat7edqHdDSmDO0zl3L0rUROd5Ujs5P0wIAzk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=CIQ2+pr1/IFy1J/Cqj4xAxFux/GIa20NPau6WtfoEaI34fPTFtJyPnFqcyYL8ObnE
	 TnWxKE2Hxw4sMDJYa/Ckq8gdthUDuYAw4r/VWKJxWi3CukaUmmdTgcCZpMSbjXVqY1
	 78h3b85NmurNGGPwHvKk+MycCnRDgDghOBaopcuAa0L88dcwRrMyBUXW4o/WicUnZw
	 uFI29kJeWFuq9nEtT/e3CLso0y1kXapkhMeM3H9qMfcamQ2J3l/ZfP8NkNEPd5Cu7F
	 FfPUS3t3uwyGhHGoFlWbJ9ON7yN/XIyViunsF+WGWlGYCWBeelYKtx/7sNeHfKq8HV
	 Y4rwL8EOMdA0Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB871C98331;
	Sat, 26 Sep 2026 00:50:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 25 Sep 2026 17:50:58 -0700
Subject: [PATCH RFC 11/17] KVM: selftests: Test guest_memfd with anonymous
 fsmount() tmpfs pool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-gmem-tmpfs-backend-v1-11-d36159822d18@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790383850; l=2594;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Si9JGry309vjF8hKL0mCR4ckxqZZ+FxcLQB0xL3xoag=;
 b=PyIIYTVR6N2jUy7YaNCs+XJW/WTb8muHJXoGFl1QAit/5T4X7y8M5Oq8R5MHlWF7Xs+QkWAos
 p6iAVxid4mbCy3dVT3rzd/VcyoiQCU2KkivZkLfKJ9j/KwsTlzd0Lpd
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 138ED140004
X-Stat-Signature: pgibn1j8c8tc7wdx91wzy4oj7sntaj8w
X-HE-Tag: 1790383854-332399
X-HE-Meta: U2FsdGVkX18ioyUX19AvbUHSziB9doFP0dgN3zQnFlLkOmQA/gA7bo6T08/vsiXpS7CiOD8QxUyZSyjFkr6Nou7xCPKmUoU6d7iuPHGiPpYuX8bYCmQQfTiW5o9DdVKbO+y8usQU8k9I3FItH9kf1/SGZQLxN5X0vfoW4T4JSCycieFj+RS4MjdW/zFYMtcLoSeFKMi0q980tHc030M20bAvaen5wZR/hqWlguI+LDXK3bCJEQ2mVbJ3MArOXoqgGaAoQGXkbPxWUE3joOcZbzqZXDYSqN/1ZnUkrkH9AqMPquEElr9NiTK45m/dU1xezAtmiRYYOlplJ9GPiV5xQys1CpD6VvWFf9hEbEhqTuZsU8aMUAbOQpLl2YXVqcfrMuV4a8ivsGNlOctZLySh5lF7lTbnySSu5wyzKabZvjxkdcvGRoA3SoY9zoAPIt8TGd9EWUMNoZlsi6APJpas/xK6/IQWzD9CCyqdnj+GWRK5MxW1pjQW9BRCseofZIqbq5c54oIWOhUQaA14BLRK03e51PRWGhygkETKXw/tFzkB6USsPkcf0CYvMd8AbT5lmu5PauksOPAFr4fg+OcQxWEc4u8PhP9UJWQgJ5+yFStAIIzrvwBxaqwKiXazjntBHfU9EiJRDCp5WUeaFCEWTF+Q5e9HxdIFVPC/RMjR2hjWCf1kvAumJRN+n3rTtcJKeIYEjYkhgB51+Cq/oaMaJ8DHOcJTs/bGEPYsIHGSEVMud1LBZnpTqjhZ8xwnC/EZ2Xg1u4ifConIm6m5dBDv9JUDRrdjEY01roIfRNW1xE9nO5nazXCEjnG9BEIGU8IJc49E4vuc1LbeG+K3mPLPwbs+wwqprQIs62HyD9kemgP8BAB6hO0tP6pUxcO7g/mFvIoKwC+VvlSBVfrCH0noIMCQrxQ4PW3B4Qfn4apgm1sQJPFBiAY5wtBRCWmJYF1hSJ+S2eLFjVryWXIs1Gp
 nO9Fnkct
 QlJ7qVxuOKpDOV2BiSke0V+e/kFQnHSC8h8A9N63CDSVky4oumS0HQvDeuiz5tNe1f7VY7E9SqpUmJeFeGoDiODi+/F4zeq+SxNvXg3kOrSLahs1lYYoxLDbkMboaJkLC86KwG2PWYrJKb5mH0VZGQP4C88JTsyYc8MjZcJiXc4H7ezbRrrwLl5lx8mPlp1ziZkqEAQ39zDvdpqPD2uaH+FUqVEbOBwCrMajc/bBc5PSmoFVi8mEhsiei9u8tIK+7eMoS02KuTifLP5j3iXGyNAv+EnpuHZto207WZImQKTY4h1ygVGv7aIDkImBEt+Kw+V5U9H1kk0DyOi07bcilQ3xy2ovpZ3WZ10rMMwS3yAz7uVwBfMGOZ1TU5th9QDQh/GZbFiOyUq5lmwnW42kvNr50YNXz7rNDochKPEGcyeb8ZsNv3uUpmr5DJ6ONbRGr4mXXOQLuTNXa7Ul7QsjaonwcHi4g7ZIPfO8m2Qgbwiie3Bf/Zxn8vfWPopXHBKVJ4lmS9+TMiehH/ffdmnwKtGmGmkFKB0qDUluB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Add test coverage verifying that creating a guest_memfd backed by an
anonymous tmpfs mount descriptor returned by fsmount() succeeds and
reports the requested file size.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 35 ++++++++++++++++++++------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index e8199ed17b0f8..73212d5307049 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -541,12 +541,23 @@ static void test_resource_fd_tmpfs_huge(struct kvm_vm *vm)
 	close(pool_fd);
 }
 
-#define ____gmem_test(__test, __vm, __flags, __gmem_size, args...)	\
-do {									\
-	int fd = vm_create_guest_memfd(__vm, __gmem_size, __flags);	\
-									\
-	test_##__test(args);						\
-	close(fd);							\
+#define ____gmem_test(__test, __vm, __flags, __gmem_size, args...)		\
+do {										\
+	int pool_fd = -1;							\
+	int fd;									\
+										\
+	if ((__flags) & GUEST_MEMFD_FLAG_USE_RESOURCE) {			\
+		pool_fd = create_tmpfs_pool_fd("never", true, __gmem_size);	\
+		fd = vm_create_guest_memfd_resource(__vm, __gmem_size,		\
+						    __flags, pool_fd);		\
+	} else {								\
+		fd = vm_create_guest_memfd(__vm, __gmem_size, __flags);	\
+	}									\
+										\
+	test_##__test(args);							\
+	close(fd);								\
+	if (pool_fd >= 0)							\
+		close(pool_fd);							\
 } while (0)
 
 #define __gmem_test(__test, __vm, __flags, __gmem_size)			\
@@ -606,15 +617,23 @@ static void test_guest_memfd(unsigned long vm_type)
 	test_resource_fd_tmpfs_huge(vm);
 
 	__test_guest_memfd(vm, 0);
+	__test_guest_memfd(vm, GUEST_MEMFD_FLAG_USE_RESOURCE);
 
 	flags = vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS);
-	if (flags & GUEST_MEMFD_FLAG_MMAP)
+	if (flags & GUEST_MEMFD_FLAG_MMAP) {
 		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP);
+		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP |
+				       GUEST_MEMFD_FLAG_USE_RESOURCE);
+	}
 
 	/* MMAP should always be supported if INIT_SHARED is supported. */
-	if (flags & GUEST_MEMFD_FLAG_INIT_SHARED)
+	if (flags & GUEST_MEMFD_FLAG_INIT_SHARED) {
 		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP |
 				       GUEST_MEMFD_FLAG_INIT_SHARED);
+		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP |
+				       GUEST_MEMFD_FLAG_INIT_SHARED |
+				       GUEST_MEMFD_FLAG_USE_RESOURCE);
+	}
 
 	kvm_vm_free(vm);
 }

-- 
2.56.0.rc1.315.gc6ed9934b7-goog



