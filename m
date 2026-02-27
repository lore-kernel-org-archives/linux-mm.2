Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFFB3FEFB6D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:08:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C64A6B0093; Fri, 27 Feb 2026 12:08:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 296E96B0095; Fri, 27 Feb 2026 12:08:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A3206B0096; Fri, 27 Feb 2026 12:08:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0676D6B0093
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:08:08 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6EB50160869
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:08:07 +0000 (UTC)
X-FDA: 84490869414.24.6BB0D96
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id BF03A14000B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:08:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k93XZGV7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772212085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1wG3zzdpPfsfQDVp+tooRSryeqD9IaybMf+e22AJk8c=;
	b=o8sDbI0z0xFD08W1MgcnMqOW9FBYIPBeDdmWRr6FKgM/3GLRKPDQoypQqnEzCKusI8facp
	+LpikjmOBtUjFiDiSEc0AB0b7Q/VSY7KXP2DOQtIQKOh011/r/UdxjcQW6ZSOX3ck1xxCk
	6WNDgBGTmJ3pdzOksuktZRh9YvflrbM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772212085; a=rsa-sha256;
	cv=none;
	b=X4z+pT/jYG/QgzLTI1s+cVxOYlwzQ1lmh5+xE5llRQq5UC6ZyMxq1fcL7vLThDoAVyT6Ay
	zYLw473TWWjBzpM00vCya+lZL/gr/IzDfDH2V8DOjAm+9Ze57ZrUuPUqz0xkikoo4MUJzu
	NGrwKbNcr6UpeTY1pmMrYvdX47o/hqg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k93XZGV7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A8A160008;
	Fri, 27 Feb 2026 17:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45BCC116C6;
	Fri, 27 Feb 2026 17:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772212084;
	bh=/+yB8Djtw/lq3sI9CY947SUdtQdHlwAvGnUS3Q5Fw8o=;
	h=From:Subject:Date:To:Cc:From;
	b=k93XZGV7zY6JC24pbTErv93DzIA4A0OqaLX5Og3OBF1nqrUHd1ci7tJ7L41Bk9t7G
	 iMMZXwuiSMCwanZddglbkb2abKB3V/5lDZsp06Nv8wzCI1Zlr82g5ppi+0y3XyhTiA
	 IPTF3OP4xFUeve49tNfS4dLggqIVNmebQ+ZfGP8Cdl48dQXckMmvm/mv84BWWk9Lli
	 So7d8TNym5GEUe0PqHF3DZZ3+XNVKPFfRCOqVlrOLzPaFfhxk3q2CLte2qwNOWr8WR
	 DRCHIRwdUvManMTSczc6r+aiLT50nhRq7B1SSranPZhVhUOs0iox7wQR4i0FLz0HQc
	 gj0+o2PHex8ow==
From: Vlastimil Babka <vbabka@kernel.org>
Subject: [PATCH 0/3] mm/page_alloc: pcp locking cleanup
Date: Fri, 27 Feb 2026 18:07:57 +0100
Message-Id: <20260227-b4-pcp-locking-cleanup-v1-0-f7e22e603447@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAG3PoWkC/x3MQQqAIBBA0avErBuwoRK6SrQwHWsoTJQiiO6et
 HyL/x/InIQzDNUDiS/JcoSCpq7AriYsjOKKgRT1ikjj3GK0EffDbhIWtDubcEactSHXeU9sHJQ
 4JvZy/+Nxet8PtD2+OWgAAAA=
X-Change-ID: 20260227-b4-pcp-locking-cleanup-b7a2d5ff2ead
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>
Cc: Mel Gorman <mgorman@techsingularity.net>, 
 Matthew Wilcox <willy@infradead.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-rt-devel@lists.linux.dev, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BF03A14000B
X-Stat-Signature: fob3oco1omg1iprzor1fifms4rpqmown
X-Rspam-User: 
X-HE-Tag: 1772212085-950747
X-HE-Meta: U2FsdGVkX1/q8XuoMfnLGyheQZqoMNAkSr0T0hBeYKvsUK7rkm6R++kyYnfqUQTsmLzIPszlMoN4u0/XpxiWWXqsQ96OvGZILKuwWhP4x5lyZTgdZOanl3lXIbFsfQmN6bMGvN1gd+Pv2AmLsNd8XF6Z42lK4ue6MpO5oFOeZrUy6p4angFE4rJmLjYbHxdw+rAdqZfbAXpSOsYVnJ2vgu75lYyWsoZ3i62Vsh0elJj/gRk+GYPXxuAcbmWfE+rjD1iL7XS8CoyJLF+nyz9350i2ji6H4gNe23GtNDSrUCGxF0t8PNWoQzs63tkb0Uy3Z6Yq5/56r7D5cVjvATfrrbkbVqUqSew+Inisq0pmxKnGqDGSc9In4cy1Y+6q6VIkCWxfOwhGCL0DI9KGyeHB3DdsBoe90wfoTSqyDmym/yf8QN2OzxCiKXzQZKpUcRGJY3yLGBypnnpjvfnT/YnN+99IoOON/F36LP9y2XrENcs58hfJN+/jfZqqW1/l3dcGhtVc4Xyow6Xjc3qgtp7wkDfQ31GXhOQIsXLeJjtZ+PDDyCcqHXRGi3YBEpoV90IsReQOH/bLxPyvG99ECUb4IRq4vCHTvrtSecDNz+HI4mh4MTv/PyI+a+XORO/nqh3kSSNnDEyg6qBvF29uWWZUQflCwbX/oHobBB2MgPNAcb2/0ivhCu7s3Bucz6JDSn55Zzz+I26Vksl4lejTI8AGJkl0UJXYzAqBXhUj+3EEY0cB3Yhum7r7PmPgnos4a9KQiv4Ozerohe91i2/isxUFSt3BJP6AlCl7J/QdoDnPlEJyLNy+qZnr7PpgEYXhLdhLA9a+rnhgwlJk/K/7V/NM1W22IrwmQLxvH55fFmerhT/Lg+cvbg5NhoBx12RKuo1i4pulrtzqSZRDsYnU9ddxreJt1DuPxcY4MkiPwMr3tKEdpjpBNFcQ/8kuVPjP7OKLAWuegqD8qZFlqc9zGUN
 AdaJ34t7
 3n/vft3dULcyFkpzHc1OpFKva6y+KKrRbu9UBKSI/nPJ8L9Mu7+8d0nQc3VFuw0DSrVk+Fw8A1+EHvrX0jV6cWm0YG7yNggBxt0SoDPrQImzjylK4dEmkUQTH6I5buNLfWrqxyhDFMmLZjxnxCNcC/T16NNUpVT7mgSP7T3C1bJRqablPlk3mynKn8nePHo1hju7RvQ9f4FLwsrp6WmkfCOFmyx9VYaXWoosFe/OIV6C38Z3/tWRGU1KgegUzbfD0raoy9YoY0M8Uz4SLrzYO+wtJHjAeqDQ904Xk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a followup to the hotfix 038a102535eb ("mm/page_alloc: prevent
pcp corruption with SMP=n"), to simplify the code and deal with the
original issue properly. The previous RFC attempt [1] argued for
changing the UP spinlock implementation, which was discouraged, but
thanks to David's off-list suggestion, we can achieve the goal without
changing the spinlock implementation.

The main change in Patch 1 relies on the fact that on UP we don't need
the pcp lists for scalability, so just make them always bypassed during
alloc/free by making the pcp trylock an unconditional failure.

The various drain paths that use pcp_spin_lock_maybe_irqsave() continue
to exist but will never do any work in practice. In Patch 2 we can again
remove the irq saving from them that commit 038a102535eb added.

Besides simpler code with all the ugly UP_flags removed, we get less
bloat with CONFIG_SMP=n for mm/page_alloc.o as a result:

add/remove: 25/28 grow/shrink: 4/5 up/down: 2105/-6665 (-4560)
Function                                     old     new   delta
get_page_from_freelist                      5689    7248   +1559
free_unref_folios                           2006    2324    +318
make_alloc_exact                             270     286     +16
__zone_watermark_ok                          306     322     +16
drain_pages_zone.isra                        119     109     -10
decay_pcp_high                               181     149     -32
setup_pcp_cacheinfo                          193     147     -46
__free_frozen_pages                         1339    1089    -250
alloc_pages_bulk_noprof                     1054     419    -635
free_frozen_page_commit                      907       -    -907
try_to_claim_block                          1975       -   -1975
__rmqueue_pcplist                           2614       -   -2614
Total: Before=54624, After=50064, chg -8.35%

[1] https://lore.kernel.org/all/d762c46b-36f0-471a-b5b4-23c8cf5628ae@suse.cz/

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
Vlastimil Babka (3):
      mm/page_alloc: effectively disable pcp with CONFIG_SMP=n
      mm/page_alloc: remove IRQ saving/restoring from pcp locking
      mm/page_alloc: remove pcpu_spin_* wrappers

 mm/page_alloc.c | 146 ++++++++++++++++++++------------------------------------
 1 file changed, 51 insertions(+), 95 deletions(-)
---
base-commit: 8982358e1c87e3e1dc0aad37f4f93efe9c1cfe03
change-id: 20260227-b4-pcp-locking-cleanup-b7a2d5ff2ead

Best regards,
-- 
Vlastimil Babka (SUSE) <vbabka@kernel.org>


