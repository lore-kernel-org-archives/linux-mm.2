Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46E43C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 07:58:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B4656B00D9; Mon, 21 Sep 2026 03:58:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427776B00DF; Mon, 21 Sep 2026 03:58:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 335B86B00DF; Mon, 21 Sep 2026 03:58:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3EF46B00AB
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:58:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4E9251A05F8
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:58:23 +0000 (UTC)
X-FDA: 85237016886.14.7648089
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 851E9100004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:58:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A/Tbm2wJ";
	spf=pass (imf14.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789977501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L/18n8TfyaFMDLnAYEp51nwGZPC1Y8Qvb7X09zPa7Vc=;
	b=znRtLpyfx0UCRo6ikMXi0lglHKeho+8YU60UrL5cUjtdqco2cw8/CGg6VmV+Z3FDIGCfdK
	1TFeROH6Zo3sCcmKyggX3lmlfTGJp626VPB4mRWKSHAkEaxVm12/vg7CwXwvuq1G8Ijpwb
	Rc7NiyWYrfVei4/2TUM41BMN/34oD5o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789977501;
	b=uOPm+njWhgMpH/rfKD5HajFnkIB86cMQb3mw/7ZdJ38JMBeBLvuU54++jZjDUBHc+rnqME
	rL4A8wH0KLcMgLPFvtr+v09yk5UUsasy7S/n1fIQTcRWSmKpFeiYPhog18ddgvefAYcQtx
	vg0sqomh1IiBJJ/dusbC23UitEyFydk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A/Tbm2wJ";
	spf=pass (imf14.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B05CE43E20;
	Mon, 21 Sep 2026 07:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745871F00898;
	Mon, 21 Sep 2026 07:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789977500;
	bh=L/18n8TfyaFMDLnAYEp51nwGZPC1Y8Qvb7X09zPa7Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A/Tbm2wJxme0+N0pPuGOo8l68ppGyPNpDhIC88m3xFlT8W2gs2H0UtOcaFX9iXwkS
	 COcGAExn661bK6PWCy47/Y9KvNRK9Capy8ppPxO3wWFDlJV5njIu70kOH9B8waNcL6
	 d6b/mpFAr35uy3KaVJDRyPlxeT1kPwDY4TDyg3KiNWt9J1VHjqAzIcp80PjutjKnqS
	 K3D9lhTABsKYOqMjzwN3SKVtRrBzxlWF96B+TLvD3c4i7oouEgH78A03DroLWGeF2Z
	 JuJwF8pMShZX1rKiCS5CtTF1YuKEr/PwoCl8dl2GystyIzixncFflxEEHpkeOvvb/l
	 2GcjE3lK1EDJw==
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
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jason Xing <kerneljasonxing@gmail.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Willem de Bruijn <willemb@google.com>,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH v4 3/7] mm/slab: Add kmem_buckets_destroy()
Date: Mon, 21 Sep 2026 00:58:14 -0700
Message-Id: <20260921075820.1718334-3-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260921075811.too.775-kees@kernel.org>
References: <20260921075811.too.775-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4729; i=kees@kernel.org; h=from:subject; bh=+WGfdR3Y4f4MJOabUzkDEAYVtCQqjvgmchKMVu5bAso=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkbHs9UUVx8Nfu38g2JFUlnXu/wXSKoUZe4uPxUm0ODS qZpdcy7jlIWBjEuBlkxRZYgO/c4F4+37eHucxVh5rAygQxh4OIUgIkkVjD8z+N5yGySI+I2a/8V v7vmn5ezRey+emMBg+2JhF2itXI8uQz/a1aHH9OSFKp4G/eEN0gx01qHScXVznvTV4XDy6Kd8vg 5AA==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9da8bq3ctubf5fggtbwh4pmig3h7khqh
X-Rspam-User: 
X-Rspamd-Queue-Id: 851E9100004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789977501-92079
X-HE-Meta: U2FsdGVkX1+YmzsJeNFUSKhG+jfXpVi7+gsIy9zy4A6JcTO6IeBivgmtia+NmfZ5dlKxE7Ps56gMLlMFMcDDRJk/3ZI8B1M+gKg0w1rK+oqApVYnYBJnnBQUvwaVun8ZzBapz3B3JWeFcOY695tZB0IvFO7TUM7HNLlR0ocvvW+pQ1GMBvymgtaNu+pi+Zrnn3xcUHurMWITLydua1G0M85vkiwRe4WPjhGzc4wwlaa2MHJTBMNeQR4m3cLds0rmOfsLegt/lTmmgPZVzVA7yJPVZz40tf5qBUM2VAmEr6ZvG3kwY6xE9DEeuS8w/mFeU9FWuB/NFlCk+6N9dFfs25lEnil9uIZ8VnaQPmiu2NT94KGutJFFdxkoOQkDzsfAYld6O5TjgbXm2+RFwdNdYLW9DuGO2qP80fxxPJen6Pv0ELVKPwdA7zGG5DZRwCBsOpQmdG5ne4zh8vT+7HX+hKFYQweUf1tykqWBXEdSB2f1mBDVhyoFYSHfYkDDa+MBXW19C1d/eK5aH8ariK1+DxahYavnALRqHg8SFoxe1USWsaCxnAc5IR8htk5fUJPpEys89UYzCv4A8gNG9QgqvzrBV8WK9q7WemCCqfgmWNwZphHe4VmVh1f2+tq7xEn+zmZXxh/fxbktEkZRQ867oc1FC/Sei16G41RpVDOGDxAhx3eAdwx/lI2lRUn3532UxVXXf9w4YW0ONvjSbk8mxlaMCQfqmuN6xxeAl0dVtQ43pW7UzTveCpaV/ikC9ZTp/J1wdxLPaqz2KzIM59TpG4GV0prrb60Tq3lbMC6I+1WbnbQ+nLVQ01rUnPDwJ4hk/kGJFPvPgAcfFIeMYogHVD5o3VAICM/zbk49F3fVE1/ZLu2EZxFwQ0vaRcgylzL89nj9wwYn2Huyyl8aeizpd+BNpV+8N2RTh6pjY/ILlt1qpX4vesO/or5Phyz1dYNJEQ2wZHtdMFQFUGuWOO1
 lWeEm3rV
 qfAymztfIcxT/OaYqF4ac1HYxZVI9XZXTyClzmFuR5UJiHATkqUi7q5pnCl+5rEtX/k5vSocO+GZuloZa5H5Ss1rw62MyVC1Hy9q8hTezL+3yNczF8RaCqhXknV9lrDKaw8q5lM/NMdNVh/DR3QXfzlY1UNGbZ0McaB87C1k//oOFO5ngmeJLrUp5wcPZknrBI2j/sZhvYceXhnN2YR9R7kGbyga5WSHY1quLDNsJa8IUZ4X4HIVM5ZjcrxYxywz49FnRWSvBhQrmedJDCUEcoFX83x+EX/gpnZQzranktsRuqo0iMfIAOxfkMnco8Vt1v7P7jPnn1Lt9c9BC5hATCo9Qnf6jlD+PSsn3WgoGy1s/AN40qHWcZWhUOMCh2w0Q5ijKTbOhS02XJlpvzruW5cw/R447JjFOa7Bc+/H1MFy7VmqS7eb8/4YsmRaaKDnTfBNkXvuzqUC4JMe0XiTweo+TZgJWVFmAucbo4gEE+xxKENk=
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
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <linux-mm@kvack.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Kuniyuki Iwashima <kuniyu@google.com>
Cc: <linux-hardening@vger.kernel.org>
---
 include/linux/slab.h |  1 +
 mm/slab_common.c     | 49 +++++++++++++++++++++++++++++++++++++-------
 2 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index cda126def67a..18a2351f9084 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -893,6 +893,7 @@ void kmem_cache_free(struct kmem_cache *s, void *objp);
 kmem_buckets *kmem_buckets_create(const char *name, slab_flags_t flags,
 				  unsigned int useroffset, unsigned int usersize,
 				  void (*ctor)(void *));
+void kmem_buckets_destroy(kmem_buckets *bucket);
 
 /*
  * Bulk allocation and freeing operations. These are accelerated in an
diff --git a/mm/slab_common.c b/mm/slab_common.c
index cc58f192f349..eb29cfb2f0a9 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -434,12 +434,9 @@ kmem_buckets *kmem_buckets_create(const char *name, slab_flags_t flags,
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
@@ -493,7 +490,6 @@ kmem_buckets *kmem_buckets_create(const char *name, slab_flags_t flags,
 			kfree(cache_name);
 			if (WARN_ON(!(*b)[aligned_idx]))
 				goto fail;
-			set_bit(aligned_idx, &mask);
 		}
 		if (idx != aligned_idx)
 			(*b)[idx] = (*b)[aligned_idx];
@@ -502,14 +498,53 @@ kmem_buckets *kmem_buckets_create(const char *name, slab_flags_t flags,
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


