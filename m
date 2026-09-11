Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7901AC88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 13:55:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AB8F6B0093; Fri, 11 Sep 2026 09:55:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05BF76B0096; Fri, 11 Sep 2026 09:55:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3F686B0098; Fri, 11 Sep 2026 09:55:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A39686B0093
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:55:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 11DAC16023E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:55:21 +0000 (UTC)
X-FDA: 85201628442.11.12AF9B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 724922000F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:55:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dvpeu/2F";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dvpeu/2F";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789134919;
	b=VV+gx2hK4BzObdmoHNwTEm5JraBR6eYLlN1N3lLMucOjN1hx44aBQBAw/CpYIuqm9BWwyP
	zTQBx+/Q8/3BLNPRa20PjNn207BR5Yibxwp6/pZECg9xLsfm+GjeWCyj9B5iyeDhFXRE6J
	M2/6Nngdom6E+e/mllMhyc+HRhAFRkI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789134919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fAZQzRBgRrm9eHxZI3qPgkDGXnuB9LQ39hNTY8psKnY=;
	b=gBwNd/KU/jyxdfLEq4L6HF74MJc7QC7r6kXny//LwoLCmTFByKHX+WBMac+HxiHk5Hiqj1
	kYcH830QW6YQKp7DzoUACUoIJhe7rlURMIu15fMy+W5AIVjVjR1CtYPnTQaUFAHThBm1FB
	neSdwLr7mecwwm8+9CFSbmnwl6HBT7o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 020E06020C;
	Fri, 11 Sep 2026 13:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B30D1F000FF;
	Fri, 11 Sep 2026 13:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789134918;
	bh=fAZQzRBgRrm9eHxZI3qPgkDGXnuB9LQ39hNTY8psKnY=;
	h=From:To:Cc:Subject:Date;
	b=dvpeu/2FsiD05c79j971JPnbwVDxf8XY8OczJKP073Eq0Lji1J+UwE8vW4d2SAO4J
	 0Heof6xseU9mQCddUtSoXr/4TTIuWh7ILBesy7KXMXBPU9HotRBaOrhjQChGBgNM0d
	 9+B0nODxzVktTgvp6apKSmIpKPb240aGXOZRUo9ifmJjXIjPHDG50W8azE63Cl440D
	 //qOmPTeKRQ+gRQWpvRSCkuI1g2CpwhwquNx9WbHbnLuPmi9IsGTup313OpJXLD+uE
	 gv/ZGz+H923/sYIc/g0edoO9eiqSLFmGIFcUNBgaA++UNFpsaCV32R2kqs8gY/y7u+
	 tVdprEUu+88lg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [PATCH v2 0/7] mm/damon: introduce probe_hits_wsum DAMOS core filter
Date: Fri, 11 Sep 2026 06:55:02 -0700
Message-ID: <20260911135510.96914-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 724922000F
X-Stat-Signature: n8pdm9xdj1ce3augtwykoimu5mympbd8
X-Rspamd-Server: rspam01
X-HE-Tag: 1789134919-729049
X-HE-Meta: U2FsdGVkX18fqJkiR8wAn3qpccjOQzasVYn7wkROGM9LIqzsGH8ijyEnu93p/LoTvkmZww4K0Blb5CthmmY4NSxtRV/GeCspUxORRYzUqSCafz0q5CdMaZyc43veXHAoKr1T7K4UgAycC7at8PZLOeaiY8NVcNkxf4G9cquG+9AdTQJxX60nNa6ITiDpg7to5h31A6zBPZCiI3JwUAmf89b6Hv5BMYLjLh1sFaOMoDO5xxcf3cbXrs4EnjtvMbtKANa1TbNkD7RJkD4Q9ApwE4Hg/dRnKjChZnxxBI33fLnNfrtgOacg9WMYq43u+d+pgnh5uBiYRDb23wayaatfIqmr1k+7byFRbIJE3PAcLkR+OE7ExLbwisaJifuomR5cYxPkNVOyp3TDVm5o6XI1TJgKj3Uq86MRGoam+C5QnqvWN9+hxr4p3aNc5DSylwr6GvCUhUXU+1jMYwh/z0BW/OUl7iqN0zvAas5EyOOknpWoi7o0MHml4/elfjA+nwUgw/vfuVwptC0o/RMcS9AOJR1dxdcOASaGQImncGd2A7mUnHIMS8pHoQ0fev5SKjTZgYOrIDyXlhT4+/yB/KF4S33DCPfVd1SCseXo+byv0n5jbuWnZ0oJFRFaDIYSw3GQM82vgqEx/+HoRzOtKMdgCtjD6zJfvB0sFI7In0TmeAsVEPUpZVy3YVaDiCgKaHgfB5GTOCVmto81u+gXp5mehpgEQz/JieGt+hSS4LvoXl7YF76dI3Xbdk+cUcoQTxh7oP6WJ43m3ivDNFMyaiAy9iVKJiOLyiK4KBPWXQSgYuX/uAYuTsqpdRWemACO/yIRUGfYhL+1+pqzlguv1O/vxnW2TMyG0xtFxb20PtpdW1hfjTNXfga++plFBZp1NaV3pdwKDIDkQ1w6vjHT4st6sN5iNHd1h8kmPRhbue+lF1Q51P8f5I4pQBIa7ng7q0lpuLUROK7j7n9AOODYftj
 gogr/huA
 qkjRoiw7Rt5j5e6r65rrodP32RBPs/ylFbmZDm58f8gHXj8Lieybo68b/eJuSzgt2XORZHaLHUyZyDFb0s1vSqjRGEEaKpWmehX2p6Br6sX1hj/e9jMF5PMkQHyxMj1Tx1OORwjlUfG7V09TtN9QelMfwGMVJRJjQ3m0s6Z1hp0k8e7qtLLCHRNQh0Gw6Ju+fVpPtZy/6oTQGdXMaob2fOfJrGXmhdjSeKGII3/71tfQ8GTLydQnjtjjahIHe/fPZsEONazC9DQY4oFXB6Nv4qlEAvNbo88lptIvX
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
extends damon_probe_hits_wsum() to do the calculation based on moving
sum.  Patch 3 implements the filter type in the core layer.  Patch 4
refactors DAMON sysfs interface internal data structure for efficient
reuse of data structure for the probe hits weighted sum range user
inputs.  Patch 5 updates DAMON sysfs interface to support the new filter
type.  Patches 6 and 7 update design and usage documents for the new
filter type, respectively.

Changelog
=========

Changes from RFC v2.2
- RFC v2.2: https://lore.kernel.org/20260911011330.93678-1-sj@kernel.org
- Drop RFC tag again.
- Rebase to latest mm-new.
Changes from v1
- v1: https://lore.kernel.org/20260910141849.170896-1-sj@kernel.org
- Validate {min,max}_range sysfs input on local variables.
- Add RFC tag again.
Changes from RFC v2.1
- RFC v2.1: https://lore.kernel.org/20260910040319.147037-1-sj@kernel.org
- Update kernel-doc to clarify probe_hits_wsum is a damos core filter.
- Drop RFC tag.
Changes from RFC v2
- RFC v2: https://lore.kernel.org/20260907171218.101430-1-sj@kernel.org
- Rebase to latest mm-new.
Changes from RFC
- RFC: https://lore.kernel.org/20260906210513.106895-1-sj@kernel.org
- Fix kernel-doc typo.
- Use moving sum based weighted sum.
- Fix wrong range saving field names in sysfs.

SJ Park (7):
  mm/damon/api: introduce DAMOS_FILTER_TYPE_PROBE_HITS_WSUM
  mm/damon/core: extend probe_hits_wsum() for moving sum based
    calculation
  mm/damon/core: support probe_hits_wsum damos core filter
  mm/damon/sysfs-schemes: rename sysfs_filter->sz_range to
    range_{min,max}
  mm/damon/sysfs-schemes: support probe_hits_wsum damos core filter
  Docs/mm/damon/design: update for probe_hits_wsum DAMOS core filter
  Docs/admin-guide/mm/damon/usage: update for probe_hits_wsum DAMOS
    filter

 Documentation/admin-guide/mm/damon/usage.rst |  4 +++
 Documentation/mm/damon/design.rst            |  3 ++
 include/linux/damon.h                        | 22 ++++++++++-----
 mm/damon/core.c                              | 20 ++++++++++++--
 mm/damon/paddr.c                             |  2 +-
 mm/damon/sysfs-schemes.c                     | 29 ++++++++++++++------
 mm/damon/vaddr.c                             |  2 +-
 7 files changed, 62 insertions(+), 20 deletions(-)


base-commit: e81bad1a9d225410ad05860d729169baadb2543a
-- 
2.47.3

