Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7162FCA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 12:31:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B909A8E0003; Wed, 10 Sep 2025 08:31:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B68558E0002; Wed, 10 Sep 2025 08:31:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7D8E8E0003; Wed, 10 Sep 2025 08:31:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 960D68E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:31:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 49ED91A08B6
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:31:24 +0000 (UTC)
X-FDA: 83873276088.13.E702398
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5F78D1A0013
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:31:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=h+xr8Xl8
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757507482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z28D9iiY/FsctjTG9fO3hTbLrp0EukPX3101AmbRWww=;
	b=8XvOOJdhPO347zGjjOHbhTzKGZvJXvNyYEF3N+IxoRbgRvsUZQhgK5JfIdhBd6Z25bac+Y
	5doFp6exfEAcr28mRwgiJQ58xdC+IZJgwitRHK223cBrQK3EnBMGc8CSev8HUM5hh+NPjq
	AZ/J9e3qlYKO+nxXZCzNijTTM7xmc0s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=h+xr8Xl8;
	spf=none (imf19.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757507482; a=rsa-sha256;
	cv=none;
	b=6bYsXiBNH+19UBcM8pfyUSM0/lvKPhVex9zYO7PMFZDK0oBSPfe5U53otlfbiqlOCPx4lu
	jKOgIGjRmya6ViYUrjQsRfembaEjyqpOCaHd5EkvZnT/oifEqo5tSPtkbGB9izzABCKxNB
	PXPjzYNiB6rYBBIPXCLVqmM88QPKpho=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=Z28D9iiY/FsctjTG9fO3hTbLrp0EukPX3101AmbRWww=; b=h+xr8Xl8NL5B1jPcR+0s0aUg91
	KOVaBKIEZGQRkUtpKFNIYkVhS2HnwfGYOXeqw5aULyMFzXEl1rUq+Q1x9prlaEB0EA+hZ+c6dQjuK
	WWpQDIF5VGG32K21VLPvaFUvIgf2kQ/B+lX2w42pSpxFIO2oJUmp93gCmhiU7JquBj9c1WJ2I1Z9l
	RfjdTjJeZslIBLjUJDW3U/J19bDKy2jn1y6Zx3dbwegKMuL5UU99cPWdFSlXAwP3kK5d99Im9R+nT
	fY9w8FEaE4uV9CTtQ1WX+PMHEsAilj+HQ7wRI0P7FHHImQIdZ41F4wNGcCdcPPofKyUi5xRcu42p6
	oAru50uw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwJPq-00000008MFO-1Srp;
	Wed, 10 Sep 2025 11:55:10 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v2 16/22] slab: Remove dead code from free_large_kmalloc()
Date: Wed, 10 Sep 2025 12:54:58 +0100
Message-ID: <20250910115507.1991829-17-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910115507.1991829-1-willy@infradead.org>
References: <20250910115507.1991829-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5F78D1A0013
X-Stat-Signature: 85e53er1tofhiq31zsmdi7mrex3iqmbp
X-HE-Tag: 1757507482-4974
X-HE-Meta: U2FsdGVkX18PW2+tZWTbwL4MvrtOvwk5rdp0PU8zf4NyRakaAOgQFlP1ompFoqrw4NlYCutT5kNvbWnet0847EDC4k1pcSDI3qChHr3uyFtDOlaROYoz0EF+R4JqcJwjm8sFReK+pyQryiis5noqfJtENl/mo6kcRtBvY75MUDv+snsDQeaJ5KinXoj30hT+dTt2shVtm6pdd+/7zEGmTHCW1M/1oB98F6U8FhFPM5shmTrOghJ+Hpno7+mV0Rxhg/8aef0K0c0cYr4m1aURW3aciJKwDLnkzcpgrUvYGVFRKgwwRp9RkJGgi+QUgWbSvTI6w3XFCIOfbz3zBIP7bJ+c8QvHJRJxE/4CuE/imTu689oG8r+5uZ/GRmCdVKQz2gLiMs8MVutCuqBn65UKU96L93+VxeUN+i/2Y63p6BxSRJOSvd4/FL/7N+2yqDsmXrCxQKVdnBYKuNSUnnLDq4lOlIm16e/ovrGx2q4czjlCkKBZHb4fQF/iYnBA63kxAZgsR6cw+3gLV+UADglSI8o/IEnyur3fhyQ4aYODlY1aR6Yf4Hw8tPGJmXem9TQUgAFJS5FCU6T7+DC/6b4WrJJSS+gmWdrWEA4ZldkXxCESm8+3oFbtas600ggshvJh/sZtAtznWKMvHOUbuaxfSXZaXBdbZpd27ELmYa8OMKXRs023B+GWyHX4DekEye76SwAg3gDVGxl+dbqpPfI2Ktu4LIhalieMIhL17fRHCkpA+89UcF7ty74f/w9d1ewfRnsRigUOj3i/dEDmFisvwjmK04qfSAAZ7p6s0ppJz1F4jr2rY0s68r1ORgP4e/FDZTDyueFVrDuWgyQZT/DZdfjJvRfPTWRz/1fzpRL85O5p0p3/dtHkdSAHIJf27L6h3W5anNCH7GNT9m9q46HRCyXq9yT4Af+NI4g6F4nb/W8dUfZS1jQf8+5KPEH7Hx2Jvld4i14cjQlgptZ014d
 k5DpzX4o
 FQvuf5wX+amCMH7YjfG7eRrnhXKFz8Oflr+6LzQHhVJdED9XdELx/hA0JkysW3+mMVXsikfneaYxZHiJCGTJLlc55pANdnZb+F2MeCxoU/eVaETlS/YCuGQBIYe+3qwp8MSiHSdjnsGN6Qsu9q1aT4c71vKDZ3TzAt22LKoS/fEJPv4Uh4umzuC/c2g+RMqVRe8kGOJGIF7W65m3Wt+K5gq9Jp24X5/YNDKowrySAxxpy52851+HnEOh+iadriif/4oz2ahMmvo5pLGA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All three callers of free_large_kmalloc() check PageLargeKmalloc
first so this warning is now unnecessary.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 0f4e7a2a5887..523a4551ceb6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6227,11 +6227,6 @@ static void free_large_kmalloc(struct page *page, void *object)
 {
 	unsigned int order = compound_order(page);
 
-	if (WARN_ON_ONCE(!PageLargeKmalloc(page))) {
-		dump_page(page, "Not a kmalloc allocation");
-		return;
-	}
-
 	if (WARN_ON_ONCE(order == 0))
 		pr_warn_once("object pointer: 0x%p\n", object);
 
-- 
2.47.2


