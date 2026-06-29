Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9990C43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:43:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 890F46B00E5; Mon, 29 Jun 2026 10:42:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 841AF6B00E8; Mon, 29 Jun 2026 10:42:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 757D66B00E9; Mon, 29 Jun 2026 10:42:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 498DE6B00E5
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:42:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C961E1A014D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:50 +0000 (UTC)
X-FDA: 84933216900.15.96639AB
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf11.hostedemail.com (Postfix) with ESMTP id 413F24000B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=euhmC69L;
	spf=pass (imf11.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744169;
	b=QHpzWuCO82TbxvXAdWCG207D+lqcPuke31iy6ypAvVoW45N74tcugRepITT9znYIzZHxO6
	CzCMLiAt9J0su3VYdLpBFGRC+n/JAwRjksWIVW8ixAVvoSzh19YIVkJnzuh2atweAjYqCj
	Wsf3Srzj9V+6Yge1blDdu63ptKSR7Vg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wl7SCHrPlo6N/ym8KPSSIcP6adc/9JLwa19T/UO77JQ=;
	b=QVYfSS3SrtK63bL6hEZlb7s2FVt2rMAdEmm7a83Iu9k1xDk3mqtmeTJvq6dLginIQsV72Q
	SGQsi2eiQEN1+2xLBJmRMjdpl7XkdIYZlMX4c/BAFieDzw4sxPfwsbqqHMW26oStFEXS7l
	+JBXoAztOzxiC33ynos5UPzrDypOMWI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=euhmC69L;
	spf=pass (imf11.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wl7SCHrPlo6N/ym8KPSSIcP6adc/9JLwa19T/UO77JQ=; b=euhmC69LbGhU9Dgd9AsPghPJN1
	ebN6+NCHh2bzNlWJ78vv26FfpQw39H1ZmoWHhbtKq2ShvkbvqD6cVK5pSzzPitfB9on8/JhTco24+
	8uCmsiVON3l7fl15B2hhzU0i1q1bDfonnfDUAnbeQWUPvt1Rjw4zZkYT18lraKuL/s70pmRV3N/tQ
	scD8zbixPsPQZa8aa9vF5w7kPIACZr/wmOPOQUJxtg0IEmpl2dLS7cza9VK+G1ejB1D/X2a/8mep/
	NwmenVnrgmeUgJCg6QDHSTNVMNKi1nBQvJjz5tdsl2eIvvun5q8Qd5P5d92pJUzDSro9kztBEwdAx
	4ogi5WWA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weDCC-0000000EubZ-0mxD;
	Mon, 29 Jun 2026 14:42:48 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH 10/18] maple_tree: micro optimisation of mas_wr_store_type()
Date: Mon, 29 Jun 2026 10:41:37 -0400
Message-ID: <20260629144145.1572283-11-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629144145.1572283-1-liam@infradead.org>
References: <20260629144145.1572283-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ceyztonfw5ya1oaoqs4w1bz9er85bqmx
X-Rspamd-Queue-Id: 413F24000B
X-Rspamd-Server: rspam06
X-HE-Tag: 1782744169-610223
X-HE-Meta: U2FsdGVkX1/plTTXxCzDFufEVTzfTTMCyKuXQWlC469vxtwL490GrGxtpxaaokoBlxl2S3R+y1JAf4P4FZkDxkhXhpoYXQVua8vHAI9j3Atnn3sSWSxChnEJRj9RLi8lMbIgdLJkl7U2RUj7h1xO+4Ntfzk+zAjtuZa7OyzWocSfaK11ySW3czX7k7ie5lQNpa2E2tChCMVHh8sl5TUsukWEx53RDeqfOelqUWNEUKpLkdog+tmASVaF1eSYmG1RvXT8W1FtDyER2nk9BtKi1sUQXMEFj68kpKN4ZxukSSTYlAWczUpkDW7dZcgoLOIrjslCRydJbyAq8vweak+Bi978QUFx/xTHeeC7ITvtyfJfmxUcCakPe9MOVH1VIKmKZsEwDWAku9x4HclOW7zPdLbDot1BCGxwIXbU8YPD+N4wC5rpqsINXiFAzQgCVwt3ijewD8qtPYfOCrkRXCHM1o6kyjbZvVr4Bs3q7CBiR6uG8iEIeGvZqrkCQHyol0qSzmehJaMt0c9ZJgdovQ078KJrHDelucAML7FgXcgSZY+lawDPkv6OXaTIkOuGoN9XVDqw47JfJKe6J3tQL0Emdr+A1n47hrG2lA/Jn4Jet10xFWAgWzFN8C5pMzrosH2kAAg6ilUs9oIz/IE8rCM475gyPEySu4PuSsdEDpWWLoaL/FWU7QsrhBFJYYsc2rRMtDPbwamJrQkAsVEbZSROGbkwc7EVx/FYkrsctQsImTaw+TVY3aQSGTH1Hi92IHU6wRmxN8bRAGApi4o7fxAHCHvK1xEWcvEiJjM93ykGqGm5zQoo25/B7OQORGXCbdEbsjws1oxI3Ex5RL5wv7gP8C/rvsXj56mG4PfMddLeJebnPHrkZAqyJYVEYXvHywewhTQG1eV7uZKES+gA0ZH/7Yj4EEzc4csJ2m7JvHE+21URO69+fqYHfkAiRkcaAIYHFSFTVsGp7aU4jsF9bUS
 KYjA8DCo
 qyd0hv/egiGm9UN1aMd+hyo52tQAHkeUlUUkMhBQyqSZ0n4fwx10yndb3MaajcKaC874hOc+GsYvSrsVOshJFDNq5aptlBgPSAv988n/8DDD/ndjxRGJiXb/hnXaMzML93ZzKeUD3IuLEOZ2+la8REKjRTVMxoBoQGhIpPByvxytwrb65uxLK+M9b10y5b0dgbTSOI5lGvYQsp39QMYZQ0sOFEPOyeiVQZWl+RrrQ8NL+Erd8UuxY6HgAwwSPZ1BDGz05vTRUia0cNFJRmFRMQLRB1oCtgA7fw81NexIqm2o2G23BKBTwqLHtAOefRIQkbZl9gz+yyRUpf1pZ+G09s0cuCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use three new local booleans instead of reading other structures.  This
has shown an increase of 0.62% on a 2048 entry tree of height 4.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index a2b96ef05cb32..dd679ba2b8bfa 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3729,6 +3729,9 @@ static inline enum store_type mas_wr_store_type(struct ma_wr_state *wr_mas)
 {
 	struct ma_state *mas = wr_mas->mas;
 	unsigned char new_end;
+	bool appending;
+	bool one_slot;
+	bool in_rcu;
 
 	if (unlikely(mas_is_none(mas) || mas_is_ptr(mas)))
 		return wr_store_root;
@@ -3748,21 +3751,30 @@ static inline enum store_type mas_wr_store_type(struct ma_wr_state *wr_mas)
 		return wr_new_root;
 
 	new_end = mas_wr_new_end(wr_mas);
+	in_rcu = mt_in_rcu(mas->tree);
+	appending = mas->offset == mas->end;
+	one_slot = wr_mas->offset_end - mas->offset == 1;
+
 	/* Potential spanning rebalance collapsing a node */
 	if (new_end < mt_min_slots[wr_mas->type]) {
 		if (!mte_is_root(mas->node))
 			return  wr_rebalance;
+		if (!in_rcu) {
+			if (appending)
+				return wr_append;
+			else if (mas->end == new_end && one_slot)
+				return wr_slot_store;
+		}
 		return wr_node_store;
 	}
 
 	if (new_end >= mt_slots[wr_mas->type])
 		return wr_split_store;
 
-	if (!mt_in_rcu(mas->tree) && (mas->offset == mas->end))
+	if (!in_rcu && appending)
 		return wr_append;
 
-	if ((new_end == mas->end) && (!mt_in_rcu(mas->tree) ||
-		(wr_mas->offset_end - mas->offset == 1)))
+	if (new_end == mas->end && (!in_rcu || one_slot))
 		return wr_slot_store;
 
 	return wr_node_store;
-- 
2.47.3


