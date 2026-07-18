Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E645C4451C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 09:37:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B9296B0099; Sat, 18 Jul 2026 05:37:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 769B96B009D; Sat, 18 Jul 2026 05:37:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 681186B009E; Sat, 18 Jul 2026 05:37:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 439B26B0099
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:37:34 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CEDB51C030F
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:37:33 +0000 (UTC)
X-FDA: 85001394786.13.654F8B6
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	by imf15.hostedemail.com (Postfix) with ESMTP id D18DEA0005
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:37:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784367452;
	b=h3qpIfOxb8Aa9OQVG+0qHV95tW4HoVFl4ZVKrXhKD/KwzMfFcgvk1tKpfcjXW2J63vtLqS
	kqo0xAIXrhM+2KEl8I/2etWMNS+2vMBSTt1vDmi/24ho3VaqE0CuVwZ9IqGo0ndJyme8VW
	0j/Gg5R87iC119TpDE2DQ5HoS884xyA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784367452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=pCuVZuUlHgeA31AiujD2V0GiDFd6tOmt04WPdwSKVtk=;
	b=aQTwvejXlPyE7T95VX72nRJwuCE5ip128Yau8D2fvJkBOM0HTxhcjUIwXGy8E8Ml4nl5lW
	6a8XQe+nCeB2XRvDOlMj9Ijiz9E2WOOv9dklZH8DefYX6SX7K2Gexp8oDjoES5D9vFtYB2
	MVt01YFv45D0UZawVpItg0PmcTZjjZU=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 711273EBC8;
	Sat, 18 Jul 2026 09:37:26 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH 0/2] mm: zswap: free cold writeback folios promptly
Date: Sat, 18 Jul 2026 11:36:38 +0200
Message-ID: <20260718093723.153324-1-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: -100
X-GND-Cause: dmFkZTFxZvr6XKnOKfRc1Y5n/c8ApM6/T31QCAr0/v+UL4mcP4oFJ63kVxE/eDJp0cRZxKS+V8CME7pUMvNthBL3n3tsGJHtOKbj5Q2GymwU+g+1B8LAIa0550zzXOy+ei8CgQ769VWG59bVPiwVl6po3B1xr2qitYDOHC9e/4FHoR1YSDCeUhwHnZunO4MAKXe/GIaI8fHfeMhlNDfM22nJeMwWtqUVzotlsN+FluS5+iSFLl6rPUt1JKYbPTa+cGnQp78Hd4xR90wjmNlThTrPSs8PZTX0wdLUQSBg5xGRZ0SAThnasMoulXFn5T1gia/xPAbs+OXELh9u/pJoOY4/k9AHemdb5/3dlp7bNnu8DlEY84qS2kwyJX070/NChOFC4aMr5sgTLCu/a91wGVLmYPUh91hvv4T3VT7Iw1oin8GDe2vsoQyy/jbjsaxtvlPQQ2YqDDBwfXPrKjQwUO8ALGChTZ6rHjGGFykb0cdwt3cav0Qy1jrhD8B+8Jc0Lh4GVEiq5HwjwB0CdHSHxDJl5GGawLqyXpiVTWsmNfn6F8ucG3RPkTuApICmYiN0P1ugqBkILAO88b0UYQbKfWOMrGXOcPp7vXH2vxyQM4MZcp/YRQLaJxfewoqJ4NBDslZyvQhTa7M4dceAe5pDJ0wAXWHmn1/brv9z5a8VEhjiNEd1bQ
X-GND-State: clean
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D18DEA0005
X-Stat-Signature: 7eaifao17nkhaisgjpa5ybjtzuwrp34o
X-HE-Tag: 1784367451-494700
X-HE-Meta: U2FsdGVkX18OLUrP+XF4RwQtE5BpdYF/wq6Jg7kkdZQURrfh+OoEtLYsZ1cK3uS/XoLXbQ5XIp314Fos1kWhCLBmfYKGnFuYooIzCKb0fzHwTGIldMZyWMagV4rctGeknme7UICv8ohpHD9oxnOk5Xu+Q5LG3ARXIzLIHh5XK38fzWh3VEZx8idZA0ZMLCw6ygeuXu6Fga+uR/OdTJrIvO0asEH4/flNYnuGnPl2jKswitoO7wOd9gfW51dwh9qcKlGhercSBdeYB+QQonoZgjw0vR5YpmOuzFHMepjZH2wX9IwtAlqGDRG32Oxb/KZsakMtW7md2E2liq/bWyk6FhvEtw9ZWOJN2VpUVDaC811Yi4c2bOVk7UhRHXAHejuo658hxHFZV4ACzD3PT4YxJDMddRN3O5POqCkbIimHcHm3tdYCcylKYh5hXpPMr0ZOlVH9L+E6SmK00ngwDxXBesJAkoLc8G2vOIx/AYaygtOqSg16W/Yg1jc/RSybyEC2hiXnRDpX7UX2YIIjF+nfnuhyxx/HdFhDfcetevuI9N5XgRDvQamK0SatvjD85Eadw3s/mLJS9sioqeNoDcaANG1edw1udg1GN45VLXzNWX1ky4Oi1KE/n1eX4JcqODG8b6P7rjBCv4ZinSO/mSocWuMyily8DqEbkW9oN7pt6RU6I0v6e1mYhDkekmaB2h/7cXcB4wzWz2W9zcJkR0QqHEDgjtKCn7TOcQb+EVf3B/gxNikAlDi5u/F3NtNiwriOQ7dzzLjmWAuIzmlcorW6fGtg+a9zJpME7ey3cCVSGLz6sTmUZ/piqwsRWiRRMujdYsx0QtotEQUkIaLCXTl1Wgi3UTJn7uiaIKnJS7wfLcYr44clGMTlr71O8p2bY8VXREwed07su3rbQY5Q+0rR8Ww9HnS6fTFp9Jr1boiCJ6hJuIKrlULmc5U8rveMvq6Qyep2ZrW5fkGu1muR0N/
 IWipNC5I
 ph7Ha
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When zswap writes an entry back, it allocates an order-0 swap cache folio,
decompresses into it, and issues the write. The folio is cold by
construction, yet today it is left on the LRU for page reclaim to find and
free later. That wastes a reclaim scan and keeps cold memory resident
longer than necessary.

Free the folio as soon as writeback completes instead:

  Patch 1 - synchronous-IO devices (zram, brd, pmem, ...) complete writeback
            in the calling context, so the folio is freed directly there.

  Patch 2 - asynchronous block devices and filesystem-backed swap complete
            writeback in IRQ/softirq context, where the folio cannot be
            freed (that needs the folio and swap cluster locks and may
            sleep). Allocate the folio off the LRU and defer the free to a
            workqueue, which folio_end_writeback() hands it off to.

Results
-------
Paired baseline vs series on async swap (NVMe, Patch 2 deferred path). Each
workload runs confined to a memory cgroup (memory.max) small enough to force
zswap shrinker writeback.

Kernel build (defconfig, make -j4; memory.max = 600M):

  metric            baseline       series      delta
  pgrotated           441028         2521     -99.4%
  pgsteal_direct     3524343      2869004     -18.6%
  pgscan_direct      8393791      7765008      -7.5%
  zswpwb              705129       699019      -0.9%
  build time (s)        1155         1114      -3.6%

Of the 699019 folios written back, 698990 (99.996%) were freed promptly on
writeback completion; only 28 fell back to reclaim.

MySQL/OLTP (sysbench, 10 tables x 1M rows, 512M buffer pool, 8 threads, 300s;
memory.max = 256M):

  metric            baseline       series      delta
  transactions/s      153.87       163.30      +6.1%
  p95 latency (ms)    157.42       145.82      -7.4%
  avg latency (ms)     52.09        49.05      -5.9%
  pgrotated           743738        22460     -97.0%
  pgsteal_direct     6886490      5445278     -20.9%
  pgscan_direct     13462510     10820730     -19.6%

Alexandre Ghiti (2):
  mm: zswap: free synchronous-IO writeback folios directly
  mm: zswap: deferred dropbehind free of writeback folios

 include/linux/zswap.h |  2 ++
 mm/filemap.c          | 20 +++++++++++++
 mm/swap.h             |  3 +-
 mm/swap_state.c       | 17 +++++++----
 mm/zswap.c            | 66 +++++++++++++++++++++++++++++++++++++++++--
 5 files changed, 98 insertions(+), 10 deletions(-)


base-commit: 626acb37cd445144f321f1b64cac9a93760fa716
-- 
2.53.0-Meta


