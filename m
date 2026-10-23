Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82A02606A320
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 14:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=HVAg8X48
Received: by kanga.kvack.org (Postfix)
	id 9DA536B037A; Fri, 23 Oct 2026 10:01:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 984CC6B037C; Fri, 23 Oct 2026 10:01:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84C646B037F; Fri, 23 Oct 2026 10:01:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B29D6B037A
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:01:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E3BABA7FB6
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:01:11 +0000 (UTC)
X-FDA: 85354052742.01.9B2D65C
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id B7687A0020
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:01:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=HVAg8X48;
	spf=pass (imf25.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.171 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792764069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EtyMFPm1AoXY1rEO0WfbSM6JxPHkULRdHaFEkgfjDaI=;
	b=u1fpufgyQLDhSksiZSWcHVp6H+EWfCuKl9cTMXlxhLnh2FyxxMYN1HT2Wtt7kHQIGqPDE9
	mE7IzCO6FxStUeeNxmbblm5meFttKk+oDAmnMN+TcEt3FpUO2XhWOArsr6a5rXqAIXxGhl
	jr7DqwbTnHH5RIVIWj7zI+30zw9Dgtg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792764069;
	b=PhvAyew6p2MGF5nznMPZo8thk2wgwkqhFvo0Ci3LxWAr9u0wAt/ZRHIPih6aSB0621Iuhm
	3h0vmpUT0DKzJ02pG3a794KwnRCmvqXfeRW0HkdiOGGz/NRNcYAXXxksBSopKO6EQGwzt3
	+cLI8sxndPvWgZx7O9aGRQ6PuKbfbl4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=HVAg8X48;
	spf=pass (imf25.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.171 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-53634b8328eso6043811cf.0
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1792764069; x=1793368869; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EtyMFPm1AoXY1rEO0WfbSM6JxPHkULRdHaFEkgfjDaI=;
        b=HVAg8X48hZ8+NgWMgSVqO7f2tpjdVhPuKQd8GWM8xtkRIO5XJI21XRPpOXE0v643XJ
         xSNQk9rJtiRIKmNyyRFAdrfdJKNGp4UyB8vHzkkSOVsgfNNBm/HeLEgzAShwdlUIVQTe
         E/t0Tq3v+nLALppDB9hmlA5LlDQP6Pbi1imXMj07z6Avms85Q/2Q7xvS/yYKhsxBHwss
         vrP9ZiTKUSAawmd1jRaJ0trvbzZVetgacRqK3k+6ccaHqB5V+OQtvtFaTurvz48a/tYc
         nuC1LQEfuAAxf1jwLJWeqmmEY1sqVhWzaxLC1f1JmGa3b58rcZ+cRAe7sg5HqhJBXyRm
         GBiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792764069; x=1793368869;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=EtyMFPm1AoXY1rEO0WfbSM6JxPHkULRdHaFEkgfjDaI=;
        b=fnqBUgVOxTKc5lBkl/aG+Zi6zP8U1BcNF7XJ8i3tnWI4nSPRD2rOIbiO6Fk92csH8v
         ulrrdbdrXdlYxYmiJz42FXVwKrY74zowJhYS9OSXFTyAHY+ZoIcR1rXcWloNxI0jtu1Z
         H2Ezb/TjB9zSPX126Cw2HVn3wPdCoXmxahzcJ0aC6/MFUmaEgU4Qs3T5VifKYeINYWRT
         Tmkfx70vgfUoFrMfLT+HGhfNM/I+ptOoQDi6qAaEFkkht34UEwY3A2aXYSts9UN4owK1
         q2w8J7MF2rN1VK55rqa6ZbmTOPTUCJyGucFStF7KuF7KztUfVdW9en9Jxc5hMtEeyick
         gmjA==
X-Forwarded-Encrypted: i=1; AKwUvBymZrGp6X/mzET1HFSqV7x2HVLM8eBPsGdjZD5Kd5VLK/BgdQngPQHKRsxk4+hV+e5yM6GVRrHefw==@kvack.org
X-Gm-Message-State: AFq9FYKHJbOg2JEfBCMmujoXm9Zou8XRvIzceGNrXB9G9W8o6bwucauP
	BZ5p4/IN2rByjqGBMmtnX1dtKjif3SzSpkOMD2T3kr6g7JEV45KlKuyzHl7OjGNFT0Y=
X-Gm-Gg: AYBFou2bHW78GUBo+bKqzcvJw4r7Rv2dF7t+LFccy31Yf8WXMKunux6P2AlfysmkakL
	GkI+heR7kRt1oILP6MWE0vog/BZI70R2CdvWMdsQ0k+p1DZc+ab9VO/tAYvjw3i2nTHnB6uDfaf
	OiScMpo40CF9frWPqpUc6ce6aguonVlGwzIArAyE0ifEdPtkXYkIqDq5ocevLA9pmjKCBI7xHL8
	yFb+RPWM8+WtsHK7dlIVgvDn3i33n9uQsmfxVwUbIEloSoVIOtn9HdxTBHkbfZaFblwMLcaCrJu
	DaMWxgDVV6yhIU8Qaie4H4c03BaHbUt2e+mJJDVLGAeAnUK5EwZk7Rm/KLDkuvtiq2vOnMYPdXg
	ohI+cHN8hm/OM0HEC/brTDqRH6k3mPrHAjZG5AAGS43WeZiEfZbNZHUWHUqXzE0k1P/AhhVRtDT
	mfPR92kpsGKmRmFOGclv9GjpRJUlt2LjtL2hg3YahWwd7zcKUmLviWwB5S05nRnunZN2HcZxEs9
	2L5G3RtfaAgmiRzL8Sk9RCGNyP0Wlsi7Ck0UV9TCImakqdtj3ekp32XxjGmAmHZxaWcxG8lWt72
	KQc1My/rZZma5oKb9fKA1tNHLYkXD5ql17/m1g==
X-Received: by 2002:a05:622a:4d88:b0:535:92a6:22ec with SMTP id d75a77b69052e-536c263076fmr30716841cf.29.1792764068500;
        Fri, 23 Oct 2026 07:01:08 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940479fc830sm24750685a.21.2026.10.23.07.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 07:01:07 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xKFpT-0000000Ghww-1SWZ;
	Fri, 23 Oct 2026 11:01:07 -0300
Date: Fri, 23 Oct 2026 11:01:07 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Luigi Rizzo <lrizzo@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Christoph Hellwig <hch@lst.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Willem de Bruijn <willemb@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Joshua Washington <joshwash@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev,
	netdev@vger.kernel.org, linux-mm@kvack.org,
	driver-core@lists.linux.dev, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC: DMA_PMD 00/22] DMA_PMD: PMD_SIZE-backed IO buffer pools
Message-ID: <20261023140107.GC3977851@ziepe.ca>
References: <20261003212241.3432303-1-lrizzo@google.com>
 <0cc1cac1-a500-489b-9c1b-b49598b5550b@kernel.org>
 <CAMOZA0JaiKsRgDdjHkL_N+MshhcyLSv+cT9SzEbNsC_sumHvOw@mail.gmail.com>
 <b31efcd5-149c-4edf-81a2-1744d363c390@kernel.org>
 <CAMOZA0+6kAbwgNwGTsCT5AqpwcZKz4pziEGC9UpHkNCVoqrF-Q@mail.gmail.com>
 <20261022201229.GH3381610@ziepe.ca>
 <CAMOZA0KaanmevmvWS=M3gKfBeborzfCQTiF_xbSeYMWbozG7Mg@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMOZA0KaanmevmvWS=M3gKfBeborzfCQTiF_xbSeYMWbozG7Mg@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B7687A0020
X-Stat-Signature: tiiwo1wfnjxcawtsw3yudyxc8dhezxow
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792764069-348468
X-HE-Meta: U2FsdGVkX1/nFNDnq//z2Zc82ohG7Bu9vawWy6T3Y1I1aZWZa1CsOYwAVJTgIiOuvIqAoY2ra+Hi9VyMkWCJfR9HswK+hrYo1U5MpYrABTxqvvPa5Acg0k2GWnPD6b2pLHUK5Cr2nXkGTAAtqL6tTO2vCWcg+d38O2pZ/Ujdf5U95CRwHYNCWypxnM2uI8+70gKSf5IflQx9G4xa3sJod56XdsXdfFLs9eV+lhRHudioQI1f2TUzEjyrwLbMkqrEmL0Fmj1reitfHwQnJ2IZChfzU4yeG9rEv14DJgJn/MGkJRimi1HUU4gSOM9g6kveFJ1czzd6YydWyeqL1LyVw1geH88O6Ysh/ckX8ju7fJwhDTDhXhUX6bkWAy3OAily+N8hW9E4CRmuFDMvJzYPRhZhisql+W7CUm0pIRbchUaYZnvvA6/ZN0hkAjnDqzLMfQRQ1V7eWEX/WwQMzKLlHvp9B/dvS909dHlKgHDtdZrVS1TRNnHKRE8ZQq77LQg1QqmSKFgCwNCq6218f3iWxL+AlBYfDvGAqjwbE+A1TynGv7/tiLjSpQQ369c+Tg8G5dRFXktXrmxaYKo2nvHTc1d2q2NztAYQef3KYpkYY7fOkWq983XRNCkLlr9BjcKMVquSFD7mVBgnA5qUz3rF3pabesq+ItknthQzv7qpEl1WFUn4coIPAfayJ9qnO5nLZCQfUHNBXok6vOvOcte3znjrUuf9pXipSIbZNCKc/QxDWMu2fynSl/8f4B0S2yLpptxQ+2IqbbiuxN3XBFKSwxpL7eUjLpt96gtsu9Xi4SPfekfCSJN46T8d0KG9NpBdGAtAv2VvilwblH1M+4rjG8eUlK9nVHJ1ZS/McrsR1kh5hsIJKHJECeoCq6ceLw+tOyx3QFyxlQ78OMVI5aRpX+2dxgb4eQyLGg6VDkg8FOd0TqbUPfz1R2Rmdq52ZVvueBO/BfSDUK4sN/WJvuq
 Xqfnk8s5
 Op2DqdCtUo5jjfumKpWwtuXkg6hxvksQ0rrmjFt1QaJO/9+5TL4KzRLCCc1xHdYPlT5zE+l4HDP4gdWa96MYBvk3nzNFlHViodfjic9A6SJguqdTUs4Yl8cfqm3NXBff4QDxnJtARHzNGsnlPNWoIg17jkEy4WbY/qKUZACNOBil0ZCe+R9BH9hqXrilS42f5KHgbujsde32+pa4rmEernen1Mmn+wyk/EDpmyQOSfQqD1QVYCfPuQrNRMEWH6SWzxu0Dz4cVE3hEnW79KUfwvofRcyTTJrtAinI1UINuUuZOv65AF/qKaySCCfy0+yFD1oQ7sCw7DBHdVshkkk6D63Ib4q8dMmhQeBcv0K8uPAP2HhodfrZadbweQi204FVhf8SG1NRvsVKabU1xwo9g+CdMgw/wk8ICfWU1J29C9J0w6hnCayA2oOVqPVaxaE+S8R4cb4lvpOjzVOoA2GP8c9J91L3wJTGOOCaSIe1gujqbqdg301pKowlhlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 11:51:40PM +0200, Luigi Rizzo wrote:
> On Thu, Oct 22, 2026 at 10:12 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Sat, Oct 17, 2026 at 07:11:28PM +0200, Luigi Rizzo wrote:
> > > > We should probably just find a way to describe that this is a POOL that focuses
> > > > on physical contiguity in some configured granularity.
> > >
> > > Before embarking in a global renaming, I would like to get opinions on
> > > acceptable alternative names (possibly with a short prefix usable for
> > > identifiers in the code). I could think of the following
> > >
> > > DMA_PMAP (for PreMapped or Persistent Mapped)
> > > or, ahemm...
> > > DMA_PISA (Pooled IOMMU Superpage Allocator)
> > > both using dmap_ for internal name prefixes
> >
> > Can someone explain what outside netdev would use this? And why you
> > couldn't do this in the netdev page pool?
> 
> I can try.
> 
> Regarding users, the next target is disks (not included in this series)

Disks don't use a memory pool, they do IO to folios allocated by the
page cache.

The only other candiates I know of besides page pool would be the
existing dma pool users. I don't think they are so performance
sensitive as netdev.

IOW I think this entire series is only useful to netdev.

> > It is not a common workload to have the DMA allocator be the one that
> > allocates the memory. Usually we are DMA'ing from memory that was
> > allocated someplace else.
> 
> Aside from the fact that dma_alloc_attr()/dma_alloc_coherent()
> does memory allocation + iova allocation/mapping,
> this is not what happens here.
> Maybe the confusion comes from one function name
> (dma_map_alloc_pages()), but it doesn't map any thing.

> My code (in this version, and more in the upcoming release)
> mainly implements a specialized memory allocator with an
> API equivalent to alloc_pages() and variants, but ensures that
> the order-N blocks come from contiguous 2MB blocks reserved on the fly.
> 
> The physical addresses of these blocks are recognized by the
> "dma allocator" (I suppose you meant the entity that allocates the IOVA range)
> so that it can apply specialized IOMMU mappings backed by 2MB IOMMU leaves.

Why? This seems completely divergent from how anything else works in
DMA mapping, and I don't see a reason for it to be anything like
this. Other than it makes page pool work a bit easier

Frankly this looks like you had AI to transpose a bunch netdev page
pool into iommu.

> Note that just feeding the pagepool with 2MB pages is not efficient because
> the fragmentation in pagepool is done with a bump
> allocator, so recycling blocks from a 2MB page is difficult
> (it has to wait until all 512 blocks to become idle). My code
> has a bitmap to track usage, so it naturally recycles at the block level.

It doesn't seem like this little issue should motivate all this
 
> Then there is the transmit path.
> 
> For skb heads, one simple solution is to use tx head bounce buffers
> some of the patches in the series show that option (the next version
> implements a proper tx-copybreak).

> Otherwise we need to populate skb heads with pre-mapped
> memory. In the next version I have a simple modification to
> the slub code to accept an opt-in alternative to alloc_pages().
> I considered using the pagepool, but the changes would be
> similar and the layering seemed really odd, with a cache on top
> of a cache.

With AI there is no limit to the layering violations one can make :(

> For transmit, there is a bit of impedance mismatch as well:
> skb_page_frag_refill() does not know which device
> we want to use (in fact, it is a per-task so there may be
> many netdevs used by a task). We could tweak the pagepool
> to be device-agnostic, but that would be a bit more
> intrusive (more architecturally than in terms of code);
> also we need to make sure dma_map() on those pages does the right thing
> without trying to map/unmap the individual 4K fragments,
> and we need to make sure the skb_free() etc does
> not leak those pages into free_pages().

This is all a page pool problem, has nothing to do with iommu or the
common dma layer.

You can already get optimally mapped 2M IOVA and memory out of the
APIs we have. I can see no justification for the intrustive mess under
this beyond it makes netdev page pool easier to hack on top.

Every thing you listed boils down to 'netdev page pool work the way I
want'

Jason

