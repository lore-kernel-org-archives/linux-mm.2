Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 177DD606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bdw9QDwU
Received: by kanga.kvack.org (Postfix)
	id 4338E6B02E5; Thu, 22 Oct 2026 18:03:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40CAD6B02E6; Thu, 22 Oct 2026 18:03:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 347AC6B02E8; Thu, 22 Oct 2026 18:03:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 137556B02E5
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:03:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A5B271602EA
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:03:23 +0000 (UTC)
X-FDA: 85351639086.18.4065D61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 10A7814000F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:03:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bdw9QDwU;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792706602;
	b=69B92ncZMyLW6YScjlILPq9y8iSqjsrvGXk+P7WLKbk4QWcm92ZyrmzVMeL5X/wDkODal7
	1iXAeF4gJbgRqqbu7g/aK/QgqlxD993bvElxnFqLntzrEQNNdJOnYdVBRivsbOWnZm98D1
	XyLotptwTAHODg+PfeVYaTlBeFD+yZI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bdw9QDwU;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792706602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vFrx/Rduc+8ObKA8YH7FJxIFbEwpzgAWwJqG31qSCIw=;
	b=TXGNppo8lpOOY1znkWZFdF0CV1CtQFkBksGESeDxq6MGaQI/EmbwirHLqzv3cMKAJFyubt
	VYvpn4PpS/BfT1LnN9qD8cNRyN2B8NOzYXyzmnut1nRoJeqVxXlEoLGNsCuj80iJz+Xwz/
	vfq9FZyxIx9kLoKFkamU1j7cNr1is+s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3E79B401AD;
	Thu, 22 Oct 2026 22:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415E11F01825;
	Thu, 22 Oct 2026 22:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792706601;
	bh=vFrx/Rduc+8ObKA8YH7FJxIFbEwpzgAWwJqG31qSCIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bdw9QDwUVXcRyjLN8KRZcI2Bz1J5yyYtGTIy6mchZ/zi+ZrzTMDCw0bcmJSSr5SL0
	 w0CElcSGKrGVCYs5L/fRGUcSQpIKrUjUIOVeMut+Joh77JQLjYCao3C5fVxFsP5Erh
	 3pHOkMe6HeVtrGRgrBVeOcyP++L+FkUzt1b5j0cdmLKGfh5raNKKoi4R0cIxaaWyR7
	 D5DfrJrxivUmofIRt7wofBkzqw5fO/v75E1FG+GfZi/9813c1SugD96qrev7RZr3nV
	 9rzEWWE+aBpoWLQNGpFUGUtK9PzhvBbMgx5C9OfhKDNM5gt8SH0OtpnIi/w4UJRd+1
	 C7KoV/jusV+gw==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: hui.zhu@linux.dev,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com,
	zhuhui@kylinos.cn,
	baoquan.he@linux.dev,
	liuxiang.277@bytedance.com,
	wangzicheng@honor.com,
	lianux.mm@gmail.com,
	kasong@tencent.com,
	liam@infradead.org,
	surenb@google.com,
	mhocko@suse.com,
	rppt@kernel.org,
	zhangbo56@xiaomi.com,
	lyugaofei@xiaomi.com,
	ridong.chen@linux.dev,
	kunwu.chan@gmail.com
Subject: [RFC PATCH v5 13/14] mm/mglru: Make swappiness=1 file reclaim more aggressive
Date: Fri, 23 Oct 2026 06:02:02 +0800
Message-Id: <20261022220203.91911-14-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261022220203.91911-1-baohua@kernel.org>
References: <20261022220203.91911-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nesng6jdnsmqp3qhbpd6ehidiktc4cjt
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 10A7814000F
X-Rspam-User: 
X-HE-Tag: 1792706601-642805
X-HE-Meta: U2FsdGVkX18+OgzbfzAT8jya0idG2VTWwCcs9ogcKvvL3Sujdxwk4ZtKx4/f0V3hpBMGr6up9/7TotgFWuVxgpSFg9iMIDx7yAxmsumEYnwe5QzmDQIIEBygJtrWQu7To5LHzgUMyzVeNHq+zDiOdK+kJwmJaSb+67wIXwe3od25sWvQ0HxV6DIVp7quuCsnb60iBbv5SWQcQDr3AtmcI2gpXAg270PmgG9U0YZ8md31wOO4myptQRoCtFn4R+c3AsZFiZnNrGKB7Lsiro4SAaIpgjxo+cTKzJ5Dq6SnOHwJIBdopIWyvrRUEGjl4x4grB7oJbsCNL7Yh2zs+dJoBdyln9vR9JxvYSY48M6tGQDCzwdT44qqF9gXlDpAr+Oya/JdluIbFRW3PHEctem8RfTjPCjd4DbOvCfdq4PXQHEb15v0n3js9/hYcQ5d09cbQBtyZWHL/I9mlU/h9/QSFngy4abmxySoFCjKQxjl+O6qHQODminWSyym2hFDKr5pDQEyA+MGoTl9ElbBO1QQV1nw2dUrfOz2c3qZrQ0Y0JYgW2Q0K4LtnTLj1qdTMNaB93KMv5H7yLldcOw5CB9MhQyGE8/gQYP2x66MOUZjqt5g/X94BMAAFZiufdW7FblJPpGU5QCqfS+zk0ACIX2pDxiJGLx7AW6FI+wHBvBlOi7B3nr/GtYnGYrt8+dv4N0rEhwjoUTGtiwLmLYrjDdo0IejqntMOteNqnXL9xiAwSY6JRYrQGCKOsoUwmIg4rLw5aF1ZO5CXK5pWaot3J04NnZsyXtaabPfuT8w5TecSKshBRHoHzQvpmUYrAuD1M7/wCtIVSluIfZxn2tX+qH7lhZ829HvIoPdDTigXfhlA+IEQUU1SHRSGrorzgzWgQS0ji9iYSl8/pU7MXlOApXAh9Bmslp4lm+ifJSeBCHXxAGIIH2sYTOw9sDzqng39kuJLSTbNWJ0M6Jw2k+EHgH
 O70jhPWe
 BcMe7ronfIdHfXqeMgiQZ13NvpP2mctj5qZ8j8SCKpZEOKEocrgQFlgOlkO6E52i518HLlOlsfrjQVHC3edvvfoRKYxG09uacY79020B8pQJAdBnFmopLN7OcePMsbo+7pp65KCqXpYa2fT8oi79oMjf31OkZt/DwerXvssv+KmMvBzIfIgIZ6E2Ac5hbJj1zSwXnAZZhelDr4TErYi2aM9bNgYAz6r3ETfkibw8JHBkYyxBMP6dHUyJesKLxPSUVbUBbyirBmC+905j9CIPZbChLOhPZrbJRb0XnCX1iB1t/qBkRmR7O+Plejg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In MGLRU, swappiness=200 favors anon reclaim, while swappiness=1
favors file reclaim. Swappiness=0 allows only file reclaim, while
swappiness=201 allows only anon reclaim. Thus, swappiness=1 and
swappiness=200 are counterparts for file and anon reclaim,
respectively.

Before this patchset, get_type_to_scan() always returned
LRU_GEN_ANON for swappiness=200 and LRU_GEN_FILE for swappiness=1.

For swappiness=200, file_factor is set to 0 at higher reclaim
priorities. Similarly, anon_factor is set to 0 for swappiness=1
at higher reclaim priorities, making the two settings behave
similarly, although the thresholds are slightly different.

This allows file pages to be reclaimed more aggressively and
benefits workloads that prioritize file reclaim by using
swappiness=1.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 81e81d69e67e..6d5a823667e0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5113,7 +5113,11 @@ static void lru_gen_balance_scan(struct lruvec *lruvec, struct scan_control *sc,
 	anon_weight = nr[LRU_GEN_ANON] + nr[LRU_GEN_FILE] / size_bias;
 	file_weight = nr[LRU_GEN_FILE] + nr[LRU_GEN_ANON] / size_bias;
 
-	anon_factor = (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_weight;
+	if (swappiness == MIN_SWAPPINESS + 1)
+		anon_factor = sc->priority <= DEF_PRIORITY / 2 ?
+			      refault_rate[LRU_GEN_FILE] * anon_weight : 0;
+	else
+		anon_factor = (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_weight;
 	if (swappiness == MAX_SWAPPINESS)
 		file_factor = sc->priority < DEF_PRIORITY / 2 ?
 			      refault_rate[LRU_GEN_ANON] * file_weight : 0;
-- 
2.34.1


