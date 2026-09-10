Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE99CC88E40
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:22:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 626436B00AE; Thu, 10 Sep 2026 10:22:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 560BB6B00AF; Thu, 10 Sep 2026 10:22:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44F456B00B0; Thu, 10 Sep 2026 10:22:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 202956B00AE
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:22:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A04EC120518
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:22:44 +0000 (UTC)
X-FDA: 85198068648.20.D4DA1C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id EC14F4000A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:22:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YxvePAEX;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789050163;
	b=p8d6BZoGI0Uu7AmavnIQ6n/v9WxwxyPDpjyAlzyoKxqJgjy1APsoWHLFc7Qr1v/Mzh6mhL
	X0bilwU4X8iaYlyEup+9mhajrLrrysd0CkFgCUNa+68P/e8QakXAIHHbsmlVCq8mCeacvO
	ME60NEmsATIBtH5eu3DvGLnu1U13vLk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YxvePAEX;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789050163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wPCZ7WqgRzvETLWg2a26RvqiL8k5Df3lkcW+Fvmq+Qg=;
	b=IIoScRx8S9Uv7KWwqt6x91vWhwaOdfzEevstwgazN4IAdQAiRqBOEU/CZwSD8zN/zJX9Tq
	kOCejQ9w9RQozcpM5FjAL4fm4wfHO8DwuNWzThoQMwT2HrpLQrL3lEEzpaeJ1vy0xhLRKc
	uksTQlSq63vNe0Yz7PO/xWH8STN3qpw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B218403D9;
	Thu, 10 Sep 2026 14:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EEB1F000FF;
	Thu, 10 Sep 2026 14:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789050161;
	bh=wPCZ7WqgRzvETLWg2a26RvqiL8k5Df3lkcW+Fvmq+Qg=;
	h=From:To:Cc:Subject:Date;
	b=YxvePAEXrWXF6Rw1TL5OTHVTq1O5/0FetqS4vTfRh2HWWw82DPGEbBrpTdVfF7T4/
	 gf0eDrKaLbNDoJF2XCFghUWRwQl18qgKoiRTXft/jaIC2o3I+RCu101I0OcPOpHWYU
	 IW+Mc/l5NwiLiEC2clQg34xX/l1Ocy00wRcnO7riJYd/ssawrA7/BmcLNblMxQvYym
	 oo//zYHGcdx6UBqQn/EC3to2ZVN5TNvSu+e2yLZQVyVtZf+MDCQugpaOVkxPW8JSx8
	 2LRQ6LSDrEpyOQZSifbtnxgY42zGPk9IQlDO6/hA7S1c6/fkow/B0l2xXqpbJ+Ytri
	 g717Ko26Fv0rQ==
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
Subject: [PATCH 0/5] mm/damon: introduce pgidle_set probe filter type
Date: Thu, 10 Sep 2026 07:22:27 -0700
Message-ID: <20260910142234.171562-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EC14F4000A
X-Rspam-User: 
X-Stat-Signature: dnm1dxf4arnrwyiw4wa3ghz8ag5xedi3
X-HE-Tag: 1789050162-176842
X-HE-Meta: U2FsdGVkX19eGuqKLvh602U271NugvSGAEkZg7uLRLCPlsSQPZ79u0zaboq/nwv4JrFhdxakkBXK84CN6xYj6t/ZVpCBlm1vK8AAv63iMnMXRuuCrQQlV/TuUzB4srQ3C4VPizPI6L++A21n91sNtUtLj4/cNEv/aWKmD/6A2EbtZ7/qcPbyGSHHXgjzDsbjkhQgKS3ecmCx1Da3BL8Fg2ZMhGzipkhd7mQ6AOS9e6qMMGFpaYxO5c8SbYt8cckEjCGMsu5LKm7/0+vPiHJuyEqIjTY4F8nWhPuQxzN8MFLtk11sAbz9dj9RZQyukCb9AbAOv7Q0wPQ/qvs0ZyylfWPA9wHUBddddpUeinpezgjMN38Fbodk09X5LIbW4qXMSyrNMTt3VGxiNh1pRsMjjoORK5VaWv6hmVOVfFawaKKPGwHfi7zQrT7uGYmklaHALksQPlIN4GiFka0Y0BezpN+PABPbtRGgzPpS3AqzOpOFVwKikhxD1yuBhcoSnVCO5RaM3pg7QAXMySR/gd3KP+L4CZvBD6pgVDoeHESGhLnX2sTOKGDiK972sIH104ShNHgelkhRVcIsw0xEdqc64sUG6VSc1TNgAdg4h6X5PEV4K2aepCZwpcP0oxLg3wQzpJn+23S5mhW4J0dpbNHy34gOxdz/0OuiqOHS4b8XRtLJkFt3uG8Img42OoKs8NUJIAGOYBsp19QMUf5WokBkB3BPy0XS6+c4GvjF9DTTtndSz2/tbm/yEdC+xIxKsEnUbQdJtJ68I4hB74YHr3fSZQz37aXMhYvT0OvhQQKGMnf06K7kZFc7qjdrd7BvZrnyTtzsBydiqZRiA/LhHE2mgCGzqkFBolY0aX0pb23dpCt6Umd6snxB5OzcN+CfZmLIqaJRRANgBZPMAuaC5MslbnweMN2vKWWNMWfgIfbuZl+URwNI0ISWWBhjtSNjv/3+Ps7T0u8vP1oA2NOkrGE
 lx5amTV2
 nbPqbH+YMlZlXeWhi1XNKqkzcqm2bnyvDVN+gguVl4ERUEr00pyrMV+MQkda1gAqQySCbeav1UlTeayaohZog3B67IP1jLF+BTIERCVyK8APgKi24MzHhe+KGIX1zp4vYuunJa+Nw9vHE54j6N5uxcR6r4jvtX6hzSf+sf6KaLxDhxgbKImlLRgWYdO4paZpuWL3ztaIVPCZeq8K5r304CPE4VSUkdjp96oJjCVMTp1oODlY5A8ujg/39Y0Zatgi7g1XM3llxCnYdOl6jEsNYYKSBO1ii7vxHNlH2
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

Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260910040911.148273-1-sj@kernel.org
- Drop RFC tag.
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


base-commit: db0399c7f55d733a66e5661c4300276629123b0b
-- 
2.47.3

