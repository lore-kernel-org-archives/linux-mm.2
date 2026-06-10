Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 527FACD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 04:36:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9667B6B0096; Wed, 10 Jun 2026 00:36:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9174B6B0098; Wed, 10 Jun 2026 00:36:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82C516B0099; Wed, 10 Jun 2026 00:36:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 727206B0096
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:36:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 330241C316F
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 04:36:13 +0000 (UTC)
X-FDA: 84862741026.10.116888A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 42D464000B
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 04:36:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QJTDO5S3;
	spf=pass (imf07.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781066171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GsADmFNyWnSOI14Pn1OOlC5OR+kMjyhKf9M+Xzo57rU=;
	b=uPppnShDnEZC0hH4vMG0p3QH0TLtf/iILDNB44dvgnVCfXrLf0B2ff/xKLzCAwQ6NTDpdw
	fStuZm5rRt9SOYD9MjFSh6Nu/l7aFMigtGFuiE4p+Z5Vh9CL+VfoaQQGXaVKXP6pNPYew4
	BlQE4+bX9Ztm9T6XyQkcx9p4bjhiE9Y=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=QJTDO5S3;
	spf=pass (imf07.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781066171;
	b=F8p75UoE38Tf7S+OrD+TphQ788a//ZOde/aSKMKGEEhv78dO2Bvaey5ycqD0WiZnVPe+Px
	pAleHWiawaf5jruP2nAjV7lyhWCDl8ok5Wg0oIi89npQXYgIgBSLFgfNhj1DolQbceecnr
	gz8actWZ5eM/PA24O0JOXQmb86R+Fw0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 92AC84723;
	Tue,  9 Jun 2026 21:36:05 -0700 (PDT)
Received: from ergosum.cambridge.arm.com (ergosum.cambridge.arm.com [10.1.196.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 0F52C3FD88;
	Tue,  9 Jun 2026 21:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781066170; bh=Adf3UUubAzeI6nT0ruRbYrEdRb+IDFoKB/5Y4BllNRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QJTDO5S39rsz+D7aX+2P7dXYCwOJ1lARvf3pcBiWVpOu7oWro/1B+TRRFQ7T77Vfu
	 lenwi66r82vEP0f8KxHBHgrR546fRcMendj+3T1SW+OUTSps1MdwB6otBlnhSYrutB
	 NRx5xHfCsgElhQP6pKoujBnPnEMznXbCcJqOmKMI=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Subject: [RFC V2 3/3] mm: Replace pgtable entry prints with new format
Date: Wed, 10 Jun 2026 05:35:45 +0100
Message-Id: <20260610043545.3725735-4-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260610043545.3725735-1-anshuman.khandual@arm.com>
References: <20260610043545.3725735-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 42D464000B
X-Stat-Signature: 9f8tpizhb9dhpdmj5uqn7i4u7fwow89e
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781066171-140019
X-HE-Meta: U2FsdGVkX1+KtrbFOitgBQKKMbDT58H9o9OsDwVGpm3Jvzy5GY97iN33SnXBfkdfP5aJqCXVxjFNuOiOzNIp81mrLNaYHAXng8/JfCM2xpFXN2CVLb+qDJxcy4sAESMMnYKCFzgjGzMFM9Z1USljCZfMZ9Oe3BtC8hLcdYSAgONi9+M8tmn0nXSK3nxsWNK2yIFfEeg2SaK1916h9o+ZZf/5djMDuywK6v97fMIikA2XYf2vEMJiHgmWVBke89OKyq0+r+acneaVFIBirR52DVmK8ef1oGfZYmf47SHWNpgfCOj6gUINS4x/wsvwnYIoRhdK39WRxI3iDALTVb3zDI4Rmz6LDnjkokTSxIMyk7+PkL0tOGrJDwgEd23UuWW/AlkTof/eU2+gf97S/2yVbAbIlo97IaxVfhK6VLuJ/Hyb7hbpk8CnNV+onK/OJtzAl9FrDWDCGcn2x13eC+rFfgnxZl1z0qyEXeSX1SqVEqd1HxpOLDTDbv+U4g2jp2OvN78ZylCbGaPnx5HZCG2ZbY9f3DJbgHwL52NWnlnuSpJPUG6ff7g07bewYYhkC3tjJQZDZPEoYcSZEARv08ayp+ADFhCNB7ALbslb8Hi0x4cmjQDXjeamARf2Sby1dMMJHhiSaTHFFNFGcFKOZRLQW9KB5seZ/D54kO+vnmushWCIfut0bUumK15KEXdoy43XvCx6eD+BLgUzWZKzD7jVgaKkNRATcXYLvaKo4NgDgrycKJUYUsATju41PP/yXQxGW92dE34p5I1Ip74PDrAv7AT5r5QGh0TKnWkfZXb0yEnK0GB970Rh7ZaIqn0XWf5sauiA+lGltHqElyrHbH20/Ngkn2mOsmo5Xt9UVlp7qfjGxRhILfOruIQ+DSmH6eT9zePSYsNfU6ytTV05uDplWzKJ8V57k93UkizrdO9Hrzn3jdxAoQ/a8kmruEsqFcdq/V+ieNHKOvdgyFTOOXj
 JDiaRcjn
 sXyiY+Q9RTVi6biPef9K/7DqJc2Zrsq4lc/2+iVZc27T73ZKJ4EWa8qel374RSPv4t3DJNRJ74hEkKiwJh75h2j6REnDe+zOorr18F0clZBGwieTTiEyeQnhztVdug6lEtoKdkCrUOZSNMwAhAGeHY0rg+qTshd97JwOjeWJHaL05NIpDyArWG4VyVcOGXBho0vtSyk37WPGJ8FFCkLnJJpbmfd8xQI00tFePa8PKFqkOjoTOMsD6JDN4Ukq/GPqimnjQ+oqTQLyHdZl9tX0rGxmw8ucJwBXg82JZyNLb0qeuZEDOG6XAnbA5inLOq7gpN3VQf2kZ8+seuFN3zxAfg6nE4bSczuDhWQoMeY7CiSo8OjbxuHQheePHUPJvLBZ4MLbU2muxGf9Kzqbn1n5t5MfZXEsf6LzYBPYwuQTQ9GgyxSU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace all existing pgtable entry prints with recently added new format in
__print_bad_page_map_pgtable().

Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org

 mm/memory.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 86a973119bd4..8a25790f7c24 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -521,7 +521,6 @@ static bool is_bad_page_map_ratelimited(void)
 
 static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long addr)
 {
-	unsigned long long pgdv, p4dv, pudv, pmdv;
 	p4d_t p4d, *p4dp;
 	pud_t pud, *pudp;
 	pmd_t pmd, *pmdp;
@@ -532,34 +531,30 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
 	 * see locking requirements for print_bad_page_map().
 	 */
 	pgdp = pgd_offset(mm, addr);
-	pgdv = pgd_val(*pgdp);
 
 	if (!pgd_present(*pgdp) || pgd_leaf(*pgdp)) {
-		pr_alert("pgd:%08llx\n", pgdv);
+		pr_alert("pgd:%ppgd\n", pgdp);
 		return;
 	}
 
 	p4dp = p4d_offset(pgdp, addr);
 	p4d = p4dp_get(p4dp);
-	p4dv = p4d_val(p4d);
 
 	if (!p4d_present(p4d) || p4d_leaf(p4d)) {
-		pr_alert("pgd:%08llx p4d:%08llx\n", pgdv, p4dv);
+		pr_alert("pgd:%ppgd p4d:%pp4d\n", pgdp, p4dp);
 		return;
 	}
 
 	pudp = pud_offset(p4dp, addr);
 	pud = pudp_get(pudp);
-	pudv = pud_val(pud);
 
 	if (!pud_present(pud) || pud_leaf(pud)) {
-		pr_alert("pgd:%08llx p4d:%08llx pud:%08llx\n", pgdv, p4dv, pudv);
+		pr_alert("pgd:%ppgd p4d:%pp4d pud:%ppud\n", pgdp, p4dp, pudp);
 		return;
 	}
 
 	pmdp = pmd_offset(pudp, addr);
 	pmd = pmdp_get(pmdp);
-	pmdv = pmd_val(pmd);
 
 	/*
 	 * Dumping the PTE would be nice, but it's tricky with CONFIG_HIGHPTE,
@@ -567,8 +562,8 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
 	 * doing another map would be bad. print_bad_page_map() should
 	 * already take care of printing the PTE.
 	 */
-	pr_alert("pgd:%08llx p4d:%08llx pud:%08llx pmd:%08llx\n", pgdv,
-		 p4dv, pudv, pmdv);
+	pr_alert("pgd:%ppgd p4d:%pp4d pud:%ppud pmd:%ppmd\n", pgdp,
+		 p4dp, pudp, pmdp);
 }
 
 /*
-- 
2.30.2


