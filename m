Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A4DFCD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:08:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0E386B00A5; Wed, 13 May 2026 09:08:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE63A6B00A7; Wed, 13 May 2026 09:08:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFC7D6B00A8; Wed, 13 May 2026 09:08:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9DBD26B00A5
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:08:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 61C2D8EAD8
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:08:31 +0000 (UTC)
X-FDA: 84762425622.30.323BE37
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7C704C000D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:08:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="ef/5BAeq";
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/LCdC6mqaLMXTH7aZ0tMWbwialgwYp0mO7Qo6rGSxZM=;
	b=a6ITWleV6rXS4hrcXNRnVgnFw4v9LA3CuwkxbUjo+Z0Q1O96b3O5dR2BUAw47CnaA/4Wpo
	Yk6/jk4ijrlI3hbxA+3yw9OsAxoIbMIee+OGxBUdXr2tBi8AQd9cVB1FxFnVqxfsG1ZHFQ
	4++dGPUItd99EvA/rw0BBtQQiX5QZ1U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="ef/5BAeq";
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677709; a=rsa-sha256;
	cv=none;
	b=0FILXRSHeNHEL5G1gPYoL41uMZvDSCP25VJeHy+AZUPBXn85hUiRlEMjzq5mmncM+MRr79
	WfhywxP3EqG0qnP8t6actRl20vcds58GwGRYqfeFgt1PDOlaYv8I3c03MNwaD/siIH++IJ
	e0kn3TIezUbz2uQRWbsQF3eiZcexA7w=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2bab82d75fdso37448715ad.2
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677708; x=1779282508; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/LCdC6mqaLMXTH7aZ0tMWbwialgwYp0mO7Qo6rGSxZM=;
        b=ef/5BAeqA4HNyLnysXmFgQg1pn5WYmA8SduNutABEkca7Wifsr8UX9tgw15frfv714
         jBHwrtbrOxTLRts7q6EZtfI7AHDDDSxNwBWPzgpDEnOIEMiMIkxSFz6VoCtxuyTM2Lnm
         TWnVrCoHuFLxdH7cTjaJchcDkxstRMxbgsq9DLOkZOmzZDQPwlpv3a3JJqEafw2tpLkz
         anzWEewJ+rGqCYGk+9/Cg0iFOaQGWtrlN2QMylEvmpSTPPa5znn3WdAAK7lJwIqI40Qw
         joqqtyuH4c+zh6QzlkGH7PwnFxTFVF80zOWZM/9rr+U8z4cCSEUWQ/ogF1hs76525yDy
         DH4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677708; x=1779282508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/LCdC6mqaLMXTH7aZ0tMWbwialgwYp0mO7Qo6rGSxZM=;
        b=VO33EL05OFTamkOOwGXx3OPU5lUwHMBIEZlYhqZH+ysKMP3zA+755gCMI5C6z81To1
         BAPZG4/G9jEDVEGoYK6cks+G3No8XVP6HH7oY9ZKKmwg0rQuM4BQlw3/hBSn0nplBxUw
         MXtCY5W/jQaXfa88pf5Vbr6idncbhIk8LEOQa8lbXFzIQgSbY68HTivSHlMIlAMhEN22
         MvYCnAntdCwBtP8CjFarTpB9G3t3Z8J96eYbYWZTz+WakZBWtzcQbl8qYTY5P3hC1TuP
         sNXYtWaNz1V8SZVzBOYMjduBOFHzH74awE2GzqyE6cvxcB+vl7KoEluYruHFXM4gYltu
         sLIw==
X-Forwarded-Encrypted: i=1; AFNElJ97Goyqmc1Dg+UUoSgUOi23GPq0yH5+qlVBFKQWPfWfnlMASNtG458znxKIb6dzGBDw39nxkKd7lQ==@kvack.org
X-Gm-Message-State: AOJu0YyZHjj0QBScqojT/ZO1orF3WmPfE5OAeAxDujFcJNp3zkQrF0Yu
	tIjja4uqdtSgcGie3WU58ltwfVX4vJzd7r9RD3qBnq6n+kaBvvlK2+vrei4GPNLi8PY=
X-Gm-Gg: Acq92OH9G2zQGq49iJiFsXcZx2wJ2N0jKKQGjbkaYO8c4KKQ/ZQPhNAMim1M6c+cObB
	Vci86G1j+ZwZGCjURM4zMzHSILSqkFUpyWfIV9qvXCqJdSymU52dm0not1B1OFjUod23LRDmbro
	pJbM6lp38YWPcyYINVF9rvR5Wx/Ady4X6JvkDn5K05oZH4jllQx60TcR7oOxuIYLyXYpKVBuXRq
	AS72MiZzg9GkkgBgsfbd70NQ3jXOogxaEWzCx5M6zaFHXXWv2cuKDWzruO276EK6RD1JLuDtijR
	xqhmALKhBiKwJD5/NTING8puW2tKwDLUvlLBOOGJeCnLNfcMWwkU2Wpngq8x+3riQ4ImnCrljoQ
	3xE89PFCJ5DZncvTg5Wfmh3XACHnCUOxYCz4kyPKwmGdQ5g0ezOPkJdVogWkZf8IuxTJFyrMsi3
	TW3jv99X3bVphRsJqk+bJ6I+JTmUeAMFIP9UJAqDfWny05mNn0oFXE9V0PEjwNORM4edWOnw==
X-Received: by 2002:a17:903:4b03:b0:2b2:a267:784a with SMTP id d9443c01a7336-2bd275c818dmr34598845ad.24.1778677708025;
        Wed, 13 May 2026 06:08:28 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.08.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:08:27 -0700 (PDT)
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
Subject: [PATCH v2 10/69] mm/mm_init: Remove set_pageblock_order() call from sparse_init()
Date: Wed, 13 May 2026 21:04:38 +0800
Message-ID: <20260513130542.35604-11-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7C704C000D
X-Stat-Signature: 5m13pyd85c9gr8q97zofzdm1dgp368o3
X-HE-Tag: 1778677709-740919
X-HE-Meta: U2FsdGVkX1++dfleGd9gMeECXUUi73fK4pSM9e+F+Fums57W9Kp6tkgMlnvXhjEXInsGLrLRbzPy1YGXZ+cpgtl2zt8UlA6CSRyBuQOYIpgaG4pGdGp7k5Lt+JsXsxxTdlK73bNsqIAJG46dtjcrJTiv1EITgWwbeJTr3Pzuf55CWMVgVNrnkResNTeK3OM1SHMyZ+vyKwE4EHekkQCITgeIowA4qdCu+BPgGYgnCvzznRfHlK9ksViJJE/7nKZQEi6cGB0CXGR3Z7XByIJ2KPMHS1wc2dbQfyitX9bPyQkGm0+GmomdFJuJwppgNnq9ukz/qlb1o09jfLNaA5yv5wL3pEAThQNxYpffJUfVV361UzZvLK46/QE/UsMNIwgSRxDOPubV9NDt6gZxn5NGSFuPYxQW1DSe3ay/PWtXvc49sTuBlZiGejHcOjDMll0Gf4q4Sju+LVZkxFBFeYAKPWddO8q0sxM5nE20RHN73BSQR1Rjl1a+6YS/vVe1Wy06WySeyqJP6JiYoEznYdwZ9sWbfxroaPYVLCiEhSMY0TEZU3gSPC74I9Fg+uJNbNNlvZ9em6nbYatyJeM5qS/IVx8t8tTXMdduZ+SQQYmF1zYfwhAagiDr8TI+gWPCp8bkybfyHIve5psOGq/EssEBiXrGQW7x5NQ5MnC0MLpp38/DIo9feN7yUl5y47A4wA+XbjJ6Mej71Y2SuUBVv+dqh2PyxRB8igneI2AZ2rrFSBn4Ay3snC7dMS0HEfCroH5SbgLb455SfS0rfbTLJxv5DwKUXTIp1rfj2vU419UDk5EueXrrSWuAgtKc5+m2UZcLYs3KMzJw1gKCh7NadDQj9xa6/Ik49LcuuNy2MFaqEzHt7BPJ4ADAs72zDtIM/Vni7LzjzPyToC/+rxReT0dedfuj2nefhHaxw3qo1GWq1yM7Okbrrb8eFSPMJf3YzqVSfhi0nKG2XuqyYKwXlQx
 ZyPZ37rG
 9usUzHL1c6j78kW/JAczAr9eGBo1kKYKH0/rmGBg0cFqrdJC9RLODP3ck8enDutCk4CbUmYBD+YHH+pvYzqxfVqUya66mlV/YJbKntMYK/c2U3UIRQRBD0j1y+WzPSnVoRqg/108LpDmv5Tl//wHIk5AibIPOCgowL7/K3Mm3RL6LB+7MT7cbFz5krnAXrEw7guEuewzmVHSuZNnCxcaAEJOoyyUvyp0VVZLDpIEXOkh/YTZMZ4wJg7gKNvpl/OzLkNWkkBEYn0awPc8nnz9SctBxfXaipnii3pSqoRoPTV+j8lBlzgmN6USL35yC0Jq2IBT1mQWjO+p+UbUmPCQNxsE4MQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

free_area_init() already sets pageblock_order before sparse_init() runs
for CONFIG_HUGETLB_PAGE_SIZE_VARIABLE, so sparse_init() does not need to
call set_pageblock_order() again.

With that call removed, set_pageblock_order() is only used in mm/mm_init.c.
Make it static.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v1->v2:
- Move the removal of set_pageblock_order() into this patch
- Update the commit message accordingly
- Add Reviewed-by from Mike Rapoport
---
 mm/internal.h | 1 -
 mm/mm_init.c  | 4 ++--
 mm/sparse.c   | 3 ---
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 28d179cbc451..6bd9aa37b952 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1436,7 +1436,6 @@ extern unsigned long  __must_check vm_mmap_pgoff(struct file *, unsigned long,
         unsigned long, unsigned long,
         unsigned long, unsigned long);
 
-extern void set_pageblock_order(void);
 unsigned long reclaim_pages(struct list_head *folio_list);
 unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 					    struct list_head *folio_list);
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 75f98abfed97..6646d4b47796 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1508,7 +1508,7 @@ static inline void setup_usemap(struct zone *zone) {}
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 
 /* Initialise the number of pages represented by NR_PAGEBLOCK_BITS */
-void __init set_pageblock_order(void)
+static void __init set_pageblock_order(void)
 {
 	unsigned int order = PAGE_BLOCK_MAX_ORDER;
 
@@ -1534,7 +1534,7 @@ void __init set_pageblock_order(void)
  * include/linux/pageblock-flags.h for the values of pageblock_order based on
  * the kernel config
  */
-void __init set_pageblock_order(void)
+static inline void __init set_pageblock_order(void)
 {
 }
 
diff --git a/mm/sparse.c b/mm/sparse.c
index 85557ef387c7..324213d8bdcb 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -343,9 +343,6 @@ void __init sparse_init(void)
 	pnum_begin = first_present_section_nr();
 	nid_begin = sparse_early_nid(__nr_to_section(pnum_begin));
 
-	/* Setup pageblock_order for HUGETLB_PAGE_SIZE_VARIABLE */
-	set_pageblock_order();
-
 	for_each_present_section_nr(pnum_begin + 1, pnum_end) {
 		int nid = sparse_early_nid(__nr_to_section(pnum_end));
 
-- 
2.54.0


