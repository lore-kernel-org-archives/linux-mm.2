Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 619B4CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:10:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19C916B00AB; Thu, 14 May 2026 10:09:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 014DE6B00AC; Thu, 14 May 2026 10:09:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFA5B6B00AD; Thu, 14 May 2026 10:09:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C11046B00AB
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 810BAC2114
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:28 +0000 (UTC)
X-FDA: 84766208016.01.4643660
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id B2A06120009
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Iu01nMOn;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ng3Yto6s7Tx33dXSqC8A8r+4OBsbKwB93P8p0G2pGxo=;
	b=H+7SaqaIXfg6qtYlCuwM0HfShnzZLycs50dh7QqGsdt1gl0XcQ5TpLaaqiPsizzn+yXCiy
	+DrMk+j1pa/cGmFeVsG3KVlkyjGKSGOVvsJlaVranEUciNupkn3nWE2M6TnhrTmP+JbNOF
	PEeyOtPZSYvflF94Dh3hco19Zz+AfVA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Iu01nMOn;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767766; a=rsa-sha256;
	cv=none;
	b=zPpHXAK6rBvEp+Alv1NqA/szLS9zcQApxQSoESruOcDWAEVMpoql6PMYgWBhiGLO1B20G1
	x+OvEXGoOiM+DH+D6L7S9TVp7phRGVjU+gTcUlZ/b4aY2LTIqHbXKGoxlmipL9OllMCEAm
	niLxaANyvFnR0kM22/4I9pwpSmeenT8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 662B34472B;
	Thu, 14 May 2026 14:09:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C33C2BD04;
	Thu, 14 May 2026 14:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767766;
	bh=XvoG0MYMyxeuNZgWYp28nddVB/e95qmsBgzm52k8D4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iu01nMOnmpfA5MmMgSvcn9aGsNoxY732dFaYOALOJgILxY9cR6Lx1UgBM9IseimKv
	 o3IOrgPMhWdalNFQsilhjPyytVb8/o/BUZgbcvMOTQYXZ0eDP9eVpAZxqAFaL8hegF
	 ait6tfT1WxwffU8P5kyVSKqleiQRUtBkU0WtM9kmPQ1XgrPuLh3OgFAgxJBsZyCzNH
	 AbPmKv9RSiflHisDqvQearGJBIlgfQhBkjarupw+Azy+UaZJ2/GlR4n0jFX/+R8wh1
	 8VzdPa+xXydRDVMkVM+NYgb0S+BxxcCSBZygtPmSFOxjvan9u9TPbSxF3dKyCm+AdA
	 EwebqLqWxkl4Q==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [RFC PATCH v2.1 21/28] Docs/admin-guide/mm/damon/usage: document data attributes monitoring
Date: Thu, 14 May 2026 07:08:54 -0700
Message-ID: <20260514140904.119781-22-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: <20260514140904.119781-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B2A06120009
X-Rspam-User: 
X-Stat-Signature: t81ojnuup1gw5wrb1ge5r34ty9ff1rf1
X-HE-Tag: 1778767766-419357
X-HE-Meta: U2FsdGVkX1+3A/1j6x+/MAzqRnqroAvclOke1jEG7KbTZGjyZO/DezrhXPbvTKSLaSoqjm/7URSswiqxO5wVZyRkQaX3ceaVX1uMitY1qzVp9GFydhHLZQIlDXzWMFMZqj8F8mHAbL7TpA+CfCHBjuJAZBh1KyBAk/Imzwwo8itCoAoMQgnXInf09mN/YyfLOwTeqQy+rWMJEgN8nLh5pTLRg8pFDAye/aMvMm66/G5CO4ZX/RxBotMGAKCmS+5ir4UHaotQ5/VcVRT5FbWF8MynjgGP1+BDnXanEierYCi6EHzx9Koe9yev4bA9vQaxZycEkRNKTwEbCJsImDHZkIJXWSas+JKk/KgAs1u4FO4i4RK0KlnaJTqIOJ46BkP/1yRBPfBESzxej4CMVx3tI8kQNz2ny+D6Uwi1u2bOpQdM4iPGdCR90oErqrNc+8BZi6OU0kzWjMxI6714gFRzT5s/81fbu64VEyCKGcfEXTG6rYE7ZEDyOR9e9uXyClaCnTDRsGIi5JxTicbSOr8zMBN8PJcvBA6Tk07EG2thdq1tLx9IZTK7ry1+TnA7FsZGaHTbW4iKVUX+59JpwScRtXaDG5uItyg7NcaRaFzoe448iQIam6vEGr4CT4/yOtpUw+rLATg+yzdMhjKL+0WeuBS9DNhmgTGRSb+kjKmLsoovvqoEJbMeQTtxl2X2w+VMQs4a3PYsUJe+cJBv/KNSw4kk0QbB6UZz2FuXkH0ZfC93vFMVG6RYr8IKfUrx4vMbQykeZsJ1n7zfg7YpFws2itIQR7ldjPoRvEUHeFTfL+MoyRYswA6B31Ps68wjnKTgi4V/LEIJIY2LbDX++UyLEx7KG+sWTSSkKsNfBK1RmV7iCfjvKaa4pf2koLMKf0spip2NAOgfi1x0h8fk61UR7liKnhX+D794IECIeNGfDdvqTL9d+A1cwaTejBxORpcOR0q13j60CeYh+Oso278
 ZO3dI9Po
 077/Y7rZf7N18e8Fsf3+H5/kJtp0DrpklOE+OJJ+Mt2tXJPiXIGO+Ra/ECPXnI0RP5INPBiIHUGAzf2Z29I1+luhUVDGrN1+CQZQ6Vdk+VhxSEFGm4o5S78kv1losn10Jc1gm7kk/TYMLuzOqLlRMKuVeLj+xK+/YEiS9dGlHxIim75B/t35jf1XQrC7Wp6jgv4NDbM4hY62mgHhrDA8go4mhIWwO13rJ0fdzMkhmgeKwecnfOKt+UbABDRWCkR8K+U19NxnasUu0v2kJD/XKt4KkL4C5KB5rJ+cLewYxWn/XNthjQlc5lT1EPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the newly added data attributes
monitoring feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 46 +++++++++++++++++---
 Documentation/mm/damon/design.rst            |  2 +
 2 files changed, 41 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 11c75a598393c..465bcdf89b182 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -72,6 +72,11 @@ comma (",").
     │ │ │ │ │ │ intervals/sample_us,aggr_us,update_us
     │ │ │ │ │ │ │ intervals_goal/access_bp,aggrs,min_sample_us,max_sample_us
     │ │ │ │ │ │ nr_regions/min,max
+    │ │ │ │ │ │ :ref:`probes <damon_usage_sysfs_probes>`/nr_probes
+    │ │ │ │ │ │ │ 0/filters/nr_filters
+    │ │ │ │ │ │ │ │ │ 0/type,matching,allow
+    │ │ │ │ │ │ │ │ │ ...
+    │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
     │ │ │ │ │ │ :ref:`0 <sysfs_target>`/pid_target,obsolete_target
     │ │ │ │ │ │ │ :ref:`regions <sysfs_regions>`/nr_regions
@@ -97,7 +102,10 @@ comma (",").
     │ │ │ │ │ │ │ │ 0/id,weight
     │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds,nr_snapshots,max_nr_snapshots
     │ │ │ │ │ │ │ :ref:`tried_regions <sysfs_schemes_tried_regions>`/total_bytes
-    │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age,sz_filter_passed
+    │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age,sz_filter_passed,
+    │ │ │ │ │ │ │ │ │ probes
+    │ │ │ │ │ │ │ │ │ │ 0/hits
+    │ │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ ...
     │ │ │ │ ...
@@ -227,8 +235,8 @@ contexts/<N>/monitoring_attrs/
 
 Files for specifying attributes of the monitoring including required quality
 and efficiency of the monitoring are in ``monitoring_attrs`` directory.
-Specifically, two directories, ``intervals`` and ``nr_regions`` exist in this
-directory.
+Specifically, two directories, ``intervals``, ``nr_regions`` and ``probes``
+exist in this directory.
 
 Under ``intervals`` directory, three files for DAMON's sampling interval
 (``sample_us``), aggregation interval (``aggr_us``), and update interval
@@ -262,6 +270,27 @@ tuning-applied current values of the two intervals can be read from the
 ``sample_us`` and ``aggr_us`` files after writing ``update_tuned_intervals`` to
 the ``state`` file.
 
+.. _damon_usage_sysfs_probes:
+
+contexts/<N>/monitoring_attrs/probes/
+-------------------------------------
+
+A directory for registering :ref:`data attributes monitoring
+<damon_design_data_attrs_monitoring>` probes.
+
+In the beginning, this directory has only one file, ``nr_probes``.  Writing a
+number (``N``) to the file creates the number of child directories named ``0``
+to ``N-1``.  Each directory represents each monitoring probe.
+
+In each probe directory, one directory, ``filters`` exist.  The directory
+contains files for installingt filters for the probe, that is used to determine
+the data attribute for the probe.
+
+In the beginning, ``filters`` directory has only one file, ``nr_filters``.
+Writing a number (``N``) to the file creates the number of child directories
+named ``0`` to ``N-1``.  Each directory represents each filter and work in a
+way similar to that for :ref:`DAMOS filter <sysfs_filters>`.
+
 .. _sysfs_targets:
 
 contexts/<N>/targets/
@@ -614,10 +643,13 @@ set the ``access pattern`` as their interested pattern that they want to query.
 tried_regions/<N>/
 ------------------
 
-In each region directory, you will find five files (``start``, ``end``,
-``nr_accesses``, ``age``, and ``sz_filter_passed``).  Reading the files will
-show the properties of the region that corresponding DAMON-based operation
-scheme ``action`` has tried to be applied.
+In each region directory, you will find six files (``start``, ``end``,
+``nr_accesses``, ``age``, ``sz_filter_passed`` and ``probe_hits``).  Reading
+the files will show the properties of the region that corresponding DAMON-based
+operation scheme ``action`` has tried to be applied.
+
+Reading ``probe_hists`` shows the number of data attributes monitoring
+probe-hit positive samples of the region.
 
 Example
 ~~~~~~~
diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 6731c3102d0ff..887b45cbeb716 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -276,6 +276,8 @@ interval``, DAMON checks if the region's size and access frequency
 (``nr_accesses``) has significantly changed.  If so, the counter is reset to
 zero.  Otherwise, the counter is increased.
 
+.. _damon_design_data_attrs_monitoring:
+
 Data Attributes Monitoring
 ~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
2.47.3

