Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 974EFC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 20:19:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47B116B008A; Fri, 26 Jun 2026 16:19:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 404816B0093; Fri, 26 Jun 2026 16:19:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CCCC6B0098; Fri, 26 Jun 2026 16:19:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F12EA6B008A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:19:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4DCD5120487
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 20:19:00 +0000 (UTC)
X-FDA: 84923177640.14.B9E906D
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id 83168A0008
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 20:18:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pie4VFcb;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782505138;
	b=uvqzD8NL5ZQNJ/fN75lcNBlEMHJo2A6o218IYSSAnxiR5HCkYgRAPeNq2g+NhCSB+x1DgZ
	68yWi/JNd/oFzcQHFNS9l2RFlPuVK18WFf/fv7CMFZ4Vlj+x7+24DrSZOMOw0TvGyXf1/t
	0rPMQs9RbaD9OlpFMOQoFOyoKxTC1ZI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782505138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RGjlyDYhehErqYiWQ+JPN847GkKF9E5lFSL9mEIK8Uc=;
	b=TskYhwfk6LPI6qNzD6Resh4L5VoZ+SZXCZGriZNHsxMoGVIO/WwOY9ktnz0Zyeld4pa0Y9
	sDZzdZzT2JzbbLG03jmLhP4oL8AZxSurswBSDfxcyxIDJDXHzdElKEs3k9yx9ary21AcXq
	Z4DtkN8qCIH553LMxe+0jgXWpYhPXmk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pie4VFcb;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-447d86f63c8so646654fac.1
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 13:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782505137; x=1783109937; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RGjlyDYhehErqYiWQ+JPN847GkKF9E5lFSL9mEIK8Uc=;
        b=pie4VFcb/3UVTDLaZ7u/mfZr5CF7vYkjayn54YLp5r+NgiRXk/smh0nKxP+ptWktLh
         4Mauc9MNLU0tJydtilq1Kep3OBrvRRlGtXA936i3VXn404RaOhwIrY60PGt2Hq1+wfKl
         sUZMcrtz4HjwaVqFt9XpW60p6dpuonRzg+WwmqeDMcJL7Qa1HN0DJSgKXYIvgpzZJoxi
         +cT32JBcqH/HgFpELLx1FFihoqEoUN9X/ZAD00fNmmuxjemIE5FagGkwA2IIxc7ZUIv1
         mBJrI5FyyI02VG7PI22ImJMBYaXa387H+3Bks9iuUpfenxDoVE8uslidKy1Kd29iyhYb
         VfXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782505137; x=1783109937;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RGjlyDYhehErqYiWQ+JPN847GkKF9E5lFSL9mEIK8Uc=;
        b=lEnDH+WrkVawbf2c0Y0nqkdtvd6BB8S9wZPpAGUFK1JYK9blRYfgDn6VBglToTqUaZ
         YQM4elQ5rKpnlXPrLExOUqqNPSjCW5FRtrIhmHRUXdH1/AQu1tjLcovnIeo21174Z37o
         xUBSkXW5tHoJiQjnTvwrp/bRnLB3iFs4+vnqENqr/TYq0s5C3j6c1mdmZvarEMKH80U4
         4wc/PB8N6r1UAbClXdRFgcIDuushhIqYYg+WmTrULb/GHW5F4oHgcOTAd0nZbWqXW8uR
         OpAEyIurYpGQ0oYGIBSw7R9estHgg47HgDvTE4fViHELjLpEolsafRElKuY2kabFYq4B
         Bpug==
X-Forwarded-Encrypted: i=1; AHgh+RoISjeFCvoiYfAZRofWr5NXYObSiaScGhXquoiCzuGqcgaayRY9mdSW9YJLtXZjEda2HWvpXRX+vA==@kvack.org
X-Gm-Message-State: AOJu0Yz+YjFUFfg9LAYr0J/xDr3tvcBUumVNVxF0fPnhtyv+wioV9Yq7
	GxwS7UbieeNxI8/e+4s/6onl8aGQu61/p8ESNQOjafWV9zrRSUBXcfQh
X-Gm-Gg: AfdE7clKpqFciwuL1B0939XaP/FmCGpYsME929RiuMHIdwSmZZ6nblGlwijfeRU/Vpw
	3FfUymJ/+P0umE628v9JMnVfnObG/OAo7PxHoex26lKC9Z18OvwG7i6hwhaNpvAgo11q2DAGpuM
	8p/J87QYhUKTKyA7ensAxsf1BWH02WMNwb8BD/UYblyLPRbfaC9KAsLjNcZug5YAPq1yby5UmrS
	a13gBI+d53jU9gce8NYbRSHJoF701da/tYisD2cZrAdLG++ysU9z5yOP1yCzA7g5FtemCHEG67L
	KO5KILFQvCwtLTXvQ7Ty8kpSm5xlVie71o9UpWcxS4zw31kAp3wjS0mUhuSIf6Mt1xVlZSG34L8
	Y7mO1YWrTZ0LdlgsLfdvLWXaHSl6zidi1hxPcGAVcB8CCsmPRiTYXWG/4b0MgM590VVUYf4HbiH
	PtqTXMxa/AWRNYjunZKLsEL9pHyx28KWB9M+xudOSxEWE=
X-Received: by 2002:a05:6870:c0d0:b0:441:d09:7f6 with SMTP id 586e51a60fabf-448119a0600mr7118160fac.4.1782505137237;
        Fri, 26 Jun 2026 13:18:57 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:55::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4472e79af8fsm14027490fac.0.2026.06.26.13.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 13:18:56 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4 0/5] mm/memcontrol, page_counter: move stock from mem_cgroup to page_counter
Date: Fri, 26 Jun 2026 13:18:54 -0700
Message-ID: <20260626201855.2966118-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260623180124.868655-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 83168A0008
X-Stat-Signature: fxwsg4aabf1zjmur3ayzkjynouwh7xb4
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782505138-841537
X-HE-Meta: U2FsdGVkX18uVk3IUcp4PGNkMTaDkAJoNQ5DVU57OX5nt0jcUno2KOLeVPT9DrPDCIosd90UtT7XPwoG+L3D7RPfUa1R1RfFBaBL++ik8IvOKrV+e1e1e1+McEojqNIvV38JT9m0Qq5FuCsJlCZKaEtts7O0okEo4sWz1t7lzQ24wwtCxQ0DmGgbyaG3w+VvqcQVz9EXolTrprb7MWXqVrDbv4h5AlYJvX8EJ8f37D7ZiKjWaBbpdAtikRmE0DboTBXVagyuBLff/M0uZZeixxA268DwKzy/75VtNxZNInPapGedQGFXTYZxP2MVVp0Vntw8/vDLFjyFutK7PvHgVQ/LIXPyJVXQUxfJajeqBUnXpapnh52oU8F1zOvE7md+IZtHzUs28rCt2RdQRFS1e8U+YtgL8EowEovxsEVzf6innPtD7SBoMfZG/pbuU+ZnepiVlJa/biBT19f+5nZGu5w4Her2zBSMUJzUC2AF9pEee7jdnh5L92T8hBoIPY/SCJeZzzy1xJVWJYSM8IphlklH2FiMOgS/NntfmcwdGA8Af9sDYGwH1Bd2TDLQdVri++RyYzAeWfcbIvnHx/TQy26PSEXZ4AsXXRey/Curf281RwYBN0PmLKBebNZLMPBV3Kl3H2MgH6s1L409KbOxrsitmkdLnTP0jWqo2ulmJ5trYxwJY2UeFxM9kKXlRawN+nu6awc5GN0lveZQxjUBfYDwrLpIJzHBgWO/2euV1MM4h0IfgegpNkYRmuKwv5iSjk3zqqCb/7/IOZ+WXEw/vN+Kvvzjr0p5GE8LvieV0uK/o62oHK3rmYVZ11CJuFFyCJ2smPkg42YPL+7boZ6tqMFqo8mYHacbMGRc96CDzO9k6cB0gFwKW16wyFGvjYtJNMsbzI+bPnhxyseRpva4gGyHQlIwwt6n6l+DO1KqUNykWMIqha/PKRyEXNchLjE2TBClwHeG8FTuQ5GotPA
 adxab8QH
 PV9j2wGrX8XYya4EzC8AZ4TyS++oADKawLwXqigABbPgtqqH9pQO9FEXxJbAEftHZauAsER+V7EC3VSKijGC0TEL8tBQCd+Ol/2zFXUTRJ0d1wTIiq1a5OfZ7w71d/xQAylrR0QeQScTpEnjSWW9BVo5vOxI1vjDvWJCmbvCpx1pyJ+mcT3rCFfKDHfCnrotO/w5RIQDXYM2xoUSpoOu3pdUseJzI/oV594vJpWHLGlOZpB6dIvP4/iMcxZrgpBlmahvBoXUe8Q6rCzF9SJPWI1vRbEBppmURe/OxHupW0Mfq9exga6jA6JoXnvRN9+YqXME47Ap+eTTgLSsecvUnD8BftzpzEHfVitAbZRbs42TihzV1QOjokrpUn9E4ma1M9iP1i+vl2NPTubXmNz6I3jgfN6IsM43A96t/91jfndfSVq9XRDW4HhZi2DLTXaInoxEzrHBhRdsALl0zxDf2AwxFPcc1AfB7QNBv5/M0Lp+QUIyibyNBqMgGBbgWRiHZVUbbSkQsJRfxLlsKa1feOwKGBhuVHr+gMPqfnzWqY2lQvkQLR1w/gPkH0XkgfylFzcaFnLAkcZQhLA8Lr3R7x5TAwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Jun 2026 11:01:18 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> This series is intended for the next release cycle.
> 
> v3 --> v4
> =========
> - Reduced memory footprint by 4x, from 16 bytes per-(cpu x memcg) to
>   4 bytes per-(cpu x memcg). Each page_counter_stock is a thin wrapper
>   around an atomic_t.
> - Removed locking completely and uses atomic operations to use stock.
> - Removed synchronous work_on_cpu. All work is done via remote
>   atomic_xchgs.
> - Added a patch to flatten page_counter charging in try_charge_memcg
> - Split page_counter_try_charge into stocked and non-stocked variants.
> 
> INTRO
> =====
> Memcg currently keeps a "stock" of 64 pages per-cpu to cache pre-charged
> allocations, allowing small and frequent allocations to avoid walking
> the expensive mem_cgroup hierarchy traversal each time. This fastpath
> offers real improvements, but there is room for improvement:
> 
> 1. Currently, each CPU tracks up to 7 (NR_MEMCG_STOCK) mem_cgroups. When
>    more than 7 mem_cgroups have stock present on a single CPU, a random
>    victim is evicted and its associated stock is drained.
> 
> 2. When one cgroup runs out of memory and needs to drain stock across
>    all CPUs it has stock cached in, those CPUs will drain all other
>    memcgs' stock present in that CPU. This leads to inefficient stock
>    caching and cross-memcg interference under memory pressure.
> 
> 3. Stock management is tightly coupled to struct mem_cgroup, which makes
>    it difficult to add a new page_counter to mem_cgroup and have
>    multiple sources of stock management.
> 
> This series moves the per-cpu stock down into page_counter which
> consolidates stock limit checking and page_counter limit checking into
> page_counter_try_charge_stock. This eliminates the 7 memcg-per-cpu slot
> limit, the random cross-memcg stock drains, and slot traversal. We also
> simplify memcontrol code, since we no longer need to maintain separate
> draining functions or manage the asynchronous workqueue.

Hello,

I just want to address a few things that Sashiko raised. I think there
are definitely some improvements that I can make as Sashiko suggested.

In commit 3/5 mm/page_counter: introduce page_counter_try_charge_stock()
Sashiko raises two concerns.

"Can the per-CPU stock grow unboundedly beyond counter->batch pages here?"

I think this is true. I went back to the original stock design and saw
that when the stock is greater than the batch size, it just drains all
of it (since this means we raced). I can add the same check so that we
never grow beyond the batch size. This should also help with the point
below.

"Does moving the per-CPU cache from a single shared stock to a per-page_counter
stock fundamentally change the memory stranding bounds?"

This is true, and I addressed this in the cover letter. Yes, the worst-case
upper bound grows by quite a bit, but it is difficult to hit that limit
since it would require a memcg process to be scheduled on all the CPUs,
and strand memory there via the stock. Nonetheless, restricting the
batch size should make this worst-case a bit better.

In commit 4/5 mm/memcontrol: convert memcg to use page_counter_stock()
Sashiko also raises two concerns.

"Could this synchronous loop cause cacheline bouncing and premature OOM kills?"

Sashiko is referring to the memcg-cpu iteration we do where we drain the
stock of an entire descendant completely. I also addressed this in the
cover letter and that I couldn't really reproduce the issue in my
testing. I addressed this every version but it seems like Sashiko does
not read the cover letter :' (

"Would doing a volatile read to check if
the stock has pages before calling atomic_xchg() help mitigate this?"

This one I agree with, I'll add:

if (!atomic_read(&stock->nr_pages))
	return;
nr_pages = atomic_xchg(&stock->nr_pages, 0);

And hopefully we can avoid most of the unnecsesary races (of course the
value can still change in between the read and the atomic_xchg but it's
just a best-effort optimization)

So I'll spin up a v5. One thing I'm going back and forth in my mind
is whether we want separate stocked and non-stocked variants, or if
that should just happen transparently within the calls.

Thanks again Sashiko!
Joshua

