Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1D58C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:39:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF62C6B00E9; Tue, 28 Jul 2026 20:39:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA73D6B00EB; Tue, 28 Jul 2026 20:39:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C95B36B00EC; Tue, 28 Jul 2026 20:39:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE3816B00E9
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:39:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 378781A043C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:39:36 +0000 (UTC)
X-FDA: 85039955952.12.493CE39
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf21.hostedemail.com (Postfix) with ESMTP id 466B71C0009
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:39:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FW5qd2ZD;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hlDfDH8fw0HdMBSkD+M9GnJly9TjD4Ns9P6nYByTcGI=;
	b=Mq6C7WlE73o5hejzgnaZOPMd9tWZMtyCBi0VPHknB7RlUwlZ1FVr9DH8SFq0FIfTVHY3xE
	LVzD5Uta4+yU89pkQp4Yr3mR1o3XcrgHvfV+rf6vPds94zzeWAdnmd3+kGmTA/L23OooSU
	Ps1q2qlkCo8Sfy2bwYRLD6ns0gxEKeo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285574;
	b=iKBaLvTHwJXVY7FqcoV8tSg3+h+YM/xLxXyOXOcY+kWK9u8j5MHUAXbAbnz5J9plVRH6L6
	YLQ+FPewaiIu3LUdFczbNNzXbLoa+aGetrUbClIa3tmkRezxxYMOfh0fsjImWY70oniYBZ
	yjvLueXalzAjvHXf6OfZ+XBWDo/RYU0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=FW5qd2ZD;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8f1a8e914a9so3403056d6.1
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 17:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785285573; x=1785890373; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hlDfDH8fw0HdMBSkD+M9GnJly9TjD4Ns9P6nYByTcGI=;
        b=FW5qd2ZDMgrtItgOYU7wVqxaDjO5lCi+FQIXac0UQ4ZHJai+tNLXP+ob7K8BmFqYrU
         IDSMdeVPsbmdmPh9DhzwkGmtnZtC86TARWv1gWyWNiOaw0zFA3jAhjPkWSIKEKHK4Rfj
         EKl8be5CoU4dS1eevmzVKQej31QJOcvta2+xusfj9yQnOEhFjcVvN128IQ5D3oib5rXq
         LIX9FhxGczsbNVE3mu2b4MA4Zt2QuCxAFlnv8rG430YkxZA8RlUwhFcRW38eOJVcm+Vk
         ETcgxCxV3h6hJYmdQtx5sMmojrar/pqayg1H0cijxooWJEJvZWhJHhhL3aFx1P/FtqAa
         b52g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785285573; x=1785890373;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hlDfDH8fw0HdMBSkD+M9GnJly9TjD4Ns9P6nYByTcGI=;
        b=NYGsqIsjk8uR8Rfbnt1ZMfPjx0ueftj+gvLnzQ+iu/fXo51p6hspCuc9YkLUZPR1mi
         D5TRSfqakhrZk/j/qWRj5oGF7wVjfXD63v9tZ8F9+eNpEJQDFBMqoCuMPBP2b9XMtp7I
         cTdF/9c68+/SXlfSIgH4dsn7Cn6rkNnMNvgdQqHSUQxZDSFkVFRwQND9p+ambB1vgzrI
         Q13ST4TDF96iHLUHKnnje9UMxTzglgAxTWUSkU2wO5YbDAxNTagEz8Jw3IgGqCBZbXqn
         JHJK+lyvgQ60AXnTAdOdHDcIAzIGoxGIvHZgoA6qJd4VRimGfodc7AxPYaJTC/yKJ8MM
         YiBw==
X-Forwarded-Encrypted: i=1; AHgh+RruarkL3SqRANGGkctvNJHuEunLslp9jy5OwqwwKE3N3dIKKaAL7PxsVXYnaCw516YkBynH0mkDEg==@kvack.org
X-Gm-Message-State: AOJu0YwsE36VjLD7CxS/I0P0NaQEura8QQGkNQKY7s55T3d4iRG+5m4e
	mpkFXGz2rsR66TQIxjHwHLmRGZWeyFIc+EB1TcMOYFzSQProf3L//1ChTRKXglarAuDjU8VOaBl
	mNR90
X-Gm-Gg: AR+sD12mBW9GNHGjXXQLni1o/ixI1dxCN0rLF/AtFpcl/BKfKXj7oGPK2wRtPbF4k/r
	NDl7Ch6F4na7MX4ZlWaIPfKjTk4okAzzlTdPSbu7LOX44Z2b1Se1fTEruIL0tIMQQHMex0wBz7N
	liv1HfYQ1p6wGL16g6vn3MP14w5b6DE7pUPGAmTTKsTWf6YuWPW1GbqR4wGCYdTBqw6bOAjEQON
	UjhjYXGNwL8qAwChscC+ATyU6KGPjFXzCbBBgbhw9r8mczHoqauJO2514PNUcvdb919Cbf8uVCM
	9Fm9Tl5bqYFjykX811Urmjj9H9ij3qwIIV8LCpvcjwux6cBun4NqDmHVuMakHI2bL4BCSBL+UY4
	BO0n1ErkEyGWE1SYvh/lvycPLCFMZlfhi7XJAcfQhb9jj8dvCGgMax51NKByKrb0ER32JJAmK5x
	dTnZdq10l7o/9B/7bQGERqjXsIlaymeQ7BP524x67vCKQJmlr2nL3SDCNUgG32ePqDl9wdGPO/a
	mqXPNuP9amijEw+VHer5vT4i9KTAjX4Mo++HGHlCr/Pl91gKTvb5xca8n+wIEg3H+E=
X-Received: by 2002:a05:6214:4114:b0:8fd:6df3:b379 with SMTP id 6a1803df08f44-9081743d851mr51993906d6.61.1785285573375;
        Tue, 28 Jul 2026 17:39:33 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9081dd91080sm11772486d6.49.2026.07.28.17.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 17:39:32 -0700 (PDT)
Date: Tue, 28 Jul 2026 20:39:29 -0400
From: Gregory Price <gourry@gourry.net>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v7 01/13] memory-failure: Fix hardware poison check in
 unpoison_memory() again
Message-ID: <amlKHkemYQBxFESG@gourry-fedora-PF4VCD3F>
References: <20260728204409.3396238-1-willy@infradead.org>
 <20260728204409.3396238-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728204409.3396238-2-willy@infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 466B71C0009
X-Stat-Signature: oksqmew8s6ksead3kg446hk98p1816ci
X-HE-Tag: 1785285574-190557
X-HE-Meta: U2FsdGVkX18ZikdaNBuGpXnc/EzcFwhDkGOmMN/Y6N2E93Cz2D3VWLSw9eTgQ8pGQnuJFwfRowA9J1IPiMXnJPvF54DoNSHdY9F9nG7xFSCqxzZCe63Tm8OYqJHboEAA4eRoCD9M+5MMMt9CL2OVMiH28utB9DfpYPd0tZcrohDwXA+OUPXm/A1QfSRGbQMSDkHJR0Z5sOddeiups3PeieUsUq1oG7sIkW7GbJ+JR/Y2w9gx50d/DguEVCnOW3bfBfu5IfwFMXiaAbFS39UYwBsdk2vP4qNB8v864WHO+ypBuXukEoTzEq3/wsBCHUY99dgdjWlKxeMgwShB/bkvFiiZV/TXu9TDV7dE8iNfjDHqtBw87+eJudUmtCZI7W2+2PvBJ7gAhhnBQewE58l7hBH75n22Kfl/r723BKOb4X44V5cm+DCtey9p+RwgrVuI+1EVjyPFaGIODDnDoi942luKxE7xXFKAAoSM+fSIsURWJBL9aoPETQuiWqstSVuQ4t+NUkTPSyOB1OEty4CBWlJchpGFDf1PaBuyaUrrGmyg9Ih3eiM1Bn64NRh+2r9H/S6Va2AGv9ue3XT72xBN7lHNbkFV+SmXLXPsu8dF+Vw2Dtj5OzZYOHapypLjIoNDnC/Lu9Az/HJihaoSHZNHcLcRbJzW3k2TTrHeCvHbiRSZ4KfmGPVXjhfHFTlK/PWgbNjYHgqBU5vIyxAtf4uHSNCNvLytYOvAJHTP3ILzVK+v+mVbYwqC65F8rTFLS5X9jxQoekdO2pgdbgiDTR9+VOhuLilT++z5Zxd07OXHIYc8gg0jF7D7yVblwOOQsQ8uH0b2gHhYmCpEgFZQdWXKtEyz5t5iA3AuOXZi8guj7d+yZLOWtadbDa1SkQn3wvbIKdbP0JrSNDTa5uiNKmpBQjj+GVT8M3bHvJl+ku+fD7A5sxsQZsLP5449co8ReJ2CMFCqF1RqIYFj14yohHM
 JQzOs1vE
 lG50NHnMElJWOjXbb4vzN28o/+YZwNAipwYDENyYmCQrLNSjGoqYjBSSaXfxhLBR1oIgGd5hyLvLFtqGM6CI7nrZaAtThkGDs79d528q37hh/rckor7PIBtnS5nk8dpEi8a4XcHz6tGWOXpzlXCYxrkb43pyjWTfazHYd/JA3b/Q7j8Z2ML0F0yKSsTQ93eylPN9hZ6kOqK+GcTgn89RC9HoTHPNg9dIg7IhvdMMvRxnfU4eLhUWlJWao9FG2k+WvBiHi2jkicuSTeyZuqCzahpF/C3lLh4+HrCbG/gnxzBBl/YBdveFDqg+B61289bB8a4q4s0VAZiTauqQc+Xd0UntyYMRPka8z7Xi0hkz4fo6yyHUNtg5b8dJIdGQ2rzVwAAjgBlWwJ5l4nJQ34hpSAZmuqUyCBaoRtkFVIq6+uhzTKAG3n4E021BF7WMDClFVgz+JEQy2epKC+AVLXnY2mcwTXf14r3e3xRWFp58mvYcgaYdCg4tUEDJIVjlBL3bv15kHE3SRnjAVTsuT3WVFMx5XTbAGiRETMhf/TQbhOpeXPW8bbfL778gAjXoIVPfagqGaNNU0RHHPATWkuLGaDY7zEEIepGL4+sNWmoQdAfELkl0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 09:43:53PM +0100, Matthew Wilcox (Oracle) wrote:
> The earlier patch (6c54312f9689) that attempted to fix unpoison_memory()
> was incorrect for hugetlb folios.  Before a6fddef49eef, we checked
> the head page for poison (which was correct for hugetlb and incorrect
> for THP).  We are currently incapable of unpoisoning pages (other than
> the first page) in a hugetlb folio.
> 
> Use is_page_hwpoison() which handles hugetlb pages sufficiently well for
> this purpose.  This is racy as we don't have a reference on the folio at
> this point, but fixing that properly requires deeper surgery and this
> is a CAP_SYS_ADMIN path only so this will do for the moment and can be
> easily backported.  It's no worse than the situation before a6fddef49eef.
> 
> The other bug in a6fddef49eef is that we currently clear the HWPoison
> flag on the precise page, which is wrong for hugetlb.  Fix that too.
> 
> Fixes: a6fddef49eef ("mm/memory-failure: convert unpoison_memory() to folios")
> Cc: stable@vger.kernel.org
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Just trying to wrap my head around the state before/after, assuming
the following is correct then LGTM:

prior:
   pfn_to_online_page(pfn) -> p = precise page
   PageHWPoison(page)      -> checks precise page. Poison for hugetlb
                              is only set only on the head, so bug.
after:
   is_page_hwpoison(page)  -> checks precise page AND head (if hugetlb)
   p = folio->page         -> now TestClearPageHWPoison() explicitly
                              clears the head page poison if hugetlb

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>


