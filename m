Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 083F3CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 08:02:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 624EE8E0021; Wed, 10 Sep 2025 04:02:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D4568E001A; Wed, 10 Sep 2025 04:02:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49C998E0021; Wed, 10 Sep 2025 04:02:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37AC48E001A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:02:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F14A186C66
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:02:17 +0000 (UTC)
X-FDA: 83872597914.07.E715E4C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id B9F2212000D
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:02:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="XH1P/pCm";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=96GHuDHG;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="XH1P/pCm";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=96GHuDHG;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757491336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=suObi2/GY4gIdOy8/pJdudh4YHfdoLo9Lt+1E266qUA=;
	b=s7fToN4gw+Cdy0bcoGGOkF3EXeW2o+A0Jg/iXaeEHsvVp2t9pQqFo9olUuhLP0OhQI4Byn
	q7gAeK3UFvFGV1hSfy0ZWOMOykOTY1SOW+AhTeGraK9RrxV+fZFgOjRXItCRkdzilsxrqG
	XeI1KKHvafjsDkBda9Gs2BkRofqE4Wk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757491336; a=rsa-sha256;
	cv=none;
	b=XWoDw7cwxFo1FAV3cVl1ifmRlFXsEdSZCxpAVx7bRDHJKPQF5firqWn2tcPh7GwhgVfC9y
	xNCFdjcnxRielg+ifIQ5Podopl8xhJl4I9k670aWm2UCFLvgKeRqUUT0HxSLarRejmrUu1
	cz1++DKXgakBeV/oMBJT459ZzwaxqUY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="XH1P/pCm";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=96GHuDHG;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="XH1P/pCm";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=96GHuDHG;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 65D705CB7F;
	Wed, 10 Sep 2025 08:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=suObi2/GY4gIdOy8/pJdudh4YHfdoLo9Lt+1E266qUA=;
	b=XH1P/pCm7aIhdWR2K+hIhZNEHdMZ3IZbS3VhIImYaSvMZvBS+/fs5djvmdoTXkHjT78KPG
	KCtg3OkOWqkWN6Qut5anMLrs+F+LOsMsjQjHugmwQJikMbosqj/tBQTLL2ft0qZRI1ucjk
	eEAdqrh908w1crlBF+wFd9tGnM8Wwnw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=suObi2/GY4gIdOy8/pJdudh4YHfdoLo9Lt+1E266qUA=;
	b=96GHuDHGXNaNLLeyYvM8kaj/9vvyLDirzWizLmA/t8xdUUVXJF6oXmSnEj3YQkPpJT5iuk
	ZBzeuMMKVchYMCDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=suObi2/GY4gIdOy8/pJdudh4YHfdoLo9Lt+1E266qUA=;
	b=XH1P/pCm7aIhdWR2K+hIhZNEHdMZ3IZbS3VhIImYaSvMZvBS+/fs5djvmdoTXkHjT78KPG
	KCtg3OkOWqkWN6Qut5anMLrs+F+LOsMsjQjHugmwQJikMbosqj/tBQTLL2ft0qZRI1ucjk
	eEAdqrh908w1crlBF+wFd9tGnM8Wwnw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=suObi2/GY4gIdOy8/pJdudh4YHfdoLo9Lt+1E266qUA=;
	b=96GHuDHGXNaNLLeyYvM8kaj/9vvyLDirzWizLmA/t8xdUUVXJF6oXmSnEj3YQkPpJT5iuk
	ZBzeuMMKVchYMCDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4EFFA13AD1;
	Wed, 10 Sep 2025 08:01:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UI7/EkMwwWgGJAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Sep 2025 08:01:07 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 10 Sep 2025 10:01:21 +0200
Subject: [PATCH v8 19/23] maple_tree: Replace mt_free_one() with kfree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250910-slub-percpu-caches-v8-19-ca3099d8352c@suse.cz>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
In-Reply-To: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz, 
 Pedro Falcato <pfalcato@suse.de>
X-Mailer: b4 0.14.2
X-Rspamd-Action: no action
X-Stat-Signature: y5amfm3qrm5mpdjwmnmd6zaar4y781mf
X-Rspamd-Queue-Id: B9F2212000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757491335-447313
X-HE-Meta: U2FsdGVkX18kvtcvRfivaj47nZ7oiHzjJ3i+9BX7KqucNNSTHHeyoztyjiuDBrraO6C7CHvDO8jTZLV/a07jSsAzhctMzUUt4TB7FeN3qL00vDWk8uAgKzTAWto89WTUsGGaamC6lJumm+eZQsxnFmg3OOfE4Nr1gENSmuV9hBYVtpSihhcnfUrXztNOJoXbqSHduoA1nLcbgB8qHS312h5+g754JplMlmwaDD2lwCIh5lPa5zGRJiKiWbgjdsQ2+vlm/T9q6r/8hgHrUyqpeW0DwwuQ0vljFIi63qr17O6TJIwiVPcoYGNDegQFO2yzUOsJxLk6uzcNGkK2+Namj8fm4qmPvSEkmCQQmHrpJJJoo2dQop/4KMbnLxsBBAv7Ju9ISQe9QEytlOkg1ZVKlHs/n6WlNA95v2UdMnIv8W9M0W4l/jTJv8xhlmQQFK6Y5R4wGUIjoSqYYF2z1NyxH21puywk0SqgzKjQXfhrPuMyuOVNceE6dwYh2lGZKQoAXDbNC5RqldAr2BaZqBc01JkWkMZm2qqOrLq9BQ5UQKTzymcFbqSS3XrkN42xmcQOBtJdSjFDDeszBKYGyYZ4tmwnnZvfo+QBWirT23LkCsTzmzua18WLWKmxBSFmgZlH5jZHrbIvNGc9Ks1lxplhXmcBHC/UCbAX+mEiyZzJIItjnVVYOpxXridwHe8JvIxGF2RBao3y/1Bz3kQ8F0oQRH91XkNhLLVBcxPurj6MfZNAOpkDqDX2aL61CXLxE2FMUGGzPZz/0+ry5u8BmJAQ6x3ZlG0EdcRGb/EyafGDxELx5VyGo/Py4v2vg+dLqCwo2p3SERi4Lx8c8HevyWLguQgws02angsUOt0w8ILSJqVRXHTJW2M0UeUCujZasROY1PAPeQcmMEGvZsfaQH8EPyGWBh67mowU3ScEW3P0u7MwSaPZpDNjTJZbhfGGfFA4L3svPxDSkxDp6FZOKXl
 LNskFAQD
 +W/46ohwpPL+tekBzTJW0YLTML3vrsjinXgUcoy4giFDvI4ut3n8FsMQSHffvxh7e/RzrfNl56gF1ITdoxSMbeqQSrSS4wFGAiPgdmD2HwwgxbnKeYkMWsS72Vfl92NORXlwd06Vm0ytIEP87sursfMjtbaj7R9ynU7+NHPSHnhD6iqKnaPuN8yvypSvP+/SaZ7eGiyW27OJo5VXoqPlS1cTfxjNz7RdROUbK2KNBrog7+ya4neN0qMxD+oWX5oxbYask45NC2fdDw+3H9afHc05MYc+CcBqiI/MaGukyXoRUm7g=
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
index c706e2e48f884fd156e25be2b17eb5e154774db7..0439aaacf6cb1f39d0d23af2e2a5af1d27ab32be 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -177,11 +177,6 @@ static inline int mt_alloc_bulk(gfp_t gfp, size_t size, void **nodes)
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
@@ -5092,7 +5087,7 @@ static void mt_free_walk(struct rcu_head *head)
 	mt_free_bulk(node->slot_len, slots);
 
 free_leaf:
-	mt_free_one(node);
+	kfree(node);
 }
 
 static inline void __rcu **mte_destroy_descend(struct maple_enode **enode,
@@ -5176,7 +5171,7 @@ static void mt_destroy_walk(struct maple_enode *enode, struct maple_tree *mt,
 
 free_leaf:
 	if (free)
-		mt_free_one(node);
+		kfree(node);
 	else
 		mt_clear_meta(mt, node, node->type);
 }
@@ -5385,7 +5380,7 @@ void mas_destroy(struct ma_state *mas)
 			mt_free_bulk(count, (void __rcu **)&node->slot[1]);
 			total -= count;
 		}
-		mt_free_one(ma_mnode_ptr(node));
+		kfree(ma_mnode_ptr(node));
 		total--;
 	}
 
@@ -6373,7 +6368,7 @@ static void mas_dup_free(struct ma_state *mas)
 	}
 
 	node = mte_to_node(mas->node);
-	mt_free_one(node);
+	kfree(node);
 }
 
 /*

-- 
2.51.0


