Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 471CFCA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 15:09:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B0E46B011F; Fri, 22 Aug 2025 11:09:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 789448E009D; Fri, 22 Aug 2025 11:09:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C6FC6B0122; Fri, 22 Aug 2025 11:09:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5BEA06B011F
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 11:09:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0D08A137F85
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:09:28 +0000 (UTC)
X-FDA: 83804727216.07.71ED16C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 378AD1C000D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:09:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Prntf9uZ;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755875366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vCOsOz88mPScACBG1/CQZuInDpdXn6Z4TRAWSkNAAYc=;
	b=L4PSM/+FFY/HlzWdCdfnOwdB04SpmLTwIZqUqEQylaBmUqcv61IH54GzqR7HlzelY+v/as
	7Knx4apXRnbT71VxX8BupaxtjzSOrevErQJXx5RQ2l07u8hU5yOSCleo4as/gRPXN6oX9n
	keOh3Bi/P0WJhOJgWNUd+smoECEaMk8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Prntf9uZ;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755875366; a=rsa-sha256;
	cv=none;
	b=DUqMi1gpZUdI+vfOvnTM5Z8pRnK+ytfVWrhk2c5b3qCMDyq471+Rs2U3f0Cnlh/VAdh0PZ
	zkHWhNbnsbdXiYIO8BnpKr4ZOK9+Wb2Lho+sT48IJCiDyvMKNPdgJJ4DoDCv3suNWJzLNf
	CTtwNEZ4Al0H0x/7R5AJXPryA6Xr3JE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B028D4368F;
	Fri, 22 Aug 2025 15:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC2FC113D0;
	Fri, 22 Aug 2025 15:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755875364;
	bh=BbeE+oYVvXyCl/P3cWovjJUaU7WzCVAlNkMT749qO5w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Prntf9uZKZis/U/bJlHQFXtv4HnPV3FVBr1/P31JtBZdZlx8pNyYQrIV2U1OHL2Ph
	 KWg0PSoWLWhirFvfgHCyLwMGddND32c/PoybCUWyTY4uJJaWAm3pqSnmsGRF97A6G4
	 VDGi/p4toQ5nig1708cGRPMAz3wCxoj5eCkSR54XvHPYG/bVMzGFIuTMu74kogSth9
	 uZBDebwYJugk9IlUMY2oDzjDlJybUXGUDToJl2tsj04xT1jSsHqLJwHeqPJg2mwSqm
	 1JhNQxwyrU8QnJ30mOJ/Iq/kXqrUNLLTQ0bAe831b6zLWD86rnmkM7tBokSIpXtEvj
	 XiFVPUzX/IwAA==
Date: Fri, 22 Aug 2025 18:09:03 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
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
Subject: Re: [PATCH RFC 01/35] mm: stop making SPARSEMEM_VMEMMAP
 user-selectable
Message-ID: <aKiID8i6dYrlVi5T@kernel.org>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-2-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821200701.1329277-2-david@redhat.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 378AD1C000D
X-Stat-Signature: fzormeqtx8mse1optzbniwmkq7qg6sf1
X-Rspam-User: 
X-HE-Tag: 1755875365-284340
X-HE-Meta: U2FsdGVkX18gJYFjCsKXkV0/9s8fUFAJ7r9ZSwVR55eU+VKU+ctzjRxnAb2qvxIXD/cyrWL/LeuppKbIKM5ujzuvWvazpby2YlSxp0Kk1WzeFOBkVWRUOz7qv7B/AcQISTEFoxAK2kDT18Tg02jR8JxSkyVgwxNmep/LzQbaB3mTNEnr81l5H9o3gkqZ0/Es5n8WWPebzNtq96VvHFubrMoABvBDKSCfKYCdSeJvdO46cO0BrXJ9VwMlQdZoqd/KW3DJ8ilU1W/pp2Sw4cLQ0UQ6Z0dcoae3RAI8ROY/T4+q/WZ867JjTxOAd6F6i0mP3gOvhciJUqf1tOj9xcPBAU3yHYYw687/qCWK644PLMzxLMVQVW+r0NvMeD6KqaikTX2JZKztzTiESjaz9y51VVWEGC+9lVodvLoJUmHwHuJB7Z5YA+gqWEF37jXtVlpFXorC+w/DlF5njGC4zXsIt5Oa9ZU3lkfdf8hDWCM1sjiVcBoE72367Tx1Esxk1Z8QZmFL+WhQZNW4umQe3P5Rp3PpRpmRM99mAJGPNWg3clcyc8sQ2fquaiLIKgaUt3uAnqOIOJedVuHh4sZ3SZaiRSMxhqkRWPk0oUP2XgaVt0gh+2LA0lPH5J5JZAicwsHwqMOLAOjnGV08fZXqo88b4I4qKvmJxNidYPmTJnD8/zKTEO2i8XjWqUNBqTIs+uRhlT5/uLGQnZ+IBivrWJxH3ppw/fNxhiUXPfxlryp3yqDT/dmAPIlXWnFaGBYGk02aqx2lLaiGNjpR7F4Rd6XmidcmNgxl+znTYHKWb+ylRAPKqQzN3u443yTIlbYJcijJLBf3KTpr8MO30TGGcLoMvVjq9ZLWEekPknIx5YlV+kxL3jALKzZh5xr2HfXaml80KvW4kmSwO6J6XpCj5d19J86hQUBMn68QrMrEkJSrj51o3pahY7ZXIqwtgqz7QxrrcObPNvUH/wPJ6P5jiOM
 c/FhYHdH
 PwWZUULcqbEAdj7UIll6737e0iKge5ntHp6kGB0ryQi9WXBMjnXWfLSNLiwNIPeMPwPgN4iS9kaiWzCgsluc5Ket379Gfvw1NOka0P9IKYjmP6Y9zqDzzBQ3Q5f58Or0+E9IULJcze5QGEiBN11hU62t853wThaToxasBBLUtzLLHN9GRcGV2LJMkLyRxeJkUsOznARjlEH4wgx7Pl18zklMskQoGcn1GI1vVR+ahoya0ErkTJuUPCC7MekFUSpsKPZockUGR5nYSAvRdzqb6nhGtZGzfWmmgLoSMRcN2Wk+/9Br9tL5WKUOIBSx8ZK1UTy7jfLx1gZr35boBv2H39F4KpWD/F1TTJUKqpNZuU4klfXp3dDwVm/gzrrttOYtrxuYMWApj0BCaLaStsW75bLTSrPINGzsZP1Ev9hIEkkTKFm8rawrvHTiYDnD6DFZM5AwLk4kIvtONySuJRHKkrO6Jsov3iAuMkPLZVNW+hMEUshcM71aeSBPMiEJhk6MXL5zf+pnQQf1edU8TKPWAZIykxdqQZAVslNKHTQwMkAbclM8f2Gj5GWjPOAAOAokzfcNwJA+loHWtArISfKDTdU8HTGIxTRhURd9IvGDbJxXOelNNQ1oy0kSx5LajJ0CFriFBD8Wz/5sNYqYvXzo0iVy82+z8s91BIP8SkQ9k3lT6wM/mObfS1CBE7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 10:06:27PM +0200, David Hildenbrand wrote:
> In an ideal world, we wouldn't have to deal with SPARSEMEM without
> SPARSEMEM_VMEMMAP, but in particular for 32bit SPARSEMEM_VMEMMAP is
> considered too costly and consequently not supported.
> 
> However, if an architecture does support SPARSEMEM with
> SPARSEMEM_VMEMMAP, let's forbid the user to disable VMEMMAP: just
> like we already do for arm64, s390 and x86.
> 
> So if SPARSEMEM_VMEMMAP is supported, don't allow to use SPARSEMEM without
> SPARSEMEM_VMEMMAP.
> 
> This implies that the option to not use SPARSEMEM_VMEMMAP will now be
> gone for loongarch, powerpc, riscv and sparc. All architectures only
> enable SPARSEMEM_VMEMMAP with 64bit support, so there should not really
> be a big downside to using the VMEMMAP (quite the contrary).
> 
> This is a preparation for not supporting
> 
> (1) folio sizes that exceed a single memory section
> (2) CMA allocations of non-contiguous page ranges
> 
> in SPARSEMEM without SPARSEMEM_VMEMMAP configs, whereby we
> want to limit possible impact as much as possible (e.g., gigantic hugetlb
> page allocations suddenly fails).
> 
> Cc: Huacai Chen <chenhuacai@kernel.org>
> Cc: WANG Xuerui <kernel@xen0n.name>
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
> Cc: Paul Walmsley <paul.walmsley@sifive.com>
> Cc: Palmer Dabbelt <palmer@dabbelt.com>
> Cc: Albert Ou <aou@eecs.berkeley.edu>
> Cc: Alexandre Ghiti <alex@ghiti.fr>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Andreas Larsson <andreas@gaisler.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/Kconfig | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 4108bcd967848..330d0e698ef96 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -439,9 +439,8 @@ config SPARSEMEM_VMEMMAP_ENABLE
>  	bool
>  
>  config SPARSEMEM_VMEMMAP
> -	bool "Sparse Memory virtual memmap"
> +	def_bool y
>  	depends on SPARSEMEM && SPARSEMEM_VMEMMAP_ENABLE
> -	default y
>  	help
>  	  SPARSEMEM_VMEMMAP uses a virtually mapped memmap to optimise
>  	  pfn_to_page and page_to_pfn operations.  This is the most
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

