Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF69FC9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:30:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09DE16B0088; Wed, 23 Sep 2026 11:30:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 075B36B008A; Wed, 23 Sep 2026 11:30:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF45F6B009B; Wed, 23 Sep 2026 11:30:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CD88C6B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:30:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4BCF6C0564
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:30:01 +0000 (UTC)
X-FDA: 85245412602.27.0DF4C81
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3082E140006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:29:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AfsLGFjr;
	spf=pass (imf23.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790177399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Y7A6O5BOlb3cgrbeJ3TD2sHpIPq+7MH50KkNRsb/il0=;
	b=RqERLildK/Pd4dfEDK4z0NnRzvGFxShT+fOqndbwJdIdItTzM3Vqgn8H50LZGrrK2dJzd4
	qxBbTB2NectNvEJwRP4VpuJHCe+Bb+mQSpwimoyrGXHcdIk6kkgRaYgcjBvN2fy58aCYGb
	BbB7/NeGEIbZ2yDT/HYygZTeceKAIpo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AfsLGFjr;
	spf=pass (imf23.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790177399;
	b=IOd/ox7RXM2N+PmTgtqDMfed0Ae/icRVemMgLesb0bztYWFyWJXvT5tkKiPc2XQ9E0KC4K
	kG8Uc9gNMrCg5ZhVh7iFJcBTBsqpGyOS8lbY474ehgpjzEFC8TCprb6RevnhYw4m4Uhopx
	6i6PlOHosdCgI6OKOwBXjV8m5odRA7E=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B905F1570;
	Wed, 23 Sep 2026 08:29:54 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3A0863F86F;
	Wed, 23 Sep 2026 08:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790177398; bh=bweJ08cI1wxdWcAWpqQUT1byxmSO3PWzKNswFgARuKM=;
	h=From:Subject:Date:To:Cc:From;
	b=AfsLGFjr9cSIlAfAIMfUc+9MJWm2/Ef0ef1X4C/kNVuAvMMJ1vEQglVmtpK6yXljA
	 kvMxGTuy2JI7Y46CExkGjM0wTXnvQMXo1BdDwijyzF4kwdh+BBd4HyrlKIvOVlaorZ
	 048/CMADAO1WF8lx4Gr/+jm0ZyJioNWVqVRtIN6E=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v3 0/2] kselftest: mm: fix intermittent failure khugepaged
 test
Date: Wed, 23 Sep 2026 16:29:50 +0100
Message-Id: <20260923-fix_khugepagd_fail-v3-0-b387e92fe1a9@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAG/ws2oC/x2MWwqAIBAArxL7nWAr2eMqESK52lJUKEUQ3T3pc
 2BmHkgUmRL0xQORLk68bxlUWcA02y2QYJcZUKKWHSrh+TbLfAY6bHDGW15F1aDS6OvWVQ3k8Ii
 UrX86jO/7ARHQjxtkAAAA
To: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3121; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=bweJ08cI1wxdWcAWpqQUT1byxmSO3PWzKNswFgARuKM=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqs/BxkwlkaZg1jFRE9j9tMvyCcftG7cu/ywr9T
 AE1rxBtk0uJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarPwcQAKCRBt1cPRWsUx
 M67fC/9xYpqodOUkH1uLZ32IFXS3OPOOhVDYcdB02dRNRXhpojFIS5M7G+4C+MoLpVQeIMjNZgo
 Y/h7iMze3lbooJQYhZqEchwZUsl3+FqXA3hTObs3eQxB+cfEJJmJqyKcuE+8o6elnKegAscWB7Z
 zvLvZoQdlfvbTzxZG2M2gWixMZH2/Jy4F3cQbocc8T1rtjjyLWAo1l7WWqy7sBcU+zmRXriV+eF
 kQzCWw7eaXWKMGHIZ6jOmxPFaTwcTL4FmboU+cBY3AQr/4SxSWa5jhLmZKWSLFm61aZsofOmV6k
 lS5hyCXc9WXEFyTwQO8IulIWkr5Fp0qBesJy89iXX8gunMFRb4JLzgx27KIr6U8JpdGCE3+U/II
 BIX3M6ACwK3ZZVZ3ejAFLATj8uV/qZ+Bs7oVzboWYqTAX7cbiVj91XRaicrtUXwrZQmVeJKGK2U
 clppKr2wVkTN+xekeW5wqpdC9gJPdgg22tIoiY2jYF2bt9WxcLXusgEm5P4SPSVXQYu1k=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3082E140006
X-Rspam-User: 
X-Stat-Signature: 5twkkssz61u148mjdptx7rsiwjcrqica
X-HE-Tag: 1790177399-947416
X-HE-Meta: U2FsdGVkX1/LnVHbJqRU6PfHxXZ6Y2YPFKABiBA5pXZYispedEdKRLg7CABQCWqQiwYbexZbgwyXvtLwV1DixzM8RUr0R6V4qY3pURjiTgM42fVQie6JpqrEXzqAS5Gf7fmwoyL/g9RQPMvmOV8icKX77HW0vIOoaypQP74qc7eu9is6HpilS9RdaC/2BOvbyDV5wGbI4BNF92dqztKMVVZsmugGLwa7u0pw/HdQYLNrPX/sPXYFNnh0kgg0bXMexI48jWb/9JiR86s+NmaGM36DcOjr6Rln29cXZW0AN0JqujtcgJ410bd0bBe9nZaApNjGubtpWbd/9XoLrdPFv3ct4m7Jj0tBGfdkVVM/L/OoTk36P0HFArC3tBt6tqJYl2mY8Au9/BeA7Wtj40ONtnWUDCUWL4whWQGghlk0ltwwPRtbdUYtBL5su82e/3YIDX+3syzh2zNRgNTk2ZED05OyI/VaiQw/G9WDqxZghU3sk7t8nvJexsbDcFzHGx8XwJ/s+/G/edF0B4RDTrJ7SgMRYHkytngS4VMySDWWXfTc/1E8kVl4yYfSUPlCs8+JqEdYxPny4S9VsV7BN67FLnB1qJsrr/cccOzRCYZgL7rk1md42h1xtF0KDdtkEpcJzFfIUMhoe/F+T9kDYQwccXxusreiPyXIAoxL56IppWDHpFC9H5qHVdowGXUJB+l7xl+gON4x5P72n4c5Twj+CPEeAJFpmIrbDeX9I0mQ0nWoYo6RAcoN51Fd0KghbGkBINbUrU0V+8DbA7cIdD9Ri/LuXmLCQ8+e0aKAmNXYM1nW3FSsUoKDtlIpYVm0xiO9vqM9PRQKaJGcpTLTGMypqTQiOAKf4ru96fy6BSf1IwXZcWiMbraDOJszrS7h13V0c3elImdPVNyp5pYu88XDqAB6Noj7zZGhuRV7ZQWUD5Zru4TQjLW6hVzeCOR/Y+X7eDQLZhbULtR1EMOcRbI
 YboxBRSr
 DNGvdgyUA5PZAvf3J50YDbEsoI535C+++3W9Ht1IskW3WSIXUfLp0fvPHUvNSluAemcQcIZMrKd77h1BTDux9UBfc1WLke5rz3dncl6AXUjHTZvZJO+SegWznBv09Krt0qVdIAAoHVvEm3yWMD7L6nh8ez6+9JgcqlKQPxk2RoqFEoR8vhYpJht7unMAfifGcYtRU8XlLR/jVToqcwIBhnuhHV7oDfX8eeiWgOoJG3N4OEblR1Gw93+mxPp7Y2rZ7fZeP11uPGh2f83VOc5Z36L4AKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are intermittent failures in collapse_max_ptes_swap() and
collapse_max_ptes_shared() when using the khugepaged_context:

  # Run test: collapse_max_ptes_shared (khugepaged:anon)
  # Allocate huge page... OK
  # Share huge page over fork()... OK
  # Trigger CoW on page 1023 of 2048... OK
  # Maybe collapse with max_ptes_shared exceeded.... OK
  # Trigger CoW on page 1024 of 2048... Fail
  Bail out! Unexpected huge page
  # Planned tests != run tests (26 != 23)
  # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0

  # Run test: collapse_max_ptes_swap (khugepaged:anon)
  # Swapout 257 of 2048 pages... OK
  # Maybe collapse with max_ptes_swap exceeded.... OK
  # Swapout 256 of 2048 pages... OK
  Bail out! Unexpected huge page
  # Planned tests != run tests (26 != 17)
  # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:0 error:0

This happens because khugepaged may collapse the pages before wait_for_scan()
is called, causing a sanity check that expects uncollapsed pages to fail.

For example, in collapse_max_ptes_swap(), after faulting the pages back in
and paging out up to max_ptes_swap pages, khugepaged may collapse them again
before c->collapse() is called.

To prevent this, mark the VMA with MADV_NOHUGEPAGE after it has been
collapsed by wait_for_scan() for anon. This prevents khugepaged from
collapsing it again before c->collapse() is called.

Also, fix false-positive results when a child process fails in tests
such as collapse_fork*() or collapse_max_ptes_shared():

  # -------------------------
  # running ./khugepaged -s 2
  # -------------------------
  #
  # Run test: collapse_max_ptes_shared (khugepaged:anon)
  # Allocate huge page... OK
  # Share huge page over fork()... OK
  # Trigger CoW on page 1023 of 2048... OK
  # Maybe collapse with max_ptes_shared exceeded.... OK
  # Trigger CoW on page 1024 of 2048... Fail
  Bail out! Unexpected huge page
  # Planned tests != run tests (26 != 23)
  # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0  // child failed.
  # Check if parent still has huge page... OK              // parent hpage success
  ok 24 collapse_max_ptes_shared                           // considered as success
  ...
  # Totals: pass:26 fail:0 xfail:0 xpass:0 skip:0 error:0

This failure was observed on NVIDIA Spark with 16KB page.

---
Changes in v3:
- using is_anon() instead of comparing name of mem_ops
- add r-b tag.
- Link to v2: https://lore.kernel.org/all/20260921-fix_khugepagd_fail-v2-0-3c2877beef61@arm.com/

Changes in v2:
- remove temporary enabled setup.
- Link to v1: https://lore.kernel.org/r/20260915-fix_khugepagd_fail-v1-0-bb6f04c8759f@arm.com

---
Yeoreum Yun (2):
      kselftest: mm: return fail when child test result is fail in khugepaged
      kselftest: mm: fix intermittent failure khugepaged test

 tools/testing/selftests/mm/khugepaged.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)
---
base-commit: 685086170033a6ab334f0068cd25dae90fd1bb4e
change-id: 20260923-fix_khugepagd_fail-172362f58d17

Best regards,
-- 
Sincerely,
Yeoreum Yun


