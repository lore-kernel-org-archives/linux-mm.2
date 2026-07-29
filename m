Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DA6BC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 13:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EDCC6B00AE; Wed, 29 Jul 2026 09:59:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C5BC6B00B0; Wed, 29 Jul 2026 09:59:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FF496B00AE; Wed, 29 Jul 2026 09:59:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C53C6B00AE
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:59:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1CDC6A1A83
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:02:28 +0000 (UTC)
X-FDA: 85041071976.22.016499A
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id 19C0140010
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:02:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZjJ9xaPh;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785312146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xqNI7GzmVD+ON60PavI4uX979smGqBUstiCgQqn1YZU=;
	b=tb41W75Ruvl1Y08iwjJRyQD4fkm69iHdckZS0oGXEcNvsIYe/ckufvPDSzYQMzwNghLNj0
	X3EBLCjtWJ3HCjAvWhNvbaOaigDHhsAg4o+JXDY551M17VA3WW0kEF/t/hp2agEZnaxVOU
	i8QhnhuUZEh6ACLlmu80FoCFIL8Q6dU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZjJ9xaPh;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785312146;
	b=2qDMZdRz2yPsrZxnRUMbna9yvgb1ezczRwCPrPzjIkZmTVKCR8I6lzqbH2Yo/6aTM6k0eY
	4hW0mKL7r0NIFIRpVEhdQpzLDVxD73hG7R9CSdrAIQvg3akchsxuFvXlyXqUqLMzea7MEt
	Ly9q86lRkxKxQB7WKWQJP8jvMdc8tUk=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47f752b3423so400156f8f.3
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 01:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785312144; x=1785916944; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xqNI7GzmVD+ON60PavI4uX979smGqBUstiCgQqn1YZU=;
        b=ZjJ9xaPhKIqA5JWa9RjCVsOtdzAfQDfkgwxSLtyW4AF3mLyz71VsZAnjblr6PqicnN
         eXPtHwAQDWqxysZm2T7vH9XkovfmI6BeEkL4rbh8BQc/hq9hn9UvJBy0AyysDlGqnzC5
         4CfXFugzDARUnODsJiSb6HTBK23lcoqelFzvMdwSPW1R429sw5i1c9bY0OdQmdovgI3x
         Ixc48WMqQa3MdqavVKAfoSu/w+z5qucp8NfabiBc0Ofn8NSnkbt6UR3glA3F5ptJACHo
         EeKj/nNtf+ux+n0LSEhj5QExim/ooOPM99Dat1Z6Vbbf3U93PGn34lwnCvN4lFlB7r2A
         9eKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785312144; x=1785916944;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xqNI7GzmVD+ON60PavI4uX979smGqBUstiCgQqn1YZU=;
        b=FFD99zMptVAKU3xNBWuy+ZI/WzUjqXbT02DAQLnGHM6Zei17s4OhvD8yq9j51tKhMe
         e1CqQLAdcplDIdJIv73yy9PVUn44xHGnRJqU/DaEMiGbEl9XDGL4EqbXG5ZWObjdRWQb
         OBs0EImltzF+kMhaNTaphAtihEVCQAqGJF+4YH6iGOFY2x5jFeuQKxQeZNrrSfrsYVBL
         ubiJZzWILJGIz/3YK5EfYHEUn6knAFmcNqiNb/0j9neznVqCkBMZ8cDaiCigRRkpgMNo
         lkCO7YAteY1F0I1cgmDLNAmsm1hdSEEYc3yYkLwJ89q2N26rDAhyJiKfB8phEFiieXJc
         7Q/Q==
X-Forwarded-Encrypted: i=1; AHgh+RqSNsC0L1wZUPqlXSKVX0AnZadJSjSKgY2aHi8dql7t/eQWKJ5apLYkzDfL7uN4IEb3t4WWG0Hx4g==@kvack.org
X-Gm-Message-State: AOJu0Yx6j9qTthWmg77Dlq8nWbYp6ZKourp+Na3JsqUhi2jShRUt2SF9
	UtUS4aFHPdAD/c1nPlrAPCCH1oOarJYVd3ysid7Ny0GDEvp9TDMIzQW/QbQ0Z8J2sdftjBafdd0
	VdM1ydq0=
X-Gm-Gg: AR+sD12sDCqoXQxLiOchxsgPz6Qpl9ll54fHdQ53Zv7y+aEu5BTz7/T6i0bZ7mQrIZi
	IMm3ckEnsAee4FJt8KWwr+ctwefqizTsVzmWbOuK1SmHBiJj3eTs0AyCB3Dz51aM3quaWzYCE5q
	ai8aXPY4BMsaAZ+JDj1rIJRhr7VR86BPIFyKDJksRw+Af7J+8zc0QZrHOzV5QEtHJ33HOdT62eM
	wGV5C2f4zYdGNOB0ZasBi4swG3OExjj25XxSWukKMziCsBqynK6LikUuQR+DQTyTQhK9UamVHo6
	EIZu00FbsxYbE3908R32XTqbIChPWl54VS1Dp+JLDGskQl1exw2DZ1wyZzG375gAw4w6R3ZS0OE
	B0hYD+jJuXlHGgj6WNn9uRR5X+AS6u2cbVQ7WyIbBD8Z8w5hyBnMCN0O1uBd9fRhT4kgj8eQs73
	FtXp7mR3iW90U45feDCX2JWyqE0hmVBPesH9mkkUrl/bqaXLHgOm1iLAt7SyKD51mRbIK147obx
	ZPpyJaj
X-Received: by 2002:a05:6000:2011:b0:47f:97f6:d39a with SMTP id ffacd0b85a97d-47fb1ed839emr6971287f8f.17.1785312144463;
        Wed, 29 Jul 2026 01:02:24 -0700 (PDT)
Received: from localhost (109-81-83-7.rct.o2.cz. [109.81.83.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6b18a9fsm5229420f8f.32.2026.07.29.01.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 01:02:23 -0700 (PDT)
Date: Wed, 29 Jul 2026 10:02:22 +0200
From: Michal Hocko <mhocko@suse.com>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg: stop reclaim when a limit update is superseded
Message-ID: <ammzjkUIADCxO2mP@tiehlicka>
References: <20260724021805.1234583-1-guopeng.zhang@linux.dev>
 <amcT75pLmA0hRUm1@tiehlicka>
 <615d091c-bd3b-4686-817e-5b29756542ff@linux.dev>
 <amdkHvSMj95DUri5@tiehlicka>
 <f706d139-53a7-436d-adc5-c691577ce53b@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f706d139-53a7-436d-adc5-c691577ce53b@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 19C0140010
X-Rspam-User: 
X-Stat-Signature: cx6esi8mgtwcazek4ge6tbk787jpmu4j
X-HE-Tag: 1785312145-434943
X-HE-Meta: U2FsdGVkX19CW1B9LXiiw9ZFtwuwQqAtfQwmE2mw4MGj/j2jbQ5kJ7qApLArfyQ0LZB8y1Pu/i+jgSgrQHjzU20DUX6sArXKH5ms3hSGtF3NAGIIweKXCUE6I/1B2poaWyXEmk0bPDO3g9wIE8qdRaHRk9xnOpTs0rDhatKaeeJeCUXCR/XcyAuvhixeh7pmIm+M+h6uiqKBdUtX1Pr9+yHXXaS+fGSUrL1yhjszkQBGj0KuoLARGVnhS8FGJRTu6NSV2pDKKbcvaEkZrpAYJ9e/Z6eY5lB6OgwxwX3ciyYnfbC8+e7eM4yEqwvWWG/SbSdGtf+6R53RDnhPDyoSGC4Dm5hFZcS9SShkGlHRflcUwXpL51GKyjQFZGAwEVmur4UQAMNPHOJ+an6qIfP9PQZgGRNF10yZzFv9v/4SmHyg0CguRlpxSVYCvD8G0EoX9UGFxaW7A/1iEze/uiGOcnmMFNPdA1yrFRnK8mngRrHS+KPrPMg7CvdDUbEtYUUWrs7ycTBBmr2qlI7ggZfcs3UAgR0NY+66ETU3r3H5iYI3A0i9ztD+nUnDEp0e/82G19fnt7NWOSSntyk/cbE/LyBFxMnJFHJWmsvtbZRoaocGNZWa/5nfct5GPtYS1eZDehNAEtyUwEl3NnXFdv1/7gw1xWTZUkBmAtR78Znv29isk6CiLOekpS+myvO5yWlIMsrL9RuyIg/Fo7/LqvAe35o5N1t8IBeVxzLvAXUpjtOC+ii7wngXwkYLNtauCO9ex884lrweXcoBoYFH5gAEZYgF5fgv1Jr4zdeMPT5nPNbEJCyR/15DB7ZafQD26i/egbzy7UC66HDea8E7dzcjd3VzFgLQUShGPTta59wK6r02Kiu7T0Yio8NzU2pqHWLlHo+Ubd3Y+3Kor+lwT9AsGHBH9MFa0wdnOE4eou+ftNOc4GfGPajQMRHcwamYnJa9DwHGHbJYLOZysSNzp2I
 v6pDTaOy
 8ATrem9G1FAhIdBG30Cds96tTLCErkKw6OrCwvgWWj1RBE9V7uDvHAWpPFfs3FbBOjkw2+BXqfYsQc7a7hjfziRVQrYGzmu1j9r+Ia8cP2frIs10m5KNSDVzEN1q3aMalzeJQwmNVmjB/b1QpadasmwI6waNZdM7HJZCUgoexMOl6lcXgxrWUYtiXczeTHvUErIL1ONkexhU+YaLKxEA+6NJSSVfMl869Unf61ALOatYuNHo+Hdiz68JaTyIVaxGf/jnx8o0ZRGGu3Nb+2UTHUDQdSAC4tr6im7+QPqz8vzfQZSl3Ilv+UBK393Lv088k/BGaGS012t902eAK/KejcfC57GRRoaNImL2VfVmzEYR4iQYiOd9dtHHEt+6y2BokYf7ivNZtceX0FZMZaVEuSS5/Y0uXAWby2UbWXjY8hx8XCU0N5sW64ytMSOoKG/xTIqezFYPQsMSy8jVcBUItWzR5OQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 29-07-26 14:15:25, Guopeng Zhang wrote:
> 
> 
> 在 2026/7/27 21:58, Michal Hocko 写道:
> > On Mon 27-07-26 20:59:23, Guopeng Zhang wrote:
> >>
> >>
> >> 在 2026/7/27 16:16, Michal Hocko 写道:
> >>> On Fri 24-07-26 10:18:05, Guopeng Zhang wrote:
[...]
> > Is this trying to replicate any real workload? One would expect that
> > writers to limit do some sort of coordination otherwise the exact
> > behavior is not really well defined.
> > 
> 
> No, this was not motivated by a reported production workload. We found
> it through automated randomized testing for our cgroup observability
> work and reduced it to the reproducer above.

This is an important detail to be mentioned in the changelog. Describing
motivation for a change is really important, especially if it has direct
impact in user interface behavior.
-- 
Michal Hocko
SUSE Labs

