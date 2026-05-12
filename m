Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83E82CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:37:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18E356B00AC; Tue, 12 May 2026 10:37:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F7DD6B00AD; Tue, 12 May 2026 10:37:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E65016B00AF; Tue, 12 May 2026 10:37:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C8CC16B00AC
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 96C941C0C7F
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:08 +0000 (UTC)
X-FDA: 84759020136.06.8389744
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id DA87740018
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uvQ+Js0D;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ng3Yto6s7Tx33dXSqC8A8r+4OBsbKwB93P8p0G2pGxo=;
	b=F+KtRLUcXZe+z9hwRS9XfFodxwjWQ5eVllTqKStcO1P07wXckv1hcU5ceHKDf9W1GCt9Dl
	ZVPID5ggMLXABRAwiiZ8ksvi5XqY29xLd9Bd0J3y/PylzX235bohItbvMFSyK3yX4TCyxT
	5iSl8eEcO0OnDu46Y0/5IRwswMcaReY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596626; a=rsa-sha256;
	cv=none;
	b=EXZxipipXJoEEJrl+1SG86PJiPPa/wPlFBrHwVASN0+Eaz2x26MjEPqV+nzLWlHTQc764N
	HeBBEk1YhAccsBi613ZlbLxU+OfFyAYO8CemQ4eqejci8GIkprsmQcQXfAdAmpCaeUVvIZ
	KCC4y4kUi0Mm4nROwOXPQkp17ztw+l8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uvQ+Js0D;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 657BD62D3F;
	Tue, 12 May 2026 14:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9430AC2BCB0;
	Tue, 12 May 2026 14:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596626;
	bh=XvoG0MYMyxeuNZgWYp28nddVB/e95qmsBgzm52k8D4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uvQ+Js0D85bE+lt2V4uOB5sDjKwYR5nMOlSMxaQ1KGtb78VRkW8glTEgyq9qCM+hB
	 XHWWumq9YCy+RTXl1e6JynKOIua2p/A4K2c2pDUgplMCulE99qKoNDxCoMU1lJJQ4b
	 L4/PwqxSvuM+rtRiVY/CDfdaQXPBU1cJgkqBkR+7Fz+bhMEZJUEh3hJvyoE7SEvbol
	 fQ9sHzO0E5IQ1dk6CNH92TOwlaTSS8BHJn5MCabPPDBDhd/gp88uSABZScqx0pA/tO
	 nRMsMFX1JWkZJZmy5bU3j2UeR4KpiKbesJB9Hkq8z6Sv0ShtfyKSJpP/qppSyBdYx9
	 qtH6o0E3l+yEw==
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
Subject: [RFC PATCH v2 21/28] Docs/admin-guide/mm/damon/usage: document data attributes monitoring
Date: Tue, 12 May 2026 07:36:36 -0700
Message-ID: <20260512143645.113201-22-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512143645.113201-1-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DA87740018
X-Stat-Signature: emw9t5wb599n5gbc7sdg1ejsffrxke6w
X-Rspam-User: 
X-HE-Tag: 1778596626-203537
X-HE-Meta: U2FsdGVkX19bHNFtxFCBuvDcAvQRyAqNGoZGfKIbvC+FSjhqpbZ9x6mNId4AT8mtOwKTp9vPfIktw3uRsDcdIUxZ1pueh5Rwc3YtIWKZagXC4a3PKxeV5pceTAkzAs6T8xRgzzHWM3EzUJptAvvlahnF8E+8Q6oCMCTv4bzRaKip03x4mgKOoB6cxwbp25R1Cah0Gq2G42ydkCtiBpGzIso+gnbTdr49iUzKrcyCNG7zr1OMmNW5ODGLBKEbi5lWMHZMNYhLCuzZeT3adMqXE53LYRq+RH6zSJlSHKBRahYtRiI+IntkD/hFnA7Ttz0cmNIwvfHz36lT8q+uoD5MDAshaImCtb1hEYLLnkXajhSB/Xkv0nADaawfqtXQSlRSfOzSKIkZEyVdGmwR2rZzeLz0/1EGOkVxFfw4XM927AtiOBue5IlkTPs95Eswp4zddIDwQ+4J4WK6nSiUx6LXeBZUMyrcLW2cTuU2QZw1mcJvIPP73O85mryBMZuJ0mpgOj/We4H0QTgSFCd0ieQuWfzunDkush18s/2JUUwaejhgIXwf0a6yhbY7U+FDJvo37zMTqBHWiGTNCUZZTdSm9ErJLqomie5ImXxrs0Vh2aJvTFSnIFSsQdf6MS3gL9Lu36C+Dcaq83PII0rEZZ/1HVCH2PkGkxDExEdOQd/4cprW7KE4bd5nRSgBFFS4MOq5P+VSTpb5JZNDjN5/C2/rk6R3ZKGjyeynA9x4y4m2XNicq9Kcl4k0pZSp78Y8GlfpNYl+ubIIUrlJZqXObADfXv+uEeCfXUv9qq4etCi9EEE4/SKY7VpS9oZI585Sx/tBe8pJhJD10Js0ebSrGPmBoktAegWqnP2mbTCuIviGIcs6TJf9XtgDLvNNG0nX5xVtCw81JN9EHMdFlfBBWM/3TztaGBO6ra7HFGhzozOG2BthMB22EDBy1UzaZqxfkDkUoRu5gfDlVO6mM9n6stF
 RQYfLeC9
 WwKDR7aIBEcTvd9ApTXugylUAy++Roun76B7lenzkCqK7H29Q6ijFq9FNM2XOrBPEE3TyYlDkm+bFn3PdFUdGpPqWTV3bPtunrDGbe0OzinfmE9igM8DnFpw3B3t99opoLyO/+W6nQPkbAzrx7icyNPF8+QT3OW3GfLGfwodKg0qhw0GpPz/bLvWLh/5mdu3Q2Cf8OpmL0UjK4MO8fbM1g9JPauEAlFiC/+bAt0532zWmOtgNngrRNprbxNpZxrIv9xXEnG7ZXM71D0VkXrufYQK4FAKY9UpQZvjHo1mcY+Z2rSw9E4r+A9v8kw==
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

