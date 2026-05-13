Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AFDECD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:07:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88B276B0093; Wed, 13 May 2026 09:07:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83C046B0095; Wed, 13 May 2026 09:07:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 752226B0096; Wed, 13 May 2026 09:07:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 66F086B0093
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:07:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 161A31C05D7
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:07:58 +0000 (UTC)
X-FDA: 84762424236.01.BD85F83
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3A288180006
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:07:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HNBML+fv;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vB6yS1z5EFpHn1m3zCB1eARc99Wr/QTdVrJKUDK61SU=;
	b=78w1plgViZ/JzPRhdhVfOc9wEOHkT+Pw/vqDZmClTKpmguROXAiEmQnj6RLhhCUvsQGvbH
	OWTXTO2OYa4J0Xi2nCLo0vu9WUJRLsHXkEwdCYUNDLb+yi1+iLs2lfsvVRhtG0dKj1yUiV
	Ofs+oo3KVVR9ru6zhrosYm8OVtbU7t8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HNBML+fv;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677676; a=rsa-sha256;
	cv=none;
	b=rNSQTdePH2NDKYWN5gghphUiPl+J4VFYhv+YmIYvOg0stw+ZSFjQSPWhzSM67PT4zClimE
	FmWy8MamVZzrkd1AIaxlPOn87EBfXxsUSIgPOzcUU58ahgFI9iVJY8eCMehpPwDLwHpckP
	cROiqoimr9rsXgA3LAn0wTRyRthENcs=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2bcd3ac3307so19192375ad.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677675; x=1779282475; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vB6yS1z5EFpHn1m3zCB1eARc99Wr/QTdVrJKUDK61SU=;
        b=HNBML+fvuOrF9RlEL/sYUVRvwa0iyo9BcJHsC8gVdNoCT/ObkKquDpBNoVlTad+uAj
         xSKcmi2IHOGAZ80gX0vCumpXPbQSn595bIqHK1FgcvZAUTUopS13hERQXnh9XtL50LDj
         hpaVLfquhFP6rnpMSL4wqoWXPZ076WdDfuiCuZxKsuTWYpedlDEe50ICqT90TfZlM9pl
         aiMUmsRf1NNPif5eZk4ZrzV88SNOmUYfjNzhAqYxI24CU9AIA3cmwmlG/hOcTo1TH3Ld
         GgQ0JJtVs1Oufhzp/+GPwsi+jj9dZxMtPveXWQksKJwjkICIfknYeTF+JnSBs3Qi0iYt
         hbqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677675; x=1779282475;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vB6yS1z5EFpHn1m3zCB1eARc99Wr/QTdVrJKUDK61SU=;
        b=TSTFD/ipoEcYsqA5Xk2EY1Ab1VyWJ8l9y9PI1qGq1QqNDIg9bJzUSI2OBJG6e2LKR2
         OUT8c8oSzOEwxj/7U7p2xvXE2w8sLaqxxWxnw+h6Yqjx61WWJEK20v9AV6xiaV/Z9fZU
         3i8ProWkerXUBu352RyjfSPqSysIIk30zmhZSTmb7sWQhPewMY0CzCJSjZv6IeKeXVWR
         zic+Avt+naah/RuzEV0YMbFx0pdWpTHL+S2fi/A47aWHdbTscUkfo3JZfGV7OV6ap0e3
         9DpK9sEWYuHgdVowprJatS4Go/5T0P5yjxXIve1f48fjc2BMjqhWlgQuSIFaDSTH/tlM
         1WHQ==
X-Forwarded-Encrypted: i=1; AFNElJ+26o0hZ5K7NSdaPVN9eYKGNy+aHS4vkrDKnp16z1FkMpMv3eFAI0TnZ20jv1jhxTmGxH9YzPlVqg==@kvack.org
X-Gm-Message-State: AOJu0YwZk4OpVg6O09T7BE5goBwo/oChF8LRhxLiItHmRwCfAD+emGj8
	C5gtTAyOBk2KW6x4v6o8Oi+31RGP5RKw4bqwpVNPVYLeaUZOxnvSn8fdyy+/9rQJAtg=
X-Gm-Gg: Acq92OEIzrEPkxNl/mwk+a2NiQ0m9nRNOhQQbJYxZbiAWoSOse47mjIr3ipQ2pF7zRA
	GBwqrndF8LQNioPS7tNvZVLdlqDfULDr+JDm1p8IpykwfOVPDIJD1zvZ/c+cIydOVo6qHjGGva5
	d/Tz2CKKSwzUAjrDsW+sQBd7/heMHbgcljcJdYqxemGFiAofG7TV6bInMIYBCU3WgkFDZ8qdnEO
	xDq1+DZA4l4mZb0iSDoW6LF/8vKerPSAR13TW0IvVWW5MyFYWYXS9ntZpIXaiMyCAo8loNBAKNp
	NsaA2SR/2gzsXCxIlFck0QjncPMlX3azfnIa9lBrnspkl/IbDu7L/4hl+7cYA5xwJOz4BfzT/6k
	4YuUkCXY8KZxCQmuqWgrBLAfr1y6N358kwmXGf8OuGEb7gj22qFZbtQAlG3BH1v2UUK2Ld0KWi0
	qIiEHUC2da6EzNTxMJcht14t0PlFJ87Eut6Vz6Lh58iseBC/d+h/FvIdA0rzs=
X-Received: by 2002:a17:903:f8e:b0:2b2:ebed:7af5 with SMTP id d9443c01a7336-2bd271773f9mr36693205ad.13.1778677674866;
        Wed, 13 May 2026 06:07:54 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.07.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:07:54 -0700 (PDT)
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
Subject: [PATCH v2 04/69] mm/hugetlb: Initialize gigantic bootmem hugepage struct pages earlier
Date: Wed, 13 May 2026 21:04:32 +0800
Message-ID: <20260513130542.35604-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3A288180006
X-Stat-Signature: rg3f7wtk8jb3865jtjboj33s3gz61bzk
X-HE-Tag: 1778677675-425352
X-HE-Meta: U2FsdGVkX195oKDoS6nj7HEDsgp65H6n4JoM7cXAqfNir24FSO9a+yVn+vQqyDVORvYIA4mBfXo9s8i4ZoRiaQJHABqPGhLFahpaVyUq+D9BxCYOlzTpiSHx/4pbQrefl2kcQbTiwTZEB5AUdWv/PbJqMR+8n2vA/9zfj9egdiaFp4F93e9lB46yeYQmExY67KVgxEYclsSi5u0S0SE9DabXvp4y4PBv7GOWxC0WhAenNl7ZBEp5OZ8JGXuNdjHC1kTszdLbfG4LU37MSKKkJwDqHPg/h1MM4rQGdogXgDffKk9CG+aXdhiI+GXtaHXKl035I6LHbiDzKaDEMyzQ1IqwPdH5G2mWk8ZQhzZrleWImnopjOeRV1I4AfdZ+MZKBZ6jICU8jmDgHgeC2UN6ZwzOXsZGdVSOUa1PDF07iii7edgzP8mO25eJOYLO/gBbpS6ieLkUWtPJQyyLf97RX/jgkr009V9qebP6Y1O03Qyn6BH7JCCkzc0Tj+QxiGo/jFcVw5W0QFH3TVA71m4uCX+D+2G3VuBlfAAnIhHU6ZwEW6H6k3i6idauCXokZtUPbIxwfXaDRCheizEoGZZ8E4bXsKXPnmjAbW1xevy9b05s10feqt7XX/NyFG3wM00Q9yWNWs9ZFcYOtpC3TlRbklK/J5+FsO2HxVeyTswjG9W2NRifxcRWmvC0NV/xe0w7SQm1eSu518HT8dqx7iRhkIJk45nUKOu6cDL3F800cwZwpiAwfNzOX+ptOepdoaU6k/WJYSwYTQOzPgYtX3IeuzpP45+Nv+xhhVh0ycOULL6xKyX0emcS1oP+ePg1/sV+YPVPhrc/mpsZNHdKgTPLVje1OY9RESlPN+wsUy2wTjCvPu/7P/KyA3RNTw5oTQMM5hyojKcFOeHkRJ6c6ReM+iHqeE4/gLys+ta8xhwfbEuqJHfSDJeQ7U3pfrxkV7SxK6jX0j1/690SZbCjOnF
 th7XwfRu
 Zy94nmmsOYkRy6CH1ZKVYyphh2EdNyrBJaI2eLiz9y5VuvTLoHvnZCu0yXFfXnaUBLEuZaz3x5fLg1tnIjD27zvRI+15supVq4HTWsHeQkIJO8bf5ZAJ9FDqQ0IPhWM0kccJoCC9FhOYWRdLm0TQ4wAEFidGD5tYhEq0b8z+NJbWhxWm6jL0nT3OpEspDxIIGZ11Y17TWWVwbDlNI8TasK3xkCgJegKjBbsAsxMXApjOkCmcLUxI1T16EaNGri6swn56lPqEPKz7aduog8ua1qhGTv+fJ6Tp0BbPCSNn9kabUOD0n0dm35DvM9srdw+tVfV+RBgZRkH3ErgPsNdA/Iu2TUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gigantic bootmem HugeTLB pages are currently initialized from hugetlb_init(),
but page_alloc_init_late() runs earlier and walks pageblocks to determine
zone contiguity.

If a bootmem HugeTLB region is marked noinit, set_zone_contiguous() can
observe still-uninitialized struct pages through __pageblock_pfn_to_page().
This may not trigger an immediate failure, but it can make
set_zone_contiguous() compute the wrong zone contiguity state. If extra
poisoned-page checks are added in this path, such as PF_POISONED_CHECK()
in page_zone_id(), it can also trigger an early boot panic.

Initialize gigantic bootmem HugeTLB struct pages from page_alloc_init_late(),
before zone contiguity is evaluated, so later page allocator setup only
sees valid struct page state. This also makes the initialization order
more natural, as struct pages should be initialized before later code
inspects them.

Fixes: fde1c4ecf916 ("mm: hugetlb: skip initialization of gigantic tail struct pages if freed by HVO")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/hugetlb.h | 5 +++++
 mm/hugetlb.c            | 3 +--
 mm/mm_init.c            | 1 +
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 93418625d3c5..52a2c30f866c 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -173,6 +173,7 @@ extern int movable_gigantic_pages __read_mostly;
 extern int sysctl_hugetlb_shm_group __read_mostly;
 extern struct list_head huge_boot_pages[MAX_NUMNODES];
 
+void hugetlb_struct_page_init(void);
 void hugetlb_bootmem_alloc(void);
 extern nodemask_t hugetlb_bootmem_nodes;
 void hugetlb_bootmem_set_nodes(void);
@@ -1307,6 +1308,10 @@ static inline bool hugetlbfs_pagecache_present(
 static inline void hugetlb_bootmem_alloc(void)
 {
 }
+
+static inline void hugetlb_struct_page_init(void)
+{
+}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d22683ab30a1..b4999653a156 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3370,7 +3370,7 @@ static void __init gather_bootmem_prealloc_parallel(unsigned long start,
 		gather_bootmem_prealloc_node(nid);
 }
 
-static void __init gather_bootmem_prealloc(void)
+void __init hugetlb_struct_page_init(void)
 {
 	struct padata_mt_job job = {
 		.thread_fn	= gather_bootmem_prealloc_parallel,
@@ -4163,7 +4163,6 @@ static int __init hugetlb_init(void)
 	}
 
 	hugetlb_init_hstates();
-	gather_bootmem_prealloc();
 	report_hugepages();
 
 	hugetlb_sysfs_init();
diff --git a/mm/mm_init.c b/mm/mm_init.c
index fde49f7bba6c..5a910cc5534c 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2335,6 +2335,7 @@ void __init page_alloc_init_late(void)
 	/* Reinit limits that are based on free pages after the kernel is up */
 	files_maxfiles_init();
 #endif
+	hugetlb_struct_page_init();
 
 	/* Accounting of total+free memory is stable at this point. */
 	mem_init_print_info();
-- 
2.54.0


