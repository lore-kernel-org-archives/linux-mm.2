Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CA7FC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:29:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71DCF6B008C; Mon, 24 Aug 2026 11:29:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CE7B6B0095; Mon, 24 Aug 2026 11:29:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BCB46B0099; Mon, 24 Aug 2026 11:29:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D2736B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:29:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 98F111C01C3
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:29:38 +0000 (UTC)
X-FDA: 85136547636.30.C70CCAB
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by imf26.hostedemail.com (Postfix) with ESMTP id D8AEC14000C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:29:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y89fmpj7;
	spf=pass (imf26.hostedemail.com: domain of 3X2OMagYKCLIdjarrgYggYdW.Ugedafmp-eecnSUc.gjY@flex--lrizzo.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3X2OMagYKCLIdjarrgYggYdW.Ugedafmp-eecnSUc.gjY@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787585376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4S+Q+WbZhfdTv2oIAFNepA3QU93t9DANybxh3vuKjoU=;
	b=d8zy08+ihI0lQKWAwkfhVcjLVp9MCvQyfy5QE0QajGBAWzqF9eTSps5f8NBPiGgjgWsj7N
	sP6LLYs+2lXg+tiMDIaokieI3HNEdXGDpJt8GQgjm0PRtTrxXuxU5RLawqa838n8TLZXKw
	r5YBRJ62BCpiM8d8rVwpVO50N1aAUfI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y89fmpj7;
	spf=pass (imf26.hostedemail.com: domain of 3X2OMagYKCLIdjarrgYggYdW.Ugedafmp-eecnSUc.gjY@flex--lrizzo.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3X2OMagYKCLIdjarrgYggYdW.Ugedafmp-eecnSUc.gjY@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787585376;
	b=O1pWUOfVAaKJKz298gyWUplI0SmRKf7gLOruR0ji++ICFoMRXlgK0Lk/nUBQeqO50pcwhG
	HQIWC/4t9rNJXD++UudcH9rOPoKFQU4BEfGY0f607hQF7mBjqHs42Y19qnaMEO/LapbCa7
	/FFkssGr5OOxW35OM4fzQBGLkhV9xE8=
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c15fed5653eso267839666b.2
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787585375; x=1788190175; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4S+Q+WbZhfdTv2oIAFNepA3QU93t9DANybxh3vuKjoU=;
        b=Y89fmpj7moyxcL5B/4cdk+iLpvtPatDk9DFJMecFkMbgA7d9vctGH1c7aDgC2U4K7n
         YBUGOS+nSggO41dwWGnmqez96X2XRcwBzYHPGYW1K7RLFpQbopoX4Qy5LGNG/eIsE2w9
         n4tEDVl70WH0mk1oYvw6yXfo4RmKqw+Gy05cLiTM21HqUuON3KcJLthMwyaydCk8apq8
         a09UEcR/QorQAcowqyzZ5geGvAS9Zs0qUGpxoiRfbK8JNACrQcihN2nZx3hIjaDwPqfz
         WHZa2HgszEkDrAyrxLxfcI5QdI/4d011A2mNEk+klx/1zHM/PZGjdQAQXKbOJkMdMIvp
         BfjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787585375; x=1788190175;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4S+Q+WbZhfdTv2oIAFNepA3QU93t9DANybxh3vuKjoU=;
        b=mkDyBDmKe8+12vBO9WOFs36lsl+9fIipCNW0ZPhlmYsKXVIna9xtgO+gpX0SPBXFqB
         v0uVYtAZ2XKzec8oCuEhaPANm7+2d3OdXoyQSGcQu0Rg2xmVVy89QjsSQwIpLAZwQpzZ
         lkOih/C851VpgkiZXOmQMD+pA8g9Ju6qwSNDnL/KexHMMBvZGVWSiMCtZ5bOtn4Pr07g
         1bHCB79dY3lJKd86XeAnUc55LPz0PEyw3OXy0UPCFX51ADGmpH3dQ+9KjfZX6La+zA0y
         14A+7j488NugnfvISatzYyMDq0pHX9gUwvgnc7ajQheetWIEVEPgoTKKiahPejlEoEM0
         APsA==
X-Forwarded-Encrypted: i=1; AHgh+Rq45OxbkHEi106+y9IF4R1y2Xq6GuHB7RJeOfB6mleOziLX0Vs1TilrFJWOT3qsJB5sOCQYuFtGsA==@kvack.org
X-Gm-Message-State: AFuF++ktCZuxqIcMJZAK2lm48CkJZAHzCFz7JBasTopzq8wtgjiU1J++
	pxJaYy5eKEB0l0vekG/LFlMJF9T/wT+h2YRM8hJXMmYpKPUnOVTMwitqbYno+bddIWuq2m2r0QD
	jaRvqaw==
X-Received: from ejcdi21.prod.google.com ([2002:a17:906:7315:b0:c12:8b42:7bfd])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:1caa:b0:c20:53c7:488d
 with SMTP id a640c23a62f3a-c246a5f7664mr2951802166b.14.1787585375128; Mon, 24
 Aug 2026 08:29:35 -0700 (PDT)
Date: Mon, 24 Aug 2026 15:29:27 +0000
In-Reply-To: <20260615234220.3946885-1-lrizzo@google.com>
Mime-Version: 1.0
References: <20260615234220.3946885-1-lrizzo@google.com>
X-Mailer: git-send-email 2.55.0.766.g2966f0265a-goog
Message-ID: <20260824152932.1583506-1-lrizzo@google.com>
Subject: [PATCH v2 0/5] swiotlb: avoid swiotlb copy on network sockets
From: Luigi Rizzo <lrizzo@google.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo <lrizzo@google.com>, 
	Luigi Rizzo <rizzo.unipi@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dragos Tatulea <dtatulea@nvidia.com>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, netdev@vger.kernel.org, linux-mm@kvack.org, 
	iommu@lists.linux.dev, driver-core@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D8AEC14000C
X-Stat-Signature: y6mg5ysdd6d7casksr4sg8q7q3jpcnjn
X-Rspam-User: 
X-HE-Tag: 1787585376-72444
X-HE-Meta: U2FsdGVkX1+9YQkXsrkLR7K6FIhwVddnkaot+kDS3GeZghno0D6ZfDfqmPkLIpkTIjMjeC8XIWddX6KtGK918+ATw1RQrUm97FK9q94aSmktjjkqvvUly7Ji7WwUQlRddz5HB/Fc5s6BnVArWExkRr1iNeP2hdyCewqvd5834EIQMDh5c/FICYrXwBN6gi7csc8p8Cph8KNUFsKKtLRkGi/hnrYbvr+P1E30QhzKbWwXEA9GyihWB+UlNu9cgmm7CG4OFh6VMWFekbisN7Wluz/ZYnvAfjVYlZ2+iMiNzYG9V9EZUoBoJzijcAgYXwI+a4/b4aatDoHomvpj13dlZvHaEwqXgR6Zk961Dg23vAXQkeB1PE1ADgn65CMiZZrN35cXfQpLrB8Nlj5CZnKVk4lGXliIqKCxjN4IXlCYdDuKZLB21abY7HaYkJYB1QZ6JgSQQL5YRxVlz4Bg6AUVBFdZXl1ItFORdXUosBsuYvbm0tg3H0dHUoiLZrTFh3mfdxFOmgOOEZ1XyoldwgyrvRX07pOhzd/wPP4fBXLHIEt1UvjJvLJwJexJ9Hwt+R6Vky/Bq4My/6j2+Qb1SmzxKpUjSJaP8vPOMxpFabhKovIkSsxzFlaO203kkUKoCcuYvfRlfM6FRRaJZO1uO0l4OEs2PqLkR78TmvUD3jMnqkaeM2COkpVpXIsP2CIpeLYOFhNKAjm5UYxtg28pjzIEhdOOCDY8Q9tmuv4H6lRHN1FPgRP1MvxJ7hiyzV1i1LkHMen+7EupdYg7HQgH9CCxpAciUGUc8mqgDogQq5xdvyS6MHo/x1q/gzrOBxYz0zDNBsgUje5RvHZbSsTrAfp5kFJw/mrgrfM6SJx7RtmbnOaM8DIlUhG3/WB7LsiTF5r7hJc3egQxUiOUQC7Ww4EjP78i5SlHvsvXlc2AgZhEzQQAfWbO3sqSK9QGR6DBkZh7sx4Z/9Vrprs+JpHcNXm
 CdHbbxKI
 RFpomC8NMAIELYYn6zRRCnANRaobXXfVySybfO1hstk70wAReNeNAvmSxBjFDQy0EiOYLH3Y9OSSfeV6TGutoxABDrKVqe/QUqSb1Y4sDD1KvuRq1SB3olBPTzXuqJop8iZI1Ts8AUGKNxOCvL1PniMcRnelvAb9CQz4DMG3PhFSij1b7S16l3ZNA9Vjg7CMjQBzWAdDOX+idbrDC9t3N0yFNaS8dv/s+sNZz5aDOYjLDuDYXCJ3KfhM0yQ+Q7jrYKoBjESXkXVYIlQBoN7GfMHD18hhDx41dVLvQtr71lCeLbgbn2sG+uuYKZX4REm2fWCtb5Td8Mtdztvc5RBO0GIK5XJCNvcTLcJRdxtXxj++8pPZ4tNvEWK3T/xvXrYpQgxphQ30VcpK86E2Zc8YkpyyBWnVAPB1TvS6bDmdPb5ArFgOx7IPElGAObEoJ+yTsV5I41b5mn6HvmE/mGxtJjz2g36NkZi9gMnZEPMdOz/80+/T7GG9T4FffwR6I0N5993bYQLvv8xa3IeEkDohgZiSO1WTl8cEs6WxwkHdcyZb8OInrq+wWuO1ebl03Yx0BTKe2qrT2raivRU+7/ixTM+UM3COe0yNxc0ICL/VlZbNlhkndMnFe1D5tDjXFuDNVVIG0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The use of swiotlb, common in Confidential Computing, causes an extra
data copy on each I/O. Focusing on network sockets:
- on tx, the copy has a high chance of happening in the tx softirq handler
  (especially with greedy senders where the device queue is often full)
- on rx, it is guaranteed to happen in the rx softirq handler.
Thus, on top of the copy cost, swiotlb concentrates the overhead on an
already constrained resource (CPUs processing network interrupts).

Reduce or remove the extra copy by conditionally allocating socket buffers
directly from the swiotlb buffer pool.

The feature is controlled by runtime parameters to set the percentage of 
swiotlb buffers that can be used for this purpose. This avoids stranding
the entire swiotlb pool in socket buffers.

The implementation is made of four main parts:
- introduce a swiotlb page allocator that can be used instead of
  regular pages, and teach __free_frozen_pages(), free_unref_folio()
  how to handle them
- dynamically track the leaf device for each tx network socket,
  so we can tell at copy_from_user() time whether we need to use
  swiotlb for this socket
- modify skb_page_frag_refill() to allocate from swiotlb if needed.
  This implements the copy elision for the transmit path
- modify __page_pool_alloc_page_order() to allocate from swiotlb if needed.
  This implements the copy elision for the receive path.

The savings are especially visible with fewer queues. In synthetic
benchmarks, senders with 1-2 queues would cap around 50Gbps with
conventional swiotlb, and reach over 170Gbps with the feature enabled.

OPEN ISSUES

Currently the swiotlb allocator looks for free slots using an
approximately linear scan of each pool (with some hints to likely
candidates) and then does a linear scan of subsequent pools.
This works extremely well when the number of pools matches the number of
CPUs, and there is plenty of memory available. In fact, it is almost
unbeatable by any more complex strategy.

Under high load or buffer fragmentation, a CPU might repeatedly do a
full scan of its starting pool before finding a suitable candidate.
Even worse, with multiple tx/rx queues, what happens is that multiple CPUs
will trail each other on the same sequence of pools. The effect is that
some allocations will end up costing O(100us) and more.

I have tried to implement two improvements:
- a buddy allocator on top of each pool, so to make it quicker to find a
  candidate of the requested size
- make each CPU use a different sequence to explore other pools in case
  one is full, so they will not end up queueing one after the other
While they are very effective on the tails, for low load scenarios the
current linear allocators is better. Thus this will take more
investigation.

---
v1 -> v2:

- split components into separate commits
- simplified allocator, no need for a new page type
- many code cleanups
- also implement the rx side

Luigi Rizzo (5):
  swiotlb: enforce pool nareas and nslabs invariants
  swiotlb/mm: Implement SWIOTLB nocopy page allocator
  net/swiotlb: Track bounce device per socket
  net: Divert socket allocations to SWIOTLB for nocopy TX
  swiotlb: Implement RX nocopy with fast recycling eviction

 drivers/base/core.c       |   1 +
 drivers/iommu/dma-iommu.c |   9 +-
 include/linux/netdevice.h |  21 +++
 include/linux/skbuff.h    |   7 +-
 include/linux/swiotlb.h   |  63 ++++++++
 include/net/sock.h        |  46 ++++++
 kernel/dma/direct.h       |  11 ++
 kernel/dma/swiotlb.c      | 296 ++++++++++++++++++++++++++++++++++++--
 mm/page_alloc.c           |  61 +++++++-
 net/core/page_pool.c      |  25 +++-
 net/core/sock.c           | 101 +++++++++++--
 11 files changed, 617 insertions(+), 24 deletions(-)

-- 
2.55.0.766.g2966f0265a-goog

