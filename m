Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8F43C88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 11:45:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C86CF6B0099; Fri, 11 Sep 2026 07:45:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC1F96B009B; Fri, 11 Sep 2026 07:45:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB25F6B009D; Fri, 11 Sep 2026 07:45:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8390C6B0099
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:45:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E2CFE801B7
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:45:13 +0000 (UTC)
X-FDA: 85201300506.08.B4218EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id E8786A0005
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:45:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bmAqAas3;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789127112;
	b=QONkD74t/Q+APIAjl0eng57xBGnhxNOBfl7lgJ/6u8P1xc0Y7yPweEF3Tn0CL8DnjXeW5u
	D9czmpoLLWYZaUFGbTlfrNbHercQcLFsZV2ldwxXZljWUAeZxX6NEJKN0m41fEDFaov+jo
	4tar5mzNhXeSuxGLp7wXEkuIFzQUd0w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bmAqAas3;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789127112;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uW0GLg8GcBt3jnH7onoeFwEHbzC9n8AV50KqE96/dM8=;
	b=mUeZkT3vFJM+Zt2z41O7Psf6nPWGb4izS3T1uXE8WpxlFUMqsNRa9jSrYWuIAq/mconuev
	BopALtxIa0J0NOP18E2qNjqgwDXAaf6sS1sBTRaeSjLcGmydeqWDjUyEVwcmyxB0fiSage
	+/BZK0dRgvbi1ziYbxuBiH/y3bYoibo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 50028444F7;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1166CC2BCFC;
	Fri, 11 Sep 2026 11:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789127110;
	bh=wzPifprnOEoJPVBYXvRSRBkxb6yxGbxpMxyweqd3YNE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=bmAqAas3zirbhvbEBVMODgzwo8q8Mp+4OPF54a845yx0JBMAqWCHk8RhWnBSALepS
	 WV94GIWu26rEOqjNvoDi/VG5YdejEhMOMCxQHlj3Rmsn2L2hfkpo6ckR8kYxiYch+p
	 QFFu+b2pM530plfg1oZXXIPf2MvRXYvRDdbEZ4Y4gcD0TUobet5p4W1VfoGiCPU9FD
	 Eos/i0iFv5MdtkUmfty88Lj1Lw9+O1tKK677tWdYsmfPVhm2mxGkvnGm33Dxi+DRuB
	 7iwqDCCT1Qf9CGeQeH6EEkHZ68WBMkiz3SePpXMvI3Ogxiy3K/H0ICauZkjNHguUI5
	 yLJQeVslApUPw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB80DC88E4A;
	Fri, 11 Sep 2026 11:45:09 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 11 Sep 2026 19:45:06 +0800
Subject: [PATCH RFC v2 03/15] mm/memcg: add folio-based lruvec live helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-mglru-fg-v2-3-f26e5cb26da7@tencent.com>
References: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
In-Reply-To: <20260911-mglru-fg-v2-0-f26e5cb26da7@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Nico Pache <nico.pache@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789127106; l=1978;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=SvYmbN922JEUzWuF0JBLImZdpDlDYaO8ZKxBMuWEFm0=;
 b=/e2U3x0u3hN4OaXIPat7GMtrGeQO4+p5A4EzBwk7S1z2M9L+0p5JMCmz8USYWmHfzZaiSTXl/
 POwj8I3eZR5BnJxu2wmAdebk3jbMmX0i0Sl5rxa6PB++T8TbwRKPRCV
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E8786A0005
X-Stat-Signature: ibchid6pkpj16hf687zb63wi8upczkkk
X-Rspam-User: 
X-HE-Tag: 1789127111-431442
X-HE-Meta: U2FsdGVkX19bVnwlcBgrU7V/jJQEmqoRPp6tom+9TI9SWkuN0sfeAio0SiSZz4I1H0cBvimq/iQo5mxqtwIDBDwlZVhOhyUCEvePwlMSFxEOIhSUalHa3nAO6qZH1U02QpEK94MobjfgRpswUdBJx65glFxjV9qAOMvLEbKhVbi68vnD2UVJod5JwH8gO/l16uXoOqVLs/DaIKErAEK3Q0uOXUdk+1sjwZRIOxfA/oCvfN675GpXivHQUQZVoZMQ0O65tXqYxSHB5inG9RKRxqwH/MGneniF6MrULEPkvh84cK1u5wSmYOq9hTYBBhvihHGcoxEInfpLVGnjNLm1/SDxU63SQKGdUjigzQYpJk8gVScorK5QBBrc/PZrAJQIWmCpUMsQIAteaHrIwcshWDIIiYaTd7tZfve+XYwLJ8JueLnNUgxNSNNLrWOPGctVJxUi+5ieySQuVwB5nfqXnOS6Psw5fRUtoIQu9mZ9SQZmsCpxwBuMK98NOBCcY3hZVrx5JEhgDpUF7s7q7ZiR4/xyOa9aEOKG+uY/4ugR/LENDAgap5zJ/4Kr5SaNzcAiW3SiCFuJm6ZoCrWNa6UJj3+RpiXmUxtW0qip/wlf7WRAig3qfGm1KB4DvD33EIcLW+1IAiijy81mnjXk/bBf421nCwemhBe8TZvCXGEetUWXyOFkyUuzYavmszICIChq9QhaRXw2oyHpRXFls62kh1+i0SP3i9fwubN5IEGMpqPh85+w6xhwp9CIZNclwRbtx7li1W5zqgnssKJwIV3Z+2qoaV9M5qAYm21aqejgB0z5R0T98wylAo8X/LAQJOc6NoW9/LmuC5GzPf3sSLe5hicGQPYThIvgvj3ZpDoWAhnNsRnSixDDg1xuLlDo6P7DBo3uYrTBxRabfTpvedvIFTKRqdN0xlD2BVIXMqBl4hP0iijQkYBCXol6ynXAMlACM+PMt2NIO6tG5nwbnzf
 tVsuLDvA
 uA2bSU8pIoGWfTUbGAODgiiBBHdD1Edf4QLaTSMP2/ZA75tjOZAhCEDkS7dfqU171RaiQSNOkBs+hfsEeVI48hy2mopFQ7vkBWsPQ1ovlKRO64jyW0VZWQcSx9QxluKLgOLzNM2RRWeKWt7Vxwjt8Mgs8yQu5mtmP6HuWDo0C4YedxREp0VzW6aF5V6AXctYouLLwoJJGjuQHaQynsvJs+OYPIa3KA/amq1wWdWzAYxfTCKnhHFAxnTKO4Gi5bDPhUzZDdIP0KsJY8flran5bykPTJ7d0kg7t2yFprNY99LxhOJ2NDStQgTwE9PfVQvXSVhDF+coLcOKA23hu8eZqRg5G9615Y8MGFxD6b66eeQ8RKKy+C8xmddh8TcZvkF1+BynhdltMZFhiINWwtaneJwJsI8/4M69Txq86
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Add a helper that resolves a stable lruvec for a folio under RCU
without taking the lruvec lock.  It takes a folio directly so the
lruvec lookup happens inside the RCU read-side critical section,
which a lruvec-based interface cannot guarantee.

No functional change.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/memcontrol.h | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 2daf2be5d1e5..d8a47fde387e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1524,6 +1524,45 @@ static inline void lruvec_lock_irq(struct lruvec *lruvec)
 	spin_lock_irq(&lruvec->lru_lock);
 }
 
+/**
+ * folio_lruvec_live_get - get a live lruvec for a folio under RCU
+ * @folio: the folio
+ *
+ * Computes @folio's lruvec and walks up to the nearest live ancestor
+ * if the folio's memcg is dying.  Paired with folio_lruvec_live_put().
+ * The result may be stale: RCU keeps it alive but does not pin @folio
+ * to it.  That is fine as the counters are fixed up on reparenting.
+ *
+ * Return: the live lruvec, with rcu_read_lock held.
+ */
+static inline struct lruvec *folio_lruvec_live_get(struct folio *folio)
+{
+#ifdef CONFIG_MEMCG
+	struct lruvec *lruvec;
+	struct pglist_data *pgdat;
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	lruvec = folio_lruvec(folio);
+	pgdat = lruvec_pgdat(lruvec);
+	memcg = lruvec_memcg(lruvec);
+	while (unlikely(memcg && css_is_dying(&memcg->css))) {
+		memcg = parent_mem_cgroup(memcg);
+		lruvec = mem_cgroup_lruvec(memcg, pgdat);
+	}
+	return lruvec;
+#else
+	return folio_lruvec(folio);
+#endif
+}
+
+static inline void folio_lruvec_live_put(struct lruvec *lruvec)
+{
+#ifdef CONFIG_MEMCG
+	rcu_read_unlock();
+#endif
+}
+
 static inline struct lruvec *lruvec_live_lock_irq(struct lruvec *lruvec)
 {
 #ifdef CONFIG_MEMCG

-- 
2.55.0



