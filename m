Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85028606A326
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 06:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=pVMANl8C
Received: by kanga.kvack.org (Postfix)
	id A95506B05C0; Thu, 29 Oct 2026 02:09:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6C976B05C1; Thu, 29 Oct 2026 02:09:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 982CF6B05C2; Thu, 29 Oct 2026 02:09:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6EA356B05C0
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:09:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 02C7C1202A8
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:09:29 +0000 (UTC)
X-FDA: 85374636900.02.A38C198
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 32EEB100003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:09:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=pVMANl8C;
	spf=pass (imf14.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.172 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793254168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kJG/RgFaRLdMkGdKAhf/ALFLkcE1J6knB1UbEQSKpbg=;
	b=XKWZXNW/9JIf4sm30xk9+S7uP2bSHcvWxeW3cLfQTV0Bqm7va7/bUUOBm3DQnzVQs9LvBu
	Jag+9XvP1tSMW597Bhk//M0+BoAjPn2mcL5CfgH6yndC6gyRsGfw2jl9bJbd40KpGjVlSG
	xdxGkCfcMenkyg/AUKu3nS1wq22jeQc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793254168;
	b=YCeQ70pYbDFC9hTE9hBCQIIJwVgh4dzf4cLbiHBguB1GBvHAuttbAk90PoSy/R0cXlvw6i
	2A2OxXTzLu7BnHBHAEF4du+4cm9S+quIJ4hP55Qk2S1fca20H2Tw/t/PyRMXn9R8GMkRGo
	Q8yppN0932k6VfnmlefyMGNbvF3+WI4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=pVMANl8C;
	spf=pass (imf14.hostedemail.com: domain of chris@chrisdown.name designates 209.85.210.172 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8a058315c79so894421b3a.3
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793254167; x=1793858967; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=kJG/RgFaRLdMkGdKAhf/ALFLkcE1J6knB1UbEQSKpbg=;
        b=pVMANl8CEccF9rEEmVxT1RvB8muPTiW5tavcgvw4ZCPgPEE1Tq5DFjntvssmWNAB5i
         3l0TxMF4FQesaWC2m4ZH1dF57zbRS8DSVeouUan3X7SITkbWGqAXoMk9xcFzHn1N4Z24
         u2jMZ5N9PI8PTU4HkcdR/Xz7Qu2AeM5YJVG0s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793254167; x=1793858967;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kJG/RgFaRLdMkGdKAhf/ALFLkcE1J6knB1UbEQSKpbg=;
        b=SYFCdAmb7m1Q27+noPqc7toJrrbYsmtjr/3wqbuFCeUcvlp0qBwg2b+Rqb+qLP3gaG
         jdnlT0yBO2n208bExCUL71R4TSucW5TUrr6hSVZU40h4Rt5OVxp41RTOi7bYbrQ8kmeS
         Pt7U39FrcyXdkdMeqsX1nfqroOm2QLqQTcC3d4faeQMqYfn4sE80UPYQ9NH4WL5zGWFu
         0fYOmuZ+FDvcf1Akr+Yd/DMObETFy+9FIQVa5RvOQgMAPEtM+oMwRGg44NvrsxKfBG4a
         lqQYNTNvxjbXEoPporlaEj2pZUIzvap6z7qAwP8amowtZ7RLy7qljJYbEc+F2arDLZfN
         EOVw==
X-Forwarded-Encrypted: i=1; AKwUvBzeKufbnNHDa54FH1OhlpRmMMjz4i1hwOe1qxhkSvDNWpim1Sy3Xg1FTZ8JGqxPj6Tn5gPi35Bm4Q==@kvack.org
X-Gm-Message-State: AFq9FYISDeQhFM+i2058rSyM8oiABhqDr0nSyIikgeEn3nnKvkwprAFG
	JI5IUfIKckh9+NCgYeQ1P30nIkjXLyCRBGlV1wT81bg7Q+VRzcUVbavwD0xe/Y8U+oQ=
X-Gm-Gg: AYBFou2rYe/s/lb7fb/ZlOPd+/ABtHkDgedo8lIDvENn+epJyzYPUdH3wygfVAf5Ozp
	D6PnAou781wsoh5DINzxLokZUS/mkSUa6lljF7hDpBEtgbdpvP0j7351BjnE6VWjR1idnIRInyk
	CRuuJYPGtrkAjbQ+peg/2245TxVt0mOkO+LRAF+9Q0CaPGj+vpT2xcrE0qxs16vovgw3u2vsgej
	g+o8tLUPI8TFJFMWhuOS3aTvEJR2BbZ31sp8m9si4Zqit9U6uNsorM/R1AtTFYMm+7c27QZElf1
	O925Xnnijg1+IJTfc4DIxUie91D6/YoplK6kDV8WUzYogVpIiG6d8LGbIwoL69FfhOLIupoBVMd
	PdrXE87YZuFrSED9ZUUGQNDmULyXJCW+41j5+yvMvNJjwVWncto44j3z2HTgJSh4tZrjLO9YYm2
	gSzxKGqg5i6Eso9Bu/qPOz0ckljG7WkdcrzcuiqduYoRXpsaz07T2ELi2lLsRS8976+bhi3GUWp
	S9dzxW7ViKOG6byGKETE3huug/j8PxkLISb/RPmaRDdGIFEEnBIphVo1NX7qtYRC+LBvqrzDLwN
	DLbht4kcYU+E+X0iJUAyx7LhooS/5oqcKF87DS2ENtFT7NQIvhf3dbG5UlguF1o1OwUraBzyUWt
	FA2K1iG0wceemVr7tvHGJXgnSt244bKp06b1E7edKvk18LIeGMafr2KV34HOPgIprqTREEoGljA
	YEuf2WjLQtLGZtT2VX/as=
X-Received: by 2002:a17:90b:4cd2:b0:3ab:884b:659e with SMTP id 98e67ed59e1d1-3ae57f96d53mr3126592a91.9.1793254167010;
        Wed, 28 Oct 2026 23:09:27 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e9bc6f7sm2447023a91.16.2026.10.28.23.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 23:09:26 -0700 (PDT)
Date: Thu, 29 Oct 2026 14:09:21 +0800
From: Chris Down <chris@chrisdown.name>
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <kees@kernel.org>, Marco Elver <elver@google.com>,
	GONG Ruiqi <gongruiqi@huaweicloud.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH v2 6/6] slub_kunit: Add a test for the kmalloc_partition boot
 parameter
Message-ID: <66f981ce04dfb01d02d1683bb18ba6db1c4eabd1.1793253633.git.chris@chrisdown.name>
References: <cover.1793253633.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1793253633.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 32EEB100003
X-Stat-Signature: rff345ojezrko6bqdtdzdjbaumw49mz3
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793254168-567632
X-HE-Meta: U2FsdGVkX1/LPwpxEZ67wKXn3KJaUkd89DFlzQfpKB8CGYqfTkW4l2rTjDbuIeghkuLLPmIbOw6gpf5u8PhiulXqxn9KoZpsEEqiqZgGisaetQT/HI6+PVZr7gQlCng1t4HiRgxYzG2kVfNp4Y++M9n46oGtCJ4G6Qwhh0MShWI0QIwomlIkeqHlYgSgVleKv0CiIER6D90IRPwAVfJpsK6rDzqVeyQQoXV1Wpll786Rfxn9DhA1Ugk7BeIvNsNZC/OjyLnbFK1OmRVM2w9O1/HpgbGbDyqfDprlt33q0acdh5MQ2dhmRqosUi6r5CDU+W7OQjYsinnG9dWpPCc0UAX9xwAUSpEgmkEVuemL1BwcyE9HxaH/FLrN5oP1i6S+wzXwB6SZDNuX+I1D+gL2nZkMkz6Tezu8TvyVXOUaQhPvf7Ar1uFfx6kAyiJPFXRAiBE8UhC8f0W+3TR6m35bU7uL7q6C0vCU8kika8y550MI5sUL+U97woexfKZ8w9WVb4OquwOf9Ai0XkXsnREN9Rq/eil0lda+QlgRt593p+zMnD03d4ZwLRzUVaU/nDs5otqaxo7eV4RQUboPKG/dTgJqj3VXDd1aDV79ER7PoNzpJdkrTNsi3tEBpmOPbCigqdUVLnDGXyV8SVByr6kzHUzh9jNAetVdF1T432aQx+9tpqUZkDmSERaAuvTWsbY7VeI9V9HpLycwQWKdyqonW6e1iIIM4P03cAfnrUAG5YnQDAP2i3He8Dhu8+AAhhc7Y5gK/Y+qDw+3/90NsPjqnb5yf2P4a3eDWQ6NNFZglcWaQGBraIkgQIJ02pmxDpPOhr8IbP2lTkfVSwAbWaqzViayHfDdBrLba+/1q2hYVYM1xYLDD42OeoAmqGX+d7O5y9xQ5uP1nhwssaLFGlKnmxZuO8KQJi4U3nxnZnHS7P6Wx+++N2dBAgOF17bdfGvkl7D5UPbe0ZEjt2Bz3ao
 aPB085eN
 xZD61w51FAcZGpvE7uARBfGJtAiCwojKcPJHCWZGXVT6eQLr5FcQ9EU9lCf4fdTJj4UyuLdy+z6qP68AxCYYkxxuqrJ/U9jpTTrfGVnMGZlpi9BtUkRKTiCjJSp7crmPnHSA+yVnJIcA4b154mLt7R/Zc0aVG+3u+hrpmcgks5eeQ/MUzm8qissyhL/EFADxEA/ogcsqpBdirko79Ob2dUjhaioAFp6kRs2yogTKigp4PS2rCO4n6L+GgjITAX3drXiM3N8rt6oWWE5cCM452YMNx8oMSSpqi8dJK0bkYfviHI+ioGXUda2tW3lnItV10ykdcfk/13+sEssFFy65I3pDQadyJQ1eAfoi8d48kT16reo21o9WTNRpe/Z1N0qHuUjTLL91nPwv0yjlwiFOHy0CA8XK5mR07T4LP4silnumXe2Rw1Y9v2w2c5eKNwzAXMXke5O54Bg0m/tYEm4vx+kueKFpxjGFjxHHo2dYClbvS7vrZrrC/HICLzOQdC/3P0vU6UmCl+WoUb6w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Check that the kmalloc partitions are separate caches by default, and
alias the normal kmalloc caches when they're turned off with
kmalloc_partition=0.

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 lib/tests/slub_kunit.c | 46 ++++++++++++++++++++++++++++++++++++++++++
 mm/slab.h              |  4 ++++
 mm/slab_common.c       |  3 ++-
 3 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index 670645875b27..e3035864577d 100644
--- a/lib/tests/slub_kunit.c
+++ b/lib/tests/slub_kunit.c
@@ -333,6 +333,49 @@ static void test_slab_buckets(struct kunit *test)
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
@@ -529,6 +572,9 @@ static struct kunit_case test_cases[] = {
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
index b5b344d6e402..8e1e5a3f044b 100644
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


