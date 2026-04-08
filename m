Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2F391073CB6
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 13:33:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBE276B0088; Wed,  8 Apr 2026 09:33:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6FB56B0089; Wed,  8 Apr 2026 09:33:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D856A6B008A; Wed,  8 Apr 2026 09:33:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C37B26B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 09:33:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4DE98140132
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:33:42 +0000 (UTC)
X-FDA: 84635481084.05.998D381
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8E75F100016
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:33:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=B6CgjiPE;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf05.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775655220; a=rsa-sha256;
	cv=none;
	b=OZPly4CudbBAzH+LUXywgGastHNG7xK+FEhNikE0qhd/N63mPmVn04TweUYcsTJqsadDDV
	mX52iHUTHgh+bsXqppHR34kgXEPT4xy6H9/9RGeKhtwfD28IcIm5OP5CdFlxb4hAFvohSq
	VL5PI7cCoU4oRK2J7RfaMu4mTmbOYPw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=B6CgjiPE;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf05.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775655220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zCLRAjuTrAQTizeHsvvcGO1levRtnCTOyZrIbtMQ40A=;
	b=VVeZSWuXWkLKX5ov31orKM49/OGyxAXHR6qhMmqLDSzAOI+/yv2tkN+UQg6Q1jirJasCE8
	nRSgo+YsLgKaf+4VdyeVw8D7jZrmUdAXpiYJA5uDK2Dc9mnjeKsYTvQNQiZjZm713z/bVy
	SZialzFSdk1KSKoH+9cUfJN5njnhg1U=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id DFA7EBE70F;
	Wed, 08 Apr 2026 13:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1775655219;
	bh=zCLRAjuTrAQTizeHsvvcGO1levRtnCTOyZrIbtMQ40A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B6CgjiPEf0oUY+HcHI1TGUkeqsMFfR+z6iwLuuCNGT6xWUh1mPNDAFsbKgfc0z8g0
	 kctIIZ/mwbnFCIccEJAX9CCMrtczS5vOUz6mniz4QA7JS/H2zTg35B1na/ftX1vy0G
	 BRILKsctNBtNAGDKC44EVtNjzejbgY2r8DJxRNIg=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [RESEND PATCH v2 1/8] mm: use zone lock guard in reserve_highatomic_pageblock()
Date: Wed,  8 Apr 2026 13:33:16 +0000
Message-ID: <9423598fd4f5664c72c0e030efaef2ac5ceae978.1775654118.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775654118.git.d@ilvokhin.com>
References: <cover.1775654118.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kt4347dghujenkck9a3zqrs719x876zq
X-Rspamd-Queue-Id: 8E75F100016
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775655220-423380
X-HE-Meta: U2FsdGVkX19eNkj5hQWsWg8W0Cq9EUQUOBnCqeZNX0eloTvUUvPWbG5QGmK1yvLsb8p8RENfByUFxQrMKt3B0zC+1ftD3Y561zw88N2wzbz3TNLaZLVUciwwP33riDA6MMJW85dUiQhkizgrNMsGa5fTEZxUybCYLljMzsEfB73MxPe1xq3fBc11wF0O6XyF3e5JzHh2s8yglr5iA+OPv66UKbL2bX/S683hX5WNCgQY16oe1V9RqbMDHHApxtbF2MTAlJvlzB1XHZOxm4RmLldxIqxeCkZc/qgB1nigWLaQKfJaaox1evEFMOYqbYylH8xxhOj2ZX4VaW7JVvezinJFltqZrgskPVONwOli8FNceYgcbpVMDR2itLetuSHVYr80wMAu7vqJ2MbSO3DJn8kP35/kBJW2cvll+za0DH6Oees9/a4JWUzfPzBhb/7rp+qAxcAziYD+oKihkJ5ALlVyWczMIotuaaAjGcdTDXLxYnccd0QoLY8v1K6EjQ3LTAF5S/Dr7Ed5qnK4KDzzQZKXZj1HCGsasV7tOweDe9vU3/7y/YPdxOoM2dDJOq6CwhydQfVjWBAG2gox9miPemNJBqBFNQM0cNUBsRze6w8yznjREqpKAthhAjRKA/pAx7Xyg4WgYAtc1HdL8WYLMIk4FhMy83wjkShvvbG0lYmDNFQOIkz9tDKAp58V6FqPWjauSen6zWE/MtyDl2ZffwPQCx0XmB4vKiLeQrsCdwUaoCxTwj7tiVTFMW46XyQxoNwlN3nVFaZg/oLnCygOmZPPUN71bNotPm5PqWnyXqoteKOvCA1QjHq1K0Vvcw93W8JoP6Ur5GtmkBfygs9lKxKPlsj3Vl4+/+HYmi8EORdsKK6DCZX6JBoPv/yXJREJD/eTjnQHks0Aa4m93qmMieQ6CQDRWjfHdz+D4HY0brfyGtD44Foti2ugwjuhVTlG0dvBhuiKDoo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the spinlock_irqsave zone lock guard in
reserve_highatomic_pageblock() to replace the explicit lock/unlock and
goto out_unlock pattern with automatic scope-based cleanup.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 mm/page_alloc.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 111b54df8a3c..3a4523c35fb6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3431,7 +3431,7 @@ static void reserve_highatomic_pageblock(struct page *page, int order,
 					 struct zone *zone)
 {
 	int mt;
-	unsigned long max_managed, flags;
+	unsigned long max_managed;
 
 	/*
 	 * The number reserved as: minimum is 1 pageblock, maximum is
@@ -3445,29 +3445,26 @@ static void reserve_highatomic_pageblock(struct page *page, int order,
 	if (zone->nr_reserved_highatomic >= max_managed)
 		return;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	guard(spinlock_irqsave)(&zone->lock);
 
 	/* Recheck the nr_reserved_highatomic limit under the lock */
 	if (zone->nr_reserved_highatomic >= max_managed)
-		goto out_unlock;
+		return;
 
 	/* Yoink! */
 	mt = get_pageblock_migratetype(page);
 	/* Only reserve normal pageblocks (i.e., they can merge with others) */
 	if (!migratetype_is_mergeable(mt))
-		goto out_unlock;
+		return;
 
 	if (order < pageblock_order) {
 		if (move_freepages_block(zone, page, mt, MIGRATE_HIGHATOMIC) == -1)
-			goto out_unlock;
+			return;
 		zone->nr_reserved_highatomic += pageblock_nr_pages;
 	} else {
 		change_pageblock_range(page, order, MIGRATE_HIGHATOMIC);
 		zone->nr_reserved_highatomic += 1 << order;
 	}
-
-out_unlock:
-	spin_unlock_irqrestore(&zone->lock, flags);
 }
 
 /*
-- 
2.52.0


