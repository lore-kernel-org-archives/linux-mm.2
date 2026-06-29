Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88A5FC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:33:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74BB16B010A; Mon, 29 Jun 2026 12:33:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FBE76B010C; Mon, 29 Jun 2026 12:33:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6125F6B010D; Mon, 29 Jun 2026 12:33:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 383F76B010A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:33:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AEB5B1201D8
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:33:44 +0000 (UTC)
X-FDA: 84933496368.28.E3012BA
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf29.hostedemail.com (Postfix) with ESMTP id B0FDE120002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:33:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=i7n3ehsI;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.52 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782750823;
	b=aq8tTHL3ER62SIJFJDIj7pYCBWrJ7Qk/Ja9Zxnl+EN4mQYsjcmeB80xO4dFRfQ9M5qqmtf
	i9mPVwMRtmwFSoKshescqOcS0qwUmkQA9LAZakl0EA7uLnwY0eKNs2IYdcJfM/Cy5c0kpD
	cjCs8hL/TF3j7a0fBrjdiW+9edCezLc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782750823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kN1HdUbHSwBU7r5YIRy1kGjvINfYo7yRqPYydSfH+gc=;
	b=o8BayUK/6/1noEIhXo5wwOYMECxPU2MQEgLwgJTArp29OjG/nCe1T6BBx3lpmKf/uXHUQS
	YOoIBUGvJA6xaGDox2fPYdylHxVR5Hx/UX/dIhW86AZuyVjjWLbwWs+hRd+IMxmE417Lai
	yDUMFsGYLqAVsmZZf9eS7rwyF0uGcts=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=i7n3ehsI;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.52 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8eec5dfdb65so9562956d6.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782750822; x=1783355622; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kN1HdUbHSwBU7r5YIRy1kGjvINfYo7yRqPYydSfH+gc=;
        b=i7n3ehsIOAjaXIib6ZoqU31jX4fOWeJ5Dt8yhcitAXy937x4lWQOeo/RtZMcGVkLEG
         n4XdsvopSe7XzWR1aR4DU4KmTkn8nbJ8Fi7u/N3VMdk0MzOzgbplODrtLdTdVuS/B+4/
         tfJLKvx8+h9U5WrS3I4cVirisqxpIgU6VwBmgIDyE0ehefgPjFmOEDbwrZ0ivVrgr/eS
         IeF6n2c2Nyxds8vD2UG3+CUigGhvjhLQ6WBpfZ9TpdII98b89efU2WPbN0dtW+sWTgJ5
         2t0R0xH9vRd2S1eKCPzkNWGSr17FhkEPEV8/PeCGMrDFKph7JFQjmZf1ybBi0wrcsQzW
         PdGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782750822; x=1783355622;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kN1HdUbHSwBU7r5YIRy1kGjvINfYo7yRqPYydSfH+gc=;
        b=RDphscq4MkkvUJm5Au2EAi/2LwT4l0bjDd6+trgT48fzrfWfGCsP3bZBF2//CWmY+1
         8OksEcHNkxRjKGT5yrFz9hyAe0FrJR3DqTPGbvYw+/4rShEpE+Qd2i1NNAs8uvXjBY1/
         WmA/pGnC3BeQTEvmKjEkkcHBvBeo4Ve4mDxtxLFDEE1agIDClf0RziTOR6jSyK7MOdki
         cAwJWmbP0eSPy/gFWWEjs93ZcIcB1YJwlqRr3xYcXyBPyBz08ypopOi3/BOfmWHxx3lF
         jccN209xQIpbMQxJQxlnEJBV7iqe3noJcSHiEDFayhOZ3HWp1sVqcUAZU9rR+US3uww9
         mNEw==
X-Forwarded-Encrypted: i=1; AHgh+RqcMBLq41qh4MiDgrwcJNGV7jqSDyF14homxvjip14nYEJivQ7cm/IOkDgudy4qOFbr+AvWd1PtGQ==@kvack.org
X-Gm-Message-State: AOJu0YxPrcwEhwsbpXqsSa8JOFIRitmhi6vJPg2MbflSOZwn9ajvyiCu
	1+3nLCbhytPiiVviC3XrGusbMAxFYApuuWB8PXAJUIWKgBmwqq8ZKvDwV6dHhTAcP6hJrJGq4X6
	bJQcPQFo=
X-Gm-Gg: AfdE7ckb8Q0xnKP9lYEu8Fw8aaSZew2P91010Kyw98Qs0QgIXo8uKJqqkVatmCITgmj
	+VpJ4XBJ3ItklEwTabjiWquXkzw5w4U5m4xBd56sbrWJgeCbNUy/z87kh5aH5y8gk6+KLVURgtw
	6dOPLM3WiwQiuvrf9fKHUaUiINQ2bvfzLB0Ri+lCc6B4EKW/98UfYpAlNvcBAJuB+OndV0uhdpv
	xRZQ2e6UuEB+Mr7aBY3tqUTq7I57cqcd+rSIXHSZSUJjqjHdyRzl0fgz2jCztf7jBrvd+zFWb94
	nuMCvcYhpvCe94PjNQ3TSQSa+d5DTVZmUqISJbAd2zuEkdbwOEJz2TPCgyRSKzBaMBe5E7sM9ES
	Gfw7/FBT+FESdyyGD0matnEHhu9rM499dgSFNu7dDxtaaV0uhXMMcoD3aYV44Ps49mxdcFc7+rT
	YUi3EviOaVoP0=
X-Received: by 2002:a05:6214:8109:b0:8f1:323a:fc45 with SMTP id 6a1803df08f44-8f1b9fc70dbmr307846d6.15.1782750821627;
        Mon, 29 Jun 2026 09:33:41 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f1a27e64a9sm2397176d6.4.2026.06.29.09.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 09:33:41 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Neha Gholkar <nehagholkar@gmail.com>
Subject: [PATCH] mm: mempolicy: fix automatic numa balancing for shmem
Date: Mon, 29 Jun 2026 12:33:37 -0400
Message-ID: <20260629163337.1264881-1-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B0FDE120002
X-Stat-Signature: muxefhctic57knehjzzfwixw3a6kpfjb
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782750822-794801
X-HE-Meta: U2FsdGVkX1+8CIQ7fbNQWclcWYYAMyPuFlKKUXge1LUEAU3u32p/8Ryv1oQZWIidjh9AUi+t/xfZpJ7vq03sibwL1l6UKaFyzYtKxlxpJlmBO7UJwEFuqekjyLvIPTeBMhG0yeLynoW7FdNRH+gqhPNQjkYd0EQQDLY0QWjPjCdJIO8DhEYOS2gYSC7j0hpUMUaVGjfHOnRH4b/5qEwBXVbYdR6cDEQA1U/34Hrzv89y4C2Ne4agldHP8YCq4xFxElycvNHwi42nfBHMzNfWF1L2OlEyAGMJ9twDvXSAH2iF02m3oY+Ubr8/CwTeI4JEirCQhKFNV/SsRY79NC1iqATUZiUJACQO/yCimMjKSZClaj1f3ctWyyH6kPuYuyLn3DvB91dgreqXcwbrrbTo5ojNkAaKt/R/o10uKBmZo+5CUOOcWbr1QtIdPbI+plk/QqV2vcSJWxIh0YXQSCxuJzzJt7p28+kx74qyhAw1LL/lpBubBHS+iPXxHt7oS+x3HJo521OJKT/NBvtq/i+kSHC/jd2QLPy/CssHgfBwMo9gu7xUuCIjBIF4bu/eL0Gs1x1j0lm6jY9C1x40rNcAHPmm37dEYnkFw1r0zAAnk7fyTtPseuhxCqtY0P/bs4vUmEZ1o5JeKOvRrZ9rqKhzLXjYUavgokwPBCsuEpuzgEwu2sthbJWpYUFtQcbn8pFtuMVBXDAfTOeTwuLY7xGxs9KlU81YBn22NqCa6LHCSOI4SWp4lWYpqQHpax/5Nj2dPtCBc5XStzJzl1rQLy8698tcokXtU62pZVxqKUap1KhU+7QX3E3T7/AmkpD9q16C/tgupzy7Qsg4Hb+5zC/A1tAJ+O9wwIdkGeZVKeeHJzxgqgUYpqoDY2fwZdvDRWy9fNr+i3P57DYz7dgmw4ea9pd343kv2DCVsL3Y63KLVmWmGL9iErgUiYxVamObVYifBebAbvP7KtBzc5WsCVi
 rbye1BYI
 uN6WDpPPp1ZMnKabjLtOhL/ZX8TEhprmMK9UHaFGvnIyEgHq5qtRoxXtpcpzADlN92Wx5NkWm6OhOPbhGWXO+LOkvvBf/W966aCSkyfW5ew2SXmKs1RDVHpb3GNm0GXNleNChMPYWJmsTCjIRbIF9KkDyOsNC6L0vbFDIXLdOoJmg/yH9p0F3PrS+gfymwvECxpjnkjL3aXClGKf+Ubxb7T50V4yCVg758CsABrXRrtG8bayxUcFBf+ce6foNtfI6pTNHcWjwXgrKHXa9+A/llSIL2yOqwDzRsluUo552pqhKLOAMj81TLrM6RcLA7GsOix4OChspDM52xn3v0A1hK5WIYD3SBsEV3i7nS4llwhDkfSH/5Nzf7CHF6m72pVf6y7fJWdf0WvhdsenzmmJv1i97/yf2qW/q9Z42oK1LWhdHIEpBzgF6ScrXAS51CtQkoZ1CT7Jo7I0RUre/ViTl4mPh28Rscxbnaq3wIhEU+qmzcqw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Neha reports that mapped shmem aren't considered for NUMA balancing,
noting convergence problems and bandwidth bottlenecking for cachelib
based workloads on tiered memory systems.

Looking at the code and going through the git history, this doesn't
actually seem intentional:

Commit fc3147245d19 ("mm: numa: Limit NUMA scanning to migrate-on-fault
VMAs") added a vma_policy_mof() gate to task_numa_work() so VMAs whose
policy lacks MPOL_F_MOF are skipped from NUMA balancing scans. The
motivation was a real usecase: Oracle was pinning shared segments with
mbind(MPOL_BIND) so trapping faults was both expensive and pointless.

The handling of NULL from vm_ops->get_policy, however, treated "user
explicitly opted out" the same as "user never specified anything." For
VMAs whose shared policy is absent - the common case for shmem - the
scan was disabled too.

This issue is old. It probably hurts less in conventional NUMA. But it's
very noticable on tiered systems, where entire tmpfs workingsets can get
stuck on lower-bandwidth memory.

Fix this by having vma_policy_mof() use __get_vma_policy() directly, and
thereby handle the fallback to task policy (-> preferred_node_policy()
has MPOL_F_MOF per default). Every other consumer of vm_ops->get_policy
already handles it this way, the scan-eligibility check was the outlier.

This preserves Mel's intended fix: don't scan stuff the user explicitly
pinned. But allow default policy vmas to participate in balancing.

Reported-by: Neha Gholkar <nehagholkar@gmail.com>
Tested-by: Neha Gholkar <nehagholkar@gmail.com>
Fixes: fc3147245d19 ("mm: numa: Limit NUMA scanning to migrate-on-fault VMAs")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/mempolicy.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 36699fabd3c2..bba65898aee1 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2057,24 +2057,15 @@ struct mempolicy *get_vma_policy(struct vm_area_struct *vma,
 bool vma_policy_mof(struct vm_area_struct *vma)
 {
 	struct mempolicy *pol;
+	pgoff_t ilx;
+	bool mof;
 
-	if (vma->vm_ops && vma->vm_ops->get_policy) {
-		bool ret = false;
-		pgoff_t ilx;		/* ignored here */
-
-		pol = vma->vm_ops->get_policy(vma, vma->vm_start, &ilx);
-		if (pol && (pol->flags & MPOL_F_MOF))
-			ret = true;
-		mpol_cond_put(pol);
-
-		return ret;
-	}
-
-	pol = vma->vm_policy;
+	pol = __get_vma_policy(vma, vma->vm_start, &ilx);
 	if (!pol)
 		pol = get_task_policy(current);
-
-	return pol->flags & MPOL_F_MOF;
+	mof = pol->flags & MPOL_F_MOF;
+	mpol_cond_put(pol);
+	return mof;
 }
 
 bool apply_policy_zone(struct mempolicy *policy, enum zone_type zone)
-- 
2.54.0


