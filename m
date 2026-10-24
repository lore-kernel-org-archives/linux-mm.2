Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCA46606A33C
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 19:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ivUhPgUW
Received: by kanga.kvack.org (Postfix)
	id CBC016B05B0; Sat, 24 Oct 2026 15:07:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6D8E6B05B1; Sat, 24 Oct 2026 15:07:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B83DF6B05B2; Sat, 24 Oct 2026 15:07:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 887646B05B0
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 15:07:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EB6EF16047B
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:07:38 +0000 (UTC)
X-FDA: 85358453796.14.5974F16
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2F2261A0009
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:07:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ivUhPgUW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792868857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pV9crl2bRNBetBvvFA3ER0yhn3utBtqFVAs6V796Sv8=;
	b=JvrHu+EI2tru1PFKH13ZWitLBv/rVMONBAudkvTYdxQfbnmYxN1w98H42djwgWWHfUxd9u
	xV1ZDoREBo1m+eWtMjbqVeGhmTyiMbRnED/fN2Ylbip1nie71nCN/9uONFdoW74/HkRq9V
	+m0qRrIgjIT+fMGsCRyVO9FWmBZVNzQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ivUhPgUW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792868857;
	b=HfhJ21RVBAaX3/QtXuQ3fF8qUr5m4HvzGwqSNPmWdW+GevvD7co/9lleeviwcrKUuB18MI
	MTVKCJ8UTtjU1JjmcvzjH+GHjTYRMQ+BPyDgYovLkKyfPKTa1BhKn9kT8hD9Wk2NmgaP//
	Jj0OwdZuE0azKkf/t8SV4M8rRFlhs+g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 138F643D8A;
	Sat, 24 Oct 2026 19:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C661F01825;
	Sat, 24 Oct 2026 19:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792868855;
	bh=pV9crl2bRNBetBvvFA3ER0yhn3utBtqFVAs6V796Sv8=;
	h=From:Subject:Date:To:Cc;
	b=ivUhPgUWEGsBgz/I6J+l3oalvDnaTt/gSdZMGakLjoqU4bB2Tze+lcanG07YApmi/
	 auSbCDF57uw98UxYsnIgxuj6ZZjNhV+6KheIOoXZz745X/uTvbBmvGIKzqbPNGf/sI
	 e8ce8d/4SY9CZHcyNeUpd49j3k5azfc9PI3TOSQxyoa8fy0BZnNc07EMLRay2BUXq6
	 dSOlqu7EhjMQGv1f7pEcjNvnjwtwEajOUdUorKA2mteweZPppiDCtmWjgoWklshOki
	 8zECGMMlLZVpJlEod6sKIWb396el2szUjSwXOZQiO4wNx6nZBPqiZUjxa9C+FFmYaO
	 EJISm/3c4bkkw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH RFC v2 0/8] replace CONFIG_SLUB_TINY with a slab_tiny boot
 parameter
Date: Sat, 24 Oct 2026 21:07:22 +0200
Message-Id: <20261024-slub_tiny_rework-v2-0-bf1419ab5ffd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOsB3WoC/2WNyw6CMBREf4XctTVtkaKuTEz8ALeGEKAXrJDW3
 AJKCP8uj6XLM5mZM4JHMujhHIxA2BtvnJ1B7gIonpmtkBk9M0guFT8JwXzT5Wlr7JASfhzV7Fh
 KFR60FnEWwzx7E5bmu14+4H67QrKFvstfWLTL2VJ7Gt86GlZxL9by5pDhv6MXjLOMo1I6ChXm0
 aVGstjsHVWQTNP0AxnAzq/IAAAA
X-Change-ID: 20260911-slub_tiny_rework-8f2634dd17a7
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
 Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 2F2261A0009
X-Stat-Signature: 8rm5r5kaqm4n7843x6apqjo474ciydb1
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792868857-707602
X-HE-Meta: U2FsdGVkX1+vIyqlb2hC0/reLLV9rzfz/Fh/ppwOJ8VCLYx+3P5kEHaTR5DPcO6pa/542QwubMZGttIXhjrhZO9IogFgSzqjiPFGxvr1sLQEOAWArnnJOT2fDhrWB91YlUhBIw8DHUlIU25l1PPKOf9ch2/4NHqzhBIBH0juAQ+sBNAi93V0PyMPf13MvG8mx6sM6/iAphuXM5eAa1c8lzdgMI6H85h+Yw+PxuSI276B3LsOgW4NxqQoted13I7SRZO+qugYRxVUypa2/+PexxxikoZHwPAUCtHdevaCOv35YijDqVOHxrBCDnQYdCqqsfl1dijbJ4cIO6vOIPmi6CTSiSNhA1jOElizPekCvS0RRDBn32FymjdIjK18gUGhVdtWB0iDFEnHGBOfD354r/bcQ3e7yCdmHpoERRVb/WAcGAAQFP/b2jEoXUTrDqSAi0ENJwNwCQ8VNnc2TIC+jruKRpWxlQ3xJUuKHXFoiF6g2aAun3KSbmYGFKDHYcotgqwWwbEANvJGQMapqVAjdzRR4M6lHIjVW/lnz+YfyK9eUwhJW03X3RnGH4hVQZDugt+eO3lOmxH5azHHKBnCESmQzp6UyXuOMKxFokhWl7WGrB0Wl0JpshJu32VJ1XxFcITK4Pg4mcVlJYQCnUcaZqAuD7E8li+538nPX8b24zvROYPn0wUtVFWia93CP0HkdTuGOFRIIgKoFkcP98QvhyraGYIlwcQGFQ61SRqk6rYWPe8M25Td6VPXLx3w4pyPbPzRbHbAe5+QYr2JPE7NYjLR17gdoUsAl9Dq4t0/1kIplFf6iOwBubgrm5xKwS4nxkJueFeP96f6G8k06ZbFtQhnlo13Cb1pSYU7r8Nn7uOLOZld2UrF89jmBvLb7Z9jzZfd0/cJh+oSzTyesBRzcTDKbMUEteYZa8Syt21Q/FEpWym3jHuZApdmKItBuHfHnRfsDx7OskcdXzjEL+9
 /Sp1T4+z
 VmbgyvojmCAY69e+QqkdDOyQEVofwBdQhB4izI9xbR2KnI39yyHIrclJ+BZbwrw/8tuvOaweRL+0oFpiUNm4+DeSDuBZbTV12VVWw76AUH8o6OZblRBLmFP2ZEfvpXj/gnhjPgZfAsQiRr6dsjQYzR1GH8JAkqM52URhFMocUgr7X4oiQNJSNCzQBtYnwbdh6Lnl8DYk6Fqq3tka5NesvtlzsD/MoBhqfLQJEpj33Q9kcy6JNYZKhMnXUCh5ZBpieMTUlS50ikT2bfbESiNXRR8smVp05hAHC/PAQHNmcVVOBdFmR33FvFyjXHPO0jGDTpgUof9fMIMkv1Rh/lGl0ngst2QP4GLISyapq2nmSqzPKx5lPsucdPLNhbJmjIroNQQQVA5cvRV06QsXTUhpeoVaSCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

CONFIG_SLUB_TINY was introduced to help tiny systems migrate away from
the SLOB implementation so it could be removed. Its main purpose has
been to disable all forms of percpu object caching (cpu slabs back then,
now sheaves), and being a compile-time config option, some extra minor
saving were achieved by code elimination or more agressive merging of
caches with reclaimable and non-reclaimable objects (keeping those
separate helps reduce high-order page fragmentation but not memory
footprint.

However being a config option brings issues such as incompatibility with
other options that has caused troubles in the past and Linus argued for
removing it [1]. Moreover, there is a use case for having full-blown
scalable implementation enabled and being able to disable it with a
boot-time rather than compile-time decision. That ise base is the kdump
kernel which shares the same vmlinux but wants to minimize the memory
overhead (which has to be pre-reserved from the production kernel) and
does not mind reduced scalability.

Thus this series reworks the CONFIG_SLUB_TINY to be controlled by a
variable set by a boot-time parameter. The config option itself is
deprecated and only sets the default value of the variable, and all its
interactions with other config options are removed.

The conversion builds mainly on the fact that most SLUB_TINY specific
paths to avoiding percpu object caching are shared with slab_debug
handling, except doing any actual debugging checks.

Thus introduce slab_debug=N (for No-op) option to allow using the
slab_debug checks directly, and extract the underlying static key
handling from CONFIG_SLUB_DEBUG only scope. The decision to create
separate kmalloc-rcl caches is also made to be boot-time.

The parts of CONFIG_SLUB_TINY that can't be transformed to a boot-time
decision are related to dead code elimination and fast path inlining,
merging of non-kmalloc reclaimable and unreclaimable caches, and
ignoring SLAB_NO_MERGE for performance purposes (currently used in
networking). Those lost memory saving should be all relatively minor
compared to the savings from avoiding percpu caching.

To sum up, after this series:

- CONFIG_SLUB_TINY is a deprecated option that has no interaction with
  other options and only controls the default behavior.

- New slab_tiny boot parameter controls the functionality (and can
  override CONFIG_SLUB_TINY in both directions).

- slab_debug=N can effectively achieve most of slab_tiny and on a
  per-cache basic

- the implementation is simpler with many ifdefs removed

[1] https://lore.kernel.org/all/CAHk-=wh-k04MsoEC0SGKff2Snm6bBF_e+0pHOKwaWv4umZ_SnQ@mail.gmail.com/

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
Changes in v2:
- Rebase to current mainline (with slab/for-7.4 merged)
- Stop triggering nohash pointers due to slab_debug=N (Harry)
- Stop preventing slab merging dues to SLAB_DEBUG_NOOP (Harry)
- Link to v1: https://patch.msgid.link/20260923-slub_tiny_rework-v1-0-a0e66d536eb5@kernel.org

---
Vlastimil Babka (SUSE) (8):
      mm, slab: refactor slab_min/max_order handling
      mm, slab: introduce slab_debug=N
      mm, slab: rework KMALLOC_RECLAIM handling of SLUB_TINY
      mm, slab: make SLUB_TINY handling dynamic for sizing decisions
      mm, slab: convert CONFIG_SLUB_TINY checks to kmem_cache_debug()
      mm, slab: remove remaining compile-time checks for CONFIG_SLUB_TINY
      mm, slab: add slab_tiny boot param
      mm, slab: deprecate CONFIG_SLUB_TINY and reduce its Kconfig effects

 Documentation/admin-guide/kernel-parameters.txt |   4 +
 Documentation/admin-guide/mm/slab.rst           |  18 ++-
 include/linux/slab.h                            |  17 +--
 lib/Kconfig.kasan                               |   2 +-
 mm/Kconfig                                      |  16 +--
 mm/Kconfig.debug                                |   2 +-
 mm/slab.h                                       |  32 ++---
 mm/slab_common.c                                |  18 +--
 mm/slub.c                                       | 167 ++++++++++++------------
 9 files changed, 140 insertions(+), 136 deletions(-)
---
base-commit: 5b0764a53235d3c77e1ed674e836e1b3fe1a4b1f
change-id: 20260911-slub_tiny_rework-8f2634dd17a7


