Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2E0DC982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 16:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 876796B008A; Fri, 18 Sep 2026 12:34:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 827686B0095; Fri, 18 Sep 2026 12:34:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7179C6B0098; Fri, 18 Sep 2026 12:34:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F37B6B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:34:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 84473C0339
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:34:51 +0000 (UTC)
X-FDA: 85227431982.23.267B28B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id D7ADE20003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:34:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ND8hzEqB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789749289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rwnH9zVddDW2WUbNCyZTKKy1dimOqgY9DBfn9f/BDW0=;
	b=Aso/rz2nCdVDM8I0VtAudTlPB7fZ81G1vEnuJMOJJ3NCuPt0BYDssKqvqn8XpRCD+qqQTj
	tbOaSmr5gvnl53nDomxj+/VsJf6qTQit/+rC37VN1wOjFKtQ3kpmYXVSafxdiuPg3qbXQI
	gow8tVWlFkga641QjQwcK0kFuTkRxAY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789749289;
	b=B+Dcz8EMsRPZBZa3FInMz/H6VVx5HIbIWHHQaRlRSwn6ZGH5tR/V2OUlu7dQRmsH2ARHJR
	vw2HZ+Vrq5SqgqeM95wxG2CiKLkYPU8Ve6DbYUpdqhFCp2Zbmlhd++T4gqzhF9JS2lEAYu
	A4ycsP56etbmKg6wocL5Tktt35C4g+8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ND8hzEqB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 95DD4601EF;
	Fri, 18 Sep 2026 16:34:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9681F00898;
	Fri, 18 Sep 2026 16:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789749288;
	bh=rwnH9zVddDW2WUbNCyZTKKy1dimOqgY9DBfn9f/BDW0=;
	h=From:Subject:Date:To;
	b=ND8hzEqBL5+6BA/fPxbZhb/Hh0KOSEtEecFHP9zPRhpsDq+ekU0Lc2oDt16kKFVba
	 CgKpaO8BXrzeRyfP3T8HcekIWowMb/O+mR6TI03+1pwNetUr1gKR16ByCTNFP5q8yt
	 yGYT5neQ/Tceap7kjtgBi3M+SDsZB7aMUMiuxuiKLmbG9XOUq78C3+i+4de/OHxOMP
	 yXLHKowVdc//Be5Y7qyDBkuEcmd1X6ZSHIU3Q+gzfnwvw5ZTZJQaEwvYl2omFVkG2z
	 i8N9h+ldKgSMdoolRYGXDdZPUGcgarlAqVegcagAV3oHjUAopEB1AkDyH1Fw1q2Mk5
	 NimC8zF3S73LQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH 0/3] MAINTAINERS: rework MEMORY MANAGEMENT - MEMORY POLICY
 AND MIGRATION
Date: Fri, 18 Sep 2026 18:34:23 +0200
Message-Id: <20260918-maintainers-mempolicy-v1-0-9a94cac6d135@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAA9orWoC/yXMOw6DMBCE4augrWPJPBW4SpQCOwNshA3ykigIc
 XccKKb4ivk3EgSGUJNsFPBl4clHpLeE7ND6Hopf0ZTprNJ1eleuZb/EIYhycPM0sl2VrkyXF6a
 sYXOK3zmg49/ZfTwvy8e8YZd/jPb9ADhO71p5AAAA
X-Change-ID: 20260918-maintainers-mempolicy-06bf34b59ec3
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 Rakie Kim <rakie.kim@sk.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=838; i=david@kernel.org;
 h=from:subject:message-id; bh=KlIUYYGrvd+OtGlPnQ0kH51TWAVclS+RYyBAJa4uKB8=;
 b=kA0DAAgWx+nLGEVVu3kByyZiAGqtaBygwtYkDfAiMd8cRS5X2ycFUgJ9qMC6q7TbJd2hUNcie
 Ih1BAAWCAAdFiEEUlPfMOnprn17Rg4Dx+nLGEVVu3kFAmqtaBwACgkQx+nLGEVVu3lZrAD/WZsa
 l6CrLM3p8DGMdCvXefasFsISZ3KgP97oJtxRQC4BAKfh1H1N/uAOFGC6oI1JQUmLnTuJG//72Yt
 wqlRUQ7AA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D7ADE20003
X-Stat-Signature: boopeotaakhp1xd1xq4sonc1ag79oeb9
X-HE-Tag: 1789749289-669946
X-HE-Meta: U2FsdGVkX1+wqB6Q/VPKmfbYgg2sALdmDGu+IITf2ExwA6tg90RQQ649ZdYrGXfYFF1juy01wKI+21XsaG1Le5Fjwu7h45AYpLtH++vzsJvLydpNHhQAQyxdlevPVjHdGz2wiycL4Ix8K3U2nsQ4Px+DhAX01Eg62Sj17ASMbEwPpY2JkzC8Pfiz8hQV2Q1tLeRR7SKJIHxfWM0zPcCbiOO3SH+IeYAQB6CLhg6IB0KpEN9eItcMlh0uufBhT2k51pVoMy9azrT5/CMeZ6uyahguM4zoP2+b+RqkfVLzpqEZ+UJLdBz1TINezRTYJF0Fp4C7pUQSIIXqz0UHiRr1wLd5bDygDwDbK2YOA2nHTYzctPDUvP+JxHUMGcDXfVVwcwvcDYq4b7vxKmJuzsyvCh+5ZwF4SE+23lc5qdZ2d89mwY1aaI6TcbVIni+F0uaE2fWUhXfqmr9jqz3DiVN+SIldq4rJVcpFBUC0NpDrLBPY+E4tKRrsuK41RrM0/Dahaye8ygxgkg39dNyyHfQdFl099BQ+REzs3+fk38jrRDx3D+Ans7Trz1LhYXFUkugmvo740XrYLylJwg+d9EFWrahXw8rk4cuAgOj2sD5okdog84d/J2Zk4KiAESfbaefZ8nY3aq18UytIluVN+hNI/JFOFrznwX1HgCkraH1YrUyMuPyjmOSNop+Krn190m2RCjJaQoF/r9BulhOw12VfA7vd3bAeVscb9MXtiz7Cjo8H+d7SZ8PJ9rFWpIOp+vfsR2dtRV96POcD8qfnW4PxDtvlgn8/qtfFgSl9nMuZTwRCmnBUMNDtoxHEPrhIHB6ykW/d4LKfif5LIs5mkBWIDK2OLQl/fJcU/6C0JwenwQ/in4zGKmMNRMPir52t6kRuz2SqUMq50yj9gK0uXcnJGa5YThpXcxVov3hHVOxbogJ+YSa/t6JOCa4BL7M+oIbU007gc6eiOHsF0Rmbb1u
 LGk2XBAU
 hJlDug1g+9EmG9ujbPBj1XO501jWNKq0lVhBLZBvI9Qok3Wf95BDR8F7bVoLYeKTrgZJzde266UyVpUIn5DAh8mp7Oj56wqTUaJKB2JSPJ/qZ6Q/yUuqAt1HvHp5JGx7HgLZ1aCKvmmylLGHw4YXxZAD/xuEVxaRByEm98d2sOTPVh6M2R5UsMN/3y2QNZAPwGKkC5Ihq4LQpJXLISNpUbCwVhsY+67dQk3WwnDIoFOTmBYbI6nmPYLJeFNoBkCxsAiCsWQkN1RbbfRbmQZH3Dpn5kwcei6/LOsHVEOIZAICFy0aYjm4F+gMrHRvCn71LlfZC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's rework MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION.

As I can use some maintenance help in that area, add Gregory as
a new co-maintainer for the split out MEMORY MANAGEMENT - NUMA PLACEMENT
section.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
David Hildenbrand (Arm) (3):
      MAINTAINERS: split up MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION
      MAINTAINERS: move memory tiering under MEMORY MANAGEMENT - NUMA PLACEMENT
      MAINTAINERS: make Gregory a co-maintainer of MEMORY MANAGEMENT - NUMA PLACEMENT

 MAINTAINERS | 68 ++++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 40 insertions(+), 28 deletions(-)

---

base-commit: 5dd1818b15d98d4a20806cd00b1b40320b06004f

change-id: 20260918-maintainers-mempolicy-06bf34b59ec3

--

Cheers,

David


