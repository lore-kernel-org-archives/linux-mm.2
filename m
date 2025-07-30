Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C653C83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 14:28:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C7CA6B0089; Wed, 30 Jul 2025 10:28:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49F5A6B008C; Wed, 30 Jul 2025 10:28:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B5CE6B0092; Wed, 30 Jul 2025 10:28:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F0806B0089
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 10:28:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AA57D1DA713
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 14:28:23 +0000 (UTC)
X-FDA: 83721161286.23.4233141
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf23.hostedemail.com (Postfix) with ESMTP id A9659140009
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 14:28:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=ivepKDsg;
	spf=pass (imf23.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.181 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753885701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yXicpotvi3lyQ9AOXQWfwG3KeaAtrSGGP0WC4PeRJ0I=;
	b=iRYaQKaPvEtE5WrujTbrl0XDo9GuUu4oOSgcjo63z30B6IdhrN0+g5R2UO6qCw73lNJSbA
	qajqJxXhWU1xqrX9YNjU9ZGgZlSc82QZMszx0b5cqfYJg5/rqKg6Zutr//FPnz1c+tpGtG
	WymHrGEY0RUuLp9hmA8FAq0iIIskFek=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=ivepKDsg;
	spf=pass (imf23.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.181 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753885701; a=rsa-sha256;
	cv=none;
	b=lgs0gHgd5A/UjwNCxED3tBbntLQlvWvjBwdy3ljHWQtMnyWq2VBR6PxWhhmLl8lmeTy6Ow
	sCMoZ0d44iDXPBZ5cMOkbl9r+aXsKSYjcq81hILLIhQuAwdjp0qrBidnNy1XnJ4cPv/36C
	Xoa9E0rdX451SX19fo+F2m3PstHSH68=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ab61ecc1e8so53617591cf.1
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 07:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1753885701; x=1754490501; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yXicpotvi3lyQ9AOXQWfwG3KeaAtrSGGP0WC4PeRJ0I=;
        b=ivepKDsgA5+opb31RvJZ79SQEi3pMIJ4rvRLN70I03RiUqWH7gptYNrbUwvUJkoV7i
         S8+GX+V87lQZUU2jR91fP9baOKNV1jyWmQEkKvu6GR6zktANYBLNpgxZRlOkzlz0iWUz
         nB2SAe5gV0+OzygPQ8w683MTD3KT6Vf6DIxVS2F/vgiA0DVwmrAOsDTNSRSIzhGXTDbu
         yvhXkpMX6FCqxKgiTRY55zJUvq6GKe/WG4X82aRjouA/INt/pxTsKOdNPGerx2mE2eM9
         Y6E0e8A7nb17b7QGGRa1rYQAe5QbQwwEOXP/1ZZECt8JWiTopzwjFUK0XWWBRukZwMYj
         R+Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753885701; x=1754490501;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yXicpotvi3lyQ9AOXQWfwG3KeaAtrSGGP0WC4PeRJ0I=;
        b=LDoHGrTn7bhZYKL/TFY0AnbQj7hidaA3Xz6mOKMzuyPKSRzzpSZfexwvjBLDrO9wyo
         m7cVEEdGhI1Mdw9fAoXCD0rIAnqnqvBPsZN50T97wQKLMg+aRdb6+tzejqwMVScM3BNR
         EF7afciVZBrttG713E/QRXvqFNCuvmrrkDv1G/9jWZKMoVa3WZDnqkMYDyxb8Pgp3YRd
         wpDhNcf4sWgwr9QP9//uTNn1ZxC8lrfpfXZqPVJsx1rPaZ+qzauZVlwm9jlLFa79v5gz
         JTsrxBxqXqOXNcNWF2TNE4OwvDx5+fXm59EnYK5md49njkLDoSOIecxfBOEFzRi0DgaV
         pHtw==
X-Forwarded-Encrypted: i=1; AJvYcCWgtgVjILo5CD/MR/kE7dIzSNzaXuZLgEtQl+PEem788QbKlbshI5d+4N6DH8M+x6czP5jnIxZf8A==@kvack.org
X-Gm-Message-State: AOJu0YyplmmZBiC5H1NVhjIf+6Cc5eWlANCGZHTCNsNT59wSRl2YQExS
	BoubZ0x8WcACmpXxxsOLuUoj9nmRUVG7/20zoLE1omXRFmtbdNw2mfSP3yOgiFfiPW0=
X-Gm-Gg: ASbGnctLn+RzIzJSF7X0oyDKGUg9/kILr6mMUvKP8243reFE5sK8unktj3oSl8pqOcr
	WrT8qBH0VubPTxaYY49WadrofLKke9RAIiFJJ0Vlr5DJsHk9kZKkyWgxzEzTxJHYb166bYXFz0s
	F79lHpXP0/b+gHW8IR2E7Kj5tE8ClfKVY9HHTIZGn3SZeUhFLpkaQkqaQ+HVacm5j2QPaLEKoRb
	as907vp9MAvo/qhgBDY9OUhvjW1iB1d7LggNWh5z6/TLJyqah9+DqCRjawZ+49CeK4oAi0F8ezm
	vWns7wmShV6YWuuWBQmBDCrGdHXThYemM6o0E8Vehr0tvunkwAkQoWrOgF5m/cWCdwy3Jv1BKsH
	jL1Bp4va34jKzTg0Mws1rRnmYlEM1PzGdA+M4nNgpYIv5p2iCA1KFxThS3Z+0rSVFlbon
X-Google-Smtp-Source: AGHT+IHCzPfwaMM+aIDs6tu6c39/KdwhCla3PbAO01xs1vOnpsn8EpRRsdfpw4N6uvD5MCuSC49wxQ==
X-Received: by 2002:a05:622a:48:b0:4a9:cff3:68a2 with SMTP id d75a77b69052e-4aedbc3c0dbmr55369321cf.37.1753885700213;
        Wed, 30 Jul 2025 07:28:20 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ae9963b6f9sm67178931cf.35.2025.07.30.07.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jul 2025 07:28:19 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uh7n0-00000000RbZ-432A;
	Wed, 30 Jul 2025 11:28:18 -0300
Date: Wed, 30 Jul 2025 11:28:18 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Leon Romanovsky <leon@kernel.org>, Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@redhat.com>
Cc: Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Christoph Hellwig <hch@lst.de>, Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, iommu@lists.linux.dev,
	virtualization@lists.linux.dev, kasan-dev@googlegroups.com,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/8] dma-mapping: migrate to physical address-based API
Message-ID: <20250730142818.GL26511@ziepe.ca>
References: <CGME20250625131920eucas1p271b196cde042bd39ac08fb12beff5baf@eucas1p2.samsung.com>
 <cover.1750854543.git.leon@kernel.org>
 <35df6f2a-0010-41fe-b490-f52693fe4778@samsung.com>
 <20250627170213.GL17401@unreal>
 <20250630133839.GA26981@lst.de>
 <69b177dc-c149-40d3-bbde-3f6bad0efd0e@samsung.com>
 <f912c446-1ae9-4390-9c11-00dce7bf0fd3@arm.com>
 <20250730134026.GQ402218@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730134026.GQ402218@unreal>
X-Stat-Signature: 8tekturr1fmc7p9wc6tmf3pzzrnzwro6
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A9659140009
X-Rspam-User: 
X-HE-Tag: 1753885701-417500
X-HE-Meta: U2FsdGVkX187kP51rydfafgftof1i7Sr2v6rQ5+9y/PhlS5ZOaOfD42IKz4I2LGTTz6jBdeqzLyF43VhsPr6fXlhm+bUCEhP9saqE8mMSex0o7DLRuIaP3qghLadxUpyeWNUDlz4FJ2P0tpFW/pJ/KX/YQynsW+beElXNYDvU8PiEb3Hos149BMsCuH3kDBqGJchj5c6QTL1i4putGk+Bz9g8z479AFeB+yi42xBAmjLvf4kKUbZeyknqecyfaVfkKa49SMk5og19FjSe2HNxu/vpRBV9zOdpD0TSh5H1O2Re2Ic7uEYR4xAOcHTzyJNr5ve3iZYxa6S7XGMPccX4rV6GQUdWbFqYNpdySXdEhZWELVNEefIaonWclMUw7SWa1cj+RI/DTGVTbqJUS+hF0ctEQo50NsXBCu/V71cuu9O5qQ5uD37OW6uvGOT6S/p601yz3ES/NqS8Qdco69FI22syUYes5NNfOac27R8HhB+W2SIR8+TZxvNwjr+WOd4n3wh48BgyPHXvV/md3CP1C6DyFN4sVlu32cvRISg8w6ha6XBBNRjplyLfw9Pnbvevox1NTzcBWm0KXO7ruprM5M/8AS2BJvmsum8gImPe5H2M911EB4Ox0gq1NbqdhWB1D6ee2rC8r1JP3NydEKk2RcIe2VIS+PdKUPl61vWOJI7FTLkaARlWQmWd9uTAN6s8/JeHs3BYj6d8EoGY5qyu7x3tWR6wRKa6iK7Rx7Nh8WtvKMye1VxUaqgg1E1D+jO1kwRs+d5rujFwJokjXE4++TvzuHlgBR+r/jIVMEACn9HGzB7PORr0wJVdUW57rIyhfVeHw8duXXYwQ9xhhhV1uJaaPFDHnWWlbPX6ErDBMM77LEkIleyRRhTpnwBSlj33N8zLuouU6Lht5U1K0gISa2q/3L+kzpiQfXteExUZCEADxkqnnhdEzRqXX9entKq9++hXEjGadmBaX+jAvt
 vfPTudRl
 TWzCJDpNHMTD3xrzZg/OhGOAQ49C6uoEe9i3MIHTfymrEsuQPB1VD36nBHWI3V6eCO7Sz8naP2Z3KqxARnpyOvxR4/8b6ePxunZUOB+ilAsSUxOt1UVBFrj2iRXSFEIDUBvqsvcHrua33LWp8qYgmNAiV3XCiIqfWDe5O6d46RKBg0Q9N8eXJ91xHMZwTnpjkttQTQScFIVTneWLjXJJbuxBeix0Rwgp40rv8PZgsDvbo+SDsP4cbSAk9/TxwnpTmq8Ti3vBICDID8f1CRSS+CODituSuboBZi35IHYpdxexhxFgYf5X0v8r2rhCmGjkSXM5xTf5OVgAWonsucCZiOUWPVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 30, 2025 at 04:40:26PM +0300, Leon Romanovsky wrote:

> > The natural working unit for whatever replaces dma_map_page() will be
> > whatever the replacement for alloc_pages() returns, and the replacement for
> > kmap_atomic() operates on. Until that exists (and I simply cannot believe it
> > would be an unadorned physical address) there cannot be any
> > *meaningful*

alloc_pages becomes legacy.

There will be some new API 'memdesc alloc'. If I understand Matthew's
plan properly - here is a sketch of changing iommu-pages:

--- a/drivers/iommu/iommu-pages.c
+++ b/drivers/iommu/iommu-pages.c
@@ -36,9 +36,10 @@ static_assert(sizeof(struct ioptdesc) <= sizeof(struct page));
  */
 void *iommu_alloc_pages_node_sz(int nid, gfp_t gfp, size_t size)
 {
+       struct ioptdesc *desc;
        unsigned long pgcnt;
-       struct folio *folio;
        unsigned int order;
+       void *addr;
 
        /* This uses page_address() on the memory. */
        if (WARN_ON(gfp & __GFP_HIGHMEM))
@@ -56,8 +57,8 @@ void *iommu_alloc_pages_node_sz(int nid, gfp_t gfp, size_t size)
        if (nid == NUMA_NO_NODE)
                nid = numa_mem_id();
 
-       folio = __folio_alloc_node(gfp | __GFP_ZERO, order, nid);
-       if (unlikely(!folio))
+       addr = memdesc_alloc_pages(&desc, gfp | __GFP_ZERO, order, nid);
+       if (unlikely(!addr))
                return NULL;
 
        /*
@@ -73,7 +74,7 @@ void *iommu_alloc_pages_node_sz(int nid, gfp_t gfp, size_t size)
        mod_node_page_state(folio_pgdat(folio), NR_IOMMU_PAGES, pgcnt);
        lruvec_stat_mod_folio(folio, NR_SECONDARY_PAGETABLE, pgcnt);
 
-       return folio_address(folio);
+       return addr;
 }

Where the memdesc_alloc_pages() will kmalloc a 'struct ioptdesc' and
some other change so that virt_to_ioptdesc() indirects through a new
memdesc. See here:

https://kernelnewbies.org/MatthewWilcox/Memdescs

We don't end up with some kind of catch-all struct to mean 'cachable
CPU memory' anymore because every user gets their own unique "struct
XXXdesc". So the thinking has been that the phys_addr_t is the best
option. I guess the alternative would be the memdesc as a handle, but
I'm not sure that is such a good idea. 

People still express a desire to be able to do IO to cachable memory
that has a KVA through phys_to_virt but no memdesc/page allocation. I
don't know if this will happen but it doesn't seem like a good idea to
make it impossible by forcing memdesc types into low level APIs that
don't use them.

Also, the bio/scatterlist code between pin_user_pages() and DMA
mapping is consolidating physical contiguity. This runs faster if you
don't have to to page_to_phys() because everything is already
phys_addr_t.

> > progress made towards removing the struct page dependency from the DMA API.
> > If there is also a goal to kill off highmem before then, then logically we
> > should just wait for that to land, then revert back to dma_map_single()
> > being the first-class interface, and dma_map_page() can turn into a trivial
> > page_to_virt() wrapper for the long tail of caller conversions.

As I said there are many many projects related here and we can
meaningfully make progress in parts. It is not functionally harmful to
do the phys to page conversion before calling the legacy
dma_ops/SWIOTLB etc. This avoids creating patch dependencies with
highmem removal and other projects.

So long as the legacy things (highmem, dma_ops, etc) continue to work
I think it is OK to accept some obfuscation to allow the modern things
to work better. The majority flow - no highmem, no dma ops, no
swiotlb, does not require struct page. Having to do

  PTE -> phys -> page -> phys -> DMA

Does have a cost.

> The most reasonable way to prevent DMA_ATTR_SKIP_CPU_SYNC leakage is to
> introduce new DMA attribute (let's call it DMA_ATTR_MMIO for now) and
> pass it to both dma_map_phys() and dma_iova_link(). This flag will
> indicate that p2p type is PCI_P2PDMA_MAP_THRU_HOST_BRIDGE and call to
> right callbacks which will set IOMMU_MMIO flag and skip CPU sync,

So the idea is if the memory is non-cachable, no-KVA you'd call
dma_iova_link(phys_addr, DMA_ATTR_MMIO) and dma_map_phys(phys_addr,
DMA_ATTR_MMIO) ?

And then internally the dma_ops and dma_iommu would use the existing
map_page/map_resource variations based on the flag, thus ensuring that
MMIO is never kmap'd or cache flushed?

dma_map_resource is really then just
dma_map_phys(phys_addr, DMA_ATTR_MMIO)?

I like this, I think it well addresses the concerns.

Jason

