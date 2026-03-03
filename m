Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9294EC1421
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 11:54:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D6766B014E; Tue,  3 Mar 2026 06:54:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ADE86B0150; Tue,  3 Mar 2026 06:54:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AD216B0151; Tue,  3 Mar 2026 06:54:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0560D6B014E
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 06:54:05 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9EB951A0128
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:54:04 +0000 (UTC)
X-FDA: 84504593208.01.A6F4C92
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id BC3EB40007
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:54:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20230601.gappssmtp.com header.s=20230601 header.b="p/51pHDO"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772538842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VSbAaFhMKYH/6sDptBm4izzjlxKhysV1aVqA/IFmMak=;
	b=8kRVo70S7LIUvgRkisskZi4dP5hy3ZzTrnm3gVEyZ0v+6MZLtaj4ABQXGF0HlKE6LsJwxQ
	pB59yOD4YAQjjE2XP+h+iI4/O1hqgWWboX2MIUoJbdK83UjGDBS9ah1qDsH3IH8KAZMoWW
	V/KpZKARXku36zXjz6T+77QcQQq69HE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20230601.gappssmtp.com header.s=20230601 header.b="p/51pHDO";
	spf=none (imf12.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.128.46) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772538842; a=rsa-sha256;
	cv=none;
	b=Lt/R8dqgflKVOhr7EJkSr26B3Sl9UcLXP9wUKm6EFBwrowis5HTSs8m8i/ZE5KQT6UvYJC
	FvlBt4mfBwjGabVgptZ9XUUZFNC/l0dEG/gNVQEUXnKr/wI/Ty7atAYfE+b0GUg0Q+D2mU
	l+4e2toAr0efS2d93N23KRB78E1/Z+o=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-483bd7354efso73715235e9.2
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 03:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20230601.gappssmtp.com; s=20230601; t=1772538841; x=1773143641; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VSbAaFhMKYH/6sDptBm4izzjlxKhysV1aVqA/IFmMak=;
        b=p/51pHDOOg+/YVCIk4uaPMZYpjOkGuEd3eVrHd+rX8SKbeV3nSjAcPjAZtVv+nxjNn
         IccnXh34OI6i33ybdm6EdcaYNrKhmy4oYtzq86BoK0QNoceKzbFwvZ6fztw4ep7EjP+y
         uSC1wXz+dT6fA1+Hjb+gIad4gE9wIJur/y0mbYXv6N9X2VY9NxllO9m1vGrr9lUqiovw
         yy50ISM4EgvIGqJjIT/VNSp1YKXD+eK6I40LDbkEFOO537KkmXUfiKa4hMUcYUlGP85N
         ft6N/9CqvrhSQUuyBWwJmBzQi7Xg+8Tr/qo7W3lyrfJvqVo4s9s+1vQOlG3vsLHADYoJ
         W85g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772538841; x=1773143641;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VSbAaFhMKYH/6sDptBm4izzjlxKhysV1aVqA/IFmMak=;
        b=hwZm64sNB6Dhd44f4zRASMHbw8gg6QDJ9QAcZVaYrM8OIDoOtOt6pjXOKJABLPpNJW
         NKek9oxfPELVFght3cV/UrCdWj94Gltm0RkhWBmMfHRdsVuHUv7OPMbBUDNzk5j3wXHZ
         bQmIbQuClf6yYlkkGyUVSqK4uas01JxF/YYcm/oqqLgbT8D1l0XA+/qHJG+j0plNBL7e
         zHX7w5Xd1Y8fYW+G0p1Zpf0J7+yMp7hTfzYtZ9pCe4flcRW0q06qF95ZarWa9hIIBiUe
         bLyxWTuNjifx7a7llwr1QnAkEvHrKmnz4ya/8MFpbYgJ+P+xZF23ZoHmziAu5JwMIy0O
         +3YA==
X-Forwarded-Encrypted: i=1; AJvYcCVW/gP/fRSRIzYaJzG8Fii6CZxOYArR3jZ2OpIkGbp4Rm71zEEmLBaMs2e1Sd0dZGX4kv5QKzAQkg==@kvack.org
X-Gm-Message-State: AOJu0YwC5n4urD1uTEoNPX6ulG/BhnerNeWOvrPbYDPVBCIPQ8hjivVd
	P8hsrzUL5e+iBMQoxeKqXliWokQaNPZFxXu0IYUdts/tQhlXIidr4IF08qgRINhtD/o=
X-Gm-Gg: ATEYQzyhaws7WNgujwC33/XqHsXFyZkISnFenn9s1cTd1xVLqpt9EcLsgF2yj1s2yP7
	+GUphILq/Y2o5RTpDS2ZJYcHLRf8bAQbHRil5N4IF2QNuMcYzFzTpO1M+uEJ3zsqp7mstbO40Pz
	Gj6zfzFODVeMyJ2AUyBbN+Y6LdDmWYLEiZZPltRd4UfrDLilWDwQJLsrGSZFoztD1hpKRqWw8j7
	m/kencKwDCvMe5klbG8pZpib5uzx/tk7YYib08wP01Hrck5f23Qw8t0j+7GmjnvaqoUxa1kV9Ur
	5UeAUyuTywVW/GOWNJ0AP3qSFI7tbx0yB5YBEk11ypwntf+qZw4O+Byk0Yi72sE7VzupPfwXIfV
	NuYKsQkHgqxUnFHfRW15Ku8DQJvflJB6slKRoLrSbG3W9iuHNfYHnUarn6JkTR2CRMwHj/6zgw+
	lDbsGuIGAi+edlZBF9fFpZUws=
X-Received: by 2002:a05:600c:a4b:b0:483:71f7:2797 with SMTP id 5b1f17b1804b1-483c9ba3785mr295878295e9.14.1772538840803;
        Tue, 03 Mar 2026 03:54:00 -0800 (PST)
Received: from matt-Precision-5490.. ([2a09:bac1:2880:f0::15:430])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439b3cc2e65sm18598717f8f.2.2026.03.03.03.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 03:54:00 -0800 (PST)
From: Matt Fleming <matt@readmodwrite.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@cloudflare.com,
	Matt Fleming <mfleming@cloudflare.com>
Subject: [RFC PATCH 0/1] mm: Reduce direct reclaim stalls with RAM-backed swap
Date: Tue,  3 Mar 2026 11:53:57 +0000
Message-ID: <20260303115358.1323188-1-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BC3EB40007
X-Stat-Signature: oj8ro43sssksh9dj6t5z7qkqyrpjbszk
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772538842-235351
X-HE-Meta: U2FsdGVkX18s9aS65inN0dymph2JOeRp4w9M2D0ZRla6evQtZpdGp3khKaP5whpAjTdS7JzLLODkeQk2TxzOYYXsFx7HKofNUXNrM1tZ2rQkBTKsLgWj+zGEhDzTQ0RGLqlQu4wvJcm8UFsyrwn2vvjb3O8Q2FVJKIaM4TyaYVCt7ejTTc7A//3rWtYRSO02DK3jcCv4q1pwu4za4k9HzbBEpyA9D9KTkpk5ok4U4Icl68ezfV6h+u9iAdMyIYlsZpNpWbAyZfpbMsDKj0wBi9sDafTMkxoPFhKcpfVl7OsCmzNpFTUee5lNHVTNBTj+Tj+k6xSSQEsmtszbSiXSR6OjZKNzx/ZLSb0YBZ3AmRbHGbhQCeaCHsD00UXPlQGBgmlyaM5F3NGunu/Ppqjl6nwTV96v+wIHtXmHR8kvpRZ847xI3eGROeD0EuX101f9mPlj6YCH8UV5Kv7OC+QXTfw8iuF2X8D1WHWz1nIylFyXe08oymtQGolCxCfyHdFe9Arx9ntvGkDvHLnA/HBN84mkjV+T39O5UaSQd6fpcxlxfAYMKDRHoQLUswEmWrFrs+Ndoxs2ILnzKXFNGifjcQQtEgn2ZbNqE+bC0KsTQts1X4crCdwnoTeLOExP3cGTFz0ZNsRHXTj87BrM6actPNtEo6Ru1WeKqpkLaOYrwqIIZ3PPK/j3e6jE0VnI69FhXrE50CXPE3ysGS/Nae4Cva5zmlzJxojcEc3klS+ZrWAOMMuWfDbYlVdNrJOFfun8ZBCtbpZZ0pByxEJF6vSdpzsW/tGLkkyTh2XHhcD65bSSgs+2PM4yMZkJXReAxzmzqBK+oC5r5YtnjkNUeMCNU9TkGLK/BKXGiIieqvSjC1B7CoWH3/SkB51Zv9uJmNjsZEEAG1ha6NK/to9/rdoxYkPy9e5U/efpxhThLkziN8kh55XC+vU/RWjnwFxW2/CKhU0T5R01Z+hf+UZEDak
 jTuffbrv
 u7R9W17hszWt9UK+BU9Kgxufmn81emQh4mjUSY9t+iiqZhv79dRHjdp6O3mDmoNU3AKZQr7vJn+l3et/wiHIeHnPaQNAQAOkM7PYuhYVgNP4rQ7GmL9oXrvpLigGQQ8J5hcSLrIDLbVa9O0YfxrOYeflOWx3w8oQjlseWTPMmEo/zkmkjRmUp5sSL6jMPxae9TTUWoOuSY9Dc9K8JWF8QlxGbADSq+l2U49TMR454n3PNIlWaGGw4qKDUvDNVzSK+JEATh8p/BCMJz4q34bkGMLC50BjAVDSHZJ5h3MJvpCyNVI7t371zcj4vspexQMetX+sb2iS2VTp/XrPTBGIPJ6HK2lk802bX/D3B8cKJzHLyMky5aHzVyOhTZ5Wf442S/ALbBOJv1mOLGVqFg6QAQUzeZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Matt Fleming <mfleming@cloudflare.com>

Hi,

Systems with zram-only swap can spin in direct reclaim for 20-30
minutes without ever invoking the OOM killer. We've hit this repeatedly
in production on machines with 377 GiB RAM and a 377 GiB zram device.

The problem
-----------

should_reclaim_retry() calls zone_reclaimable_pages() to estimate how
much memory is still reclaimable. That estimate includes anonymous
pages, on the assumption that swapping them out frees physical pages.

With disk-backed swap, that's true -- writing a page to disk frees a
page of RAM, and SwapFree accurately reflects how many more pages can
be written. With zram, the free slot count is inaccurate. A 377 GiB
zram device with 10% used reports ~340 GiB of free swap slots, but
filling those slots requires physical RAM that the system doesn't have
-- that's why it's in direct reclaim in the first place.

The reclaimable estimate is off by orders of magnitude.

The fix
-------

This patch introduces two new flags: BLK_FEAT_RAM_BACKED at the block
layer (set by zram and brd) and SWP_RAM_BACKED at the swap layer. When
all active swap devices are RAM-backed, should_reclaim_retry() excludes
anonymous pages from the reclaimable estimate and counts only
file-backed pages. Once file pages are exhausted the watermark check
fails and the kernel falls through to OOM.

Opting to OOM kill something over spinning in direct reclaim optimises
for Mean Time To Recovery (MTTR) and prevents "brownout" situations
where performance is degraded for prolonged periods (we've seen 20-30
minutes degraded system performance).

Design choices and known limitations
-------------------------------------

Why not fix zone_reclaimable_pages() globally?

  Other callers (e.g. balance_pgdat() in kswapd) use the anon-inclusive
  count for different purposes. Changing it globally risks breaking
  kswapd's reclaim decisions in ways that are hard to test. Limiting
  the change to should_reclaim_retry() keeps the blast radius small and
  squarely in the direct reclaim path.

What about mixed swap configurations (zram + disk)?

  When at least one disk-backed swap device is active,
  swap_all_ram_backed is false and the current behaviour is preserved.
  Per-device reclaimable accounting is possible but it's a much larger
  change, and mixed zram+disk configurations are uncommon in practice
  AFAIK.

Can we make zram free space accounting more accurate?

  This is possible but probably the most complicated solution. Swap
  device drivers could provide a callback which RAM-backed drivers
  would use to estimate how much physical memory they could store given
  some average compression ratio (either historic or projected given a
  list of anon pages to swap) and the amount of free physical memory.
  Plus, this wouldn't be constant and would change on every invocation
  of the callback inline with the current compression ratio and the
  amount of free memory.

Build-testing
-------------

Built with defconfig, allnoconfig, allmodconfig, and multiple
randconfig iterations on x86_64 / 7.0-rc2.

Matt Fleming (1):
  mm: Reduce direct reclaim stalls with RAM-backed swap

 drivers/block/brd.c           |  3 ++-
 drivers/block/zram/zram_drv.c |  3 ++-
 include/linux/blkdev.h        |  8 ++++++
 include/linux/swap.h          |  9 +++++++
 mm/page_alloc.c               | 23 ++++++++++++++++-
 mm/swapfile.c                 | 47 ++++++++++++++++++++++++++++++++++-
 6 files changed, 89 insertions(+), 4 deletions(-)

-- 
2.43.0

