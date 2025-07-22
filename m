Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D38BC83F25
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 09:43:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E47C46B00AA; Tue, 22 Jul 2025 05:43:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD1686B00AB; Tue, 22 Jul 2025 05:43:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C72176B00AC; Tue, 22 Jul 2025 05:43:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2C386B00AA
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 05:43:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 873D51601B6
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 09:43:03 +0000 (UTC)
X-FDA: 83691411846.27.A6ECE8D
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	by imf05.hostedemail.com (Postfix) with ESMTP id DF3C0100005
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 09:43:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=Y0wFAmYk;
	spf=pass (imf05.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.161 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753177382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OYyp+w22l9XbkRdarGqCeCGaqwERoFSGzuOGfuq7M5s=;
	b=D9eJv/ffLlqvRlheqqsF2KxdOHPsA6O4QLBMtFn54ARq57dg9GuTvdaQWDTNAQnaB1uh6C
	89o0tzTyH8BECjZQqqZT956HisHXRWG0lBtoYjda58YsBRXo+MZAa/6VAvi9eWt3lGsqIC
	LDUJKXurrMwIvfMoOei+UxZ374p36q8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753177382; a=rsa-sha256;
	cv=none;
	b=iWGQOlyV2DK6G+nthsgqmK5qtdk4MgXHf4Dfw5jDUGfK3ZndoHaHPFd+jWOtA40ub1aFoQ
	MlnY3Aj4z82poFz722AvcFeTriwruKH3IVjAxh7HXeiuSSagDFg9lqEByWx+uVnkdfxPHH
	rhDoygHqr10RYvjzOzJEbHrKeN+eDhc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=Y0wFAmYk;
	spf=pass (imf05.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.161 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4bmXPZ286Kz9t5M;
	Tue, 22 Jul 2025 11:42:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1753177378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OYyp+w22l9XbkRdarGqCeCGaqwERoFSGzuOGfuq7M5s=;
	b=Y0wFAmYkHydK48RI/Nd8fQWSF3YLrfZXysTNb0HP46ej3v42HL7K1rEDJDXtfe5dfRIcbk
	A/rSON4SAyXNA0dp8muPL1J6PzEGBPCfOcOaO510oBuVXNfYVQlm6cYq4awQHv9s6J/twP
	RE5msPFF4rnlpEVMdPKLw6kZxv8p/3DMgzw0KAfGPzhTrH8fRUHFld8xQtNgwd3v69Z7g2
	0RYfYJuok6e4SS1R6fZbtz+HiSPJgT0o/017lUhkhWMPVAKSXGrCi4Z1gOp3IFixS28WC8
	NvH4TJJhBGLbUF8Jf/UjucWIrhfZGjDeNg6EFBV079IlPsUWHZawqH9bPpmBdQ==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nico Pache <npache@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	willy@infradead.org,
	x86@kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	hch@lst.de,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [RFC 3/4]  mm: add largest_zero_folio() routine
Date: Tue, 22 Jul 2025 11:42:14 +0200
Message-ID: <20250722094215.448132-4-kernel@pankajraghav.com>
In-Reply-To: <20250722094215.448132-1-kernel@pankajraghav.com>
References: <20250722094215.448132-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DF3C0100005
X-Stat-Signature: uzmmp8j4isn59j6mdroujgwk3i9feddr
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753177381-411256
X-HE-Meta: U2FsdGVkX19Whov79yx97dJkq17V56de02f4/bYZFDjFT5jaWGarF+8tWYVrty0GAeTP+K2vAK5yi8myGoIojkyUITzUtAsHuMqKQTAQsEu8QZl5HoJ1BwTLt0XoZBC3J1ZBzkxmbS7E61pkoNVZItauIqHAOy6C8KfdWi9KJ6r+i6r+eBggZcytGt7RlGQUyBNaItF1OtGRpuMNe3qFm3KFzBl5slkEe2n+t+aI3EY7zeBfm8Bt1OHeOpwev9qwzkGVCrByFguJRRGTS8y0d2uugTc4sIW3Q0aDQVyhaPrO+FTDPilh3POaCMzFoC4QfPnp1rZiqbn6Qa0a4HBx0PYNBPua8y6IZtukL2q4GU6XNeCcm6R1SVIxTOU8dZisHBJn0RRqsYKoKm//sEFBTTMSQjSNDDlxohQUDEhP13MhW0AxZmJvWJT0wxzpA8+JHEP181m3VQlor/7JWd94QLUharZ0pZQmeqsrbCu5lwPGJs0u3Ajn9/iEYYEemsXKSqu4HkvXojdeka0ezURe94L42AjKcBlmksrZLDxz0mbevcyc0mE++SXMABP9CfK9aQMIQsdvohH7fYMteIrbzNqML8pFRvxwCBjXzwaWkPYfdjXIdNQ7hZz8e6Ysj1qAXhl4WpfiVxoZHRWNGUPGeP7pgfTDY24xy0mTA3GYGkwQQLrxRlcZ/dZccpQBGli1Z3pVqk0Hx4yE3zZayCKqLLOEkIRq504ihPmnzcxw5Fh3mBZ8klCf4d1NIszdLPl6EMgUe1jYx+lC2yY2z9l4vS6YhUCTezJnsK/APycLjZQEJ2oB/K4kxC+dklVbPq2e3e3Nkm0FoScDjBh2RVTYxO1rtWkcGDkmYgEM74IR+YfI9jsvzvhzd1CrnMgSHbwSS9sgBgSKcIQFAAFoHyDlP2xKv96bmNiFtNNryoS3PXFVeR5tOjaV6HqibRvBNuKK466aZIzEgNp1YXKd7bH
 VKRD8v2/
 Dgm1mTubJrsC6HTPD28UwhACZbo9uigLMPfesYY18eeZ2QTYRYfASOADyX6AGqmffPeoPpvmuaSn1C7kPPPwE3BEoFfqWfv5nRQG010kz0DoQfOlvZKx3MmiMOzsIq/AGS/xLtSDXleinjXMToFIwAEEPdxEzGo/rYliNAVkoTnl2ypKjwujeNuC2HOOLWFyS7kKA3fajPPIfdJooPZg5OKRpwN+1FiywujsLluUk2OYdZZHuka7+ggF+BbwYwOWJIi4ch0rAfjnCVhFeIjc/s1sD550mPnxJOWDkBhzJ0kl3hfoOeXx2iBgjAG0w9W1iwRZtyZSQOisuU1PsCpW8ynqc2Sdl69Q9l1qfdrxHbyhNOV6AjEfJH4JpnqL8KVdorPvlC4N6qih1xXo/qqS6KIG3Ow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pankaj Raghav <p.raghav@samsung.com>

Add largest_zero_folio() routine so that huge_zero_folio can be
used directly when CONFIG_STATIC_HUGE_ZERO_FOLIO is enabled. This will
return ZERO_PAGE folio if CONFIG_STATIC_HUGE_ZERO_FOLIO is disabled or
if we failed to allocate a huge_zero_folio.

Co-Developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 include/linux/huge_mm.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 0ddd9c78f9f4..a34c5427aaf6 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -714,4 +714,12 @@ static inline int split_folio_to_order(struct folio *folio, int new_order)
 	return split_folio_to_list_to_order(folio, NULL, new_order);
 }
 
+static inline struct folio *largest_zero_folio(void)
+{
+       struct folio *folio = get_static_huge_zero_folio();
+
+       if (folio)
+               return folio;
+       return page_folio(ZERO_PAGE(0));
+}
 #endif /* _LINUX_HUGE_MM_H */
-- 
2.49.0


