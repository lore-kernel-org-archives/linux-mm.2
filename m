Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FB06C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:52:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 442906B00B3; Tue,  8 Sep 2026 08:51:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41A4C6B00B4; Tue,  8 Sep 2026 08:51:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E1226B00B5; Tue,  8 Sep 2026 08:51:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03C6C6B00B3
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:51:50 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C3B5A4FAE
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:50 +0000 (UTC)
X-FDA: 85190581980.19.05E9630
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	by imf14.hostedemail.com (Postfix) with ESMTP id BBAB4100004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="b QphX6R";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=EHwFmNFF;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788871908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QevT0gNhfb1/e5iwBM5FqG6u8eP9u0h4aKjgatgr0cQ=;
	b=DdIYPNbslkI/hBtgngOyjFXMFsab2XZDH1c9B8CPi1Hrm6IdDiZQa7+jKM2NOTfaEeM+dy
	HWrUFkLAULDSkheZcJFFyLELsyEF+U3hhxqd2GxkIo8T6oRD61kU78Qye1R5x1c803UhrV
	SxPVC6YsayNlabAuPim/HeOXu8LDFwI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788871908;
	b=GpkzM/HATqCcW76lAZXsiQBAyq2koC0bhu5bS5aTWEhwlgrlve0+zqrY+rOQAmJ/RApiSw
	WB2P5hFoYv4za6as7L9JAfEfjsRUwJijkaGGTsZrkg9dwm6cHGFfw7oD1wQmP4bVs5ro5A
	1fXkfFfKKiETm/B6pD26LnPox2mgRbk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="b QphX6R";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=EHwFmNFF;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 4FF6E1400085;
	Tue,  8 Sep 2026 08:51:48 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Tue, 08 Sep 2026 08:51:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788871908; x=
	1788958308; bh=QevT0gNhfb1/e5iwBM5FqG6u8eP9u0h4aKjgatgr0cQ=; b=b
	QphX6R+M0Nl+OyVvVdyGjVLXLG112HY5Fl1BjawRor878tYdDWUlossI0SWTjzud
	XtJtxcR03TgHGZuElnqr5kTmeEznm9csEzqtVzkp4TIR1YLJ1SgOzaPkycM5ZeZ7
	vqnHzEioqwJXmGIcNmAP+WtijNA3lQND/XNGePw6siV6Z1DbQBEltcl9IrjeEUT7
	xXxg8aEvx0TL7krBtd/X8mnoAynKOZrOzFeWy83o68SyYq/ypdUN8FQojM0l8STE
	KL93L9ogzWanCvCMGFTIqHSxeR7KcEw2VTfcadx6ASduSRyXETS/mtiHzB84mUB6
	TTyGyCXDKcPPEUSHLSYjQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788871908; x=1788958308; bh=Q
	evT0gNhfb1/e5iwBM5FqG6u8eP9u0h4aKjgatgr0cQ=; b=EHwFmNFFc/J5szbyr
	RwsXb0/sjKy1cgj3rGxFu8Q67pP8gJv0NyBl1AhEvNcfmUUiAABpPKhvYSRbw7vT
	8X5rZOO1fKTt9wDUvpD0nE4//SqfJ45Bsxtjk6nGJe/LEs7lK2Jv+KHxziBC4Rjn
	xTtwrzw8N1/gptNoNjJXon2kmgmUvWN90ZT6GyLKL1zhWqCXOtAU8mW8hbitfPUY
	YFq2DuX0IPtetir0fMysbCz232FHQgqTDplKUb1+0ykOnBsIyZLPmjgTQb4dv0F6
	UQNJWqs23tIAK+4dr/b6pXhxwkL0C9B/4veIc0yrx9893MaBG/kJuHPMCXbK66kh
	eKVqA==
X-ME-Sender: <xms:5ASganvwKO0KsBJ2NHIa8kCS53Nd4vp6wTa4BHHGti_u-dlQgCKwJw>
    <xme:5ASgag1_JYj4NiMDgFV2IFoJ3Zb_y8j0fsxzZxlYpYwxFIZK572aajLLRUAQOdUvx
    cexcumBBFFY8cEl5g3hvOs5FagIj9e_Uo0ioR6349QSHTIGqnm6C3Ih>
X-ME-Received: <xmr:5ASgas8e3TjI_p7q_N9S3l5kvCFKvK18-kpOd_N2VbLrPQGBWofELEPvIJo>
X-ME-Proxy-Cause: dmFkZTGRBbZq0PN6yNJcYWtVb23sO8hvfZDBWhDTIpZzW37zIX45AJS+7LON/4Xm/DsuP7
    98LWMNJ9EQApZevpiXRG4PtECFkYBq07HNHsbmmFqFvZsINLtRU27hF4Ez1zSV0tXKAKqs
    C6bKKyV7OM1sgQly7c8SX5vF/8ip2pY5lZQKXrVVPjM3l0q2o1FDhYukoyJ8Tn4JDDE8g4
    UFy6VPwfY2dP93OAetWkyJVBUK9bZ6BB4d8UPJ6t2OdyQWriXopGbxrEAGUlJNHM3pyOqc
    Zu1M4nLcOUMvR6qUcWJFuCnVGbGfObbOdENALiH6zrKToG6Pox9htLH3ZXrBYcmcnQ2gmV
    eLg2HMCEwaDQFvR7ao6VTgYGmzSfgxO+jmZweEamOLo17pvBTzTIP6vKjHGwRqfnOtMgSN
    GA7w5TbaTBipdGpzsw2y0cPuM27YNmA69kS36BwfG7mz28Po2qxCfKKwXn1vOqv9TQ3s6S
    cLEpNqa7wjaC6juDm3m9KDm1uN/OP74TUJAKKi+e6S2Ro1ho8fNmUd+ik7cPlgzAqD2bMz
    ST+La5nk6Bxgc0AcuxcCtLtHsQu0x0UP5aqhXZhV6gCnZ3nXgbcT/d5gaa9i2IuYxvBZ84
    nrSIkEkdAzC/kyYUIPPozN3LiSlcLcftIakPXmV+6+AFUiaZqEXCnWQ6SDxw
X-ME-Proxy: <xmx:5ASgauBJBrrP3AyCHqj-ztMzFeu46VZeKXSwoNFMg15A6zHFULotMg>
    <xmx:5ASgaqAdXn8x1U-6NXtOeM8ab-T0rFinRTcBw0wjIZ7g6SapKgNLvQ>
    <xmx:5ASgamK8Px2xAVS1UKHLUm8wbwh_CSVNpp8XfTVcINCZBC_KRlMUMA>
    <xmx:5ASgasTrrAFIA36FulaVT5inaRrdXtQk6zazZBW2F2IkuBhWWYbptg>
    <xmx:5ASgaojLykoUvw7Gog61D1v4z8QkYGSdALJHulII5Ff9P905UuudS_hL>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 08:51:47 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	rppt@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	usama.anjum@arm.com,
	usama.arif@linux.dev,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ziy@nvidia.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	agordeev@linux.ibm.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v5 19/19] selftests/mm: zap whole PTE tables in the khugepaged race harness
Date: Tue,  8 Sep 2026 13:51:05 +0100
Message-ID: <20260908125105.1510704-20-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908125105.1510704-1-kirill@shutemov.name>
References: <20260908125105.1510704-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BBAB4100004
X-Stat-Signature: k5ijsymm5kgqaf9c7iysywmwxh31nk1b
X-Rspam-User: 
X-HE-Tag: 1788871908-340597
X-HE-Meta: U2FsdGVkX19ESSopPNAPAq5MmWmx+HF9SvpCqdhq35tUc1XTba5kQOxyXQugwbSjWOkP1VPIB+Ynped5hFs1ZBeLhmexHt83YIRKzQRslvj7QmHu4fjYXQEF5BUAPrKEfQHXxOFP25BEuHc0XcAQpuLpDHdVhaUBcg1xO3R4xrS7XYQolwoVWfynbjkZJqb9FMrCCih9KLOfPCiy6uTOeCm4VSKHh/QnG3As6zwDDP/IAxxh4Vnfkrl/Pch85FBd1keRZiMARXg1j+z/4OZKneg3yvCdnAST2iYUyoUE2gCS5AKNwDqkjEw8HbkmnqNaRS8vSJ+Df0RC9XxoScZoy7YJ8cZ7FbWQp2OCidOq/KXgI050G9H2kvFCX1z1PxRP+GYqa69YNMrHSFtqYT3VXvwDk6e3Tf0Q6nruq3L2A5GVIcwECxgz5nO+FMcS+2yK8JRpr8WsahquIeWZ9GVY5hZncCt9Y4Cr9jBspadt4xVE2UF2U8QtCRnGH3bMT3BOa4jX4L67hTzdQx5c7LYfTXoFxh/pcwR/orkNvg5ruNvQaF8H2NISxhVkxnVaP7LKzlytheFFOqDURzDvp46unmhTDewb31is8P07tEYHPApHd5eCZv6Z99Oqi/ZclAwf10tGLtksTNlR+P+QJkXG9NW8u+vMjJQ5jD0UMv0V7KOfcU3OA1IOy1BVFd0+s5C+Ywpq1a5xQ8BIXoa2gDUbVkYUHfn9CSLdRshWglhDWeqceqLOMqyCP7ZAA/BLJ8RnV3LsrDJGMCsqBXPN9Ud0ogoOVTLly+oit/si1lFGjUjQo8qIjAFLuxFmOHX1qHBhfvY5FwY69D2GGcUdti2NCaJiLxPmpt7mNTaZI6GW4qf7ICdVfW7LhFq+PzeSGshJ92M7GBXys+qF/aZarCPYkWJiwx3LO9v3N7bkjbqrwCLZPSstdNS23FXHs4KqaQ/MqZbjpPy3oiGZnXJTn+/
 NyD0YvZh
 BVmSKJY1mlBHIBb29muACbFns/h2t3M7q0WyqO5QAsVBDx7lxAHkbJ7ONjHgI/I3aAQGpk/1dJJzGfkn1fwy11Uz7JvguxotkPU78N+fHTGcZwYwlHycGINQgWB2OqOz8rudoreLGJMyGDFrwvrmopa+Uezq0Fc5PdJo8vJeqGS+LlIE/Jx0nNjxio3nVH7GIAzd5mKw7bKOzL7DeT6SnWzPGTQWOMEDV3GnbaHDAcccOBkpJmmC6CHHlYoaErjif0Z0uy+ISAUCEkMTcKj5N6JXT483mUzBmJjiWmUtbwov/KhiuUU+WLuIvr5RPCH9QBAaHwUtIZQiGWt/O8gSVWvL7z8dswZD+tPHbTi8+MW3AOqBZ/PMV1KRWqV9ZQg3XQ8hxf3Bp54R7sEC+VUYNCi6rA9kFNMfT36LoJWwX0JzYqyLE5y9rF6p0mYRZSFQ4ZtwHrBzLqeKxH9/m3zAjjTlvesDomFLt3s2A71oisWuApHXAZ8bYIZaJGIPugEurfH3J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The harness's MADV_DONTNEED thread zaps 1 to 32 pages at a time, never a
whole PMD-aligned area, and only a zap that covers a full table frees the
table itself (CONFIG_PT_RECLAIM).

Make the thread zap a whole PMD-aligned area about one iteration in 64,
and keep the fine-grained zaps as the common case.  The new case frees
page tables, racing that against a collapse walking the same table.

Assisted-by: LLM
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged_race.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged_race.c b/tools/testing/selftests/mm/khugepaged_race.c
index 1f4aa23834db..c3478b5123e2 100644
--- a/tools/testing/selftests/mm/khugepaged_race.c
+++ b/tools/testing/selftests/mm/khugepaged_race.c
@@ -118,8 +118,21 @@ static void *dontneed_fn(void *arg)
 		unsigned long page_idx = rand_page(&seed);
 		unsigned long nr = 1UL << (rand_r(&seed) % 6);	/* 1..32 pages */
 
-		madvise(region + page_idx * page_size,
-			room_from(page_idx, nr) * page_size, MADV_DONTNEED);
+		/*
+		 * Now and then zap a whole PMD-aligned area: only a zap that
+		 * covers the full table frees the table itself (CONFIG_PT_RECLAIM).
+		 */
+		if (!(rand_r(&seed) % 64)) {
+			unsigned long area = page_idx /
+					(hpage_pmd_size / page_size);
+
+			madvise(region + area * hpage_pmd_size,
+				hpage_pmd_size, MADV_DONTNEED);
+		} else {
+			madvise(region + page_idx * page_size,
+				room_from(page_idx, nr) * page_size,
+				MADV_DONTNEED);
+		}
 		usleep(rand_r(&seed) % 500);
 	}
 	return NULL;
-- 
2.54.0


