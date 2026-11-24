Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE921606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K0VKDCfv
Received: by kanga.kvack.org (Postfix)
	id B71546B0811; Tue, 24 Nov 2026 12:51:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22896B0813; Tue, 24 Nov 2026 12:51:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A38776B0814; Tue, 24 Nov 2026 12:51:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 665906B0811
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:51:36 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B2E12120A9B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:51:35 +0000 (UTC)
X-FDA: 85470754950.20.D0573D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 18B3B4000A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:51:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K0VKDCfv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795542694;
	b=AACTwRqJe/fXSB1h8Rs85s9Fap1L/Ur/EShmgDhq16NV1MTDuaK5pJemDG1jK4HCZ/P2cB
	T+bUmvC7yEd9F1sKozwKbigTtc8VWk37xPn2PYyG+5t5guvZuBEhnpCmhctvlrwiadStQ6
	18DafzafV7sp6p2Tpb4NjUL7g0nPMXk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795542694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SkbRJ3BICaStaQpwyrBwVvkQ+2k3l99JSuWqhVYJ7js=;
	b=x6B3IQ3m3MWu8lhQ7l6rQdPoZtFXKXw0+vu2DmnWG8LZO2YXSsgw1NT05ZZBRJmtga9bWu
	uhh4z9WgthC/+HghYAc+nbc6dLUh+2zQWFQQz2ldl0GqUlQGUjtrvGE2SmjeweS6INJ/N8
	ApPuiYJbWGaQpPTiPbPmdJSjJ2nNl7k=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K0VKDCfv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7025062888;
	Tue, 24 Nov 2026 17:51:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB9D1F000C4;
	Tue, 24 Nov 2026 17:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795542693;
	bh=SkbRJ3BICaStaQpwyrBwVvkQ+2k3l99JSuWqhVYJ7js=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K0VKDCfvlDIfrnTyVFYmLMBRLCc0IoK9boz/D+vjMKZgAXHqUDOf44RmzhrWQf08d
	 wiFBnIgPICA4wyb+azfEtvl7xtkuQsb2fVS98+wqcMmtpY2mYYyhtV1XkG8fd4JfSV
	 U4zCZIWU9UIpwqon/qarS/CmT8ibKD6FBy+OmolAWRm2avKRK5NGwyefuB4XFDSiIC
	 F9t6GnPPdhuCCIhLEzzTpFkSTXHLG8IZOXVEZgZyBkPlJ2NDHqn/Ds3ek6WVZYZOBU
	 UxplVAlrajs5RBpqUj2HKnyVew82BHCOqBsplM3RhlnqKcTBEgI5WZDpyfolhwwt9q
	 IWsUxu2wW7O5A==
Date: Tue, 24 Nov 2026 17:51:26 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Brad Hawthorne <brad@sim.vu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, Hajime Tazaki <thehajime@gmail.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/nommu: keep the maple tree in step when mremap()
 resizes in place
Message-ID: <awXMCqK5H2TOlvtf@gremlin>
References: <20261121083139.803682-1-brad@sim.vu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261121083139.803682-1-brad@sim.vu>
X-Rspamd-Queue-Id: 18B3B4000A
X-Stat-Signature: 9ut3dmxeop5rqkh81oitu4gkwck33tfc
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795542693-815336
X-HE-Meta: U2FsdGVkX1+wbecSSo3qKsX3ohJIP/R6SS2vpoxkICB6ls6Xl3Rw+QBdOayTcdq+1/n9euTaK55a2gZebAFn2WElxBiBlasWoWeHlDoBiO6JuNqIZk6nnpoSQss1eTJxudnX886Ox3duDNWOU5qdxbNPgdkNBoIv7RsiUcheAb9qjMyyilNnDfFJSaQi6aQqpnBnvZ/K/cYaQ7sh9MvbwbLvDATnkKg62bujoQO3Fn1TyPEKBiRotdMwZMChlTKY7UQDt5BqFTr4F9twwVLmbs+wO+x/2YWOr876Dayh9Etyn+o/sOv6T0k97/7tFbPIxkrA2T2l+rz6ZdGYuXPzEBqDgRxrmdZkm9rmGTrctYe8ncCLy4myogZRHLf0h0MdsoD5uweI2FRrhT8L4BLBaTAa1Yf3opzpbythaME6zGlfizRofXxyU+XwdXyOP0/vMY3oGGn5jV96ggxodUK/gW6B8ySnq3JsSFZcodJNgY1m+rYk2T6O5945uwUyAe8ZF3+GdUq7SzAHaWN6cB03uEHk6xYa0XWn83Bvi0v+byOhNI+v5fMCJFpFwTmqsQfhIiWZCbI2rQuZ/gj481uLG90Sp2D/6O0TBW1kxh4y2pDYz38w2fOHu/4P7YpqFWMxaVHhxPXM7BvuUM1Ue5uSDO5BEJeQPwTOPpbdTB/9VGGhjN0Xm4HGWE4b/oPy8He1bGvL4fSpdt52Fsko9d7Lh0ruKVCf1iUSMERmv/KUnXGtRdEbmLmAOcDl6kv9TjYOE9iqtC+oyk10ZYENBGjkdieKW0x0anWDVKTWYLj0qbxqUzi6pVanAdVBTXpQM6QxLzB36/QuYu5DZCNDBFfGKreTCb2jTl3240r4KRMkkfK7lLS7TznG++qZgy2piBJV5iGgkUqqbrJhPcRDY8vEwymRpN2HwTAUlvQs0NBCH6Q8gfmIe2FOMbepB/8tBdQ1p5pLdPKzBy9P022AIsq
 NqrMcb08
 YYgCYOiemv29LPbQ7mowZsRv70bk63d4Jw97sne87DitgTSyAwEcck3dWJ7FeANK9WrO30iBt4g/C4wN3nSOUWsOGwBzIui2tzwM2y6mIBcJynzCyml/ClTMGiJ1mqbhdgfYsKtDvBSlbMmBW0+ZKdeJXJdv9neYN7POK39EHhEr8mbKUAQYMy38V34aQ3N46ZCrkwtcMAtjeOv0aFHSjSOHxjyfGfRL94WdNpsdKPyoGx9bHJWgfmr5GZPqomd/u9LbF7CgSMX5ZI424aEPJfaCw+kUBiuXLfUILtZGHOCp6FBEbwAlHjtkhNr4OOJN0RETena0CyRlhLxNW2W9J7b2R9leNGBldpSMNPYUTOq4iTwOHjmo0k0k8m+9QIQPDVOSTaosEzv9FMls9zMxKI1Ufrq8CU+rBjTxp1RtIBanUHo1vVLo0P3p9iLud4mCrt8/FCi1w0USpSX8jioz78vUHnjl373hCGGM+a0ai6zBQHIlvM8IMdWnpHp84oFeFZOctrnNbJoUX8Iq+sH4x7tUicl+HetVWX91EcDu0VCKOAtv8rpkPRepNG3E5O3A1er7LWYOtxeKj99w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 02:31:39AM -0600, Brad Hawthorne wrote:
> On !MMU, do_mremap() resizes a VMA by writing vma->vm_end and nothing
> else, so mm->mm_mt keeps the old extent.
>
> After a shrink, [new_end, old_end) in the tree still points at the VMA.
> When the VMA is unmapped, delete_vma_from_mm() clears only
> [vm_start, vm_end), so that range survives and points at the freed
> vm_area_struct. Lookups in the range then read freed memory (after the
> munmap(), /proc/self/maps still lists it), and exit_mmap() frees the
> VMA a second time. An unprivileged process is enough:
>
> 	long pg = sysconf(_SC_PAGESIZE);
> 	char *p = mmap(NULL, 8 * pg, PROT_READ | PROT_WRITE,
> 		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>
> 	mremap(p, 8 * pg, 4 * pg, 0);
> 	munmap(p, 4 * pg);
> 	_exit(0);
>
> It was first seen on an Adafruit Fruit Jam board (RP2350, Cortex-M33)
> running 7.3.1. There, three rounds of the program's mmap, mremap and
> munmap leave the process's vsize at 2133 KB instead of 64 KB, and the
> next exec faults the kernel, in vm_area_alloc() or __kernel_read()
> under do_mmap(): the double free has corrupted the slab. With this
> patch on the same kernel, 11 of 11 runs keep the vsize at 64 KB and
> the board runs on.
>
> On mm-unstable at the base commit below, under QEMU mps2-an385
> (mps2_defconfig plus SLUB_DEBUG_ON), run as uid 65534:
>
>   BUG vm_area_struct (Not tainted): Object already free
>   Allocated in vm_area_alloc+0x10/0x38 age=0 cpu=0 pid=20
>   Freed in do_munmap+0x2ec/0x2fc age=0 cpu=0 pid=20
>    kmem_cache_free from exit_mmap+0x7c/0x8c
>    exit_mmap from mmput+0x2a/0x74
>    mmput from do_exit+0x1f8/0x520
>
> Clear the range given up on a shrink. Once a shrink clears it, a later
> grow back into the region must store the VMA over its new extent, or
> find_vma() would miss addresses that are mapped; so store it there on a
> grow. Shared and overlay mappings are refused above, so the region is
> this VMA's alone, and the grow is bounded by its size; but the range a
> shrink gave up may since have been mapped again, by a direct mapping of
> device memory at those addresses, so a grow into another mapping fails
> with -ENOMEM. As before, a shrink keeps the region's pages, which is
> what lets a grow back reuse them.
>
> With this patch the program above exits cleanly, with and without
> DEBUG_VM_MAPLE_TREE (nommu has no tree validation of its own, so that
> adds only the store's warnings). A shrink, grow and partial munmap()
> sequence also passes, and fails with the shrink half alone, which is
> why the grow half is needed.
>
> 524e00b36e8c is where nommu find_vma() started trusting the maple tree;
> the exit_mmap() double free above follows from 8220543df148 ("nommu:
> remove uses of VMA linked list") in the same v6.1 series.
>
> Not changed here: a private file mapping's place in the file's i_mmap
> tree also goes stale on a resize. That predates the maple tree and is
> left to a separate patch.
>
> Sashiko's review of Hajime Tazaki's nommu series found the stale range
> in July, and his fixes and RFC since then cover it [1][2]; review asked
> for a minimal fix-only patch with a Fixes: tag [3]. This is a minimal
> version of that fix.
>
> The consequence was reproduced and this patch drafted with an AI coding
> assistant (Claude, Anthropic): it reviewed mm/nommu.c, wrote the
> reproducer and ran the board and QEMU tests; I checked the result.
> Stable backports need adjusting: 6.6.y and 6.12.y lack
> vma_iter_store_overwrite(), and 6.1.y nommu uses the ma_state API.

Thanks for acking the AI, but this commit message is unreadable slop, sorry.

I just can't gather the energy to try to decode something this dense.


>
> Link: https://lore.kernel.org/linux-mm/20260710021028.892645-1-thehajime@gmail.com/ [1]
> Link: https://lore.kernel.org/linux-mm/20260813063401.1786548-2-thehajime@gmail.com/ [2]
> Link: https://lore.kernel.org/linux-mm/an77pELeQdW-sTEi@lucifer/ [3]
> Fixes: 524e00b36e8c ("mm: remove rb tree.")
> Cc: Hajime Tazaki <thehajime@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Brad Hawthorne <brad@sim.vu>
> ---
> Hajime, as you asked, here it is as a separate patch with you on Cc.
> Earlier note, and his reply: https://lore.kernel.org/linux-mm/20261120221021.789792-1-brad@sim.vu/
>
>  mm/nommu.c | 34 ++++++++++++++++++++++++++++++++--
>  1 file changed, 32 insertions(+), 2 deletions(-)
>
> diff --git a/mm/nommu.c b/mm/nommu.c
> index df99495c8..9221cd241 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -1575,6 +1575,7 @@ static unsigned long do_mremap(unsigned long addr,
>  			unsigned long flags, unsigned long new_addr)
>  {
>  	struct vm_area_struct *vma;
> +	unsigned long new_end;
>
>  	/* insanity checks first */
>  	old_len = PAGE_ALIGN(old_len);
> @@ -1601,8 +1602,37 @@ static unsigned long do_mremap(unsigned long addr,
>  	if (new_len > vma->vm_region->vm_end - vma->vm_region->vm_start)
>  		return (unsigned long) -ENOMEM;
>
> -	/* all checks complete - do it */
> -	vma->vm_end = vma->vm_start + new_len;
> +	/*
> +	 * All checks complete - do it.  The maple tree must cover exactly the
> +	 * new extent: a range given up but left in the tree still maps to this
> +	 * VMA, and once the VMA is unmapped and freed, to freed memory.
> +	 */

This is a super schloppy comment. Please just drop that.

> +	new_end = vma->vm_start + new_len;
> +	if (new_len < old_len) {
> +		VMA_ITERATOR(vmi, vma->vm_mm, new_end);
> +
> +		if (vma_iter_clear_gfp(&vmi, new_end, vma->vm_end, GFP_KERNEL))
> +			return (unsigned long) -ENOMEM;
> +		vma->vm_end = new_end;
> +	} else if (new_len > old_len) {
> +		VMA_ITERATOR(vmi, vma->vm_mm, vma->vm_start);
> +
> +		/*
> +		 * Shared and overlay mappings were refused above, so the
> +		 * region is this VMA's alone and still holds its pages: the
> +		 * grow, bounded by the region's size, stays inside it. The
> +		 * range a shrink gave up may since have been mapped again,
> +		 * though: a direct mapping of device memory can take any
> +		 * address.
> +		 */

Again this comment is just horrible. I don't want to see crap like this added to
the kernel.

It's classic LLM - ridiculously dense noise that doesn't help in any way.

* !shared, !overlay
* pages belong to VMA
* growth bound by region size, is within the region (!)
* a range that a shrink gave up may have been remapped
* a direct device memory mapping can take any address

I mean seriously, wtf.

> +		if (find_vma_intersection(vma->vm_mm, vma->vm_end, new_end))

You have a VMI, but then don't use it?

> +			return (unsigned long) -ENOMEM;

These casts are pointless AFAICT.

> +		vma_iter_config(&vmi, vma->vm_start, new_end);

You literally just configured it above and now you're reconfiguring it?

> +		if (vma_iter_prealloc(&vmi, vma))
> +			return (unsigned long) -ENOMEM;

Why are you preallocating?... You usually do that outside of a lock that you
can't allocate under?

> +		vma->vm_end = new_end;
> +		vma_iter_store_overwrite(&vmi, vma);

I'm seriously confused why you're updating the maple tree here like this.

> +	}
>  	return vma->vm_start;
>  }
>
>
> base-commit: d12eccbcb79a4fa35c3aa588eb79056af62eb859
> --
> 2.43.0
>

In general see [0] I don't think we can really look at this this cycle anyway,
but I'm not really confident you understand this code (see [1] especially bit at
the end).

I'd really want to be convinced of that before taking a fix that gets
backported.

And I imagine this can be done with less code. I'd suggest thinking about this
without an LLM so involved.

--
Cheers, Lorenzo

[0]: https://lore.kernel.org/linux-mm/a2f584f6-e382-4876-aa6d-d5a34de6ee59@kernel.org/
[1]: https://docs.kernel.org/process/generated-content.html

