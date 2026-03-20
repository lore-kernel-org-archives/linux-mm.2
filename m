Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97E6C1099B28
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 17:34:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9E3B6B00A4; Fri, 20 Mar 2026 13:34:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D75706B0120; Fri, 20 Mar 2026 13:34:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB1EF6B0121; Fri, 20 Mar 2026 13:34:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B92E96B00A4
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:34:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 586631D5FB
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:34:40 +0000 (UTC)
X-FDA: 84567141120.18.F830559
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9CF4A40008
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:34:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LO5Pe43s;
	spf=pass (imf17.hostedemail.com: domain of 3LYW9aQQKCIIl1jrmuumrk.iusrot03-ssq1giq.uxm@flex--fvdl.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3LYW9aQQKCIIl1jrmuumrk.iusrot03-ssq1giq.uxm@flex--fvdl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774028078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bonijrsn1OMkw59Rfu4OJ4lbGEhyXMY7KnXznrPdFI8=;
	b=Dt0SUpOUGRZec0PAeEn0GRQfLOpZO8+VlJOrPrF7PzjSdGi2IKDGstFwlAYO5cQ12+5RAx
	tgoV855sVn12gibv9xH5ETXJMZA4ofZ8/W7jHSN7iPopNVZGwmFL1HllotfUUs7VxJ3Vgi
	+WsD+aDGHVsMQOBGwbRdRfXiZa5BnZQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LO5Pe43s;
	spf=pass (imf17.hostedemail.com: domain of 3LYW9aQQKCIIl1jrmuumrk.iusrot03-ssq1giq.uxm@flex--fvdl.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3LYW9aQQKCIIl1jrmuumrk.iusrot03-ssq1giq.uxm@flex--fvdl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774028078; a=rsa-sha256;
	cv=none;
	b=7Ja60ZOhbEWuRDi8feuWWKtPLCSNhEO8If7SO464H9J1R59LAxlwwpWtcmyC/vJsHYArs1
	4zTyBYDZLm2DdJx9f0z0CfLtBnKMKORmOCJUklzwlNeLS44Gs75LbBNpUgTsHhMn+goQ+p
	iRB6rmKFIZ68JRRN+OZC1RZ28/od97U=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35a0b51eb23so2189670a91.2
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774028077; x=1774632877; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bonijrsn1OMkw59Rfu4OJ4lbGEhyXMY7KnXznrPdFI8=;
        b=LO5Pe43sjR+8o429B/b4UEOcFkxEEt5TxHxIz7G1lmB0FvageAtu2F1fled+qNtQZS
         kWOZ5AChEhovqqoVbiArO9isqwxuPZlSy+j61kMRcW0gK0IRVT4aX8a0csYQPBn4RsNc
         gD3IkzrXAgHlKfk2TEcKk9wdrlPB2T5cUhr1HjofhY+MdK+52CqoMVMCg31L5hw82K3Q
         JrUiDk89Fn7/fhZKQ/vdC4eZh6Isj3FrCCe60Pc0WupL+s3rfRa7JJKGFoFxeUUDGScH
         TlJLbSncSjU4xbRDtaBrNR0v1yBmtlFSHqGevhpc4r2xbP5xROmujlAKUh1CCz5nz5+k
         GnGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774028077; x=1774632877;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bonijrsn1OMkw59Rfu4OJ4lbGEhyXMY7KnXznrPdFI8=;
        b=fONlQ3gNsqVGL5QE1P5V9GwsIKqPOqH6AoUMOmquqyDaLmq/YpffbcMQe82nImrhod
         NKZC9UHRhhd4oyFCOIMVTGEwfnZSO1LiI6ZOE6r/m9K2isO8MEaenkhL6txQsOHUe2fz
         hXP+wQ1qGvx2y5C5zzh3UluYWsW9bUuLgNsMXFt40shP9N2ozuUM+0Xlj58c5PfgzeIg
         jkPABEXRY0ZrpKDOpJ0i3OexsniYXskmnb+ZrWBIYQb4Nf096q+rlbPq4GQYeqtygUaK
         di0pDGj5MAhgm4saxhQl/ZcfSLzvmXOX4A82K4kjy/vECJdsj+YVW3hfys9H1fxrzXlY
         Z7hA==
X-Forwarded-Encrypted: i=1; AJvYcCWh7EkzrpD0rpp5X+YTgnkNXV3xKSY5r5Qdpf83lqMP9Pm5KWwHhgpKwgkw8BFgk3KmtlJEe1J6/w==@kvack.org
X-Gm-Message-State: AOJu0Yz8+WVL7g4RIRT6f7O30yc+MBHcxh1rP4jNQx5nft2m4qtTaAhe
	Bh3bUzeTRbn3EBI9mmE6lv034X51aPpwEaaYJeoHHBN/shJewPVjYwFxTTUlnfCaoeGxteU4WA=
	=
X-Received: from pgac4.prod.google.com ([2002:a05:6a02:2944:b0:c73:7879:4c1b])
 (user=fvdl job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:e7d1:b0:35b:90e7:c458
 with SMTP id 98e67ed59e1d1-35bd2bba0admr3287761a91.3.1774028077229; Fri, 20
 Mar 2026 10:34:37 -0700 (PDT)
Date: Fri, 20 Mar 2026 17:34:25 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.959.g497ff81fa9-goog
Message-ID: <20260320173426.1831267-1-fvdl@google.com>
Subject: [PATCH] mm/page_alloc: don't increase highatomic reserve after pcp alloc
From: Frank van der Linden <fvdl@google.com>
To: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Frank van der Linden <fvdl@google.com>, 
	Zhiguo Jiang <justinjiang@vivo.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 9CF4A40008
X-Rspamd-Server: rspam08
X-Stat-Signature: 7e8xemsjczxntjxnopcuy4mhmx9q3xy6
X-HE-Tag: 1774028078-449819
X-HE-Meta: U2FsdGVkX1/xzOFq5JE0BYyXLXK6zQb+7ON6XzfjYb2LfzGyw6fulDrxPhexajeGYKxZlo4XBHTMRljq8e/hONVPIwNNWUdBvhNAQTXzzuaEwZXi3X2vHKSwlFgxT0rxItc5lkJguSCC2WnD2rA4UG4akWQu33qpaVaCkuCfyBiOmF2bJju21Pjf3mGtn+PHeD3V90cUQlo3cJATldtr0bmH+Qj1TvrOqfB3ZR8rm2qNeBfjkBaahQugR3n8C8F2f394tWcS4+1ghyQizilCmodoy3Go9EKRQ5eDOp4V01PU7Ufd6DyRAe8M1/edlXE6kLKrjrDCybMjptPZWaDtFDE6ZxPtBc/vhs7JjMHymYnxl+uj29TOaqSN60iDaCgomVSiyWa4tJRgifne4ysqnCoSKMZNNa6ukhommG75qoAWTJybMN1f5SZjfTrUYepwH8Cu1OasxF1jNgiCvpYnBqGpTTx/HLpj9zQeAKUou2LP0DAySrrlPDwx+fXU/OU63Fsz9FFmk6Am8z4po6Ev4YACGLa/tA4blbbgjU3GuRnZVNP17vzgrc/p6TofmLaoLv+FrRE8NF6w87UAWgsT/fdUgcH7uw12UT8v3RU0iY07x1NiBFDYkL/FZ+hv8i/2A5EUo6h83lpyadjt+K+iomRyLMXMAg/5DLRcARwZzUeLWag537HrmuoyAWPuHhl0iZkM3LqqYdBvE0YfIOB9jwMYC4cn1+mFtdmkq5t8dPCbbWHEy9j9xrkcQAo5sgsfpDJCKbjGLiwAp7b4te0KHUl9BCzg9qyrYomK6RF6P1SsuwffASlnc0Evul4a6fzv4TYrncGKGoG1tFCkmDANG9nkpTr1vmfBQ3EiQ/1PY7gY19kARw9k9rOUoqSfAWAVzyTi11nj+9SAmfgbYp/9WivTpKe6hr7c5HaxHR+UGS958UtZvhVpOIcUQzOED464ziwPOzvyIG68wyUZA60
 feJ8ZuME
 EeZAjvJaK0qimWPnWb+8H0CIomWYp32gbmxU15URkCNy5eCGKkkxsBEBvu0ZT9Ai4VPQG/1JLcV7hZ+rcZZilMR2z5e2rlThQ3fu/xySlpF693TlMwX/cuEr6XodrIzBEPwWpqBtUCBAv7Q0s5AGnwi+Zs0+V4mL0XWb2OOlJvbp79kf5anugo+1gFJ3aVRLLhyuUA0LFQWyCRyzNlhfF2yx2MmMxsLiVSONkR2daRUSVBs9ySQYCJprBJ7MzGM4eNLRmWtRB2jpgIjk1NaBtVSkQGyWqtfmFkNbAo9cgW7bi6FwRNoNoEc/gtKs0FhWrKLrpEpZlTN48bpDHMOumrKOytpQeFyLrKtCBgg9WaFDG20Ehz4LKlzdQPclV7ydP7NGQdpx4qIB5WJ8rrdT1peObiUhh1su2v5Fmis68JiiLW5/nNEc7Ppgm5SELbrDGfN+wS3hueQjptXSATRoWWGvi5M/FzEgI37CufljDZhM5iZbYV9vm373MwYsRbIK6bk2iD/4fb5fY1M01GTcyarr+3pDu+fcvAXaEFZi3LxO0FA0Yhx981058WjYyMTXDJkwsFv2mIj3YLmv8LJTl2nEFhZ5S5oDPggG2kYOEs1RFYS0jcifBUzQhU0Nb2u2bp3QspYy9I/LCPbtK6vPAamxMsS7polGJp+zebR2qtlPiUhPtZdJ9Y+ek7rdMkKwbrfFfZB+hrMUvoGI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Higher order GFP_ATOMIC allocations can be served through a
PCP list with ALLOC_HIGHATOMIC set. Such an allocation can
e.g.  happen if a zone is between the low and min watermarks,
and get_page_from_freelist is retried after the alloc_flags
are relaxed.

The call to reserve_highatomic_pageblock() after such a PCP
allocation will result in an increase every single time:
the page from the (unmovable) PCP list will never have
migrate type MIGRATE_HIGHATOMIC, since MIGRATE_HIGHATOMIC
pages do not appear on the unmovable PCP list. So a new
pageblock is converted to MIGRATE_HIGHATOMIC.

Eventually that leads to the maximum of 1% of the zone being
used up by (often mostly free) MIGRATE_HIGHATOMIC pageblocks,
for no good reason. Since this space is not available for
normal allocations, this wastes memory and will push things
in to reclaim too soon.

This was observed on a system that ran a test with bursts of
memory activity, pared with GFP_ATOMIC SLUB activity. These
would lead to a new slab being allocated with GFP_ATOMIC,
sometimes hitting the get_page_from_freelist retry path by
being below the low watermark. While the frequency of those
allocations was low, it kept adding up over time, and the
number of MIGRATE_ATOMIC pageblocks kept increasing.

If a higher order atomic allocation can be served by
the unmovable PCP list, there is probably no need yet to
extend the reserves. So, move the check and possible extension
of the highatomic reserves to the buddy case only, and
do not refill the PCP list for ALLOC_HIGHATOMIC if it's
empty. This way, the PCP list is tried for ALLOC_HIGHATOMIC
for a fast atomic allocation. But it will immediately fall
back to rmqueue_buddy() if it's empty. In rmqueue_buddy(),
the MIGRATE_HIGHATOMIC buddy lists are tried first (as before),
and the reserves are extended only if that fails.

With this change, the test was stable. Highatomic reserves
were built up, but to a normal level. No highatomic failures
were seen.

This is similar to the patch proposed in [1] by Zhiguo Jiang,
but re-arranged a bit.

Signed-off-by: Zhiguo Jiang <justinjiang@vivo.com>
Signed-off-by: Frank van der Linden <fvdl@google.com>
Link: https://lore.kernel.org/all/20231122013925.1507-1-justinjiang@vivo.com/ [1]
Fixes: 44042b4498728 ("mm/page_alloc: allow high-order pages to be stored on the per-cpu lists")
---
 mm/page_alloc.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2d4b6f1a554e..57e17a15dae5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -243,6 +243,8 @@ unsigned int pageblock_order __read_mostly;
 
 static void __free_pages_ok(struct page *page, unsigned int order,
 			    fpi_t fpi_flags);
+static void reserve_highatomic_pageblock(struct page *page, int order,
+					 struct zone *zone);
 
 /*
  * results with 256, 32 in the lowmem_reserve sysctl:
@@ -3275,6 +3277,13 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 		spin_unlock_irqrestore(&zone->lock, flags);
 	} while (check_new_pages(page, order));
 
+	/*
+	 * If this is a high-order atomic allocation then check
+	 * if the pageblock should be reserved for the future
+	 */
+	if (unlikely(alloc_flags & ALLOC_HIGHATOMIC))
+		reserve_highatomic_pageblock(page, order, zone);
+
 	__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
 	zone_statistics(preferred_zone, zone, 1);
 
@@ -3346,6 +3355,20 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
 			int batch = nr_pcp_alloc(pcp, zone, order);
 			int alloced;
 
+			/*
+			 * Don't refill the list for a higher order atomic
+			 * allocation under memory pressure, as this would
+			 * not build up any HIGHATOMIC reserves, which
+			 * might be needed soon.
+			 *
+			 * Instead, direct it towards the reserves by
+			 * returning NULL, which will make the caller fall
+			 * back to rmqueue_buddy. This will try to use the
+			 * reserves first and grow them if needed.
+			 */
+			if (alloc_flags & ALLOC_HIGHATOMIC)
+				return NULL;
+
 			alloced = rmqueue_bulk(zone, order,
 					batch, list,
 					migratetype, alloc_flags);
@@ -3961,13 +3984,6 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		if (page) {
 			prep_new_page(page, order, gfp_mask, alloc_flags);
 
-			/*
-			 * If this is a high-order atomic allocation then check
-			 * if the pageblock should be reserved for the future
-			 */
-			if (unlikely(alloc_flags & ALLOC_HIGHATOMIC))
-				reserve_highatomic_pageblock(page, order, zone);
-
 			return page;
 		} else {
 			if (cond_accept_memory(zone, order, alloc_flags))
-- 
2.53.0.959.g497ff81fa9-goog


