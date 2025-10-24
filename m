Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78247CCD1AB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 06:51:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5F1F8E0039; Fri, 24 Oct 2025 02:50:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C36AB8E0002; Fri, 24 Oct 2025 02:50:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4CD48E0039; Fri, 24 Oct 2025 02:50:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A592C8E0002
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 02:50:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3A31588F40
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 06:50:59 +0000 (UTC)
X-FDA: 84032085438.12.54CE0E4
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4551240009
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 06:50:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=M51apLZB;
	spf=pass (imf04.hostedemail.com: domain of david@fromorbit.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=david@fromorbit.com;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761288657; a=rsa-sha256;
	cv=none;
	b=ADoeMwc2ag5fjQSyvpwUZADlojrx2/rr316QQgettCBepoKDrcslhb+eNp5dq//xUSun4a
	BaVPIBPsHRt0HywdFwPeOcVkqaNFaVcc1vopvxpuOoueRpqih7W+OpEwJWxmJWaLQdbAuB
	n+TjuTCCv1gnyyeDZhArkW33X0LcOSs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=fromorbit-com.20230601.gappssmtp.com header.s=20230601 header.b=M51apLZB;
	spf=pass (imf04.hostedemail.com: domain of david@fromorbit.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=david@fromorbit.com;
	dmarc=pass (policy=quarantine) header.from=fromorbit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761288657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DHCxcy5rr5LIi478WtCZse20PdH2a3ydVXLtPEk9x3Y=;
	b=yEs2VVbCZe3eBDNBeULiNxmCQ+Ci7Ls14IMc+2sD1GP9KTK62OWhZBIdEGV6c7593X5dKx
	Jd8U93tkjTspDp+1vPdzERJH7Z1SrEN24YbGPsqEWCIh3yC5pBOyNJeCnNURduQeiAHkzr
	KPJXRh/Mt0zENsFNfjtuLof/huHYPrM=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b6cdba2663dso1236635a12.2
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 23:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1761288656; x=1761893456; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DHCxcy5rr5LIi478WtCZse20PdH2a3ydVXLtPEk9x3Y=;
        b=M51apLZBQwCtFM2Xr+SQWQnk+xwF2K9oG7rO43IziUUE1cYU2WMYrnirl+dN0gLN0T
         7ddP2jYX8tVXH19VvWD4MU/E4/7QRwGNDPQPBZClx46utk0GfY44uV/Qh+d4XlFxQOBe
         PaCpE9XFMUQ+rFJkZIKs+5xV3nOsR22yqudXZxQer23lSdPQy/2RfVdG7dRICWHXh60l
         jzz/+VV8Vgs3nf4QDa+roMOxBScHq1mW6TVNud4yHeRvSgrS+OgboJ03/pcjrmrd22lR
         gU1tL4QYyx024k4GZOED5LFnaV3+OGlGRhiXoJOaaeC3v/Q+CNBwrJlx332uny6XvIgh
         CBsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761288656; x=1761893456;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DHCxcy5rr5LIi478WtCZse20PdH2a3ydVXLtPEk9x3Y=;
        b=KehBD633n4Z9/l+HHTkfOroYu4d16GyTL4BRFnPFVGFHJc8orYm3jwasDA/BW7guDo
         iFvd4kps8NJe1kG8BfumPQE7I2Q+vHvkSOhZyE9/Kj5bU9AiiTxPBSBwqd4qNVhRw5Nf
         BMvhE/sopVlDaqmzbbikag6SxVySqyjZfyRlewPCFxAWcZpyD5Z0maxRRLwpAgY6iQ+6
         CdfSFz29JCI6jsf4XBE6vXpwWwccuWBc366/rlTxhdhX1fZJskt5J9f3Nr8MfvyklUqd
         ZKu2daQAAclxS4b7EsrpRreMfoSGxvqcU3j4mBTlr0FV5llKj4aae2kM9bF406y0fXse
         Qw8Q==
X-Forwarded-Encrypted: i=1; AJvYcCXgj0EuqdeVwmTdhmd+3gSIafuOfTTKgBwAMWF4oDm6l0b7U3q+Vyxk/zFwMt8YIcss6DSnTYetsA==@kvack.org
X-Gm-Message-State: AOJu0Yx3okqCP6dYtWf5AQZgKhKsFTnVNuQGycNb/sMrOrE5z4ZQKGC3
	+ilkdVRzhCZmrp3uhvVC9Qr8tFXlaGyljXxp5lJw90U4krT4tIrQrqXPJIKaCR01tvM=
X-Gm-Gg: ASbGncuq7CqeJHfzHNc5Fqg094xHJQrrgt3A6049ojIIetaIWaY6hB9uW1TaViNntHV
	jewXJr/YTDmhT8R8hLH4n2rHZ+2kGIyP33TjlTQq9GOfjRY9FQSdtY/fS/GDdHDr62QGKqm56VA
	U9XVBRL3n10z975AQwM3Lnr+fOeK8vTbsi78zJu91tZ4xlvYx3kXt2VY2wfwyCdABhEiN6O3Bwg
	kp8VVnfq29RNTJ4bmMBxE2BVnd4PKNBVDUlDXxCZ5haqTqWlIWb+bweLxZyiYWPGg6McJjjp7wi
	jomTXJIf5GlPyXjHjFAcs2cU+9DnJVshiZBwYnaqgysfkaEuNsyAkF30bsDroMsqYkXonKukAJT
	M0UkAbDTGf1s/TjycKMd5S4TDX263Dv14W5WEj6OHqQP5KR4s/Haay9sQehotRX/RHzYF7BNbZW
	3KVoBWkf2ON8+hURqqOWcC856ZQykvMFtfrDo2GzHtgnpI08cnDXHFW05Hd9aiPg==
X-Google-Smtp-Source: AGHT+IFom99rdUC4rqHBj2JdLSCZeZQXVVqQvty9JoHlT9qtIJ5LbSGWQ/CZd37bHNSPFzQXNSZTzg==
X-Received: by 2002:a17:903:1a4c:b0:27e:ef09:4ab6 with SMTP id d9443c01a7336-290c99ad18bmr336153455ad.0.1761288655816;
        Thu, 23 Oct 2025 23:50:55 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-91-142.pa.nsw.optusnet.com.au. [49.180.91.142])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2946e2578desm44175585ad.106.2025.10.23.23.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 23:50:55 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98.2)
	(envelope-from <david@fromorbit.com>)
	id 1vCBdU-00000001NJi-0OGs;
	Fri, 24 Oct 2025 17:50:52 +1100
Date: Fri, 24 Oct 2025 17:50:52 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: Kiryl Shutsemau <kirill@shutemov.name>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-mm <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 0/2] Large folios vs. SIGBUS semantics
Message-ID: <aPshzHsqp2Srau5T@dread.disaster.area>
References: <20251020163054.1063646-1-kirill@shutemov.name>
 <aPbFgnW1ewPzpBGz@dread.disaster.area>
 <d7s4dpxtfwf2kdp4zd7szy22lxrhdjilxrsrtpm7ckzsnosdmo@bq43jwx7omq3>
 <aPoTw1qaEhU5CYmI@dread.disaster.area>
 <AF891D9F-C006-411C-BC4C-3787622AB189@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AF891D9F-C006-411C-BC4C-3787622AB189@dilger.ca>
X-Rspam-User: 
X-Stat-Signature: efnm458zq3odq7b8x6afmubkdmwauiyr
X-Rspamd-Queue-Id: 4551240009
X-Rspamd-Server: rspam09
X-HE-Tag: 1761288657-287743
X-HE-Meta: U2FsdGVkX19xyFiUzO1JqMRhLkD7DVGGR2uA7DkfPMe4oaULOVdahGxWTHBl4E5kFDP8w8PlTvxg7vWkYqUhCvbr4ziXH/7HtOylunh/V4Mu976oxYXvXBKhjFywJ1ah+gKI2EYn0SYxfclyuVdpvCYOAYwcigpMoN4tAm5a2w+iGmc43X4L3CD6IJB+j8bYZXQBZxqHS3lNyjNxe3JZXTcwvjY0zjGwakFpSuhhzTDUA96G1qeQ9BLwjYsUNLwaQTIFaauhWp17EPeo82LlfOIZumJF/Qei9OeTcWJl8QbRpseU/5RmC3L0yWCBpy21lx/726suou0621GBF1x04BRa58WU6v8h7wajLv5ol3t6/CXFfjFswv1bDR/sgYYi5FITThkTS7F71Rq1we+IbwxGV5DbnBROBGJ8tS37lADdnglAeu5q/bEnSCF3sTtSN5D16oX/MvSQM0Cbp4oFHJV20N14tNYHhOyS/jFrf0TbqwOOn/x1xm+qM0//UVp9UO80OKmBAYkLPI1nQ6zrG1HASE88ZldVVQ05/xxeeTE+bGdVVLoLBG9cTkWJlT+JaSnlcW7OEXVcUxDaVNXfQKfycmmPUWgz908yr8SvX7xHVPmbacvCr6BoHADIjR1mEMYWUeJWlRJOQEKQeIBuJXOiXv2t0OID6QDKdDzog0o58meS6SZ8GvV5r/dWJP5bDOuObNVwPBm8h4ONXpmd2fKaITPk+EEzYYzS9eeAhNxK1CNy+gXcdqrkBDKdiYbVcxsLRGk3srS3YTEj+7Gruin45GHcKP+/ZZ9Ej4GiB4mzBDX5+KZ3GrnDNC3zCps5FTRhs/LNkoRCLO7qe9+3zZfL2Gox7e0xXXMSK/wj4OJC1IUBKnyunOfiTW/BpJzrbQT1XXji56e+Pc8iEiWtcxFju+PXRz0WiSEEHsKvxRzrT+V9IOzDzPoLaWnWgqhfMh32xsEVA744JO0iWxv
 OCmCk5qg
 Pmw3iAk2MOmNSdUSIadHN73Qyg3URfdtVzzPFnAFG+tEzrPJ8zFgeXMsqEnuXFsr2Se5iHlBHfupuLYA9dHTCFfjgJwuvz0LgSElFuP4j98W/3HN+usUS99Cu0g9tEMfx1pfdQ5RG0ZvrWMU6yJqjbKy95EO43UEWxMwDVuh5GRZXB+guIDFbQT45JXbUceblW1UfWBbovt7r/v9KqV/NEHqRY8o6E1OryOslN/78Tz3s2dikZpz7HQJ5BwLAbj3S1jUH5kIid/rhTY6bIZLSxwlb58Zj3mtW5I+lewgEHageLnDaYPG13/+3ccQy45jXGLlhouyHN1/L4X2ou1voxoSFwsY9GtIO/2k9ceNFSXVzivCGZFWJdLvNk8dZSOUBtiGK+BcWEq9f9ogErNDtFg/HgagAKZPA13Z1jMAZM1QZYjCI6YyfVyTZ3ZSgFdZI6gLELuvWwpe40f4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 09:48:58AM -0600, Andreas Dilger wrote:
> > On Oct 23, 2025, at 5:38 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Tue, Oct 21, 2025 at 07:16:26AM +0100, Kiryl Shutsemau wrote:
> >> On Tue, Oct 21, 2025 at 10:28:02AM +1100, Dave Chinner wrote:
> >>> In critical paths like truncate, correctness and safety come first.
> >>> Performance is only a secondary consideration.  The overlap of
> >>> mmap() and truncate() is an area where we have had many, many bugs
> >>> and, at minimum, the current POSIX behaviour largely shields us from
> >>> serious stale data exposure events when those bugs (inevitably)
> >>> occur.
> >> 
> >> How do you prevent writes via GUP racing with truncate()?
> >> 
> >> Something like this:
> >> 
> >> 	CPU0				CPU1
> >> fd = open("file")
> >> p = mmap(fd)
> >> whatever_syscall(p)
> >>  get_user_pages(p, &page)
> >>  				truncate("file");
> >>  <write to page>
> >>  put_page(page);
> > 
> > Forget about truncate, go look at the comment above
> > writable_file_mapping_allowed() about using GUP this way.
> > 
> > i.e. file-backed mmap/GUP is a known broken anti-pattern. We've
> > spent the past 15+ years telling people that it is unfixably broken
> > and they will crash their kernel or corrupt there data if they do
> > this.
> > 
> > This is not supported functionality because real world production
> > use ends up exposing problems with sync and background writeback
> > races, truncate races, fallocate() races, writes into holes, writes
> > into preallocated regions, writes over shared extents that require
> > copy-on-write, etc, etc, ad nausiem.
> > 
> > If anyone is using filebacked mappings like this, then when it
> > breaks they get to keep all the broken pieces to themselves.
> 
> Should ftruncate("file") return ETXTBUSY in this case, so that users
> and applications know this doesn't work/isn't safe?

No, it is better to block waiting for the GUP to release the
reference (see below), but the general problem is that we cannot
reliably discriminate GUP references from other page cache based
references just by looking at the folio resident in the page cache.

However, when FSDAX is being used, trucate does, in fact, block
waiting for GUP references to be release. fsdax does not use page
references to track in use pages - the filesystem metadata tracks
allocated and free pages, not the mm/ subsystem. There are no
page cache references to the pages, because there is no page
cache. Hence we can use the difference between the map count and the
reference count to determine if there are any references we cannot
forcibly unmap (e.g. GUP) just by looking at the backing store folio
state.

Hence we can block truncate on non mapcount references via the
layout lease hooks like so: i.e.:

->setattr
 xfs_vn_setattr
   xfs_break_layouts(BREAK_UNMAP)
      xfs_break_dax_layouts()
        dax_break_layout_inode()
	  dax_break_layout()
	    page = dax_layout_busy_page_range()
	      page = dax_busy_page()
		 /* page returned if it is held by GUP */
	    wait_page_idle(page)
	         /* blocks until extra ref counts go away */

and only when all the non-mapcount page references are gone across
the truncate range is the truncate allowed to proceed.

IIRC, we decided to block truncate and other operations that need
backing store access exclusion rather than returned an error because
nobody expects operations like truncate to randomly fail like this.
Such behaviour would likely break applications in unexpected ways,
so it was decided to play it safe and block until the ref goes away.

This is one of the reasons for FOLL_LONGTERM  being added - we
can't allow longterm pinning of file-backed fsadax pages (e.g. RDMA
regions using filebacked mappings) because then operations like
truncate can be blocked for hours/days/weeks. This situation is
checked via vma_is_fsdax() in mm/gup.c::check_vma_flags()...

> Unfortunately,
> today's application developers barely even know how IO is done, so
> there is little chance that they would understand subtleties like this.

I think that even the experienced developers who know how to do IO
struggle to understand this sort of thing. Most kernel developers
run screaming from GUP before it drives them insane, too. :/

-Dave.
-- 
Dave Chinner
david@fromorbit.com

