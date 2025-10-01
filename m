Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F9C1CCA474
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 15:37:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C26598E0006; Wed,  1 Oct 2025 11:37:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFE158E0002; Wed,  1 Oct 2025 11:37:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3AF68E0006; Wed,  1 Oct 2025 11:37:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A4B938E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 11:37:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 18D01160167
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 15:37:23 +0000 (UTC)
X-FDA: 83949949566.04.8D450ED
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf14.hostedemail.com (Postfix) with ESMTP id 21F3F10000F
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 15:37:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CkX1ydXZ;
	spf=pass (imf14.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759333041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HOhlFtoBnWaiM64nftJX9Q0scL17iSbfh4QHyZLgLlk=;
	b=Ir/zlSs0y2mT7fqLCgQ2Xso/78J7RcYVLX7ojZuU7GIr18Cj7g3Cbbdq6VwNB+4ljYFojB
	AfWPcQgO4w52Q9G4su1bTB//CVf8cBDPgmEM8KlorRUCv4EJelt3nrsp994Q1ngwQ3va6R
	jvHdlFoyh/WMJfZ+1x4DIaPI1eAqmDY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759333041; a=rsa-sha256;
	cv=none;
	b=ruiwWEFMeKEu/6Mag9BVaVVm0BQlzaijwEprV6gGYgEVU0P5oRLGn7yesMUstcVEkzPRcW
	/HFNhSx46fmLnSejgzTv06K82Y9KmptBTDZvUr/7FYaucqR8HKe8hpKUKrenvnRaPYtcDI
	yuY2O/NNMFctm3JtbxPrT9NHHTzrwHA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CkX1ydXZ;
	spf=pass (imf14.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-71d603b674aso146517b3.1
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 08:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759333040; x=1759937840; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HOhlFtoBnWaiM64nftJX9Q0scL17iSbfh4QHyZLgLlk=;
        b=CkX1ydXZxl+2Kr0U0sEkXbvg7NluwTq6ZJ2UoO67GIyQXaAJxT46rZtPy7ZIiENLgJ
         1gfL1bTuFbXKR9OrntAmPrcAciJAU/XZO4syrTyA2ztry8ns1UsHAuvM9KdmnawMlLd8
         PbW+CBnlQ4SGmGBthAanKqusspo2kjWYUWryBpMR4xpy/sZHuBAONTWbm/2IFebM9dIc
         u/I3N2LjWIUiSWsO8Lti4M5FWSB8zm/tlL4gJ3XS6npsoa7bq+0/SzBowoFSkY8HurOk
         XNrGKcXYlArqS90aC+gLNQLyOiTGgqK5tfdnG6Q+g6YgTqaxBFwRBzkLxju/VwmQjQeT
         JFZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759333040; x=1759937840;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HOhlFtoBnWaiM64nftJX9Q0scL17iSbfh4QHyZLgLlk=;
        b=Odl0BGLebJg9UDV321c0JEmyPL7QF6ngASoXbTU7o7UNOaind//NED78E/H1mk+BHv
         AngpPMbdXQtbZyp+UZ5F3RdfBNTZlO9zY/ivs1vGRn0shZacayrq9twEbcAojUDKJfXw
         V4RK5gnK2UYMIykQJ64SK990LLJQBOPkrxCJR/dhOj6lu7mRwKw/zTmWQhzYXKHTI4Le
         HHKTbD6QkYLQoHxbpNnLH/uplk/4gcYvin3qZcUo9StylAiK/rOWg8F0nu12yZRLNWJk
         juqAvZfdoFR4gG895UMcuEUyBAibvsu8kKlyH7AlrhATaUBNIt7nzmuyVLUBMMpRdJU2
         wtnQ==
X-Forwarded-Encrypted: i=1; AJvYcCXjUICxjf8ge53707c6SIdk5lW31ZtSuSiavh+VAARSQN3shxbVp+zW/ceLA8fC4If7UHUNZhSeVw==@kvack.org
X-Gm-Message-State: AOJu0YwvHXJ9GJOO8IqoZiCjRBz9RHElc3o5LJsl6pWVN1gK9snOA1bm
	hBt/TbJH3DCuzPiddc0CxMzY9e6XeIBFsPfP57RN+NH6HIgIv62YcPZC
X-Gm-Gg: ASbGnctZw6WEFtuQojwPrdiVrL4bvmqWf6M6NKbiRcHFRrS/+K6YYdGFgiAS3V1C+zw
	fnJ8JM/d6OaSEdqm0rsLZpoYYCD6AXjvBYTc4nXhxpharwYtzg7XaFoNZZqzp074sbVLln1/pxC
	j54EDQsWOdgLcyW9w/4pcZzTI7WmUxTyxCLEZOUyi7nvb3A8SaalWVezCqFFtELbWetlgOvWxqR
	Bcci0esRsK11di6rjwaf7otIERKKtTVkkW+oCC6Y2iaHMeXzlCUpK1Kl+U8I1+q9CIGo8b/f6aZ
	TXDqEevh/5wnl6JYEVE9/xE+ILXS0wHsOJ8G+qLHdlhzyxv6jrz1rdYIzFYBkGWJW25trTeFtff
	a3HlKiEf6YjMCM7Wdh9UpuHXXMRogGt4+qSn/IN91VXSQai4+KLL4OF5X1NN8hUk3dM0wnSfic2
	vC78oEAC10dW4=
X-Google-Smtp-Source: AGHT+IHKVJROpyMqw1QoZWrF7csKcCEketgdJMlIcKVy36nzcnmwP5FDc0ogNg5Bq4RBgd59dy6v4Q==
X-Received: by 2002:a05:690c:39a:b0:76b:cd91:e7c8 with SMTP id 00721157ae682-77f6f317c86mr59080407b3.25.1759333039546;
        Wed, 01 Oct 2025 08:37:19 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:8::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-77f67cb2a92sm12615607b3.46.2025.10.01.08.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 08:37:19 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Hillf Danton <hdanton@sina.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/4] mm/page_alloc: Perform appropriate batching in drain_pages_zone
Date: Wed,  1 Oct 2025 08:37:16 -0700
Message-ID: <20251001153717.2379348-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250930221441.7748-1-hdanton@sina.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 21F3F10000F
X-Stat-Signature: 1zjnj471es1jp4dkcsb7m4ob9fsz1s5n
X-Rspam-User: 
X-HE-Tag: 1759333040-683255
X-HE-Meta: U2FsdGVkX1+pyC7WKX7IhwpyisQH3zJXgRJNidw2TrHF+yCSxeexBL7XlP/34OTG7ehYSVp+nz1svs9IcmhrHQxfPv2sfz0lWi0wAlZTL4tHRbMbH7QcYMG+EvJ4edlhZfmbTWM3wIzXjkqsTdcvPhL9fGZjLRU2/UW1Wx9v6SVsBYufEpch/4xKD7wE6dtOpvXpV7tcNdvAX8uGpcy8TDSt+7jWZG02JPkKps2zYikJO22l6sdClusO4MVPZVYWaUrxmTgQDQQnOxGgImrp4e9A8xbzMygpHBsClBvxFlYBsR/Hz8WAPfiSyhYeUnmGQAbAks5fHHxjvj45c96b9y55JNaXEeV9WIdjoXiHE4uDnxwIGGBYweebahajW/Xrf8Ym1Fzu474ALElUAuszyFaaqmCH6K0vm4pgiQNz1KR7nHY30Vlne2I9f2owGwdN8bCMi9Fb3PsDld3mSD6IWoe2sjhHsVRxaIM/2eQDNZ1xFEFgz1W3L9u3lR9RomR3eEgodpAEIs+PKtibwGCyhMBoooqv5yWaAY5ijqxpjNzRw4NzL9CI6vdCa0UGClFo7EYaiZ2xbxPqaILyWhgou8oUxvvH0UD+zN5bDXRpjA+jld0KK67xZKkZEZYzmN5gss04w6z1/MSamZ7G1weefEvwK4sIOlPPex9CyxvM+CXa4UOBuvm/DFJEjMwCRr58Ol374est6M+B0bjBjM8Sp+oqozIPqKf+jymqUTIWmZCvWQNa704Cl8miiaJPP/DTCq7KNaQVNYJjY7g2D0P3xhbd54Hmj1RDS9JjEIhx8GzfMRvKcUgF0cCr3NCertKjXdWFRiLRFxJWMUgSeIdRmfYqrSMK5KKHHeOdZcyS2DbMpGA28xpAR6OjeCplzvPVnv7EpKrirQM71NqMG4F08ex/P95wiWJHcUoHL4V034+w7SCuBrmX9QaiXMq5xP0QjqZy7aim+IHRePZx2aA
 ///kUjEb
 Xgyq8SlRSPdkFfV2VD3hobhZXNPPdmbbMiXb4j3nlolca2s4PPEzBnfnS7YHSFNqwiC8WKrbptYc0rwO32aAHLBqc2t4m/wLKUV7etbuljM97haOAT+SuPUZoWI8uk8yFs1BYcDFUZiJDzyfFZcBgB7QGDayWk/i7NfE1moOYbWNzsswqVBhzQowEN65mxzge7uz1nCf4CpwoSAItYw5A2zBJI/M9jb4mrbRZfILb4R/fkA695QT8GJ0J0D8zuZ7Pb9n/ZBi70KAXMjADGYI89FEXA267B1qUVZvgPJ0aAOdbyM8EkvdX90aQQS+a/aEMaH2t4jEKrYQy1GKMyHHdZedgcfPwkVGjCgUThf+sosp8mSXJZnAI9Zw9lK4JHJus0JDDgvcUtthcHkvKZAgz4+QPA2w8eM2g4jS+AdrztpFKcg4YhJVEyjb2oBfggTfUMNvwGFqv6PzwadiHGsPrRIm7SUtSsizabtUIhPN3ERHcOZS43PWLLlX1UkwzwtDxNbpHkoibVFcKmhd7zdpyghoWOZaXLVhQp3uY6SPiJHEuO6/amVMLjCR0lQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Hillf, thanks for your continued interest in this series!

> > Hello Hillf,
> > 
> > Thank you for your feedback!
> > 
> > > Feel free to make it clear, which lock is contended, pcp->lock or
> > > zone->lock, or both, to help understand the starvation.
> > 
> > Sorry for the late reply. I took some time to run some more tests and
> > gather numbers so that I could give an accurate representation of what
> > I was seeing in these systems.
> > 
> > So running perf lock con -abl on my system and compiling the kernel,
> > I see that the biggest lock contentions come from free_pcppages_bulk
> > and __rmqueue_pcplist on the upstream kernel (ignoring lock contentions
> > on lruvec, which is actually the biggest offender on these systems.
> > This will hopefully be addressed some time in the future as well).
> > 
> > Looking deeper into where they are waiting on the lock, I found that they
> > are both waiting for the zone->lock (not the pcp lock, even for
> 
> One of the hottest locks again plays its role.

Indeed...

> > __rmqueue_pcplist). I'll add this detail into v3, so that it is more
> > clear for the user. I'll also emphasize why we still need to break the
> > pcp lock, since this was something that wasn't immediately obvious to me.
> > 
> > > If the zone lock is hot, why did numa node fail to mitigate the contension,
> > > given workloads tested with high sustained memory pressure on large machines
> > > in the Meta fleet (1Tb memory, 316 CPUs)?
> > 
> > This is a good question. On this system, I've configured the machine to only
> > use 1 node/zone, so there is no ability to migrate the contention. Perhaps
> 
> Thanks, we know why the zone lock is hot - 300+ CPUs potentially contended a lock.
> The single node/zone config may explain why no similar reports of large
> systems (1Tb memory, 316 CPUs) emerged a couple of years back, given
> NUMA machine is not anything new on the market.
> 
> > another approach to this problem would be to encourage the user to
> > configure the system such that each NUMA node does not exceed N GB of memory?
> > 
> > But if so -- how many GB/node is too much? It seems like there would be
> > some sweet spot where the overhead required to maintain many nodes
> > cancels out with the benefits one would get from splitting the system into
> > multiple nodes. What do you think? Personally, I think that this patchset
> > (not this patch, since it will be dropped in v3) still provides value in
> > the form of preventing lock monopolies in the zone lock even in a system
> > where memory is spread out across more nodes.
> > 
> > > Can the contension be observed with tight memory pressure but not highly tight? 
> > > If not, it is due to misconfigure in the user space, no?
> > 
> > I'm not sure I entirely follow what you mean here, but are you asking
> > whether this is a userspace issue for running a workload that isn't
> > properly sized for the system? Perhaps that could be the case, but I think
> 
> This is not complicated. Take another look at the system from another
> POV - what is your comment if running the same workload on the same
> system but with RAM cut down to 1Gb? If roughly it is fully loaded for a
> dentist to serve two patients well a day, getting the professional over
> loaded makes no sense I think.
> 
> In short, given the zone lock is hot in nature, soft lockup with reproducer
> hints misconfig.

While I definitely agree that spreading out 1TB across multiple NUMA nodes
is an option that should be considered, I am unsure if it makes sense to
dismiss this issue as simply a misconfiguration problem.

The reality is that these machines do exist, and we see zone lock contention
on these machines. You can also see that I ran performance evaluation tests
on relatively smaller machines (250G) and saw some performance gains.

The other point that I wanted to mention is that simply adding more NUMA
nodes is not always strictly beneficial; it changes how the scheduler
has to work, workloads would require more numa-aware tuning, etc.

Thanks for your feedback, Hillf. I hope you have a great day!
Joshua

