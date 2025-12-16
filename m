Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5136AD609B6
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 16:01:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADC926B008A; Tue, 16 Dec 2025 11:01:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB4006B008C; Tue, 16 Dec 2025 11:01:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B3496B0092; Tue, 16 Dec 2025 11:01:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 89FA26B008A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:01:18 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 59F1F136606
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:01:18 +0000 (UTC)
X-FDA: 84225798636.20.C4483A0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id B10D040030
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:01:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YcuocAFN;
	spf=pass (imf17.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765900876; a=rsa-sha256;
	cv=none;
	b=DotFWZOQm9JOF/DpuE55Mz22hfIWd+QCzfY1oeCsjmTaUTlnuO7FL1OL/pXl17o5FHPJTn
	NIprVAhkyvuj0oOv71994nsASMKDSpVWsIQL3WRFboHN1GxsjIlVcId2iZ7djVLvp4k5eP
	Csmm6Dnv5mLgJ8gL2rVIBRboriyvHrs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YcuocAFN;
	spf=pass (imf17.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765900876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7n/t6p/jvZYpUfKx4Fl0OmmPDhqaugBP8Gk8GNKqtjk=;
	b=q+dYSaeRGzJkKNsqPVf+RVY2PMPd19D8s+plB8AnuMig6YjXKWMUf4HozvSvsTRm0ZJEmA
	rHGN5T/mxT3FfJGCOrtt4NaCD9rnoOdFk9sk4CCaCJjTSHu7AK49CS8FgYBPbXywa+h8VW
	C3m/6Fd5W/Swy0vIJZ2TlX8HWJcrxZE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765900875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7n/t6p/jvZYpUfKx4Fl0OmmPDhqaugBP8Gk8GNKqtjk=;
	b=YcuocAFNRksS1GmJ/GRSdaCKHvpV+PLGCORwsuWt/iSgnO+mlKW95XtO2G3xcmqLLJadHU
	3bFSDW8ksumwTDFQw93+sDWkQGIotZYIXUVlBtli4nN/EiRdlp8OjtFEycjxrgdxgVq0hS
	kRpYedCv8pyWqV813a4ulKyYmjtYReE=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-665-lOx6jFMrNOOQGQU0SFMlAQ-1; Tue, 16 Dec 2025 11:01:12 -0500
X-MC-Unique: lOx6jFMrNOOQGQU0SFMlAQ-1
X-Mimecast-MFC-AGG-ID: lOx6jFMrNOOQGQU0SFMlAQ_1765900871
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-7b8a12f0cb4so5880922b3a.3
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:01:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765900871; x=1766505671;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7n/t6p/jvZYpUfKx4Fl0OmmPDhqaugBP8Gk8GNKqtjk=;
        b=RTcNkLVFTJVKNi6xCigEiCm0Zrshm/jgxvzWoNV8MQ0WgT3m1AkoEoROita/toFgIT
         BCK6F74NXrPPp0ezfESW73iWArDgMcYRtQtVAve0abzsRdszenUnz/32mUMy3cNA/qQC
         hJQOD/0hXEd6ISZcYR5cX+cQpqRnw9gVcjH3kun6J2xXHeJF17t2nVgTY/SEI0W/ks4j
         +xkLaxjBM1kIHVdXn09AMqQLTFwHwb57Es6AGfMUTSe2fGHle35mGw15lC4Apk0URk8J
         MVhI5lW7PCVbMf0lDTrOMqKURnZHcKHTIH3OxyunVCftvAJ97yVDwKXxinlb6fJmMmr/
         srVg==
X-Forwarded-Encrypted: i=1; AJvYcCXT6FVyWdIdeGcxGLYVuSWerGgGiXwzCB561+FZuo7a9UmUQ4HEoeh4DOY+474aBw9TxdRFMKDAlQ==@kvack.org
X-Gm-Message-State: AOJu0YxX+pimalQ4W6JirVgKFqX3Pb/bcUdaqGR/VJdr9bH27erJE7i3
	vAdZMtYq3qonLhnSP6sJiEExbXVIvqKFEOMpYbuzX+PsFUucO832xXh78xio70RGIkfa/5J08Ic
	AtOa1vnzowgsB2FIDjFr4pYkhWe6PM4koMx2pJ+wE9GjR5eQZfbnJ
X-Gm-Gg: AY/fxX4g2dMF/mSwFvip8qkIvvIKqrz5JVxq6LMt1u2/4BWCSVgNYiflIs9hiy62Ejh
	wI9c8OIrmW3By5yi94Ayzb3l9ITryfCGr9i28HemBBIP8WOg7AZIk4kNJ/HknQTzmdGi3GVqiz+
	0ZxrmUd9HHMNinsWrd/4TFwnH+Jl4b73Y9hGvkj9Ebl2m5mVApSSktbPWmx4ImIQXOTInjgWAgm
	wUNphB5xbH94Fjck5mdpckOEMccHuwWKUY6YC8Uc015Xk/MEgTKBRxJKaH2KNSFDb0MBNVSkrUq
	pM6AGOa4RzncRrEAUAlNhg1uwZwEXAaQe+9+4UypYNKmBLCNy/Zu4WErpLiCofMunym5TfDov98
	Eb6U=
X-Received: by 2002:a05:6a00:2993:b0:781:4f0b:9c58 with SMTP id d2e1a72fcca58-7f667935e19mr15661156b3a.15.1765900870457;
        Tue, 16 Dec 2025 08:01:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFETgvpZCauQRnRvkaRDXoTYEkmrTUKb8yH8PJYSGK8XQagrI3k5h20qj2x7yaO23LdoS5X+w==
X-Received: by 2002:a05:6a00:2993:b0:781:4f0b:9c58 with SMTP id d2e1a72fcca58-7f667935e19mr15661042b3a.15.1765900869272;
        Tue, 16 Dec 2025 08:01:09 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4c53834a7sm15772514b3a.55.2025.12.16.08.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 08:01:08 -0800 (PST)
Date: Tue, 16 Dec 2025 11:01:00 -0500
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
Message-ID: <aUGCPN2ngvWMG2Ta@x1.local>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-5-peterx@redhat.com>
 <aTWqvfYHWWMgKHPQ@nvidia.com>
 <aTnbf_dtwOo_gaVM@x1.local>
 <20251216144224.GE6079@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20251216144224.GE6079@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oE1q4t-gAXCc2nXQXpmLmytQkIX5spSPkzw_mhevsTg_1765900871
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: B10D040030
X-Rspamd-Server: rspam04
X-Stat-Signature: jjrzaaswtsktxd4r585a99s47gdtbetp
X-HE-Tag: 1765900875-958726
X-HE-Meta: U2FsdGVkX1+5RNnNeLMexD6cxhw6KCUeqYbF+3mSFxzdhKaZ/C4n0Stbgh4zgzqWqtARVii4e0oLwli8SDLdImZ8hgdcbWJC0OrzFE0eNrqA5be82aafQxcmhw+gysMVxGhDLyaks2q8/WtwrO/OAoq0O6tJx70fFfcXBBVOgH+sAZk6wLRErEbVU7of1+4H5PtfLN7rD4IfZRJ2ZcuO2uETdRfFZ0Sp3AN6ziVhkMIsRjnlaLVeiA+71UHaxjuqkWSQ8hVO2U6s/jmKjEaFSnscZWv/tPPrbCwe3ICOAEyGeY9qJYoL6jFTpocqn4Vmvz9NjrIpBKV+aPWsQnZ7gn4Ebi4AGR5FMJTOLxfj+sv+o98pedDvZ2tXQGSAOgvd2KfE5zomrcVufqP7hCIkjIUyRw0rDHRqE47KAnWfJ4/fj8awgTszbzjZ4KltbvsdZh6Sgv4wVJ/GIOXXPMYeRs23DsrgJtM0Vx8O1VmpeqoqXR86i4xLEjII/5sj1McTiSyYaqLail1Lpm1nrDu0of/heBHBYZvC6XQM3X2O8vpbzQONqxYp3T8WFvVrsknRM/ABHcJ30ALAa+YzZxUlq0DyIWQ753vNBnx0i8+KWr2bP+JoIBlH/eydDpOLI2U/WeQrWcEvJhiidIZ0M0YiJcv1WsEiJa5npQ2JjYZx41kN1Ql0YqxxgCY8eA38FmR1BzrHUd3vB5lPdkNwR3GZ/k0nEKgP9rz2LGdHEyfA7Ns9BETrZrpU7l74QTzsZhgKSH71tReYX3yGZZRiBiIWR5Le7d1sB5gJ8ZRxlPEgAL3MkX7EqvsFty7un01/6h28p2f4PSynxouS1eYnecqtxkP1rATD3Xtu+fHwPg50lMwWHa0KQCMrl0gn61wy/7Lik8w7lIjwwMWI/MqqYCGjbbhnA3gCAM6eLCL844tyCdY+K1W/35L7Cw0+W9J2Vb4Cf6dKVyR1aZH6PiEFAt1
 PTQSop8g
 mi4LqSUCreXM5BwQYhbKpb7JKIliwrw/LzwYloMAxnEj6BxApPkpuIA9VC5Vjag0P5W+T0VAfus0YqiuPVdqNHDh/GARJRkvAslzwgHQ16enA5NZo2fb0p1kyZdFwr2qi9sNB5BASNeiUMV1RMdjU2w7LQ155yARjbWFcxa3kDuqs7pJE7L0fiWdMT/aniun87WoLEozLrr5DKfwF4hFtV9JhI+m045abKyzKFw3igwnggY4sdgcxTn3ZqESnmw+DPRUBTyaa4YW0gzjco/4sg7KZHvjyIRF1BVTrUFUd1TIkCYy+45gFc7ZJhZAQzg9aWBOfZhHToCLGBA6x4nbl57w2qguHmexVcOhfCjvQwfQmfFDZAQCOrzh7Vw6GCT7AU/zgWwWM5a1zieh3X60WvKUxMqjwkzxgpGzYmI5mYhxOHI6nB7JRLWGWKoO0isGgk4u9XNaCE7emPQdbRR8J3M1NLIA8XjH477XIB9pNO8BfTntXUglrW/67LSXpeMBWPvPZOEAS4w5Tq8mK8Pj7LOpDHvlK5Dc2PYvdDjWbjfQYtWoTiWNFXVoVlacmecze2It7vD3zkB6p0H29gZX96Vb9nQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 10:42:24AM -0400, Jason Gunthorpe wrote:
> On Wed, Dec 10, 2025 at 03:43:43PM -0500, Peter Xu wrote:
> > > This seems a bit weird, the vma length is already known, it is len,
> > > why do we go to all this trouble to recalculate len in terms of phys?
> > > 
> > > If the length is wrong the mmap will fail, so there is no issue with
> > > returning a larger order here.
> > > 
> > > I feel this should just return the order based on pci_resource_len()?
> > 
> > IIUC there's a trivial difference when partial of a huge bar is mapped.
> > 
> > Example: 1G bar, map range (pgoff=2M, size=1G-2M).
> > 
> > If we return bar size order, we'd say 1G, however then it means we'll do
> > the alignment with 1G. __thp_get_unmapped_area() will think it's not
> > proper, because:
> > 
> > 	loff_t off_end = off + len;
> > 	loff_t off_align = round_up(off, size);
> > 
> > 	if (off_end <= off_align || (off_end - off_align) < size)
> > 		return 0;
> > 
> > Here what we really want is to map (2M, 1G-2M) with 2M huge, not 1G, nor
> > 4K.
> 
> This was the point of my prior email, the alignment calculation can't
> just be 'align to a size'. The core code needs to choose a VA such
> that:

IMHO these are two different things we're discussing here.  I've replied in
the other email about pgoff alignments, I think it's properly done, let's
keep the discussion there.  I'll reply to the other issue raised.

> 
>    VA % (1 << order) == pg_off % (1 << order)
> 
> So if VFIO returns 1G then the VA should be aligned to 2M within a 1G
> region. This allows opportunities to increase the alignment as the
> mapping continues, eg if the arch supports a 32M 16x2M contiguous page
> then we'd get 32M mappings with your example.
> 
> The core code should adjust the target order from the driver by:
>    lowest of order or size rounded down to a power of two
>  then
>    highest arch supported leaf size below the above

Yes, maybe this would be better.

E.g. I would expect if a driver has 32M returned (order=13), then on x86_64
it should be adjusted to 2M (order=9), but on a 4K pgsize arm64 it should
be kept as 32M (order=13) as it matches contpmds.

Do we have any function that we can fetch the best mapping lower than a
specific order?

> 
> None of this logic should be in drivers.

I still think it's the driver's decision to have its own macro controlling
the huge pfnmap behavior.  I agree with you core mm can have it, I don't
see it blocks the driver not returning huge order if huge pfnmap is turned
off.  VFIO-PCI currently indeed only depends directly on global THP
configs, but I don't see why it's strictly needed.  So I think it's fine if
a driver (even if global THP enabled for pmd/pud) deselect huge pfnmap for
other reasons, then here the order returned can still always be PSIZE for
the driver.  It's really not a huge deal to me.

> 
> The way to think about this is that the driver is returning an order
> which indicates the maximum case where:
> 
>    VA % (1 << order) == pg_off % (1 << order)
> 
> Could be true. Eg a PCI BAR returns an order that is the size of the
> BAR because it is always true. Something that stores at most 1G pages
> would return 1G pages, etc.
> 
> > Note that here checking CONFIG_ARCH_SUPPORTS_P*D_PFNMAP is a vfio behavior,
> > pairing with the huge_fault() of vfio-pci driver.  It implies if vfio-pci's
> > huge pfnmap is enabled or not.  If it's not enabled, we don't need to
> > report larger orders here.
> 
> Honestly, I'd ignore this, and I'm not sure VFIO should be testing
> those in the huge_fault either. Again the core code should deal with
> it.
> 
> > Shall I keep it simple to leave it to drivers, until we have something more
> > solid (I think we need HAVE_ARCH_HUGE_P*D_LEAVES here)?
> 
> Logic like this should not be in drivers.
> 
> > Even with that config ready, drivers should always still do proper check on
> > its own (drivers need to support huge pfnmaps here first before reporting
> > high orders).  
> 
> Drivers shouldn't implement this alignment function without also
> implementing huge fault, it is pointless. Don't see a reason to add
> extra complexity.

It's not implementing the order hint without huge fault.  It's when both
are turned off in a kernel config.. then the order hint (even from driver
POV) shouldn't need to be reported.

I don't know why you have so strong feeling on having a config check in
vfio-pci drivers is bad.  I still think it's good to have it pairing with
the same macro in huge_fault(), because it's essentially part of the whole
pfnmap feature so it's fair they're guarded by the same kernel config, but
I'm ok either way in case of current case of vfio-pci where it 100% depends
on global THP setups.

-- 
Peter Xu


