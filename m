Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 267FDC5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43BD26B0871; Sun, 16 Aug 2026 18:46:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EBFC6B0873; Sun, 16 Aug 2026 18:46:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DB5F6B0874; Sun, 16 Aug 2026 18:46:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 084496B0871
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:46:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7B2C01C1979
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:57 +0000 (UTC)
X-FDA: 85108619274.11.1D508BC
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf05.hostedemail.com (Postfix) with ESMTP id A061310000B
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:46:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="s KocDFE";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Pn8FC+cK;
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QHqKPBFVnTs29f21vr16ac6OAqWm4F4NnweEXoqIRdA=;
	b=F/Iv3ftj8E22gLIoqByT9JhdciYY0SW+sNtTFl7lI59qZrfFkuHLOgSa/OHBgghPH6rh+r
	v/93lR7gamqyA9H5pvgvtfqjqpKAH3hrTdUkMRzbs5Uw8SJpC/ePV8J5vSsEAwV4h8T2jH
	2aj69TDLT+rsqLfehrJsyi1/JyuLGgs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="s KocDFE";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Pn8FC+cK;
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920415;
	b=RMhMwbGiSUmIDBQ8WEkCy0gwGLFrSW9mHzgG4qN/2WdxCQdV4fnSBJ78oO4nUNwSylKHfy
	zi7DJou7nFZUff7gJNRusX4AruaYKFLZB+rDc9B35gX5aH0quqE2hzOpdVMNKFxn+yd8nw
	6jBH0kc5KyodhY/thbuK2wbORZWLl2U=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 3831214000FE;
	Sun, 16 Aug 2026 18:46:55 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Sun, 16 Aug 2026 18:46:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920415; x=
	1787006815; bh=QHqKPBFVnTs29f21vr16ac6OAqWm4F4NnweEXoqIRdA=; b=s
	KocDFEWxrud+mkbmUPVtPbiu+43Yn2FKamFIEZsI8h1/8zMn+TOqdH179ImZq0r6
	cWYLXuGvF1fkFRAMw4ywLXI+WzpZcgVRCKxenmyXvhuDoXTXJXsA9giezG4P5EfC
	kvOWiCXvcK3ShC6M7rvmIKTUWXLmjF1JntkGSBWhMTWESJRubIGqMQMcqtRWRaL8
	9peyASLhyFQinM7O7SL7VGdgkjfHx4lPSK3KXyx4bBUYNyFmzhrQmx6Cg5Dr+aMh
	rDPQ4jPr/FWiaQ6xmdcaIRMUYuCycuG1ESU2mCHfYEeod50x5/CwPCT0BCaTj61k
	ZTB3rAabkvnyWmH3sM+Bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920415; x=1787006815; bh=Q
	HqKPBFVnTs29f21vr16ac6OAqWm4F4NnweEXoqIRdA=; b=Pn8FC+cK/ZMRgElW7
	Y2ryQGC/MlYol41rOcraOqvuS9tz98JDGzwqcbpAN6+cKxWG1j2SGamTMSQVKThD
	La/KjzbQXBrOfCGFhuvPaOiD1uZYMpPEo7m86OchlgTRnbeuayAKCcOOEpJpPFt5
	XI7W8XMlZg21XxckGOwcigBZBtAGfIwjtrc4vORVl2Aro+aPusKxCJzoULKTIW76
	sHInn6i8JGuaQDvSZGcuDEMUgyU1tNZKrtiJosDCJeUrSXwF41nK8zrM8l32Sclh
	9P/gAxclYtIliRvNM4e/pMEN8wUTumUoIl5D5Jqu3yChwWC7rMlWJaA1/7BhzbE+
	uKeQg==
X-ME-Sender: <xms:3z2CaoaX1k-LNAXM39Eo2aKqRk5KN7Cew2Q4sgQIJveUgc5djWoDyQ>
    <xme:3z2CaosdfHihshqhl023_YPBFo6fJx6Thvo29fNHz3Sg132AwvDpwaDw2FALR7Fsg
    u7bSiMtvm8AMCQtWDe1yX23RRF0Q6lalWcP_IePOC-eSLdJS61XqRg>
X-ME-Received: <xmr:3z2CavBtVfKIoZlcw6TPUFq4QpB8VMskDEmXllYhNWZv2Z0OI1M9vQ6ZwXg>
X-ME-Proxy-Cause: dmFkZTGU6CsvhMdBtF1sno4coJRY9LqZz27w5X62/KcvcmaHPoOW0E1BwYMGQvImxADkeF
    Vrd/NWvQclh95CfVK4mxB+x5IwibSBkynFlxvp5GF5/z4jepOu57IyLHUvB8DzXymwpMun
    cyoWwWLP4hjAaD7bSTsoDmYKe03ryBERSg0IuR8ZqJolHrsaFnqWf5mL2byVsL9qLL9zPI
    9yLFlvwwZlCiJbT4IVFlRVV/9A2lZNuDFrGWvpQWw3cjqX9EcFrpnMQcn/0MdQygQWXSYC
    yXHZy2pRvgBssh5qObsL1GM1XSEE6m2uHX2m5CwJlvTSIfOodU1appS1XFI/CBVlhtQ7CF
    ULG6OtC6a1s/NmdMZEoDsIJcrpBkdRdhXB11gNV50z2d4E/iJeXml3T3h/o0H7gU+64vOP
    PqPDa4EdcFe/rGNcm71i1IAqWlLhpil33moV0JBcgZQm9qfgBsqf0h59iIN1pPwwFe7xeZ
    P7twIKhdh+uX1rwSO+SB2Ua/tk/l9fjmZe+S/3gFTdptk2aaquAFLmgWmNltN4ZZAqkppG
    LpcqV7O4OtJwJTFWHt0SRtr6RBcJbb1AY6je6ZAylypaQl8WN8RmScIh8gpwmMGiCcQ2r8
    fuizZBKpxbm2PItZCAiLKBTcdO/z5AopY1nNAlm7k36xkZfTwfcgPCHgB6jQ
X-ME-Proxy: <xmx:3z2CavNR8kVdJNi9TH89lhcQ4TkpDFzBq25DfoaynU7Hn_5mSy0qFA>
    <xmx:3z2Cap53MsPQrKejKa8zra3I3QJGYB1ma_ErPALcWlGyEPZ0mHViqA>
    <xmx:3z2Cap0Ans1JV1ex615QjDXgOUsZs0E66ReSPF7luoyvvRSyvwwvSw>
    <xmx:3z2CaoqlV5Q8E9NJkzhNZaF66eQmk43LzQJInV9_Nkk30ZoMeBIBMQ>
    <xmx:3z2CascBTPNqFGz0uu4-_o7y928VHQ9qIWlb4YONvafw_9Te3AxuxTXu>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:46:54 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 19/57] mm/collapse: install a PMD leaf as the terminal layer
Date: Sun, 16 Aug 2026 23:45:31 +0100
Message-ID: <20260816224609.308019-20-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A061310000B
X-Stat-Signature: warrou55ym15687d6nm9tg5sxdkrk7s8
X-Rspam-User: 
X-HE-Tag: 1786920415-764495
X-HE-Meta: U2FsdGVkX19bHUVUXOGBB79noTpUG9RXIQRoR1ph4TuMyasmiLLe4o/LxLigkvCmAKBfXe2/ZeViBTaAMHUpKrnsuTgXk23Zy9y2ujmHNKEApkWVRlHsxmtIRjxXrlZh+AZtYizz8HY5IScEJk7FIakgLtEwNrDaLU835wEZ8WiKqbiYxxOGye+UfPd4uOxsf8wwCkohWoFr4Rk9QCFQefiyBZ9+Hw4iThNHDS21OORYt4/x9xIEjKM9AVWWA6lnFmT8zMzPQ6DHUsUfMMKXWxfDJuHmpAFBmmBrZKlVCxqf84kTAZJ6QePvgpWv3odrp9BylGAEj4/hRcbNXFrLq9cAfG2bpJqiE6hb0XaeCP1Q9UC+P8JplCxLUlYuC6eIQpSImkKnw4GdMHMnxaB4dhUExmxt29/WgOZjvNBz0dMGWwuIo8d3qI1OhbQKTAHVJWA3BhprZKuaWCN/SyhWeUzak+nh61QzQllgj82h4Deg5MnjCW9UqYza8k+0sI4eRYV5E0PtoCMocDy9cU8RTTTKZ5LOdVrN851HUeFk5djzUQhAdwziaGC0gTDk82iR/KqchiacNfsTx0VvlvV+rgzU/78nR/EW4aDVOpiLUeaMwSxKzsehklheY4cqNrHtw1Lq07ymONN0lOxrJ9cWRgA9roEkpcuf2nNQxpPzVWbm/c2EzJAAQkB/73hSOSKiyCVW/b1Yz+0LiYvwE6WUrEZK+OEEEl9uThK8meUJeiVqci+2IKeI4+k6qWPCsrKcvEnZHpSlFFoNuAY13sCWmz9SS1RxQnGo+vZgvUQOMxFdfc+yG9nhKkta2M4XgYxYLw6lfkMzxf8fGH3Z9LaEsUD/I/By8pU9XOgeLJQ/EX8PRFmyvum42XM2v1alC+3ELWSHHzzJ5rgYM1qLTsyFsTo7CiX8WaDRFdCLo0nr+l9NZEDJkI/NtaEDu881gVDXKZU3zHi5gj7BavwqPG7
 VD5IGKj5
 HvwlKZfoz+Vm3K2mRraVuelp3Qk64V6jAODsTOpt/hTDYUwGBCRvbQDXMfolbh1wYncD7rw43XMC09Ln4FTz4XtQGAlr6yENVvMPQTux58JPXQQfsF5NQXmWCaBnudaGY7euCBgvzBX7IkMyLKT+bkvX2nraKeSLIqItbfk5TGbZFZXuXefthHOoVnXbcQYI4qRfKlfvyZpxgI6ajbNjftdrMX+rD5EPtXjigDOHAhF6czilah6NihQqolPFSvrc8pNTOFiLEJiIPQd7fcy7FrAqSn5GR/syea4h5i4hFVAMEMr44UEA/vBSEqS5ZJF5SsqFnd+pvE2D6hpUGFUFIVcj2d363/pixw455jEVdHy+g/I87w616f5ydaIZHxG5Are1nOaBxWK21V/N1vgYJe0Fz4G64/TSAXCT/G0GdsGrK5YWy6m9xWGbj7dgxKW5d2iFRrLfQMkJP41U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Fill in the PMD install.  Under the pmd lock, with the pte ptl nested
inside it: verify, detach the table with pmdp_collapse_flush(), deposit a
fresh one and map the leaf.

That is one atomic section, so no pmd_none() window ever exists: faults
stay held down at pte level by the migration entries throughout.  It is
what lets PMD collapse run under mmap_read like everything else here.

Two things force that nesting, which is the one the tree already uses to
reinstall a table.  A racing zap of a frozen entry takes the pte ptl, so
the verify has to hold it.  And the table must not come apart between
verify and detach, which is the pmd lock's job.

Nothing leaves the section early, aborts included.  An abort only
restores PTEs and would need no pmd-level exclusion of its own, except
that its pte pointer came from pte_offset_map_rw_nolock(), whose caller
must establish that the pmd is stable.

The deposited table is the freshly allocated one, never the table just
detached.  A deposited table has to be quiescent, because whoever
withdraws it frees it immediately with nothing to hold a lockless walker
off first, and a table that has never been reachable is quiescent by
construction.

The detached one is not: GUP-fast and RCU pte walks that read the old PMD
may still be inside it, and on broadcast-TLBI architectures the flush
expels nobody.  Quiescing it would need an IPI, which has nowhere to go
here -- outside the pmd lock it opens the pmd_none() window this design
does not have, inside it is a broadcast under a spinlock.  So the
detached table goes to pte_free_defer(), which holds the free until those
walkers finish.  One transient table page per PMD collapse is the cost.

No anon_vma_lock_write() is taken, unlike the mechanism being replaced:

 - rmap walks on the sources are unreachable, their refcounts frozen and
   their folio locks held from freeze to putback;
 - non-rmap pte walkers see migration entries;
 - pmd-level observers see either the old table or the leaf, never an
   intermediate;
 - fork, mremap and munmap take mmap_write, which the mmap_read held here
   excludes.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.c | 118 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 118 insertions(+)

diff --git a/mm/collapse.c b/mm/collapse.c
index 842adc30aeb0..ab7476471b8d 100644
--- a/mm/collapse.c
+++ b/mm/collapse.c
@@ -1232,6 +1232,124 @@ static bool collapse_verify_candidate(struct collapse_candidate *cand,
 static void collapse_install_pmd(struct vm_area_struct *vma,
 				 struct collapse_control *cc, pmd_t *pmd)
 {
+	struct collapse_candidate *cand = &cc->candidates[0];
+	struct mm_struct *mm = vma->vm_mm;
+	spinlock_t *pmd_ptl, *pte_ptl;
+	pgtable_t old_table = NULL;
+	unsigned int nr_populated;
+	pmd_t old_pmd, pmdval;
+	pte_t *pte;
+
+	if (cand->state != CAND_FROZEN)
+		return;
+
+	/* No destination: the provision pass could not spare one */
+	if (!cand->new_folio) {
+		pte = pte_offset_map_lock(mm, pmd, cand->addr, &pte_ptl);
+		collapse_abort_candidate(vma, cand, pte);
+		if (pte)
+			pte_unmap_unlock(pte, pte_ptl);
+		return;
+	}
+
+	/*
+	 * The pte ptl nests inside the pmd lock, the nesting the tree already
+	 * uses for reinstalling a table: a racing zap of a frozen entry takes
+	 * the pte ptl, so the verify must hold it, and the table must not come
+	 * apart between verify and detach.  pmd_same() rechecks are unnecessary,
+	 * the pmd lock being held across the whole section.
+	 */
+	pmd_ptl = pmd_lock(mm, pmd);
+	pte = pte_offset_map_rw_nolock(mm, pmd, cand->addr, &pmdval, &pte_ptl);
+	if (!pte) {
+		/* Table gone under us; see collapse_abort_candidate() on @pte */
+		spin_unlock(pmd_ptl);
+		cand->result = SCAN_NO_PTE_TABLE;
+		collapse_abort_candidate(vma, cand, NULL);
+		return;
+	}
+	if (pte_ptl != pmd_ptl)
+		spin_lock_nested(pte_ptl, SINGLE_DEPTH_NESTING);
+
+	/*
+	 * Every exit is inside that section, the aborts as much as the install.
+	 * An abort needs no pmd-level exclusion of its own; it only restores
+	 * PTEs.  But the table it works on came from pte_offset_map_rw_nolock(),
+	 * which leaves its caller to establish that the pmd is stable, and the
+	 * held pmd lock is what does that here.
+	 */
+	if (cand->result != SCAN_SUCCEED) {
+		/* Machine check during the copy */
+		collapse_abort_candidate(vma, cand, pte);
+		goto out_unlock;
+	}
+
+	if (!collapse_verify_candidate(cand, pte, &nr_populated)) {
+		cand->result = SCAN_PTE_NON_PRESENT;
+		collapse_abort_candidate(vma, cand, pte);
+		goto out_unlock;
+	}
+
+	/*
+	 * Nothing fallible sits past here.  No anon_vma_lock_write either: rmap
+	 * walks on the sources are unreachable -- refcounts frozen, folio locks
+	 * held from freeze to putback -- non-rmap pte walkers see migration
+	 * entries, pmd-level observers see the old table or the leaf and never an
+	 * intermediate, and fork, mremap and munmap take mmap_write, which our
+	 * mmap_read excludes.
+	 *
+	 * The flush inside pmdp_collapse_flush() is the round's second over this
+	 * range: the freeze displaced every leaf here and flushed before dropping
+	 * the ptl, and the verify above proved nothing has been mapped since.
+	 * What it covers is the paging-structure caches -- a CPU may still hold
+	 * the pmd-to-table link, for a table that is about to be freed -- which
+	 * is why the helper shoots down a pte range rather than a pmd.
+	 */
+	old_pmd = pmdp_collapse_flush(vma, cand->addr, pmd);
+	old_table = pmd_pgtable(old_pmd);
+
+	/*
+	 * The smp_wmb() in __folio_mark_uptodate() orders the copied data before
+	 * the install below publishes it.
+	 */
+	__folio_mark_uptodate(cand->new_folio);
+
+	/*
+	 * Deposit a freshly allocated table, not the one just detached: a
+	 * deposited table has to be quiescent, because whoever withdraws it frees
+	 * it immediately (zap_huge_pmd()) with nothing to hold a lockless walker
+	 * off first.  A table that has never been reachable is quiescent by
+	 * construction, which is why collapse_alloc() secured one.
+	 *
+	 * The detached table is not.  GUP-fast and RCU pte walks that read the
+	 * old PMD before pmdp_collapse_flush() may still be inside it, and on
+	 * broadcast-TLBI arches that flush expels nobody.  Quiescing it would
+	 * take an IPI (tlb_remove_table_sync_one()), which has nowhere to go
+	 * here: outside the pmd lock it opens a pmd_none window a fault can fill,
+	 * inside it is a broadcast under a spinlock.  So it goes to
+	 * pte_free_defer(), which holds the free until those walkers finish, as
+	 * retract_page_tables() does.  One transient table page per PMD collapse
+	 * is what that costs.
+	 */
+	pgtable_trans_huge_deposit(mm, pmd, cand->deposit);
+	map_anon_folio_pmd_nopf(cand->new_folio, pmd, vma, cand->addr);
+
+	/* Slots with no source gain anon memory that no zap accounted */
+	if (nr_populated)
+		add_mm_counter(mm, MM_ANONPAGES, nr_populated);
+	cand->deposit = NULL;
+	cand->new_folio = NULL;	/* ownership: the mapping */
+	cand->state = CAND_INSTALLED;
+
+out_unlock:
+	if (pte_ptl != pmd_ptl)
+		spin_unlock(pte_ptl);
+	pte_unmap(pte);
+	spin_unlock(pmd_ptl);
+
+	/* The deposit balanced the detached table, so the count is already right */
+	if (old_table)
+		pte_free_defer(mm, old_table);
 }
 
 /* Publish each destination folio in place of the sources it replaces */
-- 
2.54.0


