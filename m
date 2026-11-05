Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 743E6606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 05:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cFNgwft/
Received: by kanga.kvack.org (Postfix)
	id 3C0E46B05B0; Thu,  5 Nov 2026 00:56:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3724E6B05B1; Thu,  5 Nov 2026 00:56:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 261E36B05B2; Thu,  5 Nov 2026 00:56:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E48236B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 00:56:44 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7274940960
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:56:44 +0000 (UTC)
X-FDA: 85400006328.30.E21D1C4
Received: from mail-dy2-f8.google.com (mail-dy2-f8.google.com [74.125.229.8])
	by imf25.hostedemail.com (Postfix) with ESMTP id BB29BA0006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:56:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="cFNgwft/";
	spf=pass (imf25.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793858202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dOC5LHS2AgqTFCevtv/eDNStKtT/WCl/fk0wy/PN8GY=;
	b=JIyGxgHTy62xWQB9LSRtUBa4ApT2QPvoYOQqTJ0uVh9hqC0f9RSqBQgwCTZAKNoZRqO1BW
	Gt3hFAtuUB7P6EU30kX8qt+cqxTCmoQzKvuOKH1TmcWPKT1awXgOuOkIGsFLhVdZ0aCTNS
	ZWGq4khqEShP8eunlDuESyjz4tcVFvs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793858202;
	b=1triekSWMTINQD9cUMpvM6kq+zYPXnhQosZjS7up8Iv1OA4+jfsFLx93LRXKmNksIfYxex
	kiKh78N5Q0zI8soxQhHxhvS6d35KogrIPdh7mAyOE/DV7+LQwQXlSRAvQH1CD3Or+g0wAb
	SQE+LHZfmbj8EmO2BKsNxG50k2RKPo0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="cFNgwft/";
	spf=pass (imf25.hostedemail.com: domain of dennylin0707@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=dennylin0707@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy2-f8.google.com with SMTP id 5a478bee46e88-36a1e794908so342337eec.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 21:56:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793858201; x=1794463001; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dOC5LHS2AgqTFCevtv/eDNStKtT/WCl/fk0wy/PN8GY=;
        b=cFNgwft/LYAg85xmiAr61e8/7SLv+tclcxUKyVJayeJc83oDAL0CS/Y+5VGuk58VCy
         pRo5LuoUmFu0r4T0nj/UaZknxbno8aDfNyMXuzYxMoWMb2HfO1JvM8KdTEeo8SNdVnZd
         +QJfVr/V6qDjKkkhYLzan1HkXIuzxOmIH46PUxhQijxy7diG7Z+uu2BbIKgKsiDuMFHb
         okPGN/bfZ6BmjK9zsFbf5FY411VfNVCWKz6KKmMp77CHjAMUeZZq1Gy9RWkG8KGY5PDs
         tiMs0yZhmSWorGetj+nKm8P5oWVzNcnLW86+X2uEme43oqxNpvEgs3dLmB/ChJ94S+2s
         3IPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793858201; x=1794463001;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dOC5LHS2AgqTFCevtv/eDNStKtT/WCl/fk0wy/PN8GY=;
        b=WbSJeXiOHvHs++9OqSfFDEGwWmn4bym4yhs+nbuFqQfFxfMKImKY0l7zIWpm10G8qP
         m86qp+wwWRSPrTHdMK+dbYwe0cJRTl7EgJGW2KVZsdgIzFPheDO93U/46DIshRQnGKTE
         F/CiYicH4X+fZr0w46fDUim/T53FSaa6GkLXc7dt8HAFvpp8IyRu++0lsawGNpAehDJq
         8p5lBnJz2f8t2rV2vC8qhkmRtluP32mO5Vc6ZRo24soFoFUQGFNrAwxhWTuLuNz5x+RC
         KUcCGmMYkv0xz0ncIbWGN1vNeMczOl12JzZCbOT75B+Hlt375uVOY9Lox5w/NjejmzT/
         NyeQ==
X-Forwarded-Encrypted: i=1; AKwUvBweeXQZxd4SgEvpoJw1b+B8xwgohlSWruL7hwoy8dXUwuV7w6bSXzsPs7+OGwPZ6TGYz/XTF4SkKQ==@kvack.org
X-Gm-Message-State: APuU4Z9cC1wl+ERV3mKxZ2WABuawYkSFuq/ffob9YfisVz/S9R2DSF+0
	DQke4DSD5ohmVA5hJy6kYhZXuhapSVJza3Pb89hQfRl4WcOvlbTLG+r3
X-Gm-Gg: AYBFou0pt3B0u8FqeDaIr5s60Nn8IgWNQvZRJjeuRmfGE5c8M1miMijWjvJNFSjrNMH
	OckZM3kwyqh0NWLT2xVDK+RZ4YLHMfEIhd9BC3bThr1z2qeNyHMFbXi23vFtUiWZwaQ5sJ/0+6q
	FqSulbYYrXxI+/DQH8/RhzY0Ew9yCequd9F5WpJ4C/OSu0rhjHBxyor+McCIXEX89Uj2ce1/JYF
	QQbiyx81kwxRcVU4l+v1xouLiJlHujmTBB+3qASYg1Smla3qgVlgmNLABiLbGTsQghQXUFDKQwn
	gCwzDGxKABOSIkLBxUzpRto/FTmKS9BAoke7vSETAH0NtgryIg4Sk2oyIlZ0OY5Rp7+JVo1e2Lc
	d0zFosWcSG7r2Efrjy/0zJwUfQpR3Sk7SiMscd2Ri9S5TTHGQfC0p8DwQFPe09V4t9iEQmWnU6u
	lslQyRvCEEw5lMZjuey/Oj6TrYVEZm8nFhnc/jxhua1Oh4JdNcIUgD/ssTY2OWKtBgYjeogYLv+
	1MEu2/9HMFmVszU2GEGFZeaBCbKQVhk1MxtBeOy+AOvgN6+mgLEz2ocM98X+2+zn9ApCRMHnNVM
	l7YXR7Sv/H1OGHXlEK5xHoI4oKU6pvsTeljHCscvzGv8JGCiLPjsRMy08342s63cBNeaEIBhBJi
	/qW6t1U0dp3Yksr0tYP1Pm6DbJA3Z7WYegq5hUA==
X-Received: by 2002:a05:7300:5626:b0:36d:3c0f:cc85 with SMTP id 5a478bee46e88-36d3c0fd4ddmr3962427eec.5.1793858201254;
        Wed, 04 Nov 2026 21:56:41 -0800 (PST)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca3784f78sm15780167eec.2.2026.11.04.21.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 21:56:40 -0800 (PST)
From: Hungyu Lin <dennylin0707@gmail.com>
To: hughd@google.com
Cc: david@kernel.org,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] shmem: skip empty unmap ranges when punching holes
Date: Thu,  5 Nov 2026 05:56:19 +0000
Message-ID: <20261105055619.58289-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4a9q9ohithcpsuequ3fn4tdxfd41a79p
X-Rspamd-Queue-Id: BB29BA0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793858202-738548
X-HE-Meta: U2FsdGVkX1/wpRfoOM2gnhSCuM04AADA2BgixsZ1TbsN8vGhsSLkQuQg6sEDDTBG45q9gLnY/8SqnipnA7a95S7svdj2hGe/8c/Lb4clRubYfBi+LKir9V2Bpgtx+Piz/8K1XtAKQbr+3F0z9Glj4s2K2H8uvemge5rg9yP9xxo/XqnWCBxD3LI7CXU21qvdcALypQboVQCwZccSKuF5XUz2NNeI5FhyqwGSvDMOtUPhvOQbVkcXravynO2kPKAjfGtFQCCWuV8/i5u2VBKPaO6txzvKBSCiim9+RIJZWxXlGV+ldTYlXkkuIj7k7pPh7dMHORUdNK94TKd/s5uLPxreoGM9zkBQTtfMtUA8A32WLtpk1hWfhJ+q5QxeWZKEEPuwcXzssWFCrazcYQ3cJJbsIpEoX50drsVJRjrem24UoOY76xI4I/EXyyRnNOXvirxTk1Zgktr96mtbCW4A+h7pmnG2aaf7JVElsv1Q2WMA/MKisDDuCTFvDkDZ3LfOEdfYI7qMrdZn7ztFOzfMpDRk+c17sVYvrC6uHzlM7h21Pgio5tUPMSHOMebCThLzt3QQIAbbTz8KqNpWKaAjxKYcszsfa+ihwXjyBQcy5ifsSAmmkKqn9kYvMU5OegNRe3n2nIfjqUkqFasNPpgATk3XKQ4djjHeut2pwRP0cM38fTRb2suSwbmw9lPHncmnXrQSKmpi2pIRkUrzbawX18jPov7NUXlC/fH9hDlkUbvEVKy3Kv4QUYdNTCmewfc7QLPz5WEJ6xrShemgt5dIbsTUvUEOz7Kvm3x+VdEnEc49uSWuIO367sg5Lt6CjIiWyxsZ6OYOWNyIM30y6LJ94NcKKH01NktcVgxD+77UfVYPI7ckqc7BfOqTwLPwGYtwOg7dCv0MPDIiGcMuLk8BHmW+U5T097bHtPhAVXfZlJwCM2B9IveYYeqBnEH07cIDzYti9fbm6uODKUe+NHz
 5o5bkyI4
 l57fYBVdXvbLz5swIW8fR5SE3EuZBAtHwqUHzaLl+3NjCn+oZ4knd+0SHMNYuG8rJD4oGvFXlxNWmJPRu4seWWByMaK0+YrF7k4Qvpv00iIou5Y8Ogu0FF0P9DKKNc6X1H5IB+KzYrT5u0scEHaKHgn0YuH8dRwC9o43iZ4hBxSZEyZg+O2ZQID1UcmdHNzWiDxHeBwcJkiGrCaz/O0oCFh5YcV7ZO6V5cr1pQxx/EHd2uUUerfi6KFHXoi2uaqzjHACcvu8cCvF21ED/epYorcrHMF7wdZvy2wHk+3spotprxuopxvDKbDjBm/E5hEl9hCx6QaSEZQUt68soxdIwj/rHP1adhAN/VrUn3kCnaRCw8nSO4TkWPhJQrdaGQkcc+ughro+TETXZk3GafJzmdPGTSXKvDtJd/whV8JayqPcVjhW5x/w+p/JEDfbmq8H7FFbzfzxuWjS9mYI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When a hole ends before the first page boundary, shmem_fallocate()
calculates unmap_end as -1. Casting it to u64 makes the range check
succeed even though the hole contains no complete pages.

For example, punching one byte at offset zero calls unmap_mapping_range()
with a zero length, which means unmap to the end of the file. The file
contents are preserved outside the hole, but unrelated mappings are
removed and must fault back in. This can be reproduced with fallocate -p
-o 0 -l 1 on a mapped tmpfs file.

Keep unmap_end as the exclusive rounded end instead of subtracting one,
and adjust shmem_falloc.next and the unmap length accordingly. A hole
ending before the first page boundary then has an end of zero, so the
unsigned range check skips the empty range. Retain the unsigned
comparison so rounding the start near the maximum file offset continues
to be handled correctly.

Fixes: 83e4fa9c16e4 ("tmpfs: support fallocate FALLOC_FL_PUNCH_HOLE")
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
Changes in v2:
- Use an exclusive unmap_end throughout, following David's suggestion.
- Add Baolin's Reviewed-by.

v1: https://lore.kernel.org/linux-mm/20261027171753.1485-1-dennylin0707@gmail.com/

 mm/shmem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index af21a89abb0f..ce92e74baeb7 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3845,7 +3845,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		struct address_space *mapping = file->f_mapping;
 		loff_t unmap_start = round_up(offset, PAGE_SIZE);
-		loff_t unmap_end = round_down(offset + len, PAGE_SIZE) - 1;
+		loff_t unmap_end = round_down(offset + len, PAGE_SIZE);
 		DECLARE_WAIT_QUEUE_HEAD_ONSTACK(shmem_falloc_waitq);
 
 		/* protected by i_rwsem */
@@ -3856,14 +3856,14 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 
 		shmem_falloc.waitq = &shmem_falloc_waitq;
 		shmem_falloc.start = (u64)unmap_start >> PAGE_SHIFT;
-		shmem_falloc.next = (unmap_end + 1) >> PAGE_SHIFT;
+		shmem_falloc.next = unmap_end >> PAGE_SHIFT;
 		spin_lock(&inode->i_lock);
 		WRITE_ONCE(inode->i_private, &shmem_falloc);
 		spin_unlock(&inode->i_lock);
 
 		if ((u64)unmap_end > (u64)unmap_start)
 			unmap_mapping_range(mapping, unmap_start,
-					    1 + unmap_end - unmap_start, 0);
+					    unmap_end - unmap_start, 0);
 		shmem_truncate_range(inode, offset, offset + len - 1);
 		/* No need to unmap again: hole-punching leaves COWed pages */
 

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.43.0


