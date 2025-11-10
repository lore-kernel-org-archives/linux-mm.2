Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 584BFCCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 08:44:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73E1D8E0008; Mon, 10 Nov 2025 03:44:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EDE88E0002; Mon, 10 Nov 2025 03:44:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 604148E0008; Mon, 10 Nov 2025 03:44:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4A62D8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 03:44:55 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C654BC0CD5
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:44:54 +0000 (UTC)
X-FDA: 84094062108.20.5D61431
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf18.hostedemail.com (Postfix) with ESMTP id 14AFE1C0004
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:44:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="b/MLsFTk";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762764293; a=rsa-sha256;
	cv=none;
	b=3KXbQtPVmoFlEy9qOP6V6nfXRYWCL96fTmnqW5oFUu5OiD23IzPuPAyi9sePVkRBtMvwGZ
	M1fgEAo3vd/ubClwv98DuCQUkBEH52xqHZBRMXSG8+3MY6+3LxfbgKV0AE47q4IKy7V++z
	b58fXED8qNoBqq8F9+Z/I1lxe6luUyg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="b/MLsFTk";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762764293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=i1AWXzCfEqRFFIgfi716ObTY/oClLhe/oFlQHVuhgXk=;
	b=ket6XmJgAijKo+b6VrFO4AqIUrmWVbk9NksQef2mSHGA5hQnQJVdMrg4ICIPkcbwLNURMb
	wemf8eMIfpbuscttUvdLws+MtySPiwA0d8zQaEbRefbk0MM2X+Fwh8p1Ba7c6Ys7rBc6Kb
	9iSnxDa74nNFbvP9aTqpGISwpWU4i2U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762764290;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=i1AWXzCfEqRFFIgfi716ObTY/oClLhe/oFlQHVuhgXk=;
	b=b/MLsFTkzOowsCnABlSuNUL72SnXg7YGrxD47ixZas0WMQ01U5vWwdV2i3JmnO44oA1CPs
	jT78saeR97gCQPqp0dgjiQZjrmFW0qcXgGjS3apHrL6YorW+mpRRbo2YC0KrdFxupIN7re
	BxtmGk09LyUkCZuNLHKAgW6iaqNG9/k=
From: Qi Zheng <qi.zheng@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	harry.yoo@oracle.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH] mm: vmstat: correct the comment above preempt_disable_nested()
Date: Mon, 10 Nov 2025 16:44:37 +0800
Message-ID: <20251110084437.46701-1-qi.zheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 14AFE1C0004
X-Stat-Signature: ikpxdm7f6zehamx98me75hyyekmwgdnw
X-HE-Tag: 1762764292-557565
X-HE-Meta: U2FsdGVkX1+adzb0ZxPyTYU69VvIRkt9ZeqMpnv9JPD/ZVBF2wxuWRINQnxSK5k3JjxDFacc9zh3cQ8T1RJzh8GH6MiqIkNWePHVJGwlJZ0NU7MjFxxksmIFI+Z4r72VyPz/APUG92fTA+bID9girSQIsJq9MG/qzkTmn3jm6jmRroiMdwJXkdwoA/97DHt5wi5Ixm9O7wzczLVb2/Wlj1YDICYrRRbAuVdYTFGDhmq2+zNIfkbPBIAgLWFdTPzO5F2OgmHicdH8A7UfX1UpgMFsairWZpq8aTG0BwpKboEYBx/mXuRoA0ioRLG+Qgq7Zng7DyzxO1pfO1yCr+9bK7x0ceh3jwkqnf3RnQ/W0+vy4LHMIc2SCVe8fVGzbdLyqBzbiwPrruMPsUhPWCJRvr/lzLBHGdtzVh7yC2oajNys0Yzj48GrsYDTpMYOXn16WMogV2iDpo6YhggtP1jISaRCW+a+BiH/dLJfD9i3ZB/kYEC9PfMc4ejL0qjlexxp9wEooEAGUMMYlvApluAhq4oK3AqBDpVyR6tv/47Pt+IPzadtqfJRH6O6seO+TI7WMOKL671LNZQfXMAsXXVKNv6pF3ZYwnVo88G05Q+7X3PQeiknEuw8KRl0HYsiCBKiXGhV6/6hd3KPNAyBmT0KZyQ0D/X7R4dICzjP+2dXINWUiBrdvltGgarh9A56l2rFkES/PJtVlvqAHvgrciotpaMa1J8XncluTobOAN9Drjk8I37Q0fWZRyPCjiLS1zR/PHejbCW/HCfmLNW7HlY4O8vfC+65PZvCyaI6W63SR6AWx1rzGENmfe6bfqYEtt2SfPIwKMllBuC3LVunn4M1nOorDvV5hTvgqLS/dKpzsIsc92wmJwyfp3GKWOpbMcTE9IL46S5Pomw74vNypJn78bKDlFcNklIFwue8YokMKgLt+RR1sQyTTIurZRLKDIDQi4PailBUmNcAtABuSjm
 ehLmGx1Q
 zgqiu7RiQ+7lqDpyw1/nVlchHFRTsdHqTwleCV6yhJCiKm6AR9mNM5CiUbHiAnPKQQGfu9GKNDXMITa8Uq4c1nAfCn9YC85NRGcYyVMc2IMGQmcQWIF7odvryWsG8U8XHMVdYGRBZ+pLQK0ogDxloFlFBeMiU+MApVQZ7ocsasSgnVIg+znJpbkGj8Kf2jrn2VWDmVltnt+t1ecUuj2sQRdW1TIgbGv+a4pCaI/6H6IFxbP+ovxbJAbkdajMG+3/CO0i47PAfGGeeVbA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

The comment explaining why these parts use preempt_disable_nested() is in
__mod_zone_page_state(), not in __mod_node_page_state(), so we should see
__mod_zone_page_state(). Just correct it.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/vmstat.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index b53b07aa29e81..65de88cdf40e6 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -392,7 +392,7 @@ void __mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
 		delta >>= PAGE_SHIFT;
 	}
 
-	/* See __mod_node_page_state */
+	/* See __mod_zone_page_state() */
 	preempt_disable_nested();
 
 	x = delta + __this_cpu_read(*p);
@@ -438,7 +438,7 @@ void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
 	s8 __percpu *p = pcp->vm_stat_diff + item;
 	s8 v, t;
 
-	/* See __mod_node_page_state */
+	/* See __mod_zone_page_state() */
 	preempt_disable_nested();
 
 	v = __this_cpu_inc_return(*p);
@@ -461,7 +461,7 @@ void __inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
 
 	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
 
-	/* See __mod_node_page_state */
+	/* See __mod_zone_page_state() */
 	preempt_disable_nested();
 
 	v = __this_cpu_inc_return(*p);
@@ -494,7 +494,7 @@ void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
 	s8 __percpu *p = pcp->vm_stat_diff + item;
 	s8 v, t;
 
-	/* See __mod_node_page_state */
+	/* See __mod_zone_page_state() */
 	preempt_disable_nested();
 
 	v = __this_cpu_dec_return(*p);
@@ -517,7 +517,7 @@ void __dec_node_state(struct pglist_data *pgdat, enum node_stat_item item)
 
 	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
 
-	/* See __mod_node_page_state */
+	/* See __mod_zone_page_state() */
 	preempt_disable_nested();
 
 	v = __this_cpu_dec_return(*p);
-- 
2.20.1


