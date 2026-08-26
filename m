Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF61CC61DBE
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 12:25:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C58856B0088; Wed, 26 Aug 2026 08:25:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2FEF6B008C; Wed, 26 Aug 2026 08:25:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6D2E6B0095; Wed, 26 Aug 2026 08:25:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9962C6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:25:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2AA3FA035F
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:25:08 +0000 (UTC)
X-FDA: 85143340296.28.B82E8DE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1262214000A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:25:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=H1AKHO99;
	spf=pass (imf26.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787747106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Fpvkr8ZzYlj8/ituNx2A0/BU6uKzCk/HiB6+v9ddThs=;
	b=CFqktPEfWO//zP+RVHQLSGsvxefOgrjtwsi3Tdt9foONDCZU3E/LPWjcBY3hnADrFXcf4W
	z4SVNoeStnsQGcKE9BkWjtJ9h++egWshiPHSapKyQkmkXZUQ+ton4IypJks5o4qg2FYmHe
	JDOP59bDFi3M3eYwheYRxxPjHq1Mq0Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787747106;
	b=APS37FVWo5qQg9Fohk1oSNnzrTjob5keu9KP57BpAG+k6rTnEEHBZ26sbNlgONaSmlpn9J
	izvqmfBWM+/UhXdlND3srDHWqENTEbT2YWazxtVkNaD+PrSVuyUyIh7eBpMP+K9l+CZ3HY
	lls/a4sjHolonw/sN9gYiH1OFfQHXvw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=H1AKHO99;
	spf=pass (imf26.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 103D41576;
	Wed, 26 Aug 2026 05:25:00 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E21123F7D8;
	Wed, 26 Aug 2026 05:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787747103; bh=+m47CDGBLu+2KKry0pk847eP8rBPBT/djc8BljXHXXc=;
	h=From:Subject:Date:To:Cc:From;
	b=H1AKHO99jtLD2bOmZ5RyglZq5nbqOYTkUKkzgdFaYn3ohXgA64O7oLuBkluVJgWzj
	 PgFhPKpCYsDvjAvDEuCpL8SwDam6INmNFDopQ3neQ2Kkagbh3BbmBUyP8nPj/qB8Tl
	 39UAVvLzQxlmqUEgwD7Soi7bhHF3nFJQp5kJqic4=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v2 0/2] kselftest: mm: fix some failure of
 split_huge_page_test
Date: Wed, 26 Aug 2026 13:24:38 +0100
Message-Id: <20260826-fix_split-v2-0-71153c7f579a@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAbbjmoC/22MQQ6CMBBFr0JmbU0pVQsr72GIKeNUJhFKWtJoS
 O9uZe3y/f/yNogUmCJ01QaBEkf2cwF1qABHOz9J8KMwKKnO0igpHL/vcXnxKpzWbdMSaj0YKP4
 SqJx769YXHjmuPnz2dKp/679KqoUUdtCNxJPBC7qrDdMR/QR9zvkLzeH07aAAAAA=
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1965; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=+m47CDGBLu+2KKry0pk847eP8rBPBT/djc8BljXHXXc=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqjtsbvrNCvj4po7sJrnN7TSfCTIQVoy1AQhX+2
 NKWHsYjt8uJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCao7bGwAKCRBt1cPRWsUx
 M+T4DADC0+md4koOHJPRiqUozSeGzQ4ENUdfN4dbVq+ldDlUffw8Fv/oYwph24FW/hJqA4qcCxt
 RTVIf9PqIjHGWEkD/hfzjT4PuS8oUL4FzlzeYN+9qhWxXOBbUZzO5LNzxpzHE9y/xkIYLzP3iNF
 YEY0KE2YnNBPGGEqbmzF50YKjdbb7/5Ai8ytW9zBQtBFX2M2tCWN1we1dIy09ZYjy6vHUo/Vw00
 cuSUalRsW8OY+toor32GvdjcSQX2Ki+8Ld3/Q+YG+uA9wyedY7SslfvjwhogNpYl4gfdEltJxE9
 /lBGLuoYWUXXAGR8dJe4ALH9h55Pyx8NqYwWamNDyhgCMGDy0d2dvsIf2I3vOX69zFho+RTK4Hr
 +jLWA1SFMp7/QeIwkRL9g7MzT9gpO+n7PtjywTbs9DY6GqdVaFXvb4DV+CIzOtuI/mYGjMOgAde
 W1vBkXWcBpvAGSF+DNwRXyU/+sQ/lezOqofApHi5IGNs7IV2bDi3vgBmHw7a0JOKqAg4k=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1262214000A
X-Stat-Signature: 6tknokrhozehukgyuydcozqtcddmgf5t
X-HE-Tag: 1787747105-254939
X-HE-Meta: U2FsdGVkX18W/Pm+oCx03En32XU/7CC8dqVL1U3Khw5RQhWLzX2hixVMryJ7ICEo/K4NWILd++r8m+PTA2L41GHCzM7UscWI9S9Y4Eaw2rljmzhFzvVY2oxVcL5s+5IROmNk/LdwbmYme7WyX6qaI5gDV8Zwbjk6dZxCD9PeBhoKBhr90/3H8aPe2HjGoEjPIxObSQKGR1oEyq5aG53h0bkU9KJDuM4TA+vawUoLmPsPmiUwNhjVg1J1stqS5+huSLmMlI2LNWOXOykvZH0cpHmPYT76ZZMCqDuo0CyG+xZoA5h9jKmn17yCy61RSPmGXUyfCBQnp88YL/d7jjvIA8bW0n4A2XwYjXmxcntLNSiMlV0CoNOrv711O1N4kc0AY5xkG1YtB/nZ2X8xYps+d9BnvI5L3CPtNSNW5yiThq235fmcJk6EqKKobiEieCQHE3kKlf74Os8L6Y5HZuV5to0gKRaYL37tEe7KiOQiLxfyYm0sMxmI6id+5wH8Hi2TFSq7NCAis+Fq057MznSAL+pYYsMx3OWhCPo1fWaOmFhd4cYfBg/EqxXUVQVw0G47hkNSOzfROw2px7yiuPgfIdzHzFbDmn6H2VxIzix1BtAt8JjHYwC+GSn6+Puvg9J8uyNBL3JZjrjdIxBS+zkMn9p99HXiLnvHwXhN77Udm8J7KJfFepuQfRf9JvTQJqKLoBLMwl/ZaLrwnzaQbN4be2A3BTRqvwJxSySuCTmkmBK90RPgMz3bZ5tNgWBjgeIVDyBpmK6YJyF2PwjcQtQvvZy7ryF1IYuppX8AU6r5BP2hCsP87TUuaL7drTtRCHoVxxzPxYQ+p3TN3ZLlME3S09bplmx1cUxHS2dnm3oYtWHqh0GZbCot6R8w32eZzIBgm6iNRSK/YmmL4BCmo4rIKI7QNPCizaxmyV6GZO55ShyIjch89J4K0EozJdAxpN0Pf7WkGrXQG0b3FRL/8sx
 SMgaf2Mu
 BcyrUmZIVeYN+z+DsHyZssnHEbEF6NuVZrOwsi0kROW21YSWQtKWBmc2W1k+L8ooBzP6XfTVPeg5DYZZrqUjVNiQyN/ee8FgLnWh9NbxymUWBSwaL1x+0ZslHFOYAoBWZHVEdZu9ASZ/jGUJRiRWA9hA5fNT/eD9k57ysOFZ5y/VzObnLcnZZIEuW5okphUK+XhCdkB43iAsvgoDCJlrEjeSRH3QFtfCPSHCPUYfJGUvtjba/pSEAdYY/dsXNJjSpVDdPu+B80YwzDIxSbQcWSTiifKe1V3AQUzJVBVqIoGrmzFIoDjfUpC9VvlX87n6IOJ5CnvWK081QslfPflyik6xGq+ZrKR3VPfp0
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
huge page, preventing khugepaged from collapsing it again, and by replacing
the use of /proc/self/smaps in the check_huge_xxx() helpers with
/proc/self/pagemap and /proc/kpageflags.

This patch based on mm-unstable

---
Changes in v2:
  - rebase to mm-unstable.
  - add message in case of failure of madvise() with MADV_NOHUGEPAGE.
  - fix wrong setup expected_huge in check_huge_shmem().
  - Link to v1: https://lore.kernel.org/r/20260820-fix_split-v1-0-ab430c58c7cf@arm.com

---
Yeoreum Yun (2):
      kselftest: mm: prevent random failure of huge page split for khugepaged
      kselftest: mm: replace usage of /proc/self/smaps for check_huge_xxx() helper

 tools/testing/selftests/mm/split_huge_page_test.c |  15 +++
 tools/testing/selftests/mm/vm_util.c              | 130 +++++++++++++---------
 tools/testing/selftests/mm/vm_util.h              |   1 +
 3 files changed, 92 insertions(+), 54 deletions(-)
---
base-commit: 169393fff5d1ec2690934067eeb95544ff5ebdd7
change-id: 20260820-fix_split-f44939ec44b8

Best regards,
-- 
Sincerely,
Yeoreum Yun


