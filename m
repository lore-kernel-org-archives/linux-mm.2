Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19DF5F3026D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 16:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E8776B0099; Sun, 15 Mar 2026 12:29:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 396D36B009D; Sun, 15 Mar 2026 12:29:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 299276B009E; Sun, 15 Mar 2026 12:29:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 179BF6B0099
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 12:29:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A0F365CCFE
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 16:29:58 +0000 (UTC)
X-FDA: 84548834076.30.CBE326F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 090FDA0002
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 16:29:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aKnWgzUV;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773592196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=70NgK4TaawQ7NPER8ohty9fo03jAkhNk4bTpT/dayxc=;
	b=E1tRYbQorYrDJjEnhwZsc7rfvWYDmusZGhoNvhNqqYriceBTf1VSlCk4PZN/mg44imeEGL
	vjVfx9/TPYeBQZQJJhq5DVL1Bcr/cWMXGBuqMqAT9JcXTAMsba50zKAg+rK24y+tHKcPYP
	u2oRScTPgRUOzu3ca9/4jH5uPV60M0E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aKnWgzUV;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773592196; a=rsa-sha256;
	cv=none;
	b=a9E8ztAqLSyIINeyPHSvyCZEP0OVUvbtjxmj0S/PI2yXZTrrYkSXF4pxkYp9eykdxb0+Fx
	ZltPQIEaNOyUXWlhpla2FjLjaokJrVbyrEcNSWnGN5iGzMN7MDPUqOC8+McLFWrhqHRQDM
	trcGs3CiKhbpvRvD5bp3TdOncsxub8c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FEA14067B;
	Sun, 15 Mar 2026 16:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E74C4CEF7;
	Sun, 15 Mar 2026 16:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773592195;
	bh=He08VfqZZvy0NJ509H07nj7EMEVUJY5kq1pTp0TKxWA=;
	h=From:To:Cc:Subject:Date:From;
	b=aKnWgzUV17mDG+vFpiOFZ65eycBdJF5NNE+shq3yAFhbHt8ZEjn7kjA0Px4mpBDtg
	 0qjfRv6u93OiWE3Zoi/TF6/q4VrccEp/6sWNKFqx4+mXvSp9K4h6OuOWgXm2iEmhCr
	 G2s17qR0f40sP0541owodaqkDPxKVVXKjziWwTM1KKaPQ2Y+gYb9jlfT5/Z1y4ot7m
	 ZsgBv6SKSQhAkTjgvgdH+atfi59phLmudaP+1nFuXGI8W9g6nfv6pUVMkeGUpBsR4w
	 AlqGwhiFrQEFrZio1LKNvkaWeLtTKIzr3NLJbsDkK1YLg/12/6IkWWIutuN6eNKgF6
	 EKRAmXmDhgmZg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	SeongJae Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2] Docs/mm/damon: document exclusivity of special-purpose modules
Date: Sun, 15 Mar 2026 09:29:44 -0700
Message-ID: <20260315162945.80994-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 31qx9fctwtaya4yen9iooanhmft1gro7
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 090FDA0002
X-HE-Tag: 1773592195-830545
X-HE-Meta: U2FsdGVkX19gqquh/BX4C9gyi9PnOzT5BQwMUVMYi7g0XFUOzFpsz0iWn390ADHkTiTfBJU9p7ruFYayzIv/jpY+lOZmPTlioKkUl9j7Ij5xxZ+CqqH1iJJZxjeipk5ZcTIMLoTY9WzEX5sM2E7Z7Kq48OoO55/RDwSSi0JKQN5ckBxHyqunr9Si6i3XYGvA7Nyh8982lqeTq+jlgbtSv72S61gtGLnTDTXZq3rgzQZ5M5Wd5Kppv+O6UrsgCYzg7i1vOccu7ql4AQBDi81NeUQt6B3K9vLiQ03kDFjvAKiA94Z462qgcTDM30dRelrp8XDZSI+Yrousywx7l5xLZh3WN7RLUpRwNjKE2Ykt33e9eSI+HhlPnE5/0M/dlkmxtfpuXrKbTZStr6NctapJR775hrQLXwZ4LFRYF6fPqRcIaRCe7XjXyb2uDQGV9LWbWFSsON2JOW3OJK/riL5LNt6TRuqTWM5H9uqt0szczYwmZJfqzpfBdLoHNN/vLwiOqEqXC7wOrZU3Br7jbGWV2cSkKrwiuxYSzI8aZ2o98ZBScnhceSJQvfvso703M1eRHYPGiwIZmcziOpmv+eNDsCEy+7uWJGy0GwKTJez19drC9fJ6z9V9kDMAAH7wDez3hfoQJ25Rbk8PDFncmsV51WtfJ1DSlnETJEGzu/yry5lyeHmrNQgkK1/kC6AC+x4iCD+7XwtV+FHwF6/UIxtaEsVMWEM2WRKGxQKTmSxsOlBpI5HGlejJFE3whGyZQ8rgY1XjRNfYqUEU3LOEqTGjoxzYanixGb+NaikHALBmiSovHcLtugzLZWzun1lZ4ywzusNrs6nwJCcS83Ax+qSE1RTasv0oiAiyU+XE2E4fZDBWhIx7R0jYF4lOxoSoMhEUFvdmD7nly9DFqMPxNnjEcnOghoYc6szXkH8V4yiASmp0tZuOegPjVKgIpUnE1TdM6RaiiNbhQgv3yTV1xLN
 Uvu4EKK1
 8RU/4KoXqdjrXQdrjStMXktVZUL3Fo7tBQzfRNEvOK1D54M2gJk/EHWHaYIg+hqRXg5KkyQUCl1D5vSpDn+AKSw7V3ySSocf5t89+Rbc+FnvJ9T0aoxGpAqzV34CcdBiemXJVPCehZdYkJ3Ovj7SKLAbQ6hC2hvnV1MkEBtibeyvp6yte5T+9ZtUker8QxTk0cjNUXMBdkecpDd4Y0CFUFug1bty0tlvg+n+QKv1IXtXSOjm2diqbIzbOILd/XfYn7S+NB9RgY8fGCAarc4pviTYbL5+ZEdZF1QnaRLG63/a9eTTkkU03sWNgsSkfHRRoaPM6oVfi+gQLZ6wJAGoDdaT7ImFjHPDloHQ4KjUBg5KHq+F3nquhKVnb/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Liew Rui Yan <aethernet65535@gmail.com>

Add a section in design.rst to explain that DAMON special-purpose kernel
modules (LRU_SORT, RECLAIM, STAT) run in an exclusive manner and return
-EBUSY if another is already running.

Update lru_sort.rst, reclaim.rst and stat.rst by adding cross-references
to this exclusivity rule at the end of their respective Example
sections.

This change is motivated from another discussion [1].

[1] https://lore.kernel.org/damon/20260314002119.79742-1-sj@kernel.org/T/#t


Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Change from v1
(https://lore.kernel.org/20260314092145.7496-1-aethernet65535@gmail.com)
- Drop contents directive fix
- Reword description

 Documentation/admin-guide/mm/damon/lru_sort.rst | 5 +++++
 Documentation/admin-guide/mm/damon/reclaim.rst  | 5 +++++
 Documentation/admin-guide/mm/damon/stat.rst     | 5 +++++
 Documentation/mm/damon/design.rst               | 4 ++++
 4 files changed, 19 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
index 73980bacc3a02..56690646cf398 100644
--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -351,3 +351,8 @@ the LRU-list based page granularity reclamation. ::
     # echo 400 > wmarks_mid
     # echo 200 > wmarks_low
     # echo Y > enabled
+
+Note that this module (damon_lru_sort) cannot run simultaneously with other
+DAMON-based special-purpose modules.  Refer to :ref:`DAMON design special
+purpose modules exclusivity <damon_design_special_purpose_modules_exclusivity>`
+for more details.
diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
index 552a7786b0829..6f580f637134a 100644
--- a/Documentation/admin-guide/mm/damon/reclaim.rst
+++ b/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -318,6 +318,11 @@ granularity reclamation. ::
     # echo 200 > wmarks_low
     # echo Y > enabled
 
+Note that this module (damon_reclaim) cannot run simultaneously with other
+DAMON-based special-purpose modules.  Refer to :ref:`DAMON design special
+purpose modules exclusivity <damon_design_special_purpose_modules_exclusivity>`
+for more details.
+
 .. [1] https://research.google/pubs/pub48551/
 .. [2] https://lwn.net/Articles/787611/
 .. [3] Documentation/mm/free_page_reporting.rst
diff --git a/Documentation/admin-guide/mm/damon/stat.rst b/Documentation/admin-guide/mm/damon/stat.rst
index e5a5a2c4f803a..c4b14daeb2dd6 100644
--- a/Documentation/admin-guide/mm/damon/stat.rst
+++ b/Documentation/admin-guide/mm/damon/stat.rst
@@ -45,6 +45,11 @@ You can enable DAMON_STAT by setting the value of this parameter as ``Y``.
 Setting it as ``N`` disables DAMON_STAT.  The default value is set by
 ``CONFIG_DAMON_STAT_ENABLED_DEFAULT`` build config option.
 
+Note that this module (damon_stat) cannot run simultaneously with other
+DAMON-based special-purpose modules.  Refer to :ref:`DAMON design special
+purpose modules exclusivity <damon_design_special_purpose_modules_exclusivity>`
+for more details.
+
 .. _damon_stat_aggr_interval_us:
 
 aggr_interval_us
diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 29fff20b3c2a9..dc37402c0fee9 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -853,6 +853,10 @@ more detail, please read the usage documents for those
 (:doc:`/admin-guide/mm/damon/stat`, :doc:`/admin-guide/mm/damon/reclaim` and
 :doc:`/admin-guide/mm/damon/lru_sort`).
 
+.. _damon_design_special_purpose_modules_exclusivity:
+
+Note that these modules currently run in an exclusive manner.  If one of those
+is already running, others will return ``-EBUSY`` upon start requests.
 
 Sample DAMON Modules
 --------------------

base-commit: 1e6fb24fdfceeb8dfa1a97a0270e4aeffa0a6d6d
-- 
2.47.3

