Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21032CCD1AF
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 21:22:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A5C58E0015; Tue, 21 Oct 2025 17:22:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22D938E0002; Tue, 21 Oct 2025 17:22:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00CE28E0015; Tue, 21 Oct 2025 17:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DFAF38E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:22:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B2435A06B
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 21:22:24 +0000 (UTC)
X-FDA: 84023395008.18.A700DF3
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id A8302C0015
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 21:22:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GFHqZGjN;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761081742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=zsTcoezJSoRgrirfDZ7w+aDie/WIBCrRU0RSsZ2fs58=;
	b=wsKQF2iKCiSmUsyWNnbhGmX/4wKRk6QuybL2ckJ4ZFS0LOrZiu+riD+mScsv9oV0d+nczo
	AJAJPPzOohnTkuzuqULMLNbNMTAa19cMfTsMdfhu3H/aD/V2VmjwOyAbTALnsExKDYrGL1
	R5IGYU++eaBTvd4Ua9OrJvcv6nHacsA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GFHqZGjN;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761081742; a=rsa-sha256;
	cv=none;
	b=v1xSMmFDqniNecVq7+1U5SILCaTJ2Fol347EVd4NJ7Hhow302f97XTOE2og+51sK5yHSHB
	VrOMFNdVB+nZD4TdUXVomWq7vI9KhfZoag0D/tS9+8Mr0ZDQIMB9FGu5KZyaGS/hzddc6G
	gs5wB8vE5zVwfc3vZTw/JNAYtoQ4Clw=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b3c2c748bc8so758476666b.2
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 14:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761081741; x=1761686541; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zsTcoezJSoRgrirfDZ7w+aDie/WIBCrRU0RSsZ2fs58=;
        b=GFHqZGjNjbv7IdUI16dXqlaLbUeMRgfah49H1ahYQT9MiqSmiZ5dg30Lgyv7QZKrRJ
         CVJDuqmO7eJnGEN1YBmlBU5n1gPR/j8GdBiGg4Lnls+lCVb3AjLH67N0ALYd1LIu9VYn
         rylu2rbjzP2IX/wbabL78hlUYfaEjShDA34hQEsooDQn6gVUOFfutIqK3YPaL5ziXtvF
         uPQ473SMe+OxNbsRzHlHQtat1719Alrn7WAOUQ/lQIwvoEeTyPYU0CW7H6r74DrngddY
         fzKd069S9NLWumP/juU5NRtBk7YALDrteJ1oIcbygPCMkyKsI0BNObo2laF9ewTAxwth
         kV7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761081741; x=1761686541;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zsTcoezJSoRgrirfDZ7w+aDie/WIBCrRU0RSsZ2fs58=;
        b=t8dfbghWJg4wI1nMw/u9iWFQJi7LU47nzM1TQ9sOIDrlGG8IYa7wNbHTc1pJkkvlVR
         mnoTkOtUqTM3YKOQw4j2x0Mq2SVWPN+GDBOgblGg8uwXqOPAEemY0M2Ogbb5E4pFA40i
         QMaiFpKej1JY9pcE69NAc4iYH5fGe5q7TYoL+lZwsIAJrPEtfPa+oGUutz+esdE9NfIp
         I4IvP7Y7AW24CcNzF6wu9lRsNxwyEIedEG2G8tId/D7+Vx6Xo/hj1F1qhVJETmQ1tDyz
         V2uphHPSvLdTF2aI4+Np+do1EO8AxAK7Gdr5Eae+9+EhYz6MRvng/oOLA+yXa75k0dR6
         rsPA==
X-Gm-Message-State: AOJu0Yz/CGPwZhxE6KdSAr8hFB0q6Ht+fG06Y8VPQA1nSWWYfW0xRZ2f
	ZBoM3WLJhG6p5yRmV4+MEwFn1IfZOjE/g/IE5f5IvA1RrhWFl83JVDAT
X-Gm-Gg: ASbGncuchbv1QnI0spTrVYxBm3hcZF344Pso3rExbRvBVBrYtI+14xxaDW+kjCNPmrR
	Z4h3OZ9IaWuzgecWFh2DzZ7yVtiZ14q5KUw9MAJpznjG/P+3qC4GbGbS052g9p5vRmLhh5dW0D7
	NwNiGDyu7/A5k7zdR3flvfE1PspXMlmGiVAxHILW1tRP4XCGz23mP6teaVYeZJAHOU0fQiy7ny1
	qa4jDrvPDgRUMLaxW+NU84ZJMo8G2ccn0LYhOEKsVy8TnUer5xGtXaKb3GBDAik7DmxJuwpmYBC
	XRYaVt1fHrVK3OkaGsnszB5AEKnnOArbO3L4oIijC7YvLjVlr+2nUH5ewk0jm8jQExQLHHKXLOj
	BjuOuoQDOnBXvvyOLsfV1dQfRoLfKPXcqQEZvEJh/YG9G4Ns1Xnq17GXzNbd5PrxlcXdddLOIoY
	VqOKfDahSI4g==
X-Google-Smtp-Source: AGHT+IGSDXVb2EPHkRr3q6Uom0veJyoqj3T2rSji1hV3txhSBx8/7IK6SZbnhrDa/Janji7ZpbvVOA==
X-Received: by 2002:a17:907:bb49:b0:b3c:82d5:2119 with SMTP id a640c23a62f3a-b647403a63amr1971871066b.6.1761081740933;
        Tue, 21 Oct 2025 14:22:20 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b65eb52621csm1166878466b.59.2025.10.21.14.22.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 Oct 2025 14:22:20 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	wang lian <lianux.mm@gmail.com>
Subject: [Patch v3 4/4] mm/huge_memory: optimize old_order derivation during folio splitting
Date: Tue, 21 Oct 2025 21:21:42 +0000
Message-Id: <20251021212142.25766-5-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251021212142.25766-1-richard.weiyang@gmail.com>
References: <20251021212142.25766-1-richard.weiyang@gmail.com>
X-Stat-Signature: g97p66a9oh9woi63dr1cw7i1t74a6ybu
X-Rspamd-Queue-Id: A8302C0015
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761081742-689719
X-HE-Meta: U2FsdGVkX1/NDeiIcYiZxQGm7BRP1NnGky+9xzJk24B5pbfSeIIopmbaCmjwlBJyZm821M5MzXs8z+Z9TuCNb/lSUJHflNc9F2SNdq0Gli4/Eq/RyvFuH7mx7cZewc1Rr+6y3xNeJVFzDgwLRr8SVsy/RMQpNmrD8/5OHmkpvwF92sM+ijTuQL+HlTB6c3HCiOkntaFJosfOKpDWSKtsVvPlushLkmWIxqivBLRfUFji8QsJl3xAgzn8iksri3CWGs0FdHUogl59S+qeg0rfCo/FN/daXM/jvn6tLa0Jh9RT/ULD8xDPCRyT9GulpCACpP7IyZ083Hcy7zkut+ilbMfRzCfi+MBdSPylwSZH2NmgXQsqS+7GC46nFlr6t88RPHUzPlkZlzvlC4tbi0r32GyQzeJJr6R1XhpJ4k23rBX2rFHEhYHpuAqkTE6eer/A651WslHinUB3R5WXt9Xvv37xiWHEv6ODUHoh7z8ErFwLXmrCrtNDq4nr4aPg671MoL6vOGsCiyer5GkJZ8Fij5faVxhvgr1l/xOgngmBgrC1Ef47EU9LSMP6wbOY5DXIL3x6wnCDjYVgeQN03NmuAXT1lc6aXgv/xx1Ah91tm732ASh6hUS1/yw04EwXlJnfIDDuGuJ0dgsd6JHsCiGaS5CcKZkoHU1g80TYUG0pnu1wQJXN0I1BkzEfl7Axl6nGm+lcQ7uSdzjpR9CHA0ztf8H9Zcnm3LI4nX7q3NleXQdqGImSSC5jm7NIezUXKjWpnIQW65ztT8jVmYJKCCL+CYxbQIcOGGe9OFMsRgyDgFlrrR5V5CRNkgX7nRzXYw48xHI+4dBF0Z3NXpfxPCCKigvsvgPcNTgUCyHeQK0sIxhD0/8PnUpwaqw1Lh5dg8195jb6FqQFtnq4SRHuCx06RYq3nmsi0Bj75tKwOTAfwqX8BFsigq4KDschYe1UkM7Ga8CFA3Qzd2D4BJP/aqE
 WQJfrN/x
 RgbUnqW6XjsBmEVVD/mvXP7zazvuV85dOaJFHlR2JXqHxC13iBNdXAA2C9wDNjFXnM2hZJHc9liszZY2TxKtHSw0c9IWQ0k6Y6bDMvN5xRdMrRyJdie28euMG41Z98sNKIYRm3SrGLhrcHhL2E8uHhIGj1/E/64z7fmt75b3ErEytpMEpblmpaYcaV4sqxVBu9vjc0SbmK1Fz1X4v6UUYcVElUjvr/iS9+9sbdIH2FqrbqXqWZjv/kjd7ELUY1es6bj/m+VtRGmW7RvTXLHMQGFCHFoI9ALr6LKhSqAatdhz4fuuh0YWCG/AxuenDVQydQ+x+Ak/ldRIW7K4sWJDsk5ht1SJ6Nrqa0UJdVfWY5cQfjlmDO/lWP/51HwQI7EreVSNQubV8PAODMpZtyplJTuyxLS9DEet5cUb7zJQl1JHPf7sstc1hrD6MTfa/pQbatWl43d3dukvWDC8ld7xT2vTdRG9zvPhP1beOyY67IUGUWP4QDiyLZc0Uwmlay/4m0jukwEupsiOr+EJHtvFWMehhKZg+qZaco2aUzai5B5pAXK84UCxAyg9+8FGNdrIltFRDAR8o4KpzeBTLG1XD3e/nAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Folio splitting requires both the folio's original order (@old_order)
and the new target order (@split_order).

In the current implementation, @old_order is repeatedly retrieved using
folio_order().

However, for every iteration after the first, the folio being split is
the result of the previous split, meaning its order is already known to
be equal to the previous iteration's @split_order.

This commit optimizes the logic:

  * Instead of calling folio_order(), we now set @old_order directly to
    the value of @split_order from the previous iteration.

This change avoids unnecessary function calls and simplifies the loop
setup.

Also it removes a check for non-existent case, since for uniform
splitting we only do split when @split_order == @new_order.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: wang lian <lianux.mm@gmail.com>
---
 mm/huge_memory.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 093b3ffb180f..a4fa8b0e5b5a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3596,8 +3596,8 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 		struct address_space *mapping, bool uniform_split)
 {
 	const bool is_anon = folio_test_anon(folio);
-	int order = folio_order(folio);
-	int start_order = uniform_split ? new_order : order - 1;
+	int old_order = folio_order(folio);
+	int start_order = uniform_split ? new_order : old_order - 1;
 	int split_order;
 
 	folio_clear_has_hwpoisoned(folio);
@@ -3609,14 +3609,11 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	for (split_order = start_order;
 	     split_order >= new_order;
 	     split_order--) {
-		int old_order = folio_order(folio);
 		int nr_new_folios = 1UL << (old_order - split_order);
 
 		/* order-1 anonymous folio is not supported */
 		if (is_anon && split_order == 1)
 			continue;
-		if (uniform_split && split_order != new_order)
-			continue;
 
 		if (mapping) {
 			/*
@@ -3643,7 +3640,13 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
 			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, nr_new_folios);
 		}
+		/*
+		 * If uniform split, the process is complete.
+		 * If non-uniform, continue splitting the folio at @split_at
+		 * as long as the next @split_order is >= @new_order.
+		 */
 		folio = page_folio(split_at);
+		old_order = split_order;
 	}
 
 	return 0;
-- 
2.34.1


