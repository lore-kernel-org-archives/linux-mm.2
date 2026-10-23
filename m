Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51D4A606A322
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 13:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EyfrLfRl
Received: by kanga.kvack.org (Postfix)
	id E9E256B036A; Fri, 23 Oct 2026 09:47:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E77316B036B; Fri, 23 Oct 2026 09:47:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8AE96B036C; Fri, 23 Oct 2026 09:47:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B62406B036A
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 09:47:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4283540441
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:47:56 +0000 (UTC)
X-FDA: 85354019352.27.688AFB6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 75C9D40005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:47:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EyfrLfRl;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792763274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=b8PlXFeXPIMULatUGJPR39iwhYNo68iKGZKAUipKPAE=;
	b=yPrGD720X8StXQ1EXHdWr3HN73IdNCosRnWtglva3fKpVGrBKMMmXyHJUHk3DKnkswesFn
	t/biJwLH1+EPOnSRTRlOTm/YeUIRAl0z1VF+MxKS7dHJQR4BQCFnwcI6zbzPP5hwzgRmK1
	grtqCH70ZLP58bZlrsdq24HnaRzy3pE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EyfrLfRl;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792763274;
	b=nn/puSn5/euSgufiJ6BFnIS1fVxcvNOKVLm3LXKzurREUzxWw92N2mZ6ZhZw0nuq/+zMSa
	V3g68E3nLoz4sbAyqaj8KfnQ9S5dOi3M2gMNXhJ+oVb2BiLKa9JKpBdEuI3whVzMcKhObl
	82jWWge6bKnz/0Wsh+pnRYaOxF6LxbQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A18142AD8;
	Fri, 23 Oct 2026 13:47:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82FB51F01825;
	Fri, 23 Oct 2026 13:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792763273;
	bh=b8PlXFeXPIMULatUGJPR39iwhYNo68iKGZKAUipKPAE=;
	h=From:Subject:Date:To:Cc;
	b=EyfrLfRl/6eXOF1vlZq5joi0UMItutPbnKgTKaw48KYGj5nVzLNp5o2T2UtIYV4wU
	 VoxIzdynZyu54LaS06o75JX2ti/uMCzukL7vsGN0hNYQP5kpRxCXEDWoja5YiLp9BS
	 /PMwA2eIvSQKrUDZBxfgwBZ33QoAfsGOOJ8nQ+eVCGxiHTZdGhqpfhgousYKZRYN5U
	 oBOw72KcnWbfhICt+PctlhQpYrigpAoZtTbdOZjdQqvPEq+n7GnfhrkSTCmZJyFlNd
	 qGrBLiDQtZzXd5KZlPizVXJJBqWVb0eBG/2ck2kTWG41KdoWa+TujokxAc92dJMqMF
	 acTC4PfhottSg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH 0/4] mm: avoid losing atomic VMA flags
Date: Fri, 23 Oct 2026 14:47:26 +0100
Message-Id: <20261023-fix-vma-atomic-v1-0-8ff4fae1fc85@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2MQQqAIBAAvxJ7bkH3INVXooPoVntQQyMC8e9Jx
 4GZqVA4CxdYhgqZHymSYgc9DuBOGw9G8Z2BFBmtiHCXF59g0d4piMPJzVrt3hhLE/ToytyNf7h
 urX35R/AfYAAAAA==
X-Change-ID: 20261022-fix-vma-atomic-8c910fd66a28
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Davidlohr Bueso <dave@stgolabs.net>, 
 SJ Park <sj@kernel.org>, Kees Cook <kees@kernel.org>, 
 Colin Cross <ccross@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1655; i=ljs@kernel.org;
 h=from:subject:message-id; bh=EzgA8OpuDj/HPokV0+ioX4khGkGy32kgZSQsaHsUjdg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJup7ZMnpOUIbnRwN6Ox/PBp08arqWV3rmP170vZgpqb
 T8TUX2zo5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABP50cjI8PBXyvrFEzh9yt+v
 eHfuRJpTQp6RaNWHUC63KbJM/ifvfmL4X2DkzJ7DFCK9+Ym1bO2lBkXV53pTLCZ+DNzmO903+cQ
 HbgA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 75C9D40005
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: mecj67u6nrct9ng73rrzjqjfz7ypr5fk
X-HE-Tag: 1792763274-216751
X-HE-Meta: U2FsdGVkX1/ZsyZRnKUal6TrGSwAdJjXcc26yMdBgNRV0hqZa3KEqX1klDvNLlVsmZwIyjH2gYVYv76L07/j7k/GOlnf+yoH/R5gkthogBYw54QiWpvye3R6z0G4TSct/zoe3K+s4W8Sw6uuX2vSFxebNb0y7AMN2YKCuDjhrVYFZJo4F+Oyc38/zRHIBeKDDf8UaZ5hrp8gU5vriPTZfeNURbhDpOjBteCYVULjm/FKLjlBvSZxCrROPA83kxQDQCWOagAxcRP+zK2HrVxjgKgozxzsn4DCMqSal+zyzzHNG0XjnOCJAcNrvLD2m9rpjVsc6DaP2Qv6nxfyPJX8WXo0SB5+NTt5Nnm9T12WAYdGtmDWR61Kzm1/OObrtpMuahIa8nhRa2koSB+U9E97TCvmOy3HgBNH+sBJX73SIDNpE+fXaICFi/sBg2v+X81ZGCsM/1zonBbd4ZnLR3VweBdWWZ+GOvdbMhWrPIUi8BpVH+1cz1EtHz60jzZHfQT3ojspLh3xuUiVC53G402OROmV91lLWNMoI0VzbLt+ExAoLz1yed8XbW+TehAekAHm0/E9zlN/g94djQleGZTgyjl84c41pB6DwsqETdksj0QHtc4Gk3gfx5Kz/EIgW3NjzucsCVneKEtmHkjD8IpaOfTYDLa1BkSwCsEFAC8dFzZ365Uhs2tY0rMjwo1zHUm3X2RAJsCxZMFL1P8TVXC1M5olCBhwKLksfJid7uTHo1dty9uGqS8mMuLvQoJruV/0xRTm6SfQcYPP4LUGeu57Dv6TJ3q72975RiK/97zUj9gYipG4/718Z+marmz6s1jbQYii2uX/yHyfYYxI8jfcCfmWz9COfHFbYqStaWjpw+w9p2vT1WIzbgTN2Zc55q0twYiiVGwKUxuDOo/Bw4Bad43Rx+060UAItXyYN86W9TkMYXibudXf2jfhhA8Sh3FbAmEs6d0SRiOqTUA9Z1M
 jEpxNnPn
 xg6gZDIogFMuKd7I6UdP0UzmUcAWnLcb/us2F/1ovqilryHv9zOMH1rGKWdrImw2EwJ5ClRe06pJvzcpqpdIX0ju2xHIDcgMsdr3ACnQy/L5KVIT3afGBc3AHGi2S1WayVx0+a7zSy3hSS1YZ/unPUlSvpEpjJX0R2pGfLrc+OKRowGcx2JZ+JUxnNA+Iz+4e01rEz4sSauGN0IHV71ckiTu2iorBjHbvWvX5uh4Xtah5wwKJk6GuM4w1hg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since commit 2ab7f1bbafc9 ("mm/madvise: allow guard page install/remove
under VMA lock"), VMA_MAYBE_GUARD_BIT can be set atomically under the VMA
read lock.

However, a number of places wrongly assume the flags are stable under the
read lock, which can cause stale atomic VMA flags to overwrite existing
valid ones.

Additionally, one case in which VMA_SOFTDIRTY_BIT was overwritten is also
addressed.

This series addresses each of these, while keeping the logic inline with
existing conventions.

Each patch in this series is a hotfix.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
David Hildenbrand (Arm) (2):
      mm/vma: write lock source VMA before duplicating it in __split_vma()
      mm/madvise: preserve VMA_SOFTDIRTY_BIT when changing anonymous names

Lorenzo Stoakes (ARM) (2):
      mm: do not unintentionally overwrite atomic VMA flags
      mm/vma: avoid losing atomic VMA flags when setting sticky VMA flags

 include/linux/mm.h                | 166 +++++++++++++++++++-------------------
 mm/madvise.c                      |  10 +--
 mm/mlock.c                        |   6 +-
 mm/mprotect.c                     |   2 +-
 mm/vma.c                          |  57 +++++++------
 mm/vma_init.c                     |   3 +
 tools/testing/vma/include/dup.h   |  78 ++++++++++--------
 tools/testing/vma/include/stubs.h |   2 +-
 tools/testing/vma/shared.h        |  16 ++--
 9 files changed, 185 insertions(+), 155 deletions(-)
---
base-commit: 5f980b2d53abf3950caff5d77b5c69dc6ebb19b6
change-id: 20261022-fix-vma-atomic-8c910fd66a28

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


