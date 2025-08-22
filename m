Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A393CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 15:10:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B858E6B0122; Fri, 22 Aug 2025 11:10:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B359B8E009D; Fri, 22 Aug 2025 11:10:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A73B06B0124; Fri, 22 Aug 2025 11:10:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 95A4A6B0122
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:10:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3259814020A
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:10:45 +0000 (UTC)
X-FDA: 83804730450.10.5204978
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 80CD420011
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:10:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MfKWAMlW;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755875443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7oUqMfc5Rr6TMbgE/wenfxbF6AVX4t+wpxIGqlOIW+c=;
	b=BBH4FC1HLQ/5+x1DANfgpKa1ZThtLS4Ty42EQfYf21jNg14DN8IUfWGQZUSU8gEEmJB4bF
	1ktSj4ptuW24Te4ihHOneJmFCAAd5hjPakPgtyyaZ/6jiO0INF8AEhhCbhUInelNviRJpH
	oKjR8cAkJjyvry9iQMOy6/LaWZ4Oap0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MfKWAMlW;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755875443; a=rsa-sha256;
	cv=none;
	b=YQ9/f6MJ2ev5VCvoAZwjdoJEX4oZLGO+pXzOKiodhKpbpT3TN+N/Fotd8isz+6ZiIGmPQv
	Kl3QNDRLHjgfk2EHTaCYHq0JdZY4OLz53s6LQa4ZcK79IX22Cm8R72xSL3X23qzHmoqNiz
	omlhmuc4GgTY7PrSK59vfBQttEtmQFI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5905E44023;
	Fri, 22 Aug 2025 15:10:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA78EC4CEED;
	Fri, 22 Aug 2025 15:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755875442;
	bh=CAY5DlsOHyGeAuJSXFXVAByj59QIAOw2AekVjj0R+b4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MfKWAMlWZSLolf5Er8IdYEE5zQV86o5SRIWNfuGwAevHaro0KNr+O0AUudzUFXmc3
	 fsRmTkuzMKyOWmo+8Ib/4pg6uAO607N85i/ZR6XdaP13USRH/bc4QgbG247YDVGntr
	 dIuimCsUgCJa1CldCgolX2CMa2bqt+CMes53Pgq69q6mqbsJBHuaoP74dMUUlUNsww
	 SqsEK32SbicopH2MuZVGLxcSstv41b7vIfL/1490jZeCkzm9ukqxF1GXRENu39XO4p
	 GF/7+asbsxkyC7LQAOGokPKRMO8cxy0hNc1JtEMo2NFHS86o6qSj3ySEtrOWX+tEVg
	 yHfXvZ0oyq//A==
Date: Fri, 22 Aug 2025 18:10:24 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH RFC 02/35] arm64: Kconfig: drop superfluous "select
 SPARSEMEM_VMEMMAP"
Message-ID: <aKiIYJoshnWwrJQ3@kernel.org>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-3-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821200701.1329277-3-david@redhat.com>
X-Stat-Signature: 3ih6yusegdbpbnjsc6p3f6nijndgnyfi
X-Rspam-User: 
X-Rspamd-Queue-Id: 80CD420011
X-Rspamd-Server: rspam05
X-HE-Tag: 1755875443-29944
X-HE-Meta: U2FsdGVkX18LSEr4JD+X220XlkmoGy5myzYgdJm91ugyn8sTZnI/6mGwuZ12Rmb+P79zYP24ibQjIJFqejtNtbN3FhRZxCglb1+BFkoqKf/FGN3QTyvqxVswx0KynPGbnJ3WqeGIpdtD5ly2o03NO5DvMCAXNprInscydGej/zHasKnUXOHol7wCC/pxWnU3Kmb6xf8BAH+2HwhQZACWc5+Cb2ndv/0xVyQH4jz5qau1g1HjIitqlV81XxxS5R5ht+KUlh3YfXrz2esUnCuX9Slx8LBcj38U2+iewKH0eZqg7GXdn2iZwUKTIRnh3A3qdZoa+tf/nHVNjbNLHIxPjPc+vs9UvMd81HIq71PEy+eyQlyM0wVkgSrfAmmF0L0hnkxNXsu2Zhba7zL+pJ+KUGoiRaV/Y+OQWpckvzKzP7GM04w+I6ffhHjjW65bHGnB2iS9uzWj4rOjWqm834pSRmak/ZtjNBSgQz8YFFgwco0OdCL5tHzMLKi3mAOY09XfICYRfqoGnNZAEgQkykbCu3fosNB5KljTBglBhCZZkxmYqGNuAV7MP43ZSe3FccnwcmUfZBzsT7a4HA0VGtQTU07uvSPioLmt3yIxe5RpF5VBXYyco7W189xFE1nAx2+rsCwvdLN+DXMW2Zzw/DSlfVGREmShj8LZGj49V9EPwp7UdmBeS0z0Vvcs5chBBAED1B8R8/rZIcV5jzml5FA6YjFri6tyLTN3uaaazDTGXHzDTDeHBNAQWFBGfotcxtkEjLD3PckPJz5b0hWeqGEAoJzBvTCGkFP/8N5bAxhVgqY8PLawvEB5NkRxWWHfrNQYKmE4Uw4iE5XJDwJQVssqrcf2GIUm6gLcUI+iZq84r2t6XySx6zSyB3E56u5P2tt/WuxaN+uRRsXX1OpGJLaQqPaPhmDQX75iXml1CeeVdNW8r63zCuQp0MmsFWwyuNIvugib4LNVTANaQQhoVmg
 PhWBSGaY
 VjAthSv+S3hHBhdcxl2Q56SZeJpSh3CyA/Y6B1VFJRcuHhyC87m6zBTkH+HgIvKMt5p5IRTdXiI5rAXwlZ8kDxFmYOtgHtKYL/rd+1Jnvw6PXEf3F1FkpI7wTxU7D0wbZJ/woqHx3Ru+2qQJLgQmxLRq+JaNstJwLwkugj5xs50XL9En4HegAL8SqGO3sri6YzYNXy66GJqtxNeAdSGMYVoVdB0rSJoKzctvvn8kp2hN1sBo4aDAomvnXKLbS/7XfNYFj5IYmxT3JlTVEVWKvJmhzcx7qhCaBm6HimhMPXMot7vrs15mtnZS18S7sJqzm/IhoqeitBQC1er0hR0aZJHiqjLKmBx6tHMYqUuVJlxGTh+3IrvCuVRy+4BOKCi/RTGNgoNlsGuAtLMu0QZyBMXy2Mwuzot5MuvT3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 10:06:28PM +0200, David Hildenbrand wrote:
> Now handled by the core automatically once SPARSEMEM_VMEMMAP_ENABLE
> is selected.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  arch/arm64/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index e9bbfacc35a64..b1d1f2ff2493b 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1570,7 +1570,6 @@ source "kernel/Kconfig.hz"
>  config ARCH_SPARSEMEM_ENABLE
>  	def_bool y
>  	select SPARSEMEM_VMEMMAP_ENABLE
> -	select SPARSEMEM_VMEMMAP
>  
>  config HW_PERF_EVENTS
>  	def_bool y
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

