Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 090A9CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 12:46:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F5A26B0096; Thu, 28 May 2026 08:46:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CDF66B0098; Thu, 28 May 2026 08:46:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60A3C6B0099; Thu, 28 May 2026 08:46:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4FCD16B0096
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:46:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F23B6C2911
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:46:29 +0000 (UTC)
X-FDA: 84816802098.16.4DFD42B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7048D14000A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:46:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=TUqlpwVi;
	spf=none (imf09.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779972388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OYWIfkP+VT/qifqMoBAuLWWbO4DfLIMT3CuxxzjmwTs=;
	b=F+0yUdacemZzOgFn0oktXOoAylcOH4WpsXiB0/wWLV2rc0YuQ3dklTBkSgsQPQL4qsGnwa
	jhHJIP2QMk0nndmkgD7c5MzXGlaSSgfyWihOSHMr9LKm+f912x+ucc/5L4iO57K4UNLyTH
	8ZFWxIxQ7yIQNyefXYrQUEPNqNvULcw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=TUqlpwVi;
	spf=none (imf09.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779972388; a=rsa-sha256;
	cv=none;
	b=jr75DzR0DRhvZRiA5tVEZdhYxI6rJZyMTenT/+0ToYnKtEWR0uTGuszYOfI8qB9+CJBZ52
	3qXMg9dRlZHiOeGBPPW+KAvtj9DXtSVSaq+F0iQk1uXNCQwnmNspwQBhuMWULHj9ESDZur
	pHm68NqYtPdGGCrX8iopXAfDLyCeAyc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=OYWIfkP+VT/qifqMoBAuLWWbO4DfLIMT3CuxxzjmwTs=; b=TUqlpwViKay5B0pQvXN68ANQr2
	KQF2wVaR1oyjSDxWX41gkJFyIyYRr5N/ZS5cXgdWcHS0cnqLAu68wQ+krKEeNyz0Vo+uaINT10DeJ
	vNSOVFR/ZZZIvyRSpdPJZpvF0c7EDTqZvyet9iBp+yebq4YR/2L2qENmFdjHe7h5eB8kWH132AWll
	eRaXnDOHUw2flybDxtPx8BioZ+O3pJ0+B//ZJGuLn7/SZeSKvJ3aG1leBLeAduF+uk42SAig4eSy7
	1eMLNjeCoawQVwwc2r2qhW7gxBN0D0ZGISXMgLOuPvh8aQ8hVXys0kKjwd8Ls5FQJIQv05/z4p7YW
	pAZseglQ==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSa7y-00000005jeQ-1QXp;
	Thu, 28 May 2026 12:46:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: 
Cc: baoquan.he@linux.dev,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	usama.arif@linux.dev,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-mm@kvack.org
Subject: [PATCH 04/10] mm: memcontrol: factor out a folio_memcg_css helper
Date: Thu, 28 May 2026 14:45:20 +0200
Message-ID: <20260528124559.2566481-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260528124559.2566481-1-hch@lst.de>
References: <20260528124559.2566481-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: 7uw3ra399bqcp59t4k551ncmz51zt4j4
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7048D14000A
X-HE-Tag: 1779972388-356266
X-HE-Meta: U2FsdGVkX1+3DJ2WtfbMJdf9TuxrK3yEStxRoSlioipdbkKiUlGsS2Yq4bz65F0qJ1z/b975rvFZhf/SRavieafIUf4AWMGYFt/Vc+J+l4ooCmoI2e3+IPM/t3x2aQXQiv4rGGCwt87rW6t0u3T2N0O1MhqGdXz4hNOSWRi8RBUj7pXv5t70bK7qpHf4lwGW5MQ9eC7rLETw11AaE5AckQZwQAnx4cS1XcbZEihTF/I6YZoQ1cgosbZYUk7s6Sq2Ohl1NMAUhjy+vt1kUmvhyZMMNUs8BViY7jVv3/qWJw5PKV0tCIyCuMpXcySuBYSJ1vWtRVii5gSbS2tmxsDCk8BCTwlkItfJ5k8ZqymS0PaS2AfiQdsLXJ//f10F4yQz4WaDOs8mgng+v5+jVdgXu7QK6rTQyn4MWDSfBaUxtMbxfYAmEnNOS4ty+8kgaaaF38frfzlR0XtI6JDT4EZNJvPc1LWWG+iQnZEGqL4tdjjYxg0XMFvYmbUTQEV51TxGGtQagXPpOrbUtqSYEX9IBSCCubLoeUZ+brccnGkVMVeEt+ai1fRvSWBtYxMUn9ovijpC9wcsmqSR0RwomI5yjsjMBaxiiBA1Cj8W6zWNbOO6XdoSHYUrzoC8oGw2xmDMRfSSS4XlP3B9S/NtmJSwfdt3kAcsEK2F5bdkP2TQD7vd2I39kVmk88s6gtT4GvUwRebLKYMS/5N/djidVXkpoNNd7PNU1ZTaHm1KAn2rPV0CdfP5WuUfHPodsFq8x/4EnJZSwCIXANlnMj4LR38cRukOMtp1DinZFXOhKtpwJmAiJhDqVYxUEJUUMfSlZ8s+Zf40P01SyREPSa3R/Mv+OJUhTsKTZwrdztAdOZK9NNKHGJnHHWwHzUiK5+hUDWSW30lury7erFb05twC5I/7Ke1HiiTxl5vHMhgcveRvri1+J/LiqktwC+VDhTw1yJpWmch9jQ6MZyPBTxOE9uX
 x+gBoY5K
 sDlM2pnpyEDLvKyo8PyPepWVya73OgoPlXtqLwXf5w6PvnhmMr5lszpBsAGbZomq6B7iqJplYc4BSEjAAe1zKsHExekyTudM0LIrKTfwwQ99U0lC950bbF9GS6ekutspvx8vG9x+bzpe8LfAwA8dTQXgdpeeZYOPbFYHaF/1IhzsRshfNdIt7Em3pLQm89k5Cb/Mb8pzmwgSqAfruzspGapzuh11smuCjPIjuIbknn/6hbGoYgMPa6/e7eg1+B6kWZwFHO0mqKLIjtANcfvKk7AV/YCc0p/q3CdyH0V5RNIol22xsE3zXKz4LiCcH1zl/43wmRIteLM+zMzZlgmW6CSsO1HrRE60BeyKDpQ21153Gwi4pFCY2uTEGO9oEeyk7EBplfSmVozZTXsYtXIIuWkykGY+RmNZn5eStksPpR2fh4GJYGeEQxaZqVR02PzxV6/IJgLPJ8JfqVckCxuqMCkoS5Oexkv4jKUqxHnLsV99f7bTEm0belUtXodPtsyS2rTKpDcrpoVFbfEm49XhZJhOo8ryBCO1/In/Dsa0EjoEuupZLdFoh5b+0v+BT/7F4oF4RTgqpe3oqyd52AkeTXvabhcaUAhj8NF+8usdbTnbzXofEbfMZp3vcawPTejTn/59E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a shortcut for this fairly long expression that we'll start using a
bit more soon.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/memcontrol.h | 10 ++++++++++
 mm/page_io.c               |  7 +------
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index bf1a6e131eca..997e244695f1 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1771,6 +1771,11 @@ static inline bool memcg_is_dying(struct mem_cgroup *memcg)
 	return memcg ? css_is_dying(&memcg->css) : false;
 }
 
+static inline struct cgroup_subsys_state *folio_memcg_css(struct folio *folio)
+{
+	return cgroup_e_css(folio_memcg(folio)->css.cgroup, &io_cgrp_subsys);
+}
+
 #else
 static inline bool mem_cgroup_kmem_disabled(void)
 {
@@ -1846,6 +1851,11 @@ static inline bool memcg_is_dying(struct mem_cgroup *memcg)
 {
 	return false;
 }
+
+static inline struct cgroup_subsys_state *folio_memcg_css(struct folio *folio)
+{
+	return NULL;
+}
 #endif /* CONFIG_MEMCG */
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
diff --git a/mm/page_io.c b/mm/page_io.c
index 1aca1b0231b1..003c0bf151f9 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -318,16 +318,11 @@ static inline void count_swpout_vm_event(struct folio *folio)
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
 static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
 {
-	struct cgroup_subsys_state *css;
-	struct mem_cgroup *memcg;
-
 	if (!folio_memcg_charged(folio))
 		return;
 
 	rcu_read_lock();
-	memcg = folio_memcg(folio);
-	css = cgroup_e_css(memcg->css.cgroup, &io_cgrp_subsys);
-	bio_associate_blkg_from_css(bio, css);
+	bio_associate_blkg_from_css(bio, folio_memcg_css(folio));
 	rcu_read_unlock();
 }
 #else
-- 
2.53.0


