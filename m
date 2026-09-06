Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF714C79F99
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 21:05:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF7C76B0096; Sun,  6 Sep 2026 17:05:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A72726B0095; Sun,  6 Sep 2026 17:05:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93A246B0092; Sun,  6 Sep 2026 17:05:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 693256B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 17:05:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CEA4DC05C2
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 21:05:24 +0000 (UTC)
X-FDA: 85184568168.26.0D23C95
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 56382A0003
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 21:05:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S0wOCysI;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788728723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tJB81UTgzrSfPhYv5eHHbGNV659HaY2JEk6GKYFHi0k=;
	b=ywbLgj+ORVTM34nBlB6u2JA7g5mSvYNLGdyT9rZr/QyFjHHYmVbskEfGYw249+Q3lr3qK5
	9ZmYhNHfR2gDRjCJPK6Mj3vIh10s0l4kndEHbgxb1I+LydLvSDVqDT859RBtOELjtEBvMT
	VYcPjwjJdxyfaBxGQCpvG5VBwWKIvx0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788728723;
	b=GeD8wr9xFz+p2sOqjwsGStCniV9InnBGkNoIS+c5K5uv4iSmLKJWsUw2bhLVfP+7XH3qqm
	z8r/TanjE9zHAXRUiyTRWCbQvkB/ud4olsLQZfOfr3xZLFmrykQZe+500tndWo421SGttF
	9tzjEAlADq3Ou3TFJUY5IDSXxTSgXIY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S0wOCysI;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 24BB4601DE;
	Sun,  6 Sep 2026 21:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C721F00A3A;
	Sun,  6 Sep 2026 21:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788728721;
	bh=tJB81UTgzrSfPhYv5eHHbGNV659HaY2JEk6GKYFHi0k=;
	h=From:To:Cc:Subject:Date;
	b=S0wOCysIgW+9naXrgkj4wzl/6wFSrTfkTZ9KQIHBnR6bB/Yj/Bws8uCf+uVyjSJgg
	 p3YRGIgEiCMn4CQBMTaeOYZeHbPD/XdTeamAWbW1qsBEO8ncCsA1Ku7y4Yai40TBj6
	 wiBIvgVvy+LUmXsxVHzUE4JxEqxRppss3YSVu4DMvgVgzgy1aPGqrc7q0xFxIqvfMW
	 EmJ1ufzWrIieg99vs9+qAuQzo85z5QqxO9uwwBzFP43g7zmCl6MBfFONtJeGFphDqL
	 GzxLKAmTozx+KY4dydyz3OQYuVQEfqtada9sXjJvLsi5uWO9JsCDcTmcLGjSQ/SSmD
	 arkVrjqfWrNVQ==
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
Subject: [RFC PATCH 0/6] mm/damon: introduce probe_hits_wsum DAMOS core filter
Date: Sun,  6 Sep 2026 14:05:06 -0700
Message-ID: <20260906210513.106895-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 46moqp8wfggh84w5hcmmo53mewrpdi6d
X-Rspamd-Queue-Id: 56382A0003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788728723-50245
X-HE-Meta: U2FsdGVkX1/VQ3RlkZBjFCrVk7/Wri9e4F2eKkr10efcjUVYL9PPzRSnwkLFSDvSNqDVGjwX5VKNo1M4nQ8I3JnSVslZcvXvtvTsIKuzPeNEq/osURlUITOfWjKfNjqomsqdeXPV4WLq3yLZ8ocpOb9CdqwDSArVDTBq9qet+PWNU+k1bVtsRcGj9U0Qu2tafI8ekQbTXbO8wkIXgWyWZwfOTSaR2b5V3lIzfUUsn8SLCDS8R6SkpG4iPLEIgzdv7e+5+dSUT+P/rEeK7QTduDIbZqafZFq+D/zS5JVnU7Q1p+jaV8Kb9B/WdzxUaZ46AOTrVV7wStNmK98rz7qAR690sGmrz9FH+LUuOQ5AVzhxgkISXiG/cZKj/JI4RfnVukYL2hrVrarCx2dO2VUlQw6CV8F+yaufJcwT4K91hOoy/6ZbdtoUBgXE8Nz0N4Ex01A3qBVMrDTdz8yiFB2meWucjwORWmy6EM367yn/u5C2w7ztY6XkN/EXdnVD52rXZx9/51HQZKD9cZgMm3bP1/37jWBFRxWPGR0kyUKAorXB1nFOGngHxFm7Zed2/v0XzpwZpZyTFJXoLyVd6iG9G4Lfqtq3eXlgT/fHyBImkvb7tcAMOXIHj+spg52i0Eecv63RNqnWqrq6orU6548UBS+LRFzxRz8BDHAi7Citzf3Pib6XAlyYg7QsYJK/znLRLim8oePRroxxuOvIAkCeFA2SxIHI0GWf0klBnyAelYoj2nli4BYUB5NMsxCGG0iYmgtfgxurfUcSpdr1eJK4BvzUxuiS7WvYBF4ryoFvTipMFA0iYoKIPPyx2CZ11DiH2Q0darQny6ei+V4y7da+LItxJFaMY96Cg5Sw/+XKo/Fz1zMF3XGMbFxkOZD11XN6CFGCgjHWRHyVJxz9iBt8SLZLl+KOMqSDLyoYFZpV6TyFg3wcQozN/S1FRLarGK0LnK64o5isJK3tOQAo+uv
 5DZR+CR1
 VOhEGdpV0U1cY1+78wP1wqPEN1o1vvnEwxp5nfZA9t9xoY56RSIyHaWncx1pN5r8oSwu+fHyaUzzP+vF4N3dGcrWXQdb8mMAtMKy4DgjskKRvN34L6w2PFUljBgoJm42OVVwSPvlzYeLio6ZSA/ZHyake54HuogMQrxuUR1Iq12EX/PJVnyEGcgn3Q8b5Z8MIAndZyFE465loJkL529V7jyXeCA6gFI6lu6vGzTpxQJH3faluIR1Qob81io5jCWcxg4T1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON can do flexible data attributes monitoring.  The classical data
access monitoring can also be done using the attributes monitoring.  The
access event is just one of the data attributes that DAMON supports.
Users do monitoring to make some actions based on it.  DAMOS is a
feature for automating that.  However, DAMOS cannot utilize the data
attributes monitoring results.  It is still Data "Access"
Monitoring-based Operation Schemes.  It requires users to set the target
"access" pattern.

DAMOS core filter is effectively the same as the target access pattern.
It is just a more generalized and flexible way of describing the
operation action target region.  Introduce a new DAMOS core filter type,
probe_hits_wsum.  It specifies the filter target based on a range of the
probe hits weighted sum.  Using this, users can apply DAMOS actions to
regions of specific data attributes pattern.

Note that the classic target access pattern still works.  Hence the
target nr_accesses range should still be properly configured.  The new
filter would be used in only data attributes-only mode.  In the mode,
classic access monitoring is just turned off, and therefore nr_accesses
of regions are always zero.  Users could simply set the target
nr_accesses range to include the zero nr_Accesses regions.

Patches Sequence
================

Patch 1 updates the DAMON kernel API for the new filter type.  Patch 2
implements the filter type in the core layer.  Patch 3 refactor DAMON
sysfs interface internal data structure for efficient reuse of data
structure for the probe hits weighted sum range user inputs.  Patch 4
updates DAMON sysfs interface to support the new filter type.  Patches 5
and 6 update design and usage documents for the new filter type,
respectively.

SJ Park (6):
  mm/damon/api: introduce DAMOS_FILTER_TYPE_PROBE_HITS_WSUM
  mm/damon/core: support probe_hits_wsum damos core filter
  mm/damon/sysfs-schemes: rename sysfs_filter->sz_range to
    range_{min,max}
  mm/damon/sysfs-schemes: setup range_{min,max} for probe_hits_wsum
    filter
  Docs/mm/damon/design: update for probe_hits_wsum DAMOS core filter
  Docs/admin-guide/mm/damon/usage: update for probe_hits_wsum DAMOS
    filter

 Documentation/admin-guide/mm/damon/usage.rst |  4 +++
 Documentation/mm/damon/design.rst            |  3 ++
 include/linux/damon.h                        |  8 ++++++
 mm/damon/core.c                              | 12 +++++++-
 mm/damon/sysfs-schemes.c                     | 30 ++++++++++++++------
 5 files changed, 48 insertions(+), 9 deletions(-)


base-commit: 787c63ba44ce65021966f55673e27d778c8d9c68
-- 
2.47.3

