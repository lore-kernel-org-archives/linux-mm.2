Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE562606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 06:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LD6ejzLV
Received: by kanga.kvack.org (Postfix)
	id 07C606B05B2; Mon, 16 Nov 2026 01:47:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 054E96B05B8; Mon, 16 Nov 2026 01:47:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED3416B05B9; Mon, 16 Nov 2026 01:47:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C716D6B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:47:24 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4B063A086B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:47:24 +0000 (UTC)
X-FDA: 85440050808.14.802A3DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id B2EECA0002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:47:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LD6ejzLV;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794811642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3U+iFMsR7Wf6izMeYzL3XEBnXOJ8vfgZxFGf5leGhvM=;
	b=MXO3A5sZyxjKoZcYdO0LfsqprtOp9lOB8CUdEP1JxMwvsF8p29Z/EcRDmc0MrIaT6BLyTP
	P3NGXpHPwsy521vKjCpOLDD0J6XbyWVJBM/yn0kDSyfELvJ0ioyVr64KSDSmsigqCWB3hK
	QtggtgrbuESUAmK0KCl+tTD/CKLAd24=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794811642;
	b=TrKne4nY8+ZbQXBBmXvXZF6yhzzkgmotpWIyWheNgC/MVPHYfGgkpC12t6HBXO3btN22/w
	84Ruau7qgPr27Srwt0GWoeMS6mtZSpbmxW7FNnopaqSxmvrm2rX4dL0Dfcec2LQCnWsDQG
	HZDQcHb/4WLHNyGoXL4pc+lQGelY6+4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LD6ejzLV;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E12E623B5;
	Mon, 16 Nov 2026 06:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12AF1F000C5;
	Mon, 16 Nov 2026 06:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794811642;
	bh=3U+iFMsR7Wf6izMeYzL3XEBnXOJ8vfgZxFGf5leGhvM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LD6ejzLVqR8AUJ+Xda9FHUcUBs6d9zxbCmNuusg03uIJxYTZS+tTC8SpyUjNtAPkf
	 UdXj0ebnLwKrLEMBOZHzghtpFNfFNIggbaaLrE8TvW/5TAX0KFTIgGBkEtFa/RqkLy
	 6f37iw1UQY+6v/ewpyfStd23CXSbbD47iP6+m36zWp5/APDhb6Ah3IOzR+0zQ0xh0p
	 rSL51wa75o3AxKQhGi8afDrv1vgmVNotLiqMCnlBaEyhIc/xXjXTts+ow30t7HM8Ej
	 JpWDX9/vGr1WqSferEgjgGXoQ3D84LupLrDiah82kmYcEQxA2l3u8YepvBnasEJP68
	 LroJHEfVSVq+Q==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 16 Nov 2026 07:47:09 +0100
Subject: [PATCH v4 01/10] slab, kunit: pin test slabs by an extra
 allocation
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-slub_tiny_rework-v4-1-227a4b3636a5@kernel.org>
References: <20261116-slub_tiny_rework-v4-0-227a4b3636a5@kernel.org>
In-Reply-To: <20261116-slub_tiny_rework-v4-0-227a4b3636a5@kernel.org>
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B2EECA0002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 93nhtydo1ex8q45tuo6yfgsp7xpdhkig
X-Rspam-User: 
X-HE-Tag: 1794811642-253361
X-HE-Meta: U2FsdGVkX19V5ZbisVl4VrrrGamHoty+CYnjh6WFua9GJD0grmAWU0BgtIkgQrlPedeA/D8/WghDTaX255SrMg7T5R+OhxqR3yQ2zCPArZbsv1tF7JCBN7p726pbjWghRXi44vf/wT1nE2np0gRt4flHqaFDriYGSDVgswm/uV5AKFnaZmvO/zLZF834X9nvoxi7mJpu63QWSFHDO01/fpaoeMw7WaxTzg6DqA1xA9ODvXaDFqtZZp9Lzlq+wysobpOibPyi7/+IwdT/TCCS9joKa7Y+5BHPS5iqGpzetAAcjuNLtFcUERJk6dfX7TOvyK36ep+XVLX3WVWx8mj/eqrRu0EcQJcnhSg/CrDsQb0DhTpeJxe40Kpnq45EJgubkSI6USH+0MWaaS+ZuAEdwCu+fq3NEGNf74do4CrfJWwGMeCtepIjqTddzlQAtW0sQ9n9CNjBSC6CotKkIyMzCM95YHYxrPsoFYeBReIV9vT+dxPSnHEHlCfIWtsIJgJ+TLshmyNKZ7vQOtamdhcnM/NFctFBWz8SmGl1kDU7q4SkATShFGOptjmVBO92eYUY3PMbH+OUYczNsGLjFX2hoZOB67j+fkbF0Zo3undluQzIha3wzh1H81f6/4d1/GTCeNK5x0CahEEfuvv/LTxu9UTr5GX2jPCo8HPUiu646oR+9VwmxrsQRgQFhcbL+BFJmKh+Q0gZ34eGyH/fIKg8ELfL4ktDvUSmUDZbGG/yQkQ3WXpoXRN2J3WnL7r9MD+6UCtYiXQJZPLpYFkAzX2QPffJXQGxmMLYLp73NpoZsI0fG+/Mt+ZXB5DYy6btegXcjPPDzTiatpqERYU0okIjJAJuAH3aHi6ZRwuudyWsfmZPVuWTPEiwO+5CbskJ5PplmVrfHleg1g3mca7UONdKcjC8TRcRnPBwClDv29Np+Eo5ra2Q1OTIZyrV00qXtNORbfNQiKAlosfxOWHlbFU
 mhGunow2
 Dj1ofLPLWFo0mwd+ZQk+AeCjcJynuFbzORNDbCN6rL4JK3xlA6A/5VK7L+H33bJrvhfxodhhL/9ICXk+rnD1AWlJBPLNwulV8DHwdqjIz1+Uc3rCXsi5RBeYQalV02n4HaTVkMRV60E7wI/V1VLI1ML4F02e7VZap7Ro6pN2ato99pPtQjPjvV5tfXldjuNB+PaIjKhLEW1yHlK13HBLyXaKrekW/kgbTQQjJFEpDQxR7v3gK0yd0TH5UkoVgLoFQUVgJ3Koka6dO2bZ+wfwisuUnBwiTT+A3v6nCamiSF1FedTKwZWW5NZJP+vZh715PCkrydfrKDcbDfCigm1BfsmIG1X7Hc8KSWNnTgmDJtxu2J09pp7e1Vwm7HdWueWJ3bLHH
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

Acked-by: Harry Yoo (Meta) <harry@kernel.org>
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


