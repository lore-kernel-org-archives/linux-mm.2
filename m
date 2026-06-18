Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24BC8CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 13:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF8116B0095; Thu, 18 Jun 2026 09:13:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E81DF6B0096; Thu, 18 Jun 2026 09:13:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D97666B0098; Thu, 18 Jun 2026 09:13:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A94A26B0095
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:13:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A8BC140796
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:05:21 +0000 (UTC)
X-FDA: 84893054442.09.65DBFAE
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id 093F7100002
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:05:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xlflmLrO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781787920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=StRsT/girAhXblxgt1DXtSL21+bofC9V1moPBZm7vto=;
	b=1w0aANaaEfOhDlOOo8h08c+VC7jGTBR89rGvShyxVJLmrWJFVyfWvu25wERT1szps0tegX
	byOsFCm08/kHPYOcxVt2aHSS8jEmBjZEl/W+KNOKXO7cf5yOSBwkILjCQeQ/WPPmt9x9Zj
	NnjpS1x4FKQDpo4ka5S+NEr6j/Nj81g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xlflmLrO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781787920;
	b=ZwwOirfAyr1aWLSXsG2huepclz0qcZDSfUqWZ/8Ip6ykv02dvx9XtK5fKtbZ6hpCcjN7iL
	2pOOxKkvXa2whWjuh8BvNN7KVRUTSIJ+wjYMMOrKN0bMvDgyFQZAZ7WfATQJ8dHHETjpFJ
	3pALJI2W6o5nJfIz1g6roD7V6ZaR/JE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781787918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=StRsT/girAhXblxgt1DXtSL21+bofC9V1moPBZm7vto=;
	b=xlflmLrOQVshytOhIvWWQUWPlKzKluwWNKz5yd70FX/pQapU3ifdNWAzmO7qhu0jn92VnJ
	Gqsg5f1+wYuHY+tC+hNNKLFZ0PRWxMXsiuBA996rTqQaMm02wV75AlkB+C2G8UVtH7j//K
	Ac6YtTpbsftPHKV0EZKHlN4blIaXEfY=
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH v4 4/4] mm/percpu: Avoid IO/FS reclaim in backing allocations
Date: Thu, 18 Jun 2026 21:04:14 +0800
Message-ID: <20260618130414.96383-5-kaitao.cheng@linux.dev>
In-Reply-To: <20260618130414.96383-1-kaitao.cheng@linux.dev>
References: <20260618130414.96383-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 093F7100002
X-Rspam-User: 
X-Stat-Signature: ygbxuy7cz9jrkdbj9qk8a4zuypd84wod
X-Rspamd-Server: rspam09
X-HE-Tag: 1781787919-254514
X-HE-Meta: U2FsdGVkX1/LCxI3HzPCdSxjoymuPl5SSw/rfUweMiiGLxG6ARK+x9Eq3L/ZQ4V+pUXfgz8BJIRT3Lm4/s14iGRQ/tt6RjFighwYo4HxR5ni7VX+M+u6XCAUMPBkOCF2RbIgrvLqRvHpGvIkyo/vzwLWhKCbEw8wGdv5s0zr0YRsxxIviofERIc46kohJLuAzgXDTDc+wYW0Ga7pBOTB95zxXSyvpTUYytdWu1Oa1I9fYvAntEEvm/I/Mn4VTv/M7Yr3ydNFEB+gTBvos7EEngW6Bo1snTBN6CVwIXCAQfYjBpC3dbTlrleDc5lFDhlnUTRRuR0UYA/tgNTIocMb9HDWSMS5iERfLMuiHUzmnNCSMbycjHGMiKU3+nDGmIELVpSfLU2D4r4HrYKnrNGt/pjMoWwAaxjwAmL9xZ7nLi2+cJU8DH0ENYknftgy+WVG+1doCBVDaZOqymdzHeRg+1SuInxf3R3Z6if/Yb9WJm8mZ7jIOxgXQ8imfOWfnOjIrneH922v3trwe962Rj9pz58ac4ZWx5MiyRN9qLoQJ1C17Sfq/UMEEXdbhXuOOSrmFYHIF+8TPKeOlRlK2229dM9t0tIpou0gMtC6fuad4+L14Dl3yAdFptEdGqCsZ6BdYRFRElMZUHrUVi1rVZRHARDOhDJ4ReAeZ/RR1LUPrhbmkIuURhYDS54RTtRRpbAzjGNij/aZZa/m0+J66OP0lk5NJVyJ2bi8RaZ6Q2MllFr3HUcTYS+8nj7spdMQ5/qUhrGiqpNr4LG8lZDjlk/it0abcPrqaYnTa3l48CDwUTXaix65lKg8L4PZ27ZsA3gYTDi7UMAIH8/Bl2RypVbJbdVMPF6yfayuF+z4Rsiko359w83jkYWaANYC61pxxSlf3S2nY2FYRpMbwReSHmNqCvSZMl6jZP8hN4/qs7kqCh/7sv6uoPQLaCbvlyS3uTLwwOjzSR6D46IwCe5C0uz
 bIOJqBku
 LOCzJtL9IAzC+CX0vfREm1G2tsBE1EUKYbWtJYi+yVW8Y9I4Cz0LwzC+xi+FulAKnz8UoDcDWGZpmzoVI7BTsKZnfOZ0iKGGwDJnxlYmhYnG3jmoXibYfP0fxAJeSKWcs6XlIkFvkLu7AVihM6Q0oYMiJOMWBSoo9mGRLk3bXd+brZ8DfSoibdFYSz8AYpbLBvGuU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kaitao Cheng <chengkaitao@kylinos.cn>

Commit 9a5b183941b5 ("mm, percpu: do not consider sleepable
allocations atomic") allows sleepable GFP_NOIO and GFP_NOFS percpu
allocations to take pcpu_alloc_mutex.  This avoids premature allocation
failures, but it also makes the mutex visible to callers from constrained
IO/FS contexts.

Thread A calls pcpu_alloc_noprof() with GFP_KERNEL and takes
pcpu_alloc_mutex. Since the internal allocation is not constrained by
NOFS, it may enter FS reclaim while still holding pcpu_alloc_mutex,
creating a dependency like: pcpu_alloc_mutex -> fs_reclaim -> FS lock

At the same time, Thread B may already hold an FS lock and then call
pcpu_alloc_noprof() with GFP_NOFS. It will try to acquire
pcpu_alloc_mutex and block, creating the reverse dependency:
FS lock -> pcpu_alloc_mutex

This can still form a potential deadlock cycle.

Avoid the dependency by restricting percpu backing allocations to GFP_NOIO.
The public allocation still uses the caller's GFP context to decide whether
it may block, but the internal memory allocations performed while
pcpu_alloc_mutex is held cannot recurse into IO or FS reclaim.

Fixes: 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations atomic")
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/percpu.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 4d89965cba16..a802d72c116f 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1726,9 +1726,8 @@ static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off, size_t s
  * @gfp: allocation flags
  *
  * Allocate percpu area of @size bytes aligned at @align.  If @gfp doesn't
- * contain %GFP_KERNEL, the allocation is atomic. If @gfp has __GFP_NOWARN
- * then no warning will be triggered on invalid or failed allocation
- * requests.
+ * allow blocking, the allocation is atomic. If @gfp has __GFP_NOWARN then no
+ * warning will be triggered on invalid or failed allocation requests.
  *
  * RETURNS:
  * Percpu pointer to the allocated area on success, NULL on failure.
@@ -1749,8 +1748,17 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
 	size_t bits, bit_align;
 
 	gfp = current_gfp_context(gfp);
-	/* whitelisted flags that can be passed to the backing allocators */
-	pcpu_gfp = gfp & (GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN);
+	/*
+	 * Allowlisted flags that can be passed to the backing allocators.
+	 * Backing allocations under pcpu_alloc_mutex must not recurse into
+	 * IO/FS reclaim.  Otherwise a GFP_KERNEL caller holding the mutex can
+	 * block on reclaim while a GFP_NOIO/NOFS caller holding an IO/FS lock
+	 * waits for the same mutex.
+	 *
+	 * Do not pass __GFP_NOFAIL.  A small percpu allocation may need many
+	 * backing pages, making nofail reclaim too costly under NOIO/NOFS.
+	 */
+	pcpu_gfp = gfp & (GFP_NOIO | __GFP_NORETRY | __GFP_NOWARN);
 	is_atomic = !gfpflags_allow_blocking(gfp);
 	do_warn = !(gfp & __GFP_NOWARN);
 
-- 
2.50.1 (Apple Git-155)


