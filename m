Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6215FCF8840
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 10:35:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44EF06B0007; Thu, 20 Nov 2025 05:35:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FEA36B000C; Thu, 20 Nov 2025 05:35:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ED626B0088; Thu, 20 Nov 2025 05:35:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 16BED6B0007
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 05:35:40 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C0891140839
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:35:39 +0000 (UTC)
X-FDA: 84130629198.23.F1D479A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3F267C000D
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:35:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GREW670r;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763634938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tpTOpzASc1dvEdLw/kxxVJOr1uD8yM5aMjpwt0LDXPU=;
	b=pjczvzC/zD16Sa3zJeUIrr8aacE4c6TBU+e5d5OLodnI3R4I8FCuui4Bir7ACvvl5ViOIG
	qujG6DgZV5smL3mhLC1kKiDpV153KlFoSZPYDcguuRiKj5pV3dvyXZsiH4BNpojJQlLD7j
	w4FHg65TOL8AjIysCujbxVj0HuIfuXM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GREW670r;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763634938; a=rsa-sha256;
	cv=none;
	b=oUa9qG+pf7YvYyNgJszj8er/0r9LwfwgfDwWegXebyMpb7Z1HHEjbGR6rqwXypCIb0ItPq
	hhX1GrIcTAw4X+1oF8f0k6hwmRszjK3nMC0drycBVEWt3Q/44WgxQzagIByXgXQl+uwwLu
	rIOITSABNaBi5kSVs/D/sBfPOHe/GGk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DC2F443E41;
	Thu, 20 Nov 2025 10:35:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C55C4CEF1;
	Thu, 20 Nov 2025 10:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763634936;
	bh=JhN5ODh4SUzvOgFOKxr7bEcrjPEG8Ip1MG+TWZ4MFBk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GREW670rDfQ9BqsGMHJ+jirMkrMenMfQNZHG0Aw/NHasbANFNYEdgTfG+fzjCwSAB
	 WacykwzQR9deDr5K6StoxF/RGXaqCJtkXnVGlKrXt7+vvAKDHpn8YdBryvpPy5E1cl
	 c8bv3go2d/7gGSyFdz5m450iEa1W/02Cm4Hvr2SVlwxke3/dHN4xlamRvNZ83bVT6I
	 OxMuetQkvJOs7eOYOHKkzuzd26tz3ZhUgETW9uVOiw9bThnaNKsBz03ZA0daxzHRfD
	 w6U2lclj+2sp78GVLQuwlCoyW0LoLwrZMI9aSAfx6WJff7kTGz8mby/gE+rwQZxlaw
	 8b1ZFU0/xn6+A==
Date: Thu, 20 Nov 2025 12:35:22 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Jann Horn <jannh@google.com>, Vasant Hegde <vasant.hegde@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Andy Lutomirski <luto@kernel.org>, Yi Lai <yi1.lai@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	iommu@lists.linux.dev, security@kernel.org, x86@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 6/8] x86/mm: Use pagetable_free()
Message-ID: <aR7u6ukKVM2S7rOX@kernel.org>
References: <20251022082635.2462433-1-baolu.lu@linux.intel.com>
 <20251022082635.2462433-7-baolu.lu@linux.intel.com>
 <aRvWfv_fc60zUK1d@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRvWfv_fc60zUK1d@fedora>
X-Rspamd-Queue-Id: 3F267C000D
X-Stat-Signature: df78tif9m9mk8qnb5hi67juzt73ts7ka
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763634938-398614
X-HE-Meta: U2FsdGVkX19B4mABa4I/7JXXRXLN9eXcIer++WKCm6F9itG+5Euu9oW89Oe89YAoe/D7GSaRC6FbnuOPpjBH869yHm35rtK/R1UtezxJbGFWtUbVNN7htWqQm0hsnI01uwJufZg2/Y0ayO9d8Bimc+f8zbccpkxNB5zr6UpXlKquubdzRU6PbjGfpUK/dHvXQvcidtKlS+M7Qvq3eK3wc6r8ZCxkFIDtWBk6aTkkzVVVt5+GprlS9aHhSHFtxQcuUujyDB7ktTPOVM2QKZma3ex8d/SSRXeQqBzZ1vtVuyWfdyuSlrKrh2y6vsj6dDWx52EOiyYP2V7RclZ6mmRQvGc18Xadi2KhK06iE+N4WQNrpQ/n5Q/Dvo3yYZmobjJYECN9WMC08Zzm8y5vC8s3UaPQxShp24dWvWpVzZdAStP+2pgNSF/75bDI00uw7ZIrvV1NJtRP+GCdWdrH6O3U4xcuwLjMJ53t316MAiIM6SLbVb37ZCHwrXmYsCzDR/6bqD6K19WkTwZiuMPNz2972wobTTZpttAWmNIV4pmDJdA/Xj0a6akhosWksshnxiVmh4RP4SZUiqz/4QjKUg9Rl203AwPNywFFiyQcM27kgBAaUU+4M3bi8ozB8xjoKLaNNbKv7yrd25iyWEol3cjeRHIWIbWQQtzETb7x9sFUV1/RiXP6F73FHU+dHbgcjfzyBPrYuc/t2CGYtRBz2METd+qMIP3kM1z6PaahWp9rtd7T05cOgRX+0sWEAKhTL3RBBVcDe9k3xPZWZpzJUeocJ90JzNa8d+PJlzqGG3FnBiqq3ufw5t+gSCzXk6ukDPUlrHPGlAzQCCD4+vS571PybL+y22+8tZtzYi9kJsafjlLMKYZ4hDLGN6RJ9cq5DXWrpNg906LSik4/EgpSAwiqJwYgksFseU8oqdJ/ljcpOHy/8QgnmZZwSKAi5srqnBmF30TPJOX0Mpcx2ZFa/A3
 0C1gvM02
 Yt4Y/169RX+qXZwDzbSvkxpb/F+g6zjotKXcGS64fCjXQoL9b/HQb5cheefqmCX48EWCxTMXzYLW/jYE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 06:14:22PM -0800, Vishal Moola (Oracle) wrote:
> On Wed, Oct 22, 2025 at 04:26:32PM +0800, Lu Baolu wrote:
> > The kernel's memory management subsystem provides a dedicated interface,
> > pagetable_free(), for freeing page table pages. Updates two call sites to
> > use pagetable_free() instead of the lower-level __free_page() or
> > free_pages(). This improves code consistency and clarity, and ensures the
> > correct freeing mechanism is used.
> 
> In doing these ptdesc calls here, we're running into issues with the
> concurrent work around ptdescs: Allocating frozen page tables[1] and
> separately allocating ptdesc[2].
> 
> What we're seeing is attempts to cast a page that has still been
> allocated by the regular page allocator to a ptdesc - which won't work
> anymore.
> 
> My hunch is we want alot of the code in pat/set_memory.c to be using ptdescs
> aka page table descriptors. At least all the allocations/frees for now.
> Does that seem right? I'm not really familiar with this code though...

Yeah, that sounds about right. Allocations in x86::set_memory should use
pXd_alloc_one_kernel()
 
> [1] https://lore.kernel.org/linux-mm/202511172257.ffd96dab-lkp@intel.com/T/#mf68f9c13f4b188eac08ae261c0172afe81a75827
> [2] https://lore.kernel.org/linux-mm/20251020001652.2116669-1-willy@infradead.org/T/#md72f66473e017d6f3ce277405ad115e71898f418
> 
> > Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > Acked-by: David Hildenbrand <david@redhat.com>
> > Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  arch/x86/mm/init_64.c        | 2 +-
> >  arch/x86/mm/pat/set_memory.c | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> > index 0e4270e20fad..3d9a5e4ccaa4 100644
> > --- a/arch/x86/mm/init_64.c
> > +++ b/arch/x86/mm/init_64.c
> > @@ -1031,7 +1031,7 @@ static void __meminit free_pagetable(struct page *page, int order)
> >  		free_reserved_pages(page, nr_pages);
> >  #endif
> >  	} else {
> > -		__free_pages(page, order);
> > +		pagetable_free(page_ptdesc(page));
> >  	}
> >  }
> >  
> > diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> > index 970981893c9b..fffb6ef1997d 100644
> > --- a/arch/x86/mm/pat/set_memory.c
> > +++ b/arch/x86/mm/pat/set_memory.c
> > @@ -429,7 +429,7 @@ static void cpa_collapse_large_pages(struct cpa_data *cpa)
> >  
> >  	list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
> >  		list_del(&ptdesc->pt_list);
> > -		__free_page(ptdesc_page(ptdesc));
> > +		pagetable_free(ptdesc);
> >  	}
> >  }
> >  
> > -- 
> > 2.43.0
> > 

-- 
Sincerely yours,
Mike.

