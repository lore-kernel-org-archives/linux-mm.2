Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC49ECC6B3A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 09:38:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA4876B0092; Thu, 15 Oct 2026 05:38:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C54E96B0095; Thu, 15 Oct 2026 05:38:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B699C6B0096; Thu, 15 Oct 2026 05:38:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E91B6B0092
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 05:38:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA155804E6
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:38:27 +0000 (UTC)
X-FDA: 85324360254.15.A1D0F07
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id 400974000A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:38:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="gNq/q2IE";
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792057106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QvPtbhrFSm5FoNNWvwj4y3Q4nd03scqDRxnUx7itX/Q=;
	b=pRLqKagoiJ3mpmUvfjdUijU6ILbDp8DfoyR6ktoL3Ft5PPI667wN6ZJq0IhAyS2+ngWZNe
	LcR0u3gs0EsbNZb1sab2UTf/9A95xitoe21On07VC4MbOxKD4JqGCq/krmbTkh1GNdCkI8
	5B88zTgR5XSFpnvVQsMgn4KmF5jpnqI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="gNq/q2IE";
	spf=pass (imf07.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792057106;
	b=tBgIXuMwwVvRofXdBkAgtIIc32SmNqkrh+341NK1YeMYyncN4noUs7JvEWX1mp0MkBKfLN
	dn3a+Iju6t1tyoKFBZLUSRs0DQ7TT/N/De15fXMl1wgZxANyU7FzdAj8/V7OKHzwoH9WLe
	CEZlrRhYKBsEo9GVsH0baZeoxubcX5Y=
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-5e91e422859so2504362e0c.2
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792057105; x=1792661905; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=QvPtbhrFSm5FoNNWvwj4y3Q4nd03scqDRxnUx7itX/Q=;
        b=gNq/q2IEnEaSA9xmO9UVJc+FUjQEwhSVANpAd9ID2l2P/JCJFd1n8xJ95VTf10rNA8
         yPtQ7R5iLuLCLhIn/H1VR/nSm8Y4WREXteSfVEXcTCe2RmaNj4CeYzS7DwYhp/iTljmm
         jjydW4wGFz1XutIuZDL6VcHIkEhYUa11xV6X3cPpeTzS8MjyP0Cszxx9y4bElfxDxZQK
         Hk0m+exMlRJjMTF8FbGBlPIdXCQYyR6+2V55S0G1ouCHxWgE49DuqYQhCXQ5PRGnI3FV
         +8E23yYW5kZYK1tIibNKqhVVQANABSAB1T0TAhTODId2ePWYpMyHNqGdsLmpxtDBA82z
         UzuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792057105; x=1792661905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=QvPtbhrFSm5FoNNWvwj4y3Q4nd03scqDRxnUx7itX/Q=;
        b=psZfq8C82UFAaqqVHZOJ+RUxigrHrF2M/joIKENSK5uBuhwph3QzZgt+1MJRALYPxF
         yKN9KQfT/y8NeCXU16N7wCl/ZDj0UKAdH9vzP70Q9zUaFfUPtATAirp+IiNGzzdm2hZS
         B2QQzIb+8U6ZTbt6ReEQQf7B2ubAMt2t292eSDuxKGgkbUQT4Gky3Tly9MhT/u0BiBB2
         vofAfj8aNzTbG4tly/jAv8IkaW/m66fkALJV/USM1W5li7FUaC67DcVSGQ/5mnEeUHsw
         UmJksqmzqHYt+WaVycvKvR2VbVbTcekomXgqi+3TDZ0WJWWLMs7dqGWdPXYgGlo/1pP2
         g6uA==
X-Forwarded-Encrypted: i=1; AKwUvBzxvHv/IuJopr8HRAWCEq+wRjk89/mE1fMjyKF+GFdjI7857kF7xQ9VyjSTQRyUre5y5cOZfKqDCw==@kvack.org
X-Gm-Message-State: AFq9FYJrYuYonJY9QXwx9JUQ84xM0c9LVHgt+HoCYNlQW275HdfVtSU2
	rvQOyygnMAflT1oBkESfqGbqpUnwOPbdYR6FBlynFGDagVG8cIgP47JfGPArefDRuvhCXp0UbRn
	bjDTF
X-Gm-Gg: AYBFou1xRNNqOioQOx63fI3fxGFQ/LCpq7TbIkD/vt1I6c5DXYoLCqiFeyJx5Vqw9v8
	pamii/7eBwaW1oSa+zRWFwWEEYd9Og/apdExo4KqGO9SC5vNSglVm41Gs41GbFk+yMw6Av+HigQ
	ZOdncFzCRAOOMXZpMTnEaCiWdgjtV+KbU0sc2tqZpQTy0/XnU87+/6gD9jKleXhRrBE+Xk46m8c
	ygSY3LmDLLCdmEWL1y+KXZgdj1vUS8UjSlgI1byQC1gq4AQln2P7qpnhJ5NdGpe2w1TF4ZVh+f1
	cwO/cmv9axLRuCpYcrosSTMO/bAQ5pzyE2SRz459dJO65tq5txZxAxvBwfoQsoAJwHTAgZL4KiJ
	cJbuxeW5D9GREANKHHYOTaQW4XrfWLHX7hDm8c5oh75qBdZRrFgy8TpxDT2IjXXEl8dy+FfRNXP
	Ku1g4lnBJ0FITzPc15fQOj0za5FTwfutsd89FgtrWc6eRsSCqsZYxmux2ZUIRJX+LoPQcVCwnqL
	mUwxTV6epKoSJdAuY3y3/tWA4YD0bMM1CFVYcgOuGfFGzIWQClIvY6NfDJFrI0JfzxjedxLrPqg
	6JVJZGDcFZarHFVqwlFlw7Y1FxqJPXc=
X-Received: by 2002:a05:6102:c07:b0:7c3:873c:b3fa with SMTP id ada2fe7eead31-7cb36885ff2mr3914174137.4.1792057105254;
        Thu, 15 Oct 2026 02:38:25 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99003d37009sm12275672241.2.2026.10.15.02.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 02:38:24 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	vipinsh@google.com,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	graf@amazon.com
Subject: [PATCH v1 2/7] selftests: liveupdate: Add tests for LIVEUPDATE_SESSION_FREEZE
Date: Thu, 15 Oct 2026 05:38:11 -0400
Message-ID: <20261015093816.2438942-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261015093816.2438942-1-pasha.tatashin@soleen.com>
References: <20261015093816.2438942-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 400974000A
X-Stat-Signature: r41fuxjn7wbaic1dijk8yfzw8yyru4pp
X-HE-Tag: 1792057106-766427
X-HE-Meta: U2FsdGVkX1+ksG5YO6uek4SZ57vf+lT5dQlFSErpZgt9NNy7ky1edjW2K5cErOefHXzNsb2/vCIL83cCufevSOU8DxLW+GTdDH1/+uGxJV6Kg4vpfGDbwc1B+oonT/GOL4nhCtgCbx3Nv1hZyOw/Nag0Ocnyq6DdD/Amsk6GUcQ0zzaBeIK6rCWws0Joqp/Hs+N6fxZsdMRjhe5cIDfnXOdZ8rP/QHAzxlURHYvNPPXvgnjlSKrgIR7veIoEHe3bVwKeGicTHI+fN/UPqgBLZRDpgBib9RnOCcFaB+JQA9NKIU670ehkBk4vt5xl0SPzaPrbyKfGd9hIbznGOOuMnkro0Zs1e2JRQ9TQPS077XMQ8AbRx8Ut5huaLPZ8mFU48JMCvb9e5rKKHi7gW8n/iX40BihWMk6ZXMzC4otSlMhW//Y7M5UEhvGazmnIx7O5vNoxzxQS/gFNDMlpE635q6aTUS2PTNYPsXTI3/lD5FOLmfNVuVpfq2zF+449ZmuPZihDjftJbINv/igN/8WKRhrSAI3wbvt7MjXp/IIhS9ueX/8POu7MhNs8fTEyUd/2ZeRnkwFUy1ckpk+QKxo34BAftJ7eHtudBc4/hiEvGZKUguORn8x3lBxLmiISACEI7zrZiDUeOwJsHwS7QbE6fzsF095qDoloTwrkR4xc00v2nT8RcNTFEPrDOqChm3g5Ow1AZ0HrxCUr6dfQ0ahPxW6BLo9WtxO/aK8p8HVpLmHayfoh3oN7XGG1b8qRn3wcbRv4B2AdvFSZlyxVunrb+su0v1kANrYyYO2iL8ZEKaT0JvJMj4DNcH1ouEHUexOk6JzoAnj37gLtkgRFoRnA/yqM3m1zDNzQpJx9DV8EaiVBC2ndDjF5skLeYJpX5Oem7sMhS0YGyiDRi5FDZLpI8WNtmaZb1G4u0SKq8tXm3ApQ3cRKwyMz/r8xXgHTNalcXlH9Dr2H2FJgPHHv4eh
 UxbZIozK
 lbRKKQ0H4x7U7jmN+/mOXL1YE9sas7rNURhifvK7tzUkJZ+H1KLKrOkUbbQpQCuT6QTQfTIrnu+vrpy6O9JWbk6MOntUTWbCkQ3u8DN/0nufRevTQtBUTUClTip23PpvgV5t8WlQc+s1Apj5ibX7SXLdP2KLX1BLjsctbVobh2fhFuXTNNqFDtS1bU4PqlMWbCaLE2lpG6H4eK/cI2fx2IlzYo/jw5T4nzC6D6P3dnv5EmJd8e6Uab0doReXkIe4cfBsx3V6N/6VqbIjFI1lh0i911RO52adZJJHQ/cVzBsIkA8reRL9mY/1voaudUbCtcdwlLthdp2yziwM8Uv0oj9HROo/yUi8H7mBxAGT8ybK7VSVpswTXu2jNql8xaQTvzv/V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide luo_session_freeze() in the liveupdate test library and add unit
tests in liveupdate.c covering the LIVEUPDATE_SESSION_FREEZE ioctl. The
tests verify that an outgoing session with preserved files can be frozen
early, that freezing an already frozen session returns -EBUSY, and that
attempting to preserve an additional file descriptor into a frozen session
fails with -EBUSY.

Also freeze the test session early in luo_kexec_simple.c to exercise
LIVEUPDATE_SESSION_FREEZE across a kexec reboot.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 .../liveupdate/lib/include/libliveupdate.h    |  1 +
 .../selftests/liveupdate/lib/lu_utils.c       | 10 +++++
 .../testing/selftests/liveupdate/liveupdate.c | 40 +++++++++++++++++++
 .../selftests/liveupdate/luo_kexec_simple.c   |  5 +++
 4 files changed, 56 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
index fa07fed083646..15a7db3a6b3e8 100644
--- a/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
+++ b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
@@ -26,6 +26,7 @@ int luo_create_session(int luo_fd, const char *name);
 int luo_retrieve_session(int luo_fd, const char *name);
 int luo_session_finish(int session_fd);
 int luo_get_session_name(int session_fd, char *name, size_t name_len);
+int luo_session_freeze(int session_fd);
 
 int luo_ensure_nofile_limit(long min_limit);
 int luo_session_preserve_fd(int session_fd, int fd, __u64 token);
diff --git a/tools/testing/selftests/liveupdate/lib/lu_utils.c b/tools/testing/selftests/liveupdate/lib/lu_utils.c
index 74d41115c2815..6315746ff08f8 100644
--- a/tools/testing/selftests/liveupdate/lib/lu_utils.c
+++ b/tools/testing/selftests/liveupdate/lib/lu_utils.c
@@ -198,6 +198,16 @@ int luo_session_finish(int session_fd)
 	return 0;
 }
 
+int luo_session_freeze(int session_fd)
+{
+	struct liveupdate_session_freeze arg = { .size = sizeof(arg) };
+
+	if (ioctl(session_fd, LIVEUPDATE_SESSION_FREEZE, &arg) < 0)
+		return -errno;
+
+	return 0;
+}
+
 void create_state_file(int luo_fd, const char *session_name, int token,
 		       int next_stage)
 {
diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index 2dedd5fc2534f..9de068f31c3ec 100644
--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -530,4 +530,44 @@ TEST_F(liveupdate_device, preserve_many_files)
 	ASSERT_EQ(close(session_fd), 0);
 }
 
+/*
+ * Test Case: Session Freeze
+ *
+ * Verifies that an outgoing session can be frozen early via
+ * LIVEUPDATE_SESSION_FREEZE, that subsequent freeze attempts return -EBUSY,
+ * and that attempting to preserve an additional file descriptor into a frozen
+ * session fails with -EBUSY.
+ */
+TEST_F(liveupdate_device, session_freeze)
+{
+	int session_fd, mem_fd1, mem_fd2;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd = luo_create_session(self->fd1, "session-freeze-test");
+	ASSERT_GE(session_fd, 0);
+
+	mem_fd1 = memfd_create("freeze-memfd-1", 0);
+	ASSERT_GE(mem_fd1, 0);
+	ASSERT_EQ(luo_session_preserve_fd(session_fd, mem_fd1, 0x1111), 0);
+
+	/* Freeze the session early */
+	ASSERT_EQ(luo_session_freeze(session_fd), 0);
+
+	/* Subsequent freeze attempt on an already frozen session must fail with -EBUSY */
+	EXPECT_EQ(luo_session_freeze(session_fd), -EBUSY);
+
+	/* Preserving a file after freeze must fail with -EBUSY */
+	mem_fd2 = memfd_create("freeze-memfd-2", 0);
+	ASSERT_GE(mem_fd2, 0);
+	EXPECT_EQ(luo_session_preserve_fd(session_fd, mem_fd2, 0x2222), -EBUSY);
+
+	ASSERT_EQ(close(session_fd), 0);
+	ASSERT_EQ(close(mem_fd1), 0);
+	ASSERT_EQ(close(mem_fd2), 0);
+}
+
 TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/liveupdate/luo_kexec_simple.c b/tools/testing/selftests/liveupdate/luo_kexec_simple.c
index 786ac93b9ae38..ab108c7f1d855 100644
--- a/tools/testing/selftests/liveupdate/luo_kexec_simple.c
+++ b/tools/testing/selftests/liveupdate/luo_kexec_simple.c
@@ -40,6 +40,11 @@ static void run_stage_1(int luo_fd)
 			  TEST_MEMFD_TOKEN);
 	}
 
+	ksft_print_msg("[STAGE 1] Freezing session '%s' early...\n",
+		       TEST_SESSION_NAME);
+	if (luo_session_freeze(session_fd) < 0)
+		fail_exit("luo_session_freeze for '%s'", TEST_SESSION_NAME);
+
 	close(luo_fd);
 	daemonize_and_wait();
 }
-- 
2.56.0.385.gd3acb90ef8-goog


