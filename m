Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14EC1C4453C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 16:35:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2203E6B0093; Wed, 22 Jul 2026 12:35:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FA6E6B009B; Wed, 22 Jul 2026 12:35:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1367E6B009D; Wed, 22 Jul 2026 12:35:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E10206B0093
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:35:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6B8D212020B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:35:47 +0000 (UTC)
X-FDA: 85016963934.21.B5A8E4B
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7B787100006
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:35:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.198 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784738145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=IBLryKwTtUnGvX1owRzcrX+V3EM9LpngHLsmtrpAS6Y=;
	b=ZYp/7f7g87v2H7lzh0hZu1fHrdaH284u7TdHpg9Bm8TCYetPs0TrAFSrw0zniQ18wOO2LM
	PQLNOdWXn769lTBKPMIjfyzU33HUXnOdybm4x3hamzj6h0wPLw+9D3fYtKDNMVBm/AqQfJ
	y9DZEd/IgJb/3AGK/3VatHIJzeKG+8E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784738145;
	b=mm5bQZRM1GcCa7F/G33hQ8JKoqgEI3LmJ+h7sd72c0pMzRsWGyecmBsfZebv0YZlmgjV55
	QWnabUDoC8LvnX9KAFcoMjKJo/f8VaTbMBtBnXOhSmeeapnfL9dBl/Vfp3sjzJQgK5Q/G/
	ZsAG+rOVPrJfzWAdTmlEwcsHH7rx0FU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.198 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
Received: by mail.gandi.net (Postfix) with ESMTPSA id 3A5DB3F505;
	Wed, 22 Jul 2026 16:35:40 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com
Cc: chengming.zhou@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	ryncsn@gmail.com,
	chrisl@kernel.org,
	baohua@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v2 0/3] mm: bypass swap readahead for zswap
Date: Wed, 22 Jul 2026 18:35:23 +0200
Message-ID: <20260722163536.773166-1-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTFEy/h7CX42yfAcvx8H68gVNQWl7hSJQtCRqa5qhaZvp1hGhH6WZ2/EporIZfMtT1niLpPlQCW7OwTxTuIxjqamN5Lusuv45Okg+WN/rspzzu2UF7rul7C/1iZvwvbHd6vGqDwj5ooxG3tauiuQpKwjFyJVOpx20A/Ak00UZ5OHqVhUh9Nw4XS0naXjjd8Xc2+RrpOHpojvQSHGpNjujI5wrtXZejKQVZL4KQ54lXr4lvTe6aYJfwH7ufoqkwUQZrWjvwlwb+4jaqv2fb/4XW13mkcpyu7dFJJKZPiKpWEUjTTlFvV24FIupHeqcFfBAR/OuAgqBYZoYfQS7TwYKvEZsI+7F/CPHL2eQyMZ7rxIA0VGs+J5WI6sKFMnD6VWZ0GBMaB1RWvS20w8FQLRTYTq5wux/qJkfV+dpTkKFSYQg+gDhW9tnPnXVLrtPSGqOmGPClvzbFTam39OKx/LHLs66bwzqVAJw1rmX/mGpGHnbH6575HZI9du7wOOdP2WGS0fEXFS81xnLAIsrfrSq0TaRm55w126hZYaYx/IK5FXVFMHLPyHnGCvVNBebM3+QXgpy2Mdk/sUidqBAuvg1/zY2Njb/CaDKFfD5Cdz4+kXnWANWLEWO/Hxxg8JldvHlJGeYCCtrvN8ho6AqHUekLInfRuyq4Vy23H/6/RZ4IslyQ
X-GND-State: clean
X-GND-Score: 0
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7B787100006
X-Stat-Signature: 6wu87ijyo7hoikr1ceoiq8ai7ym6e63u
X-Rspam-User: 
X-HE-Tag: 1784738145-294128
X-HE-Meta: U2FsdGVkX1/yCdbSRdo9whT0OLP/wI1/tRxJ9pZFMUNS3ANQC+S+v1nTDyVXuQTCHJ3P6mfPBJCGCBNVvzQNGN7d42mu4hQ+b5zKsCi0czD8e0t/tjatttkb5zMU2/NyrGVTWTWxkXntJChQw3slhaHs0b3nTFJkM/CeFB0xRFaV8wv1HWhlrkj2UB0Yn3z3x83dG/lHiHIuu10XRCE47yewEc1o/ChI3FCo+tTcRLzzg7IL2I7xC6dfmM2kP1F824d4duGeWbNA18OiYLvrQFOwChDnME1ISnvuvFGxrx5siFJ8F0Z/IwCht7SmJraVfEeBlNxnc/ak+C7JqKv0nWGUOwUSFJqMgi+hRan4Zvc+Fgmg3nOWsAYyE/rsz6BHFYL9XFsQDefNyiRGyNyhJoQKJAySz1GnP/cxdjg9rWPITQH4mVSjH6HUvBEQfhlsBn8WXNA2pm8I8oBA+AgNrLTL7rBvAZW6Z8u6DXm7zHqmjbmTOTQQ16UddGK2eRZnEKvD5EjMZ47n+uj4o0XBVV7UPYGY6bK8oo+/95qMAkdc5W8nnRXl3a2F0Sqdk+T66F9B1d9+XIFltV5hA4RBrGYt1iIW64hiaRM17CDJLGJbilwISSkVkw74hguIsV0oMygSP2+/ZqZgtQ7YOE9qFpevUJ/RkoO5sC4/opiJVte/0CKrlkhMH5Ije2/i10dxuJHW9HyCFjUa+CU1MtE1VhYBTFmJWL6YD0ML5bg6gYyysLKvUtqXRcXWKnSQvWWoJ+K8qnjC4dYIeetPkPJT5xKetgLr4ZfA37E1UahohMNL+5QXXpVVw4WMPHn4YJXoysCmp4m86/GAgTcIvLbx760MLETMmeRlBKsT4NQqx5G5zKxbJrCQ9hWIVFmOrN7+j7eI45jmJqpQoBAngktI553aRI8ggQmWyvpUArnsRUSuQi0iJHyXl7xMWIj5WwE9I5Ux1o00RepozbMLjCR
 MKY31Tpk
 r+DV2YXoWF/l0JvoT+ZyF/qVL8jvT6/Uaowlu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

First, the title is a bit misleading but this patchset is a follow-up of 
the zswap bypass readahead, so I kept it.

Swap readahead walks a window around the faulting entry and reads every
neighbour. Some of those reads are synchronous (a zswap-resident entry
or an entry on an SWP_SYNCHRONOUS_IO device) with no asynchronous device I/O
to overlap them with. Today they run inline during the window walk, so they
are pure added latency in front of the read the fault is actually waiting on.

This series splits the window walk into two passes and reorders it around that
distinction:

Patch 1 (overlap): issue the asynchronous device reads first, defer the
synchronous neighbours, and read them while the device I/O is in flight. This
overlaps the synchronous work with the disk reads instead of serialising it in
front of them -- the win for mixed (zswap + disk) workloads.

Patch 2 (bypass unless the target needs I/O): when the faulting target is
itself synchronous there is no in-flight I/O to hide the second pass behind, so
skip it. This is the zswap readahead bypass, gated on the target: it helps
pure-zswap workloads and, above all, keeps synchronous-target page-fault
latency low.

Patch 3 (SWP_SYNCHRONOUS_IO): treat SWP_SYNCHRONOUS_IO devices (zram) as
synchronous sources too, so a disk-target fault overlaps its zram neighbours'
reads behind its own disk I/O -- the same benefit patch 1 gives zswap
neighbours, now for mixed zram+disk workloads.

Changes since the RFC [1]:
- patch 1: overlap the synchronous decompression with the in-flight disk I/O
- patch 2: bypass the second pass when the target needs no disk I/O
- patch 3: extend the same handling to SWP_SYNCHRONOUS_IO devices (zram)

[1] https://lore.kernel.org/all/20260624075700.751467-1-alex@ghiti.fr/

Alexandre Ghiti (3):
  mm: swap: overlap synchronous readahead decompression with disk I/O
  mm: swap: bypass synchronous readahead unless the target needs I/O
  mm: swap: treat SWP_SYNCHRONOUS_IO devices as synchronous in readahead

 include/linux/swap.h  |  6 ++++
 include/linux/zswap.h |  6 ++++
 mm/swap_state.c       | 67 +++++++++++++++++++++++++++++++++++++++++--
 mm/swapfile.c         | 11 +++++++
 mm/zswap.c            | 17 +++++++++++
 5 files changed, 105 insertions(+), 2 deletions(-)


base-commit: 13a1e1a618858407fa12c391f664ea750651f6b2
-- 
2.53.0-Meta


