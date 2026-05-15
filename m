Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C4F7CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 08:49:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 460206B0005; Fri, 15 May 2026 04:48:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 437BD6B0088; Fri, 15 May 2026 04:48:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 375116B008A; Fri, 15 May 2026 04:48:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 28A466B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 04:48:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CCC87160F08
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:48:58 +0000 (UTC)
X-FDA: 84769029156.10.D59FC67
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 86B4F2000D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:48:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OmiQSeHT;
	spf=pass (imf03.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778834937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WM3lHdrMDhxg0+xtruE0NQZ4vJRyK0afx2h5jLjqFN0=;
	b=rZDlFyOb+z3D7fBz8EwC9Wdmb7AZgbOAetnSjFemAJtzP4N0V+Zx97WwOpkVkBJvAiMJfs
	77jfLBfGiCJg9pH0tI5mJ/xxp+RCi+ytApyK4C75iNXvN9+ijX7ny0BgXBC6jkc625dGNV
	mYbhMBX7bvkbBlDWjIYkYlri6rDBNDs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OmiQSeHT;
	spf=pass (imf03.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778834937; a=rsa-sha256;
	cv=none;
	b=g+uhu4Q8Co+OXVCzEp6TB9NQ2QUQjvZk/V6M/auAHlWTAmBx6tzhysc76NkO0hUKgVhk4k
	0hV9YQrqwsykcYWIxEwosXs+hp0HWW1K6OdUuA5C2B+wQRoTAL8eOVz2RPfxf8Snt+8OKq
	GhcVWPPwMSRzpeaFzpketFrTZcSnNAs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6E77F22FC;
	Fri, 15 May 2026 01:48:49 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.82])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F42343F7B4;
	Fri, 15 May 2026 01:48:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778834934; bh=RTcF/U1Y6oPMyTlW+ZZLgcOOyaQjN+u//4XIQ6K34CA=;
	h=From:To:Cc:Subject:Date:From;
	b=OmiQSeHTvLPuSauwrwISTdCnc5In9VBNO9NrxaUkG432UuGauw2O2R0ebPuHl/HfU
	 tyxNGWuK4jzDgGEK/k+h8U+bNBPTCmjA8cOzipcGg0/FZVuzTdov6iNm7aiC0SdECp
	 sNc7l02WggEELdYDQNIsgiSavjHAnFfmdNJtUZu8=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH 0/2] selftests/mm: separate GUP benchmarking from functional testing
Date: Fri, 15 May 2026 14:18:38 +0530
Message-ID: <20260515084840.174652-1-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9imwkfstyr3bbtggpj8g68xksjqt5pdc
X-Rspamd-Queue-Id: 86B4F2000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778834936-601377
X-HE-Meta: U2FsdGVkX19+OosCDR/rOQJ8OQ2AGj5LkERoBFUSmzcDSKXtkMKb3wJLWDUrJ1DfnxzbLKPMChJNAt9+N1nFOtBuM+Wu+eyKc7lA0rsa2CUjhX8U8iarP7x3ITY0tXW2wFo5TlvZUsouEjkOzr3uoUJdmhDw14LZ7MeBJQ+yGMUy7Pcuq4flqe9EnBYGjoOmrV5jGcE7rMrxHt4oWocmXmOtmthDxkQm4U4cX21RqAtJK4M2xiP4Cs0gsfwwEHxEJkLzSWj3EMox4MKiysg2h/MwEnCBV5T6zIi/g9RZTg7bRu/4uMyqU4GhaCOsOYsfvEIrZA0vsodwYduOcGatO4L2jvoNEuRBG7ksF8zonmCU6i/pnzhoqz/xUePKxgvLQg0EIjXspTGvKn39o8dW3kFcdoWGrAnWwGm4kQVwtoG95bF73YAByyRzoBni+aKJOhZC0bGBtI9Ou+HJzo181P9fnX39wiwZbiin3OR82wZ1m8Msg7Qv6PrjJ9zQFxTJJJTbhZwRlwlFyGO6Mj9khGDtnD2/dlWA+462QGwOWN1gGezDHXMnN0nTwUL3Fm+qAHMOkSkC7AP3ujTy4lC/QjXYbTHO4uJvNCe+GEUY0OgclpPHoulXjpjBkFtjycfMjE7o3pxBthAiy5+mph2HnSUnyRRFP2ybnm7UNARxYULl2/3QhecpQfWWirkd6eFu1awHmrBl+vKeCNxn00QtWkEAa8JFOXyJFFYdZ7mridgUnBV5i9EAwyOjdX1NmJdG3nERKfOeoqbHWGq6fV13W6SJryckYx8WZtn77YmzmHqF+Wr8FOauGxgcDbgxH8Qejbf30cmVQ6W1dKBxe5g7KOpKhKPQ4VoL9f+s7sNNbEcAOm1dxZU6R6Ervts/29RXAYsnDtoLLEnn2sLf2f4XEauTygNMeCKaQ/o5iIk7nB4MyOOXeL4ipk0RT/mkQM6X06jYVT9vXraul/jzgHQ
 cWiUQUgt
 xAK06h+iuJXYBnNoqAEzBp3N23bsDq62FDlMJV9VZ4GQg8GOBpBBtpe82c8PqELotLRQ55WfROzACLtX0ssYDuHvAFwFXNA/Fue0vHyy4yGgG35jYl8GTxvB+uvyd2RFG27iBwbP96iuKxILLToa1nmovGAGPQJ0g9Gaj10+lIwY3Q2zfgTFhohiGhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

gup_test.c currently serves two distinct purposes: microbenchmarking 
(GUP_FAST_BENCHMARK, PIN_FAST_BENCHMARK, PIN_LONGTERM_BENCHMARK) and 
functional correctness testing (GUP_BASIC_TEST, PIN_BASIC_TEST, 
DUMP_USER_PAGES_TEST). Mixing these in a single binary means functional 
tests cannot be run or reported individually, and run_vmtests.sh has to 
invoke the binary multiple times with different flag combinations to cover 
all configurations.

Patch 1 adds tools/mm/gup_bench, a standalone benchmark tool that does
not depend on the kselftest infrastructure and can be used independently
of the selftest suite.

Patch 2 rewrites gup_test.c using kselftest_harness to produce clean
TAP output with per-variant test reporting, and simplifies run_vmtests.sh
to a single unconditional invocation of ./gup_test.

---
These patches apply on top of mm/mm-new.


Sarthak Sharma (2):
  tools/mm: add a standalone GUP microbenchmark
  selftests/mm: rewrite gup_test as a standalone harness-based selftest

 MAINTAINERS                               |   1 +
 tools/mm/.gitignore                       |   2 +
 tools/mm/Makefile                         |   6 +-
 tools/mm/gup_bench.c                      | 491 ++++++++++++++++++++++
 tools/testing/selftests/mm/gup_test.c     | 404 ++++++++----------
 tools/testing/selftests/mm/run_vmtests.sh |  37 +-
 6 files changed, 679 insertions(+), 262 deletions(-)
 create mode 100644 tools/mm/gup_bench.c


base-commit: 2c3f468717231305523ddcd94d91c0d5e4a72419
-- 
2.39.5


