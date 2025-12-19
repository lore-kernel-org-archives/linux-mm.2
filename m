Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4915E66882
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 20:06:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 563DB6B00A8; Fri, 19 Dec 2025 15:06:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 535006B00A9; Fri, 19 Dec 2025 15:06:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 437CA6B00AA; Fri, 19 Dec 2025 15:06:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 304766B00A8
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:06:02 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C8DB31A016E
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:06:01 +0000 (UTC)
X-FDA: 84237301722.08.0C39279
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf14.hostedemail.com (Postfix) with ESMTP id D4476100008
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:05:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DVGVYifl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766174760; a=rsa-sha256;
	cv=none;
	b=s6XiaL064RlwF5U4W93/x6+xTddpLQL6ulPZsBxNtmtzcqIOd/U4gzkELICydyB288sq3N
	ONteD9gOOmUbBoGrlHVaCxS/5fzNfyd84OuVzXt6Iy5wSRze7aYzi+qPyKk6eBkhZgpJsT
	OIFVRuNlU1m4qxJx2eblwfreZd8SlGo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DVGVYifl;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766174760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4w5CiTpqGrabbxUxAh6ePhewNTKmPofU9jkTiJ1MvgA=;
	b=dPj+RvBmj3FHkgMzW6Oi7CDjeYGRbGASp7lMUFDJFJ9BgUfSg9DYeqsNfqz8lV61RpRZkv
	OUKVPyBkDw13XMCFbxh+lAvyw3DffaCYKJ3SNDcsyHe0Fcq0hi2byDaj9ty16F4EPd4H51
	gno6FS1eFBJkgikXmr4HMt+/5rcT5A8=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-64b608ffca7so2574031a12.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 12:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766174758; x=1766779558; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4w5CiTpqGrabbxUxAh6ePhewNTKmPofU9jkTiJ1MvgA=;
        b=DVGVYiflz4liCd8w3eIeCdBtOgtcy9N3b19nLMIFrhos/kEqMD2xgBOdWFU3oqWaIp
         NRhwKV49/C7qTB6JkeYbGnM3UfNiFQ641fff0bU25siN/mxIfcDrNiKxLR3Ji2qjX5K3
         n9ulxmLePpf+Me4RYOA+l7jidQKMpNF7DJzOM1AAQZw/AT0uZ/KTQHP+gUu3kIdLkBVP
         oq8rmRnZ5xsqT7Gp+qsd8AzbtF3W6Ioa259jpyYtFBxJnpT9G5RiUQnpag7EUaelACZq
         N+nhbWgLq4BkzxiiGxCQHtFUjISjYICd0VgTFAIDSwFaPvTP1h/4NcmGeqNgyctATD59
         RCNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766174758; x=1766779558;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4w5CiTpqGrabbxUxAh6ePhewNTKmPofU9jkTiJ1MvgA=;
        b=sc9UdtzIJAc5zWioNW3nSSVeD9Q9XTeyas7AocxVZTpd4dwGYfoAvsth1NPVwrL7is
         QkLWX9pwrPATxYJ+Y6lyBeHajMNVl0/gvw1IkAAa+quAI1kOVCsT69ywlpYVrX3TOuXe
         DuYgjkHNLgEuEEl36JBg30RaAgUjt29BGLj6TntM+Rxo2psAtf7p33QDe/1ZYSxAzOfA
         rFOVEQ3tpPjVka+QyfLb21LmLjeUSPZuHko5PW12I7VjR3to2aI5vQ5y4sdpy1J0oFpW
         vaKJrUocS0n61WdzM5+U1B03jQTbs9M8G07rc0YRlC9mGn7MWBr5ZfYzUdFum35WP5FF
         MvoQ==
X-Gm-Message-State: AOJu0YzHc9fSIePIZAKtGb2DCxbrcns6egiBexjoafZ5R6S3W0xakjh7
	VnT4GEP35cCXBX9hkM0kI4pOJFQ/+Ebb32IW08C81BRKw9wbEqaluo7JMjFzPhDtxH4jQXFnoS/
	Zfg39uF0oA1b5NxrOxbaEWbOcemxqXBXfiUIPBSU=
X-Gm-Gg: AY/fxX7rf9Au1x6agKZqer+JxPhGfiKTyuzrE08ZBllbGHIAJEgCSujko4xsdapystU
	oArfT6yizhr5RXqkhs1OffaKgVdKPoJCsc6pkObHRrOsVgEg+MaBAmNm0ZxZwk25LrC6YPvHXv6
	7LD7N8Dg/m41WdfnNA9tziTXlmV0m4PcVfj+0POQcQZAYS02rRbrcPC5DmxTLoAwDlDsuM+5UgT
	gbrNkCq3goaNWdFjFYzmeWGlI9WVWEw08O9RGuBL3pOxYkkA4Oy/nhSJAddQNJye3wffrgIMq36
	++M1gj7H/35xATYQcIpVCet+wRPmHktk4EKsz6717A==
X-Google-Smtp-Source: AGHT+IF1POnLCa4AjD0T4HL68OsMv+4HDDO0cpabJm86414ifutbIdde1m67LWKd/ckIi8nE4Q7eS3r7NXO8ejqKkZs=
X-Received: by 2002:aa7:c348:0:b0:64b:8f56:f804 with SMTP id
 4fb4d7f45d1cf-64b8f56ff7fmr2613779a12.28.1766174757596; Fri, 19 Dec 2025
 12:05:57 -0800 (PST)
MIME-Version: 1.0
References: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
In-Reply-To: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 20 Dec 2025 04:05:21 +0800
X-Gm-Features: AQt7F2rEwxuypBr72KxPfJdvuV5mfvnYo1-1zcPWVt_eak3CiU3TT4aXkr2_eeI
Message-ID: <CAMgjq7D5bmQvkR_Lw3Fjx+oSwonvT0AqJUM3_wYahpqzk5xHbg@mail.gmail.com>
Subject: Re: [PATCH v5 00/19] mm, swap: swap table phase II: unify swapin use
 swap cache and cleanup flags
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-pm@vger.kernel.org, "Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D4476100008
X-Stat-Signature: nad6xjtebadgskadczz88w6gdmehtu31
X-Rspam-User: 
X-HE-Tag: 1766174759-67012
X-HE-Meta: U2FsdGVkX1/JnYaueIGIagqTqXSphlegQhL6GHG5J3qa4uXI72znmVY9yM/hQQK4wZKHjGKpbLKSK1ZLixohLi0Opdq5O0BkH4jKLI2Mk5YXA9lvcd65FM0rwO/sNToIZSIftsLH0sOi669dCw8AqFUPwDUTMbuHiOJ4K7bejWJWlVMzY5z/rMtrPEFGlWZV6VSUebsHyCZCKYJXWYNZCetk0KVOhFAkEI/R8IW7glzuyee6BN8Ysqn/5OTsuff8UrUEPtCxOYJhoWtObmWByZRorT4+40pZlLdJQGh3x901LAJtbkWeVf+QefGzhsZUYpgIRhsoUljwphWw0koB5y/9NWCAL3/0lObQqMItw31Co6OFFSCOtBkYl4efGG26yq/i9bc/1hDrRu9okhwlQU5yvrHCbpdtkd1R6Of2zJPCce5XrBW+RTO8dpFNRVtvpZs731BszmqcbjVjtpJ3DvEftfSe4DbCZiaWOgWibuq2jt2cbnZ1kjutz2o/tBwjPvqOCLRFuCQ9rK+F4af+L08fIXBG9vqCLBbd1ppb5SJ1x2stCAdQC5Esj7zm8v8FzgfYJhwBTn5ajqlzeD6rYxsxGmCEJCxvv0Q/AyEp7eZemEGQy98olD6kDgO3sxjbS5F13L1kYL5qhFSKGfs1oFb4bkXk/iSF4zwYFHL8q+lAw9Sn93f+S7HlRc8fHEiUHuOzBPnkYWc9pjgXgR69QESXxH4yT6y12uuwzpCnupTnvn01f0Cam9bTavH8UTZrIHclrwBj0AfdemfENR2CzAh3dl6C1u+eq25Y7e9K0/BTShtp+z/Xh9rZlSUxjOe19WIUOUhD3Dr4a9y6edMN2HIgJMrTrsCsiM8zwBY9hAc0zotsbNQxN3X7DQYB1cGg46zz5nmrZAjpm0POzT0RVRq9JxQMaebye6PYdDxxnGpHsP9t9F/FKcSBVY5CVsoNvb9fyo4aY8RhLaPq7Tm
 fZ3Tdcmz
 Lfm9LdIHaFH03J9qIF9Gcmv94THXXPtFtgdtzqCQ2L33zzQtVrwEsLJG3lNyrseJWoqLYrhOlysy2Vt0cw/sa3xR89aU7v6U43adYiRolYQdAbETHq9Wcj7OOtPTjJH9AQnj58Sbfq17FUcC2s4TPE3q74yJ5KJGsSqjJOmYyPdugKvChjcsiRk2TZHujvom8vLaqLRtzNXK/GX4UG3iWb4UZZIx2dJLSFiZJxuE4eeF5355ncfuznSZfum1qhgJ45Q9wbs5fDxiydT6fj/f4/yg7dHrBb75ZKUtHAv9BpokHa1x5nt4YsPezUer8yfMqwoKBDuIZ2lbpPYcDN41W0uyVwpLK+rfU+l5RJExrC8YRUAFLadAhywhahVy/WC/+QCpaDYx1yq0Xr7yegiSecwwFoedYOBwZ9NNRWHRRX97g0X+hf5EVLQtEhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 20, 2025 at 3:44=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> This series removes the SWP_SYNCHRONOUS_IO swap cache bypass swapin code =
and
> special swap flag bits including SWAP_HAS_CACHE, along with many historic=
al
> issues. The performance is about ~20% better for some workloads, like
> Redis with persistence. This also cleans up the code to prepare for
> later phases, some patches are from a previously posted series.
>
> Swap cache bypassing and swap synchronization in general had many
> issues. Some are solved as workarounds, and some are still there [1]. To
> resolve them in a clean way, one good solution is to always use swap
> cache as the synchronization layer [2]. So we have to remove the swap
> cache bypass swap-in path first. It wasn't very doable due to
> performance issues, but now combined with the swap table, removing
> the swap cache bypass path will instead improve the performance,
> there is no reason to keep it.
>
> Now we can rework the swap entry and cache synchronization following
> the new design. Swap cache synchronization was heavily relying on
> SWAP_HAS_CACHE, which is the cause of many issues. By dropping the usage
> of special swap map bits and related workarounds, we get a cleaner code
> base and prepare for merging the swap count into the swap table in the
> next step.
>
> And swap_map is now only used for swap count, so in the next phase,
> swap_map can be merged into the swap table, which will clean up more
> things and start to reduce the static memory usage. Removal of
> swap_cgroup_ctrl is also doable, but needs to be done after we also
> simplify the allocation of swapin folios: always use the new
> swap_cache_alloc_folio helper so the accounting will also be managed by
> the swap layer by then.
>
> Test results:
>
> Redis / Valkey bench:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Testing on a ARM64 VM 1.5G memory:
> Server: valkey-server --maxmemory 2560M
> Client: redis-benchmark -r 3000000 -n 3000000 -d 1024 -c 12 -P 32 -t get
>
>         no persistence              with BGSAVE
> Before: 460475.84 RPS               311591.19 RPS
> After:  451943.34 RPS (-1.9%)       371379.06 RPS (+19.2%)
>
> Testing on a x86_64 VM with 4G memory (system components takes about 2G):
> Server:
> Client: redis-benchmark -r 3000000 -n 3000000 -d 1024 -c 12 -P 32 -t get
>
>         no persistence              with BGSAVE
> Before: 306044.38 RPS               102745.88 RPS
> After:  309645.44 RPS (+1.2%)       125313.28 RPS (+22.0%)
>
> The performance is a lot better when persistence is applied. This should
> apply to many other workloads that involve sharing memory and COW. A
> slight performance drop was observed for the ARM64 Redis test: We are
> still using swap_map to track the swap count, which is causing redundant
> cache and CPU overhead and is not very performance-friendly for some
> arches. This will be improved once we merge the swap map into the swap
> table (as already demonstrated previously [3]).
>
> vm-scabiity
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> usemem --init-time -O -y -x -n 32 1536M (16G memory, global pressure,
> simulated PMEM as swap), average result of 6 test run:
>
>                            Before:         After:
> System time:               282.22s         283.47s
> Sum Throughput:            5677.35 MB/s    5688.78 MB/s
> Single process Throughput: 176.41 MB/s     176.23 MB/s
> Free latency:              518477.96 us    521488.06 us
>
> Which is almost identical.
>
> Build kernel test:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Test using ZRAM as SWAP, make -j48, defconfig, on a x86_64 VM
> with 4G RAM, under global pressure, avg of 32 test run:
>
>                 Before            After:
> System time:    1379.91s          1364.22s (-0.11%)
>
> Test using ZSWAP with NVME SWAP, make -j48, defconfig, on a x86_64 VM
> with 4G RAM, under global pressure, avg of 32 test run:
>
>                 Before            After:
> System time:    1822.52s          1803.33s (-0.11%)
>
> Which is almost identical.
>
> MySQL:
> =3D=3D=3D=3D=3D=3D
> sysbench /usr/share/sysbench/oltp_read_only.lua --tables=3D16
> --table-size=3D1000000 --threads=3D96 --time=3D600 (using ZRAM as SWAP, i=
n a
> 512M memory cgroup, buffer pool set to 3G, 3 test run and 180s warm up).
>
> Before: 318162.18 qps
> After:  318512.01 qps (+0.01%)
>
> In conclusion, the result is looking better or identical for most cases,
> and it's especially better for workloads with swap count > 1 on SYNC_IO
> devices, about ~20% gain in above test. Next phases will start to merge
> swap count into swap table and reduce memory usage.
>
> One more gain here is that we now have better support for THP swapin.
> Previously, the THP swapin was bound with swap cache bypassing, which
> only works for single-mapped folios. Removing the bypassing path also
> enabled THP swapin for all folios. The THP swapin is still limited to
> SYNC_IO devices, the limitation can be removed later.
>
> This may cause more serious THP thrashing for certain workloads, but that=
's
> not an issue caused by this series, it's a common THP issue we should res=
olve
> separately.
>
> Link: https://lore.kernel.org/linux-mm/CAMgjq7D5qoFEK9Omvd5_Zqs6M+TEoG03+=
2i_mhuP5CQPSOPrmQ@mail.gmail.com/ [1]
> Link: https://lore.kernel.org/linux-mm/20240326185032.72159-1-ryncsn@gmai=
l.com/ [2]
> Link: https://lore.kernel.org/linux-mm/20250514201729.48420-1-ryncsn@gmai=
l.com/ [3]
>
> Suggested-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
> Changes in v5:
> Rebased on top of current mm-unstalbe, also appliable on mm-new.
> - Solve trivial conlicts with 6.19 rc1 for easier reviewing.
> - Don't change the argument for swap_entry_swapped [ Baoquan He ].
> - Update commit message and comment [ Baoquan He ].
> - Add a WARN in swap_dup_entries to catch potential swap count
>   overflow. No error was ever observed for this but the check existed
>   before, so just keep it to be very careful.
> - Link to v4: https://lore.kernel.org/r/20251205-swap-table-p2-v4-0-cb7e2=
8a26a40@tencent.com
>
> Changes in v4:
> - Rebase on latest mm-unstable, should be also mergeable with mm-new.
> - Update the shmem update commit message as suggested by, and reviewed
>   by [ Baolin Wang ].
> - Add a WARN_ON to catch more potential issue and update a few comments.
> - Link to v3: https://lore.kernel.org/r/20251125-swap-table-p2-v3-0-33f54=
f707a5c@tencent.com
>
> Changes in v3:
> - Imporve and update comments [ Barry Song, YoungJun Park, Chris Li ]
> - Simplify the changes of cluster_reclaim_range a bit, as YoungJun points
>   out the change looked confusing.
> - Fix a few typos I found during self review.
> - Fix a few build error and warns.
> - Link to v2: https://lore.kernel.org/r/20251117-swap-table-p2-v2-0-37730=
e6ea6d5@tencent.com
>
> Changes in v2:
> - Rebased on latest mm-new to resolve conflicts, also appliable to
>   mm-unstable.
> - Imporve comment, and commit messages in multiple commits, many thanks t=
o
>   [Barry Song, YoungJun Park, Yosry Ahmed ]
> - Fix cluster usable check in allocator [ YoungJun Park]
> - Improve cover letter [ Chris Li ]
> - Collect Reviewed-by [ Yosry Ahmed ]
> - Fix a few build warning and issues from build bot.
> - Link to v1: https://lore.kernel.org/r/20251029-swap-table-p2-v1-0-3d43f=
3b6ec32@tencent.com
>
> ---
> Kairui Song (18):
>       mm, swap: rename __read_swap_cache_async to swap_cache_alloc_folio
>       mm, swap: split swap cache preparation loop into a standalone helpe=
r
>       mm, swap: never bypass the swap cache even for SWP_SYNCHRONOUS_IO
>       mm, swap: always try to free swap cache for SWP_SYNCHRONOUS_IO devi=
ces
>       mm, swap: simplify the code and reduce indention
>       mm, swap: free the swap cache after folio is mapped
>       mm/shmem: never bypass the swap cache for SWP_SYNCHRONOUS_IO

Gmail blocked my Patch 7 so I have to resend it manually, it still
appears on lore thread just fine but the order seems a bit odd. Hope
this won't cause trouble for everyone.

