Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86F5FCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 16:38:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3E548E0008; Mon, 22 Sep 2025 12:38:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE9288E0001; Mon, 22 Sep 2025 12:38:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B0AB8E0008; Mon, 22 Sep 2025 12:38:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 84FC98E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 12:38:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 41F9F84340
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 16:38:25 +0000 (UTC)
X-FDA: 83917444170.20.82B82C0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id BDC64C000A
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 16:38:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XsBaV1+T;
	spf=pass (imf22.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758559102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kRPJicGQTdnr4fyUdWpU6gJMxGkHyZtedzSbJu7STr0=;
	b=OjsTXI+WtQ1+tP8o82OiKd7ErkmlTPHYZIO93v8mu2hofeNPSnqJpL95BEibHaJxW76Rqm
	nkbbwBFDorC3YTeOMTdAWztkbGZdUZ4Zbo94VdxC1pjEP0dgLebaijdiquzAAk2iGNzTDP
	4CvrJH+u6UAd60MUZHYTVyotJigL5Vg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758559102; a=rsa-sha256;
	cv=none;
	b=MCXYBHNdx6SeU7ncVVcRzp3OJw1RCdGBmNM0lJ++omzN83Itlpjsdvxcf/OxK6CYyMkGnU
	Uf9q1kDWl0uHWHEQhxcKU3PlWmsczf29t9tkBgKveytyc1aEzD8rO65uHYu+hvvKfb3BDZ
	Oh8FP/syapQeTGUUi3iDHq8FRBS/Bv0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XsBaV1+T;
	spf=pass (imf22.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758559102;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kRPJicGQTdnr4fyUdWpU6gJMxGkHyZtedzSbJu7STr0=;
	b=XsBaV1+T1LPypvZYJSa61EcgUWWmkfZm9xinR/KW/Scnsu/WK5ZbwPUqENytfNl00mYQ6R
	eBSTx6ZVZYyhQbTUh2XVGpnKrn0oKh4KUZ/735o6Px2rosdiG4qDg1ttciQhPcThxLGF0C
	0/LQJqWwNqjlzpLeg5U1h8IPPHuXR9M=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-hM-SbyEXOByHNfoAML068Q-1; Mon, 22 Sep 2025 12:38:16 -0400
X-MC-Unique: hM-SbyEXOByHNfoAML068Q-1
X-Mimecast-MFC-AGG-ID: hM-SbyEXOByHNfoAML068Q_1758559096
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-81b8d38504fso252036685a.3
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:38:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758559096; x=1759163896;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kRPJicGQTdnr4fyUdWpU6gJMxGkHyZtedzSbJu7STr0=;
        b=sfJ+XKfyGNuDzm3MMaGIySL2USsR7kB8Uv0f31IpbKyBTuc1CeoFPMhjQ5EMLAt+HV
         jVH5jgbw/UW6wUn1bNbyQFArE3Q26dry31HSDis8S6BJWdm1dgzFSywC0TqA82BzDKIt
         wnDDa/wDyCd71WFos929sCJKzkyUgoYh2hdwRNNFp1Tgmt1SgGlrTBmAzQ6qshMErvmZ
         rs584Lc5UY/4Z89SO13DoZ3S2z0TV8kEFwJA+nbLOEDIzgF/FcTnxqBTjUnaYfGQL1kW
         O6ysNYcQfsDQK8iDBtcLAHlx1IecWxUThTS02hTcCGcWgRZvMGxmE3HKZmgEWhEqc7VH
         e1lQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdc0n0Kvoj6V3cFAiuCGjK9puVlM9thMd8ibG508Sw3hQkWDTGHCmHAECnbOwbx2L+DKFfiRIC+Q==@kvack.org
X-Gm-Message-State: AOJu0YxwxZxtDKB9jddzeAka4TINRrEU490s2JU75EyVTlxMPh/hPi5G
	3awP7UXYE0l4rRNxnG6r/LoQVhAeg9Zl8i6Hn1BAfE7Js5LzuadpU2aG2p3xVYYmmO83XhYgZEr
	IO42R62ZL/owwfa46fBBZ8byl2qD3kuQ0jJivyKPLEMgM7PawwN9A
X-Gm-Gg: ASbGncsiRLQ00wLX9jsuJebziAQwH9UO+ert6s39Z/4epB9uFJXWVHuQJ+W09UpUr2m
	tRKwQthtOjm3TCyfuWAefyv/saDGgwZiOF5lEzgBLRXAsuXU9qshBJArM1rFfPo9WW2h+dcNVyM
	OfWveoam7Q19vA+ibxgRqtRWNbKx66t+ya/iyJA7n3V87EZm/dY3XR36I/PNqwsqYSkSvM1C/KQ
	3w3IlAOmT0qNvaIeXz7/lQaV4xG7RCGrNyK857iLtFHwl+o2tBdMxlGiy2eis9ZL2DrkNlEc1kp
	y3KjXcdc9AmyLnRVefWiWdaFjEj258Kg
X-Received: by 2002:a05:620a:2683:b0:84a:a019:cdf5 with SMTP id af79cd13be357-84aa019cf13mr485439385a.53.1758559095950;
        Mon, 22 Sep 2025 09:38:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFCS5EDF7ht5BQNo1OOpXMisltQt1vHiFGmi7H0nOcZkAtQZS0HfCi5gZJpE5Oi/8k95h7sgw==
X-Received: by 2002:a05:620a:2683:b0:84a:a019:cdf5 with SMTP id af79cd13be357-84aa019cf13mr485434985a.53.1758559095449;
        Mon, 22 Sep 2025 09:38:15 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-83631a7fc2fsm817022185a.54.2025.09.22.09.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 09:38:14 -0700 (PDT)
Date: Mon, 22 Sep 2025 12:38:13 -0400
From: Peter Xu <peterx@redhat.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
	Muchun Song <muchun.song@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>
Subject: Re: [PATCH v2 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <aNF7dT-YUccWygka@x1.local>
References: <982f4f94-f0bf-45dd-9003-081b76e57027@lucifer.local>
 <cda7c46b-c474-48f4-b703-e2f988470f3b@amazon.com>
 <aGVu1Isy-R9RszxW@kernel.org>
 <aGWMsfbayEco0j4R@x1.local>
 <aGbCbW7hUf3a2do2@kernel.org>
 <289eede1-d47d-49a2-b9b6-ff8050d84893@redhat.com>
 <aGfsaIIzHWfjcNFd@x1.local>
 <e7vr62s73dftijeveyg6lfgivctijz4qcar3teswjbuv6gog3k@4sbpuj35nbbh>
 <aMnAscxj_h42wOAC@x1.local>
 <oybstepupgh2s5lpwwk7scryem4mgk2t7wmkr5zhj7cz4da3bp@aylj2x6sgtap>
MIME-Version: 1.0
In-Reply-To: <oybstepupgh2s5lpwwk7scryem4mgk2t7wmkr5zhj7cz4da3bp@aylj2x6sgtap>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ShD6fKi_lbMksAHzHHUOm0GhvV1SpKLc0hhH_Ohlm2Y_1758559096
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Stat-Signature: 1y1eyg31tr78tyof536xykdpx9y6pwhm
X-Rspamd-Queue-Id: BDC64C000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758559102-609775
X-HE-Meta: U2FsdGVkX18gZgI4i3mPw8UgIa4ZfbqdT7zv/Lctw+/RyKYivw3j8h4yOYacy+76ApnNv1C5WCCVl127Plvw2PMAIQir/6yNYIH0+g5BH/9oUD6ysWt8YFTK625g6FnEzHXY4eY6itU+DQ05j5oOvuqo2MEGO8VdIMp83m15a+fXLtppWxyDJq5/96p2zzD4gDqpjNvBUeiNc6+2EpwSonjlUWRCuMMu/WwjTrl3urbbYmRdN+rOqLuM/z/3QE5C7L6m0RqzeBmS9+8L3aS74vHQanxoYxcRieHPUrgXdw2P3USnZrRTxIlXBLwc62TXDBTv2kDp75XQXP9c9JdioaXDDOslpGU2IKv9SHwy5sUQPTHcDtgDlRexTPRriJy1ealN2BlV3idxKvOKReadnTp1aAntYQCqXyooHF59NyXOqbmm4heRD+rqoILsS+TiNX502qkDYhw5WA+ikO5nYLSGDQ3VrtugBtHiCGrZ3gcwjc2sHECpipMJA/6mJ/RVTSs1IFF02oNZig11LhhiTVYreG4soKlcN+H7ShWgZ99l9QGKOA4S+YOE8itHdQsysu7j86Q4wE7jvig+Qdm4K32iXPqWkKujeC9jwjA9VSXlb41FP3hreFkpvddrjUqrF4YlkrUWmm+i+uD8ZpeqRKi4bbscux94EjM1uYB3dB5GBciQbdW1eyWtZFCxUye4ZuPEAdCNSrUZcbEGcTwV8Pru10cwMImZD3C23SXWJEHHaovwsu5bb5IFQHWzOexe3TzMA1ms+sV9IU1AXNVHqs7OkBfh6JG/4pONxRmvYP/nLSAdLspWxbYk0GOxqHQr7w+75rWCsQQkIqGl31M4fwI2HvW4J7Dz7mkXpp3NxyCyMenmo1xkotLiSFMKpmxnjdC5L61QYOkCnAJWxPivBm9IYuYy1wFzmp4FShMIpPV/IjjBoFF45RyI2FzxE0BzZT9ikeeH1t9/VnCxslm
 cw9Ze5bB
 5Xbxs9H2+a5zyG1KnWjpeugibF2MtW8sFTs3pDgWjxGFCc20HZbv5zCQQCMXn4Cb2mWDY3lOGaBJ0+uUCokOx7TTIDO9tJrz1A38pN/NQARCzq61cdOtkBVU095dYjnMeELWcEzlu3B1bRjaZWs5ydcMNu6kFbXQheDj0yeVK4yPJzh2zh/X12ZE8cJ1OgdaErLWmWs4KJjAKx62xw7xe/1V7Es/Jsdu0HdO9EqdOXPGx6nVXMP9L5IxSqZbYLMuxnEd8kTV/VXe9Yp6fmM8OJ3TMH7yg8rlzYp5w0OWDJS03stv5GrYCqTFttyxD5SVrGsHJ2BFhCLHi4qwdzO0e3+spKLpN+TPni+2VtJq+bCkcmyh44g6q/xknQkf7MTF6bNNGVqHZXoRno3cDWyYqY1ASIDIOFxKAqSgffwdBNqPGjhC3PQeB0X2R4NGjyxjnj+dt2ZuAAT7nV1xigcReeTEyT1jSiEcxDkMb8dyCyUZDDC+HUoXSixyeIM8mNnFmua33UvRPRMvz4MUfHMKAlzRBvqbWIiC+AAe1eq4Fx42xRzXYMnB9/XAtL0mK2aXsyGAmFeB6eb1PF+aYwK/S4BgHAvGqSDHdDcdIV2rtp098II8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 01:22:01PM -0400, Liam R. Howlett wrote:
> > > The shmem call already depends on the vma flags.. which it still does in
> > > your patch 4 here.  So you've replaced this:
> > > 
> > > if (!(dst_vma->vm_flags & VM_SHARED)) {
> > > ...
> > > } else {
> > >         shmem_mfill_atomic_pte()
> > > }
> > > 
> > > With...
> > > 
> > > if (!(dst_vma->vm_flags & VM_SHARED)) {
> > > ...
> > > } else {
> > > ...
> > >         uffd_ops->uffd_copy()
> > > }
> > 
> > I'm not 100% sure I get this comment.  It's intentional to depend on vma
> > flags here for shmem.  See Andrea's commit:
> > 
> > commit 5b51072e97d587186c2f5390c8c9c1fb7e179505
> > Author: Andrea Arcangeli <aarcange@redhat.com>
> > Date:   Fri Nov 30 14:09:28 2018 -0800
> > 
> >     userfaultfd: shmem: allocate anonymous memory for MAP_PRIVATE shmem
> > 
> > Are you suggesting we should merge it somehow?  I'd appreciate some
> > concrete example here if so.
> 
> What I am saying is that the containing function, mfill_atomic_pte(),
> should be absorbed into each memory type's ->uffd_copy(), at least
> partially.
> 
> Shouldn't each memory type do all the necessary checks in ->uffd_copy()?
> 
> To put it another way, no shared memory vma will enter the if()
> statement, so why are we checking if they need to?
> 
> So if the default uffd_copy() does the if (!shared) stuff, you can just
> call uffd_ops->uffd_copy() with out any check there, right?

IIUC this is the only piece of technical side of discussion that was not
addressed, so I'm replying explicitly to this one.  Please let me know if I
missed something else.

Here we need to keep MAP_PRIVATE separate and as a common code to
UFFDIO_COPY / ZEROCOPY.  It not only applies to shmem even if it was about
shmem only at that time when Andrea fixed this case, it was simply because
hugetlbfs was working fine via its separate path.

In general, shmem is the file system, and when it's mapped MAP_PRIVATE (and
even if it's called shmem) we should bypass page cache, hence uffd_copy()
shouldn't be used.  It should apply to other file systems too when
UFFDIO_COPY/ZEROCOPY will be implemented via ->uffd_copy().

However since we're not going to export ->uffd_copy() in the new version,
it's also out of the picture.

Thanks,

-- 
Peter Xu


