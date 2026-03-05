Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41E64F30951
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABF1B6B00B9; Thu,  5 Mar 2026 06:57:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A93246B00BA; Thu,  5 Mar 2026 06:57:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AC716B00BB; Thu,  5 Mar 2026 06:57:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8BC586B00B9
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:57:41 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 30CA8C268D
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:57:41 +0000 (UTC)
X-FDA: 84511859922.28.C350CA5
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf16.hostedemail.com (Postfix) with ESMTP id 64FBE180004
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:57:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D5G9LhV9;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jmuZGex7AAaN+LnMc+A6Q6xc1gQPncq5PZ4nPQh5Rck=;
	b=yJribdhgTEoxPGuPJWBeHQ9Usg2bzceZ/TFmOx/u6HYKD3Ko4HukW+w2/zgEK1iki5KBy/
	o7qP8r1jfECbqlB+mXWftJQXn2uZ+n2EHyIFj3U8GMdsyb3bJMR6q/Oxu9iEhInLvucxhz
	JxfBUcvdFJkEy3nxWbPJfXHDJui+320=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711859; a=rsa-sha256;
	cv=none;
	b=5KVSx/P6xeo26JFTOUJwpOfaL8lvAQeIJ16qlbfrWP4zNTUvtNjaL8yVHjOhjsne52SKll
	LqEPyxahXvLb99R4vjEqWQJjfcOuzMW3ctwM0XkWY8khyBh4XI+RNs9lgTBw1MHFwnE9eH
	QmuWikwdE2g0X8W1/5i91QsUFbCMeik=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D5G9LhV9;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jmuZGex7AAaN+LnMc+A6Q6xc1gQPncq5PZ4nPQh5Rck=;
	b=D5G9LhV9i9D+g8zOKEs6s94sZHQteuhZZQvtZYE5qwK9GZ7kfNcLpYygIw0aL1xzHzwQ7H
	qo3NIicbH0E9eBQhnms0uu/Ctl6xOdp5PuA/td0lZLaXnbWyCF1loex70Eb/PwO0pqB2b6
	D5pea089i0q7vev0/I3J2Cj7sSfCois=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v6 20/33] mm: zswap: prevent lruvec release in zswap_folio_swapin()
Date: Thu,  5 Mar 2026 19:52:38 +0800
Message-ID: <02b3f76ee8d1132f69ac5baaedce38fb82b09a48.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 5obp5mhehj4g1zqdnconxw5xu69knwd3
X-Rspamd-Queue-Id: 64FBE180004
X-Rspamd-Server: rspam03
X-HE-Tag: 1772711859-592272
X-HE-Meta: U2FsdGVkX1/E03ZuRcXgQgwxdSVDD6z1obbhschviHW1etnB09BWLg0GH/BL40euj0529xMvIwNiRYK7QhcDw8HEfj8aS4Ie0rZiKRfeckwFo/Z3bK2pTLp2E0F+VFGMu/LSJl8Pi+tR2MaNXovLMWm+ZxjtrhPqOi7Ed3lVn4E10O0TNlz87nGmOD2bsfWw/ZjbpcNj1zeZoIdqYpicbU0cDb2ML4y+IIBQS5vS2JM1K03Vav6BQl+fcAvyUByMyUh9hqHWtHdNZ1cXm0BXtSnE1n+dYFl+c+CuIKjFOW1qeNAOGQljHnyQy/dsE+fzLg9JsQ6uacDpoc83yIimGb7IpHKNHyEJ4liVQTt9OgLH09k/warpjjSmwNKjaWXdjzlosYM9d3l59Vupy4XPP6u8a3yUd5qJxReRO5x0ElaI6FOnWzKGk9dHydp93iT+NTpb51E1Kq70It3512SGnv7EHMleiBNk0uPDTh7RzhM7FISxv9LJcyihiBeVksdI/nX8jN5StQm1X8HWx69xqCCJRj6G1HX4glNa9aMvtFqdz9Djz748SFTQbOermmklqciuVL7ysQ0vGmYnDBgeG0901VZLd7xf9Hpethl/hUC/tS5kp3ChoYVAfmJLftV1px9Jx0qTMYcZKH0GP55VbYe9dU48N9fP+jJr3hyJULNLZ+Rkq4tydcfBMbegp7K+raBT1mRIfWMKh2gUI94gtxMgYq6ZkWjNBVmKonPul3rTR/dpsf9SZQJ5CwhA2SupPgg9ab1Qrh+EH6jje2TJeitI9oEMMkbrTn8xjaYvPfA+KEjYszlhK7m3MwPGo9L3dPZpH6FewLmAxQHkLtGcCdAGCi1sdOE09QbmmgkaO/tONswzw3EVopZbu18/SC4iQ9OtA5KqldQBV1PKQdkewl2vpM5qTqD2Kg62cwyxTtDNALUZ+8tqSfckyyYDWpJjY0IsTmjwvfa//QVXP+W
 yRKrTumi
 z0TLVDV0UaosbP/mpNj0CpbK+rlcAx2Y1+n1ZU2M6Gq3sl1VviwhHKYudnfjw74mDV4HlsWYme8Fhe2d933Hbl5Z5JTsKBVH1SYiUIOqXyZh5IkKvSa7zhJpDYdwatPWRcnawpAaobCsKFSAIe7RLsUDHrIa6KHNy/aqBnvE9nC25/g68R3OQErX1VEeq82rF3dVnbanzwWImSr6ouUvS3usAyRcyyoINhSouWOzqzPARpW6ITknv1ntF5mMDYaZiMpFY8LYwiyVqCG8W3g42B9moPNFousQVr5nJPWwKInTVKLHYQr1Tai5bpEodg/r8xR7z/I9BsFGTAy8vDeXzbnCRcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. So an lruvec returned by folio_lruvec() could be
released without the rcu read lock or a reference to its memory
cgroup.

In the current patch, the rcu read lock is employed to safeguard
against the release of the lruvec in zswap_folio_swapin().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/zswap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/zswap.c b/mm/zswap.c
index fb525874a1b6b..bdd24430f6ff2 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -664,8 +664,10 @@ void zswap_folio_swapin(struct folio *folio)
 	struct lruvec *lruvec;
 
 	if (folio) {
+		rcu_read_lock();
 		lruvec = folio_lruvec(folio);
 		atomic_long_inc(&lruvec->zswap_lruvec_state.nr_disk_swapins);
+		rcu_read_unlock();
 	}
 }
 
-- 
2.20.1


