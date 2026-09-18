Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB5C7C88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 08:07:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCEBA6B009D; Fri, 18 Sep 2026 04:07:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6696B009E; Fri, 18 Sep 2026 04:07:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE2C26B009F; Fri, 18 Sep 2026 04:07:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89D6E6B009D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:07:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 06CD81405A9
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:07:53 +0000 (UTC)
X-FDA: 85226154426.18.12563E6
Received: from mta0.migadu.com (out-22.mta0.migadu.com [91.218.175.22])
	by imf30.hostedemail.com (Postfix) with ESMTP id DBDA280007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:07:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v0ypuYY9;
	spf=pass (imf30.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.22 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789718871;
	b=tacKuX7Mx0E2ec1upJ/vmgu8WZRz82p0t5oQRBm3y6X9lKO7+HrPbXfwAnXC1gTWanVwee
	m+X9iJP5oxziT7Y0yJOvTCOoltYV1bsGcNjUQrzyr6XZ/q32nEdhDvrD7zKGAyLWqGQwyt
	9H8aK7q9HOkK7lm+FyFXTIFDVQJ2Ep8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v0ypuYY9;
	spf=pass (imf30.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.22 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789718871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M3/s8OmZmP8PGhVJj8eoDrc1V8e8LB/zdVbmUs07jAc=;
	b=FggjK9XxNtCY1LGLkKSqDtUUDnMDT4sePRJnNpx9tCzfWL2/U0affv3FI8tuwZsCbbHzYH
	4HgP4yTfrgu6KfEvK8UrOVeFKrKYc93KcX0m3iAj7TixxKJYRZfWp+VUVjYvQ3nVZHhlMA
	gIo/1lHW4LSMebs/LHhZeP6HDu4sp/g=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=LQKsApWiukLe6I05VRgMX+vmqCliXhSA5N9TndfGCbw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789718869; v=1; x=1790323669;
 b=v0ypuYY9lpx+Q4GIVdm9v6zwBXNzKPoIF0AcrTD769tsD+Zkub1VTe4r/3Mpqz+pZRxmbi6M
 3w84Fi25B4W5b/cYPhUxk6VSpSIewtFSefFIwsVo23kWlBIb2mH8kLg6pBFhMzJw3r1yRNaakVg
 Rw7IoYWVYJvizNE5Orr8C3vE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 38739c2bf71cf7dd;
	Fri, 18 Sep 2026 08:07:49 +0000
X-Mizu-Trace-ID: 38739c2bf71cf7dd
X-Migadu-Flow: FLOW_OUT
From: Hui Zhu <hui.zhu@linux.dev>
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
Subject: [RFC PATCH RESEND v5 1/2] mm/vmscan: fix missing NR_ISOLATED counter update in MGLRU reclaim path
Date: Fri, 18 Sep 2026 16:07:19 +0800
Message-ID: <aabe948bcfe6ae1d5fb422e570d092a3bbc7f2e0.1789718658.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1789718658.git.zhuhui@kylinos.cn>
References: <cover.1789718658.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DBDA280007
X-Stat-Signature: uciurjaiqtu44y43gmhdqk6rjnta8ymi
X-HE-Tag: 1789718870-872519
X-HE-Meta: U2FsdGVkX1+meDB2wOSeVMYKN5qbg2yw0l5nj14BLzmte3MoGkKLnitFR8o9d4bzNqUCQztYkA8NS86sJbI/xRWRTZKTDf/5AV7UjLdKWxYynotAgONmzo8AW5e6gNdjDjil0Rg4ail3RUa1R+ONVwwkN9XSDLje0OL4TN6IPMLlRVsxmAjpkg1WIGo+rC3S9qseMjpz+7H/1cVQxRuzGVrDMb8mvMtBcTUc2AsD/xFe3tGKNHSQCG5icIZEf4fPCpjbaHzwy4m4scEaU2PAKFmy6Jb2Oxrw1HvUBbDQfRD/KGB086FQIyvDGh+yXca8gFIZDVSE8SKFDoKPYFhutnUQJ9QKMlOUZZNfAfY1mMfjkgRIrjzFyhU1cPqV9Mj+I3ZipuqFXetuRNzF83GNZJY54vnhpDjRIrn2GrRDQ1aHI27L8oR+gWdVxYDzD2SrB+F/C/q4nKnE0Y0UokdHvlbUDByC3LRV46/JamCwRAbODVk9MitTYZ7zrAQN12UwWxs2ewfAem2N+c5QV9Sy04Emi8rJ+NwRMjP0R6KUvCYRk+UrsozJqbgX+wd0d8IrmF6cDxDDcuy0DrPLamnt6VmPv0+jQT8ovucVCidQvrDHiGlO73Psi/9azNAHZb3FlY6Cfr/r/GnWQeJ4I08s0DagdXx+TvwT7HZiZqqQcOb/XYYme5rIvJDttJBfj57Ez/MpfNmPykXgwHY5wWg9JaNbMhPx+OjJ/I0Yp1OFSSIDsOH1Vz1iUeyjYcgn+AGLSAnaZn8kS9/FH+sboPi/2EL5IVZsO/2zBBeGyx4qbarK2OYw39i6kVWhpCFSI6gXhNhnEcw5eppNcDNN6CdBb/gWtVHgZ3oc0NL4EGnxQ2g7J5qQOIGuNCTQmbzkZ1uX7mur0ocaEgEaepoqlJXGusrHUaFtA0DEgMp3wNuXtKoYBndN9/Muecun+q6SJXfxAkrN01mqnr75wcoBA9Z
 lopCctup
 OenA/cVC1iXFRSGNS9z31ZBQ3us0GzERSkxwGhPpXxULPgMnF0WOe1tSK8hRXwNFFjzWJbywvWLQwbRqvEGtjQdf8sSes/f46bpAga2mIneD/TnkPbz3NKPGUlhwQadMTgxlPqeHow1WX2VzjSHeAk7vDglwGtyqDpfn3ukseBeteMgD71ICGeH5USQLf2AW5sTuVAXqh01Z/ESu+ZT9LV78RFdt1VPwJPeC1LFYSwYh73WXaLyt4oJ1QkDMA6+pmTrxp6hD1idufqMIRxm25YH/W1Q==
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
2.43.0


