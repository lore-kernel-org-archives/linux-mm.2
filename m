Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E41B10AB82A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:26:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 340586B00E2; Thu, 26 Mar 2026 18:25:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C9256B00E3; Thu, 26 Mar 2026 18:25:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11B7E6B00E4; Thu, 26 Mar 2026 18:25:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 009586B00E2
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CDA15160E2C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:49 +0000 (UTC)
X-FDA: 84589647618.13.F2F3D63
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf18.hostedemail.com (Postfix) with ESMTP id 007E41C000C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=p7sSs3Gz;
	spf=pass (imf18.hostedemail.com: domain of 3arLFaQsKCDsXZhboibvqkddlldib.Zljifkru-jjhsXZh.lod@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3arLFaQsKCDsXZhboibvqkddlldib.Zljifkru-jjhsXZh.lod@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=p7sSs3Gz;
	spf=pass (imf18.hostedemail.com: domain of 3arLFaQsKCDsXZhboibvqkddlldib.Zljifkru-jjhsXZh.lod@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3arLFaQsKCDsXZhboibvqkddlldib.Zljifkru-jjhsXZh.lod@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563948; a=rsa-sha256;
	cv=none;
	b=kFxieYHlexND+1cVIZcRbQ0+m51INWYZypKzLMU7jd1dy2kUKvXur7KLcoADf/Me8dcGYv
	RIq8971cg2jrSz+BfUve9RZH3/z112NK8PpWGRmTYSh0NcR0S3p54RXgbyo40W4yRev28M
	tIV+/dgpPXVsFavQGdUL6UjRhiqyoe8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uxISHYd3W3FTll0OYwaGPsDXdAUGKJkLGuwa2uoTRP0=;
	b=7VfgoLPEczSi0jiy1uCp4OHN3S4aFj8F/tojcSySIf2tCXtu9EwbZU6MaY9CUs4TuOagQW
	c8PWSicLBvyKihd+X7D/imt2MhZSF0IV374qTLirHBzdRYXX+Ks0wjpT5BflBRgcc9kI/Q
	DriorHI10ccdXTrXgA3UcFjHlk7jGx0=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35bea322389so1722998a91.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:25:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563947; x=1775168747; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uxISHYd3W3FTll0OYwaGPsDXdAUGKJkLGuwa2uoTRP0=;
        b=p7sSs3Gzg6Q+v0wEa2XokriIcf59hB5k3l/7pvL8Zx4FAXh3tgipm7p3IsisXwdrcg
         DdrZJvbdJzAiXGIYid5PL6YKuLGFMDMA9MNOMQvErohWrvVHrKnlSyq/Xx/LfpTU0UFJ
         56q+SbeS8BPLU3kckoXm2MSyDkkedk/F+qEtIrvl+5XB09BGtqjHcmqkX8S/sRkxFZw3
         A0KqTMzAlI0pWvwTBa6GlKugnsPvRBfdV+LqW86y6fVGUvB4HFBxZoQudL7HSRcFkmY9
         GJQzkEaG34qdbiAbVWbNdCU3Th2LcQOAF4DPrteE0VQpOUOkIU9NNRCETxTn2fgazAws
         M6IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563947; x=1775168747;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uxISHYd3W3FTll0OYwaGPsDXdAUGKJkLGuwa2uoTRP0=;
        b=p0g+UHqgFurTjaZ/BDsaw31BvqKRR3IY7Q/WawnZoJ1VHN6AU40htaijGyFGcRHfnI
         llao7qpbS4PfTh7PuPIlHn0/OnYppQrZ5uGPeCtL73ACqjtrNBubz3qyZLTZXkO5nUIF
         KXEwZXEEuzxKjAippMRJozzNNWM7++MA/AhEwmcth5VsPaHHEBJOodH0yxw5f87L/lzs
         7TSez23m5JVlqTYl756yMO0B+jKJjv3eE9GqxqV3MTO0E+i81U/AISqC6B0FWy2buiK9
         ea24F9cgY+20L5dNYMw/W4rthFTOqoHcHHbAElYBpvhfWygVGZriUPflf9sgTWmx2hwI
         xRGw==
X-Forwarded-Encrypted: i=1; AJvYcCWUZ23lMd6aDfzJQH8amUNSOpIUmlm994pMg2WbFXSUkHGUOJRZ8A3CiLux36LL1yO4sq6mJ/w5OQ==@kvack.org
X-Gm-Message-State: AOJu0YwOa1uTBcVi1e4wa6G9c2U/kAEYBNyw0MAhQVY3qK2YoU4elIde
	4i4/hwduHu7tohp60ZA8Ax335oCNMj51WjLmiLiZ8I4kkhrJ37T0u3O/XUSVXEECgQ5+kfx/FXV
	UTyDR0lEFl2XPgNjZe/49rFEjtQ==
X-Received: from pgbcr7.prod.google.com ([2002:a05:6a02:4107:b0:c74:42:899a])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4c:b0:359:8eaa:7f42 with SMTP id 98e67ed59e1d1-35c30056c25mr252326a91.18.1774563946580;
 Thu, 26 Mar 2026 15:25:46 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:49 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=5283;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=UdkBDo4oFBkXTHel5o8ZsFzPW+C1nVjCh4r6CInrjXo=; b=ekDVL11JYYjJUYvymKIHGTVycixyPeCaJxJvIY0KEoHTIw9VHcxDrJTqDhJsHWWpAaHT93McN
 K08mqT17n/eDM86iL0+q9pH2zxZ9JI8j/SugMW+LvhwJ33ZMYZTlGvK
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-40-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 40/44] KVM: selftests: Make TEST_EXPECT_SIGBUS thread-safe
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
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 007E41C000C
X-Stat-Signature: efqoz5igizg63y84nksgifdaz9cykszu
X-Rspam-User: 
X-HE-Tag: 1774563947-914569
X-HE-Meta: U2FsdGVkX1+wF4BvuL1mdqU+DsrIU9wFkeuiNaHLzQDMd05LiIqOURh/aCRnyS921Ejvmt3e1WHLo2ATZCCFWAJHCrktuwUBO0kA4KUdO25pj5F6PDmOr/vjPtpSu3BiP6spsqsZFoOcMTn9LKA5KGYx/1S5k2XQtNrjl4/MCQ7WnUpnkpyMWXhH6IHvyAf+5m+fgAjfhfhL0a1mI93ipXtr5pTMf2FIyWlOr6ECX0HCpL28oWveCCGCX5HRkrrEUyU7QjkhgVLILLzN+uUks3uBUy01LtaP/ipfSiBrABbssjOnk+FV9/41ZwceTbPk7C2jrq23kRGQN4F7yC3Ymi/MgxtbpTN0ASLVATiDwBQMYSmb3bnzYP6PV8Sb9TfvGYqxmdxHaFzNr96TwtcPSselV968adaLWM2uNYrjARHj7LlygdhqpDcFTEDKehNP2R4Y6m9E1q9FH5MD9A2LKRMrVwh/3Ais2COuYV7DkWnG59DTJqZJRABspTjmDNxG+LymvQLDo9BRgOnyKD2brFQVocmF6nIYwXPpMWrt+0J2iDBw6B2u3Ye1p9OlTB4iS4ZnxDthYTqZIQe7m8uvcfUcc41H+J7CTxW07D8poBLCP0+SI0g/awT8SKr5oS2F7hLfDi/UF3fzHb9pQNphw35HKvWQAmOrfIZv3ilnYvK4zCUHx7XIboDj++kNEeKrHCgQGSNX9p/Sqa4xLH37cVdY1bcsZrCQyNN767SxImzly4CuZb+K1orw0hIN4EFPg48IA50hrp0NE1/WPh9BOJD+k2HWTbgvu/C5oISSW+qO+0JDBdJRQeprrgh4Oeg7XoYakG8lq5zh5jQmdK1NJR+1pIcyRe8qb/d2lA9Ezw38YwKIl8p29jWx8qvb7JZXumR7Va98UxJBUebzZI+1FcZAgTtHDQ6E8OQ1XlnYpvVSk4sEc99x4D6ukDvqENII65b9QjN8VAZvicdsPrp
 RbBoxbJL
 5WnHEQH9AmbaIXZnkZohUGUh7awCHi4RVppzHeOmDZkOUPhYwcSfq5og4DEDKkGGfW0ngQGlIVLBHQ6mMQi3lfhGg0Z5dwqVr3UNbQnNwqBKsSauEHjhCMOtlk5UVFd58l1/j9WHK2HhpeHaK4aAw/nf+JnRwIg1aLoSwxgG3i0G0nbXixZbutCqhHpEgeogRUVqJSZOW6n7PnRZei9NK0Uv85xJE+mVPPVRPrJESbZVldg4xM9u9AZIad2hYIEJLYYn5fM666353qXgSeR2LYWANDOAm97zJiQg8ltTDTQBvTK6NOQ4++ZtWu3Pl8QRljQVCiFHAUp5wsXg6r9G+9kHJbnFfrPoiDYKf6phat/qT/mqMFlhaIXp4Mt23GmhBKLGoBjhCRsUT9q9mLy4sdAMBpZKLaeeCSZ5i7Jpqlp3RFc2W6xXZaPn8x0sHXsRU5jxNs8Ip5c4NnbkfgduhG4CNgplMw0y+Vb5Rh3XzJ8SUUPrffORV994PO2v30zEcLQi9pOjwD8T8UmKKsWDBQaCnNp/M6maGxrFDiSZhE5EMzRI/I5IcjfD9nv7Gg50KEoULxWLMQrQNCgiT4OGcUKDOUdSWSuY9RGl5lKUCa/EWH3o/ayRWvH83UGp31Pc/J6j+IwKfcczud+dSct0k1Y4TFCtbkrCq9IaeVROnnon1fsdbIzc3ka87+/7BYEpzZeemDmyFWlWrJogmxUBoPtPx4Q==
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

As part of TEST_EXPECT_SIGBUS(), assert the prerequisite for this setup,
that the current signal handler is the catchall_signal_handler.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/include/test_util.h | 32 +++++++++++++------------
 tools/testing/selftests/kvm/lib/kvm_util.c      | 18 ++++++++++----
 tools/testing/selftests/kvm/lib/test_util.c     |  7 ------
 3 files changed, 30 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index 2871a42928471..82f6b371fe767 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -80,21 +80,23 @@ do {									\
 	__builtin_unreachable(); \
 } while (0)
 
-extern sigjmp_buf expect_sigbus_jmpbuf;
-void expect_sigbus_handler(int signum);
-
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
+extern __thread sigjmp_buf expect_sigbus_jmpbuf;
+extern __thread volatile sig_atomic_t expecting_sigbus;
+extern void catchall_signal_handler(int signum);
+
+#define TEST_EXPECT_SIGBUS(action)					\
+do {									\
+	struct sigaction sa = {};					\
+									\
+	TEST_ASSERT_EQ(sigaction(SIGBUS, NULL, &sa), 0);		\
+	TEST_ASSERT_EQ(sa.sa_handler, &catchall_signal_handler);	\
+									\
+	expecting_sigbus = true;					\
+	if (sigsetjmp(expect_sigbus_jmpbuf, 1) == 0) {			\
+		action;							\
+		TEST_FAIL("'%s' should have triggered SIGBUS", #action);\
+	}								\
+	expecting_sigbus = false;					\
 } while (0)
 
 size_t parse_size(const char *size);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 6f7d3adb25d0a..eaa5a1afa1d9b 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2347,13 +2347,20 @@ __weak void kvm_selftest_arch_init(void)
 {
 }
 
-static void report_unexpected_signal(int signum)
+__thread sigjmp_buf expect_sigbus_jmpbuf;
+__thread volatile sig_atomic_t expecting_sigbus;
+
+void catchall_signal_handler(int signum)
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
@@ -2365,12 +2372,13 @@ static void report_unexpected_signal(int signum)
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
2.53.0.1018.g2bb0e51243-goog


