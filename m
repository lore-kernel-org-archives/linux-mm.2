Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F07BF55102
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 19:54:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BB6A6B0099; Sat,  7 Mar 2026 14:54:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 378F66B009E; Sat,  7 Mar 2026 14:54:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11E706B0099; Sat,  7 Mar 2026 14:54:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C43686B009B
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 14:54:10 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9460F1A0135
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:54:10 +0000 (UTC)
X-FDA: 84520318260.11.E2C7BA1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2681F20005
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:54:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m2QCmobp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772913249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ZfEbY6j9WATZXdLNJL8PKYjp8xrErzk1kAJxqVP3Ag=;
	b=Mp/LLbFpasw/9Pz35GWqcLWUhpq+bINP2SDlZnuD8pRmb7TSCPnmBmhA211pZ7Xg1VXDOs
	BtVMZwOnjPsr0GWGwwlQ6U23NZYQ7lgxz0s2Mp0BhRTCsKlkAM+Fryoh9nuS0kxE+ZGtUx
	tlq4n6/zqwN+3/et+VrlV1y6REsL0+Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772913249; a=rsa-sha256;
	cv=none;
	b=rGSXrFlglNBhzUqEtRE6E6V4dKFt9HtnLWJ1AQLBbasi84fTGtP7JZZDS2+SOH31J41Fu1
	SpxfXoqkBemieO6HcaKG8IitmgqC51GBMFcY+upgY276UcXa/GHZoL3dcqBVAdT70gmddA
	YRAGOuYHMrwr2Ax2n9v2YOqx8zKyetg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m2QCmobp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B595060126;
	Sat,  7 Mar 2026 19:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B7BC2BC9E;
	Sat,  7 Mar 2026 19:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772913248;
	bh=gLiv+pNotyPVa+VV/9QXIoANdJw8lI0sD1zcvN05ExA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m2QCmobpyIIHTNmOdBlq/087P28EA10hWT0WVhLHTwQ+diKNGEGwjcBnW/xlDvg3X
	 xeQcSDw+fDTq5VDVDtT8/frS9C+p1jdjmBrfN7SuBNVSoCf7tfxN0yCoJ0NynEVTx2
	 5BGYOl0P0lxD/vOe1gxfWpHXO7uoeS+L2DTD8DukjshY0vJYqbY3DPBBuU/2GVDGSw
	 YNInUZn4JASMbrYuB1ucXx2lb2OdRhoabXpweEnxkRxJJ4yQNhUUoe17ZwuSXPZIOH
	 +TsEkO53u8XEPwuYiXu/XeV0UJI5ht/pChFzCFXYDOXEsdNcadhkxEP0fCdDBSOHpt
	 U+YkFFtTlyY7w==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
	linux-mm@kvack.org,
	wang lian <lianux.mm@gmail.com>
Subject: [PATCH 5/7] Docs/admin-guide/mm/damn/lru_sort: fix intervals autotune parameter name
Date: Sat,  7 Mar 2026 11:53:53 -0800
Message-ID: <20260307195356.203753-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260307195356.203753-1-sj@kernel.org>
References: <20260307195356.203753-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2681F20005
X-Stat-Signature: 8hdp3ozotpik4bs3x4rjj5dzw9p4jwgn
X-Rspam-User: 
X-HE-Tag: 1772913249-297467
X-HE-Meta: U2FsdGVkX18zu017+EegagD71uDF8Yp7b7PDhtHTSMMWfsmLsWJwWsNOEo1Uc8yALoyYP6+9+xwSycHfdXOJ1Srx8oB1TkmprANXbre324Dr1RIgZoffPj80Td5eCd3hAIMk/GISMgJ/3D8xxRDgpFDLE5jzTykXT30p77rtykjOrUgUfayfrskv3eznwVgHusM/H9c2RSbSBe57KX/WL8wpADsXJT0QtkrLef2URI//p7lD1Rz3NgaVjZsIatzKr5K+utWFYTj+MF6BpVkE+Ya4FbSoUKDTJ3WviiXbL4xAE315GAU+4WIKyZH8+fJ86ZiXp7sqSsugE+lWXLn1iZPIwYs8CZtSWqAol2za+qZ2b3Hw3W9OsorFFkVhYZnIe6ro0h4lIjv8Z+GnA2wpUzejuMROIBw9xPm4XJkzkAfsmW+LMWz+R0bfg9/Yb0acSxOyWA/KaYoAVbTTh4WL1MHFzj+OkU1XE9oa96agc4UY1FJ9bqp3XnEpqmnO/Qcgq1dI/xIm9z7G7A7Jc+4Wb2rX5LNe5Nz5rNJi2pqIS5VWEDjqi1yIbhLNOeZgv+LHyRNkQXEPpXiOsQ2XHBUXCFzV9OaHU/1mnNyX61TNxbjr3QGQEEG+uRSDbnGx1NygJ2wGFRRZpBLRREJjSiQUpwzXiEern7XGqFUHV3urwCEoncFWczvsZtKo065aLY3VEdnjOMkazqES2VwpXEZsxceted079ubZWGsrdWgpXmhJcUfwz96p3QXVbK9kokTk9rBRespXrxWaxy79NSBnhxoLw57AM+DSKAHMUDDwoHlQoNVktB21rxUvt+wuxD9+M6KUqbZhj35O4Od8fPZxewbERUuS8ty8tV+KzXMbB+xbj5cQ+N1zmO4j0MNF/pB+7VM24Am8cJk5D3e01Dv8+6T2nYeoH/Z/EKJjV/YN8Ad8GzcrKLiDc2eO6vthKlaleI6HpLIPr72C93Zimsu
 t8bRKEnP
 mes3KlgmK3W0TBZ90NpAoQKZhfM7GK+vGOKAArqKQk0dQAk7z9YJXT2Hrf3tvkIV5wl9wbPmjv8JESBo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The section name should be the same as the parameter name.  Fix it.

Fixes: ed581147a417 ("Docs/admin-guide/mm/damon/lru_sort: document intervals autotuning")
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/lru_sort.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
index 20a8378d5a946..73980bacc3a02 100644
--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -91,8 +91,8 @@ increases and decreases the effective level of the quota aiming the LRU
 
 Disabled by default.
 
-Auto-tune monitoring intervals
-------------------------------
+autotune_monitoring_intervals
+-----------------------------
 
 If this parameter is set as ``Y``, DAMON_LRU_SORT automatically tunes DAMON's
 sampling and aggregation intervals.  The auto-tuning aims to capture meaningful
-- 
2.47.3

