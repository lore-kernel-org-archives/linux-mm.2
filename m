Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04508606A31B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 14:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=STLaEfnM
Received: by kanga.kvack.org (Postfix)
	id 072096B0B84; Fri, 23 Oct 2026 10:50:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01BAC6B0B86; Fri, 23 Oct 2026 10:50:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4C786B0B87; Fri, 23 Oct 2026 10:50:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2CA96B0B84
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:50:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AE124A5250
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:50:27 +0000 (UTC)
X-FDA: 85354176894.17.E431CF3
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id BC8071C0006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:50:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=STLaEfnM;
	spf=pass (imf21.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.172 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792767025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sGl5cqr0Sn8jKPodNx0zyYTo2AHNV4DEHX4rmbHeM6s=;
	b=f1BiBhJnOmj558HU6SYoZRd0Rajn90mSRVaZo+Fg4g9MOdaGjPIxH9MQCd3hO0dV0rfISF
	awhgFXHRvX7PF3YMvRrnlFXJWRoFMO5lhaENdFzIb6TDzNhnHvA98y1+ewbMFdYdG654DJ
	e7ctoWb0geS1pUBC3foFsyxSV/qk7GA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=STLaEfnM;
	spf=pass (imf21.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.172 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792767025;
	b=E9/3zJgJubczaGaTFr3/ZAQcodwCrKqP8s/SHFh/+rbwmKhQxdaDzT9kIM9luwwTt86/fU
	0Bh7NPCrmMVSB6IwIuNRDfMILRVNDeqsInfATHSeahOQ+aZqj0h8k7eZhpUka8lyLKzDod
	6F3jLi/H5uWZyAg85VsagMN0+Bix334=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5364c951da4so8428871cf.1
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1792767025; x=1793371825; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sGl5cqr0Sn8jKPodNx0zyYTo2AHNV4DEHX4rmbHeM6s=;
        b=STLaEfnMPjs0BYGuaHnxfhU43Kw+dcktzLbXkRusSlE8zTcMnFP726OT80bsg53i4V
         B4hbIPDbcANoNZiqQYyal9SrR96Z0OwZeQTllbYPnT7SFMJCWHkV5qOpveIDwXct7T/n
         HBDiCOiOcAgNrc1bPAtLB4b8+eo/0Ez689bRqEWlr1hjqdR7wHGh/U0XHR4+KJOpVJ2Z
         NEEB5AXp1kzKGDGoiuxLUkSkNQ7xOloTNey0Gerh5I6848bOijEqItrIP9Dob0ETyF0g
         3bQTrr3kMQp8ECTc5Vrle+rWUFo+74+tx5duPlqR+w2wtN66ChbE0Hcq4WEXZkmOV2W6
         p4UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792767025; x=1793371825;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=sGl5cqr0Sn8jKPodNx0zyYTo2AHNV4DEHX4rmbHeM6s=;
        b=iYh+dzDfyyYWJzEcQjXBHLq9EaLKOXMhsdTPEXBh08Zv+5dbILacqEzM6A4D3SqLN9
         z9bH9vQDwiWr9GjdROqYfWxiaAHmq900Gp4Qi63n+rPBT7Qqr3wWPOQhnHdZzLjcHpGy
         TrKS7BB4/QnwAMvh0t5nepKxSpGG0CKsHIJbpA+zw+PwBmqCEjoBwDnywCoqjRoM9Zeo
         AutkYA5iVNVJA0JMiN70hCcoEegMh2klIk9TBY+pUokgEHVL/F+pVjOM06QxQpG9JNWp
         adDuMwmaGJ5K3w3cSulKHWz6hWKyzaFTbM1zNarO8lF5ZE826R4h+VNekNDEUKEE+KJX
         UIDw==
X-Forwarded-Encrypted: i=1; AKwUvBxJBBXkRJ4ttiKGXR7zpMsJ4cg9glQ+neU5qRBdbJUxyUXpOC34CWsqFH69DfftAYZqcW+lfdBbng==@kvack.org
X-Gm-Message-State: AFq9FYJjLq0wWHR2+ebTKZYEaOrZcCaHEu7H3jBZvzoMJCWwgA/TuSwq
	/wEfPwR3074aTGwYFd9rDD2kiK1L/jbiDdIji4zQwmL6fhJkT9sGPOu+tbNFrRQtKD4=
X-Gm-Gg: AYBFou3UBNKCYJLvwwAj+e34pqGoRe5aK3px1dWPwIv+TLHfJ3NapVXlsSjRYmUKFVN
	nTkdHSdrjclSO9zI/1rSY2LdyiRUda/tfrifu61QA1CPRDEcHtR98vR7bJ6xOK7/Q1Cp6bclQ8l
	iusgZvk+r+K6gei03oMnzQEkbvtpqzH/0TLARxCuzALD7NkWwXCNRIDrFBI5r1hlwPdUiOjbds3
	40jI/aww7CktUqMdU4VBAUgyBkRNzpt7cvO4bmpWXQVlEi2kVyXwt4LH6fnpUWSOlSkiy9ZGsr9
	YoC3VzYUPn3vd9qPe13x23xiHC3UXO5GRXyNsszkS6w8+dzx9JrIlYPRjYqg7HkeZqiRhYtJAMA
	G6hMKhCVG5pfRirXEKE2RbBbl5O2luZcrDZkIrOF6rZ1pcyunV8TUr7hNt4YpACxg/2ZNgPtFiP
	6UhC50h/iUmgBgQEzVYjKSCJeIa4D2XJAO7ThmVY92NNcTnwiCsIHPPWmHVDG+VUV7tXqL0gTv8
	YoTyqpIwtCTOgyfGQVxiSstf1ZiwTcgW4gSuUAVGO3dyMwnIHDmE6c2o2XpX1Vw2+cpBTuXXkF5
	UE8p/y+5zsOOp6VZG+oovsyBsOlyRljch7kW0g==
X-Received: by 2002:a05:622a:3cc:b0:536:7669:7eed with SMTP id d75a77b69052e-536c2837232mr34025651cf.21.1792767024875;
        Fri, 23 Oct 2026 07:50:24 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-536c1846ff0sm18130901cf.19.2026.10.23.07.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 07:50:24 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xKGb9-0000000GkTD-2sYP;
	Fri, 23 Oct 2026 11:50:23 -0300
Date: Fri, 23 Oct 2026 11:50:23 -0300
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
Message-ID: <20261023145023.GH3977851@ziepe.ca>
References: <20261003212241.3432303-1-lrizzo@google.com>
 <0cc1cac1-a500-489b-9c1b-b49598b5550b@kernel.org>
 <CAMOZA0JaiKsRgDdjHkL_N+MshhcyLSv+cT9SzEbNsC_sumHvOw@mail.gmail.com>
 <b31efcd5-149c-4edf-81a2-1744d363c390@kernel.org>
 <CAMOZA0+6kAbwgNwGTsCT5AqpwcZKz4pziEGC9UpHkNCVoqrF-Q@mail.gmail.com>
 <20261022201229.GH3381610@ziepe.ca>
 <CAMOZA0KaanmevmvWS=M3gKfBeborzfCQTiF_xbSeYMWbozG7Mg@mail.gmail.com>
 <20261023140107.GC3977851@ziepe.ca>
 <CAMOZA0J+MOLv+s4PAvsAK1jbasnbQRyHffZw1VEKutH9Vr6ODw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMOZA0J+MOLv+s4PAvsAK1jbasnbQRyHffZw1VEKutH9Vr6ODw@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BC8071C0006
X-Stat-Signature: b7rmjwtbh96u3c3zwfzq9akne9jgkw6p
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792767025-250171
X-HE-Meta: U2FsdGVkX19icL9I5flnDlDvWJL9v0T5/d9RvUOv17XrYFDvVwWQB+QFlEP9mwzSk7QahaBZ859A8QrmjfJcz9f5+O5j2K48cOeDXotSEKBuLSRpZjgbeZ/W456FypymlVme0gjK3dOQpELNl+aiaN7eeEv7knk/iLLB7IrswZ/TRGCP0XBLChpC2v2ZszA2JXlsx14RweJtOPu5OyPAcR7ocnvrk7D5egqbOmVC7+z34S6YGiVWEWTzIx+vXt3zPz4sx/yor2YayO+JSvi9Pz2zSXKkAUdiw0zjEkhv+YezDP6PC7JoHQQgqUwctndRQlN2VH0kBBBSzxGkKtM2tZ8TpRfv4Ja8l3p2n7/UWv4qizHCFoZEoso6BHY3IqlcXL35ZBCEMBDzu7RfAvpeXtucUHCpmEtQVhPmvoOqhlQzLRptNJL8XmHesjNEIMlkahHkaPXYQp2FLx04PKfugbn+bhPy3QYP5NI0eYFERauIZ0v61f7IHlWQsGhj8x7D1khJpf3Cu2rhxaR2HCI9MrQuyzd4lPaCqTW33Y3fmvAxKsKTbW37V7BPsIpKWhwNALa7pmB4S/+4aQafgtCuIjOBXhU5J4ys7EwK/ARH4bdrNR74sflKNy1Pt4RBbhWAlSIOg9DRn2+vWVwS12izwHtI4drfkFEA8JCQdSrDyVM6md+1f5wwUlf1B14JyhkzFZj3s3bHeJ9W6BlHR5YfGWX+curwnbnqs47uUWPjOdSRSsN1yL+HQ1aS6s3+EdWpJeBSnhvMyX9BsgYtq9udoQkIY57rmujMZvhkarVwtKU5lGWdWdHdtCKHVx+UNjU7QVjotjZclf1IopZG82rkhjNrbgIyEVYcBDVP+FTo9k2y+whRe4P1LCfra/mrFSyTs94vl08Z+FN8647ZwydyLcVqNgKD9IbsaghK2MSzmaBDGXCr/twix3L5mwFf6bAsCf7zEhdvTmr9dvtfccz
 y5KQrVow
 9xA7ncnfL437G1GPb0yDatz4j7opjGGie71EXDxbYbceWWUkKStPi+wvQ6WB2U5UOQDCOkzlAs0zgRn4FU23KMNfWDrsHc0QX/tmQpoyZ7w1j5mogNchWNXTK2x4WwYjK74WhVQlBZMrYZzJFo9AuWTAT9EWaOSoPGQv3BOUUmW8BFZCK10sNhOBaT2kdE/gsrdqvpfhX2rCcyQ/T6+Hwd+NJBYfmIlRUnoWTm+4jf/6y8Vod//s7AaaBga70hpBuZAkS00md2KZJfufyPQJKjDp+lOO+S+f7XEBJmrygyc2OKFiYDt+wlY4ROBBAf3PPR7rnvKXAgbHgGWZA+TTBcwEYIiPbbXrn9XSr4jqgXWNS4WxgOwv1edlTa7oQ4zPIWlbR1B9UfPLL6uwJ2Y2AwbPFRRwfN6eta1axzogP8bZqVyruLLjnZSXfEzxGDz5YSpayjb5RVxmOxEe6ESNZtJCVcgB4h2VmhgS0jf8rcakdn8dxrki1B9r1CQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 04:30:25PM +0200, Luigi Rizzo wrote:
> On Fri, Oct 23, 2026 at 4:01 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Thu, Oct 22, 2026 at 11:51:40PM +0200, Luigi Rizzo wrote:
> > > On Thu, Oct 22, 2026 at 10:12 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> ...
> > > > Can someone explain what outside netdev would use this? And why you
> > > > couldn't do this in the netdev page pool?
> > >
> > > I can try.
> > >
> > > Regarding users, the next target is disks (not included in this series)
> >
> > Disks don't use a memory pool, they do IO to folios allocated by the
> > page cache.
> 
> I know. As I said I have a separate patch to cover those IO buffers
> 
>  block/bio.c                  |  21 +++++
>  block/blk-mq-dma.c           |   4 +-
>  drivers/iommu/dma-pmd-node.c |   3 +-
>  drivers/iommu/dma-pmd-pool.c |  14 ++-
>  drivers/iommu/dma-pmd-priv.h |   7 +-
>  drivers/iommu/dma-pmd-user.c | 390
> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
>  include/linux/dma-pmd.h      |  53 +++++++++++
>  mm/filemap.c                 |  27 +++++-
>  mm/page-writeback.c          |  13 +++
>  mm/readahead.c               |   9 +-
> 
> 
> Disk I/O is still potentially affected by the same problems
> (cost if io mapping/unmapping, iotlb thrashing, bounce buffers
> in confidential computing...)

The disk folks already have a proposal to address all of this using
io_uring and preallocated buffers. I really doubt yet another version
is going to be interesting there.

> Anyways, reading your next comments, are you suggesting that all
> these functionalities should be implemented as pagepool extensions?
> (2MB mappings and iommu backing, proper allocator of fragments out of larger
> pages, device-less pagepools, multi-domain mappings, pagepool
> as memory provider for skb heads, pagepool as memory provider for descriptor
> rings ?)

netdev shouldn't be touching iommu, it can get a 2M page and map it
using the normal DMA API. AFAIK there is not such a big reason to need
any of these layering violations. They just make it easier on page
pool..

"multi-domain mappings" is that just for page pool because it can't
easially keep track of IOVAs for all the devices mapping the same PMD?
I admit hacking in a special IOVA range so every netdev has the same
IOVA is certainly a creative way to ignore all layering and solve
it. :\

But you could just figure out a way to keep track of the per-device
per-PMD iova mapping..

That said, if you came with some much narrower series to request some
kind of 'globally shared iova' during dma allocation that might be
something dma-api folks could agree with.. It seems like the only
actual DMA API request here anyhow?

That's a bit tricky since it is impossible as a general concept, but
maybe you can come up with some way to narrow it..

I'm still not convinced this is even right for netdev, especially
compared to what Dragos has been working on. The CC stuff seems
actively dangerous. Unconditionally always using CC shared memory for
skbs is completely security wrong. What I have traffic flowing inside
my VM between containers or something? Does this end up putting those
skbs in shared memory even if they never hit a physical NIC?  Same
with a TDISP capable NIC, does this unconditionally degrade its
security?

Jason

