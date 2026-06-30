Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19D1AC44501
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 12:51:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAEFD6B0127; Tue, 30 Jun 2026 08:51:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E86596B012A; Tue, 30 Jun 2026 08:51:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9D676B012B; Tue, 30 Jun 2026 08:51:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA1CD6B0127
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:51:57 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 38A571204D3
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:51:57 +0000 (UTC)
X-FDA: 84936566274.21.62DC639
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf21.hostedemail.com (Postfix) with ESMTP id 400311C0003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:51:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="Bxh/PMC9";
	spf=pass (imf21.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.42 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782823915;
	b=bVINj9E+00b9sYG5jwbSuxA8rLL/YzniFtkYDpQpd1+s+BlNDeB1204NyLQFreppZIGdm0
	jWQ1zQntvwD38qLD2A8zAhMne7jMcRtUe2gMFGe6BpZ+OHvzD1sm1ajwUd/gEgu/B0X9au
	+966YvNOpcxPWZ+4U+P6SfHvK0U8oCA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782823915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Yl758QqeVKhY4n2MCSMwX4uj2krX7F6fWmmpzTHj8k=;
	b=jLS5pZiKPNPVMKbH5eex0IBCA8GxO1AfHX1urX1H/ZOMfyPrPdXtQ4LT9+p4mEuA+YOkqC
	DExVKd8epvxNgi9AaKRmDL+ixMz0CGQv2jpvQOqgOyN6U2ERiMb9oTmUHe/mtJiQd1EU4q
	61/3YhHy1dPwR+gXLqG0P7R3DvtNc+U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="Bxh/PMC9";
	spf=pass (imf21.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.42 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8eeb4508f29so33485866d6.0
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1782823914; x=1783428714; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9Yl758QqeVKhY4n2MCSMwX4uj2krX7F6fWmmpzTHj8k=;
        b=Bxh/PMC9xwgXi4ORQMIVfSPXTkb4m6gan8cPc6VqxbmfZTOXtG0iB55aDulaUkzSfY
         FiLDDNue8XF2YYOG+jIjmkZ3IalMnFcx66lNqg2IaTnyqEjMBgSvJEEsZGljMpgw0Vza
         E4LMbJ5DjxNToa3xwOb1Uod2uSSBCVqDpFEzHDjEpZuxalJW4Yj9V8KHtw5f5YKATPDs
         D/XJXFPRLRjUnabMWgrI6oNt1C+N9I+lhCmV/piSBNV00xaO/nf+NfNz7wOVMWWAOd11
         KpccgiQH43EAMDIeSJOmszuTo27MPUjQ53trb56mtnxZu0XwNS16YQJkW999QWM2p/i8
         F+qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782823914; x=1783428714;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Yl758QqeVKhY4n2MCSMwX4uj2krX7F6fWmmpzTHj8k=;
        b=VCEZBo5CCgFV4C5VrwxmNSVqC99BI+rSg4ij1TCCd6SdpYP9utV1cSj24HRkPeNLTo
         +9ViRhrZsFbuToWgHoWR8yAG4fAUpGBDrIeQlBVkzaBLC+T0ZfKgrfB+0RksGyYFsB5f
         NMOX55grE53Ft+a+zJt5UV1Fe6YF+C57Q+SVFFEz+bFEZi78NSpdvPxxo5dwHh4CecZf
         +JPaAtdYglZrfojDN410clp5FkPSSmML9AyGBxPTVQwewUbzfW7zYZRLoG3jTMy67PoY
         ShpL2z7XO5JpdOdILHtp8A9rqRHxiuF8vXgMDLz56FKaRBqvdZxytvdWSOn2Ke/JmH1e
         bu5Q==
X-Forwarded-Encrypted: i=1; AHgh+RoVJxTK8ku1MJdrgG3sJC4B9YMGX97D4IFBlm0jSDtooVO97EnRJqARrl7xu9Jwd2L887UOivv0sA==@kvack.org
X-Gm-Message-State: AOJu0YwTB6ypS2shEfakx0tn+ZuQaTXqmXIiStfu+ZLPuZNFBBzKSee1
	kPRjCdMJZEoS9KK8H39+jXwnqWJN/YfAuTpHZiIrpQ/FAix/C34f96DISjDmEt4feqI=
X-Gm-Gg: AfdE7ckgNKPqAJNeWFoInJkEG/QoML6SH8Ux/IcDEPTxl8l8LaSpegjJeTqHjA4Xlpr
	GUdQpT186raMMFVBlyMmdBuhTDYTsrKn+eGIn9ERRFtMM336HQSuzGsSrEjbPOyIFzNVat+Q4zO
	2lq5njZQhQGQdNVHTKdTYNkzz3QgHEHOswilxTyaSg5Otl11GkdvCuAuCETofGRo1jVEFU1ckwi
	62qk0bsignqBucvRFpuk1xE2OSZuQNmI9zZJ26CNO1tNTyQ5Kw8yQ9/XpwuL/G7eN5oThLl7QqE
	E3AbAONgZLw/Cls8tvlD0MFSB0o8XoigTlPeJGhMaz5hOJ78K0I5KC9RXEXl5Kqi89YUSzY9NzB
	i2sVikuuxEWrCAhM8dNvaxJVmOwUIJVCvHwZYMrT2pMLbcvhdopLf4gfEW7oJj0NhyhJ0BqADcD
	Ke74klEAwBlpjOLvvivmVfJAUcvcDUKB+hnG61TbXNqPmFtlo35wdNVmxL0uBhQwaAuSo=
X-Received: by 2002:a05:6214:4e04:b0:8ee:6e1e:e38e with SMTP id 6a1803df08f44-8f2d13426acmr4770576d6.34.1782823914291;
        Tue, 30 Jun 2026 05:51:54 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f1a69c32cdsm23571706d6.31.2026.06.30.05.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 05:51:53 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1weXwP-00000001rWO-0UMp;
	Tue, 30 Jun 2026 09:51:53 -0300
Date: Tue, 30 Jun 2026 09:51:53 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
	Alex Williamson <alex@shazbot.org>,
	Anthony Pighin <anthony.pighin@nokia.com>,
	linux-kernel@vger.kernel.org,
	Kefeng Wang <wangkefeng.wang@huawei.com>, kvm@vger.kernel.org,
	linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH] vfio: Request THP-aligned mmap for device fds
Message-ID: <20260630125153.GF7525@ziepe.ca>
References: <20260616180129.160016-1-anthony.pighin@nokia.com>
 <20260616163054.77fdb61a@shazbot.org>
 <ajKtdCN0AlbmBnAj@x1.local>
 <ajLontmFa1oRXeoK@casper.infradead.org>
 <20260617192928.GB231643@ziepe.ca>
 <ajQDVAu9b-LX8gUQ@lucifer>
 <20260618152805.GF231643@ziepe.ca>
 <ajVqRiAMG23QGseC@casper.infradead.org>
 <20260619170705.GC1068655@ziepe.ca>
 <ajlW-Lf_tSBMccw1@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajlW-Lf_tSBMccw1@lucifer>
X-Stat-Signature: py1rbfbfrdtyg1damza7oraajxdq9hdg
X-Rspam-User: 
X-Rspamd-Queue-Id: 400311C0003
X-Rspamd-Server: rspam02
X-HE-Tag: 1782823915-205291
X-HE-Meta: U2FsdGVkX1/mefiwY0UC6itUTKQeADeVtnh+HDjjzOjCV8dCSL0za6RAsnEUU8V5Heg49ZxhZ7EYjP/rxteOG8rdWiRb6knyZ97IyNWqUme8b3edELUvCB6T/pOL6WSTVjXndYAOqPhJEgm9TSmOaPDmhXwgbMOnowYiX5yRMdal4p/eGosS9a/NhoRScNPl3AL9/q9BRkWa7KoNOhgGy0OT31yemYQ3gD14QXRIENDv9UFGuPSAFaCLUyvn8pSPFD+4wXPcJp95ckNI08A2hSTNtplyzlCoS+2O/l5YxrQaRaDWEs1qpg3gXy9nxijWRR8J2o1/q/bMPvIVQslXsudpm/6Bxb3rc9db5PGTfcQkxnWQylTh/r02yr9Vd6ktJFrU+zxzovYTGlT998G5N90TRTmG/E5YHke5pXrnHsjVQsGme/PFZCcYbDZObFAeWTGxFZ3NmWl1NFdXRazQUDvT4gECYJJcmDbc/IskVil7m4nJ4emt6eAe+tChezxisXQXxRdBbK7GAcq5yNEwzpqcRr/otdiHkfdPl4x2s4POfUN1jcOSsvMK5IVQ1VfPgStldW0HfgPQi9WjsdJOyHgU4rki1ihVJeY6eiIwCoPEB1mbZVrUlqfVJR+PvJpcFeqM1pta4/dtvxkgsxESIklmXXCbJ5d2OWjs9042Hm6Vc6oUQmoIP+7Fbkvq3s6hZ4PntGHa/sTko6H8cbIKdDF0J194der94VjOms/BmRlpFt/y8LLs0qVTPb+/x6x/jSZ8pEGQHaqAH29+0ISmYAxzmHz9JLjOkwa29mJzaGcStamOiF1vxUg6QkrAH5jzl5Ph8+0+v7lvoC5VNmO+wvPm7K/rfmMvew2K7HVBUUZQ6C3AIL2OPGEdvDTDxeFvfv6fiThEJgwjy/Jic2eYHPowuDJXXWPWaMThPsUUHuFNGA4mzulTNRtTAoK+rhjzjaNGYZ5s74l6ParhzCs
 YhyF9zhR
 V3jeO1/bAqXP8g1oGctKp+C12XkR5oHnN6WOI01L/QarF8EFhZiG+4MmTofTm777PIcLJVpmk5IBT/8RjtusbxXBXOnWNNaoJBM5xAMUAJnAUdgp4AJgTtiLarm5RT7enUyPxLg+Fvty15xAUqSfvnYhZB0TeOL833KIXEvU/+f8Ky4UKm91ikknDP8J0OZnCkbswel8ylWest3oE+5ElqKGRPYFiuH4hfk1urV6/jBjxbjmP19CchjzB5A3oqqpJd0HrU+gHjf5H+QHvf0OiTHiNi0imNFTT2c+W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 04:42:13PM +0100, Lorenzo Stoakes wrote:
> On Fri, Jun 19, 2026 at 02:07:05PM -0300, Jason Gunthorpe wrote:
> > On Fri, Jun 19, 2026 at 05:11:50PM +0100, Matthew Wilcox wrote:
> > > On Thu, Jun 18, 2026 at 12:28:05PM -0300, Jason Gunthorpe wrote:
> > > > On Thu, Jun 18, 2026 at 03:55:58PM +0100, Lorenzo Stoakes wrote:
> > > > > Can't we figure this out from what the driver tells us when it invokes an
> > > > > mmap_prepare action?
> > > >
> > > > VFIO installs the pages via fault handler so there is not a naturally
> > > > existing way to pass in the pfn?
> > >
> > > Is there an advantage to doing it this way?  I understand why we (eg)
> > > demand-page pagecache, that's obvious.  But I've never really understood
> > > the advantage to taking page faults for PFNMAP areas where we don't
> > > really do anything, just figure out which PFN needs to be installed.
> > > It defers page table allocation, I suppose.
> >
> > VFIO has a model where the mapping can come and go, so it makes the
> > entire VMA SIGBUS from time to time. The only way to do this currently
> > is with faulting.
> >
> > The mm also had races around populating the mmap in the mmap callback
> > and using zap on the inode, faulting avoids those too. Lorenzo may
> > have fixed that with the new interface though
> 
> Well, you can't populate the mmap in .mmap_prepare, we do it for you.
> 
> I guess the issue there is an race with an rmap walker? I did add a (slightly
> hideous) hack^Woption that keeps things rmap-locked until after the 'mmap
> action' is complete (action->hold_rmap_lock).

Yeah, I think that is partially right, if something wants to use zap
then there must be some kind of locking that guarentees after zap
there are never any stray PTEs. So if you race zap with mmap() the
mmap must complete and the PTEs must always be non-present.

Certainly rmap locking is a part of this, but you also need locking to
not populate the VMA in the first place.

   Driver CPU 0                       Zap CPU 1
   ============                       ========
 mmap()
    driver lock
      if (zapping)
        do nothing
      else
        remap pfn
    driver unlock
                                      driver lock
                                          zapping = true
                                          unmap_mapping_range(inode)
                                      driver unlock
    <no present PTE may exist in inode>

IIRC the current race is the mm calls the above pattern's mmap() prior to
setting up the rmap, so the remap_pfn succeeds, the
unmapping_mapping_range is a NOP, and we leak mapped VMAs.

But the ideal thing would be to allow the driver to populate such that
it is after the rmap is setup, under the driver lock, and optional so
an in-progress zap can be handled.

Jason

