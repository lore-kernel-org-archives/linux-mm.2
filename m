Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E20CDCD342C
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 02:05:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E15C86B008A; Fri,  1 May 2026 22:05:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9EC46B008C; Fri,  1 May 2026 22:05:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8D8D6B0092; Fri,  1 May 2026 22:05:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0AEE6B008A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 22:05:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 73E4FC1BC2
	for <linux-mm@kvack.org>; Sat,  2 May 2026 02:05:18 +0000 (UTC)
X-FDA: 84720837516.17.B8E7DA5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id B70FB16000B
	for <linux-mm@kvack.org>; Sat,  2 May 2026 02:05:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ejtoxq0d;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777687516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OU4V8PfVkdWOxb7Mf6RaSY2rrctexF6dNqw3iMDrQ84=;
	b=6gu3ROim9C/hEg7L18LPRFvehXc6tvPT6fJR/ylTzwTCiTH7tYObcdK1Es1ibv0S27b6Bl
	goKCdC0mP0ucWG0YF2sLsEUfG+U1OBLnTQsCg/XOPZIhMNeN6C9pfF637NqRmA8ZmsyZ2+
	PEGInXYxFOqfYOcOz7QB/yOrGCXy2II=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ejtoxq0d;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777687516; a=rsa-sha256;
	cv=none;
	b=SJHyVSFjDS+m7koFqzrhpbqQgcw/tJCE5sA366jTcAgET8keitLrtgeHrPukLkWYKDl8/e
	Logz+9x1TW8IV3gIV0wnCqhe5iPsV4HaywAMnN8XjVj9R5vpwbbJSeTix35Ie2s/SBqtsd
	T2DeKnjG+Fm9gSduMRzHCCPVEyUgoFM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 735D0443D9;
	Sat,  2 May 2026 02:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259E3C2BCC7;
	Sat,  2 May 2026 02:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777687515;
	bh=zmdkpdSWqP8doKAHn9uOBEj3q+JEz8NGiE/WXdGr6Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ejtoxq0dEbQHrdgOUI/B+UpvvG9khRixX7Cbk2C/wzsQtGIgcfY77JjchiMCcZ+JR
	 Z5vBHkO+A/+OrB/QKrnR35mwCYVFC2rxPnU92Z8zruW46MF3l3kuHrdKgdJUQ1tzg6
	 BKHo5uh9hhkeQzLFy9ZDGY7C1XAdo1PV493MyhridiF/FMTqI2GaCiwM+hDkHvj1bQ
	 +Nl6NHm8msrlLH2HK/VBUx6fWIdP2kt66YgpNPf4LPF8bwClnaDKuxsWththf23oVk
	 kkdmz/abV5l5laXUpWuoxjRqGQWe2mHOwRL5jrtUBnprRcy43U92+bx39zGJ3DSn1J
	 IAVtz4+6VTTfQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/2] mm/damon/stat: add a parameter for reading kdamond pid
Date: Fri,  1 May 2026 19:05:03 -0700
Message-ID: <20260502020505.80822-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260502020505.80822-1-sj@kernel.org>
References: <20260502020505.80822-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B70FB16000B
X-Stat-Signature: 8egzurk5sijeaba69rgkjeu7pofwc7re
X-HE-Tag: 1777687516-700857
X-HE-Meta: U2FsdGVkX1/t+rOFGuO5pSm+PhwFd6p9ou0w+3l9mFJ/ZK2oMamS1JCPyVTntC0JEuaK+szXJFvav91wscHRH0wU9GVtygZzMMk8mbGoNHUn6H1XvSgdxHFltvh9MnbxkZ61WRg4hFCjzdNO1u2lZKpRZ0/6Y5qo8EMSFWKMH+8xfniKde+un4ujNW5L/KsfqyXKv0uzs1K8mwv2OH+DFasRnW+n+HO+jGQIxyXwlT54FJs2R3P7fP1xGXLfDQBTmf8HIf6/AliYmrqWzOU+O/92hRD6ntxGKEnmgOg/PocE21dApeFORxAM9gHLmmLeeINMVM7is2zR15vqsvCBEJqP3vMR8G7YcUgajPFZihQKMxoE9wYRWTd+7YwcgCoNRa2tLO45/LAGSmli5QRMjcsIjqyoMm5lUeabLoDNBiYS0Hf+I1zJkNjqnAqWuLxsdEe+o0wk2qiFKFimGpLcrmWshDjQxb2Tmk1Gna5lWkX5/2ajzWwbcv0rQdKGGlFv98+6g88i7HiiKs7LtkPebc8KaQHTJHaSpTmMI0bjLLhwMlpHC/YaJFWwzPZKNgHa4oW9/hrQN7EKRbJ13hqK5rIOrzFHGfXpym3ZuPMn0WgT0PFE5RZB9AmQkdtn3jWG8nanHL8HWibiYcNAPCF9KUKa8XW3l1o3W07cXNQUK94NLNIousHoJCHO3ikxWw+26A3Nf4goBlCROTSRrKonZCLA7Ld4pgtLRP/hD1kh7DpG2azqEJJJh8hj2AedNHCD8CkT7pmnUuA+hcvW9+7cLJeUmSg7uWz+Aqd7er9Brt7kOOj70OmAAkx+20DGRqF8GlP6aYy523JFMn6U0sQHP5zn6FgNMkV5I9vCHwadSDI3HiWowX4Y1wSJqyT/upPbCnkaU1J6PsOfkdD7leXFlUWSI/iYJEhMUIKhojuMMpoMjc3m07USOCgtz9tJrJZftumq1MlZCh4wzAPi5HX
 SCqViZol
 pjagjm9lZQPfVHxtHqirtJXop5nxWienBqvqXdQLIXeuK5Lxm5KuyknDD9nJxHGGiQYDDZXHdaev0Xnz/xsqbLGTOodFUwUPaG7sJv0KVJhA+NKumB+M8HQujeTId0gRKz/rwHB+Y8isbcvaUK9pxlxf8Xuv/ZyB4o1rwaNjlBv4bH9FVWl0blz/y8rNGiVGSbfYttRPqJxG5tt0mADTa/x9FQLE0D3wNVkmiUK5b1cGTj48=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Knowing the pid of the kdamonds can help user-space management including
monitoring of DAMON's system resource consumption.  To make it easier,
DAMON_SYSFS, DAMON_RECLAIM and DAMON_LRU_SORT provide the pid
information.  DAMON_STAT is not providing it, though.  Expose the pid of
DAMON_STAT kdamond via a new read-only module parameter, namely
kdamond_pid.  This also makes DAMON modules usage more standardized,
because DAMON_RECLAIM and DAMON_LRU_SORT also provide the information
via their read-only parameters of the same name.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/stat.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index f4d3203e92639..0e14f5bb8f75d 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -266,6 +266,45 @@ static int damon_stat_enabled_load(char *buffer, const struct kernel_param *kp)
 	return sprintf(buffer, "%c\n", damon_stat_enabled() ? 'Y' : 'N');
 }
 
+static int damon_stat_kdamond_pid_store(
+		const char *val, const struct kernel_param *kp)
+{
+	/*
+	 * kdamond_pid is read-only, but kernel command line could write it.
+	 * Do nothing here.
+	 */
+	return 0;
+}
+
+static int damon_stat_kdamond_pid_load(
+		char *buffer, const struct kernel_param *kp)
+{
+	int pid;
+
+	if (!damon_stat_context) {
+		pid = -1;
+	} else {
+		pid = damon_kdamond_pid(damon_stat_context);
+		if (pid < 1)
+			pid = -1;
+	}
+	return sprintf(buffer, "%d\n", pid);
+}
+
+static const struct kernel_param_ops kdamond_pid_param_ops = {
+	.set = damon_stat_kdamond_pid_store,
+	.get = damon_stat_kdamond_pid_load,
+};
+
+/*
+ * PID of the DAMON thread
+ *
+ * If DAMON_STAT is enabled, this becomes the PID of the worker thread.
+ * Else, -1.
+ */
+module_param_cb(kdamond_pid, &kdamond_pid_param_ops, NULL, 0400);
+MODULE_PARM_DESC(kdamond_pid, "pid of the kdamond");
+
 static int __init damon_stat_init(void)
 {
 	int err = 0;
-- 
2.47.3

