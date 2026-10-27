Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 286C460A5BDC
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 07:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=merXNRNF
Received: by kanga.kvack.org (Postfix)
	id 3ACFE6B05FD; Tue, 27 Oct 2026 03:36:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35E6C6B05FF; Tue, 27 Oct 2026 03:36:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29A9B6B0600; Tue, 27 Oct 2026 03:36:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00EBE6B05FD
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:36:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8335280805
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:36:23 +0000 (UTC)
X-FDA: 85367598246.07.BE97AC3
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id B1C4A180007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:36:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=merXNRNF;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf06.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.47 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793086581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WsDVlDiCyeeoi6YHVgqDovvrMD/IKVknSNFW9xBDDdM=;
	b=4hzjhBnBDSH1bNcw0gzmn467xZ2+4wWxJp+NZVKk/+qCOY2tgHZ7U3VMTtOZFi4CGSuABt
	fPw9VGXKo5cgdeV7ky9yROUI+lhznHW47i0nqI/LQ9f2X5HTMj2s9WcHiN+MsrDKWpwlbv
	Ciz2mUVaYxaNsZI/aF3qIaszQFg5cbE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=merXNRNF;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf06.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.47 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793086581;
	b=CwSO8gBDtyxrhYVh1Jydad8gL5nAUE095K4TJXuzmvN/V4kR4Fmw0RAnRTb6fDk+b4LwGp
	MftRTC5nFAmP8yRZmBzQjIQ8cuzLC+0rDqpvC39fQnqG3L2wMnxfDXbYJNJyunG7OoK3E4
	QZXCKO7J56hOMd3gHOMp8vL8qFTxTfE=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3ad787e0593so1640564a91.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793086581; x=1793691381; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=WsDVlDiCyeeoi6YHVgqDovvrMD/IKVknSNFW9xBDDdM=;
        b=merXNRNFy2GG3gibQ6rBgrjmvjeKY05eeFaN7/ry/bGd6GxnCqjHZ24ajZZXwDW4Lg
         m1JkEP+r6y1NmDXvSVverXA3RByXPGKbOdUvWT9lssk0ZkytdF+uClKtey2xpsX96X1W
         Yh2bO/3WvFyIhR6fdjZ0J8cKQaK2DRLsQWFHo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793086581; x=1793691381;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WsDVlDiCyeeoi6YHVgqDovvrMD/IKVknSNFW9xBDDdM=;
        b=ufsxe22OctIe4x1x+DCnRfpFoEFcvCirT3k96VsJc87MPAvookkmluh1pJmxLnHz0P
         zLEsJaBJp8cvR5MKt3rFAhzLengEIHvKTf/60jNLqq6XOwe+xTKCMLOvQdQF5S7PrzfN
         IiinmBqFl69kOihQO8CCnvilWP1THKQB159E9QYlPMdzZTqGE5HhTNmVZpDzanhofNNr
         CqfMAKreeR/LV733gskpaDHrD8lhfbXcGgURmKsylxUYq20f3gOnia2fQy/Ryg+JJd08
         gSmvav16K0AaqWBGdb9FyPVIAIl/kX9IDUA7cbLNBBu6XbxOXxRUrHK6JCfcD6ffwS66
         lsUQ==
X-Forwarded-Encrypted: i=1; AKwUvBwzhFR9YFlzOx5skev2SAwYOsL/dwnesvaDuRzjLmrN4gK5qhm2l909hmmokuBoLaTK3xfY78pQlQ==@kvack.org
X-Gm-Message-State: AFq9FYIn71caGN1HZa95pGpC2t/YsP8c/Uj7DLt5YtctwIi7po1McShU
	aGfbh53QkyIXLlbiIu6FQG0mgkssRUR713FHGTT7M1uvwK1dkksBx1Cn1KBcMRXT1Es=
X-Gm-Gg: AYBFou0luXJqAa6Uuki+/Es+6QqNlPpjCQFpEYHXuzXdX64G3QXGJ7PMafd9u6OqQ86
	Y4LzkQM8S+pPycGqQVnLFh1/lBGebDvcldk1EtIwfWBHd0JT0g/BwxiC9S6afjuFtF0chY2uvxn
	YwerTLoSBJ9MwrgcnXb1gcwqkriSsdafNisXgKp9uyFieFeyvjcwPeVuvc6+1d2/sj4HiLJCmp8
	XSyCHm+UEvay+p4c30lq74lJ5icL4IZeNZeM/ZbQEKPYKDQoKz4WZfM/N1qXV0lTTGSdr1vtcoA
	lGJibjMJnyv+JI8cc88IVku4pMCSxJFlqYvgAyc6moSH1nrsZ1F9jXDwYv1wbaKjlEao6vGvMI4
	GYBYcDKQPWLDOMpCJdMa0Kko/agRCDK4cRlDKKyzommleU6NELXes9hAyvE3ef1lQZxkfvTUbNp
	M9QRwTEDP4DtdmSr59m2a05iom21kfj9z7PTuuc9rPwSNhQ5BbWRi7i9aq9xl0qnjfk5jhA+uez
	ouhNbdu11XuqGUb/1bPxLzFS8iNw60GCOiyZrUydz8dMZDkpdj5xU+DvvFajcvcBwK8UjKsw/iK
	IUPGWQDoTMAMjnXOHcvNLDwXnaIazr/K0XcUNXjfsdcuuVySu1lSefXDg1mY/LCrSgfGEpuDijP
	tPyDTmEjFjNLlYaKRcDF9LoQ=
X-Received: by 2002:a17:90b:35c6:b0:3ad:a17d:f46c with SMTP id 98e67ed59e1d1-3adeb194872mr6931650a91.62.1793086580701;
        Tue, 27 Oct 2026 00:36:20 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae40614d7dsm2480038a91.3.2026.10.27.00.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 00:36:20 -0700 (PDT)
Date: Tue, 27 Oct 2026 15:36:16 +0800
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
Subject: [PATCH 8/8] slub_kunit: Add a test for the kmalloc_partition boot
 parameter
Message-ID: <7c619e0ff37d83b825549ee257bb60a82bc8006f.1793086056.git.chris@chrisdown.name>
References: <cover.1793086056.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1793086056.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Queue-Id: B1C4A180007
X-Rspam-User: 
X-Stat-Signature: r9mquc4bisscw1y56m7ztiswetnmpyqc
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793086581-252399
X-HE-Meta: U2FsdGVkX18vYR/Xb0a15I/+RHWxO4H7cdgHlGHH8EmwsLIQLgegsoNCq/y1ryFFx0tzE9yqcacrat5f/tqAyq42BZsapbhnIWyqdTjCiUQWMBUmA+0zqTol2FrfrQagd7nwTLNKT9f5WCrxmiCjBnlYWv0Kda1yqvTlW52IJsR9vhUhiR7WRWEtUL7llvWo7VLVvHH16mvurUKQ2xCpUT4dfdiDXAn+DsKaX13W2YcVO/HyCH/AMl0Bb8Utt3iSMbTSdKHGRI0ws5EGMgn/JqObRBNSUx6lFL2LXfpqPoN5W0BXYvJlYqSuTFi+wcSuRY+MydpRJXmh/CAbZI+3SWYV0TOEdHIGz03KOaytCZH+CmHFJfuvGyYc5KX+Lms6t9kp+sX2c9nNTIzBic9pMJG7UHlZk3J+W8pyoPvNRvRBl8b2EtIisbtES/CHL5BKOm6U0lw82+goacpGpqaaSXopv50EVCqYGGFIOK7HU4hvNEh33bkVwITaiI3XCTP5L+KBuBZVjPX3hE6LjmkwNZXqWb13+Td5+p8PT5MVTAd7nJmGx+a2xrUa11Aj9ChrPosISUkUi0ggRX/SltcQ63PBOxX5Nb+eGljQudmW6GA/relfWtGvIjj2gU5sEx2EaEEq7eC9n1ftZ9QHk2G14OPKiwyT3O2TV/HC4A33RAmJHF3OM7BLMlxR7pyeuG3WRFF38GkILAx1MBMYPVijOck9getfV1E4J7FXyfbirdO2zqNLaUzrbVjLSnmL6ACKUuFbXPkm6C0x3FbBXZ9sOymXCJU3/3WAkAN0sRGl9hMzTwh5Wa1h2W3/F+7IQQVCDDJjs9AqjNSs8ty+4i/LGNP7h3/rlpGY70PrVssl34DLP6gpIRhMSO9isfcYst3bSc90WvOMYoiOf+uARgRL2XpOePQny5YWZB+8vaf0FN4T2e8SpSRHwtMVlo1ZcMJBNJ7fvT1kNQmugCVBwLu
 m3iGEaLi
 SoqCUMhjYL6U3lw6L2hC3Vw1Lz7iIyI3/omjDjpdRn4GjSHV5UqOsaaoZYYKBUMbw6q5ERhmRRBjq4/6vkiJMV3UgTSXUtEqzlToKhHkl+jQp25EmB4/HKY4LSI3ppbmcU/1DPRkhqmqwO6XcNO7EFMK1ZQ05jo8YvwaCAANSvvVBPCmKiW7nIduimeZSH/1w27LTm1pgHJ1a1eNLXmPQuK05+BabcjCIx2kb0CKOek9cwKIjyjqmAaPbrgz3b4oV1y3zfcDKYmx/tpW9lzxhaO9e5dyg9zk4/twVypc5LdxHpJHh4HKhodv9HfKC9HRss4VkkV3Vwi4F/Xe1lCTmRuq0eEQs0RDSzX64ER5yXry62mt87qQlQNDmEztj8VV97rXmsFyiclNIm2vzW3mMh+wi0T5c+oncLPP5FytNRtIXe/lfnofo4r3yW/3OwTHbbwmkW/rly7Mi1N6rCXcSIVWaCboh/740ndEWupZHNmJ8+hHe9e83WWWWLnn1hxsTK2CuHclWh95YLls=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 lib/tests/slub_kunit.c | 46 ++++++++++++++++++++++++++++++++++++++++++
 mm/slab.h              |  4 ++++
 mm/slab_common.c       |  3 ++-
 3 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index 646596663b33..0fe10cbfc83d 100644
--- a/lib/tests/slub_kunit.c
+++ b/lib/tests/slub_kunit.c
@@ -430,6 +430,49 @@ static void test_slab_buckets(struct kunit *test)
 }
 #endif
 
+#ifdef CONFIG_KMALLOC_PARTITION_CACHES
+/*
+ * Each partition copy is a separate cache, unless the copies were disabled
+ * with kmalloc_partition=0: then they alias the KMALLOC_NORMAL caches.
+ */
+static void test_kmalloc_partition(struct kunit *test)
+{
+	enum kmalloc_cache_type type;
+	struct kmem_cache *s;
+	unsigned int idx;
+	bool found;
+	void *p;
+
+	for (type = KMALLOC_PARTITION_START + 1; type <= KMALLOC_PARTITION_END; type++) {
+		for (idx = 0; idx < ARRAY_SIZE(kmalloc_caches[type]); idx++) {
+			struct kmem_cache *normal = kmalloc_caches[KMALLOC_NORMAL][idx];
+			struct kmem_cache *part = kmalloc_caches[type][idx];
+
+			if (!kmalloc_partition_enabled) {
+				KUNIT_EXPECT_PTR_EQ(test, part, normal);
+			} else if (normal) {
+				KUNIT_EXPECT_NOT_NULL(test, part);
+				KUNIT_EXPECT_PTR_NE(test, part, normal);
+			}
+		}
+	}
+
+	p = kmalloc(64, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, p);
+	s = virt_to_slab(p)->slab_cache;
+	idx = kmalloc_index(64);
+	if (!kmalloc_partition_enabled) {
+		KUNIT_EXPECT_PTR_EQ(test, s, kmalloc_caches[KMALLOC_NORMAL][idx]);
+	} else {
+		found = false;
+		for (type = KMALLOC_PARTITION_START; type <= KMALLOC_PARTITION_END; type++)
+			found |= s == kmalloc_caches[type][idx];
+		KUNIT_EXPECT_TRUE_MSG(test, found, "allocated from %s", s->name);
+	}
+	kfree(p);
+}
+#endif
+
 #if defined(CONFIG_PERF_EVENTS) || (defined(CONFIG_KPROBES) && defined(CONFIG_SMP))
 #define NR_ITERATIONS 1000
 #define NR_OBJECTS 1000
@@ -628,6 +671,9 @@ static struct kunit_case test_cases[] = {
 #ifdef CONFIG_SLAB_BUCKETS
 	KUNIT_CASE(test_slab_buckets),
 #endif
+#ifdef CONFIG_KMALLOC_PARTITION_CACHES
+	KUNIT_CASE(test_kmalloc_partition),
+#endif
 #ifdef CONFIG_PERF_EVENTS
 	KUNIT_CASE_SLOW(test_kmalloc_nolock_and_friends_perf),
 #endif
diff --git a/mm/slab.h b/mm/slab.h
index 185df5e68419..934b9db1ef6b 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -394,6 +394,10 @@ extern struct kmem_cache *kmem_cache;
 extern bool slab_buckets_enabled;
 #endif
 
+#if IS_ENABLED(CONFIG_KUNIT) && defined(CONFIG_KMALLOC_PARTITION_CACHES)
+extern bool kmalloc_partition_enabled;
+#endif
+
 /* A table of kmalloc cache names and sizes */
 extern const struct kmalloc_info_struct {
 	const char *name[NR_KMALLOC_TYPES];
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 5391149a2eed..406e8688ee0e 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -782,7 +782,8 @@ EXPORT_SYMBOL(random_kmalloc_seed);
 #endif
 
 #ifdef CONFIG_KMALLOC_PARTITION_CACHES
-static bool kmalloc_partition_enabled __ro_after_init = true;
+VISIBLE_IF_KUNIT bool kmalloc_partition_enabled __ro_after_init = true;
+EXPORT_SYMBOL_IF_KUNIT(kmalloc_partition_enabled);
 
 static int __init setup_kmalloc_partition(char *str)
 {
-- 
2.54.0


