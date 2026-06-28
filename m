Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C95EC43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 22:01:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B414F6B00AB; Sun, 28 Jun 2026 18:01:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACB526B00AE; Sun, 28 Jun 2026 18:01:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A83B6B00AF; Sun, 28 Jun 2026 18:01:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 636176B00AB
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 18:01:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DF5E3167D03
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:01:31 +0000 (UTC)
X-FDA: 84930693582.29.41C22A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 537D5140009
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:01:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hYkzKfma;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782684090;
	b=v2l84VMiYx3gGOl2RBNzDcZiIcgYcpC4QFdVVW8IMmhs4oyKFoiaZ1VME86pddEIKjA0Wo
	duV0qFyeniAMjRuxilV+WlUoImXPV1DP64D3S35Y1gnTsf1dRVUC1BFwYcqJPmEqj5f19N
	tQo1UDKtvdHrL1eQ4PtPNJHcq5Z5Msc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782684090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2uBHDdQtU7p9MN0ZSWr3YOPnVjS1vyYPgmIElFEJHkw=;
	b=ASK3o50nsSgRp1wXLtpBbSWnBx7zzSj+1H6bG8ts0I+dWks6fBQgFuqYKH2ALXDMxnGzYp
	bosX1AVpfMuoP1SDe67S4l/Dkzfze3dzLyEYXYWTT54l1TtlfkK2fUsdPvnvKHHVUkUjps
	l1fMk84RLcvLkICzrLnhf/Xczvh4ugA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hYkzKfma;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F2CA43A62;
	Sun, 28 Jun 2026 22:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1B71F00A3E;
	Sun, 28 Jun 2026 22:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782684089;
	bh=2uBHDdQtU7p9MN0ZSWr3YOPnVjS1vyYPgmIElFEJHkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hYkzKfma/az9hJtX3o8fslYCyrTjH4g5+2Nnb3gDweQsi3S4IKNMKIOqPMptjl90v
	 Tn9VAD502HeVg1HCPsQ9DBKcch9Z/j5Y9NcNQ6jWgdqUWcFgnNeuegFxnCk6ptexnZ
	 XfIVh8EN9XgVwXwOLx+/c/CCAuHsZe2seA+NMHxc+UJDwfabGinvW5TsJRoculbuQ+
	 rcjQRE6wzGgN+TQLeoqTKPTXLoaSVeAAS1aUOCYMzVPYFzyQjPi3K6SyTvE3hDGHuU
	 XiXr4FG6aUC0idRqvIa1soNF9mLO5uV0wV66+H3TvM1hHcqfkWwiutY7GiiDZ6z/8g
	 iXUfF3tAummQg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 09/11] mm/damon/sysfs: kobject_del() probe filter dirs
Date: Sun, 28 Jun 2026 15:01:18 -0700
Message-ID: <20260628220121.97360-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260628220121.97360-1-sj@kernel.org>
References: <20260628220121.97360-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hmks3ddr6uz41fgu18q4gg8ig8c9rz1k
X-Rspam-User: 
X-Rspamd-Queue-Id: 537D5140009
X-Rspamd-Server: rspam02
X-HE-Tag: 1782684090-737459
X-HE-Meta: U2FsdGVkX1/7EHiiAUrRznkOToi5kV7AlnSeKHJxoQ9gJTVEGgKis8g4eju6dHM0fVtN92PAlrwM0xmK2rqMU7mwAP4gl/o6i6PqPeQ1qBPbliCPw0FcqMyGxiH4w7r4NJPtutYlF6GH9YPMb+ol2kAwS32x+B3vS8J23WbnM2d2KFsHEjIIwcy6pufNaL3t0YvAm7TjlTYvIvPzFYqLR3T7VrnNiqNyu6poD3b8S8Bruhw+PLCgyDXV6AtqotiR/YvyF4IFbZNk5ZAmHH0xOlmBmKYx+aeQQyMn6KGwSWkOthbuU9w2LjisQWAKIwFUzMOhRqOXO0jFgSJIXiSnDEA6TUijjKrrg/AYL1iVMhn3NprtAwL6HRr0HFe7yu+fQkEhP/8YJYS4DbaMED6nzDAwNudIgqT3Fg+/RSF2ECDDr+rSD5H1g2QWUhPRUedXNzKs4ZmeEw2z9IWAtsIo2TujuV5VsiRGax9TvttC2umjLKld+XDFCtSIulofpNQWABrqvKW5SWVdSz0H+4V7lLi5jiGRfJ+J+1Dts4EJTw303L2oBWbIhBtjCh/PlmAFlpXrcKtRJwaOxWXUUmr/3wPHkA3Eu9GnoiqXDFd3Oj9cab9KJc+x+0ExVrPaugcF+oIe+GAlOOmdIQBBxEEaTyLOfw7/isfQfDVWg5oIlvrXHEF3ae4VwgSljnb5QkAaLtEFojJ++k7bsoRFcfY53+avGLbdx9ItpNJQ2Ih9mLpIdxG+YPnbeteK1bXZAtb5ftH60BXErsG+meL2fT/bZIatxPQCd4IRQBfas/g6NWgES5Na3RfxAUM8YmoJL4qliM9VkZG29uFGm9RmGtkctogWi+YIf4YQpYEp/BW4ADtIU7QGNqa7jgwIyreRAdDTirYQcpuPYFJv0Fjw0djdyKQbrqosslaRrePUdvKems9cg4UwAqU/wax1yuD3FhKtMuhn6nSFC0ZIegkhP+I
 HJHvd1Oo
 aNhucTk77KNHpflOfbP4+u+/GcpVPsvJYLUshqS0zQW86fP6jCjEqdtQ1Hk0nEJ7PzGxxLQ8neZyXWLmlYpcfYiMw24ScDrgnJfl2Ar/HTMx42IRATJBpPnJKcu3jyFFYuX9WcrvvPLRHs3WTlIqmmA+zk/P850DfsC+tHTLiYPX104r/NVpmELhJMk4/xTRga5tM6n/u1tv/Up+cDbs80s+uvmRBJ0mZJ9G2MOmYSk0L1V+6w+aLr8vZgKZ5gC+snTQIoJJajI/l0vCHLf+cfdtafpv3AsSxN1cw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for data attribute probe filter directories by adding
kobject_del() calls.

Fixes: 82e66aef7714 ("mm/damon/sysfs: implement filter dir")
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 9f92ebdb28574..0ccdc71275d52 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -960,8 +960,10 @@ static void damon_sysfs_filters_rm_dirs(struct damon_sysfs_filters *filters)
 	struct damon_sysfs_filter **filters_arr = filters->filters_arr;
 	int i;
 
-	for (i = 0; i < filters->nr; i++)
+	for (i = 0; i < filters->nr; i++) {
+		kobject_del(&filters_arr[i]->kobj);
 		kobject_put(&filters_arr[i]->kobj);
+	}
 	filters->nr = 0;
 	kfree(filters_arr);
 	filters->filters_arr = NULL;
-- 
2.47.3

