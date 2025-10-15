Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B570FCCD192
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 13:00:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E3798E002E; Wed, 15 Oct 2025 09:00:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06CDF8E0020; Wed, 15 Oct 2025 09:00:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4BA8E002E; Wed, 15 Oct 2025 09:00:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D61CC8E0020
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:00:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ABD03117BAA
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:00:51 +0000 (UTC)
X-FDA: 84000358302.07.9C649F0
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id C93BB4000F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:00:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tkm+5Cdz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760533250; a=rsa-sha256;
	cv=none;
	b=qzKGLujCYvxhtjxZlxtvyrUEZpJH9d7ESRr4/VuI0OX2CTCHcjnW18BmPlfivijsULHkRY
	Gcf4Ghj98RyVR80yF3L9BsQcXEu+aLXeMiWGxM4wNFicQU2a+dZuqqYhNsFb6BzIze7XIe
	h7fnpmwjce5IHSsiBYjA1/YpISCnpvI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tkm+5Cdz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760533250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bvThHLk7dk0OCNQMxd4/MQHHps7Vic0UfmO+bcwITQc=;
	b=3DU1Vjym+33uGA1Q2UaG0jyWM2RdR16lkNd2N5/T/nUXrBNYQhph82I/XmwSaA6K04cPq2
	CjuyvgZdafAxk3ey5qgNvYOH9CEok+AeokFx3uE3nJ0loNx9qrQh/MR6QLrWakwFeoCGMe
	sUTjigAZiSH2DNVuOcLrg5rxnzd2o/s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760533247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bvThHLk7dk0OCNQMxd4/MQHHps7Vic0UfmO+bcwITQc=;
	b=tkm+5CdzzX3evmTKvCY/i5bNzP17XpdFzXSxivzzJLWFy1HEBiZYFmjZZgK1i0ox3EPVYW
	HGHdyrVkbP5irKJtwKAtgmqYMbTbiEjs1FqYNC05EqASSjEo9Gv0mcCOUbn/PaQ8h2KLhp
	QXIU4vv4DlDLqpEvtuWhBO/8GgLQS2A=
From: Hao Ge <hao.ge@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>
Cc: Alexei Starovoitov <ast@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Ge <gehao@kylinos.cn>
Subject: [PATCH v4] slab: clear OBJEXTS_ALLOC_FAIL when freeing a slab
Date: Wed, 15 Oct 2025 20:59:45 +0800
Message-Id: <20251015125945.481950-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C93BB4000F
X-Stat-Signature: onejscr53o66jrsxek4ofpmbbj3cyzkc
X-HE-Tag: 1760533249-817012
X-HE-Meta: U2FsdGVkX1/hvow5uQF6U2PToyLfqG5riGGPS4NShvKue5rfkPfutXO6clglk0WUCv/6ObGvc9xb8MqyUjayUAqgPQ2CHdxAgEJ9irEEAHHIRJ6w2vS7PNIiOMFyj6DRo/8fQ6WgrgaDJjJp6O8AiC5HfuFQhY+qeCTYA22tVJVhix670Gr/LG9PoRnOIfZlsN8YEv5RVrNbjPNlRc7mPHsT8JL8Hif83jacURSHyk6Mv2M++5YrB5BcfjnHlBRPS8KcRksNPfpuf0r/UxMA8/RnNUeUj+sAFK3uMpqT3LDhX9zQH1zyrZGAv9D5N16uFzcdOQP5xaDJG2Y519+Nm/Q+t6Ta4sNWeTRP83YmZMiXH8qfCEahi1GrfQOjmuLyGYSuBvxrrkAbd9Rg9OxUKSSZf8Pi3Nir6DUzMuWgnu2opI4jWqXVO29wDCvl0L+U19fRIucU+4Fg8LPoNb1H0x2k3XnYofsbF16x0D7Mf+McXZnhcX45oCtKsMuXoqMGItMnA9dFuJmTC0yd7Cu8yP/IUtnTAkZaJBbx3H0JDWVAdnavqppBwvC3WgLrcqz22a3Md5t2XFLZLDXzey/WierVbbqzVDnH85hoOk/qC9Iph5TTDpy2IQKql2dsJ8dK9Td8m+8SHY0T76BwXRlVL3SEMW3tOwyvp3QtS3VT9cLPeERbLcJyZ5uCEW9/DhwFqpZHZs5OCQNX7DfsmS2eB8skNOFel31U8lW+lwlR6Z77MXj7dACnUfRDnfjKjDnMmiGV4l3VcvHqAACPHcPoPn0BSw6iC/YzXEhkqFldh2XqKXt+Pzl2/vJSmgb6kLaa4G6X9W5OsEDVf3bON1f55HJOxXnfmCWO4SjyqSkxqHlzoaJHx9oy2zzedgEh+TtqR935rAphLbGIYmX+dbcxFuPeMMIdwGKHFaqZvE6S9A0iDUano/D2RzOf9xTNbVsh3xr9kKrD0DGmwf0HuI3
 uje4f92l
 YsU9AmB41HWMiYuPJZa1XYgF44McR3hI063OrDKgiqO9ySDerNXoLRocnoDqYQhAniCQMR5UKjeE3ibbDzBtMq6RN0XJOg5sKYGBoBh/lqeFoNpaDpnug8kzJBFu1dMdOn08xHJS9wgS8mAYDI9w/b6ai6IIPmh0CQfi5n3ni17fjzXdFltFlT6TywmqQFNY8qAOg48yT9tI19DN1EF1uGdfZk4fU/NJYhoKXmORMd44YQDhb4rTlvTqR6KUmcTLJTY91e3FaZsfd6/7K+SNb/GSflw4wyGs0709owRSGO2e0Xw+rOPIvPfNh7rAmH6Fd+Vuka5aeFZ+3Qh0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Ge <gehao@kylinos.cn>

If obj_exts allocation failed, slab->obj_exts is set to OBJEXTS_ALLOC_FAIL,
But we did not clear it when freeing the slab. Since OBJEXTS_ALLOC_FAIL and
MEMCG_DATA_OBJEXTS currently share the same bit position, during the
release of the associated folio, a VM_BUG_ON_FOLIO() check in
folio_memcg_kmem() is triggered because it was mistakenly assumed that
a valid folio->memcg_data was not cleared before freeing the folio.

When freeing a slab, we clear slab->obj_exts if the obj_ext array has been
successfully allocated. So let's clear OBJEXTS_ALLOC_FAIL when freeing
a slab if the obj_ext array allocated fail to allow them to be returned
to the buddy system more smoothly.

Fixes: 7612833192d5 ("slab: Reuse first bit for OBJEXTS_ALLOC_FAIL")
Suggested-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
v4: Based on the discussion between Vlastimil and Harry,
    modify the solution to clear OBJEXTS_ALLOC_FAIL when freeing a slab.
    This does seem more reasonable. Thank you both.
---
 mm/slab.h | 26 ++++++++++++++++++++++++++
 mm/slub.c |  6 ++++++
 2 files changed, 32 insertions(+)

diff --git a/mm/slab.h b/mm/slab.h
index 078daecc7cf5..52424d6871bd 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -547,6 +547,28 @@ static inline struct slabobj_ext *slab_obj_exts(struct slab *slab)
 	return (struct slabobj_ext *)(obj_exts & ~OBJEXTS_FLAGS_MASK);
 }
 
+/*
+ * objexts_clear_alloc_fail -  Clear the OBJEXTS_ALLOC_FAIL for
+ * the slab object extension vector associated with a slab.
+ * @slab: a pointer to the slab struct
+ */
+static inline void objexts_clear_alloc_fail(struct slab *slab)
+{
+	unsigned long obj_exts = READ_ONCE(slab->obj_exts);
+
+#ifdef CONFIG_MEMCG
+	/*
+	 * obj_exts should be either NULL, a valid pointer with
+	 * MEMCG_DATA_OBJEXTS bit set or be equal to OBJEXTS_ALLOC_FAIL.
+	 */
+	VM_BUG_ON_PAGE(obj_exts && !(obj_exts & MEMCG_DATA_OBJEXTS) &&
+		       obj_exts != OBJEXTS_ALLOC_FAIL, slab_page(slab));
+	VM_BUG_ON_PAGE(obj_exts & MEMCG_DATA_KMEM, slab_page(slab));
+#endif
+
+	obj_exts &= ~OBJEXTS_ALLOC_FAIL;
+	WRITE_ONCE(slab->obj_exts, obj_exts);
+}
 int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
                         gfp_t gfp, bool new_slab);
 
@@ -557,6 +579,10 @@ static inline struct slabobj_ext *slab_obj_exts(struct slab *slab)
 	return NULL;
 }
 
+static inline void objexts_clear_alloc_fail(struct slab *slab)
+{
+}
+
 #endif /* CONFIG_SLAB_OBJ_EXT */
 
 static inline enum node_stat_item cache_vmstat_idx(struct kmem_cache *s)
diff --git a/mm/slub.c b/mm/slub.c
index b1f15598fbfd..80166a4a62f9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2169,6 +2169,12 @@ static inline void free_slab_obj_exts(struct slab *slab)
 {
 	struct slabobj_ext *obj_exts;
 
+	/*
+	 * If obj_exts allocation failed, slab->obj_exts is set to OBJEXTS_ALLOC_FAIL,
+	 * Therefore, we should clear the OBJEXTS_ALLOC_FAIL flag first when freeing a slab.
+	 */
+	objexts_clear_alloc_fail(slab);
+
 	obj_exts = slab_obj_exts(slab);
 	if (!obj_exts)
 		return;
-- 
2.25.1


