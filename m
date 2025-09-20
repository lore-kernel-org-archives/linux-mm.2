Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F405CAC597
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 10:42:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 662168E0002; Sat, 20 Sep 2025 06:42:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E4A68E0001; Sat, 20 Sep 2025 06:42:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D3568E0002; Sat, 20 Sep 2025 06:42:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 30B6C8E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 06:42:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D50611609E0
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 10:42:25 +0000 (UTC)
X-FDA: 83909289450.13.F66376D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1EB5FA000C
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 10:42:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O83uxJ3m;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758364944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bcUR1tqJbRirnVcHGuo1ARvB2xtVm7kipRe2h9pGnak=;
	b=BjS3tPmO3IipdEOs5+ON0w/vNHrTMvuZLVopyiHwi6vT1yaAW5eTGrI31lFbKGJGh73i9k
	osw9hl7QGDM6zdK7JaYFNQiNQlfPFPBRF46uoqsahSfnQzS2QO+ZvGr0d5i7IGaX2QoPO5
	haJARQ6qIportIM7YJn31Sn8GjIKLF0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758364944; a=rsa-sha256;
	cv=none;
	b=NOgavJscZg/oVfR9yJTkropezA4YOM3xosb9ggQG0BkmIhGfVrxMafgJK5EBffDLcw89b/
	Y5PETGlyeakI6Yx+5PvB98DAiY9yWRw25+lYy3ELRz1mkmRRkgRSulVjjI3kcZvBXrq8oa
	jy4CI1RTAULdtRU6tGR2OOMLfx5gOlA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O83uxJ3m;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BF01D436E8;
	Sat, 20 Sep 2025 10:42:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADA4C4CEEB;
	Sat, 20 Sep 2025 10:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758364942;
	bh=9kwVqoLydbm2Rbeubw/EvPFJmKcEfrJda/IiMPaoeEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O83uxJ3mk3gybuY33XyTcokG0zq83t1iApEr3h2IJvkiY7uOByucy4zzlJZbOeKGm
	 SoTmG7WRl2NLBAUx1XuMQTNWJ6ER/14T70mp2NdHxMkUa9CJTva9MNuwN0hefq25gk
	 zjSwXnjoWRQmUU4/O8Bd4epIB6xdbWmWQcRGRqkcDmC0g13avlzQuCVe+erhgUw7nq
	 mWPzv73cVXnITs0h2IGJohXdmlcOy1BVULuEiFR3vMeBt+BT+td49w2d3WfvBRSr7u
	 IKysXP9BJthGnRlB91Ly/LoEDCmSQzEUxF10SBpWLUUWQk/WcI28PbfKZGV5IoZ7DM
	 1CgRl/5HTyXQQ==
From: SeongJae Park <sj@kernel.org>
To: Hugh Dickins <hughd@google.com>
Cc: SeongJae Park <sj@kernel.org>,
	Xinyu Zheng <zhengxinyu6@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zouyipeng@huawei.com
Subject: Re: [BUG REPORT] mm/damon: softlockup when kdamond walk page with cpu hotplug
Date: Sat, 20 Sep 2025 03:42:20 -0700
Message-Id: <20250920104220.1399-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <296c2b3f-6748-158f-b85d-2952165c0588@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qnr8kfz4pqwiby16gn97863jid7zzbio
X-Rspamd-Queue-Id: 1EB5FA000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758364943-354915
X-HE-Meta: U2FsdGVkX1/wzJCp2auU3ZAi4l5ssjj9cJ5SJ1xvVZD+aybRA6/FB9lFWTy82mnHD0oys6yElv8rx9VCpGO9pnKaJpmF9PkrjZ99ixbu0lCAYIWUhAgoCH4bUkuW3SrRCs517mS9GhJQWY7DmF7M54vczgFARbm+G0Lks1yJ5bIxFfRjpzKYNpgYTf1r48836miW4lAHcpynQ/0lDfgqAYaaz4kU9L3pMmsfW7Ag73PYs1Q/oYPYZ4dQdDpfd+ntxlwFrrAQXhoZlaWM695qjqqOJomLxo+wtBWXRQnvCIOm8rFadt+PYPn7A4m0zMrz6VOLFZek5oVxbm8BUnKId6Y9wxpufhyAbLUt/5u5wi+PW5ufvFNkY64PKCOiYQ+Bj7DRwVVzx7EZTB0jGgGlr99/nHk+aryYGGDnexiUpIICgSSU5fmzFyffAByMD0iE2LVwq8k48l8Xw3XGaX39subRqFtqVb5+qi0MA+8PxA4Mk2qc3kceGjfoU3VwHL4ei5q6CEzPtSWX993jNxVAik8OwQI7p1rhq9F0ldrQVZL7R27SzAvvrSxUYyAufIrfgAmQoOisofkhNAv7dVZdW+ADWnGddqkqcb9j/t8bgltRzgFa8m/gOGlfCQCbdmbcveqIoijTSJlmlSjTmIiKgYKQTlpuEFqpSDPMNZDb7SkPNZTSIcNpKir+J30vCj7pNjW3yvBySN4JUKmveRlnPl5Xl6TRex86hIlVIcuLTdfGBDyw2KvwaqO+jatp/izIAXNYhzSQSt8H2X+NO5fslcRtcbnYs85grlf5H0DdRbYMftCmhy0/Ckg9zF6u1iVk41vg7dPayDre0UhkyJ3xIP5PESdKilgO8w8I7nvrCkjGUuilJCLxMBaNYVEIP7I+E4qG0elSNzQxbxnHG8z6mUhlQZUyM+750wg8lO1/zCCDMfnForbpOvXuJHjxfgDvZAuVwJOmXnlpBpa7RKQ
 aVPtT/r4
 3UAeq4CtdVI8eJ+dXMqkM551g5FzOJ/6/42p/FN+qz6OELauhdHs7SFiQtBn30wyeIFjZq4ezSZyMfIa+jC+02bHUoRlmHqB9xn3J5Qjwl5JhfBDeQk2M3BSsJ5TgPpjQNCkSlPdwpWQn9ReQA8BvlGqAaWUiQARQm4MzMf28bxdlWf4VcKuzGOrspiFUKZjK8SiMoLzTPQKND2iAuuoG9DdqtVN7VlIHci8+6OerBrLHfYRJ2BSVkNb0Gve7o+UItNd1iMwFf8sHZWkgX+CmUKWt5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Sep 2025 20:56:56 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:

> On Thu, 18 Sep 2025, SeongJae Park wrote:
> 
> > Hello,
> > 
> > On Thu, 18 Sep 2025 03:00:29 +0000 Xinyu Zheng <zhengxinyu6@huawei.com> wrote:
> > 
> > > A softlockup issue was found with stress test:
[...]
> This had me worried for a while: thought we might be needing to change
> lots of other places, and scatter cond_resched()s here and there.
> 
> But no: no need for cond_resched()'s, this is all just a confusion about
> where pmd migration entries are handled: a pmd migration entry is accepted
> by pmd_trans_huge_lock(), but is not accepted by pmd_trans_huge().
> 
> See fs/proc/task_mmu.c for mm_walk examples of trying pmd_trans_huge_lock(),
> then pte_offset_map_lock() if it failed, or ACTION_AGAIN if that failed too.
> 
> When I ACTION_AGAINed damon_mkold_pmd_entry() and damon_young_pmd_entry()
> in 6.5, I didn't realize that the pmd migration entries were reaching the
> pte_offset_map_lock(), with corrupt results (or did pmd_bad() filter them
> out? I didn't think so, but it'll take me too long now to work out whether
> a pmd migration entry counts as pmd_bad or not); but knew that the new
> pte_offset_map_lock() filtered them out safely if there was a race.
> 
> But they've been reaching it without any race, so yes the ACTION_AGAIN
> would send the mm_walk back again and again for as long as the pmd
> migration entry remained there: not good, and Xinyu finds a lockup
> when hotplugging CPU without preemption.

Thank you for your detailed and kind explanation, Hugh!

> 
> My suggested patch below (please take it over SJ, and do with it what
> you will), converting damon_mkold_pmd_entry() and damon_young_pmd_entry()
> to use pmd_trans_huge_lock() as I'd been expecting, so handling the
> pmd migration entry up in that block.  (Side note: patch against 6.17-rc,
> but I see mm.git adds also a damos_va_stat_pmd_entry(), which would
> better be converted to the same pmd_trans_huge_lock() pattern -
> though I notice you're not setting ACTION_AGAIN in that one.)
> 
> But I have to admit, there's very little gained by using ACTION_AGAIN
> in these functions: it helps not to miss the range when racing against
> THP collapse or split, but you're already content to miss the extent
> if it has a pmd migration entry, and there can still be an instant when
> the range which used to have a page table does not yet show the THP.
> 
> So if you prefer a smaller fix (but a larger source file!), just
> dropping the walk->action = ACTION_AGAIN lines should be good enough.

I agree all your points.

I'd prefer the smaller source file following your suggested change below (using
pmd_trans_huge_lock()) in long term.  But, for a short term, I'd prefer the
smaller fix (dropping walk->action = ACTION_AGAIN) since it should also be
merged into stable@, up to 6.5.y.

So, I'd like to suggest as following.  Let's drop the
'walk->action = ACTION_AGAIN' like the below attached one, for now.  After it
is confirmed to fix the issue and merged into relevant trees including stable
trees, let's revisit the code to cleanup following pmd_trans_huge_lock()
pattern.

Please let me know if I'm missing something, or you have other opinions.

Xinyu, could you please test if the below attached patch fixes your issue and
let us know the result?

If Xinyu confirms the validity of the fix and no one objects to the above plan,
I will post the fix as a formal one with a better commit message.


Thanks,
SJ

[...]

==== >8 ====
From 743cafda8982624229541741dbfe5ff252328ac0 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Sat, 20 Sep 2025 03:35:34 -0700
Subject: [PATCH] mm/damon/vaddr: do not try page table walk again

For a quick fix of a softlockup issue:
https://lore.kernel.org/20250918030029.2652607-1-zhengxinyu6@huawei.com

Signed-off-by: SeongJae Park <sj@kernel.org>
---
From 743cafda8982624229541741dbfe5ff252328ac0 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Sat, 20 Sep 2025 03:35:34 -0700
Subject: [PATCH] mm/damon/vaddr: do not try page table walk again

For a quick fix of a softlockup issue:
https://lore.kernel.org/20250918030029.2652607-1-zhengxinyu6@huawei.com

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 8c048f9b129e..7e834467b2d8 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -328,10 +328,8 @@ static int damon_mkold_pmd_entry(pmd_t *pmd, unsigned long addr,
 	}
 
 	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
-	if (!pte) {
-		walk->action = ACTION_AGAIN;
+	if (!pte)
 		return 0;
-	}
 	if (!pte_present(ptep_get(pte)))
 		goto out;
 	damon_ptep_mkold(pte, walk->vma, addr);
@@ -481,10 +479,8 @@ static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
 #endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
 
 	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
-	if (!pte) {
-		walk->action = ACTION_AGAIN;
+	if (!pte)
 		return 0;
-	}
 	ptent = ptep_get(pte);
 	if (!pte_present(ptent))
 		goto out;
-- 
2.39.5


