Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9D90CD98D2
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 09:55:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09F706B0092; Sun, 14 Jun 2026 05:55:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0290C6B0093; Sun, 14 Jun 2026 05:55:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E33746B0095; Sun, 14 Jun 2026 05:55:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE09C6B0092
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 05:55:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 78CBC1C3CF8
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 09:55:22 +0000 (UTC)
X-FDA: 84878060484.06.3BE8C23
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id CCB59140002
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 09:55:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P70k8Eds;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781430920;
	b=frlfe/2eqwEG9EBT+7zTaTNg8ivbtKX2p93XzLzgFGBu1sy5HbHLksdXcPzIgot5U3WWPa
	cAkMggdu0Kxy4rkHl+72Qaq04A31LCwbHAEwA7NJorI6Pc76sQzbN74Ae3IntEPPLFTkso
	YIMTg7IH0R00pQ4sm7AZGvXW8XYKQvA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P70k8Eds;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781430920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l+rYKnQxSik6h20p9v/FXlfKzLNE3EJSxpZIHMtaCF8=;
	b=sx5HrtIZzS8Za1qMfAYdK0Hk34djvJLvTZL2X8Li6jzMc4Kvzwk3aVy4xondQmWwSVU+43
	mQPjE62+1+CRlAXn3E1CPwfIYWLnttIYfjs4uqeYgv2l+SI/eb8awSpECsTyKh+GpqEk64
	1cNHEHmeAaWlyIiTFDh2KpMXhT73SxE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1B5816008A;
	Sun, 14 Jun 2026 09:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55211F000E9;
	Sun, 14 Jun 2026 09:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781430919;
	bh=l+rYKnQxSik6h20p9v/FXlfKzLNE3EJSxpZIHMtaCF8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P70k8Edshz2WvKYbe98e+4xLaHZggUaZdsdYpyRf3z41TpiGJEgcwxn42JUi9MOZ4
	 wbbxm7AQkQw5Yu8ryL7XbUtPFNnrnlYtSC//PnfMNJ9UwUuJ8lVCtqHA4HVQZRocvc
	 obPyuILakMsOZLjjgL7dbVLjrT8t3xFBZrb+tdl/eviRDBI84WhRs/eLjuT0n93XD5
	 7lwLh5RTs2QTcPZN4KeNOoBFM5f7zKS3ubJSWxBWlphEjJMC7kuKt1v1Nx7lXmzVY2
	 zHTUJ3mg1alCBZGJ/rhPEFvXmjVkMUbjvLfP57yOnTiAjivMFltddHWoFk5RO58JYW
	 C1RHQPavfL2Ig==
Date: Sun, 14 Jun 2026 12:55:11 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org, rppt@kernel.org
Subject: Re: [PATCH v3 14/19] mm/hugetlb: Free cross-zone bootmem gigantic
 pages after allocation
Message-ID: <ai56f5AxGJQ5SiGp@kernel.org>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
 <20260602101039.1867613-15-songmuchun@bytedance.com>
 <178041489395.457517.12727427621570734471.b4-review@b4>
 <1ABCD934-CA2C-4541-9B76-32FAEFD398FF@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ABCD934-CA2C-4541-9B76-32FAEFD398FF@linux.dev>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CCB59140002
X-Rspam-User: 
X-Stat-Signature: ug18aoc9cwk8qf6dkrjxuq3y1in47wrz
X-HE-Tag: 1781430920-66477
X-HE-Meta: U2FsdGVkX1+rzK+nmhTkLYcajLbIzKMxFZGmjbsatZP7FxZWKR2GTEPp7ZqPyS+j2KP6BtCGFTCUqab/AbYScJe6Y/jBrd3Q2ygSb3wDFPV+fllQB6XEhVWlNeUk6jyS7AwcBI8zb18WLrYkvS76T4AKiCPC3V9sr+jDx2s3a7wWSNxeFmV10AGmsrToj+P/VRnvjrOXWqPAFYFWITtRZXQ2ELYvzztXafFIFSH/B+o0wqO0CmxDY6Ts8IUeCzWU506BZGJIyPULe7p5j0TGUldCDKk0s9bWeJL9qTmqyDCmhntrN1DTk4iJUAJeAmX0GfLIFnrg0gZog+W7mi6A0uiBM30eSL1clGVfo1x9BiVL+x4pDcGx36Va60xyVY3LyxQPx48Ux63Xyhjq5czhz5JIDvmWV//tIAWX3Ef83TVoP4qCzjHt2J1FFMtrImJa01qjgPwYbqNr3RuXFvrc75rHUCIJN/2PwjTAIDeTeU9SZdQMCf5nYYc2dP4K9+jkTxiD5oYF12IvJ5cW3jCCk6FA6Etg1gn1QWUgls1J5klLs5u5lHY7eVWe7has0rGLL7u1pGDH8H16klZ+6Hh3KobbhAXaCEX5r2ebgPABJFE8YUnZQa7dh9XQ9taOIJXKpted3aBkB84/gBWBeojCLhyzDHr8DGzucDGkYryvfpKda2E0IAE7yC6FDjzjbYM7k5Jw2lb17kxOxXWF5/JWyPSx/bTzi+PxZqSnJrd1N0aeF6FCK+O0UMGLgpmlckMjfXehMvrJcivDyuK+tkBG3o++j2P7epplQzLIWdvi48y3P9KU0dp1h2u/hDkjFfSwMavfuCwFpbV1Nnj2CRu8cOW22naeryiQjt+cSzI3Av6i299UTrueTixSI6JciRn/kLhocU88JaYosjzxFPCdpsyHvAT3g+LKeDkFssckqlqIhjs6QD4oYYZbxPsVQ/6Vv+7IAieY864iC6+HbyQ
 EIJ4ywmN
 q+nvVECa9TMFnPIIgKv+7lzFCqoyrqKsK0UH0EArDW//24inDCBs8u0Q43Scx40G58I5Px/354ARkKxkiIizswb+asy9y19gQwB3sOHw3TiW0I30fjG3cD2Wc3x4tI1I9tvRyDmNSwd4Skuk8Tt40CZP75fGAf+s9zrJSm1bm1x66WRdxgGkrkBA9J+avRvGO+PDa8ePgTQ7PFxeElzTkq9fu+q1Zr9X5VnEFYtH0SX42+13CU3afHG8kwwdAGmMB4sRGQUrhiyYFpxUpgx/+pCcyxtiKiPc3BlxZ+9K8rDlZXBLDnCNxrXHx1ozaOmQBAQqCs/hryDJC/ShjTKK7xJfA0W/I2T8MVNaA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 10:53:04AM +0800, Muchun Song wrote:
> > On Tue, 02 Jun 2026 18:10:34 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> >> 
> >> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> >> index 5e557c05d80a..218fb1ca45f4 100644
> >> --- a/mm/hugetlb.c
> >> +++ b/mm/hugetlb.c
> >> @@ -3073,22 +3076,38 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
> >> [ ... skip 26 lines ... ]
> >> + 	* pages belonging to the requested node.
> >> + 	*/
> >> + 	if (WARN_ON_ONCE(nid_request != NUMA_NO_NODE && nid != nid_request))
> >> + 		list_add(&m->list, &huge_boot_pages[nid_request]);
> >> + 	else
> >> + 		list_add(&m->list, &huge_boot_pages[nid]);
> > 
> > Can we just memblock_free() the page that intersects zones here?
> 
> I had previously considered doing this, but then I realized that if we free the
> allocated cross-zone memory here, memblock is very likely to select the exact
> same block for the next allocation. This means we'd just end up with this
> cross-zone memory again, degrading allocation efficiency. Unless there is a way
> to mark the block so memblock avoids reallocating it, I ultimately chose to
> defer the release to prevent this issue from happening.

You are right, there's no simple way to avoid memblock using the same
range.

The comment at hugetlb_hstate_alloc_pages() hints that we might want to
split allocation of gigantic pages to be more explicit as a followup
rework and then freeing of cross-zone pages would be cleaner as well.
 
> Thanks.

-- 
Sincerely yours,
Mike.

