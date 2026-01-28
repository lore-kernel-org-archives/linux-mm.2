Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BF8DD35690
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 09:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2D946B0088; Wed, 28 Jan 2026 04:30:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D05376B0089; Wed, 28 Jan 2026 04:30:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C08266B008A; Wed, 28 Jan 2026 04:30:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ADAFE6B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 04:30:35 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D03DE14055A
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:30:34 +0000 (UTC)
X-FDA: 84380852388.29.E1DAEEE
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id E98F4140006
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:30:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hM0kmJg+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769592633; a=rsa-sha256;
	cv=none;
	b=PRR9USp2iMij/cOgPvfHWGqHW5PoCN1HMT/X88qJzsugHV17x5n4/YDhljLm7XRWYXdtST
	m4w82HFwKCXlvYJJr+P4XZ5w9/Q4twGEYqtj/M9tgZAtMjdmU0Nc66MNZFxkWN9T/2Oyfp
	E12xcGahSA1Zsas9dB74RcZVs0nT1Ks=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hM0kmJg+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769592633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CWU5+GI80rzKUvfGPShbg6eie5kBzuS4F6usClrZBLY=;
	b=CeGgd9risSLmjaC1QjOl2g0bFLDJjx94zA7oq37Q0184Agt0TqiKXjTmrXWS7FhySnnZz6
	4/0wuUNgdjASO+e+khmC4biN4X3yszfz0AIInlJT3VloSqMlUxsaXpR8nqDoMNWt4R66U6
	PH6px4PbYWgxni2KEOvqqYbKD6TiLJ8=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-34f634dbfd6so5474881a91.2
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 01:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769592632; x=1770197432; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CWU5+GI80rzKUvfGPShbg6eie5kBzuS4F6usClrZBLY=;
        b=hM0kmJg+7Q1iAeHOvJGWwpW58WTziF46AD0LbFakf0t9/Yvd6lR9Ob0cwpefnGbl4A
         mEakw8hB6uDwpu+P1yBwObygoyVNjnFkn1F3iVT+R7y8AER8I+uue6H4RmVlXcO8Apty
         ++scyUktfJyMb/3APTAWsYVpbd9ZE7vrOkbGs3GyuZibZQZTw+LI/mB1NbxIV7q4E5XZ
         3maQzz1Uo09I1uxnEE/auTk1Uj5rI0tGeikDeANimyaO0iApTPAmMMGV5B8fdp5YPMLI
         8mTvFoEulzMhrIu5Zlbm8GO48Uh7gBhruMfZ7qmTw12XKKwFkccAtxHqIqAUbEMgCqmX
         W1Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769592632; x=1770197432;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CWU5+GI80rzKUvfGPShbg6eie5kBzuS4F6usClrZBLY=;
        b=pkTweNzAP+u6RD91vzUj97YsAdKT+BsJ/zEDF/cZcc245hQ2uONHhsvCtgC6lk5N97
         sBxXJvCNDyfMvwS4qDs9YEo1fBhzgsGyKk95IieUGkeMGr1CPOpTEyThXHvxYppKu7X3
         W6N787hlWIPOI35StgyY4isPQobADqvIpoG7G/j5r2M2yA1ZvzjJ36YpXq3LG/bw2fw2
         j9c/850mZK1X3s01R7aSLP4gOszdqao5t6plqFQmSjwarbg1bPOvgbva8rmMLPrFHr99
         lTBd1x/YHZSkMryZSdFm1Hrdf/RLnq1iRE/lCBx/L5I0qioKXbaJ+ROVuK+Wb5VCjiDH
         jozA==
X-Gm-Message-State: AOJu0Yxf7FbRL24H7K9YlThJcR9m5v5gx67Rx9EKWztp5Fw/2Ih5Xmay
	KAeMcqCbCI9S0Eu9e4wbKsA26PrUlM8xtFi0DrfZz9gaErI+xErW8OnD
X-Gm-Gg: AZuq6aIdsNckwNGHcPGPSF5tjN3WicpA5UXylSCUQWLfiNePGpK0q+skl/LQpcEYcPO
	WVcuWawIrXI0xZpaibD4V7WpvtQdvjeqDXQ82P/mkCL6UZfYCZHcc1kG0xgjY5Pbr7ez03M80Hj
	6hdNUkYo8q9TAuDRapZuQHB/pYnM8UxBq+kOgRtX/oNeqK9uFNZ2EfbC4Keq5Vs9lRHbMsIMWB5
	GXQQgm/Hr8OMqeE99VPB/owCHg6CtBmbY9m1yePRQ/6magW2DXxyDQS5R6G1Uowuv5UfgXUTM0J
	ruD5dmydDpkCk5ztIpqxz39AmbCIx28/m22ODxFW2TwLjNIOWEqy/hTdWREaNmczHJbTi5P79A4
	dOifqeWW5msHb7TvwnThwmTGSqvxbjeByvoi4rpqGEn+CrKG+/i/gWSrd+/xicgqFDem1uJaOCs
	Gt+VT8wFvENgLZHokXoz7YvwjSfvbleC554czB9z92L+Npd8bGN2Gq6guoEQ==
X-Received: by 2002:a17:90b:2789:b0:34c:cb3c:f536 with SMTP id 98e67ed59e1d1-353fedbb396mr4978524a91.36.1769592631687;
        Wed, 28 Jan 2026 01:30:31 -0800 (PST)
Received: from [127.0.0.1] ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3540f3eca6dsm1872235a91.15.2026.01.28.01.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 01:30:31 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Subject: [PATCH v2 00/12] mm, swap: swap table phase III: remove swap_map
Date: Wed, 28 Jan 2026 17:28:24 +0800
Message-Id: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/13MQQ7CIBCF4as0s3YMUCnqynuYLqAdLIlCA6RqG
 u4u7dLl/5L3rZAoOkpwbVaItLjkgq8hDg0Mk/YPQjfWBsGE5IJ3mN56xqzNk3Bu8TySai2RMtJ
 C/cyRrPvs3r2vPbmUQ/zu/MK3dZM6xsW/tHBkqNWJS2m1uRh2y+QH8vk4hBf0pZQfvk7J8qwAA
 AA=
X-Change-ID: 20251216-swap-table-p3-8de73fee7b5f
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769592628; l=4647;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=twxbP0g4CrwvblUjXGxqvuvnnM3ZU03eSXMb1SiZqyw=;
 b=lCPeHPz6DUFJ2ww2Ne99AdSNMb3RP8bQZPv7KTiwIa8i/Xse0MopcYlXi+ciRLcD5+ibVAzG3
 7v2N5Ee6wBuCWZ3/+3qOnRC0NBtow+djUmz6+9KwoozbKVLBnmr8XW7
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E98F4140006
X-Stat-Signature: ig88e55379cmjwgfqkg8nz1qcq6kyogq
X-HE-Tag: 1769592632-365665
X-HE-Meta: U2FsdGVkX1/M1biNI2XIqMjyD0yObwCbYU1fD0+JbIxES/SkLlVDzNa+2giA8z1RYBKP4vyHYYK7SElNMEc9L4JzuZdkK+P5cMDU+5FPT1w3/00x/t7inO/IGUWJ3MVhmPDEv4y1SQrIG8ACUzhhRS7yIuEhZRGemIg8r7g+sym1sWmL+CcantFlgL4J61c6bpPSZaOMcPZcxZ6Bq4zZHzQDerZpYi7Mwgc0V9n5PK/CtIkpKjNmpb/BVMzLUDSlY4kqFT5yNRolZ3/YjA3ZuTgJVOSmcdB0lfki76pG+7Qv9ScdHxI5BoLDHNwsL4Nw0h7PtZ/jziiu4TbsanKBnOFokcGUDIpEgxZ8uG7lGw6BxWuhRtN8M4NL6wb1BnlYexlqtFzH8rF3bWFhpuaYm0P9yE3Uy5uCGTp1BgvAvoulry/tjZMdA3G7r0aSCqul/8ynl2a9QYBQJP1PdGRxhVF1fRg32WOuCCGeoLLqPB/rCebrvujyN1b0HRD4oQ/6PViTo9FlmYfFH6hiwmK4BX+BO1G0M9LxiEBRliWPddl845qG7iiyUytmn2CKbvL9nKnqaXAiZCii8d5TN7wXMxWwOYOBHfxDzQmGxr7+m3GYI6XDT3GxiIJBjKg0TUbVSKmpz7j8KGRW03goIgLSjM1I5oe4c557uuW57W8Gcr9197o8b1yNRIHMLbKKGbXC1KEM857mmhJAFUfcDFWgfk/861AgcSGp6GIhWw5PwkXhRywIdxhYv20+ZT/6rBN24GOVjlz6YdExm2MqTKB9tY6MXv8+/YOK4q8EWg1JGqy4OIjwPQ/GVAZ3eH6ps/OzEtgix6jRcpWnUhL2irbAjXCMMFhpogb8xSuXnqBOporxM2xly8Et4PJbwv1++Y1JNvGQ2CMLhO/1orVdfHx+KWgZKS2j7FrGIbHmCNBAmFRUybThE8SRg1e2cJ3geoqtQoERB70X8/Y+fZA8CDm
 TcH4HZ+Q
 4pmWHB5OmcHnbeJ3SrziAO7LrB0SheJ5oxyhAixeONvwC/LM+xx4+GCVUlWq2c1yo6p5HzjVtp8x5uN5XYashHYYbPu5W2YfftnKVcpgNCX/1S5O+HJGabe9d9bj62bNuyQRXgGefmxGIsfah8IjtO9HT20/v4+HnNx6j+zsOz/MGf8zbyQaYsezcJYDon3/sU868t6L/BCJO4Fm0IEgtuTWUtBiG/hcJc5ZEv5bp+yCCJux0zzTVDNxXVoucZE5zLKG6IBT3kT7jVQchGUIxI6vXU/u89htgMF03tr8CL4iSK8eZy8EF4hDIRFGgqrpvObr71Z50u3k4kVGl/FtZ6o6PIjzBqhEdIdKbXX63FZwA8jsZjvdMPDPHPtBVqbn0/Ed4LtqaDjzncm4zEva81mzuMglER9RRu7W0Rx20e4YHslpRTbHDvOsm3wBvVpTbvBaEK5d3Y3aAP3Y9f0ufFLDRxvT3LBTRMiK/N5cS1RGOkMm45CQN8Iqbwg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series is based on phase II which is still in mm-unstable.

This series removes the static swap_map and uses the swap table for the
swap count directly. This saves about ~30% memory usage for the static
swap metadata. For example, this saves 256MB of memory when mounting a
1TB swap device. Performance is slightly better too, since the double
update of the swap table and swap_map is now gone.

Test results:

Mounting a swap device:
=======================
Mount a 1TB brd device as SWAP, just to verify the memory save:

`free -m` before:
               total        used        free      shared  buff/cache   available
Mem:            1465        1051         417           1          61         413
Swap:        1054435           0     1054435

`free -m` after:
               total        used        free      shared  buff/cache   available
Mem:            1465         795         672           1          62         670
Swap:        1054435           0     1054435

Idle memory usage is reduced by ~256MB just as expected. And following
this design we should be able to save another ~512MB in a next phase.

Build kernel test:
==================
Test using ZSWAP with NVME SWAP, make -j48, defconfig, in a x86_64 VM
with 5G RAM, under global pressure, avg of 32 test run:

                Before            After:
System time:    1038.97s          1013.75s (-2.4%)

Test using ZRAM as SWAP, make -j12, tinyconfig, in a ARM64 VM with 1.5G
RAM, under global pressure, avg of 32 test run:

                Before            After:
System time:    67.75s            66.65s (-1.6%)

The result is slightly better.

Redis / Valkey benchmark:
=========================
Test using ZRAM as SWAP, in a ARM64 VM with 1.5G RAM, under global pressure,
avg of 64 test run:

Server: valkey-server --maxmemory 2560M
Client: redis-benchmark -r 3000000 -n 3000000 -d 1024 -c 12 -P 32 -t get

        no persistence              with BGSAVE
Before: 472705.71 RPS               369451.68 RPS
After:  481197.93 RPS (+1.8%)       374922.32 RPS (+1.5%)

In conclusion, performance is better in all cases, and memory usage is
much lower.

The swap cgroup array will also be merged into the swap table in a later
phase, saving the other ~60% part of the static swap metadata and making
all the swap metadata dynamic. The improved API for swap operations also
reduces the lock contention and makes more batching operations possible.

Suggested-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
Changes in v2:
- Fix build error for ARC with 40 bits of PAE address, adjust macros to
  shrink SWP_TB_COUNT_BITS if needed, and trigger build error if that
  field is too small. There should be no code change for 64 bit builds.
- Fix build warning of unused variables.
- SWP_TB_COUNT_MAX should be ((1 << SWP_TB_COUNT_BITS) - 1), not ((1 <<
  SWP_TB_COUNT_BITS) - 2). No behavior change, just don't waste usable
  bits and reduce the chance of a slower extended table path.
- Add a missing NULL check in swap_extend_table_try_free.
- Fix a typecast error in the swapoff path to silence some static analyzer.
- Stress tested setups with SWP_TB_COUNT_BITS == 2, looks fine.
- Link to v1:
  https://lore.kernel.org/r/20260126-swap-table-p3-v1-0-a74155fab9b0@tencent.com

---
Kairui Song (12):
      mm, swap: protect si->swap_file properly and use as a mount indicator
      mm, swap: clean up swapon process and locking
      mm, swap: remove redundant arguments and locking for enabling a device
      mm, swap: consolidate bad slots setup and make it more robust
      mm/workingset: leave highest bits empty for anon shadow
      mm, swap: implement helpers for reserving data in the swap table
      mm, swap: mark bad slots in swap table directly
      mm, swap: simplify swap table sanity range check
      mm, swap: use the swap table to track the swap count
      mm, swap: no need to truncate the scan border
      mm, swap: simplify checking if a folio is swapped
      mm, swap: no need to clear the shadow explicitly

 include/linux/swap.h |   28 +-
 mm/memory.c          |    2 +-
 mm/swap.h            |   22 +-
 mm/swap_state.c      |   72 ++--
 mm/swap_table.h      |  138 ++++++-
 mm/swapfile.c        | 1111 +++++++++++++++++++++-----------------------------
 mm/workingset.c      |   49 ++-
 7 files changed, 663 insertions(+), 759 deletions(-)
---
base-commit: b2394bad912787054d79bf22303dd03eb59aa416
change-id: 20251216-swap-table-p3-8de73fee7b5f

Best regards,
-- 
Kairui Song <kasong@tencent.com>


