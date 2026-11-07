Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98B3E607B388
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JhbzNiix
Received: by kanga.kvack.org (Postfix)
	id 520036B05B6; Fri,  6 Nov 2026 19:37:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EB846B05BD; Fri,  6 Nov 2026 19:37:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B4CA6B05C0; Fri,  6 Nov 2026 19:37:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 106E66B05B6
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:02 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 954724029A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:01 +0000 (UTC)
X-FDA: 85406458242.27.F1CDFB0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6E6EF40003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:36:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JhbzNiix;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011819;
	b=s3DtwtAtlsw1IDuNgoRT0hIuDqyTBOpTHkPmlKePyBEvZ9fXe/PNv7NsJcvdQxYT4p9jd7
	e59ykuYIHiRbCIq3wDbSNJ4JE04yN6m5P+iQuPQnExllEgUEfYvzKFk9loAJ8TufobWW7W
	JqepZOlNeLBC7vfbAQEeIz5N9+KTF6E=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011819;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WEsvWJrtZKFuRaNPE0dZ9EmVrGX9PP233mRUy4dzRbk=;
	b=HA2aq64kd6q1ZQXuVyzxmmPBWHLnYGiCDcKyVcVTnBFVfANmUPIUifOVjyeMt4BcJnfUlb
	J5ym/3gwyHnGhOmwC5EtApBzHIbN2N5XIxFyoH6ink+Wiuev1QPRme/BeB+7Sg4RLFw67U
	zwI7gslbekqhwNsdvmVkLQskd4flQqE=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JhbzNiix;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BCD3D43FEB;
	Sat,  7 Nov 2026 00:36:58 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011818;
	b=LQq13lZx+sdZvJz5hV0vhqPaWhKazQtEJtF/YdBvmS+jXpfC38I3fuX8LbgI0cfBSa8O
	 i2O3Eo2v8vnZ0O+mKpWd4VRDEkj1UWVeGDTQGxxnOaWUKL9t82HbxduC1NDTZ4LMI7j5Q
	 QzeQO0idOvt+ruCOicr+VL/q7Az9OWpoz9/AfQrI33JgEbXDKaLBGIWe6luWlsy1xwIum
	 BCW/KCUWE7g1iing5sMEQ3FmCFeMyPXLsKzYnt09tcYeLS2nzuVa2pzq91W68Dc0289iC
	 Ow8QwVM+VGjNDX0IM8GNer7BkZwE83XUwOWRNEIrcb+XYT1OkH+jmNhjuffdi0QkIRQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011818;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=WEsvWJrtZKFuRaNPE0dZ9EmVrGX9PP233mRUy4dzRbk=;
	b=tTRHieWCp9iQTGVHmjJVrmhwJ1DQHhCwWnR5vtFJ4AYKdxeifkft0a3IkcNJOj94yKKL
	 yvN4bJi3lB61m53NcEh/LOVjC8NXr82mPoDhZcgTLnhEhPRzLhwjG7cjvCBKDT3eUObx7
	 mO5FEZrNMO56O1J7L2/sBMESnIaH7zIDBDEgglPBCGZWPt+mJfu50+Qy4E6wqqJISwCVu
	 v0Ks2vk2hGuQmWlOd972egztZuk0ZnWLsHkvF7Az4cQWWI93lS/fjsrk81mjo6y9tSslJ
	 vZP9AMYQcz1ROW2OKGSJgaKxqojzvN148UPp46Ui5zk70fqLAPwM52XLCGVdbh1Oj9Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8E1F51F00923;
	Sat,  7 Nov 2026 00:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011818;
	bh=WEsvWJrtZKFuRaNPE0dZ9EmVrGX9PP233mRUy4dzRbk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=JhbzNiixOQpWLus21oLO1FWIRUOevDOFjpyEjgPXYjOFKaY2ZAJxqPxOdwvmMH1wU
	 +cpIgzxWwgtrCL7j+pE0Mq1LzoK8ajN4SCA7wWcHMANq+gfs+4J9ERmIga3yfxoBej
	 KGisCr09zVNewGg5/4CTmRJpt7nf1be806cO+g0zRUR+PuHRMB/qb/idCaRczpf2f6
	 YbLl7vnknkt+1OP0Ehl9PWYiebzNo59u4jTqiTG1g6omcgIMNnCsOqA7xZk+OFgTRg
	 06hcBdmoWtJpESakP+xgdJ5dbgtaRJ0g/hLuxr67hujc4MDp3u6CKyNEFmBVE01+cF
	 nUFJj4Dgs8Mig==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 00CDC47950;
	Sat,  7 Nov 2026 00:36:54 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:36:49 -0800
Subject: [PATCH RFC v3 15/88] KVM: selftests: Test memory allocation
 against shared tmpfs resource pool
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-15-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=1933;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=0jopPByLNEPBSe0/be0Wm6QK3iE1kkpZwMF93kEQ4eo=;
 b=ScmyeLGXcUc8o/vmZGhEcaEmxpTM+jdVNW4rYAIxNVAiMpGRVTplAEa7BJbxPZT141BmrEWN9
 wgmFQ71KphQBC4nTm17TPFSsfUH0DlS3aqYVRFiQJyH2q7Jt9E6TtfG
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6E6EF40003
X-Stat-Signature: pk7qi7b9trp6jguxo4qpnqiz5cqf9p6z
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Rspamd-Server: rspam12
X-HE-Tag: 1794011819-424216
X-HE-Meta: U2FsdGVkX18dzyQ94qMsrQHgE0RFk1jettkB9ox4yOqczVk56nVNFgjpugD2uXm2mq40IrFAE38zloHGzFdIkDUO4ENGukHQYB20qeaJWa0XHYNJPoDuDH7MgMJS251ruW1tRH9pUomV9UcDnzZZ8LRLEWHS3yeJZVP/mR4sJCvdDFxjAWHGoa+EJWEqihzZPiRYZHLTVZjW3i03iOmTzBlvP0fBcJ37vmmtDwIM9wJgVOSu2GvCrfR15Nv/zoVPKMY3+uJ8iPT1r1ni8tFgNqTVGjFVQ3RRbxmML2N69zAkrjG2r55cU7ervcSYZnErRIjepN0doOt2B5b8p6tuj1oF67PxLF+prD3P7opqT8lmHvYKUYY/lb5+F4OHjk//yRLdV0KCa5DnNSDBWanc/PAsLzLCbT1Emmdk4YS6tRlF8rfV9BiJFFXG9XISDenMCppFeM3SQRKpzf5hwVEk+8K0Vp6DLS7HjI7Cw0VSX6e55xrVZtbUvAmgFg/oZZuU2FQToqsRuu6RueJ4RHRPnRgL7tPLu8ywJ/Mv9LGvlhr4ZeDn8w7IbuilzMYmhmguKmUhotpw29AnNKSLEfXLuIz+TkNoMBtRwll6WqE0UCMzhNx4HD/TjM2djmDJw28G8IBFi3ljXGdCOikk6SjM/od7zyJpsVjlq9IWQdvWhlouEWgpd9rG0Oif2jyaUGjw8fdhlPAUsu1ezadl5+5Xk4xHNBktT0W0t45Z2wzsXilg6FmEyc7HoHukQ77OmInG/wM4TM+XBx9+83UyoxxhVcmYkRsM5vS6je8tqWn1vnzZCZhtlrcgkcTtAMi/Q1s/emqbrs8R5+9H2RmjM4R7pHN88wuS79iZ6GFy+vWvrxY096QI54HOI/w3bOXHlEGknmNXNwo4XMN+IqMGk4OZV9bZNxyehYh+dLzhF91D4xtmmA1AaLQW2mF3Mp4NLYi0UzNlFh6AfUAZS0e3lZo
 A/PDyGPd
 fzG76M3Pw2f1IWyAvWm2B8cohqlVe8tWUzHLz4++K+QL/Wg59VE27IQSk6waD6lXFC6wVaAl2s35X9pCYZ907+0Z0Y1SXORP+ztQqWWvAqE4k8Puss2KEQIK+BWKGgKeOXqxIXacvehF0yxJ+fNeaNjhdDCW5H9FpJW5RCcY0MOzFnjdSOiII5K7lyaYR6FZHqRdiRhwQX/xE69ngO9qgAh8fUZGyNoLfDd8OwDOwHHY9wz59Hp48iYeOiQI9Q6dIiKt/e/+/MyKYRj6vZndGZmZRe6TbDK8ktsTmhLvCDqFvVYA7iPbEQrRtd8iOHuKZoksVOomAu6KHrIqdmKZr+Zliy0N+w6aZELWiyFud1SyqzymBdDk0CFbC6dWrZtQAyb2Tr3z5vu1EUtrByh8EAfh3AVjEHVSrnaih/Nlbe49IOMcLBwAIWiNpmJ9nmoDLDj1YQ688cbha3eQwn44QiSsj0gCxGcgawyAMBAB6zPQ8fS5TGk8FUPwvm154DxcQkLlDAePRVfXn2GNwWr+RULkEkgS9uyMV7nC0G24IhYZr+1gxVc7uZrQnUION2QwyXd3mfT2H01PMxDN0xYlhEQbrXHoWb345eREY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Verify that allocating folios in multiple guest_memfd instances sharing
the same tmpfs resource pool consumes blocks from the underlying pool as
reported by filesystem statistics.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 310a45b6656aa..639b1b0c204ed 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -18,6 +18,7 @@
 #include <sys/mount.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <sys/statvfs.h>
 
 #include "kvm_syscalls.h"
 #include "kvm_util.h"
@@ -564,7 +565,8 @@ static void test_resource_fd_tmpfs_huge(struct kvm_vm *vm)
 
 static void test_resource_fd_tmpfs_shared_pool(struct kvm_vm *vm)
 {
-	int pool_fd, fd1, fd2;
+	int pool_fd, fd1, fd2, ret;
+	struct statvfs svfs;
 	struct stat st1, st2;
 
 	pool_fd = create_tmpfs_pool_fd("never", true, page_size * 2);
@@ -590,6 +592,18 @@ static void test_resource_fd_tmpfs_shared_pool(struct kvm_vm *vm)
 	TEST_ASSERT(st1.st_ino != st2.st_ino,
 		    "different guest_memfd instances should have distinct inodes");
 
+	ret = fallocate(fd1, FALLOC_FL_KEEP_SIZE, 0, page_size);
+	TEST_ASSERT(!ret, "fallocate on fd1 should succeed");
+
+	TEST_ASSERT(!fstatvfs(pool_fd, &svfs), "fstatvfs on pool_fd should succeed");
+	TEST_ASSERT_EQ(svfs.f_blocks - svfs.f_bfree, 1);
+
+	ret = fallocate(fd2, FALLOC_FL_KEEP_SIZE, 0, page_size);
+	TEST_ASSERT(!ret, "fallocate on fd2 should succeed");
+
+	TEST_ASSERT(!fstatvfs(pool_fd, &svfs), "fstatvfs on pool_fd should succeed");
+	TEST_ASSERT_EQ(svfs.f_blocks - svfs.f_bfree, 2);
+
 	close(fd2);
 	close(fd1);
 	close(pool_fd);

-- 
2.56.0.455.g6c5a503b38-goog



