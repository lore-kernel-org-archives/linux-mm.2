Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C931D5B161
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 08:01:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 491D96B0099; Tue, 16 Dec 2025 03:01:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40C7F6B009D; Tue, 16 Dec 2025 03:01:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F0626B009E; Tue, 16 Dec 2025 03:01:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0DD4A6B0099
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 03:01:51 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E14AB6031B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:01:50 +0000 (UTC)
X-FDA: 84224590380.06.FC499DC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 36439C0007
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:01:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jtpzAqkH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765872109; a=rsa-sha256;
	cv=none;
	b=lVxqoyow/BqeiMZgulCgi/UGTNdgQIsYhCW2IgJ7WOxuclTWbOqGkR/W4vx36PNV+Wmus6
	LR3AhZX0GZwLMYgnTK6eD5v4e/ElxP7TLFS3Si0oR0touuxIaIOy+dGrixOJjF41bg79PY
	4fouiWYNbYIontHcvYxNBTno9o5bUAk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jtpzAqkH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765872109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f2yJ8CIPOcfWx7JWN81g56fRHUOpWBBV0aEH2lNBhu0=;
	b=fxT4X5ibBvTF5UPIL5ZqMWVr1t7cinsaC32KMiLbmFeSEVbmm/8Af9DO0BfhKKaAVfGa1X
	+YFCo4Xali+I3PkpRvfNGbU4WYhNYdNpcJDhifctlq4dxaYFcZ6trGga6W7OW/sMl8SM81
	pb3FdUMlH25cabXNqS0QMUXu2iWXtF4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A3A9444C7;
	Tue, 16 Dec 2025 08:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F67C113D0;
	Tue, 16 Dec 2025 08:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765872108;
	bh=vPTC/eKfLkll500maYdRrQDlL8kK86gyaCZ9jL7BWDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jtpzAqkH2DntmX+MprFRlCH+lIqo86TJxG4y/kKAFPeKlPFv9vGRRySqPPqPcD4ed
	 11YtHV8qLbXjPl2Z4WdT82t1Nd3HKLejcCG/T+nbU5sYpXB3KEOFO4+yDWv2gupU/z
	 6R10ZPyr4X4pEscy4HDRprbkXwzUA+DIuIAhKP8AoPYeFwkNZWRrhkwclKxVMJwpah
	 rymGGtWc4vmj/1TOEURkmP1H+kpMoYJm+HROutNt5GEdeIkVHe7aisLWQvdMM50oyn
	 s9BKuBu+Wy3ZyzsJpU4i3sjHdL6ONOmqDU8i+SgkzbbbHeDjFEBmCcgqJ/ygoaE/2L
	 L4mnR3FuywvZA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: [PATCH 03/12] Docs/mm/damon/design: update for nr_snapshots damos stat
Date: Tue, 16 Dec 2025 00:01:16 -0800
Message-ID: <20251216080128.42991-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251216080128.42991-1-sj@kernel.org>
References: <20251216080128.42991-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 36439C0007
X-Stat-Signature: iaex4rqn8sqxj7fiz3r5suucjfjewtdk
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765872109-972015
X-HE-Meta: U2FsdGVkX18BMGUM7FX2gHjuFxQLsKL9b21OF5womJ6iyDBuyFYEW2Exp7Im6VJgSFkpjIeHxxXmq8sRx8wdZ80CT1bpHIMlVMRXxkel+7oRSzug/YFCRwfxsvS74cuS/Y6kD1IBCMrbLp+aQeTlOEOGSXLOuROUqaNoTkMaxvjrdzZ11/cQ5hh44uvQ0RB2QqKxY3pl4AMu/26v15UyRsbD6TcUpM+knJLq+IlBBnlW3pBAV4uNjb1gVpPbsyEmHDiImPIKEZoPHBZuxENA6XSfM9IhHSp7qLwouSRPVzlfvjGDytE/fYeNZkKkPcCZmg1dLzCOV/w0kyqzkxz1LN15YYkS0hs8yVBUFtu8jPHG6bHtbItPy+p5UXY/4rluT5zwSLrMxI6Ii/vw0JvYsDk1KHxDZcoHIeI9cgiJ3O0us8r/RWEr9BGTwAoZxNZGIXuLXWrFbs+n+Wp6bYIrNiRn6PMyRVmycMW8vra7jf9vvUKuF2L0LEyhTbluzE6Xvp+anEmvSK3a/p0nJiITWwdh7t31bQuMxdZQ1cfexo04XimwOvu9Y1UgKqauQpiLpuxonk4ZBw/Jg6Wt55X1hBurCpQRg+8mrdBfqSiKGzJwYJJxNoFOfAu1QfY9jy94iyaPyX7mblXGnQXgYaYBIwZLeE1TXntaDLqLn+uhbnrCNmCs0evZ0h5LNsBSNIVelqPozeCcArIsa3G2JgzN5+2xGaoAmes3YZT2hRpKnHS7bapJFQWx+YRd6dOC6Dwf2u4pdLpwi/crdTLO1dVaPdJaTduAPOMTkG8N3B63U7cqWIzcyY4yuc+GBl+GCzkf1TZAG956g0HhRw7FzB5cG0QHivN0DUVGb+gaw4AwXPcIEgKhrz0Ja0KO5w7I+KI8X8chJPHlxtzLnOaQl+pT8llcyi/LNQk/NVP5Ed9+6bSb+cAjcOpYmlpDmNhL38F+nwPE/RfBP0eE+lBSgqr
 wh5ZNKN9
 72I/WNKNoZVJOv5okUKSPFK8JyRAdb+qSSIrx4U918WLeTBe8YuWKvbi/Q33T4oeJ64QNfIxBhU32wSsME4Yh6DfabH9jp1UapolDyQ4cn+0OrmaTpOF1n7awkXO5AhWbVXSltn5yRXU64AWMe8Zehit5XlW/2HdPgwSGiwV1/N7aWJtRoTXjAKD5+OgavkUDbqCQIVgnc+EiJq3AOzUy1m16ZOWeGr4y29a17gKe5/l2ObC75+JY3C7zLSFUiTDLrC75RpwoAzWADiUavncXfTkjvA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added damos stat,
nr_snapshots.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 2d8d8ca1e0a3..5cc7b7d662be 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -718,6 +718,8 @@ scheme's execution.
 - ``nr_applied``: Total number of regions that the scheme is applied.
 - ``sz_applied``: Total size of regions that the scheme is applied.
 - ``qt_exceeds``: Total number of times the quota of the scheme has exceeded.
+- ``nr_snapshots``: Total number of DAMON snapshots that the scheme is tried to
+  be applied.
 
 "A scheme is tried to be applied to a region" means DAMOS core logic determined
 the region is eligible to apply the scheme's :ref:`action
-- 
2.47.3

