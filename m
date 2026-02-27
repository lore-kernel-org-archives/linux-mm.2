Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBFBBFD9E3E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 06:27:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BCC26B0005; Fri, 27 Feb 2026 01:27:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 094BF6B0088; Fri, 27 Feb 2026 01:27:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED61D6B0089; Fri, 27 Feb 2026 01:27:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D42D36B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 01:27:55 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 68BB91C5D4
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:27:55 +0000 (UTC)
X-FDA: 84489256110.07.9611E03
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id D6225C0007
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 06:27:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772173674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=5Ed1TP9MYM6mEfEJYOz611/j/jJmH5JV54XKh6dZMRg=;
	b=39cm5R9Y8c1+nS8G200oOGmYzxNCWinqZiIQnTwNy3EfSGTKUPi5oZXIU80ZlIgKk5mEQX
	/c3dpYarz0Bq2sjFxtG/3WB68yHeV6ZaQKsxQaYXlGMsAEOmr8DJiYosqfQ93N6/I7t415
	O2ROck9s+QqLb/lS66gEFCiIjoI9uy8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772173674; a=rsa-sha256;
	cv=none;
	b=trWd3+5ASr3+IkaRys6GEzvN5YEdRtIzI8y+lkL1KMCJYE8h2ISNqj+xdqnPJxuoDsHtpQ
	rLJIpui0xjny2X3OrhqGMHHxQ/7EppjAijQsBEzGYmqbRgS7Sb9lT/aMT88UwsC8MfT+gv
	WHXVSJfjuzd2xBnj1I7V8aWalddtFtA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A57B214BF;
	Thu, 26 Feb 2026 22:27:46 -0800 (PST)
Received: from ergosum.cambridge.arm.com (ergosum.cambridge.arm.com [10.1.196.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 39CA23F7BD;
	Thu, 26 Feb 2026 22:27:51 -0800 (PST)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] perf/events: Replace READ_ONCE() with standard pgtable accessors
Date: Fri, 27 Feb 2026 06:27:44 +0000
Message-Id: <20260227062744.2215491-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qa531qqnuxocezs31agmpm9b9rsksm3w
X-Rspamd-Queue-Id: D6225C0007
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1772173673-979869
X-HE-Meta: U2FsdGVkX1825l4fQ3mRgOA1hKH0UAqxkRwQCkhLRdHf4JZCXd+OQZBhvtlXaAe6a+8HbgYNZac4emMUxA+AvshOjGKaVGpcT9M3LGAoHylAWfFnzQR6gg5Fcx6LPZfTPGKfyZqhGd44AqK6SmYLGGZ5O2nhuxxy0hNdhCusB9YmmnP1z+ZBwhvR1u3quRszrZxv6wV2Lb7rQclcNTZFePlhZZfKcqI1W+4DNRsvqizTbol13yVeko1zOGKjpwjFmAVm3AZceuKy1tMCmmDV71i6GziFBkJoA+aO3qGNFPpkgRjnNdvb/jC3rRSjb+Qh4tcPyPOoku+PmSJM2cjXg7Tbi0eOvBQkjaiteJp4bwD7TNjc+rzgaXgS0IMf+ePYHVGoq184LBDXzBT4CyGgxJTC+1eKFgOF+AFet8FElJoflSXVbHSKEVsRdpeI4aabxd/ZOmTpmIkAb8FA0jhVKoRQrgfx6x9yvPKKoedtRZeDLrJbYKZsXfqOwNvFCTDLKOeVMPB24vGYmiQureVJH8tPuiAOGkYL4VgCC5ourApUT8o8V8PJAE6UhMamrEka9BqPLjCMTP2gE42G1xv5Mij7yC1a/jsMIQXIdgcYAxADB8uhVdG16i71pvyhNBBzxZdtQS8N361dZsWIllpjPwTndya/502pBLuSvIemodlDdDas7GeP82veU7Kt7gJ5GX0vksT+hZkliyfIIMQ6SoM+gHsldwTgo1llwnwtoKOMLqHw78gd0Roa4YNLPS2eAXpfVNj4gnRA/cA1Qs533JQzLqRdbUUfu3ejk0jLSG86dqreQbJZ6qFPGmwkQEOPG0medquVv92LexKctilX/Y2+Zr7l4Jkhnxu+jWSqUVj2MVJ/F0wbr4uFVPwoKxYcFzjls4s4mfP4zENeKtBzwTGvdGUB6jd66CA/o34vo7FkKvWiep9zSXWGuiyOnV/UJpLZIb8uxaGyL/JWAXQ
 rVpmtIAx
 HIwyJtijdy6eu1I2qpYjXcAbqmTDsow4bc0SkgBvJiEgvMhCrwU/nY1QPdvkDvmzKl4T1sv6Is4dqvE5A/FWpYxnvkNE+Dje+qysSe7G457RE6qpdAv3Ro0je1NftM+peDFkXJt1KwTGgkqckipkDeyhLrmnHgG/7i/GgiOCMnSY1KgYzr+zFyKKyAacziipO5dtk3dVAu9rrGwP25i/Zj3+iT26B3Bf44L33ttV7Np0kOVnjdFcd7M1nVuzgwWkV3HGhGHjEXShZohykDqW2jf1vmSLRM3wMUwEcxvaO3eTtt+sZpB530mDueOL+K7QXcIW52JFYG3KhnGpGdYjHpbNa9NA4GoHOicF6i5JDFfWiikhRBtnkyV/RaIAOjKYXOSPd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace raw READ_ONCE() dereferences of pgtable entries with corresponding
standard page table accessors pxdp_get() in perf_get_pgtable_size(). These
accessors default to READ_ONCE() on platforms that don't override them. So
there is no functional change on such platforms.

However arm64 platform is being extended to support 128 bit page tables via
a new architecture feature i.e FEAT_D128 in which case READ_ONCE() will not
provide required single copy atomic access for 128 bit page table entries.
Although pxdp_get() accessors can later be overridden on arm64 platform to
extend required single copy atomicity support on 128 bit entries.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linux-perf-users@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
This patch applies both on v7.0-rc1 and mm-unstable.

Part of the D128 series but independent. Hence could be considered on its own.

https://lore.kernel.org/all/20260224051153.3150613-5-anshuman.khandual@arm.com/

Collected Peter's tag from an off list conversation.

 kernel/events/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index ac70d68217b6..4ee151cd2c6d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8422,7 +8422,7 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
 	pte_t *ptep, pte;
 
 	pgdp = pgd_offset(mm, addr);
-	pgd = READ_ONCE(*pgdp);
+	pgd = pgdp_get(pgdp);
 	if (pgd_none(pgd))
 		return 0;
 
@@ -8430,7 +8430,7 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
 		return pgd_leaf_size(pgd);
 
 	p4dp = p4d_offset_lockless(pgdp, pgd, addr);
-	p4d = READ_ONCE(*p4dp);
+	p4d = p4dp_get(p4dp);
 	if (!p4d_present(p4d))
 		return 0;
 
@@ -8438,7 +8438,7 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
 		return p4d_leaf_size(p4d);
 
 	pudp = pud_offset_lockless(p4dp, p4d, addr);
-	pud = READ_ONCE(*pudp);
+	pud = pudp_get(pudp);
 	if (!pud_present(pud))
 		return 0;
 
-- 
2.30.2


