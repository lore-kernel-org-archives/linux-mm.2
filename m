Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04AC2C88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:58:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D40606B00D9; Thu, 10 Sep 2026 19:55:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC9546B00DA; Thu, 10 Sep 2026 19:55:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B90B86B00DC; Thu, 10 Sep 2026 19:55:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 72C8F6B00D9
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:55:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C54011A0632
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:58 +0000 (UTC)
X-FDA: 85199513196.04.509127A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id A46951C0006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:55:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BwhB2EEc;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789084556;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8QsIAWPNTAg5FE1aiu4zTMQx/6RLvT+mKqdGSoHPrXE=;
	b=CJz53jaNqf6fH2Fz/Gt6HKGXrNVihSopQXFN5GTFJX9L/Ga7ZUk5XotPkltBO9k8kmWkoX
	mEMELjpqQ5ybQmgCP6hKjRpY6d58kW1te7VNG6KDvu6EG0KUUUsx3WQPcJoy0+B1AnsOpL
	IVajx1CKhmgRcjf2lBW3HoqqKXg+T60=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789084556;
	b=nuKVdtLC5p2fCiSCzJYDv/rqcJEAs/FMps3fJssaU5qI5iJkleY8zCM9j2pNCgNDDaoawj
	gPaKtTNi1LSjRJsiMmxZg5RvnsoK+y35FZBQyAg8SKhqiDqBBDU9tU8cwJKT0YiUtV7EgQ
	68E/HTpi1QwQwykYaDBZJlB7qcZwJgM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BwhB2EEc;
	spf=pass (imf18.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B439449D7;
	Thu, 10 Sep 2026 23:55:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 03867C32781;
	Thu, 10 Sep 2026 23:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789084541;
	bh=Usdkixf5ZXbmJXWcgS8yG+6vF/nHWR20SmPH+Hst/D8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=BwhB2EEc10Iorm/WNZPAZR0I4ZHX1EBfsClUoUaYMcotfH7ovlxlKxrP0lPxG5pzO
	 ZRiflM2W15HksMVSlEvaY5IwZb19NiQylbZ8ocylDh22atQk0ZTvO3jz2InCWPVdiv
	 N10a0o6TcpBfB3EwJsGu++HFj3bq1Flcx0C2ASvQeBQv89E+g7SGmrRI4C7+vYQwcV
	 KGbLywxDz/u7UB/U0JMWHV9z9FBb9bOEvbjJmWzNmSyzeN8V8k1cATPR0Cyi7ALMRI
	 A3pGfCHZxesneid89EcX1WzqnIw6/GdfFnJwrG5SKJdSAB4oNhSMgRjXFD9uUgpWXd
	 bVGuC4MvkpsQw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E135FC88E4D;
	Thu, 10 Sep 2026 23:55:40 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 10 Sep 2026 16:56:09 -0700
Subject: [PATCH v13 43/44] KVM: selftests: Update
 private_mem_conversions_test for in-place conversions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-gmem-inplace-conversion-v13-43-dd6fbf94f4e1@google.com>
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
In-Reply-To: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, willy@infradead.org, wyihan@google.com, 
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org, 
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org, 
 Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com, 
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Fuad Tabba <fuad.tabba@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>, 
 Fuad Tabba <fuad.tabba@linux.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789084533; l=5729;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=NIpyFLdhCTVD97IHzJc7q0klAWZs6At1EhrFH3ni46M=;
 b=VdkuzOao3BXPsEz6g+Bl53pxZxRFm5vINe9XiaPBHRvNB/A8PTD8M79905aFZgzQOxpka8JkH
 Z4N/YRlKClmBCr44GLftPdOdKhXGHHxvJilv3JeShqHo47T7ay9+H3Z
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: uofedk7ueqt5o814bjpqz3fd81nhfzmb
X-Rspamd-Queue-Id: A46951C0006
X-HE-Tag: 1789084556-661418
X-HE-Meta: U2FsdGVkX1/93ti++kKgivRBcaR05K1wq0NrjpF42D6x80qI/IN0mymIlMuJSDTYu+Y46wHiduf8P7eSr9wgT1I4H2oea90+jQX34ogHR84oqi7hBjjC44MQdH/BmKEkGH4b6barsbZX7kRLZXH82sK/A+Jdvc9iOPTF6DsG2iMnF6OuAVHHGa5IZxgPzSZrM30U1/WNZ7bOLj2cdTcBGRW/S6daNcmkiryU6o2ubGrJ01IwdP9Px8O76FRitRuJCaFUDhy9r9WDFpHhnVqP4jkL9mvmQ/tZqnJJ9BdkDTICBHsMKD2cFbUpUIO6y+fvUC+6Hiu4uMuwrnQhJVN7QOFdCfQnaTRejXiysVcKp49rejSH9JAlusyrDMvHskbpgeWbOSRalrI/L8EScEYhvGwTJJSvcS1eP2IpqFTA/hgGYEBbLN6xP/pyBwtQ+omca8Ad8N6UUwmCkKEjb8SzL//5wPVzPl8clJ3qrxj+71PkNm5wOIOESHkMTgLmfIHIyEwP+Iju1GULUO/XJwUAb04hF5v/phKOFnLJgfrARLuYc83GzEjtGrH0d1MEBz9Q+68RlFFG20fC7wAE4t1N0RFNrDrC2kNBAI+YtBWlSdGUNu11Sjg+47P5E10+1A2uXtfIM3OaXd1P8hFbZ0UeXKvYBaPmW1mqrcGMe/0oPupKbY3WWEyF5HFC6SMkEn2IhJOqMNjLahjOOO8GRwYgD9fjjlFahQLvCwNkOc1Z4UzJaAXHY+GgU0hW5pGTYS04X4ELTpBKTF0DUNPCzO7O/90qZwPes4w/rea5Q4QgBqNmDg7FUlMs4o7nRWGh5jEHgWmyyWICGSCrIvxFNbD5hLNAxa/2QwemmLmUPsp9qcF1n2L65xJckxnDf7He7uIgQMFvkQZCsLc5fPJ4IoFpuj40xXCHBeDVoSWBOwvfg3tPDEfy1DbNDEXONCMxJGTwS5m5naC2Ged8Mlwl4ho
 DXzpuwdF
 rZaWeIzJMuA0xwnZKdD+Qk8MGoukjLe3TT1oja8v8/RGxU+djpX/ROdu0oaX41UmQBZdu7QqynOz3EpzGFyNt/Ush0AGj7s+1hIA4pjKgt1mqn8hEmoc+YkTfdcdpc8+LGNBnZNaQFKxNUA4myB4meN/Dorc8eUhELGEKutG1ZZnqBWrlzQ/vt4/aVCsJKQ0RqqLXpQkoVP+DsdYJVJ+3mj1c+4K3aelFlZbpZ7EV6WmCSYQKV65e1GAkobXVjJxl3v6WgeDkmU0OlgG0dRiCFclRHsKelLSP12aRtZKzcg80k3UB8QhKPFfcvtZXTIgfp09lx7hTHBmLmfMS8Wqesw9quLfwck6kKychyuUK2V3hiH639uyM07w77pxNeITRGkPrSZDvB5baViyGF5zVwkmV9BsKbJhA08/lQ7hWGhUNosxBdLJqKjbtad8EE6OatobQQXZt5XXgaD5I2f+/CjuJxdYh4V74mETka6TMRDf4S+Eh3+QnWzvTvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Update private_mem_conversions_test for in-place conversions. In-place
conversions support is detected in selftests with kvm_has_gmem_attributes.

With in-place conversions, specifying userspace_addr from some other memory
provider that is not the guest_memfd associated with the memslot is a user
error, since KVM will only use both shared and private memory from the
guest_memfd.

Hence, when kvm_has_gmem_attributes, only test in-place conversions with
single backing, where guest_memfd provides both shared and private memory.

For single backing, guest_memfd must be created with
GUEST_MEMFD_FLAG_MMAP. Initialize the guest_memfd as shared to align with
how memory would default to shared when shared/private state was tracked at
the VM level (the test expects this, it was written for
non-in-place-conversions).

When handling a hypercall to set attributes, use
vm_mem_set_memory_attributes() to send the ioctl to the guest_memfd instead
of the VM.

When testing in-place conversions (single-backing), don't allow the user to
configure src_type, since src_type will be ignored. Don't use src_type to
determine alignment for rounding up per-cpu test memory size, since
guest_memfd's backing page size is always the system PAGE_SIZE.

Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 .../kvm/x86/private_mem_conversions_test.c         | 57 +++++++++++++++++-----
 1 file changed, 44 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
index cf50e9a332c5b..33b610383693b 100644
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c
@@ -306,9 +306,12 @@ static void handle_exit_hypercall(struct kvm_vcpu *vcpu)
 	if (do_fallocate)
 		vm_guest_mem_fallocate(vm, gpa, size, map_shared);
 
-	if (set_attributes)
-		vm_set_memory_attributes(vm, gpa, size,
-					 map_shared ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE);
+	if (set_attributes) {
+		u64 attrs = map_shared ? 0 : KVM_MEMORY_ATTRIBUTE_PRIVATE;
+
+		vm_mem_set_memory_attributes(vm, gpa, size, attrs);
+	}
+
 	run->hypercall.ret = 0;
 }
 
@@ -352,8 +355,21 @@ static void *__test_mem_conversions(void *__vcpu)
 				size_t nr_bytes = min_t(size_t, vm->page_size, size - i);
 				u8 *hva = addr_gpa2hva(vm, gpa + i);
 
-				/* In all cases, the host should observe the shared data. */
-				memcmp_h(hva, gpa + i, uc.args[3], nr_bytes);
+				if (kvm_has_gmem_attributes &&
+				    uc.args[0] == SYNC_PRIVATE) {
+					TEST_EXPECT_SIGBUS(READ_ONCE(*hva));
+				} else {
+					/*
+					 * If not testing in-place conversion
+					 * (dual backing), the host should
+					 * always observe shared data, since the
+					 * shared memory is a separate page.
+					 *
+					 * For SYNC_SHARED, test that the host
+					 * can see shared memory.
+					 */
+					memcmp_h(hva, gpa + i, uc.args[3], nr_bytes);
+				}
 
 				/* For shared, write the new pattern to guest memory. */
 				if (uc.args[0] == SYNC_SHARED)
@@ -369,20 +385,29 @@ static void *__test_mem_conversions(void *__vcpu)
 	}
 }
 
+/* Align each vCPU's chunk of memory naturally to the size of the backing store. */
+static size_t compute_per_cpu_size(enum vm_mem_backing_src_type src_type)
+{
+	size_t alignment;
+
+	if (kvm_has_gmem_attributes)
+		alignment = getpagesize();
+	else
+		alignment = get_backing_src_pagesz(src_type);
+
+	return align_up(PER_CPU_DATA_SIZE, max_t(size_t, SZ_2M, alignment));
+}
+
 static void test_mem_conversions(enum vm_mem_backing_src_type src_type, u32 nr_vcpus,
 				 u32 nr_memslots)
 {
-	/*
-	 * Allocate enough memory so that each vCPU's chunk of memory can be
-	 * naturally aligned with respect to the size of the backing store.
-	 */
-	const size_t alignment = max_t(size_t, SZ_2M, get_backing_src_pagesz(src_type));
-	const size_t per_cpu_size = align_up(PER_CPU_DATA_SIZE, alignment);
+	const size_t per_cpu_size = compute_per_cpu_size(src_type);
 	const size_t memfd_size = per_cpu_size * nr_vcpus;
 	const size_t slot_size = memfd_size / nr_memslots;
 	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 	pthread_t threads[KVM_MAX_VCPUS];
 	struct kvm_vm *vm;
+	u64 gmem_flags;
 	int memfd, i;
 
 	const struct vm_shape shape = {
@@ -397,12 +422,16 @@ static void test_mem_conversions(enum vm_mem_backing_src_type src_type, u32 nr_v
 
 	vm_enable_cap(vm, KVM_CAP_EXIT_HYPERCALL, (1 << KVM_HC_MAP_GPA_RANGE));
 
-	memfd = vm_create_guest_memfd(vm, memfd_size, 0);
+	gmem_flags = 0;
+	if (kvm_has_gmem_attributes)
+		gmem_flags = GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED;
+
+	memfd = vm_create_guest_memfd(vm, memfd_size, gmem_flags);
 
 	for (i = 0; i < nr_memslots; i++)
 		vm_mem_add(vm, src_type, BASE_DATA_GPA + slot_size * i,
 			   BASE_DATA_SLOT + i, slot_size / vm->page_size,
-			   KVM_MEM_GUEST_MEMFD, memfd, slot_size * i, 0);
+			   KVM_MEM_GUEST_MEMFD, memfd, slot_size * i, gmem_flags);
 
 	for (i = 0; i < nr_vcpus; i++) {
 		gpa_t gpa =  BASE_DATA_GPA + i * per_cpu_size;
@@ -462,6 +491,8 @@ int main(int argc, char *argv[])
 	while ((opt = getopt(argc, argv, "hm:s:n:")) != -1) {
 		switch (opt) {
 		case 's':
+			TEST_ASSERT(!kvm_has_gmem_attributes,
+				    "src_type is only configurable when testing without in-place conversion");
 			src_type = parse_backing_src_type(optarg);
 			break;
 		case 'n':

-- 
2.55.0.1007.g17ff1f9808-goog



