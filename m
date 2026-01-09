Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C874D232EB
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 08:08:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE21C6B0088; Fri,  9 Jan 2026 03:08:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC04D6B0089; Fri,  9 Jan 2026 03:08:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A1B86B008A; Fri,  9 Jan 2026 03:08:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 85E746B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 03:08:23 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 104F2B8965
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:08:23 +0000 (UTC)
X-FDA: 84311698086.10.6A0775D
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2F12840009
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 08:08:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OWrg74Je;
	spf=pass (imf07.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767946101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qpHrGhMAzP5cZ/pwyDMDFj8ircdSPNgtbyAQqaGMd28=;
	b=HXgGACZbaeWPFa1O4HDvenRv7i4Ukw1DXfNN8SXx63eCiauyI2H1Zpxtw7AQZ51U65szcu
	pDkM27usPXWTR8/kpML6+05VyhNUt6GgxYjTncxdsZs6NUqMkr5UIUQ07J94HLjKXhzKXd
	fvjJl4EYajY9Sits+dREKOkB8ecV7rU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OWrg74Je;
	spf=pass (imf07.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767946101; a=rsa-sha256;
	cv=none;
	b=Ye+in6GXFGej33utDydkqygoEgosWFp/Fqcf8CGG7XhvD1C/wbDnzsNBn7j/43TTmFkWuV
	4UWKieZxrRM9Q276Sjc7nS8e6iZQdKYDBkBpy4+2mWCLzyopfa+FgnJjXw9IHHI5QPeNdt
	ajruUhn1hwgpvemgjN5D6XMZYKJBa9Y=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-bde0f62464cso1998001a12.2
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 00:08:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767946100; x=1768550900; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qpHrGhMAzP5cZ/pwyDMDFj8ircdSPNgtbyAQqaGMd28=;
        b=OWrg74Je8kIUw0qZAPwpSktfqrdigjVNRpccbqLOfsketca/4lkoeyKwPYwzqLwvmq
         gGrpuaPiFcrQ8//wB1h0EpQNT3wEWD+87NKB691OjFsEXeJBuQHmTdvDc9IVhTDcdFZe
         FmN9GmHCl/udM13yYwBsY2Ydsxkcw5MG0ASaDl96USUI+Y1ShUOy/1EDp7HWcbH44IyT
         jAE00vDm9UP49R4aCOHjDS5xZHsOsOlfk3euuqsMvpQmBhh4eYhQq7WBgR3OTRuXt3Gm
         WxOf/dEM2Zk2Re8LvzNge4RpxbKuBS7lh11xQZngmOUZujDyi3herNz5tNPeTdhE4nzX
         PF7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767946100; x=1768550900;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qpHrGhMAzP5cZ/pwyDMDFj8ircdSPNgtbyAQqaGMd28=;
        b=r+Ifn5sHewv3vAbN9TWA/ksE0Uvn9JjV2FsC2kkvFolMM1GkezJLkhfcKs6bp5BD3Z
         vke8wndyKdx85+Zn9OydCGUJ916Fk3l8jb3tiAVpcstTXS6Vt/dvi4oH2631U9wszez9
         Ylc86rmmLvANwu1LcCByiY0IWB6tjfk05TBiHvx7hfeDJloFzM4xvl16Fqa4EnQDUukI
         vX+YG5Gw4empjujmNLLXH/ZYTeN6olSeHztsOXIba9z2Y6zx5ys77BCGGSxctedixOv/
         sLTsjtXR5QoFL4YdUNc/eUb5ePgMYkxEBekQQGKV7Ma/fS5eyUcqSS9Dh4Y10malck6I
         I5rg==
X-Forwarded-Encrypted: i=1; AJvYcCWQjhYzjbodwW/YJ9yGGZ093gIrHCpVtkhjtjuaYQPVWoWRX7K71G0ZzfLyQ5/d2Sne6154pO8L2A==@kvack.org
X-Gm-Message-State: AOJu0YyqtXQsvzhcXj4XPHBNoQNOk4+cGzwokE0Mj47RDuwoWBMn9Pe+
	6tW0MB0fa0G5RK36Hs+HwJwYsL4TI+MpOixnGPRdM1jgy/kQitL3sgdr
X-Gm-Gg: AY/fxX61eOmeStIuNmlfOfNnPvSndLo1z+rcNDXgaf8eJYJl2sKinZ19boxCAxWUrTr
	CtI2TU/0BituL0T51l0sxRhH2VoCL3mxHZZ5Zvf86mwOwRIrzUcoWrfxWnsX362e1N7zSGi3cEY
	KSVNSINS2FNiGuGupPc7+UcanCUkPIEyl+XnP0OyEU/R2Sxxbg8v7rQGuNLT3rHrA33sCsK+jmc
	zEe/GWoIQXtWlJH8uw0vovWdLQYX0oGwvk3gcUWOOUVzp/68kKTufg0h3SDgYc+szCQvrGHhxhV
	P5zPpZAgOzafDIQ0d0wCNP58cwkmM1wjUfSLBuSPCmpR4Tqa+cgSypIxv/rRdqh97HOyY7QYZjR
	fTngB7MgMyGiof1UCWY51wWyd2LORqxwuNZIg2uQhcYUrdQIPcOckPx+LfZPvJLn1oJuAjrCT1b
	ST+QQ=
X-Google-Smtp-Source: AGHT+IHLsrX/ZJegdYBv464UAGUVk+R0PGOxDzqPUVHf8M+cVk3HCEFoQ0UpsEjquRvIdlE4srvO5w==
X-Received: by 2002:a17:90b:568d:b0:34c:4c6e:beb3 with SMTP id 98e67ed59e1d1-34f68c00199mr8920162a91.18.1767946099887;
        Fri, 09 Jan 2026 00:08:19 -0800 (PST)
Received: from localhost ([2a12:a304:100::105b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f6b95a081sm2513700a91.11.2026.01.09.00.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jan 2026 00:08:19 -0800 (PST)
Date: Fri, 9 Jan 2026 16:08:15 +0800
From: Jinchao Wang <wangjinchao600@gmail.com>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/migrate: fix hugetlbfs deadlock by respecting lock
 ordering
Message-ID: <aWC3Y2lOoVaN3NBB@ndev>
References: <20260109034723.1342798-1-wangjinchao600@gmail.com>
 <87secfqok7.fsf@DESKTOP-5N7EMDA>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87secfqok7.fsf@DESKTOP-5N7EMDA>
X-Rspam-User: 
X-Stat-Signature: k6yofrx1rr87y8wra74zy9f39jbbaj9j
X-Rspamd-Queue-Id: 2F12840009
X-Rspamd-Server: rspam04
X-HE-Tag: 1767946101-569736
X-HE-Meta: U2FsdGVkX1+QxEVxxumhGz6kx07OffWjQvRHIaRewbmdArsePcUGE9zc431uibM1h3MlK2m83a1Nq8Q9zLWjCv3tQhYjysxM9g4oHQDDBnCUeZqTzEbq0dMAPRL/kbH9avDhWF3b32aqi5yG5gk/NR3GO5j6Vpo4TgrRFj+tYU5fOtKv61D9A4HnWhia6JEfro8eg/gbVAxiJlsF+8dLBqJtN6HJTujxw+e/yLAeoObviMIA0fELxz5woxJgMFGxor90JcApq3obAamgv6JE83et7eJfMvOAgF5odNZyKzmi2rWJ/ezE32fvNUWpf63NHIyYBk5FkFWJ8xrUb4HCl/TXyqs+nwh4+NWKWPBgW6Xg3F8azY1SnNHOImktXFbnVsxeC1N/YkXduZYMN5iqGQ8vSFzW10XmtltZtsMjJ49DsTqHWpwJcaHrwxSQAskV8cpzMVppqTQ//FjBdSBMvokeTVhsDfNG3YpOzQgjDj3EUg7MXBpAqbHDb/ZL0AUOMG57qsOTD4o7a6yOW4fhWDxOlgj+yLhr/KLhqIN71sG26B7Lflc0exGuMvX8s4wB1YFXMdA+wAsO96oMawcEZfXVqY0ABICf9Fcfw3kWDQi9xPBwQk5K89M7of6S3mExTNSYqeUw7jp5DJg/8QVQaX7o638aVTgBMEPQ0txxGMxhqUotrI0/iOv2of7l4/gmDniYkvgJkWOvUiXDXGXU3wjR5E7c1yG2zskE7phb2stG1S8z6lc4icGQDFCQetbW7MwPl+8jfTbHPxI0AGgRBKN1wWTM/+6BuT6/xGdhQmKDri9sGerA+7iBr0SNVN9RgAxUaP3jR6wOYrDKS948FEf/Izy3q2SHKMkmDPyau4l8BfjhsOuqszXgKUOWxE1g5nzpGFwhW6pQ8isdcQmTU4EiJb3GX0qtpjUggLI8BYM1PEauZ8jpT6M4uF0+Hcdt+lOiqMUd5Tjy69Iu+T0
 bb8eQ+/4
 +C3mud4e+ARws/BJio8UiT8Z3tHuL0t7/0oEnANdxRc/aefH1pU2o5DRdhIc1Z6FkPVAHMEQGt6Ytklruj9gQfc86+s2z8evxJq7+mX98TnqDcVI97HZlaVcmH0xI9L0dQDOHJham1/Z0pliddMvzOa4O+8GqI1BTFtZJiosmK515yhha8W6YOgF9eOveyvbOWGVQBPiJGqH6VRxCC5U1qqsA+YL8DQtnDL/rJvkBqukNbnBupsiw/TbGiLsyFbPJVbNl91JtJdXJ1Oy6+cdnkMsnWiWALnotSrNu1q2t32CxfmnfiErX4wD1Ob0UTUmk/rPrFuW7iVPmW9lPoxNmHtYJR/Sr2E9TFSZdCxNxNGdZjQd/tifVgQIOgnDY/TFJ8GYgCBlnSmCQ6f9NnUfldNYAmF7G54HFUj8Pny9z/h1fUpcvJAazs24HyFimsn7TZJ7nC3QSm4/RF0KMySt7OUq8g8QVUTWMqp611MMLqDMeBtDG8z8c+UuGPhIcIzpjfmFUGeiZ2NqsNWa0i8M5rxtV8YU9UNZeybbbGPfqRv3LXnu8I7ntuyIbOlbzUHouVwu2snC8LXJYvOXAe+EY7YYXBn/f9NDWz7d5ICbO2c2i5f5lXsiuh5SOXsRur2D7RlO2MhepAKy6caY3yttUWVEinRn7WQ62KMRwa6Y3yPPOuPOAFKnARDoYAnpbUAN40RjWfqT+FxAT1HFg4cN/9NPg79RjKkWF30VryhZ0I5ksoDmbmXQbxy4xOYQXB+yCvVT3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 02:37:28PM +0800, Huang, Ying wrote:
> Jinchao Wang <wangjinchao600@gmail.com> writes:
> 
> > Fix an AB-BA deadlock between hugetlbfs_punch_hole() and page migration.
> >
> > The deadlock occurs because migration violates the lock ordering defined
> > in mm/rmap.c for hugetlbfs:
> >
> >   * hugetlbfs PageHuge() take locks in this order:
> >   * hugetlb_fault_mutex
> >   * vma_lock
> >   * mapping->i_mmap_rwsem
> >   * folio_lock
> >
> > The following trace illustrates the inversion:
> >
> > Task A (punch_hole):             Task B (migration):
> > --------------------             -------------------
> > 1. i_mmap_lock_write(mapping)    1. folio_lock(folio)
> > 2. folio_lock(folio)             2. i_mmap_lock_read(mapping)
> >    (blocks waiting for B)           (blocks waiting for A)
> >
> > Task A is blocked in the punch-hole path:
> >   hugetlbfs_fallocate
> >     hugetlbfs_punch_hole
> >       hugetlbfs_zero_partial_page
> >         folio_lock
> >
> > Task B is blocked in the migration path:
> >   migrate_pages
> >     unmap_and_move_huge_page
> >       remove_migration_ptes
> >         __rmap_walk_file
> >           i_mmap_lock_read
> >
> > To fix this, adjust unmap_and_move_huge_page() to respect the established
> > hierarchy. If i_mmap_rwsem is acquired during try_to_migrate(), hold it
> > until remove_migration_ptes() completes.
> >
> > This utilizes the existing retry logic, which unlocks the folio and
> > returns -EAGAIN if hugetlb_folio_mapping_lock_write() fails.
> >
> > Link: https://lore.kernel.org/all/68e9715a.050a0220.1186a4.000d.GAE@google.com/
> > Link: https://lore.kernel.org/all/20260108123957.1123502-2-wangjinchao600@gmail.com
> > Reported-by: syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com
> > Suggested-by: Matthew Wilcox <willy@infradead.org>
> > Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
> 
> Can you provide a "Fixes:" tag?  That is helpful for backporting the bug
> fix.

Thanks for the suggestion. 
The deadlock appears to be caused by a violation of the lock ordering 
introduced in commit 336bf30eb765 ("hugetlbfs: fix anon huge page migration 
race"). Although commit 68d32527d340 ("hugetlbfs: zero partial pages during 
fallocate hole punch") was the one that first triggered the crash, 
I believe the 336bf30eb765 commit is the root cause.

I will add the following tag to v2:
Fixes: 336bf30eb765 ("hugetlbfs: fix anon huge page migration race")
> 
> ---
> Best Regards,
> Huang, Ying

