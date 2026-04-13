Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E050F531CD
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 20:37:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C99F56B00B2; Mon, 13 Apr 2026 16:37:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C71296B00B3; Mon, 13 Apr 2026 16:37:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B60C96B00B7; Mon, 13 Apr 2026 16:37:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A808E6B00B2
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:37:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 572B4E2F19
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:37:30 +0000 (UTC)
X-FDA: 84654693060.27.AB0C377
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id E99662000B
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:37:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CF2iE+nV;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776112648; a=rsa-sha256;
	cv=none;
	b=8EjeNcaWl+xW8crPHHvAuVa15X07PZiqpUfXgFpNoXVLTW9+/9fzHDVvPqyRYRMWkKgK0Z
	HWaUMCbeJ2llL3015pBxE5Z9SbuawSkIsX4lziBXZTMyf+Rrhzc3G9AR+Y5y1tMnDmA/KB
	2BSfxktOdWEjzyCOEbWgpLAe0lNJ4bg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CF2iE+nV;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776112648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x+jn9tzh7nhmbt6+qjsG4Y4k6+ZRmcZ6RnPQ8R+vTBg=;
	b=ecT1sjpASxgQ+qkA6jzZ7D3CMLtta0cRDFU3qrzI5e1EGeOKbuuMksJQCjtm74elSPFm1+
	x4dLay6qRfteu3C3IZiapreeI7c009pK7dxGRfrxsLuMod7KMF4Vnaqu+czPwX1aUGo8RT
	Ys5kRxVXBnyM7An/ouHaAN8EVFbl76Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776112647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=x+jn9tzh7nhmbt6+qjsG4Y4k6+ZRmcZ6RnPQ8R+vTBg=;
	b=CF2iE+nVTZ2Lu9t+YVRAOs7JGyGMmPMbUUXOsF/9f4ygjFvSQfkEPykAmTjwCYLUHOGe1R
	LgNAiwMB2eDM0iAjS3yt5KJ6b8/6xkmNEJCbhel8bl1oRPYJnUtOshHOX10Oe/MLvdTbGn
	kVB6jhwAYDa8gjeyARstK7yzx228c6Q=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-fcrUBAbiOMyEGip1FVyIww-1; Mon, 13 Apr 2026 16:37:25 -0400
X-MC-Unique: fcrUBAbiOMyEGip1FVyIww-1
X-Mimecast-MFC-AGG-ID: fcrUBAbiOMyEGip1FVyIww_1776112644
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-43d7757463eso703219f8f.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:37:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776112644; x=1776717444;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x+jn9tzh7nhmbt6+qjsG4Y4k6+ZRmcZ6RnPQ8R+vTBg=;
        b=Qadh00cO1MELHEX9b2hnEyRRa5ASybYqpDGN02qNLcEPHk1WVn5x4SV7ELbNUlOwvW
         Hp9CAh9CMNggVLSyeLdu2csSIM7PdO5RDRth0O4i9+5JUlyaaDt1hj+WGkd2c0Zbneqa
         h6hPgwifAnxDeVaYkVJxzShO1XMEnbdjJBTJPPQE2U/An2xOkmSHfEj+UHPFzsm2EzGm
         ps12bn/zjnF5S/YdIlpF7tE6zQQMEhw2qQ/IWy6hj29mumnx3OIe4sSkRSEyx3Ts6a9Z
         qreogSUCW2sUixTiLi3WfL7lzev/ukcdIj5ieYMgEEPxXlpn18VJLS/vWi8jA/4ffPiS
         zp2w==
X-Forwarded-Encrypted: i=1; AFNElJ+MtkQBV3GarQDY3v4fX/6uDR3G4LzLjV8Ye+LOmwiY0J8vr+C8LoYlarlyzFml/8HQUlOB2GhCKA==@kvack.org
X-Gm-Message-State: AOJu0YyAtEitfL1A0BpWVP2y/A5vUeJBuU9ax/1TdqdRi7V34Sv13H99
	Muvk9BJ4U0vUv3+zng4TVzeb8PGCokfDMqTrsKKhDO5T15BynyGB1AaApfmtaMzWNOfBJoBddwa
	YXR+IB5+rd6GpGXKw6w6Fw6IvwYDx8MpoTspyIB1RP3Dq8U3zLQoM
X-Gm-Gg: AeBDietixhiCKgt9w0Bsf0+AFj7o+MVE8aD3T6ejtALyIl+9A9YXdAQeq5hSUNfGBVO
	3fDUJTaY0zm4vOnM1fOHE+4WV4IG7UXecHyNrUfS2VFQkMjW3AmhJQdE6NYWgIVPBYlgk+YRt1L
	cr9J6aK4gn8BNuucYNgfToC6W3PqEN5i8iMG6e2sm58BxnPgHtkIGKLnD28F7G3fqE4RCDc9anr
	o1sNQkI6e3Gxqi1W/WVGwWdrkau8o6ndNxgLRjfsIevmf4MnkAIFGQ9MzUArJgSVon6VhhtYs55
	FL+9YSCwo1rvvvZv6DkV0QfhBtk8QlyYZBG3oUcamHEK/JFZfiins8YQ+D86Hye9WkTeWNwm3Re
	lle0e6u7NdTPPXeY17R+obXTT5kR1CXlABKxaFrvU3So=
X-Received: by 2002:a5d:5f44:0:b0:43c:f926:1fa with SMTP id ffacd0b85a97d-43d594ad27fmr26223989f8f.0.1776112643671;
        Mon, 13 Apr 2026 13:37:23 -0700 (PDT)
X-Received: by 2002:a5d:5f44:0:b0:43c:f926:1fa with SMTP id ffacd0b85a97d-43d594ad27fmr26223952f8f.0.1776112643201;
        Mon, 13 Apr 2026 13:37:23 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43ea5f26274sm283900f8f.1.2026.04.13.13.37.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 13:37:22 -0700 (PDT)
Date: Mon, 13 Apr 2026 16:37:19 -0400
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
Subject: Re: [PATCH RFC 3/9] mm: add __GFP_PREZEROED flag and
 folio_test_clear_prezeroed()
Message-ID: <20260413163644-mutt-send-email-mst@kernel.org>
References: <cover.1776033471.git.mst@redhat.com>
 <b21b0ba353330f24b9e10ee5bf01b60f32043327.1776033771.git.mst@redhat.com>
 <b258160c-5287-43dd-b56e-268c403b85ea@kernel.org>
MIME-Version: 1.0
In-Reply-To: <b258160c-5287-43dd-b56e-268c403b85ea@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: N77U8hM7_liPRlVLE07uFT5b667QpehBUyMS4Ry8_iE_1776112644
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: u34y9zdfshf8spjijy8uwq37oixto7yf
X-Rspamd-Queue-Id: E99662000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776112647-538196
X-HE-Meta: U2FsdGVkX19JxFuHsNhO2Wp6uqWgGpRHmVboY/1CYs/v9hmmlxlbzeQ+jGPis7JjYobaQgHOEZoyTIBZH1MdCKPkEV15/ii8gtCOsbCJtJVfYw4dgYEuK2IledTIMOug/OczX5QatgcGk01rG1WIB729He2FaPQuuAfdjFMVIryrxcYNZfyU42Yibq9JmfeNirjyyIbFxnbk/FQU0CYzoRngpSjOiY7RxqmtnB9ubjJ7kSl44yHajOYz4688Pwpf6PAxRgI6cDlw2JSxtrxozLh+NpDSYKfmfKQHAHT+OmfiDF0dcJzO6QZRwSTS3IiJ4LCll+mBv+YYJuIB4jgtQfYSfZrWPBHPgLgYPsk53DB5weS1svXEfzj88aU1LwAHuXEqNACHD+yBtCmmJ0gQRNDbcH6ScPxYlf8pwzfqoTRurouN/LJ/77GyDEwYZFUgb4B2/igwdKE2bbF6VwCHTplItJ42ueumYMF8q4LyD3TraqIvgEmhtKHVYFUUhFrEoLzLtlQx3OE6DeCmoXV6UOWBJm/DtGA8xZNCF2BAKYatvBuM8HufAkgHmtOpzTY2n+ByYrhuA4gvZxML694S6b6oHTyeQV0bMaWLXNxQN6uY7LYxLWj2PltYEHH1D+GCbd7/h+ttFlt0g/VjpnGeS032eirrCd40M3ox7RJV/lRvfGL9pTQwPQv5mYXzlwiyPs7idsgyNUgL9XnyCmpTEh7I81G0Xu/O5btjYX5U1L+zytIblVi70EnNdNYxzr58X1S7jCvt5Qju2ez8FFKz7HC7VXjZ2o2U5OU9W+Q+yCmuTm1VMXZkygprNQmL98le52v7WKWz8tom2CnE5SbJrABWflbKT7JAFutt4w+IfaaT9lwPY+t26W7SiSxLuwtP8aR32ukcn0KA6LNtjYqO+Rb/b0espD94+g7mSUd1GejawVm9de/vlU8zzeGTmHUfFxw9aCj3LQgau/cWjri
 TlD932NW
 cjfJ/eCB6fD8nrema+dDWBlniX2R6vGb690VDayDMCEWcZVJmaX1BKF0XnULV1afa/tUFCDaM8MtvgLrsC0t4Ru3veuzdErqbKDWL0hKPD+VLHru8Tsp8ypS/XO0ddBAuex/09JCmcFyUetL6YpWO8keU6/jXhL6n9eQIIfAyD6MD1lTYro934JnAQhPkDBmmzJpIaSIEYgWFwZeQAp9Gh2LqZEnl7690bLyaRiQ++EfUd9vmhIBUISMI3yOIbO3vG2HKNWAmuxQvkhoN7kXPQn9W0w4S0TGjY3y8UUWhGKxVwnAuZdiDBylHD2n52Naygvwqu/u1SGzclgzRdXsnUULLf2WZCeSX5BeDGui4fGGrINbmLnCYq/1LZkiAB5b/Jj8X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 11:05:40AM +0200, David Hildenbrand (Arm) wrote:
> On 4/13/26 00:50, Michael S. Tsirkin wrote:
> > The previous patch skips zeroing in post_alloc_hook() when
> > __GFP_ZERO is used.  However, several page allocation paths
> > zero pages via folio_zero_user() or clear_user_highpage() after
> > allocation, not via __GFP_ZERO.
> > 
> > Add __GFP_PREZEROED gfp flag that tells post_alloc_hook() to
> > preserve the MAGIC_PAGE_ZEROED sentinel in page->private so the
> > caller can detect pre-zeroed pages and skip its own zeroing.
> > Add folio_test_clear_prezeroed() helper to check and clear
> > the sentinel.
> 
> I really don't like __GFP_PREZEROED, and wonder how we can avoid it.
> 
> 
> What you want is, allocate a folio (well, actually a page that becomes
> a folio) and know whether zeroing for that folio (once we establish it
> from a page) is still required.
> 
> Or you just allocate a folio, specify GFP_ZERO, and let the folio
> allocation code deal with that.
> 
> 
> I think we have two options:
> 
> (1) Use an indication that can be sticky for callers that do not care.
> 
> Assuming we would use a page flag that is only ever used on folios, all
> we'd have to do is make sure that we clear the flag once we convert
> the to a folio.
> 
> For example, PG_dropbehind is only ever set on folios in the pagecache. 
> 
> Paths that allocate folios would have to clear the flag. For non-hugetlb
> folios that happens through page_rmappable_folio().
> 
> I'm not super-happy about that, but it would be doable.
> 
> 
> (2) Use a dedicated allocation interface for user pages in the buddy.
> 
> I hate the whole user_alloc_needs_zeroing()+folio_zero_user() handling.
> 
> It shouldn't exist. We should just be passing GFP_ZERO and let the buddy handle
> all that.
> 
> 
> For example, vma_alloc_folio() already gets passed the address in.
> 
> Pass the address from vma_alloc_folio_noprof()->folio_alloc_noprof(), and let
> folio_alloc_noprof() use a buddy interface that can handle it.
> 
> Imagine if we had a alloc_user_pages_noprof() that consumes an address. It could just
> do what folio_zero_user() does, and only if really required.
> 
> The whole user_alloc_needs_zeroing() could go away and you could just handle the
> pre-zeroed optimization internally.
> 
> -- 
> Cheers,
> 
> David

I admit I only vaguely understand the core mm refactoring you are suggesting.

-- 
MST


