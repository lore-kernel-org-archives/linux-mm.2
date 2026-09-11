Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FEB1C88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 21:09:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6257C6B0092; Fri, 11 Sep 2026 17:09:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CF186B0093; Fri, 11 Sep 2026 17:09:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BDB06B0095; Fri, 11 Sep 2026 17:09:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 24BF36B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 17:09:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5901C1C203B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 21:09:04 +0000 (UTC)
X-FDA: 85202721408.16.CC72237
Received: from mail-oa2-f12.google.com (mail-oa2-f12.google.com [74.125.231.76])
	by imf18.hostedemail.com (Postfix) with ESMTP id 88D631C000B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 21:09:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WFdYrRFd;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.76 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789160942;
	b=Vt71dLDtSzT/Ys8TN53RHoIhYpdrIrnd5ttkFwZW38a9H36lD8QbwtpS55O35BfnhENbAU
	1prwFn9ru2ZBfNWL3KDZyy+jiTF8+uwHyAyzi1qgKMF72YVXNXsDv1nX9EFKaq2Ebc9Fhs
	wb98G5txt2J5y7njFtu/b6zb/gEckwI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WFdYrRFd;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.76 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789160942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TBG7NOe4Sh6Qo2OfXnbQ8kr2wauyToElAZG6HGEhqgo=;
	b=lEDQUsnlXIHsmCY8ALeEOnQsOLayMLbmoaFscj6IiVv03Eamk+Qc7pm3LUQuE7OBiRGTJM
	vLP231s+osNZWa6WALmZBcyFfOPP+qPDsDp9ywTNphesSmj1O+6Wlh0y1Aj1GIABtfRQmP
	TXE/qoxv8evJBMIvusP8njrBeP5K2O4=
Received: by mail-oa2-f12.google.com with SMTP id 586e51a60fabf-466ccdd76a9so21248fac.0
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789160941; x=1789765741; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TBG7NOe4Sh6Qo2OfXnbQ8kr2wauyToElAZG6HGEhqgo=;
        b=WFdYrRFd6LMqY/vn3GOMBrZ/L/hoxU3lodAE/RUGH19D63VCh9h+jUUa64/iCqqTeH
         af7GftjAVaEeLdezFaJxb7/Fy86GbT8Yt1c9nE6HLNfAAz9DfBMfdy4MUjSoQwyAEcHy
         edq4rZ8ARkW8eIuwBaTkrpJtR8/gymhCVFRdYpJcfwJj2KTbCIqfmScZkFrtWZ1IKu9V
         0KfIKsaWtyC2LN5YkFE4xHt+f55CRsbwNA8lbBhWrvIcOZcNgs484jOeJbT6tc6cY/Ru
         GsItsbyczKpmwYwCSXQ25qkp5gtauI4Gr12D/tyrdw7YvT9FpZK0UJngyGrD9TOjMYbg
         RlhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789160941; x=1789765741;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TBG7NOe4Sh6Qo2OfXnbQ8kr2wauyToElAZG6HGEhqgo=;
        b=SOu5QcqjB5KVRjfU7ON6/dQ5KUFl1DbFMnDJwLH5jUJ2d1RG+fklgwfxVf2CEPv0NM
         3xke2ts5wxetAwNZp7u+jHtRW4t0phFruNd2nXIrR9hNw+99jOS45K87GKnX2Sphf/F+
         iLgmXixKB6Dz+Sth5nZirlmXRlfQHTsINZCAAyjAL9tcyEdBTP0IzS4Bpap/C+mG68Vw
         2JrjPwiTDgeMMZChjnj4o4MKrgv1s9cx9U5IKULycM5QBsug2O7MAOt2vJoi/Sqn34/h
         putRilI/06IyEMWqpUyuTXLlM6zVJW9O/5VpY15ze3JXhNG+A+0RvfDUMP9CeDyXVYUw
         K7TQ==
X-Forwarded-Encrypted: i=1; AKwUvBwgN93SsuAmKE28EfsNgBhq4DCdNes4blQUSKlzkBfIfM6QO6W6FVnELJv0l+vvd5/ZEtB9YL68ew==@kvack.org
X-Gm-Message-State: AFuF++kw4pQ3X0Xxcgn5EPz6FZ3NIz8Oi8ZUNdXZjPQhKQGVYuRl4WMR
	b+b52OWPQK+Eepn9WCYzfX2ONxKtSs9UPdPbA+7NfJBnIPW1zU+haKii
X-Gm-Gg: AYBFou2rcM6LcDBzpYslndz0yiF2h7hE0jJnviIKf4/ULrzO9kCMO7pHLJPZEa0Nnd/
	G6iQwiE01YaIWgqjALuSjz6Ejna9V3sCIhdor1NCECirXD/v+1hR1TvJhhKnx/+ZRcYoQbWTB0R
	BjwR90nfHiWAlBC4GxEYDofWk6W9XhLEGCav08HXDcd/BecaaQZwh+X4O6jvK/Rc2TC8vsD/281
	91P03d8x+ftz9P7mSLzAFBDYMbDknkF8NZm0lLNpj1Ey6GNGNG9Dhxaahh8++5U3O8nEoxoVXB/
	zfLZI/hZ+Uj1MqEJjHdK8ibzUfXl6ZPoCHFT6EO4/+bQ+7kfSC0YYJ7TKJKqxi/K6OJMIIP+gWe
	fqGJmfu6JtY9nDokORFu265kCelqvk91zwxohkWxNZ5VBzzoY1P6vyc7jxgN8X0SKv9da8ZKF84
	+OvGwRYMG25EJ6/oBkZa/rGuxhjmaPv8RjJsmxGB2b/GFRP+u46u8XE0K1qtdgD5ZBjpoyibU02
	nG/M75jHSGK1hB8T39914LLvt6a3A==
X-Received: by 2002:a05:6870:910d:b0:45e:caa2:4ea with SMTP id 586e51a60fabf-47f5805e0femr190151fac.6.1789160941379;
        Fri, 11 Sep 2026 14:09:01 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:2b::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-47df64d89b9sm3191832fac.1.2026.09.11.14.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 14:09:00 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Bharata B Rao <bharata@amd.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Jonathan.Cameron@huawei.com,
	dave.hansen@intel.com,
	gourry@gourry.net,
	mgorman@techsingularity.net,
	mingo@redhat.com,
	peterz@infradead.org,
	raghavendra.kt@amd.com,
	riel@surriel.com,
	rientjes@google.com,
	sj@kernel.org,
	weixugc@google.com,
	willy@infradead.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	dave@stgolabs.net,
	nifan.cxl@gmail.com,
	xuezhengchu@huawei.com,
	yiannis@zptcorp.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	byungchul@sk.com,
	kinseyho@google.com,
	joshua.hahnjy@gmail.com,
	yuanchu@google.com,
	balbirs@nvidia.com,
	alok.rathore@samsung.com,
	shivankg@amd.com,
	donettom@linux.ibm.com
Subject: Re: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
Date: Fri, 11 Sep 2026 14:08:58 -0700
Message-ID: <20260911210859.1359875-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260728054356.291998-1-bharata@amd.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 88D631C000B
X-Rspam-User: 
X-Stat-Signature: xwnreond5ec6u6nqf8as8cdrad9t9zhp
X-HE-Tag: 1789160942-913737
X-HE-Meta: U2FsdGVkX1/8RUrF9TiuPoOvYh8y+keOxdOYEG5+htWIh7TtiHgn2tj/A/anyAAjrSTu409wccanPNNf02AzzXmvq3FQICMlnJrGw/r9RhQgXzkLkK0ge4LpqytOElzBUFezE69gRWrHCLt+VE8YERLsbVob09ObuJFYy8rg7qtxLmmp5t7xly0CPn4b0aEHRlqYvF8F/qH3uS9yRtye0vjrE3upJtAYluEmgfoJMFTVXbL2yPgV2UyuEQKxKUmAO4Q1ELl3NM1RwAooVjd2MZAvCgu1p8WOl4hOXawDydhph6xv+r9/GCgV8/TJXlchTkWxd7lTCKtPiCBrBmV7psT71PmbUQsnGc4rsLtITIj5C5QWZeOL7UveQ0++qQSpQUBi/HoqjrSCainoE7Ak5YoStU/+FE2h1/ErXa1Vi24bgZaD/MT3csogZG+MjasdVLa7Ntjm5G8TeAc6stPrIJK4qKe9EW8lVGuarYKhNKwlL8Wmz5MDrdKfdu66lm0Hgajr0buGKe4MVqsGRUkCcRTrwiofkdfFeXUotkPG1X0SB/x/anL6cPv8pn09qZ3Sv5GGXl22i6J0qhhsnfUh0dA5Oe61oA/c8uVzG6UPNc0Lhfmg3ek9FeugLSC8zsQY5YzVcIBj8a1GFb1osfKaSYj2qWH7f7W8e8j7CpkRddTRUmDi5SKR7k7phVjtIddE43imibS3JwzGDEIyMKhh2DofRKpBDEd1cW7mC7hvdpsBNWWblQ9wXeB2Jpoa9lL14PtpfFcESsmau/iHNny5NuY1wybhimdVetFIv4i3uVj8gTZSbrZTsihHS3bte0k+cNgfqQnvo6y4Lxmqow27Rd0j3W/qTSdYwJhyAHkDTD1F+KiYExyGEP1OzTAoB2s7s6j8ZKPYqSCDcBpmNSscHMqc6nZXa/hI8m0eY0uaps/Mq1z0WyYg9yO3kbaYsc6JgA71odc+xoVUEn0vAmx
 Txcv9wKf
 tqpX3Ap+1lAblPLYtAebkKcYRDuw7FfuUeQdSjya++rAoInMXWgHE4StialWOLN72uNcXZrl4K5jXglqnGFlJsr9HVJ+HvNa3S7PKdMJ6gbKSTBxqb9OIhUbhpmEW7VLfTVdyus0YDO0SQdbqCBnjju3DNReNBhEGV7/d1WtR4t/sxiUc7Qwc9VWJ33qhOBhvmQzryKNN4swN3knk72gT/ocl+9CrbDDS/W8qtAyUDJSi5K9Vu9ayAVn2/ZNnHVlzTbs0X4101w+BjHCdHHQgVdSWZ45yIylx5EeSeAiUX1XjmZlwwzWXieKM2GrJSjbihYhTv0nEs7m0/hnNvpRIV+NfqxQbK6iP30c6FX3W3xBDfPmQrq0jEK+L+9WSRllhOd19XK7CyPgmApKLwh8f0+YCi3OjSIVvRD8JynpkYJz7ptrtZEcLxCt8/fgaXs6q3RA3DZghdislBa2l/R/Lbf2shCsm++v84SLk5J0F9p0aK2rHoNhcaq6AFJIACk05W6FfJKqO1RD5tm89V5M1iuO3ACBTaIftq6e1DvyKAbmqEykg5jpqoLEnYOE0hSOVAa/UH77jhhgiT/ZuDvdF9PhQW+NuAN/9hkprkvifYCfnwjc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Jul 2026 11:13:48 +0530 Bharata B Rao <bharata@amd.com> wrote:

> Hi,
> 
> This patchset introduces pghot, a subsystem for hot page tracking and
> promotion. It collects memory access information from multiple sources,
> classifies hot pages resident in lower-tier memory, and promotes them to
> faster tiers via a per-lower-tier-node kernel thread (kmigrated).
> 
> The main changes in v8 are a rework of the per-section hotness map to be
> RCU-protected, a move of the pghot tunables from debugfs to sysctl, and a
> rework of the AMD IBS Memory Profiler driver that now uses a dedicated system
> interrupt vector instead of an NMI handler. The IBS driver is also split
> into core infrastructure and a separate patch that adds the runtime
> controls and arms the profiler. Also there are a few fixes to the hint
> faults source.
> 
> Goals of this patchset:
> 
> - Unify hot page detection from multiple sources like hint faults,
>   page table scans, hardware hints (AMD IBS).
> - Decouple detection from migration.
> - Centralize promotion logic via per-lower-tier-node kmigrated kernel
>   thread.
> - Move promotion rate-limiting and related logic used by numa_balancing=2
>   (NUMAB2, the current NUMA balancing-based promotion) from the scheduler
>   to pghot for broader reuse.
> 
> Currently, multiple kernel subsystems detect page accesses independently.
> This patchset consolidates accesses from these mechanisms by providing:
> 
> - A common API for reporting page accesses.
> - Shared infrastructure for tracking hotness at PFN granularity.
> - Per-lower-tier-node kernel threads for promoting pages.

Hi Bharata,

We've been testing pghot in a Meta kernel with worklaods to try and see
what the performance characteristics look like. I wanted to report
some of the findings that we've found in our testing. Note that these
results are from a modified kernel that has my tiered memcg series [1]
backported, as well as Gregory's numa balancing scanning fixes [2]
as well. 

- Without tuning and using the default tunables that pghot comes with,
  we've found around a slight performance regression against raw NUMAB2.
  This was being run on a host with 750G DRAM and 250G CXL.
- However, we've found lower pgscan_direct, pgpromote, and pgdemote
  rates as well.
- We've seen PSI dramatically drop on the host as well as the promotion
  happens asynchronously. 
- I also found a bug where the kmigrated thread isn't created for nodes
  that are onlined later after boot, like CXL nodes that get onlined
  with memory later on. I've been using a small hack commit in
  pghot_memhp_callback that just checks for the MEM_ONLINE case and
  spawns a kmigrated thread.

Finally, we've seen some issues with pghot causing userspace crashes,
which leads us to believe that there might be some bugs that manifest
in userspace as well (we have not been able to find out where in pghot
these bugs are introduced).

Thanks for working on pghot!
Joshua

[1] https://lore.kernel.org/all/20260807202059.2620949-1-joshua.hahnjy@gmail.com/
[2] https://lore.kernel.org/all/20260911001826.2109390-1-gourry@gourry.net/

