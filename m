Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E10FC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 05:59:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CED16B0088; Fri, 10 Jul 2026 01:59:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67F6F6B008A; Fri, 10 Jul 2026 01:59:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5966A6B008C; Fri, 10 Jul 2026 01:59:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 372896B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:59:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B7D2FA036F
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:59:28 +0000 (UTC)
X-FDA: 84971814816.03.2315860
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id C0C8B100004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:59:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OpGnhiW3;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783663167;
	b=12EswgcjIF6Yp4FgpX5+rnfyPdA+BOWQEROmDcAeuHIxdkYpEgiWwnszo+OHmWYjB27Gc3
	GFEqIFq/xBczpJq62Mdx2ZFBsfVyHSYbGeBsgk4GgWegIB0ybcMwmtQyk1QKLv44rTy1Z7
	iA3LeqrMsm6ZchN+WLbtQ/LMy65CH7c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OpGnhiW3;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783663167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=N0KqrSwN3SVKkkIxLspvsWOxpGNQZWe21Nn2cvqwi2U=;
	b=R+cdkq7bj2wAZ1xrFcGDBY0quhQFfa4CqJuLs57o4S90PZq4ss445ouSEdmSV7zziChUuz
	AycJcLVF4Agi5bmqXIpuMv+GJPYXXtyYGzSnu8BQO52hvZZ3WQcGAUnDTt4eGW/MdFoS4Q
	x1GbgMUolMsCjFKj7N9OjMdiJZedCLE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 51C6C1476;
	Thu,  9 Jul 2026 22:59:21 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 46EC63F85F;
	Thu,  9 Jul 2026 22:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783663165; bh=Hdg/tLq6AWtfKBheXabe4Hz3TQClVfuMhfgdlP9/4jQ=;
	h=From:To:Cc:Subject:Date:From;
	b=OpGnhiW33CuvRMljgllb0taozw6+R+0ep/mt8W9tWgbLEeLtvTT1Sdn70wdZ2oHfL
	 YrP8Y/LtKtLGW0CY4miopWz/ayt8UvKwr7x+REHE5cpmoZI8fwwvee836LxDLj6ymm
	 xN6nSnYjiOFF59x4yrbyq9nl4c6qvXl7b4EUZ7FU=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v2 0/5] mm/rmap: Refactor try_to_unmap_one
Date: Fri, 10 Jul 2026 05:59:09 +0000
Message-ID: <20260710055915.638659-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C0C8B100004
X-Rspam-User: 
X-Stat-Signature: o4ue6q9fw9fwstc4jjqrtia7srtecip9
X-Rspamd-Server: rspam03
X-HE-Tag: 1783663166-159721
X-HE-Meta: U2FsdGVkX18KSDvlhm41NmYC1Tp1S9pH27Ytvbv7wJ44GTERn887o5jdYiJIh9cO9xXQasF6ozD1mvz2/bSAtxGkhttuQJkRtdw9j8tR1WXhX73JA0DenSdTNCGMebOUj58Dt+YeJ1EjSHLAgxH25kx8R72eFobICAG4YhTREzbjaAnevkySKXTcoykqVl2KjgiH1Gk4GMt5uZsMAoLhPh66iBs67AoRmiS72UlHSkoQND35WnHiYLBxSrlTR4mA5LRxHSAqUKaEn01CV7Afiegl2ubVSghEeMbAlcWX+2WWzOaocJeUmgAhoXYT0PoTTsLZ3EBZuq1jMGQq9MmuaVpbeysSc5Df5BuCxE39VMEqF7hC/k7IQCtVNiwWyX8ssQyp6ETNIA5oypuzc/sHzHEah+4r4BceGWE8cyKDGsZ8tz/Y0tJh7S3xtL1UIdco6Ny44/DKXoFJYXDRs5W/2mXntSHZTQ9LKlfZmUXIIo5eBL288VXon7jN6k2fKUZbndkQVvZ6ZSneU1R6pnKG07gkBRdsBmCkwT5upNEW43C0JpX+6Nr/wPyxk5bcyhB62wv3hXQg0gHEXRk8Lb5e68yMfF4a3KBDCk9t93UAkYhxxRCJPYbILkKT+W31c92KHf+QGUtjmgjEEtSIDeJ4kNQYQWNNjqtCz8REDg+JGEZOiRdjrUNvnn+kq8tznRASWH3bFsnNQ9Y0AgTAOGmCvpN08zA3RaxatgupV3YdP5D9TclwwUjOUQtHVR6joeGOvvmMB0C7yERVDGUH+jrfqqMLXHwOEBGEH5glv5hTP4C49VvBsFTY1gMTZgrn5j+9nfy4GqTX98eYeavN+OhNF77oXSSGnhECBYeJcsO/L2p3Dwx8x1OqZl4+tplEtvSNH/q8zwhR4vseolQDbMIsFZnTtHRPpPFd0AihbZLw8MwLjBC1tB4GijWvQl3vkcqTZCG3KyL5OxuTvDw4iR7
 RS7/qFfB
 /43Lp1FhjugZxyAf73Hbedl8Xjxsr1s/3rWHfYOBaBC0YxD5LzpSfoaQLRAl2d5NDjx5/HQR03K42v1sUM8hhO7okNX8W/V5bpq28FIpZVsC5w7ugV+A0Qb7OiUcgVKk3Yheq3k5ijnfHKyn8T9fzB1jXSxUee5v8zXgWJ3YPnpj3gAIaBJ/ZeLVkPrEdyI2O1dhPEcvm6FtxH148J5WgYCdxCsYv+SwA8ptYihzNntNvvXmJ9UjU8Hqx8xUJ9j7llZvg+eFO6LXLeE5+5CsxvvbPq+2Kv7W2PKxDlubgF9lb34zLSSztsFJoVFbpAtfuLSAw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for batching anonymous large folio unmapping to optimize it,
refactor try_to_unmap_one. This series refactors hugetlb, anon-lazyfree
and anon-swapbacked logic into their own functions, significantly
reducing the length of the huge try_to_unmap_one.

---
Split out from
https://lore.kernel.org/all/20260526063635.61721-1-dev.jain@arm.com/

mm-selftests pass on arm64, built on arm64 and x86.

v1->v2:
 - constify ttu flags in try_to_unmap_hugetlb_one, move const variables up
 - Assert address passed to try_to_unmap_hugetlb_one equals pvmw.address
 - Patch 3: code and comment polishing, do the stat update in the function
 - Remove unnecessary inline hints, remove set_swp_pte_at, instead have
   swp_pte_prepare + set_ptes. Rename subpage -> page. constify
   anon_exclusive.
 - Do pte restoration in caller

Dev Jain (5):
  mm/rmap: convert page -> folio for hwpoison checks
  mm/rmap: Add try_to_unmap_hugetlb_one
  mm/rmap: refactor some code around lazyfree folio unmapping
  mm/rmap: refactor anon folio unmap in try_to_unmap_one
  mm/rmap: add anon folio unmap dispatcher

 include/linux/hugetlb.h |   1 +
 mm/rmap.c               | 420 ++++++++++++++++++++++------------------
 2 files changed, 237 insertions(+), 184 deletions(-)

-- 
2.43.0


