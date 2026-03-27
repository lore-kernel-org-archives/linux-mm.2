Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 703B810ED656
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 10:21:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD9886B0096; Fri, 27 Mar 2026 06:21:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8A496B009D; Fri, 27 Mar 2026 06:21:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC7806B009E; Fri, 27 Mar 2026 06:21:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BAAEF6B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 06:21:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7577AC3ADF
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:21:26 +0000 (UTC)
X-FDA: 84591450972.30.6C83EE3
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7B22520003
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:21:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Cqyab5jH;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774606883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xmgOZAwp4EbDVXy8Q0wvm1dBxaFD04bCGkZNNWdOHBA=;
	b=nzWaH63Po8YCnCOqQoieT4/VZrbYBw+X0G5N5hFVZdEm76TdDqBSiAzV61bvxildC+kxGI
	U9d/k8PgRraVp2bHAL8XY8jroZz9ACN3JjwPJIXos3PIQQ9aklsI+rbbBpGs+nCTvcan9q
	D0GwaPFEukEwiyzzsczVS/5tO43otnY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774606884; a=rsa-sha256;
	cv=none;
	b=PIR+48hQHBo6uJNOQCFU5Yj0OGNG9j9vSs0+EfbmcYrXAVI7qJwYpfvvbOYloOJLEzF51t
	w2tXP1NmeCG81IxsA6O76VsC5f+cn+cZbKKapqdyZJADWMWB09zghAkB4sUipZYwjFlsGw
	zGT39wnYR9WlZbxScH5SbnEdnnRsjh4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Cqyab5jH;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774606880; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=xmgOZAwp4EbDVXy8Q0wvm1dBxaFD04bCGkZNNWdOHBA=;
	b=Cqyab5jHF4yunYZRBHgQiBFeglcj6NdmnpYcF/Jb5GWnaNyJ4pFAfZ4r1Ppnany8NCP4O81UpJ8o3oaIeY1v3H5aLilrNZmFrRE+ztvDosqVAqvoN71LuAYxhV0qlV2j4FyYeOENTmcaPZvGIbVw24w8/2l7+SBmbRgaCwC4dFI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R991e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X.nz5ds_1774606878;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.nz5ds_1774606878 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 27 Mar 2026 18:21:19 +0800
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
	ljs@kernel.org,
	baohua@kernel.org,
	kasong@tencent.com,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: vmscan: fix dirty folios throttling on cgroup v1 for MGLRU
Date: Fri, 27 Mar 2026 18:21:08 +0800
Message-ID: <3445af0f09e8ca945492e052e82594f8c4f2e2f6.1774606060.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7B22520003
X-Stat-Signature: pmw6p7jpuzrmxnfiter8yx9rexop1p3x
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774606883-78268
X-HE-Meta: U2FsdGVkX18jZ3XnZqkuWP01bqWsemDz+KsjsOfNaV8iZmAxR5aKl8rT++3oyGAPyWvxurVY3Wo/dNDox2aL5BiXTT2W5AynGu7ZxBETCz4HzFeLTh+UjUdez9rGOk2MLoGnTTtXDbdSn9sWtzMXEq5PuXjOMtDAo5JNsfehKMrehfY6BWZccW30HKN0+9YbPMdJoCcheBu4UdDRIZ1OhtIaMH5MVIcRNxj7RraPGVS6VR5Dr9AZr2oER/oZrAi2+w8aIQXgRGnwujfQ+zkdFsAa0tseza4HHeUm5bvzFFa+YDmCZO3bfY0XJiBDA4aXkN3wDkjo0Is+ek4GAaNDtqQxYX8cR7x9VdouSojKUtaTBBBcvlrMddiu3rb0VOzIzWevm8iinIT+vRfzXjCxgjOTeFOwsimTKj27WuW4vf/kQaS+SSeTDn3rEP+QTVnkchheGd8P3emnrxBQQlg0e3MU3AtZuIw7PC4yW45jFhRYQcMivmBYHvqF26f7gmXpN8kckBletfDUqlBegkagcqqTJODnNhjzWt2KduIfjoqJs7DUZ3FqYval3niLa+sMK8XF/y73JvXwyLMudmPAcRxjLGDMIJ4JHbQysvio4kg5uNu9pCzHCmHVlmgS0uowhuAlm5u/Wq/tn9b8rlle9Vw2EjrUTcoVDj5ga5/EYP/ZV5w+ex176lNsxFVyHDB/nDXEmO6KlhNE0WZKmUd/FPGzDOFqo+7T+4QnZAQnbjG3ek1d0aD0iL/xF1qu15i6cOad8RgrAj5ZgAf1Q+5BvL074iFmQe/Woe6Sd+rmw5MvVF7DflqZGl7rkGDgJZJBQppxaIxj7P0sMdoIHkEgsr7YOgStlZYtmLZjYNPCNtCIEtGR6RJfV1vT7njQr6c/GeADSmyrOtlmNzQurTRj/cJKW7m80YWabNcYeMfpnxjqdmRlDOgmtFAXpN2gqnh4AryjYudfLb7/vLoEbCF
 WgzjI7aP
 43N/VSFkWhEKAdogKNlo49yqwFdmRmId64OoDXk0Fat+SJFuCQmXpJqjIG3WK5jgVIA9xCsB9mfHpl/YBPQJ+yeoTWkjtWKytb2Rg6NLGYdoJePZvF6iq/AEjOMPWMgANBjIz+w5EqgMjWeBCl6/B4+hbMtKyRt1sQ38oEhQfiM/1aNdVhpe2lSXdH53VamHl8u6sb5Gxst8fxq6htBcLgMq4Wx46ATdeQlfed6J2o+ehrSSOyuIUf1lg2Cq7hZZaMca19SUnzslDYeVnoC7V+k+2rPGqJQ3UZ52sfFM+sCT5yoU=
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

Fixes: ac35a4902374 ("mm: multi-gen LRU: minimal implementation")
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
Changes from RFC:
 - Add the Fixes tag.
 - Add reviewed tag from Barry and Kairui. Thanks.
---
 mm/vmscan.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 46657d2cef42..b5fdad1444af 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5036,9 +5036,24 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
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
+		 *
+		 * Flusher may not be able to issue writeback quickly
+		 * enough for cgroupv1 writeback throttling to work
+		 * on a large system.
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


