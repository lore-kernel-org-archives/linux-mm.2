Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99628CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:05:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F0F56B00EE; Mon, 11 May 2026 12:05:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C9306B00EF; Mon, 11 May 2026 12:05:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F20E66B00F0; Mon, 11 May 2026 12:05:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E2BD06B00EE
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:05:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B34611C0410
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:05:25 +0000 (UTC)
X-FDA: 84755613810.11.493FC5F
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf01.hostedemail.com (Postfix) with ESMTP id 93B0340019
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:05:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=n5YJo1mc;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778515523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=53pN36zCncMLyKGWGnOoIrxzjGZ1bpiQo8EJw90qZwk=;
	b=bohUppZQFwyIRVWDzGnKd0KClQ0A+QDVgPUqdnjWad36HaGdzLs8p0shzMmF5A4RWhPcYn
	DnNCpqcmWlVzi34tmAwHw+YWDcqp3z+SGNz6vR0KGTbM2oLvxsOxayENJo4C1w8WG27ywG
	cURfaQhyp8/wWltuczNGXFAEfwpb2w4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=n5YJo1mc;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778515523; a=rsa-sha256;
	cv=none;
	b=NGM4sXD+O9/uYjYjXEkeCP0CSuTuGMFz0hQ9lp9B0vqdNETu4fWrdQYCEN2VUNi+l6StGA
	mMggpJrlcgZfEUmnFCGdldIiKIz7XUDZNM6PeprlkcmZHjRwriM2Y3n0Eb7ozXqUMXa3Mw
	9Tl8KOU50sUlhtb8LJKD/1FLMPHdnK8=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8d6d5e45c43so492561685a.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 09:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778515523; x=1779120323; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=53pN36zCncMLyKGWGnOoIrxzjGZ1bpiQo8EJw90qZwk=;
        b=n5YJo1mcAoxA0B8T3nics6ZYWp6BXp0uh6tY98SMGMq4DzuHuLx65Bsxt0nYPCxj54
         8RIvjuZKxpQRQNUpdhfbRonXpOsns8M666pE+0+DzdIv8FhnOro0vreC+nHqCgYNIQ3D
         hfqoIivya+ImysuR/UJJElEbEOIXJrELsak7x+MWwcSaCDtwkKfjvBncROpwOpIEZqbG
         vTFia9Q5yXYNUqVgJMlf/5hSRs09WaMVCWveI34AIK3ZitPWEoOC8jS+d5XxuzePocDj
         T2YNMsap+enOe4lGSV//Cu96MmMFbAuVll1dh7z7tsHUWFo9/L1hrux0EFyr0sbqQJDk
         WLOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778515523; x=1779120323;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=53pN36zCncMLyKGWGnOoIrxzjGZ1bpiQo8EJw90qZwk=;
        b=M7DopAMrcIme4DdrSeV1hKLvV/Mg13ubF1k2ZX2eaAsqZQHhFwSGuBiWh0Ul5eQL+5
         kQzTPR4/qs2bdoC1aY5Jx6UGChwFtJZ18WbnscbfPzRnpQfJeSB1az3010SqKq5Enqcz
         GnzabpNwJfCxRrO2/XDmfwCtg25ZraTgsuWvWHXSYr/RgDnkDwDEddf4Vvqbay7jLpu9
         1XvZn6nWWLeW+GqD0U2vmUxrtWhqTeHGNvrdptWv5lgNjIi8uKxajFO8sO0i9qi3GQB2
         fVMCzJLykpQJoY7mtyX4oOlCz/FaqeXIGpz+UUObFjRx/sbMb9RdSVi6RcU+Jt/e6ti0
         W5nw==
X-Forwarded-Encrypted: i=1; AFNElJ+iZ6Wt/fgdO5SlXYhoHAiAeuLytIoI7f7OQp84HOOU6ilLrtQdeINZdeosMxpoxabg3QF3MrMfjQ==@kvack.org
X-Gm-Message-State: AOJu0YxIGxEG5xidiojSADdpDIfe9oqc6PiGG7FsxL1uy610yjKA05d5
	3GMfqBDBaBxsgPv9Af9IMBkXr+bl91ut9Im8AY95dlvUCVoLAzHTrpvDL+x8VcfAAQU=
X-Gm-Gg: Acq92OEwnc0czgxHwngAoOGa8JUIJtyupmHnRDd8O1RQWpsium6oKCTICX5zACUy+Hm
	uDQPHu2pgFgELpr8Y7rcf5DUbAX493tSXJ9xwi8ZVfFTLc8KJd4MySuhl0nXTG7XAml6ce9n9TV
	XdwRJKX08+umHrVlUPpm8ZbTMIc/1evO5LraBHt+l7GQRbzAKEqCRH1xB6BIFrcbT0y5u6A+Qc5
	xREaS+pTlsVuy/VKYRK3JdTQUnsn3CFuhSvdm0XIEelN8ezLmlyNpynSCgonWgsKV2tUgqixuZV
	0XVUDXs69jeiXrIT4dd+sGfO0J3+peB4Xhm5fxovEMntQiKowCm6qXUU2Y2HXK5GW9/T+AaQvdv
	gkrMgzrYkbhJA/zjqbBWW/uAZPpZRfcvzgf1B4CYR9JEENjWJrCV7x11u+cCB/qKGCiNhNlvMnW
	qkvbw3GGRCDvas1ZvHE6eQPrWNBzw55Dy+0kgnsYcU7pV/AiaYIDqmCMmnzbFUXDCsWMaO3ClrY
	RJz04p15p7pAUS40Ss7Ayw=
X-Received: by 2002:a05:620a:2916:b0:8ed:f377:96e8 with SMTP id af79cd13be357-907badfb617mr2055265985a.38.1778515522494;
        Mon, 11 May 2026 09:05:22 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fc2cd04de9sm3186408485a.44.2026.05.11.09.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 09:05:21 -0700 (PDT)
Date: Mon, 11 May 2026 12:05:18 -0400
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
Message-ID: <agH-PrpY269pyuJQ@gourry-fedora-PF4VCD3F>
References: <cover.1778489843.git.mst@redhat.com>
 <369a08b86f51572b2715a9ec577de27ea98000d3.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <369a08b86f51572b2715a9ec577de27ea98000d3.1778489843.git.mst@redhat.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 93B0340019
X-Rspam-User: 
X-Stat-Signature: pt9hd1z7ta9d7po9sqg56f57ejcd8hfu
X-HE-Tag: 1778515523-857234
X-HE-Meta: U2FsdGVkX1+SS2GlXjBYZ43LVs3FoqV9Hu/x9gVVDwd7pEntTgWTk4moMXPBzqOCb4Tr782M2eEGvmiGdthzTT7feUNT/hYiUxUrUzvKoS5HCvgz48hekdbf50CItKdrqIcCE/DMP2qWRwq1YzZbEWHyptVr7im18ufANgQCw89bLSsdBvaMaJgfLcfBUr93qTB4dnuXiLtoRz4GCEFoyXYT7Qf52DWMwt8jI9Po26BYRfSrDwH0hMcNEJwwGmdSpngidez4L2MMQB5Zchj6Isp/meLeJUTFB9/maSyv6MiAxj4Lwh7NxsuJsYlKem9GxtmacFnJw7mH4GcCRj7+3iTOkzmaNHmkEFkWP9NYQer2iau+PX1TWf2EYJ016K6WNvFWRdyRQ16i4hDkr0zj72KwWCpdfWDAbGFol0jMGPq4XocPc3UDTBl8HGRdgx6pUeiSI8PjzZUQOvP4talvIIjWjoS6OPLqVcZYOF6Hlg8KQHfr5cJ9XaAtTRGd+cEq6q/cT/b+zvz1OQPA587PR0G5+WUFDHVxikGbHAKT+PpA/8mw2LHVk+/hLE6qp2hidod01ZQc6hMR3EnwCZKGRR7GVSLf4thbeNPCigBPYJmXFGqFnGkGDUGAVYAuWwp8/rcgvnjIMx8KeKNhZPcBXEKd90MfhN253fWXZBJOSieYWNBE8A/E0f0wXY1ALcgQY5cI8lv8qmpZ1t+3gSqlTzPs9ZxZDwbSk1zj1RYQgPVZpqFwXEK6p4cQGtywEtfseKeCz1dtnune6GxZuHaqUMYkilAGoo3G34kCaHy1a8lVLx4g6x7qwX5uinStLRlRAwkVo+NzgcZ+s8DMP3VKEAwE1jsVz6CVqimzQe9ZbK7ADtYQ+R6PG+qyGulAAKgD34cQ/jBtbI6pnODa6TMpzzJN5+s2OZfQeg5usV9x3F0xkNwU5eX3/5I+UvaJayt07DKE1lL0jOM0wLVrmER
 +eWu3OGS
 gFgyI+s07UGFYNvzJFiX5/imoq8oSIduMT1z4+NqxLD8FK2cb3F83effOv4cKJA+LpJ40PJq9kcq0MBsfJBS0uJSlkvTRl70Jz1kFSKpjIu9fj9oDOA6EqeDqM4pIPcXK6n+SOWeadv1umRy743G8m+PD82KpygtjX32L8JMtlgH0+ZXSC5U0hB6INaaUrDXOsvsJ6Iw2kh4PsW/fLerEdkrQlvBVB9+Ci+VEuYX/twuHei8+webQKQBglLR7dvkkjWls6XbzUmXQs79oFPfFYM2MWQoh8WceJGJB7yBtMK+BLeap4vRI7M2/hAFqBdJ/qrRa6ZiHcAq6W47XTNPk8vxl6XIh7Fih80LTPP0ySSNJG8QYJ5dC1XAE4wftUVpv4G+wS6nPFurVmqKECcbqp18csn2UE4nfETZG/eqqeOeFSIWCGfmmhYxd0zWMm9f231eeGzu4rZ68qyeFhX1OEAK2lR9J3AwklvNL3awfwreXhPsfgZqMJSnIBRW8jTzBN00H5NOpafHsia0VOUbTfLSIWSc0xg1XJy33
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 05:02:39AM -0400, Michael S. Tsirkin wrote:
> Same change as the previous patch but for alloc_swap_folio:
> pass vmf->address directly instead of ALIGN_DOWN(vmf->address, ...).
> 

Starting to seem like this should all just get squashed into once patch.

~Gregory

