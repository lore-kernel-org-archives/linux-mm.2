Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECC03CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 20:13:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E26968E009E; Fri, 17 Oct 2025 16:13:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAD2A8E0092; Fri, 17 Oct 2025 16:13:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDB718E009E; Fri, 17 Oct 2025 16:13:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4DEC8E0092
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 16:13:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 68A351602A2
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:27 +0000 (UTC)
X-FDA: 84008706054.16.D4EBA1E
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3E86F1C001E
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 20:13:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jJSz2xnW;
	spf=pass (imf18.hostedemail.com: domain of 3Y6PyaAsKCMIiksmztm61voowwotm.kwutqv25-uus3iks.wzo@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3Y6PyaAsKCMIiksmztm61voowwotm.kwutqv25-uus3iks.wzo@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760732005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sRpCljJtVrls/6hWQfsPORVstHyDe7m4NRLHPP8M32I=;
	b=WXAggu0NFV4sXkvMVUMpl2h4h76cIRrM03/XDx9JvatLqdEeuantMWouFd2P6DLJ7b3Ynv
	XENKcoMvlvrl4f3rL+Y4OrmsDeGjbsaaSvM0PXus2/f9d3XPDhsFPa+0NJ5Bfdj9eKMLn9
	MkYtooUOX3wgSrfXuidlfeMBi0xjbQA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jJSz2xnW;
	spf=pass (imf18.hostedemail.com: domain of 3Y6PyaAsKCMIiksmztm61voowwotm.kwutqv25-uus3iks.wzo@flex--ackerleytng.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3Y6PyaAsKCMIiksmztm61voowwotm.kwutqv25-uus3iks.wzo@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760732005; a=rsa-sha256;
	cv=none;
	b=vy4s3p9rLvI0qmT1W2gl8bv35OFAU8AQRaeyDmyk/ZWq+eojkj/0isoS+dCBqO1fdWUUMz
	5GtW+jThkfDVgDQLki0Sj9mW24i8bXpmcFyCGxvh+iEMmIv0jgIZFlMumUhiqCbvxkyzhv
	WGT5sgb5vM6lYgN40kQOLZ7//0J1QSY=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-33c6140336eso1582604a91.3
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760732004; x=1761336804; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sRpCljJtVrls/6hWQfsPORVstHyDe7m4NRLHPP8M32I=;
        b=jJSz2xnW39LX70gK/aebZEJTxNLKEXjHIFuZ9WhwYnPpltSrNSmhxF05Hj4/3MBm8P
         6o0PXwaUvUC5rdK9Rmq4WCvJ37AkaKDrfSkjxXAOX6YkVdwwdqo7OqM3VJ05/xfcMYzS
         NazefGUhpu1PrZytEnsqHQYIF9kxIcua5cclOL+waL6/Ip+1Es8VDXETMDLt4Flm0EOQ
         pgpeAfei5Kojm8JuErqDQx53KI/7KEh+g9oPjx6a0H1AZ7mz5FqI9CIag19sXyINGGgI
         QpA+gnoE68VDlwdj/UopHP8kmK+KZHV01UznQmEDc3DgcSzxK+60O2SBSNTgGi0MrGoA
         5Tqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760732004; x=1761336804;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sRpCljJtVrls/6hWQfsPORVstHyDe7m4NRLHPP8M32I=;
        b=IEYAb05RXBwA88Uu4Q2wzD3WhRxekod9PUpEAqNkceMZfYDi4+q5CxaAReQllbXchn
         gewRL7bDm2NqOsF5n81xvM68iTA5HbhP5J3CkhxZvQf/1pMQzPxOJkUicTcG2EXCmAjA
         r/RPo/3lU6p4X4yY5eKASit2beQ0RukokRsRyIIjjeKDCreFST5PoQtmSG7aHr3udb+t
         x/dp6xbbA64Ga8pIBgYx/gUQ3/zAqubuZQx6d7iE9KPcf34AVBj9mKKYzV/H3qIA8pos
         dvf6ESoEmtWa23TIZZ+/KC8li0T7/eymc8yftKyy2dv7dF+btk6cfk6gc3A4Al1uuGSG
         iyKA==
X-Forwarded-Encrypted: i=1; AJvYcCXHDzFQPcxG9QfTcz4aEizsbAeBqwFNJPx8ePoH9L5ZtBl4UAPFe5Ha3BDhF0pSyog7WzzMNQp6GA==@kvack.org
X-Gm-Message-State: AOJu0YwEZp+/xRcrXAHz2axlt/mKKIUccYlcSgXFC4dc31wOg+QDH00o
	U9rFKVBxCf9cDAuyh1uuyeQVgwDUnU45DYuNcEh5CyMrfUwzW4X+aftPESSo8LAs2IvxenRMnz9
	+iEsPgxmsTb7Yj8HiqN06XDdlXA==
X-Google-Smtp-Source: AGHT+IFGdBmr577G2D3wCPa71CmRW8ibsEq1jMkd//hmxTuN/1icQQzMZDjhyZdDN1r6wBAmdBu0Iyftggdo2S8VYQ==
X-Received: from pjsc19.prod.google.com ([2002:a17:90a:bf13:b0:33b:ab21:aff7])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2781:b0:335:2a21:69db with SMTP id 98e67ed59e1d1-33bcf88837fmr6418681a91.10.1760732003972;
 Fri, 17 Oct 2025 13:13:23 -0700 (PDT)
Date: Fri, 17 Oct 2025 13:12:14 -0700
In-Reply-To: <cover.1760731772.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1760731772.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <5f66d5b024efcc1028bc6ba4c15fc2eb73593d0e.1760731772.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 33/37] KVM: selftests: Make TEST_EXPECT_SIGBUS thread-safe
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
X-Rspamd-Queue-Id: 3E86F1C001E
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 6qya8sgpt9fysu3nbg86rxwoayfksejj
X-HE-Tag: 1760732005-173748
X-HE-Meta: U2FsdGVkX1/NDVtTIuBMG6t2Mp2XtlHDY4as8I+MQY1EQDhd3e2ZylDB3YCftEkyQap8nol+AtJLHlneSbSj/7oWvETi0nN36bBnrEtxHsV4NYfmpkzX+c8g37i7aF04EZBlBo6w5I0r/Brt73/kzfYmIgpwTZDViUkj5QCM80/B90fFMPQ9DnltrfUvh9fbRHXyMu/ZCakPUmpKJ1vrzASR0K1A5kPOWOyo7+TMueIzKsXSCQQ6Mwr+G+zfWvMa7VJwFBE8uNvgJghOgVvM2eJ9hl/wTbysEYQUWUhSpYB4R8TlNlibz7TQ/W7AOfpzkD2BfGk2eHlQ6IehsUusmSbSrnjpax3cYYy46DWQAClVaiufNVtr+2e3iD0zj4sj16HJPIRcucVKxJo2iqkM5uIQ0q8+ZeBtAxaizGjebRATKIJ88Y451sC0fdqxxDby15k5fD2YOT2+p8N0rIMtyI2+5q7cZorhMDFttNx56ITS8dPkz6lkpfl2GwMHYk3Q4Yqjc0EJrRJWhE3eljLFqLK2MOetu6EksbxWf23PIySEKGDDs73uEdS2GOVdBRoz1J9/uHJ7ozzxDwHAinfleXQ27UunImeWxGfFxEYe9xVSXZzdCzauQCBAn6Q1E1wMNi+YjpfsacXodbGNOHZmTIDt1S/pYsqn6wap0LjdRvIjhkk+XBK7JyWnx88DJAoAAjd9POnm/FQ1AJ9R9Hbd9LuwEaOxYoYyUXnCC8Cgm8XczVSzTyGiCG2/4he7k9aHciLMqmBQK2rl7dzxe3ehfcRHor5fr8HDBSjXLyEc02SuwFDhcICGQnFhLFl9zNKExco/sO9i+dHt4TGkcvnJebJuOXqsNfPdgkeMuuDeIr0t0Ont8H+2/8Tm6jEwJnHdLYNB+4odSbubFU1YpdmWarMdk/3wDLGsiqN3h0APZJAGFoE+OYRx/VpJVC674FjtWqyl6m6EE0W6Gp0R8JW
 KU2U1REv
 87GZAJ2c1pi1TPwQRXiuM41Aix8QUZ+tD/TJ16/GSImd7eHVMMByu5PC7JdDawTpjgTMGZ/lPCl8H4ZJVFEn3iic6yT/dUYf+z1sYxtW8wwO2Q43UM5ASYDZcJoXr7H15fsr4BWX1W7ehcCbKqQ+quVz7m9UiNqTnpb33sQN8vbpZvh9y+Jf+lUNrOQV2VhqLjI7UmQRoDJQUeHjX7suummwNPaekQazMZ4Gl4R6i+g9XZxJ8Rja7ok1AxspEDVU4xAMSyopufE7X5asSbowDr3fXIFkYKpZHw6cgK4X+MqNd7NB8F/VUb0eD0ihNyBmX4NT1tea/tqEAs7Im6l7r5XpCs4CgPWQ0ilyKlZKZjZQxml4jJjgea3dpoT+IG8E7d1BtJ3p1Y18TFwXvYMmrP1eUbFoLOgpQKx24UuzoOAvYFw/Z91VDjb4NTKPz9ep5ko3pfgCCKjAuk8z0TArmUia3BCSuZ8Z4lobKcp5a6f8XRClvEytxc53qDxsRVzZFhMTGcfScx5VH6eRl51wyB/earCJIJX1n+AFaG2IeyIqdz46ExO86Ir5CMJq+vRJVVs09m8yBTyMo3EhHulDixZUO137aQyvdIVMzCWQIqvkkV2X5CtShp4g3lD+ZdyFG4ZTwUHZMEt3lQ9t6XvECv232sKKM9xKJI6PId1HsQVflAGzB9kW+2AC/kNYxd0LeeUI+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The TEST_EXPECT_SIGBUS macro is not thread-safe as it uses a global
sigjmp_buf and installs a global SIGBUS signal handler. If multiple threads
execute the macro concurrently, they will race on installing the signal
handler and stomp on other threads' jump buffers, leading to incorrect test
behavior.

Make TEST_EXPECT_SIGBUS thread-safe with the following changes:

Share the KVM tests' global signal handler. sigaction() applies to all
threads; without sharing a global signal handler, one thread may have
removed the signal handler that another thread added, hence leading to
unexpected signals.

The alternative of layering signal handlers was considered, but calling
sigaction() within TEST_EXPECT_SIGBUS() necessarily creates a race. To
avoid adding new setup and teardown routines to do sigaction() and keep
usage of TEST_EXPECT_SIGBUS() simple, share the KVM tests' global signal
handler.

Opportunistically rename report_unexpected_signal to
catchall_signal_handler.

To continue to only expect SIGBUS within specific regions of code, use a
thread-specific variable, expecting_sigbus, to replace installing and
removing signal handlers.

Make the execution environment for the thread, sigjmp_buf, a
thread-specific variable.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../testing/selftests/kvm/include/test_util.h | 27 +++++++++----------
 tools/testing/selftests/kvm/lib/kvm_util.c    | 18 +++++++++----
 tools/testing/selftests/kvm/lib/test_util.c   |  7 -----
 3 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index 2871a42928471..0e4e6f7dab8fb 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -80,22 +80,19 @@ do {									\
 	__builtin_unreachable(); \
 } while (0)
 
-extern sigjmp_buf expect_sigbus_jmpbuf;
-void expect_sigbus_handler(int signum);
+extern __thread sigjmp_buf expect_sigbus_jmpbuf;
+extern __thread bool expecting_sigbus;
 
-#define TEST_EXPECT_SIGBUS(action)						\
-do {										\
-	struct sigaction sa_old, sa_new = {					\
-		.sa_handler = expect_sigbus_handler,				\
-	};									\
-										\
-	sigaction(SIGBUS, &sa_new, &sa_old);					\
-	if (sigsetjmp(expect_sigbus_jmpbuf, 1) == 0) {				\
-		action;								\
-		TEST_FAIL("'%s' should have triggered SIGBUS", #action);	\
-	}									\
-	sigaction(SIGBUS, &sa_old, NULL);					\
-} while (0)
+#define TEST_EXPECT_SIGBUS(action)                                     \
+	do {                                                           \
+		expecting_sigbus = true;			       \
+		if (sigsetjmp(expect_sigbus_jmpbuf, 1) == 0) {         \
+			action;                                        \
+			TEST_FAIL("'%s' should have triggered SIGBUS", \
+				  #action);                            \
+		}                                                      \
+		expecting_sigbus = false;			       \
+	} while (0)
 
 size_t parse_size(const char *size);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 8603bd5c705ed..41169e8cbf8af 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2302,13 +2302,20 @@ __weak void kvm_selftest_arch_init(void)
 {
 }
 
-static void report_unexpected_signal(int signum)
+__thread sigjmp_buf expect_sigbus_jmpbuf;
+__thread bool expecting_sigbus;
+
+static void catchall_signal_handler(int signum)
 {
+	switch (signum) {
+	case SIGBUS: {
+		if (expecting_sigbus)
+			siglongjmp(expect_sigbus_jmpbuf, 1);
+
+		TEST_FAIL("Unexpected SIGBUS (%d)\n", signum);
+	}
 #define KVM_CASE_SIGNUM(sig)					\
 	case sig: TEST_FAIL("Unexpected " #sig " (%d)\n", signum)
-
-	switch (signum) {
-	KVM_CASE_SIGNUM(SIGBUS);
 	KVM_CASE_SIGNUM(SIGSEGV);
 	KVM_CASE_SIGNUM(SIGILL);
 	KVM_CASE_SIGNUM(SIGFPE);
@@ -2320,12 +2327,13 @@ static void report_unexpected_signal(int signum)
 void __attribute((constructor)) kvm_selftest_init(void)
 {
 	struct sigaction sig_sa = {
-		.sa_handler = report_unexpected_signal,
+		.sa_handler = catchall_signal_handler,
 	};
 
 	/* Tell stdout not to buffer its content. */
 	setbuf(stdout, NULL);
 
+	expecting_sigbus = false;
 	sigaction(SIGBUS, &sig_sa, NULL);
 	sigaction(SIGSEGV, &sig_sa, NULL);
 	sigaction(SIGILL, &sig_sa, NULL);
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index 8a1848586a857..03eb99af9b8de 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -18,13 +18,6 @@
 
 #include "test_util.h"
 
-sigjmp_buf expect_sigbus_jmpbuf;
-
-void __attribute__((used)) expect_sigbus_handler(int signum)
-{
-	siglongjmp(expect_sigbus_jmpbuf, 1);
-}
-
 /*
  * Random number generator that is usable from guest code. This is the
  * Park-Miller LCG using standard constants.
-- 
2.51.0.858.gf9c4a03a3a-goog


