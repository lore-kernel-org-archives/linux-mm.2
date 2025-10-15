Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26E1DCCD195
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:37:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81CC38E0084; Wed, 15 Oct 2025 14:37:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F4488E001D; Wed, 15 Oct 2025 14:37:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 709E78E0084; Wed, 15 Oct 2025 14:37:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5BE618E001D
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:37:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C36DC0263
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:37:09 +0000 (UTC)
X-FDA: 84001205778.21.8315CFF
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5288C80002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:37:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YuQxyjgp;
	spf=pass (imf30.hostedemail.com: domain of 30unvaAYKCLMprbaTgZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--wyihan.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=30unvaAYKCLMprbaTgZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760553427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r/50hzPJcz2Tgtv5Q95r1Wz9trycmcqvXu8eukDbYxw=;
	b=Oa9vOYtsfbS7qVmS0cDzbId9IkmWNaQS/5afI/UoEQk8vSWJEuHV8281uUA+8Yz0UWuDxi
	24KF5i5V1ooGIV4krvJfx4MGmtRkIsm8iUm2UmTpZWpV1MjAG/hwMdsSbbdC1GhYD1aHZs
	qxqMT4Nt54YQL6QQyB1/HIdNobD7GbU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760553427; a=rsa-sha256;
	cv=none;
	b=fJe+q/8e3epLXGkIxu9i3XxJNzb0cIGfl3rrrhw2JwqAXg9irtnlmO3V65Y1wq/MMHH60R
	DMLHa1Obb2pyjCakDvs0C3gYxWHu6Wd/dHeickxZwsqhcFjmFUCLPGx7nX9lMOnzqvCH9N
	r4uRJ8MV8SlLewj5kRKroL8V8Ig+6jk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YuQxyjgp;
	spf=pass (imf30.hostedemail.com: domain of 30unvaAYKCLMprbaTgZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--wyihan.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=30unvaAYKCLMprbaTgZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-798920399a6so1361084b3a.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760553426; x=1761158226; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r/50hzPJcz2Tgtv5Q95r1Wz9trycmcqvXu8eukDbYxw=;
        b=YuQxyjgprAXbF4f0mOYcVJ56zXfZca4mmztBKnDLbStCdkzDHGD9iMJkhbJdbVIcfO
         oxOvLUPFOfCsHL0p9AZoY20FsA8+AJL8J47/UgoTwoFAF+F3ZUGoDwLfo8wwzLt/Ld0Y
         a9j2AQ3cavVzaDF/62bf/lqHaNNSsizPMkkxmuNDBwIMuOJ1B5c8+kiQn2B8n5FCG8vO
         cylPOJdgswLtl1AdPg6KdJXcN0boT0b/gfW/Fz7PQSvK+lQaeq5a0Ppbx+kg/fV0Xdmv
         /xq8Hz3CpH+0MmWL2pw6/o8t3thwmv8yoTzOYulrQnrLJfnegbJNQhiQIOodSRh8yWri
         pCIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760553426; x=1761158226;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r/50hzPJcz2Tgtv5Q95r1Wz9trycmcqvXu8eukDbYxw=;
        b=Sg9bbgAcOTVr6uEmNi3fOZtMJk8h3qPCD8+Ab3O/TbuJdtUvFtXnYW2oTS+yvZRDMj
         O7f6BpYH0mN223QXUOGd76glJDKB73PZApl5gBM5xnt0AxotLFdx01SOszZIbgCyCeEC
         X6LasDhg2hG6XRgEXXCSUcLaCB0F0fUv/FlkP97im4w6nqtBMWeFefXytcsmyM6Jm1wA
         vPgRl/KRQrA/dUiTb8mM4Hs+VMBfAUuOp59eIArklzm81axa+zIaXk6rCrJ7Beif6PTq
         jHqyH7e59Rbf/9lqv0+OCCg1zN2OXLn2hQZ+t1apIgshXFRRlEjfaXuUfiyrqMqxLEgx
         PQ5Q==
X-Forwarded-Encrypted: i=1; AJvYcCU9TJbI8+rsxeHVEfRtPEUYgtfriISzc4qWZMR45tAMoHU2m2HDcCWuPMA/MLx06P3LvaFPtECBLQ==@kvack.org
X-Gm-Message-State: AOJu0Yyojbh0ReqCTe9ucipItC8hET6Wq6gKyVxijGhRv1H22TWavPit
	nfZRbZOXO4+d6ctNf23UHq3lTJfPrORnRXqJIJA5IYLtJjlcg1kgCOKcRbtEYrER13BclobfJRs
	mYF97Ow==
X-Google-Smtp-Source: AGHT+IH/6fHMrWMV8yp+8Ppnbbm83SfdopptQSAUB91QvYTFNTxXFVFSpf5U8i3i7fNPRxzlbwQGpMJ/fbA=
X-Received: from pfbei17.prod.google.com ([2002:a05:6a00:80d1:b0:772:3537:d602])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:1593:b0:2f3:3e1b:de66
 with SMTP id adf61e73a8af0-33495d4ea9cmr1351247637.7.1760553426186; Wed, 15
 Oct 2025 11:37:06 -0700 (PDT)
Date: Wed, 15 Oct 2025 18:35:54 +0000
In-Reply-To: <cover.1760551864.git.wyihan@google.com>
Mime-Version: 1.0
References: <cover.1760551864.git.wyihan@google.com>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
Message-ID: <0ec7349858142439ed0a250e6c04edf84cb0f488.1760551864.git.wyihan@google.com>
Subject: [RFC PATCH 3/3] KVM: selftests: Test guest_memfd behavior with
 respect to stage 2 page tables
From: Lisa Wang <wyihan@google.com>
To: linmiaohe@huawei.com, nao.horiguchi@gmail.com, akpm@linux-foundation.org, 
	pbonzini@redhat.com, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.or, 
	linux-kselftest@vger.kernel.org
Cc: david@redhat.com, rientjes@google.com, seanjc@google.com, 
	ackerleytng@google.com, vannapurve@google.com, michael.roth@amd.com, 
	jiaqiyan@google.com, tabba@google.com, dave.hansen@linux.intel.com, 
	Lisa Wang <wyihan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Stat-Signature: k84syr14o3s8h146fsdpaa8aebbx79oe
X-Rspam-User: 
X-Rspamd-Queue-Id: 5288C80002
X-HE-Tag: 1760553427-77306
X-HE-Meta: U2FsdGVkX1+HHjnuUWWR+id8oBCZwr0Cc+rzSRmmSzbzeS0qxLc5z8EXrHSXqNj+8HOFEdU/LFnu9kK6iTKAGWUUZsySW0+xNMbrvl4KPL8yckIy5c+EN4EslUM7OhAdhpez/yVanneW4xsGMRMH493Tbmx/8F+b/Fa1izYprTwJHAXMLXId8uQpyttKMPJPDGePVJBshH1be1GWHD3CJjdYchkUvWcZLan/hZjaCzk7AaoepF4XiBO+A7Ptt3z31V7TsfW1jTEKyjup1BGpOHHoYhjLwOf27ON73rjMaPRBjDC69Xm800HljOhjWrTUbXrOIHI9zQMJoqRb5qiOkFSnSAnwTfTs8YpqWtmeqbFrCJz8X9v+ycpYFfN0ZmYlpO5s52wotSaEq7Ucxs/izbkji7yLfJAGkdt+WH1PnI//PyLnbPFcrTT8wDz6wf/SXDlbJHWWfijHxsDjpZRjRR6rL4e+cHwPVsMmNH0rlpZl/8SHiPgV9DDW1lUoZGCn4JRin+3v9oWGdJ4sLnp/YTl0jopwPXO0dPqAaIGEcIQCCprmuygGveYELXf+LyhfOvwzFYj6OrfH12IQkSgy4bRkj7E/XX3320MRpSTYCzgCR5ieJmmooMTBLUXnOsgmo5BRI0NDnRw7BxmAUs1S5/Ouj/mlg7h8XxHW2trj4SreSxSZrk4hKpSEMNM39ctEYunWyONm9YS69G1JSX6gRPPwr2DM0ezSo08E/JIWNNkhIYXeSJVvmrEtVxizafSIGv4dAhGP/tMCtzWYKUf7/tdbmsunNbpZojgS7pxwhI4njPzIjKaFTjp0pYO7+cpRMtV7+kIvkjYiz7oQajzbSZwybKNaz+qWc5B1dDUf3b3FgjM4bte1xWpF31k726UPLk6cNPfMDlqsHbEjLBL2sqV3EgFAx+0MbUX2HlSRbmT+dxGsPymd/Y8lkVJyq+bMbnEnp45bhhyC7hNzJ3/
 cTpOReQR
 C7i9eydr6p8cLbVwUW/FWKvX5ieO6iIgfeuvMLfJZ5zGMp3TeH8xy+aMp70iavsQDvEnjiYwZqb+ppsJyT0ul0jtuCQ3Eg6XDhedbYvxO+RNy6ezKuvQfgCmkw0qp9Oi+DqIr9Pf/rF/v12DbR9sXQRZloiNco7b4/Ij0zXR1Sv/utARzlIKdPsU1/grirNCNea7aresU0Ycwwlmhk/KczQFS3WP/DIMbfyGupiVccUx9KiCZXsY9kV1fXfvklcliuNeID5mz+9vHXFOm1m+G46zjTHPIOn+sEG60fFMi1rgc3X5p/yRgzHYFM8nDoGmRnu0PYHOJTnRd/+JCQ+EDvaalNs/6/qlBpP9orZFTGAp+MZc/WnzMWQRaqRuveX08uti0hp1RIER4eib1KEFWwvrJE1OK/FaWgyZeLNaW0KQ7zVbyqNp3B1eSwCm2K0Fu799o/m8QFYMqe0+n2AMqDGzgcZAnpNbLum11yMkEegxptYED3dTcOha/HiireR9XihRNbSwhkiAHnJ8k8o9xws7wpOukAlQdYgiUI5MYWgJfOxTAYgGniaj5XY5lkSi4xf+0T+fKM2VhzAEycCtTg8b3OsyKngx545Zq8NdV4TmlNKPMZIXC/4/5e7dACix1Tmtl0AqdK5tP67LECnkmPdKvPE5OYIixfCW8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 .../testing/selftests/kvm/guest_memfd_test.c  | 65 +++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 7bcf8d2d5d4d..dc3398e22edd 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -539,6 +539,70 @@ static void test_guest_memfd_guest(void)
 	kvm_vm_free(vm);
 }
 
+static void __guest_code_read(uint8_t *mem)
+{
+	READ_ONCE(*mem);
+	GUEST_DONE();
+}
+
+static void guest_read(struct kvm_vcpu *vcpu, uint64_t gpa, int expected_errno)
+{
+	vcpu_arch_set_entry_point(vcpu, __guest_code_read);
+	vcpu_args_set(vcpu, 1, gpa);
+
+	if (expected_errno) {
+		TEST_ASSERT_EQ(_vcpu_run(vcpu), -1);
+		TEST_ASSERT_EQ(errno, expected_errno);
+	} else {
+		vcpu_run(vcpu);
+		TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
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
+	/* Fault in page to read pfn, then unmap page for testing. */
+	READ_ONCE(*mem);
+	memory_failure_pfn = addr_to_pfn(mem);
+	munmap(mem, size);
+
+	/* Fault page into stage2 page tables. */
+	guest_read(vcpu, gpa, 0);
+
+	mark_memory_failure(memory_failure_pfn, 0);
+
+	guest_read(vcpu, gpa, EHWPOISON);
+	munmap(mem, size);
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
@@ -559,4 +623,5 @@ int main(int argc, char *argv[])
 		test_guest_memfd(vm_type);
 
 	test_guest_memfd_guest();
+	test_memory_failure_guest();
 }
-- 
2.51.0.788.g6d19910ace-goog


