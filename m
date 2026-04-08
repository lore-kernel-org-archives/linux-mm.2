Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A031710F995C
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 17:26:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9D8C6B0098; Wed,  8 Apr 2026 13:26:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5D816B0099; Wed,  8 Apr 2026 13:26:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C24376B009B; Wed,  8 Apr 2026 13:26:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD1AD6B0098
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:26:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6A3B68967F
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:26:24 +0000 (UTC)
X-FDA: 84636067488.27.5EE22F6
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8BE2C40008
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:26:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cfXVUg3S;
	spf=pass (imf11.hostedemail.com: domain of 3vY_WaQYKCIwCEyxq3w44w1u.s421y3AD-220Bqs0.47w@flex--wyihan.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3vY_WaQYKCIwCEyxq3w44w1u.s421y3AD-220Bqs0.47w@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775669182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qDOZkIKxiPaQK0xKrpR+eqPsSd9MFpMG2SR/o/KXRoA=;
	b=a52zTDBczAs3RBJ6c7RmhSzyj5gB3MRTJHfSf4FKKWEDmFHiWVLroY4/DsaSgr4u6rEK8N
	eoaluKCk5K/tRjA6MzMx0OgU3+DYufUQNhSgl6jiOm7n8+dj/IXFGK/wnAk0S5cOs/D5Hb
	VabopzaOQs2Ao5yo7RHeXMBgSwBnRws=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cfXVUg3S;
	spf=pass (imf11.hostedemail.com: domain of 3vY_WaQYKCIwCEyxq3w44w1u.s421y3AD-220Bqs0.47w@flex--wyihan.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3vY_WaQYKCIwCEyxq3w44w1u.s421y3AD-220Bqs0.47w@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775669182; a=rsa-sha256;
	cv=none;
	b=Q4wLW9JJq7Q23XHUvZCXIA1zrFrrhCJ5Fw9E/RkABmANbpCHKtxUQyPyaSzJPgaoqcmGuw
	17y9vlsW7pDacFA7O3qQ6jTGT/dyoZMEvnzb89oF2fFFw8J7/SDirFRf12EmnJ4PjsSFG1
	ysjXgM2wfBW0tDlJOLlKO7vaWkCjSa4=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-354bc535546so96342a91.3
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 10:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775669181; x=1776273981; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qDOZkIKxiPaQK0xKrpR+eqPsSd9MFpMG2SR/o/KXRoA=;
        b=cfXVUg3SBzxdBViDuq/coT82LkQHNRURlRM/EM9Pxb9esHRcZIOTobUp1bkXLevrYL
         0DwooaenDtz/Hlnsk83dbJrX/5y6Z3XYUgyec9bkFrw/XlfCD4Il1KvTSqrysDpFH1Rs
         jVIfUH5qMVrp9Mtz4M0QNXam9D2YDrTdrHpBhfT8/GtIOZqxDDQFS9sgQLtMJCcLqpML
         eRYxPcpxW+0AKMmEXnO8SyyE8tatUxTFVoFfgtwWYEDQ+h1KfK8AJTU5Hc6c3FdX2GjL
         67gotPicRckfoGyZFDjjGqClXSzUCjeHa74r9xWtCVMdNuQvDFN2tq7mOqwV+1qX1xd9
         OuOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775669181; x=1776273981;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qDOZkIKxiPaQK0xKrpR+eqPsSd9MFpMG2SR/o/KXRoA=;
        b=JyvleE2CsumL7irU4PiAO/0VRXqxiitLaO1ofMgkOEBxaiEVb5SWXYARAiUlfyHwsa
         edRUYMhnBQVnbcEL83L17EM/gA0IKidMGkUhWaucISxiF8KW4H4/oODH0KzkAIANmU5o
         vabrrLGUnZoCE5TVfg5/TJnG5JyIEFkTvCa24mAiSoUL6u5SIxH96zosOzBTGanGJIkX
         Ru6DzvDDdpjpMschRVyu0WWsX6MvMr+jbkAGPuzTkpLBfl8qDa1Zr/iMd0cmO6Auqui0
         F7vVhReGReTXXhBRe6hCJeKr4R3zizZIARf984Tq+YCopQWZoTVLvZljTnOO0FNnlypI
         JMoQ==
X-Forwarded-Encrypted: i=1; AJvYcCUaNo1abhy4M1hM2SCVCueMG5Ufs980lyaN8yrJ4IxqfHdJ0eAp7uK/FoL1A2ABGACT5+8wqsksWQ==@kvack.org
X-Gm-Message-State: AOJu0Yxy+5yM60YClPZhb329XicjWVacib7tkC5OZAHk7OG0c+HsP4qA
	CijVQnbAsFN6kZR//mxhPcAzHUN/imsr/EH4ghUFg6HMXlDfjnJveCLvEkzx0tJgdUQnnhf7HmD
	d+wjfgQ==
X-Received: from pjbhl3.prod.google.com ([2002:a17:90b:1343:b0:35d:a369:bbea])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c48:b0:35a:18b1:c245
 with SMTP id 98e67ed59e1d1-35e3574c101mr173541a91.3.1775669181262; Wed, 08
 Apr 2026 10:26:21 -0700 (PDT)
Date: Wed, 08 Apr 2026 17:24:48 +0000
In-Reply-To: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-0-718f45eb7c75@google.com>
Mime-Version: 1.0
References: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-0-718f45eb7c75@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775669168; l=3409;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=ijzz7721/Uxn/cIYDu6fObmDcCDSsHBAV/IttC7RW3U=; b=sRyqvXXGMNI5dZjLhIg1mr5q1swOpgzarSwWrk1NumIrtzSiI54MbVYzXC+7k09lxHjEFl4fv
 +zVMRi1MIeSBNGsLfAME4QP5EX4LbgDrrGBr1tO69JgO1LqU2DVF5ct
X-Mailer: b4 0.14.3
Message-ID: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-7-718f45eb7c75@google.com>
Subject: [PATCH RFC v3 7/7] KVM: selftests: Test guest_memfd behavior with
 respect to stage 2 page tables
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com, 
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com, 
	tabba@google.com, dave.hansen@linux.intel.com, Lisa Wang <wyihan@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 8BE2C40008
X-Stat-Signature: y4en68gmetd99r5fuqnqoc7xig7c8amd
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775669182-798870
X-HE-Meta: U2FsdGVkX19GACahT2VUwLgpOgd/k6Or/4SrhfmOoK6mrA9KJ7fqAoE+vNngE7uOysIHZIj3027XAYWgqcC25bZ4ZspIZFXF+rYT0FopSxqEe9uu52o3oaRm8gQwTHjtRfkNAHzq72XlDZpeu5uOSJgB9hkam2i/mIRvakJQMKqk6jCnoomMC7EZ7eqkhdlXoSORERVfWcO9+nFBVHEKhnH4MZ2WT/qI69QPRI3CGmg1bAqtma/0w/d5/2Jtxo27rEbwq5XlUnxmoGrOp1gvq6LfKXeMokufWkaafQy0LheoOqRYQecb1bil92Q0JcR7cYiBzQPsdNxYG0zRI/tCtb8zL5YqYaV7hQg9C6AgsAIg9/cn7sPn7MIeT3UsmNzGAMR64xAIDMabw55WXMiJbJyQu/qVBRmsAkrka5D9gPr3bTwuyXQoOwiFwX4JqXWpSGNFIOQ2hYXTx/IYG8EBGj9p1litSUx5Gai9DYns2JPylRhAABXa4ztFP+egs+tvWmlSA1iln6SQEjn4nUxchqUDs4GNXm8iGArDH2jaO0HFv8P/RZ1dy4aSbcHM0v+0RN3IrZLtRoXDl1ONN0Fg2t4mN77/H9zurYP6iHfybfBYCTIcfFRxWFKB8zsNrBuIeHJ/0WHeMNaAPW0Wg6X703srIdNYky8SnGpX/O9Tx5j0aZI3nX0vgwCJrPn0LjDNC+WX4pZA5cZpzP6GE0eXnPqSw6FbmfCPJ4t501PDZQvCVg+fPCkDREWhLhrtwAcp7GDeM2mwKQEbaeC8wf16+Nw4bnQvRDhWvPbIAi0i2X91qYh/bNb0srIpr1VHO8mEnViFOIpjCJNhEpPZ0LSu85QKnyKQaxuR+iM5Dfn3SZjfR/K0w64iUXoJnY52XBlqvSVGNtMB+4ZBduGooDj4vZHSMn3Mqo3MRkCabda80uXPucwAI9UCiTPwwADbtMflbXnHadRj1N9/EHdW+Jm
 +qHtHdZ2
 CHFnn/cLcD8DeC2WUk/1P5JkVztw+/qkVF1W8dunHYSXeBhkGB6DFkqMyyzhFm52pi4PFaksLKflswE7WwZcEXF7Y4TS0Ll37HaAzNffAI8aJkghQWOBHr9GFKXXqvCByzKk/8nrDjE48XzIVTWW3JnzBDlJI/hHS2djLDj3FPtIv06xdMRuZJ7HC8hqrRitAkai5foyE21XQMl+SqShPhgVEtSBQSFsKUGxB/KU9FQrd4ITKZ9wcgdetLT9CnHQmj+r1gW7tbKSGRg/1hyh0BGsqV4hYQ84fmu3I2Vx4TrHWE2UcZwmZvqmSzej2TtfZZupZXZhbK0Y+mJIkeFgt4L618HdS2ExsCg+sFBQvrfwhRZvW2DoiskhxKe8vYztxDIUmZ5X7w/8auCaHYNJTV2zBbTX8K6xPkZN61cKQjCVIxj+i9YDLuqx0jhsKP130g90k9SG+gnW88zt9/37fP6oDOlP7F9lOG/tF7NanfRu5LHyg7G8+wrURQ+m3+5mhrCK5QPd5zb0/twA76iu6judlm2OVPQJwMLc4UUnCI8z1gWeBrFW6uRyVxiFQdgXx1QPdWIumw5AKfa4xq6GI2c8HhvV0ADDC57gheBOSnQUrWO2xeNiYY1MmzHPVVL3U7VWVL99DTKl2Mx2VhiFBeQt6CjaxistOfDvJTo91jXTVEVocoXf/uPkljkwbbCu1yja4RWIEfK9bcC4K4ecejjJ2+BIs59GZBBvi7mI0kzR1Avdae3PZt20yAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Test that
+ memory failure handling results in unmapping of bad memory from stage
  2 page tables, hence requiring faulting on next guest access
+ when the guest tries to fault a poisoned page from guest_memfd, the
  userspace VMM informed with EHWPOISON

Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Lisa Wang <wyihan@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 70 +++++++++++++++++++++++++-
 1 file changed, 69 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 0ea4e7d7e6d5..6615ee8bfcd8 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -26,6 +26,7 @@
 #include "ucall_common.h"
 
 static size_t page_size;
+static uint64_t test_memory_failure_guest_gpa;
 
 static void test_file_read_write(int fd, size_t total_size)
 {
@@ -637,6 +638,73 @@ static void test_guest_memfd_guest(void)
 	kvm_vm_free(vm);
 }
 
+static void __guest_code_read(void)
+{
+	uint8_t *mem = (uint8_t *)test_memory_failure_guest_gpa;
+
+	READ_ONCE(*mem);
+	GUEST_SYNC(0);
+	READ_ONCE(*mem);
+	GUEST_DONE();
+}
+
+static void guest_read(struct kvm_vcpu *vcpu, int expected_errno)
+{
+	if (expected_errno) {
+		TEST_ASSERT_EQ(_vcpu_run(vcpu), -1);
+		TEST_ASSERT_EQ(errno, expected_errno);
+	} else {
+		vcpu_run(vcpu);
+		TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_SYNC);
+	}
+}
+
+static void test_memory_failure_guest(void)
+{
+	const uint64_t gpa = SZ_4G;
+	const int slot = 1;
+
+	unsigned long memory_failure_pfn;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	uint8_t *mem;
+	size_t size;
+	int fd;
+
+	if (!kvm_has_cap(KVM_CAP_GUEST_MEMFD_FLAGS))
+		return;
+
+	vm = __vm_create_shape_with_one_vcpu(VM_SHAPE_DEFAULT, &vcpu, 1, __guest_code_read);
+
+	size = vm->page_size;
+	fd = vm_create_guest_memfd(vm, size, GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED);
+	vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, size, NULL, fd, 0);
+
+	mem = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap() for guest_memfd should succeed.");
+	virt_pg_map(vm, gpa, gpa);
+
+	test_memory_failure_guest_gpa = gpa;
+	sync_global_to_guest(vm, test_memory_failure_guest_gpa);
+
+	/* Fault in page to read pfn, then unmap page for testing. */
+	READ_ONCE(*mem);
+	memory_failure_pfn = addr_to_pfn(mem);
+	munmap(mem, size);
+
+	/* Fault page into stage2 page tables. */
+	guest_read(vcpu, 0);
+
+	mark_memory_failure(memory_failure_pfn, 0);
+
+	guest_read(vcpu, EHWPOISON);
+
+	close(fd);
+	kvm_vm_free(vm);
+
+	unmark_memory_failure(memory_failure_pfn, 0);
+}
+
 int main(int argc, char *argv[])
 {
 	unsigned long vm_types, vm_type;
@@ -644,7 +712,6 @@ int main(int argc, char *argv[])
 	TEST_REQUIRE(kvm_has_cap(KVM_CAP_GUEST_MEMFD));
 
 	page_size = getpagesize();
-
 	/*
 	 * Not all architectures support KVM_CAP_VM_TYPES. However, those that
 	 * support guest_memfd have that support for the default VM type.
@@ -657,4 +724,5 @@ int main(int argc, char *argv[])
 		test_guest_memfd(vm_type);
 
 	test_guest_memfd_guest();
+	test_memory_failure_guest();
 }

-- 
2.53.0.1213.gd9a14994de-goog


