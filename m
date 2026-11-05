Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4E54606A32F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 08:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cejgT5a3
Received: by kanga.kvack.org (Postfix)
	id D0E2D6B05B1; Thu,  5 Nov 2026 03:44:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C70BD6B05B2; Thu,  5 Nov 2026 03:44:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAD396B05B3; Thu,  5 Nov 2026 03:44:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9559B6B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:44:02 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 307A414095B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:44:02 +0000 (UTC)
X-FDA: 85400427924.13.E7823FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6EF90C0004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:44:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cejgT5a3;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793868240;
	b=Xm+mApg39tPCklImbkRbc7o2YHszlRqB1lJ+7fMIitDD1h/HcOIB/XTvVNNNPwVKbxAxBn
	DEhT0nkHX77Tdg2f0MQor2eixxoGK9yPsuHessw3ws5EadgMvjhlY3lGdw+QnK+k9nx/5G
	zPuLdi+iahYDl7kYhUHA0FBz8dqnprc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cejgT5a3;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793868240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dm7hinjZ2Hv+FWkKpGdKWF8U9Pzj/MHQHGGecTaoJOg=;
	b=1chFRxg/oU1+oz45n3REl7ubgLKQY7/HYraoUrE1FMtavfiPQl1EmkJUuOJKDtUl9xJNjB
	GnQU5iYY9N8a1Uvnju8EfGyEuKI2uoBrh1T/0Qqa0tPzCVatHcg32ZKzULfakPs4wJHC5W
	j23lPTSba9fNJ96WelMyLH+Hdzgy3IQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 62EB440C40;
	Thu,  5 Nov 2026 08:43:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E7161F00A16;
	Thu,  5 Nov 2026 08:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793868239;
	bh=dm7hinjZ2Hv+FWkKpGdKWF8U9Pzj/MHQHGGecTaoJOg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cejgT5a3IGcZ7drU+mnxmAA0JdW+j4iFA8tEz2xpYm+bBKiuBIuQ0K7RKlwvUOYPY
	 sZrI+CbasH1q5A/qudt2JA4jENjECGpcW7XC39O3D5GiWQQxfIIdLg/FZ7S9INv6cT
	 owd3RXPAMbUUea6PDY8nPlgnS14ohetgj7AkTLhfxEMtXOsUjyo+x/Olvz6PAK6pcy
	 ae0uOUofbN4UoBMUVE3BPlzjdxT/PCtVxcyySaikhYXN4lMWJfQgD1Qa3faPLj495E
	 TzQYA07ncTOgCjByaGuQ9Dv3LXMj87NV83PEJEKRwXJbzTj8JZwmurMnMxAPIig19Z
	 lAMpcuu3BBCrw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Thu, 05 Nov 2026 09:43:50 +0100
Subject: [PATCH v3 01/10] slab, kunit: pin test slabs by an extra
 allocation
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-slub_tiny_rework-v3-1-0484ce59eabb@kernel.org>
References: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
In-Reply-To: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
To: Harry Yoo <harry@kernel.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
 Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Stat-Signature: dim1qrfb1ofh7hoikbyfpadff4i681jp
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6EF90C0004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793868240-182337
X-HE-Meta: U2FsdGVkX1/pD0D/PoxXWqKMuf8kbLzLuXXxbbXPhkhAj6svAZ3B65kV/mYLZQHW0QsON37F7mDTIublLHelTYvxH6VzIAj2UOFXHNZaYEqd90p1zsELHPsFjrNxgcQlwy+cnG8VvTgqTYe5Y2MnwNcoH6tUO2YMP5FYiggVYr3aN7Djz/OB/2s6brh0vcmiEmoyOo+EL0huRxvvdS9Po595W2wRzXH2MmgyW0QHNeG1ZFF7kTevXZvUMWo98laGKR0MUHep5wDlnGB/0ErZZtI+qOTqy3Rog89ysgfAFWnXgLjfnjTI4Zv66jBcS6ziTALsVouhkbjkwq2sFu1W3bRJmP3eMls3BCg1sfxetPWsq3EewdzjwZRwaVPiYqxOkVTNT92ki0gM4CmVn24RMRDP4B1n1WdyT92QyZmjO8uRTmX3WFruAJUJnVpBhpG9/ETwq/qdnr4NlviMPVoaBs/MvRiJVB1An/a0z/GsU0kBeAgqY/p1kwirrr6JjLTs+EkCwmPT3yPebSpr/CN/3j7u6okSFDFYtaUQWXmFyXlUe6l8emXsHdbwb1DaRS/7FMZ/tMQBxRVIVq6kkx7f0WerTXl14iU4jwNK6PYpY7iV75xPtvOw4qqrVzBODkItgWsT+imWflGXYipCIT0d8vED/jGBeIPQPexL1bmS+vYJxBHn2bsu6N8MktmHSgXGCkPZPOd8xjr6eV4I6MQC4DBECfs7ymvBfwAqNJfFbmr992D8tvLfuoBGtuoAdu+96FIn3MlL3NwZ1Zv6+h7tpZ2PruPXcWL2rNGrGbHGu4WghGXJwDB9MD5HIuj4j0wh/j0wtYA0dG7OkHTU0uBYKpy1tcNKmhFAoa3OnSwKdnM0akM13Ns6p8WxykC9y5AfPR9gMKJ/U6UZQYH4Dna3DjiPRX38BA1ZGennlzAeqelR88r7SL/ON8ZNusXeogPBHrJPLSLmschpsee30VJ
 MpewmMcg
 x2JR2gTPDdE41dyJVntLfR9sNKtqp202OPcI3j7ga2lZaMXV76Z6fNbDwB7AdpGtr1WI3ad3xRpVJCZVUAgk/xWaE8N71Fq/QBD/Jf0dnvXr7jrlqEOtGWhWf1g2ORc15H7zY6txkkjsQppJyN2MlQ1pndO9p2VQnEMLAOVaz6Szk7eg7Xcm3853E+zaaC3GkWNL4i2FATO6DU9eJZU1patPEpZEqvPpcLmdfzE1Ct4NIJ/9j2iIyon9VYA80oPO6dSYjxf/i7nXl/8ODIg8lUbdwgXYyxHm53vBM3pWcEV5XKwwePYZLK87u4gy9/cYCjYaSd1c4pcjg6R4tTOu4uFKlERTo4yBZPhKZuBiJkp5869MH5LNN9zO4A+bQlhPvGz1r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Several of slab kunit tests allocate and free a single object from the
test cache, perform intentional UAF actions and validation, while
expecting the empty slab to stay on the partial list.

This subtly relies on non-zero s->min_partial. It currently compile-time
defaults to a non-zero value, but in theory a sysfs write racing with
the kunit test could change it. More importantly, the upcoming
CONFIG_SLUB_TINY changes will make it possible to run the kunit tests
with s->min_partial being a compile-time zero, which means the tests
will now do unintended UAF writes on the page allocator level, and also
report failures, as flagged by sashiko [1].

To prevent this in a robust way, add an extra object allocation to the
tests, that will prevent the slab being freed. Use migrate_disable() to
prevent migration to a different NUMA node, which would place the
allocation to a different slab.

[1] https://sashiko.dev/#/patchset/20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org?part=8

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 lib/tests/slub_kunit.c | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index e3b63f0338d5..40427f7edf4c 100644
--- a/lib/tests/slub_kunit.c
+++ b/lib/tests/slub_kunit.c
@@ -51,10 +51,16 @@ static void test_next_pointer(struct kunit *test)
 {
 	struct kmem_cache *s = test_kmem_cache_create("TestSlub_next_ptr_free",
 							64, SLAB_POISON);
-	u8 *p = kmem_cache_alloc(s, GFP_KERNEL);
+	void *pin;
+	u8 *p;
 	unsigned long tmp;
 	unsigned long *ptr_addr;
 
+	migrate_disable();
+	pin = kmem_cache_alloc(s, GFP_KERNEL);
+	p = kmem_cache_alloc(s, GFP_KERNEL);
+	migrate_enable();
+
 	kmem_cache_free(s, p);
 
 	ptr_addr = (unsigned long *)(p + s->offset);
@@ -89,6 +95,7 @@ static void test_next_pointer(struct kunit *test)
 	validate_slab_cache(s);
 	KUNIT_EXPECT_EQ(test, 0, slab_errors);
 
+	kmem_cache_free(s, pin);
 	kmem_cache_destroy(s);
 }
 
@@ -96,7 +103,13 @@ static void test_first_word(struct kunit *test)
 {
 	struct kmem_cache *s = test_kmem_cache_create("TestSlub_1th_word_free",
 							64, SLAB_POISON);
-	u8 *p = kmem_cache_alloc(s, GFP_KERNEL);
+	void *pin;
+	u8 *p;
+
+	migrate_disable();
+	pin = kmem_cache_alloc(s, GFP_KERNEL);
+	p = kmem_cache_alloc(s, GFP_KERNEL);
+	migrate_enable();
 
 	kmem_cache_free(s, p);
 	*p = 0x78;
@@ -104,6 +117,7 @@ static void test_first_word(struct kunit *test)
 	validate_slab_cache(s);
 	KUNIT_EXPECT_EQ(test, 2, slab_errors);
 
+	kmem_cache_free(s, pin);
 	kmem_cache_destroy(s);
 }
 
@@ -111,7 +125,13 @@ static void test_clobber_50th_byte(struct kunit *test)
 {
 	struct kmem_cache *s = test_kmem_cache_create("TestSlub_50th_word_free",
 							64, SLAB_POISON);
-	u8 *p = kmem_cache_alloc(s, GFP_KERNEL);
+	void *pin;
+	u8 *p;
+
+	migrate_disable();
+	pin = kmem_cache_alloc(s, GFP_KERNEL);
+	p = kmem_cache_alloc(s, GFP_KERNEL);
+	migrate_enable();
 
 	kmem_cache_free(s, p);
 	p[50] = 0x9a;
@@ -119,6 +139,7 @@ static void test_clobber_50th_byte(struct kunit *test)
 	validate_slab_cache(s);
 	KUNIT_EXPECT_EQ(test, 2, slab_errors);
 
+	kmem_cache_free(s, pin);
 	kmem_cache_destroy(s);
 }
 #endif
@@ -127,7 +148,13 @@ static void test_clobber_redzone_free(struct kunit *test)
 {
 	struct kmem_cache *s = test_kmem_cache_create("TestSlub_RZ_free", 64,
 							SLAB_RED_ZONE);
-	u8 *p = kmem_cache_alloc(s, GFP_KERNEL);
+	void *pin;
+	u8 *p;
+
+	migrate_disable();
+	pin = kmem_cache_alloc(s, GFP_KERNEL);
+	p = kmem_cache_alloc(s, GFP_KERNEL);
+	migrate_enable();
 
 	kasan_disable_current();
 	kmem_cache_free(s, p);
@@ -137,6 +164,7 @@ static void test_clobber_redzone_free(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, 2, slab_errors);
 
 	kasan_enable_current();
+	kmem_cache_free(s, pin);
 	kmem_cache_destroy(s);
 }
 

-- 
2.56.0


