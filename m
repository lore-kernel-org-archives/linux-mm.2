Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 574D5F531DD
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 22:39:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4790B6B0088; Mon, 13 Apr 2026 18:39:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42A1D6B0092; Mon, 13 Apr 2026 18:39:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 319536B008A; Mon, 13 Apr 2026 18:39:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F6CE6B0005
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:39:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A0DEA8B24D
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:39:57 +0000 (UTC)
X-FDA: 84655001634.16.BEB2364
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	by imf14.hostedemail.com (Postfix) with ESMTP id B369D100006
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:39:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nzifsHyZ;
	spf=pass (imf14.hostedemail.com: domain of minchan.kim@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=minchan.kim@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=kernel.org (policy=quarantine)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776119995;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0K64xmthNLCePmJo52NuOtEIXWr6iFwRBqVr5vZCSO8=;
	b=1hqIH/VTuSJRTt7eKanfrnbbtEBsFTqV+Tud15BVr6+6JhcdcpGUoec/RsZJBhufnQYP43
	9WlO2Wr8FitL+6FQB98sDDA3adtUKQnOqinONXi0JKGvvPH9DLaon2fb77ib8zMlOKbdH9
	l6GtrwEpWqMlbN4OrM7yMQhvzzOGsYo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776119995; a=rsa-sha256;
	cv=none;
	b=2HcdY3bkmp5L7CQLC1a/R1CJEdus121K+1d1sxgjbofGCGVHdus84kdPICcdPYsPPAmGSs
	AgapU8Ylyxgdk9Ue/1Y4N9mmRwZfn6IwNCs34nhBrfXjXn8QdFkZnG/Y1pLN+nUcus/rC1
	qeUE01V5nF7vY4+3lybqe/5fGSvG/S8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nzifsHyZ;
	spf=pass (imf14.hostedemail.com: domain of minchan.kim@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=minchan.kim@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=kernel.org (policy=quarantine)
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-2d832f2f44cso2264223eec.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776119994; x=1776724794; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=0K64xmthNLCePmJo52NuOtEIXWr6iFwRBqVr5vZCSO8=;
        b=nzifsHyZMlTygEUbWPkE7oKIASYTfNneVUz0Kdo5LW0XkMh3SUXd2fDCthFCkd82xG
         ohmI1jjJ0c21DUAroMlsg8g5ZCl499miP9gn37X5Ue3DYJpKRFWujXAlmAiX073F/U+E
         yMhZA3uQ43Kw6LVMkU/7PHM3MaBLqbIf3D83aPvS7nv75SgjzeFyjQc0ZMzV7sejVf4O
         KEUWl5mEubsNX2tmDEskGDT3oUEtTjXBFzFWP9S+Q0r0lAbae/oJVArZ9Jz7KcW6TKTq
         yaNkPT64nsDF8B/Ez25KUNwkxde+yFfh1GV0qy8tXO1eu3Za2rFgSwFwWwIYdkXOb8fA
         N13Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776119994; x=1776724794;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0K64xmthNLCePmJo52NuOtEIXWr6iFwRBqVr5vZCSO8=;
        b=PuKci3H+Lsx+ezMw1SmQOJh1gYx09SsbXnw3XvDYebFJunY1iM7LN9MWLrymVGEJS8
         WE9I7GvdWwsugtmuDxES8vWUO53Se8SgYExjnvgs5lpj3ShuZ59k1zlL3c/RbGR17ZMQ
         645hfWoSozLqWC6RvrWockm/BvCvla82fYfoqoRkldYGJnOKLPgEd4G3vxAw5omROeKa
         9t9DhM1PvXzML1589cZSynHKjHbsLPv7Xinqnqi9JB5C/QAR6niK3dwrQoNhVKygki0G
         XnZdFJM2CDCXFndws+4SuLYPE6Q2VzltgXrMpzGU2rSw05sXI3FZkcfKt5s0VO1uYwZ3
         smsQ==
X-Forwarded-Encrypted: i=1; AFNElJ8LqujQu+O+2Ra2wcZ3ahyP4FXVAy6KUNkOEn7sSHwrY61lt8r87kG654+YDBQ9AJx0a7inAnlEFA==@kvack.org
X-Gm-Message-State: AOJu0Yz3fcG1VBNS2pGP/mhPlcsSf1TOSqDQCoHcH6wwojIaditJJfIS
	0HCMyu2KlIaWOlBVHCc1MFwjoCZgHvUJOMYGKuA8cDJnWDX2LX776B2V
X-Gm-Gg: AeBDietS9LVTDoIhip7dG3nn2aO+0PbibpRrHXg1G+UtN28ir98OP81YjBBV2pX9lI9
	weRMH5h6t+xZ7xWpQlMRxCDE51ClyAqKpwjM9iCxb4yVpkHnYCxBVG0IPqqvS/DXVjwNqoBWAVf
	f0CfkL6TH0Fl1mt2vUIXnQ5V+9zedSmHQ6ogCXHQrjcvA4Ij8/OK1bJ9tXt5+W6PhZoV0t4SD+V
	yqxQ15ICublZlKa0K6vA2hg7gxqk2kEj7hxrMZ5i9xH59CsY8ZnIfH4svdln506u6q9aPRnILMZ
	nNGz4Bf9Jvj5ZQOvGSF4ikyUbT0z5RwomSVNrGVL1KvJQnOLdqy6DcejnMqlSPg/Qe5LncUixT+
	gOHgqzkA6Cy96QGjqCmhC9ndUf4hlCEF9b85Tx6rekeHQKlD58rcCt03xB/9XbMMafWZeJiWAGs
	w0aHshleZlZrwe29rtVnRFKAis0jadlyt7xatS/lSdJfietT4haiekmL6xiMboGdjPWmlogwfsp
	QoO
X-Received: by 2002:a05:7300:dc83:b0:2d9:3616:d897 with SMTP id 5a478bee46e88-2d936261d6fmr3514937eec.22.1776119994303;
        Mon, 13 Apr 2026 15:39:54 -0700 (PDT)
Received: from bbox-1.mtv.corp.google.com ([2a00:79e0:2e7c:8:c871:4088:5cd5:bd1b])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d561cd3138sm18577297eec.14.2026.04.13.15.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 15:39:53 -0700 (PDT)
From: Minchan Kim <minchan@kernel.org>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	mhocko@suse.com,
	brauner@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	surenb@google.com,
	timmurray@google.com,
	Minchan Kim <minchan@kernel.org>
Subject: [RFC 0/3]  mm: process_mrelease: expedited reclaim and auto-kill support
Date: Mon, 13 Apr 2026 15:39:45 -0700
Message-ID: <20260413223948.556351-1-minchan@kernel.org>
X-Mailer: git-send-email 2.54.0.rc0.605.g598a273b03-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B369D100006
X-Stat-Signature: ixyaxoo9utug4wyjy6z8xyb5ag9dtewu
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspam: Yes
X-HE-Tag: 1776119995-940468
X-HE-Meta: U2FsdGVkX1/YCpGwsa0lj+ruWx7YiztbBD8y9hCiB+i2prm41l17etgO6cavdDL8/RpJxYAwruLluomcfg31ukTRbP73QAJmhs8M1m9rGQkOxebp+p7tAkSNJPIaDIQDREzMfECeOl4nQpb63IusqeMl1t2SR3ckDgeKpTsuqyp0DIiWp0tofJcJ1MmT2QsgtbaZxzcPoOlTWOiAKt26s34lYgagg759PQdQvp2zZnBwRHfh7hOfhzYDrIBBBnIuQbLXGfyHn7A3zjfR7qwcaLP1B4aok832/P+cZYAsYq3bqvPBlF4tcjSg463Q/pyoJJGpVfpV7t7o+Y6rrfd+b8snFfM6rTjxMxEBhC47J3QNq/Su+5YRgUBaEzaxtxeVXxxtKyJlvcM/nX0DabPWLGePdWJWkM7/lz0oM27rwEXNqN9Nc866lnlxJNnQ+ATfb26lrSZArEON0n8fHX03W4kC0Q0eL9GOjAowns8W/p28bE1WCPY9dgV7JeR/WOHRqUEkbNzyzb1JNUYDJ2OYcKMU6awT4SBExGZzKSrfGqXZObUj1Iz7dISt6cZSF6mz9ujM5X280Z2TlgUHBPsEg5O1P+EN+PZSjn8MAaBKqiKy8T+fm0yXXCHMFDZ5c2rtFf3Tw4dYdkGUXE8oimwdEmc5hVpl9ENPNbAHVzATc7Rnab5NY1QBZMH7eGE7fMnBbX2PFGgu/WAAHucWNqhtCEJe7HhxLIZ9b25QravpKupEK1RwTKChUeHIuCqU4UR44JVvp+5tpNjmuXmLDS+kwjB1EhJIGw1oeer8NIuEZww970kOtQwuV9JFDH+BxFmlQo2DjaNmnb9qlNMiULO8IO54c+CL1gAnaDU8eO8qHTqQFJDKULJY73rkOfg5+/1Ele6gtKAIaU7vfy667HIe1rmZiwYpA4JLkBJWSbp6FrlVADvUcr8EV3LQ1pm5CCdQ+Kbp3jp14trAxvcjaXk
 b3pbzu0D
 vE3+SDoUWWoaYsaJ2AZQnrnwY087GvXPGqlyU+Jj+t7BbfZF0+Ht301vLeoEzAgr5TXTmzlKJSLL6R3v4/2R7dtlFLdu/zLOPGMGo7hjvz8TNbmE9mBQM6rU83Uu5b54dQkKQHAJuA/WmIRx9qHKSaemvH/1t8ms6atkPwswuWS4GvfR0TddZU6vH4kBkYkezKb6ZN2+0xGryk7/uMiTy/eOYFz6jIi0OOdOGZM79s1os3KVMUNeF9RU46MBX1rgLunpYNBnxuvuVNwIK6QrAnSyOd8go6Y9fKKUXuXfNJ/UmBlAa3/QaLwD8tINxYEqb1riJ6WFj0ijiso3e3vvia1kBjJWmNZlUn8Bz3tCXAW64lWF1Wsc0+NDwTHuiznvEnYKq+ycbId8/0hpX4bP9E2Y2W8Qz8TUYj5OsBwj2yeDWAY0uc8WB3B/luypLz0Jp/HD3Aa7yVdtc2uNMyDR51cEfv2i/1IhtJ8sz5t5pPbwadwRbDniK3MhY20WiM19atFWqi+fC5VPwf1AIV5xMtIZAn3eunlU2Uht+0XFEJF6+sW6/N92dt6z+IJS6O2NOxP8Kb1IIJ97PdBssjzDqy+mRUxpTLA0yEk6fsIdSbLojv76LK2Rc3IOKw+gDi7K5D/ysOH16tOJgAoe7sdkpX+yOWBtgSvEA6j6HE6qDB4ow03S2hW1XhvfOFfgJvuvTmDLAkjS49JoIWg47oD4yTuicvwCwOdLtnQQrqDRtrDHbQjgf/gApphMCb61toUEQkk4D38itizt+vsg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series introduces optimizations to expedite memory reclamation
in process_mrelease() and provides a secure, race-free "auto-kill"
mechanism for efficient container shutdown and OOM handling.

Currently, process_mrelease() unmaps pages but leaves clean file folios
on the LRU list, relying on standard memory reclaim to eventually free
them. Furthermore, requiring userspace to send a SIGKILL prior to
invoking process_mrelease() introduces scheduling race conditions where
the victim task may enter the exit path prematurely, bypassing expedited
reclamation hooks.

This series addresses these limitations in three logical steps.

Patch #1: mm: process_mrelease: expedite clean file folio reclaim via mmu_gather
Integrates clean file folio eviction directly into the low-level TLB
batching (mmu_gather) infrastructure. Symmetrically truncates clean file
folios alongside anonymous pages during the unmap loop.

Patch #2: mm: process_mrelease: skip LRU movement for exclusive file folios
Skips costly LRU marking (folio_mark_accessed) for exclusive file-backed
folios undergoing process_mrelease reclaim. Perf profiling reveals that
LRU movement accounts for ~55% of overhead during unmap.

Patch #3: mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL flag
Adds an auto-kill flag supporting atomic teardown. Utilizes a dedicated
signal code (KILL_MRELEASE) to guarantee MMF_UNSTABLE is marked in the
signal delivery path, preventing scheduling races.

Minchan Kim (3):
  mm: process_mrelease: expedite clean file folio reclaim via mmu_gather
  mm: process_mrelease: skip LRU movement for exclusive file folios
  mm: process_mrelease: introduce PROCESS_MRELEASE_REAP_KILL flag

 arch/s390/include/asm/tlb.h        |  2 +-
 include/linux/swap.h               |  9 ++++++---
 include/uapi/asm-generic/siginfo.h |  6 ++++++
 include/uapi/linux/mman.h          |  4 ++++
 kernel/signal.c                    |  4 ++++
 mm/memory.c                        | 13 ++++++++++++-
 mm/mmu_gather.c                    |  8 +++++---
 mm/oom_kill.c                      | 20 +++++++++++++++++++-
 mm/swap_state.c                    | 19 +++++++++++++++++--
 9 files changed, 74 insertions(+), 11 deletions(-)

-- 
2.54.0.rc0.605.g598a273b03-goog


