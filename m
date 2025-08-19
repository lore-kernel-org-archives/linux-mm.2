Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAEB9CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 11:49:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 440F88E002D; Tue, 19 Aug 2025 07:49:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 417F68E0042; Tue, 19 Aug 2025 07:49:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 354B88E002D; Tue, 19 Aug 2025 07:49:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1A63F8E0042
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:49:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9C2A883E2E
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:49:52 +0000 (UTC)
X-FDA: 83793337824.13.2546945
Received: from lankhorst.se (lankhorst.se [141.105.120.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id D0B2A4000E
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:49:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lankhorst.se;
	spf=pass (imf01.hostedemail.com: domain of mlankhorst@lankhorst.se designates 141.105.120.124 as permitted sender) smtp.mailfrom=mlankhorst@lankhorst.se
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755604191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=YbMYAnDDmkg6j9Dr2nXw2tLH/OWVGr8Za25pROmaIPU=;
	b=eGnYS98Ekas0hAPt3nrOkBlve+V1S56zBNL9ie1OxfgelCOngb660JAncvDpzXozQWj6G4
	xmSOSOvh9facrQSd908Fu0MmiGULyFLeZ0jtz2rGe3FWgrMfCYb34ei/bKuiPiJLpCGfHq
	drCoOVmK22HdZLGtKoYwt/GyTuZnMTg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lankhorst.se;
	spf=pass (imf01.hostedemail.com: domain of mlankhorst@lankhorst.se designates 141.105.120.124 as permitted sender) smtp.mailfrom=mlankhorst@lankhorst.se
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755604191; a=rsa-sha256;
	cv=none;
	b=EvqAVhqRyw1AxTYAe55jLSHNOR7To6ElObPUbwBfcrlIv1bT8e44AYkvLp88tIbQ67c690
	OfLR4rfz4VhMB5THVuSQXz2DYT8MFsEk/qb6BPpFjRHpTWOOJwDTUrH0q179/HBHrSVEQ3
	P+y8KovKRX6d8NZU09ri5x104FaCUJ4=
From: Maarten Lankhorst <dev@lankhorst.se>
To: Lucas De Marchi <lucas.demarchi@intel.com>,
	=?UTF-8?q?=27Thomas=20Hellstr=C3=B6m=27?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <natalie.vock@gmx.de>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?=27Michal=20Koutn=C3=BD=27?= <mkoutny@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"'Liam R . Howlett'" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Zimmermann <tzimmermann@suse.de>
Cc: Michal Hocko <mhocko@suse.com>,
	intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC 0/3] cgroups: Add support for pinned device memory
Date: Tue, 19 Aug 2025 13:49:33 +0200
Message-ID: <20250819114932.597600-5-dev@lankhorst.se>
X-Mailer: git-send-email 2.50.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: guxxrg9je8mad1uh1chcca5i3j95eqme
X-Rspam-User: 
X-Rspamd-Queue-Id: D0B2A4000E
X-Rspamd-Server: rspam01
X-HE-Tag: 1755604190-797392
X-HE-Meta: U2FsdGVkX1/4Gw6PJij7jwrLoVMKn5yV4UPWgKByymeGSNSFr//babqP75q6S6v0ANMPhE9jtAILH5hwGxBG7z9B0p015jKxs+kjpLwGevpdf6tMoV1EmjIcInN1S4rWoRQPJxSukMeF5KhgjQm7SLX4LOMAE/z4lX3dQJ9YDGAYSxXlAVNMGWohwmgvKBhvZwCBFgEY5nEYG+ytSBD5e0ZLMiHIONg0ionVIqaoP+UZorBYWHPE1NYTXw++XwnqoOCWdHr6t18p3r/Rx7SQC8uUzSMHGjclbZ/7SHYChHiKlZO6U6MumD51IyRHbxPNXnE1LoKRxTHZ/4eIew85BTbS9hqInu7xklyNsbtW1cmo39HVHIPdSV+ZyR7DOzZ2lDuow37WQp7ocJVHhVzxC80nwWs0Mppsu+T7NKBe9fvS0fTmjE9PpTk9K9LzreP8HgWK2KvcYprqY98uZ0HRqpZL41psR6BGU5qK6hN90Enh1IzfNcE7PlwmNS1oGXXqg/7QQaUW+ZQPDUBMvhLIxIUHXfLXNVWhQ67cCVbIWAODaFGZAf6rDBgMx+8Cu7OZomQt2PvxHeWpxf3A3TVQCk1HX0et6FAj2vEb1LnoNITX/KpF4IED9yZFHG5B2GZLiRF2I+/Hi8+5sSuSCJaY6wuDk+ZmxNjqH9Cug0KOgj9Ndkzos0CNeBow5LxTZAcwMaOP3MhTlg7+xteGC/wxzmsf/mEimlGC79vXPcSb3CZYpgEyhAOPSFw9dLCW/ySzkVtJHT3Rp5q7C3B11++JfZNvMQBDB68r8ShZWInsDCQD6Jn1dpNaecBEaiCyMy3aXKZQD8yBt1mk65HoFGEduUSZ/XiAH5h7Bg6BX2O7w5E2GUbut5VxHYTjLsl0uS1TZjJoovvep1XO5jxapRQIMrlUOwiY9DHuf+/9ToFMX3g7ZpKEWIKsHDky4PlOVQE66rgKTZtG/8pRamACjD0
 XFteL7Rx
 gFjsgy5MS1GnmzOBCQnYDKuU4EbfuWsUxK85EUkFcKo1V5WQww6VTPKHfvi8kBeIpsPODsSEsxZVlXJ/H8razPewAHtxmN70WlN+twVW7Xa+PaCWL2eFJZ6iNzBCQjV/4BU69QXCkkGCQCsyVx80Yn5Qpgg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When exporting dma-bufs to other devices, even when it is allowed to use
move_notify in some drivers, performance will degrade severely when
eviction happens.

A perticular example where this can happen is in a multi-card setup,
where PCI-E peer-to-peer is used to prevent using access to system memory.

If the buffer is evicted to system memory, not only the evicting GPU wher
the buffer resided is affected, but it will also stall the GPU that is
waiting on the buffer.

It also makes sense for long running jobs not to be preempted by having
its buffers evicted, so it will make sense to have the ability to pin
from system memory too.

This is dependant on patches by Dave Airlie, so it's not part of this
series yet. But I'm planning on extending pinning to the memory cgroup
controller in the future to handle this case.

Implementation details:

For each cgroup up until the root cgroup, the 'min' limit is checked
against currently effectively pinned value. If the value will go above
'min', the pinning attempt is rejected.

Pinned memory is handled slightly different and affects calculating
effective min/low values. Pinned memory is subtracted from both,
and needs to be added afterwards when calculating.

This is because increasing the amount of pinned memory, the amount of
free min/low memory decreases for all cgroups that are part of the
hierarchy.

Maarten Lankhorst (3):
  page_counter: Allow for pinning some amount of memory
  cgroup/dmem: Implement pinning device memory
  drm/xe: Add DRM_XE_GEM_CREATE_FLAG_PINNED flag and implementation

 drivers/gpu/drm/xe/xe_bo.c      | 66 +++++++++++++++++++++-
 drivers/gpu/drm/xe/xe_dma_buf.c | 10 +++-
 include/linux/cgroup_dmem.h     |  2 +
 include/linux/page_counter.h    |  8 +++
 include/uapi/drm/xe_drm.h       | 10 +++-
 kernel/cgroup/dmem.c            | 57 ++++++++++++++++++-
 mm/page_counter.c               | 98 ++++++++++++++++++++++++++++++---
 7 files changed, 237 insertions(+), 14 deletions(-)

-- 
2.50.0


