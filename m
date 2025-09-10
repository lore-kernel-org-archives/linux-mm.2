Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFBC8CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 08:01:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEF4B8E0014; Wed, 10 Sep 2025 04:01:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9F508E0002; Wed, 10 Sep 2025 04:01:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A68788E0014; Wed, 10 Sep 2025 04:01:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8E3618E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:01:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 49DD214077E
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:01:41 +0000 (UTC)
X-FDA: 83872596402.19.9CDB80E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 388FC18000A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:01:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YPw5IO+o;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sgSvKRdD;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YPw5IO+o;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sgSvKRdD;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757491299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JknvsOxfmdGK99z5Y7Du3/KRq6UYdu6X7lKlwYsXCV8=;
	b=ZaZ9WHxoydEC1o6uvHB/6k+KKWWaWWXyPWpR5VvLSBkN0YZjWz8CbSPfl79I8tCzFlc34F
	ejHmnH5oaSkGoTbMNnsZN0Htzcw2VQfKnASHAE2KF/bbFTd+WOVr5pPGcmXdEG0o/FYdoI
	WVCueWK12AS7PiDSyAaH/+9YeBXYFWc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757491299; a=rsa-sha256;
	cv=none;
	b=aySPF7DDeaAy3WkGf50f7vo/67chTBO1B8ggS9nY09+PIb7clUvX9OFKbzRiokNCZN6qkJ
	OR+IzegLRvo+IueS+85yOpXrweL5Lkt8VIdSupLc6XOZJHfi4/gIs9WKPrVS0XK2NoEOXM
	xqfIqxcME0y8PP8YCKLhPWRDADOnucw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YPw5IO+o;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sgSvKRdD;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YPw5IO+o;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sgSvKRdD;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5304A5CB34;
	Wed, 10 Sep 2025 08:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JknvsOxfmdGK99z5Y7Du3/KRq6UYdu6X7lKlwYsXCV8=;
	b=YPw5IO+oJdz5rFhGGiXcLxntBg4dQtv/AZfDa58nfUW0pulrlTBA78HLoJ8DalVdbjN3AJ
	C0egF1mCnxK3hEeFFci2DMnofdQigpmjOllksLUOJifn1F9oZDsgEoSbaLzbMkhxOmzqkE
	fcLhoNGshkR+ZB083dHYP3RKv71CQ98=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JknvsOxfmdGK99z5Y7Du3/KRq6UYdu6X7lKlwYsXCV8=;
	b=sgSvKRdDq2XsiiXk/7Crr8DG5iWigMyXMXUcR0U8vCxpaJ7jxU3b7OtFGpoLxNh6s3912i
	WhVESaxaLatiyjAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JknvsOxfmdGK99z5Y7Du3/KRq6UYdu6X7lKlwYsXCV8=;
	b=YPw5IO+oJdz5rFhGGiXcLxntBg4dQtv/AZfDa58nfUW0pulrlTBA78HLoJ8DalVdbjN3AJ
	C0egF1mCnxK3hEeFFci2DMnofdQigpmjOllksLUOJifn1F9oZDsgEoSbaLzbMkhxOmzqkE
	fcLhoNGshkR+ZB083dHYP3RKv71CQ98=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JknvsOxfmdGK99z5Y7Du3/KRq6UYdu6X7lKlwYsXCV8=;
	b=sgSvKRdDq2XsiiXk/7Crr8DG5iWigMyXMXUcR0U8vCxpaJ7jxU3b7OtFGpoLxNh6s3912i
	WhVESaxaLatiyjAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2542513A54;
	Wed, 10 Sep 2025 08:01:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wLDRCEMwwWgGJAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Sep 2025 08:01:07 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 10 Sep 2025 10:01:19 +0200
Subject: [PATCH v8 17/23] testing/radix-tree/maple: Hack around kfree_rcu
 not existing
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250910-slub-percpu-caches-v8-17-ca3099d8352c@suse.cz>
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
X-Rspamd-Queue-Id: 388FC18000A
X-Stat-Signature: kxnh1a5qw1sa4fg5ee161fhqdwgac9rn
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757491299-786987
X-HE-Meta: U2FsdGVkX19dDf5uEH0coXpspUXlG1mKMXu7dplZUJ8/pmo3nrLP3twNHypY1M7BMdtOukXVPsVw23Y5aF2NVxvMuA9VVTEM16gFoOvAA2eB7O6dn1bnXDet+f0XV79AsDwGyio8w3BSqLLUaxmRK67IWLmaQNxGE3jztwS2R45Tb6ggPu5ukgLduHBB3KwpkYjXjpwncB8oP2/wEtoGy0q4jIaq45KKfFDtXF73hy9YKT8bjwhf36tSSOSFTQuGhN6c07FwtYmm15UFi+iCj0NeqbzPQitrpyQJvtl47oVNkRlBXl66PKs3s7m5nv+7xPVkNhMUkO+B1IE7JnwMsKa6wBVuGs1V5Txxi9gYXLVeJ6zmlLZEUhWHsFZAXL2Dc+umhax++d4nvT3ggY+J0zM6bA3AzNRNlZzW17mcrY/8G9MRaY8nzot5b3bSJXTWfuiTu7arLkfseIsuOEXU+AZI9dQvwG/BkkKLoM2X+hrgdsfGScNQR7jhGMihi7/2wrGBwIwqWi9RFM+kMM71Yd5WxsgZY5/Fxy3fdy5/X4pxBnGN7OgPOE9tBOhPzQHdv/rvj4mrnQ15rVWsK4Yk05oZjG0D+vNiS2Ri38e57pzHlvc0ho/nkuqYwSg+VXIE1hY7rDefkkAtWxD7sZzSC5EnKiiiLSgz8oe+BusGaTiX30GiuGoMLTpW2E3fuSUtWDV3E+LqYSmcOMC/1f7i+4al53U2Ax/5uSpdbFFVY/JJbcLQIzSoENXJwsP2Zjs5XUwRSpODJvnmJPGkblCo5d7goJ6//U/ulBGUqid1adDK4U4aO3a3Fzbsfd0Irtdo38qxnyrZYfXijVCwMUFPJ//yVn2/6qMd7+HbYgnNlmEvIgZf7i5MbnZ4y+s/V22zmSyZzCk42JEZfgBkpyTA7pvdNq2RAAWiDI8gXuRPS1UOOFs+dcVQuFT/1845Vhck
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


