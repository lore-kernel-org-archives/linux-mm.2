Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3523C5516E
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 19:26:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9012C6B007B; Thu, 30 Jul 2026 15:26:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B2626B008A; Thu, 30 Jul 2026 15:26:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C7A36B008C; Thu, 30 Jul 2026 15:26:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 558F86B007B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:26:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4A03940269
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 19:26:07 +0000 (UTC)
X-FDA: 85046423574.03.3280F66
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 262D54000A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 19:26:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=z63lMu7t;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785439565;
	b=VcWdKAoJUF7YBEAPCoEH0UY3tmNvHHOQEITX7h/Ru/VReFb9dwLYpiiSIpVR7qNN+AWsPa
	bIZysehxk0y4aG1rP5XHF/AWXTnyLA6KjIbYZudM1ThFnV28EOza8GgV6jeGbGFKFVkGlJ
	xIK2cwr15nxzwk9HGL67KgtNYncO7G8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=z63lMu7t;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785439565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Mu63+TXTdPWbpzCzG/liNanm6XyD5XCxB88149EcWI=;
	b=JTYdbL/ouRX78h4/dhaaWJwYH7R3TL4DxgjrZz/ocUD1thIQDXRgd7lS7Yhtt9OpCMA4QT
	SZLJ/1fzKo3FNfoyab+9Bv/+vDwvqY7kD4LlUEO7A5jsPx3bdrNIAHhhEXlzlVEfVZE91P
	IvTWIvqg+0qvI5B8xOLP4nePlvcN4cw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 10B6D40314;
	Thu, 30 Jul 2026 19:26:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683381F000E9;
	Thu, 30 Jul 2026 19:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785439563;
	bh=9Mu63+TXTdPWbpzCzG/liNanm6XyD5XCxB88149EcWI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=z63lMu7tXWHGvvdGZKjWKifKRdW6gtCoUrnoLT/EC62tESOltxEo37cabBtOFu4IG
	 hqGqFehBnJSJADqtX/yMkcBMcM22ARhPfWGd83T11G8LHKfDpOSgODfLPGbwbNDljJ
	 mWG1UG68d0gjKJWkUO8qkQ5RfDTYP7Ge7WOMAzQE=
Date: Thu, 30 Jul 2026 12:26:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dev Jain <dev.jain@arm.com>
Cc: david@kernel.org, ljs@kernel.org, muchun.song@linux.dev,
 osalvador@suse.de, riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
Subject: Re: [PATCH v4 0/5] mm/rmap: Refactor try_to_unmap_one
Message-Id: <20260730122602.587dc6cfea1859059e29ac6c@linux-foundation.org>
In-Reply-To: <20260730094559.418003-1-dev.jain@arm.com>
References: <20260730094559.418003-1-dev.jain@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 262D54000A
X-Stat-Signature: 1r7m5jqu1tpxcy55h9jqepiz6th8pz6m
X-Rspam-User: 
X-HE-Tag: 1785439564-606725
X-HE-Meta: U2FsdGVkX1/NM7phA5uAwFwcOU/bby7JE0SaJvBbrhzyR9GkCa67vh7uLNPReHne12PLVP0aMkG48K9El8LuOzPN8D59dOMm6ltbHReQpRZ/8JGGsIaxH8CmUfyVglM2jGgfGAE2GZrTslrluhtdjC7odLmb/idmS7iPcw4bgZL7hR1GoD+3WRRcOcRx+RMgHTq9OFZEkQmc8tzwk8gUpnWzHle4F2PMWhYbKjo4flbzhAOXWsVHx2tgqwjHM/1IAteu6TbzEqtCDcGQcKFzcChVdROtjlD0bsCCx1FfDsTG4EWGRu+ubMqEjVzE5MlMmQF2+KfJtfMJSAlzHGX5UWkEFCK7nwHgEMqf1otaPIcCzfQZg+3BOWG6ts5qRm+KVn/3c6XNRE3IAShs0DzOSCUHSWntCvCtQDhZx+GngwhhZE7D5VaAsVos1Yg5jJ6OWKISdRxDEgrUluY6cgjU87MkxjjdMcQcahNL7TaqvMRHOlOcpodB4HqvONukFvjMC0R0KdO7oCMOBMlqySvyRW03N9IbhoosynZeyqEjDsskEIR8HcHFbG/QVjBSslOPqvZstrpk6YKYMxeZcxvY2CAlrcGKHicjGYr0vveyo7p5Qbd4UhEpElbx/JFZo5z8ezD0zR4oWfT2g+NMzjHgqsnqpHAKaqWbsc0zrNMnXOcb1FEkdzFHMxJs6WdDekZkhzzFZc8u4b9bpOzjGMioLjmgdEDq14VlnvffjlIrEcGmtKYbrE29P4eGbgKO5aUWzymOk+2SEqLrNfH3puy824Sw9zBGpskLGvSAS/I0cQ7QHUvSG5wN0zOeBsVF5W67zlGUe4ovx7TxOUGt0hAj5+wk+gnCM60s6O4bm6gtn/4vMXFHeJYL1ebBHfXVLOs3xtshugknY6st8vAyUEGC9yvsxDLFmafOAt9JD6qZcJ47G42nq7VrBOmhyNr7dt4MEf2OhiJYKF+T684w+wf
 Ns6GlFGd
 D+hTQHTPVK/sJ5wcRh/aTnF1+sbGqYoDwadqPzDAF//yPZlPN2kJulBiFI1gY14p3B7mwI/OATgfeq25teSHPAa2iZXr1zYo0rb4XUYefvmmvfGTSItp9cv6qSQsZPfXTCK9kXWBgSPB6adm7QVBQjSCg1gVKd0aoE8bcTcSmGJjlh7qeuBl9F23plBW6Lua/k19g7opoNWNyU6tcnnI9xIYqrJvpafYgnR372+eBfKtUD0PYme2/ZVbvbzEr6tkZp4sdRy2VCXdpNSMKy/HSYyM6ZmbMG/9176lo1BiMJiJ+5vnQcQhtWelIO03BBh+NaJb5UVTh/AOultQSIE6couSN0d16t4N6t3deDQqm4RrdZdA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Jul 2026 09:45:51 +0000 Dev Jain <dev.jain@arm.com> wrote:

> In preparation for batching anonymous large folio unmapping to optimize it,
> refactor try_to_unmap_one. This series refactors hugetlb, anon-lazyfree
> and anon-swapbacked logic into their own functions, significantly
> reducing the length of the huge try_to_unmap_one.
> 

Thanks, updated.

> 
> v3->v4:
>  - Tighten comment around TTU_HWPOISON
>  - try_to_unmap_hugetlb_one -> try_to_unmap_poisoned_hugetlb_one
>  - VM_WARN_ON -> VM_WARN_ON_ONCE

Here's how v4 altered mm.git:


 mm/rmap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/rmap.c~b
+++ a/mm/rmap.c
@@ -1978,7 +1978,7 @@ static inline unsigned int folio_unmap_p
 				     FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY);
 }
 
-static bool try_to_unmap_hugetlb_one(struct folio *folio,
+static bool try_to_unmap_poisoned_hugetlb_one(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long address, void *arg)
 {
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
@@ -1993,7 +1993,7 @@ static bool try_to_unmap_hugetlb_one(str
 	 * The try_to_unmap() is only passed a hugetlb folio in the case
 	 * where the hugetlb folio is poisoned.
 	 */
-	VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_hwpoison(folio), folio);
 	VM_WARN_ON_ONCE(!(flags & TTU_HWPOISON));
 
 	range.end = vma_address_end(&pvmw);
@@ -2031,7 +2031,7 @@ static bool try_to_unmap_hugetlb_one(str
 	if (!folio_test_anon(folio)) {
 		struct mmu_gather tlb;
 
-		VM_WARN_ON(!(flags & TTU_RMAP_LOCKED));
+		VM_WARN_ON_ONCE(!(flags & TTU_RMAP_LOCKED));
 		if (!hugetlb_vma_trylock_write(vma)) {
 			ret = false;
 			goto walk_done;
@@ -2350,7 +2350,7 @@ static bool try_to_unmap_one(struct foli
 		/* Update high watermark before we lower rss */
 		update_hiwater_rss(mm);
 
-		/* With TTU_HWPOISON, we only expect small folios here. */
+		/* unmap_poisoned_folio() only refs order-0 folios */
 		if (folio_test_hwpoison(folio) && (flags & TTU_HWPOISON)) {
 			pteval = swp_entry_to_pte(make_hwpoison_entry(page));
 			dec_mm_counter(mm, mm_counter(folio));
@@ -2440,7 +2440,7 @@ void try_to_unmap(struct folio *folio, e
 {
 	struct rmap_walk_control rwc = {
 		.rmap_one = folio_test_hugetlb(folio) ?
-				try_to_unmap_hugetlb_one : try_to_unmap_one,
+				try_to_unmap_poisoned_hugetlb_one : try_to_unmap_one,
 		.arg = (void *)flags,
 		.done = folio_not_mapped,
 		.anon_lock = folio_lock_anon_vma_read,
_


