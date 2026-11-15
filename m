Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91B67606A31F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 09:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mvO+EHx+
Received: by kanga.kvack.org (Postfix)
	id 8F8A06B00EF; Sun, 15 Nov 2026 04:20:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A9886B05B0; Sun, 15 Nov 2026 04:20:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C00A6B05B1; Sun, 15 Nov 2026 04:20:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5315A6B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 04:20:13 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B4F5D160641
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:20:12 +0000 (UTC)
X-FDA: 85436807064.08.BAC6A72
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 115A8C0004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:20:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mvO+EHx+;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794734411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ISHXbdncGdAEHxOHpmuqEiN2RbSSTwBk5vjVfgEgHGo=;
	b=UNJ9JKKKO8Ta+8UXbjdGlM/9zSzXaSFfgiKPQiGSicz52nIkeJ3gXbBDalxfNInybr+ReL
	XAIiVoJMstrUoPKa4BAwqsx+X+Uq1QjiV8HYhN4FZVjJ8xjKNhyvnKXpaRJMRcf2wlvUSG
	BIGU1vg8vMFtKoQTaafm5s5fRKkaz5c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794734411;
	b=7TD3sa4ckP9vCMBf3jLRupwrNwCxSkK5MJNcpcbfGlsmyTuUIcsbd3QROMwn5A7HChuz/f
	OKf5SvhCS2hmlDgUcbTZXBXnAJqvJ8FcbRuD6AL7ZrPKM/b72Lgvht/UsWR3sBFtUlmLjj
	/HYj/CC2lKKOyo50USNIS3sA+vwm7v8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mvO+EHx+;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E8C20456E1;
	Sun, 15 Nov 2026 09:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 150851F000C4;
	Sun, 15 Nov 2026 09:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794734409;
	bh=ISHXbdncGdAEHxOHpmuqEiN2RbSSTwBk5vjVfgEgHGo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mvO+EHx+rCi9DzTNLXh7+1mktt3J7djeXO7FbkITEbbfxl1iOmT2FB0418jF0/0wf
	 UomovW0IpoQ8kid36TrTAc8Koq+DcrnumFutM+I4CqmypdxSGdOAt8eaR+wR0PvbRp
	 LG0q4OSY8Mlhw3Zkco3bu7nqd4ykRAaAHmwFDB3kT1R3MxIp3h0/jmW38jrSEnBVMD
	 XwzOU5GOdnhjGFkEK1bgm7o4K6t5T34FHcWmJe+ss2W8ujyxOnpcDRClFpBffs/ySh
	 onr8SjTwqurbwnH2Mlj3UB5oA3olzct6XlgHChNX/F67yvtzzFux9tPUyAj/FQEUNv
	 Banf2CkHyeaqQ==
Date: Sun, 15 Nov 2026 11:20:02 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Mukesh Pilaniya <mpilaniy@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chen Pei <cp0613@linux.alibaba.com>,
	George Guo <guodongtai@kylinos.cn>, Kexin Liu <liukexin@kylinos.cn>,
	Sourabh Jain <sourabhjain@linux.ibm.com>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/3] kho: walk bootmem areas in address order
Message-ID: <avl5QjUdYWcCP8Yo@kernel.org>
References: <20261104-kho-bootmem-sizing-v2-0-b0d1a834780f@kernel.org>
 <20261104-kho-bootmem-sizing-v2-1-b0d1a834780f@kernel.org>
 <990cc079-70ab-4fcf-9974-679aaf07849e@redhat.com>
 <avV9qoaPMBLCNOXD@kernel.org>
 <7d5f300f-ab18-4086-8a61-c3347168067a@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d5f300f-ab18-4086-8a61-c3347168067a@redhat.com>
X-Stat-Signature: rgjjpntahfpj3kmbprxza6qr65o1t8um
X-Rspamd-Queue-Id: 115A8C0004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1794734410-123728
X-HE-Meta: U2FsdGVkX19fVj2u1tu6f94Xjd7BcPJr+zwzgXBEKgNwwiKFQaQRYKR2wxw14zA9aFCbYv0zg0CTbBf4PQkuY4Tke8NPdiOfdHDLFf1q6Mfh7myjUiTzLyGxiadckVwetTZs17dTMqB1CU+ZyDKFk/asu5LHUWIzxae+6yEIfAbNW6JPVVlUkZ3BNme4EaU7WojLqPZFuN8Wj2ybHKuAZmouNlGY0V3+ydSmEbQI046NNMqDaWhbN6aObTzxoj3EULD3kcKgDYaa72UhMb4njq47DTq1Guj5gEfYbuuIWtLlJrSXSt2DxHKgfZPsL1Nku/pKG3Q4vhtgh0X48zoQC0cPvCmFcCP94lhH6wz2Smor5TSkF6peQmRMhwuV1Dt7MdtNOP80pzehRQz1n2uGFb/4vQkIrhs8Fg7004dERQCZXP7pSZ3UjXWTh6b1gtxTIzq349LZ5ia7TSzUo54hVEWYx8MPFCGZMZxnu6uc2xwHGkRMGIEp3Mcx8jV89a/0//1UgQSxVgLqLOhi4M2Wa5NyoUKW7hM5wVgf4ZGpejxhv7HRvaJUbso2pFq2ScJyYIRyxdKiCBSMIQag+4fa+Y2xp7e4By4kC3yF+ALV53btMeGGNtxHKl6nkclmEhMYU19qMi+HIIDLkiXhJPladdpZr6hCcbBIBysoBnabCx/IfN8kGwXUgk5pBGsLPM89BbKRDchFKsJQts1lpJY+PfBrn7PHaskvD2v6IFEl0WweUy6rFWXhhA9/dJ7/TxmBWDrlvsVTo7/fJdToSaZct99L9fJJkBORwb3F2a8UFXkfbDJmfxn5lDXUQPm3J7M8XfmOYSj6xEc0WvIBrhzIt5YvB3W/QmImJbUtNxh+viMEY/TiKx6ibqvH9TVRc4LNnxc851sg5vaT4AcpkhbgOvapYXV4bYaWtmUO1zrPYeOC6QfjkzI8UW5lZ3/f2nJf7keXE4xhyUhC9Lypoy1
 /Fbf6Pv4
 mrWC84+QF0uETptMF+rIDN4+kt1KTP7MNVn4fYss6Ab1TMJYHpzIacOy6xzmJeRlyaoPvby9ggbXIUYcqJmooqjH51eG4+jxAjjBK6NHCZd3fbVsT+bUWC6n4RjB7DhaxI/H7uo8sfs8HuXSC4ZcdoIv2vhT/19qEDFKE+J7fL5RN7115UOPxCVDHrB1IzFlm8NoxOH7n7maXVA9fiYVAMQyB6hMXPmaxrH1CDVxSjpFsinYDgfrPuwPUFp+K6ZXjAjiwB7o2LW1Vaem2aRhwSiR7fwUD82t++YDn8Y7HtbnFap8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 10:34:06PM +0530, Mukesh Pilaniya wrote:
> Hi Mike,
> 
> Thanks for the quick check. I apologies in advance if I am missing
> something obvious.
> 
> On 12/11/26 2:19 pm, Mike Rapoport wrote:
> > On Thu, Nov 12, 2026 at 12:02:05PM +0530, Mukesh Pilaniya wrote:
> >> Hi Mike,
> >>
> >> On 04/11/26 10:20 pm, Mike Rapoport (Microsoft) wrote:
> >>> kexec_add_buffer() users may depend on the order in which memory holes are
> >>> searched. For instance, arm64 places the kernel bottom-up and then
> >>> requires the DTB to be above the kernel.
> >>>
> >>> kho_walk_bootmem() walks the bootmem areas in the order they were
> >>> reserved, so if the kernel lands in a small area at the top of the memory
> >>> there is no room left for the DTB and kexec fails. For example, on an
> >>> arm64 VM with 2G of RAM and kho_bootmem=8M,64M,64M, the lowmem area is
> >>> reserved first at the top of the memory, the kernel image takes most of
> >>> it and kexec fails with
> >>>
> >>>   kexec_file(Image): Could not find any suitable kernel location!
> >>>
> >>> Sort the bootmem areas by address and walk them in ascending order, or in
> >>> descending order for top-down searches, like kexec_walk_resources() does.
> >>>
> >>> Fixes: 3bdecc3c93f9 ("kexec: add KHO support to kexec file loads")
> >>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> >>> ---
> >>>  kernel/liveupdate/kexec_handover.c | 57 ++++++++++++++++++++++++++++++--------
> >>>  1 file changed, 46 insertions(+), 11 deletions(-)
> >>>
> >>> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> >>> index 6f1f55fe31819..2ac5d94f33fd4 100644
> >>> --- a/kernel/liveupdate/kexec_handover.c
> >>> +++ b/kernel/liveupdate/kexec_handover.c
> >>> @@ -26,6 +26,7 @@
> >>>  #include <linux/list.h>
> >>>  #include <linux/memblock.h>
> >>>  #include <linux/page-isolation.h>
> >>> +#include <linux/sort.h>
> >>>  #include <linux/unaligned.h>
> >>>  #include <linux/vmalloc.h>
> >>>  
> >>> @@ -820,6 +821,14 @@ bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
> >>>  	return false;
> >>>  }
> >>>  
> >>> +static int __init kho_bootmem_cmp(const void *_a, const void *_b)
> >>> +{
> >>> +	const struct kho_bootmem *a = _a;
> >>> +	const struct kho_bootmem *b = _b;
> >>> +
> >>> +	return cmp_int(a->addr, b->addr);
> >>> +}
> >>> +
> >>>  /**
> >>>   * kho_reserve_bootmem - Reserve a contiguous chunk of memory for kexec
> >>>   *
> >>> @@ -904,6 +913,9 @@ static void __init kho_reserve_bootmem(void)
> >>>  	 */
> >>>  	kho_bootmem_cnt = i;
> >>>  
> >>> +	sort(kho_bootmem, kho_bootmem_cnt, sizeof(*kho_bootmem),
> >>> +	     kho_bootmem_cmp, NULL);
> >> This only covers the case where this kernel allocated the areas itself.
> >> On a KHO boot the array comes from the previous kernel. A kernel with
> >> this series that is handed over from one without it therefore keeps
> >> walking the areas in reservation order for every following
> >> kexec_file_load, and the arm64 failure you describe comes back until the
> >> next cold boot and vise versa because the ABI string is still
> >> "kho-v4".
> > 
> > If we were able to kexec from a kernel with no reservation ordering, the
> > issue is not there, isn't it?
> IMHO that holds for the image that was just handed over, but maybe not
> for the next one. The producer's last kexec_file_load did place that
> exact Image, DTB and command line through the areas in that order, so I
> agree that reloading the same image from the consumer will find the same
> spot. The order is still arbitrary though, and whether it works seems to
> depend on the size of the image being loaded.
> 
> To give you the case I was looking at: on a QEMU arm64 guest with 4K
> pages, 2 GiB of RAM and kho_bootmem=44M,64M,64M, the 44 MiB lowmem area
> is reserved first, at the top of RAM (0xb8800000). The Image is about
> 38 MiB, and the DTB has to go above it on a 2 MiB boundary, which lands
> exactly on 0xbb400000, the end of that area. The load then fails with
> "kexec_file_load failed: Cannot assign requested address", and the next
> area is never tried, because the walk stops at the first area that
> cannot take the buffer. With the areas walked in address order the same
> image is placed in a lower, larger area and boots. So the first area
> decides, and a few MiB of growth in the Image or a larger DTB is enough
> to flip the result -- which is the part that makes me a bit nervous
> about the first kexec after a handover.

There's always a risk that KHO will run out of bootmem, even presuming we
fixed all our bugs :)

In your example it happens sooner then it should because there's still
free memory that kexec won't use, but it's still the same - we've run out
of bootmem.

I prefer to keep the sorting in the cold boot going forward to save a few
cycles at kexec time, so I'd rather not add sorting to the kexec'ed boot.

So the kernel from 7.5 will have it right and if there's a case when we use
an older stable kernel for the cold boot, and we see that we *really* need
sorting after kexec there we can just add such sort as a fix for stable.

BTW, in your case it's enough to switch lowmem and global sizes to gain a
few megs for future image growth, isn't it?
 
> It also does not settle down the chain, as far as I can tell. A kernel
> booted by KHO never reserves, so it never sorts: B inherits A's order,
> C inherits B's order, and only a cold boot sorts. That makes the same
> binary behave differently depending on how it was started. Sorting in
> kho_mem_retrieve as well would cover it.
> > 
> > And after a cycle of KHO boots to newer kernels we anyway can get to the
> > point when bootmem is not large enough.
> That is the same argument, and it is probably why I am not fully
> convinced that the previous successful kexec covers the ordering case
> either. The inherited state was adequate for the load that produced the
> running kernel, not necessarily for the load it is about to perform.
> 
> >  
> >>> +static int kho_bootmem_walk_top_down(struct kexec_buf *kbuf,
> >>> +				     int (*func)(struct resource *, void *))
> >>>  {
> >>>  	int ret = 0;
> >>> -	int i;
> >>>  
> >>> -	for (i = 0; i < kho_bootmem_cnt; i++) {
> >>> -		struct resource res = {
> >>> -			.start = kho_bootmem[i].addr,
> >>> -			.end = kho_bootmem[i].addr + kho_bootmem[i].size - 1,
> >>> -		};
> >>> +	for (int i = kho_bootmem_cnt - 1; i >= 0; i--) {
> >>
> >> kho_bootmem_cnt is unsigned, but the reverse loops in
> >> kho_reserve_bootmem() and kho_bootmem_walk_top_down() start an int
> >> counter at kho_bootmem_cnt - 1, which for a zero count is UINT_MAX
> >> converted to int.  That conversion is implementation-defined; with the
> >> current compilers it yields -1 and the loop body is skipped.
> > 
> > We never get here with kho_bootmem_cnt == 0.
> Unless I am misreading it, we do, via kho_bootmem=0%. The parser accepts
> it and stores the scale without a zero check, then bootmem_size_update()
> takes the explicit-size branch and assigns the zero-initialised
> bootmem_size_pernode to every node. kho_reserve_bootmem_area() returns
> early for a zero size without recording the area, so kho_bootmem_cnt
> stays 0 and kho_enable is left alone and only the error path clears it.
> 
> kho_locate_mem_hole() is guarded by kho_enable only, so with cnt == 0
> both walks return 0 and the caller turns that into -EADDRNOTAVAIL: KHO
> is enabled with no regions and every kexec_file_load fails with "Cannot
> assign requested address".
> 
> FWIW this became possible with 214f9649 commit, before it the
> zero-sized areas were recorded, so cnt was never 0. The zero-scale patch
> you posted in the v4 series [v3 1/5]thread closes this one.
> 
> >  
> >> How about using this one.
> >> 	for (unsigned int i = kho_bootmem_cnt; i-- > 0;)
> >>
> >> Reviewed-by: Mukesh Pilaniya <mpilaniy@redhat.com>
> > 
> > Thanks!
> >  
> >> -- 
> >> Regards,
> >> Mukesh Pilaniya
> >>
> > 
> 
> -- 
> Regards,
> Mukesh Pilaniya
> 

-- 
Sincerely yours,
Mike.

