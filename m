Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0F34606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 10:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=oVlyPKyI
Received: by kanga.kvack.org (Postfix)
	id C1A1A6B066B; Tue, 24 Nov 2026 05:10:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCAD96B066D; Tue, 24 Nov 2026 05:10:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE0886B066E; Tue, 24 Nov 2026 05:10:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 90DB96B066B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 05:10:39 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E121CC0B2A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:10:37 +0000 (UTC)
X-FDA: 85469593314.26.5D6DCD4
Received: from mta1.migadu.com (out-133.mta1.migadu.com [95.215.58.133])
	by imf26.hostedemail.com (Postfix) with ESMTP id 538AA140009
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:10:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oVlyPKyI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.133 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795515036;
	b=hnrwKGY+GSVfZ/DHyWs5odE19oNPj0Dc5367lCxV+TMLrZVyS/HQYuw0ll3J83dOeWbj5U
	Ir420YuRb9gER9ZW5DgR3zOcoP9tOSjKuGoRIr4CmyGPZsSSrbemoUcCda/HIIuZKC4qbv
	DSbRooklp2cOrEjwX3ogARr5OQF24L4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795515036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ej2Lub/tWmpWAD/4/8+6tVg5UvNwsYEnIAhl6l7BBpE=;
	b=Sk6swzXCJKcRSfrSQQtDC1Wq6Bw/zzd+EoxZXSyvCAtQ8DUsv621e16ssp+ty8S/EOseut
	aFAKm0ns9e0a++bN0cIMy8yzo6xj8u6e/+iGX/aaX6Jy2Le+TYEo1OANcv0gfSCwj9EhEJ
	wqj/4e/EbyUpRuV5iv2TJT0RmhIAF98=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oVlyPKyI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.133 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=m52rwqGBVeSAn1sDkoGDzQa96arP50zJyL6GkfKJuOw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795515031; v=1; x=1796119831;
 b=oVlyPKyIdIBseLfLogA1l5IItLV64Baq46W/wNB8015w+iB0RdTAjDZrrY0wPhZtd54cHu/p
 aEyAtt3SunaLIJyl8NQy+6qHOAoS4IGPPkCKm4C7rbAZXleOPBaMu4BsOZ47JNpQvEZbJkdaPw0
 fUPNCiKLRU1tCHnKm2O4uYb4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id f5186cc52dc81d0e;
	Tue, 24 Nov 2026 10:10:30 +0000
X-Mizu-Trace-ID: f5186cc52dc81d0e
X-Migadu-Flow: FLOW_OUT
Date: Tue, 24 Nov 2026 18:10:26 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, david@kernel.org, akpm@linux-foundation.org,
	kasong@tencent.com, baohua@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com,
	baolin.wang@linux.alibaba.com
Subject: Re: [PATCH v5 0/4] skip empty PUD subtrees during aging with a
 PUD-level Bloom filter
Message-ID: <awVikjVOOs5XnIsR@fedora>
References: <20261123085800.981256-1-baoquan.he@linux.dev>
 <awR-UsoEGg733fQA@gremlin>
 <awUuwi7Jwt0BQfJs@bogon>
 <awVcG_YxoL78TycT@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awVcG_YxoL78TycT@gremlin>
X-Stat-Signature: 4wpxjmfbcuxb5yja899an17najsx917t
X-Rspamd-Queue-Id: 538AA140009
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795515034-584000
X-HE-Meta: U2FsdGVkX19N4nYK44I5G7JsHoZTBYB37IBoRyK0+QN2wAOAzvUZdtsbqAkdsGZAsJNkI3li9u58/vQWkxk7JewtAb945yRqfGau7PJW5yshLFOMWvpyQr257oGgO9Hk/8SNc4Et/RZgoCli+BCLIfUWp5DU/6RWO/6zYn6Qqdrcw3itz5SohNdc0YIsYVgyLkPfCrWw0EeVmDwdlPu5ME5ZrVutxTMm+BhbFb9pm5cp4EGHPd3JTZadB1LXvchJQa3FTFnMMuIUSZqqAaAiDE6kij4dyiXMQ1CsHlXxLAopvunKoGNDE/O24cfSBoXaiq0vVr5q4qkcuNdd8a7h/uJl6vLXmO24i6oO4veV9awPHvQ9duViVfBp/EiWH9VKDslXJK1q2UKzkleIrDn3HHJQLwkCCzdBQFpF2Lk0+zAGgpQfVWbW8dlsiaugY+OU5JKcsEgtNuVZL2/CiYVqpcizGtPPrg0nReliFc37noXBNlEMFPJP56/S8n5xIFkI1ynjHKvvqGwwPKHkYoKwc4U5qUV4HBQ4N+MXmSi7JnchQiPqEq9kk2GUwrRnh+A4t2GDFudNgYroh8YoCWSafAu35izlOm/Por3SNd06NPNLtAjJV4ZjfVrMVLHTAd0Z5hRsrf0asEq6Y+kbtvsfrF1ITNDFh7FkqVxc4jrLyiV3QU04uJRi9kF6Lts9x+qU9ge7J6rX5Zz8anzCOd2sZXV6A9npjeGqMm9mrgNLuWX2q2mHKYd0zntuS4ShcB74puPPoHGvVVmBNV9z6/6wRNNDi6kLRcA4Bn2AMxNPLFrVUu9zkft/uQ3A01GeoHzYR8hZ2ySmsPP3ATx1eHGJaVqrCNOZYyHpDZjYqi88DxsIlI3GqcU44cgOPIJQzquhL8M1YCD4DqmleA4TVH2wmlC7LwBgTsonzHLo9WeYCG+1SLpz9DcGu6h2DUAJn9/COgaECZO8lWx7qymZN8P
 co9Shn9B
 jO5L9Sw1rCHWxDOBBNMRkGZs6VHy4X9FGJLQ7ERu8Y6mAscBKfrirJEYv47f7/zgBMMyO3hpCdPQ5BaQwstUT9ryoYcmV3mGjZvo8amcHQ+QhDWHEuLGa5+6rmncHjSzJYI+TVSIBXnKgSEUiNjmpE358Xt0Bo7v41qpskVwtgTyuP5jHLFBAdCN/XEl0wqA4TwQsSEYWthVhlZFzGegbybwx+JZNda4hQWvRwS6cl1OCZVSp/KBu9iPNojTvdV+wSSiDRB06JayiEAFPR9EqOxMHV/ZNxpUCIuSl+QmYGhDKunJgTYD6OW+aIUjZbzAeXvN5wql3t77kS6hAoo4DF2un+lgcd5mP7ilkEoxerw81ddK7AionrkKCI51XewNv3ZwcpvQCLSmMamUcNUJmRNSEj+C9NeHfsC5UkUbVBWeByoG6R5lVWyGEfKkf7GRH/KbJ5lGLlQ4fqPRLYf337mV5RL/GhOc57lf5vRSP3VosT2e6BAZOz8qAEzO6SzZ7wlav
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 at 09:44am, Lorenzo Stoakes (ARM) wrote:
> On Tue, Nov 24, 2026 at 02:29:22PM +0800, Baoquan He wrote:
> > On 11/23/26 at 05:57pm, Lorenzo Stoakes (ARM) wrote:
> > > (Got a script set up to detect things not cc'd now)
> > >
> > > On Mon, Nov 23, 2026 at 04:57:56PM +0800, Baoquan He wrote:
> > > >  mm/rmap.c              |   5 +-
> > >
> > > MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
> > > ...
> > > M:	Lorenzo Stoakes <ljs@kernel.org>
> > >
> > > Please cc- me on rmap stuff, thanks ;)
> >
> > Sure, will do next time. I should have used scripts/get_maintainer.pl to
> > collect mail address, but not copying from the old thread. Thanks for
> > reminding.
> >
> 
> Thanks, email-for-development continues to be... fun :) though I do very much
> recommend b4 (i.e. b4 prep, b4 send), I resisted it for far too long, but can't
> live without it now, it just makes everything super easy.
> 
> Like:
> 
> $ b4 prep -n name-of-series
> $ ... do work ...
> $ b4 prep --edit-cover # Write cover letter (b4 adds a dummy commit in tree for it)
> $ b4 prep --check # do checkpatch etc.
> $ b4 prep --auto-to-cc # automatically figures out who to send it to
> $ b4 send # and off it goes

Ah, it looks super cool. I only use b4 am to download patchset sometime,
can't wait to use it. Thanks a lot for the sharing.


