Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC3C1C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 09:32:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74D896B00A0; Wed, 16 Sep 2026 05:31:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 725146B00A1; Wed, 16 Sep 2026 05:31:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 615536B00A2; Wed, 16 Sep 2026 05:31:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 414F46B00A0
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:31:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 875D11A067E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:31:57 +0000 (UTC)
X-FDA: 85219108674.09.E31EEB6
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9A2B5140007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:31:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="H 9elMPv";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=TunGcNhJ;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789551115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8kffjeZ0BbAQk8WNkrJMcG1UR27PMTOcUlnehRZ4hss=;
	b=4nhBq1XXbEvd3vfwE6Jye5IMclsyun1GxnIyr86u9KR0Nr9uniTkk3UG4HpkY3wNWXlewL
	BY5MsL15TraeaNn9FZyK0I/j0da2Yh6tIRsyQ+tY/hv7jnv/VciQmjwgyLlXuJzKExhNLD
	BADa5y6m+nEXVeJSXcwEJ95vmTbPNb4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="H 9elMPv";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=TunGcNhJ;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789551115;
	b=tt3Pu8V0NRDInwstDN37mSHvV7Ovl65bAHRev2RkEeFZQ5bJk3/WuP38f3lA/VHTyzk7g9
	5+yf/ury6bgoaCg5t5iRb5FGx9npjww7nvrrXRu/goklsq2a86DyuPgwjoIDHazL4KKb9t
	lDINYcgAZA42wge174W5vjH3j//e3Jw=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 875557A008D;
	Wed, 16 Sep 2026 05:31:54 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Wed, 16 Sep 2026 05:31:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789551114; x=
	1789637514; bh=8kffjeZ0BbAQk8WNkrJMcG1UR27PMTOcUlnehRZ4hss=; b=H
	9elMPvjJgiSJuYKab+0Y5yu987oSGjYEACb2aiWsREPZcMO/L24u339TXnzLy0sY
	BrwD8LAymA8MsPdbmyyGF2d3C1gsfNk963ky5/znSRAEQhTQTYaNp9CNg3YinTXk
	yu8XZPPYDeltgWfUTkXgpznVTVcGZxZiAUb7IPMCWTbs8/JBWuOSVed2TvyQjSXl
	N+njdR33I24+71rdDzxL9GLJ2gDbczy7xW5uvhXYz5JW22EwbFWR0Q+9F0TgucX9
	/Dfz6yUPGbyyGPn2yQq+qsKPcTa5416T5tdjS4z3PuDf+39UjjWPMi/UFHCpblMn
	SQVqpxDaA/tcWp1erBM9Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789551114; x=1789637514; bh=8
	kffjeZ0BbAQk8WNkrJMcG1UR27PMTOcUlnehRZ4hss=; b=TunGcNhJR4yEJp/xS
	6RdkSwFK2RxkFqK0H3jeo0GIGoLEj6v/AmRXZJ0KKKfAW27OEsKMq/zz+SSqTog/
	WUGhQbro6FWdR/IVZxmm+wnRhsOd8cCcA+PBgtHXwBHm01Gt6oGu6x/JGdUgYmdk
	vykveAJ72Q5DxTnuj5wIr4PQeL+TE2/UJsGJ7OIig17YuA+TkBHtLfGp1xdqgu7z
	CPyEtt3aWoM4RmPmXMq88lvAB5DzuB4E5c49FFMmD8KE5UeQO+NzD8qBCIYuiK+3
	AOJ5LCW1j4UM59S8ZC3bXSyubN8fLKGarEyExOYe/eb+rjO5VPE4ijtCas3BcrqR
	CdzNg==
X-ME-Sender: <xms:CmKqakJ_T-9lGR53O7s53BmxPBZCn8euYug0fweUNKry0hLknti4uw>
    <xme:CmKqagE6SyesxqJS12WKfxqSZnW6nJhDvVrTNcR64GUhjDhKP5qb9cQAWy4wUmNrJ
    fPu-QNX8bHMEkITzyHLI5C2hbEXuzvKIRjvfyVaWNpNL2fLVjQaFcXP>
X-ME-Received: <xmr:CmKqaq008mpXIwXUuNFU-BYkGbNfGUIlq0oBgAGqS89ky3NGKWW7wsoGy5A>
X-ME-Proxy-Cause: dmFkZTEOpyDQEfQMjLyldXBPAs1OiAaYjuycA/zprc2XA0sZE/gLY53LzRl6wisjmJsNcj
    shXh7L3amtO3W7Dj4gJ1brhV8efHSvbbvvisq8qNCVrU/hVVqWW2fJ8EDoeL9EfJt8J4fa
    r63UA+S0A+UN3c16swmwWrTj5sK0gOy7RYH1CN+xe4D6TTQ1ncSXBFkweWqSBfk0S52Say
    Dntsl8DI3TlZwS0igZd1iO+ltDo9n3qHIbwcYcvcbVUlu6Rxag/XK6s48+7ZTTYlI2aJe4
    hkL/jN/KxntOAh39VLdXeraBW39brB+PkStvfnz0wMlwqVlAhF3nsCCzTv21LQWeSF/ipH
    aSMoXw7Yrzq75z55RCiNMGl8Zjz1OaWOivnaPIGs8vL43WJY+7nhtZqGYOHlPycNBy82DP
    8yITUE0MSeu1TrcwigSUkhmilfFGG6a8h46LQ/DEOfydYCycrcQ6fVhus7GOg+CfLPs/gZ
    SVT0jtv4TBzMKs8Vnlas4qXYQdYYkPaLGWkFHKpFPQ8hjyhbQZdQvMxvs76toKTR60zQFq
    c9HC++mznhIBchm9YPND7TW+Gt5T2VRACZnh6SClCmaY7wc9WPa4Ycgp3A+M5swF6nr/0E
    ouHUVqUa7HdcMJiCcGWJTSTBoeMKxCeXXw7GaXguOym/AcnT1kp2xzykiKUg
X-ME-Proxy: <xmx:CmKqany0ldwpuWbIMrAOfuA6xMYhl_6ErGtGNW9lKdJHBZtBiJTYkQ>
    <xmx:CmKqapjz9GJ1iUbZ6_MIWCV2f0IZNax-0bsMS4X_j4XxPoIvKd6otg>
    <xmx:CmKqamzjbjLD4KSo0zghpBxhJ6EtrIwMpa6awB3K5r3nZYcax5SYaQ>
    <xmx:CmKqanz8uLOV4G1zrptcEEmKkURETOwZ2499qkrFbCQw1rjBzWSgvQ>
    <xmx:CmKqauJKRPOBurD-so1TYvWrx3RuTGnoE8Hf3Kfiv4oy4oYlgXdiebs6>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Sep 2026 05:31:53 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v3 02/12] mm/khugepaged: count collapses where khugepaged makes them
Date: Wed, 16 Sep 2026 10:31:29 +0100
Message-ID: <20260916093145.4022188-3-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916093145.4022188-1-kirill@shutemov.name>
References: <20260916093145.4022188-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9A2B5140007
X-Stat-Signature: t5i99fb5pi1pg6e1rwphj5m69jz81bwj
X-Rspam-User: 
X-HE-Tag: 1789551115-932066
X-HE-Meta: U2FsdGVkX19EU07SKaMmXholP2uR4WN6ez6zqBR+WN7gBOa//XIPTr35qmxxxQ2UhrNaKTSKJYfm/HiIxOfVujTtazgZx+2KIAkE5pLbZj0WKb41WjqziOjvIR2aoJUDqLTvg2FS7KOwUyhfiFaX3k2nd/ljBsIlCBdOrfx8u6mc3MXbu60c8u3YTepjdMUP2A1qzdXmjiqFJ4Vkox5H3GIIuACSSD1hjm5oZH2v2yD7EuvtTvvCFiPHGqEmxlIXyoIhQMb1pj2yJr9AogyFsMNFXkoMKQ+HLuGWP3dZOp3KwzIpzu91VCP/6YXXPx21AgwZEu05Wvdj6zcpQ1p86K5RZX6hMkbOhvIy8iphCOQzq+0QkwfocuKSDiHdrI3keMAb/j1MQP7QHSjbmpmEpD81J9CaqotPjTFmhnEw9pHteErNPK/x+vYwB7CrVeh8BSeBBVyHaZztZjoUZP7MHWROoeN0eLJ/hp7WPKZH2lB1tkHHL+d1phyNbQKHPt95VOMB2Nfllorpzm9PemYPa/6AILwwooyuIXXhsK4Rkz+dp2WDDaZ8K0f1U7Hu/QZrkDhh/kaHQgL2V1rCn21x1iaytCFBnGU1SfDb+DsldyLh5xH/EKc6rtnO4AySRZcvRZk2mD7SGETIDppB8Gt08YNiJTZo6SFW9+DjOSzrdPDSFo4Xy/ZlqhtBaDuaibRXG8JfUGwQ9d5p/KD3dRNL3/6vM4gyj384wfjs2w0Ivm69V46njuxKZu8JCLUdaN0YtvDbFlOb1hVBRWlBCsq5boqnyN1bhfFwdnynifiUpLeg1R/uKW8mxwHIRXAQ4LgSUEsP8nk/VYERiQg17j5N4fw91uKy8n5g5WOO5jfDUeNctsjOgv+wU/UIx8CE5I3+mtLkqhqYUEMA6TekCrEkcSgrWbTlgOyM8Zn0m35Jy2TcXh1t9irkc82/c8KtGCcvYIDyqe0M7tI+VJx/C6L
 WxHURNzb
 WkeQ6HE5HDZx/MbTWrXMgfL7iQiS7MKxZEnPaHUu2m2i3Aq2F8uvlgttfSpIt7aWht/5H6hEsHmboZ3ZcxSIyKORA9jgOSDqMTh/F5y0Sw1kU6rjsHxUul2ZAr68qUv7GAgxc2fFaCyliT1tuSSAX/tZPOa8VkR7siEhPdaeThl+4DWUFAPc+IQhlvB6xZiVHM/BrNLerCFU+RcBcIuKbxC2oAZLArB9I5xYwODdIUDdwggDf77AHr69zpiC2Z6UMq10nfhQ6SCLXmO5tOxBSS4K6QZDAaHCB6DCmwnfMOdjManv5HNOjFyDO8r0nzErdMwKNkZcWDMOZdneAW5fhrooJFLsyaIVaAbwq7Jqh6KaXAPaa74H20sFoXPbPbnfZL+tabw9mWdp60xl8h7aQKw/UL+3paeYZqZ0gf2vupdNKUUvrOxyQP7RHLBB4iU7lUTAdzTnNMYmI8I83hymaW5uFzkCJZr2gEjk0gvrSJamr9efZYX8Wb1jxDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_single_pmd() bumps khugepaged_pages_collapsed for its caller, and
tests cc->is_khugepaged to know whether it should: the counter belongs to
the daemon, and MADV_COLLAPSE must not touch it.

The daemon sees every result of every collapse it asks for, so it can keep
its own counter without the shared path testing who called.

Assisted-by: LLM
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 75c876acf527..4979a93e3648 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2815,10 +2815,8 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 
 	mmap_assert_locked(mm);
 
-	if (vma_is_anonymous(vma)) {
-		result = collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
-		goto end;
-	}
+	if (vma_is_anonymous(vma))
+		return collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
 
 	file = get_file(vma->vm_file);
 	pgoff = linear_page_index(vma, addr);
@@ -2854,9 +2852,6 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 			result = SCAN_SUCCEED;
 		mmap_read_unlock(mm);
 	}
-end:
-	if (cc->is_khugepaged && result == SCAN_SUCCEED)
-		++khugepaged_pages_collapsed;
 	return result;
 }
 
@@ -2933,6 +2928,8 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 
 			*result = collapse_single_pmd(khugepaged_scan.address,
 						      vma, &lock_dropped, cc);
+			if (*result == SCAN_SUCCEED)
+				khugepaged_pages_collapsed++;
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
 			if (lock_dropped)
-- 
2.54.0


