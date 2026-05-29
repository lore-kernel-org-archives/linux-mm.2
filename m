Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58DFECD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:02:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7A876B00C1; Fri, 29 May 2026 11:02:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D528F6B00C3; Fri, 29 May 2026 11:02:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C41AA6B00C4; Fri, 29 May 2026 11:02:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A67A06B00C1
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:02:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7359E1C0255
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:28 +0000 (UTC)
X-FDA: 84820773576.07.CCDB94A
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf19.hostedemail.com (Postfix) with ESMTP id F1BC01A000B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LDBJotU6;
	spf=pass (imf19.hostedemail.com: domain of 3gKoZaggKCJMxE0y+35G3BB381.zB985AHK-997Ixz7.BE3@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3gKoZaggKCJMxE0y+35G3BB381.zB985AHK-997Ixz7.BE3@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jiyjEGpnno65e28CupjUd9OJcNW9bWS5umqxs4/DfeA=;
	b=RhmH1fHhNj4ATkTI5XoxmFKH9LK6rCBQl7VO8oTLjJv3swSGblwe+I0gAuzu9KlvIp3Ssl
	9eeXSBylm9Dig6RqhnFYzKCjyu1AbWtdibxcGrui+rE++sMwBH3upuB1ZXyGhS7kAbksRh
	Xc7bGO0w6Iq2YWWOLw5WbY70GxzBdF8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LDBJotU6;
	spf=pass (imf19.hostedemail.com: domain of 3gKoZaggKCJMxE0y+35G3BB381.zB985AHK-997Ixz7.BE3@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3gKoZaggKCJMxE0y+35G3BB381.zB985AHK-997Ixz7.BE3@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066946; a=rsa-sha256;
	cv=none;
	b=eyp4eBRusE7jp+ukhmw7EGKefMUQ6FYTRgGH5jvDLLw8DyJHL5jWjVytEQHAs5EZlD4XUT
	PJSoB8rP4byXaVvBW2b2D7VkTOYd55RrwYpk0u0bi8xYGVFC0mztOhDD1ioYHIzVYvF9Ga
	GsZzOP4LnFwAbXcOuRNK2I1dIa2C/s0=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-49041d39887so57610565e9.2
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780066944; x=1780671744; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jiyjEGpnno65e28CupjUd9OJcNW9bWS5umqxs4/DfeA=;
        b=LDBJotU6cDRMBEZO7mgf/uXgSnr7ZF16z5QYC2yunLeViJb6om3DkoseT3eCPq8ROV
         P6NoEWX9te2nbazbbgXaaRpZhDNemT3O/jnAzbzWgBjSbsIi8MRmoCFfTHQlubDj8+tm
         CLkJq1IGsegQRjtFUYOzayXiC9j/yN089tzUWY7h2+QS+u98bo7mvlvGuhwqR+q4PHDQ
         AmIX94q8jd99RXCVseDaDZfJxMM5jgvdUna2feNA8BMYqYyZ+lh6VvU93WXkY8QORCFJ
         rvl34jkPIDED7GJTJ5T9ujFdUCFA6r4tuQZi1OisjBQKT6gPBYsPeXaiADLM8ds1L1SV
         mwqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780066944; x=1780671744;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jiyjEGpnno65e28CupjUd9OJcNW9bWS5umqxs4/DfeA=;
        b=AC6J1NGv7l8ryC6mu99wZr4HYvyH1HCGOSyDFXSD+UnSdnrBeOei8B5KUFDxBONeM3
         S73QZhC69Ke2xQtIfPGUW1ZJ10DkI0ONA/yImh7dhiKP4Em2FXvwwLjIGaUZYDR1TuF4
         M9FqKIKeDwl+0bVb0XVO2wXFbMBXNPUJZIj32nbv8B8JoX6/qfmUCvJfMmygrk4BtBOR
         JoVrWlncbjPU07KwrH4ndnKyKePYEoLiHzAhwa423n7BoJglNSorwOHWvcHXyeKu6j18
         5DxIhSlHY+FjWEQJQ4ObRd/DpX5tnrPhbVcV8VkyP+gWhf+wbnh7zYxPH3ePtxTzZPVU
         huFg==
X-Forwarded-Encrypted: i=1; AFNElJ9TXRnh0nAyGO+6jIRRkDoZYQVoD3q8SCdK4n4+1Nf1xhipk3tKt98xsIzFpWNyM9ToVVr3rmMZMQ==@kvack.org
X-Gm-Message-State: AOJu0Yx8s8DNuzZ2qUGcH9pGDkVYBJSM+Rn1vo/QkEr8uo9MHbUE9k7F
	AP2hQYOImuNjdKd7VKOswzitb4IICn6ZsBUtzBmh0MUzWL10K0huYiznlTMDX0bYkmHU1fYgvg=
	=
X-Received: from wmbgx19.prod.google.com ([2002:a05:600c:8593:b0:489:1d25:1a63])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a315:b0:490:53d3:4767
 with SMTP id 5b1f17b1804b1-490a2912114mr284275e9.7.1780066944330; Fri, 29 May
 2026 08:02:24 -0700 (PDT)
Date: Fri, 29 May 2026 17:01:57 +0200
In-Reply-To: <20260529150150.1670604-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260529150150.1670604-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1543; i=ardb@kernel.org;
 h=from:subject; bh=aFPaV3eZRwZbfRuJcOVglMiqpjLOoyYLSair5CgEE90=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUtyVZr0Ro45KbG/U3TOPQvc7JNkwC0kaWy1cjWvuuPuw
 kXLLSd0lLIwiHExyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgInMk2T4Z7Hw4UF3Zx6hsg1W
 SuvzdNwYJPwFeT9LdVbN/bJSSk70NCPDCQPV3OWP9bYd/e+4xmP7gWzbOV2yZp1zagvtpm/ydwp nBwA=
X-Mailer: git-send-email 2.54.0.823.g6e5bcc1fc9-goog
Message-ID: <20260529150150.1670604-23-ardb+git@google.com>
Subject: [PATCH v7 06/15] arm64: mm: Permit contiguous descriptors to be manipulated
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
X-Stat-Signature: 7dnycsds718w718kwtj9gj6jp4fomnsj
X-Rspamd-Queue-Id: F1BC01A000B
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780066945-484018
X-HE-Meta: U2FsdGVkX1+U6gwaxI8f9Wqf7oqQ1U4GiHKay3DbwqJaH8/TSUY3VyHpBSr1gP1LttN2IflWMTJV022U+NSYeTA0muNqzySWgHUIOAUa5qoRfchw2cJHRg3gNuoKMcIm/4+hKF1WIanUuIJLIk95fVm5loX8o471cLXJY8u9c8M2ElVLRQ8WLuL0IWNwwv7K9pelpuRIJh9sCO6tjDzQUTQ8qy8OZxXj42nohHOh2daupjywFOnkj3NNlX2+iu+SYvHErssiMJU7xDSdx3E2cv0oPdC8Og2kKZc713sKaGZ9c7Gx6tY1UBAvIATyrHxlrWRdHpDALPQtHFcYjKaoU6VcLGn5Mz1uhjfy4MLqSAXou9VDwPOA+jNklZ83/SWN7/Y6aIIAtJvtNghUyJoOM/jfXESiJAL2cAYY9tmxCCDNJRbS85dznUk6tdZKRk1ql/QSgPG26F0c6g70TWqN0zktN/OZVRj8XroadcDrilcXaSNQg44BN+1OwtHi5CFQi5X1MtNFkoOhlZ9SqI2TYBupp8JrM/BsKIJz8Y+RKqilax9FtHqovK2Wpk+BAMIEf29f7E31DznNv/tQJwyKO/mwzrRLjADwNs/XFrOJjZhyPQUNlphb4EU+bRcVoLIGujjQUoZ/UVJz76EqmM/RDM4HURD6Fum3WiyzZKWQbZ+0S3OzjXEpLkh0M3lriaJ6trLcUd9B59mh2FmoyiDsk1FIYFY5/5uUg3EoH5/04CaVUj4QAEkc/UQPZNmd/BauFpnuPkJw+T+cU3gwvY/G2NkGzDp4kQB1Do2QHPi+Yb4UzLqrjOljlF0e/ZKn86eEc2jrkuS22xeSit8EvyiQylSselQCV9V5+OLkcQL6b8Ea7Nfg3h2I/D/pmrY9xUS5Vc3FZdAyyeWXWQxhuhezIAORY1g5Q7ciH9FEUeWvJbiIOw1PFV/JTQ2jij+6u7H1Z7XFtfUITon0+CFX1uI
 znSv7ywA
 ASgmPyMhPa23coewWynNvoAMqbTft81sFIEDou0YqdWXvtH8UUlyTYBQB14bBskh3hrEh+XlVt8Ml71FRD0Iq2cNlqiEngh9m5GWwmih7abQHTNR/3pubAbivQqP6JzoCT+sGq/prj/PGJLgLe90fVlfleZzYDm7SgmeXoNnzMFyOdiIUzG11SxdtKGPWK1bVfc1vtSpcluT75/i6RJf6LsDeaWzzg+9TYTU6Shixcm381/L7cXI2NNg9HxzHwY0Nz9y66oU/mo0DaAucJ18NmajpUs8yLYBu6TfPEOsuzDFTDiU/LrzXDK7HutyUWz9jfWwtAIDBOLIbFKU422kGNItHkQOxI2XCR9llYXaDEuUAIue3dgDAwhwRUvnS8QpdIG5AsJ1dlHHhwN/9+7g6/SDsgjvAR2X73j/ZoFnbFET8Ye9AJZSytfbm+XieskrSvxNtaGoD0XCcD9UrmXPxUiPUim69J5yhphRI3LURk4u/b0cWM8w0dgEYcMxK4nkdG5mIficsiggZEi4TAR5oVOJanKAh+rnRqmeXKkfePuHRCDw7FVTuCCbE6uPqfyzNGsmO
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

In fact, as per ARM ARM RJQQTC, manipulating descriptors with the
contiguous bit set is safe as long as the bit itself does not change
value, in the sense that no TLB conflict aborts or other exceptions may
be raised as a result. Inconsistent permission attributes within the
contiguous region may result in any of the alternatives to be taken to
apply to the entire region, which might be a programming error, but it
does not constitute an unsafe manipulation in terms of what
pgattr_change_is_safe() is intended to detect.

So drop the special PTE_CONT check, but still omit PTE_CONT from 'mask'
so that modifying the bit is still regarded as unsafe.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 6b42d724bd1b..d7a6991e1844 100644
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
2.54.0.823.g6e5bcc1fc9-goog


