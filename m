Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C502010AB82C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:25:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27C1A6B00C1; Thu, 26 Mar 2026 18:25:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2059D6B00C3; Thu, 26 Mar 2026 18:25:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F3586B00C4; Thu, 26 Mar 2026 18:25:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF6C56B00C1
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD931E1304
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:16 +0000 (UTC)
X-FDA: 84589646232.29.667A784
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf15.hostedemail.com (Postfix) with ESMTP id DC02CA0017
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uiEUtvIY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3SbLFaQsKCBo02A4HB4OJD66EE6B4.2ECB8DKN-CCAL02A.EH6@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3SbLFaQsKCBo02A4HB4OJD66EE6B4.2ECB8DKN-CCAL02A.EH6@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o5T9NfG8XOkzMLDmEFGNVKs1ndpz9+nD9vrw6ykVGHU=;
	b=TT1ky7Smh7aiOhC+XiAM8YNlPKmnDFO8PlohG/dOJN5t3FkvCiGdSR/nkd/iu4SyJj44zk
	104HFhn8CGT9QHduTqGlEDbDoWP9MKjtrbKIOy45Buxwlmz0M9PN83zOA8EFNgS9aqTP6o
	4vrA9OsWVFk+1ZBSH37s1CrmJAvFAUA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563914; a=rsa-sha256;
	cv=none;
	b=07MXuiqepukmL46SGrH3noZoVk65umGoWk8EKkUZ/IY7cQB2fMMaONq0eehEkmsW88JxfU
	3QrYDF2X7eERSHIYjIByv9U2Nmvoj1qePUIHtptYUvMNmF/NILRnELUGdRSpUfxX0tso1q
	90fXDKlqBOUe9nUKhygEzjkWSOCEqfI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uiEUtvIY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3SbLFaQsKCBo02A4HB4OJD66EE6B4.2ECB8DKN-CCAL02A.EH6@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3SbLFaQsKCBo02A4HB4OJD66EE6B4.2ECB8DKN-CCAL02A.EH6@flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c741a9ef5f0so1036159a12.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563914; x=1775168714; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=o5T9NfG8XOkzMLDmEFGNVKs1ndpz9+nD9vrw6ykVGHU=;
        b=uiEUtvIYlOS04tp+lhcd+ZoggVq8HOeRfB8+RPUSYRxcy2DYCTc4XH/kpNslEEfyAA
         9jIN39yRx0yqrMDnVV8NE1TWPTLll39ZMSaJL5SPCkpDRvNxrWUlaGkvARKfR4CWxL/t
         yrKYf04pcQxHF3tyx9+53Hr80Bdxs6ZtgdsL+D29x5UGUPirdq3FM5Ae53aJCjO+Qw/w
         sQHreBLERgn9X5DwRKtXFO6KdZbVghXnQ2wMjcCw6QHT+ZNlH6Mq7M9L3ZQyGExbIcj0
         X1zAxnxAkfyzb9kEWfs8S+Gn4f+JbtHNkLG8DEcRlZlOWC8ePJGGBHpIduHji0q6A6+Z
         zLWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563914; x=1775168714;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o5T9NfG8XOkzMLDmEFGNVKs1ndpz9+nD9vrw6ykVGHU=;
        b=CBudnEndkhXAFC26e7RmKKfY4oUPPBBAkof1JnQT1F4kmLw2j54da4aFnu+cv3hXiz
         ApvjZ0CXSXEYJv4meMGZnNSwgP1PhvQxdUGCsUJfAE3uDvIj6xXAUL6xO8+HZ06mZVFS
         fCfYt8L9w8rXu0pUCoSBb32UcPxeazecuapaSvv9Dr4pmtgQGJPgUlBJ5vMHMRzSOfRY
         eKDlVjxk8RxF62A+gtNfztkxEQ3HKosY5XNg/oNB5ZW+CoFxtKoETJEPhBXQElZJC0T2
         NnvQDVCygL3DkXgQwXXF0RIYj+DbbCz8V6txyMuJBaknXdL4YBR7atoUv+pgPvKBrlEy
         pz7g==
X-Forwarded-Encrypted: i=1; AJvYcCXwR1iJiuG2hPwI8HegOC+4V7MkdO49TwwcHxUoOmiXHLKuuohm519WAaHOG10bABefGCVh3L/E7w==@kvack.org
X-Gm-Message-State: AOJu0YwY2uuwKmwNjc3fe1wUmJZHL3cWxvLSSAmEFqao/9cyasql4PuF
	4khe/Wz0RmIAdxsMtWvJFDhpCwKzIG5ls7RRrn34TONLdkzovMeFA84SF1oRjwX2/DzxrFnQe+D
	6MLuUW+cCYUj9z/bOmUds9ZCUPg==
X-Received: from pfjt19.prod.google.com ([2002:a05:6a00:21d3:b0:829:7eec:794])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:ab89:b0:827:2792:e401 with SMTP id d2e1a72fcca58-82c867801f0mr2756930b3a.15.1774563913210;
 Thu, 26 Mar 2026 15:25:13 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:33 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=3775;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=zRxx5/gHPS2JHJuJIs+5pNbq2l0ZSiKHaA8Zk5RuA84=; b=VbHUBBR0WU0omOVPBuMXZyxIW6ATPi3tjRPVcgfbz9ptdEr9eML7Tg/j/U1YitZYGTOZMkqw9
 iofJmFKNJQICGz7MXZMzJC3tsckH1ROc9T4vFF1M+jcA/cyGvgNFUVl
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-24-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 24/44] KVM: selftests: Test using guest_memfd for guest
 private memory
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: DC02CA0017
X-Stat-Signature: c7rnfzmnpswkwcfc8netpjpnxmqrdyyx
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774563914-727451
X-HE-Meta: U2FsdGVkX1+MecgNAQ1sHxO95Yl55P3RS66IDqfeD/CAj1sBYf4+DbVvzeu3/dQd6rP9P+/+jcHqHDqeVmISCzhJHMUvoqgBxmo4Oj72YhBK6lWyyyHowhbfgPrlRcOBOCzg8gWDl6pdiwf9Epa6fRK8tlbGh1zsM6GBIgZYHvvmns3g1cwgU0AJE7hQ1Cv9NS9F6wttaWe2Iw1bJs6GcfHD2+vE7s125HEowB/Qd6MmVQOgpG1wgx51DI8ScdMqInaDKI2zqCf7pukunwIe8at3UtuKTW2qbwR8Rq4rZgk3h4IFl4ItWE6OlBUhPwBOYmAWLEga9RxVrl0xQbi9/YNj/YiP7fNopkHSwXWsVpZRgijbQ0+jMaBTk7fOAmMIA59tuCfxaBLgF3lMJaNE+ERciZKwIUMfqilLj5UZo7Ho5gDKroPo2GKeNURm6t/sSriMz4NO5kDb9SIb4+XrgONzV6IphL2CcIF8Wf4HHdFh3tNud3T6spkkzTA+N53HoNDOPoqzf2+y4VV3CZV6oymCatQGllWB0PUbrUvOTGBesz7Yt5SbbLySGfeM95Ig6zZgdZYPs2uRhWfqUHyHDPFAEsS0IyAobsUSyuFV+NjLNNZvDzwRYBT4LysUgI8C043l3UoVyH61mDBP7JPA4XaKyX/t0nq4EKMWrWbu2zxZkQk/+1u9R/z776xyt84Io2B0N5ibkeeZVS/K0JNXOstbpgT190sje6iNB67Ec+hB6Yif87WvB8yW/T2xl66LDAmotzRRt/oArVKCNn445wF00UScbN/GrDemfaqL8YespdS0dYXFg4OY073iVPXt0JUFnxqleKAfoLrTyyrCaz80DmEHAXgj0dxNRqXfD2qJC9fyjY0hRYmKPQY2wBXnn9lmFWw71LVpMjmJECtcWJorDfI/olnJWCFlo7PV5jL6CqrAn4cZY8zgMkKu+jO076Kl+TQjJY1dZE3HkMs
 MOFKaRns
 aBi1dubzWmFDp7JplivgzWgq8TU+Od+FJnTWU3o6uAJwOz/uOUTlwS58MhC3OSCDHuTWeLz/iPd55jYNyQQkgYaYuzeCFvWEBJjZfjxStccjKBNj5UNKs4uHU4dDSh9M38KtvDdJXHV2KXc+9FEJkKAd6pDH0l2P1aVMyNMgAsVj9MQh7dkLiaL2GYvg+v79T3357ePln4k/Lj7cjNATzJmLdrujOmG0gZo60gGKqIwMtFW2hgZq8GIJjjzxygRb2/zKPPIcT/wXDJILVe8F7/aozNRRE8GNICfwfcHTKTh7HPv9/k/JKWpSiCYszX0VvzP1O/HFO1PVpDpAJ/0w1rOh2OElyrd6uBMNvEUqlfR636vMefrDMQ6gF8GbQDmn2/LShnYif6+z2XN0cPoqZ0/gf0p8nQYiBlp9HdDGYPpOiBPkemnGAd4LQYa0vxX59p8jU5cUuFTVXS+/dUiB6gMz2A3l9GN+xKyIVHKBnHHkysxXYWEXfZaaGSPfnnmiJSgObNxamR24fXMUvzZ6EA87EoFadlRg5ZR8ifKHcEDbAXou6Jc2QJ5svOKV0tzg7B6WX4W0df8ONIvTWu9NDwDNBYJfPzuqfXDNORhayKUcGZRcN3cKEuFmxHTmLHLqpJh6s/ZdocTbIzp2sX9lg1abMwDVmze82t2oCetSq6ej5G7kmEwRwzLzDEN575kX53eHbmSQx4U9M7EKwmRLRIOk49g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a selftest to verify that a memory region backed by a guest_memfd
can be used as private guest memory. This is a key use case for
confidential computing guests where the host should not have access to the
guest's memory contents.

The new test, test_guest_private_mem, creates a protected VM, maps a
guest_memfd into the guest's address space, and then marks the region as
private. The guest code then writes to and reads from this private memory
region to verify it is accessible.

To better distinguish between the test cases, rename the existing test
that verifies shared host/guest access from test_guest_memfd_guest to
test_guest_shared_mem.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 57 ++++++++++++++++++++++++--
 1 file changed, 53 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index cc329b57ce2e9..10b57fd4fa9ba 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -406,7 +406,7 @@ static void test_guest_memfd(unsigned long vm_type)
 	kvm_vm_free(vm);
 }
 
-static void guest_code(uint8_t *mem, uint64_t size)
+static void guest_code_test_guest_shared_mem(uint8_t *mem, uint64_t size)
 {
 	size_t i;
 
@@ -418,7 +418,7 @@ static void guest_code(uint8_t *mem, uint64_t size)
 	GUEST_DONE();
 }
 
-static void test_guest_memfd_guest(void)
+static void test_guest_shared_mem(void)
 {
 	/*
 	 * Skip the first 4gb and slot0.  slot0 maps <1gb and is used to back
@@ -437,7 +437,8 @@ static void test_guest_memfd_guest(void)
 	if (!kvm_check_cap(KVM_CAP_GUEST_MEMFD_FLAGS))
 		return;
 
-	vm = __vm_create_shape_with_one_vcpu(VM_SHAPE_DEFAULT, &vcpu, 1, guest_code);
+	vm = __vm_create_shape_with_one_vcpu(VM_SHAPE_DEFAULT, &vcpu, 1,
+					     guest_code_test_guest_shared_mem);
 
 	TEST_ASSERT(vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS) & GUEST_MEMFD_FLAG_MMAP,
 		    "Default VM type should support MMAP, supported flags = 0x%x",
@@ -469,6 +470,53 @@ static void test_guest_memfd_guest(void)
 	kvm_vm_free(vm);
 }
 
+static void guest_code_test_guest_private_mem(uint8_t *mem)
+{
+	WRITE_ONCE(mem[0], 0xff);
+	GUEST_ASSERT_EQ(READ_ONCE(mem[0]), 0xff);
+
+	GUEST_DONE();
+}
+
+static void test_guest_private_mem(void)
+{
+	const struct vm_shape shape = {
+		.mode = VM_MODE_DEFAULT,
+		.type = KVM_X86_SW_PROTECTED_VM,
+	};
+	/*
+	 * Skip the first 4gb and slot0.  slot0 maps <1gb and is used to back
+	 * the guest's code, stack, and page tables, and low memory contains
+	 * the PCI hole and other MMIO regions that need to be avoided.
+	 */
+	const uint64_t gpa = SZ_4G;
+	const int slot = 1;
+
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	size_t npages;
+	int fd;
+
+	npages = page_size / getpagesize();
+	vm = __vm_create_shape_with_one_vcpu(shape, &vcpu, npages,
+					     guest_code_test_guest_private_mem);
+
+	fd = vm_create_guest_memfd(vm, page_size, 0);
+	vm_mem_add(vm, VM_MEM_SRC_SHMEM, gpa, slot, npages, KVM_MEM_GUEST_MEMFD,
+		   fd, 0, 0);
+
+	virt_map(vm, gpa, gpa, npages);
+	vm_mem_set_private(vm, gpa, page_size);
+
+	vcpu_args_set(vcpu, 1, gpa);
+	vcpu_run(vcpu);
+
+	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
+
+	close(fd);
+	kvm_vm_free(vm);
+}
+
 int main(int argc, char *argv[])
 {
 	unsigned long vm_types, vm_type;
@@ -488,5 +536,6 @@ int main(int argc, char *argv[])
 	for_each_set_bit(vm_type, &vm_types, BITS_PER_TYPE(vm_types))
 		test_guest_memfd(vm_type);
 
-	test_guest_memfd_guest();
+	test_guest_shared_mem();
+	test_guest_private_mem();
 }

-- 
2.53.0.1018.g2bb0e51243-goog


