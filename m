Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FA54C53219
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 09:52:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 735036B008A; Mon, 27 Jul 2026 05:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E51D6B008C; Mon, 27 Jul 2026 05:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FDCE6B0093; Mon, 27 Jul 2026 05:52:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 324D46B008A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 05:52:43 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B3F40A17E4
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:52:42 +0000 (UTC)
X-FDA: 85034092164.21.0A13CC8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id F228C80002
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:52:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="MP4/mRzI";
	spf=pass (imf30.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785145961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fUtcfoxdMZ/cp8tHehhllqULjSSpH9E1zbTixSWgLek=;
	b=UlKuQ52OB5u4wb63Xy8bCvOQy60b12rAS3p1Tk5OXGUrwTnwkQKLO0vbqoKQhAGUAloHO+
	a8IqzVxA7Qck9II4Qde1lyg0lEx3VH1pTFpa/mpVftpNuQOPvRpsJKh1/1AqH/hFtxxL3w
	ipDA5VQU8GjXcDJxHfMSkWjw9Cdu3Jc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="MP4/mRzI";
	spf=pass (imf30.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785145961;
	b=khEJYYS0ZPXhHbIkoQcFF+DnvS1DWKMXgZRGegzfFLe7JtmBcS1Z/mjzKXqpgU6DPpzs1v
	QcnEVGVmPZHx1RcJS/ixVRiwijIBSAbJXw/QfVu4LPQ7WP8Vya7yTLJzQtjEfMTXw7sVNN
	rMGbSp6P6+xmN+w0aEe3EV3R8TA+71o=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A2667143D;
	Mon, 27 Jul 2026 02:52:35 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 601093F66F;
	Mon, 27 Jul 2026 02:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785145959; bh=C0BIX6coAkVc1uXEiywKFdG6o8NwwBAoxC8vLg0e0Ns=;
	h=From:To:Cc:Subject:Date:From;
	b=MP4/mRzIVDzqhcPA9FV2KqfSsS/V5hQE0l5uBnGbdhUHaHAR0psLWqpS9+sGGakUu
	 s/MICmfU1ayOoSsKWr3wNWsfhj0TEtDPLOS7dasqY13XMoPO3niMLFbX0NCCeN1Jdd
	 DfOhzoHVkNc7jfzKWberw8n7399DFZydITK6rjqs=
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
	linux-kernel@vger.kernel.org
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH v3 0/5] selftests/mm: Handle unsupported and transient test conditions
Date: Mon, 27 Jul 2026 10:52:16 +0100
Message-ID: <20260727095225.372655-1-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F228C80002
X-Stat-Signature: tskub4hyergneizwqmmmrrg81iejmrg9
X-HE-Tag: 1785145960-571811
X-HE-Meta: U2FsdGVkX1/KOAoOrknnfdUDRdAvdkTGFOabT//QqnUlE5fwVopBgENPWfE7gisQ7xZbE/91LgVU5LbJC81rqD82y7plYmJDYWHrLUBlmQKHodqFGmLVEcBz6RActlLFxxYuoYKpnXfBpolf6v/rgxSnlMmC63p58h0zW1Bj+YL9rd21r0sRZgYOYAHoBEyCS2vXe/gCqX2s8K0Y9FPfVFccTHq9D1qi4BsHXwAxON5mJckl9bdnq2y2NYnm721UWmpfp/uKRJ3hco3inPqj3u+Jd/iqjmIiLP+ILpjNTN15SllkiLzZTNcZkcAwka/MfuDva79mra1UWASUnuDINGYt5Q1LhBl+vNDUOYWNAefFXLDOIuMhqhDyTSe2bBWvcvJZBmUCyGlp5Bhz2WmDi+an6HcsjxrL3qDNziVCgDHW6jYnmWmq76U3Uirkg5YBGx8OqxoyoJZEopab63UrctAs9GWce5D979Q0da+FFiTJg5x7eqLrEMEk7hAg8hIljGxlAovgOztOrjDZhHsqKfk8XH2kGWIR33psro0b54S7rsA/giyM2DvR5I8CUYUWxEjyBhpytxFO7tMyYxxtxjxzVh6UzxC7G09Nl4QD7NDn1gkMpxwAqph7oxFDmOwwcWLzVsSnA2OAb+ApSe4fukI7KUy3PK3Zki0vJyObKHDmIGFpYC60usDjA93OXPuddc0t756orvBn8Lx3K5tFpfCLeiDvYvurYVPG6s3VFf6FSdrUJOX8qQwPxWfeVkYMEAHUC/1Cm/adolQakN+FudA6FPobzzSJo9dc2XnKhUQCKqb7vpYuQTsVhhQPdAOb0/fE3SbD73LdisUkkqKNvN64YB4e3I2Vj1Vnt3G1s6KWEDRoWi6miECAlJgGWWOuqwVsFvXbr3io4DtjwJ0vCGrlDF42PxmXE+kKUaTaj4UhiwrJUhjCWA+8O6cfL6UFmAs30J9XCsJzdRUjpSQ
 vh8mr1Yb
 BLqu9tt9Oqg8AlzbqyubzC+9myq1SUwtucdUeFFSUgT1nykiqm2fifkHqMjpVWuc30+ziiAXcN9r+FNwPhYZhDnsUClpVMCp6dTmGklVnBFha4BglllotNkmcvBiGdMTUrDXCJYJkRk7gqd6QrnUjvdhTq2lpeLodqEFPgi/Dr6sGjgX5bV18N/L7sf6GnAMGgOvc1RkhLN96CnQWnNepTSzgrGrZTqdlhskFbmlgHrwYiR1AqgfYaiHg8r8s069ETl9a
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

Changes since v2:
- Explain why the hard dirty-page variant is skipped on NFS.
- Return -2 when the page is not on the target node.

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
 tools/testing/selftests/mm/khugepaged.c     | 38 +++++++++++++++++++--
 tools/testing/selftests/mm/memory-failure.c | 14 ++++++--
 tools/testing/selftests/mm/migration.c      | 37 +++++++++++---------
 5 files changed, 82 insertions(+), 26 deletions(-)

-- 
2.47.3


