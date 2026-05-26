Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E56ACD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 17:59:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3313B6B0092; Tue, 26 May 2026 13:59:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26C106B0093; Tue, 26 May 2026 13:59:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 133626B0095; Tue, 26 May 2026 13:59:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EEBA26B0092
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:59:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9069D12042C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:27 +0000 (UTC)
X-FDA: 84810333174.05.660D76A
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9A36120015
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ccDVTFCW;
	spf=pass (imf03.hostedemail.com: domain of 3e98VaggKCOgKbNL+QSdQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--ardb.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3e98VaggKCOgKbNL+QSdQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779818365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LtBeFQlOADPYK4gJNp1okGIhaF4i6t2Ouexf2+2MrWs=;
	b=JuZbXe322A/MgE/OWO5K9UApf8GlkpezAVP+qq0dVszhcDdfZUtZ3r1m6010M4c3CowMX/
	E75XjkXiz7854B+Dhd/8VuZ6lbwiXxHHHEKJmfCrFo5/43EVlmbdq8HKGwfetaRYCznU50
	clzcn4XKbq4YjP9xXfL/yMKubK+3dkg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ccDVTFCW;
	spf=pass (imf03.hostedemail.com: domain of 3e98VaggKCOgKbNL+QSdQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--ardb.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3e98VaggKCOgKbNL+QSdQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779818365; a=rsa-sha256;
	cv=none;
	b=sDq7Zd5KZcIVNlZygtTdukSV2XKJTgmvqwDyj8y0V9WL0P0fqXx4Q54QHHJiwB5wCyENtV
	3uQLTO8hTxINe6uZ+nr9cHe7o2wBEzVaVRFqnf6wOZsmQZ5F5CwucUtXyuNG1L1JdQpWHA
	UrPUGjnZTMyQN576JPsM1GfR2ZSZR9U=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-687157a1739so7839804a12.1
        for <linux-mm@kvack.org>; Tue, 26 May 2026 10:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779818364; x=1780423164; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LtBeFQlOADPYK4gJNp1okGIhaF4i6t2Ouexf2+2MrWs=;
        b=ccDVTFCWUfSRp/Ai+dNUG6FigWlk6mIKSRFjVOllCwO1aJdoTIqEjSCf0sg1I5zQhx
         S9RyT5ez3GRJABrhiKeCrnZCoSt7Gqo6LAD1xwqDeznL6K2eQ37WYBoY7wDwcghKsi67
         3Xzed1A4PtIwrfeT7ZNKAEE/sBPWaUIOEYwTYXXb0RPvkzxi5oAzOxcecGPEnI95ocZ+
         VIn5Bjcx/nwWpV6jRp85spB6jN2Gr0iMM3MdND66h28s5L538q6KSe46RiuY7Nc1zebN
         ciXBjT4mU3qT483dC74lseBrM1piZ2fSij/hXEkXYXNtuLG8Q2WRlvO8nV/mK1P77XiG
         V50w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779818364; x=1780423164;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LtBeFQlOADPYK4gJNp1okGIhaF4i6t2Ouexf2+2MrWs=;
        b=JcdK8gbjWDJVt1id8OfFwHDV+i8Rz3LFtT3GqScWBBUq6GoCpYFpzkd9rEF+6yVWb1
         QHRv3xJNCNXdyLMwb4lB0NMx6G8rmIUqilwvFHTLmiaVM2CyqM8lVKdVvFeUQKIYJUdZ
         /SioQ25aa/rtN3CVctaveXQCK9lUNYS7iukPnkmiZ0TEEBzBSfxUFnqTlis2qhFypn99
         OxolfYM9WgtWFhMo/lYDZ23Z2bP5gLJuiqxL8FkGqw0YKcy1GYJocH53Jt5+kgSIzwfo
         SX9az08X5uVtUiXZbeYqcm9rdEaUHQHwbEAInKO0O5ChxRn+iV0nVnqG7wqq49yrxgLc
         jidw==
X-Forwarded-Encrypted: i=1; AFNElJ+MuGKGNdq0bTPqUKeAQM/0PtOZmP3AgLauyLbcxQ0B65iGJok7PW6JsR4pv2mbGFKplhOxM7ZtWA==@kvack.org
X-Gm-Message-State: AOJu0YzmJzP+Jfumy42r6GiH8JPmiYiPKZN7iD4CfAVxKktlQZRXlvQR
	E3nbvFpPpUw5wBOjOEK1jMAwaw7ntzwr4zHcSmRWzEji8f2lSjipPDJRIJG+fnfmaMPjqgUDAg=
	=
X-Received: from edye18.prod.google.com ([2002:a05:6402:892:b0:67c:573d:d3a0])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:40d4:b0:67b:cd1f:9cc1
 with SMTP id 4fb4d7f45d1cf-6889c445088mr10125279a12.6.1779818363764; Tue, 26
 May 2026 10:59:23 -0700 (PDT)
Date: Tue, 26 May 2026 19:58:50 +0200
In-Reply-To: <20260526175846.2694125-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260526175846.2694125-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2121; i=ardb@kernel.org;
 h=from:subject; bh=UYuabKAGVqw/38U/k7XQfrNPG5ThRXq/7mqnsjcGnSk=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUv0fvTm0BsvTTTaUheFf26uWyada7zXR7A5ui2rSTZi1
 o2FJrwdpSwMYlwMsmKKLAKz/77beXqiVK3zLFmYOaxMIEMYuDgFYCKHcxj+Cl+U+L3mz31fZxuh
 tHcrzdsEq/i1War/p2x78yRMa8USUUaGzw8WujlZRJw7v672d9asvI8f57TITLjpqnwn3Gp2wO5 +NgA=
X-Mailer: git-send-email 2.54.0.794.g4f17f83d09-goog
Message-ID: <20260526175846.2694125-20-ardb+git@google.com>
Subject: [PATCH v6 03/15] arm64: mm: Check for pud_/pmd_set_huge() failures on
 kernel mappings
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-sh@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: yxzyrqb17utg9i3jekhjt9wubcx186eb
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9A36120015
X-HE-Tag: 1779818365-962429
X-HE-Meta: U2FsdGVkX1+t/iMYMmK4PKPEFd86CrXqWOVuzptLw2od0FyB5lPDUrptkEPj8cUScpW66RlPWmTScyLadUuK3cvBaE02LcO7P7OrYQYoMSHti93aGfXRxDJzIHVR4dDur3+XJr/dW6/tHNrInHOnNxvJlpipoATRhCSN40df1vEnsOpw/Zqux+L3my4s3AZ6+p/HHCJRX3v94wqkcODXJLyJ14jCnw1ngFI6+4JfUWWRItXpemLdV05YoEB0RWgtP07I5Yv2twbwZ1B2iIQC+T8VSfrNyoT4u/G4jAiG4dpBltfdJAkqrNraNGVBfHXZf+CQwYO+bJJ+d2waIYgrpbNpV5OPwh2rdW0OylF9hoZWOat6b8Ja/XYjb6aKKC/er0tBu0uwBkrtBZfvP7qeEbcq39kDTgNWf2Y25zZ5R3GoubYmMJzmoP8Ol3NkvL1r+OzxCnOsJa6fJCCxb5Gfyu2kA/YUnPKjEACtCzIhmVXnLc85a+OLLNoKQant6qK937ySUvNzW96BBfmXMYZLVR3p4vuslUIsmy6hCK2w6MudKe8fAIY13ETuS2a9IeTzGx6v85Hb04cIbq+6vTTSep3U8Zj1c3NJOEnKg4WG3EdUxKTtvN4jnXUnq4oue+GPECyH7oInchfyG/cVWwhYi38GykFnMjpIsrA8mvf9jgYN6oN9674oSfwGYNoRKUhBeGZFD0eho63AH2f/hnFVc3NukJHZc9hZs+fYz5yx+Or66TPjtY8jTlr8UJJJukI7jaR232KOgHhbcZ6ty7XYePXTMQODzoMdtBVE473/l3PxyXLDDVFQIzDQpm2GDeZFfLi3DSvi/yqI40gvGmrxidIs/t999W/Fhwbbj/U29t54cuvbfDbwjBmlmst2HbdjiAOPCACqE7xLgML4MPnR6V6qvBo1mofz5KysXLJtmV3oojBk+OmN7oWtS1aFg3yRg9RCYqPDbybjKuQE8+y
 9ZHSctXt
 rWmTA3yYlmC7xkKhrOICeQORNzKOhlRM6BMPtZKenxIgWZhq6on5rRvo+nUb61QW6JFpx7ArAd53rdXLd3NGEW4Zb2sy7v7+wddXasO52LdB3yLhhsV3c56/Vl4H+5iKQnFBMAu/yuZ9MHb9T7I+EpEjkRjXGVUI1m6DPq+UL6A82CxJVeOqWCSu867QwKitpWlkDWwM659TlKEkqXBS9HM3A/EXxovqfeLGWqdL3a1GLfId76MR2Ef0wicMsbpaguKo35SD0s7bCpwXiamMEYTzxEa6BFoX3XKgB9k+pWDE/XCy9SgeEFDroHcTzIOTbngMvJClrGZpB1ODYeBqiOlsBOH/oULq90IogNpdoVqqVzWzi9XDA4fM7088SBLPyJy7E2Wl96X5H4jHeMji3VSUZsmTbexT/XKTQqwVJVrWKkXcT+ENNzWuQkLMO8dvxpLkwuq9DOVQBsSGfwrrRXjr0GQABDmJqEMDWEWO3adeU7H293Nfpca5uIxkljElpKUkc+KqpjRXKLekVeoxbTXGhHqY96RTXufLhiHUV6lw8YvURwPcjUSJSOusHmVZ8gjAVWcR2ztG4M70A4PLgMVAlM9wzMMjW00T/1RJdHnfRa7YGtiTjkmY3cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

Sashiko reports:

| If pmd_set_huge() rejects an unsafe page table transition (such as
| mapping a different physical address over an existing block mapping),
| it returns 0 and leaves the page table entry unmodified.
|
| Because *pmdp remains unmodified, READ_ONCE(pmd_val(*pmdp)) will equal
| pmd_val(old_pmd). The transition from old_pmd to old_pmd is evaluated
| as safe by pgattr_change_is_safe(), so the BUG_ON never triggers.
|
| This allows invalid and unsafe mapping updates to be silently dropped
| instead of panicking, leaving stale memory mappings active while the
| caller assumes the update was successful.

The same applies to pud_set_huge() in alloc_init_pud().

Given how it is generally preferred to limp on rather than blow up the
system if an unexpected condition such as this one occurs, and the fact
that there are no known cases where this disparity results in real
problems, let's WARN on these failures rather than BUG, allowing the
system to survive to the point where it can actually report them.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index aa0e2c6435f7..b2ba5b35c35f 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -257,7 +257,7 @@ static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
 		/* try section mapping first */
 		if (((addr | next | phys) & ~PMD_MASK) == 0 &&
 		    (flags & NO_BLOCK_MAPPINGS) == 0) {
-			pmd_set_huge(pmdp, phys, prot);
+			WARN_ON(!pmd_set_huge(pmdp, phys, prot));
 
 			/*
 			 * After the PMD entry has been populated once, we
@@ -380,7 +380,7 @@ static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 		if (pud_sect_supported() &&
 		   ((addr | next | phys) & ~PUD_MASK) == 0 &&
 		    (flags & NO_BLOCK_MAPPINGS) == 0) {
-			pud_set_huge(pudp, phys, prot);
+			WARN_ON(!pud_set_huge(pudp, phys, prot));
 
 			/*
 			 * After the PUD entry has been populated once, we
-- 
2.54.0.794.g4f17f83d09-goog


