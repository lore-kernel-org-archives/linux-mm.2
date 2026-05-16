Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21D30CD4F3C
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 21:04:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED3936B0092; Sat, 16 May 2026 17:04:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E84866B0096; Sat, 16 May 2026 17:04:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7F5E6B0092; Sat, 16 May 2026 17:04:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C85006B0092
	for <linux-mm@kvack.org>; Sat, 16 May 2026 17:04:13 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 42661160753
	for <linux-mm@kvack.org>; Sat, 16 May 2026 21:04:13 +0000 (UTC)
X-FDA: 84774510786.24.FD44C4E
Received: from mail-yx1-f68.google.com (mail-yx1-f68.google.com [74.125.224.68])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6990780008
	for <linux-mm@kvack.org>; Sat, 16 May 2026 21:04:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GaTiuEjy;
	spf=pass (imf02.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.68 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778965451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9zii2AWb8oMGGjdpxDAORttiwCSLXiloFVUhqxIkFOU=;
	b=1p3hBjbKldsH7x6SpHgBeoggjR5mv/UlhTHMmz0J8z7YEZy2NW42ciQV22dpQAxc1H0eK8
	emc/ZI/M3CkaXDBURzUyRM6FnZWo+A2hNzvSP5M74cWlN01Fy/YCK0eJafL4fmgcI5Y5cW
	1YOsIxWTzBbeVz20UsizBXOut911Ef0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GaTiuEjy;
	spf=pass (imf02.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.224.68 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778965451; a=rsa-sha256;
	cv=none;
	b=2f3Heluuw3Sz0Ho+VhKQS5nZkAtcdwJGUYUf0N4DcimnAt94RvD3lpjvw2prihNijAx6jQ
	Z0cJsMJ33dmynb1nKzZew8XVZwowJSkKIjNgwVKCFd5ENK2y3f5EOt68pz9YfgRDtRLmLc
	BgwGxUFHNfpez6cBn6l5an8jCL27t70=
Received: by mail-yx1-f68.google.com with SMTP id 956f58d0204a3-65c21049dafso1138941d50.2
        for <linux-mm@kvack.org>; Sat, 16 May 2026 14:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778965450; x=1779570250; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9zii2AWb8oMGGjdpxDAORttiwCSLXiloFVUhqxIkFOU=;
        b=GaTiuEjyCK7a9Kzjzs6lM33W3gHTwtiLurSx9NyBcmq3iJmdJizb18vTcWnWN0ejqQ
         sW8OcHSp+poRlg9ehnWquYPcYVmYZhai3dIxnfUBHdCno8IFnoA7V9GqwB6I9nER59L5
         fGdxf/5r8apbO/aSyZs9XjsnD7bQFs0zeaXH0bQ/Sbg2+zVoLpW4tIFyxn0tWRzAlLBd
         uspUaylAlPT26IqfvMHr6TtUo5ESzdDmY/Y5450DZvnzx6CGgutSX3nK5YK3J2K4kE7N
         EgBRwgrBpWAvftwthgMwOV1BuwAAS4sGg+mU1+gDimX8WfiCSmSqSXsWhYCIXwCgd6/a
         heKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778965450; x=1779570250;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9zii2AWb8oMGGjdpxDAORttiwCSLXiloFVUhqxIkFOU=;
        b=qxPxrjUm8D++nsU7U8MjLS88PnwM7YlmFB3S0dvrkfNzKD//yWJrVF/KtrbPxAafUo
         nAg9YP289XDLxWhhDXQB1sXFLU9nU6q8VLuaqUvDZJtwxM6jE1q1zeesvm0pF9OT9w0o
         wYSwgO1GyDnE/ApDk24xagG8LzJLD03D/hy+k5gX4oTrhgY4RrSLyi0C0wGEtsrm2As2
         yRz9Iydk9bLe//8XzqOpU002rbA7CvVURBkPrj5ZFWQBHzJXkZE9iajnkT/wennC5fP9
         /AEMniHJ9X4COcY6pjfqKJTcW9YGX3drtaBjg8bmujkSIrJXuYCDcsyxFIh6FntJaxou
         LQ1g==
X-Forwarded-Encrypted: i=1; AFNElJ/08GvLfe6FEsKLfCMANdbXdU2QD26aglsxFqf8McYAU5zG6yXUFBp5ky8qp2kdtmBqz9kJKlRCfA==@kvack.org
X-Gm-Message-State: AOJu0YyJXZz/CPoc4mdvLNbKneWrvqe7oV6WgdhKBC/Zj/oecKbkwke3
	ka1v0Q9n1WuAZgTIN12mItpZEksJ5r7GwK6HU0NABXOWoxm3e1BsNFY=
X-Gm-Gg: Acq92OE60k/KR10BB5dkDDVZj4rs0H39y63wkmM6S7lyh3BS0tJPqiND1saACnRA6i+
	IFCFlnbVmVZjcK1Y67Gp6EKgTiYI4bF3rLd7CSb1/cEUv0xskgiulef6mu8iHVDxXgedgZf4Sw5
	HVfG2AzOQaiEAuxtFPc5190w1hHCgHbwBAk0qa4ibj1iAmfz8ZxlEk8Hogj3nvadXSnUENg7Yqb
	cEexSTyjDU+bbHMG26h6F/YsE8oi7rJNy8icLexjRQT9XMBLu0y9CdB2TjlRuxjsW/1nX8fL0W1
	OvpLO40VfqYFj9l3QnQAa8LpQqscX9gWgpm5GHEMH1vClH2Q0yjiP+Yh6JzAYHSfK9mUYm3JgZR
	e36lpW6scYJwoIpP7TXxdLrpLd5tLyY1ZurwqwSZjdYGOihbjnarCSjlTZrqzt3rdvvJuYdLKtU
	eL7OOvA+Yh3laqXuZDQncN/EYsxEoYzzeWPt3puLl3iLu9niFFVksxF34sMcOl5JdUEKvVGrghC
	A==
X-Received: by 2002:a05:690e:191b:b0:65e:c81:3a6c with SMTP id 956f58d0204a3-65e226dcb9dmr9397203d50.15.1778965450383;
        Sat, 16 May 2026 14:04:10 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-65e0d86c850sm4349204d50.1.2026.05.16.14.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2026 14:04:09 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	ravis.opensrc@gmail.com
Subject: [RFC PATCH 4/5] mm/damon/paddr: skip free pageblocks in migration walk
Date: Sat, 16 May 2026 14:03:56 -0700
Message-ID: <20260516210357.2247-5-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260516210357.2247-1-ravis.opensrc@gmail.com>
References: <20260516210357.2247-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pmkf8pj7gj8g8uscpsqmfxwbu79eamjp
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6990780008
X-Rspam-User: 
X-HE-Tag: 1778965451-595901
X-HE-Meta: U2FsdGVkX1/ck72uzu0gdzUFgEUPjMlMT1Dr0X66rDNzuW0//ml+8M6uFwDXzNiBWRuxo58iuSu9xMLNmQfb55KN7ry+x4E/iV6B+ysRG/eMFQPw6EAgdB/w7CTR+6hJAiJwPqa8wzLr9TnLgu9nMeZAf67WqkLqkRyRtHi4Unc3eqTfePMKDuUgsuDue2859G7/bJDxviCYdgi4PttdxkDd1ddaprf9g5wLH8nWwzXdX+o38S854gi8FbE2NZfNPpU67tfVjkV5LPL9Z+DKmXc5ZRiOTvIeQQZIiUp5IjHpKBxbojqGtJZ6REZAll1+m9Ow9DZW+gkQVdxm8wKyF39yGoTN8zhVihUMbSqmueRUsCvL5lDSOHfEUduHCSxepm3JBwGxSYibP8UQERIFK08NYv1988LYRUtquf4MUDUiiau057OJXh8H7fgGIzpyInUYM5Ss8R6jfueu+lOWf+5IkJZaS+r74bineRUHBtvlqgE7dhX7yPVpfQ4i3O/MLAKQr1L6jkuuyeROsA9ciHQEb3ZzyJp3JDVJdLQGSHiQIXJc5zcbhoLACC/jvMR3weXzgIRohxexe/S2gxKpPdEf2qrvMUn7Zua++Ya3k5zxxXVh3WwO/DpCH9pR4FvwYfhhu3GJSFA1FA4kcoyIggEMI0O6f3IbfzKnF3RMwqbJkvWMCCPdN4pRSTkOJeqUwubFrlJxqqqshE9duO6gTbJlozCyAH2xcr3SMtwlGS2k/k5ag86AOzD7eWtJrADD6Iq3If0sUtroRIZClBuCOsMaL00/Y0qNIV+1BOnrAlWYmlAIV3G8y56ni7obVVkEwiq7YPZi98aI2gBopElWbJputi9Ir4Gub8KkwOig7WjvafyLcfywOo8MftB/1UoeCc7NYHNW7wV1Sy5HKmNKxAhIErlbmLSWgokyBG+UiU/geYU/cH+z8Bl7uvb/PI1eJBF5tB5K2Lyi8o4clRM
 +JLyuylK
 SrL3io//7oojWq5L5RYU2q6bGy4jP6/ZHo9ZoLAAihXN52MLRggLU5HF7+unn4mF7vRxgtMnBs8ttK8Iny2bY6pgSJXL9RcHfJgdsYmPA2Uu/6mCjNSgZxeDulVSjMCO/eHMvXjNJ0QBrgxt9wowfqOr0ont3wJiEySiYrnnylZp30E05oR9ghoZ/T82P4hX985Tr5YWTfgsdPGUNfBj1pDqB2zV/tfyEGW2tpL1yBZagI6zKO1g++3eIDU509BO8c3QZ03BwRwr6AlZjD+W666yH5mbjRquqmKeLElBdILzMvZVvhUEDfjZUcq9abf4EfUelz96lIPsqaUx8GbPdhmS7OU1WtpILjU5Sh+fenUByzTeAEnD3jlDu9BK7w+Q3oJdYzJnbxGKXVswokWh5QFurUu4c04w25WDNeMpvHVcS8+83oJCXIPcAfNbDT4gJIhGqWK+9+uo+TxYNl/wcPWRe3KosSVuya7A3OKEUguHsIbfGvf4D6rNaGWpsgp9zVqA3njE/AeRztC+2ys7fvWCCGqxMn0WE/Tk1IbgdohJzbeRYCgcg7GuR+VIt8JBDoioAU0kCJ1BZDQhXAsCY7sKwkzPDMZrJqVyLJFUCeT23BWu8wc7jvM6jyp7Nuju2chiHHjnDkUM0tXc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_pa_migrate() walks every PFN in a region linearly, calling
damon_get_folio() for each one.  On sparse physical address spaces
(e.g., CXL-attached memory), a single DAMON region can span hundreds
of gigabytes where most memory is free and sitting in the buddy
allocator.  Most page lookups are fruitless and dominate kdamond
tick time.

Check at pageblock boundaries (2MB on x86_64) whether the block is
entirely free.  If the first page of a pageblock is a buddy page at
pageblock_order or higher, the entire block is free and can be
skipped.  Similarly skip pageblocks where pfn_to_online_page() returns
NULL.

This reduces the iteration from O(region_sz / PAGE_SIZE) to
O(region_sz / pageblock_sz) + O(populated_pages).

buddy_order_unsafe() is used without zone->lock.  A transient false
positive (block becomes non-free between the PageBuddy and order
checks) costs at most one tick of missed candidates on that block;
the next tick re-scans.  No correctness consequence as DAMON walks
are best-effort.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/paddr.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index c4738cd5e221e..e844c990987b9 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -258,13 +258,32 @@ static unsigned long damon_pa_migrate(struct damon_region *r,
 		unsigned long addr_unit, struct damos *s,
 		unsigned long *sz_filter_passed)
 {
-	phys_addr_t addr, applied;
+	phys_addr_t addr, end, applied;
 	LIST_HEAD(folio_list);
 	struct folio *folio = NULL;
+	unsigned long pfn;
 
 	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
-	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
-		folio = damon_get_folio(PHYS_PFN(addr));
+	end = damon_pa_phys_addr(r->ar.end, addr_unit);
+	while (addr < end) {
+		pfn = PHYS_PFN(addr);
+
+		/* Skip pageblocks that are entirely free. */
+		if (IS_ALIGNED(pfn, pageblock_nr_pages)) {
+			struct page *page = pfn_to_online_page(pfn);
+
+			if (!page) {
+				addr += pageblock_nr_pages * PAGE_SIZE;
+				continue;
+			}
+			if (PageBuddy(page) &&
+			    buddy_order_unsafe(page) >= pageblock_order) {
+				addr += pageblock_nr_pages * PAGE_SIZE;
+				continue;
+			}
+		}
+
+		folio = damon_get_folio(pfn);
 		if (damon_pa_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
 			continue;
-- 
2.43.0


