Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64204CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 07:51:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB73B8E000B; Mon,  8 Sep 2025 03:51:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B67938E0001; Mon,  8 Sep 2025 03:51:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA4638E000B; Mon,  8 Sep 2025 03:51:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9584E8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 03:51:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 37AD2140A04
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:51:13 +0000 (UTC)
X-FDA: 83865312426.12.10266F1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id A41E6140003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:51:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757317871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=1bNU8+UdcX9v6SvsIPAmklaFI5JWR6VivC22GI1lUcM=;
	b=J5FwoOACUVhB+UiB4xGlTAMvGRRXvlwmYmoWeV8uOSQDX9LY41lZpsClYq9K5LLq7pfj/0
	qLhXt/sISb6a0uizBJv8KBaJAW37J9ZMUvx/WTlVF3Y0zp+sWvGHFQmjbsfZeDYC/DDM/+
	/b0KgIW2ba94Lv/gcHcXCV0oRa9Ndyw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757317871; a=rsa-sha256;
	cv=none;
	b=QpsvvTYN++xPwp+PzJT2oR2ikH6jKJrcYghM1ZhNfaYAZAypylCJQgMyZ46EJsZdNXmtRB
	yUzBgLigZsST3BiR7xx2CHCH03ju9Fxm+LrsrVmKXRnPnGYFSQPwz0dR5DIeXIqUQe6NR+
	qvVwM0Ni1T5KKXCBHc91k6l7bBrOK7o=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9C6E11692;
	Mon,  8 Sep 2025 00:51:02 -0700 (PDT)
Received: from MacBook-Pro.blr.arm.com (MacBook-Pro.blr.arm.com [10.164.18.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A843E3F63F;
	Mon,  8 Sep 2025 00:51:06 -0700 (PDT)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	kas@kernel.org,
	willy@infradead.org,
	hughd@google.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	baohua@kernel.org,
	richard.weiyang@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH v2 0/2] Expand scope of khugepaged anonymous collapse
Date: Mon,  8 Sep 2025 13:20:26 +0530
Message-Id: <20250908075028.38431-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A41E6140003
X-Stat-Signature: iyoumi8g3wsu5zojx6th7ssindzcatn3
X-HE-Tag: 1757317871-83422
X-HE-Meta: U2FsdGVkX1/aY8UJ0wvpPv/Qfyo2jBpWJsqbAUvH/UYKfx/eobvH6EMFIhPVRTLQwylM4g+FpDMomTmZ1e7R512G+3Ykqi2TehekpAXVwIm2q0knMjJ8q1aHL1cDrxMuZkY3mrVjcWM0hYR8vzW4sA8RoVIN6UXnYS4b8bNqW8lQUec2TgUzo9uXBmnx8LmozyvnICQxSJ9MyU95NODSRl3ea8SKICPSMofA2LzTItWtDCIx27ikRUid9sO/eXaODaoBCM/CapuHCXM8SxMWlURUXq4RmsnxPUGmSNWcjA2uTdGQbaVe/0B7cy/hE8XbH3Vj+fsLPvzRpb6Z7nrpBitBaguRLuPVf45l10xFmJpsOEkPetXxO/jWUQbvaM6eD6s9wP5qdhvATfcHh7rEyWjFv+Ewcx9Td9i3ny09adNDitnTHgFrhL/clbP1wphbiCk5qcBUK070+bahFrZHmlRPh777HmAd/SCvMUdB426/wmYvKMu8ilefsaU1XXImCNvtaoGCSRML1S/z1fM6y2D8CTxM4OVqr1hLs5Ti6h+mLSL1VRoXo6IUdSqQ7JqOWYprkDKms5o2oLAwEnjWUat4mnDmJpw3xXi5qhJV/OGXTAs71sENpGDNCar4XJKbFlKKwT1CLGH+cbiygWYYWGBtp9IyE1Gdh1THOeQ5BbBPkUNxPTmpgm7WEIGWGGwOlEnnfUwE2d7fUoCS6rU22reBqzLTrLpWzkq/qU9d5aZ5y5HZlwyZEa3FNx9QbznVsqposhFHJ4D4/lItFdjkG1nxFzfT0AkiIjleBMLhBdV7Hd1ny/+iN9mM4DVE/v5jrKZzAZeXnkpibk/FVT/hExRXxbdRsCdm7V1h3hvZlnhZYZnX5hQ62T0BpZt96PIBF9iDWqXmiPD/9J1zVcyBbmHk6YMJunMS0SclLyy2pBFQLHbhRQzia2hfcT1E/T2K1lozYEbkhrWoPp/9nJB
 khRkGMN3
 j2Lth+zaPwJHsqwLHsYTUSjSgFavjvHCj9Wy3L0JW+7+Nos3rxUtZYF+W8EgWSHLhCfYMbmo5bgN4Hv5GnvGoBJQ/Fk2JyA+ojFAplcyc/WP8QH0fPPYW88CHKPLTyxYGNMRrQ65gzTLmLzDS44I5A93A9x1K2l5eyjDWTuqIFEefppx8k3WSHKTMOjTCv56qOoLiU3JkcEvIxwGbCfE+hRJ3+Rd7vUtPtPqNdUimCDrW+vUPG5mvfDEPXw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently khugepaged does not collapse an anonymous region which does not
have a single writable pte. This is wasteful since a region mapped with
non-writable ptes, for example, non-writable VMAs mapped by the
application, won't benefit from THP collapse.

An additional consequence of this constraint is that MADV_COLLAPSE does not
perform a collapse on a non-writable VMA, and this restriction is nowhere
to be found on the manpage - the restriction itself sounds wrong to me
since the user knows the protection of the memory it has mapped, so
collapsing read-only memory via madvise() should be a choice of the
user which shouldn't be overridden by the kernel.

Therefore, remove this constraint.

On an arm64 bare metal machine, comparing with vanilla 6.17-rc2, an
average of 5% improvement is seen on some mmtests benchmarks,
particularly hackbench, with a maximum improvement of 12%. In the
following table, (I) denotes statistically significant improvement,
(R) denotes statistically significant regression.

+-------------------------+--------------------------------+---------------+
| mmtests/hackbench       | process-pipes-1 (seconds)      |        -0.06% |
|                         | process-pipes-4 (seconds)      |        -0.27% |
|                         | process-pipes-7 (seconds)      |   (I) -12.13% |
|                         | process-pipes-12 (seconds)     |    (I) -5.32% |
|                         | process-pipes-21 (seconds)     |    (I) -2.87% |
|                         | process-pipes-30 (seconds)     |    (I) -3.39% |
|                         | process-pipes-48 (seconds)     |    (I) -5.65% |
|                         | process-pipes-79 (seconds)     |    (I) -6.74% |
|                         | process-pipes-110 (seconds)    |    (I) -6.26% |
|                         | process-pipes-141 (seconds)    |    (I) -4.99% |
|                         | process-pipes-172 (seconds)    |    (I) -4.45% |
|                         | process-pipes-203 (seconds)    |    (I) -3.65% |
|                         | process-pipes-234 (seconds)    |    (I) -3.45% |
|                         | process-pipes-256 (seconds)    |    (I) -3.47% |
|                         | process-sockets-1 (seconds)    |         2.13% |
|                         | process-sockets-4 (seconds)    |         1.02% |
|                         | process-sockets-7 (seconds)    |        -0.26% |
|                         | process-sockets-12 (seconds)   |        -1.24% |
|                         | process-sockets-21 (seconds)   |         0.01% |
|                         | process-sockets-30 (seconds)   |        -0.15% |
|                         | process-sockets-48 (seconds)   |         0.15% |
|                         | process-sockets-79 (seconds)   |         1.45% |
|                         | process-sockets-110 (seconds)  |        -1.64% |
|                         | process-sockets-141 (seconds)  |    (I) -4.27% |
|                         | process-sockets-172 (seconds)  |         0.30% |
|                         | process-sockets-203 (seconds)  |        -1.71% |
|                         | process-sockets-234 (seconds)  |        -1.94% |
|                         | process-sockets-256 (seconds)  |        -0.71% |
|                         | thread-pipes-1 (seconds)       |         0.66% |
|                         | thread-pipes-4 (seconds)       |         1.66% |
|                         | thread-pipes-7 (seconds)       |        -0.17% |
|                         | thread-pipes-12 (seconds)      |    (I) -4.12% |
|                         | thread-pipes-21 (seconds)      |    (I) -2.13% |
|                         | thread-pipes-30 (seconds)      |    (I) -3.78% |
|                         | thread-pipes-48 (seconds)      |    (I) -5.77% |
|                         | thread-pipes-79 (seconds)      |    (I) -5.31% |
|                         | thread-pipes-110 (seconds)     |    (I) -6.12% |
|                         | thread-pipes-141 (seconds)     |    (I) -4.00% |
|                         | thread-pipes-172 (seconds)     |    (I) -3.01% |
|                         | thread-pipes-203 (seconds)     |    (I) -2.62% |
|                         | thread-pipes-234 (seconds)     |    (I) -2.00% |
|                         | thread-pipes-256 (seconds)     |    (I) -2.30% |
|                         | thread-sockets-1 (seconds)     |     (R) 2.39% |
+-------------------------+--------------------------------+---------------+

+-------------------------+------------------------------------------------+
| mmtests/sysbench-mutex  | sysbenchmutex-1 (usec)         |        -0.02% |
|                         | sysbenchmutex-4 (usec)         |        -0.02% |
|                         | sysbenchmutex-7 (usec)         |         0.00% |
|                         | sysbenchmutex-12 (usec)        |         0.12% |
|                         | sysbenchmutex-21 (usec)        |        -0.40% |
|                         | sysbenchmutex-30 (usec)        |         0.08% |
|                         | sysbenchmutex-48 (usec)        |         2.59% |
|                         | sysbenchmutex-79 (usec)        |        -0.80% |
|                         | sysbenchmutex-110 (usec)       |        -3.87% |
|                         | sysbenchmutex-128 (usec)       |    (I) -4.46% |
+-------------------------+--------------------------------+---------------+

---
Based on today's mm-new.

v1->v2:
- Replace non-writable VMAs with non-writable PTEs to be more specific
- Add cover letter

RFC->v1:
- Drop writable references from tracepoints

RFC:
- https://lore.kernel.org/all/20250901074817.73012-1-dev.jain@arm.com/

Dev Jain (2):
  mm: Enable khugepaged anonymous collapse on non-writable regions
  mm: Drop all references of writable and SCAN_PAGE_RO

 include/trace/events/huge_memory.h | 19 ++++++-------------
 mm/khugepaged.c                    | 23 +++++------------------
 2 files changed, 11 insertions(+), 31 deletions(-)

-- 
2.30.2


