Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46653CCF9E9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 18:22:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E5858E0179; Sun, 26 Oct 2025 14:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76EE08E017E; Sun, 26 Oct 2025 14:22:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59F088E0179; Sun, 26 Oct 2025 14:22:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3654A8E017E
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 14:22:29 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D204313A858
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 18:22:28 +0000 (UTC)
X-FDA: 84041085576.18.FBCC9E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 26F88180003
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 18:22:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a8HhEKac;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761502947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GzKD5JL6IymFK1OYMS617C2qW1B0Sz1Oo4QS+YhTXew=;
	b=InELRC6ECydVrGlhStg3PMecdaMdM1/VjKjcRsCiEJEAyBX8QCj6shJfZBAiBUx/PABBAg
	eIduiu82qXZsVdD1/a+8divyGBAStD01uojUjrT9NFDm3sPeu8MiJ7ReynfTExoZHsV97J
	mlbh4Xv086S34m21Ob26zFJJM3TllEo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761502947; a=rsa-sha256;
	cv=none;
	b=6zwLNdGvaH0VbQGBh5aeSfqDL4DJ9t/HWNqJmkDuqg8w5dwE3ZUj8qv8j8pLzCjtrqF26J
	e8soOTSxHAR4NLbSo0ybHR/Z2Nrs5UT2R7ZxwbCyEBAjpEfEUI7+HRnbw+zoeDfC3w38Dk
	jTlUPy2+BLH06k9FyqhJ6XLwZzDKIuI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a8HhEKac;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B47AD451B3;
	Sun, 26 Oct 2025 18:22:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60492C4CEE7;
	Sun, 26 Oct 2025 18:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761502945;
	bh=HTEUhayo10VIIHTrpNQMg1meUMUdoEd6UZy7MJUO3rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a8HhEKacHBy4+fTLed4bI/HXIzp7f0fyoBsAaukKkycunU/gHfrRznT04l5Hpi6XS
	 QX+yv9feyV4/2phxDVXL10MnhFjxx3pKGIrkyHJQtabJihUZh/XefOqpuBm9A8qowW
	 xjJz2FeVtH1Wyvt9RcslPpeX8osSGVQ1HybXCNpwN3s1z4GcByZrb3Ls7lV+Pfj8C2
	 ccYDEjAXXn8c+6zchlv/j26VcUS2ul230UE/6ve4dm63r+KmxbFvgOirEuG4nzIVlY
	 +YRAHmcrGlWj7wl1ixuTisJQ4OPWlJKQWZB/EV9UJ0n+MZdKwHoJhdziAESyqM2Xiw
	 iisJsBClf9h5A==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
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
Subject: [PATCH 7/8] Docs/admin-guide/mm/damon/stat: document aggr_interval_us parameter
Date: Sun, 26 Oct 2025 11:22:12 -0700
Message-ID: <20251026182216.118200-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251026182216.118200-1-sj@kernel.org>
References: <20251026182216.118200-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: nx195xydy6bac9a4q6xa9qbqbsrjtugm
X-Rspam-User: 
X-Rspamd-Queue-Id: 26F88180003
X-HE-Tag: 1761502946-157686
X-HE-Meta: U2FsdGVkX1/L2vjXMWjP7R/KmAlVbHakHBI1hGk4FaUw8HkA5ajwAAHyuWJ5SrT2vGe1kQgvNs6y1ZgWUl5w4Jb1iTP+TXp2ejfWrw22GA1TL7T/zL9Qw6wuIhZKt0pFxUMWBwsVXTRpH37/hn10fGwWTi4Up07n6bWRZ1v+k/ec8sa2GrIDKeJKpC3pG1BAGv/8VEEvbzgWH3So9mQQK1RKJc0+k43KP41Wne/4EfGjL29/KWPyXLn45SbhSSxgvkNdNnXyY6/ati7ry+H3t7K5qUsic1oyfgd5pz/xzJ2xMh0BstMxHyrE8LNZOdVvRo7UvEYV/G9ke7CkV4YczupAve6l2YVBw45C3tW25Ar6/fZhQfG9rG5qBDQ0t52WZ/Zas26ro3xpBAzFUlh+Z9N0yjPuGUFKmkdBtPVoZ4V3jKsHMW7MqQs4pADd9SnuCDbEmb6n+Bw/3/iGgkWL4aunf5Mb5wQBH5ercMJje975n2OlzG90h8mmo2gf35ztgFa2isIXRyIetHiIm+ljlYKCWCza0NBqfBQ6UGd75wqgqAmguEduls+sGeZfVtn+pxjBw4ItM2ZX42kxc1QfcHPjvdWSWnMQNxj6LCcIi/I+uJakNiC3tUuO9Wp1TOUB2CwHqPaXa2Izs5EHixQHco5IQrvQ5drVKQId3OT3lwxZDlcAu4mUQCCI4J3YgCRIMC5hZUOWwW9HmcMGxAjjEsB8VfOQXwFZtEQq2rygjHMYKpplUbG1fvNzqO1xQz7n8mjMVmwqVsYYRr9rqOFqQ4DWqyFjwhTBzRAsgrlgNN6+QaCDU7wstpg0VvJHFISw1QhCNa+hiJImKZdgUq2pOBXAA2YOWWKunrolmfWXs4dfJIf1Vc6FroMwNSrYby89h+lZDykGffHNKdERIHjd+o8UR/SuhTTuVN1ZNRY+Au09S/LHq6Io37rJb9FVmXliWilRkX/AyZ+l/VqB+m7
 TQYbjvAv
 NUkUDFLaskwa3y173nMeUHwwjiPlCO5tjYCM3Omb5xUVnUCcvXBzuW+POtbbjAJ6LHPevsWV7fL5XH7vbl3Qyo6+X0KF/Sy2W2A9O7ClDqpHCAhBUwRixaMh5NRoSPV7uEdjJxgXEHaqJGNKTwDmxP6p4xiDl3D+cThfqB0kVwihYtZue9rFvlM/J+ISQL4ibcDQVC0hpS1KzuhEyCSZj9p5vjgeCJU5hUh593xGaWUcmiInX2uuQeUHTwBEMrUchUbF7x+Nw2Q+3zyybPSqZvl6I9QvwGFsfdfCWInKUuJ2egr8EUbBZMlXWgXRi1bmpHDnJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit cc7ceb1d14b0 ("mm/damon/stat: expose the current tuned
aggregation interval"), has introduced 'aggr_interval_us' parameter for
DAMON_STAT.  But the new parameter is not yet documented.  Document it
on the usage document for the module.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/stat.rst | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/damon/stat.rst b/Documentation/admin-guide/mm/damon/stat.rst
index 20f540a9d3d2..754f98d47617 100644
--- a/Documentation/admin-guide/mm/damon/stat.rst
+++ b/Documentation/admin-guide/mm/damon/stat.rst
@@ -10,6 +10,8 @@ on the system's entire physical memory using DAMON, and provides simplified
 access monitoring results statistics, namely idle time percentiles and
 estimated memory bandwidth.
 
+.. _damon_stat_monitoring_accuracy_overhead:
+
 Monitoring Accuracy and Overhead
 ================================
 
@@ -19,7 +21,9 @@ overhead minimum.  It auto-tunes the intervals aiming 4 % of observable access
 events to be captured in each snapshot, while limiting the resulting sampling
 interval to be 5 milliseconds in minimum and 10 seconds in maximum.  On a few
 production server systems, it resulted in consuming only 0.x % single CPU time,
-while capturing reasonable quality of access patterns.
+while capturing reasonable quality of access patterns.  The tuning-resulting
+intervals can be retrieved via ``aggr_interval_us`` :ref:`parameter
+<damon_stat_aggr_interval_us>`.
 
 Interface: Module Parameters
 ============================
@@ -41,6 +45,18 @@ You can enable DAMON_STAT by setting the value of this parameter as ``Y``.
 Setting it as ``N`` disables DAMON_STAT.  The default value is set by
 ``CONFIG_DAMON_STAT_ENABLED_DEFAULT`` build config option.
 
+.. _damon_stat_aggr_interval_us:
+
+aggr_interval_us
+----------------
+
+Auto-tuned aggregation time interval in microseconds.
+
+Users can read the aggregation interval of DAMON that is being used by the
+DAMON instance for DAMON_STAT.  It is :ref:`auto-tuned
+<damon_stat_monitoring_accuracy_overhead>` and therefore the value is
+dynamically changed.
+
 estimated_memory_bandwidth
 --------------------------
 
-- 
2.47.3

