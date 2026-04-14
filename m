Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25979F9D0F6
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 23:59:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CFA86B0088; Tue, 14 Apr 2026 19:59:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47FE46B0089; Tue, 14 Apr 2026 19:59:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36E9B6B0093; Tue, 14 Apr 2026 19:59:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 233986B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 19:59:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C471057F37
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 23:59:25 +0000 (UTC)
X-FDA: 84658830690.24.6991AA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 348E440010
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 23:59:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t8NiXV9W;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776211164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+usz/pEenZ6o/UHisQg7FlAFiNgpvssIwSkQhOalzAw=;
	b=AM91nXW7zgJotZwcXo4UTXzjo3KvfVvYzQ69ey4bbl2i9qJxLkXCKV/lNHMSwfAcD2rNSY
	eNCU48POMlc4NJMu7hIhjgv4kwtuJ4ZGEBJrseGYYzxfSwQOZXA5vVadJlogRJtWT4Q2zF
	P+1/Kb4W8aUnj5zvp8D58WUQaJIoZIc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t8NiXV9W;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776211164; a=rsa-sha256;
	cv=none;
	b=kHvBG66ng5+zG/+l8576pAbp45gpMsJJIyMQdx7b4/yG1GTVke0LLq92ABmvzrqkpBk7PL
	bJ54uKZvR7hjpbrlcKKcbYlhnRdCq10QD3sEdjDrxan2d+Ze62CAsiIcRvgZqYwiLS6I69
	sD2dFUZxkHb5AX+PGH4P9ZNrF8dFLIE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 230A543989;
	Tue, 14 Apr 2026 23:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD20C19425;
	Tue, 14 Apr 2026 23:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776211163;
	bh=aT2joNhwB38aP+3ueokcrxLbjs3TuKPM6sz/BJoGywc=;
	h=From:To:Cc:Subject:Date:From;
	b=t8NiXV9W8dHj+xU2joGruNKXvO0/2H8x8+UD6hI61Rbyf0IfGwER4zLs6cs6VuciL
	 u/OVlHWGPZcLEPhiGrOZslOrHnnfsCS58mAVDqaZ6XTUkQqNKtMfpKRgIi/mHmpPbN
	 6tw5vX/d0hBBO20SxZ2MXvRjxCZHrmeN0IVcm+qtxc9gB9Yn67wMUUJXGORwFhbkQX
	 BSuJC6O7F8vOxWVPHzcFMV9wf0K/OnvFOBnIDjQjLKWRAkTytxGmm7sDpA6vt2SG9c
	 Va57uA3o2dIqPBE2qxgjuxNsIONwJOiJZ8o1DSaLMp9N42r64EGc/wP76M7Dao71SK
	 x1qOOP52xgZhg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 0/2] mm/damon/stat: add kdamond_pid parameter
Date: Tue, 14 Apr 2026 16:59:09 -0700
Message-ID: <20260414235912.98174-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: m7mycobwaqmjkgixqbzzq4q1jyym7pru
X-Rspamd-Queue-Id: 348E440010
X-Rspamd-Server: rspam09
X-HE-Tag: 1776211163-674199
X-HE-Meta: U2FsdGVkX1+M2lC9lrQJEcTkpA344mu/K1kJ7ZtpK711ZbVWlhS32HmQk+4M4hnYb3xymoXA0x2qsVXvpNkYYx5Ba2l7KHm1yHISy8ss6VnQmDQxl+pfVKRrjnqfsJG+1y3cP5E4SpkwHvYAJ9gWlxUhWZ6Dc5TdQbljkLGhIYLzMr9bpIhqhBCkQgpL6Q+KIJwwgApQCpxflq0Dk5WMLAGWIkl7GEBHgrhfblI0uUrTNbTeanVLuXHsL5jUykYL5AQg3fJdJ45beAlCcHW9ZBqhWWUEpWYufNsyI6KxIYG3NM05ytPlynF+EyThPY9mQPYpsOLW6qQgyBB+3wxYSjB7MB/CBRyHrLU03JY+roOJftRHzX6R/7GIpE4id66+8vfAOIa7o46RJaQe0lbWqHRPVskVQKgS6FavrhdFvGP8uwGrC8mGXuNbVXYFRPqCAgkvwFaS0qaR/ZfqRvauxqX21VjvbqGlyDY7r+YwaJDe+zoIT38FcYW9yQEsh51Sw9CmATOQ+S96zEZky8YMT2XFZDjlqhCBPH1jNUbnXYVB8mNL/afXRG4hQU5OcKxjY4edRRD0vcO8aVOSK89ELUy7uhTEE3+2KgA9Lth071NdC3Ko42yA7swSQ+NiSyZVINkhenlTx74DGotyBtzryQF+urouHrUncv8UP2Fa09joOOxtzUT1EnLCvwXmnmHafaJbaxgayw9b0SsaGU304nKhwPmNSnozw3yzV5qf5mEO9k3rPy3/DPxD1+Tv5LjAqxtu2rWlrg3w/68jKQP8gJ4DRvDgY8ZTVJeDFel7kU6wYOzlwUkLMpR+DZKGZSpbI4QBzStuX6jes6XyVjultMPYYvQ/5ho05CXoF6q2QffPGyc8WWPp9eBTsKsYSFwB8LUxt1BWp4M8PL42fES3azmFg1jUGcMNuBolxPqmV0QSb3y1bzFiKhuQNSHZF4r0cAjAbrUeTc9LfYqGIey
 24w9bw+W
 Nczsa8yG7jF1oAcds59jmvc0YQXQaQDHkKbyZWEC/1oxSmdpfGfIOMP4UfIdQ8u9P/TdO+OjkGV9SciaRXT2IRspysefIcLeQCsejPdE4VS0WGRpr5e1+AULVZyXaAd35VkPmRSV9eKI747FS4+crgT1Vdu1W+MP8bkGJsg9nhMM5b9+QDSkcBxZw16Twu8UADggYA3UGrmaTw+8fJJejHzHyMELX89DDk9Tn6D5csVKsdMg5dTsodAdkObgCFvNBFL9w8RkLblkBWVMoWUmqb1CEEyU36/pHbSJB8pTJB9jBE7oa1L67i5eDme6/a4CzL14k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_STAT doesn't provide the pid of its kdamond, unlike DAMON_RECLAIM
and DAMON_LRU_SORT.  This makes user-space management of DAMON_STAT
unnecessarily complicated.  Provide the information via a new parameter,
namely kdamond_pid, and document it.

Changes from RFC
- rfc: https://lore.kernel.org/20260414053742.90296-1-sj@kernel.org
- Fix damon_kdamond_pid() failure handling.

SeongJae Park (2):
  mm/damon/stat: add a parameter for reading kdamond pid
  Docs/admin-guide/mm/damon/stat: document kdamond_pid parameter

 Documentation/admin-guide/mm/damon/stat.rst |  7 +++++++
 mm/damon/stat.c                             | 17 +++++++++++++++++
 2 files changed, 24 insertions(+)


base-commit: 02784c37a710fa3c8c3e7be4f27a5cfa3356dc00
-- 
2.47.3

