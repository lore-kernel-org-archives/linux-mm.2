Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AACB5CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 16:24:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC2096B008C; Fri, 15 May 2026 12:24:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D72D26B0092; Fri, 15 May 2026 12:24:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C88E36B0093; Fri, 15 May 2026 12:24:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B8CFF6B008C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:24:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 842FE1A01A0
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:24:42 +0000 (UTC)
X-FDA: 84770177604.01.26EF36A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 81BE914000F
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:24:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W5DCg2tV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778862280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=u3HojV8p5iOKy4UiQbbvcKMalVff0dwKYrIXuv6CC2I=;
	b=T7C50JwzV9FsR1pT3EMr1DlUiCyLo2pU7PhxpOcBWk7M+nCLPmrwpp05cv1XbXoH3TxlVK
	4GwkPg+TZHTVHm+b5kljn6U/dO6iYS/eJQueVdVO774bc0+rm1Q4+Et/w+uivInxBirpO/
	V68XzAjqibjakib0QBz+8CeMddn8TLU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778862280; a=rsa-sha256;
	cv=none;
	b=KwLxnHH8qe2GNb+Qu4QfpfPuSHlkTp9BqglcvPBhspcfJpk4d2K/sOA3/GKmdA3ODlbaU6
	EQ8soQyrj4cqYz8sVKFTEowGqKVgKKXcNbjT7jwUyFr8uKqrFkoSJpHRl+b9r/jEH4jAjQ
	HIS7x59TWOSeO1DPhsiaJxOObqH0UbY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W5DCg2tV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FFA143D1F;
	Fri, 15 May 2026 16:24:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C846C2BCB3;
	Fri, 15 May 2026 16:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778862279;
	bh=dupM0PA/sb1sG/NMXe05FuF98ugxfzwE++GzA0pjfLE=;
	h=From:Subject:Date:To:Cc:From;
	b=W5DCg2tVX636R8GC4Jkqff0H+6I0x3wWwfdZOUcd4W3BHjKgyBJlWY91Aiic3sx7C
	 F73JVsZiLKn5ftxAsrbyzx4x+JozThPi6BYbHG7GXDTgFsh4V5ShYTWq9xa67VeKj2
	 kmyBktGptL0pwuMp6WatbPqXJf1LEcOS0GtWsuqL7PkhVSRAeCslHuH4paYi31cya8
	 TOHAg6B1rXPL3+iMGoHIHOHjRxIdth/Je3/Q+ad100uCmg+nGwXiGemqf1LXNXFZ2h
	 wmQjlrXts7Eu6y0aRMrlsObiTO8hYW8ELAMK7WgAWoaAuuyDNhB4x1gZLkhFvUNmNs
	 1Le4x3LMuixwQ==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Subject: [PATCH RFC 0/8] mm/slab: enable runtime sheaves tuning
Date: Sat, 16 May 2026 01:24:24 +0900
Message-Id: <20260516-sheaves-tuning-v1-0-221aa3e1d829@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALpIB2oC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDU0NT3eKM1MSy1GLdktK8zLx03VTDNAtL85Rk8zTTVCWgpoKi1LTMCrC
 B0UpBbs5KsRDB4tKkrNTkEpBRSrW1ABHCp7t3AAAA
X-Change-ID: 20260515-sheaves-tuning-e1f897dc7f5e
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>
X-Mailer: b4 0.16-dev
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 81BE914000F
X-Stat-Signature: aym66tsds1p415u3jndr4hxbujoibdzs
X-Rspam-User: 
X-HE-Tag: 1778862280-330342
X-HE-Meta: U2FsdGVkX19prgySIwd+HNrxz666vVUbvWaANCi154TCuWivVF7mLEXmwDorPbwA5X/3LdePuoOr6vbp2Y1fCZbOxL6m+WK3Bs6iNMvnjnNONjFgvrPzdglfU3NUgi/KFd9F3d8Jzrj0uxLYesi8TxCQ+85Rsm2ng+gdJZKzW0gK42qmru5pnK5kB8W9DJJLDEZpxHTN4Yr2DxFfMtunSRQn7E67N0LuW4RQpK1eA+3fVyvrBCv9FxkCcgSZNt0ToKe/pM5ZHtVTWpslo6f6hLq0F077wlycqPl8/Qp2x3djJeyWC8af6WNOCeN/6bVTmzsK/R2v8n01voIS/oiOEWSWScpXgqwXp0SlNG9SYrTVQhhS7HgFgTVFYfLrjkZVPwrUPWqJwVihY/OpQ0vLDzhHdL7bLABfimiV0kL3peswIAxRksBNhPEYW772pIUP1uCf2PCTQ3b+/xFbQYHYidyctCnzFnYIndYnY0wRvoBcXWb9i8UOub038hyAEEunvGboFMoADudJ0y0RtbzVmezSO+FH72fPwgv3us2hYvVuglmrOGAmPWyq8L4u30QDNBbyf4Si/+mVNFcl030Nrxb+8qLbtA6JoCzDAA+8jVFo4UADquZpLojnvS3fNGQr4KoteEdQJQjUyCmqs6rB7aogtjgcepdcOtQWrC8LVXNaAOKEC9Km/9awCXEqUfhORMbzFVOee+pSPrT537F1eLmAGK2PQ2kPyjNZ/zyziqht3a9Dl22LTKDy8vNs1dxxU+2Y8uuPq+ZGAeHQjLez5evP3aRXWGJXCfaYme+wrQvpJvrzIx4I8vhbf0vjvUkjmGxbRRYSC0mkdJZ4OVHVotMHzC8cHC5H1mMhfITN4X3J6DMx4UZXadmoqNi1n5uI6t9/BhvzU6SednW+eicZVTwtWwZn7m2mcKX/KFxYmGBDw066L0B13FiA6KNkI9iSy8Z5dGkWmhyCxLe3asc
 WVG+wJb7
 vh4IPGPX4a9/kwhdHhV/MGNE52FSXQLhaIFN1a0Wj9Jeu4VvPfffOUaEnn7ICmlKpIxoHzb9ENsXOigeP4OYtT+DNaAK7bZ3Tl6/+0edxzNCNKf3BfPfNGVJ/qMJz5aFUOLziPr56tmVz15Mm0dTIxMtXHgdC6UW7bVGvb+L4fJsgFPN4YVEQ4SlUB4eJ29VWy8IAhoBT6r2oExcrj3u4GNSRU6WR4qC4G4jshL1hSPFQ0/rhSDQXvnWDjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Background
==========

Sheaves were introduced in v6.18, and starting from v7.0, they are
enabled for all slab caches (except for kmem_cache{,_node}). In the
pre-sheaves era, there was a cpu_partial parameter to tune the number
of objects cached per CPU. However, sheaves don't have an equivalent
and the sheaf capacity is determined in the kernel code.

The goal is to allow tuning sheaves at runtime by the next LTS.

Overview
========

This patchset does two main things:

  1. Make the sheaf_capacity sysfs attribute writable so that the number
     of objects cached per CPU can be changed at runtime, and

  2. Expose MAX_FULL_SHEAVES and MAX_EMPTY_SHEAVES as sysfs attributes
     rather than constants, so that users can tune them.

Measuring the performance impact of these tunables is TBD.

Roughly, the sequence to change sheaf_capacity is as follows:

  1. Disable sheaves. Make all online CPUs replace their main sheaves
     with the bootstrap sheaf under local_lock and wait for completion.

  2. Wait for all in-flight RCU callbacks to be processed.
  
  3. Flush and free all existing sheaves.

  4. Re-enable sheaves with a new capacity.

Challenges
==========

1. Allocations and frees can happen concurrently at any point between
   these steps, and we cannot introduce heavyweight synchronization
   mechanisms on the fastpath.

2. Currently, cache_has_sheaves() checks whether a cache has sheaves.
   This works now because sheaves cannot be enabled or disabled once
   the cache is created.

   The question "Does this cache has sheaves?" should be split into
   "Does this cache support sheaves?" and "Does this CPU actually has
    sheaves enabled right now?".

3. Once the sheaf capacity update is complete, no sheaf with stale
   capacity must remain. Flushing and freeing all existing sheaves is
   relatively simple, but under the current design it is quite
   challenging to prevent sheaves with stale capacity to be installed
   to the pcs or the barn. Reading s->sheaf_capacity without an
   expensive synchronization primitive is racy.

   Patch 6 introduces a copy of s->sheaf_capacity to struct
   slub_percpu_sheaves to address this. pcs->capacity is copied from
   s->sheaf_capacity and it is stable under local_lock. If
   s->sheaf_capacity and pcs->capacity don't match, the sheaf_capacity
   writer is responsible for flushing and freeing them before completing
   the process.

Patch Sequence
==============

Patch 1-3: A per-sheaf capacity is required for the following steps,
but I didn't want to grow struct slab_sheaf. So patch 1 drops the cache
pointer (which was used only on the slowpath), patch 2 changs
sheaf_capacity from unsigned int to unsigned short, and patch 3 adds
per-sheaf capacity.

Actually, the size is shrunken after those patches.

After (24 bytes, excluding the objects flex array):

struct slab_sheaf {
	union {
		struct rcu_head rcu_head;
		struct list_head barn_list;
		bool pfmemalloc;
	};
	unsigned short capacity;
	unsigned short size;
	int node;
	void *objects[];
};

Patch 4 allows bootstrap_cache_sheaves() to fail so that it can be
used to re-enable sheaves without panicking the kernel.

Patch 5 splits cache_has_sheaves() into cache_supports_sheaves()
and pcs_has_sheaves().

Patch 6 enables tuning the sheaf capacity at runtime.

Patch 7 adds lockdep asserts to verify the new rule "Always hold
local_lock when accessing the barn" to make sure there is no sheaf
with stale capacity.

Patch 8 turns MAX_FULL_SHEAVES and MAX_EMPTY_SHEAVES into sysfs
attributes (max_full_sheaves, max_empty_sheaves) and allows tuning.

RFC V1 is also available in git at:
https://git.kernel.org/pub/scm/linux/kernel/git/harry/linux.git/log/?h=sheaves-tuning-rfc-v1r1

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
Harry Yoo (Oracle) (8):
      mm/slab: do not store cache pointer in struct slab_sheaf
      mm/slab: change sheaf_capacity type to unsigned short
      mm/slab: track capacity per sheaf
      mm/slab: allow bootstrap_cache_sheaves() to fail
      mm/slab: rework cache_has_sheaves() to check immutable properties only
      mm/slab: allow changing sheaf_capacity at runtime
      mm/slab: add pcs->lock lockdep assert when accessing the barn
      mm/slab: allow changing max_{full,empty}_sheaves at runtime

 include/linux/slab.h         |   8 +-
 mm/slab.h                    |  40 ++-
 mm/slab_common.c             |   2 +-
 mm/slub.c                    | 715 ++++++++++++++++++++++++++++++-------------
 tools/include/linux/slab.h   |  14 +-
 tools/testing/shared/linux.c |   4 +-
 6 files changed, 563 insertions(+), 220 deletions(-)
---
base-commit: e98d21c170b01ddef366f023bbfcf6b31509fa83
change-id: 20260515-sheaves-tuning-e1f897dc7f5e

Best regards,
--  
Cheers,
Harry / Hyeonggon


