Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AD55CCA462
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 23:13:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AFFD6B0095; Thu, 15 Oct 2026 19:13:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6600C6B0096; Thu, 15 Oct 2026 19:13:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54FB16B0098; Thu, 15 Oct 2026 19:13:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A9DA6B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:13:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9DFA9A023B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:13:27 +0000 (UTC)
X-FDA: 85326414054.07.D2F8F03
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id D622B1C0003
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:13:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IQnxwjSY;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792106005;
	b=Xul2Na+VTFOwhPXX+U/tCMixVpd2dAC+r6ToV1+v/S0uOYTkoD98ZD5cM1hGfCJk2R+ZRr
	SCXUR6MA5vN/n8mX6PhaY+5rsCsfLs/a5gGJUQgQcyUG2Ey5CXPED1k+1bEk/hBJ2pbrFu
	3YMlSmJByaDQuqmDmZKE8SXo4VB99Yw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IQnxwjSY;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792106005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dAaIZ7hoQbW4Z60fNlL2ubqoX4QsjqbaZoJuPxq8vJY=;
	b=L9Tb95pTECQ+PJiWuzZpirJxgcfQxRKn0vQWDjt0mvYvNfmxR8NBHDuCy20IcgSM/BSwdP
	9RSBwFJdWWU5o5eO9Dbz7Bdxeb72lwPzom7nNwtOS5J9Vi/VN2DMybepAca4k136srW9nq
	yLy6kOlwEerx5awcI+1mQnnglr62SsA=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-533861a59b8so21902561cf.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792106005; x=1792710805; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dAaIZ7hoQbW4Z60fNlL2ubqoX4QsjqbaZoJuPxq8vJY=;
        b=IQnxwjSYSdGxPZguwfouWZF5BEGfKV5M5zbR+bqXEHnnwlHgUzuVIkZw9Qzw7a5avI
         Ka/9meUA476a4etXQt1t/HCA3oqIYW7d9cZ3IpjQpGdfFI9B9pxx+MSU9Ng22BqzBS0A
         nh5IaC5EWSS8lBtM+kzuPLXEJ6jibHTVoHM/BNI73IG8a/n8j+hqHTBcJDpz4dGZ9nVd
         hwIgYuCWhVgkJbDCP4v8WduuvmPicfbmPDj6bnXYA7iwnq3Urd73sZWmDVF4D9NovlpA
         F8Ak1n1ufWmubYaQOYWYoqDuJyoT+mNyAzwouDDCTpckiGpCIc0KkLvVkKWs9ymI/Muw
         Vdzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792106005; x=1792710805;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dAaIZ7hoQbW4Z60fNlL2ubqoX4QsjqbaZoJuPxq8vJY=;
        b=I+OvnrzWFU7NRBURUmR0fg4DzKDTNfOUYDIjc0Q2+ASaZYF0IvCSdtkYGUX5ymsXaK
         uQQtXezuZ/HJ9X/dxrTRPwhu6+ClsuO5VSqrmEcQRHmpp5+pdKYKkuaW5UI9rgkP5vwW
         bbGBYrjq0D+XzzvqJCJ+Nwt1A6R9Dcs7KeRcHbGJV17eKrAHlQ7ZE6ptvXczzeLHquCa
         0zRT+tGvvGs2kLxPnk+BCmOIlMc/5iIQBYN78EJx+IHOxq3GJpIHvieew1tqHNGaXl7F
         ki5/lXDa5k+s72ZLGRQB0uU4Cm//V8LBt/U58Cqz5Lrpud6YHHjkRZE0XivFg6iY5QzV
         7kiw==
X-Gm-Message-State: AFq9FYKUmO2holGyjc+GqElNHsP1Vbp4CJQU+UUDf8SVcfRL8j6k/tct
	E1MWo9059XFDUkDgKj/mnQXkHNdp7j2IJjV/xifJIs392nlGy8VYTSCYEjB82QpJsAGrqRazw6x
	Yi2gtXpU=
X-Gm-Gg: AYBFou2cP2IpCwpL11UPqpFu+wsaZLrf0ByqLvXtLnoTG2W+Gl80d0rDOaZUfP8aFXR
	6aL8wTae4sPxqL/9k/JNTlN0yGHWytHAN9B4urLDkHisTCd1f0rey57JRMXeY8J1qrK19efynte
	fGhhe0eW2g7tsnV/IdSBGK9lfMYRLRuqSj51jbRVJlvxCYIeOWPVJpiGvCXiG1gkKP+tQjjh0BM
	AfKj2D7a9p8X/mNCMoJ1tt4l1kEI04j+loQMvz9+ikjEqQ2i8g3h53uwNTqFhP5fBYoLH1aReg7
	DVhPjZbQVeWhTWTGAG1QrXW1lwOniUsyLo9RDOIj61Jk/pwZaqhkoJvEMePI4P41cXEZiPPVfUP
	qUvARiRzq0v61l3ARuzQ1GNnMZ1dD1QXInc0BuYauFU3NKuzyZoBgIciI/5uy4X9ni2+6Gjkwtn
	zlXq5Hzxajk25QOdHkbfNfpECmvBwCH+yIioHfp5HQpNWCkXawhDYORPk7SNG2sX84TbC++ipQ/
	m3lNRcRY+KxRCIjIhjzll98DvtxNcQcpQicVHbZ7ukUKkyLWbIJmzPir2yz
X-Received: by 2002:a05:622a:a0c:b0:516:ed02:c85d with SMTP id d75a77b69052e-5359f46e1e4mr316611731cf.3.1792106004967;
        Thu, 15 Oct 2026 16:13:24 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5362a9637a7sm6256501cf.14.2026.10.15.16.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 16:13:24 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] mm/mempolicy: convert mempolicy refcnt to refcount_t
Date: Thu, 15 Oct 2026 19:13:22 -0400
Message-ID: <20261015231322.3392551-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D622B1C0003
X-Stat-Signature: mt4raxu98649bp9m88g3rqkzw9u8tyk9
X-HE-Tag: 1792106005-86568
X-HE-Meta: U2FsdGVkX18TpEZFnLn849rXgQvd/Jcnqsayb0Ld/1chwntEqosavaoIEoz2R61TbCZP0nkuxyWpCk6XwWHxNn+/ID7hEKreZIhCrv23jIRe5hsk8IprTrHeRyBlsF8HTG5tZi1EtWw88NuPhogwd7FykX9g1OvM+FXKhafWbOpnG7y50y6QbusaHllvm6We+tJrqM3L9H5iOcPXU+DLKCmdNNLqJG7cH1+C5drQz0nSeFr14BBUVpVirV418ynuHDpBPv7iDLvzOdZWGeubZeB99Y2JQh7Wfisfp8rmb+pWxaWJy+vFShuH1NIHyRoc4vBcSmrqZxvrMjDUcF/mMQXNrrZjMbX7IZrGKCadMb5+tm4KwN2MF4VOAsYYtcf9WiLFTj7cLh/cdMfNqILwMt+gcB6nCCjkPTmN9ISS8d9YR7EnQ3EmAmYov8zkLU875RbxGQGBxcBTPE4jx+dlwCmNI1bcDC66WBJvRAzA0Wrdw8wqnVHyPQDg2s7ejb+SRisVFZ874cuQ3SseEf17O3T2ZkziKqamGrO/TqUbxI7TU776HR+I0HkFJMdzosM2xspoQEB+T/sEw3Qt7c7ZRfJIYiDgiIecOGdjdjE4xYj53tB8/7ZGIgHd7/1P+FndR9eo02OM6mMN2f2UJcXDjYycskcSzuZdJryd1ydnyX4jGbtya/F5fxQUxUe+wh51KSGnzb/kcrvxrF2d8zIJJDIS5AIaj9/oNTO/YDkaQhjAVXYQ8V9lWyj82W/2Y9+pBR85g2ZUu462ZcWFOnBiRIUOrWHoeNb2o/bC030UrRtCwbKj1DD2g3/Wn2pmV2CBuwYmMwK/s8xvKiVu50hCMxaTHi9snenWSN+U2uh2z4Se78VgnBhOA5dLzncmnW1O/5nH/cBSObJiukWY7dQb7xZJafNrlQTK2mbRmCiYvjZA1AKyveXabwfz1vJSS4d7p15AW0tKj7j2Z9xJXc2
 xb2IB9on
 pVaQXaRI3K9jAYtTWjir9noW36pbCPtdI4xDDisA2raxpEhFhrgNRNlfPKw/F2l0KLqT3d2HfK8lwWgRI2oVVEJHHqoKoUPMDik6+wxg6WBK7lZiP9Tan+dkkdYWF+I92pkWKrg8eSd7AwJiHVfQhDnBzgg6LNcPMzEDJVvIIPxGTlGbdWPbn5li080I/ZBjX0rGtB5e4joqDMdrytn4M8mm3vaYt5KDp8OHBZFwrstk/A5vHRYUdpRD2dYnDalpQL7hNGzm45YTPs9dECJ4suZ9GN2mno1rQWJPADPmWUOx1ijLxEYJezSjAIrhk4w3nLYGk0r9a+6RiZbW2Y+PsSdKbCgDOZFe6zY+txgrXUub8ZKLadWSs3L41uh9XMrpjeM4uZuQcnCc3N1g9z3thC053gWbNSc08pNOYRW62QG64BlNmJSCzFVmj+AqgeY818Ju0wJPGFaNNPNlA9NzN38Os6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

struct mempolicy uses an atomic_t as a pure reference counter.

Convert it to refcount_t so that overflow and underflow are caught
by the refcount saturation checks.

This silences the atomic_as_refcounter.cocci warning, which started
matching __mpol_put() when it switched kmem_cache_free() to kfree_rcu().

No functional change for correct callers.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610061946.Bx22ZFrw-lkp@intel.com/
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/mempolicy.h |  5 +++--
 mm/mempolicy.c            | 14 +++++++-------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 65c732d440d2..8b7570a90e54 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -10,6 +10,7 @@
 #include <linux/mmzone.h>
 #include <linux/slab.h>
 #include <linux/rbtree.h>
+#include <linux/refcount.h>
 #include <linux/spinlock.h>
 #include <linux/node.h>
 #include <linux/nodemask.h>
@@ -45,7 +46,7 @@ struct mm_struct;
  * to 1, representing the caller of mpol_dup().
  */
 struct mempolicy {
-	atomic_t refcnt;
+	refcount_t refcnt;
 	unsigned short mode; 	/* See MPOL_* above */
 	unsigned short flags;	/* See set_mempolicy() MPOL_F_* above */
 	nodemask_t nodes;	/* interleave/bind/preferred/etc */
@@ -96,7 +97,7 @@ static inline struct mempolicy *mpol_dup(struct mempolicy *pol)
 static inline void mpol_get(struct mempolicy *pol)
 {
 	if (pol)
-		atomic_inc(&pol->refcnt);
+		refcount_inc(&pol->refcnt);
 }
 
 extern bool __mpol_equal(struct mempolicy *a, struct mempolicy *b);
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 70298fded1b4..7c78c66f7f21 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -138,7 +138,7 @@ enum zone_type policy_zone = 0;
  * run-time system-wide default policy => local allocation
  */
 static struct mempolicy default_policy = {
-	.refcnt = ATOMIC_INIT(1), /* never free it */
+	.refcnt = REFCOUNT_INIT(1), /* never free it */
 	.mode = MPOL_LOCAL,
 };
 
@@ -492,7 +492,7 @@ static struct mempolicy *mpol_new(unsigned short mode, unsigned short flags,
 	policy = kmem_cache_alloc(policy_cache, GFP_KERNEL);
 	if (!policy)
 		return ERR_PTR(-ENOMEM);
-	atomic_set(&policy->refcnt, 1);
+	refcount_set(&policy->refcnt, 1);
 	policy->mode = mode;
 	policy->flags = flags;
 	policy->home_node = NUMA_NO_NODE;
@@ -503,7 +503,7 @@ static struct mempolicy *mpol_new(unsigned short mode, unsigned short flags,
 /* Slow path of a mpol destructor. */
 void __mpol_put(struct mempolicy *pol)
 {
-	if (!atomic_dec_and_test(&pol->refcnt))
+	if (!refcount_dec_and_test(&pol->refcnt))
 		return;
 	/*
 	 * Required to allow mmap_lock_speculative*() access, see for example
@@ -2871,7 +2871,7 @@ struct mempolicy *__mpol_dup(struct mempolicy *old)
 		nodemask_t mems = cpuset_mems_allowed(current);
 		mpol_rebind_policy(new, &mems);
 	}
-	atomic_set(&new->refcnt, 1);
+	refcount_set(&new->refcnt, 1);
 	return new;
 }
 
@@ -3188,7 +3188,7 @@ static int shared_policy_replace(struct shared_policy *sp, pgoff_t start,
 					goto alloc_new;
 
 				*mpol_new = *n->policy;
-				atomic_set(&mpol_new->refcnt, 1);
+				refcount_set(&mpol_new->refcnt, 1);
 				sp_node_init(n_new, end, n->end, mpol_new);
 				n->end = start;
 				sp_insert(sp, n_new);
@@ -3224,7 +3224,7 @@ static int shared_policy_replace(struct shared_policy *sp, pgoff_t start,
 	mpol_new = kmem_cache_alloc(policy_cache, GFP_KERNEL);
 	if (!mpol_new)
 		goto err_out;
-	atomic_set(&mpol_new->refcnt, 1);
+	refcount_set(&mpol_new->refcnt, 1);
 	goto restart;
 }
 
@@ -3380,7 +3380,7 @@ void __init numa_policy_init(void)
 
 	for_each_node(nid) {
 		preferred_node_policy[nid] = (struct mempolicy) {
-			.refcnt = ATOMIC_INIT(1),
+			.refcnt = REFCOUNT_INIT(1),
 			.mode = MPOL_PREFERRED,
 			.flags = MPOL_F_MOF | MPOL_F_MORON,
 			.nodes = nodemask_of_node(nid),
-- 
2.56.0


