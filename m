Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C0F3C5CFDB
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 02:00:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EB336B076B; Fri, 14 Aug 2026 21:59:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C2466B076D; Fri, 14 Aug 2026 21:59:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68AB76B076E; Fri, 14 Aug 2026 21:59:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 297916B076B
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 21:59:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA06EC027F
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:43 +0000 (UTC)
X-FDA: 85101847446.03.2060F05
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	by imf20.hostedemail.com (Postfix) with ESMTP id D74AD1C0003
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="U t/lCJE";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=JhwiSSGG;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786759181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S0c1eOgbbGAyxsvdncO2s21v5pX/QpSQtyc3bthgrHY=;
	b=pZG52aF91JSp4tRcS4OsTGONIxOGLGmOQpG5PW12OL6j2Rm7enUCk+DYGwPjcr3ViIEo+F
	X4cpDBcTeHftJsrW+dwOqV4+4y2o0Qq2AJhevoegwFVs8QcaFMRyY/Qe91gC/zTaWYweZK
	GkQgEc6rnzlPdj19xGKfphi/z/RYJdw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="U t/lCJE";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=JhwiSSGG;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786759181;
	b=NBkUZyS8PmfcgMzI1ql4/OkT4nCMwNE731QEWMI1okhB3fqWXV+TuQz/Vler8ItPj/nicO
	RgXzI5U39g6nXjoNceSB8OadYlWfgVn0kmLyKRheB32hlrD4ZcR/RDc8cRE0TgL9090k7r
	61QQClFXXyO3bshh7moKTsCsw4aluHc=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 72AD5140011E;
	Fri, 14 Aug 2026 21:59:41 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 14 Aug 2026 21:59:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786759181; x=
	1786845581; bh=S0c1eOgbbGAyxsvdncO2s21v5pX/QpSQtyc3bthgrHY=; b=U
	t/lCJEwc5aQKPhgw7EwTAdTo+PRmF1IqeIOoZHi9eWxt471XuI22OZtQK6rvfCzg
	PyqtP2xJXjnttcwAHHPTXq6RWBbl1TILSyEPlOKqqlfbqhlbW4LBQyziuNP3aQYc
	aKIrMrBrGOdfYk+Nl2ekV8oJNdw5MbAAQtCiOWjRg4zX2kJa6hiMe1Tes3mvOw/7
	VAqfAQbUZ96Ltjk+aZWT3EGpyc2NFU5ZdBHi82avmgjDy3KaYWLSsE3q/2QbI0fz
	Iq4d54umBUGqaK0sAfBzpsVxVlL78nvkRCAHeXcQiiFkOPz2M8A6avRgIRFwQq4T
	oso0GHW6fyv9rYa+r7WYQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786759181; x=1786845581; bh=S
	0c1eOgbbGAyxsvdncO2s21v5pX/QpSQtyc3bthgrHY=; b=JhwiSSGG9GcvcRpt2
	StUvvTqekt2dNbT/MEipdTfJWgSKaGnX8aavOol8DZSxj0N/b+OQqhO+bR6/wcRQ
	U2EyqxQZdIiQdPGZ2ivmhTmS5ZlWs7xBqRJG/EFbMN/UtZBZxGMkemYuNcfP5spt
	2BHM0nsRpAn3Xy3iJVVTlkpk2Izn4qhFrjZQIfUjWRR2Z/SKQodDpB7KKrwySSPj
	KEGLALAreBOPdw3tIUmhQfzDHFf1zsuAs3LpMjGQUMaMV5nmlBJgxIsDqh1ClrFi
	YCw3g5OzfuT148DEXOx0g1SLwA7dMzbw+MUgrS9rTmJKJWI/ZRx4nxaZtco2mErn
	sNtpA==
X-ME-Sender: <xms:Dch_auEZShlT8MhC7AAr8dR0miZ55owXdryNSKxgEB3mOIQA_kfK6A>
    <xme:Dch_ajRyYx_cqa--3oBs53Hm4fITiN4zTloBpELhMUHd0GQPcKYmjoGUwxJJhle2C
    0tnBUfW1plUs05_-hW7cGdeV0SdrI9MXOdDEIuyrwVQ-kitUhpX3Q>
X-ME-Received: <xmr:Dch_agqYn17bJZeAzYEvc_rvTQW6rZFojEGSLvdGN3F9hdOySzZiSTBaazk>
X-ME-Proxy-Cause: dmFkZTEYpEQiBdLKlCaLp317TOYqYwO99jnuX4YrBujo3RuW+IIGXdYj4qE1ezcGRvbtOZ
    hc7RfnfkdlTehb5Dkvk4VZTcyRAqm2CcEjaldkIQshIttrB2HSeWyAKQfsR+ykmymFv8qO
    aC/+wh3joJiQccaWn5NjVrqLVVMYdoVO37A5ZL6SnR75seJlCquk1NTOiA0EvXHIVSJ25Q
    iFONSccd/wEzNfQZlOvvQQf5bCKiGIALXd0Rd37Vcnrh56q8DfWwmvEu2ZgBGSMa525iaP
    HkMF5MKO3LDiNiHXJVHjo5f/L4XJttiAOfdXhljkaHgZI649okv5M81/eeF8HfhCZr1UOF
    hEaMyy8SNp+WA12XXrvIqlcMW2sZE0kgpE/SOwwrkjJJR1inJnCtzQ+93UM2eF1fnod6oT
    9r9RUE9IaQWym0pbVGY3R1/tSevMLn2Wm1fDSecSv3O3MsiiHeeD71o9x7zq70jW1XGMxt
    6PxXclH4l5ckE/VqaZuoVIPwRETu0ui1oWDy0ZOTdrEEgVG8tzZNDoMGrwKfGHkXxWDatX
    F7XN4ZYzRnP0ghZSWu5SVUOAinq0yjUcgWhC9vY4+NzBxMhAdOUGFaUimv51f4+MtooxKw
    LlXk8IkRDFUfG5OOf3LKOP1EhgQRur3r/DB1mhiHKKozaXnvIDhtuZIUDTng
X-ME-Proxy: <xmx:Dch_ahrJoPNdH8-Jem6IiR7LfSReBAwKivDdiOSnJwKOXEcKzSF1ZQ>
    <xmx:Dch_ar1O4-7k2YPb_krkKTwwuJ2wmgySvS0C_9MX8pFfNC4QImb1cQ>
    <xmx:Dch_alhmC2uV7gV7mJuU_zGJtbr6KxRKpQutipCG35jLLGxhF4xCyQ>
    <xmx:Dch_aqnJ3srTrf-QxAQZBonMPNFZZOQjZzc6CdT9_AfNHRYHG96-uA>
    <xmx:Dch_akl6UTtKBKDWOLN5GVEVhzifFY0IWQRFwe-V57e6ge23KOIF7ED->
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Aug 2026 21:59:40 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org
Subject: [PATCH v4 19/19] selftests/mm: zap whole PTE tables in the khugepaged race harness
Date: Sat, 15 Aug 2026 02:59:01 +0100
Message-ID: <20260815015901.1236937-20-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260815015901.1236937-1-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D74AD1C0003
X-Stat-Signature: p7pdcgcpia8ghfmyaw8kznojynzx4wfi
X-Rspam-User: 
X-HE-Tag: 1786759181-311109
X-HE-Meta: U2FsdGVkX19KSRwzIyVCg3Q8Oo2hSTxIic9F1qQ3g2NQcvxbpM3CAoIkUsRpFrzG/1CksDxfRUB6xR67hEDrgKCPhwuFbQB+dd6IEB8vat4pRN5lV4x+qA1lZn4VzEUydKvOsHKAGnB7JhHDd5nuD/aACPwt1MJCshO3DObHkOcaO94muBdWPqDE6M+60L43Ll9GEg/14AJ0FqbFFzhjt0jRa8f1yQbzZoPwcSEaYQ/qo8S1mw8h89cesADAcaxnascvLgxko7zmBgUm/CeV4P6L9t08Gh30k7Yak8vq+5S6gPXJLPdiNhavtl9PyWYR5kbiyygfcxbLufWQ2dr/na9c/YTx1B2viC50dOUQe6wRwsHjCjxHrpGlPFNuwqx98RIubVyMbakVJBziXyg2GzxzQERjfwY1whj3ewHOa6tE/dtiV5g7BsBLZaNRUTz4BZXOOqBw/MpyDJE2LZand+KxKUsXskRbURMh6olCrT0ugXqPiz3VKD7gKFTW77YZfy4LbTMBziM/0Sp+TiDK/G5WskQflfGjo88vLCZUbsa0Ogy3Qb5dm/QJr6BbqIbnPGCw9jKU6WWPhK5zmYqa4yLa87Ca7qPPHTg/uSzVAkBH1MM7cEzrVXqByFlErl/mRxsTrEGuUBTxpxYl/hTm2Kztob66HKN/PNuMEluVFakEuIoec79B6iucMRuFYybOyH3vYNtUWA0A9VbjDP8Qh4x2NuJnMxK/ZnMGuN0aB56vbV3J7X0vnjg7ZjsoThtCjGuBMCfEE+FyeCiLUIZgBZiNvOGc7Vfd8yn0EjzcIyUOYSkfaMW03vVEqXz+O8u1E0oCHNfbIeRN/X+aBOaki2ySKa/dQWsDjK13oL/Bhqn1dcSl2ehFbos+PflUtb/puNIsBC4IXbBiuRezA9SG+RnBcSzhb7vS6+lRGNvuVyIWL1xnA1tb9p7hvL+fcCFqgQEZ06z/s3Ox6cxHb85
 BJ4/wps0
 JWL3BCbnHdkx+DNee+9Xj7L6kDVsH3NEkfKzLVATRuEwnXQ1vbTcaZPJyI5ZfUxnaoWUG8i1vhlOnTJLlISLYm3VZ7DrURQag/NzK0jr8NJw4ohgiHUE4d0ABtN70gSiCUr8F1RqT5AGaPARSiOdo5Oanhy01eLlGwi7kq9ff1qjvTL0NJ0JANCndwBg3HUB9biKFLgFSmv+KI9JXfTzg8623LGqfE6W9MOBkBX2r0pnb2sHShBqcuG78e+B+wQdZjz1jxhuUg7VUnBtm8LPKrIhvlTGmuuWSKtB/4/MmuaxS1oKj4GpZUlVWkrxBo0uYyUCZ38+Of8pQY32IcFvf4u/T9gPNKgQZgr9y6Mq+wpXv47cmof4j+O1bGs5wRTJsYxNoHwvvpAavcbwsxEDWHEp0Nt/A/IXupsNsU3zydlaEtrT82B8GVSDhXGczoZvWGk1RCU/T/l0gKYV4jJ7vyMb8aep6RKup5LHUJqa3NUcVq+gEi/K3tyvpaiei7m/MkNJQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The harness's MADV_DONTNEED thread zaps 1 to 32 pages at a time, never a
whole PMD-aligned area, and only a zap that covers a full table frees the
table itself (CONFIG_PT_RECLAIM).

Make the thread zap a whole PMD-aligned area once every 64 iterations, and
keep the fine-grained zaps as the common case.  The new case frees page
tables, racing that against a collapse walking the same table.

Assisted-by: Claude-Code:claude-opus-5
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged_race.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged_race.c b/tools/testing/selftests/mm/khugepaged_race.c
index a23e5bfe78af..6682bbae0a8f 100644
--- a/tools/testing/selftests/mm/khugepaged_race.c
+++ b/tools/testing/selftests/mm/khugepaged_race.c
@@ -140,8 +140,24 @@ static void *dontneed_fn(void *arg)
 		unsigned long page_idx = rand_page(&seed);
 		unsigned long nr = 1UL << (rand_r(&seed) % 6);	/* 1..32 pages */
 
-		madvise(region + page_idx * page_size,
-			room_from(page_idx, nr) * page_size, MADV_DONTNEED);
+		/*
+		 * Once in a while zap a whole PMD-aligned area: only a zap
+		 * spanning the full table triggers the empty-table reclaim
+		 * (CONFIG_PT_RECLAIM), which can free the table under a
+		 * collapse that is midway through it.  Sub-table zaps never
+		 * reach that path.
+		 */
+		if (!(rand_r(&seed) % 64)) {
+			unsigned long area = page_idx /
+					(hpage_pmd_size / page_size);
+
+			madvise(region + area * hpage_pmd_size,
+				hpage_pmd_size, MADV_DONTNEED);
+		} else {
+			madvise(region + page_idx * page_size,
+				room_from(page_idx, nr) * page_size,
+				MADV_DONTNEED);
+		}
 		usleep(rand_r(&seed) % 500);
 	}
 	return NULL;
-- 
2.54.0


