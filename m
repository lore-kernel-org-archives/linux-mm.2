Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7B5AFF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 17:36:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A41D6B0005; Sun, 26 Apr 2026 13:36:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 455876B008A; Sun, 26 Apr 2026 13:36:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36B246B008C; Sun, 26 Apr 2026 13:36:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 257576B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 13:36:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E055F1A0566
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:36:36 +0000 (UTC)
X-FDA: 84701411592.28.06835BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 56815A0002
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 17:36:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XU6vj17C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777224995; a=rsa-sha256;
	cv=none;
	b=akdOt3MmMLXEe7er51DITnt12EZbqtM/yWyMvaRsI7KEejq+V4Y8qmWZlIm2Ix8gIblO3u
	PkzuQA3sdCTE7/R4j+7JCk2yi19p1b0+W9K4nNXreAImbBuii43mtW1pgEceFv1wSgLCUt
	87uLQzdxCaK0++We16Mc1ksADzplwok=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XU6vj17C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777224995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NrZrtE/J2BWW8C2uQkpByEhDkLRmo2XlLkvDqdUFb/Y=;
	b=Q4akH/st2tF1GZEX2N4J/5dp3PX7M/gtqDaidVIU9EKgJIjav5MEJxOicAlKZ/RUKWobO9
	lYQqlXwdtUbmEuk08nE0nCk5iQVpLRHiICDyOg3ng1XlJ6b5lCM2CUHcIXFp4J7KItiswd
	GxpYNaQwlADlZ8o8vRE9v79+ppHL/yM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 340A740830;
	Sun, 26 Apr 2026 17:36:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D409DC2BCAF;
	Sun, 26 Apr 2026 17:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777224994;
	bh=KvSnvOhyWjleirQU9z5e2xFONCdcqdSmhG+4jkdX/YU=;
	h=From:To:Cc:Subject:Date:From;
	b=XU6vj17CgcR2KLRsj+KMMZ6pRz/MMIqmQOMrQgFe3KscTBSoSVL9eYF0w+xg2g6sc
	 SvJQGqCEoYJuVGL3mrOf0AZZuRQ76jBixxLoqBmkndxxdSOgmdX5LHcGpHeqrufgc2
	 h7UitJfkqGzTYtQR147S9JSEhD26GtPfFWQ+XbxLl5sp5ir2E2hujgoWvkYIDxo0uZ
	 21/ni0TpcVRd7fk8xdbXG2+yG5wLSwDgRDY/TDHbYVibANzffV3nSJSGRCUFsN26Nl
	 NQdtLMghgf8O+Kb16POFvumzXVisB0RDQaO7skwAbHm0MDqUmVl4GOkbI84nfdXP4E
	 Z4gdQbCNFUXvA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 3 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/damon/sysfs-schemes: call missing mem_cgroup_iter_break()
Date: Sun, 26 Apr 2026 10:36:12 -0700
Message-ID: <20260426173625.86521-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hnegodt54oszdocfwf14xbfagtq4tk51
X-Rspam-User: 
X-Rspamd-Queue-Id: 56815A0002
X-Rspamd-Server: rspam07
X-HE-Tag: 1777224995-605159
X-HE-Meta: U2FsdGVkX18GUhv9E0grP6AdyKWlACJsKGNoteMxbLmUedYFLZaWfW8QYSCl2lj+wTnWNZWd2FOaZmez7ziq+qzAm9T7qmLksCAssFU0/cakUZZ2WU2v9/6Nte4Jv8R3tX+IBQH+oItddnOuOHSDHIX7U7DPFnHi9LsVY7wwNKDq/cHMJtgyJHx6uqJPm+nq4J8+osA0R/fMlVsToPvtW3s/5TvzX4gPYuMNHtYWhz0+F3OBp/OY0XusNYMz/ppNrZDfbE5bxs3lejUdD8SSr2PNZptwksua+hweFZ8N/ESmx4YoXHBLYnprO0797eUuvngcP4CjmZDpIgeunOZclxuHWhoM4yVmZ+O5Vno04lUknhdBzpivXRDOEVyyjPvd5B3ANDKX8DASWsJCqgYKuShp0KstDwI/GGhKPMJTAbqIGm9BJ4s+1kZDLr+6zIntXV9fSb9wDXst/i26fiYaF1ZhRye3ygrRAXIfkF7qyqIkbZ2IMCQRnjO9sv5/cWCy6aScvIyzZLy7GIaTt0f0m6IZmMfJWTq06cXKOev/DT7QJhB/sznNyDudGYtqQFOsp10f3DXOwVdLVyNeIkSmNJT7OypuzaUGw13ekChyrbLZnjGNzie/m9ul8SrpawZCgq3NfGUe9On8qbjPOO9f0iVamgM1X/YhXTS146ezMtBR4YMxduwtGv1vvmuwcNt1qEPordYmSGMeEAlac0XXnGns+dfbWOOJGuyI7eLO9g3VGbY2G8oVjg7RJGZdWKVy1YOXlqV48aXeqzBIopoWCf1YKJ16ikE0qAnA+exDlFBrsi0WOCAcEfQGPqORzWZsqPyKYY+4hzOGFJCi9DY+vM/3AzX52Ilvepl+lRX8TPk9DknNAXhNvn5Ruj81NTnBOO+T6feU9W2STinczdkTRMFLNjpxmJHnImtTZjWJ4MR0ho1Gfr4ksq6jgn+FWrTQwXFv2yZWrqiOO80EWxB
 9pkt3HEj
 +3kdl2nUjkctyXhBwtA2Qvpo4LHPNLl4zsnU+IEqihgF1yFy75HGyAz398PcehH0DYcWbe2it04RW3Vv2J4AOS9YcY0WkIlgljEieNpB6Fb9LYK0H/xSigabWVOtGCpX9yb4Y2FJBm8uGb3LOL4yXHHTVafwrvrEZTzjfIcDuDdcr1a+igIXZL0uoA+1F+5LdnMYDUtB0dx9OvVgH9QioAV//h1l/R7AKhzB12pfBuh3EuxKfJfgIYlpbqDZesInYYKVkuh34G/obdRmbfj8T4zatYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_memcg_path_to_id() breaks mem_cgroup_iter() loop without
calling mem_cgroup_iter_break().  This leaks the cgroup reference.  Fix
the issue by calling mem_cgroup_iter_break() before the break.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260423004148.74722-1-sj@kernel.org

Fixes: 29cbb9a13f05 ("mm/damon/sysfs-schemes: implement scheme filters")
Cc: <stable@vger.kernel.org> # 6.3.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from RFC
- rfc: https://lore.kernel.org/20260425202446.108095-1-sj@kernel.org
- Rebase to latest mm-new.

 mm/damon/sysfs-schemes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 245d63808411a..04746cbb33272 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2594,6 +2594,7 @@ static int damon_sysfs_memcg_path_to_id(char *memcg_path, u64 *id)
 		if (damon_sysfs_memcg_path_eq(memcg, path, memcg_path)) {
 			*id = mem_cgroup_id(memcg);
 			found = true;
+			mem_cgroup_iter_break(NULL, memcg);
 			break;
 		}
 	}

base-commit: 63037c6230622d20536f4327a162b82cd59fb483
-- 
2.47.3

