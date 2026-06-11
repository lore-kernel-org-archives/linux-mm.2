Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88A55CD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 05:44:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A64E6B0005; Thu, 11 Jun 2026 01:44:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 656296B0088; Thu, 11 Jun 2026 01:44:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51DA76B008C; Thu, 11 Jun 2026 01:44:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F59E6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 01:44:08 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 50DAF1650C6
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 05:44:07 +0000 (UTC)
X-FDA: 84866540934.23.2CECC76
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id C5EC5180006
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 05:44:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MlYWLT3D;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781156645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J4nnNFS8Cjiou/AxpB5/aNpa5nrhgheHR12Lh4z+m4I=;
	b=y1UoW0o580WOndbzYT1xyDZH23pNJ6Wl+krfczHkHfRK7kvByMYAriaQxxi9Z87ffAN0hN
	wDCu0Q9N/oAh6eg6tlECnhhw5GYwCa3xWSYsInicdeaIOkB27EsE1ERj1ZSD2d0Tkg7DTl
	uczV8AjLZi4LxQ+gaDax3JHb1nK7C0Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MlYWLT3D;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781156645;
	b=rkJDgWXHeZZ+/TP37PtU7565itLh4RzH29eg90yR29vyt1ai+Ri73BpKLa8Y+rMGcIkGL2
	zUUpDsmKWtBEFspO2X5/HO9LMR4tkCEhVKS0Kt85d2SQE4B+znVNz8ws0ezGb+Csdgcwcj
	BYDcMfy/+e+JJVyl8W2+32YMEzNZaEM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781156644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J4nnNFS8Cjiou/AxpB5/aNpa5nrhgheHR12Lh4z+m4I=;
	b=MlYWLT3DJT70Zb6FavvJMarQews6mjwIgcv58cziK6AunaKI7/F7MLJZOS/IkzKxfHoniB
	fjqaD3v+Semn4I6+KCJy9nu4DNtLKBL8gSn+OKPK5/659vr0rznx01xD3iUm6kBDjUMl2r
	tkF1TqwZOdwZzr8kcts6asdJjWhoVVc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-IG2qwJO_P5eRT_NwBIeWqQ-1; Thu, 11 Jun 2026 01:44:02 -0400
X-MC-Unique: IG2qwJO_P5eRT_NwBIeWqQ-1
X-Mimecast-MFC-AGG-ID: IG2qwJO_P5eRT_NwBIeWqQ_1781156642
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-460153ce644so5640581f8f.0
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 22:44:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781156642; x=1781761442;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J4nnNFS8Cjiou/AxpB5/aNpa5nrhgheHR12Lh4z+m4I=;
        b=Bu12/H7A5o8Q67efOXa9Y/L6V6QjsaTRAim29B4fzf/SkYBdOL36L8srt1ykDRADpW
         uNtCRdM6AWlbePG+KEjm9kOp5vnvlpycle0u3CarQzimHKrr4thjl9sUXet/8y9Wgn2L
         dfVSOTihHvuqy18TcDR4LchHxbz4rVAtBf7LY2wP2Jh+QIEfz2ma4Rh6evKFeTkJqEcd
         hg67f3L1jXO2/PkzLumJij6L57eaO8fkOWF2ZIp3ZMbLwhBV98hPeuDvVtL54RI5kcOP
         Ljv7vEMCRgAqIQjVW8GZfdZIgMVyRo+hQ357f+XM/9WGoxWlbmSWxKmTjVvoUsNYXWL5
         9NJQ==
X-Forwarded-Encrypted: i=1; AFNElJ84evO28nbmqFIMnc1Q5HvAU5nAc99vdbR6jWof9HOAUM/JS3mdfcG7VemD3ZYtrfHO+76xAXdQWQ==@kvack.org
X-Gm-Message-State: AOJu0Yw1ZeP3XcVNckAOZo8PZdEJruVaM3fi1rRd0REpRha+SIuvuMId
	WW+vP05rHdjdDSLCBBVRKF8+VTnAyLUGYTO3Bxa0NfqiZhvUZlqeX4kNTdbgksOQxKc1Ri+rF6D
	rZDHVTnGpG3oscamxG2hoF6YulDV+85vTtbSU1N9zWGDJjqPkooUy
X-Gm-Gg: Acq92OGUBEEMKkW8XD0ZuSnfyaRG+5ER7ESGd8z7sIRVjNnck6VM3VPmp18/XqNHPk3
	DkNHtoRQwZI9VOmkLfpfTAulT6sPt9ovK1Yz0sgx2reYCg/PCwDmuInxkSfQ7xq9VPbpRmiwbDI
	8zh4KuqXty+yosWPSY7iS3Cm3WKXJPRKPjknD6mNQ7la/TC32kXOEdxecefn3MnBNaKj962Ndoy
	RMJy41dPHzipzLieeh0uZB03ww84dE9zk4o861jmnsl2aVCoROJAVU+kvk9BA7EOwgLzX69TmlA
	JXV6+luE1Du52UZeDQyyXQzXa9vYa4Eu5Ei1B+2dr1xvw5/HYuUDsC6MJ8kQ38Ypbmjje3jBs0w
	QY4kX9edsQS6PJm5CCH2k0CuBIrRmo9eEcFzvGR5LiQ7MthSyvZ8/+g==
X-Received: by 2002:a05:600c:8b44:b0:48f:e3e7:3d39 with SMTP id 5b1f17b1804b1-490e55b5511mr10517455e9.11.1781156641505;
        Wed, 10 Jun 2026 22:44:01 -0700 (PDT)
X-Received: by 2002:a05:600c:8b44:b0:48f:e3e7:3d39 with SMTP id 5b1f17b1804b1-490e55b5511mr10517005e9.11.1781156640945;
        Wed, 10 Jun 2026 22:44:00 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490e532c778sm19957795e9.14.2026.06.10.22.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 22:44:00 -0700 (PDT)
Date: Thu, 11 Jun 2026 01:43:53 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>,
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
Message-ID: <20260611013644-mutt-send-email-mst@kernel.org>
References: <20260609111020.e88f51a7b6ebc37360d66fdc@linux-foundation.org>
 <8c1f468e-b50a-487a-a267-8d1ea5a61c87@kernel.org>
 <FB250C43-790E-4AB0-BD40-74665FC601A0@nvidia.com>
 <38C84F23-E881-4DB2-86BA-93F39D44AE1B@nvidia.com>
 <20260609162437-mutt-send-email-mst@kernel.org>
 <4BA276D9-9EB9-4E2A-8A05-657ACACFF227@nvidia.com>
 <20260609165829-mutt-send-email-mst@kernel.org>
 <dd8d89be-9c73-8ff7-7d44-9705bddeda4d@huawei.com>
 <20260610171646-mutt-send-email-mst@kernel.org>
 <14537566-94d9-eac5-2636-35f925a9d159@huawei.com>
MIME-Version: 1.0
In-Reply-To: <14537566-94d9-eac5-2636-35f925a9d159@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PO-e9rmn_ext7FK8FIjdUTfL1Q-dH7RoxWqNqxjghB0_1781156642
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C5EC5180006
X-Stat-Signature: w5wicgtm3kyzjzf9ifjy4onbos1u5x37
X-Rspam-User: 
X-HE-Tag: 1781156644-79025
X-HE-Meta: U2FsdGVkX1+1S3y/A9k0UY1BbgMZ7GlJXXt8JsF//cjwLg5dUWlPG7gIq/5iY2UAaNRmOZPiC90ZBcDLo1/YqWgETt3ItZNA9Hx/FQAYBe7GkhLtObjJFQZMmxc11xRmIs7E8LhfUhRpCnf3pijKT9gkj1QMUAouT5Vdvj2ha4YsEc9EucHSgM7KxJRdNMFdiclPx2q1q6smPa0yWQgz8nKH2ivHTbBKT/PrDQX2DlqTRj7rjTbvrT7UstE8waZmfNqea9YO7g1nG+AuJO0E9JGdH5rwgyDOdGUcGDWQsdwAqqrjvL2ZSlSvK6lG0nUwkTHVBTMCshDRyitrYJD9K5M11YO/GrsURqhmItBDCRYXZL4Pnce5jqua4esVbOhr9eLidSDyqOgUCEaj73dpqitUqLLtrZQa1UNMgF3UhkArKA5HxkqTQxweQg4pHfmmZI2N8YvzcKPvVHhF6EGhA0XusnIGlXKZU5vCsT05lSkKMJ2BF/y+UWLHcXED5mvQf7Z2PA9ogY0koWtGTRjmwl81WBmE10hGTUpn1zyADQvkj4veuXNJwOyB8I0lUxk0ydlaDmW1ps3O/wqIl1RqkNJajQcE/OdWl020qkQo5UNdTNmV4FUHNnYYh7O9JJcCPDKJitucLnKOHPFu1Bs2w+R/tlUzoASB5Ir7MHQrB+fX60TjNR/NM142bqcJr9PE7wfqxDhLnYOElIm5VbXHC/tsfmcYTkKxF7s/74gMr0/4Nn/lrZOUssIxxd1gHRueDqYlt9lUzdoH4+sAgKor0nz2PBhhlFauiNSWHOSxVRzgJ9fUwDmbIxyqXTulelHF8MxhI8xIFkrbwVwji3I98P9cbtANtwczRer0wDhrSsb4HWWdVvFhFcE2ct/RYVDBtWa1w9fIj9yqubn5vJrKpRuYQhD0HGv91p1g9zhHFw56np9hJIEY4PSStNNdplhlGjsgwT4/N8WXN9iMAWl
 Mteithsv
 Rd4GDlh+bvO42ljYUfCVZ79shofCWvTRsBPcUKqucPzEbATWWlcNHXMPdUq8Xjer6fmopzJTI7saclORgD1KoSC4h4Ya/yr+ggFtL0bW/vyXZE2UPjd6Yq8fM2+RpPcV9B/Y76WjRaGLRm+TULTh0D4bW/wXmpkbPysQJqbb++mlwNVAs7eJF2mFHlKoUvlLEfRmUcv2vybYBJJoJTqL54IxFfJ5FlK3wak9WcaZPkLPlBoS1LadxLqc/Y5CHmU8KXbG+M5KlhEu/F5mVrDThUhM95wCEztVllb4XXEU+aY9hDotwFOPOxGdxClufUdjn5NLxO0sWaqR9Hdk3Xrdru4gnzQ1WVfFSN2jJLQQ1E0rdzzJB41lEXnkGGd8tQWYZwshyC0aanJmWPKXbT9++uiT2+BRJGlFgcK7Xv8i0tQCIA1SDrb8g7tQrV7ysDG3dD/wJhQvZPVoT63g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 11:35:36AM +0800, Miaohe Lin wrote:
> On 2026/6/11 5:18, Michael S. Tsirkin wrote:
> > On Wed, Jun 10, 2026 at 03:24:30PM +0800, Miaohe Lin wrote:
> >> On 2026/6/10 5:00, Michael S. Tsirkin wrote:
> >>> On Tue, Jun 09, 2026 at 04:54:01PM -0400, Zi Yan wrote:
> >>>> On 9 Jun 2026, at 16:34, Michael S. Tsirkin wrote:
> >>>>
> >>>>> On Tue, Jun 09, 2026 at 02:52:47PM -0400, Zi Yan wrote:
> >>>>>> On 9 Jun 2026, at 14:39, Zi Yan wrote:
> >>>>>>
> >>>>>>> On 9 Jun 2026, at 14:38, David Hildenbrand (Arm) wrote:
> >>>>>>>
> >>>>>>>> On 6/9/26 20:10, Andrew Morton wrote:
> >>>>>>>>> On Tue, 9 Jun 2026 06:12:49 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:
> >>>>>>>>>
> >>>>>>>>>> TestSetPageHWPoison() is called without zone->lock, so its atomic
> >>>>>>>>>> update to page->flags can race with non-atomic flag operations
> >>>>>>>>>> that run under zone->lock in the buddy allocator.
> >>>>>>>>>>
> >>>>>>>>>> In particular, __free_pages_prepare() does:
> >>>>>>>>>>
> >>>>>>>>>>     page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> >>>>>>>>>>
> >>>>>>>>>> This non-atomic read-modify-write, while correctly excluding
> >>>>>>>>>> __PG_HWPOISON from the mask, can still lose a concurrent
> >>>>>>>>>> TestSetPageHWPoison if the read happens before the poison bit
> >>>>>>>>>> is set and the write happens after.  Will only get worse if/when
> >>>>>>>>>> we add more non-atomic flag operations.
> >>>>>>>>>>
> >>>>>>>>>> Fix by acquiring zone->lock around TestSetPageHWPoison and
> >>>>>>>>>> around ClearPageHWPoison in the retry path.  This
> >>>>>>>>>> serializes with all buddy flag manipulation.  The cost is
> >>>>>>>>>> negligible: one lock/unlock in an extremely rare path
> >>>>>>>>>> (hardware memory errors).
> >>>>>>>>>>
> >>>>>>>>>> Note: SetPageHWPoison and TestClearPageHWPoison calls elsewhere
> >>>>>>>>>> in this file operate on pages already removed from the buddy
> >>>>>>>>>> allocator or on non-buddy pages (DAX, hugetlb), so they do not
> >>>>>>>>>> need zone->lock protection.
> >>>>>>>>>
> >>>>>>>>> Sashiko is saying this doesn't do anything "Because
> >>>>>>>>> __free_pages_prepare() executes entirely locklessly".  Did it goof?
> >>>>>>>>>
> >>>>>>>>> https://sashiko.dev/#/patchset/df06b66fe4ff8e925ee0714955abc2183a727b90.1780998980.git.mst@redhat.com
> >>>>>>>>
> >>>>>>>> Battle of the bots: it's right.
> >>>>>>>
> >>>>>>> Yep, __free_pages_prepare() changes the page flag without holding
> >>>>>>> zone->lock.
> >>>>>>
> >>>>>> __free_pages_prepare() works on frozen pages and assumes no one else
> >>>>>> touches the input page. To avoid this race, memory_failure() might
> >>>>>> want to try_get_page() before TestClearPageHWPoison(), but I am not
> >>>>>> sure if that works along with memory failure flow.
> >>>>>>
> >>>>>> Best Regards,
> >>>>>> Yan, Zi
> >>>>>
> >>>>>
> >>>>>
> >>>>> Actually memory failure already plays with this down the road no?
> >>>>>
> >>>>> So maybe it's enough to just SetPageHWPoison afterwards again?
> >>>>>
> >>>>>
> >>>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> >>>>> index ee42d4361309..4758fea94a96 100644
> >>>>> --- a/mm/memory-failure.c
> >>>>> +++ b/mm/memory-failure.c
> >>>>> @@ -2415,6 +2415,7 @@ int memory_failure(unsigned long pfn, int flags)
> >>>>>  	if (!res) {
> >>>>>  		if (is_free_buddy_page(p)) {
> >>>>>  			if (take_page_off_buddy(p)) {
> >>>>> +				SetPageHWPoison(p);
> >>>>>  				page_ref_inc(p);
> >>>>>  				res = MF_RECOVERED;
> >>>>>  			} else {
> >>>>>
> >>>>>
> >>>>> and maybe in a bunch of other places in there?
> >>>>
> >>>> You mean for fear of losing HWPoison flag in the earlier TestSetPageHWPoison(),
> >>>> just set it again here?
> >>>
> >>> Yea.
> >>>
> >>>> Why not do it after get_hwpoison_page(), since that
> >>>> is the expected page flag?
> >>>
> >>> It's still in the buddy at that point right? I'm worried buddy might
> >>> poke at flags.
> >>
> >> Since __free_pages_prepare() executes entirely locklessly, the only way to ensure
> >> HWPoison flag won't be lost might be only set hwpoison flag iff we can make sure
> >> pages are not on the way to buddy...
> >>
> >> Thanks.
> >> .
> > 
> > 
> > To clarify do you not agree repeating SetPageHWPoison is enough for
> > this? And if not, do you have suggestions on how to fix this race?
> 
> Do you mean repeating SetPageHWPoison on every branch?

Right.

> Is it possible
> to make __free_pages_prepare changes page->flags atomically or this race
> is specified to memory_failure?
> 
> Thanks.
> .


Adding an atomic op on every fast path page allocation is, I am
guessing, going to slow down Linux measureably.

Doing it for the benefit of memory_failure, which is the slowest of
slow paths, seems unpalatable, to me.

Neither am I sure it's the only racy place -
grep for __SetPage and __ClearPage - all these have the same issue, I
suspect.

At the same time, I'm not an mm maintainer. If you disagree, try to
upstream a change converting all non atomics in mm to atomics, and see
what others say.

-- 
MST


