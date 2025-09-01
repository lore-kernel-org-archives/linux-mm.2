Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31F75CA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 11:09:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D1B08E003F; Mon,  1 Sep 2025 07:09:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 882D88E003B; Mon,  1 Sep 2025 07:09:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74A948E003F; Mon,  1 Sep 2025 07:09:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5EAF48E003B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:09:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ED6521607D7
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:09:28 +0000 (UTC)
X-FDA: 83840410416.06.FBD5A63
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id C1EFA180006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:09:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zKTz6Lov;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TTbyuHqB;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zKTz6Lov;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TTbyuHqB;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756724967; a=rsa-sha256;
	cv=none;
	b=hI6+vtaAmHs2/EDmZVorE1dOxMYBwAY9Gw23mLXNhDqPAFqPQTZVhF8lstqB7+krAFYUyM
	K9n+gIv7EWc7tsJw+xBzKWIbUB+V89C3DvFBAfqMxkxvIa5oELWyC2gLPU3Fb7SfAp1qsk
	Va9Vc0fC8teqcHAp7F/nFV/dtzGvG+Y=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zKTz6Lov;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TTbyuHqB;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zKTz6Lov;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TTbyuHqB;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756724967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Orc9L8mxDfBM2P4Cd87ufTnmwdvv431SxJfeIHzvdf8=;
	b=huN/A6n6LGQy1IHlkrZVgfeTx4sT2BSLWSP31wK3MoCKE43OzR6uFKhDbLc64WiCNiLQQu
	HB+R6BbqAY4IKGsOACtt2daIM0MRFOXTQXTWUOw3r63HnHBiP848Z+f5F7QZ9paCGeNDaN
	JWZTE/y1AMkK3QCZDQkXsUW6ud90DNk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C29D62117A;
	Mon,  1 Sep 2025 11:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756724933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Orc9L8mxDfBM2P4Cd87ufTnmwdvv431SxJfeIHzvdf8=;
	b=zKTz6Lovr5q/xB/OgJ4lFP4VG791nn9WUZ4LQIxwfrfi3FJ5eKFvtpckPEMVHyiJlozJJ0
	NEr7AAQbfKzzLmTRGT91+4KNRXV/iIVPYlKGqBGBgC6Qy0G2bPvAYN06KOI45+UTIBCGjb
	2O2qZkYl4FlRzIW0t0dVuzSaZGCdzYQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756724933;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Orc9L8mxDfBM2P4Cd87ufTnmwdvv431SxJfeIHzvdf8=;
	b=TTbyuHqBOtS89J5z/MDvzGrGoZgGM8awDt34B0yPMv3zPVL5OtplAWc6UYFAmuFtfwS7OV
	jGC0Ri+QQEJul+CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756724933; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Orc9L8mxDfBM2P4Cd87ufTnmwdvv431SxJfeIHzvdf8=;
	b=zKTz6Lovr5q/xB/OgJ4lFP4VG791nn9WUZ4LQIxwfrfi3FJ5eKFvtpckPEMVHyiJlozJJ0
	NEr7AAQbfKzzLmTRGT91+4KNRXV/iIVPYlKGqBGBgC6Qy0G2bPvAYN06KOI45+UTIBCGjb
	2O2qZkYl4FlRzIW0t0dVuzSaZGCdzYQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756724933;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Orc9L8mxDfBM2P4Cd87ufTnmwdvv431SxJfeIHzvdf8=;
	b=TTbyuHqBOtS89J5z/MDvzGrGoZgGM8awDt34B0yPMv3zPVL5OtplAWc6UYFAmuFtfwS7OV
	jGC0Ri+QQEJul+CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ACCE113A7C;
	Mon,  1 Sep 2025 11:08:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2JzeKcV+tWjtDgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 01 Sep 2025 11:08:53 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 01 Sep 2025 13:08:58 +0200
Subject: [PATCH 08/12] maple_tree: Replace mt_free_one() with kfree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250901-maple-sheaves-v1-8-d6a1166b53f2@suse.cz>
References: <20250901-maple-sheaves-v1-0-d6a1166b53f2@suse.cz>
In-Reply-To: <20250901-maple-sheaves-v1-0-d6a1166b53f2@suse.cz>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Matthew Wilcox <willy@infradead.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, 
 Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org, 
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.2
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: C1EFA180006
X-Stat-Signature: oy75f6mrxx1tjxzfbmicajxq3mepfi33
X-HE-Tag: 1756724966-811572
X-HE-Meta: U2FsdGVkX1/jZ2nyC/GmAW4W/fNeqL/yTldpnOmvxMA41+NJUNQBA0OTyF0JyR8KAiwpjahNegVcjybQ99hfyJQZbiSqorkelFTqFIi86adonS/l+nx0KLVNTxtya8JCJxS9ZKw4643y2xgEAUrxIUm87GEaQLjo0j6LSVHe1yTgtNc2xrUwz90qy2o7+iLMPO85BPT4SYLqZIiUVTQvrIHwjYilWXuaKknrPhpS1UFZYkjJwqOXEwBl40wGqval+P1D/pAGNMwElkX12B/oImkRF5shSoT3ABoqr3qrjDYGpO6ZLBcPhXeGYOSwkD6uMB/TKE2coIIHSrBxQtDVuK0fEqOEpTGalOLf0GETbq7kZ/H+utExhLdm2VDDam8yQxo0X4Uzwgk9Z3FJMHd3NU8MC+7a0CF/gaxGXFzQI/j3T69lE7aOrezst20huFl0WQLpmuldYo+qneyoiawAT0n1cRY1vdFK25oB1V9tPqtIkkc27bZmHgH55xnBrsKKEC4jLYJ3f5AgWoeUUkgnfGjGdtaPtM4HH1pjfVL+aGnVXElAidpuUn9nik8M9zvzQQ2HL98bxI1e9TI2arcnK5WQ509u52vUqOTBvhE0JI7yzEWCFwB2JGlOtWfnUtAlUX9jfNVNDhnKZ+KMz3+F+7rQJZWa9l+A6VwJSLu5F03npDJYNahnV8ggXgFwSwmvDEzkiJ/oEnj6ej8wHlxBmDppSmS4NctK2A2S0WYSub/jXYK1ZtkNUAfMHCkfiIz28gCT2Ht2ntefsL3UKE7njVNA9NxEmhdSzOQYrip/YkW/PXcUjKThf9zkORN/md77Yc/PuSvzfNVVHmLlbyKxRs2eAOtqgYn5n7KdzAZB7PbkHWgZYLV6gFAUm/6RyIMozQ5aUyUVCBP/zbNfR979Mak8oMJ1t6hqxXASGSqkrrLvDmMHLhPISRHlSrsLkTfH1EyTuqFFWRQKMym2+Q9
 B8a/f/7H
 /mXNcB8qYHd1xKQOt92APwk6WuR/jJrE3lHJlFfBAVU8mnhIcqdQkmFHh/4uzMy3CLw7EUcmOxY1e4d5ZK4IVKcD2SqGpi6cEug+oxDMN9Ym7DlnISMfZfCu3McLe1o6n6MpqbZQ3vX6wEpy+EK7C5B5hi3QXBI+QXa2mNZCXJ9V2+50XYN3FU7FFy9JQxP6JvHvlkGOV+Lu25eZtCZSPuYEFFk2+5COJL13Qnil+UjzWYyPbTOMH4gO/qKbaernha0iD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pedro Falcato <pfalcato@suse.de>

kfree() is a little shorter and works with kmem_cache_alloc'd pointers
too. Also lets us remove one more helper.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 lib/maple_tree.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index d77e82362f03905040ac61630f92fe9af1e59f98..b361b484cfcaacd99472dd4c2b8de9260b307425 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -181,11 +181,6 @@ static inline int mt_alloc_bulk(gfp_t gfp, size_t size, void **nodes)
 	return kmem_cache_alloc_bulk(maple_node_cache, gfp, size, nodes);
 }
 
-static inline void mt_free_one(struct maple_node *node)
-{
-	kmem_cache_free(maple_node_cache, node);
-}
-
 static inline void mt_free_bulk(size_t size, void __rcu **nodes)
 {
 	kmem_cache_free_bulk(maple_node_cache, size, (void **)nodes);
@@ -5274,7 +5269,7 @@ static void mt_free_walk(struct rcu_head *head)
 	mt_free_bulk(node->slot_len, slots);
 
 free_leaf:
-	mt_free_one(node);
+	kfree(node);
 }
 
 static inline void __rcu **mte_destroy_descend(struct maple_enode **enode,
@@ -5358,7 +5353,7 @@ static void mt_destroy_walk(struct maple_enode *enode, struct maple_tree *mt,
 
 free_leaf:
 	if (free)
-		mt_free_one(node);
+		kfree(node);
 	else
 		mt_clear_meta(mt, node, node->type);
 }
@@ -5585,7 +5580,7 @@ void mas_destroy(struct ma_state *mas)
 			mt_free_bulk(count, (void __rcu **)&node->slot[1]);
 			total -= count;
 		}
-		mt_free_one(ma_mnode_ptr(node));
+		kfree(ma_mnode_ptr(node));
 		total--;
 	}
 
@@ -6635,7 +6630,7 @@ static void mas_dup_free(struct ma_state *mas)
 	}
 
 	node = mte_to_node(mas->node);
-	mt_free_one(node);
+	kfree(node);
 }
 
 /*

-- 
2.51.0


