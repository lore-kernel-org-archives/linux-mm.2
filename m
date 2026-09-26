Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5CE6C9832A
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 00:51:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8AB06B009E; Fri, 25 Sep 2026 20:50:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C12F96B00A2; Fri, 25 Sep 2026 20:50:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8D086B00A0; Fri, 25 Sep 2026 20:50:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 74B5C6B0099
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:50:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 04E49160811
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:56 +0000 (UTC)
X-FDA: 85254083754.24.0B7E75D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0EE4880005
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZW4YcAr8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790383855;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=udtcUyWE1uSFW5Ldwkw5o6zimv2R2aYRb8MqWJMRgKE=;
	b=tUXkGI8KW5mtN3ZFKS3tTTzjqZa8Ocrd4qYZlB5pZ7so+xwkAuCcNo8QM1nseMYB2huXp6
	O02+mIRjKRv4lw58ClVYC7XEVJQ+xBfY7Wql+G64mmMNsixGs19to+yNU0GTGrUEQN4zI0
	zneJDDdWjMZA9UlUJU2nQJjwXXHFlPo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZW4YcAr8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790383855;
	b=AG/nTw73wahUGQGM57P7xEWn5pgLnuHC5EwQIVJkNEIbi5yKb+fbRIqnBhNlq4h+juSkuK
	o04pM4aTsvPG0cOuk36ukneoKJiznXtqQ8KVabszhK/HbdQPdb8sx2MtVaT8x7JEMzFbFZ
	b/q3n2sOdeh4L5JbY7dz2upTmz9Xg4g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D4CA447CF;
	Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D9A6CC2BCFD;
	Sat, 26 Sep 2026 00:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790383851;
	bh=liqnGaVxdQZUr+SxRatM6jYTFXLCR3vxDWNamKgblq8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ZW4YcAr8zEw6RprjXZNXegMg6fPKlJpw8XAr2KcCvJKDVNDelpLV72b9a6ZP1+P3e
	 2RDkg56kZ0PXG4m7HEWSbD0+vSMrd6Z3ddVRykS3xlJqGb+ZFzaPtfV77bqY8mGtZS
	 zp5PJkIL0EZUucw/9u7eFdonuism8eoWK33TgVlR6NOnYGZ37ezHaMUXtyfrbpEI1N
	 2fYv0i1TFE3f1Yqh6hNTD4KvZKhGv578rTeVbpAqrNEFZM7Z5ApZqBM1no28cL7nny
	 OJ8uD2fORW7YLwDKJGGR3KzHaASjN9egcObI3/t5SQ2c2+Zm4Z0jN49fohRtSZrgWY
	 TzqnL9eysI6HA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C76B0C9832A;
	Sat, 26 Sep 2026 00:50:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 25 Sep 2026 17:50:56 -0700
Subject: [PATCH RFC 09/17] KVM: selftests: Test rejection of swap tmpfs
 mounts
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-gmem-tmpfs-backend-v1-9-d36159822d18@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790383850; l=2877;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=5xkNo+br1h4L99FBlpcbpIchm5gYtDbafhYivlve/RE=;
 b=Yf0MTimFpeP1F0O9CabGUA5VbTmVvRQvNwWt9G2lt6epCRofDg+tFnu1TRfsb8Q00G+NQPfQ2
 LYbxro03D5JCDwPzJ9nW2zl6/2PFMe9fGlCcRtB9BWU+1IAXEAkqVxq
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: dug36gpcknkwgqdkqmtcoafu98d98c8g
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0EE4880005
X-HE-Tag: 1790383854-218333
X-HE-Meta: U2FsdGVkX188iuiXqqja1VrLv4X4ToZb8wjo81O7weKWlt90cfIkFMis1wy0joWoexq1pzdDwqRobxu4ppupBoXujEZKs03yG4tN/0OSfQW5cz7hR26hFtlucU2nUDQUx8jCF13h2TWKvab1ZRh7LSAA0G0ZyULFof1jUR7jBt9PqdLPLg84KDSpsFD387XsKm7Wrod7ZcuYLaerL6DK8608De3lt0+CZNs/hfYjbX/UgkpdzH0S3e6CSSmb2NeYc12mBuOn+gfRSVmE7eMnff0Tv/eio/4BVOGeorSOVpyRp5lnNyJFWNqNJW8xgOrD7NeRpU1UoqWCvrelPcfR2OqH4CNOx4BoGBj6oEp69ws/uX8HvSS78e8o7DiAu4V4msltK/n/zdI/gcfygCLoyP6ZS3r/+aw7d6UEmPoHh0V9hS1nMK8Y/tDYtQOJ2s4EnyiOLglRKnJT1dsrbwEpMEI9kXEQHtVLgKtG4p0e5cO2XL771c3rV0+zb+5gOw5L8s2w+Qug5rnuXuxz0+ND4iulocVI9VwKiuB9SuS5Oo2ZqRoQ8ijvAFTJurgWdmEa4pj3sbnk6RTLXDM+jDq0uWBLgKy9h6KILTO5YNObveUHe9MhHNe3r5e/hgA27d9fakOVS4gsujJYNLveIjBMtMs4StPF6d4t+tzChLTZnlSrmvtr/pCF28D7emcTKCTjEc3sUIRpnVHkaHDcyICm/hq4oiKSCC8ZPx1ACLFaKznqrdJ3E14NZIB4Pax50xWIX+Z1I5DZnFcGDfW/OLR3vRzrQgxe8KCFN65MXCwDZ55k2HxYUeUrftL2IwpfVTFGbo7JA7Zz8dXOIKJIzDvNE6bW13jfkDsdmRP6cnPXDryD2OctxuY2kZXUk+C9bJSEupoKmkY/X2oZsrOgCPfKaqu1dcnvMx/I8S0UnRK3xsaBPtNjj+by2wpCvHRJJcHvh08N1WujFHH3LgQdMGV
 rBWevHZ6
 O4ap6JX4C38av5UUap0ZLbeaMwmWdFyTYeXhHqvez4aaKfmYTOn+D0VuOLROYcLDu4cEOFiH2H2wLjk7eMnlP2zpvC4l83qAimrSa6RlwW2L6pJyHqV05jadxcQB6tj481GVas1Culnog7U6chWDqtvQZDT2j0le/1sRhFX/JZUy98fxgGfhQsJmBsATRZ5hKzBjybbjgqSRmwXwN43lpO8LxhlxM91T2fKScNmgSUJp8V9RscrymzevfdyPYqJC5pPswTEjMRtSL9hom2viSCI8oHDUVpD5S9JQGae6olxYyD41Ea42JhX69WHTaEsAKQtVmjW3ro1pX7oV8/lcrPhhX0vdHWqMTmcPu6rXSmQLTFdVe02cOoMvKVhdgi6fnBwCnqK4zGa73UgEB8pmvAi06OZfMaVsK11UjnDwXzfkOkwc2ijONHnbvhkH0iYuQ75+RQmUWI8rhj2+fvE+8xgEjdJYN2aS2MrCvwUxYJnN+Ti4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Ensure that guest_memfd creation fails with -EINVAL when passed a tmpfs
resource pool mount descriptor that has swap enabled, as required by
the tmpfs guest_memfd provider implementation.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 50 ++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index a7a1b5470cb2c..5d017164d7b45 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -13,6 +13,7 @@
 
 #include <linux/bitmap.h>
 #include <linux/falloc.h>
+#include <linux/mount.h>
 #include <linux/sizes.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -477,6 +478,54 @@ static void test_resource_fd_tmpfs_file(struct kvm_vm *vm)
 	close(file_fd);
 }
 
+static int create_tmpfs_pool_fd(const char *huge, bool noswap, size_t size)
+{
+	char size_str[32];
+	int fs_fd, mnt_fd;
+
+	TEST_ASSERT(size && IS_ALIGNED(size, page_size),
+		    "Pool size '0x%zx' must be positive and page-aligned", size);
+
+	fs_fd = syscall(__NR_fsopen, "tmpfs", FSOPEN_CLOEXEC);
+	TEST_ASSERT(fs_fd >= 0, "fsopen failed");
+
+	if (noswap)
+		TEST_ASSERT(!syscall(__NR_fsconfig, fs_fd, FSCONFIG_SET_FLAG,
+				     "noswap", NULL, 0), "fsconfig noswap failed");
+
+	if (huge)
+		TEST_ASSERT(!syscall(__NR_fsconfig, fs_fd, FSCONFIG_SET_STRING,
+				     "huge", huge, 0), "fsconfig huge failed");
+
+	snprintf(size_str, sizeof(size_str), "%zu", size);
+	TEST_ASSERT(!syscall(__NR_fsconfig, fs_fd, FSCONFIG_SET_STRING,
+			     "size", size_str, 0), "fsconfig size failed");
+
+	TEST_ASSERT(!syscall(__NR_fsconfig, fs_fd, FSCONFIG_CMD_CREATE,
+			     NULL, NULL, 0), "fsconfig create failed");
+
+	mnt_fd = syscall(__NR_fsmount, fs_fd, FSMOUNT_CLOEXEC, 0);
+	TEST_ASSERT(mnt_fd > 0, "fsmount failed");
+
+	close(fs_fd);
+	return mnt_fd;
+}
+
+static void test_resource_fd_tmpfs_swap(struct kvm_vm *vm)
+{
+	int pool_fd, fd;
+
+	pool_fd = create_tmpfs_pool_fd("never", false, page_size);
+
+	fd = __vm_create_guest_memfd_resource(vm, page_size,
+					      GUEST_MEMFD_FLAG_USE_RESOURCE,
+					      pool_fd);
+	TEST_ASSERT(fd < 0, "guest_memfd with swap-enabled tmpfs should fail");
+	TEST_ASSERT_EQ(errno, EINVAL);
+
+	close(pool_fd);
+}
+
 #define ____gmem_test(__test, __vm, __flags, __gmem_size, args...)	\
 do {									\
 	int fd = vm_create_guest_memfd(__vm, __gmem_size, __flags);	\
@@ -538,6 +587,7 @@ static void test_guest_memfd(unsigned long vm_type)
 	test_resource_fd_invalid(vm);
 	test_resource_fd_unsupported_fs(vm);
 	test_resource_fd_tmpfs_file(vm);
+	test_resource_fd_tmpfs_swap(vm);
 
 	__test_guest_memfd(vm, 0);
 

-- 
2.56.0.rc1.315.gc6ed9934b7-goog



