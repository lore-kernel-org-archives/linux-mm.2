Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03092FF8862
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 07:10:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 235156B0005; Mon, 27 Apr 2026 03:10:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E6846B0088; Mon, 27 Apr 2026 03:10:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FC5A6B008A; Mon, 27 Apr 2026 03:10:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 029D76B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 03:10:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 48D2A120721
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:10:30 +0000 (UTC)
X-FDA: 84703462620.23.6F18BC9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id A30FB140008
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:10:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QT7ATLBD;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777273828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ffkliykgP9jph+OnAmxcFmgmWa/FR9IxP8lqMoukazk=;
	b=0M3LHSh5WphBpskBLwnxJSl6hB1LcpR8OCwz19/k5BCwAnsgYE6dJ4CDTp+WjpAPgacvdh
	bnqClpTWnJ3snHoxqks2u5U9rQ9qL2NEJTNSK4WYjC6+aS7UYmkXXZlOJsJnwWpe+iFTLC
	RQvYHDV5OvkO57KsTFfC2jQVOVUMIaQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QT7ATLBD;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777273828; a=rsa-sha256;
	cv=none;
	b=NKQVU4UICLAsnpz8Kn4eBrqD22KMNvzquMiGrWAYJLCCAZ0CRG7leTpy16ZFi5LZh25BKW
	PBKUGZr0ZSGFKzIDp8gEbetB7H5eN9M1hS4G8cYLYB5bLVmutnadMghTkn5P6J3burccl/
	vfa3EGzRqqMh6ow5x/R0oyqOga3Xkps=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D12B060138;
	Mon, 27 Apr 2026 07:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F70C19425;
	Mon, 27 Apr 2026 07:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777273827;
	bh=QxlWAFeIx/eH0s4aOzsl5PZNyhR1rdrTgB1RZ0JEspc=;
	h=From:Subject:Date:To:Cc:From;
	b=QT7ATLBD2uh5xo+VH9XW13IwKyLD8j1vRz539G1657RXwJ69ZGISlvmP20CNoxj0j
	 Mos7VshWGPJnKKxzbrXCKe/oL5pJbHnA4zo8gnBY2fqyN9wMFzDCB4E4oQgCY0BNI7
	 b2ReTyrUd2azIlZe+EWK0ot92aPAToA+5PA5Kfnc7nGRTkF0ZUf++tW0b5nEzUsZKU
	 aI4A2VHaPFszVJFFPcSkgNfaTBHO0aLvClHRhkKNBiZuLnkrxEe05Had9RZ4NKRyyF
	 OshyVpvsTiTT6sAceF2UM9oMjIiuuB+Acr9JOd6gKM3Bcytc/z3X4hIFPnznB4ldBT
	 dK2QeSiWJN1YQ==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Subject: [PATCH mm-hotfixes v2 0/2] mm/page_alloc,slab: return NULL early
 from *_nolock() memory allocation APIs in NMI on UP
Date: Mon, 27 Apr 2026 16:09:51 +0900
Message-Id: <20260427-nolock-api-fix-v2-0-a6b83a92d9a4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAL8L72kC/yWMyw6CMBBFf4XM2klKgwX9FcOij5EOSktaNCaEf
 6fI8tybc1bIlJgy3KsVEn05cwwF5KUC63UYCNkVBimkEo1sMcR3tC/UM+OTf2icuKpbXZPqCIo
 0JyrzP/iAaUIfl5P788wfM5JdjiRs2w52jUUGfwAAAA==
X-Change-ID: 20260427-nolock-api-fix-bd056911e68e
To: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Harry Yoo <harry@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: A30FB140008
X-Rspamd-Server: rspam06
X-Stat-Signature: ixrmnxgge4ugnkcjyhowx48djqpkss3z
X-HE-Tag: 1777273828-426441
X-HE-Meta: U2FsdGVkX19rZidFk5X2ppVXG5cXwq3vzvgpDHJCtv7vSgvmWDToM7DjJuEP849Wq2zNVAzphbc1gNe5kz5c7U4BCJRMH43mrg14si2jUWFp7J3UplS5eCNvMzGY9dnNPPe6yu5y6VJa5WR/XIgDgk0rdqweL5Mg3KxOODf689khMPlLTvvgL8f63Ux6Wo7kG5YgfLB8Ek0EclS9DRCNPZqiI5kRWS5zDyah0g9oi0Pe3evP7+mqz/7H7txiJyzJYeMwaZVDioz73wYvI9pCuzypjrUWPVSkaapvPyZl7QzvKe5BEK4uZ289Xtc9oUPZ3RpJPA3DfkpFeHNPCN6ragonyeEHpuxQOAZdNxTHEhrv5mv7vhV9huBhddo+J47rolRIt6BtJhp1UG0xH7+cc7dQxG6BbTsnychFdYlYJ80pyTItGOWO96fXBNe+MGv76BfO4tOBipE7WCmFasSZD8s1SQq09jhQk9jXjW5/aKAJY6LwQVAfeFjLmJPxxjBzNjZTR8jEm3kwSntf7heXRCA9b6FV7WXtCh+U6kQlPPro4mxTGTDCwXyHD7BHlIbgA6gBbZgRFTzV+pp0clVc3PT+CuvHn7pEKrS+KVdDVsoFdw36/P86PeCps4A2Sy8q48oNX0vYVNfOR8krHXpctLvBobJMTAQXTuOWXxG8yuabYbwKWab9Fzh7FuswV/0hznRlkrcDIWSNSAWZU7eQyd2ncMXNQVVmR0/U94ZhNZlPDi9/RoqcB8o9IIu+UTnz+O+8Qo7rWifyQbw8Oe5+4Di0I2Tjz99GGBG9JT5XqFSHp9mdQZ7dxrDxrOxaNSiMHAl083bWHksB52Sn3a1SXnaQ5W0ZbFiAJKewUBEDZplak2VLyqaB5bTEnFB6sq0PDfXxAY5hx2GhFRQybuM5mY1FOQ/t2W4UBV2/cGuEH5SBET/IbLdUXlSKANrof2U6q1mCKPcbXX6tXIBY0Wd
 Z451fJjt
 2Qa1jik2LDNXT+C9hrlCD0Lmm8jsBskEz77Z+Fv+jfNxR+E2y3HUmUEwhdEOCwICgcG2BQYSO6MdEqoTImjJBZ0fKyhyJf5YQ8oZllBD2wwPqVVPqEAySjHL1/Gra4MiEt2+tmUglKmPjiVrwTtwaZcAgXnOwGcuejsEAZNtRSbXb4NU8kQKqxVL6m8VgpZRHLlHQCi5PUIIEUpHERIw8R3nmFaGe96c6U5f0B97HBsERJS/EoRndsDsVxE4OFlz9p0PmjGDFVfJiZ2JUgOsv3gCxpmlmO1UCETy0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Due to my mistake, V1 was sent twice w/o proper cover letter and
Cc: stable. Please ignore V1. Apologies for the noise. 

Changes since V1:
- used b4 to send patch series (w/ a proper cover letter) instead of
  my broken git send-email script (Thanks Vlastimil)
- added Cc: stable to patches 1 and 2

On UP kernels (!CONFIG_SMP), spin_trylock() is a no-op that
unconditionally succeeds even when the lock is already held.
As a result, alloc_frozen_pages_nolock() and kmalloc_nolock() called
from an NMI context can successfully re-acquire the lock that the
page/slab allocators are already holding (no deadlock because it's
trylock,  but leads to e.g., allocating the same page/object twice and
causing use-after-free).

It was discovered while testing the new kmalloc/kfree_nolock() test case
in the slub_kunit test module with CONFIG_DEBUG_SPINLOCK=y on a UP
kernel.

Patch 1 fixes alloc_frozen_pages_nolock() and
patch 2 fixes kmalloc_nolock().

Note: As pointed out by Vlastimil Babka [1], in theory a kprobe in a
locked section could trigger the same issue. However, fixing that
involves a non-trivial rework (e.g., inventing a new spinlock type) or
introduces unnecessary overhead for all spinlocks on UP (e.g., let all
spinlocks check locked status on UP).

Given that BPF tracing on UP is rare, and it's even more unlikely to
trace a function called from the memory allocator within the locked
section, this patch series addresses the issue only on NMI contexts
(which is rare as well but now covered by the new test case).

[1] https://lore.kernel.org/linux-mm/af3a7fa9-b368-4ffd-964d-9e4fcba863a8@kernel.org

Cc: stable.vger.kernel.org
---
Harry Yoo (Oracle) (2):
      mm/page_alloc: return NULL early from alloc_frozen_pages_nolock() in NMI on UP
      mm/slab: return NULL early from kmalloc_nolock() in NMI on UP

 mm/page_alloc.c | 5 +++++
 mm/slub.c       | 4 ++++
 2 files changed, 9 insertions(+)
---
base-commit: ba24da38a519dfcff8cce3f3f2726d7b159a4d75
change-id: 20260427-nolock-api-fix-bd056911e68e

Best regards,
--  
Cheers,
Harry / Hyeonggon


