Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC011C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:48:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0371C6B00A7; Fri, 10 Jul 2026 09:47:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6B206B00AA; Fri, 10 Jul 2026 09:47:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D58CB6B00AC; Fri, 10 Jul 2026 09:47:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD4266B00A9
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:47:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 450A5140208
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:09 +0000 (UTC)
X-FDA: 84972993378.03.05FAF06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9784C40007
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cflqCq94;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783691227;
	b=C04rmkDUYIAtJWEZm12y5/OLOuSYCNeAYsRkWbJzQ31vQ/M3GDodTKv5YKXXZhrkjoxryr
	B0NQAt+WhfuYMj5qo6kHnnpTb13VmXJpaWHYyrhYsICrv2BdDD/DP1yIQH/tblY8grjzCR
	ijdLqg6O4qIx4F0c+JBgcr1/yxsxz5Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cflqCq94;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783691227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CCjb58wtAAk5F9PdDMQvKlFN0DE7q9fXquVywqvC5OU=;
	b=5zcdC+cxq1827MVCY54xaqiD4xNNJqZn6j1Ir8EfmKR2jqgdb+y9zI9Z1497BMY3AygxBX
	tpEE2J53JVJ5CSs08OK47rm7FdCYJ3T38VqcXL14tYm6iioDvrz6LbVnjz+aGRxXfE8Rtk
	9+x2r8H7XyHuG2qXd1Wg7ys51SeYiUs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DE7714089B;
	Fri, 10 Jul 2026 13:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0531F00A3F;
	Fri, 10 Jul 2026 13:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783691226;
	bh=CCjb58wtAAk5F9PdDMQvKlFN0DE7q9fXquVywqvC5OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cflqCq94qaeo+eBNls5BN6m/yVTI/o80F8xOUkfExOo+m8uis54QwrR2grtiXeEwd
	 bQkMxHjPyxu2LQlfoX639W285vYWS7JV+KtDryEpY4KKApRxLOP7d6S5Ugxo205hbK
	 rvWJ/KS6EAYeHUwJUdGB2HwFM4g5hxvP2oYyFtR/Z/tb+8HKy3kDzIzzKnD0wtMAv0
	 nfV7rOzvl77CXlrY5PGlRUFsRytVFe9OfIxMUXsnbuFxDXBokVZUhcmmP63U/UW6sj
	 L+e40vhh4RA3XghTUMPIa33nK079yzqxgm7W01igZngZQV6tJ2RC0HQyoOG+nLTVIk
	 uKgpiEaFLg51g==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
Subject: [PATCH 18/19] Docs/admin-guide/mm/damon/usage: document weight sysfs file
Date: Fri, 10 Jul 2026 06:46:47 -0700
Message-ID: <20260710134651.18084-19-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710134651.18084-1-sj@kernel.org>
References: <20260710134651.18084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9784C40007
X-Stat-Signature: egn3hb88irzgqjgfg6xo79d51a9tx6oe
X-HE-Tag: 1783691227-816405
X-HE-Meta: U2FsdGVkX1/UVqScvx+RLbpWIurfvjc6Gs1TIuC3lwaz4j+YxGNyYfxOgzqtBZUN4+EnGJai2Psg+fYdubCUl8BaIQtaJwKoJQv96M/xHt0vuebzWntMPUNVMVQwa3PS7ubQQfnrk2tbcekngUKtGhHQT38DleKqWkuneo+4O5o8gQkr8XnV1mMjC/R83PPG4fjEQp6vLOiwEqv/t3k8VlwIZkh7Hf2pEfOP61c//EMekT5vUwztptb++vIQ4dbuO9epIcqsclwDEBj1OVs3n5i8U90t6uKEeX3/uI6zWyER6WQhG9g9DOjfFDaj6gGcnaGfIeD5qXiQqgORC5+ZeCuTvbif3YU4odHdtC91BBoeof4P0kVfOKmfuKIGOtsJaN9BB2CUT/g3GkuTkGkOsN1sEigsIrH9UhE/bWEOVVeUWOEdZkTve8A3w6fRPgeodHvWmLsUfe8eHBOT2K7HpwPBxrJYVHha4Rz+oFpyI4L5+/UPLsK50+SFzcOwLCKCwxtVwcjRidQ9LnzYHzU+UubVRV/2R75kmNcl+sF8iFe+ApkOYvFlfGLu2MpQCOIfpXRSQ2aHNPgLHRWqZsoJdPr98+bUjXXICZRkxVObOeZGlpwhS6D6a3PgZiX7wJHtnzvd9UOTXoCLVXx959meOleWinn3VDt5g0KiBlWx4lzwGx2hGL773lKU509IAi++/d28Qsw9O+r6izo0j6f4IWAzNuvtzEqnS+xqKHS3Sk0rV0EDfSXFhjWHwquD9/bwHjVmO+MCrtfNqrZQ6pqXZpGGafUvO/FsoitD1Es5ySqCQc1Y6icY/19/H9vZ23ragpkkxr+8tTuTZf2R2nsNED+LGoPE89JLfUvJMGKuZldfvJ5dJc8PHoTINl2s6ZrZQ0on1z8oD37edKBnzTcKe3I85t42qwrUs6JUF0XSY3xeFL57tGz5ymABA75vu01Cz7ImOLdC8b3Ed7qSpHJ
 HTv0FrI9
 iBWXGFYP2x+e+beCkQfQxuVhhPSqfFTCiR+QMgzhgrthyCIRJG64I++UZFEnMyapi8L8Tan9QKvas8dw8ciO6xhq70pDH55h0Iic1UHFL60lT7PJ3V1pWvGG5f1puCFcVTa6gHCMzyb6g4dleH2jXfpGU2DMkU0MsuIZWWhb4QVcRYWmcxR2/pCZ6a0qsgxGSrKbPNaM0Lx8Ks7BqXpA0SuymT25aJVBagBGFPd9+xF+DEHRWvt8rJBtlanpHSaxhnI1d6Ij1fN0NfZJymlSC1IdwCXCPUeZ+HaHdRZMjZMVxrbwZ+uCqxGnSwrkHaY/k/ferjAnF7XsS2Oy2hjUe1r+lrCm3t98T9MdVY4PkBy6MJwe5CDbyx1ix23HEQYaw1Ave6NEZfqk1qVg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for newly added probe weight file.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 11 ++++++++---
 Documentation/mm/damon/design.rst            |  5 +++++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index b2649ea011f93..da5f9afd08aef 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -73,9 +73,10 @@ comma (",").
     │ │ │ │ │ │ │ intervals_goal/access_bp,aggrs,min_sample_us,max_sample_us
     │ │ │ │ │ │ nr_regions/min,max
     │ │ │ │ │ │ :ref:`probes <damon_usage_sysfs_probes>`/nr_probes
-    │ │ │ │ │ │ │ 0/filters/nr_filters
-    │ │ │ │ │ │ │ │ 0/type,matching,allow,path
-    │ │ │ │ │ │ │ │ ...
+    │ │ │ │ │ │ │ 0/weight
+    │ │ │ │ │ │ │ │ filters/nr_filters
+    │ │ │ │ │ │ │ │ │ 0/type,matching,allow,path
+    │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ ...
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
     │ │ │ │ │ │ :ref:`0 <sysfs_target>`/pid_target,obsolete_target
@@ -286,6 +287,10 @@ In each probe directory, one directory, ``filters`` exists.  The directory
 contains files for installing filters for the probe, that is used to determine
 the data attribute for the probe.
 
+Each probe directory also contains ``weight`` file.  Reading from and writing
+to the file gets and sets the :ref:`attributes-only monitoring
+<damon_design_attrs_only_monitoring>` weight for the attribute of the probe.
+
 In the beginning, ``filters`` directory has only one file, ``nr_filters``.
 Writing a number (``N``) to the file creates the number of child directories
 named ``0`` to ``N-1``.  Each directory represents each filter and works in a
diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 6d79e7d69be84..aed6cb1cf4831 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -316,6 +316,8 @@ Another way to do this for higher accuracy is using :ref:`DAMOS filter
 information in page level.  But, because it is operated in page level, the
 overhead is proportional to the size of the memory.
 
+.. _damon_design_attrs_only_monitoring:
+
 Data Attributes-only Monitoring
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
@@ -336,6 +338,9 @@ automatically turned off.  The access counter (``nr_accesses``) will always be
 zero and not updated.  Hence the mode is called Data Attributes "only"
 monitoring.
 
+Refer to the :ref:`admin guide <damon_usage_sysfs_probes>` to know how users
+can use the mode.
+
 Dynamic Target Space Updates Handling
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-- 
2.47.3

