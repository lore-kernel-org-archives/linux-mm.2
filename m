Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0F24CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:53:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 074BD8E0078; Fri, 17 Oct 2025 05:53:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04D138E0016; Fri, 17 Oct 2025 05:53:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECBC28E0078; Fri, 17 Oct 2025 05:53:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DAC0A8E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:53:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 97E6F1A05C0
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:53:46 +0000 (UTC)
X-FDA: 84007144452.08.2AF75E7
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf16.hostedemail.com (Postfix) with ESMTP id A4619180007
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:53:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kBDu4FYb;
	spf=pass (imf16.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760694824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EepmnhOf2b8cv48i7uBzvZdSo/kJi3CKbYL63TM2s2s=;
	b=2orI5lBlZpOsaqAkyrUNLhtim4ssoPNsN234HExB6pzd8nPdZzI0YjdruU7lF9h2fLo9I4
	SvXvM6TAjoYQ+RU5iDF5R23lTRSD3Vm4swgCm0QSzdcCOOVxvSNpDramecIHvzC4ReY77W
	uXl5KbR4SyPFR64ftO3gEUXcM8GfOe0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kBDu4FYb;
	spf=pass (imf16.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760694824; a=rsa-sha256;
	cv=none;
	b=O9CXo6MsgkpnTmpgfObDML6vhy1VIrWLF/JOS0i4a9T1MOmFe0vtfqvfEsNu2J3qzc+vNd
	uPSdcA8d4RJBCXdZ0yOLlCP0ZGvvjawdIovf2cbssLO15C/zmAfmEX4XvbDbk8FNR69gfL
	Z0CSlJNm+HTa92SGbGvIRF+c7mJWJ/c=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b3d50882cc2so325737866b.2
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 02:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760694823; x=1761299623; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EepmnhOf2b8cv48i7uBzvZdSo/kJi3CKbYL63TM2s2s=;
        b=kBDu4FYbb9RGO4z67t5enjy56Ls9D38aqlNa2uhDIe02/6AyZ4bzRa+S8yzVHHV4F7
         senn/WHDK4E9je9KiS9Kgjqwk2wI1w2X11y2jCsH5dU6pykd/5ZANnswsqi87Tjl/7CM
         Fii7BozXG6mBTdec7F6ICrinB967VIucRLuAJ3p4r1uvSc1CQ6yFJfDwq97MVPNEgadM
         9V4CNAfrqkzg7A4+gZJR1+CPa3cKGpJFpjSzMLP2bG2jRxPSn6PWelP7rjgsQmGkxpH0
         wYzPexvl/l0oCh46sUhnTaBg6w063ztKechcmQF6x/w8ZwOfKCIgYVvrboJiUK2iuBVa
         unDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760694823; x=1761299623;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EepmnhOf2b8cv48i7uBzvZdSo/kJi3CKbYL63TM2s2s=;
        b=FvFmGivauLkv2uSxg71/dcTpUVTcKIvBH10JSMqib+v0A1mF29q8srFlKMXFYzQFO0
         hIiq3hsTwmq07dZ4w+GR/C1X0ifjPVAsZp9vnBN1j5M+CSIlTK/MXdH0sI96bk0Z5NNz
         aGt2DL9z/l961s6igauYefN3oE0H3D1BBSdaeEUxGxNPm+1ZWdSPBsP+D4EkseA4bphC
         T3wvq9ckKrOjRe+qd/hgYcmqBNGHQGAh+aXN2PwRZG9nIuz9/irVy/AuOc/Gr5G2tRgT
         hBwGaa4sQ+NjPp48zyB4RSwZFLOetOfpmbnDZD+fTjVXByHnkMg7WbXoIxJ+fQkRDzvs
         GkQw==
X-Forwarded-Encrypted: i=1; AJvYcCWrda2PWHw35N5M4TnhKLPvfs7FtdqlcKCvm7QFaRDE6j+BYKA9QTV6zFNpNfFASPnp0VFq/o5XoA==@kvack.org
X-Gm-Message-State: AOJu0Yzyo/eEZjXw5/Hhw+Uer5hmFZcWfTOmB8cDn/3M5R7/KvOd1xyS
	kWDjfkq7xqWwBuDYKi8x9Pa0QWnNbwCSggB/7aeKllGmmSpu1ElcrJe3bRk5mxWqSIaw4PqE87T
	iaD880g1kUzTaUBGWjCzjNY5nH6P1s70=
X-Gm-Gg: ASbGncuzTslaeI7v4pzNA0tOYzRnJWoDfdldx7RSir78mSF86qcmoLUQguYYxnLVs6s
	pGc4M9a6DNsAmQ7q1epYo5ouNy8Onmfj7fOec9En2sPg1bYsBMc3ksrT6dJAZLa/dW7h40MTkRJ
	C147zVfiEd8gk1QkVnvl+T4dEb7P3rG7PAS2Pd4oAgpCX93mcva0PxBYO+rksPDCrZt61jGN1YV
	XoAAtsXRTVjbuPvujAoVXQ/oH3xt2RCdbPRaxFyY+jAE/M3ufE3CAxFykg+vRHZOIHuppOZrQ==
X-Google-Smtp-Source: AGHT+IGnkkXRL26RjJocOTbDHT6wQpAjD7i7LZQcNZb0xfoSFRP0gYibjbMJ3dbGukJMMqFIxLuRJqHhFH9k/kdc2Ow=
X-Received: by 2002:a17:907:25cc:b0:b38:6689:b9f5 with SMTP id
 a640c23a62f3a-b6471d45e6bmr377170466b.3.1760694822635; Fri, 17 Oct 2025
 02:53:42 -0700 (PDT)
MIME-Version: 1.0
References: <7e3e7327-9402-bb04-982e-0fb9419d1146@google.com>
 <CAAPL-u-d6taxKZuhTe=T-0i2gdoDYSSqOeSVi3JmFt_dDbU4cQ@mail.gmail.com>
 <20250917174941.000061d3@huawei.com> <5A7E0646-0324-4463-8D93-A1105C715EB3@gmail.com>
 <20250925160058.00002645@huawei.com> <aNVbC2o8WlYKjEfL@gourry-fedora-PF4VCD3F>
 <20250925162426.00007474@huawei.com> <aNVohF0sPNZSuTgI@gourry-fedora-PF4VCD3F>
 <20250925182308.00001be4@huawei.com> <aNWRuKGurAntxhxG@gourry-fedora-PF4VCD3F>
 <aNzWwz5OYLOjwjLv@gourry-fedora-PF4VCD3F>
In-Reply-To: <aNzWwz5OYLOjwjLv@gourry-fedora-PF4VCD3F>
From: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
Date: Fri, 17 Oct 2025 11:53:31 +0200
X-Gm-Features: AS18NWCQ9wXgY3ohNhZ8GKQ15VfNgQtd-CWHjxzqk37o1eOtpgk7IRUwEDn2cR4
Message-ID: <CAOi6=wTsY=EWt=yQ_7QJONsJpTM_3HKp0c42FKaJ8iJ2q8-n+w@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion infrastructure
To: Gregory Price <gourry@gourry.net>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>, Wei Xu <weixugc@google.com>, 
	David Rientjes <rientjes@google.com>, Matthew Wilcox <willy@infradead.org>, 
	Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	dave.hansen@intel.com, hannes@cmpxchg.org, mgorman@techsingularity.net, 
	mingo@redhat.com, peterz@infradead.org, raghavendra.kt@amd.com, 
	riel@surriel.com, sj@kernel.org, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	dave@stgolabs.net, nifan.cxl@gmail.com, xuezhengchu@huawei.com, 
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com, 
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com, 
	balbirs@nvidia.com, alok.rathore@samsung.com, yiannis@zptcorp.com, 
	Adam Manzanares <a.manzanares@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A4619180007
X-Stat-Signature: 1njq5rf5xd43te4cg6msr3e14fzh739m
X-Rspam-User: 
X-HE-Tag: 1760694824-676382
X-HE-Meta: U2FsdGVkX18Rx9hkfy++mw/8AH7iXQMbP8ACh8JbcSVlMqJF6mT6xQ3CHsIbQMuhVwkeVPvakharzhp0VMKkJtVz9JSaRUZ4bgWSm4gjJBHxQDqlm7j/sy2ct39SNEtaqt0sjpwuVOcrIS37cwg/YPEKBuTAz17QbEcODSoiJPoNZL7E++1BLdtFQITHdenchv1TsVdvduqadQ2Uk/K+u22R+8nsuVY8Y/gXTOMe1ktp2KS9SXrKfYR0piloXNwnByFLr/bTkyxspiycLmCjKTbY8+OPXBA9qgMjNgr9dBO1BFnNWKM2vD+sUc9sDtDUpzS89UWUNgjtUrYpOhAMP+E7keDqpl50FKfF6kdBu9Fxqnk+hnZyjP0VJOSsnZyntZ1hYNICkvA5f49NyvSyXGHjyhRYXpKaGPouNrxM6+UHr5olin5XzC2Ojxq4ysUC1wL/l3mgcnhustz/os6o62kPPF9RD7H5E4VZ/fg+eA/+aw1Y8050VLYsaq3V0WDB1x09JhZb5kw8lDBmXSU9ytLaOYZZhTJHtjhCkOrv+MDAe4l6t3bhQiCk1NhZ8E4njWjtxm2yEjrpZQIawNhCrL0FoBtOXZ0o6r/mN2E+QffR4AtQAdUYWPzM+1oVt5r/3UrLs8W10rgVspipAY1DKEK63xrgSbFkQVopPQ6uZs870HxrGX6feWhPG7bDnnqXz/xDcg8S8TcecbSpLbrIEdcPcNK28E7ltfUxh6Jf0Xvn/LGjTaKlTpxrq/4BSQ0AM8FDgH8CvDFwBwZsnEcE79Jlv4pcC7j5MGr6iO5PlBXKc9hYFitiWius5/552Qk2o1SllbheZcLIsbi50/g5LZsu5rc8k+H1ZdIImOA3RhpADJr9RA5TIPSplqVoYUbTg7wymDEWXWDNBgmBcjYxO3fTnQJGzMv2LRRU8U3Q8KPNtSs35eBYB6INdXufWaejcFqtx57I4qkU6TeICwJ
 nuw3SroS
 hlmqRJvIZcmbvqsoWaP/prsMVheqE6EXOf/tttex3KOH/GIbQ5ZA+D2MpHN4Pw0pIPalBy0wtPoLcPvrmNl8YZ+5SV5hmigQCZOgHHppe0pOkbC9t86EWZn1KdeCO0ZlS4iLKDjXTDNv5NUAb0v/GbsquDJMUNH0QBPDlVZRGOXU96E55TPohL/QkxG7ITMNrYTEnC9b9iz90Xt9u/MmL2hu7+dsruDncPSvPfjC7S/99q5mafiUuUglO1QWgxJS0TH/7SZZa+sEgKCeu/md/5MDirvGduRyzMOpdb25SPl1Hk/98WtP2nqsdknAm9Gxq9gewBXr4ymGVZQ61gE7bcdOn5eipTZgKmnXug4PLOrAx7VBriFfVG1EGs4PivKfjn4qjAjSaUaW4P9UOoPbkXPrfBbkk/cnJeUBIxFzC8rWLT4ueVIrAVJjC3yxXFsmuBlTjm7vI7Hss75PhBmWZ6bcbWXD0FJ7ntU6RNDZB8s2w9p0TkITTt0j4s8rqzDzBo71skqQ11FK9SQwBH+V312/wiIrV8h1pm+BW8Dsxys0otKA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 1, 2025 at 9:22=E2=80=AFAM Gregory Price <gourry@gourry.net> wr=
ote:
>
> On Thu, Sep 25, 2025 at 03:02:16PM -0400, Gregory Price wrote:
> > On Thu, Sep 25, 2025 at 06:23:08PM +0100, Jonathan Cameron wrote:
> > > On Thu, 25 Sep 2025 12:06:28 -0400
> > > Gregory Price <gourry@gourry.net> wrote:
> > >
> > > > It feels much more natural to put this as a zswap/zram backend.
> > > >
> > > Agreed.  I currently see two paths that are generic (ish).
> > >
> > > 1. zswap route - faulting as you describe on writes.
> >
> > aaaaaaaaaaaaaaaaaaaaaaah but therein lies the rub
> >
> > The interposition point for zswap/zram is the PTE present bit being
> > hacked off to generate access faults.
> >
>
> I went digging around a bit.
>
> Not only this, but the PTE is used to store the swap entry ID, so you
> can't just use a swap backend and keep the mapping. It's just not a
> compatible abstraction - so as a zswap-backend this is DOA.
>
> Even if you could figure out a way to re-use the abstraction and just
> take a hard-fault to fault it back in as read-only, you lose the swap
> entry on fault.  That just gets nasty trying to reconcile the
> differences between this interface and swap at that point.
>
> So here's a fun proposal.  I'm not sure of how NUMA nodes for devices
> get determined -
>
> 1. Carve out an explicit proximity domain (NUMA node) for the compressed
>    region via SRAT.
>    https://docs.kernel.org/driver-api/cxl/platform/acpi/srat.html
>
> 2. Make sure this proximity domain (NUMA node) has separate data in the
>    HMAT so it can be an explicit demotion target for higher tiers
>    https://docs.kernel.org/driver-api/cxl/platform/acpi/hmat.html
This makes sense. I've done a dirty hardcoding trick in my prototype
so that my node is always the last target. I'll have a look on how to
make this right.
>
> 3. Create a node-to-zone-allocator registration and retrieval function
>    device_folio_alloc =3D nid_to_alloc(nid)
>
> 4. Create a DAX extension that registers the above allocator interface
>
> 5. in `alloc_migration_target()` mm/migrate.c
>    Since nid is not a valid buddy-allocator target, everything here
>    will fail.  So we can simply append the following to the bottom
>
>    device_folio_alloc =3D nid_to_alloc(nid, DEVICE_FOLIO_ALLOC);
>    if (device_folio_alloc)
>        folio =3D device_folio_alloc(...)
>    return folio;
In my current prototype alloc_migration_target was working (naively).
Steps 3, 4 and 5 seem like an interesting thing to try after all this
discussion.
>
> 6. in `struct migration_target_control` add a new .no_writable value
>    - This will say the new mapping replacements should have the
>      writable bit chopped off.
>
> 7. On write-fault, extent mm/memory.c:do_numa_page to detect this
>    and simply promote the page to allow writes.  Write faults will
>    be expensive, but you'll have pretty strong guarantees around
>    not unexpectedly running out of space.
>
>    You can then loosen the .no_writable restriction with settings if
>    you have high confidence that your system will outrun your ability
>    to promote/evict/whatever if device memory becomes hot.
That looks modular enough that will allow me to test both writable and
no_writable and being able to compare.
>
> The only thing I don't know off hand is how shared pages will work in
> this setup.  For VMAs with a mapping that exist at demotion time, this
> all works wonderfully - less so if the mapping doesn't exist or a new
> VMA is created after a demotion has occurred.
I'll keep that in mind.
>
> I don't know what will happen there.
>
> I think this would also sate the desire for a "separate CXL allocator"
> for integration into other paths as well.
>
> ~Gregory
Thanks a lot for all the discussion and the input. I can move my
prototype towards this direction and will get back with what I 've
learned and an RFC if it makes sense. Please keep me in the loop in
any related discussions.

Best,
/Yiannis

