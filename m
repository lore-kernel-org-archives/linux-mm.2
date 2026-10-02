Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07488CA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 23:11:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09E436B008C; Fri,  2 Oct 2026 19:11:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 000586B0098; Fri,  2 Oct 2026 19:11:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE35A6B0095; Fri,  2 Oct 2026 19:11:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B58636B008C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:11:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 502C84059D
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 23:11:36 +0000 (UTC)
X-FDA: 85279234992.07.14AE77B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 83607180003
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 23:11:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XpAS0XK9;
	spf=pass (imf16.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790982694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ck6iL+D5JVu4WQzD8eBQ/ax4Rj5EDM29htDBOrwkdSs=;
	b=nPJJ6t4sOuzKCPyLDkcSzD9f15/WVVtlFYdo5DJpeuXCaFIM8AdVqh8RlbNr2la3CYdQZb
	JONtjURNhM5L3evAbz1zCMsafDKAk+To1h1LuXEkm2XoZm5kfwKykBtIdc3igspAUBd9rA
	Xmfh0ilBKD1kAV92HutFS4xdrD5egfk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790982694;
	b=OqmNB9l4mSOf2K9v95cGhBAhWr7JxecoYjsPDhoezD9s+IobTvyIESP8pXTCAl+Rv744KE
	fj3Bi7vzlwaIFWRio3ZzkUPdQ+vVDk705njwD4oth8E6zF0UbDCg4SBuqm1vFqA7Ko0fVP
	DpsnPtUf7DVwX1tlkqgqvwbmHSOfLjQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XpAS0XK9;
	spf=pass (imf16.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9312343FBF;
	Fri,  2 Oct 2026 23:11:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363DD1F00899;
	Fri,  2 Oct 2026 23:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790982693;
	bh=ck6iL+D5JVu4WQzD8eBQ/ax4Rj5EDM29htDBOrwkdSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XpAS0XK9fdAVVra2THzqk4YxwBSgGi3chiGMstxoTGB9pz8nIdeSusKWnNk+umHzX
	 lzIT+lz4iwF/U40t/BTKrKXGb+Bn5QHcUsTnbkbEDg/tuLXhx3sxaAJ1AXPKieyKOz
	 E/tiBX/uPnrL/EfIkOS/Kyw/Wg1sSLJDSY3hk9Ed9pgdkhOYHbsmTMm0MGYyknwuQ3
	 LQIWlLpnc9DTGL80ALGerdob7oDFUNvSTxR0E/cLtEa2mIpsZARP548p/C3MuU8JDa
	 zHxLu63E9sRwg3fv7F8bGn+G+hsen8i7JjRzt1Qyn++v90a60a67xHjmGRLCA+dMWE
	 eET0PH0MJ041g==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-hardening@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Mina Almasry <almasrymina@google.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH net-next v5 3/7] mm/slab: Add kmem_buckets_destroy()
Date: Fri,  2 Oct 2026 16:11:23 -0700
Message-Id: <20261002231132.1646573-3-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261002231120.late.500-kees@kernel.org>
References: <20261002231120.late.500-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4267; i=kees@kernel.org; h=from:subject; bh=IvyaYk2+Iu7NIXTrpa0hYRhQGrcYMHvNwlOs/GE8Uyw=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkHrOTicsW01boNfb6oKrkouiTP+XlfzpotX/3Ghs69n Mf3Gup1lLIwiHExyIopsgTZuce5eLxtD3efqwgzh5UJZAgDF6cATKRyJcNv9sc/FSY3ZBXsXRIW /0d71cKjnSxpXBY2N3ym5ly8aivvzfBX0ubsoxqNqwuPVrpduhf1fxX/67eLnnQxrp1a55Tx4P5 GNgA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: e664i7k9f6w9nhoe4go3bj4suijutc3b
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 83607180003
X-HE-Tag: 1790982694-956267
X-HE-Meta: U2FsdGVkX1+t8qiAn7WKsBSXRKJJ3m1vFbt64VGUP7KDmdpGEVexBCcX+j78Qlcx6MjjtGYNGMNPJzFFXXIfyGXh/uCDXz5hc4zxD5+xXJnnWCcVhvayioGF/55r5epwE3ybnHsiYbEMWzNtDzQjBvRi0W/k6az+c0cuH8YBNgEmo1YeGePJ+GPI/9aaNzUCe0VrxWQdwr2nJF5x3cJ+LeffxdOkzDok4bsxWOCKqQC5Wu/L1FBps2E1kBuM0EnKnKdFpVuU8Q4FkCw7Fv0H9PE5tfYE8agebS7YHEcGdPzpfmsIh+iDu4rZQ0NDNi6j+3JDwMZQYRJsNzyxg71GQO/Ik1QGGAyrZMXsUkS5s1gORSyn2lSq9/vgALb5pLGZkxL0ssgKQbdg03l6FOvjL8eUouvfpcfFoHsELrcupSFlsv2wIujn9sav0AAFJtWa0t05zY2kkZGhJRbq37w7nEx8OpKVHqtxbo8Jgu1EzTQTher/j9XTIizYPKOYXr2Gl+2ZwQQb5Uy78lLSw/6ZJ6zTS5i463Yje/IBkp6540hpmtsPqlrmhPD3aywbcniA3rpEPdG+mTZLnc3QxjGY4qvXshkA+zcZkbm028wOhh/BT+Hk05ot/rj5z0v4/W+RVZYY2qgbl4oqP7kGitD9RvCZXOmhCyCvpi+SARDacyXhlTjVYb2/VK8jxMbqIQoZyrth+VZXG2IQQ7tMEvvJE4aWOWkCH82YvngIpQoMK58x8Nd8aYYCLCVtYjrpQnI44scJnGzp+Y66n6ik58tuyAP/t1ps08hogWKjCphfq3hLN1oaO6WAge1mccpxblhqZ2oXLrfG0povlsledcBwtBY4EzR41aLl5RS5HbZmhiK8MMBX2+tJ/auAdgfGbXUst/hW1LG6nWnqhLkT/86175Boy2EpdaroTORHgvuwQpB26ntORDaO27tJ5rAPFwVYHHnxerdg67SJ2hbHBe6
 MJuQsFWX
 QYcFEn1zkaPF7+ajwDiGWEzTPJMkEBkZ2aB9LEMS0+R2CN/O+1BXMhqNj0dgnyaq+A0W+nfmZxs+1IOKlpWgOl4UTpLJgb4uQ2/Rec/LBlYH77Xbjhv2jtK7gSkTdTjBaHAuiqQwfVLwUj7nDM56SVmk9jJdertVwMtVFVE8bN9cvdPssc/bbmiiwz29/YzU709K6uCeE3N6sgJTUPNZe5zL9kgYDD0LNKcVA9/S55+0m4Fqv//nvNm33f4OJrqvTiGj3i3n7PLWreRDovltpy4bbngJ0blz+roTe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmem_buckets_create() intentionally had no "destroy" counterpart. Every
caller has lived in core kernel code and creates its set once at boot,
so nothing has needed to take one down. However, KUnit tests may be
built module, so we need it now to support the coming tests.

Some caches have size aliases, so the same pointer is stored at more
then one index, so we have to save it, clear all matching instances, and
then free the saved cache pointer. (This is what the bitmap was tracking
before in the "allocation failed" error path.)

When CONFIG_SLAB_BUCKETS=n the whole body compiles away, matching the
ZERO_SIZE_PTR that kmem_buckets_create() hands back in that configuration.

Link: https://lore.kernel.org/all/20240809073309.2134488-1-kees@kernel.org/
Assisted-by: LLM
Signed-off-by: Kees Cook <kees@kernel.org>
---
 include/linux/slab.h |  1 +
 mm/slab_common.c     | 49 +++++++++++++++++++++++++++++++++++++-------
 2 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 94709e4e14f3..4e6e74b3a990 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -894,6 +894,7 @@ kmem_buckets *kmem_buckets_create(const char *name, unsigned int align,
 				  slab_flags_t flags,
 				  unsigned int useroffset, unsigned int usersize,
 				  void (*ctor)(void *));
+void kmem_buckets_destroy(kmem_buckets *bucket);
 
 /*
  * Bulk allocation and freeing operations. These are accelerated in an
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 301f3d4f4ca2..d66e5e56a0f1 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -438,12 +438,9 @@ kmem_buckets *kmem_buckets_create(const char *name, unsigned int align,
 				  unsigned int usersize,
 				  void (*ctor)(void *))
 {
-	unsigned long mask = 0;
 	unsigned int idx;
 	kmem_buckets *b;
 
-	BUILD_BUG_ON(ARRAY_SIZE(kmalloc_caches[KMALLOC_NORMAL]) > BITS_PER_LONG);
-
 	/*
 	 * When the separate buckets API is not built in, just return
 	 * a non-NULL value for the kmem_buckets pointer, which will be
@@ -497,7 +494,6 @@ kmem_buckets *kmem_buckets_create(const char *name, unsigned int align,
 			kfree(cache_name);
 			if (WARN_ON(!(*b)[aligned_idx]))
 				goto fail;
-			set_bit(aligned_idx, &mask);
 		}
 		if (idx != aligned_idx)
 			(*b)[idx] = (*b)[aligned_idx];
@@ -506,14 +502,53 @@ kmem_buckets *kmem_buckets_create(const char *name, unsigned int align,
 	return b;
 
 fail:
-	for_each_set_bit(idx, &mask, ARRAY_SIZE(kmalloc_caches[KMALLOC_NORMAL]))
-		kmem_cache_destroy((*b)[idx]);
-	kmem_cache_free(kmem_buckets_cache, b);
+	kmem_buckets_destroy(b);
 
 	return NULL;
 }
 EXPORT_SYMBOL(kmem_buckets_create);
 
+/**
+ * kmem_buckets_destroy - Destroy a set of caches made by kmem_buckets_create()
+ * @bucket: The set to destroy, which may be NULL.
+ *
+ * Destroys each cache in @bucket and then frees @bucket itself. As for
+ * kmem_cache_destroy(), every object allocated from @bucket must have been
+ * freed beforehand, and @bucket must not be used afterwards.
+ *
+ * Context: Process context. May sleep, as kmem_cache_destroy() takes the
+ *	    slab mutex and can wait on RCU callbacks for each cache.
+ */
+void kmem_buckets_destroy(kmem_buckets *bucket)
+{
+	unsigned int idx, i;
+
+	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS) || ZERO_OR_NULL_PTR(bucket))
+		return;
+
+	for (idx = 0; idx < ARRAY_SIZE(kmalloc_caches[KMALLOC_NORMAL]); idx++) {
+		struct kmem_cache *cache = (*bucket)[idx];
+
+		if (!cache)
+			continue;
+
+		/*
+		 * Sizes below arch_slab_minalign() share one cache, which
+		 * kmem_buckets_create() then stores at each of their indices.
+		 * Drop every reference to it before destroying it, so that no
+		 * later pass reads a pointer to a cache that is already gone.
+		 */
+		for (i = idx; i < ARRAY_SIZE(kmalloc_caches[KMALLOC_NORMAL]); i++)
+			if ((*bucket)[i] == cache)
+				(*bucket)[i] = NULL;
+
+		kmem_cache_destroy(cache);
+	}
+
+	kmem_cache_free(kmem_buckets_cache, bucket);
+}
+EXPORT_SYMBOL(kmem_buckets_destroy);
+
 /*
  * For a given kmem_cache, kmem_cache_destroy() should only be called
  * once or there will be a use-after-free problem. The actual deletion
-- 
2.34.1


