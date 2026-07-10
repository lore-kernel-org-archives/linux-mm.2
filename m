Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE9B8C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 00:25:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FC4D6B00A6; Thu,  9 Jul 2026 20:24:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55F496B00A7; Thu,  9 Jul 2026 20:24:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44E586B00A9; Thu,  9 Jul 2026 20:24:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E0F36B00A6
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:24:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9AE3F1A02DE
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:07 +0000 (UTC)
X-FDA: 84970969734.05.AF6513D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id F3DA04000C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BPGETswp;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783643046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CCjb58wtAAk5F9PdDMQvKlFN0DE7q9fXquVywqvC5OU=;
	b=1WQfkvehBI2Ri/C0RSwsK/nSx0rD0Wu/BCz22RJ1uojx7UYSTCu3psR+X855YNPK4Vgoq5
	C4y3fd7+7gnePSY7KuxKbVhsGfp5ApJohutl5AWzanuaIL2Qdt6OhbiD9UV8178ahTUWuN
	gAaGZSWvhyoPhGazbdVlb/pljdDoxa8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BPGETswp;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783643046;
	b=m3SsSxCE/fkw83uWCwXh1HpphFAC88t0GbMqJFLK5JxYtM9NklkRhvUhx/Xtz3wLYorYMz
	McVOBmuDuC+Fgjfwi+P/idITv3JMPBOZrQknoZnDjPekngWEYZTXKAGk4i5PSO+rx0FXfo
	s3IncRewz31RvaWy3uTyThNdamuaPQU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9551761831;
	Fri, 10 Jul 2026 00:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54331F000E9;
	Fri, 10 Jul 2026 00:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783643045;
	bh=CCjb58wtAAk5F9PdDMQvKlFN0DE7q9fXquVywqvC5OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BPGETswpdavwH1kNHlT7mPx7fdNU54dpfWQvbgNXMTAeozjaUoVtHHbRejB82lKTT
	 97+CWRkM6amMegglrhwsovFFOr7sun1LNqC2Q3kHvIGQptkVmPh2tfzwUUque9jYc3
	 sXROnxxfJ7r9AHITK0j2cY1oxxHJuGl0cQ+0b06UT0rjaIsiqhlDyj8T+p1kYg2j+G
	 4SXGm3oxSC0cS9tJFvsGhE5rhRXY/50O7Xqbyd8csx3wBDjrO6gVZqcruCWzyaeJt+
	 nwa4LAk+iWlp91Zm8kKla1J6VliFv3j7AvluzVug/ypIZ5gei2aJkLFtm5wVt35S6R
	 w2OU/rZp0cYog==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
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
Subject: [RFC PATCH v1.3 18/19] Docs/admin-guide/mm/damon/usage: document weight sysfs file
Date: Thu,  9 Jul 2026 17:23:44 -0700
Message-ID: <20260710002349.111414-19-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710002349.111414-1-sj@kernel.org>
References: <20260710002349.111414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F3DA04000C
X-Stat-Signature: 53sdkfgc8qkgo4o5m8mrnuodnss6ybbq
X-HE-Tag: 1783643045-971828
X-HE-Meta: U2FsdGVkX19Ou4TOa6Vaj98ph5NI5orQLEDoGRZ21k6QQl7ttiGhUr77LHyaYHIiQcAZv+qkP2KgaRJbwHchsKJloB1PdDsrEKH1z1LXsblI1aSjV9ZE5ew/0v1b3Nkzo6HELq8poh6a/iSUFTcmtE4FJ08WREgXnjFONcW0a3kX31DLEVHWqTQXHHH6c6yS/Sj1dPAZOAE6c7TJ1qhGh6H6iFgjKhdST71jkWXcxoLcr3CUax5GDU5JsTLnnYq9SvemALxUmR/cOzTmNXhYq85YxDR9UiL0S2T9dDjMnbfIjB2Zi6Jr2CCR4RAX04x6maCBnAMxd15c7Y15ng9IH9aZr4sudmz9kP8oCkA/QwExgqMByTe+cn7jZtNeEuwzYx8il5m3vBn+CaqYeHTQw+G0raYGkIdqti7kykwmcizkIQ+ldzo9R7s/mGyaGQux/eWP5JBeJRtJR7DOthyYl3PYeWYAXly7+0DxqPFZYFIXGsuGzoZVc5NM1GRlR2j9NNxORYwAfC+lY9+MJm0SQOccCjsTj9iUtN9XDv1DJYlI+QTZ7a3csOSCA8P9emw9lLZe/Gmnf2OPjCh00Nr5mApBaXkoj/csPFoPa6fQR8zr81tQwk8/k/scjV8C3OX4dfMFi/e8zg2Me5KvKHpDbghIcCX8ufmvvc7JXw4tACA5fBXOMUf4VjW+Jd67cqWS9bdb07qA3ckfBJ7KB9PmYwqj3yUGIfoNIItgoLyx7SbBmVEQJF0dA77FYiNRgQSOa9TlcX/nJvm5ZKd0G4Z56DVfMyzb1klej6HjIFq0Z2ruBtQnysZo4usky+YNsQ5nEWyVOijp56EUD2b9WaNNQ9/Y3rqraT8lKJ0RDtxroHo/PaHn+DVkyg5HGWgCa0+qTLywrxXNooZwMA9mpz/7uEfNCqGslO40xl7NhMX6sxhfL6DGcrC24JehOODoSIAjrJNxnZxwot3usvsxn+S
 5rcHnxrd
 HdilsMENebtjdug3A0KFMps2A99ipjp1/K4DL82qBMlgK4yp2QP7Dyv8eog0gPxRulHoAitWMlRNUmywY4MDkI/FEiNS0li1Hf4oZAm/CGH/GvnhAnH3+XrVDjV0zRnYi1LQ7RXBS0BUTikEvu0rGlVRDkTup52YPr/2MvtU0v1k9AT5p74CSBz+j6A3hVvPqaw7Yu6B3eCuh0GjIM1aM/fT5OVO6rfGftfnZ+wJ0VU9If9Mz9CBPAVg90bR6bwcf8clzLXS/PPdBu+bo+5xwVCQhdr2XnoqHFdIWqci7E0BvBGR1rm1aHG6j5A==
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

