Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35ACDCD484E
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 20:22:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99FFE6B00C3; Mon, 11 May 2026 16:22:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 955746B00C4; Mon, 11 May 2026 16:22:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83F636B00C5; Mon, 11 May 2026 16:22:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6F73C6B00C3
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:22:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0A96785B0C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 20:22:56 +0000 (UTC)
X-FDA: 84756262752.14.E8E6A07
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	by imf26.hostedemail.com (Postfix) with ESMTP id EC871140011
	for <linux-mm@kvack.org>; Mon, 11 May 2026 20:22:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.198 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778530974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vtzBRoA5n6IESGTjQR87JdK9shr/MOhzg/Se/qSUoQk=;
	b=1k+iqXYiZnTdtVde9J4a3O+V+4pfFQT+wsKecqYE99RwYrwREReH1lg4TBZbCmAMtPNZs4
	Ly6d9SnlQ/55zTCtGfcqv22mQksBcs1Iuri2FV5Cv4VFnyPENO4/5eA3LmiPNfo3ICfkjT
	nR71Onu80V7r8iZC8SqRyblZNynVKLY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778530974; a=rsa-sha256;
	cv=none;
	b=3Mau67fZcGjSmtTLsrY1nHC2wmoppw6xrTc15tYozpn9SOOha3gc5x3wdctwUw8xXUdl+g
	l0h0PZIAMQn6+WG5bn6QgKWg+QBDt6zYbui+ZyWRTTvdDVR2YIivzeej21TjvOWTWYWiHQ
	0qhb3Vp03DaASdP1isuWsNZKNp+cfzw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.198 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id AF36C3ED2B;
	Mon, 11 May 2026 20:22:47 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH 1/8] mm: memcontrol: propagate NMI slab stats to memcg vmstats
Date: Mon, 11 May 2026 22:20:36 +0200
Message-ID: <20260511202136.330358-2-alex@ghiti.fr>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260511202136.330358-1-alex@ghiti.fr>
References: <20260511202136.330358-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTEKdSC5n47cMxx7+E6xIcuuqMdhUwWhsmhYP0l1q/lL120dThEiR8vb0TiEqhY42A2jPimP5jU/Hm0hGDMno175lLcPytRQJKdldhMsQt6RKWRnwi5uj+7Fz//srcwN3JM6xfrPe93Kmskbbh6XnUYrgM/FTVmCaDrz/0m9ROXr6uVhqG9eyFnOYs1gvA8enM+zyzmByTi7t2LVsTGJjtQGh7t7IHfie/kQmD9bBx9sjOPfZAyTGWUiv6GvKGuseIvPIQs97zGR0NteRVRP95Qqs1VoYF4GH4W6YoIEL9NhmCvSnS5WjCx0nn+v9kQeX4YAgUsLIIKoDX5j6QPthtreg0WrEdOETloX0nHU9QhFkusicJofCoJUaSZJXLcCr3ipFEeJ3E7V1DOQZ31F//5TvDzDBhidPN7NE6DOthjYDol0pyFj4b68FbfFVbwBJvZZDmqots2dvQU1F9tMPbZ0KNLMXGEjnYh5jY9TmHMi8QJcUJPv6R/PHTGe7VuzMDYVUAYEySv3jvZOtiOUX+3BLehOQAdl+y+lDol799VHPQ1GiQTOOyJnUjkI39gp4v6hWPmEvUMxUntR7QxPhqvhnMyoKWukhmEuywJfRLQhc5zfyz4Ni2LLQb9MA8om6nkBITcQCDZuU4F2IlNOslNIR3WBk/YqbbxI7Zos7XD32A
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EC871140011
X-Stat-Signature: mmxw1nfn1koemikmju1fmiyeo39drhaz
X-Rspam-User: 
X-HE-Tag: 1778530973-795813
X-HE-Meta: U2FsdGVkX1919Q7U4jie3sytsV6pFkYhLN9AdZ0dX0WwktGRaZtQQAxM1mfHjF7KzBj8qBNOB+SB72LtsAVCiVVd/nbJD+e4pujmEEJkNFfH4eEzYKBhWUvsStmXuCo0DaeP3JLPtd2fG0Z0VSUcE2eA408yMrrEtnuHmXBjj9QXatct+qXsVOAI6TxqsMK5N3DG0QLLsimgUDhYjHB+Ga3i7nAGxvqhZyTiBmtbsc7VyJrBEzJch7ro7ndKWpMzysWsdkL+ph7XM5WHHQHsfQG7tSmQL9up62cXTuiBFBi1t8hKifgCStCmgnRIjSc/oue4Wf2WsXNo+t4gQDCOgoXyn1TJ2bLjx8dXsgR5f/tT1ySrXtLFxBRiktnbn5nH3EicOrcFLHMOMzvUmOoCCNfQUnRyzvS0maK/cb+yDYdQjPlLKGre+M6fH+/Bb1nFCWUBbUndXhTmrFmedXwq9b5WgySlLlhbUJ9Z35FxiNHSvKD47Ry+WUjKvXPFFKa/Ia2hVb4mbjeGrGuZu1gna07WGRMHHk8oyxeTo7PLRDomIgNv7GahTILwof/Q9P7ZRnVL/BZKgf1SvdkYFP8VwyYuyvD9AzPNZhLZNrvONXtIp/DSXCgTU+EJz2HHRyJPV9jkJKZSjA7ry2snYOrX/DXp+p+Sp3pfG6hEUIVJvKUgn0IF0QYPq+z0qOoy1Q2IVAsUZRqQRu+76YbyZZGnl8mL90glFqvj+zlA8x39grwEBbqwjUC4BTDse7pto5/dtZOIXZMK5LhTMxVrZDCXfCI+TtJgTMuRhNJmPk8JULpYzdbwf99vZ8GSH9QunsmdnSnH5TnKX0Y+3MHTkT989HlgLfftZwi10V5df/YWGKY9fZfuZrHyXIfzp59DoA1yNs9XcjdPoo9AZfgwjT5OPXkFUaF7v5DOpAdkLVMyvxMnH1/Yh15dhgvJVTdoQApT47CtiS9HMk+QQOPmsxs
 u8Um+VMG
 0eZHEgDcPtHti8V7AbU279GGdPkytTDEbXzDkre6UMdSqmUuBwAN7ctvb+ANTEjIPJ0MWa8EWQhM5gBd3pQVDHtoTTF96Y68kihfPS+4TguSPQJs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

flush_nmi_stats() drains per-node NMI slab atomics into the per-node
lruvec_stats, but does not propagate them to the memcg-level vmstats.

This is inconsistent with account_slab_nmi_safe() which updates both,
so fix this by propagating the NMI slab stats to the memcg-level vmstats.

Fixes: 940b01fc8dc1 ("memcg: nmi safe memcg stats for specific archs")
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/memcontrol.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c3d98ab41f1f..d81a76654b2c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4341,16 +4341,22 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent,
 			int index = memcg_stats_index(NR_SLAB_RECLAIMABLE_B);
 
 			lstats->state[index] += slab;
+			memcg->vmstats->state[index] += slab;
 			if (plstats)
 				plstats->state_pending[index] += slab;
+			if (parent)
+				parent->vmstats->state_pending[index] += slab;
 		}
 		if (atomic_read(&pn->slab_unreclaimable)) {
 			int slab = atomic_xchg(&pn->slab_unreclaimable, 0);
 			int index = memcg_stats_index(NR_SLAB_UNRECLAIMABLE_B);
 
 			lstats->state[index] += slab;
+			memcg->vmstats->state[index] += slab;
 			if (plstats)
 				plstats->state_pending[index] += slab;
+			if (parent)
+				parent->vmstats->state_pending[index] += slab;
 		}
 	}
 }
-- 
2.54.0


