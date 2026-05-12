Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C287FCD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 16:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 351B26B0098; Tue, 12 May 2026 12:35:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3018C6B00A0; Tue, 12 May 2026 12:35:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C9A06B00A1; Tue, 12 May 2026 12:35:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A51E6B0098
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:35:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A2C7C8D1E6
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:35:22 +0000 (UTC)
X-FDA: 84759318084.02.4AFFC0F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id D0349140017
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:35:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U0KWxNZz;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778603720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fcCfUoqbPzi0QdWN4h/jl5Vlg/FOqMT66yAiEmc3y1Y=;
	b=ud9z8dp/xf4d3GG/SiVRJ/rMQdCkifCeUhNRrVc4480/6wp+YXhi8pO3RF/LVpqVz+cuN6
	gJWPcSMeodxlo/3ruYJ88+D14++AJOOTGPSLdKeNHyQXhDdvVBrnvJ/t3myTfATheqAdyd
	liF8obW7ALROOBlO+ic5BptHFGrHaso=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778603720; a=rsa-sha256;
	cv=none;
	b=i5Q4zBqf8oMWFeXcPFvmHOu4BBF4uX4GYdc4yBBdVKY6jD7yEr3oPtHcBk7dxjAWK+Bj2x
	x1X8L4D/bhJgZLV5OkWIGrTSps3r5v7Vw4EKP0uFfoKVnojtWxZMBG71lP76zHHactNzXN
	47Mfx8Kkje5ynz0jrtId7ikmUtA0Aww=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U0KWxNZz;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778603719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fcCfUoqbPzi0QdWN4h/jl5Vlg/FOqMT66yAiEmc3y1Y=;
	b=U0KWxNZzb9sSfpCPxt2D4Cz+afV2fsQsUaSo9SE5Jjx4S9EiQvkkYfKE+UI8Es5YxVw7sI
	rMVpaSS9Rzg6CTkfPnd5VUYSJRo4MLj/sdvxloq5OYHb8Yca/2D0dPhKSmK1BpaNG249FM
	4KqQMgOtv6lTDJDgIkHm/S58nGR5fcc=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-qjc-ao25PKGwerfxGRWWlQ-1; Tue, 12 May 2026 12:35:16 -0400
X-MC-Unique: qjc-ao25PKGwerfxGRWWlQ-1
X-Mimecast-MFC-AGG-ID: qjc-ao25PKGwerfxGRWWlQ_1778603716
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-90f5248b209so34632585a.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 09:35:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778603716; x=1779208516;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fcCfUoqbPzi0QdWN4h/jl5Vlg/FOqMT66yAiEmc3y1Y=;
        b=WYNhkTos8aa+KaggjBAvzVIp52cTkEWdGktF6exOrS9ywIPTjviClnLHuoYAp/Lypt
         YCKUbJjml4ByJwsPmZPWj4NRrXYv6yWSFgTBuKf8Re/L2Jb/V5Wc8PcgAyYxy+nMWCX6
         IRJU3SW0GejWbUteNL7LihReTxXE5bgCBfKlecevqacqCIYpYA9GLsE6QUGu5ZrAYR7T
         EmJm58UfXkwTaq+olX2Av4IzYMuhfyTkm28KmcccGF/PV5qOYyasL+rGzIZX9J3hQWRX
         ufR2p4tYmabj2qzeXZydaSKg4Lhkk2he8upb4zyegMPriemLVhU/Sj+rZB7rwKdJT0T5
         80Ww==
X-Forwarded-Encrypted: i=1; AFNElJ/YhMcznT8BVxHarLzJcnAOXuSCoj9aceb+Kvje2VaNB2QJNuQbOI+I2+SEPjU2NvlU/hCCyrkxbg==@kvack.org
X-Gm-Message-State: AOJu0YwjRN7o9madcPULgS0gIjBTRK/CZoc0EysBEYb+9PpNXu88JUBX
	IUE8I7z6z5wQF1FGGsT13IezXf99AKSC1+7hCRKNg6ZSQabIKIUtcLtt0lVkbdOxMPk8w+ILOkw
	Pds1mT8N0SG6B4sNeAhHEQjJaiFFQqVKEMsw0AavMG2ZCFN55PuLV
X-Gm-Gg: Acq92OHIfZVV+vbJ/oD4aMsxwGOMGEBSU3VFFy9tTgMxT+YH0K7rWK3V//Cs6uvn1xF
	Ly+7iGZW0TTbhFQnfpCwcjKh7Bg/QFy2A3ZcwOqCSTWP9KNUgx2pH0ylIMzyq9kxIzvizyeCYyx
	jUcfxzKRwQib1WeKoxaXNmA97quRqbTQO0F6vKA5OeRV3yGAszHadn2AzQIhXPmLJSyQXqofbUt
	xUGcRzsSmdSwySe5R5DQSeO73RGSuF2v90CnOmKm71AaayC/QUAtcUDe0m51C57NeLhiDhB+H0G
	SPME+eNtfKlu2dKZn2zFU8nNmw6+0pSd0c3BgXCIM/NB44NU4I1uofS5EXG6gycvFHT6sq098PQ
	jzb5hYZ85z9m3RucnOrMe02XFNqFFIOXdfTu4fmMH
X-Received: by 2002:a05:620a:bc8:b0:8f4:3895:25da with SMTP id af79cd13be357-90cfd3510fbmr518775785a.25.1778603715567;
        Tue, 12 May 2026 09:35:15 -0700 (PDT)
X-Received: by 2002:a05:620a:bc8:b0:8f4:3895:25da with SMTP id af79cd13be357-90cfd3510fbmr518761985a.25.1778603714550;
        Tue, 12 May 2026 09:35:14 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-907b8e9b24asm1430902685a.18.2026.05.12.09.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 09:35:13 -0700 (PDT)
Date: Tue, 12 May 2026 12:35:04 -0400
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
Subject: Re: [PATCH resend v6 14/30] mm: hugetlb: use __GFP_ZERO and skip
 zeroing for zeroed pages
Message-ID: <20260512123246-mutt-send-email-mst@kernel.org>
References: <cover.1778489843.git.mst@redhat.com>
 <fe1d24d4deafe0f5d1a9c51fcc040d9561c8592a.1778489843.git.mst@redhat.com>
 <agIFq63QZugkWcXJ@gourry-fedora-PF4VCD3F>
 <20260511174337-mutt-send-email-mst@kernel.org>
 <agKVIjvNwVajYwjz@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <agKVIjvNwVajYwjz@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tDezF3NwRfSHnqs4vOgFQMr-iG-30fZZnQDOFphIhkc_1778603716
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D0349140017
X-Stat-Signature: 486nj16j3i5kjf7arimtby46otpddr3u
X-Rspam-User: 
X-HE-Tag: 1778603719-881454
X-HE-Meta: U2FsdGVkX18aRThOrIzdheXLAoIHqrvXYn8/IbEc7d191fwi4XQ4Lnox0MAUuDKX8npOV6d97EPzhADEM+546UDPMSkjA9MvhRfbFimZEs8WCHoo+Q8DLhj3u4diuHq5dh7/r1c8twxZ/4SF8qK//EbOLxndVBGqXwUjKqSevrJqVSSw+6M990u2+MLvKGHfqbChEqQghrbiLwcRJ3mN+TUiDDGlD9OJk7GUdkBhH+CwUK2j9kgMClB914xiMaPGn4aJv77AuHM9/2r3pOjRg328uP/FE/vku+JcRuaVzHST7/Z+WHwj47UvESsi2gLvErJh5QkoPrhG1T0F02vy4/IO0joUs/5ihcJ059cJiJJthC2ddH+/2oLFraVEjYSujhXiYEZ1Utm7pecD0/AeZZcfUfTOpu795lgnE6zN5jHG34TSzl38f/lEk7KAdeQ+7ua0OGDcem1UBJMe/uqJj6M1ltZltlFgFSTt2vEYe84QC3rgO/SfkjKUuOmeAfvFmRF79av2svJN3l680Ups2Vv+zPerm1dTx7ESYgAypVqLfzPXsWFeljAJtZEG+CuyDQOAfTocWPG/hPTSjyDdOBIiZFWf3a7QKH51KFoma8Npg1iu5r6K0tGstqnW9lozB8qdf+B374rdguHltomZbfRXjsfV10rhE+Unf39boS9Q5Hp9x9FqXm6qbEw6TUPvoLuE201ETppRml/6OVZwaEE1dEf4kExUz0WNoDzsKVKDTSYLg4gKtyKfu4fK22SYfx4AbjRh+9vLnytPpt2MJWYKG9ZjxOQdbL6sHS7B64/+LfDue+Dm9RLQw/Cu+6IPQ6c6A6fGUeJ0J438cLgLMHDOyCX9S9UInjj2MkY+cdjYCALs/r88tbnidzmqbRvFSiRiqfagiudjjRnl+ui5YnvBimXu6Ul2co/p2IDtkPB8P9iXhby9rfcBfDQW7gahqwuKumdua3IEDyboqdn
 LIsF3BVF
 SroFdrDKYXX1nSO2Qv9AiC33BE7g8VjYI0cgdKHFy7ZaAYriCob6mkoOs4Sm/CuWm85wXBgnuMDFuKsnmdwEqbYnL0RnyhQQPCkATO+u9/Z+S9oDNp8Ie54x4L1iVZxGgDMsJG9GBnRuSulXYfB2ONMb7rHxopmyYFJIAjvfv3Xf2CRI15KR7GtmZqGpWiy1mb9TYI3tyZh+HQdqqZKQy1jtmSz2EyFGVs/SR2Vj2HhrlfuWIvJ/LWXuFtpqdHdirjFJrK/rAyHexnCIc40XSVgEsCGm2Gm6WQ92eppOkXnp6BU433ObGU4YqJGM0D8uEq6Olkbv/XTA884o9/dcx5Rcqm2jwlhSMCO7uNNXqovgqw+VxjFnXHN01uxSnWxjfL6mUotsbo7yLmWmogG8pskO4hNBt4NDYV02Aa0IFLJpqRDfMXXWboS5XcsWhRcLI1DsWEhHFziZbut/BAlfAbhNYlYNLRj98BTP10TuhJr8+5FhIKdKdXxpqQE3MJMftf6OA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 10:49:06PM -0400, Gregory Price wrote:
> On Mon, May 11, 2026 at 05:47:48PM -0400, Michael S. Tsirkin wrote:
> > On Mon, May 11, 2026 at 12:36:59PM -0400, Gregory Price wrote:
> > > 
> > > This feels like a very odd pattern:
> > > 
> > >   1) ask for __GFP_ZERO
> > >   2) Have to check whether it was actually zeroed
> > > 
> > > Seems like the zeroing piece should just be sunk in if you're going to
> > > ask for __GFP_ZERO anyway.  And in that case, maybe just `bool zero` as
> > > an argument, rather than GFP (to avoid future overloading of flags).
> > > 
> > > ~Gregory
> > 
> > Heh. The reason is that it either allocates from buddy - using gfp flags
> > or from the pool, in which case it zeroes.
> > 
> > We could even avoid the bool - just test __GFP_ZERO inside
> > alloc_hugetlb_folio. Would that be better?
> > 
> 
> Hard to know until we see the full shape of things, but it seems
> reasonable if we can eliminate one or both new arguments that this would
> be a good thing and the logic should just be sunk into hugetlb.
> 
> ~Gregory


BTW it does mean we need to use vmf->real_address there as user_addr
as opposed to vmf->address which is HP aligned.
I guess I'll switch everyone to use real_address then, for consistency.


-- 
MST


