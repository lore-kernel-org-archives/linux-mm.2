Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C76DE606A329
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 05:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=Qrs6hYPz
Received: by kanga.kvack.org (Postfix)
	id 09B086B05CB; Thu,  5 Nov 2026 00:01:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04C7D6B05CC; Thu,  5 Nov 2026 00:01:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA3166B05CD; Thu,  5 Nov 2026 00:01:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C308D6B05CB
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 00:01:08 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE9C5C0211
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:01:07 +0000 (UTC)
X-FDA: 85399866174.04.575E016
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	by imf04.hostedemail.com (Postfix) with ESMTP id E571C4000A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:01:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Qrs6hYPz;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793854865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PsAwlx2j4fW8q8aMdYc1iycHvTmI4Op6n1GzgHBZx5g=;
	b=mJqUOSHTZA179KE186S6qxv1GMXGRENbqhKBNsVYo9OIJH/hLT8HHl9wXt0vvBkp7LcDxU
	C2Oo+GTIL3bCo7vvVCiKJqu9and4TU0n+HJ/0ig42p4/yLItVN6tluyDX9V6GJN5LQWbO9
	3R6l1qV5T3qqXXOL9HseiMJlGUSScRs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793854865;
	b=pmUuUvWFIQJaBzaU4qXOYGlk5yERUL9pwy7oPkK/brl5z8oulLERfYpdtO3eKGymWh3dEt
	QSYchniz+Y5FMEaA4CluqRjGjqencDPiMhEpaFE+9y5fx2dBPccvTgfYeyK2oTfAw7JWUz
	ow+A43e0dejdKoEwY0S6/VIX9AReCGo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Qrs6hYPz;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-7bec5112765so906169137.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 21:01:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793854865; x=1794459665; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=PsAwlx2j4fW8q8aMdYc1iycHvTmI4Op6n1GzgHBZx5g=;
        b=Qrs6hYPzHDw+IruSDM3BieNkdQuNjmNKItPIz3gMRFEmGVmYYI2Yfn8BnXjsrcQNds
         /o8JaQvaLoAuvjMCSslRREgTbBi/f6ALUNgU3qcGX8F5EyTww+Su6UBlSeyPkPg5ykRX
         jrT9dSuy+vkA2PvAFLRlBnawHFAPzzOga6340ChCvM44nSvNrEYcFB+sj6iF+tlzuePq
         XavQpgFUZD+dzKsaTE4rVUNcPKnBfCvkaR92VtLa4T283Xf65CAm+oVoH0jo0TIlht+e
         nJzSXn0KCRqv1RbQVES676faTNJus0M/4TG+3VfEOxGN936BBHAzGVJNwLnE9pJHrLFA
         1gWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793854865; x=1794459665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=PsAwlx2j4fW8q8aMdYc1iycHvTmI4Op6n1GzgHBZx5g=;
        b=oyArwfqOoNHBDkD7PIQlry5DpAaMdhwyWS2bS0aHtjL7o+HxJRsPlaeBoATZjdQtpN
         0YMKvEbPXVSoLN0PXq1dW88p/GuYoNC68BwdyMpM4YdkFeQlSmK6nACha0TG1JOwS2Eq
         1QHrwk43BwlV0GTf5UiaD9W1i1iw0lwn+7zFh4EXgpS7Uq7YnXYHbvPJo3dH95QwEFdj
         bDLTFxlIh93PAxwUrqtCQ972NZUfWGRQb3Xy22MiBNwgdUEbwRuEmZoBhEfF9SCcTw5M
         sRH52eGORiCw061XHwux4lYZU59o2cNj2YyCSLpC1RNg1+ACw6RuGCjujG+P/c/95gDO
         cv4w==
X-Forwarded-Encrypted: i=1; AKwUvBwe1gTWWWYC88dWjozbX8IThnU1gF3bjLXm6XrBuVpXdKipEOOShANLAQoZ7wFwfFD4gp6E0AyC0w==@kvack.org
X-Gm-Message-State: APuU4Z8L6zJqeACAT3UMJrCEWYmz5c5YqcoZBzFVMy4aLwcDFX7zFcuA
	uxFzPVkOSpMqspagIRvNRVK8Sc3r/+yUfhMbCtiu5ulwbj6TCpkawep9JU3478avMnE=
X-Gm-Gg: AYBFou2jnvSmD3tFDbns9AfsNH9u4WrJ47mNsWdNKtV7Jifed5buWnSecKBmee2LyCR
	f+GsH7WnNd7iIMarg2JNnNNRxJF9f3+2s3aNhvFShLPqPgramN16rcJqRWfAnjjiduNR/SstLLI
	ja0MjW4DG9+VPptsTCc3zMoEtQEia2GSvvus3HNxMs6yfnYa5pq1UkTvLsp7KuhJNRsrVm2S0uq
	f6G3pnKVviA7lRV/xcrmw9dY+6YOxDYKnaqszuQ/yMSkeXr/YJscrA0bUKwextiuiTCpOZmhe/Y
	urvEKk21m4yGvVNLQKfI1G8N3S7wTWmOM09ER48zuecGo1R7/l7jm8NFmLakSdBpgihpmcwuQFk
	PPjewTiSl/O9mnMk3Fh0RvAqzI0064VMILzQI6pfC50mzFky6xHYogBD23EgSQugQ1BhcFt9+D9
	WvKjI5NSsK5VGuMRNTs17/W2Y8LhOO8IRyg4EwmbYqATLQ6ZcwsUS/nfvs9AVkv1mEm7yLHb/ry
	BT0DLiJBn3vfEmutr2k/cfPuQLygoYeQUC2baGktlHHAciujPQbIkPzr+wm3iMsWGSrFXlcytlm
	5NPHxcZaDUcxU9LD/u6PHVAFkF8Xc7X6v9DODe0KAQLvkG3xuDvzVdJmngKT4sjpPakC7A+4gte
	kMChznpjn/1TZWyfevbAkszHmRZXBUGHnTpN4+FQCwSOCOgWNHA==
X-Received: by 2002:a05:6102:f0b:b0:7ab:af4a:f2f3 with SMTP id ada2fe7eead31-7d072cc2323mr8731716137.26.1793854865027;
        Wed, 04 Nov 2026 21:01:05 -0800 (PST)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eca8d9d62bsm3305282e0c.8.2026.11.04.21.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 21:01:04 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	vipinsh@google.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	graf@amazon.com
Subject: [PATCH v5 6/6] selftests: liveupdate: Add tests for LIVEUPDATE_SESSION_FREEZE
Date: Thu,  5 Nov 2026 00:00:52 -0500
Message-ID: <20261105050053.3063001-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.398.g882cbad275-goog
In-Reply-To: <20261105050053.3063001-1-pasha.tatashin@soleen.com>
References: <20261105050053.3063001-1-pasha.tatashin@soleen.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E571C4000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: szzprxqcs39cs138gfpeqgqxm3gkomsb
X-Rspam-User: 
X-HE-Tag: 1793854865-829628
X-HE-Meta: U2FsdGVkX18XpsKpxurHjf0o1ldhsgA3NsvOd5SWTMZVR9Yr+aPFMzdcpjZkqnf46a3jApSrNZ1wAZx424+DMuR95GWSTuVpbcUHRgvm7vShj3UFOZHPZOw8+07TcMXxeOu1srjcK0mJm6BJTYKpdviStxWz0ovrrdiUHqFbKojdE0oyIVFewXLFvYqsImVE8nwex6cuzZqh0CCjEF2sVMwXe0XosaxhZbZCc60B0nbrtBnjGBZeXVhWyNWyNc+20g2JzmL3pESlYqEJ6iL4JzpdvVTFZOY1UJ3imsbnW7FUrXEQeZBNeLF7W/Uz9/lobtjo5/Crgx950ZpFw7FM0ktPYBH9AqGjzAculV+wGh530zxU+VmyEqg2M9Sy3IwaDHEdUd4VofPrF4fbboWVAdKpXWr43uLhKTOEQ6zyEo/GT/Rz9QjaAU5M+Vkfs0GyDmez/dRyOrfxk1I8jiswGeQG31OoNpXN/hONnz93mvthVw/BMSobznbf+Ut//TsL82zlYCaMAcTI6Sln+TpJbSt7x/4K+1pnIn0we02w/ZTg7JjASZCQ4wWKuh+DGpV2VIO9JBZBEtAJOyT6KdFCa6hU996wzsn5JkfnIOQyFuh6kBHjzALPjU8MmDW+cyj0A+47b6wIBgAo3MOXX2ugLE/d6s620sbC30epICmQrEgojVsWURzoLuxQJjRLoo8GITBML4HrFe5kk1gVReGDAlkl0YZ4bnPLLaSQBSovzrTm6rswAKB0HE2F2OVT859+cbDfd4dKnxNzBkpd3jKgLxUPzW0YXihkwBqARTsSc4Rs+mVsnkPfp2czUSlNLqFjaPj2n03UkwT8pav44faQiGlj3o28QJIJ6t708rR9BM/Sv4ugpAqFMDhSckDqLyAJC0pdNgHLMkOMHBItaWHnMQREHwqBnEqvXedLGzyhsxSri5aHba5ADBQX6nLfTq/ttSvDQL3ViCKQKpWrzJp
 hPJedS+N
 sIvkWhJ8ef6TYeMLmbbeQQ/WsAnRwo+gCt1Onhz1T0zHXA9mCRdj2HTnXsHi13yPixUzr7NlMMcmUUDVki68rVubQQk0Nvx4Pe99wfVdaGccsgLpAbzsxAHK98Yj3TjKtkwGTj1JXsLPAtneo1FO6VK722Ao1vMNC5966se4Wwm6drberlCbIPLyxBQfsD3pygmx2j8X9hKEhPNBriknVDsbLipfdiGMw6LjKLM91+8PIsUWRw9EyZktqhslWXm24MIzt09Q5PA4nMMHRmfp8fRbvCgo7I3FdgWTwFXheMP+iUO6FAmZCOqvKAmTtCxWYJrrlzyUtndWViSDhmVl9mQNOqPmntkBRKO4hmqsNGTNMiZ6z1V6Z0SAKJc0Yjuf0nb7V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a luo_session_freeze(session_fd, flags) helper and selftests for the
LIVEUPDATE_SESSION_FREEZE ioctl:

- liveupdate.c: verify unsupported flags return -EOPNOTSUPP, repeated
  freeze and post-freeze preserve return -EBUSY, closing a frozen
  uncommitted session unfreezes and returns resources, and closing a
  committed session (LIVEUPDATE_SESSION_FREEZE_COMMIT) retains LUO
  ownership of the session and its preserved files.
- luo_kexec_simple.c: verify end-to-end kexec preservation of committed
  sessions after closing all session FDs and exiting without
  daemonize_and_wait(), and verify freezing an incoming session returns
  -EINVAL.
- luo_multi_session.c: verify auto-frozen, kept-open frozen, closed
  uncommitted frozen, and closed committed sessions together across a
  kexec reboot.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 .../liveupdate/lib/include/libliveupdate.h    |   5 +-
 .../selftests/liveupdate/lib/lu_utils.c       |  21 +++-
 .../testing/selftests/liveupdate/liveupdate.c | 107 ++++++++++++++++++
 .../selftests/liveupdate/luo_kexec_simple.c   |  22 +++-
 .../selftests/liveupdate/luo_multi_session.c  |  33 +++++-
 5 files changed, 179 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
index fa07fed08364..a35871cefb82 100644
--- a/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
+++ b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
@@ -26,6 +26,7 @@ int luo_create_session(int luo_fd, const char *name);
 int luo_retrieve_session(int luo_fd, const char *name);
 int luo_session_finish(int session_fd);
 int luo_get_session_name(int session_fd, char *name, size_t name_len);
+int luo_session_freeze(int session_fd, __u32 flags);
 
 int luo_ensure_nofile_limit(long min_limit);
 int luo_session_preserve_fd(int session_fd, int fd, __u64 token);
@@ -34,8 +35,8 @@ int luo_session_retrieve_fd(int session_fd, __u64 token);
 int create_and_preserve_memfd(int session_fd, int token, const char *data);
 int restore_and_verify_memfd(int session_fd, int token, const char *expected_data);
 
-void create_state_file(int luo_fd, const char *session_name, int token,
-		       int next_stage);
+int create_state_file(int luo_fd, const char *session_name, int token,
+		      int next_stage);
 void restore_and_read_stage(int state_session_fd, int token, int *stage);
 
 void daemonize_and_wait(void);
diff --git a/tools/testing/selftests/liveupdate/lib/lu_utils.c b/tools/testing/selftests/liveupdate/lib/lu_utils.c
index 74d41115c281..e71e7e90da27 100644
--- a/tools/testing/selftests/liveupdate/lib/lu_utils.c
+++ b/tools/testing/selftests/liveupdate/lib/lu_utils.c
@@ -198,8 +198,21 @@ int luo_session_finish(int session_fd)
 	return 0;
 }
 
-void create_state_file(int luo_fd, const char *session_name, int token,
-		       int next_stage)
+int luo_session_freeze(int session_fd, __u32 flags)
+{
+	struct liveupdate_session_freeze arg = {
+		.size = sizeof(arg),
+		.flags = flags,
+	};
+
+	if (ioctl(session_fd, LIVEUPDATE_SESSION_FREEZE, &arg) < 0)
+		return -errno;
+
+	return 0;
+}
+
+int create_state_file(int luo_fd, const char *session_name, int token,
+		      int next_stage)
 {
 	char buf[32];
 	int state_session_fd;
@@ -213,8 +226,10 @@ void create_state_file(int luo_fd, const char *session_name, int token,
 		fail_exit("create_and_preserve_memfd for state tracking");
 
 	/*
-	 * DO NOT close session FD, otherwise it is going to be unpreserved
+	 * DO NOT close session FD unless committed, otherwise it is going to
+	 * be unpreserved.
 	 */
+	return state_session_fd;
 }
 
 void restore_and_read_stage(int state_session_fd, int token, int *stage)
diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index 2dedd5fc2534..16b210da37a9 100644
--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -530,4 +530,111 @@ TEST_F(liveupdate_device, preserve_many_files)
 	ASSERT_EQ(close(session_fd), 0);
 }
 
+/*
+ * Test Case: Session Freeze
+ *
+ * Verifies LIVEUPDATE_SESSION_FREEZE with flags == 0: unsupported flags return
+ * -EOPNOTSUPP, repeated freeze and post-freeze preserve return -EBUSY, and
+ * closing the session FD unfreezes the session and returns all resources.
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
+	session_fd = luo_create_session(self->fd1, "session-freeze");
+	ASSERT_GE(session_fd, 0);
+
+	mem_fd1 = memfd_create("freeze-memfd-1", 0);
+	ASSERT_GE(mem_fd1, 0);
+	ASSERT_EQ(luo_session_preserve_fd(session_fd, mem_fd1, 0x1111), 0);
+
+	/* Unsupported flag bits must fail with -EOPNOTSUPP */
+	EXPECT_EQ(luo_session_freeze(session_fd, 1U << 1), -EOPNOTSUPP);
+
+	/* Freeze the session */
+	ASSERT_EQ(luo_session_freeze(session_fd, 0), 0);
+
+	/* Subsequent freeze attempts must fail with -EBUSY */
+	EXPECT_EQ(luo_session_freeze(session_fd, 0), -EBUSY);
+	EXPECT_EQ(luo_session_freeze(session_fd,
+				     LIVEUPDATE_SESSION_FREEZE_COMMIT),
+		  -EBUSY);
+
+	/* Preserving a file after freeze must fail with -EBUSY */
+	mem_fd2 = memfd_create("freeze-memfd-2", 0);
+	ASSERT_GE(mem_fd2, 0);
+	EXPECT_EQ(luo_session_preserve_fd(session_fd, mem_fd2, 0x2222), -EBUSY);
+
+	/* Closing the session FD must unfreeze and unpreserve resources */
+	ASSERT_EQ(close(session_fd), 0);
+
+	session_fd = luo_create_session(self->fd1, "session-freeze");
+	ASSERT_GE(session_fd, 0);
+	ASSERT_EQ(luo_session_preserve_fd(session_fd, mem_fd1, 0x1111), 0);
+
+	ASSERT_EQ(close(session_fd), 0);
+	ASSERT_EQ(close(mem_fd1), 0);
+	ASSERT_EQ(close(mem_fd2), 0);
+}
+
+/*
+ * Test Case: Session Freeze and Commit
+ *
+ * Verifies LIVEUPDATE_SESSION_FREEZE with LIVEUPDATE_SESSION_FREEZE_COMMIT:
+ * once committed, the frozen session is inserted into KHO and survives closing
+ * the session FD with ownership retained by LUO until reboot.
+ */
+TEST_F(liveupdate_device, session_freeze_commit)
+{
+	char name[LIVEUPDATE_SESSION_NAME_LENGTH];
+	int session_fd, session_fd2, mem_fd1, mem_fd2;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	snprintf(name, sizeof(name), "freeze-commit-%d", getpid());
+	session_fd = luo_create_session(self->fd1, name);
+	ASSERT_GE(session_fd, 0);
+
+	mem_fd1 = memfd_create("freeze-commit-memfd-1", 0);
+	ASSERT_GE(mem_fd1, 0);
+	ASSERT_EQ(luo_session_preserve_fd(session_fd, mem_fd1, 0x1111), 0);
+
+	/* Freeze and commit the session */
+	ASSERT_EQ(luo_session_freeze(session_fd,
+				     LIVEUPDATE_SESSION_FREEZE_COMMIT), 0);
+
+	/* Subsequent freeze attempts must fail with -EBUSY */
+	EXPECT_EQ(luo_session_freeze(session_fd, 0), -EBUSY);
+	EXPECT_EQ(luo_session_freeze(session_fd,
+				     LIVEUPDATE_SESSION_FREEZE_COMMIT),
+		  -EBUSY);
+
+	/* Preserving a file after freeze must fail with -EBUSY */
+	mem_fd2 = memfd_create("freeze-commit-memfd-2", 0);
+	ASSERT_GE(mem_fd2, 0);
+	EXPECT_EQ(luo_session_preserve_fd(session_fd, mem_fd2, 0x2222), -EBUSY);
+
+	/* Closing the session FD must retain LUO ownership of session & files */
+	ASSERT_EQ(close(session_fd), 0);
+
+	EXPECT_EQ(luo_create_session(self->fd1, name), -EEXIST);
+
+	session_fd2 = luo_create_session(self->fd1, "freeze-commit-check");
+	ASSERT_GE(session_fd2, 0);
+	EXPECT_EQ(luo_session_preserve_fd(session_fd2, mem_fd1, 0x3333),
+		  -EBUSY);
+
+	ASSERT_EQ(close(session_fd2), 0);
+	ASSERT_EQ(close(mem_fd1), 0);
+	ASSERT_EQ(close(mem_fd2), 0);
+}
+
 TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/liveupdate/luo_kexec_simple.c b/tools/testing/selftests/liveupdate/luo_kexec_simple.c
index 786ac93b9ae3..f065418a047f 100644
--- a/tools/testing/selftests/liveupdate/luo_kexec_simple.c
+++ b/tools/testing/selftests/liveupdate/luo_kexec_simple.c
@@ -21,12 +21,18 @@
 /* Stage 1: Executed before the kexec reboot. */
 static void run_stage_1(int luo_fd)
 {
-	int session_fd;
+	int session_fd, state_session_fd;
 
 	ksft_print_msg("[STAGE 1] Starting pre-kexec setup...\n");
 
 	ksft_print_msg("[STAGE 1] Creating state file for next stage (2)...\n");
-	create_state_file(luo_fd, STATE_SESSION_NAME, STATE_MEMFD_TOKEN, 2);
+	state_session_fd = create_state_file(luo_fd, STATE_SESSION_NAME,
+					     STATE_MEMFD_TOKEN, 2);
+	if (luo_session_freeze(state_session_fd,
+			       LIVEUPDATE_SESSION_FREEZE_COMMIT) < 0) {
+		fail_exit("luo_session_freeze for '%s'", STATE_SESSION_NAME);
+	}
+	close(state_session_fd);
 
 	ksft_print_msg("[STAGE 1] Creating session '%s' and preserving memfd...\n",
 		       TEST_SESSION_NAME);
@@ -40,8 +46,15 @@ static void run_stage_1(int luo_fd)
 			  TEST_MEMFD_TOKEN);
 	}
 
+	ksft_print_msg("[STAGE 1] Freezing and committing session '%s' and closing FD...\n",
+		       TEST_SESSION_NAME);
+	if (luo_session_freeze(session_fd,
+			       LIVEUPDATE_SESSION_FREEZE_COMMIT) < 0) {
+		fail_exit("luo_session_freeze for '%s'", TEST_SESSION_NAME);
+	}
+
+	close(session_fd);
 	close(luo_fd);
-	daemonize_and_wait();
 }
 
 /* Stage 2: Executed after the kexec reboot. */
@@ -60,6 +73,9 @@ static void run_stage_2(int luo_fd, int state_session_fd)
 	if (session_fd < 0)
 		fail_exit("luo_retrieve_session for '%s'", TEST_SESSION_NAME);
 
+	if (luo_session_freeze(session_fd, 0) != -EINVAL)
+		fail_exit("luo_session_freeze on incoming session did not return -EINVAL");
+
 	ksft_print_msg("[STAGE 2] Restoring and verifying memfd (token %#x)...\n",
 		       TEST_MEMFD_TOKEN);
 	mfd = restore_and_verify_memfd(session_fd, TEST_MEMFD_TOKEN,
diff --git a/tools/testing/selftests/liveupdate/luo_multi_session.c b/tools/testing/selftests/liveupdate/luo_multi_session.c
index aac24a5f5ce3..6b532ec6b82f 100644
--- a/tools/testing/selftests/liveupdate/luo_multi_session.c
+++ b/tools/testing/selftests/liveupdate/luo_multi_session.c
@@ -15,14 +15,17 @@
 #define SESSION_EMPTY_2 "multi-test-empty-2"
 #define SESSION_FILES_1 "multi-test-files-1"
 #define SESSION_FILES_2 "multi-test-files-2"
+#define SESSION_CLOSED "multi-test-closed"
 
 #define MFD1_TOKEN 0x1001
 #define MFD2_TOKEN 0x2002
 #define MFD3_TOKEN 0x3003
+#define MFD_CLOSED_TOKEN 0x4004
 
 #define MFD1_DATA "Data for session files 1"
 #define MFD2_DATA "First file for session files 2"
 #define MFD3_DATA "Second file for session files 2"
+#define MFD_CLOSED_DATA "Closed session data"
 
 #define STATE_SESSION_NAME "kexec_multi_state"
 #define STATE_MEMFD_TOKEN 998
@@ -30,7 +33,7 @@
 /* Stage 1: Executed before the kexec reboot. */
 static void run_stage_1(int luo_fd)
 {
-	int s_empty1_fd, s_empty2_fd, s_files1_fd, s_files2_fd;
+	int s_empty1_fd, s_empty2_fd, s_files1_fd, s_files2_fd, s_closed_fd;
 
 	ksft_print_msg("[STAGE 1] Starting pre-kexec setup for multi-session test...\n");
 
@@ -57,6 +60,8 @@ static void run_stage_1(int luo_fd)
 		fail_exit("create_and_preserve_memfd for token %#x",
 			  MFD1_TOKEN);
 	}
+	if (luo_session_freeze(s_files1_fd, 0) < 0)
+		fail_exit("luo_session_freeze for '%s'", SESSION_FILES_1);
 
 	ksft_print_msg("[STAGE 1] Creating session '%s' with two memfds...\n",
 		       SESSION_FILES_2);
@@ -72,6 +77,25 @@ static void run_stage_1(int luo_fd)
 		fail_exit("create_and_preserve_memfd for token %#x",
 			  MFD3_TOKEN);
 	}
+	if (luo_session_freeze(s_files2_fd,
+			       LIVEUPDATE_SESSION_FREEZE_COMMIT) < 0) {
+		fail_exit("luo_session_freeze for '%s'", SESSION_FILES_2);
+	}
+	close(s_files2_fd);
+
+	ksft_print_msg("[STAGE 1] Creating frozen uncommitted session '%s' and closing FD...\n",
+		       SESSION_CLOSED);
+	s_closed_fd = luo_create_session(luo_fd, SESSION_CLOSED);
+	if (s_closed_fd < 0)
+		fail_exit("luo_create_session for '%s'", SESSION_CLOSED);
+	if (create_and_preserve_memfd(s_closed_fd, MFD_CLOSED_TOKEN,
+				      MFD_CLOSED_DATA) < 0) {
+		fail_exit("create_and_preserve_memfd for token %#x",
+			  MFD_CLOSED_TOKEN);
+	}
+	if (luo_session_freeze(s_closed_fd, 0) < 0)
+		fail_exit("luo_session_freeze for '%s'", SESSION_CLOSED);
+	close(s_closed_fd);
 
 	close(luo_fd);
 	daemonize_and_wait();
@@ -91,6 +115,13 @@ static void run_stage_2(int luo_fd, int state_session_fd)
 			  stage);
 	}
 
+	ksft_print_msg("[STAGE 2] Verifying closed uncommitted session '%s' was not preserved...\n",
+		       SESSION_CLOSED);
+	if (luo_retrieve_session(luo_fd, SESSION_CLOSED) != -ENOENT) {
+		fail_exit("Expected -ENOENT for closed uncommitted session '%s'",
+			  SESSION_CLOSED);
+	}
+
 	ksft_print_msg("[STAGE 2] Retrieving all sessions...\n");
 	s_empty1_fd = luo_retrieve_session(luo_fd, SESSION_EMPTY_1);
 	if (s_empty1_fd < 0)
-- 
2.56.0.398.g882cbad275-goog


