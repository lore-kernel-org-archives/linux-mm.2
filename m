Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D738ECD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 17:51:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1505C6B009F; Tue, 26 May 2026 13:51:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1288D6B00A0; Tue, 26 May 2026 13:51:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03D426B00A1; Tue, 26 May 2026 13:51:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E44586B009F
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:51:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AB48EA041F
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:51:48 +0000 (UTC)
X-FDA: 84810313896.15.36FAE42
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf07.hostedemail.com (Postfix) with ESMTP id 83F634000E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:51:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ew4PODaw;
	spf=pass (imf07.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.47 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779817906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XQ3cng5X0oDMXeSorLg9lB3BC86VI//X2tWXp1ZbvQQ=;
	b=XutkCkSyQjrsqrSeSHae8+hibBQctLUuzyWKl/jPh9VQ0eN0ibXjEdT4+D43eYmUMwEsmL
	uMuYUeNY8dwCfctXqniHXfzzo1DyKuPwH3AxxGkR6Q9cUckKxkq9q7m2K2EzQZAxY2MBuN
	xYG5zS6iLyl+zAVyOzy7UnZggkdXqnY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ew4PODaw;
	spf=pass (imf07.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.47 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779817906; a=rsa-sha256;
	cv=none;
	b=pwlGeAe7kNW6/WO8pV6ApawLbpnlhDbOdqXLf/qr3YrvkB2sYD12nSj2yFNhl/0yk+cKf1
	4Ear//EoqKINniHatgrSnTnsW6omnBvyL0DlYTL6RLhlDVXASDHx8zTqwoIJqFgDJ5HF7k
	QbmRL2ZkdkSgzI8SPAW/j1GP6zY86Fw=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8bb09239328so82332006d6.3
        for <linux-mm@kvack.org>; Tue, 26 May 2026 10:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1779817905; x=1780422705; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XQ3cng5X0oDMXeSorLg9lB3BC86VI//X2tWXp1ZbvQQ=;
        b=ew4PODaw2bm4QAl+mBEn46ohizeEn7x8iOsBfxaG9MlXPDgOGzLXfXIiQrHS0gvzRS
         3IZBoV0gDOMks2o+XNHN8CEkSsxlfMMV88fxDj4pmIaUG629j3f/4jmVP8XlsKjD21N4
         oHdGvmJqXfazA/Fj3GqJPudtKF7t5vT2b9HQuqY/b6EW2yyjd1dt3iilF6Hmq3eCMs3q
         uJfM6plSCZHKjYCoP817397j2bA2jC4m8233LMv+vL2Dthyraso+6sW7Iye4KF2HVON/
         uyizaRs9Tyu9dLhqfXapxSz5+qlSDJtrt66vXGxb20zE7jRGDrcFw3mxRQ8vvFFhzqM9
         HPRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779817905; x=1780422705;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XQ3cng5X0oDMXeSorLg9lB3BC86VI//X2tWXp1ZbvQQ=;
        b=jiTdhYZi6yign8IMntXPSqsEO4eEC6ZyqfmQtJvdkNePwsUERmupZ0BeNmssRPfsJ4
         ApMsuhUKJX3NTM07iWCxR2hGcTJUmNnCH7GajSe+xsSlfGXr0mmpTUnIIVmT+H1/3hot
         iQE5BUgA5Wn8/Fouyk4o6tOk3y1InkzP8jRvtZg0nB5ka+NiM/A3lNJV/RSjyjL++edZ
         3KIgm0pJcJs3L5RKX5jh/JeSE4TgXnNysmSsJTy6E18rfMCe2bDuoRl06i6uCW0pSNR9
         p96p+paxs31bWFpT1ENuECW2PE/b024fT3IDSvnFSh2eGJkasf0dfFJcrc1TEXZFeLK3
         kPOA==
X-Forwarded-Encrypted: i=1; AFNElJ9QJexb+xK8MqhFJC40+oR6pmOc75FrkLnl4EuwsknM5jKfcgWiT4bImyaUjpQMY/HpkJpQK/xqKQ==@kvack.org
X-Gm-Message-State: AOJu0YwrUFKiDwog9eEWBrAfmT4tSQeeVwviFM7r+8DjwzaL8IN43/p1
	4XhIE4VwMn4cA5DDbOGrjXcYWAqyWimVOw0jVSv0t/ZTnL4I2pGxH19NxSy77/hkpNfm/+dX16N
	2B+kT
X-Gm-Gg: Acq92OFXvaf2XbWhI3rhCR3fzXMNnsn9Qz0LaQn2ibyZPS9ysY6LcfXZZWMBuTGbuFm
	4rtdgPUl+b6ev9Q0Pj4TyJ02ikKNEIIjegdKhyjFj+xawx0/rg/ufieT16T/46yfiPOdrI2+2ow
	y91lYi0Qztfx2SNssLlupvLOds0kYjAbz0bMDcjo14X7a1T+5dBUkIb59IzjjEVil/xey+WiDEf
	TnduWVu+Dj0/KWzQPKfy/qt2w7RzbS8U2blxIdUihLeyjWZPnxmfBneCjnt4iBnSyOywSd/vq0E
	A3nT2Xz6nJNPgoi+kOLIkoPYR0DP9Ue4aT8RQc6wEFRgWLNpNGyqmlhpWbCVwp2p3YlYpwaH19I
	0KZutOs1Lfmbhpz8JfJM2gLtak7ktnN3Vyq81wq8xkG1ifp3bt8JmjalT+5B2LQsFHNm0SvGRe2
	iHlOdXwTwoXhlRA9gEPZDhrg==
X-Received: by 2002:a05:6214:4113:b0:8be:3c37:5e6a with SMTP id 6a1803df08f44-8cc7b621af4mr292946046d6.21.1779817905223;
        Tue, 26 May 2026 10:51:45 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cc80dcf895sm165660966d6.1.2026.05.26.10.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 10:51:44 -0700 (PDT)
Date: Tue, 26 May 2026 13:51:40 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm/page_alloc: fix defrag_mode for non-reclaimable
 allocations
Message-ID: <ahXdrP2eNYw1jc0P@cmpxchg.org>
References: <20260520122228.201550-1-d@ilvokhin.com>
 <20260521165910.e7dea6a4e591d66293d2bd47@linux-foundation.org>
 <ahBUoB15hHbIyZMr@shell.ilvokhin.com>
 <2aedfd17-17e6-4dfe-8ae5-c7342ead708b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2aedfd17-17e6-4dfe-8ae5-c7342ead708b@kernel.org>
X-Stat-Signature: hnfnzsty3a53y7takq4q5uqhmgairegp
X-Rspamd-Queue-Id: 83F634000E
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779817906-928877
X-HE-Meta: U2FsdGVkX1++HByuZOO7yQeKjqn91hAQbo/mGXxsRjXVDFjOW0n9ArwFoQBtP686erTnZ+mw6jLztdllL8QgLq3NgN/ywAGfxHPyP2NmqwiAcoT3QSFCeO1IYkINhvIvyD8muYoj6k4PRq/qUk8jouzdZ59J3Lzysd9l1tw8xxbkj3vfTYoI/JcKPRQdbEVzZKPwiIYNHLyfH+N/eb5RVxPXJAALquYlXUrfHXsI/47i9HaroKZIkI3YOHxPIVFHaOZnkAiZ1sWjGf8LVJZKzV2m7N3J+ymz1mdhdkyn3sqHNSH6gX5YT0KWU2y42koUOhYU1x9dKow+dow3MyRg1gBAMHsZYPeNkLazQ55APNgPtVvdqlCX6Ng9PjH8LMQ+2907GXFMqgHqeIGw5v4lzGXoTbJoNWi4QwwzEql64urPwAZLN2+5SUU0+k9JtUf+oWmWjUv2NTwQZm7gw8bGzRiEhkpOjB0/Ql6wtgpzW1lKNCifY7DYiEXDItIbKehwKQFe0VNRvevNu6sTZjBKHuzvxy/0DuYNa9D+fsdpbAmL/rD3H34ump9FrIIpKhNLD8++qQlhfGgP5tAhCW4wspJzBRewnlvHpuz0ZB8sFh4XDoKuGKRS0QFNshfoISug8BBie9+a0CtLOPW+i1KYmv+txu0JEHjcRnunahYzNWMVmKXXSA6MU+HZYjO/8G11SFg0VgvKvat/YieSIOG9umKJMQUtP21+dwrZRUMMZkCCm7h2CkpCfA/x+G2yHUu4kACq5PCfLOpq1MV9ppvzgf2PVLyVhscmUjV+K+LGmJB9PIrEAjVD2rL2S+Vqf0CdyFCwYRvR63oZkE0b8fF4pRP8QfdQSULD3nXtYZU/0P/88uIqyKn6vSyWpuCNd0ptmQoXH89cXwmnoMWahDneRLQl383FV9ZAQzWz6IgICL0+Pq8suon82G1wYVjn+RGxOxKb5Akdwosb1zro5Sd
 AbZLIfZ0
 GrZlH4aW4uvu/MtB0Xy1mPTUABbsEvJst3fQmHEH2+5/IMhz82d9ZDc6Uyif22fW0lQkYVW8C9jPxKtKuz+9Wt9L94OaDZHwlVtx5mOeMFHVn0NjoVeJnUsBZ328GOxu6YgBCa+Lot7BmbD0GcLfc4PSLWuS2C1dQwO+ubylrNVXf8qi1ZktxbNYVrkAfq8CtqUdGdO42dEumCH9h9maUsjFa09k99MX0wMQcUCWPcYDt1jpNbZor2PiaN7xcVB9xymKzCcMHg4WXZfc+8jvkW0a0q4CLDRk+Z89VWVCg57YUecjw4yTXkdi2hrGOWqFpgdajT3qmxD36aeg3NtQb62OHT1n9qNWXNwhPFlZkAQ2+TXqtsS/Bl4QTCO0NabgNNeZCZHWjN9Mt85NU3kdrlNdpQU5+MTl6M4fnqdDwTi3h8SBfN7SOtBtu2CFgiCbiB5rUv9CYVGufyYRu56sDMGxL49cYggpkG+iBLNRtklTeqFDRWZwlXi0BPGQOnpY3eivnWC6zBcKanrBASAHNbLVEVFMEgpE0h7aPrBne1Ig22NU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 03:13:09PM +0200, Vlastimil Babka (SUSE) wrote:
> On 5/22/26 3:05 PM, Dmitry Ilvokhin wrote:
> > On Thu, May 21, 2026 at 04:59:10PM -0700, Andrew Morton wrote:
> >> On Wed, 20 May 2026 12:22:28 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> >>
> >>> When defrag_mode is enabled, ALLOC_NOFRAGMENT is enforced to prevent
> >>> migratetype fallbacks and keep pageblocks clean. The allocator relies on
> >>> reclaim and compaction to free pages of the correct type before allowing
> >>> fallback as a last resort.
> >>>
> >>> However, non-reclaimable allocations such as GFP_ATOMIC cannot invoke
> >>> direct reclaim or compaction. With defrag_mode=1, these allocations hit
> >>> the !can_direct_reclaim bailout in __alloc_pages_slowpath() with
> >>> ALLOC_NOFRAGMENT still set, and fail without ever attempting a fallback.
> >>>
> >>> This causes a large number of SLUB allocation failures for
> >>> skbuff_head_cache under network-heavy workloads, despite free memory
> >>> being available in other migratetype freelists.
> >>
> >> That sounds painful.
> >>
> >>> Clear ALLOC_NOFRAGMENT and retry for allocations that request kswapd
> >>> reclaim but cannot do direct reclaim themselves (GFP_ATOMIC).  Purely
> >>> speculative allocations like GFP_TRANSHUGE_LIGHT that don't set
> >>> __GFP_KSWAPD_RECLAIM are left to fail, since they have reasonable
> >>> fallbacks and should not cause fragmentation.
> >>
> >> How serious is this to our users when running real-world workloads?
> > 
> > We observed it on a few of the Meta workloads that adopted
> > defrag_mode=1.
> 
> Do you (or Johannes) have some observations to share about what
> motivated those to adopt it, what kind of workloads benefit and how?

As you may remember it was developed to help with higher order / THP
success rates under pressure.

The impetus for actually deploying it was that we saw issues with
avalanches of large page cache folios vacuuming up the higher-order
chunks; this (ironically) also led to failures on the network side.

It's kind of a structural problem. We have real preproduction buffers
for order-0 pages through the watermarks. But for higher orders we
only ensure there is at least one page. That easily fails under even
mild competition.

Since we wanted to roll defrag_mode for THP in multi-tenant systems
anyway, we figured we might as well take the plunge now and battle
test the feature this way.

defrag_mode fixes *that* issue, by preproducing watermark buffers in
contiguous pageblocks - making everything up to that order more
readily available. I'm still hoping to make it the default eventually,
which was the plan with the original huge page allocator series. As we
keep leaning into higher order requests more and more, and especially
grow the non-optional ones, we kind of need non-optional preproduction
guarantees for higher orders as well.

But there are bugs like this one, and we're still figuring out some
overreclaim issues with it in production as well. So I'm glad it's
optional for the time being ;-)

