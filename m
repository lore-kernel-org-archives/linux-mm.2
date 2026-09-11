Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5000CC88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 22:15:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AD7E6B0092; Fri, 11 Sep 2026 18:15:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55F446B0093; Fri, 11 Sep 2026 18:15:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49B236B0095; Fri, 11 Sep 2026 18:15:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2062E6B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:15:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5D6D540370
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 22:14:58 +0000 (UTC)
X-FDA: 85202887476.30.BA7505B
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8AF2680003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 22:14:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=enP2ZZaU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of yury.norov@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=yury.norov@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789164896;
	b=xNm8qVMiN1BPO2ySmsnsC0F2itOfh/SSVn2HICY/C1/pODKfelOG+Do9F37N76mlm8DYpU
	SLprMOaR3/mALoYtk/wPofoWXMOslFIo20k+cfDEkJHTiBdP/DQVZtg9rkM2cDKA/coD6T
	2oucuIMnFt5zoXS6d16KS1KMPA1Krdo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=enP2ZZaU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of yury.norov@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=yury.norov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789164896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SryPbedwt+PB/tIiQ1DKQcYvegcDPhcxT20I1ilZbIQ=;
	b=zc3vXglqL3QHkG+ru29atd4wKgZPi4B6bLPwz7yjOjEo/WBpj89wceY46PJphok53HwHtr
	ySt2oyg6VJenaBura0X0XxWe0LZhouSCQzi7SRqUs1XfnZWFIHGi44cAWDTeAbgkP+G8Z+
	rlBUeJmm0z/QKQfHE/xhRCD3bSVCx1Y=
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d747f01363so399285ad.2
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789164895; x=1789769695; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SryPbedwt+PB/tIiQ1DKQcYvegcDPhcxT20I1ilZbIQ=;
        b=enP2ZZaUPq0RTlMWSp0om+BI6syejRlqhzqYiLki9QzHT+HiSxLvO4Eq5qDnNYE6Fj
         QE7P1S3K/NGFWZHy++/LfTZ25mlmBJrUvwr9J6L/ZjYIJAfF/GL2nljY2VoMpIHrmfbE
         y78JILNd6WylnoXQ67dmFJX9eMEkryKKRWx27Sw0ANn0AUIv4d9hCmwSV1YTBQoG3Nlb
         txKVRTs+1GiJQeRs/faLy+xO2eo4IArN2S7RndUpTuEyvVl8JZN7UfxRLS5toOxK3Oud
         9yK05STu6nLyqyWMJhA564l8Bfbal3YJpD1b+4xNUCXgZacgEQklLZL2XUfF6TBy9HTl
         3MRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789164895; x=1789769695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SryPbedwt+PB/tIiQ1DKQcYvegcDPhcxT20I1ilZbIQ=;
        b=d48xAY5gUA62/KoSUAN/NomN+Juxgk3u+1zH0eRp1/E9OlFkMPLCvw2xvUTYd5BJac
         mFapxYLF6rKRPTNdF4azCHzHKWwU6hRTpkdHINys3c9hEgYu4OQjCkKLob+XnBaJKaCF
         nE1mN7hZZo3J3gfsmOrzInsdRmn+iVoazzFy3yqdaiQ4OcpIQtoK9nx+QiRg6WXI2eyT
         DzmhxBBRw+fOiAJqF3s9ML81dQMWEahoXuAb7+gNVVBj1rfevEp/3ss6JVMDzgrJKiWg
         hq59FYX4E+6Ph1YxO3JKoLqDciToEdBbFHvCDSjDj7aGqo+A61StNZs5bnofOhhXkdje
         iyYA==
X-Forwarded-Encrypted: i=1; AKwUvByxaYjnUGzSy9Oqz5V9jOq+YmteVgEUEWf/8sT2piUAzQ6Nv3aQ1zm1KNWK+LPk20W2Yn8zU0d5NQ==@kvack.org
X-Gm-Message-State: AFuF++nQJxBAC9Q7R8CWtRXQlfwDpuFI5TjoWKEhWDmNuYO834GqfiMb
	qf9tTLICHjP4vLK5LW2gAgp/IoBbbb9ImaQ4+Ev1a8JpiqgxeNkZkMaW
X-Gm-Gg: AYBFou31NxfsvChokNr3zahundV8UVfiY+SkuZ+GEjcln4cSsvIwmp2kq+dUNJ8fN79
	NJKwDrS9zkmfZHxgbnfIV4fNSDp+luJt23G2Jkl9zw0AD9pCBQA5SpO8zCC7icp3DdzbLY6wcZi
	x+fRdq7IjMUYCEfqhKwTpoEyl6y0JJ3f+/c80vZ6qQtwe/UZFBkCH+pD80TTyQZYfCFpZmlJwgx
	fmnD/0hjgbFdwyLLwH9Kbe9mOdnoQQJA0Y0fZDTCQUwb95YjFZ/anPPq3ir6zmoJTwk1O5cJtZw
	NvsDMcSxO3inQvTDgHstjtWFLlGJyhwNWZ9ahpa1vOsjiQUvYRoDB4DEdCPpZOc6znGp6SoonCi
	Ap0pe8U+lDThtCONa+J1cf+ENiQpk5/bXp0xgGWKeBmKcGAWmsOo001PUFSLK/XTIK1Q16xu79t
	fPyM1phWvxa1aPVT1zCazn6eT7GNKxyPHude3Jl2hnBxoHvC6Lv7XuJiXhpC112lok/+4=
X-Received: by 2002:a17:90b:4c0d:b0:38e:b400:a860 with SMTP id 98e67ed59e1d1-39dbc6a3e56mr392229a91.13.1789164895357;
        Fri, 11 Sep 2026 15:14:55 -0700 (PDT)
Received: from localhost ([216.228.127.128])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14365ba71cesm8971595c88.13.2026.09.11.15.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 15:14:54 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
X-Google-Original-From: Yury Norov <ynorov@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	"Liam R. Howlett" <liam@infradead.org>
Cc: Yury Norov <ynorov@nvidia.com>,
	Chris Li <sparse@chrisli.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Yury Norov <yury.norov@gmail.com>,
	linux-sparse@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	maple-tree@lists.infradead.org
Subject: [PATCH 3/3] maple_tree: assert static storage for DEFINE_MTREE()
Date: Fri, 11 Sep 2026 18:14:43 -0400
Message-ID: <20260911221444.1523311-4-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260911221444.1523311-1-ynorov@nvidia.com>
References: <20260911221444.1523311-1-ynorov@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8AF2680003
X-Stat-Signature: jx1rq4zzkd6575rwd3btawg4hfsqgpez
X-HE-Tag: 1789164896-721076
X-HE-Meta: U2FsdGVkX1/Y/SVRRRV+E2J1g1P9nLyg6DZOyI/5icictgWMaSZgaqAMniPQbwNQLW1aTkbSBrO/rVQyXbjRQVxje8/vVBEtqzjqrX4aTdE1jjZhAWymuBMuvOlmoJ9p1UYZXaNsS8cW+BCSbGfThUFbJw+5mae6C0O5JJxwKnFvq15BOfT0Zya7HRlJ15F+SLvdrRNGuxs0DvCqjltzC0Px+PJgFoY9V7edrX0QPFw2LqaP++91eYtOQtcnXhzfm4HTcmpQkh0Vmo8CIkvIxrUoz4/BaKjGXTwMC4QnTQ6GewReFnSklbT1PWYRBIk8NNGH5hOoQMJVq9+Nq4YWWGQWFiJ9B9sLHT/48dLT8vZ4mBvff4uuKQkDs2pEO6S6lFNfqGtWaiMwRIBGONAwG0wqXbKfQ6DUdmHOxa2d28QZaiC92h+bi+Gmfd+u6LmCMRF51H6a1REEh5DMzMl8i/ffMF1AXIbJPOTiSQoIlvJ0USgy/TYOtLsPYfXbolv2Jazx1yDs6Bn06CGk7rGcSbTOyo9pROI4k22y39O2C++a8rut1q6N8Dy3Cqck7VWgjeL2BuzZQcJGOPkNN21FAWXMnuJqp1nZAbMsKMfxe0CA4PaTpW9d6CsJHSwVVPGh5FXDNt4R/gC3ZAyFwc8XJD0Ts1mhyF4awOM5TEC2Yy26wRbBvOuWTUwZnbSWqbmcHz1yoFmc9psiPMXxWo5lW4YOrU/YXD/MnxX942L1Sl9SAqhRHEb1ypA75FUI6ZXhUe9u42U193qFyCzsRXjXHMgaRmT8Su/f9ukMR/eLVrEqaLWZkc9NsNY44InXz/C75EzCOIi1nMFrQgwGVFIeJEBAJejEc1X77faVMLYaVDr84TK+gA6nw6MSj7UCxZlBi7K6IwiwQTBBuhO3bruNeDYkdTDCeunJWCMjnrFmzaDNRbAuwWafL0j451E0bPVWf4mXNPVUKBCEYKkNci2
 Z9GznxZY
 bcbEQriDOqN/56wpNE2lJ3xKN40QfSyZoA4KjlGZQGexoue9oQQcl/DwI7FWKFEpc0sB4TYGECpILfUvJRPS3/kl2b+zbRRMUMKYnJf15yT5TId50v+E/dl7n1ycjUui8ySUR3CQxj+qp1YQfenmni1mVcbT6Y4mMRSpNiFwI+MwzRGRYxYkN/2/+R5HqytMmJ4jvd5KFtXcIY7JmvSJt0zbAf6di3H6zcN8PKk5aW+siNEe3r83pZoF6VTiC/JumzxiXC8EnsLonDzGrw/Be8M5rP/WI0pUfPx8T0hihIGNiR6i487u/vMbPwoypSWidvH40hQlKBRPKIb04q/omCn+b2TPs5gbYeLlcaPguenH3xMtNAGKPGP7z9+LVoQrr+dS1l1iL/6npuC2xpxUwAqTprvKugos1kHtbieZN1dzvqOhqojxJC8LsobHZsGHpWiU3d/SEGfmM5YjCxRc9Ku6/SDs7txvVeiDxNAHvtLQuJDAF5LUzQbBaZjZl5CkYfWCirbVCeq178yutd031do+04u8or0+VDP8eruakhN+TNziiC+Bvzp5dgi5DntCDWNCmiFDgGLOWON8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DEFINE_MTREE() uses MTREE_INIT(), which initializes the tree's embedded
lock with a static spinlock initializer. If the tree is an automatic
local object, lockdep rejects its address as a non-static class key and
disables locking validation on the first lock acquisition.

Apply ASSERT_STATIC_STORAGE() to DEFINE_MTREE() to catch automatic
local definitions at compile time. For example:

  void example(void)
  {
          DEFINE_MTREE(mt);
          mtree_destroy(&mt);
  }

GCC reports:

  error: initializer element is not constant
    name##_storage_check = &(name)
                           ^
  note: in expansion of macro 'ASSERT_STATIC_STORAGE'
    ASSERT_STATIC_STORAGE(name)
  note: in expansion of macro 'DEFINE_MTREE'
    DEFINE_MTREE(mt);

File-scope definitions and static local trees remain valid. Automatic
local trees must instead use mt_init() or mt_init_flags(). Direct uses of
MTREE_INIT() and MTREE_INIT_EXT() are unchanged.

Replace the local DEFINE_MTREE() in the interval-tree span test with a
plain declaration; the test already initializes the tree with
mt_init_flags() before use. Convert the three local Maple Trees in the
userspace radix-tree tests to mt_init().

Validated file-scope and static local definitions with a kernel object
build, and confirmed that an automatic local definition fails to compile.
The Maple Tree test and region allocation benchmark objects also build
with lockdep enabled.

Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 include/linux/maple_tree.h       |  4 +++-
 lib/interval_tree_test.c         |  2 +-
 tools/testing/radix-tree/maple.c | 12 +++++++++---
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index e595ae5cd0ee..e30e57f5f3df 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -9,6 +9,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/compiler.h>
 #include <linux/rcupdate.h>
 #include <linux/spinlock.h>
 
@@ -297,7 +298,8 @@ struct maple_tree {
 #endif
 
 #define DEFINE_MTREE(name)						\
-	struct maple_tree name = MTREE_INIT(name, 0)
+	struct maple_tree name = MTREE_INIT(name, 0);		\
+	ASSERT_STATIC_STORAGE(name)
 
 #define mtree_lock(mt)		spin_lock((&(mt)->ma_lock))
 #define mtree_lock_nested(mas, subclass) \
diff --git a/lib/interval_tree_test.c b/lib/interval_tree_test.c
index b0b07270ce7c..06f77fb3179f 100644
--- a/lib/interval_tree_test.c
+++ b/lib/interval_tree_test.c
@@ -244,7 +244,7 @@ static int span_iteration_check(void)
 	unsigned long start, last;
 	struct interval_tree_span_iter span, mas_span;
 
-	DEFINE_MTREE(tree);
+	struct maple_tree tree;
 
 	MA_STATE(mas, &tree, 0, 0);
 
diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index d967e76a3c06..bfe4b8626c42 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -36022,10 +36022,12 @@ static noinline void __init check_erase_rebalance(struct maple_tree *mt)
 
 static noinline void __init check_mtree_dup(struct maple_tree *mt)
 {
-	DEFINE_MTREE(new);
+	struct maple_tree new;
 	int i, j, ret, count = 0;
 	unsigned int rand_seed = 17, rand;
 
+	mt_init(&new);
+
 	/* store a value at [0, 0] */
 	mt_init_flags(mt, 0);
 	mtree_store_range(mt, 0, 0, xa_mk_value(0), GFP_KERNEL);
@@ -36319,7 +36321,9 @@ static inline int check_vma_modification(struct maple_tree *mt)
 void farmer_tests(void)
 {
 	struct maple_node *node;
-	DEFINE_MTREE(tree);
+	struct maple_tree tree;
+
+	mt_init(&tree);
 
 	mt_dump(&tree, mt_dump_dec);
 
@@ -36432,9 +36436,11 @@ static unsigned long get_last_index(struct ma_state *mas)
 static void test_spanning_store_regression(void)
 {
 	unsigned long from = 0, to = 0;
-	DEFINE_MTREE(tree);
+	struct maple_tree tree;
 	MA_STATE(mas, &tree, 0, 0);
 
+	mt_init(&tree);
+
 	/*
 	 * Build a 3-level tree. We require a parent node below the root node
 	 * and 2 leaf nodes under it, so we can span the entirety of the right
-- 
2.53.0


