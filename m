Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95165606A32E
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ifNf0Ij9
Received: by kanga.kvack.org (Postfix)
	id 63D8E6B05ED; Sat, 14 Nov 2026 15:09:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59FC76B05EE; Sat, 14 Nov 2026 15:09:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48F4C6B05EF; Sat, 14 Nov 2026 15:09:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1CA0F6B05ED
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:09:23 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A776080203
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:09:22 +0000 (UTC)
X-FDA: 85434814164.06.9C21A00
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 26C2DC0006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:09:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ifNf0Ij9;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686961;
	b=BeP13yWulJeLazf/cBO6ZjVqgKmi4TN1mmBjDr8NiqMF7jhBdJI+UOoLWJXxy0IUI6NWav
	/6Z/N5ncN5gs2c30DBXfQR4nhDYxB2gdErW52FDsf78VHLhaUeYtaYUiGRCly/ifKo4u24
	XDtbIlx/1FEn+gSudEdYefCcYpMuWJw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ifNf0Ij9;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ve/Ocmsy8HuxP+6kQzWQhSszhJgvBNDX8jcaj0nMCc4=;
	b=8fy+UDIlTE/WyE9rw5g4NgQ/hKGbvg3SVlEym3wJv0IYVAAurrkgUDg7dynWEiAQEFZKpa
	pzDjb9CnQh2NbouslBCSlEJLNSfYVwvAAbeDxWvEN8qmjuuTddF+pXfO6/sYXo7DDDUviH
	rllf+N3lvvbyGJD6WbcOUVOZXq/o680=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9DBB861449;
	Sat, 14 Nov 2026 20:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9701C1F000C8;
	Sat, 14 Nov 2026 20:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794686960;
	bh=Ve/Ocmsy8HuxP+6kQzWQhSszhJgvBNDX8jcaj0nMCc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ifNf0Ij9G0rdZ+eBepTpikC57OTdhoCg+3Pusbrg+dSA9yQXwPrto3i4ecV1bGtcd
	 ajqaOLFVukYhSlWLHmzOHNPwhdBjw+jx6I/yDQnHKXPt4hiJaZ3HRSLa99o/8wXup0
	 VdwuDDS0ZBz/nsLBID9XO5xAAcP/ZSzJ0giNFI10+1IgMdHLhVBk6gEhGKB9dkWlc5
	 XX+6jSPQirXonGLOrtej8ej8oYlksxj2E8DOei3UMD/DG2quZcTjzD1AaHLMYiB0nW
	 UWTdu9YJ7XLwB7phFNla16cFRGoHl415ZFQk4WZqsTFTelj2SrgAVR7z6Tou72m1mx
	 uxiPvm1EfljPA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	hui.zhu@linux.dev,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	liuxiang.277@bytedance.com,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	rppt@kernel.org,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	zhuhui@kylinos.cn,
	sidchintamaneni@gmail.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH v9 13/16] mm/mglru: Reduce LRU lock contention by shrinking folio batches in inc_min_seq
Date: Sun, 15 Nov 2026 04:08:00 +0800
Message-Id: <20261114200803.23129-14-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261114200803.23129-1-baohua@kernel.org>
References: <20261114200803.23129-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 26C2DC0006
X-Stat-Signature: 997ci44hnnz5bdypt6p1yzc8kjo4knk9
X-Rspam-User: 
X-HE-Tag: 1794686961-502564
X-HE-Meta: U2FsdGVkX1/MqWa6o7+9eVbCesTgox6zUlxXa0S4HXWTGj5Y/ZrdS7ksU8IIPEloSIoKG3w4AnlBafiLYSdB2aQ3GF/JdrFvqoyStJIkuMWaO9hXfU9M2MENtQzlm87oTqvAUBlxHF9hIg5pONE3olWwaN8r5YBSg7VOmx1JbDZHZ3XirpWlKsiVxPKo/muwlRhdvAm8YFf5+pff2LTyr0KNPAE5I6QBJggaw75zpyf+c2u3AKJG1yQ4w+cts+EL7A3eg/AFDmZwg4EOj2O6khSMGnuOGrola1E6h/tq2EdPhg8bq04C+TCctlbpzxSYcSA8fknNMnSE+/FtTTyKYyQddiCFiR2CbDByBP3ivaFteSjmVLj1iRoCAvnJ7u+lhQcccO97AWSuo+tU9zaC1OV7HAUcRwq2tUVJgqtaw2F/4Y4iJa7Dugl/Es0VWgq62iKe/5dUzVul23tAWGwv9/hXJoqfg4W07LAHTrDnMTVw82QzzOuOMI8CFgnyZX48qtddws5vaWLb+dIsMNy2XKdq/gXq0bOYfATO46oT3GbxCWlxgzIOzjwVIsrbSTD6J3oiIkmNFCQsXkE8rR1j0COlyVkps50cf75y+g00Gyl1q2Vyo6kvEqCr4Ej6nk5ihrnj8f2JeloO3bJ/hZlP9CIs/FQ1oKERTHnV1aAEaAvNkfN+N9SwnilwvjfmDcoih5VxDmB/fQWZWw8BkNY4SYIkVgb9hsdtxUwnWc0XCVdNfdkYb++g8C/rP2RXMBPQIJJH+VP7RJR43cqai232ZFtK0VsvOQEs2zHqHQEnh4NPPF9oJgDssuiRM6O7hrwVuSMJLuA9cfWayVgxMg6prYTaF4ccgWx0TpcJcT4oa3reaSAwJSR8YvAscKQmFWbMQJybAwvwKZhL6e857ewkYIhUXxKKEfJeu9vKAaWOXj3xgdLUPotaiMd4RMMvhySVFNVeLThox+5tvx/WGhw
 cjYVhoHo
 cs2r4EwrTASYGG3aXXol4HUC7if8jVTKDQSfQhyqGuRqSUOzNiV0OeYi2ybnR4cY5NsV4JZ7mC2nFJPWE0b6nnM2/vL3grh+F+Z9njep6AlqSKgdusl4XEmyBhHp7myfMAnh73GdVZX+vsOV/UGjBmdmF3ORd7+x7CzhLiCUsK/ebKI8XnP0rfzlCH3Ct/ppYGbg95eEhNoUZdbgOkxV9fIQG2F7QBaoaktd3g3VVBC7GK1YZf8mp3LLQVMKOw/51GXiIlP3j/XAGW4lifO2hlpY3vRjC0GyoJ2fqp6JIlXFheZ/Fwh/5gKuCLB4gVcHYFjMpII/2r1XjCUOQTnSARVCsJhL+SOQaqKNQZpZAU4KJtmk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reduce the number of folios moved from the oldest generation to the
second-oldest generation in each batch. This shortens the time the
lruvec lock is held, allowing concurrent LRU operations to make
progress and significantly reducing LRU lock contention.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c9e22a5cbb51..6cb905162cba 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3914,7 +3914,7 @@ static inline void flush_lru_batch(struct list_head *head, struct list_head **ba
 static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 {
 	int zone;
-	int remaining = MAX_LRU_BATCH;
+	int remaining = MIN_LRU_BATCH;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	int hist = lru_hist_from_seq(lrugen->min_seq[type]);
 	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
-- 
2.39.3 (Apple Git-146)


