Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D12FD606A8B6
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 08:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=blR2ZZkc
Received: by kanga.kvack.org (Postfix)
	id D3CD06B05B6; Thu, 12 Nov 2026 03:49:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D13B66B05D6; Thu, 12 Nov 2026 03:49:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C525E6B05D7; Thu, 12 Nov 2026 03:49:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 989CF6B05B6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:49:56 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 29C5414050D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:49:56 +0000 (UTC)
X-FDA: 85425844392.03.4935813
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7059440004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:49:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=blR2ZZkc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794473394;
	b=J1jA9OuehUJhyq2ost2QdyMlR56SuEPHNbo97aF87awJdPKs/1xSu9PKUGg0FRcf79N9FZ
	ix5XtIabHxdufcxTTKSPhv47TwaLJ9PXtu2fwuFtt4GJPGsqzdlgk3vgsLKoVQ9efAW3Dk
	8zxA+h468Pny6CTUgc5Pny73+Yiac6E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794473394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OGChezwGEAs5VmxdKN/i88B/dah14lbYLutkEhF0lOY=;
	b=RdcJ/+hPOkkEYGkemwqKLNuemScbe4ggYV1LDNEKJ0f7ZO1tqTI70ULjBwouWZQcuJIkj5
	Bq31CMgn2JP14jrZJVQL531k+Rqc1nuHBAyCz8LP0T93BWPkM4rQcaOi2o39ePUfcO/I5H
	Ap/PA6jhZd/aqmOPiwK01IaOIgEQSfM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=blR2ZZkc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AE97D43645;
	Thu, 12 Nov 2026 08:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7AE1F00A05;
	Thu, 12 Nov 2026 08:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794473393;
	bh=OGChezwGEAs5VmxdKN/i88B/dah14lbYLutkEhF0lOY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=blR2ZZkcc/vDDO96F1pNxo2m29Sm1eEE58wpJKJVkHYo/oXT8bnVVxwZZly5gZt9q
	 WjKhsecawJUo7hwiLqoB1tVNvATaSKrnCQij9ms9i4j046DyigYLVgzKpPVW/Tm32u
	 DFsGgSAhvGZFpD7jZe6hMTEs8q6xFGpoAsvodr12hfkgt1d+rnYLrT4Zo91RMnmygO
	 0yruuXkzYrHRiuER+joOHfZNGA23QqvNVf/8ozCvJuVQ3b+UfYkf9kKtv/5ozkNjEA
	 SJWrIn3UVe4emvFMOq5MsjJhsAU82JyD7Ikm8arKDsaA71v1lyHUIdzvm0qEtUhFC4
	 NtcmR0wFZxi0g==
Date: Thu, 12 Nov 2026 10:49:46 +0200
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
Message-ID: <avV9qoaPMBLCNOXD@kernel.org>
References: <20261104-kho-bootmem-sizing-v2-0-b0d1a834780f@kernel.org>
 <20261104-kho-bootmem-sizing-v2-1-b0d1a834780f@kernel.org>
 <990cc079-70ab-4fcf-9974-679aaf07849e@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <990cc079-70ab-4fcf-9974-679aaf07849e@redhat.com>
X-Rspamd-Queue-Id: 7059440004
X-Rspamd-Server: rspam12
X-Stat-Signature: ysmzuaqznrm9oxyju9g7hb4rbfcm5c11
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1794473394-559673
X-HE-Meta: U2FsdGVkX1/CfYWwcI6/u13JdPdsSbAUJ+/F10ccCZGqEv0j/BPOYGOnr8tV9CR84nOxwOlosEF+3OiZdTVurGFAXOo3T5XyjhNnNYpo3t2o9lNh6VcWblRJl5fyGxdR65YeJJZJwUXP/afUXcZd4pVdE6U4ISnOWI+/dUHV/rna0NsUl/aYQWjOXEtNaoYE6dMNmNb+zFSw++S0haaUE1K2Nn6kzQBqZ91JZr3l4Gh5rDERigMzJanac/zBcQGUx0f5ahmStfa1VMSl77p2zEwAIt1uymBJ55dTwI5/0JLPa34XoHPO9SGspAjuFxBk8XksZKTxRHihoS3et3bteGdGaWW8xQHFtWnrtF8dJyoM1FxaVWpvgpFDmQAhuf9XNa/djOkR9qQqkAV2MpOoBin6XlUz8JV3l4Epmp9DnzEbAIsij2Rd79FZ0xFdU3IBZG43uMf+DlX/sEJhnkA1T7zonM6HWsFsGXW4Oi/3kuRE8aaVgo2CskZK+bWMJEXPwIf1Krv/ySYuqUj9zFO5wY1R9Z7bXY+v9uDm6Lh9z6tuGgTHBQwanCfYJMjligl9a+agRS+GWptRC5GRtiaZeTy4kQ/FutzFnBPEebVkh4aOu4XwmbgCExVppEcBfog9VQrkW3azS0XVgpG7xAl1gLDNp/223AbRywQP9Z5ElCZzYwk7YyhBgHdqzm3w/F9l+MqnYw4ysQySVkM1qC7+dVfHNt311RYwIyIrplFUP67w0S+/mrtlIYV9MZQDNq7X4khAj4AhcnaWofYbArmuyIh607nx44osMjCLx4BNhQMFBwuYPbT4nv/kN7LCHZ5JQVVd2quK0XpHX1aTdgpOYB8f55a8ObOgBVZqafWaeEd6d5/gDPOQCjo8CZV5VaoCVHonX9tiB4vKZUQfftRoSE3DZP8nWzGBlUQwq1iDg2cKNTFhJPZR2aJRlEzB9KJfMY+mQIc0G1vPAYK9Rh7
 12JJ5ELG
 4o5eLyBfTv9dvF4II0k3HrSVgCtPX1okOFFlNPrVwDLPW14g/efd4skJZu6sfRge5stS/KI0gLTSGQ5HiAL0t2PonddTljGOA+LL9fVKcyybCRtm+Ml4ecPPC6tqLgfNh0FCPCwbkwsetOYV9p1RtpNZMJUclZRK0RcicZmZgChbikcK6uDhKSdj8Ny2TrIILGf9veFLLm5YnrbwCnr3dA5JYgTRawAjiHtDIzmiHD4aVwc0PhHNpTpM9+mTW0wzz0pFZG85d5CcJYh8xI65nZoGzvwOcbMBkcEkgJNhZWy1XhZOSKd+5i1ti1mJRfbsSFL2T1Z50ZnBdovWFzvzxzV8xxekXBmQqYvBxtpHapA4GNyWUHNvzK9b5XWVqBNClPpP4TuogagYD3WH2hAkTY18QTnlAZUvUtMKX5Aa0y52n+R5IqUzNVVeOFEi8NdOYrmTfaI45M6iV12Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 12:02:05PM +0530, Mukesh Pilaniya wrote:
> Hi Mike,
> 
> On 04/11/26 10:20 pm, Mike Rapoport (Microsoft) wrote:
> > kexec_add_buffer() users may depend on the order in which memory holes are
> > searched. For instance, arm64 places the kernel bottom-up and then
> > requires the DTB to be above the kernel.
> > 
> > kho_walk_bootmem() walks the bootmem areas in the order they were
> > reserved, so if the kernel lands in a small area at the top of the memory
> > there is no room left for the DTB and kexec fails. For example, on an
> > arm64 VM with 2G of RAM and kho_bootmem=8M,64M,64M, the lowmem area is
> > reserved first at the top of the memory, the kernel image takes most of
> > it and kexec fails with
> > 
> >   kexec_file(Image): Could not find any suitable kernel location!
> > 
> > Sort the bootmem areas by address and walk them in ascending order, or in
> > descending order for top-down searches, like kexec_walk_resources() does.
> > 
> > Fixes: 3bdecc3c93f9 ("kexec: add KHO support to kexec file loads")
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  kernel/liveupdate/kexec_handover.c | 57 ++++++++++++++++++++++++++++++--------
> >  1 file changed, 46 insertions(+), 11 deletions(-)
> > 
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> > index 6f1f55fe31819..2ac5d94f33fd4 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -26,6 +26,7 @@
> >  #include <linux/list.h>
> >  #include <linux/memblock.h>
> >  #include <linux/page-isolation.h>
> > +#include <linux/sort.h>
> >  #include <linux/unaligned.h>
> >  #include <linux/vmalloc.h>
> >  
> > @@ -820,6 +821,14 @@ bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
> >  	return false;
> >  }
> >  
> > +static int __init kho_bootmem_cmp(const void *_a, const void *_b)
> > +{
> > +	const struct kho_bootmem *a = _a;
> > +	const struct kho_bootmem *b = _b;
> > +
> > +	return cmp_int(a->addr, b->addr);
> > +}
> > +
> >  /**
> >   * kho_reserve_bootmem - Reserve a contiguous chunk of memory for kexec
> >   *
> > @@ -904,6 +913,9 @@ static void __init kho_reserve_bootmem(void)
> >  	 */
> >  	kho_bootmem_cnt = i;
> >  
> > +	sort(kho_bootmem, kho_bootmem_cnt, sizeof(*kho_bootmem),
> > +	     kho_bootmem_cmp, NULL);
> This only covers the case where this kernel allocated the areas itself.
> On a KHO boot the array comes from the previous kernel. A kernel with
> this series that is handed over from one without it therefore keeps
> walking the areas in reservation order for every following
> kexec_file_load, and the arm64 failure you describe comes back until the
> next cold boot and vise versa because the ABI string is still
> "kho-v4".

If we were able to kexec from a kernel with no reservation ordering, the
issue is not there, isn't it?

And after a cycle of KHO boots to newer kernels we anyway can get to the
point when bootmem is not large enough.
 
> > +static int kho_bootmem_walk_top_down(struct kexec_buf *kbuf,
> > +				     int (*func)(struct resource *, void *))
> >  {
> >  	int ret = 0;
> > -	int i;
> >  
> > -	for (i = 0; i < kho_bootmem_cnt; i++) {
> > -		struct resource res = {
> > -			.start = kho_bootmem[i].addr,
> > -			.end = kho_bootmem[i].addr + kho_bootmem[i].size - 1,
> > -		};
> > +	for (int i = kho_bootmem_cnt - 1; i >= 0; i--) {
>
> kho_bootmem_cnt is unsigned, but the reverse loops in
> kho_reserve_bootmem() and kho_bootmem_walk_top_down() start an int
> counter at kho_bootmem_cnt - 1, which for a zero count is UINT_MAX
> converted to int.  That conversion is implementation-defined; with the
> current compilers it yields -1 and the loop body is skipped.

We never get here with kho_bootmem_cnt == 0.
 
> How about using this one.
> 	for (unsigned int i = kho_bootmem_cnt; i-- > 0;)
> 
> Reviewed-by: Mukesh Pilaniya <mpilaniy@redhat.com>

Thanks!
 
> -- 
> Regards,
> Mukesh Pilaniya
> 

-- 
Sincerely yours,
Mike.

