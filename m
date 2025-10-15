Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59F37CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 17:50:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5DE48E005B; Wed, 15 Oct 2025 13:50:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE7D98E0005; Wed, 15 Oct 2025 13:50:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 988A98E005B; Wed, 15 Oct 2025 13:50:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 820398E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:50:53 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3065FB7687
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:50:53 +0000 (UTC)
X-FDA: 84001089186.02.98BE32A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9E62CC0008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:50:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=S7jxapwC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=laPpn4W6;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SZSQv1sO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jTvP7Oh6;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760550651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eQ75EAJh+K3fc00OxjTeenY3SD53Rdq8gimDFm5M73g=;
	b=gbBf85/W5QhFj6le98mSnAV+CzaJ3venSazC3a518OiTR8xaIfcef06xGQmgZ5izA60bx0
	yWcNNcn9zdnwrBMlWB0s4HSH5II8VEIBFpAqXFYAR0ZviUteveCwBnBo3cMiOZOet2Zan0
	fO+tpdB5mjELlLWcGeSxRNz2qCeI18c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760550651; a=rsa-sha256;
	cv=none;
	b=EIpkZcAr7hd4ZUbW7pq0GcJofXQKUq9xI8Dt9BISIqoLTaOIc6nuyr1f2YLdpXGIfjYZm6
	SELxrcHtyi5DTBTaP5sIGvW35ENBBkvCqhebtHOf6EvWaQZE4+cLAb3NnGBhPA2aSQaDXP
	Hq9m4oZPDvQ21ipHw8eKtQjxgsOtiPQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=S7jxapwC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=laPpn4W6;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=SZSQv1sO;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jTvP7Oh6;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1ED2F229E8;
	Wed, 15 Oct 2025 17:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760550649; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eQ75EAJh+K3fc00OxjTeenY3SD53Rdq8gimDFm5M73g=;
	b=S7jxapwCWwYuHKP1GFIjPSeBv17whoOQxJL9gU9GbQozuCtMcF/J5PG+nxDmEPjcUsYyLC
	O9xXRF8A4TwTpxe/JHj9dVjnFf9/rh/afYMC/dslXMP9iGlU9Zde1Prqe3iml78S4bylUW
	iug3WcDXXzOcz0bJk2fErnVj0TuEp40=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760550649;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eQ75EAJh+K3fc00OxjTeenY3SD53Rdq8gimDFm5M73g=;
	b=laPpn4W6F8reiAnkpLl82N7OF3lH1hk9XMYHJRwaGfr7n66fKIuuPM+FoDOBqDnqSjm/QV
	fomcN8tuAa5/rWAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760550648; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eQ75EAJh+K3fc00OxjTeenY3SD53Rdq8gimDFm5M73g=;
	b=SZSQv1sOQtk6RB+iX5xnq9u3NpbtZRJ19XHB9kX1wAfP0j7fkjf8LNNRZb6nzp9MBdTfhw
	xSOxX5xNJiMVyY9cWXYMLbyO6b/UReOPwCWPMXPqEhu77LFrqA9fbIfQaqypGFTGKMqV+k
	YMQFR3bCeuZSG6QBTk3e8Vmhi5MUNyA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760550648;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eQ75EAJh+K3fc00OxjTeenY3SD53Rdq8gimDFm5M73g=;
	b=jTvP7Oh6ltI28GHkR6hIGTsiHCrbnDycKuWE9p2ehLtO/TBzfS9G+orrrjiGnYf0Yowzjp
	wKdA5tJJhgs8L7DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 077E913A42;
	Wed, 15 Oct 2025 17:50:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pCFxAfje72jTTgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 15 Oct 2025 17:50:48 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 15 Oct 2025 19:50:38 +0200
Subject: [PATCH v2] mm/page_alloc: simplify and cleanup pcp locking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251015-b4-pcp-lock-cleanup-v2-1-740d999595d5@suse.cz>
X-B4-Tracking: v=1; b=H4sIAO3e72gC/32NQQ7CIBBFr9LM2jFA2lBdeY+mC6BTS2yAgCVqw
 93FHsDle8l/f4dE0VKCa7NDpGyT9a6CODVgFuXuhHaqDIKJjjPeoW4xmICrNw80Kym3BbxoyXT
 LpRKMoC5DpNm+juowVl5sevr4Pk4y/9n/vcyRYy97YiQnM2txS1uis/nAWEr5AmeEAtK0AAAA
X-Change-ID: 20251015-b4-pcp-lock-cleanup-9b70b417a20e
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>
Cc: Mel Gorman <mgorman@techsingularity.net>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=9848; i=vbabka@suse.cz;
 h=from:subject:message-id; bh=5YeiXycEHBP9UL7SpqxhlXaE4HDt2xnE7RFWrPOXngE=;
 b=owEBiQF2/pANAwAIAbvgsHXSRYiaAcsmYgBo797zNbmiH4d7JrNLpLGyWlvuth3v/LOzjhmOf
 MStc63WHhKJAU8EAAEIADkWIQR7u8hBFZkjSJZITfG74LB10kWImgUCaO/e8xsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMSwyLDIACgkQu+CwddJFiJq96wf/YG5DWuTVspUOR52b1acc5RMhQzZvNbC
 lQ6qReXKw6+gPQkZInW1xijhmYtN2Z/NgFlb+JeK22bGJN4sLHABxj6TQ0TyTKcCCgZdE3/lhHM
 LaCsN4cJQ/81WlUCwhk+YRDsiN4WktUpSwHKEo4wHdeQXOPOEb0H/nRCSE5u9r05dVzF+io7/JW
 PyeTIgP+PJhL42mPcNm/Bua3B7GmpW7o4gG7luOrEMGHOTtfFhZvAYbvBLnV4D1lm3yuQ2AQGOq
 IVQpsy9Idm/qmvdZmNI7M675YptsiSzdca9smsFAqObAUuJDMED9CLO2R77GdRKgwZPSUWdfcVU
 vV7pAbM9JdA==
X-Developer-Key: i=vbabka@suse.cz; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Rspamd-Server: rspam01
X-Stat-Signature: fgtfrcxmwebyjnkrnjab7twzcdt7yaq1
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E62CC0008
X-HE-Tag: 1760550650-608148
X-HE-Meta: U2FsdGVkX19E4g9UjvS2ssToYpBFgwg9Jfmz1BjYGOAjX7TKXVwOrlre9KEq5Q/79IzUrd/hdWgWUn2c4JAlDzO5EIn6iGEBUTZtJ91TYsQQ/59M2pheb7yweWNhePBjBT4rdd3Aa4JYvEbuCUjPthVkvxfxAvoCus6oqQiCd8UerQoQomP/YP7WYMWTCtLgotMCn6UJps5gwlqDe1aSIRLCrQ+ggP9iJbCap+PYwjmv+w+7RBG0UH6UvC0G1JuR1c/n+Bhz6F1Ea6zPHKLjJQRWS3oRIn5RNizHT04Uh9P6p5Mcf1UnX6UJTGBTnjCNEj+hGHXl/WxH1FuWhw3nr2W3+FkojXp/VNHL0gDC7nLsIbFD3fGDN0DGzXp/YPSmRAfJVbbK6P1233OtdU825aspoOetlQES8kkc9fXiSSpOFFCBMeMT5sVDxcugUkVNfbWHPORUqGDceLlaBubgV2oyqq7PN0oO25kiWRUZn+cZO8/XlrkiqmDpWtoQPsP4g04OMQuk5rYXuNu2a91Jw9UKGI9G+KqlGtjibK2+97UGMr4/vjD4GrZropsHiw53uW6K7749SidTx+oQO8+rHfUo1+fjw6zSXqOS+2Poo6mjvXxiFCd1irvAi8mgE/+BUTWR1fURELTZgdmNuaZAAPbWzjlLCqeM5mb4HF1G5ZUY+XCkLTzBuWzRhPjVKybFNyi4GrMxEe7R60F1r46HtwVyTn+n9eomyIAOy6SLj3vWfqUIWO6VHzh05LrjkvzbZPt6HFmEBGyy2nTUXZa+RQz8ccweZVONVyRSRSfWIpAF0B8WFaIGHJZs24QQ6P+Dtqpxz/oeafA5j2NtR/AHi0KJhcEkCjsz2knG+NFriDtA/U9XO51CmqktF9i3zdKF0EaKWaKJnBcjDeZ57UmdfrFvhiJuiT/tC+DEEHgTkUDotTiLFwNRNVeUdKI1EV3WLatEOC95aIDTgBYpPB6
 eiAFslV1
 FI9DEyDqbR8l3WZ6a/Gkc52t54QLdJdyq/EJxVbZChdCgJchPzVW5+Q2M+QV8BSZMZY5KpZrX9AYODWyUPvmF6CoT6NadErrxXG/XOdvVAahNJBRX18xkXZ9pLbj2IL7lWHTHXL4h8y6MjTP4vyq7nC5k13DOEkatG8Ky8W7gr6yUPSQa+CAbQb/+GMIySmRNiP3tojY9JWSbtukLVlD1x+8gA1y/SXufVsGvIER1PefzqXmw26gpfiuSWwBtndAP6DL7RuaYjR32Mh5VPtkBflfQDaQfIDALBq/50fT1ecS3/Tt9yiwUEaxZRef89Nt2vYGS4aXz+KvU9A3hIefJOIxhz0QvgKBMRmUGMxZx/Mk+jsDA6ktlHaYg8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pcp locking relies on pcp_spin_trylock() which has to be used
together with pcp_trylock_prepare()/pcp_trylock_finish() to work
properly on !SMP !RT configs. This is tedious and error-prone.

We can remove pcp_spin_lock() and underlying pcpu_spin_lock() because we
don't use it. Afterwards pcp_spin_unlock() is only used together with
pcp_spin_trylock(). Therefore we can add the UP_flags parameter to them
both and handle pcp_trylock_prepare()/finish() within.

Additionally for the configs where pcp_trylock_prepare()/finish() are
no-op (SMP || RT) make them pass &UP_flags to a no-op inline function.
This ensures typechecking and makes the local variable "used" so we can
remove the __maybe_unused attributes.

In my compile testing, bloat-o-meter reported no change on SMP config,
so the compiler is capable of optimizing away the no-ops same as before,
and we have simplified the code using pcp_spin_trylock().

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
based on mm-new
Changed my mind and did as Joshua suggested, for consistency. Thanks!
---
Changes in v2:
- Convert also pcp_trylock_finish() to noop function, per Joshua.
- Link to v1: https://lore.kernel.org/r/20251015-b4-pcp-lock-cleanup-v1-1-878e0e7dcfb2@suse.cz
---
 mm/page_alloc.c | 99 +++++++++++++++++++++++----------------------------------
 1 file changed, 40 insertions(+), 59 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0155a66d7367..fb91c566327c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -99,9 +99,12 @@ static DEFINE_MUTEX(pcp_batch_high_lock);
 /*
  * On SMP, spin_trylock is sufficient protection.
  * On PREEMPT_RT, spin_trylock is equivalent on both SMP and UP.
+ * Pass flags to a no-op inline function to typecheck and silence the unused
+ * variable warning.
  */
-#define pcp_trylock_prepare(flags)	do { } while (0)
-#define pcp_trylock_finish(flag)	do { } while (0)
+static inline void __pcp_trylock_noop(unsigned long *flags) { }
+#define pcp_trylock_prepare(flags)	__pcp_trylock_noop(&(flags))
+#define pcp_trylock_finish(flags)	__pcp_trylock_noop(&(flags))
 #else
 
 /* UP spin_trylock always succeeds so disable IRQs to prevent re-entrancy. */
@@ -129,15 +132,6 @@ static DEFINE_MUTEX(pcp_batch_high_lock);
  * Generic helper to lookup and a per-cpu variable with an embedded spinlock.
  * Return value should be used with equivalent unlock helper.
  */
-#define pcpu_spin_lock(type, member, ptr)				\
-({									\
-	type *_ret;							\
-	pcpu_task_pin();						\
-	_ret = this_cpu_ptr(ptr);					\
-	spin_lock(&_ret->member);					\
-	_ret;								\
-})
-
 #define pcpu_spin_trylock(type, member, ptr)				\
 ({									\
 	type *_ret;							\
@@ -157,14 +151,21 @@ static DEFINE_MUTEX(pcp_batch_high_lock);
 })
 
 /* struct per_cpu_pages specific helpers. */
-#define pcp_spin_lock(ptr)						\
-	pcpu_spin_lock(struct per_cpu_pages, lock, ptr)
-
-#define pcp_spin_trylock(ptr)						\
-	pcpu_spin_trylock(struct per_cpu_pages, lock, ptr)
+#define pcp_spin_trylock(ptr, UP_flags)					\
+({									\
+	struct per_cpu_pages *__ret;					\
+	pcp_trylock_prepare(UP_flags);					\
+	__ret = pcpu_spin_trylock(struct per_cpu_pages, lock, ptr);	\
+	if (!__ret)							\
+		pcp_trylock_finish(UP_flags);				\
+	__ret;								\
+})
 
-#define pcp_spin_unlock(ptr)						\
-	pcpu_spin_unlock(lock, ptr)
+#define pcp_spin_unlock(ptr, UP_flags)					\
+({									\
+	pcpu_spin_unlock(lock, ptr);					\
+	pcp_trylock_finish(UP_flags);					\
+})
 
 #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
 DEFINE_PER_CPU(int, numa_node);
@@ -2887,13 +2888,10 @@ static bool free_frozen_page_commit(struct zone *zone,
 		if (to_free == 0 || pcp->count == 0)
 			break;
 
-		pcp_spin_unlock(pcp);
-		pcp_trylock_finish(*UP_flags);
+		pcp_spin_unlock(pcp, *UP_flags);
 
-		pcp_trylock_prepare(*UP_flags);
-		pcp = pcp_spin_trylock(zone->per_cpu_pageset);
+		pcp = pcp_spin_trylock(zone->per_cpu_pageset, *UP_flags);
 		if (!pcp) {
-			pcp_trylock_finish(*UP_flags);
 			ret = false;
 			break;
 		}
@@ -2904,8 +2902,7 @@ static bool free_frozen_page_commit(struct zone *zone,
 		 * returned in an unlocked state.
 		 */
 		if (smp_processor_id() != cpu) {
-			pcp_spin_unlock(pcp);
-			pcp_trylock_finish(*UP_flags);
+			pcp_spin_unlock(pcp, *UP_flags);
 			ret = false;
 			break;
 		}
@@ -2937,7 +2934,7 @@ static bool free_frozen_page_commit(struct zone *zone,
 static void __free_frozen_pages(struct page *page, unsigned int order,
 				fpi_t fpi_flags)
 {
-	unsigned long __maybe_unused UP_flags;
+	unsigned long UP_flags;
 	struct per_cpu_pages *pcp;
 	struct zone *zone;
 	unsigned long pfn = page_to_pfn(page);
@@ -2973,17 +2970,15 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 		add_page_to_zone_llist(zone, page, order);
 		return;
 	}
-	pcp_trylock_prepare(UP_flags);
-	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
+	pcp = pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);
 	if (pcp) {
 		if (!free_frozen_page_commit(zone, pcp, page, migratetype,
 						order, fpi_flags, &UP_flags))
 			return;
-		pcp_spin_unlock(pcp);
+		pcp_spin_unlock(pcp, UP_flags);
 	} else {
 		free_one_page(zone, page, pfn, order, fpi_flags);
 	}
-	pcp_trylock_finish(UP_flags);
 }
 
 void free_frozen_pages(struct page *page, unsigned int order)
@@ -2996,7 +2991,7 @@ void free_frozen_pages(struct page *page, unsigned int order)
  */
 void free_unref_folios(struct folio_batch *folios)
 {
-	unsigned long __maybe_unused UP_flags;
+	unsigned long UP_flags;
 	struct per_cpu_pages *pcp = NULL;
 	struct zone *locked_zone = NULL;
 	int i, j;
@@ -3039,8 +3034,7 @@ void free_unref_folios(struct folio_batch *folios)
 		if (zone != locked_zone ||
 		    is_migrate_isolate(migratetype)) {
 			if (pcp) {
-				pcp_spin_unlock(pcp);
-				pcp_trylock_finish(UP_flags);
+				pcp_spin_unlock(pcp, UP_flags);
 				locked_zone = NULL;
 				pcp = NULL;
 			}
@@ -3059,10 +3053,8 @@ void free_unref_folios(struct folio_batch *folios)
 			 * trylock is necessary as folios may be getting freed
 			 * from IRQ or SoftIRQ context after an IO completion.
 			 */
-			pcp_trylock_prepare(UP_flags);
-			pcp = pcp_spin_trylock(zone->per_cpu_pageset);
+			pcp = pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);
 			if (unlikely(!pcp)) {
-				pcp_trylock_finish(UP_flags);
 				free_one_page(zone, &folio->page, pfn,
 					      order, FPI_NONE);
 				continue;
@@ -3085,10 +3077,8 @@ void free_unref_folios(struct folio_batch *folios)
 		}
 	}
 
-	if (pcp) {
-		pcp_spin_unlock(pcp);
-		pcp_trylock_finish(UP_flags);
-	}
+	if (pcp)
+		pcp_spin_unlock(pcp, UP_flags);
 	folio_batch_reinit(folios);
 }
 
@@ -3339,15 +3329,12 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	struct per_cpu_pages *pcp;
 	struct list_head *list;
 	struct page *page;
-	unsigned long __maybe_unused UP_flags;
+	unsigned long UP_flags;
 
 	/* spin_trylock may fail due to a parallel drain or IRQ reentrancy. */
-	pcp_trylock_prepare(UP_flags);
-	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
-	if (!pcp) {
-		pcp_trylock_finish(UP_flags);
+	pcp = pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);
+	if (!pcp)
 		return NULL;
-	}
 
 	/*
 	 * On allocation, reduce the number of pages that are batch freed.
@@ -3357,8 +3344,7 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	pcp->free_count >>= 1;
 	list = &pcp->lists[order_to_pindex(migratetype, order)];
 	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp, list);
-	pcp_spin_unlock(pcp);
-	pcp_trylock_finish(UP_flags);
+	pcp_spin_unlock(pcp, UP_flags);
 	if (page) {
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
 		zone_statistics(preferred_zone, zone, 1);
@@ -5045,7 +5031,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 			struct page **page_array)
 {
 	struct page *page;
-	unsigned long __maybe_unused UP_flags;
+	unsigned long UP_flags;
 	struct zone *zone;
 	struct zoneref *z;
 	struct per_cpu_pages *pcp;
@@ -5139,10 +5125,9 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		goto failed;
 
 	/* spin_trylock may fail due to a parallel drain or IRQ reentrancy. */
-	pcp_trylock_prepare(UP_flags);
-	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
+	pcp = pcp_spin_trylock(zone->per_cpu_pageset, UP_flags);
 	if (!pcp)
-		goto failed_irq;
+		goto failed;
 
 	/* Attempt the batch allocation */
 	pcp_list = &pcp->lists[order_to_pindex(ac.migratetype, 0)];
@@ -5159,8 +5144,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		if (unlikely(!page)) {
 			/* Try and allocate at least one page */
 			if (!nr_account) {
-				pcp_spin_unlock(pcp);
-				goto failed_irq;
+				pcp_spin_unlock(pcp, UP_flags);
+				goto failed;
 			}
 			break;
 		}
@@ -5171,8 +5156,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		page_array[nr_populated++] = page;
 	}
 
-	pcp_spin_unlock(pcp);
-	pcp_trylock_finish(UP_flags);
+	pcp_spin_unlock(pcp, UP_flags);
 
 	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
 	zone_statistics(zonelist_zone(ac.preferred_zoneref), zone, nr_account);
@@ -5180,9 +5164,6 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 out:
 	return nr_populated;
 
-failed_irq:
-	pcp_trylock_finish(UP_flags);
-
 failed:
 	page = __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask);
 	if (page)

---
base-commit: 550b531346a7e4e7ad31813d0d1d6a6d8c10a06f
change-id: 20251015-b4-pcp-lock-cleanup-9b70b417a20e

Best regards,
-- 
Vlastimil Babka <vbabka@suse.cz>


