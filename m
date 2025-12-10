Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22742D3E77D
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 20:43:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35C3E6B0006; Wed, 10 Dec 2025 15:43:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30D546B0007; Wed, 10 Dec 2025 15:43:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FC0F6B0008; Wed, 10 Dec 2025 15:43:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0F2896B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 15:43:51 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7934913B97A
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 20:43:50 +0000 (UTC)
X-FDA: 84204737820.18.0C33F14
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 42130A0017
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 20:43:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="N3XkWwD/";
	spf=pass (imf25.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765399428; a=rsa-sha256;
	cv=none;
	b=rqfFKgcclNZSVxMfvt6fvIUhjZWmnLdysw+Gan8Ytw9sLzRjzUWXluPY8Vaxt4rMGFntcm
	vimh2iPdbDC446TmFOxa2ZDrTIIWS/z6wDVapWlyzrx1K3U+dVXuyh97WQK4SXnZAzTwHv
	r9puCMXUQszfqx6XEkKMYy0ZdmzhWbE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="N3XkWwD/";
	spf=pass (imf25.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765399428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MdaxxiCV8H2eHhp9NcagGoogiR+1MMFcEmWlgLwt4lY=;
	b=TCVvjBstXvqOpp1nTdBQ3XtM0sNyfI033Ne7wtAzUCc96VBB3nm+fuKw3ujnbhzkC/foPE
	v2GM4owIvgXSD+5HFCUJh9d3mKr9usUth87s5Yp3B95Ii/PIoQ5iXzoTqfPFJNSXaEMmit
	46YRHJtO6pHMiQ9IblMTiXHRoROCfFY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765399427;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MdaxxiCV8H2eHhp9NcagGoogiR+1MMFcEmWlgLwt4lY=;
	b=N3XkWwD/Pkoj8biU6T9xsdaqfnunO+SKCPh9dsc1XZn3zv7Zr1dPtTA0hpGVu6a04eq0f6
	T5gFKuGFPCBiHZJVWafMSHhyteQauuDELhQytomBTD5/yOmNAwAtqVPO3IaFv7uk8BLtIG
	ws42VTymAhxnxN6/TOllk7PNvtzr8i4=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-4K5Dn9AyNiWaxXnZwXr1TA-1; Wed, 10 Dec 2025 15:43:46 -0500
X-MC-Unique: 4K5Dn9AyNiWaxXnZwXr1TA-1
X-Mimecast-MFC-AGG-ID: 4K5Dn9AyNiWaxXnZwXr1TA_1765399426
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-8804823b757so29357546d6.0
        for <linux-mm@kvack.org>; Wed, 10 Dec 2025 12:43:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765399426; x=1766004226;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MdaxxiCV8H2eHhp9NcagGoogiR+1MMFcEmWlgLwt4lY=;
        b=l7JgaJOaFIKsRIWUI/n/Jgr9qzp7Oah4FbN9CzUOCvr2XvbBuimh70v+fqHqLcmMXc
         sbnI1ttNypo2vEOz5UajI9wqgV95NovWxvMUaltd17g7FRRZH581rLu36KqIedQuEOTR
         Ce3UdIF5VnPfkJ3kFN71Nh+bXeU7O8P1vSaDu1FuAZ5r7lgSasf6glH+1yHsc5+rTsUI
         hvsD3qJDMxmoV98O3IR+YQSPHaaliq5qhQ7bEQbzheZhlw2SSHxQo3YcpZqRzLpjBiHN
         vMbrdXu614rwPw5+lCMSnSm9hZWURxd8geRjPY2lnR34LE3o2TbD6hxVVSlMV7GxS3gn
         Gz3w==
X-Forwarded-Encrypted: i=1; AJvYcCVUNEozwh4xy57/q4C4Ez5h2HxnPvUgVnt9E9BsqTjMZDn26JMEJmblKCWs1UltNctM+hYbDHJdUA==@kvack.org
X-Gm-Message-State: AOJu0YxjEKnOwRiqm10mVXMGP4ZW4xNhaYTLeAq/rml/IRMYQCMRzVqI
	DW9r9lc829ZlW1zSNkKE/n/th7DgVrWIx/XrL26+B0W3WPCNCRF9GdnFyEvRrhzPsIDI4lzlrXy
	AACg8Ei6b07Bym1suJxd0HYJIEN7KC9t6kh0TwS6YjA2Gr7pbOeKZ
X-Gm-Gg: AY/fxX7vPOwPqAI+EFvl4PsJ3oBIDgnTPK66Kroqd9zmfbehY6Rvhz/VL8aa6fSlCe9
	mKyoks6N6h75sZdwP6u/+vNryzShntb56coXfXSX7balDxg1sDDAIOfJgsF2W4ELu8GLuhvhi68
	a7S6oz+S91P2stDWm1Wx852zoZOBF6X61SbuOjL3h6jczGHNKRAueTr35jrLGE9KG+iG+0fK45r
	5D2ah5cXh+fHXQV95Qazap8uDPGR9PkI6NZIlea5vA3LoNVbvni4okPyq/lMNp9f2poPytXrYuf
	k6nAqdjNSw3ENXxCWSE23YZlcv8f59KLqFUOT7VwmhB2dmtEP+bRhOYOmvvO/h4OJ94xLJ4UFb7
	l4kg=
X-Received: by 2002:a05:6214:21e1:b0:880:51f0:5ba0 with SMTP id 6a1803df08f44-8886f2c85efmr12874466d6.26.1765399425706;
        Wed, 10 Dec 2025 12:43:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEMlXnfPx1nwXlxZMeogmX6e8U0uMByKwt0vnr5JltJxNMWxHqIgAvaalVCu7oIuo0OaauRzQ==
X-Received: by 2002:a05:6214:21e1:b0:880:51f0:5ba0 with SMTP id 6a1803df08f44-8886f2c85efmr12873866d6.26.1765399425121;
        Wed, 10 Dec 2025 12:43:45 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8886ef30441sm6054106d6.56.2025.12.10.12.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 12:43:44 -0800 (PST)
Date: Wed, 10 Dec 2025 15:43:43 -0500
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 4/4] vfio-pci: Best-effort huge pfnmaps with
 !MAP_FIXED mappings
Message-ID: <aTnbf_dtwOo_gaVM@x1.local>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-5-peterx@redhat.com>
 <aTWqvfYHWWMgKHPQ@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <aTWqvfYHWWMgKHPQ@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SOTdi1E05-tzvtS4JPscmnDO_0_LX4uQBAKIhbcE9JU_1765399426
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Queue-Id: 42130A0017
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: njktydgwm18wyrmnoyj8qnpkc8qzt65n
X-HE-Tag: 1765399428-80290
X-HE-Meta: U2FsdGVkX1/QXvndPk8V26dZcoRaLgIXRvHk6tJ+ZlnIy1YVGwf+RH/4CpDl35qp6BYUOZJHiD8m/XbOXB3p4Mrr4rU3jixbKLaZf+ZYQB8YDd8x3g1JqRmROOpdsZCetgqaQVV3Yyl7YAgFux70eEyqdUGvjiKQFHULTcLVAMAtwy0PVqIhrvXmzl5RzNlUQGSkRtUJNEsXRa3Sv+piF6OSATY6YdG5+heFtUC8xGDg503eNbsAJ3Vnrjdlf4vxaQCqpthuZsDnYuhrlT4EfjZDat+sevNoOdFqt5JOzAxmVHluJWvgQxcyR/uCI5I6cO/WyLPdbT1ow4kF5MeVYscZ4+Odl5dTx5pb34lK4fPK3C6ZPFG2ycLEdkyoPbM1LeeJTFqbYVVnyLbo6uGjglAqoSXRih0Xo6yvPIEcEyFJDie5lsmixf+BProwL3L37sblVTTiryx+VvBRoxfu4Q8ErsVizLsYRlO6x54MvEE8X4AEIervICOe0hoNvcpU6usro2NiKInTFQWUFFlf+PRut82Asp8cUi+oQeuQnk3MeVxaR99ZWQ+RxAcWCPmYlobPWc+rlmn1i9F1EvEtepqSUrLa0Y1PBEozy7qQPBO8Mc424oXUyS+ycvFmsGvcQA7uAAU00T3VykzmKR0FJ0NPlnoOCQPJvaJvPSGrtewiKluLFvCbYFIWCYogJu7qJcsDp5ywD/LbwVBa92YmxiVt5e0Dzlj7XBzN8YCZxw3TtkZEgu9+Nn6ZAPnQdxDyOGRmrh8OM0jrFAKvB6l4uFHhoFbbXNJDEE85FzLF601C8R9XdSaTepFBRNYWeUs7j1NBdcM54uhRfpbIJdaAGEPdba5ot+8lBtgQYl79CPZyT2zyWzoOfY7qqSWTTbKu/gReskwDnRxEqb7VvBDEEqxWCgd6rulUOWzxdvEasxmvcLAXTRCGEP6dakPlWckk4s+/gS2uFeOPfmKwsT3
 EOiqjs0I
 zVlo3YgA1RlA6lEDGlNwo6FjAKr62JMVRfxi2FIMoPq7XmuW8UIuFBZpPoYubk3MoPXUqQDwKT8KoHjZTwcD5ixCPUnYduOxxAdeOmI2K0FB2VdP7Bts5EgbxAsccLVQUmjlLKFMgaK+uDFN6diiHA7iPVdIIV+GvdcJYfKj46ymgxMpbXJ/GTBSv67ftrU3PNwCJZU32CKyDiyqrehiPC2iRk1skd6i2OSih7WJ/jKTH5ZRKAhxXQCOkItsvs2+ZMZZ6nlIoXE6hEmVjgiHknaxDMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Dec 07, 2025 at 12:26:37PM -0400, Jason Gunthorpe wrote:
> On Thu, Dec 04, 2025 at 10:10:03AM -0500, Peter Xu wrote:
> 
> > +/*
> > + * Hint function for mmap() about the size of mapping to be carried out.
> > + * This helps to enable huge pfnmaps as much as possible on BAR mappings.
> > + *
> > + * This function does the minimum check on mmap() parameters to make the
> > + * hint valid only. The majority of mmap() sanity check will be done later
> > + * in mmap().
> > + */
> > +int vfio_pci_core_get_mapping_order(struct vfio_device *device,
> > +				    unsigned long pgoff, size_t len)
> > +{
> > +	struct vfio_pci_core_device *vdev =
> > +	    container_of(device, struct vfio_pci_core_device, vdev);
> > +	struct pci_dev *pdev = vdev->pdev;
> > +	unsigned int index = pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> > +	unsigned long req_start;
> > +	size_t phys_len;
> > +
> > +	/* Currently, only bars 0-5 supports huge pfnmap */
> > +	if (index >= VFIO_PCI_ROM_REGION_INDEX)
> > +		return 0;
> > +
> > +	/*
> > +	 * NOTE: we're keeping things simple as of now, assuming the
> > +	 * physical address of BARs (aka, pci_resource_start(pdev, index))
> > +	 * should always be aligned with pgoff in vfio-pci's address space.
> > +	 */
> > +	req_start = (pgoff << PAGE_SHIFT) & ((1UL << VFIO_PCI_OFFSET_SHIFT) - 1);
> > +	phys_len = PAGE_ALIGN(pci_resource_len(pdev, index));
> > +
> > +	/*
> > +	 * If this happens, it will probably fail mmap() later.. mapping
> > +	 * hint isn't important anymore.
> > +	 */
> > +	if (req_start >= phys_len)
> > +		return 0;
> > +
> > +	phys_len = MIN(phys_len - req_start, len);
> > +
> > +	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && phys_len >= PUD_SIZE)
> > +		return PUD_ORDER;
> > +
> > +	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) && phys_len >= PMD_SIZE)
> > +		return PMD_ORDER;
> > +
> 
> This seems a bit weird, the vma length is already known, it is len,
> why do we go to all this trouble to recalculate len in terms of phys?
> 
> If the length is wrong the mmap will fail, so there is no issue with
> returning a larger order here.
> 
> I feel this should just return the order based on pci_resource_len()?

IIUC there's a trivial difference when partial of a huge bar is mapped.

Example: 1G bar, map range (pgoff=2M, size=1G-2M).

If we return bar size order, we'd say 1G, however then it means we'll do
the alignment with 1G. __thp_get_unmapped_area() will think it's not
proper, because:

	loff_t off_end = off + len;
	loff_t off_align = round_up(off, size);

	if (off_end <= off_align || (off_end - off_align) < size)
		return 0;

Here what we really want is to map (2M, 1G-2M) with 2M huge, not 1G, nor
4K.

> 
> And shouldn't the mm be the one aligning it to what the arch can do
> not drives?

Note that here checking CONFIG_ARCH_SUPPORTS_P*D_PFNMAP is a vfio behavior,
pairing with the huge_fault() of vfio-pci driver.  It implies if vfio-pci's
huge pfnmap is enabled or not.  If it's not enabled, we don't need to
report larger orders here.

Said that, this is still a valid point, that core mm should likely also
check against the configs when the kernel was built, though it should not
check against CONFIG_ARCH_SUPPORTS_PMD_PFNMAP.. Instead, it should check
HAVE_ARCH_TRANSPARENT_HUGEPAGE*.

But then... I really want to avoid adding more dependencies to THPs in core
mm on pfnmaps.  I used to decouple THP and huge mappings, that series
wasn't going anywhere, but adding these checks will add more dependencies..

Shall I keep it simple to leave it to drivers, until we have something more
solid (I think we need HAVE_ARCH_HUGE_P*D_LEAVES here)?

Even with that config ready, drivers should always still do proper check on
its own (drivers need to support huge pfnmaps here first before reporting
high orders).  So what I can add into core mm to check arch support would
only be an extra layer of safety net, not much real help but burn some cpu
cycles, IMHO...

Thanks,

-- 
Peter Xu


