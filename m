Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B707CA5FF0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:20:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26F7B6B0092; Tue,  6 Oct 2026 05:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D2636B009E; Tue,  6 Oct 2026 05:20:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA38D6B0093; Tue,  6 Oct 2026 05:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D2166B0098
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:20:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D38816056F
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:20:39 +0000 (UTC)
X-FDA: 85291656198.15.882ED23
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5C30820006
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:20:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CVuoYX+y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791278437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UWdiWm/AeZBjUn1Ge2ocDynm/vUX0V3PYEyMJDJeYUM=;
	b=R9D9urieh9ww+vCiJSmCvYGvUzCPuZMjubjNnQUsqmhfAoGnByNoS4MH5vrJ++qgH28ItY
	rR7J1Te7At+T8K7OHJib/hNRl6xbF9c2c7ZUaVQJtwlAqc6Jqu8QQkUC9uIetI878rGlCX
	zdN+nWtNBlEvcDv+Ure9FpUj1iNRTH0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CVuoYX+y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791278437;
	b=jiie3i9q8025/SuCOo54c25x9hJxXgVSriRuFTzZ20oveI64oh4fgzpkj4UYFgGG9wqD4q
	j53yeXJIFuv/DVX2CxcpLIRJA6RCdtFhbUuUOETMPCZhWQQ+ybuYNYyonnvzXNYXjKujTZ
	PrNARELb8PbszVtdgqnDT2BAkcbhnWs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C4FB41738;
	Tue,  6 Oct 2026 09:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D291F00893;
	Tue,  6 Oct 2026 09:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791278436;
	bh=UWdiWm/AeZBjUn1Ge2ocDynm/vUX0V3PYEyMJDJeYUM=;
	h=From:To:Cc:Subject:Date;
	b=CVuoYX+y8Vr+gukSpcCxEQbbhTSWy/L5mHvb1sMV1kE2IfUWTiDJXkjhPokuaEqlp
	 o4FU9LWhcopNf2xTSPyodRjM1qg1/Mzm2Wh1K0UU+CO9KcG322EOvqHCu98bYfjECu
	 eL8QxLSiZdzNL87wCdvE2W84LKXmkuJza85xBzNrOodnO8iczZEPxaNev6BFmNjPYG
	 ZcMt4HZcF7RsC1WSCHLiKzLsd/NO/UPuKZZEBhR5ogqnBblCWd0CMMxTdLkVOA/EmQ
	 BPuIfzqHB8EK63TeKn94rBzvhXqgCwZOgJCNkZKdHffeKOvkcYqGGEHyytb3CmFj3v
	 b25qlF8nYyvvg==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	cgroups@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH net-next v6 0/8] net: skb: isolate skb data area allocations into a separate bucket
Date: Tue,  6 Oct 2026 02:20:26 -0700
Message-ID: <20261006092030.got.500-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4195; i=kees@kernel.org; h=from:subject:message-id; bh=Cp0If3PbWZZsepP088/3ZWOMHF574LM44+zI328FUaQ=; b=owGbwMvMwCVmps19z/KJym7G02pJDFlH9sbn8PqKeBx/z3et2s7w3kf1fLa24IU2lX9Eav9uc LX5J3S6o5SFQYyLQVZMkSXIzj3OxeNte7j7XEWYOaxMIEMYuDgFYCJfJzH8r78uHXPRZIKdz/Xi vuzYfUk5J7+I3FmqdFHM496DZYsWpjP8j5hzc9+hl9HT1Df95vUP+XNNK+FGweV6X2+PXUVpLO0 TuAE=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5C30820006
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: izqbw6fn1ecrbhgm8kz4z87b8e8briwx
X-HE-Tag: 1791278437-162894
X-HE-Meta: U2FsdGVkX18/7ZsjmRH+4UMSRxVJYoQSfk1e9K0Pp8nNgSv74FSuv0V4X6tjD1bqK3A7GYPLQbQ+JFT1+3Q3u/JhBDoHnd0NlbX2iez2Rav3VlmSKvuQh0a3iC0CTVWn76SvIOVvD08MGOLvBb5iuEArH6bufNHbRszeEM0BaIoUjQmWhogHKXwoJ57IF+zR9UxUhYJsr/K2bBA/XYfafzaLv+JR7gRonf9P2H2BdrdiPEvPHOBw0UdNYiHqGgPcm+5+Bkh8hk4uV2Pu7ZIxzjWgj+G32nAwHR9kpZ94Qd4WbOO5IrHzpenHRrD0e/Caj4g0S3v5I+EJkc5TuYYjO4esQ4wLdVY+NpJwdzC5VRc9HpoyknKOPurq5T5L7J40ltUBbhpsI/ScUo4ss3jUMErmsp8xZdpFazr/GDwQdLEy30TVPdDLR5RreKqx8AdqfnmOxgeXMTpV7AmZzYv+45yZmtnFk6Zcoih0nALoUGmWKAbcntNS6+lU9byHajT1LSpf2q5jvGSsF4WTLUwUcTUb1iSXpa/W7zv6zZoS/HEYQLhfo6gfXK3CysjWTyXBUWle0STWI1k5FJGEQqZj5UEIDydxTMNr+3xiosniTA4vFgcFdDmJoD2ukbW7Ui0czURL+SqfMEjOMKetHR7WZiCGAIzZtslrkVYxVs6KnTLGTHhGBlRDIxq45ErK6XH2DFrIplUVWoZumtRcmqMpr/x25HJiAuc20lJnAh+cfgRQ+I+Bu0/Dq2oSGJyMGWqWmhgux9TeO2u3MeSBI6rZ8nnSGgWTJtU+IzDqNdQ57pjlvJ4nL7NtoaP+xrkHDjFpWoDLZw9UGTkE5pmsx2WcOmxD7qsjp5s5x9Yw1cleL+PE3TIG7vglILOCD5B/KIy/U5W3hgUt0sXO18wi9+CkGS+8mXI5pm6COf7vUQE6+jKjeE48WV2t/KsEhiCP3kmVKIa6xY7dMRWdb/rw3oh
 dh0Hw8fZ
 qhYtkzDauu/1PEQTMCq2VwAhASEKaPGQtGgwpDbhyhB4x6YYEh/glRsBWRpaTcTOYYCgoyUeiMLxTo+mvB2Ip6jTGKki6gYh68VZFOYPzXe2sVYSwcVQDikCn+bU2p5vw7W5hNXZjvdGglLY/sY1lUwvkxrNxv5R/AcOj4lKO42Vd3ylprVJGGhvKon2a8PHe9vycEtqvZkqOEZ4eaacKRgpT66QkJtd0qPQBuuo7s8y1K8I=
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
fixing too, including msg_msg allocations going uncharged to their memcg
when CONFIG_SLAB_BUCKETS=n (fixed in 2/8).

Harry, on your v4 question[1] about bucket users giving their own
alignment: I tried that in v5, but a set's allocations don't always
come from its own caches. With CONFIG_SLAB_BUCKETS=n, after a failed
kmem_buckets_create(), and for the DMA and reclaimable fallbacks, they
come from the general kmalloc caches, which can only give kmalloc()'s
alignment. So v6 goes back to mirroring the kmalloc cache's alignment,
and drops the ctor and flags arguments for the same reason. And the whole
exploration made me realize I had a completely wrong understanding of
how memcg worked. :P

The bulk of this is mm/slab, but the final patch is netdev, which Paolo
acked in v4, so I'm hoping this whole series can go via slab?

Thanks!

-Kees

 v6:
 - drop v5's 6/7 ("Let a bucket set handle __GFP_ACCOUNT") and its
   kmem_buckets_create_types(): memcg charges each object in whatever
   cache serves it, so accounted allocations can stay in a set's single
   row of caches, and the fallback now covers only DMA, reclaimable, and
   no-obj-ext allocations (Sashiko)
 - 2/8: new: account msg_msg with GFP_KERNEL_ACCOUNT again; with
   CONFIG_SLAB_BUCKETS=n it went uncharged, since its accounting lived in
   SLAB_ACCOUNT on bucket caches that are not created (Sashiko)
 - 3/8: new: drop the ctor and flags arguments from kmem_buckets_create();
   neither reaches allocations that fall back to the general kmalloc
   caches, and no caller needs them any more (Sashiko)
 - 4/8: go back to v4's form: no alignment argument, and each bucket cache
   takes the alignment of the kmalloc cache it mirrors, since the fallbacks
   to kmalloc can give no other (Sashiko, Harry)
 - 5/8: say in the teardown comment that cache sharing comes from kmalloc
   rounding sizes up to a larger class (Sashiko)
 - 6/8: drop the explicit alignment tests; check that each size lands in
   the cache of the size kmalloc() rounds it up to, not just a big enough
   one; and in the destroy test, assert on the allocation, skip when KFENCE
   serves it, and tear the set down through its KUnit cleanup action
   (Sashiko)
 - 7/8: keep __GFP_ACCOUNT allocations in the set, document what an
   allocation that falls back loses, and test the reclaimable fallback
   (Sashiko)
 - 8/8: create the skb_data set with kmem_buckets_create(), and make the
   comment above kmalloc_reserve() name no allocator (Sashiko)
 - v5..v6 diff: https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/diff/?id=dev/v7.3-rc2/skb-buckets/v6&id2=dev/v7.3-rc2/skb-buckets/v5
 v5: https://lore.kernel.org/all/20261002231120.late.500-kees@kernel.org/
 v4: https://lore.kernel.org/all/20260921075811.too.775-kees@kernel.org/
 v3: https://lore.kernel.org/all/20260702170728.168755-1-pfalcato@suse.de/

[1] https://lore.kernel.org/all/arViR2Miz61-3fV4@thinkstation/

Kees Cook (7):
  mm/slab: Mark the kmem_buckets_create() context as a Context: section
  ipc, msg: Account msg_msg allocations with GFP_KERNEL_ACCOUNT again
  mm/slab: Drop the ctor and flags arguments from kmem_buckets_create()
  mm/slab: Give bucket caches the alignment of the caches they mirror
  mm/slab: Add kmem_buckets_destroy()
  mm/slab: Add tests for the existing kmem_buckets behaviour
  mm/slab: Provide kmalloc type fallback for bucket allocations

Pedro Falcato (1):
  net: skb: isolate skb data area allocations into a separate bucket

 include/linux/slab.h   |   6 +-
 mm/slab.h              |  19 ++-
 ipc/msgutil.c          |   8 +-
 lib/tests/slub_kunit.c | 291 +++++++++++++++++++++++++++++++++++++++++
 mm/slab_common.c       |  74 ++++++++---
 mm/util.c              |   2 +-
 net/core/skbuff.c      |  10 +-
 7 files changed, 378 insertions(+), 32 deletions(-)

-- 
2.55.0


