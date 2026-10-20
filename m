Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA4E5606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 14:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=eaWm4ojL
Received: by kanga.kvack.org (Postfix)
	id 2EEA46B04E0; Tue, 20 Oct 2026 10:47:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29FAD6B04E2; Tue, 20 Oct 2026 10:47:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1413F6B04E3; Tue, 20 Oct 2026 10:47:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6D8E6B04E0
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:47:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 54CE0A74AB
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 14:47:30 +0000 (UTC)
X-FDA: 85343283060.15.24D82A0
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	by imf06.hostedemail.com (Postfix) with ESMTP id 82971180003
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 14:47:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eaWm4ojL;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792507648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8BnGO4/42KiDK1q900mgIYvccBVIMN3QrNthvM/m5KA=;
	b=IE/iQuYXZICLJIzKqSCdTtIaFmHP2/P3SAX5M4dURYPHqOSpalh14IU5wzpfG1kZQUa4m5
	1005v8WIXpz69bt/3NADjNzuiJhzS/Wzg0UDqZTUScF2mTcTvTC0pWMHHiYtUj73Mg5xQx
	+OB1yNn6/0w532eeCdjoipJeHhlXN7E=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eaWm4ojL;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792507648;
	b=hF7Bu7OguAuGv8zxZU8kBGO0m1cfsjggzk+8NAyx13lCC4qG+W2+ZlLtlfOL6tXaRH64P5
	eul3xpQduUVPVkotmbId7VDeP6YLAgZ1E2eW+Snt++5Ts5j4/gStXqDtt4S+Pp8sLG9JHH
	OVveVHUGvnXT0NjWPMKKERdrUUohm0M=
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-5e7834687easo726923e0c.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792507648; x=1793112448; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8BnGO4/42KiDK1q900mgIYvccBVIMN3QrNthvM/m5KA=;
        b=eaWm4ojLzC2mNldB4avGGYQj/VW2vDNdUycsVuTD6TIh4a8K9+q8dfhJkEd9QUc/GI
         ml46VCgkSLRr+6adxClvsNUVXZxKAmFOaG5fzYGtPxi0GrjX9IWQLu6t0WouiEbyG+yu
         WOgT4/Gy9ZC9lFXb1CquiK3+YDWN543DK0dQoCxlVY1sNPdyDLioU6I7ZrP90tKC57P9
         +J/6xVNteVDnuhvVNq+EIlLDISohp9TU3l8V0BAwuNEbcPuIQzeeUfxuzjkRWtOl/F3t
         eCGmtK7OMbFKOoePElrAsho0icvS9sXHvIqNCTFddcEtkB7VBdmN3yPEGmexXDzXQBcm
         Vi6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792507648; x=1793112448;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=8BnGO4/42KiDK1q900mgIYvccBVIMN3QrNthvM/m5KA=;
        b=03Uzc9roXmKBxULIRgMtnm1KokfD3cWPo+xxIiSiq3gFrtuRK2IeYPnK8wFkr73oZT
         vJvK2EMvQ307ZAlpflmH4doPES4+QOGMERICmJyavsZnK91R1Z75FW7WsaV9IyfR0/tv
         XqRCG9mtLDwp5/8cctkLoYXLtKs6q9ZA/W/gMnrgWvtvsNNv69CFta6LPkcqQ9yFwPFf
         BCfDzi/liPU5gKNHZwhAqLle6RvCJaimgMF9BnsTPvTL0bQ6FQeDyh3GGmSPDTLVYoYM
         y0LtVO9dfSytlv/1/kYnv76KaipXqmKQIHLl3j6sMJ6Z4NLGs0VC8+3CIeLNExe/cap2
         n6Mw==
X-Forwarded-Encrypted: i=1; AKwUvBxXgZQzIjGxrZTwl9U7S8P64LIXrGZSFXURNRdBDKzww4LTGzEyzG/NXe+SemxCiU/9iMOknaAPjg==@kvack.org
X-Gm-Message-State: AFq9FYJNu88Zr10RkMUjG6GvS16DgMHEogDH2bFcZY3RtRltJ/1UHc3m
	EARmt2L978im/dPNQLZ0vtUDZHbOnDp3oWsanZSOJ210oahCTRZMYpwgPdPxPUcIq/w=
X-Gm-Gg: AYBFou1bl+e+dk42JCZ4mzGRecOo1dL3DzvYjcmD3DWKkwHXySvs/yDomukE0NYVWAY
	4fmYcYOKnN8GjUklCQsyS7nDljBCpCyr4NoBBLlN1lngr9pSBPopppwaQPJgprABSngTl1yahUs
	zt+1ZGmeHQJw/imOtqGpumxlMScf97+XLSTQjFHyDd9jDNHMmqCnhHUG5TWZNKoGQGPyD6salNo
	3B3eeaEilrk2baOPVN24826/AyAOZ9qdpTFpyzxrwXUnfv3nSefV4aA9Z8fsFibdqYNbYzGSldi
	VvOlMs3uIFJ0WM9Hm/guScwDkNqMR5kSdrGKGF5EOlEjEameHvrm2BNch2E3d3xivFH2eTY9b3y
	/0B3azuVwgPk0ZtDnhXlGEDRViU80PMToAwV4t/DdoQ9e/uaQ0gCpmMyOLoluSRE70rF9owZKlV
	JLx/9ik/FjQ4m6QEFwpbwMquhMv6gADaw5AHV9l/4M9dyQlC9jATjdutGmTzy/3Rjvpp5y/IIIr
	ZhMybQluaxACeE8AKyjvfcWFR57i9lHfQaHkwCRAF1YY5b/tI0+WwI3FPaxjfdanq+bkku2/0eF
	Kp7TJzRnva7vd/WgjRk=
X-Received: by 2002:a05:6102:4487:b0:7cc:1045:610 with SMTP id ada2fe7eead31-7cc36ab3f59mr2581207137.27.1792507647537;
        Tue, 20 Oct 2026 07:47:27 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ea9b536ccdsm12920421e0c.13.2026.10.20.07.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 07:47:26 -0700 (PDT)
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
Subject: [PATCH v2 2/2] selftests: liveupdate: Add tests for LIVEUPDATE_SESSION_FREEZE
Date: Tue, 20 Oct 2026 10:47:04 -0400
Message-ID: <20261020144710.4154339-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
In-Reply-To: <20261020144710.4154339-1-pasha.tatashin@soleen.com>
References: <20261020144710.4154339-1-pasha.tatashin@soleen.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 82971180003
X-Stat-Signature: n6gbihb348isibri1c19ruwdp8foyia5
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792507648-624035
X-HE-Meta: U2FsdGVkX187dzkxcPjQdJ0mqYW5BHDaUeP56mC0C+/bni3nFL5hkKglbatbiMpSAQ1lrPNOmG9QPcDXWj6mLsveDmYT/UGNcnNjDD9hD14LE+MGslxRuQDteTr4lLb0yukzKfvgq7YqTF7qa8JOcZwvgfohO1/3pyggTx21rUObRQe5m6oeVS3VZCW6tI+dPUxhmzy7kkRNTo+o/e4+bffnA/TjL48zn4fL+ZXD2Zd0TIeZRFDhySuzAeMW5oN2bQszINy6oZk2IzfjTSdjr17UdJehnYfZjhZonC01HBYv3CfwbI/LTi1Fotws5wr1d5QEXsJ7V9wVIRQ9YtF5cOESM9bybnwqEnEDkcH6sHW99fC9HxdfBg48pgE+Yn3XVdtS22BeCadahBzkHeI9jZ3G1Nb6hFyfDyA3WQuX0Iiy3VrjYD2sRkVwxO7O0OsTidSXlCQ+L1sxrir/J6wvtuKF+NNL2+PT2Kn2VQF1U2up6G3dx2lhdxnqx9BqFMraTVqjjYtRbcIjHP0knw9OCt90AhWanp77Yrohx7DqNzJQGUIpahu1KGmC7CXJVpfA6JR9CsU9msAUUC3jfzgHLRMVcU+L5QKpcJojGWnYsnLuihJ1t44NYK3afgHnrCteo+Wjm5/IAFiwi5mot5khGgBtVX0PV7vSOe3eKsq5J0Owbp4DnRkqj7iycdnRJ/OedMA9/mHe74E6yKVQMcWcszGrNFhJdnv3mgs5a51oFUF3kEaeG16VvpORIHUHdTGG1BtaEDvyM7Qh45v/g4W62lFIlAgOvmpT02WGw7OWRYmKHEmqAhGFlzcAvpotPNT4j4TfOXRHxwIchZOltUMumwXE10ViZPskFEDdn+dHg0j0C1XXF83jgxkptiiEZiciPPko8I3DFXLrNrklxuAB8HcAEipVLiVGkCpXKSC3s7sl/04tIkH8JyB4u5kYlhhiFC/83V0YzLEpkFPf3ob
 kELHX66E
 yfVZL9tS6GEk64EeFc8otNH2tUcd4c6x4lrmbtA8RyY8W1LfLZn6cT8nVJg1vbtRGxXAE36/pex6i86ckHKuBYEdY+J3W64vNRAuUhKXfQxYQ47JWik/YmZO/tOr7U2jWlYgcDzI9+WY7iAr4eWEM2p+AIb9104A3o1ZBdoArVObJ3YerhVjywIRjg6sa+zoQ8vLX0wzdjfoFv+Q+h89QOfoGhvEbTMitUlBoMx2Jz4EWBj1PqCV1LQty2ED2w/MVczqeNh35yRNnRB8ZdsqHA6JU+TDgyboY9kjZdu71smqrtya2MF6VOHzwp+00FDqYvV2IkKFOMFrJ/VVg95b2AQTswrqs+uOU2ilTgVZMlEL3dA3qA6elrzunQFgJyJkkXN/p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Provide luo_session_freeze() in the liveupdate test library and add unit
tests in liveupdate.c covering the LIVEUPDATE_SESSION_FREEZE ioctl. The
tests verify that non-zero reserved bits are rejected with -EINVAL, an
outgoing session with preserved files can be frozen early, freezing an
already frozen session returns -EBUSY, and attempting to preserve an
additional file descriptor into a frozen session fails with -EBUSY.

Also freeze the test session early in luo_kexec_simple.c to exercise
LIVEUPDATE_SESSION_FREEZE across a kexec reboot, and verify that
attempting to freeze a retrieved incoming session returns -EINVAL.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 .../liveupdate/lib/include/libliveupdate.h    |  1 +
 .../selftests/liveupdate/lib/lu_utils.c       | 10 ++++
 .../testing/selftests/liveupdate/liveupdate.c | 49 +++++++++++++++++++
 .../selftests/liveupdate/luo_kexec_simple.c   |  8 +++
 4 files changed, 68 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
index fa07fed08364..15a7db3a6b3e 100644
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
index 74d41115c281..6315746ff08f 100644
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
index 2dedd5fc2534..74004e4276f5 100644
--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -530,4 +530,53 @@ TEST_F(liveupdate_device, preserve_many_files)
 	ASSERT_EQ(close(session_fd), 0);
 }
 
+/*
+ * Test Case: Session Freeze
+ *
+ * Verifies that an outgoing session can be frozen early via
+ * LIVEUPDATE_SESSION_FREEZE, rejects non-zero reserved bits with -EINVAL,
+ * that subsequent freeze attempts return -EBUSY, and that attempting to
+ * preserve an additional file descriptor into a frozen session fails with
+ * -EBUSY.
+ */
+TEST_F(liveupdate_device, session_freeze)
+{
+	struct liveupdate_session_freeze bad_arg = {
+		.size = sizeof(bad_arg),
+		.reserved = 1,
+	};
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
+	/* Non-zero reserved field must fail with -EINVAL */
+	EXPECT_EQ(ioctl(session_fd, LIVEUPDATE_SESSION_FREEZE, &bad_arg), -1);
+	EXPECT_EQ(errno, EINVAL);
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
index 786ac93b9ae3..9bc8dab2e074 100644
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
@@ -60,6 +65,9 @@ static void run_stage_2(int luo_fd, int state_session_fd)
 	if (session_fd < 0)
 		fail_exit("luo_retrieve_session for '%s'", TEST_SESSION_NAME);
 
+	if (luo_session_freeze(session_fd) != -EINVAL)
+		fail_exit("luo_session_freeze on incoming session did not return -EINVAL");
+
 	ksft_print_msg("[STAGE 2] Restoring and verifying memfd (token %#x)...\n",
 		       TEST_MEMFD_TOKEN);
 	mfd = restore_and_verify_memfd(session_fd, TEST_MEMFD_TOKEN,
-- 
2.56.0.212.g129ede20d9-goog


