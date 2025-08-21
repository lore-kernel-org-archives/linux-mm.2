Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BDADCA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 19:37:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B895F8E0024; Thu, 21 Aug 2025 15:37:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B61258E0023; Thu, 21 Aug 2025 15:37:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9EA98E0024; Thu, 21 Aug 2025 15:37:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9842C8E0023
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:37:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1A126594CD
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 19:37:45 +0000 (UTC)
X-FDA: 83801774490.04.534A230
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2EDFFC0005
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 19:37:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f6lHv4Ea;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755805063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qbcsp/HYAITfGuo2SXY/LG2h8CV6ti2SdCWAHkmo3yU=;
	b=CN06mfdEfUUMkYyA0fuHxs2kRKCpTDjjg8z91UOKT/FDFua1UExJnW9x9jLXIDIBTxoQLR
	A94R5uYIMz9YQPGzD6ksZX2Ii3L5N/2cvFc5Od4j6r/97hp9QHiXFQ/hFtK7r4MjGHMDLr
	zNeGpa59LDQhv+d8GblKCAZcajBxnTg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755805063; a=rsa-sha256;
	cv=none;
	b=m9rFb4DPbNpWehSXzmpWAXqlOFIT9cBwq5LHPUkSf9r07fLsvv3eiEnXv4ifooS3wjIZsJ
	+VCf8yvUI9CJohCrYUgHjPxyrB5dXgO1PvK8wnAdkeXX68GoJEif5g8O3SXj/HZOZxcoFy
	lkrHW4Ca1DnNczP6uQgrxGBsPXRIlsc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f6lHv4Ea;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 21 Aug 2025 12:37:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755805060;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qbcsp/HYAITfGuo2SXY/LG2h8CV6ti2SdCWAHkmo3yU=;
	b=f6lHv4Eaw6bRrMmsg1ePkmBAFmqMjou73pU0z8ovbs+rKATqeaaDENg7sZDADG5f9XhQ21
	8xgKJTX3fZM44T8tqukNb1IG45fTEJ2evsqB8Ms8WH2STndSR3678yyHb1ASpWqe/3KJBO
	ZEfQWqDlyKUcXnTDtlQy6c/p7mFdDSg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Boris Burkov <boris@bur.io>
Cc: Klara Modin <klarasmodin@gmail.com>, akpm@linux-foundation.org, 
	linux-btrfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	kernel-team@fb.com, wqu@suse.com, willy@infradead.org, mhocko@kernel.org, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, hannes@cmpxchg.org
Subject: Re: [PATCH v3 1/4] mm/filemap: add AS_UNCHARGED
Message-ID: <jewggm6jdhjmd2hlnxr4qgaqelst5ue4hviza6v6hgiivkxmiz@eiyng4pg2ilk>
References: <cover.1755562487.git.boris@bur.io>
 <43fed53d45910cd4fa7a71d2e92913e53eb28774.1755562487.git.boris@bur.io>
 <hbdekl37pkdsvdvzgsz5prg5nlmyr67zrkqgucq3gdtepqjilh@ovc6untybhbg>
 <20250820225222.GA4100662@zen.localdomain>
 <p7uqfmtrl5duh4zekgtf3vtl4jsstbdefar5nramp4aflcn25t@7pmvft4zmsid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p7uqfmtrl5duh4zekgtf3vtl4jsstbdefar5nramp4aflcn25t@7pmvft4zmsid>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2EDFFC0005
X-Stat-Signature: z1ec9kq5ypmyihcojn3g18u1443ewao6
X-Rspam-User: 
X-HE-Tag: 1755805062-65550
X-HE-Meta: U2FsdGVkX19ZZaQELaLbLJckPrSzMkqoGBhvscuy+8yGH4QaXk1N8Qb0XFDFU1GSnv/kiGVwnY+BADKiuF4IkU08lMZ3D3igyeoLYqAVMTYW4Q3D5LYMwY7KFlNYQif9EgsqYWdd3jQpw8ZAkh7KMwoWhvqMQF3Oq17CFELwMX8yYUvFC+8LhAtesxHghqQ5xXpJJc/pb+wshnjR+Rq+z05+ZNkz39DlR/qWh3fSymQdokgVlp1GjZfwD8DE1kIn46mkAqOw5NdL4Lnv6LqjmxFdRHgWRio4m7pinqRYc1GUk4t99bUzHAMOc1r64GkbrllObf7dKso2fR63/djDGz/doom4tlE2HsIovzasIwofjB5o4BZEINA/5cOEYdIj5pzmYgAu3VdFOyScPW9aq1lraya6DjfsqN1w2ZEGK1OY8ZqR308Q4l3l0fkjmWipyWRH7z4NeMsNoDKMf3QfC3PSPBH7vmMKNSkj41mAVxqb3kp9edkDUCMoR/MixcMjjnFFYFdN53ZsYYXPac2kl6yQxXQaZZxzW75JCsY4Bhn3gp1+QkOBKs88ZSB3e2NzuUllgxM4rqA/Y1bsgO0hbGcKAn86eUa4E3J8W/2E8qmMnxQeF2xnR5UbVcSpAhPCyImlExr86I6V1qWsIjd/ISoqlj0O+e2+7Ag0Y0E5uXARkkzfsD1ZH+bRIopVXBrKZ9pJJ3zpxFaAlfEbXRGR0fI1RK3Ou72Ubh4O0dP6IybYWj8Mh9YWArkBOLqMlJIbRmn+qL5zajdCTqA4UQQieGATzhRTO6IYgeb+jO6rPmAXsSgqoa8do4OhWidz47ilh1eYGyNJVGVYP5QGp8bXSEu/3uOkC6b2da30DkZQUUqOFuWWs4DlZytPl7vhqddcTYsD920Yn3gzUG0OHr98bizlPgVywc4flbXe6CyE6RKa6XGyYJ4UGYh5ZNLyoSEqmCu/Uoooxw0dQS2A3c1
 /MNolNEO
 r07bY8giS0RJIcjeD8cWbU+/cTn+K3GmTjRPGPMRyt37NogzvpNy0oPp+iAiWaraRuw41lF8EmlAYXKzwADNdE9MEJa1sifgZ1bgtiTMPUGUsYa0AxJjOTLq3MQ9+Q0urojTe2pLs6zD74YqMLGMQcIMzwN/ME09dYwOesQCDwD+ui5iUjvBOUXYTEPtQGgbYFaQnzSnqNhCdBqGQxVhs2bHVWvx0r2jFzkQcZg4mxXUy4LvyNfVlOQodWZmLKNJZthVq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 04:53:08PM -0700, Shakeel Butt wrote:
> On Wed, Aug 20, 2025 at 03:52:22PM -0700, Boris Burkov wrote:
> [...]
> > 
> > Thanks so much for the report and fix! I fear there might be some other
> > paths that try to get memcg from lruvec or folio or whatever without
> > checking it. I feel like in this exact case, I would want to go to the
> > first sign of trouble and fix it at lruvec_memcg(). But then who knows
> > what else we've missed.
> 
> lruvec_memcg() is not an issue but folio_memcg() can be. I found
> following instances of folio_memcg() which are problematic (on
> next-20250819):
> 
> mm/memcontrol.c:3246:   css_get_many(&__folio_memcg(folio)->css, new_refs);
> 
> include/trace/events/writeback.h:269:           __entry->page_cgroup_ino = cgroup_ino(folio_memcg(folio)->css.cgroup);
> 
> mm/workingset.c:244:    struct mem_cgroup *memcg = folio_memcg(folio);
> 
> mm/huge_memory.c:4020:  WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg(folio));
> 
> > 
> > May I ask what you were running to trigger this? My fstests run (clearly
> > not exercising enough interesting memory paths) did not hit it.
> > 
> > This does make me wonder if the superior approach to the original patch
> > isn't just to go back to the very first thing Qu did and account these
> > to the root cgroup rather than do the whole uncharged thing.
> 
> I don't have any strong preference one way or the other.

After thinking a bit more, I think root memcg approach by Qu should be
preferred. Using that we will avoid this unnecessary code churn for NULL
memcg checks and I am pretty sure I might have missed some places I
listed above.

