Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB186C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 13:52:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F2A66B00A9; Tue, 14 Jul 2026 09:52:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C9B36B00A5; Tue, 14 Jul 2026 09:52:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 491D16B00AB; Tue, 14 Jul 2026 09:52:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C0EA6B00A5
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:52:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 11DE7A0431
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:52:44 +0000 (UTC)
X-FDA: 84987522648.01.15B4A8B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 71A022000B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:52:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Mg/1cImU";
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784037162;
	b=d/6QNMqD+BMdrKxtdnvCrmP/ZMolLxygup+6P/IQpeP42cnHsZjhd/3t3iI8eYGZ+byN2f
	VxXLwOHcRatVHql4nJScBAjULg6ZWYa908ANTecak8IbAFfHEPJFMyvRoaxmAxYQQzVEGa
	S8VXKB1IlTI/0buVDTs8oGu316HVBMY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Mg/1cImU";
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784037162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dZ7Hztpv9AG3ym6rD1iyRftJCr5BqjDTKMYF5vaHn/Y=;
	b=yfbbPkw9bzBjEf+XUiBnqvvItCFgjt1XydiT25+Gy2QN0boHdpVFxjMcLmlm4g0AMiiqNw
	5YVRkw0PhUJneLQfWEOquJM18blysXB5ivFClOMX4UV2hJ3XNJqN+9r8X/6p5PknRdxUHb
	Io3A9aZnBoyB5CBGW8QG5+SdDDGQFDo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CB7E7419E2;
	Tue, 14 Jul 2026 13:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648221F00A3E;
	Tue, 14 Jul 2026 13:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784037161;
	bh=dZ7Hztpv9AG3ym6rD1iyRftJCr5BqjDTKMYF5vaHn/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mg/1cImUvg1xFHeuB7HlVPy4iR52T3765lzbUe744vSr6w8vgzvRsPXCeM8TIAKBH
	 EfnFC2sunhWRbpKAwMxprwe8uusmv3x7oT+iInwMgbk2UajQHiCGqsJ66jZOAR/6Iu
	 fY4i7nwBAdYIct4z3u9mmAaTUP/NTEDWXwGh253f0vC8iKCEdZUlG76KCmzLYkFc7D
	 Qy4xGvWQLRjSHnhnNVI+qu+FkVvFef8x9bKu/aZWQOVkLqNwCznx/iwmLd/7hFn2Ws
	 XRdj4VpzQVT2MvoyUgAJ2ZXS14418PyBe3FDRUN2PGTngkDFRYd+nbRQyqL+Po2Sqc
	 DHRb07n+BCDNQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Fernand Sieber <sieberf@amazon.com>,
	Leonard Foerster <foersleo@amazon.de>,
	SeongJae Park <sjpark@amazon.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/5] mm/damon/vaddr: drop last same folio access check optimization
Date: Tue, 14 Jul 2026 06:52:31 -0700
Message-ID: <20260714135236.92699-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714135236.92699-1-sj@kernel.org>
References: <20260714135236.92699-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 71A022000B
X-Stat-Signature: tj7nns13emk99ii1tjk14gg8srjornst
X-HE-Tag: 1784037162-554860
X-HE-Meta: U2FsdGVkX1/CMqrwBDcej0cAIuWXRuA5XZPo25Ejh4aVNSokTjWaUVP2qpXKH85dmT8dOmmveMxomwvsdVWkNOykw6W/qrzu2qQUKFJo6pKCcV4yzcbLcCbULM8TRtDkaNJ8odjZ0YSPNgukM/VzNNdJZyOOiIPS8oa5NAkVzpWJZvOxrBYitFmr5JAuNPL29gYbi/1n7krb+MVWF/K9IwDQ3RVrsgtKwTsfYs9a/ZejnlvQL7yNtcNhvljslcJeFsQG5smv95G1OeHIVAvw6QWseaUQuFnz6tdmIHrP61F9eI7IYsAFrPmJD033v6wwnb/xso+iebqYl04eQ+kHuvW1ztNWGTR5s9fIxKXvp9yBjjxsBb5GnuVL4nmtrABAzKxFNVIKd5fdVnj3/w77JmqIuBoWKjqDWB7s2FU4E1eniqkzg731b+Wn0m3fJMF4Bd1e/sYK97iS2b0u9uhrqTiV40bHfpu5kQQ53rTRg94frJevQoZgtIkssL5j3v9p9iAhbkIuOhaGdCNKmJMpTbtITlJNW0Voq7RwYUZoioqdTyKrof23IvguELXFmr6jPFdlXaTKGdPqmAu81nm/Lu8qET7cfz81zT990NEz/xwkmcQWJ/UMRQsQWONvZk52kR1GWayOQQGdX8pZxjA0/e/y8XinJPMmGWXZr7KcApBuBpvTCnXpnWAzDv1uSlFjYfgYbwq9QQFa3Vw2tCszHZa/t36mYjTzcLLwJf01P5R1j8jlppVL11SjlMdGW/H93lpdFcmI2Dap6kAeOx7sB7Bl66Vry349438ghHLuuaK4nNufl6yHUeqqq3f2VROyVznIDeu3nYnEmFSHZcXmsKI0gsr2rx5PT3I4eBXGoAS6pTlXuasHWOaVj2rPpA50tOkY3/jfj+ZmwZJlX1c2G2v19Hef06/ZxEa2pYK2GbRHDFSdaVyp1fo1KPSp2fxwp4MImDUGW+KC6hgYzAN
 YNfKpWQV
 ZFWYYsK5PDSMICAFqE2OEc8uQ8F0OJDbu+0ruaiEmRuRxK/HlRipK48PFz4Owz2iHW+VysbPxTx35KvjwuosxxXrLv3YS+MGMUga5je+nbfhYZHdUkrHTE9ruSpH7cpQSVi64eX8e6S9YRBqio6/ZS1nhiGixLS0QVH4evP19iOWL/84+XEQn/1Qeqkz3TVVkfk184PYpQ6xMZ8S2mBkbV4w4sOhoeK/SX0f4VlBW7r9FY8s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The optimization can race when multiple kdamonds are running.
Meanwhile, the impact of the optimization is quite doubtful.  Just
remove it.

The user impact of the issue should be quite trivial.  After all, the
race can happen only when the user intentionally setup DAMON in the way.
Even if it happens, it would be rare and only degrade the best-effort
monitoring results.  No critical consequences like kernel panic or
memory corruption happen.

The race possibility was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260621204050.10993-1-sj@kernel.org

Fixes: 3f49584b262c ("mm/damon: implement primitives for the virtual memory address spaces")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 33 ++++++---------------------------
 1 file changed, 6 insertions(+), 27 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index d10b8042adb5b..d487b7a4a1042 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -383,8 +383,6 @@ static void damon_va_prepare_access_checks(struct damon_ctx *ctx)
 }
 
 struct damon_young_walk_private {
-	/* size of the folio for the access checked virtual memory address */
-	unsigned long *folio_sz;
 	bool young;
 };
 
@@ -411,7 +409,6 @@ static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
 					mmu_notifier_test_young(walk->mm,
 						addr))
 			priv->young = true;
-		*priv->folio_sz = HPAGE_PMD_SIZE;
 huge_out:
 		spin_unlock(ptl);
 		return 0;
@@ -430,7 +427,6 @@ static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
 	if (pte_young(ptent) || !folio_test_idle(folio) ||
 			mmu_notifier_test_young(walk->mm, addr))
 		priv->young = true;
-	*priv->folio_sz = folio_size(folio);
 out:
 	pte_unmap_unlock(pte, ptl);
 	return 0;
@@ -458,7 +454,6 @@ static int damon_young_hugetlb_entry(pte_t *pte, unsigned long hmask,
 	if (pte_young(entry) || !folio_test_idle(folio) ||
 	    mmu_notifier_test_young(walk->mm, addr))
 		priv->young = true;
-	*priv->folio_sz = huge_page_size(h);
 
 	folio_put(folio);
 
@@ -470,11 +465,9 @@ static int damon_young_hugetlb_entry(pte_t *pte, unsigned long hmask,
 #define damon_young_hugetlb_entry NULL
 #endif /* CONFIG_HUGETLB_PAGE */
 
-static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
-		unsigned long *folio_sz)
+static bool damon_va_young(struct mm_struct *mm, unsigned long addr)
 {
 	struct damon_young_walk_private arg = {
-		.folio_sz = folio_sz,
 		.young = false,
 	};
 
@@ -494,28 +487,17 @@ static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
  * r	the region to be checked
  */
 static void __damon_va_check_access(struct mm_struct *mm,
-				struct damon_region *r, bool same_target)
+				struct damon_region *r)
 {
-	static unsigned long last_addr;
-	static unsigned long last_folio_sz = PAGE_SIZE;
-	static bool last_accessed;
+	bool accessed;
 
 	if (!mm) {
 		damon_update_region_access_rate(r, false);
 		return;
 	}
 
-	/* If the region is in the last checked page, reuse the result */
-	if (same_target && (ALIGN_DOWN(last_addr, last_folio_sz) ==
-				ALIGN_DOWN(r->sampling_addr, last_folio_sz))) {
-		damon_update_region_access_rate(r, last_accessed);
-		return;
-	}
-
-	last_accessed = damon_va_young(mm, r->sampling_addr, &last_folio_sz);
-	damon_update_region_access_rate(r, last_accessed);
-
-	last_addr = r->sampling_addr;
+	accessed = damon_va_young(mm, r->sampling_addr);
+	damon_update_region_access_rate(r, accessed);
 }
 
 static unsigned int damon_va_check_accesses(struct damon_ctx *ctx)
@@ -524,15 +506,12 @@ static unsigned int damon_va_check_accesses(struct damon_ctx *ctx)
 	struct mm_struct *mm;
 	struct damon_region *r;
 	unsigned int max_nr_accesses = 0;
-	bool same_target;
 
 	damon_for_each_target(t, ctx) {
 		mm = damon_get_mm(t);
-		same_target = false;
 		damon_for_each_region(r, t) {
-			__damon_va_check_access(mm, r, same_target);
+			__damon_va_check_access(mm, r);
 			max_nr_accesses = max(r->nr_accesses, max_nr_accesses);
-			same_target = true;
 		}
 		if (mm)
 			mmput(mm);
-- 
2.47.3

