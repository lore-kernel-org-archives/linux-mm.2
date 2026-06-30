Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C35FC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 19:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DAB96B00BA; Tue, 30 Jun 2026 15:09:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28AFB6B00BB; Tue, 30 Jun 2026 15:09:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B7006B00BC; Tue, 30 Jun 2026 15:09:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D6BE46B00BA
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:09:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 60DCE1C3761
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:09:20 +0000 (UTC)
X-FDA: 84937517280.29.D9FE5AF
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id D69A316000A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:09:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=TDnbvz3l;
	spf=pass (imf08.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782846558;
	b=fk9Bofm54te/nMycRYNTxPV/p8DGI0c8Lhj7tna1OGEp5yOMKuOXlDoiCSvX71lnfUcW4U
	9WSIS7DuwiUlyuqjMvvrhJzwLFKJmjsBJh1l3JK1Rn4M+Ako9hjSbt4ueIQwzlQx9M/hZH
	TySCR2LKYojJQOkmPHbH/R6AWnCAncI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782846558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d19P2mU7bCvxpx2bi3qQUglg6+PsjCRE3aXSYueMTuY=;
	b=0Eia0Dai+MjzEY1ZmoUaKXUFgP1vG+PyWxqQgg+KTbct7YekZy1tx3sk3LqgeXIXh8yTNr
	u0XtWdu3fVRpmCQEN6WFWq1pPlBOPx6ZHJ7l0EZQo/4cSaEwf3+oZTkGao8lDRdQkPu8dy
	wGpKPVOSOZrC9tXdwwyeQRK88FW5cg0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=TDnbvz3l;
	spf=pass (imf08.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=d19P2mU7bCvxpx2bi3qQUglg6+PsjCRE3aXSYueMTuY=; b=TDnbvz3lB9rgMKLOweJ4/5AWrN
	ZQ3ySzjIr86ANtcbD8o/A+//JOAfJSLJePZ2DTDtH3dCOq8KltSnH3QxSYdFuUgpa+5l9rUBvgXLW
	nNCIp0JlVJXozib/JLi6vXzoMHX3Oe3luwWv+Ivr7i/JmNPMZJKwXE0i03f37GO5lB1hAqM59ib43
	v235GPOlwRSoRErFNkOJXOVFbgKwjsTM4gV/+O/gX/OO7E6pmolXG4vWV4z9Lw7heMMHf3r9CKWQc
	LDGpqdIWf3cC9dzh8mT6pTEsmn5fesbikNIOtQHyigYEs978VdD/ImE8QjFB2E6uTKmdGx7NBd4Em
	JJk74/Kg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wedpd-00000000620-1k5d;
	Tue, 30 Jun 2026 19:09:17 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH v2 17/19] maple_tree: Fix argument name in header
Date: Tue, 30 Jun 2026 15:08:41 -0400
Message-ID: <20260630190843.3563858-18-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630190843.3563858-1-liam@infradead.org>
References: <20260630190843.3563858-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D69A316000A
X-Stat-Signature: dmc7h83zt6fxfje1utxmhbw5nwx8ehdq
X-HE-Tag: 1782846558-809903
X-HE-Meta: U2FsdGVkX19pbmE4zz2qkK5QpdBvpESAlgXlXyXDMuJEuh9PG7gB/orTJ7o8nfZxDM/EMCYhmDz8gRbRNFO1DWfKF8YvUy71FQhGOBlvIgc4Wt7jrl5+DL1pgvsq65yKSUhQr7cSe7flRmCQqGqmjPaeCYgs5+Hzo0giTHrSoDdVlsacJ68RgSBo/bsCQjIVl7Hyib2iu/IUWDJHvXsN92yoWraeLiYMu4m3XlPjmcCi7qRefMcZGYS+A8ZT24AxPorrvhpHFADSYgnVgkeowlSfmAXxy2hjMmWN+Y+y6R3gKeVVaW3k7Gs7clui6Up8BrgA1MQKlPiSMT7We62keTk0fro881ObHsA3khuB57suSThi6rWOwGnzJFat/H0iIEBzW9bIdJWVwhRNWwlToVzUrd8pB8P9eqCvWtghxC1dSchGEUcVAlKeUcpifRzWKfwXIRnl+LTMsE4lHjpsM+UUHjSKz0fiO/k6PAcS/TYKTDhYqUjuw+xsVk+FnSLVfmX9CC9VgPLccnCX21yrwLU7RuPCQzRwuRbQ/30Pt2L96L15kPWflrd+QXmIGB8+TIsPMXUeMf4y1LyRl7hD6Cc+3wWKxATixXlx6lNqn+aBxTGLlQ+HdMiynroE5+ZPW1+X08cM+DqDQhYqqnQpyICdzVActdHQJSG8tr1UiWDVgKfNR7qyB7i+nuKXUa25kr2wsXALF+57+/UVHSrpSuRo0HM+KLPslcp+tUq6ei6x+USQkEbzGlq91WHnbKFpPJYavQz4IQreD2s4uOsxXOGhgAT3KSgXBvD0U+Ruz0POdvv1ROVD/ly2jFTWXmZzNNVWcOh0wiEU0AbVRjWy5MD/QObAdJVtxq7AYALR1KeMpzUw55X/MT0oqfz0GXn6eHt/7Toezif4Vn9clr9CP3G1ejMXByQZZZTD0E7jwvuQnPA0N3Neph7BTLH8Dosk/jVIzdgUETPX4XEdlJ6
 b1MojblT
 NoLJzOGL6HD6hN+KgN9CcWC3BNaiyRHcQSzE2l1YGSUo4M2LuBRvc0y1IVxZwrNVxxeR+xPpyU+QjFoP11JQ9lFMHG8cDm6rpWoLbDBQr4xN7xWP/PefhvjcBt7mFBTJP6TSrohZRJQQIQKPyervC1s50N/G8xigsu46eOWGFY6f3xU7KkbQ+GYEsl9povA6S2h0GpdbOnBIWEke1GHljmjC/4zJ+KEqiVLWI4kciOPQWCPWrA32pPR5ul06bk+8gf5oklwEwA8wdaU9cZSa7wvmLejlcCTLzvpFCqMYd3VCTpHX4ft549EbvoNwgi8O9psHh8l7uheqhAEgAkb5X5cxTZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mas_prev_range() function takes a min and not a max.

Fixes: 6b9e93e010204 ("maple_tree: add mas_prev_range() and mas_find_range_rev interface")
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 include/linux/maple_tree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 346eae48cf15e..5e0bd2857d941 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -576,7 +576,7 @@ void maple_tree_init(void);
 void mas_destroy(struct ma_state *mas);
 
 void *mas_prev(struct ma_state *mas, unsigned long min);
-void *mas_prev_range(struct ma_state *mas, unsigned long max);
+void *mas_prev_range(struct ma_state *mas, unsigned long min);
 void *mas_next(struct ma_state *mas, unsigned long max);
 void *mas_next_range(struct ma_state *mas, unsigned long max);
 
-- 
2.47.3


