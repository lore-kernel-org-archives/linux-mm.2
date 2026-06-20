Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E7E2CD98E4
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 17:23:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2E366B009E; Sat, 20 Jun 2026 13:23:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C05F96B009F; Sat, 20 Jun 2026 13:23:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA5B26B00A0; Sat, 20 Jun 2026 13:23:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F9D76B009E
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 13:23:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CBFBD8C69A
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:23:05 +0000 (UTC)
X-FDA: 84900961530.25.D1BEAA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 462464000A
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:23:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dJmCwMaY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781976184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SYAGsaO01kiQmgR5RMp78XMLHevy+rCRbusd/Bmkavc=;
	b=urMQ9mvE6ytWeQksJeuGVIJ+d2QHOMB7AmakCbwouCxS5fp36kxv1i+iQJhpMxPh7uljLw
	lOEN7hoHi9PO4tipvs1wdrUmxa78eP+B4/4YvSK8N/XxbJkaIYq5R7EKW3S26GRunP2YXL
	rQJtw3ejVaPrUAnCpGUSmeY2OkgdwY0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781976184;
	b=lF3x2WMHKOcp7M8gL5OX7PBY9ymSUd9gCPameFE1ceEYKfYNWb/tabO7gAnZ7/wNCjCOVw
	RzjjD5T2BpgaJwyH3jbhg1isP5AqGcq2QT418z+O6q+FKfOgDw+4rSq6X0k7sGdhXOjkGW
	+xNxbAqpxwTyiwD9qKgVr4038VhcMi0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dJmCwMaY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 15BD240823;
	Sat, 20 Jun 2026 17:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869A41F00A3F;
	Sat, 20 Jun 2026 17:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781976184;
	bh=SYAGsaO01kiQmgR5RMp78XMLHevy+rCRbusd/Bmkavc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJmCwMaYu4CRKg7QWxPIpjdBYvx4AU6uOKZoiMzlEyROhtUlBopFwgPzr3c02XVcT
	 eVoZixq74e1u4fR+Q3Hz6qz0cCkMRuCVaDqEHRuK5gW0XNtpyPv+FOOqJ0uQdITW13
	 JsTYolmli/dYQ+rO/3jw5M8P2cx1fuep0FvKKMIIX/CCIuWuOVik6nfV5nmQep4jxx
	 Gc3Bm9owJcUc71xB9v0WQEp8/960veQX93mEYxKL/vqeGoWGLgwYyAa9EZtwbjMSxM
	 CMZgdnD5cxtULPztdmjhonngthhxDwgrcxQ/V+hcWiBDmmGgBoHf5kaOwUz03bVn0P
	 7CdE7Hgd49Qwg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 08/13] mm/damon/core: remove damon_verify_merge_regions_of()
Date: Sat, 20 Jun 2026 10:22:38 -0700
Message-ID: <20260620172244.90953-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260620172244.90953-1-sj@kernel.org>
References: <20260620172244.90953-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 462464000A
X-Stat-Signature: cpxy66skbco6f99sgh6wz813p33yt38w
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1781976184-769649
X-HE-Meta: U2FsdGVkX1/DtlR5QyQurv715WrKi9IaYeXrIEpm5/HUg6GWqEpDo+SZGgFrfL3bz0WzcY1B/gDVaJlgxcFtO6aFN3mwrA1KguMYAZRx6XM4cuuxWmpwK+Ode7IDhcJcBdi7xP+mlnVxlTPntrKlbrvR9nEtcm9n1fg0oZJvPCDi5T/xNwryA3JYycZMmGbqsOI+YYVYTzI+cZ1+IaZQ291ijGRzxzWXF14yuGBPq0Kq09cTHfllkr4wLMmjkZu5pYpL2KWjUkGQRGklZvw4C7v9O3PoFcaR3q98yMtfqWwHZvvgY98ZFN/AatGtS1aQrZEUgdGrnVDtmn5Qm95jcTQRvIhqCZI/Ja278/oGWvOw1a/BTrL13IxhHGrUhrQeKbqqvXHqupPvVQuyb/WjI4HdmDtoWgLKkmk74BosIE8Xom3lyJNCZx7pX2cyLqA2D4cA/B17beHvQ4iBbuCL3/XORQOvfS9/I45gAJwhQwgDrBjfODnvGyn+MO9EdOsXygR7Z+uU9kB+WIxzxlrKUueoKR/QbbaCh6qmDH7uDIN1yvsQy3r41zpRxTHEy5qxYTdd/rUxZ5n84gtn9jFiTyCZg7I8GGrCvGgt6oZwTG9UJnkcS7U2lXH2Y1tnDbCKc6rNj4Yw2RDJyucFRV9oEq8LnontA/DJ91ErIus7FKdnyUc9a5lIfmkNPsIy1kDrehMpr5hfiHICMn/r+HkNYYCDZgBfO2Skuze7Efr4STpN+pNMubXAV4s8ioOLEpDPF2V+ftU5GNwdHu/Iw/9k5SzxObmYn5qQRb7Nsw/oWksx7j79W3itJnu0E6iZ2+qrdXHPqvYEKUXNYPVk0l6aQJPBq9xE5226QXU+uoJ6MePMoEQG7e96FXiOXZqbTi9wNnWyvnp/mwkX7NWXiR/LXWhvh1cYhjm1RIOBmyXgye0mbdq9QP+c64R/EbqVd+lNFTJpyhWzclL9fXm0tpQ
 qNrZ2jGx
 mjkSDh5BaxRU6iPKtW/+3h5/h28QVxyz22oIjq552Q6Suuqj0dRTIfMFRLkMf3DMzE63EzkH8G5HkLNMIYESIyifyta6mYfMiwPIORzbpPkHi+7MdvyNQz65bD8Gj8VbFh4/kJGY5ZLoCl4XFgp4jdvbXizh2SxVGMi5oLxxXJeYvT0kNnlxPD7C0s7KczKrT9S4qGrKqJdbPr2sOC4Q7WNTQqNBEBQ90z4GFbufEhE6ByG1DlfA0lEBiAaz3ELO0EuysEvz00JjlC+B8bav+7iAfWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_verify_merge_regions_of() is only for nr_accesses_bp validation.
But nr_accesses_bp is no more being used for a real purpose.  Remove the
validation.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 84d21d21ed6c9..6db157ee25129 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3109,20 +3109,6 @@ static void damon_merge_two_regions(struct damon_target *t,
 	damon_destroy_region(r, t);
 }
 
-#ifdef CONFIG_DAMON_DEBUG_SANITY
-static void damon_verify_merge_regions_of(struct damon_region *r)
-{
-	WARN_ONCE(r->nr_accesses != r->nr_accesses_bp / 10000,
-			"nr_accesses (%u) != nr_accesses_bp (%u)\n",
-			r->nr_accesses, r->nr_accesses_bp);
-}
-#else
-static void damon_verify_merge_regions_of(struct damon_region *r)
-{
-}
-#endif
-
-
 /*
  * Merge adjacent regions having similar access frequencies
  *
@@ -3136,7 +3122,6 @@ static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
 	struct damon_region *r, *prev = NULL, *next;
 
 	damon_for_each_region_safe(r, next, t) {
-		damon_verify_merge_regions_of(r);
 		if (abs(r->nr_accesses - r->last_nr_accesses) > thres)
 			r->age = 0;
 		else if ((r->nr_accesses == 0) != (r->last_nr_accesses == 0))
-- 
2.47.3

