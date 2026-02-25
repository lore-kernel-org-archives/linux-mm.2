Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03601FD3770
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:23:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5305C6B00B6; Wed, 25 Feb 2026 11:23:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DA9B6B00B7; Wed, 25 Feb 2026 11:23:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40B3B6B00B8; Wed, 25 Feb 2026 11:23:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2C7166B00B6
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:23:31 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D27731B7115
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:23:30 +0000 (UTC)
X-FDA: 84483499380.07.55D82F6
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3299F180017
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:23:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=P7IbmXIw;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772036609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+00XNNy3xKzd0oEXtdRXCr3SQsysWVmAOu1hobMNKdc=;
	b=L6LxEzfQhLjG4gV6v8n1PeteaJDCU41yehNjyCHJVzCV9WiGTgoGmpTb6WnYcL1q/IirBm
	gk3to/IK3PmHgm4HfAsukn4pI9w2suqgou6zvDoPcMj4eThBCCSRrNc/S1AxxFmS1fE0HH
	OB2eVO06UyLUmd3HGgKUHDQRi022Wzg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=P7IbmXIw;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772036609; a=rsa-sha256;
	cv=none;
	b=lte1heygAYncGg1sc5xm5xWHjh4cOK1+lzcSexFCcFZ+jXBEFAqFhRqkrjn3W8yfWC2Zz0
	kUtjZJNF1u/TJ7z3o0GtHzv+Z6h4F7kquO4Uf6C0clIHIoj7i5toxQkzkPo8AbTksHyX78
	shp6xangwLGi9ddZje8wRWbEtMmVVU8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=+00XNNy3xKzd0oEXtdRXCr3SQsysWVmAOu1hobMNKdc=; b=P7IbmXIwZtyE5OQxnBdjckNY8C
	4Zuk08aWMGTKp+JopyVLEXINpIAkr0i+j+1BVVwHbP5/KHfLay3/rAr8ymGGXp4XDQ1id1t4J/EI0
	FBtB3lf+QeLEM5SNYqTeB2D7oo5W7x9M+GnPBCs/wEY+46n/7JeRtYrFJGIRYcjYwXTdm7WqeOH6j
	NvGciAVHFwU/Nq1PmiG237ZA8tbQpPwTWcA0ixRCvNXrhpr7tkPM3AE1cn4PcOO2dCWtCPu2QfhDu
	9+Ai6ePkPAn+XFoyxycKLLLbTcTxsS9TMHOFWaPUIeMOh8aixmZteNMgHxBXHdiSWPRg/iWC/TNQ6
	4Gn1YIjw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvHfV-00000001K4o-2W75;
	Wed, 25 Feb 2026 16:23:21 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 1/3] memcg: Add memcg_stat_mod()
Date: Wed, 25 Feb 2026 16:22:15 +0000
Message-ID: <20260225162319.315281-2-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260225162319.315281-1-willy@infradead.org>
References: <20260225162319.315281-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3299F180017
X-Stat-Signature: uwugnpb368ypjaj868yu6s8ywdbyispg
X-HE-Tag: 1772036608-433362
X-HE-Meta: U2FsdGVkX1/0cuoC5SuXFMnBd+6NzMRbF/uFJDIQYW7h4+J2YXGTbFXizoltN0/VOyGROUP5JfVV+ukoKqcy7SmjkfUynPnx/LuUlgBr4E9AE4+9QQQV4FvKVhC52m/Aj9gB+5fFn9zVtKxB7ZLXyS780e3L5v3HTEWs4H9rTvu4PgDEAojj8nBbGZaLnRh1rk8AULkkdtsxcielBxtY7aSAe/RMbxa7cOjiKccfu9jXCanuuRTRhfM3pygpnkT0gD7YgHtTsxYdKk0HchdpDWckoqd6DO/UmibCpMGwJmv5jy4npEl2WxgYkG+gKpXXdrBJIG/rdlcQLtLhKnd0F+NkFezzTr7LlXei6VUHx5jad5Pt0HEzGe7uADdiJwpW9qFbgwrgYtegphbGwP/omaHnORa4hBg1JmbZKbRiCtMRrP6+ZGSIyaK9tyGaOUeqmn6sV8o9VNaNZmJBtzdXtwsRvp9hHP6sS2bmE8JpY6lL5ELrUr8DA72q1mN3AVumpf13tOi96A7DlY8smJnwrEglWYtXsXAhb01wMhSy4t3lh/TwJAMuodlqV3qS+268CHhPLFWVCXb2b7y9nunjG/dXRwPeKWHSoWDvbSWoMPaXFMoU4beX3nJxWpj6IhBhMc9CyJmhEE0i32oUlXLy0i/tlOnCxk3a+bltAo28nLnu5Y9YPQniSWsu7CGZhC2ntOFIIjsoX85+JEv4nc7bQ4bXZNHJ52l1cw8s79a9yejlvla/Fz0SKQSds8y1gPaV8XSKLfyEXwZzSYE6Ha1zfHa8KrI4K7nZHjiFS3qI1+SRjrGq5ASRLeI/tKdbALqkOqC5Jg2ml4gpdEDDSWlIT9frMGTU5r/TZBirkKQMpvGaKoMbnA7jRmNiYdCL7eDCABFzw8Q0pSZBYD+1zumbuM1UeTqZh4OynY7qwD9+XScf/S+bBBBTkbZ6YcmTiG8A76RVonNTXJI/LOoEwI4
 qhoKn0zy
 TbAeuN9STL672L0wBPq2AsaG4dzpcyDAblCqiBVyLA5TzZWsgeETrGX9Wef9JM4wxw3HtoP3ntQvy3q5puiemOuXqUQ8weSFJpcp2uixuFg3opHNv/r1B5bTaT+jBZvoEkqqyvF6GyNGtlayz3xCUXReGTZfOFYk4eyCUux1YJ1SZPN8XtutF+ruMcWyjAJVIa0WOhUi5CR1716PKky6QwpYkIuQ7mCFN+XQDpuU4sQOKR4xsG/wiNaBXIdhB8N7Gr2VIcyqqsqN+QZpAHp4BWQjRwNSAfLL6v+5WOhZNYDs1+8eqDONeyIsS6dzzeSmUy9jt+/4KPwEqmgxHDOGo2i2U7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This function lets the caller find the memcg somewhere other than
page->memcg_data.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/vmstat.h |  9 ++++++++-
 mm/memcontrol.c        | 23 +++++++++++++----------
 2 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 3c9c266cf782..0da38ea25c97 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -518,7 +518,8 @@ static inline const char *vm_event_name(enum vm_event_item item)
 
 void mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			int val);
-
+void memcg_stat_mod(struct mem_cgroup *memcg, pg_data_t *pgdat,
+		enum node_stat_item idx, long val);
 void lruvec_stat_mod_folio(struct folio *folio,
 			     enum node_stat_item idx, int val);
 
@@ -536,6 +537,12 @@ static inline void mod_lruvec_state(struct lruvec *lruvec,
 	mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
 }
 
+static inline void memcg_stat_mod(struct mem_cgroup *memcg, pg_data_t *pgdat,
+		enum node_stat_item idx, long val)
+{
+	mod_node_page_state(pgdat, idx, val);
+}
+
 static inline void lruvec_stat_mod_folio(struct folio *folio,
 					 enum node_stat_item idx, int val)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a52da3a5e4fd..b356ef312bc2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -787,24 +787,27 @@ void mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 		mod_memcg_lruvec_state(lruvec, idx, val);
 }
 
+void memcg_stat_mod(struct mem_cgroup *memcg, pg_data_t *pgdat,
+		enum node_stat_item idx, long val)
+{
+	/* Untracked pages have no memcg, no lruvec. Update only the node */
+	if (!memcg) {
+		mod_node_page_state(pgdat, idx, val);
+	} else {
+		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
+		mod_lruvec_state(lruvec, idx, val);
+	}
+}
+
 void lruvec_stat_mod_folio(struct folio *folio, enum node_stat_item idx,
 			     int val)
 {
 	struct mem_cgroup *memcg;
 	pg_data_t *pgdat = folio_pgdat(folio);
-	struct lruvec *lruvec;
 
 	rcu_read_lock();
 	memcg = folio_memcg(folio);
-	/* Untracked pages have no memcg, no lruvec. Update only the node */
-	if (!memcg) {
-		rcu_read_unlock();
-		mod_node_page_state(pgdat, idx, val);
-		return;
-	}
-
-	lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	mod_lruvec_state(lruvec, idx, val);
+	memcg_stat_mod(memcg, pgdat, idx, val);
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL(lruvec_stat_mod_folio);
-- 
2.47.3


