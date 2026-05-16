Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3AC3CD4F49
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:38:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D9966B00AA; Sat, 16 May 2026 14:37:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23AB66B00AD; Sat, 16 May 2026 14:37:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03B8C6B00AC; Sat, 16 May 2026 14:37:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E71166B00AA
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:37:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AF7871601FE
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:35 +0000 (UTC)
X-FDA: 84774141270.16.46C1C2E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id D71A380002
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U3NGrnmz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+vTKq5nmfvFvJeB5Nt/4xqWvQgpDB4Z9qf1uf8YQ/E8=;
	b=b9I0ev1orpI/J75drLgpNrKSIGFBamrWP3W6dCUihCotRHuhMYf4i9LYSB8E/0z/lYKwvR
	Kj0KqRgAlxQmqgVuqIWS1FGI14p8zwUqtRg960g13ouFRnFHQ6uTvTvLXnYRfIlUZRkz9l
	kCFM8/r7MnY37nUeRmyYVuvu4RfZqGU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956654; a=rsa-sha256;
	cv=none;
	b=tHu0m67dkuCTONVCWkup7iStiZVgCoH5oYGrmORIXgpw8pg4VxK5LO0mVMYg1cmtj0sGTw
	wWP6Fu2MlAfQCHESaW/oFEr68aErm40KdwGq7np9bmeLv9UXAN9EJYZ8CYooQnJV6ZXTyI
	POC0xT05+ozC3nkbAMvrClCv2lPIUko=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U3NGrnmz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 06A914454E;
	Sat, 16 May 2026 18:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC85C2BCF7;
	Sat, 16 May 2026 18:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956652;
	bh=jMwAnu4yT3RRMK4ipWWfT8kscfFZqP8KMamyoxvugWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3NGrnmzTBKZP3uPO5ftowoJ2YeL8zy04LqawTayW5hWW5YxiDbdxqND/k8dkap/N
	 y2ZVvxmupRBs74Bb7n4VpHOS5MPEtb0J/xW/ZaxW6oxsgifreh47SOcNaMM0V0HjYj
	 HjJMtZC7XoQ4URHYuTOwsTJWT7SOAJfF/oJHojwj2x56rh6YDoXHUhMaJsOPJA8yDP
	 6U9H7CSbFcrdVPKjchnvXuGw3dcZjUkRAwmdgsxTVZQoGPLc9TfM6uD/3tyAoN91Fj
	 862jeQ3szKe9LTTK8o2/V6zaLoZNiSIIwJxo1HTpJJlwqNAP6wVEPBsozmn7X+v4eY
	 Nq4NOrxL4bpkg==
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
Subject: [RFC PATCH v3 21/28] Docs/admin-guide/mm/damon/usage: document data attributes monitoring
Date: Sat, 16 May 2026 11:37:02 -0700
Message-ID: <20260516183712.81393-22-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: <20260516183712.81393-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D71A380002
X-Stat-Signature: hcbbrcz8bebguopoocaxd44w8gmrbii9
X-Rspam-User: 
X-HE-Tag: 1778956653-183041
X-HE-Meta: U2FsdGVkX1/DUkoQsBsmXT7R14/ZdWL99TQ8KCsb8Fl/jyt5n59e1gyB5Qf7WKgLiFA2m8IOLTzTCTefNXvuUxfDqtcdVtI7mVB5K5kebmj4uvxaT8KYsBcvQsU6C6gy+GoJBsHNVeOubus9huM4l6+Y8/i44pGHRrwVOB12ots5DyXHUwiDmaAE9d9ablfV2K1CPnWAR/Ohgv8uMmDhyL5lADV/WchuyTs8H/WYl1GxpV58uveep0kkTDwWTYRLWw6w3cWBwDmAkRDO5MMjxmcxZU5B63+asfvxndCaL5dASY+SISeJAHJcqR/zrQwp+uTAGrQQs3Gnt+6mWn0amjdOworsIJZcvXnDmf0x1UvOVAgQa/S1KmNtbVsn5/5TBQwY/XJdfOp+1/Qsy+46S7JA+LJMIBamY2LrMD+YDd0u6j3dvQ1nuuprg/AzlyGccVuErFij9TM05veo4IY9aI11E+HubKoEgDGd9e0Isn0JURSTI/uuAS8W/D8gFvO0BgD8Z66py1FRjr4DM5LB4WTNFGsFJ0dGNxdYYYqQz4Ps+wyiHG9Ov3mlWzTAp4u1BR8b9eYMVfp0y2fXLGR5nuG0YU7QBqeVuTU+M55YU+hGaiqO5gge7jVKklLNMZBPRIP+YmIGiak40a/KQwL7tTzOUKSSl7LB5PAg3lwhfqJIh1tgMBDPws72/iOwZHrgo+3bCoeKiGyE9RFAgHeEK8WSE2DJCbiL2xA/d0eQBTJKmbpImG/ymYEavD4CtUPo+5UjBrB1ajrZFMUicv9a/C2yjRwx2oJdkhE6LF0bxq34wbwxFGATDTpDEnLNg+qtxqnhA5ztdXOL9FETf4kG4O/SOU75l6byaiR2mA4PtAch7aGbTpnB4X0SrSbF/9XoPFEjUIsnB22FQ5BNXCDwvuyBvx6N56QC2MOTmAEwROIgEafmFw5kIAZfQvqwl7J9U2ePA+o/JsHeWG0X8Yu
 CFH5IQ6D
 mYAGjdP52zDSjcBJw1ZnFmUnRyzHFEQvbbeXM/5FYnnKyXE/x4UFe/60gz9/cH0PjB5ViFMA1vKGU/thU4VNe9blNFNlvH3xJrXahOoVPBYVrWeLjJYzcdP6ntTciVSaJUL49EFBjLPMns1ZYo1zJ8ndtg1tGoFnOqDleMPPmadcDz8N5uYS+LWagnrMGT3mJEHkumEotm6gVurSPYAajNphwzHOsPiK5Y9L31/kvbVK1+x0ep1pOcbh9keQKffpszw/4PuYeQvAJhM0SSUOOwoUSaDFW46rphstDTkhUbiHJyq9aQrCw2kyykA==
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
 Documentation/admin-guide/mm/damon/usage.rst | 44 ++++++++++++++++++--
 Documentation/mm/damon/design.rst            |  2 +
 2 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 534e1199cf091..7b6074a1666f3 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -71,6 +71,11 @@ comma (",").
     │ │ │ │ │ │ intervals/sample_us,aggr_us,update_us
     │ │ │ │ │ │ │ intervals_goal/access_bp,aggrs,min_sample_us,max_sample_us
     │ │ │ │ │ │ nr_regions/min,max
+    │ │ │ │ │ │ :ref:`probes <damon_usage_sysfs_probes>`/nr_probes
+    │ │ │ │ │ │ │ 0/filters/nr_filters
+    │ │ │ │ │ │ │ │ 0/type,matching,allow
+    │ │ │ │ │ │ │ │ ...
+    │ │ │ │ │ │ │ ...
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
     │ │ │ │ │ │ :ref:`0 <sysfs_target>`/pid_target,obsolete_target
     │ │ │ │ │ │ │ :ref:`regions <sysfs_regions>`/nr_regions
@@ -95,6 +100,9 @@ comma (",").
     │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds,nr_snapshots,max_nr_snapshots
     │ │ │ │ │ │ │ :ref:`tried_regions <sysfs_schemes_tried_regions>`/total_bytes
     │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age,sz_filter_passed
+    │ │ │ │ │ │ │ │ │ probes
+    │ │ │ │ │ │ │ │ │ │ 0/hits
+    │ │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ ...
     │ │ │ │ ...
@@ -221,8 +229,8 @@ contexts/<N>/monitoring_attrs/
 
 Files for specifying attributes of the monitoring including required quality
 and efficiency of the monitoring are in ``monitoring_attrs`` directory.
-Specifically, two directories, ``intervals`` and ``nr_regions`` exist in this
-directory.
+Specifically, three directories, ``intervals``, ``nr_regions`` and ``probes``
+exist in this directory.
 
 Under ``intervals`` directory, three files for DAMON's sampling interval
 (``sample_us``), aggregation interval (``aggr_us``), and update interval
@@ -256,6 +264,27 @@ tuning-applied current values of the two intervals can be read from the
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
+In each probe directory, one directory, ``filters`` exists.  The directory
+contains files for installing filters for the probe, that is used to determine
+the data attribute for the probe.
+
+In the beginning, ``filters`` directory has only one file, ``nr_filters``.
+Writing a number (``N``) to the file creates the number of child directories
+named ``0`` to ``N-1``.  Each directory represents each filter and works in a
+way similar to that for :ref:`DAMOS filter <sysfs_filters>`.
+
 .. _sysfs_targets:
 
 contexts/<N>/targets/
@@ -601,10 +630,19 @@ tried_regions/<N>/
 ------------------
 
 In each region directory, you will find five files (``start``, ``end``,
-``nr_accesses``, ``age``, and ``sz_filter_passed``).  Reading the files will
+``nr_accesses``, ``age`` and ``sz_filter_passed``).  Reading the files will
 show the properties of the region that corresponding DAMON-based operation
 scheme ``action`` has tried to be applied.
 
+tried_regions/<N>/probes/
+-------------------------
+
+In each region directory, one directory (``probes``) also exists.  In the
+directory, subdirectories named ``0`` to ``N-1`` exists.  ``N`` is the number
+of installed probes.  In each number-named directory, a file (``hits``) exist.
+Reading the file shows the number of data attributes monitoring probe-hit
+positive samples of the region.
+
 Example
 ~~~~~~~
 
diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index aa08c899a3e5b..85d668e929194 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -269,6 +269,8 @@ interval``, DAMON checks if the region's size and access frequency
 (``nr_accesses``) has significantly changed.  If so, the counter is reset to
 zero.  Otherwise, the counter is increased.
 
+.. _damon_design_data_attrs_monitoring:
+
 Data Attributes Monitoring
 ~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
2.47.3

