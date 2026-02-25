Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DCF3FD3774
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 17:01:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 823026B00A8; Wed, 25 Feb 2026 12:01:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D0E66B00A9; Wed, 25 Feb 2026 12:01:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D3146B00AA; Wed, 25 Feb 2026 12:01:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 583416B00A8
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 12:01:56 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C07C98C261
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:01:55 +0000 (UTC)
X-FDA: 84483596190.19.4EB0689
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id DB94D180010
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:01:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OaqZiziQ;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772038914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D3TwUQqJCu3pPi6QJD2PSAqbuKObzu+ex5JuOKPtNo8=;
	b=BVK4szskXmk/Ab0XOguts0QqAQEsuYXwYEwHittAAd2FpsbYk6IC0XevUoWb79uHnxkYbr
	YURcaznEfPBGx5ui1Y0cYDisuHuFQdNvf/TJGPdIh5aEZn/8UGfhELZzrJLCCxlYsL56mG
	UBnhAV5AnAJ4sBtTbJc2qd/KzpHk04s=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OaqZiziQ;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772038914; a=rsa-sha256;
	cv=none;
	b=UmJRWnff4UMS9MCoykO/zxhOwkaPF1lAHRAcP0IPjCMxUBViJhDfD3foD/EcvztT4MtE4u
	Gm1mApaMayBXFLmNZntm8U36n6cYsdEdNo+QCw4eIqlgMT3d0Qk4R9bFmM4cvV2ptUrQOb
	Ig5DtTyRw2wm3/e/+KR+PxcR9m4ewsI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=D3TwUQqJCu3pPi6QJD2PSAqbuKObzu+ex5JuOKPtNo8=; b=OaqZiziQmIk9V5oNMOMkyB5ORT
	uf+ivgFyc6+IheH/I0+KuTa3nsdRvPhQzL+DfjJvByoBnf2+OeYFk6vvVW6HozwbW+c8W9UviTk/W
	EHyn167alq1rhv6oHL6+fm2Y5lzO0cPyKOmqXTM9YfqJVUkIgzcRs3aZkGUE5M3K2XSUHpX/iwh1y
	rzbim0lz2YJQIHtq/HzJFywQYD6BFTmypsWm3sovph95P2qP7Yvnxxlv1Q9c3hqTx+chWQ/9lFwlO
	EFiHYiTl/AJ0hJbDDIOtiuHlOAL5DKTJhu5Jr9e5u7/VGkTFzozbHar9XdUcjhGDceXR5MyGbdzHZ
	iSEGOfnw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvHfV-00000001K4q-32eU;
	Wed, 25 Feb 2026 16:23:21 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 2/3] memcg: Simplify mod_lruvec_kmem_state()
Date: Wed, 25 Feb 2026 16:22:16 +0000
Message-ID: <20260225162319.315281-3-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260225162319.315281-1-willy@infradead.org>
References: <20260225162319.315281-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DB94D180010
X-Stat-Signature: x8gxeu5futqgu7sx7q9qbtuxb76th7yt
X-Rspam-User: 
X-HE-Tag: 1772038913-846546
X-HE-Meta: U2FsdGVkX1/K67gr0Xhgf5diMvPHx70iaeZwZiAsLspNfe+OXzO1xd9LQiSsSMUYiTVp7uJaAvYhzkJ4BC0IdjUIdHQb1VNu//1VpK1qDM7uoBWEg+zZdxAF/Ev78REi8Dg9wxTxruyp7QhHWpGhVw1+4jpyDOJBT22PXAXQVk3SPEonF46K0K8hRbG+7J10INO5ANr5NoW8IMkN7vjhVH6ZDW9t1AZIZMVdNm2Dw1DDI3+xxwcj6bXf7OOAn8PyxNWO8M6nI+A1Kv/DJpPYEOl4EJ6vKRzCJ+dlwLsEznGmBrY6RwvnTIPqVQmMEP/8GZaTrtA09EM4/RnAqNW9PdOAgm1FlsyR26sxymHSpYyqkMo2krTNNCKlv7JVmyGoqUyg2r3ZSqDkicA8RGyXqTo6D599+ZZ3Rd9nJH2Tfu7MMHb2YC/nnax0Jylkca7evPjNavOts0WY81fV/T2/Qv1C971MaCMf5/zdqHWQTUiW1eGfEcq3eC2fhN1h/SveRJB0E70zBrylg3LXw+WfEcVVblQgLArxZGTEp0H0m+lqZURNb2WKj4oN/d8JSR1OjDfXudRW7VsnejNmQNr1Yz5aPMT3LDxhkxBAjS/yrw3Kl2mlsdZcs22xSm7yeeM2UdeFlW1om2/arRNdelZCj08OuFGhPL1d47wmNMZZNuaaY2N8OsFyUTe4mbL7w5UCkYMKZJ81o3YbGt6HfsSV8fCgz3A5CH6zHSfLCWDyiACkTv05Mk8p68Vsj/u+F0KF770Oem90hYHb8eyj9FvgZH4LoraQuzzv8LGtAdemOnFHeCH+TU5xx47EhninhQkf17lFk+hb2CQfY1Wa3UAQfTovy5jQonHe1mjFXr22W3VQMlN1BTcveNpYAHl8565d52nClKUoSO7lwtaORlVRgL0MrvOOa18tNUKrJNYxx4fxuHxYSI53d6krmavE+UnNi3wXKqiHlSUepTqyuno
 J+bUMiuk
 VyqbL7js0GDlCT3k8TODRiJfL6phTqKsRob2qGAdvQDzOHehaou0b7JBG/ywx6WvHqmrJYY1o8Tq6V+wa9FrvQWogkJkapJaLd1vBEeHshQ/Ls0jWq7homSVefeuse8A+tsF+v7XdCDPezTMXS9xcsQtRB43E5uD5J7Trnkef8iSsr2gjGfB13CXo3gMvD26bA1vcuERhieubFO5gCvbN0MFH2J7+M2bL1C4Jd1gOt+34EJK1PS1FcnJZjBRYDGeS4mlBaxnPvfQxiMKsI/2sOby+OYhL0E3sObtdXspHuki7xuPSVrLF8G7ssjNg3JJPEuQ3NUXXvvejbUNkBzi6hyCbwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the new memcg_stat_mod() which does exactly what
mod_lruvec_kmem_state() needs.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/memcontrol.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b356ef312bc2..8d9e4a42aecf 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -815,24 +815,9 @@ EXPORT_SYMBOL(lruvec_stat_mod_folio);
 void mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
 {
 	pg_data_t *pgdat = page_pgdat(virt_to_page(p));
-	struct mem_cgroup *memcg;
-	struct lruvec *lruvec;
 
 	rcu_read_lock();
-	memcg = mem_cgroup_from_virt(p);
-
-	/*
-	 * Untracked pages have no memcg, no lruvec. Update only the
-	 * node. If we reparent the slab objects to the root memcg,
-	 * when we free the slab object, we need to update the per-memcg
-	 * vmstats to keep it correct for the root memcg.
-	 */
-	if (!memcg) {
-		mod_node_page_state(pgdat, idx, val);
-	} else {
-		lruvec = mem_cgroup_lruvec(memcg, pgdat);
-		mod_lruvec_state(lruvec, idx, val);
-	}
+	memcg_stat_mod(mem_cgroup_from_virt(p), pgdat, idx, val);
 	rcu_read_unlock();
 }
 
-- 
2.47.3


