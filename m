Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97C4CCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 18:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB67F6B00B1; Wed,  3 Jun 2026 14:26:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E410F6B00B7; Wed,  3 Jun 2026 14:26:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7CE16B00B9; Wed,  3 Jun 2026 14:26:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C0D5F6B00B1
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 14:26:18 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 35671C1DEA
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:26:18 +0000 (UTC)
X-FDA: 84839431236.14.F2AC2A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6540E20007
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:26:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lweSA3OH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780511176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aj9xa8st7Hvx+2LGq6rt+CADlrLWll6a6d3QhFDJBzY=;
	b=meIRkOGP0ut3B8SJOQ877c2st9cDGq/5ffpXjsTJYi06AfZ8LM35osCacuKDTCeScH4pI8
	rFuGIQysM2L1Hu89K9eoM1DDrCejabxpgYR+FmJtejHQyQi6wQLejEH6VUfni+i2IYe8yU
	+9a/JOXV372eQRzdWBnrqtOICRa/W9g=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lweSA3OH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780511176;
	b=BTvcThFPchgJmMFvIgsuw9BzYqqMc8Lpi+SBEXhwuCy91uOzCe9vF99mD72U2O9YO2fo27
	2xOt4egIc1EBF5t04JludO7AQJoq7wEkoCgBi/SVRQjEzuF6FwLt9cng/U1wlEYFvtA6Cr
	rTVL2WnMCgVu7oQTgu3PDX+NWtHtxPk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D974C601F4
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCCE1F0089E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780511175;
	bh=aj9xa8st7Hvx+2LGq6rt+CADlrLWll6a6d3QhFDJBzY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=lweSA3OHcLDrQaav9lc6Wir64ubnglJerfByUmJE1p/Qu69+5AJT/2hrWKyHRtiIF
	 lMqxEfWzMxVu66n+z1AAurmnA7ZYRPIA0T+B2+5gupdwOosKscsY8OB1sqAIxDvGiS
	 PaaL4y9VAuVcz61GkMVMkSwDQOtJl2b/ksEKhe4NW1CxHbR6diEaiZ/OAeS60z2qqh
	 cRNOVUobhK+jt+uE+7MYWgzJFAaYRYE1uHJoe96cSXXUnLTTVvgcB96q5MiEr3ks+O
	 vj737IcIsmdD4cvOTQrupb2OMIcxPuW05kY+NRpARBBKdK15pTjVLdwTtr9n6WRrtk
	 dvcOoffxM0CPw==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-beb7f26ed62so508256366b.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 11:26:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/EcQ/pMdhH+WX38LEtyL1DIvvmqeJOZ7QmoH9kTcqNjXrzgXu6XRdjj1TEaBsFehmbBPFB77Qm4A==@kvack.org
X-Gm-Message-State: AOJu0Yx7WS2z86c6FvJ3MQRDwm6mldIblFlKozhRcCiyPjilCEH2ON4T
	uYxQFXSM38AAXxbd1znf2S7JDelEdRC8XCmGOvwHFaBEtxUiQIpjVvbiQbzrq02G5WQx+rVFPyy
	hip+fwLpIVHTtdKZnW7npCROYufiznjI=
X-Received: by 2002:a17:906:5a5c:b0:bee:215e:5486 with SMTP id
 a640c23a62f3a-bf0b3aaceacmr174660666b.36.1780511174539; Wed, 03 Jun 2026
 11:26:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-3-jiahao.kernel@gmail.com> <aho-Z6wshceTAYd9@google.com>
 <ea2c1323-1440-e927-f14a-0eac54a245bf@gmail.com> <CAKEwX=PoBZ4ci30tKHQXs1o9=NDpPrtbe7RxxZTbnzVJf74ZYQ@mail.gmail.com>
In-Reply-To: <CAKEwX=PoBZ4ci30tKHQXs1o9=NDpPrtbe7RxxZTbnzVJf74ZYQ@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 3 Jun 2026 11:26:03 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMBUMXy_bkeT8z+M=dXayU=6VGEw+-HmfDWR2fyJy=z+A@mail.gmail.com>
X-Gm-Features: AVHnY4J4j3oM4dD13IqQZCy-bYs_O4SfhMK6I0X3Uvdscn_9ZGq_oohrA-pnMhM
Message-ID: <CAO9r8zMBUMXy_bkeT8z+M=dXayU=6VGEw+-HmfDWR2fyJy=z+A@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
To: Nhat Pham <nphamcs@gmail.com>
Cc: Hao Jia <jiahao.kernel@gmail.com>, akpm@linux-foundation.org, tj@kernel.org, 
	hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: pg9p93niaj41rkkry3zhzx9phksuzqxb
X-Rspamd-Queue-Id: 6540E20007
X-HE-Tag: 1780511176-814210
X-HE-Meta: U2FsdGVkX18Vm03RlmaGA3r1eW4RHVC8ekA0Z9KeqDW8nIkyh3ddMRwJF+1i8RJ69NA6kIUFqzWs0TgNJq5GAW2sGj3L5fbMvD8st9+y68BU385bcDMtF3iO0pLAyKOnhNZgj/gLkTIQKPD/ELKrzQ7wRoVlVZQJufa10s/2ekEVxs1Ggp+Opix6rKPmIrUeJk0pJMdhHvH48rmzcc4Ks/NMrdkb+Mz+OGewtwpVyvccP+TMNmU/LtDnWiV8pS8FI+OUw4rNqFRRrWwfSCJshVJ65GVh3L3UhbxFvxVa3qeZGe5dYowc8vzODyWfFW2jlr2DUAoUNBbqXtBnB/3mjCyp2R0YLxgHiB4SNpqxftQtogs9ME7j+GpSQfppIM/cj/XDUqT9tz3B133XW4oaI9wRx8h4svuPPMs04NtNIK82lzd+Lx6YV/ayLJ3QdRQXB6bF9l7oOg78QDDOt93el2xIMD1Z5frGDcIkdDEe15CzEtwOGVwnLvpI2cndcXhIeB3pGi8uNYGeV3MXwOW4niFgUDns7vnw3NOdaAKiUJjDJNZVTjvg31WbxsKMmPeQzd0zGgR4sa6pCSSu0eT07iE+tetosz76QoT58pkJElASfbNenpCBXVzTZ0iEUzJTUYmIVoVhXlDPwIQPJPlnP1fQCOvdS/mRkDrwd2331Rm1j+BI3zrGTaZVjQdKpK3oA889dXBVRKMYNA/xHdMj+Jg0nmtaSI2U53L+NQPyO/KgjfMXxbZZaAI/Rbouis0/3g3KrWlPnVJoHPAKVL4eX3cbYBQYsuVaDh4QxNGqmWUHtZbUOYXjFF0SMfm2glZBZlEsb+BoFspAY0QNJFrfOpmsTWL9XdCqPZxG+SlO3Mf/iIQK7lWV1QEJv3cShJIPdcIGkK5SaQIo+v8JN0PscCfpemCg8eBWBh5g9FMrUlMvqbj6Ei49d3QKKw8Ag3lbiUMY7Y5oKO9Vn0EkSpb
 0xJhzJQi
 czh3qk1BjptjAarEA8nRZm1oNeLsjqVFdkE3a9krQfoajEO056fmLpgibk4dHC8W+POGwXd4pSuhrubdzkGLBju/OANnHm/xGFCGgkE5nGvDXroNVIEOJOLE3W2FQdnAocNAujsCQwNE8oMwqGuiZKSOeI2frsrX2kW5gRh7ZPUkS6Wt1pVV1fyzcVzuIIXyJOHX4ukWYKi1RzDieywP06jebQpA0QfB32gqWi3JdC+hfgba3th4haLZqfNNV4zUiMaArU+Sjb1g2SnCD8j/5o+9bS4pAGRfSgtVgR5Z02OpIN2LDambjmveZtIB6gCTlR2YiswGvqCzYQUBacs0XKbafK6aiuevfCEkuKL75Do8jZmY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > Is the main difference that we are scanning in batches here? I think we
> > > can have shrink_memcg() do that too. If anything, it might make the
> > > shrinker more efficient. Over-reclaim is ofc a concern, and especially
> > > in the zswap_store() path as the overhead can be noticeable. Maybe we
> > > can parameterize the batch size based on the code path.
> > >
> > > Nhat, what do you think?
> >
> > Nhat, since we now have the referenced-based second chance algorithm,
> > should we consider doing batch writeback for shrink_memcg() as well?
>
> I just take a look at shrink_memcg() and realized it's reclaiming one
> page at a time. Thanks for the reminder - I hated it.
>
> Please batchify it if it makes your life easier :) We don't reclaim
> "just one page/object" anywhere else in the reclaim path, Sure, it
> adds a bit of latency to zswap_store() if we reached cgroup limit, but
> IMHO if we hit zswap.max limit at zswap_store() time, that is already
> the slowest of slow path that you should have avoided with proactive
> reclaim/zswap shrinker in the first place. And, setting zswap.max does
> not make sense to me in the first place (I can write a whole essay
> about it).

Should we batchify shrink_memcg() from the shrinker and background
writeback, but leave the synchronous zswap_store() path to reclaim one
page for this series at least to avoid potential regressions?

I think this change specifically needs more intensive testing (vs the
other code paths).

