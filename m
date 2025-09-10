Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88723CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:29:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E752C8E0015; Wed, 10 Sep 2025 10:29:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4CA38E0003; Wed, 10 Sep 2025 10:29:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEDCD8E0015; Wed, 10 Sep 2025 10:29:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B737C8E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:29:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 62BAE1A0925
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:29:33 +0000 (UTC)
X-FDA: 83873573826.06.CF32379
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id CC11080015
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:29:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KX+6OYb2
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757514571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mw6hcUKeijxyP4vVKHIt04knLqLP4Y9X/1rjcfbhF7o=;
	b=I4Pf819tJb6iCtW/0WkyJStqlGTbFWne7sCCJlqOzkmzpRK0xAe1Lnz9bpgIQXECf27EIO
	wQsk8oZgmrkSfMIsBS2mYyosSsmS53hUfZtn16rANVwSFJdldreGxoSZU/SBrxCBxPqouC
	cTYiz6AWvVev6AoUU+KddI5j1o0dcVU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757514571; a=rsa-sha256;
	cv=none;
	b=avRAQmDCFAtZttBhP6mJ8VBE1/z2eaplSgCT6KRvqtRpDAmFDdwsVRwXeQns5dn5zxu4vS
	g1wBdlXoSk7HNhTK4eWMssKJxrCW9vkarFyIgAIgoSzecAEcihyXr7qw1jU002/yz2COxq
	djlweLtJLIVZFpBvR09htQeYkT2+jMk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KX+6OYb2;
	spf=none (imf30.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=Mw6hcUKeijxyP4vVKHIt04knLqLP4Y9X/1rjcfbhF7o=; b=KX+6OYb2XMSbxwpI/kdZPPOs/L
	T4fSGIZGLUBbIHxDS4xywYounM/VDh2nV6iOFJ3/sDEICtpoarQXInKViCNQsXUEL1Q8a2zT2j3jV
	kWFfZp+ki8fpzKoShkq7e1sbCA9XuUS9h0esePcq1kID+adeAX3QJUzZfzNHFqEHz1Xl5LHEsiFhi
	Jo1wLUcYUHIX0PQdRsqtcAimH+j56OKk0g6FXvNjUa2TTKRP1CntCyjjfmz4SDRSsnzpAzBnsxl/t
	UC844vkD+8XRS9fxYMJniwndKitc8smr1zScsByqeeKfdsaux1kHoxvJ93pWvyabuYmTjSYxxKbbO
	0AEyXmyw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwLp6-0000000ALQT-1ZuE;
	Wed, 10 Sep 2025 14:29:24 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH 2/3] mm: Remove redundant test in validate_page_before_insert()
Date: Wed, 10 Sep 2025 15:29:18 +0100
Message-ID: <20250910142923.2465470-3-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910142923.2465470-1-willy@infradead.org>
References: <20250910142923.2465470-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: okmy85zuax7w5yf9s8qq1z9erboc1s8r
X-Rspamd-Queue-Id: CC11080015
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757514571-711038
X-HE-Meta: U2FsdGVkX19PnasLmndKFc9n6JDU1V7xulnggLgOB4PHc9yYM/QKnjGipt887FIh8neQ0x4k6prWC73X44iweTOfSfovbrljfeItQmfWZe6l/NuI+ibZMUj0Hpn7qm2qDg3Stc+UiSYrODsJCKvvAFUHAElDxJhknCgisLubZb6RWo5DaySB9bZRWbEPQ4e2SEOhNorjewNSOnQkTgVzma9I+YTRjYlfgIm7XHS/bZ67UZfZmzG3/b58TlMN/5z4xgklkz5UidQnFToGkjZlk5Wf0Xv5bBODC6SVGgVgxvGFxswkKgqth+u2gfI1L4kCo/aOX0qjfoG60CnKXdPBojL+EB7Bs3a+v6Zxrg9dG3lSASwfj6G0GK9Pl7H971VKyVEegRvGERh2N7ruRnxe+OZx6elhF8rTEyxR+JIZUgKLQnoBZovjkWiQLtMr4haXRRCMskeNs7mr/G4c/E+tjGJ3AaEjX0s5B4jU0MBgRiXJ+yj5JEuSkCL+jBQDQ83Pj4jyj47wdyDmxQlxJfwvML0H3OYtLAbeW64/qrdsxucHs5PbjK0A/6ENFOZoupDowjDCXanDmr83y6v9/K6mvuB/NPYMFMUfFcQI0WF1/tQq2P35yt9k0V6SVP2QQ7Z6pKneqmnl2gWHe4DJf2ciPyqOWadmJAaeAnIXPBJKAZTiKwOLD417EOyGgGDShvBdoya+VXS+psA+QVKajPiKkx2lTUOyymjiwmUr3e/9KgQpNyoHCz+6RqPisgSEUu8YX+jR3wxMlvPVBJkSCMBDJEgvJoXfGclBmjoLugqqJqoRQVbE8O9ekLRXJQGSySHbHT5Kh5UesjgTpaJLzRdE2c3j9uGr1zBfZieKdAN9LmvfgI3Fqbpe9VMBj50jUcnfd60+WMNRU8HO8TLwLYq+r5i8ODgKojI0AmGQY9AZkiS2lIu0jOIwe4x0OQOsn8wJqmelx4N/XWMBith/sCK
 ip54M8+h
 cWNT5i+N5T3TILnlH8FcxLl5loZezrQ6Qj9ERHjmhiZ/QETQ400sRNIeJtm1nZ8g70fHtjkQhIf37kJcV0DnjK2JixM8l/xoOYR5i43mDMSL4N3t4dpS62dw6SxKiwby3Mc1iot/wx+lCMPaOa2pVKXL25w/O6JjuZNO70m4566+Emd+rxTQUydlp0HN1eskLJlvd7jO+a6ry0midmGGgNcj7Yb7bJEwywpSfA7MvgExd57IxR+DAzv9gfyEL6VtxoXgorhELn46kP/FSeMDbHxpGrb1/9sH3NvNH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The page_has_type() call would have included slab since commit
46df8e73a4a3 and now we don't even get that far because slab
pages have a zero refcount since commit 9aec2fb0fd5e.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
---
 mm/memory.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 3e0404bd57a0..46fa459d9a11 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2268,8 +2268,7 @@ static int validate_page_before_insert(struct vm_area_struct *vma,
 			return -EINVAL;
 		return 0;
 	}
-	if (folio_test_anon(folio) || folio_test_slab(folio) ||
-	    page_has_type(page))
+	if (folio_test_anon(folio) || page_has_type(page))
 		return -EINVAL;
 	flush_dcache_folio(folio);
 	return 0;
-- 
2.47.2


