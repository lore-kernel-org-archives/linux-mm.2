Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB9CCCCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:04:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23F238015F; Tue, 28 Oct 2025 10:04:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EF378013F; Tue, 28 Oct 2025 10:04:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B7C58015F; Tue, 28 Oct 2025 10:04:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBEB08013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:04:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B8DA112A883
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:04:23 +0000 (UTC)
X-FDA: 84047692806.07.20C2F53
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id F13F2A000C
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:04:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NVJozt+A;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761660262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aojrlW5QM0w8YO0ADBtzTkECPDUg/Z5IsfaLfTy6jEI=;
	b=SjjmhIydTtNPkjVJkArgxX0+qFUs1v+vHTQuu8XLpgFCjH75LHSj9DfBfO7h/iv1tD2kAq
	g7XGyNRtJTa26wy+6PCxmA9gHlnXnrZwu4z2hu793p8voYnRMZDoO5+bwaoJovz3/dHo3X
	vjuxrwFqc/eB+mB0H8heZFboqz/M02Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NVJozt+A;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761660262; a=rsa-sha256;
	cv=none;
	b=HWY0R8YERdF+HnLFG5Ojfuu41vG7fBZE+LswD+snAmHSaPsezmlPvmNJYJX1yYioomZWRV
	Ao84HEjaxj8gkNqwQWrg4Ms5uVON2GIMBzjdwDqK9rrKPoO0IKDrcGy9AjiRlGfk2yiC+9
	wuXAt2b/ZJORUIrCeziiF3P6ZOv8yFg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761660260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aojrlW5QM0w8YO0ADBtzTkECPDUg/Z5IsfaLfTy6jEI=;
	b=NVJozt+AdVtBShZigadtoWRY1WbWR7ZpmjhNfD5oqkNoSunHh7O3bg0e+LXQkCnelRdVjj
	X2BHIa3BeXi0buSPXZBq2lboVKZxjmF0FxqfxBUTEsaKvpiCYNFVxur3NjE4kwmfm6s7zF
	MSovgm+6YsP2wyb9q6luD8mzY6ZfbjY=
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
Subject: [PATCH v1 19/26] mm: swap: prevent lruvec release in swap module
Date: Tue, 28 Oct 2025 21:58:32 +0800
Message-ID: <c8b190b1b4f2690f12dee0e334e4c0b3f94ad260.1761658311.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1761658310.git.zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: F13F2A000C
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 45ticze3n7ectpwt91ay6hre3ph34i33
X-HE-Tag: 1761660261-459854
X-HE-Meta: U2FsdGVkX1/pfEujGag8Htfo8Pgv5MKyVWuThwx0c4ASj5g/U1/HgX8bMV8rxWp+fOI/04JjG7+7aQOINyA2vMODr3raM1OeDzqlrgce5pfbcCreAnAlOtAheWl6x+eF0FD9dqDN0rFPMN+WoN0FqPhvFHHRp+JtVP7EH1ipoURv+EqdCuFmCaLV44ZjIl2qTB56EmrT1GtKRLdp2IJeReMqYyHwyQxgmcNrdsR4RTMbU4Hj3ag57KIDMnCVNjEypR4bnT/ZqscINEyPsfpPSAPzLRi+O7IAiDXi0pZgibQCBQrldF6L9z09F93IWCMIBzKLzaDJRSyG8t7f17/RM4iv+ZnlfUnG+1r0ceCDNkb9OtSsy3jYUcj9lEmYiVz0k5uVJFl5A2lx8i70xvtO24JNEkQL3syu7+9IytmXfG2WxKgqAshvRnnIZzNEizU43J/5FUjmS3OG09lLIBjfNm0IAw4XJYFUC6vVW/8ZhJG37do/hg16DV4KZQB61bgB5P9B6pH/qmcdYuIwuBIfRCJykzEZMFojSNOKXg7RuBZezwFNxJaWhxJsgWSFl++e6Ep4xfudhfjHnNvWkqUTKKCN1PfkUWMT17pCKhFNK0ftVMe7zvs+MVUjTy/yAP8gv/g3ddKHBCDWjjhea2eVz+4e5J6Tx2/sJS+ivCGrfyJL8mdUKevsEX7KK9TRmNTEEME+KEBEJDLeRvTy3McOwoFOANphtogEdHElirHtZ+C1ZBk4wS7/FMnrPCqEwBACmN7bV05VQ++DTSjIs8kLs8Ga+yO6o4tB2n9z0dQpjfWCZQiZLF/l2XNfZ46UCAGz9hB5wwc+N16XXaqLrtOigGwTt6O8QjZ/mVfbeZVm8vTdLE419iNEgbGt1PZ7rLtk1/6MkZVjurQQjr/TQQnN6WnEYCdXL4XMH9jsZBks8vqMEVv99gNc1PVt268Vf6aPNQOYwg6xq2h5k+pjsoB
 P2SmXxq2
 f4X3STzdpz9QxuMlr7cePgV0kdwxzlgkBaTduroUybh42FRWMQczG5sBbuZyDZZhH5/3M/dbbT5UC7ZgqTXhg9q1GbPACKocwKzI4hoTmonTORFaHUf+GmQ6i/TFJX3r1no2yBAtG/XHpncuKit7fn9d8RRBdCCUuI+QINuOLUqMzMZIi6PzWGvGfiyjvE8fM/CELT0rFMrut+j/Ru7qICxsgAg==
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
against the release of the lruvec in lru_note_cost_refault() and
lru_activate().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/swap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index ec0c654e128dc..0606795f3ccf3 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -412,18 +412,20 @@ static void lru_gen_inc_refs(struct folio *folio)
 
 static bool lru_gen_clear_refs(struct folio *folio)
 {
-	struct lru_gen_folio *lrugen;
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
+	unsigned long seq;
 
 	if (gen < 0)
 		return true;
 
 	set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS | BIT(PG_workingset), 0);
 
-	lrugen = &folio_lruvec(folio)->lrugen;
+	rcu_read_lock();
+	seq = READ_ONCE(folio_lruvec(folio)->lrugen.min_seq[type]);
+	rcu_read_unlock();
 	/* whether can do without shuffling under the LRU lock */
-	return gen == lru_gen_from_seq(READ_ONCE(lrugen->min_seq[type]));
+	return gen == lru_gen_from_seq(seq);
 }
 
 #else /* !CONFIG_LRU_GEN */
-- 
2.20.1


