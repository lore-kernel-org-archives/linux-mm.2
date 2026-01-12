Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD9FBC9EC8D
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 13:44:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 033686B0088; Mon, 12 Jan 2026 08:44:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F23656B0089; Mon, 12 Jan 2026 08:43:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDE326B008A; Mon, 12 Jan 2026 08:43:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CBDA96B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 08:43:59 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2CE6B1A0205
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:43:59 +0000 (UTC)
X-FDA: 84323430198.13.1832F0B
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3A0F480014
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 13:43:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KST9WPWr;
	spf=pass (imf30.hostedemail.com: domain of smostafa@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768225437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4n5VXKt5uZhwz/osECQnV+32AgtobC/ivtXXVJXaVoI=;
	b=IRIVMDxc1+p6sGIBFl9CU8mCBOYdLvaREGdERUFH16YECQThqzUrNTaNDy1QaDRmbRLY9c
	7tKZgc9CArNGRp1Y1izx+Ksr1RHQ859nb1NhVNY9Ol1bRY5sA4iAVgkaRewfnbZSIU7Op5
	bgdP8sliN6z9cKZ9GD/wkp1ib3n85OU=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KST9WPWr;
	spf=pass (imf30.hostedemail.com: domain of smostafa@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768225437; a=rsa-sha256;
	cv=pass;
	b=fWZ2Mzg9IGY1tQssuOIJrEo8VwijhJ+mkR7Vkqpvuh38emrxUzh+wkBtB36AB2BQuRPauI
	YeSL5irbOMljo6OGuy8DyMZ37yQdCEVBMzAC5ItTAcmSkbrPtbPf3OrXUxCtWJ23Mxzya2
	Nj80v4IpkjRaZ79fkrmXEPhseh279cM=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-64b72793544so9804a12.1
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 05:43:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768225435; cv=none;
        d=google.com; s=arc-20240605;
        b=ChMcqeAnACr6+B2VbyN1PJNW+XBF+QDRuLT7YIphCyBdMw5LthA/7XpjdZ1AYIYAFX
         nmLle/7ycML3e9Gh/6L206mUOnBCpBQgJgFk9zLBZQcqMgc75tOWi0lmCc4+zCoCTFQW
         vmxUV0XVvFii/YswF5oXPJrXBiccB8A0n5/WgaJ1vjX2yihRlZya6kbqWnpPK1VmgbKE
         El5RYoqd5VdqgFQ0XUHFsiJKJsXTtJ+HG2F6/zHasyIsOkh8u5vXyotlVilCBqHqiw7V
         ZQLIwF/ET1/lWVifeW893OCKBz0Z7QZyL92/aC6AUIwIT66gFHqyjSGb5DDDtiMO1nWK
         pmlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4n5VXKt5uZhwz/osECQnV+32AgtobC/ivtXXVJXaVoI=;
        fh=gmy3vim+lyLQAZHW0CtXh7r3TBmX5Emig2GMVX6Hyb8=;
        b=fb/R/toRftlMyRle5n3KTx30YRweIZVNdYHbNWgoOJiU0a+IrD/im0qhjTo+HrCXX6
         1fMp3l1CnNTgD0KVHVEv52kdy/gbZKCTdNY0gKAHgfADMquhrVU+o9XDzWIYkq12poyF
         swjAC55PPr8iwQ/Ozinh+m8S8g1uvZvqMbfv7SU0Qu6Hj66zmjqZBWsscCHmG9Ux9p6d
         4fOMJlwovXbU5/6wKpU1Hj1ijc/ayR/thAH8Fu0IguRDFraLgSro/gX2AmRwGwh+fOxy
         HX91qZmQuDjrlgqNx+dHVlB1M51SYyd1E29B9xUUi4cFKusyefWs65OlHcAn+vucIZcz
         BUVw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768225435; x=1768830235; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4n5VXKt5uZhwz/osECQnV+32AgtobC/ivtXXVJXaVoI=;
        b=KST9WPWrJQbVOpuxVLXOx5CoBDyMw5GE92RBv3qgtwfppOIcbYtMIQb+UKrHbgiw4F
         WePAkCKVN0Mia1w/pIRO7nuLMx8Qn41kbvDWHuPJMNQMrbcqniCHtliQYAZ4PlwTLX9+
         ulwlTLLNXnSTsvD0S2Q8QCyTlKP2FOf6NuE0z7LwfWChTGX2CWI4YChr1bHf4e+AbNmz
         2RENPIrvZ0O3DoouN2aTFTxtpnqRmt3yD0oBZTTzfDzL6I8lru3zYgmTCNqRKmT/nZBU
         HAihTd49WjXlxH9kah41haS3OZr3NdlVUeAWWl8awlOxmyk3XhtoehmvGz0SEazujN7x
         rcVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768225435; x=1768830235;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4n5VXKt5uZhwz/osECQnV+32AgtobC/ivtXXVJXaVoI=;
        b=Ewc3bxnF9IyVVo2RhMni3a4BxEFUKL1D+xtm2xqAjr1lJ2z7c4de/jQ9mYJKS+PaE2
         VZ+VsxihjQ9UcHro+myy6X/TI4sojbDpgh9ITBeZ9qbGhqY5EUtjVgKGj1tNP8XbPS4z
         6h1wHNEJC5fuv6UHHHtvA0LeVZEy0Jke/Se3KLOcVM1aEK5hHTiFqFECVh6VDJeejhMR
         +QSHVHZnYPDlXpLsvcRlN5WsCoAbQMcvHMErho62/9MfzXf3MzgcFjVeuRqtQSRn5thr
         i7qaz9VbRtzCPYClo/EQ7U3girEvuxQhE94V1M1FErgPRXD+nZCUP7gDZTd19hLt8p4r
         ETBA==
X-Gm-Message-State: AOJu0YxdQtG6JYUOJ1MxN96dvs0h6u5NZBq7jSVT2BjBdi1hxl9u41KM
	atjxTvdWvLSopn47zAbrZ7/YhwREgabXuopd7rl3HmQ5zzf2NldvHcMfQAuSj47J4yydF8PXcj7
	Kw3XuVWg2axAMXgQRbN40EDHVe5whH6EOhTZYcGG5
X-Gm-Gg: AY/fxX5rA+gK5w41P/uqZ1onsC9RdtQyDBh/luhi4R9wCLoO/0ReLivXUpeUSa+rcI6
	VpPGXJz30a9sNPqS2sAXvbLRR7ebTrtxiRBM5D+OthxLYBJ383ze4R3sdzRzRoc3qIQksuXOxaT
	YMHdaVqldxNRBbx270YfvSiVriQuZFsOTLnlozx8d/kVEpmF+h3UFqri3H6iR3U5HKQ+a2dpDlP
	iwYkfzF+kfaFfRQwfdfF9GNwhKvz4qeGvIa7dRuee0ha/1JObcfavxD6hm32Jpy1PXpwnlvNmYA
	gZALqBIDa6AKKtTRoEkbXTtj1A==
X-Received: by 2002:a05:6402:342:b0:645:21c1:97e1 with SMTP id
 4fb4d7f45d1cf-650dfe8ada6mr56290a12.18.1768225435357; Mon, 12 Jan 2026
 05:43:55 -0800 (PST)
MIME-Version: 1.0
References: <20260109171805.901995-1-smostafa@google.com> <20260109171805.901995-4-smostafa@google.com>
 <20260109195111.GQ545276@ziepe.ca> <CAFgf54r_au6isA10Nrve=MHL455X=tKhNsSwH1ej-TX08J3xLA@mail.gmail.com>
 <20260112133256.GB745888@ziepe.ca>
In-Reply-To: <20260112133256.GB745888@ziepe.ca>
From: Mostafa Saleh <smostafa@google.com>
Date: Mon, 12 Jan 2026 13:43:41 +0000
X-Gm-Features: AZwV_Qg7mYkIwH8ZCCMUvPyADXUnpvnCnTrzZaJFMI4DtUTEE1VoDRcqZ-qy__w
Message-ID: <CAFgf54psxPrsvujStPNtrzxiKOsJF+aVrN7BcNxxmAF4wDmRXA@mail.gmail.com>
Subject: Re: [PATCH v6 3/4] iommu: debug-pagealloc: Track IOMMU pages
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org, will@kernel.org, 
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz, 
	surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com, 
	baolu.lu@linux.intel.com, rdunlap@infradead.org, 
	Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3A0F480014
X-Stat-Signature: 3pkfcp8p6rbshisjoh5jkyhjzes7qsjj
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768225436-666430
X-HE-Meta: U2FsdGVkX1/PSY6kA3bcjbgum4I0pzGBxFmOllsgTmkWyc3k6pgkQA8JFEx0Vc9XLOAmDOGP11P0RWLorGgpukgc0XwwQY+Ouyua69F3ZdHGm1XgQvBnSeZl5SR9kfgRLtYs6hR+tdbLNmmom/4Ex0aGMP4l8qi552BVvS1wWREb+IHnMtYMU8Y6pCpuheJzmnhMm8DjZvO/LrfJJbPoIc/BeVLG2QdTplc/f1HQZzrpm46JYD6kUIfSzrpx1sFESpRISA8ET+QygrRsaDsz0fDwmrMInQvhov0onHS3IiAtHUy4yME3RE3AO4iPKSorkEnyS6M2Fp8/5kU/KrSR0Lb73yaat+ISpEn2VcQWyjY56xtckqYsnrGzCfln02jPD2mlS8pMV5R0ACD2K7XeQxxwfOcfogFr/fJESVBddc6qDPym0BlPSdtlWrgeWP1MiitTGyFgtn9P6uvY4dEDQ8HGtwB/Yg0Aqft2C1Bztif1KvgdfjWzqgecDI57aM4gpgP8cvTtdYztOWkAlm/fNqJrnHTf27FMKL9TCNZI8xrt46fy2QDv8gs9SaEd3J1ECVz/ROEO0c6b8maJnvdt5QNq2IR16E9ETIUFCatVN9S/XJufxp5e9VGFHCGJ6WA54Q+YLlNDsliIKWh7WvKUugqs0YXGFEEAd1nMBCoDaehQK/RYh18ifpD2kGETDiiP49BJ6ZoZ9xnZAO1znDP2kGpDXOCZVOtLego8F0MLrkqlEcRwV3fZuuw+OfyxBN93ANI8DSDKQltKKrFEiduKxVsraCZbaZhVRck5Z7W9R9SUPdhtElPRg+s+tNPpDr/pjHTRCl+9qok1GxeG53uKwIlY+EdlksytMKa57NAcIVmWxdb8kgWeNRdcH+om6vHiL5fVTSlXnch31V/1GSTgv4scZNyCpOnFySIQfAgTlPhA2L7aKtj8pSpRJrX2Ry16yuexGSCydE5Okbf6BHW
 m27TVBVH
 N7FsPNldI0Zl4SkMNXvzFnps1/KbfW6jbZApc1LvlSQ/6icnkzEAvYkYzPtVIp27QNfYhWs05C53+/UAg76PTcazotI5TNjuKLk4emEKoP7QoeSad7kc3yRZZ9qrYYzjuY11U8eLCb0X7Um/aRmCgcR3M3LZwkEogJEY6Ml27Nyv6eazVv/G/1htNXOx01EN42KR2UnT8fNpGsykJrNixbvq1qSv0eKuhnrf94fGCJ1wvkBdCOF7ZcxkKj78P03FfMbB1f8WhGXBY+M96oMbnRJkXvsHV4g/5Ubl9F0ceypCdMkuwzqvRhNsHiBPXClW1KnNrzTmzhSsI6mWHr/wrAdspiLL+RpnqOCq+EnsZ0VRCISOZHMDL5gj+IlwJ2xOj0Xbp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 1:32=E2=80=AFPM Jason Gunthorpe <jgg@ziepe.ca> wrot=
e:
>
> On Mon, Jan 12, 2026 at 10:20:14AM +0000, Mostafa Saleh wrote:
> > On Fri, Jan 9, 2026 at 7:51=E2=80=AFPM Jason Gunthorpe <jgg@ziepe.ca> w=
rote:
> > >
> > > On Fri, Jan 09, 2026 at 05:18:04PM +0000, Mostafa Saleh wrote:
> > > > +static struct page_ext *get_iommu_page_ext(phys_addr_t phys)
> > > > +{
> > > > +     struct page *page =3D phys_to_page(phys);
> > > > +     struct page_ext *page_ext =3D page_ext_get(page);
> > > > +
> > > > +     return page_ext;
> > > > +}
> > > > +
> > > > +static struct iommu_debug_metadata *get_iommu_data(struct page_ext=
 *page_ext)
> > > > +{
> > > > +     return page_ext_data(page_ext, &page_iommu_debug_ops);
> > > > +}
> > > > +
> > > > +static void iommu_debug_inc_page(phys_addr_t phys)
> > > > +{
> > > > +     struct page_ext *page_ext =3D get_iommu_page_ext(phys);
> > > > +     struct iommu_debug_metadata *d =3D get_iommu_data(page_ext);
> > >
> > > You cannot do this - phys_to_page() can only be called if we already
> > > know that phys is a struct page backed item and by the time you get
> > > here that information is lost.
> > >
> > > Probably the only way to resolve this is to somehow pass in an iommu
> > > prot flag that can tell the difference between struct page and
> > > non-struct page addresses.
> > >
> > > But I have to NAK this approach of blindly calling phys_to_page().
> >
> > The callers to this, first will check "pfn_valid", which is the right
> > check AFAICT (looking at similar patterns in page_owner for example).
>
> I'm not sure pfn_valid really works in all cases, it has a number of
> exclusions that can be relevant when phys_addr_t can be a MMIO
> address..
>
> So far we haven't been using it in the DMA paths at all, I'm not so
> keen to see that start..
>

But I don=E2=80=99t see why not. from the documentation:
/**
 * pfn_valid - check if there is a valid memory map entry for a PFN
 * @pfn: the page frame number to check
 *
 * Check if there is a valid memory map entry aka struct page for the @pfn.
 * Note, that availability of the memory map entry does not imply that
 * there is actual usable memory at that @pfn. The struct page may
 * represent a hole or an unusable page frame.
=E2=80=A6

That means that struct page exists, which is all what we need here.

I can see many places have the same pattern in the kernel already, for exam=
ple:
- vfio_iommu_type1.c, is_invalid_reserved_pfn() which does the same
check which can include MMIO and then get the page struct.
- kvm_main.c: in __kvm_vcpu_map(), it distinguishes MMIO from memory
and then accesses the page struct.

Thanks,
Mostafa

> Jason

