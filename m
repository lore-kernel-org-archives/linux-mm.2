Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF301EBFD18
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 08:29:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2C536B008A; Mon, 13 Apr 2026 04:29:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDDB66B0092; Mon, 13 Apr 2026 04:29:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCC146B0093; Mon, 13 Apr 2026 04:29:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A784F6B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 04:29:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BDCA4C3AF4
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 08:29:21 +0000 (UTC)
X-FDA: 84652858122.24.E995230
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 57883180004
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 08:29:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AN+FIDzr;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776068959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d7T2EfZlOhL6EGzqfce/4yeDNVNuR7hO+mhzu7kbbMs=;
	b=2m4h7Qx2x0uWd3iHgA86j1xsJYETBeco8O9rrjLqZEdEMb2vTCLf1Snv5+qd6cZwzXfYjS
	H1czMAkcBpQDjwWGD5Kz2fgyTCELWVRTBT4eKDS12gJccOFBgbj9iBkL6TzpPc14ca2ipj
	wvkIKp9lsen5VMVr7R4nZJuP8um0P4Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AN+FIDzr;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776068959; a=rsa-sha256;
	cv=none;
	b=CoXctiof4yCPCekLQ49/la/63ZfxQ1c+kLGdEuHEq6XJjk0mWX+/H12ZtImFOLp5DLo1My
	3MMHVIIZQ+qz96fyeLv2bXoKHaNCf2ayGg2aTaVo9py8vS2FeGMcQ1IBwh3KWMOfh7iO6b
	JGPvyNLI+NePUuw72J6kCUfo3JgyNYc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776068958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d7T2EfZlOhL6EGzqfce/4yeDNVNuR7hO+mhzu7kbbMs=;
	b=AN+FIDzrmyfWJ3RvNXWH4ooH7mDvNzMykzzsHOnK4LZEqEUZH0eJghfRuyWGUTj9ysN5cZ
	wdJZt+jNjwaquAAs3puOmvlHnQoIsvxiKJthlhIjArin7jrCrGusGSHi45nkzKm0EWRZlC
	jNNqqFyPwZXSoXiFc0Wi2OVzV/sH6/c=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-29-aCqulnsHPcG_ZiVrh0T2CA-1; Mon, 13 Apr 2026 04:29:17 -0400
X-MC-Unique: aCqulnsHPcG_ZiVrh0T2CA-1
X-Mimecast-MFC-AGG-ID: aCqulnsHPcG_ZiVrh0T2CA_1776068956
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-43d77286244so521175f8f.1
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 01:29:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776068956; x=1776673756;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d7T2EfZlOhL6EGzqfce/4yeDNVNuR7hO+mhzu7kbbMs=;
        b=sfEwAaBo5SDhWakaqOcu+RbyPHkS8re6BLxDkMNrNBL4Mm1vKbr7HldeAkCAfyAKf6
         5DpI03j6XN442rravBfxMsDNBhhwKM7WgNgDbz2kiGDKZuLEvWG6dJLLJw+OOrx7RBnR
         6j9uSEGQXOP64JSy/XZb1PVnshsQ9G/P4t7G7ikw42O2nR7q/lyoQpGirnthfFLHH7FF
         13vbRpD2bfIhO2yiA7uhnj1qDcu6c+FdBVeoBq1uKr2JSn20RA4OCm+Neq6fqFGn6zDm
         x6KpJwyzNDQTyKhPEfmVpngLugRJPxE963QQ3o2q9OTunqiWYznjJ8e0elTHVOXuqGgP
         sWIA==
X-Forwarded-Encrypted: i=1; AFNElJ9vKiftDY3Sfdb+oCznpHjpMW8YTODHe0QgFD4O9vuNMlDbukpF+2I6w4qd2VH42tFI99K0RKT61Q==@kvack.org
X-Gm-Message-State: AOJu0Yx/uXyJzBHiGtspiFSKeeilA0/d11PSbksydkADIxBjifMBgbQu
	Mbnw0GMnCrzVae3stS7QRiOUT5fXVEv/CH2r/KJsQpm1wZ7s1No6CNTQyqSuMsqXZ5dovJh3KQh
	yZx95AhmJYHhXeOYUJPRB2h6Vhb50g3OY1ztr3D4SGnGr0LWGa1Hg
X-Gm-Gg: AeBDietnbggsZsy7b2fUXZOcZD0bjVTXKrWRStvLYW9ZiC8rPqstxkgnDW/tmfw0ZsK
	IOVuZFzFZp2N2pxc6PcQ8KO2S5l0mhAV0cjBc6xvZrcC7702FaOIc+tOAZi4DwfRr8FG9xnQl7Y
	nWyRz6RFJG/BIHxS9fLKMF0HJpGW/wvNGnqTHWdt2QIUN0kR/qk8Ip88UPP3bZ9CDmoctXvC8h8
	0kmuF0TH9STAx3WCU5sb7eed0mN87A5c59cgNdgym5qLG7TmG9ElIfHzPt+zDFmCMPQFTD+pjx7
	exMK/FSHJ1PSHU5cVBQKExR6Z1qBg8Xk0L3QX+9zKjUZ8S7RJ04LudA0aNx1CGD7YAgFpuxONK3
	yYS7B9SvPNRXsGncvzWFQKiK03I1tiXAe1v68kYuCybs=
X-Received: by 2002:a5d:5f86:0:b0:43d:2be:e54 with SMTP id ffacd0b85a97d-43d642b5035mr18655080f8f.39.1776068955980;
        Mon, 13 Apr 2026 01:29:15 -0700 (PDT)
X-Received: by 2002:a5d:5f86:0:b0:43d:2be:e54 with SMTP id ffacd0b85a97d-43d642b5035mr18654999f8f.39.1776068955408;
        Mon, 13 Apr 2026 01:29:15 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d7bd2f237sm3321886f8f.23.2026.04.13.01.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 01:29:14 -0700 (PDT)
Date: Mon, 13 Apr 2026 04:29:10 -0400
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
Message-ID: <20260413042505-mutt-send-email-mst@kernel.org>
References: <cover.1776033471.git.mst@redhat.com>
 <ea67e39bc3aea1b0b491908f851ffce25154cd26.1776033771.git.mst@redhat.com>
 <2155527a-e077-4b71-80ee-d735f9984f60@kernel.org>
 <20260413040143-mutt-send-email-mst@kernel.org>
 <4e1b349b-d0df-4ad5-8050-9a2b3b3831ac@kernel.org>
MIME-Version: 1.0
In-Reply-To: <4e1b349b-d0df-4ad5-8050-9a2b3b3831ac@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: awjrv_eElLcQbqVyJtEdByxAU-pTR6-I9kW4ow5lN48_1776068956
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: dwxmhq3nnu5mi1uar8zswjbf13w8hwf9
X-Rspamd-Queue-Id: 57883180004
X-Rspamd-Server: rspam09
X-HE-Tag: 1776068959-236407
X-HE-Meta: U2FsdGVkX1+LRv3odRL9TK5Z95adopFbqrafST2b173ODGE31fCU6hL35IwdWH0UugmeOtLaLTZrG6k0ptm6M0VHL0IT9YmV6zStTovSRjaHxzwVkR8WG5PJtr4m+t6LvJ9UBRIaoHB0kS/iAPsh4o0yB1fz9spaMvv0YdlH6MvBLJoCiSMhw15WhlIcCB0OYaciv96+jKofHvR+1HdUseW4bWeif8+u6eZ97c0qQlMBSLkWXl4lUYfG1Akt00kdgTECdwQ2fTVXKyLGehqVo7cQ9TspPX2L4QANy7/Gpz94dLG3hqizyG/CY1KWd1cF5/MDOuFVboNRcYX1DZxPGkxl8q05PR1FnRzoiar+WYLw5BxOoAzncyz6qTG8rB5QKcB/X1DEJ8h1+YeOyZ0WZvyTWNAB139NuBRfVi4A5pReMUd0I711S2/BiylEH4tUc2rli3F2Qd2DYi02ctVBf35vCorxBXf4VvagTOx+gMdvdtmd5Nttk4TEehlOLUqlwIrMj9QmX87pVPdv4l8WgR/QjgnKEaB6NBrTYoHuZ3R+i+u9ZjJVnLCtJW5c9ApSnWvKFtnlu8T1u/MeAUB5nXzc2ciC8dZ4hlsEMje5KMQgp8HomZJFmnYmTtyCJqvFDbzd/h4d0akR0jy3QdcehncOJqWe9X8ir9hj5F9iIl4VqmCbW+/i1dHCh8dq2AExpyLPY44R41YwVTyKHTM010aCguiEGlsOjrr+aHKrYUHJaptFsjltWPnC9lxRdGnmoyp/uEAM7yaLS44q5eXTInxwQ/COEAMKL5V7wkK5iB/q3cmGQTrzBMXsoGFHL0XpL7wE3Dnn/PtrcuqFtVbcSyICLn2pqoBvIBqo2zRZl2dTecSrH2QMiyJLgTl4YsUl/b/GLZX4IqReF/GJAkuXJSUF4c3qnir+GHu1i52Zd7OwnYT2l+MmGqwesT8zf5MN9C950UvEVD7v6wLkMfA
 JAkL8//E
 nDgVwKBasPrhMHN/SKccYn73aiQ9+Is0YbNMlwC2UFLG7OZN39RlAvrENbo5zd6QYW/dUyL/+vkZTHSg/+RBctHw5da8F8o2n5u4VlEBGaFZtSPhatG4iRwedAtcMo+oXha6b03mbA+Jg8qlFYmEKD6m6C2UetA15/6V3oTiOeOE77zmSFfc2bEoN86mbVhPT1ClLtnKAZHz0k9W7off2j+89iL1bqSzAK9fvp/TjypBt6NnFscnVxj1WnrUgmei4X9c5xfzjjm5Z7/l4qg+w4C0aVclPcLqLmh8i15ywHEaY5xnkZM5Oce/SjZipwycC+K5CdNQwF56sk7A8L6WpFfaFU+hzn19P0PCJnUj3wYBYbT2nL4dLCZwPY5TZzVDwn/Z+fzJ8I3wszUNJM9GEsBNiCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 10:15:08AM +0200, David Hildenbrand (Arm) wrote:
> On 4/13/26 10:10, Michael S. Tsirkin wrote:
> > On Mon, Apr 13, 2026 at 10:00:58AM +0200, David Hildenbrand (Arm) wrote:
> >> On 4/13/26 00:50, Michael S. Tsirkin wrote:
> >>> When a guest reports free pages to the hypervisor via the page reporting
> >>> framework (used by virtio-balloon and hv_balloon), the host typically
> >>> zeros those pages when reclaiming their backing memory.  However, when
> >>> those pages are later allocated in the guest, post_alloc_hook()
> >>> unconditionally zeros them again if __GFP_ZERO is set.  This
> >>> double-zeroing is wasteful, especially for large pages.
> >>>
> >>> Avoid redundant zeroing by propagating the "host already zeroed this"
> >>> information through the allocation path:
> >>>
> >>> 1. Add a host_zeroes_pages flag to page_reporting_dev_info, allowing
> >>>    drivers to declare that their host zeros reported pages on reclaim.
> >>>    A static key (page_reporting_host_zeroes) gates the fast path.
> >>>
> >>> 2. In page_del_and_expand(), when the page was reported and the
> >>>    static key is enabled, stash a sentinel value (MAGIC_PAGE_ZEROED)
> >>>    in page->private.
> >>>
> >>> 3. In post_alloc_hook(), check page->private for the sentinel.  If
> >>>    present and zeroing was requested (but not tag zeroing), skip
> >>>    kernel_init_pages().
> >>>
> >>> In particular, __GFP_ZERO is used by the x86 arch override of
> >>> vma_alloc_zeroed_movable_folio.
> >>>
> >>> No driver sets host_zeroes_pages yet; a follow-up patch to
> >>> virtio_balloon is needed to opt in.
> >>>
> >>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >>> Assisted-by: Claude:claude-opus-4-6
> >>> ---
> >>>  include/linux/mm.h             |  6 ++++++
> >>>  include/linux/page_reporting.h |  3 +++
> >>>  mm/page_alloc.c                | 21 +++++++++++++++++++++
> >>>  mm/page_reporting.c            |  9 +++++++++
> >>>  mm/page_reporting.h            |  2 ++
> >>>  5 files changed, 41 insertions(+)
> >>>
> >>> diff --git a/include/linux/mm.h b/include/linux/mm.h
> >>> index 5be3d8a8f806..59fc77c4c90e 100644
> >>> --- a/include/linux/mm.h
> >>> +++ b/include/linux/mm.h
> >>> @@ -4814,6 +4814,12 @@ static inline bool user_alloc_needs_zeroing(void)
> >>>  				   &init_on_alloc);
> >>>  }
> >>>  
> >>> +/*
> >>> + * Sentinel stored in page->private to indicate the page was pre-zeroed
> >>> + * by the hypervisor (via free page reporting).
> >>> + */
> >>> +#define MAGIC_PAGE_ZEROED	0x5A45524FU	/* ZERO */
> >>
> >> Why are we not using another page flag that is yet unused for buddy pages?
> > 
> > Because we need to report the status *after* it left buddy.
> > And all flags are in use at that point.
> 
> I'll comment on that on the other patch, where __GFP_PREZEROED, which I
> really hate, is added.
> 
> > 
> > 
> >> Using page->private for that, and exposing it to buddy users with the
> >> __GFP_PREZEROED flag (I hope we can avoid that) does not sound
> >> particularly elegant.
> > 
> > But propagating this all over mm does not sound too palatable, right?
> > There's precedent with MAGIC_HWPOISON already.
> > Better ideas? Thanks!
> 
> I'll comment on the __GFP_PREZEROED patch.
> 
> > 
> >> Also, if we're going to remember that some pages in the buddy are
> >> pre-zeroed, it should better not be free-page-reporting specific.
> >> I'd assume ordinary inflating+deflating of the balloon would also end up
> >> with pre-zeroed pages. We'd just need a (mm/balloon.c -specific)
> >> interface to tell the buddy that the pages are zeroed.
> >>
> > 
> > Indeed, it's also easily possible - it's a separate optimization, though.
> > Another simple enhancement is including hugetlbfs freelists in page
> > reporting.
> > Doesn't need to block this patchset though, right?
> 
> Not blocking, but I don't want something that is too coupled to
> free-page reporting optimizations in the buddy.


I can add that in the next version if you like, sure.  The main issue is
that it means we need a flag that survives free.  And the benefit is
much smaller - unlike page reports, deflates are rare.

> The comment above
> MAGIC_PAGE_ZEROED triggered my reaction.

yea, that's more confusing than helpful.

> -- 
> Cheers,
> 
> David


