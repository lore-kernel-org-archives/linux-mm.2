Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47A82C982DF
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 01:14:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B38F06B00F0; Fri, 18 Sep 2026 21:14:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE6C46B00F4; Fri, 18 Sep 2026 21:14:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 959156B00F3; Fri, 18 Sep 2026 21:14:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D2CD6B00EE
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:14:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AB72BA0119
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 01:14:10 +0000 (UTC)
X-FDA: 85228740660.23.9628F3B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 249B514000A
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 01:14:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Yj/NwpFo";
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789780449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Zb5CytK3hYGdz5zNBs0yHNibNYLTEYY9210AEwdD6LE=;
	b=tlcxalDLAhv5G7cLYv/gnqmwXuP0fILiogM/5Xy2BbanNRCfH8dSZeOR7CIbN+eRFDS2dU
	TtjS+VlDitLSrUq1vogkfTLIpdEU/jWPfDAP3mGTzuogsr7lZsJrcMJntcpBvbDBW1En5X
	RXLptDMX2D+uxriz7WFsaudWEyf02kc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789780449;
	b=FzDW1IhYm2cNpU5pItT9bJHAnTr779/lBuhKdbCWUp62MqDtmVlNcwv4CbA44e1zMSBfj8
	1CGOBpQXlBdHoH74C2NNoePrWHviFsCkJ3CvxQlPW8NDUrWQjosa4UdL/mcwhR8bNPrEW5
	N+RR1jY0tVmd3xCx3J4ARS48SEXPEUc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Yj/NwpFo";
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 84F5E6053B;
	Sat, 19 Sep 2026 01:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C431F000FF;
	Sat, 19 Sep 2026 01:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789780448;
	bh=Zb5CytK3hYGdz5zNBs0yHNibNYLTEYY9210AEwdD6LE=;
	h=From:To:Cc:Subject:Date;
	b=Yj/NwpFoDHOxMfDN3lLRnXCT5GzM3QUuYF7ZVmAiNqK29M8boQiCTEe8yKrCVj63s
	 fLAk8XbIM1Me0N/FDK0an4iweUCUZS31ludZnpSKf4zY53M9nQtp4wBZzgZMUCnKOl
	 Qj7YDHSocgO3EfuOiZokUsHuBAsOTVZ89swhot8FH+FI1zZeDyrNxWe+ufesq3Pp9+
	 Ute+vkKNPD3DzDg9BLKVfRIPCHj7+bHoTOqYrXa11GonE91i2WVxefTuR7gLS3gpoK
	 lv8ogbNjBUbJaaQ1vGKERY84aEpCPl2g7uppasxSIWtefwVU1PY6QXhbKlu8SN7vyk
	 B+zIMBZhyWPRg==
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
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 0/7] mm/damon: introduce damos quota goal target metric complement flag
Date: Fri, 18 Sep 2026 18:13:49 -0700
Message-ID: <20260919011359.88921-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6e9crwn7oygmkq3cmmkywwsxnhdii1tq
X-Rspam-User: 
X-Rspamd-Queue-Id: 249B514000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1789780448-858233
X-HE-Meta: U2FsdGVkX19kOy4ftCuAQxLsFo7Pjk1ckyC5DeUaoMmkJOL6CnI47QOzrmm09pRNBPHY9V1W6eATTdNW+bIynK4YcSUx19KBXB4gyLjYiI2YlAKxLYYMbmDVg+Qb/agGPPqWTCKKaBcMDM9Bk6OUJAJ/geapVvrpWSPYbvLaJydJ7AXTtZbuTuvu6fs9NQwOnOTv8i0677Sdqk6PWlhEORR48JZv+y/oPi6sNGQHIP+O4UUTb6c4BB2rpZnpI0sgnEBxVBTnUxFz+2A8lYdkYjvTMqyeZZm8e7daBCzOaAp1RtEY+WTVo5B9Yy33DGyl/UWczN9RY4FMzNJ/zAxQBVCHK5mCk6LYOQlyeebB+EdMUinIUb5ujEEofX7DjpCPHwaOiYcY8oXo4WGWxmpbMVeo09n2neJs+M5o5wLmz+rVkshFMAvdY3cbso8XOED5pxKIFH4pIUZQxH0Fmy3i5e3geVnLTOUjwzM3VR5Y/9+DTlRBuFY0vEV0Mfrk4x9hNa2/RdiotirCQBjnUH9w+YfboghZ0KKcpNv+IUMN3BUFHkkdi1I+FJZb66IkEEYaJfv4wFIn/R479zgTufX1W98ZBti0h1mmNrVxaycv3pB+UMVlZ3K7bqQhkhdXjefaOXJQmkgcGuRxQOkPSTC+HNmXGHSAdAom/ODjRyo48OkYXK2g+C0+QOevgVDjpYv72fmhkdE4T7E7sUvgJ4kmutt/L+kEJ4dDvPPhMbIQxx2h1KoN9e8XR0uHKQg6Iwo1r1dtfYgQcK2eS4m/0arLr6YSXknomzLDitScap0a4/tQ3jLR+IG3LuG6iiGFUmE8lWsbYT6X/+90hn+KI876eSykHRQPsLN5F4RhshRl2WIHU+sPO2bk0GMw9uLOE7RrgKXrr9CejXnm7zsRNY4bVJ/sIHscdtA6hsurHxVI2nFLAccPxKWnORBorqK8/tzRLkwG6PjgDk4oSos5PDm
 mh48v4Er
 ixZTWM+hGjduiZwbJ0Sk0eHYQTfTMXVIwwEiYEFXl36AY9xVkcuBZvvxVqIV+gTdIzWyWlVtmdkNlip4Iuo8sfkd4D7zMP6qnoFwbESDs0mztw4on/8eUO9MtI8Pm4/hQIhMCoZhArK85ip6bMYXh4RK6lUmPwXtQLgv6pm0AhbShHEZtcdWVGWK5cNRDXMyFWq7aQ4cmh31unLmmzQy+73rCZeO/g7bYnVgZJvY4B6bk4l0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Aim-oriented DAMOS quota auto-tuning assumes the aggressiveness of the
scheme (quota) and the quota goal metric are directly proportional.
Depending on the scheme setup and usage, keeping the relationship can be
challenging.

For example, let's suppose a memory tiering approach for higher upper
tier utilization.  One common idea for that (TPP) is utilizing two
schemes, one for promotion and the other one for demotion.  The
promotion scheme migrates hot pages from lower tier to upper tier,
aiming for high utilization of the upper tier.  The demotion scheme
migrates cold pages from upper tier to lower tier, aiming for head room
free memory of the upper tier.  Both schemes and their goals are in
direct proportion.  However, for this kind of use case, we need to
implement two different goal metrics (per-node memory utilization and
free memory ratio) while essentially the free memory ratio is just a
complemented value of the utilization.

To avoid adding too many new metrics, we are adding metrics that turn
out to be really needed for each found use case.  For example,
some_mem_psi_us, node_eligible_mem_bp and hugepage_mem_bp don't have
their complemented value version.  But it is not really difficult to
expect use cases that their complemented version can be useful.  For
example, hugepage_mem_bp use case may need a way to reduce the hugepage
ratio.  That would require a complemented version of hugepage_mem_bp.
Adding a new metric for each of such use cases could make the number of
metrics unnecessarily high, and discourage flexible usages of DAMOS.

Add a new flag, quota goal complement, to allow flexible tuning goal
setup without unnecessarily increasing the number of metrics.  The flag
specifies whether to use the complemented value of the given goal metric
for the tuning.  For example, if the complement flag is set, the upper
tier memory utilization ratio metric works the same as the free memory
ratio metric for the tier.

Changes from RFC
- RFC: https://lore.kernel.org/20260918142827.85303-1-sj@kernel.org
- Avoid quota goal value underflow.
- Fix usage doc for number of files in each goal directory.
- Rebase to the latest mm-new.

SJ Park (7):
  mm/damon/core: introduce damos_quota_goal->complement
  mm/damon: add complement argument to damos_new_quota_goal()
  mm/damon/sysfs-schemes: support quota goal complement flag
  mm/damon/tests/core-kunit: test quota_goal->complement commit
  Docs/mm/damon/design: document damos quota goal complement flag
  Docs/admin-guide/mm/damon/usage: update for quota goal complement file
  Docs/ABI/damon: update for quota goal metric complement sysfs file

 .../ABI/testing/sysfs-kernel-mm-damon         |  6 ++++
 Documentation/admin-guide/mm/damon/usage.rst  | 15 +++++-----
 Documentation/mm/damon/design.rst             | 13 +++++---
 include/linux/damon.h                         |  4 ++-
 mm/damon/core.c                               | 25 ++++++++++++++--
 mm/damon/lru_sort.c                           |  5 ++--
 mm/damon/reclaim.c                            |  5 ++--
 mm/damon/sysfs-schemes.c                      | 30 +++++++++++++++++++
 mm/damon/tests/core-kunit.h                   |  4 ++-
 samples/damon/mtier.c                         |  2 +-
 10 files changed, 88 insertions(+), 21 deletions(-)


base-commit: 026f1215e57024b54116f6388ca96c64ff84f44d
-- 
2.47.3

