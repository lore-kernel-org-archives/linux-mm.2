Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E70B606EEB7
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i80B1oKu
Received: by kanga.kvack.org (Postfix)
	id 3BC706B05C9; Fri,  6 Nov 2026 19:37:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33EB16B05CD; Fri,  6 Nov 2026 19:37:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22E4C6B05CE; Fri,  6 Nov 2026 19:37:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2C016B05C9
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:09 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 140DEA7AD0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:09 +0000 (UTC)
X-FDA: 85406458578.02.CFC057F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id DCF1080004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i80B1oKu;
	spf=pass (imf30.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011827;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b+jliTZNk7EWQSiCdak8u3SiAd9Jj0Xqxa/r2n/xqpM=;
	b=HWEqzLiIt0CRDa0O4GgfyCE2qLVvJ6OM0mNFronBqKijte9VNSvF/ln9qiAkOIPLm9DC4E
	kN5X18kIX0yi2bErzBQ7Ou8nQ3wvjPgfmrhgzn5ceJPP9DpBMZ172yvuycoJJjF31lNMRt
	BWFO/pvH7UFyfrW0F93PYmlDBV+W0Qw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011827;
	b=h5VgxdOAEj7Y8JnMTu4CRxoVdupwtzLBp1U/LAp+k2mXr2SeRRrPitE2RRYUYMNXGS3Pd3
	7ZL8EHzSANOCAeP0kemZeogceVK/zUmz3cIrKyjVEW1jRZLdPr2lU7vYGVdeJ/Ue3aYl4x
	lA4uptFsZGu00oNL2dcyT227TaD2+ys=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i80B1oKu;
	spf=pass (imf30.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 36A2444046;
	Sat,  7 Nov 2026 00:37:06 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011826;
	b=nNh2p2qPJ89sASLpv/yX9PhDo5lteAV+a1eNmnJA/431bGjBw6hP5v9QR1WCdDUFswWT
	 nmPkGQZSjiOdwtkadbmic09swx7moAYX9PgjvzKSh9TQDBCfgipr0gNsuud/wrK5ozsrL
	 cR8CD14FYRyi1nQprhgbwRDeUC2aeGw/DLMxGOmVV5VxLg23YI53w5ZjxYXgtPviR+l+F
	 7pCUC8PSaO6NRKIDPfr89eEeYdlZX+dGArwAnpdx6wpjEIi4le0uUrYxPGfTx4T0xPUUj
	 TyMdREFDZQXUa3hAAE7H7ArqaEpUnz9q7j6o+mdIxIho0JjJC01Y0OFfnW/4YwQBVYw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011826;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=b+jliTZNk7EWQSiCdak8u3SiAd9Jj0Xqxa/r2n/xqpM=;
	b=xnpwHd/MZPx1FeeeLTe+qFriLmdSYyPXxucG5nnEnZ5ed1fQhqFMP78RfZDCH1m+eLnq
	 yBbdG+C+8j2AB0dhveJTsZ34H+3hvV1Wt8cjGaUbmcTh8bEZc8IBIDfdTYRm2+u4JEfCq
	 Oge8GoFXYzf2dbEwa5GqAFzgJQf62E8Iv4feJH+KBYx5x+FeY0BfT3Btr6ojkT3UqkCAd
	 gGec1Yjv9EeefgtNgzxWSTK54M5YngKHe/r+Y0V2oHuk+t2au6bGxT+jN8W93y8722mG1
	 4chyFD2lQpethi3sH9KRCFUQQToEwJ4AeKqYM06O63y/EZAtx+sqAiNZ/JUpe1JWRhw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 4A6631F008A5;
	Sat,  7 Nov 2026 00:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011826;
	bh=b+jliTZNk7EWQSiCdak8u3SiAd9Jj0Xqxa/r2n/xqpM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=i80B1oKu4K52Wlsn0OHvbdOvk1WheZttKNp13wd/ufzCuAVu0o7tpRYGuOK9/Mxlm
	 vkXV57lE1IIga1IZyBf9M8YiZWSb2FZpA9R6/yna43/Ber9h4J7odv003A/fQ++O/E
	 mIQ/k12NzKMpB2HsgmDm19zbmxePhUs5estGeWXSxRUE4w5ZMXTKcJlIhH5FJGTSYe
	 vDz6O1GU34kfo01nnOlxh2RcI71NTVXWS2bDwjTcC6pGKLBXLNmFX+80kDpTkye8Bj
	 yoTHciDo+yKBk0Q5OKOCV8nraoDMzw+cW0lu66cSgPI4cW6xRzwGW3xDWUDEC531a6
	 +tLew0Fk8YkKg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 475E74795F;
	Sat,  7 Nov 2026 00:36:54 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:36:53 -0800
Subject: [PATCH RFC v3 19/88] KVM: selftests: Test guest_memfd conversions
 with tmpfs backing
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-19-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=9639;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Ywv4Awh60QVQXfJ42x/j6i2G3l1UGcU6b4v8gcyWpig=;
 b=EDb+BOFfQuAMKC477YknSboSYEtvDUgYLwNAzDBtxOPsFifr+qxx1Kgb2Sjumi6KnTOEoFdoN
 NlP5Q12K2NNCUhaXa9Jue3uo1cBdclLvjJJyIG6fbL7MBuPn4X5T/9n
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DCF1080004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: stzgpd79bp9tyhyjmuifpa9y6zpmq5ki
X-Rspam-User: 
X-HE-Tag: 1794011826-656027
X-HE-Meta: U2FsdGVkX1+wju3Fq8E6tVImlBuayfuA3F3S2rQDVxaHxVqcU8POPeWbBMBSkebjhfaw799GYObPHsGJ9eMR+SZdXLzFXapTDCe6SZrXx7NYF/bZfLuhI+qpFwoj6Y58HCKhtAfi/GxKOtDZooH5fn/zi0Kzl3HP+5TIwDKHNLVNuvddzhtXBKGW7EBivDG1QKm+2EgnCDhq01IAHuDH9Sb4aUxo4O1QqwbdQKGK4SzqSf2Sr0mX2gJfr5hgTV2JOSLBxC4ah6zF0jSPfENQ3csBNCna5Pcjkwam6i0lA66sgxTH9O/sfGpB6yk5v5QvpvZy+rlOzX36QCD3JvMxQif6bjC3tVtW79hw3xIQEkxRs7gG3B8yFl2LgLTTIh7FsQuQzNIeipKvE2ZaTR+Ow8pnlrXokpP/NYNJsMq3fsMQG4mBs71M5TSAVd+RBKyZS6YGsx8UxN8yvdGe3ofq28L4FNAtDKstFOOlo2MOipUYDry9LQyBJ/U4F1spqqZjo/6JfZpb892Pd8qkoiViLcmt8y7jOtAFcJU/8Ts1EVfiIRY3b9MQE773Rzj1CNQDfqo5cJDmTZ8EOcqh/I8YXAYJ7iphgHt8VFYr71RKOwrzpptOTN+cTJliiwg+tG6ezHQHKFhDOtCJG/7w6prGbEARFiDKYBkLu0XqunSy6pNXCo3J6vG93cbvFX6i5rtu1vlQk+snew8hGi+REcAT5j0smU8iQOidVvvOS/HFOZ+NmmiWnT8rYxF3OAk/5+9lfFdpMerxUxQJpMb0yMZliN+eq2grC5rxFsNUa+18MXY5Im2yNrng7orUNO2Phu51Er0htuwi2kxkUMyWnVlEPP8NTJcbKxEoJjB9T750oKF4yKVb3IW6iyiU8sW85sXq+fP4Tr9dmJKerCHg5/t9XjHkmdqpftUqFjvaB09A8ljXRpetma3gJl6JIvMVNfI1aHfD6yscfdjGhoiIB5t
 bNu/3EzQ
 NnFktSDqYTcn6ELdfBI8nrMRA5cdcZWbV6kuh6YloEkrxSSwTy1se92FB/xoDtx4xr5of4bQa2Az+Q5hXJvstvoQWi6oQJrrf5qwu7d6kzZS3EJqH2bFdhBk66VFUpOct7cFOycosWt0EgFnB926TpuM5c7E96W3mSgfwpb1RIC5xKhiUExhgrw/nEfBtfgR6B48K3QR9QsiDPWCapesM4/ed5L8ex+AKw2kGeJzkuu4mZmGdsqg/rPlUyYQrvwvd5hHP1ryag0kT3RfAc1B97cUxZNe9vgpVBjDamCcU3Y9pwREBNTEX53GVy4Al7w4JTHe4Bn7jxUngdY7mOhvP74R4MDUVeTrfB6sNLAHulZlVy4iOeXMRfunOpiYSlQ3I/uriCRFbjzJZNcnh15iGTg5W+1OB3yjmgxFJplkD3QDjEjnydjqhg0OtERmwGQ+OTL/0QUCZA3K1iJpfjD3uHnhiv7I8651VltElp9j0eyxqWtnnpk+Gdmv3+cktIBsNBnXnXZyWlR9QWGNXdBzlEqiy7iodXdFlwWZLddSXXefCZ6TAZwWj5zbBScTqG2TQnM7TGKoqK8qVLqlmLU/t9z3/8W8cS7Y64bhnxITrlr8Kw3Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Move create_tmpfs_pool_fd() into lib/test_util.c and declare it in
include/test_util.h so it can be reused across selftests.

Extend guest_memfd_conversions_test using fixture variants to run all
conversion test cases against both native guest_memfd and tmpfs-backed
guest_memfd instances.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c     | 52 --------------------
 tools/testing/selftests/kvm/include/test_util.h    |  2 +
 tools/testing/selftests/kvm/lib/test_util.c        | 56 ++++++++++++++++++++++
 .../kvm/x86/guest_memfd_conversions_test.c         | 49 +++++++++++++++++--
 4 files changed, 102 insertions(+), 57 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index fd249445ce3cc..cbc2f309664b2 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -481,58 +481,6 @@ static void test_resource_fd_memfd(struct kvm_vm *vm)
 	close(file_fd);
 }
 
-static int create_tmpfs_pool_fd(const char *huge, bool noswap, size_t size)
-{
-	char size_str[32];
-	char template[] = "/tmp/gmem_test_dir_XXXXXX";
-	char *mount_dir;
-	int fs_fd, mnt_fd, dir_fd;
-
-	TEST_ASSERT(size && IS_ALIGNED(size, page_size),
-		    "Pool size '0x%zx' must be positive and page-aligned", size);
-
-	fs_fd = syscall(__NR_fsopen, "tmpfs", FSOPEN_CLOEXEC);
-	TEST_ASSERT(fs_fd >= 0, "fsopen failed");
-
-	if (noswap)
-		TEST_ASSERT(!syscall(__NR_fsconfig, fs_fd, FSCONFIG_SET_FLAG,
-				     "noswap", NULL, 0), "fsconfig noswap failed");
-
-	if (huge)
-		TEST_ASSERT(!syscall(__NR_fsconfig, fs_fd, FSCONFIG_SET_STRING,
-				     "huge", huge, 0), "fsconfig huge failed");
-
-	snprintf(size_str, sizeof(size_str), "%zu", size);
-	TEST_ASSERT(!syscall(__NR_fsconfig, fs_fd, FSCONFIG_SET_STRING,
-			     "size", size_str, 0), "fsconfig size failed");
-
-	TEST_ASSERT(!syscall(__NR_fsconfig, fs_fd, FSCONFIG_CMD_CREATE,
-			     NULL, NULL, 0), "fsconfig create failed");
-
-	mnt_fd = syscall(__NR_fsmount, fs_fd, FSMOUNT_CLOEXEC, 0);
-	TEST_ASSERT(mnt_fd > 0, "fsmount failed");
-	close(fs_fd);
-
-	mount_dir = mkdtemp(template);
-	TEST_ASSERT(mount_dir, "mkdtemp failed");
-
-	TEST_ASSERT(!syscall(__NR_move_mount, mnt_fd, "", AT_FDCWD, mount_dir,
-			     MOVE_MOUNT_F_EMPTY_PATH), "move_mount failed");
-	close(mnt_fd);
-
-	dir_fd = open(mount_dir, O_RDONLY | O_DIRECTORY | O_CLOEXEC);
-	TEST_ASSERT(dir_fd >= 0, "open tmpfs mount directory failed");
-
-	/*
-	 * Detach mount from namespace so removing mount_dir upon exit or
-	 * unmount doesn't conflict, while dir_fd retains the active mount.
-	 */
-	TEST_ASSERT(!umount2(mount_dir, MNT_DETACH), "umount2 failed");
-	TEST_ASSERT(!rmdir(mount_dir), "rmdir failed");
-
-	return dir_fd;
-}
-
 static void test_resource_fd_tmpfs_swap(struct kvm_vm *vm)
 {
 	int pool_fd, fd;
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index c80019e24b2d0..e6707534f1951 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -244,4 +244,6 @@ char *strdup_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2), n
 
 char *sys_get_cur_clocksource(void);
 
+int create_tmpfs_pool_fd(const char *huge, bool noswap, size_t size);
+
 #endif /* SELFTEST_KVM_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index f5f7189f96a84..c5b264f533ad0 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -10,10 +10,14 @@
 #include <ctype.h>
 #include <limits.h>
 #include <stdlib.h>
+#include <fcntl.h>
 #include <time.h>
+#include <sys/mount.h>
 #include <sys/stat.h>
 #include <sys/syscall.h>
+#include <linux/align.h>
 #include <linux/mman.h>
+#include <linux/mount.h>
 #include "linux/kernel.h"
 
 #include "test_util.h"
@@ -483,3 +487,55 @@ char *sys_get_cur_clocksource(void)
 
 	return clk_name;
 }
+
+int create_tmpfs_pool_fd(const char *huge, bool noswap, size_t size)
+{
+	char size_str[32];
+	char template[] = "/tmp/gmem_test_dir_XXXXXX";
+	char *mount_dir;
+	int fs_fd, mnt_fd, dir_fd;
+
+	TEST_ASSERT(size && IS_ALIGNED(size, getpagesize()),
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
+	close(fs_fd);
+
+	mount_dir = mkdtemp(template);
+	TEST_ASSERT(mount_dir, "mkdtemp failed");
+
+	TEST_ASSERT(!syscall(__NR_move_mount, mnt_fd, "", AT_FDCWD, mount_dir,
+			     MOVE_MOUNT_F_EMPTY_PATH), "move_mount failed");
+	close(mnt_fd);
+
+	dir_fd = open(mount_dir, O_RDONLY | O_DIRECTORY | O_CLOEXEC);
+	TEST_ASSERT(dir_fd >= 0, "open tmpfs mount directory failed");
+
+	/*
+	 * Detach mount from namespace so removing mount_dir upon exit or
+	 * unmount doesn't conflict, while dir_fd retains the active mount.
+	 */
+	TEST_ASSERT(!umount2(mount_dir, MNT_DETACH), "umount2 failed");
+	TEST_ASSERT(!rmdir(mount_dir), "rmdir failed");
+
+	return dir_fd;
+}
diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index e1c84df0f0596..023df9cb9d4a6 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -20,12 +20,30 @@
 FIXTURE(gmem_conversions) {
 	struct kvm_vcpu *vcpu;
 	int gmem_fd;
+	int resource_fd;
 	/* HVA of the first byte of the memory mmap()-ed from gmem_fd. */
 	char *mem;
 };
 
 typedef FIXTURE_DATA(gmem_conversions) test_data_t;
 
+FIXTURE_VARIANT(gmem_conversions) {
+	int (*create_resource)(size_t size);
+};
+
+FIXTURE_VARIANT_ADD(gmem_conversions, native) {
+	.create_resource = NULL,
+};
+
+static int create_tmpfs_resource(size_t size)
+{
+	return create_tmpfs_pool_fd("never", true, size);
+}
+
+FIXTURE_VARIANT_ADD(gmem_conversions, tmpfs) {
+	.create_resource = create_tmpfs_resource,
+};
+
 FIXTURE_SETUP(gmem_conversions) { }
 
 static size_t page_size;
@@ -37,8 +55,9 @@ static void guest_do_rmw(void);
  * Defer setup until the individual test is invoked so that tests can specify
  * the number of pages and flags for the guest_memfd instance.
  */
-static void gmem_conversions_do_setup(test_data_t *t, int nr_pages,
-				      int gmem_flags)
+static void gmem_conversions_do_setup(test_data_t *t,
+				      const FIXTURE_VARIANT(gmem_conversions) * variant,
+				      int nr_pages, int gmem_flags)
 {
 	const struct vm_shape shape = {
 		.mode = VM_MODE_DEFAULT,
@@ -50,12 +69,27 @@ static void gmem_conversions_do_setup(test_data_t *t, int nr_pages,
 	 */
 	const gpa_t gpa = SZ_4G;
 	const u32 slot = 1;
+	size_t size = nr_pages * page_size;
 	struct kvm_vm *vm;
+	int gmem_fd = -1;
 
 	vm = __vm_create_shape_with_one_vcpu(shape, &t->vcpu, nr_pages, guest_do_rmw);
 
+	t->resource_fd = -1;
+
+	if (variant->create_resource) {
+		uint64_t flags = gmem_flags | GUEST_MEMFD_FLAG_USE_RESOURCE;
+
+		t->resource_fd = variant->create_resource(size);
+		TEST_ASSERT(t->resource_fd >= 0, "Failed to create backing resource");
+
+		gmem_fd = __vm_create_guest_memfd_resource(vm, size, flags,
+							   t->resource_fd);
+		TEST_ASSERT(gmem_fd >= 0, "Failed to create guest_memfd with resource");
+	}
+
 	vm_mem_add(vm, VM_MEM_SRC_SHMEM, gpa, slot, nr_pages,
-		   KVM_MEM_GUEST_MEMFD, -1, 0, gmem_flags);
+		   KVM_MEM_GUEST_MEMFD, gmem_fd, 0, gmem_flags);
 
 	t->gmem_fd = kvm_slot_to_fd(vm, slot);
 	t->mem = addr_gpa2hva(vm, gpa);
@@ -68,6 +102,11 @@ static void gmem_conversions_do_teardown(test_data_t *t)
 	if (!t->vcpu)
 		return;
 
+	if (t->resource_fd >= 0) {
+		close(t->resource_fd);
+		t->resource_fd = -1;
+	}
+
 	/* No need to close gmem_fd, it's owned by the VM structure. */
 	kvm_vm_free(t->vcpu->vm);
 	t->vcpu = NULL;
@@ -91,7 +130,7 @@ TEST_F(gmem_conversions, test)							\
 {										\
 	const int nr = (__nr_pages);						\
 										\
-	gmem_conversions_do_setup(self, nr, flags);				\
+	gmem_conversions_do_setup(self, variant, nr, flags);			\
 	__gmem_conversions_##test(self, nr);					\
 }										\
 static void __gmem_conversions_##test(test_data_t *t, int nr_pages)		\
@@ -127,7 +166,7 @@ TEST_F(gmem_conversions, test)							\
 	int i;									\
 										\
 	for (i = 0; i < nr; ++i) {						\
-		gmem_conversions_do_setup(self, nr, flags);			\
+		gmem_conversions_do_setup(self, variant, nr, flags);		\
 		__gmem_conversions_multipage_##test(self, nr, i);		\
 		gmem_conversions_do_teardown(self);				\
 	}									\

-- 
2.56.0.455.g6c5a503b38-goog



