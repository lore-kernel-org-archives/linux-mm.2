Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 080B9F99342
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 07:19:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F2B56B0005; Thu, 23 Apr 2026 03:19:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A47C6B008A; Thu, 23 Apr 2026 03:19:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 592A36B008C; Thu, 23 Apr 2026 03:19:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 434D56B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 03:19:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9D9F31B819C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:19:25 +0000 (UTC)
X-FDA: 84688969890.19.E6D965E
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf17.hostedemail.com (Postfix) with ESMTP id E9C6F4000F
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:19:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fzJDdvpF;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776928763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=b5ucw1jsaiC+LU7Zn1moEYy2AT2i3WtwhP+YNxCDsCQ=;
	b=S23SOrODe3wk8hzyd4K0uOcJWffqgxg5w1IvY5PFS4CFI5dHGDpgB4ZBiTEMe/tGwxTul1
	N5jBNvPRiq0HcBKslglOLThqLqLQDUrnQv8lSD7NsLT8LAO/I89Mk3y4naE4rCxGB73Dmm
	3w5iemWBqR2H8Bs0nMw1IdKnKoxJxYs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fzJDdvpF;
	spf=pass (imf17.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776928763; a=rsa-sha256;
	cv=none;
	b=kpr8yjvQ9GbUBbAk5EmH6W158k7GYRbNWZw3YEECbxxYU/c+Ba2vvA8C9+MNqbAju0lG/P
	e3H1PojBgRlyxxck0qgu155QH7NC0ZUgWcRTHkSIm+d/+N72cQgMss3NHxuGZvfKMt/hts
	f2eS0z3nmhos8hYBT859bupequPwW3o=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-35d99bae2ebso5736792a91.3
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 00:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776928761; x=1777533561; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b5ucw1jsaiC+LU7Zn1moEYy2AT2i3WtwhP+YNxCDsCQ=;
        b=fzJDdvpFr41r0OLN3y4VPgSUAWcaGGCmfam4W3Cn3OXPhp7HsVNLqxrS8oUqNCE2X8
         w+OQnHfWEpR4B0DmbuS2KKGlp008FZ1ygp17nxPl4gt0fm77OGmxViMnSA2QjseUdaGI
         bA66WSWR0/d8+j7JWaerHa/IgpyUl5IzS8O7byKARO+yarMKbkX+3mVVMUTRPSeHLCco
         6RvaCc7bn3AjwqQxFSNFrY6yUWUjeRpreF/8dMyrbeCTJsJc2xhmvg64vDDnLfbezIMX
         U/yKlURWg4UbSCyAjjxZ+hl2te9qpv2AxjrL2NhK9k6K+4riM/VdlO7mqVzcAbND/ySy
         FwCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776928761; x=1777533561;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b5ucw1jsaiC+LU7Zn1moEYy2AT2i3WtwhP+YNxCDsCQ=;
        b=pCl3JTDaBVehAbpGViWgABFEyLk6wwfJFmmJDpkrwjoivTJ3zjgYKXXi5lVETkZLH2
         N4Z6Mk16Lj8IXVV/R68fXHDyfoRP5THBgohxs4KzKscZv0bterB9iEu6h/WzPHI+8Mem
         QVHRS2X2POOzd5YOMtpMPh1bgpEj2bc5mrs+LJn2mhxdT6S5y9rs+qVLD3Pr5N3er7AC
         1Z2Z0rmbB95rBc/I/H5poyb4B3efnLCu+4iO/dMf50KqiqmGKd2E9iBxZxpv0+Fx7o2C
         VHP+3jW8L9TTrrA8Hjt6PxB4bKYGNuF3Cxp647tp/P89ZqqKOcCbXbgp+8V/8Tygy94k
         NRsw==
X-Forwarded-Encrypted: i=1; AFNElJ9A9ZMVZMCh6tn3ml4eB5lXoe/rR65vEPMlN4gItYLOAwZxybur0oAM8k2LS5tTd/WvuY+fbrBBbQ==@kvack.org
X-Gm-Message-State: AOJu0YwjlqPR/J+ckxEYIGFdAwszkHb3Z8H/gDxuMRt07vfP+hBdAgfo
	RJY73H+MzJcx4tqgUcmtdckG/coNiKtYgzrfZ7icpSyrIFHEPmzjHSFIfZ1zK3yLuRk=
X-Gm-Gg: AeBDiesC6tuTUmge9dRk4nBcD96Tt3yaqESF+80ADBvoxJhHoNfvlntyP2SAvaEYP0r
	T4nhIyKDKjskXWad7OcLAcW2Sby0V7Gc44TIQ1OL0S4qBZ7UfBUZak+YOMV9M71OUF9iAgASCxY
	7EGnHv9HuZbY/SWQPXe22Wib+kLsjF/muZicxUCaNQl3f7+z3aW4TxC4Xe0mqpbmMB7IU5rTJ9X
	pLcsyz7Ighlc1Tn+IgvS3ch1K5CL6fUO5ZsbowcRRo2QGwgQWYNnJGhxrvIHAbeeuYQE8ph6ttb
	Vw0I0O69hXslSfOh46UQcNvG0JT1wAZ+/FGNzAOyO9Rpnx7vJjWuhNO4TOMaIqICHPn25sqYdjM
	O7+69HHc3O/pLfPe2o3CtuWd9sNw2uN6e/RJm6SQxJZrRkPHvSTD4CT4A41Iq8W5efWxoBjOJF3
	+8ZGGkhOUDbYnyFtAA3pS0SazgphRb4lWBUtIDEIfGtho6wUqTwuIjAw==
X-Received: by 2002:a17:90b:5543:b0:35f:b227:db86 with SMTP id 98e67ed59e1d1-361403af6a5mr26477355a91.2.1776928761356;
        Thu, 23 Apr 2026 00:19:21 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3613fbd970fsm7092372a91.14.2026.04.23.00.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 00:19:20 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v5 0/6] mm: fix vmemmap optimization accounting and initialization
Date: Thu, 23 Apr 2026 15:19:05 +0800
Message-Id: <20260423071911.1962859-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zqbbdb1ck9kw58tdyj4amyqanjr5rqxi
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E9C6F4000F
X-HE-Tag: 1776928762-806056
X-HE-Meta: U2FsdGVkX19BZummF7qCx/wutnNPOO5X0HW4n+2MQUvXDHsnUU6RaBJ+Fy4ybXb+SOqzp0FCUkEAwq093GxhJ11ZCbsCrdq6q1xbEJRE27hD13SWnC2i5eiYR9hYFuIg689JmuSSbH7S4pBFHk039yjspmGQAT9KT05m5tyQUs/jVb+RbfncQzxzp1vdxVtIQbKPyN8hUeqyvOwBe4m83HSK1fOwIIF+MEz1XZt15SStCAeLXnbigwbbw4jgr3FUgZ66htW1yAPjBpoVRgtbbsDrMfV8BsIL6V6BzqZV5OAZ5QtHN5ufGnJsLlTyTwPeNdRcFf/gVYBscLd07IEIle7QNwCwt03PlODgqny1MUFSEnaiXnAPtPfxpr13L3LQr9YqZcUU9W6g6nwVRjjaieSHy832XiJm/UxOM3zPHetkjtf7dMO2UaHMK04Aj28Zk3wGTzUokU8wO1+fE2WLiLlWQjoFBg8bPwXUWHpwwqXPIebNe3N5jxuIaHwkhHbsKSNq8EGU2UuxYdKr7Z1jC4bJQGW+0Pb7a5NK/Fgx2td858rkj0SjvDk5XWsXxx842hUQLCq4xjuGUrwLQeGagVbrAuhaS0uvqDgnRXjEUK3sM2OEeF2FAIVGfZsqARKbQkxwQNIMmFqS9WJ7gZOSrIQqVkHasKqPi8j3MO9BNHIEEyI4MoeBisTXBMt2jVd2THkPs/16OIxUbsqB2iuPitIKN7dkhkIf2/kFGTJSVprusrQcSr+a15W61kmpoV0RJIPVMIdJ2FbTdqujUbj8+L+AELBARCslXH9BYEE1uKj/Zon+OrekS7U2ta8I1dI/s/z5oa97XpBB6P6/mxthoquRqB/ivPK+jEppZUk2hIKo6ZpnPh1bT9WfUTyWrXVZ7YOJvB16CsBPNTPnH6FuEFKHU7oQ4miMLab5Cj5L0/zKVewlXXI3S+Biitkupt5PRtFey7XY++iUSujoLUG
 M8Ij/SrA
 2C8S1nYAB8QmisbBsrX1ZP2NorRqHkg/fmoawLOu0plYIFl+K//fk/cHKyLpf5oaraPWkxS+FZtC8qXb0fN2Ik5DISsngENmgaa0phY89vko/O3TapwcsIfD5/vftQlQpkdpS+iOUKN92qOdXk+GfbhxRVUncD29H+cKccxpaw4yVb99rBr3WvGQ9F+iUfm4IsnU988MHMwuq7T1v/FkFoqXfPGOTfhk2v4dbD+M1tYvxTcm3qqv2skAsCrUsmZBIyKiyJ3g05NtvP69Wm9/6ce9YxCOwVNSYRELh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The series fixes several bugs in vmemmap optimization, mainly around
incorrect page accounting and memmap initialization in DAX and memory
hotplug paths. It also fixes pageblock migratetype initialization and
struct page initialization for ZONE_DEVICE compound pages.

The first four patches fix vmemmap accounting issues. The first patch
fixes an accounting underflow in the section activation failure path.
The second patch fixes incorrect altmap passing in the error path.
The third patch passes pgmap through memory deactivation paths so the
teardown side can determine whether vmemmap optimization was in effect.
The fourth patch uses that information to account the optimized DAX
vmemmap size correctly.

The last two patches fix initialization issues in mm/mm_init. One makes
sure all pageblocks in ZONE_DEVICE compound pages get their migratetype
initialized. The other fixes a case where DAX memory hotplug reuses an
unoptimized early-section memmap while compound_nr_pages() still assumes
vmemmap optimization, leaving tail struct pages uninitialized.

Changelog:
v4 -> v5:
- mm/memory_hotplug: Fix incorrect altmap passing in error path (new bugfix
  suggested by Sashiko).
- mm/sparse-vmemmap: Rename section_vmemmap_pages() to
  section_nr_vmemmap_pages() and use two-tab indent (suggested by David).
- mm/sparse-vmemmap: Use 1UL for pages_per_compound and use const for
  order and pages_per_compound (suggested by David).
- mm/sparse-vmemmap: Simplify VM_WARN_ON_ONCE checks for better readability
  (suggested by David).
- mm/mm_init: Use two-tab indent and const for @end in
  pageblock_migratetype_init_range() (suggested by David).
- Collect Acked-by tags from David.

Muchun Song (6):
  mm/sparse-vmemmap: Fix vmemmap accounting underflow
  mm/memory_hotplug: Fix incorrect altmap passing in error path
  mm/sparse-vmemmap: Pass @pgmap argument to memory deactivation paths
  mm/sparse-vmemmap: Fix DAX vmemmap accounting with optimization
  mm/mm_init: Fix pageblock migratetype for ZONE_DEVICE compound pages
  mm/mm_init: Fix uninitialized struct pages for ZONE_DEVICE

 arch/arm64/mm/mmu.c            |  5 +--
 arch/loongarch/mm/init.c       |  5 +--
 arch/powerpc/mm/mem.c          |  5 +--
 arch/riscv/mm/init.c           |  5 +--
 arch/s390/mm/init.c            |  5 +--
 arch/x86/mm/init_64.c          |  5 +--
 include/linux/memory_hotplug.h |  6 +--
 mm/memory_hotplug.c            | 15 ++++----
 mm/memremap.c                  |  4 +-
 mm/mm_init.c                   | 34 +++++++++-------
 mm/sparse-vmemmap.c            | 37 ++++++++++++++----
 11 files changed, 81 insertions(+), 45 deletions(-)

-- 
2.20.1

