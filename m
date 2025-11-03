Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12ED4CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 07:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FC7B8E002C; Mon,  3 Nov 2025 02:52:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D3FC8E002A; Mon,  3 Nov 2025 02:52:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E96D8E002C; Mon,  3 Nov 2025 02:52:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B39A8E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 02:52:57 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 139F84AEAB
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:52:57 +0000 (UTC)
X-FDA: 84068529594.28.EA8AD9A
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1A12FC0005
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:52:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b="caXh9Rq/";
	dmarc=pass (policy=reject) header.from=shopee.com;
	spf=pass (imf22.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762156375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pLkzhtoF4Ahv1FKwU/tjbCnsdl0esqhckJcQdc+yB8A=;
	b=EMOJJKL12L+I3fNbqMNvytvo72MbqOC0V606Mxj+AXx9frBiQCfKzZkjfChmSEJd7/D7H5
	yI1sXUj594Bhf1oiDmOTjOU18U7fDmFh+N8MpOM7U85dQ5GjLaCgu84J+PAoHZaiS4GIhY
	Dkvlv9aARtPjcbMFO+vwFIhrokPzII4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762156375; a=rsa-sha256;
	cv=none;
	b=hS/+K7bR1DLc4GHcxAkm9cVzCHzXgWdzTaMpuMLE6nNwpl37J5PVUip3dJIc926YSo0CPw
	Q1pBKTfuh42r+nuWtYzb5+04dhYur8IjvWmqeOPH/TWkAXdvVvIpewQYCsljm1TOD5o9co
	wqVswjpyLDsr/uqEXdLPTxBJPJT+Z2U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b="caXh9Rq/";
	dmarc=pass (policy=reject) header.from=shopee.com;
	spf=pass (imf22.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-33ff5149ae8so3211065a91.3
        for <linux-mm@kvack.org>; Sun, 02 Nov 2025 23:52:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1762156374; x=1762761174; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pLkzhtoF4Ahv1FKwU/tjbCnsdl0esqhckJcQdc+yB8A=;
        b=caXh9Rq/gE9hOQrcg4LZtefbzbv7a6bFr3PcShmGJqrLtRipebeTlw+ZIXjQtjpyck
         nhK35QIojJeUKiyqYshdz0xCQaK1wDqNgVrrLRtsd3pnA75kQPeJVzq9GrG0Z+5JzaP5
         y1tVz2LEiTfVF3eneUr4Z6aIqzewtKEBJigYdMJ/YnqXOPqvZID/BsEiamrMJali+L9E
         ZNwdmRNPZKpFwt5M8GyZ2CXcw0RLxhE/acvetr3rFgxaVN3uvbPqHeqB/DDeG82pFZxH
         LgYMcjOS+w3aMtd3K8NbFB1ZTxucQwQdT9sgc0I5bE3HozXmU48fQj6jA/sr+Uo3u+xM
         ysxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762156374; x=1762761174;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pLkzhtoF4Ahv1FKwU/tjbCnsdl0esqhckJcQdc+yB8A=;
        b=F73AOfFzwccB9a8bIuRDuVznzLi1PyuQOrg1rg53ghYtNWvY5MmjY0WuyCLYG3JmAw
         hKNtZrsglOz+ELPL/4RmQMamcS5gL5b9snxwQc9a7vlpsCRjRRaG86LwH4OdiD1Qwg0K
         0V3xq3v8y6Z4E+daURGzTZXQHYa3EAj4vX1MEu3LqusLTzMJ0cVdM/BrSOVdWXAh8UVC
         pwiUFH/WpUDZiVde+VUBzxlo9A8KxUSvS+EoGmS0mnRWx6Q0cV3RPFnqLXNIxkrRrR/n
         ySjYvVwQTqoVoWjc0XEWKrK22aM8n/OzzKqjeStiiR8nTloeVZjlFx9oQ/uwocwMFmI3
         1ctQ==
X-Forwarded-Encrypted: i=1; AJvYcCXjQvL52+9eCYvadF3g9a8JhiFfb1/UUoEbOQIv0Zh+MxRWcCe/xNXIRiDd2vSzC5OoUgFmwtOHtQ==@kvack.org
X-Gm-Message-State: AOJu0YzeubPX5rkEDNulnvXmpPn3Fwxt9cUJqlWMNPe1/RBRJj/yxBol
	hKjOJVu6OKR97nYweMjk27p2mS3qM4IUOUEaSVXq9agTwZymdBvEChs8RPpffFQc1AOSNUtk5cX
	zgYJ/ZesWAg==
X-Gm-Gg: ASbGncv/mK0msJtB6gTINiChmF9NK5tmExBxjsW235Jc9Ku6fthkK+elQmER8cMuBR1
	fZdl86ZDhKdPZ8d3a5M9ABLW5PODBu9V3lMhhwwqJPV6TfnTtcmAOKeGn57oSixC3w0E+dJ1OjY
	Do5UgFjKd+MW7rC9lVlMRFMeD2qREWG6zP+dmyJ3y3FxZv3rzXHoR0iUX6Xk3+AH0fmmlN4+Vt6
	jc937Q9oGc7FLbwFWH771YgmZTiceapWh+4vlXRzH504Tw5esKm8I/6h92QeRvyH/DP5a97v4rm
	HWg5i65Xc04v6B2dKPHhMvJmpCGPH5GR4vaVfcEXbN91Hl0SZAGFZGknAC4pwtXgqBb+Bji3j5G
	S46J3dI4AYxlWLxd2kSp6PGsIY9C6plwcEoneWOYRcne8xK68VCwlTgBMMt5UjhKv39MEjMbsPn
	nwnLqL3hmReXR2Ekgs9/yZ/pW+
X-Google-Smtp-Source: AGHT+IFmmflmrHgmAEotptMvyKECeXV6WQu6qDa1mCLOci2pV13NrALFzKLJadVhnxzhUmSBh4pxng==
X-Received: by 2002:a17:90b:1c06:b0:341:2150:4856 with SMTP id 98e67ed59e1d1-341215049b9mr3820496a91.17.1762156373781;
        Sun, 02 Nov 2025 23:52:53 -0800 (PST)
Received: from .shopee.com ([122.11.166.8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34159a16652sm34552a91.20.2025.11.02.23.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 23:52:53 -0800 (PST)
From: Leon Huang Fu <leon.huangfu@shopee.com>
To: stable@vger.kernel.org,
	greg@kroah.com
Cc: tj@kernel.org,
	lizefan.x@bytedance.com,
	hannes@cmpxchg.org,
	corbet@lwn.net,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeelb@google.com,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	sjenning@redhat.com,
	ddstreet@ieee.org,
	vitaly.wool@konsulko.com,
	lance.yang@linux.dev,
	leon.huangfu@shopee.com,
	shy828301@gmail.com,
	yosryahmed@google.com,
	sashal@kernel.org,
	vishal.moola@gmail.com,
	cerasuolodomenico@gmail.com,
	nphamcs@gmail.com,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.6.y 0/7] mm: memcg: subtree stats flushing and thresholds
Date: Mon,  3 Nov 2025 15:51:28 +0800
Message-ID: <20251103075135.20254-1-leon.huangfu@shopee.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: 8sfgpx16tbzfmpm4or7t31uob9rb96im
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A12FC0005
X-HE-Tag: 1762156374-773017
X-HE-Meta: U2FsdGVkX19bCnAmsY9JR9D5klZpkNEtXLlFv+VIUNVkCkNpKlakOn9ezguNbMb90U8oxaI/aN+dbyAaswoPdkXeeZppdn0LGAoENpy1cwNx3G8rxiQ1IBVuEPPQrOKpafHUFcMdgPScGbw/1BTFw38QymZXfEHZTpbK+dnWLmHk+h9+RP3iwyEv9tTps7lskqP0iFIvne8DJ3gHCowjI58+pENCyNhIAGGRkJQxNYLeV+H6qow4eV3qtmuOyGXTkYyBHgj856NIAt85hj3mH/r1yYT/9b1QAnpTRmdUrcLJaEn3vJTR7rUKcKUgekDUaWXmo+Y0A6yryuxa6zd4DJ4m7eA1RXnkFU054L3u1ZN4b3G41O9waq3ql6e5AqwIV7FAjNqQwJS1lu8nFzsuu6LoVNec9JW5XzFd3XVF39o0I3aPeATOIapaxkEt9CK9GS2Ay6+i/U0OMl2QOHUedNxle0Ua6n9+5DSgxW6QgSxBU7/7qApwS4Y/BKXf2aic7uFxA8B3Z0jRa2gGQT2lka1qQ++5Yqnm0Sx+fkLXyJn+ig+GPorfcvDveGDrbbPHTPiW8iNmEXXvZIUstPRafsz0xdncXM+02rqFT3RErhRA9HNmwRXyA8lEvXhKiWyHSfJyEhGoMorG+EXWLFg3JGjlpZYHclkVyGtt65E3OXJxuBwIVutz7nRnMLO0M8hXoQQ7Ze0BU+ZiBqEDgR60FS1uLavsNy6PAhMVySqokkw9q25KAxj9I6sfImTKoIW3B4xcfuMpk0TYOyURlNWirKnpjWNH/YE1hvxQkay0RG8IR2gbQVfuzgn5iXe5x6qMOVgdmcUTYaSbnPphS1mkHyKucq/rag9T94OWjTrlsJ8rZUI4If1oybUMc2c68FJG76ISUU808oi/UIYcALtTspeTDYlw1u0Z50uXf35wA0HNMPS6Gmj9b3/Povjnbm4zjCn+uL0mbzI6OsfcuRL
 yY2PjLxd
 j9KVNPtQSYdHwOTEhOqwLZuaUozhuGoPdoi+eWSh0tFyltdWovnsTgGmlkINBVj9UNPHTOHAqTqkQQKjJMngwf4lCrUEpxj8eorl7iADWkJo3pIY4rH2GGbELIk8Qk5bHH5vzJygXXdO99q3l/21iZP4YwzzkILZRmPhbIzICVlRektE/fQ8Ed/fyn/TH1lj0QWWCxOH43ktmcBT71oibM0Ic2uSirntgUpaAgvvUr74U6wmL1KXj5LaxKDstHU+hqw7y42QyYJImMHid2eCF9pX+FBnNyLPFUGhS5Ev4r8twoJ2C/q/1gSEwe3nQ+bitjzKjwfcOjvUGJ2Cg4ieZf4qB7SMr10fmmB1dTHnb3LyB7wgLyfuq2B8T1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We observed failures in the 'memcontrol02' test case from the Linux Test
Project (LTP) [1] when running on a 256-core server with the 6.6.y kernel.
The test fails due to stale memory.stat values being returned, which is
caused by the current stats flushing implementation's limitations with large
core counts.

This series backports the memcg subtree stats flushing improvements from
Linux 6.8 to 6.6.y to address the issue. The main goal is to restore
per-memcg stats flushing with dynamic thresholds, which improves both
accuracy and performance of memory cgroup statistics, especially on
high-core-count systems.

Background
==========

The current stats flushing in 6.6.y flushes the entire memcg hierarchy with
a global threshold. This is not efficient and can cause stale stats when read
'memory.stat'.

Dependency Patches
==================

Patches 1-2 are dependencies required for clean application of the main
series:

Patch 1: 811244a501b9 "mm: memcg: add THP swap out info for anonymous reclaim"

  This patch adds THP_SWPOUT and THP_SWPOUT_FALLBACK entries to the
  memcg_vm_event_stat[] array. It is needed because patch 4 (e0bf1dc859fd)
  moves the vmstats struct definitions, including this array. Without this
  patch, the array structure would not match between 6.6.y and 6.8, causing
  context conflicts during cherry-pick.

  The patch is already in mainline (merged in v6.7) but was not included in
  the stable 6.6.y branch.

Patch 2: 7108cc3f765c "mm: memcg: add per-memcg zswap writeback stat"

  This patch adds the ZSWPWB entry to the memcg_vm_event_stat[] array. Like
  patch 1, it is required for patch 4 to apply cleanly. The array structure
  must match the 6.8 state for the code movement to succeed without
  conflicts.

  This patch is also in mainline (merged in v6.8) but was not backported to
  6.6.y.

Main Series
===========

Patches 3-7 are the core memcg stats flushing improvements:

- Patch 3: Renames flush_next_time to flush_last_time for clarity
- Patch 4: Moves vmstats struct definitions for better code organization
- Patch 5: Implements per-memcg stats flushing thresholds (key change)
- Patch 6: Moves stats flush into workingset_test_recent()
- Patch 7: Restores subtree stats flushing (main feature)

Cherry-Pick Notes for Patch 7
==============================

Patch 7 (7d7ef0a4686a) requires manual conflict resolution in mm/zswap.c:

The conflict occurs because this patch includes changes to zswap shrinker
code that was introduced in Linux 6.8. Since this new shrinker
infrastructure does not exist in 6.6.y, the conflicting code should be
removed during cherry-pick.

Resolution: Keep the 6.6.y (HEAD) version of mm/zswap.c and discard the
new shrinker code from the patch. The conflict markers will show:

  <<<<<<< HEAD
  // existing 6.6.y code
  =======
  // new 6.8 shrinker code (shrink_memcg_cb, zswap_shrinker_scan, etc.)
  >>>>>>> 7d7ef0a4686a

Simply keep the HEAD version and remove everything between the "======="
and ">>>>>>>" markers. This is safe because the zswap shrinker is a
separate new feature, not a dependency for the memcg stats changes.

Additionally, if you encounter a conflict in mm/workingset.c, it may be
due to commit 417dbd7be383 ("mm: ratelimit stat flush from workingset
shrinker") which was backported to 6.6.y. The resolution is to use:
  mem_cgroup_flush_stats_ratelimited(sc->memcg)
which preserves the performance optimization while using the new API.

Testing
=======

This series has been extensively tested upstream with:
- 5000 concurrent workers in 500 cgroups doing allocations and reclaim
- 250k threads reading stats every 100ms in 50k cgroups
- No performance regressions observed with per-memcg thresholds

The changes improve both stats accuracy and reduce unnecessary flushing
overhead.

References
==========

[1] Linux Test Project (LTP): https://github.com/linux-test-project/ltp

Domenico Cerasuolo (1):
  mm: memcg: add per-memcg zswap writeback stat

Xin Hao (1):
  mm: memcg: add THP swap out info for anonymous reclaim

Yosry Ahmed (5):
  mm: memcg: change flush_next_time to flush_last_time
  mm: memcg: move vmstats structs definition above flushing code
  mm: memcg: make stats flushing threshold per-memcg
  mm: workingset: move the stats flush into workingset_test_recent()
  mm: memcg: restore subtree stats flushing

 Documentation/admin-guide/cgroup-v2.rst |   9 +
 include/linux/memcontrol.h              |   8 +-
 include/linux/vm_event_item.h           |   1 +
 mm/memcontrol.c                         | 266 +++++++++++++-----------
 mm/page_io.c                            |   8 +-
 mm/vmscan.c                             |   3 +-
 mm/vmstat.c                             |   1 +
 mm/workingset.c                         |  42 ++--
 mm/zswap.c                              |   4 +
 9 files changed, 203 insertions(+), 139 deletions(-)

--
2.50.1

