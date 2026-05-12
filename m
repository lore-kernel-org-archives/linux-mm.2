Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4FC7CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:06:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C5ED6B00AC; Tue, 12 May 2026 17:06:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29D4E6B00AE; Tue, 12 May 2026 17:06:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B3BF6B00AF; Tue, 12 May 2026 17:06:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 08DB66B00AC
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:06:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9AF951C0DB5
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:06:23 +0000 (UTC)
X-FDA: 84760001046.14.4F23E16
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8CAE21C0008
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:06:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MhIHUzl0;
	spf=pass (imf20.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778619981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tom/uL+543XR2YP2OF3z1y+v/10GzcsXvkyBJuLR6so=;
	b=tGPxsNST4NIxA6nJ9ygiuiufPl6RxKLUes6WsnX8NkQxoN+xebTrRqWCEAOKq1aWvx7GDk
	18EuIxbXW0taoCoWI83rgaMjP2wkBdyZzHvASGPrd6Cf6pARfVbXrEfV/sj/FnBG4TBFS6
	O642HJe0JQQXh9jWEvDO3/8+q9nonlk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778619981; a=rsa-sha256;
	cv=none;
	b=NBejjvs4gLaGlPzGe/0nE7OxHbsDnawYAZ/p+/JAOmj3YVuupiP9vay35Ph+D3oO5z0GdS
	u12EKYj+nHWHfOQzqZxYJdMpSeqQ+MbR9z32iMZgr/MdUw+smpuSztlRRTgIoViLifS0+Q
	8Vr2Bk4zwdgPf9AulL23xDOsfoyDMTU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MhIHUzl0;
	spf=pass (imf20.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778619981;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tom/uL+543XR2YP2OF3z1y+v/10GzcsXvkyBJuLR6so=;
	b=MhIHUzl0AFjHeDjGjmcOTAa0I/MXZcckpM8+Kpb0CSTyFInQub2ViiQtcVL2l4Zh4YjrR1
	4lUfbZa1gqYXZQtiL7B75Xhn642g8RfvGGK9Hj2G05eubT0EDuhRwbeKsgUNHs1856jdgo
	bA7wnuMaWuVOdTLVqD/tf3Fpw5QSWFs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-416-omwT6-GUNgCiuipz9oGFMw-1; Tue, 12 May 2026 17:06:14 -0400
X-MC-Unique: omwT6-GUNgCiuipz9oGFMw-1
X-Mimecast-MFC-AGG-ID: omwT6-GUNgCiuipz9oGFMw_1778619972
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48d046fac74so35019655e9.3
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:06:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778619972; x=1779224772;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tom/uL+543XR2YP2OF3z1y+v/10GzcsXvkyBJuLR6so=;
        b=WKmzxFHO+zAU2v8+nIIX2c1F+fX7KKtq2baS59HL8voTB8pj/Ngt64vYtnN4h18oCe
         Z29nE6kR1U/AB0AS/gcW5M9yLkVVFZ9AOhNj2UphKPWx3Ro+EAnCmq04Wal1Y6UtXVYM
         6oBfuIaxWuBqnFcODAYM8gNyKgv0leR0ehT2B6Yu8iC5LgyM8kysXtUa+GcSvC0Z2aFQ
         +wqRM7hyda3mlhbwDHw2Y6GEM2nNFiheH5Y7hCjTF5CrP+nA5e6Mg5bVChAhDulAqOWX
         Xb9LLfbj70tCcM1EzeP2IKReaO6RHPKYvr5NR2e1iVh6eYEnCQUv8UiRKJZ9wVWGnwUZ
         FHAw==
X-Forwarded-Encrypted: i=1; AFNElJ8Pihxr6d6y4qWr4oK1RO2O63vwenMunU2rl0mpb+0efWMAhAJHK+qRonJYlWAqWQpB6x51DFtUJw==@kvack.org
X-Gm-Message-State: AOJu0YxwcjjIgG+hUDnbybl+Ev48JS2SKgPZbUV2r3af7Com8ubqL7Fp
	ITo8TX3ISQ2VNFKZ2kgIRicdzYBHsoJU1zgzaGQRBA2tTz/+exH/hZkbmcwz3AHDvkfvGWgo5aE
	YKnlSAxNWOuLse8Hqau5mG/Ik+2jbDfviVDHEiOScOqlgbUMDcWSx
X-Gm-Gg: Acq92OEg794F7Map3eYsrgTBG4CI+LgPHHt9v0yTrsihsN2J93cvxWxoys28jwPTF7n
	nmfqJzlk7T/fRUUBDvXEvrBS0ifvcBFSxSPZio+Fe01fXw/om+ywLPbeC9G+0yml5XqPFwV9FEN
	7SC3GcDe+4Rjv4ScSLNJ4SH2c01hTqR3TAuNnNhl6oHum/xGgTRRYltL2VqrwHAyFHL/cUekldI
	IuKZG6VkHfUkV8dCjwqhSOAN5yN8LCfg/TG7ifxdMzb7UiZb/1xCz6KciZ6gzrvsF+to1DM5fiL
	Qbzv8sKhN+zRxghIu67fJ+MjlvenNJxwPG1l21i8B08P7MbFK9Dj+cvQSjOuh3La8CyG8AwaWEK
	gmWu3G977jdTgzAJ7NX/aQKXpYnQzW/QrbcHRsZrY
X-Received: by 2002:a05:600c:3507:b0:489:149a:f9e6 with SMTP id 5b1f17b1804b1-48fc9a4a5e9mr5880245e9.28.1778619972381;
        Tue, 12 May 2026 14:06:12 -0700 (PDT)
X-Received: by 2002:a05:600c:3507:b0:489:149a:f9e6 with SMTP id 5b1f17b1804b1-48fc9a4a5e9mr5879965e9.28.1778619971777;
        Tue, 12 May 2026 14:06:11 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-454913049ecsm34251392f8f.19.2026.05.12.14.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:06:11 -0700 (PDT)
Date: Tue, 12 May 2026 17:06:05 -0400
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
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH resend v6 20/30] mm: page_alloc: clear PG_zeroed on buddy
 merge if not both zero
Message-ID: <20260512170525-mutt-send-email-mst@kernel.org>
References: <cover.1778489843.git.mst@redhat.com>
 <a09c1848702368c3545b980c17101b5185ab774d.1778489843.git.mst@redhat.com>
 <agNNkvRK128bYhrf@gourry-fedora-PF4VCD3F>
 <20260512115805-mutt-send-email-mst@kernel.org>
 <agNWFPBTBszcq5GP@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <agNWFPBTBszcq5GP@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UOYA2j38cyiTSMtdaWh27sD-Z80GC-0M1aS6f6KnvXE_1778619972
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8CAE21C0008
X-Rspam-User: 
X-Stat-Signature: i6583ppkgh7rtazhx7qrx1c58owx5bgn
X-HE-Tag: 1778619981-283554
X-HE-Meta: U2FsdGVkX181PFeO9E6iEV1lnSBp9Spu9eYPyUNHgIlInKd2xfRMrL0iJ3KEaduhIE6NZwnIK6A1qmCvLEBvYEio7S5OkQqTCETKW29PYcFVAenEu7f0YW/yXfEKtAadJIF6EzFYizbBafieo6zAsIjHqLCa8a3qlM579fDwUN9cAmAuCiuBOhyrUe8Pes2s78g0V3g+7Jf2LAeAg2/3bZWxxLSAyzL/5kXjb1et/t1ctDEW9MaZ45uZyJkAomPQymANJpYCLFhzh4MPHnx8vmjqm4rEJ6Ev9VDhwnJoNhB3KfUE59emOm/TycQYBNg0EdyhqhUsUTi/WVvb0mIpKlaSWuvgD7iruoF1pIyreQRcs6bUte0HT1asLfjNKbx4tpuVueaOZwy2jyjPDxL/ZFq/hK1COLi/GX7EjyDlLwL9t3jsc671ByMiAwseK4sga69CTTYFotNJiS1J4i0vai4H6QCAOvsPx9jNiuytImGYqYiIETCgF+tSGEWcEexGOUsAVndgg4Fvwnkw5RuIhowY2WOtBRAbjfbc8V+oRu05AIFULFMGbGu4T2Oc37I5zo5wvw9cIvp0GvFOktMru5tzVRC8zLKfhxSDsDhM3N1a8Q87vd508a4pN610xc1V8Q6GUUtjGK+eHnoL9wcdzBxpQKRDbx4y3K7j/ioSQskPJE4i4+j/Lbl1t2xSp7A9GTHdCE5mmzcYGq1OqvZ7RaNAcoEMY89D6jvqveS5lqzPvZcAqMXuPk28YbImqtTzcv69wpywlyON0xIDGGKQHhm/x2CsJMLkyz3EPgxPExdda3bRm5Tix8o8TAkEGL9ivRFnNfhS2BqTjxllJXXJpaYLdq4pO0pZUtVGJDUs4ZHKcdyiXhwpC8Trqacdt4AJseQ7KK4igrEi1WBSPPLg7SEs4p+Nc91ffNK84uNsnMaU1okfOrr5FOltGAUOPps9ehJrWA0eCAJ5KdYtF0L
 k9NOaiTP
 gD0wrEfeGiucOsdAsKxxyFFCVApwhmGaqDu+bDaLAEJS+LgNC0w6I4MzSnmxieZBW55year1Zlot1pQoaaoMY4/k2y7V7JZEpQ1yfR+99gI889cfvsQXvAuiAacgCGt0uE5x89TYsu1oqIvK2FNe5z113dYFKusc4dU242YvLLw2toShiVkF+AIbX8j0mYJzcxP4oSSWtivaTn2CAh3+P+GX/kigHhSU8r96eWc6uv6h+jRsnwyjFpVF+C3+3Rwo0vStPIvPRMry4R589RKtG8HDMXcYu5vZhgihdH3vTEfwNBjyCMn9Ne8X7t+AvoPtrkEc92QXqYpaW5BNdPTzP1P1V/iwXGTqqmUbz0OB7MsznEqKZIMLzgzLbj6aStmB5MNUxUbK8SF/vyNs8jfPk2CQ3B+ObmOpRJ3h1shuJSC1d+s9w+lXgKwli4zMr51ybVJEQP+UzRL7yC4MPmYTEDPsVAJLR0P2+RzSccbXgIBcR8jQ2uXp3ODjtjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 12:32:20PM -0400, Gregory Price wrote:
> On Tue, May 12, 2026 at 11:58:27AM -0400, Michael S. Tsirkin wrote:
> > On Tue, May 12, 2026 at 11:56:02AM -0400, Gregory Price wrote:
> > > On Mon, May 11, 2026 at 05:03:35AM -0400, Michael S. Tsirkin wrote:
> > > > When two buddy pages merge in __free_one_page(), preserve
> > > > PG_zeroed on the merged page only if both buddies have the
> > > > flag set.  Otherwise clear it.
> > > > 
> > > > The merged page would inherit PG_zeroed, and a later __GFP_ZERO
> > > > allocation would skip zeroing stale data in the non-zero half.
> > > > 
> > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > > Assisted-by: Claude:claude-opus-4-6
> > > > Assisted-by: cursor-agent:GPT-5.4-xhigh
> > > > ---
> > > >  mm/page_alloc.c | 15 ++++++++++++++-
> > > >  1 file changed, 14 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > > index bd3b909cacdf..d70c9ba6b329 100644
> > > > --- a/mm/page_alloc.c
> > > > +++ b/mm/page_alloc.c
> > > > @@ -940,10 +940,14 @@ static inline void __free_one_page(struct page *page,
> > > >  	unsigned long buddy_pfn = 0;
> > > >  	unsigned long combined_pfn;
> > > >  	struct page *buddy;
> > > > +	bool buddy_zeroed;
> > > > +	bool page_zeroed;
> > > 
> > > If you want to play some code golf, i think you can get away with a
> > > single bool here:
> > > 
> > >     bool zeroed;
> > >     zeroed = PageZeroed(buddy);
> > >     zeroed &= PageZeroed(page);
> > > 
> > >     if (zeroed)
> > >         __SetPageZeroed(page);
> > > 
> > > ~Gregory
> > 
> > Does it matter? It makes my head hurt.
> >
> 
> Less code generally means less bugs, but this is more style nits than
> anything.  Either way
> 
> Reviewed-by: Gregory Price <gourry@gourry.net>
> 
> ~Gregory


many thanks for your detailed review. I did my best to address all
comments, and sent v7. 

-- 
MST


