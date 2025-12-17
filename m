Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7905D64085
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:30:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 380F26B0099; Wed, 17 Dec 2025 02:30:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3625A6B009B; Wed, 17 Dec 2025 02:30:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26BD76B009D; Wed, 17 Dec 2025 02:30:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 160826B0099
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:30:27 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C1C4A5B890
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:30:26 +0000 (UTC)
X-FDA: 84228140052.16.298E248
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0B835180008
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:30:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ht/pt0s4";
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WJaSY8/LO9jJ6S19J29RE7irvv8d++fvHvljBrkMe5g=;
	b=JqeiL9Db8f4/EJG27LOsfiU+z+L/jvt9YoCV/fOoq5lRHMxy3QI8Ud04rRgTwNCerxnxxA
	QWccnnrg/suFJ7F3Ww9NfCWhnwYP6RY20k5uPuufpp6NlM7ByhlF4JlxRpvqmuf/lojaaE
	I/4Sn39DjLUYYgRP3vL1C1xa32ktEOI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ht/pt0s4";
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956625; a=rsa-sha256;
	cv=none;
	b=1iltkAjTVRBaP0h346mdD1qKpbJOGF4wxB9jE57mXu3f8F/OgJhCMTX6NtLkQ/spy9jT6g
	kNraPCe8y3uKpRBk+zVi5rFuPBqz4R1Ekk8GkAVhq3h+30mqMEYKRki6a+pJGMP9/ZWKXa
	iVIsUbGR2weuyFmtthzBz+56jliBe7s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WJaSY8/LO9jJ6S19J29RE7irvv8d++fvHvljBrkMe5g=;
	b=ht/pt0s4g+3r53ot1RQ62n1/WqHwohZA9oU7UDB4uUGCVJQQfb73NonfcosdEPDPprev9u
	kp/QvCPPE1NpyYcUK+QXcQhfINyowuqc1uV/DUY3uHn9/sZ24vHwfj08oOrtlHG1H5nQDq
	esXNLr5XLmnrkUJOnln+Nwks5ycdKwc=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 08/28] mm: memcontrol: prevent memory cgroup release in get_mem_cgroup_from_folio()
Date: Wed, 17 Dec 2025 15:27:32 +0800
Message-ID: <29e5c116de15e55be082a544e3f24d8ddb6b3476.1765956025.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765956025.git.zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Stat-Signature: ekekjmrkt1m5z97w6r8goxiwr9c77czt
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B835180008
X-HE-Tag: 1765956624-686337
X-HE-Meta: U2FsdGVkX1970PCk93G2Y7w9TTzGQ4N+2gLg0InoCEWAiUuohyhBaoTnE+j6irNgyA2aRQ0XXTzLFvUbZQ+FZOdKc6D8gxy3WL/ZASiFnQT10gl6dU6uePtHDIVKMyzxuA/I4ESi/nvkowBhDhcDwvMh28EJcEUbbE8EVmBdNl+zE15GwV3cyqCqKWN4rB7MvEuOSmMUNXJSW7+dAKZmc3w2W25MFg0qLTYLfVxxl1qs5wsRXlXukersMSCHsISnyvgA0kRCq9f86+s1oQVFpj5OSQjLdJVeXQ+uBt5zofw29nlas+jdlmROsDM04QMLALAHDpvWb4pSBxcuNuqZwDwwa+orjHDxv2GEiyxi/qCGJJP8kkNnwVEbiZASvph2b5XeNByUC2D9gg2RM835oZDoxS4sy0k0uV9wkfT7RkY2JmtmqyeLshCmeQBXTgzGKe20C0aJ+QOnX30+WmMwZ8PgTJHGcUD5gMZ5TQlR2+tpU3gvui7NoFjzgyuQllx5zOBThMgHXPeZxDQx8k9mfatmGXo9x7ppZ2exZd7JQ+6G2/+UPdCD11GbiQ6fMUsvTK8TLWGCTB0147p23PGh4LE+tvUycw56ZlXe2fbxQApOj/5sRFcwZCXyrChE+LNXW5U0eD4ackcwWGIC/Hfvysm4DyAEGhe6/nbK9RNp6jR9nW2KZCuewBVDpQwgvHF1Fga9xjzps0YC4jsbim3PLkNYx1QHLbu9uD5GMcXAgx+rmFuqngiGtjQdjM2l42pjoqk0tCIjeZigQqvEg/ws2/ig2PvalwEsiqH+qBRij2j8BtnpuAWwOeMN9pI1nWKz/5yza3DqDf1h8foRoxf9bk8I4zXkoKccaWxe+eqdFXRKXZwrx8LPLTWhDiD3S7nCVhwTwz8+jG4ItaCqNsHx9J3VqJehvgSsVKE0PqQ2AhSC1InXoxC1hMKcAcugsPJVa46tL3cjPIZnn5PBHhQ
 EBothoBh
 6UEfLxSZjDrLAozK6mf5/CgdNn23/x9pkyCRcqcLKPaiyZh32a76CIiu3FtUw7QAvG+qW3Uiwn6aMro075cDOymaIf3MU7rMVXkFJnLsaqoCD+TQX1FbyOLr4h6daM2wJGV+Lb66RaQ1xopouv/JGEkEarjofzNmJVWNxmHWuFhOOSRMSi5+Gvw5zb761ycLE6fZsD3/pnsgJBTEHfyj8bmLUXws0wylzT+00kB4XXmT/59cfvmkmZQjH7mOI7UEQ4b0X
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. To ensure safety, it will only be appropriate to
hold the rcu read lock or acquire a reference to the memory cgroup
returned by folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard
against the release of the memory cgroup in get_mem_cgroup_from_folio().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/memcontrol.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 21b5aad34cae7..431b3154c70c5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -973,14 +973,19 @@ struct mem_cgroup *get_mem_cgroup_from_current(void)
  */
 struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio)
 {
-	struct mem_cgroup *memcg = folio_memcg(folio);
+	struct mem_cgroup *memcg;
 
 	if (mem_cgroup_disabled())
 		return NULL;
 
+	if (!folio_memcg_charged(folio))
+		return root_mem_cgroup;
+
 	rcu_read_lock();
-	if (!memcg || WARN_ON_ONCE(!css_tryget(&memcg->css)))
-		memcg = root_mem_cgroup;
+retry:
+	memcg = folio_memcg(folio);
+	if (unlikely(!css_tryget(&memcg->css)))
+		goto retry;
 	rcu_read_unlock();
 	return memcg;
 }
-- 
2.20.1


