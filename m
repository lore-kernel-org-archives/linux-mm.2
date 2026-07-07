Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54DA4C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 14:33:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3381E6B00A4; Tue,  7 Jul 2026 10:33:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30FAD6B00A7; Tue,  7 Jul 2026 10:33:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24E116B00AA; Tue,  7 Jul 2026 10:33:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8E826B00A4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:33:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 69DD9140321
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:33:49 +0000 (UTC)
X-FDA: 84962224578.19.794C295
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id CFCE5180011
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:33:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jzurjB0S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783434827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lRPHBZyUrNKHZ2wYrLs9GBkE6hyCCqTsoxHyYNlEGp4=;
	b=cQp/BZouIfJfuMGkHkCe7wEGMXHdFaoGV0DwlHadbCm4E3ORl0OcpT++1phEpgr3e9TJUJ
	k+tapNI/75FC0O5ejwcdsVmOyyxFi2NQ6bGTU/KCQMXKJDkia/Tzc/Zdz10bMxghcOEFKt
	7GbdhxxN1eJi5cQ414sZrTsKCJnSNaA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jzurjB0S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783434827;
	b=Q2VEk0l5oKSt2h/XtbYtnrQzrVffaom3HDH2Hxz5WEezdfc5Rd/s1yZSqez6iILhmX2ai5
	yG06MWrebY3loiGqxIeamQNfwYwGIteRWYXiN2rW6EaJ/PdyTSfDTVigdlbVvHYOvniAxd
	Fv6hTgqoAUbnL29pl49Z7l16mgA3oVw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2FC0760018;
	Tue,  7 Jul 2026 14:33:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF6D1F000E9;
	Tue,  7 Jul 2026 14:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783434826;
	bh=lRPHBZyUrNKHZ2wYrLs9GBkE6hyCCqTsoxHyYNlEGp4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jzurjB0SxrMqwZu6uNCaUfK4c2KGCtIIYOndWXuK+m1VvRu9lrbi4I9nj96Zx/pQY
	 E5yroM9SofgfLPNUTi6rrbpvZf9oMJsje3oxScFpQoP+BheH9AY8tU9REhT4PXuCKD
	 WhAtxsGMH4gsy6lFf6h3HV8BmOcbRD+ft8MmdaUIQYKSvS6KYXk372FgWfu8KDOT75
	 IOl1BeNhmV2NYab9YsUTEZEEKIdxU4VtUEL0fenczLVhigCgCWx9PvSgRJl50+GIbZ
	 fIXgoNayIVs8XG5PvCpF76T302wAO0BK51iT22HwwtIETVfzDFxL6RyGgy3/cC2lQ1
	 7f+sCjaN2oRGA==
Date: Tue, 7 Jul 2026 15:33:32 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Wandun Chen <chenwandun1@gmail.com>
Cc: vbabka@kernel.org, david@kernel.org, rostedt@goodmis.org, 
	mhiramat@kernel.org, Alexander.Krabler@kuka.com, hughd@google.com, fvdl@google.com, 
	bigeasy@linutronix.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, akpm@linux-foundation.org, 
	surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, riel@surriel.com, liam@infradead.org, harry@kernel.org, 
	jannh@google.com, lance.yang@linux.dev, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	pfalcato@suse.de
Subject: Re: [PATCH v2 2/4] mm/mlock: wait for migration to finish when
 mlocking a folio
Message-ID: <ak0C-DP_1ZrTVSLj@lucifer>
References: <20260707125925.3725177-1-chenwandun1@gmail.com>
 <20260707125925.3725177-3-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707125925.3725177-3-chenwandun1@gmail.com>
X-Stat-Signature: 8eo4btpu1m9h46pjaqb9hs85m6dzoo7c
X-Rspamd-Queue-Id: CFCE5180011
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783434827-470355
X-HE-Meta: U2FsdGVkX1+4wf1lArmcnivRgh9jrCP09hPIwu2Puqp2zRD/iQXZiJgGAojTojYM+iWAJ0hH00BR9+ybtWe4WIkygc0GenC+MOX39JIrZ3jhYpH1fPfB6Zdxi5/ILRAW2y+Pa1aFlIUkhLPI518GGkS71HwtBI21w6MOgYl8vNIOvQMQX2H1xQt8ILKFAQjNkhJb4oQ0UUkukqbwUgoLwY/HsGOK1v8vcbL7HkcsGhBD5U9QlsRiWinLOw+5yRqjpz7L/qNrphe74JqZ+0/YaJYdaPEMFCakW49kEqkY/K8NiRL3X/Bi9XJxOR+iTbgTacGI3wx/haNe7NlW+mhRjXfo2wgiVh5ujxCL2r7LFNVtqeCda3hh1RWMZR6XVptFeH+arpPtuIEkNmIdC3+79YhEqSIDir4uIZzo/KUZCkLmpgvzvka+GJGsk9l3uf+nI9TazyaxRXzNGFivkJzmAW+hIbm0O7VRdA/Gr28EYGwvDQLAk8AGT5Mn22E+sQ1gX3mGqy0QY6uP+DFrmIJndtlBrCkKHKeK/Vay3uFM6kpJp/rXXYpuwgdLOjqokM46DnjsGVM1ttm2TW02RFo32qXD9489x50gkAldYpCbjKKUz9CHRx9wRjUPISg/Px9BU//fge7C9bvZl7Nl8ZTi3/9X+7CF+lKvwtNtTrvV6jH9Oq8/oWXgtm+IAziRsRi7DDOCvUZ9p9y/Sh1Bou/Jb4xqMc/atdeDZK2xkppzOGgqVG9HrMcANd7tHIm/jGlQ9NOTu/Dc1qHwnU4tLh/gUAd9j3nvbM5UK3Bib1eOkpMNkVGMaDQ8h1ZdnzRVPlSlvCLXEobQGzh3Dv1a7II60sk9Be5l+64l/0TMu4vnKAGCwfUfvVuTibMi0Ou3OtXYp0P2AaUFNdYITeazPVI2vasUGPHcF0WDvpqC1v8lwswiiy9jJI1FADWt8XHh0tEhSoV5Md5Z/2G0sba2V3g
 zJOXC+qs
 AJgNiGLX5zmLI8NlPrAStenRtQTWZyBU9lpUXZAdQlGgU2ukeClPczEQXXPYy8McxXcGa0h+RUHf11FhgsoUcsnjuA+9iu2ekUuQZJztAX3YDrpz2yn3SkPl/rSUIbSnQVZdy2/5h+ZnF4ZtIlggQMKKoL21fMBZml6TUVvrQOqHlX2o+fpDJNXHgt8CPzXyaITvgy0T9Hsw51ki+YwM9tSUDOhcPOjQk2lsGgac4rePNev2pqPqJNNXGeRt/OwD6HUe6xqtfN8THsu9cqWiI6Sr9OEwD5pjkdAoBCWggRGSY58fIyTY8FmxK4DTBcJ97B7BMJrFYuMHJFgsEtJWwKi3IGGg3FU9RuiRAexQmtz1KGgcxNuZynh1cF9swYpcUF0Mz0oZkaU713rb47zZox1+m5SeVyfbVYvO2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 08:59:23PM +0800, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
>
> In RT kernels, sysctl_compact_unevictable_allowed is false by default,
> when the mlock/mlockall system call try to lock all the present page,
> the mlock_pte_range function skips non-present entries. If these
> non-present entries are migration entries, and the migration is not
> guaranteed to have completed before the mlock/mlockall, it may result
> in a page fault on subsequent access, which then waits for the
> migration to finish, causing spike latency in RT kernels.

Is this really noticable and measurable?

I suppose not too many ranges should be mock

>
> Fix it by waiting for the migration to complete during the mlock/mlockall
> syscall when sysctl_compact_unevictable_allowed is false.

Probably better to reference the sysctl itself rather than an arbitrary varible
name.

>
> Fixes: 90d07210ab55 ("mm: mlock: use folios and a folio batch internally")

Again I have no idea why you chose this as the fixes target, especially for
this?

But in any case, why is this separate from the previous commit? I sthis an
entirely separate fix?

> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> Link: https://lore.kernel.org/lkml/c8793c0f-7156-4cb7-9e6e-7909397e2fff@kernel.org/#t

A nit but please strip that #t.

> ---
>  mm/mlock.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
>
> diff --git a/mm/mlock.c b/mm/mlock.c
> index 97e49038d8d3..ac65de40b22b 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -25,6 +25,7 @@
>  #include <linux/memcontrol.h>
>  #include <linux/mm_inline.h>
>  #include <linux/secretmem.h>
> +#include <linux/compaction.h>
>
>  #include "internal.h"
>
> @@ -361,8 +362,17 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
>
>  	ptl = pmd_trans_huge_lock(pmd, vma);
>  	if (ptl) {
> -		if (!pmd_present(*pmd))
> +		if (!pmd_present(*pmd)) {
> +			if (unlikely((vma->vm_flags & VM_LOCKED) &&

-> vma_test(vma, VMA_LOCKED_BIT)...

What is the basis for your unlikely()? Don't use likely()/unlikely() just
because it feels right. Leave them out unless you have actual profiling data to
prove it.

Remove it please.

But I'm also confused here - why are you checking for VMAs that already had
VMA_LOCKED_BIT set when you are about to set it?

Surely this shouldn't be predicated on VMA_LOCKED_BIT?


> +			    !compaction_allow_unevictable() &&

Why do we care about compaction here? Are we assuming the softleaf migration
entry is present only for compaction reasons?

So these migration entries could be there for any reason? Does it matter? Is it
such a big deal, on mlock, to wait for migration entries? I think probably not.

But then maybe some weird workload gets affected... hmm.

> +			    softleaf_is_migration(softleaf_from_pmd(*pmd)))) {

Use pmd_is_migration_entry()? :)

And technically you should use pmdp_get() I think? Maybe a situation where we
don't care/need the READ_ONCE() though.

> +				spin_unlock(ptl);
> +				pmd_migration_entry_wait(vma->vm_mm, pmd);
> +				walk->action = ACTION_AGAIN;
> +				return 0;
> +			}

This code is really disgusting, let's please not just copy/paste open-coded
nested horror shows like this.

A good rule of thumb is if you see a bunch of code 'poking out' like this and
certainly if you copy/paste it or something very much like it, break it out into
a function.

So:

static bool wait_for_migration(const struct vm_area_struct *vma, softleaf_t entry)
{
>>>> As above I'm not sure should even be checking this?
	if (!vma_test(vma, VMA_LOCKED_BIT))
		return false;
>>>> As above I'm not sure this makes sense?
	if (compaction_allowed_unevictable())
		return false;

	return softleaf_is_migration(entry);
}

Then call it like:

	if (ptl) {
		const pmd_t pmd = pmdp_get(pmd);

		if (!pmd_present(pmd)) {
			const softleaf_t entry = softleaf_from_pmd(pmd);

			if (!wait_for_migration(vma, entry))
				goto out;

			spin_unlock(ptl);
			pmd_migration_entry_wait(vma->vm_mm, pmd);
			walk->action = ACTION_AGAIN;
			return 0;
		}
		if (is_huge_zero_pmd(pmd))
			goto out;

(etc. going *pmd -> pmd)

But we could probably do even better than that, and assuming your dubious checks
above aren't needed, we don't even need a helper then:

	if (ptl) {
		const pmd_t pmd = pmdp_get(pmd); // possibly just *pmd?
		const softleaf_t entry = softleaf_from_pmd(pmd);

		if (softleaf_is_migration(entry)) {
			/* Wait for migration entries. */
			spin_unlock(ptl);
			pmd_migration_entry_wait(vma->vm_mm, pmd);
			walk->action = ACTION_AGAIN;
			return 0;
		}
		if (!pmd_present(pmd))
			goto out;
		etc.

And similar for the PTE stuff below.

This works because softleaf_from_pmd() (and pte) will give you a 'none' softleaf
if the entry is not a softlaf entry. So you can unconditionally call it on a
PMD.

>  			goto out;
> +		}
>  		if (is_huge_zero_pmd(*pmd))
>  			goto out;
>  		folio = pmd_folio(*pmd);
> @@ -383,8 +393,17 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
>
>  	for (pte = start_pte; addr != end; pte++, addr += PAGE_SIZE) {
>  		ptent = ptep_get(pte);
> -		if (!pte_present(ptent))
> +		if (!pte_present(ptent)) {
> +			if (unlikely((vma->vm_flags & VM_LOCKED) &&
> +			    !compaction_allow_unevictable() &&
> +			    softleaf_is_migration(softleaf_from_pte(ptent)))) {
> +				pte_unmap_unlock(start_pte, ptl);
> +				migration_entry_wait(vma->vm_mm, pmd, addr);
> +				walk->action = ACTION_AGAIN;
> +				return 0;
> +			}
>  			continue;
> +		}
>  		folio = vm_normal_folio(vma, addr, ptent);
>  		if (!folio || folio_is_zone_device(folio))
>  			continue;
> --
> 2.43.0
>

Thanks, Lorenzo

