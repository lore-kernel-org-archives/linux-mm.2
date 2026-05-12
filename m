Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9A23CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 18:06:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18D316B008A; Tue, 12 May 2026 14:06:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 165296B008C; Tue, 12 May 2026 14:06:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 054316B0092; Tue, 12 May 2026 14:06:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E9D116B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:06:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 827B58C2C0
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:06:42 +0000 (UTC)
X-FDA: 84759548244.27.8801469
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3BF4B180006
	for <linux-mm@kvack.org>; Tue, 12 May 2026 18:06:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DVHe5xrw;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778609200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xc/NhkzuaZoAdTp3ChNwKwwR0U6LJ0GRCb8Tqmiuz2M=;
	b=zH/W584AASW3/CnY1tsb6eNP1yoXqdknFMXtVJ3K0z7Wyh4e9aa/PdTw8VpQVqQFIdFjaq
	U2/z+vRnfJTRLWcbnbNgQr+b7SuI4skzeavjFkAgcZbZNs5V1eK2Kl0WA2R++eW4CIvm/V
	MK2LhBfUf0EXGOsdfJNTL52TEqJmrCg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DVHe5xrw;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778609200; a=rsa-sha256;
	cv=none;
	b=daV/wj3LXLKR4Q0P9JEN841B84YYk53JMliqjzCaSXHbwe/fQz1FqzeK1TlUpeVAcuHjqH
	24N5spjcVu/AzygXO1G5C0WRLmWOnEyel+pNpfD4Y/4BN7oVpDG/wGxeCgPy9tw/WwHV42
	jUDYysLM4w0gqrWmptxQpKhNslCkWRU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778609199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xc/NhkzuaZoAdTp3ChNwKwwR0U6LJ0GRCb8Tqmiuz2M=;
	b=DVHe5xrwi6hwUrWG1b9SpO9J4K4T7/uH0UNyyQTeAy6zL+uHbBVfdJ4NySkTe88xUYF7j9
	83rMKOqRdWX5M4zyf872sWr4PLVYVr5MudQcJGc62BbvV+wUT2IJ15aRpIF2oy5EYhbtJy
	zBCxC+Kj7APyS109s8w63Xj7Hh5/tsA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-50--hRW1N_QNsaD2cAyKQ6WFw-1; Tue, 12 May 2026 14:06:38 -0400
X-MC-Unique: -hRW1N_QNsaD2cAyKQ6WFw-1
X-Mimecast-MFC-AGG-ID: -hRW1N_QNsaD2cAyKQ6WFw_1778609197
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-45b7ff2140eso705294f8f.3
        for <linux-mm@kvack.org>; Tue, 12 May 2026 11:06:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778609197; x=1779213997;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xc/NhkzuaZoAdTp3ChNwKwwR0U6LJ0GRCb8Tqmiuz2M=;
        b=tNAAUd9oCArfmnOREGO4Y0JglBcsQIss1VuSI6PYBJQ7/MaI6tay9VmC6JzdGfjiXr
         TXSi6vjoFcrdRS+fP4iS/ZN2k3xMX0XM7Z+Xa/HLfTkQ38n7U0D5VF+PCRlXWGj0frMs
         W1pDf92SQ2IDsJsPxOqN+x4a9Gl56C/LWRBZ1EumyoP261PnQDtCFVhBLYVoFO1BSZjb
         sef2cZ70etXG6ww/Sdq8qcPs6gjeXeMIep6pdcwwg+Mde3Dz5w9yV8gdOh2vJvwIDXuT
         tHylDKFtZ7buXQLcj7mUmlCrLCxPOGhJmWxJw9epwPM3DXNjbRLYgBpKHzBPgpPwHI22
         LzUA==
X-Forwarded-Encrypted: i=1; AFNElJ/4Uc/jlup1wC4uWTPkGt9VRFrnpBnujEK9AWEJ3QXONI9WgD7FTlMKCwTWuf+2dReoLB0NNuXwKQ==@kvack.org
X-Gm-Message-State: AOJu0YwRg6rw+gfI6ohzjU5+7jLCQ2L19b7OmHKBKIZXrN0zPW1R+XQT
	U4rcSxy1R1AajpzXZK5TEc7lF4lO3LKkYFVmzqfD1zL2/6nvtmPmhbJPmHjzr905StPEaAtEMKq
	bs5WVJav5y9zc09NDlIPp0xIMOe0pFjceYbWepw+tInN0LGUVrOW2
X-Gm-Gg: Acq92OGCg1aD5r0IifM1FuIrykpyU4+c1UC7/pfakORgwiSPdbg61HN9SWNiVKazcRW
	DWhpgW6nnCoJ+r/2+nYaSQiAAIJGWtDQpMSe04lb1OXN0MiIJkc72bMIAWTzRVuc198NcRTFvbi
	l9Wbbqrj6x4e7vtbaI0FhFX6OsI8Li8WqcO8lEtxb2fC05pRh8qpnyLyz1RVCT1+stpw8PZYYde
	uQeK6MX2Njb04iRYI8YyT+f2x5oqtjneowv2sIXypodh7TZejYycIlX0RAcNI5rQu3t+w4Sj0a0
	x+JzS3lAG4Nk6D7tLbZHpbTU24FxoDkMZPAgupDzw2GNgMLKBnJfnc6E09xL7XlhEIIuuAU7ziz
	TaL/VjUOS+lzLlBHajwwt19AoQuq96evrl/nQeMPh
X-Received: by 2002:a05:6000:2311:b0:43d:6244:f8b with SMTP id ffacd0b85a97d-4546140ac8bmr30487484f8f.13.1778609197042;
        Tue, 12 May 2026 11:06:37 -0700 (PDT)
X-Received: by 2002:a05:6000:2311:b0:43d:6244:f8b with SMTP id ffacd0b85a97d-4546140ac8bmr30487412f8f.13.1778609196463;
        Tue, 12 May 2026 11:06:36 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45491ca383asm33507368f8f.28.2026.05.12.11.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 11:06:35 -0700 (PDT)
Date: Tue, 12 May 2026 14:06:30 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Price <gourry@gourry.net>
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
	"Liam R. Howlett" <liam@infradead.org>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>
Subject: Re: [PATCH resend v6 03/30] mm: thread user_addr through page
 allocator for cache-friendly zeroing
Message-ID: <20260512140254-mutt-send-email-mst@kernel.org>
References: <cover.1778489843.git.mst@redhat.com>
 <9b53972f4854c1064b92cefc464f51949afeb83f.1778489843.git.mst@redhat.com>
 <agH3wceKcPNmixCj@gourry-fedora-PF4VCD3F>
 <20260511114853-mutt-send-email-mst@kernel.org>
 <agIJOkLhTOsvJs1-@gourry-fedora-PF4VCD3F>
 <20260511175032-mutt-send-email-mst@kernel.org>
 <agKViOG_YQci0ffN@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <agKViOG_YQci0ffN@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Y5av0Qb4vZMT56ovvz87F_Een9WRurrlN1TEDIXx0W4_1778609197
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: f4rnijnb6dc5pah9n1ug8xtgqhgzspqb
X-Rspamd-Queue-Id: 3BF4B180006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778609200-580023
X-HE-Meta: U2FsdGVkX18+Sw7y+exW4sUvQMuwwbPBtVATTjzEqj7vE3cQqMcjbnUPW8MWAGv9puETvgl5ZxJOfg0PDdzbd9j3JdNVUXCWCLh69+Cq/R9xEAg7axjt2IrtgpzzNOC0pdKAYnKBzvfq6r2W88ZYyFSWKyFJB/I4EDBYDv8y+g4+9KkhuNl3FefHQYqZY/QOny8PiCoAZpCNCxdomo27kGnXaoa+TA3sWMOHXRb7Pd9kkdAvQyti6UlR3iUO+w+AEjyq8A9KYY1loe5Rj6u/lGxhPHNWzpGBBJU3sb+DypXFQErq1hnc/dmoAU5HAL5+ulTGwW3zEBFlOAgdp3ILPHrzt0mPwWatj9aUUUKQ5wCuKR8x4xcB+/phdjOSjDJESO01dD0u6AfhBfSojVuNGtShhjfJdnhk17U5uiyyjmSNGY0GCiblGjjMnJskf95ON3gaB4hoW2s4EuQTIksOlhC5c7Pb9p57CgZVg9nbkTuECIVNMvFlD6rsReHCxaL/H1mjD8VYwaMY83tQlkpH55j8Ps/IXl+PrDWn2fg5ZIvDTsfM3IU29JQsz52CD978Ph/vbwY3wDzot75MQNWU6YaSflSoFA/TcsAPolw84C856ytz7EGXvLwJyQuHMM7jVtuOtwRzhcA+D05oKrCqsnItSkZkWwKbGibldqBPqRIIQWOd/c79icLNUTbKRMsjIZeynoWkfRta/TLnZN2DyLx9XZhpk0fnbgTh66jgPxwV0/jbtREz2X9gPHvk+nyhngIJeGrt6Q2z+QPsnSyyKbICYTNsXYzfNQOTUOmYmot7c2fl2cNbr/ceD43xiBzKTUflBKB78YX8syB+simODdnXtRhPFT9ogK0gU0l3zpbzWIhMUs8Eaj25Jx9F0zvN+0N3USWODCp99Jjd75R7PyBl1qTmTre4xIADNQrsox0Eju+wDFM/xf9LdPvZyZPmIPcv7Uiu3jiyB2p0Tw6
 h/j/5pa2
 JIXjC24bP74qPf6+qYKMTvYdU8epIC/YmekLPrOLH9A89tnMAiUAFuBjTfy3KDWS9fXXSYJjkrcPHfBepl21Q1kIFS0+IhLfUARvOaguvfGsMSLE2e4tK4jDTxso0SnAFlvy4ySuZp0mFv/xKT1cXkEdumLqDpXmx3IzKWeSWjBH3UYbS/fSMij/SIIpHMDnCp/RNuhD1a4yYX/fuK8fKCgf3Em8J3t5/Zml/roAVPlJa3/RlR2vJFs6twL4u76ieLZdckN5tjow8dTbo81IQ2m/8PwEMDQ3Hshwz2qLfxbrss/quWSkaM5zKcKrc0gXAajaXQtXCWL6sNWWTYY+OhyvKNLVtGOGLAoqXYN1N0LxJBkfkIrJVgkpaMgzIkeOG5JXnb83c9yxsjENMRrXDnBBgyG3lfuQ+Xy10
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 10:50:48PM -0400, Gregory Price wrote:
> On Mon, May 11, 2026 at 05:59:23PM -0400, Michael S. Tsirkin wrote:
> > On Mon, May 11, 2026 at 12:52:10PM -0400, Gregory Price wrote:
> > > On Mon, May 11, 2026 at 11:55:40AM -0400, Michael S. Tsirkin wrote:
> > > > On Mon, May 11, 2026 at 11:37:37AM -0400, Gregory Price wrote:
> > > > > On Mon, May 11, 2026 at 05:01:55AM -0400, Michael S. Tsirkin wrote:
> > > > > 
> > > > > > +/*
> > > > > > + * Sentinel for user_addr: indicates a non-user allocation.
> > > > > > + * Cannot use 0 because address 0 is a valid userspace mapping.
> > > > > > + */
> > > > > > +#define USER_ADDR_NONE	((unsigned long)-1)
> > > > > 
> > > > > Ehm, hm.  Does -1 hold as a non-user address across all architectures?
> > > > > 
> > > > > What about in linear addressing / no VM mode?
> > > > 
> > > > this is used on a fault. I don't think there are any faults then?
> > > > But maybe FAULT_ADDR_NONE would be clearer.
> > > >
> > > 
> > > Meh, naming here is less relevant than the sentinel correctness.
> > > 
> > > My only concern is really whether -1 could end up being a valid address
> > > in some horrid future timeline and this all going belly up.
> > > 
> > > Is why I asked about whether this is correct on all architectures.
> > 
> > I think the answer is yes: on all architectures Linux supports, the last
> > page of the address space is never a valid user mapping. The kernel
> > enforces this -- mmap will not create a mapping whose end wraps past -1.
> > 
> >   if (addr > TASK_SIZE - len)
> >       return -ENOMEM;
> > 
> > 
> > So the maximum vm_end = addr + len <= TASK_SIZE.
> > On every architecture TASK_SIZE <= (unsigned long)-1, so vm_end can
> > never wrap around to 0 and address -1 can never be within any
> > VMA.
> > 
> 
> That is worth documenting at least in the changelog if not the comment
> with the define there's a clue if anything ever changes.
> 
> ~Gregory

Actually that's one reason. And there is *another* reason. Almost all
callers pass vmf->addr in there (with hugetlb being a single exception
using vmf->real_addr). So I changed hugetlb and now everyone always
passes a page aligned address.

It can never be USER_ADDR_NONE



