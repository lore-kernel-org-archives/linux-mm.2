Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5756A606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 21:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CuouEd0R
Received: by kanga.kvack.org (Postfix)
	id 6C5476B0ABF; Wed, 25 Nov 2026 16:27:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 676606B0AC1; Wed, 25 Nov 2026 16:27:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B3126B0AC2; Wed, 25 Nov 2026 16:27:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 318406B0ABF
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:27:37 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B1582A0132
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:27:36 +0000 (UTC)
X-FDA: 85474928112.14.AC91F7A
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	by imf16.hostedemail.com (Postfix) with ESMTP id D8618180010
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:27:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=CuouEd0R;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795642055;
	b=Zn0DDWlfkau9QxFim2/WAZz8lBiA+2YIJmJnlTyUpObTmM/gwtPPXBFn9xZ4GzMe9jg3ez
	z65en+DeWSAUmN73u5Td3mMuQAK9V7nWhUTsG02806g7yraZhfgOtp4iJmjqWG5RW33wKD
	haf6DPKQVMlAMQb2Cb/H6p7q+O+kO5Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795642054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Po/VMnNPFKlYAPvPbfBlMgiPu0A6mBCRrEbMyYdIQcQ=;
	b=m3y54n8w5CHgBeCNnAgnbK+atAvvouGEFqNGn8PAYHNu4t6KLOjnY7Fu0WvfJrb5qULoBX
	2z2+g7GF98rWsLA8TH9d6mvmf6CwCTL2lC6+g1qjvuFzB/KTzJ1XQS1TqKQ6ZkEdOqcDE6
	kCobOapj3dsfxoIQmPDQXmpYJ6bFS4E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=CuouEd0R;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-862a19300b7so2186560a34.2
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795642054; x=1796246854; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Po/VMnNPFKlYAPvPbfBlMgiPu0A6mBCRrEbMyYdIQcQ=;
        b=CuouEd0R6H+TiYgbGi4SycRIhTYgkbDlc3QwBQXfZyCKcTcNyt+oORnLMU67NvenL9
         i+OWxBfWwWWnmLV63wnomTphi1zN5WUF0g38+Dme3hcBqaHu4xmtrETMxT7LlRr1NEyY
         ma5k9olka4MubPma+3IExCnu+xcP6/cCXcGOpCHNoEmRvDxdFQZH330RZJjCKzKrlYnJ
         7U5HsRCHLctWva4gyZWNm92p1NPt89EQkbwV6TbGgFt1I2xWhPePwKoa8nMim0BTE6Ci
         eVp70XVKTJ45phBac8UgSJM9lqMPxKdnAoMccTA9Gkuqcoko6bLmxZwB2NKz/WMAK9TL
         odyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795642054; x=1796246854;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Po/VMnNPFKlYAPvPbfBlMgiPu0A6mBCRrEbMyYdIQcQ=;
        b=L76gdlPkQGt2XdErAQUaJkOuVHmLTf7hpLM5i+2Zofi4a4xJGJWIhHKowjHfWjoC1g
         GvGz/c+7ukcu/T0zXrDllZBjcOSxti4MbdhaMgsioW2WajS4MdyvgW6aQ7/kf1jvlTl2
         qz9qVxxDTCLNCoXgkUAekK9BSyM95w9lakpZLhLivePuU886YuMytr6Cwik6Iuofe1jt
         D+4ql9549wSAtQlbY0/0GPz4bF0PLBdgT/Hh+fP6H7bLrwaCkEp0SppPWtnvgNKT58In
         dLN5505aq/1DvlFs4V5+ODSZsKrU1+bTo0wx2SRR8ef2IXHZVv8YElff+RuN5KVFsPmK
         az2w==
X-Forwarded-Encrypted: i=1; AL+hErFaP3D1k9A9tzX4rrT9UPCH1vTbIAQSW48DNmSscQOC2xiR7ZBmLUB8IxJhpvSa0NevxQsBWuxnPQ==@kvack.org
X-Gm-Message-State: APuU4Z8yixeI//n5ky/+ZW/o4BSJszTFn6B1R4Rt+wiwLcGd5LATcCDq
	gJj5olmj63uErqH7qAofwwOqqhGWtwIrNk+EUyEB547oBG/N0/uvhbWf
X-Gm-Gg: AZFdTZcOjihIQiI1ReF8aMsTGuEUXOJB0BTOqE/qWeJ3D9d6RhXzBq6EIuqq5a4u5ah
	lSxy1WGUCE5dydxVUaNwBMs6Y6yaESoC6wToNph0hBCpXHaNXmL6PZqyILSm8keMsNGeazZZWt7
	QXpeepYt2bWtxJZ7AS0zmQ+Tf7iRBwX409vxDr5YPuFfUL++Ehy3kVt/RVTAfHGGS/JWMMfcsz+
	T6RM0+eBxL1sPhbLiHMLNpPSMjANl8ltC/Grqmb9iXTuz8N+y/Bdj6urDL+oB9UKU1G6GQjxGYV
	MSGr47MLc+BijH26Z4ON8RcySIRW+jJePv/rdofNrOerF4mKKIcrnRiYnEaWJiB28yHZTYoWNks
	ta/wkruyERu2kKcVAeHHkv1gxCHDsH10wopaHsslKNUBdygnWJSNQfIvoR5Ugd5zidU3kbdqEll
	7pEeLMkcvJ+X82/AIFVxArTxtikyMKXNGPfRtOuY60s3akKzQm3Dn5mxgt+WhhdF3osvH3dGkAy
	bEbn6cOLXMRMxdbrQJqNEcb4IQonpSzNjy4h++HX4Fce6bteFhTcI42IfzpFmuXJ6L8iWdf3Q0q
	5Swkv8LP1gdTtOx2tB0CHvYHWvh8DYyvsajZ7xh/8bToEun0O2g0s4npLJJj
X-Received: by 2002:a05:6830:3151:b0:862:ca2e:919f with SMTP id 46e09a7af769-863158f0a19mr26925527a34.18.1795642053680;
        Wed, 25 Nov 2026 13:27:33 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:4a::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-8631692d9f7sm14718395a34.24.2026.11.25.13.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 13:27:33 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH 2/3] mm/page_alloc: drop the pcp lock before enabling IRQs after a refill
Date: Wed, 25 Nov 2026 13:27:26 -0800
Message-ID: <20261125212730.1128631-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261125212730.1128631-1-joshua.hahnjy@gmail.com>
References: <20261125212730.1128631-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: 33ri7oea6mmghrxhcykkwr9i1d5si3eh
X-Rspamd-Queue-Id: D8618180010
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795642054-225764
X-HE-Meta: U2FsdGVkX182UyO0LaDXG7o/z81g8rMa3Xb6UVbAzv2EEK0NHwTPIVOFXaT1UNwDk7A6hqNOigK4hphFLagSuWIffbj3n8fWV3RHEqG/mAwsc/ESZKmEc4DVTd4FI5EGmO9viTm015roGlEvTmDSfN4cH4S6aUioaaJJQseTgeoy3eWJ0wzFwsbpnhc8QU0QPxT7loRgfzxPt8xwno5VeRDKGFXD50/RI3bg5/t/M0vJqaPhiidUtKCHbAGvBPGBd3ICDvYw0vVmWPsKMB64n1e09i0sPe2iWoL+05ik17L82tJ+KYFqSFKlJWNPD1lU7RPm5Um1nrZvsC4Vr5RNJHwuEvIzlbFBWtfneF0xObHsa9hm63JwducVg39yPysDVEiad3mc04VJe1u22M1H/8svo2uIp39rUSuewIIotdXT3ndOgxmsLINyiJ6U/yZMm6ndWn+KlLm5NC8VvisIss6Ok1bRcc2WhGsaf/6f7E29imM4nj7bkHJdI+Ctr/wlFWSjKu97ouyhp3HwMIwcigUmxHCIRXr9ZmZAezoo2rlwmpn5nswyC2EIm3ju5ve7vsvEZ8fbTMC1dJPRTO573lGCy3aEeV4Oy6A+18WBNBoFEoM6QSJ5UnFrD5kxnWAf0xy7gbI6bX/5OOHQwoi6B08uo2kdaL1KrvZlYbpqhXD5zDY7VxoJqnWEaFY/rQ+ipEUcqeO1/R3Q2MXYla+KRIyrXiDzHWHznoiCmQfqyqP9YUA/ZpWn0hclzF0g0PnDcuC00wc4MF/3Nsy3AjHEFk5Y4q3Y9AOiHfzMNZpoKzJE3l6wr9d6y/sjss+xvhVFXQurl/G5i3Z89rK0B6V8Ir8C7FR+mzs4VCJTJyZgRUtrDt2SmN2f3d5zUxmJWA+emNSErTqrykvmIi1K2SL8uWYqh3gRkwhKC/U2Lb3Vlcv1eMAHB6ZYpqhLv5jLewkbsXZbO+hUBDy9XJ/mnQD
 IopDOssM
 eDJzXc/7NyVRtSyXujIujwbScUsAWEeWQluCusBLz+5PiZaYwQBOmonKesmftLy86F4TP9lW25Aa9YOTDNaKiCn3H3tSkTXYG1kSe9+2au9ekX9mfnazFAUAU8kqqIh9H8FmarU3sPB/Axr7WNvI64r3EVsg3HEwbZzhEdKjfHbEjIiiIPTIJWX7MD6kOoYuj4NXPbsLtJUCxDvRgkHflNaHRd4Q2nvZA7EYspsw1jO+3PML84d85BZV8zlqI6TDD3A7jrxcj+oXlIOCkKpefJH35Q80CNIjOjzm6Np71DHX0Qc+U3xMfnw8usrSh1eRZln7hctHZDjH7gVO/HUmqMyG2CAuMC58d8DFARjPdqAlnJtwGZqFpHAtxqzGVbeG8OVI7gMActjJce6+ybLnbHpewZ92gcG2vUo9FT7uaXwO7JXvYZsLDZtDOFabJDClEw7tbc2JhADKMEKqgCPqaMwBTV7X0L7/yvGxXpmorZxn6sMUD5gZyeIpKrsqRgZ+8ggLN8IXIgY5bdDJoqYqCAThJxRX7gSjZtpIAd+NSJGcdLcDcjhN70pwRU0uu/INRTVoBaH20fYxIXheHzvxugapXGa64PdXImxQ3fpTSNAmSAyDEO5IboK5wJHzP0rpxJJ9b2LqJ6KiG54HRmivmAJ/a35u1LIRSwWVzjHzqWJroOTqxszqEo/8cip6A98xJL6PHB89AEZcGnXhoXuWKh/A7CABEiLDpZH6M85n2eAi4rtELDlFqZVY9jZ2JMIBFm+keNOkX9gRG6LE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

rmqueue_pcplist() refills an empty pcp list with rmqueue_bulk(), which
spins on zone->lock with IRQs disabled. An interrupt that comes in
the meantime will run while the pcp lock is held, meaning the softirqs
fall back to taking zone->lock for each page.

When the list is empty, disable IRQs before the refill and restore them
only after dropping the pcp lock. PREEMPT_RT keeps IRQs enabled.

With zone->lock contended in a 128-vCPU guest, tlb_remove_table_rcu()
callbacks hitting the fallback went from 7% to 1.5% and the average
callback duration from 1.5ms to 0.6ms (the previous commit brought
these down from 93% and 14ms, respectively).

Note that alloc_pages_bulk_noprof() still refills with IRQs enabled
under the pcp lock. This one needs a different fix as it keeps the
lock across prep_new_page(), so leave this for future work.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bc272f8d8ec75..0e669e206d371 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3405,6 +3405,8 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	struct per_cpu_pages *pcp;
 	struct list_head *list;
 	struct page *page;
+	unsigned long flags;
+	bool refill;
 
 	/* spin_trylock may fail due to a parallel drain or IRQ reentrancy. */
 	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
@@ -3418,8 +3420,15 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	 */
 	pcp->free_count >>= 1;
 	list = &pcp->lists[order_to_pindex(migratetype, order)];
+	/* Refilling takes zone->lock, see pcp_spin_unlock_irqrestore() */
+	refill = !IS_ENABLED(CONFIG_PREEMPT_RT) && list_empty(list);
+	if (refill)
+		local_irq_save(flags);
 	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp, list);
-	pcp_spin_unlock(pcp);
+	if (refill)
+		pcp_spin_unlock_irqrestore(pcp, flags);
+	else
+		pcp_spin_unlock(pcp);
 	if (page) {
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
 		zone_statistics(preferred_zone, zone, 1);
-- 
2.53.1-Meta


