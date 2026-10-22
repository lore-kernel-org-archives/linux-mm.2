Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5D6F606C093
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HJJ/+3Dg
Received: by kanga.kvack.org (Postfix)
	id E83956B0A39; Thu, 22 Oct 2026 19:28:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E47E66B0A3F; Thu, 22 Oct 2026 19:28:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C07A96B0A3C; Thu, 22 Oct 2026 19:28:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 84ECD6B0A3A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 063421C3583
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:10 +0000 (UTC)
X-FDA: 85351852740.17.350CD20
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id EEA5CA0006
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HJJ/+3Dg";
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711687;
	b=ylFA4klCt9tUFDHLlWPC6h+RqsTut4Serea5B6eFYIvjKDjLxfpgeZQGFsdrBkYTiBN4Yq
	xnsXiFiufwoDump/Iu76zk/vWjH5IWwfq9snDrw3li56IIZFXqRgarIIbo4WzRkpgpTJmO
	SXtGcrkrzbc2TKDdUEnSda6jOncZSdk=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HJJ/+3Dg";
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711687;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZP5mM8QI71wbAYr9X/Kh24n4XhiBqUCHdlwGIwYTpuc=;
	b=efOhAGFejy2/OO4Q4YgLbHCQJixAc1Xhi9F3mRZyT3vLsHXmZW4Jyp18ap4tMT3oBh0gD0
	0F/EblpSOao5V9J+TcKp91/8fAakk2H+YMRNJV0MNxDLrqZj5glCADWayXyPjwKPisr0UP
	4PgVvekYrNrGVB8rqpGlBBohrZvnn4Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 88CE060D84;
	Thu, 22 Oct 2026 23:28:07 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711687;
	b=dUKNiy5+jy+F0RiuL3E7HCjmJytV2EIuvyBSDqg7Qk2mxLmIfY4iqS+clV+fl4YY9sBA
	 jekwtTUj3rL8ZgA/K8tnJz9NKuMClMRrai2L8dPIUbHtk0lGJLq78nuWPueFMYu7w+UJN
	 a+wxaYufO/5i1WtDLHUdoIFRclK+/6XVOoZ2USU7ye79dUtC/7wTuu/0rvIS56Xd9+tJR
	 KLcCrGjvBPYwPh+ExPuS/HnwTfF2xIQb07nbNr7LU2A0RFAbmwo8vDgFcZBZTHUnvwe0C
	 3hE14Sdk+UN956p/jgOSR17Bn6RirnsQSmgyonkjXdY78DpZrnNmwATrOs2p1SRGuXw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711687;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=ZP5mM8QI71wbAYr9X/Kh24n4XhiBqUCHdlwGIwYTpuc=;
	b=nHjNspNNzYmtF9sNRWL3PajN/0cQQ3MNDIoPFshXTTpt27pF7Q93kUma0Spy/sfNfYHr
	 /GDMqrHyU1WdJt95PdpiC5m0g1WC+Kiz7VmgQYR8I5AxY7pW9iKfartHu3ErMj8qNjLd/
	 25BTGcP6vg9tjs3p4pMZpoOT4yoZjBQvaKmnkYzBXAQia/k2mrDdRM+LZxUcy1iVVynsj
	 +R4uqwW0uCExCvPoyFX8nzHPKRxZ6fQpmXd7ADdXqDLtqVVGQZtCLZ+hZ/25nPyY5bvwT
	 ZrZ9DrYKwcA99bePwoEaoPEbASR8t+XpzNi4jLruijaJTKuqSpuMlpd8CBXpcAXYaXA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 6F5541F01195;
	Thu, 22 Oct 2026 23:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711687;
	bh=ZP5mM8QI71wbAYr9X/Kh24n4XhiBqUCHdlwGIwYTpuc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=HJJ/+3DgGlfH146m8BrN+82/5kJOG7ONIUpw5dqJZIohvTHMQNfu59Ro7kpZv39YJ
	 UmxYAUM/7DM306ivqD6baX0EULAaalNVz1Va1xn6TLsl3B/U0P+QP6iEui2fGKF569
	 WctDRf8kTJuzZGkxXsPakZjiTgsW8Exemu/PolfnZpAtQqIx2XAp+mqpN+oyHlntCO
	 cc1qSBTL7FoUxwdbMQml/nmzWzpr+sQmer4Y5vN+GQZYUuox6VfLVIXpFN3XdAE93K
	 4hS1IRPsKe+H4QgWVKdeyDY1bqnp4kYvvAHWyi+X/ccNsEkPgnntLSvdfSKtfR+44N
	 M37fVLUeN5qwQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 2C13C4208F;
	Thu, 22 Oct 2026 23:27:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:27:51 -0700
Subject: [PATCH RFC v2 19/50] KVM: selftests: Test guest_memfd conversions
 with tmpfs backing
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-19-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=9639;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=2IiPx+cUsy8kKIePNGRlu+krlb+T2Ppc08ibBkV6Uq0=;
 b=c52viF1V8PByFo4YQezMS+qf4jceJz+2OlAZbo/wQrpC+3OGhIbB+tGJb14vPzV9JrIgwS0gN
 4pn/Jt5HVNFBnqjZB66MKUV8njFXRXY/Meipf9dUuNNXQT0DWNPGMf4
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: i355ashnqqcbromruoj6k7dyx737x36c
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EEA5CA0006
X-Rspam-User: 
X-HE-Tag: 1792711687-506161
X-HE-Meta: U2FsdGVkX19v61LemxdblCNIo8v7ugwIvkx3CMiGfO7Xd80haKwAB/WSP8mf26L3IlN1fS7OEJZnJ0nz0f9p+ewqFFDXHXu2uE6KERWG8V8ygcT7wxNZDBsJSuB3A4xNjDTNVjJdtQED4Loj5GsgnXKvonK4KdoI3+IZHOKhBG/zslcpFjDZNf9PkCC8T/HXKbpym5Zs/5Pr11wi9xDZLBscgZLKRXtepkb9yp32XVeUgNP6uCIqEVdtYttqYM9XeGS6qizG1VV32jDjA2aLhhdnQ1PML52oqx2vYk30u26wC4+E8uFB+mcqfIvl3BYm3WJiboloePyLkRomi+NsDlar51nhbircft3oW4BytpCFkyO33c/Xj3p7s2INrhbUc65dtSmWcDXwgr2UKp82+GpVD7XsxMTPZId9+4p5jnxnANUWZ2YWJhhrfJyondzX3dXdeWFitHx/BwKN2LpsqUX7p5zpIcH/QDzTJZUYPSirEa3183OIfA+obFu6vZZyUd4kFDIQITVg2EkZ6TG7Dg6JGOPywxZwhrDVPMciYD0EFNj26kj3nI8dMMWBogDU58CzJgLFfnPxiR766FAtVgmOAATfvx0joeHkaQF2nLzY3wmuWouBnPkR+2HigluQECyCgXi1dMNrvy4oS7nSvhXSMS5LVl16s4hg8ZxZaQ4e8XJufqMx0Tsdzl7SeHVq1baJW5q5m/p0ruHP8LeB8dfYCqMGPrSYW6RobmxZAYkdlYzNJgbKZslrg5t/ZuZlOp6C/8gSgAVLY6aOS4fOgGy38DRGsRQ4ueVHALFrLWkXiEk/w7qXJ5mYbhPf5LqONIxQXLgH5Dvfx3mYUagDkQvsAw8hOn4z5rzfrig1PMVO9MAQ2SWAMkx3yZWWLIcyNot+AciW497R2ZEHp9q46vP8/vOPklzjxJqdwR8HeQHsStMwGbybqKCW3j9q25QZLsRFkrvejjdR3h9bJAi
 xFEBUIE2
 0jgd54pFNUUGlnoNRfHARoW7hFBnZ76yjMQJQxuPuH2kD75Zr+yB6JYn6SZsM1Q97gn2MNgzJA0ule5Tx478OONWluGomGXXN4YVII+7SlF2XzKwVZoPd5KNXBYEt6koi9hjx4HRQ7pHuppfd7hNkUxUO87UwIbB7tXzXdjDlou1OmSR3b6MOxzyyIpfnjQnHg2HAAFNWAeeYscgMXTwA9TPAsWHVmtBTejY6gaYZBa5ulfDho9O5uBIYHJ9fzxxihfL4EBS5SRPNd5cZ7EqrkzDMhhxkyRPlegZnOzt1NLE2QzgZ2x/z7587p0iCKDeHqiIpyZ7WFgD+0AQ5A/VFoKRqMmtvXikUDZvM8PZAu8HgRhaGx37/HN6TTZRIJqAT/9tCfbqizrC2fHqT0h8UsnxzpIiA3WZKO8aBWajG8l06w6GpPBpNzKaPaqURvGOb5o8Dso4zcKoMuvzLE/9xMQgZReLTa/RxFNb5Avbw2xV9Z1532Ybnh8p50VrQcVOwLIzC9BbFuIkenxNhv78IBBYPEix3w1JgGplHZx27ebEyROrjZ5BrJ95zQYEa2LYuVSKroZzXER2coL5dck0qjiAROhiEbyKV7VwL
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
2.56.0.257.gf7497c7d27-goog



