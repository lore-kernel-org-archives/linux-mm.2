Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AB19CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 21:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B7A26B00B4; Mon, 11 May 2026 17:52:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 768E66B00B5; Mon, 11 May 2026 17:52:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 657C06B00B6; Mon, 11 May 2026 17:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 508B16B00B4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 17:52:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 00BB71C0180
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:52:44 +0000 (UTC)
X-FDA: 84756489090.14.E84BA61
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1B3C840003
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:52:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=h5mtZpyg;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778536363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zawmE/mtpN2n4/3m+Q4HP4926MV70apZ3swxtsElHX8=;
	b=gpSnq2IULaRHLUfD5g5hAV/aTpWyj1ehMRFEItyIY2xXNk6zI52e8pC2sdSezX+/xlkhJf
	HMIoT8yQU286YqZ3CA5PQhO41vU7sS4VThWOUOltRcBPhXhKjBF89dWr+5GU4XV/LKPsey
	BeN3Kx1wMdG2y2U2d5xKrOeIx3cN23c=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=h5mtZpyg;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778536363; a=rsa-sha256;
	cv=none;
	b=ptTM/ASqNGyYH9IIUXRvxrlQemMn3lUNeL6z0GjAumQSme1v3ahC75OIWijk8keRdEj0H9
	Lvq4ILkYuMZmELh5uZcHj6un4ntVP9aLG1jOY4+B46BScNPQbzbe1xd+gqGIhCeryL/Q7J
	pd0YkhMzVYfSiWyR0E9+39gZLVopJcc=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8eea23d01f7so654834185a.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 14:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778536362; x=1779141162; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zawmE/mtpN2n4/3m+Q4HP4926MV70apZ3swxtsElHX8=;
        b=h5mtZpygq7JJyXWLF75fPttAS77WEVs2U2+/vFJ5kb8lbtFushyXueivOqamhSL+9v
         V7F0LE9td/Yr1alOZpwwLlrK63Ix/HRdA+HvCE0cwcU36qLUCCbPXISll9Q/0R2akj9A
         tQ6EUfm73stMPrfxK+dEfcYQl+tT/AdwM+n8LWzgMdShu33TdLe8umE51w8JUFVIyuJU
         GK+Y6NkvHeWwZidxkpyX/MJp5047DR3aRqj9BsbELqmvdhYEsGTt821TTFUOycGOygji
         xksKEwIKOnCj/pUL2Wgc56WCHChn6pY1lCOUGbk5gB/tvo4F4PbdmQmEuhe5b67xXxNZ
         nuuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778536362; x=1779141162;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zawmE/mtpN2n4/3m+Q4HP4926MV70apZ3swxtsElHX8=;
        b=OdFrgCsmw+i9QmJJuMCwh55qcS+/wJgPaoPjNnJzwv3W8FDbZlBggwglLfYnwp3tQi
         GFeQ0Rr/mELcJUH0AVeVlA+1uAGuF3bYe4FG0DgOxs5+nUjB4K0HtDktYecpVSaXUReG
         aU9pgF2STx97kYD3F2+sCvi4JDVjOinNiYJeXOJs5eHbwac8tIdFod1OofIF4WkhaEB1
         Mv9shh5baHNmRtBnGHI6zT01DvYrKQSocG2z8vbLETK9EdepIserF3nTPbu7myy+3c4q
         jLvrcykQZZI8/t8YmbTZv9+wlvYpOrjNL7L2RAwKFXBM9YW7247nsYP4Wm6lOoGrPqAq
         LJ7Q==
X-Forwarded-Encrypted: i=1; AFNElJ8rBTH9zcYB2kB8ewILuc+obXSwkRPI/b3yfvamwh2ThtTo5wA5PEZKriM+oD3LH0ieHDYX0i1e7g==@kvack.org
X-Gm-Message-State: AOJu0Yw7LeOUF6dm/1vNeuP5GB/tcaV6jHYdesKF7ZD/Fmo09qRf58V3
	+IH/GACvkQLpzJ9/mm3Ho/ZIGGFq8E/1G+5WpiUUfM29nSCWDniFtZzHO2QrWo/j5zE=
X-Gm-Gg: Acq92OGVjcKuq/zZ9j9Lgu1BniVd67f1EmejNaTUkkUREbU5ONThNvUTSbUVAccOVRr
	se2OEL9CUWP0Q57dBzqeveVDelmGPiZ4tPWkx2Tl7cXjr+RQaf1j4yht2PRWjFk1evNca8AsQCs
	G0uPlWLQWQrn+MI6wLSK0v+QvaiHr+wL6Ul8qhufKNdDieHbtsP68p8sa/pJl58wbdRFQqzZG1n
	87Uo7T3RNGKtnDVwFEghcb8tkOMYJjoAHhMcuWXZDl6t8Ee8NqjVwuHaYEKhzN4cVHkPBbYIM5p
	9UtDtA86/myft0pVmzbz1FV/ewl9ubEv+gCIpQ+r2Ck0T8MPRT+ASbXFVnLxSPNtGHvXBCo/GoS
	6WxLQ9UuCRN0c4s7aghtR5ESVD+SWS0rpgo7e8D7VctftaXyN+Y40oViX1xX4OXRWS77+cKqfYt
	kMg+SanQjOvWcckiV+FjivronZIKW2HvPhjbHq4h0uNvtUW6bBE0WxAp5zDDAf4M2vlTEIghkW3
	/cZvgmEDaXG
X-Received: by 2002:a05:620a:4003:b0:8ef:3953:7d0 with SMTP id af79cd13be357-90cfd3568e1mr38106785a.51.1778536362049;
        Mon, 11 May 2026 14:52:42 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-90cc338d234sm74534785a.43.2026.05.11.14.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 14:52:41 -0700 (PDT)
Date: Mon, 11 May 2026 17:52:39 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
	"Liam R. Howlett" <liam@infradead.org>
Subject: Re: [PATCH resend v6 10/30] mm: alloc_swap_folio: pass raw fault
 address to vma_alloc_folio
Message-ID: <agJPpxyu4gKqq8rj@gourry-fedora-PF4VCD3F>
References: <cover.1778489843.git.mst@redhat.com>
 <369a08b86f51572b2715a9ec577de27ea98000d3.1778489843.git.mst@redhat.com>
 <agH-PrpY269pyuJQ@gourry-fedora-PF4VCD3F>
 <20260511174032-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511174032-mutt-send-email-mst@kernel.org>
X-Stat-Signature: 3enpexj58n67u5ofmzd4gjqhym6cc8sq
X-Rspamd-Queue-Id: 1B3C840003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778536362-28821
X-HE-Meta: U2FsdGVkX1/LVGlnMtipvvSPF8z3by27R0dtzq0mXlVG9kKflX9i47MYt6PvS6fO0PItSCTnqHBIKwW7nyJLThXWqx1QU64stOhCItDQse9aem3w9VyBd8iJ9hCFMOBh5MJH4sOJZIz2eJDrHHjhaFEQMrIkASxaMfZgteym9DoRfZoL7d99BaCj3LamaUpWG33AfXxDKFnRBffbZ3SZyeQrbin6a9/hPXOR4/ZGLa8c7it+8sTJbBp5snDSF8GX6p98itugOMSlgkyvEkxxHD2pxKhE2BeT1o4ZBr6zoTWUo6w4ufay03REDWivYVJFYTZLmyBZ0fK/9gdkxA5TEnzoX3SQBUGa+Gnnam1NHjnqGLfBu8ay1r+d7B/MzO0rIwgQTrYZRq70rqNP7FcDgr96Pxi5Y66bbfRM82FY2SxRtm1Ztq4RWvmUiD8YJ8zhTWi8TQAVhbLAHaODCDlzw456m21YOQqT5xsmXB6k9C1NDhuBv6TvchqeFMO6YLTIYfGbkbYuLF3qY6MME4fJCUR6pu1ucvf4kHbDDp5dFc33OuDNtA7syG4QfJB08OBhkBjw9+fSHnqUZaBPfF7aO8Ru0uTVDP455BBNFVnaJmYNCq3b+glHXzUAkpIkuT8VWQujbN9yzbmI191vw70C9cT7efKyX95Q/Zl+3+dWBXSJszyEALa+CvbFygzgPSf2z1QrQqAdI27tGdVxQXSINrM4xXPv8jhsEfjIdruVtF7Q6I77n21+a+WafPc3Zt//GTFEPQypxpD4B8uLsRvAv9cRTpVjrb3+45nBH/pllYpFPpzTHaNldvmFXs0b9iGGjZfT56bopxgABOuHDqTfr21LQlXEV4K1LytQ8/x2C1KX7YTZbVW3kcVZPUaJFj11C1avWOpccrMAVg7ie7WBuqtFptLhet/6f5b/L/xqvGuAgtE8N6zvEoEUSc4m8ZfpCwnucwqR7U6Ccr4TMfu
 ilmlqghG
 MonARpYbOjVit0XYBctxw6wXblxQpWyKIfVWEEVastxVOCEIzk8QJ+EYXNBt1HvF9M2yYeGzHfmZX71zf7VZrkqwnUinwmCa9lgWWpo2Ifvn/yKltHPN5VjppefHGLwVUrmN9IZ74v4ciMVfT3M4FzRqAQ3L0NW7AdYhpnX0334rGA8ObOTzfe5/jVpNBSyAq0XRxEpnAOYsBTHTGArxpkfyGw7W2g7fcDQpSZ3w5rb5F2F1YsmOoiutnbLre8GyKYbfW+WdzXU1rOGDh5folHWRs3qJ7zvsyIi8b/So/nej9ZIrleFLW5RLM8OsJyNT+zrVHjZHifFcVh3mtNb8ZHshN01WwzPrdPwgncZeUIRZFOmfCcdaIRzoLEcJNl2dWgDWHik4296WIwaTdQ6Df6whqdckiRgOGQHsnMb5BvnMRM2Kvlk8wdgI25AljFpZzn9P9RRIxfY3SlELetI7JZ/gLNlwX+b5izLXYO7wnxa2ulPFp+5LgrWSvEffTAjEuOiU7iwkRqCvIIySIpgGPSEFJS49BcH/wpBps
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 05:41:16PM -0400, Michael S. Tsirkin wrote:
> On Mon, May 11, 2026 at 12:05:18PM -0400, Gregory Price wrote:
> > On Mon, May 11, 2026 at 05:02:39AM -0400, Michael S. Tsirkin wrote:
> > > Same change as the previous patch but for alloc_swap_folio:
> > > pass vmf->address directly instead of ALIGN_DOWN(vmf->address, ...).
> > > 
> > 
> > Starting to seem like this should all just get squashed into once patch.
> > 
> > ~Gregory
> 
> I mean I was told the patches are too big and too hard to review.
> It's just same, independent changes made in several places.
> Does it matter if they are squashed or not?
>

Mostly i think the ordering of the patches thrashes from one set
(alignment) to another set (USER_ADDR_NONE).  If all of one set was
pulled ahead of the other then it would be easier to follow.

This particular set seemed trivial enough to just be one patch, but i
don't think it matters all that much.

~Gregory

