Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5519AC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 03:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA3896B019C; Wed, 12 Aug 2026 23:50:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E54C96B019F; Wed, 12 Aug 2026 23:50:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6AEF6B01A0; Wed, 12 Aug 2026 23:50:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B04AE6B019C
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:50:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3F3951A052D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:50:12 +0000 (UTC)
X-FDA: 85094868264.13.BA7F7E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id A8A03100007
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:50:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="d6KR54/r";
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786593010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a+KFNc38yAs5cF8y2PPkR2gfi2v/4V0wSG+v466VkTs=;
	b=AzTFPVdEbHjrWfXSsa7fNrIJ45A8jP5CoU4sEDk+4sO+MT0b2+ilgZuLr4q77+Umvih13d
	YycLP/SiI/J6DHz5w4zJflASCPYGL8XGLHtHWjSXPUa4rcb6chGuHboFFhurdwq6LJ9m7d
	6hHu4CdShctSQ3Axfi3tKW81SdYdamI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786593010;
	b=RNJGF3d7CVZZtb6W2AAyup7NfmYigVfbgRNLoxFxwvQDzAT03zEzfTD/ab1z90s0w0qzgP
	agKFJSXBto8aaK/JynvB/0AgPFxB6mGzrp1BaDML1SbFiL6rvbYaJmbDf6nqum8J9TB+FH
	i4s0sNZye7wegw48qVfmHzh6BzITXgw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="d6KR54/r";
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 09A12439F6;
	Thu, 13 Aug 2026 03:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7E21F00A3F;
	Thu, 13 Aug 2026 03:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786593009;
	bh=a+KFNc38yAs5cF8y2PPkR2gfi2v/4V0wSG+v466VkTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d6KR54/rLJ6ePQb83TqoNr8jusNymXRiNaj14b1zv8TRr3k3J+ryDyr8d+rkhKygi
	 U5fDBygBfVu0bhTdsz8bB7ZbWwyHPexkewIv2J+VKov83KofK4K59jFtdBY7PLpGzO
	 um5jy0k/35nTdRW0wblktzbuZZ6qAoNe4cjdyMyrvtAiGNNsxDMCZg9rk8mDiu5Nyg
	 orXJhay8agEVn6stcxkWGnoR+cnU1isxlDgl3uo+7xddVNIfJUqlVH+cDMo65LXzas
	 ZLzRUvAr16bExumbamKbgV7i9en9Wb0VrlFc71DF9occwI+Dkz9q6Ki9S6wzaMa4A1
	 o1aVT6ZpO8Kqw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 4/4] mm/damon/lru_sort: remove unnecessary damon_call() param validation
Date: Wed, 12 Aug 2026 20:49:59 -0700
Message-ID: <20260813035001.97364-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260813035001.97364-1-sj@kernel.org>
References: <20260813035001.97364-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: qrfezx1wroxinsrygaerjhgchrm8w1n3
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A8A03100007
X-HE-Tag: 1786593010-600759
X-HE-Meta: U2FsdGVkX19LRTSYGPaytIhOjcKGsVb1I82dsni7JSDy6QsL4XcOKv6hTkz87ddW/uqEyYcCfxvFa7MoYY4h56pOxlNeWuMm5FyVdZVIiqB0/75Y67CXxuoZK0CT/x1NmJgAuRgsLPLpHZIhIdPocB6p87+zOwTAcKa5xRZYpT1s1Zh2EvvndadVA53cBL4j9bU/0hUM572JkfX481l7m6ihSKz5BcT4oV0/mcaDhCSCES7zOQNPaSWUMjgmmSeiezbYD91B8nZAv8+SR3QeazmKqpIVpqw1LG4Q5dkzXyxGhcCLTkC611115qmTU8bcajpmbX+VvFjPH5p/rQ7V6+SzmL89g4dzYzII6aRdFRFd3kjm5w7Tahyp0MSrcsnTBP2FBF3ZAq/5oLCR5dOB+/7eqqc/4w7zeJKrmIqo4+PuQEptJ1PtQDpS5y8mDWCMWBXQKSrclezQKh8zcJbl+R15azYx3BfjuGQucQHnQJBzlygP97koRMi1JiAM8aronJYAdME3TUsFsw3964nXDtYxnLXX1YRfHZvWTThAxrwKGnU4/fe/fiByKdhGUv68Dya1wHWQ8tesxx0EvFefzss/2JylJ8qqKnEc2ZopnBSEwUKhnAnUpAQUdKN7ofGjoEizU1tkhNJuc3ek5pccwsMXafST2v3pZr2XNhkK1ZOjH28cDChePpikohft5wKEAa1MaL46yivpgjr3/x7Li+gboZXF31To46mEZ7Ayo0t8xKq6ELRk5KHL8t0ZiSyU42eSOdpjr6oZNlsvnrVCoJXc5WyQH+TRdc9dMbDB+7w7VVhkZ5n2IWNM4ZaYJJD5ogO+tloU5jYVZjg8nXlnE66YkuqPfbft3Nj6B1uh/97YRU1uQs+Q8GzjcfeTFvOuLw/neXt/zOmUA99+3DAlA7GzNPcVDuXHgO7MPGujhe4XpCl5p6UY1hu+VJubMee9BBewYvlpB7fPkbckVMz
 MmJwoOt6
 NHPOUnEWR97k5c7C84y7Tij7TaQWvuVd8h6NKYJUBY4Z4ZDb8g9FPqd+S0RVSf/iE37v6Kh+RdqNycZ/HHQjwYXQfodCpuM0p8952pPc4iI1YOejX75XSZsyKnUrHffvsW5984dpP0NCjxfqtoWpX+IVaSXp79+LnAaYLIXw4dQ38HTJG6d4CyKWlm4LUKNmOlKozRveRSYzFyIaxuhgpnrIfIJ9cLtpp3strLa9/DSVgQPkI/l1/bAbx0zOkBNayfIuN75wMP4gGx2pGrtFgVuaymg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_LRU_SORT avoids passing NULL or unstarted damon_ctx to
damon_call() with its own validation.  The validation is no longer
needed, because the DAMON core layer now handles the corner cases
itself.  Remove the unnecessary check.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index bd847829a9907..f25ee7326e87c 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -346,8 +346,6 @@ static int damon_lru_sort_commit_inputs_fn(void *arg)
 	return damon_lru_sort_apply_parameters();
 }
 
-static bool damon_lru_sort_damon_has_started;
-
 static int damon_lru_sort_commit_inputs_store(const char *val,
 					      const struct kernel_param *kp)
 {
@@ -368,10 +366,6 @@ static int damon_lru_sort_commit_inputs_store(const char *val,
 	if (!commit_inputs_request)
 		return 0;
 
-	/* Skip damon_call() if ctx has not successfully started. */
-	if (!damon_lru_sort_damon_has_started)
-		return -EINVAL;
-
 	err = damon_call(ctx, &control);
 
 	return err ? err : control.return_code;
@@ -422,8 +416,6 @@ static int damon_lru_sort_turn(bool on)
 	err = damon_start(&ctx, 1, true);
 	if (err)
 		return err;
-	if (!damon_lru_sort_damon_has_started)
-		damon_lru_sort_damon_has_started = true;
 	return damon_call(ctx, &call_control);
 }
 
-- 
2.47.3

