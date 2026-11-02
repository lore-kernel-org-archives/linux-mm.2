Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7D46606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 12:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BPDBYnRq
Received: by kanga.kvack.org (Postfix)
	id 13F536B05B9; Mon,  2 Nov 2026 07:55:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1185E6B05BA; Mon,  2 Nov 2026 07:55:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02DEE6B05BB; Mon,  2 Nov 2026 07:55:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C5A5A6B05B9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:55:39 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 653D6120CAE
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:55:39 +0000 (UTC)
X-FDA: 85390175598.04.A827BFD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id D3D6AC0004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:55:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BPDBYnRq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793624137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zK+jduPgyuYhoGFDTvKP1KlaDNql1X030u3qNAXE0zA=;
	b=mdqNJ2T4Eqo51j67S17qrChjumcHNePcfjvDAMWHS1Ooo686lK2XcWiOhtqgmj2YyfkCBU
	za4AS3qIQj24p2yWPiI+m6EOIkg56oidP/D5HXoAvAX7FN3N/1o6Rr9ef5JLq/s+v/fyWe
	XX2+JiqjqJ259TDlbBybLEgB8UrDU34=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BPDBYnRq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793624137;
	b=YQrtjPJuOZ0cyb7IHGL2BX/relaRvPaP/VHlMiPobHg0ZVfQp9sLk7KZ23kDgPDd7vJewR
	/NDC+YWi7fi9gaucwUjuDDwjhK+XMx1EWqJVg+heSMxTjk/NowYT/lLRPn+vGQUNNr3EC/
	9YlMvbbThrVEMNjmFQIQV8Kx13gg/Ik=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C031602C5;
	Mon,  2 Nov 2026 12:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C40F1F00A16;
	Mon,  2 Nov 2026 12:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793624137;
	bh=zK+jduPgyuYhoGFDTvKP1KlaDNql1X030u3qNAXE0zA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BPDBYnRqf0o0UbbvkaWjK97ToRo8QnnXDa+oV8kdzXiCvIH7BgZt+sLXxnFlLUdjZ
	 J1F/CHVDxjRLimLNxrAWVrOh+nqoRouG4O0tzipJeliYcGEskLHhMIs7bFOu/L5tuP
	 7Pp6SIH5pz5saLv9Oj7r6iTI2kZ/hAgzJrjWklPAMsyYiyM3ycETTZ00kt+kT7gvOe
	 K0QkjvZtKKTJHqMns9+OZ4q9CxX9Hf8Y5eCTxEgSFFUOLQuvNjmgwfviDp/o6Im8e0
	 7JrSYh2G6i9P2XngglE6HoaquaVBaZNaasYaAy0b178ZNHSoaYW9W+GpFXFjSk6KAY
	 /hmvLLaTVyuyg==
Date: Mon, 2 Nov 2026 12:55:32 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Zhao Gongyi <zhaogongyi@bytedance.com>
Subject: Re: [PATCH] mm/ksm: avoid unsafe anon rmap dereference in KSM merge
Message-ID: <auiHNPkbB0p7-2GI@gremlin>
References: <20261102-ksm-anon-rmap-fix-v1-1-68962acfb59b@kernel.org>
 <54e20549-ca49-4d86-90fd-9f5e483d362d@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54e20549-ca49-4d86-90fd-9f5e483d362d@kernel.org>
X-Rspamd-Queue-Id: D3D6AC0004
X-Stat-Signature: wxa1r43yps49dsapwn5ppk9611upjpfw
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793624137-517454
X-HE-Meta: U2FsdGVkX1/Rmr2P/pdVkaxSO+SeA1VQNU41RF2wAG3M7qmdimD/OuL04xgZ0alqnrGWhB74YA5IP2usC+PtN9WH/iZsUzV7CNkvdZfvi01nbTLhbQUgS7+cWKxG5cVaD/18QA2sRZYzSozuN1wyA6j07GO+TRew6NQWr9xK6gcu1fRtkRbFla7+6hy/VowKJ92rctBmVBfhAZfLdf0Rhg3Z5r6bCYfCtzNyjLMbQjcBXujRTjtymjC2ZtfyXCbP/TKkc9p2vHIc6X3GPZgSygB8ETn5nhQEDLdO9kJXAfGgGO+G8RzKpEyHGWuX4AriZ8dhZxsc2jHiy4M+0ZJw3yjf3giPV0zaCiMPp1jtjV3/PnX3Wa4sPQ3BgboukeS5iTOt+5ZvQ9lGnKNmW5qKqnsT0MZj9sOeLtJBvjgjSEW3lWXtGUi+Upm1aUrukvlY3cT+x42Sn6ae93TY/KYRm87vU2oivJcolnEXhu3qzusLQqd1ab5Ppph+YEFMsSGr3nfVlRt5rl3v2M/XH6M/cffgtHW6mumMyassnN2wC8FnA3oA9gbrMjemPl1aINwMGK5iglCWFhoeLX+PPx6jIZSg0pwcxo3nGejbhKdzBeV9ToYC3C8SjuYl9NW9WDMMoQ1rIzHnyKOXS1ppvqQA0qixFs+zERRW2xlECOPp+rv8w42/FauvTFGWilgVPnfYiPkywu2wvFOHxcoFBPQmAiSIBz97NgGhsNsuWyqnaFVbR56VOU24t+HlVTQhc7MKOtvtYcuJK68yO5X1gQC2+1m0fFmP/qRZtpRSHc+ZF3BG7lDB1auAnbd/waAiHskSDGAOoDMbJfmhnbVM5E4d47atE3Qhzrv4uOlmCuOBkkd7GYZfpcHRJaJ/Et6HNqgnNsltGX1yBX8g+Jg+uVDg5o4qGiq++R78MILGUu4t7exOgV7hzFsjkmwCxyQxsZRpiaq+Dn7JcXuFTFycil0
 1WuFXjRC
 QrgFW09OZ3q3d7EwgVK1S38lsW+M8bkvAnEhYD3B3ywz/396xR0kpn9P7Kx91ztWHVMEZGLDBftamylQSbp2QdGszUjjQSG7VAi6mGGOOtu6InGcMh1si2PZ0poYMEDcp96Mc0SgbqH+Ag8SnGSjKaOCNX5Arh+iwZ1F/YUIX9+t4vj5MOZ00dl2UC6NN7zhZQcNo2GE1BWWpMfyvL/XY4+F4xqrTcvczK0Wi8PjJANCJu+3MvNLA/bsWUpbi1FrCWsEPBb882/sQ5xJtIf4JjHM6RiruqOy3G/MNDY+l2IsXiuw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 01:49:02PM +0100, David Hildenbrand (Arm) wrote:
> On 11/2/26 13:32, Lorenzo Stoakes (ARM) wrote:
> > When KSM examines candidate VMAs in scan_get_next_rmap_item(), it
> > accumulates (mm, address) pairs in ksm_rmap_item objects, assigning them
> > via get_next_rmap_item(), pinning folios via a page walk in
> > ksm_next_page_pmd_entry().
> >
> > Throughout this operation, scan_get_next_rmap_item() holds mmap read lock,
> > which it drops afterwards.
> >
> > After the mmap lock is dropped the VMAs might be freed and remapped where
> > the VMA belonging to the folio was previously mapped.
> >
> > mremap()'s ability to change where anon folios are mapped is dealt with by
> > KSM by essentially avoiding the problem - prep_move_vma() unshares KSM
> > folios, and the scanning logic is tolerant of concurrent remaps, discarding
> > stale ksm_rmap_item objects and allocating new ones at the new address.
> >
> > This doesn't account for a new VMA being mapped over an old one where a
> > folio was previously mapped, so KSM accounts for this by checking things at
> > the page table level.
> >
> > However, once an anon_vma's reference count reaches zero, it is freed, but
> > nothing clears folio->mapping, which is where the KSM pin interacts badly
> > with the current KSM implementation.
> >
> > page_address_in_vma() is consistently used to look up the folio's address,
> > but page_address_in_vma() explicitly states:
> >
> > "It is the caller's responsibility to check the page is actually within the
> > VMA."
> >
> > And KSM violates this, as it cannot know this to be true. This results in
> > this function performing a use-after-free:
> >
> > 		struct anon_vma *anon_vma = folio_anon_vma(folio);
> >
> > 		...
> >
> > 		if (!vma_has_anon_rmap(vma) || !anon_vma ||
> > 		    vma->anon_vma->root != anon_vma->root)
> > 			return -EFAULT;
> >
> > As anon_vma->root is dereferenced when anon_vma can already have been
> > freed.
> >
> > This is currently benign in practice, as anon_vma's are slab-allocated
> > objects so this will always be within the direct mapping and arbitrary
> > memory will be treated as if it were a pointer to be compared.
> >
> > This either results in an -EFAULT or a spurious match, which will be
> > rejected at the page table level.
> >
> > However we mustn't UAF even if it's harmless, and KASAN rightly flags this.
> >
> > It turns out we don't even need to use page_address_in_vma() as we already
> > know the folio's address, it simply needs to be passed through.
> >
> > This change therefore updates KSM to do this, sidestepping the issue
> > altogether.
> >
> > Explicitly check for KSM folios in try_to_merge_one_page(), which are
> > already merged, and by definition never have an anon_vma.
> >
> > This was previously handled implicitly by page_address_in_vma() as
> > folio_anon_vma() returns NULL for those.
> >
> > In many cases cmp_and_merge_page() will reject these, but it's possible for
> > KSM folios to fall into the unstable tree there, so eliminate that
> > possibility by checking for that early.
> >
> > This maintains existing behaviour.
> >
> > The bug was introduced by commit 21d0d443cdc1 ("rmap: resurrect
> > page_address_in_vma anon_vma check") which first dereferenced
> > folio->mapping unsafely, but commit b8c8ba73c68b ("slub: Introduce
> > CONFIG_SLUB_RCU_DEBUG") made it visible with CONFIG_SLUB_RCU_DEBUG enabled.
> >
> > Fixes: 21d0d443cdc1 ("rmap: resurrect page_address_in_vma anon_vma check")
> > Reported-by: Zhao Gongyi <zhaogongyi@bytedance.com>
> > Closes: https://lore.kernel.org/all/20261031182256.40205-1-zhaogongyi@bytedance.com/
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> > David - this seems benign in practice, so I'm not sure whether a backport
> > is required here.
>
> Ok, thanks. Is there a similar problem as with the other anon_vma->root issue
> where a false positive match could be problematic?
>
> I suspect not.

No, as it checks stuff at the page table level later.

>
> In that case I would pick this for the next merge window after a couple of days.

Yup, this is far from urgent.

>
> [...]
>
> >  {
> >  	struct folio *folio = page_folio(page);
> >  	pte_t orig_pte = __pte(0);
> > @@ -1515,7 +1507,7 @@ static int try_to_merge_one_page(struct vm_area_struct *vma,
> >  	if (page == kpage)			/* ksm page forked */
> >  		return 0;
> >
> > -	if (!folio_test_anon(folio))
> > +	if (!folio_test_anon(folio) || folio_test_ksm(folio))
> >  		goto out;
> Okay, that makes sense. We don't have to check under the folio lock as KSM
> doesn't merge concurrently.
>
> Do we want to assert in write_protect_page() that we are not getting called with
> a KSM folio, similar to what we do with large folios in there?

Sure could do. I wonder whether that existing check should just be a
VM_WARN_ON_ONCE() anyway, seems a bit silly to if (WARN_ON_ONCE(...)) return
err; there.

Do you want a respin for that or happy to add?

--
Cheers, Lorenzo

