Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AF1ECAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 09:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B34F28002F; Thu, 18 Sep 2025 05:35:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 864218E0093; Thu, 18 Sep 2025 05:35:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 779C128002F; Thu, 18 Sep 2025 05:35:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 665EA8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:35:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 246C116087C
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:35:06 +0000 (UTC)
X-FDA: 83901862212.20.089A9AB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 55A78A000C
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:35:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758188104; a=rsa-sha256;
	cv=none;
	b=imPz4Wk89YWmQmLZ6GmcHD5KRXft/I/i6WB/y+yTCzIOEYqjc6BzUmlEkEgu/TtneCMmMC
	6AvKGPf1mc3iPH6W5Ky0dFfs27L8/UUNPstLxUc2CUcDm/4RnX9860Me1jn6XFnJUv2cao
	AOoEtSMHQKJiaLQEwryBy5OiJHnxvjA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758188104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=XuKvxMREAmE0zwi1dHM3uq21ai2ZDSIgrGw9a7CmzLc=;
	b=A8Pq+d5i+oql5gGdeVeriT40ewSw8/raB4LlgJ8EvAoUOZVnl9DtcvmAJmVS+3dEHCGSrV
	uWL+zeaAOm2AjDzi+WQSQlD+dqbTrP7EPaUP90mJC0ZLoObajcyJ/dufCr5FErBAbLpENm
	VVsGVfcHRxW3niBFhl8pC+pa9CJiI0g=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 25DEF1A32;
	Thu, 18 Sep 2025 02:34:55 -0700 (PDT)
Received: from MacBook-Pro.blr.arm.com (MacBook-Pro.blr.arm.com [10.164.18.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2D2033F66E;
	Thu, 18 Sep 2025 02:35:00 -0700 (PDT)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org
Cc: rppt@kernel.org,
	ryan.roberts@arm.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH] mm: Remove PMD alignment constraint in execmem_vmalloc()
Date: Thu, 18 Sep 2025 15:04:53 +0530
Message-Id: <20250918093453.75676-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 55A78A000C
X-Stat-Signature: 9epd1i8gbzc1gr31mutbbpobtqsweocd
X-Rspam-User: 
X-HE-Tag: 1758188104-796391
X-HE-Meta: U2FsdGVkX1+dFj0UoWl9Iqs4kK72PxuU+lu+e8hbYAh/mSmPfOaE89gREo4fkOGGkmZEHl0gtk0wRUqEPXqdYlWmNPNi244a3Gr439JRJ1pCP8OIM6r/34/FDESxsfnA1uFRDEECO6/XjYo5isAxxpBqQQC+ywAL9Z42Ri09YxZKUictcQWLasuRCH4pYlm80zDYx2Nf1RXSucLZCWApTboDELm/ZfbS7KpqSJT3O9MPE9poTja8xxlaNgfaLnGFcpKZKiiC1QLJkM34PQKWkRd7aCyIjOw/x9dLc/pwr4xxeLpAPbpl/85dkv4IrFZ6zybhhw+QRtN1zIbp7AlnhiFuK3JuwHqoWIkNYBhfx+85aNq1mC8fYo3s5zyxN+CnXalCNpZvOGnRKailYENPyxL+bU6ySqZ6obdZRBTumj9ia3gPOspBxVVg0KG2DTO47YJQI3++zdunVdtbeNAt1uQB41seOu3DC2TLxnuVjKQQi2/wT8ZVUORuj2kJEBZvGjjlwuAjW13jz3CM/rHneeBgsNiAWqgzRkACysah1y5J323NaD06BNexvHtpiMh3y8x7aqAzYmQ11A/tnc5/7wjfpeQLM7Ree9P6MH4z+KXXpb93cWosaSeKWMOyMMxNQOqBbSGzBUZB5QQNEvsYIDxSWrPKivLoOOVp0MYknVy53KcVMXtDsW3PUHYwrBqEU1vPKWOOAqmzu9Fc8DZ630Zdm+ur5jSzmn9NxGsIge0HjL4Gz+lQZ5Fq4bP4yFiKpvTLHVY15UzPOa4c9SY8CRfIjMRmU361xsu1dJUH5nUpK0O2H2jdWRA19jBV8eWQwtI8gli953ym5RERALKoG+R2AyebmucU7ybPmWUlHqFj+1hCeB+PVmoAwqZviNT3iJlOodFMxmpwvSrAC/Ou3gFMkj888Ewgz7c0mIBlvebxIimT+m27OMr6vXqYmhN+3blUurtSkBwcFhDcubS
 z20aCFk5
 cmpp9gUGrHxtf33yqKNPfvy/fNwuzN4SNsQRqg/OWTYFaSh1IrEFsJWXe4yVwhiGnU4gTyVu1flpCV+r6a0qiI51p8vnw5uJGO8UOqdlAeBn9Ja8zcSJgZMYZowe0Q3HeMG9Tffo6CAGE1ckweJEXOqPOJvs21+HSMoEO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When using vmalloc with VM_ALLOW_HUGE_VMAP flag, it will set the alignment
to PMD_SIZE internally, if it deems huge mappings to be eligible.
Therefore, setting the alignment in execmem_vmalloc is redundant. Apart
from this, it also reduces the probability of allocation in case vmalloc
fails to allocate hugepages - in the fallback case, vmalloc tries to use
the original alignment and allocate basepages, which unfortunately will
again be PMD_SIZE passed over from execmem_vmalloc, thus constraining
the search for a free space in vmalloc region.

Therefore, remove this constraint.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
mm-selftests pass, but I am not sure if they touch execmem code, and I
have no experience with this code.

 mm/execmem.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/execmem.c b/mm/execmem.c
index 0822305413ec..810a4ba9c924 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -38,9 +38,6 @@ static void *execmem_vmalloc(struct execmem_range *range, size_t size,
 	if (kasan)
 		vm_flags |= VM_DEFER_KMEMLEAK;
 
-	if (vm_flags & VM_ALLOW_HUGE_VMAP)
-		align = PMD_SIZE;
-
 	p = __vmalloc_node_range(size, align, start, end, gfp_flags,
 				 pgprot, vm_flags, NUMA_NO_NODE,
 				 __builtin_return_address(0));
-- 
2.30.2


