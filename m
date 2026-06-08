Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 692D7CD8CA4
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 20:33:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F9BE6B0005; Mon,  8 Jun 2026 16:33:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AAC16B0088; Mon,  8 Jun 2026 16:33:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 799FA6B008A; Mon,  8 Jun 2026 16:33:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6AC9E6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:33:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 390AA402E5
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:33:47 +0000 (UTC)
X-FDA: 84857896494.08.6C53DC1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id DB95640014
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:33:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A4dI4SXr;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780950825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W1CZWnaLjy4XWhYnDZ8ZzqFQF7H0uYCpTeSCvjLh0TY=;
	b=c1BqRg9iSaAOPn8/g3JVE+FU2NdQWYq2uOslX/GuwKffrAgR2qhK0r3mvHroiZ+EzlFK5Z
	2PRvZYOuD4HjqfDw5GkFYifjDuOmEXOPlN9/NBguATRGDZJx8Z8ioVr3zovFa/r0962EbF
	8vWREazUI24wHIzqSFr8ySDGLxFrthE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A4dI4SXr;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780950825;
	b=JzL7iXrOak329WKLWcfi26Vxgqu8EuyMViZa25KdJFMzM0ahx8iAUbkJSyJPVfef71rMW6
	aMKuMJmn0PhBDhO7MnjswGby/DK+1AnVtRm4VJubNrTvpOcSGnw9X8xidjSgvZyKbEuuAY
	urppJ9ZpFQjHsIRB3VLTzgwISfdHFaA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780950824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W1CZWnaLjy4XWhYnDZ8ZzqFQF7H0uYCpTeSCvjLh0TY=;
	b=A4dI4SXrgUIq7yE/IGJAwyJBxES2fB6Wg+ygOfvq3cqtduT/KAH6bs5f+m6PThiAtjh/8R
	r4EtQ/G9W5vipN13wZsvaZu0ueOfodDxnLWnDWlA9CyTHU3j4zw9FT5Z6szItYjTYMeZMX
	iMQOw0luxGBXizQrHBKcpQ728sAuwEc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-245-hlC7RHYSMa-xvNUSHPRtWg-1; Mon, 08 Jun 2026 16:33:43 -0400
X-MC-Unique: hlC7RHYSMa-xvNUSHPRtWg-1
X-Mimecast-MFC-AGG-ID: hlC7RHYSMa-xvNUSHPRtWg_1780950822
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-490bfd70b0fso49312985e9.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 13:33:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780950822; x=1781555622;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W1CZWnaLjy4XWhYnDZ8ZzqFQF7H0uYCpTeSCvjLh0TY=;
        b=GqI0PNIla7/RDLLxxKk7neXsW+BhR5POCGRNvhk5f28GJAl093OUpzuCd8rPjTITJ7
         EBjASvopQXV3Nfd/8qljcyYKB8CdXV/XCpe+oZiYrm/e2EJQdANusMshT1ZJX/zHF6Zz
         td3qK3XjpnUKixSlu/PQTXxjjP7GeaU891yzdMNVpm/3SORI/2zQpcFiAuy6Szjfg25J
         og97ijvcBv/wfREMpp1fYfjGM1ojrmXgL4xFLXNDh+3dG5oVHg2XRQbjzQ00La2V52Vk
         phodDdrPMZtg5qUJv03FUyAwmE6/lWYMpiVgW+bWbCqkxKTz094BH7lZxMAp5t56Luxi
         OgcA==
X-Forwarded-Encrypted: i=1; AFNElJ82tdFvyMTioDYWVFzySZwrnRN0QfBwM57Qy9k9HfOPAoT+eI3Z6oP0LqEd/z7lwDtsziTxmBbA3g==@kvack.org
X-Gm-Message-State: AOJu0Yy6zaj5YM0GYgUYWWu3FLbneSBX3XGXL3wKLszOOqhmwmqTZCdY
	3LQb+Eq1XbKbZCZIdr1/t5boUf7qMopcK1QM+jOCnis3NNubeExXgO51PbMUa0ofow2GpTjHMuc
	29ZkFWbRzH3SLpsIUuJvfKkfUPkkPfw4E/gdYLJS+ng9yGum7z4ck
X-Gm-Gg: Acq92OHowLeRaL5XM0EasLONY0ghK16T8uZ4RYkdqdZal9l7wvym+MivmaoNYq27cwK
	NDvXEZ+wduNMBFSTazp4InRyU9bCfrU1JjfKas6hK1HAzT27194ZRvtAHFPBFAuYINac/qs76zm
	qWKlp2zxzazwosnya0H3NNun3y1AP+9xZ2BsqMuIzYYEXxkRrAJ0K6pYdO/nmP/x12zRHNhV0FG
	FmQunTOQ/2ZRhiOea5yNHw6AoQzi/o5/UEGaq+8dGOy4lo/3gi2Zmf71Peoy4SY5IGAkHOeqGex
	NpAWlKz7TCXiQ2DmjwkQ7ix3G4duF1KseHs9rRNyfJgIrQLr8/Y5+WxAixbr9+ApJJ2WRaQyRwM
	4i6g2fCIHlkTQdktCQy1jY29kdLrjpvPOPaSd5TXB+mIxkxvo4oATGA==
X-Received: by 2002:a05:600c:3107:b0:490:9588:bdb6 with SMTP id 5b1f17b1804b1-490c264cc2emr292104365e9.33.1780950821746;
        Mon, 08 Jun 2026 13:33:41 -0700 (PDT)
X-Received: by 2002:a05:600c:3107:b0:490:9588:bdb6 with SMTP id 5b1f17b1804b1-490c264cc2emr292103725e9.33.1780950821331;
        Mon, 08 Jun 2026 13:33:41 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490c2d52e5esm196804455e9.2.2026.06.08.13.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 13:33:40 -0700 (PDT)
Date: Mon, 8 Jun 2026 16:33:35 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Gregory Price <gourry@gourry.net>, Matthew Wilcox <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
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
	Johannes Weiner <hannes@cmpxchg.org>,
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
Subject: Re: [PATCH v10 07/37] mm: thread user_addr through page allocator
 for cache-friendly zeroing
Message-ID: <20260608163257-mutt-send-email-mst@kernel.org>
References: <cover.1780906288.git.mst@redhat.com>
 <50d410b47fe3f45327783e05bd306d5eaab75e65.1780906288.git.mst@redhat.com>
 <aiaUDTeHDA45ZXFS@lucifer>
 <aiagMc9Ng_AE_adh@lucifer>
 <aia93IzhTgi1vGi6@casper.infradead.org>
 <aicfERTP3H6AndOs@gourry-fedora-PF4VCD3F>
 <D1CF67EF-2CF1-45F8-9265-70A528C1CB01@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <D1CF67EF-2CF1-45F8-9265-70A528C1CB01@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XYV3B1ZkADja5i11zQVCN3mAfzGHSKhaY_-UJ8Q4NlI_1780950822
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DB95640014
X-Stat-Signature: hcueq8mcpabu7t63y6bnyd6c7a35imeo
X-Rspam-User: 
X-HE-Tag: 1780950824-958407
X-HE-Meta: U2FsdGVkX18NFBdgg7glepD35u7zMtALzZuTKijHoJtgYcKc7fgaFtlebQ1MkN4WgfhW0xSpn+BZNDIesHmIeOI/JhW3EYjv0PEHoi+mluLSJN0wXeK7kP0g+Kjsu5+MG8Nhb5oiXV2gBjULeSD0D0tZ6jUQvemuOsbcMO8ZYYF5e3H2QAKyqfs+GT/Pune0ap4Wcu4aUryqyCqQ2cHT6bNZ5ycYOKIAJcR2begKV5So/wv7TyVy5l/doLJeJByE1PxK6atne42RB7wXAVRhr48XlrB5I0J/OOUJ7sAsQNEIXwLt2Savleckb5UUWlwsIKsGJmTg+w1cPa3SA09kLSwSTH8z0iWWJuuh23/RiutmCfebZojsoHU7ZmM/+fOmYHY/Nd41YaoJVFWR6zSNQVhV28vawkdsPnZiT/mrCDFS//NItzHARqiOa7Sx7049OcTW/o6i7nvmfi02+eRRiIFjyp/G95il5ejmsFlfm/QzyqH8cLBplFuoyQa5t5XFJmtkoaiUcz/aLyk6Sx0Ei3MHMBETEZrK0f+3eY8oFkuMCqs5Aa3C/uAkHkvlIkSRo9KzWchg72wYh2ozTTl2U8mCQzCvS1Acs+maVEb9y3BXCJFGqAFxqD8WEyXPTJICeg/aByS3jyf2jyXVUBMpMAFnZLZbDyMEqBbjE7EjGtRCBxz637eQV3I4TC2uEdo8KB2nMAgrYHF2aaW4dV/6dfmVM9aKRNHIeAnqWP0se7Hbm6XED7pZLYucS3k2E27aJWDoc3KJed5ZS9LQ7vMJKCqr7hmutkQBd749Vewlr4510FjPeyI90at7NaR2AMp1VnJ7xLnHNze5kVYLaFRURr5f5N4h0IZt1x8iUpaT0gOJA3fo2zuM5nTTZVwkXJ1GgYUM9KeWYXSRAdXmuhUif7y/94ovmLBPdNXOjE8VGNvHa8PSeNOKYwi/qOlSmakCTahScM48rCqVcHgErKk
 e4OsLS2i
 O/c8fcMrx149lLU/fJdDJx2wKz8bmjZVPdQq3Rjd9I+oRWdmUkWxGSkZZzGvbY0LFzi+SHaM1ukgL7TfupBPs3uYv0xj02XLudLFrb+WMCWArLzbO/WjCPBQ43a5yuP90wh8mBSIK4uRufWnem2JIormleRPBWx2PQ0+DtkK8OBVWLcfda2OOfx4Y9UP9KoGD7iGPcrgobQTPEN+ewmSkSfHhNq6uTjW2DmCgKLgeV8glEvN4V26RWsF6ZoZQ8Ddu8AZRyvKRg6d83q4/6mQA2RbCHZ7HZevoo4mElIBOQjJIsWOw5hqxenBbk6gF4CVAzcPywEJdquFCyY+aNFSJtch8KxH9SvGrO6yqhp4BhtXIsnhdJlo7fPb3cf8VgGiDnP/W4FwQkuzoCgqtsRRFdCr79efsN4qFPzZ+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:21:08PM -0400, Zi Yan wrote:
> On 8 Jun 2026, at 15:59, Gregory Price wrote:
> 
> > On Mon, Jun 08, 2026 at 02:04:28PM +0100, Matthew Wilcox wrote:
> >> On Mon, Jun 08, 2026 at 12:06:35PM +0100, Lorenzo Stoakes wrote:
> >>> But instead of overloading user_addr to indicate all kinds of things, instead
> >>> make life easier by actually breaking things out.
> >>>
> >>> Like:
> >>>
> >>> enum alloc_context_type {
> >>> 	KERNEL_ALLOCATION,
> >>> 	USER_MAPPED_ALLOCATION,
> >>> 	USER_UNMAPPED_ALLOCATION, // Maybe? Do we ever?
> >>> 	/* Perhaps some other states we want to encode? */
> >>> };
> >>>
> >>> struct alloc_context {
> >>> 	...
> >>>
> >>> 	enum alloc_context_type type;
> >>> 	unsigned long user_addr; // Only set if type == USER_ALLOCATION
> >>>
> >>> 	// Maybe something suggesting context or whether we init before in some
> >>> 	// cases?
> >>> };
> >>
> >> Ugh, please, no.  As I suggested last time I commented on this
> >> trainwreck of a series, lift the zeroing functionality from
> >> alloc_frozen_pages() into its callers.
> >
> > This sort of just implies writing the "alloc_frozen_zeroed_pages()"
> > wrapper that does the zeroing at the end before return, and then killing
> > the post hook nonsense associated with it in the first place.
> 
> This means it is going to be a multi-step optimization. This is probably
> step 1.
> 
> >
> > None of this resolves the user address annoyance which is needed on some
> > archs for cache flushing.  Whether anyone agrees that the page allocator
> > should be responsible for this particular operation - open debate.
> 
> This is probably step 2. But does the virtio use case apply to these
> archs? Does the performance matter for them? If not, maybe this part can
> be left as a TODO.
> 
> 
> Best Regards,
> Yan, Zi

I doubt it. But I don't get what's proposed, the code that we
have to modify is arch independent?


