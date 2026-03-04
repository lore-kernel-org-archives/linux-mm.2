Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89881EF8FE1
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 13:16:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A69456B0088; Wed,  4 Mar 2026 08:16:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A17406B0089; Wed,  4 Mar 2026 08:16:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 923816B008A; Wed,  4 Mar 2026 08:16:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D73E6B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:16:27 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2B56E1B83F8
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:16:27 +0000 (UTC)
X-FDA: 84508429614.29.E8F33B3
Received: from mailrelay-egress5.pub.mailoutpod3-cph3.one.com (mailrelay-egress5.pub.mailoutpod3-cph3.one.com [46.30.211.244])
	by imf14.hostedemail.com (Postfix) with ESMTP id A662F100007
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:16:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b="J/f/fT/t";
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=sol1UIqd
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772630185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KC8d/KVeXoBSBl3S63Vm4xwhGedRXfLdMa2e9njpMV0=;
	b=7BxAchqDDUITH3CPHcrrTYysb7g6EsD6hvyAyYrBfmy6Bl6b4iSVK4wNapjN9U3iO9Tvda
	kien98l+g5I+wFP19dZRubxtBB8Po+9Y7y1VCq909nVKqjfeqZJuhk1LVfg7cY1FJMvuT2
	fovCjD6eE8yDWIk8WdShTPAU4wEzUOs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b="J/f/fT/t";
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=sol1UIqd;
	spf=none (imf14.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.211.244) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772630185; a=rsa-sha256;
	cv=none;
	b=KD/AxSDwMWzdlb6ERBnCFVCGgp0mDVpv/68q3RIhG9sPwUqadUmhL+b9cvaKxPO7r4eUy8
	xof28c+wGHDezHnjHU5e4Idhw/cqwoOcIWOERxW38TYCV97QQMfw7inZBQSsjmRBOh2Xuo
	FH2fVQqdOIjaeVzmi+GQk96bB802GVE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1772630182; x=1773234982;
	d=konsulko.se; s=rsa1;
	h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
	 from;
	bh=KC8d/KVeXoBSBl3S63Vm4xwhGedRXfLdMa2e9njpMV0=;
	b=J/f/fT/tf6M2igfKIYMLizQKXT5lTR+ss0dralnkARg5R10SWOKAJIRN6NQRxl7ZUswU3wjyhLdCZ
	 wVAjrBFaZOXMSFzH7fTDXHjHLaKzWbQiE0raM7aQq+3jn2k6GaevuhQANE2Owo6F4F9jfF2Whxx4bT
	 cp+49hZZhhVMMxwRxalh7UDaFQ2QTuK3ic2aOSWHXhX09uufva6aTzxCAwqe+OmbI1YHhz5ORr84OD
	 F8VDswg3lzlviNKEBmze1QUlv4HcCA7QX6K5SyR5dJJw6cKmwnwFt3AAiNat8LzssD4qMvpRy5/5JU
	 lDlOSaxMVJCksnwACgJgWL5t2aY4bKQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1772630182; x=1773234982;
	d=konsulko.se; s=ed1;
	h=content-transfer-encoding:mime-version:message-id:date:subject:cc:to:from:
	 from;
	bh=KC8d/KVeXoBSBl3S63Vm4xwhGedRXfLdMa2e9njpMV0=;
	b=sol1UIqdgIp854m0kJbW+mnD+2sUgveCQMM1vDr3I+fHblb6M7/2HBPwmoylLVxAsVfoGUGlLIYHk
	 O+IY5AmBQ==
X-HalOne-ID: 5639a062-17cc-11f1-959c-f3c0f7fef5ee
Received: from localhost.localdomain (c188-151-133-237.bredband.tele2.se [188.151.133.237])
	by mailrelay4.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id 5639a062-17cc-11f1-959c-f3c0f7fef5ee;
	Wed, 04 Mar 2026 13:16:21 +0000 (UTC)
From: Vitaly Wool <vitaly.wool@konsulko.se>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org,
	Igor Belousov <igor.b@beldev.am>,
	Vitaly Wool <vitaly.wool@konsulko.se>
Subject: [PATCH] mempool: fix the race condition in mempool_resize()
Date: Wed,  4 Mar 2026 14:12:14 +0100
Message-Id: <20260304131214.102588-1-vitaly.wool@konsulko.se>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A662F100007
X-Stat-Signature: eruhx7msqyhpo7xwyzo3bs1nrydzs76p
X-Rspam-User: 
X-HE-Tag: 1772630184-318270
X-HE-Meta: U2FsdGVkX1/PxOK5eZ7wgUuLM/CJ4l3D8jEhsh5ohqPX/aiyxfHQx2gGwzGL8EzK2uOUcyoChYDdfnAtnU7skWrtECfYVI2TJ6y2pjqAm5g4/yxfiP9vU1mw13crWBvwbKEjXlUTUFLY57vfgtwBK4ydwMpK9Zql2aABWUCZdtGcthXJd/kZL0BxPpfxpllKWPjtyuZiJSwiJHRP3NvfamHd4CockrvY6dfWerdB2UGvZpBLjzwQWheckOcvDpJYiGMBAwISvL6Rm2AHqQoftprLSMhsT1s4h9r5hMCR+UresGRhOJ1SrMnXHTFjl6atWZKCEBBU82pgV/dTx7wtU7O7zRYbbW2e4uXeY4Adhso+v5EnAz/6csMG/7z9CQZiL7jrwbrQ+45hc8bqrqshTk0IhY+oQspsZ4vkFHwn9l/ZpYRVwhjY5mqePwcgdWmcJmRGUo2twHAFmgnjXXxasiYD+mcdEB1Jdd4vfxPHVPJpBugZY09295UbACmTJzwOpLhkDJQhZlDOZtPDJ7n3L0n1IVy21dfcdqidYIqXHNA7jrD/2UgYY4oQXr33SYCAGORS60l701ZjNF8Q04SCr4PHlqJlTfkOmTRQCH17OLv84TCkxGdMayV9oRbH1bThynh93Pbb4p35euROcDS7aNRouShqbVsPZ6ZjJ566uF3fbLavcO4qKiRds32ccqXwkVe//j0WFnQFD1WiWA035ONY7EHuDqz+MOa6sXq9zngPD0GmPWYefHPKa+q5MxUTMdTeHYzUdYec2OzezPaccQjItRFBkviR4de0kUJll6PwSccw3er/7OF84zQCWAL5Umv1APOHiwDmPyfowXvOLYX2+bRmH7VeBBZmbuMOBg4MM5AeFJMLzSm5kOv9hTqhe64MRN1c7LzSs9whyTvb0bR2UbLLgFXNeMYyCpvv920HAMNeAP/bTeda+uFLitW0SdCfubdC3fDz4lHe4vR
 YONNhnpa
 YlHAlMXFikc1O1gAH93fEKsPiItWE9WR6E0kd+sP0EK0WoDls8u3ala/xjGcB+7k1Yl5/fSBJBa7AUWkK9U89PEPXgw50G8OM1djsRiz4SV90TXP3K5mnMfh7sJk6RXfHvdqDc4FaWJr/7nb1ALFwxxkU9kmYt2gd5vqYr8Unt+K9l9qCP8+aFxbSKqRpluenoQqptGpI2iLo90k2gXyCM725pQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Igor Belousov <igor.b@beldev.am>

mempool_resize() at some point has no valid elements array for a pool:
...
    kfree(pool->elements);
    /* here pool->elements is not valid */
    pool->elements = new_elements;
...

If e. g. mempool_alloc() tries to access pool->elements after kfree()
but before the assignment that follows, we end up with an undefined
behavior. Fix that by changing pool->elements to new_elements first
and then freeing up the old array.

Signed-off-by: Igor Belousov <igor.b@beldev.am>
Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
---
 mm/mempool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index db23e0eef652..302d83cbeac1 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -384,8 +384,8 @@ int mempool_resize(struct mempool *pool, int new_min_nr)
 	}
 	memcpy(new_elements, pool->elements,
 			pool->curr_nr * sizeof(*new_elements));
-	kfree(pool->elements);
-	pool->elements = new_elements;
+	xchg(pool->elements, new_elements);
+	kfree(new_elements);
 	pool->min_nr = new_min_nr;
 
 	while (pool->curr_nr < pool->min_nr) {
-- 
2.39.2


