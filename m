Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56352CD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:04:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F2CD6B00CC; Wed, 27 May 2026 10:04:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 407D36B00CE; Wed, 27 May 2026 10:04:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 343FC6B00CF; Wed, 27 May 2026 10:04:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 252676B00CC
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:04:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3E1DA0612
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:04:18 +0000 (UTC)
X-FDA: 84813369396.01.058054A
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9F824100009
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:04:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=okM1NZVZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779890656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mkyZglyRu7RuI2nqe28wvRtM2BtUYvNg8u3jxi36ejc=;
	b=uVnSsOsS+/8VwTyCwGOARaoAWEr/WFl5bbEQhB+jbIPb0mykgmaH7tAbE05i9LYLm6hO+w
	r98CXij5x/1Snlq023jQeE6s9S8Ot5IQBxx15npY3fdZhrj+8FxWgKDvdoMw+IVQse6kX2
	+XSE/rWK8351xOaeeDq5MbBkXDmROyY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=okM1NZVZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779890656; a=rsa-sha256;
	cv=none;
	b=SNaNrMyGEFu2Cp8DB4Lcrh0Won61PeLzc1jbNInUtbofvWR/pwTHx/BD6MtiPYnAdIog91
	xPvYhyLHnV+rgguan4qQka/oehhTHaCCW3hv9TjvOjALBLH5B8hNzCMeV+BpC+iH3VxjMh
	UTV9PQH2TbRTDw9K4giWDjI1IMPaeVA=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-43d76dd4ee8so7130918f8f.2
        for <linux-mm@kvack.org>; Wed, 27 May 2026 07:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779890655; x=1780495455; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mkyZglyRu7RuI2nqe28wvRtM2BtUYvNg8u3jxi36ejc=;
        b=okM1NZVZBAiiCu3qC1+PxH2bFZhuCQpz5sPelOE3Tf8+1kAhEWvcvYUx3u7otGuqgf
         ID7PG946GsvTOdL5g5UiKzssDrb8RTLJlA/xNfuhr9ezR53k+C6cUQHUDsxyp25LoxF/
         LkF8ZbPtYocCGY2147TAFXUGtxoIxI4Ccj1on8ZEAJZcaiVqoBnZHrfnwXa9Y3We/nmo
         X6zIyTkjquHFftWEnW6/SwG+8Bh9tRgYdpMrsHigGUwVjT9ZQ6aAtHKk598xgx8d7kCW
         GbX6uvnJtOjaoXJ2Di7QraMa/5ygk0TzPpcg9rHyb0vHXpWE+xKeoxl8xUsd7vcNoBEb
         bzpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779890655; x=1780495455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mkyZglyRu7RuI2nqe28wvRtM2BtUYvNg8u3jxi36ejc=;
        b=sydC1coizTno0M3ssl0e/HPUaOjHLsx503xVwd7EE/kYZBCMRGgw4k24LrADaJHHZD
         9qDCmKP/MGmrHEaS7Eez5FRSqU8PCWkN/CRgv8kGmN/cSm0kitkwSyRuUXo0ZMp+t85u
         izZyvEFEe5q9aN88JQEZ/Os3deSl46rVghnbI27aazLWv/rOYKdLwGKfx2i/JVPSRxgG
         XmcwNrpyfCkPSODKQAfUxsdjxqzOlPfIzRoc6FQrPWGTeONbp08AG17xS5AzBrF7l0bi
         LbDRyKbXGEQw6kcJb3UQDtyKEn+OAiP9OmIGFC52z3OvOBZSldZNP9FU1kMDAHdedLcn
         W8bQ==
X-Forwarded-Encrypted: i=1; AFNElJ9R/qEtYPaJfh+TVsy+KWu3bfajsjubldVGCXtM3CYDGAjWpr6EvQuTIzjjuKqBaTyz5grNlUFxLQ==@kvack.org
X-Gm-Message-State: AOJu0YzVYZGYEdmUYHsfcKGdV+buCLk63w3n21poOVkfTlGiJqoHyxXF
	6uLvOEn/Bc01dSnYnwp5jImozP2A50s0DPBcWBOiFr8xfRdwX2zxzYHZ
X-Gm-Gg: Acq92OGNg6smJvO2UdU7sfaEY/Su1h3SnphwlpMf69qou1uI+RCMkWJlDt3HLMj3e/K
	sTwefh0HGVRncn5F4fE92JmOHhQRgFmXrWtD/fOFvMdN3PotYy/9UAgwwmKMR3X0bn+hf+SV9j4
	+sXOt6M5/3+Fo4jKgBhPgZuPrI8xFmSuewt9eEmnIkqOWxpm3CMdv7/EvIUKNY9mws2OYp5E+KN
	E3W4qGvG4OZzGg4+sGx40ifpjg8yoX2oGv9aJ64DOSOrnNPYK8aHmRBOsiPLgG0bBM71CoISz+2
	uKCU99/YrNf5Ok/mTfhnw4uQhs/AaVKBuBTBC5ZinVtPh8YjY9iqp1NEb0O0Y+oJvtRccHYKq4K
	zGgCnDGI6xLC903fBoOlC7su5C6TQiGuONZotvuXWpvs5JiQZtwAIvxsQj9tuPfTEdUsDN6gbmp
	d8U4DY+dth4Q0A5DnR4b93zxE85uO0PbC0ti8eFgJEjwBKBaJ+LWqvqp6Cl//A1VqA8kSdkRp7H
	itN7nATyIOevs94zcRwGEaNdNAkoOPXIds/5E+ZJJs+
X-Received: by 2002:a05:6000:26c3:b0:45d:b14b:23fb with SMTP id ffacd0b85a97d-45eb369c7abmr40583483f8f.11.1779890652261;
        Wed, 27 May 2026 07:04:12 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-45edb558f52sm6693771f8f.14.2026.05.27.07.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 07:04:11 -0700 (PDT)
From: Vishal Moola <vishal.moola@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: Mike Rapoport <rppt@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	xen-devel@lists.xenproject.org,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Vishal Moola <vishal.moola@gmail.com>
Subject: [PATCH 3/9] x86/mm/pat: Convert collapse_pmd_page() to ptdescs
Date: Wed, 27 May 2026 15:03:10 +0100
Message-ID: <20260527140316.294621-4-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260527140316.294621-1-vishal.moola@gmail.com>
References: <20260527140316.294621-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zr4wnpmuciqpr38xucwjtkt95pqzg47k
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9F824100009
X-Rspam-User: 
X-HE-Tag: 1779890656-906908
X-HE-Meta: U2FsdGVkX1+RQ1gBEw1bwKpydOcCDBhgjEKeHOFs+AiE3qyH121EF4RthqMsmUxQ39bCqRLRIwRa8mf7EmhkKImBc/6EJnyt1oxOcax/y0wqaG36LGKaZIiSp/h77gqjOco4MB0q4/Cm3GSuEifGqA2SJixQhJyv4g8t/wzuMuP2HWeBLPVVC/yo3HyETxnKtpoEoME4W6i2keI9wx5rvFYA6MQ3/2Dp3Y0HpU6mRa/3MjUSNcOda8DbF4Qok/4RSbvE25qI4I0qQI+y2rFhAvc8Vecrf0dN+1hV1gB6Jcu8MTePQx32v/iKwVqI+2s0w9CC+i6WLv5WHD9Dhc8sGnZgLBMPrD8+mDxK/P5QMTwmE9IkWPX2yzJ+2lJLN2ta7VD46gYHXuWoJiVC18ODZ6RLpMy+anF4UBWpzp5y/5JtfABrlhT6NlTwY5G7Tpe1paJZFPjurq8pU1X2aWdD4Csu5nfzFJuuV7HqdWdRfT4kwycG2rapkqFypvAR5LuKsdId2QOB3PaPa7uoaSLY5G2iHuW0kAjV1qhOpUJuiSQJfXPiZsX3DqtuTr2GXzBRh3ssrOAJmAhDIQVHWx8Sl8HYp7lKW0RjUpqwiVMNznDHZJMBFZ3EWvmBa+QXfcD/0qvhFtf/KEXlV4y/0dREySK3QgMKtODZLKcjW1LPcGCULOcjgFEEDoSS9WJ/c7TNfn7Cu421sFzyQQxndzd25YqiwLIS7vkZQhV8BibJUshP6szBQI5f0P+zuTmHrfYPriqUOm9sAeagRLZpIkJ81SAWMswGd788u1a6AKBu9C+lp81Ll+BFl0SJyT7qR8AK7akKf2AnDneqBK5xj5BiSaH1Om1Xbvfivq1H9rGPWxxdhXNno7fHht2BMIp7HurELRoyFmZaeY33um5/Xt8VxHreZHmVhWYaHdVuNiRo5n8zFqEY/r+IiQQ2fHv9qB44p5V59qq7NJAu1cDRj3l
 +IY6urcT
 ZMJRtFZkcGnDvp8zz6a/CMbPR8poSjp1wortC2kHL/ltVsv+UPblv2vC9DeFtDDgfCEqEPVa1sAufww8njb2Ot4fawUX7lk+F8Py1YqTQXqA6hBExOBtn2Sv7Ts1adwvra/r+cYzETZEb/w7N+q3R51wtvGiiITVmExetevD20iWYowQ3XAYJW9E2jiy5jO4l7IV1we+crLj2V/a1NalFZiv9uw14Qc2l5+vswdvsNYaNUFojjZ7aOXysQ/WitOhQ2Kyk+kGQnOQJ3VWHSfxkMmF1ad/9E4btnakDzh92ZDFh/3DdY9L2rqT1jyBcDhMD8CcVzywestS/3EK63hRLl/G1wUm5Ai8zHPd8+S9GmvKtgk066WZvzCpEyPuX2qpon/wxteD4v+f762mqHbB87OaEqEK0kOL8nyr+98gx49voSTLIPAnAu4MSqZgc4SnBJcpyQeALoC7SD9CuBa3cWsTEs1+kPtr0kKJqYChU6wCwDASUSAvGEIuH5CO9N7wQgICw0xvrW6u4zijHKTICokCtOOX057tXcHf7pL4iykc7zRF6GRrpjJt/RA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert collapse_pmd_page() to ptdescs in preparation for the
eventual splitting of ptdescs from struct page.

Signed-off-by: Vishal Moola <vishal.moola@gmail.com>
---
 arch/x86/mm/pat/set_memory.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 93cb71451ce2..45623d4c24c9 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1297,11 +1297,11 @@ static int collapse_pmd_page(pmd_t *pmd, unsigned long addr,
 	list_add(&page_ptdesc(pmd_page(old_pmd))->pt_list, pgtables);
 
 	if (IS_ENABLED(CONFIG_X86_32)) {
-		struct page *page;
+		struct ptdesc *ptdesc;
 
 		/* Update all PGD tables to use the same large page */
-		list_for_each_entry(page, &pgd_list, lru) {
-			pgd_t *pgd = (pgd_t *)page_address(page) + pgd_index(addr);
+		list_for_each_entry(ptdesc, &pgd_list, pt_list) {
+			pgd_t *pgd = (pgd_t *)ptdesc_address(ptdesc) + pgd_index(addr);
 			p4d_t *p4d = p4d_offset(pgd, addr);
 			pud_t *pud = pud_offset(p4d, addr);
 			pmd_t *pmd = pmd_offset(pud, addr);
-- 
2.54.0


