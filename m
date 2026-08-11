Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79EEBC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 19:13:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D2E96B008A; Tue, 11 Aug 2026 15:13:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A9EA6B0095; Tue, 11 Aug 2026 15:13:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59B586B0096; Tue, 11 Aug 2026 15:13:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 397C36B008A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:13:41 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C27BC1A01C8
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 19:13:40 +0000 (UTC)
X-FDA: 85089937800.01.BEC49D3
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9D009A000A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 19:13:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=AmbVgFR3;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.50 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786475618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JGgTTrOlpU5V9+iEvkXg7TLjlPJJLUAmemLOJS8lidU=;
	b=CVc4IZkdXFFgBaLlfaolbzaNJPN+zuG8a3G6alGvfRX0fcxHl0YZ2GvRB2aY8w4Do8FV5P
	7lE2LDNWvKv36yp8ytxsHG8IEpYqP+9KlDZqbwKln6S96JtDjhGnrJyKxi5rkqWIHwe2c0
	ZeM4RNhv+JH7N2Pq2+6pwtDRlhEI1Es=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786475618;
	b=QYUM3ZVTHql+PsuG77wPGgSC8jAt6j7og7MKfyJMwA7lshNLkQy0Ghh6oDvt4buEefWt1k
	nGT8W7tGBKOY6aaFpuIOw7ede8QbkQ3qxhqKZJzkcAaOvwO18e7jVSVTLKNjLu9+aiAELd
	xjTXgRkCCGNo5ys5BoqI86wnxlIjVUM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=AmbVgFR3;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.50 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8edda5d56a5so1887476d6.3
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1786475618; x=1787080418; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JGgTTrOlpU5V9+iEvkXg7TLjlPJJLUAmemLOJS8lidU=;
        b=AmbVgFR3MGWXVr8VE5hAWxFin9q08JD2N7QVv2tsLLoRAffWuNJR3QVZaUYdVQyx5j
         OlY+GcNJPkeTgmY3wxpkaxiSDaaWvwSZgfTDltHfsEX8Xf5IGw3VZRg6lhZL+IfZPSaI
         1RVV6lTthnULuz9CDymeIap5pIKwOlo3yz0tQ3klWXrupIKQE2UBFmMLMsIdqPxxd9mR
         roflY02pt9x+N8zDCjGxWrfx8ymQ5GKHY3l3LrnlHGebB5ASdKbgefPUc29jE931aWS6
         T5fRarVYoAsA487m+nV8oefS/lociINNLQsFOr3JvVlIFZsfju8gB76WBl2qYsIHxLOH
         9c3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786475618; x=1787080418;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JGgTTrOlpU5V9+iEvkXg7TLjlPJJLUAmemLOJS8lidU=;
        b=lX0BUWCM/GukJrnVGn03KzzTj+u1LSXWVxrL09YLxK26ffkSf26DM0IaSW2XXaiZpM
         aa393iJG8IdTa1pMWK1IZDHVlbjJLp35Bta/h3EJEvc+JVpByozvFPD6TQ8/kqBMYKdS
         D29pjK6NG2DsYp56TsvxjyPu7y4TnEsa5pCcu8QQ6kWqyHba1dTJKNodZUL3Gm3qED66
         j+CRJKtEMf7/a3uyMJhhvQ5VCLim5eBVM+/RZxtNJXQoxqs6haptYBrW9LbY7hYiWA41
         5Oq7pzW1tEGXnWmZjbwBQpL1B/XxBBpXmqoohfa1TDYcooBWMSp9Eea4TBwffAnBUjbz
         fkqQ==
X-Forwarded-Encrypted: i=1; AHgh+RrXork3FGYHzKmLQcmdSSBQYOJ3D94tKkGzjIhEvsPFJBoE7Sad0yrscr+U7g2cd29mX7NVqheTMA==@kvack.org
X-Gm-Message-State: AOJu0YzpJ6kYRB6Gh1wZvhn2kCCKO7jenzrugmuxH2Oeqqg3tKFjjqeH
	mrGVa6hQy+RmoktUmEYZqfuHtJUtbVjgQHAZFBO2WJJ7Lx/I+uMjKG5PD6F20vSWv6s=
X-Gm-Gg: AR+sD10JddvVBIehksjGO4cEf3JLpCvsE8hRAAQoiAlwRQk8+EFwgTeLw9PhWx4xUIW
	p90r+vnfkNUtZgHOTYGWSnyxpewepc1RkiZmkiF4cM096CuB8wsEslHkenyvOwU8WrRpPxPJGSS
	BV4x4fBTOZPIU8T0MOfjcM+oz1eCdaX5uApcwTp+IsDMigqr++z8DMpsTPzxcKkwfQQhwHloPHe
	TrboYMYKhgSzSKBm2nd2gx0V5BIXgi/aQgBlQL4h3AjFDriaHm47Mn1ekR3hpLza0nL1/Ug7IxD
	9szq/yz7xFIIfJEk9EhGpo27PoKsWn0xdWoYeGJkGLq55h0jl13nmC2pggr5QwLTgUclrm1dy6x
	7HMLzGl19fLY0QsMvRMS02dBrU2KDVZe882w5vWI4bIVGj/RMIYLiHRpDYsw8ixFezXE62SmuYh
	JsmMqsTy9kNm5DtrnfShgzspxFYQ08wP+Y2JalA13ZQyXawT5STfq57wHkFmw=
X-Received: by 2002:a05:620a:198c:b0:934:9f6d:d1a6 with SMTP id af79cd13be357-936a8eefff8mr464006785a.17.1786475617703;
        Tue, 11 Aug 2026 12:13:37 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-936a85e5a14sm170303985a.38.2026.08.11.12.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 12:13:36 -0700 (PDT)
Date: Tue, 11 Aug 2026 15:13:35 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/page_alloc: replace custom bad page ratelimiting
 logic
Message-ID: <ant0X_RB3PL44l8b@cmpxchg.org>
References: <20260811172156.356053-1-pfalcato@suse.de>
 <20260811172156.356053-3-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811172156.356053-3-pfalcato@suse.de>
X-Rspam-User: 
X-Stat-Signature: aju3z8htbyj83gee65z9dzc7xubqt8f9
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9D009A000A
X-HE-Tag: 1786475618-667612
X-HE-Meta: U2FsdGVkX180yopGInfAniSjI4/Whj8bTrbtD4AmGw2bLEbmJny40uH0D+fUqZJrSNLC46Syp9cb2xM5hQeOa5SZYGQ+m2KEQBEAbON0QoxUXPkkzWTGQW3zQpr/P/g9UVaQ45hEW6lCTOBVtbJSR+JlGnezD8nSRUyxnW4DqzZhkNJYchyTeFjYUN58hJhikOZvs3S4UPEJXPS8DN1QU5QCkOk2sfVy1g+ffsO5ZGMMnyUPB7EgPB5q+gTfGsG48stO4I10SPPFbXqfOesN4kI7lDHPXuKc2pS320givVcDcI/+I2iCOrXD6MFzEUqF911XWQEbJG2pHmU0J/xYUOjcB4lJhu7fdYUvv3OIZBM3hFji+ufFoDp6O/X4t8UweP6X2CcZ8tRNiXL1sUSL53s1rpj6tBB/xw1NMfNjX29czP3bfF/vRJXTZB0E0JMK07yaxpf1iem0D7ocpOASXBzzWjxa+zPpREBZJ4Uv4rvke1QMvAwA2y0vnjFu25f0WCRNjPT79eiYrGCU8uFDTXRx84w3PrbLzwvI5QC0UFbbOabVc7dK7UqUz7tE7TfaZxBrhK69ECu0/geuGFhbESkUX1AO7XmqIk2NEUVnMdk5jAsYUlLc/O744eZXei1ZYDHKsoB7eIv5L8ilr8lINJ00YMhbrAk+u9JSwJFF94cvxTnGMeIbfdxRo8jkjxgy0LhzmGRslnPHsc5Q7059kMJBdTA/TyRK77g4KhzxO4KYiBMxO3t1q5FU+UhTJLJjIi1QlIJDYvHPrhYvnGA3z206E0kUj6c2lil98zNtlTn9Hcu//3BngqecOuFo9WMjMvE1gQbULR3r4vzPgol/8RlpcsyDZk42WUjX+odwksvrFNBwlbtc7NO6jSmv+6cukwuFCCly0MaH8YqgyE1TO0q+x6sL4PKOGtqDC2S1tluKvLL/ha0zehPzvLMo2SWbr8fG8Gw/k49pJ8HdtoJ
 qhADMRgp
 f+CbEM++U60Ieu6TfKL8lRVEVaoiLADaxjUJAZeGenOEUYNPjx8gC0a8sYfH63ZYzRYAh9wPZiGXZnM30A3BCZO6bjGrQT6lKXr4jdUHq99lFrbgShXweKB642j0/Z9ChJsxMukY0OrlurkeqAQEYue0XRAcLk9H7Fvq8FUaN0Jr1DyhNeT1VsCLMFVh4yPc1g+9h4DErVniJVv0Zpqu4vTL54i+GAopdSn6fl02UsKIy11gOTz01gmYTy3AS9608uuu/OGm6Uv9LcG/+TFyBX5/EWXn/YLY1AMRrGSuGjYiZynIphfdzSpv3pY1e9ELc415DixAEFP7Eq2hx9bFB3qPn/XeOqZU1yyoO7mjwCvivjyDSRifhjDeW7CZLUcqspkRBENP/vIaDQPvxf0wYFRta1kdiqI/HF4Aexd0MUk9hfZI64k1aJCJuFQWS7m18qb6DRZR3ge5J8c51T/tgyQBOAqdVvYUQcXhn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 06:21:56PM +0100, Pedro Falcato wrote:
> The current logic (allow up to $BURST prints per minute) can be entirely
> replaced by the generic version in lib/ratelimit.c, used around the kernel.
> 
> Do so. The only functional difference should be that the new logs will
> read something like:
> 
> KERN_WARNING "bad_page: %d callbacks suppressed\n", ...
> 
> But that should be fine enough.
> 
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

