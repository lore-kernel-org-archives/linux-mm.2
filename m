Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28E26CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 17:36:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 289E06B0005; Thu, 14 May 2026 13:36:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 262646B0088; Thu, 14 May 2026 13:36:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 177756B008A; Thu, 14 May 2026 13:36:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0874B6B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 13:36:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB8991402DD
	for <linux-mm@kvack.org>; Thu, 14 May 2026 17:36:54 +0000 (UTC)
X-FDA: 84766730748.06.1E747C0
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9135B18000A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 17:36:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b="O+9A/8aK";
	spf=pass (imf24.hostedemail.com: domain of cascardo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=cascardo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778780213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GwwUeKFsKyVyc2+pTaKswdPzG1/YgpdUqtqHsE9uC3c=;
	b=Ydiq2lN5SQTgRg031EtRAwivhhysSMLRX8ulTMK2sBSZ6SlyRhvAoVKDTY/ItYqLbpf0st
	xYGGh3M1wME6zvxgN2EPPcgQpaPZHYf22R9f3McF4BQBWzvR+BlGbul1IPXjE2spg0ymsd
	WZBv51g3L+Vk7hTD7+HQ0gwBSXCrBpA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b="O+9A/8aK";
	spf=pass (imf24.hostedemail.com: domain of cascardo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=cascardo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778780213; a=rsa-sha256;
	cv=none;
	b=ievl8830tVFstakJD20827zcNUbY2/DeMoVlcSoLC7OM+e2mw9ADWGGXJrepij1xE+aCPw
	DDyd1SRx8JfoLno2B62B7YrLINFWYzx5HhHduZdnIhTwV6wC7uhUioNVTZB9qEF0L1p9SR
	aHoDPyVXiF2mQe9d3fS3PzTHcntQOcw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:Message-Id:Content-Transfer-Encoding:Content-Type:
	MIME-Version:Subject:Date:From:Sender:Reply-To:Content-ID:Content-Description
	:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GwwUeKFsKyVyc2+pTaKswdPzG1/YgpdUqtqHsE9uC3c=; b=O+9A/8aKWex7YSsZulUvCRbT22
	LS39rgmpP6xjmZFVNSpkoI67QDvh3fbOJvgPayTkCWw4Rn0Na3KxjTkUHhGZVFZUIOn6MzsutEncE
	33O19MnrHYpx3Yt3NhNYfz/KFLz3k3iGqycn2laA6IryKLQuX+gX6RbuosFqCnXFxv9S95+U4q+K6
	wgb5OguCJO6p55H62aR/LmtJbiJjCVVKRa1tFq31rv3Z0Xa0PVPZpFF4PBjqRJQKs2fg3GZ8VwkvI
	1gFMAIHQVUyMe7l+/NHpi5c4xogIy1NDC+zPejjuTuP+NhD8tEk4ft1FY7g5WJn9gWPNCO+31zjnf
	x9aARObA==;
Received: from 179-125-79-241-dinamico.pombonet.net.br ([179.125.79.241] helo=[127.0.0.1])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wNZz8-000Aig-0e; Thu, 14 May 2026 19:36:34 +0200
From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Date: Thu, 14 May 2026 14:36:08 -0300
Subject: [PATCH v3] cgroup/dmem: introduce a peak file
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260514-dmem_peak-v3-1-b64ce5d3ac38@igalia.com>
X-B4-Tracking: v=1; b=H4sIAAgIBmoC/1WMyw6CMBBFf8V0bc20BaSu/A9jTB8jTJRHWtNoC
 P9uwQ0uz809Z2IRA2Fkp93EAiaKNPQZ1H7HXGv6Bjn5zEyCrKAAzX2H3W1E8+DKWCcs6hKOkuX
 /GPBO77V1uWZuKb6G8FnTSSzrr1JCtakkwYHXvgaFVhWFdmdqzJPMwQ0dWzJJblShtqrkgnvjo
 NJae6vxT53n+QtDElqX3gAAAA==
X-Change-ID: 20260409-dmem_peak-3abc1be95072
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
 Natalie Vock <natalie.vock@gmx.de>, 
 Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-doc@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, kernel-dev@igalia.com, 
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
X-Mailer: b4 0.16-dev-62088
X-Stat-Signature: dejszitcn38edrj1kmqaftdqfefq5d7d
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9135B18000A
X-Rspam-User: 
X-HE-Tag: 1778780211-336520
X-HE-Meta: U2FsdGVkX1+MN9SRGb2u62kLpmc81C4bFB5COdbgtPm6iquOjlPp1g/mFnQfpPt3ziFlWCfToys/gP7EAZ1WGQ32ES464yCaNDaGcQTu7Pz54lo//demO7Y/cMxRFVi4rRP6rUtnN7F8WvOIqtV/qJAtic5M1Dybsv6nLtv4YeZ2HvWF2fDCFTYMLbq0euNFx48OTMx1IdV68P+hvzJ/DVp2WBcQymsIvId5lfPtGCsIDEd00cwapOWs1ayTs2miOXa7wwFyG2GwbDh1hOULYwo6dxd0LvBNst3VasVO+9Qxrr3VIj5uRJT72BN+zCuGMtLKPqF+PlaWX9dE+JuqBZCly4JwV+6Vs5gxfEoWduWfBUyuBnxuPATFk7FhDYx/bV7ix+d/itF0gvSQsh7piQuRdYI6qOE+CXJ7qPiZfXai+TKWfGpGCr/jF7MUXWz8Zc8Ig0NEknAmp2TaVs/k4YPQWYjs1+eKUFVA1Fgc6Pjg/laSukv8CTnR2kXmQXT3tFVXLbWr+7wMIpFWGWORc949iWPy30sSD8vrmUC+55BHJyoowkWFcx/Fr7Ms0zKgY2m7RPGBkUex6EUIVbIiNSTg/tV1MRgQfukVXyuFaTiq8wcW/UK0OlfmSTsMuQ4yqRxECFGXJO7+OtuSjtX+FGUT8SoMs/3Da2X0bCbu/Iowbjn7e44CL4RYKmPwEoKtMGzBf53TVcawddLtvdK4XtX29qUWgfx8QmV80pf6U3xMtIbZTk7qmiNIJF9AFvfpzx+1O6u4hIAUyepeBpLdOapmHQ95rz6u3xitOhdCWyh1snqyxqAqNaDSKysdwOxojskscdEFQL6BVAdD2zjShj8jKNnUssYLUOIgoMgdXvTC1jFaC77p04ZKUg/rPpv3OvjSj0cbVYS9UzoNoBC8MhbiTeh29ivEsWnBMSHaC8GBWAZaPwl1bMBIxJ5iLu5dLqoCVC6y+2p1c7bqo8h
 c1tJMFZS
 2eXlizrb7byrEgYsLBSrQeX1ztaC70hm/R9tkdGnO1Xgws6m7L5SGa2MnXKU3Tjo2i2bzoYxUl0JtiXfB4/SgoYmFHWCIR4mu4jzsNHOslyLaaQOAn046FXBf7mIVyJ/GZIFhXguJyZ9ezyx7MepAliOEFPXNTEjUlLMFP5Na5uqRh21kDrjxsvOr6+jzaOm9So4FaT1ha2u4eak5301HLHUaG0f3z2Xe+slX7hz+3vzunIGaujCEjtG/jPZyRjjasKgTGI2L8lv8TzXXBU8OywT9LAi3zduoib1i/B65cHHoy84CY3lvCw4Sw5x21kHb2movGtoa80AJrtP/3yB7dZyfgaSX19ix5tl/5Pjt70cLhSo0vXv5q5qVOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Just like we have memory.peak, introduce a dmem.peak, which uses the
page_counter support for that.

For now, make it read-only.

This allows for memory usage monitoring without polling dmem.current when
the information needed is the maximum device memory used. That can be used
for capacity planning, such that dmem.max can be properly setup for a given
workload. It can also be used for debugging to determine whether a given
workload would have caused eviction or system memory use.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
---
Changes in v3:
- EDITME: describe what is new in this series revision.
- EDITME: use bulletpoints and terse descriptions.
- Link to v2: https://patch.msgid.link/20260513-dmem_peak-v2-1-dac06999db9e@igalia.com

Changes in v2:
- Make it read-only for now and adjust documentation accordingly.
- Link to v1: https://patch.msgid.link/20260506-dmem_peak-v1-0-8d803eb3449c@igalia.com
---
 Documentation/admin-guide/cgroup-v2.rst |  6 ++++++
 kernel/cgroup/dmem.c                    | 15 +++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 6efd0095ed99..d103623b2be4 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2808,6 +2808,12 @@ DMEM Interface Files
 	The semantics are the same as for the memory cgroup controller, and are
 	calculated in the same way.
 
+  dmem.peak
+	A read-only nested-keyed file that exists on non-root cgroups.
+
+	The max device memory usage recorded for the cgroup and its
+	descendants since the creation of the cgroup for each region.
+
   dmem.capacity
 	A read-only file that describes maximum region capacity.
 	It only exists on the root cgroup. Not all memory can be
diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
index 4753a67d0f0f..6430c7ce1e03 100644
--- a/kernel/cgroup/dmem.c
+++ b/kernel/cgroup/dmem.c
@@ -182,6 +182,11 @@ static u64 get_resource_current(struct dmem_cgroup_pool_state *pool)
 	return pool ? page_counter_read(&pool->cnt) : 0;
 }
 
+static u64 get_resource_peak(struct dmem_cgroup_pool_state *pool)
+{
+	return pool ? READ_ONCE(pool->cnt.watermark) : 0;
+}
+
 static void reset_all_resource_limits(struct dmem_cgroup_pool_state *rpool)
 {
 	set_resource_min(rpool, 0);
@@ -808,6 +813,11 @@ static int dmemcg_limit_show(struct seq_file *sf, void *v,
 	return 0;
 }
 
+static int dmem_cgroup_region_peak_show(struct seq_file *sf, void *v)
+{
+	return dmemcg_limit_show(sf, v, get_resource_peak);
+}
+
 static int dmem_cgroup_region_current_show(struct seq_file *sf, void *v)
 {
 	return dmemcg_limit_show(sf, v, get_resource_current);
@@ -856,6 +866,11 @@ static struct cftype files[] = {
 		.name = "current",
 		.seq_show = dmem_cgroup_region_current_show,
 	},
+	{
+		.name = "peak",
+		.seq_show = dmem_cgroup_region_peak_show,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
 	{
 		.name = "min",
 		.write = dmem_cgroup_region_min_write,

---
base-commit: d3b0a7f21119f5a66cb76aa28fb8cc13206aaf7d
change-id: 20260409-dmem_peak-3abc1be95072

Best regards,
--  
Thadeu Lima de Souza Cascardo <cascardo@igalia.com>


