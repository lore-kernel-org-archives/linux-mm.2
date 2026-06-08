Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FE4DCD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 15:45:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7E3A6B0005; Mon,  8 Jun 2026 11:45:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A55BD6B008A; Mon,  8 Jun 2026 11:45:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96B736B0098; Mon,  8 Jun 2026 11:45:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 870D66B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:45:24 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 433891201B1
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:45:24 +0000 (UTC)
X-FDA: 84857169768.09.BBFA7B4
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf11.hostedemail.com (Postfix) with ESMTP id 484A640009
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:45:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=RqmaE6mp;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780933522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b1AEJD1gijFxE19tzaU+lK+SRdJdZGcBz2s9WNZ86i0=;
	b=VI4lfKg8z6eE/k+oaSM4VIhUTyoJi4QnedkjA7UnMD49123LxuysEkXgJEFlrADy8I41V5
	bCMXMHfVUP/xcrF37sZeNMN/5HXVKAmOlTD48t0FdtgDENahm2Qe8vAJ0TMwvY80YFXPPr
	jiwa4c3j+R3NJYOzrSjWR+F/8OQBj8Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=RqmaE6mp;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780933522;
	b=kSO9DzQF9TRLG7yadBnPm4zGV6urXKDWA1eGXIBP5a72rYKA6cUDO02+ztSyuY//GOcPyE
	suTXbBctaFfUCr7Ok43SmBALe06BVAH+gc0Z3RtsUNvvf1LmyzNSbRDCRn62dQ1s3CFBI4
	RCSmMPoomGIML8mtpOWm4Shsk09Rl8o=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-915c36e32abso150898985a.2
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 08:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780933521; x=1781538321; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b1AEJD1gijFxE19tzaU+lK+SRdJdZGcBz2s9WNZ86i0=;
        b=RqmaE6mpziM/O3/Sbr/qThPIrXUw0lK/PFsaXOBd0nyMulj75uKpj+kWhc7pqQpP+H
         h7eh0Hart2+xcVHQGWCSsyJYA4M/z/hjltRcj9nwiDJqDGk/CIcrVuclZio6LaFrCRKN
         eeqFrBBnFIDXmso19hoTKrRiqgTOohOYvVpyuQvKyJ5Q5TM63a7aC9nDnAHno1VlW7+1
         E0ra9QV78h7+RLld3zRnN1k9SeO37naQ20tT/vNA99i2ehA5VCivTKjepIzELY5wkk79
         kq5JkkN+KsjQ8sYIjIFbrMfXCwD5pKyUoQRVwdxgnNXuBbnozAVfx/Cgnt68dfMW+sAh
         LyrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780933521; x=1781538321;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b1AEJD1gijFxE19tzaU+lK+SRdJdZGcBz2s9WNZ86i0=;
        b=SEHS6jG7O+Asj2uGphJg+ezCB0Y7bZN8N8JosoDNlyTtL94weB8sZ3imrrWat9cVGK
         S9BTjHM9JuLYiE8LTGfdAzSPaVHIipKLiOkT6jD6awUYfOvVOsp5wF/QRa6OGp20lk8L
         A7hkXqjbSrJLxERV6R7ifrbyhd45DLLH+d8a9LEBJMmOmQUaDdKQISU52pye61N0Rnfx
         cNHxIUKVq4qvkZYmlOtA29yn8Di1KRrJZJrp+EFYxOWh2zSNQQtqJ5lj4Cye007ksNXc
         mkFUd+U/5SG1m8lJxuBiUy+VPut5drYJbMn83istf76xTMUiolNAhnVw0es/y7AwoZSI
         d5BQ==
X-Forwarded-Encrypted: i=1; AFNElJ8Gjwu9964IIJhWRAp9azQdil3HWjIRYUD639ebhW7J09ZPpju3fg4xP5VveX4f9++VclKN1o3Wew==@kvack.org
X-Gm-Message-State: AOJu0YyxLigsnbtIIv+Fh+/xTjFOwYHFg/6cBE+nU4OZNzAyxLjwGHhv
	iaVCHNpr/0LCkhx5BCbnyRA230jnDxXA6OCWMT+bgbK9JWDQBYD1ydagsHjIfC96qmw=
X-Gm-Gg: Acq92OGibvevJ74sCMzt5fcixmr55PGQv6xQUPFRtLZQfIyWP0MKZLzucDsuQCq26qJ
	rno9qIUvW+ZETVYY9Z15oUtR1TiHK8qaZmrni8Pfm6ILYLXqm/TBSrDi0TpVnym566SmDOYx90C
	KYdt53Ui+/JJgGTOwUsr+m8SrE9zkUzJiOcfvAeUsfGLC4056CR7JWBwmxPrSHOpAXnSk9sdhAe
	AAgjo/lRZB4x+BvAEaJIwbIyHkkGK3lvw6n4uI0rMbmIxGlj2GBX9D5YxwU1M7M2NuI2+OgDpN3
	rGRwBza1lnJg18S6VaEXZuvcF2nb1IK9cUzoi6l+5KPDF+cMaVCaJa/Rquv+iuG4Je2VUd2k7U0
	RcZXp/fpc3FKsad+c/AdqKLqs2ekekUYJMAHxjiFt7so4NIc3xotKxmZhIeMViuCfKIIfUxMj+V
	mUAPNPN9z+ahpXZBxc3394kgbi/DKw0zX8r6jGz2hS3Qh6BKoxk56S/xulH7L3Mwrpl3+6D+MAv
	ztQHA92BhzvkPX9Fg==
X-Received: by 2002:a05:620a:1d02:b0:8ee:bae8:2bb8 with SMTP id af79cd13be357-915a9d5784cmr2593487085a.36.1780933521234;
        Mon, 08 Jun 2026 08:45:21 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a21f871sm1787135885a.12.2026.06.08.08.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 08:45:20 -0700 (PDT)
Date: Mon, 8 Jun 2026 11:45:18 -0400
From: Gregory Price <gourry@gourry.net>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 00/37] mm/virtio: skip redundant zeroing of
 host-zeroed pages
Message-ID: <aibjjsoeEcvXobCw@gourry-fedora-PF4VCD3F>
References: <cover.1780906288.git.mst@redhat.com>
 <8d5d2fa3-a60c-4d04-b3bf-7a8fe89cb1a0@kernel.org>
 <e54f9b79-b6b4-4911-86ac-48b61889765a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e54f9b79-b6b4-4911-86ac-48b61889765a@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 484A640009
X-Stat-Signature: 4drqs8xy1hdxygjyi3eg9yd4964ubiu6
X-Rspam-User: 
X-HE-Tag: 1780933522-885902
X-HE-Meta: U2FsdGVkX1+w3cUNkrQABrxXf+4ektu6itXadhzzUm3U9Fz4xM8Dirkrj07T0YIu/B8uIo8HGWQEETWZtmFr/RsUzCl588oayTj5nnkw5a4Iwe+SLa0Pr2BBW1EY5gi48osPqEoeTujzru+49PUL3X1Z4ke+evjpQtztoPWu/GmjHxaKoG6qpzs4H2oi36Q8OeiZEkZoQJYafm6eO4ZtJY0BcsqDWm7KabFXbaSExj96Dhy4V4MLTjHIsIamrrFR3SNOblQbAJ4sjmZQMmxraCiOSLEQHjPP4wtb/3CjNjfVV1zbWqkyhzuQqa/bBjCKVq5a9o27LntsyP5PeRaMCRXyNNzuTjOm60rJOVi7v3D72paED8VM3oCjDBlGq9DenF9ju8b8/9UHVqT79LO9cz0I0/tIIhUpK8wg9cJWsDyad96fVqheqrsHbgIVTyIl7K3iqMGGfWFH8eIEq9lto8A4zFfY1wkBmkMbxxlwcTFyB9kNyZ9Cdzp28OCGXLYjSPJ69U9vT3rF1IWymHjuQT2aW4HzpWhTEG9cFU8mz2tQnTKRxpJD/h0HoL77FCQidpziuOsLmd0IFVwSCeCEJ0vAyBBvzmocU6mm4q3oLwTd8cDfmHsvgPy8+RCQhenHFOvm1WDbTyPaosx+PVJVPCDasR/LSmYogxZrVzp0a0hNiczhQrVRLsSGxmikPPNpeIHPH6KFa6LTQiRwV3vYWx54x7hHqxWOa+DzhqO6iq4ysFhGUKozRSHW2NvAWAkqsGI5dTsGnW9hO6BBo6+0jfCbfxKg/0y2E/egLyf2B82y2CwyZxp1J5IuDwexymHe/wtu5vho45m1op0PSdoJumoXKIyhPLlwE3k+hCyvA7HISpM+xj/fACoBZ69lqElljYQlZTvodqCeYmqSxpr0253IpdbUkRFSxNkoKguc2DIbLvQVk2lX5ElSc7h01SYpDCyDNRg8N3aXjBig9gL
 L7jD7s9A
 zcpuIV5dPZfoQ/u/upcvCr2vuO14Vtp11jj/e4VQbBum9XM8Ya9CnZbbGhYo+y5HbsqaMfOGbJXmDE4mIIXUiENxL61UyMO6tm8PyVypStcv5g3/89mh7gIPfE4V/N8TruV+s8aCgYVlFlxp2utlebbL6iZGmH0ynXn1fRkbMgd+Ckitc3ijumgcmb5Fz9+6vORLppmZsRXqhknI96GZ4xyf4kTomIF48Bu+HWZwh7kwOEfjuTUhKvl8VqshAxw/FX5xP/SgATAwOiP5iS2GDKeNPO0v1wEhHTmU0MIXp/eBSZdIdx8yGu4/p3DnBtlUAAcI8x45Xn+Cy81RDl1d42ADpfUgMcrbRCBiELPbnNeNm01vWK11kEszl7f5ktAAnf+3Vphx0TIdjvCBBJW/q4Umnog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 01:13:42PM +0200, Vlastimil Babka (SUSE) wrote:
> On 6/8/26 13:02, Vlastimil Babka (SUSE) wrote:
> > On 6/8/26 10:33, Michael S. Tsirkin wrote:
> >> Further, on architectures with aliasing caches, upstream with init_on_alloc
> > 
> > It seems those are niche architectures so we can ignore that part for perf
> > purposes; the other reason why user_alloc_needs_zeroing() would be true is
> > booting with init_on_alloc.
> 
> OK I misread how user_alloc_needs_zeroing() works wrt init_on_alloc, as it's
> negated. But you're changing that anyway to skip that user zeroing, right?
> 
> "
> This series eliminates that double-zeroing by moving the zeroing
> into the post_alloc_hook + propagating the "host
> already zeroed this page" information through the buddy allocator.
> "
> 
> So relying on "everything in buddy is zeroed" would still work I'd think.
> 

This regresses for anything that previously didn't zero on free or
alloc, which is most kernel allocations.

I think the scope of this set has increased too much based on early
feedback to fix the userland-initiated allocations piece along with the
balloon/reporting/double-zero piece.  That's making all of this
difficult to continue following.

~Gregory

