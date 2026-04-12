Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2CFCE937EA
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 16:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0333A6B0098; Sun, 12 Apr 2026 12:20:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAE1C6B009E; Sun, 12 Apr 2026 12:20:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3CB26B009B; Sun, 12 Apr 2026 12:20:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A65B86B0098
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 12:20:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5EC5C14075C
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:20:07 +0000 (UTC)
X-FDA: 84650415654.04.D783A4E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id B3C381C0009
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:20:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=go158nx8;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776010805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GMUCrJ+gvGwaDfmPiXkEDkPCzQINbFEnETxptdhOtNc=;
	b=0F93SNmRqK4USazuQa3Lxmllc4tOrX122dh0hkFiqT8bRtPVUCevRvxm9+TKCSg4ubZGcY
	VxFSpEFaUaFSJ9+uJclPW4PUDn/g5tzT9eX9zFLPU1xjgvdhHpyy+YwxMQ7RP9PN2Xpbzg
	1Ut/2I7h7syIvOrgsO73+TZFcRyTSlQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776010805; a=rsa-sha256;
	cv=none;
	b=a47W8eabXfmYP5v7+pVZgLAJb5Bl9pxEX0PvSttJZb60sdLZB7/TmDp15UatAaQl22Jw7I
	tR78yGq8ZBzUJLGR/lsqHuhcNSkkfAydPF0qAoUbFOwPaRUdLyrJwmktGgNMkyKCmqAIiT
	n9nlZR9KbZ6x9Icc7Gx3zPrMYHYiIGU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=go158nx8;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E0FAD44564
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:20:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0709C2BCB5;
	Sun, 12 Apr 2026 16:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776010804;
	bh=WgiRHi50zFvHwjFSQiNfyV/FQHY8WOkdhFM9Jv3jqj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=go158nx8BH5wgKLMjcmj2GNCaGpXFTv8GALgZhbg1MwLzUu1PiIKmQ2hf6SZ5Totq
	 /G72za/RW+8/JEEnUYwSWGLIRMEpWrQgjbiZVx42Ewbnk6ygizBccxGBjzAC2ZVaRZ
	 EgIKM5yBQfdEDEyfNkL/cNCsqR+bzpnQPomrt2vJ9SMYzihGiEvxNDH2xrUi2crUT0
	 UVvlumPhUfeA7lgNWOee6C0wh1ggZnRFo+pQ7CM8cS5Dp0Ass3mKlSGclERIvJlBh2
	 sQxEpv9agPUOTNo+AXW3DAKDn4dxWrOylZIR4GaZ8oP0nfxaKKv/hSYdaVCzt6mXEv
	 WRN3GPr5BSogQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5.2 07/11] Docs/ABI/damon: document fail_charge_{num,denom}
Date: Sun, 12 Apr 2026 09:19:50 -0700
Message-ID: <20260412161957.82835-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260412161957.82835-1-sj@kernel.org>
References: <20260412161957.82835-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: m4e97a4yw7fexo88rfz9qjgnnwgwsjn4
X-Rspamd-Queue-Id: B3C381C0009
X-Rspam-User: 
X-HE-Tag: 1776010805-910212
X-HE-Meta: U2FsdGVkX18IduEZRRL9H76Sb8Dpjrzeal0vOOC0bwQmf6q3o3AaG4Sx+cpBCkgi9Vt2FZ1ZN7noi70VK7vwP1BG56a4oJt9iMgq3015+0lLXU7z3FrIWga2sSfWlTs3GwU2kRmXqowloeKF96tV74uqtQGkcMroUbwS40xFWoPYpaWAUYg8nSqV4wy1qxpdH2mMjRK1c0dbzSWpjRvRsmwjf60nqAFtC7XofWU/Fp9RSu4ruqQjINNGgJUiqB8FmJnlgHoC9nEEbBCGR+htzniu/O+Md8j+qUrGMz0dvbCJFBjwjppZn/7uv7MDe65xgVqKvH06t8Ey3TdX+tO9FMB66vybFDHDmESir4FiX4fIGSp1LaHLHQ1nmdmw6A2AiqUSGO9LEtYQDShmCL6YNsRRMepF8vukc2lNB9h21K1BiZVBTi6H2M4KICyr2LQ3tgGNFRF5k1CQcKOigxuAI2c4LlWs1qxd5oxN3UUFXsyyqUHyMVqVjXDLJn/m3RTuZDx/FLl3RayMXvVTyiaXGXkfG+g2Si5RNUqo4oCEFs1Elfkq1gtBba7WPoSzjbmfHVtFWCbHC/ypWUDPpq3snb5wR0b17eciMye0rhHLb+47fGj98oZ8p8z1xh2SY/JwcGXqxgUKv89EhQPPYQaTh4VSmdeGCinazwWs7hmNqBS+7lWavXx6EieMDjB3I0ZHt4tA7vm1vJqEk02fHqmL0CZNn65GQ1Qjnn4vcqogI5IYO8eAjcVnhps22Th7V45dvk5TKj4zb+jv9aHPumcUilV2F94pU9enq+tOAu70ud/Xu+JosK7Gx9lgP41D/t5+glSBvD6+OTTIF9MqoxPcVWtRBtdAlgsxyihp70oxrGTkSIEtEg9znOPnkFMpBqj5+4BTlwPFdQFJ75cGEqUndks2cpuVgl6NO/tZo8CQ2gIXCvT8rE/mTtFHBOP9NEdwBz21ejL/MtlxPqj0/Xo
 1odxgnmN
 BiMcL9TCpVGOYeDmmTUVvhz0WQHIQhrFI/qJ+QT3ouRmmOaRQ+s2Tevh+Gjr9OwM43+VGtXz7MOEOTNS1Yr2C7Fgs14UxfuSqYhnyShiw4c1RAI/yYSGgyCSiMu3KBZYSQQJKo78shKDVylK0+aPDUb7wUj+0vR57BxC5l3rZElgVJlM5HOMs6c1+xV4ol0lOkgkZxN80vDl+yTf2bVmG0ThPedm/guGAC64iajqjI/2mC1CoXTMk9lzknEjcEtyFC8kUwFN5o2UnYubvqoUl7Wxs4ynj2BQig1+sqSD5qePPHp/MwbPGM1kjCj4VaETf8b70/KxVTvKY+jHmYh8PBHJmZxHSH6hUlgTaCYQFOayAR16MzxLQUyK/bauhyktNDJab
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the DAMOS action failed regions quota
charge ratio control sysfs files.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 7059f540940f0..971c22e34e722 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -329,6 +329,18 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the
 		goal-based effective quota auto-tuning algorithm to use.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/fail_charge_num
+Date:		Mar 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		action-failed memory quota charging ratio numerator.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/fail_charge_denom
+Date:		Mar 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		action-failed memory quota charging ratio denominator.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/weights/sz_permil
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.47.3

