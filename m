Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41683C88E56
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 20:08:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3466A6B00B3; Sat, 12 Sep 2026 16:08:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A8BB6B00B4; Sat, 12 Sep 2026 16:08:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 172266B00B5; Sat, 12 Sep 2026 16:08:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E7DDD6B00B3
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 16:08:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3850D1C2697
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 20:08:25 +0000 (UTC)
X-FDA: 85206197370.04.AA17C92
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id B5FA140006
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 20:08:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GyP7s0R6;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789243703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=smoUNIlPKQ1+ngX9XR4JYb0EDk9zUK6MJ9A9qAFnTbA=;
	b=TZvVCC/N+B8A0K1PTfA23TO22wSI7/TEtHsR0vSy/TH+WQAuTiVZlEHOT8GdU8zGr5iQKd
	jPtEDCqqX4eGC4FX36GLOdnas8Clne3/UYb8g0MSYmYA1eNwONYPd9EbDFJph+8TqDCBag
	1/TIYqFCWJk5+coVhbFrojlbAi4HLzQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GyP7s0R6;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789243703;
	b=QVoz5EMaocfvhcOsIq7wITEb+K+TNcO53pvzMQ3V8di8dr33jHcxVpmjn5tm8fmEaK6jCA
	bOPHUqYBbo03mToUeaJDLtU1gQKWW1RDD8+vybFt/eHf6fTYQtdjy/MRJHC3yXFg0NC/fF
	mhz8aIXMH+xm8Hw0lvbKZYt3yAWdUJA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EAEFD6020A;
	Sat, 12 Sep 2026 20:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F541F000FF;
	Sat, 12 Sep 2026 20:08:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789243702;
	bh=smoUNIlPKQ1+ngX9XR4JYb0EDk9zUK6MJ9A9qAFnTbA=;
	h=From:To:Cc:Subject:Date;
	b=GyP7s0R6uwhKk24TKjL48orriQZnS140dDGxiVVZo8TROSrOXjYvzTCiTQLHx+kna
	 Jbgoalm/05tCAcssJSx0GXakZDREjI0bO2Z5lbYEFSSGNWue9vvl6wh07MJjV7npJV
	 eG2Si86iG90PkubUg5Zrgw8D/Wz/gpP+QjrFyonFZHyLsc9BXg8SKj55xJz2vNZZC5
	 F/JLWgdXwIlveZGqnYHAEPTLzSf/F6ZR9jcmt3vlZEpMTeu08eNBdptNw6QZIRQ6cG
	 G487KL3gQIA8/iBxVsgSHREo0ZsHonuO3oCl/Un5Iuv+qKg/D5sGsg7+IcY62GuB1n
	 2/mBQjg3UBzCA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/9] mm/damon: cleanup, clarify, and add/improve test
Date: Sat, 12 Sep 2026 13:08:01 -0700
Message-ID: <20260912200814.145612-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B5FA140006
X-Stat-Signature: 7e1fpjigjocyh6qagdjop98dmdugzh3j
X-Rspam-User: 
X-HE-Tag: 1789243703-823309
X-HE-Meta: U2FsdGVkX19aws02VUC4jSl1CyQgTIhZdQCGanB9iUGznLj0/1kWSdBeCRfsvDZDAMflgrXIKWJXVs7t1f/abJm0NsuvehCe+xi2ooXlRBhFkzbgC9FrMZ6GuQujPt5fRxgbzj88zsm/b5a0CTHDhIh2yE/0yDHQOlLQkhT+gMpfJPJqKfyuNnQqMVlgOrIX90JXshdk41fmDHjaxckXcZ7Ruip+gcll4VgoTqupomZS2FyuRen9bKUmZvAlCURDezh+MQokadAHYPMaQi2ISYNAx29nEynCfx83XE88sWg+CkWwelegC4GdzoqR4n2q9rrgrdGem4yeNs57EZd4PCFWjK3jpad64x/uRpFQSoV9Zi/QPKRy3npLqUx4HrshJmtg6jOKAiJN52EpK/QHRVraNjvsO/UQiR6OBMio3rkGrQfDo4IK4rw7zvymp6f96cDgGIyC8wN9SbX0RXu1SQYcWC9rScEf2h/ISqjwtn9mGw2EmCLk2EoL3TpXXj90nPQIrt7+6CG4rLOglR6bTYkKQdo+e1MlKXim8Vvh05rlOozAMlwXhJhN08KUiwpiIGhW7EdXU3alqa9MD1e5bxJ/+qlUvzJ84i1pXmVumFtbPbedMG3+mXAD2nmoY9Nop0OtOZicDv6JGRVY52S/+vCiglG4BBQp7wv/8AwWTXPkyVTaTL4bF3aXeJF0cwhcvoDBZHdgOPb1IFKYCMVEpCtXc/s5JF8kj9mbLVtFYGBFWITQJuKvREczPmt0di6uW++wrS/VDDtTslr9NrefxDldZ6v417Weq3tWpw2YEqfywmg1Uo5GK4JgLJl4Q2jtsbQl9WxFdOhbv96Nl3Yp0yOXKMh6WBHIsYBvunsRx6Hns0PFZ9XFSU2BaTPfST87ZXd7AAioZmXLbFsWeMkG4fAiTAuyRqkDw5F10cUxH3hQvjMucD9HGb50GNPG6h9DE5t4jD/B9/5jm/NUYfA
 fCBQljKz
 fImgiXkreBXLa1VRMy/XWdomGM+SLuX64g9WP31qISy5ZuG80y7kgZBQaG0gYa6PB6P81gvLtsf3bnS1kIXZ6ArfE8fvhcd/vJclu/FHEBKUPtvqF9vDZfygH4Ra/9hfPjekt6b2hEBWC1uK8UsBT3yAr+czeRxA+EsXlZqyh2LC8ofT/ihw2vOJFRm+U+Y2YbfEE3npxOsTsHvQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yet another batch of DAMON overall cleanup.

SJ Park (9):
  mm/damon/api: remove NR_DAMOS_FILTER_TYPES
  mm/damon/core: use abs_diff() in damon_feed_loop_next_input()
  mm/damon/core: use mult_frac() in damon_feed_loop_next_input()
  mm/damon/core: use damos_quota_is_set() in damos_adjust_quota()
  mm/damon/core: document damon_call()/damon_start() race hang issue
  mm/damon/paddr: remove pa parameter from damon_pa_filter_pass()
  selftests/damon/sysfs_memcg_path_leak: fail only for real DAMON leak
  mm/damon/tests/core-kunit: test eligible_mem_bp commitment
  Docs/mm/damon/design: clarify bp is basis point

 Documentation/mm/damon/design.rst                |  5 +++--
 include/linux/damon.h                            |  2 --
 mm/damon/core.c                                  | 16 ++++++----------
 mm/damon/paddr.c                                 |  5 ++---
 mm/damon/tests/core-kunit.h                      | 10 ++++++++++
 .../selftests/damon/sysfs_memcg_path_leak.sh     |  7 +++++++
 6 files changed, 28 insertions(+), 17 deletions(-)


base-commit: f0cc06ae989195d7280e0e7eff9d963ddc056d27
-- 
2.47.3

