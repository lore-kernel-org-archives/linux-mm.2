Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02D76D609B1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 15:42:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D32A6B0005; Tue, 16 Dec 2025 10:42:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49A9E6B0088; Tue, 16 Dec 2025 10:42:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37C6A6B008A; Tue, 16 Dec 2025 10:42:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 22C1F6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:42:58 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B4A19136252
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:42:57 +0000 (UTC)
X-FDA: 84225752394.26.D4FCFC7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5CB12180014
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:42:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PfJlJkg2;
	spf=pass (imf16.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765899775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d5KXOzuQhkZAaENyDSkIPF8i/y4z+WQGbelXRyoz6Cc=;
	b=206QqPICGGICKkDsIzet+sDJohkk9zlKBaRcgJhde22+geRpx05Wu1sFSo2uvDIIfzdsXa
	coiQU58ZXPrh7LyCZVNU9kvVOzQzk43e6fH0XeQh0Hj/rh+pJdgEoq36ZoU2ZYYH2uIyDb
	eGy+TW/eTxt0rAtw8DL5eq91WIzt0Hs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765899775; a=rsa-sha256;
	cv=none;
	b=ce933DpjV70keA5TkvOlNeSyc66zasDCYmPKr35jt31kL9l0HXnxG7rov+NQoottCiE8cj
	nGXQ5n7ZvPBE0zavkD+WRBZdifZlBSsJzvbz/0mP50eAwz/jHSSUfQtUoszvQjpgQ8aLUy
	laj0YuhvZ+hidxzRmYi7vlYNfdp1IEA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PfJlJkg2;
	spf=pass (imf16.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765899774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d5KXOzuQhkZAaENyDSkIPF8i/y4z+WQGbelXRyoz6Cc=;
	b=PfJlJkg2WEErTavn4vJ7ROusSpZ2urA2588iH95X3BBQ35C5YXl6yh1FIX3WYs48QCyfjC
	0Orz/pD+KUgF2CjXRKfMnS/4X5+CbKwz9Spp422wdfpmMsyOZAi+0orjPOCmu/1DfostPD
	AwmZeos+Kol92knMmxuiCf9pL0zyrf4=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-IJccNGhSOVWGnmj2mMsUnw-1; Tue, 16 Dec 2025 10:42:52 -0500
X-MC-Unique: IJccNGhSOVWGnmj2mMsUnw-1
X-Mimecast-MFC-AGG-ID: IJccNGhSOVWGnmj2mMsUnw_1765899771
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-7f21951c317so4017284b3a.2
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:42:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765899771; x=1766504571;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d5KXOzuQhkZAaENyDSkIPF8i/y4z+WQGbelXRyoz6Cc=;
        b=K0yaK2d8SxAlmUlFTi4Whx4fqGdLzS2uzifhL6aEENeJ0ZX5M7bbldhsHlCFVAJGw/
         4sPEn3qh1cSbM4mzE4FzKMQ2FkukTSCbLhV0wCoLLr6FYr7w4VX9P+YRFXvEARFJ2P9d
         Y0rlnsPL8VhVNGr08D4Fmb48F1nzjyxe++WE02Vj3t1rPlU7lBuNYczBX2kVCBHMvR+1
         Zm1CB3WKpe+oC0M+4M0GSi8EGlG4gwNtobB3Q6AruOCRAmX5uqwXmKyTEi6Pn1N5eCzB
         XSEX2rj313mnh4ws2o7yv8vyUqmOTwKqjhUjzGxmDBF56htuyWqHDvp3UJHlg+ozV6ev
         oE5A==
X-Forwarded-Encrypted: i=1; AJvYcCVJ/Deh7ZF6YxUY8aw6A7JtJ7OmapiSj4OoVqufUfxmFJnuJ5B3t4NAxl9hiCRB6nfF9rHaDUxUzw==@kvack.org
X-Gm-Message-State: AOJu0YzHB5LAMkVZdbaW7D+es1pmW6yeY/poG9QRJQi8g7UybkO6SMG1
	cbj7tbbWB3jsrKvxdKBqjW7bWW8grn0v5nIlKu3lc0e++vj0i7/3PrUUCtfdlJSNr9DOvc4R2h7
	gijFkirrCV4UmLxSHItA9BuekkYrj4oOWfV4ypKyqu8INobE020Ia
X-Gm-Gg: AY/fxX4gj7dwG2s1Yzx51wiN+foFByMZtWZN/VdZ63+TQbh2bIj9+k3jMtiPKB6mvbJ
	ANkvVLU37hTRi4xDUy2Zk3igMIglzancHkez9LfaYG13GxFaPsxVUWatjhlDvfd7t8KDQlvdulH
	qtjFBUIkmRmRJGE8C+fCbqLc7TfXBhF+Umoz0iUsS47L/likP9y8q5WTjp2fSi1I/NjBuN8/Kp1
	j16WB7emp2pPTY6YmFdy59Yggb5neO1QhJo3UBfVmK0cF5KxUEQ34ukYW/RcJK9IJPxdYeCfyUM
	znOfTpktiM5Vxt2Q3i0iRQwPvCOnZRU9pfjyzMQlE4wZydE6CgumY9UEqqvYeB2c2yFaaqxq5M0
	fJz4=
X-Received: by 2002:a05:6a00:f0d:b0:7aa:ac12:2c2e with SMTP id d2e1a72fcca58-7f667d17b97mr13569084b3a.25.1765899771109;
        Tue, 16 Dec 2025 07:42:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFLCCVgc3/X1w3LsrtnhDoEJCb55PbVIq0LxCDKAJ9JaT01nvcCM+COudpJkrEncaDLaUIQCQ==
X-Received: by 2002:a05:6a00:f0d:b0:7aa:ac12:2c2e with SMTP id d2e1a72fcca58-7f667d17b97mr13569056b3a.25.1765899770643;
        Tue, 16 Dec 2025 07:42:50 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4c5481289sm15994024b3a.64.2025.12.16.07.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 07:42:50 -0800 (PST)
Date: Tue, 16 Dec 2025 10:42:39 -0500
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
Subject: Re: [PATCH v2 2/4] mm: Add file_operations.get_mapping_order()
Message-ID: <aUF97-BQ8X45IDqE@x1.local>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-3-peterx@redhat.com>
 <aTWpjOhLOMOB2e74@nvidia.com>
 <aTnWphMGVwWl12FX@x1.local>
 <20251216144427.GF6079@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20251216144427.GF6079@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: V1RBoxVmHeFsWb3XG_lrlpGgCGRHe0sL9A4u9rVfsTU_1765899771
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Stat-Signature: z6i7yay9siarmg67c35grohc3ftra8a6
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5CB12180014
X-Rspam-User: 
X-HE-Tag: 1765899775-436233
X-HE-Meta: U2FsdGVkX19wMAWGSHycr6nyiXlSuyHntMwbmEpbDJ/6SMdLH/rcpdCRO72k9AN+FL+paz/U61SeOpRSPrTyJd1aoMvEnGbGN8+EV3DH7QodR9KXpFpMCc4MCOGZhTAPZaxk2Ooz5fil06DMpUT6iXPH97J98GDNZO+3Q57+rRtrJ5v+WBJRazrNsXJdeR417XHc4P9RdRRV675PkDhhtt/PB8neQLNyWfbJ/giGPFRGt9EOdcZ5deQ2wJJuEGOHZcp2QGgTavt5ZI40rrJmRnA8GEykgbFXnCzOMs9wNqznRmLLSwqCMLYP/9/lYPOfapJHCpZLDbmlSXUKwgFb/4HQsVSvR4zvxsotjrkaWmL/hUe5v9Hq/TPEacGEKDG3Lp+BV3oBX1F025EgC4XCIQANRDsv1N78OPlfpsev/XtBNhn2HsqgO5wgjrIAKl9z8AmDPuQm6OWTCcN6OatTGAIEF39v1zXpPb6F4UIsjpIHpj3XMmY5P1sxvFOirAtDkLvGkdpOvI3XtyjXKhQ+3zURw9xJl7EkgErNGtGbUP4GDBfNPjqBj+mfwmJboGYfTip4ge1l+Y+4pHwAzOm7qopJpYElvtRY4209FF+PwvQX5k7B66Cyu6CWs5mSYjIJUmyVHbDOxdRTsHx7a2JahfPO2sTCW+1Zqxxe/drFhq8YNh7YtA+/891Otwe263ZyjiJYLjRlzJJCy8Vvhf2cwp2cWRlI+VnCBAuaeObls7PhOt7GCh7jQoB3zsU7uJ4JiU4RR6bTZB7MzXQKyehzYL6cBz5rFqlbxoEZgFlISfyvqNDT4FkavKQHLRsgCDSZbH0r1stWugZI+yJY8Z9zgIkvF31KILO4XQR08wpYPhQd/Z6SbL83W3jre2sxIwYn4bqYVRG4TopAI0uhk1hDkMjomeQGjYp2uhM3B2bxaOvm493LBiiwIQNSRgn5vqz7HKPikK4K0y7Npi02IM8
 cHSL0oJp
 myRzKc/TU6MT279gsxUZ58oCORaSLhPEI08l2KeJULwgaoKGPxfJiF0oDnauF/tK5Q6UGzL7ImLRi33mpKJ1KLio3lTnnflGwlbaTHAieSGyi81uxLrEm9++RpbbwCh3ebr7y/yi4nE93vI++dOL0i6An8t9XR6jeNic+VFWi3LsJAFrzDmq95xS1fKgg9TJ5zhRL+hjqKw3lifTl3qzu/voANk2q49G4JONP4KjMa09pl70zWeGvwyqH76Chy4HH/Ucf9mbnSjAxtr+4MhYLxKfXD2uqAEtb8UbFTDpZUv8KWN5r/SkOngvTeTz3VrcRhQCQlFQSgPy8+THujfxGvuQp3IOBXIftGXSKMWXwBDzBZzsAbQFIz3WmU+ENM1iRwnW532+ywOpL3Lrkp95LDFZSNT9Vlvmlf/jDzUgVk2Z+TbhbZ7HjU/8SA6zaSzlm7NkW4e7/LKHVqj6FVttwDDBldfKEup6qyHkDRTrIHN7/VdMfqAxg1FmgeuriJPZqqQLcu56pNxuXEPkyVSbZxO0jaIZmKn8HR4asyExr2Tzmi7R+gazcjwp8dKDzQgky24P+AS/yUUF10ZUnvF9/J09/fwW2DxEi7u5hVYI+vubPy28=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 10:44:27AM -0400, Jason Gunthorpe wrote:
> On Wed, Dec 10, 2025 at 03:23:02PM -0500, Peter Xu wrote:
> > On Sun, Dec 07, 2025 at 12:21:32PM -0400, Jason Gunthorpe wrote:
> > > On Thu, Dec 04, 2025 at 10:10:01AM -0500, Peter Xu wrote:
> > > > Add one new file operation, get_mapping_order().  It can be used by file
> > > > backends to report mapping order hints.
> > > > 
> > > > By default, Linux assumed we will map in PAGE_SIZE chunks.  With this hint,
> > > > the driver can report the possibility of mapping chunks that are larger
> > > > than PAGE_SIZE.  Then, the VA allocator will try to use that as alignment
> > > > when allocating the VA ranges.
> > > > 
> > > > This is useful because when chunks to be mapped are larger than PAGE_SIZE,
> > > > VA alignment matters and it needs to be aligned with the size of the chunk
> > > > to be mapped.
> > > > 
> > > > Said that, no matter what is the alignment used for the VA allocation, the
> > > > driver can still decide which size to map the chunks.  It is also not an
> > > > issue if it keeps mapping in PAGE_SIZE.
> > > > 
> > > > get_mapping_order() is defined to take three parameters.  Besides the 1st
> > > > parameter which will be the file object pointer, the 2nd + 3rd parameters
> > > > being the pgoff + size of the mmap() request.  Its retval is defined as the
> > > > order, which must be non-negative to enable the alignment.  When zero is
> > > > returned, it should behave like when the hint is not provided, IOW,
> > > > alignment will still be PAGE_SIZE.
> > > 
> > > This should explain how it works when the incoming pgoff is not
> > > aligned..
> > 
> > Hmm, I thought the charm of this new proposal (based on suggestions of your
> > v1 reviews) is to not need to worry on this..  Or maybe you meant I should
> > add some doc comments in the commit message?
> 
> It can't be ignored, I don't think I ever said that. I said the driver
> shouldn't have to worry about it, the core MM should deal with this.
> 
> > > I think for dpdk we want to support mapping around the MSI hole so
> > > something like
> > > 
> > >  pgoff 0 -> 2M
> > >  skip 4k
> > >  2m + 4k -> 64M
> > > 
> > > Should setup the last VMA to align to 2M + 4k so the first PMD is
> > > fragmented to 4k pages but the remaning part is 2M sized or better.
> > > 
> > > We just noticed a bug very similer to this in qemu around it's manual
> > > alignment scheme where it would de-align things around the MSI window
> > > and spoil the PMDs.
> > 
> > Right, IIUC this series should work all fine exactly as you said.
> 
> Are you sure? I did not see code doing this. The second mapping needs
> to select a VA such that
> 
>   VA % 2M == 4k
> 
> And I don't see it doing that.

I have an old program tested this, I ran it but I didn't mention it in the
cover letter.  I'm 99% sure it works like it, unless I'm seriously wrong
somewhere.

See:

https://github.com/xzpeter/clibs/blob/master/misc/vfio-pci-nofix.c

mmap BAR with memory ENABLED and read (offset=0x0, size=0x8000000)
mmap()=0x7f4395a00000 - 0.000117s
read(32768) - 0.085376s
mmap BAR with memory ENABLED and read (offset=0x1000, size=0x7fff000)
mmap()=0x7f4395a01000 - 0.000012s
read(32767) - 0.088642s
mmap BAR with memory ENABLED and read (offset=0x0, size=0x7fff000)
mmap()=0x7f4395a00000 - 0.000015s
read(32767) - 0.093850s
mmap BAR with memory ENABLED and read (offset=0x1000, size=0x7ffe000)
mmap()=0x7f4395a01000 - 0.000011s
read(32766) - 0.093248s

Also see __thp_get_unmapped_area() processed such pgoff, it allocates VA
with len_pad (not len), and pad the retval at last.

Please let me know if it didn't work like it, then it might be a bug.

Thanks,

-- 
Peter Xu


