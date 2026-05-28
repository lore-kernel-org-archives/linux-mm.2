Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BA84CD5BC9
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 01:14:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0508F6B00A6; Wed, 27 May 2026 21:14:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1C1E6B00A7; Wed, 27 May 2026 21:14:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0B366B00A8; Wed, 27 May 2026 21:14:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC3686B00A6
	for <linux-mm@kvack.org>; Wed, 27 May 2026 21:14:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6EC1D911C3
	for <linux-mm@kvack.org>; Thu, 28 May 2026 01:14:40 +0000 (UTC)
X-FDA: 84815058720.18.802025F
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf07.hostedemail.com (Postfix) with ESMTP id 262264000D
	for <linux-mm@kvack.org>; Thu, 28 May 2026 01:14:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jdOmy2Dw;
	spf=pass (imf07.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779930879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5fu1dDsnMhKF93AieSigFxenLRg3U0YzuqKbVaS1vss=;
	b=xuwQUTOc6k9wYz8yYoMyIyhqVpcVcncE+T27xkXwDGXlNMA6GTkusF8/M2Jk9c+hUfra6G
	5GXDG757hCATjHqFDm9HZxK1YpkAXr0pq20lqBSglMCd5aeodHQPKuIRrMzwodVNFaLu9k
	qw/WP03xjsLz80YOQyBFvLJZLVHZj+M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jdOmy2Dw;
	spf=pass (imf07.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779930879; a=rsa-sha256;
	cv=none;
	b=OL0eJG183DkL3/jmyKbRw4DScCqbKxgr+YFRTSC95oWkgtHGUmuQrHBcJzfGs5RcLy7jY8
	m9gbfCMfPApvseMjX2Bv13a8oxWiuADrKGQzb2GyOKAaeiLuBKjxZuhZPYKPQu+BzzeImg
	9ulCsjRjXpCJX/UY/uiiBNxF1wuTP58=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779930875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5fu1dDsnMhKF93AieSigFxenLRg3U0YzuqKbVaS1vss=;
	b=jdOmy2Dwho+MmvdxHhF/EulRjLNea1P8ngmdi+mXKjWa4JzyL0Ja88ejVyohRPGvM/HO5Q
	y4t/WGVMmYk42atY5egxaFtDdKP47gcVX3rJ1kF36XvZP6ayPc2Rx274D1f9ZzRDveRqGR
	HsJWQnlmldJ05xNEgZyO3DEmNYQL+JQ=
From: Hao Ge <hao.ge@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Balbir Singh <balbirs@nvidia.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH] lib/test_hmm: fix memory leak in dmirror_migrate_to_system()
Date: Thu, 28 May 2026 09:13:36 +0800
Message-Id: <20260528011336.20797-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 262264000D
X-Stat-Signature: z7k7xp69t6rfon1nn8o3qweq9yiy85pc
X-HE-Tag: 1779930877-850626
X-HE-Meta: U2FsdGVkX1/wnLBBwE4yPbrquJIBxAYNY0F4m4HmcIgUd0BEFhQKfIwwQ97NyPikzCUTDOoad350Tqz1NV5GPy1SJZCXC3rQayenMv9btmF7EsSEjWXOeAvblTz57tFFHQ7CA1G/JpEllT4M9e4rTNlBkuCJLxyhPrgTk5cy+JdP1UztJX1ejs8vg/8ZNoo5su30MsbBVQRK6mU+pnMGlUFC3OXWMZ52ZWuHTqosVpBvNXB37/dsWv7YoR3m3zwkmSI/Ed4QUfd6o9vRZffWFrt+J0JBf4M8YEpKUyp37e0Hy3albY/YJYi68JK9/1hThpiiQs9c6KPmpCeQpH1aC4l1r5I7+bVCMfLOt+KM0Cei0r6FexuZ4GEw4wgxDo0vprv/AAH78j5kWEGxxBKVPlnlc/8//xp7A5VgfQ4fkry5t6eOSMOLMEV/CZ6gXQ+4HFTgIb0Kc3ZO6fuoPB2j7YOGqTx5qCS2ZipKBNXEgvL3LMtwFFDCaOtQVP59jtH6TP0TinXfW5yYVQ3BzRE6jBZI5bGDobbwxf/DovPFLTdml/+HfTfAF2giSyOpu1nKHSlTwY+ba3RJgtfI2nG8F9TJfNl0es3U16j9Jq38zWfHkHsc+XscPZce8LXhowkATDLXn80/8TaxgOk/JwUSRkrWP8WX/afwCbiTONNpKr7LT4CxtTWZnx6M8rkjAisNaE532RLj1uWgSODewQQmbk3j/W4HDOAZIHxHSH6LBalNICpCmvFzrNYGWnHLOphvYtbGIclFMBRpkjjz5z5vYW//2Kkit+YdVtnsUv1k/OfHto9PO90AeD2HMy7DsUeCihaMtSGW4sYxCD5NYsIyjc3dRP826LqOyl3usttcdyGwUcP5Zc5MMYwz0allEb0MSM0EnoWi6QJxd1Gb96R3LzGPazbFvzokxxRdniQ7XNZp+uWwbCCUryGhK35Z9A39RG6Tu2+7RfiLj13qJ8W
 1Df9ouFA
 RqofE5tQzK+Wsd6+jUvT3botSTchDa53/5xXYDqyFIT+K3fRjYaenmcZXdRWVAT6umJJ3RBpoG7XuMGh24nLVadJ8uNqEbRvUOpJqV7+fOra4XtGVhWSaxmHujMxabOB9hPsGfxI/V40mVYCAk5Bo7mRCszuuXMRQDAN6908HgQXtgxD6mE2yCxdcEPGlwOVzAKg0Nv/7ieSh0oobGp56mzrfamgFCaatMsPCzmuzeRF4B/UWm4n8zJAdUxkr62A7DShxivUGLRuX/USt9ZoXVukzJBsoIxbv0RgYuyvEu0br84Kf3MxPEWrlJNvbfQfwEKZSIwb+79B8cAI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the kvcalloc() calls after the early return checks to avoid
leaking src_pfns and dst_pfns when end < start or mmget_not_zero()
fails.

Fixes: 775465fd26a3 ("lib/test_hmm: add zone device private THP test infrastructure")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
Sashiko report: https://sashiko.dev/#/patchset/20260513082525.154036-1-hao.ge@linux.dev

It looks like the other issue reported by Sashiko (dmirror_devmem_fault()
leaking args.src/args.dst on migrate_vma_setup() failure) may have already
been addressed in mm-new by 84808b0e9f75 ("lib/test_hmm: fix error path in
dmirror_devmem_fault()").
---
 lib/test_hmm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 213504915737..0c02871b97ba 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1111,9 +1111,6 @@ static int dmirror_migrate_to_system(struct dmirror *dmirror,
 	unsigned long *src_pfns;
 	unsigned long *dst_pfns;
 
-	src_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
-	dst_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
-
 	start = cmd->addr;
 	end = start + size;
 	if (end < start)
@@ -1123,6 +1120,9 @@ static int dmirror_migrate_to_system(struct dmirror *dmirror,
 	if (!mmget_not_zero(mm))
 		return -EINVAL;
 
+	src_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*src_pfns), GFP_KERNEL | __GFP_NOFAIL);
+	dst_pfns = kvcalloc(PTRS_PER_PTE, sizeof(*dst_pfns), GFP_KERNEL | __GFP_NOFAIL);
+
 	cmd->cpages = 0;
 	mmap_read_lock(mm);
 	for (addr = start; addr < end; addr = next) {
-- 
2.25.1


