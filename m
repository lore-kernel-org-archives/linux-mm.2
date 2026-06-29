Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 375B3C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:55:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDF0A6B011D; Mon, 29 Jun 2026 10:55:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D93DC6B011E; Mon, 29 Jun 2026 10:55:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6A0C6B011E; Mon, 29 Jun 2026 10:55:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 67D236B011B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:55:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D27561C0D0B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:55:47 +0000 (UTC)
X-FDA: 84933249534.04.CB1FC22
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4CBFF40015
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:55:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M6POtsQ7;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744946;
	b=zzgFeiX/Y5NR/ZQiAY0Y3UwAks9qyYnHngOjjXxHobzrxzjxzPgiubfvlL8r3D7KyiZrUV
	0nlRunt+aLctKRLyAJFK3DAUGxcfoU5x9Z8ctT9Bu1hxIdhUUmTjW9BGVgZ4nmiFzEXrEe
	0+zn3IN0PWRHx7KTaHEMkikkMTeJ8Xs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=glg/l+97lI6caoDUvXnrGH8mHyRTc6ftKl7nh2+8cz8=;
	b=7EZHom4ei4D42ciBAWaIcHXAlD8guVpkTpPPAH+EV9rdDV0TMwoNfASBUmCqXHvZ7IMmhG
	Vt1HfIgeY/K9o0NUpQT6q0rdzTbqqKJhLiJzff6rCmdL81FO1voiPMUfI47MHf4or4PT3f
	haQWUOfDdRCn1nh7ptIEG0tckcbdeUo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M6POtsQ7;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D9BD760172;
	Mon, 29 Jun 2026 14:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFE91F00A3D;
	Mon, 29 Jun 2026 14:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782744945;
	bh=glg/l+97lI6caoDUvXnrGH8mHyRTc6ftKl7nh2+8cz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M6POtsQ7JwmFriLSUrGusEFtYk7bOEnNTG5xsCHvROuypRxbdJzTOv1JY3znWxYIL
	 Lsa+7xKyixqJnDniTwmiovWuuCzQYr2zooe5OLSRu2/I/j16UemiOs4/Rr8d3xFZkp
	 CwoJyfx+45upeJBPkYdN2+j4yrIrq4/uWq6WNkoBe1Y64oHEKeaC6dp+nO5hzLX8Pn
	 9nayPZef9Pa5G9WERePzsQ9x00WSkgICjp0bNoTplPbp1SP9uB2fnKNEsSw9LvbVVJ
	 dY1jP0GGKonOw9Qz9xAMZ7vHBzH9Jee/PT6Hsz218cwJkPz5lP6FFBI1buzoYkCnDp
	 B9c8EvOAix4NA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Doehyun Baek <doehyunbaek@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/5] Docs/{admin-guide,mm}/damon: fix DAMON documentation details
Date: Mon, 29 Jun 2026 07:55:34 -0700
Message-ID: <20260629145538.134832-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629145538.134832-1-sj@kernel.org>
References: <20260629145538.134832-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4CBFF40015
X-Stat-Signature: puzupamu5871xchbqxohzpp6adzps5nn
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782744946-965696
X-HE-Meta: U2FsdGVkX1+11JJRAXoeAssl1MOw5oglDU/HCwea6ZM+uui7PG3YTfezMyQmFLxcyrPZatsE8xYfbjxCC1zScMTqBGY/nQ0Pxau4bE0AzxtBRNPXrVpvaCiZIrIKQVROdbSZzQ6dvPivZCY5U4hCYgmoBdvDda18qfYDdIMwd8uWIG1lFPZp2r6o/ZSRTbTYr1zE09Dhm8ehedGfHR054adhCJxuhI5XeGAWmQTWt1QIaemR0wj8y+r+/DNBK/kW92lbKK5LDJHXWsYc6028gwJodXlZAnfs5MxQXJgxFBpfxjwGG6E0OmBau6IgI/Otiq78f2xmeOWml9029ZIqzutRFUjCzlA/nYPOIp11ZTdPViaFCdkpEv71UfnMVxc/+e6l2tT4cwW/Pgc7VmuozrqJt4zPZ3gkgZiqWMZ0agOkBUkvkYanNI3cI+f68OXjdDbqIfXtmag6aRvCv2+lApXVNnbvY9sRZQ7lYRJcZHedyFmYWAIjtWhGqcTRK3YYTDnR+q/ovdFIrBFqciaZZcbGHw6jyg/16wIq+0a1Zu2NtF1mUgsdGvGOu+ZCPf4aS48/cD/iwj/SLRXfwPvl3knQYQEzGaU4ojFMqDQULWSfF5Si7Qo+L4KgnDtKAi2lDIougoXyR8Bsvww7n6zELjMtHKuhNi1gsqBKGkLSQVFjmr7oEKHaoYk8AzHfU/wzxDAXMaSyI8nUD+Iq8N2KKiFdCQm4+4pVuERjwaT2hoG+mH8UvufRN5o11mIAx/8oBNZWCdFQmuJBnhL3d06/vylJfQI27xobFAGe4kkyCiF/0qSQep94G7Sfw4xVpPL4d+caT98Dr3hzqYHdGlCfei+9hs/oOKi3X8i+m7UcIR5+wtWyDZ36KQyL1pDJC07UPJuRMblD7xuUI6zdAMBh3Si4SQASHao//TPY7Lx9FBAIxhN8r2JN0GB5obChlB1eVHGAO/txnXDkHeB4jIc
 2Do0iuVj
 Mts/teM+aTr3mtCikV+35UM0sftuEPITBGhCp3XHwZh8Eiss+meT6IWcbDQw0SqQRMGdhyW40qY6KwwFTh80iO4ji1p6h2iG8dB/yaulgnx0Oy3X3CXGDnaFMUnOuWJUE8dcNkPIO19dEl/wV/ch+D5MAHFwGt0ldvPqCLcWTDkK4PYQ4MK5pLFZOXzCSYs1WDQXp5P1j61JreV2y85di0bVrNb8Xi7WKFt6E0H4NaYSSYWSHg3wjvhspU4cGfWq6YVy9enxJvd/mHAdIWvW8ubJmgOezdboYYB+7PytRCd7d0qnTcb7M1IrZJYbcsfDjqtwK8ixa170pG0lpRAEOO/8WIxokizlK6MRxP8QhVOh0Cyug098HMiRCGtE0MAMhNZzRbrUeM9vflTFbLBL/JkuMsNE5O0+TZmf4NcdTmD0wKBbXQLtwakvnCnEg3IeRBvBWUsRZLnSbEI/2/TstuW5LzUyXpm3Nh0sSZ9Xn8My9+vi0e6NIminHCdSAgnGUjxxto9BQNwXdgtI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Doehyun Baek <doehyunbaek@gmail.com>

Fix minor DAMON documentation issues.  Correct the sysfs scheme file name
apply_interval_us, the DAMON_STAT module count, a malformed reference, a
misplaced label indentation, and a few typos.

Signed-off-by: Doehyun Baek <doehyunbaek@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v5
- v5: https://lore.kernel.org/20260610053951.553739-1-doehyunbaek@gmail.com
- Collect R-b: from SJ.
- Rebase to latest mm-new.

 Documentation/admin-guide/mm/damon/usage.rst |  8 ++++----
 Documentation/mm/damon/design.rst            | 12 ++++++------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 011296f1e7c21..b2649ea011f93 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -246,7 +246,7 @@ writing to and reading from the files.
 Under ``nr_regions`` directory, two files for the lower-bound and upper-bound
 of DAMON's monitoring regions (``min`` and ``max``, respectively), which
 controls the monitoring overhead, exist.  You can set and get the values by
-writing to and rading from the files.
+writing to and reading from the files.
 
 For more details about the intervals and monitoring regions range, please refer
 to the Design document (:doc:`/mm/damon/design`).
@@ -264,7 +264,7 @@ Please refer to  the :ref:`design document of the feature
 <damon_design_monitoring_intervals_autotuning>` for the internal of the tuning
 mechanism.  Reading and writing the four files under ``intervals_goal``
 directory shows and updates the tuning parameters that described in the
-:ref:design doc <damon_design_monitoring_intervals_autotuning>` with the same
+:ref:`design doc <damon_design_monitoring_intervals_autotuning>` with the same
 names.  The tuning starts with the user-set ``sample_us`` and ``aggr_us``.  The
 tuning-applied current values of the two intervals can be read from the
 ``sample_us`` and ``aggr_us`` files after writing ``update_tuned_intervals`` to
@@ -377,7 +377,7 @@ schemes/<N>/
 In each scheme directory, nine directories (``access_pattern``, ``quotas``,
 ``watermarks``, ``core_filters``, ``ops_filters``, ``filters``, ``dests``,
 ``stats``, and ``tried_regions``) and three files (``action``, ``target_nid``
-and ``apply_interval``) exist.
+and ``apply_interval_us``) exist.
 
 The ``action`` file is for setting and getting the scheme's :ref:`action
 <damon_design_damos_action>`.  The keywords that can be written to and read
@@ -743,7 +743,7 @@ counter).  Finally the tenth field (``X``) shows the ``age`` of the region
 (refer to :ref:`design <damon_design_age_tracking>` for more details of the
 counter).
 
-If the event was ``damon:damos_beofre_apply``, the ``perf script`` output would
+If the event was ``damon:damos_before_apply``, the ``perf script`` output would
 be somewhat like below::
 
     kdamond.0 47293 [000] 80801.060214: damon:damos_before_apply: ctx_idx=0 scheme_idx=0 target_idx=0 nr_regions=11 121932607488-135128711168: 0 136
diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 2da7ca0d3d17a..c16a3bb288d07 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -86,7 +86,7 @@ To know how user-space can do the configuration via :ref:`DAMON sysfs interface
 documentation.
 
 
- .. _damon_design_vaddr_target_regions_construction:
+.. _damon_design_vaddr_target_regions_construction:
 
 VMA-based Target Address Range Construction
 -------------------------------------------
@@ -930,11 +930,11 @@ control parameters for the usage would also need to be optimized for the
 purpose.
 
 To support such cases, yet more DAMON API user kernel modules that provide more
-simple and optimized user space interfaces are available.  Currently, two
-modules for proactive reclamation and LRU lists manipulation are provided.  For
-more detail, please read the usage documents for those
-(:doc:`/admin-guide/mm/damon/stat`, :doc:`/admin-guide/mm/damon/reclaim` and
-:doc:`/admin-guide/mm/damon/lru_sort`).
+simple and optimized user space interfaces are available.  Currently, three
+modules for access monitoring statistics, proactive reclamation, and LRU lists
+manipulation are provided.  For more detail, please read the usage documents for
+those (:doc:`/admin-guide/mm/damon/stat`, :doc:`/admin-guide/mm/damon/reclaim`
+and :doc:`/admin-guide/mm/damon/lru_sort`).
 
 .. _damon_design_special_purpose_modules_exclusivity:
 
-- 
2.47.3

