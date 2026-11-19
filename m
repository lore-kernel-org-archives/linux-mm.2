Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30283606A326
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 15:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=readmodwrite-com.20260707.gappssmtp.com header.i=@readmodwrite-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=k2hSrM1o
Received: by kanga.kvack.org (Postfix)
	id 328996B0615; Thu, 19 Nov 2026 10:32:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DA1B6B0619; Thu, 19 Nov 2026 10:32:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C8E86B0686; Thu, 19 Nov 2026 10:32:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE23C6B0615
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:32:04 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A44D140AF7
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:32:04 +0000 (UTC)
X-FDA: 85452259368.28.D6CBD98
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf15.hostedemail.com (Postfix) with ESMTP id 92784A001A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:32:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=k2hSrM1o
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795102322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KDh7vGX3oS8n9XC7mOI9LpgUvgIhwiDsFPziOjYHQwg=;
	b=YnZpiHu5vssnGmiRaoZgsNDC82uVKc4fxanJ69i5F9dmeKfmvMcGXYOorLA4zu+Iz10VkK
	N5l/IHUhzyRxmvOX3ZYWvkcjZdtBs3e+sEDMnNUgxd19o97DFzmWI9nQy9/y3W1MiuOglN
	xkZGr4yxZbygyNfofFfyeAl3B2D+XNo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795102322;
	b=lnYHFXPaJkA8EnX7UjBfkyDc81xIiZwzbaJb5NYYynxoCUpQR9GsDOWie7sTxDxnNvbYt1
	tXz+ypNNtT8LYrjTjxbqQHG3vo/g3OAAoMixaBO5y1ATHXlc6GQGfMtwfQZYy+Iiolo74N
	A2qvtVQpNo5WJdzCAdfXH5/TurOOj28=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=k2hSrM1o;
	spf=none (imf15.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.221.42) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso2202736f8f.2
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20260707.gappssmtp.com; s=20260707; t=1795102321; x=1795707121; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KDh7vGX3oS8n9XC7mOI9LpgUvgIhwiDsFPziOjYHQwg=;
        b=k2hSrM1oLFQgL8Bg9vUnJaWDsoRTk5Yv/mZlZfzjV1jezkmYQro663HFc7hOmtDICT
         fJMTq4z2SaO/T0PLwo5sMk9dPcYX8N/nzejOdgONj+qbUOM2JkLzLexrvqPSnnGowgD3
         HJUY6Uxa+wSFz38546Tvs/Pj2piOlUBP9qknNBhisOD65s0/97LlHcqVQGJwRkWJIaOb
         AWxYfcnZM20iQApbJnKJ8MXxyKRQdaCTxHYpSMuMVLqiLChNpn6wKUl6qPTY5EqE7DP3
         jAq5R7J9yJeNh0iH4TzL+CQRc00bQD1kJxdBO84rvsp98nj0Q9tsB6zyWkMFQpTqbd71
         8jjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795102321; x=1795707121;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KDh7vGX3oS8n9XC7mOI9LpgUvgIhwiDsFPziOjYHQwg=;
        b=bgofu2YESARoFQolZFQDJmXcJwlJ2s+cGzu1PHxECsDVMXIcCBC/8SDJvwjQj9h3bH
         0fz61czg4uw+EJAG2o8jHrRHWTNrhHIhXUyMN9UWGShIGc1vDGp26P0pfi8iba14fDEu
         teZ8mEO9BP01loCqXtBD5524PU3a0HaCz42JiFBkp2AgAHxn0Bo9As3zK53rarnyXY0i
         XkWKNLuo9I6OxzGU2EbL33OQzZXFf9CrNJiy3/WH10MkhSAyVUc+/yC1OIV22ua5H+AR
         2OMgzeijLT40RoT+ZdjSX3nAZuNiYwxtBSvJROv9kP1e5shvGysfI47/8ths0w5p/jgb
         R3Ag==
X-Forwarded-Encrypted: i=1; AL+hErHgaGtyhOG8CvJ6DoVbG0gppXpes5QlzO8rp2t1uMcUIEwXDz9/iLkb4imsj4eDlmRubqHofLFnpA==@kvack.org
X-Gm-Message-State: APuU4Z+CgAYg2Khxt646KJviZb+DNQSc/U3M2UqiKZZFHr4aTH0rzdHn
	A67erBiFIEDba4ugnnYrG5rkiMaEcfEV0FKR3Cp47ezUHlXGIKcxQ+XYzLyzhYMgu2I=
X-Gm-Gg: AZFdTZdFi/PmKPsFqRqW9WH1pXOOJ6ZB49cqUIyxNnIzjo/+SRXZZ9Fz0EJWK4J5Qhj
	ZCfmxb2YNmwnZQBmkz2QpCORvQp4i2l23FfKpuE4TRAzdMikxVh68P8UJeXWFYhyZSX14FkTJHc
	w+WP43MFyskINhDsFP73czCrKxApsa608WBDZbYPSVd3ypgTr80EuAnen/EmOCakte+wdMKhzSo
	4DbhRWtrzaRQA0We/DfmrY6+r79puTcWLdJxH/83MTXZWKT1IATK0twGkXVjXWGrkwvBL/LxaOv
	06y4P8DzQNETKiIHRTTZub7eUybHlHM0y1Z/38COB+ZkN2Jo1JwWq2F8+LrL+XJmAeGxwhF8n26
	AbNBiik3jq/3RNoxMIkt2JF36ZQm7IuimXnnAXaxLpTQgrxMmidcQiL+c86KIHziA45bVn7zB+G
	DAdm4jeIa9T9ogtNZVzylsUq18JL7IULtdFVZS/h/XTbOJFb6aS/HVMhvOvbqC4SF/AU0j36cPO
	d6bP1QueivdaV82a2DkqYfN9qWAWAkuRfRJXVjvrjhuTK3aI/ar2AN1ckLvu1mLekfevaWXOmob
	uCLY43PJjKgzUAyI7cyJsFE/RqoR2lNe
X-Received: by 2002:a05:6000:2484:b0:4aa:8fc3:2909 with SMTP id ffacd0b85a97d-4aa8fc32ab1mr3673377f8f.2.1795102320532;
        Thu, 19 Nov 2026 07:32:00 -0800 (PST)
Received: from matt-Precision-5490.. ([2a09:bac6:37a8:294b::41d:4e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab65cb41f4sm237463f8f.7.2026.11.19.07.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 07:31:59 -0800 (PST)
From: Matt Fleming <matt@readmodwrite.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Caleb Kan <calebkan1106@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	kernel-team@cloudflare.com,
	Matt Fleming <mfleming@cloudflare.com>
Subject: [PATCH v4 00/10] stackdepot: store compressed frames in stack records
Date: Thu, 19 Nov 2026 15:31:33 +0000
Message-ID: <20261119153143.4099483-1-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zkcwpbbgz9whpns9ke69ezbqdnkjer9z
X-Rspam-User: 
X-Rspamd-Queue-Id: 92784A001A
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795102322-315483
X-HE-Meta: U2FsdGVkX1/cInloN8zDVozjfxRMK5Gmaf+JHGlLUfY7bslMOrZxAgYtYvI7E5F/nMMxL/zJVUyuYsL4u1qf8m6u5/5VZKmZj3kOEqEmFCYk1Z+JDSYIyWgPAyBFk893tQWwyJj86vr7eBW6ML213Dt86ju47PrU5qieYSx31ORYEY/hwaerONBg5hUJgDMxHOHVo9mtNQsg/FHxe3zRKKSs4S3146ynge7xT7RkPcc7uv+uyP/6zFSI7/Tj4zOPp9PghqBvdGbtI2nIzer3hyg2xOIODisBpZPqW+5WsYZ82UizXZ0i7pEfibpzNzMfz7slkc22H+ubErDkJdCZ8mROWw9m8R2bXVmR2lIyAiKO3iUOOwAuRCwKce3P2kae5gQv+Ss5kdum0tIWHRAVSbsbOad+GanUvJjHV56xqg1Y5nSIHnLjYHoPTYfbj9xGxbLhrgYvN1uuT01ZeghlSoEpqmdnue5Y2qwgfzfZv9rOQmY37dQSoOoQHf8BrhA0H4XcaIjDxMMPYE1rlO4OHvi91BtfaQquad16veXMx8p9FQ3eyknqmxxwPyNRoPBuEHx8CwyNh5SeDmZsyQqMWQRviJ+kR20PnEElCWsG8upPUnJoJ39iiPm+ly68bd9ap8FZ84xB72OnpOqhQNfvPiSZBQYqm3Iu4FhC7FBMUinNdz9FrdsUk4u/ZibSxL/A6bKa7eEY8HqJt66PHosfbgWjcNBZtWFYTqw7ZMDWdnRKaPYOgvtx78O34nkGxcTO5oEQXIYFDFty92fTmC8HHNiaScpwXJAsgl73AzCB1m4kFerWYY5fmTPYYYcqh/R6BT9Yqz6Wwq2vCTtSJfN+9YbmseBPIcqJjQ9j/gxaVksVHf4AzQ9BbG9rhuvuk1Uwa/7RseHDOYVPHyezCzYNeSmpQeJS3QsbSRB3Nb4MAjNMKRFUXGxzZN6RYtmPhmFANaJTHdILgzyqqx9ZQYq
 LC89sLdy
 UULSOe79YtDnT24mNzG15etyauvTw6gdUexW8Swny5/W7U+077S6vJLXFfMX0I7HV9bIO8XEQ90Qu+KZB1XB9mBDbuUjqZLBxU6MzL0ueZ1hlhBhlMsAkmnnlHn59PTJN9AmAINDhhSi83h1VsstLRxKEaw2x8du+64oftMV8AvDX+3EMWCUjNi5vCqDgVLdMl3aY+trJ8k00xbor5lQTefro1miPcQnMIfC87GYWxbKO8zQsNOhiDU1IaZX3ItnnaaE5aFKRzDhsJmDlz150k3xXDqnzIJUw6k0v/UMsPWG3IdcJkrTOiHMS0pC/I/B+G9s2A08CuaDc5Cp8tIfICQxFV2EZw1ooUCM8pW+91egGC6eh/8J+GnSmdjCvrLhxBsgcixnaV2jv6KddEqeYCiQQpifEfUtAmKe5pxvNNWdmWOHXLR2KYnAPaEkoEi5jxR2vOcGcAMcI6/Mp+tFyt0gFaMsRdtreqydw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Matt Fleming <mfleming@cloudflare.com>

Hi,

Cloudflare runs KASAN on pre-production servers, and on some of them
stack depot keeps running out of pools even with stack_depot_max_pools
raised to 65,536. Once the depot is full, new persistent traces get no
handle and later KASAN reports lose the allocation and free history.

v2 of this series tackled that with a trie that shares common frame
prefixes. Marco asked how much of the saving came from compressed frames
alone [1]. It turns out we can get a decent saving with just frame
compression and none of the trie complexity.

When every frame of a persistent record can be compressed with the arch
hooks, the record stores 32-bit frames instead of unsigned longs.
Evictable records are always allocated at maximum size, so they stay
uncompressed.

On our production KASAN hosts this reduced stack depot pools per 1000
stacks by 41.5% on x86-64 and 27.1% on arm64. arm64 saves less because
we run a lot of BPF programs, and their code lives outside the +/-2 GiB
range around _text that can be compressed.

Compressed records aren't contiguous unsigned long arrays, so callers
can no longer borrow stack depot's storage. Patches 1-7 move every
stack_depot_fetch() user to stack_depot_fetch_into() or the print
helpers and then remove stack_depot_fetch(). Patch 8 adds the arch
hooks, patch 9 stores compressed frames, and patch 10 teaches the GDB
helper to decode them.

Changes in v4:
- Write *frame in the generic arch_stack_depot_frame_decompress() stub
  so callers never use an uninitialized value (sashiko).
- Use the address of _text in the GDB helper rather than relying on its
  debug info type (sashiko).
- Rebase onto v7.4-rc3.

Changes in v3:
- Drop the trie backend, the stackdepot.trie_enabled boot parameter and
  the trie KUnit tests.
- Drop STACK_DEPOT_FLAG_COUNTABLE. page_owner reads traces with
  stack_depot_fetch_into() instead.
- Remove stack_depot_fetch() now that it has no users.
- stack_depot_print() and stack_depot_snprint() decompress one frame at
  a time instead of copying 16-frame chunks.
- Store compressed frames directly in hash records, using the u16 size
  and u16 flags header layout from v2's COUNTABLE patch.
- The GDB helper decodes compressed frames instead of rejecting trie
  handles.
- v2's patch 1 landed as 8f56ea8e0706 ("stackdepot: stop preallocating
  after the final pool").

Thanks to Caleb, who wrote v1 and v2.

[1] https://lore.kernel.org/all/CANpmjNMP=NdD8ZE9rPwikUBcLwc8V=J648X05YGPn41yAZ5hmw@mail.gmail.com/

v1: https://lore.kernel.org/all/20260817-stackdepot-trie-v1-0-53870ca1651b@cloudflare.com/
v2: https://lore.kernel.org/all/20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com/
v3: https://lore.kernel.org/all/20261113185702.1332171-1-matt@readmodwrite.com/

Caleb Kan (6):
  stackdepot: add caller-owned stack trace fetching
  mm/kmemleak: use stack_depot_fetch_into() for leak reports
  kmsan: use stack_depot_fetch_into() for origin reports
  mm/slub: use stack_depot_fetch_into() for owner tracking
  drm/locking: print deadlock backtraces with stack_depot_snprint()
  stackdepot: add architecture hooks for compact frame storage

Matt Fleming (4):
  mm/page_owner: Read stack traces with stack_depot_fetch_into()
  stackdepot: Remove stack_depot_fetch()
  stackdepot: Store compressed frames in stack records
  scripts/gdb: Decode compressed stack depot frames

 arch/arm64/include/asm/stackdepot.h |  37 ++++
 arch/um/include/asm/Kbuild          |   1 +
 arch/x86/include/asm/stackdepot.h   |  37 ++++
 drivers/gpu/drm/drm_modeset_lock.c  |   5 +-
 include/asm-generic/Kbuild          |   1 +
 include/asm-generic/stackdepot.h    |  20 ++
 include/linux/stackdepot.h          |  45 +++-
 lib/Kconfig.debug                   |  16 ++
 lib/stackdepot.c                    | 164 ++++++++++++---
 lib/tests/Makefile                  |   1 +
 lib/tests/stackdepot_kunit.c        | 312 ++++++++++++++++++++++++++++
 mm/kmemleak.c                       |   4 +-
 mm/kmsan/kmsan_test.c               |   4 +-
 mm/kmsan/report.c                   |  28 +--
 mm/page_owner.c                     |   8 +-
 mm/slub.c                           |  12 +-
 scripts/gdb/linux/constants.py.in   |   5 +
 scripts/gdb/linux/stackdepot.py     |  23 +-
 18 files changed, 651 insertions(+), 72 deletions(-)
 create mode 100644 arch/arm64/include/asm/stackdepot.h
 create mode 100644 arch/x86/include/asm/stackdepot.h
 create mode 100644 include/asm-generic/stackdepot.h
 create mode 100644 lib/tests/stackdepot_kunit.c

-- 
2.43.0


