Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF2FFCDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 01:17:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3323B6B008C; Mon, 22 Jun 2026 21:17:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E2346B0092; Mon, 22 Jun 2026 21:17:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 220D26B0093; Mon, 22 Jun 2026 21:17:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D95416B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 21:17:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CF16166C86
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:17:06 +0000 (UTC)
X-FDA: 84909413652.04.3729472
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id ADC60140007
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:17:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eV/LLi9a";
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782177424;
	b=Jg4Y4Kk6/pOIDnXmDPfz9k7YLMQBz8h9EfA7avGB6Mc0jC+K++d58flaEe/F/xdJOZE30q
	jAG3SpTa553IZM1Mptd2Rv/BAZscv+Da4dTAKt55Bj6x8Lf/nFQCSJ0mhEjKw/9XBpbnMy
	1H0CjlHFgrsLrNB8YIL6d6KUCeJn2qM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782177424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uNO+RQmUCKpyh3OJUwnU0KKiT0g7xqCEn/1y3Eui4M4=;
	b=C9jfdbl3CMirTaYjhJ060Q9nXYOsYXmZ40THrJ41lhshSUX9i6ZEfWNXrhm3xlwleqe/lE
	hjDHXRGKNUDbCl+h98p0ZVlHiqudzp/CI6LUUrj/bVmZxUVvS1Ck7a2C69owf+K7oeymUi
	WWKajamyWpbfGZVrR8SR2iyKOBp1vfc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eV/LLi9a";
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8DD31406B0;
	Tue, 23 Jun 2026 01:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B141F000E9;
	Tue, 23 Jun 2026 01:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782177423;
	bh=uNO+RQmUCKpyh3OJUwnU0KKiT0g7xqCEn/1y3Eui4M4=;
	h=From:To:Cc:Subject:Date;
	b=eV/LLi9aYqGVT3NMiY/2Sw2taMBtu2M9N8g7QZ10iOebp3xP2JdyJAZhQsvvjVDEf
	 gHce/8tStbVSjqGLUjJ/tpFZhu9hgWr5ucijcRBCxK2Qevkjt3dHZlozXuzAdItLDx
	 UJLrN0u/pWSRqCXvQDu5JVKNNP3V91HgGZXCfyD1BN7lmOaP7zhauhfZHGEVCnZ9Eb
	 teiX5rlJIMiYa8iZA/a5DnnziqAenk1EkYJntrkY/wVd4OtM8+wxYMw5SZcyb+An1c
	 vjgRu7ifY3fKkU8OZTti41WbpgzWZ52YL0cm8ZAjwEAPvsqikXhuSUuvLY+wgUYuaL
	 oa+vRpYI18u2Q==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 16 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3] mm/damon/ops-common: handle extreme intervals in damon_hot_score()
Date: Mon, 22 Jun 2026 18:16:51 -0700
Message-ID: <20260623011652.1354-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: ADC60140007
X-Stat-Signature: s74afz3y3493omj7o7jdcde1tboyhymh
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782177424-776044
X-HE-Meta: U2FsdGVkX1+jPZKXJwBZgToUQX8CgdAU8ZwtvEDJ9sFobop95xyCRAWK9KhjGf4nqZi+TlzByVzgHX/Ag6rwMrE3QjIr+AqYJVVd1a4Dl1iyTZIbE9gqgXtxKGZLk//hB+n2yFAyLBh18abifs6431SoXCdhnJhevXpkX4DSr1uPa5q4TApiz2tuvibh9Ztm8IYZMSsjOC2Tpr2ac6pVOxNfOFRqgiXJR7x9QcX5X+hijAhMte0Xt9eRFZRON70da0bexO+gXP46RCxkJ4mBHC64vri7090vpFMZIZQSwX+zUvYwxDmI9d4WXNwhEGIPvLsf3ejV+PRz6YQM5Cdg630xuHiyP6vgOB6v4WdwQXqMj3rSk0ASVU2CpOb7dJlJd57MwxHNr4/5JMOdXXrc+2OH22hEtKZtAagwWS/lQiw56wdjZ7p0dqpShb4eZjKT6w5V0++87ehWGj737u+tVd7FPRW6ZzCRH3Ansk/uoun/W8LjxkzpY+Dz2BODcVixaoSKN4n+XVNFd+jxFfgTOgbVsKKMh+irc7/R+S7Qmq+kU78xq2FQZ4QCIbPffa8l1VtzDguEemOovQPH1uElk11PzzgH/3yKAqEN4rme6epfcP4/FhVF5K6xNZhOBbFOQ1qSzCxw6xibSRVWdWIoP/eWfSooMtkB95mAEWnXY6Tthb8WnVmCDMMyxc6I9/r0ZbKhx7LEl7a2kuM2NPw8i1cdF8LtxuVnj3QUdfp0kszGUbwi3CkumVeU7bdVPRp4467MiGij+W9gKzC5JCWnahG930OmCY683QVAbPSN9J6ynu2gHLsxoZUPyjbwJEPLDJm72d2NGHUOramHhUaOq0VOTd7gQqUu57mHi+7M5An2vjNsHw+EPUg9EFzbHQLqB8EiwAKV6AkxEsHvGMnPfiOau9jZynaomxtqoqlTFwvj5CTTcLYyJQ78w7OoCZ5IfPQOPGCf5ssceTGEggD
 IfAXs9ng
 YQqQ0HFgRaZhdOy4RQP8RNdz2USSOwftxq6EsPXrxJ6NptAc1/88TquDHXbNnngp+rZXFFoD48WstWrskxn8e8+TlUBXooVkEwpdNUo/FOT3mB63RODIW4ex5N8CNvqSPCl4eqVIG49R756bv43kKEkVk71AiQ5xK5EApLCzAH9TIFnt46IOQkH9xU3jobrSAQ/ISSfhpahGiUOgl7FLRCP9CDtnkIZp56Gt63JTRUEbGj0gKjw+ULAlNm+ISY2oZtbz1wh9Z3yKIAFtrf2GIWjS/HQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix three issues in damon_hot_score() that comes from wrong handling of
extreme (zero or too high) monitoring intervals user setup.

When the user sets sampling interval zero, damon_max_nr_accesses(),
which  is called from damon_hot_score(), causes a divide-by-zero.
Needless to say, it is a problem.

When the user sets the aggregation interval zero, the function returns
zero.  It is wrong, since the real maximum nr_acceses in the setup
should be one.  Worse yet, it can cause another divide-by-zero from its
caller, damon_hot_score(), since it uses damon_max_nr_accesses() return
value as a denominator.

When the user sets the aggregation interval very high, damon_hot_score()
could return a value out of [0, DAMOS_MAX_SCORE] range.  Since the
return value is used as an index to the regions_score_histogram array,
which is DAMOS_MAX_SCORE+1 size, it causes out of bounds array access.

The issues can be relatively easily reproduced like below.  The sysfs
write permission is required, though.

    # ./damo start --damos_action lru_prio --damos_quota_space 100M \
            --damos_quota_interval 1s
    # cd /sys/kernel/mm/damon/admin/kdamonds/0
    # echo 0 > contexts/0/monitoring_attrs/intervals/sample_us
    # echo 0 > contexts/0/monitoring_attrs/intervals/aggr_us
    # echo commit > state
    # dmesg
    [...]
    [  131.329762] Oops: divide error: 0000 [#1] SMP NOPTI
    [...]
    [  131.336089] RIP: 0010:damon_hot_score+0x27/0xd0
    [...]

Fix the divide-by-zero intervals problems by explicitly handling the
zero intervals in damon_max_nr_accesses().  Fix the out-of-bound array
access by applying [0, DAMOS_MAX_SCORE] bounds before returning from
damon_hot_score().

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260619202459.145010-1-sj@kernel.org

Fixes: 198f0f4c58b9 ("mm/damon/vaddr,paddr: support pageout prioritization")
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from RFC v1.2
- RFC v1.2: https://lore.kernel.org/20260622141027.29145-1-sj@kernel.org
- Drop patch 2 and make patch 1 fixes all damon_hot_score() problems.
Changes from v1
- v1: https://lore.kernel.org/20260621154808.86431-1-sj@kernel.org
- Add out-of-bound array access bug fix as patch 2.
- Add the RFC tag again.
Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260620171413.89555-1-sj@kernel.org
- Wordsmith commit message.
- Drop RFC tag.
Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260619205144.150664-1-sj@kernel.org
- Handle zero aggr_interval case.

 include/linux/damon.h | 8 ++++++--
 mm/damon/ops-common.c | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 64d75c78f4df4..02ac34537df9a 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1066,9 +1066,13 @@ static inline bool damon_target_has_pid(const struct damon_ctx *ctx)
 
 static inline unsigned int damon_max_nr_accesses(const struct damon_attrs *attrs)
 {
-	/* {aggr,sample}_interval are unsigned long, hence could overflow */
-	return min(attrs->aggr_interval / attrs->sample_interval,
+	unsigned long sample_interval;
+	unsigned long max_nr_accesses;
+
+	sample_interval = attrs->sample_interval ? : 1;
+	max_nr_accesses = min(attrs->aggr_interval / sample_interval,
 			(unsigned long)UINT_MAX);
+	return max_nr_accesses ? : 1;
 }
 
 
diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 5c93ef2bb8a97..d1842e2b00ef8 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -143,6 +143,7 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 	 * Transform it to fit in [0, DAMOS_MAX_SCORE]
 	 */
 	hotness = hotness * DAMOS_MAX_SCORE / DAMON_MAX_SUBSCORE;
+	hotness = max(min(hotness, DAMOS_MAX_SCORE), 0);
 
 	return hotness;
 }

base-commit: 0f0046f6171e76f3dba376cc13ace04d654bf372
-- 
2.47.3

