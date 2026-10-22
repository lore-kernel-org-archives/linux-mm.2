Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BA2C606A336
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 21:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=S/jUlXDH
Received: by kanga.kvack.org (Postfix)
	id 119596B09D3; Thu, 22 Oct 2026 17:52:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C3416B09D4; Thu, 22 Oct 2026 17:52:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECCCD6B09D5; Thu, 22 Oct 2026 17:52:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B5DC46B09D3
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 17:52:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 14DED1202F9
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 21:52:21 +0000 (UTC)
X-FDA: 85351611282.15.B2FDE76
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id 10288180002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 21:52:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="S/jUlXDH";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of lrizzo@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=lrizzo@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792705939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=enf2YbTyhYZro8noMVoZG0AyfViHUg43We1xb8wdUb4=;
	b=MwMnjMOlGcqVePkB9sfVJJo2bsDyfKRhIFI95B6E7qu69+GGdHuKbx+0lopdPLXLpdFgAt
	pJL1M7lr6p9w4IEWJgsCTGWLHdT9nW76q88vd8Bs7+hgIDzU5CfWrci0XfABuq15aJCIMz
	kMp5teLkzC7b90ELJcwBvVHd5hh5JzU=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="S/jUlXDH";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of lrizzo@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=lrizzo@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792705939;
	b=tbkm6SHHaoIddlzquSx1VX+Ls21RxuWL95dS/D1dadSyjML2QIyDZzn5Ja5pOmew+Eybow
	xsXFKeaCOrAouoReoeC6dMnVyzKyF6T0YG4Fz87egGuzFHl+UmlBI6CramzQhbR5kIs7Fo
	ojx6ufv12ZsInKHUELLZ1ZdTNxN3MEU=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2ea7f9c11e6so7125ad.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:52:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792705938; cv=none;
        d=google.com; s=arc-20260327;
        b=pgo7xX9XisejEQ1kNNgtJZQK4evzgKHDJV+j6cggaTy8Vk0MaFmQPVeimz/fEs4DOI
         xZk9js3qx7xtsGZb31/poyL7GmnaeI90OgT+RMJ9HYlwlSZtjHX1CkgwZxfRI3YPTkFo
         2daJq9Zf1ImX9kUPUGb9tEQ28bj1TEWDGN5LJNdr6av5Ks0BzO/2lh8kcjvcRLQl/9m5
         l4kY5YMtYG1yjN6VTlWKE4ftENA+Xzei7wT+nld82NjFSfsRNAXwFHniFsBk3VVWOYta
         mbITmWU4NyXmKMy9wmIaYuTesw1cF5vSlhcryT/Uj9j8aCi3s3e05CU7JT03PEAk2wkV
         9Gfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=enf2YbTyhYZro8noMVoZG0AyfViHUg43We1xb8wdUb4=;
        fh=8rzfzvIozORQpatqOk2QoU4Y8wYpwiM97D9zF2D0TCU=;
        b=jIyTF7I6BxLuKTfVMZSInulfg0Kz9S1vCbrx3GLviGH0O5VDa72Es8BwU+0ZO/GU4+
         ue4AoCvgjcK8NrPCuJWX4+fEKW8noRGc34PCOU+CS3INFHDGdVK2ZYckorY69Oqy+Ivg
         /B/gGkQUW1zvtWhvwNB2sXv4ljWNOn/wbXg2Rj9vhmvEY6BDrzPkyddFxEZGhY1q5FvD
         ECpLvTC+SsxhWEKwyuAYhuxyWPwEcKt2PvzdZtq+GqvS2EceqFpir2zRphe4E1t+BhYh
         wPmbyVEM/Ti3i5E21lJbgY64+c4RXCiVSUfwfRAZg7IcxG2FZ+kTOpwx+x21ny05QNn3
         mvwA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792705938; x=1793310738; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=enf2YbTyhYZro8noMVoZG0AyfViHUg43We1xb8wdUb4=;
        b=S/jUlXDHNW7o8IX4upKPVZCe7taPSINCXoVA82bY2TAuQmYWCxxJlvHUUbE+VYbG7/
         6XHyntpVk3PUaXM+7L2v0bkQwLgPYwZghGCIaAwkKDJxQsLVTdSEWS4b5KTyp+Oz6N++
         xCnJ6biUHN8l7IyTO+ZfAqYB5ws0MqrXXVfGAJCIwKP8resGW5l7+ZjEldZt7GMCmixH
         f4DFqjZpRxSVODfQCo4LzunkY6I1ohoTdt9a6znIcaj+/3AbfqH+ZkpWCp+sZvjcxCkR
         tj2IVyeTXt4u01yJdzGMUTTH8yAsmSkvhcHyIoKCjLi6+iemSPHqnfLiiTnD3nu3sJ5q
         t9SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792705938; x=1793310738;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=enf2YbTyhYZro8noMVoZG0AyfViHUg43We1xb8wdUb4=;
        b=MqgCZlUs+ky6iqZtj8VOW2VGoS3slIwSoiDtO7giiHJ7SKGtstlbUdh2/siT2ymX3h
         YpFjryrEP8cM49dNDu8atJdyU2Vn1RV459bgdEXIDQldaPN1Rmbw2pP1OQ3eI+IoP9Hh
         VDtGsa7GlO3XUtEAFmhoVSBAepMHI74EaZlASSKlzvQW+PoOTc6la1lYeBRHh+qIzfWv
         w/jdflJOHVxw/oG5YECY8xT6NEx8uEH+eHss1CZ7QvxfjnjFMUfvcFYZJnwIz+hP7Wti
         IXXsW4BY7j4BDUp/2jaiplJxJnhry4EsQ6VDg3QRj20J1M1/xwmsYjGgtXhBXKciNjIp
         D40Q==
X-Forwarded-Encrypted: i=1; AKwUvBy285YHrUnjeIHLgjrewlUg+VSDQpwzwxYW3bK8AB5Tz2Tx8XKtAHF3atw7YGPc/fcjAoscWEcjqA==@kvack.org
X-Gm-Message-State: AFq9FYJG/R1wI2wUUdp/xavkrVZ7hboUAAQKgss/Dcm9NjEnWJ3M/Cas
	p5lqegvWVSH7dLUwq/V5hmOPqwjmkxwGC2slr4VofYZbc7dLg49HXdO78c0KCpUZPq0nAsZ7Mjd
	nqcAdAX2goMbbakFGnofN/704Z4Nar04RdNgmqS1a
X-Gm-Gg: AYBFou2dMOrQIG58ScNwdP6oVRNbl/lGC+bRCp8/3/4ZJLWVyIWOzg4dRXeb6LxqJKH
	vdtx48OSrHay6pa2w8ECdQ3McpD6g7LGxegA3oPFQige26wor3GgOGFOSSysngvaYxRF0+58K01
	Y29pHQsLOepeWttFkklUaYhIiIHTuakaolOo6COwAjh/3jE5uDcVhm8/nTgZ7oIbeU7YeybzRZY
	E9x0qItm3KKzJ6sjvu8xQT+azcq5BD0umwPdGmVtM0vQg5APXk9PcOW4cr99wuNuF9Y9kBBRj5K
	LBgp0mK3Avk4vrKYLv+A8uQkrCxtTP5uUHImCozVERH1sx/iQpAeQz5KfhtN/LDIN2OcAsxe6XH
	3DWAZydcXpLClk12QZkZZiL/hpXmjRymg90WAaKkN5MY4FZe5injAbZNJdZ4=
X-Received: by 2002:a17:902:e881:b0:2e6:1917:fa with SMTP id
 d9443c01a7336-2ea7ed0feb4mr728955ad.7.1792705937217; Thu, 22 Oct 2026
 14:52:17 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com> <0cc1cac1-a500-489b-9c1b-b49598b5550b@kernel.org>
 <CAMOZA0JaiKsRgDdjHkL_N+MshhcyLSv+cT9SzEbNsC_sumHvOw@mail.gmail.com>
 <b31efcd5-149c-4edf-81a2-1744d363c390@kernel.org> <CAMOZA0+6kAbwgNwGTsCT5AqpwcZKz4pziEGC9UpHkNCVoqrF-Q@mail.gmail.com>
 <20261022201229.GH3381610@ziepe.ca>
In-Reply-To: <20261022201229.GH3381610@ziepe.ca>
From: Luigi Rizzo <lrizzo@google.com>
Date: Thu, 22 Oct 2026 23:51:40 +0200
X-Gm-Features: AclHuK-9aqzBfV-60_dzPgAjNzAFJyPZLZoLZFY0CUqnWbJGyVX0XJhPkps5rLY
Message-ID: <CAMOZA0KaanmevmvWS=M3gKfBeborzfCQTiF_xbSeYMWbozG7Mg@mail.gmail.com>
Subject: Re: [RFC: DMA_PMD 00/22] DMA_PMD: PMD_SIZE-backed IO buffer pools
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Luigi Rizzo <rizzo.unipi@gmail.com>, 
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Tony Nguyen <anthony.l.nguyen@intel.com>, Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Michael Chan <michael.chan@broadcom.com>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev, netdev@vger.kernel.org, 
	linux-mm@kvack.org, driver-core@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 10288180002
X-Stat-Signature: zzx1sycyjywf94zo93frpw98b4kfmo3x
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792705938-368282
X-HE-Meta: U2FsdGVkX1+pYl2eqUlIxPZX1vDW7CvtrFqGhGPiASE/fAigF8sO1s3o/u4XiOK750Q+crlEopq8lwuoLXeyIZ0TnMib+204qtBqKhSWk5WBNNlZHDXz53aV9GhZEed923APCOlEgeiffUl0x0cAqESkV2gqlwOYpJEQrIxNiUOwsEl+jLomxvGbJ1EMVKkchxOJTownE+UaFuilE4x7qGxiCz8eJ1iYncum+LjZQCJwM+ti6jkealEeA/EjrliCIePdNC5KXU6B9WIRl0risfZXP5MJyQb9Cf4fjoupe3LtwwOOlXdVVCDeTCGZ8gJGrMK97ZfYvve2wi6xhi2Anj77/eI5+4+aMlNYAC7UxGrIr4WO9uCiMrbyXMSOKl2NIjhYUw/Og1Hk9TNmcMDPIhc6SQ6qY0eH6JcWQIW9gsvPRfjo+SqT/rFn/xIZehgUKe0CejhE1SWKJwweR69+xYQA0kCAvmvBkSFGu51n9lRTOv+uz0fFgn9KJXpemBsSu1LgmUGAELdh4Muw9CvChvSIGR7YTXyH9LR7JQep6EAIpblPQrgyQyIzL78cEkvwzMpknX6Yu6Fs+qRxOTYO306xFtBWQu5KUyibaMf64Lw9vAvHmxFXzZdFIyjHWXn6WM03o/dEodD+rS7chrIm9qmSTNYCeJfxVdI1xgRrNjDYFJhn9tczDnCSO+0NmLAkcyfLtk/uWPMqhW5piKMpur8y2LPPD7iVOiSWJDmRivpD9pAxzieMLcD90r97DAOrWEwYF75rVuLR+MNNmUMUdFEeBD7YTQfPIRTWJflJ9SXHZ9Q5F6xww+KgdN3NgNXQLYpM3bDbyEwxoVFPkvsz2/WwABZ40vWQ7DDhNOWi5Egctn7G/kWmxLNOowc6rFOUG+9W2Ha1+IQ07d3fTNqTONM1kQEpis7Vn/bkWTRHf40JYwDv8kK4jbKzKONxvu8dfCVMEN9X4gv2OzFLZOo
 pIm9JJW9
 RnGSy/xiRD7+lDs6knOhPqtLy1bWMSm+K826rkjPCknGOdEjY8EKjBowfMQO6lQYAOpWmmmw3FiHTSMNB/m+Aty6g1r7e6wTHaYWY7QdDMgGhB+ghRf8q5M/ebHOmUUM9/4bQDHBuvBIXpjJfkhqkkMZ5BNx5pONY0+PYMGl0j7Fb6mdIT2MTpBDiCm8zCuJYMdaXd1oX4vwDdkCa3+SQ0wmcZiaY0y6DieNct0QoFwn/ULgY41ERqLzcKpNr4eClF2qF95biRyeKTBkrsmiYhbfLQy5/IJiCs4HIxhgPWDllawtc0jCnc1s3u8oIr+iNbWQ7TSWN4apRV/KjsGRnuAXF6zAgzCiSgHDIIJgLTYp3E8YE/TYP+TCDguTMOWkwKLG0ht9bUfpTkscbxTyy0LIJd3phmAMOu2TBg5QFoGu3JlFG0HL8g29yL7XOGDt+VxQFnnx3+QlLBMnMukVjfExl/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 10:12=E2=80=AFPM Jason Gunthorpe <jgg@ziepe.ca> wro=
te:
>
> On Sat, Oct 17, 2026 at 07:11:28PM +0200, Luigi Rizzo wrote:
> > > We should probably just find a way to describe that this is a POOL th=
at focuses
> > > on physical contiguity in some configured granularity.
> >
> > Before embarking in a global renaming, I would like to get opinions on
> > acceptable alternative names (possibly with a short prefix usable for
> > identifiers in the code). I could think of the following
> >
> > DMA_PMAP (for PreMapped or Persistent Mapped)
> > or, ahemm...
> > DMA_PISA (Pooled IOMMU Superpage Allocator)
> > both using dmap_ for internal name prefixes
>
> Can someone explain what outside netdev would use this? And why you
> couldn't do this in the netdev page pool?

I can try.

Regarding users, the next target is disks (not included in this series)

Regarding why not just pagepool, see below.

FWIW when I started this (after the previous work on swiotlb copy elision
https://lore.kernel.org/all/20260824152932.1583506-1-lrizzo@google.com/ )
I thought this would take only some simple tweaks to pagepool and
skb_page_frag_refill, a couple of days with some agents tops.
But the agents did point out that there were a ton of corner
cases to handle (device detach, reconfiguration, memory
reclaiming, reducing locking contention...).

As a reminder my goals are the following:
- reduce DMA map/unmap costs in strict iommu mode without the DMA-FQ
  compromise on security
- address the IOTLB thrashing problem when using 4K mappings
  (very serious even with DMA-FQ)
- help reduce bounce buffer usage in confidential computing and
overcommitted VMs.

With that in mind:

> It is not a common workload to have the DMA allocator be the one that
> allocates the memory. Usually we are DMA'ing from memory that was
> allocated someplace else.

Aside from the fact that dma_alloc_attr()/dma_alloc_coherent()
does memory allocation + iova allocation/mapping,
this is not what happens here.
Maybe the confusion comes from one function name
(dma_map_alloc_pages()), but it doesn't map any thing.

My code (in this version, and more in the upcoming release)
mainly implements a specialized memory allocator with an
API equivalent to alloc_pages() and variants, but ensures that
the order-N blocks come from contiguous 2MB blocks reserved on the fly.

The physical addresses of these blocks are recognized by the
"dma allocator" (I suppose you meant the entity that allocates the IOVA ran=
ge)
so that it can apply specialized IOMMU mappings backed by 2MB IOMMU leaves.

And finally, it hooks into existing kernel subsystem (pagepool,
the skb transmit buffer allocation, dma_alloc_*(), dma_map_*()
so that devices can opt-in to use it without any driver code change.

Regarding pagepool:
For the receive path, I do use my allocator to feed pagepool
(in the next version I have wrapped it into a proper memory provider
interface. Non-pagepool NICs can either use a few trivial changes
to call dma_map_alloc_pages() when filling their rings,
or convert to pagepool (slightly bigger change; anyways
there are options).

Note that just feeding the pagepool with 2MB pages is not efficient because
the fragmentation in pagepool is done with a bump
allocator, so recycling blocks from a 2MB page is difficult
(it has to wait until all 512 blocks to become idle). My code
has a bitmap to track usage, so it naturally recycles at the block level.

Then there is the transmit path.

For skb heads, one simple solution is to use tx head bounce buffers
some of the patches in the series show that option (the next version
implements a proper tx-copybreak).

Otherwise we need to populate skb heads with pre-mapped
memory. In the next version I have a simple modification to
the slub code to accept an opt-in alternative to alloc_pages().
I considered using the pagepool, but the changes would be
similar and the layering seemed really odd, with a cache on top
of a cache.

For transmit, there is a bit of impedance mismatch as well:
skb_page_frag_refill() does not know which device
we want to use (in fact, it is a per-task so there may be
many netdevs used by a task). We could tweak the pagepool
to be device-agnostic, but that would be a bit more
intrusive (more architecturally than in terms of code);
also we need to make sure dma_map() on those pages does the right thing
without trying to map/unmap the individual 4K fragments,
and we need to make sure the skb_free() etc does
not leak those pages into free_pages().

>
> I think Robin is right, this is just a special case of the dma pool,
> and it certainly shouldn't be something as grandiose as a subsystem..
>

dma_pool() could be tweaked to allocate 2MB and return order-N fragments,
so maybe that could be a provider for pagepool, but it has some caveats:
- when fragmenting, the freelist is constructed in-band, ie using
  memory exposed to the IO device. That is really a no-go if we use the IOM=
MU
  because we don't trust the device, so we would also need to
  allocate extra memory for the freelist (no big deal, but
  that is basically what my dma_pmd_meta supports)
- memory is never released until the pool is destroyed,
  so there is a problem of stranded idle memory.

Trying to use dma_pool for the transmit path has all the problems
listed above: lack of device, inefficient release of memory,
coarse grained locking...

In summary: of course we could tweak existing subsystems, trying
to reuse them in ways that were probably not anticipated
(see the above partial list of missing features).

I think that once one addresses the functional and performance
problems, the changes would become quite intrusive and the risk
of penalizing the currently supported code path might become significant.

cheers
luigi

