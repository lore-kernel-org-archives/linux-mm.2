Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2C8A606A327
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 20:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RwUuj8bJ
Received: by kanga.kvack.org (Postfix)
	id 5794A6B05B3; Sat, 31 Oct 2026 16:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DB9A6B05B4; Sat, 31 Oct 2026 16:26:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A3146B05B5; Sat, 31 Oct 2026 16:26:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A0BC6B05B4
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 16:26:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 77392803EB
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:26:25 +0000 (UTC)
X-FDA: 85384053930.11.DDDA677
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id E63FC40006
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:26:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RwUuj8bJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793478383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kOWWL3M+VZ5r98aKn5hrniliEJVp1VQubbGhe+wLkOI=;
	b=NXGBz5iXiPs3TY7xYBGNzaSUsF995P916F3hsnIndbgMTUucyHtr8Vt5O7gpQ6/7bVSFcD
	Ic8TPqO9vF2na4vDFKPchAn2bqrlFhniQNuHzveuleBzd7bh5YIrTSnBwqL2Zb18VmE1S1
	DH11LjOpo3HJSLy/MBo5AFqJ78NJdPw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RwUuj8bJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793478383;
	b=UvmTvLd7IsJM5dqvMtzzNTQe/jgfg7M+hFtIagfceeWQ7FGQeIEVV/18XW/iU82D1suE+v
	WgBvzVqAHXh+OR/3oPDIo6IPk+9PkW7eDZ076z0OC5WGQagrI2O7khp3PLHo+65wVWOepF
	N2sBLkXxWAJQ/NiPs18pLuGcosIEJoo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 843B860202;
	Sat, 31 Oct 2026 20:26:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F9B1F00A15;
	Sat, 31 Oct 2026 20:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793478383;
	bh=kOWWL3M+VZ5r98aKn5hrniliEJVp1VQubbGhe+wLkOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RwUuj8bJhrOGolYSTqKBJpONRcCmYDmwI/dbDHKggPP3UnwuRI1Whwuv/2KWvgDgj
	 OKnKP3ulpyV5d7iqrRdeWpE5RimU6BKA8uPisfPOUx8TqfFhPOOVsN7rw9dbPoxSbb
	 T3RLoE5bLCIo1geXJMPfW/HUGza3al88kA5YbokU0d98ZYQeSbi+RY/++2uRgKbuJf
	 BR1VIImWdvjeA3lwElWJ7DGVrToZRyDOytPnABYUhiuHhz8sQPXfXVXuYatfvdiZxK
	 ivSJgz3VwyJX4pa604MJW85gSZh7c+yuRu0Kd+lQ8hVmWeOZoQLUMAyHGf0SS67PH1
	 WRMNkItbY50zA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/6] mm/damon/vaddr: implement sz_filter_passed for migrate_{hot,cold} action
Date: Sat, 31 Oct 2026 13:26:10 -0700
Message-ID: <20261031202614.96036-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261031202614.96036-1-sj@kernel.org>
References: <20261031202614.96036-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E63FC40006
X-Stat-Signature: frx7caauk9pp6s5btu73utg8j3da9y76
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793478383-144879
X-HE-Meta: U2FsdGVkX191Ff+WaR8CiYu4qESAzKJ25kAYucN//05mN4Y9JSk0q/gqxZ++4nrXL/O0uhD03feNaB5SzlakiWFbMeDnNfRdEpZiSGXZpxI5YGq5EXMrX68gfITSELuviCVmehFoYznJm3q3/0+XQ8ZB4tP1EdrDvWeJoAztroiTD+XQvNq8Arqnhsj4AV3FbFlHVUTb/tb5q9/SkAxFXTbRMpwnUenCEX7QpZ+0rcukbAim1uLzKRo1YpMd5JoNQW3v6ju88bB6IF58cC3g5c/+9L66LAMFNd3Jchb2EY3o/krQB25BJa4mQkR/R+lG/JH3VPfFtnHwuJePDwl70ygmdc8mPabrT2fFrDBWtfdDJ/yOLZTsP/UoFaqP/5wg/BqCjcW81n7wYcVLbALBZ4JAMP04IhM1/DApnXTLQ7AOChlK8rPjRo7ivnDV4g0WGeg1A/V0soFipxMui4Znh8WZc1BQgP2VpagSfPKanv00R3kP1AzPI3A8jBB/Exzfej8h0WQs6dpYWTycChhOommpqFAMwRjbsb9RTbuxv58gwH8vWgePyx32eBwaQWVb0EyIsFZAJerH8QUbH/f1mBz9n3vpoeRbL9XVJcOmXi4GpOvCqtb43Y48ok6YE2FAWNlFsiccNqoxUYMyeaTZhQUQjr2LmEqDjQo4FKjWv5Sixz5TIDv7sdZ9R9BY9q9naNlvD6vNtHJ29R+hj+T9Fufl2VB3t5aDvyJONwVVOf1+ND2nCuTqwRX6wpwsdntM9NKdzuxeC5xj087QOqmQXeC4x454et3adfyVbuVVyufOtrULCDygsJ8q6Rf/vn0QeQlpYWaISt7O1ZuGIP/o9/SivB25FI3YJZmUfcSdNWwNhKGIO/D89nIHMK4YZLdqKqqo6UlbH5zv5TUJ+pnFRMKnzS+77xoCYVXFQWgjzPYYp/XdufzynDoXX1NwvQGC13oQNnO2tAMotQi31Zx
 UB7IsIy3
 0Xsj3kMeh8MFtHF3CuiSRGIwJXlJohGpBEBtBFOeH8KhbkG20rCu4aLe6w3rrNBZWgqeecHqsu9XhQWG9cGwDTB4dyD3jmro8LrV0LuVyxg+oo7OUCQIZ4WiQfTAnchwA7lRTz5ThjyiQcwMXLgkbBnPLht2ehZ6VZTfz2Tm5JbcZ1SuBiTfAfXK9zwga+JQ3X6/Wp3AbhVrXmb4kHn8stzpcgDnZe1JAevq9r41V0vDBDjn+wRpPkF+mEGCRaqQ6A4iClabQSBbLHZ38dBY9koVCKsTBvpKXbpAtxoNQB3YmpWLlf7bdaV2EdgIrQyMPc7qYUHipL3GVksQBybP1JCHYkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Support of DAMOS ops filter and sz_filter_passed support is up to each
operation set.  DAMON_VADDR supports both for only damos_stat action.
It intentionally does not support those for madvise-based actions
because applying filters could make it unnecessarily complicated and
expensive.  The vaddr implementation of migrate_{hot,cold} action does
support DAMOS ops filters but sz_filter_passed.  There is no real reason
to not support sz_filter_passed.  Add the support.

Pass the sz_filter_passed pointer to the filter applying logic and
accumulate the number.

Closes: https://sashiko.dev/#/bug/linux-986e8b64-8e65-4e32-970f-4d3ebdf8206e
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index c271b6d63c027..112095c2d53fd 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -776,6 +776,7 @@ static bool damos_va_filter_out(struct damos *scheme, struct folio *folio,
 struct damos_va_migrate_private {
 	struct list_head *migration_lists;
 	struct damos *scheme;
+	unsigned long *sz_filter_passed;
 };
 
 /*
@@ -840,6 +841,7 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 	struct damos_va_migrate_private *priv = walk->private;
 	struct list_head *migration_lists = priv->migration_lists;
 	struct damos *s = priv->scheme;
+	unsigned long *sz_filter_passed = priv->sz_filter_passed;
 	struct damos_migrate_dests *dests = &s->migrate_dests;
 	struct folio *folio;
 	spinlock_t *ptl;
@@ -858,6 +860,7 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 			goto huge_out;
 		if (damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd))
 			goto huge_out;
+		*sz_filter_passed += folio_size(folio);
 		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
 				migration_lists);
 huge_out:
@@ -885,6 +888,7 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 		nr = folio_nr_pages(folio) - page_idx;
 		if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
 			continue;
+		*sz_filter_passed += folio_size(folio);
 		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
 				migration_lists);
 	}
-- 
2.47.3

