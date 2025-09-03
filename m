Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 488BDCA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 13:01:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F09E8E0023; Wed,  3 Sep 2025 09:01:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 979F68E0022; Wed,  3 Sep 2025 09:01:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77F128E0023; Wed,  3 Sep 2025 09:01:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5F3238E001A
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:01:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 15B65140698
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:01:29 +0000 (UTC)
X-FDA: 83847950298.04.A369BE1
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id 95337A0021
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:01:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=s56PP7bb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+A8t13hY;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=s56PP7bb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+A8t13hY;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756904486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JknvsOxfmdGK99z5Y7Du3/KRq6UYdu6X7lKlwYsXCV8=;
	b=eMBDnftwo179oUtVzjFBRFMO0ooOYzGgEjBCQnmD6R14Es4Tbe3Ok+N6TUMkJup4IKzRex
	z68Mw9o2e1GToo5IjECFGGPw3yc023V5qpwidGuwGrZDj/P8AUCmRoIWx0e+v2kKuLw6iv
	FRaHLSiCH7dpU/bHWvIlRGsys+RoTOk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=s56PP7bb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+A8t13hY;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=s56PP7bb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=+A8t13hY;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756904486; a=rsa-sha256;
	cv=none;
	b=GlDRvaGcwRIo5WsDyHX5Ea+T0bQBuFqUYT3w+HGrdYf4XtonWzyrisu7rbVYriMggFPyYb
	hvM+/fP5NuW5hgxggHrS1LZYILOciTVXd8cCap7CNUWkVH3Jkm8HRsUIjI5SI8EB7H0iVH
	vQIvD9pUPIVwjuh5dF+WiK37ykHx+Xw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D69712122E;
	Wed,  3 Sep 2025 13:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JknvsOxfmdGK99z5Y7Du3/KRq6UYdu6X7lKlwYsXCV8=;
	b=s56PP7bbwHH6whwJL2r5Ho4P507+nSBUP2TENIZjQ6Q81MdfcfZ+M39yPd3egI2mWi4ogm
	Jaki9Wif5jE8+sZXfWqHbpXIFEkFdLYgcv1lsFftAUPUZfDhTZgWSskrY+yMG6HBRby2+k
	RgqBBotTah24Rlbnn6UIvj2NRP8aY9o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JknvsOxfmdGK99z5Y7Du3/KRq6UYdu6X7lKlwYsXCV8=;
	b=+A8t13hYRyz2t1rAcREe70GXhSQ1k6mOaEitFo2To8F3ZjbHzc2x3A1u867+o4CmmebmsJ
	JXpRflqZLF43kqCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756904410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JknvsOxfmdGK99z5Y7Du3/KRq6UYdu6X7lKlwYsXCV8=;
	b=s56PP7bbwHH6whwJL2r5Ho4P507+nSBUP2TENIZjQ6Q81MdfcfZ+M39yPd3egI2mWi4ogm
	Jaki9Wif5jE8+sZXfWqHbpXIFEkFdLYgcv1lsFftAUPUZfDhTZgWSskrY+yMG6HBRby2+k
	RgqBBotTah24Rlbnn6UIvj2NRP8aY9o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756904410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JknvsOxfmdGK99z5Y7Du3/KRq6UYdu6X7lKlwYsXCV8=;
	b=+A8t13hYRyz2t1rAcREe70GXhSQ1k6mOaEitFo2To8F3ZjbHzc2x3A1u867+o4CmmebmsJ
	JXpRflqZLF43kqCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 518B113ACB;
	Wed,  3 Sep 2025 13:00:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wEShE9o7uGitOAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 03 Sep 2025 13:00:10 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 03 Sep 2025 14:59:57 +0200
Subject: [PATCH v7 15/21] testing/radix-tree/maple: Hack around kfree_rcu
 not existing
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250903-slub-percpu-caches-v7-15-71c114cdefef@suse.cz>
References: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
In-Reply-To: <20250903-slub-percpu-caches-v7-0-71c114cdefef@suse.cz>
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 95337A0021
X-Stat-Signature: qx47ezezxebmrzwfoduj3ch1air4kpiz
X-Rspam-User: 
X-HE-Tag: 1756904486-494189
X-HE-Meta: U2FsdGVkX1/51PzdDToQlbY6g3LW1CA1Tu5IYG8xC3wrOb0F8JgOzj8Jye1Pz48M4uiYq+B3T80xmh3VTBmg98C6RU5ZsqlCFttF2edl1x/sdpmoAl92oRQYlmLwky0WCF0FSKZMXSyLBjxtNjQ9IopfXlSh3CWrW3JXYSVYgF1kYnUp4+mreuybciVM51P+EhM3dMIIa+XjXPeoPfMfEXIZsgo/FY7JN85Q9X/oQ6vOWLGp6xqvPaftNI+p6dV7KZO75ajaoRhBwbo2C4BhULe0xrRbN/vCAhrn6NcMDIN7CnRMk2moGznK5NdNsk8vbnMpIDnPNmy2J7wy5IFw3YpHg2QxE3HgQ+b5bIDJ+FWujLT22aSVB8JWBSc69ZYHwRcZftLIFVSg+5OVAARWiGnApLG55DRiLgWM5mAYIVVFECS4tjM0EKu7rpbP9qr1dkFnS9JBxmDBwmPSWqPJuBVAMK3My59yb8xYRVTzMJu0OHVqcD9sBfXKSICZF/F7KqYTxzgmc94X4a//qXaQjghBejTK2VLTvXe3OSU5ckv7caZMnstZ11BmF5v32qKQd4FjzTs69KjQx+tDKNgqp79rOeaNIPXv3x4TbNqgmX7pr5WBGOpBTwQsHCxh5UIlOID9SmyGhoEKT2HuQM3x7wPf3V6GL6blwplvtrq//b+79ZL1qWLINPt2r4ADThd87w1XCGv0Ifu/GJ8H0cCltRjexJyaxQfNHUmsA/Cz+LyjnmSw5cT26zIrISnpFtSLisxY4Ywj7Bie0odPx/YIwrg87rFE69J/icyq15cq57hGQrkPGbVuQHGdDL0XleOr1OtKRT4CD9r22hyj46Qgcy6562sH8t0P6U9nUYPPLa7f/U4suC5XF+QCg3xk2tKrCZFJ2omQqKnTN/110gUJAcrr63Y0oqRAoFbJOZ+mlg4+hq+PqICRPkgiDX+ICm3Sxju/WWFCiyJXLv0u9vF
 MhxjWkUW
 +dtkbqYJQ3n/KMp5x2UZ4Zf7cRFnfKmyYf+6ZYNy5kmA6KlaQ+FxNS7eDrZqSMew0dpj65Uu88UoFNnl2FGDPcxwZyU3yRSHRn9pWlb4RgOLCUAuHKO7bmq5ZiGj37MuwQpNXoAmiOUkYWHduxdUkCtqJGog3rfxhGQxNZpxYaIGBKOzMPYJ/fVmrmGTIdHgh/An7E/M5yI1FobBJzvzTt9VaoSe7ydqNocsOxgMA2cVExTbDYYSEC4ylTSxG0OaJrCUKKu2fl2D8mcKEx921QzAzB72HACN1sAeXkkC/9XcRlmgR3LlZS+UX1eojtMgfxPyb1mYqUfkSLiPtqxby0Z/c9k0G07yipNOn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Liam R. Howlett" <Liam.Howlett@oracle.com>

liburcu doesn't have kfree_rcu (or anything similar). Despite that, we
can hack around it in a trivial fashion, by adding a wrapper.

The wrapper only works for maple_nodes because we cannot get the
kmem_cache pointer any other way in the test code.

Link: https://lore.kernel.org/all/20250812162124.59417-1-pfalcato@suse.de/
Suggested-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 tools/testing/shared/maple-shared.h | 11 +++++++++++
 tools/testing/shared/maple-shim.c   |  6 ++++++
 2 files changed, 17 insertions(+)

diff --git a/tools/testing/shared/maple-shared.h b/tools/testing/shared/maple-shared.h
index dc4d30f3860b9bd23b4177c7d7926ac686887815..2a1e9a8594a2834326cd9374738b2a2c7c3f9f7c 100644
--- a/tools/testing/shared/maple-shared.h
+++ b/tools/testing/shared/maple-shared.h
@@ -10,4 +10,15 @@
 #include <time.h>
 #include "linux/init.h"
 
+void maple_rcu_cb(struct rcu_head *head);
+#define rcu_cb		maple_rcu_cb
+
+#define kfree_rcu(_struct, _memb)		\
+do {                                            \
+    typeof(_struct) _p_struct = (_struct);      \
+                                                \
+    call_rcu(&((_p_struct)->_memb), rcu_cb);    \
+} while(0);
+
+
 #endif /* __MAPLE_SHARED_H__ */
diff --git a/tools/testing/shared/maple-shim.c b/tools/testing/shared/maple-shim.c
index 9d7b743415660305416e972fa75b56824211b0eb..16252ee616c0489c80490ff25b8d255427bf9fdc 100644
--- a/tools/testing/shared/maple-shim.c
+++ b/tools/testing/shared/maple-shim.c
@@ -6,3 +6,9 @@
 #include <linux/slab.h>
 
 #include "../../../lib/maple_tree.c"
+
+void maple_rcu_cb(struct rcu_head *head) {
+	struct maple_node *node = container_of(head, struct maple_node, rcu);
+
+	kmem_cache_free(maple_node_cache, node);
+}

-- 
2.51.0


