Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D331606A74B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GWEffl76
Received: by kanga.kvack.org (Postfix)
	id 8CA0A6B0A3C; Thu, 22 Oct 2026 19:28:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A81F6B0A3D; Thu, 22 Oct 2026 19:28:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A5CC6B0A3F; Thu, 22 Oct 2026 19:28:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 30F076B0A3C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A5B334033F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:10 +0000 (UTC)
X-FDA: 85351852740.03.01127C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 89708120004
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GWEffl76;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711688;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A1G1Rf9O2BcjH5Ek8619fSE6q5ICyMfGfc6AaIv7KWc=;
	b=lEyhLNN9vONU86IEQHbC2Uy/d9rGyqVgS5IJ44SYK+DsEVXnT2WQ+lCtbvAvzgxNiVuZAs
	1yMsb1okJbWxbS04WZQKxMV7OPFlOsPJbICamog27oaIu9o6QV1mfHHCsT+LVaq+gNoSG1
	hQncp6c41PZsIx6jxA+zAhOcpzClXp0=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GWEffl76;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711688;
	b=xwEFVIxzjgpgy94vkMDMeVLy7sP2NNZwWe4b1lAKBryEAc8n8MJY0jYQ6KekSKS5uEvQGR
	GrDjLY0uVl72nJkTIL1eoLiHQysFYHtOPjrn4/QNhZI3EaxrbolMuKSpza5q5jpBA3KsFT
	1FrQZKzFzApjm8rQRDwnpvI4SzZLpas=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 400D343602;
	Thu, 22 Oct 2026 23:28:08 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711688;
	b=MwmGHrSt1eJMuBBBulqnE1bWSoSCJp1yjqiE1FtTi4euGZrXLoSRqVgGVenBu+uFpdVF
	 QMNnRFqrnjBSRDIzzgHW/UU1/HzYqVFLHn3fomAzJGUuhhjsIwaytTOsgQIUy8krIHzLu
	 Z8XRgIIAkhWf81wDq4nIAErqAz6GdTDfUx9a5/1EkwGH9FRQhs9AbWkQ0t08bCtHlGHko
	 DtCss9ZW9BBiy8trVfyHoSMWz1hLwczHA2DXkhlBigxt0hvBsySnshCmk25T75RMW5vaN
	 YVaVEiHG7vZYrdUk9a0A73e2/u4wC/OZop0zc7XF6yNP+5bdy5azKjud10xL1oHFGSQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711688;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=A1G1Rf9O2BcjH5Ek8619fSE6q5ICyMfGfc6AaIv7KWc=;
	b=C2sOJVvJh++jf+Kox7SO9iASpaLO2+WJTpWTM/8Y5IR6F1k28s93JSn9a60ckmN8R/Gl
	 aMTgOO/tg1JSSPJL7XGwjyQtUOEZsuUxUiYnDUlBS/EeEQBwDNeLbG7gOK+wrp/ivF/nI
	 XQk/fRMI8R5vJEfrOeqeBiDJWvq5KBikwBlX8pYJBj2gzHZpDsMXcSHtPO5l/mSVgJd9a
	 +oV+JYngat++1sbc4t477plPBDERD6rnnmtf7mk2vifaDgkeaWWW650TPkzDhKMG5J152
	 sg17zYZHUvQIgGhkdVzqUgdd6eIJRQVA6Gf2+WqC2ac+XGTD2MJtG+3pPmmsOcKlBRg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D34AB1F0119C;
	Thu, 22 Oct 2026 23:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711688;
	bh=A1G1Rf9O2BcjH5Ek8619fSE6q5ICyMfGfc6AaIv7KWc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=GWEffl76SBhdGZp6Tjxw+CdTc/RVflP5XJVPPI1gIypHV6RPrNSNlNxKOwu0HLRLR
	 zeApewmaH/8/h9x+oSK3en2gX7TLz0rwAGV0t4gItJAmYD47cSRI/6SUONtFsXnzAV
	 65SaOgtTRC2bzwEUmhNypyxr1IpBxW3nWJb3iFrsg3Wz7KK5oMha12XMeoMMGjtkN8
	 LqU2SZj8YPholGtjtMgCWBL14MBw2S4aGbkY7clv9rro/WOfF1HsWdSssacTQ80Pd2
	 7NxV5jycZDIHJYmqvhvx8xVVY65xX1rwZyTHVxYvOKZiERI3fIDpwia0WmH50Wo7GN
	 TnLBCKd4YQ/Rg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 1464042087;
	Thu, 22 Oct 2026 23:27:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:27:49 -0700
Subject: [PATCH RFC v2 17/50] KVM: selftests: Test guest execution with
 tmpfs-backed guest_memfd
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-17-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=2755;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=N/vFySqhzz3dW65J5EFhyRFk6LB15JoXBGCroknEhCY=;
 b=3+azDMpNzGZAiJkCGhllbXDoBCpuaO/CIda4zJwz+p2iQFNCnYOkkJsCYKEeJ8sHTzGm/Ysn5
 3a9n4kDRMwxBk2Rd61BgxYePCJBJJicbcrt0PQ/kcPF9PlmC9M9qTi7
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 89708120004
X-Stat-Signature: 86h1k891ngx8c9b1dbytzt94yn1z1fh6
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792711688-835170
X-HE-Meta: U2FsdGVkX1+vN/WpP4TfEB9vbdk28i3Lc7fY25AEg8bgZzaIcxF0RWfC1f3FKWtVLHCKvSF/N4Lt6m2VcGxAA095VYjAaJ567GwQXSU8kOVBPMn521TUsPUfie7ESwgdZy7Uloy/YevWGfQmgBbtfLqs4gFVIuGqR0k/g+zUKclLlEGqAgKJ1IpJ/ovg0igqzCaRliSUvlHAf/uHASW5KhT2waJBFxY3DMLtd1vUpEoh+k1rZfzdMVRBRAc9sChWwC7iDu3QMcGYxsAnoz1ZBuqydbfxjOOeXWXFt02X4HVeEeKHECNFuFlW8Fud+yLbkhMAvYP9zwh1T1FP8Vt3z4p7BkpPtSS+U6/8grJBi7M62ZhjvXhs6+J57bDybMTWwG4H9nU2zD0/3ysBUFNRedtN3T9OlewL4nD5IYlW7hWXBxWx+Y4/rcHBYV10AFGKs7rr8ULE9fhnEXNsaugluRhtFCa8pZqxQk55PVfxhAgWcL/7629/DIuyznRunt7V8IK+kWnVF+N6CF0Wg2aQLTTjQnFZRqyu0bKY1jbLERlzgsCUn55b+8C9tWd0N3rS98xYSMLeIqkqoh39fwUfhmQfNwFelNDVRfdKc2NsBGzjY5v6F72d7FCG6T3sEgMt+iQ1G4y05slB4myBmMWUnYdAJnLge7oneWCKGps31Btpsnn/CjCYAmYldbtHO2Y+itrW3wvGjmOQVfIltQQhvivlF4r2X0MSQquRltZMoFEk7cB9rLsELAEF68yuvGrFhcVofevlt+EPXAk7rAK7CKbSM9cFj0bwR039giXyThOnfYh2XmZgneWi7S9H76YX4/D/iAHnlgop5m0DQ+Ak2idY+nk4EnreugnXTZ/1p1DmHL/ZxUp3DCq4TcIc/T9Ceukd1X+ih84pZ8Z+/4v8YnMstp0IiPcLrU2kyDaQay21Gz+wxNvMShcW51qIihNSZY66dVZ3Eprl8dAw0H0
 JTtRuQlk
 UA/NVbZ2PZ98FiFcHPflKVIYub8RG84znp0WOhnJRI2GW49HRwbfjR72rEx41NpjTTRJh8jNi/vcoTmDN6qjHl0l9h5PyLbKvXZ/CUZXnpvPSbRouB6jdVNKlAntj/4dOQximGwQETCfAe62DLk+eWVklb0J0jYBlZSq3LfJm0KiFQm9haNMw1sBwCxzXY9GCrQBH0ox9IfnBqOkNEROJjMloLzX7vbMfC0PAi1awHy0/19Lv324nXtvrwV23OkAkvZaJU7dLBgdhmt4scdFER+SwGOTrbT++SBJA1qQfkzdcAyu4wBHza+3A+UzsOcg5+GPAwcPHpX8PwTNe8wo6DHfxw1X3x3kF5xAgz+RWRxEOL3TPy9+z0a0sbXk6pWCF6QE29ZBRsicZxdrXKWVnp7hHhkmf72s18uiUnl5orovPQ4ss1TEzZrfU4thiurLzgr+a+587z/falZzf2Iv7iudasd8p8derGyCHI8DfWoq9TqRlN+997WqwYTg/uYK8hbERsHayyoNbSQdZNXqkD96VbsOMPGPKxPySu6IksMVK6HzJqLwZ9IPyX+9Binnuv7X6k3SByehbnkCJUBJCDi35Fm2h8R1AlULVUpty/39fCwI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Test that a guest vCPU can execute instructions and read/write memory
mapped into a guest_memfd instance that is backed by a tmpfs resource
pool descriptor.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 56 ++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 20de24ad535f1..8e9261db23354 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -799,6 +799,61 @@ static void test_guest_memfd_guest(void)
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
 int main(int argc, char *argv[])
 {
 	unsigned long vm_types, vm_type;
@@ -819,4 +874,5 @@ int main(int argc, char *argv[])
 		test_guest_memfd(vm_type);
 
 	test_guest_memfd_guest();
+	test_guest_memfd_guest_resource();
 }

-- 
2.56.0.257.gf7497c7d27-goog



