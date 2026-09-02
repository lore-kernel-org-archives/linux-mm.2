Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1736CC624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 09:12:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F303E6B00C7; Wed,  2 Sep 2026 05:12:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F08ED6B00CA; Wed,  2 Sep 2026 05:12:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1E186B00CC; Wed,  2 Sep 2026 05:12:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BC8FF6B00C7
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:12:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1722112012F
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:12:11 +0000 (UTC)
X-FDA: 85168255662.25.62BA312
Received: from mta0.migadu.com (out-100.mta0.migadu.com [91.218.175.100])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0D46EA0006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:12:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="LM/zbNPH";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.100 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788340329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1xOhJSh6GBhJTnKkrhAubgK3jC2EHaeSXQ+UMUC5WvE=;
	b=K1dvWQzNY3RILvXwRcNKa6s+tDHZ36XEt6rTuOAxODPd9firdRXpFqAkdAIl7lFDLcVMPG
	rjbXD1dzdGo3W7XY2BKG/WdRZqXHcFMyIWXxFHJ1V7ezrhwvURli4SVxfbFx/h5cmnTFpS
	ayXwX7W1QC8HqsHufadxD83Zc4OGZTE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="LM/zbNPH";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.100 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788340329;
	b=SXnsuOcltaGDZbqh81EOlikPJ/SEdr1l6Y2cog0HhnNmaR2qzNIL12fSqLPgWblQD9bJWG
	lfJfpJTq+bhWGhf5fF+1S/NXlEnvrtHDyTo/ELl8ZhZWDhWl6Rj+hYQjRh60qp2LhBr8pd
	wBgZoN2GOG11uyqGkUzRrl7GqpmBUbc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=S4xIe48Lz2OoFv+XGXqa0e31U6j3FkB/AF6kV2JAwo8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788340327; v=1; x=1788945127;
 b=LM/zbNPH76f1kMb372TgOYdN+vEMy4cIDJy3IM/1AgTh53GS4gfsJIXrkhlvaxdUuphY1ZxU
 q/KOpO6BzakgoR8kP0xugkXaQ0TVBN3xNCSfyl3EuPFDOl2UiavfXDf3Od1nHerANATXksCoUkW
 WENXAX+HU6q4ElV2KAtPnc4w=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 919a39186f4cf9c7;
	Wed, 02 Sep 2026 09:12:07 +0000
X-Mizu-Trace-ID: 919a39186f4cf9c7
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH RESEND mm-stable v5 1/2] mm/vmscan: fix missing NR_ISOLATED counter update in MGLRU reclaim path
Date: Wed,  2 Sep 2026 17:11:25 +0800
Message-ID: <6b23d93b47a6cec98bedde6e68df9c2bbd9b6a92.1788339549.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1788339549.git.zhuhui@kylinos.cn>
References: <cover.1788339549.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0D46EA0006
X-Stat-Signature: cjt6i74k36s1swwg4ikq6r1ym9ohetxh
X-Rspam-User: 
X-HE-Tag: 1788340328-666972
X-HE-Meta: U2FsdGVkX1/otc4ClHbze7Px/lCI+cT8ObRn9aM35VwBJf1vhBaChwYh33gP9ZQVaAAAhR9buKA9td9dPbDWoqireG9GHX7J/j6b4fYaAYY42u88RGy4wkAG9v6897219Mk2vvFyGKfh7XJGD4HJQT1B9fzK+hTw1s2qOmML3DB+rxgL4w/iSvb0OXwBBFurr2qOFDAbiEreMyamn8jhQRknMu/XKBxFnnNi7fg5xM890We1pgEE7kw7Ko8E2y6yaCyjhxWlCpOsuxOvXU6N9y4izrY79+Hzs/zJSZwiaxkzbZtAAR+I5jroDxtbDBz8R7Zrhiipgffz3Wyedcs901NwyXP4vePZ0mAPJNh8kzVUumsPYXKjnLQXdbbsF/nAsN+J8oLBWt/WRzKrVDd3BpfnlBsVBP68yqJOWfmINQztpM3e4dbhlbkboxFaOiH8fqrQcBgJmbw1pCc58oJ4Vq0DqoxwcP5r9kF9aQ95Xx0CM0Q32zo0ky/kc7gDayD187gpo9XAYvEyJN8Hg6etbIbi4X+2GUXsTxDZk9rWjxV1w700TlH922ajCXeEkRohSOSLcB5JUXYLBS9qyvetAnkGQF1u6rFcdPWg8ypsyuSWng7DV8bqO+7ClVZrABQT1ROXome3iVdWOcQz5P1sObhuCydmqAUmp+/UicDT1mKkDpDCO82FaJlljrye6K1RookwOB2a2vxGRH1KIDsSBbmOg/WqTFYkQJbffSt54Xy3ZIOHz7+enxSKA1VCeWNMwull6Lrg2L8lVMcatIEB32EAnjh1uHBt/83xcJj5bmCx8nYhlFKoe/fBOLHW/+Eljm2oPNQD8F9B8bjWx0leTb4Pb8YDBfqQ9/DNzZfrYtRKnyV0agrcMfJTO16o0Sv4SSySupkACoJh5fVDLvt26EUH0CM2Keu5Pu1Ane+KXppiavKDK6isAE5746qBvC4kAwvPRCOK8UqOzrxUgvU
 FjuzD2Ui
 4NRb5AVhK/6UM58Ys/GwdGntZtG97lV7OrPzdlPb32+kPkqRX05KTmsNlLSaKgeVUgPDAorLxfc49BxmYk1WdPAA70CRmVbZMJ7pdx7lt6w2U3pM4pcSAtFb/YR6vl5WHoVSfjhHED04qNN+I+ZNU7bccN/pIR8ju6IfGdqb0/ox6SiepTqHAAlTVIXj+VajzsX3tpmTYFRX8ctuWA03Pp4MwZ6A0oUeDmtPIUUl6efEtrIInI20Mh80bl+X6Ee66+GoDl3S5PeyUxWPvECbCQF61Yw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

MGLRU evict_folios() isolates folios from the LRU without updating
the NR_ISOLATED_ANON/FILE counters, unlike the legacy
shrink_inactive_list() path. This causes compaction's
too_many_isolated() check to under-count isolated pages when MGLRU
reclaim is active.

Add NR_ISOLATED counter updates in evict_folios(): increment after
isolate_folios() and decrement after all retry passes complete, using
the existing nr_isolated which holds the original isolated count.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 mm/vmscan.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f11491ee9ed5..3936c553c63b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4897,6 +4897,9 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness,
 				 &list, &isolated, &type, &type_scanned);
 	nr_isolated = isolated;
+	if (nr_isolated)
+		__mod_node_page_state(pgdat, NR_ISOLATED_ANON + type,
+				      nr_isolated);
 
 	/* Scanning may have emptied the oldest gen, flush it */
 	if (scanned)
@@ -4959,6 +4962,8 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		goto retry;
 	}
 
+	mod_node_page_state(pgdat, NR_ISOLATED_ANON + type, -nr_isolated);
+
 	if (nr_isolated > total_reclaimed)
 		mod_lruvec_state(lruvec, PGROTATE_ANON + type,
 				 nr_isolated - total_reclaimed);
-- 
2.53.0


