Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E97FEA7197
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 17:48:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12EDC6B0329; Sun, 19 Apr 2026 13:48:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DFBF6B032C; Sun, 19 Apr 2026 13:48:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F10F96B032D; Sun, 19 Apr 2026 13:48:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E00DC6B0329
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 13:48:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 61272E51D6
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 17:48:00 +0000 (UTC)
X-FDA: 84676038720.10.DD1AAE0
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id A09E0140006
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 17:47:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qJ5pn1ZT;
	spf=pass (imf23.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776620878; a=rsa-sha256;
	cv=none;
	b=VGaa6GMrtNQH1uSu85LCXUBOdteMRyT+Sc9Ye6BleJeqOKnGi/t8T89fusanI4JzvgyRPP
	+BstOqPNxobUnHlfQN1sCgQJoMTkAHVZz7+/sCrA79W/uItnpQR3cWjkFt8qWD2swZzBYX
	tprr1tIL855rOIaZorFk17FJksBE3WM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qJ5pn1ZT;
	spf=pass (imf23.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776620878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SU7IMwjgaaSGvWJIdVbB9YzEzjLEjhjYNgpzlOXz1yk=;
	b=3CZwR1dszo2PXfaT6KsKAsCgxJCVQEmo10Ld7RpuRnkBCtiUeafQGY2Z3ZA26elt0OULM4
	kX2HQQMNufyZzTbQ8cbBp3+0gFnfMt7jQ12NbBEyEvHnS9GKGtn5BkjMtGjRChmx6D+T5L
	klw7qqXeRJ5XGEdYokGaj0zlxNUbBDc=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3567e2b4159so1495791a91.0
        for <linux-mm@kvack.org>; Sun, 19 Apr 2026 10:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776620877; x=1777225677; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SU7IMwjgaaSGvWJIdVbB9YzEzjLEjhjYNgpzlOXz1yk=;
        b=qJ5pn1ZTefgNzeiwIRusLOJXSscIKdJrz5VGhgeNFrLRbxz8YaeoBypwmbPGbqEebQ
         VzWXUE2jx/C+2wf2h12RrFCr7ojWKpzvCsSgVfb8jQuN32ekZe4ZBXsPrHzD6Ky2ZbzW
         asLmh1UCqVJV39Pk/Tq3UIB1YZgnJLB+8hMUMb51uRh+Ns1TPHTR1MNlmhFGSEL2UlYA
         jcFlfh/+cxI7HUlFc3ujFajHmXDY/KGSpSxyGyZger5PD3PsKgRRUSbkX6WqdyESrtRk
         n8t/a/Q1QQhQmBTGEJRNPKWnUIBAQmC1MtbQrJ/cHjAh+AZmEdX1qBSlEkNZO0Y2M8Ju
         JuRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776620877; x=1777225677;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SU7IMwjgaaSGvWJIdVbB9YzEzjLEjhjYNgpzlOXz1yk=;
        b=TlK6Xqj4mHTkC1zMbLfwB6gQwcTTjau1VMWFY0S/4P9vhrKZpBcRWsXj8HrCLyAFsB
         C8Rx+ZkHt88P4z87JzTJhtgYBVXw9KimeL7uvWKw59UuAGa6k+Q3IyvldyWk9zp1sJCu
         /KDt/VBidGeTEUyaxvHyHZPnE1VqhIfm06x0M1/8VEJDtwAl9fZKIKVmOCCYekdGI1xy
         +Xky7yBcPgbNwSCdb6mgDaVyygTpUmqMdgKHCRAcNroZ87/3RSvuJMWhb84LoDWcSBw7
         wwqjpHiLMJme+be0MuqZsgvbroGtuCcfue3Ulc3rSSNcvCHUBt45eCPravj6H8H7FI/G
         s6TQ==
X-Forwarded-Encrypted: i=1; AFNElJ8FAM6eIx2DotAXEYUZON88f6CL4iCl7KQtYmHSpsIrLeNVa8dk3V0XqoZp18rnwUpIBUAzwg434g==@kvack.org
X-Gm-Message-State: AOJu0YwjgwMCt91MrB4cpBkLByRh1HG9rq7LHWCZRrPoCmwYXv5nT1ha
	Tej2yNlQzcg9mmsDWBFdUdz5rCZ/aZE6povcDcO6n/B3aR86s6ixlsMdXPXJBA==
X-Gm-Gg: AeBDieu0zxDy6U+odQBrNSXVSuefkceEY1p0krzh1mJvUKephlLsvXeAo+jQpKcYn4a
	D4gmQMYem13tyyTVOuq2tccP1DRT7Y4Sd0AMUbs66rLHZAVoAuEyzubcyrRjkQe5Oi793SshfbE
	ZRtlqDNY2PkRdEUCPzoV/30lnMQB4lY1Zhz0YmfRBYOjBc95tu3z0RpLX/MEhhBd25c15wF71Pz
	nWeB2X7SM5r+283XuG8AhB1E26lkTXwKBLA+B/h7fR4ZgqkZ52pvfAarnNqbGcIULcqopDCUzGF
	aOCPhJ+YRdH9xMqs5QpHPBEVOT4vxwr1/kB+CIvTqjf8tQdFoKjaUlKCHARGFH8nBLo+3vNtcBJ
	1BbLAcNv79l+ZmNbK8Oe8LFAUaBwGSJqgh4v1njMxZaIYMfYVB7c7g2QGEqAmZiOxJuTtmvV1PL
	2LHQE0b1AjADhh3bT3Nh29XxTO+tWm53NZ00C4MySI08t8+JgZKXuV4EVq
X-Received: by 2002:a17:90a:fc45:b0:35f:b5df:453 with SMTP id 98e67ed59e1d1-361404a3419mr10556738a91.22.1776620877397;
        Sun, 19 Apr 2026 10:47:57 -0700 (PDT)
Received: from tech-Alienware-m15-R6.. ([122.171.16.167])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-361410a7ab7sm9880210a91.10.2026.04.19.10.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2026 10:47:57 -0700 (PDT)
From: Sunny Patel <nueralspacetech@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sunny Patel <nueralspacetech@gmail.com>
Subject: [PATCH v2] mm/migrate_device: Cleanup up PMD Checks and warnings
Date: Sun, 19 Apr 2026 23:17:43 +0530
Message-ID: <20260419174747.10701-1-nueralspacetech@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A09E0140006
X-Stat-Signature: qb8kxy8ahxy73chrogwhq997g3cswzyo
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776620878-225678
X-HE-Meta: U2FsdGVkX185Xp+T+zPDIEHc1TgiIQvaVX5sXW8lRvP//+KFJ5+XZioFIwc3h5ajtSWXHXUzd06sxXQAkpOCnGn3HKuDNlwytZiAps0+ArmxyqCHjQP8KCaORttndVjSN8GldlT4aLqQnqGI55cIDBKGF+8tzQBikBZ2oieCXV712fZCgyB4beqHux0fEA6dryde4xnabjLs0yZpF1gpLG/Nml2EcFNvlzKjbtqLksKRywUfJEEPy94O7UNp93TGD5MVfywVsYWmtlRhQzqlHDUnXGomy515Bg80o6Pp/gZDhAcXifsSWQbzyFCuhV8bFV343BBjHnUUs+5WTxieV6gwOKhMA93JvOXuASQxQQU24PlY8CEy2poJc9cUVAhsmaWhj0RsrKmExzuLZXYy3hZjTp+cLdMZQjy0EWfquncbTfZ9OMik87IF1iIXGKM3qXyHPEA9Dq/m3zLT5VGSrL2KRDxh62UQjB6Q4UXVIJn7OeuMiKQ6MSByt6S2YWh1tTmItxM2ipFpcAM4e8n1lt5Yydxjl7i40R8mjtm/wrIrGCqJTr0D09h67PHHJTzTHC0qFy0bYV4Z9ZeWYzwD+GG+V/2eX6/gPcO9I1Rp2ULpD8eOEu/Og01iDghEQ30DBK3h7lJy8ZIAjR4NmENCTQ7gKbc6xfR6gspcsPXSLhW6qqHcdoY4eUiHhI4HdOCE/hhP8QwYtRzdNroBRWtVojAca6j9aFjPs4wsuuCScXYL39XOpx7Ss2mm1dq1Vs4K9oba5zJx5NLW1dD46s9hc9+8TB0FyMfM8vQSBUXOi8f9v4JJVaR1JPYzpJr2LkYq3caRyN+WaoJAu5lEqiEAT0FIHfps88VKhK4WU6c3P1tnKDKKKGk3B/nOSBpl12wOi/HVyJdA15Cl80ihuIOXCNGbyfW9VDL9EigKeSSJanDdyPUEMKHDdzbd45tNJVs0TktiuNGpLctHmipndPN
 AFF6Worg
 Lsi8HSqdv9azF7umAmJ+j6nGpXFlfniLhFhw7GCzN+2ClE2dhj6eIsOoG5lrrcyaILwiQS9tBGKnz/ytTsYvScfq+0prRy8dB2imHHLQ160O9uLy82LrxcYD2lIdosMK59RATQL7S/gn3o9hQCcZhG7DCClBZfQ/yyUogByhqjPtzNogMURy8FhIFg5VUNGItkOB33b8F6T0hfTqVgwxyPPmf2PJl8csGc//YtUzZRZo8hCHWE8y55BV/cWToyjpL1Aq4kjDD9ftrnj7gVVJxPXTJ5SogTg0wb86yB7+Ue/LsohUVmgrKfwgMYaMBpQfKhUSPYfielez4Rf5L+DzVSB9bWaVXqZHflKdJIAAgQ+SwbA51X4VX2tyOSZgVQa967+U8Ou4+/c+d+1SKbAUbxnk4iQzTB/aeg3aP9ZpixQQbjk/RqADCXf8LwUy5jS49xddOqmB8xle5AQf3ZWfBTPRIEeJqqInbSn8YCEuVHG61YI1E8K3Bki4faEtnPbrmkvxgSYx3vJR02DXsaRbbmzMlsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the odd VM_WARN_ON_FOLIO(!folio, folio) usage and replace it
with a simpler VM_WARN_ON_ONCE(!folio) check.

Drop the redundant VM_WARN_ON_ONCE(!pmd_none(*pmdp) &&
!is_huge_zero_pmd(*pmdp)).

Refactor the PMD checks, making the control flow
clearer and avoiding duplicate condition checks.

Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
---

Changes in v2:
  - Removed additional check for pmd_present() as is_huge_zero_pmd()
  already checks for pmd_present().

Missed it in first version of this patch.

 mm/migrate_device.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 8079676c8f1f..2c7e89a6d1b1 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -807,8 +807,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 	bool flush = false;
 	unsigned long i;
 
-	VM_WARN_ON_FOLIO(!folio, folio);
-	VM_WARN_ON_ONCE(!pmd_none(*pmdp) && !is_huge_zero_pmd(*pmdp));
+	VM_WARN_ON_ONCE(!folio);
 
 	if (!thp_vma_suitable_order(vma, addr, HPAGE_PMD_ORDER))
 		return -EINVAL;
@@ -865,11 +864,9 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 	if (userfaultfd_missing(vma))
 		goto unlock_abort;
 
-	if (!pmd_none(*pmdp)) {
-		if (!is_huge_zero_pmd(*pmdp))
-			goto unlock_abort;
+	if (is_huge_zero_pmd(*pmdp))
 		flush = true;
-	} else if (!pmd_none(*pmdp))
+	else if (!pmd_none(*pmdp))
 		goto unlock_abort;
 
 	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
-- 
2.43.0


