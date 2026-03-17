Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BEAEFD8755
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 12:14:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13C676B0005; Tue, 17 Mar 2026 08:14:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09EC96B0088; Tue, 17 Mar 2026 08:14:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA86C6B0089; Tue, 17 Mar 2026 08:14:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D20D46B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:14:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2EA471B6C1F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:14:12 +0000 (UTC)
X-FDA: 84555447144.03.F3F85B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7EF111C0002
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:14:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ows9e84F;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773749650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0jxMNeD+XvOscmoxPWl3tQ4UM3/rwmlnhkwX+6Q+sMk=;
	b=2FJfjviG/n4eiIOttjWh+rkIfb0BgCpnDzTxLu9coSO/MKyEx2Z3QVJ4B+RrrcKtk2H8kX
	H2O8xT4KRKIn3I+tHjyFk6C1c6i0dyrhhAtvJ+GIvAI0iq93KgML9Vi0ZcE8W6be1I9+dX
	B2b/rGPVWuQ+vdBkNSie/Z8jEdUGUSU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ows9e84F;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773749650; a=rsa-sha256;
	cv=none;
	b=m0Kh96pyVQQEiMm1EXO1a4rUQWQ7uAsT4UIF9CMcEaTGlMn5J/mPjJLfdNKCX/LIykdUqt
	08Ep1rbv09dGPzMXOwmNnPLUDy3XnVsA8JhmyYIsp35u6GEFiRrbzR5JC4/1IGRgVOHUet
	hPEj2VXqT/TSp4iPLrI26cfzuqsD3hQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C8DF860134;
	Tue, 17 Mar 2026 12:14:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213DAC19425;
	Tue, 17 Mar 2026 12:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773749649;
	bh=h2yNj/JlK8uUWz6oueVZrppiSDLJqWd0uEjVTtCBuyY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ows9e84F4eolPF6a0yRJ+ZioFE3OdIGV4p+J5awFCnKRj03CyNoc3Wix4W1oioAV1
	 KByL/Fg9tQPh1ZWFCVDaxlCyK9TBDIwiKbYJ2MrphlT4seY33NXo0fDys6FIPxTAui
	 4VhYIIbPQgodQ9d22mzQtI3uz/IFAaiwAli+8oFtQdIgcJBgMZrPyJB3l06FH6w1iZ
	 8xBru0mGQwGukYjkrOCjb4McWDPbbXYY8JNGcmI0s5j9lnTKGYOhqom29VRQyJlZjO
	 NDD5qPNMMi5yR3mBjdrRBpd9mvw/DfdVIwGmncQY2vnEaf6wndQ5V58hyLRLS8gH9q
	 Q9RIEtdQgEi/A==
Date: Tue, 17 Mar 2026 12:13:59 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Mateusz Guzik <mjguzik@gmail.com>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH mm-hotfixes] mm/zswap: add missing kunmap_local()
Message-ID: <4587357e-e503-4a01-ae2c-df4ebd2c24a7@lucifer.local>
References: <20260316140122.339697-1-ljs@kernel.org>
 <a4973bb0-9286-4b49-9e53-656eec2e9d93@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a4973bb0-9286-4b49-9e53-656eec2e9d93@lucifer.local>
X-Stat-Signature: hbta9acqw8fjnce4h7ps3m4cnfcy1o1q
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 7EF111C0002
X-HE-Tag: 1773749650-458761
X-HE-Meta: U2FsdGVkX18ZT9CM0CB+NvSFW8mThzSNnTXmce2sfho+pCbzy1eKLWzreXEphtW5sFJZuWI2+AJbC/xfqItp/1jveCtTVOK1d3Mca9r4vuFMkzkY9c85l/EBcmqbxNIQXwXJr4JukOmrXqvkoO67B4806eJrh+5iabKVRT8+uU0/7NLvShZsflxUCBaa2lM9TdN46OuIGMLzMuvDPWmRcgzGfWECD/acUnb+eZN5VDVfuy50PgRwBhIjYiCaAdr2zzzBkNYuLz4qZoly602mrDYrq7hYvYGJOwoP4eXYcgG5HdGyB08c9iD12bFV2nJ79ePOI7Ux50SVoy0KtM/cMoHpnEJiDbDEJE/Hv73843aqbCOl3HPgJsfEXisYvRjPc9l7V/NvNkpsjoV4j29P2JcR1s253vD1p4MxS28zjgF6CGH0ILUUXhFYjnGgQSmOucnsbMFaeqJ/+6mdCFP9oJ6AmfQZSqwLJuHT1qz+5SSrTPPxShT/RL84S3AfP4tBG42f2KuM/CsW0CgJZgxlTIaEJUpbSJ6/ft1E9C/m2IEf2FvwPbgc6M2L9iBLbTy1I/RArC/BRFPPqrWykkp7rqfhTBSdVkPEAUzTbdtZ9eRjGQYMPnKlrUfe6o4Dw60wIpcWVVS5DHg5CPO/H7J8ic3q0BrsAWSfsAUjgp0OVStTqKrmxcLwvzBlPgwxZzCwq4OH7Kvia1qxCk60kx3K8vLO3tHqdfMrXITXt71BdKqLW8hbWBlkXJIa1YdC4fqCw0adfNbX1vw8Z1F7YUQNbRcogwAELOndE10lapQRVD26c10qFESGa1aTJbOl0rChHj8LSdHrBH9pZi7Qlsz3247dJlRzaZ0S/ZOe32ZmS9RkWUG6eR+6422mX2dZC2+3fj6vaNVEtmikahEA9qqQr8vwv3yvB9QpsymHYnoyGXmQ3vanlNpOUry58fXyPpNEpoMwQag/jfIsClqawBi
 XBBc1Os+
 a71M3mgQNyr3FdSo9s0eQheWnxOFxagUmOx8Dngd+n8grvtxYip8Iq5laG/vSdpWN9Q9duihmHuaLYEnrcgRNnwHBBTI/uboAsLAGpXi3sVSaWctc/q1Hb1pLkahQr8e0kDHhlTtxkO+kmTyaN7Sx9d9awVHxEmfJm4iZ04AW2s9ofrU103/qsW6OuNre91SkBR7OHLBMS2y5rUiOkIJXf3BdFUqFbB1lLk3zS7jiMzekwtct2yFC1aFjX6Y80RHUsuQKgXVFbxbshvThKDNa6TdB+huPtABENA4I8xYD9fEcpAKwYyxGSZ/yjhx1Ehycpe1s+jG+O9pXQMSMG4q7vI4RJ6UAYYAJAhd3rK2vabubLKn3rvCQsPZ8wmKWl4ht+ZM8wXo6JC9PYQMoooBjTr304g3akeIBWwdK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 10:01:19AM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Mon, Mar 16, 2026 at 02:01:22PM +0000, Lorenzo Stoakes (Oracle) wrote:
> > Commit e2c3b6b21c77 ("mm: zswap: use SG list decompression APIs from
> > zsmalloc") updated zswap_decompress() to use the scatterwalk API to copy
> > data for uncompressed pages.
> >
> > In doing so, it mapped kernel memory locally for 32-bit kernels using
> > kmap_local_folio(), however it never unmapped this memory.
> >
> > This resulted in the linked syzbot report where a BUG_ON() is triggered due
> > to leaking the kmap slot.
> >
> > This patch fixes the issue by explicitly unmapping the established kmap.
> >
> > Reported-by: syzbot+fe426bef95363177631d@syzkaller.appspotmail.com
> > Closes: https://lore.kernel.org/all/69b75e2c.050a0220.12d28.015a.GAE@google.com
> > Fixes: e2c3b6b21c77 ("mm: zswap: use SG list decompression APIs from zsmalloc")
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > ---
> >  mm/zswap.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index e6ec3295bdb0..499520f65ff0 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -942,9 +942,14 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
> >
> >  	/* zswap entries of length PAGE_SIZE are not compressed. */
> >  	if (entry->length == PAGE_SIZE) {
> > +		void *dst;
> > +
> >  		WARN_ON_ONCE(input->length != PAGE_SIZE);
> > -		memcpy_from_sglist(kmap_local_folio(folio, 0), input, 0, PAGE_SIZE);
> > +
> > +		dst = kmap_local_folio(folio, 0);
> > +		memcpy_from_sglist(dst, input, 0, PAGE_SIZE);
> >  		dlen = PAGE_SIZE;
> > +		kunmap_local(dst);
>
> FYI to address (in advance) the AI review from [0] which a couple people made me
> aware of - we don't need a flush_dcache_folio() here, because the folio is not
> yet accessible by userspace, so we can't have virtual aliasing of the folio's
> physical address on VIVT architectures.
>
> Examining call paths:
>
> zswap_writeback_entry() -> only calls zswap_decompress() if allocated
> -> zswap_decompress()
>
> swap_vma_readahead() -> only calls swap_read_folio() if allocated
> swap_cluster_readahead() -> only calls swap_read_folio() if allocated
> read_swap_cache_async() ->  only calls swap_read_folio() if allocated
> do_swap_page() -> called in path where folio allocated
> shmem_swap_alloc_folio() -> as name implies, allocated folio
> -> swap_read_folio()
> -> zswap_load()
> -> zswap_decompress()
>
> So actually no longer doing this is a de-pessimisation ;)

On second thoughts, I'm wrong, this is required. The documentation is really not
clear on this, which is a problem given how horribly fiddly this is.

https://docs.kernel.org/core-api/cachetlb.html it super vague on
update_mmu_cache_range() -

"At the end of every page fault, this routine is invoked to tell the
architecture specific code that translations now exists in the software page
tables for address space “vma->vm_mm” at virtual address “address” for “nr”
consecutive pages."

It doesn't mention that you really need to have invoked dcache flushes in
advance for anything you changed, and that the architecture may then choose to
not do anything at this point otherwise.

Anyway, I'll send a fix-patch.

Cheers, Lorenzo

