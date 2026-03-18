Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D302FCD0D2
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 08:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A9EE6B012A; Wed, 18 Mar 2026 04:25:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 659DB6B012B; Wed, 18 Mar 2026 04:25:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5488A6B012C; Wed, 18 Mar 2026 04:25:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F6B26B012A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:25:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DFF4B140476
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:25:53 +0000 (UTC)
X-FDA: 84558500586.29.3A0508E
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id 221C74000A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:25:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bZXlKWqZ;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773822352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qct1M6uDgddyZIwhlydpZnvmv7ZwIfwluJBCESYJnoQ=;
	b=dkoI/+CjSdWxWhzIRzVkG0+2xjVNXcka27FY9OUkwpB6qzNZTWImRdoOCS20UPNXBDUbD+
	rhLlpwg3ih54JfE2f4o9DnMKZD+OvcB1m2DG6phwxf06SsRm3kEukBDxYdufofnjDQk297
	sjD4yGwrJK8PYr8dZMHlOIMcdZBjtzg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bZXlKWqZ;
	spf=pass (imf01.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773822352; a=rsa-sha256;
	cv=none;
	b=GUjjJQr05IP5DSIuDMVJGLe751lovVOZa5qPGgCtTG4bA40bfZzWbWAC5Nbe9s/bQYadBY
	ywzR4rC/lQMbpAzN+9ogofbTiTAj0wEbSR+HShGR/DRPaOi6kZwASA+wUKzXNjR1NtDPWo
	ART4mFIXzEKI7libiG+3gGwud92XPg0=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48534237460so70497105e9.3
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 01:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773822350; x=1774427150; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qct1M6uDgddyZIwhlydpZnvmv7ZwIfwluJBCESYJnoQ=;
        b=bZXlKWqZqOCAQzqkntbobpGLJcFm8XnZtBERiUfXf/BbU2W1Qoac3s/NWcz9lUt4E3
         091AASJ5v9TLOtthvq4aOy+pqklwP0U14Y2SXuZFXmo0lZ2sxaQGuk+qofyJSsQ9cD6H
         HGsUmRnJYrFadp+oOEMdDItr4qKFJD16TzNDVv4Bgj+T8CqhQVOLr//mFVhsmZ0cRgNA
         Yp04rER1NMyUqiLKy5M9LRf4E6gDpVqWrb62zjt+atf7gXlNY9Cw9iVYrHXXuFIG6m/n
         szhYS40R7ntGUts4rYDv6Bay7pVuHkabLekhbjhT2ZDbyGkZ8rRHNEFfNo10KvTvCz8I
         U6Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773822350; x=1774427150;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qct1M6uDgddyZIwhlydpZnvmv7ZwIfwluJBCESYJnoQ=;
        b=R6lBAGgdriWTmU8cmhVbvIsf3R5+AyAPnie4wmW/+sunYR7eVOhGQFfIMBvPnxapR0
         kvpudAazdEaOKxes8WVitz7hVvJ1b0GUmTBPVEcLaSw9rxKjYPwQ6t0yk5c6nnU4yB7S
         zjHMspOHU/V3sl0W7HqsY0TG0zYEGntOPbVLsY0heyUvhle2aqlFaDaUij/2CZo6pLfZ
         wOHew7zmY48MXNbNQRzCrhBhX5eNnrV2fv3lyhAvXRH7qLWhh+GP15UJS7FG6st2nGWw
         /Q9lIjVniwQgSowsT4vcow8L97QW+S4SfcoUJUxm4VeWnoPKW/hdO4eYOlYnCa7b532w
         +AgA==
X-Forwarded-Encrypted: i=1; AJvYcCW/NeHFqKOr4lrQf066Y4hPMWxKrrFS1wsGVH3VLJPq/tpT1vj5QjQn8gnKOl4nIXE81z/+Ikd7xw==@kvack.org
X-Gm-Message-State: AOJu0YyFF5YmiGVvyXwI2s0gCN6mua+crwrIcqZnKNTO6GX8ptydsT+c
	YtZgQriaJMlMwGsWu8xGxAGriK26MtmkHT03qZHTpZDTlvkm9JUkvsARA5M2XTwqi1A=
X-Gm-Gg: ATEYQzxqWJ+Xz2P9leBA7Nv1laew9MdNQbWJt7YFtALendX5RRgO1AKEhqna95RR2Tf
	iXKWoHGUNppb5++28qyg6tmlWc3iGVlTELGpj+3UkyeSXUYLcnzSaU2h5LzQy0GiJGRlYJlPPlJ
	9tiBZfw92hC2nJdD9V1V4uaJveJz+2W9tZRSjSxgmHom2mJg1yRb13mFzCLXo3HjpUBfIA8c3H9
	VkqPkLa/2Qf0Pw/8LOQgqg8wyikikcniykxxFkUbv/hUdogRzy3QJxJs0HpBR71AkZcwpbrgzes
	/mqEINO6Pqv2KPNyvRvZJO0U/FGTLRRwCzbwGBrK/t14CEysDRtEcS2qHsWDybPtzSjZOO39vyA
	pseluhjoDVDntaEKfHdxVY2n8s5saG33dSWmvQmAdHNDVbKmnE+DWtYmfZi2IrJLpOO+EezbdQN
	C3g3va93kz7E/PzQI8e0wq3KuWFUX4aFSERX9n
X-Received: by 2002:a05:600c:8486:b0:485:3a22:69b9 with SMTP id 5b1f17b1804b1-486f4457e6dmr35524025e9.29.1773822350370;
        Wed, 18 Mar 2026 01:25:50 -0700 (PDT)
Received: from localhost (109-81-21-195.rct.o2.cz. [109.81.21.195])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4856eae3322sm105879665e9.10.2026.03.18.01.25.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 01:25:50 -0700 (PDT)
Date: Wed, 18 Mar 2026 09:25:48 +0100
From: Michal Hocko <mhocko@suse.com>
To: Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, yc-core@yandex-team.ru
Subject: Re: [PATCH] mm: add memory.compact_unevictable_allowed cgroup
 attribute
Message-ID: <abphjNOYaNslTA90@tiehlicka>
References: <20260317100058.2316997-1-d-tatianin@yandex-team.ru>
 <20260317121736.f73a828de2a989d1a07efea1@linux-foundation.org>
 <3db237d0-1ee8-44b7-a356-f3015173f7c2@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3db237d0-1ee8-44b7-a356-f3015173f7c2@yandex-team.ru>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 221C74000A
X-Stat-Signature: z7ej38ru8kmmm445t4w8d4898urimwnx
X-Rspam-User: 
X-HE-Tag: 1773822351-182686
X-HE-Meta: U2FsdGVkX1/RuZB0TkIWHT+TpcoTDL18YT+zv7Po06OX0wlcwCajjLIyomwOI+5h9Q/DKt+5Vs6zLOj7nawU0wCUunJSrRHEkutNrRAwl0kT9Y1iN35ROSQjdTT33vh9aN+7g6JIhdmEDMs3cBoBOpub0snyUskEl3A9E6jrFM70YbB7hruwgMUrLUPvgQ0uoKbl1HS3/68lddThauQxwNK+UQ6BBmL/BrGIKhzEwuBbwrTkZxLgU2udn/P5fwvPuEuW4Gh7se3QBefNhRHqJ5DyQ+T3PZwDlnC7DsATE2sLcpdqluUw4Vdu/gJBqMyO3Jby51MsjB54+w7nW1ApD7fLYH5d38U5+6S1HhkKnk6P7rhwKXxL9xilg3FivCHBUUghRWQDxIOvMw/wCsjsqfVdDeUSVb3Mr+FA8DUBPvNFIk4JA7vgR1r0kSZ0C883c748sT/OD8wQSBDge/Aai0S3uUVg3Il0rkIGGsds3cL1NOe2UUuxoON8z0qYSd422w/kar1mb0phzHgDq6FrqYCKDCQJnTXsNVNzE1JN1wrsOyK0KxEDeR/kPjBdAlZZel71W82fQpUruPWi1HkE5qLafqlA7auuCX899aGjHHB5fq1Rw5XAA85xuoyIKRmij8+5/h5jkBXTMTHscyH8ua8eoruVkFcpgkffHlkjiX0MpSVQmHFPoUbo//uhFprtDVwXeZtp3qN9G9RVYbRhts9WWNHSZSCwafMSzRll4x0u/hsIeJXpayptwoN7l7sq8UQbcURwCoVQMOkesSeqrv4sQDvZu4u5T71jTslrK2yKOlEYIM9GNEOIJnj0p6zjvZlkq+LykpNg2+OsfPlJzCglUEi0BZJzHiKFMHWaLROq6JEvrOe6jilhZ1fPTk/qJ9owCrE6QVz966zONFV0k7hZd3PuAURWjyXF+MFc+/saKId3EOb2zRScRW4eWHo8tvvn17vUKAvMytMmt4C
 2nIHiuwH
 5yqE8jvDGYWD+mATtXnlw2O0Kopm3e1xVskL9iKTjw3ijdV7Y3Dtln9nuiM430cbYgVsF91+uGpZLk1AApPMO/iXDI8oL+phUwu4PLqPOPwUtFFU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 17-03-26 23:17:28, Daniil Tatianin wrote:
> 
> On 3/17/26 10:17 PM, Andrew Morton wrote:
> > On Tue, 17 Mar 2026 13:00:58 +0300 Daniil Tatianin <d-tatianin@yandex-team.ru> wrote:
> > 
> > > The current global sysctl compact_unevictable_allowed is too coarse.
> > > In environments with mixed workloads, we may want to protect specific
> > > important cgroups from compaction to ensure their stability and
> > > responsiveness, while allowing compaction for others.
> > > 
> > > This patch introduces a per-memcg compact_unevictable_allowed attribute.
> > > This allows granular control over whether unevictable pages in a specific
> > > cgroup can be compacted. The global sysctl still takes precedence if set
> > > to disallow compaction, but this new setting allows opting out specific
> > > cgroups.
> > > 
> > > This also adds a new ISOLATE_UNEVICTABLE_CHECK_MEMCG flag to
> > > isolate_migratepages_block to preserve the old behavior for the
> > > ISOLATE_UNEVICTABLE flag unconditionally used by
> > > isolage_migratepages_range.
> > AI review asked questions:
> > 	https://sashiko.dev/#/patchset/20260317100058.2316997-1-d-tatianin@yandex-team.ru
> 
> > Should this dynamically walk up the ancestor chain during evaluation to
> > ensure it returns false if any ancestor has disallowed compaction?
> 
> I think ultimately it's up to cgroup maintainers whether the code should do
> that, but as far as I understand the whole point of cgroups is that a child
> can override the settings of its parent. Moreover, this property doesn't
> have CFTYPE_NS_DELEGATABLE set, so a child cgroup cannot just toggle it at
> will.

In general any attributes should have proper hieararchical semantic. I
am not sure what that should be in this case. What is a desire in a
child cgroup can become fragmentation pressure to others.

I think it would be really important to explain more thoroughly about
those usecases of mixed workloads. Is the memcg even a suitable level of
abstraction for this tunable? Doesn't this belong to tasks if anything?
-- 
Michal Hocko
SUSE Labs

