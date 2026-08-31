Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 768B0C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 08:29:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8746F6B00A2; Mon, 31 Aug 2026 04:29:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8257B6B00A3; Mon, 31 Aug 2026 04:29:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7625D6B00A4; Mon, 31 Aug 2026 04:29:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 57C376B00A2
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:29:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C177FC03B9
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:29:08 +0000 (UTC)
X-FDA: 85160889576.03.618D2A2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id ED32D1C0006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:29:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WDek0KzA;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788164947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zL5VLVZjP8B4IiR7cDacSwNLTXI8TvnuJhAme3BzNzw=;
	b=LmXPrN4yQf9MsuhRo41tC3Nft2v278zu18oeOEf+PbJ4HMR7qzQ5zf9ySncxojZXIR6zLn
	LupfkpimC5+ZmhqgdtRP7oOEl06o9CR8C+JHqNF7aq+LvrN0rhmvpaj/41OhNkHuYP2/0I
	H+38uIJlieWGYOI4qXHiWo62ICaKsTQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788164947;
	b=c8aZd3dOvNUsGprBSUw+UZbD6jEVvLDkjRZP71acI8G1Vc3jfQJ73Bc72okxX7t5ZU1WGr
	jmoXO9RN0VhKT4RZL0dMaoyDfN6ujX/XRofAFLl5Bz+CZSJUSRbr5NZVchv/9TpmGRA2pa
	vCFsY43Bp6PZ/kl8Z7Oq78CMFFuopds=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WDek0KzA;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0EDFE1477;
	Mon, 31 Aug 2026 01:29:02 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 7253E3F85F;
	Mon, 31 Aug 2026 01:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788164945; bh=Evn7Zfh9iuBirO24rNV2tVorrvWz1SCWoNgm/w4vOxA=;
	h=From:To:Cc:Subject:Date:From;
	b=WDek0KzATN0t8hjZiy7B9EfLSgwTpZL505soK50bfiBjSlYL83nPMqXWIevbm161g
	 rkL1wmBIsxcEmthh/G4GrnDXaGKKqmgfQyn0ZRFDjuXIGroUF0LL362LIv0s18wc6Y
	 rtfYyWOI4VXTDleXrN05OYyfl+Uw3qNr+YW8H/Xo=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/rmap: remove stale hugetlb check in try_to_unmap_one
Date: Mon, 31 Aug 2026 08:28:47 +0000
Message-ID: <20260831082849.3573957-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6obkcstfoiysbz66qaozaeqc89ozw6do
X-Rspamd-Queue-Id: ED32D1C0006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788164946-475570
X-HE-Meta: U2FsdGVkX1+iZtAfGj0kvWsOiUP9SwTQVWGLNt0sdNvNI5Vtlh+Zk3qTkq9tmeWuD5ze6v8tNoK7QwLlS3iz1BdawEF1Mg/QEwM7qoO8rsq2y8nkSL10/iNpsO4x8i9Fr79G7dXGKtOuPZWFd/ZKrns9wDKzm9n34M62BVISnQ9tQFxthXYAT72xbH1K74asU8yKYDcA5/jZUSc8mdAwxLkYZTvsxqzrll6QXGgXMnNCjzcqaQ/m6pCEmEsHLmtgx/0JpJuv55bi5yPHsagAvRttGjIGEvUZAv2oyUyQVYo9s++pcz2vEu5JUkESeeOrAhZ+9mhOs8zjIReRspn6Kpn/9OCIDw66r/x/LrzZJ8QXkMzzrr4rzEiavSzIKdqAmZA8jaU2/BtCiYXisILJtP0ZBK3lAkAYF2jbnFR/vg8PkWHMq35lyflzQnfJ3Nj3JSggpR6LiDO74y8d5mrzDoxSaImr45P0cp9cCYL7Ux5tTo/WkHSH3e4P9l6Nx2ojxHnCTzFxVUDu9gVPqaSBi+lGbiO1MvAHn6NdQYQIP/WvNZvZjt96bW0UeEc69UH5l1oy7FU5Vf34htmCkkQHBR7eKqKc1fjStxHA5peLm5K2rTw3femweqjrUT0FY6KsYU2MEViJRwAtmZt3qh3hl64wnXd3+GhbfV/5uO1fnYrEKHEoBVabkD1xOnNalEUO2G9MpqqZWkGqbpXwJLDmsXK0N5z9Cd9M6kW5Sou9L/pM3TJUY3GyE2nd3NQPrj89fJ67wvybzXQrVqiTSFMJlLUDpHPvKuyb+XiJVcaPANkL3rJJ0lMyYzKE1lFyphuP4PzBej7SZt7wiH9jPkMUmK1h6eSXQKtIJt3U0FhqbTdeeKaNLftLmKH8y6Hof+jPaE+5soz5oRVmD7b0bOTnQv9tA6Y3Bvz01VBBmF4aGBIZECVRrRTt2zL/ch2SwUXzaT2T6kCOa3pCAzMiIpB
 3oSbvUbT
 n+3rfwBKqpAvRcV7XeVznvuqIPZIHDJiiD46UsucVsbJgp9YKOyx5hsrc/HhpRZWvY79JdfWZEuNhQAKYkKGmz+CTWq3e8RNJd+0UNnwuNaRn0fMWcfObCMF6F5v9sNWnE4PG0o9XDVbOWX+ZH/g3FMc1jD+dB7B3FG4UoKKtyhOxfuQBveqZkssJwxDEV16XLI1jQJABJsUPECM3vk5RPhpzFg3HZ3ynXIFzIWFmCEkjXHgY+7Xi4B7tsjoC7D7as8N1trALZgA9tNNm9suwlHaUUW34JzJU6FexY7wpURcvWzD1hI/PT+pBE2cGaEgaIn0ZOIAUzZEvNsHZxth9XkqcMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Post commit d4ec5572825a ("mm/rmap: add try_to_unmap_poisoned_hugetlb_one")
try_to_unmap_one() cannot be called with a hugetlb folio. Therefore remove
the folio_test_hugetlb() check.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
Rebase soup - my huge_ptep_get() fixes landed after the refactoring.

This patch applies on Linux 7.3-rc1.

 mm/rmap.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index d1819fd699380..606c8ecf31302 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2299,11 +2299,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		VM_BUG_ON_FOLIO(!pvmw.pte, folio);
 
 		address = pvmw.address;
-		if (folio_test_hugetlb(folio)) {
-			pteval = huge_ptep_get(mm, address, pvmw.pte);
-		} else {
-			pteval = ptep_get(pvmw.pte);
-		}
+		pteval = ptep_get(pvmw.pte);
+
 		if (likely(pte_present(pteval))) {
 			pfn = pte_pfn(pteval);
 		} else {
-- 
2.43.0


