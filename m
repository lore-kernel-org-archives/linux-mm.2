Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A94DF31E26
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 14:22:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC7E86B0093; Thu,  9 Apr 2026 10:22:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C52546B0096; Thu,  9 Apr 2026 10:22:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7C496B0098; Thu,  9 Apr 2026 10:22:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 883FA6B0096
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:22:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4E60113BA84
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:22:02 +0000 (UTC)
X-FDA: 84639231684.18.25F5E05
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id A19AF20014
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:22:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CkDeT/lm";
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775744520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uH80Rmw+ixDbvW3zicOB375OvkF2JK51os98lxA73xw=;
	b=ZCuJrSizF3ZN09P4lPARxCV66VMtm4WeGQ9pNtIt6P0TYgh4lxrTSYQ7pEzIlzTbLxTacC
	Ho2mwuen6INHFOw9l9UBIAbZeq10JKKcJ2+h1dNwBS9AzzlNl0jc/5wjpI0Tq9k3gS9zO9
	0bUCUCpKYSgqE03eAqGRQRAE3rmkP+E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CkDeT/lm";
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775744520; a=rsa-sha256;
	cv=none;
	b=4am8ZRvae+6CAE0qbvD0Ka/6K+79/0FDQyN6W9hn5GVXNrShk+PvsAXqyy0sjDGiT0KX4N
	RJt1nEvrgeqyqXIykYj+afvMnuKkDNkGZgh4gcJwwkG4SXcmuu1qnQAMFPVVOrOpxKR2Fm
	bVY2Z+pmrpofR2WtPvswJaUusrtaywQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BEB144455B;
	Thu,  9 Apr 2026 14:21:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18CFEC116C6;
	Thu,  9 Apr 2026 14:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775744519;
	bh=88ilcTiVHxOBPfSO6beti3cUyMc/KjPaTfyvCKtApUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CkDeT/lmDk6C/Sl+XwY4s0Pbx75AJHzSyiv62uorGOZwQhxrHXj3fyGZJ3zpnuUrP
	 sNArzdquT+YjNnnriUtVSrjbIkPxrVA3ea0VYeJGVmCd9rzrzA9Cvrr4Xvt8PhJBNM
	 MKR+rUxXJltnKqciSCdSKCRaXGcR2hJAWYw778XEP/jSIP+Eaf72IB7wpf2TzAPnoa
	 VIYefws8DpGNUQs4u8IWm68FnFnJ4j0xoXp3ruP1MoK3wyX+FJhIzxJ1t4lP2VMGqr
	 Hx+8aScbKI8cI2qhDJUFmhSpQSpFwHP88SjHP24EZvveE4orT2EbzIUhvYzXKNwjSg
	 YpNaUYx6nC/jw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 05/11] Docs/mm/damon/design: document fail_charge_{num,denom}
Date: Thu,  9 Apr 2026 07:21:40 -0700
Message-ID: <20260409142148.60652-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409142148.60652-1-sj@kernel.org>
References: <20260409142148.60652-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A19AF20014
X-Stat-Signature: zjinn55a1azrttzhj3kpon1c68ai1u7i
X-Rspamd-Server: rspam06
X-HE-Tag: 1775744520-23023
X-HE-Meta: U2FsdGVkX1/tJ9PHxlaXe70fWZrqULiEkyMYgiC9nkz9scLUvjdWJEwaJ19rnkui3GcROA41zjXvhlrizwpmJsGUEZjLsfwC0Ou4vBHjge9Yaj9xfN132aX3Xr+6WU3yNmx0vK8BbmZgFNOSDS9DqqzIHGvTf7uTV6CkDiRCbA0ZX4IIOB+Fd5mgl343eFeEW3akKq112Wyr1bMeDPxnTbeRCn1I5GMLYZrA74M0wZ3Ncj0avOlE+lvMHwGwoHSM0i2Kg9sSKID/Hd1smTLLdWJJJPQXvk6GpI9MsM0KlylMrBvYmo6jIbardvzu1fkHmgWNXSZfL3OTjz+AFsh8KohC1b7HLv2CT96D/3qFs41pxLoKnFtcimN5R8Rhqh5ve9bT08WFqaoUC5Tvs4KkEDduuLo7sGun9sBJBo413CWKG6B+PNOt/Kt5jPmJ7tSEddG86em6A+AOQh13DdNxk1N61yE6w5sskBS0S53FuESNX9D++WHrNFIKJ/0yQ+kBSCqQxrBO5CiZ200wHjZ4xwCv3UzqLSmGWG9hF7fRBqEl2AqIGIa6D3E731hYzoFVvNvXfhLl5TzGjU6Vvl+Kt+iHBXKJsA4SAn2N5cs5nBKm2ddKo203fNVgQtWZ9uuXAziMxIuKY7h0p/0PO6d/Sk9NSfviktP5+pChlpRXwxR5m5hRILinH6AYGRauHuY6GrIB4GKpLiq4rp1IT/K0OOPe+4yH62NNtOwwY5DRllRTkAJuj863fSbW9jAaqmMb7XDMywy8IVw5SFbexMQY5F/Wp7i/w6B6CqJ35bSHEmy4iewuwCFYCMEOnAhy2GP4pwCm0z4M1N+GN98hWfGkIaJ4/XuevLSOzZKJzVrOVXmfJwQQ4EhURMAasC4SEbuxd5QceSBZ1ASY7GdDUsieI4jRTOIjKw1egm7pZCvWciLOGPlFGKsC/XB5Wyx60w+3tbsCQYecLcbm2HMLTFU
 yNOvCOv+
 stKuKCRO72QsS+rKwsVPyFeptfW+RPbelkno6/WCcV/oFIYfkNQv8jtRMWGyPP97koeJ5LmckB0WQ61vPtI069zJE/QtFzmzUVvoLWLh0Xkj7mvIbGiJ/JlrVg84sGGIckSi/73KCqgbmgj0mu1tsV3k7fFs1Vhip+5zs3wOgxgfyB/RHr808UEjwEvA+oDPj95qRonQl8OxC5RYvlyaZat7MrOW55swZUnnkluduMN+U85qZ23Y6R8n7CFOxlDttSMVBbPnFAbHF+xyA2V0P19OGclmuL4DcKl8k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the DAMOS action failed region quota
charge ratio.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 510ec6375178d..94e898b671d15 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -572,6 +572,28 @@ interface <sysfs_interface>`, refer to :ref:`weights <sysfs_quotas>` part of
 the documentation.
 
 
+.. _damon_design_damos_quotas_failed_memory_charging_ratio:
+
+Action-failed Memory Charging Ratio
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+DAMOS action to a given region can fail for some subsets of the memory of the
+region.  For example, if the action is ``pageout`` and the region has some
+unreclaimable pages, applying the action to the pages will fail.  The amount of
+system resource that is taken for such failed action applications is usually
+different from that for successful action applications.  For such cases, users
+can set different charging ratio for such failed memory.  The ratio can be
+specified using ``fail_charge_num`` and ``fail_charge_denom`` parameters.  The
+two parameters represent the numerator and denominator of the ratio.  The
+feature is enabled only if ``fail_charge_denom`` is not zero.
+
+For example, let's suppose a DAMOS action is applied to a region of 1,000 MiB
+size.  The action is successfully applied to only 700 MiB of the region.
+``fail_charge_num`` and ``fail_charge_denom`` are set to ``1`` and ``1024``,
+respectively.  Then only 700 MiB and 300 KiB of size (``700 MiB + 300 MiB * 1 /
+1024``) will be charged.
+
+
 .. _damon_design_damos_quotas_auto_tuning:
 
 Aim-oriented Feedback-driven Auto-tuning
-- 
2.47.3

