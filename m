Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E030B606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 18:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KzAjMyKS
Received: by kanga.kvack.org (Postfix)
	id B067B6B00EF; Mon,  2 Nov 2026 13:51:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB8FA6B05B1; Mon,  2 Nov 2026 13:51:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AC196B05B2; Mon,  2 Nov 2026 13:51:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E12006B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:51:56 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9C6B0C01CD
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 18:51:55 +0000 (UTC)
X-FDA: 85391073390.04.60924D0
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf01.hostedemail.com (Postfix) with ESMTP id BDDE94000D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 18:51:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=KzAjMyKS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of ampr.mhd@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=ampr.mhd@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793645513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jUhK5m1lvTjtdfmztu+bilD4B6b4ERUK5SOg2m81DN4=;
	b=bk9LHHL7rXA0Wqn2hYS6bHt7cS+yargSjxSS+QDztuK/abxiK18qE0w9gRyqBridJ2Q7iK
	Z6n6qo44X4Xn0EhemC9QT8RRW9suNkpQuUCZrbxKsa32dmDN8B4s+e7jBX6fn3sKECYoSg
	peOwA7PXkE87iGr+SjSJdgvjWM7DNQI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=KzAjMyKS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of ampr.mhd@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=ampr.mhd@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793645513;
	b=z/vSRXMSeXmlhZVhr4aC8EnWuwp0Ev8uogpGLoeeSwVuoMK3NmbcvKYoIzp5KsDdRgdSia
	vOyCOJS47JXgl4WUzKd/bwCCN/RRsU4RQa30PeUvzDCL4ytedE9t3wg60iivGzCq5l3Lrj
	74YtcUVymyWRNVgeLrBrMEnhL5BYXEA=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48df4e9d2d4so1789141f8f.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 10:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793645512; x=1794250312; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jUhK5m1lvTjtdfmztu+bilD4B6b4ERUK5SOg2m81DN4=;
        b=KzAjMyKSy4LedzB3w48ogctz1+bDlOwpSv9f4FhFa+77oexDm2WYQcEN+zqQ3jDJKd
         vMnUBo1JOEzqIFOhSMaFj5p5Izeo79hen1gOFaJoPc3ayD25HQwizxTuWjOdjD5Ma2lF
         Rq06IF1mOeZsJBqaaw5f75IBNUCg4ViHu/8BvgIPqyoC+3BuTdwThKUIBMyUVov8avIN
         FqQ7/k7j9FpWu2AgArZwNX/5OV0ZwYg839kOntHHj22AYqTuAVR39RP2NdqqfO09dKRY
         LyVXgai+WWH/wCJTe1VJX97O2rnMLqgSNEAgEOYNyHoV7F3fY/lY9neCyplRAFeiT809
         uX3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793645512; x=1794250312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jUhK5m1lvTjtdfmztu+bilD4B6b4ERUK5SOg2m81DN4=;
        b=oAHsBZzQFRzFgpMVW2ibcSRWgmWa2E5g7NR6s7aiC3a3yqTRF+S+AzYZWsSM2Id4Ta
         Q+7b4cx2eXM02RtM/Rq4KgBY3NaX+sn3wjvTYKqG7Kyl0XgWx2RuVavFyEzahKXNzusw
         3+nbzDnXZuUKRE0+Fu0uqI6VvFIN9MTEt0m+/ZGTDANnmLjXPIpIc4+FBdUV0I6erthp
         +4rvFkBT8AlmugLvp9G7rPmRFqMWU67b76/d2AVvPPI7R9PgtNj8mTcbja6yhBsWHY24
         JHpgfPEnuS4xPyzQdQvraxThV+cvVnmU4ORPMh+aMNByVG2oT58j1Do3Eflxa55z/fB7
         mwbA==
X-Forwarded-Encrypted: i=1; AKwUvBxvk3eL18KnIXpdZgiOsMV8DCDu7FtNs8GH1ZzqCXKVEszSkisJn667JpHYNrr8rZkfKCqWHJVIBg==@kvack.org
X-Gm-Message-State: APuU4Z9toXWqrwnDkDuTyR3NEM35WhhbMMXHl6wNX9r9nIZcgHKbrGyG
	4/8q99a2EWytAoFYNDKvZaDVAbj8DSWSdSa9qICOKhg1QySWasgr/GXmMRKmFTVWqaUKi7Nf
X-Gm-Gg: AYBFou2zSGBY11u/326bins/qr7fzBKpNVR2YhBvQjX+w9cio+4vHTcPPIJDiyVY9Sz
	5Whi2ahgtHPZl8kcjgfWntXIK5Zqhk9yl8RzebhCgL0njzYYtj2o3TqZSka1Kw4NM+8xJeHHITm
	63nng8oy4sgPsGtGhe8P6L5T26dg6oyrS8kCEbHwqv3hARjYEgXZDZHiCMuFv/9lLBAQF4R3qqX
	0X62JlemEHpmgjx/ghUEtYp5j7ZLqSagqkXXt8CwIQoQBqqXh+aTij9U/89oT42cgcOh8yQK/2p
	ndP0sU/v0YXCBEuq2YSR5qnsko0wezWo5Dw9M4oLAawQrcmyLK+SRnj8Vz6Iy6vQ8b8YTmiYVZl
	4Xcz5V9SxfM+1Co4B/t/xbCgihPfxh3Fnth2kmkbe8WgN8VoJMAD0LgC+apIdGLd0+swU0nHpFk
	ufWGdJvqFuGomEwCnnlyA3S4Xgpg/D7ehdcpqE08PHClpikS1hiNO11AoK9krQoTr0w/djub9of
	DzgiIjQ2RI8fONM1Ck4M442l43XUgL1hMgOJVkMa2/xlBxQhRVhYVsRw5KLCKVAWsok2sf+XOG8
	Es3Zkll8sLWxMhOhRGkLYVU=
X-Received: by 2002:a05:6000:4559:b0:488:79d6:a4a6 with SMTP id ffacd0b85a97d-48e6e2bc780mr16125799f8f.8.1793645512031;
        Mon, 02 Nov 2026 10:51:52 -0800 (PST)
Received: from fedora ([2a02:4540:28:4cc2:7f6a:92cc:ff40:8b84])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b728f9sm21260812f8f.10.2026.11.02.10.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 10:51:51 -0800 (PST)
From: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
To: kas@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yeoreum.yun@arm.com,
	ziy@nvidia.com,
	Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
Subject: [PATCH v2] selftests/mm: handle child status safely in khugepaged
Date: Mon,  2 Nov 2026 22:21:30 +0330
Message-ID: <20261102185130.30504-1-ampr.mhd@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <auhvkuDO8cP9Pip4@thinkstation>
References: <auhvkuDO8cP9Pip4@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BDDE94000D
X-Stat-Signature: dp1zopd5q8sd3eejcbhnjm31sz5qefze
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793645513-345129
X-HE-Meta: U2FsdGVkX1+IowK+dLpOyG5kO8NTSSlzeEbRkLXnBozK25DpIMve5avKXLJBQMLeG0b1VLnDEltC3W4Vh6uymyUAIoeNgCyYwKzY2xrXToCTfeXRMEu4fRIEgAAUDhpbvHWst0lzjwqtXYKXV1XFUtAAiwSs1J3NpmbPmeUDBmgzP2IXJsOX2/34Gif59AHJakGzHPXEczswiBdRWMELSkzHNGxVsGZOUSP5sIAE2S37mHGaNRzhafO2h9fTDUqgz6aIbNQ6b5kBosr5gyVZuE8HUEG7fe36oglhLjh7U4pYHNfZEVHgiwtNlwz4qLg9m0tZ/32O3DMRk7MgXbAkfRtDyXnjau257zX88wgpw3m9Nep6BYiP4n0re4VLbsRUr4QIEmO/kQsOTjhduiZgxqrwzao9c4TTfrINE6M4OMB2563992wDxOr5dD7GtJD69NK3aDVP3J3SFfh/4aHE1ChLRYjJfjQp3o/9YJSsDNL3m5mWlE4KJDXHjdwfSdJ3KbIJ1s9gFDRikZ0+p3JyJ71I/dBQogZfozKsDrgvFJGGw10Nqvd8iqz0oybQ76ShR9CjrKVoWLd78+yKkRWuOp/l6DcSBFbv+ct5PpysicsCCx6hYjuCYf4Dvty9dPYr8wl6i3kTorTdytzpcec6IwpoYkBxbS2BwvbGVSVfZTc+mYBANLvpaI92DT/ExV0cT4dLSp6co0mwdLxI3l9YHvq7MWCZswY0Mp4kYEbx/QmjBhzpP/RMv2jfUeH6alD1k7F2fqz5cg53HxcpHAMOZwiHcqNhcV4hjexemYwLE14QOa2c8VKELwrg/6VtBVPpylGjYuoPsT77corPAFP8yXpxLjguDgh+jtZlcvtc5nchUoTnO58lvCmX+4EcneGHybrXBZFFKeUlVcIWD5nd5k5uIb39rDbpvhA3N0oQ4sP8EaELHPaPl0X1mu+ZAOI+e2TYAc6YuBFk39jdMJd
 7Mw0+iOZ
 ZUbzXzLJJY6WXyuFoJMfKkyf/mZLTo+n7Na44eNHu1EFY7JLszMS7661da+kYELe9017bm4kgtM/lNbSStwELqNvaZql2J3negjRH4o1uEWgkeUkyTR/pRnTMT07/uYTpIdfdS1sSriUn4DgOezIrOisbbztYNR5wseUKuYpz/reykAtwKXtrwvKh+sspeO/kW1QOEKnlP4klw44T+4LaE+PpwAtfB+YAyyfq+3Nvgx3WptzQBiOHoYWx7NOAlIELsFnK9ZctY4mo8FRK1r4TkeNao9HZf4Hr2fiUfUejUkdtogook6KtNL5ZmdYVYjBjGwU9ova5MOlS7tkeCyTTCp9e7CM7E1zvhMzckqhy0mtAvQvnx8rt/8Qg9II0Ec4GZQrYLDX27qiD/7iMIRkmcCuobI7v6E4L5DgOvJEUJwtuLRlLd+cPoaP4m3cjsJr/5xV3EUVKjz1xKyl8vUUILJSCNCxT4e7ffSzXlQqRqPZaCverv5dIq8T9gQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

collapse_fork(), collapse_fork_compound() and
collapse_max_ptes_shared() take the child result from
WEXITSTATUS() without checking WIFEXITED(). For a child
killed by a signal WEXITSTATUS() is 0, which is KSFT_PASS:
the parent runs its own checks and the test reports ok even
though the child crashed.

Fail the test when the child did not exit normally, and print
the signal that killed it. Also fail when fork() fails,
instead of reading an uninitialised status.

Use get_child_status() in all four fork tests, and use
wait_for_child() to handle fork() and waitpid() in the
three blocking-wait tests.

Fixes: bd212a7dbdb1 ("kselftest: mm: return fail when child test result is fail in khugepaged")
Signed-off-by: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
---
 tools/testing/selftests/mm/khugepaged.c | 61 +++++++++++++++++++------
 1 file changed, 48 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 1bc7acc66a46..b90daf008239 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1004,9 +1004,44 @@ static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops
 	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
 
-static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
+static int get_child_status(int wstatus)
+{
+	char buf[64];
+
+	if (WIFEXITED(wstatus))
+		return WEXITSTATUS(wstatus);
+
+	if (WIFSIGNALED(wstatus)) {
+		snprintf(buf, sizeof(buf), "Child killed by signal %d",
+			 WTERMSIG(wstatus));
+		fail(buf);
+	} else {
+		fail("Child terminated abnormally");
+	}
+
+	return KSFT_FAIL;
+}
+
+static int wait_for_child(pid_t pid)
 {
 	int wstatus;
+
+	if (pid < 0) {
+		fail("fork() failed");
+		return KSFT_FAIL;
+	}
+
+	if (waitpid(pid, &wstatus, 0) == -1) {
+		fail("waitpid() failed");
+		return KSFT_FAIL;
+	}
+
+	return get_child_status(wstatus);
+}
+
+static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
+{
+	pid_t pid;
 	void *p;
 
 	p = ops->setup_area(1);
@@ -1019,7 +1054,8 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 		fail("Fail");
 
 	ksft_print_msg("Share small page over fork()...");
-	if (!fork()) {
+	pid = fork();
+	if (pid == 0) {
 		/* Do not touch settings on child exit */
 		if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
 			success("OK");
@@ -1035,8 +1071,7 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 		_exit(exit_status);
 	}
 
-	wait(&wstatus);
-	exit_status = WEXITSTATUS(wstatus);
+	exit_status = wait_for_child(pid);
 	if (exit_status == KSFT_FAIL)
 		goto out;
 
@@ -1053,12 +1088,13 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 
 static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *ops)
 {
-	int wstatus;
+	pid_t pid;
 	void *p;
 
 	p = alloc_hpage(ops);
 	ksft_print_msg("Share huge page over fork()...");
-	if (!fork()) {
+	pid = fork();
+	if (pid == 0) {
 		/* Do not touch settings on child exit */
 		if (ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
 			success("OK");
@@ -1085,8 +1121,7 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
 		_exit(exit_status);
 	}
 
-	wait(&wstatus);
-	exit_status = WEXITSTATUS(wstatus);
+	exit_status = wait_for_child(pid);
 	if (exit_status == KSFT_FAIL)
 		goto out;
 
@@ -1104,12 +1139,13 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
 static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops *ops)
 {
 	int max_ptes_shared = thp_read_num("khugepaged/max_ptes_shared");
-	int wstatus;
+	pid_t pid;
 	void *p;
 
 	p = alloc_hpage(ops);
 	ksft_print_msg("Share huge page over fork()...");
-	if (!fork()) {
+	pid = fork();
+	if (pid == 0) {
 		/* Do not touch settings on child exit */
 		if (ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
 			success("OK");
@@ -1146,8 +1182,7 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 		_exit(exit_status);
 	}
 
-	wait(&wstatus);
-	exit_status = WEXITSTATUS(wstatus);
+	exit_status = wait_for_child(pid);
 	if (exit_status == KSFT_FAIL)
 		goto out;
 
@@ -1248,7 +1283,7 @@ static void collapse_fork_cow_race(struct collapse_context *c, struct mem_ops *o
 	for (; i < n; i++)
 		ip[i * stride] = i + 0xbeef0000;
 	/* A child that died reading the racing pages is a failure, not a zero */
-	child_status = WIFEXITED(wstatus) ? WEXITSTATUS(wstatus) : KSFT_FAIL;
+	child_status = get_child_status(wstatus);
 
 	ksft_print_msg("Check the parent sees only its own writes...");
 	for (i = 0; i < n; i++)
-- 
2.55.0


