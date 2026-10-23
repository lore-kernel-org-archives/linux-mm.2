Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2975606A328
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 14:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Rw0Lw4Md
Received: by kanga.kvack.org (Postfix)
	id E29BF6B0393; Fri, 23 Oct 2026 10:31:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E011F6B0395; Fri, 23 Oct 2026 10:31:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D169C6B0397; Fri, 23 Oct 2026 10:31:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA1986B0393
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:31:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2FA081C006A
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:31:06 +0000 (UTC)
X-FDA: 85354128132.12.6A02BC2
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3C137140015
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:31:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Rw0Lw4Md;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of lrizzo@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=lrizzo@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792765864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s3FkMl8OhjMqOhi3zpzbiZNiNsx48LLQzOlCjP1CveY=;
	b=Qyt7tcsKMePcUnxIZw3QXpsKdJt0cQdWNi8oFvYvbX/jeJxsHUTrcLg38l+cFAAObGlJGa
	oio3uDv3HUHj9U7WyjbSofKxN8KD1l33PE3IegSIRn9kkE6mPmltwT7+BQvkzBnIoB9d8c
	scqpl/FBGYDkB4oN7NQyepyTlP0qmSA=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Rw0Lw4Md;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of lrizzo@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=lrizzo@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792765864;
	b=Te9Ft3jc1c3HsRkespG4HQajkLmWfj7NB6l6XeZstR7C0oOV+jB196pjVujUi2yhosclTB
	Hx9f1nVxd3cojNmCA22j6FBHwIxr7aKKgE6vD60rW4TLeri4ekfwjtCr3H7wDOkk7f0dsz
	m9mWz/zAP9pGPjBBke1uFPUeWAyKx2k=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2db33db4de9so70995ad.0
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:31:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792765863; cv=none;
        d=google.com; s=arc-20260327;
        b=diwJCsg7QuUHb81mBltBhky8ndb+z4P1yj67wPQ5pKk0//aMhpyMAuvPst4kNIrpxn
         1NrOoMxc035XfZFloVNSxEWn4KVRyXIHzrG6zyvtWf26gse9I2Sp4KQZd+2bvZTgzRyZ
         oRCfRRqG05LvHJZLFQAtnvUfKxjS7aHgiM8fJsa/nwyvZvigZl+J25I8DepPyjzsQjRO
         gLbdeguycvigPUbqNSvbHFoGWDogXe5CMlgVZGmqI8OvHzVUgBrTS7UAPW9pa3T6Kac/
         sImpW55lo3JqfVHNgfenF1j9if+UbXFVvBRohvPML4F2hR9gNMaB/jpSbFqJMFr4rZ+x
         XvZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=s3FkMl8OhjMqOhi3zpzbiZNiNsx48LLQzOlCjP1CveY=;
        fh=QyilLk2THul8M42iDd8SVvq6PUl83Q3WhRm4r2VPEic=;
        b=HN2SMPvFzog/ZKA5LxC49nbMMWPV60Ld3YvPXcXdEwaU4xajFuBWFT4ZKsGGu8TZKb
         jn7SjA6A1j3fezzSprTDZV+6eUjmWk39fkp1HSUQrjDEuCSoDRCo234U1r7urMmFIKWy
         paUwWK+qdne27xuaxNMd5h7yMkj4KX6kIwUQgGu8k7OYd7PA53mps713FQ0/v612MlKn
         xbTYt6vIs0Z6+lnSfHYOof/p7NqpmKPH4Xg07A6ZSuJiI0Dc8SkT7U+ijQB8Q4DEql/7
         XNdHP3QWfoYj/wLvQ8phVJa26HA6V6aF9gzNX0zvx8M6OxIqLny6ChHChPzAZHThpdsl
         ieuQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792765863; x=1793370663; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=s3FkMl8OhjMqOhi3zpzbiZNiNsx48LLQzOlCjP1CveY=;
        b=Rw0Lw4MdGiJe2XUb0YG3Il8GX4EVcmi1gP4DsJeP9r3OWmoAv6R0vVSBN9r0soKFqe
         IYhhPMBbduX7K/66MtnhUv74AFhrltV2G0PIzvlzkehUY7HH7fMGFN+cYsFnOIYYVMlg
         iY7pT6+eWAkChLg04MsYbuHpZ5WrqAf/xT0xGuWQBl0PokFbEYUy9g5QL6AFme3TxYcy
         6E3b5jGEN/j7SNUaDVEMogPmcxDuz6MGWSJDE8LS7vMDEmHVttFZs+SPYiBxIXuME+yD
         N2DIizu2B6vBstrlHaCHPxemzLBCIeZRoWWehXaaVzI16sHGRV5ePfRypu8kKsONydbK
         sKOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792765863; x=1793370663;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s3FkMl8OhjMqOhi3zpzbiZNiNsx48LLQzOlCjP1CveY=;
        b=tzogAqrsgn9+8OzeEpqzh2Q5iAYR4Gphln9kg5FnYHynfnC4bE3FdISR9x2N+L5v/b
         pF1f80ZYfUmR4RMx39djXvdq1fbsO+Iu0sgoqQIcH8IzpBqad3eB0mxK5CksbVcmXXS+
         YRxEwWKy6AHA+ef3/PsJJc7qUFQIxgY67Uv25W2JLhGVgIjf1kMogtBY6ZqiwBYn2ZCP
         o7wC31IHKOhd35vm+HEIOm190rNKnzHBv2+H8dfMBRvkU4XciEHrsTVT/fopohlEJ0me
         J3oKbThOkU6S5hUA37heBKXXFPd4UGjaKVn+Q0gywvFpeGNCuWGDsjh0ekWBCi+R8Kgp
         2VOg==
X-Forwarded-Encrypted: i=1; AKwUvBxueccLzfK6gDJ8cETSCBS5GOXFR0tfNZDeORvY3cAX+GJx1DbjbVYkaxvT5Iq/DrSQL4gU9EiflA==@kvack.org
X-Gm-Message-State: AFq9FYJBeRcm7DzAuPgikR17N1G5hKYUCMOKjFZ7OAM2rftcgFv3I2QO
	yGyZfmqL3smHmhBLF1Mkbv0mULLzWCCdP2Kkm1nt736f+gUCduLVdCT3JKa7AK1UGsNFE810lNk
	7qrYkoVCmraoJ0JKpU0TnMXPo2hbyW7ibOEJTzo9a
X-Gm-Gg: AYBFou1KbV2n+HZgDO8/RtKkcN9dcui9kfN2M2JqsW7CS1RA9L8wCV0NfAKH1QSr6Ez
	I4ytSFS9kg8NRcOpOmhPJPzJWI24bmjE1kRTXEA6hPrMlcbQtHDwu+uA9y1e3f0zObqA5q9YJvv
	tLfXVljqvOeCeOV7aBnm8xoeaqB0IbLsvv7anf8oz6caBven++Hh6DAxYaNTY00afHnHPzAygYx
	IEUYGG/slgH6tQd5ljrMOnp2ZQp/bwciaR+BRCIrIU2rid5u4m2Xtk8k22PF9qvtPsMeWixRsJT
	DGHVpQV7mOAm0GpCM+AFof8GUY3EZPXqwPlRguYubZbVSD3pftdxcSOYZ19hluk9zDOonJPVqHz
	1SGUo5qcG+RhDW/3rkVHG9Oh7b1ZydJZ/FmxBEqrJ+7+1XsgH868lWaM6rdY=
X-Received: by 2002:a17:902:f683:b0:2ea:7180:3abf with SMTP id
 d9443c01a7336-2ea7f512f16mr4025665ad.15.1792765862249; Fri, 23 Oct 2026
 07:31:02 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com> <0cc1cac1-a500-489b-9c1b-b49598b5550b@kernel.org>
 <CAMOZA0JaiKsRgDdjHkL_N+MshhcyLSv+cT9SzEbNsC_sumHvOw@mail.gmail.com>
 <b31efcd5-149c-4edf-81a2-1744d363c390@kernel.org> <CAMOZA0+6kAbwgNwGTsCT5AqpwcZKz4pziEGC9UpHkNCVoqrF-Q@mail.gmail.com>
 <20261022201229.GH3381610@ziepe.ca> <CAMOZA0KaanmevmvWS=M3gKfBeborzfCQTiF_xbSeYMWbozG7Mg@mail.gmail.com>
 <20261023140107.GC3977851@ziepe.ca>
In-Reply-To: <20261023140107.GC3977851@ziepe.ca>
From: Luigi Rizzo <lrizzo@google.com>
Date: Fri, 23 Oct 2026 16:30:25 +0200
X-Gm-Features: AclHuK9d7tFq_s1fhJmYPVN1-JncgZCOvwLUHaeunw-YOxbh9iZtFoxmVAkcY88
Message-ID: <CAMOZA0J+MOLv+s4PAvsAK1jbasnbQRyHffZw1VEKutH9Vr6ODw@mail.gmail.com>
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
X-Rspamd-Queue-Id: 3C137140015
X-Stat-Signature: tyeteuhttpy5mw3aoujhgqyryqo7uawu
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792765864-739358
X-HE-Meta: U2FsdGVkX1+TCtzEFIrOrDLTH/EZEWX2fAbEhdk9npYb1Io7k1OBluFvyRWMybLdIenM3Ul4QG301vFnX9roz1R82ICmx8sw+0AiEdRsJAGmsX/l8qee/R/tgDapPO938nhfIqVxklhdc/7FC+3jBEC/qTr6hEB8tfSUT7MWsisCZz7O89B1p2Hrx4yaa5FTMqiptzdPZbhAKZoVihziaF8Nv/HsgqzjexcKr2QxFQSn//MBSNLuxoBr6M86krn+K98DFlH8/FBUC9fQAGoX2vULZusrvHXaE1x03JEayTHmd4+KsAAaXaFKnfNIHrghUR5y6H0Tk48tSqa8X8ab3YM88H7XhsSNX9jluujnawkOMsMtgZHn3cfcZnlza3KuXWKEdckJ3MxDfCORimJPqzrsKuV1q+v4W7kiLkCzSNmsb+milRclpzIQkEqfvg6UtM0lTGvoGm7su3wG1ZxNGJYuqu7vZ7boHpUvRBdL77ZDpE2Bni4l2zgt+QdnFS2fizQLvM9WIEAcYAJJmgC5b95Zl13Jxh0gDZ8sfU8+frL3uO1hSiDkCg4tiUi4tOO8fBoSs5lhbNsXUEXY1Nvv0X68AGRpnv1gfgh99aQCID/ptKLLxp99SmiKvsR7//MiBTJMtG4C5jAGPD4lDBvouDLNDpn7zRHsReB8rG6ZSkDTpPQOBAF7S8w45XBFxXiYqxHc6MJKwESqk6qI5BqjQ5Gp+IGGO/B8OTTl9xT5aMsdToAT078OrLpbhA2DG8W2gfqOOHDmqyqozY8FsoVm4yiNylmDIiVDUAXrFo3dlT7PHo2KtNHwb9gBRoulB7P3AhcpZlyIi9MdPhzueECScRNFSD4XR8W3Hb+F6rmbqKZq2DdieLR5Kgd/hyKmtRXrxJfSlnuhqpCd/u0bWJXVUixwAzgEsL/Nn8dYCEFOKzVX4L1fidCbJWZbiewGqzycdiw+0Hym4G5iwDvwnc/
 /PA1aZVt
 xXo4IqzJPdiXOpaRa31tKGmSVbPl1TbPfPp3QncMJK3/UuULy8TFLbrY4i0drqvyUFzhk6S9LlpAcXz2mA55oUIOo1fMKT6aPdYtZoJUWc9DsBPWIKQfpMgJZu92cvGl02CQ2pBxu5p+SQvuFBeqsu3fdazkSJ3DSl6UKcx75/6BoxowlTcfz0Aq6Uku2P0IDIH8ZPMuviqtdWOilK7oWk5LYq4HgSCoYZSL/c+/SmqmiZ2oJfVi0dMgHKk5JzLsKl30f41aPbTZL+vPydCZSi+IEu6qYhO07mTxRwf+p0yqlZorYm6f5CH6RQP/k65WUvzawkCOrGpZ+7/WC87Bvdb4i8SxZeER2yNNtXtU/KSot3QrP4EvtHI7VdCxMBv+BZjuChD+exWq98VbWSObazsPI9nXMbD0tO2vGARRrlBCHaPc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 4:01=E2=80=AFPM Jason Gunthorpe <jgg@ziepe.ca> wrot=
e:
>
> On Thu, Oct 22, 2026 at 11:51:40PM +0200, Luigi Rizzo wrote:
> > On Thu, Oct 22, 2026 at 10:12=E2=80=AFPM Jason Gunthorpe <jgg@ziepe.ca>=
 wrote:
...
> > > Can someone explain what outside netdev would use this? And why you
> > > couldn't do this in the netdev page pool?
> >
> > I can try.
> >
> > Regarding users, the next target is disks (not included in this series)
>
> Disks don't use a memory pool, they do IO to folios allocated by the
> page cache.

I know. As I said I have a separate patch to cover those IO buffers

 block/bio.c                  |  21 +++++
 block/blk-mq-dma.c           |   4 +-
 drivers/iommu/dma-pmd-node.c |   3 +-
 drivers/iommu/dma-pmd-pool.c |  14 ++-
 drivers/iommu/dma-pmd-priv.h |   7 +-
 drivers/iommu/dma-pmd-user.c | 390
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----=
---
 include/linux/dma-pmd.h      |  53 +++++++++++
 mm/filemap.c                 |  27 +++++-
 mm/page-writeback.c          |  13 +++
 mm/readahead.c               |   9 +-


Disk I/O is still potentially affected by the same problems
(cost if io mapping/unmapping, iotlb thrashing, bounce buffers
in confidential computing...)

>
> The only other candiates I know of besides page pool would be the
> existing dma pool users. I don't think they are so performance
> sensitive as netdev.
>
> IOW I think this entire series is only useful to netdev.

Well, the series provide mechanisms to address disk I/O as well.


>
> > > It is not a common workload to have the DMA allocator be the one that
> > > allocates the memory. Usually we are DMA'ing from memory that was
> > > allocated someplace else.
> >
> > Aside from the fact that dma_alloc_attr()/dma_alloc_coherent()
> > does memory allocation + iova allocation/mapping,
> > this is not what happens here.
> > Maybe the confusion comes from one function name
> > (dma_map_alloc_pages()), but it doesn't map any thing.
>
> > My code (in this version, and more in the upcoming release)
> > mainly implements a specialized memory allocator with an
> > API equivalent to alloc_pages() and variants, but ensures that
> > the order-N blocks come from contiguous 2MB blocks reserved on the fly.
> >
> > The physical addresses of these blocks are recognized by the
> > "dma allocator" (I suppose you meant the entity that allocates the IOVA=
 range)
> > so that it can apply specialized IOMMU mappings backed by 2MB IOMMU lea=
ves.
>
> Why? This seems completely divergent from how anything else works in
> DMA mapping, and I don't see a reason for it to be anything like
> this. Other than it makes page pool work a bit easier
>
> Frankly this looks like you had AI to transpose a bunch netdev page
> pool into iommu.

(yes, AI assisted, heavily human-guided).
Frankly, it's very orthogonal to pagepool, given that it uses pagepool
for what it does well, and it provides functionality that pagepool
does not have.

Anyways, reading your next comments, are you suggesting that all
these functionalities should be implemented as pagepool extensions?
(2MB mappings and iommu backing, proper allocator of fragments out of large=
r
pages, device-less pagepools, multi-domain mappings, pagepool
as memory provider for skb heads, pagepool as memory provider for descripto=
r
rings ?)

cheers
luigi

