Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD35ECD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 17:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDFF66B0096; Tue, 26 May 2026 13:59:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8FEA6B0098; Tue, 26 May 2026 13:59:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBB3E6B0099; Tue, 26 May 2026 13:59:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7CE06B0096
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:59:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7A9DB1C03A5
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:31 +0000 (UTC)
X-FDA: 84810333342.02.52FDC60
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf15.hostedemail.com (Postfix) with ESMTP id 90C48A000C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:59:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="u/OnXfLo";
	spf=pass (imf15.hostedemail.com: domain of 3f98VaggKCOwOfRP+UWhUccUZS.QcaZWbil-aaYjOQY.cfU@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3f98VaggKCOwOfRP+UWhUccUZS.QcaZWbil-aaYjOQY.cfU@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779818369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cNZ6xElfqK3A4SE3F9P829uWscll1GihYVBHckeq6A0=;
	b=4RvPKdPHxUKoLj3D5afjiVl3ZaFkJx2QmGIfh69lvWl16MGc6khIXPoEdbJ9mswG6Ve54+
	FWOegSBxGfvm0PVs7n8qRk9wfwta+Q9C1QBzmEw7sfAE2LMkBv2dynk5xracZn1Tqz3OKz
	Kq/Vm8aVsILtd/B6A3dENAFXq/USmVI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="u/OnXfLo";
	spf=pass (imf15.hostedemail.com: domain of 3f98VaggKCOwOfRP+UWhUccUZS.QcaZWbil-aaYjOQY.cfU@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3f98VaggKCOwOfRP+UWhUccUZS.QcaZWbil-aaYjOQY.cfU@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779818369; a=rsa-sha256;
	cv=none;
	b=tq53QmfdKMkEGP7SR3csmC0Ptidqb1x14Wa0Pev5NYY8R4jDv35fdtmbGkTKsLENvjClk4
	PoI21EaqGZ+UTZeQYsI9Q7nJIv1p6jVCKar6nlUFLzx7J8PmjT0qL4uy8K6zVSwtyMnWRA
	D12IGqoTa7qURvLH5B1wmgxcVYkFDbc=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48eb0da933fso75100985e9.0
        for <linux-mm@kvack.org>; Tue, 26 May 2026 10:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779818368; x=1780423168; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cNZ6xElfqK3A4SE3F9P829uWscll1GihYVBHckeq6A0=;
        b=u/OnXfLoQppsfO6ALR55yLhFNNlQPawdo6YWliagtLqRSpIVCYHyfJg34zcqDlKvza
         LOXYfzdYFJ8PlG6y/ELX5deXHFrqwdw9lWuhsTeaYk5PXv4pdD4kNhnUqcqKLhGw1ecU
         RUqBKvkOzPGjchX/7I4RZMVnU4mEYx8uoFuo7KxojPpQYJxho6IbixofovrGFWCx38zh
         L2y7GVpnfCY5mfIS2xulvx6BXtAIPAi09X/okeM3fx4Go4ag6yhZ10jECxhL1vvH61sI
         0f6rox9YgUCDiPsgZ++ywo0jRmdBgi5Vup5Vdshauw09bSqZsRZ0bEMojTNen3Pnsy1b
         W0wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779818368; x=1780423168;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cNZ6xElfqK3A4SE3F9P829uWscll1GihYVBHckeq6A0=;
        b=DAH2JLh4ZpX3Nb6oog5o4lPmHLbsAZwfbs/m6VNSscUl8zZByPu9Ua1meANBNqCFh0
         qCoZTT/7aQ3ppt6Y28rK7HqNDh5YbS9B6uSZmzsVVSIjM2Mq0i7B9+FpKKtbs7xYx82D
         q/pRAK5EO+GgPZy8T4N+J4bL6GXo2Y5YB89PsZVC5UC708rABA1rNC1LX2vhmgvT3+9j
         WmQammlnPxOFccaW94ZgMuQr7OHY+yU6RA7M0OpUWtH5w/u1YfYVODetZKKSdaVAIike
         ha+Pn9aTyrlEjsrEUDKup1KSosyC983K/e7VIM9044s8gL6D4NKpPAuJDcjgZwCh0gKg
         IHQw==
X-Forwarded-Encrypted: i=1; AFNElJ+wHrrB7eiMVAMJhPfB1Yyq/1xWc+Ohpg/71PIOujnEwZA08YYdhAcWwg5I37G9IO3qA1obd0q9mw==@kvack.org
X-Gm-Message-State: AOJu0YwNQXRZeQF1i7vlz2fCTPuLR7ZZVh4Kb0EAaRKxksEzmWY7X20J
	QSwwlAZsB1vCTZd/AQ1N8/GtWMSImggLEOx5iV+1MeIdYQHC7HsTXoGykU042mACDS3FweLtOA=
	=
X-Received: from wmbje7.prod.google.com ([2002:a05:600c:1f87:b0:48a:5970:2007])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b97:b0:490:52fb:12dd
 with SMTP id 5b1f17b1804b1-49052fb14fdmr292012705e9.10.1779818367951; Tue, 26
 May 2026 10:59:27 -0700 (PDT)
Date: Tue, 26 May 2026 19:58:53 +0200
In-Reply-To: <20260526175846.2694125-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260526175846.2694125-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1543; i=ardb@kernel.org;
 h=from:subject; bh=0Wnsvtw0Z2vu8jTM+plTHkuWXyq+RnVgc0hID3nHEQ0=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUv0fnxSZsWx12f761qXqC0qS65U2ZVyr3Slf87jmSwTV
 KRvvbncUcrCIMbFICumyCIw+++7nacnStU6z5KFmcPKBDKEgYtTACbSLsjIsFvkWXjX0hVFJxZW
 Ldt97vPXdU3PRc8XH9GZ8UZlg9pB7T+MDA9i+Q/xn5Hz+Zl1U29m5LMYieUfPCfvSXROOpI/3bA ngBUA
X-Mailer: git-send-email 2.54.0.794.g4f17f83d09-goog
Message-ID: <20260526175846.2694125-23-ardb+git@google.com>
Subject: [PATCH v6 06/15] arm64: mm: Permit contiguous descriptors to be manipulated
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
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 90C48A000C
X-Stat-Signature: riyz7rs16jktde1d3ej9z6m3jwwedcqf
X-HE-Tag: 1779818369-587791
X-HE-Meta: U2FsdGVkX1+mmO74bqCwI+yvJB2zKXS5+UxkC7jASK9HPMfqnD+DyLJbpr/4Mx9lHhRu03B1AAGXGkkl0aAPorRZBagN7tHELlPDUxBeUSHkocYS99cdmc4aHXEuf4bjel1D4ePrF4X0eQ72TiaQjeNymFdAxLNw4x5TrulPpbjWThEH/Bmif2HJPNqfvZ+kO+VhEEYWlQHzeGezt1vQjAZEUeUwWyMc4beKkKlPyuTYo4Xx8Q42+iRFIu0V3+dcA67U/q88jkDJVTxSbnTFOOGvg0gKcZ/XUvKDg6O6DYYUim4cvEsW+Opl74ZPfp/E6uXJFQrLq0Ux6SYSblnqLXQRgLrYKJX6JYaK8KFLZgcZLQWlFxNu4PgtB5dkHEyOz5yyhlxlRkVD9dPtTpnv8EiVuhjEDMLwhPnCbA7n0VSLbjEcbUXXQljl+06Hl+xDVYmvRG9fCHNXz5jl6HlseIy/GOEOiFYEbX5gwrpzUn1psFuvEXzlE3I+B515yCn+XlRuKLlfdYztP0UOpm9veVP7qs4yDhc7GroSZvZlNh2iFmwqWx28pyX7Rl4gK6Iqgky57i71/P5KVcVgcNkICklNloiM4QtfFoPlmDFE1Y17KP4O8BWtlKl9SFG5VsnzWy52dypyuL5CNV7GiuO2WDpRmMlQoRH1FwOckoC//BkGoCBzaj+uSIjRYbpzbIearfRnqGTvP4x2x6WP/mjeA1zMROpdLDV3H+2zxlCPkLsLpFg+tvbIYAQVdjwo3eHFbEJt9ZLnRsQPeczHsbgikNIEqxNJqIKwl6BmPrlax93V1rxS7Jy0znP4DHT/mw9mkgG+CubWviFwHBEM/D7P/lrLwHt7axi9SaSmSxL5tZUubKyYKU1XfgNskkwthmkA4p2w7VtWt8KIkXsGKCz0yOikQwAQbDMPwHLxS69psDO8bhim+sKn/3JQcygKnhAMTFlQgupvp0fYGZwFecy
 SheRu5zq
 z0Qgofst7VA6gL9NE9szO671e176A5e84cfpoVDzMdNRciBJ5r2ErPX1cBgYoXGrJbQw6LOZzkmPimrulU8iwHz5LP1AnoYo1sgL/faMGSV0e5g2aj1Kwg3KMAFdtvEe0r8CVMAWzE8ENnnctL4f49byAFxkBfwWL00nZXHkBVxo+ZgVd63NGf6Ncb/+GAQaeultRQlq0z2ktKzsjfkvMH2Yz+MhUz47HMQhdo8L/yxdzJYieunvv0/CudwpVx3GEmkWT/bCFsAj/QkGKep48h0jefHeHIM7SdNEY/DzLcP5zvOLeW2ZCCxr2yH19dAu3dtKgfSJpI0/OCWXpWRihYnOyKlFA5q2FhStOaVaExgsr5hYxYlCmgTbygpvnHwdrxlCzXtaf2lFOAgbkERSSNnKf/uRltZ8c0DMB21XiCSbedO9qy13KGLdUGnFwMiF73uH5h02IOT4/sf/xsfYpL0zmxSUxiMaSkiUHVIqtfpqCsc3bGE2l3azNt14+ZuyP+eR6tWSVTzeUwxz4XS3MfyYaXjgQcteWsOZ6XOwmIKX5pqH6IvlcYifru09k19r2Zw/g
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
2.54.0.794.g4f17f83d09-goog


