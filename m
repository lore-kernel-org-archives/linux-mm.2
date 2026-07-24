Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9617BC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 10:25:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 876B96B00A1; Fri, 24 Jul 2026 06:25:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 827696B00A3; Fri, 24 Jul 2026 06:25:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7407F6B00A4; Fri, 24 Jul 2026 06:25:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4996A6B00A1
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:25:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C10188036D
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:25:00 +0000 (UTC)
X-FDA: 85023287160.24.4A45277
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id A1E0B14000B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:24:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Fm6VI5NF;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784888698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mkHk9b58RJ1EtCmKkLObaDZ/eH2HlMw8OWfdNerMvOc=;
	b=gSmbJYGS87ce75db/CY1WnKg416jtimFE1YxAYzgKG3L2axDGZVsxjTZZ9DianI3Otg30V
	5XDeYVioExMMmVFD+JMQI2RxUoqHKO7HMUz770cc4F0aERyoQ3rTWAl9FhKTgiNiSiAKCR
	QgaDBF/R/8KRTBpec3brQ2lF6RwCEtw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Fm6VI5NF;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784888698;
	b=X/5Wl7qeYr/Ca7syRhvsYBRcA8Mi2QUaKQIoWge9G0AQ48Ka4s8JjnnsvQpc1pgo2zqOuG
	6uIgeafhpX60kSfcqteYcfdiV46IAgeypVGT5wofpLtl2L7/50eVRy4Z1Qoz8S1ekux3fF
	1oOPNELM+C2r2rbqyV4bg98r+1ojT5k=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A69A51477;
	Fri, 24 Jul 2026 03:24:51 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 329463F66F;
	Fri, 24 Jul 2026 03:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784888695; bh=TiypPVrcuP/pwFCPSKURegHGQntIz51gQCB9AOGPsRY=;
	h=From:To:Cc:Subject:Date:From;
	b=Fm6VI5NFP3hH30OMlcrm9JLiH1m7DtK/3m9a50rIMS5tZBpPguluNw5NwlhAKNsti
	 uFtvXWbCIrAY8UX4HAZERbBFsbi+cHkJwHTSDSakIJZl74jCoXcOH9ZyyeAHq2QCP/
	 Rdh4XIVKDJjUwHV3I6PuoSzp6M/rxxaIjgiADU9w=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sarthak.sharma@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH v2 0/5] selftests/mm: Handle unsupported and transient test conditions
Date: Fri, 24 Jul 2026 11:24:23 +0100
Message-ID: <20260724102431.1199519-1-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A1E0B14000B
X-Rspam-User: 
X-Stat-Signature: cza4qr8f35nzgo59bt4g1xuf5747cfnq
X-HE-Tag: 1784888697-268115
X-HE-Meta: U2FsdGVkX1/wicU/YOFgyeDDq7CNOZH9iB07fd9B1IGtVONGtsJYbNR1Qx0QTN1tw0FoJjDKu/ezN6QyQPMXYPoEpZ0DORtpbv7Z78aPITDeAhyGOTQ/QFEn/W7kAjva7QCNKxFqFFy4zjRO/0vTus+3zEy7NigvfmctQcuNMGwDQxOatVWl9HcmZMRlBQV8rWYmtl4tqQ2mUpoKtapikUH3YdLYpdHJ6jkrRavwJWPmbz4ZjcvZC9KncNzezfSZXiHuE5i+NvSzrky33pwJ4mXnD6DSh4dn1HdpknCZcVVq9GvR8Z+LPwck3ApOKEepGjdGW4jjyfqBQ4oxHEIt9tnvKZXJtjnMCqers571coyc/lGwnIzTLVn9yLQJNvusQPGtPX30fbwBcOHGo458mAvfEmGnBtCNinbTyN0LIRF8hIXtheYILQQ2INAt7s74QWLdnyI1Ox1BlFy2D2HaYSvJHvswP25dOC86ZdTRL/vwIDj/2icIgw7dw1MLfzPtUYASZH/4gW7etXVP1xnhElKlyQCn9B/4KCr+JmDP5IDRRRPpxjal3odWIlAzjAEHDACtwc8uVSpg2ycB7MknUyAC/sqx1ftc9MtHHDkmkts7F+zGFiWTVlUDJlBwaeM+Pklz8CAMNxMa1vU2RXbpvIv+91zt9DChxPoLWu2JbDp4rt9UXrE5qT2qpt32i4fQ/ITsNEBqGPSgl6++iE1a+6TLeb0M3rtBp83W2h8M17s9mnuzLGOimk6f71HkaKgEhh8vHkHddb9jIokS8XacDC8qJlrajkBacc0hw4IL64j2SmYg68hUdClmtfw3y88WzJGuRjhy8hy/OyrFFq1eoPd7YwjmSaZzHqngGylg+UDHFnHI+bRLX4dgWl/t//DPP4TTDRluZg/y6NEUOwlwfls0GAGv7+WfpxZkOxVgeFbf5pYmWmB1M0jdwvc31leBpoi5dgNinTYXiPdyrxY
 TjdzHb2o
 Dqo4XHvYpuyV6hXhA5dbcL7BgcBdKErjsT6453VsAUFFS1mq5ABHBst95hJ7MJiGdtA3533lWXsc3E4kiT+WVzxZfNWZ+HHlWnfOeCeTuiUh/bs/QXSy38Wgs9xyutP6xmsuJofbaZbW6RiN1boi80LGAk9iP9Zh/LHI7ySw9IfC9486J7y77Fhf1F6vdquW12/9VqT77rrtHlgyzh0GTD8kZuPCl/edoKdwXqm+yvhlA+TW/+Xfram9oSTJl9moXzYRe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Several MM selftests report failures when the test environment lacks
an underlying prerequisite, such as fallocate() support, MADV_REMOVE,
local page-cache semantics, or swap.

This series converts those unsupported cases to SKIP while preserving
failures for unexpected errors. It also allows migration tests to retry
transient move_pages() failures.

Tested on an arm64 Ampere system using an NFS root filesystem. The MM
selftest run completed without failures or errors. Also verified on
x86_64 to ensure the changes do not cause unexpected errors.

Changes since v1:
- Print swapout diagnostics before reporting no-swap skips.
- Limit the NFS skip to the hard dirty-page variant.
- Retry per-page failures for the full runtime.
- Verify that both alternating NUMA targets are reached.

Muhammad Usama Anjum (5):
  selftests/mm: skip COW tmpfile cases when fallocate() is unsupported
  selftests/mm: skip guard hole-punch test if MADV_REMOVE is unsupported
  selftests/mm: skip khugepaged swap tests without swap
  selftests/mm: skip hard dirty page-cache test on NFS
  selftests/mm: retry migration failures for the full runtime

 tools/testing/selftests/mm/cow.c            |  9 +++--
 tools/testing/selftests/mm/guard-regions.c  | 10 ++++--
 tools/testing/selftests/mm/khugepaged.c     | 38 ++++++++++++++++++--
 tools/testing/selftests/mm/memory-failure.c |  9 +++--
 tools/testing/selftests/mm/migration.c      | 39 +++++++++++----------
 5 files changed, 78 insertions(+), 27 deletions(-)

-- 
2.47.3


