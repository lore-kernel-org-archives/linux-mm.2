Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C65DBCAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 02:52:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 263DF8E0034; Mon, 29 Sep 2025 22:52:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23B418E0002; Mon, 29 Sep 2025 22:52:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 178258E0034; Mon, 29 Sep 2025 22:52:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 048288E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:52:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B8B99140298
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:52:54 +0000 (UTC)
X-FDA: 83944394268.06.6B9C125
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id BE3CDC0006
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:52:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759200773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=GWv5oIDqhms0LUU88lIi6tp8nHicFRW87MO40i0CmY4=;
	b=1sCY7EXfjYIXw/Bnis4N0suke+SUPKbhKVUt/h/k95iYeeHQESE27TR4S5O68qC5Jxbk2F
	MqpOk+Q7WB7V8acZi6e8z+OHDtqhT7NwzdEqj4n2/EHhwN0iZet54/sJo/LbZDolVEj/yx
	NElFs4h9ZMlsAsjk9BHTzkqPpZWhYoo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759200773; a=rsa-sha256;
	cv=none;
	b=UTdNLJrvNJqRLG8S+CgTsPumL4t9Cg7ZZeHO5kNNeS5NC/YZ0VcL3Lh3Z5a0OxGLigj7im
	grfDTyv8wbK422CGb1/k3+avVJpqYFRxGvIXgam7A/oFocFmrSBVf1QlKHyLvl7igm/d3v
	DKvXUa7GScWbmum1CMzUqPPPNTwYs/E=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9F873497;
	Mon, 29 Sep 2025 19:52:43 -0700 (PDT)
Received: from ergosum.cambridge.arm.com (ergosum.cambridge.arm.com [10.1.196.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CCE443F5A1;
	Mon, 29 Sep 2025 19:52:50 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/ptdump: Replace READ_ONCE() with standard page table accessors
Date: Tue, 30 Sep 2025 03:52:46 +0100
Message-Id: <20250930025246.1143340-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BE3CDC0006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: wzi47yduezkejm18yrhecbhqeu3c4o4s
X-HE-Tag: 1759200772-56503
X-HE-Meta: U2FsdGVkX19zillMtZgcM9f+o0642TazhFrkNmsy4X7SjrYk9rAJZxl9Bx8jqzFEBmk/Hc0CmUM76KUY+SQs5/mPKzb8NNNdvkN6mtiyxX4KjPd8A9PG6SA3mZ3SSL6wOFpcOyyzunWHwJwTuUqL3rq7hMbyS6m38agoKTPlMeXY0t5+dhyh2UAqIXMhInT6rGxN03k/AW6/q2Ofwlinca6wSFRkA+GIf7GSPq67zce4gUoiobWR4tGOGZyAFCvl8oqhWcz1I2jisMnAKKXdU55WMbHJ6SGZuHVfm91O7kTpjQPnQa+FR45IhKFmiNksOuLpsmNShe7sB4lHBMmOrCizCpH4FsNJxqheODkpZgundZ8X2MVu0JDZ2SFbBIZJ20mO2yRvfzb1grN9Kn7WQYkIx/6BgEnO7OjJCDbIEqYpc6vl6CMYh61UiRSIpa7G8ZLgL6jo3KUpzcDWiHjlcE09H7hqS3XYyPZ6IHjG1so/nUD4X/voTrdWzFnvH6P73jATsZlgyWOoqXhHoCrz98osVMS23lao85f9HCNI1cD89TqwnaV40/22nB1QUnxNXYg3/CH6LbTs2xGnkctAgG5sRsW3yDzhSPlI/aQLrdj/EeA5vLjpEECQ0wxei8TN8HZhoxIHxmsNe+BgP/iWY/h1bbcf7VV3fCINSSt7kIqiBocirGu+ugFL/gf3pblgbhr+SaFJ+NLUkPnPpCgh194FdGr528tVsat5WZFQF7ppoVNtR/aSgK8TA841BtiMWy10WXh5I/osCx1G+5ORFHaXTH515HyDYiX0lM+bMxWxFrnmGW574Mps+S3N67aegvw1ggco3TQRPhpwClbddJUiJiBnxhsCbRV74pqhudnJp3N/fkbb3IKonoruOkElVQKzcwfNozD+zqg5ec+y7vyh5sblPpAfTm4PMSs5ZqYtjhZah1FS1UIm2A1h/GbOAJoWFpNQh9oojbwlfRi
 ykmKl3+k
 +kKI3MCAYbq91qZgn5R+W67XkZcZd92o+pAtsS9x8BVcLBfw1QNQ400iJTv4Znz5s9MmYodZunH1oUKGYYip9Ro5NZbVrp4Gy16KSxoAxelWgSi4SdLZboKm6NNyNi6TOtWHVO8onABzKepYMcNmtDbMZafFrAQqwrSt143gDk+OC8Q+zlq+AflWuexpYdpaGwCpGDbhYbgDjRoqj0RJ0g8ok0X5jxsoptQ+FLZrY1wVRxsBEKfPO/jisb2ecJmfyaM4U0IjioY8w20zVfbHSl4soY/hoMNBo7q8jtoZMJ+jDHE/5BQ6MaAdrncqJHRTLkB1LYIo9h7/UQU0mDwW1zaAH/o/TTJsGToH9gKnTn7ft6dwRQWLok+S/948FstYzrQCi38MMapkD7X648YgIZRu9rw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace READ_ONCE() with standard page table accessors i.e pxdp_get() which
anyways default into READ_ONCE() in cases where platform does not override.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 mm/ptdump.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/ptdump.c b/mm/ptdump.c
index b600c7f864b8..18861501b533 100644
--- a/mm/ptdump.c
+++ b/mm/ptdump.c
@@ -31,7 +31,7 @@ static int ptdump_pgd_entry(pgd_t *pgd, unsigned long addr,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
-	pgd_t val = READ_ONCE(*pgd);
+	pgd_t val = pgdp_get(pgd);
 
 #if CONFIG_PGTABLE_LEVELS > 4 && \
 		(defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
@@ -54,7 +54,7 @@ static int ptdump_p4d_entry(p4d_t *p4d, unsigned long addr,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
-	p4d_t val = READ_ONCE(*p4d);
+	p4d_t val = p4dp_get(p4d);
 
 #if CONFIG_PGTABLE_LEVELS > 3 && \
 		(defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
@@ -77,7 +77,7 @@ static int ptdump_pud_entry(pud_t *pud, unsigned long addr,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
-	pud_t val = READ_ONCE(*pud);
+	pud_t val = pudp_get(pud);
 
 #if CONFIG_PGTABLE_LEVELS > 2 && \
 		(defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
@@ -100,7 +100,7 @@ static int ptdump_pmd_entry(pmd_t *pmd, unsigned long addr,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
-	pmd_t val = READ_ONCE(*pmd);
+	pmd_t val = pmdp_get(pmd);
 
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 	if (pmd_page(val) == virt_to_page(lm_alias(kasan_early_shadow_pte)))
-- 
2.30.2


