Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01982606A31E
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 20:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PJZKHTKg
Received: by kanga.kvack.org (Postfix)
	id AD05A6B05B4; Sat, 31 Oct 2026 16:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A59966B05B7; Sat, 31 Oct 2026 16:26:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9217A6B05B6; Sat, 31 Oct 2026 16:26:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DA2C6B05B5
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 16:26:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF48B1C43EC
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:26:25 +0000 (UTC)
X-FDA: 85384053930.09.5C04F91
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4D0DA40003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:26:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PJZKHTKg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793478384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kuii1OxTBCJKn/aKUCi3+2COKzMgGJ8Y558hfckwvWc=;
	b=mmy3RaEvhrct6UaBhKTbR/ZtdMfObphIGx7rptcrXWBXzjzXJj4CBu+5rhs0+q3p/BZWQc
	lJ1fTqgqqPj8nORSmA3z0YavC6zWd8YezUtuuWeaj3K+fYlHowf4bNsKQzd3xLREHKLV3r
	/Sg1jxp4uXnmwRsgGcpDxZ+tvZsFwus=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PJZKHTKg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793478384;
	b=MrBcviZm6nP3u0+xV3uJJA2ujAlVXgQpgg6C1nL5QBq6aqw8anuhyNwkaKHa9VfnSOkAQF
	j47WYhi6g+OwMoUWub2m9S1uWtuR2P81ughrO6D8tpAT+XPuiBx/9kYl0PJSa0zb206J8M
	e3A8ReiP2kN36l62ZqHdddxY+dS89lU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A4A7243EDF;
	Sat, 31 Oct 2026 20:26:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6276F1F000C1;
	Sat, 31 Oct 2026 20:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793478383;
	bh=kuii1OxTBCJKn/aKUCi3+2COKzMgGJ8Y558hfckwvWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PJZKHTKgxkFAm6c93xDqAvoQwjMN6iFhyBgIc/AWNrJTBMV5ToxMdx0C1WvtvY6yO
	 tiHmG/kp2qocNcaEp8x1xQkKpseGrUEoAWEq7x4wgh19j3R6ytAer6OQVSpACxluQC
	 JhuAm2J8WUnSAJ7vLpPNg/aG2ZX5yumCQGfzKLT8mNDS+bqZdtX4hLJV3YS0cXtFzj
	 L7Irvp3FD/jqqfaklw6jGp67En4y/OsTbXkd1i4Gt7NslSqughMwRiYUCj8BKW7uXj
	 Nmvnajxn45i1srr5n0MleeHWJSOUtiGHBY98uYJpo9X7W3oJOSRy8IMEz3wTy9G/nw
	 K+jL1++CPZ1Lg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 4/6] mm/damon/sysfs-schemes: drop redundant and racy zero target_value check
Date: Sat, 31 Oct 2026 13:26:11 -0700
Message-ID: <20261031202614.96036-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261031202614.96036-1-sj@kernel.org>
References: <20261031202614.96036-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4D0DA40003
X-Rspam-User: 
X-Stat-Signature: btkahzcixccd1m5jqejw3ow8x4m7as7y
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793478384-26786
X-HE-Meta: U2FsdGVkX18RyeJbfBp84pwgGVtvowBj7Jc1L6VzREitB+Q/ywKAVCHkHcfMKKXVHxuwtQzJ+wQsC81olQZGn3IPaY6IFHKZK3p/4Gs9yD4pjWRYhZ1xJe9zz6H37alWk8c40C3RzDW8wRV+QIfvisCH6Q/IEiowJKvEy0bvWtGN4xIl/e+9jDw/eaAdgzErKBGPkJBPi7GnwQDrCPfp9v5hdWfjw1hWWrewdmh4Gzk0YUUHFEjbYpRr3BV0pdh/aFOIDuSxRGl0j1WfDOi9foQT4dQM7nzk+xQR8C7/oe7vMZW98RaO9YKGYtQ8LXDVjaESp33YQgDMcM5Db9Kb5JmnvH8sT43+cIgnsBZuKQkbnAgak1FR5nXnoc2MxdyY399cBNYpl+3Rgv66vjZVSQ9Ip67IoCLaGuxm6brzpmtN3vlUtIz6suyqLW83g2isC+k2b4CUwf9//hwrS1ISHjXLBch4EAqd72TCW89v5IxtDl4ARnNtVgH7Kd+kViV8Xr7gSuRlmsuYFaCZ9ne6bTg3bOijNYXydoF2c2N6CFlZraBGrw43TWMA+trZKFkXjc4KEwM9uHQAbNDtM5DaUr6urmJqNXeYRTaPrdprEB/PTLWUJWT15wSikzTkUXcH/WmEAf4z9AnwQL4CSwvkW59kMrO6Q3wMnT2DqAilY8Wnt7mqo3feI6f+bFsYtVqzaR4HlTHwIbwxZ8EcL+01C61JvHefm2201SIbd6Cb0D6JS6iLKlZJPviXCTLPvGmyeYGmySzaprvUqW6Nf5PZb1P+lB3M3Leo7pHVwc8l4TopUO4HRE0u1cLF0il98T4OzpBw+T7sLq120/Q5oV2efugqMYkY26ZLiuj0TnEDU/BahavCK60ilEQaC5oRIBRpYx5cONwuzmKVsfjU+gKVvHYNfwcc1J5dCRsvLcIkALgW9SGLWt3ZMOpT3Z0Nl2W8EM1lo4udFC3dqEqvWk6
 IGAK/OEt
 IXOPHbKaEKRuYtezdebR/ux9dcA8EhU1V7eXu0JmyXgoUHK4nl+AE9qrZp518YSFin+0aigH5uwWaqxCfrh6vzejl80k7CUNak7tmwAOgmGagdcSDCVlxMjPlClYpcHeciuZ8mCe9v/rymxiGIDyvMXupAgMMAgFWjeB9e+CFeQEssLS/kZiYQPucFRskU2zXwrukkiJNqUyggDT40oIJRx6jrgtHJic6ioeQGr3k/i+ik9AAd/jlECQ2Tf1G3/t2bp3MmzFKxzQgXha3RSDkjKTHpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMON sysfs interface disallowed zero target_value because it could
result in divide-by-zero in damos_quota_store().  Because similar checks
were duplicated to other DAMON API callers, a patch series that starts
with commit 610c4438fb66 ("mm/damon/core: error
damos_commit_quota_goal() for zero target_value") added a same check in
the core layer central parameters, and dropped redundant checks in
DAMON_LRU_SORT and DAMON_SAMPLIE_MTIER.  It forgot to drop that in the
DAMON sysfs interface.

Now the zero target_value check in DAMON sysfs interface is only
redundant.  Further, it has a time-of-check to time-of-use (toctou) race
with target_value_store().  It can confuse readers to believe [1] the
division-by-zero can still happen.  Drop the redundant and racy check.

[1] https://lore.kernel.org/20261021005234.94107-1-sj@kernel.org

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 637f1bd0c950b..38efdc258ef3f 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2898,9 +2898,6 @@ static int damos_sysfs_add_quota_score(
 		struct damos_sysfs_quota_goal *sysfs_goal =
 			sysfs_goals->goals_arr[i];
 
-		if (!sysfs_goal->target_value)
-			continue;
-
 		goal = damos_new_quota_goal(sysfs_goal->metric,
 				sysfs_goal->complement,
 				sysfs_goal->target_value);
-- 
2.47.3

