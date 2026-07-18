Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0669CC44520
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 00:43:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6941E6B0109; Fri, 17 Jul 2026 20:43:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63DB96B010D; Fri, 17 Jul 2026 20:43:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 552D56B010F; Fri, 17 Jul 2026 20:43:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BB256B0109
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 20:43:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 99775A084A
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:43:13 +0000 (UTC)
X-FDA: 85000048266.01.EBF8CA3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 23BFC20003
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 00:43:12 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LvkM1VId;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784335392;
	b=jU9L6go7vily1FRg+4B+Hiys4gEoV2/hy0rmc3HyCHwGn+U0G/7hscImbH6f9u2ONFAnUu
	sbnYCQPYsV8mW2FeaAoG69OImKdSsRZT7clFn1mdOEbVojgrT2pcB4s1gYpUhpq+VAI86v
	xWRvl0xqsi9rgoxoy2NkzuBr1Hlc7MI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LvkM1VId;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784335392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JS3w3XL9lBOxCrsYXuWXGjRlToz81TO5Buc7T8lNzzk=;
	b=3c0jvnH61mKuY1RklXQB4uOi795w7uXHenQ1az6HzAzRr/ZpNW2/+QezHvcbAvhG/htCXy
	ezXfmV+Csq9OZ7fiMhs5f8PZefdOayTY9XEq31J70hPWbaL8bRc/N+ukO+s1ZF70oKSqts
	6eaOGfdSiK2QGC1tT+wc3mo0GI0s/JI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 580E8437ED;
	Sat, 18 Jul 2026 00:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DDE1F000E9;
	Sat, 18 Jul 2026 00:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784335391;
	bh=JS3w3XL9lBOxCrsYXuWXGjRlToz81TO5Buc7T8lNzzk=;
	h=From:To:Cc:Subject:Date;
	b=LvkM1VIdulJi2+c+0scwEAUmj2pqW8aoeUDmMZEPZU6ZKsZCJHFa4bbEyM+qbUms0
	 6Dd3JxDWSukUnEKWo4BPk5ZymTF5LYoW4IjSBplN/MjPyiEO2qmnDCbIqH848Ho4Cz
	 DFfMjm5KndnKGGpGz0lrF0vVqwHpxi3f1AXNV5DMwf7H06+N/rCNhB0DEwn0Jn5cMr
	 tfjVMIOmfJdaHESnfbA/GhVfSvgJ63d5/XWHN2UY58e8l6luLK2ypsdA+0neZrNi/h
	 yaIk1NCyASQchdyFYIA47jp/0Aodsfzk0+W6H69hTFeGcSxITri7xGLARQwrbnTUpG
	 2yxTbeiHOm2Dg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH] mm/damon/core: handle region split failure in apply_min_nr_regions()
Date: Fri, 17 Jul 2026 17:43:00 -0700
Message-ID: <20260718004301.88883-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 23BFC20003
X-Stat-Signature: atma5kat55zc4ox5ozqq6u9ktedeopga
X-HE-Tag: 1784335391-517927
X-HE-Meta: U2FsdGVkX1/CzNhYVCFuRPmuz7zl5UvBtrWzFMObjJPy2fT7BkfXODI8l7btgZtkcitOkD3fHrvW27jHBY2aegDJJ/XGK1p+p/MamUpZ/G9JqO+dzzxe6XUy//TGpVnXiMYubD5XsuepmdY3NHrN1UhBcODwGImxzMttx5E3Vc0/QfOxd/pv0A/oAwve+Ym7zkMjXHhauQaV9bUucs26aVnNXQIrMEj4bkhhighLDrAiOpzBbL1EPdxW9uuS0RwrEEYYjADUeXtzecohWIVlSBjyT2ZZQ5NOrlkGqvsaa3+HmjklfGu9DXBPJFxFjWT2FYvWLYouWvJbTNjO5+iWaSeKigV5Y0HR+YvT8dr5J8M9kRxLuoxUtTlksoyWQxjNjrAmER+lMGOHTdy8UZL/sNo4SjirW90YHV+Cm2CA6U3Q7QkOArOfAGsHabRsTuMhiHmJl2H1k/pD7c4SUbxHY1bydTIS+0MjV+lmKJNObBvM9CjN/d1g6UgG+P2RNL17rXbwQtn/0EF7mtnGId2lcIxHhzExBp2V7wKUdv/3MnMF9/MvUJF8pV/3zDDZE9DXfoS2Nb1oXXuWvgXsM//6GK+HYMX0q/fcvjY0eytCFjRKjn2dVlrYGtm+l0nvhmZPg11CRPVUIZeOLVUWe8kTOsxg703idkm7NjvJSBw030GNV6izUPyxxr1tojeSC7BaP4ohuiFPpkhe4kCh0r2jeqWM8uNY9wBt2tBignE6NrUMM+lSqtSTgB9x/C3hPOByYIU3n85Fw1Ye12M/lMFjk2UuQfUqh9olVpdONk87+2iQfvxqdLj/uJiHteWoguPl2x3H4jseORZG7RygfBRFZ53DjjtOG6Q1G5PJaapJjVEmreSKKbLWd7kpV8nFWA3Ez004umb6w1vJgGoblQAPcVnoSQrbnUPVKuSIA8DpeZIvmT0W8ds3hBRZX4r0yknAoqWdwIaIh9DZVJmE1R9
 fi4Ln+nk
 sFcqhK4dptnzUO2zacluMNT9DLstdmJdDVgEcdnpU717WLznwONJvaeUGBy9qFIjzzW05sdWbB2ilJntHaUvk7zeR55pckAFN7F8zE140MnIGAImnqz1xKxAbeh+tly9mbbycRx5rWKqTLFrEQM2y6LZdAvCMkTSWPWFpPT0m8AJ2tVzU7cwpRVJKXqTCErhZ4HhJOj7oQixfggOwW9AaevM1wx6V6kxQAwkYVXHLFjwY+nhSZyhBKs7t+2DTtXwSzqiMSOKC8YKlfuPiphcmLj6KHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_apply_min_nr_regions() repeatedly split each region until its size
becomes small enough to meet the user-defined low limit of the number of
regions.  The loop assumes the split operation (damon_split_region_at())
will always succeed and create the new region.  But the operation could
silently fail for memory allocation failures, for example.  If such
failure happens and the region was the last region, the linked
list-based next region fetching returns invalid pointer.  As a result,
invalid memory dereference and corruption could happen.  Fix by breaking
the loop in the corner case.

The allocation failure is unlikely since it is arguably too small to
fail.  But, it could still theoretically happen, and the consequence is
very bad.

This issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260717011834.120715-1-sj@kernel.org

Fixes: b1029f29eb1d ("mm/damon/core: split regions for min_nr_regions")
Cc: <stable@vger.kernel.org> # 7.1.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 603b102ff80f9..ce79918400cde 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1912,6 +1912,9 @@ static unsigned long damon_apply_min_nr_regions(struct damon_ctx *ctx)
 		damon_for_each_region_safe(r, next, t) {
 			while (damon_sz_region(r) > max_region_sz) {
 				damon_split_region_at(t, r, max_region_sz);
+				/* split might failed */
+				if (r == damon_last_region(t))
+					break;
 				r = damon_next_region(r);
 			}
 		}

base-commit: 47263730d8de68a42ac020f8fcb9044f8c86e1b6
-- 
2.47.3

