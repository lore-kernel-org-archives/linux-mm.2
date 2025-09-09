Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E2DBCAC581
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 01:22:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 963458E000C; Mon,  8 Sep 2025 21:22:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93A858E0002; Mon,  8 Sep 2025 21:22:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 877448E000C; Mon,  8 Sep 2025 21:22:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 744678E0002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 21:22:05 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0843B119AD9
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:22:05 +0000 (UTC)
X-FDA: 83867960610.26.AEDA3AE
Received: from ssh248.corpemail.net (ssh248.corpemail.net [210.51.61.248])
	by imf23.hostedemail.com (Postfix) with ESMTP id BF132140004
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:22:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of cuishw@inspur.com designates 210.51.61.248 as permitted sender) smtp.mailfrom=cuishw@inspur.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757380923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=lEAnNHWc7di92xg3ck6FyVdL7D2jEGkH+Bev+hPUfgw=;
	b=CmMeDa7/W7WGNzXAsbMiQV4GTLNpFyrNbEKdHzjm20mpLIEOJO3nRsgC2QepQonjftfIKK
	puyYMEmPwjBbH9iUrkmpB60vZVY1mNeyd8IksaS0EeQ6POzu+ig3X0MiRL2nx39W0DQS+B
	a8LcciNYHf9UEYx9p5kSgE9VmRXMX4I=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of cuishw@inspur.com designates 210.51.61.248 as permitted sender) smtp.mailfrom=cuishw@inspur.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757380923; a=rsa-sha256;
	cv=none;
	b=HAgr6PwAzuaxGKO0jpD0pOPaj/mRdEWBiG43m+nZdz7CvxK2wI1aiQdQyjaN7cjV07opjo
	GvoQlCBLMuLWqiTNYUIz80xSt+Oq7JYF9a9jXJxaC8HSbv20x/E5FjYZ57sI03fQOtOb9N
	wyomRJCVIZg/9pUhAuAFbrYYeRfYbR8=
Received: from jtjnmail201610.home.langchao.com
        by ssh248.corpemail.net ((D)) with ASMTP (SSL) id 202509090921522911;
        Tue, 09 Sep 2025 09:21:52 +0800
Received: from PC00024056.home.langchao.com (10.94.13.207) by
 jtjnmail201610.home.langchao.com (10.100.2.10) with Microsoft SMTP Server id
 15.1.2507.57; Tue, 9 Sep 2025 09:21:52 +0800
From: cuishiwei <cuishw@inspur.com>
To: <akpm@linux-foundation.org>, <axelrasmussen@google.com>,
	<yuanchu@google.com>, <hannes@cmpxchg.org>
CC: <weixugc@google.com>, <david@redhat.com>, <zhengqi.arch@bytedance.com>,
	<shakeel.butt@linux.dev>, <lorenzo.stoakes@oracle.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, cuishiwei <cuishw@inspur.com>
Subject: [PATCH] disable demotion during memory reclamation
Date: Tue, 9 Sep 2025 09:21:41 +0800
Message-ID: <20250909012141.1467-1-cuishw@inspur.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.94.13.207]
tUid: 202590909215269e944241ffdc39a63df3b45123fc775
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Rspamd-Queue-Id: BF132140004
X-Rspamd-Server: rspam05
X-Stat-Signature: yu8f4ocuzpoy4crjojp3b7ki9xy553g1
X-Rspam-User: 
X-HE-Tag: 1757380920-746643
X-HE-Meta: U2FsdGVkX19SfJ7uITCuKZFq9Kx63mMJo9aep9YybliqfgZKBFYcukZAYPzpKyVSurttBfuMxQyXg+fYq8a2gNLOFw3Jey3xtJZfyzsErmXZKOYKcie3UKShloWzKpoQVsBRShyU8IMbhSlgVPzLt+XpZLFs98H7VJARCJYRT5Gonh2/pLfoEAqhO1XElByfp5JhrKmKmQZwhofXxq6mZ2ymVlQPLqelcsHGgXjWfdyxPZmwDewWRyJbWnwgPIyZ2L9oHrsovnqL5H3HTFZ2fZrMfV9rjg5xPM5Vhhtahvqu6YFeG/m2IPMWK0NvQJ1qL909QtuirMd//0fHP63gDzG/CXnAYSzHHWLQFWIn1vv03MZMi3ZM5uOK2niwXz2oDps58N7zMZekhJtCt8FTZsi+n8exYT7v9LpmcP1OdEf32gXOD1wHlr3j+fViCW9BmnVqNq047VV+isOUP/+2/mLiSfB8NDK2tViP1zqufTL3qw7DbpfHF/qUleJsUpBs0N/Hoq4eIeYu1D7mUnVVmGS97YWcDEn7qTfSTQi5gMP8ByUhOpIIUfNZd/6Th7BEzuJl5bDsGw/Gnt61XTwHwOn5BauwG6fJIlBsBW4IeBjA2lyPZ7H6IIABYCbJa6H3eUS4ctz6i0E1sfQzPU5rcpc+PoxzqJW+LXv8rcNG0wtowplw6TMqlEKlIXS9v5tOB5s337YcBq5omJjGbe0wWXaQN4i77Jz1HxvCggpdKLwr+JFVkhiW8f5E55bfXRWlGZ4eWQrQPVD27G1lL3fNn32YXNeAuL5WwyGotuxHEXyF6BK9GlisFVa+A0pVgF6k9OF00MWKSqHsY2LEPFUn+GuqqgiLDw7lyfpBonrpgU3i5gWEbwdj+8kVWAssLEYoBHNytjdW1Tmq2QAFJUTqHSlX5vrKpt1aYuwP5rMhFseuQqyfMgeTSa0YmgG2RFlqRfSmdXp8APN+PWZ76Rn
 XQ3B6jGa
 B5neSWGMoGjeYLliPta+qFPMzlz00v0uS87q9gTU2+2Bd/xYYTUBgw3GqubmVxYSiViR86x14isINoq0LUziYE/3VwWsACj3B5aoN6e3g2Ndm7tJ5wWme9sBF0SEJwkSm1sUh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a memory cgroup exceeds its memory limit, the system reclaims
its cold memory.However, if /sys/kernel/mm/numa/demotion_enabled is
set to 1, memory on fast memory nodes will also be demoted to slow 
memory nodes.

This demotion contradicts the goal of reclaiming cold memory within
the memcg.At this point, demoting cold memory from fast to slow nodes
is pointless;it doesn't reduce the memcg's memory usage. Therefore, 
we should set no_demotion when reclaiming memory in a memcg.

Signed-off-by: cuishiwei <cuishw@inspur.com>
---
 mm/vmscan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index ca9e1cd3cd68..1edf618a3604 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6706,6 +6706,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 		.may_unmap = 1,
 		.may_swap = !!(reclaim_options & MEMCG_RECLAIM_MAY_SWAP),
 		.proactive = !!(reclaim_options & MEMCG_RECLAIM_PROACTIVE),
+		.no_demotion = 1,
 	};
 	/*
 	 * Traverse the ZONELIST_FALLBACK zonelist of the current node to put
-- 
2.43.0


