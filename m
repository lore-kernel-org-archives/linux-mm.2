Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2902FEF9008
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 17:02:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75A1C6B008C; Wed,  4 Mar 2026 12:02:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 732996B0093; Wed,  4 Mar 2026 12:02:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 614B46B0095; Wed,  4 Mar 2026 12:02:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C5226B008C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 12:02:38 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F07EF1403FD
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:02:37 +0000 (UTC)
X-FDA: 84508999554.08.8FFC445
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1B1DD1A0002
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:02:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="XR/Qffzq";
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772643756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ta0CBo4iJBYO40FFYgP26GVcbBBIKRmW4rgVFJyftec=;
	b=ufPCV9aPo1jZrP+NmeaGYU5u52CRKUK8L6xgb34UJTxG1RpVD7CbhB1sUo9KqLSLgYpno8
	GgpgXLI5SeAhTE/8V/nPoVYRZtHShaUTW7UUG7pBtpgf2565k+zbgZu1cB3K2CxdBmvsSo
	QOKjfwEXu1AvGudK/ixeMF1R3wKCi7o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="XR/Qffzq";
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772643756; a=rsa-sha256;
	cv=none;
	b=0YP9XLUtaE+qzIFZ46FJWzIF/KKxZ8Sa/H1NQoNkE974HzSoM0ljJUT1dcltJgZq3fqBEV
	7BQvHcaTcuBcrMw9CXx6mKyOYFz3VuQfj2Q1b6/8I+NbbYMQUqoulMX/BioQvZsa6Ge9Vi
	217LNJnjA0jBD1u8COVOpITvEHcd89g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A5654327F;
	Wed,  4 Mar 2026 17:02:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787B2C4CEF7;
	Wed,  4 Mar 2026 17:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772643754;
	bh=m52ZlSB16l1sLAs0GvnmebShviEQjPH+XrVdZ+Tj2/o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XR/QffzqaNsadKYUM0M0H2KGBs+YLtG/NezPuj0ufogN8pVQPQkQXll4U28D/nkDl
	 EsO/NnV6AN+favd5xS/cE6WiJgY0kXurlUmwXnUoiIfcgBhS6v/cIeFU7d9oe8QT+4
	 d5sQjJ5wUuY+tW8Zwq7sLHeA+igaX8k2Vc/U6yV03rw2bk8ILWbYzgtmDf9hHfS9fp
	 drLDFP0ejddUV6/mF/8xj4usnlUnuZ9mc1dkx8A3Nq0zHLL47i8Gwqyxxf2EdcS+sV
	 wV1+n6Zk7PFrXNGdhOBqvms3PodOGnxPT2YWthXUX4QS7Ewf/SQBdMfs5i1znxAq2o
	 Cc07RtBp7V2DQ==
Date: Wed, 4 Mar 2026 17:02:31 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	akpm@linux-foundation.org, david@kernel.org, riel@surriel.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, harry.yoo@oracle.com, jannh@google.com, gavinguo@igalia.com, 
	baolin.wang@linux.alibaba.com, ziy@nvidia.com, linux-mm@kvack.org, 
	Lance Yang <lance.yang@linux.dev>, stable@vger.kernel.org
Subject: Re: [Patch v3] mm/huge_memory: fix early failure try_to_migrate()
 when split huge pmd for shared thp
Message-ID: <96fb9100-8a19-4461-a14d-c7777b7d04ef@lucifer.local>
References: <20260205033113.30724-1-richard.weiyang@gmail.com>
 <fbd6c31f-7f35-4986-86e3-76bf8963433d@lucifer.local>
 <20260210032304.j4k5izweewouabqb@master>
 <20260213132027.wm75sh6trz7n24kd@master>
 <c820d6a1-4283-46a5-a639-04f6849e4e73@lucifer.local>
 <20260304010828.ulp5i3v2drwhzytc@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304010828.ulp5i3v2drwhzytc@master>
X-Rspamd-Queue-Id: 1B1DD1A0002
X-Stat-Signature: mqdt9b5jp3je5x38papojxjj97ptouak
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772643755-391537
X-HE-Meta: U2FsdGVkX18gtvXhoK53cFKMioLI6R2n7B1RNHbKSMD7JV3+89nCYCN8UGyPapcOYLvovS3GHZWUe/W7XyJTjaiW1IH4Fh/ztb0WZyMjyP7gOMjjTeQI+PDoFtCX/Rf4Tcg6x28mP4CpZVYUgLlrS6FNH2DddG4whksyU+BVCl/g+cZk4OUK1jGbhZF2CzJuHh/HGziO8oSY1xlwODDICsTdt0PxtOpxPIxfGyStr0z7kZs/Fy9WHqHtkMOcswi+pz0O923ei1Svwr70j8dtKrHstyuyEQuvSh0vlErbtk7yg4fxjZEEufcF6M1ZqCCyDtViCxA/L3Up2zTIt1vN8VPKPQRQnfCBIUTAyhviwenWZDSAhcoKVTLu+jbTglWZVIanJRUn7VVQvxytYgCrJGo+VmrCs7aG1s49f3s5ocbmtgLMODiDIks1FgzBkdmP9q0DJ0y1onFxfu0KTXFRWpNuB41bJZcE7TOxEflUV9kmENBj1BD9k02gle4X0XdaoR2xxCvEZGrbd01z29gtKMImx0bT4kvL8BEPAL1WIg7RBmolRdggPMFzMaLo9jvri1yUBM0mYbUniVnFuQR31Gf4bb4xaIkV2mPwpUEcciJXEnWpOUJaNWYi5eV+HF/xLD9D5KhmUZapbEosDNL7pP+OSSk17PvylRiSyjwqeTkC4HBA2kqFBHRvks4Ba6pqSZ390HDL2EAfT9wGJceGDAO0eMXw7l9G/wIYBuq6zTah19qBoIug4XnRJLBIspGzJbb62922YgBiuVsSbbTk5HVkP15GmpuxAIc4guc7aG14mnpU+8CMfvaBF0SiHw1mTjvuFIGDpanavJR447Xz+qxZMGkubo8LkoTk3Kut1igEKcV6RAyPUdnIQf5VIVhrD0tkhUka3ihER43JGRIXqLqekuIq4feJ1KH81iXZYNXTgxDA3RS31pfyrHISgyHFSipff/EyyIkfWuo3nev
 qq/TtEdo
 2pmERE0fUdGNFk98lNDEeaoId9jJ6iqWilKDGXWItdi8qy9VDJk1GaG0JvEkELKR7Nfg8X66bQZuzZdmjjds+HLgdU6dXZ7rSFGTW9Dz1JBVRfMBjfub5qOHJRZDBLLb0QL195gXmsjq1+EGceOzIIWn3V58nJcri7hQyhrpRfmuQcxSr1Ity+QigtFsiLF+weotvZ1xqCCS0vrxE4KT/z05eKMdO/HA/B8yux8pzprxXTOmzQ8j5zqGnMf1zDIWV5sHs9RsbCRmXf1zhYO9AcPOOjd5S2R5x6XP6OMZc4qH9KJBIPCKJxwdqM5LVHERXDG//A9Y/YWzoH+Ew2/juFW7B6N9K6j170LIUDKYZY16pKIoyBtp9KGD/5shZ2ktDfHaKShKaKTzY9MSTiReOXaxz05//BUjmoXGZDooL3kBQo6FO/o6BBlMSMxMOHDJGJQaPiKHBi8asZcdSegL6tGipZXMtPqoFujGaFkbw8w7mBGw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 01:08:28AM +0000, Wei Yang wrote:
> On Tue, Mar 03, 2026 at 10:12:35AM +0000, Lorenzo Stoakes wrote:
> >On Fri, Feb 13, 2026 at 01:20:27PM +0000, Wei Yang wrote:
> >> On Tue, Feb 10, 2026 at 03:23:04AM +0000, Wei Yang wrote:
> >> >On Mon, Feb 09, 2026 at 05:08:16PM +0000, Lorenzo Stoakes wrote:
> >> >>On Thu, Feb 05, 2026 at 03:31:13AM +0000, Wei Yang wrote:
> >> >>> Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and
> >> >>> split_huge_pmd_locked()") return false unconditionally after
> >> >>> split_huge_pmd_locked() which may fail early during try_to_migrate() for
> >> >>> shared thp. This will lead to unexpected folio split failure.
> >> >>
> >> >>I think this could be put more clearly. 'When splitting a PMD THP migration
> >> >>entry in try_to_migrate_one() in a rmap walk invoked by try_to_migrate() when
> >> >
> >> >split_huge_pmd_locked() could split a PMD THP migration entry, but here we
> >> >expect a PMD THP normal entry.
> >> >
> >> >>TTU_SPLIT_HUGE_PMD is specified.' or something like that.
> >> >>
> >> >>>
> >> >>> One way to reproduce:
> >> >>>
> >> >>>     Create an anonymous thp range and fork 512 children, so we have a
> >> >>>     thp shared mapped in 513 processes. Then trigger folio split with
> >> >>>     /sys/kernel/debug/split_huge_pages debugfs to split the thp folio to
> >> >>>     order 0.
> >> >>
> >> >>I think you should explain the issue before the repro. This is just confusing
> >> >>things. Mention the repro _afterwards_.
> >> >>
> >> >
> >> >OK, will move afterwards.
> >> >
> >> >>>
> >> >>> Without the above commit, we can successfully split to order 0.
> >> >>> With the above commit, the folio is still a large folio.
> >> >>>
> >> >>> The reason is the above commit return false after split pmd
> >> >>
> >> >>This sentence doesn't really make sense. Returns false where? And under what
> >> >>circumstances?
> >> >>
> >> >>I'm having to look through 60fbb14396d5 to understand this which isn't a good
> >> >>sign.
> >> >>
> >> >>'This patch adjusted try_to_migrate_one() to, when a PMD-mapped THP migration
> >> >
> >> >I am afraid the original intention of commit 60fbb14396d5 is not just for
> >> >migration entry.
> >> >
> >> >>entry is found, and TTU_SPLIT_HUGE_PMD is specified (for example, via
> >> >>unmap_folio()), exit the walk and return false unconditionally'.
> >> >>
> >> >>> unconditionally in the first process and break try_to_migrate().
> >> >>>
> >> >>> On memory pressure or failure, we would try to reclaim unused memory or
> >> >>> limit bad memory after folio split. If failed to split it, we will leave
> >> >>
> >> >>Limit bad memory? What does that mean? Also should be If '_we_' or '_it_' or
> >> >>something like that.
> >> >>
> >> >
> >> >What I want to mean is in memory_failure() we use try_to_split_thp_page() and
> >> >the PG_has_hwpoisoned bit is only set in the after-split folio contains
> >> >@split_at.
> >
> >I mean is this the case you're asserting in your repro or is it the only one in
> >which the issue can arise?
> >
> >You should make this clear with reference to the actual functions where this
> >happens in the commit msg.
> >
> >> >
> >> >>> some more memory unusable than expected.
> >> >>
> >> >>'We will leave some more memory unusable than expected' is super unclear.
> >> >>
> >> >>You mean we will fail to migrate THP entries at the PTE level?
> >> >>
> >> >
> >> >No.
> >> >
> >> >Hmm... I would like to clarify before continue.
> >> >
> >> >This fix is not to fix migration case. This is to fix folio split for a shared
> >> >mapped PMD THP. Current folio split leverage migration entry during split
> >> >anonymous folio. So the action here is not to migrate it.
> >> >
> >> >I am a little lost here.
> >> >
> >> >>Can we say this instead please?
> >> >>
> >>
> >> Hi, Lorenzo
> >>
> >> I am not sure understand you correctly. If not, please let me know.
> >>
> >> >>>
> >> >>> The tricky thing in above reproduce method is current debugfs interface
> >> >>> leverage function split_huge_pages_pid(), which will iterate the whole
> >> >>> pmd range and do folio split on each base page address. This means it
> >> >>> will try 512 times, and each time split one pmd from pmd mapped to pte
> >> >>> mapped thp. If there are less than 512 shared mapped process,
> >> >>> the folio is still split successfully at last. But in real world, we
> >> >>> usually try it for once.
> >> >>
> >> >>This whole sentence could be dropped I think I don't think it adds anything.
> >> >>
> >> >>And you're really confusing the issue by dwelling on this I think.
> >> >>
> >>
> >> It is intended to explain why the reproduce method should fork 512 child. In
> >> case it is not helpful, I will drop it.
> >
> >Yeah it's not too helpful I don't think. You could say 'forking many children'
> >or something.
> >
> >>
> >> >>You need to restart the walk in this case in order for the PTEs to be correctly
> >> >>handled right?
> >> >>
> >> >>Can you explain why we can't just essentially revert 60fbb14396d5? Or at least
> >> >>the bit that did this change?
> >>
> >> Commit 60fbb14396d5 removed some duplicated check covered by
> >> page_vma_mapped_walk(), so just reverting it may not good?
> >>
> >> You mean a sentence like above is preferred in commit msg?
> >
> >I mean you need to explain why you're not just reverting it, saying why in
> >the commit msg would be helpful yes, thanks!
> >
> >>
> >> >>
> >> >>Also is unmap_folio() the only caller with TTU_SPLIT_HUGE_PMD as the comment
> >> >>that was deleted by 60fbb14396d5 implied? Or are there others? If it is, please
> >> >>mention the commit msg.
> >> >>
> >>
> >> Currently there are two core users of TTU_SPLIT_HUGE_PMD:
> >>
> >>   * try_to_unmap_one()
> >>   * try_to_migrate_one()
> >>
> >> And another two indirect user by calling try_to_unmap():
> >>
> >>   * try_folio_split_or_unmap()
> >>   * shrink_folio_list()
> >>
> >> try_to_unmap_one() doesn't fail early, so only try_to_migrate_one() is
> >> affected.
> >>
> >> So you prefer some description like above to be added in commit msg?
> >
> >Yes please! Thanks.
> >
> >>
> >> >>
> >> >>>
> >> >>> This patch fixes this by restart page_vma_mapped_walk() after
> >> >>> split_huge_pmd_locked(). We cannot simply return "true" to fix the
> >> >>> problem, as that would affect another case:
> >> >>
> >> >>I mean how would it fix the problem to incorrectly have it return true when the
> >> >>walk had not in fact completed?
> >> >>
> >> >>I'm not sure why you're dwelling on this idea in the commit msg?
> >> >>
> >> >>> split_huge_pmd_locked()->folio_try_share_anon_rmap_pmd() can failed and
> >> >>> leave the folio mapped through PTEs; we would return "true" from
> >> >>> try_to_migrate_one() in that case as well. While that is mostly
> >> >>> harmless, we could end up walking the rmap, wasting some cycles.
> >> >>
> >> >>I mean I think we can just drop this whole paragraph no?
> >> >>
> >>
> >> I had an original explanation in [1], which is not clear.
> >> Then David proposed this version in [2], which looks good to me. So I took it
> >> in v3.
> >>
> >> If this is not necessary, I am ok to drop it.
> >
> >Hmm :P well I don't want to contradict David, his suggestions are usually
> >excellent, but I think that paragraph needs rework at the very least. It's
> >useful to mention functions explicitly, I think something like:
> >
> >'when invoking folio_try_share_anon_rmap_pmd() from split_huge_pmd_locked(), the
> >latter can fail and leave a large folio mapped using PTEs, in which case we
> >ought to return true from try_to_migrate_one(). This might result in unnecesary
> >walking of the rmap but is relatively harmless'
> >
> >Might work better?
> >
>
> Hi, Lorenzo
>
> Thanks for your reply.  Since there are several suggestions scattered in
> several mails, I would like to consolidate all of them here.
>
> Below is the updated version of commit msg with change marked. If I miss or
> misunderstand your point, please let me know.
>
>
> Subject: [PATCH] mm/huge_memory: fix early failure try_to_migrate() when split
>  huge pmd for shared THP
>
> Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and          <--- simplify a little and
> split_huge_pmd_locked()") return false unconditionally after                        put reasoning in next paragraph
> split_huge_pmd_locked(). This may fail try_to_migrate() early when
> TTU_SPLIT_HUGE_PMD is specified.
>
> The reason is the above commit adjusted try_to_migrate_one() to, when a        <--- specify the function affected
> PMD-mapped THP entry is found, and TTU_SPLIT_HUGE_PMD is specified (for             try explain reason clearly
> example, via unmap_folio()), return false unconditionally. This breaks the
> rmap walk and fail try_to_migrate() early, if this PMD-mapped THP is mapped in
> multiple processes.
>
> The user sensible impact of this bug could be:                                 <--- more detail on the user sensible impact
>
>   * On memory pressure, shrink_folio_list() may split partially mapped folio
>     with split_folio_to_list(). Then free unmapped pages without IO. If
>     failed, it may not be reclaimed.
>   * On memory failure, memory_failure() would call try_to_split_thp_page()
>     to split folio contains the bad page. If succeed, the PG_has_hwpoisoned
>     bit is only set in the after-split folio contains @split_at. By doing
>     so, we limit bad memory. If failed to split, the whole folios is not
>     usable.
>
> One way to reproduce:                                                          <--- move repo after reasoning
>                                                                                     remove explanation on tricky number
>
>     Create an anonymous THP range and fork 512 children, so we have a
>     THP shared mapped in 513 processes. Then trigger folio split with
>     /sys/kernel/debug/split_huge_pages debugfs to split the THP folio to
>     order 0.
>
> Without the above commit, we can successfully split to order 0.
> With the above commit, the folio is still a large folio.
>
> And currently there are two core users of TTU_SPLIT_HUGE_PMD:                  <--- only try_to_migrate_one() affected
>
>   * try_to_unmap_one()
>   * try_to_migrate_one()
>
> try_to_unmap_one() would restart the rmap walk, so only try_to_migrate_one()
> is affected.
>
> We can't simply revert commit 60fbb14396d5 ("mm/huge_memory: adjust            <--- why not just revert it
> try_to_migrate_one() and split_huge_pmd_locked()"), since it removed some
> duplicated check covered by page_vma_mapped_walk().
>
> This patch fixes this by restart page_vma_mapped_walk() after
> split_huge_pmd_locked(). Since we cannot simply return "true" to fix the
> problem, as that would affect another case:
>
>     When invoking folio_try_share_anon_rmap_pmd() from                         <--- rephrase the explanation
>     split_huge_pmd_locked(), the latter can fail and leave a large folio            on not return "true"
>     mapped through PTEs, in which case we ought to return true from
>     try_to_migrate_one(). This might result in unnecessary walking of the rmap
>     but is relatively harmless.

OK LGTM, thanks!

Feel free to add:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Cheers, Lorenzo

>
> Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and split_huge_pmd_locked()")
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Tested-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Gavin Guo <gavinguo@igalia.com>
> Acked-by: David Hildenbrand (arm) <david@kernel.org>
> Cc: Gavin Guo <gavinguo@igalia.com>
> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: <stable@vger.kernel.org>
>
> ---
> v4:
>   * only commit msg adjustment
>     - rephrase the reason analysis
>     - move reproduce method afterward
>     - more explanation on user sensible effect of the bug, especially expand
>       what "Limit bad page" means
>     - remove the explanation on whey it need to fork 512 child for reproduce
>     - explain why simply revert commit 60fbb14396d5 is not taken
>     - mention TTU_SPLIT_HUGE_PMD users and confirm not affect others
>     - rephrase the reason why can't simply return true
> v3:
>   * gather RB
>   * adjust the commit log and comment per David
>   * add userspace-visible runtime effect in change log
> v2:
>   * restart page_vma_mapped_walk() after split_huge_pmd_locked()
> ---
>  mm/rmap.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index beb423f3e8ec..e609dd5b382f 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2444,11 +2444,17 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>  			__maybe_unused pmd_t pmdval;
>
>  			if (flags & TTU_SPLIT_HUGE_PMD) {
> +				/*
> +				 * split_huge_pmd_locked() might leave the
> +				 * folio mapped through PTEs. Retry the walk
> +				 * so we can detect this scenario and properly
> +				 * abort the walk.
> +				 */
>  				split_huge_pmd_locked(vma, pvmw.address,
>  						      pvmw.pmd, true);
> -				ret = false;
> -				page_vma_mapped_walk_done(&pvmw);
> -				break;
> +				flags &= ~TTU_SPLIT_HUGE_PMD;
> +				page_vma_mapped_walk_restart(&pvmw);
> +				continue;
>  			}
>  #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
>  			pmdval = pmdp_get(pvmw.pmd);
> --
> 2.34.1
>
>
> --
> Wei Yang
> Help you, Help me

