Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0E1B60A2614
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TPelHZMv
Received: by kanga.kvack.org (Postfix)
	id C8EB36B05BD; Fri,  6 Nov 2026 19:37:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3F8A6B05C0; Fri,  6 Nov 2026 19:37:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A91456B05C1; Fri,  6 Nov 2026 19:37:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7C88C6B05BD
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:02 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 008AC120263
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:01 +0000 (UTC)
X-FDA: 85406458284.21.B231244
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id E1A30C0003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:36:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TPelHZMv;
	spf=pass (imf28.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011820;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7oNPewxIMb68UUcd1Cg4cHswlI8K0kn7Az249dYW9mE=;
	b=iCy+cs/O1glOIxdUo5U52D/1+IR8WFxmHaP+CYPRHM4XfQTOZQ1OPjPCb3YV+UVXbOQcFH
	vzq/9gTecYaO0Uc7blyD0tvEq+h7NHuj+BdfW6g1mbBwoTCi36wtGElRfRg3/QnpeLTLo0
	JM/oMRcuCwt4G0KeJWB2AblUGgWJ26Y=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TPelHZMv;
	spf=pass (imf28.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011820;
	b=W28HLe7lxpqC907JItaYteqdI2FQdnEDuxr3tDDlAOF3JzPWkZlEwHGGGw3JEUz1qBxTua
	MVBLaltCdp/D4OHu+ydbVSRa6nV3PIo5QQ2AEpe7kkTB1VAJ9USzGje9+2te5uWGXNrWEQ
	4XfRTJO5HHzjlNAj+FzNqaoueuW7m94=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4105A43FEE;
	Sat,  7 Nov 2026 00:36:59 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011819;
	b=H0A6ARcoOlg/wGWvBYJusSL4nKPO4bZ2f1h+yqOPoo4sauji2BnhwPPDFmuKWpNkkW9n
	 gBGnuF2ez59YJytA+9Ybvw3LyjQqgDRSiumCV4EkQ0Cr9oYwep7hfYdNZn0sRTTkb3YAq
	 BhnoP0vGXveFOnEP+Zpk72KIFknMP5KaS5OURsM2NiCqqsF3CW2ntG6LRleP7vCHF6xn1
	 bDsFef5DHQuGEuSCxo0EIcT7v2fZqmUrKgTcIGDRKfwtR+YhbpDE3IaQb3HIVKQESplar
	 mCZeaQrp2+cm4RgkK+pL9aD43NpRXSgli7gQ4hf0kczqEOXiThCULu3dA30kwR8n+Vw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011819;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=7oNPewxIMb68UUcd1Cg4cHswlI8K0kn7Az249dYW9mE=;
	b=uI86uebgOTx5uMY9VAba/WL6rQCbS37SyFp/8lPvCvFwiICvXakETwmqGQCZOcvYJOJ4
	 Uf1gJaUh+xDePSt9C11xLdMyH/vZF2UwY42/kR0RydhSjhCdZ2arq3NebwKqqgPUicehM
	 wGNpezbnfQx1NwxP/WvQzwCiyjKKLhbM7eoxxlNDbvAQEPVJqdDjUO1nGD4r7EpxNHWQ0
	 gs1jmrnTujKcq1kjMWieFPxh6tR6NAjwAnygP8lepTthGcVapbRHoZQ1Z/hgZvMc+QthX
	 e+LRnDn8s/o+p/SPzCBk4DnOU08JXNUSsabYvcYfAnVzD8X3WtDpz/1i0mWPvMtARRQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C6EFA1F008BD;
	Sat,  7 Nov 2026 00:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011819;
	bh=7oNPewxIMb68UUcd1Cg4cHswlI8K0kn7Az249dYW9mE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=TPelHZMvf1BVZHG1LqQKlrtRjK5OTeVpzqOpk6PMUoQF+IcST36bzANR148bghBXG
	 ORX9l4XsfMqPT3zwgMfbx1zeIDo5AE/PVL6KlggGNDLKVEUaXLQx6UD/VP1PwYfc6W
	 yExO2euukrk/VKf0Kn5WJxT/Q653T+LMKC4wpf4iqZsLF8JzVcfUA64GZCGU+ohJSw
	 NgkiOGHm1vwKdxZMlxoJSmyT66C1yZTBERxEKt0KwEPMjZ52Vfs0wZd6AdPfQh/MeW
	 nqL7ZwNRuVYQV60cpGdCZYG59dwGv5noltzmeYkklzkjUYJbfECqcXU7UDcHkOTWSn
	 d6NGENvzPARUA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9167A4793C;
	Sat,  7 Nov 2026 00:36:53 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:36:44 -0800
Subject: [PATCH RFC v3 10/88] KVM: selftests: Test rejection of swap tmpfs
 mounts
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-10-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=3539;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=lpdQUuXZRi5HMPPsDaXRCAlhoLcAGTXnceeQBzFXLus=;
 b=8gMlAhCQDehpdhBKMnVKx7w1xPC7T5I9VIapWU//NYUwuh9viMkkDkY8Lth7l4Nzmwxv3uzv3
 0m7ExSF1OwwBGyGeTkzOhAjzWOq3kzo+pxYPQZad5a7uLNh6tMiN/Ux
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ieb3o6mty14m5pwwzcoxxsa5fm6by6gt
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E1A30C0003
X-HE-Tag: 1794011819-464466
X-HE-Meta: U2FsdGVkX1/+U7s6U60Uo1qL+33ZoYGV1NFBH9vTEOzld1ySj+pi/TcBmY1NUvZnl4N3hWiHU4FfBnhP9LhM183s+wtqw9XzK2Tx5IJgQ4UURh+pEtFmZm8dqFKLQ29ppaNcl+EzfY2k5TUgjPUYBlokqYzOlcgu/Z/jXE711Veix6zEPek4LxQb8OuqPXR1TcmM62pOxbxoy03LmyxRwmtUqQL/5KpvmBd1q0841FhoAKNOL/DutShcgB/8aCMpV6g4IdxF5s2z5CseZavEvWGA+vJDsfhTjKkGaRCwGFfHqjJ0X0nGPvWtrTr8rDwoUqHruY/GFw6i3xGf/mIEDclZF375O9i2WnBfq+8sqX5U3YnXP1iqhhE3FmTmstSVM27grNoR3okpnaRXTNvuUQKP6aXMQ5LCaAiY6aWWIHycHjXkAgP1Iy4yccrylOqvYpJ3+Gr46/UV+g0NIluqXZd6LxtqBOosnjzekC29R9FyXr8YQgraDODxqtAuJEaFDT2qNrksJkFPV9SFKqwtUEcDRY3NFAjgZErv5Bg8Vtb/tG+RVhFicAjVqblrgp7FHndYwB2910TtaR+xvSkKdYdn3XLOx3bsm5tRXvvZxcLZ1XU3OsECaL6kLFWzkIygb/tYkWwRilXgarvdbTcuzPi8zCkpk6V2g66eAwMNcoTAcUHcafnQFugTdnS56mz4TAxmY4nZC7XlhUMyG/LZvgwruHTEXQFa+AKiiV6aHaafm7mOAXhvashs++tuui2Ve/bUBL8iA/UE4MGgDaIJw3+EmMLRweE/yXantZmK6EBplwVWeBxojll9ONq9aC79bwkta1Q7a9bCJ+n4tDO7NTCQeqsnpkNyxwWWtF7xW7l6LDoh3h9ZZqhk07XWJRqOlE9Q+indBvM/5XNobvIU4lCTICwgApx+sfcRIaO4J2z4lkslaLy4gktB59L/RAFhsbw64C2GrK3Bo3XrKEY
 fRlu1evn
 s9mDinaDDIm6I9BOU5attaAh74vqcHMKRzRR/LFuGzpDBgBpuhtaGLtzkF0d8+E90ywSnXxNXc+dhqFfS3iUjH2CTxtOJ5ttAPLO3ln3dyI6LbVfgQV9hYQDf9A+BgN8yil9z80l1Ual2bMWpGn5sEISDnbmnXvqZ3kxDV7ls2xDSAuXD5IF+i71mwm/JrFEayLBQwMYr3IlRmMepegLC3DAWhrpGOQFb7R2vLnpXvh3Xyv++UQhsS/iss1tr4KEw7hAJjKsiKWN8jfUXLOCoxL/8aXkcFWY737K0Eth5D8zGCQxtqzzajr3xyBYRiMAvBHIeAvesi9Ka1lEeCBqpRZ0/L1UqVGspAk6WMgxD3wT3hRs+svUWPaJ8XBAs4hGZRhHqJytNi+EjjKvPeXTvaJbWASETtvjOWujvrAjprlQUT2fAvE0IeiWriN6MKVfkX1XwIUBdiqjVjWLAHNfSL375Xzd3+Yvhmw4DJuFLt1C6e5nmGOf2FjGreYDYeo6lh2AuNge4s6iCMAx000XfRsojiDwa/Wtw/LnTats9FQegykvscnoaytxU0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Test that guest_memfd creation fails with -EINVAL when passed a resource
pool fd for a mount that has swap enabled.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 70 ++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index d62ae23256083..205f822e10c6c 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -13,7 +13,9 @@
 
 #include <linux/bitmap.h>
 #include <linux/falloc.h>
+#include <linux/mount.h>
 #include <linux/sizes.h>
+#include <sys/mount.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 
@@ -478,6 +480,73 @@ static void test_resource_fd_memfd(struct kvm_vm *vm)
 	close(file_fd);
 }
 
+static int create_tmpfs_pool_fd(const char *huge, bool noswap, size_t size)
+{
+	char size_str[32];
+	char template[] = "/tmp/gmem_test_dir_XXXXXX";
+	char *mount_dir;
+	int fs_fd, mnt_fd, dir_fd;
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
@@ -539,6 +608,7 @@ static void test_guest_memfd(unsigned long vm_type)
 	test_resource_fd_invalid(vm);
 	test_resource_fd_unsupported_fs(vm);
 	test_resource_fd_memfd(vm);
+	test_resource_fd_tmpfs_swap(vm);
 
 	__test_guest_memfd(vm, 0);
 

-- 
2.56.0.455.g6c5a503b38-goog



