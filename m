Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5609CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:13:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E0DC8E0088; Fri, 17 Oct 2025 16:13:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 945228E0078; Fri, 17 Oct 2025 16:13:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 809268E0088; Fri, 17 Oct 2025 16:13:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5C7878E0078
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:13:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 210C113A78F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:13 +0000 (UTC)
X-FDA: 84008705466.02.490E58B
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf15.hostedemail.com (Postfix) with ESMTP id 391BCA0007
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zCVq6KhS;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3VaPyaAsKCLQUWeYlfYsnhaaiiafY.Wigfchor-ggepUWe.ila@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3VaPyaAsKCLQUWeYlfYsnhaaiiafY.Wigfchor-ggepUWe.ila@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZ34d+VZkuHwS4Tl5hmiFloUpUjtvLj/jsnwlnFoI8s=;
	b=W/jXiy+pnYa6jYDnfrEqkgNi61sx2SuOqhQTKu1koEr8MeAzqA8ZYUSUZxy7RjNa2q/g3g
	r7kHVmv/skOGUqE/8uUXxXZtdUhVbdLA5PHJjYfYsjxepR3mHmt3YRPe+ECjll+rjcBZrw
	R0gRT2WpVU1NqQbjNd76igIS0kVKtFA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zCVq6KhS;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3VaPyaAsKCLQUWeYlfYsnhaaiiafY.Wigfchor-ggepUWe.ila@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3VaPyaAsKCLQUWeYlfYsnhaaiiafY.Wigfchor-ggepUWe.ila@flex--ackerleytng.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731991; a=rsa-sha256;
	cv=none;
	b=kdm0NeSjMa7WOgZxa3HNjKrk400KJb4vgCKIAtrUmpMAiO6PQidxMNGSmhdGBzImqpUCdg
	q2AXGAYg+bWZEa5QN7DIkZLjOhLCYUB9EhbEP3ehDh/mEOEz1Cg/BnNvtjzSX+0/tKkdqS
	YBP21f9yCVe1PhJReowoEy4SDySs35w=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33ba9047881so3096537a91.1
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731990; x=1761336790; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zZ34d+VZkuHwS4Tl5hmiFloUpUjtvLj/jsnwlnFoI8s=;
        b=zCVq6KhSy2YF2i9PjXiTW/HoPNF6lpVQXR1BttNYu93gmlmE+lkQ5ni5FXcrSra1Ed
         yeQEnK4vrjXmdkZD9lnsgOr2zpJWmWE20zmD/vMxHch7ODWrw5fd7O1w+JtBBTwgqdTv
         yah4+tdBOaChNvL3M2qvzAEwF2ILufFynKPENrMP69lZh01WkJqsqQ/DDpSklLk6R6cs
         yKAIqzJg9rh5sgTQbBpOiROyqGJaVz+RvGzvWu5WxxfO2KyAamqlhLkx+fHJL+9rh1k4
         UK0s/T6UFm1wxA4AnnOrGjHpx0LbTK2z+Zju6g9QI9REzSwRZIRED4DWfjtxmFBy95sj
         qW0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731990; x=1761336790;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zZ34d+VZkuHwS4Tl5hmiFloUpUjtvLj/jsnwlnFoI8s=;
        b=CkaVh8d3/0Carw6zp68rCePU+A1cpQUdJD4gUUk9Om8PhPFLSVomo7ywBzx46JQkMO
         EqrfbeXnnjph1gWC2brvPuSvO9G46cR+iQS8KY45+XWkQF1u1ihZYtfyT8inRa7zTFZ5
         yOP+15ktSQLrb+FrVhKsxkl7kpyVpr5a2IlpDmpsN29qL6K+SNmvJf6eWMqhGFq9aC0L
         IVNzyL6m2jcfgPePJMGmqgvPQPj0S5bx4j7blECusLCj0nUOu0W36KjjsGk+3tLy4d51
         K13wtmG2CrKR+GvQLyD/MWNXJNwQeFktcc6eJ21Xis7Lvux5SoyY2wEUWk3Qz8dfU5wi
         VpNA==
X-Forwarded-Encrypted: i=1; AJvYcCU70oqCg+uLWDl8fgsQIELM+nIxPfVSiAYp9yBX6CTF1X7smGYNZ+dtWXZsrVPugQUC9dT7+xLD3g==@kvack.org
X-Gm-Message-State: AOJu0Yz9wZka2HVFnNYrxdWj4nqaR5wBrGaNgUZnak1/+KX1iSQlyjjJ
	4U1MGzyrBgcdT/zrEK/kPoxMe6GUejrhGc6BLYF1xIgMQ5GbiPk165RcNytxEIAxl4zUBdCqcLX
	M61FxzYEgBsEqpPX76hn+lb0Wqg==
X-Google-Smtp-Source: AGHT+IHzx6Q3hHG57ljkrAP15mW/fSli8KOfzlU9yowcOYAMM7uKRQLpZuKh9dqK1n26N00k3XfO53kYXQVOFNP6YA==
X-Received: from pjbpj3.prod.google.com ([2002:a17:90b:4f43:b0:332:4129:51b2])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:e7d0:b0:32e:23c9:6f41 with SMTP id 98e67ed59e1d1-33bc9b8dd13mr6981801a91.5.1760731989968;
 Fri, 17 Oct 2025 13:13:09 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:12:06 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <00b93a008a75a345f71b61ac67a2ffa068bc67d7.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 25/37] KVM: selftests: guest_memfd: Test that
 truncation does not change shared/private status
From: Ackerley Tng <ackerleytng@google.com>
To: cgroups@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: ackerleytng@google.com, akpm@linux-foundation.org, 
	binbin.wu@linux.intel.com, bp@alien8.de, brauner@kernel.org, 
	chao.p.peng@intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@intel.com, dave.hansen@linux.intel.com, david@redhat.com, 
	dmatlack@google.com, erdemaktas@google.com, fan.du@intel.com, fvdl@google.com, 
	haibo1.xu@intel.com, hannes@cmpxchg.org, hch@infradead.org, hpa@zytor.com, 
	hughd@google.com, ira.weiny@intel.com, isaku.yamahata@intel.com, jack@suse.cz, 
	james.morse@arm.com, jarkko@kernel.org, jgg@ziepe.ca, jgowans@amazon.com, 
	jhubbard@nvidia.com, jroedel@suse.de, jthoughton@google.com, 
	jun.miao@intel.com, kai.huang@intel.com, keirf@google.com, 
	kent.overstreet@linux.dev, liam.merwick@oracle.com, 
	maciej.wieczor-retman@intel.com, mail@maciej.szmigiero.name, 
	maobibo@loongson.cn, mathieu.desnoyers@efficios.com, maz@kernel.org, 
	mhiramat@kernel.org, mhocko@kernel.org, mic@digikod.net, michael.roth@amd.com, 
	mingo@redhat.com, mlevitsk@redhat.com, mpe@ellerman.id.au, 
	muchun.song@linux.dev, nikunj@amd.com, nsaenz@amazon.es, 
	oliver.upton@linux.dev, palmer@dabbelt.com, pankaj.gupta@amd.com, 
	paul.walmsley@sifive.com, pbonzini@redhat.com, peterx@redhat.com, 
	pgonda@google.com, prsampat@amd.com, pvorel@suse.cz, qperret@google.com, 
	richard.weiyang@gmail.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, roypat@amazon.co.uk, rppt@kernel.org, seanjc@google.com, 
	shakeel.butt@linux.dev, shuah@kernel.org, steven.price@arm.com, 
	steven.sistare@oracle.com, suzuki.poulose@arm.com, tabba@google.com, 
	tglx@linutronix.de, thomas.lendacky@amd.com, vannapurve@google.com, 
	vbabka@suse.cz, viro@zeniv.linux.org.uk, vkuznets@redhat.com, 
	wei.w.wang@intel.com, will@kernel.org, willy@infradead.org, wyihan@google.com, 
	xiaoyao.li@intel.com, yan.y.zhao@intel.com, yilun.xu@intel.com, 
	yuzenghui@huawei.com, zhiquan1.li@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 391BCA0007
X-Rspamd-Server: rspam03
X-Stat-Signature: 59jcbd9xcfee56daesidfxxuyyx71ajh
X-HE-Tag: 1760731991-799242
X-HE-Meta: U2FsdGVkX19aJto2F2nuAVrJ05p1TlLzu2Hn0rkleKkF4NtzXpvNCAfwMuptNYBLOEdWu/MonSDTFYZB7A7jvweE/5FmmeScp4LMg7ncWfbUb3rwjUZ6h7VS4LBfQkWm84vC+86YiaHppPCihpJgmsaTf6M2WoapUQHftcus8ajE+uarE7jffKFyPkky5YcYhDo16YG33CLUikos5XX09n4IrrLxx5goVsQiR+5E3nP15gyuk3hbqN45hT6UgLBO8lArT0HLOSvi4K3Jh6Eg0t8joo04HBsjf0Pmi8qJ/2JFdEOeMblJJ4T6L0ENP2UkI7iywF2h/fbp1kFL3uBuutU9lMF7Z74PgGLhrhH4aMXQdrwohReRlRGmqqE0cCGlWx1Q5r3Kg8gVw3hM2XftoLGfP1mz3Nsk5qktkC51KIoJBl7XKpKfVxuC2WRyJgCr46ThPLYvyddKO9tMMkgK0PrmnNzZluLWuFZgQg7BzmQ2W2u7Iseevze5yweQz+Kr8JWaOzqmb6NAHQS2pC5kxa5GKhNt/8bY8frQpp6fVu5UCjm/zaQy4exPs8E/ntG+zEWhxaub+eIJCjyWCgAUtmAqe/DFf5zs8GGcKWKyJWnf6JLl/K7wLNLl0rEvdtyOstaAHOFo1Q3gYpGdTxZfbb8HPVdBmM0taxYu5q1amTbqRlo0cL81V064H6ERLcje5zliENpp9qpD2Pyy7BRsSygb3c48uPC0YHer6acoXfOmPrEw9LtXcDWs7AnWKazcigXH6yn9Wm7FB3akRHx9YklbAdBrOmu3oYkCU4Cta71jjiXd4HvihdqMf6+FGgbRwOGsB5kVduTMND5Ir7EwuaOl2zB3aus2gtxEHzyaDP2H3gAIND+koGUp+Yx3iibxss3rf5YwDTkJvFJmWi6DvbWhZPItmQCDvbIuffp+6bMTweRJvcK9gE6tL1wN19kwx9ZBMLdtxJfWfwDk1Fq
 XDkGaNWI
 TF6x4Bd08MLccOcvBAVH5/ae1fQFhEhVRP7xx7hLkjAaGgQCJBDvER1HMkGvA+IPgghPGYgFKNkz0nV+PK/cY4pIV2ztjJk6EGCHA/BYT37jFTrZ1DU8Y/Fw1SrfU5dP6kjEUKnqezLALXhmmnfYPiLQ/6suJ7y7uNg5SfAF8Ev7GoMeJQ0UnTrfPndDBD/CvQ9mdZIaUq84OheSUhUkMyE1tHHSbZrN9C7O3SF4JLn/YY9GRqs0tI8xO+zicR2W5QOftPsETPd4BUi6Rn5MIiGrjBthKwEjGVoHsAnXqenP/8IJUvW5yeVOgW4BPoXpunxl7hQ31SoD3KZ29NVeWF2ioanp/Z2BN0xyr4CDwMdIhjx47u96nXYmpHCcC0T1xtuCTdN6PptjkB8UWrveG8tlwHe5FBincxPXdvwiwKZFZi78YZGNtcSm4GFeroqXqP9hxRvaNqoRTzql64dkcvxsuhEh8h7uCZzlsOwl3oouxiGgsubLfeHkCeLXKFkKT9fksPWQyVp0EqkEoLKMTSPI+eLQQcjUipfJMiDwiZaaN6ubpKVXKC0qdtA7ZgU+WGzcSYU3XFSi1ADUpM1wbpqix+i5y1aKm7wHDC8fw7OS6QRnj8z6vAGOwNP2IwEAE3WQOUHQJfqIrLcCR6riCKMngdtCKk/LGaemqtqVmmk+NX3Ua4yyylrPZXYkySXwQn00TTPzamT+PMZPAKUt9Ydfu4DXcrW98QqqvwegCP3morfE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a test to verify that deallocating a page in a guest memfd region via
fallocate() with FALLOC_FL_PUNCH_HOLE does not alter the shared or private
status of the corresponding memory range.

When a page backing a guest memfd mapping is deallocated, e.g., by punching
a hole or truncating the file, and then subsequently faulted back in, the
new page must inherit the correct shared/private status tracked by
guest_memfd.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/guest_memfd_conversions_test.c   | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
index 43efe4af1403c..907d415d72315 100644
--- a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
@@ -10,6 +10,7 @@
 #include <linux/sizes.h>
 
 #include "kvm_util.h"
+#include "kvm_syscalls.h"
 #include "kselftest_harness.h"
 #include "test_util.h"
 #include "ucall_common.h"
@@ -316,6 +317,19 @@ GMEM_CONVERSION_MULTIPAGE_TEST_INIT_SHARED(unallocated_folios, 8)
 		test_convert_to_shared(t, i, 'B', 'C', 'D');
 }
 
+/* Truncation should not affect shared/private status. */
+GMEM_CONVERSION_TEST_INIT_SHARED(truncate)
+{
+	host_do_rmw(t->mem, 0, 0, 'A');
+	kvm_fallocate(t->gmem_fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0, page_size);
+	host_do_rmw(t->mem, 0, 0, 'A');
+
+	test_convert_to_private(t, 0, 'A', 'B');
+
+	kvm_fallocate(t->gmem_fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0, page_size);
+	test_private(t, 0, 0, 'A');
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));
-- 
2.51.0.858.gf9c4a03a3a-goog


