Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3C4DCA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 13:31:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92AA9900165; Thu, 14 Aug 2025 09:31:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9029C900023; Thu, 14 Aug 2025 09:31:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 818BF900165; Thu, 14 Aug 2025 09:31:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6F457900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:31:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F36661385F5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:31:14 +0000 (UTC)
X-FDA: 83775449268.16.11A839A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 57F05100009
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:31:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XqHxW8YW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755178273; a=rsa-sha256;
	cv=none;
	b=GyUJQyx5af99twcGWbjXZGgw92r1rxmqmbeT0b5QUGqbs7wezJeVGmf9F4ZmstZn11lABl
	X1YMTZYC8D+a0fnN+VIjdrJLreJ5w44N6c75ee26thgu/YP1uDyR3AB2M95GS3f+o9MeE9
	yP3hTsbBdWhffeF4sBfpiUauOsBy2xU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XqHxW8YW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755178273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/aVLEAIiIUq96sEpteKq4xn0CYp2Pr/HhvYRjdNe/U0=;
	b=LkQRoGv0HdXvdsSI+OQ0KAAJcE/Gtkzg+SVurudQ4pO3mn/TUG5gVSsDdcXx6ZUnnf3wZ3
	yb/fe1f8KQzBzT/XMf/vd74h9/lgeqt9EXqVHm+UkJX0EJuS0B4XXE6UgGY/klZ/i60qzU
	3G3or2vhl9LOA4uqLMPFiCago78dkYY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 766E96111F;
	Thu, 14 Aug 2025 13:31:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E81C4CEF1;
	Thu, 14 Aug 2025 13:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755178272;
	bh=WW0xB1u8XI1L1gGsXl6wpt3WDXrr4yCiJlHi7BUNlCY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XqHxW8YW58Ln/tIjnGi73wY9qD5/Iqkzwyv6qop3T0s5v319Ftg/c1ujK3/+Pmp3O
	 3SJY9d+x4hq26C9R4ldz3ap27JZ3CK6dbddTXlBk+z2z09uVrOYjtUFTpeGlFvgNjV
	 L1huyBWZL3RmFzTXcCZe8HHfxLc3AApxz5Ss7QLL+ussS/TR5qi1rfohz3kzvuYQXA
	 z9fOR+m/fazEworlcK45UcqDrJLI+rHyeuLbz0YS0ZizqgTQFWAKE1JSOTRnlpXZlF
	 3y7wTMxm2dgJYYjVCyrbQbIxiWn20GP+y7nUAEOT4RU14M4Kgk2W8/qCK/ckcjXpyq
	 NVGeZpIDI1XVQ==
Date: Thu, 14 Aug 2025 16:31:06 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	iommu@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>, Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com, Keith Busch <kbusch@kernel.org>,
	linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-nvme@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v1 08/16] kmsan: convert kmsan_handle_dma to use physical
 addresses
Message-ID: <20250814133106.GE310013@unreal>
References: <cover.1754292567.git.leon@kernel.org>
 <5b40377b621e49ff4107fa10646c828ccc94e53e.1754292567.git.leon@kernel.org>
 <20250807122115.GH184255@nvidia.com>
 <20250813150718.GB310013@unreal>
 <20250814121316.GC699432@nvidia.com>
 <20250814123506.GD310013@unreal>
 <20250814124448.GE699432@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814124448.GE699432@nvidia.com>
X-Rspamd-Queue-Id: 57F05100009
X-Stat-Signature: a88fqbn3beeauqn69xcofeyn5iyanqe5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755178273-7488
X-HE-Meta: U2FsdGVkX18ArnSKGLIwoyivOY3k7RhZxc4x6E+kFhIwsAjweikFbUPJNthKGNqujk1Q8HsHqmUwIv90CnXl47g/nR+9dkykxD842gk3PcdWtx63PL9HGGfANgGw28q4IsbKzY5WRZvSJIG3eLDx9aAo5ZA4lvOnX37a4sePW6DiaVOxCBJVKXmDnjcd+PhXAvdxfMxyJNbi1g7/QSuifV7fCJ3uYWtDwsZSb1XwlGJ8Vr8Efn6WPnY9Vc8QRkOX41007O2gCdbFwgcySPmMBu7LdRAWC/hyk4V32xZL8hmDe29CyX7dZIXxtdnFI1phdfzj8xPJnsMB7TdzNN4+xheM8155twmyBTGzEewm9hKqOD3YSJeS6VDyTj1upMVzl4MtSR3TOqD8A3IO67Y+zWj+Nr1fvRHqMzLMvoUUxu4TMoDL/9Ru+D2IrygNHOJ4yGjunZrb0hdpsrZT3Ubkn20CpZASc2MpJqvN+yIUye8flGo9FRPEuU2L0h92CFofSNAORzh/6TBmKr/9DssuXIxY4E0Wal7BteAUwYY+ohmK/sOKO1PKuLRyi65ydi1LDKin/g1gkJ7iFKNHyRxJoo4V5eXlsHzaAWFTdyWr673tEcyiC3/PvK6IjtUnRRDRbrYhxQipyxsn0MHTDheVDtnexEO18AAWOiQM2dctC0RAaBCG+qyv2vmZrNssIpzW8I1jWCrXocaS6isSuOveB1Gjv28mgswgc2xQIJ4RziU6zTEivjEtbWbWTOq0iEpBQrNe/B7m5uR4qupApDq2ojLsHVlGpxcPc6AZ/C8qDUadCO5uC1aMXBrViP/ZodqICxrmfvkVd4f7Vzv1jymAjWg2+hV/yuega7Mhlcqx8VuQc870e73F3MblSEFIkO3FPoNHDdrtlMqUfrCKe/EkgzOHNp0rAKJywZnAKziuGYsO3Bo6B0LNHHMQXd05/Y53QJfQLjx0WqPgcxAvfer
 a4Z5j6+G
 IuZwZ3wVraUmOymPo2/HkKRP6+eFRpNjY9G3xpeNKs7oK1tcZj8IB3pswv1Q08SozifPf6LOZkzUJRyS6miRioHvdkVmN3UwTOvKhAkTjd8eld73cze+/iDyzNTjE6eNKDuzGMNBy1g1SiH67zJMzNs1l8JW8TvcKcSot9pMXyiuu+1I++pO6uz1eJaFGGsdC9woOAQ2G0409fByHCSDhStKyw2mqh01uXmQjlqLlL2MDkBt0d1LoHy4lKDpUWa/RR/Yf9OrI4j1HMbiJ9rtbWV6CHf90I+9XcJHwNw9X31SXAdEYX1v0USBTgN/X1PQ/fvtL1t6h20DE7JGncWaA39+br41oykDv+w14YBzOAXs2p0LXgdlhXyQSxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 09:44:48AM -0300, Jason Gunthorpe wrote:
> On Thu, Aug 14, 2025 at 03:35:06PM +0300, Leon Romanovsky wrote:
> > > Then check attrs here, not pfn_valid.
> > 
> > attrs are not available in kmsan_handle_dma(). I can add it if you prefer.
> 
> That makes more sense to the overall design. The comments I gave
> before were driving at a promise to never try to touch a struct page
> for ATTR_MMIO and think this should be comphrensive to never touching
> a struct page even if pfnvalid.
> 
> > > > So let's keep this patch as is.
> > > 
> > > Still need to fix the remarks you clipped, do not check PageHighMem
> > > just call kmap_local_pfn(). All thie PageHighMem stuff is new to this
> > > patch and should not be here, it is the wrong way to use highmem.
> > 
> > Sure, thanks
> 
> I am wondering if there is some reason it was written like this in the
> first place. Maybe we can't even do kmap here.. So perhaps if there is
> not a strong reason to change it just continue to check pagehighmem
> and fail.
> 
> if (!(attrs & ATTR_MMIO) && PageHighMem(phys_to_page(phys)))
>    return;

Does this version good enough? There is no need to call to
kmap_local_pfn() if we prevent PageHighMem pages.

diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
index eab7912a3bf0..d9cf70f4159c 100644
--- a/mm/kmsan/hooks.c
+++ b/mm/kmsan/hooks.c
@@ -337,13 +337,13 @@ static void kmsan_handle_dma_page(const void *addr, size_t size,

 /* Helper function to handle DMA data transfers. */
 void kmsan_handle_dma(phys_addr_t phys, size_t size,
-                     enum dma_data_direction dir)
+                     enum dma_data_direction dir, unsigned long attrs)
 {
        u64 page_offset, to_go, addr;
        struct page *page;
        void *kaddr;

-       if (!pfn_valid(PHYS_PFN(phys)))
+       if ((attrs & ATTR_MMIO) || PageHighMem(phys_to_page(phys)))
                return;

        page = phys_to_page(phys);
@@ -357,19 +357,12 @@ void kmsan_handle_dma(phys_addr_t phys, size_t size,
        while (size > 0) {
                to_go = min(PAGE_SIZE - page_offset, (u64)size);

-               if (PageHighMem(page))
-                       /* Handle highmem pages using kmap */
-                       kaddr = kmap_local_page(page);
-               else
-                       /* Lowmem pages can be accessed directly */
-                       kaddr = page_address(page);
+               /* Lowmem pages can be accessed directly */
+               kaddr = page_address(page);

                addr = (u64)kaddr + page_offset;
                kmsan_handle_dma_page((void *)addr, to_go, dir);

-               if (PageHighMem(page))
-                       kunmap_local(page);
-
                phys += to_go;
                size -= to_go;

(END)


> 
> Jason
> 

