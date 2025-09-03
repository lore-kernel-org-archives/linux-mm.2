Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2642CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 13:01:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13DDE8E001E; Wed,  3 Sep 2025 09:01:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C7198E001A; Wed,  3 Sep 2025 09:01:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5C9F8E001E; Wed,  3 Sep 2025 09:01:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C5A7D8E001A
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:01:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 91BA15A902
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:01:10 +0000 (UTC)
X-FDA: 83847949500.02.9752CE1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6878240004
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:01:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="g/crOFhD";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+sVatJLy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="g/crOFhD";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+sVatJLy;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756904468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oVt3cZeiI6R/GA6oApyVXQ+OhlrdalPHGhvrN43p2wQ=;
	b=xMwK0u8aHQwJm5IFlMbV29T+lXs3T0qZdYQeAhqNS6xwCZE+fXzXbJoGQTX6JZ+wnccBm8
	qgaGS4zAUey2eu4gIq35QuWSrLbwcadhtIzoFkew9v6sE1ja/+syVkUWBskkbSR4Ko9AZG
	VPCgIi7zZoR8LrmkdC73NCGxsZLpFHk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="g/crOFhD";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+sVatJLy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="g/crOFhD";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+sVatJLy;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756904468; a=rsa-sha256;
	cv=none;
	b=7cjql9PFaEFSu+OZt3Z42EdBq3ZGdTeNApzAkPxp1u8mZMnbHeHpmwXVij0NsV2l0DBKrQ
	jqgFMBPUThJHfx5XRPyOFQLAGADSP8bi5X7J+Xkbep79NY1/5NILNGvwWGNGOvkT5Z9eyD
	hWboLBv7DG8YPt+YCtVRySQ3wHMuNKA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CDB631F747;
	Wed,  3 Sep 2025 13:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oVt3cZeiI6R/GA6oApyVXQ+OhlrdalPHGhvrN43p2wQ=;
	b=g/crOFhD4na0C8rkDfdx8cUVpPT9jg4mfQfUrEEG4AJVIvPjBSHqVuQMjx53jybGO8wQv1
	DWgjWKKW0nkBALpU4bUzjCI3zEvlwoWuUoE/GApq97pTKowgtq9dqLM59Kh0Ov/9ySkgTY
	CFgYJ/oUj4EsO0+gbZKWXeBV7c/nkaU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oVt3cZeiI6R/GA6oApyVXQ+OhlrdalPHGhvrN43p2wQ=;
	b=+sVatJLyO7r62pCDRCB73fRH3sZeAriIa9SwQJzFj/GY9Z4x+DyRR3hpk8Usdnb5CGo5as
	RkaYUntMqWg2EMAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oVt3cZeiI6R/GA6oApyVXQ+OhlrdalPHGhvrN43p2wQ=;
	b=g/crOFhD4na0C8rkDfdx8cUVpPT9jg4mfQfUrEEG4AJVIvPjBSHqVuQMjx53jybGO8wQv1
	DWgjWKKW0nkBALpU4bUzjCI3zEvlwoWuUoE/GApq97pTKowgtq9dqLM59Kh0Ov/9ySkgTY
	CFgYJ/oUj4EsO0+gbZKWXeBV7c/nkaU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oVt3cZeiI6R/GA6oApyVXQ+OhlrdalPHGhvrN43p2wQ=;
	b=+sVatJLyO7r62pCDRCB73fRH3sZeAriIa9SwQJzFj/GY9Z4x+DyRR3hpk8Usdnb5CGo5as
	RkaYUntMqWg2EMAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 29A3313B06;
	Wed,  3 Sep 2025 13:00:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GEjhCdo7uGitOAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 03 Sep 2025 13:00:10 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 03 Sep 2025 14:59:55 +0200
Subject: [PATCH v7 13/21] maple_tree: use percpu sheaves for
 maple_node_cache
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250903-slub-percpu-caches-v7-13-71c114cdefef@suse.cz>
References: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
In-Reply-To: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz
X-Mailer: b4 0.14.2
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6878240004
X-Stat-Signature: n83yrn9qypi9w71muz35jyco95st4m1c
X-Rspam-User: 
X-HE-Tag: 1756904468-267980
X-HE-Meta: U2FsdGVkX1+Ro90iGx6T/6XTL3mBIt3o5YFoPbzI/EgKxp0NJyApxnm2Qc7xCe7rp448OTfAMfp+EkEj79ztVG3+Dvull5iGO1BA1WDHyeMr2JUWdFWQeDja8JjaJoNBNrFR1eM4znaF3h7lkfuslFC68DUtsyq4qeld6yTyDW/KlQLfnjglD/mnlk4if/8Mt/Nk7IZjNt1OWUy589zzXe7+T09ZCXD8/0Xt4EFW14BOtP5o9VTYHVXY86GuhXOy+ORgO9Dzp6DNjdCqKEqLsqcdwBWMECISq/wUBZ6EZnbSvL9BOhUc78qZBM1KQiMl4QzyCKDkZ+vwASi6p943Si57fcTajwEW0NCbBYLbszqY244q4QCve+msF+eMjLdVEnBtmh4bee2/bjUb+rYUHyEP4IFzwBtK6kYpRQmrsQfI+T2OvuaXIc/DR1W9fn6s8W4T8thTp+Qdjzbyj2ghJrhDtyF7yeGdvWAoaDqsfMJGm6GH20hTW58ypHsYZmokGGlYpbleYORNJSA0PhXhHwh1re2Z6czhKi5U7Bs2gttwXYAtRgUq7dHgmSPloq6UYDrIc/MG14b357MhIWcbI8xZtE/95MdvyAIfMNLo7o+1zN1qgWAJOkBswReJgC2DXEQbG+VSZPfTsf2+bJtmh6uhfm0d8+gscO8F+xzo6UnK92SUKwiVffZ49jcTkHkLgZw0sGZcnVloWGWwoE9AOdeCjs/Vr1xOkSAQdJRWd+6yfDcXg8sykpadT7+a7+RXcL4rKKJ6mJo91FGiYWdopDyiLD4OMHX4yYC9NkbOvdXCb1Y1mdFRnmVkejFZWty/FZf/gD1KM4Up46Fu+ZpCbaklenfrIWKqf27FeFtqTL6bT3FHF2t42fjNr+Y2J9azuYYBUH3Gn+8I0oB6jK4iWhU8aAMaRXomCgor5Qzuk6w/SJdNt3g031VJcFp6DMZM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Setup the maple_node_cache with percpu sheaves of size 32 to hopefully
improve its performance. Note this will not immediately take advantage
of sheaf batching of kfree_rcu() operations due to the maple tree using
call_rcu with custom callbacks. The followup changes to maple tree will
change that and also make use of the prefilled sheaves functionality.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
---
 lib/maple_tree.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index b4ee2d29d7a962ca374467d0533185f2db3d35ff..a0db6bdc63793b8bbd544e246391d99e880dede3 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -6302,9 +6302,14 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 
 void __init maple_tree_init(void)
 {
+	struct kmem_cache_args args = {
+		.align  = sizeof(struct maple_node),
+		.sheaf_capacity = 32,
+	};
+
 	maple_node_cache = kmem_cache_create("maple_node",
-			sizeof(struct maple_node), sizeof(struct maple_node),
-			SLAB_PANIC, NULL);
+			sizeof(struct maple_node), &args,
+			SLAB_PANIC);
 }
 
 /**

-- 
2.51.0


