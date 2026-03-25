Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81E64FEA83E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 11:51:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D86216B009D; Wed, 25 Mar 2026 07:50:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5D946B009F; Wed, 25 Mar 2026 07:50:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C73286B00A2; Wed, 25 Mar 2026 07:50:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B66456B009D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:50:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5F50B1A0873
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:50:59 +0000 (UTC)
X-FDA: 84584419038.21.71B00F2
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf11.hostedemail.com (Postfix) with ESMTP id DFF7C40008
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:50:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=QBdxSYn7;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774439457; a=rsa-sha256;
	cv=none;
	b=r5UulthWyaspuIncSWTkl4mbN3VhbZpiYJmAcpX+u++5xQ29z2m2YRlcEmv+y5bQUuZ3RE
	6M73OAUvvdpOGzC0KsYyrHZSEIR8eUuf2EoJzCPz7rtbu6oZ4o1nS4TheO1xvP8tA7YBTU
	fwg/DLFOa34zDqS3OyyH8XExufPd4fA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=QBdxSYn7;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf11.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774439457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fh2m+bR/6D39zNLTgYdahtwpo8phH0yzMEjKHobAvT8=;
	b=7PK1guPa77hqWUINJj9TLyT039D3fYMQDFNXwMijSTlYOMvraCsdROXqFXNl1VDE2oB2aX
	iQSPe8LIic2q4Z7dvVXIl7M2KNbVUtHKsIDHyOo/K/+lAbJnMFOsmcBjiZU3FcPFr681tv
	cC9VXNzZt5T4lLACDTaUx4s+568eBF0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774439450; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=fh2m+bR/6D39zNLTgYdahtwpo8phH0yzMEjKHobAvT8=;
	b=QBdxSYn7+hQB6Y/w8m3ojfRq9XrwD2ISsayDa7Vbw9BZNIbpaJcTaOBYJzWLTj/oaSeaH7AbmBAckdqpcHNfqeqxfx1yRbkSVrc/RLQIM6u5hi/4AbowQUAuMksXalJDn0hHFJ9/kMDOZVfJNwZPqn7d6cfotpfr0KMsWhwWIkY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R591e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0X.hZLU0_1774439448;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.hZLU0_1774439448 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 25 Mar 2026 19:50:49 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org
Cc: david@kernel.org,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baohua@kernel.org,
	kasong@tencent.com,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH] mm: vmscan: fix dirty folios throttling on cgroup v1 for MGLRU
Date: Wed, 25 Mar 2026 19:50:40 +0800
Message-ID: <bf40a20cd93b6c21f10db95657928fdae185e843.1774438978.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DFF7C40008
X-Stat-Signature: niqa6h7hjgu9dne37uph51g6wgh5tfui
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774439456-500453
X-HE-Meta: U2FsdGVkX18L0irMfCKhkF8df/I419Ay6+Ye/Btire56VW+fLVh/7hcGAZlIAVIgFeagbIcu0rJ99jQ2JCUAQPJzYRicAeQtHUFQRk+8Ar9osIJpAMuTSlKrkZuqbLrWqspJb1J5cts1cxJVPr0RtZS6XJC9qrauBqtdO4PvsZqcJNfSUHd28w9Cvj6kkmQ2xyY4SzQKGsaCSe6oKTbGNWQHiGHj/8ZoC8hQsnJwo0giQLYVbEIER3OzYgBoUsA1qE4nqhrGajURVvaYwxM8it51FcHAh9RZXw5BsCrPFSxEk5GKEXDqOs5+KxhIBNXoV4HAdtlSf+uYgCMKHmW79gm0vypEjaSi3qfJyXppkga0g8HUirxvPmPF7YRhXb6eNez8+42qKZ16V2adBGgp3vHOnUeXvgS37A/q3nVtJ5j214cUlX8+VKZsS3lUxSf4o5I2dCINrlKYkNwf62uGOEmsQ61eZH3jtODwZ8ikOZKTbEVcXB2z9cvsq0On83/uDR8Lmbg4jEnKrlscWxoMn8wKNoNBkOfXRDBkhaNnDpQDa+/O/J07d0PyAnHiJPDU8IVpkrZj9OWOMXnOemX6/GnTBFcpReouD9G+yJTtz0GzUyBqhUKAD64xzPMl2nrKYcsYpcUbeEOZj0/s9XjGD9M0ZFbEiIkg4YAVP4knIZ4DDhm13Y3eyVweWCn4QyFbowfr9kx/ULs94eLJFVeLte4qf7xZJSExEhbaM2bW92CJljOc1gqeqnbPgKsCusbq+tbZ1eF9K2LSv1Nwc23MzyhVr/A8nMOjEPcAPXQqy4iJG8s3QxoQ3K3/zCrcl4UufSbh4MaNKhBS3n0lB48Cpa91oMGokX3S/XiTQtY4uDF402oc9tql+eLk0nK2Awe/93Xe0aUYnCmMgMyOpLBw+zHMjgWmz95/6L/FPzYxNJ7/+6GnPiUN/6FFpE2ys/RVuIgE+RaxSpPS4K1+uP3
 tEUA39o7
 /nAJeQYYJn+3n2EpNlwaJkLF7DHULHwqRivBkSJGb9XCIP1MkP+WomwKOgnI2KD3GFuG1mTlmHJmXKZXyqTiR2NUBLTSwoBdXi1lwX415AFbFnGe19HvWkq71T24uI5DTm9sILvG2RBx1u2mXNQLxsqPnDhZS6EFPls1S/V0beq3ThT2I7agH1qX0U/BdMgl3czRCwzpLFbTsMNb8KqDQIzpVbxRkf6jBLaGZsk0wr8+zWk2mChX9498UxTjNdU1AEHQs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The balance_dirty_pages() won't do the dirty folios throttling on cgroupv1.
See commit 9badce000e2c ("cgroup, writeback: don't enable cgroup writeback
on traditional hierarchies").

Moreover, after commit 6b0dfabb3555 ("fs: Remove aops->writepage"), we no
longer attempt to write back filesystem folios through reclaim.

On large memory systems, the flusher may not be able to write back quickly
enough. Consequently, MGLRU will encounter many folios that are already
under writeback. Since we cannot reclaim these dirty folios, the system
may run out of memory and trigger the OOM killer.

Hence, for cgroup v1, let's throttle reclaim after waking up the flusher,
which is similar to commit 81a70c21d917 ("mm/cgroup/reclaim: fix dirty
pages throttling on cgroup v1"), to avoid unnecessary OOM.

The following test program can easily reproduce the OOM issue. With this patch
applied, the test passes successfully.

$mkdir /sys/fs/cgroup/memory/test
$echo 256M > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
$echo $$ > /sys/fs/cgroup/memory/test/cgroup.procs
$dd if=/dev/zero of=/mnt/data.bin bs=1M count=800

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/vmscan.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 33287ba4a500..a9648269fae8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5036,9 +5036,20 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 	 * If too many file cache in the coldest generation can't be evicted
 	 * due to being dirty, wake up the flusher.
 	 */
-	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken)
+	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken) {
+		struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+
 		wakeup_flusher_threads(WB_REASON_VMSCAN);
 
+		/*
+		 * For cgroupv1 dirty throttling is achieved by waking up
+		 * the kernel flusher here and later waiting on folios
+		 * which are in writeback to finish (see shrink_folio_list()).
+		 */
+		if (!writeback_throttling_sane(sc))
+			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
+	}
+
 	/* whether this lruvec should be rotated */
 	return nr_to_scan < 0;
 }
-- 
2.47.3


