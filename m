Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB465D3514A
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 07:18:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3A7D6B0005; Wed,  1 Apr 2026 03:18:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEB856B0088; Wed,  1 Apr 2026 03:18:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD9DD6B0089; Wed,  1 Apr 2026 03:18:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA3A86B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:18:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 189F459F9C
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:18:03 +0000 (UTC)
X-FDA: 84609132846.07.D8F7F9C
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf21.hostedemail.com (Postfix) with ESMTP id 31E591C0009
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:17:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=e9RLizYc;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf21.hostedemail.com: domain of wangzhen5@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzhen5@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775027881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CgTvKdo/p2bgLfcLhC67tpYYumUMNTRd/FLgAyX/pIQ=;
	b=TYaMcOfUHBgxCzSGndQrzpqXJgQkv+aJ2uu8cQaHV26Nw8TZIL+Nrx+Lj2W4obC/q9ehcJ
	xV0TIIRO3jx9jFsr5QrA1vdIi0M7EIU18CH2tUFqPzciEZqFb3FRb2ZirVMjhnRQUlGnAM
	/pUoBgbjcKyc/J5XqMzNHrAr1uR1QHo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775027881; a=rsa-sha256;
	cv=none;
	b=qUg3Arsi853vm3XMMvj5/dQryvKOaYoJgQQfdSTf43sFWN4tj+6ugFuwLJOwFsbb/T3Rjh
	1i6p3yPHL8uN/BTLSrlLdyt/fwnn7FscaJMrvrtgGqeE6nPA8PA0mJ1grZM2t3zg49ydxZ
	moe6v1E3lbXd5r/FGxr4TmsxZfLvkqA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=e9RLizYc;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf21.hostedemail.com: domain of wangzhen5@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzhen5@honor.com
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=CgTvKdo/p2bgLfcLhC67tpYYumUMNTRd/FLgAyX/pIQ=;
	b=e9RLizYcoe8gkHVBOqL7jxfUkmtOdBuXmz0i9jpqj9M+1oYceFOXiNqyOD3rR09deo8Il143E
	L6p5gETjJSRBVWmLliaH0KmsZx7cNZTUEXo9oVZ9NyLMPoGgH4UzFWwolQwJJmW3SSxdX/fxk6G
	TTtGe1u1yIkkdIF9U+2D1ss=
Received: from w012.hihonor.com (unknown [10.68.27.189])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4flxBN5Kl3zYlYLZ;
	Wed,  1 Apr 2026 15:17:00 +0800 (CST)
Received: from TA012.hihonor.com (10.77.228.68) by w012.hihonor.com
 (10.68.27.189) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Wed, 1 Apr
 2026 15:17:55 +0800
Received: from TA011.hihonor.com (10.77.232.85) by TA012.hihonor.com
 (10.77.228.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 1 Apr
 2026 15:17:43 +0800
Received: from TA011.hihonor.com ([fe80::1391:8a1:1ddc:4344]) by
 TA011.hihonor.com ([fe80::1391:8a1:1ddc:4344%8]) with mapi id 15.02.2562.017;
 Wed, 1 Apr 2026 15:17:54 +0800
From: wangzhen <wangzhen5@honor.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "rostedt@goodmis.org" <rostedt@goodmis.org>, "mhiramat@kernel.org"
	<mhiramat@kernel.org>, "mathieu.desnoyers@efficios.com"
	<mathieu.desnoyers@efficios.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"david@kernel.org" <david@kernel.org>, "mhocko@kernel.org"
	<mhocko@kernel.org>, "zhengqi.arch@bytedance.com"
	<zhengqi.arch@bytedance.com>, "shakeel.butt@linux.dev"
	<shakeel.butt@linux.dev>, "ljs@kernel.org" <ljs@kernel.org>,
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "yuanchu@google.com"
	<yuanchu@google.com>, "weixugc@google.com" <weixugc@google.com>,
	"jiayuan.chen@shopee.com" <jiayuan.chen@shopee.com>, wangzhen
	<wangzhen5@honor.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-trace-kernel@vger.kernel.org"
	<linux-trace-kernel@vger.kernel.org>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "kasong@tencent.com" <kasong@tencent.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"baohua@kernel.org" <baohua@kernel.org>
Subject: [PATCH] mm/vmscan: add tracepoint for changes in min_seq and max_seq
Thread-Topic: [PATCH] mm/vmscan: add tracepoint for changes in min_seq and
 max_seq
Thread-Index: AdzBp6diUCgIzLcpTbOIx0zw848r2g==
Date: Wed, 1 Apr 2026 07:17:54 +0000
Message-ID: <402fbac2fde14bcda8230c1535186b4e@honor.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.244]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Queue-Id: 31E591C0009
X-Stat-Signature: nghk1xe61899z3ifs5p5r4zdghsxrpxi
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775027879-408700
X-HE-Meta: U2FsdGVkX18BErTCF/mAOycJZa4iKJ57BiBElRbGARgj2juz37vxiX51Ac2Oti5wbj89SnnRg3l78ve80r3tFkevecXp17PcFBUcZA5yuPJkcagiAVoJe7YMJFtBwenseudv0Lr1TPWHAmPzDHslkv5mAF9Mxzcr+5lwwwsaxlxIw/JU69zsbQYQp09lSgdHONRYD/nuN99fmHb4zIpkLnx60E7xbvIYzeZXfjGm9R4Byq29IdSRstUS84jF0SAJa+QFdyCsz98pWJLxuyt1zvuWQZcN8vj4PtmA37W2AIxJItFDjupyxSLCMnns0a46TqcpY1nJuU13tBarOgWDKPtmV6CIpGMaAVZwD4K3vD1KO4SAzJVolBORsclWqghQE7+fqLJeQXmelvlXRiOMnfOrvc6rDxYhOJl2jGv4/G0PUOleRFTLsrlHQL0dzDh3X27G5bWW3ZqjuJCC8KBgORRL2/oqvRZVK78eHZzsGF1sjqpVLCXSC9CqBX/WXpZv5AK2Ih/NMLhTiIaQu020obZb4rMo1rPOZMiAmmcFWUkxaV6JNJZaB7FRcocRw2EcYV1l5mnB4sNxQxqsmAXz57xnuEEsBPGI6pqVRwc6tu6/bDMoLwcT2QZL2qLVY9d3P6IlPScMjekT/+BtzNNCM2YbP0zfiKH5jfWVcgMDy3V84aZMDv4LyVidXrHJUIXXsHEgs7OyIZ5ms9WF+DygeGd4mpVKUphkkk4xFIyIe3X+xY3TtprhaUfDcMBjDrKs3izeMh7bpfxDOYahiXAYYGeMfuGH0pyqnVAeoNuXKDOvbcJBAEAsENLMtTexDewsp2sPe6/O4AfjN4uRo+bnve4yt+uEfjarO6yZs4u+ivKlnSciyLFqNilJnc3JOHKedp5sqswQx2ZkySMfOq7TMEMXU1HJcZ4qAmjyOs31WGs7MEQU5HF5gMyYsKaquosYybnzOoOQEGWgFxP/nsm
 k18JLlC7
 q38Gw9oAo8LWEiJCSzvvtWXCO+Fya0FI6G312noFi60cbvRl9Uy/dAR/avr3ShxBctEqL6Eiz0qt7zmZnXthMlGGBWrV7SzAEJP+KihZXLhFj5FzzsrzTFAL+rpjLxTvQgAVjENDV9TeqUlC9Ab0J+mY/Xc9BxbWVMRmDhopK8kXpQUAu8pBEnUx/VFgVz30rxGRJo8j8FkQpvqXDXEJLxkwPzYnI95IC2SlgRIksNsoN+S+xHBpqUIrcVtsZwu9GmA4ucbwRIsxtoQ+5JWO91SskaNCM6m5uECTQqITyMnXq4CvfZ18kHDnlGTlHzfFFC6ypzTkkOVVtBF3Y7Ta1+hP9DmouG4+rX9UKRvaz6HohR6N9UsL3V7AwuF6pF2Mktn1AYqvxM/U249Jm4bzvpgbm/0js1DjFYP4b6txM8/UbklRa7XOIeIY7oBNGcXjOQDasD3ylvmMXEkEXnj0zmfDTgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From 20f685d13826ebaa86705a689128893be6316c7b Mon Sep 17 00:00:00 2001
From: w00021541 <wangzhen5@hihonor.com>
Date: Tue, 31 Mar 2026 16:00:48 +0800
Subject: [PATCH] mm/vmscan: add tracepoint for changes in min_seq and max_s=
eq

Currently, when tracking the changes in min_seq and max_seq of mglru,
it can only be done through debugfs. The granularity of debugfs is too
coarse when we debug the generations of mglru. there's no way to trace
the increase in min_seq and max_seq, so we add 2 tracepoints,
mm_vmscan_lru_inc_min_seq and mm_vmscan_lru_inc_max_seq.

Test results:

kswapd0-94      [003] d..1.    72.664921: mm_vmscan_lru_inc_min_seq: memcg_=
id=3D87 type=3D0 swappiness=3D140 min_seq=3D2
kswapd0-94      [003] d..1.    72.664922: mm_vmscan_lru_inc_min_seq: memcg_=
id=3D87 type=3D1 swappiness=3D140 min_seq=3D1
kswapd0-94      [003] d..1.    72.667303: mm_vmscan_lru_inc_max_seq: memcg_=
id=3D87 swappiness=3D140 max_seq=3D4
kswapd0-94      [000] d..1.    72.807691: mm_vmscan_lru_inc_min_seq: memcg_=
id=3D25 type=3D0 swappiness=3D140 min_seq=3D2
kswapd0-94      [000] d..1.    72.807692: mm_vmscan_lru_inc_min_seq: memcg_=
id=3D25 type=3D1 swappiness=3D140 min_seq=3D1
kswapd0-94      [000] d..1.    72.810955: mm_vmscan_lru_inc_max_seq: memcg_=
id=3D25 swappiness=3D140 max_seq=3D4
kswapd0-94      [005] d..1.    73.482586: mm_vmscan_lru_inc_min_seq: memcg_=
id=3D91 type=3D0 swappiness=3D140 min_seq=3D2
kswapd0-94      [005] d..1.    73.482588: mm_vmscan_lru_inc_min_seq: memcg_=
id=3D91 type=3D1 swappiness=3D140 min_seq=3D1
kswapd0-94      [005] d..1.    73.485509: mm_vmscan_lru_inc_max_seq: memcg_=
id=3D91 swappiness=3D140 max_seq=3D4
kswapd0-94      [000] d..1.    77.708630: mm_vmscan_lru_inc_min_seq: memcg_=
id=3D88 type=3D0 swappiness=3D140 min_seq=3D1
kswapd0-94      [000] d..1.    77.709491: mm_vmscan_lru_inc_min_seq: memcg_=
id=3D88 type=3D0 swappiness=3D140 min_seq=3D2
kswapd0-94      [000] d..1.    77.709491: mm_vmscan_lru_inc_min_seq: memcg_=
id=3D88 type=3D1 swappiness=3D140 min_seq=3D1
kswapd0-94      [000] d..1.    77.715550: mm_vmscan_lru_inc_max_seq: memcg_=
id=3D88 swappiness=3D140 max_seq=3D4
kswapd0-94      [003] d..1.    77.749288: mm_vmscan_lru_inc_min_seq: memcg_=
id=3D4 type=3D0 swappiness=3D140 min_seq=3D2
kswapd0-94      [003] d..1.    77.749290: mm_vmscan_lru_inc_min_seq: memcg_=
id=3D4 type=3D1 swappiness=3D140 min_seq=3D1
kswapd0-94      [003] d..1.    77.763055: mm_vmscan_lru_inc_max_seq: memcg_=
id=3D4 swappiness=3D140 max_seq=3D4

Signed-off-by: w00021541 <wangzhen5@hihonor.com>
---
 include/trace/events/vmscan.h | 49 +++++++++++++++++++++++++++++++++++
 mm/vmscan.c                   |  6 +++++
 2 files changed, 55 insertions(+)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index ea58e4656abf..6f2ae5c597fd 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -488,6 +488,55 @@ TRACE_EVENT(mm_vmscan_lru_shrink_active,
 		show_reclaim_flags(__entry->reclaim_flags))
 );
=20
+#ifdef CONFIG_LRU_GEN
+TRACE_EVENT(mm_vmscan_lru_inc_min_seq,
+
+	TP_PROTO(struct mem_cgroup *memcg, int type, int swappiness, unsigned lon=
g min_seq),
+
+	TP_ARGS(memcg, type, swappiness, min_seq),
+
+	TP_STRUCT__entry(
+		__field(int, id)
+		__field(int, type)
+		__field(int, swappiness)
+		__field(unsigned long, min_seq)
+	),
+
+	TP_fast_assign(
+		__entry->id =3D mem_cgroup_id(memcg);
+		__entry->type =3D type;
+		__entry->swappiness =3D swappiness;
+		__entry->min_seq =3D min_seq;
+	),
+
+	TP_printk("memcg_id=3D%d type=3D%d swappiness=3D%d min_seq=3D%ld",
+		__entry->id, __entry->type,
+		__entry->swappiness, __entry->min_seq)
+);
+
+TRACE_EVENT(mm_vmscan_lru_inc_max_seq,
+
+	TP_PROTO(struct mem_cgroup *memcg, int swappiness, unsigned long max_seq)=
,
+
+	TP_ARGS(memcg, swappiness, max_seq),
+
+	TP_STRUCT__entry(
+		__field(int, id)
+		__field(int, swappiness)
+		__field(unsigned long, max_seq)
+	),
+
+	TP_fast_assign(
+		__entry->id =3D mem_cgroup_id(memcg);
+		__entry->swappiness =3D swappiness;
+		__entry->max_seq =3D max_seq;
+	),
+
+	TP_printk("memcg_id=3D%d swappiness=3D%d max_seq=3D%ld",
+		__entry->id, __entry->swappiness, __entry->max_seq)
+);
+#endif /* CONFIG_LRU_GEN */
+
 TRACE_EVENT(mm_vmscan_node_reclaim_begin,
=20
 	TP_PROTO(int nid, int order, gfp_t gfp_flags),
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0fc9373e8251..6b5d21ee45ba 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3848,6 +3848,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int ty=
pe, int swappiness)
 	int zone;
 	int remaining =3D MAX_LRU_BATCH;
 	struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
+	struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
 	int hist =3D lru_hist_from_seq(lrugen->min_seq[type]);
 	int new_gen, old_gen =3D lru_gen_from_seq(lrugen->min_seq[type]);
=20
@@ -3892,6 +3893,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int ty=
pe, int swappiness)
 done:
 	reset_ctrl_pos(lruvec, type, true);
 	WRITE_ONCE(lrugen->min_seq[type], lrugen->min_seq[type] + 1);
+	trace_mm_vmscan_lru_inc_min_seq(memcg, type, swappiness, lrugen->min_seq[=
type]);
=20
 	return true;
 }
@@ -3902,6 +3904,7 @@ static bool try_to_inc_min_seq(struct lruvec *lruvec,=
 int swappiness)
 	bool success =3D false;
 	bool seq_inc_flag =3D false;
 	struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
+	struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
=20
 	VM_WARN_ON_ONCE(!seq_is_valid(lruvec));
@@ -3947,6 +3950,7 @@ static bool try_to_inc_min_seq(struct lruvec *lruvec,=
 int swappiness)
=20
 		reset_ctrl_pos(lruvec, type, true);
 		WRITE_ONCE(lrugen->min_seq[type], min_seq[type]);
+		trace_mm_vmscan_lru_inc_min_seq(memcg, type, swappiness, lrugen->min_seq=
[type]);
 		success =3D true;
 	}
=20
@@ -3959,6 +3963,7 @@ static bool inc_max_seq(struct lruvec *lruvec, unsign=
ed long seq, int swappiness
 	int prev, next;
 	int type, zone;
 	struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
+	struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
 restart:
 	if (seq < READ_ONCE(lrugen->max_seq))
 		return false;
@@ -4012,6 +4017,7 @@ static bool inc_max_seq(struct lruvec *lruvec, unsign=
ed long seq, int swappiness
 	WRITE_ONCE(lrugen->timestamps[next], jiffies);
 	/* make sure preceding modifications appear */
 	smp_store_release(&lrugen->max_seq, lrugen->max_seq + 1);
+	trace_mm_vmscan_lru_inc_max_seq(memcg, swappiness, lrugen->max_seq);
 unlock:
 	spin_unlock_irq(&lruvec->lru_lock);
=20
--=20
2.17.1


