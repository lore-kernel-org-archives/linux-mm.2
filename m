Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB0E1606A33E
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 08:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MPOs+TdQ
Received: by kanga.kvack.org (Postfix)
	id 3723C6B05B2; Thu,  5 Nov 2026 03:44:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2855A6B05B3; Thu,  5 Nov 2026 03:44:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14D356B05B4; Thu,  5 Nov 2026 03:44:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E19B96B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:44:05 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 78887120925
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:44:05 +0000 (UTC)
X-FDA: 85400428050.25.1BC5544
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id BF24B40009
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:44:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MPOs+TdQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793868243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gA4GYfT6GSCvJ1oVfp7f8fLjQLRtbP4OEVTLxVbAiqY=;
	b=pTS3U14GIfHYgS+ZmS04bbGJc1qhj6i6dIVAuVNxZZDywQP0yXh1lqZklY6Wldg4v5gBS3
	ZnKe0nvYUXC1TDqx0rEax1VjnoQosdqbiEpBpYH/nI99okrNzdWJKQDWao9g94NG1PkaUJ
	ON3iJzyHweDKyrLfPXpS1MDoBFr052A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MPOs+TdQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793868243;
	b=ReEwbkqErycWkuiwSRBRHGSj0AeszSyyLjLNv2VDCcEF1BL6Z2kctkTFndbClxvbRXPKQa
	1Qv6GxIZ0v2KqiE3bYDRUY5oWUrlj8RlbMW6DmkLaz208tkk2D1sDAaYhvsfVQoNJzC0GG
	aNhV5X1vggXTYxFPj5n4rIgLy3XHj04=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1463440E4D;
	Thu,  5 Nov 2026 08:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B456A1F000C1;
	Thu,  5 Nov 2026 08:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793868243;
	bh=gA4GYfT6GSCvJ1oVfp7f8fLjQLRtbP4OEVTLxVbAiqY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MPOs+TdQ4Qep5WekUbHmaepO2gqQ/mRINURzsY31qWmiARLHe7YtG3sbyhUICDc8V
	 sYSaNDHqL+EbB+/GHXIa0ux59VZis4ur9fXJcfKB97t2I+Ejf02jGENjdIT3+lmh88
	 SYl2IrxAAWlv1gjjp567dC9jdVWJhPfAGpSVvFdbu6tDhGUAJU1jt4y1Pw1LW+W2LO
	 sSfcaqDX7IBSQRhhtot+Kl3WTXokChL50fOnu9V9RWBQ+99k+6hJtUoQZ3+pEEtE8k
	 PUSfi5Q2emtjI999kfJ9To3Ei/3uZU/wFibN06zSgpqLo37lBRwHBMr/b3QRfsFrO3
	 EHOLGwpcmVhKw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Thu, 05 Nov 2026 09:43:51 +0100
Subject: [PATCH v3 02/10] kasan, kunit: pin test slabs by an extra
 allocation
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-slub_tiny_rework-v3-2-0484ce59eabb@kernel.org>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BF24B40009
X-Stat-Signature: nxqbi37698jme1jhjk9ax7chuzxxsfe7
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793868243-103952
X-HE-Meta: U2FsdGVkX1+a92rt4vSVT4P6DNN1mrn/HULtdEtjx7XHiuNfcKZRi8ofa5A01o2O3IPKXMmrBjzaCYxkWJMvZM8AV6mX9tkV4lyA/29OuX8VpogjYMtTyKDRqPqncw/wr29esZeppLD2w0+iHuFo/qm8FAMjidqKsDcAlq3kzkEtqBUPZPWwQoftFFm0vSITm9VTlORz4SchiGNwSmN6JGnIB46UQ1aIj9dejL8iUtlmpRmNR8M65G1MI+wWKxbpVYejVwmfN/BY7WRPNUW5WbbuBcLd1yaoVCot7NjUoTShuOcQzrue2aPrskUpphzVRNwY5amSekD9DHFSB7cvyn4FAKalro07jT9Vz/d0symLVXjFlPhBaLlMgtgBNcrvZo+s6Fl0xxZyBy4IBWa0Bt9vAgBNZkgC3R9oqdJSSIn8XlpcS3SRfmH2AKp09all06vdZjM2fRfj9GiZLV/e+61AOO4Trp6ITWTKrhoGQU+D1SGmHwOCMDMxOUr5PungpZpDJKbFlHY16ddI0qHZGlN3CanEqFo8KBC0wxsK602s5ylnUNI8/X/QVFMDaOoKDT7KT6In1iMEl/Hdbocxi6TlcOwzzJg+g3RuA/vgRbVemBII7OEApc/Aaj09tPm8B8aBQb4VUHb6tRyFGG1Sf4XxByS9I4d11E0vTcWpX7msqnMveQJ5ynDFImqsxUGPQK86TZzhGmg8n76yeYLAtfs5U+IraW44dpEp8vmho/mgy9NCk3wIz4c7NAVKyRWKC9iS7/AdqeN48WSKWtpkeDNbM979oedZ3pqJqWhU6byH/YLJf2fHhcsL9LoGKEQk2mtvdOZXZKMp3sqy7oPqwMwzZZY6r0MwWAkS48WWS9/r7C30PPgl7mpuGryC9ocoiJEvqig06FiEbrJh5ycaJhXNj7Ggfg+AtLLqvxb7mV1HuIXzp4Gjq9etYsxofv9wynXlC0ApoNANr9EdKam
 zqN2H62r
 GGWng0T2RTOgNMEG1bGmEZWtzTAwIGJUbIFUyCM4tJumUVr3LvATtARvwbTXAupRRl8ASEkmMKp/oZze5T/vWY0iVEkTXQP8r93IPza0LBLDPwtP8qKWT7SQB4JIgSPh5pYMk7jN+O3W2/r26SdiEWHV7MVMiLj14s4FRcVB5Szh3uYAoLp4bPEhJJsT9gP7Q7tJU39w9RFiAutfbTIC7r9vRyGOfoFIYJJfQXZ24nv+NOYO/bEh1MhZmwg1d3QD+zUlJH6vzWxDoCbsSpXJSpdEJCYeAF8dw/hDKi+jSmBBqMKsuTkHvysDVLTt6t+4zJ7ZGJcbTRaw09lXSV2njagtedlpFH0Yg+AAzixtwXTv5elJCJrkdMM+QS/2rOKdBK6nh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The tests kmem_cache_double_free() and kmem_cache_rcu_reuse() create a
scenario where a slab becomes empty, but rely on the implementation not
immediately freeing it.

This subtly relies on non-zero s->min_partial. It currently compile-time
defaults to a non-zero value, but in theory a sysfs write racing with
the kunit test could change it. More importantly, the upcoming
CONFIG_SLUB_TINY changes will make it possible to run the kunit tests
with s->min_partial being a compile-time zero, which means the tests can
cause a NULL pointer dereference, or fail, respectively, as flagged by
sashiko [1].

To prevent this in a robust way, add an extra object allocation to the
tests, that will prevent the slab being freed. Use migrate_disable() to
prevent migration to a different NUMA node, which would place the
allocation to a different slab. kmem_cache_rcu_reuse() already uses
that.

[1] https://sashiko.dev/#/patchset/20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org?part=8

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
As per sashiko, this scenario needs CONFIG_KASAN_SW_TAGS or
CONFIG_KASAN_HW_TAGS to occur, otherwise kasan quarantine will keep the
objects and thus slabs alive.

To avoid the need for arm64 system, I have reproduced the issue and
verified the fix instead with slab_free_hook() modified to skip kasan
quarantine.
---
 mm/kasan/kasan_test_c.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index b9e167ed5be3..580a9bf007ec 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -1051,22 +1051,30 @@ static void kmem_cache_oob(struct kunit *test)
 
 static void kmem_cache_double_free(struct kunit *test)
 {
-	char *p;
+	char *p, *pin;
 	size_t size = 200;
 	struct kmem_cache *cache;
 
 	cache = kmem_cache_create("test_cache", size, 0, 0, NULL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);
 
+	migrate_disable();
+	pin = kmem_cache_alloc(cache, GFP_KERNEL);
 	p = kmem_cache_alloc(cache, GFP_KERNEL);
-	if (!p) {
+	migrate_enable();
+
+	if (!p || !pin) {
 		kunit_err(test, "Allocation failed: %s\n", __func__);
+		kfree(p);
+		kfree(pin);
 		kmem_cache_destroy(cache);
 		return;
 	}
 
 	kmem_cache_free(cache, p);
 	KUNIT_EXPECT_KASAN_FAIL(test, kmem_cache_free(cache, p));
+
+	kmem_cache_free(cache, pin);
 	kmem_cache_destroy(cache);
 }
 
@@ -1152,7 +1160,7 @@ static void kmem_cache_rcu_uaf(struct kunit *test)
  */
 static void kmem_cache_rcu_reuse(struct kunit *test)
 {
-	char *p, *p2;
+	char *p, *p2, *pin;
 	struct kmem_cache *cache;
 
 	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_SLUB_RCU_DEBUG);
@@ -1162,6 +1170,12 @@ static void kmem_cache_rcu_reuse(struct kunit *test)
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);
 
 	migrate_disable();
+	pin = kmem_cache_alloc(cache, GFP_KERNEL);
+	if (!pin) {
+		kunit_err(test, "Allocation failed: %s\n", __func__);
+		goto destroy;
+	}
+
 	p = kmem_cache_alloc(cache, GFP_KERNEL);
 	if (!p) {
 		kunit_err(test, "Allocation failed: %s\n", __func__);
@@ -1178,8 +1192,12 @@ static void kmem_cache_rcu_reuse(struct kunit *test)
 
 	kmem_cache_free(cache, p2);
 
+
 out:
 	migrate_enable();
+	kmem_cache_free(cache, pin);
+
+destroy:
 	kmem_cache_destroy(cache);
 }
 

-- 
2.56.0


