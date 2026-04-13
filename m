Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0402FEBFD0F
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 08:10:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E98116B009D; Mon, 13 Apr 2026 04:10:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E70056B009E; Mon, 13 Apr 2026 04:10:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D86416B009F; Mon, 13 Apr 2026 04:10:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C38236B009D
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 04:10:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DB8CC140D3D
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 08:10:53 +0000 (UTC)
X-FDA: 84652811586.03.878D6CF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 970C2180011
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 08:10:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EyHF+G4v;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776067851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OaQMCi5HMfp/OHds/BFFbF3BJqhYWZNHL69rqmLc+L4=;
	b=K7ZRdSnOBA3S+yl4d0vmyAJO6BiIjzscSLy8kIv4tdYt9hPBkbHqPpWJfrGdswa4ZjPs9/
	eD6Tp6CAIRNEL2T8E1yG0kgPTrH6kg0SwP+YKgKhVQ5MeIb+AMUbt9fSm4twpv4DKVfM4I
	dPibNuKxC7E+5E52m+gHTvvqZjEA0MI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776067851; a=rsa-sha256;
	cv=none;
	b=AA6oaO6VIOv1A9/WjUyOY7ouO6ADUTpJelJLRzpCwCBad32VpFBzk6PJ5agz1JDiamdfT7
	zaztuLe0ic8T1gtQAJBTXCGPqRog1G4ok4a/ZwHXV6A6MEd0Sk6jg1GO8mmM6Om7NHIK0r
	R2SahPp37AUCsvFOoyrwKPuvCGm1OP0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EyHF+G4v;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776067850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OaQMCi5HMfp/OHds/BFFbF3BJqhYWZNHL69rqmLc+L4=;
	b=EyHF+G4vxGpkO42SPg7NHWccpRAUjG6tRxrwWeDz+sMSub4Ps8x7wEUrFASyMH9OB4yu3o
	jUEpXl7fJ4DL+AruR2Y+XQGxu9mp9s75aoNVr8Yj8kGsYt0aHzHmTlQft6T3/1DI6utSD5
	eBbzkSOv3oSTxYSAALXEdloiD4qi9pQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-343-QxJA7bwOOXKKagFLGZTecQ-1; Mon, 13 Apr 2026 04:10:49 -0400
X-MC-Unique: QxJA7bwOOXKKagFLGZTecQ-1
X-Mimecast-MFC-AGG-ID: QxJA7bwOOXKKagFLGZTecQ_1776067848
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-488c2aa6becso32343655e9.2
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 01:10:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776067848; x=1776672648;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OaQMCi5HMfp/OHds/BFFbF3BJqhYWZNHL69rqmLc+L4=;
        b=gHQ1ICwrCsVIBsts2m2lx6Aks/1vn7aOohf88+ztoeqTwFhtKrVwbe/g6M37osZxDt
         HHJfaDb7oH6beiJVzr14g1vLFjqhk6HqXxkLzuGbIhRGJWf8Q7MHG1njOliUHHdIeZu+
         Zhh4rToxu9HeQ3ipMEwAmOGAWXM8DAfWGgquEBNfJrPC0U0DSZRhRZwL8H2C/1t+L4/x
         HwoFV/YYPJ7BkjpenizjlD9Otq/oommyqVvhI18+I6xlB7HuSm0tuwX+SJna599yUrwC
         FYWof7lNyOChZnsDKmmqs0/e903yxgnhonXddh9etoODLGIr9UYPmMt+d4O9ZPrYTpR/
         H+9A==
X-Forwarded-Encrypted: i=1; AFNElJ/RdfSCVEypCezpAkQYd2DBB6qcHu0kA5L/pMwPANX8cOWUaquygHtHH2SZ5l4xLcxz0YDm5Jjzsg==@kvack.org
X-Gm-Message-State: AOJu0YxL3LLy9bwFBpSBGVsMn9o2PKw57q+m4v8+BCCwFGWxSwSXGBIU
	ostz8H7x8gtYWJixHxCTCLi1riZmUHnD4oa71RdGUxzj3TdjPHQaVbM9mxgAg3Ymwa/df2shOTn
	obXaQe2G6j0U2/wBtlEwZZP32oPgYgtoxPF5a2BUZSfpfUEVIz78Q
X-Gm-Gg: AeBDieu57oHNRF/CGtFkxJa+piaqoUZ80HMg4xosNRJM2+ZJG8i+2d2m+N37FJ8C6M3
	Tf/sd0CdCxfW/yk10hhRKzVkMQgiumqiXcOR4T92FqEdGn4sSBtqh4KwXApBcLRRBolU2kWAvQf
	5CqJPKQ53YuK9fZDgRwO4xac3asKHwofqtx0KcDRtZjHDrdoX6z3oEdwOyS7kijQ9vSs/Y8SHvk
	BGWECuc5Tu6CqPJRXq1sQadF+XR1T89LAsOazxra5QhIAtGhJenSybvyknJ0wzw7bzoo6Lwnk81
	S58/4Zj6+I7Ao3j71EjILgpxQ0lphgz21Ev0W3inlxKIuOXJ3vMj5IWXENOBwiGiJG5oS4xNriy
	3CePlj1NFK8XCNqoHab8KGJzR+7XkizCdipUTteenrOQ=
X-Received: by 2002:a05:600c:4715:b0:488:9e54:94c0 with SMTP id 5b1f17b1804b1-488d67e7dd4mr183038825e9.8.1776067848264;
        Mon, 13 Apr 2026 01:10:48 -0700 (PDT)
X-Received: by 2002:a05:600c:4715:b0:488:9e54:94c0 with SMTP id 5b1f17b1804b1-488d67e7dd4mr183038325e9.8.1776067847773;
        Mon, 13 Apr 2026 01:10:47 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d5344e28sm297869325e9.7.2026.04.13.01.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 01:10:47 -0700 (PDT)
Date: Mon, 13 Apr 2026 04:10:43 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH RFC 2/9] mm: page_reporting: skip redundant zeroing of
 host-zeroed reported pages
Message-ID: <20260413040143-mutt-send-email-mst@kernel.org>
References: <cover.1776033471.git.mst@redhat.com>
 <ea67e39bc3aea1b0b491908f851ffce25154cd26.1776033771.git.mst@redhat.com>
 <2155527a-e077-4b71-80ee-d735f9984f60@kernel.org>
MIME-Version: 1.0
In-Reply-To: <2155527a-e077-4b71-80ee-d735f9984f60@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0V59sFkbvJoJ_vfTnYzCiIIys22XKtxDjYAkbFRVByg_1776067848
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Stat-Signature: w47obtkwswmqa41mee4pfm917n5i5ai1
X-Rspamd-Queue-Id: 970C2180011
X-Rspam-User: 
X-HE-Tag: 1776067851-256161
X-HE-Meta: U2FsdGVkX1/d+r++KIlKNMnYsOsVzSQuOnHswXe+mMDLGy2zu3eF4sXdmNqS0y+0LViJgnT7mXkEIir1/b2Z65Ksrx3gTsaPM0qq/nERLHeYw2O93yGlFa6BAe8aDWAF/Yy5x2898ZOU2PQY/or5rHGZpFVLJyK2gSMZBtlaaZ4ty5fkvrwuVLeUBzGMbFYq2YRQwiq6R/jcTWStD8Wd4CVMS/K9pDfnTohRRiC7zvvGSPhPtZflijg/T9sYmYOBYe74Lo/3ISzmSxSAK+lmmWnGAe6YRstcabk/xqjtuaDPOdEjjfWHGxZvkpESd+BUu2RPNgxiqyN0lluLvf2/sa6KTnZLEU28lZtM8hsVxg/oMw7TP1Gfa6tJFXf1bniZEjVgzNotm/nCQ0+3rU7fjvscFqyPtglQDRkKKVYTHmxnKyinNuzyYJqEcgXI2RmC2DFqHIfAt/qiPE55dz8t5l1DmNwcdtQ4SORIRjU5bcMjCyCko5iuv/IuSlVOQHB0CTxVCr5ou8jT2OSOwUEFl4dByZh7f2xVIYYl33hRHdT6zpmKV4Vh40blQhqyjAC8wd8HMBvlEftEm8lpsM+B7NvFDlgPOHTEPCsjgBbURw3BWk4or56T5TMTRFNarFMWF+H04qjEtuSVka34ECom90rN1JW1QIP+MViV2B+YEb/sRJe6AskEUC6FUjHJTafQRujr8oKzQ74NzGZxTGqwpx7fgGw9dqP/w02cNCAsr2WxQlFkFL3YCO9p45jdtP9xw3rWTEIkF2eovAJg2AlBZ9f9vI5g+Pa+ERcELjb8nkrU/r4Rae6YjbD9eutCotef1J7VAxbeFwYCC45zTNRIqd+k4kTfnnjSizEpCm23n/tHb1c2WuzMyOB3xhxV1fNw9HhA6Ss1vdPkBZVAuXqVF/v+JP3/TfKNZVnJy3WBKQLjfsogdqkLCFxQIbw3iFpjGT4q5juPsgK6JqqZXjM
 FmlyR5Ee
 JY3jGfaLM4IvQHpEl/+0L2tpKDtmt9IgQla/F9jvJypECq36pDYG4gIiY5m5VkkXbpcfC2liCwSAHc+sajAruSv+EvzubOA0OpXV6pzA6+rjVc/Zify+Q631+w263meIcyecAfyYicTnbCYnpr1s5pnCiUiimbc7Ky3IDauK+UMYfq2qi0DgGwwP5asbwq0BrTugo0ddeN81StdLx8PpN7TpMxphSmvHaoEIjQ1PuGulmi734QVBpuOqN6eQHEGMet76CzSar5Y3loI5+lyrr+jDWoC72Xd9o8vMC6/+IpQDsrVO2L7CISo1nQ+yfRA9TKGTf91Y45CBAxiQvwjDn+nE8qelDmv76YEH39mbgtXG6P8ObhGkY8rssjWSExAUaTLCi9wWAn99efxGgw9ZksIx59g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 10:00:58AM +0200, David Hildenbrand (Arm) wrote:
> On 4/13/26 00:50, Michael S. Tsirkin wrote:
> > When a guest reports free pages to the hypervisor via the page reporting
> > framework (used by virtio-balloon and hv_balloon), the host typically
> > zeros those pages when reclaiming their backing memory.  However, when
> > those pages are later allocated in the guest, post_alloc_hook()
> > unconditionally zeros them again if __GFP_ZERO is set.  This
> > double-zeroing is wasteful, especially for large pages.
> > 
> > Avoid redundant zeroing by propagating the "host already zeroed this"
> > information through the allocation path:
> > 
> > 1. Add a host_zeroes_pages flag to page_reporting_dev_info, allowing
> >    drivers to declare that their host zeros reported pages on reclaim.
> >    A static key (page_reporting_host_zeroes) gates the fast path.
> > 
> > 2. In page_del_and_expand(), when the page was reported and the
> >    static key is enabled, stash a sentinel value (MAGIC_PAGE_ZEROED)
> >    in page->private.
> > 
> > 3. In post_alloc_hook(), check page->private for the sentinel.  If
> >    present and zeroing was requested (but not tag zeroing), skip
> >    kernel_init_pages().
> > 
> > In particular, __GFP_ZERO is used by the x86 arch override of
> > vma_alloc_zeroed_movable_folio.
> > 
> > No driver sets host_zeroes_pages yet; a follow-up patch to
> > virtio_balloon is needed to opt in.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Assisted-by: Claude:claude-opus-4-6
> > ---
> >  include/linux/mm.h             |  6 ++++++
> >  include/linux/page_reporting.h |  3 +++
> >  mm/page_alloc.c                | 21 +++++++++++++++++++++
> >  mm/page_reporting.c            |  9 +++++++++
> >  mm/page_reporting.h            |  2 ++
> >  5 files changed, 41 insertions(+)
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 5be3d8a8f806..59fc77c4c90e 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -4814,6 +4814,12 @@ static inline bool user_alloc_needs_zeroing(void)
> >  				   &init_on_alloc);
> >  }
> >  
> > +/*
> > + * Sentinel stored in page->private to indicate the page was pre-zeroed
> > + * by the hypervisor (via free page reporting).
> > + */
> > +#define MAGIC_PAGE_ZEROED	0x5A45524FU	/* ZERO */
> 
> Why are we not using another page flag that is yet unused for buddy pages?

Because we need to report the status *after* it left buddy.
And all flags are in use at that point.


> Using page->private for that, and exposing it to buddy users with the
> __GFP_PREZEROED flag (I hope we can avoid that) does not sound
> particularly elegant.

But propagating this all over mm does not sound too palatable, right?
There's precedent with MAGIC_HWPOISON already.
Better ideas? Thanks!

> Also, if we're going to remember that some pages in the buddy are
> pre-zeroed, it should better not be free-page-reporting specific.
> I'd assume ordinary inflating+deflating of the balloon would also end up
> with pre-zeroed pages. We'd just need a (mm/balloon.c -specific)
> interface to tell the buddy that the pages are zeroed.
> 

Indeed, it's also easily possible - it's a separate optimization, though.
Another simple enhancement is including hugetlbfs freelists in page
reporting.
Doesn't need to block this patchset though, right?

> 
> -- 
> Cheers,
> 
> David


