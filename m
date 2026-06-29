Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AEA6C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:43:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E05D6B00DE; Mon, 29 Jun 2026 10:42:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8681B6B00E3; Mon, 29 Jun 2026 10:42:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BBA56B00E5; Mon, 29 Jun 2026 10:42:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C20E6B00DE
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:42:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B1D011A0161
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:47 +0000 (UTC)
X-FDA: 84933216774.29.040C17F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2C3D1160011
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:42:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=djU1ICuD;
	spf=pass (imf08.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744166;
	b=6TIUGZ2hb0Y/bFA1SVGogTAD4rKHpBZbrTudh1zrZgWaWvuZ/FJzSJ1iNJ7fh3U++21/3v
	xhuRWptBeXY1H6BG8ZVUN1HtWctKU1rY5BiRn3Vl4L27YfhkveqgDBfEi4mXssggFiv3oz
	NY3DJN6UdwsvUIsPjG7FRDK/8oyfETE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bDMHXsCKcSGAHD12REN22mHVNiO24BTkjlbIOD6JWMU=;
	b=7XRNFqF1hYYuNuQ64FeCzUdKkO0R5QQEqoGBF73tvmFKqmCt+L3jIGUGkS+MpNQXPdCmG5
	tU+tCwVTpRdp/NXNVZtQDdZzKAjSJslfh4fhbRkW0zBH33kgIan48lod5cT3Q52Fx4jkah
	wOsiHi0JJAD+Fe/JwVmhGVzYQ9C9YfQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=djU1ICuD;
	spf=pass (imf08.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bDMHXsCKcSGAHD12REN22mHVNiO24BTkjlbIOD6JWMU=; b=djU1ICuDWaNku/q/mvPldJIRcu
	kqsTQLYQAyqYKFQfvsnmqqIuoPJZmPDzhw4XslxD7jPIT9F6ERLkxvY1azeYHOOfr/waNabo8JmAl
	oGM4f2fGX3bHIeIj06VAGQMHFTMwy49arrhdKI36w82eG3Sxso4AOnGh8QJDa3ySch3tcNvnJClmu
	5SpVeZ1ggbZjl4axu5wyDjUz/vUXoyjCTIhr55Wpzfn8KxXjmDKnKuEpoMOTKZSCrSkn+GvwtN2oy
	SjEP4aX2Ldyt4U7DhA/QB2bJE52kcpSyY8DhGhD/mhGfdtujhh36sbEb4S6kU+Uc2ZHvhcBUcuCq4
	A1o6w+6w==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weDC9-0000000EuaM-0I3G;
	Mon, 29 Jun 2026 14:42:45 +0000
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: [PATCH 08/18] maple_tree: Use prefetched value in mas_wr_store_type()
Date: Mon, 29 Jun 2026 10:41:35 -0400
Message-ID: <20260629144145.1572283-9-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629144145.1572283-1-liam@infradead.org>
References: <20260629144145.1572283-1-liam@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bintip3o6omoe433ja1ezyjmashepi95
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C3D1160011
X-Rspamd-Server: rspam02
X-HE-Tag: 1782744165-943384
X-HE-Meta: U2FsdGVkX1+DaG/MTtsnrcdIona4zLpQ6lf5op7e3QL8O1ISh8v8F0Oivhr4XaYQF6iK96kUGDEGdU9wA/msw480mcyCO00T0oCtX5PeRK2BSlNWRM6yL5GUe0X5Prld8vKWnk5iVkRYPQKjzM/oTzmdDgI+Y1rTa8uAXKpka6Tc5c1xnR4gTQaumuBreZLnOMMhARSRiROGEr78XI9Rpe0j5cyo2UcXESpm5eWiJJIH23Ub4U3MSGlCLrkaGj/yN/xEwt/nFL0KnnZc5KKLuap4K9r5qkDd5EMCZz81uK6VdwGPXC6hbldvfvxmqNY5SGkBDV4FsTRnovyDocOAOxyrrvrPHu0YC3zUZ3Iyd+R5vu+cuCAAajEANjM1qI4410Hv1xoivRukraL/itdpzbJul2MgUJHUf6saViqZ1kxVBgrulNfY3OSpO4wyWsmpkiiwS0Ev2WKskMcl2OlK5+NukFg/DuH31vSCrhJD6hf88rKQPGq3iA2VZOwiIjCwFuH0PGG/n1sHT9X2ZF8Ih9KdWksM2Y/aQyHIy+2oNKFZ99SA+3xDII4DmmfmSfU6tTaYUpl5Z93w4LuL+9oE+RWAF8jZbKz1rH9o6VpMrxYGd/FgcYjSmmX/Ip0vnOVUy3Zva5807m+JM1KrdqCqsFsNf97lilcrBTORBms7YchcoA/OxXEvMMnmE55lhD94ia+1g400Qs0O6YnlBFs/Zo96snKBppKA1wysTrfbW+UJxJFXUOzogIYtWJRqne2MaZn3lhpvAKh0kAxhtUfRi5V+wQ8GYiHMd8UDWPu+RwgopJE7c0cRvi0sRwweZAswPmZ8fqjXafNo8WRCA3vRfqlqSrncC9+J2Ol2GlhAIPxdXBwhMTfadrY+8/BoITmFxn+UWzLegIdSJ9ugusrj+9BEuyOmyViJHk0V63hEvX+ixQzJ8MuBBzNShbY02xvZAOj3dPFwnRmzdPJIRqa
 +htCW9OW
 ZgKYwASDGBXXRNh0z58uoGKec7HVOLDKkbp32+6EZO3og0gJUgygm0+adUyYProdWpRhlpk89vNtQ3AcPvB4v5rzoShCXb9vRtrTEQWDeIlMx6xb84JpNAoKc/360aqKqvqmZ8ZkNlw1/NaAcCyp2TH5EgXWkN/Cg6Tv6+j+2oaqV/t2Zo/6TaSBDHNqE0AZKDGrtYtElhxSMjeiwARHXZ1zhRMbZtOoscx201T5lDxqbK5JC/3fiH4ZgnBp6ub3C07vmACBOOIH3MQkzAQ1sUOWocRI/p4Dr1Z0pegyGnv/X+yqPJE6hpQ7xKma/YliTAuFCYdubScFjc50Ptq4nqbkNng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The slot contents exist in wr_mas->content, which has less overhead than
reading the slot again.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 8106eb8bf2eb6..fe10ff83e4937 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3276,7 +3276,7 @@ static inline void mas_wr_slot_store(struct ma_wr_state *wr_mas)
 	void __rcu **slots = wr_mas->slots;
 	bool gap = false;
 
-	gap |= !mt_slot_locked(mas->tree, slots, offset);
+	gap |= !wr_mas->content;
 	gap |= !mt_slot_locked(mas->tree, slots, offset + 1);
 
 	if (wr_mas->offset_end - offset == 1) {
-- 
2.47.3


