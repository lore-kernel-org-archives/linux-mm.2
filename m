Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 241EBCD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:38:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB1796B00B3; Tue, 12 May 2026 10:37:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8A756B00B4; Tue, 12 May 2026 10:37:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B797A6B00B5; Tue, 12 May 2026 10:37:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 964946B00B3
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5552540488
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:11 +0000 (UTC)
X-FDA: 84759020262.24.9B523BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7B67F4000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j8bnVnRH;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jVvgkwoumhFmJdDElpW9sDh/rhAQYtD8kH0626J2Mz8=;
	b=iDWdIbL7LQx9m6bsGo0jU4RWq/Vk4wqalPc+/Ou3cfndfTR+n6t+kIBd02qAewbdq0LdER
	xmgKhkj6LF14ABRlS1dk9Ga9z9emJtWIsVCfChyoZfOdhA7U5hf4El0n+EKAy9YHWfwF5j
	LJ5F9QYOAMhiDUrpGPPpWfBdCM6ZzXk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596629; a=rsa-sha256;
	cv=none;
	b=f6ueHiyO5/bL8h15XrKBqIdvZHKlwkAnQ5Ad7yGtmf0Brrg1L8f2J4iNh5nTgvHfTRpm2S
	l1BaMTRRo03Wltb2O2AGn2Dsa6k0gWQZALbPihkHP+cFqSWginiV/739wb06YBz+03Ut6r
	ulcU9HavF9MAi54hzgtqDJxlyYto1J0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j8bnVnRH;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3E52644A8F;
	Tue, 12 May 2026 14:37:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98AA0C2BCF5;
	Tue, 12 May 2026 14:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596629;
	bh=QiZyClLpM+jtGeAv4uUzZ2zYrmnjLH6QxsmmjjG7o5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j8bnVnRHe0oMq1ecjHuGJ5gFJ+0gNOQuH6/dC+xnhET/c6Y4OvlTL1PpRIpwqy2l9
	 jZcxe7i8FDDpWSHTHU1ZpMLpLw1MqE0PfoKmoLjMjWib6a9JZTgIaof48NUalaPccm
	 QgczXgD2MUURpkTcAFah3jxP2DxhEubA0B2E3UVbeZ3F/1PeHMvV4LFnAy/Elfw9wL
	 6itwvyNSOHyLF0m89hwrOMeyU3V5T06EZv0vdIz+T6lxsDCqNL+frXU/sDzXIgDhUd
	 mkkjT/jDJwg2G9crHdHrHhTeZSH0l27Xpwuxl+7OaayCoPnVN5QK0Cx3OFu1TglsDa
	 gahkHk+7+tg3g==
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
Subject: [RFC PATCH v2 28/28] Docs/admin-guide/mm/damon/usage: update for memcg damon filter
Date: Tue, 12 May 2026 07:36:43 -0700
Message-ID: <20260512143645.113201-29-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512143645.113201-1-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7B67F4000B
X-Stat-Signature: h8jw43zn7gy7grhuup39o1t6313qj7ce
X-Rspam-User: 
X-HE-Tag: 1778596629-715845
X-HE-Meta: U2FsdGVkX18M0NpJ5ujqPI2VMJi4YNFZZIVrwTFMv3I9THDGXKJLW9MCgCWHVTW3Jk84gXRnP0nIwzjmKK07eyxuYMPRAa47Hx3PZ+yF4SeyoPCQzEE1zDUrDCDk3djuPppt4AKmxIl8jgkm/9WbCIHUpR9l0YQJB9DSIzoQeEInkgAkmNeF9QQQ9K4CEZqUAnY6+SSe484BsCYzIJmsLuLJpzLiuAFxsZfzgEY8w1y1VF8DUzpM2+V+0n6glgc0VtWuaxco22+641D8o//Ncv5ynHPzj96V5vx3y9JmsVarKI6XK3iBmLJ2UDWhy9EDZ1QJ+T2fzNJAvTyxv7nfHnxILeduZzC2WHxoOHP+Xc8RBpIh9Hey4rVzT5SKjE47useuA1oW6NrfwLPdTC5i4lDHNZOwTJm0S3+uD7p/ZIqthCoBL84Y80Ia+IJ4+7QS/whudHXRAcsomV3Fqf2fFmO0z5k8Ci28RyxbbEdsfBGRs+pQH4RwIC21YeYWSkdkbrs2t3J1a7npn/0jAQ06StLnVvzLQ4cg+4/pNfEdipcCA93SElcSaWHipgn3EbOGAR8lxIQUULOGaPDSOa/jrcHCnNXzIirWJEtPuQrZajEvHHpE8osUbC2tKlPi+UrlPf8RQ5Pu4NQoDeheKGd6qRZDU9r1swt3mq8cJz2q2N+C+7/YymkiWubpOzVGUvwAntdfARMHrwB2FNCBaWTi4lUVOTkOYRz/b8vdT88MF42h5AAzESSSyxUG9vsS/Yy4NKX+c6AVsGVDdjGqibhkkaOF1bTR4gc4p4MjWFU+EJAOkupMJCmg8nPkIyuFMcVS2YJVzGEBB1llQ8FyobnIS/h/HTtRTljjWEniOINUoFVrbyEtJb2iai4ANKmwZZsYZsxx+XTIvENnGRkhzQTkZJtx4XJoN3BgVj02ssJzNS9Je3UOF76CyCL5gRWXthThtFaVHLFOqP3U6BFkxLA
 xYR0sHP8
 4ANEhvo7882v132ppzB8fVlpo5Swiv3IyJC3Tg1r5Do+4TO02ebUtw+fL01+MCqOFl3oSXHilAbQ9sLfExIDdN3ViO7ANZsMdJLqfXU3r1y+lt9p2bamaMN4jGCV5Bp9lVcd4BKgV4XKiHa7y63DuKKmMFrAvDEGjXUaJPEASec8IlDBJNwzee0XmcaLAseSyTWWRz/jzqboiqs8IVNPLsNfD8BTQlKZo3wc/NBl6h6uKbN67PdU7M1zIWMKqXZXAmuilTB35YdavyNeTLBvXw4CWAVByi/82O+OYfcck3uywKVvE2UG/FEFbww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the newly added belonging memory cgroup
attribute monitoring feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 465bcdf89b182..84741b4cd1877 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -74,7 +74,7 @@ comma (",").
     │ │ │ │ │ │ nr_regions/min,max
     │ │ │ │ │ │ :ref:`probes <damon_usage_sysfs_probes>`/nr_probes
     │ │ │ │ │ │ │ 0/filters/nr_filters
-    │ │ │ │ │ │ │ │ │ 0/type,matching,allow
+    │ │ │ │ │ │ │ │ │ 0/type,matching,allow,path
     │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
@@ -289,7 +289,9 @@ the data attribute for the probe.
 In the beginning, ``filters`` directory has only one file, ``nr_filters``.
 Writing a number (``N``) to the file creates the number of child directories
 named ``0`` to ``N-1``.  Each directory represents each filter and work in a
-way similar to that for :ref:`DAMOS filter <sysfs_filters>`.
+way similar to that for :ref:`DAMOS filter <sysfs_filters>`.  When the filter
+``type`` is ``memcg``, ``path`` file works the role of ``memcg_path`` for
+:ref:`DAMOS filter <sysfs_filters>`.
 
 .. _sysfs_targets:
 
-- 
2.47.3

