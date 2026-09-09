Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1C9CC79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:14:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAF9D6B0092; Wed,  9 Sep 2026 06:14:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E39716B0095; Wed,  9 Sep 2026 06:14:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D27206B0099; Wed,  9 Sep 2026 06:14:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A62236B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:14:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2B4CA018F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:14:20 +0000 (UTC)
X-FDA: 85193813880.26.1C603F4
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0C031120004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:14:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L60qduUE;
	spf=pass (imf29.hostedemail.com: domain of hughd@google.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788948859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cx1TfB9GnW58nOxDn37ATPgkJR6erGAjBm2BqNqkY28=;
	b=V7e+2wIuSnzrbPXSeFdboaIYcLL3fiQ5TUNr4fkz2wAtp//hrccG6HPJat8xz8jZeQPwVS
	jpTu+3llt34OnpWgK7qGGxb+3Nb4C2wELFDMrq6kQyNYKdPDXdYKCRbM3HCc1HVlpC3/44
	Qf+T2KF8k0wBfYnPHgUXcXqdoto1xEQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=L60qduUE;
	spf=pass (imf29.hostedemail.com: domain of hughd@google.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788948859;
	b=423cMHo9DRISxXAlzHxwsT8ZWaz4unhHzlIcjBe4Xnm5GF8ivpS3bcnXFsBZdI5KXWLRCP
	DBOHrOiydfa+vAStoG3J0vBVtoA/WK2tZu95E+vwqZ7SZg4oDNU9+nRxU8SAb6uv8G+El1
	HFwwcgsGvqdY5NSFZGnJqu+cUQUQqhw=
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-878ed0f17bfso34135237b3.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 03:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788948858; x=1789553658; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cx1TfB9GnW58nOxDn37ATPgkJR6erGAjBm2BqNqkY28=;
        b=L60qduUE2V/UIvRZz23fM0DCwrBxYPx5D6msWYmhNQqD39FDb7cwFTKgK9OnwvzEIK
         iBeRHxASisj6KAYvZAL79+cYxVAUd+lWYySNgSXZEMfa7pDOqcIKN18BSn1uoEeDsfwr
         UUG65YO5H4RRFSMaSFMzs+v7MW/tuLpR8LKJKqv0vkM7q70dCfZlPadgTY0jdVoR5yFn
         pSpYFRhaZxjl5bLmTs5BGWlxxy9IhwjMLT+OoAIemr9Fdhymh8ZAAAaQJJXQi89G2ieh
         1JZPCEQ8Y5KjHklaxnKcE89Yyyw7V+hH/LHIm5T0Uj0ai5eXNvnzRh9GMPlEVAbQQUfm
         WW0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788948858; x=1789553658;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cx1TfB9GnW58nOxDn37ATPgkJR6erGAjBm2BqNqkY28=;
        b=lNYmIwKWHj3iNBGMFEURW0hcI/tcq2TgydFPH86n76lhfYkf9ULZzAQ10v5RyMwWdx
         f8TTVOfbsI3pGaMIS0HOcFUbhxITonQ8hL/2U5w1zAANvuvMadyXmgQkxAMFH3chnTEY
         oshgSiPiJV3RSucvzcMfe7Sb+5kLts8/pOaQBwOX10KW6JjZzyixI3FB75K2/OlxAZuI
         ioluulxt034t3wbyWs30Ft7q6sFSut/jD4s+/jqNkZR/cvFL/Ir80r482RpygtkgxNxS
         DQNFWpJd8CahXJKmtmSGjIHvz/MtP/11GZ0Q4+IEzeWSatmeq1trR896XdXYC+2CLrGX
         Ha0Q==
X-Forwarded-Encrypted: i=1; AKwUvBzAAElJIyPzZlKDu0QT3ZYhAHuKzwmrYwMbZHgIXsMobz67yG8hB9h/6lo7u+joJFLWkvYlkIIyCQ==@kvack.org
X-Gm-Message-State: AFuF++lITy79ISgt/MWe/GuovL7BP/L0lL0CaZeEoUUGWsg/fF3GZt/1
	zEJRmt4/ezJTIfoOZKekEcB6V5Emeydqo8vzLoIYnRmyIm+S3t0/wOGCKhZ2EzBPkA==
X-Gm-Gg: AYBFou21y/wC3qgRgD0x1c/wgAKlrtHGKfefbeGqH1rNrEUd5BiGk0WlwkRrXJx92Vd
	ezWahHHiiACBJ5v5jAbl78En/nT6o1ilK3Qx55v1IgNpDeLCZDQ4+0PEqzYzA1vOaHTJuA16/9M
	DB4etnr6gUdpkzO49OiT1GjDyMYvcjl4BmwBMw4wg/GxiJcNWXZaI61bjpwe/xNZk8gqFS0Hj9o
	uRt7Yh/VcNpURPcast8n1FsD90AmAvSF9k05Tsl2tUYRr+/ZwWUoh3I3Bn9KU0vX8fmLX4ZCTmL
	T02Xxlb8KfdtcAytfx0g1cpDwNWxqJW5l0ae6vuY1hTgGjMKc/YoaCrJ7eo8Mc2yLgaP/2AHKCI
	PZCiRoWrtni7CXaJBtsaFvcKVGlMVW8YrTNwoG4BNZ9IY9TwB71MSXYaLYt+1ctBnPTUhJ91tHD
	Hxqcdzoo/Gtv1Ntk8XK5I2CjcDOjd91Zy2U3vIwDyiaEFMirPul+cp44Kd0Q4ptnJvFKZ9xnXxs
	ZreDgidDBe+WkzOhHgG9lckMDqy2yTMXsGyFuzb7ep77O09bGgF5qyEa2c=
X-Received: by 2002:a05:690e:4513:10b0:670:f6e8:1f8c with SMTP id 956f58d0204a3-670f6e87f07mr2998845d50.84.1788948857514;
        Wed, 09 Sep 2026 03:14:17 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66fb47a8894sm12066216d50.1.2026.09.09.03.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 03:14:16 -0700 (PDT)
Date: Wed, 9 Sep 2026 03:14:11 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v2 16/26] mm/fbatch: remove lru_cache_disable() from NUMA
 folio migration
In-Reply-To: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Message-ID: <bc903047-0dad-902d-5774-ecf73c6dd343@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0C031120004
X-Stat-Signature: yweiyf69qew88trik47qqg88rzrrkipb
X-Rspam-User: 
X-HE-Tag: 1788948858-701446
X-HE-Meta: U2FsdGVkX18lsKeiuMoKgYXf9JQETKGj8jt7YKRL39f4HjryeRGJftYfBdf3koXIc3J3vJ0Qqls7NNjC2YqWOCSwnIvN/vOCyB+XySPT4+EgID02G/QfcvQiWt9D7C8pwqujgc+3pNTobGaRLFUy+A12q3NfuleU1wR1KQgJSW7maayHzDHr84B3Ox3sMDXnF1YcI3r/0VUyB6zABy8xx4xUF/G4Inv8xf+BD3Kj33WFle+p4dgrwR54lVyYuulDS0u5J5vcZ7pA25+6NfhxoGYTwMDXYg2PO3ZNT7jzwhvMf4dbltQtA3v/twGjHW+dLwGJwj8voSV7XriEaodrUB8hOJTkJP2wFtBZkgVsYVYj9DJpr/I6E2Rd9kVY2JaYrQIq5pk+6X0V+E515EO4FbVGqsYpBlvzG49KeiSp3g8S02VbZCNMCI4RRpVwDaR8dYHdgMsVHMTRRS2zUuPa3F7DCns33jKuOfkKOQ93rcw9bV/PKv5OazBA+mPS6PwVLfwa3gIfBRMsCpyKcAX48Cy34odyHxV76PgNdK70SIprFHE3gy7ThllLcGppmCiwA4AsGuSZVUEaF2n56cWeNNhStnRoWn3xIccqvl1Otwhe0dYQII4noEGBIdnN80lH5Zk/oEdYEdlgvD3Ms7/FCh3wOK/T3ue4W3E+nqYVrpX3ihkLn3Rq/cR1CUUh9zGXgcEQFohepoFgMKruGIBXVgpGb1v/+ow1zsLriN+2CXO1c1eZvhJ6HhLKYPVVoV1phwCL5RHdcjDv5nLvi0JzoQSPdjwvU2N2KaCF+YojeuEgSg2ewUMerM7+0cA1M5ebxUrVn4Qw8+QEW7wt1GuDQ9atFTx9J2LdpUQGdfmzmVNSW7YJCFyaY47AcsCWnTfSzrv32Ga7d+KK3z0HK9RRGNRIjOqb3P1+t9X9rmcdiDPKLp7RYbQyCWu7i1lR3CJmJgG3bX/rlziL7Gwmsb8
 Shm4wi8P
 5O9/6fVlkW4yiTDwcenMQEPDfpftkx13UYlgsAG2Af/yR6Bc2FAP+jd+LDiP9x+oriZ2rvx3uNjI3GIryMm81UULiA42v7erRH7ojzpH8e0VXcCUE6w9YwGDlWm3m56ce0BtzLWUVmtN+ytRro2pH+6inUuorBltGSv+Ca2dQE0usPJcWW+BS/5XPiTXj2Nt/6siCXkWHEe4B6stBGzbUiFzFMA0XqYFCQjBEIHmX9VL4gypAy+x6b1bbXbofV9oLPleAKaIU1PtwlVbWCNQNaR1ju9jPyrNYJrVb/qit8w/Kj99UNQX5l9CstbsiF/mwhkl6uXN/z2+JhamqvhsrwTlXH81muRWddSoO/t9kECY52qGNH92vrud642TRpGtBj0LVBBMRmDnRC9PF+zZuwo+ZKxUWVqgbxO+OWTzRAsbUgsLoIeIc2caOLiPErSYU2/Clr/V/eS41lKpctAhT0/IJm2TB425diS/s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove lru_cache_disable() from mbind(MOVE), migrate_pages and move_pages
syscall handling. They do not now benefit from lru_add_drain_all() first;
they gain little benefit from invalidating buffer head LRUs first, since
5.0 commit 80409c65e2c6 ("mm: migrate: make buffer_migrate_page_norefs()
actually succeed"); and it's a shame that (even without CAP_SYS_NICE)
they can prevent concurrent tasks from enjoying the use of those caches.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/mempolicy.c | 7 -------
 mm/migrate.c   | 3 ---
 2 files changed, 10 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 79053ece02cd..f4d9b5580632 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1343,8 +1343,6 @@ int do_migrate_pages(struct mm_struct *mm, const nodemask_t *from,
 	long err = 0;
 	nodemask_t tmp;
 
-	lru_cache_disable();
-
 	/*
 	 * Find a 'source' bit set in 'tmp' whose corresponding 'dest'
 	 * bit in 'to' is not also set in 'tmp'.  Clear the found 'source'
@@ -1425,7 +1423,6 @@ int do_migrate_pages(struct mm_struct *mm, const nodemask_t *from,
 			break;
 	}
 
-	lru_cache_enable();
 	if (err < 0)
 		return err;
 	return (nr_failed < INT_MAX) ? nr_failed : INT_MAX;
@@ -1530,8 +1527,6 @@ static long do_mbind(unsigned long start, unsigned long len,
 	if (!new)
 		flags |= MPOL_MF_DISCONTIG_OK;
 
-	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
-		lru_cache_disable();
 	{
 		NODEMASK_SCRATCH(scratch);
 		if (scratch) {
@@ -1626,8 +1621,6 @@ static long do_mbind(unsigned long start, unsigned long len,
 		putback_movable_pages(&pagelist);
 mpol_out:
 	mpol_put(new);
-	if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
-		lru_cache_enable();
 	return err;
 }
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 364015cbef33..1d2085529cd0 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2359,8 +2359,6 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
 	int start, i;
 	int err = 0, err1;
 
-	lru_cache_disable();
-
 	for (i = start = 0; i < nr_pages; i++) {
 		const void __user *p;
 		int node;
@@ -2439,7 +2437,6 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
 	if (err >= 0)
 		err = err1;
 out:
-	lru_cache_enable();
 	return err;
 }
 
-- 
2.51.0


