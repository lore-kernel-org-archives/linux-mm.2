Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7528D1112246
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 00:09:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66AF66B0088; Wed,  1 Apr 2026 20:09:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6423B6B0089; Wed,  1 Apr 2026 20:09:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57FB46B008A; Wed,  1 Apr 2026 20:09:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4BE646B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:09:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E76F713A03B
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:09:34 +0000 (UTC)
X-FDA: 84611681868.14.0DE415E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4A51B100008
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:09:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1WJ8RFiQ;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775088573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yc5L/NSEgypRcObdx4WXROK4jY/IiP1dMAt+IkBC6WY=;
	b=l/otTZUvrsIlW1iBb2giDQAEzUv69R8WWxrzE6wGxyv/92CxgFxYPEU0WKkUtjzJ2JQbGD
	TX1VIroyySQEH9Qx2ZHmzaPHIAGWgyYyt13Lxey/4+tIT4Ij8cBTsW9V7otR9lRXxLgNXU
	6+mxoZmHpHABqZdD6Y+w+P5T8Si5fMU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1WJ8RFiQ;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775088573; a=rsa-sha256;
	cv=none;
	b=ZSQlJy8TkbwX0r0UOkXyq2MxKHxl4Q7AAyGFdhzOMLOVC8HAdA/xvZzRpFH8i0IL39AFip
	bMZE7FxbjxmJ174GsnermurQ6zeMalkKIOPgBL0sjIb5z8/2o4BdzNFYX63QC9UCrRCpF5
	5DlfUru7bjIWR/lcc6I2R/31OuO+qOY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 64E9D60120;
	Thu,  2 Apr 2026 00:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD2CC4CEF7;
	Thu,  2 Apr 2026 00:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775088572;
	bh=dkAtgDLSBaxNr5vlZELUNXtYvuqifZY6JTWaqhRVgv8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=1WJ8RFiQxomXlhtkeMx4OumY070hPRb9rh/7m56LYt6iVWvhEGUyg2LUl2uF2et1u
	 r0kBOvehREBh1C9w7966A64zWRSKJYETLghEhiDoKz6m9XKjOXI+CFLxk2yCMvR6M8
	 KHZJiOaoxC2P8ECWIqIky/JiDAfGCs1lcOF+xQ9s=
Date: Wed, 1 Apr 2026 17:09:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil
 Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Dev Jain
 <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>, jhladky@redhat.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/mprotect: special-case small folios when
 applying write permissions
Message-Id: <20260401170931.9e455bbf679792b039d9770a@linux-foundation.org>
In-Reply-To: <a7a903bf-10c2-4d2c-872d-9b31fefb5d1f@kernel.org>
References: <20260324154342.156640-1-pfalcato@suse.de>
	<20260324154342.156640-3-pfalcato@suse.de>
	<fbabc728-a87b-48e2-87dc-68ac21eb02d4@kernel.org>
	<dccxy3i3kaprljloxbyo2u346bu6xwev42cpvt5lfbbli2hbap@6n2rd5mftffh>
	<a7a903bf-10c2-4d2c-872d-9b31fefb5d1f@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A51B100008
X-Stat-Signature: gj34arsu3gfbnpicg4fpig7jusmr8en7
X-Rspamd-Server: rspam06
X-HE-Tag: 1775088573-775281
X-HE-Meta: U2FsdGVkX1+CYNP27eCv5MrK15Ge1WeZ4gsquH5KK2AYsG22IFGHR/BDxVsp4KF3JoKzprqXCfsTLN1hWnCGe6A7VfhZaOCCyiVw9iWYc7zZaeoqcU+aSM6zm+rxQmt1Ls/zvPYrzN/nr1QRiwiywpRSeuoPw/McH53X7Lli8y2jxCpw/jwY14Jb02W9CVvx24sgDMsLSHTPLnwG7hmbNz/4uXphxcj4eDnVktsrdHDiaX2WyNUYP0M0oFJoOL/Hs6+eDi+vtsqOke9pRFTzSwRvGJWQnJQ8MKhdTU7SjeCtD+FAjzszJeHNh/SlltCExrJYFL8byyJqm+D3LUXZXuCrqGRETHN38t4+CNy5Q7LBus2j4efHveexWGjLQcTonWvT+ve3cfmzA5IhgcSSfogts2OajAmtRD1tyNCu5WFnIxVazuCutWVww4Vg+mxygoCV+VOUUUmiyIpfeSKoyb66BzsLA3P+C2e4ACVlKE38h9AlOQSBm4+Jb+1hCQu0xTnCAXrCnwGjJNUTGVK4PVV81U+S2BybYzh00e7SRwud3u0YJK7qphIBCqjglKrTwdGeybk8xXRhFNDNroB7vjYDNTWTKvd1YZtjZel+i2oHAnp2GN5olnPqOL9C982BheGOIaMe+RI5gg4ZORvt35OAcU/DTFXPdD+9owzAEBs6TJzjcb9xbG2ZOV8Ng4JAMwJsUDuWemAMGcBgYvFzav4RxskS3KzWNrkLJSjeXQI1gOJJ5nvQjmAfI/g5nNQayIDmDmhgy8pTyeD4FGefHGMkrHArY8+XyWG5OQqPuEo1Q7o06nd1CajyVcKsxf2y76xTncog72GFZi99RiUn3q4I89iMsuq65oCO78+lCFxUkszBUIGF/1RM9IsKScVyVipLTC1fOaQWh94RVfEjXfSZzaA48+9udsneKoO73F1oF9CqbW3bSh4oTb6ygTPaAO+cev0qtlJOEw5+nYt
 per+XsZR
 W3synEW33tB6wN16st1aTbDuDRa0EI/8Swvc6O35p++VY8Bu0s3EEtL3/J1cDMEz1KTH6kqKruu3ymHY+Syr6WfwDrLYaLF2NSrgZb3Bx/RjbmfDWdspTJ8Qzb7tB9oyl+h8Z5YnOvEQz20BjGWx5s+P5+JoyldxlTGcS3uRX1gGg8X66ZA1a7GxC1IfKm6v7g7JO2kQOCFrAstFZT3CG0nJ88o/Fg0b0bXSwsEC3Lq9L37ybmn8K3Qc559OVIacvPKXuMQ9XSf0AuRmGi5B/vk+QXFwMznixMrWpin6Wfbo03LcMuhFwjTMzgcYHSVX1VkHX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 30 Mar 2026 17:16:51 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> > That could also work, but then set_write_prot_commit_flush_ptes (holy cow
> > what a long name) would definitely need inlining. And might be a little uglier
> > overall.
> 
> Right. The idea is that you __always__inline any code that has PTE
> loops, such that all loops for nr_pages == 1 gets optimized out.
> 
> We do that for zap and fork logic.
> 
> > 
> > This is the part where having data points other than my giga-fast-giga-powerful
> > zen5 could prove handy :/
> I just recently lost access to my reliably, well tunes, system ...
> 
> Is it just the following benchmark?
> 
> 	https://gist.github.com/heatd/1450d273005aba91fa5744f44dfcd933
> 
> ?
> 
> 
> I can easily extending
> 
> 	https://gitlab.com/davidhildenbrand/scratchspace/-/blob/main/pte-mapped-folio-benchmarks.c
> 
> to have an "mprotect" mode. I had that in the past bit discarded it.
> 
> Then, we can easily measure the effect on various folio sizes when
> mprotect'ing a larger memory area.
> 
> With order-0 we can then benchmark small folios exclusively.

It sounds like this is all possible future work?

We have Lorenzo's R-b on this [2/2].  I'm reading this discussion as
"upstream both"?

--- a/mm/mprotect.c~mm-mprotect-special-case-small-folios-when-applying-write-permissions
+++ a/mm/mprotect.c
@@ -103,7 +103,7 @@ bool can_change_pte_writable(struct vm_a
 	return can_change_shared_pte_writable(vma, pte);
 }
 
-static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
+static __always_inline int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
 				    pte_t pte, int max_nr_ptes, fpb_t flags)
 {
 	/* No underlying folio, so cannot batch */
@@ -117,9 +117,9 @@ static int mprotect_folio_pte_batch(stru
 }
 
 /* Set nr_ptes number of ptes, starting from idx */
-static void prot_commit_flush_ptes(struct vm_area_struct *vma, unsigned long addr,
-		pte_t *ptep, pte_t oldpte, pte_t ptent, int nr_ptes,
-		int idx, bool set_write, struct mmu_gather *tlb)
+static __always_inline void prot_commit_flush_ptes(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, pte_t oldpte, pte_t ptent,
+		int nr_ptes, int idx, bool set_write, struct mmu_gather *tlb)
 {
 	/*
 	 * Advance the position in the batch by idx; note that if idx > 0,
@@ -169,7 +169,7 @@ static int page_anon_exclusive_sub_batch
  * pte of the batch. Therefore, we must individually check all pages and
  * retrieve sub-batches.
  */
-static void commit_anon_folio_batch(struct vm_area_struct *vma,
+static __always_inline void commit_anon_folio_batch(struct vm_area_struct *vma,
 		struct folio *folio, struct page *first_page, unsigned long addr, pte_t *ptep,
 		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
 {
@@ -177,6 +177,13 @@ static void commit_anon_folio_batch(stru
 	int sub_batch_idx = 0;
 	int len;
 
+	/* Optimize for the common order-0 case. */
+	if (likely(nr_ptes == 1)) {
+		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, 1,
+				       0, PageAnonExclusive(first_page), tlb);
+		return;
+	}
+
 	while (nr_ptes) {
 		expected_anon_exclusive = PageAnonExclusive(first_page + sub_batch_idx);
 		len = page_anon_exclusive_sub_batch(sub_batch_idx, nr_ptes,
_


