Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EEB3CCF9E5
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 18:22:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91CEA8E0176; Sun, 26 Oct 2025 14:22:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CE068E0150; Sun, 26 Oct 2025 14:22:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80AF58E0176; Sun, 26 Oct 2025 14:22:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 715668E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 14:22:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA8E51A02A5
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 18:22:25 +0000 (UTC)
X-FDA: 84041085450.21.837F8AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9E120A000F
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 18:22:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l6JS8Tx9;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761502944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6+wf5n1h7ATx3ZN3ZWCgBFwVVOrb2ti2cr9EhEzZ9GM=;
	b=XXs5oGnxiX1ZdM0203z/5f5YEVvg2yk0GJdACHVuw5FuxUzFCHd+oE8tThuAHXLUz0+JYa
	kN/ikd/QUhjJhzZlRTnvmbhWmdLsJ1zQFiTefNJgPx0FXJxfX58BoR9mOE+M/4+t7E9YBl
	9C/JPUY3Y2K5mgFf377f/qU1S1O7+Hc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l6JS8Tx9;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761502944; a=rsa-sha256;
	cv=none;
	b=1gFbtXwrEF3G57xnz4sPlqgwT62ouKlekPES9nt2YXa+C8jtv7qTn8vlOC/PnV7ZVsxTmB
	CpeeTWqcL143TKHyIDyT441DMVZ3Wn/Qfd0xV1qlifvRbLXggAgJUFtVdzcRj7RUI7LOXw
	j1u5wKG8kTB8/pwvPGGWWcx5Ymux57Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D5EDE6026F;
	Sun, 26 Oct 2025 18:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3600C4CEE7;
	Sun, 26 Oct 2025 18:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761502943;
	bh=GiKZojVeog5YOllrsDes1GwbWKFkabuDbGBFBP0siC0=;
	h=From:To:Cc:Subject:Date:From;
	b=l6JS8Tx9QJHnZ/QS+03PmXD+ZLF0mnbSH9X7NFXeo+oY9KW77lstrx8MfPsbmFkfi
	 izQVOMQn/kc9Irh8pG0rCN237YpZHkobm5WXB8DEMkYXZ3oQFihP6tLF5fYMjEZ75j
	 AQ7qfckSBBVjTWpsz0PLmthmt4pPhHGb9vhdazIN+lZJMX8SjoqgcMLDlXynSrzreD
	 /puxr1dv+DraGT738SAjH5KNDJ4cdt4ZVplqPX/onibP7TgGRvO+aaJLZjZwL9y0v6
	 6TdnGn1AnA898sj4g4MVSPCcQzdP+WcD0kvyE11USzfSfZBVhpxGQDJfNKOjcS6EWp
	 LPrzxg0FoWYig==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: [PATCH 0/8] mm/damon: misc documentation fixups
Date: Sun, 26 Oct 2025 11:22:05 -0700
Message-ID: <20251026182216.118200-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9E120A000F
X-Stat-Signature: u16e1q5fihgzwrd4b9yfuw663q47o84u
X-Rspam-User: 
X-HE-Tag: 1761502944-548427
X-HE-Meta: U2FsdGVkX1+HFkgXF4sXugf8ZoESIDrdNLOejPAYxs3yF3PvoqqUDlNq6ZniYo3St+Qri7Fuu5xA9ODrZN2NJ1e1wSVH5eo/NYzTlL1voc88feSBEPsi35bugQqNUSGWlhA3oyVL6t68E5G92gsY6096g3v6iLn5YxzJ2/tV6ahdOxFLE1Mhisc7zf4rSdCXDxuGHFaZdvn4X+NDn9NIB8+ntNjMfPSnmmxAALD3JH3d6yI6GnvOjM9gXxWjXzPViG6DZtUXT3gUM1JIjZj3hmEIO05C4lwh/G0h6datYXbgtlwvJI8vYjBZTRjf8Q08TtZuK6Dtp1L0cX5IKshcGqesZ0W+7ii8fnwApe1x2Wlt4cwzOpYYSINE50Tay6AQOJW4730e1YQyG5qhG8/tFSyyxTOlBPeTESJKLfby1AEEzkFMAtkdUCRPU9NuECLFOimTQTVO9UsCpnVDWg1aeJp2p6HcEGSK1WsHuPoM0932bQkE+HCmoYdFfbZykxcHG+3BZuTgRDae2oUopuyjBvV5h2VmRXB0Ne/0GQbublHRS+ybuOd5+vnFlSqpz/sj7Gu5EZjrJ3Il1g3wI5MALqOq+mAa9QBlCTVxsmOjTr26xZPpaxjNXOpwxSTzCHCIrKbLWpNXyqPXYX2/ZNpVmnIyH6AV/OHP6bD9JL9DbKpRi5aK+rS5TPrDw0i8RNRPd/1SBAmaUDg+REYlf69k81YgpuudB+nhQsejLg9Cw8wlK8MMb70smWbKVHmRbfq3woCxRgrqWj7xvd8xFKo69CgTZ7fsYIh2Nd3pQSaBuqUsxZV0fwZDHeg29rUhbtOSclJnlMUuK4URsSVgPuzDspLix79SmMF1bPq7GCTgWic2MeHKNO9XPGNZKE7v+hOJCeHKf/Ddy0rhLSRdygK7mDu4Dumx+nPgFa28//c5DspU4KJkfhY0iQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As the subject says.

First three patches fix up issues in the documents, including wrong
explanation of a behavior, wrong link, and a contextual typo.  Following
five patches update documents for not yet documented features and
behaviors.

SeongJae Park (8):
  mm/damon/core: fix wrong comment of damon_call() return timing
  Docs/mm/damon/design: fix wrong link to intervals goal section
  Docs/admin-guide/mm/damon/stat: fix a typo: s/sampling events/sampling
    interval/
  Docs/admin-guide/mm/damon/usage: document empty target regions commit
    behavior
  Docs/admin-guide/mm/damon/reclaim: document addr_unit parameter
  Docs/admin-guide/mm/damon/lru_sort: document addr_unit parameter
  Docs/admin-guide/mm/damon/stat: document aggr_interval_us parameter
  Docs/admin-guide/mm/damon/stat: document negative idle time

 .../admin-guide/mm/damon/lru_sort.rst         | 22 ++++++++++++
 .../admin-guide/mm/damon/reclaim.rst          | 22 ++++++++++++
 Documentation/admin-guide/mm/damon/stat.rst   | 35 ++++++++++++++-----
 Documentation/admin-guide/mm/damon/usage.rst  |  8 ++++-
 Documentation/mm/damon/design.rst             |  4 +--
 mm/damon/core.c                               |  2 +-
 6 files changed, 80 insertions(+), 13 deletions(-)


base-commit: 1148e04980a5471922064ff4b19cd154643da743
-- 
2.47.3

