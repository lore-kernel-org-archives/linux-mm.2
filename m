Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 945DCD58CBF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:15:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 905CA6B0096; Mon, 23 Mar 2026 19:15:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81D586B0095; Mon, 23 Mar 2026 19:15:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66F1E6B0098; Mon, 23 Mar 2026 19:15:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 49C136B0095
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:15:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 17DFB1F06A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:15:47 +0000 (UTC)
X-FDA: 84578887134.04.EED4913
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2C66080010
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:15:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nA2KuA96;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774307745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CtSrqktECVSRTbIOnfAhYjfcjrVe2WKXIwFaQDv8qqc=;
	b=2K3H3gh3107Pyve2llLRNZsxqDJjX7sXhlNcjJR8jJLmxIOUdyQmgrvYbEYdXXNaTiPZw0
	mQVnAu5whKWC7BJsA9s8y4lE1wQY3rXqIqhm59lj6fE7ll8id0Mqh9iY8PKh6JSD2ZD1jm
	hAEIKL17XTQAg6O1C+2hOzIjTwE0T4w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nA2KuA96;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774307745; a=rsa-sha256;
	cv=none;
	b=BnBGTGCgwZoSupSFiM/TKNZq0meXeEkkGaJWx8eCeopRbDQoNixE289jNAlAK9KqwFqmBV
	eIqxmQJ96ljJF230IBpkYKfDgO23BJnvx4xFzb+0xKp+nb3ZFDhJ/kC+mknHj9yf3DxguZ
	BHLH2ubpQUgI3roXpsU62EqB70ys2AE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1905F40782;
	Mon, 23 Mar 2026 23:15:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82478C2BCB1;
	Mon, 23 Mar 2026 23:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774307743;
	bh=O8n0uNGYuU+EcM7S/clzxsj2TzvWbNFjQtjX/Z2/CrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nA2KuA96J94NIVA2IAWwHQY1pV5olXSCsVBQtnd3ASc3fu/I9TZN4Nh8tt8Hd5Wl/
	 /z/JHKQzPcqbLE+RdgtksRWES7360W7qmfC1u8UD2U7mhzoihsY5ZT8S9wu9VCpdg1
	 HIP7C54R+Q1D6UmP1jPH/3/GRhnu7MnNqCiaaeMKCnb0cujKqnyWwLM4de4gTyFqSq
	 n2zGC1LGWSx/MV+LAVHxEzIDRF9LYLHPNf5aepIxW/F7AcZJZHJkx4P0MudnvN5OAU
	 ERvntDgA2bZ2iCYwv82Fci5x13zhNnANmwSNyElCFmWH8OXl75jIZcEnXv3l2IIlyN
	 8ZXHhi+u8RaMA==
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
Subject: [RFC PATCH v5 04/10] Docs/admin-guide/mm/damon/usage: update for pause file
Date: Mon, 23 Mar 2026 16:15:29 -0700
Message-ID: <20260323231538.84452-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260323231538.84452-1-sj@kernel.org>
References: <20260323231538.84452-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2C66080010
X-Stat-Signature: kkdkc317p4n9r61489rk7k4eaqwm9piu
X-Rspam-User: 
X-HE-Tag: 1774307745-314093
X-HE-Meta: U2FsdGVkX1/NCCVS/HPaJqief0ftz6/sSkurCqohNzbck4DTBTYYKqvbb+XsE6ZUvMLSQx8ZxpdDTGBPAKLKC4DsnzOWeyXwehmbLJFr4z0IHYWQZbkJl09d2/V6XSTHs/3bbUt3uRLXRrpqI8Yu9d79/atGk/9NEFNlstKfnkYr0MNkucQbs8ZzP4lNt9rG1ikUJbxscjSxbfQTX7m51Kn07MPkHEZ6vm2/+6NrlFHljXFzZ5315dRL9EucxnP2fTx4d5F6G/LUVOEE0fS/rH8ODQ9UQ9fglmeWTwRzYQVNXF7G5ey/Te6049lK8EuWhkPfqTOHoqOVBcgGxfvQyIwjHsGtWyStlGgmnKHfbx3TMgGt/cFC1rS62z4s50NLiGpQEojBp4SnfmXhShQ0rzFlZCrHP4vhG6lgWXNQ/nux6Ts7xx+AJQNQPpx9RIg2XRK0ZfUFqq0qPVrm0rAbe1eMpHcUxdzGC1WLamaZpSLzcFs5WgEbo5UZYTmnznF31Cto3XSrUpIkSkgZshKdklZdBFgMIPN14JvWIRCesSN0ffxMGEyXvhlrP8/Pljns9u9cQkoxAafVm1tPyR9d3C1co47RlRfz3IFLM0SfuR6XL6MY1X2N+AwSgQuCNYH6zYDQSgGMfHK8zWgIqvYB/J6zE/Xc7LOew6kiq1OCQOZJldhE+hTz2GCrf9GvIES7teMpmvhJPSX6HgruVLDm2EusPV9jSvW5jw+NC12FDdUcY+Gx/1FuX8+P6Vgz8Xs7KhESgl2dNoiDzvzJr6Pzz64vmeWSyvqQK7fQO2jeP6BsYy371Aq6OJRJLNAY7vpuQhtLkh0s9x/H2hroNoBthdUIilR8Nk5UdnbChm5H/v+rvPgme1MhssjnOtVlqAuHF4HG3YZAOg6UVZobRS/+yQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the DAMON context execution pause/resume
feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 534e1199cf091..bfdb717441f05 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -66,7 +66,8 @@ comma (",").
     │ :ref:`kdamonds <sysfs_kdamonds>`/nr_kdamonds
     │ │ :ref:`0 <sysfs_kdamond>`/state,pid,refresh_ms
     │ │ │ :ref:`contexts <sysfs_contexts>`/nr_contexts
-    │ │ │ │ :ref:`0 <sysfs_context>`/avail_operations,operations,addr_unit
+    │ │ │ │ :ref:`0 <sysfs_context>`/avail_operations,operations,addr_unit,
+    │ │ │ │   pause
     │ │ │ │ │ :ref:`monitoring_attrs <sysfs_monitoring_attrs>`/
     │ │ │ │ │ │ intervals/sample_us,aggr_us,update_us
     │ │ │ │ │ │ │ intervals_goal/access_bp,aggrs,min_sample_us,max_sample_us
@@ -194,9 +195,9 @@ details).  At the moment, only one context per kdamond is supported, so only
 contexts/<N>/
 -------------
 
-In each context directory, three files (``avail_operations``, ``operations``
-and ``addr_unit``) and three directories (``monitoring_attrs``, ``targets``,
-and ``schemes``) exist.
+In each context directory, four files (``avail_operations``, ``operations``,
+``addr_unit`` and ``pause``) and three directories (``monitoring_attrs``,
+``targets``, and ``schemes``) exist.
 
 DAMON supports multiple types of :ref:`monitoring operations
 <damon_design_configurable_operations_set>`, including those for virtual address
@@ -214,6 +215,9 @@ reading from the ``operations`` file.
 ``addr_unit`` file is for setting and getting the :ref:`address unit
 <damon_design_addr_unit>` parameter of the operations set.
 
+``pause`` file is for setting and getting the :ref:`pause request
+<damon_design_execution_model_and_data_structures>` parameter of the context.
+
 .. _sysfs_monitoring_attrs:
 
 contexts/<N>/monitoring_attrs/
-- 
2.47.3

