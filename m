Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F58FCD6E52
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:02:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A8EE6B00BD; Fri, 29 May 2026 11:02:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90BBC6B00BE; Fri, 29 May 2026 11:02:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D4326B00C0; Fri, 29 May 2026 11:02:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6982C6B00BD
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:02:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EF801A0199
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:25 +0000 (UTC)
X-FDA: 84820773450.04.0BFF785
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf23.hostedemail.com (Postfix) with ESMTP id E6CCD140008
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OaQuxEPV;
	spf=pass (imf23.hostedemail.com: domain of 3fqoZaggKCJEvCyw+13E19916z.x97638FI-775Gvx5.9C1@flex--ardb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3fqoZaggKCJEvCyw+13E19916z.x97638FI-775Gvx5.9C1@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066944; a=rsa-sha256;
	cv=none;
	b=qpDYJSC0I2rxZKgK4j6UCe3YQXADtcPSlQqmMeJm5phQUu+W/eX8VO3mBSduD+IgTzpHQW
	0oxJh146BOu3rA6zK1BuXlBp3N2EbZL60is1CZuNVelGCFugm2NzYeTR97hDZlm35FY8zz
	xVAQedIJtqRfSZIvVXCBnLFfDxUGabs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OaQuxEPV;
	spf=pass (imf23.hostedemail.com: domain of 3fqoZaggKCJEvCyw+13E19916z.x97638FI-775Gvx5.9C1@flex--ardb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3fqoZaggKCJEvCyw+13E19916z.x97638FI-775Gvx5.9C1@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9SMbp+4SpJBPuSW3tE55txpooI4fjODhC3THY1otv5g=;
	b=LisT/nkIb7KBL4StKUxU8JvCFmdwtnt2uodEI8WbrlXwvpw3oOS9Veqv+2f4GkFiHgQWZl
	AOY6pPL/uHsPq3ldGztjyrUP6WuIRrlhg4CkdtjK5g4TrT91wHszaVgbAYPCZ505KSO3Ni
	nTOovsW5gYYxnXPcsxcmbbpKMj97Mxo=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-44d9ace59efso8064694f8f.1
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780066942; x=1780671742; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9SMbp+4SpJBPuSW3tE55txpooI4fjODhC3THY1otv5g=;
        b=OaQuxEPV4TfXbV6f17xHSQouew+fWSZY0ofbUZKFzl7WjMD2gHdjXpItVY6mLTGjA0
         f2MsvAIQSpZos7ILPQKddu0jyKaTvMkmSI+zkXxwjnWUi6KAoB7Rfp1CJ/3oCSzc83+y
         /JwPXKNgxIFyUrtqoZqrCB1Vf9aks7SFdexNak4jq2aIlQNVdM31Vm4gZfMJDZB4Uraj
         u7ru2gat1c1uzG/XbpuU/ttGdadOF7YbWy18yF6f3zC61PCKXBNpWzcKWNoAn70PnJ1o
         zYxkDOyKUoG78JTBsRRwqU5UexjZLbxr2TR/4o8vkHYHzAl0hd6ggGbIF5qB17txfCAy
         z2iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780066942; x=1780671742;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9SMbp+4SpJBPuSW3tE55txpooI4fjODhC3THY1otv5g=;
        b=lNqznJStcDUluou76bMqTynpdMrbG0EC2bUwq7qa6cnEtXZYJ7iNt6vxG1Yr7g0NEF
         7tVMMVwqSbbNpsEGhInf9726/5/F57+kwICjyexhmj5AGQTIUC///3CQaIqITaKJyafT
         0iNWhDplop4GTPYqnsqz4a3N/vjV8mxPdqmqRqJ8lVeFRiYMWrtKtGARx+TUhmtBZnuS
         PyEcc5NE0GBQXqFRp2ATwNfyCYeo6gpgLEBZqqQGUgCEmB/Ok+zuqtVnzv93o5MPZHZf
         EFTXsltRRIjmovkVXQyVFwnOhsuSyUgJGyRCealfxNjSnVNy/sOotyrKLvNS6F8zFnjb
         U/Ig==
X-Forwarded-Encrypted: i=1; AFNElJ+H1wr6rSYy1xYRKZC3xAnvEQLKCuSuCD6NjA7+XCbgzjKotYhhv2igv702XEPIaCEiazRH8hqv3w==@kvack.org
X-Gm-Message-State: AOJu0Yx7+XQ7M6cquEGdy5RVm0L6LJ0lEMV6xeM+C4oQ40z1dTKSIMmF
	CKIaZDiAtS59PBp2QaiW8ttTavww9WVQNVcCGIbZy/7cPKUcQ1xrIUtUdPF9CnDlNm5LQLL7Ug=
	=
X-Received: from wrna16.prod.google.com ([2002:adf:e5d0:0:b0:43f:df99:cb43])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:b05:b0:45e:e3ea:1101
 with SMTP id ffacd0b85a97d-45ef6b3a9d3mr250438f8f.17.1780066942102; Fri, 29
 May 2026 08:02:22 -0700 (PDT)
Date: Fri, 29 May 2026 17:01:55 +0200
In-Reply-To: <20260529150150.1670604-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260529150150.1670604-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1360; i=ardb@kernel.org;
 h=from:subject; bh=zgVblspip5ZINNAWS3J63kCjniwJXU0OYP5r0DXGxEI=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUtyVfJJkczPYfGm/hd8+FL02y7q1vnc3l5lLz2B/bWeR
 ZyU8q+OUhYGMS4GWTFFFoHZf9/tPD1RqtZ5lizMHFYmkCEMXJwCMJGrFxn+e55rMk6KmS+o8qjx
 TFPydss+tp/hHKtbs3vkHc/PO8RoyvA/WrE+UfB50QXpS/Hr3nSqW/oxK2XsCGS8dSmZxXNHTQs /AA==
X-Mailer: git-send-email 2.54.0.823.g6e5bcc1fc9-goog
Message-ID: <20260529150150.1670604-21-ardb+git@google.com>
Subject: [PATCH v7 04/15] arm64: mm: Preserve existing table mappings when
 mapping DRAM
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Liz Prucka <lizprucka@google.com>, Seth Jenkins <sethjenkins@google.com>, 
	Kees Cook <kees@kernel.org>, Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: E6CCD140008
X-Rspamd-Server: rspam03
X-Stat-Signature: sm1xhgyncqdk65hso76oetfunssaa4xz
X-HE-Tag: 1780066943-503782
X-HE-Meta: U2FsdGVkX1+UCwKNR3ZV26iqMTFkrt3AY7GW3ykAmlch0ENmE3wHEC9QzZu8LR9NfRrNwMG5bAP2YzgHKrDm0W4TGR9lIyaBHseXCeV4/CpspvJ1m3x4eiAxA47mWy2J4GHumnzbmBluTOXfezAPwoS1UYO2QslPndXFwt4JxSNuPeWK5bm5TmUGAsKdqzndEVsRiQef6fC53SVF9C7Dm0JW5kA2DcFE+AyZXAM+b0T1ii43eE3S23iyP0t3D54W8mrnp2/JAB+CmQFAuCZtSaD3wuW4GVjKWxqsReNPrkwAgeDf+rzrWYgutEjhwkldPxEFoMG+ksadtL87eaqlT0tv8YJYt59GYCh1fLLWbkQJZEEMS1UF6FYDOGJ7li+uiAmsZPowEuaGKb7NJPlvJ894Z+rY8c9k+nZ1B+oC0SiWJHRd668a5F/zYf/fgasxdTc0KOYsbcJ1s1Sb26pfhHDl0otGlMom+mxBzoslPsXSUqmnU1nySMXUe1xG8PvvbEn0i2mh2tsKIrhvlVOb5Px1yZuivvFy8if/a1g7m+cnLZHww4qsMJ+NKKnTkLnCsAEjkVGtAkZmxh5cNzt7TOHWMEsE31DQjjyGUzOdTrLIhYSuPIxXzcnEyiY0HQSGv3SAJnrJyo5jI8k5A6jSrxsLdAi2z0ftM1tLK+gigyiGTXqc2uGdc8kbqtREWlViQWaMm6TSbvn8sicl3cJbrFts9Xxq4vd5X11SQRcFz3CPCH3MaaB7qCOK1FWQeVuBUAEFVy6wE7vxsvdHbzt1YC/I2xfctglvGKd/hlRlBgNB0K8IEJ0CysDLbBqbmv2f3wME4AVmjESHUsn8HRl4Q4ee1WumNgVRRfgQdEB+tnNYSGGfzEfucfEJFKAh5w7qNz+bbMWxlIUaTW6XKQ4XbjQ8Nh+lUJb4ORES3Qnnil1AZHLcPiM0nCth2FCWXASJZBvWoy/8zZilCuJgSrm
 +B9yF0ZK
 eSunZXx0QMvL8m7vE9ufsq7C3taGwArn45c/cXZEo+3MrCfYNp6q3QSfFpTzqxqTL8IWDx1I3H7/4LXg4YL+Lunj7rAameqP74DnM1EAYVbLjpIwm+vm3/xFJAvohwAP5HsiGsK9q7YXwf8a3mXzo7P5BwNQjj9OGRCRF8bVVAevy24GdBnUau9n2ovnjCfZYrjbMzMzUYxWLlwiIfxjYJI46Vo+BL4EKemZQlD82rUnfav0kKKDuhnPt3KSRATRACnuuiNyJlloZwMLYXIq4uk29qRYDqe8m3KoeNb//R32xTqucdF1NLm6384e8VJ5hv3WIhd24WX/8nnL48xVkLFMUeYr7c6FlNzbWXWnFaqBf+spJ3wm4bPT6LxnkFDZvttSq/vBFrvQSPztfhrbHMQpOLC1dbigS5lueRWEZDaxOQ7SHfTESK0RJTGRSL6k/FDvWesLb8NkjiowMTdS7xDIdTgvqfVne8sLY5f92sbc5PGQA5kKnFo5VLXp83pzlrNiqsXXdpdC2Cf6uDABCQxEr+wS1SkxQfBLMbFwQLFoYu4KCwtH8oDaI/iqRWclkVPVUxXhlP5v7Ecg4+6eNNP2znT0/o85dOxRSkGm7OTooetr02YO6T7DnasHqhCaW6raB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

Instead of blindly overwriting an existing table entry when mapping DRAM
regions, take care not to replace a pre-existing table entry with a
block entry. This permits the logic of mapping the kernel's linear alias
to be simplified in a subsequent patch.

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index b2ba5b35c35f..5c827fa3cd38 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -256,7 +256,8 @@ static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
 
 		/* try section mapping first */
 		if (((addr | next | phys) & ~PMD_MASK) == 0 &&
-		    (flags & NO_BLOCK_MAPPINGS) == 0) {
+		    (flags & NO_BLOCK_MAPPINGS) == 0 &&
+		    !pmd_table(old_pmd)) {
 			WARN_ON(!pmd_set_huge(pmdp, phys, prot));
 
 			/*
@@ -379,7 +380,8 @@ static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 		 */
 		if (pud_sect_supported() &&
 		   ((addr | next | phys) & ~PUD_MASK) == 0 &&
-		    (flags & NO_BLOCK_MAPPINGS) == 0) {
+		    (flags & NO_BLOCK_MAPPINGS) == 0 &&
+		    !pud_table(old_pud)) {
 			WARN_ON(!pud_set_huge(pudp, phys, prot));
 
 			/*
-- 
2.54.0.823.g6e5bcc1fc9-goog


