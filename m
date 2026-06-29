Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFEE9C43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:12:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 226296B00B3; Mon, 29 Jun 2026 09:12:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15E9A6B00BC; Mon, 29 Jun 2026 09:12:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1C966B00DB; Mon, 29 Jun 2026 09:12:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C58C46B00B3
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:12:18 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 57689A066A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:18 +0000 (UTC)
X-FDA: 84932988756.21.8C37039
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id 934B61C000C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eAkgD5Vo;
	spf=pass (imf20.hostedemail.com: domain of 3Lm9CaggKCG8WNPXZNaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3Lm9CaggKCG8WNPXZNaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738736;
	b=Nr5lZo3ij5SbEfvlhRKCfIs6nZBFYukOBMymyOiN2boi1E+3xaqXVQEcNJD2mfv9NJbuKN
	SEh5wY5Yt3Q02JFxMBicxE63g4SvEis5RnOKbXWmoA5r+kY6BO5Gc9BYJuimvH4lK/toxN
	5qfmGYbjxL4NqOGSorN21kIpUmLxyJQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1KiAPxDKk/sTRmD2XdxXE4JggXE3gBepw6QWVMegxow=;
	b=4RD+rs/U1GrBA1lCI07Xt3JHzIkYfwWN44obsbhHATN5A99o/iG2naLbN+LQrikM5QuXrO
	UqSfhcFZWvjZ2nEfN5FxXu1P8XlYMluLxjXqIFdf6vJfhs3UudVpGDZ+DwA8WZZSRP0c51
	msAR5h7u2A8WhYlj5XEDVNWgncNn/SQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eAkgD5Vo;
	spf=pass (imf20.hostedemail.com: domain of 3Lm9CaggKCG8WNPXZNaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3Lm9CaggKCG8WNPXZNaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493a6135742so16821815e9.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782738735; x=1783343535; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1KiAPxDKk/sTRmD2XdxXE4JggXE3gBepw6QWVMegxow=;
        b=eAkgD5Vomrr1d+km4YkMn4E+9YhMasPD9Eb3FzdSXWafxWjGpeKAdfryQJNqU91MBA
         BHNbLl699RPDiXtz6j5+GmRo37YIUeq0ZS2k/EBCbryr4g2YDtmgRh3QCurwNAKavvcg
         rGZR1nIGrNhKO6hBxGEcEGQ4Scuap5I8Ph5pGAkcLbj4TDM1wlAo9+GFyibO5RJmrDQB
         r3M+Mr9w5AF9jXGHc2QbO/4GkQFF5P2lOmkhwC5zTI6F7NbBNK1DQoKSZL8AN/kKAyJr
         znHCZaLjhxg6H0nhEPZ+O+U2NOKaZSA2dvxe9neO7cgV5TgiU0cMts+NiPALX8IbCgxW
         odng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782738735; x=1783343535;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1KiAPxDKk/sTRmD2XdxXE4JggXE3gBepw6QWVMegxow=;
        b=IeTd1x4ggW44O29Wby4KrgZy6+1Mo4GEvHxFzqEF/SmwE4mEreP+pmN43n5ti41VZK
         Vf0p5Vx5reH8FimsEUSC7FF5y7+lfveRxoC6v+u7FADzGaau175G7I8cfpJqFYqF8T9A
         7HGL8z+tE4ob7hplCX6GvvJohnYJ8Ah4gx/Vo1xlr6Y/UBPAEKU0EupT4ULEC1aDgeD1
         8LYVaQocj2gB3M0II4xeIFgVC6exUcdcGTxwKPH84+K0GSIgkdPCGYR7+x+lvOh7p/29
         XT5Hsn1k1pE73k6Z8QSSJAKKEN6+bIxoFZPQYydbP8CfATp6hSZL5FPrv8OVsTmgxTUq
         nHGA==
X-Forwarded-Encrypted: i=1; AFNElJ/+fQPcuKpajiy9PjYagq6UI3m8CUmq0RRKgSEto1OdbHARLYjIHzp0yQCOLRDLCedEgIUkrmQWsA==@kvack.org
X-Gm-Message-State: AOJu0Yy6Ocg6Ww/lGnMpUTgkTkuDzGHoNFYoxBK2GzbD3b3okuTaErIp
	1rSrSfwtJP/Y21z8Y/3Dl5nsRE/PvbX9TZACUJLxL+2He/3+d7GJ7o8B+qWaVGGxo95qPXNCyPT
	9MohjsxPuVfUlvQ==
X-Received: from wmbei8.prod.google.com ([2002:a05:600c:3f08:b0:490:4477:50d3])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b85:b0:490:50c5:8153 with SMTP id 5b1f17b1804b1-4926683231fmr257056755e9.2.1782738734079;
 Mon, 29 Jun 2026 06:12:14 -0700 (PDT)
Date: Mon, 29 Jun 2026 13:11:50 +0000
In-Reply-To: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
Mime-Version: 1.0
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260629-alloc-trylock-v3-1-57bef0eadbc2@google.com>
Subject: [PATCH v3 01/16] mm/page_alloc: rename ALLOC_TRYLOCK -> ALLOC_NOLOCK
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 934B61C000C
X-Stat-Signature: kkrzypbttuwey8hhq993seaaa7cfxp8o
X-HE-Tag: 1782738736-416613
X-HE-Meta: U2FsdGVkX18AkETKzcJyniUJ3bwIMIKDvU3jEBoOqiNOu38NEQhosSRlObN406JGdJ09zqoFqLO0b7DfE1B4Fl+C0UdjhXihA7RnLycAOYWwTXCB1uR+9t8seKxfW/SgNVaXEdbsrsHVRC/WAcKA/bXIntKAiK8NTd7LPVhHgtF8KpXUWnWSIMxc5cVZDLKIYz6TRtZgVJDjq4vMii/+PD4VquRqBoBtz4f/u8L1n8Q3ToUslMr+jZqQS7Il33Au+YH7EbPsuU0EFaExwVlXO1ZTjxk5dwIhtB5bqqMvMS/RswoHc1lXQSfprblOxjp/aX6/PRUo69mG/wpsZQRKbC2EhdencJPq9dtiXbdlf8lTOz4uQY5qba7u39TqsKKTdeAY/OOmcTUz1GyjsB5cB9UIJtlfdnMNyEXXTuiAmClDrrBg/z2NZOtAPJX0TtRstyPdapkpLK61bnC4oTYKf0VQ+e7nLwAWpElnDGgbn8AXVr722KQI8mVHunG7y+UP6CqQ7vyPY+QFxyd0xmtwzigPglfWhb7tU6g+KV1MOHNkm+bKCXSWUESszVbrMBT4WqqvOeTl8G5Vn9d4cRwh3QaRsiWqiSxt0pJR4cSz0sRXqMSIwPIDIic0O+8T3wLiuqroPiMZLOh7pVqOXrO817qThFqWOq9ygJ/AudyNobPuvMh6+RAqWYrXgQ9vk1zd2H1CrunRed3FzOPbae57gNbUGsTDh6a4iLTn2yyEthEI0I+xqEK7rqRnQPqrTDGRTRd+p9lgJjxs5/2cIxyZMccAZAWwTpem+C0+wQQzAoTJ/R+xsHXFuoWa8sO2Gq0F0W9R6hiPosXUUQQ/mXKUsYBKGw2hxKMgo6PT7B5lJgYfekjfme0PG4SJoZxVFP5B1fvVrbJA4FZazuF99LzGli3kZTI3PIq6w5BSfHtW4zDh4oVMTBrZ5vJbgsuXI1rKStnjLWq3Cs818x60HIG
 4CG31Zt1
 3/QG2kozmeeCHT982eul/4Jrq4zS5SsYRnk8LsFM2xzh34DluQ2VzXXEZTSBFHrb2hBwAJuR5RwXGkBbi1H48NZa/73OJr6cRW/qXUqztNRaIrpae+F1xnnP8CKhpuiUKWh1w9f2nnDsYCV/zmmfZUoqGYwIcDbwp8Dyd7/jpCkd2jCNFi7Jl552SWmE5yRfL8bqK22/xtK0++7S1SMoGy3BJLmLxacxE+2ZMNAMhas4pFV5qd9OZ5HCzhFc6JbEen6jmj0r3uJpYi8z/qS+0uFKPR4WNRlHErYxUFY3M0Up4G9+WeofiilK78IrnJF29cxlGORdyyyPd0GiF18GqBYQilBx4mJkpnqhfH+uFASSc9ARxMughXNTHuH+MT7g+IqbcbWu8T3Ed4xr+orAVOGyQHrGtJjELA0m7Os1LHk+ayb1K8S57h+cdCdHcUwdtg/KfELvDS6jsZ2cVRAixZuS3eEm+EC8S0TQ9q8iLQpWAHlZVdwuSMrHg31/WHAzof0iQKgzj6Yu4p2B2i+Hvrbg68lrfa1WD68NmlObII40Yd1TF1AubLKzrLnuWSR2SmKfeGBSqvaskQuoRTEWCpc6ieDYvhNCE006kDdQbJxR4QN1FrUn4FYrrUElcHPtIX2ZkhBza2S0548hfDu2lbg+WYB7RU5B9qPwZgO2r071gpz70ggCc/+XxagFdeLV8z3NVPkU/aKABA2s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's confusing that the function is called "nolock" but the flag is
called "trylock", align them.

The function's terminology is more visible and has more mindshare so use that.

Suggested-by: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Link: https://lore.kernel.org/linux-mm/2399b3ad-4eac-4a14-94c3-27e9f07972a1@kernel.org/
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/internal.h   |  2 +-
 mm/page_alloc.c | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 430aa72a45758..2237eee030cba 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1480,7 +1480,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 #define ALLOC_NOFRAGMENT	  0x0
 #endif
 #define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
-#define ALLOC_TRYLOCK		0x400 /* Only use spin_trylock in allocation path */
+#define ALLOC_NOLOCK		0x400 /* Only use spin_trylock in allocation path */
 #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
 
 /* Flags that allow allocations below the min watermark. */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 62f71ece7ca17..421271849f291 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2530,7 +2530,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 	unsigned long flags;
 	int i;
 
-	if (unlikely(alloc_flags & ALLOC_TRYLOCK)) {
+	if (unlikely(alloc_flags & ALLOC_NOLOCK)) {
 		if (!spin_trylock_irqsave(&zone->lock, flags))
 			return 0;
 	} else {
@@ -3218,7 +3218,7 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 
 	do {
 		page = NULL;
-		if (unlikely(alloc_flags & ALLOC_TRYLOCK)) {
+		if (unlikely(alloc_flags & ALLOC_NOLOCK)) {
 			if (!spin_trylock_irqsave(&zone->lock, flags))
 				return NULL;
 		} else {
@@ -5059,7 +5059,7 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
 	 * Don't invoke should_fail logic, since it may call
 	 * get_random_u32() and printk() which need to spin_lock.
 	 */
-	if (!(*alloc_flags & ALLOC_TRYLOCK) &&
+	if (!(*alloc_flags & ALLOC_NOLOCK) &&
 	    should_fail_alloc_page(gfp_mask, order))
 		return false;
 
@@ -7804,7 +7804,7 @@ static bool cond_accept_memory(struct zone *zone, unsigned int order,
 		return false;
 
 	/* Bailout, since try_to_accept_memory_one() needs to take a lock */
-	if (alloc_flags & ALLOC_TRYLOCK)
+	if (alloc_flags & ALLOC_NOLOCK)
 		return false;
 
 	wmark = promo_wmark_pages(zone);
@@ -7896,7 +7896,7 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
 	 */
 	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_ZERO | __GFP_NOMEMALLOC | __GFP_COMP
 			| gfp_flags;
-	unsigned int alloc_flags = ALLOC_TRYLOCK;
+	unsigned int alloc_flags = ALLOC_NOLOCK;
 	struct alloc_context ac = { };
 	struct page *page;
 

-- 
2.54.0


