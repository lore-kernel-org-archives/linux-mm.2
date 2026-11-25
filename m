Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 251CA606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 07:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XuevB5jE
Received: by kanga.kvack.org (Postfix)
	id 0DD166B0925; Wed, 25 Nov 2026 02:39:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08DAA6B0927; Wed, 25 Nov 2026 02:39:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0CFA6B0928; Wed, 25 Nov 2026 02:39:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C8B406B0925
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 02:39:51 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 31EA81C494F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:39:51 +0000 (UTC)
X-FDA: 85472842182.22.CC500D4
Received: from mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	by imf05.hostedemail.com (Postfix) with ESMTP id 928C2100007
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:39:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XuevB5jE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.184 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795592389;
	b=5LZCxk8BSDdF9sK04FfrxvtNJsxY1knXdwxoHPuUeKrNk2FYvquytga9HZxLh1H1MSrcEg
	uLpfYz0zTqIhnI5am8b1px6YoAWls3X+2PBSdvm90AROcRBigGUTHF5ofNDVl2io40IMw5
	n6D20dldVare30b1koB/ynaRPe6wsoU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795592389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QyuaUJ+4lg3ErXzz2AqnSWN5VklK1zHAWHe8IsT8cPA=;
	b=ZcLnTS9gx3JelyiuyWNEni5pWZSR7GAFDhCk8gMZVhNPBNCh064u6hSypASVkroiYXgx+i
	4oOTuLPlQWffdmxABt6gLbpP7fc88ul4Ss/Y8hP+g8Chg+hjYRFBixSggG2S4kaRRbZeUM
	4/BKRRd0gpcBT5LeT8YjX6aw6ODnjlU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XuevB5jE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.184 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NdER6oRtsKeTuIl117XW6vlFvInI0gofh/dTxKEIjdA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795592384; v=1; x=1796197184;
 b=XuevB5jEtDVT7lbmN3LnMsW89qiwuRnyo76pyWeMbi5FjQ2efMB2L6U1qRcWOfPMRe3C90S/
 OH/FqJpxuOcElORVR6yqFy/NI1OSxwYOfOGvwGh/mRkGo+JzWBchPK7H5vd2A7O6dn04DmYRP33
 5f7iNf+tBRdaWSre6gMvphWA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 882ad378360a5791;
	Wed, 25 Nov 2026 07:39:44 +0000
X-Mizu-Trace-ID: 882ad378360a5791
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
Subject: [PATCH v2] mm: mglru: reset the mm iteration cursor in try_to_inc_max_seq_nowalk()
Date: Wed, 25 Nov 2026 15:39:31 +0800
Message-ID: <20261125073931.1171242-1-hui.zhu@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 928C2100007
X-Stat-Signature: r8rctkfscu4th11g8r4wimpfgcda454h
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795592387-119801
X-HE-Meta: U2FsdGVkX18KuYJHT9270gohNBBfgdxkxS2//Hq9VAsT0+PFZHe3B0ZDFTP3uZKvbxsKVEC7I1V3IswN+DE6SoYxRnzJRWmFNZ+tCRmBx4joQbKTivf1tXkyR6MT09nVCSZFtIIMvrmiGSoGlOZl7urC3syC2LT+1Q7dEw0hXehzvv+lvgge9XayTfM02xWQdyfILWGeIceYWIG6vuVD6BZndvbv4vHkWs4HUDn7U29R8VV8dm/CsRjqdgVTwfJ95BYGswgAJ4jfJdoQLOpVCqHnjmwWXDm1ehih6Ay4Ls3F4iScoyobyaLjaVoOdFOty2FXCFMrI7ZXunBZJX7+FglDibQBw08jGMN1JuCOa+0cqs+eHE0hv5EAIU5PxjntHCai9BhomfLVa0zicMkvQtkpcVQFm4Gl0HyeWwhVkdTGrdX7xv2cUdVIGakWV5i5HaLyCEPrgdR7zJSyMrI53VTh7TrrrnhBoJUJufAseu5MTzi2QINioRMIcxvpAvIHO3MGUX8mkTgLOtHzxJRvL/2iTZ4L4Uk5jBAqTDGUkNc38OkggJWqTj2hY0Gy5+4i/xujx7zYU8w/LZ4tTMTykJvJpJ9pEwjLO0HmLLDoqbQUnq/PvFQ0M6047pphRu3Opqc8S4EH7TDaV1AqCD6pQ+ycENzeU+AKGhcq33hFaTWLfvNUnjWwJvNMsd6RUmk3kVrNv02ZcPMFPkQKeYiXND9FSLPTBL47/AEE9y95WbN6c2DgPixzmGVIL51fmpqwaxsep6YJk8sf6f4GD7jXa13vcbChbDmAOn4rPWZB6s8PZGIUiUiMyS96lUGSOm8L3ohViJ4fsBtyEpiasmiTUPUIjGLpKPZXXeqZ4eNS8NjMeAoqZ4q4tBjyEXbRg3ovrdK6EmG7gBODOeiQDhLDKZyHUNDDlD+wkXW5UBMKeS6DdXVHBE4MbjaP7Q8AIo/dZj+Vo4gfBhNIizgmxZs
 HWr4KZ9I
 GxLtg0EbxBp5hOem3YZiBt2AbTfll8w1wco8dg/HSPBaD7NULjY8xtCjlDGCchBH1dE9LcTB3xcauEkg5/VHJLKsp358140i9JXjBIjXSUjdzQ09eL3cybe/KzyC4mPH+wVgQz/9xmgo81lowpOAgITZNll39OU7q67URakl+1mm3iWodxH/fKKO05MGNf7BRKcRT8KsxegA/gWEbbFgK4ZWJ4XTMqEP9DpYRxU6nHbzzUow/C3oiAqKXum5O/9yL/AQ+lmfFyjGv1Hz0Jiq1ZKj+FWOWZccD95eXus5KF7ISCm6ga2hMnnwxM5JfIGxZV6EKMQ8HrdVCWzf3OUZk6jZdXXLO6FTmijuCx/qvs9xqkvpHtwUAJSXLalSzcx9gP6A06G+amC6vMEVErmDJC0fQSqaBn8LCNYVGxN3IjpGIJ9VXHLBztepIWyav60WtkCZRbqW+6ZvdtQASBp3XXa+lRZZNp/iIPfL9K1vNGhmtG8l2rDdsFZS6ScFOLuENdGV4U8HCje3f7V13h/Q9jd1/Zl2MruMC1IHjIOOrRacBvgs=
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
try_to_shrink_lruvec() ignores the failed try_to_inc_max_seq() and keeps
evicting, so those hot folios are not promoted and refault in the parent
memcg, until head wraps around a generation later.

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


