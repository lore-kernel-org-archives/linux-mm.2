Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B25CDC9830E
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 00:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E7116B00A0; Fri, 25 Sep 2026 20:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 119F56B00A5; Fri, 25 Sep 2026 20:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E84D56B00A0; Fri, 25 Sep 2026 20:50:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD5B46B00A1
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:50:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 37092A07FC
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:57 +0000 (UTC)
X-FDA: 85254083754.12.3F7D7FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4459420002
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:55 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nT+Xp4PP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790383855;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gyDmcxSvyBaR+YW8LqEwxFg3KfWGCKtPA9l7nROs800=;
	b=BeaoQyZD2Puy1yOvlcs/m50xvytRFR9lPd0K5a/TTtwGahcMxsqgKOkJltua4vYIp3q0hm
	v8gqiQLficUpmRXfNi7qWvS5+n+hYJaM/9y2bJdxjYOGRspOC+8AkN1i3tXU0eK9UU4fpm
	ISH/EVsO3ZRX9GWgcu42bcKV5CdgP0M=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nT+Xp4PP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790383855;
	b=CtBDhUNLeNepMZQhUgo9gbk6WoqV5ePZQvzsGDflhbeUjzi6tXJspCx34bCrV+7RfV4esm
	QosnEilagWmnWSOS6SQ0C0oi0c86FboVUKIbjnnEKDMmq5FiZivIMG7jjKKWTPxn/+3+ej
	GhI4FdZ3dU1xMQlFDpr4tALp3zhxWog=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 56037447F4;
	Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3280BC2BD00;
	Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790383852;
	bh=21HvTorctO9Ssbh0Oo7al0KxPCcL6KSYRxge9z1lWjI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=nT+Xp4PPn7TD0qgto83K2t8IPOLi+ZqTR9UuqPt5672aUH6W+UPrO+22zbdwsgXdk
	 AZNeJJm3SNPuuMgG3HlyLMHDRFuNc4q3/RKd+1hLVPkltnxDOfW2XZXp174+ECz85S
	 lSTn0jbhThJ2JwyG0TNMvsF5nqamUQwios197XH0S0Sv0z/FmWiVoi3N3Q75NJaR0d
	 avaIKb0IbBX29V3pVlPyGO6SnIcPC6T5MbgTyAvsi0tTWje60YS0THvJ7jV902tobq
	 mv4kVtLjawwEPTTWHohKFOirN/Z3luZqGKvq7p0n9UiZliBH83uTqMaDPRELbdO0DI
	 c2GdCdWJtaBqw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E683C98332;
	Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 25 Sep 2026 17:51:00 -0700
Subject: [PATCH RFC 13/17] KVM: selftests: Test guest_memfd resource pool
 sharing across instances
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-gmem-tmpfs-backend-v1-13-d36159822d18@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790383850; l=2284;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=9LO/j7yMhJpTOm28buLLSDSKy7s9Zo30YgKsCsYGTTM=;
 b=mVJcR7vvGiZtoLCGnt/0t4woHxKz3scYXOvAZ0LmNrLTf100ewNFL1vp2GLk6dll/4KmKlQAu
 u/BbjIypF/ODnW1Uifc1XQ2DvUviguno+Rtw2F5Iryj6zwEtjtmcb9u
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Queue-Id: 4459420002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ntrwk8iksqfipnxwxb5eiqbayynoue6p
X-HE-Tag: 1790383855-609162
X-HE-Meta: U2FsdGVkX185PQzlz1fLhC4rRAPh2huWHvD4Jo793iBYTh3447a7F4G5rI1webIeHvVJzIX0Sso0uFk1tVCGyZ0pEoMM/l0rG4K6zsQUTutRSwAK7SlyJoAkW8EMTMmnSFmkWj2HXNo2DMZYqipec2oFuN9po0o1m417+0FuLHmzpm7PlffYLQyebjLEtYcH5f7qeAd2g2eqwpZiplcc9bgSmpTO4vTno4BZasSx4WURnjszqk4OUcYEqBdqmw0hsAUvm00b5w2x75lf2IB08vnGqUqVcYCBP6u8GgGZnMAMyJlDrzfx72o2OLoTgFnxn0J/XX2qaIdJ4yeqJ4U0u7AaELdGIpZGZGPQi6Og3bB5d3j0F/jvi/HiXl34GQVDDFgEmdNMhFixWIBZqs7zsjx1H1imlqJ4VghfI7pTnOIfiiwuue8j2IPJwaEGFDOdQekDqa0Dh+EkFTZsByrvC/CfKOIQ+vSHFTxMD+TGD2R8Ckb1VNa+GQN6PoT0Exlfu+6sUEsqo27myFLEC5qHl/XIACjlQFpsMFy5G3m0NjRVWKTFr6aJzvrLmd68nb2ItE3IIjkmeXQGjVdj6xk85skZJ1B2OpTXb5+GQXKURNN4fBiYELENG0nY8jKOWoOBN+P7N9PDxm4az20X9CoXBuaeaBGJDli0Rl5YAzFpnrqY5gbVU7uNCJOVouQIXVssxR5C4pLJ6X4FLNolCuXVyOZkD964qU3rSyKIHrrCa4ctd4dGIl2TeS7vshmcAEr5v0Wlbs0DG/xiuNurLP5JCy4y1aw3Se3tzbEtolzJ3ddkY0ITDt4E3KHbabhgVLFTRGmu0SZWNpL8rCBD+lM7nuHyGIQ5Rtyy+y7xRoZ0vfX2PZsHlwqOXBkEVbYyk0+bTM+DKPK8M4NlQmkr7XKAQpyx30VO+zM/DovnVN6Sju+gF61ubUVMO9JCB2Vl2HUId/KsY1+Mj0FdI123fCN
 RKv/yz9l
 zJKJSt0+qFADP8bZBImsSHEeoEQzqYtZFrwci9bSJQZN7ghw06rX5zhpI6QJfdw4shKdVjFwC4hTL2ToqP9aFn+YgDbgj04olf1vA0oIKH7UHZeK70Hk9PZOETGjHuRpTTB8SmxoETf3EGa2bJWj5DhBkOeGWn6v0koX6EeQtgBvEJzH2TR2swAhyKwci4T3anYDhuowDVNf4+Pb8O4P3acodavI4gqcrkobtmoYQLpskNw77BF1W73Arsg1bA0vaB/n+ifB4CmkNzJL5ZEIRKNLxsIIUq9dR9L1K9VEi6C2McIppo9P53Yq7uuLbUqUHrpHMXOE9Jjbmf4Xb+ztShhNaf97zQcz3ZSlQSGwwCP7bku4R0lAIY4PgCk5T6b2JqLHxlTRp37q6nGB+526hUKAeCZvN+M6bo1fnuViZ3He/EvIZZZsMYyqV+knL3uu0ZBtImvN8KcPwR+2Q/0gnw4lhZd1z9WJCDN017kfUfaqXcmRmyRHjayagdlPJ6xbOHsshhVK6qdcW9EXYT6Jr/UUtgkrn0+o6MEiI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Test that multiple guest_memfd instances can be created backed by the
same tmpfs resource pool descriptor, that each file descriptor reflects
its requested size, and that they have distinct inodes.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 36 ++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 94ef64474f2a0..81311be059923 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -543,6 +543,41 @@ static void test_resource_fd_tmpfs_huge(struct kvm_vm *vm)
 	close(pool_fd);
 }
 
+static void test_resource_fd_tmpfs_shared_pool(struct kvm_vm *vm)
+{
+	int pool_fd, fd1, fd2;
+	struct stat st1, st2;
+
+	pool_fd = create_tmpfs_pool_fd("never", true, page_size * 2);
+	if (pool_fd < 0)
+		TEST_REQUIRE(false);
+
+	fd1 = vm_create_guest_memfd_resource(vm, page_size,
+					     GUEST_MEMFD_FLAG_USE_RESOURCE,
+					     pool_fd);
+
+	fd2 = vm_create_guest_memfd_resource(vm, page_size * 2,
+					     GUEST_MEMFD_FLAG_USE_RESOURCE,
+					     pool_fd);
+
+	TEST_ASSERT(!fstat(fd1, &st1), "fstat on fd1 should succeed");
+	TEST_ASSERT(st1.st_size == page_size,
+		    "fd1 st_size (%lu) should match requested size (%lu)",
+		    st1.st_size, page_size);
+
+	TEST_ASSERT(!fstat(fd2, &st2), "fstat on fd2 should succeed");
+	TEST_ASSERT(st2.st_size == page_size * 2,
+		    "fd2 st_size (%lu) should match requested size (%lu)",
+		    st2.st_size, page_size * 2);
+
+	TEST_ASSERT(st1.st_ino != st2.st_ino,
+		    "different guest_memfd instances should have distinct inodes");
+
+	close(fd2);
+	close(fd1);
+	close(pool_fd);
+}
+
 enum gmem_pool_type {
 	GMEM_POOL_NONE,
 	GMEM_POOL_FSMOUNT,
@@ -673,6 +708,7 @@ static void test_guest_memfd(unsigned long vm_type)
 	test_resource_fd_tmpfs_file(vm);
 	test_resource_fd_tmpfs_swap(vm);
 	test_resource_fd_tmpfs_huge(vm);
+	test_resource_fd_tmpfs_shared_pool(vm);
 
 	__test_guest_memfd(vm, 0, GMEM_POOL_NONE);
 	__test_guest_memfd(vm, GUEST_MEMFD_FLAG_USE_RESOURCE, GMEM_POOL_FSMOUNT);

-- 
2.56.0.rc1.315.gc6ed9934b7-goog



