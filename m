Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83346CD5BAB
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 15:18:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB0C36B009F; Tue, 19 May 2026 11:18:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B16D26B00A0; Tue, 19 May 2026 11:18:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 969F26B00A1; Tue, 19 May 2026 11:18:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E0316B009F
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:18:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2E5C21C0407
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:29 +0000 (UTC)
X-FDA: 84784525938.25.F713B16
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf14.hostedemail.com (Postfix) with ESMTP id 21643100014
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZRa18w1f;
	spf=pass (imf14.hostedemail.com: domain of 3QX8MaggKCMgo5rp+uw7u22uzs.q20zw18B-00y9oqy.25u@flex--ardb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3QX8MaggKCMgo5rp+uw7u22uzs.q20zw18B-00y9oqy.25u@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779203907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EjHc0cb+NE/2F+UEf5a5kfxEL68f5+QTn7aAzw8hvjg=;
	b=ZsOLnmRSQbykPe5XIhCmCX/+i1SMD/YqPbyanLhPdtTW6X3aNsil/1K5kraY8nEC9I5KvA
	yqdV5wUhC4eKlXfr4HFnUe4WqZfYSWqahR46ezWbkPP9MIfdw5lxfKVSm6jKglbYhBr+Qb
	PQklCic64AI2T7oSPcbk5jaqjN8dm0c=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZRa18w1f;
	spf=pass (imf14.hostedemail.com: domain of 3QX8MaggKCMgo5rp+uw7u22uzs.q20zw18B-00y9oqy.25u@flex--ardb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3QX8MaggKCMgo5rp+uw7u22uzs.q20zw18B-00y9oqy.25u@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779203907; a=rsa-sha256;
	cv=none;
	b=sPEFU1AWwGOU6ILuotTKh+WYx69hvVuaDdb8Os72zPKZHGcZvXNwTAU7XSnKeSbM/shZYA
	dQ+VoXneooJrMXSClm5wDgyN1VK4NhvkChFv1IsbzYCsZF+vSYItczHXi8DV6EeiPcXJ4r
	QPgtHrHzn53zGnTz/MfAxyFCFKGz6T8=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-447f2ce5556so3173274f8f.2
        for <linux-mm@kvack.org>; Tue, 19 May 2026 08:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779203906; x=1779808706; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EjHc0cb+NE/2F+UEf5a5kfxEL68f5+QTn7aAzw8hvjg=;
        b=ZRa18w1f9knCprWGc7QSPMcIH82/JonFJGsZByxOff3fjgHBlsyILN0qfRbDLFRc3+
         u+zowR80FNE60uJikeHsHHbz/xsSCqdCtweOjuWF8Re46JW5j0DIZQWHd5+PzvMAmfej
         tEgUZit/yxGGuxVHKKdOj049jQE1N71br8D9wJfPGt2Tj7hDaFAPhcZDIyVpS8uP3V9I
         cD8icKl7LML+K4fV74uKzZNTgQlu0uCaEU9mlo/+s/AOoUdjJ62h4x7AG8SlJI4zyuC6
         coROoKqwgLn6oymGUHriMMl6Ux6LDny3BCNL/GgAC6aHb0DAyS+d1T+N4EoTJLFUm2KB
         +iHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779203906; x=1779808706;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EjHc0cb+NE/2F+UEf5a5kfxEL68f5+QTn7aAzw8hvjg=;
        b=IBdrgoyxy2e8Dmh+pqCud3xJOmx2oyTEkNsKZ+1bhkI0uHuwkRSuflcVlFyT7JoJm1
         MCN9GzhRmkIZHuWTPdU87mwIG7oK1pBjHEF8N0xQNoPvFyWImOhyJVsCxN+Ynez5BEcm
         dMhJWfrDI7q6NXID5eSt229IYvH0j+IjIP7BuiRrTlpwKdJ65FHwx9nl1iaAr0vjqXHa
         A5C0yRPB2xEjZu73YqxJvGhTfE38K+cn3gaYFj+u1BDIPkKQNGNuFrOH6lDDAa0JpC3T
         sB3EYrPDQMuZhQTN0c/UO+Srr0VpdKtmI/cGL5UWXsns3jSgCMEiSv+0qAIhM96gfeUI
         GoBA==
X-Forwarded-Encrypted: i=1; AFNElJ92aFQS/i7tx4FY2ygTPAmq3PZOPvGTH/o+xfl5bKxMh2rE3Wba9JSACzSh1Noii2Vf/l2Stbm6hQ==@kvack.org
X-Gm-Message-State: AOJu0Yy0V8cSdaMBttIA69JUp1tO8A0b/f5ztsPAqBWSlg/8y5TnDMyP
	MnEoCv6jlJTuRMinqaNKpwySNMikzIzwvbrQPivnSF8U/BhnIi+QHy5NQaY7tHXUAwxdu9+g7w=
	=
X-Received: from wrjb13.prod.google.com ([2002:adf:e30d:0:b0:45b:cad1:2df1])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2c06:b0:45d:4fc0:fe0a
 with SMTP id ffacd0b85a97d-45e5c5dd346mr33349921f8f.32.1779203905296; Tue, 19
 May 2026 08:18:25 -0700 (PDT)
Date: Tue, 19 May 2026 17:16:24 +0200
In-Reply-To: <20260519151616.2557018-15-ardb+git@google.com>
Mime-Version: 1.0
References: <20260519151616.2557018-15-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=914; i=ardb@kernel.org;
 h=from:subject; bh=DzlMi7mku98t808/4L/IevsaqNhHNBA7ZPaOWGTKp3M=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIYun7ozjx5JHO2c9Tvz2bbb1UYGuFVGxfyOk/Lcl39l/K
 H2HsKVMRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZjI0z2MDCcD0w4yfjZVbdjI
 l/1mdYzWeoF7uf/65CXWOutIPTyn6s7wz/CboZoY8yGh2dyvFDVyd1ef1EtQfpqkvm298dz7pw+ +ZwAA
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260519151616.2557018-22-ardb+git@google.com>
Subject: [PATCH v5 07/13] arm64: mm: Permit contiguous descriptors to be rewritten
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 21643100014
X-Rspam-User: 
X-Stat-Signature: mq6qoaw3hco9fhnut8yyb3j64qnm6mes
X-HE-Tag: 1779203906-418665
X-HE-Meta: U2FsdGVkX18BhdSnUNvXXrwWF0Xl2Mmouc9rLasbT2QV4aaxIRz4YpIZYmgBuCwPlyVuw/o3VkElH+SNIfhgXkHvlX8ew0Ng3ls1QfXClmEQF4zOkhdSjyrKtrKAcjCh/Mf7lR5kno+Wq8LvP/trjWNAM3nXiKN1Up43i9wDlAFg+eJKlBOUKXeQJWRHlmkFfOJsWa+LEV350/t9BA5p3BITaPtdsCnzvu+BGZibaAZ6VZ6MhT/wXbRj87uBTllj19RrM8wkp7xcOHGxTO739kXHDrgc/LGQCUif4q5J28MOs8II/pnUqlu044dO38JKutRu17Bx/5glFDrox86IZF3HaA3tKSVCxTEEItiC2Vy4GiH3iMLm/2N86zlwVBO2vQJrBSP0M+L5IJEyW/f9ATkZ+191OiP6ICibUeF/epPi36B+OvOxP1Gc7yPSu9DQolg0gOxTaxb7xS6NZcZi6jk2eSDpbwOmgT1nrxndj1I8AUhQzhY47QBd3x4vTgPWqHi1oIv+LZXa61aikKFtYz6rYCyCPBZ9eghudrAfemTLjbTk72VW32fdr3k0HNgEqCee4oiM5k2QYseH0Ym5gg1hoprR6FY+1VZhdF25ddK4AWSmqB1u/WGQ8eEOpLItujhmmSDq5N6IIUH4KCnGPec4bIcIQ24Qk1im/JLYLYDvIVhzkh3ljkRvr7zD+qjfiDIZZWjTbZ6PlifGma9ZAcN3ITH04F8dat3ZXcf1cG/K6i8LwNVSN3owc7FxEGUwmdHcAWP5IZS7S/iRCeb6zGPQMp562FzyhaYfLRnV9fits1nSbWwTaopxuyz9bERj+F0wHYNS/eCI4LQdpr5NwrfkYNnrZe4UynPdIvxGGWDhIOmUstGnT4CzYf6kOur7qylGhGt5tlSxuTQyc1qbNPpGi/xd8tIvSWaASXpxE5lAYEjHiMqM1zsRUsQ98DLTpkZGsKgPPpkyvLTz5/S
 X5vE6lb6
 MSPHL3/CmOlaGk7s6OPhDiHYZiRAogK+sH0Fd6CdoGmykhaWzX/MtP5Kp5Tff0o4jw9qL93tGfaP9n4q6lQTGrPSAn5pRrInfUKXG+xZ/kbvaq1BvUZKdjG04xFblvQhH2a8HRwX0IKaNQ4E1RfEF1mHnJOPcd4EKpodrStAsk+FGG9S/EPnPaQI/k/rN8Oxtu0utubsW+SLLiMvsxBmu5098Mkzun2Y2NBKj9owZfMwmgsbAWmiCRMaG3ZH0Xlat3srMetUXRw6tJe1pN3Kr5inqgNsyp92uSatZ7oI5H6UxVQSOl6AN3j3AYaWJPkH56nFVpIIFYRiGs6pHLU1vGQjrPKEvvgWp0duepKlHR6finEcPFPhu0MZRbJmeQ5bZD7Gq0P3FqriTyodklA3qtq53sQ6WdD5aC8sRFbIEoCjQKDY8mZEZfXhbwyDroNOOfBU9+3poplovlZCO3tvBU4C7gadQPg2JOfM73FFQqNh12yl5EkN2NSYiljgGgNGzgvjKFGNDLDpv/pRXzuivq7yqysDA1MrRu1rol+Fr+vQWqvzBUeLLHHE42hmY0qaAaLff
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

Currently, pgattr_change_is_safe() is overly pedantic when it comes to
descriptors with the contiguous hint attribute set, as it rejects
assignments even if the old and the new value are the same.

So relax the check to allow that.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 0405fac18959..7cecd25aa83b 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -134,10 +134,6 @@ bool pgattr_change_is_safe(pteval_t old, pteval_t new)
 	if (pte_pfn(__pte(old)) != pte_pfn(__pte(new)))
 		return false;
 
-	/* live contiguous mappings may not be manipulated at all */
-	if ((old | new) & PTE_CONT)
-		return false;
-
 	/* Transitioning from Non-Global to Global is unsafe */
 	if (old & ~new & PTE_NG)
 		return false;
-- 
2.54.0.563.g4f69b47b94-goog


