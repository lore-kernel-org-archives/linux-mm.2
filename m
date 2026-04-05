Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1662BF3D5E0
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:55:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81B656B00B4; Sun,  5 Apr 2026 08:55:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CCCB6B00B6; Sun,  5 Apr 2026 08:55:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E22D6B00B7; Sun,  5 Apr 2026 08:55:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 60E9D6B00B4
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:55:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 243885C027
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:55:22 +0000 (UTC)
X-FDA: 84624498084.04.3A23755
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3F2F9180004
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:55:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ERoRlXUb;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VJ1CmGSdxm9qljCoiKFVSLrEpkjzI4pVEVcuHUoMZpY=;
	b=TbUzVeFIxjtUnhxWXvRhQXAVzsCLPsvwABJM3n3F+Jo81wHuYUsRglU5xZvJ4CQxjOF14x
	e2j75teUZUSfRb2HY9LNsY96XXesBGOfGf8vP+ohX6udh0KunOJjKfF38cMhp7W5n+Mz2F
	LpHySynprfQz3VCExdcUw4M7EneVt4k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ERoRlXUb;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393720; a=rsa-sha256;
	cv=none;
	b=QtKB9Pky3ShX1OoQAYS/lQ+Gdyfv1RTgRx8dVeF3jh6IKSbKQLucxPO+tPtImvUb8urpBl
	3ouLgIgKAVNzMDKHpHK/r3+KrtJ6RVTmN6v9DxNakQshGH6LrI8QABYj94hvDy1PDsK/BD
	WvRpOEHfdI6AIK7/uDKAoZNAc2Ghm+8=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-35da9692ec3so2875370a91.1
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393719; x=1775998519; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VJ1CmGSdxm9qljCoiKFVSLrEpkjzI4pVEVcuHUoMZpY=;
        b=ERoRlXUbBs7V0HjsR4H/ChPwwrXjn7mqHN/M9WKNFrfmps71TE+I60wObXOEY7wn4S
         eisEWUuxqA1TsRgrXT5EoUkbRVmbDOjZ5KByhbdMZLXR6KmJWTN9S90gJu4LhqOjq7Kt
         vlXmQk83pBtb8a4sdTJTkRyQhDJgGgD8aWBcfd3LPTuoH3Hql8ucHHMGsXSpkI4cdpoo
         l8+tFi6E1ItQnyn8LdkEMkBKQCWCo6oL12E+sIlvc94OCJSqPaExUupUh73HWfOsdZMs
         huDyUZ8t2zkAkJaZR36KUl28fSIoo+tawNMUreWxfCxPugiQiaIai8rYsygdqhEq3WY5
         lC2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393719; x=1775998519;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VJ1CmGSdxm9qljCoiKFVSLrEpkjzI4pVEVcuHUoMZpY=;
        b=Of7sxVGcx98wZk3SZ5O8U+qLIqH3hEvvDcZxpmThSXkcwV7XIVNNTCiWhSjpanw+jZ
         y4PVwPAgwwJP1BKKrvSdb+LOQSzYRntu3Ex/77c7xK/CE7pJegeXax6pZ97QO0juiS6p
         +3a9o3yD271vUMKMr/bFGQ4CmwdIxauGX/mppwowenaZ9epcZ0h73OVHn1KSPYPFVLJy
         I7ISPvrWJnkkXlp798MXch7JAh3Rc7uFfDGd/ngXfVaqUSjDfc7/6zxbqP/hGLPjoFb6
         qTeItj1jSOsMQYpSYrsEnjMIuRtW0vw1cuW43JfqY99VMqyfouM8N816rmw0lSxlezEv
         RAvg==
X-Forwarded-Encrypted: i=1; AJvYcCXo82D8SZBM2Ta7PXvSdj7OJCYo1XjimOso4LA977zgkP5rxDqFR33hNWFgeEUYYYPgo436vx4Oyw==@kvack.org
X-Gm-Message-State: AOJu0YwiAIoMvWLuJO+HNfcSSDMOy0+BbY7IzxVLSwkoN1zXxcVWTzTc
	d5WN7M0aYGHrdAAgcV7/jOUCgfKXXmTlHzVf2PSz4p99as9b3MawwcttqHRHoZvq6Wk=
X-Gm-Gg: AeBDiesWe/TQxcv3t3uX1hVCkRwyZfEZLmdcKhJ3A5BmfmZ+CDwggrQ/PRS2RMAhd7o
	Hjo6wqORNhnHHFuMj5ARMLtKIRiprC4VkwFynlpDb6T4peeWwOFTA1hOnFjBxVmC0BvvEKWO5Ey
	KOkrxBo2VdHxfXgyL9wzz/nQsxVh7NlpqrPcV8Xq+8X2vHL7L/y5Nr64NVXXtq5ErWRXlqP5Hhk
	6fN6YS/Uxz8seWXtNDjY7Psd206nl6WjBd1MfeQ2Ldx4OD1D+RRiI1AQP8ejHyIIL2/lHXZwunZ
	zN8M6XArqnzRG0erVp6vEzndJX9oyNE/JigFNMmg+RO7lIw+46o3ZmoH7L/wd8m+x2SSBlXs/MX
	Wfg73eAwlVATug32rhSmW0W29+tvoqTaKYdhDHERz2Wn+iX+la1OffAUd9U5QnNqriEqbOx35ef
	TOvreN11HxhBv7E3lNm8pvjT87ZmZtNGLVIl4WmqKxTac=
X-Received: by 2002:a17:90b:268a:b0:35b:8d89:7199 with SMTP id 98e67ed59e1d1-35de68ec6eemr8630177a91.15.1775393718992;
        Sun, 05 Apr 2026 05:55:18 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:55:18 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 18/49] mm/mm_init: make __init_page_from_nid() static
Date: Sun,  5 Apr 2026 20:52:09 +0800
Message-Id: <20260405125240.2558577-19-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F2F9180004
X-Stat-Signature: oqgywroc17x497ob84bkb93hb3uzne96
X-Rspamd-Server: rspam06
X-HE-Tag: 1775393720-696608
X-HE-Meta: U2FsdGVkX1/y/j0LnAmARNuOolYF2uxZl0ZAYpj3gTLrB/BTKtDGEtm3QTEO6ejb7w9zA6BKWOg0Vk1vBD6CJEh6yA9GYol8U+z7yMIFuFaVYObvi3TIQadWtfV96hg7whEQLtYx4batWwKZMFP1ZsyIo8VurOQag7LQ9N4uLEVJAaxucyA2a0Uac7iedwkni1Y2/u8SlKh6lm1jqZ/UHaUfTWJiSe6pO3GQJPxZ1YPcK4asblzAefoVlxJqlZmoGHuR9q1gqyIKaq4mD7OWt0siwUA54czJ+XE37AFGtkSb7zGhRO9mp68ouikoYvHMTnkGoEPfx/9c+vMbxb0qQbXL8l7cWyVcXwC56KPTYxhy2carEI7Eib6fmluOMwui6nAY6RaJbMTUiBV27xbLTIZkLKKKy0bFQpMiljk7+lmA72B3mQH5w3FTJnPKis5NW8DHgKOO0YnnPEDmrM5lz7GAsyvQpu+m5eXVLzRDBAMASd+U4VkpoSk6adL1VaJ9G/SYwL50zoJRHcKJUQEGjXLuXOA27WODRDS4wvWunqbV3stVykp9/7HNHSoBs4ScI/nnJkf+pkni+vZr4YlK4Uvmsi8qQbbD/b73OYVJtnTNntoYZ900RkggxxfgjAzPJS05GStxR2+JuRd6lf41f/jIRDqM4kcWn6tRCuDNOkZNI7+Hk8ISIvx6/m0KzEgwr4lcwhUKSiLyxkEVlMICCPqpAqzXYrbMVtEqMg0LEHmdVHKsAqKxxrK948aeAS3VE98Z8LeTEKsyk73U2sRZuBc+im+9s7hzoDAKFLSsq6waDpgVmvpCMxR8z8Wank+2T9fgfcWh2Pkmbkaaubc9Sq1xLScEu9TFLDu/fblut9hn9T93AiCCgSzHug2D4o/5Mx8Yo4P7yJwS8DlWLY5fOZRCcqMieqUlNBO8nMXUX4v50BrSWB4x2inMjiNHSJ3SZ1uHGsggDzR4TWORw9L
 +iphnLfC
 IPsQrRsYs9hAZOHuJ4jTrdnp1hBXoLvlWalgpSa3Fqaz5PbFunWeNR5m/isCEUp6yiJLBkP2UihRBcuQjkQlZA7n4ywa3NyupMzO3IZx5vFLIHTMwUQSr1hB28Bc9/PDR9eAdkrecXehOnjTlkKKDp7GFTBXGbvqBDQa80Fp8GNo27OAmTFAMOps/sEdvC6aSTHbZsXQBgt+r1+A1MWDrcuASH2V46VepUde9cfo8qGEr5dt7iR01qWXq/Ymmx/IB9BIf/bp2Xq4h90lWo0EPTcv5tQKcl6v5gEtMQ+7CjCBMNlejK8G3XiHSLaqAM6+phz6SoIQjQZFqaOIvz6esD6dK1+hTgsLUCfGOhckzQ+s8Pb4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since last commit removed the only external user of __init_page_from_nid(),
this function is now only used locally within mm/mm_init.c under the
CONFIG_DEFERRED_STRUCT_PAGE_INIT block.

Make __init_page_from_nid() static, move it inside the
CONFIG_DEFERRED_STRUCT_PAGE_INIT block to clean up the code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/internal.h | 1 -
 mm/mm_init.c  | 4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 8232084f0c5e..a8acabcd1d93 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1755,7 +1755,6 @@ static inline bool pte_needs_soft_dirty_wp(struct vm_area_struct *vma, pte_t pte
 
 void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid);
-void __meminit __init_page_from_nid(unsigned long pfn, int nid);
 
 /* shrinker related functions */
 unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 7a710fcbe3c8..977a837b7ef6 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -686,10 +686,11 @@ static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
 	}
 }
 
+#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 /*
  * Initialize a reserved page unconditionally, finding its zone first.
  */
-void __meminit __init_page_from_nid(unsigned long pfn, int nid)
+static void __meminit __init_page_from_nid(unsigned long pfn, int nid)
 {
 	pg_data_t *pgdat;
 	int zid;
@@ -709,7 +710,6 @@ void __meminit __init_page_from_nid(unsigned long pfn, int nid)
 				false);
 }
 
-#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 static inline void pgdat_set_deferred_range(pg_data_t *pgdat)
 {
 	pgdat->first_deferred_pfn = ULONG_MAX;
-- 
2.20.1


