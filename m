Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E60A2C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 12:10:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAD4E6B0088; Wed,  2 Sep 2026 08:10:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E84FC6B009D; Wed,  2 Sep 2026 08:10:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC19C6B00A3; Wed,  2 Sep 2026 08:10:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B16B06B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:10:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 761C91401C6
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:09:49 +0000 (UTC)
X-FDA: 85168703298.13.7B2191F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9E58680005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:09:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SLbBBDWA;
	spf=pass (imf02.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788350987;
	b=v7oGRKcBLzbV6cPqxamoP0aYzGW0RN+KiYzJGa3YucpLBiEHFMvNfNcL2adm5xcshEDOn3
	0OyqBBKGtdE8F0awbG/5r7PEjhCv3JWfsjsLGhOpZxRvPjqs16AQsVp/7RWXe7I99bdbj/
	nCAKC+LNyrP82bDn215QcxIeyd+MrEA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=SLbBBDWA;
	spf=pass (imf02.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788350987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cP0s2lBMktuexfTWJ837Y1s1U2/uA2ggRJJeR+y2zCE=;
	b=QZ4icztAS5dIH5QQZb5q2l/8GCFKe6Sv5xX/xznci/77NaTrllnkBOv6y7b1543X1yWNQy
	w6/jzDIkZcsw4+WbKCfVYekIgABM3itku0u3NwS9M0Gxdj70fCECsEnyftpR/aaslWMSz5
	VfKAj67VYOkrbjxZu/uWdZBw/qyrRc4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 027E01596;
	Wed,  2 Sep 2026 05:09:43 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B551C3F882;
	Wed,  2 Sep 2026 05:09:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788350986; bh=H3oSST3gZCk1h4h7AopyovjoN8fmMhkmuMRHfSSBHWo=;
	h=From:Subject:Date:To:Cc:From;
	b=SLbBBDWA3EUzbE1WwPeK8x3Gbuqqw9iCHep+fXzd1Nc47a35ZWjhGcYpUbw2pXq8m
	 Y4Jo0bYXcAn/DSPom6iKfacxqpAwIzuYftrw3B8myA1ZXxU8bUPXCyhF4L7ec8gkvM
	 mnSNjeEbT5VdnTBu+aGrT0B5D86hSZLhxmQ/GZkA=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v4 0/3] kselftest: mm: fix some failure of
 split_huge_page_test
Date: Wed, 02 Sep 2026 13:09:34 +0100
Message-Id: <20260902-fix_split-v4-0-85f03905f7b1@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAP4RmGoC/22MQQ6CMBBFr0JmbU1pByisvIcxptQikwglLWk0h
 Ltb2MjC5Zv57y0QrCcboMkW8DZSIDcmwFMGptfj0zJ6JAbBRcmV4Kyj9z1ML5pZh1jL2hrEVkH
 aT96m59663hL3FGbnP3s65tv1XyXmjDPdouSmUKYy3UX74WzcAFsjyqOnjp5MnqyQC1GoUmP78
 9Z1/QLOmZxp2AAAAA==
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3345; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=H3oSST3gZCk1h4h7AopyovjoN8fmMhkmuMRHfSSBHWo=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqmBIFQ9pKXUEX9Pc6r/CDC+Rs2HNX0jTNJYDmF
 /OOdd7TtwyJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCapgSBQAKCRBt1cPRWsUx
 MywtC/9Bg5o9hWFGdydX9wGNo5n7LsnG4sMQ15fNjJMi0WkDh4TSAGBs/Lxn03+m84dUsLGXR4t
 K7rcO6Ziks4LEm9I5x90GerUHeSr0zT6vGSdAJje2xi6GaZcIqfOs4fehIx9I9kx4UYzqxbYy9P
 QL8KFWv8zaxfPCdkD8ghIOEvgOE8NxgXOJj/U3s2NaEwzsYwMA/MDLzuFrD6NwRonQLxw+25okR
 3yViOKvAI31FQMGBvL9XaG5crS4yVrx/QsiI1EXXkHO8JGK4l2LBrXp1XMGDP6HQkaayklWYVSH
 xKKa8mTETJTz39zQ9TDCHMI9JGc9Co8Cls38xFas2XpUBLbpx4Fu8nCbpct9NEnVH6SYOd6FR/e
 8mMnCGAFGRoBOhGxncsqMUsVRdc5jkRX52Zi34jbi3yO6l5OKKrrZxhKbeZv7uhmW2yFawtfwtg
 0EphkAqcWVA4ptAbxl5CxeKFKYBTALDm/51JKYCOR74i1YmfvPsQIPomH8MB0rGj8F+ac=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9E58680005
X-Stat-Signature: 4yj7e7g8h8k9dr1grkdca1pueshwxgoa
X-HE-Tag: 1788350987-620310
X-HE-Meta: U2FsdGVkX19Qqsd9//qCK/YCn28qpJxsWgqQbSyT5PNTOr77WPAx03NA21ccGAJ9v4zSCwzTU05DytMYivAlIrLoHzo1aw4Oj0w0ZbBKZuJ5luRn5BIZE7hkZ3D/hNDO0EfQEQ5dIouz1TUD/kwEwlx9zuR6rYRRuZzny0bVlcIEkXqpYCCcE+c5eoSTdufD0nyL4mXKiGSBCi39SOS2dXWEV2DTsY4B8B0gPeSwe3yivfs5Ic5dgzXxcLHHtWWC3r5bgg1QKwUQThmaH+zMhQUFrMNZH1nKEM5tnxnGDU+GRV0wfw4Nauoeqrkyo/hwRpDgJ+2uqKH5g7nWOoWsRTsk2NkfXWsmTmzi5kI0IbqHcnbgkoW0+ulBDG7j8m4rTAyO+s8p1CEz3m4fRakuqpQM6wXm50E/qX47XyyLB0XZrGwXVgbzxtWdlRNCC429WvX+iw/nQ7hIuuVGu8Kl68raN5+E6HMufOZ1VCjwb6zT99xc0qJ1CfCH8yiLwVSTr90h25gCvYbF+KNpmFQvwYGqqe0D0DyWQ6HVXh4ZDLWmFwjupFVwWtNdsXReZAQgsx7zfUMrjDjcqX5d1pxY7Cjce14w21KXy5+kH6+kwJzmtcuiYrXLK8DBvvF61zbR+GFvzE6wRXs0jA/llghNO4wzk65jOKAMH0SmUKUjiyBxgJ6KROIBAe5VL/gYP8kL0TmvnklKAv1104J+xYBiRa5Se9AnZy5d6u7N2FanotenkSiqMP5ZJ6/JiXpsngK1gtgyOFu/xKAnlaV8/3PgzTiOsqjjgo6TwssMGV6p07uepWDca10pPENjchFqDQbsZ437l+aM+3bymmTtlPqEXyR2lanpFxog2wv5+8YDoP8ae8mIlx1C0Ym0IxmagLwcE9kShEz/XY5fS4PpjtfiS1JGhmTCJu9ZD8XaEbYwvIaXDjNo9ixZQMX3SH4sqiEo2QwrnkvvxvT8o0MviBe
 ErmrciiP
 5RwszQFtDfdOWuYlN7Q0VUVjzdUfsW/8mXEYalIoKSkPyscr3rtBfE9xSR7Fwvk7j9DjZIMyL9P9M7E6lcsNzBpcQVaa/vUyNS5iD7CmrouOwinGZx+CWrepiWMMYfkFiW89xagq5HNcXn71piNlD8ygb+JZ4+FMxZqmumNVcb07HZ++mBluNQq/d2YRJxt6N/12NAnyXmGYgXbEnvwzl1ZDu3RUjpqSZhtVKeUgl4WIoGsc/B5j9hho1JUlNFjncjk0mhuodgsz2pxptvjquOBjOk0xB5mTnRUA4x/SZRmMoAtiRjTm33WNzq1kQggckXtRjawYBiSvgZs2VS7wGfEUrgi6fXaHbtCUO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

split_huge_page_test can fail for the following reasons:

  1. During the test, khugepaged may collapse previously split pages again,
     causing intermittent failures.

  2. Since glibc commit 321e1fc73f (“malloc: Enable 2MB THP by default on AArch64”),
     glibc may call madvise(MADV_HUGEPAGE) for sufficiently large allocations
     made by memalign(). The underlying VMA may start at a different address
     from the aligned address returned by memalign(). Moreover, a subsequent
     madvise(MADV_HUGEPAGE) call does not split the VMA because it already
     has the same advice.

     This causes the test to fail because the check_huge_xxx() helpers
     incorrectly require the address returned by memalign() to match the
     VMA start address reported in /proc/self/smaps.

Address these issues by applying MADV_NOHUGEPAGE after faulting in the
huge page, preventing khugepaged from collapsing it again, and instead of
relying on /proc/self/smaps, use /proc/self/pagemap and
/proc/kpageflags to detect huge-page mappings and large folios:

  1. If hpage_size == pmd_pagesize, check PAGE_IS_HUGE instead of
     using check_large_folios(), since only the mapping type matters.
     This identifies PMD-mapped huge pages.
  2. Otherwise, use check_large_folios() to detect large folios. This
     covers mTHP cases.
  3. Check the folio flags according to the type of huge page.

Also, current usage of memalign() would result memory area may
unexpectedly merge with an adjacent VMA, causing tests
that inspect it through /proc/self/smaps to fail.

Eliminate this potential source of test flakiness by introducing
alloc_isolated_mem(), which places guard regions before and after the
allocated area to prevent unexpected VMA merging.

This patch based on mm-unstable

---
Changes in v4:
  - reparse commit message.
  - introduce alloc_isolated_mem().
  - make madv_nohuge() helper according to suggestion.
  - Link to v3: https://lore.kernel.org/r/20260828-fix_split-v3-0-374022586a4b@arm.com

Changes in v3:
  - change  message in case of failure of madvise() with MADV_NOHUGEPAGE.
  - fix collapse_single_mthp (mthp_khugepaged:anon) test case failure.
  - Link to v2: https://lore.kernel.org/all/20260826-fix_split-v2-0-71153c7f579a@arm.com/

Changes in v2:
  - rebase to mm-unstable.
  - add message in case of failure of madvise() with MADV_NOHUGEPAGE.
  - fix wrong setup expected_huge in check_huge_shmem().
  - Link to v1: https://lore.kernel.org/r/20260820-fix_split-v1-0-ab430c58c7cf@arm.com

---
Yeoreum Yun (3):
      kselftest: mm: prevent random failure of huge page split for khugepaged
      kselftest: mm: replace usage of /proc/self/smaps for check_huge_xxx() helper
      kselftest: mm: introduce alloc_isolated_mem()

 tools/testing/selftests/mm/pagemap_ioctl.c        |  18 +-
 tools/testing/selftests/mm/soft-dirty.c           |   6 +-
 tools/testing/selftests/mm/split_huge_page_test.c |  27 ++-
 tools/testing/selftests/mm/vm_util.c              | 212 ++++++++++++++++------
 tools/testing/selftests/mm/vm_util.h              |   3 +
 5 files changed, 192 insertions(+), 74 deletions(-)
---
base-commit: e3b5239afe1b8f0194db7436b17c33e94c1988c4
change-id: 20260820-fix_split-f44939ec44b8

Best regards,
-- 
Sincerely,
Yeoreum Yun


