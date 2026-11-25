Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 381E9606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 11:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LwAxmjWC
Received: by kanga.kvack.org (Postfix)
	id 5D9C76B09C2; Wed, 25 Nov 2026 06:35:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B13C6B09C5; Wed, 25 Nov 2026 06:35:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EDBC6B09C6; Wed, 25 Nov 2026 06:35:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2E9556B09C2
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:35:45 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BC3D8A0ED1
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:35:44 +0000 (UTC)
X-FDA: 85473436608.16.4379127
Received: from mta1.migadu.com (out-1.mta1.migadu.com [95.215.58.1])
	by imf14.hostedemail.com (Postfix) with ESMTP id D0371100002
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:35:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LwAxmjWC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.1 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795606543;
	b=3RhlQFCs+HUQVxhxa9BZGL3cc1HBn2X7FjVHVRZjGqU0ShnoJ1+Ngnr/JAe1L9EnV5i/IW
	Pk8LppO/dL+Nztd8zE3oeKGv8oMikn5AFeWa/ajqsBQYdax0ZDV9omAlF5GREMJH6D1aPY
	o0H35+NTvkg7cGGjdisd5SmBlAosBGE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795606543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IYZQR2NWRm2aqXIEbQebL6wCc5yHIbEePswxQJEyMnU=;
	b=CGLG8uPGdfcJ614N5yM55kcx05lMFO8Ngye5zjprGEYOvNkMJrcwZDIJBjgv9kI4bDH025
	mLzZT/QFfLJPX7gffLHy91O/IPM4MFMRk2qnLNZZJJdUZfmSkSLEA4KRBZwiRgQk8OH9+z
	vGfJEzfS3Tic3W58RQU0fauaBLRDwB0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LwAxmjWC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.1 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=hyYSlPLEjHqHiuxc1EWVJHk/NKxvpHyxjjsLCf7xOrs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795606541; v=1; x=1796211341;
 b=LwAxmjWCu4z6VIUOybmhXd8R1IwJJJPysWeaGc4XNKu/zkAfAaLOFPDaQaWDusOsuf6EYUIu
 4f2PnxrMw1i59vJMLmKisq1uTiUuoSj9N9xKZ+8dXmKJ+zULN3ZVQ2K+Gwg7ovDvNzIUxJEyC0r
 C9xCMVaIG3CS3hqRo40atMiY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 236edbe9e403cc2d;
	Wed, 25 Nov 2026 11:35:32 +0000
X-Mizu-Trace-ID: 236edbe9e403cc2d
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: "Andrew Morton" <akpm@linux-foundation.org>,
	"Kairui Song" <kasong@tencent.com>,
	"Qi Zheng" <qi.zheng@linux.dev>,
	"Shakeel Butt" <shakeel.butt@linux.dev>,
	"Barry Song" <baohua@kernel.org>,
	"Axel Rasmussen" <axelrasmussen@google.com>,
	"Yuanchu Xie" <yuanchu@google.com>,
	"Wei Xu" <weixugc@google.com>,
	"Baoquan He" <baoquan.he@linux.dev>,
	"Baolin Wang" <baolin.wang@linux.alibaba.com>,
	"Johannes Weiner" <hannes@cmpxchg.org>,
	"David Hildenbrand" <david@kernel.org>,
	"Michal Hocko" <mhocko@kernel.org>,
	"Lorenzo Stoakes" <ljs@kernel.org>,
	"Harry Yoo" <harry@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH v3] mm: mglru: reset the mm iteration cursor in try_to_inc_max_seq_nowalk()
Date: Wed, 25 Nov 2026 19:35:18 +0800
Message-ID: <20261125113518.1207280-1-hui.zhu@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: xopagsombeytmd5qqz6ormxtmtew67ca
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D0371100002
X-Rspam-User:
X-HE-Tag: 1795606542-684681
X-HE-Meta: U2FsdGVkX1+ZiJpVwIGkk1XMRazxw4Ep3qDES9ZjsF2eEa+DbD5/6OpQcvEEgpKwDYDNnpkh9L2sI2AUnEt2Mcg3wXxQVQDNjwu1sRA9y81hSX68VnyVjiR6keA3etKVUyrdrb+Kz0I7hydAqZy+Mqx/F2N5ElI4Y7hM637so/PNQryevVdMZRcyStQ0/qum/ZiiWAKBB2eviqWcgrB/EbOcqG5wU2YT9q+KtNmrDc1qA3huFNtXGiTTdimxk+HbpQWD9h0a6zzo//ZSls/HxEevq+2Lc5g9z920SaxFxam13BleeUVSd88xRiNro+YUABXJauVtFGVjsfnnfz/y7mLpWyPxDKzEGx1UXoOjlKVeubq7SFxqNUPiiAAL5puEs33VVLkLxkAIUPVnXGxHiTZM8McOUPgWSp0IKxUzqBzCTVx6rvaHkvRR9iH1LOYbqY8URDFDOFDbx0jtgIfId5FxmS/iYg6emx5UF8IQ/e8UsWeaQtpIFVqq7VXIYRMzkP5T6XecPBUWwxGwx6zED4EIJk6hSiWCPTshkykHmczFjIW0il50vUXNCyUF0aK/GgleWekDsvh8qkTRQ7pTg36A6YKccUq147llZC+eL1oGRkgT+wgKgiUE8DcmcGs3yAkDBZioFTn6XYUVdCviOT4UApz+u47crBoVxEnGBHlHTIruWBk6P0CkNHaL+lyViPIueTn3LY9AV55FlM4r2bacJUAIBdueAagDesCh+13OuM5KiMIvuMUrI2qYrlCYidhL/PUQVHAVBGSV19cNDlBQSwioW88i7XTpep6QpKPurJKaKTwWwc22X3BrktmvrB5eqpHVoaRuyicAgJh/niGBsTNxLIIjl0P4orPHuQUtDn//pvlyLv2yNR0utdDnifWyHRvujOGKfIrNCOV/MvEgljJBH1KLvWDm2dHnsvzPDtX3fuL3+K3Gpx9vocqd/CQddCQtuTK8OMsB++6
 7pYb0PVS
 SZWHGyu3ziR3g7XSZrC4qN+Y3swM0WCYA6Xuzsgd8N2cs8mdTvz2ZIC5NrDHyMUlmtxSuWIxzSrbDLjYT9yriklPEzw1oQ2JsPlz2Kp1YblfX5usbYoQUOE/PqdPIXq0baLYy05gGyqZNukEU5gdURTgMdK2y7ul+8LnnYoXCxk1N2QnccFswuIfNjVSY69lcfh+SjrbOqTtszu1UGf0llJZyzL5RxcMEZIdp5tTIt6/dO++IQs/oG4sidLS/tMv4zfP3cNaLGRhY4GSWx2suQRPv2A5Zc9wkqzlUE8DP+DkdF9qsWsQaN2YumsFPsZ1ZvLm7lRq6MOOl0LVuopxKheukv8k7FPhiiJ8j+wpViMzO9jTmT4tE7dyK1FvNq8Mr38PT1aaefJYsJi0c4WATEmMJ08qQa8sX7hsKAjugcn7IJBc0NEfOXnggtJnzC4nXUeUlYqXrpkDyHl47mf+WeDq/cwbuDSL7pupE2tUUcb5cIMGV37JCd+Ksb4w8R1yzoWFEgkrd7cTOpST8HfWmatMivhdIlHn2kTf8md1ZfepsOb4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hui Zhu <zhuhui@kylinos.cn>

try_to_inc_max_seq_nowalk() advances mm_state->seq without walking the
mm_list, but unlike iterate_mm_list_nowalk() it leaves head and tail
alone. If it races with an ongoing page table walk, the cursor is left in
the middle of the fifo.

The next walker reads that as "this generation already started": it skips
reset_bloom_filter() and resumes after the cursor. The mm it visits are
the ones the aborted walk never reached, so they have no bits in the
filter being read and walk_pmd_range() descends into none of their PMDs.
Those mm miss a generation of accessed-bit harvesting, so their aging is
less accurate and hot folios can be under-promoted. Eviction can still
detect their references via rmap and lru_gen_look_around(), so this
weakens aging rather than guaranteeing reclaim and refault.

Reset head and tail with the seq increment, as iterate_mm_list_nowalk()
does. It is safe: get_next_mm() holds an mmgrab() reference and a
concurrent walker bails out at "walk->seq <= mm_state->seq" before
touching head again.

Only reachable from memcg_reparent_objcgs() -> max_lru_gen_memcg(); not a
memory safety issue, since lru_gen_del_mm() repoints head and tail under
mm_list->lock.

Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
Cc: stable@vger.kernel.org
Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
---
Changelog:
v3:
Reword the impact as weakened aging rather than guaranteed refault,
noting the rmap/lru_gen_look_around() fallback (Barry Song).
v2:
Drop the helper and keep the fix open-coded (Baoquan He).

 mm/vmscan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6a1af9b92349..3601e58f2a69 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4694,6 +4694,8 @@ static void try_to_inc_max_seq_nowalk(struct mem_cgroup *memcg,
 		spin_lock(&mm_list->lock);
 		VM_WARN_ON_ONCE(mm_state->seq + 1 < max_seq);
 		if (max_seq > mm_state->seq) {
+			mm_state->head = NULL;
+			mm_state->tail = NULL;
 			WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
 			success = true;
 		}
-- 
2.53.0


