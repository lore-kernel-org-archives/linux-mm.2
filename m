Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 434D1C9832A
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 00:51:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C02E6B00A4; Fri, 25 Sep 2026 20:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F7F16B009D; Fri, 25 Sep 2026 20:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C0826B00A7; Fri, 25 Sep 2026 20:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 073956B009D
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:50:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 994651C281F
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:57 +0000 (UTC)
X-FDA: 85254083754.04.8408BA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id A09B340002
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oLVH+G3k;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790383855;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KcvPzeDWw3J+blXFQL5GGoQ0SHASC9QaPWtBXxcesi0=;
	b=OorO1LJAGVlpIbccq1lK9Ga8XfAZuTdZ8FwK9I+0t6OTZgwpaHIK14axNWkKq8knzqekTH
	Qsvjc42yT1g56jh1Vy/3XYo9mI1esqBiDL5wu1IRlsjqRZwi3ZZ1h82VCr0Fjjjmh0v8PR
	w2TS17CexBqR5tZssyxJanQ8L0s/1RM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790383855;
	b=0hzWxyIBD1csUT2rJKhBTRodGlqoDhc5a65sSYoobW0shdYf4wlkuW6FvCMERP9oNVgklh
	/5Ixq/WFic+dmI+acRMcBg3eUDT8FXTiIJlzNv4R+WJJ0RtBDt5+y7QvtVU2owRwsgyL0N
	ZoxGMo/F88g0jDvHvAgskF4dljwTbMw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oLVH+G3k;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D690447EF;
	Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24009C2BD05;
	Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790383852;
	bh=vDEkazdRLF4novShMyP5tuhmgMvX29p9/UO9KqWcgPw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=oLVH+G3kOdTztlkvAcQ11NjWqYDFfKVrZ1QupyfZfNo3deil4Ey0uOqy9cpb2y/vF
	 Xv4R1Ms+zaRGy/VYvAzoD3ySTt7RGa6X8ZGdwUdhUsYiRYjziZcOXR14t40sCLkmbJ
	 WJJPYRuwyc0fkpAQpKPJs34awU0X19xg0aI8Liu6+zuEILNHnGtQq42Zw5OTCIJAaL
	 UFeLMAooIa8BuYYGK/EYPkD31rV5TfKI+Ia5JrrKYI643Rz7D7wgPXAqRmQpY3tMRX
	 SIR3x7hRvKtGHCzT288kI7gDeRVW9uWG0dPUpB3PM6+ZpMD542Q/UEHiZOiwQVD5Dp
	 YhQmvVytPl7cQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C515C9832A;
	Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 25 Sep 2026 17:50:59 -0700
Subject: [PATCH RFC 12/17] KVM: selftests: Test guest_memfd with mounted
 tmpfs root directory
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-gmem-tmpfs-backend-v1-12-d36159822d18@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790383850; l=7758;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=I2qZYT+hdR9asssZySkypzr+BY173budj+AtlVNc+WY=;
 b=4/VFnb+9s+yMlUcYP3RlcOKI9CoI44IGLvMZ9TOrzcZL5l3AvKLpTfTxSoQJqrZvDZH53/7xc
 1NdnFokQecUCT4JzQmqjmtlO9cMXSiBhIGbWZLyXfeo1J5GdVqZAuGI
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Stat-Signature: masgejio3whtdf5bi8ciobx1cpkpewy3
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A09B340002
X-HE-Tag: 1790383855-799525
X-HE-Meta: U2FsdGVkX187wQw5wgNXcxVvaiP91uO1uV+Wl7wxx3Lk/9/XwxXBawMzQUbTTzX2sReh/9DJUE96Z8rMFox4F84MRJDISAcnxWeYcN70oGpgkc8/+COxdWjLPlGmn+fYfjnbq1zvCdUmjL5VxsN5djnlR4IcsV5CffRMUmydg6YxVbiVflt/EGq2V1wJNCyRj97rRaTnyGWq+RLXBPE5eoUFwVHRFplATUjiEJBg5Ru4fEa6gNeS9gY7xEkurMI+v6kFfaF3WasL84w0TDJdOm7cHwwH+gTaHZis3Z0aRbqkb8AFVUDW1ENWD+70bKz6KwF16HxTSLfqjFWwlye85uJBcQb4Y6ISpibYPqumYNFr67Iz8n2k0GtGtUHu1fYwoIedPZaaFgK60lsnTorF75Z8HbrYQt3CmqtlvCz1ue7AtfV6rLKFY4eLFra59RDhKxTKO7O6lEMn1JCZPzZe2StMh5GL3zgU98ym6N0yh5t9I0VCo6Ag2kKafLPsSKgiH7smQCrzPm/ldKjrRgcckuo5HCq+T1lpFgbmZji4feWFrSD4qhVaPYABuKJxJrUO8DUqJ8GPGr3GNfQLOtGFFtYmtU6+Psf3eld9uxuS498uC5Hv2h3xpMIHJRRCd3xwii2R7GWSQT3qKbxVfSjEAZB7gAwqUVduKRdzVnmPanmWqIPLpVLyyi+iTS2H09oFO+Rp8g7diz8y0MoYPQPYJQoqbfCE0X59DsYM6AR/tBHvmNcIoBIF5UbTcJoHMH+lToBdQCFGhB/aiqtfkCC68TH0xU29+wlVKbR6ohQsIiVSxRbPDNXiX3/GB4K3yZ6x/X70+xDLrL5m6hvvO1fwDJSapJD6nOAcWX84bAmIMM0O96HltvpB3DC1SETw8bLNKS0AWsqRDHXCh0PgAF4rHcCNklIF8fAS5Mpmjx/2KXHwTxrB6JplvEQKBrPJ8F/NtbRKMiE4d3V6ZnWBkXm
 1zerkjb5
 dKyL3opG6Y34dZW3/igDYFMaMfqINI57oeL5uqYF7hCx2LPm+sAIbZOvrdVtflXkwQO8VOGysnjjRmm7mJA44jFOrxTACF668coUnJCVP+NB7Tjm8OAac9veUQLTHwx763LhrXZdD630NfUvXM5dVt2AsxxAH4QQjVtxrDEdROBVgy3hz1Si9ltO2fTjj64dNlvGvHvRLxCF6MNMwokicdfX1bw8YGHP6rkk037CSsiY8jjcX0MBB/Lhs8X5rhkeGqULsYtda39ZQyRQKmuJfwp94dWnNY8gtJPjFcQrpunJ8ck6LpFvGo8ddaeKK2QbJZX8zoeJ+zxVy7YCJgibU56tZvejIi+skXy2JfdD79pKxfP3/9ZJ5bPUo8kLIVBUUiHY9jPpytX3c9/KjlvaknyeCz80CknfhD+yMAdnVyhk/YI8Ok2e3H4//Oz8FjKNyorS5V29yp/Sh97uTHmq8oyJjAQ8mtOzqwLIfHYPkLER7ROMRcUdV25R8sdGyzJbtToY1xyN+mPW16bSZKyvO/zGbo4lM9IRpe+AA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Add test coverage verifying that opening the root directory of an
existing mounted tmpfs filesystem and passing that file descriptor as
the resource pool succeeds across all guest_memfd subtests and flag
combinations.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 137 +++++++++++++++++++------
 1 file changed, 103 insertions(+), 34 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 73212d5307049..94ef64474f2a0 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -10,11 +10,13 @@
 #include <errno.h>
 #include <stdio.h>
 #include <fcntl.h>
+#include <limits.h>
 
 #include <linux/bitmap.h>
 #include <linux/falloc.h>
 #include <linux/mount.h>
 #include <linux/sizes.h>
+#include <sys/mount.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 
@@ -541,66 +543,122 @@ static void test_resource_fd_tmpfs_huge(struct kvm_vm *vm)
 	close(pool_fd);
 }
 
-#define ____gmem_test(__test, __vm, __flags, __gmem_size, args...)		\
+enum gmem_pool_type {
+	GMEM_POOL_NONE,
+	GMEM_POOL_FSMOUNT,
+	GMEM_POOL_MOUNTED_DIR,
+};
+
+struct gmem_pool {
+	int fd;
+	char path[PATH_MAX];
+	bool is_mounted;
+};
+
+static struct gmem_pool create_gmem_pool(size_t size, enum gmem_pool_type type)
+{
+	struct gmem_pool pool = { .fd = -1, .is_mounted = false };
+	int mnt_fd;
+
+	if (type == GMEM_POOL_NONE)
+		return pool;
+
+	mnt_fd = create_tmpfs_pool_fd("never", true, size);
+	TEST_REQUIRE(mnt_fd >= 0);
+
+	if (type == GMEM_POOL_FSMOUNT) {
+		pool.fd = mnt_fd;
+		return pool;
+	}
+
+	strcpy(pool.path, "/tmp/gmem_test_dir_XXXXXX");
+	TEST_ASSERT(mkdtemp(pool.path), "mkdtemp failed");
+
+	if (syscall(__NR_move_mount, mnt_fd, "", AT_FDCWD, pool.path,
+		    MOVE_MOUNT_F_EMPTY_PATH)) {
+		close(mnt_fd);
+		rmdir(pool.path);
+		TEST_REQUIRE(false);
+	}
+	close(mnt_fd);
+
+	pool.fd = open(pool.path, O_RDONLY | O_DIRECTORY);
+	TEST_ASSERT(pool.fd >= 0, "open mounted tmpfs root failed");
+	pool.is_mounted = true;
+
+	return pool;
+}
+
+static void destroy_gmem_pool(struct gmem_pool *pool)
+{
+	if (pool->fd >= 0)
+		close(pool->fd);
+	if (pool->is_mounted) {
+		TEST_ASSERT(!umount(pool->path), "umount failed");
+		TEST_ASSERT(!rmdir(pool->path), "rmdir failed");
+	}
+}
+
+#define ____gmem_test(__test, __vm, __flags, __pool_type, __gmem_size, args...)	\
 do {										\
-	int pool_fd = -1;							\
+	struct gmem_pool pool = { .fd = -1 };					\
 	int fd;									\
 										\
 	if ((__flags) & GUEST_MEMFD_FLAG_USE_RESOURCE) {			\
-		pool_fd = create_tmpfs_pool_fd("never", true, __gmem_size);	\
+		pool = create_gmem_pool(__gmem_size, __pool_type);		\
 		fd = vm_create_guest_memfd_resource(__vm, __gmem_size,		\
-						    __flags, pool_fd);		\
+						    __flags, pool.fd);		\
 	} else {								\
 		fd = vm_create_guest_memfd(__vm, __gmem_size, __flags);	\
 	}									\
 										\
 	test_##__test(args);							\
 	close(fd);								\
-	if (pool_fd >= 0)							\
-		close(pool_fd);							\
+	destroy_gmem_pool(&pool);						\
 } while (0)
 
-#define __gmem_test(__test, __vm, __flags, __gmem_size)			\
-	____gmem_test(__test, __vm, __flags, __gmem_size, fd, __gmem_size)
+#define __gmem_test(__test, __vm, __flags, __pool_type, __gmem_size)		\
+	____gmem_test(__test, __vm, __flags, __pool_type, __gmem_size, fd, __gmem_size)
 
-#define gmem_test(__test, __vm, __flags)				\
-	__gmem_test(__test, __vm, __flags, page_size * 4)
+#define gmem_test(__test, __vm, __flags, __pool_type)				\
+	__gmem_test(__test, __vm, __flags, __pool_type, page_size * 4)
 
-#define __gmem_test_vm(__test, __vm, __flags, __gmem_size)		\
-	____gmem_test(__test, __vm, __flags, __gmem_size, __vm, fd, __gmem_size)
+#define __gmem_test_vm(__test, __vm, __flags, __pool_type, __gmem_size)	\
+	____gmem_test(__test, __vm, __flags, __pool_type, __gmem_size, __vm, fd, __gmem_size)
 
-#define gmem_test_vm(__test, __vm, __flags)				\
-	__gmem_test_vm(__test, __vm, __flags, page_size * 4)
+#define gmem_test_vm(__test, __vm, __flags, __pool_type)			\
+	__gmem_test_vm(__test, __vm, __flags, __pool_type, page_size * 4)
 
-static void __test_guest_memfd(struct kvm_vm *vm, u64 flags)
+static void __test_guest_memfd(struct kvm_vm *vm, u64 flags,
+			       enum gmem_pool_type pool_type)
 {
 	test_create_guest_memfd_multiple(vm);
 	test_create_guest_memfd_invalid_sizes(vm, flags);
 
-	gmem_test(file_read_write, vm, flags);
+	gmem_test(file_read_write, vm, flags, pool_type);
 
 	if (flags & GUEST_MEMFD_FLAG_MMAP) {
 		if (flags & GUEST_MEMFD_FLAG_INIT_SHARED) {
 			size_t pmd_size = get_trans_hugepagesz();
 
-			gmem_test(mmap_supported, vm, flags);
-			gmem_test(fault_overflow, vm, flags);
-			gmem_test(numa_allocation, vm, flags);
-			__gmem_test(collapse, vm, flags, pmd_size);
+			gmem_test(mmap_supported, vm, flags, pool_type);
+			gmem_test(fault_overflow, vm, flags, pool_type);
+			gmem_test(numa_allocation, vm, flags, pool_type);
+			__gmem_test(collapse, vm, flags, pool_type, pmd_size);
 		} else {
-			gmem_test(fault_private, vm, flags);
+			gmem_test(fault_private, vm, flags, pool_type);
 		}
 
-		gmem_test(mmap_cow, vm, flags);
-		gmem_test(mbind, vm, flags);
+		gmem_test(mmap_cow, vm, flags, pool_type);
+		gmem_test(mbind, vm, flags, pool_type);
 	} else {
-		gmem_test(mmap_not_supported, vm, flags);
+		gmem_test(mmap_not_supported, vm, flags, pool_type);
 	}
 
-	gmem_test(file_size, vm, flags);
-	gmem_test(fallocate, vm, flags);
-	gmem_test(invalid_punch_hole, vm, flags);
-	gmem_test_vm(invalid_binding, vm, flags);
+	gmem_test(file_size, vm, flags, pool_type);
+	gmem_test(fallocate, vm, flags, pool_type);
+	gmem_test(invalid_punch_hole, vm, flags, pool_type);
+	gmem_test_vm(invalid_binding, vm, flags, pool_type);
 }
 
 static void test_guest_memfd(unsigned long vm_type)
@@ -616,23 +674,34 @@ static void test_guest_memfd(unsigned long vm_type)
 	test_resource_fd_tmpfs_swap(vm);
 	test_resource_fd_tmpfs_huge(vm);
 
-	__test_guest_memfd(vm, 0);
-	__test_guest_memfd(vm, GUEST_MEMFD_FLAG_USE_RESOURCE);
+	__test_guest_memfd(vm, 0, GMEM_POOL_NONE);
+	__test_guest_memfd(vm, GUEST_MEMFD_FLAG_USE_RESOURCE, GMEM_POOL_FSMOUNT);
+	__test_guest_memfd(vm, GUEST_MEMFD_FLAG_USE_RESOURCE, GMEM_POOL_MOUNTED_DIR);
 
 	flags = vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS);
 	if (flags & GUEST_MEMFD_FLAG_MMAP) {
-		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP);
+		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP, GMEM_POOL_NONE);
+		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP |
+				       GUEST_MEMFD_FLAG_USE_RESOURCE,
+				   GMEM_POOL_FSMOUNT);
 		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP |
-				       GUEST_MEMFD_FLAG_USE_RESOURCE);
+				       GUEST_MEMFD_FLAG_USE_RESOURCE,
+				   GMEM_POOL_MOUNTED_DIR);
 	}
 
 	/* MMAP should always be supported if INIT_SHARED is supported. */
 	if (flags & GUEST_MEMFD_FLAG_INIT_SHARED) {
 		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP |
-				       GUEST_MEMFD_FLAG_INIT_SHARED);
+				       GUEST_MEMFD_FLAG_INIT_SHARED,
+				   GMEM_POOL_NONE);
+		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP |
+				       GUEST_MEMFD_FLAG_INIT_SHARED |
+				       GUEST_MEMFD_FLAG_USE_RESOURCE,
+				   GMEM_POOL_FSMOUNT);
 		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP |
 				       GUEST_MEMFD_FLAG_INIT_SHARED |
-				       GUEST_MEMFD_FLAG_USE_RESOURCE);
+				       GUEST_MEMFD_FLAG_USE_RESOURCE,
+				   GMEM_POOL_MOUNTED_DIR);
 	}
 
 	kvm_vm_free(vm);

-- 
2.56.0.rc1.315.gc6ed9934b7-goog



