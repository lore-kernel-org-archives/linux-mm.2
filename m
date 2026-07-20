Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D9CCC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:36:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E11C6B00BE; Mon, 20 Jul 2026 15:35:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 543A26B00C0; Mon, 20 Jul 2026 15:35:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BCEA6B00C1; Mon, 20 Jul 2026 15:35:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 010EA6B00BE
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:35:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7822C14027F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:38 +0000 (UTC)
X-FDA: 85010159556.06.C3230EC
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf10.hostedemail.com (Postfix) with ESMTP id B4ADCC0009
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pZ2QIY2+;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Td0ObD4Hgwpwfgrx3CumklQ3nHYCwgNqQNeFJP8dHtU=;
	b=FE145kVJHecS5cKBK4Tjatq9i/MiJxfJdnZ/Ohdqdfwe3amblT8T/hgkz63aP/HQwU+jRW
	9T2KnPLlIZuC2qFp3rkOToEFmyxaFQoiBwS7hdwxw8/WngUaafZq8b/cq9Xjcpw3RTAzID
	wzM+UNYILVZhJ3M5tlMSvO045LkVq2w=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=pZ2QIY2+;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576136;
	b=6626cPDM7vRTnTlmNEFfGozBHpTkVWDIUrO4VkoNs+iGGAJooTXeeY2z/ZOOJ2FWyeKF64
	dvAVtXvAUZSjV2Nhg19M8XDvjdDndIwKrWF3EHeoOnDbWDpnsU+INz9vSCd4exv+6dOxFl
	XzoVD+lZEF47zsrXeykBzvodvADOhGw=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-92e5c92c389so689318985a.3
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576136; x=1785180936; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Td0ObD4Hgwpwfgrx3CumklQ3nHYCwgNqQNeFJP8dHtU=;
        b=pZ2QIY2+GuaViHx/ZVL2rknIzTIBAG160tcx6cdgrMCvs3BRFVEtqehYtwce6Hnpwv
         rd7FbSAbYoUFpiZuIKAPf3k9Wfy+uge4CwI9l7TJRSGSaiWfSmY1tTNxe8sP1HFbYSYC
         2m+PWzlp7PN/AqUtsKoVGwI0T2t0rQMO1n7LZu3jt3azbH1r4KIHBJSPCET3SgBYM+Qm
         3/a+8wd3IyLeZK/c7h5buMcm4Apdl/SDB2LUTodUx4UTP3kQxL5Hx5LUTWGydCEdZNWi
         LJdkK5J1dtAApBlAjiB6NZZLMJ3cKgXY+F5R63rDMDVxYZGKq8F0kNTckqAbm+T/zcrO
         AArQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576136; x=1785180936;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Td0ObD4Hgwpwfgrx3CumklQ3nHYCwgNqQNeFJP8dHtU=;
        b=TyuCYvy7z0a/w8uYeOFQ/WtyE5TpGtB9gVoGGfKRn5fp1cGYOtveRMShw6JOlizrZg
         7gzkHLDTmd6C18UBvjFexgnfcej93kxkT6Pha0wuVXWWgsF7eprFIbBMiPa4YIydl4g3
         uYgMDvK9Evf8wbDRXQeSHcBHGwKsPAyPxgRIQ50djzwqCP6UhPMkdue+iv6kxxSRhaQ4
         7MsXpcKbSi587gUPwOmCuTnAKwxjKrsipn+GrkZXAEgas9CVgsGyN1fYrSBhAaRvpaBT
         WSOglNijRDJjLIBCI5jNZ6/4tuDZQp2VIgSUxWOsH5r7w6Xm6d+mr9yzGLVx/4uMF1Dd
         9ToQ==
X-Gm-Message-State: AOJu0Yw/lNC0JOt/Lwh6Q6PsstO+VgSH857kSvZOj+qWZFgrewPko9p9
	eKr0w87cm9ZhdvfHQo8ybXDc8/BH5D3U8KJW3xtlZSAZD6T2MlYOUy3hXs6//rHUJ7lCap1uYTe
	btmkY
X-Gm-Gg: AfdE7cm2sQw8y+lJzNUsfLP9/MEFBjZz0kxTBEpe3ifKc1MJEjk7zZ++Zr1uNfqPUaf
	Y+dqSKxvveppZMQc1J/Z1mZtO30RSnWL6CxWUptgTl3w/38IR0GyJ6zB+gSHTBzEm9asSuEIFn5
	wNrQ92xEtYU5wnhFFiF3C51+8fSR+Yi8C3qX8/Sfktz0jn4PCvEyjZoy314L41kwQzaXVgsrYJZ
	kGObWh53JQWJcg05kyKwqnGLGlFfhIdHXNrFVMlUZgSl+eqKNtBVj2765xhjGR2TO5NsFyZ8qRl
	8jFaaaidsU6nkSIFl0VAvWAHa5dNs1Xtiy/UyE7tt+Bz/cMMRF5cPUOlmOxdH8Bim+dy8X/ZTnA
	fYM8y1R/GJNYRsnW4nh7db1LUyt5V4gQchICpm70csn3CjHjMvYV6wWCnIpVNzqwy442S8q8gPU
	E1ORxw9nP9+BcukBpInIrI8MccuLTovH09XGuaBv2EamoqC+uQWSIeZwNsIgg2AeO/8qPSWyztv
	w==
X-Received: by 2002:a05:620a:890c:b0:92e:c117:5ed6 with SMTP id af79cd13be357-930b4350ebdmr1533259585a.86.1784576135604;
        Mon, 20 Jul 2026 12:35:35 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:35 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 22/36] mm/mempolicy: add MPOL_F_PRIVATE and zonelist selection
Date: Mon, 20 Jul 2026 15:34:16 -0400
Message-ID: <20260720193431.3841992-23-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B4ADCC0009
X-Stat-Signature: ixh76rg3xap3ydigdskqaumr76skc9p6
X-HE-Tag: 1784576136-205435
X-HE-Meta: U2FsdGVkX1/6WhvVCLJ2CcxbXEw754P3a7a9wQeun+QaKBN/u/MZ/Dsqu1aWiNzSl7B+T7KWdHX0G35IcNxmW+Q/HRNr6regYIxjkc/dbsqizi+hJSGEqLfnJejf+eo0vM2HP1J2UaCFmP+S9c2EdRqFERqW16lUkCVp+/Op4rj8cHJMncvqd3nQs5c3eG3DlKfyk2mxBPmbhZDWwPzDdBzpPeDAzCbLYR7j2Gv4fcvBRdcXteup4OA1RIivE9ZEuR3QXDy5FYAQ7lPBHRI0j2tzNi+ceTTlwgjLk+h3i2abTSpDhiPkLGaX7EtoUASFrfP9eb1Z6cAMGmij9vVSvX5wZxf+K+zbpBKqZEmTAVqmM8Ol6etV+fZdRPLZ5XG1Gukc1EqI5YUzYME5745SmsWZx2ptih5f8d+eAhDxSPmT6AY/pAxdBwnrnqp0PO9Yi2iE5z30A6nDRbKtPrQOsCKMbgVhjtDPzGpkKmNiB5O+IAacDjB7pGLH4cvKdJmhjBclYoQLHYJo/HJz9cBXykaRayVrNiAllJBuPcOuybe4PwCFV1NLUK+d2qRV+bCluLbZsrrLBBHbaehD0j1q2vu5D6PN4exeC+1ZHFyaJnDyfUO6aD4v2UsXvKoDMr2pZ/J7BU0wIo8hxCIFxiOehGFCoDOQgRDSclBP60x+xjlYc0NeU95ur09wuozP9XQeIShIYON294wxa7JsmzKl+YLc2konN4Kfwwozqt3hLvhm6pjinvpXU599aF9su6r6GjY8o7OgIkPkJRv5JD+AMMQaIRXtFi5buMwab3Pwb0TIjsjdel8baPovvbQGaU4Qd3voXap+dDmfrpHFDNCpw1gtBvq4OTowEfUspBKscAzxV8JIYYjxct9YOHs20FcyDb9HEfMrcj+4yAiWYZWmU2bC9QMQ4TMAZ663w35lsZDiDKYEGkJ+4roqsXh4oriF5D4/mTwv/WaJeBHGkqS
 Rl0mw1bd
 c8jfqfwwBbhVXK7Shu18HeBTMZ7Abk6XOphedmEx0lmW3sdSREGrnQlOkXAqxniO0IQfBqY4IfE51B/MqakZ4mIbSVba1u2Mjt1ZMZLGrVgXDqJA9+vi6dLKIX/6IzhHxiQq6sNWwk3CVUjLgZW4PXveGSjdZbd9gj50pieaNHrYG1TGdSxF76EbgiIJLp2vvHPaweBhuhrP8LkJV9GCJ8vpt/0kVW8jcsg7c85Tvs3pxqW0e9cMGkqfwa0rhukdaUu2hANPOp6YZYNpBC5/5L/MpM304kLU2+p5yrJSkk3rtVZkHVxHOIqVwkUgYin4Im/G4VIK1vmq19qd0aEyp8nggkGjpLeRDAXrixJX4eK0XmGUhLV2h6sSKbIJ6FfVQ+Qrsju6C+/0csjGKnvBeGXpJ+n7lwoUySgYer+ygZMSgKgA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add MPOL_F_PRIVATE, the internal flag noting that a policy contains
a nodemask with a private node, and making private node memory
reachable via standard mempolicies.

Plumb zonelist selection into the mpol allocator interfaces via the
allocator's alloc_flags, using the alloc_flags-carrying page_alloc
interfaces.

mpol_alloc_flags() maps MPOL_F_PRIVATE to the alloc_flags an
allocation uses:
    ALLOC_DEFAULT            -  normal allocation
    ALLOC_ZONELIST_PRIVATE   -  private node allocation

With this, a VMA with (mpol->flags & MPOL_F_PRIVATE) can successfully
services faults like any other mbind() from the private node:

   buf = mmap(..., MAP_ANON);
   mbind(buf, ..., {private_node});
   buf[0] = 0xdeadbeef;  // Page faulted from private node memory

Like any other bind, the nodemask relaxes if it is unsatisfiable.

For example: apply_policy_zone() allows an unmovable allocation
targeting the VMA to fallback to a viable node instead of failing.

cpuset rebinding does not affect private nodes - the nodes in the
original mask are preserved, and we enforce two remap rules:

  1) never allow N_MEMORY nodes to remap to N_MEMORY_PRIVATE
  2) never remap N_MEMORY_PRIVATE nodes at all (they stay in place)

In the case of an empty nodemask as a result of rebind, revert to
cpuset - which never includes N_MEMORY_PRIVATE and always guarantees
at least one N_MEMORY node.

As of this patch, nothing can actually sets MPOL_F_PRIVATE, so this
is a no-op that simply adds the plumbing throughout mempolicy.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/uapi/linux/mempolicy.h |  1 +
 mm/mempolicy.c                 | 79 +++++++++++++++++++++++-----------
 2 files changed, 55 insertions(+), 25 deletions(-)

diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
index 7f6fc9599693b..87af18c84b947 100644
--- a/include/uapi/linux/mempolicy.h
+++ b/include/uapi/linux/mempolicy.h
@@ -67,6 +67,7 @@ enum mempolicy_mode {
 #define MPOL_F_SHARED  (1 << 0)	/* identify shared policies */
 #define MPOL_F_MOF	(1 << 3) /* this policy wants migrate on fault */
 #define MPOL_F_MORON	(1 << 4) /* Migrate On protnone Reference On Node */
+#define MPOL_F_PRIVATE	(1 << 5) /* nodemask contains private nodes */
 
 /*
  * Enabling zone reclaim means the page allocator will attempt to fulfill
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 2b76c57a460c9..90110e9761122 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -432,6 +432,10 @@ static int mpol_set_nodemask(struct mempolicy *pol,
 	else
 		pol->w.cpuset_mems_allowed = cpuset_current_mems_allowed;
 
+	/* If any private nodes left in the nodemask - add the private flag */
+	if (nodes_intersects(nsc->mask2, node_states[N_MEMORY_PRIVATE]))
+		pol->flags |= MPOL_F_PRIVATE;
+
 	ret = mpol_ops[pol->mode].create(pol, &nsc->mask2);
 	return ret;
 }
@@ -505,22 +509,33 @@ static void mpol_rebind_default(struct mempolicy *pol, const nodemask_t *nodes)
 
 static void mpol_rebind_nodemask(struct mempolicy *pol, const nodemask_t *nodes)
 {
-	nodemask_t tmp;
+	nodemask_t tmp, priv;
+
+	/* preserve online private nodes to re-add later */
+	nodes_and(priv, pol->nodes, node_states[N_MEMORY_PRIVATE]);
 
 	if (pol->flags & MPOL_F_STATIC_NODES)
 		nodes_and(tmp, pol->w.user_nodemask, *nodes);
-	else if (pol->flags & MPOL_F_RELATIVE_NODES)
-		mpol_relative_nodemask(&tmp, &pol->w.user_nodemask, nodes);
-	else {
+	else if (pol->flags & MPOL_F_RELATIVE_NODES) {
+		/* fold only the public part: a private node must not take a slot */
+		nodes_and(tmp, pol->w.user_nodemask, node_states[N_MEMORY]);
+		mpol_relative_nodemask(&tmp, &tmp, nodes);
+	} else {
 		nodes_remap(tmp, pol->nodes, pol->w.cpuset_mems_allowed,
 								*nodes);
 		pol->w.cpuset_mems_allowed = *nodes;
 	}
 
-	if (nodes_empty(tmp))
+	/* private nodes are identity-mapped during remap, drop them here */
+	nodes_and(tmp, tmp, node_states[N_MEMORY]);
+	if (nodes_empty(tmp) && nodes_empty(priv))
 		tmp = *nodes;
 
-	pol->nodes = tmp;
+	/* If any online private nodes remain, add them back */
+	nodes_or(pol->nodes, tmp, priv);
+	/* If no online private nodes remain, strip the private flag */
+	if (nodes_empty(priv))
+		pol->flags &= ~MPOL_F_PRIVATE;
 }
 
 static void mpol_rebind_preferred(struct mempolicy *pol,
@@ -2411,7 +2426,8 @@ bool mempolicy_in_oom_domain(struct task_struct *tsk,
 }
 
 static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
-						int nid, nodemask_t *nodemask)
+						int nid, nodemask_t *nodemask,
+						unsigned int aflags)
 {
 	struct page *page;
 	gfp_t preferred_gfp;
@@ -2425,14 +2441,21 @@ static struct page *alloc_pages_preferred_many(gfp_t gfp, unsigned int order,
 	preferred_gfp = gfp | __GFP_NOWARN;
 	preferred_gfp &= ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
 	page = __alloc_frozen_pages_noprof(preferred_gfp, order, nid, nodemask,
-					   ALLOC_DEFAULT);
+					     aflags);
 	if (!page)
 		page = __alloc_frozen_pages_noprof(gfp, order, nid, NULL,
-						   ALLOC_DEFAULT);
+						     aflags);
 
 	return page;
 }
 
+/* A private policy allocates from the private zonelist. */
+static inline unsigned int mpol_alloc_flags(struct mempolicy *pol)
+{
+	return (pol->flags & MPOL_F_PRIVATE) ? ALLOC_ZONELIST_PRIVATE :
+					       ALLOC_DEFAULT;
+}
+
 /**
  * alloc_pages_mpol - Allocate pages according to NUMA mempolicy.
  * @gfp: GFP flags.
@@ -2448,11 +2471,13 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 {
 	nodemask_t *nodemask;
 	struct page *page;
+	unsigned int aflags = mpol_alloc_flags(pol);
 
 	nodemask = policy_nodemask(gfp, pol, ilx, &nid);
 
 	if (pol->mode == MPOL_PREFERRED_MANY)
-		return alloc_pages_preferred_many(gfp, order, nid, nodemask);
+		return alloc_pages_preferred_many(gfp, order, nid, nodemask,
+						  aflags);
 
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    /* filter "hugepage" allocation, unless from alloc_pages() */
@@ -2476,7 +2501,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 			 */
 			page = __alloc_frozen_pages_noprof(
 				gfp | __GFP_THISNODE | __GFP_NORETRY, order,
-				nid, NULL, ALLOC_DEFAULT);
+				nid, NULL, aflags);
 			if (page || !(gfp & __GFP_DIRECT_RECLAIM))
 				return page;
 			/*
@@ -2488,7 +2513,7 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 		}
 	}
 
-	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask, ALLOC_DEFAULT);
+	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask, aflags);
 
 	if (unlikely(pol->mode == MPOL_INTERLEAVE ||
 		     pol->mode == MPOL_WEIGHTED_INTERLEAVE) && page) {
@@ -2597,6 +2622,7 @@ static unsigned long alloc_pages_bulk_interleave(gfp_t gfp,
 		struct mempolicy *pol, unsigned long nr_pages,
 		struct page **page_array)
 {
+	unsigned int aflags = mpol_alloc_flags(pol);
 	int nodes;
 	unsigned long nr_pages_per_node;
 	int delta;
@@ -2610,14 +2636,14 @@ static unsigned long alloc_pages_bulk_interleave(gfp_t gfp,
 
 	for (i = 0; i < nodes; i++) {
 		if (delta) {
-			nr_allocated = alloc_pages_bulk_noprof(gfp,
-					interleave_nodes(pol), NULL,
+			nr_allocated = __alloc_pages_bulk_noprof(gfp,
+					aflags, interleave_nodes(pol), NULL,
 					nr_pages_per_node + 1,
 					page_array);
 			delta--;
 		} else {
-			nr_allocated = alloc_pages_bulk_noprof(gfp,
-					interleave_nodes(pol), NULL,
+			nr_allocated = __alloc_pages_bulk_noprof(gfp,
+					aflags, interleave_nodes(pol), NULL,
 					nr_pages_per_node, page_array);
 		}
 
@@ -2632,6 +2658,7 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
 		struct mempolicy *pol, unsigned long nr_pages,
 		struct page **page_array)
 {
+	unsigned int aflags = mpol_alloc_flags(pol);
 	struct weighted_interleave_state *state;
 	struct task_struct *me = current;
 	unsigned int cpuset_mems_cookie;
@@ -2667,8 +2694,8 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
 	weight = me->il_weight;
 	if (weight && node_isset(node, nodes)) {
 		node_pages = min(rem_pages, weight);
-		nr_allocated = __alloc_pages_bulk(gfp, node, NULL, node_pages,
-						  page_array);
+		nr_allocated = __alloc_pages_bulk_noprof(gfp, aflags, node,
+						  NULL, node_pages, page_array);
 		page_array += nr_allocated;
 		total_allocated += nr_allocated;
 		/* if that's all the pages, no need to interleave */
@@ -2732,8 +2759,8 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
 		/* node_pages can be 0 if an allocation fails and rounds == 0 */
 		if (!node_pages)
 			break;
-		nr_allocated = __alloc_pages_bulk(gfp, node, NULL, node_pages,
-						  page_array);
+		nr_allocated = __alloc_pages_bulk_noprof(gfp, aflags, node,
+						  NULL, node_pages, page_array);
 		page_array += nr_allocated;
 		total_allocated += nr_allocated;
 		if (total_allocated == nr_pages)
@@ -2750,17 +2777,19 @@ static unsigned long alloc_pages_bulk_preferred_many(gfp_t gfp, int nid,
 		struct mempolicy *pol, unsigned long nr_pages,
 		struct page **page_array)
 {
+	unsigned int aflags = mpol_alloc_flags(pol);
 	gfp_t preferred_gfp;
 	unsigned long nr_allocated = 0;
 
 	preferred_gfp = gfp | __GFP_NOWARN;
 	preferred_gfp &= ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
 
-	nr_allocated  = alloc_pages_bulk_noprof(preferred_gfp, nid, &pol->nodes,
-					   nr_pages, page_array);
+	nr_allocated  = __alloc_pages_bulk_noprof(preferred_gfp, aflags,
+					   nid, &pol->nodes, nr_pages, page_array);
 
 	if (nr_allocated < nr_pages)
-		nr_allocated += alloc_pages_bulk_noprof(gfp, numa_node_id(), NULL,
+		nr_allocated += __alloc_pages_bulk_noprof(gfp, aflags,
+				numa_node_id(), NULL,
 				nr_pages - nr_allocated,
 				page_array + nr_allocated);
 	return nr_allocated;
@@ -2796,8 +2825,8 @@ unsigned long alloc_pages_bulk_mempolicy_noprof(gfp_t gfp,
 
 	nid = numa_node_id();
 	nodemask = policy_nodemask(gfp, pol, NO_INTERLEAVE_INDEX, &nid);
-	return alloc_pages_bulk_noprof(gfp, nid, nodemask,
-				       nr_pages, page_array);
+	return __alloc_pages_bulk_noprof(gfp, mpol_alloc_flags(pol), nid,
+						nodemask, nr_pages, page_array);
 }
 
 int vma_dup_policy(struct vm_area_struct *src, struct vm_area_struct *dst)
-- 
2.53.0-Meta


