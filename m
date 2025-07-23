Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27427C83F34
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:48:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96FEA8E0019; Wed, 23 Jul 2025 06:47:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91FC48E0018; Wed, 23 Jul 2025 06:47:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E7B78E0019; Wed, 23 Jul 2025 06:47:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 685048E0018
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:47:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F9585A1EC
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:42 +0000 (UTC)
X-FDA: 83695203564.30.926F469
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5B4EB40004
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qk58u2IO;
	spf=pass (imf17.hostedemail.com: domain of 3yr2AaAUKCJMGxyyx3BB381.zB985AHK-997Ixz7.BE3@flex--tabba.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3yr2AaAUKCJMGxyyx3BB381.zB985AHK-997Ixz7.BE3@flex--tabba.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753267660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d5hGo3nn+2nj2a3HbRALDwA7qk9YZQrlMbSjM7BcAIQ=;
	b=4J9cfZ/f03yOtBkzlz95hdIw8CqW3uR74T5ifIWyv9IiKgIDMXsU7IxfzTfuKmqIye8cV/
	HImHGGYU1OD/TgbU0lUUhkGiWduQo77KZP/x3cleCEG6T7AdUDd2oCOzJ5mAh6iHsOm1bn
	ujbgpjU4hrjIA/dywnqyjyikaWJg1BQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753267660; a=rsa-sha256;
	cv=none;
	b=GVj2DnNlESPoXdHicKu34b3BX46r6TDCwQ2iRJvC8+NVRrSOJXvaRqXb0jv7PYprslFohr
	jZV0Ptj9rZQJe+k6Se8tSVo1z2D85kAKUBxsXRxKvEDCUapkne9aO0phkGPRYU8cXDGIu9
	6ESqqSCLzbKbmBZNICOu423jyioIXy8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qk58u2IO;
	spf=pass (imf17.hostedemail.com: domain of 3yr2AaAUKCJMGxyyx3BB381.zB985AHK-997Ixz7.BE3@flex--tabba.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3yr2AaAUKCJMGxyyx3BB381.zB985AHK-997Ixz7.BE3@flex--tabba.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4560a30a793so26731915e9.3
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267659; x=1753872459; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=d5hGo3nn+2nj2a3HbRALDwA7qk9YZQrlMbSjM7BcAIQ=;
        b=qk58u2IOFtYthnMtWsKnutgODa4m4LJi3lMa4V3mJN+/qo4D1fa80MM56cskmpeFnx
         AkXpAWnFFpHf/FcxWikQkf2+K+wOAhqCLGhpx/Vqx6YQ1TCFje6XJcrl71ANoFJqBQuf
         or39AUFo6p2oDWklEowR+VXXDvoe4/ljxdGicvG3bNyHY/MTJRkW59g8oIW5PJD07H96
         +AHrccRFGl/UPoiVvnZ5+Rzs+X8xTifdM1N04iqR7iNmY0/Df7Lqt8CtTrEg9NGlAzro
         BH9snptt4zoZoLfNDnqNdg3XHggVqhXzKYH0Ukk7B2l7pkgfxIis+T5fAT85Wv1o9v8l
         9Lhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267659; x=1753872459;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d5hGo3nn+2nj2a3HbRALDwA7qk9YZQrlMbSjM7BcAIQ=;
        b=rAtT54QtoLK1anJBbu++MMiD7tsL9Az2IOqC1YxGCeSF6xVSoS2agsWi0SwoQc2Gjg
         RykjNjT8it+zjFIyIyusUSyXYNR29t2oHHeW2BPNrMFF0KDi30HoRg97wFVbpCE0SGMw
         JvaJgT8kKxaDs0ShtiQ6qoeWC6jThewYTVgoqLLvUB6fiBFyo9fP0fZ78F1BO6QQC1bj
         qxzqmvjNXmjE2QaF+pvjMkXTzSayTljgYuOwwGxbGDO8z7ImgxJJtpJGJYBClCIoEiLL
         XK8lW2uUnFS7Vym1WIBmY/NrH9fPtKH1KO/G4rpmEJL8RraKSD/FgDdqPywf9aGFPB5F
         hXyg==
X-Forwarded-Encrypted: i=1; AJvYcCWe2BZCM0oVzEUWHt0TTevHyizpWRqjKivT53CxJnWnihyMuurP014/RWuTixWJ+x1yH6zkI7jnNg==@kvack.org
X-Gm-Message-State: AOJu0YwJ5cR35pZq57GkskIaxWSau9MWKV/AonUr76gPI4qRlxYNyJ/N
	lJCGAAK7kuJCEMz5Mx5K9X9+/10kvBHoUFrxOoXUqiEDNQOOZVC/niE6Ab44T4nxmK06y9gY5mZ
	OWQ==
X-Google-Smtp-Source: AGHT+IEN2ng1iBiQj/hOpJ7Jz7J3gbvaCwPkqEq6kCkN7K7pfMdbdTtgVfhLQcA0SIIMDYrrycOWegtIzA==
X-Received: from wmbeq10.prod.google.com ([2002:a05:600c:848a:b0:456:257a:e323])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8b2e:b0:43e:bdf7:7975
 with SMTP id 5b1f17b1804b1-45868d53277mr19005515e9.32.1753267658788; Wed, 23
 Jul 2025 03:47:38 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:47:14 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-23-tabba@google.com>
Subject: [PATCH v16 22/22] KVM: selftests: guest_memfd mmap() test when mmap
 is supported
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5B4EB40004
X-Stat-Signature: yz6qe6rgapicp9mk61qqkr4hstma5uxt
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753267660-684109
X-HE-Meta: U2FsdGVkX19Icu6QyOIoH5a/7Nt289PZBIMff3d/HjnrTTC4AukAaM4yNBX8OkNAUSYaYYK7EGJq+PbMLPfOM7y7Tj0SDgH2wyCHOFF0OqbFi9zILNihc2ribNmuiHQyghiifMHu5+PYY5K9DjBhn9ZRfhM1MJLSqfw80Dxahtajz9xS1z8J4eNgpWHssoCCvqbLc8HYd5+C0VTxj9w78Ebv2TSca+pZIe7TEHjIn6zl70i7pgSsoEb4rqM/no23LRW+r4Lziy6UlBLmGdXT0Gw+aOQfZHf9kufCapXX48g75ZzPpRkrf5CC5XmdebW3x8grw503fRiT7IqwIrqF/2HoH1+wYt9UwfL8zUQe++1iIQLe1+3GUYfQPjbNqb3DA/lhUhcK3zJGmKmxVjB+0FjZVcjwphi49uDC+UZWMtVrVcQs+vx19rndYXzoM+tfpR5nq5fz/AJzKQlr0jolClJ9mEoehP7pvqGgBmVeXjILQ5FF76LDZ+Bcqhi51oKHFt429MW14B0CR6UstQGB7pnDtTchD16x5a7xPk2k5fMDd02s4uD3abKj2BkksXd+Dt1UQy8cOUvL6cek7HD/MPddG4LUoffeHmGzMrLPosXLnRuPnPqv9u6KQdjs3cSzHmxXoemQO9lJ+n6RqUaIFs68p2IeOkdJw0dwV6wwzF7wHgJb6oSy7Y4iaPs2ksdglcb9eCiH76bjSnaPNfa9po625Jh5vBckqpUSqLGXdyY/htCrXsAYJhJqgvJhZnqeq5Z0gDnDoJPIyRaSdTwZzFmMlVsqZQB1HdFVEf4M2gpKn82l85IMXl8u0PlFgi/xeDPmVVZW9J219Ny21pf9l457TsLQNww83r47Nf5Nv0J6mETrhuI3G6xZdaaBnf0csATA6ArPRR67q4btBYCp43RAZqNbC2/ZJtKES4CLeMtQmW6bgbcK0f7wIFvIX1AIyp47UJkvtBX2xML6s9u
 iP2pvlwg
 czx7D9DVJHcUq6mwjJ6+JOgDJ79vH95RNT9M13c1oNUEXa4Eu31/qL/mqKEGW/xEzQopAMJUHhcTwmlMJiRIqEEAbL6+gCBMDjp4Egf4nuSJJGOb0jecgoWkxqyGVGRby7WD9i5MGtFjdD6LY/Ngrx/dFGJVk/tD1Kn9frVjqibvd9N+OJTFPMM/YXGPGsUmX7JIhWhZ90BSZY5rIlvYD9je+HIXgY0QBx08AAD00t2oPceyos1i5Qkse37itxgC3CEn6b3JQAL5kkA1RtdGN8VwHiNGm9l2pmSgb+ev95mA/nC/9I1RQxAnzpnbMtN4up7rILR+KW7rxKXiDUbiF7+YthI4PqBK+JsOG9V3oKLxA4vtHusv4Ry8VRhkG8Z/NZ+739Fj85eFPZnWJVTvDJyboBcszm8Wyvjkq1WS+lHGMeoFEcrhL53DKZOtTVaCvM90UXAhT/KT0JHoedkRz5+UkBK4TCoR1KUTTYBj/qvo4TNh3cs6BCpErAbOC/Kf8SjVKWlx5VerKL7UvFYuxQDlQhyNWniuX6b+YC6oI78J26JCRZu7AQ3ihbjsFZW1y1juJhaeqCMKBDKVh/lFfHm3tfYmEVrUZexr3K/RdzE5ZnkINJmHf4I0kCz1Vckue7EivTEQ3m0N8wFuwAoKHBwZf395B6aYuQyRBslLOQMXjAFSoRLMxKdMTe6QGl6you5yz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Expand the guest_memfd selftests to comprehensively test host userspace
mmap functionality for guest_memfd-backed memory when supported by the
VM type.

Introduce new test cases to verify the following:

* Successful mmap operations: Ensure that MAP_SHARED mappings succeed
  when guest_memfd mmap is enabled.

* Data integrity: Validate that data written to the mmap'd region is
  correctly persistent and readable.

* fallocate interaction: Test that fallocate(FALLOC_FL_PUNCH_HOLE)
  correctly zeros out mapped pages.

* Out-of-bounds access: Verify that accessing memory beyond the
  guest_memfd's size correctly triggers a SIGBUS signal.

* Unsupported mmap: Confirm that mmap attempts fail as expected when
  guest_memfd mmap support is not enabled for the specific guest_memfd
  instance or VM type.

* Flag validity: Introduce test_vm_type_gmem_flag_validity() to
  systematically test that only allowed guest_memfd creation flags are
  accepted for different VM types (e.g., GUEST_MEMFD_FLAG_MMAP for
  default VMs, no flags for CoCo VMs).

The existing tests for guest_memfd creation (multiple instances, invalid
sizes), file read/write, file size, and invalid punch hole operations
are integrated into the new test_with_type() framework to allow testing
across different VM types.

Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 194 ++++++++++++++++--
 1 file changed, 173 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 341ba616cf55..a0c5db8fd72d 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -13,6 +13,8 @@
 
 #include <linux/bitmap.h>
 #include <linux/falloc.h>
+#include <setjmp.h>
+#include <signal.h>
 #include <sys/mman.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -34,12 +36,83 @@ static void test_file_read_write(int fd)
 		    "pwrite on a guest_mem fd should fail");
 }
 
-static void test_mmap(int fd, size_t page_size)
+static void test_mmap_supported(int fd, size_t page_size, size_t total_size)
+{
+	const char val = 0xaa;
+	char *mem;
+	size_t i;
+	int ret;
+
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
+	TEST_ASSERT(mem == MAP_FAILED, "Copy-on-write not allowed by guest_memfd.");
+
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap() for guest_memfd should succeed.");
+
+	memset(mem, val, total_size);
+	for (i = 0; i < total_size; i++)
+		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
+
+	ret = fallocate(fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0,
+			page_size);
+	TEST_ASSERT(!ret, "fallocate the first page should succeed.");
+
+	for (i = 0; i < page_size; i++)
+		TEST_ASSERT_EQ(READ_ONCE(mem[i]), 0x00);
+	for (; i < total_size; i++)
+		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
+
+	memset(mem, val, page_size);
+	for (i = 0; i < total_size; i++)
+		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
+
+	ret = munmap(mem, total_size);
+	TEST_ASSERT(!ret, "munmap() should succeed.");
+}
+
+static sigjmp_buf jmpbuf;
+void fault_sigbus_handler(int signum)
+{
+	siglongjmp(jmpbuf, 1);
+}
+
+static void test_fault_overflow(int fd, size_t page_size, size_t total_size)
+{
+	struct sigaction sa_old, sa_new = {
+		.sa_handler = fault_sigbus_handler,
+	};
+	size_t map_size = total_size * 4;
+	const char val = 0xaa;
+	char *mem;
+	size_t i;
+	int ret;
+
+	mem = mmap(NULL, map_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap() for guest_memfd should succeed.");
+
+	sigaction(SIGBUS, &sa_new, &sa_old);
+	if (sigsetjmp(jmpbuf, 1) == 0) {
+		memset(mem, 0xaa, map_size);
+		TEST_ASSERT(false, "memset() should have triggered SIGBUS.");
+	}
+	sigaction(SIGBUS, &sa_old, NULL);
+
+	for (i = 0; i < total_size; i++)
+		TEST_ASSERT_EQ(READ_ONCE(mem[i]), val);
+
+	ret = munmap(mem, map_size);
+	TEST_ASSERT(!ret, "munmap() should succeed.");
+}
+
+static void test_mmap_not_supported(int fd, size_t page_size, size_t total_size)
 {
 	char *mem;
 
 	mem = mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
 	TEST_ASSERT_EQ(mem, MAP_FAILED);
+
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT_EQ(mem, MAP_FAILED);
 }
 
 static void test_file_size(int fd, size_t page_size, size_t total_size)
@@ -120,26 +193,19 @@ static void test_invalid_punch_hole(int fd, size_t page_size, size_t total_size)
 	}
 }
 
-static void test_create_guest_memfd_invalid(struct kvm_vm *vm)
+static void test_create_guest_memfd_invalid_sizes(struct kvm_vm *vm,
+						  uint64_t guest_memfd_flags,
+						  size_t page_size)
 {
-	size_t page_size = getpagesize();
-	uint64_t flag;
 	size_t size;
 	int fd;
 
 	for (size = 1; size < page_size; size++) {
-		fd = __vm_create_guest_memfd(vm, size, 0);
-		TEST_ASSERT(fd == -1 && errno == EINVAL,
+		fd = __vm_create_guest_memfd(vm, size, guest_memfd_flags);
+		TEST_ASSERT(fd < 0 && errno == EINVAL,
 			    "guest_memfd() with non-page-aligned page size '0x%lx' should fail with EINVAL",
 			    size);
 	}
-
-	for (flag = BIT(0); flag; flag <<= 1) {
-		fd = __vm_create_guest_memfd(vm, page_size, flag);
-		TEST_ASSERT(fd == -1 && errno == EINVAL,
-			    "guest_memfd() with flag '0x%lx' should fail with EINVAL",
-			    flag);
-	}
 }
 
 static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
@@ -171,30 +237,116 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
 	close(fd1);
 }
 
-int main(int argc, char *argv[])
+static bool check_vm_type(unsigned long vm_type)
 {
-	size_t page_size;
+	/*
+	 * Not all architectures support KVM_CAP_VM_TYPES. However, those that
+	 * support guest_memfd have that support for the default VM type.
+	 */
+	if (vm_type == VM_TYPE_DEFAULT)
+		return true;
+
+	return kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(vm_type);
+}
+
+static void test_with_type(unsigned long vm_type, uint64_t guest_memfd_flags)
+{
+	struct kvm_vm *vm;
 	size_t total_size;
+	size_t page_size;
 	int fd;
-	struct kvm_vm *vm;
 
-	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
+	if (!check_vm_type(vm_type))
+		return;
 
 	page_size = getpagesize();
 	total_size = page_size * 4;
 
-	vm = vm_create_barebones();
+	vm = vm_create_barebones_type(vm_type);
 
-	test_create_guest_memfd_invalid(vm);
 	test_create_guest_memfd_multiple(vm);
+	test_create_guest_memfd_invalid_sizes(vm, guest_memfd_flags, page_size);
 
-	fd = vm_create_guest_memfd(vm, total_size, 0);
+	fd = vm_create_guest_memfd(vm, total_size, guest_memfd_flags);
 
 	test_file_read_write(fd);
-	test_mmap(fd, page_size);
+
+	if (guest_memfd_flags & GUEST_MEMFD_FLAG_MMAP) {
+		test_mmap_supported(fd, page_size, total_size);
+		test_fault_overflow(fd, page_size, total_size);
+
+	} else {
+		test_mmap_not_supported(fd, page_size, total_size);
+	}
+
 	test_file_size(fd, page_size, total_size);
 	test_fallocate(fd, page_size, total_size);
 	test_invalid_punch_hole(fd, page_size, total_size);
 
 	close(fd);
+	kvm_vm_free(vm);
+}
+
+static void test_vm_type_gmem_flag_validity(unsigned long vm_type,
+					    uint64_t expected_valid_flags)
+{
+	size_t page_size = getpagesize();
+	struct kvm_vm *vm;
+	uint64_t flag = 0;
+	int fd;
+
+	if (!check_vm_type(vm_type))
+		return;
+
+	vm = vm_create_barebones_type(vm_type);
+
+	for (flag = BIT(0); flag; flag <<= 1) {
+		fd = __vm_create_guest_memfd(vm, page_size, flag);
+
+		if (flag & expected_valid_flags) {
+			TEST_ASSERT(fd >= 0,
+				    "guest_memfd() with flag '0x%lx' should be valid",
+				    flag);
+			close(fd);
+		} else {
+			TEST_ASSERT(fd < 0 && errno == EINVAL,
+				    "guest_memfd() with flag '0x%lx' should fail with EINVAL",
+				    flag);
+		}
+	}
+
+	kvm_vm_free(vm);
+}
+
+static void test_gmem_flag_validity(void)
+{
+	uint64_t non_coco_vm_valid_flags = 0;
+
+	if (kvm_has_cap(KVM_CAP_GUEST_MEMFD_MMAP))
+		non_coco_vm_valid_flags = GUEST_MEMFD_FLAG_MMAP;
+
+	test_vm_type_gmem_flag_validity(VM_TYPE_DEFAULT, non_coco_vm_valid_flags);
+
+#ifdef __x86_64__
+	test_vm_type_gmem_flag_validity(KVM_X86_SW_PROTECTED_VM, 0);
+	test_vm_type_gmem_flag_validity(KVM_X86_SEV_VM, 0);
+	test_vm_type_gmem_flag_validity(KVM_X86_SEV_ES_VM, 0);
+	test_vm_type_gmem_flag_validity(KVM_X86_SNP_VM, 0);
+	test_vm_type_gmem_flag_validity(KVM_X86_TDX_VM, 0);
+#endif
+}
+
+int main(int argc, char *argv[])
+{
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
+
+	test_gmem_flag_validity();
+
+	test_with_type(VM_TYPE_DEFAULT, 0);
+	if (kvm_has_cap(KVM_CAP_GUEST_MEMFD_MMAP))
+		test_with_type(VM_TYPE_DEFAULT, GUEST_MEMFD_FLAG_MMAP);
+
+#ifdef __x86_64__
+	test_with_type(KVM_X86_SW_PROTECTED_VM, 0);
+#endif
 }
-- 
2.50.1.470.g6ba607880d-goog


