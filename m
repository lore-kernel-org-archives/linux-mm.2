Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99A76CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 03:43:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09DA06B00A0; Sun,  7 Jun 2026 23:43:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04EAE6B00A1; Sun,  7 Jun 2026 23:43:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECDB46B00A2; Sun,  7 Jun 2026 23:43:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC7B96B00A0
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 23:43:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A06ABA0948
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:43:26 +0000 (UTC)
X-FDA: 84855350412.07.A58C3EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 03A13180005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:43:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ilSao1YB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of yukuai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yukuai@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780890205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+GGMH6tty5FLIeZM+POYH+qzK23yhtXmMhvkWYu3LDU=;
	b=Xbr6bAtQbo5+CpU8gIDyrO7D3+0XlBBgWIGRoI+ysCqejAl9yJU5c4X4ZNj8VAshs8BAYT
	Bo9PtRFzb7pCq4QlJvdPHJ09pt41kGns5eO5jFMJAc/0xcNWiUDzDwfTCG/O5Vv1XbeojW
	w7eDahU/NXcp5V01AeTniNRT/5+QnaU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ilSao1YB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of yukuai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yukuai@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780890205;
	b=v3qnHYTkWg/KiBfZ2mf0IlTCLSiaWlSanBrBUKXUwwRKjAfYr08sISJoJq3FrTl4PZtb0W
	snTzRVZMn5gvMyzT+pVh5bQZfRJ+OvCe8lZDpbXSuhJA/ndf/o+XsdRGIa76Htt1xvxvXD
	1mazhuAqIebxMrRnt5sRA299W8KJ/2w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 46CC440476;
	Mon,  8 Jun 2026 03:43:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7AD1F00898;
	Mon,  8 Jun 2026 03:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780890204;
	bh=+GGMH6tty5FLIeZM+POYH+qzK23yhtXmMhvkWYu3LDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ilSao1YBHviA+H3l+VdOSbhmDAN2xxeZYpIZV8xr1Au1go4gQR5Sq1gFk3or2Kl50
	 OZo0qnAylTCra8E+swhFiOTCCUFdE8lM65WpM+WgUQY1EhOaM06vWeO9pba77JZNDT
	 DIlz3gA0WQ0GLOGJikvft+Zabgn6VyTpM/YKeUIjPAfZ/Y6nO8tg5fohWyo31TsNLY
	 RNXjrjqyZQBb44UdFOXRs0c+apDVKdaofrG2SNg/WC25YtAdf28oU2sxaozXJNTvHC
	 hIVXG2PJPG18e62kckP0o3G1O4XiRB06o0XZQk0lxeiIYNm/XfvpXl5KKMs8Qpi4Xq
	 klZxVCVqWnqSg==
From: Yu Kuai <yukuai@kernel.org>
To: nilay@linux.ibm.com,
	tom.leiming@gmail.com,
	bvanassche@acm.org,
	tj@kernel.org,
	josef@toxicpanda.com,
	axboe@kernel.dk,
	yukuai@fygo.io
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6/8] blk-cgroup: don't nest queue_lock under blkcg->lock in blkcg_destroy_blkgs()
Date: Mon,  8 Jun 2026 11:42:47 +0800
Message-ID: <00b03cf74a9937cb4d6dd67a189ddc00a3de0451.1780621988.git.yukuai@fygo.io>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1780621988.git.yukuai@fygo.io>
References: <cover.1780621988.git.yukuai@fygo.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 03A13180005
X-Rspam-User: 
X-Stat-Signature: mnumd91eq8mpakjakfb64d1wan1bwz3b
X-Rspamd-Server: rspam09
X-HE-Tag: 1780890204-481069
X-HE-Meta: U2FsdGVkX18wdojClKWyJ08XEjlYxKH9tC57lfNftAuofXQKCp66auMqa5xTORGMeciSmisjtSJEO7sg9S87FFOyOYNlvG8v5Tp/O/NyaMsO/tC5BxwqqzqBosCfFva61YMBSBFR6qlL6hRwvc3HBigdB/vVVr2EDQHnDlp066DfHhVM626fN7nHuRMjTuT7e1ER9zMn1IFw9JsRBvGjv4PXS52g7plUfYq15JZrH+2DK4sy2mq6uecnI1sLSrtrmBUazQGsc1WdSxTNhTMkLjOJH1bX9AK9tw8R5wDkOXXaH3/5eLQB3JprpKJzlO/z5e6EY5dFSM4tXv10MyCq/YezcIifqylNY+OIQujCwmOOeu0H8atzgsQfl+/HLbaGorKVSkQ9cmdoAR50KuSJxLZDIZpv7h91DHq3ICOLVFP+Gnz4x7QkRyo3KVVY5snKyHFn+a6/4cqwDmpu48HDPeLgMFojplsYha0YnFBGM3yeF+5WXKJKmn7iS1nQsFseOdqQuSy7dre+MgXZXaqbsnosCLAkBAlMilq9p91TRQ/olMomv9MTdNQyG3SrOwGWlY/q+QGESyL1Or7IPxCDEY3gMwr905cX1dUL3hYzckAPvmoN4iHeV/Xc26DtFrMcmsoJNsegp5c/uyZz8s5eyEi4P5K4MObPcdXzTTqyNE1UPXN0wdowuGzgAR1OhrCdRXO7u/8Y3xzHNV3A1Sy85Qxipb597UDJ6ocE4GtfhkSP28Ybs0nvBBWwmTle7QW2/KYM1acPJfvlOrfixBG9UhCz2xFsRWhLquA29d4O8MAepGlIixOEWd7jcGDXVhfwNxqtTJ+wncpvrhLaQgQPAvEihAmoCRTQAmIWNszSEmeFYSw04VXDk7AY0MPXQ6TmUjZKf3pBd+c7BGuauYHlcvH+HolbTYO52yEcjAsfQRqE/9eQqwOdu1It8jxfkVJq7GOtDBOPvpho9L7xHD4
 yd2D/J7C
 t4WvtQt5nsP/bvMBPGMkaRH/Nn2KU+yvb4wW4yJv4N/xzO/HTtowm62NmHwVzXGwQRDJSnI9SM48q+lEpzMSzcqRC3DnajOenn0TlqVNPnfRMgDZsxB9umPFTKLTwFRoLlsZ71W7G0NI8TwWMM0Gd5sTXRyPNMfRFbJhkk4UOMelYVc5hcgpLkZVqs5uMaQMqiePs9LGboLiQWBlSznDSs9cGjx4d62sqMu7h49/pvJJynIOIqISBTWSFghGerZrPyI1wdsM+/8umzzFKybZ8dro7gNBeJfLitBTF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu Kuai <yukuai@fygo.io>

The correct lock order is q->queue_lock before blkcg->lock, and in order
to prevent deadlock from blkcg_destroy_blkgs(), trylock is used for
q->queue_lock while blkcg->lock is already held, this is hacky.

Refactor blkcg_destroy_blkgs() to hold blkcg->lock only long enough to
get the first blkg and then release it. Then take q->queue_lock and
blkcg->lock in the correct order to destroy the blkg. This is a very cold
path, so the extra lock/unlock cycles are acceptable.

Also prepare to convert protecting blkcg with blkcg_mutex instead of
queue_lock.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-cgroup.c | 45 ++++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 8c9ca52a54f4..d1f69a23c9d6 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1289,10 +1289,25 @@ struct list_head *blkcg_get_cgwb_list(struct cgroup_subsys_state *css)
  *
  * 3. Once the blkcg ref count goes to zero, blkcg_css_free() is called.
  *    This finally frees the blkcg.
  */
 
+static struct blkcg_gq *blkcg_get_first_blkg(struct blkcg *blkcg)
+{
+	struct blkcg_gq *blkg = NULL;
+
+	spin_lock_irq(&blkcg->lock);
+	if (!hlist_empty(&blkcg->blkg_list)) {
+		blkg = hlist_entry(blkcg->blkg_list.first, struct blkcg_gq,
+				   blkcg_node);
+		blkg_get(blkg);
+	}
+	spin_unlock_irq(&blkcg->lock);
+
+	return blkg;
+}
+
 /**
  * blkcg_destroy_blkgs - responsible for shooting down blkgs
  * @blkcg: blkcg of interest
  *
  * blkgs should be removed while holding both q and blkcg locks.  As blkcg lock
@@ -1302,36 +1317,28 @@ struct list_head *blkcg_get_cgwb_list(struct cgroup_subsys_state *css)
  *
  * This is the blkcg counterpart of ioc_release_fn().
  */
 static void blkcg_destroy_blkgs(struct blkcg *blkcg)
 {
-	might_sleep();
+	struct blkcg_gq *blkg;
 
-	spin_lock_irq(&blkcg->lock);
+	might_sleep();
 
-	while (!hlist_empty(&blkcg->blkg_list)) {
-		struct blkcg_gq *blkg = hlist_entry(blkcg->blkg_list.first,
-						struct blkcg_gq, blkcg_node);
+	while ((blkg = blkcg_get_first_blkg(blkcg))) {
 		struct request_queue *q = blkg->q;
 
-		if (need_resched() || !spin_trylock(&q->queue_lock)) {
-			/*
-			 * Given that the system can accumulate a huge number
-			 * of blkgs in pathological cases, check to see if we
-			 * need to rescheduling to avoid softlockup.
-			 */
-			spin_unlock_irq(&blkcg->lock);
-			cond_resched();
-			spin_lock_irq(&blkcg->lock);
-			continue;
-		}
+		spin_lock_irq(&q->queue_lock);
+		spin_lock(&blkcg->lock);
 
 		blkg_destroy(blkg);
-		spin_unlock(&q->queue_lock);
-	}
 
-	spin_unlock_irq(&blkcg->lock);
+		spin_unlock(&blkcg->lock);
+		spin_unlock_irq(&q->queue_lock);
+
+		blkg_put(blkg);
+		cond_resched();
+	}
 }
 
 /**
  * blkcg_pin_online - pin online state
  * @blkcg_css: blkcg of interest
-- 
2.51.0

