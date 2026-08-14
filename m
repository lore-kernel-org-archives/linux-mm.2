Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 446D2C5DF66
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 01:30:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79EBA6B02DB; Thu, 13 Aug 2026 21:30:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 729166B02DC; Thu, 13 Aug 2026 21:30:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5548F6B02DD; Thu, 13 Aug 2026 21:30:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B2826B02DB
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:30:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9A688A0168
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 01:29:59 +0000 (UTC)
X-FDA: 85098143718.24.546E485
Received: from mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6AA2B140008
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 01:29:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DY1hXoZ6;
	spf=pass (imf09.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.175 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786670998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EkRV9cT8eTIGpK9Mjpl/pEyiUXlLpQy8HBJVP7Kwx8w=;
	b=sAg9ejqlj4kv5lkqpLmCYHnxvfpaVCPp7ofLWj4aRc6P6v22eJtLbO0Jr1cVShy/5RYfMT
	/taU+PmjckweNqk30IEwtg7yV/qF87lMt2sNHyRvNES9IkDsPoi+neICTVXd+sWsvQaMUB
	PE6MOepGr1NgYP5WsTmlQMViToUUIIE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DY1hXoZ6;
	spf=pass (imf09.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.175 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786670998;
	b=wLzdt02nkO5GdFltgx2J+XjfPde3G2WV0qfg2Sx3R8ewHhp/KX+cCqq8r0TmZZaQhkFaRB
	X6quVYoSfljSx4usJDUf695Lymb3+GPwzrVmHwyHZMRpCXV67WWasVw7/ez8a97Cz86zKI
	c9tD95z8VQNrMWBPfu2j4jQHQQFzfp0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=mJVpl+4xZO80M/OyNFMbUx08bRvBm8AGaGXAAVqZKA8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786670996; v=1; x=1787275796;
 b=DY1hXoZ6vTmcsBXsYod4ZqC5V+KXAxrFf57kesxFOQRMAENF5GuaCE468aJspN4VQLLlo+Ap
 Jr55opKuLFMIdV0AsWfgBLpWHaQjZ8ZecWNZs2GpwEy5+/20NvtaFm7xValiZLcPgy6Y/+9RJuV
 GtsLoq8sF0YTHVmmZx+SwOzg=
X-Envelope-To: linux-mm@kvack.org
Received: from mi-ThinkCentre-M760t.mioffice.cn (14.29.108.92)
	by smtp.migadu.com with ESMTPS id b69033f2e9e602e1;
	Fri, 14 Aug 2026 01:29:56 +0000
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	David Finkel <davidf@vimeo.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-kernel@vger.kernel.org,
	Tao Cui <cuitao@kylinos.cn>,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v3 2/2] mm, memcg: fix memory.peak reset clobbering other fds' watermark
Date: Fri, 14 Aug 2026 09:29:24 +0800
Message-Id: <20260814012924.2388613-3-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260814012924.2388613-1-ridong.chen@linux.dev>
References: <20260814012924.2388613-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6AA2B140008
X-Stat-Signature: wwj6cm6654r8eq4d58ekzu7myd63tmym
X-Rspam-User: 
X-HE-Tag: 1786670997-355280
X-HE-Meta: U2FsdGVkX19scD/Tmx2iaItcB1zFAqnTPpRVMxmQu8vh6csLgs6PyeInU31BXDERlvgC4qTgPU13J4/3a5YIUhHxRZnzB5vZ7yncwYJkb0p6ORdk1vAANHHiDjkN2RZamP36Lx6I59MWwRT0gcmxB/z50jLhVvD5llDNYvGCDH7nrMaiGqMAh8U235xQDcXsPMQpVJm5yxdlx2WcK87RJhAyjfWUy5nJefR2kWQd2djaXwrDXLvvA/oFHeT0/ZlipVhnr0gtKkQPKeoD/9NodFDTXWoYVtDFNG0jxS+FnLd+znjXO1wNTFgYy6uDg60L6pUWvS1/TiLBlnWE1lCbRss3lK9346uY/7vn3ZyS2DRjWPgq4OlEmQNxdh2wSd4Ywisg2V7uwFvoVsbZ5cmaQekoo41IBV9SVd3QkFnWE6yhfnJ0pj80nTZsddtMLNB9Pqf40AKwmgQH+RqSW+7jKRacePoAR/XQXAU6KeJ/TOWmEpzKj4GlwlMW5ghxYx8mJKdRO1Gt+HStOaO2zIvS4IJ62gu0ej1n2y7Wg8d4pfeeDTLSIMyYlAlZC0g69yxxQ+h592Vz0Zz5hUWGu6KGm1zCtX+lAyFMcBYQ0IxcM+3Ga54cqt3zIKO4ev5wTaaGXxMNhK9nZDF4+67M9BVnX9hiIDZauDhitlJH28FFDPlFEFM70BlsMox91D1DxPgy7VmHR53gF+FKCVext0mmLf2vdTmIoof48QnzqPRZjHEyESCVmG8lkuHswoucmS0YgfTVEqQWOV0Y+B5PnjnVGMRVdTKgIzi2JU1nrvXVZk0KWm9dX10sj85WKp93Vb3xKtxlfQVCdWWhXnqOEKVTsPBHAClK7JGm21BnTBIyNg64s4hR7CEmxECFAdkTtPI1TeQjtFpw4R6lxocFMCqZiRXotuwNgHsSpYcb7PpTxg6RN7aW2nJ+W+fibp+uaPaFbTGUIqZm8+MdCWOUhqE
 Ej0XdEZv
 i7pTtNbsS+fhTl/jNpEkewV8e9p9ecp/jItVTfDC6X3IfhzmILnwyGt8aI5O+Lp70B0Y3NcjbBXt9gJReQeAf7HJgWAJT1qUnrGsMG3nL/9esfNIcY1fZTO/ZLtPg1PBdg7uSPUl6vrohPvJ1EoexHKASjpqJu0ZX48n4hDsumQnY4QSCHFWJNiR0E6VomlNrsnQR630lpZIE0/ED5mfQEEvP3s2gCHyZ6bm4V2AeubUWk7HEekp4JJlLJBWFD4jSIJjZH5+kepGtMRDyLInO9rh10hFdOa6NIGgh2Fjv27GSbR3u+luff9IQN+wonMJA72nagYLEVEnAZiPgPRppyyI7FhOEUNuyiOVSAA+noFP9rRTayfe+oPws7yFUQpZSydSsfW2qmVaepbLvEAF2fgmv4YksC4BWYH90wcMC7RuPoOQgsgKalMLUc7qgvVBSV2ulxQRPJljsBtymbp5H3A17f43qK/htqP40tmbxKYVwIFjL161kQdjHEwBpi+8Zecq+e+bvN8y6I/TvY9gr6u7cdhjtSi+ZMYvR9mdxuwmSdp7zVMPAUdMV4GvpKrwkvmC7Z7ay/T1pKc+z9tNe/lSP+xK21TuQsTHZx54ejw1IEK19Rvr+2TyGhm4bNJsMB/Gb4BJ73/PgGr58GzlZJd0suWf26cYpZrCUJJM7eBXHBNq3etkeA8yFpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

Writing to memory.peak resets the peak for that fd only. Each fd is a
watcher and reads back max(its own value, the shared local_watermark).

peak_write() resets by lowering local_watermark to the current usage.
To keep the other watchers' peaks it then walks the watcher list, but it
stores the current usage into them instead of the old watermark. So once
usage has dropped from a peak, a reset on one fd wrongly drags every
other fd's peak down too, even fds that never reset.

Reproduced on 7.2.0-rc5-next under QEMU, two fds A and B on one cgroup:
B sees the peak (410624 KB), usage drops, then A resets -- and B's peak
collapses to 1060 KB although B never reset. With this patch B keeps
reading 410624 KB.

Fix: save the old watermark before lowering it and use that to floor the
other watchers, so a reset only affects the fd that issued it.

Fixes: c6f53ed8f213 ("mm, memcg: cg2 memory{.swap,}.peak write handlers")
Closes: https://sashiko.dev/#/patchset/20260807090000.1532495-1-ridong.chen@linux.dev
Assisted-by: Claude:claude-opus-4-8
Acked-by: Tao Cui <cuitao@kylinos.cn>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 mm/memcontrol.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dd8756870ff..5e5edc988119 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4748,7 +4748,7 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
 			  loff_t off, struct page_counter *pc,
 			  struct list_head *watchers)
 {
-	unsigned long usage;
+	unsigned long usage, old_watermark;
 	struct cgroup_of_peak *peer_ctx;
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
 	struct cgroup_of_peak *ofp = of_peak(of);
@@ -4756,11 +4756,12 @@ static ssize_t peak_write(struct kernfs_open_file *of, char *buf, size_t nbytes,
 	spin_lock(&memcg->peaks_lock);
 
 	usage = page_counter_read(pc);
+	old_watermark = READ_ONCE(pc->local_watermark);
 	WRITE_ONCE(pc->local_watermark, usage);
 
 	list_for_each_entry(peer_ctx, watchers, list)
-		if (usage > peer_ctx->value)
-			WRITE_ONCE(peer_ctx->value, usage);
+		if (peer_ctx != ofp && old_watermark > peer_ctx->value)
+			WRITE_ONCE(peer_ctx->value, old_watermark);
 
 	/* initial write, register watcher */
 	if (ofp->value == OFP_PEAK_UNSET)
-- 
2.34.1


