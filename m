Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F382606A32F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 09:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eZOeoBav
Received: by kanga.kvack.org (Postfix)
	id 723686B05B4; Tue,  3 Nov 2026 04:50:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AC586B05B5; Tue,  3 Nov 2026 04:50:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59BDE6B05B6; Tue,  3 Nov 2026 04:50:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DD136B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:50:25 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CE3EAA7DD6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:50:23 +0000 (UTC)
X-FDA: 85393337526.15.DE73456
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 42B26A0002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:50:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eZOeoBav;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793699422;
	b=he+wE6YotHCO5ta31526WD5Lu3QQ3GkwXFWyi8VEEvjCQp8f36+ZqcZOr2OSFAIGuOF1BN
	Z/XPAn1tF/1qM+AVLvSxG/Ib4h9+9JOAQ8bexMudAGV4iDHTghmrlwvczEKjlCQUSLCMUg
	ct27eMWmfMyplBbWlh2qFIZfqCOjwm8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eZOeoBav;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793699422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5XD60sJxmqVuuR9WqNOmUBIYTHUHzJOfBqo68ZaXcw0=;
	b=PHWeOR9cHLzrSCMfu2nG18OFJMk7eKRMF/tgB+m7hCrkDYwd7LIip25aSE4zf6PV9y2Ik1
	ZwSSV9b/YmiD55FLBJC6EUQ6QitkpH6/EM0cCLY0JYQfvjuN5xalgR0bofQnUrrF6pVZ9o
	JTx13mkw+xvepc+BAo5mPBFy0qa+XEk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C28D3605CB;
	Tue,  3 Nov 2026 09:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB3C1F000C1;
	Tue,  3 Nov 2026 09:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793699421;
	bh=5XD60sJxmqVuuR9WqNOmUBIYTHUHzJOfBqo68ZaXcw0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eZOeoBavZjcryxFWgr5UKhLBq+VUBZ0r6W3TvwHEmEPJ32QKVMkDprmtKwnpvKDQp
	 ujZhKcfQDTi2BJ35kyhYxZCnVZGiI081+RPl13Ez6vV94VrJWnszbw2VcaM5Dp4TDg
	 y5RUPHp2dj462u6Kt2/fw1NWIis0aRHzV59njv/86Z3ncg4SJqACYj9/1tXk+mGIWr
	 4q7hwgVNcmlUzAlAPvgW8nf57bneTHenVmrYyvsdMaeM3lCDwerCHvpLeu2nODIN4A
	 udpKAXl39Tkph8SnipwPJb8hkyEy37yXuiTM6/GjEd1PoPsRIMpcwVCom4R3zCJ4Oz
	 ADrwWOFjce1ag==
Date: Tue, 3 Nov 2026 09:50:15 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH v3] mm/memory: use pmdp_get_lockless() for the pmd read
 in do_fault_around()
Message-ID: <aumfvNWiemmuyooP@gremlin>
References: <20261103014749.96764-1-hui.zhu@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103014749.96764-1-hui.zhu@linux.dev>
X-Stat-Signature: mx643xkqt9ixnkk4xqii5cz66rao3idf
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 42B26A0002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793699422-172555
X-HE-Meta: U2FsdGVkX18Y8Ydtzfm9o9k/qYO2jOIQD7CZl6bB2SO8vIIX7plEo1HgO+gYtBv9RgkSmYhKKdPeqMAb9QMitLs9omi/JVm2GURvY6FZjjgs5uzDrtgDRlHc31ldpxqH8ciQQ3Qrz0ilF9s0i8TslGZUxhGi1iHSKuBwPWDB8vW1Usb5nD2E0OLOO9nQC6Jn16CcoFp9tDARRBwsp8sk3v95PeioJeRtJF8hv7x9bUSUmjPqjJQmR/c/m8TBlfhIVrqiWTS+U3bHC4PaAP+ukI01S1W2G1BU0XwQC3VX9sqWirVGOyPYohJgT43Sd8OlL46UqSwjXG52Zo1UZiIDJegY9gM9Uju/mwP5EmXhn6FrYVPTcTXNVZi9mrzElfEWFtWpGrkTTdXGLI54GMsVxQ6hhNbqmtup5vPe286P4MxapsGqWeKiHQal43ExhOP2PU8R3xW6/U8iCu0zjwlIDOISa7/1WwMqDYTpcTuie7PUwIZCevYpuYyXv4n10mr0hwn7B1INjvb/VeZFA4wBMb2jFhHGWrjhDRTEP2rfq3AWwh/X+rZlDSmvKFtDC424O0gN1O4PVQENU9deEJsibzxplAExg8ydV9dSPvDjNRWoLl5f7yi/znMefnqAP9S+Kf6yqjuYR3/k55135sbgKQBYkg3Vr7pwH7W7sekjeLHZWryBdsOO9Z0g2qcSomzyi0NeHaOQteDRHiqjkpPC1m3Kk5Rq5vr5bpHvHZELYV1dyklLyP1kPowaRQOia3x2U+29YzvOgIIXZTKYBokluDx1oFekXb3DlnPhsAlGD3Q07sn3HR0kLbmGwJtxt6xJkoJ8tPwpSZvaHA/SfwARFpSANHvB9UCnaSEZuXmyK6F361wgrkyvjEi7sADM1WsltYeQ6/phqh562PU9H1mvCNmufWPH5LdzouyBGvJmm2rXaSEDX5s/KbhL/iXE9QL3xSLQKrc7+k+Irs9jKmH
 IlijHqX9
 fdkexGVbC9Lecgem0BN+eGMFeoEjUDBi693xo6YHevP+JCLV4ilYL8tXR9VjVxbplKkBZfDFc+tX6z2p0rt4U/OIS5cpeBKCLMQNLkWJE6gkWvrSxrx/nyxuWRLcfAxaQzts45HGpxEt077xDwz4KCJ+BOQ0G8LpQTi5kDz/dM7FQBBrBrJGO63wNIJrwk9szJA62WTo7kOR3m3hO3myva0D2kzGcz5osx/9fDCUEEzA4EUTNV9NiTglEawtYlEc7HnUwiK/F1I1u70IB/WiQukXsYio+HM9fztWOEbk2T/w4Q+Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 09:47:49AM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> KCSAN reports a data-race in do_read_fault / pmd_install; the same code
> is in mainline:
>
>   write (marked) to 0xffff8d52a75fb810 of 8 bytes by task 27487 on cpu 5:
>    native_set_pmd arch/x86/include/asm/pgtable_64.h:83 [inline]
>    pmd_populate arch/x86/include/asm/pgalloc.h:84 [inline]
>    pmd_install+0xe0/0x120 mm/memory.c:444
>    finish_fault+0x5bc/0xb00 mm/memory.c:5204
>    do_cow_fault mm/memory.c:5432 [inline]
>    do_fault+0x5d0/0x6e0 mm/memory.c:5526
>    handle_mm_fault+0x211/0x4c0 mm/memory.c:6218
>    __mm_populate+0x144/0x270 mm/gup.c:2207
>    __do_sys_mlockall+0x2cd/0x380 mm/mlock.c:764
>
>   read to 0xffff8d52a75fb810 of 8 bytes by task 27527 on cpu 9:
>    do_fault_around mm/memory.c:5341 [inline]
>    do_read_fault+0x162/0x670 mm/memory.c:5381
>    do_fault+0x31a/0x6e0 mm/memory.c:5524
>    handle_mm_fault+0x211/0x4c0 mm/memory.c:6218
>    faultin_page_range+0x227/0x530 mm/gup.c:2156
>    __x64_sys_madvise+0x67/0x80 mm/madvise.c:1479
>
>   value changed: 0x0000000000000000 -> 0x000000001386c067
>
> Both paths only hold mmap_lock for read, so do_fault_around() tests
> vmf->pmd while pmd_install() populates it under the pmd lock.  The race is
> benign: a stale pmd_none() only wastes the prealloc_pte, which do_fault()
> frees again, and a pmd seen as populated only makes ->map_pages() find no
> PTE and do_read_fault() fall back to __do_fault().
>
> The load still has to be lockless-safe.  pmdp_get() is a plain READ_ONCE()
> and can tear where pmd_t is wider than a word, as on i386-PAE where

Isn't i386 no longer supported? Are there any other arches we are worried
about?

It seems now after Arnd's removals this has to be manually selected by the
user.

Other than that we are worried about mips32 with 64 bit addresses and sh
with x2tlb. More museum-piece stuff...

I hate that we're impacted by this.

Anyway you should probably call out the relevant arches here.

> pmd_install() publishes two words with a single cmpxchg8b.  Use
> pmdp_get_lockless(), the accessor for pmd reads without the pmd lock and
> what __pte_offset_map() already uses on this very pmd a few instructions
> later.  It is pmdp_get() everywhere else, so the report is silenced the
> same way.
>
> No functional change on architectures that can load a pmd in one go.
>
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>


> ---
> Changelog:
> v3:
> Shorten the comment to one line (David Hildenbrand).
> v2:
> Use pmdp_get_lockless() instead of pmdp_get() (David Hildenbrand).

Please add links to previous discussion, it's difficult to track stuff
otherwise.

>
>  mm/memory.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 0fb676dd2bd63..f25c2ce0ef153 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -6017,7 +6017,8 @@ static vm_fault_t do_fault_around(struct vm_fault *vmf)
>  	to_pte = min3(from_pte + nr_pages, (pgoff_t)PTRS_PER_PTE,
>  		      pte_off + vma_pages(vmf->vma) - vma_off) - 1;
>
> -	if (pmd_none(*vmf->pmd)) {

This pattern is definitely bad I think, we have it in many other places so
should probably convert those to pmdp_get() at least?

> +	/* pmd_install() rechecks pmd_none() under the pmd lock. */
> +	if (pmd_none(pmdp_get_lockless(vmf->pmd))) {

It definitely seems right to use at least pmdp_get() here, but I wonder
about the need for pmdp_get_lockless() here.

pmd_none() only checks the lower word, so a torn 64-bit word on 32-bit
(i.e. the PAE style cases we are worried about) makes no difference:

From x86 pmd_none():

	/* Only check low word on 32-bit platforms, since it might be
	   out of sync with upper half. */

And anyway I guess there is no valid PMD in such systems that would have
the lower word cleared and upper word not cleared.

And we have other instances of this pattern all over the place, when you
read the PMD you don't hold the PMD lock at all so 'lockless' is kinda
questionable here.

I mean yes it's lockless but no more than other cases like this.

So either I think use pmdp_get() or we need to go convert everywhere else
and be strict on pmdp_get() only being used with the PMD lock held.

>  		vmf->prealloc_pte = pte_alloc_one(vmf->vma->vm_mm);
>  		if (!vmf->prealloc_pte)
>  			return VM_FAULT_OOM;
> --
> 2.43.0
>

--
Cheers, Lorenzo

