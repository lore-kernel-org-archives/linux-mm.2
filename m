Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 362DFCD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 13:30:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F7186B0005; Thu, 28 May 2026 09:30:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A7376B0092; Thu, 28 May 2026 09:30:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E49A6B0096; Thu, 28 May 2026 09:30:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8196F6B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:30:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B22DE1207F2
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:30:29 +0000 (UTC)
X-FDA: 84816912978.10.2EF57EB
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf01.hostedemail.com (Postfix) with ESMTP id CDB9F40013
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:30:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HIyd9o0V;
	spf=pass (imf01.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779975027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xtP6vXc+wJ1AKv++CgvfrsjrOTISB3WM3uSjHYG3gWE=;
	b=wrEn/5u0G5XU+WK7Ro4Y3u3xHvMu6cAfNxjzwA0dVP01/BWGmR1QN2AOXCfHo1gilNpkQ5
	UtF9x4HvmPOT9PJ0dsHxVOHMADvb91bUNXpwtO9FyN6zNi1BYBfS/fNxJpy2PhJD8Hw+jW
	hMg4Fzf6JHX4KyzW1cXYcXhDf0thMTw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HIyd9o0V;
	spf=pass (imf01.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779975027; a=rsa-sha256;
	cv=none;
	b=mxc9zVXD4LGI5WKVZTps9jTBn50T15SCMfnRpVPZU9klXqzkm3VAMbLoUnkI+MoHvwJZTP
	JsF0ubPJYMFexuHBhbTG4NLs3pdO28tiWw9gXco+Q7ulUi+AiAs+besj4XPDPSDkZxhx7I
	qyghUZaEwSjUk7I9dmVO9GMkvW376B8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779975026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xtP6vXc+wJ1AKv++CgvfrsjrOTISB3WM3uSjHYG3gWE=;
	b=HIyd9o0V6brTfZATywJxIFk831aiMRHc+XNfJ8OFdKNEZu/JOtvt1X6UUEetvJSxDR4MQ4
	W5oNzudzyvuB7V8LEJlYz/BxhuUaw/VIQKTPj53ulQkUDg5Wju+1H954dpOWAOhjzMNKXk
	+BAkjgcMQrRSNLrH7PJmtp3E0gzimbU=
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: dennis@kernel.org,
	tj@kernel.org,
	cl@gentwo.org,
	akpm@linux-foundation.org
Cc: mhocko@suse.com,
	vbabka@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	muchun.song@linux.dev,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH 2/2] mm/percpu: Avoid pcpu_alloc_mutex recursion from reclaim
Date: Thu, 28 May 2026 21:29:17 +0800
Message-ID: <20260528132917.81123-3-kaitao.cheng@linux.dev>
In-Reply-To: <20260528132917.81123-1-kaitao.cheng@linux.dev>
References: <20260528132917.81123-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 8i145aabkq3g9h41tynuyrwtywjzatj8
X-Rspamd-Queue-Id: CDB9F40013
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779975027-933571
X-HE-Meta: U2FsdGVkX18j0ZPeKZ8DAmrGg8zhiTfxK8+vyo9iOcCYzyIJRIHjCzAiL86wHEf4l7h0NJ6J/1QSFWwQCzla7cANON+l+fIQXF/UTBjKy5rSVB7+pHbF6fKI0SwK+2b2OUsqV3AraDoAF3274jriwv8FTeFTLKehDeNMiYkUtCYWksXmTVBwfO2U/u0gsKiEqovEoWyVvISoQjIzarJDY96Mp9InQaTsoewBHyLtxtmIQYllmmMQTUxkqFMOXXV0pNKL4c95nylfmQOls1o6WBPpxPv9aHrJmgpnw2cg47rxsXFpdYOsnMmYjxmbJIo5f/WOjnMkQzx9VSLuUCmS8gwP/PEEx2mFXGlktCY7ALsv4gjnaiU927rCJhn6PaulKBW2YurxSfGIVlMA6w1ytUE/cN+yyTICqx9qKQtCTM5V1wjxHP4qRUiNfS0XChMAvZ9BFYqfn01d/vKMWY8j7ie0uPcwfDPYkSL2xmNczWyhqCEKZ/UxZlIWrgjiJrSCrglFCyanSwl4mJT6+SLS26GRM4q8XIlc5jCzGsCCCrX5/WWdDfVI6d6DCv0aARAJnl115edbjiEJpt/F4PxzkckKhpq502oT9pNQn2CIK0M37kYd2KhHx18jAfOnqHLQjbzLTw3QbxqANNGnKx0eP2lQJNoFhyk23YgwMj7eGrO6crT/YrCL1Sl6pLe4NZI9dUqIb8VpCoGCeT0Zan8z30ZGFkfaqeh5HJgcWnJxZvq+5Mtf6GI7wunHx50wGsPhZTGZlcHY9y2Fr6J9wqrB8ENbhdQ+xUipQbODJjkoP1ZLwwUkmST4rv7/Efoj6eJz9hkFMLtRASd7Raolz0gbPuG1WxKAM+gfz4/VNVS+PgVBRWKDfSiDE4mn90VcIAwBprw/GwM4i9Qt/IY2l4+b8/bXtpgCYPrYoFPPi5DB5InVIZTalRmcc3d1Wwi9Y4IRuats9QdS1skSiRcI7rs
 Qd8t1yGJ
 tL2FwWBaqUb+r351Dny+cYEkZ7kAPiXGn4Ohe0LqCksjoDawOlgjLPIx3dcM5DibpGQllStXbTfhgAPGfnZGUu8rRHLU4RTvj29Kh+CS5JErSBLbrkCHL18unu1sn3YeAy6CsiELLb4uU0ZDVvYy1qiJschrw7x5X0RYDW7ChhdmPdXFtx+uwjJgkbeN3EBTSTa8E8PKSiyWDIcv7tcxAuy9vY3qcvu7c8v2saVw29eACw/UkUieW5PWv3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kaitao Cheng <chengkaitao@kylinos.cn>

pcpu_alloc_noprof() takes pcpu_alloc_mutex for sleepable allocations
so that it can create chunks and populate backing pages. If reclaim is
entered while that mutex is already held, and reclaim reaches a path
which allocates percpu memory, the nested allocation can try to take
pcpu_alloc_mutex again.

That creates a reclaim recursion dependency:

  pcpu_alloc_noprof(GFP_KERNEL)
    mutex_lock(&pcpu_alloc_mutex)
    reclaim
      pcpu_alloc_noprof(GFP_NOIO/GFP_NOFS)
        mutex_lock(&pcpu_alloc_mutex)

Avoid this by treating percpu allocations from reclaim context as atomic.
Such allocations may still be served from already available and populated
areas, but they must not enter the mutex-protected slow path or create new
chunks. If no space is available, fail the allocation and let the normal
balance work handle replenishment outside reclaim.

Update the function comment to describe that reclaim context allocations
are atomic regardless of whether the supplied GFP mask would otherwise
allow blocking.

This patch is a preventive fix. There may not currently be any path that
calls pcpu_alloc_noprof(GFP_NOIO/GFP_NOFS) from direct reclaim context.

Fixes: 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations atomic")
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/percpu.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 1bb38467390b..9c30e5897813 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1803,9 +1803,9 @@ static void pcpu_memalloc_scope_restore(gfp_t gfp, unsigned int flags)
  * @gfp: allocation flags
  *
  * Allocate percpu area of @size bytes aligned at @align.  If @gfp doesn't
- * contain %GFP_KERNEL, the allocation is atomic. If @gfp has __GFP_NOWARN
- * then no warning will be triggered on invalid or failed allocation
- * requests.
+ * allow blocking, or if allocation is requested from reclaim context, the
+ * allocation is atomic. If @gfp has __GFP_NOWARN then no warning will be
+ * triggered on invalid or failed allocation requests.
  *
  * RETURNS:
  * Percpu pointer to the allocated area on success, NULL on failure.
@@ -1828,7 +1828,12 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
 	gfp = current_gfp_context(gfp);
 	/* whitelisted flags that can be passed to the backing allocators */
 	pcpu_gfp = gfp & (GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
-	is_atomic = !gfpflags_allow_blocking(gfp);
+	/*
+	 * Reclaim can be entered while pcpu_alloc_mutex is already held by
+	 * another percpu allocation. Avoid recursing back into the mutex from
+	 * reclaim; best-effort allocations from already populated areas are OK.
+	 */
+	is_atomic = !gfpflags_allow_blocking(gfp) || current->reclaim_state;
 	do_warn = !(gfp & __GFP_NOWARN);
 
 	/*
-- 
2.50.1 (Apple Git-155)


