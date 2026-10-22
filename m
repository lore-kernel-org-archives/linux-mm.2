Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2534A606A323
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 01:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=CMvfbIg4
Received: by kanga.kvack.org (Postfix)
	id C75986B0830; Wed, 21 Oct 2026 21:58:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C277E6B0832; Wed, 21 Oct 2026 21:58:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B14356B0833; Wed, 21 Oct 2026 21:58:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8DE196B0830
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:58:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0FB448035C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:58:52 +0000 (UTC)
X-FDA: 85348603704.06.39EEF7B
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4C305140007
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:58:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CMvfbIg4;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792634330;
	b=sbGnvd/HWOIj8KVM/xMImFiqI2ERN6XUOuuIJlIBFaI5knOsaPJhXS+va6GqwKDbRuSs1D
	OZjXl+6pcbfIsP8r8OgVqfQw3QSXsydg0R6GWF2J8VFTziAQaZhFbO1kggrLX5iubP2qBK
	I8pVXsx4EgOqwF37imRavB7+cGT0/O4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CMvfbIg4;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792634330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J0kSQmA6WteBQ8jad2iaYF5h9jM/IeqgPz50Jq+mBV0=;
	b=YB2vVVrcmm+O9CrH9D24IgKjP5YTS7iEwCSNCHain3D/zQGUQWfFmPXsrmG6N2WZ3AfQUr
	lucPDirKxHaKlzbsgpN40HChq3IcJPJt2t/nulqfNt99A/dRErcifBtf5roGJY5dKcM4hX
	3Wj+30MiHs55sZsQlt0hO3jEOyTVxhs=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-93e635220b4so120363985a.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792634329; x=1793239129; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=J0kSQmA6WteBQ8jad2iaYF5h9jM/IeqgPz50Jq+mBV0=;
        b=CMvfbIg4p2Nl5XcQTB1DHjAYp6l7atBZIwNe+QgRQAfBZqu51pg5jP34xwlQ0NCB5A
         K+gHmfRx8qciGK4BtpEnBm6vJ11vON2ZVz2ppC72OYWdTJaIi4r0xDyC1tcQmbpW+0A9
         NOr75WUnfOYuIq8A/7SEZVZsclkFtQxpgMAYYcFKQuAno2obKCXCu/KFatlcL8wYYqne
         YVIyveYzKdQb2yKKuKTRMHAacydPx5KFe64qSBf9ur/AC+Bt12OCEL37Zg+3cL6mePBx
         xtuTxoCrh0WO7nKdo3mC+tHU2ZLikbRtwghXAlxIYeSjvJZ0mV9HEfPmYAlnupbMxN60
         AlEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792634329; x=1793239129;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=J0kSQmA6WteBQ8jad2iaYF5h9jM/IeqgPz50Jq+mBV0=;
        b=cemnVqSMkDgllHkO58v2EvuUPuZbciesVJWyg0gRkLU4Ch2fKFl1YvvMzTZRbVOgLR
         33J7ohk7IddGPaV5UCbka0JzYoSpIh1q7sTdMK64dAGrCtuPEsT+e0qNVsIeuEmJajiq
         t7b6/mfPnAacAPpXAjgQ1LaPMiUj866HBV0E+iUMpjkXlwG8VTPOmJHF0xLmKUkD1VZ2
         fIAmzmVZeylNuU9b7D4KqlX/l2WH3hDANcuCGgfW2jMXNljdcNvZTd/v8mUeljDTi5Nv
         TUQuzYTVXMhPU7UoCODZ6D5KufLEz1pyKijIXfIl6/ZKnFpawwC7k5aIip3LvY/v7A58
         Lpyw==
X-Forwarded-Encrypted: i=1; AKwUvBy3HJ5RuD9AkboN1bCpkpJolWRSytTwmZrW4q6qePwDJCP78br18JisjY8Oqre1XEW6wqgWgHbjLA==@kvack.org
X-Gm-Message-State: AFq9FYIXw+nY+0MykPUZ7eIm/py2w4hIAsb0IHrg8IuJoHsvEurPiMYP
	iR4fHmBvWsXPE6Y45zvVmezVoLKRdCuClqQ3TEP28votv8aVFBQfiLjozxJUCgPItoE=
X-Gm-Gg: AYBFou2jf1UwEnYmPqpn557HiLCfI1JDfVKTo9N5Gs6LUSeEBmb0Xtfb4xkEZKgX8Ep
	LVKiwqkpQS/8Z2yzJGlUsYP+o9HNmgcoTVYttMGrYNb/MbFvi29ghYQfTUsHHwyEHVkGaHgpSlK
	N7zMhEAWwRGCDG+PB4L3svWvT1nHTGE9sANqkY9EZajo8sxtz6Nr/xUdV6i4bVbUfA81Vq2HJN3
	+HvyWg8wodlJ1SHXgFQSgCD9iPdp6fWF0fGyaGyco6TBSFBmM9FVEYVFukPM2xLjGEo4I2iL8nU
	8nBOHVjbimraWHnxmsxtFhK897Eday0lyMFv2EbB9+vCUWm8JvAPepja1KA2gJs67sAVXunCKOp
	+QaWFU4Rqv6ihcHirGVcHoeodr6/W3irvtTm85v5/aIoETz7rISVxVP5resS7O02uJUlUTcsfAY
	YKmmsVtcBn7p9q7ZzmtFJtZwmz8h+u3htxBFV3PPu4+ZIRSfk3T1RyuOVEokPeLNipH45Zar5G2
	rY+ZrCc79Vdb2hINUSQBFdfMQbcFyjPBighXvDdtPoA1mPilk5A4a9gl1/hLcjopIeUAFAw3Fd1
	mSiMEV1bfEmPko3WGKvT4lRmKOrq1vh8t3Zb/jklpQO2E2qoIp3+x+BqTlnI8n7ZBXeAIyMI//J
	XUwFPCkyvMR6tR3lD3oQ9Nw==
X-Received: by 2002:a05:620a:2851:b0:93e:4d60:d389 with SMTP id af79cd13be357-93f57f1ecf1mr807656985a.25.1792634329416;
        Wed, 21 Oct 2026 18:58:49 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56e247ffsm397383285a.39.2026.10.21.18.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 18:58:48 -0700 (PDT)
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
Subject: [PATCH v3 2/2] selftests: liveupdate: Add tests for LIVEUPDATE_SESSION_FREEZE
Date: Wed, 21 Oct 2026 21:58:40 -0400
Message-ID: <20261022015844.2795816-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
In-Reply-To: <20261022015844.2795816-1-pasha.tatashin@soleen.com>
References: <20261022015844.2795816-1-pasha.tatashin@soleen.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sq3b9i3hhr95sd5ud5xrdj4w7psg7yg1
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4C305140007
X-Rspam-User: 
X-HE-Tag: 1792634330-723815
X-HE-Meta: U2FsdGVkX1+Bevvxt9Lyh9NR4XwJ1zdYiVD3l9ZI/77nzfHlEZfA/b0bNEkVAyRJw+6QdsfH16+7fqnGgv5KTGYEuwAHdT8cCk6LKhJKHbDqEES99IcbjahBW5MmsC9LCkrS0k2Q1ELNOOh9ub6LjEzzAvQk6GwV2I9k+brQ1A9DHtGRt/J3s4kn2OFq+OTeZHxcZWpU1t0+icwBPzyp/bDevbZWW92remxdCi1eQNdo7zy8X8bQ+BIb5hiQZfVsrvm8JYjNnLp8GIW6SolJllAjhn07LpUIwtDq2v98GsNqblMJh+Q4menPaXcCyEnapqmxgXiPjIbIQZm0sDOp6fVpcfc0Na8Oj6CotJBuQJDsnxSsMucZJl4sk2dTifkGDGv20WZD8Wo6luEZq7968jASShV7mqWpUf0I38+BA/b2HQfUSjW/qfFv3SbmqNNslfVSuEZ1ZG5qYR5AkiwaInZPcx+PSxC58+TjzZy6WVbFwBgUHvyJCxo8MSrLkWsVNnsW7Rw+L7CpmIHAXZhB+3vRrsRzdtG8HEKn8tOTZ0KlH5BEmMfb24OD/H/EEmu2dFnexRltKp7dgq/LiI0nBe1vZYVNgfs5jI2zRmWpBXPdYmo0RbDNCuMmYSqf1YPVUnHNNybRbboWPuF1aQ+w/FjOppRI7tWwSkCvH1vBJ0SlAEJuBsq99XWTvlKsXGceXxjcMEq0fDtH9XOj2//2HrVMHbQppQKsJhdGJYgtGFaQnS8OqdnuJBaE9kEpChgdJmmZAqq41O83qCc0q9EnoEuYzPIYu8Hp/xTO8CRicMQyX4eFOzpSn7mkD27s0sHY1FNcW0bMlILLzRjHIynV/PUpCif2GtqRFyvdjBlw8kYrnq9tXWf8JxzZwMob0Ds0plqbMYnXy2OdGEidY/xOLDW828K9wP9ZGt59pORGhyWGPFp8njLnG3CXvBfQdvQ62PhJxOlr2tP4i1DSqgO
 j23l07pP
 bY0lN5/uOFnqdwyVmU48iDn2KAQgmGAWB//o/SuOX5AMyboazDNxxKXbE2pgiy1BCGkFeAq66DOrgTmp3fB9QrZtOwz4GYa/lAoI+GT9+tBTgELVFhVxO+O60IeDThx+5xW/coObFYEVZYdHTXXi1G16scN1DdP6ANOtii4U+UWKvdzH6kPmDcCovzDhlRm2qFPqDmFBmUyuti/T4jAILJDDTTfhvFbrfn3/lLvpP6toH1ic47XdhonsI4NirXC7EbqQ8zkucPybkC57U3z5sk3NCVRR/4YcAR+aZCP+BHz3ZsKxRSx5IG69KHFswJ5IUskJGXgK02rvW6urP0MDZg0o5j8QxKVWSeR8TmPQiOSZx8Ax5qL2mhucF+fv5jvm5dFpXAx2iMYj9SIeytHjkbxZwwA==
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

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
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
2.56.0.218.g1ec904b173-goog


