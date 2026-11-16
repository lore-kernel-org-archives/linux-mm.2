Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01988606A32F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 06:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UJYOwvTY
Received: by kanga.kvack.org (Postfix)
	id EBD106B00EF; Mon, 16 Nov 2026 01:12:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E463A6B05B0; Mon, 16 Nov 2026 01:12:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE9486B05B1; Mon, 16 Nov 2026 01:12:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ADF0A6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:12:06 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3BC3E808DB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:12:06 +0000 (UTC)
X-FDA: 85439961852.24.FAD29F3
Received: from mta1.migadu.com (out-40.mta1.migadu.com [95.215.58.40])
	by imf05.hostedemail.com (Postfix) with ESMTP id 20937100007
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:12:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UJYOwvTY;
	spf=pass (imf05.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.40 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794809524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0RMiKm8OhZ/whW1u17DDxpoYgGPWHg9pbYjHuqCA9VI=;
	b=7XCCBWh1OZzVXKvoMb/leiEk40Qn4FUNAwmxKrKJZ1TszAUHacu1l77170BrcGiBVFJdNY
	LOvliZtmeLx3hJADr1pvNNOW+WemqEGTgEITHxCimS/o+o/1xOmuCWF4Soz1NkqdmFIC2a
	PZKFbJWj4mBiubzjSDYBoVtdb64UK9A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794809524;
	b=Rq9TsEyJyjZFtxgWb5O0r1L4PSjXhOQyqjofv6U+sP4bAAJO71UVxajX0nQSd73IbOueLk
	Z+5iD4xIGk7y2nPYnjpI4UEb+4SIcfnd0B3bVVaEjVCV6dXNG0VcONf+nEWqFnPrrxymCV
	UsOhjbbBGrYg4hSzSXM+KEWKodoQC98=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UJYOwvTY;
	spf=pass (imf05.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.40 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=hQuBY7FIlaTSnxksxhCcBvzfrEGVlJz/9yiTBC1ZBTs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794809522; v=1; x=1795414322;
 b=UJYOwvTYw4H7n27qc1Z2QjVajGDz6CUxx3VwggM5WmfTD3NjdbwW6zpUWhQSsSJqwfIkr9tI
 PO8kvrWvcnDANPU06ug1Om4c0rPTPrcHaMElg7p+F/rKu+LKXoxztPuIFecMtlM4Gvr4WtrvsU0
 NUco27WbtJb1cp/sK1/gR5yo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id af38cebce14534ca;
	Mon, 16 Nov 2026 06:12:02 +0000
X-Mizu-Trace-ID: af38cebce14534ca
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH v3] mm/mglru: use a smaller batch in fill/drain_evictable()
Date: Mon, 16 Nov 2026 14:11:58 +0800
Message-ID: <20261116061158.333826-1-hui.zhu@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 20937100007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: kg985hhk8hzzwdpof6g36su674gfdf3b
X-Rspam-User: 
X-HE-Tag: 1794809523-719441
X-HE-Meta: U2FsdGVkX1+ihCQcZZy/qQMpXCkjeWSVN8JahYi+KhbdDO4YsLJFjra/YhkQ3IevpE9kSvXbsGOoSAGpao7E44usWAKx0dTdMb0CCCMtcOjH5nkOxR6JVijvUqiF4F81UKS5p8smgjs2AYX22h8CFQHC+yXZQ/FQ0XFY8Yb2QhhV5W/4IIc+gW0wHW8J1rSdpe9Ut8sYtUkdr2EkHW5K+THKkHpEYiOrs5zQa1AT5ASCwcH7Ayyy8y6wZb+DofAS8vUgCpehm7BLxGSjR5Gc+orLan3osTbipS6QfPIWqEY28Ws4DB2abN8/n4L57+xYpsTn/PjleAIpCK6yz6s7blrBoCqWPWmaGLZ/h+yytFYo9W37vuCAQ/YpqKDIgYe0GPDCI4uIEHfU/mW3r1cYOHgwpW8hAPutHg6C8NNelH8Aoxz3f4Vuk1UrSM6cBsZyo8hVCSYX2pWwcn6QpyhGG1Yz0kwHQzbi+KQK4Oy0jx5c+wbYweKiEcHwp3ubL8/BcJ13RklqmWmMj//9bqDYOSs8qV6m+ecE6DBuJykQeUCaXBn0qIjvZaLWYEXy/RfKNa5SUP1ioLPnW3jgP22gnU6HoWFUHlnWOsup/aTuVLBLH1QLYV2wKnAPEAVmI5ivY1kxdFzTbjKaBtoCMqmeVBwA/bPE2F5kXItTCsb2sZ/ATJpmWlmZw3rD+TTKhoQr2/Apb62u0/gI8ZsX+Uh9Ax6nxVJ8iXgcceBiUbuE6aOh1lpxEpzO1X/San6zkcBtxjzcU4pLrXpc4W8c4N5nIfGz5mSPDZeSST99IAMWI+DlarWFBpr1t+GXXtzHfEZkseQ5Z/R+g9J6cSunGIcOrTL+NE2AJ+S1yI5vISUjoZz4rp3IJBAZxlozrq0D26jbLqKxwJ7Pl5jVn7PvLS64SS+Pvw3Iu9B7BeOLpgE2+dOQcXJG8EqlH0/GLpN033r09MRX2FhezjTEFcL73oK
 n6WVP3Ry
 xbnQi5zxQRDqlwMpauft59ZobBshjmbtZ7Th8/Y9LcXLpxOVJ2Q5cDybw4R2dfE+IVSEE9j2BSFba2/dmOd1TlsiW0PkvIyBsbLkUF1at2QODv8uwmf24U7VK9lpHl7n0bc1TG36z9i3KVX1H9VcEWEovecCpaBQwM4k5/52gFKjLr/Ue+h/b7V+hzoLUVfC1kndtwOCrj22R8xqAhYx8ktD/QtZvnZC/mcdWaLot5egU41rVWe3wJyYruhWnYyUh5GFemL1ZmWEJuao3KO4rRnzx6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hui Zhu <zhuhui@kylinos.cn>

lru_gen_change_state() migrates folios in batches of up to
MAX_LRU_BATCH (4096) folios under lruvec_lock_irq().  A full batch
keeps local interrupts off for up to about a millisecond, and CPUs
contending for the same lru_lock spin with interrupts disabled for
that long.

The caller already drops the lock and reschedules between batches,
and the restart protocol does not depend on the batch size: both
functions make monotone progress, so a smaller batch only shortens
the irq-off section.  Use MIN_LRU_BATCH (64) instead, bounding it to
about 15us.  This is a cold path that runs once per kill-switch
toggle; the extra unlock/resched/relock round trips cost a few
percent of wall time on an otherwise idle machine.

Same change as commit 6e9be217a3ce ("mm/mglru: use a smaller batch
for reclaim") made for try_to_shrink_lruvec().

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
Changlog:
v3:
Drop the need_resched()/spin_is_contended() checks and shrink the batch
to MIN_LRU_BATCH instead (Baolin Wang).
v2:
Also yield on lock contention after a minimum batch (Kairui Song).

 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6a1af9b92349..054af6cf6a2e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5499,7 +5499,7 @@ static bool __maybe_unused state_is_valid(struct lruvec *lruvec)
 static bool fill_evictable(struct lruvec *lruvec)
 {
 	enum lru_list lru;
-	int remaining = MAX_LRU_BATCH;
+	int remaining = MIN_LRU_BATCH;
 
 	for_each_evictable_lru(lru) {
 		int type = is_file_lru(lru);
@@ -5544,7 +5544,7 @@ static bool fill_evictable(struct lruvec *lruvec)
 static bool drain_evictable(struct lruvec *lruvec)
 {
 	int gen, type, zone;
-	int remaining = MAX_LRU_BATCH;
+	int remaining = MIN_LRU_BATCH;
 
 	for_each_gen_type_zone(gen, type, zone) {
 		struct list_head *head = &lruvec->lrugen.folios[gen][type][zone];
-- 
2.53.0


