Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5FACC531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 21:02:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18C2E6B0088; Sat, 25 Jul 2026 17:02:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A1056B008C; Sat, 25 Jul 2026 17:02:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED24A6B0092; Sat, 25 Jul 2026 17:02:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B505E6B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:02:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21146A13D0
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:37 +0000 (UTC)
X-FDA: 85028522754.30.E6DB33F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9F57040003
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F3yfrMYA;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785013355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LAM6Abu94jF1fie/uC+MUDrkB67RvOMdcnz1WP+Dz24=;
	b=Clex97j4QLCXoFWh8WkAaj75D+ghy2C4WTD7KGBLbUurYFnDh+QzSZyiyqJmc6NZ78RASf
	EE70Dj+2bXoM4EgKbbm+mdjkrBKmiaoyMLRpKdX5Hc8E5AlBQjSWTjQ5wGkMhAh6j1mfuP
	1Ef+1e4fGrlWqXIGvPIcmaL8QWncXgU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785013355;
	b=x7pUfzsC5FiZe0NENqnCyTTLCr+on0gbX09GBMKqrdqhe8Z29HCMmEQXsNfwZYI0V615rU
	FbJqguAoh5XE+o6/0Fu7Css7TnlqHA7nk7KKX5bYIsXJ0kURIweBwMJB9wYvreJbnYj39G
	dE1hb/3tBOOQ5s6M8Pd5oLMRrMJRifY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F3yfrMYA;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C4DE60A91;
	Sat, 25 Jul 2026 21:02:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A111F000E9;
	Sat, 25 Jul 2026 21:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785013354;
	bh=LAM6Abu94jF1fie/uC+MUDrkB67RvOMdcnz1WP+Dz24=;
	h=From:To:Cc:Subject:Date;
	b=F3yfrMYAMcesNgY7mhclt8oYvBnIALQgc9Uaj+QIiqtb4xavNYvUqyvzWeQPJMtgp
	 i+rB98S8vnDk7V2CSDovXsaqYSZqTZajgVO2y2pOcahrLiUR2Jvck7og1wEe+qYRBN
	 m3Ec3QJcf2lSnJmsWUDdm39c0eZhRKS67cs1nHrjGxFDubf+SVSVNzmHQOs3AEAvGd
	 9GUSBsP7BHYs1NSummgKqJUJzBWrSxwXDP/SLT4PGMpnlh9CKkHysvP8Nc63189nf3
	 BKKvStil7yUMlob+mUD2WKar7mnNUgKKd6odRxFRv8ZTFkacgOlNaUygxpRVXHTGlu
	 qdRk+W6942lCQ==
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
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 00/17] mm/damon: introduce data access-as-a-data attribute
Date: Sat, 25 Jul 2026 14:02:04 -0700
Message-ID: <20260725210225.129944-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9F57040003
X-Stat-Signature: ch91isyaz3kszc1p49oxooi1gr3xhepy
X-HE-Tag: 1785013355-964262
X-HE-Meta: U2FsdGVkX19tUUQvoHxXWFQJ3uBe/tfLo6IdInshvrbdpSkuEH0rUJSGB+qf0nbyVFiygK1I3iakHHRAJx0t5C53rh9KQXC/sQqkKftrSnU1uu0IF7WipGP+Zb/mkK82YYb/u+Htf6JI7XWXZKNsli+mNFbjuQr7kxrsQVloB11zuSI1yPht7H30bP+J4jwSvlKZYtSVH0HSrjIJVtm8YvewPBd6Ffny/cTzifSFgptLbEc6dCtGAiH4UZ23sHFjNv8/xiNjzkADbkrGfxWG17DbuaHLsCl2cUKC3d6Sj+TZsXDIAx3AC/IJTIZdqhy27LgGbobUgspPHA5KgbrnSplh0EFBlSuDzBYGygG/vEBW6vZdT/+PvOeW2c9XK9aRPv81UM2G8LQHCaHbThFbOatt2UEDfx1rv36HM5mjtlciDLSNg+BMlNAR5xUSc9/1+VTI9E9mJh8g+olB2G5lF1BAPQBdrnNl1hvZ+VI4fbzIQWW5/GsniNMsImEIB1zcfpIYCZWVf3yy9M4TkGuYXpK1PwKW5njblOzlUdn+xtzWrJmTH7FQWxTDL1pXwZmnpLUkjIpedItNyd6V7MKJKsEVhwwre9nhqpcMgpWV9MwoCk+Ldi+Gx915LRrSoL4lDiHFlc5l2/YnUdV+f+7L3w0Se0aM3zblrROV7KAL/n25xtXMNSy8K9NDdotbtMaGm2iLkwxlZYzoJ/IzRhi6eVmtysVBAAZtB3i+E5ao/DFIpmKIPJEDLU8wRFSEvVc+YHpeMEogHrDiwiaz/KKbf1oH4jEq1tEg6/19SEV/1w2A9ZvjcCp/PMG8iy0lUaJNbzCCDvXUDGCebWxU15cTsa41kJsuJWLa4vKGRhWQq+R/uvKpohweksIGFZsork5gfIv/hY4WxFK8LDxU7fV+D7rHaRVNhhDehfUZBrbAEII/RvPdIkPKdsZmfqFz82IchVRYnl6mpqKKufu03bc
 tfGL5suL
 EJRd0b7NWUY0/kqfrxe9rXJVTR1L8hGpO3vzPfFoY5IffrJb0VWMeyVnBnte+UPLb9v70E61FTbT05AD25XQ7OlTNLn4hwTw8MXu1zEmFna2SJJS26czIw0An9gXi31bGk5P80FLJpNedEe2WVCdFS2XIacsgr2OLZhxExhfXwgYCVbdIAjcHGW0OC4YcOKjVoFaRH+vZkioSpWQe6/FTcT8Kxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

TL;DR: extend DAMON's data attributes monitoring system to support page
table accessed bit and PG_idle based access monitoring.

DAMON was initially introduced as a data access monitor.  Users found
data access pattern becomes more useful when it is combined with other
data attributes such as belonging cgroups and backing page types.  For
such cases, DAMON has extended to support such data attributes
monitoring in addition to the original data access monitoring.  The
DAMON probes system was introduced for this purpose.  Users set probes
for filtering data attributes of their interest.  For use cases where
the primary interests are the attributes but the access pattern, probe
weights system has been introduced.  When it is used, DAMON applies its
adaptive regions adjustment based on the monitored data attributes.

However, DAMON stops access monitoring when the probe weights are used.
DAMON cannot optimally help users who have interests in both data
attributes and access patterns.  Data access can also be thought of as
another data attribute, though.  Extend the probe system to support data
access as a data attribute.

Introduce a new probe filter type, pgidle_unset.  It shows if the page
is not set as idle.  Specifically, it shows the page table accessed bit
and the PG_idle flag.  It can inform if the region is ever accessed. But
it cannot say when it is accessed.  To answer the second question,
introduce a new probe feature, prep actions.  Using the features, Users
can specify what preparation actions should be made to each region for
each probe.  DAMON executes the preparation actions for each sampling
interval, like it is doing the preparation for access check in the
access monitoring mode.  To help 'pgidle_unset' probe action use case,
'set_pgidle' preparation action is introduced together.  The action does
exactly what the access monitoring was doing: clearing the page table
accessed bits and setting the PG_idle flags.

Patches Sequence
================

First four patches (patches 1-4) introduce the new probe filter type for
knowing if a region is accessed.  Patch 1 defines the new type in the
core.  Patch 2 implements the execution of the new filter in the
physical address space DAMON operation set.  Patch 3 implements a user
interface on DAMON sysfs interface.  Patch 4 updates the documentation
for the new filter type.

Following 13 patches (patches 5-17) introduce the probe preparation
actions feature.  Patch 5 defines the data structure for specifying the
preparation actions.  Patch 6 completes setup of the API parameter for
the prep.  Patch 7 extends the DAMON operation set callback list to
connect the parameter with the underlying operation set.  Patch 8
implements the execution of the prep in the physical address space DAMON
operation set.

Following five patches (patches 9-13) extends DAMON sysfs interface for
the new prep feature.  Patch 14 adds simple selftest for basic file
operations of the new sysfs files.  Final three patches (patches 15-17)
respectively update design, usage and ABI documents for the new feature
and its interface.

SJ Park (17):
  mm/damon/core: introduce DAMON_FILTER_TYPE_PGIDLE_UNSET
  mm/damon/paddr: support PGIDLE_UNSET probe filter type
  mm/damon/sysfs: support pgidle_unset probe filter type
  Docs/mm/damon/design: document pgidle_unset probe filter type
  mm/damon/core: introduce damon_prep struct
  mm/damon/core: commit preps
  mm/damon/core: introduce damon_operations->prep_probes()
  mm/damon/paddr: support damon_prep
  mm/damon/sysfs: implement preps directory
  mm/damon/sysfs: create probe preps directory
  mm/damon/sysfs: implement probe prep directory
  mm/damon/sysfs: create probe prep files for preps/nr file write
  mm/damon/sysfs: pass preps to DAMON core
  selftests/damon/sysfs.sh: test probe prep sysfs files
  Docs/mm/damon/design: document probe preps
  Docs/admin-guide/mm/damon/usage: document probe preps sysfs files
  Docs/ABI/damon: document probe prep sysfs files

 .../ABI/testing/sysfs-kernel-mm-damon         |  13 +
 Documentation/admin-guide/mm/damon/usage.rst  |  18 +-
 Documentation/mm/damon/design.rst             |  17 +-
 include/linux/damon.h                         |  42 ++-
 mm/damon/core.c                               | 103 ++++++-
 mm/damon/paddr.c                              |  41 +++
 mm/damon/sysfs.c                              | 280 +++++++++++++++++-
 tools/testing/selftests/damon/sysfs.sh        |  27 ++
 8 files changed, 527 insertions(+), 14 deletions(-)


base-commit: 7c69a13f116ab63f525a2c4b0be7ce89f73befcd
-- 
2.47.3

