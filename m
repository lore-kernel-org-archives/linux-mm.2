Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35983CD8CA8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 21:01:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53AE66B00E1; Tue,  9 Jun 2026 17:01:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 511C26B00E2; Tue,  9 Jun 2026 17:01:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 400026B00E4; Tue,  9 Jun 2026 17:01:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C5E26B00E1
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:01:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B18CA407B0
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:01:12 +0000 (UTC)
X-FDA: 84861594384.14.B9B532F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 54F2A140008
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:01:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pc6iAmv1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781038870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Om/173xa6nAXXlawHrWQ0qeVuAob6cSlyHSyIFpCw4=;
	b=2powd8kn3z9J2ZjLjC7VnT+fMF6PUi4y74bMOFyWGhutsbhilXygN/X1bjJChD8b/pYHfg
	SGoDFTp/8k8Ne/3rQ8tSa5GEAUF/3te7nBs4nrOHDX6R6kaCyq6WaetZw9gjy5NgEhehzm
	jJOLykEH0oNETeDonD7/5SltxmYOPIk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Pc6iAmv1;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781038870;
	b=8q/27wVJppY9NSd0B1udNl7qLkHXTBz2oXoMasODXaMWXMdfaQyTFxGchjYCIY/PjPL0N3
	138BkVXpzsspUbHWof25BpcvA+PAwokke5iaXUiS2P8wynWKSpBC8q3TI8LnAEyrDblKqF
	EuLhNTAl8VXDDpONavlDGKkfcT7ee+Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781038869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0Om/173xa6nAXXlawHrWQ0qeVuAob6cSlyHSyIFpCw4=;
	b=Pc6iAmv1fLWH74AGTT9KqnYaFqx8lrYNNSFU9h2W7I9+aNDRQE6i/+5660EFOJGBbGlpMY
	RrryO7j1Bq7uB9+Q9bIbWeLu+rnepjhkk0gX+668C8nXdS62U7QlTM7XG8fdcyYZ7qBDxV
	OhES06+5FSTdiwsQoIyjflum9pGvLiw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-376-_jIPBi9DPkqfFHU6oAuGoA-1; Tue, 09 Jun 2026 17:01:06 -0400
X-MC-Unique: _jIPBi9DPkqfFHU6oAuGoA-1
X-Mimecast-MFC-AGG-ID: _jIPBi9DPkqfFHU6oAuGoA_1781038865
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-490b3ec3f7fso38791215e9.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 14:01:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781038865; x=1781643665;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Om/173xa6nAXXlawHrWQ0qeVuAob6cSlyHSyIFpCw4=;
        b=ZsZdE54n0zivIFFBeNSiHPsbXWIJjVL9EwcsTqlLeRwxa3Fafr73t7nb/kIbJtCIns
         RR3uVtvY1XsQFqSuW2rRBu5yH/LK+tLASoIQ2WtZ22psqj++sA982TjSaAgb1BarbTjT
         frm7MJwD68RNB4vOgn+6QlFYlFvNmJaxSHIm5SSrDy1lql4ff9VmKgBlkGgn3YGni1xQ
         JSvzeWnIdjCJR7wmG0rSYXnCpZaFMW621LLD6BrX3iGJyQ5QTAgsb95BBC2opTdBLYYA
         1SKkZje5JWEdMNPpPFeYA9N2r2FWcgQpFvyuSqUX2xRuUFKCxSMvsaTvx9/DDVOkrCqA
         TDiA==
X-Forwarded-Encrypted: i=1; AFNElJ/uW8aPqkN/THkJ+t7nrwVf2ohWkzG3tsKrJ6apylXm6WDeaeB15ak/+KIPO+SfQ4WzA092EqWmeA==@kvack.org
X-Gm-Message-State: AOJu0YxcywjfuebumGnUGBIwPRKOt5qdOnBPgNnL5oRTM64ZAz2BNfa/
	VFCFGvULCvWjqwLSmNIEzW6ZdaQsjgrbpoMb1Dli6gN+nvJUxOklT0EtzG8epUlXOHGx0x75ZK6
	hwCWDkhQ/nA4F0oNa/kkzk124A7i6ZvHNZlOIUhsjpIEIzHL90Pk2
X-Gm-Gg: Acq92OHwIKqORImc1cZrmDHysMPB7n5Hf903/LQb4tMmlea3jubtzbGVsfpwtozR9i7
	uPNK0FdhPRqQzO9X/FFSJiQokcnUaX7xf+jM7aGvdQCd/F65TGOA/7lrMRjgYn7niR/W7Mk8X62
	BA63DooEJqt2k8KWuw2AzNYbGayUDTeBJeJEcb6jGU/AVlPoi4Ry3WFGp3bcxwZvmdOkKwfbDwV
	Sjb++kj7bxdhi/6A3o5QozJk7VAgkJ+84BfREJqvWC+mjV6+Cs+4qZTQue7spjIbuZixvdbU4sI
	dTnLxSipJzOyCExB8fGOxIIwNkB1bFEDAX6LeQpAomHo+VHbxfSv+yWklUPHGImNHououedJlI2
	R4cNEfzpIPzFalk6cVhviIwFFO9OEXk18cT0FVTzW8ZEhvhnMdwEHDw==
X-Received: by 2002:a05:600c:1907:b0:490:b99c:9337 with SMTP id 5b1f17b1804b1-490c25a0800mr343765475e9.10.1781038865124;
        Tue, 09 Jun 2026 14:01:05 -0700 (PDT)
X-Received: by 2002:a05:600c:1907:b0:490:b99c:9337 with SMTP id 5b1f17b1804b1-490c25a0800mr343765005e9.10.1781038864641;
        Tue, 09 Jun 2026 14:01:04 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2dc577sm66817831f8f.3.2026.06.09.14.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 14:01:01 -0700 (PDT)
Date: Tue, 9 Jun 2026 17:00:55 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
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
	Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH splitout] mm: memory-failure: serialize
 TestSetPageHWPoison with zone->lock
Message-ID: <20260609165829-mutt-send-email-mst@kernel.org>
References: <df06b66fe4ff8e925ee0714955abc2183a727b90.1780998980.git.mst@redhat.com>
 <20260609111020.e88f51a7b6ebc37360d66fdc@linux-foundation.org>
 <8c1f468e-b50a-487a-a267-8d1ea5a61c87@kernel.org>
 <FB250C43-790E-4AB0-BD40-74665FC601A0@nvidia.com>
 <38C84F23-E881-4DB2-86BA-93F39D44AE1B@nvidia.com>
 <20260609162437-mutt-send-email-mst@kernel.org>
 <4BA276D9-9EB9-4E2A-8A05-657ACACFF227@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <4BA276D9-9EB9-4E2A-8A05-657ACACFF227@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: RJlGs7FzbEABU4Far5rRpjFZ4XmCp1beRWeseH7Y3Ik_1781038865
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 54F2A140008
X-Rspam-User: 
X-Stat-Signature: zoat1q8369au7jzaamed3emm8z9qd5ih
X-Rspamd-Server: rspam09
X-HE-Tag: 1781038870-77047
X-HE-Meta: U2FsdGVkX18ge9X2DNKlbuejLWu/kRVTQfec8AT5nDTrNZzI0wuwxUdVa95QyRWuhmg1vF6I4QwPXS6EWCuz9+tmBZYp25lL5vB7xO0kchDZrubCR2Kxrz0DLmDX0Eq8WehIeDXOKX9w+K9/uclXbdpYur4KK7WemU5Us3SEEvx6Z5awmsdN1HIR83HwNgcuz8AC/e1yGtiXf4GeZBDZdFZMgGZIYij5u/X45dHjcFmgpHTxzcC9MvzsY+AGPFZz1R8oKMljp2pZc+F5AnT0wNHs2SqMSqwD8L2k10QMH3PmdLrn5gmNrDMliTXck9N+4PRSOTw3zrejDrLlVodZHnvoDUlOUq76W5BBy1gjtxTuvR8ZbeiraQC1UN7ISpoN2ZICd3cpIIebzzkjCdmllYIvvQclOVL+9SLgKJxQlFE5bk7ZF/ZfhfMY/OVdvah+fPhqcgqEwuvJlETdhB+I1TqJYS9T992KA/yq0d+SsaJJEVpK046hroyJiMZ62+q4HD7WeMG0CF00RSCu24fZAtb/I4lSvTTqCvv3OwfdS4gWIndVXXiYTNPAAL2/yU+HvwJZNbLdxmTdps9Yc20kIR1p091s2PxT8pf+P9pAxSQOk2KsNMYl2BDnGP4g13KThQfAyl30l5FngNgIJeoohfLiYpKe6VrVUgfWP3xKS1LPt9MM1HOBU7JsAmxG62EKXRmNPcEr94vzpMoEu8lQSDiv1KuZjK0HKDZmdNFa1MPA8pCtucGf9oOMj/DwHyDTMf2lJWDO2rLlU9eQ2sQ0daN5sbb+NYRKn5M7tM5axbyF685GpePR3Z9FAOSn1qsPa4d3MMPTs6xd4/9179IKGmznMNfizxxfXHb8hrX3TEcU3NbCb8TqLimbhr7Le466ydz4tLc0NA/gaCS/Scy8ATGYncnOpcw5E1p8l75kl/3V2Vayvjhwo2ehFx7yZTrUTgRGZOCES2m+XG9MVIt
 AVDkQs/n
 6Y884ZPhsxljzMFM+MjAleD6KhTqON1Le3dTyoNRO4wn8qgSaFcX1M40sAsboq88dGsIYwmI6b2N0ODPo0aUyemOGL5OUAOG/+cKAOa8MzLPyKQN9OVL1UedFcgy2Ye7id4eGnZ5ISxuGjR2n4Cx0vENyJ07Me9EtlnLLoK/YW3i/G8pdztSfNA6yvcRAOvl3khVRBOwgaUH2/mMWJeHZkh+9mmPzIAdtiMTFwXn8gjyS91W5cvZkDwW4Ap7VwU/tAXwTRxeUycLCK7e2mLAv9yXPvV+quaTCrps4RCgiwJSO//1ihCo7GXs1a41bc74YJnKxxHFDn0i2FzGHs+N4EaeiYUSxgClADeG6EWmRnwZM+4WGUh2xQm9/ao6SbEN7jrQFBBWVslP7Qi5o1V5ThsZuOhofXWY/97Ly+cB/akmStAOIAEmqqFtcwdVT26kdE6ACZWOaaaYMkaJLSD0KaR8fOq14GNXiWa5//jVmYwPUrRvvUwo2KtDALzbE1fBvOXrkbdfoT93mxlnJD3/+M7E+sZlPx1Go8ILr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 04:54:01PM -0400, Zi Yan wrote:
> On 9 Jun 2026, at 16:34, Michael S. Tsirkin wrote:
> 
> > On Tue, Jun 09, 2026 at 02:52:47PM -0400, Zi Yan wrote:
> >> On 9 Jun 2026, at 14:39, Zi Yan wrote:
> >>
> >>> On 9 Jun 2026, at 14:38, David Hildenbrand (Arm) wrote:
> >>>
> >>>> On 6/9/26 20:10, Andrew Morton wrote:
> >>>>> On Tue, 9 Jun 2026 06:12:49 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:
> >>>>>
> >>>>>> TestSetPageHWPoison() is called without zone->lock, so its atomic
> >>>>>> update to page->flags can race with non-atomic flag operations
> >>>>>> that run under zone->lock in the buddy allocator.
> >>>>>>
> >>>>>> In particular, __free_pages_prepare() does:
> >>>>>>
> >>>>>>     page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> >>>>>>
> >>>>>> This non-atomic read-modify-write, while correctly excluding
> >>>>>> __PG_HWPOISON from the mask, can still lose a concurrent
> >>>>>> TestSetPageHWPoison if the read happens before the poison bit
> >>>>>> is set and the write happens after.  Will only get worse if/when
> >>>>>> we add more non-atomic flag operations.
> >>>>>>
> >>>>>> Fix by acquiring zone->lock around TestSetPageHWPoison and
> >>>>>> around ClearPageHWPoison in the retry path.  This
> >>>>>> serializes with all buddy flag manipulation.  The cost is
> >>>>>> negligible: one lock/unlock in an extremely rare path
> >>>>>> (hardware memory errors).
> >>>>>>
> >>>>>> Note: SetPageHWPoison and TestClearPageHWPoison calls elsewhere
> >>>>>> in this file operate on pages already removed from the buddy
> >>>>>> allocator or on non-buddy pages (DAX, hugetlb), so they do not
> >>>>>> need zone->lock protection.
> >>>>>
> >>>>> Sashiko is saying this doesn't do anything "Because
> >>>>> __free_pages_prepare() executes entirely locklessly".  Did it goof?
> >>>>>
> >>>>> https://sashiko.dev/#/patchset/df06b66fe4ff8e925ee0714955abc2183a727b90.1780998980.git.mst@redhat.com
> >>>>
> >>>> Battle of the bots: it's right.
> >>>
> >>> Yep, __free_pages_prepare() changes the page flag without holding
> >>> zone->lock.
> >>
> >> __free_pages_prepare() works on frozen pages and assumes no one else
> >> touches the input page. To avoid this race, memory_failure() might
> >> want to try_get_page() before TestClearPageHWPoison(), but I am not
> >> sure if that works along with memory failure flow.
> >>
> >> Best Regards,
> >> Yan, Zi
> >
> >
> >
> > Actually memory failure already plays with this down the road no?
> >
> > So maybe it's enough to just SetPageHWPoison afterwards again?
> >
> >
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index ee42d4361309..4758fea94a96 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -2415,6 +2415,7 @@ int memory_failure(unsigned long pfn, int flags)
> >  	if (!res) {
> >  		if (is_free_buddy_page(p)) {
> >  			if (take_page_off_buddy(p)) {
> > +				SetPageHWPoison(p);
> >  				page_ref_inc(p);
> >  				res = MF_RECOVERED;
> >  			} else {
> >
> >
> > and maybe in a bunch of other places in there?
> 
> You mean for fear of losing HWPoison flag in the earlier TestSetPageHWPoison(),
> just set it again here?

Yea.

> Why not do it after get_hwpoison_page(), since that
> is the expected page flag?

It's still in the buddy at that point right? I'm worried buddy might
poke at flags.

> Miaohe probably can give a better answer here.
> 
> 
> Best Regards,
> Yan, Zi


