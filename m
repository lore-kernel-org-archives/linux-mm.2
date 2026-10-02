Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24734CA5FE3
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 23:11:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEB086B0088; Fri,  2 Oct 2026 19:11:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC0A16B0095; Fri,  2 Oct 2026 19:11:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EC4E6B0088; Fri,  2 Oct 2026 19:11:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76E246B008A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:11:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0AB59807EB
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 23:11:36 +0000 (UTC)
X-FDA: 85279234992.10.A460827
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 750B11C000A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 23:11:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WX9OTQZ5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790982694;
	b=BiCZTdpTZJ3Kyqo7++e2hamiJFtDX/T53AHyDFQ+gg+bt0h4WgphsllfQi4MLmKxCB/irk
	jJ9CXMba2cxsEfqbZJ/nyhXLx4ZUWrvcf2aUc+lfxHkaz5ckj0MxYed7LcxRNl3fJX7GqU
	APkCEAojmu5prqhpcJKDmZ5z10GY+/o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WX9OTQZ5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790982694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7sFn9nTy/0M8Manz3Ov3zjSMZmnOUPsuIFDC5cAOrJM=;
	b=0B0M5eKHDJIi3vDbwQXOk7axJ6VIw0lwnD0NUb8C4hKCeYtt/w2Kn8Lkk3h5JGwnKLuOxp
	dxjGWcue4aQQ/P1k2XnsHPOgI5qh+1ZNzjm45q6Fbx/08cupT3kiEL6vQ2AAZgrKCy4ooB
	EtIPdpuYDzQcOY9uyjmIGWFF5csfLHI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E6FA60214;
	Fri,  2 Oct 2026 23:11:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2404D1F000FF;
	Fri,  2 Oct 2026 23:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790982693;
	bh=7sFn9nTy/0M8Manz3Ov3zjSMZmnOUPsuIFDC5cAOrJM=;
	h=From:To:Cc:Subject:Date;
	b=WX9OTQZ5f8MIdYmno3tB9LVcEkBK9w0haMdscxstPKJcdFV4qOehzGOmGJNwZlcwt
	 dMFoUuAYtDw2pltFdFTdaIKCTyfF1ajGwCNP9RPaX3y7MrzsuyMR2hSoMKiEK+tb6T
	 oMuiVqkKd2l3QX4RPkoOrEV9yi8CyffejJPJYXBpeYgSZO+i3hJze3d0VszgUBrkwk
	 nlcBMCsndQzgKso02eemH/h1Y3dcUreRZrur82oIvV2Q/sR9OWdWTu4nOB2DZPT6P0
	 N1Je91CKwthhBMW5rx9tB4vxCPp4R56z69aQDnYkkgIOB4yb24VDs9kmrnb7nwXT2x
	 Uv9B0rGCD9jaA==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Mina Almasry <almasrymina@google.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH net-next v5 0/7] net: skb: isolate skb data area allocations into a separate bucket
Date: Fri,  2 Oct 2026 16:11:20 -0700
Message-Id: <20261002231120.late.500-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2360; i=kees@kernel.org; h=from:subject:message-id; bh=QjrjRWiPlStTZ9Cuw3ASdtaVlT3rP0Cd9M68tzV6oRw=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkHrGR9+dt+TX8RuXLy0ftnen5dUAvbvKa9NHnuvgfvT ypcdj9U2FHKwiDGxSArpsgSZOce5+Lxtj3cfa4izBxWJpAhDFycAjCRpcwM/wwnFZT98rzaMseu b8rJo/eubXjut/Gj8kRtPh2x/nurWJsZGXbFVO0SknljvMD45Yfpx6w3Hz+7deXGkC+T22bxZU1 fwsEJAA==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: xffcn8irtabfc85khbbyezobpjhpstao
X-Rspam-User: 
X-Rspamd-Queue-Id: 750B11C000A
X-HE-Tag: 1790982694-566561
X-HE-Meta: U2FsdGVkX1/s4Xocrw6f6f3I4wTTwU9dXKivJrm6fXprUzeUZv+EbS4/4NKizpGi7/ajmbtgZvG37gImX3LdfvVcJ4A+OL1r6bCjJYtwDR0zUTz5NXgTxSdJyzzWCFemSn+Umr/B0Wn0B85mxEPSdhGJgpR10aR4gRHLYuGF1o7pia72t9ixHkeeyQOOrcUNelyv4W+fOcDwU9kjl60qAu4CvA1e/H1XzMf3kiCerD40Y5tZ3Di8KVNw1biK9ddweDhhL2WNuGvJSVDECXLQ0LWki3hXWAJQuep+AeHMy/Qi96uncHgnZFIekoL7RqR36ogFKRITyWM+/qx0gwB4In8OBaAHbS1qIsQijVw9IX3tkCXQQBcHMW35BqjL6dFzadQbbKExuDv1ChfHyyGVAd+bjYlhUA19/KYFO0SsuNL2CK2hcL0oV98FndtgdBfx/RKGQvD0NVYgewIMbSmP5COYGDct/Gx+onoPgVkFFEpEiAoq0WBj9fRcbK2Y5q9V8DZfGcJo8ecmtdWKboWdua9+U+HHr9HQpGrOP1XJM/+Ii0SOetHrhvjAOOttdz4nl/gf6kdWbFzWue7OnUQ023rYhvvXgBhgkeboUkpQDFyWX23s0G3j78W2LRdXfVkeXhelH2ASuGn19kPv84vtmQb5LXno0Prcxdg5jWZ5CeTAUdFWgR0WpvfTLSQNf0c0SKx4G2+vp6rv9NZcVRFRSsjCwMxwsmw6c/qNpm1lX0cdey6EXM9yy2LYQ/CutkFzXlbFE7leAPnvQq37J43d9p/x5HdWMy+HEhXnGtY7kNzfxYZ5GmAGHe34x7LpXZGg4XkTGE4QuOYbqATPb4VX3r4WHl8MilxqOXw1ihhIgjJUGA5rxIvOxkfIutMZXLnL91WqYOgUlP/t2B/tp4+bzsQHFE560pdBs2rJ51q/5sCFSHuyQ4twETevwlIlpr29YV84F6CfAtVVHypzbOK
 jgRz0DsL
 q/2y3lfEJmyh5O5yioWW8V7C7ZhkcE4pxGj6FuBAw1tRiENQ3Ig6EyJ6bFuzeg92HHkco9w/MF7UFXbeXIf+/09g7XjsJsJQuHG9f3+bwSAtlefzgO+QAD9FuVWt3A7VWJN+SPyxP/or5tURVHVIkzZuhI/MocNnjUHYYCZoaucksmC9bMbga5jOVih5tXRT8yCQ1yCJ0ssTS4Ajs9oYVqbZM0+8RuPpE3k646/mTEC5hbfE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi!

This gets the buckets able to handle memcg (GFP_KERNEL_ACCOUNT) with
isolation (since it's common due to AF_UNIX), and GFP_DMA with fall back
(since it's rare). It gave me an excuse to build out bucket kunit tests
too, and that (and LLM review) found a couple other issues that needed
fixing too.

The bulk of this is mm/slab, but the final patch is netdev, which Paolo
acked in v4, so I'm hoping this whole series can go via slab?

Thanks!

-Kees

 v5:
 - 2/7: kmem_buckets_create() and kmem_buckets_create_types() take an
   alignment, where kmem_cache_create() has it; 0 keeps v4's behaviour,
   the alignment of the kmalloc cache being mirrored. All callers pass 0.
   New subject: "mm/slab: Let kmem_buckets_create() take an alignment"
   (Harry)
 - 4/7: test that an explicit alignment is honored.
 - 5/7: export mem_cgroup_kmem_disabled() for KUnit only, fixing a
   modular build of slub_kunit (Harry).
 - 6/7: commit log shows the per-set cost of indexing rows by
   kmalloc_cache_type; test that an explicit alignment reaches the
   accounted row too.
 - 7/7: pass the new alignment argument.
 - Collected tags on 1/7 (Harry, Pedro, Hao) and 7/7 (Paolo).
 - v4..v5 diff: https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/diff/?id=dev/v7.3-rc2/skb-buckets/v5&id2=dev/v7.3-rc2/skb-buckets/v4
 v4: https://lore.kernel.org/all/20260921075811.too.775-kees@kernel.org/
 v3: https://lore.kernel.org/all/20260702170728.168755-1-pfalcato@suse.de/


Kees Cook (6):
  mm/slab: Mark the kmem_buckets_create() context as a Context: section
  mm/slab: Let kmem_buckets_create() take an alignment
  mm/slab: Add kmem_buckets_destroy()
  mm/slab: Add tests for the existing kmem_buckets behaviour
  mm/slab: Provide kmalloc type fallback for bucket allocations
  mm/slab: Let a bucket set handle __GFP_ACCOUNT

Pedro Falcato (1):
  net: skb: isolate skb data area allocations into a separate bucket

 include/linux/slab.h   |  66 ++++++-
 mm/slab.h              |  44 ++++-
 ipc/msgutil.c          |   2 +-
 lib/tests/slub_kunit.c | 397 +++++++++++++++++++++++++++++++++++++++++
 mm/memcontrol.c        |   2 +
 mm/slab_common.c       | 173 +++++++++++++++---
 mm/util.c              |   2 +-
 net/core/skbuff.c      |  11 +-
 8 files changed, 663 insertions(+), 34 deletions(-)

-- 
2.34.1


