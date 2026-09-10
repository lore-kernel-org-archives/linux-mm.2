Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A023EC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 04:03:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A3456B008A; Thu, 10 Sep 2026 00:03:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87A816B008C; Thu, 10 Sep 2026 00:03:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 798716B0093; Thu, 10 Sep 2026 00:03:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6048B6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 00:03:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6FF5B803C5
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:03:30 +0000 (UTC)
X-FDA: 85196508180.20.7A600EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id D70F41C0003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 04:03:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M1QIO72J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789013009;
	b=SDtZW+uOsdglnWy+fzf8ktICWnLtzjGaU4/EqplGi4wnk+ivs3hoJKdjvfvlRhilFsxFVw
	FdrRCjd14hGLN+jSm9vfovNomLsRoPvoLsKAJV/3xtGgvZsoaMHt3v34lWL3zpXb831Waz
	TccVgOtI/t5e7lxQind/oDkmBBzbNMY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M1QIO72J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789013009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Fn16+s8pwcYwe1UkQ7UDOCdjo2v9pEURHMCmkbI/wZ8=;
	b=PvPZyD+wfEWebe3jUQuPMbouESpWiSQxCzwLm/LTdQw3qY/gcZ9ug+zAhEwnDACNtRMKF6
	he7XF3/RoDgQSzza2+6s5x7Q2f3ZQjzsiwxNZkay8ZDOjcZgbF5A4h0nlPtZV8uSDeFRLi
	erWLXTuvHiMM5VEvO18auuaXt9IcoNI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A3F464095F;
	Thu, 10 Sep 2026 04:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040261F000FF;
	Thu, 10 Sep 2026 04:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789013007;
	bh=Fn16+s8pwcYwe1UkQ7UDOCdjo2v9pEURHMCmkbI/wZ8=;
	h=From:To:Cc:Subject:Date;
	b=M1QIO72JqahmYJFMMNlIMQFzyCFsdczpPacaK7qHuYZX4FGpU/oSyhQKjHP8Kxotx
	 hSPFeoxoZzdjbNdvp/UuyhRNCnLunbScnvmVbvlIUqErb4WsnrJ2vDpDZ/6EhiTIt6
	 r7Uk7sJ9lATr+kSB3vFANmxkRC8QamEwm6JnkUcBig26Cpvtag5k2zIf4S5E/GoFwV
	 a6nU/u0Lt6k379cF3yK7qYEZ7jdZ8TPezo+PVB6CrTnSXY5vOWMTPRAfE9eZnds+0p
	 PYJAMuxQ2sg3DKtmMi83PmfFoO24OCYgrj5OEI+1qcu+SIwBDTioJWI+MHDsMpvWmF
	 hbr+M5UkyE75w==
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
Subject: [RFC PATCH v2.1 0/7] mm/damon: introduce probe_hits_wsum DAMOS core filter
Date: Wed,  9 Sep 2026 21:03:11 -0700
Message-ID: <20260910040319.147037-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D70F41C0003
X-Stat-Signature: w8iqkniod57onqncpys9hbo9t43c5jse
X-HE-Tag: 1789013008-788519
X-HE-Meta: U2FsdGVkX1+FmL9Ze3Hw9rVfx28AAdCaeB56RgZLkcf3OzSvGBebLz6wAiTky1S7SLtJPXQYRN6+Z2OeMYYC2ds89s6U9j3rkbR1ORUbci15fOuSonBbB0FVHEqcl2ooaolnI6X/BA5VG0xIvcGAGDJjgOz78m8vEyoHrmDQq4EJyf1dmSb5anTOCTBwNo+iXtQ+27JAly/vfz7Zjf0zw4ma+mF3bnCP2hFRuPZcP0eF0iYkkP4kDT7bMuRcmmQjr+b/Mhucx48UPGcUSP76E8BSvazpN1VK+kXyqq9MFAr5VTPy4h+nRgjRgblzhqmltmMdSK74s/IjfA8+qldMXFxAVgi4HkdKfQEsow4cSKobPkU1JmNZ3/dRa6TwbZd9v8BK3QxPt+j/c8SHLXqLPUnb1AmChXLfvFzo5r2s3Fxh7SMcFyz82+SFEuKwNaxY+599mnUwHpiZpQzTTYPnHOfC+80XIp47re8/TtIe6lJH17SU61jtuxjH21Jz/rQ7TOUCYLB4K7c/c6vPGQ4UdU7VhSs9kaMGDvnc1Fmov3snL16wmLuCXA0PxAFEykboHvxCF5TEkkL9x8xayNI+vkWyStn4vT56X9iHBLaYDMq87X+F2YdYHIrVAiudUPuUaiH/5+KcPGvUO50IB6osgvPuMwpBDkfa8EcMNyiYINGxPRYlHwh+oLRknYZkOEfHj66cQmdWBZPAycQCgwiaK82SgnbMrf9Mx5JnnjmC+J/FqXVjmhcNrqS1WP44ddMy6eitH3nZO9O2ayuiFZi2mOexcHLfVkBHJK+HXMkeiP5h+l47iTDZgp+kmSdJAXKaJTHa8RhZTP4edEJoe61zOA1cfe3AW7klxDqz3bq/sn958dnsUHZAbauILLVzbXuGRlXfT2RkioOje8G/jRmy7wZ/70FI+fcylttaSrg0Chr1tmKANu+uPGKaQS732kcno8OFtIyR8NS+Z6mLr5p
 7J3zwKIs
 kPp11QPP5kZ7FKTn/LAfjUgiIB4NIlWi3+wT3kAQ9Ha5JezxDgpJaNhCuzTu09ylE9bwZYLz6IYW5V83rZCmuBHZ92tlv8TI+tDgzubee82jNwcU7t8y+JrIRFJ90JV5x+37t6fAvMv37ZnyqPD84fbuL3MGgd1Cfkf2LuR3lXq8sG3k+mZYw9JNfG30gYBdlUp5Y4dIpp/3VkTG7Ucn0/K5qMTYFvvwjAp9j9HpfOVBBaaE94FiOTxVxUmG8XpNg4l+6pu70FvWYWLAAgLemiZW+Y68yGzTITyH/
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
 include/linux/damon.h                        | 10 ++++++-
 mm/damon/core.c                              | 20 +++++++++++--
 mm/damon/paddr.c                             |  2 +-
 mm/damon/sysfs-schemes.c                     | 30 ++++++++++++++------
 mm/damon/vaddr.c                             |  2 +-
 7 files changed, 57 insertions(+), 14 deletions(-)


base-commit: 569e5184af6e299ec0e1f44cde89c2c2bb309a9e
-- 
2.47.3

