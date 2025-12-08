Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FFC1D3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C2ED6B0032; Mon,  8 Dec 2025 01:30:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24EA76B00A7; Mon,  8 Dec 2025 01:30:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0534B6B00A8; Mon,  8 Dec 2025 01:30:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E87F36B0032
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:30 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A67D38B14A
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:30 +0000 (UTC)
X-FDA: 84195329820.18.2DE9DB4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1597C20008
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q1Qe9zDT;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8mVD5cFgqTR23UaDf3tWgIQ6IeRyWnECAB44kHcv5+w=;
	b=EVmLQxuTUPKa0hFi0F+jItSFVdvqs3T4uokj/7MskbHSJHQ4fD70+CluRG0Ir2XUyL+OAl
	miSGWsK51IAMu1mfKykD7cEBHIxKHs61QZAZPEd8Pd0GCftoHKUOA3hs/3C7seRkmWbDfK
	sxval8DkhkpWpjjQUX//nsXp6Gs1V1Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175429; a=rsa-sha256;
	cv=none;
	b=Ad40qNeww/cM+JfQjVAvlyItVruI6yrP+6D6TlIvRdHTxfr7AeQB8AAoTJp9d2mRGaMCTu
	eXTmeHgddg4yINlWlJrJ5NhkWvsOz6n1YzGY72UKlPz61LRq1z2DP8yFXl5St1k9cS0Hde
	VgE0ax7XBZpjEGH55kCG1A6rAw6LgDE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q1Qe9zDT;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A03B16013F;
	Mon,  8 Dec 2025 06:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CA8C4CEF1;
	Mon,  8 Dec 2025 06:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175428;
	bh=MflKOa3kMKRZ5nzC/NEJe7cCxqAo99+D2pDObNtur7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q1Qe9zDTQODkH0a6LlN0LLWPF56eQxGRzEzYfMFdQWUh7byIaHBuE4XMnoV9G6fhB
	 +cME28lPAyXBwZhM6UAEy9chg2ADqQhP99ZJd8Sc6fRu+JXcwxMuTckTYvg5FLyWd+
	 TKnJDcfq9YyYXiHBWQLV8OldynKIBRUgSw9K3qS4gqksQKLkrLaB33oxuKcZ/GCpAs
	 NyAjkU5LejRDQlJvyIzJoIC/wp7yaH5ETycmwWyTKGm/z7W5BjBfyCg7kmNXxXEiqq
	 UQYeR029RoU2S9MXdtbV4X+g7EMdij9R0ZRE5ILqnE4hykX7RTMMIcOTPRSTn973ny
	 6UTvSMDPJgySQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 25/37] Docs/admin-guide/mm/damon/usage: document sample filters dir
Date: Sun,  7 Dec 2025 22:29:29 -0800
Message-ID: <20251208062943.68824-26-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1597C20008
X-Stat-Signature: x15howxsmwo8hp3k66c8j6pjpxwoqorf
X-Rspam-User: 
X-HE-Tag: 1765175428-107531
X-HE-Meta: U2FsdGVkX189dnOQzCYm1fykkaHeR526LUnqObyckNUjPPUZmQ+3xdMLXmUMWa7I0NMxBn61G9BAG0jb5y1xJVKdLBtGOp3fwTrPUM0Y7h0wGMCyIX8Tj2Jq0nFA610HtNHzZgFBfs4rhz6BYJ8hxFSFRPKpUcp9r0RvkuZmlBG3Ct/Ik9WLqa1sBqSHAWGH3TuuUJ6FefT+/h03cVEE2/Y+X3N+uZW2V0pxfUkHVFtkHwOGj06FeQjTe1XY6US4/55OP/ygKOx5ExtNnNNLamfrgIHivTnZRh/+g6JTbMSmMlN4si3ImUurHZaM3tW+jzoP4YfXfy9KUWBh8MuezntTenQ2a4mavHKZgBeiGC6BiDHFMybEMTRN+85N3OOWvHSz+6iOICj+a3lp43L2T9yQle8o3jxhZyFn3LzQi3ksfVPCio6i0iDj6vrD37aqUXhLg15s46pyopKzMHWJhep2mRVV3YnNHYj3v0ZfpEWpmmb4+f2zNbQ5TVUkDP8U4g6RP4tXwqU8EvT8NGJqhtMWKD7S+Dy3CGFcWXd+tDMmzgBYOZnKHBqvM5kCGKwTlmjz4l+CIwQJK3iMaaOJJkYN8xzxREyQ27vqo8oB17TS22XMC2plBHisxn95nGAWjqm9+L7wIEFLQhfkx5fzJhiev5SLw37COXnxpxgUFfF74JjpjydK/1IDw7mtWajIz3KHAfe9LCHRQUVea5ZPc/zeEx/B6QsLLS6gB+U4WEe56QKKgjcDhYwSSAJLSJ6FRp33lFHrjgOYJa5dINcmB/u4+BcaX2ll8sj7imlDYDg1DeUTh5F1zV6a/fXvZPKtYLRnjGipbk+BjS5YiThuy3YVAnZdd34INb+6XoopEr4qHPBk1DT15b82hmc/4p1mKVGtS5dMEIgwhXZpdmvBarFt4gDGVsciJe8TtqdMWaVDVwPPKKwN3Sc5xUNHdtQmXXY/mX5+wzgkZQsrD9H
 6R5XOyev
 ROWt0RRvzTMlegP81k5XPdFsM8bDju+lkyJV40AkSVcrzn4afgyA4olDE/FUW5bD+NlXVpFXrzRVo+hY2Pdbl9hxN5K4/vh6xMFxyiWql0oj57FLamg4OlKAYPRgWRxPof6ZFy2YVrfS4sXokGm8ECb9KdMxy5bG1AwHKdpQJatOy01cHSPflmU8Hj36NomyB7QaUupRMIkdsIsyYR+7bKJn8NBwS5Te8NRHv0Jdn0hx9mxHDA4WXJDN3ItpXsz7JkdN9JN4vXSzJWu23CHqqUVVKhlxoIH0I0s9xqJhchFzLlJ5FjQuSej0/kA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the added DAMON sysfs files for
installing and setting the access sample results filtering.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 25 +++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 897a89950351..365a4548a5ba 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -66,6 +66,8 @@ comma (",").
     │ │ │ │ │ │ intervals/sample_us,aggr_us,update_us
     │ │ │ │ │ │ │ intervals_goal/access_bp,aggrs,min_sample_us,max_sample_us
     │ │ │ │ │ │ sample/primitives/page_table,page_faults
+    │ │ │ │ │ │ sample/filters/nr_filters
+    │ │ │ │ │ │ │ 0/type,matching,allow,cpumask
     │ │ │ │ │ │ nr_regions/min,max
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
     │ │ │ │ │ │ :ref:`0 <sysfs_target>`/pid_target,obsolete_target
@@ -233,7 +235,8 @@ writing to and rading from the files.
 For more details about the intervals and monitoring regions range, please refer
 to the Design document (:doc:`/mm/damon/design`).
 
-Under ``sample`` directory, a directory, ``primitives`` exists.
+Under ``sample`` directory, two directories, ``primitives`` and ``filters``
+exist.
 
 contexts/<N>/monitoring_attrs/sample/primitives/
 ------------------------------------------------
@@ -245,6 +248,26 @@ to these files, users can select whether to use the :ref:`page table accessed
 bit <damon_design_pte_accessed_bit_access_check>` and :ref:`page fault events
 <damon_design_page_fault_access_check>`, respectively.
 
+contexts/<N>/monitoring_attrs/sample/filters/
+---------------------------------------------
+
+This directory is for control of the :ref:`access sampling results filters
+<damon_design_sampling_results_filters>`.  At the beginning, this directory has
+only one file, ``nr_filters``.  Writing a positive integer ``<n>`` to the file
+generates directories of the number, named ``0`` to ``<n - 1>``.  The generated
+directories represent the sampling result filters to install to the DAMON
+context, in the order of the directory names.  Writing ``0`` to ``nr_filters``
+removes the directories.
+
+Under the individual filter directory, five files, ``type``, ``matching``,
+``allow``, and ``cpumask`` exist.  The first three files are same to the
+properties of the filter specified on the :ref:`design doc
+<damon_design_sampling_results_filters>`.
+
+Users can specify the cpumask of the filter by writing it to ``cpumask``.  The
+format for ``cpumask`` input is same to that for other cpumask inputs like that
+for cgroup cpusets.
+
 .. _damon_usage_sysfs_monitoring_intervals_goal:
 
 contexts/<N>/monitoring_attrs/intervals/intervals_goal/
-- 
2.47.3

