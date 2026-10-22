Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C592606B822
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nj+TiSZY
Received: by kanga.kvack.org (Postfix)
	id 324506B0A2F; Thu, 22 Oct 2026 19:28:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FE476B0A31; Thu, 22 Oct 2026 19:28:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EA9C6B0A33; Thu, 22 Oct 2026 19:28:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D1EAC6B0A2F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:02 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 441D4120201
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:02 +0000 (UTC)
X-FDA: 85351852404.29.8C9BAF8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 23099A0007
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nj+TiSZY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711680;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IeBKuFbI5RouGS1BqE5uNK60CXrNCKPcOeZV9/GDpf4=;
	b=TY4kO6kvOmD12HzhUw7Om3Z6Z8Er3RBVAC339x/thHfZC0uusOLkp1UHSuUcK2o6X1PZhr
	OT2+g9Dv0iI1+tgid8xrxtl50ZeGQhyZdo/2ZulKAkDVqHDNTCMlMp3LC1MHTh7Ctbr4qa
	sr4XvqxFqR3OyThe8FWkyu+zykX25Jg=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nj+TiSZY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711680;
	b=Kx2aNAezBNDB7DVTWlALiYSWr9uZMcGKnflbb9KvJN1aNas7sBfb1ASjhhwl2A1ulrXAYr
	WAsyweiPl87s3vbfedr706lrx846OlKE2TjA/DxfgbTQUoI0fJtmT8Y3g432GGnwheJhb9
	Kh1U0wYu3eujgBuqnXdWJ0wfGhcUQu4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 291FB403C8;
	Thu, 22 Oct 2026 23:27:59 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711679;
	b=1q69OPGMxptt/9Rqel/UMGTuXK8Ce3y0DDz61Ur7vYUnRx5EPEpHuaNgvfhOY4NAnybj
	 m2tOcRLdJD4mJf/Uinf3OChrwKMoedFW8ulC5yw2G++r/w4IZo7LxT02Ok+F3xsLZqI1B
	 vkaJxD3F7XPjQsT241kOcG8LqjqVEEFnIZscWrBdLELndikbuZ912egUgqQtAXxRjgU2/
	 YKKTozHYiCNN0g5+2qWvgc6IiFSPkh30R3dLJPXr4xLtJCKOgm+uT0SVjLNlQh/QrVPlk
	 XKvuMvsH7l6syDWcm0GEH/jqcjvCCzgXFv5jAkX6Jl4gKAt0TPTs7jAJwpGVO7hmx0A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711679;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=IeBKuFbI5RouGS1BqE5uNK60CXrNCKPcOeZV9/GDpf4=;
	b=p9o9xZ3cnXLM0ht5NAyv8IWHZGmS3FbkHDZO1h8fnNcFNFon7p0sNf8ZEUaZzeuDf9dZ
	 83vStgUT4I8D44XRE+r7v50jRF7JOg//ZFaqdmSTwOet4rBOqmUPqr6Gx6f0P1YPeZ/ZW
	 upepaSQ6J1upNBfXcBG+dtOdvWNoolaoGf9Obm73oGkjRhmeK4LH9nhzRVd/8nSxivHWC
	 KBXhR8K0k1T0IGCo35UwXGhqNilqVSCpxFVcNSeEal9Xwl5jE45wakZTZ3C69cbC5a529
	 rATljN1aFxkB+AyKVldoq+MbU2C392nGKfNAlB9oPu0OFJaXSzCOcc0AJe/c+ZpuIiQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id DD5011F01185;
	Thu, 22 Oct 2026 23:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711679;
	bh=IeBKuFbI5RouGS1BqE5uNK60CXrNCKPcOeZV9/GDpf4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Nj+TiSZYgKRwu6dmh3++kCeiItFqHi46Q9yE13sYBkQQ0MfiguFVChe/NCKrG+Ygg
	 IWM41RTCvOx7GQNtApWpCFEzw8nhnlrWX8g27/TvFAkT0V4+aC9FhHCEBWTfdwhPOX
	 XukFvnbZ0OlL1SuTzsZjRmwp5KcLtZiJGb+Xm1jlEa9N17TL2uAjQtviSb0ss2o8xd
	 1f/YO0rToVCalEnWUs/QMSQtxkkxIxYVHY6fUx0ddYYt97h6vvN3x4HlYHmJwwDWRD
	 Lntgg1vsKqvOoZ47ZaEpR7rmXXg+SaDJf8fcT+pOAkDz8bDkwzaeX4b9vu7sa1OP6l
	 e4pVYbu16Pw0Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id B56C84206B;
	Thu, 22 Oct 2026 23:27:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:27:42 -0700
Subject: [PATCH RFC v2 10/50] KVM: selftests: Test rejection of swap tmpfs
 mounts
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-10-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=3539;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=zR8MX/2CQi/SqTXqjQrd0mWj1p+sOZKDt/EsWzdKyV4=;
 b=L85dc5nPJTUd1vfqIJYkB9OBf1jiRRCQbTzjK7L0KKv8MXi0Hk77tRqYzylP2QhdB9rQHTqc1
 qLKKxC3ZuL3C5WnjXjJ+unmgSB7LWFhYNht/YdH2QYBBeq5YpmrcOAI
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 23099A0007
X-Stat-Signature: ihj1dzon9x6kcwqoiefaxoojo6w6qujg
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792711680-599087
X-HE-Meta: U2FsdGVkX1+mWsmH0OGuWU6m8wGvsUERYSMQAVue9hF7UQF0Ztmug4vWXLIdtLXuaMLQTa4Wul5HLYsAhbwNOQ7hhISpPJYTInIbX+Oxd7ilzEL3nLfW0AQm2iwB11hiEqyYYPVVnIQX2EGYzQALH0QjFBjrWPvmiz0sBeQiudUJY7QjpI25QSQK0MuUoXFfBsAz87VPMMbcPyKWhcbZaK+ju+TVCXLqrcHvTefs6DTQeQLKmjHRvfc+/IK82waOlTyYk70N+7bY/DnvZgUjeG9nV2Y1rrkAPnM2rCaA/nRoVH/Q44j3H9jb7qZT8Bko/0yvT95BCz0L8cwSmiErUyb2bUy27T0UlnYtLHhW9Ch251ZtjpZHhWs9l4wnJ5lwdg+kINlAO+oskX3y83bfsuw3H0R37J34XwyhA84Lj2nhaoLOt+FhMOriNJ/eHYyBdLRTCviSlYHXSZlV02kbgeUSMQB7cCXf96/2UWitNeIiia6TaQaomT1reefC+3RtonDwNzbVm8jRd7DOfaV+mq6kGdvmAQDW2laigvJ+rCfux7g9BwkZldj2uwOTQG/+aJ1ZSYU+Ul2xx+kmjlSpPFJgG88ofESc0Imb8a0JuTRZVLTfVtteZFkD0hc6vDOXZvaoLbvWmrSGSSSqzFBWR7302OunYzElo2GAkAvwDnuv7qJ1mV08HvfhwB3qxp8/hMlhtmE/IF8SAx0xVbjJ4jf7PZ1+lUSBX+um/b3YyDlP4iPrMVnItb8ePpVJy+w0Wl6wXZHU4Zk3qaF1evoNQS6fk6nU48gILFkv7MEBw3AKSGjsoszrIOm6c8SzlOzRdl7dyxnTR5UrfLSl3N620yZKblmH1YqN4bjd+8PKWpdVi+MLqbAju5PRwnGY/2uj1uWAVkLk0GPGmTkb11li7sPrQq8rM0rieQQd75iJSBqhN+qU34VLnlmHMQENhezaHLuxLpK2yYL6adaPzea
 JzfPl7eY
 c79jyDvYdt4LiwoFA0D/5LDzW0vwcykroRuVUwIzz6VJQi2Gyt0+rSjLO3tByR6DvRijMNUveAiF1/FcTaP8tzO4Db2VBl1TT3dHJtVwZUZDtoU51XGusCtWy8SIoe/ObdWxhTCKfdjwHjCZxhCkAO+tH2aurkMSH6Sg1lXHZwV8/4HtX4UMaMYunnGRlbYAqiQVbwyyWGx6io1wsBi4VKdCLLb34Ic13AxMMf4NGLb2EUhsin0f3F71LWaFQfwx0uYcuBGL4zoG9Bno/hyUGd3pSzayLMMqpmLDu7E0Mk37+1colh2LomllgVIbnmC32Tdqhn+H5SKwNgwla0K+oHRiGHJZwAMgNntiCzrg9ZoXzaiIv2VKCkHWKoWGig5vpl3Cxy9SSyzuXx5ZeAdF4WPZgEz5s84eIPgjLtQY8NePEHkAeoCksoKWkN1C8pRgRjl9PcspM/CtyGbJupu7dhUzqBoeCnVfFD8kXCeOraf0fg1BwSEfD7np0eAdL43xRnc+YacUJtIR54KjgCNy22umIadKdLSF6FNem3HjG1oAMoFotjYY0NyO/9Q==
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
2.56.0.257.gf7497c7d27-goog



