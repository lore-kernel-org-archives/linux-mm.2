Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB7F4C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:48:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79AEC8E0001; Wed, 23 Jul 2025 06:47:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 772BF8E0018; Wed, 23 Jul 2025 06:47:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6670B8E0001; Wed, 23 Jul 2025 06:47:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 54C988E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:47:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2A34DC064A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:41 +0000 (UTC)
X-FDA: 83695203522.10.5F524F3
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf08.hostedemail.com (Postfix) with ESMTP id 510B416000D
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="ipPLBaZ/";
	spf=pass (imf08.hostedemail.com: domain of 3yb2AaAUKCJIFwxxw2AA270.yA8749GJ-886Hwy6.AD2@flex--tabba.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3yb2AaAUKCJIFwxxw2AA270.yA8749GJ-886Hwy6.AD2@flex--tabba.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753267659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HOSoWQ4+/yGEs/NqGALv7XevomaPnLrGHC8IlSxBAg8=;
	b=EGPgN/Z0TcHS1vZ1LJ66oHLDO0NKt++Zly8erUFNRv7d7sicbgk6CWFgqwcx4YmB4+JfQv
	78SVkJGV5g0h0+EGHmxhSvzSns4/L1Y914KlgDjK5hlpg1VZD7uj5feQxwPK98svCFPxvw
	BvBnCgPB/vc8arec9adtwup16GNmBwo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753267659; a=rsa-sha256;
	cv=none;
	b=P7KR2JRAiQxozmlUjdel2NQ+laRqwyhKTAY8bxkYtg6VNLKs5OHpRIOoNzQ4GZszurSzGs
	L4cO/8+xFE4iIJqtiNJ+9IyT5FK6CSJCMImKoGpLhhMA/Jh8FkljgVzKv8A13Gct5QJfDc
	eEM4GE5KDi3lv95tl923ufdJDHxMvJ0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="ipPLBaZ/";
	spf=pass (imf08.hostedemail.com: domain of 3yb2AaAUKCJIFwxxw2AA270.yA8749GJ-886Hwy6.AD2@flex--tabba.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3yb2AaAUKCJIFwxxw2AA270.yA8749GJ-886Hwy6.AD2@flex--tabba.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3b61e53eea3so2901499f8f.0
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753267658; x=1753872458; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HOSoWQ4+/yGEs/NqGALv7XevomaPnLrGHC8IlSxBAg8=;
        b=ipPLBaZ/u4My1HBHbSX3aZHHegUJf4IOTqI/9jPTKkOW0gkBKWOc7rW2dGJRO69N3T
         qPXQdUef2dncz+6guHoeceMPnq0Hg6/swpsHjG5YmuMMjBmu02EnfRC6HQmR0iRs4fQC
         T9epAbClChl7n2BkK14OqBW3cP8oU5E6cWdrT2TkLaZj8FlH05s5IquLWZbN47S67io7
         Ui8ysckSg5rUWG+EfUurFZGEWJkR4zFU1d0PRTZkCmFtAowv/lkooHUSrj/Rxo++NxHt
         aMZl6mEr8UzC3SiXaSfjUKdJvDlme3n6zLFocZyfww6TZe8juXyJe1UOGuwD0pb48jKL
         IGzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753267658; x=1753872458;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HOSoWQ4+/yGEs/NqGALv7XevomaPnLrGHC8IlSxBAg8=;
        b=doxSg5WsoX32SA/Jl07EpKuyxZcGq7duAUzsi1Zia5qdoOGvvb20qRFKXDFJr/RsKp
         AtU6lfv0wA19Qat4a/OrviWwC/gOyMbTRcgjRs3KRLbl3BnhvI0oclrxx/mHuOisySIo
         4JCslvlcn1xJpL1uUSQfXQEp8fmB/SgicAhprhkvImiH1vup70CsAb52EeoZgx1NivXY
         8dwpSLFrL7jTGlR7BZ7Z8yM8ZvpfiKqfU1blFi/tYiC9wp5ez3545kV07awORngj9vEq
         JFTZ6Grr+AadKH0QqrbGZOVtqnjbOUtm1IO3ncUHZe4pPOCsKOWhMhyP3VEJkE1adIek
         m+Ug==
X-Forwarded-Encrypted: i=1; AJvYcCWdA1+1M9tpQGoUeO70XE8nOOXCtOlCAHYrpVq+UCyXgHNAtOaHneRBCtg9jpBsY2lLCjq5pnYTKw==@kvack.org
X-Gm-Message-State: AOJu0Yz1SYfyJJy0js+U8mW7s85frSChO0T1jW17su2Q2iyWu1KGr0RF
	th9rPYqv9HQsRdZCRMPUl1e9kqmSaRPBcUBoIIxi3ajilxD8nVfuClZu7BiO72IDz1aTzeW6mxp
	U6A==
X-Google-Smtp-Source: AGHT+IFYDyBWPe2+6tP7KCxBAfbDw8azEGmzllmCBYSUMT9NPuE3ieg8wuyvATEHSgUhh0Dh5p9i1h8xlg==
X-Received: from wmrn36.prod.google.com ([2002:a05:600c:5024:b0:456:26d1:4451])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2dca:b0:3b5:f7a3:3960
 with SMTP id ffacd0b85a97d-3b768ef9510mr2077699f8f.33.1753267657792; Wed, 23
 Jul 2025 03:47:37 -0700 (PDT)
Date: Wed, 23 Jul 2025 11:47:13 +0100
In-Reply-To: <20250723104714.1674617-1-tabba@google.com>
Mime-Version: 1.0
References: <20250723104714.1674617-1-tabba@google.com>
X-Mailer: git-send-email 2.50.1.470.g6ba607880d-goog
Message-ID: <20250723104714.1674617-22-tabba@google.com>
Subject: [PATCH v16 21/22] KVM: selftests: Do not use hardcoded page sizes in
 guest_memfd test
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
X-Rspamd-Queue-Id: 510B416000D
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: qxayczr97wtamwqkjcjssnwuccnhxqsp
X-HE-Tag: 1753267659-841986
X-HE-Meta: U2FsdGVkX19RO8A3DGgVVNimTn64ZNC4lRtHhgMJEg7eiTt1FyIdDpH47xvhY63ANcmnCxKBagVxkea9DlfPoUY721Ibbl+NLXyd0H5IIDrU0G3Xj4n9rhLn52GaP7jB8D2uzw/rusDUkegiIbYm4QzmFptqFqxixec9TGrcFcb3/0TfKZugWfbQf8m3NK5uQdJHiSGJ8eAN95b1ZzkIeVCqSNoqL8SX73H2TMk1368yVm5q8WQYwLg+oBSYrVS6jVz3OhQCkDivBJJRDqXCAs3nssJfGPYii+cqh3TXklVxFjR9xR/ph0O1PPQLJvOhRFIPfGdZEAL5yhROIJWAwSaXQWctgL7l7UUjpAs70SLgNmi9QkWTo1rDfjwpMwDP3j5dDsjF0LVLaI1Zd29qXGS/atKPD9ACUUJPsiYGLYmfZ86s6weSgFqR/Pcl5I6Y045MUU+Jy6Hn9yJak6uSYy8z13QK6JnWK7WNJgly6fgBd/+e8I/UGJtqiZNGtGCdehfHF4iwqpUcFC+xyPMtla8YeJRnNrPefNu+44842D4V0ahc3Er362X+WOXlFwh5VZWgNKSGw/kxHNq88wI/iwprh5d1oelW4oFXqYXqD9oc9WAdLJxSWBYpkGhww2VBKPQGgDXlTvBRgKqpSiZ7dIK+qMvpuUsZvCFdHJ3/GrgZKK+F3mR6Bud5LiIfx/EIuIVt7ZsryUKWYco12TwnVB5DY8wfCKJF3Heut3Aoykd3GA0h3oiyLccF4cyquOhQ4OWWSk7Ai0Nujtji17Y4IhUp3tQfymnaMqKlFVtApuwwJNvavMC25zHbkqlKC15wD3a9y+Pq71yEeozCIWaeVYN51cqXlbAU0Us3TEHgr+oqj3GJinSaxR9VUyKBm1ypF7IjGvqY5a88tua6jI4TGGt4pZTJzAoSCNJN1nNDrfypTDYomx0O+XH9XRub1vzL4BuoAbZA61qEIBk6ja5
 ayzGOv2d
 N27cP12CpzCSox1CaQzIA4GBSU5OXNYFye+9YfivFqxzwEKOeTjnv332hvNt1la3OEvP6KrQM0zuFW4ytnwnAM+qPwchYlZ5EIvSU+JcLsHxq8Tp2P2RER/QOdI62eFi44Dj1koAQP4ucj9Ie1loUAVe3p205xrFBOMJ0px84QT3rBKkDmmH8xD6uBM31KjHMC0n7s/UgFZiuploM+eFPHRxztRDCjS/eIOpd8i0I9beylqW+pHE5WwWO2SO9jTwznuNXiOuadZjovE0xNDfeRi+YcHfbbRURW+4x1MqmGrPF8cFIVxhW626vvk3PhxEgp2Cs3TEz35B2p4+q6c88KNOAymrTstJT4WfK4Czw20fTLPjW1lBkTc1DfTdGjkVEUGXYHNYnJcgvejAEETPEvOP5CH//PL5sO0Dg1hl+JD+O7EfdIz9ONMFOJG+o4qwIzD+VnTTk79Cr/JimuqfrHx3mLAtkR0i0iJuANoUweWQFGH2s1essxFp6Ixlom+ianswjikAcWo9r0qhqljgLjDdwTFrKxroblCavOPb+VSB56TrsDgwVRxCK9YGn7xGNPhnUSc8AKX2w1/Z0Zzd0hMF2GNz4eCT8b7mufl08D0YV3D5jUb4r7Hbqmmry4Ur/Prop53K7V5JXgFq3Gww3WNqbSfzI6pi/dKxlvfuW+PzGAUs93kBfSW/Z6ArkYDUym9c3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the guest_memfd_test selftest to use getpagesize() instead of
hardcoded 4KB page size values.

Using hardcoded page sizes can cause test failures on architectures or
systems configured with larger page sizes, such as arm64 with 64KB
pages. By dynamically querying the system's page size, the test becomes
more portable and robust across different environments.

Additionally, build the guest_memfd_test selftest for arm64.

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Shivank Garg <shivankg@amd.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Suggested-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm       |  1 +
 tools/testing/selftests/kvm/guest_memfd_test.c | 11 ++++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 40920445bfbe..963687892bcb 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -174,6 +174,7 @@ TEST_GEN_PROGS_arm64 += arch_timer
 TEST_GEN_PROGS_arm64 += coalesced_io_test
 TEST_GEN_PROGS_arm64 += dirty_log_perf_test
 TEST_GEN_PROGS_arm64 += get-reg-list
+TEST_GEN_PROGS_arm64 += guest_memfd_test
 TEST_GEN_PROGS_arm64 += memslot_modification_stress_test
 TEST_GEN_PROGS_arm64 += memslot_perf_test
 TEST_GEN_PROGS_arm64 += mmu_stress_test
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index ce687f8d248f..341ba616cf55 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -146,24 +146,25 @@ static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
 {
 	int fd1, fd2, ret;
 	struct stat st1, st2;
+	size_t page_size = getpagesize();
 
-	fd1 = __vm_create_guest_memfd(vm, 4096, 0);
+	fd1 = __vm_create_guest_memfd(vm, page_size, 0);
 	TEST_ASSERT(fd1 != -1, "memfd creation should succeed");
 
 	ret = fstat(fd1, &st1);
 	TEST_ASSERT(ret != -1, "memfd fstat should succeed");
-	TEST_ASSERT(st1.st_size == 4096, "memfd st_size should match requested size");
+	TEST_ASSERT(st1.st_size == page_size, "memfd st_size should match requested size");
 
-	fd2 = __vm_create_guest_memfd(vm, 8192, 0);
+	fd2 = __vm_create_guest_memfd(vm, page_size * 2, 0);
 	TEST_ASSERT(fd2 != -1, "memfd creation should succeed");
 
 	ret = fstat(fd2, &st2);
 	TEST_ASSERT(ret != -1, "memfd fstat should succeed");
-	TEST_ASSERT(st2.st_size == 8192, "second memfd st_size should match requested size");
+	TEST_ASSERT(st2.st_size == page_size * 2, "second memfd st_size should match requested size");
 
 	ret = fstat(fd1, &st1);
 	TEST_ASSERT(ret != -1, "memfd fstat should succeed");
-	TEST_ASSERT(st1.st_size == 4096, "first memfd st_size should still match requested size");
+	TEST_ASSERT(st1.st_size == page_size, "first memfd st_size should still match requested size");
 	TEST_ASSERT(st1.st_ino != st2.st_ino, "different memfd should have different inode numbers");
 
 	close(fd2);
-- 
2.50.1.470.g6ba607880d-goog


