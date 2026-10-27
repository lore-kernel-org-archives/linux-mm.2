Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14B31606A321
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PwIPF0Cw
Received: by kanga.kvack.org (Postfix)
	id 071D76B07C8; Tue, 27 Oct 2026 11:46:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3DF56B07C9; Tue, 27 Oct 2026 11:46:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E05096B07CA; Tue, 27 Oct 2026 11:46:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B74626B07C8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:46:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 57E311A0A0F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:46:36 +0000 (UTC)
X-FDA: 85368833592.08.E792759
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 93E2A14000F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:46:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PwIPF0Cw;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793115994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/Ri4iDNPYWxMKwrITsIynrV03rkPdZU8RMGQIDOFcHU=;
	b=z4i78l2leHV+N1d2YiHnheais/fbHEYN2QVfxi5sheY1wPM9heWustXXNEceYMWqJ8eALj
	n5lGhjo2Gc0Ql5n14upZ7HToRtFBvR/knhkWHtq/8kUzDPqpFteHVrGln4qp2RucIZ+/XE
	B7hARTU1Jm89BdpeYlpjqH5poWZM0L0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PwIPF0Cw;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793115994;
	b=pb62MfQK5Vm/gy1RF2PG7SKRgWifsUiiF0jlGwsvYOUlvFh1ZuJfwVSefo/tism/6lFpV+
	HfagPydomMNiu+nzLtsQTcLuCwBZiGNVpS3WqW1eROYCo66vMEmidmbo0adOnbVlKPQU7G
	efJBZ9XTr45VIbVkBs2pJ3zoyfJwChM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC0F743D4A;
	Tue, 27 Oct 2026 15:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CBD1F031E9;
	Tue, 27 Oct 2026 15:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793115993;
	bh=/Ri4iDNPYWxMKwrITsIynrV03rkPdZU8RMGQIDOFcHU=;
	h=From:Subject:Date:To:Cc;
	b=PwIPF0CwnI9H7xVSelgLMbn5NjCKiXO6xpchM797fGekQGKC82jup/tx8n+Sm+XiH
	 /CstMqnfYA6gsDwJp9N15dJ824FzLE+XR6XfUeA4K+49CTbFLHeK9tSf2HuKt2p7vP
	 WpA4Ve1BX4sxvq8WrbwdnfUgU0IXqMtLHOAP0Hg4FFfksGWRljx7ieE/bpZdd/L7D7
	 WghvPiIikWA05KYUb9oRmg7Fg4dYP36rR4pGRZDRYrmZtKNv3tSSgy8G6PyY8qa6Ur
	 ianZLnKBIquNBHSFzwuyGBmjFkwPPxWFOzi6Ftt0ZOMm7MAqvWx00hOoZqiBx+2/x0
	 /CrMA154mVpaQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 0/9] mm, page_alloc: several stable fixes
Date: Tue, 27 Oct 2026 16:46:26 +0100
Message-Id: <20261027-pgalloc-ai-hotfixes-v1-0-9c7d1aca801e@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFLH4GoC/yXMQQqDMBCF4avIrB0wkajtVaSLGEcdCUYythTEu
 xt1+fH43w5CkUngne0Q6cfCYUlQeQZusstIyH0y6EJXqtA1rqP1Pji0jFPYBv6ToHl1rm/q0pb
 GQCrXSPeQwvbzWL7dTG67ruA4TjlyPiZ3AAAA
X-Change-ID: 20261027-pgalloc-ai-hotfixes-59bcd873a355
To: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 93E2A14000F
X-Stat-Signature: fnzu9yrjp1w116isxkp8sfnzdq341odw
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793115994-314376
X-HE-Meta: U2FsdGVkX1+z+/uobLbb4paDvQ1GxX2IDeAykNsSmtdKTGC5419HUGrBrlAT7/Z3v+1BZlOvR9Nbc5PD3Lar3YA0PvrUl20H4yA9KCy/DVBTtjZDHJ+UNmBVl+SRM08hcMmek2GUWqXLFCE5XUMIXEWv8tJpiRniWhXTzKyEF6+IN5q0PZDSZIDO0JLup7+49M9CYFDhrccspKGkuEM5VXa7vY7pgYnhZL6sItlLeXGLh8AUM1C9bVNULwrryJTS3IaShz24T3IEKuQk+sUQzjUnKh2mO0JN3UGriFO//sW8UthksHtGYEaUYxRfm2CB5BPHDfhL+Zqp9ShCeM5idohwX4GnyxYUphAZ2bGHbTL+ZGop1yAGUMhPy/wgFUcd9gkdF7RwAzOw/FHMi2ZZcCbMhPpOEF5FXuTM16apCpvl7P3ystY+INWuJIH0CLEMgJneaE3CTgzAB67OpLAy8Cy7ieWvODD3mep4jItEPRNco2eUkoOJb0DE5+LTzi6wcpZSy44EW3GKrMFYt6l1OQZRNLKyeqsJFL24yxfiUZURAAnSLkvBMgOsIRRa6/TK9WguaAp59EiJZzseKJDh/kaPIHC6uWtDGrU+WN8rOjsk4Ov33nBc+iP3eeb4YB1/OkZmI1LnXb4s12lzVAJHs+GqEeGcoKGaq/8I26itn3JGXt/HUmsJjjoSQOZ+qRH4P3kokcxQr1EJ+iHxbVZ+RQrsz+c0LvMLpml7YdCuBnNVbTj6AGVJxloFaqy4Quh8YGPzQgDrmPxTvPY12hTz52ba16+9Ol8PZH0hGdzbToYuf4YhHOjNcYG937ElZnZKH+vgv4mSlixgHVlleUp6HyPr3+PVz0uMztQblna1A4O61WzR5kI3iUnQ07xVKof7fWwymQiqOeWqbdv9rhwQkLjT8XikqnxOENiseofW7t5jgp4cMHSANHTi98yV8XIdk9fLfG1/24pkGgALX93
 QN+WkyDv
 7ndeoImTkc/lbYxIzbDsjSDEVwv8nEqmOPayqbH1B/8hNbHewC8SoqZTzHigDlHgXOESj13UGarxqSeWhWRkp8r1D62RuEn6ldpujWMPF6bTWmY+M2a1At9UsDKIzVEtYE+N9PrZjg1nwrlwj9RbYsP8uhLigQNQmGfnsT2DMKmejuXRlnBC6MdKMAUe6XKaEpNWprDtP3/cD+huMx8WOtH5pAaPRdpSaWxkJ/ap/D/iuphZVbwpEut/CLDjOXYX8EQCxFE1VZF+3kv0Obn0RxyAtEC4axQgOQF6E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A bunch of fixes from Josef, filtered for page allocator by David.

They seem worthy of Cc: stable to me, but IMHO don't need to be sent
urgently as the issues mostly need root actions (memory offline) to
trigger and/or CONFIG_DEBUG_VM to result in a denial of service.

I have tweaked some commit logs and a comment in one case.

Based on mm/mm-unstable.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
Josef Bacik (9):
      mm/page_alloc: don't undo a racing start_isolate_page_range()
      mm/page_alloc: clear ->private of deferred free pages
      mm: page_frag: refill the cache for large fragments
      mm/page_alloc: keep the pagesets of an empty zone
      mm, page_alloc: pass zone pointer to trace_reclaim_retry_zone
      mm/compaction: trust zone->contiguous only in the span
      mm: page_isolation: do not take slab pages for free
      mm/memory_hotplug: resize zones under their seqlock
      mm/page_alloc: check pageblock pfns under span seqlock

 include/trace/events/oom.h |  8 ++++----
 mm/memory_hotplug.c        | 51 +++++++++++++++++++++++++++++++---------------
 mm/mm_init.c               |  4 ++--
 mm/page_alloc.c            | 43 ++++++++++++++++++++++++++++++--------
 mm/page_alloc.h            |  7 ++++++-
 mm/page_frag_cache.c       | 21 +++++++++++--------
 mm/page_isolation.c        |  7 +++++++
 7 files changed, 101 insertions(+), 40 deletions(-)
---
base-commit: 39274b454e9993cea319f4ac342a8082a9ee1730
change-id: 20261027-pgalloc-ai-hotfixes-59bcd873a355


