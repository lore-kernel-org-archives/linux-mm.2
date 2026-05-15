Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA93ACD4F3C
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 20:29:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5F5D6B0005; Fri, 15 May 2026 16:29:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D10326B008A; Fri, 15 May 2026 16:29:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C26286B008C; Fri, 15 May 2026 16:29:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B3EDA6B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:29:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8026E1201EC
	for <linux-mm@kvack.org>; Fri, 15 May 2026 20:29:09 +0000 (UTC)
X-FDA: 84770793618.24.A35914E
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf07.hostedemail.com (Postfix) with ESMTP id B577940003
	for <linux-mm@kvack.org>; Fri, 15 May 2026 20:29:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rzDHJ4i0;
	spf=pass (imf07.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778876947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hB4x7rO0kWraX/2vch0MYRJ2VJ/csAYjyg45Hf0A9bM=;
	b=V4MeM6SMo0ujZYwX+AO0dodCi7tIfb6JlBIPyUS0sntPwRdOhhg9B8FlZVXgjZfDtf218V
	8LVsnnOBhiQjJNrTZpzyFOzA3wr4tZVNxBZSxNStKXjH3S0AwNW+LK7noEV87usDId8pdf
	97w9Ur545NJzXfL67OMQa7JH7d6/5sc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rzDHJ4i0;
	spf=pass (imf07.hostedemail.com: domain of devnexen@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778876947; a=rsa-sha256;
	cv=none;
	b=dZDxyoNU+y2qZVNtWsHIfF8taEMwVgrZBQvGYmGRcA9M/d0m4tbR+P3xJkQuA7herPas6S
	EXicDU6Eug/kYVUt7XAQgeVOPLFlmPj4Ki+WtvKJO8sjNg9d8dKeqnuotm8VGUaMKhpV4z
	GYY/bmq1ZGr0FZXy9wQ4JMpMGzBLVhM=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-488b0046078so1858065e9.1
        for <linux-mm@kvack.org>; Fri, 15 May 2026 13:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778876946; x=1779481746; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hB4x7rO0kWraX/2vch0MYRJ2VJ/csAYjyg45Hf0A9bM=;
        b=rzDHJ4i0z8/6QmVC8Drr0sc8efwmyX6/9Mp2zEa1YzSwnDCgA2T0Ze9sFwVnVQ2VCO
         Sg+2a7zDmB+mnCrlNmVlxB02vb8eG9Q2RmlSU2LXWcxnGaiRviS0W6dJCKk/JMTK19dr
         XP0gxbeX4pnfp7tYWYLJsNdqTg5+FADMv2ExWTb5r0TM+E0hi5aBKvt9fB6Tz1E3sJEC
         n6gSAneHt/r745Rq/eVahikCKjTALegCQjJRwUGSNH8puoujUb4lgbWnF185z1p/LhJv
         6uuRO5AGIpybKDVsVu5Dftr6BtpXyMcoVXtn7oElqBLvQx1igUv1EbZ2x4By77dTR/f5
         69RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778876946; x=1779481746;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hB4x7rO0kWraX/2vch0MYRJ2VJ/csAYjyg45Hf0A9bM=;
        b=CJWUirPqMGgv4+zcot/YCCn1OxC4ZUnUo0qSdWUazHRAhNaGn0yX6tRhlWh4Q8EOyP
         RDRRNlKNe74sqOaKjtAZhYsuq3p/sB8zm3fhE9sGSQQcVTLTBB0RJsib2QZNN9JozITa
         IPCOKlgFEJ67vRd9GwZCmUQeFwqP7cGfP7EwMbGeJBLcnpeQXT7HFzhwOzr0/DwsF6Ut
         H7u2BdxEeEUzsWIuyOhu/+VbXSwgX/KsgY5hW4aukfr2znXyWlK+hxksZGd/hMY8DguQ
         svnwBH8A7LMZw9WAZVaWKHr/vat/vFVNOt++3kle1slDRaxZq2k0G9qbEZHVquJFx3rH
         x7NA==
X-Forwarded-Encrypted: i=1; AFNElJ9gOi1mGibdAmPn6S79b6QZt5/E6JKfyZh5jm9ui+ktWije6P2AtnRiQy6YDG5P83OMUBvFXunWOg==@kvack.org
X-Gm-Message-State: AOJu0YyMmUAmI8lRVXzzEGPHMS7eG/KPEdXF7LrKbonHKAy3++HfIYew
	G1fNhznJrtM4M0Arky41PCR3/CcU4mrD3iHyD6+7C1u998AeClo0eJml
X-Gm-Gg: Acq92OGD/ADZtbFs6sU7uVi6ispVr9exNsRkjc6Nz3VAwF8xaThKVTA+2OPPMdJaZql
	Xt2ja0iTSQvz/gzfCzQ2UcCQBxChQEy6ZPNNDMSle2kjBgKAjle/n7xhb6oFMhTEYvTgiwhcbR+
	tXk2qJy7rifL0EdJni6hZvydTMLFYqbNaC961OJL7/vOwYRHvHbIUFLX39D6vwviZbgN7MaTuvJ
	B9pBpyFfw+rrO9Fblrg3mtLgKDL92P8vRBizNEzTJFAPUpKfOV1dzd5LGEUTlbFuHAOpsD87Zkg
	P/WM4STkZCCgCVDId2eUbQykiM1OSe0jcC6P6gBrpUpWYXgWuL3dMOhoPxJQm+IA8ZrSEZFGiCT
	HbNxnaLglx+jcUvbc0TY+Vr6ZglPajJOTxJFlu6hfiypkGaqFHSa4YFvamNrdD4UMD4OUP11msT
	xVUhfccRrSK3bDIR5a2mqhCX1Y7+6Vb0kcGFXuPOfQ9u9Bojlxr9m1OUOSHZBFoU7Li7F3CoBMg
	hIuiitrMH3/N0Phu0iAUQ==
X-Received: by 2002:a05:600c:a406:b0:48f:e230:1d12 with SMTP id 5b1f17b1804b1-48fe6329913mr66632025e9.31.1778876945902;
        Fri, 15 May 2026 13:29:05 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0fe0f72sm18422463f8f.25.2026.05.15.13.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 13:29:05 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	joshua.hahnjy@gmail.com,
	mawupeng1@huawei.com,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH] mm/hugetlb: restore subpool used_hpages on alloc_hugetlb_folio error
Date: Fri, 15 May 2026 21:29:02 +0100
Message-ID: <20260515202902.461539-1-devnexen@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B577940003
X-Rspam-User: 
X-Stat-Signature: 9ufffbq5usrd5buurqte9kdr9n7717x7
X-HE-Tag: 1778876947-124431
X-HE-Meta: U2FsdGVkX1+j6ljkKw50xsA8afvJhwIQsJToJ5Lm5jzpDUaMPXCUil8BIxStuJA44+ysWNFFL2r4SD4tvnmivGSg/D/8AbckBJNWrOFoYuaPK4hi/fyvirPFe0ZrvjPyv8omD5ZYGbSAv6y0GS1TLkdxTGD0JwpwQN87qSUjtNBydHqrTpKMzkOf6bi7EpM/vhTUhfkJGdCswNR8vbBvSXdZiwc/nyxCgmvvjx8bqXkTX7YlohiU5gXjHtLABJJQpvAV5fyk3Ao4uoYQSwNOSYzxa2ELjDKsuxKIyiq8UeQbsgkoEWJckmiv5ZggPm829sRxuZSimHs6dqK+kNQM1K+PlUu8QCTOjaZ0EJVZx3FljcLrUY4BBfjaCZYo09oBX8ZVXTyRoMO07QKnzaNEpbQ7EnmDAsFOLFS5HJNqIm01upfyXGweLiF1TAzOh2Yonn0Js8YoEJd1yNyX5iy2OSQ0y0ORgRtLYlUx99qI9pcrOsN1Fzsh80jbovdtGmqN947YKdfkh1sydpJct28B1HgOAB5tCVGQ1jFUxtk8fL5ssgtttgierm7zPuPxK30xeB0nyDmtr1tfHeBnhBd5pQuL0eAjg2+OS0leleOxi6wCheLcYCVEcklaNQ6UXWkxfuVAI92lfwLHEDQmSX/ELO8LrvqXHLNh9C21feqYQMl+Go2rIePJV8ekUK6SKg5uRPe+jxRkBx/9fAnKXAI3ypduJPhobWtgz2DvEjRhSDDqm5Vn/1fh+LxLrNLFlyxJfMZN3V0EETtzi+ySki/YGCiV3GXlUV4gtq4YcSfwvSfdnFQkLOPUmzXfm9ZJebxLK7R9uhZxmuAW8GEKBnNZWnOqdYp25P0FF17fVHAPP2DA033oSkOP5IPuJr9f5S3alhTXm1xNBe0n5jChxWxfC5AlpxEN1uFpYigAz/azBPA0/2iiFig3Tfefs9xsvRh1mtIdgraneUD19jV2t/h
 njVgbYI0
 orKTFCpuhPyJxUfQSEqP7PP7ET3WyhdzU8mxSBiYrnb6fzNWRXHGleiWFNetQEvfbTj+hBWGcCz1MZovrKBRwIYZ57yVRpysa7wmCEAiK340Y7Cfks5nuppmogBaQnfdghfApQdmUfxzhuaz6UItcubKd+iejN3orbku4ePoQqFM5/Z4R9O5yF0uO/HsSxkMea5p3PCHd4gPduZREeMGdJlH+zQnmYhRCC5bXZYFddbZJCsQuzjSrPl6YZCBKRBGMnnyvi1u7UdjZLoguDgGpd5nER51cSe6TcwHISGejO9WCLuojq4wHSxEoBNjO7ZLDbAuBPkfaEIaCO9uUyuO+I8ucrCakzQwaCC8/KX1m1sHDvguBI86GQsV6OgkSYGB+bQAGW1fE8uWNyFdniAaNwvX5IVjQESc853seIM7A11dJSspLM1KD0fpANlaBYI0HPo+AgfU03JcVbC4QrOffhGfVtqge53bbvhUOQ+qWJyUJk9IPmBXfh3cOKNlUKSNUkMAv6dOcoQqzpbYMQLcvrwUlXBYzxE6yHP/Bp1qiJb/eS9U955FcHg0vqrHBnr5sWoUpiZ/kiHsCnJk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit a833a693a490 added a !gbl_chg guard around the
hugepage_subpool_put_pages() call in alloc_hugetlb_folio()'s
out_subpool_put path so a failed allocation wouldn't drive
h->resv_huge_pages negative.  But hugepage_subpool_get_pages()
increments spool->used_hpages whenever max_hpages != -1, regardless
of whether the request was satisfied from subpool reserves or needs
global pages.  When gbl_chg > 0 and a later step fails (cgroup
charge, dequeue, buddy alloc), used_hpages is never put back.

Each such failure leaks one count; eventually used_hpages reaches
max_hpages and the subpool refuses every further allocation even
though no pages are held.

Commit 1d3f9bb4c8af fixed the same defect in hugetlb_reserve_pages();
apply the equivalent restore here, guarded by spool and max_hpages.

Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
Signed-off-by: David Carlier <devnexen@gmail.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Wupeng Ma <mawupeng1@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: <stable@vger.kernel.org>
---
 mm/hugetlb.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index cfb7cb2e9806..9614330889de 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3010,9 +3010,22 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	 * put page to subpool iff the quota of subpool's rsv_hpages is used
 	 * during hugepage_subpool_get_pages.
 	 */
-	if (map_chg && !gbl_chg) {
-		gbl_reserve = hugepage_subpool_put_pages(spool, 1);
-		hugetlb_acct_memory(h, -gbl_reserve);
+	if (map_chg) {
+		/*
+		 * Put used_hpages back for the global portion of the request that
+		 * was never actually consumed; restore the subpool-reservation
+		 * portion via hugepage_subpool_put_pages() so rsv_hpages is rebuilt.
+		 */
+		if (!gbl_chg) {
+			gbl_reserve = hugepage_subpool_put_pages(spool, 1);
+			hugetlb_acct_memory(h, -gbl_reserve);
+		} else if (spool && spool->max_hpages != -1) {
+			unsigned long flags;
+
+			spin_lock_irqsave(&spool->lock, flags);
+			spool->used_hpages -= 1;
+			unlock_or_release_subpool(spool, flags);
+		}
 	}
 
 
-- 
2.53.0


