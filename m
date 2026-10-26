Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 045FF606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 01:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=boOFbgHZ
Received: by kanga.kvack.org (Postfix)
	id 9C0146B05B2; Sun, 25 Oct 2026 21:49:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 970F96B05B3; Sun, 25 Oct 2026 21:49:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85FDE6B05B5; Sun, 25 Oct 2026 21:49:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 612F76B05B2
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 21:49:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C6FA280628
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 01:49:56 +0000 (UTC)
X-FDA: 85363096392.10.923E2ED
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	by imf12.hostedemail.com (Postfix) with ESMTP id 19F6440004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 01:49:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=boOFbgHZ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792979395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=paepyu+lNzKcCGz2xys5Lce7GHF0FgZ1jCDDvPB5GKY=;
	b=wLn9nqOFpff//mbrUfcdpaS/jOI1XWVmfpTroVm4agKs8+eOgx3Vd0zK6FvPNwd3FP6JDq
	fC/gXeJAu/JCW1v4tDPXIBFtbhgouetly0e4wAizv7fSpnl+IhHEqRhY9J+8wzjbG2gdQd
	IJr10sgUHf4BLJxtLP96fNKZNJZ7Ivc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=boOFbgHZ;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792979395;
	b=xuEXHSmDrEJeY03dZ7njQ7BnQCZIvBv+mKbJE3OUNmME1GvXkuxRlkWbGseXvx3nHRKiwr
	jBRza+KjYR7WeXZVbQWCM+POSTyA28jzfXdBe81952/XzrMdn40bw+bPfQkiSYg6Ducvaz
	ypNr/FlK9bFUm6iuKIjmiN0CQ3Xm5M8=
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-7c33cc572e6so2233466137.1
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 18:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792979394; x=1793584194; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=paepyu+lNzKcCGz2xys5Lce7GHF0FgZ1jCDDvPB5GKY=;
        b=boOFbgHZc69ndU6/DF8lL4DlCqAtv1zjr3GkQWkcCsfQaZCd2a66dYfM8TfhBY0WSa
         19CHFuUS9M8fSP+Khbn3jFtZ7yhWuNDJAOkNLs0hnkMS0lR353zP13ds9enB4xBw+Gnt
         X6f8bDLh6uWKGjDNnoi13rb8s3dZtRXsTRuLM12w7TcaZXtPKaq070y6Ib60rVhDCjII
         HXHGIS/vKnbsViGdWhrJLAiHxQb5w8rfkpWeXrmfpfd/wRVOlGH1PRTOhWbMh6kCoP7o
         eRyanj8byRlgybiHVe2WPKVpkf+Ll/l54NNSQGEe8oCfnN7uozMllsA0quQvA5mD2xZh
         06Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792979394; x=1793584194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=paepyu+lNzKcCGz2xys5Lce7GHF0FgZ1jCDDvPB5GKY=;
        b=FvEu0QWNizsplp42b0r8mVJCgjMbQj5HHZ9Bpbd1yvyYXgKgcoui/eJSCtZ2dSGBOL
         LbifEv1w1956hXMyxU6M8eMQoiTOEpP5bAPBcE1jbyV3i2BI1iMrb93gCLmA6faQkLrR
         ZCH5jwXk3d4k2b2qyb7WMHMk/Y1dsiuf1jmyAziom0AwymD09oxIQ/hLjDj58AzV9QkG
         367YsPEWjo+RBpPOZhox7ZOg+O8BpLTD8+tr/YjPF8r/9OkGTsaoPyEQ96LAo4gr6hUL
         fK5nbCdN8sWFyBp8lgte/G8qK4OUSGI75OHpHPXhUnYc2JT+pYAumB9NhidBXVIhxFz+
         SKvA==
X-Forwarded-Encrypted: i=1; AKwUvBx9+gJoHrNeWu30ZLfjGXK9t+p8UyHTCgsvlzR/J5H0t0azch3AMyXUb89SEysfxksNVj2jlf92Lg==@kvack.org
X-Gm-Message-State: AFq9FYLrMQnwooZtYbldHA4OXIkzgq4aQWPr5qldbp5d189ZPoF17+2y
	yz7OFu6OzyOOzvnqggYxKsX6FyPsOvSKv5/10HRU3n9TqGIGGTYSXr+Gv/i+eEpPv8Q=
X-Gm-Gg: AYBFou1d0HbmMK4BHRluPh7owaNcRWc1rvCxxCWD2jx6He2sDCtTn7rcrt7EQAMwQV7
	l3JyTdfSHpNrGsHSudOpVf4JMwH7rGCei7QCg8lxkOXjGGAgj+qbEX5y69TMNWd2gM2DjYNxJK6
	96aCgFCb4RTSUf2Ay8a0ZnlwKQlag6ehMHT+q9wUW58TFzYrytxOOTYlx75WiBsUyE4vyiSF8Co
	/OycAsZiqk1xAxWlCMV7ksslxeWTLBzCWvf1WcAn1171pIGxWD9OMnPfIvIm49/v1yNHMAB52Ma
	A+PgKdeUiSrId4+M/4zC5IyYueLOCdE/84jR/ob3Yk0UodlSlSmfqtAO/2JS7cY0M3r2W7VfQfo
	UU6a7XPAEzo5Zg4MnACnSTsNkoxu7ifldKGn36wEMlYzgszdMpcC27LWcOsnmxU80G67vJccD0z
	471zdNVKRUW/xN2a0G7D7YibxaL0E+vwdRG/oTdu1ZbBke5kxVyujXRTjWa2+TxI1UKAyaLFRk5
	6QVOfdmSaCVWqPIwsCH6/2BH1UA8wwk0Dj3zvxdmqt0/x+fV5h+0Rs99H4MHks0F1TmJBDMBrBk
	PdNJaFy4BMFT331BY0/Ya3VnznKHPqnal0me2/238vxf8ocpfOyZglVw+1k4/FRDlEApmZU1G1d
	hIg==
X-Received: by 2002:a05:6102:290c:b0:7a5:673f:9a37 with SMTP id ada2fe7eead31-7ce5d3e4c67mr1068887137.15.1792979394230;
        Sun, 25 Oct 2026 18:49:54 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7ce5df73970sm6099917137.1.2026.10.25.18.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 18:49:53 -0700 (PDT)
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
Subject: [PATCH v4 3/3] selftests: liveupdate: Add tests for LIVEUPDATE_SESSION_FREEZE
Date: Sun, 25 Oct 2026 21:49:46 -0400
Message-ID: <20261026014948.162559-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
In-Reply-To: <20261026014948.162559-1-pasha.tatashin@soleen.com>
References: <20261026014948.162559-1-pasha.tatashin@soleen.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 19F6440004
X-Stat-Signature: qtuwb9wtyn3wdznaxe5pi9gdkspz3cnp
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792979394-368098
X-HE-Meta: U2FsdGVkX19pgnlgBJfrYojlbBAOXg6r8z2+UWlo+7nJwFY6NxqeO9i0CvevmUuOBQ9XN+iuVPiijfB4EfoSc9kJcA+2ct7VQ0KICgPhDuXdulVXSYcFfgAbnWrKDv0TKqIdJKzB/byv2Wc7F/Z1j7fDsukInQ12R+JL3LlHEXKGNKug7UyRPpJA+FcJOJu8U3TsMP614V7KN4ArVWj6U+i+gU3ov4EyWBESYZFHGr9QPt4ltepzdhvSLBEv/erKqC5em4y7Y2TBnlMgPWkjc1nFzK4dO6BD3FfcqESf/S/p2BtxonJ0NyfL2nEJSsg2EiO7Ggi0ss5c5uRdm+oWfiIcVWvf30QvGEKsmcUibfPJsYT/qYf2WQLf5+bA1RJbH52VJrOtUuJ58L9sFs2u6mou5lCS4DOJlpaTBKKt7AoGOpuvlyi7rWWHzT68TnHgWowesZPTTUoyNooq07b1d34KorAdmyDLTasdfYY5Qoa0ID+nAAN+13EmjunxPlu8pVywRbtMOGGTm8HfwjPAi3c29ButGe6v/PYgbyi2xfkLWoJzLvyD/N4BLm91QDySu7G5Tc3S2Y56BF2AfhFg029Lk0dvpB74+Z3P4oQfeUcGR8IcRILft0qys+UWNOk03xQxYPY1fMT5hdYNBCkS3++tvcQqJBw3eLLT7FLhcq9bncjibIzHC4aDIkaYCJJqDXcVNJc09A3aP9yVeBFgW4KfOR9BfwK5AxpRoZnkRgOIw+fBLZUd0V4vupmvCWGErfXwz1SJdMXVQCwfk22PaBJCzng9fKi+z5r0VHdMNNkmSpsGGt2OBe3kbx9dawc1vecdFPF/2ubWLfpxLqO4XgTipVs0y9D4AWizASg0GfYwrqAIE7mji5dbMQEWf+yj9E1ZV8d4G4A2rHcN8bwhpkU6Dh+rvRbVMSSctMOIiaSX/gtzcTXY8dYbpD2N9g8GOXoBcNHFMxAZzowzp+Z
 Y27v6IQR
 lh2LOGnts1LFcYeG1EgYO0PllB6aTBrP4lhyqHoELg9rR1lWELLPcqI9H7ERU86Y078jD2gSBGKd2flDUi0S8TZIxAtBm2w2akqbfBpiI5pfFrwDv5ClVMqad2ywZfiHZH4N4/L88k74XLC/y/a8BNWtNLqsNIlg8j011ZSJ/fOPwdL6JBzqEIgHiSNYaDVRf2+vuXlxn/M6fxVoTurB9pT27VeBpwzMhPjsBvPmvTfM1PaStp1gxUnpBLAJ06XY02HUm2W3MYE1ej9MNMymPPWEK3YmlDSY+QfwCsxohdcI9ptbvQbXda176vQhX/6l+d904r0hhJeCXZOLltNMVZNZLkqi+zvwIWrFhQdzv1fFmEvyG+XNSEi8jyPmu7RwmLsdyY6u6NHoJAR5gXRptLC11hQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a luo_session_freeze() helper and selftests for the
LIVEUPDATE_SESSION_FREEZE ioctl, including freezing a session before a
kexec reboot in luo_kexec_simple.c.

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 .../liveupdate/lib/include/libliveupdate.h    |  1 +
 .../selftests/liveupdate/lib/lu_utils.c       | 10 +++++
 .../testing/selftests/liveupdate/liveupdate.c | 45 +++++++++++++++++++
 .../selftests/liveupdate/luo_kexec_simple.c   |  8 ++++
 4 files changed, 64 insertions(+)

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
index 2dedd5fc2534..c27f57eab870 100644
--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -530,4 +530,49 @@ TEST_F(liveupdate_device, preserve_many_files)
 	ASSERT_EQ(close(session_fd), 0);
 }
 
+/*
+ * Test Case: Session Freeze
+ *
+ * Verifies the LIVEUPDATE_SESSION_FREEZE ioctl on an outgoing session.
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
2.56.0.307.g5fe7bd680c-goog


