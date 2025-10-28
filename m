Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0847CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:04:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 043BB80160; Tue, 28 Oct 2025 10:04:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F35E78013F; Tue, 28 Oct 2025 10:04:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFE0D80160; Tue, 28 Oct 2025 10:04:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C426F8013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:04:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8BF4587D32
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:04:29 +0000 (UTC)
X-FDA: 84047693058.27.99CBBDB
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf06.hostedemail.com (Postfix) with ESMTP id D5E6818000E
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:04:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GZWIQPg2;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761660268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MfFT50NAM4YJdcJwEiZWm9eoPKYAch/I/HKN7VyhW9I=;
	b=TM6mtYIlH4D7gj8V1msBWduiblY6MGS9831D53ftIyNnA6PMKPfzrhPvysTc7drvOPc+bj
	2fb1vBGALXXS9N6p+GEBCGlLYlIIYsnbXHaFAYPb0XaUgmBDMVZIoTOl7Q0lCwK0b6TBNz
	c8q4cpI/aU2f1OAKX8hrcoW8cm2Mudc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GZWIQPg2;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761660268; a=rsa-sha256;
	cv=none;
	b=RImcF9jhvWapNMCDsKrcoTYrSUYHsmnTxXe0xJ/a0vOEOcxHY3+i9j/BKt9BsCdilDueqb
	n5AIYECS51/PVvluhH8/3Q95zyPbRRY0I6lgIJluEK2DABi7XPU1SjuzSjK+GkTF6CEV8z
	P6zugNCr1i2qe0iFheelYONjZO5sD9I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761660266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MfFT50NAM4YJdcJwEiZWm9eoPKYAch/I/HKN7VyhW9I=;
	b=GZWIQPg2QKwgut9Dq3hgo3nl0aQwy3J/E5mWPtGNg4bdNwkQ+AI6uq3lfLJklHFfbHo+Pg
	3E7xR05XF643Awodwuy+5roySsCLCwXL2xAjK8TTY1IsG7QNx+MN4lIQAYKtvBXnOk8QdZ
	7rTdqleL9uVxBl3NuOZLwvW0LxrK80E=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v1 20/26] mm: workingset: prevent lruvec release in workingset_activation()
Date: Tue, 28 Oct 2025 21:58:33 +0800
Message-ID: <03a26f7d8723a42c29a24b03ed318a2830faff02.1761658311.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1761658310.git.zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D5E6818000E
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: uidtgodiffsp9t5zyyfh4r6md35jgmwy
X-HE-Tag: 1761660267-21361
X-HE-Meta: U2FsdGVkX193sDPFTRs/cLpivO35I3otO5CvU8X+LgKfBA2v8g6YlYd0DiLUJLHAENVABLa1aGtuIDwZpcLO90lj+yLXze65C98DezApSl5DZ4uF0OJrCpcW2wdkL/SmBrkOHO5XXC7T9QPO9Oug4dLWJt3qpaFX9bbeGEXe/UuP4u0TrCEkdOIadJsrGsZxlf/fJu8xhq+DgfMIN8oWaXEmBWnD+Wtk7HOqtr8Nirlx5+73Aeh9CYMwgzLdp4RJcbI5N/Koro8qbfP7vx1v4k5Eea3HdHphH8LSHNGgWxLVF0rMES28/wD+KzIJomv2hH7YBpxNh1r0mvECYqgz6pPrLIv63sOkWwUvEzH/aBMY/+ccRXXWnd7gsH+xb1RXBZtnB8oyECIpKomB9pVvnUlaWjS/cVII/rSNt4/4A5TJqq0H3pMeElMdDgKkmM+PCDJOZzPoVP+CVH+X7RHwyaLEIXsQfIZie245U7jKBOf83/Uqjt0BHWkRtAWBn+ckekrBeVU3QmOL2/BazbktS/L3A+CU2ymQ9As6gfUp/UgqDODMfIQ+uXw1NiHHeEp/F0Ut2kexT6EPDxPiHJYyVmds4RCjuLgli7hyHTb3NXPyFHdO2Cdyt0Zya1+9v1v2kLue1qxF9vdZUF+utE5nk0+/CyFV3RTe/cSydgBk/Bv7dBkyjwP1to0xYgUmd4uEETfXx4uALGY7X+9EAi2FBDqH7URYiGz8z7HHH3mEiRUT42ox/gCRUlAOtxlQgPJI0ikBDtmeWLOUHU5wcv7l2ZxkPgPaQwIM2Tf6/GYZcYCbIg9DcPbtvwUY22/yVKfnZ6TYLhc3hrmMpdxt90wlRAdT63UAuMrv3k+QSh8GYP6lX40xIey331KIh0tAkBY4FFO2uTy7eqdUPC8XdyJx6eucJIihZYvsUmrXYNV3WMYFVZRQw3SgCzOqNoctnMOWMz1pP0lghBRkZcJq0No
 5mkoCWWd
 AHRz8OlNoGgBqg7TXbxUiOCkvNTSlR1JDC+5VsCM6GvCGivRku7PCHTubLyObHqFHoKJIeeHVbNqOP2ANOhadvPdMcTh6DvElAT+RHPyoh9yHXX8RfEqN2Qipob4e8lJhvcyaC1+NhxuXAuiEzxFGbPW+jyOqgeZBZPdOs87uhw6bxfBgacLZOe/QsiMzpHQtSoCpnbrp0BNH9g02Osy+FK81U5B+13VobD3I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. So an lruvec returned by folio_lruvec() could be
released without the rcu read lock or a reference to its memory
cgroup.

In the current patch, the rcu read lock is employed to safeguard
against the release of the lruvec in workingset_activation().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/workingset.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index a69cc7bf9246d..d0eb3636dcd1d 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -595,8 +595,11 @@ void workingset_activation(struct folio *folio)
 	 * Filter non-memcg pages here, e.g. unmap can call
 	 * mark_page_accessed() on VDSO pages.
 	 */
-	if (mem_cgroup_disabled() || folio_memcg_charged(folio))
+	if (mem_cgroup_disabled() || folio_memcg_charged(folio)) {
+		rcu_read_lock();
 		workingset_age_nonresident(folio_lruvec(folio), folio_nr_pages(folio));
+		rcu_read_unlock();
+	}
 }
 
 /*
-- 
2.20.1


