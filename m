Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EF9CCD98C7
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:54:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FCCA6B0092; Mon, 15 Jun 2026 07:54:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ADD86B0093; Mon, 15 Jun 2026 07:54:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EA9F6B0095; Mon, 15 Jun 2026 07:54:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 715B96B0092
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:54:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1960CC3678
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:54:55 +0000 (UTC)
X-FDA: 84881990550.05.D154F10
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 65C40A000E
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:54:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b8XHv0jS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781524493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SVCepHs6d1sEZDL4gFgolTnsiAOHVwL4iSPAe3FhQcU=;
	b=V16nKVyC/LFx5j7KnxOjvRUdwJrKX7aJYRNpGXRVj+1cYiC1pxvZjtss9PlGuis1z6TCjr
	n2vtkk5auZyNfvnU76fBc5xjNeuhgW2qa+S3NbmVxL5LyVWxiymta1qksrctlpNuWvySQe
	6uJ0/M8pwVy6/K2XvB6c2ZQKnb4uQPY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b8XHv0jS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781524493;
	b=LUprUEdvvJ5TkXLfjyFIGlYVwseNHlFkbnddsDUckW6xVABvPhdTwlVYxuWdG51DHX4FfV
	v2VFlQ/CbAKVHaJV9rhyhBy3lVd2HKMckRIr2kW5B3drYNJNLYu0JwwHwf9246KG8HKNuV
	NID7qFq6h/GE58bhutWyeDGGkM+Cp1U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8DB054362D;
	Mon, 15 Jun 2026 11:54:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001471F000E9;
	Mon, 15 Jun 2026 11:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781524492;
	bh=SVCepHs6d1sEZDL4gFgolTnsiAOHVwL4iSPAe3FhQcU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=b8XHv0jSnFQKoaQwFvgr1GR1TEC3NhvrdybcD/DZTcJk62W/+Wf+aXq28YaO2Vkvj
	 Z3gICBMopV6ceOwGSSBGqJbFRkt6Hv9DgPuTBn80AxjIQ20cf3de28xpUeobEOPJnv
	 uipfgQlmMyVYxR5d+JEyBwk5Gcizm0NBQP7FM6cCQJI+i0d0TFgCSuFqJS75t23TiD
	 tGrQ/1g3Byjyy50fULV3rIETHPE6n27FZPTolQuqdLUOougcfcjeQynYaaapjdBxwn
	 75181HZJQA0jujcSzknz9BHcfsJshoz7KIaSRMSiFjFYLJrSkmv1pvergveknivbu/
	 U1UDeTwFbwbyg==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 15 Jun 2026 13:54:35 +0200
Subject: [PATCH v3 02/15] mm/slab: stop inlining __slab_alloc_node()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-slab_alloc_flags-v3-2-ce1146d140fb@kernel.org>
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: iwhbz6gi458uk4nwnh3juc757a6woc15
X-Rspamd-Queue-Id: 65C40A000E
X-HE-Tag: 1781524493-68898
X-HE-Meta: U2FsdGVkX1/aQtXbqVZfYY1PgysKKwClWCHrfPLpF1GNqWu8P3AGQHqLTsAtwixr+cd/rp8Ha185k3HQskXJ6OYM5FblfmSGYj3cr4xXF/4F2uuB8oCvIrO7ATJV29qrb36+PyHy1EhMh/GyIXs1XPDM8mHyY/gZyUoDwpQ1yM3Z2sG5KmUMNkw/TNuPXbaiNyWIm26IWb9wMxEP8CIF98alzbjCGrI+Xj5rzXgHLs81ICn916WSMYvSQ9Wmi/AnYFbDrcAHtTjJEFTbgBRL6HqpZ2I9rEMvnG68dp+5qFLoZSB4B/HtreIkOdefoVOw5PmsEddVwGyYjOxGUioDoygOBkU75XYju6NUP1DCeirR1JUN6mayvwvAIvPDBSVV2iQTd2+qAp9Gs15VOgQB9QpZtRHOBQi/F2gJccy0NXyAO7WrX2+LjFiWuB83ETQet9FTerNLVH/j3xx4UV8S5qBdVxNwEW/cKZ13TabXvakyo/VQinKfFZ+Nj5veTZDGcuosUT4xWawj0d1ZOY3yKJiJ2XIvtxYr+SiZen0aPEnguaa5EBW8/z0fAnn+Hik9zidjkNNKZLVrRs/c58ddAOENdvXH7uZ5gT13Z3wpLO3wm6j4bCoa91XPWtEYewUottVXJoAIVKkDn0LknZp/RhqqQKCQe2ovoYFIQw2fj0KF5aI6oeJzFd3a2PL9hd68dMmYJtDKqceaCVMJbFydVgt1tn92uGlQKauAKH5PLi1PKoTv7evsl5ZvfCSPioadJcDLY3xMrpG0JcgJeGymcn1bqcfu2JQhlb36C2jOLSz23qoefSqIbk00wYFe/Fi2yptfSQvAaVipH18yh8+5lZOLPeIeo1RQLbcRQzUZtoyBbmY642sMsdlicofsdeqnkKIlsbXOotXijDXAgU5AIeSVzi+FsgU6AF2PlCmVc13RPZ2EBEdnBref7am1Vy5cXbVHT7dksBTCe8rqvY+
 b1pxLIpV
 uqeqyQjuJpgP/Wdz8i97SwrzVgvcQEnhVOLoAvag0LObx2MJDDHZWX0zf4l2cxW8KrOdXDskWb7WfWEQFJ4M8YEmJd4hnNJbq1JuwgsIRgHfyE8soPBHiBAvLQO5XaSdyNqYFjT9V+1t78w2nft4/VKc+C0Eai7jf5xHQISc/xLX0K9Df7eniSKXn1kPtrVAbvmK5mHc3KvlLBLkjWQO8PZpJySXFzBUaaqcOkIV3gCmRD9ByKVR0BDX2VWEptzRuBZswAeBxgC2J1tsNQQtib5lHelMM6dXef6xjwZWn/zTgyZkq/Nugq3ZYGyYupOisZt5CQ2Xw8ZAn4mIYyJqWG9W16l39imoU3L34yOUkwf4IELrwjIyw8tsyI0E24oxqXPJ0RtwljuvoMgCX7rzjcQI8Xg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With sheaves, this is no longer part of the allocation fastpath.  For
the same reason, also mark the call to it from slab_alloc_node() as
unlikely().

Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Reviewed-by: Hao Li <hao.li@linux.dev>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-3-7190909db118@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index d762cbe5d040..8845e15cb152 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4519,8 +4519,8 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	return object;
 }
 
-static __always_inline void *__slab_alloc_node(struct kmem_cache *s,
-		gfp_t gfpflags, int node, unsigned long addr, size_t orig_size)
+static void *__slab_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node,
+			       unsigned long addr, size_t orig_size)
 {
 	void *object;
 
@@ -4926,7 +4926,7 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 
 	object = alloc_from_pcs(s, gfpflags, node);
 
-	if (!object)
+	if (unlikely(!object))
 		object = __slab_alloc_node(s, gfpflags, node, addr, orig_size);
 
 	maybe_wipe_obj_freeptr(s, object);

-- 
2.54.0


