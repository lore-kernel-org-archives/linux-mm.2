Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 660B2C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:36:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FB3E6B00DF; Wed, 23 Jul 2025 09:35:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 384836B00E1; Wed, 23 Jul 2025 09:35:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24C926B00E2; Wed, 23 Jul 2025 09:35:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E3266B00DF
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:35:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D32781406FD
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:35:39 +0000 (UTC)
X-FDA: 83695626798.04.B7B7FEF
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 902DA180009
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:35:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=D7xnFeFJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=W0T4MPEY;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=D7xnFeFJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=W0T4MPEY;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753277737; a=rsa-sha256;
	cv=none;
	b=lc7+NGVEzVwrwcIzQvolGp72pMG2BTV5+RHQGHp6Tj+fBURXC5xeRkjyaQIvhqLnathxq7
	xyb3qN7Qb6XliqitkEmpXl5abghfHuUlkq9nPMn+yk+Kw0WQbMkTxwmiNkeG3WZ+/zNnyk
	xi3SZcJLn3Gv6H1QmMnRemv8+0gC81c=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=D7xnFeFJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=W0T4MPEY;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=D7xnFeFJ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=W0T4MPEY;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753277737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GMN8ss+JM7ZT/0b+qlebdOQL8dTktv7rSpXSzwpKjiM=;
	b=D3RUlEkVxd5HvwkbGSiNc4MGPUrozlQXUc/AJLDpH6rq5FgQGMEq1ToViYD+l7HNp2DONb
	ySGfmnDKHDgAGGiLiq9xyVtP8WUkOjkpiZN0T/Sgy0x7i6fk5kk34kJeVc/twalhh2eN66
	dCRE+lpokZ/4YOphb+gYfJBFiXlQwSs=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DF8B6218FD;
	Wed, 23 Jul 2025 13:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753277704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GMN8ss+JM7ZT/0b+qlebdOQL8dTktv7rSpXSzwpKjiM=;
	b=D7xnFeFJAkpHugq7K+vv5+xSMSSqv3LoNlPVCWeCFQbPAPPqcioyTHfY/fAuH0ah3hc1qm
	xwLQCk3W5hSFk7qYtX4Dy23J2nmo5zwA00GEuK33qaoGBeHyH77mviLv80FrOEwd1nz8gW
	JcFlnOtoJyZkUh2CfE0Vp/5gazF0rLQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753277704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GMN8ss+JM7ZT/0b+qlebdOQL8dTktv7rSpXSzwpKjiM=;
	b=W0T4MPEYaYr+YrCIKUaN1zHTbbptplOPMW3ImnnR4cspWkdh/NgMwtL+HWczth9piHUT82
	i4k4BTrXlL7fnDCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753277704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GMN8ss+JM7ZT/0b+qlebdOQL8dTktv7rSpXSzwpKjiM=;
	b=D7xnFeFJAkpHugq7K+vv5+xSMSSqv3LoNlPVCWeCFQbPAPPqcioyTHfY/fAuH0ah3hc1qm
	xwLQCk3W5hSFk7qYtX4Dy23J2nmo5zwA00GEuK33qaoGBeHyH77mviLv80FrOEwd1nz8gW
	JcFlnOtoJyZkUh2CfE0Vp/5gazF0rLQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753277704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GMN8ss+JM7ZT/0b+qlebdOQL8dTktv7rSpXSzwpKjiM=;
	b=W0T4MPEYaYr+YrCIKUaN1zHTbbptplOPMW3ImnnR4cspWkdh/NgMwtL+HWczth9piHUT82
	i4k4BTrXlL7fnDCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C72B713AF2;
	Wed, 23 Jul 2025 13:35:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OCxcMAjlgGh0IwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 23 Jul 2025 13:35:04 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 23 Jul 2025 15:34:46 +0200
Subject: [PATCH v5 13/14] maple_tree: Add single node allocation support to
 maple state
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250723-slub-percpu-caches-v5-13-b792cd830f5d@suse.cz>
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
In-Reply-To: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz, 
 "Liam R. Howlett" <Liam.Howlett@Oracle.com>
X-Mailer: b4 0.14.2
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 902DA180009
X-Stat-Signature: 8ckh4cuewb4nkyn9rbrso1idnqc1wp77
X-HE-Tag: 1753277737-637147
X-HE-Meta: U2FsdGVkX19fX6tEdj+vO+6IU/Z3wtlFAmLlGpQhloR5p1BWnv9BUGrJOlYvQSBWXhuW5ZZdZtFG24cJbBhKwYMdXCBVPqh+KQxGiSqGN/3y+iWdK1Fuk2B9ZWjzYaqSqQ2iUuIdzMk8sVWPFFQbYL5lD3lHGx54XJpKHqe8ko0N8DJItPI3G2qdyFIW4zCEx2j87TwIQmPK4Mu6LnYsbfhkgvCIsjKbzpyjJEvrWbRwlrAr4mYDT7AoE8zwmWH6iEIMSgtWAHR4f2ijaO23Z9LtsAHkdPfgdHPDEX0yxFnHlXvMFLHLK52W7vnCzhhm0rNgCmdvkZKEdFvbWGn03Q/uDYiOFEaU7mfyHuiX8z9ny+sJLhcZtN208Jr2Dl4FAGMixIR8NQboVCHdazXdnMCwWcEGiozoQ8EbMlJ9gcX0eLXzU1MvhUZVDqkhvyt88gKXBF2FF0Qorp5udGwdmSz85NyTjsvRHyK/fbbg2r+rUQVbAY7U9REk8J3X73dbWjoU/hmgGVoA70Hy5AnDH1KxjhvhET9FzWMNgoWxGtYdOENMCV19jsTJB+uPiHD8Jn0/3ptfGaFv1cev+UuRKcR2Hj9gqSpJQRZqPoQitITZBO/TwUQhzzb90c0VlnKkNVdox/ZfoB7qGoh/+F1rXkBeBih4yeGnFrqlxw28QawjJ1qtfQu5+gbFfT3qBdpZBgz+1V+Qv/iKq4Cd2gsoW66HzMLdtsn+bze0VmuvVB1T2H2qBX3t+6iRQlV7buTxI1cGXFeNI/RzsBP5gxux4g5UQB2z9ygksM1xcFJO8o/6G+wwth5ffBwvvLE+6IplTOZT7cFABztpnwTSsMIuWNQgoqBdYXT9i3AR1o11NK5HjCiwEdZIQpbyEFiiK1TsRtsWQdY0Z9B/UZAOHCplJoXAiT3jHWzecn/QOsL9g4p63qHbvVb3Tj3phJ7we0Njg0QPnrYgpP4tT/JI97C
 DuBGEaGV
 UYOx14N8k+zwZhW5wvKEf3f0N1YYwKxo8nTVpk3tD/d06/3shjiPbQF7gSJBqSg/c20EwyxnYK4LHtBwx18aecE+dyzKWG/Q8vAUem2ntTc/dHFID3ck5yhWqS5kuFFI6yGcXjbsJTQNywGha3vd/hFir4nvPqUTHEyXYQRTtvUZdOwLdZpV8opX47CvpcBEIzejAofW5jtj41lRv8GFQxf2PtSw0PPo+M4xyQb/zMr/gHEJIG0+U3UcUJBRsRNKhiQz4cwe+KISSDIQfCF3K276cUZY9mlO3oJZx777V47VlBfmUhX8QQ0oTEo0O4mubVP49aEtvzi5A/K0wPYKmAGTKn/bmA0CDRiXr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

The fast path through a write will require replacing a single node in
the tree.  Using a sheaf (32 nodes) is too heavy for the fast path, so
special case the node store operation by just allocating one node in the
maple state.

Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/maple_tree.h |  4 +++-
 lib/maple_tree.c           | 47 ++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 3cf1ae9dde7ce43fa20ae400c01fefad048c302e..61eb5e7d09ad0133978e3ac4b2af66710421e769 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -443,6 +443,7 @@ struct ma_state {
 	unsigned long min;		/* The minimum index of this node - implied pivot min */
 	unsigned long max;		/* The maximum index of this node - implied pivot max */
 	struct slab_sheaf *sheaf;	/* Allocated nodes for this operation */
+	struct maple_node *alloc;	/* allocated nodes */
 	unsigned long node_request;
 	enum maple_status status;	/* The status of the state (active, start, none, etc) */
 	unsigned char depth;		/* depth of tree descent during write */
@@ -491,8 +492,9 @@ struct ma_wr_state {
 		.status = ma_start,					\
 		.min = 0,						\
 		.max = ULONG_MAX,					\
-		.node_request= 0,					\
 		.sheaf = NULL,						\
+		.alloc = NULL,						\
+		.node_request= 0,					\
 		.mas_flags = 0,						\
 		.store_type = wr_invalid,				\
 	}
diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 3c3c14a76d98ded3b619c178d64099b464a2ca23..9aa782b1497f224e7366ebbd65f997523ee0c8ab 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1101,16 +1101,23 @@ static int mas_ascend(struct ma_state *mas)
  *
  * Return: A pointer to a maple node.
  */
-static inline struct maple_node *mas_pop_node(struct ma_state *mas)
+static __always_inline struct maple_node *mas_pop_node(struct ma_state *mas)
 {
 	struct maple_node *ret;
 
+	if (mas->alloc) {
+		ret = mas->alloc;
+		mas->alloc = NULL;
+		goto out;
+	}
+
 	if (WARN_ON_ONCE(!mas->sheaf))
 		return NULL;
 
 	ret = kmem_cache_alloc_from_sheaf(maple_node_cache, GFP_NOWAIT, mas->sheaf);
-	memset(ret, 0, sizeof(*ret));
 
+out:
+	memset(ret, 0, sizeof(*ret));
 	return ret;
 }
 
@@ -1121,9 +1128,34 @@ static inline struct maple_node *mas_pop_node(struct ma_state *mas)
  */
 static inline void mas_alloc_nodes(struct ma_state *mas, gfp_t gfp)
 {
-	if (unlikely(mas->sheaf)) {
-		unsigned long refill = mas->node_request;
+	if (!mas->node_request)
+		return;
+
+	if (mas->node_request == 1) {
+		if (mas->sheaf)
+			goto use_sheaf;
+
+		if (mas->alloc)
+			return;
 
+		mas->alloc = mt_alloc_one(gfp);
+		if (!mas->alloc)
+			goto error;
+
+		mas->node_request = 0;
+		return;
+	}
+
+use_sheaf:
+	if (unlikely(mas->alloc)) {
+		mt_free_one(mas->alloc);
+		mas->alloc = NULL;
+	}
+
+	if (mas->sheaf) {
+		unsigned long refill;
+
+		refill = mas->node_request;
 		if(kmem_cache_sheaf_size(mas->sheaf) >= refill) {
 			mas->node_request = 0;
 			return;
@@ -5386,8 +5418,11 @@ void mas_destroy(struct ma_state *mas)
 	mas->node_request = 0;
 	if (mas->sheaf)
 		mt_return_sheaf(mas->sheaf);
-
 	mas->sheaf = NULL;
+
+	if (mas->alloc)
+		mt_free_one(mas->alloc);
+	mas->alloc = NULL;
 }
 EXPORT_SYMBOL_GPL(mas_destroy);
 
@@ -6074,7 +6109,7 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 		mas_alloc_nodes(mas, gfp);
 	}
 
-	if (!mas->sheaf)
+	if (!mas->sheaf && !mas->alloc)
 		return false;
 
 	mas->status = ma_start;

-- 
2.50.1


