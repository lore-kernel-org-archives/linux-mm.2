Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27722C9EC94
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:46:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78FB46B00AE; Mon, 12 Jan 2026 10:46:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 734016B00AF; Mon, 12 Jan 2026 10:46:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63BDB6B00B0; Mon, 12 Jan 2026 10:46:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4EEB36B00AE
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:46:49 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E73FC1A0560
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:46:48 +0000 (UTC)
X-FDA: 84323739696.13.25A0BF3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5CB664000F
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:46:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768232807; a=rsa-sha256;
	cv=none;
	b=OhoZjtNWwcswN/GSUbd/Xu0RdxGyAzEdCicJDq0UyQ1BBVMqLF09DZajmDYiX6Mtys/6rt
	ptBp2F02nAmIVmIKFEfLEBi0crScXNF35jcTt8oXCWjy2aIW0hitJd1tvmZ2PXe2HqOz6h
	+VM7QoAO782vZ+UerEbiXBwmNSi6JkU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of robin.murphy@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=robin.murphy@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768232807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=/2Fpx5sMln+4uvsY6IoIKQrv1w7KPnbD9F8QJS3ZSO8=;
	b=tQfbNREJ7PBMCo8BJNe5NvTFxORQGDYjTCL55v0jy/2Jhb9dKgbJ4VdLH5Je+Qh4ykdBHd
	Ou9rfOXE/lGCvXLGhv4ifOgXDEl/lGrPQIWYe4gbmIcbJtZa5aoVGt2nsUHN3OZrJxLy2u
	f9lZOXe0T/767xjk49AHkfnsPjGRo1U=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 73310497;
	Mon, 12 Jan 2026 07:46:39 -0800 (PST)
Received: from 010265703453.arm.com (unknown [10.57.48.115])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B7BFF3F694;
	Mon, 12 Jan 2026 07:46:43 -0800 (PST)
From: Robin Murphy <robin.murphy@arm.com>
To: m.szyprowski@samsung.com,
	akpm@linux-foundation.org,
	vbabka@suse.cz,
	david@kernel.org
Cc: bhe@redhat.com,
	iommu@lists.linux-foundation.org,
	linux-mm@kvack.org,
	vladimir.kondratiev@mobileye.com,
	s-adivi@ti.com,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com
Subject: [PATCH 0/3] dma-mapping: Improve atomic pool behaviour
Date: Mon, 12 Jan 2026 15:46:35 +0000
Message-Id: <cover.1768230104.git.robin.murphy@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5CB664000F
X-Stat-Signature: xzrc18tkamp53odmkahohu5m7gmg3boe
X-Rspam-User: 
X-HE-Tag: 1768232807-640323
X-HE-Meta: U2FsdGVkX18Jq8V7iQhnoVLsaOMr0gIvUOYnzDv7uGP/wwB13+McVTaTQHXYcaHrceOCG0GvR6XyVCHy8i3VSge3qIG8wC91SJIb/jWJ/ZmveGQFLCABDosRc+w3vStXp1enX55vfqQOgyD0MEy6MJIf91SiLpMeQtLXIL4Ds2ZcDfDKc8e6PoXAda9q0xAuTYJZ0OQoRjo1xvERnT35xXUclenxTK0ZmVNCO8pJ3NOML6PpMmuQT2q8eQCmegbZuDX4L2Fp514IDKZxSwqNsHA+cr6t5NSXKlasEcerVRZTtK23hNdqpWSHo/IV+TkLxcAeoXasLOSZBDGFJd7lUpcYPAZIm3mXu0sllavwUgKm9s8IMiEoUYJwH3Pfp8eYdZ+NAHrMtQq27krAWsJqik0KxFggWKCLssQbH3W0P1C8XIXttqHlLBPU/o3Sy2Ws3cT40fbChZBgr8D9TUoHCtPEgRarOz5l++LG5KFbjEAklg+qZwIkdxYKnGx2iHBsC5N9YlhgUvccqDjt5MqnEieBe4GlnFqB6p/qspgHUUUFnKNmdtB7zCKDkEsivY7ncsqvD8EXla1/j7Z0p4Lc8LkWZnD3h9vsXFww3CYqLvjqQnNz8WUGW+o3J1LZN92FYmBPnAQV8w1wlhT1rMB2suCYETIAO3mV7L/AekjfDSQSrh+h5qSrr96a9/dcYpRW6tCTpiNh1xkuSCqwzgzBfrgAf+/MtUizHR9iE0S51zKxTjN6JgTG93Nv5ZAuJMvpP2CwkG4SJTTVlzoP++N+iujiwAubKqvMpq1kPECyC32md5VVo/PeqCDvYzeZvcnWlgpDwfsZ0awlExVTI/AW8vo2GUQ7XO19pmWXmb+E0D/MmdDN3LdQIJ4vWiAz0ResxasIeG+arzIENSVKmI3iLD8h6pcr+0ij/vwDYn+gUFdAFMTJ+DL/QiBIKyrJagkv53Oeu45aDSSK235WtwD
 KRHY/kHR
 pFHuX50aa+Nsy7F2/Q19K3gK6WqpEnDl68kUi1r1O2qKo++yrVJBvO2dEAZBwEaidbIBD2IDAYGSw+fdtbRXocqNwtmWTcgWrsQnYVSNvqR6TiRV8ElemMicv0RlfZMcI6gN2UM2WQl4nZdmvW+5bZZ+FYOGv+9qaRjB9kVyFIV6dKVsl6e6/tUOEAszNRNAnb3BxRyzhzXrCdqI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

These days we have somewhat of a matrix of mm zones that may or may not
exist and may or may not be empty, which the per-zone atomic pool logic
doesn't actually handle all that well. It's not all that difficult to
improve robustness and reduce redundancy, so that's what this series
aims for.

I initially wrote this just because I happened to be looking through the
boot log of one of my boards and had one of those out-of-the-blue
realisations of "hang on, why *is* it allocating pools for zones it
doesn't even have memory in?", but coincidentally, it seems that others
happened to notice related aspects around the same time[1][2]. This is
my attempt to sort it all out properly.

I guess this could go via either the dma-mapping or mm tree, whichever
maintainers prefer.

Thanks,
Robin.


[1] https://lore.kernel.org/linux-iommu/20260112065857.3137331-1-vladimir.kondratiev@mobileye.com/
[2] https://lore.kernel.org/linux-iommu/20260112104749.4132641-1-s-adivi@ti.com/

Robin Murphy (3):
  dma/pool: Improve pool lookup
  mm_zone: Generalise has_managed_dma()
  dma/pool: Avoid allocating redundant pools

 include/linux/mmzone.h |  9 +++++----
 kernel/dma/pool.c      | 27 ++++++++++++++++++---------
 mm/page_alloc.c        |  8 ++------
 3 files changed, 25 insertions(+), 19 deletions(-)

-- 
2.34.1


