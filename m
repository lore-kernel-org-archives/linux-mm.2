Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17F85C43327
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:58:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA4846B0110; Thu,  2 Jul 2026 20:57:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2E896B010E; Thu,  2 Jul 2026 20:57:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAB2B6B0114; Thu,  2 Jul 2026 20:57:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 867676B010C
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:57:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 98CBC401CB
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:49:47 +0000 (UTC)
X-FDA: 84944574414.26.201EA70
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id D3AA810000C
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:49:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eS77nEYO;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783014586;
	b=gZQ3+CreL306yQpEIFVVTVdcpZt+wsO8TufQ71fOiTbehcGywvXWoN9yQnL6nsWPB1CRHm
	Eke4FusnuOvpWVIeodX7QNIKzlxw2RItizvr40xK0Hz/KCU55oDXT/q/a+GE58qVZygX5y
	Ive1sggxrT7Qa9T2EBRwP20weBixKOE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783014586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wuCIBX5SKHbYxpJ28hHw2u9p1C37eIECB4uw4lnxHb8=;
	b=2dzKDh5Q6CFAH5cfmEKfFaB117cvknvXu4z1vorvclSoRs6Mt1Fh4CC9K92NWQFmh0J4Ia
	IEdkfDbbxxyY5CgMNB9Sw04UDWIKmzPpDybSgDzEJXBuMGN+pmgaFAabB+ZFyLX0+U2lSs
	t0cXcryKkJXlFrJnZIKtvu+nvIHsYok=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eS77nEYO;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1290940D7A;
	Thu,  2 Jul 2026 17:49:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7393F1F000E9;
	Thu,  2 Jul 2026 17:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783014585;
	bh=wuCIBX5SKHbYxpJ28hHw2u9p1C37eIECB4uw4lnxHb8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eS77nEYOKAx15MNcfxh3mmjiOoNqjHjvbu58LpEIZnqMfmdHX15eBZ0mkhikJcDl/
	 tP4vIFxQbFD2GzOd37ePE1DRxEY/pdgBfqyusoa3LIhU1HDeyJoKx8sECR0dXAbwj6
	 SKZGjK6FxJPXBg5c91F/GR6iLSBNoFSNfMZ+vbjVBwzoA24Io+ulZ2nqwXoH/j9Wnl
	 jpNTcYvD7IihrnGPEnCBl0hbLFG1RGgapV4SsGoPbnDvBxCVSdE7OXQXGYkgVbgrsB
	 b3caRgLyJ0IETP4mgPER75qHRXXZClI8NazztQSybbHie9vOe9eIwqTvLxI8GBAuSh
	 VbsJeulNaTsyQ==
Date: Thu, 2 Jul 2026 18:49:34 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Klara Modin <klarasmodin@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>, david@kernel.org, 
	richard.weiyang@gmail.com, akpm@linux-foundation.org, riel@surriel.com, liam@infradead.org, 
	vbabka@kernel.org, harry@kernel.org, jannh@google.com, balbirs@nvidia.com, 
	sj@kernel.org, ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [Patch mm-hotfixes v5] mm/page_vma_mapped: fix device-private
 PMD handling
Message-ID: <akai-Iw5okhFPXUq@lucifer>
References: <d4e4180e-dcdf-40e6-b5a2-2ac55f4aecc4@kernel.org>
 <20260701163356.22936-1-lance.yang@linux.dev>
 <akVDNLGaCfr-PF8K@soda.int.kasm.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <akVDNLGaCfr-PF8K@soda.int.kasm.eu>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D3AA810000C
X-Stat-Signature: 8wjwouxhu5n8ext6yptwaawbsgq8xnkz
X-HE-Tag: 1783014585-183136
X-HE-Meta: U2FsdGVkX1907s5+fJ8HcrN5s+vF1eFrrkEXI/yKetz3AagyKJDP7LBsz4jpU6Aw7+6sRXLVVOmReOIIvrMh3wJo+952IvXnzpSw118psIvtAfbuUlEJwht2V65eMOhDwUm69q4/UX5QzCnJ23oR66TuuYpgpyemveQSNNPw4sCCrjs2Ups6XvIOSn2JblHr1UeBiyw2lqW7RmxekHUO/nA4zFVcwMVfhvJf5WJDowvAlFcbeiapTIx9cEXkUhEvPsJlgHIGFcex2ez997mtnW3VdV0TySFutjEIK19chmqufC7+srPi1/pSC+2XNrgg5CoD0T8W4tbwbKhMWW06H8pCcTh+kvZoBxwAXDqvplUP+xS/U9SANFRcMw7FV93/2cCI1O57B3OojnfZnjMwT78iPyW4GYy1G/VJyHwCXpAtaEgwsfIywK1lcS7LSrpuwlKfPgnRhrHhLcZjc8eBAOD3EmwsXLf8dZg81j8/k8ESt06COcA24zPRo2DA04utnrtNwvkTEi+DxsiWRW7ZEHlaAfJ/W9Id6q9myh02nGm5vcKsIDgbEaOlXIBQjenKhPvcsRiLD7WmnvIdfg7nX37P2u63GsFJYMqiF/8IeexNsRHVkT/6htYCTH7pwB3b/COczYU5uXcCFQddY/5evby8bk0bHig4g0idjmfMWHip9pa7jnBnbou6LG2Rpyi0Nx28SK8RoRxRFg2NB0NGO/3YI8jLHzM9EVC9ljPuH0rJy2wFXjkZ+so1o3L60Kv5mVxiFt6KSFD19QESNvHUJib12624velhZzgU9d9gMBnYbbn7IuLJZihWxUXRKB53Hzeezz2p6y+XeswdIe/jI650p3nt7XeIdiGUxy9GbItYucFlzTv7hqPECwFdzZJGGtyKVnqWBVVPuHi6b03XwhaHbc5kRfouFqaxszIv7u3pSS7L8s0Djj1zMTCRy60J983O/oeAR7WjLUUECdl
 7BJxucdo
 EFPOlpCTSCTTQQj2hA+BIV3Fi6VyO1Gl29UXu5oouJ/wjM6y366qIo9fbYDg4I1tvk8Ii1/T3MF23ZDNGvq6znfxLpBHM20sLr/tQ43OquL8OmhvGSuQf3j0XnlPvnkvnoIKm3JjLutOYN96LqNYT8H+QyM+OAXGKAbG+53BR70NuMih706hQ3khs7AfDOwMyWl3YUO3kEHecU8sXMUj/VBvzKZtnVpFbMiqyrcTwFAMk8lLQR9iJkVcQ/oi2ZvUDlKe/rbfmyA0z2T8nczqmQK+wDV0BxCJhfX+3Eno3KAsYdQWoKlk/vrajleAUwgrkvGf46gGASWRR0IvQc+Dp/Y4ZLfqF3n/U8v42tlPfvBu1+sWcXsQYHzup8C/76jcWdlJ0NRgBGZzzD6rRQQElDfRSDV+BH09V6Na9De0ZOZhRgi5RsIErVj9IcZFO3i6jThGEUvkWZz4ulsKigYDRcMCJfNGuIgI5Kf0x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 06:46:27PM +0200, Klara Modin wrote:
> On 2026-07-02 00:33:56 +0800, Lance Yang wrote:
> >
> > On Wed, Jul 01, 2026 at 05:36:33PM +0200, David Hildenbrand (Arm) wrote:
> > >On 7/1/26 16:33, Klara Modin wrote:
> > >> Hi,
> >
> > Hi,
> >
> > [...]
> > >>
> > >> This results in a build bug for my Raspberry Pi 1:
> >
> > Thanks for reporting this!
> >
> > >>  In file included from <command-line>:
> > >>  In function ‘check_pmd’,
> > >>      inlined from ‘page_vma_mapped_walk’ at /home/klara/git/linux/trees/bisect/mm/page_vma_mapped.c:256:10:
> > >>  /home/klara/git/linux/trees/bisect/include/linux/compiler_types.h:702:45: error: call to ‘__compiletime_assert_433’ declared with attribute error: BUILD_BUG failed
> > >>    702 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
> > >>        |                                             ^
> > >>  /home/klara/git/linux/trees/bisect/include/linux/compiler_types.h:683:25: note: in definition of macro ‘__compiletime_assert’
> > >>    683 |                         prefix ## suffix();                             \
> > >>        |                         ^~~~~~
> > >>  /home/klara/git/linux/trees/bisect/include/linux/compiler_types.h:702:9: note: in expansion of macro ‘_compiletime_assert’
> > >>    702 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
> > >>        |         ^~~~~~~~~~~~~~~~~~~
> > >>  /home/klara/git/linux/trees/bisect/include/linux/build_bug.h:40:37: note: in expansion of macro ‘compiletime_assert’
> > >>     40 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
> > >>        |                                     ^~~~~~~~~~~~~~~~~~
> > >>  /home/klara/git/linux/trees/bisect/include/linux/build_bug.h:60:21: note: in expansion of macro ‘BUILD_BUG_ON_MSG’
> > >>     60 | #define BUILD_BUG() BUILD_BUG_ON_MSG(1, "BUILD_BUG failed")
> > >>        |                     ^~~~~~~~~~~~~~~~
> > >>  /home/klara/git/linux/trees/bisect/include/linux/huge_mm.h:113:28: note: in expansion of macro ‘BUILD_BUG’
> > >>    113 | #define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
> > >>        |                            ^~~~~~~~~
> > >>  /home/klara/git/linux/trees/bisect/include/linux/huge_mm.h:117:26: note: in expansion of macro ‘HPAGE_PMD_SHIFT’
> > >>    117 | #define HPAGE_PMD_ORDER (HPAGE_PMD_SHIFT-PAGE_SHIFT)
> > >>        |                          ^~~~~~~~~~~~~~~
> > >>  /home/klara/git/linux/trees/bisect/include/linux/huge_mm.h:118:26: note: in expansion of macro ‘HPAGE_PMD_ORDER’
> > >>    118 | #define HPAGE_PMD_NR (1<<HPAGE_PMD_ORDER)
> > >>        |                          ^~~~~~~~~~~~~~~
> > >>  /home/klara/git/linux/trees/bisect/mm/page_vma_mapped.c:142:20: note: in expansion of macro ‘HPAGE_PMD_NR’
> > >>    142 |         if ((pfn + HPAGE_PMD_NR - 1) < pvmw->pfn)
> > >>        |                    ^~~~~~~~~~~~
> > >>
> > >> bisect log:
> > >>
> > >>  # bad: [be5c93fa674f0fc3c8f359c2143abce6bbb422e6] Add linux-next specific files for 20260630
> > >>  git bisect start 'HEAD'
> > >>  # status: waiting for 'good' commit(s), 'bad' commit known
> > >>  # good: [dc59e4fea9d83f03bad6bddf3fa2e52491777482] Linux 7.2-rc1
> > >>  git bisect good dc59e4fea9d83f03bad6bddf3fa2e52491777482
> > >>  # bad: [6148219e90732fd06f5d7a498bda974e6a43ab4b] Merge branch 'nand/next' of https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git
> > >>  git bisect bad 6148219e90732fd06f5d7a498bda974e6a43ab4b
> > >>  # bad: [e0326ebe10191447ab8fa2e904080df7b743765e] Merge branch 'for-next' of https://git.kernel.org/pub/scm/linux/kernel/git/soc/soc.git
> > >>  git bisect bad e0326ebe10191447ab8fa2e904080df7b743765e
> > >>  # bad: [fbc9c5ac47cef5a2b04aef30c8e990b32dcf2548] Merge branch 'hwmon' of https://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git
> > >>  git bisect bad fbc9c5ac47cef5a2b04aef30c8e990b32dcf2548
> > >>  # bad: [e488171f6f6df6fc899a355079665fdb3c50b0e3] Merge branch 'for-linus' of https://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound.git
> > >>  git bisect bad e488171f6f6df6fc899a355079665fdb3c50b0e3
> > >>  # bad: [60db0fcb8fc9d80ac0b63041c632b41a311a45f1] Merge branch 'fs-current' of linux-next
> > >>  git bisect bad 60db0fcb8fc9d80ac0b63041c632b41a311a45f1
> > >>  # good: [51021d260d682aa17b3533848a99160ab83e0c93] Merge branch 'vfs.fixes' of https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
> > >>  git bisect good 51021d260d682aa17b3533848a99160ab83e0c93
> > >>  # good: [ded56474db6552260786a65898322464b72c7540] mm: a second pagecache maintainer
> > >>  git bisect good ded56474db6552260786a65898322464b72c7540
> > >>  # good: [6c893b948351d42cfc3761cc746ab5b3d03ee7f3] Merge branch 'misc-7.2' into next-fixes
> > >>  git bisect good 6c893b948351d42cfc3761cc746ab5b3d03ee7f3
> > >>  # good: [bfcc55a14179495b0c41408908fd7b9d7785c694] lib: test_hmm: use device devt for coherent device range selection
> > >>  git bisect good bfcc55a14179495b0c41408908fd7b9d7785c694
> > >>  # good: [a27318567c92ba5482906d047e71a7aa4fd01889] Merge branch 'fixes' of https://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git
> > >>  git bisect good a27318567c92ba5482906d047e71a7aa4fd01889
> > >>  # bad: [6887a39652cdfd4cfd3b0962662c9cbc26ce5252] mm/page_vma_mapped: fix device-private PMD handling
> > >>  git bisect bad 6887a39652cdfd4cfd3b0962662c9cbc26ce5252
> > >>  # good: [2cc6bd0efc264b9ac760c2bc74dff4f521a680a1] MAINTAINERS: s/SeongJae/SJ/
> > >>  git bisect good 2cc6bd0efc264b9ac760c2bc74dff4f521a680a1
> > >>  # first 'bad' commit: [6887a39652cdfd4cfd3b0962662c9cbc26ce5252] mm/page_vma_mapped: fix device-private PMD handling
> > >>
> > >>>
> > >>> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
> > >>> Cc: <stable@vger.kernel.org>
> > >>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> > >>> Suggested-by: David Hildenbrand <david@kernel.org>
> > >>> Cc: David Hildenbrand <david@kernel.org>
> > >>> Cc: Balbir Singh <balbirs@nvidia.com>
> > >>> Cc: SeongJae Park <sj@kernel.org>
> > >>> Cc: Zi Yan <ziy@nvidia.com>
> > >>> Cc: Lorenzo Stoakes <ljs@kernel.org>
> > >>> Cc: Lance Yang <lance.yang@linux.dev>
> > >>>
> > >>> ---
> > >>> v5:
> > >>>   * put device-private pmd handling along with the other two cases
> > >>>   * remove thp_migration_supported()
> > >>> v4: https://lore.kernel.org/all/20260624065353.1622-1-richard.weiyang@gmail.com/T/#u
> > >>>   * refine subject and commit log based on Lorenzo's suggestion
> > >>>   * put pmd device-private entry handling in its own if branch,
> > >>>     suggested by Lorenzo
> > >>>
> > >>> v3:
> > >>>   * remove cleanup part, only fix the issue for device-private entry
> > >>>   * refine user effect description based on Lorenzo's suggestion
> > >>>
> > >>> v2: https://lore.kernel.org/all/20260616063436.20455-1-richard.weiyang@gmail.com/T/#u
> > >>>   * specify the possible error case of current code and user visible effect
> > >>>   * besides fix, cleanup the pmd entry handling based on David's suggestion
> > >>>
> > >>> v1: https://lore.kernel.org/linux-mm/20260508013728.21285-1-richard.weiyang@gmail.com/
> > >>> ---
> > >>>  mm/page_vma_mapped.c | 30 ++++++++++++++++--------------
> > >>>  1 file changed, 16 insertions(+), 14 deletions(-)
> > >>>
> > >>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
> > >>> index 2ccbabfb2cc1..2d6c58488e3a 100644
> > >>> --- a/mm/page_vma_mapped.c
> > >>> +++ b/mm/page_vma_mapped.c
> > >>> @@ -243,21 +243,30 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
> > >>>  		 */
> > >>>  		pmde = pmdp_get_lockless(pvmw->pmd);
> > >>>
> > >>> -		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
> > >>> +		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
> > >>> +		    pmd_is_device_private_entry(pmde)) {
> > >>>  			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
> > >>>  			pmde = *pvmw->pmd;
> > >>> -			if (!pmd_present(pmde)) {
> > >>> +			if (pmd_is_migration_entry(pmde)) {
> > >>>  				softleaf_t entry;
> > >>>
> > >>> -				if (!thp_migration_supported() ||
> > >>> -				    !(pvmw->flags & PVMW_MIGRATION))
> > >>> +				if (!(pvmw->flags & PVMW_MIGRATION))
> > >>>  					return not_found(pvmw);
> > >>>  				entry = softleaf_from_pmd(pmde);
> > >>> +				if (!check_pmd(softleaf_to_pfn(entry), pvmw))
> > >>> +					return not_found(pvmw);
> > >>> +				return true;
> > >>> +			} else if (pmd_is_device_private_entry(pmde)) {
> > >>> +				softleaf_t entry;
> > >>>
> > >>
> > >>> -				if (!softleaf_is_migration(entry) ||
> > >>> -				    !check_pmd(softleaf_to_pfn(entry), pvmw))
> > >>
> > >> My only guess here would be that the compiler evaluates
> > >> !softleaf_is_migration(entry) to always be true and optimises away the
> > >> !check_pmd(softleaf_to_pfn(entry), pvmw) which is why this worked
> > >> before?
> > >
> > >Weird, we enter this path only with
> > >
> > >pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
> > >pmd_is_device_private_entry(pmde)
> > >
> > >If any one of these would compile for !CONFIG_TRANSPARENT_HUGEPAGE that would be
> > >odd.
> > >
> > >pmd_is_device_private_entry() is hard-coded to false unless
> > >CONFIG_ARCH_ENABLE_THP_MIGRATION. Which is only selected with
> > >ARCH_ENABLE_THP_MIGRATION.
> > >
> > >pmd_trans_huge() as well.
> > >
> > >Maybe it's struggling with pmd_is_migration_entry() on some (older) compilers?
> > >(not innlining stuff and not properly optimizing it out).
>
> It's a GCC 16 cross-compiler for armv6 so I wouldn't call it old :)
>
> > >
> > >The whole conditional must be optimized out.
> >
> > Right. Kinda weird if compiler didn't fold
> >
> > pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
> > pmd_is_device_private_entry(pmde)
> >
> > away here ...
> >
> > >We could check for IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) right at the start
> > >to make it easier for the compiler:
> >
> > +1, explicit THP guard should do the trick :)
> >
> > >if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) &&
> > >    (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
> > >     pmd_is_device_private_entry(pmde))) {
> > >
> > >
> >
> > Klara, could you try with this change and see if it fixes the build?
> >
> > Thanks, Lance
>
> This does indeed make it build.

Hmm this is pretty ugly though.

softleaf_is_migration() is a bit-test so I don't think that's the issue.

I think the issue here is thp_migration_supported() that's what's needed here.

So maybe

-				if (!thp_migration_supported() ||
-				    !(pvmw->flags & PVMW_MIGRATION))
+				if (!(pvmw->flags & PVMW_MIGRATION))

Should just be kept as it is or:


+#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 static inline bool pmd_is_migration_entry(pmd_t pmd)
 {
      return softleaf_is_migration(softleaf_from_pmd(pmd));
 }
+#else
+static inline bool pmd_is_migration_entry(pmd_t pmd)
+{
+     return false;
+}
+#endif

And I think the CONFIG_TRANSPARENT_HUGEPAGE is just conflating the
CONFIG_ARCH_ENABLE_THP_MIGRATION.



>
> Thanks,
> Klara Modin

Thanks, Lorenzo

