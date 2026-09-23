Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26461C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D8176B008C; Wed, 23 Sep 2026 17:10:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AE896B0092; Wed, 23 Sep 2026 17:10:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 476156B0095; Wed, 23 Sep 2026 17:10:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 295AF6B0092
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:10:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3FCC4A3C76
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:10:51 +0000 (UTC)
X-FDA: 85246271502.16.EEEAD68
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7964D140008
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:10:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gayJnhJy;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790197849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xVr7KuSWyr8CUJERgbEEA0iI2fqWk3sHPjbcAbZFfj4=;
	b=Y8ONXANR58ukh0YbKVpnJoRjlmQr3nAGgOx+iJ59fByUqHA5e/SyScu2u2PwWySQNg4J2b
	LSAIG94k0aaQV9KWcNTZWLDAHr4yC/cf4Yjx7We/jJgMacfL1XkLJdCEBKpLhN8GrcwvU6
	6N+QHDPIF9b041eOiJwJcJ5jbRqr6lU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790197849;
	b=7A5+jXGO1FSC7Sz10zOPXIoHu0tBfCfjZfnGt5Z32VyD7gyparC/D/5VqnR9NBGShqApZZ
	oriTWWRifNLmKOa4ZGRkS7+hdEJhSiYuO3bYUCkL2/SKIbzOGMdtFvkuj2ClkBP9YYlR0S
	LhcfSAO1+qRUCY44OQX1KklEpZUIqeA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gayJnhJy;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93910cc46c7so138087585a.3
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790197849; x=1790802649; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xVr7KuSWyr8CUJERgbEEA0iI2fqWk3sHPjbcAbZFfj4=;
        b=gayJnhJyrrR+dIvrCTkEiYVZ4J9K9S5zn1qu6MFLmzMxmYziaY4PmFaCNaXVcB4S62
         mS5DNHRUJElcLDRZx9tSd4giYkXseGNdVlMK21iCAvobZSt1YJhrxVjUvGRIIvk1Hc6b
         ayBu/9KFSudhT3qYsPDQEKMPIWFSNny0zPPU6dzaM1MZp8dAlszz2UxHLiiQkxP52w0r
         rMz53bA5c9IMqBoxVOCAKRuelY7AqOlaWnBdbTPZrXqwfO/lI9jsT1jsBlwmFQ8RybtH
         2E8GBJb7BxNdx8mbzkdbUUjdd8LEjLauuGGFR5JMa3MKuVg8+HtZ0aF+btorHkwBU6p2
         zpcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790197849; x=1790802649;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xVr7KuSWyr8CUJERgbEEA0iI2fqWk3sHPjbcAbZFfj4=;
        b=hAjIE1XjIC3rSr6szgMfTs9nGXvm71NQpn3I531pxBtNrpPgGdgcdtaO/Hu9v4E4+4
         D1bQ0teGuROAUFQM2k9AIuomD4x1mLB6AXew/qijHfqCtlxQLkOBkPwKidRD5T6M/tYf
         4mazNaE1yyqdoJ7lVaf8bDYPr/4Xz7GFp2J9infAn5bsZWIMqK1mZvxCE6EBM1ITm5Rf
         YqY86jHyMNFUjSoIboB0qaDk9N/VoX+2ZyF1RPILRioKs0wJyb6TAPxxzZCJAVxfZPJu
         zRkw021AU1xiPKP+3ReH3oweJHVt1v+Cea1b6hbLJgxenuasKz5t0ahapiwyAU+x0K5n
         R8eA==
X-Gm-Message-State: AFuF++kpQxdsVthF+04sIO5T5C63EOjD7JkBlpXwTw4/boDNar1ASRvk
	XGljRrtJhvMSebnsOvg2fFSKDgQArUNT9Jfua1v6VVh9i0dlmazxnUt6mPZ1KS+EqEzu2eV2RTp
	xfW3vZ9Q=
X-Gm-Gg: AYBFou0asDesBZV3UivrxRstNTp5L+qlrVGw0+KiLu7HjNiJbijCgzMFtmeyTduXjN3
	xSfSVzZMy7WvHIl3HUGABCUneIAYUK6vqxIt+0POeqiuMlgbicsTADZLXYyfX9GXpBMa/98tgWl
	3mYzRC87VORqpXbSE4PZcFKDGQ/xm+MAjpc2vrG1X9968pu2yHuMVEZe92w3WGw23vewmJ2p5oz
	BCL4QI+deTY4RCaumLDPTeitZVPsUHq5/JGmfR9dvtmeIJbbBjnGJS0dN7aqO98TiTxhBVm9k5g
	VXsp1ImlTE4lc/LAQMjgkDkwm4y9XXF1PO0uW1P99hXyejY9OqFqXdL2lYFvzIIV9aKX/IhTKy5
	zEKUDoChRISpV4/8+N0kmNt1MGcxaOH85LwkTNF8TmfmoHv8fcpfhMxZnd+GSfS5WoXCWGByvYh
	+RJB4s8PJjjyQuJuHrVAmaRlP1WjHuXsjvDP5bapagGN/mv8wNMgxncn1U+P6aMHziDwgCtAmje
	Zkjogo7/BadEkljcvQKHClHM0U+OmY4SnDgCG42XaOOhx8CoItr494C6moZ
X-Received: by 2002:a05:620a:880a:b0:934:ab73:ac53 with SMTP id af79cd13be357-93c34573b4fmr67685585a.0.1790197848646;
        Wed, 23 Sep 2026 14:10:48 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c2485926esm305893085a.19.2026.09.23.14.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 14:10:48 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com,
	willy@infradead.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	david@kernel.org,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	Brendan Jackman <brendan.jackman@google.com>
Subject: [RFC PATCH 3/6] mm/page_alloc: add an alloc_flags-aware folio allocator
Date: Wed, 23 Sep 2026 17:10:37 -0400
Message-ID: <20260923211041.3127588-4-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923211041.3127588-1-gourry@gourry.net>
References: <20260923211041.3127588-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ut5po6a9htkudh5sr6up9oq6trt5s1bo
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7964D140008
X-HE-Tag: 1790197849-587903
X-HE-Meta: U2FsdGVkX18Pp9XmOkVOOLOxElcHFRgL3y0u8NqGi21Kfi37kbijcvwEfhnrKhKplGgucb7NngfBmkXrWm/JNN1U79piFRitJatgplP+ILSzFemlBo5fKzXZpcyh/sway7E7Ipk+AFfd9OYr7QFRi40kAtPqH8O0baNkCMrdu/zipI70kfZ5AWhrQrB79Q96n7u1e4Huas7ptHukK3v4CASw0CFCBaQwVC7WO+6dux3kUzhAm+Yy8bsbN6JofT77QRPllF0Mjly4nV7mCsLhmt9CoXGcw5eIA+/7uXltxM3uOggKCHARiiSnvQeY9bmcHvlBM+JofTgo19r0Z88M9toict+TSyYyGpFSwpygD9J1uqe6f9CQmJLOrAyehFwudZSOOQe88A6TOA4QVSnlJYjHDJKLQZ0FB1Jq3hdvy3NFOnnaqPqKVhUauEhsN1rK1DMYR/XGjdokEHfmHizKF9kq+KlWs93pP8qNwVcKw9vJB4Bpdrov2RGSD1j8KkobcFLSknzwPuSEswGvSKn6UW0sjYAQOMrPgVzhXNZomgQhSdG3aSZHQBUMlaHxhEbfZCaU1WNKdETxpd55TORM6fBuiCzLXq3e0C7dp07z0inaCQ7cKDihEQq69R6SYM4MYlQQNzNcBK6fYiwxUY8y773L0//Ip3N7IT5W7S2nuj9dYsJZeS3MsmasXA2nXFkuVwBR+e89W3YsK9K897tVEQLteLGPidZtIaBPff4VXWjUU9HILMBCL9jqXo4d1ErFfQx/bqXexFsC97R04mhAWefq9UGat9W4U55yOH0A8x0IzZGP7hYy+GnH3DnQ/rWZ/tbKuG/dwxrUGqo50h6PQNzWaA7ZYaOfL3fjVCOPHAWsxP8dRC537eCS6D5LWjZywBwoxUpH0mAN0IUFAdN8Elf1AaM3EYiFujUUZBhE6EINuCNyeVo4pL6tUJSW6Os1vqnZPuxWD0A2aBep6VD
 MsV8tWa0
 EAXXSekEXGdWiQYzkt93GQmxq6wJz+lXI4xugUda/7olFJCWZ3Bs3XrM4Dn9uzsYVOYW1oSFhYT/WDIhz/rws8s9FvgqpAJE9bn4jVz5OPZnPzhTch4T/dfYDPfjzdAYJzYFxZuWOMDYs3SrTcdAxMQoE669M8oDMw6GMaPUHchbjDH46HU3B6xmY2FNfEDQbJ35bwFU3rySUzUchpKnGSrh4IfZ2i4z3FT4p4Ohd+Ehih42mflpOKer3OcyfUIZeMEk3bec1fwdqaUDaytODEDmL3hxu6cXHJ13JH35TE49elv4MDnk2cChWowGuCTgzePlJCVAPTnr4z42yB+qNJZ3IdEwBlVyltfdU8076Isga0OqzR+HtkTWmmw0IMpwG4BUZthxu5T+8Nttk+r8t8M6es9m6Ld9cQzN/uYA31eQKKB4SQAqe89jVhP/erBNnlFDc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Brendan Jackman <brendan.jackman@google.com>

The low-level page allocator accepts explicit allocator behavior flags,
but the folio helper hard-codes ALLOC_DEFAULT.

Add an MM-internal folio allocator that accepts alloc_flags. Keep the
existing exported folio and node interfaces unchanged as ALLOC_DEFAULT
wrappers.

No functional change intended.

Signed-off-by: Brendan Jackman <brendan.jackman@google.com>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/page_alloc.c | 14 +++++++++++---
 mm/page_alloc.h |  6 ++++++
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b4a021fad183..feb9c64efd84 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5510,13 +5510,21 @@ struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order
 }
 EXPORT_SYMBOL(alloc_pages_node_noprof);
 
-struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
-		nodemask_t *nodemask)
+struct folio *__folio_alloc_flags_noprof(gfp_t gfp, unsigned int order,
+		int preferred_nid, nodemask_t *nodemask,
+		unsigned int alloc_flags)
 {
 	struct page *page = __alloc_pages_noprof(gfp | __GFP_COMP, order,
-					preferred_nid, nodemask, ALLOC_DEFAULT);
+					preferred_nid, nodemask, alloc_flags);
 	return page_rmappable_folio(page);
 }
+
+struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order,
+		int preferred_nid, nodemask_t *nodemask)
+{
+	return __folio_alloc_flags_noprof(gfp, order, preferred_nid, nodemask,
+					 ALLOC_DEFAULT);
+}
 EXPORT_SYMBOL(__folio_alloc_noprof);
 
 /*
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index b9259deddb59..986e733b586e 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -258,6 +258,12 @@ struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order, int preferred_n
 		nodemask_t *nodemask, unsigned int alloc_flags);
 #define __alloc_pages(...)			alloc_hooks(__alloc_pages_noprof(__VA_ARGS__))
 
+struct folio *__folio_alloc_flags_noprof(gfp_t gfp, unsigned int order,
+		int preferred_nid, nodemask_t *nodemask,
+		unsigned int alloc_flags);
+#define __folio_alloc_flags(...) \
+	alloc_hooks(__folio_alloc_flags_noprof(__VA_ARGS__))
+
 extern void zone_pcp_reset(struct zone *zone);
 extern void zone_pcp_disable(struct zone *zone);
 extern void zone_pcp_enable(struct zone *zone);
-- 
2.55.0


