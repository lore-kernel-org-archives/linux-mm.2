Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D41BCDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 14:25:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 469F46B009B; Thu, 25 Jun 2026 10:24:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CD286B009D; Thu, 25 Jun 2026 10:24:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26C3A6B009E; Thu, 25 Jun 2026 10:24:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F18526B009B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:24:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 818491C07BE
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:24:50 +0000 (UTC)
X-FDA: 84918656340.30.7663DED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id EC05D140012
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:24:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C3+fSQTg;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782397489;
	b=nf/ad7p36JCu1fG+O1bNUTdV6KJVT+iqzZGTj6nOcssRjwgcUTHyCDtVtB5RYsuOBBIcCr
	2c8yN9OOkJS8uMC6BDYZg6jZkzrbDYJEuf3I45m+cmBJ85xth93PIdZqwGTqWSfrAihifR
	bCVi4hbFvJpbXJv3FKhAAscZdmGDr48=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782397489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J66HJiTvNrVHrkrUjTA08Y7jf1bcSRDPMBd43t60n5w=;
	b=Xm6v5bR0NLb5Ak5gsJE0oLGEjzaez7ZGuyyznSu2fAdX7EMMCvXSvf4tJqZFn+MRBHGXGw
	7htyEPh43DnuMbcLZWZUsbyRx+Vnnm0ajZgyqyIwW6qcu7w4dgtG7G1wqzuIQS5Kk/0XXV
	yhHn+T6MdKzJCotddC/mGur63TQJftc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C3+fSQTg;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4966841A95
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5861F00A3A;
	Thu, 25 Jun 2026 14:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782397488;
	bh=J66HJiTvNrVHrkrUjTA08Y7jf1bcSRDPMBd43t60n5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C3+fSQTgf2dsmDo2ZngoTY4swijX3RY43LlVRbyAl0dyCOxRmV/xYh+6SSkgQwnAT
	 ocS6+acumB/yrCEbkl+59QfvUBKDEQ5a4k6sNhJ9c9+Z6cRnNEk6aehYJsTuCB6Mhj
	 KYqO7rW4qg8bdmAs/a5pRQsK1/8TqIGSQcFAPKybmBgTR9olvhjdHNWHNzSLaELcuO
	 40yM05lmWPCnPG09SPK8HyqSFq6A0f1We3nNwM12KeYjJxkOX88w/i8SG77IGCEEoL
	 JJoVdq5vA/Pwyy6wF4afH//uW5+34mGbegbTfd/NU8TQlKlP+DtXcyMx/OPX5mKLfo
	 2Hbd9E8mYi5WA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 07/11] selftests/damon/sysfs.sh: test all files in quota goal dir
Date: Thu, 25 Jun 2026 07:23:52 -0700
Message-ID: <20260625142357.103500-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625142357.103500-1-sj@kernel.org>
References: <20260625142357.103500-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EC05D140012
X-Stat-Signature: 983efc1kdrmmteprahgmwjx747791k9k
X-HE-Tag: 1782397488-896779
X-HE-Meta: U2FsdGVkX18DV9NRlQTw+WFwdhdEVnyePKHVrWkwBZymAdPTBnkgjOXaOZxHEXGp9pEAwcViXqnL5Ez72+H9xCqxI95W1ZzJumyimj7NT2Wt731y/P4snBUznI/+/aHHduMG2k8qIe8NdhpebrF1V6ooON4mqZ77a1oTHf+ycSxwrQojehJUGF+OCNgGJbW+0DPZm/frS1yt2x8wg/K7y6ZZi8cMB1rMAKSIl86awyO35hyfXnsWntRI+MJeOXmCzhbtVCBK7kK6FtEw37FWa0NqcR1e0yk/Gd4DEm1qNlhl8wf4mmri5io6xPFDbtGuheAqTMgcT+frzIcVCyNf3hkF3LnHmVoEy/AkVf26eJftbcP4NKOgFeA4YSwVHE5Fcli0DBTq3AWpuWfRInZqPCMQA2vRGb4/4VQkfpou2vnQ1Osuq3wu8KiaaQfT5/f9Dk3kmSniKBefd6HGtfPobRCOFJUKBsA55c680VZc4G1Vz2KCwE327Toyt3Ap4zNSyH3wgAuvVoV+A4q4p+XCQFDOP5YE5rHkz5Fw/QPlT3gmo3fCkKV9+0MEkPsi+eSCWwpMiWu5T043MTI3qk06aPXX/4ax6Cj/4228EWp1Bd7IBbsyx7TJfied8A3pgIwj7hPS+sx0edPXE0Zv4gkom+ZJh6ok/nPS3I6FJ9B6/DFKMbWrZLGBSN8pifQcE48mEhCt2Xy5i5DE2VcyjvxSmHoXocp6aiMP+1Rcg52cLdhOzy934bWa6grLLdDFnn9pDB3I+9sdtNDTWAf6N7DM9CJ1lJfoipD8uiS598uy0mlx1he2QIiDY93tgxGS+ST+IN9FvU/shcLdS57LX5J8CCfXfOgD/FcxldqTW169afDIYPqflLWy0nkIaBp/U3YXMXMr7pONIFw4Pr892SGI79sWhq6vw14wvMUO/9H+gqmN7+WIYJNzPIkB6xUWDcTzaV5KJKl9eNdmXGygcSj
 ix8pVDHX
 RrmFIbt7ppsGK8mVvssLWWqkXaDBXFVvla3YhlW/8SwYv/wk8twYP4VMLUCtVp1AzQlBUqDNly4PPm1N/t+1UqP55vKLpq8vkEDLG1RUEBsj2lzv3ueKOAp+nFyjLEPeRULGAxxrSYyNe5KO7SUFFb99aqjwNqtPcROh2A6lyXTDkY+3xPvQTS9YsxELMXX4vuTLLyWYfAtdny5cbrG0UvFLqGAGwTLXqotLq1aujk5Xmt6KQ9zRNT5PlDg9iPprTM31wJaTUz6SXvmM8jZNqqt1P7J6VblXGXw9j3Qtrn8Pc/es=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface for DAMOS quota has quite extended since its
initial introduction.  The test case for that in DAMON sysfs interface
essential file operations test (sysfs.sh) has not accordingly extended,
though.  Extend the test case to test all existing files.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index b88bf7b98d7f7..811173cb89449 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -199,6 +199,20 @@ test_goal()
 	ensure_dir "$goal_dir" "exist"
 	ensure_file "$goal_dir/target_value" "exist" "600"
 	ensure_file "$goal_dir/current_value" "exist" "600"
+	ensure_file "$goal_dir/target_metric" "exist" "600"
+	local fpath="$goal_dir/target_metric"
+	ensure_write_succ "$fpath" "user_input" "valid input"
+	ensure_write_succ "$fpath" "some_mem_psi_us" "valid input"
+	ensure_write_succ "$fpath" "node_mem_used_bp" "valid input"
+	ensure_write_succ "$fpath" "node_mem_free_bp" "valid input"
+	ensure_write_succ "$fpath" "node_memcg_used_bp" "valid input"
+	ensure_write_succ "$fpath" "node_memcg_free_bp" "valid input"
+	ensure_write_succ "$fpath" "active_mem_bp" "valid input"
+	ensure_write_succ "$fpath" "inactive_mem_bp" "valid input"
+	ensure_write_succ "$fpath" "node_eligible_mem_bp" "valid input"
+	ensure_write_fail "$fpath" "foo" "invalid input"
+	ensure_file "$goal_dir/nid" "exist" "600"
+	ensure_file "$goal_dir/path" "exist" "600"
 }
 
 test_goals()
-- 
2.47.3

