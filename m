Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7893CD4F39
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:45:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E87C86B00A6; Thu, 14 May 2026 20:44:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5BC46B00A9; Thu, 14 May 2026 20:44:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D20946B00A6; Thu, 14 May 2026 20:44:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BA6E26B00A6
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:44:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8456D160D5A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:58 +0000 (UTC)
X-FDA: 84767809476.19.22A7D99
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 90ADD20007
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pfdVnQ/D";
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778805896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ueSGclicHTWQzo65W2HqgAgAG7lf87bis/qOCRwTUw4=;
	b=HLYdXQtsnhaPLvVFQkMgK+McSwclSHFOXkZhzvN6D3LP+bI+d6Zg3DaQqIxCjHGmd5OIB0
	KZQ5TMIrU9RA0tgYA0qiMqsM5GacjLpn4QI0evuqeFj1Yfm/zhA0YmNPYe4uCjsP24ipCW
	R6C9jDmEQGypyLDLhlGoQHZbPYjO74o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778805896; a=rsa-sha256;
	cv=none;
	b=NavmyFWryU/LhmcAGvbieu/7mqMCUE2KWK40Xkphb793tLNtvJsxwMV5F1YF1gWeKsvXVU
	1AIGu4KRCkZslD7284Tp1DC3N7S6TLh0+eBIy/PDMgHAwwQuWB9cT5v0opBiGxcPzb4I7B
	rQlVsIRU7F4Y/z2B6jNgb0yDe+IXyK0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pfdVnQ/D";
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F6B641830;
	Fri, 15 May 2026 00:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6DDC2BCC7;
	Fri, 15 May 2026 00:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805896;
	bh=tDul/IalxWnHQ0Ddp/WnfpzD8FisANNYVxxNG1upWBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pfdVnQ/DZlAwuHtdmFvz0ZaTBe8L6X+r92BtXxeeR5GRL3pjLZJV34yDp8B+97TU3
	 eoWv+zoOCcTe0lDZMTGdtJNzC1NGejzvKDznmGOhVEBhrGO8wK9x3Ez7NqevrUqq8F
	 pmGvIEoDGs143WIzK4SQLkpn6Ar2u+rX/ri4KlIvkQjYr8YCWndhSEQgPVWBQzTx4I
	 1GXv5fv02z/x0uiTOuAq9/o7dN2gMFQgU5D42FvCok4S6zA7ryJJr2B9mf+D1qEyZG
	 2qtQ09OqQAuy5n0gd8p4ZFVttoA7jvizLcpnDfkrtS7wem9cvbgJC03mWxBKa0+gqp
	 yux89H/ThgJDQ==
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
Subject: [RFC PATCH v2.2 21/28] Docs/admin-guide/mm/damon/usage: document data attributes monitoring
Date: Thu, 14 May 2026 17:44:22 -0700
Message-ID: <20260515004433.128933-22-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-1-sj@kernel.org>
References: <20260515004433.128933-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 90ADD20007
X-Stat-Signature: eniyrpcnoz13u8mk6zodi14qaw6nn9ig
X-Rspam-User: 
X-HE-Tag: 1778805896-730099
X-HE-Meta: U2FsdGVkX1+fKt6daWXos9/XVrQutoY+BvhjJh3YM9zQB/y1ecByYDWA99Tql9Z09EKbPYAAcb9Owa4SKnAgoo286cC/AT5ZTHEsqi4nxtlupyuFFPxYiWQqAZQ2q7V9ByS12Ebb+O7QI5D1zIK3xKIQQHFuvirn35xW54xzJEh3lLdez9ufVPhwzquDJ9xzqB6oUT6ZfNWtGKzLLm4IvFoXoM62v4izw5Gs+Frkkq2MS3XvPRt65DP2HfoNlJJKMVdwDk/WZ36I29Hcw0WVxwAdIx4j53blcY6Kz2N4x7xkXTDuZcuwYNu/nrnBu10cDBv44BT6diFQbij5wBzME2iwksKEaXZUJTDePhEK+83vHEK2x9bqGt+8hoS8B/8H3z/Z0PAOmNG4KWZ//0neLTcf5PHRboz8S5gmj/YbzTQADEln7Dbqlm4UwJBvqVzSMLKQqFazx/i9PJhLYhqWFcyAbW45x5MU9K0T3XJfUlx6HlywGLMHmM2x9z9z1bBjsB1AHM6qob9//ujTt8e5PXtqNqkoVHOrh9dcO1S5z+oONJtHANaH61U8MySNTankPwxpDsBfWg3ssMwnpxaHdZDU4HgJRXY2DJjY4oT2s+o6+iiA72ELz8W2tB3j2eZQwqa3GAAy72UC7yU58ujKEueMpcV0uSntRYjtJrDY/hw8R2/pY3g8S+SjtMD0Pl8NxGmv7uWqhvqD172syJ/TFxyJZmOkPW9g6y9M0Ve7N5UIJb5POGEtvl8mzOc2DWXQr6upgQNq85LA5SEuuoavTFM6xgLB/f/U6gXylBvNdQP86F+LgKFExShYjOY2tEjTsGDxCfpzS38nTttiPd3iJUVY0A+ov0PyiXNGtHAMAKm2TJ+BeuMJG/xenKHwU+vAhAY72ZoFiRMAQ8fYFvcMIMKL+j/tsQkC1WPVtcP7BhFLRCRV251jNY1hHeRyoeaeo6wczgl1Mo798BuzqIJ
 5QHAV/Yy
 pKE23YrKlaoY3pI6Bb2BE5845Vj2PPCO8Af763mo5LzhcxhZ066ttz86LVuoZV1wQ4ncm8mgKdTgpWlBSpUDldRibXrsHKegd1Ei5Z8OJICpBcXqrNqNz3EBg2pQtyzoOplHCZhFmrJ8JYbS2MtBTsPpPTjIkAmHmV/VaSM9yDJSplp1iUUhWilAbC0x+HFnzU8+Q4BZ0wlAHPegvOn+84yyNy6CK0f1C+zqS0n1+PiczHSZRM8GkfkRDUteyCb8y/PYjze1obPaxvyfBCAQnxzAvEqTKMwHoGr5qFFAq6gzum4gCSlb6j2bK/w==
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
index 534e1199cf091..44224da62533e 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -71,6 +71,11 @@ comma (",").
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
@@ -94,7 +99,10 @@ comma (",").
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
@@ -221,8 +229,8 @@ contexts/<N>/monitoring_attrs/
 
 Files for specifying attributes of the monitoring including required quality
 and efficiency of the monitoring are in ``monitoring_attrs`` directory.
-Specifically, two directories, ``intervals`` and ``nr_regions`` exist in this
-directory.
+Specifically, two directories, ``intervals``, ``nr_regions`` and ``probes``
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
@@ -600,10 +629,13 @@ set the ``access pattern`` as their interested pattern that they want to query.
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

