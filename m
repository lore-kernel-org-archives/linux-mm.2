Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AB14606A326
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 16:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MjRJGdz1
Received: by kanga.kvack.org (Postfix)
	id 168AD6B07AD; Tue, 24 Nov 2026 11:30:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1195D6B07AF; Tue, 24 Nov 2026 11:30:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02EDB6B07B0; Tue, 24 Nov 2026 11:30:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D37356B07AD
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:30:10 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6293B40C74
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:30:10 +0000 (UTC)
X-FDA: 85470549780.13.1895606
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id B45B61A0003
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:30:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MjRJGdz1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795537808;
	b=SzSAMxYeWKg3/AJKyj2jRZdAhPZVUgNEnThDcSumOESqe9X7FkG/qbpYPqmeQ8EDfkykGt
	11r4s2H3mEJRnKCKajj2dkxQ3uTsuWQpMXD5FsdcmKVRCEeCMACp3nS4fdEwxzvqwOYnh8
	dWt4TmFtuDcpRCZx8hI60GBhSrbivow=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795537808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZhbY7Xc0nV3cRc+NgXYsDmY8cyLnSQJaGENKgPMR27Q=;
	b=FeQKDlv9fthfTaCSeQN0S/lUasGS6CC2ey0cmfh7cNGELWTd/wjM1ikqK/AyhHDOlCNKqj
	h8SqeRWskumCRkfM+pLIc+LdbVTRQwsnSws14e3lQQXs2Wo+F2VShe8lpAexXKVnc6YDDv
	e0AU9sXF5k1nJE8JVAFJx6v96+Wkn+4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MjRJGdz1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DBD6043CB2;
	Tue, 24 Nov 2026 16:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60FB1F000ED;
	Tue, 24 Nov 2026 16:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795537807;
	bh=ZhbY7Xc0nV3cRc+NgXYsDmY8cyLnSQJaGENKgPMR27Q=;
	h=From:Subject:Date:To:Cc;
	b=MjRJGdz17ItqM7Q+FLdr9kmwkqitpLrCB+59pW36Jmc3xmDAJ/TpInLSMasM9MUq0
	 GXcZEhyaZUdxwXHjc5+IzKj7hNkr4D3q3vqZ4d5Xexr4py8oMiXJ3lBJXmcHi0x2EQ
	 VSzH/qOwU/Yk1ngXrCAeiSDmcV8y7tciyojV2BHzUK8i3N/Jg/GZEW+Yqgl5YgccLg
	 3Yva4RsI/60eURMgbkVquy4LInBdFZwyFqPQ14hDNPbhg+zFQIf+inGQjT1mGs/rQn
	 eQdgZoRJOXDlMJ2FTOppnCBWsNm4ykiXAihWAPi4fxZCVIY+Gf1EosULt3Ot+gcyoX
	 SA6SgPzJRJE2w==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 0/3] kmem_buckets entry point rework
Date: Tue, 24 Nov 2026 17:30:01 +0100
Message-Id: <20261124-kmalloc-entry-rework-v1-0-37b1631a67b5@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIm7BWsC/yXMQQ6CMBBA0auQWTtJp4tGvIpxUcqgI9iaKSiE9
 O5WXb7F/ztkVuEMp2YH5ZdkSbGCDg2Em49XRumrwRrriMjh+PDTlAJynHVD5XfSEb0hZ1uyrTt
 2UNOn8iDrb3u+/J2X7s5h/r6glA9bsnBueAAAAA==
X-Change-ID: 20261116-kmalloc-entry-rework-a0162912968b
To: Harry Yoo <harry@kernel.org>
Cc: Chris Down <chris@chrisdown.name>, Kees Cook <kees@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: B45B61A0003
X-Stat-Signature: ag6nw8mmbhrgs9je1ubf6enmm8hwrcdf
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795537808-17357
X-HE-Meta: U2FsdGVkX19S0MVurqn2YhDODFnaSbtcn9Z6i5042T97flYUqFYlfl/1GlTgM67FZLCiCgbKAqWgtPfKVvs9fawwCGmdBZT9FsiIEb9X8TH1t+QYibyMfjE+i1551jYJbFtYcmUQG/SoZRJ5pb1UT7gtjTgRij3nTNLvJZ3YEjAGI+fKGUrZFPnDjB2sDPKL4t7QKDn550XGwOzleywU2G9+jbPBl6negTJRY4ec/1XQ7oaJ25zPODw4d29Crl/POxvKkCrbvxw8AZXqryLMuSGmYungnSN8XbfwL6AXA6oXTXOuH+3fRau3ys8zjHqzSggy8Mb9XPk4LvQom+rU4IwjwdQEY9NDJzaayK0xLg6NvQjCMEcUvh/8rTo+yG+S6bOmCKuADNM1XUsyNVGUBciSTHt4gSoMfOzEMfRYpb5vzUXqMMtAfVKXLSpQ1a/KGkzJlDxJs2g8ErHbY+slNFcdS8IEAcf1vUj8NZdNwvX29pu+pNjTp8CeU6XhooRdUz8P2izBIpJyocVCk5R7p+l0mnf3iR4yvSh5+w0D3YMI6oyI9EpOlcwmxMuMubZrHsJsw9dK32+ZKthXFL9UoFs7S+zR0wf1sd1dN98AxuroSERi+Rb1Cy7CAT/4Qwk7/RvUf8c66WEmlvqu9DX0xG566rYz774CBQ959e5vor/ehIUV5ih9Efrvm2+xO2eu4N9hwDZEXrqWcZgl3nXYTbWMG5yXxxLz2ksa2BZQ4bBAHARsmgKVIuLnTMDHfuyLC5AvEsY60IHVvJ5fC9Zr6c4UCmNmO3AGainMGg1cZwQwVtLnOl05uUiAfmyRdvXy4q37blC7/7WtyCMTAhKx7hapj8oZJBwBp6lAbVDTqo0R2tQg31Yhpz+94TN7jxgUZ0j9r7dHr8kNC7D14eVbR8tumpqEC0/OjkMov3ie03c9Wh46G1DkwhZhp47S8uEopZR6hj/fZjPEO1ny7uq
 b8uMMxKB
 5kif67QpyrJ6IqB3EJBGlKjfH+4tvenMy/DTMt7zaA7gL3tV7OthjH53HYPc7Ql4tTWLfwuRYcOhDJLIm3xvpwxBlHS0I8KAwNRK7yEX4YLnr8FBCPpKqC0/+rl8daUDJQwdJ+grfKWZllaj96N5BIjGlHzINVl+jzlhTRtCbUl9OLSwCqhxRscpbrn4FJQ1hFCYB4SWQuFdkdo2v+/xZV3RKTojgdhuphN8BXS4IETX0lhe2kkp+mQiWaJK8GtamIpcZOIW0OXvU3zod7UO8jm07c7+c9JWN0rgauTGaTm2IXNQPwHApJAc/vhHwcogv6pzBoRaGp2wp6mdlGV3i+gJEiNF1xAlBR/z7QxCknIQc4xIDXEd354Xc1z65RScy4PerHE19IQ9hDy8g1xCU0Rs06Kc28lw2DffUtdVFwlaNTcFasJ8ZRt78BuRlX550vm+c8QRCSkKLsYb2mRb+j+E4Xr5WIUDU19TFPqPWNRtWElb4p0qtux2xsfIpmBELwkRKc9C2pezrujY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When pondering the boot-time slab hardening features patchset [1] it
occured to me that the kmem_buckets handling could be redone in a way
that there are no kmem_buckets pointers in kmalloc_node() and two more
functions, and we can drop some of the tedious parameter declaring and
passing macros (except those for randomizing tokens).

So instead add own entry points for kmem_buckets enabled allocations.

The first patch is a preparatory cleanup that also makes the new entry
points cheaper (in terms of binary size) by making a bet that one extra
call in the allocation fastpath is better than many functions inlining
the same code. If that bet is wrong (I haven't measured it yet) we can
add an inline there (it still removes some duplicated code) and pay the
binary size of the new entry points, but it shouldn't compromise the
whole idea.

If this is accepted, [1] should be rebased on it as it makes the
slab_buckets boot-time handling really straightforward. In fact
CONFIG_SLAB_BUCKETS could be repurposed to only control the default
behavior, while the code is always compiled in.

[1] https://lore.kernel.org/all/cover.1794506262.git.chris@chrisdown.name/

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
Vlastimil Babka (SUSE) (3):
      mm/slab: add ___do_kmalloc_node() to deduplicate code
      mm/slab: add own entry points for kmem_buckets_alloc() family
      mm/slab: drop BUCKET_PARAMS and KMALLOC_PARAMS macros

 include/linux/slab.h |  53 +++++++-----------
 mm/slub.c            | 152 ++++++++++++++++++++++++++++++++++++---------------
 2 files changed, 128 insertions(+), 77 deletions(-)
---
base-commit: 0b4d8fca3d41123c2419b8e489ea7dba34d5b7e0
change-id: 20261116-kmalloc-entry-rework-a0162912968b


