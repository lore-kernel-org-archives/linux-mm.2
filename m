Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEA5DFEFB6A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:08:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 147956B009B; Fri, 27 Feb 2026 12:08:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 117B26B009E; Fri, 27 Feb 2026 12:08:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01F2F6B009F; Fri, 27 Feb 2026 12:08:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D75BE6B009B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:08:17 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 925E213BB78
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:08:17 +0000 (UTC)
X-FDA: 84490869834.14.F5376CD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id E8A2A18000D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:08:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PtxnVYNv;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772212095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g1GyaSzjafW+dfaXmJTl1tolDFvA5se2d/Y9EdmUOko=;
	b=xZGSmMjeECFYQRNWo9WR6rLNF1oVkqxhr/073rU3cfZjzs105C6QbrLSsWq9Rnb4y+gEzj
	sZX4FumeVMyy1gVlUoZKSfD4KIOnhqkn/A7GqKnCq4Z6RRwaiMjJEpVckEBWkoXfbuAuPd
	WoZU0/rvFGr6srrfxMpBeq3rbp+Pvi0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772212095; a=rsa-sha256;
	cv=none;
	b=wHUoTTYtfgFHFPdyWA2vF67PH+te2HiUHsu5qBZgYlF4+TPL3W9zyyGBLKE6NFtvGMEM17
	i8SyGAMseLqTHiBcLs+o9a1T0FSJ6Dt3Bdx2tATu0HjNE1WRzHPYJ+TnLfMTt+rw8vj3KN
	DVIemg3zjoxZkXmTOdLZFo5VHx/HnEU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PtxnVYNv;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7462C6091C;
	Fri, 27 Feb 2026 17:08:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16081C2BC9E;
	Fri, 27 Feb 2026 17:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772212095;
	bh=ZHsMfkpb8Z0NsJNQxwMtfHR8hmqWgsxeSPDgYVWSXNY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=PtxnVYNvAXCJ0AvExijB+9VlsYSOS0chDtohot4FhDXzNLcfeknAAMcG/spA/0f+D
	 cF1j5qXDZIctqhBDMzsoEzd4wKLasrfaLl2ruaHJeuVyG93FQ97/7h+Qcx0epxdv9W
	 QMy8rJtv/Ug6PYsVk7byrvI/fq6NrZnE3BD3VsEMdbImOwngtuO5KEFkEgTAgp7wdF
	 YQxHA5fQ5Y4NgOmqjj1CsF3NhN330pHH8rEv8Hj/MbUulBRWV6vS8irzIDMLZFgosw
	 34CDkWj3nCDF/MZqCxp6Lx8PF3hSsMNTdGt4fTt6TKGJt22KUIdxDiY2Au7JN+xn7k
	 vAm1rmgjELXWw==
From: Vlastimil Babka <vbabka@kernel.org>
Date: Fri, 27 Feb 2026 18:08:00 +0100
Subject: [PATCH 3/3] mm/page_alloc: remove pcpu_spin_* wrappers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260227-b4-pcp-locking-cleanup-v1-3-f7e22e603447@kernel.org>
References: <20260227-b4-pcp-locking-cleanup-v1-0-f7e22e603447@kernel.org>
In-Reply-To: <20260227-b4-pcp-locking-cleanup-v1-0-f7e22e603447@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>
Cc: Mel Gorman <mgorman@techsingularity.net>, 
 Matthew Wilcox <willy@infradead.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-rt-devel@lists.linux.dev, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.14.3
X-Stat-Signature: 5xo79cjbfe3udzp7wirdpge5dm1qw3xo
X-Rspam-User: 
X-Rspamd-Queue-Id: E8A2A18000D
X-Rspamd-Server: rspam12
X-HE-Tag: 1772212095-177634
X-HE-Meta: U2FsdGVkX18QD3/ErBGyGqd9GeScTDIQ4xUmhIXvjnHR1wq1PIAjD3fuWu2zk0NcuZn4F1hcYSvnpFdkpxRv0jBK+gNlIwQhzxPTJic+4K5CvC2zAAT4dbUWP2vQgH96g2MeD/obFU4K6ccE88Q/X/QH0yQvytPYK2m520tcouZOfwScojQQsOxII93ORVpueeTg4r+I14BA+HhO8ILI9FT0uREB08s5TpI/B3AEJE7Lv2m8ZGnVF09O6Ylw/QAeLOupcsV4LPz0+KE5ahTf7qCj/4qJ9u6v8J208ll8hL5ADLXWAz9ThD7ONJ4zSMhRAMZ6vvDb19kBZWN1i0ruVTW7xCh14BC9V2ULBiy9bB2FvI0+mujcUKkjdehU9jaDdDGpGrI6fonVXX76AJzpsogYN8eAR9Z9Q2JkyNS3/YgyFxgphwOMXkjrWZMRz5PQhOkbLdl173qszxWFiWFqajy9he/z85xvjjZ6BLBRpKAYHH4sF3KqBFVonysbx1dkyfMfqFkrXAqmgc5Zcs62myhyH47TYeXsdCBIG6tBXyBe9M1OMIoqT+lxItBZVX4v7I9n6aE/GYdCPHQxXutljGyFnpHBcQbVE+4tCNQ9OgoQonIkiodxI15d+dwQMXJ74d3EItj8IvjH9rix/1CDw/n3H5XKYWxVxs6KUx66sf58nTfFlXh83xvBmOQa+3I5Losr2GHGpiErd0B/3sJac5LNynnrD58vTdEkUgyqTfJuEYgdgVY9A8lXYOTJfJICR+e77ymhl2XdrJJaluDBVQlo2O/zGI+cuRjdWfiWVQ85aHkSln0e0tV9HWZ1epvkuxdd19DFrJ8IlY3Y3UFaFB2yyb9W2RvhM4I0MLKmQLyBMan7ZsLL4iXvdAwMACi0GXyMFcX0oLMNw4hEiV0uvGs9qBLPs3bFaM1tn/jVaYkcC4g6zprryGw0sc5XnNwzXqR1yKp9r65os7xgqg6
 mjgIOEaN
 FlN8HUUB3ArhE0paiGm5XXl1ay/Y+j6kQYJTARoknOPy9dJaqMi4VEswszpm0Fohfz/d2IfOCuIqXUV4cp46SDtWj1qafMa2wwO64HpNOxr5gJPV8kCOLdDchoPspoTf1G4EJAFxkS0kzgy2l5A4b7JOjSVo4U+KsQ1fVdCrhy7Sek5sEqhMKWUmDmbxEXkR3N1Q6SL2eJgufSn7CPrnzXpU926lZx46haK1ZvofYRuSU5wB5ybCLtoZssv+lBG7kcEit/8s4VSBz3+3+I5JDAM30x6RuGmDi108yfovN5mPjPDhrCHW/xSnFZxvklgEFYzshvzk+mQmDGM30QSPhpWLQshnJnoXvQksy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We only ever use pcpu_spin_trylock()/unlock() with struct per_cpu_pages
so refactor the helpers to remove the generic layer.

No functional change intended.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/page_alloc.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8e5b30adfe40..b1007afa9492 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -112,35 +112,29 @@ static DEFINE_MUTEX(pcp_batch_high_lock);
 #endif
 
 /*
- * Generic helper to lookup and a per-cpu variable with an embedded spinlock.
- * Return value should be used with equivalent unlock helper.
+ * A helper to lookup and trylock pcp with embedded spinlock.
+ * The return value should be used with the unlock helper.
+ * NULL return value means the trylock failed.
  */
-#define pcpu_spin_trylock(type, member, ptr)				\
+#ifdef CONFIG_SMP
+#define pcp_spin_trylock(ptr)						\
 ({									\
-	type *_ret;							\
+	struct per_cpu_pages *_ret;					\
 	pcpu_task_pin();						\
 	_ret = this_cpu_ptr(ptr);					\
-	if (!spin_trylock(&_ret->member)) {				\
+	if (!spin_trylock(&_ret->lock)) {				\
 		pcpu_task_unpin();					\
 		_ret = NULL;						\
 	}								\
 	_ret;								\
 })
 
-#define pcpu_spin_unlock(member, ptr)					\
+#define pcp_spin_unlock(ptr)						\
 ({									\
-	spin_unlock(&ptr->member);					\
+	spin_unlock(&ptr->lock);					\
 	pcpu_task_unpin();						\
 })
 
-/* struct per_cpu_pages specific helpers.*/
-#ifdef CONFIG_SMP
-#define pcp_spin_trylock(ptr)						\
-		pcpu_spin_trylock(struct per_cpu_pages, lock, ptr)
-
-#define pcp_spin_unlock(ptr)						\
-		pcpu_spin_unlock(lock, ptr)
-
 /*
  * On CONFIG_SMP=n the UP implementation of spin_trylock() never fails and thus
  * is not compatible with our locking scheme. However we do not need pcp for

-- 
2.53.0


