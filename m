Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 520BBE9A031
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 18:52:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8585B6B0088; Tue, 17 Feb 2026 13:52:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806406B0089; Tue, 17 Feb 2026 13:52:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E7926B008A; Tue, 17 Feb 2026 13:52:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 54D5F6B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:52:55 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D4CFD16031A
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:52:54 +0000 (UTC)
X-FDA: 84454845468.22.E9DD6EB
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	by imf18.hostedemail.com (Postfix) with ESMTP id EC7C41C0010
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:52:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AU97pBHn;
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.66 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771354373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x46hiGoEyZZRfdFs36nFSz1+AdsW3p14nQ3Wm2zf6Qc=;
	b=JfmAIs18sssm4CbPZTH0BEWUuW6fxbf64r0s5QEF5n27EchVgd53F/7yvvm551/htvmTcS
	cz9Sc3CED2y56EQ2ZhH2RLv9r3Fe0ihG5+BMMisAo4fFQ/vcAjq6nT5UbAiLRtQg2IjN2G
	JAoGpw4Y3E48oxYyP4ms0l2qIs0ABoU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=AU97pBHn;
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.66 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771354373; a=rsa-sha256;
	cv=none;
	b=LHZA/1dTkjL8JIBKOoAUkSf/97rNPS4CtCrycQ1Rm1D4XzqEJkC3BuoChE5Bd0EuRuHRcF
	vWcZwEXGwG1veCcA65uVRcewOm1HAdWjYIqGJMlvIZoYdarQYmSyZHAzvdaKt+o1zd2fWm
	JMSoqbHIrCb7feMR6JP4seHLcNR6YCs=
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-4833115090dso41042995e9.3
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:52:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771354371; x=1771959171; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x46hiGoEyZZRfdFs36nFSz1+AdsW3p14nQ3Wm2zf6Qc=;
        b=AU97pBHnZOuHwulyg1DgweixhABEG9eueq3oiLEMNG46FlkZUBwyGsc+qEfoOlGs7Y
         ffDmin0ioVTuZM9DEKQcRRl7UhSTKVYl5w6UYSzTyqRbjORjZX55zWYyikyqVtlHJt8h
         dhGTLo5rQKDEA0t8Wmjam7Puwo+oAfZ5jqdk4DYkEuWBcLmC3FsKuzgI4daOjvkIFhuC
         iMhkYtl0I+ebwH9xoGFCsFQBQhTwJZl5ZEOaI7WdX4cShwavukLVN6wBsT3gl1RAbYAE
         Ahm3ZLnqH2RuNKLrZhDbv3ZTSvDzaNiXKTlmTbl0mHN+0xZxZymJxyp8IkXUGMK+KRv8
         dHuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771354371; x=1771959171;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x46hiGoEyZZRfdFs36nFSz1+AdsW3p14nQ3Wm2zf6Qc=;
        b=Ryb0qBDWU5bxoKgMoXArMOcB8LO2vj9y63ZtBtAembPpirqMqVISNveO9bqWpcQaJy
         frcNLbMmFgPZIMkzBIgFFdzgzNWhOzSnB5deVnl/TOvwwtBssVR74dKGv9flB5zqJ2Vx
         TWNEAF3T4iwXgjETz83Qu8F4bo0lUL7Ht93sQ8aX2TzGXEzQ32ST9ksBWv1255tqgcm/
         nwlQtCRHnRk+NJi/P6e0LqLwbiIsixMEOffj7XJvkvgfMQy49htTzIcBNviuV4LnFpJn
         yGSBSSQai4sZWAGR2lV1vlcjTM9kVeQDKtehphJ3k+zFFJ4vB5BMeRfBwX6eUEizKvyH
         nLlw==
X-Gm-Message-State: AOJu0YxClh4gpxiz6P7Vu8J2WYuCgJzb8JBzI79mLHAHChu+PPU6OEID
	PkVjVxKyOjkvM/UhYg+J8ocPCJjiWp5b3qhUo0NpkVFZl/hPHVC1AUJaUk0v4ZcuYUU=
X-Gm-Gg: AZuq6aJh8acX3CHd8FLs+1bujEnRrn18BEFJ9aK/F9GIz1PxiwNn9YE9Dc4mmSaWeV/
	GQtZ3FQBQBLZTmxrRV7OYdtMLFMSMLwB+oKgXm1HucIMFtrSlUKp369brmZizCSeziAd2kLKcCC
	4+pCc3vzCU5rmcDP5ctrQ8y41mPF0NvcyLpFfeM9JIo0iB1hMwOHnE35rF1hpK0TzFTMseMGjkC
	ZNfUBebt95WeDv24XwwTIsypcBEFlhCkwSx5bfqA7+WiBmA/dGLRQg44EX2pQ7CX+wRcacLDWY0
	qqfMqyoXk0XppLzqjPBV5c0gqyv09V5xNbwkNR5Mt6s5XwBUi/1p1KAVtIQnTGISHgNahgW7HA/
	k9hxwyr5zqi+Q0D4YxNpFEwphXILnsNd1yvkxI+LAftU4FEcu2TeYWYLzDwWWEW+0DYxz9ssKxv
	pTCwhK1VbN1vv9Sbgs9akQt6Bt87fDD10ohCsT
X-Received: by 2002:a05:6000:1acc:b0:437:678b:83c2 with SMTP id ffacd0b85a97d-4379793eddamr28020353f8f.54.1771354371131;
        Tue, 17 Feb 2026 10:52:51 -0800 (PST)
Received: from localhost (109-81-87-131.rct.o2.cz. [109.81.87.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796acf5b9sm34218187f8f.34.2026.02.17.10.52.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 10:52:50 -0800 (PST)
Date: Tue, 17 Feb 2026 19:52:49 +0100
From: Michal Hocko <mhocko@suse.com>
To: "JP Kobryn (Meta)" <inwardvessel@gmail.com>
Cc: linux-mm@kvack.org, apopple@nvidia.com, akpm@linux-foundation.org,
	axelrasmussen@google.com, byungchul@sk.com, cgroups@vger.kernel.org,
	david@kernel.org, eperezma@redhat.com, gourry@gourry.net,
	jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
	Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, matthew.brost@intel.com, mst@redhat.com,
	rppt@kernel.org, muchun.song@linux.dev, zhengqi.arch@bytedance.com,
	rakie.kim@sk.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	surenb@google.com, virtualization@lists.linux.dev, vbabka@suse.cz,
	weixugc@google.com, xuanzhuo@linux.alibaba.com,
	ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
	kernel-team@meta.com
Subject: Re: [PATCH 1/2] mm/mempolicy: track page allocations per mempolicy
Message-ID: <aZS5AY5bnPjAmgN1@tiehlicka>
References: <20260212045109.255391-1-inwardvessel@gmail.com>
 <20260212045109.255391-2-inwardvessel@gmail.com>
 <aY2BcIHIARSwwQpo@tiehlicka>
 <eca7a8f9-173d-4cb0-93b3-df082b8d0c08@gmail.com>
 <aZLUm95Y-dKkdBWI@tiehlicka>
 <3fe7c5dd-b184-4421-a21c-bafce6aa7b09@gmail.com>
 <aZOHIQj3pJ-9dW_0@tiehlicka>
 <9ae80317-f005-474c-9da1-95462138f3c6@gmail.com>
 <aZRg_ZSDkbGWv7Vq@tiehlicka>
 <c71f5dc7-d337-4510-96c4-38a83fca29ef@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c71f5dc7-d337-4510-96c4-38a83fca29ef@gmail.com>
X-Stat-Signature: 9tcyd35u7gme5x7jgd6uruby3d1k4xas
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: EC7C41C0010
X-HE-Tag: 1771354372-803814
X-HE-Meta: U2FsdGVkX19JAD2RbLwS2quQbeq8Bg152lThbRC0EWvAy9iMa1SR+VuRNE+nSR7lU1KPZBw40LaC06R5IeHIPZRnjwqJIzzB0yC76mBbOBItYgixwRHpqGF/IyliolXBj0nU/L1c800BXooGqcpUxpLxf6NeRNVwPdx/KhxnBtRbr3mbS4L1Ing64l0peKjXPB8RU1skV9nKiKa8wKZGGC4KdOujDxVPwNFW94RpvLWTU3UMA2RpPWzJ7i6uz0GjE3TqnOITfu0l1W5flBoWYhYa9QvVOZyQNigMwf3W0ko7pIrSJkCEpfKl8i/+OA4/fV1uYnbXjEyok5FbrUrptQQnND+8OmZDqPspVBuVQzB+txmEbqPanps+epOP5dK3sgzBuQqAY0j6KeuRM21+Lie9EgPYLy/eNAjL2lhKIrPOxhoZ2r0HcP130XPK44WU3M+1nkpxeHaAWvMvoA5XpxVrAINNP5dk9566N6VajEfiVFlROYPxeQrJ9+6GBSNizADqzkCrF35sK/XURVj4BV1O9uTqrlZ4RyA+4ZX6MMnldvkGZwBKln88WWK7P//hU2Cf1gSiZBgNn7EKEOgwiRk01V+/qg8ny/rVchss6iyLIYR+GiWPDeEymdYBBnv3aVHqkqjx2r/nZyN/oD1b9W7nj3nfGr2Gpw3GecXpzaoP1xKEdYb8BftRk+Ij85DjnEdJ4YvAbYBiJXQg2S2MAWSJitkDZDYJfA1QrCs2U+LonwedaNwsDfW8V63DeT7XdjL0bLVPazt5TgyQGU1CGoKxyQTj7NtU+R3PrCHgK7IFQdtIxtIV9Awbv9gXig0pARjayslPq/gkOt2QfCKQs0WlpgZChKX/FtuN9mk69a9FN2D3Y1tMYnIcyq28LzYXoqp0qANoJOYzSZYrUqcI0ZYHqibXxns8OwwEizJrvaBQzH1EANOc5emR3Um7pp7Z3O4oI48SOmLWW8b9Nuz
 Vkj7iYPe
 u4B5Bon3UbkN0/ANaglWVj0FOzmAnyjAWT3U9F7QAPH14l0R3DEWIHCo9FhJVKK6DDzJoJpAnBb3NWMId80owhy2ae7G7CAbHjv5lvAcuBIGu6JPEl9ZMZIrPwOw7Hoi0uYZ/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 17-02-26 10:19:08, JP Kobryn (Meta) wrote:
> On 2/17/26 4:37 AM, Michal Hocko wrote:
> > On Mon 16-02-26 23:48:42, JP Kobryn (Meta) wrote:
> > > On 2/16/26 1:07 PM, Michal Hocko wrote:
> > [...]
> > > > [*] btw. I believe you misaccount MPOL_LOCAL because you attribute the
> > > > target node even when the allocation is from a remote node from the
> > > > "local" POV.
> > > 
> > > It's a good point. The accounting as a result of fallback cases
> > > shouldn't detract from an investigation though. We're interested in the
> > > node(s) under pressure so the relatively few fallback allocations would
> > > land on nodes that are not under pressure and could be viewed as
> > > acceptable noise.
> > 
> > This is really confusing. You simply have no means to tell the
> > difference between the requested node and the real node used so you
> > cannot really say whether the memory pressure is because of fallbacks or
> > your mempolicy configurations. That means that you cannot tell the
> > difference between the source of the pressure and victim of that
> > pressure.
> 
> What if I excluded the fallback cases? I could get the actual node from
> the allocated page and compare against the requested node or node mask.

I think it would make sense to send the per-node reclaim stats
separately as there doesn't seem to be any dispute about that.

For mempolicy stats try to define semantic for each mempolicy first.
What exactly do you miss from existing numa_*?
Do you want to count number of requests/successes. Do you want to track
failures? In what kind of granularity (track fallback nodes)?

-- 
Michal Hocko
SUSE Labs

