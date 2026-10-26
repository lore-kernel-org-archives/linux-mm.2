Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4659C606A325
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NqxXcyZ5
Received: by kanga.kvack.org (Postfix)
	id 6CB1E6B05E5; Mon, 26 Oct 2026 19:26:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A21B6B05E6; Mon, 26 Oct 2026 19:26:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B7566B05E7; Mon, 26 Oct 2026 19:26:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF8FD6B05E5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:26:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 969048031C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:26:41 +0000 (UTC)
X-FDA: 85366364202.06.859CEAE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id C0A7440005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:26:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NqxXcyZ5;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JD3h3UamRh59QcjyL8J1MuE/w/u1X5RZ3DOsE1wllXg=;
	b=qsrK1eD+UIhBbvTqxoZY17GXf3xLPXOW2jRLIW+wLw6/0GmaRiX+3WWSGHC2PDaAOYD7OQ
	WqnGcrT2pYw4VWc/Bdip1eIICicx93xaLZ+PylJaPBei3+WoDfCxBEJL4/MIcij5p0iBSk
	seZHXfF+gVAU+o0z1JTR5eAQtZvbtOs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057199;
	b=iz9Zx2ZAEso8NGYcpwFZQUpQYumWu5grb/4mpQZNyHcS4NUpmRHhRB3oFSCMI6nOe6q/i+
	B0PnTVjEZM0xAt6zrv+V51jl0uTkzm/+0WypeusLX4GEDZzUa0rK3lygtaJXaPe31lCE+k
	UtLvgAB6+EsC5yghbctwahKY9dfLTZA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NqxXcyZ5;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 19E2F411CF;
	Mon, 26 Oct 2026 23:26:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A8C1F01825;
	Mon, 26 Oct 2026 23:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057199;
	bh=JD3h3UamRh59QcjyL8J1MuE/w/u1X5RZ3DOsE1wllXg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NqxXcyZ5B7hNxVICB8D7ZuTu2KTFj1aY/wZHjWEHcrphKUZXEhErMydzk2Pzo1mLO
	 KXsakbOlKadHDvCpmoPg4VdpWYop82udMmVVbnJSsa/yNZfnIpnc7zXVJuFxKNqzsX
	 XXtyntURfV0Gyys700YmRUpcZNsNBwSVXZSPdu5SAf1AyhwNb3x1lfgitOWD3HGdQS
	 vWS7Cl3Pan8Rn7XnMFij0eGv/K6IbU4S0Jzeq3EhdCV3hZuhxaFbAcpEYOR+STaAHN
	 NiDWgUxmVXVvm5yitg/azM9C5yVHptICOOnN2qnAup6cV1VLBTsoFalfWOvsoe9Zzc
	 roonF+qboPgYw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:48 +0100
Subject: [PATCH 28/46] mm/mmu_notifier: set ->mm only after mmgrab()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-28-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1928; i=david@kernel.org;
 h=from:subject:message-id; bh=x0mKttz+HwDvoeWV/WYBCh6ori+6WykC26zRhsHss7s=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu358WvjBTPacmt4dPIdDk5tcpn+01cwTchGfUrDY2m
 /szsutzRykLgxgHg6yYIktQ8H2Dly/X1Va78THDzGFlAhnCwMUpABOZdZHhf0TH64MXTnQzGVbk
 qRb3zPUxmqEu+rl0VcOt4H8i+Tv3tjEyTI9WCD+789mjnlXPFlqk3zA4dezK72lrV9nE/lCeLr9
 WlhcA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C0A7440005
X-Stat-Signature: ax861wwz49os9jk1gshh4r3s9xrquixw
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793057199-973200
X-HE-Meta: U2FsdGVkX19fK8l3o5D9otlITY8RXeMj26ZT5oabcH00Qp1bgUKXD2tXwMP+RlO8PXRXJhZsO18BPVL7qa+FqrED67g+hsZzNdTvUJVSuFu0in/2L457ZRSE8ojrfKsdSVRr+3iIpb9GnpJeZVRIKIRFstcb4IRZsptPsIykyZNZi9HsZMbVBfit6BuC1uao0bPhYl9rdGEGTrDJCGd/dLf3CpEhCFt7SGPIkfo+1up8Dt4Ru5vj/QBPyr4fV5uuFA04IBQbAKP1GsGojaCWDe2LMD3AYkTFzGehq7yAGUjNQHYa95X8l2I6BSIVt4fbdywndjey2xO2W6jqOa2K0Xj05elwuT24LF4SCf9Yy+wQsdivqnNWijkWQCj+ZzCDYdenl81r3tBkEG1Zg8UpM8NlOI8mIrQyxrKxqju8uke9HP0LkhmFEhUmA+LQdiLO19EuuveBw3f2ddeW/60xepW0iM4HSAn4GE3fN4JTizFq8/DyYAjv+C+QdUkYacjkIkEvoMfZr2YVKUFqH03SSCSB/89KRA0m3UimxA2qlSDtz9iBH5LvrVOEb/pnqS6v4kcvhxEH+xCHufwvfw8SnyrJm5sHtJcN/0eqCR9n7qP5lTnNmwGc11FMTqjLF4xZYGuiAiURrSFI9zBeOeVFnGEGDcQVxM1oa4+Vfz4ojHH8oj5cIYopYX7JLYZ3m/5h+uTHxKBNw/KhpW/Iykdln2PilJ0pY73yBxleyo2ysFgkIQ9pzV+T0V7QZ7BiId6TyKMslfcfiiZTY/doAUAvb/s58j0fjY1vDlBmIp0deYd5eq1rzH5ox8APImYPyWk4UTYwc8HMl3LgZ0DWsgSj7yEZL+3GaKALiK4PBBAAJXTPRFZJkfHMpmRP5HbJRRlvIeavw62DRanewv9PspwMLnWJqU2Q89X/a3MiuMTGOFMqFdb2zmEe21yU4e70jWPQ/oKjBaU+MWKBaB+7BlL
 EC6ilzur
 jbW++9uTtcdZ+kZ0/sUZGRXuKx9m/mAozte8Rn5/jZdOuTwYqZVYbkH6ebf/5yBGZJnIZW/ODDyk8vhBtbzYUgzrX1sw4yyTWmfZhnM45/kZnBmXjvvt/xXj4yoR0TNuctyPqxiGSG8ap9x1oZrrnl0ssKDOBNZpxlK8420u1xnHegAL/CdJG+WN+/e3f1LdFVxWmPd4slS0rPenpx/rpP4pIGpRUP23Nubd7C0m9f2mH4OLVEf8Ff5/f2/cYtLfl0JMf+gTOWGW8gvFnrBV2Qq5BK6SfGl8WUluljz2O8veoAUCoutzLa/VlwPsip97Fm0h3GH98F4UEfs3dI5B2Nd0Z2fSVYESRptbrvsoSsG1be5l05neVln1Xmmz++HSVslM8SLwnDK69TaMdyqUHvjtYEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

Radeon uses a non-NULL notifier->mm to decide whether to call
mmu_interval_notifier_remove() when freeing a buffer object.
__mmu_interval_notifier_insert() sets ->mm before validating the range,
so a wrapping userptr range can leave ->mm set after insertion fails.
Cleanup then tries to remove an unregistered notifier for which no mm
reference was acquired.

Set ->mm only after mmgrab(), once insertion can no longer fail. While
we could fix radeon's code instead, setting ->mm on success only makes
the code more robust.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: 3506ff69c3ec ("drm/radeon: use mmu_interval_notifier_insert")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: simplify description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/mmu_notifier.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 2e20f88e162d7..a7bae5de5fedc 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -947,7 +947,6 @@ static int __mmu_interval_notifier_insert(
 	struct mmu_notifier_subscriptions *subscriptions, unsigned long start,
 	unsigned long length, const struct mmu_interval_notifier_ops *ops)
 {
-	interval_sub->mm = mm;
 	interval_sub->ops = ops;
 	RB_CLEAR_NODE(&interval_sub->interval_tree.rb);
 	interval_sub->interval_tree.start = start;
@@ -964,8 +963,12 @@ static int __mmu_interval_notifier_insert(
 	if (WARN_ON(atomic_read(&mm->mm_users) <= 0))
 		return -EINVAL;
 
-	/* pairs with mmdrop in mmu_interval_notifier_remove() */
+	/*
+	 * Pairs with mmdrop in mmu_interval_notifier_remove(). Drivers take a
+	 * non-NULL ->mm for "registered", so set it only with the reference.
+	 */
 	mmgrab(mm);
+	interval_sub->mm = mm;
 
 	/*
 	 * If some invalidate_range_start/end region is going on in parallel

-- 
2.43.0


