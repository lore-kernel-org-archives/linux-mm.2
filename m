Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58098CFD348
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:15:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2C976B000D; Mon, 24 Nov 2025 14:15:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADD136B0029; Mon, 24 Nov 2025 14:15:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F3A46B002A; Mon, 24 Nov 2025 14:15:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 898866B000D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:15:42 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 415A21A051C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:15:40 +0000 (UTC)
X-FDA: 84146454840.09.7A589A0
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf08.hostedemail.com (Postfix) with ESMTP id 39D91160014
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:15:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QKcLFDMt;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764011738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uy/STkXZTXYrgITBtAfR5xJYldXIjH3PYEDKzxRY+ak=;
	b=VIVOXm6RXlv2gOTNB+MadqOM1IIIdd6TRm3Oefr7URTjq5Yz0ZfhTuQtljJ6TwQ0Makjmw
	lksUo4vxkYo4H2cFUTG8KjLr9i/Q9H2B6OrzK7WIYHFhI1ZKghbFJWQiRNb8Ce88NkCyKD
	am9NTotA50TSz4eZHLIsBNj0NxOjYSw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764011738; a=rsa-sha256;
	cv=none;
	b=5feXSzGqAPRBGmPtj7Mzf0bU7jEFwWcZX55MTMB8B30V0XNue1WVjIqXQG/fRCiShCfIca
	4mYrMCagngGJ3jNdoBTuAqMBiILM1kxS7JtKQuqzgakM05E4SpTjuFiM+bDOI4YQYELa1O
	OZupVnmvsM1H5JyU1xaTm2+c4RHy1SY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QKcLFDMt;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7c66822dd6dso1305533b3a.0
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:15:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764011737; x=1764616537; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uy/STkXZTXYrgITBtAfR5xJYldXIjH3PYEDKzxRY+ak=;
        b=QKcLFDMtHZMqonYCh3XHGR8ZPR9BmzNCtI1gqVDaNdf1AsbNHxATX2Okps/epfXzzb
         Eb3MxKMgWM1sj66igIihwqRJC2srZ9ES+UoG2w8LNcu6VLsl8pGOizT5A+PSF85neRT/
         e9bG3aL5KSC2ferBh3ipj6Oh6qphC+IFZgV7lBUX5o8vslz0DbAP5H7GPwcRU3VqV+07
         jM8+hyJZKWq4CAedzS5B7Fpq4IX1IaXq4LwiiX14dq64CfTLzcv3P2RpX4L2acWHWrIn
         vqPiqpypPm+kxLGwtyqZvC+EFXe5QaCDe7roqXHJvV+SnFqD4bT+zycF64aHzdI5HX/a
         14mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764011737; x=1764616537;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uy/STkXZTXYrgITBtAfR5xJYldXIjH3PYEDKzxRY+ak=;
        b=YHSawdUkZYYRnn9pvteeSfo0iMQqPCXhDDlA5UIE580z2yO2Byddpp8aPNFA2W59lD
         Uqf/ONn5v8lWLDv4rn3fSQRPVeFRk7pf8adhb1SxgNG4dbH3JoZchat+dQKI0v6MhBOQ
         xsarBplVE0p2Xgab+51TU6VfbqNCDvTNHl9k2gKdh6ZiSR2WML/ohJeOISwkAenULWkz
         TolM+m7MLXhOk3/4AxOJgqot45uGtTJQqPoNB8PSPM45guzY73oabrV9Jnl2+aBHp3Nm
         zcAwbc2OWj/UDwGGHPnQF8wyfdU+y5wQI6ieu9caVqVrxbB1BHlaWyERMS2JoOGD3SlQ
         h9wg==
X-Gm-Message-State: AOJu0Ywc9qnZapz/Q/oj8ZULSZIQThRXb7wkRrHH3McgkYVp4NvqoCOB
	qXJ5uGQhNzXMk5oPFjigP/bFK5yD1nfiGJ7z3GVS6awlOmTmLfd+R/ibvOKiVXdaYzU=
X-Gm-Gg: ASbGncsLWVJ9vCUg9UvwQo8uN27ir3rd1WzsKXNawmlUyUuuhQOZfTf8qK120893Rda
	wxDccIqRHomGAUySfS0yIH9hSDvW5cZ+OlEHHgjoxuV7iClOVN2CaMkF30jqXOKi9P2CBMTMwYF
	xC4OGRLYcw+SezFcLz26NWPJgCGl6QWqSTYwvxvLlyp//GEHRF1kajwCPgP/FUey7Zu2VVLdzwO
	zaQiuQAj8tzxnk3cM5CrmOHvhDXKV644k/8a9Ex+H6GE6x84eUjax3WVPgbfnO52MGdSaa9nYQ5
	35zV1r7eJO77NNQ5JB0UNCM5HMpKgrwNTwEPrYcDsd5VhW3n8QPzisVFRh47E9AJz57aAsooyqa
	3JWkjfJhVJchxH46eW2+uqFrzpauUqxSOUm0qAr4dHBJF3gM2evBdHif9Be4fis3h3La8O9eaQb
	9HtOCSWRz1IguYUsKE13VE3krWhNWRo52/WDFzY2Wy4T9MXirY
X-Google-Smtp-Source: AGHT+IHHR8gcm+u2rBmlqVse0ZQqmv1UWqForZAjRLZFPPF9ISEnQhFvT2RBfI2CGnz60va2DVmIKA==
X-Received: by 2002:a05:6a20:2449:b0:35e:521b:f4a1 with SMTP id adf61e73a8af0-3613e5b2d93mr19447853637.30.1764011736345;
        Mon, 24 Nov 2025 11:15:36 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bd75def75ffsm14327479a12.3.2025.11.24.11.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 11:15:34 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Subject: [PATCH v3 00/19] mm, swap: swap table phase II: unify swapin use
 swap cache and cleanup flags
Date: Tue, 25 Nov 2025 03:13:43 +0800
Message-Id: <20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGiuJGkC/12O0QrCIBhGX2V4naH+TVdXvUd04fRfE8oNFSvG3
 j03gmiX54Nz+CYSMTiM5FRNJGB20Q2+AOwqYnrtb0idLUwEEzVnTNH41CNNur0jHQVVFlgjsTb
 QaFKcMWDnXmvvci3cu5iG8F7zmS/rtySOm1LmlFGwB+iglWhAnBN6gz7tzfAgSyuLn8/59kkWi
 68UMJSopa3//XmeP5/uUqnsAAAA
X-Change-ID: 20251007-swap-table-p2-7d3086e5c38a
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 linux-pm@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764011730; l=8506;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=LWzQxbJRHW9VzB3LA2yzkorXpnWIvle6zmjZ3exFdgE=;
 b=+vRqLhaIXKmp1dQ/q7JNPlANEo8bJ6W/OF4vvI0SDr2ApA4J2CtvLO3yovd2OeoppwsfYWpUU
 dfPjL69KIrgCX2AKaRO1q2080UsdYEjJHOy2fzz3GDVObqgmHUj1SNp
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 39D91160014
X-Stat-Signature: txbeg8he6ij81wu6iq5de9ne5hr1q6dg
X-HE-Tag: 1764011738-772770
X-HE-Meta: U2FsdGVkX1/5BGSD1NmCna/FukesRB4Qbf6uVicXky7fG+VKtIRPWxMk7GgJTlwK17yGAKgXUcF+EnQjeWRcpwHFnW55ZV1Q0Kuhg6fmyHNn3zFncwfQSb7bPAwfJGlXaDGYQ9WHLu6SMjhyOagSKfML0MiVZB3vEoO1TPtF9vfItdjor7tDSPh0Ei17uyd1jETlECCBbAA6viyADPw6b+YaSLkR+rzAsXL7zPfJD4qL1UX4/6kH4GIA/ExVDngYY9ATKL0YV0MhoPiVHH14LPNxtFJJXvWuQF0PXqS7oMsUA9ytcK7DCA+7h2n0c9tGGOhjrLQJ8lD3QgDUn3HbzQQ/sCWh+/BAb0bwdCoJO6NE/pqa/trg8VvLz8kyJ5OyezJXCSq0zvZTVTTsmLOZbx6vwpNS1CpyGi+Yl/AEeIYYhAq9UgIPgk+rHcowoozwIIDUm6ll43rX48QaWNEtnfgc+AZEBv2gbrs4Sh5BsUNBMLs62qrjtMiX/oFhypC8tBkn2sxpY6Gri1+DxIejkLWpv0SkbSxC8rEzVilQUQWCB/z3h9Q6N1UMfF2OB2GAQrfKGM4ngi5KFa8soVR56KN6IpVbVZtIAG78P0n8mS16D+tZ36T1bbUfTLF9qohwKRJT+77hT0Wrxf/ex/x8lKAerVoOzCyz5bxM7/jtHRmg2WqCmnEkfWYtLRZwVjXGV3LOjNjKWCECMiBmdJrJa8s2xkcbqaNNg8nGo0x4N7x/rKAwxYwCvrXqrxEFeINd2RtjfRfmZw7SxyXG3EB+RVufCVp0TjCl2PzcBUVv+mM2lVpe+kmYNj8FGQ8z3Mw0zrxy7OLWmS9jlc9X2/7WINvNVvDXPbUQrXMFnfBWU0r68+f1yQxmsTaAyAz9mfXxBmbaFk9f63cgahAQmFuYNoe1jmeOLTpz7Ok/RS35F5gud78UvQCPp5rpOwV0ZaqLZcugkOqqY0OF8Ldmt5g
 2+lAsGq/
 OJauzLeW9JVONG6wAdDdxuK7CBn4KcO+mdsTNFVW7R/CRtoZ4IhZR5ond6RMkaBwkauCcW6fHi0eggyx95qHO+AdI3FFiRxTUuF3y1UUsT7jrDyiGJj2aDz4+K+CEsgstd7b62yrmkHvUV0/KnzTlyhDpJffCrOllBVguUDLFpzjjzPkWe/nc2MqfpMoDc5J6Ukx2vswH3FmUs4gStdseI3RW57qp296ZvKyf4kNnxnl21SBnktqVOKQnfHJ192VF8FjB0G9o9fEesWQ3lktbr24/Kq5hgrH6KSICfOiHZEqCiOBEfzfxM+Qiw40e3rRXnWgIT6pP9005gJWIYdgvSbSvLmwFuuAn4BcwjwYXm+nFEPs9bHQEQ5PDnl+xbeFYoiCR6HviiqUrheuG6Ad5hX6KCF5RBK8DAu1ayTEQ7BL2uhLt+aaPIh3IGEqgOYOqsIDrQdRQNQ8JjK2pAEwR8yYvLyiHECnWfx02
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series removes the SWP_SYNCHRONOUS_IO swap cache bypass swapin code and
special swap flag bits including SWAP_HAS_CACHE, along with many historical
issues. The performance is about ~20% better for some workloads, like
Redis with persistence. This also cleans up the code to prepare for
later phases, some patches are from a previously posted series.

Swap cache bypassing and swap synchronization in general had many
issues. Some are solved as workarounds, and some are still there [1]. To
resolve them in a clean way, one good solution is to always use swap
cache as the synchronization layer [2]. So we have to remove the swap
cache bypass swap-in path first. It wasn't very doable due to
performance issues, but now combined with the swap table, removing
the swap cache bypass path will instead improve the performance,
there is no reason to keep it.

Now we can rework the swap entry and cache synchronization following
the new design. Swap cache synchronization was heavily relying on
SWAP_HAS_CACHE, which is the cause of many issues. By dropping the usage
of special swap map bits and related workarounds, we get a cleaner code
base and prepare for merging the swap count into the swap table in the
next step.

And swap_map is now only used for swap count, so in the next phase,
swap_map can be merged into the swap table, which will clean up more
things and start to reduce the static memory usage. Removal of
swap_cgroup_ctrl is also doable, but needs to be done after we also
simplify the allocation of swapin folios: always use the new
swap_cache_alloc_folio helper so the accounting will also be managed by
the swap layer by then.

Test results:

Redis / Valkey bench:
=====================

Testing on a ARM64 VM 1.5G memory:
Server: valkey-server --maxmemory 2560M
Client: redis-benchmark -r 3000000 -n 3000000 -d 1024 -c 12 -P 32 -t get

        no persistence              with BGSAVE
Before: 460475.84 RPS               311591.19 RPS
After:  451943.34 RPS (-1.9%)       371379.06 RPS (+19.2%)

Testing on a x86_64 VM with 4G memory (system components takes about 2G):
Server:
Client: redis-benchmark -r 3000000 -n 3000000 -d 1024 -c 12 -P 32 -t get

        no persistence              with BGSAVE
Before: 306044.38 RPS               102745.88 RPS
After:  309645.44 RPS (+1.2%)       125313.28 RPS (+22.0%)

The performance is a lot better when persistence is applied. This should
apply to many other workloads that involve sharing memory and COW. A
slight performance drop was observed for the ARM64 Redis test: We are
still using swap_map to track the swap count, which is causing redundant
cache and CPU overhead and is not very performance-friendly for some
arches. This will be improved once we merge the swap map into the swap
table (as already demonstrated previously [3]).

vm-scabiity
===========
usemem --init-time -O -y -x -n 32 1536M (16G memory, global pressure,
simulated PMEM as swap), average result of 6 test run:

                           Before:         After:
System time:               282.22s         283.47s
Sum Throughput:            5677.35 MB/s    5688.78 MB/s
Single process Throughput: 176.41 MB/s     176.23 MB/s
Free latency:              518477.96 us    521488.06 us

Which is almost identical.

Build kernel test:
==================
Test using ZRAM as SWAP, make -j48, defconfig, on a x86_64 VM
with 4G RAM, under global pressure, avg of 32 test run:

                Before            After:
System time:    1379.91s          1364.22s (-0.11%)

Test using ZSWAP with NVME SWAP, make -j48, defconfig, on a x86_64 VM
with 4G RAM, under global pressure, avg of 32 test run:

                Before            After:
System time:    1822.52s          1803.33s (-0.11%)

Which is almost identical.

MySQL:
======
sysbench /usr/share/sysbench/oltp_read_only.lua --tables=16
--table-size=1000000 --threads=96 --time=600 (using ZRAM as SWAP, in a
512M memory cgroup, buffer pool set to 3G, 3 test run and 180s warm up).

Before: 318162.18 qps
After:  318512.01 qps (+0.01%)

In conclusion, the result is looking better or identical for most cases,
and it's especially better for workloads with swap count > 1 on SYNC_IO
devices, about ~20% gain in above test. Next phases will start to merge
swap count into swap table and reduce memory usage.

One more gain here is that we now have better support for THP swapin.
Previously, the THP swapin was bound with swap cache bypassing, which
only works for single-mapped folios. Removing the bypassing path also
enabled THP swapin for all folios. The THP swapin is still limited to
SYNC_IO devices, the limitation can be removed later.

This may cause more serious THP thrashing for certain workloads, but that's
not an issue caused by this series, it's a common THP issue we should resolve
separately.

Link: https://lore.kernel.org/linux-mm/CAMgjq7D5qoFEK9Omvd5_Zqs6M+TEoG03+2i_mhuP5CQPSOPrmQ@mail.gmail.com/ [1]
Link: https://lore.kernel.org/linux-mm/20240326185032.72159-1-ryncsn@gmail.com/ [2]
Link: https://lore.kernel.org/linux-mm/20250514201729.48420-1-ryncsn@gmail.com/ [3]

Suggested-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
Still basically same with V2, mostly comment update and build fix, and
rebase to resolve conflicts and for easier review and testing. Stress test and
performance test is looking good and basically same as before.

Changes in v3:
- Imporve and update comments [ Barry Song, YoungJun Park, Chris Li ]
- Simplify the changes of cluster_reclaim_range a bit, as YoungJun points
  out the change looked confusing.
- Fix a few typos I found during self review.
- Fix a few build error and warns.
- Link to v2: https://lore.kernel.org/r/20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com

Changes in v2:
- Rebased on latest mm-new to resolve conflicts, also appliable to
  mm-unstable.
- Imporve comment, and commit messages in multiple commits, many thanks to
  [Barry Song, YoungJun Park, Yosry Ahmed ]
- Fix cluster usable check in allocator [ YoungJun Park]
- Improve cover letter [ Chris Li ]
- Collect Reviewed-by [ Yosry Ahmed ]
- Fix a few build warning and issues from build bot.
- Link to v1: https://lore.kernel.org/r/20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com

---
Kairui Song (18):
      mm, swap: rename __read_swap_cache_async to swap_cache_alloc_folio
      mm, swap: split swap cache preparation loop into a standalone helper
      mm, swap: never bypass the swap cache even for SWP_SYNCHRONOUS_IO
      mm, swap: always try to free swap cache for SWP_SYNCHRONOUS_IO devices
      mm, swap: simplify the code and reduce indention
      mm, swap: free the swap cache after folio is mapped
      mm/shmem: never bypass the swap cache for SWP_SYNCHRONOUS_IO
      mm, swap: swap entry of a bad slot should not be considered as swapped out
      mm, swap: consolidate cluster reclaim and usability check
      mm, swap: split locked entry duplicating into a standalone helper
      mm, swap: use swap cache as the swap in synchronize layer
      mm, swap: remove workaround for unsynchronized swap map cache state
      mm, swap: cleanup swap entry management workflow
      mm, swap: add folio to swap cache directly on allocation
      mm, swap: check swap table directly for checking cache
      mm, swap: clean up and improve swap entries freeing
      mm, swap: drop the SWAP_HAS_CACHE flag
      mm, swap: remove no longer needed _swap_info_get

Nhat Pham (1):
      mm/shmem, swap: remove SWAP_MAP_SHMEM

 arch/s390/mm/gmap_helpers.c |   2 +-
 arch/s390/mm/pgtable.c      |   2 +-
 include/linux/swap.h        |  77 ++--
 kernel/power/swap.c         |  10 +-
 mm/madvise.c                |   2 +-
 mm/memory.c                 | 276 +++++++-------
 mm/rmap.c                   |   7 +-
 mm/shmem.c                  |  75 ++--
 mm/swap.h                   |  70 +++-
 mm/swap_state.c             | 338 +++++++++++------
 mm/swapfile.c               | 856 +++++++++++++++++++-------------------------
 mm/userfaultfd.c            |  10 +-
 mm/vmscan.c                 |   1 -
 mm/zswap.c                  |   4 +-
 14 files changed, 854 insertions(+), 876 deletions(-)
---
base-commit: 1fa8c5771a65fc5a56f6e39825561cdc8fa91e14
change-id: 20251007-swap-table-p2-7d3086e5c38a

Best regards,
-- 
Kairui Song <kasong@tencent.com>


