Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA656606A330
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 07:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=U6I0TAio
Received: by kanga.kvack.org (Postfix)
	id C10BF6B05F5; Tue, 27 Oct 2026 03:36:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE9016B05F7; Tue, 27 Oct 2026 03:36:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFEE46B05F8; Tue, 27 Oct 2026 03:36:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8D03C6B05F5
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:36:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F34901209A8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:36:01 +0000 (UTC)
X-FDA: 85367597322.21.DDB6026
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id 265151C0004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:36:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=U6I0TAio;
	spf=pass (imf20.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.41 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793086560;
	b=M2fNxj+t6bdaPTG0QU6K3MpUddMvf6Fu5m/LCQ8EB3eEHucDPXTkODQZzVn4Cl72gn88Z4
	9G3bB02fv5ynHlQAxh1nR7dzgt80ean2kctuT3c06Lb8PwGS0cIdS3j+bY1a4ZySCKBsuV
	D+evqOR8EsknKzvPde7qMDSUXMTz6Ok=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=U6I0TAio;
	spf=pass (imf20.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.41 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793086560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hpIIV0W46trht3EV+1EEIjsc/ykz7v9qZcaLCd0bYkU=;
	b=nW3Ra4R1TQxpHgAbKqgvXdaQIbmP9azmjMxrMWUvoKVd7pPqoapZyCAVfpa/ivRx2HNSJo
	YfcHx+DeA+p35c+qH80h/ugViFRxkAgUpW4vbfxAM5Qz/8rQgdJPuNeYGb8HmU+WDcd6Jb
	8IrizpzLn5j+nclPuLzto0+dCDRHqwM=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3ae25008e2aso800688a91.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793086559; x=1793691359; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=hpIIV0W46trht3EV+1EEIjsc/ykz7v9qZcaLCd0bYkU=;
        b=U6I0TAiob0nI70kTeidRbue3WSvK4H4AP/HifX6lwAXu2sLiWNgsTugH6eSn0WpQOE
         E3HJykn8c22EOT//KPLq8XyKv7AK161b6O9luVXHaDE2N1XJA7ZqlsO+aeScjSZ9sUvT
         zgwTvuuCLOKNDHJNPNr6J4ZdkGF9wK3jprD6M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793086559; x=1793691359;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hpIIV0W46trht3EV+1EEIjsc/ykz7v9qZcaLCd0bYkU=;
        b=vDS/OfLoYvO8V5CiYGr8LJQsI9G1uQ7sq96aX1H29tfxeXkjAEvoSmG1lqqS44TP6+
         p5T4fin1v+fDJTIyrucGhidxebQZYDVBuXzQq6wsTrp4SH+3+OUhr8e90pRK10ps//Uz
         g3MYtdkPjpKMrAH6fEgP0g6PcS0+rpXEVD5YVDeh+KsMGVtN/Y1JzfPe2LNd+VLuDPPq
         yylUOGDJEizJGKbwjXi3xyigAqH6E62opcgTVICHXjPWoWHJk5GQTAFhrt6qqFrQBrFJ
         8qhAuQncPl3zglymRT3nokFpVTYhHPqfozvDkIrAOkQQEWeZOrwAOoQMA8qW3fItgh36
         YmAw==
X-Forwarded-Encrypted: i=1; AKwUvBym5sQvunhK0u4QU3GpuyTMbog9oMJlje/F0VqDF4pHzDKkFDbcb7WK/w9ZKHBstr3tH27eenGgGA==@kvack.org
X-Gm-Message-State: AFq9FYIra2DV7+xaPVJkGXICInG7h5TTJG5WytNS2wtBrPgvOJcHqPXh
	dctclf2BMM0UGtfG+z7eUNiWjBprk2LK3xDa9V5nR50ZYpwhlph8DjoJoGFuxG5q8iY=
X-Gm-Gg: AYBFou045ezHh+qsjZ7vWeNdY021ZXjsltmB1bXICnHeRjBVEeHoSNa7F6cFP5FSzPt
	pqOuLSica4TSGH1f/OZLh3N0mGZFEg+q0GdvxoLKyHfGTKxE43/T2xh5s3iFyV2rEQElMgldjpX
	YvMHFlpwpHNSoj7N9cDgrXecN78TCainLRFauLPGaCScop5CvD/Ihm9H6uO4fNnBPkvENQQYvWX
	k1teK6V/CuNrGE0VYnSrMkkk2oq5tZvGb/G19F6JSeTQEy9cHsO2sVZP6xS2nvPeDQv9ha/jDld
	KkMmESK8a3j+2W1YyIrR6Tf9sZ3v1PxgLJgJ81IPQnaF575refkTgxB4Rh34N9Xpx8EVSn6Yf1K
	/TpG7kEhbyg8HGxwC50tpjt5QEZGDeECJkDCqMLa/xDVx4Yh+mjNYWg1aq7Eh5NyyxI0rBCYiTO
	6okHCFOYq+/YeuIILvdvOm0sOZuuvSrfFacukyIqO4lqmt4WMFTDLqSKkU52EOhP9aNsdnTkQtD
	KxlEeq35FjGRJuqXYm3liMwJGxIl/grkQglQWsLPKJ1TzA2Ztqv4MGQ598gmtWszy0AvDHZQnTk
	jiQ9XMbIUHuMoecOk+cIOietWMZcwSXKdgT3bQ2eOBwLCtWiZC4RTtghFVRQwV65QtEfXJtxvyV
	Ic6wPF78+32SOtW1VBXLMe7k1QMZWjt/OFvcR1rgMcPA/1zwhQVywESb3TrKbEbQFVGMauNKq
X-Received: by 2002:a17:90b:5408:b0:3ac:bfa7:b079 with SMTP id 98e67ed59e1d1-3ade9b2f216mr7575308a91.7.1793086559188;
        Tue, 27 Oct 2026 00:35:59 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adebb0dda7sm7230307a91.4.2026.10.27.00.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 00:35:58 -0700 (PDT)
Date: Tue, 27 Oct 2026 15:35:54 +0800
From: Chris Down <chris@chrisdown.name>
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <kees@kernel.org>, Marco Elver <elver@google.com>,
	GONG Ruiqi <gongruiqi@huaweicloud.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH 4/8] slub_kunit: Add a test for slab_freelist_random=
Message-ID: <0af4fc45ca8e1d7027ceaad079f8f9eaac663c76.1793086056.git.chris@chrisdown.name>
References: <cover.1793086056.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1793086056.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspam-User: 
X-Rspamd-Queue-Id: 265151C0004
X-Stat-Signature: 4ks1sycawk1wapy876kh5qdkajfbxbco
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793086560-592290
X-HE-Meta: U2FsdGVkX1+WQADh8M98EfrKZivPzmV5o+KUazpuM8EfDUFKX2JAoPmGDpWDeohveWEurP25z0cEVEwu8qhLuqNeVt/fcA6lEY6E8YQfK5OE22AmbZLFSUEKaoR/R2v+CYm7Dkn76p7igVX4lysHYbHOluVfXAPlCeQvzOrfl54EFW3abNVH0ByUyTT+ILwEwb7hEDgyfmD0/DJ/Ced6XrbMSDcuauOlbM1NChNbZPeSZaynsaoW+NoMhtdq2UBvnkpzGbTI12k1/8auijpG3z49rdBcA9Da3vBYGagrxaH2Q8AdnhkzE8I2vaTrBQWtB/oWg8ciFl32GlhuP++GcPSoNNZ9yeQ4XvFM4L19+7yN0PaHbKoK3JiTb9wyqfGnPjOnWQ/SLckLczbTw3LSEymzm8EA092Wp0DUGErYFF+tXCJsdxmoz2CZWPvq5y4Ay3l0bGY2YHC58JyN5E5YNy8ghUUS/Of3fYItnj1GsMh6camFDM0eao7DojKB3iW1IymhBUiujL7KaNTyppRfSBQOcfX8Eo2kkeSMrc4X39m270gkeKUzRIMf/+9AcASzWXQ3EJZECwgyr5OfdO7xKYrUsBbWhCHvDRtDmjbn7wFL8190VEbh9cCWvyqOdoBYTj2n3JGrWyl5V/c/HG1N6nlLGBJVSSK0+1mL5dAdDcDTdIuqRbYaSXipkg6NB6FdbS5CVtpehhyAsKo3PfVEPOym77XCwLd6rROPdgdLZDGWrD4vlkGkvDhKghVW7NPMFpNT2sYWRWS6204+sQ0zAc0UqlSNp/Eg6WySdh5348biOtAJOZoWTRIpmBdQmA4BY4n3OI1Gp0VJyx7mKsbMwXaEb3hQGhOHxYZti3Fx/xgpiKi22R9+tj71M29QqV208LU1Upnm5IThtFa6Aof8TW6fOs6kofbZhfqdlTO6NXAZ/QrsL/GPWLckupRsVVlP8TyIZO27LNcWIT/uN0j
 pUTi6Woq
 sYZiOU8OqjMA4Dxz54WHpCK3JDrmJoo4vOxEYTwNM7+O3lUhRGLLHeBLk1w21QGYNDndyZhRZsLK79xwajh8kA0pvW7oCQR7jY8DbytUGq7wNN51a+ns8100L2boMPkuLgvMOYufSuivi2Nm+3CZqi4JNgQiSHjtsJs4oeTHpEkHSPA7WF7E/Os+5uPwVSYPpc/Z323vYlMW9zhMLw37PAluVS4TZgCTf8bAMCvzYCGHSFSUXXOetAjUPkC0fTB5sPORtKG5dbi63rd844jHjCv39m4ccw5tk3bFxooy2ZHIYTZpCwlxUl3YOrswo0XxFv2CC5DwO/yRN/ANQiJVLbjzv/b99LUL8j6txTXnbhnJTmEzGI8VsDNxznLKiXc6TEnT1aM8DMe/HMwwVyC4o8WJRz4OXExsa+skLsmYF0DaxGgxXN7KMInoQ8Pl5l6go70cu9+rwmHZ3pLvn1PBaNXAxwXgNPpCrSSzgo0xnG5AUK5Q0imjbo/yYRiC428kaLGtH95EF+YTYe/w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 lib/tests/slub_kunit.c | 51 ++++++++++++++++++++++++++++++++++++++++++
 mm/slab.h              |  3 +++
 mm/slub.c              |  3 ++-
 3 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index 5ace73368523..49b9942bc564 100644
--- a/lib/tests/slub_kunit.c
+++ b/lib/tests/slub_kunit.c
@@ -190,6 +190,56 @@ static void test_clobber_redzone_free(struct kunit *test)
 	kmem_cache_destroy(s);
 }
 
+static void test_freelist_random(struct kunit *test)
+{
+	struct kmem_cache *s = test_kmem_cache_create("TestSlub_freelist_random",
+					64, SLAB_CONSISTENCY_CHECKS);
+	bool random = false;
+	unsigned int i, nr, nr_linear = 0;
+	void **objs, *first;
+
+#ifdef CONFIG_SLAB_FREELIST_RANDOM
+	random = slab_freelist_random;
+	KUNIT_EXPECT_EQ(test, !!s->random_seq, random);
+#endif
+	kunit_info(test, "freelist randomisation is %s\n", str_on_off(random));
+
+	/*
+	 * Caches with debug flags have no sheaves, so objects come straight
+	 * off the slab freelist.
+	 */
+	first = kmem_cache_alloc(s, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, first);
+	nr = virt_to_slab(first)->objects;
+	objs = kunit_kcalloc(test, nr, sizeof(*objs), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, objs);
+	objs[0] = first;
+
+	for (i = 1; i < nr; i++) {
+		objs[i] = kmem_cache_alloc(s, GFP_KERNEL);
+		KUNIT_ASSERT_NOT_NULL(test, objs[i]);
+	}
+
+	for (i = 1; i < nr; i++) {
+		if (virt_to_slab(objs[i]) != virt_to_slab(objs[0]))
+			break;
+		if (objs[i] == objs[i - 1] + s->size)
+			nr_linear++;
+	}
+
+	if (i == nr) {
+		/* Without randomisation, objects are handed out in address order. */
+		KUNIT_EXPECT_EQ(test, nr_linear == nr - 1, !random);
+	} else {
+		kunit_info(test, "objects were allocated from different slabs\n");
+	}
+
+	for (i = 0; i < nr; i++)
+		kmem_cache_free(s, objs[i]);
+	kmem_cache_destroy(s);
+	KUNIT_EXPECT_EQ(test, 0, slab_errors);
+}
+
 static void test_kmalloc_redzone_access(struct kunit *test)
 {
 	struct kmem_cache *s = test_kmem_cache_create("TestSlub_RZ_kmalloc", 32,
@@ -535,6 +585,7 @@ static struct kunit_case test_cases[] = {
 #endif
 
 	KUNIT_CASE(test_clobber_redzone_free),
+	KUNIT_CASE(test_freelist_random),
 	KUNIT_CASE(test_kmalloc_redzone_access),
 	KUNIT_CASE(test_kfree_rcu),
 	KUNIT_CASE(test_kfree_rcu_wq_destroy),
diff --git a/mm/slab.h b/mm/slab.h
index 8187ddb2face..b648b33f25c3 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -887,6 +887,9 @@ static inline void dump_unreclaimable_slab(void)
 void ___cache_free(struct kmem_cache *cache, void *x, unsigned long addr);
 
 #ifdef CONFIG_SLAB_FREELIST_RANDOM
+#if IS_ENABLED(CONFIG_KUNIT)
+extern bool slab_freelist_random;
+#endif
 int cache_random_seq_create(struct kmem_cache *cachep, unsigned int count,
 			gfp_t gfp);
 void cache_random_seq_destroy(struct kmem_cache *cachep);
diff --git a/mm/slub.c b/mm/slub.c
index 7e9dadda3d10..8c7b46c2052f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3424,7 +3424,8 @@ static inline struct slab *alloc_slab_page(gfp_t flags, int node,
 }
 
 #ifdef CONFIG_SLAB_FREELIST_RANDOM
-static bool slab_freelist_random __ro_after_init = true;
+VISIBLE_IF_KUNIT bool slab_freelist_random __ro_after_init = true;
+EXPORT_SYMBOL_IF_KUNIT(slab_freelist_random);
 
 static int __init setup_slab_freelist_random(char *str)
 {
-- 
2.54.0


