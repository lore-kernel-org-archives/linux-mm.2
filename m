Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 634A260804F9
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U2NC4dEL
Received: by kanga.kvack.org (Postfix)
	id 00BF56B05C2; Fri,  6 Nov 2026 19:37:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F25A16B05C3; Fri,  6 Nov 2026 19:37:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEC986B05C4; Fri,  6 Nov 2026 19:37:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B53046B05C2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:03 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 644C31401B4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:03 +0000 (UTC)
X-FDA: 85406458326.13.E2336EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5F137180007
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U2NC4dEL;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011821;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wrGLOYvm9qvd5ELar6tPaqbVxAMUuqMJGXo2FtOyYxc=;
	b=4FJsdZxihLI0lq1I32K/OIUhYKTbc4vndh/NvwgQm7rG0Y3PfvJ/5xquxHgTuT9VQqwi9P
	Y5GhBIC5RXOABG9z3w4RtbZK/wvbnVNzp0NQj6XTiSVDvvcnWi02vYhA/EdH4ayrfuedI4
	L3c3OHM9+Vc0ikBy5ANDb4DI8ik7Q+s=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U2NC4dEL;
	spf=pass (imf06.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011821;
	b=lBl6zk1afVmCMMUJGeMR2JrXwRSjEVQ1d1seqKa3P7nYwrLidH764YpPs6eD6u8aS43pq+
	muD77pmqIN3/Un0eBIvtsAPsUNMLHRfci3vUjcplbUHqYeIAGiOyII6sCZHNWCusiO70Yj
	EnbOh9z6R90i6y/v5NPm24w1vNSqMwI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DEFE060E1F;
	Sat,  7 Nov 2026 00:37:00 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011820;
	b=xSCN/H2tptBi9VeRl/s5pu40+GN3JJndgFRhtQ2VhRu5idMMb8E/bs9Ey4vGq5u6uVCt
	 GxEZbRVBgDI4S4peGL6gxqgQt1nGtuxY81DXc2ILhCNxB+lFNgdK6op5spMXxQXumCZeu
	 CemOuS5XgoXU76TVc5PwhsMg+ABYtuc4gC2Clts5QsWcj1xNsYmrXG2+Vkdw3l4/EwPDe
	 stM/gaZrCQGg6Ly1F3fdqiVKQhmDawx7cekAble5edA5ymxSS6nFtuZ0ntXTLWnrVEQIc
	 pFIANzGeGeIy0Kc7GeEC7j2rhW7YYdz5ZIXXzEngtycc4O3YtlVNBsYGrhrjxWVd3kA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011820;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=wrGLOYvm9qvd5ELar6tPaqbVxAMUuqMJGXo2FtOyYxc=;
	b=TXMA06a5WBbQVQ/rerFnUutS5vcZ1EC+qc6CwaJx40/E9L96hf3ycpL0aDNafG45er+3
	 bBBNzkJK0SmWc7KOCnb1nIum7Y4UbQGDmHD+pEPcf3Rk4ZzzosZiXChtLhyiSyOiirAny
	 iSNtwJKmpD0zT95a5FGeATwcbUpGAUGvGmn7CFsFlSbnF0d8wHJy0gmvHNN6/F8K+OykZ
	 BMFUBQhtL/APTQ2R4vC89fKde6gw9IQV1QnN/6jY060+kEguUyaFiqZrMFDnAiU8WIEJ5
	 H0JvPrr2qtdHGAqhCMb3J3Y37oPqAMgeAPhocOdvldU3Qakb7uNeOMhA3hPSOnW7G6g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 2402D1F00902;
	Sat,  7 Nov 2026 00:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011820;
	bh=wrGLOYvm9qvd5ELar6tPaqbVxAMUuqMJGXo2FtOyYxc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=U2NC4dEL6duTc4DI7Rx8CpTjKr1bgFIvp6cMvsmuO5xlCvacLsmJDYLpMeIkI4Tym
	 RuI3058XLzvMVW8Hywjusuu4wqmE/exCqPJggX63dfK/hBCiW7PKisG9el/aKWgB/W
	 rpaQxtPb0qRGsl4otS+lA4GkJ4rJsVlSrOaL7kioAZtELcsNsAX7AaarPZ/l73+Kh2
	 SpI+HlwG1lr47avkTvBuKQAAqjZkXtjkyml2xqqAnjo3j2171gK6Lz5zhFmbjjBBHU
	 c9eHTGTowULC655OkfwKdmdtGZXDh2TBtnPUfsDKLtxodCQwa6JzC9ZpXauwbBHfGg
	 WptigzRrRqFaw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 2856F47958;
	Sat,  7 Nov 2026 00:36:54 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:36:51 -0800
Subject: [PATCH RFC v3 17/88] KVM: selftests: Test guest execution with
 tmpfs-backed guest_memfd
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-17-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=2755;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=fr8rPkSzXLy1+7CQ4/dHoHPzEtH6SGICpYGF16TSzqc=;
 b=K4Phfaq4Qdgv8seGNPs3X+5Qw5d2T5Sa4NEyiI9XKn3pL0SWjZvjc8r3+b4a+mTomWCACaDzQ
 D8e2EDdfzkXAPLOc3KPgJwp9uTi2kMeJyUw0cg+ragVcNp6ain34P8n
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qiu7fzsmgeaxsaryys8si4thq5zfr4oh
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5F137180007
X-HE-Tag: 1794011821-239694
X-HE-Meta: U2FsdGVkX1/oRx/STGB/nak/jvNeVeQ0Zk6VtqdWtQGUFJxpy5qJ6OxK+6YenlPRt9k9tETA4HF/Jrlz8e3G5/PYkMdkullHBmdW/243b0CAZlHlpmt9MU/S2kLOV19ptxUCuFJwp8vDTUY/TCZ53EiBa0zQShOka8SnyPC7JKT0kGwLdkL6KC0qHn2U2+R5TNZGh23SVCs0jjJXaKkxTjk9hvKUQ+eXMWzlixSq6CuCkB6Lz8qyw3M+qCbCvt4QQUg1cTZQzH/iE+Ay3o/LF9EMIZg/FZHKuLsu4Uvpl5PsfERuQmmscDpcyRoY1FDQC5MdZlXnSyGb7JJLoPa+Rn3L5OH3F1Sc/HDoMQNGG+xxSikStp6BYlnC04Xf6I33B2hHCBva/AyTefCZpeABQ1RqIVlODc/G/AFjvgxWRvpbnWRxeon6ls64GdqEiukZaSRL0XPgK5h1I3nc2Lah+/CB5oh5t4Zs7aANlgIhe0+Qg5Agc6HNtW8CGQiCM2xmrhESYjlP8ogG0KadOHytKKbDa0DqgrP/pLD5b0FimM8XE/hef77aagrUL3X19keihDyziBYxxrfOf7kVfn6je//xvnfyvtj9CSzkCAHVz86AG3mC0vsN4M1WYpwkVCrhF2RMqxOLHhn8yaSgLK4IhnjZJueaypjlzXxE84YbFzKQIktA0ocBaIYAW1zur/AqoXTK2cWth9ZjJHx2P2TXSnoAgD2xSSznWIBpvOExNG5Y5tFOa3U0q+fy3dayv5CylqZ4s8Oxsk0NEo1XxZvYfBzcWmhq+NRbOFMnwbcBAu/efQO5YHBcyoIfguVfElRuBBt5J0nhW7nnr1/HY4NtHWZCTKu9/wpAqfJ+S8weIYbRdB0+sXBKdlMjt6ThXN/yCgPuV1jBjI+pnMVFHLuaARO6L/ZBVxwFUo72kH/+ALe4I2ePvuq7XgBhIsfBj1QPMm1uOLjMrBxADLfFznU
 1bU9nta6
 sb6UwI4vW44xuIbOcv0sU+9hve7M1xULcX7CtB0CMyr6ZTuF+vy9JeqWFnCyqhkHdmQalj7MmH5uqF+IB+dPpN7oY+wode67uOXzZxA0kbB1hhcOlEKTbIhMMgSACKQl2dQZcb+pkxYvUygVWMQAHq3pWwn/zAew8qlvD9ZCqc9Zk95jB6cYD1SxHlypvEVLp+qFHMzSPHAAmRD3P8x2ym82lOZ7Rsmk4na+5K5XabJ8n1qbKnqvimclBeM/HIkHVpCeMFAyhkUr6G388xn9QFFwoQ1La1qMhzsQ+bx1mmhDr9jt5QAsrFDeY6gAfJ8T3l0+y1x7TOayE6clXWFCBlHYroEyFfqLU4gWJvxgYkRLXOSfMv4iKKhpXZ/fTZr1TbU2hJTjSfML0Nw8zTihnRGk1eOvGTPkokYRff7T87lwbJUtH14FVCRSS9VZnxKEUXVOqanbQZ7o+9weT+mJkbdpXvtvOjx/1yAX/N5HkMNWxgfXbUcO8f05+5ulyApI5awoxnYkQ19BVluCdr6okJy/ECZ5hGocKZXw3AN3cdtZqY0yLCd0JQyNoJyw0fQ6tblEiA0Gtwk6gg8P54yQov235Iy4Qn5MuDwju
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
2.56.0.455.g6c5a503b38-goog



