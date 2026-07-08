Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50550C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 11:37:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 494816B00A4; Wed,  8 Jul 2026 07:37:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46C386B00A5; Wed,  8 Jul 2026 07:37:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35B366B00A6; Wed,  8 Jul 2026 07:37:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 115436B00A4
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:37:16 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AB41A1692CB
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:37:15 +0000 (UTC)
X-FDA: 84965408430.09.ED0109F
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id D41BF20005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:37:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cnxdHB22;
	spf=pass (imf13.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783510633;
	b=OEsv3p9UTDXkPnOijU8J3YDnLm2myml5xE3AKwoo/80pzsszHUjYer8XWQxCFGgYONp/FJ
	SrLR9Nu8EiqYNwVInBOiafSKQzKtdX827Wuf6ncT4oYVPHiEiMkfHWKFzkUeDue/eMePnD
	/szT3lH9sdQhfqtosvqjv9NS2zCEt+U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cnxdHB22;
	spf=pass (imf13.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783510633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Woy9F6ZqYKjUSWB5HkEf/ya/mNEoU0v6GtNR1Tp6mKc=;
	b=AQD793NQuNODYlcJnT9HKlznrqW+9aPQ9RuQSh5NSB6vrKt9SAWwpNAVguJdDfbUKI4Wby
	uZiJGeCsQ3yIqM+YkQI18DpdloiP3l3xXsPj2r7dLqPL1oE1mCMAtSESv3pTXOC67ZTDri
	rWQ28/q20d3DRQBM9iiDApwQunk9APU=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-c9e607d81fcso308445a12.2
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 04:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783510633; x=1784115433; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Woy9F6ZqYKjUSWB5HkEf/ya/mNEoU0v6GtNR1Tp6mKc=;
        b=cnxdHB22DFE0seQ4BR0EdhXDiya9R/83GELEgv1A8hER7mMjaLwT/d3wB4d1DI+FDg
         tRf+RsEG+9cKCZB7hTdptYf5+dbOBKs3H5l4nfGamD4SMXDlMXc0HKia82er8zoLfqO2
         fLK5N4tHaUo1jKEGZr3fjdZn1Xj2uSKohu6NVjIf+Nwv4hGQEqzfKAJ9vBTuBPLwEtwn
         /8tfc+cbmWaOWnUruVsxV2yyqSrWD7g5jNTP/YddLKTa+GEQckoNW7khfu47OGKTJsOy
         DH95OjCOJ54iL8gTVoQjQa9uwLDUl7oeUPajpy13npJcQgmQ8osoBmX90wQ7kexjgJJ3
         +yOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783510633; x=1784115433;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Woy9F6ZqYKjUSWB5HkEf/ya/mNEoU0v6GtNR1Tp6mKc=;
        b=XDu4Z5MmBX8JLT8+GHwu1M1+g3HFIoph8285wxXuccTEVBc+aTyTSXQvdrDjyCb9Wd
         AsGxIV18hEPgyYuu4TzKAvv/tFQQsprfEWWYxdvV9gagx7IM9m8K07mKszZyNAftJULj
         XJ5ewXyXV20CA2Xi/r6ElSx/f7WLNE9VIPkIhzbXN8YjQpsdriDC/DIwwzXF7DYRjhcN
         +edkR2WNgJnbuACC5cVqMY1ILkymTjA3BzPcGIelbsLfNxvS0xvKzf3DdFxCEqXp7AUs
         cgepJm9N/d+2kP33+dTvWCB+lG+psF2rvex7/CfTLzH8TEl0RF9jQYWk6aGEFepag5Ly
         trAg==
X-Gm-Message-State: AOJu0YyCGponKYA/002DTOOPI4o5cQWvRckQ8o0uxLshv8amTTJp0em9
	Il+qUDt611yx4FfuXyEErWLo5ZDzzfKXPexbXNQYzrU+I2jZMFDxTuQB
X-Gm-Gg: AfdE7ckqsYL24ioaFwBiBrkOaho1gXVe/IdNPuMu7zeyitn0OGCydQphspa71582KFV
	L2UdhIZWlOe3CLzwYJVmywaxBYV4doKdRmdB9Gy4KDtG+eT0c9VzE0+AcIa2aII4+Nxw17aWjfO
	NwKKH+0Qft5ZOqsd5sPdBK7qJeW3NWdcEd8NphZwfe2taINyGDp7UszTcYAurXLCM5k8ZpJJ9nR
	g27+mT7KYuG4FxLZCm1Nhz0V3eMz9HsE7ZArHGQTnLNu2YXpbJGRJs1QwIyjlFYc0Teo36BfbVq
	HuhScKCbJE5UukQQX/htjWNMfMBlglp4SIl1s6kklIqDSycAH0602RvmI/zSvn7smp7Og5kSreu
	DqzAizlHmhe4F4pdAfqvHIjw/rCnPwPgEtVS2dyea384k4w5pRS6csM0r6y+ZQDNgLVeLnrJZTa
	x0zrHjSBrlp06gy3C0Ts7xHuzXqyd8nP+x+uRPOqFxZqqUuzG3E8rnMFuCb/o=
X-Received: by 2002:a05:6a20:430e:b0:3bf:d1f9:b1dd with SMTP id adf61e73a8af0-3c0bcb803demr2704343637.44.1783510632562;
        Wed, 08 Jul 2026 04:37:12 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([203.18.50.8])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5b3a2e42bsm2260788a12.30.2026.07.08.04.37.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 04:37:11 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Subject: [PATCH v9 0/3] mm: clean up folio LRU and swap declarations
Date: Wed, 08 Jul 2026 19:35:42 +0800
Message-Id: <20260708-ch-swap-series-plus-folio-lru-cleanup-v9-0-2bc72b4f8730@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAA42TmoC/5XQy07DMBCF4VepvMbIHt/GrHgPxMK3NJbSJIpJA
 FV5d9yyaBQ2YXlG8vdLvpKSppwKeTldyZSWXPLQ12GfTiS0rj8nmmPdBBhopgSnoaXl04309x0
 du7nQZujyQLtppqFLrp9HGq1BHlAIiIFUa5xSk7/unbf3uttcPobp+55d4Hb9b2EByij31kkXQ
 CkvX88Xl7vnMFzIrbCIh6oZHFVFVZX3XmnTYLB2r8qtKo6qsqohMeA2ccbiH1VtVMGOqqqqUoN
 x3mGKPO1V/VANO/yvuqpRNlqi1UIg7FWzVdVR1VTVMcCEXjVBxL2KWxWPqljVhFwjB23R4VZd1
 /UHiOeFzd4CAAA=
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jianyue Wu <wujianyue000@gmail.com>, 
 Matthew Wilcox <willy@infradead.org>, Baoquan He <baoquan.he@linux.dev>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1783510625; l=4505;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=8GHogSKoIm1asFwelYhr6ck8UTLDFmUYAeHRfPd9GmQ=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QH1GLVTow/u+GY2BnotLjKLsI0uclIkvi5tbMa/r7iWNgQtdhlbghg2vvw6Rx/C8IeR90NalapO
 BXH5jKoHnOQo=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D41BF20005
X-Stat-Signature: s3rgatyfi6kgd5ez8h3wc5a7deo9tpg5
X-HE-Tag: 1783510633-568940
X-HE-Meta: U2FsdGVkX1/kasBlRFkpxIH4CLK5eYdysTIrlLwSetvWDFzCJAoUfzeeBKDE7pPP2t/A1Y8xs8Sq9E5yW5R2SQuUruNUu7+LD6ic25vB5MrGWxrYmt71cyWMMz0H+6KU3+p/xD/Qo/rXmP8QK0XLoxbbwSoXyM/XP75MkUB+udRfNgMOiJXrA1uwPu0QPfyyQUWO9QJPucgQGo7MzSKeonQU9BwbalmR53iW73xJ15NXdzx/oSIwS5RBAd99gHH/y/BhX61lzlWfTnPffM+wLnTVQou9ffhdBJSRY2gYyKIIA8vmD0TY58tT009lfXKZiU75b8tm2tEAPfP+JDH0IHPh4GeoWBaNhxU/bc/L7chb23ihA6o6LJ1ez54l+UiK6n2Jop8Lldk/p+KvUtDVT3uCgUAEYExnaHlHy7yYjCpo4C6HQ77MzpVdKy7KxQIdsJvVvSYGd+n5tBsuDPkruL2Bp8OjiCHZbT89BBd/vO3W/To1NS+XCgpXICRz13d/Btp80XWGPEnw1eZFLxmoC/fa5fueJe0ekf2j+rgx6Jdml5y6W20ueqrvVZYBAYAHG/N0T0aavrmJlhtDoPzAbcspitZIk5vulRiIfaNk1+F5cKCq/PJHLLpXgzqN3G+K6Abqby9BMHVqFxB4e8Tkut/wKzxW7RiN/Wl5B2WsNzUSo0UH91u5ABqgJf9lnbtACJxZ7Bm+c6FFpPtY9obpj9z6GgnqtcSNgKsJI5/hEy42EtPNBSOLTp4VfdRhEQuueMgvh/nLFwZ41pSyMQtB9MxXvfkiTpJWlGt0xU3vAZENBz4XOES1Z6+AvXyKpHB3fYsCx2zUvKsORUQOZbJM8z36COBd0uyXHvpw9EPRieJFmiImXe6sQ/B5Dv1eLn3b4FHTy32blUODQdTm5ErlNwdK12AZbQoSloWXvt8lbHowNlPbeplrAKA7gZ9E01HHist4vguf6tW4W5FtLWd
 acjCXnQ5
 ILwqfY7LAgPjtjgWXXHKzvr8cwtRo2UhJYoDvNJJvDz0B2CxoP0xkESiHfQImil+7+O0XmpsJ2ViSCkqMI1guw9lJA2pK7vGdN51IA+fPbTupAs8qAVpvIa+ab8tYCabh2ya+URWtpB6ab+26VkWHBNk4QF3NRUtzUF+2P5U8zTxfFMS6OJFUk3One+LuF2bonmqgMP9a86N5O48weVHoWDlf3bw3exRLobBfFUXHRusfwkTLa067QJWSZ31ClVe4SZa421K00K7G5/TGnF57e91mkop+/qHbHa7HHhGiosyGBWphEp33B6bJiNym3E8xhgCMO1mpLKTolBlH4SDiPfFk9Osy4Lq6Ju/bz+Zn1p1xcB0xigupEqGLpkb+xYb34CcwESm6nneonRBvEPW3jkfOUxpV8BRh4TxHXIT8L68xP36k57IQE/exMCb/WBzXUDs13BVvRCS1oMGev9c6XIqyeZyXWweEfZpj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series splits folio LRU and swap cleanup into three steps:

  - move the page-cluster sysctl next to swap readahead in
    mm/swap_state.c
  - rename mm/swap.c to mm/folio.c after the swap-specific code
    moves out
  - move MM-internal reclaim declarations out of include/linux/swap.h

After this series, swap cache and swap-in readahead stay in
mm/swap_state.c. Folio LRU helpers live in mm/folio.c, and
MM-internal reclaim/workingset declarations move from
include/linux/swap.h to mm/internal.h (public LRU helpers used outside
mm/ remain in swap.h).

The first patch handles the swap-specific page-cluster state before the
file rename, so the rename commit only carries folio LRU code. The last
patch keeps the LRU helpers used outside mm/ in include/linux/swap.h and
moves the internal reclaim/workingset declarations to mm/internal.h.

Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
Changes in v9:
- Rebased onto akpm/mm-unstable (d11ba1f57061).
- Drop the unrelated blank line in mm/swap.h.
- Drop the redundant swap_readahead_setup() comment.
- Add Suggested-by Matthew Wilcox on patch 1/3.
- Link to v8: https://lore.kernel.org/r/20260708-ch-swap-series-plus-folio-lru-cleanup-v8-0-e816812698a8@gmail.com

Changes in v8:
- Rebased onto akpm/mm-unstable (0bfae5663f86).
- Re-tested full build, swap-in readahead smoke test, and
  run_vmtests.sh on x86.
- Make swap_readahead_setup() static and remove mm/swap.h export
  (including the CONFIG_SWAP=n stub).
- Refactor swap_state.c init: extract swap_sysfs_init(), add
  CONFIG_SYSFS=n stub.
- Drop swap_readahead_setup() call from kswapd_init() in vmscan.c.
- Add Reviewed-by Kairui Song on patch 1/3.
- Link to v7: https://lore.kernel.org/r/20260705-ch-swap-series-plus-folio-lru-cleanup-v7-0-a028e8b5fc3d@gmail.com

Changes in v7:
- Rebased onto akpm/mm-unstable (cfb8731f5396).
- Re-tested full build, swap-in readahead smoke test, and
  run_vmtests.sh on x86.
- Move swap_readahead_setup() into swap_init() in swap_state.c.
- Move version-history text below the "---" separator in the
  cover letter.
- Add Suggested-by and Acked-by Johannes Weiner on patch 1/3.
- Add Suggested-by Matthew Wilcox on patch 2/3.
- Link to v6: https://lore.kernel.org/r/20260701-ch-swap-series-plus-folio-lru-cleanup-v6-0-d4f648963382@gmail.com

Changes in v6:
- Rename mm/swap.c to mm/folio.c instead of folio_lru.c.
- Link to v5: https://lore.kernel.org/r/20260630-ch-swap-series-plus-folio-lru-cleanup-v5-0-4627aba8ed1e@gmail.com

Changes in v5:
- Rebased onto akpm/mm-unstable (81652c5a65d4).
- Fix mm/swap.h for CONFIG_SWAP=n after rebase.
- Tested swap-in readahead on x86 with swap: vm.page-cluster present
  and writable, swap in/out under anon memory pressure, page-cluster 0
  and 3 paths, no oops in dmesg; run_vmtests.sh passed.
- Link to v4: https://lore.kernel.org/r/20260603-ch-swap-series-plus-folio-lru-cleanup-v4-0-ce0219e100d9@gmail.com

Changes in v4:
- Address Baoquan He's review on v3: align patch 2 subject with
  rename-only scope; fix vm.rst sysctl documentation; refresh file
  header comments in mm/folio_lru.c and swap.h declaration comments.
- Expand patch 1 commit message on CONFIG_SWAP=n vm.page-cluster
  registration (also on CONFIG_SWAP=n kernels).
- Link to v3: https://lore.kernel.org/all/20260602-ch-swap-series-plus-folio-lru-cleanup-v3-0-5bbb567f8c99@gmail.com

---
Jianyue Wu (3):
      mm/swap: colocate page-cluster sysctl with swap readahead
      mm: rename swap.c to folio.c
      mm: move reclaim-internal declarations out of swap.h

 Documentation/admin-guide/sysctl/vm.rst |  3 --
 Documentation/core-api/mm-api.rst       |  2 +-
 MAINTAINERS                             |  3 +-
 include/linux/swap.h                    | 76 +++------------------------------
 mm/Makefile                             |  2 +-
 mm/{swap.c => folio.c}                  | 46 ++------------------
 mm/internal.h                           | 67 +++++++++++++++++++++++++++++
 mm/memfd.c                              |  1 +
 mm/swap.h                               |  2 -
 mm/swap_state.c                         | 50 +++++++++++++++++++++-
 mm/vmscan.c                             |  1 -
 11 files changed, 129 insertions(+), 124 deletions(-)
---
base-commit: d11ba1f570615ec8d4814d6313ee1d7075a33787
change-id: 20260531-ch-swap-series-plus-folio-lru-cleanup-d9781c8332dc

Best regards,
-- 
Jianyue Wu <wujianyue000@gmail.com>


