Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92760606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 07:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=FoP+S/Zu
Received: by kanga.kvack.org (Postfix)
	id 502136B05B1; Sat, 28 Nov 2026 02:27:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D8E56B05B2; Sat, 28 Nov 2026 02:27:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A08C6B05B3; Sat, 28 Nov 2026 02:27:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C0986B05B1
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 02:27:31 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BF320A818C
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 07:27:30 +0000 (UTC)
X-FDA: 85483697460.19.B4E02C8
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf11.hostedemail.com (Postfix) with ESMTP id 557AB40006
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 07:27:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="FoP+S/Zu";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf11.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=longwei27@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795850849;
	b=hfh6kD2bN26Sh2w0minIylQGwAtvSAGs1wtCSzFl/e4lJAz21jRfEQGYr2mkgmk4odyW35
	unDnHlN3yf23znEUfUusP2tr6Zy2kq7qig2KdK1DPzm1RCAm8i6gw5cqu1KUktczoMrvK/
	gY7gR8IEHL6xyAfYHLTrJKcNkZLMv9U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795850849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S2+GAWJu093KmsSX+p7Xa5DYqGY04zbqmyhRiBRhNQA=;
	b=J50tVtK6dNG7aR8gDJ9MKAUoGF2aIbBPn9xr7gqdbw7FsxOi7erOz9du3BLAfd/QZl7M7r
	LNkmG0pVa5CJ8QzbWdq6De72X5Cr2iIvs60wjbbf6rT5F8jjgWrTwLlOO5MPWdLzc0ZbNs
	XjILFrVtdRWIJ4WIwLazs9YAGY8bE34=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="FoP+S/Zu";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf11.hostedemail.com: domain of longwei27@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=longwei27@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=S2+GAWJu093KmsSX+p7Xa5DYqGY04zbqmyhRiBRhNQA=;
	b=FoP+S/ZuUgZhkugJDKfGpPKJdLiOb7/sLhugz8VzW0r5yZvf1zD2eUrmRcL1Ggxbu1nf5oSNo
	oN+tNaSB5x1PKoeODmysqEG3iDjqciVhzCGBPrGyusX/zt47k4k4N53kn/6G6ymsH00DcYKpOxs
	EIUqKWzwMUGNTecHH4ZlqLc=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4jc20C06Vqz12LFT;
	Sat, 28 Nov 2026 15:26:35 +0800 (CST)
Received: from kwepemo200009.china.huawei.com (unknown [7.202.195.26])
	by mail.maildlp.com (Postfix) with ESMTPS id 7A2C64057D;
	Sat, 28 Nov 2026 15:27:21 +0800 (CST)
Received: from localhost.localdomain (10.50.159.234) by
 kwepemo200009.china.huawei.com (7.202.195.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sat, 28 Nov 2026 15:27:20 +0800
From: Long Wei <longwei27@huawei.com>
To: <rppt@kernel.org>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>
CC: <shuah@kernel.org>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<kexec@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <hewenliang4@huawei.com>, Long Wei
	<longwei27@huawei.com>
Subject: [PATCH 1/2] mm: memfd_luo: pick up seals added after preserve at freeze
Date: Sat, 28 Nov 2026 15:24:43 +0800
Message-ID: <20261128072444.1114964-2-longwei27@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261128072444.1114964-1-longwei27@huawei.com>
References: <20261128072444.1114964-1-longwei27@huawei.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemo200009.china.huawei.com (7.202.195.26)
X-Stat-Signature: zujb6n4ygtew7ig4d7z31f1cizbwsqh4
X-Rspamd-Queue-Id: 557AB40006
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795850847-206171
X-HE-Meta: U2FsdGVkX1/TuZJh+kiki2Kx7jMbF+q1M01fubYBkPZddF5yZAdsQoFx5NCydPwlilChPzQBZCqcWQHtLDgJJ4pgrA7Prd0pwdkoqErXP/0tdJV9xZd2hURBvgddPKV8h6II4szl9z8ZTAbNBojYr4eCb+CeNBmymFqOfl+I0vWTK7DaAMIHXGELoYvrhNpC85sgF62rZi72EVx9tQs8MjtiYFM+SgOunUZ6pW2fJW/qyvF611wjAPgXu0+ClPCTmwy/K580cppmiIcnMsuHNM4GHQtUo2AZC9qrqmLsOWw1rL5y+VqzJ3CSMvyOGzkYkkDQdOJkNpnzotEwY166buV2G7MeCNL1J7tgDkAOKkSThBTJOZ4AY4jA+N7fRAbjs9G0uIBvahvbON0zzWXZ8hokgV+4aANk55sQWBSOTeDqHdOOm8Ufau5Y9Woxs3HheUcrZOPZRwRuaBq/vHhnj09t9hGZ8H14eYYqmPDIdIoYmc3afoNYBelWfFs7c39OlJRjDplRDPmnXlGUWho0ALdY1iXJm08qcsDrgpO8DTt1VztCqpG661DJ6p3K50SCinyAmnMGHYTUclyosPtD+UwOGCQNlZM++TkC993ctV5jO44FxqVdg1sbcX+FKzqrkKluEaul6WGKPmA5gKFwLgXVsrcKcE4k7MD5Y18+ONzHsbtJsUmTDxYqID7fYCmOWEAj33MeNwmVLifpPfaEZbasSKkiFn/lE7IuxlLiUkWO7epfZMAZf0pBmpHypc4wgef2hBUew2Ki5/UaPRpQ9/A1THG/7Ky4i6Elmo8zkQ93sPMt8277FsyQhpoTW8oAKlsq9WULwJ5Tg0KsNekaTdWRvYcX57gxwRhSVErlBiF+AszSNny2QEKxtWJhWOfbwf1Ygpp1NmGnhRl/1rae6tXHTKxOZHSJ/2977z3Z8cklpYst2KK5XnTKQ/rd8HBFAAispsy9qCvQYd94RgD
 E2cUAZaP
 pCbFlpAwQqlmRNisHxfOWZU+5iFjZSXFLx4qg+hYLpcbIcSZZVm3BW0kIQhVpzjsQGqV5c6VQNZ89Fz0vxfWjv2dVpYI152o9vsJhb6PPWeekyzQIeFzgEB2YV2pzRT5vtj1f+qKeGtCsmPAIgjRwEWefmoaXrhPf+akSXn5t9KK3HtfFVTCTOPbTcdba9A93eUipmDPpaoj9qx9Nk2k0omXW+Hi9I8sFOdAfbRVea5ONxSbwv3lfSa3+PqKCyIetnkvu8sdyoSGK/567ZCCVdqfDMcCi0u/oZQmddhP4cXQkUKNsBCFtolLzzMaMOwINKxbDfGMChlWdFr87WlyMgATfmuDz3rGrAbMCf1qaL0xIa+NAgw0yEZbrohziJ5k4DNjGUBXK0n3yZjFkCCb1c+g2aQGwCC7AnxugwHoUS3Ik1W+Nyz38PRpBzDcLy/aIAnfGspgDu1huTcTuGKGuNuKl3e6yq1Ebu0BYtcYTTS16uyc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A seal added to a memfd after the memfd was preserved with a
liveupdate session is accepted without any error, but once the kexec
handover is over the retrieved memfd no longer has it: the change
silently disappears instead of being rejected.

memfd_luo_preserve() snapshots the file seals into the serialized
state, but userspace may keep operating on the memfd until the
handover, by design, so the preserve-time snapshot is naturally
incomplete: a seal can be added at any point in the window between
preserve() and kexec.  memfd_luo_freeze() only re-read the file
position and retrieve() replays the frozen snapshot, so those window
changes were never picked up.  Freeze is the last point before kexec
where they can still be sampled; there is no second chance after it.

Re-read the seals at freeze time, mirroring the file position
handling: freeze is the final snapshot point and changes made after
it are not preserved.  The new seal set is only revalidated when it
actually diverged from the preserve-time snapshot, and the validation
must fail here rather than at retrieve(): while the old kernel is
still in control the live update can still be aborted, but after the
handover a seal that memfd_luo_retrieve() cannot replay would already
be past the point of no return.

Fixes: 8a552d68a86e ("mm: memfd_luo: preserve file seals")
Signed-off-by: Long Wei <longwei27@huawei.com>
---
 mm/memfd_luo.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 6b68220275eb..08524125475e 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -54,6 +54,9 @@
  *   File seals set on the memfd are preserved and re-applied on restore.
  *   Only seals known to this LUO version (see ``MEMFD_LUO_ALL_SEALS``) may
  *   be present; preservation fails with ``-EOPNOTSUPP`` otherwise.
+ *   Seals added after preserve are picked up when the file is frozen for
+ *   kexec. Freeze is the final snapshot point: like the file position,
+ *   changes made after it are not preserved.
  *
  * Restrictions
  * ============
@@ -322,7 +325,9 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 
 static int memfd_luo_freeze(struct liveupdate_file_op_args *args)
 {
+	struct inode *inode = file_inode(args->file);
 	struct memfd_luo_ser *ser;
+	int seals;
 
 	if (WARN_ON_ONCE(!args->serialized_data))
 		return -EINVAL;
@@ -330,10 +335,28 @@ static int memfd_luo_freeze(struct liveupdate_file_op_args *args)
 	ser = phys_to_virt(args->serialized_data);
 
 	/*
-	 * The pos might have changed since prepare. Everything else stays the
-	 * same.
+	 * F_ADD_SEALS takes inode_lock, so sample the seals under the same
+	 * lock to get a consistent final value.  f_pos is sampled here under
+	 * the same inode_lock as preserve did; freeze is the last snapshot
+	 * point for both.
 	 */
+	inode_lock(inode);
+	seals = memfd_get_seals(args->file);
+	if (seals < 0) {
+		inode_unlock(inode);
+		return seals;
+	}
+
+	if (seals != ser->seals) {
+		if (seals & ~MEMFD_LUO_ALL_SEALS) {
+			inode_unlock(inode);
+			return -EOPNOTSUPP;
+		}
+		ser->seals = seals;
+	}
+
 	ser->pos = args->file->f_pos;
+	inode_unlock(inode);
 
 	return 0;
 }
-- 
2.43.0


