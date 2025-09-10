Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2C1DCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 08:01:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A4938E0012; Wed, 10 Sep 2025 04:01:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 006698E0002; Wed, 10 Sep 2025 04:01:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E10DE8E0012; Wed, 10 Sep 2025 04:01:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C913F8E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:01:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 82CAC13BB9F
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:01:35 +0000 (UTC)
X-FDA: 83872596150.06.A87F02F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4857F4000A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:01:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=S8o6M1Oj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1Ww9I553;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=S8o6M1Oj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1Ww9I553;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757491293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ojBiEAx4m3ERLpo5puWtBF2UDNNQAO38/NqqWUvTcPs=;
	b=ZmC955HnMEVlSl5rocQsdgDWpHQwG024EfcrITQn9NRxh5WPnluZcZx0K4V3umP11ld/Q/
	mXFsV8xBPdyxK4C5nsGRedie+VQaTxaA0wVoUdEJsaXXfkqF4HU3y8iJenWSTvFOUUsVXI
	CONmLaUcaYe8QLBTiFGTOgrO7ZrmIZg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=S8o6M1Oj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1Ww9I553;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=S8o6M1Oj;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1Ww9I553;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757491293; a=rsa-sha256;
	cv=none;
	b=mI0zE82S31AdNelDhkFVbNOm55ZyMeKFl9oOzjKRwmMhtBtBbnM0BqR3Xp7+hqEZUjUDhe
	Z+5MNfho+7oaQ1vqUrTHMl5m0GLZVdNZzljXwdLWgTRtM82vBghI3C/JmPnsvzIP49o354
	GEIg/Lh2GU+8a2x6pZO9zPBmU3cE0z0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 27A965CAD6;
	Wed, 10 Sep 2025 08:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ojBiEAx4m3ERLpo5puWtBF2UDNNQAO38/NqqWUvTcPs=;
	b=S8o6M1Ojk7gzwtMKOg8b976ug9apuNL7AsBon9WvCsdf1c83u5FxrjupOHFFPs58D+Iiwq
	B+/uTgRJguGcB5Nl4xz44wkda+FSReOQCGUlsgaxXdEINUgWvXzYxCshzN8sQPBT5P/jHg
	sjOVfEIqcZNS5XqKaaAtkaX1Px53jDc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ojBiEAx4m3ERLpo5puWtBF2UDNNQAO38/NqqWUvTcPs=;
	b=1Ww9I5532MCXIeEO2xHKhlJsON+aojWDoH4RgLrJ+654npRn7I6iTXr8bUP3P4A6l4X3Pq
	gKZHFInyKPTGPlAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ojBiEAx4m3ERLpo5puWtBF2UDNNQAO38/NqqWUvTcPs=;
	b=S8o6M1Ojk7gzwtMKOg8b976ug9apuNL7AsBon9WvCsdf1c83u5FxrjupOHFFPs58D+Iiwq
	B+/uTgRJguGcB5Nl4xz44wkda+FSReOQCGUlsgaxXdEINUgWvXzYxCshzN8sQPBT5P/jHg
	sjOVfEIqcZNS5XqKaaAtkaX1Px53jDc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ojBiEAx4m3ERLpo5puWtBF2UDNNQAO38/NqqWUvTcPs=;
	b=1Ww9I5532MCXIeEO2xHKhlJsON+aojWDoH4RgLrJ+654npRn7I6iTXr8bUP3P4A6l4X3Pq
	gKZHFInyKPTGPlAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5101A13AF8;
	Wed, 10 Sep 2025 08:01:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +EiDE0IwwWgGJAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Sep 2025 08:01:06 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 10 Sep 2025 10:01:10 +0200
Subject: [PATCH v8 08/23] slab: allow NUMA restricted allocations to use
 percpu sheaves
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250910-slub-percpu-caches-v8-8-ca3099d8352c@suse.cz>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
In-Reply-To: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz
X-Mailer: b4 0.14.2
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 4857F4000A
X-Stat-Signature: kgxa5i13mgzea38jukdp8x843s8319x4
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757491293-208690
X-HE-Meta: U2FsdGVkX188KiG+5Bl6grjTgMwpONDl1HIGnL3cClV1cXHQ/M8OGKOKm5U2ojeq88NaldGa5oIqOG8WBYzouUk8aPhKee2U9sQNpDIVhHc8ZgDMky0DIwfDuwBwVJOnRNPDQdlM2J3Rck0EgMCWWfAiyzdcTIcuDs+uMbFTzdf2ToqKNreZZuko2/yLwATs5SRd9bGJ5I4cbjSjMhNs339TNWcS+NXi7l8ftHEqkAN7OdEG58RYW7YA4ajZwxyFsfRdrlLUBKIO5vd3jXPNCt2FmvL8XU5RFS2/AFtc/3rRRVVreLQjPMTTAUTNsTA3eBM/oqDoHQhGRapxc4GLGrAxXxM7dw6VRnhVL2G14U6hXA1oPVOQ+MV42sD0YVQJwZ0IP/HRLjJ35XiMQRa1JKlLGAPZ767XvkH6H8KD9UQ+13sIgAfcqSZlmC0S8EcqMcBQ4Au2yup/ZUL6QMB+bh7fHIdg4H51rQlqGix40GdAN6np788uyPZTm1cB86x/0w7PIRylqBzGOvrlidF8NKRskGbihMNQtg26GEW01S1KdB8XQ3PpA1LM5Ly9dSnKMQPEjIHGJb8BQHzEmF2fX3bWAwbZTr8iTasYtbt8Gv77Hc3hckOIgwnxhJIJAPKCAELX691beTsqj5FwpAutUQIQjZhkQ1sSFHWMOGk65MYElFR9Fjr/84Kt4cctJTo9yZqsq072miOfynp5SEp8tFzHdDBcF9zz413jE0kaesYbiMfOQ6bccEff9oXAbkKuUtS2J+6rGfau6TET0K41BiDDhj0GWDsPvgg4BKtlfYbCPBIaHR71XpX8U/k4g3ZjyWgb/0g9IUf+029ks5rLHagdYV6+CGHa6ZjMOv+0rBGThLZa3kVt32f5fZOc1IzZjt/c3UP41P1bwL2dQNJC6Wxqzsk7dzEw32lgAEYt0d2imIMMxCwuN296isWKDOIo2R6s5z8CKSgOngDSBeh
 zXwT8mn0
 ewW9ZZls7uYOfSX+h4yZm0SCcxKSmnNMdkj/9XfzLPtVylZf6EPXfYygec2gD+EB0/4LUsj26WiO6+v/YO+nvlI3kOl3PrVuENG20guGTu4ShIYCJAf9YnTtRsDGGleUDpcHrcK6OEJqtSB+YyDRxVcXGW0otmgLcJMIYTvrcZ8/5Z6z3KcrTIED0qmgyK3v1LirQtfHYewoX5qJ1vb5+iywVZ5CoSktp5msfIWX59BOx3vjxcWowBh3VmnsUFp6IXmSGe1GUU4n3tft8BTKLfHkBXw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently allocations asking for a specific node explicitly or via
mempolicy in strict_numa node bypass percpu sheaves. Since sheaves
contain mostly local objects, we can try allocating from them if the
local node happens to be the requested node or allowed by the mempolicy.
If we find the object from percpu sheaves is not from the expected node,
we skip the sheaves - this should be rare.

Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 46 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 9699d048b2cd08ee75c4cc3d1e460868704520b1..3746c0229cc2f9658a589416c63c21fbf2850c44 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4888,18 +4888,43 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 }
 
 static __fastpath_inline
-void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp)
+void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, int node)
 {
 	struct slub_percpu_sheaves *pcs;
+	bool node_requested;
 	void *object;
 
 #ifdef CONFIG_NUMA
-	if (static_branch_unlikely(&strict_numa)) {
-		if (current->mempolicy)
-			return NULL;
+	if (static_branch_unlikely(&strict_numa) &&
+			 node == NUMA_NO_NODE) {
+
+		struct mempolicy *mpol = current->mempolicy;
+
+		if (mpol) {
+			/*
+			 * Special BIND rule support. If the local node
+			 * is in permitted set then do not redirect
+			 * to a particular node.
+			 * Otherwise we apply the memory policy to get
+			 * the node we need to allocate on.
+			 */
+			if (mpol->mode != MPOL_BIND ||
+					!node_isset(numa_mem_id(), mpol->nodes))
+
+				node = mempolicy_slab_node();
+		}
 	}
 #endif
 
+	node_requested = IS_ENABLED(CONFIG_NUMA) && node != NUMA_NO_NODE;
+
+	/*
+	 * We assume the percpu sheaves contain only local objects although it's
+	 * not completely guaranteed, so we verify later.
+	 */
+	if (unlikely(node_requested && node != numa_mem_id()))
+		return NULL;
+
 	if (!local_trylock(&s->cpu_sheaves->lock))
 		return NULL;
 
@@ -4911,7 +4936,21 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp)
 			return NULL;
 	}
 
-	object = pcs->main->objects[--pcs->main->size];
+	object = pcs->main->objects[pcs->main->size - 1];
+
+	if (unlikely(node_requested)) {
+		/*
+		 * Verify that the object was from the node we want. This could
+		 * be false because of cpu migration during an unlocked part of
+		 * the current allocation or previous freeing process.
+		 */
+		if (folio_nid(virt_to_folio(object)) != node) {
+			local_unlock(&s->cpu_sheaves->lock);
+			return NULL;
+		}
+	}
+
+	pcs->main->size--;
 
 	local_unlock(&s->cpu_sheaves->lock);
 
@@ -5011,8 +5050,8 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 	if (unlikely(object))
 		goto out;
 
-	if (s->cpu_sheaves && node == NUMA_NO_NODE)
-		object = alloc_from_pcs(s, gfpflags);
+	if (s->cpu_sheaves)
+		object = alloc_from_pcs(s, gfpflags, node);
 
 	if (!object)
 		object = __slab_alloc_node(s, gfpflags, node, addr, orig_size);

-- 
2.51.0


