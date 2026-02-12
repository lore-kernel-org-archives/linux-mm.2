Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FFF3EDF04B
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 06:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E1CE6B0089; Thu, 12 Feb 2026 01:23:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87D166B0092; Thu, 12 Feb 2026 01:23:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73B996B0089; Thu, 12 Feb 2026 01:23:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3E40B6B008A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:23:31 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E8BAA8C3B7
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:23:30 +0000 (UTC)
X-FDA: 84434812980.24.149136C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6C6BFA0009
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:23:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oC+OHmvl;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770877409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KvLhfav98aoqe5tjE0VdTdt/h2RyfeLHM1de/x6+aCc=;
	b=cZ+PUpZV4s0HLCFNiZnR9t05Jm9cj50my0ltULtSr6uUrBnFTLY1s5JItQ4dSkYb8lMTMb
	815AYpFGd64EWQkw08FB+nw1JGs7xQDafBc98/iDwIKDHdIkqD0TNSv+PFRXXl5tPHOMPP
	UOTlP9yeM1VFwvdDwGAoEMYarP2vvfE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oC+OHmvl;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770877409; a=rsa-sha256;
	cv=none;
	b=pFOHOQox4etOplcRLImh9FOpLz51EgYYu3rVRTbIoNiSfcQtYeSQebszEsKlL1TCL451AA
	bf85TM08W0ia4O8p7q8WmRHstMBXGXPVHm0U1EMqQm6d1PSVCP45pvC+NMJbqWxFNL13AF
	LDDh97StlqNNtFfLZYxDL6XOc/Jk+nM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EDC1A600AA;
	Thu, 12 Feb 2026 06:23:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B2FC19425;
	Thu, 12 Feb 2026 06:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770877408;
	bh=GAZRnbykPH7suqW/p1IoZkedLjJYjMBqsndjLOFppz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oC+OHmvlIsLuQBDFuJTf1WEQZ2+T73xoCBHqM9yBl1BWk9WkqzD31TEh36iQQaLlQ
	 xUT06+w7g/gPnavr+zzH9zg+ikJnLdw5AL7WL0XLv7tEi1q/jaZF4pS2Pb5P/0Ahg6
	 ieipUMaR/SLwWF/EKz6hZa4MzMb10vk8maBVAHbDFFTQlcseiPpRtJS76qbzRqFCeC
	 WkRWGw00OdOTgdnz3jxLYBzdt95rOX8C7CJ6MIo/OPdg6odHy7V5cJlCvRLPKuRjQJ
	 kux6HqxX95Mx8H7IBN8CHqUJFqh55ye9ZxF5reGdzy9ks+i8ReXhs7hNA+nmPB23Jw
	 X1NAkx8wk4uFw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
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
Subject: [RFC PATCH 4/5] Docs/mm/damon/design: document the goal-based quota tuner selections
Date: Wed, 11 Feb 2026 22:23:11 -0800
Message-ID: <20260212062314.69961-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260212062314.69961-1-sj@kernel.org>
References: <20260212062314.69961-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tobexmcft1suurkknxyg9py93xhj4898
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6C6BFA0009
X-HE-Tag: 1770877409-906633
X-HE-Meta: U2FsdGVkX18UwBKsPKE/gTdXRNavdcQQLSgDwSbdnmRW4CLnni0dCg8bAtqwVFrr1Y19bvKxpdbDLNLSQYRV5RqwRFIoIV8oSt5bzoySRDG5JM0iHinVQqhbL4cFmeYnQVRgZZwB3NYybbJWQdd1ib09+tLm5JmpquH0GTe8fADiJPGPAsS8CKULuMpSV266xRgfmhkWS+EK8WjkrUOrmxHgmGkTM7ztgrveEzp9goLQba+CS64XSp0gU3UlS/1ug8Qc+bTJbjpJnh57wH1Pq/f+yjX9k15egj+s0MOf/1clQ6UMchCux48YdfEYB4xZflpAo6Bvy39QO4vbu8DeH6UZuba15st9f8hFe0M4IpZ6BdCLBkiY+xgZFbRsiQMEVWt62ZNT69YKYcyFZbMEwvkBcxAa+pSIlV/ZUVLztKE9B/oWYrKpUwG6OxGHMk2qxVKC2LhZNutW6pRjw56XmoNapIO3EZU4YcbNihn5dVE+k5QuQ8wX4+cfOfxpXkszHXOORfm8QFn2TbTWT3/QcwBbv5W2W8WBUC4UQQDfaQJrxDk3jNyh6v5CmV+g+F+gRo1JQA9p9yOnY14jDKJVpaORim4FrlFlcN01dELrCk6dar/eF0KyFHAHfEpCfIENQ3WnaeMG42tAquf3uRykH+AO2ASBZ1BF4NGSb752i4ZNuizas/cQDPZTVeX2SCG9Pp1kAgUjDHjE14uGDf9mAEuu+7em7HbooEQJHdDZiGp3q2Hl6+/s0yG/OQYATKwim5iwM4g8yQ5wLfIhHdKyTxqonssHdjNkyi/NuZjbPLjl+qqD0LVZHXeVtWXCAJDgqHiL/tv6PkpnTd1gICuOU3PwuQQKpFEHqT1BdPdU8RmetkYIhqR8s3oF1S5sLuQ0zKUTEDUNDGxgmLLUp1dFL1W4ayk/wJPozr/JhCV0bQTAzmnWfCi0ZboB6edBGQWloaQ2fwblliAvnyoa+dX
 3NUNC+tU
 12p7F5zyrsvNjzTodAN9dxME2qlX3IFq8QlBRajRWYZw8TjapY9NcoW9b3kAndTCyRNl3Q85YxjSFM6+ev1lIocaBDeyFSmF2OhyV2TiT7Lff7PKVqdFrJKG3hMKT/ItsKrjO4x8ZDYxgsAHHzCXAQ0KyWchRnsI254dqUFSK7G6rK7MqO7TZVQoJfYgkxL0vwu0/dZQcIquf+0Xr53/+p31ylInxaejspSb3pYKp4fk7Kjg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document the newly added goal-based quota tuner selection feature.
Provide the list of the available tuner with descriptions of their
behaviors and when those can be used.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index dd64f5d7f3193..28d932ceaf7ed 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -564,6 +564,18 @@ aggressiveness (the quota) of the corresponding scheme.  For example, if DAMOS
 is under achieving the goal, DAMOS automatically increases the quota.  If DAMOS
 is over achieving the goal, it decreases the quota.
 
+There are two such tuning algorithms that users can select as they need.
+
+- ``consist``: A proportional feedback loop based algorithm.  Tries to find an
+  optimum quota that should be consistently kept, to keep achieving the goal.
+  Useful for kernel-only operation on dynamic and long-running environments.
+  This is the default selection.  If unsure, use this.
+- ``temporal``: More straightforward algorithm.  Tries to achieve the goal as
+  fast as possible, using maximum allowed quota, but only for a temporal short
+  time.  When the quota is under-achieved, this algorithm keeps tuning quota to
+  a maximum allowed one.  Once the quota is [over]-achieved, this sets the
+  quota zero.  Useful for deterministic control required environments.
+
 The goal can be specified with five parameters, namely ``target_metric``,
 ``target_value``, ``current_value``, ``nid`` and ``path``.  The auto-tuning
 mechanism tries to make ``current_value`` of ``target_metric`` be same to
-- 
2.47.3

