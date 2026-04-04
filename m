Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48188E63FE0
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 16:40:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A0266B0092; Sat,  4 Apr 2026 12:39:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100456B0093; Sat,  4 Apr 2026 12:39:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBD056B0095; Sat,  4 Apr 2026 12:39:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D37DD6B0092
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 12:39:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 73F29E065A
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:39:58 +0000 (UTC)
X-FDA: 84621435276.18.8AD4208
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id CF9CFA0009
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:39:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JTLsNDJW;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775320796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UT3tdH/yXhN1Xj/RH+t5jiIQ8PXD1Wk2BUKXg/uM+rc=;
	b=h1QsW0gRV4qYc3civuFRvNYoTQvwbdidIB82x3LqghUcSylO2gc+DdZrlxZAhF11folZea
	nS4692QhRjSIYKQGjJnHLyuDTu4Z7rVWpifTUPXnlkHUUkufgm7Zk94zi/SHjuJj2qgH5p
	3OGwyWzDiN2qe+PYtY+BI1NYp2Nhm/w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JTLsNDJW;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775320796; a=rsa-sha256;
	cv=none;
	b=vof5bSW8GiUEmtQqYEQEnps7LJHupuL5hTP3AAXUhMkUteQYOdoYlKjcjQLIf7BPckd221
	mhoen0lwWJzjatfKbRRlcY8/MYjiZMIwMfCKi8VdQm0Uz67MkyDlbBLh1416gqCVedyPR1
	djKX+ZDxaItDj82UIdgUR60nPdB5Hyo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3DB8460121;
	Sat,  4 Apr 2026 16:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643DCC2BCB2;
	Sat,  4 Apr 2026 16:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775320795;
	bh=mzfOdcEC1x6C2aREi8i81jeKTNH0+1J8f/eMCT7uMu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JTLsNDJWR1+Z9PlJJAefLfu7eEwygzdlpvNGi9eVF50HYLYXBl/w462ko3Ogt/05f
	 hLufLGLFmZlyuddDwx4bi3SAI1zgW49vZiyAwlZgu0hfkMwC/GM1DSlc/Y7HqTlwuI
	 boUm5rjyP79IqfJRJJom62sInF4y5biBpfQUmjrsvYFblADelS9Yifg0VCCHpGK7Vj
	 G2OJ+Ryg7mrDF/9WTtqe1M9H9j/w6tBjbzVw02efdG86kqvVmJQ/24ROhMrKt7kXcB
	 ImUMd723CDpmnStlcyG8XEE6ruBaWGz2qbg1un7idTmPQbm0Ho7CQeoWQbzWh7Cb2Y
	 jJFiSaEUe+5tA==
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
Subject: [RFC PATCH 4/9] Docs/admin-guide/mm/damon/usage: document fail_charge_{num,denom} files
Date: Sat,  4 Apr 2026 09:39:34 -0700
Message-ID: <20260404163943.89278-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260404163943.89278-1-sj@kernel.org>
References: <20260404163943.89278-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CF9CFA0009
X-Stat-Signature: ereg1ueu5pucd8kqnqmkn68beisom5uo
X-Rspam-User: 
X-HE-Tag: 1775320796-441031
X-HE-Meta: U2FsdGVkX19KXlX3siMjL/LoA7x0vQmlLFRy4maDFwOhG0Ts6e5FD8YGDVEsBfpqV6t75Xuvw+PeAkmJJQdWbhLmRGT8ohELi1e9HH3KPFbCO+hGPiBVYaQT1X7UsfvqaUqGkw/D/no8fhx2zp8x922i6NFR2J1uvQyK7sleNTSsLssOa83r6TbZcZj9ZMlcALMfy+GSlpMZDdjG/Sc5GZeZkDZQhodVYGWEKxaPbyNvZCmdaWsgE7HYNzSzu1p9axqP4Ct10BleztIB3zFoi8vnarzV/FSigr0Z+J3hMHb2PRpOPYAWu3KZ2XV+OXHoQhDGByP7DwoKSUAFOTBXe+opZpohDoa/gq0En7AZK10BUkC/3rMNtuimLcwXGPLIYas6LYcY0hmY0MzEhdRot420XSxR4qopJinbyPA4kmPac65TaUCKFxZXtvvGbc0oMn4XgEnTBGaLXRwYgRR/5cpCOrpvHQqy4pyzn/e3sfIrKzwX/sPlkm3IBd/w074PBuB8AOX7a+D2She549Phn3hY7hX5aN+x6QCCbfGwxZFXZ0HpnA7iMsX3mqWdGxe47E4AM/XbsYy9etkB4+4QaCLNUaKHPb3BxYY1DaDVe2mLmDG/2xs0SE3YeNmJzvxiijtMrN6wO6CmMWtEw8jMHEqvGbL0kGaSVE8JrWn0rN3HwppiBOq0eJOnqBv59L3G2a/JHyCCdfNdUuHpGFnk0cAg4BUSRYsKKR1z0Z+dmWi7ZhjN1USapAENy4S4MTknx2WYVErg3eKZ2j3NXOEowo1KbxcD2cOjHAwINRJfjo7siKZY9zDU8K3n4Y/UV9PUMpOy+hMovk2IQ4/SL/0Mcj8Js5OUNfoAlPC91SXy+aFIMweeDcSRffqFrl7NTPsme+6+aKIEy9p2m4WY12f+SOplyNN+660ktXUUZ+dr4bR17mZU0igsiIL4hVYpfUCqu/SoOXlCZvNxU6JibEI
 5dkP8/FI
 j30PlqHHd3mtIlW2a1WqI+wHDFaZiF7kAn8RlDJkNwN5ATJQ9nmrROSg/xt7vvGcXEMF5WOyBqvn6L9CmHWFZi7jdv6nydIWgHOJANIxsD31XK/L3Ptb9eJQfa7uHMtYsnatPTYhxj6p6nztMlWxTIaK/jnhxQS2cHmtabX1ZjDBOhxwbM3VVW7WzzUL4Axh6+HrGMTJvLK42/gz+K2z+QHB1leJtt8Pb3ppZ/lT5R1OREUA9htiZNAM54BUBrT83GlQFZ0vf0x+FDrQfYIFOThEqlwpEE8dO5T7aGQSCYNRpUi6f03ZKp1Ab7FGyMg0KiTkNNrZkiSxxqSK9IPqMa/SLnny/4plH4zwZ3PjJNDlqHplRHj8si+ms5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the DAMOS action failed regions quota
charge ratio control sysfs files.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index bfdb717441f05..ffb32bdbe34ff 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -84,7 +84,9 @@ comma (",").
     │ │ │ │ │ │ │ │ sz/min,max
     │ │ │ │ │ │ │ │ nr_accesses/min,max
     │ │ │ │ │ │ │ │ age/min,max
-    │ │ │ │ │ │ │ :ref:`quotas <sysfs_quotas>`/ms,bytes,reset_interval_ms,effective_bytes,goal_tuner
+    │ │ │ │ │ │ │ :ref:`quotas <sysfs_quotas>`/ms,bytes,reset_interval_ms,
+    │ │ │ │ │ │ │     effective_bytes,goal_tuner,
+    │ │ │ │ │ │ │     fail_charge_num,fail_charge_denom
     │ │ │ │ │ │ │ │ weights/sz_permil,nr_accesses_permil,age_permil
     │ │ │ │ │ │ │ │ :ref:`goals <sysfs_schemes_quota_goals>`/nr_goals
     │ │ │ │ │ │ │ │ │ 0/target_metric,target_value,current_value,nid,path
@@ -381,9 +383,10 @@ schemes/<N>/quotas/
 The directory for the :ref:`quotas <damon_design_damos_quotas>` of the given
 DAMON-based operation scheme.
 
-Under ``quotas`` directory, five files (``ms``, ``bytes``,
-``reset_interval_ms``, ``effective_bytes`` and ``goal_tuner``) and two
-directories (``weights`` and ``goals``) exist.
+Under ``quotas`` directory, seven files (``ms``, ``bytes``,
+``reset_interval_ms``, ``effective_bytes``, ``goal_tuner``, ``fail_charge_num``
+and ``fail_charge_denom``) and two directories (``weights`` and ``goals``)
+exist.
 
 You can set the ``time quota`` in milliseconds, ``size quota`` in bytes, and
 ``reset interval`` in milliseconds by writing the values to the three files,
@@ -402,6 +405,13 @@ the background design of the feature and the name of the selectable algorithms.
 Refer to :ref:`goals directory <sysfs_schemes_quota_goals>` for the goals
 setup.
 
+You can set the action-failed memory quota charging ratio by writing the
+numerator and the denominator for the ratio to ``fail_charge_num`` and
+`fail_charge_denom`` files, respectively.  Reading those file will return the
+current set values.  Refer to :ref:`design
+<damon_design_damos_quotas_failed_memory_charging_ratio>` for more details of
+the ratio feature.
+
 The time quota is internally transformed to a size quota.  Between the
 transformed size quota and user-specified size quota, smaller one is applied.
 Based on the user-specified :ref:`goal <sysfs_schemes_quota_goals>`, the
-- 
2.47.3

