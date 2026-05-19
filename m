Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1D8FCD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 15:18:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D142E6B0098; Tue, 19 May 2026 11:18:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C286C6B0099; Tue, 19 May 2026 11:18:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA18B6B009B; Tue, 19 May 2026 11:18:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9889B6B0098
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:18:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 609F64050B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:21 +0000 (UTC)
X-FDA: 84784525602.09.9BFDCBF
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8112E100003
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:18:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NklpvQOn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3OX8MaggKCMAgxjh+mozmuumrk.iusrot03-ssq1giq.uxm@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3OX8MaggKCMAgxjh+mozmuumrk.iusrot03-ssq1giq.uxm@flex--ardb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779203899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+5i5xhw6twfeNJpf3X2JDAmvPKwL/v73NW4xnl1R+ac=;
	b=rkd0zM7qI5IaQTDcHa9bGdDZvuNTLIi5ai4WoCg+ylG9cd6BGNXJu5MoybocG4Y9rgHF8O
	/La94dqlwXzERAnD2egf021n4U1yZMwBFx7ERBarOXrpTdTpHBY8udgjRYAzR2dZM8U1Fe
	NRZmNss3rRbXkoS9/2ADR6WDeoI7HFk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779203899; a=rsa-sha256;
	cv=none;
	b=7iKFFLDMUQSx/UjqGsi0NjOh78qJSC+YvK3ZWZ4/soslfi7mzvgIjUrFwuy2+vHU95Wb/5
	P/57sA5olqshD/lOH3SXmVLC8TBFMf2HHawQNZqGN8Pa5LBigVfkqj59woUuhUtxOYm/0V
	kf3ZXuhH4V4ebInpl8tccUn9TE/iing=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NklpvQOn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3OX8MaggKCMAgxjh+mozmuumrk.iusrot03-ssq1giq.uxm@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3OX8MaggKCMAgxjh+mozmuumrk.iusrot03-ssq1giq.uxm@flex--ardb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48fed2519daso19767385e9.0
        for <linux-mm@kvack.org>; Tue, 19 May 2026 08:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779203898; x=1779808698; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+5i5xhw6twfeNJpf3X2JDAmvPKwL/v73NW4xnl1R+ac=;
        b=NklpvQOnCcJ/lNoFllPyZMQVYIFGfZ0DL5+GwLBJZgs6sNTQsgiYeOTR4KY0zhimFR
         /fuw72HP7R3qJg0VNTVAfpHiOGJg0NeUrkC52HTtB0qZ1gGRsGjCiOOsqP/wUxNL8JoJ
         6HY1TUsKv7zy7RAVQArUG6zbhvJ4tI8QWS7J0oiVHQoQte2oK/2ZIkubQ0s4r+VPVOU5
         nKSkqhZtzO6LYvGvlYSKg/RnF2o0g8DgAsJazFMpzftumOrx8MgfzjLfecvjPUPDw7ol
         7mwNAbuP+aOs2KyS5KzoWNCh/TZw3y0Wd4NvGqCzPALRjcteHK38mk1Km3wcwwug/OP4
         BWYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779203898; x=1779808698;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+5i5xhw6twfeNJpf3X2JDAmvPKwL/v73NW4xnl1R+ac=;
        b=UQ3Qgo4VBy6qBl93ZdLBECQqNlejhoWIt2t+vYFe3mLKd7Po7/JII+8rFE7budOPAx
         aoH+nOGNUad7xoz0IvxTgNy1XgfEhuDcVXMgWSvwtDzV+B5mUjfckFfDLRN9FvLVAYU9
         OxbD3MWtP0Vcuc5o3UQDObx/6GeSBX83358k3mKS9HizXQUgmLFspQYN9V0/F/9Pgh0y
         h2bhZrWJ6eOCVQG/d0PbUEHd/YbNzEZXIl8Iq1douxUIdtN974w+fRw32LeUOpujq1a3
         E1m3PKpyUBzNKk4BBUttCcUI/ShhWC3933+/4TrHb/8jlSST14IUzdKghEmgf9debYpg
         O9Hw==
X-Forwarded-Encrypted: i=1; AFNElJ/79btWQ4TyH7RsLttFuyBWQdaHRPfeYYA5wb9bb8Rh8w5zoEUx5RjndlGJot+gkQkisc1QaN/GIQ==@kvack.org
X-Gm-Message-State: AOJu0Yxc+aPMN6l1SJSQH/lGdeVCgjM+u2iaoucLDC+Gvv0/QoeS+0WN
	l58LNeMivmC8DRXIqZ851zv1ojGrl8tiscnjyIfsinrzjpIb8iSHQQVapOjjyDK4L3z616R4xA=
	=
X-Received: from wmbh13.prod.google.com ([2002:a05:600c:a10d:b0:48f:de63:8504])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:314f:b0:490:389:7644
 with SMTP id 5b1f17b1804b1-49006db5bc0mr175687615e9.17.1779203897655; Tue, 19
 May 2026 08:18:17 -0700 (PDT)
Date: Tue, 19 May 2026 17:16:19 +0200
In-Reply-To: <20260519151616.2557018-15-ardb+git@google.com>
Mime-Version: 1.0
References: <20260519151616.2557018-15-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1898; i=ardb@kernel.org;
 h=from:subject; bh=Q2W2jspPsv5GaJ5WLwu7DWsztQb/bK6wx+1BuMiTXuk=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIYun7sieu88v/5i8jruVR773wtIjbld/Wm40nSSe+cjgw
 YcLqYJ8HaUsDGJcDLJiiiwCs/++23l6olSt8yxZmDmsTCBDGLg4BWAiGZMZ/nBZtdgr2B5a5Wj+
 iUmAZ231tSsO7SFntz3bed73yPGbq/8yMpwpsb8stmR1T9S10AhOGdXn+2LnfX0psDCo8O08yUs 6T7kA
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260519151616.2557018-17-ardb+git@google.com>
Subject: [PATCH v5 02/13] mm: Make empty_zero_page[] const
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Feng Tang <feng.tang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8112E100003
X-Stat-Signature: dxpf1gasmxz61yxkbyzd4y3dfeeht58w
X-Rspam-User: 
X-HE-Tag: 1779203899-938101
X-HE-Meta: U2FsdGVkX18YAoYR4NdnKbbhWtyc0AbvKgojIkQIaWGkIaIeYJKQEdH1RFUCSdxYcCj4zNUvX6pU/yeEsxsM9vJm9KH9AJW102I5QhHB+kQlrpdONLjaYEnNtY4vKFChQ0FEDmdGzUFYjyQvV6vRomysFWs9jiEVySrSV/n5G7lkEpLXSOqg0ilhKMwV5CT6zqLDM2VK2PV9Wz5DfSKl84odDxgEK8pkR8aP9xm9ssnAQO8ZKUUXwgdX8tYxp3Ztw7U/qfdxYd/cQP1iRLzsTwiX1TPFMzuea+S1JCym36RXwFc/RxGyt0XnQ49xlVIU8YUs0vMo3eDylI+smdxToZh3At2YwHIROJZd2yPUJxU4F768SZwJ3RH+mUopPd9wv8tHOgzJYD78TXhmZd/fYv3KBKz9M5nuYP0rEI8XL5NKPboZvQDHHjxJ9/PDY7C3RTmiIbuIJeY5PjVwH5glMHADPp3RRzafsGirjbBzwK2dzK9JwjfRmqUNWprdjhCIzZ/TvL2pmngdTjh5oAO6ND3qUAI7HQASguYBznVDs3xdunOqFqG5rIy839+X5wld3azN+U8OdjTTsQW4Twzx8jIBIrVmW9dxbZaxhua/8QclOekhpMVLwwRLB2J28Kfo+EcLh/gjTfvQbWuMSWo/rb9s2fLp1+ScxWMQjG2G77MLPqf8sfdXx49NLI39iPx2jxM39bPTcPDSbo882I6F6LX3mkJ10XnIjwrdLVNlX9kXGnbJEmcqcUP7xIggPSsjdHc4/oqf/DZTx7IoOPWxzJ7zVaS1iLMbCdB1KF5fCgx7w7Kvew9sle1oBueHgzYRhK8c7KYRzYKdkgDHC43dlQ1V5pUWrke0yqz22I1gnVDi+kv0vzXkR4kLMHAzjN54JL4/op/0HlFcznhRMNUNT1cE0VD0GMoeKfJiP3X8yQjCUBUKTw+fJR/83WpMbzcVTPRNz1GDxAmDFtm3wVJ
 piex5bib
 WJQrO0knNZ8qWRcN5HxG5XR+SxVdRfXnqT9ist/nhhjP6kMnI9F5t8oHk+QpClseqVeEwlVEXXK8YuGa1TcgAvWuNvX/EK46SDNwz83IK4Fn9M321blZNderVQEXGUD8QUIk4GLkqJL/o6Q8SOeXOW+4JprrxwUp7xq+p+1fAl752f5bbSHFSpDFcQV+5tKiBHjyuqlF22g7Ugi8KV3Dl4R6P8ZGfg+g5MQ9PaREznNu4CNMNhee2y+h90/4gS66wlCdK9tPUdAyhBGTWuJsDvTJcc0fQAtVNX0N3zAICjRDDfWVxh84JnuUrtcYc7CIFnJFtZdNferRkysnRTNryAEz45xmcDXXcMjs9W7VCDoornC6+MKFy1120xpwf/z4jQzeyuqJyz+BabiGBlJ9tOK9o7wL/Fe9UNIZ+XZWGydKGXx8szLZr6Wx4VrFIzs1NNCkhhvkO0F+PVxJC/9pfBVowseGw/4pC/x0CSev7VVRKPK55/lB+r1MtkBr3JPW5f2ZWTsstpDJ+HxIjsPyQa4uKUtOym7LDhtsdbsIl/i1fgUwBI+bsgtbSa3ya5vEmXcT5ZYcOrbnypwErAcEAaluEFAbuXc2Stz8nHXPXM2+xHoxBo2w8HKPJCwlCLPmguZEWPsxTxMEJHXOCIzkCwwgMfHwPPDMBfjtFlE3k2/ChThOJO3NqbCxPNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

The empty zero page is used to back any kernel or user space mapping
that is supposed to remain cleared, and so the page itself is never
supposed to be modified.

So mark it as const, which moves it into .rodata rather than .bss: on
most architectures, this ensures that both the kernel's mapping of it
and any aliases that are accessible via the kernel direct (linear) map
are mapped read-only, and cannot be used (inadvertently or maliciously)
to corrupt the contents of the zero page.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Jann Horn <jannh@google.com>
Reviewed-by: Feng Tang <feng.tang@linux.alibaba.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 include/linux/pgtable.h | 2 +-
 mm/mm_init.c            | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index cdd68ed3ae1a..67aa23814010 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1993,7 +1993,7 @@ static inline unsigned long zero_pfn(unsigned long addr)
 	return zero_page_pfn;
 }
 
-extern uint8_t empty_zero_page[PAGE_SIZE];
+extern const uint8_t empty_zero_page[PAGE_SIZE];
 extern struct page *__zero_page;
 
 static inline struct page *_zero_page(unsigned long addr)
diff --git a/mm/mm_init.c b/mm/mm_init.c
index f9f8e1af921c..46cf001238c5 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -57,7 +57,7 @@ unsigned long zero_page_pfn __ro_after_init;
 EXPORT_SYMBOL(zero_page_pfn);
 
 #ifndef __HAVE_COLOR_ZERO_PAGE
-uint8_t empty_zero_page[PAGE_SIZE] __page_aligned_bss;
+const uint8_t empty_zero_page[PAGE_SIZE] __aligned(PAGE_SIZE);
 EXPORT_SYMBOL(empty_zero_page);
 
 struct page *__zero_page __ro_after_init;
-- 
2.54.0.563.g4f69b47b94-goog


