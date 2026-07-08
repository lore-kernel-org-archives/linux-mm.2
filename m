Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E77F6C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 16:51:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDBB76B0093; Wed,  8 Jul 2026 12:51:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8C546B0095; Wed,  8 Jul 2026 12:51:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA4E26B0096; Wed,  8 Jul 2026 12:51:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87FDE6B0093
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 12:51:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EF95C140206
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:51:23 +0000 (UTC)
X-FDA: 84966200046.27.7797872
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1F25118000E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 16:51:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G2AEW2yS;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783529482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wy0zRs0iHOEqGoZqY8flVlrypFtpLWv9a+F5MdRc8/U=;
	b=hTA44ua4cXUAm+v8mAuLu2+f5G7acKJ1mv9GNKpixyo2mZmBTbsml4gwaJvdh1VPDz1z5I
	y4hR8/Wow8IZbvaKXIn39bydWfNtsx5j9hs7fE8WzAvgPeHq+fCXwjDC5nBX4mq9LO6Lvy
	ryiGFn7/DaWNV+pHjmlw+V6REXpyCkM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783529482;
	b=b4+zNoCq18A1nyLdpWnC7boIf6Ae+V82COCP42OmGsH/I6afCeW01b4ZssJtUCHuAmCP+U
	yrHkuRWb+AdCeO8FO9Zb8q3Myvg0WbNYk229Y92d3wI362s7fFemr5s9wdjTDwMqAXsdqy
	Z9CRpjjCwD6DXTb2R/fSq9yVkLexbkM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G2AEW2yS;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D01B438BC;
	Wed,  8 Jul 2026 16:51:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31C91F00A3A;
	Wed,  8 Jul 2026 16:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783529481;
	bh=wy0zRs0iHOEqGoZqY8flVlrypFtpLWv9a+F5MdRc8/U=;
	h=From:Subject:Date:To:Cc;
	b=G2AEW2ySEn90UzrvQCpkM6Q+j1L/83GPtqvTZsBNXrlV0bxDG/M/GjBWWf9qrZFrP
	 pMuMHBvTDnSqtgdwL+H2PtTVX/OWfBxMdQcbiqajGcxEGMDhw3xhzqIOYQKQsjcEJW
	 YLLhawnCF4LGVm6YtWOLaY7PZgndnGXLAA9KQNcmgRnF3CqdseOBh5HJvBY2s/LAFc
	 VUEFoqF+rGumBfxnFp9qtZS5RJD/K1sjpG6qf5vv/cKdsewC05af2uKaRxgn5YVwaK
	 fihX6XCVGmuLZX0saPX8V40UMDMYZjDgw0THH0k+Rb34lSI4a4j4bxeWQhT7gmHASx
	 ABM27GSdvrTgw==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/3] binfmt_misc: use RCU for the handler lookup
Date: Wed, 08 Jul 2026 18:51:15 +0200
Message-Id: <20260708-work-binfmt_misc-locking-v1-0-a009dd5b56db@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAOATmoC/yWM2w6CMBAFf4X02SW0XiD+ijGmXRZYkdbsIpoQ/
 l3Qxzk5M7NREiY152w2QhMrp7iC3WUGOx9bAq5XNq5wp6IsKngn6SFwbIbxNrAiPBL2HFuwx/2
 hrBvrCCuz6k+hhj+/9OX6Z32FO+G49bZH8EoQxEfstmnwOpLkU5k7ELRmWb7dD75kngAAAA==
X-Change-ID: 20260708-work-binfmt_misc-locking-15347df12ec8
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=3147; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Sxy/gcZwE0shEfdof4tpVTMT+0mLMtUkiNwr1Sz+FnQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT5NbD3sEYcjZMWk3w6ryT6KNN+DUHzaQlRn1oCS61CN
 Vb4XHfoKGVhEONikBVTZHFoNwmXW85TsdkoUwNmDisTyBAGLk4BmMiVFQz/4/8tn7pOxS0g7On0
 hoxnmgub+Hwy9vicjddwW/419PC+xQz/bI5MZ9tnyRenc/jM4fOp079PP/f0euDeM198ZvUrbjv
 3lxMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1F25118000E
X-Stat-Signature: h86ya1itj96bkbk7iwmmehgffaxca7z4
X-HE-Tag: 1783529481-3121
X-HE-Meta: U2FsdGVkX18tuFx3JwGeJAvru4AnE8okUJ3cpqciVHhRnmxeG/jsbJ1Cx6eWcEXG64hndGc8rMw2c+Q6+jMVPUzt00S4wZ3kgz0F25eOvuq8JKs4J7IBsklBFeJL6J618Eg470itScQDeUPS+Okz94S/CHMqSj7DOI1u9JROh+7gOck9I1eTiaE+VYOIB4P3MiJ5Iwjj21tRrC8Sef4mD4HWLlf/cWBDJPLVg2VrWIMVQsqqNcOSVBdDRs+3g3E+x5hVhWbW+sdh/sEbkEu1TxjHiVbT/Ybj3OXziRtxzPo6Qj8n8jMZYnxJh//lOB/KaABd9bIaJiQtkEQGVmbZeFrf2sHmCElPf8qpVxprYR/GXIp+vsmt0s1gYBiK6uxt1Zt7x3GWwQMCx2+t5h4GyMGpfN/Lilr4tmTo3jsMG+USWNodj+jEUfjo3BA6DQUOtO7eD6ZCGXaCADen67kHsWfx1Kq90r+jMBuZwCeQkJ89wyHzZUZ0Lx+NNMULV2vBRKwvRnCl0rTMpTS74Tshs2ePwTRn7DELrjQf950h+Y3hK4zmeoDDrzT3N/C3MuqS40vINAEe3OZ3eY26W5d5b4Mg72UxOlJEuAiz4RdrXyLFLEAQXDGD3kUsf/XQ6O+f6vyhmCwOOg3mj7OFpMYvSGdnZE2Kg65eFQ9W+m227SvR2gXl98Y4w/YYPNFNktTaXaavM2nMTF1at/eZJfFttVJEJ8dBF1Y69ukFrU+WY4/H+eoTKjxX6vWZtSJpfKnr6zZwaYhe1c8WBia9XnNL6lTG41Vn5+OIr50ZSLfFS+wY8R7nbx80gBvNgXu8PAXeJyKGbzaVHy6k6//YSCWTkIhOz4Me5pRLcLHDD7sI3srkXRqj9X7zHtrN6VsjSNs4rC13myDC0/d4wTa7r2l+jaWwzE2b1HK6zc51RQ41JaHBlaORQF4ksl4vqsV2OoJDvrqB25pCgdd4YJRiAEs
 e5ihcMDt
 zuecsQRVTvDJYdnxoFmkzeCDnF80w9+a3XYnA0eSqI4b2wmrM2OUIX0ISHi6oDg48ki+b9BiCFzqFcO7s11mMEAxNtIormZPutOLApeVSokk/hQouHwMXTKOiQI3wv/+QJ3Jbmy58pQK8gPs0xhggiQuIdHInruufDXvJNuVqHhDEyNjAag7kO7egRN/A/p5aty9s/4ncl6R7VTu2cZ+vESA4QXczj6aEQRR6Kr8P+P6VtCm74Fy9Lvk9WPCO5XLBoEAxpbuBDl7adkhyww4HHt5sMEsUOoUOh0n2/KantMhOrcR52DLVN9Wfix+r3g6VohZ3ifyP54p9cZsq9iwxtxU28cFs4ut/b2vym6FVIKBffG0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Once binfmt_misc is loaded load_misc_binary() runs for every execve()
on the system since binfmt_misc registers at the head of the formats
list. Every exec therefore performs read_lock() and read_unlock() on
the entries_lock of the relevant binfmt_misc instance, i.e., two
atomic read-modify-writes on a shared cacheline, in the common case
just to conclude that the binary matches no handler. User namespaces
without their own binfmt_misc mount fall back to an ancestor's
instance so on container-heavy systems every exec on the machine
typically ends up hammering the cacheline of init_binfmt_misc. On
PREEMPT_RT the rwlock additionally turns the handler lookup into a
sleeping lock on the exec fast path.

The lock protects very little. Entries are immutable after publication
except for the Enabled bit which is already toggled locklessly via
set_bit()/clear_bit() and entry lifetime is already handled by the
users refcount. The read lock's only remaining job is to make "the
entry is still linked" and "take a reference" atomic with respect to
the unlink sites.

So make the lookup an RCU walk that acquires a reference via
refcount_inc_not_zero() and free entries via kfree_rcu(). The removal
paths need to detect whether an entry has already been unlinked and
rely on list_del_init() reinitialization for that today, but
reinitializing the forward pointer of a removed entry would make a
concurrent lockless walker standing on it loop indefinitely. hlists
support exactly this pattern: hlist_del_init_rcu() keeps the forward
pointer of a removed entry intact for concurrent walkers and only
zeroes ->pprev with hlist_unhashed() serving as the linked test. Hence
the first patch converts the entry list to an hlist so the RCU
conversion in the second is a pure locking change.

Writers remain serialized by the inode lock of the root dentry with
one exception: bm_evict_inode() unlinks entries during umount without
holding it. A spinlock stays around the unlink sites to make that
exclusion explicit instead of relying on superblock lifetime rules to
provide it implicitly.

Handler removal semantics are unchanged. An exec that acquired a
reference just before its handler was unregistered already completes
with the removed handler today. The read lock never protected against
that, it only made the window smaller.

With this an exec that matches no binfmt_misc entry no longer writes
to any shared cacheline at all. The last patch annotates the
long-standing lockless ->enabled accesses for KCSAN while at it.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (3):
      binfmt_misc: convert entry list to an hlist
      binfmt_misc: use RCU for the handler lookup
      binfmt_misc: annotate racy accesses to ->enabled

 fs/binfmt_misc.c        | 86 ++++++++++++++++++++++++++++---------------------
 include/linux/binfmts.h |  4 +--
 kernel/user.c           |  4 +--
 3 files changed, 53 insertions(+), 41 deletions(-)
---
base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
change-id: 20260708-work-binfmt_misc-locking-15347df12ec8


