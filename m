Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B014FC43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 18:11:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D00066B00B8; Sat,  4 Jul 2026 14:11:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE89E6B00B9; Sat,  4 Jul 2026 14:11:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB0746B00BA; Sat,  4 Jul 2026 14:11:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7CAD26B00B8
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 14:11:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E00C4168D4C
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:11:47 +0000 (UTC)
X-FDA: 84951887454.25.7FE84D5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4F19410000A
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:11:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=duHAJKZl;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783188706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TjebM2OgtNiNXvN1yKT2/Mbtr9u3LW+BP8Dj45hR6WY=;
	b=u3eOe2pAJqx9g7IVhkEvgjN9M1jicXsht+m8mpd9v7ifAkuvk2dhgW3OBn8MMQiyDylU16
	tjErbObLWXCnum2uxOSQvB1CBcZDku2Pi5LGdryC6ZdCexl7AD9XapZuyeWZ/dmGwndQQo
	/K8qYPtgFLovEe45gPWBz9O/euB9eMI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783188706;
	b=oX+MHFJr5+N+MPWWU12PdyXaGxFQslFERFF4trRbw7mApti/E8UM473XiLDvzc4Vjnkztc
	7pbOIa2WM+aDkpqBlyjre3B3/lFkG82X6aDLvDEZnXa2xquPz/WBuohhO7Zgmz3Q1nIgoB
	vXOzNN2cvbvf8V2s4scsdu36+TjJbj4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=duHAJKZl;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DBEA86136C;
	Sat,  4 Jul 2026 18:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A641F00A3A;
	Sat,  4 Jul 2026 18:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783188705;
	bh=TjebM2OgtNiNXvN1yKT2/Mbtr9u3LW+BP8Dj45hR6WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=duHAJKZlRh8gkpSHxn0maVrPXBXWSPe79zTVdhM7vaWgBlJD9LagcfE4p9BIz4lRj
	 KH0QOm4JOlbtBSUrsIvGIF6ItBYdoFgJ4ynnzpwFPkMlvv/Hte9FpY7/YILYIh6Yo/
	 S5zLPjKOIeghHHIUcgKQlWDXUqHiFMZctYls4xdc/1JX6CNdiJ0lF0Zdg4FPAA5hnr
	 4SJ0Mtu6nDovF8gADoKe5OXTirSL6oF92PRXqRsYEKRac1BkvEOyehBLPyomZAaN3U
	 lmMbcPPQnjYu/BIAkaUvEfF3IfEsD/594oCc0U+ZQdV4Hg0VXZrE6ZO2snpkPr+zo+
	 EBilMIBxxosNQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 03/11] mm/damon/core: make damon_stop() never fails
Date: Sat,  4 Jul 2026 11:11:26 -0700
Message-ID: <20260704181135.132956-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260704181135.132956-1-sj@kernel.org>
References: <20260704181135.132956-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4F19410000A
X-Stat-Signature: 365ysxo6n4gn956fq484cdiaatk6b6c7
X-HE-Tag: 1783188706-112304
X-HE-Meta: U2FsdGVkX1/t4UAxiJuMVyMS1zVwe/doX9mHRO3+7pZJx7TxQU4QrtdxCvMf1xDUK21aVG4w7JeqZGP2/kiT88oA4+ZXnK9bGhiAQgMoDsXRzf4FRYy5GicTrxAHXIC4+KoXaeB0Y37USNrbl0t4yqIYgAIjtZMszWJb/hN9lRZ7CAM/OGqIoY8JhfUElW/QKP9CBs6g5BMXibqQX2QnZudidJw6AmhYlLsgznJsPDEbjWI+D4sDUn/aFzOTbh5GlPL+DD/ZfQmPwdPTcrKH87c73YGO2RkehCSA1StbfRZ1/Y+xfrg3xZHhEp7l4hF3Zx0MTb1vBMx2qiQcUKnqi3pXuzg/tKKMvIDARwIwjMuMua8eiV15MUFI4XeiCY3GHs7ff4CI86IThtpMIl0NOhvVc5FfDmGSB8OQNO9sWHthasxSnCzflRB3JG5AGVzZKR/4VKW0k3oToiWThS/Pm3Mu3B8eHs6Bno9PMv2tgcBg2fSjRQqAN+kuwXH0W4Zfx6wjndTsACAazybaDtIHfUhEJ2nG100ejG1qDWHGB1DTPxV/x54W+8ypJo6AyHSDcr6Ncx6kNLh80VuUHcrJ03+z8tmRLTI/vTSlc7uC+htkbCkuL72nktoftDTb7fW/bgHgOyFAoXMZaS2tnVc+P5UlJfT75DxLrCmV9n8M6YYQssK70bSvq2u8NB/ROGo4h0OmcTwiJYg9xMfXK4SCay1Moes8IYmyzeX+uX1YZ5Dlk9JsgWst1i59x6Lh9kjieNNQEitEqvIfNHMVmVy64Lq9cO+iKhdkkOnOeStOpvkONd0gAtEsoyMoi2oJ6JWXHdCrE7xVMlbPjEOt4v0MUCBCmAC0slCwPNzS8tqQqJgbJx9CYN3ZwMPdML6Ne3PUPt1NZqZFpR+QvBSmIJvcZDxTcQ7sebJ6IIg0hXDSHvYzhy1x0v3QZUrjujJLucr2d0Log9OEKUdpEzJk2hy
 XFYXNUJe
 GbcSYlNWEXgmmNwJVNOkdfz6mu9waR7M7pbNBBtwzhi65tWumxjOG4qO1CUi1q0DNlKZNLTwy6wJorZimX+EqrCIjQqsBJzjVfckU7POQVA8P97qm/X08Xzx0Lk/5kDDA7T3sZk3zY5L7ZyFssu8x8JT1F+1TCjcEElHt9LVLiG4rTOardRiNs632v5EenluHXSww9t9FCPl9xR92vC7C+CiKBMn9Cp3jG382ehnkxZViUVASNX03sATmuWXagskCl6U+M2wdUGfnfWdS6y02RSf4eQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_stop() has no reason to fail.  It returns an error code only for
possible future changes that can make it fail.  Such a change has not
been made yet, and this only makes the error handling complicated and
confusing.  Ensure it returns no error.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 16d9223c33a72..ef40aa44850ff 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1925,10 +1925,8 @@ int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive)
 /*
  * __damon_stop() - Stops monitoring of a given context.
  * @ctx:	monitoring context
- *
- * Return: 0 on success, negative error code otherwise.
  */
-static int __damon_stop(struct damon_ctx *ctx)
+static void __damon_stop(struct damon_ctx *ctx)
 {
 	struct task_struct *tsk;
 
@@ -1938,31 +1936,24 @@ static int __damon_stop(struct damon_ctx *ctx)
 		get_task_struct(tsk);
 		mutex_unlock(&ctx->kdamond_lock);
 		kthread_stop_put(tsk);
-		return 0;
+		return;
 	}
 	mutex_unlock(&ctx->kdamond_lock);
-
-	return -EPERM;
 }
 
 /**
  * damon_stop() - Stops the monitorings for a given group of contexts.
  * @ctxs:	an array of the pointers for contexts to stop monitoring
  * @nr_ctxs:	size of @ctxs
- *
- * Return: 0 on success, negative error code otherwise.
  */
 int damon_stop(struct damon_ctx **ctxs, int nr_ctxs)
 {
-	int i, err = 0;
+	int i;
 
-	for (i = 0; i < nr_ctxs; i++) {
+	for (i = 0; i < nr_ctxs; i++)
 		/* nr_running_ctxs is decremented in kdamond_fn */
-		err = __damon_stop(ctxs[i]);
-		if (err)
-			break;
-	}
-	return err;
+		__damon_stop(ctxs[i]);
+	return 0;
 }
 
 /**
-- 
2.47.3

