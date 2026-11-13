Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73BA8606A333
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 08:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=FaCvEBt5
Received: by kanga.kvack.org (Postfix)
	id 29B096B062E; Fri, 13 Nov 2026 03:51:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24AC36B0631; Fri, 13 Nov 2026 03:51:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 161C66B0632; Fri, 13 Nov 2026 03:51:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D76CC6B062E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:51:57 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 668FEA7D91
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:51:57 +0000 (UTC)
X-FDA: 85429478274.06.BC04ECF
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8E4F4100003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:51:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=FaCvEBt5;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf14.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.43 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794559915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+SHVtZshJgR7EfVrq7tFY+459hSuxkLyCsM2otXIkPk=;
	b=GzpYF442zifQgD+yaLhV7+WHjj1Af46ECHMa/VqmazSVoVxce4BF3MbLy0pXSVKWGsPuAA
	RsxkA7Fm3UcVtb2T7Th+uW1eRdhAfvxOSb1L6rfL5WM6wmlyd2+h8AfWThr7Z4MD48j8CV
	WunaNAR+vSJIGbse/PeSKhyJl+EHEus=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=FaCvEBt5;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf14.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.43 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794559915;
	b=0esLSC63SLfiYaxhBAU+KBk4OS7GxT1F4ern+u2yeTocOfMOsEZOGl6t26zkddPABBtOGB
	WGM0/E+1fG9QEpYulJEUP/5dY2WFFrSq6Eb7gdPhWz3V94/ZSVAh6NOu7+yUyAOVMfeFXG
	yNFltEW9R8xeAUYPKNfmJhRekNwX304=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3b0ae87069dso538935a91.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:51:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794559914; x=1795164714; darn=kvack.org;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:references:in-reply-to:message-id:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+SHVtZshJgR7EfVrq7tFY+459hSuxkLyCsM2otXIkPk=;
        b=FaCvEBt5+3pprq/tZqTfIVAUnab6cHc24a+v1zgEceTr1MJcbKUnjUCBJBWQUBABeD
         rQDmYHvX49ePbD5zIBnP1V9/Y36rXAzueEwbiRbn5RUx7aflXrh8zp0N7kezknYA7o/P
         +iPznGQVZlB8COzNW1zd5M2mPLPHtFOYroLMo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794559914; x=1795164714;
        h=user-agent:content-disposition:content-type:mime-version:cc:to
         :subject:from:references:in-reply-to:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+SHVtZshJgR7EfVrq7tFY+459hSuxkLyCsM2otXIkPk=;
        b=SGUzTdq3X5/NsQmHjezu5+DFvTq48KiqpSof5MxdpUrTXO08nGvkkHy3pDtstHnM8k
         ZiGVse84fqNZj+aFSqgjJuQOKHPII+IkEmDso68cb4xICgoyNLJVvi52+vZkUV6OsFUk
         IO0r1Rlt6bxKxVYZYB74Xu+2PoVaiMC6X4ot64gUuAOGga0Cr5ktyfd8JYAadvVVHKUH
         H9Pk8bm835g805BfDXzqmKHi1fXa/Tt2PsAEIrc6r3Bt3hEaK+prGBWTg5dHFjG8NFBX
         QjYKsKelVfivA5WaYXGdDozcXyg+C44YR65w6hlakKJyqtFLou9BIq2j8ZAP9xL56nyS
         ywkA==
X-Forwarded-Encrypted: i=1; AL+hErFTa8MPsPswA5SXWubkAebKXeD3Dyt/d7V+T7aF1Os1u62VXxSitzizCbaynD1X6k9ElHVJQMh6DA==@kvack.org
X-Gm-Message-State: APuU4Z/2sfWsE+T0qOWbBvxUyWdBbnKxgzy2GUlWB2bV9jdnkjZ6Vc+6
	f6aF9m7xXq7rsy1Z3OjL6Y+nZZX1uOCLJJXkyewkqrnxtiPKaKzmBb/CYFXeYnpriMo=
X-Gm-Gg: AYBFou1qLu/MtPQeqhJ3EEwxFM5tbpY3Dj8FYXzChFRVx36rBN8onnQCxkBbobtpArw
	uDZdXsot4SthyWzPLe4ff7nze4xqLzv23Qf8HVVuqug45yoact/CoSAcVj/7PfTrOw8Rpni+E64
	sOQGW+8Lf1Tuj1bkITEIyzHcVOq+KiF3ECQh0HGlc0d32dh5ydYARJjqsPbLALGdZgf7+btvN+e
	/mcG6LlYGhe3mWB4Z/1mhVOdPO147wmSRQU6zqo4VQaV5eOSEPtnm68+lZaJ3HF7kXiml/Kqb+I
	mO0Biftj30EBClUCNBhMIK6tvwJZzg8hw5kZrGsQtOO7/l8ZfQTM2Yv7qPPb+oQRFmXitV8in9X
	FLkgpHxzSRKwjn87sMiTyalHY6Sne0HyjhH51nVAgczkmsPh1ukX+jhJZPmBAoecombSKGRiwHY
	M0MGL/a9Qj1b3cwBnpB2qjZMp6c1As+0jE04NItfEHjSaN60kIYeBp2UDFoYJbAPj/Uu5ZYpUtm
	Ts+/Bzsqk06iV8WL8rN4DcULiqb/8yCzTHh2eyn0/4X62dB7QBOhccR/gyj23drYUVGC60L2OvW
	yi776oHj/uz0QeX4L1N1eiamHC7NdauL9bIP0afdY8gY1vwU3vJ+sR9reL74czW9fjzQfIB/S2N
	v8Cap/bwzASxxErVwNhZsIBEUhc5aw/Og+F1V9z8+l1GEz76QoTcqlVrtAjZA/shBs6UCuCXPl5
	rleWwuTxuL0gj6MVX12MGiMYz+RTPjs5Fr0Mpyij+HCbxl1r0BTM2MEx11U0E=
X-Received: by 2002:a17:90b:37cf:b0:3ac:9e76:aa76 with SMTP id 98e67ed59e1d1-3b1b09f3b85mr1586733a91.13.1794559914380;
        Fri, 13 Nov 2026 00:51:54 -0800 (PST)
Received: from [172.22.0.2] ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b3b708adsm1115279a91.4.2026.11.13.00.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 00:51:53 -0800 (PST)
Date: Fri, 13 Nov 2026 00:51:47 -0800
Message-ID: <ef93230b8a053d234bcb02392f505ae4b0968e6f.1794506262.git.chris@chrisdown.name>
In-Reply-To: <cover.1794506262.git.chris@chrisdown.name>
References: <cover.1794506262.git.chris@chrisdown.name>
From: Chris Down <chris@chrisdown.name>
Subject: [PATCH v3 6/6] slub_kunit: Add a test for the kmalloc_partition boot
 parameter
To: Vlastimil Babka <vbabka@kernel.org>,
    Harry Yoo <harry@kernel.org>,
    Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>,
    Christoph Lameter <cl@gentwo.org>,
    David Rientjes <rientjes@google.com>,
    Roman Gushchin <roman.gushchin@linux.dev>,
    Kees Cook <kees@kernel.org>,
    Marco Elver <elver@google.com>,
    GONG Ruiqi <gongruiqi@huaweicloud.com>,
    Jonathan Corbet <corbet@lwn.net>,
    linux-mm@kvack.org,
    linux-hardening@vger.kernel.org,
    linux-doc@vger.kernel.org,
    linux-kernel@vger.kernel.org,
    kernel-team@meta.com
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8E4F4100003
X-Stat-Signature: 75atm41osgf5spcoe4a3fkkj84tucbxk
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794559915-797298
X-HE-Meta: U2FsdGVkX1+scKOSKq9RX3XTGBbkdfMgGy/v170gTu4VV4EPzxn26EVoIrN3stbOcDHZaHqAalv66JYqIvln4zeMExeFyLKp1iSL7a7m4JBIfNP6gMvmXYCjpbi+mEkYzqw5huHy8O6E8WitgbgwynL7OAkFLiex6z86fp01LfKdlNT5FhuCf+84XqRQ9S3q9nzIhwzw/SUexSW0+PusnaUgOK30wSrR9u694hSgO1SU8mY42vzi4AARd+5scCweKfgSStxhKv9qVGQiPenD9EcB3LlB42zvs2u8DRsuLTU8TWeABtG+zS5FEKJRXxNlYYNlFH6gxSYfugjHEsHc+jcBJYiiSS+Hwj1IRpY5xVWNkIlhFvNG9YHVaFTJ4M/eCuQ3DUNVfQ8VtdrVYn8so2+LBeDgq6I9fhv3ZCazIa5a/l+BVpQUqJx/kpIB+2v3d5WsZwSWYzoyA4wELMwNbp4230xU06QDl+WTGHCp210J14rEKAqKMACgEFWujtZJ/KaX+hIa5a4FnT10Bcz+NBPXt4g5SCoIlCXX1gRUPGGWq7du7TQPnnAc1vKO74S5hPmeEVzCZ1XQDwTfNvO3EMCMgVZn/yHqdDneWclFZHDHuXBr4JpE9AfH/szzS2qse4zHqXSl3G/y/lc6QmBVKK0lujNKIc7x3PKVcSaHRgGkYsC9ICG8Rsa269/irz0BeSzhidkHtNTR6HRXSONpb3Ptw3kW5zYd0LA6bLG4NJx1ZTXih/iHmeoeXKJZf75R863OZSXpYlyKlK9oks9LV2OanQTzqEn9hXaiw0ORKLBu9jrw/n9GHMW7lwff15V87ywuojTsBRXkaRyJOl/4o4x1Zmev9BM/6w+F6M2Y4nkAtZLwemALPuy1tX6JaGvZ1F+l67OSlmUN3k6HUdIOCTir1z22pi3ym8D1LM1pz/8FjLP2kdLOv4wY/jgyv/2cPQ0C2m/jP/yx50eIjyi
 9kftx2An
 jZdLGxmG6K0HVOifytYDv5V0txsn8Qe3P6xqk27bBnHdfQYdvrKZIXhEiFREfpRaERox/JYQSo9xxrpmu25bEmCDAIJoohInZ2BgoJ44dEX+st6vMKNAeCM4LgZu61EsqGjVL9eFMBu8jcnInyDlLGV3a78abfxeoWXi/VJd7HjMtWVljVV1HRyMaAbpPKfVMBD0YUtBu97Dh2Ek4oJOrrHT2a8tKf4R5fSCuBvI6950HRFsNfSK7r66iTq4K7jnMAyx3V+94Z/qSQvOZg+Qxii8QHtyUKc4zCmTRc1JXCJM5BQkqLb+vqq2rNBDq9E1UAY58jUVk6fOkZelkcTR8oQTayrCLVdRYzEnek+i6jOml7DIVpkFZC0c5h3jSteOyQAKWWtyzIZMWufXvQYDd6EVwZllJNBL/FjhyA7v6k+SRPK9qYKKokzKyAY+1MCtuY9y+wLmiK36Tb1NtbOk+O68bBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Check that the kmalloc partitions are separate caches by default, and
alias the normal kmalloc caches when they're turned off with
kmalloc_partition=0. The test is skipped on kernels built without
CONFIG_KMALLOC_PARTITION_CACHES.

Make kmalloc_partition_enabled global and export it to KUnit so that
the test can see it.

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 lib/tests/slub_kunit.c | 45 ++++++++++++++++++++++++++++++++++++++++++
 mm/slab.h              |  1 +
 mm/slab_common.c       |  3 ++-
 3 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index 1af3f087134f..61227c242ae2 100644
--- a/lib/tests/slub_kunit.c
+++ b/lib/tests/slub_kunit.c
@@ -334,6 +334,50 @@ static void test_slab_buckets(struct kunit *test)
 	kfree(p);
 }
 
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
+	if (!IS_ENABLED(CONFIG_KMALLOC_PARTITION_CACHES))
+		kunit_skip(test, "requires CONFIG_KMALLOC_PARTITION_CACHES");
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
+
 #if defined(CONFIG_PERF_EVENTS) || (defined(CONFIG_KPROBES) && defined(CONFIG_SMP))
 #define NR_ITERATIONS 1000
 #define NR_OBJECTS 1000
@@ -528,6 +572,7 @@ static struct kunit_case test_cases[] = {
 	KUNIT_CASE(test_leak_destroy),
 	KUNIT_CASE(test_krealloc_redzone_zeroing),
 	KUNIT_CASE(test_slab_buckets),
+	KUNIT_CASE(test_kmalloc_partition),
 #ifdef CONFIG_PERF_EVENTS
 	KUNIT_CASE_SLOW(test_kmalloc_nolock_and_friends_perf),
 #endif
diff --git a/mm/slab.h b/mm/slab.h
index 6a28951f6d5d..2a9d6a9a9948 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -391,6 +391,7 @@ extern struct list_head slab_caches;
 extern struct kmem_cache *kmem_cache;
 
 extern bool slab_buckets_enabled;
+extern bool kmalloc_partition_enabled;
 
 /* A table of kmalloc cache names and sizes */
 extern const struct kmalloc_info_struct {
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 20b066d61703..d0695e4d2ab6 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -781,8 +781,9 @@ unsigned long random_kmalloc_seed __ro_after_init;
 EXPORT_SYMBOL(random_kmalloc_seed);
 #endif
 
-static bool kmalloc_partition_enabled __ro_after_init =
+bool kmalloc_partition_enabled __ro_after_init =
 	IS_ENABLED(CONFIG_KMALLOC_PARTITION_CACHES);
+EXPORT_SYMBOL_IF_KUNIT(kmalloc_partition_enabled);
 
 static int __init setup_kmalloc_partition(char *str)
 {
-- 
2.56.1


