Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AF4ECA5FE6
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 18:14:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A75046B008C; Sun,  4 Oct 2026 14:14:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4D016B0093; Sun,  4 Oct 2026 14:14:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93CBF6B0095; Sun,  4 Oct 2026 14:14:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 661176B008C
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 14:14:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EBD18160B89
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 18:14:11 +0000 (UTC)
X-FDA: 85285743102.03.E5F8E53
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id C170040002
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 18:14:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lpUjzdOQ;
	spf=pass (imf04.hostedemail.com: domain of her0gyugyu@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791137649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zvp184+VDrAAELa45MrIVjzHZuD6h0h7teUaAj2z138=;
	b=lsjegA4NKe+UrzdxkS4XFLc3thGMpqce+GJg2AkiSKobRZxNVfMj2t8H8Ewws64Nr+Qjei
	x2n1lYHtgiv1Ci/wrG6IlEy09YiLEwsc+21Hd6l8Akbtt9fQpqGCyevmfYFX+agsUsnX97
	jJkkVnC5hZDYsxC+xTHU25RWAUZDb9E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791137649;
	b=sM5LctzLyTAKfWe9aFXKzocamWPChoOS26FFnaGu0QmVmzcviV524MStWgbPI9/fDAkvR5
	lMz0lP65GtfJhckiN/XO8vvu3JD3J//7GHRIyE1mu9ztWASkz5+6zrTWTUfR2abEcIEO7O
	44z6vi74neRQ7J6YSNCp7Drp9q+riJs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lpUjzdOQ;
	spf=pass (imf04.hostedemail.com: domain of her0gyugyu@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-39b2ad83dc6so641398a91.0
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 11:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791137648; x=1791742448; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zvp184+VDrAAELa45MrIVjzHZuD6h0h7teUaAj2z138=;
        b=lpUjzdOQc+RQD37P7icaIfzVU7fcUIlaF8Vqn7ovlYSCXV7K2d/GAa8pvRlSd2HZTH
         0fcjGj/eFMeAX34W+1+dIexXc4qiKzWh4vOWsmrC4Jzo/qg3NUYGSNFeW4btqyXUXvD0
         us8FZNJDZZFvV6dwiT0S0TufXEpIJRZAs/57aZ++AQcaapT/5xhY4mOkfxVHseNd7adp
         wwznx3FxYokIAn6OWABbqya/+VeV0nNZVGlVBMf9QBfTQ/9YhAofmnu3SZJUJHwlBwHF
         2X0Wp5TBocx8Y2vY1+Kx8aBZ2bSGdUAI8FGnkxTpq0bLzVni9MbS8Fv4hU06o+J8WUhT
         8XrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791137648; x=1791742448;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zvp184+VDrAAELa45MrIVjzHZuD6h0h7teUaAj2z138=;
        b=j/5iI25hjkISfbl1NATPrd9033eLljUQXwt+3ppb8NvFJB2rdZcewDc31yypvkZ8cA
         sVc9DxVuUNYBcgPPNWdfnex2rOKnpEWhhWcwjLsMh/yi6GfsSJ+dz+zdTFqubnRygRjr
         ydvr96d/bzYYD89rglL/MfBAtn568syJTZIXsjgSygqBPi7AJz59RZMol+iwES0qVKaM
         u9fh3TDtL6fwvJa82Mz4csI5+0epgWo25o3BTgD29WbHgB5du8B/f68uilpx4BZDFv2E
         Ie5r/6yOuuMLpEVLkfYXsDpc+9jWzP55EnimgYjGVzzV815tv1Yf7y4EMwErCXNUTkN2
         lUEA==
X-Forwarded-Encrypted: i=1; AKwUvBx/M+XXJu+iPEzQ1PRW6mtvSHyd45HpvRNpisq/6PKYFS0AIsWZ7y7mCgtE97VW91fmJhINOWRf2g==@kvack.org
X-Gm-Message-State: AFq9FYJlalbk0bfxbNvtQ5OR/9RAfU62+njk/kjeRecz5MaREwUSAF/0
	BbeIR8e//r7hjIv/PYv6HCprTLZ/AlhEjfnST1a4m3DGNaURLfNp1GF5
X-Gm-Gg: AYBFou0OTx57Oo8gz9DxM9b4dcuvMD0VzSoJetUyDO+cDnRH83iXLcks6JD5oC6zwBT
	LG6FsJWs3KQrur7CBj9uYLxTxBuHqcOUZPe3TC4EOOBLBcAUBwNU8l3Q3Oe8/5eJke1PkvtamBF
	A+0gIDMC3Pndw7Xe0orRmFP/HpyciLaUjjieLlVQ1tYnxxuLdSxOcjot1+MaBhQR1O8kBkt6hFI
	dHF2n67eXU+urf9BZaxib6W7xA/YEG5v4C3gbR6p7J6yPjN6W1z2lqzgQY/yKYaSZswLAao/hCN
	c5BT2Dwy6acB6gR21YUCPr7wSsPVnXTrmSZva27Bhq/M8Rcb5RYQujQdn2o3gHs5YcBzCR9fhyE
	f99xWSyng5MP64zrp7uu5L4jtsyU1j+3DSckxH7BWjzGAcCcCRe+2XpXJQPWLjU7pfGablgY5t6
	SY/UrK3mox66lS39gWvVY8vixMfwSsKQno8Hsv00NSe4z7P9UmxNc0ELjlMh8c76gS5yFJLWxmG
	9RTz8C3GA++nIsqNi/tLB9QN2CKGw0yOTw+MELq4Q==
X-Received: by 2002:a17:90b:4ac3:b0:3a0:a781:2c39 with SMTP id 98e67ed59e1d1-3a6ce3a978dmr7662178a91.7.1791137648512;
        Sun, 04 Oct 2026 11:14:08 -0700 (PDT)
Received: from gmail.com ([220.85.166.190])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a78d59f1cdsm7460304a91.0.2026.10.04.11.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 11:14:06 -0700 (PDT)
Date: Mon, 5 Oct 2026 03:13:58 +0900
From: Youngjun Park <her0gyugyu@gmail.com>
To: Matthias Goergens <matthias.goergens@gmail.com>
Cc: Kairui Song <ryncsn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry@kernel.org>,
	Barry Song <baohua@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-api@vger.kernel.org, Alejandro Colomar <alx@kernel.org>,
	linux-man@vger.kernel.org, Karel Zak <kzak@redhat.com>,
	util-linux@vger.kernel.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, linux-pm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [RFC PATCH v2 0/4] mm/swap: reserve swap areas for deliberate
 offload
Message-ID: <asKXZv5SxBtxQxqf@gmail.com>
References: <20260926045517.3458413-1-matthias.goergens@gmail.com>
 <CAMgjq7B7jem_dwtUEX7ZJPQm_pKBegR6WS9+B7nFp-gZugpUng@mail.gmail.com>
 <20260928151944.2686626-1-matthias.goergens@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928151944.2686626-1-matthias.goergens@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C170040002
X-Stat-Signature: 1nkkdju7ck5d3tbh6eizmceujrcd5r9u
X-Rspam-User: 
X-HE-Tag: 1791137649-924240
X-HE-Meta: U2FsdGVkX1/EhobzaOIs6hIAVI9YQ1XS4tWiGg7pt4PTo/Bo3q5goHwf09H6pItMFfsdggmBtyw9bjhOrC9LGL8AY7MQT0Vr1L23eNYlCYHVPy8X9wh8LnnWmpWSUi4ULCQfklG8bR+XJoKXiDw4HNRCC4kzOLdkaWgawduHyvx5863fohtLrjLxnsJWhbaCwQBvZKiKayptbbdZMvpKIuKaJ2jBBbGjYIgrIQ7IQce2Ef0UrNRha32bM9bojY3wwQ5u7bTWi2lI3VILZykUZIgJBf7CWjEULQfYd1IGAfiUxCnJ5T3zILfbU/w3++xRRiJ4YD8j1Aegoflx1pDmtwcT9b77L+e2QNzRVvpHlstIM7NlmEQcgu+aMyACqxt0qdUwmoio1IaRwuuAz9XXc6JHXNlCkF+dYtPlKYP9DDDAfvR6V6FYcXqEKPsFnxKtojmLSXQT+sSm4GwhiuRPz0UR0DI0wW5ZVm0w7J5H5EVKEp9vBRrLuSDmr270K5s0zk2ZciT9ZECLiqr8mBEfISb6QdJDyIXg7A2iI6hEo9yPN8BLDzDi+pQ3OBsX7U1h8uAzVQsr0rrjLNZY+RqO4Os9UKfZ4jaDIVczlbC/HHYF4YpBh9XpJVhpFyxfDcwK0BBSVYt6xSns5H+x/ph3KCEX3llbZ8pdCFI36pbi2ih66dS32buDAB/5KWQdX2qUAvrmWSIvPL2alt0hJIseo7oLgxzQnctcvks5myQ1KzmDUEOcgenfmFT8ZgQCgLA5I7/oIIE7mL560G8oV7AR5TznoUwur3ME73mFqPlhITFzfLJhbfgBITGnsmexX+ZPRV/mjF9N69RwRHpIyKcvL2lwb2kS1QW4wZoUaZTPmMGZq8dCTSSaCcH1oT/q7MdMP47AKAI1M2YP+cPauKmUuH9VEsTi5U7lsLw0kuljZRWpZStBnx4AzmnYdLnATeMMe+ci01TaCOpH7PJCByM
 iSFXB/nF
 CyI+8jLiM5+7DQRM4oNT8MCMIxF+11U49XYJJQ+IZCM2/P1qjYOqm+Vcrwr128ppVov87KmOCh9V7/LL0nKIymzQTIDxs91rdGz3c6xOziWAObKB0gPO95QAV7ItlzKAOWn2Gn/f2h0l6+VKaVLeAbiru8btF/vT+ozrJ0bXUqD409RZytBN8kF+n+RI++1saFM8/xPJFBRvzzLuXxzrXkTvl1VLoVueWz2zgzIQRsWkWJdxZZYiWEzXeVj0EP+T3k/elikfNatk4wSvwKsUNu1f7zwsOFhOBC8nyxcj/y62o2lTkYzRrcg7EMwP36g6TPzzRjqFJJCuiBu93Mg9bExCa9rdwF/ac1ujn4PQS1sFekxG9BwxnrcMMRwzZRV5uxRZwRNKOzvjf9TwPB64O1zgX6WGZ4YWeoKo9BeBeHjeOMBd/ji/oaelQlQqUjz8+LvmQ9vdjqelktRVVUdksRCe/xQI3bKYG6NXzEVZCM+Xg0ewbyJWuWhWdVeorqOuDvfIEjl/Ev/0rUvrQT9AmnIqKZophHey/DHl2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-28 23:19, Matthias Goergens wrote:

Hi Matthias !

> > Just like we already have a "swappiness=" parameter in the reclaim
> > interface, perhaps adding a "swap.tier=" would be better and much
> > cleaner to achieve the same goal? Based on Youngjun's work here:
> > https://lore.kernel.org/all/20260916183437.2946306-1-youngjun.park@lge.com/
>
> Thanks, I think that's the right base.  I tried it: on top of
> Youngjun's v11, a "swap.tier=" argument to memory.reclaim is about 40
> lines.  In a VM with zram at a higher priority than a disk swap
> device, and a cgroup whose tier mask allowed only the disk, ordinary
> reclaim in that cgroup stayed on the disk, while memory.reclaim with
> "swap.tier=" pointing at zram went to zram only.

There is an earlier attempt that may be worth a look.
https://lore.kernel.org/all/20260618044857.69439-1-jiahao.kernel@gmail.com/

If you go this way, the discussion in that thread worth refering too.

> What it doesn't cover yet is reclaim outside any configured cgroup:
> under global pressure, a cgroup nobody configured still reached the

Right, so for now every cgroup has to be set to exclude zram, unless
another idea or more code covers it.

> zram tier.  So for v3 I'd like to add a system-wide limit on which
> tiers pressure reclaim may use, on top of the per-cgroup settings.
> I'll wait for Youngjun's v12 and build on that.

I have looked through the whole series, and I will keep this use case
in mind while working on v12. :)

Also, to share what I had in mind, I was planning a sysfs interface
for each swap tier, /sys/kernel/mm/swap/tiers/<tier name> (exact
naming TBD). Maybe the system-wide limit could be handled there as one
of its use cases?

Let's discuss it in more detail after v12.

Thanks,
Youngjun

