Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55EC0CD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 08:28:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1DB46B008C; Mon, 18 May 2026 04:28:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACDE26B0092; Mon, 18 May 2026 04:28:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0B316B0093; Mon, 18 May 2026 04:28:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 943F66B008C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 04:28:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 458DA1A082A
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:28:38 +0000 (UTC)
X-FDA: 84779864316.23.85FE845
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
	by imf01.hostedemail.com (Postfix) with ESMTP id 27DBF40003
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:28:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.193 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779092916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=P2w3KLqTR11dg3T5ht6wHnbd8ZirAtWG4vnrI5Cx39w=;
	b=7QrSi4w2YGWFhIGIMZPtcX6sallRIS8WbdSs7oeN8M+FF5e9UGQcHDeUboYXn0NruaOvkA
	EEFo1MQIEJFJdzvo9/mmXkcqGW1ujNMCK7CIEhuw/v2JhXtojI9H6zB2/E2nzX2MNLKZjj
	VNTfdH0Hrj0pLHzSPomzEMi+8411m0E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779092916; a=rsa-sha256;
	cv=none;
	b=2wJqqrpn9JUnyOkZt4i0fdUt2hzfZX/AtF8nGt+IheHp8izu62cFzuVUZrCJ8FK7h5XCpE
	QgaKRhhZmspLrZC5aj4r2oEAFZSKPIQ8jxD9ACxp7GNf/eClkm66ismtkLv62vwt0lNcTo
	Ti0A+FhZRIShRAtNPNU+/gsbnMhZNHk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.193 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
Received: by mail.gandi.net (Postfix) with ESMTPSA id 014CB3E97F;
	Mon, 18 May 2026 08:28:31 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	stable@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH] mm: memcontrol: propagate NMI slab stats to memcg vmstats
Date: Mon, 18 May 2026 10:28:19 +0200
Message-ID: <20260518082830.599102-1-alex@ghiti.fr>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTFxJEobSYWwhmTf2yZh3BcfZZ+gpAvsqMM7mQkREdaLd07SR+OFCteFixqSYGMWLGWiJ1KRxQdYDM244Q63WvZIySt//nzf5rM9NUh89hsnVwavQIBIeZ54gWu589OuRCP6KBhL6Jt3Wn/z00f9wsMHAnKjoRsii/78ip/eJ8f5ZLz60LkRdNrQljgBvqQWUoi76vHWPY3sVwzfYhvJiwbCrOzYlOdgRMrulLyGGS6IehY/zkYz5xLC7cE1yuH6HM/xpxnytLlA4IuEgKozD9+Ts3TERPNN0E21IswUVF2rGvNZW97180rGVLWfUMDtmL5IBGI9KRxzVXENdykdMgDolIHRM0SuSnouYvxjHPjtVHDXI2B+aNvz8FPBn6M5Y1oWXEDq91YX6CLE0WOHm0pQTUtAE2rBFXX/skXhZTnDx4CBC3TsKxw8EEaob2v+PBxn1DNqfxY1n4rzT/wfJ8FV+rSpogGjDGwxx98IzoUVfjciBSQ8TliJF08cRhf5h+0F4pggwF8PZoM1lxH+1RktKBduaBkSJ1w3EEHaXB/c///1HhICrvz0priN9vRoad9MzMfn8TnYSgQkVcm/DOBuq2Xu/a0ZI3VtaBB8umsZdLCTJ7xK8uOp9tkah4x0cfa9td832mKfx2yWF2MHRFPdyQ/+B8v0p3IrakZRqyccVQ
X-GND-State: clean
X-GND-Score: -100
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 27DBF40003
X-Stat-Signature: e9z3w9cdyn7i1im76y54xwnueq4mfn1x
X-Rspam-User: 
X-HE-Tag: 1779092915-756361
X-HE-Meta: U2FsdGVkX1/l3UPFAp3CS/sy1vVmlOubmliQ7/NOO+eF8YcTs/SyeEwC76E7Lt/d4vb7vEICDyc8vQ5GzT+kd2I2Z/A+OJzhGbJ7LrxUULVMN+sboTzVjAnE+tl3jwxDQxxcJc/SPTrQU0Xeg/Kl9OUZBG3CSm8wnK07xsTZAcgX+0/Kta60LlhYgTEDuTDMkZOq+B3f0iN/karBv0uiRDrtPI3d3Y0pZLBJH+8EovOOlssCA2SxP3f2sk1CAWYqVwWsix1SKAzuVwEmZMbKMf66EidGTaOZ//3pDmoRY/cUGcExXi2I85NFSrM9sLUa18T2/so0J1LJaDnPkKYbuIc4p0PSyn1MBM1Lc3dWIgf0/QXAFubiOVgbwyJxf7aOBX1/Js35rZJ8e8cnXPCu8T0TwGl+5kGZb9G77IV0WqYNi6Rwt1pvHv8cEOi1Y0h9VxHbfwpSp/HIBxH4HM8lXQJeJ69V6Tx3QI+KOUJpTVTfZjRlxLxwhscPTB156CTNDJy6ixR58O1g+OpFrbcLfZN/WK+eeORKbrEiYESfcGGEH1E8tL+SInMNp9ecSf17zmii139tcgtshGmGiiOLW9DWiDBSXa/CfJtmJyEtE8/N08Zy3Wd+boBxtD/PoirLi0wLTyBHgvf+zphqUrqBHdpQRrE9QsZCVb2kcRoywL8LiUh9/2aZ44io/vCSbudbVDOv46efERRmg1upGkuRCycgUmolEtIkeGa6rj0/aBOzLktdZ0gZo5WpkyznbTgn+6StvWnUNGiudPNZyI26o1hGWRXuTmIJEofP/isQQwCG4DLdbY4ou99bOemLTxW3aeal+PETY7F/dhh80hnbnStW+ooEb9JWF/34pU0IT51rV6oBYstpSVKCpI8wL6USUUg2UQz1lLQiWYJGE4pjOlBA+LJTeo8pjOZtiu1z4U7px87bX9YwHUaPZ1Qqgt1XU3qy3AjcyivmpA7Eryy
 rL6XbQLJ
 REwH/fTovr/XLa5628/yzr64iKzDCskp7q6riPmBF23LPa7WHI7XuJK0I4RzUbUiaSDz5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

flush_nmi_stats() drains per-node NMI slab atomics into the per-node
lruvec_stats, but does not propagate them to the memcg-level vmstats.

For non NMI case, account_slab_nmi_safe() calls mod_memcg_lruvec_state()
which updates both per-node lruvec_stats and memcg-level vmstats, so
flush_nmi_stats() needs to flush to per-node lruvec_stats as well as
memcg-level vmstats.

So fix this by flushing to the memcg-level vmstats for NMI too.

Fixes: 940b01fc8dc1 ("memcg: nmi safe memcg stats for specific archs")
Cc: stable@vger.kernel.org
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/memcontrol.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c3d98ab41f1f..953a3c0556a5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4343,6 +4343,9 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent,
 			lstats->state[index] += slab;
 			if (plstats)
 				plstats->state_pending[index] += slab;
+			memcg->vmstats->state[index] += slab;
+			if (parent)
+				parent->vmstats->state_pending[index] += slab;
 		}
 		if (atomic_read(&pn->slab_unreclaimable)) {
 			int slab = atomic_xchg(&pn->slab_unreclaimable, 0);
@@ -4351,6 +4354,9 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent,
 			lstats->state[index] += slab;
 			if (plstats)
 				plstats->state_pending[index] += slab;
+			memcg->vmstats->state[index] += slab;
+			if (parent)
+				parent->vmstats->state_pending[index] += slab;
 		}
 	}
 }
-- 
2.54.0


