Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C223CCD1AB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 01:25:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC9558E0019; Wed, 22 Oct 2025 21:25:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA0A28E0012; Wed, 22 Oct 2025 21:25:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8D448E0019; Wed, 22 Oct 2025 21:25:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF58C8E0012
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:25:45 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6E07E5C0C2
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:25:45 +0000 (UTC)
X-FDA: 84027637050.05.2EC67AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id C972740009
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:25:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=seqwKdRe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761182743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LQMYvE6as9R4a1BCEXmA7WVN8zy9LN/s33NRm6Xgwqc=;
	b=kl8Wz75PHYZ2QHZL8UoWsDv+VJP93C06ikuxbIi4dF4t+3EFYjjPjVWc+mEzzbq9Ta9IRx
	o5t2tnM7civ7/pTGSW9w/dq4Rgex6m2pvKCHLY0McK0OpqKG64hlMOO1kwp4Cjx1uALpUJ
	wAZYPmsWE34U7u3AVBjuTZenYtOmb9M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=seqwKdRe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761182743; a=rsa-sha256;
	cv=none;
	b=xBAPJyuqB8Co2PQUDZCh8IkhgOqis51i/Veop3yD+71SJfpZaNuHNGBFE3ag9iavgU5b9m
	9YhcAfFsdu6G1LND3CwlhlyFYJGOEmhVI/jR6MmyhGLf3nT4zINH86D3bZh7uukGotNcEZ
	AN+fEqjWIZpd7ykRReZE77ZOJ4gLuyQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 35E3F6059C;
	Thu, 23 Oct 2025 01:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1143FC113D0;
	Thu, 23 Oct 2025 01:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761182743;
	bh=65cmnk/bFjxYU2YnQodxix5UeST3Nn+DSFfFevM1UkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=seqwKdReZCx9ewGiYXyBY16OiRVxGlN2qhItsNVN4JGIPSx1mSoELriFDcSPxD3MU
	 YJY2WnBCX7OKgsHEMtLs0tvjcteOHiNHrQAq9U3lEwN1Mou5+mU49PsBpejBzl0LhX
	 Zo4gZHOUgWs3fqOsPEmm+gopm5CPAkb4RQFklQenHIM/9B9LY75GOXxG9MzT7ZmYq+
	 g0AgIZOD1TYgBA2FKncrLq/5TUmGg+sRDsJjiISybVWdO0i4Qq8yFXD3W9/zMXOJFb
	 /KevEqQqle25SCJNQt5iDRo8kXVa3kTwLkHvEu3O5Hyqf0UUMh7cecWR8kpWUmgyy4
	 nQgPTEbp0olWw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Bijan Tabatabai <bijan311@gmail.com>,
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
Subject: [PATCH 4/9] Docs/admin-guide/mm/damon/usage: document obsolete_target file
Date: Wed, 22 Oct 2025 18:25:28 -0700
Message-ID: <20251023012535.69625-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251023012535.69625-1-sj@kernel.org>
References: <20251023012535.69625-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C972740009
X-Rspamd-Server: rspam03
X-Stat-Signature: bm7ub6377jfibiyems5nabphzcmmeqhe
X-HE-Tag: 1761182743-21606
X-HE-Meta: U2FsdGVkX1/3PHV1IkpTavmJcJGKAjh+L3TNk0SCvI1g8hanjWOty9XQmfZM+ZNAi5UPPYFKTP0QKephOITe4Eyiw9ZkUSTAqfxTw8edcEmwblucA2vDEew9Xa2DEjMcrR4jgnZtrrDDuxQcw0Klfp1EMTxCsf+NEvzo82tuJSJf1lNw8S+pS9FRAPTVRpOrGC3YMfmnrUtROz/3o+OzlD1ORq/5atShUdc4NdCpPTtAesSuh6lARTdhJi36fSr9wXdptLs5WO5/2IllXT3VH30aqz4tIocJ8I5Dq6O2Nnu6zXOostaO4Bxp2pDmUyPGGZTKAIjEAMFtROV2bInh7DslBMYTB/halxe/ofZEEjgIaNw6iy56e0S3CQgQ0gbLkWELReBlkH4Xpi5PQgGFEEbANX6bBy3IlwwjIyl4C+MTKW0unIAq3JDYF966bY165LpZ4jK+L7qFALobAnaiFl+P/0mPnVYkZVN0O6wXW+FOaLRQBr+5cVQfGVYakutUCAuopiokVs9A+OLufqFuflzKaSjltueEwe0LlKDhc+cDVHF5u3Uglv0ho7jPe/hMlvCI56B7YPy8J4inUUBOUxvYUKTotIOdbGpsimh+rMepSso9ssRltPHUwMnY2Q4yz+QI4AjGe5CSC67KpEvfdP0GVaqT9ZscV+f59sPQnxHo6IlRDVuOoPQWJk8MmRQxK/5BZSeMGAwKZGuE+mYKVg5WLZ43lrJcQ0sJNZzWd/d6KPyj1lcLtJ5j5iDbf7ZgibmUqH4Rq6sfP4AzD2HxSuGZuD+dyxkkMg+iFp61dTXq7Di2bTTXw7VWoa0tjDUIyAT4QCrPxL0V+88i4qEDZFNaaZ1UXmstn0+xnQurhfsun2NI22g3/KtmhEpZc7CXTZX7Azeapny2CyVJxDwx5B5UnK7Nq18tUdh04bUCMtPBgjhUUIoQcNSwMgpYhNwekwcA56sOvUJklPu0V5L
 QHEOzSVN
 NouIUlOclTtN2bOuYEL1ir41KdOz5zYF7dZ7CPE+fvbud4tHPIeWkzqItebhHCnpWyoYRoxatpZ7zopnAnKS4OgvEzxxUhbU386+PapNkw7xFnY3kaolVXQMP1nKhWwihukXuNgEgDrQrWDzi4ri2LuCBfgbE34wt482sFNxX6Mb5CoeUHWm+oAcM7OMicky/WD0vbPOnQbIq6AqXz3V+W9kofLpkDhDWfTRGFOgU+oOS8NwS/55gW1d3mVbb1MSktsvemrvgmwFVg3FBtva7k505ng9vc9lMRATJiJzFT4YBlser8+TFfVfjPFEOk54vigrp3vtW0awirgXWzusuJVC06g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document the newly added obsolete_target DAMON sysfs file.

Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Bijan Tabatabai <bijan311@gmail.com>
---
 Documentation/admin-guide/mm/damon/usage.rst | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 98958975604d..d8a3d6e740b3 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -67,7 +67,7 @@ comma (",").
     │ │ │ │ │ │ │ intervals_goal/access_bp,aggrs,min_sample_us,max_sample_us
     │ │ │ │ │ │ nr_regions/min,max
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
-    │ │ │ │ │ │ :ref:`0 <sysfs_target>`/pid_target
+    │ │ │ │ │ │ :ref:`0 <sysfs_target>`/pid_target,obsolete_target
     │ │ │ │ │ │ │ :ref:`regions <sysfs_regions>`/nr_regions
     │ │ │ │ │ │ │ │ :ref:`0 <sysfs_region>`/start,end
     │ │ │ │ │ │ │ │ ...
@@ -264,13 +264,20 @@ to ``N-1``.  Each directory represents each monitoring target.
 targets/<N>/
 ------------
 
-In each target directory, one file (``pid_target``) and one directory
-(``regions``) exist.
+In each target directory, two files (``pid_target`` and ``obsolete_target``)
+and one directory (``regions``) exist.
 
 If you wrote ``vaddr`` to the ``contexts/<N>/operations``, each target should
 be a process.  You can specify the process to DAMON by writing the pid of the
 process to the ``pid_target`` file.
 
+Users can selectively remove targets in the middle of the targets array by
+writing non-zero value to ``obsolete_target`` file and committing it (writing
+``commit`` to ``state`` file).  DAMON will remove the matching targets from its
+internal targets array.  Users are responsible to construct target directories
+again, so that those correctly represent the changed internal targets array.
+
+
 .. _sysfs_regions:
 
 targets/<N>/regions
-- 
2.47.3

