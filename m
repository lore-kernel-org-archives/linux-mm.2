Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F37CF9D0D4
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 14:24:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 391416B0095; Tue, 14 Apr 2026 10:24:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 369546B0096; Tue, 14 Apr 2026 10:24:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27F336B0098; Tue, 14 Apr 2026 10:24:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 138D66B0095
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:24:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D283C160536
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:24:08 +0000 (UTC)
X-FDA: 84657380976.27.1664B82
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id AFE764000A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:24:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eo4OPyUd;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776176646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/tOIK+fr5m4BFelz6c3ZryPiZtEoVmunDRZA93Y7eRg=;
	b=kxncJtKquzI5NW5ieU3TbhsHT4GyjXjBT9ZwQUZ2xBxh5kjmYeYRL9K9ovBpdVQAsou5iW
	mXeV1akquk2At78k+HTLIdx4Sn7jZKQN3Dl3aNB7sV8LwaVhAHSThix6vsjWR5toR1oy/E
	j2d/qmN1STLPMgv3H83+R/8eSDqqkr8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776176646; a=rsa-sha256;
	cv=none;
	b=CAuSa5SiBdTrxWm1YIVtNWELlmrhWgHcB9FjBqRrGV5rULLRmTgrnR9X4CLTqPGv6JS75Z
	g0EGDNxd/v0OyEkoIJNKsO7mBFT7iniwkkVI86S5vimabO773h9WDutiEElv8O3yqODy3c
	naPSe1quY1OZFrx9/Qkw+vRo2jm4eXs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eo4OPyUd;
	spf=pass (imf12.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D09D943957;
	Tue, 14 Apr 2026 14:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2090AC2BCC6;
	Tue, 14 Apr 2026 14:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776176645;
	bh=9SQHe0wjWQ4DV8pwUSQ5vNuS7csFujXkHUIy1K9zVAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eo4OPyUdBPPyLpoQ4op2x+BV/yN9qLvE8zO6pEJTHQE+gTy95r1YNSnnY5uUQby3Q
	 MoV4cWH8y6ozy9fJ+/IhkvcakRdk2A258FTRUJWajHegeoQh4pHkl0l0rNyCYLOQBr
	 +50wP4xd2zH+tDbTnABRyhDy/gGGcpJzut7LUFhkIyjIgM+6Sbh06BdvVVbb7eM0/F
	 69C4XGI50Bz3XXJApZgYPMabn8iBKKYMAp+AClYA2TSx1zYC7+CjukcLIhE4jPU55v
	 OlhB6z88Qywpc2tkKj8UWkX0MJaKVkkoY7sgdTEL4sCXpN0k/qjMxsuP/XVIWQ9IJB
	 ez5iKfVmO7mLA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 51201F40068;
	Tue, 14 Apr 2026 10:24:04 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Tue, 14 Apr 2026 10:24:04 -0400
X-ME-Sender: <xms:BE7eaYX5Rk8BHF7xX9wfFPqEbatM6ADEYnxyUkZGjWAT8kNkLkCA2g>
    <xme:BE7eaTgZ5falvDeWN5Rhqw_ILNbu58Uo5jhazrwhEZaFKMbkQun9W3C-ye6R2qH0_
    wco9zFrLP3MvpYkjwdCNJaePIkjRRiLvQEyQjQ8G8FzOqPv_3cINKk>
X-ME-Received: <xmr:BE7eaRdfw3WnDhkxwUB82JsmuKk70kbsU-rep2zOzfYzyvlUHy_Qm-qE5cLpCQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegudefkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfgggtgfesthekredtredtjeenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhvdefvdevjeevhefhhfevudefudejfeduvdekheeludfh
    iefhhedujeffffeigfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidq
    udeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgse
    hshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeduledpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehpvghtvghrgiesrhgvughhrghtrdgtohhmpdhrtghpthhtohep
    uggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhjsheskhgvrhhnvghlrd
    horhhgpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehs
    uhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgt
    ohhmpdhrtghpthhtohepiihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:BE7eaedeiGuTYSUXfr__qRjqSdygLh_5kwsjNLJVHwVt5lU4vynK3w>
    <xmx:BE7eadXmpjd8JRePftAcD2YxmaUd9JeQ187kpG68BZghWQi9oZYlNg>
    <xmx:BE7eaSd-oaQA_BnaICJ1RVjs3l4IvfhLeC9mAoan1H6J8r6etuJhig>
    <xmx:BE7eaR8JWoHGfkWQOHcge8GmJcavoXoqISVZGh4TljbNmbVdm311lQ>
    <xmx:BE7eaRkLHx5GLcKkTTf8r9InF5WpapBIZJszA_hkiRo8W-y7qu7WJSm9>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Apr 2026 10:24:03 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [RFC, PATCH 04/12] userfaultfd: UFFDIO_CONTINUE for anonymous memory
Date: Tue, 14 Apr 2026 15:23:38 +0100
Message-ID: <20260414142354.1465950-5-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260414142354.1465950-1-kas@kernel.org>
References: <20260414142354.1465950-1-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AFE764000A
X-Stat-Signature: r9gqncgsziy78stnogxzh8e3qarmk845
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776176646-471240
X-HE-Meta: U2FsdGVkX1+VrjeMKQIFNhBN83f2hDkPTM4IqaC21VIcsZrE8Zs280gE3U+7T7WZG/Q6N2qmPN4VPNyN6W621SBQCmGaToRtAgMWU7ruCD5Z+9MT0C9Galp+Nf5mFwsNXJDLy3vluk6U9OaxgMk2tGombkPlTGhht6K3/7k3f8ubd80cMt9FDQjjKTJ9RoSTnVHIqT0OcqEobQ9HY7hjS9s+5WeBGtMowvNz8/cPvKru9OJT6FJ0YTGjQvNAn+3p0kztvojeB1QScKTQIqaKTRum0dUhrMTcbVOozshTT1iU8ffUHRjKtLPCbQCqBfipwoRHmk3m6Mz6ex3b1IgCGc4gyv+p03mC96erQ5BCbwIQzNwc6ubURGFiL6+0r+XtNpmH1JJl1xoQjz2zG7PFhZhkVwWw+XGGtqjV2OcEt1LdGIwofV74oVwtkzI/msIR1vl/a5YIoDeVFGbaNDmR30dE6Y0jlLs4yStGYGU0zieQLt8BUTEDGgTJmLAZ8Nmq5RarL0MWzNXLCpx0m3vMbdK+ouXywpUg60e0KbsOMJ1y70fiU4QXnekzd3YQCcFnVC865Z9gPgv1NbfqF8uJE2xWFNQeqlg1Ug48Ny8G//X+aYTHrTDz74QOLwUq81uW2avbzQIVJSw8AT+GWrBs6jkIdPA4kf8P5ilFoa2SujTEnmY+Mx33VBWRRxatGS1Z+zK1H8Ckjy31QtUZa1BDW1qRwafPIWKER9LQBi7TwssPn9BzI4GUzG9bfjn8BXsHxZG03OU747qO+vwbegKvXASKI1Frz5dxXxune2bvqXOjss+aajJnMbc6XcFikpSXdF13kksXkqH8pjWFpq59FWDoS1syF8Y1Jkn5c1P/iMoCSSquSOuWrSok5h4r2h18iqYgnRfYWCusjGHvuPOquuw91gyPH6RlxxLM91IURJQvpB7Sg8vbPwsXv70yVAD1BKFREqWx3iuIAUsSlgJ
 wpmPlH7j
 Sdty+zetZ+DKIxQAvocchHJsPVRlp2/MHEoCK/oyUpDufxBloWJa1sqbOuyxuXWKq5Hv7OBMJ3StOOWiLlSkNqwiytXHdTECWHBKkZr/Jg/waLlI4aVp3QC4sRqDy2ZRMt1gy7W9T6eyp6hTEmgdj6oru4KnSsTcq+ICH5rdYTOcOI4dgZCDNLKroW0D87kFBB1+CE8svt+h++qLgi0Kmr4np/3k1DkRz1B1LUohJgHMWX/t2BKwauUV9cB1eUG79PRvjXJK6yTY6Hd4SuYHSmpFIrOMZlQozdJdsQdn530QgqiEDpM9RuvpATaLAxvC3AY0o4GczCnPMYcfGsBfh41zYdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow UFFDIO_CONTINUE on anonymous VMAs with VM_UFFD_MINOR. For shmem,
CONTINUE installs a PTE from page cache. For anonymous memory, the
page is already mapped via a protnone PTE — CONTINUE restores the
original VMA permissions.

PTE level: mfill_atomic_pte_continue_anon() walks to the PTE, verifies
protnone, restores permissions. Rename the shmem path to
mfill_atomic_pte_continue_shmem() for clarity.

PMD/THP level: mfill_atomic_pmd_continue_anon() restores protnone PMD
permissions in place without splitting. Handles PMD races with EAGAIN
retry in the mfill_atomic loop.

Add protnone PTE/PMD checks in userfaultfd_must_wait() so sync minor
faults properly block until resolved.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
---
 fs/userfaultfd.c |  9 +++++-
 mm/userfaultfd.c | 82 ++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 84 insertions(+), 7 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index b317c9854b86..43064238fd8d 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -340,8 +340,11 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
 	if (!pmd_present(_pmd))
 		return false;
 
-	if (pmd_trans_huge(_pmd))
+	if (pmd_trans_huge(_pmd)) {
+		if (pmd_protnone(_pmd) && (reason & VM_UFFD_MINOR))
+			return true;
 		return !pmd_write(_pmd) && (reason & VM_UFFD_WP);
+	}
 
 	pte = pte_offset_map(pmd, address);
 	if (!pte)
@@ -366,6 +369,9 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
 	 */
 	if (!pte_write(ptent) && (reason & VM_UFFD_WP))
 		goto out;
+	/* PTE is still protnone (deactivated), wait for userspace to resolve. */
+	if (pte_protnone(ptent) && (reason & VM_UFFD_MINOR))
+		goto out;
 
 	ret = false;
 out:
@@ -1820,6 +1826,7 @@ static int userfaultfd_deactivate(struct userfaultfd_ctx *ctx,
 	return ret;
 }
 
+
 static int userfaultfd_continue(struct userfaultfd_ctx *ctx, unsigned long arg)
 {
 	__s64 ret;
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 3373b11b9d83..4c52fa5d1608 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -380,8 +380,61 @@ static int mfill_atomic_pte_zeropage(pmd_t *dst_pmd,
 	return ret;
 }
 
-/* Handles UFFDIO_CONTINUE for all shmem VMAs (shared or private). */
-static int mfill_atomic_pte_continue(pmd_t *dst_pmd,
+static int mfill_atomic_pte_continue_anon(pmd_t *dst_pmd,
+					  struct vm_area_struct *dst_vma,
+					  unsigned long dst_addr,
+					  uffd_flags_t flags)
+{
+	pte_t *ptep, pte;
+	spinlock_t *ptl;
+	int ret = -EFAULT;
+
+	ptep = pte_offset_map_lock(dst_vma->vm_mm, dst_pmd, dst_addr, &ptl);
+	if (!ptep)
+		return ret;
+
+	pte = ptep_get(ptep);
+	if (!pte_protnone(pte))
+		goto out_unlock;
+
+	pte = pte_modify(pte, dst_vma->vm_page_prot);
+	pte = pte_mkyoung(pte);
+	if (flags & MFILL_ATOMIC_WP)
+		pte = pte_wrprotect(pte);
+	set_pte_at(dst_vma->vm_mm, dst_addr, ptep, pte);
+	update_mmu_cache(dst_vma, dst_addr, ptep);
+	ret = 0;
+out_unlock:
+	pte_unmap_unlock(ptep, ptl);
+	return ret;
+}
+
+static int mfill_atomic_pmd_continue_anon(struct mm_struct *mm,
+					  struct vm_area_struct *vma,
+					  unsigned long addr,
+					  pmd_t *pmd, pmd_t orig_pmd,
+					  uffd_flags_t flags)
+{
+	spinlock_t *ptl;
+	pmd_t entry;
+
+	ptl = pmd_lock(mm, pmd);
+	if (unlikely(!pmd_same(pmdp_get(pmd), orig_pmd))) {
+		spin_unlock(ptl);
+		return -EAGAIN;
+	}
+
+	entry = pmd_modify(orig_pmd, vma->vm_page_prot);
+	entry = pmd_mkyoung(entry);
+	if (flags & MFILL_ATOMIC_WP)
+		entry = pmd_wrprotect(entry);
+	set_pmd_at(mm, addr & HPAGE_PMD_MASK, pmd, entry);
+	update_mmu_cache_pmd(vma, addr, pmd);
+	spin_unlock(ptl);
+	return 0;
+}
+
+static int mfill_atomic_pte_continue_shmem(pmd_t *dst_pmd,
 				     struct vm_area_struct *dst_vma,
 				     unsigned long dst_addr,
 				     uffd_flags_t flags)
@@ -667,7 +720,10 @@ static __always_inline ssize_t mfill_atomic_pte(pmd_t *dst_pmd,
 	ssize_t err;
 
 	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE)) {
-		return mfill_atomic_pte_continue(dst_pmd, dst_vma,
+		if (vma_is_anonymous(dst_vma))
+			return mfill_atomic_pte_continue_anon(dst_pmd, dst_vma,
+							      dst_addr, flags);
+		return mfill_atomic_pte_continue_shmem(dst_pmd, dst_vma,
 						 dst_addr, flags);
 	} else if (uffd_flags_mode_is(flags, MFILL_ATOMIC_POISON)) {
 		return mfill_atomic_pte_poison(dst_pmd, dst_vma,
@@ -802,11 +858,25 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 			break;
 		}
 		/*
-		 * If the dst_pmd is THP don't override it and just be strict.
-		 * (This includes the case where the PMD used to be THP and
-		 * changed back to none after __pte_alloc().)
+		 * THP PMD: for anon CONTINUE, restore protnone PMD
+		 * permissions in place. For other operations, reject.
 		 */
 		if (unlikely(pmd_trans_huge(dst_pmdval))) {
+			if (uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE) &&
+			    vma_is_anonymous(dst_vma) &&
+			    pmd_protnone(dst_pmdval)) {
+				err = mfill_atomic_pmd_continue_anon(
+					dst_mm, dst_vma, dst_addr,
+					dst_pmd, dst_pmdval, flags);
+				if (err == -EAGAIN)
+					continue; /* PMD changed, re-read it */
+				if (err)
+					break;
+				dst_addr += HPAGE_PMD_SIZE;
+				src_addr += HPAGE_PMD_SIZE;
+				copied += HPAGE_PMD_SIZE;
+				continue;
+			}
 			err = -EEXIST;
 			break;
 		}
-- 
2.51.2


