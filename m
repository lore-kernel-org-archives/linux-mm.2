Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 400CA606B635
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=readmodwrite-com.20260707.gappssmtp.com header.i=@readmodwrite-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=onJLlDP8
Received: by kanga.kvack.org (Postfix)
	id 494E46B05D1; Fri, 13 Nov 2026 13:57:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46D676B05D2; Fri, 13 Nov 2026 13:57:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 334B76B05D3; Fri, 13 Nov 2026 13:57:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 042626B05D1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:57:09 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8AD6C1A0124
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:57:09 +0000 (UTC)
X-FDA: 85431003378.21.DDE7F58
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf23.hostedemail.com (Postfix) with ESMTP id C4ED614000A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:57:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=onJLlDP8
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=e1AVEuQ7/0Q/MGJ9DZTfOv+grpHr5U/1zcdAaccW6t4=;
	b=iMLuakfccJH/xKIJ/DBI97aoAioaQBZlx0As2i9aaIqXHMtthBQZIq0gCWkC9TEy6RvXp4
	hxExMXYDoeU4WtkfIcHGhNt9Q/ct1H/rqm6uWtrmhJqpeNaqP1beZQ8na2+cpNJJaDaimo
	8DDARSDjpS5oYych9SvukRlDqBrn+wA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596227;
	b=N7dy0ygSugEkkB6At1v+R9x1UDnHFnuvdlCwMW98VDW9tHHCaSkC8Me8dcXnF/vjotINnP
	IAWHWaAbNqQWukNNxf/0JtjsFL2qhRA4gxZlh9af82xW7FZNaJ9M/PErdUFb3+g0JYWLiy
	kDq17ILOSUwM5m3JYtInUXQTubQNKt8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20260707.gappssmtp.com header.s=20260707 header.b=onJLlDP8;
	spf=none (imf23.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.221.42) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-49465892f7bso1306280f8f.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20260707.gappssmtp.com; s=20260707; t=1794596226; x=1795201026; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=e1AVEuQ7/0Q/MGJ9DZTfOv+grpHr5U/1zcdAaccW6t4=;
        b=onJLlDP8sYwiNv4wiX8/SQ+djKAvxkUThPP71KCiWIVKUcrTHKQBgQDiLhuynmYQt2
         W8OzgtoOohYQloikyjciYjvZFVW+6+QauqeoXOZyJFZLnoTvDkdATVf7JwhZvAKEndAU
         F9MMhs9vec5eK/xEwRorI7f7DmXn5+cA6XEHmryn3Pn1Z00NEvMgYxBeSGM8Z0L7yiAZ
         EhZKIyljZ/EMNxIaB6D+8vUvBloEl+ZvQkbkhD0m1LFDI0hTH2EcHXIFW30VuoIp4CIG
         CGm3dZyro2EcL8XTrNGbTlJzj5NxS4LTkhb6A7I9/YsXhAWWckmmmHb8W8e4f+H6zGxG
         4Snw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794596226; x=1795201026;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e1AVEuQ7/0Q/MGJ9DZTfOv+grpHr5U/1zcdAaccW6t4=;
        b=u+61KurdQ+F3eTiAn6LHG4CXrFbSZCdyubZ1L5xUuDqNRQgY/ihdpraznNLmncG38F
         V7I4FdT9l6j8mHLBqRULBJtiqSYmyR5R/8VMwOruIBOcmXR7HT3L0/DAcYoDw6fh+HNK
         bO+oNveZL8C5/gF/i1IJrKclHdlzFpw6O6T3bcQqqSYrc6KSq/iU2Osnczaw75bM8jHJ
         /o1CZrqVTcCbjpm3fGJ3ojhcKudTQZiUplfossREeGO+9UF+K7udEOytBnA4jmVPP/00
         ojUwS3cv0xpbW1FJnSeWEqs5OH3yUNLF3w/2VkNTUFkLCe6wyt5l/xisVL0c34ygcLmv
         x1DQ==
X-Forwarded-Encrypted: i=1; AL+hErES7jWZHRQfjKuf7GVG/LeRzIhOBF/Xwd5gx9xwuFI/xCPpsi3xWzsPO851tiNSvfzGIBuENZlW6Q==@kvack.org
X-Gm-Message-State: APuU4Z+lx/lU9QlJL+hqcFj8tc1dWN9EEGvgEA8apcfglEKb0yPCD34K
	c/IphNOaWOhnCBWSHRWb62/UDThkfl96BFXxzNQr5bnGi8kz8jjlqyV9PEDHsFAvQr8=
X-Gm-Gg: AYBFou2Nvn3WDytj1gNzpFxhv9X5K9NSm+5iPyGVlMj1OAi0vB0NM9J4y7YAoMPqaUI
	sUfMqYyKq4zREWIz7+YbH6V7gwTDPxNKEWJ9xo9JIUtDsP12uWX7/63jMzuwsDri6ulgPCq7cSo
	jk9nbOTVlLIsA9NDKcpzAIUPOVe/WLyqOMOxYmngiyOTVnp/c8ZPlmbfxFup9kVp7QkmrzvC6ho
	CsTApWup5hBWNzOun7/LkZOU+Xr4Dtn07qOyvp7uPxbw9xXQHMcHmQ0nfrOpXnn+AjsWSOjj7rm
	ryckYd6WltIrVyDHPRxTJ6yUScWfCAZNCuZD+chNn92B/lDNCfWCQtnuoZvjKzzgS8mSbOkXOIU
	a7zqxZXe4Nmh5qdS6cvlo47gY79w0XXNYl8/Wwr9nG27fj8OUqa0gOlQ4npnGSn1JoDuUZg4bMr
	7T92wMz14eUfTNGIL3ugmnA32Ffd2A1frARCBuUhArPM6RkVH+tt1q8luTRhosQGqBCciZ6J1ZO
	MMHQZSzrMfSaRdz0215MASzkD3ypUvI3RiftBaSYJud9hhm4Jze0MtSUg74k18e5a121h6HQStH
	Cy18y8nbnoe9h8T+xq99DlII7ggAtg==
X-Received: by 2002:a05:6000:4559:b0:487:27f9:834 with SMTP id ffacd0b85a97d-49c725e5a73mr4785615f8f.41.1794596225990;
        Fri, 13 Nov 2026 10:57:05 -0800 (PST)
Received: from matt-Precision-5490.. ([2a09:bac6:37a8:ec8::179:1b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5f5972a7sm6417589f8f.21.2026.11.13.10.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 10:57:05 -0800 (PST)
From: Matt Fleming <matt@readmodwrite.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Caleb Kan <ckan@cloudflare.com>,
	Caleb Kan <calebkan1106@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	kernel-team@cloudflare.com,
	Matt Fleming <mfleming@cloudflare.com>
Subject: [PATCH v3 00/10] stackdepot: store compressed frames in stack records
Date: Fri, 13 Nov 2026 18:56:52 +0000
Message-ID: <20261113185702.1332171-1-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: n3zspfa9wkqt85os69oaspfcyiozpi5w
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C4ED614000A
X-Rspam-User: 
X-HE-Tag: 1794596227-263098
X-HE-Meta: U2FsdGVkX1/dAeDqPkdt2up4B7AjSSoBBhr+R1Orallm0IVBkvif4fia9XsRiq2qeGhO3VCZu+lNkKl8qbyye90NQbV/FDNbGdswAHDtX6bjUB3OMSQwhUxJeR/AQxy0IBSENC7qy5YnO/V5uYc50gEdALOuyTHTHjXC1rrIZxOCEwTF3oBFWidkjHWK2h0eEc0HTEc+y3ngLOXpFIQ0mn3j9chfjf8+wr/vkPyeWa3Fd+IyKnyy1Nc8ST6wOZUBqtj8VNQm/G9QyUxzbuTBQSQ57dI9x6EJKcnO+V1/387C5++JiOVh01UxPqiX1QpPI/U7E0WdadzA/nx4CxyDYdu0XFOEjGSHjeujNpUvRPKudh3FlhYe0ZIUI74FrBtGJu4Djb/VsVJlD0xJEaKGfqbIJcIJ8ldNW2UdOCT5taUgh3gHSSR5WvpTzm36DiYBfEx1+uSHY2QJxqL4gS9XHD7J49VCNEdB6cAbTkSAWNMYAtQCNGqKJDB+vGdJWBzA3d9IXnZoabxkXJZ5UrUjlBiC8P1gExKOui0XLFDU/kkaPCkdliWCHynPo1U2y/pPoYHcyTpKMDUpfCqTz+RES9FqZr2FJtQtLDGZgAZnV3pLfDGktFWcqgKbwiT3aa3/kz8YPlal8DCaNtpTi6/1/0GZ2Ug7ZrAXcwIpiarfuRdYweuxqI7h6rFIYNNhnmhO5VyrdYyv6V1osog5dcHEhXAK3f0j+459Rsb+oWNStm5RqlJHYc+X31937lWAwHDvU/efuD4NqW/t++2jSEGjiqDciF8teS/pejTJJGfm4c8gAzlGjp5QzjwoIAG04EdHs8AXDsgDSlvIkxkswy6+Kfz2wqAwdhny8hb2CqrsHsvq4tyN5dZcKBX86OBOXOOSf5tGutzi9fV4prp7qyzmFAjxml2WZDXa0+q55JgYjTTUVwCsNz1j/2xk1tmGwFV71UcTbLGQNf8hn06vzR2
 7Zjqmvo6
 gPlSd/bZcekvKkzGyizyo2ptskLsfIdgczB1W1GaF6gREte365yTHmEJI2AefPFFc6wA1sOThiFn/i9p3sa9kWYEE/ESWHHNpSXa54YuMSBUbeVrxDtglKcD5RZVFhBR0TWekWSRhN2nsg2S4Hspto3MEPDtZF+fqgmvOFsD0oaG1Lngo+Axhbl93fp5ci6vuVkgMOgJTXHmwBCFluZRbZ6Od1tEopvcOqOX3WNuAQYijO5aseQ0XbuhfA42seJ1IQe0Eu8QGZs7wAEeWfz7bmI31EYwx2YwQgWXtDpkL9OMNHkkbKpAs0berbl5LFfWGMWnuefp088vCoOl1GXvYdeuab7wrdQ3spotyFjB+Fvw/iRnnDgXD9nm482Yn6IGDxz37LipymxfQ/RUrVlwidZ78iHpcSYDrkK9IAnwfEgkyJLrxv+RKi34mPpfBnumsw8cw
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

v2 of this series [1] tackled that with a trie that shares common frame
prefixes. Marco asked how much of the saving came from compressed frames
alone [2]. It turns out we can get a decent saving with just frame
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

[1] https://lore.kernel.org/all/20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com/
[2] https://lore.kernel.org/r/CANpmjNMP=NdD8ZE9rPwikUBcLwc8V=J648X05YGPn41yAZ5hmw@mail.gmail.com/

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
 include/asm-generic/stackdepot.h    |  19 ++
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
 18 files changed, 650 insertions(+), 72 deletions(-)
 create mode 100644 arch/arm64/include/asm/stackdepot.h
 create mode 100644 arch/x86/include/asm/stackdepot.h
 create mode 100644 include/asm-generic/stackdepot.h
 create mode 100644 lib/tests/stackdepot_kunit.c

-- 
2.43.0


