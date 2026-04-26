Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB7CBFF8862
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 20:53:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C54E6B00A3; Sun, 26 Apr 2026 16:52:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99E726B00A5; Sun, 26 Apr 2026 16:52:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 865F16B00A6; Sun, 26 Apr 2026 16:52:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6DEFC6B00A3
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 16:52:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 331098B8D0
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:44 +0000 (UTC)
X-FDA: 84701905848.28.EC20D82
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 722B140009
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wik89Mgn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777236762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8i8uGSMu53fmTfJkOXmpH4mTGNlu9DwHYub/xLuKQ7g=;
	b=bhzZkh112hlIeNCsDrC9HkqN2yiS1ZbOykNvWIHHtnDxdSh8Cmrx3rk7LtHZe93oCZVfPl
	teg/vNp4D7YP2NCYg8dg+c1SQATqI50h4gP4s7b+iBKDS7eMMgCw7E8PVLJtLF7WfUUghX
	GWRRwj5vIakXu/PzaMN8eqDzDKZojyw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777236762; a=rsa-sha256;
	cv=none;
	b=oMq4hMs4bS542KyIsHF//6Jbe8zfpwe53Cfl6XUgmmSXxCQlbBrrq0hjvuX5ABwQjeSPfT
	m2p4vsZ8lZ8wtt1C5T1p4dRU9d2TPIVyifitIhazY73UpueGaqLKLIJ6cwtRrtDGqm+YF9
	iDsSPAR6+vJnTYX5ozIctmUKNHQYBUQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wik89Mgn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3159444189;
	Sun, 26 Apr 2026 20:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8609FC2BCB6;
	Sun, 26 Apr 2026 20:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777236762;
	bh=jWZtEYC4wpgJ869rcJBTeYX65E0OwiGQ6QxZ8akF1Bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wik89Mgnzr4HtAStJRJvoasrrOnWhUE5QGd6dU6Xxi8DeHbnuTzMW8ljVuivcZ89w
	 PY7vZ8SEXqIwgbJE7wgwxeBfRI4yVyYCqYE2phydAfUfXpUykiihIt5fpXQ0RptNFp
	 FqVAi9KnoKTd0z7oAGpdeOa9LiAyrrXZI4kmUDrR8BPq7CXTrTN5msGUX7jPX+2R6z
	 t574ji7UaEa1EGRijZoxd5rbN+lyxQzgD/85Q7SYTgpME/Wv+go7g6IWVb6jAwuQOC
	 2gz3d8yID0Ml8SiBFwVIkcvnalDJtg8QE7ghiuv742aYgwV85wcL4vqxV9LCNXcqsz
	 t5dpBRMwjIwNQ==
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
Subject: [RFC PATCH 19/19] Docs/admin-guide/mm/damon/usage: document data attributes monitoring
Date: Sun, 26 Apr 2026 13:52:20 -0700
Message-ID: <20260426205222.93895-20-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426205222.93895-1-sj@kernel.org>
References: <20260426205222.93895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 722B140009
X-Stat-Signature: 9g9tjsdjegjmdichm8ndb7uwpfiko5ho
X-Rspam-User: 
X-HE-Tag: 1777236762-539800
X-HE-Meta: U2FsdGVkX1+HxDXG/+4s13rvt8g2U7VtWl2xFV62NqK0DkQmJoJABgZD1+kyqfPVsaG8PZf6bGXJXdYPEzuZkp7MiNvchYqResRgp1J4qrgDMz5TxSri6dmTdyjSRP5WNR5T5bQKCbG66HGNeWPYV5wBbHx6/eI7d5hTvlxMI59tBtObkVyEkMtmTQIQUYA4ug8Ph3YE/+Wky4h+mePLJh8/cLfzUZ00h3Z3QkZcy5vU6/yC62pDvLVqnajRsOS/268xbNMUUgS2s5ori54smeJTgtEqkKku2r4qZz4/Ki+o6mfayKCO/A9hYKMjNNhW5ctNKYIyOdB17E8qSJCybbCs8JAeklzlTW/+4KJc9BGcxTZoW9ql2Bm+djB252Bp8/2zkmlXm/Y0WXQ4q7iCu246envVSaV442AlWqv22VdbZhOsCva0HgBObRuNWaNGQmyM9MRk6EHOagYbuZOGV5HKw3B1cTDFO2gH4t214+kPu+Xs8CCA4Z7fQFz9+8udPOZaheZHjZfpz4tD3jeSAZiGmf2KhIhqydoIxTCxolR500AG9qcy3n82xjgpQ1B+sL+kuibYjXV1nQmG9p3RBLGSOCl0rc5hFzLXQqZHUx4JjPamsu6HLArCWOYhsv/qM5PmFb1lDvJQ1cC10Z7u8+TYqQCPTcDNuHAWR1AHdaQvJVhmZ7+GZDOve6k3HZRMtieL9/OAgI/Q0M+l1PvfTvtlUPkX3ooflieHv/8McJtDbBIXQabsBMIPlndkXEyIhWOEk3osLvLcbtNJZrPmbRAE70vQwp+85sJIB48U0l0+K0zvTxkZuZTONrnD/ltZBj3YdqLhUcMOxlAnLRJ2qUOyjTjUklpHaQQkPyckXzqhVKUZcea4YCQpDA7LuQoBZ2lW18zKXOGQ0zB0ag6L1fCoLGBB3gXIsJXxMeEfKAjtNsWuOAeiozVW9v3IsFUA06klfZuAnnqneZ1o7rw
 c9rowi4O
 /OUSKXXAYbYETL27rejsd5eTHrVjsNSg6ucuAJfqj+3NPVwAXWlShPT+OCtyY7CbGOxVfooCEIbfcJN0ahYFmx+LCon3WjPfEyAnLLcofQ6y24rjn9N9VWe6o1o991UgqyzfEN6xTstALhCttY7VPwIlBLJFPl0pQk4PcnHJMF2Irn5T8fiAL16OznsNPJYn3bSAwVDEuJvZGO8CLKMUEyw5/rMMiptNv+xCSe9ChpbTGKJjZWOLn9+QxAarmaXXUPW+DeS0p/8UMwiKAZOHOm97MPLhvBXEwlPXmJ2x5ZAt5eUyugzQ3BvT3bA==
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
 Documentation/admin-guide/mm/damon/usage.rst | 44 ++++++++++++++++----
 Documentation/mm/damon/design.rst            |  2 +
 2 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 11c75a598393c..397820ac8bbb0 100644
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
@@ -97,7 +102,8 @@ comma (",").
     │ │ │ │ │ │ │ │ 0/id,weight
     │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds,nr_snapshots,max_nr_snapshots
     │ │ │ │ │ │ │ :ref:`tried_regions <sysfs_schemes_tried_regions>`/total_bytes
-    │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age,sz_filter_passed
+    │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age,sz_filter_passed,
+    │ │ │ │ │ │ │ │     probe_hits
     │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ ...
     │ │ │ │ ...
@@ -227,8 +233,8 @@ contexts/<N>/monitoring_attrs/
 
 Files for specifying attributes of the monitoring including required quality
 and efficiency of the monitoring are in ``monitoring_attrs`` directory.
-Specifically, two directories, ``intervals`` and ``nr_regions`` exist in this
-directory.
+Specifically, two directories, ``intervals``, ``nr_regions`` and ``probes``
+exist in this directory.
 
 Under ``intervals`` directory, three files for DAMON's sampling interval
 (``sample_us``), aggregation interval (``aggr_us``), and update interval
@@ -262,6 +268,27 @@ tuning-applied current values of the two intervals can be read from the
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
@@ -614,10 +641,13 @@ set the ``access pattern`` as their interested pattern that they want to query.
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
index bada2010ad1ca..2b68a1880a4a1 100644
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

