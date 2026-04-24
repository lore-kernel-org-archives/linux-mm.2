Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA9B6FED3D8
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 15:00:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FDB16B008A; Fri, 24 Apr 2026 11:00:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 486AA6B008C; Fri, 24 Apr 2026 11:00:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34F286B0092; Fri, 24 Apr 2026 11:00:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 237C86B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:00:44 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 54FB787CAF
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:00:42 +0000 (UTC)
X-FDA: 84693761124.29.4694D12
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf23.hostedemail.com (Postfix) with ESMTP id 00B86140028
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:00:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20251104.gappssmtp.com header.s=20251104 header.b=tabZ1zpu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777042840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NVkm9NCoar5rTC7NMjwEsGBOw7MHNVq1Zpnh4oi0V7Q=;
	b=6mspjgyNdPEwigGvhpnf9kw2F0Jswo5T3YdNp6nqluI9qF4Tm/5QbCBvpvXl3SCoaHgY1q
	BQLEZlD88Iv+LIdmEDHc0FNor4db6T0+CXEIFRVWwLG0HrEOlLf0lPsxRoHbpsyGNDLpMI
	h+LoUruMV5vraJn6feJ8/oyHhRzc/RU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20251104.gappssmtp.com header.s=20251104 header.b=tabZ1zpu;
	spf=none (imf23.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.218.53) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777042840; a=rsa-sha256;
	cv=none;
	b=mofA5O2GxqhAyYI9n+7nzaEfhHa2AjFK45UjHWasbeMX8iQv75nkysAm5oEjYZjBMxTdUu
	hndSGe1himplpW79JkRz9x3CvyzuY1NGq2G3bxAKVeuBZp2OqrVz96xBt+/ikvWWL4J5Sx
	AVPd5dbxCyLswbgeBlfM+jn1akQyLSQ=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b9d9971d059so1164830766b.2
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20251104.gappssmtp.com; s=20251104; t=1777042838; x=1777647638; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NVkm9NCoar5rTC7NMjwEsGBOw7MHNVq1Zpnh4oi0V7Q=;
        b=tabZ1zpuDMkkmn9zTRMnL4P1Qh18QTxz5UKhW+22rqYqn9fUu36wW4zB/TC16sX+xn
         zLayHI6UhE3I8umhHdDZ6I1SfO2JK61GWUoSqoiaPrBg2Z8UIqZKaL8oY5ZIEt0tb3R/
         BR/kKthoNEQD+ce+eYbbo7sXsoDqOKjCLPIgemZxSyPGAJqtI/7ifXwCOQii75pS8AJX
         RX1LzL1yIb+1gFDyqlYyU49NDwdW4h3mV3s9OKXVyZOqCszeaxHEDsL1o2eiU9LY4t4B
         O1i1OQ1UAdNaKUT3KjxRW5oFxofHz4sRiKZUqsLWKTMZWUrhIFqqJpAMD84l6TqYRz4g
         viWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777042838; x=1777647638;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NVkm9NCoar5rTC7NMjwEsGBOw7MHNVq1Zpnh4oi0V7Q=;
        b=is4E7VIj3uBq+CmQD2rptkPvBM9JU00yOw6NrpRpO9tUKXgZhWXeYTibgsAEODlVWv
         /J+mpqSmzmisyTMxCBPQz25g3yQR9dDfR/+Yq0ISQsVz6ezm29byq3ZKOBKmdE0MSVNC
         dlNOa0bCNYctL1fx0ZOlLWk7Deqg3GX6eefiHA5g39QJrL9zwabX1wEWzZzxU3Dhgeqy
         eMUJmMmD3iikTDsJa3QA1WKeGpDMyrk72j6E0xaBCO5N74LV8PZb5v0t6qN5T4RJDZh3
         rbiLcjnnHr2OofAsPA1TZJznS//RcxNxFje4kNCEo7d3CNhq+X8fARACm9OMduaoLUal
         7VbA==
X-Forwarded-Encrypted: i=1; AFNElJ9TiqppTEYsCFvau8QkycIgCxOL0D4ZFGaU+uBjR0AnpdTjD5/1KfY8QTBNIQ6t+iwDStOUBRd/2A==@kvack.org
X-Gm-Message-State: AOJu0YxHaQfzeVLOc+xlC1OeQWdN3V1nqhdw7mA3Tdh9hrbu2dgK5csC
	beASZUL51FDMYHXG7ZXJ48xDWqjndG1uUEFmTfD1QSBG5jf7I4cKMwo2eWlTbDb2kBg=
X-Gm-Gg: AeBDievQax4hWgnnJhlyQHJdYQx/mVAlF29BzHXujTvXaCqxUX80f1GRzzs2ppczTcf
	/RHCwEfi+wuDA8IzRl59UOeXMxtOe6S7mxrkVCneV0sZzoKKUmKyBuI4LPefAaVqH9yRMt/UYwa
	5RDRA4ZzuBooF/OXbqJfIFT9AlQCrX0Qet9KYBcMwEKXocclcU0A8b8akYY8ouUc39PAe2PnsVC
	rLtnoPhF1Zx10QeGigo0Vmf2j1VkmXnwVsqAgpY+Oo+LRzrbf0RGa/dVLntVXOxgcWd0+PqMF2l
	3TQzBH7mPnxQPlIevCunRzzVcboHx7jsfUTI3gTHwHBz6oKjRPPo/DqYITk7Teh/ZgSqfDCjkCV
	+hHwytsbLm2uONQxp2XBA4qGivj+oL8AFY01F3e23WUZ6+hRNfankV58HEPLQUPXNnit4W73hrQ
	JBKSyTCm04qyDRIU5Juej0
X-Received: by 2002:a17:907:a0d6:b0:b98:595c:a76f with SMTP id a640c23a62f3a-ba418888cfdmr1573048866b.16.1777042837571;
        Fri, 24 Apr 2026 08:00:37 -0700 (PDT)
Received: from localhost ([2a09:bac6:37a8:1f19::319:ba])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ba4517ef3d4sm779041766b.17.2026.04.24.08.00.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 08:00:36 -0700 (PDT)
Date: Fri, 24 Apr 2026 16:00:35 +0100
From: Matt Fleming <matt@readmodwrite.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Barry Song <baohua@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, 
	Jens Axboe <axboe@kernel.dk>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Minchan Kim <minchan@kernel.org>, kernel-team@cloudflare.com, 
	Matt Fleming <mfleming@cloudflare.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Require LRU reclaim progress before retrying direct
 reclaim
Message-ID: <aetr2ju-8st9j4ir@matt-Precision-5490>
References: <20260410101550.2930139-1-matt@readmodwrite.com>
 <CAGsJ_4x96rrt+T5efMEPR1YmhTY_Ce2S4mZwN3sqB3Hx01=URA@mail.gmail.com>
 <aeFa7uIML6NmS6T0@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeFa7uIML6NmS6T0@linux.dev>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 00B86140028
X-Stat-Signature: ydxyq64ghppmfgsimecxukoykk73rufc
X-Rspam-User: 
X-HE-Tag: 1777042839-849852
X-HE-Meta: U2FsdGVkX1+jFYxPqjrLWMAYBmmF1m2kTsMoETQkbUsPBln/wp58A/kZ2Vkpi3jWnhPs/jgvGomwzS53iOw3wZJaEJxXDT47tQUYN3FbW1JQ9v3JVY0lAJjptobwtdctahK72UdbHo3tbPWlMhHmI1LhwMMkX0z5ZkOw8w9TJI2Iku9MKAuI7cuRjvR21XNTUqu2U0UCniNqpsFXqQfxkKBuB1HolQT4zJrpEJnHDZmHfHiazzhA7mISx12mD/2RgBsJWaapXqBDmV6ns76RhAevFbORx8M/Qim1LzXIi4HNvuVt0E0zHZ5b3137ZhM20FwPd952Or0vgnxMCaxGN2cxJsRDRLWNFutFhHym2zW0/A5xU51uxKLhKCwoyZxGbcRJrBEbUEnJSeLDFiuDhd4pjL4PfLU2Iy82S8I9Mk8htpYH3x4A3jsRBdHnzUHsqZkNk74P12CEEmY7T4IHv1BJEHZlUyHftAofSsFFI46bWwlokxy9drDFZZ76FGUBL8se/O/XgD/5q6jxXuiLcyqyh9VZIOMlCHEH/ulHN3neNiH4OnaThFRkBJ5hnLCnawH7xgTUC/iY4v7qGXUz+/lIllkO3hLOcLVAnKkGLGrZQOO/Y85RmFGHHZkFPEvDqI6FCc0jD33HJWNGshZrjA5sRXAbNEGwnTRQUX28aMWNBZjcKyA/fpzv8weMbA7RVIlyLcRtPDjjddNUSeEsl+n5CimiwuTmwza/vACinCkU6loErk5PjUv3K6/CpXUo5MSd++beFYIrQCUv6x7XV8TsHQwHuueI1M+Zjao8TXMjgza+MbqGMzZ+aazUScDpH4O/E2S8/lo5hIxw0u1ate4GCwQOihZDqBMSPfSEjXsBQjVxvnhbFCd52AZPvu2O0A0DkhhON0z27rinb+P4wHBjTsZks4CULRWMjvtXqc3uywxqfqFCfrLQOrcmI0/WiD0P/tFbrRfP3QkeapV
 eIhEis5x
 7UQkkoGbaYxvoWyA6LnZOcRLFseawVBGfy86y5VQkAx+VkE0HsUbJhto/FmN4fpQDmx7G7TvXrJssP6klBtnJF/PLw+BuiDcIytcHbRUrQyLfYuXZ49a569IlsSS9cL4p6h/kJ09M3XH3wokJmravuE8/2qxvBs3yEjvieCvGXXmjxJ7PeVEldv76XtfkvFZKCurTTFomti/aZ1hIKtxgJjFRsIZpx+dMOMZsB2b4zh3Bgg5NDg2vRvLPnfYECXjhYXN83TBthb4eDG3EsOSckuKzIklmNEilWh+8XPcJqb4caSS0hcQ82yFPz2UwPbx/bBx/bXVqtRHTNnZx8BxVtWOXYw76pLIWN4FTp24dvTu7qr10bKFBNMpA2UPz+XISqb02DXX0XoLE+JTNGqqYYYJyJuZ10OlPV/FSgY5SAWOMxFLhHkAZ4cpLbTH9COMCUNFA/hlsoWs5LC27M7Zjsg1qy6ScDQS1GrQACVhb9MSLpQ/gQf3Q8XVERrpKaGvR7tljS+vz8oET9w37byxbaQEaN5HbOOdx2evc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 02:58:30PM -0700, Shakeel Butt wrote:
> On Thu, Apr 16, 2026 at 09:44:55AM +0800, Barry Song wrote:
> > 
> > I am still struggling to understand when zram-backed
> > reclamation cannot make progress. Is it because zram is
> > full, or because folio_alloc_swap() fails?
> > 
> > Or does zs_malloc() fail, causing pageout() to fail?
> > Even incompressible pages are still written as
> > ZRAM_HUGE pages and reclaimed successfully.
> 
> We should have counters for these, right?
 
Let me try and provide some more data for this. It's hard to replicate
on our production systems so I've resorted to creating a minimal Qemu
repro that has 1GiB RAM and zram disk = 1GiB. The workload is a simple
anon memory mapper that allocs 900MiB of memory and touches all pages
for 60s.

zs_malloc
---------
None of the zs_malloc() calls failed and we made ~1.2M of them during
the test. Here's a breakdown of allocation sizes:

@hist_zs_malloc_size: 
[32, 64)         4831015 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
[64, 128)            409 |                                                    |
[128, 256)          1090 |                                                    |
[256, 512)          2334 |                                                    |
[512, 1K)           5069 |                                                    |
[1K, 2K)           11174 |                                                    |
[2K, 4K)            2395 |                                                    |
[4K, 8K)             237 |                                                    |

During direct reclaim only:
@hist_zs_malloc_size_in_dr: 
[32, 64)         1268042 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
[64, 128)             52 |                                                    |
[128, 256)           149 |                                                    |
[256, 512)           292 |                                                    |
[512, 1K)           1234 |                                                    |
[1K, 2K)            3539 |                                                    |
[2K, 4K)            1156 |                                                    |
[4K, 8K)             135 |                                                    |


/sys/block/zram0/mm_stat
--------------------------
before: 4096       74    12288        0    12288        0        0        0        0
after:  42622976  9412667 10985472        0 34131968        0     1962        0      237


trace_mm_vmscan_lru_shrink_inactive
-----------------------------------
Anon LRU shrink events:                 397,949
  sum(args->nr_scanned):                11,837,216
  sum(args->nr_reclaimed):              4,871,775
  sum(args->nr_dirty):                  0
  sum(args->nr_writeback):              0
  sum(args->nr_congested):              0
  sum(args->nr_immediate):              0
  sum(args->nr_ref_keep):               5,200,896
  sum(args->nr_unmap_fail):             0

File LRU shrink events:                 2,632
  sum(args->nr_scanned):                26,048
  sum(args->nr_reclaimed):              12,681
  sum(args->nr_dirty):                  0
  sum(args->nr_writeback):              0
  sum(args->nr_congested):              0
  sum(args->nr_immediate):              0
  sum(args->nr_ref_keep):               476
  sum(args->nr_unmap_fail):             0


> > I would rather detect what causes the lack of progress
> > and implement a better fallback.
> 
> This is a good question. I think we have appropriate counters in /proc/vmstat
> for cases where pages keep getting recycled in the LRUs instead of reclaim.

Here's the output of /proc/vmstat before and after the test runs.

nr_free_pages                             210,825 ->       206,742  (delta=-4,083)
nr_free_pages_blocks                      209,920 ->        65,536  (delta=-144,384)
nr_zone_inactive_anon                       1,685 ->           136  (delta=-1,549)
nr_zone_active_anon                            15 ->         3,774  (delta=3,759)
nr_zone_inactive_file                         329 ->           591  (delta=262)
nr_zone_active_file                           673 ->           504  (delta=-169)
nr_zspages                                      3 ->         2,716  (delta=2,713)
nr_inactive_anon                            1,685 ->           136  (delta=-1,549)
nr_active_anon                                 15 ->         3,774  (delta=3,759)
nr_inactive_file                              329 ->           591  (delta=262)
nr_active_file                                673 ->           504  (delta=-169)
nr_slab_reclaimable                         1,352 ->         2,037  (delta=685)
nr_slab_unreclaimable                       9,581 ->        11,689  (delta=2,108)
nr_anon_pages                               1,526 ->           262  (delta=-1,264)
nr_mapped                                     912 ->           442  (delta=-470)
nr_file_pages                               1,132 ->         4,760  (delta=3,628)
nr_shmem                                      162 ->         3,608  (delta=3,446)
nr_swapcached                                   0 ->            19  (delta=19)
nr_vmscan_write                                 0 ->     4,872,846  (delta=4,872,846)
nr_written                                      1 ->     4,853,727  (delta=4,853,726)

pgpgin                                      1,200 ->    19,035,312  (delta=19,034,112)
pgpgout                                         4 ->    19,414,908  (delta=19,414,904)
pswpin                                          0 ->     4,758,528  (delta=4,758,528)
pswpout                                         0 ->     4,853,726  (delta=4,853,726)

pgalloc_dma                                    32 ->        84,262  (delta=84,230)
pgalloc_dma32                              45,989 ->     5,095,307  (delta=5,049,318)
pgfree                                    269,896 ->     5,415,629  (delta=5,145,733)
pgactivate                                  2,820 ->        14,490  (delta=11,670)
pgdeactivate                                   10 ->        10,924  (delta=10,914)
pgfault                                    29,321 ->     5,088,427  (delta=5,059,106)
pgmajfault                                  3,750 ->     4,794,781  (delta=4,791,031)
pgrefill                                        0 ->        13,733  (delta=13,733)
pgreuse                                     3,333 ->         5,852  (delta=2,519)

pgsteal_kswapd                                  0 ->     3,605,552  (delta=3,605,552)
pgsteal_direct                                  0 ->     1,280,091  (delta=1,280,091)
pgscan_kswapd                                   0 ->     6,579,240  (delta=6,579,240)
pgscan_direct                                   0 ->     5,290,778  (delta=5,290,778)
pgscan_anon                                     0 ->    11,843,970  (delta=11,843,970)
pgscan_file                                     0 ->        26,048  (delta=26,048)
pgsteal_anon                                    0 ->     4,872,962  (delta=4,872,962)
pgsteal_file                                    0 ->        12,681  (delta=12,681)

allocstall_normal                               0 ->           110  (delta=110)
allocstall_movable                              0 ->        32,088  (delta=32,088)
oom_kill                                        0 ->             0  (delta=0)

workingset_nodes                                0 ->           302  (delta=302)
workingset_refault_anon                         0 ->     4,777,591  (delta=4,777,591)
workingset_refault_file                         0 ->           870  (delta=870)
workingset_activate_anon                        0 ->           487  (delta=487)

kswapd_low_wmark_hit_quickly                    0 ->            35  (delta=35)
kswapd_high_wmark_hit_quickly                   0 ->            99  (delta=99)
pageoutrun                                      0 ->           135  (delta=135)

pgmigrate_success                               0 ->        21,317  (delta=21,317)
compact_migrate_scanned                         0 ->        98,848  (delta=98,848)
compact_free_scanned                            0 ->       136,667  (delta=136,667)

swpin_zero                                      0 ->        19,069  (delta=19,069)
swpout_zero                                     0 ->        19,120  (delta=19,120)
swap_ra                                         0 ->            63  (delta=63)
swap_ra_hit                                     0 ->            26  (delta=26)

Happy to do any other tests or pull any other data for you to help.

Thanks,
Matt

