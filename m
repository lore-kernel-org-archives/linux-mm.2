Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EA2A606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 07:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=bRAzYnWU
Received: by kanga.kvack.org (Postfix)
	id 274696B05EF; Tue, 27 Oct 2026 03:35:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24BFD6B05F1; Tue, 27 Oct 2026 03:35:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 188366B05F2; Tue, 27 Oct 2026 03:35:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF3816B05EF
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:35:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 82405120972
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:35:49 +0000 (UTC)
X-FDA: 85367596818.24.B0D4294
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9941C20006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:35:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=bRAzYnWU;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf13.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.53 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793086547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sN6UGPpUTXeJgZ2lTe0CetjR/EEvcG4cIahELjc1+Mo=;
	b=bsBuY8qgCpN4id5tGV80pcw8vRz/vmZ8hCRaYS0kcjvoUwdRqGmbDUtol2rkPzmMqr2jFp
	0ukBCw6LqJG2G2i04mT5rg+PYwhMCipB83jGI3INqjO9Ki6L3RYIXSakzqtcttmn5g8hRW
	cOdxhUfgXE830xQlQ41I5r3wAlQ6DFo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=bRAzYnWU;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf13.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.53 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793086547;
	b=gyy+Hj2vHOmqNisN6ZJ4h+BmLIw58WeJFuPa3ktg5ttgh374CzDbN/GKZhMzZeRySWzAdj
	InR+GqAY8q++jX9/XJVY5NZIKWGlBUVjHobdi/JWrW4k8fSP7RD9m5MQpm0H14WUJL7sYJ
	Xn/fi1y4MM5eYxIsNx8Ox8nP+rBgkJ4=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3ac77270fbfso1946802a91.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793086546; x=1793691346; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=sN6UGPpUTXeJgZ2lTe0CetjR/EEvcG4cIahELjc1+Mo=;
        b=bRAzYnWUQD+OA8uqiRfzcsctpetwXCpOWJ/4OlqnmDAVMKMFU9vKDPEuLl+JNOSvG9
         O3/+Uqi59uWMrVa5rzpZAXLIbsqWhhLIkg9iBfhCWAHTd9fPRlP56GI1knjlSzoDEsY7
         vdIi6hwTuGO7YGBJMW8D9i/kM1GTfAUYSoiMA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793086546; x=1793691346;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sN6UGPpUTXeJgZ2lTe0CetjR/EEvcG4cIahELjc1+Mo=;
        b=1AYhjc1PNvge29M7JkzE3n4bDBitfJYt0cXOSSMHCybEPczses1uIYaUJWErhNIQJP
         LBnMvfF3pQKln6Hnu0sXOrXRSdC7LmzyFubUES9CwIiVdNX3MDwrBiRvW3W4muF76oZT
         huTJ1Mef71y3nJ6B+3QZB9ymT/Mw/yDT/JdgvMmgGfD6EryJEcU0K4vSY5joxG+lipCd
         nivpPFRYtIgQRexmxzm4aqswAoXt+1nVL+lMqFkSLSJyeUSDKe2bL0rQyTCq8Ho4yz7/
         pLBroheotc6Nsp4IU9k5hITNKKKUsK10M+4Kk9QbmKJBcfXU0p/DyQE7+lk/SAeA1DvZ
         6RPA==
X-Forwarded-Encrypted: i=1; AKwUvBzX6sKs1NidC3jNoHUjWeiQ+fggK/oAQhLONV3NrzBxb0yPxWHAMqrQQ6emKbOyGvQWTYqYsqTPdg==@kvack.org
X-Gm-Message-State: AFq9FYJtAAdNQrJeCfLv6kLrqRXSkphJvQcM8IP/fzUeaKXKSXENukZN
	Cm/ZYnUE3zDkH5uSwX09O5yRbQs5XRGzQIyZbvZ8kK2bMQov90/N3vfHVxSDTlB0ZfgQZzJI1R+
	8YVkZ5v0=
X-Gm-Gg: AYBFou1/PnGniQzHvlDISfj69fzv+og6QXub+0bqtorwOcuk3gc/+7HBi9lyXdp480d
	7aZZ2C9WRILf8bUTXYjkWDQP1cTSBqiPLlpFJHIJjdYGOmlI09YgNWLUbSCk8nCq5zlBxRWd1ve
	udDUIjolC2ygBDfolwP1b8A17iY1u1919EWdhtO1oZttF8NDmodvoUcb3g1j6otvoOrE8dELpVd
	nKI7g/k4htjTFLQCAMfKhb6fHF9CKAC8Hd3uivGaCPD/GykO2CVvBt6rkqSf917KeCfcDrNenXE
	E3Vh8oEiyKcBuq/xaSFyfq3OAXLsjNg8ejo+vU6h5UEAErwqkLBwAU7DtMU+bUoIL6OFk+vWI5K
	lmLxbZWAFdEaSUIU9bML6xA993gL1w2v34dd2xqNsil+PC9iCdEwJIkwND21lD3PpZ/tLkGINAp
	NSP/UDjpAEus/oaVcl04ZcjBSYYq2uxnJo/yQLotNIzTA3mKIqErYH4j+JY7w26E2sN+oT6VUCE
	mMaSwPmzbCytpiVg0ijUOdcGbllaxv187AXbgNDwrv97bMN9hSQAYEM1JviYwrYsMHpnbM24dLv
	x2UpBHQHEPcSp1MO4qPUBfLNYbguLcJQiw1YrsHc6Rg/+c29bcl8uC2KC2eNCWXHE6oDXcin/2m
	SbgrLYqVwqOFyfdznzxPvwpk=
X-Received: by 2002:a17:90b:4b92:b0:3ac:6fcf:81a2 with SMTP id 98e67ed59e1d1-3adeb137d1cmr7346559a91.57.1793086546607;
        Tue, 27 Oct 2026 00:35:46 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae40614daasm2511140a91.4.2026.10.27.00.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 00:35:45 -0700 (PDT)
Date: Tue, 27 Oct 2026 15:35:42 +0800
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
Subject: [PATCH 2/8] slub_kunit: Add a test for slab_freelist_hardened=
Message-ID: <b5bab23337f5448d8a134c71d42a9e3165ba3366.1793086056.git.chris@chrisdown.name>
References: <cover.1793086056.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1793086056.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Queue-Id: 9941C20006
X-Stat-Signature: sfdxj9p1w5p5mmahdepceijfcd1n9szn
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793086547-615301
X-HE-Meta: U2FsdGVkX1/rTm8fZFVBcDX1JtAkwHyAAz9x8ZoGRTj45tLFXWyBR4M61HTWHtxtJVIgh57ARMUB+2GEQdIbmyAipKYfCC/LVN+kJLuKaVSPN0t/LyZYENic8HRGBgkOlAScPv30Gg1WsUGKwTmG/ROhQV6+OC/OA/f99eWWv9xQGc1ESxuHIKs1m5aUtyrEqyHs/ZETSlVg6TCoD6RI41OGKrLf59MIJgPHWbWNILRMAKGjEEG0nHeSDL/+KyerwaK2XHcKSQ3KtwNOtZmSc/zeN7ohVHfT6GfJUZkEs0DlbZSGtoUerbVQ7C0oSe8apeFEBjY1S42TwS0VogsbyFAk4aXeZURLD3aCYsYqC9KEL4uKsixQpO/5McPF+pRmTRlNng+gLEa57Gg+bAGWMWtziPQRpo8s6KW9sU9596wFUqoJjgxzA8IGRuRgtnXnGdfJpNdgFBsGK+efv+c+YDqVlCFm3tz9O5qKrGv8aKA8D66Icadm8tzcgFhLNa4VuLKLEu632IS0vAvyD8QAtPq8nwNwJ94lgMValPBtYUm6718sjmaKMwMx9354rwix7p+u2w38I/dE/MRzB/Z757PAVKAF/TNDMoHqSM5tvkZ4MLMbb2Huau91kffvkNPlbEsaZTgaxfpL3VkFSumd2JzbFjPFaB7XXePNBVaozApXxn1FEFJCbLOXl1Gaz+4q20eY3qzMJ15tbAG7v7JmXb9aMOsA3H7nUrCd0HGCLwYkbJqLfvU/w36CVNqmcSk3sOMGKfDHKnzlaaHPdlBCd9eCNGrdjLXvRJlUTI6VhjSoeI/0yexZQSPmm+9jc14dy/UgyeF/WKmZf6Pj3ra2k521m+5yvT/ezBeTlasFGw4Mal981nIhEFwO5Whx6xQXYgqMPaPD0r1sMNvc/SRs3XlztoWKVxIUOdAERWxgXqTecZgLNQHH2zB4+Ml9OnMxQsz8ODto/7W8cQ/OcHA
 c3bw6Cxv
 dmmdFKbwY0+56Z/RT0llx/bTfFQqDsnLepKGAxgF1owLLokV1dv4PsW84L5INuJLZQn/8rUC0jZkDPyJUkp+AsPKBSRXu+haApyi6hSzDqDyOjAgfumSDh2YUAZB4k3RZP3u4s1Fil86GibGndLCN6UZX/+OMPHCPdmjE5SWtHX8zWinpgiGvPXt3bk9DpzF6vX/QGM4bSq8Gn4JbpXhpuRScGP/5otkxu+mbN4VkXlyGfQ7L2DxlxoA6BQnwBtRu5XCiuywAxeS37vOdbFkRLpBFoFHXQdxaYo7z0kMiZasGa8lFw94EOUl7s3VLElE+hAuyD0t0wbwksbkbaUZZFOy7Wc40VJey819LG/9yKUmlbqQNVve91hvNs4XUeNhs8DaZy7sYTCEDRDxi4Vv9ojysxNlIBbZaVaWi5V4Vf181T5qhnf3QlPKSbLnzfXIWahazCjwc6uGn6XwzdFoIRFwrfFzPjWqDuSu40jlXHMhKwBtHLCwKQkZzVncnlkqYsBR3Fx1wcUPB5FU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 lib/tests/slub_kunit.c | 52 ++++++++++++++++++++++++++++++++++++++++++
 mm/slub.c              |  2 ++
 2 files changed, 54 insertions(+)

diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index e3b63f0338d5..5ace73368523 100644
--- a/lib/tests/slub_kunit.c
+++ b/lib/tests/slub_kunit.c
@@ -9,6 +9,8 @@
 #include <linux/delay.h>
 #include <linux/perf_event.h>
 #include <linux/kprobes.h>
+#include <linux/string_choices.h>
+#include <linux/swab.h>
 #include "../mm/slab.h"
 
 static struct kunit_resource resource;
@@ -107,6 +109,54 @@ static void test_first_word(struct kunit *test)
 	kmem_cache_destroy(s);
 }
 
+static void test_freelist_hardened(struct kunit *test)
+{
+	struct kmem_cache *s = test_kmem_cache_create("TestSlub_freelist_hardened",
+					64, SLAB_CONSISTENCY_CHECKS);
+	bool hardened = slab_freelist_hardened_enabled();
+	unsigned long ptr_addr, raw;
+	void *a, *b, *c;
+
+	a = kmem_cache_alloc(s, GFP_KERNEL);
+	b = kmem_cache_alloc(s, GFP_KERNEL);
+	c = kmem_cache_alloc(s, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, a);
+	KUNIT_ASSERT_NOT_NULL(test, b);
+	KUNIT_ASSERT_NOT_NULL(test, c);
+
+	if (virt_to_slab(a) != virt_to_slab(b) ||
+	    virt_to_slab(b) != virt_to_slab(c)) {
+		kmem_cache_free(s, a);
+		kmem_cache_free(s, b);
+		kmem_cache_free(s, c);
+		kmem_cache_destroy(s);
+		kunit_skip(test, "objects were allocated from different slabs");
+	}
+
+	/*
+	 * Caches with debug flags have no sheaves, so a and b are pushed onto
+	 * the slab freelist in that order.
+	 */
+	kmem_cache_free(s, a);
+	kmem_cache_free(s, b);
+
+	ptr_addr = (unsigned long)b + s->offset;
+	raw = *(unsigned long *)ptr_addr;
+
+	kunit_info(test, "freelist hardening is %s\n", str_on_off(hardened));
+	KUNIT_EXPECT_EQ(test, raw == (unsigned long)a, !hardened);
+#ifdef CONFIG_SLAB_FREELIST_HARDENED
+	if (hardened)
+		KUNIT_EXPECT_EQ(test, raw,
+				(unsigned long)a ^ s->random ^ swab(ptr_addr));
+#endif
+
+	kmem_cache_free(s, c);
+	validate_slab_cache(s);
+	KUNIT_EXPECT_EQ(test, 0, slab_errors);
+	kmem_cache_destroy(s);
+}
+
 static void test_clobber_50th_byte(struct kunit *test)
 {
 	struct kmem_cache *s = test_kmem_cache_create("TestSlub_50th_word_free",
@@ -480,6 +530,7 @@ static struct kunit_case test_cases[] = {
 #ifndef CONFIG_KASAN
 	KUNIT_CASE(test_next_pointer),
 	KUNIT_CASE(test_first_word),
+	KUNIT_CASE(test_freelist_hardened),
 	KUNIT_CASE(test_clobber_50th_byte),
 #endif
 
@@ -505,5 +556,6 @@ static struct kunit_suite test_suite = {
 };
 kunit_test_suite(test_suite);
 
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
 MODULE_DESCRIPTION("Kunit tests for slub allocator");
 MODULE_LICENSE("GPL");
diff --git a/mm/slub.c b/mm/slub.c
index c82bc626b657..de4937fcb293 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -46,6 +46,7 @@
 #include <linux/prandom.h>
 #include <kunit/test.h>
 #include <kunit/test-bug.h>
+#include <kunit/visibility.h>
 #include <linux/sort.h>
 #include <linux/irq_work.h>
 #include <linux/kprobes.h>
@@ -220,6 +221,7 @@ static DEFINE_STATIC_KEY_FALSE(strict_numa);
  * so it must not change once the first slab has been populated.
  */
 DEFINE_STATIC_KEY_TRUE_RO(slab_freelist_hardened);
+EXPORT_SYMBOL_IF_KUNIT(slab_freelist_hardened);
 static bool slab_freelist_hardened_early __initdata = true;
 
 static int __init setup_slab_freelist_hardened(char *str)
-- 
2.54.0


