Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A31ACD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:09:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 113B46B00B9; Wed, 13 May 2026 09:09:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EBBA6B00BB; Wed, 13 May 2026 09:09:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1C976B00BC; Wed, 13 May 2026 09:09:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB20D6B00B9
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:09:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A71A0120B75
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:09:20 +0000 (UTC)
X-FDA: 84762427680.01.AF99573
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf20.hostedemail.com (Postfix) with ESMTP id DD2C71C0004
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:09:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PTCbxIqg;
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Fut968wGN1n7g7zLkJRGy6a00PEkBTyJzeVX+ErWGA=;
	b=cBNQDNUsAZLPmRvmyszV3Q9Zq2mzqBGw4JQqBhpvkrfJyqk03UF44RKLx0c4hQFZPdzj0Q
	Wnk6LFXefTUBw3LDW5TA0pwfOWlkU/E8ztD/nVNN8LAkyiGZjCHDJ52lLuzuDlDsuGzvHu
	fU95kxd9c3eRKTocPrHFKNI1Donwnh8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PTCbxIqg;
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677758; a=rsa-sha256;
	cv=none;
	b=jrikOoIF00byJQv5AgDR8ZjvN0qNqMwYB67stWmyE6opOvPC26HYPUZWpZNcdJOh6xUmqk
	qNEj8zBNzIoB4pmJ2VXxzuJRl0CMMzw64VLza92SUAdGvIS47uAAv03Wkj+LPRytWFetlc
	9rSY2sj3yRb62az8fSfCHjK+waOjkCA=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2bcd730e090so24800785ad.2
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677758; x=1779282558; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Fut968wGN1n7g7zLkJRGy6a00PEkBTyJzeVX+ErWGA=;
        b=PTCbxIqggJ7rw6/SITpZpZoFGk3YuoO2VTip/99PUKCboO9pKoEjsQo16jy3PYs5Hg
         4wU080DKCPb84UiaJoOOUH7lGg79YctubHG3IbxyEeT/O7P4LCtLYTNE2QQx1mbzg2ny
         6b4gLKShciliJrl9VN8oQ0/49SwZjOgjFONzIBM4AIT8w1yWVP0nxtHhYNJTpg8tpZ0i
         rLiunLB8uJa9YjQVPUe6xlT7d9wrYRTbmQaoFnvSngQKAi/RnTb+CUsKWdF/LFIPRP84
         gJyjRxPHcJvpuvStwfo+izYJPDoPM1AOAiEsjCQcYP/PuIrX8cjkXwM0V+UDOGMCoW6u
         iOqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677758; x=1779282558;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4Fut968wGN1n7g7zLkJRGy6a00PEkBTyJzeVX+ErWGA=;
        b=KISUM7Uw+uKQ4QBqnamyzQWyLbA87LQliq8tmMZOOyr4E/j+vG4RekMXCKel5a4DjH
         VvnQ81C5J6uMLxqFWeO43erTKxVZBtjWazWK7OyBcW2RipuOPg4Me+85IUZadmlcSmAm
         qUwF04i0Uj/yKNOeqQVuaPs596KAET4EllWkd0onS9TH4ACIgl7i08OgYggJQJExycyF
         n0bEbaL+jD4gKywnia7I7uHViWZFoxHD13wgUgv/6pnqEDeuryrUmo+CLcp0crxPhnY7
         fAaNqy/PM6/Fyk6FqTZp+HrGG/9QNASVrkkGrWa+8Hs1Su+tAzd5qO5T2G9c6/0ZapI2
         F/8A==
X-Forwarded-Encrypted: i=1; AFNElJ+lS9M0K7308ZC5aNtfKLn+RzciLZJpwaqU35vJkT2Lq2O3q+mhmwfjKUN8hL5GQ8J2VlfWow4RxQ==@kvack.org
X-Gm-Message-State: AOJu0Yz+jMlJ7zQQOZ5Pa+9QISXKyhSax+r/nAHHlPqtv+K+jdM0p3wf
	06071fVtuBKIj3EwC3KtPf+eoJLgL5KkfS7mZQ9yytDOp6vVU8tvxZ0qRnVz/xzYlAw=
X-Gm-Gg: Acq92OFseM3zKfOTHbXDJLOl75WwoHfK7LgF1Wzog9rK/rd/mbY8mX3MeKnvHUTEOcF
	Y5yIlF2OecSPHBq7u0UCW30PsGTcYXF2Lhxt3bDn0A/eShMdchtT2eUQDCE90mJUt7og2p19+AO
	FttJlBj/VSq5J8jEyhhsTjykpS+s5I+fa/Sdk5IjO9GEd+FiR0RNkZtang6ohRqyk3Q4K4pFRwE
	SxYHSjSJqtkPemhq62EujPKy/Y4vxlo1CkmCBhr2gh2J8KLKCpWOHcHNW3v96oJMm9d+ZB+Lb+T
	Wn454wpHAiqEKpXZnra8NIL0Wj4HtzVzJ/L8QuVKCf3DkOhsFkc6U6zCNuHCkQSU8OmCJKQjkei
	ua7vbOyPeW/IgjaDhUpDRZoFlazWwDNeSBX1XFDPzA1YP4MJMw6Mkx/i6BMaJ2cRw7QuyURYNx2
	W0vw0Cf/JUlsQnsmVSNBnTGLmgu/J0qaVOBnJyX8udcaubSVxljoAjmKM5eVk=
X-Received: by 2002:a17:903:bcb:b0:2b9:cd2d:6f14 with SMTP id d9443c01a7336-2bd2f4f740fmr22553475ad.2.1778677757605;
        Wed, 13 May 2026 06:09:17 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.09.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:09:17 -0700 (PDT)
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
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 19/69] mm/mm_init: Make __init_page_from_nid() static
Date: Wed, 13 May 2026 21:04:47 +0800
Message-ID: <20260513130542.35604-20-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DD2C71C0004
X-Stat-Signature: euaqa3f8c568oe4hae58u43mq5mjxwiw
X-HE-Tag: 1778677758-292665
X-HE-Meta: U2FsdGVkX19YI2pKl3UjaafiLQM/6yCLrEjD60Xw22visUmOKRROaUrSJkB389uhZaRZAhRE9z0Ov/9UM82YdaiF59WgAG8vykvFXoGk/5bOSLJ3goAcSELgPxkzGKy9fAV8AEMNJL9N9FypoDTr9GX7W4AGcJ5NYFCXHf0cKAJQVsbO/54q/tHcPEI6X2raRdvVWnvMo95vdgzACHoIdeAFrDSkDFQchlVG8pYmMTYG78ruQ089YE5Jx4rJWNY5R4kCTLls/wWwSlQbFQFk/2X24VKl0ky2hxju075yOoOLigvLAm+eTGLJmLsnWKptE6Hc2Ta19lkZhdqcDOzZcelZGbD8fFZq9vUCAxL7d2ust2rxAY98Pf+LxHd6M/Q8dNrgLy/gRN6f0pAgBgwf0xPw4l8tL04Id7TB7eAqnoq4VubOl94nEqca9mJWb9ii6F3kIMQrbfyXX2nQf87fxMRan7cC3oYWdUtvEq/U8OcxhDFqtlWNUJarD1brApYB4gNVa2KetHi58UpHmJF+xl/tFUYSGMGiLVijrSf+t3ksEKFPJTRY88nzR/ZjLW/poyDxLpr0Iw68QzH7UHl6t0Yr5sPTfe6z2fltisu+MsHfOUMQhJLCQ0yeQyH+vGRwGUt7csX04pSF+DUghSgf+LuleG97+bQAppTy6bLixZdq/z8m9LwVuOWQAWdQu6UBPrnrDRbZ5e4DWwTYDtz5N3xQPsDnnzAT15iaL9/+YRCFSzqSiJZjgV9J7ZxwRKndwlwfIcXP6SJWqTQq5UrNsIVrReBiWn2rz+vsXra4FdbA0bUuYOuBN6ONuHRgNodAcn08aOb/0LHkCmmlCT0A0fvGIcVYBg6AnZ3bDi1s7wofGEhQ2dm0uDiLJdbXPh9EviaJtmsMtBj5Y9Zt6Ih4NetIgDkOf1pyoC0AEiXScxbCsRu77gPQk2TYAhyX9H4Mp/1VXNlaQJBUHqxm9F5
 /fMpw3FR
 Gi86ZaB9ptN7N2trj54/ymvgFY7i8ZhuQgrL7nUYIfOaMm2Ata7sX/WrJJNztikwz58VBCZhsTyjvF8mEyJh9QlhbgMJb/jL7nvoWuI5rdgP8vHMD5BqazFwWb+aRSZBrTVpYwVEb1mlGfDKVi+zsJECwJvdCVo+AM6C0AiFL5JtzNWOVEqbzACt0P7mtROnV9Hd4tcfJuBnqki7OsLRuR6eOVrxjHKMc0f92KMlGtDes3O35eRjD3EMoVlcxrx8/sMzovnQTmvH+Dj2YggKcyXoYciYCGfM5TCSAUtJirrDFnwgw5LSAUkVb0Fan/0p5EUG2I6W4pkMLl8mWijCVSm3o8EaCPfwqTpocKQVa95OvccM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__init_page_from_nid() no longer has external users and is only used
locally in mm/mm_init.c under CONFIG_DEFERRED_STRUCT_PAGE_INIT.

Make it static and keep it inside that block.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/internal.h | 1 -
 mm/mm_init.c  | 4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 6bd9aa37b952..4a5053368078 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1754,7 +1754,6 @@ static inline bool pte_needs_soft_dirty_wp(struct vm_area_struct *vma, pte_t pte
 
 void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid);
-void __meminit __init_page_from_nid(unsigned long pfn, int nid);
 
 /* shrinker related functions */
 unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 165b83c9a9c3..c64e5d63c4ae 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -688,10 +688,11 @@ static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
 }
 #endif
 
+#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 /*
  * Initialize a reserved page unconditionally, finding its zone first.
  */
-void __meminit __init_page_from_nid(unsigned long pfn, int nid)
+static void __meminit __init_page_from_nid(unsigned long pfn, int nid)
 {
 	pg_data_t *pgdat;
 	int zid;
@@ -713,7 +714,6 @@ void __meminit __init_page_from_nid(unsigned long pfn, int nid)
 	}
 }
 
-#ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 static inline void pgdat_set_deferred_range(pg_data_t *pgdat)
 {
 	pgdat->first_deferred_pfn = ULONG_MAX;
-- 
2.54.0


