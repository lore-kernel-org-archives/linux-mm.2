Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0E6D606C6F0
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mBAAbAr1
Received: by kanga.kvack.org (Postfix)
	id 9D75E6B05EB; Fri, 20 Nov 2026 13:11:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C6046B05ED; Fri, 20 Nov 2026 13:11:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 604D36B05EB; Fri, 20 Nov 2026 13:11:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5206B05EA
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:03 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B56BD80145
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:02 +0000 (UTC)
X-FDA: 85456288764.02.690529A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8A8AD1A0005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mBAAbAr1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198260;
	b=pazjKvPr759WL/XStFc+7xyVWt1xcYbBhNPjsLy4Ncdz8HXM91RwTHUJqJP2VwhvMUg9zS
	QOGjWEH02Zr2OJQdjEIyCLv6nVwMo9RsMCxmpxHzH/Vvre9C+QX9JxpulwKDSAANhJlLzt
	ZsV9ZPwQuHb4gOuCHGubApVJqSiz/mg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198260;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uI4/JRp9SCSUDodmmGkLAXnadfESLSG92P6T1t9xBqc=;
	b=0YtTaX0zefm0G8fSjtnkp5GQ5Z0gZ/WSSJao9Y0WaxIqfUt+2SVtxjUfQK2n2prSkLmTi0
	+0sVLSBbPDu/UOFe+90paL+iLGK7/GHcq6L9lmq2/UkNXpCTyioS1wZHN63kXM119NFJti
	TufIaG9/GOfgA0uugdnJL9rmZaDR1T0=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mBAAbAr1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A4DBF46CC6;
	Fri, 20 Nov 2026 18:10:59 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198259;
	b=cEuwmIGZ71i2M75F2j9ZCojjmvy2JofFT3S/iyTDygeE+icablWWwNddSH5MjitvjgDD
	 xCVxYsGBWsFFxN2nKkJ1eBIzhxS8thnd6QnagV/+2r3MgagItC93WVA1s8plki+3zJCjN
	 Eide14znpPuJ/Kl2Vbr/TLP86rw2F4qh51RkFgfGw4Oo+L2iihTXU//pwaqpnkf6XfK1x
	 GWXKx7S21A9ld/Q9GeyVsAtjN9b8f5k2TT08cFIC1u/HNo50Kd1SqyFR+8FeMSBIR45Qh
	 Hh57PbFcTJhKhYYe4U/xb/D5eI4Mon6+grV77DlQOgMejRn4hpHjHVUsI74Nkk88z/g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198259;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=uI4/JRp9SCSUDodmmGkLAXnadfESLSG92P6T1t9xBqc=;
	b=X/ZsFCvPfJmlgQ3MyAs76NlQR7yf0wc6ZFiGirfAFZP0iQsXok5WG/gasUR4teJ34N7P
	 q8YlIIAR8mo7BMnVu+uRzHbolD6Veiu6Y5ZW+KVH2qesIzYGkbSsxdUluVJP9JiftfNeK
	 bpIoy3Fc9kmjZMwOWdBSDGB/lfEYjMIiIB6RoQ3WD65o5leCJIwYXp4KIE5JsuZpmEt79
	 ctF98Lp9n0n7lKphmJq1XBDeG45+LJB8XzeSEuMccVOalpRpm1o2dwgxIih6NBtGwMDzY
	 J2tceaQ/kVJ74nl/I3RRxRe6E3ykO9pR8RSPoKOMsGpS8UQAxqbH4epV7JmikjLB/gg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8FB7A1F02ECF;
	Fri, 20 Nov 2026 18:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198259;
	bh=uI4/JRp9SCSUDodmmGkLAXnadfESLSG92P6T1t9xBqc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=mBAAbAr1FZhj3vg4U4EqG6JGgWiFJouE9PMZyVMU3UWziMg59G0JtbnR+zQLp+NwW
	 dYaq8bDle04A+uacnwVEShfEwgSZsCGe80fy/xW8WvYkZsNARSVkMcVfggfA/58Gix
	 31v4kKF4v20kbZcweRZCqJ9L3BdYPzTsSVOonG8gppYRlR9tLll/ibw12cNqsOEZ6d
	 UybfLo2kjSo/uTHoaax4zjfj7I8eUHJTAXcQFUhQQZAFQ9qJdLWT4vK/FMxzbXmB6D
	 QwLHmr0xVJr+9v8YgueuoKCG1tP5Wckd9Qk6dOOb39iTrTHtHAeGrAwKjaC5gbWvg9
	 2BPCvxoMvARFw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D6C014B961;
	Fri, 20 Nov 2026 18:09:21 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:31 -0500
Subject: [PATCH 40/60] mm/page_alloc: let MM callers select the local
 private zonelist
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-40-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
In-Reply-To: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
To: Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=3868;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=npD7Fmno/ihvzONGk5Hl78WlKQtT973I2z2+au4TARw=;
 b=B+B4iyRjeprBqeAT8WfT6BHrv5fPRykSXQFs1sxCFnPlJtNmc6Rzehajvtbg2fl48qr5ckUeO
 TI31w3UdoXUBQoL6KmdQvmp7Vmy8aGnqUBf4brYww1HglkUBFrAUDZz
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8A8AD1A0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: w5b1c9if1gdm7s4ibn9abjqb9xkgrwdg
X-HE-Tag: 1795198260-523317
X-HE-Meta: U2FsdGVkX1937qoOV9uiSlxMyVVWmj8j+xu5+gqfezGfckRTtWdf0a/1i12XH4GtqRE7+3ihIgQ7CQzKP8DY+RU3ZoauidaekL/i0e5NjD5vH6FZDQ+YAcUuq3GnAi2h1tfP5+ni42Ehdy0cTL07rvgUkNjuGwRwQ17vRVygegcZEXqWkKsCrZxL3mjJglGuVm0lJYHRSh9NcH7FBI5vLvgjgucLkPe07m+Uxn5ZP2V60esUAMYNWLUIqAXpVwg1qJ3hVXpIpe0v4Xm0i0Ko+zGPVxCC/3pEjUqzpwW+Me5T+6XWST0vjWCZLH0HBubjCZblXSpuWke/eoq5dYomyaKxMaNwvFKJh6H9TPmyxUtLCK3cnXyMfg4dONZdMSEioCHpU6746m4J9ED/cd3ouadUfzwnOiLl5g6wrCkOnMykXzPrJroyaz+Kayb2A9PvP8k59No20B8S4V2ZyiD6m3/ckBxM/hmFMJ4qDllTBzpRwWR1RxZ5S7KKnZLbBe+CWFxsAVjOu3MIaIAIjwPhXctfI2Y+LPBwkgc3KDkozllo3is9LA2PJdCSmAb8nrm++e2tUSJPY6l3c5h5TGUsFVWH9lw1H37365Kjmrp8zNdRhm4dpF2t9uB+xHIBgxNmimrYtZCZxnsftkq1JyYX2oIVexjSRWTsrZqy8BjEGgvdY5vj4fYE7LF1ZSU25HgM76I1vL8ML6R07gjP0KZDLkmgmJzSyOa+FJeLiogqb9TEgAE9lY1VGj87dUj3WqccPVvGK25uhX+zNp7tIJiEd3R1QDXdg1lJY7m1w6QRF7YcTcrMNskeUW9V7lVyZ46u2RcjuJMeKBHZYTrNhLx3HOIWXE6HjrnjJfwi6w8JM90m7AGf06fQaueHW1YcqWm1wdRkFAJLtQClMqhcg+LPhCYvDBaqZ/zCocBzjy0aWK/2cYsY2hTHrcoBvBs4Xhi/o3bNAau7QFzlhEsBs4e
 XTEJ3wfD
 n1OFGBkG5+7Ed/pRPMWYVt812TdrzAMbiNy6QBrH0Uxp2Y3VdGeaHaObmZIa0p2EMHTEdmQOOo1F4y2zBSst9LjrbKDZdn8knqblypRqqoDbLNGaX8u8GYHuzxNd7C91Xj+3bcDSCxaQqpOqJpA4lDCNkPps5TV07ngekJ39IgtKvFCEAysakzCvQLkH6DrGUYPdPquvUolFZ1v4gcDgX95F8jgYbZVITUHn+hAx+q5rcMsfFz82kWMxdxcIUzV9rpG9FYdSCFccwrSuSumvJmlA3KgfgZXykIi/EU/f80hvvXAhjN5CjREJ66npi1z30cKjCR1EgK3uH5p8cwzj+YAFKOve12LKTSqduNdiCIybMAb+J9ywjF+on5ohenURse0W2ZRlV0J32VvWv41Gs/8/s21cUJYUm03kRZi37V9QmmWBYCUtLZ7KeYy6K05AYt+YuENxFErLEbdiORu56VK/ViVHtN4zR2Vj3smSJd67BdEOAXp+fgt+xlGGGrOL2w5BI2KbgvwiBWTT6OkQiBcVTUKW5GWVBRa/4ZTZw/6/MEX3WZXdcaP6wJv7sT7OEBn4BcjS6WpLgF0bzvQ/USRtyTyGX5rAGBENhhb8OJIkb/ZLxVrX+ZTsR1iLhqhbwis2vK7Vt0sQ8JDvN/wfPL9u54TGJMpThoCu6ltVYxecgRx7aShaJ1BFpxUzoYQFrScLKwsif7cHRFTuWjpVDbYzNjrQiWSMRLj0nX6UJ+2LBA9oQnSrLHIEd7N4TL3Hf8HTSrz11tDtfjsDetDN0fMDpeytMgzNx3WGiK43wGPrT5nctbSAgkrNSIpquBe8THM0f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

Add ALLOC_ZONELIST_PRIVATE, which selects the local private zonelist
independently of __GFP_THISNODE.

__GFP_THISNODE still governs OOM behavior separately.

Allocations are otherwise still filtered by the task's cpuset, this
creates some quirks.

Reserve allocations normally drop the nodemask and the cpuset check.
A private request keeps both, since private memory has no reserves
to grant. A non-blocking __GFP_HIGH request still skips the cpuset
check, as it does for ordinary allocations.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 21 +++++++++++++++------
 mm/page_alloc.h | 15 +++++++++++++++
 2 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0bd21916cea1..a219057931c3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4926,16 +4926,24 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 		goto got_pg;
 
 	reserve_flags = __gfp_pfmemalloc_flags(gfp_mask);
-	if (reserve_flags)
+	if (reserve_flags) {
+		unsigned int keep = ALLOC_KSWAPD;
+
+		/* The cpuset still grants a private request's node. */
+		if (ac->alloc_flags & ALLOC_ZONELIST_PRIVATE)
+			keep |= ALLOC_CPUSET;
 		alloc_flags = alloc_flags_cma(gfp_mask) | reserve_flags |
-				ac->alloc_flags | (alloc_flags & ALLOC_KSWAPD);
+				ac->alloc_flags | (alloc_flags & keep);
+	}
 
 	/*
 	 * Reset the nodemask and zonelist iterators if memory policies can be
 	 * ignored. These allocations are high priority and system rather than
-	 * user oriented.
+	 * user oriented. A private request keeps its node: private memory has
+	 * no reserves to grant.
 	 */
-	if (!(alloc_flags & ALLOC_CPUSET) || reserve_flags) {
+	if ((!(alloc_flags & ALLOC_CPUSET) || reserve_flags) &&
+	    !(ac->alloc_flags & ALLOC_ZONELIST_PRIVATE)) {
 		ac->nodemask = NULL;
 		ac->preferred_zoneref = first_zones_zonelist(ac->zonelist,
 					ac->highest_zoneidx, ac->nodemask);
@@ -5164,7 +5172,7 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 		unsigned int *alloc_flags)
 {
 	ac->highest_zoneidx = gfp_zone(gfp_mask);
-	ac->zonelist = node_zonelist(preferred_nid, gfp_mask);
+	ac->zonelist = select_zonelist(preferred_nid, gfp_mask, *alloc_flags);
 	ac->nodemask = nodemask;
 	ac->migratetype = gfp_migratetype(gfp_mask);
 
@@ -5477,7 +5485,8 @@ struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order,
 	unsigned int zonelist_iter_cookie;
 
 	/* Other flags could be supported later if needed. */
-	if (WARN_ON(alloc_flags & ~(ALLOC_NOLOCK | ALLOC_NO_CODETAG)))
+	if (WARN_ON(alloc_flags & ~(ALLOC_NOLOCK | ALLOC_NO_CODETAG |
+				    ALLOC_ZONELIST_PRIVATE)))
 		return NULL;
 
 	if (!alloc_order_allowed(gfp, order, alloc_flags))
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index 917653ae14a3..c0a0e6abe4cd 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -56,6 +56,11 @@
  * alloc_tag_sub_check().
  */
 #define ALLOC_NO_CODETAG       0x1000
+#ifdef CONFIG_NUMA
+#define ALLOC_ZONELIST_PRIVATE 0x2000	/* use the local private zonelist */
+#else
+#define ALLOC_ZONELIST_PRIVATE 0x0
+#endif
 
 /* Flags that allow allocations below the min watermark. */
 #define ALLOC_RESERVES (ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
@@ -100,6 +105,16 @@ struct alloc_context {
 	unsigned int reclaim_compact_order;
 };
 
+static inline struct zonelist *
+select_zonelist(int nid, gfp_t gfp, unsigned int alloc_flags)
+{
+#ifdef CONFIG_NUMA
+	if (alloc_flags & ALLOC_ZONELIST_PRIVATE)
+		return &NODE_DATA(nid)->node_zonelists[ZONELIST_PRIVATE];
+#endif
+	return node_zonelist(nid, gfp);
+}
+
 /*
  * This function returns the order of a free page in the buddy system. In
  * general, page_zone(page)->lock must be held by the caller to prevent the

-- 
2.56.1



