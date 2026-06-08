Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5283CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 20:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 169316B0005; Mon,  8 Jun 2026 16:18:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 119D46B0088; Mon,  8 Jun 2026 16:18:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFC206B008A; Mon,  8 Jun 2026 16:18:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E0C286B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:18:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 89282163A90
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:18:08 +0000 (UTC)
X-FDA: 84857857056.09.E13F86F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3EC0310000E
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:18:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WFf0GFEC;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780949886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vroj8FPw/hBBf0mVIETR1AI/cdAWI1hHo3K6Dubb1Jo=;
	b=NGK6k/I/D3KBi8Qa4JL9zaoBTu4Pbarmy7mcwxczgnCz8NH1q2GX9WXs+q4/7EFKoR+eTR
	7e7xsOtOhRvIT8MYqfzvL+3uWJkmlieD7UAjnOPi5skTDbH5PUD8hWhHbpqEMdLIgrwtSE
	Vb2lWV7ZQK8rQf/08ATnhDW7ypHRd3I=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WFf0GFEC;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780949886;
	b=Fist1H1kggR/2nG7Qn+qMSPinJsTowxms3EKESZipePdncXK53wVswpkzRE1uC59IJK0g+
	ICoahzPOdDmDp7TdWY5z0r5iqD1bNKBcMLfzrYdQB7FiHCLNyyiEVK9nwC61QyyNBgYaoA
	iGmv7/gcigs6IAnjdPxUPlITMmYcayI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780949885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vroj8FPw/hBBf0mVIETR1AI/cdAWI1hHo3K6Dubb1Jo=;
	b=WFf0GFECBCt1sFCmwQMwOPTyR9ey345ISMKMvWyRTxtwcJJ2TEiHKCY1OvW0Xb2veuXjxD
	1qnAldiMZbNUD/LOPTNAkY4DvJz5EDvNXb5JOyPHiXxE/A0wSL6/2R8FW5g6vWGjQcM0/y
	a6MddeFz3BphRTlrUEnwChvDnfJu7Os=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-jTwqitmVMhS6U2pggMDUvw-1; Mon, 08 Jun 2026 16:17:57 -0400
X-MC-Unique: jTwqitmVMhS6U2pggMDUvw-1
X-Mimecast-MFC-AGG-ID: jTwqitmVMhS6U2pggMDUvw_1780949876
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-490b79e6b94so33783945e9.2
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 13:17:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780949876; x=1781554676;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vroj8FPw/hBBf0mVIETR1AI/cdAWI1hHo3K6Dubb1Jo=;
        b=SeHFaLmpFWC4ULJpnS/Eyj/IYWwaorGEEvmrhmh7r4iqyEh/Q5tDbabnyhqDIf2kC9
         hlx0thplYWtbuOOvJSHN2QKKuRGB1zNLzMJVA5nWkm+LvEK6IePRjSWW0ZJiaEIs4Wyf
         VTOWWl1NRrGaDA56K+Ke0ha9u4ky8+tqqZQfUp9htEZBvSC17nWYgOydGiBu3J6lAV2i
         YNWGDhLHAmOq8dVUQni9Hr27XD9NL1/ffb1esF8Fd2QAh+7pPDNeQxhedO8h9Ex93Bw2
         rQeRv2vI0IHNw3a9lDFNfBnc31RSeLU1b3GaSE8cwW2sbNy+mCjx6LWierCgD1YJTbk1
         1cSg==
X-Forwarded-Encrypted: i=1; AFNElJ+sUsXRYENqBMcShz8Le00Hx9LldBUYpxnkIm0z3w6g8l5bgRscONE4oyM5XcWS4OQtt+MP64TuQg==@kvack.org
X-Gm-Message-State: AOJu0YyGwnGpUZeRVA50kRJe3O9PXZsog9blTCcnUeJ++3Wvu2o9DNxQ
	eYK4L5p/uoeE5dvoiUY9wyisSo3mrh6Cu1MCrS4e53B7lkZ55HiKdOmDPcnzKvu5iNsvSTrrT8o
	KPDluMRDV0O1iSqupJjelayl9Y9MeGXjCa2ROwNcdkJFvqH/MeNof
X-Gm-Gg: Acq92OGVtHNn/1ddjLfp1ISKcIuCJ4Q5b1Li+ITqr6VikPK+O2YchkatnmR7GIdxhyK
	R5fERijHEAn/R6Jb1k4/U+yTRmGBzdgz08Fl9juL+cIcXO03jxZKSeDgqJizPmLIKzJhJ1rU+i8
	y9Lx8+gXWeTAZkfNmApu45dXWjYGB3ILRAyBuutXCdZkfvivJ4NlvNA/GxW4ZYGlNjv3BR+Cj+I
	7GyOB/U9Mc3GPZnknVba/+51bA+MNR6/KOO9k6UZ6Cpc6HIzKmKvGkrpUoLwky42JZ6yQfW9r9l
	A6u7keapCfRLexRlgc3Wu1D+pWPco7/AYlvUMYhjpdC69Fz4Z37YOoPVQzq0CCxXz2Aw4aby/rX
	0Avrta3rcfLnFGQhAW0gy3enBovbyHgXQ0P2N6ftrAGT6ofbW2usUiA==
X-Received: by 2002:a05:600c:8b6e:b0:490:b7a2:8864 with SMTP id 5b1f17b1804b1-490c25237e4mr294515785e9.0.1780949875698;
        Mon, 08 Jun 2026 13:17:55 -0700 (PDT)
X-Received: by 2002:a05:600c:8b6e:b0:490:b7a2:8864 with SMTP id 5b1f17b1804b1-490c25237e4mr294515045e9.0.1780949875120;
        Mon, 08 Jun 2026 13:17:55 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490c2d37edbsm327199975e9.2.2026.06.08.13.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 13:17:54 -0700 (PDT)
Date: Mon, 8 Jun 2026 16:17:49 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>
Subject: Re: [PATCH v10 02/37] mm: memory-failure: serialize
 TestSetPageHWPoison with zone->lock
Message-ID: <20260608160954-mutt-send-email-mst@kernel.org>
References: <cover.1780906288.git.mst@redhat.com>
 <df06b66fe4ff8e925ee0714955abc2183a727b90.1780906288.git.mst@redhat.com>
 <aiaOZoa2vSCz_0wY@lucifer>
 <20260608094153-mutt-send-email-mst@kernel.org>
 <aibMs9DXuhH_5F2Z@lucifer>
MIME-Version: 1.0
In-Reply-To: <aibMs9DXuhH_5F2Z@lucifer>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0e8oLuZTVw7AaFBpWWcj7hYFv8GsRxDwE0s7EGB9ems_1780949876
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3EC0310000E
X-Stat-Signature: m5585t83jbh7zwncau8ji3bu6fd9nhmb
X-Rspam-User: 
X-HE-Tag: 1780949886-305042
X-HE-Meta: U2FsdGVkX19pnoT+CP/ooFJlRQ7FECCMaebx0/R0dol3ByAn3J7n7wc2X8y6XexkDG3dpwEgQpn2w6aVvTYPtaj4RB9VNSMxheWvjTn3T1jsHg8edLjmE7VAdgok8G2R75oE8cegPR4S3KPmwrQ/ATv2+nLgzIxYpJ10sxWsw/E3Dze698AFZUy0j6khbRTqkQHl4FJndOELaGhW9y4L5/L6ogqS1tTSKJvCccKrU0yWFQpmkLvDzVEkAt+6qRgICgzgf4PKUWvWqhRCJhLHTqK1dQ9Lj4wLwa3TVhdawPCPk365nBT4g3hp5zj2N8yWQTVOLPCHNHcZSRS+LBnoDdCneM4mzUFDvT4GAvHUyEJpN6hXhdHEFzX3P3Y7BchxSPd5kxDKeEi3DJdYFeXHsXeqU049PAnN14T7Gc7mNc0g8jeG5L+xlBY2Ce7CrmsviGzRGhcFWrnye2zbQjYDvayLs4VHdVHI72Q+QC0ccNRPtMd33hQc1eE3Ans4wBi5UZUwaqMXNUemcJgHW3k+jgHOaBN/ke6Jns/wmFWGuoAKQgPDpEq7vjDe9N0wCwlRlZ/ScCTnFuS+z0bVY+MBG5I10MRlhA3gD9Ow+GAbj3HdOSlKvP3/2l5yKjIyrNoNbYiVVV/pwwqXQgMp8u3ovMbCDtRzfC4hbOySseStz7y5ArEjEsHRmLSjFPMzT3xIRHCuyCkcozcbkfAOMlHg7XCX+qf9F7hcPfpv0UCC+W1aOMB9kpV1WPdyp3jP8L/eUr0+uRV83zxOHHFhlipQVpytJ9BOcOLOySxOd9mmcj2Xa7gkA4jjRqLItGhokwiTUFWlzbAYmynvQ32fDngUtoEQc60ThXrZfY3IDeXoRHtblvfFv+OGXCNjpOq+u8OhToOw2XgBVVqUR3VQf+Ww3z3jcNmMJt0VNQwf9bBMrP+h40/59ffIRxjx2zfedegkjpN+o5wpyYTqBC2OdrN
 WCADyuGf
 PQEO2ALFSBjfFF7CSzgQUXAk0+Lb4HCjVNp7pkD6v2sJlPephHyEI8FAz9pTOt44S33R3asqjDdrFMfRn7CmhSYZK/3WbFUwHQZD4kUz7g0r0vOSEGoTLCFz/GwQFPByiAIacA90tABpkU+NRfQQBh7XViOkT9anmNXc94wOpDmvKoiY1RvH9CyM1LZCNin11wWvl+ASelZXTxcLjhQ8fz9ICsIJSriI5g7w0o1FI3ICov8a4xWNOqdJiSYWVqjK+X1jts2xzFcrlOB0h38tNN0tKYC1OgjRZWd2Ec5sPf2DHBxR6ltAB4eQSGsX3DpihM/G5aswQpnDN2tdTzYe3oCnMTWMQIGtyXQa092Yvvo40PpJUs/+QQOkRUP9qTay7UUu8PJnHo2bTFMBqfBabN7U/2O2WLzqqudaiK8Avpnf9MgMTIFaVrRHTkXW34rg+7Q1CTCaVZUs6S4ChrWmw+E1dFD60rl/JBbitLEeKwiy1OG3EMSUWTS6onCOyLHi7XN11
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 03:14:51PM +0100, Lorenzo Stoakes wrote:
> On Mon, Jun 08, 2026 at 09:48:34AM -0400, Michael S. Tsirkin wrote:
> > On Mon, Jun 08, 2026 at 10:43:21AM +0100, Lorenzo Stoakes wrote:
> > > On Mon, Jun 08, 2026 at 04:34:23AM -0400, Michael S. Tsirkin wrote:
> > > > TestSetPageHWPoison() is called without zone->lock, so its atomic
> > > > update to page->flags can race with non-atomic flag operations
> > > > that run under zone->lock in the buddy allocator.
> > > >
> > > > In particular, __free_pages_prepare() does:
> > > >
> > > >     page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> > > >
> > > > This non-atomic read-modify-write, while correctly excluding
> > > > __PG_HWPOISON from the mask, can still lose a concurrent
> > > > TestSetPageHWPoison if the read happens before the poison bit
> > > > is set and the write happens after.  Follow-up patches in this
> > > > series add similar non-atomic flag operations as well.
> > > >
> > > > Fix by acquiring zone->lock around TestSetPageHWPoison and
> > > > around ClearPageHWPoison in the retry path.  This
> > > > serializes with all buddy flag manipulation.  The cost is
> > > > negligible: one lock/unlock in an extremely rare path
> > > > (hardware memory errors).
> > > >
> > > > Note: SetPageHWPoison and TestClearPageHWPoison calls elsewhere
> > > > in this file operate on pages already removed from the buddy
> > > > allocator or on non-buddy pages (DAX, hugetlb), so they do not
> > > > need zone->lock protection.
> > > >
> > > > Acked-by: Miaohe Lin <linmiaohe@huawei.com>
> > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > >
> > > Can we have Fixes: and Cc: stable and also send this separately please?
> > >
> > > These patches seem like unrelated fixups that you've discovered along the way,
> > > and don't belong as part of the already rather large series, unless I'm missing
> > > something here.
> > >
> > > Thanks, Lorenzo
> >
> > I think you are mising that they are a dependency, not unrelated.
> 
> Then say so.
> 
> > For example, this issue gets worse with the patchset as there are more
> > places that manipulate flags without atomics. No?
> 
> It's your job to make that case, not mine.
> 
> >
> >
> > You are welcome to send this to stable, but I think stable rules
> > preclude theoretical bugfixes.
> 
> It's a dependency but also theoretical?

As in, the race is exteremely hard to trigger and I have no idea if it
triggers for anyone, but it's obvious from reading the code that
theoretically it exists? Yes.

> >
> > As for Fixes: the issue has been there for decades. I wouldn't know
> > what to attribute it for.
> 
> Again, your job.

Alright, if you insist:

Fixes: 6a46079cf57a ("HWPOISON: The high level memory error handler in the VM v7")

now everyone running 2.6 kernels will backport this fix, I presume.


> >
> >
> > I guess I could send these separately, too, why not. Not sure
> > what this accomplishes, but hey.  But is that an ack? You want
> > this fix merged even before the feature?
> 
> I already made the case as to why, as have other maintainers.
> 
> If you need to review what an ack looks like please consult
> https://docs.kernel.org/process/5.Posting.html
> 
> Thanks, Lorenzo

I am merely asking if you want this patch in the set including
all these nits I had to fix.

-- 
MST


