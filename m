Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 111DD606A320
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 11:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ccXtEBEm
Received: by kanga.kvack.org (Postfix)
	id 2E1886B05B8; Mon, 26 Oct 2026 07:18:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B8AA6B05B9; Mon, 26 Oct 2026 07:18:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A80D6B05BA; Mon, 26 Oct 2026 07:18:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E443C6B05B8
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 07:18:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7F76512077F
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:18:57 +0000 (UTC)
X-FDA: 85364530314.02.F6265B3
Received: from mail-pj2-f2.google.com (mail-pj2-f2.google.com [74.125.227.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id B27D580003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:18:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ccXtEBEm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.130 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793013535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D6FqnEFeAupUPbtnZ9Y7i7Ho9zVceUZfQGwi96SCg9I=;
	b=NR59bMkT+ENsI1oQ9SwacHXmZigRIPU6hElcZxUFkncF73Rj3YHS1Qg2428dBKpv2K4D5t
	w/36lUJU9URIu7g+KF4LaN0VXKqEy0nqGUUYMUuJExFnxYvMJFDLgvEzYCmbpNy+UtERY0
	GmzYxGUI66OFB1Og5WifyVv5LK1FfIw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ccXtEBEm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.130 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793013535;
	b=J3iY449DQmDxR7y8kSnUAolY2kIUllDfAgPyIXztU/9pjVAdq/ERNAQ+zcWc2qvtuipftD
	SmB2fFfRUhEyx07eVV3k9Vnfo7YzDGxDdqX9iiMl060fY3Sl3mvMSuwulqtagvfsa/aQhv
	x+tIi6/AvhAtu5YPyHYa1knn42FBQ8A=
Received: by mail-pj2-f2.google.com with SMTP id 98e67ed59e1d1-3adc8668936so849400a91.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 04:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793013534; x=1793618334; darn=kvack.org;
        h=references:in-reply-to:message-id:date:content-transfer-encoding
         :content-type:mime-version:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=D6FqnEFeAupUPbtnZ9Y7i7Ho9zVceUZfQGwi96SCg9I=;
        b=ccXtEBEmFGlAhIisq7nLIhJp1GPpCPdAwzCw7oNIYh0SSfuQB9gHOVqL9p0eVvrgAp
         KrKe2+wAAtKrokpbluYVlIssWm6boLzP1B9UlPsnukTv+QslAD/pQAJaosL5Mu9v7MAA
         /Iy30f7gqZQ6GHaK4XdkV5UL5iuOhXgTZO1WdlU7/XwTR/rwZMrrLGy62YETDJ30WLJd
         yS7JbTx6JhUGFFr0HVxu7OrA5C/+jNhg3kjx7T3qd19qjaJMlJlXot8GZdmua7/cB76+
         uRqMAXImXzY9syigXD4vnbGlb8hw469JAZq8L9Jb/nB3hRNV7+pVF8GRUvM4Q6yYBXe4
         H/FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793013534; x=1793618334;
        h=references:in-reply-to:message-id:date:content-transfer-encoding
         :content-type:mime-version:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D6FqnEFeAupUPbtnZ9Y7i7Ho9zVceUZfQGwi96SCg9I=;
        b=SsLftyHdxVrWjsOZRAZ/PqV4lnrYRG8C082njGWtsBhnSP8TLvdyruRApZ8jB6kUNE
         5rc8DDm3nZcV6rA3O5OxOSP8wz4p5dkFGHBYofbtWH4tAH2f1Ijay4Gn6YODA0aO947e
         lPAIW5yE3M3fykOBWSPDwOf0NWuKdL1NXrFHkfxdzsOnkvLqDfXnrix7ITGLMgE5tgWU
         +mhpjvOrU4Hm66PscBirryX2NDJ6WUN+NCVHK61hUeuVPjuPqJ/qDqZUjb+qK6ZWCfI7
         FpOLU3z33NqvbAEjrPCAYjlhm1rXSV+6xUo6XRnAsUiK3LHGYNYfJ8FU5KrdFJhrh3Zg
         8RSw==
X-Forwarded-Encrypted: i=1; AKwUvBzWximDoEgSgH0di845ZtygtQ0zmldfUYzIaPZ33k8V54gs+NjYc8Oq6Ojzn0ol2aHtoqFlpryMiQ==@kvack.org
X-Gm-Message-State: AFq9FYKF5kD4d8OtSvi7yaQLdyvxjbNrA9rZ0jAcvtJc0N4TADXvIwpl
	l16dfTZ4S/vicj6ycprXGgHNpf6S+SP2Hohkfiho1fa6GpYRGB3mHPU1
X-Gm-Gg: AYBFou30kvo6KcR0iAf9FmlCPnTb7xY+ZsKcXZ4J9HU4P6GS6nKR1oAeWYHxuIixHvG
	ZtSK0rNMYlWks2IZcBmNMrHehR4WHzqv1ELCPcA6l/XMQ5zkPPyxx/dVk6Je0T3uNuxxSGG4zTp
	Wtetm/PwICqTTMIFyAdhbNsq3TFu5tT29WRV0g/1V8vRTGT/ud93ur1de/2SJ7tsv942KPp/5oP
	3KElG/kzaNYRkZzHbajqoHw4rjvOWAHB+EbeuBe2zNuJHNCR9+O2BU5mDInemnd4PfzNwSKlI88
	9T0mywBr0AAKv68DWCEwHQSy2NBV869LOHfIlCDNUvM1U3x8lpjIxRa8EMQ9AJ+J0XzQfdwdFeP
	yjY5skMdVpIpbyz/UPmB6Bj3KUiZg2g93DJh7ZFX5gv7so2ftA/ha9OtKEJvW1kLJPDlJ4am5QJ
	wvJT9hXEAi+F2xOvKu6S6VhADwx4+eJkj77S13t00E2L/F+clRAUOFpiUVSxFBCZiYYpWDNYAWz
	cG3s3kgj0pL5yyrhTCe8qkphkFw0keWJ2UhJcpiCWYfJte0XMNH8Vjyx365/CdpWlmkqPHm154j
	iQ/nqt388gys2BudBDlS8p7LD1KBBBTnb+wd1BllDcpE8Hz6dDG23Z8=
X-Received: by 2002:a17:90b:2742:b0:3ac:8527:3fc5 with SMTP id 98e67ed59e1d1-3ade9b2f909mr4872984a91.3.1793013534409;
        Mon, 26 Oct 2026 04:18:54 -0700 (PDT)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adebb75254sm4783820a91.4.2026.10.26.04.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 04:18:54 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Manuel Ebner <manuelebnerli@mailbox.org>,
 damon@lists.linux.dev,
 linux-mm@kvack.org,
 linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] Docs/admin-guide/mm/damon/usage: fix grammar
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 26 Oct 2026 22:14:35 +1100
Message-ID: <179301327249.2.6830202812762243627.damon-docs-grammar-3@gmail.com>
In-Reply-To: <179301327249.2.4690198998605536207.damon-docs-grammar-0@gmail.com>
References: <179301327249.2.4690198998605536207.damon-docs-grammar-0@gmail.com>
X-Rspamd-Queue-Id: B27D580003
X-Stat-Signature: icc9t7fj7tg1dfqi4xmuiscbwrtkqw9a
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793013535-982625
X-HE-Meta: U2FsdGVkX195lQL3r4q7og2DNjMl8Bw5yZP9gGCswqXvlWy4lPryATzyhtY0WFLcpnyqew5NvmGdYYGsX9lH5XS70de3DMmMWgsaJwb8eYvt816g+VUtE05UcwPnFsAyum4L3rmhyunxXG/Hsvjm9UshCq2jh3i8jDWOe7BuRRHtb2v8LZIYo0rrhcnsWKMSglni0o6o9FEW+aiteo9jUROGLizCbMJo30uWpXdh9dSIxeb1p6O9BSo9fz3jlOHVOnuVU9Xcz60a5n3NgKN/uFAYPkSXWFNAP+0KcKUbRiN2D19hQ4oGL9tYAzKl0vZdGMZgvTBlK9Tje2xep8qYF0XhuJqNkNCNn6OBcw8wzGrMreoKEju/FlbP4GnhNaC2nnpGRtomIwILMZwXJJ1WWRC3o1IsTzykhFv43MiA76lYeP4zvCcMp16nufFEzJlO+3KhjbzdyytdvkelAmeaXjmXC/HWw1P75O2lJ0h7Vee5mp0b08BqcIYLMLJQlAn9lHJstZavQ4W7xPxGNG7oiOQU/TPn2ij3FI1P3R476/Hqx3VVqFs5FK5a/nN7RD8iyz4vzAkDAHWDHQDg7vvUDeIn6ZMUIsPumwC62Gb1aexvfxWwvb+7jS8G3lVlhxirs+5gmC9Qru5nUC1zsejPHI0LwyM9N8XFEku61yIVRLqCkHqXsz5ojjNhIrjX/IVeFmaK2TQ8QjdJX9+onSWJMTttKF5ACDwJ5CIAbBN3zndxvNIPVG8q2lAtgeXYHP19qWuZJJtSe+8tSYD+aXyZiUG2GN1nA6O6kKE9eC7ekQLeEelV/R1JPuO73Ak71+u3IJuPaIRQuIrtqGj5UZCKj0nCZNZw4oYxPfG7EBizeyl3P5ZrAjAD1s4yN2ZygwKDN+PsetL5L5zKtrw4z/lj1nMjjYjcjVFK8fZ5iRdFIoo90FfCSmP9pBYa+tq6Dv+E8BKHcw5OS/H/ALJ9OyZ
 wDQiDjKL
 dL8ycqC+uy+soy2nQyfbJnqf6V0L5U5nF5NGsxR/U7aDCdLVz3XcUmu/PcrodQbHZAd1NwXj0tma+ToNUoJyZMdcoiedJpo+zHQyMuI6t6A/NGLcLEVtmI51OXxK7j2tOjszT0KvUXARWa/3NRD8lEBLMe+1jIRv5TkeYeYXjUKmgBL03IO/BO38cP7G/46b7MIitsFv62RKY5M9OaLqqpO9Nj6Q0HVXHJj3oYP5Gi0uphfTdsTG/G2aa69ace2TRwe3GVj4Zc8TgAVCRLDbU7OYBfSJBAo6dKrWlaxuvp2UeTJrjkLbah0kb2DOaQ/Wc0jYiGhKtaXfsm+gkd1yqBbZTgru2qZbctzQ8nCLOTy4oqfe3v6Zaa5ELWgFrQ3dljQAxSnzGvOHcp3GR0SR0ouzh4J8nz9kYAWT3b2oVukcI1B1zowBQfyHF/lT1kY5D0plEvxCPoDiajpZOWQ9j4e32yMIyawEr9VCqB3DF0HHQO4hVfA4wjiLYoYDaZMufOfuEtsr2Ox//QMeoCOOl8s3u275ISKEe71whBwInfiqMnWg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Fix a handful of grammar mistakes in the usage doc, mostly
subject-verb agreement and a missing or extra "be".  Also turn "Below
commands applies" into "The commands below apply", which I think reads
better.  Rewrap where the lines got too long.

Signed-off-by: Aveline Noir <jm5905938@gmail.com>
---
 Documentation/admin-guide/mm/damon/usage.rst | 31 ++++++++++----------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 3c4f3651a244..ffb487defa22 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -23,7 +23,7 @@ DAMON provides below interfaces for different users.
   want more optimized use of DAMON.  Using this, users can use DAMON’s major
   features by reading from and writing to special sysfs files.  Therefore,
   you can write and use your personalized DAMON sysfs wrapper programs that
-  reads/writes the sysfs files instead of you.  The `DAMON user space tool
+  read/write the sysfs files instead of you.  The `DAMON user space tool
   <https://github.com/damonitor/damo>`_ is one example of such programs.
 - *Kernel Space Programming Interface.*
   :doc:`This </mm/damon/api>` is for kernel space programmers.  Using this,
@@ -163,7 +163,7 @@ Users can write below commands for the kdamond to the ``state`` file.
 - ``on``: Start running.
 - ``off``: Stop running.
 - ``commit``: Read the user inputs in the sysfs files except ``state`` file
-  again.  Monitoring :ref:`target region <sysfs_regions>` inputs are also be
+  again.  Monitoring :ref:`target region <sysfs_regions>` inputs are also
   ignored if no target region is specified.
 - ``update_tuned_intervals``: Update the contents of ``sample_us`` and
   ``aggr_us`` files of the kdamond with the auto-tuning applied ``sampling
@@ -258,7 +258,7 @@ writing to and reading from the files.
 
 Under ``nr_regions`` directory, two files for the lower-bound and upper-bound
 of DAMON's monitoring regions (``min`` and ``max``, respectively), which
-controls the monitoring overhead, exist.  You can set and get the values by
+control the monitoring overhead, exist.  You can set and get the values by
 writing to and reading from the files.
 
 For more details about the intervals and monitoring regions range, please refer
@@ -310,7 +310,7 @@ Under the directory, four files for the auto-tuning control, namely
 Please refer to  the :ref:`design document of the feature
 <damon_design_monitoring_intervals_autotuning>` for the internal of the tuning
 mechanism.  Reading and writing the four files under ``intervals_goal``
-directory shows and updates the tuning parameters that described in the
+directory shows and updates the tuning parameters that are described in the
 :ref:`design doc <damon_design_monitoring_intervals_autotuning>` with the same
 names.  The tuning starts with the user-set ``sample_us`` and ``aggr_us``.  The
 tuning-applied current values of the two intervals can be read from the
@@ -538,8 +538,8 @@ Among the multiple feedback, the best one is used.
 Each goal directory contains six files, namely ``target_metric``,
 ``complement``, ``target_value``, ``current_value``, ``nid``, and ``path``.
 Users can set and get the six parameters for the quota auto-tuning goals that
-specified on the :ref:`design doc <damon_design_damos_quotas_auto_tuning>` by
-writing to and reading from each of the files.  Because the kernel does not
+are specified on the :ref:`design doc <damon_design_damos_quotas_auto_tuning>`
+by writing to and reading from each of the files.  Because the kernel does not
 update ``current_value``, reading it only makes sense when ``target_metric`` is
 ``user_input``.  Note that users should further write
 ``commit_schemes_quota_goals`` to the ``state`` file of the :ref:`kdamond
@@ -577,8 +577,9 @@ DAMON-based operation scheme.
 ``core_filters`` and ``ops_filters`` directories are for the filters handled by
 the DAMON core layer and operations set layer, respectively.  ``filters``
 directory can be used for installing filters regardless of their handled
-layers.  Filters that requested by ``core_filters`` and ``ops_filters`` will be
-installed before those of ``filters``.  All three directories have same files.
+layers.  Filters that are requested by ``core_filters`` and ``ops_filters`` will
+be installed before those of ``filters``.  All three directories have same
+files.
 
 Use of ``filters`` directory can make filters evaluation orders confusing to
 expect.  For this reason, ``filters`` directory is deprecated.  It is still
@@ -654,16 +655,16 @@ Users can write and read the identifier of the destination to ``id`` file.
 For ``DAMOS_MIGRATE_{HOT,COLD}`` actions, the migrate destination node's node
 id should be written to ``id`` file.  Users can write and read the weight of
 the destination among the given destinations to the ``weight`` file.  The
-weight can be an arbitrary integer.  When DAMOS apply the action to each entity
-of the memory region, it will select the destination of the action based on the
-relative weights of the destinations.
+weight can be an arbitrary integer.  When DAMOS applies the action to each
+entity of the memory region, it will select the destination of the action based
+on the relative weights of the destinations.
 
 .. _sysfs_schemes_stats:
 
 schemes/<N>/stats/
 ------------------
 
-DAMON counts statistics for each scheme.  This statistics can be used for
+DAMON counts statistics for each scheme.  These statistics can be used for
 online analysis or tuning of the schemes.  Refer to :ref:`design doc
 <damon_design_damos_stat>` for more details about the stats.
 
@@ -722,15 +723,15 @@ tried_regions/<N>/probes/
 -------------------------
 
 In each region directory, one directory (``probes``) also exists.  In the
-directory, subdirectories named ``0`` to ``N-1`` exists.  ``N`` is the number
-of installed probes.  In each number-named directory, a file (``hits``) exist.
+directory, subdirectories named ``0`` to ``N-1`` exist.  ``N`` is the number
+of installed probes.  In each number-named directory, a file (``hits``) exists.
 Reading the file shows the number of data attributes monitoring probe-hit
 positive samples of the region.
 
 Example
 ~~~~~~~
 
-Below commands applies a scheme saying "If a memory region of size in [4KiB,
+The commands below apply a scheme saying "If a memory region of size in [4KiB,
 8KiB] is showing accesses per aggregate interval in [0, 5] for aggregate
 interval in [10, 20], page out the region.  For the paging out, use only up to
 10ms per second, and also don't page out more than 1GiB per second.  Under the

