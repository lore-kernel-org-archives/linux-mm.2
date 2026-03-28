Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD7EB10BA421
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 06:55:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DD956B008C; Sat, 28 Mar 2026 02:55:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B4A36B0095; Sat, 28 Mar 2026 02:55:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CAAA6B0096; Sat, 28 Mar 2026 02:55:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EF5276B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 02:55:47 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8421A141583
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 06:55:47 +0000 (UTC)
X-FDA: 84594561534.20.52D251F
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id C168D1C0011
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 06:55:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="CCyQ/+Uq";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774680945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uDXiAtX+adUfNAkJbiLCrnHptFJMRkZSTW+WT1VR6Zw=;
	b=cB0wGYaw7JQcVuW/rPDKVnx5oDJAPm6oEcw6OMwlhxUL1L2AcrLLtt0rJHJqzUHacO9F9c
	DOieGqL/ztGABFXAbpsGpbE9KFKuZjAkFoNElSb5ikGmNhv5SVwyxtaKhGdfA0n6ZPVX+i
	Mgid2fb1bQWaW3Z/nVFuM/vSs8AQE/4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774680945; a=rsa-sha256;
	cv=none;
	b=YE4qmi+yggDgZIwhpEAlwIZqj3DAw6NXduDCUHo4ZdTiAQTwr0S4fBIWSzV6d8CND5cxwK
	kZKCTyGtL6BuBFiVP6ofj8kaxYnmVmCWx2Ld43zeLmjoYieu2BMhqcuEZ1wafKSPahyhDt
	MGebLGLxrqFqwoKNemb5XvE6LsfrWNo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="CCyQ/+Uq";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-35691a231a7so1724447a91.3
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 23:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774680944; x=1775285744; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uDXiAtX+adUfNAkJbiLCrnHptFJMRkZSTW+WT1VR6Zw=;
        b=CCyQ/+UqXm/EgRR7sjuh5BgbEbJNYw/OR2Pu4ezCpVejlDrDjbTo0U+QTSOIdJf35n
         a2Me/fsOku5i0HSLqq9/0woPowAigQ6G07f4qiamUmVGT0VJKETM/d1IfdKwxVu+j2rW
         5Vx5VcjBktYfGIqBovR3JfFEvo1dk7DrOqCqOSZbq8R2JJ5D14yqxUxAIYMEw17mo2se
         pms1zlNfQQbY4s0zCX5bug8KmS8ImXd5m7pM+49vx+pNmU9/zX1LDj94ClzBPy9UJYXz
         te2EQgksnZmYwEBHuvgZ+OvuvgVZt7qF08EA8uGGrq6D7PHOL4XCskfKo51ZvbhpgDNR
         IYhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774680944; x=1775285744;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uDXiAtX+adUfNAkJbiLCrnHptFJMRkZSTW+WT1VR6Zw=;
        b=GKc1hcih7MVznlqy4xeweWwT4XxPdaUQ7sEVz0AA0L2tk2Dn9jrc9VrZcKuQQ/l2SW
         XrQQ/7jDKmVoULr5ym13c0baSegqdKZsHn2vcZIARO7UVFfyg2yB25QHQM1msWtW+24W
         9BYWQ7d/sxby7YSmuwebjAXFh8mgdcFMDDdIttwfcGtYyMS8AEcKSa5n89FrCiBGkom2
         D9RUhvzz1HDRAnSc7hPDC1RCMY9nuPlJUgDWUlFxFdXsLkZ8lAdeFU3Xq5OhO+5F5M0l
         MdtlkqZx746f0Obar873tNklxGlyMPxcHCW9hk+4N+3w01xPZvQtdLnhiOOg3hMfyuv2
         L8jw==
X-Forwarded-Encrypted: i=1; AJvYcCXdDBYBOLlv63x/AOPXw7RrBLnUdI//g18hTF3KM6JZRdjx/JYEVtvlFWU5HPotITwRpdT0ES+bWg==@kvack.org
X-Gm-Message-State: AOJu0YxApzZol6p6jqVZkuKMxU+RBK+buCp+eu+q1UZFOtqZMOFhIUUB
	W1Hbujmr4pMReArWYPkSinm3CRY/yws4ilykk0vHxl41anTlW8EflJ8F
X-Gm-Gg: ATEYQzxBhGIMG+AS5RYWaEzQf7Gwh7GVNrEkkb62p64xE7LrW1gmmMB6ArpiJul0qXn
	ukw5Lnag899KgUZMfAKM46DA1/EGWsHA4OxDmhLzcvcbO9OAmEN1Dq4PRThfwKGeb2kPHBZCqwn
	Y1z040Xa+820ot/f8oaPplvYkrhpz6wjRmprxpSQxBL5qb8CXgk7QAxCpvwBVp7qnlihm7q4Hun
	7opbdQVw1RxyNP0ZRwEQLYRmZKkn2psWJeAI8SiLHZ5g1hktV7Fe40kU3s62jvKqDSijJBcDr6b
	vM+JVssh17Y50opArpFCuky9YJUXf8IrlTty8pZCPGM4FszoiIb3YQlLCG7UhSFm+DBdtXXCPzM
	NwZQ5Dg2DvZr3gp4T+1U0z9lsQHZVr6ICzJ0VBVEWxVpKAnjNF7wroz9TYZPPd+Twvz+iH5/3gy
	Mj7U7kpIBlnVHfyImdxYA5MkEI0563eWZuiUidxAYb+8/DjrQJ63lN2Jj3KZot1dmYDpv73tSGS
	HpGnUo=
X-Received: by 2002:a17:90b:4e85:b0:35b:e566:15a6 with SMTP id 98e67ed59e1d1-35c300949c4mr6106550a91.28.1774680944438;
        Fri, 27 Mar 2026 23:55:44 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:24c5:800f:f8d7:ae7d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c22db12f7sm6722723a91.13.2026.03.27.23.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 23:55:43 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org
Cc: mike.kravetz@oracle.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+226c1f947186f8fef796@syzkaller.appspotmail.com
Subject: [PATCH] mm/hugetlb: fix hugetlb cgroup rsvd charge/uncharge mismatch
Date: Sat, 28 Mar 2026 12:25:34 +0530
Message-ID: <20260328065534.346053-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C168D1C0011
X-Stat-Signature: 7bhio4sewj9k8ici1694fjrkmq3e4uy6
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774680945-739160
X-HE-Meta: U2FsdGVkX186kkaH+g6TUDEFjJtAjxGREpUzcbXInRG+0loD+h2iUJ+XwOJIOdCWEUWdPgJICDiS90uv1sYFSKz8F1tO5gj0va4rxRq12FQU4oVmEOz+FQL5yCIUEht/Pb2zFJieYWn6MEq7pyVzIzFKd4MbAD8zGEyp+Pj5/yX12H7L4043TZna/DqZvAPkSS29hc5oGJTg8E1CHjQMO0kPpDclJaDf8f6gbZqEEX/b+i0yf2Un2SCkAvalMx1HsiFHLuKt37knIfy1Mv1AdeeIvqQA0DwgnoqtMFZxanFwjs4MFKvOBPUcRiyEOCtBkkFnvswj57r2IjiOY1nedeXAqZR7+7hYZpTwp4PxQBxdMchj5ylOGs5fYwIkc1uaNFSeJiIyoKmt1T96gna+zf39WOlddjeng+jkUvlrISK+HZ0cLEONyofc3AKcVc0R06HI8teHEwjgc5+JTJvW4ep4YOon3CW4h/FSs/DLTcd6c3K57XvUsk2FYOeKoJhEhdi2xUzMBe53WsJhPprRRA3ApRHMhRnzi/QSBKALGQmA6yRmIhByQf/xVMM+PoQv8va4vmdg4AOnYhnkKzeZzTS8mpO9QdbOw/zVOJRTw8FEg8Dv4vEpajOQAQI4SqMMWa15UQut4SBjRPVJ6TPU+i67LsBAwqDKNBDzZW7jaR3fuWzRgD/G6U5I7dLK/CN99Vuir1uFCotNM71xEojCgYB9aUFjj2oYH0r8U8n4gz46k0HrBvFHcejIgn1P76q7bbMT6v8V6YUwCSyr59c+K3IVOdwkYVYUh8/Bx3QwUYFUm/f8x/GLq0Fy2Hu1jErZn1XkFkKiLTtibDUj2DJR1t0X3Zhkeu877YKPEp7ho1kjTnep8/0AYm72+woQO+jUSzOdYpbrk81hbBvBy40lUyjxwcgqL47uPZOi87XBBNk05SVwbJKCyBxy57+MDPMvW+h4oMxvhb/lgXemW8M
 IJvcFnJZ
 IZd9qUt0Sa9m3b0JtEwYb7FFR71GEJOXioHY2+q285jrUnoNhRLv4z14CjgmvDtohO5Uof9wVSytJM3F7A1wJaS4zc+Aw+/Eva9Hbbg7QmXeneFK7rpwLTwGr1rOL60+hVRekWHMkbxni4BJtdJRYSRqehRw+LQlCtZH9mDVS18UI8ax7yF6ijnGuCqucXeQ05cZ6KDW/CMQdT5LmvpxHopLcO7p6r/VdrAC0aqV0exBM9Iuj7zjVb14VFwZe6D0+dh5TrZfo0+FEYGP3PQKlcgfLDoNk/Ndguebxp/WbjIkdvtqm+i4HAqowVqDrCe2ITJO5z554r3bn26XTH+HiTKBGnKqlKbPObCBk49RtcrLubrZK2cHOlSM3Pf2tMUwV64YL7n3AEtyi7jiOU0QfTxfYdjOG8xFb1l1PzBwsJVw5dEpCQjeh9qLOEhonjqlzoSb9xesujx9sE+pgYRm8vmnmf+KaBXe3+JDBSSQ2nwV4Vwr7JLjd6OrTBeWMzuZw+IXo9jSLFtpYko5tsf1PxYUhdd2bvgEUPPedXLsgI+69PeAZDH4/gx3r5yx5J4mcIceocTVmVetzenDKoXKHWBanplmYbzJ8uFe6vP3eaozHvFb6ifc21ztZN0iba2BLcqNLJyoA7/8QSYTtDQUJimzWfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In alloc_hugetlb_folio(), a single h_cg pointer is used for both
the rsvd and non-rsvd hugetlb cgroup charges. When map_chg is set,
hugetlb_cgroup_charge_cgroup_rsvd() stores the charged cgroup in
h_cg, but the immediately following hugetlb_cgroup_charge_cgroup()
overwrites h_cg with the non-rsvd cgroup pointer.

As a result, hugetlb_cgroup_commit_charge_rsvd() stores the wrong
(non-rsvd) cgroup pointer into the folio's rsvd slot.

When the folio is later freed, free_huge_folio() unconditionally
calls both hugetlb_cgroup_uncharge_folio() and
hugetlb_cgroup_uncharge_folio_rsvd(). The rsvd uncharge reads back
the wrong cgroup from the folio and decrements a counter that was
never charged for that cgroup, causing a page_counter underflow:

  page_counter underflow: -512 nr_pages=512
  WARNING: mm/page_counter.c:61 at page_counter_cancel

Fix this by introducing a separate h_cg_rsvd pointer exclusively
for the rsvd charge path, keeping the rsvd and non-rsvd charges
fully independent through their charge, commit, and error uncharge
paths.

Fixes: 08cf9faf7558 ("hugetlb_cgroup: support noreserve mappings")
Reported-by: syzbot+226c1f947186f8fef796@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=226c1f947186f8fef796
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 mm/hugetlb.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 327eaa4074d3..5be36a888e70 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2915,6 +2915,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	map_chg_state map_chg;
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
+	struct hugetlb_cgroup *h_cg_rsvd = NULL;
 	gfp_t gfp = htlb_alloc_mask(h) | __GFP_RETRY_MAYFAIL;
 
 	idx = hstate_index(h);
@@ -2965,7 +2966,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	 */
 	if (map_chg) {
 		ret = hugetlb_cgroup_charge_cgroup_rsvd(
-			idx, pages_per_huge_page(h), &h_cg);
+			idx, pages_per_huge_page(h), &h_cg_rsvd);
 		if (ret)
 			goto out_subpool_put;
 	}
@@ -3007,7 +3008,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	 */
 	if (map_chg) {
 		hugetlb_cgroup_commit_charge_rsvd(idx, pages_per_huge_page(h),
-						  h_cg, folio);
+						  h_cg_rsvd, folio);
 	}
 
 	spin_unlock_irq(&hugetlb_lock);
@@ -3059,7 +3060,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 out_uncharge_cgroup_reservation:
 	if (map_chg)
 		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
-						    h_cg);
+						    h_cg_rsvd);
 out_subpool_put:
 	/*
 	 * put page to subpool iff the quota of subpool's rsv_hpages is used
-- 
2.43.0


