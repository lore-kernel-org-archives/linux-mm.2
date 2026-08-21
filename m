Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 828A4C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 11:52:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B8826B009B; Fri, 21 Aug 2026 07:52:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 668BB6B009D; Fri, 21 Aug 2026 07:52:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 558D06B009F; Fri, 21 Aug 2026 07:52:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 260AB6B009B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:52:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A808140434
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:52:25 +0000 (UTC)
X-FDA: 85125113850.07.6BA5C37
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id E168B40003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:52:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N87+Z5et;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787313144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rb7T7qQ245v3lAPAAQlownuvidcAdgxgItOpVQHp7Vc=;
	b=GP+hZjZj+zqyhZo56JvJDEdRTpk6/ZpamZPc64Su1isig9tcWf50hVAEv8s43+P1aDuKhe
	mIN6Iqi31ch4vDC6Fvb4LkdfeIPwiUOiYnn7+RTLTzIbfsc+hYs1sVzbeZWGIpUkGJgCEW
	N3CF1+NJhJYR+JymSvNe0kpIiFCHNbM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N87+Z5et;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787313144;
	b=GAWZ8K84RDIn5+rfILyvHbaqBTxrFlWX38Qy2+NYVUnxy1LCI3Tfn+KzU9iTK90BPByslu
	zjswYVpSde5C5IOtj4FrTWR6k4shwaURDa/I6yV3zWLGKjeo2xA0tw7Eee8skECrW1CRGA
	d8SCZ7gixXSK32eeGn2faa2zV/QG0oI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A1DA43540;
	Fri, 21 Aug 2026 11:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8F41F000E9;
	Fri, 21 Aug 2026 11:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787313143;
	bh=rb7T7qQ245v3lAPAAQlownuvidcAdgxgItOpVQHp7Vc=;
	h=From:Subject:Date:To:Cc;
	b=N87+Z5et1fyU2ko/O1Cr71bw/e1K0Y7lpQCiWriodjuayeS/brKGIl1542vcGrf2Z
	 xge0SPDDp1GQRsiBorLLtEdwFaStNffwCFw2LumAYgWUg5Mzoczk1KqWRChl/WM4Ri
	 F7nT2FMjO4ukNidMdBUFSBpPogxm9NUCgtRcL7reZ1ilzpx6ku00PTiLZPQBUK90pD
	 HitWCGTO62xHJaJFosV+UPcOk+Zr8uOAI77jkhDKJxuoBcRm5IDqSVDdPfDuaocAH7
	 IIRuv87wFvfGEvqQP1CyLnVpNDExhYjEorWyBu+krI0/kRMa/VepjtBKni1PpZUBU0
	 3hh+8ZYVXFSgg==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/6] coredump: select memory types per request
Date: Fri, 21 Aug 2026 13:52:01 +0200
Message-Id: <20260821-work-coredump-filter-v1-0-91f9a73ef03e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/zWNwQ6CMBBEf4Xs2UXaEKL+ivFQ2i2sYku2oCaEf
 5dKPL7JzLwFEglTgkuxgNCLE8ewgToUYHsTOkJ2G4OudFOdtMJ3lAfaKOTm54ieh4kElT/7qnb
 katXANh2FPH9+t9fbzmlu72Sn/JUbrUmErZhg+xxF4Y4DmmE4ZkH5F5S7oMx1WNcvIfRFQK8AA
 AA=
X-Change-ID: 20260821-work-coredump-filter-1f9f04ded416
To: linux-fsdevel@vger.kernel.org
Cc: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>, 
 Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Omar Sandoval <osandov@osandov.com>, 
 Jacob Lalonde <jalalonde@fb.com>, Shuah Khan <shuah@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=2728; i=brauner@kernel.org;
 h=from:subject:message-id; bh=CHr7/siqtsybsuSIZJlmc8HwuFWlZjKE7BJt0/blPig=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR1WH/84HubVVHmBJtE9xLerU7/XEQL7/bYs6czXBFxW
 aq6+FJ/RykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwEQ+HGH477Pw8fqop+wVjlsn
 bN7mr/gu5QRj2sXG7JbMFf8OfxM7GsvwP27l7X3GebocW1vniZotDclou3m9Y+Xs6tXn3hSstfn
 4jA0A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Stat-Signature: 88zwminsoun5exiqfx43ch6bbh6k81mw
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E168B40003
X-HE-Tag: 1787313143-499480
X-HE-Meta: U2FsdGVkX1+zARtNP8unmk0NqTnDMPU//PwnM4p0Lt5D86b9+MhLXa57W8ouMlJ092yegFqWvwqqb4DQb/f/2TvCNQi8s/24oxAsqJJAM3fTFCJPIGKOGrLW14ai/zdHvuTQyYIKuRuK0OkOkOn3UIwGQgtYcs1f33eWvyClUOYh/hZ0O+4UNbevr6N8EHwZb/B3MgaPCwtCNJPqx4In4DCQm4YOOnJ8rPTCg4qri5jzh73rD6xUf86uL67p1+O84LB6RC869bUGcpRFIh41H3dzn3ml0vCRnVT8aCC0SAsiwtJZBRkdcCedcY6a0OQNgL6PSN3im0623No5w9Y12MgbN8hePfdqGWalRazkWOS1PW2Dd7jwsj2z+xDtVD0SbytjaB5PvsI6RbbrKCh2Wkl+DxLFc5URBt0TiBPEL30xfcMKv6hY/+A1ht8jJZjodDMDhSRNOBfLDaw1E8H8MkUGhmzLT17IojAIatG61Sz6Xo3sstVdOn1ICv9jXpvPjP+jSoe09DZQBJ8y/hBmYQmYZicE2DoB8xs+0hmwjYpYIaGIDbTZA3JDaW/f23KE2sv7VDFJqoKEmUyVdYylSfMWR1dXbB3xLVYiT6thhQ0crmRac/SWZyvMmYwd5IOVxlK4r6zSkurN8Pcs17b0EvJjV/EkzVyV88JNbFDC4Sv6RtIUIAdAGpg8pROSRbjLbypK9IeMUk4N5+MHDTsnFAvMK6pcBKq1iuWYsFeZ2URNuiFVs91X8OxrL0YH6wtHLxOlARCqTkDRvcchoyIpwRVWGnbixeQ6dlSzeMO3ixOmlUSa1H7sFhGP3j2LLWbEItDfIgoHWUGv7fF/DOF8jXECnjUmZ8p5upnJKfRFIT0OJms4Nb1lNaIEbyQD6w9q5C/3ah7hhl56CmNI4xYJ3vZxi58K41hM/3MLiABkQy+JAcGDNy3p5H9NHBFJ1Sny4nvhyY/ZQpwa+Rtqkey
 Rr4M/GgD
 RqGquObeqzt50qtVG48DlY34nIpivDh8S0eLKU9DamrVUSwOb8FFKCCC6ULwtuciR/P0EZIbO2IYTi4Afrw585L0gLdltSPn2dmV+oAw6xy54aryH2Rifre0t6lBc2HnpYAr8fTNw67y3P5exEd4acEJMoZszPi1YBsPkH4XaYA1vn/OoWS8bFBqeK13PukhxoFpMKKpGH6J4Y8TGVCufxTPgJRmT1u72faALl9c0gw6Cyz/zMOXMgciDRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently /proc/<pid>/coredump_filter determines what types of memory
are included in a coredump produced by <pid>. This is fairly static. The
coredump server has no easy way to configure what memory to dump even
though it can figure out all the necessary details to make an informed
decision.

Add a new COREDUMP_MEMORY_TYPES feature bit. If the coredump server
raises it the kernel will dump memory types raised in the
coredump_ack->memory_types member. Zero is valid and causes the creation
of a coredump that just includes the program headers and notes but no
memory apart from the mappings that are always dumped.

struct coredump_req gains @memory_types which is set to the default
memory types that are included in the coredump. This can be overridden by
raising bits in coredump_ack->memory_types. It also gains
@memory_types_mask which contains a bitmask of all memory types the
kernel knows about. A coredump server may only raise bits in
coredump_ack->memory_types that are raised in
coredump_req->memory_types_mask.

struct coredump_ack grows too. If COREDUMP_MEMORY_TYPES is raised in
@mask the kernel dumps the memory types set in the @memory_types mask.
Zero is valid and dumps no memory apart from the mappings that are
always dumped. A coredump server wanting to add or drop memory types
instead of outright replacing it should simply copy
coredump_req->memory_types and then mask off or raise types as needed.

@memory_types must be zero if COREDUMP_MEMORY_TYPES isn't raised.
COREDUMP_MEMORY_TYPES requires COREDUMP_KERNEL and an ack of at least
COREDUMP_ACK_SIZE_VER1 bytes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (6):
      coredump: select memory types to include
      tools: sync coredump.h header
      selftests/coredump: simplify the refusal tests
      selftests/coredump: test COREDUMP_MEMORY_TYPES
      selftests/coredump: improve coredump size negotiation tests
      selftests/coredump: test failed handshakes

 Documentation/filesystems/proc.rst                 |    4 +
 fs/coredump.c                                      |  114 +-
 include/linux/coredump.h                           |    4 +-
 include/uapi/linux/coredump.h                      |   70 +-
 tools/include/uapi/linux/coredump.h                |   70 +-
 .../coredump/coredump_socket_protocol_test.c       | 1224 ++++++++++++--------
 .../selftests/coredump/coredump_test_helpers.c     |  279 ++++-
 .../selftests/coredump/coredump_test_helpers.h     |   26 +
 8 files changed, 1274 insertions(+), 517 deletions(-)
---
base-commit: 19f075830e5d874749f55d837fc4e8af98df0559
change-id: 20260821-work-coredump-filter-1f9f04ded416


