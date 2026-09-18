Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B56EDC982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 16:34:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C95946B0098; Fri, 18 Sep 2026 12:34:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C46096B0099; Fri, 18 Sep 2026 12:34:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0DE26B009B; Fri, 18 Sep 2026 12:34:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 834D96B0098
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:34:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A1FB640701
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:34:55 +0000 (UTC)
X-FDA: 85227432150.02.B84942B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id CB839C0007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:34:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YlNB6es5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789749293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y2ursOTDbgQ5WZsTMNPGX/EH4HSKwisDuvpZ2m6uqMk=;
	b=ucep+NtacCkEoZgB93q5ydP5sWdEEuQ0B0/qVFrZPxRhUB5tXGM2bPwIDhIDQRSb1sD001
	4G8Imsm7XWvg540BRqaluPu12Mzccbe0V4SiyE4Sq22EagaQi0+q8X3idd4MmDArnyiuOY
	smlzmA5U8UbrBz2WRPwk5XZaf4IYHXc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789749293;
	b=q4eEGM2DxJVzmUTHC3NFRwQnRxbPrprrrz/7YXqDLasVQw4cAab8SFT8FEpI1zA4wQfdtI
	fItvA+ypIFeEq5pbIDFVq2DelLnVHkki3/dq+tGOfpNhVcbGPH5QC+XOdXSipnwsCaT5SC
	vzVNvbdwECULX2HJR1MNGQj2Zx49DaM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YlNB6es5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E191843DFF;
	Fri, 18 Sep 2026 16:34:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC091F00899;
	Fri, 18 Sep 2026 16:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789749292;
	bh=y2ursOTDbgQ5WZsTMNPGX/EH4HSKwisDuvpZ2m6uqMk=;
	h=From:Date:Subject:References:In-Reply-To:To;
	b=YlNB6es5ZAY97rM64G4VaQskerl5o9EyMXvvZpRnvHOPcR2aUnyGpoAuCTsc4NsEI
	 GCRFAr1C0JadbMKaJ9GNPGPNvyZxRPd0Uzn3NEl08ovrM2oBcAtUkoOUsn5XydYVyA
	 aoRuUwUm+U0UmshwNYMnOjENC17xVyoaPDo7iAWKQY2+88Imwt5Dqo2OcznWwLSqc8
	 HsjMe1B9gvHwrKjMB15KJrCcYNoQnl3WDJnpzYhml1H8spTkT9T1Q7BurgVXoT3OO8
	 weM6MxaXGG6BLogddc5Xd7I3T7LB9X8dackh+34JYBqQffnEiG/on/XOnZJRnVAbcM
	 Z2o9vmb+qCJFw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 18 Sep 2026 18:34:24 +0200
Subject: [PATCH 1/3] MAINTAINERS: split up MEMORY MANAGEMENT - MEMORY
 POLICY AND MIGRATION
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260918-maintainers-mempolicy-v1-1-9a94cac6d135@kernel.org>
References: <20260918-maintainers-mempolicy-v1-0-9a94cac6d135@kernel.org>
In-Reply-To: <20260918-maintainers-mempolicy-v1-0-9a94cac6d135@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 Rakie Kim <rakie.kim@sk.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3452; i=david@kernel.org;
 h=from:subject:message-id; bh=mOcjDBoxi4jC+KgF2UHzT++wwk77CLE5fJZy2jPp9U8=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLWZii7J/Au83Pp0Y+abTSTa+G2S5KeVa37dadd3vJEW
 lHvUcedjlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACayazcjQ5dG4fObm96ouXa8
 nOrhYcLj+8r9Q3aVqKdk87XOCZP/qTD803uX/aa24JvATCs7732Z983uvvnhyRIgdKxh4wu2s0/
 8+AE=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CB839C0007
X-Stat-Signature: kcebrfphaapze3e7bpt914t7nrgwg4d1
X-HE-Tag: 1789749293-999937
X-HE-Meta: U2FsdGVkX1+6Sp3BRY8fPVAYaT+1ozALm9oV8XDL15B9Ektqu+EbKIQogoI5AosYHfdyUieqbUYbac8MinfY9L2Cjya/GSAmKTHQ5cC1d0KzkM4uCPVpkqE0ie9KbNd5peVLDnoqy7ZCMQN6BUX17Z6VRpIc/Qlw5+pBsZ4aGQ5ADxxDo4htCAd0pDxJCGzSdD7i0R+zZtHXpM9SknNZLS7peDZ2+dW70/Dj9dwbtn/TULVZDQXbF3KNiEXtU6x+kEFoiwerC9AdOllfr0iYPrBdbMEnVviJB5WXid0sxl3qAdI6kLre2GOoow1kciQI7zXMRYlTtluRP3DPAO959JokvFu1q+Bbkaco+rSe85XmfoHVzp3ZPRJF463IfHwJBqYWBJPfkoX6fhN+9vsYoMzPh38K+pTTIEJGOHCyuprepV2anoZKZdTxapw8+aq2CVLRNCT1QBqudVAzQ7XqEGtvqoM1TAJYAAT+R7t4HTjnuQBW2VzJolNZOqjIayfKqfIwxCYn/IvyqqMX9KOki7rg97q4XDWled3C1EtZnftCDnggJSAE/TQFZNr8jSpLBJLgje59dCequlgXqxwuJWjclIclzgePGZrK4AKQ9LrkMNZ60VNvHkGf70i3Vi+nihi/LsXOQas7mQG+68uhUtzNPIwDMW8FCtORnz9lmCG5YCPywOG7xK9JpfaFZdnkl8PGDCooE8gILmR6Qjt1CoiM4vpOl1iS9iY4mCsdx4j8sxgtqhIy8tafxS3awFrtDoKrzxZ5ZaCHdKnj6AKhHZFuEdqMQvrf1lFUPlkIVbg+2MYMwTjx+SagnAf/q2G4BXsfiPrMuAhmqR5Krq7u2UI20j7suFSC9R2frWEgrpcYGXguUAmp7wL8xqCfZQDknNjtguZn4FcHfnfmODonAskl84ku5udM4Fly1OqXDMO79omSKHISmXg1oc/q/oL2jL4B2lL8PzStICCgvl2
 +KqV+CHW
 OQMwLxzzM/lOZsXD09YqFFUXWIITrea+ZDlbWLm0zgM45hisiPoJA+g34Ftz1wP8QSSdTFcsN8h1fNxiiK9G0dMKrgFC6rqLyIN/fqswVQh9/vilLtsrWp4AOKEBaMUvtA0uFAwAPmKIIMyRHEyvE94vUnDYAPOul/+ISChRtIghTWPnfJW/HEPRyJtpXx6DvuClcIPrJxvNchn3RsiClfi9YIg87swoV8uDiTHObscSb9Hby5rU7mOJV5fxQ0WEo7PZswkcaCCs5XEF5p3ic7ymvSMF1GfWVTw6Po8adVZl5AoSIeCtSpUW0gZ70gtfnKogmEsjfWmVdFv8+wEKv1Rws5Xv0HQm9rxDbYer580I0qTeVVW+mc2Q2Ixex8UPuzrYOlCulrjKT9sv4mYmwcTpBL61jqt1kypJrA/IsXO7dTVkyOdQeJ/MAYBPV/g4vW3XePCwL/0XnhVd56J7KJqxoD9d42QmExWSs1az16zesFtBZkW/rcZSOf3iSyGmtpLuMv0/fvbdF6S/SH+Bys086Yn7qgU0CyP3UvfsfBIsyHtGa7FD39q6DGlPwN0KETsbATlbtkfNkkPJBGHb/B1hYJcv7gwRBbRNrQgo2bVtd9QYKvvMOZr0oBaE/IQeUj3JkhdC9+CQxv8qCDGXlZ5ge7HUrRtIcj6jaR+u0ggkTpPjkz0p9ASlgcnLRYmflC3i3Gdz3xJMtWB19dUdzxw6pL9HDpBEkVJYE+LibDyzstjsDEM1Opo9fC4TZXvpn7808CSL8HnJymS56zQjJGMTrFSlqkeglLDJ2B3W/aV2qvMA6QjmHMspn2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's split it up into MIGRATION and NUMA PLACEMENT. The latter is a
better fitting description for mempolicy.c.

Make a best guess about which pieces existing reviewers are interested
in. Move the split sections to keep alphabetical order.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 MAINTAINERS | 62 ++++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 37 insertions(+), 25 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3b2eb2a7a89a8..77232db57b53d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17207,31 +17207,6 @@ F:	include/trace/events/ksm.h
 F:	mm/ksm.c
 F:	mm/mm_slot.h
 
-MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION
-M:	Andrew Morton <akpm@linux-foundation.org>
-M:	David Hildenbrand <david@kernel.org>
-R:	Zi Yan <ziy@nvidia.com>
-R:	Matthew Brost <matthew.brost@intel.com>
-R:	Joshua Hahn <joshua.hahnjy@gmail.com>
-R:	Rakie Kim <rakie.kim@sk.com>
-R:	Byungchul Park <byungchul@sk.com>
-R:	Gregory Price <gourry@gourry.net>
-R:	Ying Huang <ying.huang@linux.alibaba.com>
-R:	Alistair Popple <apopple@nvidia.com>
-L:	linux-mm@kvack.org
-S:	Maintained
-W:	http://www.linux-mm.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
-F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy
-F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
-F:	include/linux/mempolicy.h
-F:	include/uapi/linux/mempolicy.h
-F:	include/linux/migrate.h
-F:	include/linux/migrate_mode.h
-F:	mm/mempolicy.c
-F:	mm/migrate.c
-F:	mm/migrate_device.c
-
 MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
 M:	Andrew Morton <akpm@linux-foundation.org>
 R:	Kairui Song <kasong@tencent.com>
@@ -17252,6 +17227,25 @@ F:	include/linux/mmzone.h
 F:	mm/vmscan.c
 F:	mm/workingset.c
 
+MEMORY MANAGEMENT - MIGRATION
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	David Hildenbrand <david@kernel.org>
+R:	Zi Yan <ziy@nvidia.com>
+R:	Matthew Brost <matthew.brost@intel.com>
+R:	Joshua Hahn <joshua.hahnjy@gmail.com>
+R:	Byungchul Park <byungchul@sk.com>
+R:	Gregory Price <gourry@gourry.net>
+R:	Ying Huang <ying.huang@linux.alibaba.com>
+R:	Alistair Popple <apopple@nvidia.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	include/linux/migrate.h
+F:	include/linux/migrate_mode.h
+F:	mm/migrate.c
+F:	mm/migrate_device.c
+
 MEMORY MANAGEMENT - MISC
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
@@ -17304,6 +17298,24 @@ F:	mm/numa.c
 F:	mm/numa_emulation.c
 F:	mm/numa_memblks.c
 
+MEMORY MANAGEMENT - NUMA PLACEMENT
+M:	Andrew Morton <akpm@linux-foundation.org>
+M:	David Hildenbrand <david@kernel.org>
+R:	Zi Yan <ziy@nvidia.com>
+R:	Joshua Hahn <joshua.hahnjy@gmail.com>
+R:	Rakie Kim <rakie.kim@sk.com>
+R:	Gregory Price <gourry@gourry.net>
+R:	Ying Huang <ying.huang@linux.alibaba.com>
+L:	linux-mm@kvack.org
+S:	Maintained
+W:	http://www.linux-mm.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy
+F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
+F:	include/linux/mempolicy.h
+F:	include/uapi/linux/mempolicy.h
+F:	mm/mempolicy.c
+
 MEMORY MANAGEMENT - OOM KILLER
 M:	Michal Hocko <mhocko@suse.com>
 R:	David Rientjes <rientjes@google.com>

-- 
2.43.0


