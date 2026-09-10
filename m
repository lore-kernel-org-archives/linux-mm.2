Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD517C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 04:09:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2CBC6B00A4; Thu, 10 Sep 2026 00:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBCEE6B00A6; Thu, 10 Sep 2026 00:09:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7E386B00A5; Thu, 10 Sep 2026 00:09:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A47B06B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 00:09:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ABDE31C225E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:09:26 +0000 (UTC)
X-FDA: 85196523132.28.42690CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3A91BC0005
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:09:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UOhVxn91;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789013365;
	b=tbz+b2pvLtOnI+KWCC+aspvxSXIe2lwvDmuvFM1IKm3eZej1TgZ0F7avwF9wiO+CvVHJLq
	DJmF9jvNzGvBZ5z/GBr/rlgeGmKYe73WzV396hutKMNCDZP61xBvXbByMvMz4UlZ/ztmE0
	fvKkb3eEVlVgTWAk59TUVHyb5kaxCYM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UOhVxn91;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789013365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IpnCkI3XmaUQenTKAoPeiZEhLOladtx3MVkC2IC7tvs=;
	b=JXJySjMo8TU1pDqLWklgAgrjluajNx5f2NO7u1ttGNkE7pG2uNrBvrcX/p0z8U8F2CXUpE
	r5fiAlaYNlFy5ekJPA60DNGw5JyvZMxwVDsrgWx+ScHhjO0iDtdYBbfSgAwbmN7IDdYE7/
	SJuPJ4luL4sh9YCnit0apQUqWFA70ec=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B560C600D1;
	Thu, 10 Sep 2026 04:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFB41F000FF;
	Thu, 10 Sep 2026 04:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789013364;
	bh=IpnCkI3XmaUQenTKAoPeiZEhLOladtx3MVkC2IC7tvs=;
	h=From:To:Cc:Subject:Date;
	b=UOhVxn91pcikH2N175OfGaY4gHnHk3mjXONatrvrYHQ0mIblzptYismN2cf2RzCYZ
	 vK8P/8sQ+6malbd/Jp5hrctjLEMYk3oXOQvlYdyuEpBNfak8LxmCe3Zosg0rqf756u
	 JjY4J0rTVWK9el8xOgUYuqYuXLisdRf8YVp/WkGwl0Wvl/nDdhXyxUzVKS/gTclE7c
	 yEIiJyaPIhvFhk4H6ZiQSpB5VzTj3lOUa0Xnrl3iG7EobV0ImnKerEWmEsCZg3FMnz
	 dyXtEOCny8xVWEBB9SEzwKwzDi3zmZtVgKG1D0u3OC2UVIJFbKr8HYlL5YhnSdVHUF
	 yh9SfR8Qy9OkA==
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
Subject: [RFC PATCH v1.1 0/5] mm/damon: introduce pgidle_set probe filter type
Date: Wed,  9 Sep 2026 21:09:02 -0700
Message-ID: <20260910040911.148273-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3A91BC0005
X-Rspam-User: 
X-Stat-Signature: pemeqtnmqnnnzui6ydthz8xzmqb3b74y
X-HE-Tag: 1789013365-979566
X-HE-Meta: U2FsdGVkX19YMTkW9TkrK59KziEy99ylIDgw1DU4+ANceKNzpZ+xGWIXU/lJq1zZ4SSUuqtPKLRpjD7eJuT9HfiRCJ/sg/wJZNb4hArYxZVmmDjlZ/d7sFo5d3oSzlgf0VqjgL3s1Rf3pRS2C4ttUiIu6OQUJTHa7asfwSQDEytt6B/1xhGWCNRSAg5IooFR3j96Hq7qh+LnCJ7gu8R7LDzQo6VJInYixh2d04jkYpA7+su5t2seVWpuaW9eoWCLCfRZ1zFQNbeIFrIL78UukZdK23qLSSxw7tFoeK32VFwZKmj8eDTWT0AOBiEb46as2FDcYMVkaEiNJLCgs/u8M/X5BLPqG48kemqRu8IHBLMgHPp9hZxSc2O8OFm105FKzv4fVtKIr1N0igCBxkyBDDZvggEMXBnVXrogrVqSZ/01fxVdzdkQiQa3fIcZ0B6OfYe8/mONAhN73K7aD0QpNixAMARwsZtTFTqjv61YBwjoY0d1gD3AMbXR3qBOblXhzyPvoPBL/QAW0wnmBmCZHl9M+mdYyTJWWAwHCr83rjLDJRT0Byys40ajw8l/LCTu0o0l4s5INfv4FF+AJ1MIJ8UNnUMgHkdcl4xIyWb4t4LMVeN7/CCFcSFmLJiuT0Xo0XOlewVGMORpYFNhhhzFR3YpCqxwR1psjX9imgju5YbP2wjzX+R6J2vYRMowh7myi1kgbHus5zgJvdoVChTR/JnDlCz7oPamsc2jKA579RCR0xAhguA9JsEy6T5bPtIEg/u1FtzbeMr2jPOiDXGA2FbPobQFQKwdRV1Tf/7Bnf/aojUkTehaxpyOmIWwKebGvwKDqzASrKfvgMGrQ96t+FUS2cP0mNTXtQzyLubQFxkx9rSpcNAhyyGH5WlP8Nq/ngQUNWdXaF23ebV68XeOdwk0AEXxMNL+JCaUsQ5Ub5aiSvLQRZO7i6iDd9Brsg9yLSFyQyQqE9fwWv+TjgJ
 sEek/Hmq
 s5b0IXDBfQGbEyxppHk1AgplCtPanViIUYTyPa999vFEed5M4XynFeDHq8wfdyupTcR4XrYUVGJ3NGP1/VIek/4KUE2ukJFrFtY0kQBl7+OofvvI2czzBZX3lnJEuxVklgW7OPpcDFO94MGiuPUdrMJhpUoYdr6a+10qVNqv6XdvI4ogyxfcZXbaJcphLgxheZbgnQOSlssgmWpKQrs4fuofbAMA2Gd3Y6MgRRI9uMV0ywcG0T0ogHfngItUVOOeCXQqMdfc0TG4Dbht5FnzFIa0dQFzUflwKcKoQ
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

Changes from RFC
- RFC: https://lore.kernel.org/20260906175009.93471-1-sj@kernel.org
- Rebase to latest mm-new.

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


base-commit: 0dd30563c006765cf3937091901dafb02957ab45
-- 
2.47.3

