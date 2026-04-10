Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44187E99076
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 10:32:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B09F16B008A; Fri, 10 Apr 2026 06:32:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A93986B008C; Fri, 10 Apr 2026 06:32:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 982846B0092; Fri, 10 Apr 2026 06:32:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8380C6B008A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:32:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3C9F91A04EF
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:32:32 +0000 (UTC)
X-FDA: 84642282144.23.7312FD9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 89FC7A0014
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:32:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UXc3vPoC;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775817150; a=rsa-sha256;
	cv=none;
	b=u+ApiBxCryt5u3qJSG1n2WOEnWMjMeMyO4xOZ1cNUi/uYqJtAROjHFK+0HvcmLkUJv1vru
	OMaxzpvp731av2YTpFwVxeWjzOunvX2WoTk5rtbm7XEaD84QwS+bqJGRwISer8Qo8Gt8Hu
	a6phej7GhiEUBzMKuy+zu0pL+L4ck+U=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UXc3vPoC;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775817150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kUxAj46Tcd0uuEBm6JgZA0Izdcfl76Qq/UQlrTacW6Y=;
	b=A01BruqpSay0dYTW9gxbnsDZiZ6KvgYODE7UIj8h9IZTCxnVYC9IwDUE6jFrgF20UXSj/X
	NHI9RsO/Y7ulZ/8rbZNbKWnOEf+jF3TnZOZvmDKSIqWye/RbZIZds5VdosBi1Qfd2su1yS
	AFgxAp5JaiTqx5BJVNMut5XWT18TDKE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D07B41D13;
	Fri, 10 Apr 2026 03:32:23 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5C4853FAF5;
	Fri, 10 Apr 2026 03:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775817149; bh=b08HICgezPVD7gUzyQf2pI1dALNHj0lOGqN3C5nNR0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UXc3vPoCgwsQbgN+hDlEu3IRjHexFrPZmZsCCe4+iKS7P2XZFV6VtHkFHXQ6E0Ubr
	 1FEXUb/fAwuvXn/4Yq7VI3p4t9ki5EU1Jl953XMq83vVMouhMrLnLJsM7YJR3IDaEt
	 VkOcTq+8HOT3JjA5js+iX624XwvwQwLxVI0HBGd4=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	hughd@google.com,
	chrisl@kernel.org
Cc: ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	harry@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH v2 1/9] mm/rmap: initialize nr_pages to 1 at loop start in try_to_unmap_one
Date: Fri, 10 Apr 2026 16:01:56 +0530
Message-Id: <20260410103204.120409-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260410103204.120409-1-dev.jain@arm.com>
References: <20260410103204.120409-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 89FC7A0014
X-Stat-Signature: jc4dgw76cddmkr41aw9nutd6jhq975ou
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775817150-639429
X-HE-Meta: U2FsdGVkX1/v3tj7kPcXbbG6UzM0xTP4cmF+8G9t53M2bjEM7N14WggX06Ew8XDBoB6dxbDRDyUBa8ShxGqikoZ/ftvXZxlL/umo5oSQv1Cgisa3dyUkrsYoVs97JZqQwTRbXHcePAayjjEugeAIzo0HG2vkBnCPf/jJbgKzWHJ6KDgwhPfN5FKifHBfaeo1soutvo+CAh+hrWTwZDDZwyt8GNNfaHTifYkgTuJwbaozGdixGt8u09h/on2HKfmJsScXWCEkdScwv32JwyBGAqNZzANC8mm6dDBECTRNV6CEtXuE60yUdDmnYDLlZbCD3eLlvEIwjdMrReFHZc0ax0fG0UlXojo5x/w7Sc77200w7O31K8Au7L1LT2h4LHlNWeSuJu2ka/PH5ll3OPfrQzz0xQJ9s6vvd88+jDWg2dB8V0SIXz4bdsMP6XFBr/2eHxIWy5G5ggqoeVoHvPKbcdjBVsH4WyacB6Nonhlbkv9MTzT28txYXuFEwvnoRhprmoCDHL4/LlnDtoptjErgPi7wm3exQMdIAXthyEatj5qPCDM0W50h15WVHNkgsZqY0uEK5VFb7aV7qjVieDem62Zg3QlGz3j2vD1JIaEzT/fQuU2kniox3lpgylJcisiI409DKijki/72kMvC27asGTgp+rGfRp1I5LWFJdyTiNQgkDATThvmD7OLIBCrCvL6lpHLv5n4XZHtpMunmi4L7aNJbK0NgkfxtLVEBlp8HxxMxuQKg/e9ncDxx8nA6sxBBhkQx1xNl+h8aFHKc87T1kSVqAwVqoOlxOAIHfhEPWvLCE3M+a6Xl7SCGlZf73SEZ2/5n6NHwITGFWMuuuYPCiasckeFj7nYFZ5NtVC+Bm4aUZuYCVkw6/a+eOHXkoLKgr9DPxROXwjoa8bR4QySagf4iyGd37jxWwJgicYGJGrdhYagvFjGHqp99VWsmTFroNfCujIhudidFQZ72GU
 56uvNcd+
 xfukcIwGzylcRJFmzCIAifWy1cj4Y3uLGqTOuivQBDFlsqiUcvm0/RITB4HLZaZt1BFy6ZUid88NaqFTbhqwc+jq3044bYUZYGNZinM1feixXxlWx0E+kvRvdzQULo/AzewFpfevEQv1Gr/K1p3Add/0z/IBwn4oIBY4wIWs4fG7zHyvWQsmrne6lUhx0keXz/s+9aXtnD5XlHJxxUJQt0p3r8kTeGJCoIqWA0BnX2qdH0L9AD1ixfU5VUpf9HZmGL/K6gYXVRFaLSer2EhJP40SYIPHw3sSkmsTv3Q0k0+CH18mcqTQS0Zx/7TtAAinK1uQPZlOdHUBgSyQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Initialize nr_pages to 1 at the start of each loop iteration, like
folio_referenced_one() does.

Without this, nr_pages computed by a previous folio_unmap_pte_batch() call
can be reused on a later iteration that does not run
folio_unmap_pte_batch() again.

I don’t think this is causing a bug today, but it is fragile.

A real bug would require this sequence within the same try_to_unmap_one()
call:

1. Hit the pte_present(pteval) branch and set nr_pages > 1.
2. Later hit the else branch and do pte_clear() for device-exclusive PTE,
   and execute rest of the code with nr_pages > 1.

Executing the above would imply a lazyfree folio is mapped by a mix of
present PTEs and device-exclusive PTEs.

In practice, device-exclusive PTEs imply a GUP pin on the folio, and
lazyfree unmapping aborts try_to_unmap_one() when it detects that
condition. So today this likely does not manifest, but initializing
nr_pages per-iteration is still the correct and safer behavior.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 78b7fb5f367ce..62a8c912fd788 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1991,7 +1991,8 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 	struct page *subpage;
 	struct mmu_notifier_range range;
 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
-	unsigned long nr_pages = 1, end_addr;
+	unsigned long nr_pages;
+	unsigned long end_addr;
 	unsigned long pfn;
 	unsigned long hsz = 0;
 	int ptes = 0;
@@ -2030,6 +2031,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 	mmu_notifier_invalidate_range_start(&range);
 
 	while (page_vma_mapped_walk(&pvmw)) {
+		nr_pages = 1;
 		/*
 		 * If the folio is in an mlock()d vma, we must not swap it out.
 		 */
-- 
2.34.1


