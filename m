Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52B3510AB82C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:25:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDBC86B00CF; Thu, 26 Mar 2026 18:25:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3996B00D2; Thu, 26 Mar 2026 18:25:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB5586B00CF; Thu, 26 Mar 2026 18:25:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 870E26B00CF
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 44C5D13C2F2
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:31 +0000 (UTC)
X-FDA: 84589646862.30.00EFFFB
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6CCE612000D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YC7FBpWi;
	spf=pass (imf29.hostedemail.com: domain of 3V7LFaQsKCCgEGOIVPIcXRKKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3V7LFaQsKCCgEGOIVPIcXRKKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ggNswhhr/Zm517OANSqq2rkmE45vkRU03sHcZjDR0o=;
	b=OYZ3QAzVtiTCkVF18VKZ1gg9+j5GehhgCO8AkJz8FURmByjhaNW2yc6ospu3zvz+PlFGQB
	JdaVkvowQDDhw5PFJPSptR4q8dUspBYXt/AHO9NMFm0nmTmm5bs/igMnDWHlUCMj8VQ7xZ
	9xLcDBc4IhQ9xWWSDJ1wg0T6vSvi60c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YC7FBpWi;
	spf=pass (imf29.hostedemail.com: domain of 3V7LFaQsKCCgEGOIVPIcXRKKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3V7LFaQsKCCgEGOIVPIcXRKKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563929; a=rsa-sha256;
	cv=none;
	b=FM7p0fIsZZvX4fvbPzbeg6+Q3EAo5egbX0JM3IMel+sTVRVDszr7JM1I0pDtuzf/y/SFyw
	9Lih5URiUhnEj+KTZTQlstgx2OvmORuvfe6F7X/Vsa66vWfXztwg9OrwgQvUB0dpjhzYMY
	xtHnFIxVhLfqd72hdSD8YBehgvwi+Fw=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35641c14663so1963236a91.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563928; x=1775168728; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2ggNswhhr/Zm517OANSqq2rkmE45vkRU03sHcZjDR0o=;
        b=YC7FBpWiC6Di3DOT3LgDkx1Ub8ItgWm75G9wzvA2yp0ENW7+4GCEQ4EgrBJiKuMgJM
         1f+YzoPohvLStFSlmI5xurpKHLU6OTCC/tWMsiCp+T24QilrlW1oPiqf9OoeUZHrXqru
         yhPAeksA3ABHWxltNW5xdsCE55c2cdSxDD8uIKJA4IkyPDuRrpDL2cdacR//kwbRgRUk
         CJ6dI4mZFO4E37Ce2B7URmHxJwkN001y6JUIZsnbbtV036ri6EaqxVdZIVDPY3Up3bbF
         vueaCOL/p6wzDQo5rPk6OTYFFQefU1+7dhapgngsb+N8LVTDzfulZuZv1iKukuyvAbsC
         6CKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563928; x=1775168728;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2ggNswhhr/Zm517OANSqq2rkmE45vkRU03sHcZjDR0o=;
        b=aytAkMi4zqZiqsd6G9JPUJcx0jRJvam8xGNknkZ3EQgDusCI+R5DPuvSJpUizVIjmX
         ZJT+Rc+fBBnVk2by3izCLXN+qSWVqSoLIiq9LRvuueCQliliLTQNXOlY3gR5oVmaemsv
         XqoWHZnsmOrIyWrk3cr+uEX9QGgSJne30NoLm2M35KNYE3uDrjyiW24zeUFAFNiQWRLH
         ZPUIT0vgOKTjqwKtrZRWwW09HzH2ItG57KwH/Q4bSpAaMUAppGTs7B7YoV2tQGBhaq+u
         lkpn9HSWuLwh+OhXdGZqwBc/SZ217Dd78a4eP7/aRMY6MmGAOf1zbbHIsjkZKnga1IL1
         pSzw==
X-Forwarded-Encrypted: i=1; AJvYcCVrMSn37Hb9rtGf3UP863aSM3Cfxfzik/UaLFvA958zxlkWyOplDdbloP3DQ1gS1oepAOM2xpg2cg==@kvack.org
X-Gm-Message-State: AOJu0YxcW2d8MRHx7y713hKCoqOdAflxcNNSmrpLHMefN6YitWwHj7E/
	5ZBqX4+3xZlQSZOogb33sS+BvWhzyB0L05BGMqF/3joszNz2qYop8Sn27eCwNwtV6uwjl3QhOlv
	Ie1mCtk8MT05JbvmsocWhWyTuwA==
X-Received: from pjnj7.prod.google.com ([2002:a17:90a:8407:b0:35b:a7ec:bdcf])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4b09:b0:35b:91e1:e110 with SMTP id 98e67ed59e1d1-35c300b28c2mr201652a91.20.1774563927809;
 Thu, 26 Mar 2026 15:25:27 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:40 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=3458;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=rCHdbveRHCq7Lbc/rPtcgMntFgrdjmRTxwCISj2xSoA=; b=94b8fZUYxxJIKK9M9r3xD06IQ9vXckRDERR0FGKGfKfHyQV+XY++9gfIYlhDE3CaPLXOwvElg
 etkz1NTy8bKCo8Ev2jmSLBQv/vyzxaNNaFAVWxjQJtFQibPkf6fSTHU
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-31-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 31/44] KVM: selftests: Test that shared/private status
 is consistent across processes
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 6CCE612000D
X-Stat-Signature: xjk1etqyttyi4s7qxia6eghnpc1mksjx
X-Rspamd-Server: rspam06
X-HE-Tag: 1774563929-549590
X-HE-Meta: U2FsdGVkX190O0iQ9yIU55hs9B6dmObphDPTVQKk2sr+NU9FtreSDyo5LUS72QrXVJRHrG4V9uIwxBUKrCOETi1SKWyZtVju9b7ymk+hHqcdw4HUkz1RdICRIY3PmpZLlDSgSWwurUcP77eTB+F6BU8Add1BpV9H0bsw3a8YibB/eVTkKPPfaJ1pShZMQQVgwiogFNq688NjS03T0Rvlh8PWYqs6mAvlMD71Y5cGAxPdbAIKijAceSOPxCVrSvrzeyMxrZ+29BaQSVQPk0Ff2q7eIJNB+B7nV2d1mCLp645MlMzF8cx+ASJNYKfxlGe0chPS/PVomAB25SqOZkHu77gdUepbJZhGDZmeYzC+ZuX1L044y5jLtqJIdGyxtd+kHThtLm8s/ZSaoKhlo/gsTznw2EQqK6YnkwagnianfRVXvxGaXracYSwrGdpVC4KGu+Pinu10j/GBfh6SyywIZm/qW+j4/HA8PexZeFtOG2ydJTidw5fO/0TUH3XwgD1lReZUjC+ly8dSHUrQLBrowWlEime5IiJU5mvjAOvwTzXYNzniFbYQXXj8IQ2ZpCjXvCd14U27A1cis1e7bGigr11lr7Qd2+m3MwL4V0t19/8amh10w/y3WdELsf/fIpXiDJY3fE4zLTYl4XJ4WNh6O2NNJAPCW5bPRgPnoOB+9cB/zAv6tFmPJ/6tJqc6wO1H73EUJi6dWCkHw9UoYUffwm2WnH4dTjZBuxEl1qevViX8hpp+qdHLeRdE0+zXcSuQQC7qmr1lYdAXxHCiUbltf6GVAFgeNRPc1bB0xqNNnmoEOCr3byv2o3eQAXrgy9WH6w0ZjRgY4cZS4tS5HgBAZwUFVC3Vpnwe5G9V0/4MeN/l+bmEcE87MXlDGz/onjhbIgG3X6Ql+EdHPnD+pnKOZwHtHcNggfVRhdaA4ghr4ii7xHk1teba6dgqjA/jJs98YS7GdzUgeBc0kwy9BiF
 Vlj1ub4N
 tlhaGNtZX8oYONvnnOw/j4E0a8V5/owlvLAhYuQxO01hxfFtwzvnNg8CW6s6ZSOOeUrNMjh7Wv69lWw2L1Uke8ZmpwTdGDGdHOC/7hJDezbTNorZJPtGRSq15n9rCboq8nXTMCkt/p4zvmt6M81Dqdg40gE60+hmIhR/shopK3rcDYUSJAicr2dlf8eRkcSNEAQE4rlhqFw2IHBJ/e/1oJmqhI3N9HyfrrSq8liwAQcyebC63ftgjIHGwog6HpXX8qlYUW1wXI0VpKLWl55XpvsqSD7EWovHcZeOxx1vwxE34mxUyg2AVBtJmMnDSATK5j2wmcqFH7Vjit/jIvx1Dl4VA7u937mAWSN8oB8unhfStiCoVoPIev4wzDy5q0c4iRSEl+LYAgICz//xSoRgReXj5gt0wap82EhX2pmnP3Nj/BiYt6kWrp0U/rNC0oksZ5tS3NXIGMzP8NuxCKXziBbQuNwcIHOnHdpGOjumd/6lBEhfpezx1F9tA7TmWqsgWWnlvXEA2xtsekjr4wkh8iQkvyMIOWnk5XguiMfnZRUj+y8reodl0iaSBgcCobF8W0ckQqKwFu7YzqxfnUSpE4WncCHYd8ro/1Etc6TNU3nL1h81lvnlEVHaL3qOWKij671BydIOUwPtcwkq1be5EVpzjWyQ/JAqDNScK2YqvGyOrVnLYcm4JQBvRQ6jPaDW0rh99bivfnxjL4/Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Add a test to verify that a guest_memfd's shared/private status is
consistent across processes, and that any shared pages previously mapped in
any process are unmapped from all processes.

The test forks a child process after creating the shared guest_memfd
region so that the second process exists alongside the main process for the
entire test.

The processes then take turns to access memory to check that the
shared/private status is consistent across processes.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/guest_memfd_conversions_test.c   | 74 ++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
index f195a202b3785..ed310f26d88a1 100644
--- a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
@@ -334,6 +334,80 @@ GMEM_CONVERSION_TEST_INIT_SHARED(truncate)
 	test_private(t, 0, 0, 'A');
 }
 
+/* Test that shared/private memory protections work and are seen from any process. */
+GMEM_CONVERSION_TEST_INIT_SHARED(forked_accesses)
+{
+	/*
+	 * No races are intended in this test, shared memory is only used to
+	 * coordinate between processes.
+	 */
+	static enum {
+		STATE_INIT,
+		STATE_CHECK_SHARED,
+		STATE_DONE_CHECKING_SHARED,
+		STATE_CHECK_PRIVATE,
+		STATE_DONE_CHECKING_PRIVATE,
+	} *test_state;
+	pid_t child_pid;
+
+	test_state = kvm_mmap(sizeof(*test_state), PROT_READ | PROT_WRITE,
+			      MAP_SHARED | MAP_ANONYMOUS, -1);
+
+#define TEST_STATE_AWAIT(__state)						\
+	while (READ_ONCE(*test_state) != __state) {				\
+		if (child_pid != 0) {						\
+			int status;						\
+			pid_t pid;						\
+			do {							\
+				pid = waitpid(child_pid, &status, WNOHANG);	\
+			} while (pid == -1 && errno == EINTR);			\
+			if (pid == -1)						\
+				TEST_FAIL("Couldn't check child status.");	\
+			else if (pid != 0)					\
+				TEST_FAIL("Child exited prematurely.");		\
+		}								\
+	}
+
+#define TEST_STATE_SET(__state) WRITE_ONCE(*test_state, __state)
+
+	child_pid = fork();
+	TEST_ASSERT(child_pid != -1, "fork failed");
+
+	if (child_pid == 0) {
+		const char inconsequential = 0xdd;
+
+		TEST_STATE_AWAIT(STATE_CHECK_SHARED);
+
+		/*
+		 * This maps the pages into the child process as well, and tests
+		 * that the conversion process will unmap the guest_memfd memory
+		 * from all processes.
+		 */
+		host_do_rmw(t->mem, 0, 0xB, 0xC);
+
+		TEST_STATE_SET(STATE_DONE_CHECKING_SHARED);
+		TEST_STATE_AWAIT(STATE_CHECK_PRIVATE);
+
+		TEST_EXPECT_SIGBUS(READ_ONCE(t->mem[0]));
+		TEST_EXPECT_SIGBUS(WRITE_ONCE(t->mem[0], inconsequential));
+
+		TEST_STATE_SET(STATE_DONE_CHECKING_PRIVATE);
+		exit(0);
+	}
+
+	test_shared(t, 0, 0, 0xA, 0xB);
+
+	TEST_STATE_SET(STATE_CHECK_SHARED);
+	TEST_STATE_AWAIT(STATE_DONE_CHECKING_SHARED);
+
+	test_convert_to_private(t, 0, 0xC, 0xD);
+
+	TEST_STATE_SET(STATE_CHECK_PRIVATE);
+	TEST_STATE_AWAIT(STATE_DONE_CHECKING_PRIVATE);
+
+	kvm_munmap(test_state, sizeof(*test_state));
+}
+
 int main(int argc, char *argv[])
 {
 	TEST_REQUIRE(kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM));

-- 
2.53.0.1018.g2bb0e51243-goog


