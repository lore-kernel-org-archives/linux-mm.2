Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEBFBD25042
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 07:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAAAE6B0088; Mon, 12 Jan 2026 02:35:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8C9B6B0089; Mon, 12 Jan 2026 02:35:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B98496B008A; Mon, 12 Jan 2026 02:35:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A90C86B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 02:35:06 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 10447B9630
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 07:35:06 +0000 (UTC)
X-FDA: 84322500612.25.A0D19A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 578FCC0003
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 07:35:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cB9JlNOs;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768203304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MpZZgA7Z9Th48hWh+uWd3ploF1QFnvsBfVrDzcsw5WM=;
	b=W18Ez7V2/cztJP/0QoD2g7uVEaPzDXPuk1fwYDVBVMHaKsGy68EiKEj5Uf0/o3Ubzp5Mgq
	pQragARJpQA0cD5gjqM0ghS1SQmBI8wQ9GyGIA/v4IbD/QRdOaswar0yt5kchdvpjLKOCA
	PCilYVooqAAvuh0Oc5RYIKvLVJb53k0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cB9JlNOs;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768203304; a=rsa-sha256;
	cv=none;
	b=OJMmXVjYmGvO03WOShNaluNCaRsCc32A32ymo171HyNPpKIM9hoke9y3TRXBpLfZEjax7H
	nPjl3hlAQMTYom8dIQ9N4Ax8hQtZigSIyUblqwyWfl0XgIGofagfKvYcXJ2sRTyNn3KqZI
	y4+kH1VhfG5BEgqPBBn9iKzAySfZZuA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1CBFE43C1F;
	Mon, 12 Jan 2026 07:35:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61041C19422;
	Mon, 12 Jan 2026 07:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768203303;
	bh=H0wpDyU4+hGvGadEaJXaoKwU4fABU87rkRhUJIykrtE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cB9JlNOsE5ASTDSwfciaJvBRecBB1lB0Uwj+GaWwyCjgypyJQWPdkiELZQ8iVJPfz
	 nMocJbirHN/1lk3J7Si3fdDg+XjkNRlIqWpD36vowiVH0S+GvTZEHLt/X4w6L2bjbX
	 MW70tMpH6LtqJ9xirliNmH6ey3Jn3uobFlK0X2Mc7rV2i4ddTSmSf1HxKEBm5toCRi
	 d46Yvu6ZlmDb9ZF7jcWZyute2z21cTSvo7YbjPFCodLjqoxUiSIWkDnwdalYjHh76y
	 ow7pMfD3F6CiXLdHJYJqrOQj4clSEc/bsWScF8TIIT22yhLrTWzvu1RJLquyFnQ26r
	 U5L75tv4dABXw==
Date: Mon, 12 Jan 2026 09:34:40 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Shi <alexs@kernel.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Borislav Petkov <bp@alien8.de>, Brian Cain <bcain@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guo Ren <guoren@kernel.org>, Heiko Carstens <hca@linux.ibm.com>,
	Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Klara Modin <klarasmodin@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matt Turner <mattst88@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Stafford Horne <shorne@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vasily Gorbik <gor@linux.ibm.com>, Vineet Gupta <vgupta@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
	x86@kernel.org, linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
	linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
	linux-mm@kvack.org, linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-snps-arc@lists.infradead.org, linux-um@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
	sparclinux@vger.kernel.org
Subject: Re: [PATCH v3 17/29] s390: introduce arch_zone_limits_init()
Message-ID: <aWSkELL7xJ04QAct@kernel.org>
References: <20260111082105.290734-1-rppt@kernel.org>
 <20260111082105.290734-18-rppt@kernel.org>
 <b211f877-f9bb-4892-b67c-d2610048575a-agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b211f877-f9bb-4892-b67c-d2610048575a-agordeev@linux.ibm.com>
X-Stat-Signature: wzy3karyb76q4g46deqn11qepctw6d54
X-Rspam-User: 
X-Rspamd-Queue-Id: 578FCC0003
X-Rspamd-Server: rspam08
X-HE-Tag: 1768203304-195907
X-HE-Meta: U2FsdGVkX19osXli80mAIrgg13NyG3svlhxBicc0l6hAVFAWB0wZSI7N3x8TCl0GTS7Zz84I8TQxWRtSvxSkgibtmzMBVBPUHofZW6hz3mlZZ6sieaeVnHnNylcaqQMqy+cYf8KB+sPLTs6XdyZhuV9U6HsxW0mLKTkuLdyeo4QmBjrJrZ91r+wqXNENmG44rVBQs0a2iaMnTVj3EOzIMoHwYksV3O6vuV7KyAlA0/zC/F1jpHCQJzUGCfPc9LrFlnfQwx9V99g1c2/YOa3LerwWnWixPDEJHDNNKs05KHJ2P3dvNoT/MyZm33Pp/fxUzT6KQkYy1WXXgZS+KvAbpvNzlkYCN3ZKculIuxA1GBNkVD9edqP+mKjck4BG4v+T7cY0JLpgoU/lK3/95EW9hRzYxsS0g8FEQLv8MuPX+LOpBY9z/6x3PJ4RPeHtraQyNlVx3Zz02NhgMC+lDEm1S5qKqx77Ndtu9sNzfmpINaDCMA/K1+mwIv/Rrzv8oaXVrJ1fg1ye/+TePtTrdn06/T/56xElAsjQAva+2W2wrbALGu/v+Xu6ZDzKen5pGBHW/2b6SQh4hwRYf56zhxz5RD5eQU2inofJfsKLSYEmp8iaZBnz2B0B3d6U4A/aFfDnDwdEwlLXrzoefOHGiikP5msyQy/CdQVJeNKgq7x9MwJx3h2cbZt5NkTh1mPpyW7vbkTSpgOYieK6rdJi8H1tdm9WJbDuma4AiiPoFy7RU8MptFR3Exn2bvs7nbZK9ixAjsYvMpJ1dMfUUt/eMU0DZZwbiG3G6iqtZZFP/1AfV4o5q/YbdkwOVPMIZBZr4DMxSnvF8hvwlfJPIeSPCpAih34bn/jRVy/kQZTHqOFOH+pHSCnjRDa6LTIrP1TQBE+vYQZgVO1qZSf3Mwabi8TWPEKZxKIhDNzBnb2FtepfOAGfmZjBVPFFg+VUZN+qZsPFoZ71TvPtE2FiVDYmhex
 JqlsiZ+l
 CrNvS9Lmx+ECezUfJVmjilPmEKkVLi7WJPXL/4JI0H1icLRHweORIbWF1g9bJeEJZwltPlBvOdk3wQTDSYuQQ1oSsL+MW4FCFDDNkGQtzWluqhXXOBF88vFdyVV+PLA93cbysK6kI8/Xv/21btkrxTQZ5KSyn141gle9eVr6yS+WFPJa40Nwno9kdcgUcdOHPxDGnjRKnL4+EnMo7RU3RZAKsgkwbNBBOy0sH8124Q01VCOyc1VpzpquCCadS3VcnNMNd9ihmY92bDzcU6us/wD5G50fjNLTfdUMvbPiRaS2jtBo/uTmN3TsILnzdo6b6fZeMheLblIV94DEZWWS6qSmkgixmM+HKiTd8V6IMop8k83RUMDuZZB9xMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Mon, Jan 12, 2026 at 08:02:48AM +0100, Alexander Gordeev wrote:
> On Sun, Jan 11, 2026 at 10:20:51AM +0200, Mike Rapoport wrote:
> 
> Hi Mike,
> 
> ...
> > +void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
> > +{
> > +	max_zone_pfns[ZONE_DMA] = virt_to_pfn(MAX_DMA_ADDRESS);
> > +	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
> > +}
> > +
> >  /*
> >   * paging_init() sets up the page tables
> >   */
> > @@ -97,8 +103,7 @@ void __init paging_init(void)
> >  	sparse_init();
> >  	zone_dma_limit = DMA_BIT_MASK(31);
> >  	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
> > -	max_zone_pfns[ZONE_DMA] = virt_to_pfn(MAX_DMA_ADDRESS);
> > -	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
> > +	arch_zone_limits_init(max_zone_pfns);
> 
> You move initialization of max_zone_pfns[] to a function, name the
> function arch_zone_limits_init(), but leave the initializatio of
> max_zone_pfns[] to zeroes outside. Should not it be brought along?

The idea is that is the caller responsibility to initialize max_zone_pfns
to zero. After patch 24: "arch, mm: consolidate initialization of
SPARSE memory model" there is a single caller of arch_zone_limits_init()
and having initialization of max_zone_pfns() there is more optimal than
having 20-something of those.
 
> >  	free_area_init(max_zone_pfns);
> >  }
> 
> Thanks!

-- 
Sincerely yours,
Mike.

