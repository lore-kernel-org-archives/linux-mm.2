Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 354AE606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=lXDwZ0FE
Received: by kanga.kvack.org (Postfix)
	id 5AE1F6B05C4; Fri, 20 Nov 2026 05:10:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55DF06B05C5; Fri, 20 Nov 2026 05:10:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44D706B05C6; Fri, 20 Nov 2026 05:10:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1AD256B05C4
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:10:34 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B03E51C489C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:10:33 +0000 (UTC)
X-FDA: 85455077946.11.1D00E9A
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id D5982140003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:10:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=lXDwZ0FE;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795169431;
	b=in4a/tQy7R3HnKnpOzoGDQtePfbh4t6fqkR6inxgtyuann2FF4r0pAzYXR+19D/EqiI9yY
	YzAE1vIT5N7yTvqLmpju43CK5PGmdjFufcNxUu11W5hBvNrnodHeG/+Nyy4/fjmqQI8jT4
	gUNHYhJnhNxGWYtYVyZfTYajAWMf4fU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795169431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3h1F4bfrrG/5W0dnCqnhBL9+rOly79IhG+yujXIhJqY=;
	b=n+kZDQpyH6IAvzg4O4LmGgBITIXGYAM4oZ406F3z7OFWFrzBfoKea3h07/fsSn2eHbxgqb
	8UkvfsyAc53ebdIDsqnMQ3YuSQYaWIscc9n7MunkzFzuwPgbN6UuudXJZvLdVNawGKWKEy
	+nTU6LFF7S7QgbsXP7lCaXBDOdYhfmU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=lXDwZ0FE;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cde4b4e936fso1001688a12.1
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:10:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795169431; x=1795774231; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3h1F4bfrrG/5W0dnCqnhBL9+rOly79IhG+yujXIhJqY=;
        b=lXDwZ0FE5JX9sBYDOlgif8Ix1SdgDxbfgaMJwwFksy8DyBZDVzds6TMyv71g7RGv64
         CHuoj5vFBhe+EPXQTRhnPwkIRMnnWmBJD7RQSJrlmFofVuefgTAlFmvhLQB/dVdsoRAV
         w9hf0iQcJVaqyYTdp2TAIDx19tTNNoQiRbT69q+fO20IujbKQN3OrmqnG5KLWTH+WzcL
         h+r/S0CQybkVu9HzfAhYFT1w0LeUiMtroMpMCj+IKRq00kwbxUkctMEjaa4IugfB+agP
         xH3ZSybjGB80OzF3DIHTtGqCiEGdCy96ndJjYTX/v34QIHKLt4bJb/GqqmiJUAFwc83S
         gsOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795169431; x=1795774231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3h1F4bfrrG/5W0dnCqnhBL9+rOly79IhG+yujXIhJqY=;
        b=JH5/7xuI6srdd0YESlNvn1SgqEVzYJwJbICyTvskzu2/dLDHhJwrT3DeSN9ab+2CML
         /K3rvQdDW7Nd7Ok+Euh2wMWnyj1nBEgBZlwyMI8tsD/Tld4in3XWUiHzm1nSq26fiKcC
         CFcIp/8qs/klGXmOYmXncC7/eBmDSjjSAT+WjW3cRbucCsTcuqxEq3WCNuuNY3blNvtU
         T0vzrLf8G7LF2nB+wyYNuQRgsn+deptFwrEeH5e/88lL4TCf+LlxYzxInHc/eW6Dn4U5
         YBNk/MwnHz6MRH/n2hbr4Ve0exfM/AxDKOmiiYsqcFVBN7TE14ThhXbLaN1x+KsA08T3
         bgCQ==
X-Forwarded-Encrypted: i=1; AL+hErELsLWPDlCaJQROPIN9HSjUbmc5tEk5fpJ0x8v3WO7cC5+TczuUsromk8c1hOasjAfkYS1tqp6NFQ==@kvack.org
X-Gm-Message-State: APuU4Z/1cDXPbTw1WIM0+SWuXDgMraPhtyNSBG8npt/eLnp83wDnnxqx
	wb0sGiNIKXZsM4Ba0WOR2u5E5R7hDtAL1hiho3gFPkH/MP/08MA1ApSVJhMwZ1r/Tr4=
X-Gm-Gg: AZFdTZdTyM5GFrnkxt4o4Ipldyw4qSEna9X39XYwiHC11Hk8OnGkp8F/nlb7CxmVC6I
	WGQFf75AELpLldrykQSd91iqfrDbn2T6tdwuF36yJ7GqeFUmnD6zpLXIht5YiUCXTUFif1lHazq
	2gzURVeDo9O0I811KEQ18veAu1YGh3pRBdQ7QAU0mRTwDdqHQbfvDXcdJu2gv4PjkeRKiX50w7m
	MWpEaE7+qiyeD+2deVcId6SxbnuWhTpiELhd9bZEeBHcgGwomviW+WJUPGZXwCJ6ElVEMdUu+8m
	JS6CdPJl8ICGFdES7TF6l/7PotQPkYAnJtMwsNu/cuR6v8okaRCrBrRRo5wzE1yFBGjXNij7Bja
	43ZyB7OYGT9y77McqH4QKnx0JZPnopNYoeCdQ4B678QeQTaBGrzdBspnympjMLX5t4epreg26hv
	ZSVfsgXrGPnm4u+IgcQC6Sqpm8Ds9HxsecBCv1ta+7gH2KboTw4cRMXtMouPAuqAv0KbIBdXDjR
	qQHKWndKbyohMlyeeHpBkwuLBhyH+T88CYvZaA4ytpt8IcpJLBBuL+GH60eoqTr4bdvZc5wOF+c
	+kCKM0eeY9RTcAD5J9grESI5qYx3zKXVyWATFVW9bGreU/Wen/N6R0Vq0PedEazN6fGYKw==
X-Received: by 2002:a17:90b:3f0f:b0:3b0:9409:6969 with SMTP id 98e67ed59e1d1-3b41c90813cmr1787586a91.19.1795169430523;
        Fri, 20 Nov 2026 02:10:30 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([203.208.167.151])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41adcfe16sm3727321a91.17.2026.11.20.02.10.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Nov 2026 02:10:29 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: "Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Li Zhe <lizhe.67@bytedance.com>,
	Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 10/11] mm/cma: localize init_cma_pageblock() to cma.c
Date: Fri, 20 Nov 2026 18:08:55 +0800
Message-ID: <20261120100856.16929-11-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261120100856.16929-1-songmuchun@bytedance.com>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: 8ubkf6uenkxfr1by3kb1ngadh35bmb9p
X-Rspamd-Queue-Id: D5982140003
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795169431-126166
X-HE-Meta: U2FsdGVkX1+tAg5vMLieLECR0YnfFP577XhT7QEXyDGdooWKbWJ5eVMjojILWUlvZzUCGUHIrvXYSuoC9JpP8bic9SKU6PVB/HfHGQcRwETC3aipga7i5mlmCVgsLI6GI52+40g5d6lz+vqxBCt6tRhZ8IUTHyF9BymQ+3EYnzKhv/AM+oJO8E8wc3jk31B0sLaGKE5oHPLj8dBQREBuTEupVLBJChqMEjIaj4qqUDb6iOZR5OTthSEiF16efYaxgXSwry2Ze6zFD1fKUpHSWWXckkQh8ViyEQU3QnSB2xfOfOXsgPkSoeDHCpsgq8GB8PlQ+vfOwsnJa4DV0c3omz0vzk+/pCdomrmtxbBYEUiFk20UueRNMqU09wXiWINhDL1sUuuzKQbYWSYJWEYPfFNyQ3ySqoQWQkbVdgtBueBT4iBKTG5Umph14uBBp+1vRm0NnlhfJz60Gn9PIuV3Ei3GWC5x+MW6JnCclcnrXjYpmYyZNd4vqLbRK25FYmzz8A1HXKVeS9luX6u/ml7+DdsAEAkavGK/uTxD7+Kg1VABg9236po8xUTrBGGbsDYsVrzCtokS++XbpQt50K0YY/zKaj7cOan02c/PuDz/gISXMotwqo+ftG/3vTvsvXmpSHuD3FMRXiYugBgNE1PqChtFKZUPxq47ipr/dPYh83pnFNBF4xM9XEdbisymoPb+WPMiHCpKFOUjcBoFhpYnA8yEDDzaXUqFWdAjpqnmgCqAUjcmQBaAFmi7o+enHm9mtofWmoj4CE/Qw5mw+e9lOFfXR1Hdsin92r/cTd+I1JVvYcxnbtlseWJLmEuExDQOQAuoOV1Qf9ydT32YWp125sTQ/FodT1l+alENfRga4Xbg3lyL66VklbcqlZENUVJCKMhE2TBTwSIGdGzJJrLefRujL5cPm1KhrkUwsggV6WgMugvJ7NnLmxR6pfdtwhKfXMxOyVYtHkImdq5L8Zj
 uqFEnGZR
 oinFeKa4vKnbQMSCcPgX2X9nabnqlTcZ+zqj3gtTSwzf/SpRFP7wf9SpMcjcsQdw16wpeO1rMX6i+8DauEWIUyqZRVBonxXnTVtem0uw9QvI3P61eGMjLydCnlFDP/EpmWhLZyZFHfAjkrzddDxznRUAlK4vh272G+UJHYeNc/8MJI9WtWYd7qv35WgisEmIObYxAwNzCIM6Sa+VfDyp4EP2zj5XJN31JT6pUcVk42wSbiChC3MtBflzA3WI+isUecSF2Pq9MLtnxAx08V4iGUWd9hUMe7sbatq1ZsMDjACAI5D9CutZ0CauSfV4gBhfw77WQX7879DtvQNhIc6++/aUeMtbdLGQniDQqSfydigdA0FmVePV5Kp7lAaa9zHord6F7+zAzmp5SoPk7xdDl8NrRnUZn9FKWJVpKBcvAZCd3ydBU4voDaCcwwJpJSQdr5druSoYHG+nweDTnI+HiwGgqd+njq3BSb+5iw61Lk8CTQJ532ts4g9iPkY7t1RtntaMh2akV3db6zl/WbRT6a40d7Pepgo29UrRqgOWWCctxxK1BZKgD0h4pG6E4RMGnguL7QX94e2L2KVCIgUjVWTFZqknNWPPkCgX6XyO5WkY0HtLmS14vPuiwXg==
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
index 3e4366213b49..0c97aadcfea4 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -31,6 +31,7 @@
 #include <linux/kmemleak.h>
 #include <linux/hugetlb.h>
 #include <trace/events/cma.h>
+#include <linux/page-isolation.h>
 
 #include "internal.h"
 #include "cma.h"
@@ -149,6 +150,13 @@ bool cma_validate_zones(struct cma *cma)
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
index a427477483d0..e0686b87fdb1 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2202,15 +2202,6 @@ void __init init_cma_reserved_pageblock(struct page *page)
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
index c03413a090eb..9ee9bcb8e672 100644
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


