Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2615ACC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 09:38:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5510B6B0098; Thu, 15 Oct 2026 05:38:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 502AA6B009B; Thu, 15 Oct 2026 05:38:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C6566B0098; Thu, 15 Oct 2026 05:38:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F1F156B0098
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 05:38:35 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7099F160829
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:38:35 +0000 (UTC)
X-FDA: 85324360590.22.549C072
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9FBE81C0004
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 09:38:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gsvbZhvf;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792057113;
	b=N7WNL3HHp0/drWR0yuUKA5vTTeGHdwS2LSAj3T8nQ+XL+nW8zXtP/FMghZOzB0JwCblWfZ
	ZBZVJrbBgIkNft91yCZeDKwyxqimk/D/aw782qxJbgXkeRV68WhrwW91LxLp+CY95Zuguw
	uiVW/kqEpBTiBB0dauWhfHv102ecvco=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gsvbZhvf;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792057113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZWkatgtkqZBCSGS/DoNd/wVrCRwtNmgFeYJzwykKUrU=;
	b=NVxXRzWwvgoOhIf49jOycerhdceOUf4IANohdeAV9lEGSaCe5JZVBvCcN9f72C1DyLg8S4
	kyIbVEyoRoa4uYQWQwueXN8tMG38sqK/yETf5evXt90umBehMU9qXhn+kYfKWy+JD3yDxX
	BdIm49li0jvf0U0BvaNITqCK38LWldI=
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-98ff53fb739so692145241.3
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792057113; x=1792661913; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ZWkatgtkqZBCSGS/DoNd/wVrCRwtNmgFeYJzwykKUrU=;
        b=gsvbZhvfxtlWulU/JHpy/JS4SAJ9H+eSt6hP1/+LAMyQP2xpAWrUt4QpqO2SvhJ7C2
         6+C22Dw3aGJJgx03Plc/AdCGWdPKO/+DW8HcCL0oufGedPM0F+qzjl8G/Gr3Wf/imkn9
         PexNcGSYZLnGVOGS3zJ9udTE8XPXuiD24U4cdCeOWapwFWTDmulLFUU0AfmFJ5kpV6oP
         VskmlSPT7mnXx7yslDOb3BtnoQRmAkBd/L4FQ+nw0XF7vOl2AuKuba+rgfKhuPGc7HGc
         5kCAJDcPj/j1EtJclND/YPdKV74+rvgqt25D82PPjxvZS+wGKY7W+RTIZv6VGnT2mYeK
         rJsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792057113; x=1792661913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ZWkatgtkqZBCSGS/DoNd/wVrCRwtNmgFeYJzwykKUrU=;
        b=ZofVTGZJGZXIT0t9CU8OaFSdh0w9bu4/1bqaj7IkROe7gz0aEzRu+UgT7/TfwcQTk9
         gWI1ijl32K/DxOpReSEUuVirh2O7Qf8XGOCFLNBdfQ04DWU31309zMc6vrnFKoVk2qo9
         BrTNkj3x8Fbm5QILIQ2fEWQC3V+2q//B+tXOnmpUAiA4rLmgJ8/yxkBAgSc3INaRZgzG
         g/OUx89skkxZKG1BZV+90UX2WtL1F7SHjHpojDD3pRKD0h7AbrHVP6mSHpnZqrrmc/iM
         kLI9OadVtkWZNBTHcchN4BTm7KvsQmnz27z+mrYcAXCRC0M4a91ZN60HiMfXvQbe5qGx
         rzxg==
X-Forwarded-Encrypted: i=1; AKwUvBwt9nx3LcG6DvsYj/I7YEA9MayIpVMJuT3iSs9n2pj3Dj/gO9c9xeCrTUTGwBpWE35Qgk3jJXEwAQ==@kvack.org
X-Gm-Message-State: AFq9FYKAOezxION/49Fl74wBUfzU94lLbHUYBroYdTraW9DpkGVLpjK9
	N4hagkUhJWj7ixNlJ3n9RS5GcEN2uk2HmqR4iII3+4BAeGgYYHjSegaSTztR621FAo0=
X-Gm-Gg: AYBFou2ywjAwdBmfM9w3whdG8ZWONFEkKKgoeO9HUXPdVij+VSI07b44yo+WCitXSsP
	hIZwtwAsQeQLTAAdQRN6jQwToWTm/C1hBF40oXshGQs2E1RVYOgBvKPqjcGJ2RrDwFHOc0Uc/Sc
	NkaL2WXlVfET9T6jAxStI3v/MG/1Lk59EFN+zhAzrAPY4Dbq9CEm53OGBZY8rP4dmIgPZvX0elI
	uPU0UTiFM1t45AyXmuVUSdKkQ/YRBifbuvf1zQHiW0Szw65eiv2b9fLzBGHK8TSax7rhGkWDwP0
	xGZlsn3ueyJj9zO6q097wp/bDIjrpDPjA5YfOuNtCt3yc3YUoE8EH0fRvCc1WVWOOMXvqP7YCr6
	4dqSnvXmhjnccpjd2FsroEu9/VfVpT/RfLDFpeeGNhfmdqjrzPuE30qCycZqd/UqOv0NMNJN9CL
	P34IkHNw8TAEoufEOZvOriTDqantvq3deA1NOoGtoUUYiHCxeGqwTq/h27T7A4MfL7Hyz5U3nZa
	LUAb+EwWgeGfH9U4GPnXcXzMaewYRMIbrolumlSCpzzIc8psaela+CJc18KfK0OgUZhtYOYLRKH
	GyXu6Rvqsilp+z4Ktg8=
X-Received: by 2002:a05:6102:2c85:b0:7cb:288a:b678 with SMTP id ada2fe7eead31-7cb372a8aa2mr5907427137.19.1792057112741;
        Thu, 15 Oct 2026 02:38:32 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99003d37009sm12275672241.2.2026.10.15.02.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 02:38:31 -0700 (PDT)
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
Subject: [PATCH v1 4/7] selftests: liveupdate: Add tests for preserve and retrieve user argument
Date: Thu, 15 Oct 2026 05:38:13 -0400
Message-ID: <20261015093816.2438942-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261015093816.2438942-1-pasha.tatashin@soleen.com>
References: <20261015093816.2438942-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1zgk7kodhm7oymkarkugzc4fryycncoe
X-Rspamd-Queue-Id: 9FBE81C0004
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792057113-910381
X-HE-Meta: U2FsdGVkX18aUEQjRnaY4BfRm0tOWr1KSZzHGX07yWIna597a7UtlDb5tTkEXMTxKGOjIWQZHsRw5CD4UmGoEqIIWPBjFWngpt5hC4xgt7Oq5p2jjWnCRwe8pOEsm+QHjDTLZ5QxUKEUlaPtVrSK1/RJ5XCCOOzNCSVW/9mJp8Qowo6R7fyVCFyT8TVaKV3IuNBU+5fxXr0wIJ8IqI3QQ4iqMpJRM44rKel/+aq/1kZy6v2TvkHJEtj8gZ5qfETWnueivGCvooDsYpyvsNHtuIRa1scAn30uz6LuD0qi7M7ows3Hc8MPVDybBF63ml0TZrOysHA8wx2I1BaIK62sVnoy1/SmGnW0JX60hONfXna4rpYW989FL/Llm5Tz7fttS5vzZ8aeH2uXPDr7yDY5ktl9OrXNaGsjFzPVS0+789yoWMKq9g1vwhrqfZskZiMWjzz8xOVsaBeY/kpx8Cm2u45NrqkisCtOuFWtXqXNY5mMee49Ju7wwTa1RH77rnEAzlOJFnKJS5Mg6OnmVpOoVZMlwnXy0c2TmZVVjtDIl5daGYMmA4Yn7LpNMiOcnBIsg2wdEndfKHbyeyl+QkogIniorL/H4lkMHJ5nDoy7C3UzXiS+cGLkEy/SLrr7TNVVcRETLg7aerqZDVEQJB7X0z9tFwd5x0WLmYV8lyeXzXEgxqOM1M9f2HlFfLwZGD8bVraelVn71Qn2yCVTx3jpM2DOrr2+VqAz1YD9NOZN06kbSGrC7jPdRXm0Izk570Muz9PZSEFIb7lik+uRkVGJ/046PSTEKA0eyeOsZUpd9EU90q5pgyYMWfrZ9AiRGYtOen7Lwo5ChqlrU3e9xsrhPOl5gTTnPsrQ8HifhdsAjb1QxFg8ez0l5FNV8x+wwqRWxJKo2lXcupiERhhORG4ANpKlJzqVidJidsVvMAXIAWriPOZJNff6YxzGyDRe7yEXlmugZ0C6Z8PhTwbWOow
 /ycKJp9Y
 BGSMnnt0uNGtQmgoA0KoHEKnnkY+7nHxBuY1XN0dS0N6EGDewlLd5DSUvN1dn1s2X7cn7ukR+CHiFTyoZ1sN1nA86gR9gdFXQ8mOtFow11Rhk2XFC+aAT//j9ORVJiDso8+04Lj5MS17smTRBoENMl8ptLbjegsa7y2fFX8bBjNJCY/sBnJcBcYJhtpmyBp7hhG8+QrK44oAMFN7BeSTW5s+8tIyW3c5/pEIyjWBi/r3OenA5Tyay7fQFOyzHJ/b7G21w7UtOewrDRuCam8hgJjAucyPfJeUTRA9CTqvzw/7AZ/B812O2dqbjMAVLTHkooqx1gLbLQoZidiU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Verify the user argument support in LIVEUPDATE_SESSION_PRESERVE_FD and
LIVEUPDATE_SESSION_RETRIEVE_FD. Add luo_session_preserve_fd_arg() and
luo_session_retrieve_fd_arg() helpers to libliveupdate so tests can pass
a handler-specific argument.

Add a preserve_memfd_with_arg test case to verify that memfd
preservation rejects a non-zero argument with -EOPNOTSUPP, accepts an
explicit zero argument, and remains compatible with callers passing the
legacy struct size up to the token field.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 .../liveupdate/lib/include/libliveupdate.h    |  3 ++
 .../selftests/liveupdate/lib/lu_utils.c       | 17 ++++++-
 .../testing/selftests/liveupdate/liveupdate.c | 44 +++++++++++++++++++
 3 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
index 15a7db3a6b3e8..8a38268e89dee 100644
--- a/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
+++ b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
@@ -30,7 +30,10 @@ int luo_session_freeze(int session_fd);
 
 int luo_ensure_nofile_limit(long min_limit);
 int luo_session_preserve_fd(int session_fd, int fd, __u64 token);
+int luo_session_preserve_fd_arg(int session_fd, int fd, __u64 token,
+				__u64 user_arg);
 int luo_session_retrieve_fd(int session_fd, __u64 token);
+int luo_session_retrieve_fd_arg(int session_fd, __u64 token, __u64 user_arg);
 
 int create_and_preserve_memfd(int session_fd, int token, const char *data);
 int restore_and_verify_memfd(int session_fd, int token, const char *expected_data);
diff --git a/tools/testing/selftests/liveupdate/lib/lu_utils.c b/tools/testing/selftests/liveupdate/lib/lu_utils.c
index 6315746ff08f8..5c6f8bf80b297 100644
--- a/tools/testing/selftests/liveupdate/lib/lu_utils.c
+++ b/tools/testing/selftests/liveupdate/lib/lu_utils.c
@@ -79,12 +79,14 @@ int luo_retrieve_session(int luo_fd, const char *name)
 	return arg.fd;
 }
 
-int luo_session_preserve_fd(int session_fd, int fd, __u64 token)
+int luo_session_preserve_fd_arg(int session_fd, int fd, __u64 token,
+				__u64 user_arg)
 {
 	struct liveupdate_session_preserve_fd arg = {
 		.size = sizeof(arg),
 		.fd = fd,
 		.token = token,
+		.arg = user_arg,
 	};
 
 	if (ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, &arg))
@@ -93,11 +95,17 @@ int luo_session_preserve_fd(int session_fd, int fd, __u64 token)
 	return 0;
 }
 
-int luo_session_retrieve_fd(int session_fd, __u64 token)
+int luo_session_preserve_fd(int session_fd, int fd, __u64 token)
+{
+	return luo_session_preserve_fd_arg(session_fd, fd, token, 0);
+}
+
+int luo_session_retrieve_fd_arg(int session_fd, __u64 token, __u64 user_arg)
 {
 	struct liveupdate_session_retrieve_fd arg = {
 		.size = sizeof(arg),
 		.token = token,
+		.arg = user_arg,
 	};
 
 	if (ioctl(session_fd, LIVEUPDATE_SESSION_RETRIEVE_FD, &arg))
@@ -106,6 +114,11 @@ int luo_session_retrieve_fd(int session_fd, __u64 token)
 	return arg.fd;
 }
 
+int luo_session_retrieve_fd(int session_fd, __u64 token)
+{
+	return luo_session_retrieve_fd_arg(session_fd, token, 0);
+}
+
 /* Helper function to get a session name via ioctl. */
 int luo_get_session_name(int session_fd, char *name, size_t name_len)
 {
diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index 9de068f31c3ec..83e0978f3818d 100644
--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -20,6 +20,7 @@
 
 #include <errno.h>
 #include <fcntl.h>
+#include <stddef.h>
 #include <string.h>
 #include <sys/ioctl.h>
 #include <unistd.h>
@@ -570,4 +571,47 @@ TEST_F(liveupdate_device, session_freeze)
 	ASSERT_EQ(close(mem_fd2), 0);
 }
 
+/*
+ * Test Case: Preserve MemFD with User Argument
+ *
+ * Verifies that passing a non-zero user argument to memfd preservation fails
+ * with -EOPNOTSUPP, while passing a zero argument or using the minimum struct
+ * size without the arg field succeeds.
+ */
+TEST_F(liveupdate_device, preserve_memfd_with_arg)
+{
+	struct liveupdate_session_preserve_fd min_arg = {};
+	int session_fd, mem_fd1, mem_fd2;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd = luo_create_session(self->fd1, "preserve-arg-test");
+	ASSERT_GE(session_fd, 0);
+
+	mem_fd1 = memfd_create("arg-memfd-1", 0);
+	ASSERT_GE(mem_fd1, 0);
+
+	/* Non-zero arg is not supported by memfd handler */
+	EXPECT_EQ(luo_session_preserve_fd_arg(session_fd, mem_fd1, 0x1111, 1),
+		  -EOPNOTSUPP);
+
+	/* Legacy struct size (up to token) should zero-fill arg and succeed */
+	min_arg.size = offsetof(struct liveupdate_session_preserve_fd, arg);
+	min_arg.fd = mem_fd1;
+	min_arg.token = 0x1111;
+	ASSERT_EQ(ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, &min_arg), 0);
+
+	/* Explicit zero arg with full struct size should also succeed */
+	mem_fd2 = memfd_create("arg-memfd-2", 0);
+	ASSERT_GE(mem_fd2, 0);
+	ASSERT_EQ(luo_session_preserve_fd_arg(session_fd, mem_fd2, 0x2222, 0), 0);
+
+	ASSERT_EQ(close(session_fd), 0);
+	ASSERT_EQ(close(mem_fd1), 0);
+	ASSERT_EQ(close(mem_fd2), 0);
+}
+
 TEST_HARNESS_MAIN
-- 
2.56.0.385.gd3acb90ef8-goog


