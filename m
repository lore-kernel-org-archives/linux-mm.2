Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7663CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 21:33:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5C2B6B0005; Mon,  8 Jun 2026 17:33:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0CD46B0088; Mon,  8 Jun 2026 17:33:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFB386B008A; Mon,  8 Jun 2026 17:33:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF0FD6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:33:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6DFF71C1E38
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:33:56 +0000 (UTC)
X-FDA: 84858048072.02.374CCC3
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id 94B2E12000C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:33:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bJSu6zEt;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780954434;
	b=Wi6DDOyCXWsGK9bT9WZ1Ww5CmPjlPU3k4HTD4Buq2VVCVodMAHDCArGkB2AAuGi5Fb0uPw
	/6jbaU5Y6+YlLzud0+J3sQRXeYkfCobftW6TAQ/IKHjLMobC29lTJHDMwpsYDrZzafSHeW
	74jmafkId1/SgSRgLpwHsuqLmPM/Y7I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bJSu6zEt;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780954434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OgdwZVogUbainy7/Unrt+E9dpZacJHCnboYcy2jriXI=;
	b=pjUr2wHgGohJx1dWhrh3OFVMg5OR73I2mEvuFCFjXve2nNDjUPYikgC1NNnRe+abGWMEU5
	206LyyMrWwteCqR7NBt8Ff0zXQa5RR2s72MyS/mN6ijiD957BkHyRqMVyJbFOqg8fMnnra
	op98Xg7wS6FtQAlhr4kD/k0EMDx8ytw=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-9159da9bba5so348515185a.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 14:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780954434; x=1781559234; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OgdwZVogUbainy7/Unrt+E9dpZacJHCnboYcy2jriXI=;
        b=bJSu6zEtJR9YISmsIsawSYjj/LOYAkczJ36D19z4J4SoE0hTcKdu1WSPZnNgGDmUa5
         IIqQrZP1b9h743TQW7kFeSoYvlu8sQe2OEuWUEIK/hb8oGOakf+zTRRrnkd4Jy2x6FIs
         bGaQ+tFN2VjJsnsz3FYDZ6FL5BgN0b5WXpAdzinZVrNiVko8Z1x+CwOK9hAq4upQjjxT
         oOgTleXtXXVm67HgkLc06/c8nbjPNIPs91muMSk4uOefrDnEYibc/erD1b6kg+3LOk0R
         ZFFTJOrS+Z/hHJgVQy383/MNm9hsxnIy9ZdbKiBOF1LopIv4xcF1G0168zGe2HhxdeEE
         inaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780954434; x=1781559234;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OgdwZVogUbainy7/Unrt+E9dpZacJHCnboYcy2jriXI=;
        b=RVP6cORqwCiPfwJGm/IxNJh7pkD4+KBn5/a6abtyNk07hkSJTooH4WmQ8obKuZpnqC
         37JqZK5IpesuOoJrojvmdR2o7xihg4CxrlLq9p+bNc7SmIuo9f/iUuKgSmLHI45Pqqon
         QpJjIl2+HHY19GgoCIM7zzCDlTZTowQzg1uboh6X2F0dkNNIqjVp7iF0ERSMxveKt7pL
         ik1NO9trVpaHbW/XF5zezZTQ6Xy5wuOvjBAhX9vquoaggJU7/+2IBff0rgR0ZoWop8+A
         MXcRz9F2D+MyVjkLtoJ8e2teEOPsu4/iCF5CW/C6DPbrZQ6cInhepysbKIGnpUhf6CRS
         CBLw==
X-Forwarded-Encrypted: i=1; AFNElJ/iFQnNtD0R84/QHvj28gJUdkrpwu3y02IrbhNTrnsFTHBeH8SgcwsCVefSMg9/c0oMxM+zjTWMCg==@kvack.org
X-Gm-Message-State: AOJu0YysSOEpZwiQzCCzjYHYZCPzzIsRWMGo8mdLK7VwfR8oiY45OPs5
	lIBhi6SnTQxwcCS4js+LsMxlIN8QZMrJG1XyUkag/oIuz7Bm8DVqeR7vDOdKEJgDpQA=
X-Gm-Gg: Acq92OHcEwOtwG6A7rRQsdlXdLG9/DyS8DXcubAyM8jTtrmei5dMosvul96wgJf9o1V
	pcbyxTitTan+mH1I7JMz2PpNOgv8ORaz1VzWFs5Fth/hhUpS0lHPiB0sGvbowQmTE/CoeP4FO+N
	a/pLHiTpxb1mBe3sHaWFvOokRXi4wOqYu0KE1kVFBLkEi88zkzmPa87DfplkQWn7Rk6694zJkM9
	2ws+FmME2avnJFBqX63hWUeWTavJAkBD9VE566n6tt23zT4cLxi/0ba04PamI9wZxuafsk6rtqa
	CtHN9T3fNgaUwLLeiltyJh1b8n+MWYnjsKtmRO1x6dh7TPEIst2dp7mZYadDhu5vdfqb9Kn3YhW
	YVTA7UVw001uluy0ELqbtS2J3FAK9GcVpUdsHESv6KBDLaiv9EEvdEtZaRoySnhQOPrLpm+oy/2
	nYFznjc6414vwc14vJeqhYrjM8bpjgoJyCj3YYA55Sa7meUP1NSNDJDS+f0WJWjJVZYMmMNcpvW
	lJzxmV4SLtZK0B53w==
X-Received: by 2002:a05:620a:2589:b0:915:5576:df09 with SMTP id af79cd13be357-915a9c25802mr2949853985a.3.1780954433560;
        Mon, 08 Jun 2026 14:33:53 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-915a6935cd8sm1467977385a.21.2026.06.08.14.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 14:33:53 -0700 (PDT)
Date: Mon, 8 Jun 2026 17:33:50 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
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
Subject: Re: [PATCH v10 12/37] mm: use folio_zero_user for user pages in
 post_alloc_hook
Message-ID: <aic1PoxSiHzZ40Jr@gourry-fedora-PF4VCD3F>
References: <cover.1780906288.git.mst@redhat.com>
 <f92f6f06e5804b4ea7f68b8664b7e69953b50f4e.1780906288.git.mst@redhat.com>
 <aiacZ6_7SG3nvVjM@lucifer>
 <aiblhJv_BvMn_8XY@gourry-fedora-PF4VCD3F>
 <20260608154354-mutt-send-email-mst@kernel.org>
 <aicjNRrHYOOBt0Hx@gourry-fedora-PF4VCD3F>
 <20260608161810-mutt-send-email-mst@kernel.org>
 <aicruns_4nOx0hD-@gourry-fedora-PF4VCD3F>
 <20260608170646-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608170646-mutt-send-email-mst@kernel.org>
X-Rspamd-Queue-Id: 94B2E12000C
X-Stat-Signature: w9rrcwyefpoh894tkqgm1ngt3zpdpnr4
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780954434-262612
X-HE-Meta: U2FsdGVkX18BdifX7dvHtpoW782IHk6ODNqoyq7bTOxxJCVTRlExwQnpb+DgHqOa6Lv11SpKYtz1GRea8UE2DwJnCvRzqT7LiSfxKpRYRZZYPXbQREkRhyHkD6GjsXZnAGw9ZyZ9WY7ZUUfWfthMZHFzid6kBlpqwba08lIQPGLowYmhLLywb7qiFzAsw1Qk5T2JRrU/ErGvTk1l9T8v0uaWqkKLuQx1oqz/9spGz7KrgvNnIAmoxTIXW3ppJD9VSNzJE7SAxWjm1jXpqDEXJ0H56I+E94Oul4KyFDh525IWoTIh/qoN/CSW7Hhg3gLjG8SwgrzvSzVIYXmO95Rmt2d7LIqbQy0+PkT1fSyXNPjSbhp/2pukDTvxF0MJY8QfwIzyWcKBwkpdoveAT+ZRrynEtFq1nVO6MKcpsxCrIvsIsjZPrJYS6KuFr96PVRsZ5Q6YWjNtBYqrq8RMTKwYkmmcDicw/OG54O9OoWNoHBPxv5iX7P4EHHtwxrqMsc3+L+63nsDbEac8m1pJFPjQldraAQLYjNmRI6LPL6O8NSlvLWjJOHwC7QjkXSiXUEiNIMxv3BZgc4ekXtaiqupAvB7qnDg06cWM7e4XPK8DfzHmsHLN6V7Ou8m5mmh10VmQE0oyJ6jxpx3KayVYoAz3eiCuDgwRoMHVWcsj1zYNxhDC4t7FJJ8Gq0eW58m9yfpITREWCeIIq+ylz5xcD0ggZ88lh1skSIHcre65/OAvKGIe9Ka2Dv99W4KZLTrop/Iu+wYQ2Gaw/2lkCAzfkenhiUaW2YguDQr2Dh11m51/MGnNHrXBuzpoj5muN16YLQEeW6o0yfdjOPFvLJHA5h7m5l7MvrpL3Ug74BKgn7u/FTltlOGgYuPoHTKP/IhPWWgN9VGWeNxSd9m1oJVhuGEeVKJjiU55mAj40YkKP9zk2tOM1JFhBSH3az/WP9lmAXLImY07PEvoV4vXaB2kAbg
 bpco6e2k
 5lHToZDEyThAB15uOc3ofB9gb5FQlog9oCE6xFnZcL+WvLx2JEQosLxy+RJPNJJc8uh4MBrUNWLK7MKZe1Oy903f7ZV8jme6aK/qp5kDNlqb5c/fnFxh4kyaplI5Usi4JGhlzw9g4tgzHOGI1OfNgK7osram9Y3TaFiiypAMAogPBLiEo7y38fEw7dRBbFNYuROuHr6MhCdv2iXYvJ8Hv9sIlOFcxfwBHZ82pIYVlQ8EazWA6SGLvjDwf0cREQuyp4SrIBHf3DZhlmlnfVhZfUQVJmQiDvG5259zNXRN/V6/ggsLoKbTf6dGdQJSvagKpL8+YSjjHouscya4CETbZCm7OnxYGvqrRWelwfWllLIlFmVinFVSO2amF4naE7Tf6Bgzo9Ueup7yjhqp+X6caBClk3nRR7RU9h5bIpmMLXBEhCfV1QDchfU9Kd45rLThLJ2l0qef2JSltH+M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 05:16:53PM -0400, Michael S. Tsirkin wrote:
> On Mon, Jun 08, 2026 at 04:53:14PM -0400, Gregory Price wrote:
> > 
> > As a start:
> > 
> >   1) the user_addr and zeroing piece seems like a discrete
> >      improvement worthy of its own set - aside from end goal.
> > 
> >      This is needed by your patch set, but was requested to
> >      try to push us towards a more reasonable pattern for
> >      folio_zero_user().
> 
> What I worry about is people can't agree what api they want.
>

Oh that's just our base state of existence.  We mostly agree that
all APIs are bad in some way and we don't want any of them :P

What you're looking for is to get people to agree to the
least-offensive, least-worst option :]

I don't think we're far off from that.  I suggest doing as Zi said and
start a [DISCUSSION] thread on specifically this and lay out the needs
and wants and design issues that you've learned from the past set of
versions and continue the discussion there.

It helps to take some snippets from your set to lay out what you've
learned and explain why you need the folio_user_zero() stuff to get from
A->Z, and then let maintainers hash out whether that should live in
post_alloc_hook or new interfaces (or outside page_alloc.c altogether).

> I don't mind trying all kind of approaches, but it seems to
> be past the point where people feel it's costing too much of
> their time with all of these revisions.
> 

People are still commenting, so I don't think you've gotten there yet.
I think the rate of revision is what's costing too much attention.

You'd save yourself some revisions by taking the attention you have
right now and starting the discussion thread (and consider submitting
the topic to LPC if that's something interests you!).

All this is to say you're doing fine, just keep on keepin' on. Maybe
pivot your approach from iterations to discussion for a bit until the
opinions settle.

~Gregory

