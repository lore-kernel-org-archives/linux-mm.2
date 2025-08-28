Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55F82C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 17:13:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5599C8E0033; Thu, 28 Aug 2025 13:12:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5096F8E0032; Thu, 28 Aug 2025 13:12:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 447D88E0033; Thu, 28 Aug 2025 13:12:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 236C98E0032
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:12:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F028E118999
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:12:58 +0000 (UTC)
X-FDA: 83826811236.24.A8C7776
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 35C83140002
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:12:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N5tsV3mk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756401177; a=rsa-sha256;
	cv=none;
	b=WSFKfzTkMzomi1r/Ne2chZwuemmxmK5dA275zVfIo0dCR0iSHnKwYw7k2exCwrm07b0Nsw
	Ly7DKUhGmfMfjJ4+RVyc4T2/Pe/kq2mz9+/y/jXC/yoGL41juRDoVwrfB4eEBnPnpoeiJF
	PM3hKWUUZT+jdpR2QNwJ1aTvt0s8csU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N5tsV3mk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756401177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KgMu12DcwHxpYA7igVehYj3xqSUjJgYYuEFxVMJPGzk=;
	b=MjRAYxmp5Ux55LeqwAetnwS37gAL11znZmBHjy+klRYobLDBcZVSQ25jiy1pUOGoLHNvRY
	H0DcmOW2zJlqnDaMwb0Ilr+iUIqItSEm7Ii/GFt7gHu7yIb8d97f2yElWyWAj6It3NM4Nt
	vaM4XoQGY/u1C4fu8cc7EHHZlpxM4GY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E1BC244C9F;
	Thu, 28 Aug 2025 17:12:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2137C4CEEB;
	Thu, 28 Aug 2025 17:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756401176;
	bh=0Tkh1C5fVDsNJAaGdZ/ykVNygO2LzvBdvdS278GzHlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N5tsV3mkCxzm9wNYzTMsleBT4pfBcY1lGcxcHxyZDTph4Fji+D8KxPLH2THg6LWGp
	 oc71BnlefpsViutlRPsLpDqVe4hcQNzRMcN4HYGUIW3zP/D1GjWngcP98T+323RCSJ
	 eOIY27TnIRZOzdxA8TJbYyDNf6DgQhxYqdxPCZ35Uu2jNZzAUzf3Vk6xv5LRg4kMoO
	 DIk/hFw0ni3WSvpoOrOHcg8EdWFoj4rD0rjNP3kJa6wYeP7ovxhSizXt+yMAkhontp
	 rP19fjSnVm+7/t5/b81sQKhqQuOI5AfLUMHpxyvmlLlzifgFzTzOSLmtTkFk1qoLwq
	 2m5ecHpMuEgTw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: [PATCH v3 09/11] Docs/admin-guide/mm/damon/usage: document addr_unit file
Date: Thu, 28 Aug 2025 10:12:40 -0700
Message-Id: <20250828171242.59810-10-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250828171242.59810-1-sj@kernel.org>
References: <20250828171242.59810-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 35C83140002
X-Stat-Signature: dcf7jrr8rimnbetiwyquzibpymtra1jh
X-HE-Tag: 1756401177-189219
X-HE-Meta: U2FsdGVkX18AYfOy2XQmdmBvXhNFEXb7z17Uzj1oiUyUPB+JDBXoaTY/y8fSemWS6J5g5UQtNsoW/8dlPeU3XfiiVJJy1AD86wWTQYdfJcjs5DEIB0mmVuK59aPRB0n2HgX6+xsHA8glwL2l4Zc/ci/MEgvgyAQT4JRqPT8s8/EHVHirFJBDqwq96MVOnW3BloVRzUdq1d573YaklgaydQoJhEmRfi9ODPA/VSeDB7Bdf9NxbSCJYRO4w7JYAmWKwXTHHrbbdGbqHxBFBQWXGyoekdi3o72aGE2D/scUysq6AR/XIroLQT2xQH2kxlyh/W+Dpocn8sWfJGi1/3etKX9bcp1gUDp8E/+Ffnwse7u8w8ydrFOaRnMTlRbgJwB/6rL2XsJKJwDYGgHIhVum4KF9V+HdJlUtlwb5JmhPS1g+DsFKR/JKUWeHjCQPMCwTUW/1NSOXZs9HfjsWvBVViyP/sdaKQaqqcq+5xfstdBTtzYeEcgqYk+4Y9BXrtqY78gkTwu49on45yu6TueiWjKaqU6a7aTiX8VZZZ7Q9u1feMylS9vA2uIl5uhLLLavguKP9rTTTZWLiVMecy3SJ/sX8H2EYNInZOrayYJQoGB0vNGS4h+I2MC3VtiYC17l9Efn+rCx11Nfy7oRFGUoCA6Xv5vez0neFaa7cDaTMJenBrfC1P7p0baZc+ofXLqMY/+tPg7vUDABJI1G2kJeuvh0lZ3L1XqwmNM31TUs6COwUnM4ofQjqdN6p4s5CfPLg6WV8c82mehKXjhxGVBCKM/xldsT1O8C+0HcdXoFBUJwghQKoRAgOkt3WpfAjgWuuDE+QIMxBCNQpVWaNMpUsuvt1SJ+GZ1OnOYtRnRPStp59yb6h1p5rxvf1E2f0zZguErR7TAIrj0Rr/+NE9IBs7QzN4rWgfysJIwMkkTeqHdGjdtQS49yKlHivX7Q8mPKN6XoOd3gxYKwiqE3PWHJ
 PAxVuUaD
 lhQIho34PN3f+RHa2nCLmp2moOkfMQ3zbffSutrwu8QGZ0Fb/7hOHmpNd9OJBGgAjOHekQWQnmkYL39mSnfxtgtZ14gaCfprcJYK43liHk7qJdgNAVWtPmPws9xUcmW1qZDcv3eoAhY5TwDzpIqV6d25bwgAFfZE6dVI2R2+IWfZnBvAJQu/1DhxhuLX7Ci8Oc9amHn5PDdgi7zPcug30Q6YZ7IAYzwHqNTE303hpkjOz+nfcJQBdvzz9XSHE+jLqOedpFORDMJXrE+WVwVLTueEJ0lQcG2oNQ8wdkpl66yjlAm7XiAwq6un4d+e+O9H3n5pvaSdgnBbmSynmdGWU0KBlaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document addr_unit DAMON sysfs file on DAMON usage document.

Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 11 +++++++----
 Documentation/mm/damon/design.rst            |  2 ++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index ff3a2dda1f02..2cae60b6f3ca 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -61,7 +61,7 @@ comma (",").
     │ :ref:`kdamonds <sysfs_kdamonds>`/nr_kdamonds
     │ │ :ref:`0 <sysfs_kdamond>`/state,pid,refresh_ms
     │ │ │ :ref:`contexts <sysfs_contexts>`/nr_contexts
-    │ │ │ │ :ref:`0 <sysfs_context>`/avail_operations,operations
+    │ │ │ │ :ref:`0 <sysfs_context>`/avail_operations,operations,addr_unit
     │ │ │ │ │ :ref:`monitoring_attrs <sysfs_monitoring_attrs>`/
     │ │ │ │ │ │ intervals/sample_us,aggr_us,update_us
     │ │ │ │ │ │ │ intervals_goal/access_bp,aggrs,min_sample_us,max_sample_us
@@ -188,9 +188,9 @@ details).  At the moment, only one context per kdamond is supported, so only
 contexts/<N>/
 -------------
 
-In each context directory, two files (``avail_operations`` and ``operations``)
-and three directories (``monitoring_attrs``, ``targets``, and ``schemes``)
-exist.
+In each context directory, three files (``avail_operations``, ``operations``
+and ``addr_unit``) and three directories (``monitoring_attrs``, ``targets``,
+and ``schemes``) exist.
 
 DAMON supports multiple types of :ref:`monitoring operations
 <damon_design_configurable_operations_set>`, including those for virtual address
@@ -205,6 +205,9 @@ You can set and get what type of monitoring operations DAMON will use for the
 context by writing one of the keywords listed in ``avail_operations`` file and
 reading from the ``operations`` file.
 
+``addr_unit`` file is for setting and getting the :ref:`address unit
+<damon_design_addr_unit>` parameter of the operations set.
+
 .. _sysfs_monitoring_attrs:
 
 contexts/<N>/monitoring_attrs/
diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index d9d5baa1ec87..80354f4f42ba 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -135,6 +135,8 @@ the interference is the responsibility of sysadmins.  However, it solves the
 conflict with the reclaim logic using ``PG_idle`` and ``PG_young`` page flags,
 as Idle page tracking does.
 
+.. _damon_design_addr_unit:
+
 Address Unit
 ------------
 
-- 
2.39.5

