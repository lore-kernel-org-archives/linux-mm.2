Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9080CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 19:00:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 433318E008C; Wed, 15 Oct 2025 15:00:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40B4C8E000C; Wed, 15 Oct 2025 15:00:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 348138E008C; Wed, 15 Oct 2025 15:00:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 22C4E8E000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:00:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED3D7140286
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 19:00:56 +0000 (UTC)
X-FDA: 84001265712.01.0A3BC47
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id 07F4020017
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 19:00:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nXqcYa9O;
	spf=pass (imf03.hostedemail.com: domain of 3Ze_vaAYKCFIGI21u708805y.w86527EH-664Fuw4.8B0@flex--wyihan.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3Ze_vaAYKCFIGI21u708805y.w86527EH-664Fuw4.8B0@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760554855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r/50hzPJcz2Tgtv5Q95r1Wz9trycmcqvXu8eukDbYxw=;
	b=OnkLkwgP0KF5gk4FK7bH6LgNXwTZCmqgRVDMrGo67XhJVwctrcb9SGGImfFGu4YuiCFcY5
	LQRDXDCshhYb0qfI+D1vqvCgNfkkEZWJfCCpQJH6HCuNa1ZdBRTQThYfqYjamh1S+CcRDK
	qQvzVAP5+Jj1AMWJT2cYrnC4Wbl6rQA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nXqcYa9O;
	spf=pass (imf03.hostedemail.com: domain of 3Ze_vaAYKCFIGI21u708805y.w86527EH-664Fuw4.8B0@flex--wyihan.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3Ze_vaAYKCFIGI21u708805y.w86527EH-664Fuw4.8B0@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760554855; a=rsa-sha256;
	cv=none;
	b=AJS9futEOP991im35zOWBVZ24J21yQz75eFCmoDjxZzVi+WA/hDVm/DI5K07v+Z5Fd+m1t
	OP1ynOCtp89UKHiP7jWQrPejezyzQcQlo894+12Ti0sbL7HRcO5gPaeGpH67XIXh3Sa383
	Tga6HqHJFQLpM8ckXeNABynFTbsIIOc=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3307af9b55eso9985723a91.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760554854; x=1761159654; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r/50hzPJcz2Tgtv5Q95r1Wz9trycmcqvXu8eukDbYxw=;
        b=nXqcYa9OicB+BzXilR587luEC7025wRxUILhFwEBs5/O1y/OtoM27Bb7kr1Zqpdg3e
         sA4+OFzWjor84fjQXIZAKjYOkKVgqDPMABsfRQ9Gi1G7Phn72RvH6Q75ZV9TKFxauMJK
         xo84C9KxpFSNQAICB+8lj7vaSqGs140beAygYpU8b7Wpd+GVI6LWoZJKuk61N9ciDuWU
         nzGIFTF39M8zyeG8L4whEQWemzHk21N0LHYpBffc/VX17CiQKkc8rq9kwbai4Stgfe7p
         s0ke9qRGjslM3ZPMlLZtcUKagV0RC0KumvN3gv0tqh2HowA9qvlOZoBA196pZEdYS/43
         2Eog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760554854; x=1761159654;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r/50hzPJcz2Tgtv5Q95r1Wz9trycmcqvXu8eukDbYxw=;
        b=IdxGMd2zXaed8ZnMAL3BXPjGAbVWAhGhBqv6fv/Pmpw6uh6hFrbLisVQWUN8CtWonh
         yJMJmefV6+28U9owjEp/0Qc5FTH77ruDg5tyXvU3hj8ntODSrphIfIHv2YUmTYcyjZ7m
         SAqIu64wdBFs3KEJDSmlauA4L61tlUqn4xVs8a/g19TBImZ0kE+ScCyHYG2xWCi1kKXE
         +rdjG3bcCa3gE6CB1Cqjs7aGW12/94A2YS9pt60KDbNjr6YbmFQ/sWkOwo2n96Vfo8qa
         Z4gHPWh+rBUkxgpqA2WQQAyp3KdgEa4hvNmk+tG4zmUZRCg48o5ygxZhpPNA3gC+EFDa
         IPpQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9plWWJSrR0VqSD5iEpz3YQf72W7W4stBcobWZfWhTnVjkuYIf/mAWlDGFeKoMU3pnAAe+mDuPcw==@kvack.org
X-Gm-Message-State: AOJu0YxmmMvYgdMMA34M0LzxEcPvzyGeB8W9y9dZSmGjwxqgeTs5WEdJ
	aDtL7EAfx2CxIm71msXMCvOpVUCZmG6ecozRhlF1IhJGrSNI1oyoxrXZjnOrjlhif5G8W10uAEB
	Hvlwk+w==
X-Google-Smtp-Source: AGHT+IF0aq3dEuFrF7ECI0NlSr0qYUf7fzC5xMEvWlZqMU7mOZwkC2btj1VQ3xgFa8CghlVjLKHevu9vhKE=
X-Received: from pjbfs17.prod.google.com ([2002:a17:90a:f291:b0:32e:bcc3:ea8e])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b81:b0:33b:6ef4:c904
 with SMTP id 98e67ed59e1d1-33b6ef4cbbcmr19120239a91.20.1760554853833; Wed, 15
 Oct 2025 12:00:53 -0700 (PDT)
Date: Wed, 15 Oct 2025 18:58:57 +0000
In-Reply-To: <cover.1760551864.git.wyihan@google.com>
Mime-Version: 1.0
References: <cover.1760551864.git.wyihan@google.com>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
Message-ID: <0ec7349858142439ed0a250e6c04edf84cb0f488.1760551864.git.wyihan@google.com>
Subject: [RFC PATCH RESEND 3/3] KVM: selftests: Test guest_memfd behavior with
 respect to stage 2 page tables
From: Lisa Wang <wyihan@google.com>
To: linmiaohe@huawei.com, nao.horiguchi@gmail.com, akpm@linux-foundation.org, 
	pbonzini@redhat.com, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: david@redhat.com, rientjes@google.com, seanjc@google.com, 
	ackerleytng@google.com, vannapurve@google.com, michael.roth@amd.com, 
	jiaqiyan@google.com, tabba@google.com, dave.hansen@linux.intel.com, 
	Lisa Wang <wyihan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 07F4020017
X-Stat-Signature: ieofnqsc6u37ztxag16j6pkyq37r1joo
X-Rspam-User: 
X-HE-Tag: 1760554854-37990
X-HE-Meta: U2FsdGVkX1+l6uTwr9XU9g+qAEZEIVoF0QaZ0qKD7v3Cfwk3jdcRFCcqyyf3kqFq8/MJenQpxXpIp0E+GnN7bfvy1k6S1n9g0sbIUhXwlF96rjlSAk9hT9J29wSGG4OvN/SrhtjuDPPkvyEajR6aW5GClQkmJYB3Aeg68TXdXtEYvPZdhd4RJ+zJAWsaKzDIeqUs/Z//NUj/khxZR9c/8oyF6pOUO/jqMPshx9zLLgd9NcSvI0ENIuodYNJeNV3iSbB7P9ihaqAek2BoFSyC9pQvZZZPSM2M1pwHzpiYLVnv53ppTWFc9bgMz90VKAJ8ENJUpxX8TARZvYesurF1s56ZpU5zP1aGZALhCgbiFrUSQSSVHzMBFfSCHgkrmqW4SIwXq7JIGtWkohyC+4njyoDd9xSEHom+q3B5vGiCN7Suczps5/emuEXve25k+Lswgr+4HxVtVa1PplTFM+bPopoW3UcUK96MJYpd3qWFvp4Sn28x6R7j7KR204COVR3PXadDroZQKQ+GyUbZfttNbm3G2kHLR5ryduKJEPSvh8MBNO7gstkBN+KqJ0663Fae7kBMVojcJDSohz1uvgMpWQiGSlnoQp7lcOTY5LVQMmsySzoHEHUstdW506Kvm5u1pLX+HK8vfEnZ9SS11mkkJs67PjJernrNhhVq8/b0VgkosuL+DKFSjzELGa9My3Kz1L0BbNzNi1kXG+weilBVd7h/8cSrUN0yeRi6voK2UJMl3GgAhUlVixYktCOFqDK8yXSQRJAFkSl9PBsocAR8IbhN6w7SqKIPfeT51Pzm1rTPsTXOGu2rslz7oL4H8Ppejf7JmNraURN2SfqakjzH//lW2ANQ3j8SOS1Go5zw4U5m16nMNLrhgn5IKR24ZG5kf30RS65BPYpW/IIoO4HbqkSuVAUDMNmHSEqjwysB+cPFXP4YoZB/jhjcu5lVcxpIhH0Ld76ww9wCJjlGDt0
 3AdOy4LH
 UzoHjy/y6/IojJAlftT03b83rHSi7GQkqLHp7eUNeBpgtytQj0Lli/O2YWDATc/v0ybyJ+6BVkeUeQiTKBSJpqLkHIlXBYOEL70RtDZzH3w/Lt5uWU8s44L7V+GJuFZJZMB95INBCC4UNbcGiloB59O6xHUE1vTYPq6UUjU3iHFZZcdu/FniXoKnH2TPIwP58ofNcIPSzu2Jp5AdAuP6HhKS0YqjGdouI69EqzNH4r81aRFLm4daJPTjXlmYSsWutY78SrO32MLk+CSUm3dXBlcqMsMdEhBfBYJc4todt2vzCfL6HJCUgEefxHZ55ikszyEAWiJ+ZEHMbGOdoHXNKZPZYCOdnV5ZUsOaowKb3TTiYgG3w77W0if2FE0Y3eqF6YmqHUYbWAE9Oy3D2t7HLexK2LffErqaujLIXjjj2hWl1Oq5pks0aM5vzQ4x7Kdun11kU9xz2hO3HlcgzkT9GX5Z5CM3Uw8lx5AcDS0t/dn/yiC90/JV6YDayf+nfIDOtMbmBF8e+xckiHKHo6FnR2WEanCvr7tddbXXmsHF1pBL5SLFe+2jXj4KL7VEs8676/qubTOan/2lDijQUgVo0u1FLBRfNUS8UdXQvYjn2x97go7ElDtlHT7ym/fIfdYVhq9u6D4ua0Sl/l1VMMorlJdI4889ZdSUbKUd7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>
Message-ID: <20251015185857.9x-S5ePfZQy-kFx3tqTXVzSbBVB_8ZYZUWILsgeTYmM@z>

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


