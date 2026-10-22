Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB5A0606A32F
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 06:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=gentwo.org header.i=@gentwo.org header.a=rsa-sha256 header.s=default header.b=b2cnkebq
Received: by kanga.kvack.org (Postfix)
	id C200C6B08B1; Thu, 22 Oct 2026 02:46:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF91D6B08B2; Thu, 22 Oct 2026 02:46:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE8416B08B3; Thu, 22 Oct 2026 02:46:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 83F0D6B08B1
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:46:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 019C74074D
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:46:54 +0000 (UTC)
X-FDA: 85349329590.06.BF054C1
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3E3CF140002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:46:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=b2cnkebq;
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf23.hostedemail.com: domain of sh@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=sh@gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792651613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pLH6Qdvd1b3FuoOMzQUoR0sieayKiNlgZnbtx7OcG3Q=;
	b=UQBfHh5lnwUthM58j4hOrcRX8MwwMsokgPZad+VWk1dsctvkZd0793DV979u3ftpX9ry8n
	d+IgU0lEFMEwL/pJnwXHNirj6TamXjdCwdADGc7+vMTTuVGaJCkOd1G/FAWv9TJadeZMfn
	GwPxO0Nb+xuBXNKwAaPwwV7XJ/n9iXY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=b2cnkebq;
	dmarc=pass (policy=reject) header.from=gentwo.org;
	spf=pass (imf23.hostedemail.com: domain of sh@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=sh@gentwo.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792651613;
	b=yMGrzqoXZsScMrKYbRtRx+4AFbT7Bl/dxeT8yGg6tzSIsDFsn4SDf2pLkHOM8ThYOBaxt7
	FUdKCeujJjbcNFOmZ8vkGwUYNamoklcB2pTjrI6gNXZJkUPr11ROX4tbz2yZsWfrF6Ei4J
	5aPrCrQqDsj4SPnibJmwQP4yQJFGJCo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1792650987;
	bh=fYjhazpEBlwVy5VKWAIlQqmd3ajCfxb+TAv31L0DTU8=;
	h=From:Date:Subject:To:Cc:From;
	b=b2cnkebqTtrGA61q++7aBVW98HIpNhjojmw2R8y4prNqHRHcQtWHnAB83q5b6wXva
	 TAXrDevp06k6JaLYdGBKq1OV33MBzEJbUUXcHgQjlGuC1LYGBoD2ID5cOsa//wPnOR
	 VZ/cAOIdNUOdORXFJ7S6D/7kTX8JJjf7DMA13YmY=
Received: from sut02sys-r112.scc-lab.amperecomputing.com (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTPS id 2861B4014B;
	Wed, 21 Oct 2026 23:36:27 -0700 (PDT)
From: "Shubhang Kaushik (Ampere)" <sh@gentwo.org>
Date: Wed, 21 Oct 2026 23:36:19 -0700
Subject: [PATCH] mm/damon: align MMU notifier range when clearing PTE young
 bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-damon-align-pte-young-notifier-v1-1-d0365ac45b66@gentwo.org>
X-B4-Tracking: v=1; b=H4sIAOKu2WoC/x3NQQqDMBBG4avIrB1IQiu2Vykugv6JA3YiiZYW8
 e4NLr/NewcVZEGhZ3NQxkeKJK2wbUPj7DWCZaomZ1xnjbM8+XdS9otE5XUD/9KukTVtEgSZ0Qf
 7gEF/G+9UI2tGkO81eA3n+QfcHCE9cAAAAA==
X-Change-ID: 20261021-damon-align-pte-young-notifier-e8f19e0e84c5
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Fernand Sieber <sieberf@amazon.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
 SeongJae Park <sjpark@amazon.de>, Leonard Foerster <foersleo@amazon.de>, 
 Shubhang Kaushik <shubhang@os.amperecomputing.com>, 
 "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "Shubhang Kaushik (Ampere)" <sh@gentwo.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792650987; l=1929;
 i=sh@gentwo.org; s=20251010; h=from:subject:message-id;
 bh=fYjhazpEBlwVy5VKWAIlQqmd3ajCfxb+TAv31L0DTU8=;
 b=9AcM83hLd7/2h4L5Mf1b9QDePmOKX6eHev2pmDfbiGeFBEiRY8bhh6P8HWzNioPWEW7BE34m8
 jhZGCOqfAiMCn0Lqc/6udvqeaAZKUysZ2rKn/cvSY001uqNJXnPRgZ4
X-Developer-Key: i=sh@gentwo.org; a=ed25519;
 pk=jc8YIRvxPSyJaBRe5y+a4N0RXKBUEcAh8+OFhlROXPY=
X-Rspamd-Queue-Id: 3E3CF140002
X-Stat-Signature: a5nkyz7dmgorkimhge6f38b4kqpa1uxn
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792651613-567159
X-HE-Meta: U2FsdGVkX19FReRyHIA6coLiNc9SuukHQTdZMnsOw953FcDKL53RX72/Ex4sVQcgGyvlwTyi0stCqI5EuZ5kcR2QkZLmISO8acDJBvlGw5N+c3NpWNERYTxhzk4w1xfMpRf4eD2yBi4BAa8LIdFj9yilCmK5jfzn2PTVt2JMj52Q82AWgVhp+aYFqvjQhKzj8MbUyzyKdIigwZauYjZy2vBPzdII2/ebGKmkYd4511fyIgqaIwm9Mh60J/JF8Pfptom623eKmqD0TlWzbERTahF3mQQTpJSbZN3LNG87DYGThqvuSEZXDa93Sreaa5X8KCfBEvUrBZmhVxKWph5jHYnZ38o3G/BNtSgE0ZSR+lqGjiOgOU9vA1+d8vn78yG+6+BEh0TQXypvZFCKHO3Y3U+mdZIWp6D4K39tYPysStAcXJOrN+RcdJXWl1Hw8AXniCfsCTjQ+9xEMXz0fNd/zOYipRPH9BFNZkug4N/DVsQjbe2iKqQHRKZJPGVD2c24ZO/JGlc9PflyrL1B0+UURd27mK6kDWU2ZPvGpM1BMiUAw69W7IchgAbvp4hbLbqZmPxxGh/jKxn8LcKe98Td+avf5ihW9+VES9gVLIxcSnMfE+7j1ZDB++53ruYb+/YbF/r64OzSneag6plx2AYJQi9XIQW2PNN0KLVxjep+MT20CELUNTxx6rmU8VQiCr8uQl3+txxo04/dxaOIS/F1gbBUln1Z96SitLuYb7ToeovuQryGSPGZAx4n7V3z5gcm/vLFvkHS3UQMKiizUvkimio3qPf9gtqrgCHVN/f//vjPrw4YUhtYzAQzcNjKEkHTEHG1OUt3dAILJLqoS6H/Fwpfb4lQWyPwkXsAdYzFB0TzYQIRQIRH+yao3DdZsjUjhnzBFQF18Q2MCAa7iskgTbbVikodz2ubplosOk1j5PUEJ5PQtqzs+H71U6JMJGAKN7uNIH8mF+ngfzDULNp
 zjbGeYTQ
 jqf4MBqRkUOZiOeT8aqelIFAPFESD6joXM/NAoWhKDh2GHcokEkXLwXxaiofFNsDXyu3muPy/gXAgL1pK0SL4XjxsBCBG0KlxxoFRMC2gNWYxVoHdcu+yfls5o98LWxsHtTb68Qs5P7/DIq3uZ2PXV5w8jRV/i5MTnv1FCtkvnMCPnVuDb7lyolh1Fgmt9zTpTz/d5BFsVEbauOlyfhw0v7Ozr3NwzV4HTaCZn5jpoCAqNy8h8RpwSjwNLXIu2rzQGZUw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMON selects a byte-granular sampling address.  damon_ptep_mkold()
clears the young bit of the PTE covering that address, but passes the
unaligned range [addr, addr + PAGE_SIZE) to MMU notifiers.

For an unaligned address, that range extends into the following page.
KVM ages every guest page intersecting the notifier range, so it can age
a secondary mapping for the following page although DAMON cleared only
the sampled page's primary PTE.

Align the address before both the primary PTE operation and the
MMU notifier call so that they cover the same page.

Fixes: 3f49584b262c ("mm/damon: implement primitives for the virtual memory address spaces")
Signed-off-by: Shubhang Kaushik (Ampere) <sh@gentwo.org>
---
 mm/damon/ops-common.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 8fc61d06d358597c4b8eec9523865f43496298d1..848c327f231e722499b9aac2c041b3aa84061d56 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -46,6 +46,8 @@ void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr
 	bool young = false;
 	unsigned long pfn;
 
+	addr = PAGE_ALIGN_DOWN(addr);
+
 	if (likely(pte_present(pteval)))
 		pfn = pte_pfn(pteval);
 	else
@@ -65,8 +67,7 @@ void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr
 		 * Arch implementation of ptep_test_and_clear_young() may
 		 * require aligned @addr
 		 */
-		young |= ptep_test_and_clear_young(vma, PAGE_ALIGN_DOWN(addr),
-				pte);
+		young |= ptep_test_and_clear_young(vma, addr, pte);
 	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
 	if (young)
 		folio_set_young(folio);

---
base-commit: 4403278e4ea2f654f8130a5c03eb8b4516a0f201
change-id: 20261021-damon-align-pte-young-notifier-e8f19e0e84c5

Best regards,
-- 
Shubhang Kaushik (Ampere) <sh@gentwo.org>


