Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5B43C43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:54:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9260B6B00A8; Mon, 29 Jun 2026 21:54:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8887D6B00AA; Mon, 29 Jun 2026 21:54:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C6566B00AB; Mon, 29 Jun 2026 21:54:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 584D36B00A8
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:54:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D141EC1A25
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:54:05 +0000 (UTC)
X-FDA: 84934908450.04.F578D74
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3CADA40004
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:54:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ktiapAz2;
	spf=pass (imf12.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782784444;
	b=S6WL2IoMFnlKxvqyVIINPlDslY6PrOxJA+LdoB9dFYmOCHx29NT54YL9yie+zSWcHu2HMu
	l6IqXUz/0V0hXFzAsVXWolGcAGg+0sGNt8TCgTNYxuaF5ty9/ue1CveDKIWbO5T7OG0uZV
	708pxusqo4dgsh2aNSAG2hfcnQIZJ1I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782784444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x7l7Cu37ztLHTqXl9+24GTeEvM65Yy8Y6kuKnfhmUgo=;
	b=c2NQaYxoveM8U2JVl9YmqRdjE5EX0NqP2JmmSTwTNa+/4LatUerbh5qAUfd+Vxu1uLViHB
	0ybWxnrWSrIg8tUHQGoamIIuuIcBCykogJHzWPHo8RxIXNLpxqAOonPUMRRDyIfpbwDSee
	r5G39JvQT8mppkizmNcvqMlxt6bzA/Y=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ktiapAz2;
	spf=pass (imf12.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782784443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x7l7Cu37ztLHTqXl9+24GTeEvM65Yy8Y6kuKnfhmUgo=;
	b=ktiapAz2WCe8cDjso3x7dyadbLA14q7rbR36f7qfLbmJ6zudNpK+1HZVjbdS5LtcFSRkns
	7DmC8D9tEogyic7rBcJIEqlgDvRkzXBymoKGyHYe0AI9mjM85gIe/7q8I0ZwW5ReldRTaI
	R7jRfewE5hq7Tza9/hHl/bFsXyy1jIw=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/7] mm/page_owner: hoist CONFIG_MEMCG to function level for print_page_owner_memcg()
Date: Tue, 30 Jun 2026 09:53:21 +0800
Message-ID: <20260630015331.147174-5-ye.liu@linux.dev>
In-Reply-To: <20260630015331.147174-1-ye.liu@linux.dev>
References: <20260630015331.147174-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: h1rremitdhzpo9dgjho6unmw3qgfwro1
X-Rspamd-Queue-Id: 3CADA40004
X-Rspamd-Server: rspam06
X-HE-Tag: 1782784444-847808
X-HE-Meta: U2FsdGVkX191xNFJOKqEJXK9L4K0OUpdPDh60SZKIbCLQXu0R+OwXH21LjB/ynbYE+Mzd8FYHzuqye01ej2oS6npUrbSNiZRlz/eS2lsgq5co4/FSR1PU4GsNd7dQhAOs5mMPVnksrcCWiqRX4ERHzKgR6jnR1uJau0OtQB0CNXFo1lmHjBt0TCPBATjC1pu3i0CcM223cz5kP1FEc0ymzHDE24wM365f4PXAcebM+/xjq40B82XjOb9ei6xVPP5Xita4i/ymoJgbQgGoDvsnlIpVETlBwoeVzMBwcgjFhjMEoI8uM+kvBNvPpRkN3NvVd0okezC6vMYzzh12OSebwDE38xNTH1PMQa2SmKzLXUdfRiGmUASF1/DXUeVJV09iDwrHEOfXOkhfdCPggx5cNCl3PjFnoBFd/ysojOmL6PIvf+9R0JPazafSdemo3Jm1df/OPUxOC1mAu4ltqf4dMV9xkjH5r9xaPcEf5wpsgEiNTBFVUnnK9NGqfS3WH7mPzXNcaCvQAPZcfLMDVt5a+Lt94T4Am83jVRdBPmeLHQylnoBGy61YiPtOFnjXIBZwN9T8aqUAyaaffl0FuFACX8hdw0SUclTekKKT0mnt+1XA3doWkgwPqmlmUp7CvfvPOs6R2vigrju7jDoKoYWWY0Au27Zk326ICqio3DC+0RmWmLiKqX0+n84R9iXZgOZ5ruFATwPnP1UsHVt6ODwpk940sh+AudRckIzNyn2I58d0/sT+I6lV5HXQnoAjUX+IpkfeBx3JA6QUtNP8NWpelI4lNk4Ah+NkJytF7wOBxWGqoW6WRbZXg+4lDGXbTuORk6sBgpHaQqjE2z5xSSkCCScz/ZlwTuWumPSPy76doknkIM5ixjAO+sKleQbFyc65PAU7LueLZg50jKD/s13fGoi/k5raWztSNHGO2m4EoX/Snu/xmPeM560aX9FCxm5nt9alS9CqZDfq/YX3rL
 wnT0MYl2
 1i4Ay1wvRTv1Oh1s9VW6MSk/qQi6Sw3EkqbeUg5Aaje0xaR+FTBmwD6GdL5yCFX6CJKBza/3jqLHHhCFqPDxHkTUllP2x0iPntirqHBaLhFUg6R5FL32f8gHHEHEwqppqChaX0fzYkLrCG+Rn4bWE/Mjwib9Z28Ayy8grH9cRwm5DTb/FrIiOwybDxMrkCZ93sqR9z+CIhMhczIxe5ScVKIVhpj2dzbkWjdtx39b4+sDEDsNtw6Sb0Mn9lF8DukklvH6k3k7q2d6i0QN8k4gD1HieoD5vHQ0GW2a9mKbIDALSuHA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The print_page_owner_memcg() function has CONFIG_MEMCG guarding its
entire body via #ifdef inside the function, which leaves a no-op
{ return ret; } when the config is disabled.  Hoist the #ifdef to the
top level so the real implementation and the empty stub are two clearly
separated definitions.

No functional change.

Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/page_owner.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 4e352941a6e2..fe2bf2274d8a 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -522,13 +522,13 @@ void pagetypeinfo_showmixedcount_print(struct seq_file *m,
 	seq_putc(m, '\n');
 }
 
+#ifdef CONFIG_MEMCG
 /*
  * Looking for memcg information and print it out
  */
 static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 					 struct page *page)
 {
-#ifdef CONFIG_MEMCG
 	unsigned long memcg_data;
 	struct mem_cgroup *memcg;
 	bool online;
@@ -556,10 +556,16 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 			name);
 out_unlock:
 	rcu_read_unlock();
-#endif /* CONFIG_MEMCG */
 
 	return ret;
 }
+#else
+static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
+					 struct page *page)
+{
+	return ret;
+}
+#endif
 
 static ssize_t
 print_page_owner(char __user *buf, size_t count, unsigned long pfn,
-- 
2.43.0


