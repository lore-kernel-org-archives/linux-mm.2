Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1971F1094478
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 18:14:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38DC76B0112; Sat, 21 Mar 2026 14:13:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 297AD6B0114; Sat, 21 Mar 2026 14:13:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 187D76B0113; Sat, 21 Mar 2026 14:13:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F37D36B0111
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:13:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AEED71E2FF
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:13:56 +0000 (UTC)
X-FDA: 84570868872.19.DDB0437
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 081A914000D
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:13:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eLNV3slL;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774116835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gIFJcc/U/FGZ+jTSwAe0YId8k5d0mbeypzHr/bajX3E=;
	b=PHQD7/FQW4CEHjcGJrE2V+h0td76z7x8YqhWBFaGDc/VNPEjo4Ctx+cQdMDnZtzgAmD1Uz
	S4RsKnuTDECbf2tKPJDEUj6hJAysc5wp6qof8LfjouBIx8J8Lx2r8ilJpZF2G1QIOuHsui
	ROWLKe9ZHDNu2zFQSA1u9De+PoC5pzI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eLNV3slL;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774116835; a=rsa-sha256;
	cv=none;
	b=WqF1uv5pyQU1di+hghxKqHaILls+wFfFHAx2LRj3Awt88D/fDNVtXN9HZIYSopddiMIlQJ
	tjZbbPR6i4zMw5ZA1DBcjzylgln7yZJGrwswjgl3PkmTJxpO1CLcKKtkHBP8hzigXOewyF
	miPS5y2/eB2NKPX0d4P/+ZLn5FuPAYU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D804E40B75;
	Sat, 21 Mar 2026 18:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DEB1C2BCAF;
	Sat, 21 Mar 2026 18:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774116833;
	bh=qt20gza/ZGfZPnGlsbY2CkGg3eBlVlFouLw/z7b3qI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eLNV3slLgvet31x6TAf1yaL6xK7vDqZMrt7HDDWXeHWUvLdUEwA2lM2Vx1xM23V5K
	 x/SovoUrbEEIzKL0gMYMb6k8zSXpnCmVqbuzFf+E7FQ0+uW2Z8ekdYF8XHjSIYhu3y
	 rOqQ3NjyyIKfoGeizMNE8aZ8S8Vmk9sN/Y5+7T6k8BuDmls5fc3JAHNzTFm1S/Raap
	 fOUSk3DeHGX0n0JH/1Vfu9RG/gIxXrL05fpDPs6SQCftB8qqk7NkmCIE5nIq+V7A7D
	 uOnOWaNVGl18Z2Ro47DiTelLmvCwxb+YAwu12z6x6vDeSfjpJlbN5BAp500KuOKSKe
	 Ce1bqpc5b/eaw==
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
	linux-mm@kvack.org
Subject: [PATCH 03/10] Docs/mm/damon/design: update for context pause/resume feature
Date: Sat, 21 Mar 2026 11:13:33 -0700
Message-ID: <20260321181343.93971-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321181343.93971-1-sj@kernel.org>
References: <20260321181343.93971-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 081A914000D
X-Stat-Signature: 5wapbcnesc3jawpz4dcczktrwajm4u3o
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774116834-547872
X-HE-Meta: U2FsdGVkX19d8Ajz4knD3LVfuUD5yZnOM1xWjBeivOS/9k0M2NGBXgvHEBA7ZPb6ilHoBykm0iw+1vtJSskmHXiaLosyo0g89TWCkCMEWCR4Uq3S5k20QaiL8gyB3jMcp13j6qXTy8nFEAbuDxJKtiIPJZGlCwZbb9JQdyDVhgeq3pz39q3DODekfmPq36ZLoEyrUMWvs6zk2Xj6uvVgDmZq8+Y4/WyJTglSZTPq45MWiZ3WZ/A5Oq4hEfT8VAPRGTNnEtBKFXDcfDUE35X7IsH9CwXl/XicaE1UU7P8D5jCrCScU8FBis/C/HFT+7+sJ36d116dwDok8PNDIKDPp003yXvzETFjT3Z4VF/eXFDmeqO+M7s6yLEO9+w5tRqTOX3Y1HJxP+Y2SG6GvSnnbmGUA0HmLfCFKV+gAbuUUvm7UGxwrsSZyDmL0GzzR8irCl3fq696nbcqw4uZDRkSjWFB9i/hyzE94rMR3ncDLlUeeP76qvynctZY2t7f4SpTAuI4+ONWqnr65VbHBuRsA9Yk55RYeB4WuPJgOt4xdm7HOXZab6bRtXsLXP6rdOmhgEKJp2uwTQzuSWawH6o1TSPbVDfuWidZu0+vE90h0hJO8poO9HqAoo0qmVE0ywDWGsB77UQmYhmw0Lao3VNy6yvniBSl7D0Zyi6H8bFtWWwGt93R2xfWVMzGCzOtSPq49mpjKJP2LgOtNa5cEKap/0NPsOYM+3V7KFOs+p88TAFnt9WXxubKJIyIPqQ4eH6by+/DsHcPskJjDzg7FyV5BtauS8+50aAt/ItTosTV7tcCUgianrSPF3TC3TL+HdXPgvlhF6BUOqMPHcVkMyjD11UH5FpGsSqqQ9N+glFj/9OGXavhGhdh3Hd+737RTuDJ4bhA5pzcCRs81gR4dRjieMPeE4M4pjw85yLDjTKnCzeVMNq/Eqcb+Mq51veBYUTz6FBwio+2ZD85XAXXXXW
 sIo8S0Vo
 4SGVOkq3YBiwPfz+d4NVzWqzp7tvpYgG7kx4xFNWbyPN6P0nfGnq9RBs0MCWgVtpeiZHlhIqMGPyT9xBBZpFtxaNsk5tw/8ASmScwXXC340DuOV5KmuflBKXHTjr+51vBCEqGmOB7koj52mztE28QKj8kf+XyDUb2MTllkdKKElMeIq34QLsBhg70nuh1j9NV5AVL1BcCS9t5ih2KY3CmANcx+dV3YmC8QQhsJLAYZOdj1tQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the context execution pause/resume
feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index afc7d52bda2f7..510ec6375178d 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -19,6 +19,13 @@ types of monitoring.
 To know how user-space can do the configurations and start/stop DAMON, refer to
 :ref:`DAMON sysfs interface <sysfs_interface>` documentation.
 
+Users can also request each context execution to be paused and resumed.  When
+it is paused, the kdamond does nothing other than applying online parameter
+update.
+
+To know how user-space can pause/resume each context, refer to :ref:`DAMON
+sysfs context <sysfs_context>` usage documentation.
+
 
 Overall Architecture
 ====================
-- 
2.47.3

