Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A807C9830E
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 00:51:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EF956B009F; Fri, 25 Sep 2026 20:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B7A16B00A7; Fri, 25 Sep 2026 20:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A63C6B00A6; Fri, 25 Sep 2026 20:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 363096B009F
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:50:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB91F1207C4
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:57 +0000 (UTC)
X-FDA: 85254083754.23.3DFCB6F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9E92D180006
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p3N1YqtV;
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790383855;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LnWtaqsR9ay+yB0H9mxcBETpZIU28q7eVpkiHaDo3RE=;
	b=gfU7ohyNxGwrGkM73HDjs0ydPdx/AprHL/xD08SbHAa3XzQIYKx0NeSy7gbL7KGRYO1KYO
	F5MnBtYec9KnTQ7GZ4d73odmhXEW55xqhIpCuLep7b9tP6652E8rS7z/lvrjozDyB+Zjxy
	3qRQWfUE5R8pCJj9SfOuxJ2gQhavuxg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p3N1YqtV;
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790383855;
	b=Nx53gQVGOQKOr+jOzoHVfkzKE2OH5SvEnF5IQ47Thd5fbJT2oy9oK09h8vkTOoWK5IB2we
	W0m4MJ2A69Thimjwsuh3xnUVBICJHtQ/o+fsR7khj+ySj/85IMcBpOPR8LwmYVIC5uEwd6
	330RXH0UjhQXpcBqzUD1lD9e2gOgsPs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D8034480F;
	Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6A039C2BD04;
	Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790383852;
	bh=WL6SVj5nkt1VSLicwCms+MFdPTGQsPTJ4cFpwfrA8CY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=p3N1YqtVRuIgAdzCdcKxpzfvc2kPcvmzPpbElcxGhXp0FJV4hAHtxSuXWUmNNgveF
	 J3AclXs7McCNXymGq7Dmscv58eNZQ4hNFzy3Hnc/73gXKQeu4XAJkvhvPC3iIrlqDH
	 1yrixPqZMbS9sC6RT/IeUGBS89GPJZEg5IJOY83AItfv0l1lgAglGxFQhG2MI+rH1+
	 hDY6ZGlINlN+7Xzb84vjexHtM5+Z5AVo7pcfHI9LtUrUnfQQyca2LaT87CnCMfxhd9
	 O5DH/MaCVQTfkI6yASvYueRy07tyyfZis1WbZsaKLdJJAiGOCa8OFGg1DBt/sbIjqx
	 Px4xJrqd1DyCg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5674CC9832F;
	Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 25 Sep 2026 17:51:03 -0700
Subject: [PATCH RFC 16/17] KVM: selftests: Test guest execution with
 tmpfs-backed guest_memfd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-gmem-tmpfs-backend-v1-16-d36159822d18@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790383850; l=2762;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=eEUCNuv+RKC7m7QsxpNwXumKz8ugTchjMOMGNl/2g/s=;
 b=A4r1WBbxOP9ZOlG7QCGCgeTR0iYmACXawNF2ydSLaVCH5b3ki+XdoPlrDcX39UZFv73bZqeB4
 75FNsbJvLzPAAoFskLa0UlxlDUdH77Y2b4eHQ71jrqFWXwLRW9STmEN
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9E92D180006
X-Rspam-User: 
X-Stat-Signature: 616h6hbsu8up6o5w1waes35c6ykdxkba
X-HE-Tag: 1790383855-728252
X-HE-Meta: U2FsdGVkX1+Gzv0Qeld0wfmX86QMqtXWgmAnQ+WoYeGyG79Jj1N4nyqXU/M8zkyO6NXTrUv8FnrmWtA7OVM3Cds3+j4ajASDIsNqa7i57GtfBX/K2SiuvMcFBrXHTC/cqd/qYrCn0yjH8hYZOlEBIlSYN2lQeJO8DgInoOiUPUvIG2mjp5sXbGkeDi4KBug7lMLYRcRBPM3XYDP65GmEpWKJxtErR87Y8FoojfV9RtdfQLzhnqW06xk1AgCel3SsxooLcpNDD0cPIb3SEdRCrHzg+RzmCKygI0L8QkNFBE3j7//Fjp28V3J+1FHXGmXsyeWtMhB+wmnbjmaohmfItx6aHqNGt3b9txoJxj1YuMJTq+cm7p1OViK59jP//byDzOfQsc8/cUIpDyDRbO7hIPPbrT0hJ50EnhGVtylYr88r4vxSvEB4qFm22PYCIGOG3jjTDqTNQN/jlI2mZHX17CiL2e+6kn3YTAuMTJWxNplyZIchPGuPQ0PT9FDt8Q7UHRDadasScj9zOySnoHooUCI/Rg9TfMN5GqkyBxYEIbXoAUzNXnM93M/rEkeSI7I4otpEwGxYaNwqmWI356uKat6FV5UzXpuuJmIomW+oDpOtcPR1CdEmd3uE7MFMOHz5sBLjGymYd+m+TBmaknX+wjEi761hP+h3voEol7A/cYHDlVukuhNlhCoC3/gpBnP6C95a1+7yGmGGanVWEVJ5BOHIfB3hdZHGwPG0O2UdCQ5dhxbGNy88x/BU3Htibq8lXqdXAwgPgjRzI+ttFcRbk9VH8v4vfQN9yCNE9vNPpCGwZxIkGVbCsqDurD75uYfSAQrF9kq4h1Ry7HB/JO3QnSEDSnXgnyQvYuq7UMQMOKm8Luc096sCmkRtBFUlMJMmGq+Zfm7jP2sAwbFaXBE9K4cCk3S8kY9Sm6K6aHz6q1ahCARn4jpkYIpuy7rYyfd1+b5XCd38QcOPev6W2vx
 3LGrreUi
 asRF5X2kXMxI1j+FsJ0KJoY7nf08l7sQPZTJA0HbqNDZH4EBGo4uty9cnqI9+iUwR58RNgxa7MQuJkmUvNeAhPXk38zmTqjINAhoddGk44OQqATLUUSev+N4rRLwvnAb32moHgJqA+bFLE7m7/eqNhHArSXm0GMR5xQE3oVG0+l7Fku7TzmLfdE1yNKBQgKK/GzG83W4oBIx7+mkU9UFXMoZMj9SSO0YKsCRdoUVH27WiDbCGgLxMEQIzVZtsBTqiL3wvPxfYNlvrAVgWVD5rBe4TJRt+GExHlclKBR58PeS2xgYzXtmWGOSNtFsNP+FTSlHNmVb+qpBzK5i4vdLcU9h9Tqme5MmtJpTNp3lpi48Q0cq/dsmN8GH3pWXQ8r1ZQ9CuAnNg9AbJryZdZQvCZAEs0vIUj2qIWWwHC503bAUyDNMLrAb4Er1K13nyjMZoyb2SBm7/3qAIw3EzqwiO1wGgqPsIklwAhJZmAfAA8iYJWvT/ZspVwVmlsKmMBmaUeGe0Imk9Zm9Ifaz3FVQNQfHZTbKX853ni5MX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Test that a guest vCPU can execute instructions and read/write memory
mapped into a guest_memfd instance that is backed by a tmpfs resource
pool descriptor.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 57 ++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 345b41c912a18..bf369874f2647 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -829,6 +829,62 @@ static void test_guest_memfd_guest(void)
 	kvm_vm_free(vm);
 }
 
+static void test_guest_memfd_guest_resource(void)
+{
+	const gpa_t gpa = SZ_4G;
+	const int slot = 1;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int pool_fd, fd, i;
+	size_t size;
+	u8 *mem;
+
+	if (!kvm_check_cap(KVM_CAP_GUEST_MEMFD_FLAGS))
+		return;
+
+	pool_fd = create_tmpfs_pool_fd("never", true, page_size);
+	if (pool_fd < 0)
+		TEST_REQUIRE(false);
+
+	vm = __vm_create_shape_with_one_vcpu(VM_SHAPE_DEFAULT, &vcpu, 1, guest_code);
+
+	TEST_ASSERT(vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS) & GUEST_MEMFD_FLAG_MMAP,
+		    "Default VM type should support MMAP, supported flags = 0x%x",
+		    vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS));
+	TEST_ASSERT(vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS) & GUEST_MEMFD_FLAG_INIT_SHARED,
+		    "Default VM type should support INIT_SHARED, supported flags = 0x%x",
+		    vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS));
+
+	size = max_t(size_t, vm->page_size, page_size);
+	fd = __vm_create_guest_memfd_resource(vm, size,
+					      GUEST_MEMFD_FLAG_MMAP |
+					      GUEST_MEMFD_FLAG_INIT_SHARED |
+					      GUEST_MEMFD_FLAG_USE_RESOURCE,
+					      pool_fd);
+	TEST_ASSERT(fd >= 0, "guest_memfd with tmpfs pool should succeed");
+
+	vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, size, NULL, fd, 0);
+
+	mem = kvm_mmap(size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
+	memset(mem, 0xaa, size);
+	kvm_munmap(mem, size);
+
+	virt_map(vm, gpa, gpa, size / vm->page_size);
+	vcpu_args_set(vcpu, 2, gpa, size);
+	vcpu_run(vcpu);
+
+	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
+
+	mem = kvm_mmap(size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
+	for (i = 0; i < size; i++)
+		TEST_ASSERT_EQ(mem[i], 0xff);
+
+	close(fd);
+	close(pool_fd);
+	kvm_vm_free(vm);
+}
+
+
 int main(int argc, char *argv[])
 {
 	unsigned long vm_types, vm_type;
@@ -849,4 +905,5 @@ int main(int argc, char *argv[])
 		test_guest_memfd(vm_type);
 
 	test_guest_memfd_guest();
+	test_guest_memfd_guest_resource();
 }

-- 
2.56.0.rc1.315.gc6ed9934b7-goog



