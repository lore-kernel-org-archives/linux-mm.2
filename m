Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB286CD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:04:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2FA96B00D0; Wed, 27 May 2026 10:04:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE17B6B00D2; Wed, 27 May 2026 10:04:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1D1E6B00D3; Wed, 27 May 2026 10:04:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B54C06B00D0
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:04:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 729B11C1D4E
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:04:20 +0000 (UTC)
X-FDA: 84813369480.08.842B4FA
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id 730781A0009
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:04:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KYpUescj;
	spf=pass (imf19.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779890658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=StiDcvF5NcsOIMzOzw/wp6rwR3a8/aCyRzqbH6oZvSA=;
	b=F71PzdXsdZkkjPEHagxhe3Jk8/Rg5cEAAUHP/RPpVYyna4jRWti+3Ta8XpKkEgDuXxT9m5
	74/0683HVauEaTW4WD4nF/673zSy/hHgJ1QEVTtS2d8Wqcm4WW3mXsHHU8Kves49O9KGRQ
	sqSK8IGFjFF19ZguXNmrapB4VU8ElP8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KYpUescj;
	spf=pass (imf19.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779890658; a=rsa-sha256;
	cv=none;
	b=X4+3yVwVgq5Vykwv5XzHsu7W13R4BKIiQoFjvDjTj+OpPNnvyM3RtufDJhGj9TaQznNTCB
	EsEmEOdp1Y0HeaOAsH5Jx4+kJm85TAX3/mBYAl0rLNZy/r0aUGP0r0C4eHVn4XigJdhvCI
	SP2QqixCKc/GS7XqmPKqCWGdoJUaukM=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-bd56d108454so2105736066b.2
        for <linux-mm@kvack.org>; Wed, 27 May 2026 07:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779890657; x=1780495457; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=StiDcvF5NcsOIMzOzw/wp6rwR3a8/aCyRzqbH6oZvSA=;
        b=KYpUescj0j+167RAXoWSZsiskf0sMJm2hCINSyxELaX7SO6m3oBntiqGMSryK1+h0x
         d4Hl2kPCGU0p6WCSszuYBmAgvxtxy+mec8zYnfuJvZeFq/E/jS+fhGxG5JreEVA18nR8
         vlbgMbLCVLHVyPF7QhfmcTrXhwYBdgQMFeOIxTFp2bEZArlHu3LB7gEGqW5BVEolfbM+
         Elf2gr0h71AwZ6SzreFxAY0Br+urTnMQVyX6FrZBSjHwHfJjIZFfLhA2xf5HcwqDpXUM
         0K8MkspQLTjZuEYmw2uUZaFhRMPyY8RTYZmNoLuEUXvUcczdjGxiaFbABI3aTmWQ/P3e
         dddw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779890657; x=1780495457;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=StiDcvF5NcsOIMzOzw/wp6rwR3a8/aCyRzqbH6oZvSA=;
        b=MD+UDi4NlIbMIDDqvh/K523GdyOldiw9t7C/zkEir7/ocV9/V/+7ZrffM+wOgJoEjS
         qn3LDFZpGn5yH3zGHnNdJ4aQ6OWPVJ3G2VHHbfWvwSkb44Xn9RYCcl0sTyrgTRT4NFup
         6MiaVB4JrrMAfN1hrdDkoDJgSfGuKs3UBT5bulAQV+5olLEhhJbtjk9ru1LOKNp7w4nu
         XqwIf2ZxsUDsKXT8km6PUxoVT1wqd2IccHx4P2JXXiJBUvlE2hnm16s09eErviRzJroU
         pFG1sHsJb7m/4xuuDFT6GZwoZFk75O/kkVmF5w5nET3C/V5GfSAX+Rv/vwJwgZJ3VSWJ
         Zedg==
X-Forwarded-Encrypted: i=1; AFNElJ/tfOurHLq7Cd7SlIvOzVcWQJRtLMZ9ADfp3zygs02RiwVpW2hZUv7EhNv37+Vc6whelMU33hVs6A==@kvack.org
X-Gm-Message-State: AOJu0Yy8oPlWInoXC0VA3ohN0YJJiZs6gyaOlqpoMSb30AIs3lVJfxlY
	rJcOKPnEdkUlvZ8OSD1PmCUlzy9bNf3zgsTXR4LYoqgdDHHqOpxxrqjf
X-Gm-Gg: Acq92OFtaJV4S1ffmZZT6gPBAhJx9ISiKtqsCNSCYt3BSJDnNxLrmnLdtj9VjnnI6M5
	8Z5dWKiB7a5+IQ8mUu83CYU8OYuHZlNsXJr+Um3h8USmey8JTrxw4suoF0l3omB5bGXBxlW7vzC
	I4XhKny1wqr18iO0IbkkUj24HOk3sP8xV2XK1axILrg7s/cr69M7WwBAdiN3A3hvpKdDLtLjAvr
	w1l40SUTfz2fgJXtFQ3tngpBfIOuppDApLQcotTI6j4KUQ9gR9hqN2VXreJtMptmG/wWKo+8zd0
	zZXWC7F9pWWceilgW7Wx8zD57OHXxRxQvHzFPqOwVKK98GFsVF0y6Zy5nXVD2p1ra/Id8E6gy/t
	rFwO1uhh3cV3KRaZWF/+RPT9qDjVlyAzl9uza7vVnhU/mE4OIDNGDOJI7v7/3AQlYU5PznJqSnm
	2zNdyqhYdPjb8uD5ZpKGZbMSC1nbE8rRLzG+LsLbJbLvK6KHMLUtYgHh9hQSOzmYfnj+lNODXX/
	/IXg2uDtDUUNSHiKioaPBpCUw/r0vg8fg==
X-Received: by 2002:a17:907:3e03:b0:bd9:1fb:9941 with SMTP id a640c23a62f3a-bdd25cec1f0mr1328155766b.29.1779890656754;
        Wed, 27 May 2026 07:04:16 -0700 (PDT)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-45edb558f52sm6693771f8f.14.2026.05.27.07.04.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 07:04:16 -0700 (PDT)
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
Subject: [PATCH 5/9] x86/mm: Convert sync_global_pgds_l5() to ptdescs
Date: Wed, 27 May 2026 15:03:12 +0100
Message-ID: <20260527140316.294621-6-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260527140316.294621-1-vishal.moola@gmail.com>
References: <20260527140316.294621-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7iuco3muo3o8ndxs7endxu1kpax6s6gw
X-Rspamd-Queue-Id: 730781A0009
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779890658-933807
X-HE-Meta: U2FsdGVkX1+3FyPxDGSK6PAqfkQL9tuPL/99TiGK/921gDi1YjK6iJzSuKxFbXfhJnNTqt5yMICOQvKi1HQjxceI7nJsTM/3mqwCK9+LXp+IPETx4fznS9Wkd2xVu12lmqi8N5VxPjxZVZNZP4uhWIOQVNxn/eTI/oFY+SfH8Dj0zOjwaLxSAS88+FuHitvxsZGsrOUuWEqFWsr2QqPJ4MCAf7MrYT63qS9nii/BnR3Qtq88HUyuh/nMhK5CyMPmjuINvytC2jkDq5bzo53HXXH84HTlolKDGo8Xm9L51M4Q8kcx1tgZ4SzEKboKIfHdnCJG+wDXBaYy0MrbnziBY/g/g9UNgeMZ1AsmK5JH9j+H/+hLpQQZrQ0fIoB6TZxlblWKKsrPTvDuy7rdxRO0Vz0giHPu1B2jtlOdrQZvWSR+UMY9iDRtx5GRaZU35eNqS7HaFg/H+Yy/0IxQ924v2wPOLi28FNQThJn9g1yV9HUmfzJpU4jG8UCuO+F3kGbAAmpb1TW8Y9VwyHB1ajqZnFAd6wIFGz72W5UHtzSQUGU6vRri5SxqHyDPxG3Eoi7+Ilzom+6tUjFieBXBeGbZTVGAoigKDsYuhoYGQLce7CgC02td0jYUIYp/oBShHu+RROcsWEQefmfcWxnLmeEP6a/dR2SURv9jJJlBYdpiuBvdF7xdcer8j8vP01cls7UpruwcUbiWaxUYth1m3TgJfnyLKb1yEmuCnC3SSRNvRbGdNrF7f4kuTR2LkCO4bgd08McsQlhoO0jVybC5h1UcGGEaNX60rFQruK7ffKvje0l80aIlxbLkmHU41nQoeYBtSvdhdP4n9VN4Yf7wHysrltNVCHa5PMpNY+QjfravB7ZHe3muqnJZ2OzViIZepWMbVMKv5zaqkhWSGGfZBRFj3cZKSNkefY3Pqt9cqTzC7jBggDuGPTvhlPDIKxQZPEBzAAVZAIjsQDgm+WBvBx+
 4AU0jlcL
 pLiin+Fw0RZUUObLIfyMVjwf9zFx/AA7tSvcEumrmWsH3TGscvUbvFKvTGBmkKehVQ29rVuSMqAugmU878xdGLyp53hQGazXX1zFALQg6b6Ot5COuxe4TkKiNYTJg93wRt6U95j6z57drPy3t1pIvl8W/3EU5JwuWnNoni2Ru9zBMf6f24yGmc3Dv0ZQmcXHMjUUAYEWnAVIWwCwQW9Bj30eHJE719DllrniOqAYflh4DJrNcWSPC8FPRrYRKjFPdJU5RlutL5eVyeFLIBeXyYcf7GsSJEBEao08paHGJiGvhIXFxKNI8BEz40j1JPqnK93MUx0QV+uE9dSvYWx7YFWXSnlnmT05DTrEsR1GRwpPI68NfGYn3JPKTmnuQDD4gf5ITakI3QBUQ+0vStf+056/nR0IzlM6rSJP2Z86dXIUoAt8zfUUXJcPb50PFp0NZtT3nJXj0DAvM0HGYsqykweDg6o2BLiSvpaj5B4gtmNQWlVTjT0SnNjD+dFH/RjSVA2GmpmLUBKi0TO4D0XY3vLk4USm0CFhOkEPZR/qmMCWy+JOvYAqbVAY3YU8VXILZMJH5tGRMhj+8Dj6A0GoAvtTwMQQ0cx/+8qNL2xg1eoHSK9P+/NLJJSL19BS2fo/GZo0xltsQVhgRZtw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert sync_global_pgds_l5() to ptdescs in preparation for the
eventual splitting of ptdescs from struct page.

Signed-off-by: Vishal Moola <vishal.moola@gmail.com>
---
 arch/x86/mm/init_64.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index df27379d4bb4..e89b51aea2cf 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -136,7 +136,7 @@ static void sync_global_pgds_l5(unsigned long start, unsigned long end)
 
 	for (addr = start; addr <= end; addr = ALIGN(addr + 1, PGDIR_SIZE)) {
 		const pgd_t *pgd_ref = pgd_offset_k(addr);
-		struct page *page;
+		struct ptdesc *ptdesc;
 
 		/* Check for overflow */
 		if (addr < start)
@@ -146,13 +146,13 @@ static void sync_global_pgds_l5(unsigned long start, unsigned long end)
 			continue;
 
 		spin_lock(&pgd_lock);
-		list_for_each_entry(page, &pgd_list, lru) {
+		list_for_each_entry(ptdesc, &pgd_list, pt_list) {
 			pgd_t *pgd;
 			spinlock_t *pgt_lock;
 
-			pgd = (pgd_t *)page_address(page) + pgd_index(addr);
+			pgd = (pgd_t *)ptdesc_address(ptdesc) + pgd_index(addr);
 			/* the pgt_lock only for Xen */
-			pgt_lock = &pgd_page_get_mm(page)->page_table_lock;
+			pgt_lock = &pgd_page_get_mm(ptdesc_page(ptdesc))->page_table_lock;
 			spin_lock(pgt_lock);
 
 			if (!pgd_none(*pgd_ref) && !pgd_none(*pgd))
-- 
2.54.0


