Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C520C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 00:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2C756B00A7; Tue,  5 Aug 2025 20:11:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D03B16B00A8; Tue,  5 Aug 2025 20:11:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF41D6B00A9; Tue,  5 Aug 2025 20:11:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA8B96B00A7
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 20:11:02 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1F86A140299
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:11:02 +0000 (UTC)
X-FDA: 83744402364.29.4FECE89
Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1330CA0010
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:10:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="G GrF1uO";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=oCbDjzsH;
	spf=pass (imf25.hostedemail.com: domain of boris@bur.io designates 202.12.124.146 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754439060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NMkug1PZF2QAfivblMu+w2TJxSj/x/jO/BIhiNhgEAg=;
	b=Rn84D06xFNZEuR1sZzgc5YWYEuEeynjK4QBNES0nhMYs1O/bgiiFRTG40o9p3xdp9aFTxg
	JF0A4MFk5zU+ANIh52DhL6PVIq3//rX+aYbUzS8d/MaRqTUHzml7c8C+mMCpsTtd3QYgbo
	T5rzKqLyWns+1mmGMnKMDXhzQoHnG0Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754439060; a=rsa-sha256;
	cv=none;
	b=HbdqY+9faJIL3OEvWYHHUm+CrAtSxpsBUOquFJVO5UxG4SNvV9BwdY7F7p+srfnX75QAob
	GTn7/B2afBtUFp/2kPwluGHHEXm1Aonqh8W/NuzoXxDp7i6bBpO+6VkueVWsQIw1xn9jpy
	uQgYdSvr1CRDhyUSLcmZ5QWJt7Y0rg8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bur.io header.s=fm1 header.b="G GrF1uO";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=oCbDjzsH;
	spf=pass (imf25.hostedemail.com: domain of boris@bur.io designates 202.12.124.146 as permitted sender) smtp.mailfrom=boris@bur.io;
	dmarc=none
Received: from phl-compute-04.internal (phl-compute-04.phl.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 203B01D0024E;
	Tue,  5 Aug 2025 20:10:59 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 05 Aug 2025 20:10:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1754439058; x=
	1754525458; bh=NMkug1PZF2QAfivblMu+w2TJxSj/x/jO/BIhiNhgEAg=; b=G
	GrF1uOWR5MDmu7iedNKmcnSawwxfou0p9UqxNUMBsMWsuN9wRlwLxjnTo8m3zc5M
	nObp6f1faws8totu9es1+Nq52vloBczQevQhH8ZxlC9A4GzaqL1LYym8dihZt4AG
	vfSvVtgEhXyUjtyfvCrHUr4YouyNOCyzeXEGNhuK6KA/2RUWHYa9U6ydKI5F2E3H
	dgmpo/jSYMLYlpLjiRf7N6QRxHR8QqbZMhdMR4agv+zpVt5dEu3Tyy1Xl1klypjh
	O8wureZFYxLFksMtxWLt1afrCJqhNlKX+1hD4Cxy6mGhIxYVUGutKxD0jI0S9Aq+
	Hmr5Z8cxRf/tJUQ7C1tBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1754439058; x=1754525458; bh=N
	Mkug1PZF2QAfivblMu+w2TJxSj/x/jO/BIhiNhgEAg=; b=oCbDjzsHAuG03l79C
	ajpGywvRrJXz6UmB5jHjrxwxBZCo18XD996ekP1Ax2tOZ6M40HSzyE1hDng/R783
	komopR2kWdj6E+g897Tm5EbAEs+E5aNTgidojpdextoZChI7YTEIcz1EdeJcCqvs
	bLDBGbHi881Ew/0XSubf9uO/Om+vOcz/Hz/nax4pUQPbF/m17RaBXVPIQSZiB1Xk
	A87vYvZGD5VGwX8zxAp5WFuKJc7gr2YEWEdj7EMiRr7qoeYS+zQzvb0tpy9HL1cd
	Tpdn+hsxUQYS6NAoBUstLu00fQ1ncM1Z+y+H/0CP0ykippQyZlXA6mgqkXl/33KS
	qJ5Pg==
X-ME-Sender: <xms:kp2SaC3BqECAlvdzvihEOwcVdywbPvMCZbJr65QywvgXlDCrYYvAJQ>
    <xme:kp2SaI6CmYjwXaxPVmfIEeyfgIhWTW_9FhJFkpl7rNY0c1LAxupaAW41nY2a3D_ZB
    ydFKVWytRBbyQTmxh8>
X-ME-Received: <xmr:kp2SaD-K3eXlK0-EjR7TgNI9O5VKDh_FjhZf3170KuvvF7fq3CYi5YJFvBUKW1sXSJRxRZwQ3Cop9r_wmWopb44hkwA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgdduudeiheekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucgoufhorhhtvggutfgvtghiphdvucdlgedtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeeuohhrihhsuceu
    uhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepgedute
    ffveeileetueejheevveeugfdttddvgfeijefhjeetjeduffehkeelkeehnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessghurh
    drihhopdhnsggprhgtphhtthhopeejpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    pehlihhnuhigqdgsthhrfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    eplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtoheplhhinhhugidqfhhs
    uggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehkvghrnhgvlh
    dqthgvrghmsehfsgdrtghomhdprhgtphhtthhopehshhgrkhgvvghlrdgsuhhttheslhhi
    nhhugidruggvvhdprhgtphhtthhopehhtghhsehinhhfrhgruggvrggurdhorhhgpdhrtg
    hpthhtohepfihquhesshhushgvrdgtohhm
X-ME-Proxy: <xmx:kp2SaHXSdnG8j0oyDfF47wPag9u3kOVwos43rOmYwk5XHOVB09rogQ>
    <xmx:kp2SaOq08RiY7n4O0xhXWeZEeDUWPTNU9nZq3HPhD2W0Z6bpMZxlrg>
    <xmx:kp2SaJkBuQ4R7P3Pqtpl2E7qLOE9BfiaaxtdcAYPnEeCdO0pQ1Dcrg>
    <xmx:kp2SaO1BKhjA8M96K5tUgLGc9nojcxjeIwFDG54kkIR9mMFMoouE8w>
    <xmx:kp2SaN0JikDm19k-l6Qrs5Hr9cu60wHcs0cLP3wEbCb6rG-sS0NsJUWT>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 5 Aug 2025 20:10:58 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@fb.com
Cc: shakeel.butt@linux.dev,
	hch@infradead.org,
	wqu@suse.com
Subject: [PATCH 3/3] mm: add vmstat for cgroup uncharged pages
Date: Tue,  5 Aug 2025 17:11:49 -0700
Message-ID: <eae30d630ba07de8966d09a3e1700f53715980c2.1754438418.git.boris@bur.io>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754438418.git.boris@bur.io>
References: <cover.1754438418.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1330CA0010
X-Stat-Signature: buni7iw4n6646ybasy86eyfeyh7opb4q
X-Rspam-User: 
X-HE-Tag: 1754439059-678535
X-HE-Meta: U2FsdGVkX1+PYcTBrzW6EbUw8+/8+dkXdtJATD8VrpiLSwyLaq4iwd+NeJBhIkfjtqloUjd33OyIELs8lwuaXrb+F2bjMOJQZVKcrv0BojhmVGxb5u7966IZE5i3gn1TCjRS5meguNrEE8cr4QcxSk5MrBB42MNglRuD8IYKrv7VRcFg3TBlMUkKRHPAy0pXueINaksGfPTvEVuTQi4cZd07tA0tuQEJDAQwIYo2MiAQqoETt72N3LPySDHBDXplEE4VKfF6uNSasTi4hO9qHAsjESHnwTqZu0W8okzVMb8lQKG/ik8LNnSL4MQnRsI6WWjirOWZ93TkwqdI5Lu4vyVQyTf5/r8c8M/SaGu6QaGYTeXSieOUGpKgKQ7Xnxfaa8r0dSCigDJ3Ihu2DO+usLRwotGFcEtscFm7gNZVOKpXUlNTzMFEEEeONcJbl1uEntNGeMv6CaRM5hOXZzlRvMv67KdSAIDh6CAD1xw0zU++4eq09ykGtwPlpp5+5AwkuYvUSzheIEi9SrkFFVe+4OGm/fwgF9NA115pqoj7/LOuxhx0b6zLBpX+5N+qyPlDMHcuNh/CwqXw4CbVL58Ly13c2xg7hHmIlOg4EQQ2ScAp09A28Ad8B9lKLfoCjolS/Nf5vkzFr9dU5MOhJwauSfO2aSkNLcckKYKhomAV78MOpFwB/foM/mfzYl7fNdmodcbbRSkEf3Nu5hxg9vicUYOXuximgNuGRyhZOY0eS4dKjQwR4eEd2leC0hMV0KxyhfUroGE6dCjvNORsxcD3MbLtGrGtbIcYhwgq46BGeGI3mG1RO+trwAV8EY0/237c4Pq+q/3XEKLw1d752O+0dCCMbIv8PyLcXVv2C1fpixgNBtzH85u+saCwCjl8zZAEKz6tWURRTGOBeMMLbU6wmUhkIjbG2or8hCou5M3Zw5sl7gSA3bShdJ86g6s+4uMcaAPwF53t9HTwDD7JiiW
 JivHEils
 qVN9xQPTWQhRsztzOJxQ/n5nTL8yVKGVn1v/QfnvmKdfpWUqHjgrcSEKrWVHkFYV3FLzKLvDWxvQ+WOo6VOqxDKbZTtphohR3VSkiu5bxZ258K80G4qJJB1UOTGogiWMwB1rQySaBXrmMgElquR6whWJOaKgN4Lh0G9O45QCOy269rbtZ9jzRgG9uGldhuESe9IODNSvvE6XOQ9Porgd499/l4VqYwmZfghg4/6ta2OLRC17+ke7jvTgQdpbmKSr8xMVtmYhrD8gPpVMVa0AF+2t8sPhshnjUgFjQsqBiFjKFQs5pmBkw9SYgkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If cgroups are configured into the kernel, then uncharged pages can only
come from filemap_add_folio_nocharge. Track such uncharged folios in
vmstat so that they are accounted for.

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Boris Burkov <boris@bur.io>
---
 include/linux/mmzone.h |  3 +++
 mm/filemap.c           | 18 ++++++++++++++++++
 mm/vmstat.c            |  3 +++
 3 files changed, 24 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 283913d42d7b..a945dec65371 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -241,6 +241,9 @@ enum node_stat_item {
 	NR_HUGETLB,
 #endif
 	NR_BALLOON_PAGES,
+#ifdef CONFIG_MEMCG
+	NR_UNCHARGED_FILE_PAGES,
+#endif
 	NR_VM_NODE_STAT_ITEMS
 };
 
diff --git a/mm/filemap.c b/mm/filemap.c
index ccc9cfb4d418..0a258b4a9246 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -146,6 +146,22 @@ static void page_cache_delete(struct address_space *mapping,
 	mapping->nrpages -= nr;
 }
 
+#ifdef CONFIG_MEMCG
+static void filemap_mod_uncharged_vmstat(struct folio *folio, int sign)
+{
+	long nr = folio_nr_pages(folio) * sign;
+
+	if (!folio_memcg(folio))
+		__lruvec_stat_mod_folio(folio, NR_UNCHARGED_FILE_PAGES, nr);
+}
+#else
+static void filemap_mod_uncharged_cgroup_vmstat(struct folio *folio, int sign)
+{
+	return;
+}
+#endif
+
+
 static void filemap_unaccount_folio(struct address_space *mapping,
 		struct folio *folio)
 {
@@ -190,6 +206,7 @@ static void filemap_unaccount_folio(struct address_space *mapping,
 		__lruvec_stat_mod_folio(folio, NR_FILE_THPS, -nr);
 		filemap_nr_thps_dec(mapping);
 	}
+	filemap_mod_uncharged_vmstat(folio, -1);
 
 	/*
 	 * At this point folio must be either written or cleaned by
@@ -978,6 +995,7 @@ int filemap_add_folio_nocharge(struct address_space *mapping, struct folio *foli
 		if (!(gfp & __GFP_WRITE) && shadow)
 			workingset_refault(folio, shadow);
 		folio_add_lru(folio);
+		filemap_mod_uncharged_vmstat(folio, 1);
 	}
 	return ret;
 }
diff --git a/mm/vmstat.c b/mm/vmstat.c
index a78d70ddeacd..63318742ae5a 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1281,6 +1281,9 @@ const char * const vmstat_text[] = {
 	"nr_hugetlb",
 #endif
 	"nr_balloon_pages",
+#ifdef CONFIG_MEMCG
+	"nr_uncharged_file_pages",
+#endif
 	/* system-wide enum vm_stat_item counters */
 	"nr_dirty_threshold",
 	"nr_dirty_background_threshold",
-- 
2.50.1


