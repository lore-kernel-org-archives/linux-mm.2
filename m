Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D38EFF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:55:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D18886B0088; Mon, 27 Apr 2026 11:55:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEF886B0096; Mon, 27 Apr 2026 11:55:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2CD06B009D; Mon, 27 Apr 2026 11:55:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B1E716B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:55:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A6574432CE
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:47 +0000 (UTC)
X-FDA: 84704735934.20.DFF79DE
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id 977DF180002
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kbuOCgcm;
	spf=pass (imf16.hostedemail.com: domain of 3TYLvaQgKCGYEVHF+KMXKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--ardb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3TYLvaQgKCGYEVHF+KMXKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777304144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+WwzihijZssqSOtMqDRFEFZS96kFccDT7AOSNModvwc=;
	b=g3WbnBl/Q5ArmagnmAnqVxyZtdQ9krVsBTNRyKrYJP1/BFCIxRpY3Pcy2+5bhYmrkcbTiD
	5sVcnR3V66Fv/nmv38TclTrw7mtgfB9DnC57DRLZPXZZrco4CCVmyMFtFCWjBmlCoO4pcA
	JcKNb1tVjOiQ7KlBwCbhDELB866OkbI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kbuOCgcm;
	spf=pass (imf16.hostedemail.com: domain of 3TYLvaQgKCGYEVHF+KMXKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--ardb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3TYLvaQgKCGYEVHF+KMXKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777304144; a=rsa-sha256;
	cv=none;
	b=AUAuona+fjvTS+ZOMeyHji5/hvOckM1N/es4YhZhfq6naRBxCW3Zowmc73ozSRWLoJN+gp
	ozAqZ8yuft/6V8rA4gN1b3wlRZUNuFyJ76DPsAcK0VtWFwKxxva9F7pKERoUCdtraP0sWV
	sOYyDa1hj0ULAWO2TNLl3k9EOj5m6MU=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43d1dea12aaso779637f8f.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777304143; x=1777908943; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+WwzihijZssqSOtMqDRFEFZS96kFccDT7AOSNModvwc=;
        b=kbuOCgcmcoUiVp6YFepPXPwmPZBjx5lcHYP1fUkThTOT83quJWyHYZNql9/sYaU1Z2
         ovKkFUyRNTefeSlxJ9qYlD3BRq45r33VrZapBxcTSIAU+tmxhK9NbjQpjfqGhpLuWqHC
         +xBV9wgb1UrgMfZ0rFF1GA71un11ZO0iNUeOTyl0f1hrCmrHXWKxyu7qxtVH8nQbgDxy
         PA8/n/FS43npBJkMUxwuHHYxWLS4HX7oSOrt7h6AkGGv23fB40GE5yB+Yi+cRrzCJHR8
         v2vgsxRGxfxgYiMiD1wY+2sMaiHf7p0c3zAj/9DfgLXTplybUvLcUol16CF5PxEsLmPW
         Dvow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777304143; x=1777908943;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+WwzihijZssqSOtMqDRFEFZS96kFccDT7AOSNModvwc=;
        b=em5XouIfjL5kTuKq9Hjj4spHJ5U/NVl8m5FW/E94BsW4K/S1WwuQowzsiPRhpM+2O7
         XKR+Sjlnu81Tqx1bkKt5p5cmk+prOLZlW0gLgziMo2xwaHx9cY+S+fXk9X3bw0/wlYX2
         v8rLIcUa1YLY0r2UXrDuFefSvtELojQI41oM+Rzi7PeE9YeAjs8YJeMaPTdOn3fZl6qM
         xXtE/0+3EixKy0DERFFu2iJjQpFY9QRaTQB2oKv+f+VQxDHM78NFjJ6kfnbO9rICav8a
         byf7Rr4XyxwMKiF5TYF9H9xqiPci/K7H2/q9CfnTFxlY5nsWbDw1Kq3SAomTXamgkeZE
         Y79g==
X-Forwarded-Encrypted: i=1; AFNElJ+kgGSnt4B+ePlHKea6DSzSvSxtOX7TrI6OpTI7xSY8fUKZpMR/Fhlvw3yFpEqfFhkDnqTAheQl+w==@kvack.org
X-Gm-Message-State: AOJu0Yzm0FhzNim5UniVmf7O+v5co+/ZCI3mAk0yP5iv4/xHVWBEPtog
	IMDrODE5XFF6HQWb9D6ocBRsoVkzxcvMQyklVxhGzZ2+bTR3gmB3grj3UlEFpwoqec7LzK43WA=
	=
X-Received: from wrbdy16.prod.google.com ([2002:a05:6000:e50:b0:43d:729a:b525])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5d05:0:b0:441:247a:e98e
 with SMTP id ffacd0b85a97d-441247ae9ebmr36895346f8f.24.1777304141472; Mon, 27
 Apr 2026 08:35:41 -0700 (PDT)
Date: Mon, 27 Apr 2026 17:34:24 +0200
In-Reply-To: <20260427153416.2103979-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260427153416.2103979-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=918; i=ardb@kernel.org;
 h=from:subject; bh=2M+2R/xfGuHti5Wurk6r5E9xqbGluJyDsIl7VYMOsyI=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfN9E8tUw49az8LPeSafvHDx3bajk3bfqxCf4/ElO9n+i
 EqbmadXRykLgxgXg6yYIovA7L/vdp6eKFXrPEsWZg4rE8gQBi5OAZhIxHGGf2rT5kc6JZw8EfTc
 dtq0B6b/C6uZdnxyULeaKj/79Ou3L1gZGd7fr5d6L8ZyoL7vypL3Bx1P/wzxNdu7JOz5R5H7c65 9f80EAA==
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260427153416.2103979-24-ardb+git@google.com>
Subject: [PATCH v4 07/15] arm64: mm: Permit contiguous descriptors to be rewritten
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 977DF180002
X-Rspamd-Server: rspam06
X-Stat-Signature: kf96xwxwk53q44f9rs5rgxjft5dnjjb6
X-HE-Tag: 1777304144-347402
X-HE-Meta: U2FsdGVkX1+wK+URyKonlsZdWFzyQfSh8Qb/uyMl/BCALCRWKqpS6o4PV1Icu7fUnFRD8FShMZrk1xLTisw+7NG45zLV9zgkdAvkK3eEHn61y8r4NsnhW45leK4N1dl268O3GC0vSSuo8JW1LdKRZim9Tz+Nfct2/4Ra4XQQKCIBroY5JxiHU9SBIdJtShzwPEPnOld+HXn9EH7KhcqUYxQ0q6CW20gp7roBNjA/xPjtMTSTwDPbQlshA0JO9iu1LBttM0pmtnjH96zbOmFvNbEErxYzeJms2HbTtib9iBcXjgC0/dEhgSVwsiJ77/jWE2AeP5lpZJ1jMSlWvoCFLgj37fWajXxC/B3XYiNuWmtom36OSEEYsESlULapO1bMNSsUiLU9pQydkkTZQglv6kx1W5OiSIoeh3ruo59o8asdgRVDkexsExCpNPlSVR1VRfFsrQnyGAELdgSk5s1Avf5Q3JMGUdZlc9FulN4wXz6LcFVUltFnkWVbLRmI22+n7Txom+QCJ7M3euesNDr8qnCgKZJQy2LiJlD/d9XLg08+IFazLlm2LUHocrfqpryPG/tCcDQtNMtG+M241X/+7a9a0AA2sOmadq3WN5sYwOdd7WfvdXZlg/sapL0NQ+lEb/7d45bX9iy4ls1kR/sBrtm6OBsfmSFtI5jHt2sAbsdEKPu3ViVeoSpIIVAE5AejW3wQ0sV5awhSkDivfw9xOW8zQqUW6lsWWIN/p5kGkwNmHzQ8wTLJ7UcC7SBS1M910RiV9LsdH7CEyrARI1t6mFUpx/sI3iry8jvq85z2CmTZe/VI+7tC2uErVIkHfEJJqdo89FRg9vuKGqQ9cIAjOWMswQTuq703dzIE/0uhFbVOMoMzGkTePG1/OXB5u3WaBjtI6kSCY7yk3LhvoZd0m9/MQIQfMXPSdJOnH+Xvyru/UzD2LjSoIVvHzJLlkuQFJG9eDD1q9YzC5eRBWra
 SCFCB16Y
 /dJFlSqHjMaZhE0C/ShhwijyBvUea5VZiGK4VIhJkwkm1tYOTRwZPAaqMy2YP/s1dnzKupQb+1dQD1agv9DUwa+T2WVWE5AEE/1xSmwnqfz2tcyQ1d4vPThiepf22QeK7NYZyQ2F6zcoE1d/SNUVlTWSqABbDOVchxPVKF4szaqyg459buKsS5kpNjzpu3EXc9cZcLP6trWGeitwckhTyX9ORfquJCfWP7cx8+P5lHbhMbmyHGNavAPwKFsSWrNdIHDwJKSh40ijwsBiOx0q/u3ndY6FLqXJNgMhjgtV12JFmzmB0QbhFHk4YdPOla2GyWr6L/xsyPkRYRcVvMtCapCLeAI+TQTKSR8URHNEGjZRzS3jjlSlIGmNVE4zvdA7V8TD0zJEzE6VhbnfSPekLyB4LmO5u0asE0bMj3x+csLzymmmczwKM40x70bJbhPwwibDKrL+QDk+xCq9mioXc7G5oQplqDNHfeDGkgc0LB80KbLDHZc33vVRJQWqYls4N7nMaLVkQXGD7LeJbQcRhUI8aTPJsqMEYvvqXb7nNtrc/N3srnPj6L23hGEtMw4VLIRXd
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
index 9610dd2d7bd9..bfb2f1cae724 100644
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
2.54.0.rc2.544.gc7ae2d5bb8-goog


