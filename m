Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF174CD6E51
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:02:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 675826B00BB; Fri, 29 May 2026 11:02:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64A386B00BA; Fri, 29 May 2026 11:02:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 514176B00BD; Fri, 29 May 2026 11:02:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3CF806B00BA
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:02:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F34A3401E7
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:24 +0000 (UTC)
X-FDA: 84820773408.25.26AB887
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf05.hostedemail.com (Postfix) with ESMTP id B134510001D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:02:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=doZ3F9mc;
	spf=pass (imf05.hostedemail.com: domain of 3fKoZaggKCI8tAwu+z1Cz77z4x.v75416DG-553Etv3.7Az@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3fKoZaggKCI8tAwu+z1Cz77z4x.v75416DG-553Etv3.7Az@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780066942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U/mwSEvShIHWF2QZpE0iwPRub+uC5Pg2lSQX62+z6MM=;
	b=0zQ3JZcpSNosppmnQ2BgVCjLTEnbG/Xqro6TrfqF8XSI1a8nyLQ6aKoxcpjvwfJYrhG4yF
	xa5oopVIKp/cM4djPFmEukJojmFTkXByy5pvl1u5PBlTJTc//NcXOA8qt2xlN4cxti99kh
	JkJJIRcVVtUXJz0Z2WDglM3z5nZVra4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=doZ3F9mc;
	spf=pass (imf05.hostedemail.com: domain of 3fKoZaggKCI8tAwu+z1Cz77z4x.v75416DG-553Etv3.7Az@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3fKoZaggKCI8tAwu+z1Cz77z4x.v75416DG-553Etv3.7Az@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780066942; a=rsa-sha256;
	cv=none;
	b=Fu2dC1nXScjw8OFkObMSgK0d4HwyUBm3T919V/H8a2JkMsugxqhvkYwrcaAcR7IDZ0FdNf
	x5CVm9vYOnKMJLU+3QIHz9Ws04m3rDFfXM6a9cKDxSyFghUTM44CyOSmykDCNsmqjk4RL5
	MEjFaK+yMaguhZgSkYIM9M4HP4/MwiY=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-49045f93baeso55068085e9.1
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780066941; x=1780671741; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=U/mwSEvShIHWF2QZpE0iwPRub+uC5Pg2lSQX62+z6MM=;
        b=doZ3F9mcTY+2mJJr+2a+moAUmJT0mf4XBouQ3OGCfRARPjl88G2mIDCFDomkQORu/7
         7/HBYhQY4sZ/TqI1CR6TfLA5mB+KjgRnK8zCFUoq/4gRkZUWs4bbf1tKnSTGbt9WV+L5
         gu0UghGn5frWvGrr+9eeKvhY+I4W1vU4qqus+PkTXdWcexYDQzuW6BO0tqGWzCkl6hEf
         L50fdRRdb9g53oOnbixYwCkDgvZAHCQB3jZ+n/hXlHraVtML44o1ZduB/dHqS6rdIHwj
         KxB6vcSjYJeSpiWiP72nmsVrJYmYobD/ehpgs2IhMvcTkvO/Ycuz2VB0tzHZg8csvNRB
         alIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780066941; x=1780671741;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U/mwSEvShIHWF2QZpE0iwPRub+uC5Pg2lSQX62+z6MM=;
        b=HFiSfEmyTj/8WyJFfeFMGX/ZRZ9o4O+O2EyM8CJKo32Nt4xYo+7qo+KZXriQbw+mg8
         1DA/vCJ5PxzP0B98k3x39or/fMWKdDoqze005gSiXVx/IqAahyU7RVdewFwrx0xeN44w
         3mpPAbP5I9yIpVlI2BsPNc3s2bAsxUCpCHE+JIgJsqmBZZIcTgh1qYHAHiNBeD8pxOKF
         d/LOQeO7TQmBfYyTFc8Cu9K1+TGmDHD/gHKix10s7v76xZvcVIsGvtNmYWRMTfq07EiF
         SZLVaZMva0brjjCFRpXFKfh6n284wtZiEF3MWP5np+iHIluhfHySYMzuZzkjl7mljH2i
         h+9A==
X-Forwarded-Encrypted: i=1; AFNElJ/rr5324GhseS6jkVg0ezw5scbC/kLPmJCXpp/1DSd/6UV3Z5upr8IGS8spoqXk7kI1uOu7ScNkFA==@kvack.org
X-Gm-Message-State: AOJu0YyjYk4qN407CjwVhOwHTRpve3QBoc8YTgJ4YjZgAkQ/AwMFo7No
	MLevc1DKLTYaBTAa/WrRGK0DipXoi8EUI7Mg/7QYNyDSBqMmpRqgMoejbysn4pVqWWSeB6/SmQ=
	=
X-Received: from wmos19.prod.google.com ([2002:a05:600c:45d3:b0:48a:6a1b:6c3b])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:e489:20b0:490:6869:46c6
 with SMTP id 5b1f17b1804b1-4909c0c3aa4mr45310045e9.31.1780066940967; Fri, 29
 May 2026 08:02:20 -0700 (PDT)
Date: Fri, 29 May 2026 17:01:54 +0200
In-Reply-To: <20260529150150.1670604-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260529150150.1670604-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2121; i=ardb@kernel.org;
 h=from:subject; bh=bTKeTgp6cCkzZ1W18Sd9Cjl54RAT9moCkecsCk8B5PI=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIUtyVRLb9epvd/g6Z6nXCMU1XxDqFp7StynL770hk8KPC
 3fVkv52lLIwiHExyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgIm42DP8T+QPDuZ5kJNY4Fq0
 fndHhtCalPXbZGdn3574zC/PNP3pckaG3SKqFZWbT0T+XSk3T86mOHw7v2nxfgWXR9PW1P5ftia AFQA=
X-Mailer: git-send-email 2.54.0.823.g6e5bcc1fc9-goog
Message-ID: <20260529150150.1670604-20-ardb+git@google.com>
Subject: [PATCH v7 03/15] arm64: mm: Check for pud_/pmd_set_huge() failures on
 kernel mappings
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
X-Rspamd-Server: rspam12
X-Stat-Signature: ff3y696awic7dqf6dp1mwsugsfizgxbw
X-Rspam-User: 
X-Rspamd-Queue-Id: B134510001D
X-HE-Tag: 1780066942-695132
X-HE-Meta: U2FsdGVkX1/kVKcLicSayrwpdYdzAWySNZbEHGMZnH8EIQfYKAc63La1DWnqGMlUOXJaUByA23pI+M5plBxpFtz+yRcFj1umV27WNNOpFkKlTJ8Sg1j6Kbf1I3RlkGWiSXUQKgyYW26OTyddWGLSC9Zl0OCL2uQGx8aaYL8d2lInlCScOxBBp7rhSS5iU/xqVIloKMBC7pduaJ0qcQUl9C+46Mz4I7RHxYU3uSs17O2ZjD2+2V6iO/DBFz/ZCMV+g27+lI+2Unp+yOq1nFpWMd6PJWlzipvgWQ8zIZch2Uq/8hNVhhY8dbDATs+zEJ7LF1yU31X3VcplcHSksrfLrqzS6ea5M7gsOQbMkNiDEteQWlrJ9LY6BZgjrarkELMY1d6/oUALam+H7DLkj5fTtC4RKeuetLVb83YFnaY3LVWWoy1FqnzH0quCmPb1yJ2ePnxQtAeh+v/BGR2wF73r8782v4hU0dCtlNpA7FXgr2GrXH37Dd2cwv88hI8d/KE5QDuXsafziyycvyNGXQ/N2MwQbEqBHQ9NimL/PaIE7wFv5JVZvHng8P+2NEd6LSgijMSmbWjDDk8QMlH6L7G20L1d38pBllqKfuJj/3w9O7+s6oYGVB5e3jj8j+KnrzP+dUhGpuqgFRWlAneAAYmfMLAJ5yhGTPd6AKbcb28E07lsN6JxmN04SqINJspUwFjfspx3+Sg9OWzY9xpEvMe6+h0M9QFrqByd0gm8b8x+HRCT0qU04X4WqSK2J1szN2nNC0UWKUMx9QSzP5ph4Bu0FJrk9nK13GwbQjIoEHeT+hKOutJfkwjGkAuDh1gaJ8BKMFdPR0993B54rxNTmv2CESX68cRJLdFCR71abcc3EwBwTvWR2fKT42mUugvgroTVivZUbXyUUyN3A7MSpHlWL097ePd4jLVgFlAhEL5kq3Km+vCN+3gBhHDg2hJLuJhwJLkmGcvfwySRVheOpF4
 TPfkkL2h
 Gv22hBdvGh8gY7XxYbzh8FICpvcOtVlWVhfWGknCn0fWRssiHdYQ+milsOjh9ekuzlr7/R6IDfcsBETq86ET2XbTJEzco3DtRE03elgdCjzscWyteCeWPAWk8bnQrjYrnjKe4IUGR2ziURBPdXjjGTZqS9QOry3FxZCcGyhaIE7BxGnK1HMjeeDCkRyiwVAdgBP+D2wqDtukmtdAywfoDaFXqmThLzygBXTiSIkIKDPN0i65OsQXxxhmwLtgLDx64WnEl2aeg0qW8van8G0XzzXS8/D929N+8UazKHpjziVRaIZXp8+N7d+2wV7I/XFLq4zDlXRk8YMTMAXle9L/tg0OF2pJf8YYO3hrGAMqvaK7ke7hB7y2e14+XsOBCr80NlgmEZS7vZn77xXE7EWn+/oaCTc0yoTw5QA4Arts2+YvdUkD0WSGysm3c0XjS9CB0KlPVTytATy9ooqMQwu0VhRcQsdOuwZt/vI5dYzpA6JeD74k2NcYUfwbqPWaT3gWiAyg8ETPYTU0Gwky3lINuMXvXgzv5R7JDnBFRNgdnlYxsYiV9mQyVl0tA7cCfG6K6syk7CLuxOFYvSoMzxpGJltYZjaWsZTvgG5s3VT/wb0p6muPotQUr3tCeTKG/zrih8KFObIMPnLRlex6OVMQRwBdMfQ==
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
2.54.0.823.g6e5bcc1fc9-goog


