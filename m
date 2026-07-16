Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16F1FC44515
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:09:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73BA76B013B; Thu, 16 Jul 2026 11:09:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C68B6B013D; Thu, 16 Jul 2026 11:09:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 517DF6B013E; Thu, 16 Jul 2026 11:09:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 02B746B013B
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:09:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6FDCEC0119
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:31:46 +0000 (UTC)
X-FDA: 84994425012.30.8087419
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id BDF44140014
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:31:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CU8PyQnp;
	spf=pass (imf09.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784201504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZhTPrG3YQEfBVn0yyzrLN6C3o96SAGlfQ2/4r1lWCWQ=;
	b=TsoCAbWgD+eGCUTeJ3oJIbYPRqhFDDv6YRM+zJY0sIPfWKKjREen8T5sm9DAYu/rFZWP+J
	bdjK2SjAqDmNKqhNTjSed7uGMtLdFaPYFecdX6b666CFercfPH1TVSsN6qLm+8ZZYDGlq7
	82ePGbb0lZu+l4aQZ0joJLPdIiw6A3U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CU8PyQnp;
	spf=pass (imf09.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784201504;
	b=BbeGSwi6kmtSJyVwv0G2DiKyvFjlKld3DcKyQkRJjdzFIDFEGT9jWm5zwhn3QGb84eW4yu
	EGEADB9IQir+6bq6FH06jcBkayGyyHVY8Aar+0yb3b/AWNqE4+eTBlLe3jtx4sOoRpeTSc
	2cDRqcos+aIBC1SqO2tNxD3jI945Tac=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E6FC84186F;
	Thu, 16 Jul 2026 11:31:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECA71F00A3A;
	Thu, 16 Jul 2026 11:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784201503;
	bh=ZhTPrG3YQEfBVn0yyzrLN6C3o96SAGlfQ2/4r1lWCWQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CU8PyQnpbvCRE3vUmMHtzieTpGX2UBTMwb0mi88LgLxkSs8B/ksftCcM5iz3NUd7A
	 fb8sHvnwCl7Rr4+CQEHwLGQjWOD3HXM5jPd5Cc8rCwwABcs8eQ+BKe0BjntQ/EVekx
	 dCYd2NVN2TxTIh+bleHc9Mrq3zRtYkVxaE0UqGfb4CkNFltxw8JAppM9iqDmYpCTt0
	 gr4x6uAHVmNLV4MlaNFHizKmi/tvmxJdDgxQqcFCa06FzxAgCNdY51pKLaGwJPAlOY
	 1KPwHyfp5KJywmQSfRSQ0QHUlhb6Srefcz+e9NxqkaeYr/Q75MW2N2bjgJnsxF9rfo
	 ndpfdliuZ0loQ==
Date: Thu, 16 Jul 2026 12:31:35 +0100
From: Will Deacon <will@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>,
	Toshi Kani <toshi.kani@hpe.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dev Jain <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>,
	David Carlier <devnexen@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
	abarnas@google.com
Subject: Re: [PATCH mm-hotfixes v3 2/4] x86/mm/pat: acquire mmap lock on page
 table free to avoid ptdump UAF
Message-ID: <aljBF-am7dqqG8Gd@willie-the-truck>
References: <20260714-series-vmap-race-fix-v3-0-b812eccfa0f9@kernel.org>
 <20260714-series-vmap-race-fix-v3-2-b812eccfa0f9@kernel.org>
 <alemS7vxeRB7NcBO@willie-the-truck>
 <alesCtwXdIqH6bOP@kernel.org>
 <178419641178.59347.17339330762419756196.b4-reply@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178419641178.59347.17339330762419756196.b4-reply@b4>
X-Stat-Signature: pojfeeyaub69yn3jcff4j7hwcn8xqpqz
X-Rspamd-Queue-Id: BDF44140014
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784201504-330380
X-HE-Meta: U2FsdGVkX19hMJoQikiLVMp5ewJK5WbO9wuL39zAzTO0dp4KnO5fNyRLZufbsEJgSbDkR74GS2qwjcb3GBjYmTubJP5vxuSlDjKjQONa5CP6qTZI3UN58COHYrHQpQb1pArd5fJM22h1YRsMPDy4/MID9FiLUku/9rFV5XUnXI/iXHWXwXI0Hx+4lPvjoxW+ByjX/tXsO9riv+GRw3jmgkC2i7ULqfL/AevbYJIKv9p8cTQUeVa22TMzFlnyFoVNHHL372+IJ5qbZbb5Pm/zoz/s4G1jhiJ5NzE0yOHHVuVX9FMQONdk/ZYIvQ8qkoDcA+h4gy9nhCCrAd6hvh38NdNUbSy6MpUBJNzcfpbNH14e8hx1FZqO72SFrFdbemPmoDDRP2AwoNyYz65WzKEbhbZb/zpJXUqDZeqfJt6+H21sNit31uBJAAZDhHa3/iW8B5Nu57QqNIRf613Iok0wysIP2B/Y71nNjuPMik09nvYN292fZrsK07BQO683nzkwC3wgYSkm62bWMSXG2lv+Otg34aeuVvs1hYeqVc78JFl22mCC9IzHHYRXSaiaONQkzaepN8m96LRgB+uLILTTXonKCoH5fVaUAQmhEJmBrMYYAS3Xe9Op94VDzq9N8UnNR+2S3xXW++wspSD7j7VKmKB+dzdzZyNWwy+M2T47O74QTErLlBMgyNsecJcawSaUEkAo6o+h05Rs+0RdtLwl+tO2S9i/pT80GGbDrrm9KqZJAJb8I8Avx2eeZLo0RdBSZrLMpcWuM/o0PEhDP5bPGNP13Ob86KZOLUNkUGBK6/sK97yg+oR6tElvLD2XlxyItA4hLHmKyoBOkqN3GTBqqCZZ3m0x5SECG5+0iNd9J8Vw6IBwy/ZD25kUKG97o8v9Y41X6CkDDzOblehXSOHFBDTaR34BbLd65CGCwYmwL0DJ8DXoaIdp9OtTmmLbAs6tdq+5Nb0GZ1MHHYVLqt3
 AyPntZA3
 sxX/v1CGcdnINqRpv82K7Gvxu8edpE++Z30y/g0biyqAuxuCcpCYasugGH+bDM1w0c+hrJYcmPiha8U3LtkLxtemdQ4oQkihL8SsGQE9qDIAuwiNJwO4EWTekqKjqigT8mQJpbSWidKVlgnGPWpNOwjdfbyCGL2YksPdIbqfvkit8X0f606xZ0VoXcLfBOCe1FJT8oKvtD0xkeOQg4vVhfQR0wA1HKUoCEyk5j70atPj660dpkuQFQfDmLSNR2u/A51SOzFjIumHAwEoEw2RtmwbUqOrqGyuKme0dpC2IVwg639DReLbverkC2tXP/RcnMnS1TYBrHCEkDHoPiomFZYygag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 11:06:51AM +0100, Lorenzo Stoakes (ARM) wrote:
> On 2026-07-15 18:49 +0300, Mike Rapoport wrote:
> > On Wed, Jul 15, 2026 at 04:24:59PM +0100, Will Deacon wrote:
> > > > diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> > > > index d023a40a1e03..4c4b8244502f 100644
> > > > --- a/arch/x86/mm/pat/set_memory.c
> > > > +++ b/arch/x86/mm/pat/set_memory.c
> > > > @@ -22,6 +22,7 @@
> > > >  #include <linux/cc_platform.h>
> > > >  #include <linux/set_memory.h>
> > > >  #include <linux/memregion.h>
> > > > +#include <linux/cleanup.h>
> > > >
> > > >  #include <asm/e820/api.h>
> > > >  #include <asm/processor.h>
> > > > @@ -436,9 +437,16 @@ static void cpa_collapse_large_pages(struct cpa_data *cpa)
> > > >
> > > >  	flush_tlb_all();
> > > >
> > > > -	list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
> > > > -		list_del(&ptdesc->pt_list);
> > > > -		pagetable_free(ptdesc);
> > > > +	/*
> > > > +	 * ptdump might read these page tables, so avoid a use-after-free by
> > > > +	 * acquiring the mmap read lock on init_mm (ptdump acquires the mmap
> > > > +	 * write lock).
> > > > +	 */
> > > > +	scoped_guard(mmap_read_lock, &init_mm) {
> > > > +		list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
> > > > +			list_del(&ptdesc->pt_list);
> > > > +			pagetable_free(ptdesc);
> > > > +		}
> > >
> > > As I understand it, the argument for taking the read lock is that we're
> > > operating on a region that we "wholly own" and therefore we can happily
> > > run concurrently with CPUs walking distinct parts of the page-table.
> > > However, from what I can tell, the CPA collapse logic will operate on
> > > regions outside of the address range being manipulated by its caller
> > > because it rounds up to the PMD size.
> > >
> > > As a made-up example, imagine I have a 2MiB aligned region where the
> > > first 1MiB is read-only and the second 1MiB is in the default r/w state.
> > > If one CPU calls set_memory_rw() on the first 1MiB while another CPU is
> > > walking the second 1MiB (via some other API that doesn't take cpa_lock),
> > > it looks to me like the first CPU can collapse the page-table and free
> > > the unused pages under the feet of the other CPU. What prevents that
> > > from happening?
> >
> > Nothing, and there's a patch to fix that that synchronizes
> > cpa_collapse_large_pages() using cpa_lock:
> >
> > https://lore.kernel.org/all/20260626163213.2284080-1-den@openvz.org

Hmm, but that relies on all concurrent walkers taking cpa_lock, no? Surely
that's not generally the case.

> Thanks Mike!
> 
> >
> > This still won't be enough to sync with ptdump though.
> 
> Yeah, so this patch is still necessary.
> 
> But that patch conflicts with this one as it holds a spin lock over the page
> table freeing, which prevents taking an rwsem... :/
> 
> Anyway I think this one is still fine as it seems there's not a consensus over
> there as there was discussion about just removing the locking anyway ([0])?
> 
> So can kick that can down the road and just get these ptdump bugs fixed :)
> 
> >
> > > If all concurrent walkers have interrupts disabled, I guess the TLB
> > > invalidation logic would do it, but it would be good to call this out in
> > > the commit message because it's not clear to me why the read_lock is
> > > sufficient for the collapsing case.
> 
> Yeah, so this patch is _only_ fixing the ptdump case. Any existing bug must be
> addressed separately.

Up to you folks, but if you took the write lock during collapse wouldn't
that fix it for all concurrent walkers and we wouldn't need another patch?

I would argue that using the read lock here directly contradicts the
rationale for why this is safe, because this is an occurence of code
that operates on a range that it doesn't wholly own. It seems bizarre
to me to go to the effort of adding locking, but then not adding
sufficient locking for all concurrent walkers.

Will

