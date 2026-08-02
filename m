Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AA7BC55177
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 16:21:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3821A6B007B; Sun,  2 Aug 2026 12:21:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E03D6B0096; Sun,  2 Aug 2026 12:21:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10A716B008A; Sun,  2 Aug 2026 12:21:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF8DC6B0088
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 12:20:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 67682804D6
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:20:59 +0000 (UTC)
X-FDA: 85056843438.18.C9610DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id D44A9180007
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:20:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VxVIL/x+";
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785687657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0zkQs6mCwPIKeiUIY1+pQwOcOcVfTo/+g8AflA0OwVg=;
	b=D6S3xxs0/mEd8CUtw/wgr5rjzUjmf4qyYEFuMME+zYkgjK5Kc5bxKBbpO3rXeAEO6cOf1c
	CIAe5Lx8IdStbQDuxhTlY9KRemoVFigHqFXX3FZ45X6qxsV5I7hO2sfm/w55r1bLjsfLSO
	cmHJhRbd9Kl+Degnp4J2wAZhy2/ssxo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VxVIL/x+";
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785687657;
	b=fgV6IhHduPq40rI2DtD8oGeUJpwDzrZ6YGOt1OodgV8hSKRfpswuEekqfGvNHeNXoKWI0Z
	0U4uCB+okywENvNV/eh7wzQPS68I861fOHar5QBQr4gYlLkOl/mQWjMn2ssF1AoEcN1L7E
	M7anNOa9jFxcn1qibejFL0hvRFbSMCY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 35A0C60DD8;
	Sun,  2 Aug 2026 16:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1FD31F00A3E;
	Sun,  2 Aug 2026 16:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785687656;
	bh=0zkQs6mCwPIKeiUIY1+pQwOcOcVfTo/+g8AflA0OwVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VxVIL/x+lPSXwBymfAdejVtDamYvADtCXQL5xRajDaAI8Gtuk0W4YR66+gJVP68cE
	 AyVJuw5NeKTPnIKO/ZGdT2Qu63tJV8HimD/8MoEdAKw6JezCnyWY6qoGFr+zMG/dYd
	 ZRKupuw6+fXNZq6TxU2gEqvxrScLxZZ1OS+aWCTNGaEci361wpAEc05DNzFCh/ORYr
	 I/JAuAsVw5ratIlFX69NZwaAf47uqJtpFDuZs0YO03FFoWdqOJCGoXkb5dyXT19ITS
	 uYAIr9RczGoJlfHEx4QUNjArx+eBkYKipPkoZcwBUBxn8e5ADi2zcwaxUyaWQHG7T+
	 fBzMWiKviU46g==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 2/2] mm/damon/lru_sort: error out for >10000 active_mem_bp
Date: Sun,  2 Aug 2026 09:20:49 -0700
Message-ID: <20260802162050.89477-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260802162050.89477-1-sj@kernel.org>
References: <20260802162050.89477-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D44A9180007
X-Rspamd-Server: rspam01
X-Stat-Signature: pasqo38cs4r3thjzzquhsbcaickkzs97
X-HE-Tag: 1785687657-949260
X-HE-Meta: U2FsdGVkX1/y/NESqA/Ffcvj4h/ER8v2mz/vqXkjGrkV3wWLQtV6UB72fLb84PRKdHYMmgk41Tr4dWJNlUR1eQUzcXqoJkQWhVUIsT6WUWwc1JbkwI5Ge8CbA0mpFwwjE2i9CE1AnXIfNfslkltZtvWjMZI8AR749rqqghfI6HHvhsqF9VcWF+lnPUZ4DSTsZjmz+jl+KpaFsaPtDfpSuVLa+yuoyBo+/0vZTp+8HV7fyxu9VILVnsjvLyh2bpU6zm2Wh/3LaoWAZYoEt+0svW0G01DinJfPsO0zAd26iw43dDAvVkA2fxzE7i31wDrHWrvUhGZnIc7PYhxKbqfn9+JFysH/iVr4zwYIUuv5mNGLscKL9dMHQon7pv5WvqNsv4LPsS7fPovO5EHCKf1nK7R0IpdHIg0l3Iy2z4pYJmW0ig5PxaXC+c/X7bkKkUpKDQoCju/x/XeSdkA2oeAgBbijcGejWQFGFqCTd0jUzHscyJnkxExU+432c3YUa1WqFtq9ucoXlZvRkhBpf+nGeoWiQkPCXU41cQppic8u5r1CDHW3l9uoZWF2p3RUyhKMoKWKHk1qlDEyRnbsOGiATZkyhUEntFA0PT68Rc9o3alYEe7xcJ/6aLcKufbVuvQff5D7+FEHu3cCgzNArIZHE85M1SwySlIZh6nYuoEN7RM7YbUUCzKqysyjKWcOPqIiozxg40pnA0+sDlTRIH+vfq6eRuUnBX+h4dRsHyeX9t7hAB7z/lkJD7ahSo2RProNGa0CcsDPJnVk2x2DkoQ8gP/o/Oux3Hr21mHUtxQCiFgcdUlrzOXSiy4T5//GyJqxmPlDo85oFoZUSnFw5VEMuUwO8k5UOClfKwrR+v3J58fBRyJZ+K5wlzCju9g9oQcJ4Sgcx6S/V7kypM1yKcwoiW9S7j9LEueCcN6UwK/JF1xgNk1nMxNrzhU/G6cjchpI0LdxumcnswcJR/6fZiS
 j2RiCLhV
 ccb4lbosE1vwHVhmB4COO9BgPiE+BJT3d6RiJCjtZSUiHaDVC3tj5q+xsL7V/1I4Wm1FzxeKrTNzdlqIPgS1Y5LyBk7CFfCwVTUWMwLuriByJA5/lbxjCbb9dsO6qMes6HnlmTR2Z2W2DDy7mmKkcMTRPIDzg572ulSAVXLbKf4FRRfv6zvvqYG7A5tn2wsVX3AGqOCeuZUNUOTZ7wqQGqtCNJjTlPYfePZxuM4kN462WyxNbhAHC0XJE60QdJEnjzXJbms9JSKTeX3xnwHHarboChg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_quota_score() can trigger division by zero if the target value is
zero.  DAMON_LRU_SORT lets users set the target value for the hot memory
scheme via active_mem_bp parameter.  It avoids setting it as the target
value if the parameter value is zero.  However, it also sets the cold
memory scheme with a target value that is calculated as '10000 -
active_mem_bp + 2'.  Hence, if a user sets active_mem_bp 10002, the cold
memory scheme's quota goal target value can be zero.  As a result,
division by zero can be triggered.  Fix by returning an error when the
user tries to start DAMON with >10000 active_mem_bp parameter value.

It makes no sense to set active_mem_bp with 10002.  It also requires
module parameters write permission to reproduce the issue.  That said,
the consequence is quite bad.

One reliable way to reproduce the issue is like below:

    # cd /sys/module/damon_lru_sort/parameters
    # echo 1000 > wmarks_high
    # echo 995 > wmarks_mid
    # echo 0 > wmarks_low
    # echo 10002 > active_mem_bp
    # echo Y > enabled
    # dmesg -w
    [...]
    [  597.421247] Oops: divide error: 0000 [#1] SMP NOPTI
    [  597.428848] RIP: 0010:damos_quota_score+0x6f/0x480

This issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260801213028.5127-1-sj@kernel.org

Fixes: 40d98d31cd70 ("mm/damon/lru_sort: support active:inactive memory ratio based auto-tuning")
Cc: <stable@vger.kernel.org> # 7.0.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 7e077084cb03a..3920d5042f109 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -233,6 +233,8 @@ static int damon_lru_sort_add_quota_goals(struct damos *hot_scheme,
 
 	if (!active_mem_bp)
 		return 0;
+	if (10000 < active_mem_bp)
+		return -EINVAL;
 	goal = damos_new_quota_goal(DAMOS_QUOTA_ACTIVE_MEM_BP, active_mem_bp);
 	if (!goal)
 		return -ENOMEM;
-- 
2.47.3

