Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2800E606A8BF
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=USayNb4O
Received: by kanga.kvack.org (Postfix)
	id 39F696B067A; Thu, 12 Nov 2026 22:36:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3776E6B067B; Thu, 12 Nov 2026 22:36:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28CB36B067C; Thu, 12 Nov 2026 22:36:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E804D6B067A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:36:21 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 76F8414045C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:36:21 +0000 (UTC)
X-FDA: 85428682962.21.65A8599
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id A79CF120004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:36:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=USayNb4O;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794540979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJ+IqbvwnkZ7lgF5M/SYmtKGJnK0HFHx42IVNot2lew=;
	b=Ucz1OyYBxIKG20V866hZG8rKnjr5Am2cXmIzBQopRZC9kMm4/2/NL3SlAy1yuok575qn+8
	rJ79wMEfLKzMGxmxqMkaj9Or/XvsuvZ4WYRiTgooBqqGDu59oS79ymmkkfUxOoO6QAP9Um
	1ByNNhcE6TAwf9JWw+kxHrcgnMKxGUc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794540979;
	b=P/3IZEJ9DMTxJWJx5jyaWSwDBpalqPtzwx1lRzW17m/ARq5Lk7+AgbzVsll1xLkY6I8JHM
	SG9oRvy4IzIPVQWaczW+mWXlYop0t0InPMen81+dRvQOo7Lx5HZ0fcKpHlic9RaCTCqi+r
	TEopgsEADlx1Gr9VXpLQxE8IqzgnzV4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=USayNb4O;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cdb2dfcca94so323563a12.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:36:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794540978; x=1795145778; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GJ+IqbvwnkZ7lgF5M/SYmtKGJnK0HFHx42IVNot2lew=;
        b=USayNb4OT6rigLjUOAvxoxMneYCiFIDFBbFgjbzSBTWrp6VEa2zv9yGoGTUgO6F+AR
         hZNfM0pJep4pl1FktgtBIVuA1UEDKpUhp8Rld+TX54X1Invi/4IlNUGnD+51fwu6Exu5
         IeXje18xbcrO97j0n6ztlvvBLx5TQGDok0C3XXmumCtrjvZ+XY217IKpj2K4Peghl3J3
         8nk9p7k7iYQiVY7XUmEDVgv4Vz+uIUX8kZbg8vha14kaocIkDXuf4pHaL762VvyhRlcF
         XH5bIKeNyp7qKLQeZZAqRx2soLlkVVGpXZVUOId8Gp9CVT1KrlnE35S9cnzsSUGLgvY+
         u59g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794540978; x=1795145778;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GJ+IqbvwnkZ7lgF5M/SYmtKGJnK0HFHx42IVNot2lew=;
        b=1+gNXkUIAo3hb9vSudNvd5mGH6UOscZ82VfwOPSeown9fcrumrIz/gVKfrnt/L0Hkk
         NiToNJZ7Exkl3nNlanj3h/J0DsBX1lSw0zaiwQYUyZ9G/OgWrowh5giMpnXhv8A3Q7yr
         TGMdfG+TdTrjyB0kWqJFijLw0XRKiMDglmitX1njU4ri7RGsVjFG2YHwAoPztTOI2YrI
         YjsTuTdMK29jQWWxadqHyBM6Oj3t+9W/WfczFNUWpdYr5tTlcw12jWx8P039DBHXUvxf
         WhJrJEXPFfbWI9/tJZnhrzMiCOb3G674baSHNJs5QHKbsrEirbFeGY+9eTkj4Q7Hb4do
         Z99w==
X-Forwarded-Encrypted: i=1; AL+hErEvoYwlFUd6BqiULCGKaSYw2lPEQGtRcCwoVfBR96+51m/8Cqijen9+WLKLrA1MbIdYKJex29s7RQ==@kvack.org
X-Gm-Message-State: APuU4Z8jXW36T6mNp0LwFFAxanZWXPRGMiEFD/gx9DRfHHqZsXo/kEk+
	6FNrC2bJghvWXUfH0E5DW1FNdZk1rzlCNSq1QzvtEDzxES3xD1bIyp+xPoJy3qmw7L8=
X-Gm-Gg: AYBFou16KiwRIpdqE0dpeWlnnPW0ZKhuPHXQQvBjexmzktcsUN5VuEVlqEKYtFI1sQS
	75TFgirkiBH0f/Rv/pbhrWUwL+blH3rnSYC+H/m7ShOkS/Q2/zdj8arY/qTdfX9fk58wf3TuI0f
	SKDhCm7mn3pDw/8Hyk6UWyUtI7yikem0d/pMYE6U1Gy/FgWbFSKPsyn1vYLwwsd+TDBxU5Yy4cd
	zf2fO63aP40lTSC+oWYDuo2wi2fBPoEBGsFUZ3nUgP0vckpvq+v6jCGBl9kYhK8d060V8dMvFX/
	/DN79tbLzneZc3AfEyOpNFKCQdgHArV/j3IaFb719QkWRt+6I/+Jm+uvihKdd3xXSpGBwUQKprX
	8ho2xBq4lJtfMdM0ZtqHeI7fFzsR+TC68dlHDpX1FZc+bo4bAsbW8DvQRK0Wog5ZYC9OnRjkMIW
	venIzJDTzOWbloaafSaysc7N9/udc3jPibDLsUzsFBjg1u5dCpF0db5M11AnJR30zUQcQ8PwFU5
	s5qKH91FAqLyKl6zCHfxtNMrhFyEQGn/PtmIKNrnCAnOHHJBcLoBuZxzXobt5FdSvwTu5TBtrge
	HpeVae2Kr7ZIX2EJ8uUluYk2iPIE+YyGONfiWR1iSfZSPp/Jm1w1hDbkkIqPbA==
X-Received: by 2002:a05:7301:1625:b0:36c:9f1a:30b8 with SMTP id 5a478bee46e88-37966c4a5fbmr1089440eec.31.1794540977804;
        Thu, 12 Nov 2026 19:36:17 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.12])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37955e0d966sm2959426eec.15.2026.11.12.19.36.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 19:36:17 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: Li Zhe <lizhe.67@bytedance.com>,
	Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 13/14] mm/cma: localize init_cma_pageblock() to cma.c
Date: Fri, 13 Nov 2026 11:34:41 +0800
Message-ID: <20261113033442.62970-14-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261113033442.62970-1-songmuchun@bytedance.com>
References: <20261113033442.62970-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 858isc9zouet3wkdugza56ahyssewacw
X-Rspamd-Queue-Id: A79CF120004
X-Rspam-User: 
X-HE-Tag: 1794540979-895767
X-HE-Meta: U2FsdGVkX181lWkzMTNW1Wj0OPDE01nQCByUQwoplx23UgMDNE2O6y2LEqWMxdAF1TwFZBr1DpN0WcYaXodCgvaD6pB7KwxFipL0BBaAW9LxTPKUr79JkYXUnT6TPJcXu+XE5oHFX3rylol1GMsWwpfM/mMRkE+wzPbyIMNVnclNMPfd93ybNKyLvVbaHCE154tAbUVOKWNgD6UlZyfXPwcwJK34Gf6u5+kr5tpGfSUAy3xoDqM9ERHOXGKHcaxpeMsMJk+jgb8RQOh4tuzUv9Z1h22NE0acjqq5/HLWQntppL6ODPufGDHtY1VzgaGO4p2gKQD51y5Bgxr64WXAlqCjMWaFysNhMWa943VaqL5kbwtXb0qgE6w2E2AxQK/WvieL9mLMXC2HaJEi2n6CrbAqV/ULinydd8zvSEFFggq1ZBJ496lFd5lDKEvg17TRrRMCiED1ey/zzX88WCsxBASg6i0IFHLdy8MGgo/NrWRYyvqPlNoQ+U51wVXTE7ccpZbQEsgPiZddo4G4ncfNj2rCrZYHsdkDJfn+H0XfHBf2+9FHcVxwScLDDR1mYi+3S/WSfyIY/pXZMg1tI/vM7+BjNwpFbWBvucAlWWUGH8WFPjpRVO2BcAizgrSZf4nyixF+uWOPK6mU1/OepnjTyrDJGJcmMQWF0c79gnKUI+7tsYCj2F81WDx2JnaCvSaXY3IXP5iDYLBXXBa2qqJzAwpd/WtXgH34+N5L8C6qb+Q8C+7QxkxzR1M2yf+Q5jvf+Ms7MHu2wGEqVVtXUfDG6KcTQaxjy9fNiRpAGYzjt6P9JAEM9DCii4KrdcvWwerPywNeeNDHTrpXWD3rRZahXc3TDJbCWo8c3njFggCLOPh1uioqFySMoB5C3G7wM8q6mVCj7WQXIu+TkccyUx9Q5bU1KgC9FjwOjQdYIo9Wp0nzLRUDqp8flXZhvXEBHGXS9xhm/k1RHXSwAZaTqJd
 a8iHGp6Z
 9bjIkDse7L1LP1a+c/H72bcO1UFYPOvDdf3F7/O6oGOl2t3kWLaZVFqpD/cGi3EzVKksA2cDXPSpg1GqwNFQDEoyhvHcaDdLGNguSfCUajmrfjAFHtdk+aGl3QbxpVR4TeXLL46sh3kKIbA3Uduf0pjL031jDbug6AcgO9edJQp0MuQgWgYxx0VZuLRgnmmDCa5j9lX9wmm9FqVkUpyuAlOLQPnbfsoWZ3MaIFWK/S57SZvez6Ygf/TmlFRh30c6PAra40gbplXcrsyKnaQq6Pwnn0NZ1qDCbdwSmxQeWIsPBfh2IrwAat8brDlrto2Lx4tH5SXVTSDezlKTXsNLIbmH3C1NdqnfO9xhSDH1x/qUGVDmZ/kIDbb41kfsrb2cpeSQ5Q/QOBCapZkk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move init_cma_pageblock() from mm_init.c into cma.c so it lives
alongside the CMA code that uses it.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/cma.c     | 8 ++++++++
 mm/mm_init.c | 9 ---------
 mm/mm_init.h | 8 --------
 3 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index 46e72734ba72..7ca0e100504d 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -30,6 +30,7 @@
 #include <linux/io.h>
 #include <linux/kmemleak.h>
 #include <trace/events/cma.h>
+#include <linux/page-isolation.h>
 
 #include "internal.h"
 #include "cma.h"
@@ -138,6 +139,13 @@ bool cma_validate_zones(struct cma *cma)
 	return true;
 }
 
+static void __init init_cma_pageblock(struct page *page)
+{
+	init_pageblock_migratetype(page, MIGRATE_CMA, false);
+	adjust_managed_page_count(page, pageblock_nr_pages);
+	page_zone(page)->cma_pages += pageblock_nr_pages;
+}
+
 static void __init cma_activate_area(struct cma *cma)
 {
 	unsigned long pfn, end_pfn, early_pfn[CMA_MAX_RANGES];
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 6bf25d03902d..9a51cecee547 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2211,15 +2211,6 @@ void __init init_cma_reserved_pageblock(struct page *page)
 	adjust_managed_page_count(page, pageblock_nr_pages);
 	page_zone(page)->cma_pages += pageblock_nr_pages;
 }
-/*
- * Similar to above, but only set the migrate type and stats.
- */
-void __init init_cma_pageblock(struct page *page)
-{
-	init_pageblock_migratetype(page, MIGRATE_CMA, false);
-	adjust_managed_page_count(page, pageblock_nr_pages);
-	page_zone(page)->cma_pages += pageblock_nr_pages;
-}
 #endif
 
 /*
diff --git a/mm/mm_init.h b/mm/mm_init.h
index 7cde357d6324..1723db7e54cc 100644
--- a/mm/mm_init.h
+++ b/mm/mm_init.h
@@ -40,14 +40,6 @@ struct zone *pfn_to_zone(unsigned long pfn, int nid);
 void init_cma_reserved_pageblock(struct page *page);
 #endif
 
-#ifdef CONFIG_CMA
-void init_cma_pageblock(struct page *page);
-#else
-static inline void init_cma_pageblock(struct page *page)
-{
-}
-#endif
-
 /* Memory initialisation debug and verification */
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 DECLARE_STATIC_KEY_TRUE(deferred_pages);
-- 
2.54.0


