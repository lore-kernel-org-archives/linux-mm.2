Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE5DCCD4F37
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 01:47:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF86E8E001E; Wed, 12 Nov 2025 20:47:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA8C58E0014; Wed, 12 Nov 2025 20:47:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A25288E001E; Wed, 12 Nov 2025 20:47:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 82FD18E0014
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:47:08 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1E01D13BA63
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:08 +0000 (UTC)
X-FDA: 84103895736.04.61B36C7
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id 32EFA180010
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=kA7ULFnl;
	spf=pass (imf16.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762998426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7sKtwP//OgsTzC5xxNl/Xd6UYX/1wT9VConzzoLFoks=;
	b=O6Ncrt59VcEtMhbOv7Uyf+7cUCx0wTJ87eOsazATt612SfowWXACTwYZy8Dur69fIp0VGe
	Ac/qMUwqeqiAOLYy6TL8wohETDPc0nCzQYovHy2n6a8YeVPLS6tHNP05KScUTg0oHIeu4e
	SO5vR2CRioh7dAuWS20w1k5R5R9MJ1E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=kA7ULFnl;
	spf=pass (imf16.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762998426; a=rsa-sha256;
	cv=none;
	b=UDczwXIagA+EPW+mogSBHPKJINkHmgkg0lnY98FsMC4wyNRG3MS16K5VhwJZDpLZUFYXR8
	PWQfXP0MvnMHkg0cad6cR+doLnwCi0Bw8PfOUUD8JkFgcJyy7YAtmmVy22YH22seyrwwtH
	oydTp3wX5wUXWDPqLvwSSgmJTMjZeeE=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-297e264528aso2469665ad.2
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 17:47:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1762998425; x=1763603225; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7sKtwP//OgsTzC5xxNl/Xd6UYX/1wT9VConzzoLFoks=;
        b=kA7ULFnl+p9DmLs6sQhAGAvgBMxN4GV4XVP6MSHw2N506HpDeYKDPnae6yk2J8VS0j
         KUN0jyPwyorQR1YVvvYtu5TECFV5Fbvi5KJZqn/EJ1MdS/tZp4Xel+HNR67EM2vmM8dq
         FHS4ZIqeP6SXolMgc7Kik2+SKGsc1VyV9VFJkXT6WPzxv2wZr2Uq8KLG8OJynQxtLgWp
         9sV+1iU/fNTLUObb4U5tKnsCZR4OCIBp2fVe90SRFC1VD5jv7UjiOgGmr2EHIJQhCI0i
         36oAM1aT7ShUao0qAuWvlygzGce4kMWPLt9SZn+mD5DW2l6OJU6hEnUuuq8XAnY+QUbX
         FzNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762998425; x=1763603225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7sKtwP//OgsTzC5xxNl/Xd6UYX/1wT9VConzzoLFoks=;
        b=FMPYndNZhGBMEP+7L5WmBr6428cPNpmoi0x8DSOzU7Zuiori1MH1k1BEV+Cq/Ncpln
         jaUQRpQSeiJ5rNEfAA4bEGfvKspitMRlTM3XG+6PMX43wyX5smh7tCEpXPwmUP+FM1xd
         kAUKqHIpmCj3dG9UMBaZBnZN4WrjRe20tfCHEmXZami5vcBlHnPSo49lbR/6/pDqKNnf
         xGL31+iQyoH6dGbQU8isGa+3YFOnO/8ar0GCZ4t9DafvkqCwebTOX98wZXzBRueOVZzJ
         bxDIteToKP2pJIUJ2OWvR6WHtisAsaouh6mlc+99I0AxwnpXWFYDxfosAOej//XLumoE
         X71A==
X-Forwarded-Encrypted: i=1; AJvYcCXRZmR7ksODJY9doI+vBkuSH0E8EbymG2TkebQok0MJKECi8NF4IbtB8JmBhFUAgz1b5wvjGmcBxA==@kvack.org
X-Gm-Message-State: AOJu0YwSCrNzM99xNtrZzFha7Tm+jILeNbsrVbC8PUXm7wrCrZbR0AJN
	IueW0htvFqCHdudomF+zgTq427w4Uew9S0v01xj7GXUtYFl/Tw54ZgnY/G3ynXdXJjc=
X-Gm-Gg: ASbGncvg7+fIdgC09IX6bmH5ETIEo5OFun5NVHoqC6HKZqwvQgx7UzpVkQCmmkUx6+9
	ueeyn4Hf/A+EqGpRNU23QkdajObsbbPaHTqNc5hQ5Jzx/d5itWdiLl0RkLVzpDufM2vUWmun2tR
	txmG6AAFUv3If8Ma43joikgxS03Nd4tDhqQ79y1N7Hm7qhcTbxq1UpiNGU9yIHMqkSoczDJvytn
	MBo4s3G4jfuByD/GDHzyGIsPQSBr7U16hw1uThod2hI5vsDYc/NJNzRYpZjgCEbQJFst2mnWe13
	UUy7NFFu0klHkbI2Qb0T0tphgCIg+EhQKVZhynnYiVK78ZvrrVPT8mHsddyEWCQXIp4oYi4FoT6
	qXHjMGmSZEAtdIMstVbgxH3sqT77Sbtq7EsexVSWLkavUs+DBnJzy53PfltSUj1EqgEGiw9oPgb
	3k9CIqis95d/r8hTLr13kuWg==
X-Google-Smtp-Source: AGHT+IFyAjw4zT369i2V/HQmfngUMRA4j/oLD3IR8XNvQ6Htb0EplxsCGv5RKISA4ePCqfHnQtITTg==
X-Received: by 2002:a17:902:e788:b0:297:d4c4:4d99 with SMTP id d9443c01a7336-2984ed30d02mr63149505ad.6.1762998425114;
        Wed, 12 Nov 2025 17:47:05 -0800 (PST)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2ccae8sm4986485ad.98.2025.11.12.17.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 17:47:04 -0800 (PST)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org
Cc: devicetree@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Conor Dooley <conor@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Rob Herring <robh+dt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	linux-perf-users@vger.kernel.org,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v3 04/22] perf/events: replace READ_ONCE() with standard page table accessors
Date: Wed, 12 Nov 2025 17:45:17 -0800
Message-ID: <20251113014656.2605447-5-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251113014656.2605447-1-samuel.holland@sifive.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 32EFA180010
X-Stat-Signature: w6cnhbod1cma84xb98xjbgtz16g9rytr
X-Rspam-User: 
X-HE-Tag: 1762998426-178429
X-HE-Meta: U2FsdGVkX19c82elGg3zEQEVHLM5tjFrbikhJg7/7OcQIwHy5SoVxtluXRg315Cl3EybvsQFas2gTkc/rmAuTA8SdnPAeQKXBoeTMOdlM5W1Jip5QoDm8P9swJWsAHbEZoYCG2NKJqVndfssj3Hb5PfCikeIPqm8oiOb1/p80nwcxLed9SnYgJho80BAEcqLlp7jopOBhHyT2vSXdfLKN6H9f6FOh61A74M4b67u8S2HHV+MKIi2Nza1+A0LOiKFu52UadcfPlnhC1viKwG6jSjQeZIA07WQ83Nxo+0WYSl2DQQpsYI2gM6X+rP6asepwcimJzNicc5umr0vhAzkPOWrBBoTCYUIs4BOJDl1cvCyS1AH1FJfgHn+BsJTCdLKL0WfQ4DgaVfVJ7bdilTfqLLA40UBGgyXFaliOf65kbl7iUvkBHg/J2encl7bC2SY27RrOb1565ksUm8PJwLyrYsBiB1r5bzXSa8JUeN7gTKJU1a/bLON7ToLeGsVIUxCsLDw/X4aS9CnbjJk2wVbpBX06XgScsTVBdylOgkUn+Y4b3PnYBpmjsjvmUuB0wXlea0Iw04n8zjozSTALCDYhkXi9/mVAfZsMbHLUWRFhdTUC0yyUN6gxlK1L94EVxDE3JBk3HldRUE4RiYmZqtmK1V0yHBIbI5M23HJp2CdHNtjYmpGpa5YebrdkeFMoyidD4VwZpUWOLnuB0OL3bQ2fHZLZhvIlIrrGXWdXWaqhuwQ+x8lIccWNoeMzROB6RCz7pSHQ3DZ30ckYLo6R/0Awv/MXhXgstM5ZlSY0ntFsYsBmsH4a9Ef+coMy+hc9f1YpvMWoWIX/zxozHi9Hp2tuYi1UHEVKQZwRaSVE9k0dhTCT9apGfcAAvtjPLigUwqrSrqPJYwUDHipfaAA98rzNLl6S0GZGITUef/CBX5sgCpgO8y96mpZgr5OfaHBLEvqan6B4kbicswz31JXVOn
 qLI1PywS
 SYhf0gFFxwBC8eR7ipyp88JpMXRnBNpomnb9A6YTCWUTPnucDiXYKgQ/QYyKVU6j6KDNHEoH3YHH4Up9MCZxHYrTJKI/qKzo1cvRgdLYb0H6hEebV0aS5RIp+tYtdtnPQzaF6x6VinsiGY1wC04IjgjGKMYMgqVKDLP3u1bkAjdKjidZNiuix6PMazt9hvvowj0Q7rempw1lFzOsRW+F/chPCVEDE2yw5QsMa79VWQkdY3iCC9E6lo8lpSHbUsDRZhom13ooj/5vNfgvB61hRxNB36HvQs9XjXTn0p71/CTi+J1Hu+OfcQDispVloPIb5plM9AT9GHEZK0jeQIShCsmcLIJnZE2JUVbjfzucn9nESg1VB2rvKd9ANb803It8H8yicMLmrOZz+5lXjYe3+oWrKyw4fSSv1u8J0ShfDFFiEkQHMCQXn4gz6EF7vmRBnb6bflFUt2ElfvXxbL8mE6B7Kx30WEEi2VjiiDFyH+kREcw4Z1VsqO0+iccnhcEpRPVnbFOtzDbY2Fx9nkUaOtxU6Cl0eYNkgSKR8GVvOEcPr/tPf4RSWPuGvl3n8dD6EvRtaThFtNg8mH7g7l2E97JcOLbCPUqaOzquThAONpBGmkMMqqBiYmFNl+npO77t0pO6vY6X9qtcQhSk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Anshuman Khandual <anshuman.khandual@arm.com>

Replace READ_ONCE() with standard page table accessors i.e pxdp_get() which
anyways default into READ_ONCE() in cases where platform does not override.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linux-perf-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20251006042622.1743675-1-anshuman.khandual@arm.com/
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

Changes in v3:
 - Replace my patch with Anshuman Khandual's patch from LKML

Changes in v2:
 - New patch for v2

 kernel/events/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1fd347da9026..fa4f9165bd94 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8122,7 +8122,7 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
 	pte_t *ptep, pte;
 
 	pgdp = pgd_offset(mm, addr);
-	pgd = READ_ONCE(*pgdp);
+	pgd = pgdp_get(pgdp);
 	if (pgd_none(pgd))
 		return 0;
 
@@ -8130,7 +8130,7 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
 		return pgd_leaf_size(pgd);
 
 	p4dp = p4d_offset_lockless(pgdp, pgd, addr);
-	p4d = READ_ONCE(*p4dp);
+	p4d = p4dp_get(p4dp);
 	if (!p4d_present(p4d))
 		return 0;
 
@@ -8138,7 +8138,7 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
 		return p4d_leaf_size(p4d);
 
 	pudp = pud_offset_lockless(p4dp, p4d, addr);
-	pud = READ_ONCE(*pudp);
+	pud = pudp_get(pudp);
 	if (!pud_present(pud))
 		return 0;
 
-- 
2.47.2


