Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD1DBC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 598756B008C; Fri, 21 Aug 2026 15:26:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 548C46B00A4; Fri, 21 Aug 2026 15:26:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48AD46B008C; Fri, 21 Aug 2026 15:26:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14DE16B008C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:26:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 00F381C0DA4
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:26:50 +0000 (UTC)
X-FDA: 85126258980.30.215A29C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id E477BC000C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:26:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=nStR2H0A;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf22.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787340409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D4onz/HeLHxxoamf9Krig4BuT4qb4mm5o9pd3xPJqPk=;
	b=ESbAKfk4LrhWb3nj8xH5Pzv4E1XiCqHxFO1qsE9rRvFJIniKBK1Lvu5/2hf5/wfHiaXvHf
	JTPBdZ3XwcKBZe6R531UEjksOdytbkWIhuP2b9JxF4jelARUOwjo0lE76r6hDuLCg61hpC
	sRCUPh5rU74e5jXN7o9Fe6uWrpxwLxc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=nStR2H0A;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf22.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787340409;
	b=TgDUlUjqH0saLj9KHUWMVVF8GPIMTVbBK01k1Tuxw59O9+VUl3u2+oIcAW4HPBhquYSzlf
	CRo3SYL5ztY7UIDxzw72i9t5kziO6A/AFvh+CgowfuOIS95piOmnfiBE4o7Tfg6kqAgn3+
	qDNgQ/rVe38kb/qMtFpGHgX2SWBVNSE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=D4onz/HeLHxxoamf9Krig4BuT4qb4mm5o9pd3xPJqPk=; b=nStR2H0Ae1bs9Y6uxQZGKGdovU
	2zk9HtD4tM1Uve2MzmH4YBzWAHnnx2KBPOCN/rs3rQeuY6BgLA0oWmM4GYHby8+VLWZpWvr/7SZ+l
	3II6QraqCuOkNPgGqVXss2aoZl+IB1MSruhvHvNbRpUyNBa3YrQPlnmoUyAInqBPJL5IIz/jmKekV
	SpZNFW0L4yfvLYbWXM3gGqJ3jOQ8+cT4JiWJBy3odNcynL9ipcphjX4YewPT36nQe+B5NbFjgzRtB
	Jqm2lnwRkOqVyybv5k5PV8MjpRdFDx7pa2tu+5x2fAY/HnrDgv9GKmgZdMfC6RET2eAPfPx/dwc5X
	1+yJQKqw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wxUt5-0000000E0iX-3r8f;
	Fri, 21 Aug 2026 19:26:48 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH v3 05/19] maple_tree: Drop dead code from mas_extend_spanning_null()
Date: Fri, 21 Aug 2026 15:26:13 -0400
Message-ID: <20260821192627.4085470-6-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821192627.4085470-1-liam@infradead.org>
References: <20260821192627.4085470-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E477BC000C
X-Rspamd-Server: rspam07
X-Stat-Signature: ddnmt7chsweqpe8azfhbimiiqs79fm6i
X-HE-Tag: 1787340408-206279
X-HE-Meta: U2FsdGVkX1/MRA945LLDiFVUgD5aCj5pXPSrwgg+mWUC0RpwDCFOGt6lT7DePgMM2QZUBV3/YsmKfizHxtunc01yH2kj/VAsFLdT5/vOmoT04GTFrtIyaJRjFt6oMyhy6Ptj7GHGcxhEJZfu+H0XsbfPfingAIAi48/w+pUqouqu4wgkFXh8IfyeyGjZ6UIQsu9dpfwYF9XGlM9MEq0tuaG8LDz2FGT5rob5CEQBwAFimCFn3rcI5HoUF9FYOFPfwZxE28AVI3L93fvPFIN/uHUcg5dePF0lHFoe0D+gibVKB+JLB1onslA5xjU81US2MnYHnWnoxQVl4Lx7XsuskPHFKvVWzH508hb+shKcchBLxk1p+rYWJ9FNahcyR2whxk80aPsOqwufFzsecziyKqDmb2qvw7myGU+9fU/IIBHreKU1YJWLSIDYwqPIlWEQP3+a1yR2U4/Zyvh0Zi1Px4SJAX8uNPw5M8J0qdAkCJzkTIfmmnt3PgPL428z1l3mwjY6frJ5nBlsB5t8Y6QxLkMaeHiUP21sMdbRGisydV2K/x17kRNhzN1Sbka76iJeYUeJiIOScwJ6xuopLmKO9BpwfmZS2I6L7JPOlGAq+3Z6Fp5WGzTuMUBvlrKdzfAmZhEqvkz/I7CtOOm1L56i8Ez+RO2XzMs7DaD6DfCgkVk3dnebkSK+bEE33AguWR8LntLYddKsd6CoPG73VyS11HWBuHrWyUFbPvVIsg22m4fS/7HWiaDvNBUDSM9ojhZCjddEYa7OW2h8xI+XTac24jcU+wqxwQvWjMgRLv1Z7y3nk8jcXkUqWNrb6S3oTKNzN4wad27r9s08j7IJmzkCuGGtaA1hbyIhhXw9e5xskxSXqbA27bbJSgMpo0zNPQboBTKqeRcmdZpe5Cuf/5Px7jnHHMXyiDADcdAxdtbDu9cpSZPA7va/C0ABdDYGdgCy0BWobWAKkChq32FqpW2
 orRhciPK
 I5IzRxWtOHb/fQIoJrsaKNgGtv9LuMZx7IOvH0n4mO47YdnMXb6hqI5o7mALbVIoUw7pJ5lYWs/A1jQrbGtf98fxK4m4q878C2qfM+kO3G/dJwZI8M2wLCSEyjR8r1BTbD4jAWx34cmAQcv3Eh6y3+w6HEGy8CJjBGgEyfaVJg+Ko57aAwvHONZHYkZj/4hM9AMaYx2asCTC2Ed2ZuCG4ucCijQ+eShsOZCQiOl3umTjvmhlCJD7Qdk4aJiKnCsa1ch5NcTxGX1Tn2N4bG2A1mD14rYUGkiBtYf/hqyd5HmacwFRT9+Zv7oqtPxGAtpcmzFLsy/Y1xKBGmOc0DxUFNER+Vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mas_extend_spanning_null() had a clause if the end of the range being
written (mas->last) is the same as the end of the existing range it is
overwriting (wr_mas->r_max), action will be taken.

This code path is not possible because the only calling function
increments mas->last (unless it's ULONG_MAX) to walk to one beyond the
write and then resets the value back to the initial value.

In the case of mas->last == ULONG_MAX, then the second part of the
statement will always be false - mas->last cannot be less than the node
max.

This code never executed and is flawed anyways (the arguments are
incorrectly ordered), so removing it is the safest action.  Since the
code never executes, it is not fixing any issue so Fixes tag is not
given.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index d8c826e1ca0cf..3509e293c84f9 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2997,13 +2997,6 @@ static inline void mas_extend_spanning_null(struct ma_wr_state *l_wr_mas,
 		if (r_mas->last < r_wr_mas->r_max)
 			r_mas->last = r_wr_mas->r_max;
 		r_mas->offset++;
-	} else if ((r_mas->last == r_wr_mas->r_max) &&
-	    (r_mas->last < r_mas->max) &&
-	    !mas_slot_locked(r_mas, r_wr_mas->slots, r_mas->offset + 1)) {
-		r_mas->last = mas_safe_pivot(r_mas, r_wr_mas->pivots,
-					     r_wr_mas->type, r_mas->offset + 1);
-		r_mas->offset++;
-		r_wr_mas->r_max = r_mas->last;
 	}
 }
 
-- 
2.47.3


