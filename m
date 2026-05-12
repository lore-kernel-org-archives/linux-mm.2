Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD4CACD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 15:47:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 440276B00A3; Tue, 12 May 2026 11:47:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4179F6B00A6; Tue, 12 May 2026 11:47:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32DD56B00A9; Tue, 12 May 2026 11:47:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 21BD96B00A3
	for <linux-mm@kvack.org>; Tue, 12 May 2026 11:47:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C85271A0450
	for <linux-mm@kvack.org>; Tue, 12 May 2026 15:47:00 +0000 (UTC)
X-FDA: 84759196200.03.EEA15FB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7D3ADC000A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 15:46:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iYwkEbu8;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778600818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bz4SWbhgAVm51cXT8NXKcag9UUTqJROZ/+vdmfbYWAM=;
	b=rw3snpAPEeAfcdmA3fUIZr8TzuyK2AKhlR4fu3wVFWd3zFya38Uu2wRrPMcTI+KexyCCmJ
	nq6vKXOrennFV1u53DfXmrcbnh+i/FkI5gYPqIJIHIsYKd1cei0NXFIyUai8oUzztktQ5t
	NDb1ofHqL6izetz+kQquhNjYDW+Ga2Y=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=iYwkEbu8;
	spf=pass (imf10.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778600818; a=rsa-sha256;
	cv=none;
	b=d6pj07slw4vS43qqrq4XHyz30BC6HdG5hc4/c/sHQs4tRh788d5L6gBS3l1HvrtJeMmF4k
	Emv51JUvFU9hNALbSEKxt0vPhr7GVKTIX6Dwc4nugr1ceZKo1d4QFANC6GOyOvqJuKZE/h
	FRIwnZc/BwiLbR6eJp8up0B2hPzQF7c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778600817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bz4SWbhgAVm51cXT8NXKcag9UUTqJROZ/+vdmfbYWAM=;
	b=iYwkEbu8ofxRHC3kDpGFd3nrWbs9OCNzXaErMkIJrsA6d5piSSO8hqsWfpA+f4nXmbIpwL
	CTeg/Jct1lS0maqjko7e5tIbHcSTP3sFGQVJusOBLTWkHHon1t8k47TGWftRguF+KJO1x/
	jDsqHjGuyrHas7ICMmWAPqFEt+4q3C0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-493-2PIsGQqWMEOWVUfDl5P2Xw-1; Tue, 12 May 2026 11:46:54 -0400
X-MC-Unique: 2PIsGQqWMEOWVUfDl5P2Xw-1
X-Mimecast-MFC-AGG-ID: 2PIsGQqWMEOWVUfDl5P2Xw_1778600813
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48e5dfa8ec7so32376585e9.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 08:46:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778600813; x=1779205613;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bz4SWbhgAVm51cXT8NXKcag9UUTqJROZ/+vdmfbYWAM=;
        b=cNPdJt/JJPRyv2rDqJa8bUEu+ajYwWPg5f/Ckx4SVGDt1f4rapJPoQV/NC0OihQ7of
         AQPOkKpBF4NLwXadbaZjlsB0AZbD76QJyS1kg4ktUXR6UAdWZLDEpR8hERLOsWgDWy9b
         JRiP0uE0B6Ix8hfxqqWFBMJgjIR7ELZYji7qjuTn22lE5lHOwmb+ks9QgjJP9BQ0Az2t
         wEwTk1FIh7hZLCW6n7cdmdSf6eZJ4/3Sfa3iJwoUuHa9SFkJPfBV0nfmmoPomVYPnzEo
         e8xY8O36KKkPCLzkHC9p2glHuq9JmSwjzYlo5Z51tGfsfqIb6yNqzdrJyQnYDhoLehCm
         HWLQ==
X-Forwarded-Encrypted: i=1; AFNElJ/B8ZPvSd+pGGia3wKg8+rHv9ruOts9NKsbuV/gVFWBDDTYJ5Cx5XjrBmp+Tj0KpX9aIkvupjk8Zg==@kvack.org
X-Gm-Message-State: AOJu0YyLL0wkZ0Nkv+ybraJsVuWf/9EHrDgqI/lOpu7WoR67ys8O7XhD
	Mee3JfmgnsdfBFcOJ64wDaFSBmewNXYxtv58iEk5gyr2hWUsYP8F712b7VlzY4y69WYt111WwU+
	3sXAjYhoj/u3Hobdy17YJXOf3xCSJdGzq22PpCoNhQ77ZpsUfeR/m
X-Gm-Gg: Acq92OHtbFgdeOXE2RGYGENTFMMjVJbibgXtFMtR4wldEKfhY8UrU/TC9LtFQx58XOq
	WLCcALBqVHr7THDPnbV3FINoJehcjmfTAffd41/VtrwtyVj1IlxQJl0UdkC613mKubxk8SZk3ug
	F1/O8Is61TUh+l1yVB3tAVBH5hlwUHnWoeeUv9J0Zp8RaW+TXfJ7A5QB0vkFRvGC6MOq9kJIMCn
	iYoeiL30TGtXyXy8IlwdzCcZQJHHATGWKe53F42Sjj/2YuJKrcnhRZoetZhVRPxjorbn4cUERWG
	1OEkyR8CCAjT7aGO5FQbslieQjMSuFpSBYNguky0b9tjYVoOeKwlofmnE/2W2Emgv+0qtFZj107
	2HDAV+M/RjcYuWqSbc4+KsjZbOqipO0xQBdawLvxH
X-Received: by 2002:a05:600c:198a:b0:489:1c1f:35f9 with SMTP id 5b1f17b1804b1-48e8fe50bbbmr58590665e9.9.1778600812935;
        Tue, 12 May 2026 08:46:52 -0700 (PDT)
X-Received: by 2002:a05:600c:198a:b0:489:1c1f:35f9 with SMTP id 5b1f17b1804b1-48e8fe50bbbmr58589455e9.9.1778600812271;
        Tue, 12 May 2026 08:46:52 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-454913049ecsm32654384f8f.19.2026.05.12.08.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 08:46:51 -0700 (PDT)
Date: Tue, 12 May 2026 11:46:46 -0400
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
Subject: Re: [PATCH resend v6 17/30] mm: page_alloc: propagate PageReported
 flag across buddy splits
Message-ID: <20260512114352-mutt-send-email-mst@kernel.org>
References: <cover.1778489843.git.mst@redhat.com>
 <6d98a35c94fa44b550afa66923c620511e2826f0.1778489843.git.mst@redhat.com>
 <agNJ2BFRVTKINliT@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <agNJ2BFRVTKINliT@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zCHVlZeImaumu-5Juf2nJcscN4s7eoaTuDc1dSmDw-U_1778600813
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D3ADC000A
X-Rspamd-Server: rspam06
X-Stat-Signature: bd3fm5jr6f9r7x4qjr1paopwtakrau1y
X-HE-Tag: 1778600818-255846
X-HE-Meta: U2FsdGVkX19ArlruBtg8TR0n05pbhVZWIe5D1qBLoNTBAUVX96RhAEdwk5RkGOkXvSNEqevWFl5A07DslqEPqhinN1CI75PVh8tJizApfRePxC27dpGQw6d3IP68CD9XPp9cRDT/tcsCEEAp2KOpauKO9X8FrvtI8CFOlw1LKVsEcTmrv3wkaMDNRsnLve019oQ9YsKkpseYijpIFMBKo+02lUkMWC7SKCcXPkMPZmapgLGf3ZDP3K+7zInpXHPxlnvTpFtjNicbistlFtitrQvKhwz47VrGUwE2+0ioR5TDuzJvng9IrhjPSWJjoHJuMdjbl1UAd3nFaY18jqXAGrcVaFkXB3ak5TEtenpilZDtHQnHvcbTDrIYw9sn+7S95TjzWO1DoNClBd7XvPF4BIbMCxrinRTEmIw+d7cO5gX8y7BJZ2vI7ZGYWubmqYVptD+tTKedADLRGgAizHjhG785+MHvWYRyzgrzXGRVffvyggm88Ba+TFel6+pcCyulv+BVgcH9FSeyP6NqsRy9wDvDLum0z30yTs6h7mZpVnwL1x4kw1Xm5YLrIkR5PlLpin+IJaH5PdLzak+hQuJZQLdHeJwQkmdPGziz3x7OH9NUASTR25oOUs5tBJ8KZrMLkvfRFsF0hLuwjCteQ8CD62JJdEQX582CjiVPNaSbw2DE9BBJCqJKLq8do6i73wGC6KcFxpxs5cxix/Rf4VAx+Njzq+GBq2NXkSuleX4OHjfkmE+c1VEQz9cd5ofCeHRWRN6ZvlzYkYYJ2utM8lgRbLUtaTGeIyCYKP7BM+IgDB5M192GkageJSRh7/cTvDqVx0r9PPYXgyKjBRQv1f70UztHYVOtIK3uj7Q/ccoHuY6ELEjrnOdyfjlnngrw8SXIN7XbMAtQHz60zbzYPr0a4+HWGSftpbzzREGFr92XkDMLqzUWKwqQuFht2+CJ20t16epKtYHBdOz8GMsuw+5
 i0BOkbIw
 +P4a7uuhL9qJR06TeDNSEF9T5DH8Di893klgnz9UENKEEm/McIBcz8enbFmJhH7nxw5/YZlFVXlSx+914kZXmGIFrp8J1jg+spljxQwz8Pzu2GhPg3ohvu+aD1jelymYBiKTDJAOR+3z9rTD8zqJbkvlD/wp5LpkKVeg/wauz21a48F2LBDFPMDbkp3Nlg3BU1mpBGeTqnC7eIomph44qKT0d2VDdCKtK9E0NfseiAGd9JQnV+dn/65zCnk2WW+j42+ops38nzNLTmruvDMi2YieoSjEJgrjeFtwe84yY2ija3+HWh8LX2gWcVYpRlORdqpxLonIA9ECX7hyGPdiZuOlNchMWpXbPjcOfiwuo3NLc+CO30HeWQh7ShzQ0VFqken5P1xi4uHMM5DFA+wsBqX75Mw6mHUAoO6L5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 11:40:08AM -0400, Gregory Price wrote:
> On Mon, May 11, 2026 at 05:03:19AM -0400, Michael S. Tsirkin wrote:
> > When a reported free page is split via expand() to satisfy a
> > smaller allocation, the sub-pages placed back on the free lists
> > lose the PageReported flag.  This means they will be unnecessarily
> > re-reported to the hypervisor in the next reporting cycle, wasting
> > work.
> >
> 
> Is this issue generated by the changes in the overall patch set, or an
> issue present regardless of the proposed zeroing avoidance feature?
> 
> If the former, then maybe just submit as a standalone patch, seems like
> a useful improvement regardless.

The former but then the only issue is more reporting, and
I couldn't find a benchmark that would quantify the performance
difference.

So the value of pushing a fix by itself is pretty low.


> If fundamentally tied to the zeroing-avoidance feature, then nudging
> this to the front or end of the series (depending on conflicts) would
> help focus the review of the core new feature.
> 
> ~Gregory

I can nudge it forward sure.

-- 
MST


