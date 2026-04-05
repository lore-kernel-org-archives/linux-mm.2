Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36274F3D5E1
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:54:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C82F6B00A8; Sun,  5 Apr 2026 08:54:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9789F6B00AA; Sun,  5 Apr 2026 08:54:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88F5D6B00AB; Sun,  5 Apr 2026 08:54:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7BF476B00A8
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:54:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 50113160A2B
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:54:45 +0000 (UTC)
X-FDA: 84624496530.15.9A6A345
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf17.hostedemail.com (Postfix) with ESMTP id 707C740003
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:54:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Z0M6+izX;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CpeyP/gKGQ3cmNpd3odA7JDcSLupYRRYiiUQtcwUonQ=;
	b=lFOvUmzTzoh0O9Om/lDxdtSfNwmmm+MvQAYiQzlMAsYKeqr6TsqirW1G/KMxealTDPwTsA
	dbmeWPovv0xWepxt3rJJoxBno8vL8EqY4yrFAZ3Mje6PkvN5qcn54M1MUJYMP/Ab70OpMs
	tOAdP8/6BTGZYLP8yvG8EZ7kgAm1rfA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Z0M6+izX;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393683; a=rsa-sha256;
	cv=none;
	b=33AzwV1KeMQrkAnPNP+waS1HX+eNpWFUrmtJT+Eo4fEj3MyUXR5ymaT6KjDtDU5ntx9n1c
	/HgfysDSqN6xVRqnygNdxkiRx9IYkCtcEJ8O57fRI05n6doiquwhDf6EwJ7sGcYleviCX5
	arJaWauFaK9ASxKBzn8Fdd4ePbK9O/4=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-35da9692ec3so2875097a91.1
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393682; x=1775998482; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CpeyP/gKGQ3cmNpd3odA7JDcSLupYRRYiiUQtcwUonQ=;
        b=Z0M6+izX7dK3lKT/D7whx+qKv8nqywg6JlQmGHToTOOJDv9Z7VIaAsN1CIwEwV351p
         mdyW/Y+Cc3TtU98OXCtBXOMehKYDzHtWFwKNfKlOFk3AtHrJkY6HPqYbpYLw3M3/jdRp
         vJMHwkZkV1qHVR9IhjpJu/HUiYHrEcF3GyRMQwuZOQ2Q1hQZVJJcbB0LCzemn7wNTYcJ
         uDI9B5/+LJJlyh/I8e0UGcC7zjZwSzbEvXgIki7hwwTGjye3l/GXya9X5ngiqf0ZTC+0
         T7qhln3tfLEaIJOnZ3+jmnVfTzQX/5u9RAdfuSVIpgpjarr5Zzss/B6IQzH5LdnDRxdM
         nydQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393682; x=1775998482;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CpeyP/gKGQ3cmNpd3odA7JDcSLupYRRYiiUQtcwUonQ=;
        b=m5z6Le/8WXsRcn2t1iD53tTwL70VT8EUcqHxeH8sJ7NEnCCM7SPuNPL+qza44e0MS0
         TdRuMFJqDcxTR8zywphGaEkwPervnJo4XvHAtB+LBATQAdbYI9bkj1704mn0I9vXLlXL
         bKarxFdETGnjiEFEP3aWg7xUJZW9zXSHlj7FRgqcARX6vdM5lgcinYydHH++8i/8HCb0
         vU+T5QACHuJ2c/pm1zzkVOlyY5WYT/cyUeCItaRaavEE7LWN6CY4KRT1cF9lBjSmI7Pt
         NB2ENpAYWaqJmp3CPH3XXcCNnPD4iTiSx2d24ihCpQMmjrCTdceGwITnuhJR+x/zGSFL
         S2fg==
X-Forwarded-Encrypted: i=1; AJvYcCWGY/2pcdhF+F24ZjsVnMEeRF9aGgxYY5b6NoUpk8ETvVmum6kg1mZr6aRNjCTqc9T1xH+UI5tU8A==@kvack.org
X-Gm-Message-State: AOJu0YxWsxD2PKWbBjfYGpXjs6429H0E5LBXojCWzqL/n+ejp5K1k9ZP
	gHqfDxTMVJ8JrRDg1aRM1aVyOrdDRK8UbGo6Hz1uHwM8gjbNbJC/ru93GjM8Urg+ddE=
X-Gm-Gg: AeBDiesPP+kAWYMLPfQklnC+pck6tJc8+TNJZBHPgHNlImoduShyMh7lmGwJcsh1hQo
	SOG3B/d40huEAx1B6gQkZjcP8D/U3NOFRBBwz1r8NTZJLbey1kmUOZxtdd1Y5LAP8mEskRY4WvP
	Rll/cTVqje5+kHs3w53P4QQXBXHmVb0pTpu/MEamxtDfwgCnwoYXoQRhufsEKL/sPVXQ6JDCleV
	WqU+bmM4E8WD9SYIrhUlZO4vUd1Ru7BqCoyXtpxK2qp4frflH7JIwKIFAutTtKtcb0MAMjrDOVU
	Y2UCfschabZ2W+31j9YmeAvLNe5jZlBN7Oavyt821Hfj8JsmyLqaJSng1HQRmK/f1DKTA1PUan/
	q9p3Y7Rfxlq9eRSMK66Giy2+PKdYr/S3sjZb1Jm8ninwkNyMZoDwAdTtWs7AUIvxPWDjEoe80L+
	XuD324ronaxQLucEaiuH9Uk2SLAPWvxfIwjlVYLtQEQ3g=
X-Received: by 2002:a17:90b:5583:b0:35c:d98:d684 with SMTP id 98e67ed59e1d1-35de67da865mr8258899a91.6.1775393682300;
        Sun, 05 Apr 2026 05:54:42 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:54:41 -0700 (PDT)
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
Subject: [PATCH 12/49] mm: make set_pageblock_order() static
Date: Sun,  5 Apr 2026 20:52:03 +0800
Message-Id: <20260405125240.2558577-13-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 707C740003
X-Stat-Signature: aqxctu9oswdodhbcomrhwhtmersttkuu
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775393683-47046
X-HE-Meta: U2FsdGVkX1/qmcxhdOHFKKaUdgYidtWiHbHfI6zSs7Qfsl4JA7yQry7gOQdkF6xhatbjx+KNF/HrZGoSZmHQZs4XSACjSOmmuV26eZhflQUBqBbOxRKgyxM4quNI3VTmSAy6/VknMEwDJGO7HrIsPGgi05gOpJSGgrcemnV/AZ8//7VTIISFPz3ROyn/Xug5KDuJcTZ8GXUm/GThTZpJBjQEQnOOlag0lbCF2gsq8RIH3OGH4sqOHu7oIysn96wQdDDAw74s8e8yHyzZ1qz4eL5/URfRlO3DHmeWKi5SGapJJH6E1u8Js+7V/ZSoYx7+epVX3UCihXKEvYJ0DEYnFkRr3eVcrVmi48HDbq0uvKNQnXo1ygNK6JJ1tqQR8KBVvVlR5v6XMZr1MJqpa4yTe0qfix7OB7xQQoeBBtYpCEY9mu5qmnN2SiLHAQ6rAlSdeG/sgoNCPdyHuVrof1dV1CD9soCI8yU55oLLgnIqIDbuc5UPkjeJ9DF0qHM1UwyISMPZmdMsnyN1y1sMV6cxTgNsuc1u8qtf3fQ0Skb+Q8VZxhvXFtHu1CfZ3jzGapmiOaYBf7R1nA2mAx5zMtSBdTtPuSvH45U155Ljbtg3H+vBdomQuVb05BvO5rF4VQ8Rak2avh2pc/8Syexs05mFInX2FW5afUxloCsKoNQf8EwDtWM03myaNWSCAWBjsc9UfgfAUsAQoFf3d1ZWgXRA8K+DlYl6MIyiGjJ2RdP2QZ+6Shux6QFt3/dIeQ53pRQZqiN8KO4x+Ge5+udZ5tmisxuP3MvN8VguCLFF5bAk+pxVWpXhnyyoeTXxuPqJ/Cc76seAUn2IfohdIYhd6p6HEvZ4wkt5G5oloQjCzgWyt2bGIirDuT/ExbYLRlsuYD2zXN5RtBD1G1MkySD5o9E608ij/HfJCyiP8v1xjqY+zpDVlBt6/ORFSW6ZamPDS6sCQD8sRB2BIwR0UVaRxrg
 EUgRekNp
 MPdz1ejg730JbKthMGyJnXbeVr02IcXiRQ7Nyb/v5ofEe233qEYF09PlklrrUWPx3SZG0+KRP83Q8UOwiUNseokE2a4kjuhfIXWWkEAjAqbBz2IaE1K5KIGKqDR2cbObkNiE9T1v/In08m8xbdghhhSgzWJprlIs2ZqKCrBmwRmjsS0SiMJp12RbzBWgmq2rXBy1uj8o2ATif37za6UqkISq6Jyo/QTPh3rRJ0KPtyAZMJRVcAb2ydvUbInlq3ABFA6dTOvZtGoH3965Ci+QfuaxtUgrB1PRfvJ1DSridxar0zwXaEI6s8Gxy/U/4vPP7NmFnQjB39NQu15bn2ykMLTQACh+KfFQtBsd3S5a59Czn+3A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since set_pageblock_order() is only used in mm/mm_init.c now, make it
static and remove its declaration from mm/internal.h.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/internal.h | 1 -
 mm/mm_init.c  | 4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index d70075d0e788..8232084f0c5e 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1437,7 +1437,6 @@ extern unsigned long  __must_check vm_mmap_pgoff(struct file *, unsigned long,
         unsigned long, unsigned long,
         unsigned long, unsigned long);
 
-extern void set_pageblock_order(void);
 unsigned long reclaim_pages(struct list_head *folio_list);
 unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 					    struct list_head *folio_list);
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 72604d02a853..64363f35ad0d 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1489,7 +1489,7 @@ static inline void setup_usemap(struct zone *zone) {}
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 
 /* Initialise the number of pages represented by NR_PAGEBLOCK_BITS */
-void __init set_pageblock_order(void)
+static void __init set_pageblock_order(void)
 {
 	unsigned int order = PAGE_BLOCK_MAX_ORDER;
 
@@ -1515,7 +1515,7 @@ void __init set_pageblock_order(void)
  * include/linux/pageblock-flags.h for the values of pageblock_order based on
  * the kernel config
  */
-void __init set_pageblock_order(void)
+static inline void __init set_pageblock_order(void)
 {
 }
 
-- 
2.20.1


