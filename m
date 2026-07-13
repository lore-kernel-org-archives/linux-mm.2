Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13864C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 08:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDA0E6B008A; Mon, 13 Jul 2026 04:51:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E64656B008C; Mon, 13 Jul 2026 04:51:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D54856B0092; Mon, 13 Jul 2026 04:51:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE0A36B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 04:51:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23910C8217
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:51:16 +0000 (UTC)
X-FDA: 84983134152.13.8873728
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5DB3A40003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:51:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YFbttWYz;
	spf=pass (imf07.hostedemail.com: domain of guopeng.zhang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783932674;
	b=7vD3ppq8lY6gF2u0fKDLAbc/c618MQCFDQDLXvBoINtlkJ48WINOwlaQPsrCO5TkCfcEzX
	VR/5mDSFwxGQdpmYDgZCZ8yNu0T05Taj08dIL6qosPn4Aq/PE6TYoWo5+1kfOep3t+MaI1
	BpfPNbbodkBtqFTGcs0yEPLW+DUbj5c=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YFbttWYz;
	spf=pass (imf07.hostedemail.com: domain of guopeng.zhang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783932674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6M0rnHHSOu73KIHVgHsaucxNbMa7/bd9HvhJ1ASs3fI=;
	b=xSLep8PLOL4XKKluAEjLS6znD/weo47FzRxdHiVP4EvrqE9LPPMtvp1SXFuR7uH6fwn70Y
	pW8LULXc+SPvulI7pAlbs8Z94AVJOQjlnVd214SVms4+2g7itD7Zo2xdIexnY1KmFYKITv
	QMZ/fRYh6+4qIwrp57kWG53rh5kL7JM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783932672;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6M0rnHHSOu73KIHVgHsaucxNbMa7/bd9HvhJ1ASs3fI=;
	b=YFbttWYzCN6AS81vKL8HDEaktJR5eLQ01C5Tt79DZbw9nxJvTlyfzrvLOZlLRvgBRBQpUW
	xkCoAT/Vt2Lw+A/ZlhsZq1e9Aou7lN7TDCSa508sU4LKhFdIWbPJV4j8V5PH8THv5gqFs9
	c/tb3vqRNNWVH+sMh5Qb6szf4W5ZDj8=
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH] mm: memcontrol: update state_local when flushing NMI stats
Date: Mon, 13 Jul 2026 16:50:53 +0800
Message-ID: <20260713085053.2916813-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5DB3A40003
X-Stat-Signature: k1c7hjms4joiu1bburhmewnzx7oshd8s
X-HE-Tag: 1783932674-130845
X-HE-Meta: U2FsdGVkX1+yffmp0sCoJvKFomI6KjDnq0ypX9W4toWPmcAmcCbbINPlFz0iZupgHQaGmbImFYv9h1W21ff2A/ZABVdXBU1ycPhy+7AKKO+8BMCeWNWOzicP/AyeUT5/3CM3TnqNqL0bqkWQfNLZfKp8pkt2k/ymdxxEoyIli4BrUl1TMrSvqq8xCPoklqEKUhXGVb67wRUl+FHytS8VAKTLb9rD2qz7F9Kj6KizlwsVnF8pPzhbfGYmnvu9Yr8MpE2vLI0kqIlNiVgBh/RKNSn9gVxT3F/eMZkDmQ/F8twqnSIvUE0FPw7f3t70dhx0obefVGYxRUeH0AVy9GAhaUFsYAqbgEfBtmKUYW6zATaNxXHjLOgoyV7t6vg36EU4e/JJWws2gJ6YiXY815p39zGDH4NkUNkz77ugQhECF47kn4vIvY79ZMXdjuUW3E4/KxASv2jTSRT719QtbG60yX8DK55rhBIai/mSPTsFH1WKOSyMMQKUq2DwR2XxMgZRM1Lx8QNRL4MBVe1V9xogdp5YBdlKWbYZoJjsbfJqxib/Ym7n9pAzufbShGwGMPmLqgzjvqPAeZTLHQl6s2dd8nflzSh1C7DM6DKTceRoywS31Q5zTlWU8+E4gS/c2aY7B/Se1Cnw+u6vsBskR7f1EEgNuctp6ll7bsW43ubdvlS+XlGxf9F1LE4T5o7ND/Aqx0rk5jQsWp5UjxfVIm86+6iYqLjmJRu0RUvQ/qiEVRE9nK6PvGVGtn4xmqyqlgnQW3xQ/rhOuzkYqUkmrzUinXTD3y5brJJ+X4zhOz/gZNDyEzDktLdfYKCWSTnxBHez9mU6+uSr3a6PyqDJtmgp+y6Sxw2CJs3qDbWk85r3iva6rggCc8dHi7SmBJCHkaLZXSYGB0WF5U2L/soZXoa80NFJLG6URMNIUz59flgAfSaQZsP7p/+T69n0/ptTl4lrMUqhMmkRjxx+wr/uTaN
 phOjJKTV
 RsQLsEXxVDgXsh259RWuU/1kz7rhXtzLjFD0PLJbdREeeCz9UbWCu6EOSMOcygVnNMiazle6HupYwSIMWxC/7W0Nr0uyQkGmgAmFQ8RpjERM6h2cFrnzZLYBir73MRybyPVR4KujpTdtjyAQ2i1BBxqHKWWzyxNvJYMzEeLqj+hO87Gh+fqrCZBFPuuA6PENgU2+/oCF8LC8MbwBJ/py4WZ6Y3kCbgqYWlVA1jFGOCayb2expDiCdBZ4PHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

flush_nmi_stats() updates state[] for kmem and slab counters but leaves
the corresponding state_local[] counters unchanged. Local kmem and
slab statistics therefore miss updates collected through the NMI-safe
atomic path.

Update state_local[] together with state[].

Fixes: 940b01fc8dc1 ("memcg: nmi safe memcg stats for specific archs")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 mm/memcontrol.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 22f55aeb94f3..02599b8b6bd5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4443,6 +4443,7 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent,
 		int index = memcg_stats_index(MEMCG_KMEM);
 
 		memcg->vmstats->state[index] += kmem;
+		memcg->vmstats->state_local[index] += kmem;
 		if (parent)
 			parent->vmstats->state_pending[index] += kmem;
 	}
@@ -4460,9 +4461,11 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent,
 			int index = memcg_stats_index(NR_SLAB_RECLAIMABLE_B);
 
 			lstats->state[index] += slab;
+			lstats->state_local[index] += slab;
 			if (plstats)
 				plstats->state_pending[index] += slab;
 			memcg->vmstats->state[index] += slab;
+			memcg->vmstats->state_local[index] += slab;
 			if (parent)
 				parent->vmstats->state_pending[index] += slab;
 		}
@@ -4471,9 +4474,11 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent,
 			int index = memcg_stats_index(NR_SLAB_UNRECLAIMABLE_B);
 
 			lstats->state[index] += slab;
+			lstats->state_local[index] += slab;
 			if (plstats)
 				plstats->state_pending[index] += slab;
 			memcg->vmstats->state[index] += slab;
+			memcg->vmstats->state_local[index] += slab;
 			if (parent)
 				parent->vmstats->state_pending[index] += slab;
 		}
-- 
2.43.0


