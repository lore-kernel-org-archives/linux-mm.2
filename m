Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE490CDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 06:53:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC0B06B0096; Tue, 23 Jun 2026 02:53:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C98F56B0098; Tue, 23 Jun 2026 02:53:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B60876B0099; Tue, 23 Jun 2026 02:53:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77E4A6B0096
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:53:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0BFF31C5776
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:53:05 +0000 (UTC)
X-FDA: 84910260330.13.BFFF665
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf27.hostedemail.com (Postfix) with ESMTP id 601CA4000B
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:53:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kCqgWpzq;
	spf=pass (imf27.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782197583;
	b=CRL1tSFRn3qIlvbG4tjPJSuIHsqLo7HHdpVRxOCP71tdnlIvmNfwkb/fbF0Cly9hruYlUT
	GVHASeOkW+6geC3Wc8pf/XS0gXyXYrLjz5VRIAASPB4RbhqJztFRwVabjcfAYO8KCHcjE6
	3ys4vvR2GGXM3Fa0WYrf09onqK+Tp74=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782197583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yky0pLEqAno5O+v3VI+smdGn9aRO7GVsVIMrBB77xuM=;
	b=eLgrzkue1UQH0WhK/wDIC3XP+MPBbR0nZEl5W5xvtwZ6CD1Wp0R64+tk52d/azlkBGnrbT
	QwC0CFx38aJOZrvcdursRc9TAYwIWeHP9JOns3jiRlZNTdBXdvDCVo5zkoKyPPaBqhNhCJ
	q7sC39hrifGK4yuLCrQdvTPu/lJhD7M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kCqgWpzq;
	spf=pass (imf27.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782197582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yky0pLEqAno5O+v3VI+smdGn9aRO7GVsVIMrBB77xuM=;
	b=kCqgWpzq1cbfa5Nhfco36NZiTz/0u4DxDwCxm6k1tznTV4/UG3ysEV5P4vOfAGIDvCzlhp
	Jmi3E3EVqUKqx8Qxjsnl9okFMmjCIMHf2ZsTb2t48Ol8F5uPdTtynRp3rCOY/WIyVsmu8x
	JJ0T9mMHhCDhMogdgISzODIgLaglgMQ=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] mm/page_owner: move free_ts_nsec output to free section in __dump_page_owner()
Date: Tue, 23 Jun 2026 14:52:30 +0800
Message-ID: <20260623065234.31866-6-ye.liu@linux.dev>
In-Reply-To: <20260623065234.31866-1-ye.liu@linux.dev>
References: <20260623065234.31866-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 601CA4000B
X-Stat-Signature: eu5pft3c8ktjp17fe48mucoa463h4kom
X-HE-Tag: 1782197583-267482
X-HE-Meta: U2FsdGVkX1+fFDwjY4xkM2t+DSPak8LNvX6AJIPZVf58ufgb626w1Mo4ZhHMif3rF5ORQ3J0M3q2J7wZDyRe/HG1VbPqSng3DXkmmYQTk+8c0EEuQUJo+B0TTnioWsiGmRkJztgHiX34JMNMCjQRadmog+cbTbdOEBmvf+GILOh8gSlUZeFYr5+16M79oFkvburR+p0pS9zepznNEXP9Xs1vtcGdKr1FU8WoQGWAquXzXH05JG50gRlffu9RNyNq4j1iVg2ZGSwPXVpTBTIMQD3N47CpsbjK113Hg7AAYr3/1pEjPm489pEmraupEODFHgu728K0+U8/Fc1UcIfYFRiDwPuJPHc18c351mxteTYyZc1hKw2183AXZYiICPURzV23Avo0rgnZpf5fdht+k87Vf5LjrmKL2tFT1s6HUXcvrvnwQ3AmU8wuhllC8qZOLjQ8JAxeo/qRpyKKHLq701NbEqMzcDxfFjrv99INVwkxVREI7UZi68wc0A/dKB2+wEf2V267jEd4xjeuooqoNgSEO5xQxIcXS2cFq9Bk/s58xcGhr5EOXxoJnfSAMf5OJeKo5CHQbm4j7AFgzKzFEW/75LJoCV1biphNJqNrAqXz4MOtV6LAT/ga9RkdAGo4+726SvpmBMxgbZeef0VLc4Tzni5jsYOfTN5hMIWBzHJUcYlEUL9AEFO0nFa93tNaxW9rOyzsMFtM2zHLdlfZSc4o3WOn+nX8lse2UBomMAEfsHC4J44KTwOhmkdj/+Aa0waXPEvBljM4Dgemn9J1Ry+ABua5aAB5DcXuXoVRLtoahVCFSrzojBgWv6sdyDAZPMzzit6Z3ndGrdNnZVTL9DrXeJvOzMR/lrM+4LHwR4U5A+vFQ3cPHR/Szndz8YZGmIa8E/GywEodczxDansffl75ymkMnlr+iUp9vNo3DHhN50u4rFyrH4uj76avueQawUYKwrXVyrDEyRes79O
 5Kt2LX3f
 BhQxc+FB0D9FVpwvuQ9m32mgBE6RSABdwipmKJ83aR9XqMm5bwR2JFOI85v/N8+UVLG8uvQsJwarA7dJruot2CJBipWn78WMXjZ9tQM7p3p0fzliZURzZ6Kq/OdbGWprafRPRfs1MhC+imgWC5ptyNK77sD/Lef81jHqR78Rlg3pXO0mjV9mmjR1VW1gzlrgCYh/Fvjq7tpKBIxGCbSmFBextlWzaIii/MXfiB1YC0/7zVeDKaOdQq+Rk6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The free_ts_nsec field is a free-event timestamp, but it was printed
in the allocation summary line alongside ts_nsec (allocation time).
Move it to the free section where it logically belongs, together with
free_pid and free_tgid.  This also makes __dump_page_owner() consistent
with print_page_owner(), which only prints ts_nsec in the allocation
summary.

The output now groups all free-related information (pid, tgid,
timestamp, stack trace) in one place.

No functional change except output formatting.

Signed-off-by: Ye Liu <ye.liu@linux.dev>
---
 mm/page_owner.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 958151ccb587..eaccff355cb4 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -660,10 +660,10 @@ void __dump_page_owner(const struct page *page)
 	else
 		pr_alert("page_owner tracks the page as freed\n");
 
-	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu, free_ts %llu\n",
+	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu\n",
 		 page_owner->order, migratetype_names[mt], gfp_mask, &gfp_mask,
 		 page_owner->pid, page_owner->tgid, page_owner->comm,
-		 page_owner->ts_nsec, page_owner->free_ts_nsec);
+		 page_owner->ts_nsec);
 
 	handle = READ_ONCE(page_owner->handle);
 	if (!handle)
@@ -675,8 +675,9 @@ void __dump_page_owner(const struct page *page)
 	if (!handle) {
 		pr_alert("page_owner free stack trace missing\n");
 	} else {
-		pr_alert("page last free pid %d tgid %d stack trace:\n",
-			  page_owner->free_pid, page_owner->free_tgid);
+		pr_alert("page last free pid %d tgid %d ts %llu stack trace:\n",
+			  page_owner->free_pid, page_owner->free_tgid,
+			  page_owner->free_ts_nsec);
 		stack_depot_print(handle);
 	}
 
-- 
2.43.0


