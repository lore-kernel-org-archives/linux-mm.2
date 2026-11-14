Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 713D2606A32E
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 10:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=MbCCt6FG
Received: by kanga.kvack.org (Postfix)
	id 941356B05B1; Sat, 14 Nov 2026 05:42:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F1D66B05B2; Sat, 14 Nov 2026 05:42:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E07D6B05B3; Sat, 14 Nov 2026 05:42:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5CE086B05B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 05:42:19 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D178EC03B7
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 10:42:18 +0000 (UTC)
X-FDA: 85433385156.05.8E3BAA3
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5E7FF1A0002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 10:42:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MbCCt6FG;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794652937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=148aWTr+MJXOnF2cH6V3oulG0+3oXARg0p2xHAe8Uo0=;
	b=DgtQ5OAlSx3Df+IHl3AxylmWvc29ZHVy/hnTv8D2Xt9O9BfvMET2eDOqwwfwaGJiO+tBuq
	i/wp/TVREiygys1s64CNiHYpjeKDR2BLJPmc5aIYaupG3swDDvUJWhbKJ4rrud/A61TOAK
	sANYF1hyB+5f6MOBRjjIUcJG7aCFNlQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794652937;
	b=IkEgq8Zn/rJ5uMwpz1Er59d/LiPqYe1pKzb6de+R13XcSqdgJ03inVGkmUILZ+uYHrDdDa
	Zxc1/dLBp4bfn7SVG9PStliHeUwzSBqQsgUnkSD61QSSCCrAFhTXbap9AWu6fV1AKUW4ZU
	SEL8fxAs8vC+MKcOEYknZ13O8sfEp8M=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MbCCt6FG;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-3720addb068so2949386eec.1
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:42:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794652934; x=1795257734; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=148aWTr+MJXOnF2cH6V3oulG0+3oXARg0p2xHAe8Uo0=;
        b=MbCCt6FGgDA52qiLiH/0f4hbq0KScBMT05kocCKPpDX2fF4t0YYmALbl2E3WPWc/uI
         TvibAN7ZI6RWI9WViYxEDVYXU8+REpu4EKgLUf9N5tBgXDmDDQ2t1n5z6AuREsXhJXNi
         ZJ+VFk/CFlFu1+1x6OjqYGIdCF3unIq1kygNnuKlWEw7lmjotHrqWrPM+PUQg1UCWhdQ
         kThrZF2G31vVAoCMdd3jw0eyGrXk4Mhwzs2t40w4nccMBl9CYDbdU6Lx9IOE+O4Xqpg4
         Gb8hG3rTq/etsL7Qog4sVEkBoqZj2AAW3Q6p0nPrq+zTxRIBPcINqspE3aZFfK7W6Ogq
         nc8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794652934; x=1795257734;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=148aWTr+MJXOnF2cH6V3oulG0+3oXARg0p2xHAe8Uo0=;
        b=NLgmYmKMUI2zEcn65yJH5ktEhlOZwr78Ipg7RMkJhX+INTQJtKc8OOYU7eKmX6GXli
         TWXL30xPDFfGnKwVPTfp0agE8O3nwPr/xBFAGTRxHJGn3iMk83pFcA2HCZM0H1Keze8Z
         2aH4r4XMDDQfPV9m6KqM2+vtjhhDvPfpQebi9g8h+p5XGkLQ9dRhGnJeSm6wCAtvUYFE
         kIvQgd//tnl1dNjknh2QIJJRaoPR/Grk9FqrXVLYlJ2QCKdXrD1sC87CWX9MaY4q9KOG
         4vNb0LQaiJ6DqX1ELDKr5bvSqALqT+gvXWFRnVEKmwAy2L6t99HX5OqM6wUBOgv3zBmj
         /crg==
X-Forwarded-Encrypted: i=1; AL+hErHWCuIe4rEzAoVwsFqrMU+yqk8KBbwRBO6R2g/O5gQJTuQZGjSf31fXex4QL8zY2TQa8U1/GYzoaA==@kvack.org
X-Gm-Message-State: APuU4Z+fFuhF46eHzZNPDGfDHgEiHqwG96ci5QQyXon1J69TA5cMG00I
	PaYeEVnRyOk103qU/RJsigmG5O9BaoFkUOH7XUIzLR7pi0b9MHy8Wxxpwz64tGekyoc=
X-Gm-Gg: AYBFou27OKEVVq77N3yV74b+mQikiwfLxvhk9fSS9WYgNAsWqTry17kIjOQ0psnB00B
	EAx0qx1NEfat42h6cdfkSvT1rZlSk+LSLfz1DKTsbxuWtbz+wQu/5UrvuSFZ+LP+x4yNmm0qx8g
	LhiL0TUuM2PAxV6Ek68Ix3h8OLDz0N9OQ7SGNGG62KHWSbyXjZJUuN82h/8MSeKMZkUcMqUrjHg
	FLNOZTEcYer82o1SLKOw2f2+fCuBbPF8jthucuR8eCQyKDLQo/vA/BBECBUj+wnKf6l6ZgMrpYK
	fZCvGdLz+0xaERR74gTua5/KpTaty+LIPpMIH+mIDb620ozvSQ/US/gZXtA9YlUeSXYuk7UMf00
	WPXJvdoViefNmpN3TlOry9C4Dn09+/UwouA6Pu8InA7uW47vLwg0FnTTpr08AplNb3723N94xZ1
	2RxW/W3ElhMr5HE8dyX0yc/p2GXOpPtJ2L1N8sH5NNWdjFqzTCz7AfIm98ZKFkIgiOzV5a8F2D/
	vg7S8wDT/owNBPg2FpTcci9QYNG+9xHkmr3nM04UUQAVwwMwez2HCi0Zd+mm66hUiXoBeEwjqiQ
	M58nQvA2lIgkCRkkmyLzL/eBnyZcnXfuz4xnz/krPJDw8cNKcoAYHEpnQZFukBf5wseKWyyS7k4
	reMpwPA==
X-Received: by 2002:a05:693c:4153:10b0:37b:e40:397e with SMTP id 5a478bee46e88-37b0e403d73mr1864427eec.14.1794652933413;
        Sat, 14 Nov 2026 02:42:13 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:9d36:3b30:f4a3:7b5f])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3795533170csm15772917eec.7.2026.11.14.02.42.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 14 Nov 2026 02:42:12 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Muchun Song <muchun.song@linux.dev>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Mostafa Saleh <smostafa@google.com>,
	Ketan <ketan.kishore@oss.qualcomm.com>,
	Usama Arif <usama.arif@bytedance.com>,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 0/3] KMSAN: Move per-page metadata out of struct page
Date: Sat, 14 Nov 2026 18:41:46 +0800
Message-ID: <20261114104150.58424-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: tf51m58ksc9bntbzjbamdxc5dshruzd4
X-Rspamd-Queue-Id: 5E7FF1A0002
X-Rspam-User: 
X-HE-Tag: 1794652935-800241
X-HE-Meta: U2FsdGVkX18IAoN2fzVz1k8DhvL0aMPumjuBoyCGDJKs5O55xZCdmZ0B6fBF4xFUOm69Zv9FU9a7z6sRmP7g6xOOm0orw4B6OZFD4lciIwj3JK2uI6CWg6+gKfV/enfgF0MEZKUZyJp4ddqhnEcvChTeh2th4aojve04yEwJ5BEMxZ7TVllyx1yT7ehO5AWQ+j90P6c3S3q4ThWo0KeTTsrsRUx/Icc8X6uLz83LHkc3P410oXQ8H1zc7OFyD/7RHZhUdId4EagDHWlBW8YiqQ93viuWAOwd/tvGCaFni7rW+A068t61fj9Ksq0HUumoKuDYc6Nqy9rBfoQuN3TFL9Cr9YvMSKvO6M4AgPvf+4zAqsk/WGGXY2RCu5Ag/reZAALwZzbj1EHXCgW4emFZtsFVQsLQExRq4M9A93Byug6EK/vwJKLeKeX9dMTj8f0V1Klh9tmZVDI4nmmVBFMNvehC9P/pTlIhq60Z/SJHLr2TsxNg5n8erZjOPpI/vg+s+8uzAkl28VSQrppL97WQ8n/y2UKDeIsedKMCfawfSGTnasR6g44dIIQ8ge65ID8g52gznB4f3mo0YXJFuYmNgdafH9xVR+YI2wLsKAhiMeeH3Wzt6gFKaYmkcDgaTCVMDaU06nmOba0vUCBB9siXj8H08zPBV1moIMkjGhKHrkajFJK7Q6APqyx51e8TnMOgRYpiHAe7fiBA3C2VGK3M7JW4G0sifooyvdHkF+LdeJOcA4lPZ9COfUfHVLNdNooUAykwm9EiExeKtcuXldV+I/2wuWEEhftczsFXzH76ldtKPnJZUiF+211CBm7fykBOrRcFoe0KtleOuPSb8va8OK308BSn/Ad3XkzJk9btEH5MNLh8KLKj6Ifr0fKC4HARvCCSm6J8Ih6q2zpRrx1pLGKmnFVDdGqWKa/swoaZQ0IzOAsDdvbUARIs1g83eQHJqzJfjNbrkCB10JfcjUZ
 UUeod69P
 vjnUwroVURZT4Uby2m0dYdjarHD0apGX8u/5hXwPzMAW/hccktFtcLo6icRiNpVGAADUmXK/RblM8B3n2YOjLgVNiZt9E0gys/iY6L+nOZwMYwRc3/sERjhCMunCIawz3eX6winRlEli7upmyLmxH+EGeJ7o9azslcsuz5ksjnZOfjsln5CDimmUH5FBTqrYMCdS5q+LT28PkxnHU+dFhH10GsCqr9vk8dP3h/kR3/AptZ0QxuoX2HzY/FS5SYF5UFy8deGTP+V9jGfevlcZaTi3FRoz1br+CfGkZ3rT0kvh9RHmaUMKc+jGd0ythi+CrCQxUIuhX+2elSNQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series fixes a KMSAN metadata-loss bug triggered when boot-time
gigantic HugeTLB pages initialize their page descriptors after
kmsan_init_shadow(). KMSAN currently stores each page's shadow and origin
pointers in struct page, so the later descriptor initialization loses the
metadata mappings and leaks their backing pages.

Preserving the pointers around __init_single_page() would either add
KMSAN-specific save and restore logic to the HugeTLB loop or make the
generic memmap initializer retain sanitizer-private state. Moving
kmsan_init_shadow() after HugeTLB setup is not viable either. Its metadata
comes from memblock, while gigantic page descriptors are initialized later
in page_alloc_init_late(), after memblock teardown and after the KMSAN
runtime is enabled.

Moving the metadata to page_ext is therefore part of the fix, not a
standalone refactoring. page_ext storage is independent of struct page
contents, so later descriptor initialization cannot erase the metadata and
the HugeTLB and generic memmap paths remain unaware of KMSAN.

The first two patches provide the metadata-access and early-allocation
groundwork; the final patch moves the metadata to page_ext.

Muchun Song (3):
  kmsan: encapsulate per-page metadata access
  mm/page_ext: support early allocation for SPARSEMEM
  kmsan: fix metadata loss during HugeTLB struct page reinitialization

 include/linux/kmsan.h    |   3 +
 include/linux/mm_types.h |  12 ----
 include/linux/page_ext.h |  27 +++-----
 lib/Kconfig.kmsan        |   1 +
 mm/Makefile              |   8 +++
 mm/kmsan/shadow.c        | 120 +++++++++++++++++++++++++---------
 mm/mm_init.c             |  11 +---
 mm/page_ext.c            | 136 ++++++++++++++++++++++++++++++---------
 8 files changed, 219 insertions(+), 99 deletions(-)


base-commit: 6ec534d64f85e949a5d58070678dcd7711875a7c
-- 
2.54.0


