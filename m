Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9DC8C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 08:11:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88CAD6B008C; Fri, 28 Aug 2026 04:11:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83DA36B0092; Fri, 28 Aug 2026 04:11:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72CC26B0095; Fri, 28 Aug 2026 04:11:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A2906B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 04:11:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3E3AEA3B1A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 08:11:46 +0000 (UTC)
X-FDA: 85149959412.27.E192A9C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 31CB31A0006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 08:11:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=az7+7cic;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787904704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cx4I+B3aP0EXT3W0wW0Nz/MLE1TW2YgmJCB8jCOdmTE=;
	b=7CtyoiHLvZQTmU6khnYMrzRg0kJAUA8bgu1s8v7DlRYL9I4VJ+DTv+6BCOEvHyze5epLkw
	RFitI6G2kCLe8JGVAi4sP0ddjMAYgisebgfJ/qli8lvCmjBgBxwJAueDmHbyLSRugEaSuv
	qEF1U6ZAkIHHohIvmh2YGg+YahPRvdw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=az7+7cic;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787904704;
	b=6/wsK5KdTW0Ill3akiA3xIzMp91wGrld9hZJ4blXmn3Dhc9vS35tNiPB/CVYIM3JsJPCrS
	Lt/x2dnbzRYnHHjkWhpaklTUzoaD2PLQxzeVB3z3LTyCUUfW85CSg3AdrWmg6qUSQDl++7
	gcG5And6wzwQHsz/Ez4xuuGDyvZwosI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6668D1516;
	Fri, 28 Aug 2026 01:11:39 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B40483F85F;
	Fri, 28 Aug 2026 01:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787904703; bh=USOUzZRz3c0fHctBAtbTyU36BIoeCR2Irm1oymvy1Z0=;
	h=From:Subject:Date:To:Cc:From;
	b=az7+7cicnKBQ4YE1gf1xYFVll6DUXUj/0LcNUrPlF+q2kN6lMjqfpwg21E5G1r/PE
	 Hk5FiygbfHcuyOPoOC2iqNfuaTeb2TJNTuRMsulLWoly8CUjUjJwbzN2p1m9+vlPO6
	 c6pNfGHqj04ZUWmk4r6hrzs10nJwXVOzZY/Tng7M=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v3 0/2] kselftest: mm: fix some failure of
 split_huge_page_test
Date: Fri, 28 Aug 2026 09:11:32 +0100
Message-Id: <20260828-fix_split-v3-0-374022586a4b@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIALRCkWoC/22MQQ6CMBBFr0JmbU1pqxZW3sMQU8apTCKUtIRoS
 O9uZe3y/f/yNkgUmRK01QaRVk4cpgL6UAEObnqS4EdhUFKdpVVSeH7f0/ziRXhjGt0QGtNbKP4
 cqZx769YVHjgtIX729Fr/1n+VtRZSuN5oiSeLF/RXF8cjhhG6nPMXt8m10qAAAAA=
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2222; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=USOUzZRz3c0fHctBAtbTyU36BIoeCR2Irm1oymvy1Z0=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqkUK7FZ6xrgwXi+C79j9XWUXPL157DEfNDeyvK
 NH3vM1BzjWJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCapFCuwAKCRBt1cPRWsUx
 M8p4C/9JENjCUm3iTLSylTH5Q2XPNcCbR8DJj9nKskBTusG5Hj6XCUUnfr//3gO/7CasIBssnuu
 B5ReHNHtaHq/lbokLssbDICO5An0Q53c0pJkWddWHavvXdESeXDlqJUeVal3P19As4xwZ6zvPej
 iaIGGwh4QB5YrDenpijUtphEjykFlkYzIFuAMb+JtrgiWhTPAFDIG3x76EAuZrn+AdutCKtujHS
 xKxrfLCQk74x5IsRkOf/BQLbUa61rJmpNsN7odwpztE8dyrY1CUB0y+/XVcaAhu9iB+3ax9iX8g
 1QEJ3PN/v6fXsBRQVzMR/Z8ED9czEPNzsn9nmDHMn781/Kwf/MOp2OLbsU/IGQaPTSmjZaYDCiU
 OvOnZOEtGwYuN9cKB3tz5pCVh+2r7qm+f0Z7Z46BOeD4mxVYeYrfeaH2MIqjTQK0FOY7KbWZWiA
 2J5KY1SnR/DxPXOj3QvgCtoVO9TVWeIZb9nzhOg1Wl0Zt0ESeEMW1MwQsMRmr5BmoNa4k=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: 8rhuszzhmi933s7ei3obubjwax4e4q4q
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 31CB31A0006
X-Rspam-User: 
X-HE-Tag: 1787904704-598613
X-HE-Meta: U2FsdGVkX1+A90CBRpshLYqKfE1uiG1qyCkWIQinhVc5dH63Wk4chFK3yKPZHByWk5JqbjRoYkidGQOSzQ1RlasHk4IVRgLbc71YLm6ujACUtfynJwpkOTWNhWOtjnp/hydolUG2gvDj5KyxYlepOivVCASMIb+J+Rlmui9TsFu2BHHVJBL1tZERjRmhLNgpYeBftgFtPHLlDlQKJctncXVGYshWCN805XiVqFwpx/I6EwNNRm3w4kvJK7gA1IH9pCCCFKK6XFE1AiBhLX8qP8u0yWdVjffpnEFXj8i9OvD7b6+MqpWaaDjudlDNdJpftiIR45dd0ujF+XucZwjnPG7xlqqKiCO2Kw0NKoWbKfz0qyTIxnNISHzVl/i972zQBRmsWzbVMX6uwCCqkFqXUYW4hCNXLxPF3f+OLr1Mw4WT6eLJjC9/MsxR7gtkkaidhLGfTOPa54VqA6PeWEZwTpYhPxnz5NBEAw/lVYVofLcBkorWyq9mrGUqwNzDC79BwXwV5I89ij4bdTqf914w3a9A2plW2MypHfPodNjlorQ+zCGflHwGzXfFITi29cKoTyGf8O0m9mbjofKOa4/dPpSIkTZX/1i55ALB4MBvJZ2ezMmySWnVl1JyuYEL5r0TW5fBfcAyZaF1wB13h147nX1640XX2B3sqTofK0ATwpWNZ9Ts3sMP9wFITHJ/5V5A5xkE5YS1JWwg+yu4jn2XaLfAPzQ+ZZSMaMbCAJ0vSFJV2hePgL5KrjQPT9ksqLDpOl4MGvbNfo+jyEl/twTs5DXw2hLSOiNBD69hGK0+cSyhaabfL70drK/EHr083t3vCSR1p74Soe2TJcjXg341Y8FJO8WhY9Wro+2JDE8bXHHbaTwa3NgBm+AcuGQCbtXUfHlq+hqi6UpA9mn4kUkyXHjJrPK2aLGgcRJY2WH+IjCYLJxLD5UCQ4P7s40GUaOuG6tzNjCB776hE1pIUb7
 9zSdedRH
 v4T3C6azTt+h1Fv5fRkgmY4FfX7M9cYEEjZ2OP5F+o0ooeprPiC1ZZyJoHaBZWhSVTw7/zbZvlv6FLF3pffofwwJ3S1RPUd1PfeaNYlJAlDgTVL7XfxsZ4PvWF7WvAvBSJOg1rAx6PFVOrAX3RINcOGe5uSIAAHeS3nJMEE0/QbS57Aqhbf4NhVDpiyhbaMHILFUIILG6+q3qCqlPrvc9xroIeosy0Y+C1gEBUYOJ5DVdmn6NHN+KPYrkvIU9QNqebtx2lcqw1WtmL685xZXXVo1Pp7UdelbHvgUjUi9OARneZH1VV05rANZ4OtNaztYxOje8A08fVYNXQrJ6sbnDlduQ3fXIe/3vspZ9
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
Yeoreum Yun (2):
      kselftest: mm: prevent random failure of huge page split for khugepaged
      kselftest: mm: replace usage of /proc/self/smaps for check_huge_xxx() helper

 tools/testing/selftests/mm/split_huge_page_test.c |  15 +++
 tools/testing/selftests/mm/vm_util.c              | 145 ++++++++++++++--------
 tools/testing/selftests/mm/vm_util.h              |   1 +
 3 files changed, 107 insertions(+), 54 deletions(-)
---
base-commit: 234e77148199ae43b83a0a03a3f481e03460a286
change-id: 20260820-fix_split-f44939ec44b8

Best regards,
-- 
Sincerely,
Yeoreum Yun


