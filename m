Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1A89606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 02:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bz/yjurB
Received: by kanga.kvack.org (Postfix)
	id 83B206B00EF; Mon, 16 Nov 2026 21:51:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EAE66B05B1; Mon, 16 Nov 2026 21:51:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 701F06B05B2; Mon, 16 Nov 2026 21:51:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4FAFF6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:51:54 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3A5AC02F6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:51:53 +0000 (UTC)
X-FDA: 85443086106.03.9AF57F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5C55540009
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:51:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Bz/yjurB";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794883912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YT7dJBTJ5NpMKHm7zef0UK+gnv6Fb8K6ANn5jOwpk54=;
	b=3YCxymnysKQeZGv2lbRKb2mFvArAHrkfPnpLL9YYIAB44xcjhm8ZCoQTNwPa05gOxxlfLV
	qVErlTzQRhKiTImoXjcMwSAPM9I902Kd9P/4DnrRYoI/QLkQnP3M+Hf6ynhMNpgBxzo0Ii
	RABsOsr8EL84NItYVjX3tRi3UEydLws=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Bz/yjurB";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794883912;
	b=OBjHp1UmHbhp1N2KLdQKJdNwro3XnE4OeJw+lB6ZhS+D1FZ1qXosY4+d1oc+VhEZ7P6Gd7
	A/RjJUz+mZnEGndojcxo4iosaxzEWnh+GSKP5uIW8n4HSMzOYIKj2xXxO5us9gHwQc6ivA
	lOgelmqitUHrxe2y3XZtMHW3xZV+0h4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CF1B9628A3;
	Tue, 17 Nov 2026 02:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593DA1F000C4;
	Tue, 17 Nov 2026 02:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794883911;
	bh=YT7dJBTJ5NpMKHm7zef0UK+gnv6Fb8K6ANn5jOwpk54=;
	h=From:To:Cc:Subject:Date;
	b=Bz/yjurB2tXqFCox6lw5FYMKZMY3cqFANa75FHh/q5cop5PzxLyd5qXy4WKkeJ6Ik
	 MiYPqVCQdY8DMWHxoSdnjLKIcVkI9pUxxIciiQpKHZXlAi3snx3nqo6VN+tVZkACqw
	 Bh7OGQOnn2BEQPLcOVEPa3Bcw2FytVQLi0QkjTOO7nTuiClUQha4jpYRULqh3GxiH/
	 fcZUTG9zSNWamHOCEYdIFH6UuebMoJza3xiZGm76zub/V6bf4jFQ3wNLJsDXCpvyjW
	 GKpTyAJtvlX3XVdLyonEeK6VHVBnMQmjKNwbf4349yk3cjBg9EFm2EslKo8xSmKYKr
	 2RlWqddR3yi4g==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.12.y] mm/damon/reclaim: use parameter context correctly
Date: Mon, 16 Nov 2026 18:51:42 -0800
Message-ID: <20261117025144.117100-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5C55540009
X-Stat-Signature: 6zrwpsxbetmm16gutw6y5ozrapqjrwmi
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794883912-942620
X-HE-Meta: U2FsdGVkX18xPN4oH5xWplcGAxztJ1SAnoitW8Kp+AnQCRP7ra3jz6OcvYMzb4Q5xnQsrWQbRo3SJzdYFVFYM5vsGVVuKOuMDnvtpQ6Cu7ePPZNQc5RaeQWK56sWn5smMhSKU3iEmd0SFZTfg+2g/TYboFcomzX8h/EBPUUTQKsPRcn/cHQJqX7TjzNrATBr8kzKhxKRsw8pElna+USWPu77Mg+gelEcdtHpjeI9TGcj6rdYm4+eJrz6YLo36DRQcVFU6WUnAisWwpuhTzu/lsnTJK2doIsv5/vyEfRgj8j7YuT5NUP05KJRK/VMfTkhMIljPKReMgOhr6yaeyTMDMv42tI5mCIoWnMjdHOcfy+PmUlVi3ziSpFxrigNLG+fFMxpxWQqfSf7x9CWRe4iD+Cja9U0OTk+fglS1z2lHStZ//w28gtwef2mVbD8futDVDAL1kdHyA8ebgw47Lis1y06xXMHAkcKqF248yOeQOqxsogRxddfD9LUcJ6kN6g7T/ylnBqhiUYsM08zwxqNBq9B6aHJiFgMXIbz8+gv+LKFZzXpDLLi5VXMVvW67Bi0ll0wu1nipXuMNzwWh8ZTHr5ZrDCysi45FljeuJ03QxUK2dqipH48/yD1ZDLP7+4cqHbMHNzGw1nfu6qvJDGQJoN93XBVexN7mUAfyFl46hky4DyDjfVtKrm95pZ9y7VVTlUCmajsMt7ybl2pB3IIm9vGLqhVVKShMrKrbzFJ4CY6q06MOBUHGerZMC4CLM/tWFeEtjfGwKU8nUvhIVnwt5QTxFsRMlrDljuMQXwcXqOKSWuILL1AkfikRbiEcdF/K6uzZMZS3AlHNAdQRVfj4F4PCVAbVT4KZ8NvexIlZARjeXGZBzaZNO/F5L+6QEZIWvJblpbIf8HYFRhPh6nl7ultH/t2+Dvd7qgZVYTnJN25foYSw7ijNZ/rnXAdgxDwwZ3BsX9c7YlCNkA+eoH
 QWAqBtA9
 lLqo4PYiCRPVaMjeA/83s2Uv+OOM8ro086pxuR/ZR9Pw5G4l8ocLrQZS5Dbubeqqf+L96Z1iZ0ayzN4WYxtNY6Spi5CHKsH4PoxocOY16gyg96C8X5qA/qFKh/Log3PmmhcavcAat3WcqhlNcDr0V+c+aiFvOQ5DkbGhqb8/MHi/Vsp+0vp3rS1Sc5d1b3vbFdFmYrJv/lYW3aTOB3u5m9TG9gDisL0ocy+SFqTzlhcqsS+E9YJXkYc02Cjor72a8ErusYFaVoLmussjqP2TPwU3lNJmKzhJn81ZlzfKBv80QJPOzKVndY9Iizw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: SeongJae Park <sj@kernel.org>

damon_reclaim_apply_parameters() allocates a new DAMON context, stages
user-specified DAMON parameters on it, and commits to running DAMON
context at once, using damon_commit_ctx().  The code is mistakenly
over-writing the monitoring attributes and the reclaim scheme on the
running context.  It is not causing a real problem for monitoring
attributes, but the scheme overwriting can remove scheme's internal status
such as charged quota.  Fix the wrong use of the parameter context.

Link: https://lkml.kernel.org/r/20250706193207.39810-7-sj@kernel.org
Fixes: 11ddcfc257a3 ("mm/damon/reclaim: use damon_commit_ctx()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit fed48693bdfeca666f7536ba88a05e9a4e5523b6)
Signed-off-by: SJ Park <sj@kernel.org>
---
Mark Polyakov found [1] this patch is missed in 6.12.y and causing an
issue.

[1] https://lore.kernel.org/CAA5JH2yO-gw1gn_172hv0YWFfQpkXz915a=uoVH+e49P_D8-+Q@mail.gmail.com

 mm/damon/reclaim.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 9df096218beb7..254d84166131f 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -190,7 +190,7 @@ static int damon_reclaim_apply_parameters(void)
 		goto out;
 	}
 
-	err = damon_set_attrs(ctx, &damon_reclaim_mon_attrs);
+	err = damon_set_attrs(param_ctx, &damon_reclaim_mon_attrs);
 	if (err)
 		goto out;
 
@@ -198,7 +198,7 @@ static int damon_reclaim_apply_parameters(void)
 	scheme = damon_reclaim_new_scheme();
 	if (!scheme)
 		goto out;
-	damon_set_schemes(ctx, &scheme, 1);
+	damon_set_schemes(param_ctx, &scheme, 1);
 
 	if (quota_mem_pressure_us) {
 		goal = damos_new_quota_goal(DAMOS_QUOTA_SOME_MEM_PSI_US,

base-commit: 8ea1fd6d2beedbc49a917cdccea09a0354b64d5f
-- 
2.47.3

