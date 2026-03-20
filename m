Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4303B1093178
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 05:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44D1F6B03DC; Fri, 20 Mar 2026 01:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FDF46B03DE; Fri, 20 Mar 2026 01:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 313E36B03E0; Fri, 20 Mar 2026 01:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 229796B03DC
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 01:24:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C56AE1DF9D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:24:38 +0000 (UTC)
X-FDA: 84565301436.27.578CC04
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1ACD220005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:24:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BDwYV8Wm;
	spf=pass (imf03.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773984277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dMXG2iiWDtSJZMsB11hiOBrR4Hw4ibVnoY6QikWleZY=;
	b=JkKnNDABDzWH3Uvhva5q5s8CWme6UL6Lu0FMkL67iKo6GOBCwM0nQUs56jXUeYf1Y6nS3k
	LfLiGmZSPHvTMb0X1LvkgzR91TCKKJAu0TMYDStsODMlabWU83lMU+poYk9ITjJIBl0n5A
	okC5FaTbo9GHYK6TSgVhC6ap05f69hk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BDwYV8Wm;
	spf=pass (imf03.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773984277; a=rsa-sha256;
	cv=none;
	b=FjegQiPkYAT7lk0b4iO+7zFu346u4vir5GtcSmPMeKqEgEgMz/TSHv+FW+f234SsPszaK2
	+6mN0kD/3QUi6pqFHlAyoQUoO7Rvj7V43jW4mvNEJPMcZKmppMx6Pcy/Pl7m/fbtiQ3uiw
	a16KE3p57C3YW1kulvI3Fe9BEi3moY8=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-35a04d6aeb0so217507a91.0
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773984276; x=1774589076; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dMXG2iiWDtSJZMsB11hiOBrR4Hw4ibVnoY6QikWleZY=;
        b=BDwYV8Wm21h2+ZriQjB6nEH60gwGAU5RiZ1+C+jpdJIdTUiHvngCTRLwgRjRjNzP4V
         m6uLBPAshR65NJUPI+Rug3KApGvelZvtHZ/l29ihRGQ5E/8lFKRlMI2TQ5uWwgithyMH
         UHdaAwGycUybQG0jGDi6dP7/TNpRDf+J3WXkf41R0VLY6v7BZaD1PPVmWSQPPnPvKnOz
         Ft9Tripijas204wuTeny51e5i/pl6NS6ufFU/A9frO1aQ83n/ZLE229Ed8g+fhd8wO3X
         BM8AnYIfz3ehMjQkB9OGAvQA0AOMyKWqfvFXL9ztoByy7GhZNXvYCNEOtcv0aRo/gmVD
         dnpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773984276; x=1774589076;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dMXG2iiWDtSJZMsB11hiOBrR4Hw4ibVnoY6QikWleZY=;
        b=eexxEOfF/50mgvLaY1QgXpXwr+72l43voLsp3Q952D3x8U4qe/rcyuMrf4Tu+wIWGM
         OUwf+FGWyGGveofCEWqd4r26RH8BXkLZGFuoqox4HWAhGMF/wKX5J3Lxg9Kqjw30ac1P
         N7BvrwHFqiWH3nroH2WlJ75OEY4N16gPie2YMm0vGdKcGE7fkpWpj2a7SQVHkriYtlKJ
         A3G4uUoGlW5rVZD2xH174kLc7AL+DbgwW7HVkjcG0SWzYLwFPVj3o2W5+d/E5umBQVzO
         y8IsGk1hX5xlyIqfEkk+MFCDpPM7N0L0VdseEFFDbUpexZxikwAwhnH6lo48r+CYMjNI
         u9UQ==
X-Gm-Message-State: AOJu0YwfcxpNS/Ib/Yd8VsF5+IzEUiLTJ7fB50PjMkJJ7TqO7bSt4spB
	NuHgrRTb36bussonT249uphhlo0fN0oBrLVvO8Yf1AtVSue3ME4WcgNj
X-Gm-Gg: ATEYQzwdvr/AdN0mWT0+jikIpdeQCAbUdadyndfzgJgKBzarEoRpttI0R9bFlc/gSCm
	GVT6+aVTtd/GRwETZKMDDnIzZn4gi8KJ/bgMefw0NSl54XdxTPhzrfcNK4Q99w7s/2yxNfpuujK
	VJJvvtnqiA1Ipf70nkx8m7UEBhsa7vGp18KVLal9CM40JZCY8fUPIu7OFxn8/0+jHmQ8+h7RLj/
	ozsBxjQSJSpQTrmhxOkr9w6YnWYOWb7S6RzVBt1BU9CaNqOzfUT2ZOGWgT89nW9ldVVvQT/xC6J
	M7Nk8G/xOnH+Odz1NTNCl8NLNzGsMlD1EmE+O2x7B2/istfAWR4JO1umUR6dYTzcxAOuD+YxkCv
	XEs39pn2/sZOoQ/R5ztfnLNBr20Nf3ImeY7LWGxSzxsriNLJ8J8X+B3i7F3WHW/YIjW8SBz9nlH
	0QCcLMxj8t24U25XipXxpcC32Q3mmcvLOdEcJJYfancbtknmIvcFE=
X-Received: by 2002:a17:903:191:b0:2ae:8272:deb0 with SMTP id d9443c01a7336-2b0826feb3dmr17511375ad.15.1773984275780;
        Thu, 19 Mar 2026 22:24:35 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b08352ae70sm10024185ad.23.2026.03.19.22.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 22:24:35 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: linux-mm@kvack.org,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH] Docs/mm/damon: document min_nr_regions constraint and rationale
Date: Fri, 20 Mar 2026 13:24:28 +0800
Message-ID: <20260320052428.213230-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1ACD220005
X-Stat-Signature: kystwjih59kdhofknqb7gg9jdkjo8owi
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773984276-780481
X-HE-Meta: U2FsdGVkX19EvM6GEJmArvSv1zNGCjaaHFEcGbJFdQjKyyjjYHAMu/FmTMCwLKR94Px4AQMMYFVNVRUh4lX7feGJX95NKPybeT1BuY8CROn4/OH45hPLlxW+rhafytNMifAIU1Wv+yFudvRII2bXvLLuPOvOfyn2hUyNltVWKGjiZxni8Y+1P2uODYhcNBqcDs3Q64t+CySJkDeMWXdwhRljxAWFVZpkz9mS/0iVryrhlZDuBWsfqsdlcmfNz8oGWLZt+UFaL+wSoVYyhajkHPzstYkBt13nnMbEgqRBy1iIWFGfe6GdvaM6z/JWlQGqd0VvR9ghbD5uk1KCjRDpEwadFctaYQ2ehvj1DbAO25dVGh3tKj/Qp4vxn+nN/FDVZA7d6Dr1QrTSBBmdDZ3qvnbcIEya0uZon86upM5tYzEH1io2dg9tLwLSQWr6h+phI39vslvTVoZ9gfOmrmA++GLtE9YFdFBPxf5w8J8iLGCkweycqVloiT9cFfxtB6up5/RhGDy6d1CxVflg0yhTCOI5dDbtZ9W6AobC0Y1fzAF3o1ffGOw9miaWcOyOTEzDiNevKXXjH/aBECRVBNaCJEapOzeIqfGeM9Gd0BIWNRoNu5K5M3Dx5OsQgsL58MmrjCteJ7bvPu9btZgAhanog638dlHuVYQHQXvUBrSgW46OZp5kURDoF90ZwCFXAe8sB32yp/CNeHn4WF54XwJwZvgyaysKK7tvIejcBCFXMU3jLUDDQxk2LvzN3tnrJdvgSQu1Rw7STyRN8JC+0uHeorUf7bogoFWz5UZWsCMGVWHCFo+ZXvII3q6GBbWXG5rDL4eo9EVLRZh+SQ5V0US84ZOa2jshAAcnjT1JEWGvRLkGZ1IanS61edak1JjwoIR48q66Sg5d9quA6NCdZi7fa64QQnwVU+QuwQA8Go0IZwxBOSF+7Eq4eTuyoGM5vwOYN5GlSMuNe1wsoUboQJk
 62N7L2GJ
 5V0Xstp9vmTYY+SzZGfPJJA8W9h0qhseXN4+K6Z5qy0sWMeWXriZ/T7OJsLHFIBa474+2S4YSIgW1PsVcnbGS8itsHJpbjw3eLsZ2eYZStJFOAJpHoh9VyezBDu+F/JubYo4T4oY3gtAZRHkUGQsIjsKFG5wUih9ZkH7Bu+3OjerxqLfI6+UF3iM+u3yqa79s2A9ouEy837WrspoWkQIGl9II1S5ZfJCg7DV+v3tlFFIA7uAo83m27b5LT/CcJMJm70BcALYTxqWO5oryPuOLjV13/JPKsceN7T7ft/RR5s1Mg/ihAWyZKJ7gtvJEGueNZHeMqx+dYn/uX8XjHzoGJOYmpTzsqYm0TKHBo19fiZVG7RvCgI/JeCvbC1Y6bzFBjA3MEbpnjSdkZCovbb0xw9JJr2G8UeoxOTMvVeZRQ34T5OeZYkDHwrTz3VeJgpi3ohzMGIfNyqwl2UiU/maNGowabx0b5cRjYBQmlyXLJXHrlIc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current DAMON implementation requires 'min_nr_regions' to be at
least 3. However, this constraint is not explicitly documented in the
admin-guide documents, nor is its design rationale explained in the
design document.

Add a section in design.rst to explain the rationale: the virtual
address space monitoring design needs to handle at least three regions
to accommodate two large unmapped areas. While this is specific to
'vaddr', DAMON currently enforces it across all operation sets for
consistency.

Also update reclaim.rst and lru_sort.rst by adding cross-references to
this constraint within their respective 'min_nr_regions' parameter
description sections, ensuring users are aware of the lower bound.

This change is motivated from a recent discussion [1].

[1] https://lore.kernel.org/damon/20260319151528.86490-1-sj@kernel.org/T/#t

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 Documentation/admin-guide/mm/damon/lru_sort.rst | 4 ++++
 Documentation/admin-guide/mm/damon/reclaim.rst  | 4 ++++
 Documentation/mm/damon/design.rst               | 7 +++++++
 3 files changed, 15 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
index 20a8378d5a94..3d08baf9802c 100644
--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -221,6 +221,10 @@ But, setting this too high could result in increased monitoring overhead.
 Please refer to the DAMON documentation (:doc:`usage`) for more detail.  10 by
 default.
 
+Note that this must be 3 or higher. Please refer to the :ref:`Monitoring
+<damon_design_monitoring>` section of the design document for the rationale
+behind this lower bound.
+
 max_nr_regions
 --------------
 
diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
index 8eba3da8dcee..153bf42645dd 100644
--- a/Documentation/admin-guide/mm/damon/reclaim.rst
+++ b/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -204,6 +204,10 @@ monitoring.  This can be used to set lower-bound of the monitoring quality.
 But, setting this too high could result in increased monitoring overhead.
 Please refer to the DAMON documentation (:doc:`usage`) for more detail.
 
+Note that this must be 3 or higher. Please refer to the :ref:`Monitoring
+<damon_design_monitoring>` section of the design document for the rationale
+behind this lower bound.
+
 max_nr_regions
 --------------
 
diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index dd64f5d7f319..68a25e07203c 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -165,6 +165,13 @@ monitoring attributes, ``sampling interval``, ``aggregation interval``,
 ``update interval``, ``minimum number of regions``, and ``maximum number of
 regions``.
 
+Note that ``minimum number of regions`` must be 3 or higher. This is because the
+virtual address space monitoring is designed to handle at least three regions to
+accommodate two large unmapped areas commonly found in normal virtual address
+spaces. While this restriction might not be strictly necessary for other
+operation sets like ``paddr``, it is currently enforced across all DAMON
+operations for consistency.
+
 To know how user-space can set the attributes via :ref:`DAMON sysfs interface
 <sysfs_interface>`, refer to :ref:`monitoring_attrs <sysfs_monitoring_attrs>`
 part of the documentation.
-- 
2.53.0


