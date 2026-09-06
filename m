Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0CDCC79FA0
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 17:50:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF85E6B0099; Sun,  6 Sep 2026 13:50:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE5356B0095; Sun,  6 Sep 2026 13:50:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CACF26B0098; Sun,  6 Sep 2026 13:50:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A3CFE6B0095
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 13:50:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A456D140550
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 17:50:19 +0000 (UTC)
X-FDA: 85184076558.16.76FE6EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2F5DD1C0002
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 17:50:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=miPmOp5m;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788717018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TXvzQ+SLIaLkAFo34lav/ZXHObksvDjOVwRTnAa8CaU=;
	b=i2DUoNLDnmyZrmyuJBr8+Yqq+KnZnAhOModHSXX5seBlrtXiDiVzJPxa3/UzzoFlerC2ZP
	QpChdCe0MUkhz2EzlusgFs+koQFXWSIz52VZI18WXd7oRhp9HHhFk2xCCnMwBr4uhHB1Nq
	Sa7Y5Z2g9yYLwXBjUGdBBQoqYbb9WUI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=miPmOp5m;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788717018;
	b=oYe0gh6ZmT+mW8mpyG5M4GWe93h7kjHfUDoKoMeJg8V4zwqpl9iUOdFooWEcX/ubbLf5c7
	aNrUuP1XCxZ4dlq/1dMTVQtoiUpkpyFxH1d66mO32RVZnqZ6nno9awu8uPL+NjN8HwqZN+
	WFtuMK/go8V79ZrEbm9pROSzlXDaBiI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 21A1F4049F;
	Sun,  6 Sep 2026 17:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7071F00A3A;
	Sun,  6 Sep 2026 17:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788717017;
	bh=TXvzQ+SLIaLkAFo34lav/ZXHObksvDjOVwRTnAa8CaU=;
	h=From:To:Cc:Subject:Date;
	b=miPmOp5mukXNbthtuiyU8nWqkKZHQX4z3lS5ReLyaZZ0JycHmDG4VNzFWUiekePfV
	 sM1pc/63uVcr0x8s2UWq6vkD7Rvqk7dMhykTEGNMUmRW3/h06//kyuvgxx5kwpK3JE
	 NFr6Q3pTPKIv2C0HIyZaj4yGIZwgKkbSPRaHlq9I1RzuTMmpBHRBhv3nyqV1UXngUq
	 5sqtZgPpwI4sg9LLu7NgFLJJ4zR5Abe6nNO6pdc3sxLIejoFGHrZlU+tONfEUc8rkm
	 sVJacsdLqq6vcrQqkCY6Kc/UZSji4Bh82pwWcf5ScwwW87MnaYChVGQbNOSTt5aQnT
	 J1I3eW8UlKMKQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/5] mm/damon: introduce pgidle_set probe filter type
Date: Sun,  6 Sep 2026 10:50:02 -0700
Message-ID: <20260906175009.93471-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8h3cq9wt15s7zth9hrnghraqhuxhn7tz
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2F5DD1C0002
X-Rspam-User: 
X-HE-Tag: 1788717018-219392
X-HE-Meta: U2FsdGVkX1+MSijkIk6r09Psiq5IghghLtaJxRUuGvGJFdJdC/o97s0WfHm37W+2dXYkTJRbAS67WSyfHHMW1zOBwuyMcQskfdBfO75wcXgzEUqUJpc2wCK/OzfNoFpgQsGOf6EDkTtEy2NdoRVDEN1cRND1KJ+O/USZKA1oo0V1WmS3Hp7bVvuxxMYvvWpLgzc0zm5yM0pwshHef+/hKCCuUt87/v0P8gncxVNrdhmrLokKPLwUojMWNb9nAFTAzlOzlHysTVlBKJuvd5cA61gcs0DR/R51DagfaJrlMVj5KkHWB4ty2NA0sWnJl4b8jihJGACwzjwExCDlYsfTL6LhZkxrsgWkyCkq+o5SCSazlQp3yFCS1wNtxJ6dIkzT6BNmQq67aUj79Pl0wwTkYmNNXTPEsxsaIKf3hVWuEn4csxgUm1y9/d/ISZVsHi6SRovZrBGKc7x8O+pp04coijLr+6d+fUgRpSyYKMEn75G/PnfY7UpGcigKQau93AUCnjKoxSJe73JjYiVJYiHNuB9u0i7HG1xCqhs86Jv4ei+GmwU9EPDt/tJKc7XJ5vPGKgQqKGnEG1Wy2LT1D2E85ylIgLtdoNOCahugpqXvrBSjdxCBlRrDt7ovEovOtoyyemJ/USw7O4Cc5UoDzfvGyvzZx1kpS2jVXMLN2PHjFQlTcA5hHsrrCl4gd7EzfMx1qvTlhEuGn8WjKBoADgw+BU4MFGYZ+IM9JUK1L2sBGSo1dJxYQ0n6fgeqVQCPCBCY7/Wp9CjqjOhsYuiQpdCDR6B9Epmzd2+Vs+TcpmjGyNDwstjsTWzit13ZIkDold4Akpk2OF21UTV3c7MSTjku6UkC7VhACc9xT9865wGhBijOgH2379LkC74LvwmjCtcpenFFO0JsBn6UwVpON221IIPtmZ8nHMa2bwamGGK38Rx6nJBlpSWw7oa4DM5E+zLaMnuQGS7lV2sgfRZcLXs
 gm7lcgbq
 G2fHyYywAV/lAUM4XFxpA6dyNEZ21AP4ivoORjP1BTeXP40cJuw92mTW3gtydRdYvzc3u/elA2uXoB1NmhJ6ypyOlb6JskcGFqGg3VbR6KzYi8HdEkfAoWvJUuGo6DbH+e9wq0WXdL9F1BTJNqXidkzIESMbRBRLN5YZooWd+g/NOatmx/HiEIsv43KgAGeEsm2B50uogrDaUrERCm1RpkSZM4ZNkAjGUdDXQG2BF/o6XPIkHvFMvkr3GW7NP8bFVS3mh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Users can do effective access monitoring with DAMON, using set_pgidle
probe prep operation and pgidle_unset allowing probe filter.  In the
setup, high probe_hits means the region was accessed frequently.  Zero
probe_hits means the region was not accessed.  The filter, however,
matches only the memory that can show the idleness.  Regions of zero
probe_hits may contain memory that was just unable to show the idleness.
On virtual address space based monitoring, for example, non-present
pages are reported as cold.  It is truly cold, but if the purpose is to
make some operations like reclaiming or compressing the data, this is
not really useful.  Introduce a new probe filter type, pgidle_set, that
confirms the page is marked as idle.  Using it instead of pgidle_unset,
users can find cold pages that can effectively be processed.

Patch 1 introduces the pgidle_set probe filter type to DAMON kernel API.
Patches 2 and 3 add support for it on physical and virtual address space
operation sets, respectively.  Patch 4 adds support for it on the DAMON
sysfs interface.  Finally, patch 5 updates the documentation for the new
filter type.

SJ Park (5):
  mm/damon/api: introduce DAMON_FILTER_TYPE_PGIDLE_SET
  mm/damon/paddr: support DAMON_FILTER_TYPE_PGIDLE_SET
  mm/damon/vaddr: support DAMON_FILTER_TYPE_PGIDLE_SET
  mm/damon/sysfs: support DAMON_FILTER_TYPE_PGIDLE_SET
  Docs/mm/damon/design: update for pgidle_set probe filter

 Documentation/mm/damon/design.rst | 3 ++-
 include/linux/damon.h             | 2 ++
 mm/damon/paddr.c                  | 6 ++++++
 mm/damon/sysfs.c                  | 4 ++++
 mm/damon/vaddr.c                  | 7 +++++++
 5 files changed, 21 insertions(+), 1 deletion(-)


base-commit: 1c9ae14f592158ed68845f7552f582545cb95c9a
-- 
2.47.3

