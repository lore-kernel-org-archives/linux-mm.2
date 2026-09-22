Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E260C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 17:32:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 663256B0093; Tue, 22 Sep 2026 13:32:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63AB76B0095; Tue, 22 Sep 2026 13:32:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 551C96B009F; Tue, 22 Sep 2026 13:32:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2DA3B6B0093
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:32:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AED6B12058A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:32:53 +0000 (UTC)
X-FDA: 85242093426.16.50160F6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 78A5F18000F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:32:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CLvRHaG0;
	spf=pass (imf06.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790098372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Q7mc5rE1gQW0RRDNm86nGn4GcNeBbnQk6KAZPcwbRqI=;
	b=FVZKgPHEwztWkPh79C+abFgHcM4mLv5oExlyBPXyHq1ZHAzQlpxPj7rdx1zV/Io+R3gTba
	0myjb/k4LftlGXvdIcNBkVOKuX4IdGQ2dSl9nCE8q0EdcAIIyAXbPi+OVUS3zKehUwSgu7
	ISUlawCCL0Fz7P8PEKl4iJRQsgPfaX8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CLvRHaG0;
	spf=pass (imf06.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790098372;
	b=aoHh8GC5BbXDmZZA7DZpEVk2KseYrSUYcMXJCzWGf9H+2o/kfwTSNlQ/Kd4Xnd+mH3Nn2r
	Gb59jMJWv6pZ9Odh/lh4HvrHeZzFvDueHRmWp6StB3GIyrMVX65fGbydi57h7uyLEeH+DJ
	/WLVki95TIN1GMCvnrENbYyn7syzSmY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 882C71576;
	Tue, 22 Sep 2026 10:32:46 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C8B23F86C;
	Tue, 22 Sep 2026 10:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790098370; bh=+Su2l1Ft0WBIXjZQ/cFjqH8CISUnq3bv3Vk6lON45EY=;
	h=From:Subject:Date:To:Cc:From;
	b=CLvRHaG0VyM0revKNsxvp8O1elOZLQpJ6DZ/UqshepIIeiFSTz9Cvbo1Bi1RsOx1U
	 8EaiMzAhvfYdAUN/o0PB9bBvwOXciKqWtNyWKjdw8/ifa495+DcTdpxoDTKvE9pwHx
	 DnO9RWv/nE2LTlquxhGKLaA4/gNOjwqqlKJzSX7Q=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH v2 0/6] arm64: distinguish HW PTE pointers from SW PTE
 value pointers
Date: Tue, 22 Sep 2026 18:31:55 +0100
Message-Id: <20260922-pte0_arm-v2-0-a3f1ddff0a8a@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIy7smoC/0WP0W7DIAxFfyXieUwGFgx92n9M1QSOWXlI00IWb
 ary76N02t58Lesc35uoXDJXcRhuovCWa17OLeinQdApnD9Y5qlloUFb8ErJy8rwHsosk4o4JSS
 IoxLt/FI45a+Oejs+cuHrZyOuj6WYudbQiU3QeVp3ntyMBDlahOgoehj9azM80zLfwTFUlm2e8
 3oYOEwIQAERyGllMSSjrdaUXLSOfHJIhpDE/YVTrutSvnu5TfUffnu8/PfYVHPHOJporWHj7Z/
 7uO/7D/xl6R8hAQAA
X-Change-ID: 20260911-pte0_arm-f1b7df7c0b51
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-efi@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 78A5F18000F
X-Stat-Signature: exi9et4t714tzaqfajxy83t6mdeoq6dy
X-Rspam-User: 
X-HE-Tag: 1790098371-225639
X-HE-Meta: U2FsdGVkX1/bOpKaXTeSYb0JqjWrZPx64edw6xV1YxPOekagI1kui4OEhZKMDdQ+cLZNzNAqhXnyAHTlkhtlEIkhlpl+Kef3z8o8Yf/wS1Y2Y0q2SwAlhB99u4C9dKgQ/pjd+dBfl6BV9cqBxApjPZsZ9ogqObDWiXN8RcnaxXCFfgkL2nV/aHOdXhxxkOGsxCTvdFzVpUCP21wQRKUcaVIjB0fBNdk3dZiGh7mSLcRZXPp5LBdIYft+qxWOJlZqYv8C46i+bb2JiBJgVXAOD3SzJT+n5KU+H432zZoTjcqLDmD+m02WQGMwYlHcZcwzo4hM7OyVdHywD1CKo/ty5dUkGwqGlc4cMl4Zp8NErWVn0XCNBUXyAWPpHxwQqTAAlBQcn6JdQTbJNrhVIw3PrbZ/AA54we4kwOt5cVVAfkoKcGjTmk4CmS/98gS4iiQNCm0EMZTkBiBVufC8yaGl4DYawGYfZp8uqxvFqwC+1SGT0ALr5KTvBSSfYR/6RZuL0m6k5x+ARqPuOGkV7D1hpTRpQsc7EDvfOXgV/5Hpf9TJopm4KeNsdk2EcT54tFDUH7iphUosNRQ3aHXaj2yDytEUkhMyJmaAxB5pktqSHzSYnOlGcnjHsE2he6wQ37G2005kZG/aP8jjy8Bfnj8LqDYtZkjmuum0C94GMgKTI4WDA9vYl5rI4jjeEIM49qAZ9t6hiOVLJug746vX7lW2/rv5/hJRbzaRjUaqMEVoizVlfopnopZl9qmSCnZYnhoVz/y3Llb1P6CVtNrAPOcYEX4eIqCcuEEoJYrNy9nEbHeW6vRA5VMbpzV+mLVU0CXR7ASorzeGCHIp8TwtygmgXy42IB3JUhT/6GYDTvwph7tsFioy7nSrHztgSIKO2sN065xHRquHyLV5x2O9rNDdDOnS2haSdeFOYjC9LK1I75hjikAUet5/VZM90IjinsiwnwJ9dKWpYr9JYEyUVnv
 8xXKp2jh
 flu4UUQoSJT8cF1n8beNwMz13arDB1dgMo3aTVzyRTT9o9QmhC4EJp/Ud3PFuNN3IKun4ic1gqy7dKyxuRXdblcMlpl4KUOfsx5SA5E4w/eBPWFqWsRgV79rVcSqnf9lR8UobHp2Z0Wk7TLWmSewefa/cyKi1dbxwkLzb1kpyzPwD7EUCsjHkk/DTgyXue55ekLKsk3u7ZJeomXVoUR+DCyaG5wYbzVBBeUGcQitnH4m+8H7AQYONyke7VOyjohAPSclJBVvMOuwBEhw222YNq7N3o0GfUPWU7ezIaIKEOJqndwuh3FAcNsFVrR3QNgdDbgi9Ab9KAmmPkrwYD+uZpfYKkCY00xdUGIZUrOs9zOMVVikbVK6KfMCSxI3BXWWuGOEHFM9YHLizOZU9Eg+tYqkziOBIl/T12vRInJ80CPY3jnVNh0PokoIbDqM59taSzSBGeqYHaBvdUOdSWWhvw6B8s/lz0E7NCiqQwUTLvzLIjxym24+u076YwZQ1HOs3e5u/Pz9dSsj+H2e15J+WZXNyMIbi6GeXlw8ktzJcn9d1kwYCEZww8m/tfy0tTlJcruwNA3gJS3UNfCZ5uQ7UH+tVYONsKffts/nA1tihc+Fl09lqEII44Wg0iJPIZaRiERpfAUj7e1Dku206tcfNSYaryqRStcKLBM9C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

The generic series introduces hw_pte_t for HW PTEs, while SW PTE values
use pte_t. This series enables the distinct type on arm64 so the
compiler can distinguish HW PTE pointers (hw_pte_t *) from SW PTE value
pointers (pte_t *).

The conversion updates HW PTE pointers and accessors, including atomic
updates, fixmap, and early page-table construction, before selecting
ARCH_HAS_HW_PTE_T. Higher-level entry types remain out of scope, and
shared helpers retain explicit casts.

The linked generic series is a prerequisite. Its cover contains the
Coccinelle script used for most pointer conversions; the remaining sites
were converted by hand.

Testing:
Testing was performed with and without the series on both x86_64 and
arm64. KUnit and the MM kselftests produced matching before-and-after
results problems or regressions. Fastpath performance testing was also
completed on arm64. No regression was found.

Link: https://lore.kernel.org/all/20260922-pte0-v3-0-5670b8cb9059@arm.com  
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes in v2:
- Move hw_pte_val() to the generic series and drop an unrelated comment
  change from the atomic-access patch.
- Use raw PTE values instead of generic HW/SW conversion helpers.
- Drop a comment and add testing resutls in the cover letter
- Add Reviewed-by tags.
- Link to v1: https://patch.msgid.link/20260914-pte0_arm-v1-0-bb53b663e396@arm.com

To: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
To: Ard Biesheuvel <ardb@kernel.org>
To: Ilias Apalodimas <ilias.apalodimas@linaro.org>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Alexander Potapenko <glider@google.com>
To: Andrey Konovalov <andreyknvl@gmail.com>
To: Dmitry Vyukov <dvyukov@google.com>
To: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: usama.anjum@arm.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org
Cc: kasan-dev@googlegroups.com

---
Muhammad Usama Anjum (6):
      arm64: use hw_pte_t for HW PTE pointers
      arm64: use hw_pte_val for HW PTE atomics
      arm64: use hw_pte_val for HW PTE loads and stores
      arm64: use hw_pte_t for fixmap HW PTEs
      arm64: use HW PTE accessors in early map_range()
      arm64: enable a distinct type for HW PTEs

 arch/arm64/Kconfig                |   1 +
 arch/arm64/include/asm/hugetlb.h  |  19 ++++----
 arch/arm64/include/asm/pgalloc.h  |   2 +-
 arch/arm64/include/asm/pgtable.h  | 157 ++++++++++++++++++++++++++++++++++------------------------------
 arch/arm64/include/asm/vmalloc.h  |   2 +-
 arch/arm64/kernel/efi.c           |   3 +-
 arch/arm64/kernel/pi/map_kernel.c |   4 +-
 arch/arm64/kernel/pi/map_range.c  |  20 +++++----
 arch/arm64/kernel/pi/pi.h         |   3 +-
 arch/arm64/mm/contpte.c           |  49 ++++++++++----------
 arch/arm64/mm/fault.c             |   7 +--
 arch/arm64/mm/fixmap.c            |   8 ++--
 arch/arm64/mm/hugetlbpage.c       |  48 ++++++++++----------
 arch/arm64/mm/kasan_init.c        |   4 +-
 arch/arm64/mm/mmu.c               |  46 +++++++++++--------
 arch/arm64/mm/pageattr.c          |   4 +-
 arch/arm64/mm/trans_pgd.c         |   4 +-
 17 files changed, 207 insertions(+), 174 deletions(-)
---
base-commit: ead700ca770c82167af32622cf8b68c9f87c3c7c
change-id: 20260911-pte0_arm-f1b7df7c0b51
prerequisite-message-id: 20260922-pte0-v3-0-5670b8cb9059@arm.com
prerequisite-patch-id: 0114fcc6ab0dbb739b5bb6fc0fe6b1c8f1fa37a1
prerequisite-patch-id: 09fcf65970074620dd3a9cce6850b901beb01db8
prerequisite-patch-id: 9b2fdab97c99effabb85526fa7f141c933b3aa23
prerequisite-patch-id: 1aa309a26d98a1e93a54742705a03567ee93be71
prerequisite-patch-id: ebe32f52c95ad0542982f0b37798d209595e25e1
prerequisite-patch-id: 22950028c3d2060de8acd3fe4a73d755b18215e3
prerequisite-patch-id: a60d249f52d092524176851b2570d7245bb24434
prerequisite-patch-id: 81ebd1378e25d40a1771b53973abcc4defa87535
prerequisite-patch-id: d982f2b00c5eddb2459f69008a73e4f4ae4d8299

Best regards,
--  
Usama


