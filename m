Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F8FD606A322
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 21:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=KZSQqbJi
Received: by kanga.kvack.org (Postfix)
	id 418856B05B1; Fri, 30 Oct 2026 17:58:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C9966B05B2; Fri, 30 Oct 2026 17:58:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B8FC6B05B3; Fri, 30 Oct 2026 17:58:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E5B576B05B1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:58:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4ECF11A089F
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:58:51 +0000 (UTC)
X-FDA: 85380658062.17.45A184B
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf27.hostedemail.com (Postfix) with ESMTP id 989A94000A
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 21:58:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=KZSQqbJi;
	spf=pass (imf27.hostedemail.com: domain of ampr.mhd@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=ampr.mhd@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793397529;
	b=xfSjpw8rTNYFdku4kE7W9C2yHN8xxF/b0bxrIkkj1S5I0ul+nZ0AORXiQehyiuMtYlwDW1
	XcodfSx+j8B29YDU/UHZFSK4kophH37uhFwYlNF0FXYinus19PQXaEryLyf0qDTqIE2icP
	xz3biA9hlg+B4XXoX1/xY2FrTXwNrIc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=KZSQqbJi;
	spf=pass (imf27.hostedemail.com: domain of ampr.mhd@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=ampr.mhd@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793397529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Yx1pZLwwkBWkRpnVSBKgTH165jQvpQXHy1+6SegQOjs=;
	b=mp0K96RecCj7s9bWIJA4E8V0rfpOWb/TjbBwGrhHfPE7VugZopg1umGosiqUGPLAD9nTL2
	47OCuZrEXOLvFXdls1SV/tqG+eWYjFucrG3ED/y6aDLv9rveDKBlakZVSN3zVxRztoY589
	8WUl0gJY46wHMQnh3ZOn0SY5EDSZJkI=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48b042c0759so657657f8f.2
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793397528; x=1794002328; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Yx1pZLwwkBWkRpnVSBKgTH165jQvpQXHy1+6SegQOjs=;
        b=KZSQqbJi4BdmIlstzzAo/fNV3TOj8k+oDnSmc/QjdpHBFWI6ejatydBIEhF1QWEZ2B
         D6qy5b1dG7mZdgE1rm8sKbokggL1Dm5rewxRdX30X3X9ym0ufUGapoN5YRN47lL7vahA
         klQ/AO7npuXqllp5NOjcJckR4cWgVhpaNnnjYrCeDEvlV7TIPGs7GwXg2uv28KekIIgS
         q4n9vO9L6sZszebfrPEFSN6Z2RgvmZQdU1iHPO8sE6ZF0QFLkC9xyr2B1HHUrjBL875H
         EdXUzxNoLQpT9eoAUF69BOzldRDCrhxPf5hPqHU9qqsrSMEt7MB4rcD/Sa9JldD6s9Nn
         YByw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793397528; x=1794002328;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Yx1pZLwwkBWkRpnVSBKgTH165jQvpQXHy1+6SegQOjs=;
        b=Zf0VWo4rfweKTSVvRMkGgOpg6h2vr0S2Z0Bz5yXgi15A8DvfxrmSHiJ4AeSGH02hFG
         J+PNjs/qdkQznK47g9HoFx0kfFz9e/1ySvonirXfuQEppWCMag4fcM+Bg+I0Eci9iAxE
         1r4s/cdZNFHXX1VCH7VtCAPpiZgovHjYixZnlJ2ffwfa30vgCXxoGpo49gR8oL8uJfKo
         +yB8p4UTbtAfOTNfuS5oHDl3yQrxOuHKnnv1wkHnNoF8D0x+KGwf0m+CGdklcvBS+VX/
         RfzEJJQ+KezBwZK8colupitf3dG9qiPltu92/t/W9wEssr0MGVYrPTk8j+dvlUSCNwd3
         i/aQ==
X-Gm-Message-State: AFq9FYK9l7T37TiUEgFEzjT7asgI7bokjJqe+CwGLK8Ig8t9GB8a94QG
	LzwXjAXcyoFKgr3Czk+rVKMhspaykF70h0l2/eoTsF4kcACMUJMeEH2c
X-Gm-Gg: AYBFou3DOZMg2eoKkl3A4KfEAfeanDIWmtQI4Q30WCUcRB9BPwfoORYcdzkMgEIfJTb
	chYYlkDK55F/IR0J64EMiCAP7WpflhYJDQrISUD/VRoiSaF73nGwqUsXMQIka0eB4DOs6Zc+cQ/
	ykvViTyjX84ZMADtccVsZ8uHx3MsBPyCqthEqB+EHfSTBTZSlNPWy9wLpRGscd6nRnqALgx+4jB
	APYtlIsr8RaOQgnwZcGntrteNY2tgPe/cBbNavvppSVabYNo2jGTkGJ6U7AadmdIZyJr3n3I24B
	k1wOJbfwnJWYtCNdOdBqu075yq4rj99Av4GQ1vOBEw/nGQOtUMbTyuoFhzAQEmRNBYXd7JLpHHn
	7NWYv/LiCvZT4n9Q4XrkjLPHNBKg8qd0iV+vjFbDKiDmFq6ji35XHaSLYQK//neLgTwHW4SAVwE
	AHaoyl3uUmqB40mGKwHTJFtavqWkBotiR2szX6A8UwSRX5ckMnFzlAi+VvJG54w2urVREvj6x+i
	FomEkYy4+qJHCXV57bU20CBSmN1SzY05KaP01KX0s4JqEo37Vo0F6qkYfX/f7OJFxaSTn0jema8
	FRtWqDd/MQM8WwasjpvaYHKgcgl6aJzEHhEa1H0InHtegAoaIGQFhLACjpLd
X-Received: by 2002:a05:6000:402c:b0:48d:f39b:83de with SMTP id ffacd0b85a97d-48e6e2bdf87mr10007670f8f.3.1793397527950;
        Fri, 30 Oct 2026 14:58:47 -0700 (PDT)
Received: from fedora.domain.name ([217.218.153.252])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b9b54dsm5312409f8f.47.2026.10.30.14.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 14:58:47 -0700 (PDT)
From: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	yeoreum.yun@arm.com,
	ziy@nvidia.com,
	Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
Subject: [PATCH] selftests/mm: handle child status safely in khugepaged
Date: Sat, 31 Oct 2026 01:28:41 +0330
Message-ID: <20261030215841.229969-1-ampr.mhd@gmail.com>
X-Mailer: git-send-email 2.55.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: aeedz154j7reirr75rp7r68ra9rj7chs
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 989A94000A
X-Rspam-User: 
X-HE-Tag: 1793397529-774581
X-HE-Meta: U2FsdGVkX1+NyK4o71dtYKY4QN+P0oP2no2RpEunyoCBSn1nv6Z5J6yJD7mTz2jIpK6MDALT+oWdWmc2qWPbObjHEimlj5TnRz8O5+VLiHEAZldxvCdWe1MRiFaOkNIr0HzxSrFk+cah4wlwQHufiEdv31q4s4Lsno2OHbWlDZ9JbK1qaXILigpHrkoAhZnidT3vz9ztwJsWOnXX7D7qiiY/2gQ3KSAXKjC4SQ31HzcS7DciTkUYltjin0NVvnVCE8/Sl9jt9JxGLkbHrdXPPzQ3gF6ViUbaPJxThiXqilUwU7t2n6IIj0MAkiOCBfsB2W7KtoWuSaVosuVgeedxlHrTrRO7ysalfGMLJ4WMlxhvULwyQqWAipTDlkJs7FXbLjVF0wRpiWsjLc9v/1PcwcXQt7xL3CiS+zwe52wgUEAFf9kiD2MXM97fp/BvWj42srTlTB3/e5AgPtDpD+FTDfr3WOYXB1ZgmLYO1Y5uFXM3vimmpvrFQzroiBOKk9hX7F0J/L/3Ut1MUARIMtxt5M3ypqiIzzZpSTDSUpEdp6oOcOdP/GS5x+QJyzf4xkev9HWWA61tc/cbxfqk7YsMYlmGfZ1ojJ92pDeFhrlTu3CQ3xyhOjdx0p2JnCd1kZF9PDP6Oilkwjdh69Lh/U2a5u14wQLyEsHQ9EoEpcG7lgXD437xelzg7kkmdYW9ICqVJDcmz/me1Q0Vt337vqDvvsbSRwCSpHYQAdFALvrBRzMAiE6wdJvFmkuX/d8qQlvDzjvXjzzu8Y2FUr7vGI7OS78FBCn2qe8Y/WHfuiwzl7MJled0RsswX87U/2S0q6B58L1B5z9smbJjPmEwPDkyNUcd6my5h8aJy5lohxdnpZEEQP4sdGj7KtMLvjmJqP7VNdhScR1pcHZbl4bZHH93S0pCnuRxwAY9TTxmW/ULMM3tL3cWel9ilufQ6xdcAVyq+ujxOJ4cMXkDBBLHJ9T
 uM4Azcu0
 RUGk+YqSELQUrzwfK8gcRvZR3GvpqZBlCyBVowjNWqozaSKs/L4aVREf7WqsBwoYVPNCKxXFKgDDoUsK0idbLROWAkvgf/pDZlN7W2FPG0PhX7stLRwtnTsZAXq7QeOdAG9n9atzYvv3hY6I7ndLJTchhDKw3aqUoU4VubCumK+8/7D4/wJWL3F4Qv6vBl4xJtleWDUzYDvMiNWGFqXJQQrYcvqweyC6K2h2UQUQoAtHRC4n1jDZdDvYOHJiR9C/SdEbY9egTBBR1JPlFf8fK49q6jhhVqd9aCfA7DJfxn5d4P6YFOIZvRpgnLAQWZ+krptt5LdezhKrqqlKxUtfN73kJRKeaIEP0jiAPraQAuJ0Tgq+zY1FvPozlOMDGyyqtDaxayG5ZspMcD3YUyNa99NMzyn4SEMJXo89wgDvaQvv+buNB8yzJvT6wf57em//TB67J3GcBZb01OLLaS/tUJhP7578HsQvyoIyWoLxypjDMtCo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The khugepaged selftest reports child exit status through a shared
variable without checking that the child actually ran to completion.
When fork() fails or the child is killed by a signal, the status is
undefined and the test can report a false pass.

Capture the waitpid() result and distinguish normal exit, signal
death, and fork failure before interpreting the status. Report the
child's actual termination cause in the TAP output so failures are
visible rather than silently masked.

Signed-off-by: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
---
 tools/testing/selftests/mm/khugepaged.c | 57 +++++++++++++++++++++----
 1 file changed, 48 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 1bc7acc66a46..2dd68dde1c14 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1007,6 +1007,7 @@ static void collapse_compound_extreme(struct collapse_context *c, struct mem_ops
 static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 {
 	int wstatus;
+	pid_t pid;
 	void *p;
 
 	p = ops->setup_area(1);
@@ -1019,7 +1020,8 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 		fail("Fail");
 
 	ksft_print_msg("Share small page over fork()...");
-	if (!fork()) {
+	pid = fork();
+	if (pid == 0) {
 		/* Do not touch settings on child exit */
 		if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
 			success("OK");
@@ -1034,9 +1036,20 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 		ops->cleanup_area(p, hpage_pmd_size);
 		_exit(exit_status);
 	}
+	if (pid < 0) {
+		fail("fork() failed");
+		goto out;
+	}
+
+	while (waitpid(pid, &wstatus, 0) == -1) {
+		if (errno == EINTR)
+			continue;
 
-	wait(&wstatus);
-	exit_status = WEXITSTATUS(wstatus);
+		fail("waitpid() failed");
+		goto out;
+	}
+
+	exit_status = WIFEXITED(wstatus) ? WEXITSTATUS(wstatus) : KSFT_FAIL;
 	if (exit_status == KSFT_FAIL)
 		goto out;
 
@@ -1054,11 +1067,13 @@ static void collapse_fork(struct collapse_context *c, struct mem_ops *ops)
 static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *ops)
 {
 	int wstatus;
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
@@ -1084,9 +1099,20 @@ static void collapse_fork_compound(struct collapse_context *c, struct mem_ops *o
 		ops->cleanup_area(p, hpage_pmd_size);
 		_exit(exit_status);
 	}
+	if (pid < 0) {
+		fail("fork() failed");
+		goto out;
+	}
+
+	while (waitpid(pid, &wstatus, 0) == -1) {
+		if (errno == EINTR)
+			continue;
+
+		fail("waitpid() failed");
+		goto out;
+	}
 
-	wait(&wstatus);
-	exit_status = WEXITSTATUS(wstatus);
+	exit_status = WIFEXITED(wstatus) ? WEXITSTATUS(wstatus) : KSFT_FAIL;
 	if (exit_status == KSFT_FAIL)
 		goto out;
 
@@ -1105,11 +1131,13 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 {
 	int max_ptes_shared = thp_read_num("khugepaged/max_ptes_shared");
 	int wstatus;
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
@@ -1145,9 +1173,20 @@ static void collapse_max_ptes_shared(struct collapse_context *c, struct mem_ops
 		ops->cleanup_area(p, hpage_pmd_size);
 		_exit(exit_status);
 	}
+	if (pid < 0) {
+		fail("fork() failed");
+		goto out;
+	}
+
+	while (waitpid(pid, &wstatus, 0) == -1) {
+		if (errno == EINTR)
+			continue;
+
+		fail("waitpid() failed");
+		goto out;
+	}
 
-	wait(&wstatus);
-	exit_status = WEXITSTATUS(wstatus);
+	exit_status = WIFEXITED(wstatus) ? WEXITSTATUS(wstatus) : KSFT_FAIL;
 	if (exit_status == KSFT_FAIL)
 		goto out;
 
-- 
2.55.0


