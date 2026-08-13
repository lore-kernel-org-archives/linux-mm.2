Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EEEAC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:03:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1CC36B046A; Thu, 13 Aug 2026 06:03:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCFD76B046C; Thu, 13 Aug 2026 06:03:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE4AF6B046D; Thu, 13 Aug 2026 06:03:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7DC836B046A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:03:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 042271205A8
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:03:05 +0000 (UTC)
X-FDA: 85095807972.20.F163B01
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4521B2000D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:03:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="ay/LPQbs";
	spf=pass (imf13.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786615384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1G3eQpvA85JuAZzs61f9HPusHslY0rOubeUY5om3sZ4=;
	b=rnuBzXGfnRUxaUUz0K2aflreWimF7rs29qHhmfzqA+2D5K6lgr2Z16ROXz2Mw2agbsWeJ9
	pBUq0I4xeMBPMoh71Y2zvDgmxN1/EKj5ONS3zid2kHuRdocBH3lEs2Htu2echzuKBeO45z
	opB2E0jt/sUMS3eLpCuKVAUau9M2KhQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="ay/LPQbs";
	spf=pass (imf13.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786615384;
	b=R4Sf0Zp+CNvvb8zkBbU1teipC4gsIOOzD/RmH7rDdiETnMecuEvsMRuf2UEp49XHH+plnx
	hDUjtDb5/ApUMAcgINkd0jGTA7ni/QtB97mWOBLwoPwHMWG6yD0wQDnj53jZz0AeuBKgH0
	yReDuPaIRIuEdjpTcJ4JwQ1Nz7XLjSU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:From:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=1G3eQpvA85JuAZzs61f9HPusHslY0rOubeUY5om3sZ4=; b=ay/LPQbsQM/RRgnxq7bAHdUMvQ
	f8Jw5AU1r5nZdi+WwygDbYVnhSRQiTpk6KnQ1TbMbn+5sMSSr4zM2sHdw73BusaAkR9xt3kwT2rLe
	HkRhn3grScRyWf0nAkVw8V5X+lClhsAwNr2BUSrO0rBT7xE8PCQjqsI12fSumqZouosXMnbFO37X1
	+NCJ55dINFEnVtfnNLiyuoC1T2KagbEG3AoV4M55JYbHs2gUKQUrl4viI8XEUFeT2eRhYbyGwWOKb
	ucpGw/XWYvEbyh6YFTBnX2rDR78EQ8CE8i6cNtmjv7bnnAa0a7q+qkPIgUiq/FulACSdMRo6QGVKL
	+pAUd05Q==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wuSGc-00520I-2b;
	Thu, 13 Aug 2026 10:02:31 +0000
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v2 0/3] mm, swap: don't spin or flood the console on a bad
 swap entry
Date: Thu, 13 Aug 2026 03:02:19 -0700
Message-Id: <20260813-swap-v2-0-4a625ccabdae@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACuWfWoC/13MsQ6CMBAA0F9pbm7N9ZQWOvkfhqHAAbcAaQ1qS
 P/dyOj6hndA5iScIagDEu+SZV0gKNIK+jkuExsZICggJIe1RZNfcTNU3QjHpq+72IBWsCUe5X0
 2j1YrmCU/1/Q5193+9C/YrUFz9RWP6J0ndPeBO4nLZU0TtKWUL1w1CNKZAAAA
X-Change-ID: 20260810-swap-25420f9c8ba9
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
 Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=4056; i=leitao@debian.org;
 h=from:subject:message-id; bh=P+JzP1CqEXHUFbZL8c3/vL+HspDOATmKqPkkB46OJ2I=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqfZYwoXTW5JqGMoaPfGNKdYcL8kANbO9Q4Ubo3
 flR7Y+Hk+2JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCan2WMAAKCRA1o5Of/Hh3
 bZy6D/9+FHGROjiGe5DGGfeuJczbW1nUEpKTdTwXe46MRshMrZZPN4KTb425BppzxmDgHhmbe9O
 lMR9pGroA3tkvg8EzRTIkCwLPNf1vV/tB+MDWUriJLOQfoYFwRHGI8YhQDdm+NlzNkkLeBemZ7P
 YUjpLqg4n4+m4z6cvyQ2EZllu3jId9C9Qr6a9BJlzLRKLWEnlhtZggto1Zkq7f2TH7A+DIQ9uyk
 7BDyHdg/WyQAdu6YD64uo0qh4aokah3GyE5EzYsexvSElNzUupfMo7Vu1MDQ/OHlFcMtWYC+A3C
 Qn1IbycDeMTZCJ5MB8VdC/NQq/jcu2L5CryvQeW/2Tth+Av5IzkaKqtYbd1IY7IOgLuGMzhDJ7H
 CpxGZ6t05Q5Vk4w5Ch34u3ctBJ7AxstISCwRVSZrJ0xP1IRykloHe5NzbmHyHAawtoXp5fcaU96
 a7DgSfEwnEEAyfrW7CNkvbBRFPu9nX+AFBiU9lzNjUED9uFm2xj5L0hYwwfNQyxTaQBrzFEECaK
 +Q0L8lsfDR2qGz8QoCbZ9+azG4WKeVV85ZUAQGhyHwAkUYf1AElEgHGqPGcdP73vnuBOqrnX9Vv
 2rt96dILyXeVFsv3Dilw+SlxPaWYpug4WKVxSPrU5Nmezt0zwwKboyZKasvJWK+yTw2mnZCtyJJ
 M7IowvzndkEqPmQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: de9rsgr6sufb8s7ghxf6adgeew1ncesz
X-Rspamd-Queue-Id: 4521B2000D
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786615384-107007
X-HE-Meta: U2FsdGVkX18VP2rQ+RnnHFWYJeLvhtbq+6NuRZ6UpmXoorW9DUjIwlFeJTdrifc+IXvNOvTiy/icfwosybw2caGLPpDO09wKtS3OzaKj8HNQDX7Hy4nKIG863TnSaqnts3wDda9/Or2n9kLAGkK9BYSayCJGsW1vmgzoZlud0RUDIGz23liHAyVWJ+HCcgb8fUOwxnsd2jWCDEKLcp9joh9QBP8arWnlgKlONOG4PD3f1u7i92j6tz6osToVGtlD6mTVQwR4gCtw2/PWxl8TfEqkMAbLJotrMoHzJ63/VeCW3AREEfGbQQLMtZXuVSDWl0aQMVsqZXkUTbmQvnU7W6jl6PNeYuXdg6ujeDGLfyS9wvbdZMUjrsDX69jQU0BTD/ttGlxQ05KE6wUZ6IbQf4SC1UvQVzRjG17dqFndNUm4U6zbhLh4DtaGb4OZAvnkzBa7NWHKf93/oYjxwpQm9P8RU2PatJqW+XGhXC/cNrXL9RXpwdKQ2V1wvI6IRyXIJ6QiA+6N+ehBds+mhtHa9O6XpreIeitlxT6kpBCRWY/m45z0qUyOPLQzb15GqYK4inbwSuptUm5CmhaAB0mhTF0Xg+9DUtWHvESkX4JFENXBmQ2s7Ll98iv3egtWIy1cK3bksG8CdarIYYtF595wFp4oeIq9cqfrfwcdYEh95r9fQZlaSi0WQ32w/VVmgwU9b4bfax7Edm4NR3KpXLFqYzy/K27EMYqIDXwKAXCXG0BM10Q8+qv26WAPcKV4pzRw4+zwkclsL6uc5aeNRLAZdXXE/4d5iMuPEYls9YA9vNUym3ZZshSiQf3oaAEasGfFa0At4P+aY1uxiOsMWQSgjOpdRmkvf7CyuvOYf9jRHn8jRh8eQoHGeSi/my9ZVFdLOn9i4RFRPYbzx3NigcXKKTi72MGFR0mhtGfkEPjKuE5fxpu9Q1qkM4D0XOOA1liUkqUBMPl5ooUX2Fec7KA
 F7q2Jbci
 qshVRqm5f1b/dP+E6nfCtQBsBCDY7z34kGX95lqU7RbmuNIU9+GXhnCJHk+gvUXjbAenfily5zE0E6DuekwXrLz7Dbt10UvvbKcgx1Wv1R6HbwPUTvequpr0DxhgPh3AsOXGxw7/Gu5EeHANk3MJPCoqQVyUD8aHEhA/lwFFHHd21xUPPZO1UJN/B8oPseHi2tMD3s3VRXMnMtaK/uh0x61+i15QH2wG+t92Zes8Dn7cflhqvgZPkMc8POp03osnmTRS9c3v2ZMWEpkaLVmodCF2vfYINLfm4zmIkCXlSOrZPKV1Gwo5g0BddbVZ+kKuIXLKHNqdMMbgwpj7jPqvXLPCl1Tvg14CcLlGMK5BrY7vqJ/XxDClHtePQhdqsbqPKEMnPvawsEFw9i6u0bh1pNEcI60CsBYgpZ01Fsy9u6p9aH47lhGUttqCEK7lLSVBJAuPCOr39C9fFQ5JRhyTIXigIDt8Ftzo8ySQ5x3Zj5WokJzD3nsxq3Zd5XDOGqhkyoVlh/aURPN1ARiYkAsQGO8QOZC3DGaOw/kafMnCZNsEFWiS0SOkgaOAo41LVO6dKmHb+7IZRlMUGYv/4aeJoeAJ+dHuJB+kAUDOAjKFi7eCO1030sm/QTv6a0fYE59N4RgPvp8QjnHECj6TTcWAs3qk8SbP1EpWI6VjhG6NsA/UmfpukUfmOZg8tMOOCVunIu4ZsZIzi6HRhLfPDFRI8tWDM1ih6FLmZzj2B60gYLhkXUZqdP11C7bx/lS75oIavrrgBpHhJ3KurzCs/kLFAYCfgZ4ISvwHHVniViaCSNFV8ZpGUtmkxX44wvvFU4zB8RySIqfEMsaewrkAyp4x7XyuQMrLoB/7YCe2T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I've seen some machines at Meta fleet that show the following type of
problem:

1) It gets some weird warning:

  BUG: Bad page map in process khugepaged  pte:f000eef300000017 pmd:00000067
  addr:00007f57c0a01000 vm_flags:20200073 anon_vma:ffff88829af7c340 mapping:0000000000000000 index:7f57c0a01

The corruption is most likely the collapse/PT_RECLAIM race fixed by
commit 366a4532d96f ("mm: fix the race between collapse and PT_RECLAIM
under per-vma lock"). But this series is not about this one.

2) Then it floods all the monitoring of the fleet, sending the same
   message in the loop, crashing the our fleet kernel monitoring
   subsystem (which is the part that I am interested in protecting)

  get_swap_device: Bad swap offset entry 3ffffffc043c5

For instance, in a host today it logged 6M in a few hours, and it is still
going forever. Two things go wrong.

1) get_swap_device() prints unconditionally, unlike print_bad_pte() next
   door which suppresses itself with is_bad_page_map_ratelimited().

1) do_swap_page() returns 0 when get_swap_device() fails, so the
   fault is retried, reads the same entry and faults again.
   Nothing in the round trip changes the PTE.

Trying to fix it in a naive way:

Patch 1 is super simple, and rate limits the two prints.

Patch 2 makes get_swap_device() return ERR_PTR(-EINVAL) for an entry
that can never name a slot on any device, keeping NULL for a device
swapoff is taking away, and converts the callers. No functional change
expected.

Patch 3 uses that to return VM_FAULT_SIGBUS instead of retrying.

PS: Sashiko flagged several pre-existing issues, and get_swap_device()
returning an error opens the door to fixing some of them.  For this
series, I am focused in landing the basic cases first and build on top,
if needed.

---
Changes in v2:
- Rate limit swap_dup_entry_direct()'s print too (Andrew)
- Drop "in get_swap_device()" from patch 1's subject, it now covers all
  three prints
- Return ERR_PTR(-EIO) rather than ERR_PTR(-EINVAL) for a malformed
  entry; -EINVAL is too soft for a corrupt page table (David)
- Document the malformed entry case in get_swap_device()'s kerneldoc,
  in patch 2 instead of patch 3 (David)
- Reword patch 2's changelog, "an entry that can never name a slot on
  any device" was unclear (David)
- Link to v1: https://patch.msgid.link/20260810-swap-v1-0-375ef0767206@debian.org

To: Andrew Morton <akpm@linux-foundation.org>
To: Chris Li <chrisl@kernel.org>
To: Kairui Song <kasong@tencent.com>
To: Kemeng Shi <shikemeng@huaweicloud.com>
To: Nhat Pham <nphamcs@gmail.com>
To: Baoquan He <baoquan.he@linux.dev>
To: Barry Song <baohua@kernel.org>
To: Youngjun Park <youngjun.park@lge.com>
To: David Hildenbrand <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Jann Horn <jannh@google.com>
To: Pedro Falcato <pfalcato@suse.de>
To: Hugh Dickins <hughd@google.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
To: Peter Xu <peterx@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>
To: Yosry Ahmed <yosry@kernel.org>
To: Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org

---
Breno Leitao (3):
      mm, swap: ratelimit bad swap entry reports
      mm, swap: distinguish a malformed swap entry from a dying device
      mm: fail the fault on a malformed swap entry instead of retrying it

 mm/memory.c      |  9 +++++++--
 mm/mincore.c     |  2 +-
 mm/shmem.c       |  2 +-
 mm/swap_state.c  |  4 ++--
 mm/swapfile.c    | 20 ++++++++++++--------
 mm/userfaultfd.c |  3 ++-
 mm/zswap.c       |  2 +-
 7 files changed, 26 insertions(+), 16 deletions(-)
---
base-commit: 6b8c8af514d739d0335f5579b585e02babe8a727
change-id: 20260810-swap-25420f9c8ba9

Best regards,
--  
Breno Leitao <leitao@debian.org>


