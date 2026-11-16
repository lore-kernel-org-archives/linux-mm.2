Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABA2F606A329
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 06:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HbU+7DQA
Received: by kanga.kvack.org (Postfix)
	id D74E76B05B9; Mon, 16 Nov 2026 01:47:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D26776B05BA; Mon, 16 Nov 2026 01:47:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C636B6B05BB; Mon, 16 Nov 2026 01:47:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A23B16B05B9
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:47:28 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 19A05120573
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:47:28 +0000 (UTC)
X-FDA: 85440050976.23.63E5781
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 63F26160005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:47:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HbU+7DQA;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794811646;
	b=um26ecTtQXAFR++ZevQiMmLjkrf7NYy8q+1vdaWklBt5I9baKi/J44qOlLamfLtkB2bnc/
	cGsCm7O92uJZzy2zdb4a16UJZeGxN58YlvO6wpqjdHcE+ffp0kpVmE0jmZdfkGDhn203I1
	987ys9m6Zu0exVyZQiYZVRDBy6N45Ok=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HbU+7DQA;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794811646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qnAd8kdJJsCCZ9ku2gzzQPm1FL2bWZEjkOx7cLArqZE=;
	b=cGUdpiuI5gRSqG1zvxsRD0eyyJD/uBtb6ckyuvK92Z9u0EOrNn2Vp8UrHPV2ldJxG+eCYP
	11fv/hgP/c5FPf+ZaFPR2I7y6Frv2lMfBCEyGC0CaW2DN/tQ5zUz9+QmmlF029CUu0kSwt
	UxFVgu2aTUOwCv2ahvGThMyvl6FpzSw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0032661E8F;
	Mon, 16 Nov 2026 06:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738F71F000C5;
	Mon, 16 Nov 2026 06:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794811645;
	bh=qnAd8kdJJsCCZ9ku2gzzQPm1FL2bWZEjkOx7cLArqZE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HbU+7DQAaJDNRjsKZtMjIolMTDwZVhEoaALimOLHB6t4dRaEII9oFMDxHbYA7OnT/
	 YmXU/WFq2zfCUnwfaC5yukA2XQznxMUkKbdDV6x0IKgOvclGKNmppIYr2yFSurb3kn
	 SX4S2czRGqy5NwuGB6ZvCGuvvyc/KMozI5cOogZ8+PogD4PmiuKq9bvy5Fa8dG4aNf
	 EcdCP00K95HeR2Xkh6Q1kSamO+Y6BrLMvySV6eIBdbp/ATG3QR0/UHKMxcaPsPxCv4
	 Kb4qdx4BGhJaiz0ezO27NZbi+FxZJBsEHrogqyrXMmt/NznPTXhTuN9dYVfy3YhBlh
	 F7XW1ri5LlMLw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 16 Nov 2026 07:47:10 +0100
Subject: [PATCH v4 02/10] kasan, kunit: pin test slabs by an extra
 allocation
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-slub_tiny_rework-v4-2-227a4b3636a5@kernel.org>
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
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 63F26160005
X-Stat-Signature: x74of7sc1rho54yxeown35yzxrfhtojy
X-Rspam-User: 
X-HE-Tag: 1794811646-871011
X-HE-Meta: U2FsdGVkX182wN6y+xma1ue527twqr5qLVsenKQZ40cpVR3V00ugD9Lgg2Ek0381+p+YLhV2AUEef2okp+rvPazH7VqVUVtE7XADurJHfIZeWmP0tN44HL/aIdlG4xSXGsgaRDl7AIfRMgmDdQlw5sl5jcCmiAXoOsV1yyfvgGO1kVbzy0mhxTX6jyM461yk5XplLxTn8rXLUIY9xF4HfuVAxM0uSJS9OAJ3AtXsH8mVtomN1GVePMLtXqYKEpZbCC7xeQ9aacHVT2MzCvPROPwGB6p8kq0rV59638Ep03n3J0JlNgLPLPS+npmZ6zhrlLo8IBXO2jEUpVo+qzP3tCjOKHb86/0eOEDQK9EQxwWu0QqkiaFqgbLbSQt+DUJaoKQ2V61dqMsu759RM2VwlG2vToIVN/bZ5nUEHzp+Mk6FbyOSJ+XiIG4xmFOjckxMPWR7a4RKztnpfeu15y2l3Za3UYDmYhAkinr6MYmaWeDP8SS+nL0n/p4b/gg2Zcpv6LI2mfzp5H0dyOctdV8UykubPfSuWOs/CM/TcraV7jOYo0hDb0XV0mEvJ7Bg5rAiBGO48oBiGFtDPbu3OPbIjUstBjYdn3F8DhwIlw08dU6B8UoPJX0xkq5giE2BoiFWbGKsYJg0jrmWBFjM/4SJ7QKawQFY6xhaegKCeBoT4j9XwNXL4zDTDXZajOkqABosEbDY0xZcADokyq9gR6zlF6mQ7N+ZmEmn5qB9Z6BztmTvFKzd9FNbEAOPEnjCNrGWyy72QiMGTXyB8FgfUjsnXj/g+CDeb/iJM3vCnswGqymbc3ePnH7nxvk+Z4zirf4zZgrZYy1JhINoADitfK2dXCjZFc4bfsKGqRmD7iZZtmCnPZV93pwoRS/OAU0ZYyUBrV8RCATwQlXiOJ0VNCP5xHkHNrDy06gG5PZwUc/3OMsElboUPsdO4IRPx+H3VtpoO8QaIDx+wZwJOIgIONX
 ForBIuQd
 nTdhJYKce5rmo6FM7006BI7Ajy/JcCjzWSvnyl+sBVaAm+Njh83NabPfzzDaXG+ppV8gtkDdpLNNBVBtv6irfRJNjtYnSZk0g+sy9bADltF4jTzb3advNkahLnDR3yGIs3yE61XMEeCuYYri7QsIvXj3kPjGW47mX14HBMRLvTNzcLQwxOR1EY4ML+kn9p9a6p4FbPgHUWMPSDJwl62v/taTo9nwBfGkTqLHZtUaECAusU1Wzyl9CNi7tvlTsT4WzePWS0sSaDP6GLRpY2wB2t/pvaFPJ8HVdFLHV2Lt5TTzfpPxEDDUNSWIvP5hDFJY/3uwB17Yrjl2tpSImheJPLq4c/Lh5ilnJkMaW6GAmqkhvEehc2lO+HrwRR5JD2A3Zs9DB
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
 mm/kasan/kasan_test_c.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index b9e167ed5be3..01cf001bf0ef 100644
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
@@ -1162,6 +1170,13 @@ static void kmem_cache_rcu_reuse(struct kunit *test)
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);
 
 	migrate_disable();
+	pin = kmem_cache_alloc(cache, GFP_KERNEL);
+	if (!pin) {
+		kunit_err(test, "Allocation failed: %s\n", __func__);
+		migrate_enable();
+		goto destroy;
+	}
+
 	p = kmem_cache_alloc(cache, GFP_KERNEL);
 	if (!p) {
 		kunit_err(test, "Allocation failed: %s\n", __func__);
@@ -1178,8 +1193,12 @@ static void kmem_cache_rcu_reuse(struct kunit *test)
 
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


