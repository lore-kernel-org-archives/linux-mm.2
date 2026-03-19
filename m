Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F09E11075276
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 08:35:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B34D06B0438; Thu, 19 Mar 2026 04:35:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0AE36B043A; Thu, 19 Mar 2026 04:35:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1FFB6B043B; Thu, 19 Mar 2026 04:35:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 918C86B0438
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 04:35:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 114481A03F9
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:35:44 +0000 (UTC)
X-FDA: 84562154208.06.F06E4C5
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id 35B3D1C0003
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:35:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Z8+lNpz9;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773909342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=31Icc71U+5J9ABaJwtmAWm2GzoqXy8yAq2rOU0PBch0=;
	b=TrXOLVYbaUDeaLGWIrHR47jRR9AfhWwyCWeV9pasC7jEUsrbic4ZwXZN716HZYWNRg995I
	ZJxN3xP3DFazYFfZ4HekHLT0JlQ210WtGO+yeh0Wjgvn1EuRALpe3jjAbdWTAbgOARMExp
	pYxQ8DrYdqUt+DPR6rOUYzxtWrdoHNc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773909342; a=rsa-sha256;
	cv=none;
	b=PUD3IZl98AyzidbMA18HOfkObFA/tHDvj/s7EyhwhAWAZFaMz3Ra4Kej5i2agxEZ09/0iS
	YNmdfl3HwLUABS9XtjDwvI6cJ+myo27bLXlbAV7tlK8y4F8hnW6LEn03SBhHJZAadTDDlb
	7Q/EpxNCXtdlfdjxzgEehJwxVrqSjG8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Z8+lNpz9;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-486fb439299so2904875e9.0
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773909340; x=1774514140; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=31Icc71U+5J9ABaJwtmAWm2GzoqXy8yAq2rOU0PBch0=;
        b=Z8+lNpz9Xzs/6F0+wffDxzJ2nTt7KdkurasG1PQYDn5WJ41kQM14grg5u0Dlcc4umS
         PQEGr82YDMv+DMZeFsj+yKrMxbNOwy3F44jQE4RPEE6B5Hi/NRPOQUL+K5fkLmzINBNf
         k7bGVkSgBwsViEs38GU9wa0VYlZnLdZxFN5EkZRpLanSbWW57nc4mPPZJCTFwLkyOgZH
         kH/dxynEgpccfKDaTHgUNrqbHlt+PGJz5kMu8JFse6e/dAnLQTGzw6NfR27jkCozB0vI
         jy96ITDqy771nTnTzNb0RMqGDBSBBAKJb9EQgI812R3duV2tR2xUGhJjdDmybjUG/Dbq
         fP4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773909340; x=1774514140;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=31Icc71U+5J9ABaJwtmAWm2GzoqXy8yAq2rOU0PBch0=;
        b=JvjsubHxSkOiyJQTdmyb8e0bXYq5GEEY1cQNz98jchuqVUJt8j1ofrNjwb45qgZEuC
         JhF/ezvA0qVJua3fjTX6zvwSvfCYRLSsBdM9am1FvWogNz1qUa+0MQYZmUuiTUT2FQHw
         cqlhMkHkbcUo8jUQ83nxz9t95xHzx2KtDwuDeKNZsebPEXnFHDZui5Dxh99XgRXBwxi+
         KRKA5jNJvNkRHYGnnKo+YBB1VUNHncb1P+7fqouoyx40EZRG1aWSK7TAeUCoWddp2JDu
         njdp/dPAny2V/Z2jw47HxNfPA8QLYxrGc1+pePa9toXFWSkqJrLGuWCxD3aINp3wbUlM
         ccsg==
X-Forwarded-Encrypted: i=1; AJvYcCW8vDH2Yi624lgmfXGVVKXMrnGkTmLBG98wWSgVBdzmy3E9k/cAT+dMcHRZJY/vIlVekROsX/dqxQ==@kvack.org
X-Gm-Message-State: AOJu0YwyQj4NV9+ZCiVfBh8N7DLl5tw8CDrIZY7RO3uRBjfHbouoiwOV
	+oD8EjSb/xURzqsZPUSukJvI77Mb6/JURJd/5T7ATGj5tEJYXrbDqVZMdxjUWvqtCUk=
X-Gm-Gg: ATEYQzx6XOLnu5oMe0bQ4QG5EdYhlwzVJfOUWxuf6AWAtM5xRk0caQuDXfL4FsdOqoa
	qWAEV/BzbOCJ3T4xkHlufKkFg8HewTBpMunoxNkF0P+P7D+rENkPG+NEqGNyihP5ak4PnTEj1gv
	xd7zywcTFDEEicgRLJfmxApREsKTcjQOFObIJfSvNXk3uBLKvnOAB41yEDlPsuF9WiL7bpwYTOI
	/URs1iK9s87vPBCi0HveVw7+zeUjtbbQD4Sb9WS1vQReaCXOKnhDoMlmU/GGX1Kq8qhs5Akf0Oe
	Yr2jAsJ84K+ZdaCro0VJ7pUq754h9SYHwfn062CBW8L9pQfIfeehiHkXk9lMNUlorlc+Z39MD+f
	0O5/M/qISEfFvW+pdn6Ky37ixOB5eaecQtNQqVbvvIrCAMV3MV6vaadglb6WIFAtKW6sW793FMG
	uDMZ6Z1HB/wSuO7SaNNs/pTAdH+cRwwx/eUw==
X-Received: by 2002:a05:600c:8483:b0:485:3f72:3230 with SMTP id 5b1f17b1804b1-486f4430051mr100136185e9.15.1773909340450;
        Thu, 19 Mar 2026 01:35:40 -0700 (PDT)
Received: from localhost (109-81-88-11.rct.o2.cz. [109.81.88.11])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486f8c292e2sm48894715e9.2.2026.03.19.01.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 01:35:40 -0700 (PDT)
Date: Thu, 19 Mar 2026 09:35:38 +0100
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Daniil Tatianin <d-tatianin@yandex-team.ru>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
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
Message-ID: <abu1WmUNw8c3ubGO@tiehlicka>
References: <3db237d0-1ee8-44b7-a356-f3015173f7c2@yandex-team.ru>
 <abphjNOYaNslTA90@tiehlicka>
 <7ca9876c-f3fa-441c-9a21-ae0ee5523318@yandex-team.ru>
 <abpue_k_9mjQAP6X@tiehlicka>
 <73322279-c6f8-4319-827b-938c20c96b9b@yandex-team.ru>
 <abp3-iJbazCpygIm@tiehlicka>
 <b9ceff32-1f8f-454e-84ce-b8788b3a4952@yandex-team.ru>
 <abqQtcNqxzxiZyf1@tiehlicka>
 <fd7409a3-5f8c-492b-836d-559b001a61dd@yandex-team.ru>
 <absA_ryDAnfaKJXC@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <absA_ryDAnfaKJXC@linux.dev>
X-Stat-Signature: 96zwi3md8phd6wp5m7tikicdw5x1wfo6
X-Rspam-User: 
X-Rspamd-Queue-Id: 35B3D1C0003
X-Rspamd-Server: rspam12
X-HE-Tag: 1773909341-577381
X-HE-Meta: U2FsdGVkX1/5uVXRV49a5zF3EHpRXAk/ajzRT9BnUbag7FVe7b6QZt0vMDcnKyJbfsFY42t4w8RMoykAwF2ESyvC0YhXzGSxJC1hwkcGypeWDqfkXvUP8sm/6fjzCoH/6YW+cGvTbGKsmUWRDLbTnuQiB8wUFBc6DhTko18njeFliYgFbwQC78rt+n/hHCbGZYEmkGWm4aWbHLSCqo8MW13/VBICGC6cGkuN47c6mv7+sDL0/NS0TEvWXGZKSF2s6BZ5N8dY7apJTYzJ8Frn3jcGt/if4Uj3jXEqLdkxHIrfXXdjyKwy9Lm8Tw+NuTlhpU/a6FvxsHuw1x2C6ZU8u1/tLh8nNqeNVW45B0TxSq2ZSN4RayQ2BUNnSk4l0DlDW5JVOgl4oV0rOXASdUisDxfOnBvvKYOM/d/juawMVaM47w1so/Bz7Eaw4xwwbkyVOOb5c1odQ1IOynNd1QbR02Ivd/vnJfrrg9aGXCGo1kmx7ZDbzNP1RjmKF8R3eMLjlKk8lEORBUQIbCby1p/pnyGfqIDFEld1Sne22djRhdnh5eFqxXERxaw273dc4ssvXK/ZyTH+sMMc+jZQZfHclQZMOveNlVXPTHzpk0WsEWSAHtTAvLnNGDDeBtooJ0rpCho1kD22sOo8/1dYC5cyW4S3eta5xZynWsraAgwP945BjarHuzBMrk8zC1XoR40sfGgOChlDHPfvXizPowUZGOXVALQqAlAvONVqkkszPNA+3gdXxLJm/BxNlJMtIDYkbYo34lxCmcsq3lNmAsXoij9vQeYN4GmQPT/Uy9C3B1cEk1vm4PNxxy407nxlGXbGI2RofLcjWJlclr8M+215pBnLX5XBNZik1kWwzUG/23FOWc/hy8qdNk0Ibs+YY00+UjeHSCOx4X73GHGMKppruIiMQuV5c1H2k2uyymYrql6yYoRtO/UVAc/4TW3kpT8sXn9o82W+PHNuqwpRk04
 FNBJuwFh
 wX5/B5yUlCO9Aa61sg1D2nwMM2SUFPIxJDWly6H9owozQfF6EaGuxGMSKJvqlmI4KM2tB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 18-03-26 12:55:49, Shakeel Butt wrote:
[...]
> IMO we should actually deprecate compact_unevictable_allowed and always allow
> compaction for unevictable memory. We should decouple the notion of mlocked
> memory from the pinned/unmovable memory. Pinned memory has much more
> consequences on the system related to fragmentation and availability of larger
> folios than mlocked memory. If there are applications which need unmovable
> memory, they should request it explicitly. I don't think there is an API for
> such memory but for such use-cases, it makes sense to have an explicit API.

That would be really hard to do in a backward compatible way and there
are workloads (e.g. RT) where mlock is supposed to imply even no minor
faults.
-- 
Michal Hocko
SUSE Labs

