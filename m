Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E065BC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 14:34:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E031B6B008C; Tue, 15 Sep 2026 10:34:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D86306B0095; Tue, 15 Sep 2026 10:34:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5C996B0098; Tue, 15 Sep 2026 10:34:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 97F446B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:34:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 376AA160423
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:34:10 +0000 (UTC)
X-FDA: 85216241460.01.2D89699
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9865DC0016
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:34:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MB65qSxb;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789482848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oJU2qf6RfTrTOINNEF0BpYTy8ds1otoxQWBYuiCLwZs=;
	b=59vUaxp8LxNY8HIF/2gJzBccWqjU2p3ZFssfFiAxT+Y/AUH4YicrQAVv/lFwjvmX+8b7ds
	OCA3Fn0So7VEzL2ef05f9Ucqb4I0RmcjHw6gqiMO6ZPNp6EJn6mAPa+gBui9bp3K+Sy+g2
	H6px60sr8SpxjTPNUZARf/6aKFrGk3U=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MB65qSxb;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789482848;
	b=CdQV2arAlFJxD7ZBb/DCRL3JhiWlZamOEeq4g6EgdNW6NzEh21NV8IoZNAbxhbGF9cvtTB
	TnqQqmg7ABSZxJYuKjwYV5AbHUJ3yWq2qE0Ei5HUqzCoGTRLu6WuXV+7Xvf5ncnbKGyAoY
	Hf/ZjF2Lv+s9VlkW+L4qHoEYR0r2Z0w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DA8C8403F8;
	Tue, 15 Sep 2026 14:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 982D91F00898;
	Tue, 15 Sep 2026 14:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482847;
	bh=oJU2qf6RfTrTOINNEF0BpYTy8ds1otoxQWBYuiCLwZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MB65qSxbkWAKcFKSS1JoPP7/RNuup+iughXzsMXlu1Uc8vSwNzfRKdhTcdciBfKJn
	 a89BjNR2YLYplIPtao/LiMbpGTFkaitPUtKXi09Ng418X7QijGt2hk245hq32FrVUX
	 XwHVAyOxgaOird8ttLlLvxed/IEgZNe8+/TQgTljDsqA8DeIY18EEYBji34CSrJHRp
	 SzhkTcb8Cwa2ml/FPzeKXE9UNhSgSrNZTeHUOVfNpQoOJJGfr0TepIvTxdbGuVJM/h
	 TzrgAZ9RopO8f1dnhK9AEC7T6xTT3j4YB7uWmdyorb1kdYGeCkg7C378E+zTqXiazJ
	 YmrZ3Vxv95iOQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/8] mm/damon/core: commit hugepage_size type damon filter
Date: Tue, 15 Sep 2026 07:33:51 -0700
Message-ID: <20260915143359.91472-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915143359.91472-1-sj@kernel.org>
References: <20260915143359.91472-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 9mnedbgmpinjwswk67tijug9dzhrgpdj
X-Rspamd-Queue-Id: 9865DC0016
X-Rspamd-Server: rspam07
X-HE-Tag: 1789482848-706188
X-HE-Meta: U2FsdGVkX1+HpB7lrSSHXBVpTtqNHwof9P4s/gQ+CybvInmmET8fPLmX4usG8cQmeccOhXyHYHqZ/eZMTN38HKnHmOWHmS7f2ukYw6mNjFd1psiny787s727jiyOBYSk/5tt9Lt8MgmR4HSz4twMF3RQqNfa9m6ouyVc5mz0oIf0ze3a1pLxUywV0bvVdO8qV8VE+6nlgPfh4bkVD9qpPSDD8QejZAPyCbmA86RqaYrEaErZBQEqwqF62XVvQA/ehsLjxY52JM3l2CXtPRW3hsE2vNla3YKGj90aJmb5+0i6y7LDLHhXKHXx7HNQiZ2KFM9/htKYrhPGnJdgZ97xIgWJvgwGfwZuc4w4KxLup2BO6OpdqbYfxHGaLkUYO3lC9Z/KqO84x/b78+FsqH2THKq5hEpfUUPm0IstFnCSF3UfCagk15eXpzji+KP8eE8EUbTKPtBHJiZ7+89gtEyGVoWEI8M5rYQiUexRCLhbBVSYrc2/KBOroSRbk+W60aoNIm77ivctQBw4rMIHQjrIVM2rIL6vf70Y3a6dfz3PAmd7m3Xt7TjdSoaSWHj7CXc0As44bUiUkQJ+oNkF9rc0KH/Ij19HniF1oPbJu8aUe48wmlDNAzTNivXKV65yUnU+kiQwno+hLEq8G90gr4jUN8/QhTtwfC4mOdyczg3E8jW11ddQH+QmBVM1FQO/roFW4CuaBijd+dKFYdBO7d1LxuJLjO6Bs1ptyxag7AIdxn7HqhokC3JagBP1eI9O5pvnehq49dsxePsdVsz6QBPZEEhBfGi1JzceGMrHyXPHkYl/v+DMq250rWx/NGvVCl6N/+t84EyxYIU3428hwqiDItjkSA+9tTYwBAM1X1C39fgCdKcsryi3sPu+uoJFr208exiFXLmdi6kzmSOoRu4eT4M5LXq+AnhBGjalf2IQiLsXrdFZZc8z6iBiqBUUwoW+P1y3ya06snZsiM5fwSA
 twleiMY2
 GMB/A9YLB/EBO17y9dHO7YQRqaxXmd8s7M1uYS8I0+P5v69LyjvZ0mstcII4K+PuLTCygB9jfZ3OjQqQQT6bSUUguFK2A4zhFIRPorEIuzSdpfVqoaq0Vlh8jJNH1mwx88WJX3nV8iE2OIKGHKIMhAPSQEbsaIsDw9VTxCJe0WdnrVB2TovM/1ogeiB4ytXJ0+Khl9C/ZmGY9pQzhsOBcmt7bYO7s28b8qoPXSkU6aap7giztVkeEwJw9ONGvQL3KbOWxEcFINU3gCdhEbGM1gSAwGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend data attribute probe filters commit logic for the new
hugepage_size filter type.  Since it needs to carry the size range of
the hugepage, update the logic to update the size range fields of the
commit destination filter struct.  While doing that, validate the given
range and propagate an error if it is invalid.  Add the error handling
in the callers, too.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index e0414d2adcb41..dd4317df42ff4 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1818,7 +1818,7 @@ static int damon_commit_preps(struct damon_probe *dst, struct damon_probe *src)
 	return 0;
 }
 
-static void damon_commit_filter(struct damon_filter *dst,
+static int damon_commit_filter(struct damon_filter *dst,
 		struct damon_filter *src)
 {
 	dst->type = src->type;
@@ -1828,23 +1828,33 @@ static void damon_commit_filter(struct damon_filter *dst,
 	case DAMON_FILTER_TYPE_MEMCG:
 		dst->memcg_id = src->memcg_id;
 		break;
+	case DAMON_FILTER_TYPE_HUGEPAGE_SIZE:
+		if (src->range_max < src->range_min)
+			return -EINVAL;
+		dst->range_min = src->range_min;
+		dst->range_max = src->range_max;
+		break;
 	default:
 		break;
 	}
+	return 0;
 }
 
 static int damon_commit_filters(struct damon_probe *dst,
 		struct damon_probe *src)
 {
 	struct damon_filter *dst_filter, *next, *src_filter, *new_filter;
-	int i = 0, j = 0;
+	int i = 0, j = 0, err;
 
 	damon_for_each_filter_safe(dst_filter, next, dst) {
 		src_filter = damon_nth_filter(i++, src);
-		if (src_filter)
-			damon_commit_filter(dst_filter, src_filter);
-		else
+		if (src_filter) {
+			err = damon_commit_filter(dst_filter, src_filter);
+			if (err)
+				return err;
+		} else {
 			damon_destroy_filter(dst_filter);
+		}
 	}
 
 	damon_for_each_filter_safe(src_filter, next, src) {
@@ -1859,6 +1869,14 @@ static int damon_commit_filters(struct damon_probe *dst,
 		case DAMON_FILTER_TYPE_MEMCG:
 			new_filter->memcg_id = src_filter->memcg_id;
 			break;
+		case DAMON_FILTER_TYPE_HUGEPAGE_SIZE:
+			if (src_filter->range_max < src_filter->range_min) {
+				damon_destroy_filter(new_filter);
+				return -EINVAL;
+			}
+			new_filter->range_min = src_filter->range_min;
+			new_filter->range_max = src_filter->range_max;
+			break;
 		default:
 			break;
 		}
-- 
2.47.3

