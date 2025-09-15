Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0934CA0EE8
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 01:58:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 058308E0008; Sun, 14 Sep 2025 21:58:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F24338E0001; Sun, 14 Sep 2025 21:58:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E133B8E0008; Sun, 14 Sep 2025 21:58:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C726A8E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 21:58:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6D3E858D25
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:58:14 +0000 (UTC)
X-FDA: 83889824508.23.1EFB886
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1C682180004
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 01:58:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p0AJjbBG;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757901493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Qbsa0SBz8EOMQ80xoyHIKyQmVU/0F0qXyU8QySi00tc=;
	b=jyfZacedty4Q7Uf3GCUZSszcfV8/cEwKApSWLubOB5pxpKJj/F1f9Q4llwEa6ovylm2lHy
	5EbR7kvvp9xXeN8M1ZETx2DVAOwd0Z1ngyTfeYmnum/Cck8/E3koLqDj9rVf27YhCAYICb
	/vMFc2JS0x77h0DfQ7cKca9Plcg7BWA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757901493; a=rsa-sha256;
	cv=none;
	b=Du/v/T7ENV+Cthqg3AiA2pV4TYTTW/kGk4IO8DUR3nehDZ6ZSLGftP8Ejr2H3JlmT6uypY
	Y7D85ykFnDmqLVEN8fa9ztoQ1Cez7LnAAZv6B0XN3kUaqdd3NqaBLI6JC18fzztii29zHd
	mtb4Abtdo8tX8s3VZ9/g7d89EUoshyo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p0AJjbBG;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6CA24601B0;
	Mon, 15 Sep 2025 01:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C49C4CEF0;
	Mon, 15 Sep 2025 01:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757901492;
	bh=BjDfoABSgABBExqvsCQseg6eKUcYV/UHjDVy9HDbnTM=;
	h=From:To:Cc:Subject:Date:From;
	b=p0AJjbBGFPG749zf9wQYkZKmgBX19ks09WgebMp/0+Hpb55ugQuzAomtLitCmJ5Yy
	 dTzRVHUoQv3y+CT4Ivr5dw8PWQ03uYMJQLa3ZDbtLg3UQutyzvgsH3WNMMM48TwMxA
	 mGrqqKHI64s8s2OKPM+2FCF/DAmEyMa6FAPlt5b3C7ub6dLLIpIBlcH9ESwtPyi3NG
	 TjVCW17Fp+EiqKDtKJUptMA09kckNx/v4hIQXu+QXE/uEd9ApAih+UqwF3E4HAoYuT
	 QVvgaSFzYrIrwRCMGfY6ilG+tToxHmEnqUjYKh/V9KlASxr9DRtAH91puGizygcwSM
	 K6MLyBvtOWwIg==
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
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/6] mm/damon: misc fixups and improvements for 6.18
Date: Sun, 14 Sep 2025 18:58:01 -0700
Message-Id: <20250915015807.101505-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1C682180004
X-Stat-Signature: 4pj7thxgcajhscehkyn68fhyt3wfws5a
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757901492-248934
X-HE-Meta: U2FsdGVkX1/MR+w+6Q6sIq0eL2ajfJr1MFVZsJ/iavYn/AlCve55693ld/i/8OMule5QdPs25u9Wuk3ZXAX3eR8wIzPxhHy8S6qJx+y5mfLmnDRaWg1GIgjdq38d8TvH9aY03Macf5G4R22FBIjtxj1l8dB4GiMMxsTrLM9QYetXM9HDM3kEzXEQ+m65zt8nJ8A5+ydjN+2l2rqO+3ZgvuMfHhr6SpsWRLqVscDKAOvmzXk05aAczTebmx5/Tq0+t6rRZCl2zRjt/IT9y/p6wLOCXueVsFBImWVVeVMTAhFKst/xr3AKhbIgBGGlSxsQQjzKhJmxr9IO+Lzd520qq8qNkhwwCF1MFWuXwQol3t43CTVe/mBFZ6F1hj79EDsR0cYmeXKDh8p+TbAEz8n+rLEOuVZEhe9EpV+nJQfRTz+hXMxnrhlZ+Tzjll4Lq3S/HYirZudfuT41Q3HBQWmpSJ4gdYs+3Gi/etkSuN5MWdqWKRQLTthrH9PyQA8GJS62ZWXjtp3daI5vctBsL2NvwF1Ax0mfmfSciL9VuNEu34zCNe+2VL/7uCTfdzsY8LVO7sUPa3+0ZQzbM2c4JOR8fyNm5XPl3pEBESBq+cipfcEswOMQFDIgjlSoHGBebwfUk0LYREKjFwY6xvddVGmLz2jc4WBFKOfAH7sh0WUjzXmLeo9ZWuimzYKFkDYhqr2nmbCRAtfJWox8qv6lxwSvex4Ak4/LGkNXZ9tnHKLHGfHHi8/AkFbwFu9HVKtXkO0P53MsZZzMvETH3irQ6t2//nsrtLrJ4ZxBadaddYTJyF7WLMe8bJw6yDMrRYqkUF/9Bo+a2kfozUjB5ATzWnMc8HGHICihNrijOg3sfZ0EFB02pZ5WwMA8ihgGM+Dusu4RCfjkyGTbztGqvStc9t9NyhcZ/MSJ29fcbusx+xEZZCHF5FiFG/bbEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Misc fixes and improvements for DAMON that are not critical and
therefore aims to be merged into Linux 6.18-rc1.

The first patch improves DAMON's age counting for nr_accesses zero
to/from non-zero changes.

The second patch fixes an initial DAMOS apply interval delay issue that
is not realistic but still could happen on an odd setup.

The third patch fixes wrongly written code that doesn't cause any real
problem but could make code review confusing.

The fourth and the fifth patches update DAMON community meetup
description and DAMON user-space tool example command for DAMOS usage,
respectively.

Finally, the sixth patch updates MAINTAINERS section name for DAMON to
just DAMON.

Changes from RFC
(https://lore.kernel.org/20250909034353.7064-1-sj@kernel.org)
- The RFC was only for the first patch
- Rebase and wordsmith the first patch
- Add a few misc fixes and improvements for 6.18 to the series

SeongJae Park (6):
  mm/damon/core: reset age if nr_accesses changes between non-zero and
    zero
  mm/damon/core: set effective quota on first charge window
  mm/damon/lru_sort: use param_ctx correctly
  Docs/mm/damon/maintainer-profile: update community meetup for
    reservation requirements
  Docs/admin-guide/mm/damon/start: add --target_pid to DAMOS example
    command
  MAINTAINERS: rename DAMON section

 Documentation/admin-guide/mm/damon/start.rst  |  2 +-
 Documentation/mm/damon/maintainer-profile.rst | 17 ++++++-----------
 MAINTAINERS                                   |  2 +-
 mm/damon/core.c                               |  7 ++++++-
 mm/damon/lru_sort.c                           |  2 +-
 5 files changed, 15 insertions(+), 15 deletions(-)


base-commit: d245e17d619ea0336d50b0a6c914f5701d1b0e53
-- 
2.39.5

