Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABB43CDE009
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 19:50:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7845F6B0095; Thu, 25 Jun 2026 15:50:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7352E6B0092; Thu, 25 Jun 2026 15:50:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FB726B0098; Thu, 25 Jun 2026 15:50:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38FE56B0092
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 15:50:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B338F1A029D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 19:50:46 +0000 (UTC)
X-FDA: 84919477692.30.2428F9D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5F7B440004
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 19:50:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Xief50MD;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782417045;
	b=UjJLt4kOKlcrT/Zrly3a489cd1YBKlJHUOrT5Lb9q6vtP7x5F7VJGq30oVk3YJpNqmFWOt
	CYYJ9jJMTI+M/wvsLgPpkhrbMvZJR3gKxBI1Bh62F0xtu3hUf3q67Ql4KlhNLMfmgGx9MB
	plz1/7yfK54V7q9LapdwllV3FrE2dEU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782417045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ov3fxeng+pIb9RproGBfzavxRfhq0JozREBHnmbT8YY=;
	b=JTsNPfbq7NLzJRLDPCx46w8xm0rMXuAX7kvg+mVchzI7akXm7DpM2LbcBUBgABUiB/PG7g
	I9G7zfnEqPU0V7xMo0AoiPe0hqKzhSbTeN/md7k2olWTp1u0pJiwozjqTZ51YyuAaADg/0
	IGQYOXqvGnI+wvcabV3lfhq+0QjZNm4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Xief50MD;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=ov3fxeng+pIb9RproGBfzavxRfhq0JozREBHnmbT8YY=; b=Xief50MD9ExJQdKQqiqSfONr0d
	aGVPTyhlshlmA/X3+OjEGUepWhYPbfig9cakd1TQo1JB+nRPv3k0dbbMNRhNpfY9q8Hz5comWtBWp
	8xFZnd5M50zdYLQ1cCtfSa+cQdnfLmS2c23yVYeA/plebd5D/D4B+3OoZ0l+Nosx0t8GBvzPI8UG9
	d9STKN8OB3GKSAmUXBtbRBG88/P+PuGdNA8wab4wom3STRx7mMAnsX4lQv6HoasXOmdqEX+puIVac
	iEwSV77HcmtkfEL5ZKN3emwFfD3bTLQjEmZnnyyhwNrVvdndGn8rGbJ1XYMU5K8l/h1/Nb3WA4WGY
	gpnMq6bg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wcq5y-0000000AWXm-2UVJ;
	Thu, 25 Jun 2026 19:50:42 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 01/11] filemap: Lock folios killably in __filemap_get_folio_mpol()
Date: Thu, 25 Jun 2026 20:50:27 +0100
Message-ID: <20260625195040.2508362-2-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625195040.2508362-1-willy@infradead.org>
References: <20260625195040.2508362-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 5xeshrqzp5cgk16mr6xnn3fmefg71ui8
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5F7B440004
X-HE-Tag: 1782417044-240717
X-HE-Meta: U2FsdGVkX181sJn1DmNBtV5GcfRYxHK3Dzbr4ysj5mAFosTdikyy6gPqTEWMR9+rI5u3PcuI7k4mpVNb1uZHgtmhNPN3B4M6S/M71rFZF34hC3iUYCiYVfX6ciQBWyrNwUaC3Bn+OOqN54r/vvLP4VfCu+jLHCy2vdenqWh8znNJ4CY1tzRRa3zW1u8kciQdt5OpTsywhyeIqYL0UKMp6qwAyhje5q5FtgEDhE+/LXwQv5y1SHcg+z810kwY4ousPfpET/qTTh5pbef16ghvTPDu//CB5QV40e1kpGJSW1ZUgpYoXjKIoIlFFCi2oISsEkhiENeD33UR4FY4M4N3q0CT2CEFbfIBuSLP6fDlae/1kCCypr/yrm747dWtX1yUv4iqgAGTYfaZGv+hIpNn9YD5NIXwgIxPjcOt3X76nxOsUeWlYs19MBQtmZSqYkKkuhPVZ4aMommFalbJliHLQ9mC7+DI/eSXSUygI4RNxHUgohrDzwcw+d1PJUTRX2iIBC+pQSNlg33cMwB9m2bEXRFH8o1IdDKjXBrzDGb6Bq5YH204xIy4dBV7msri6zluBoe2dyMpXxykeXIASOfZUdOB/X4T/AOjpjoqJePlYaNjWJojJYXgubLbhq6pvIe4vJ4uttFbD3ka6FSjYPBYubaRCwGORdRLgERvBtjeGEmu3iCM71ynQrP0vFLg9REZKpCW1/4J6gq4X/dGplQssU0gQfOSxUHaM77E+ppXic5ZR37s1oduGgCsDyZAzkDGe3ECFtGGIBZmefZXUXSp9kbOZBzrrCSNc82udJ0p7zcq+LkbfQzMiW70+Wz8nq8y1EEduqpGuYshtAhVmyq92FTX5yWl0CHEh1S5odKCPXQeTWpFUewkE1CSVSimmVEL+tVN7rRHkAl9X2zwkt2Md5ZjbLdnW+PZsWC86g3iwEUj9fxAzxZ9E3W4UlqOx0Xs+93oQ6qr8MtEAsebJPR
 ZHbTVXcr
 MF4esKZbgG1cQekSuDfdPYs4hp3Js8xqPS52r0WIEjOS49S5aGOmutVzn6HwD36LJbXQWswHRZVC2wJjWI0MNtNBDhdO4uyoYQnr1p7isi9TKksFa22hZusmiphdKvnRPan4PlaEPCKdMCrco8BY6DRttO0SdVbcuipiiLVuGimJiNvFNitvEP7gOvKDCJkPujFk7MfcOz1lP/XVkQ5lSvzGdAStkUbnTgIKbvnHPy+IBmKZl+aHoGNzxzpF6m67o83qPAq5NqqQsegoSwEB0vxIUZMWELJuec9oV8PD/lHl7HBI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Callers of __filemap_get_folio_mpol() have to check for an error.
If they pass FGP_CREAT, they have to handle ENOMEM, and if they
do not, they have to handle ENOENT.  They should all be able to
handle EINTR correctly.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/filemap.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 5af62e6abca5..12e445a139f9 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1957,7 +1957,11 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 				return ERR_PTR(-EAGAIN);
 			}
 		} else {
-			folio_lock(folio);
+			int err = folio_lock_killable(folio);
+			if (err) {
+				folio_put(folio);
+				return ERR_PTR(err);
+			}
 		}
 
 		/* Has the page been truncated? */
-- 
2.47.3


