Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FE79EFB7FA
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 05:12:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5F266B008C; Tue, 24 Feb 2026 00:12:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B36926B0092; Tue, 24 Feb 2026 00:12:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A97486B0093; Tue, 24 Feb 2026 00:12:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 974EA6B008C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 00:12:42 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5AE368B67B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:12:42 +0000 (UTC)
X-FDA: 84478180164.27.EC20A11
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id B866F8000C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:12:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771909960; a=rsa-sha256;
	cv=none;
	b=tOmu+NsrTrsMtUxNnSoWXG3TKH5VnhtgqoNEO+7j7r+ORDH9yfesbbyNTIrErFyZOgET9W
	NqXZxlMFXbfb60aLq7IhdA8rGo1hOXxfXX9lo3Pyr2d7IJq7PKvKBXi3ZNFdSssG0KJfQk
	c/LsyssXXJ9V17AvGS2cRK9SAxihxpU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771909960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qLhTzKtdbXIm/8qAUkJLODhrMb/B50HEdj961gOEOsw=;
	b=RRZRoj7pv3lSkvxtK3+tN68RiWzFrWIJFq3oNf6P0sSv7hLqH7kpcPSYppQX/7G/Ii1KlP
	NL7PetUXrgDgvBi4MhTgNFzPsvit3nQb82QNVfUsaA2cBGGEmCLIUwwlbA8KDrWfCayjSX
	wHNOG/IR40mSVboibTYX1UbKRpujTXo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7AE95339;
	Mon, 23 Feb 2026 21:12:33 -0800 (PST)
Received: from a085714.blr.arm.com (a085714.arm.com [10.164.18.87])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8FBEC3F7BD;
	Mon, 23 Feb 2026 21:12:35 -0800 (PST)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC V1 03/16] mm: Replace READ_ONCE() in pud_trans_unstable()
Date: Tue, 24 Feb 2026 10:41:40 +0530
Message-ID: <20260224051153.3150613-4-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260224051153.3150613-1-anshuman.khandual@arm.com>
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B866F8000C
X-Stat-Signature: x65oazu95fsao1g5dyb4gnayzynxhje3
X-HE-Tag: 1771909960-75363
X-HE-Meta: U2FsdGVkX18hJbf0S9v/jJ5hGHUoMRrDUivqBg5OgREodi7lzD70d/3Yu7IXcKI+V7EPJIMB+ssDF4SFXcJ9K2fBl9yC4zkhvZK6ascpQwl4lk6fOIOJmNN7Lx/QETbHsK+OkFpK6WYZKCGj14Y7L8QjhU0Baty1WEoAEsPj7WcFs0RdZnkEHbUAKjLt6Q8STmD3pjlI2rlreyuxqXoKtiB6GjeHfodSwEIruQMWw4pLKtQwwz4vXwC/hB7gVR67hnhv/iwAhBphN0zr/7psVjUp6Rq2xXF+W9XJdWsbXVGu+rz0n+EYzoByP4XN+6uibbD6hg1U5KeKHHB8suNFFx+0p7FjAbfXcIP0I9KwFPItozG+6OrvIa2Y3+Xj9fty18o1XLv/GLCz8Qgt47N4jtn+ivKT4cDvz8H81OWu9ABjne8o9GBOSn3/H8gMlxCfjQVRBguDLwJCRIhn2dSA5bPHsGt1U/hy+FJv14ju+N08/fIKlw7VVYssYVBejPeRHx7nXnqizyZ8EH1fZvhcqQ5cvhhnsBLWNeVZnsbMRTbX9Tc/JrXiXwVwPRvEU9J9Cn2Zy3pmALf/gzzVgZxNKYuHvhBEMuubAmUPSHiwe2Khzwi/M1PnhIgpI4Xp4SnEmfL4lu+tBS0brUC9WCE8BTqaZW7FwOq8hbBYJFEMt9HkUGMlCFDI6BBhArJxFGRNfzhJBOMSKR79HQ6LoqqFLtPm/AhBoEMK1g62cGEILC3SzbM2YQ8daVe8XeeZRJQYxYEk4giZDuwQd6Om9jHj48Mk1xFvfPne/3j49by4tHfGF62s8S2cedaKyLiS3TptISIRzRUj6rwRuWit5Sr2DdGY4OM2777Z5SaO0f7DpLwF3FMs92rL22zQJHGb033uAhEFJxqDuRHqOgyhF0FRj5RfZRa6zruCoEV5M+pTvNikp14LtPvgb/6cRYy3qEsQfhl817/Hno5HkC7HrTU
 Iql80WzB
 GMzqcWqf2qCRoNGW3d5SO4i3b02wkdSu0IHDNLTNyGR81KUxoYuZ3a3RkLneMTQswAjv+4GwVQj+OAAu8mwGGAqk17+FLGmPUoxzQ8JvAfmD0dOA0toICd2tLxyUhHlVNvDSgV1dHi2WPfNa3BXPrOJG4JaFP3jCY/49sUwX7JzPsKKPx8qqyIENj/T2c/gXRC7J80d03BXSVhrEyZFAHUo3dhXyC9PoI/iW7PdRrM/NJ4uOsI4oex1O8u2+SsBtTqvdLpwN9CvhinI8rEVjv21TMzWJyzzGrpixqr4rx8D2MoG+20TCgaBrK4Kof6Vkn5NThM83FR2A8LwDjiJ3evM+5Hvl0HaNL8TXTDSrRQ+pyuMUSN3nbOh03wyyPlJeva4ilxAYlLP5nFf2+6UhQGTZSmg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace READ_ONCE() with the existing standard page table accessor for PUD
aka pudp_get() in pud_trans_unstable(). This does not create any functional
change for platforms that do not override pudp_get(), which still defaults
to READ_ONCE().

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 include/linux/pgtable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 8858b8b03a02..397a0cd99ebd 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2008,7 +2008,7 @@ static inline int pud_trans_unstable(pud_t *pud)
 {
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
 	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
-	pud_t pudval = READ_ONCE(*pud);
+	pud_t pudval = pudp_get(pud);
 
 	if (pud_none(pudval) || pud_trans_huge(pudval))
 		return 1;
-- 
2.43.0


