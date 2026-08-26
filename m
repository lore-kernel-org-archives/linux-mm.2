Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AD70C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 16:21:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62B746B009F; Wed, 26 Aug 2026 12:21:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5678D6B00A1; Wed, 26 Aug 2026 12:21:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B93D6B00A0; Wed, 26 Aug 2026 12:21:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14AEF6B009F
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:21:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 96D86160170
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:21:17 +0000 (UTC)
X-FDA: 85143935394.20.DD2EE4A
Received: from fout-a5-smtp.messagingengine.com (fout-a5-smtp.messagingengine.com [103.168.172.148])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8E24340008
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 16:21:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="B meRnk7";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=ejWpx6J7;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787761275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cmrzZhAHwmnHLQBSELYH9/LSX3qgrbPWDwY3dINu6j4=;
	b=KJCo3YRFDP71rWc1G+BCk9xr9dfM9AY6Qsbmfz3iZpisyY486i2w8JKU6c/Gbtdby+24Zd
	c7qop/v/GXYU0YZ/zsg786OeWVQSLIY4JdMyaFGTvokIt3LXt59k7brVy/oFcn51e/xQxT
	dfU6iq9ISyMxsvGF5GCadgFg8D1iYsk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="B meRnk7";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=ejWpx6J7;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787761275;
	b=QqI2U526pF9MOKaU0/9tEy6CaT1vEBBWgWHiS63E4NLlDxSYildH0sSbuHNFoqFv633jAb
	sqWJ7jHfnwjBwvYkzZMR/Ua9DLEqFoUOY+/ZED27QtIzg56MUPY5zr0bUNsZJpyOJ8TgQl
	wH1Fhe33HM+pe1S7jBADLNPkeO4pW08=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 285D6EC0187;
	Wed, 26 Aug 2026 12:21:15 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 26 Aug 2026 12:21:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1787761275; x=
	1787847675; bh=cmrzZhAHwmnHLQBSELYH9/LSX3qgrbPWDwY3dINu6j4=; b=B
	meRnk7i4/XI6KegV4BZEImI59VLKXw56YnzEOvGO60CiHc/uZ0nK3d0FeV+gneIS
	AsCJEzxlGtqIIcTRb7JtFZr3lVwMHVVBia1aKLipF8rLPxtE/BZJ2llc+Di39fjH
	0SHDWJAUpha2tPTqv2kzT+fjhHmituWvXa/WGvus10su3zy5A4tbPrlJg88NJM4+
	Tet64WCgoSq6V/Hj3p7D3TLaFQGCcGB4rNTYR5mu2gfklqjI8llvcxyC1VCs2Fwq
	KFD8cACcyFcUN6y2XeOv5owWiG99hFtFx0hPhHUYrZ8wkUQEo+WgX3zBWSbEj/ZH
	Ico32Q6IDdm34t7qqqw9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1787761275; x=1787847675; bh=c
	mrzZhAHwmnHLQBSELYH9/LSX3qgrbPWDwY3dINu6j4=; b=ejWpx6J74tHAufMpj
	7XLoWM3bhhjP5VDG2DonuLOvsVTDCUfHiM/TQELLPmrRCauui2mq5meecCjvHMh7
	pBdBOJxVQ8TdgZtvg9CXHL3uGyAx5X3YFtfPvfYP0S/BfP9LgBOSuAen6ofCvKrn
	xuAHMDxyrqQ2/EItGd2LQmeUC+VfGj/aDMlu0IDpiBnsilATuA43TbgfFV4smQgi
	nGToQ+RhfUXiUafrBnjp1leXQc1PSnSLF4+5t0QLzdMdGeo5G91GbmShShb0V/hx
	koLzVpMyxIHh4e+RzgelFvN5aBnyjfv0aPFBapbKyQ1+7ystv/k4f9pzuygnn+bh
	cF+bg==
X-ME-Sender: <xms:ehKParUrAi6KUwnPQuxZ3-i89pzC_se5A4PwMOiLm6gqObP5SAIMVQ>
    <xme:ehKPavj4URSQjRjD9KfzlEUh1IEmvQQxlbMoKO4gJNdAXiJtVh1aUWDmvY0XmyFZ2
    Ed5yQ8kJr4h-y2hQg4ScuNbQ9NQtsNM8em-8bSxMI7SzfGP-nQpiQ>
X-ME-Received: <xmr:ehKPathtF6SiQXAVa7JbMgcrxDlMytISqqaAxlHYoWXz_lLZOrrUTpr5QJY>
X-ME-Proxy-Cause: dmFkZTGQoFXZs8CLrQvTbejM+lWkhdLg/uROFwJkkdATYglJQ9SHaTyPScF7WW0mNphch1
    eVR3IrwuHAkanmpAerNXc7LEOghrHwcryVnAmLgLIPaL4GXTh6Gf9eXsnQZjwVJHef9Nrs
    XjK6EHbPUOVKLW/G8KjWjJxHy1OYo963c/G1BhHZSIx7ZY3LwB604TzNS8Xq6Jr9ckMbkE
    MjqIIDZQsE7p6THO4ictYaMIpGXnlY0dQOoSn2w6WTw6bO0i0q9IvWAu8XF2rUmKLTGyRX
    Jqh48bYKYtZOalk45de8iFcxpRok1lQ08CY/mb9f5H5y4UZckNDJztfoueevfEh2JUVUGC
    +JurL57VI/e9t8xJ+DvlYoK5+RPHFB+KTXBB0wuGkAGhVihP4/91L/lOXPnfjTfwFQZtKk
    MsQ3k23yS8R/wi8BqJXmA8KNThEVnTLIO5sly5bbA6OKBZFExvsH5Cl809fLcDFgq8Y5hA
    VMpPXlVduTMKmryDasnpsybR8RlV94zwLi/L4ZHralLZT6A1UkzqLx+2JHoOymZkSZP9dX
    Dy5HDmpa3RMiVa6+NAcO6voerLSaml4zQlx4aExKoJKq89N0u90cHlsIzTEXU+TBahhHjL
    vdHjnNji0oNR2j2D6qMRCrWNuc/ucrjf0i7EHE59Ixaksz6ruCC0AAfmS0Ow
X-ME-Proxy: <xmx:ehKPasutb6Ae41bAnzEvoxlE0bZ0eBPVLuU04crilIxVL2zsyyKVmA>
    <xmx:ehKPajsUlfNAz7JdrR8o8Q3K9Rkxtf8tlVf6zjLm5oPO5vlzLOfbGw>
    <xmx:ehKPatM6MxTHsWTDUy35vXtYhFpyL5vWytTIjO0OKw2Y1YIh-c_uWA>
    <xmx:ehKPale9zB8c4D6SZ36XO-TsdLl0ml5DqHW_qjh4-99WTSW-aB8yxw>
    <xmx:exKPahfivdXmOC-ctgYtIin5LKLPfjId8UmF03lLRUgyX5bkO0esvFIr>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Aug 2026 12:21:14 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hannes@cmpxchg.org,
	usama.arif@linux.dev
Cc: lance.yang@linux.dev,
	ziy@nvidia.com,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	liam@infradead.org,
	nico.pache@linux.dev,
	dev.jain@arm.com,
	ryan.roberts@arm.com,
	balbirs@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 4/5] mm/huge_memory: fold nested ifs in __folio_freeze_and_split_unmapped()
Date: Wed, 26 Aug 2026 17:21:00 +0100
Message-ID: <20260826162101.1314941-5-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260826162101.1314941-1-kirill@shutemov.name>
References: <20260826162101.1314941-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: sydw7yiree1somdu31g97mg1eayn9843
X-Rspamd-Queue-Id: 8E24340008
X-HE-Tag: 1787761275-900519
X-HE-Meta: U2FsdGVkX19x3QrT0b2ZhU9CenrWwWmf2NQ67Loh+TLAB4WUg1Ma1gbvOwH0GbpJSKM3OykhyLmRHYDc7Sj7NI1cQtHoeBz/ep40jbqCt204CHFAxPh22BEWPbIkxoK+/mIFwEASTJzINks+sUlcvw386oYHSpXNaA36Kmkf0AtAB9iDw2m61iQWFBPut1Ul7Va8rBNLEpKTL1VLjmDBM7z3cyW33t2LFrftBoz4smzzBYUAGAsP3TdwjMYp+8AX/GJh1HjuKgwg62ii2QnBvTnPhXFIB8KsESHWRfG4dnh2Gf/rwnNLkufZ6q4UvFT6Y6IFaO3kwoRvo+HtE76kPGykk0EI7eoRW91/IbkXBstcETSsXDHkfxk/5KfGkXs4fb2yfrtLCmgn6hqrbIhimT5KEMWVm/k55a4P4ZPr7VtgHqmipeQdti4sAPFqa9f1THeNowol6kShUju+PMQ+rWgjapbY2fEK4PSlENmOrTVcurFEsWRcFkm1+R0+oVnTLEOQsX/utm3gQQx4SfafTU3r+VNh3ehfmYj09sLwgnCn7QOogRBYuNr2x9dfUAxUtC77XNwBfV1RdtMH4LYgLVgkHW8InFSmHMuuUHeAyicR2xCESChG3BLGYUfqbvZvPBJiQ0LbyUrKc5diHaaJc0jJ0yC2/pWMjmCvGnJGtcqP08MnvaGoYjBNWQFT7FhdI3zJSJfb0Y3zOGrvrSswooSdmDsK4KI/VPrflkoCILBdJGJIbZTT+fNFcvKViuSfMsRAoK6dpIhP4lFWOyKSRyZX2n/ouDEB2vGu/kDO+6dGSjF/bZ18JxPLcbFiYfRse8Ki/BWb8KCoAubIBFBVp448YSRW0EX5+i1p29H6J5jGWMCAVq6G9FXoqWn/FIg6r9KMNST58B7s7EJmHcxzNSMLPbYIr0eG8C9LVTACXwJzNlsM1RPHwfDKpCj9NKws5usroj4kDEd6FqFAl8l
 t50CgLAo
 XJM2/d6YDPpBuHX3KlkvmW5xH5IPfF8cQ1TB9zez8yTpy4/VOMAckGptYH3cjxizMAStymfFd2FX/1Ej8Hwz9sibbX3HBQ6Lucp+fzxDoUoBnw7cGpmFRqA/LWCJg/uJEgP6QlCPD+Kwz/auY/JHtpZkSlxnnoUhU7/plh/aI0LJdBzCRTTAalmp9jUayuRcAjD1W9oS3Sej6GP41Luvnu+jCNbkEmFyQD4wTnkfGCwQZtRvOe2p7o7bb1UjN0Td0dOvDdIdBJAjzCYMvoLM2jkaBgpczyYK6TQx6+HW8pSgJHuvEgeUvUafZQUk9znULdBgzZmbb1nAx0i4C4hgRquEN6R/HeY6hH054WCKwe/afaP0menycgcaAR769r8f8u7y9sisbGYrUJEEItGo9R6h4R7b0FpnZbCdWn+YvlRPUA4uN+5CQWJitqT9HApH0UB4sebz84f8qm/nQjZEc0r2++CmZ7LAX6V3bquk26YoUwEA8LAopz+Z+ow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The two nested conditions guard a single statistics update.

Fold them into one condition and drop the braces from the
single-statement/single-line bodies.

No functional change intended.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/huge_memory.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 36e90756e83b..001d89c57fa2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3955,19 +3955,14 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 			      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 	}
 
-	if (mapping) {
+	if (mapping && folio_test_pmd_mappable(folio) &&
+	    new_order < HPAGE_PMD_ORDER) {
 		int nr = folio_nr_pages(folio);
 
-		if (folio_test_pmd_mappable(folio) &&
-		    new_order < HPAGE_PMD_ORDER) {
-			if (folio_test_swapbacked(folio)) {
-				lruvec_stat_mod_folio(folio,
-						      NR_SHMEM_THPS, -nr);
-			} else {
-				lruvec_stat_mod_folio(folio,
-						      NR_FILE_THPS, -nr);
-			}
-		}
+		if (folio_test_swapbacked(folio))
+			lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, -nr);
+		else
+			lruvec_stat_mod_folio(folio, NR_FILE_THPS, -nr);
 	}
 
 	if (folio_test_swapcache(folio)) {
-- 
2.54.0


