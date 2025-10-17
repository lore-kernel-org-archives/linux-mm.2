Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8A76CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:13:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CF578E008A; Fri, 17 Oct 2025 16:13:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12C5B8E0078; Fri, 17 Oct 2025 16:13:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0EED8E008A; Fri, 17 Oct 2025 16:13:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D908D8E0078
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:13:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A7A921A02AB
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:14 +0000 (UTC)
X-FDA: 84008705508.26.8CEFD16
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id D2D86A000F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=J3MnXqvw;
	spf=pass (imf25.hostedemail.com: domain of 3V6PyaAsKCLYWYganhaupjcckkcha.Ykihejqt-iigrWYg.knc@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3V6PyaAsKCLYWYganhaupjcckkcha.Ykihejqt-iigrWYg.knc@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760731992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a410UVUkGWxYqDToM9eO24m2S1wWqIP4ItBf1At6t3A=;
	b=EfnL3LaRr5dGVYYgGXIuT/idY+GEqPb0bFRVwoS+/9/e673y88T95P9XPRKgfTXg22dhzD
	PQRMLpQ11MQ52xLYvhtHg14jpqNwmZvL2SKg98skRXvUBi4MwZ49dtQgbUayrRuC1nW3Qf
	3DsaQ8OWNe9d3SOU+L6FYX72ubyYk8A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=J3MnXqvw;
	spf=pass (imf25.hostedemail.com: domain of 3V6PyaAsKCLYWYganhaupjcckkcha.Ykihejqt-iigrWYg.knc@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3V6PyaAsKCLYWYganhaupjcckkcha.Ykihejqt-iigrWYg.knc@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760731992; a=rsa-sha256;
	cv=none;
	b=WhyzU0II0wyeZBVvp78q83MNcmuCdUeF5BqRuLae4uJ7/gaF8IZjjtR0RYQRbw+/iOaiJg
	LX789jGl1cFjcKEEsXf8zP0iZ0v03baooIPmHnKmM3jKVQZux9qWdiGtgMcxezMYRW7T4T
	zMqJh95HAgxWqVH+TRQisA9xfA+qAdI=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-339b704e2e3so2392718a91.2
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760731992; x=1761336792; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a410UVUkGWxYqDToM9eO24m2S1wWqIP4ItBf1At6t3A=;
        b=J3MnXqvwJt76xc3p9EB/zLBJcN8a14/yonrnwqPPiV4kc7X8Rr5uwwlaAZ/PXa+jbY
         0IwrGxHBlczY5mspGaBz7EgsJ2dwrySn1nxzNFO7LEs5SJsoCkTND/F+zOKLK07S39Qs
         z3C+XRyBrkp3N3BPH9VQKh3i5BWM8tXrDHJ2MhWeRwwqitGi+UaxONDRfpDypErPUJna
         EcNCveRRgfIYELrQ9QvtwNjYsoCEvjA93sg/tyX6MvWQ8HvyvwnunA45t2oRXuC7gvGy
         gyK9SvemVG6qHR3th3xo9Rvw/ybppW8tQ3gA+sQjwht/UojKquZKyMo2SyFpJdoHZKXM
         ztbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760731992; x=1761336792;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a410UVUkGWxYqDToM9eO24m2S1wWqIP4ItBf1At6t3A=;
        b=RzpGpxntsh0DVKgT66wBMaM4yyu3QJfzQpeG7A+0vGh6e3Lu6onRqTD5rZJd+w0a2B
         Vr1dwxwir/fId4VWz6lY3sLwN+PmEX5i2KVhf46wtnsglBAZLBoDYfbKvNC1FAyqkPwc
         ODTMU/BHKAkb4YWLx5gkIFU9GRCSeBgDxRsROoCjpoFyGLPvPA1r07HmZrZMV3bNGDVS
         lL3jFlSzatsR2d+Rq7z3fshA7U4d8TcW2AAKimrL9vXfjYAWlHKVGoCBoIbphqA4ZJwT
         uI/kVjGgw5iSsTuO6IJoEw4DCpFOpF0SDzd4MM/QtuA2LExA9OPfVCb0+ULGVo64bNiQ
         sQgg==
X-Forwarded-Encrypted: i=1; AJvYcCVQTJB23xTT2UA79n+R6/HorQviI5ITWDJ5wF1cPN/nhMJgNltIkmE4xlSK1Fn0mfjMMMGFEeEI0g==@kvack.org
X-Gm-Message-State: AOJu0YxmqxpDEqB/dJjOpD1pNeezVkugxpAGSCs32QTeDqUqMVWzhyih
	kIwDDJncOqUDTtXO911uYFLYeurvVqHSgI9wO9YL/OaTGvKcwW7s/BTpuCx+28f3+V8cGECD4iP
	ufxPGPkquSLufmTLkmvDfdgCBrA==
X-Google-Smtp-Source: AGHT+IHRvzzwMR4y0ztHkD4pksfFtRgb0k5+ziur45rOES6dge9lLW63A0tWR3m6aINjc/jUiO+gZmGPknwu1Q9I7g==
X-Received: from pjpx13.prod.google.com ([2002:a17:90a:a38d:b0:33b:51fe:1a93])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1dc4:b0:33b:ade7:51d3 with SMTP id 98e67ed59e1d1-33bcf8f78c4mr6385553a91.20.1760731991624;
 Fri, 17 Oct 2025 13:13:11 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:12:07 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <bb336979b10ee5b9c6b3c3934ec3aff19330b3e7.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 26/37] KVM: selftests: guest_memfd: Test that
 shared/private status is consistent across processes
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
X-Stat-Signature: zfud7pyjjudxuuyku5eiowuxj6zozd94
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D2D86A000F
X-HE-Tag: 1760731992-745295
X-HE-Meta: U2FsdGVkX184nn4BQgR9Q3rE02jPgmu6bFmFrglR3ZKAQAmUn5ycEqTC1/ZgVM+1eAnuNEMrgfpPaTlIEkq0hDS9pdnbsXLWww7sS6rjA2N3H1GHnzJjf81PfOhTbATWw5aAR2UAXOMm+wKTSURVc+gCEIA7BGTdwD5vsyWRe6kCjPnhb0HVszuN8rrFVnPdE2adfG+OQmFjbq5B3WuEaloJbV+tQnpk0ghMYK8KHmE+8swKwawe3x8I0KoAF84dTTJwCuLaMZd5cViqqjjXPJdoYEa7EhFADihi8Pr8k9iosMT8G2lLCkyltZdxbKfV7W6zXpKcm8wxzQkmSU/0chV4w74laimeTEr9oDHdM+cdsWZtK/rSYqWRpBJ2ENQx3y1p/KcmgsrcheR/TlbwRKzOaNKSb5tbmGEz2S7bHRbPnryMlRmef48N7iNeStoRIFxPD4hMvyKo0HhhKMdP+oATTkAlnWSlBp12N9L6qHEi8CWVGqMDttreVjkTDxZO3EOQr3ax+lO47URvIPQuft7HVrf+ZxRFuWVErY9EtaQUMWAwrgg+dTDaq7H8XhMcAe9pKIsMHKVMw8yfEWirLF4i53/faJ1W2zkF/e7T3gN1x0E39pcVMnycecJWiodaopVyGqmVK5CcrR6NLlaWxSX2FU2cVsL3xOoEDRv6KxqhcfNuIirCnAfXWIkiWTesYZmOzb/1gLJ/O4Xe5CcbmRY+DTQ1Vs+HaG/fibh5xn2C/T2PJfJZ8YpzPcdWZvec3JB0JPLrtWFWjHPfknx39XvO5PEFLXE3YSqn0sSD4S4Pzi+vwyu/YBPieeSUiTyKGZFZnn4XQJXHA7/OfVZzmZlJB2GdqbMqynGrfvX3ArcGkk7f7iBiL6yTvR6L6qR2np6ZZnMos9e07+5+Aj7EDfzoeq7/485OD5rEPzEzUgR/tsMbjj8ea1Zop4fow0O5xdPnvJiWwWQ25yhvuEZ
 MXdtwBLw
 aQik77xpDkZHVEzpsNg8pYCJnKvxkto7NBXOkVEOSMKJ/a6EERq3dsIreURtcbLMkyErHi584dwb06MWfyy7EEA74E2fbQXI8hHG5MI32ChHgVqECY317rXmzY4Wv61xwrT1ggREClwQkbAY9BgTrxM6HVjBt9EgVNTrf9e56jrK8gUjv/In2EISo/4YXN9W5t8jBAcKvisyqje1ZvJpyTTO3MKuPAw83chCl7ML3QZmVDsTKscumyLl6MLv00lArGRqM3hT4dCgxg8BxuOqQd5YRQviKIDDa5b4nurn+Zb7PZ0YsqO2rzVBYJFWFqTAokpA1JuH+zSrqLEVo+InVK00h+TyeCz/lDioDD0JMPlek79ZfsRcXZtn6MQTSxCTIqY6ybYcU5grVn+RcYgQXl5uSfinKQW/0lvUfbP94oM4HatTc4Yy0NZVfcONmqIk3OnPcbxh4hUOrbhjXS+mpPyegnSJfEKF9AmBYiLrbHqxh30Q8gopvVob7JMT36EtsF9hUKpyttXEip8CEcPguRtXJ6fgwaJb0pS+hAEf0EoJekuB9SWywtz9IeElSoGb3G6BqiSwewTn9j1vHsevdi/X5vaN/9XiN5TwlhmaFN4OlkKpNzzTYmi9nVmih6+DszCeOGddNOB4nxw72fOkkoqvO4+Gnssmb+yEuSgvFqNZ+a8hnTCPZRFrQXhJtfFyPtORx9gNrqPZ/zWBMLeeOqW4fZgEeS4BvOZ5JjFfwQu6Cz4Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Add a test to verify that a guest_memfd's shared/private status is
consistent across processes.

The test forks a child process after creating the shared guest_memfd
region so that the second process exists alongside the main process for the
entire test.

The processes then take turns to access memory to check that the
shared/private status is consistent across processes.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../kvm/guest_memfd_conversions_test.c        | 74 +++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
index 907d415d72315..e6abf2d30c62d 100644
--- a/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_conversions_test.c
@@ -330,6 +330,80 @@ GMEM_CONVERSION_TEST_INIT_SHARED(truncate)
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
2.51.0.858.gf9c4a03a3a-goog


