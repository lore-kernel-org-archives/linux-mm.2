Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ABF4C4450A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:49:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CA636B00AE; Thu, 16 Jul 2026 10:49:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 953466B00AF; Thu, 16 Jul 2026 10:49:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3BB6B00B0; Thu, 16 Jul 2026 10:49:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A9CA6B00AC
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:49:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 999DEA01AE
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:30:18 +0000 (UTC)
X-FDA: 84994874916.11.D849F6C
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id E4AD91C0009
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:30:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=I0XeFRQX;
	spf=pass (imf20.hostedemail.com: domain of 39upYaggKCIkwnpxzn0ot11tyr.p1zyv07A-zzx8npx.14t@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=39upYaggKCIkwnpxzn0ot11tyr.p1zyv07A-zzx8npx.14t@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784212216;
	b=EJrfytajixwCtgy5ZppnMB34DT+pTFrorK+y7XHvhh3Dc9TLCqyT+HpUw1/lHyOu/BqBwi
	6oHoW1ooF3z4OZl5gYIcuihuKcWknTiCfbZ+ufIryQ/N4IW8bgjw5EtdncfwkkAAgbfmCY
	pK/QIRIvdZPKA5j/LFMpsIgbBvRiwH0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=I0XeFRQX;
	spf=pass (imf20.hostedemail.com: domain of 39upYaggKCIkwnpxzn0ot11tyr.p1zyv07A-zzx8npx.14t@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=39upYaggKCIkwnpxzn0ot11tyr.p1zyv07A-zzx8npx.14t@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784212216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=KK1D0Jn0y9eqfBTpCLM4Znrw9w5QYL14n9pJHOvIIK8=;
	b=5e4MX1lMsIOZ6IJnyWf0+HV0oXpaA2SLWRZJOtisfhJpZvpuw4MOxrpCKczpTN5ZSnqTVA
	G6x051czElb3hZKq4ybbwKuJu/P+CagPnT+zC1tQ7knlsnkxEfcN3FonNdXHnDsNQFA3g5
	l9CJ0Xe6hClz9XaF41ackGUqHkGaKJ0=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-474170b59dfso3844674f8f.3
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 07:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784212215; x=1784817015; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KK1D0Jn0y9eqfBTpCLM4Znrw9w5QYL14n9pJHOvIIK8=;
        b=I0XeFRQXBQqH/RrMQvtjDiP7gyMwAom9U+wwWYm65sl1ZeEMrB/8DyYMlaSve+FzWS
         Dg2HLj9/eiKSCRiF8oRDnE6Hhiggq4c1iHr/5pX6CdljkoMpFXO6Zbc6PG/z9BQC+eXO
         0X2oq525d2n5IdtXTFC5GXwb+/VYQ/4Od5d6XLAVITZ8K4q9ApWl4VkgYPcsd7Ri8UAN
         o9BpCVa8Y9R69iCQbvty6Zm4vLqq8n2I2lc/neIoAfPDDnzbkDurxeQUWiRXE60GBN22
         y0kXoWl7VNJMjLEUMVKz6OVXWNjK2WXlPGx7Yqu6ySnbe1QFRdKoElZziV0rGOundXtl
         5qeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784212215; x=1784817015;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KK1D0Jn0y9eqfBTpCLM4Znrw9w5QYL14n9pJHOvIIK8=;
        b=pGDsvaHw5ounO0yn2REUT9PAYuZVVpeNbNtCw3E5DYaN4gd2RfSNfWAIxlQwJWIz4F
         VMdF5DRAMOqvSNwMQ320/QE0cJMzW4whS6r9M2sA4mtTou9cojwg8b4uixbAk7XinSEA
         6TiM5bIIOTzr/9nB6qFkfTxtXwSKjWUPuOzluuT3HWcsHQL8K2ATavUL+4j2j/Ls0JUh
         zyWsVxL7+RP1nR4DmO3jqcszgu6jpwzlc/BG+P8RUTZbCzaz2P4PlOuojKRLzPL6j9X1
         oboiuSstq4vxf9duk3JRCOSbKJfWhbpLFTBnJUbF1hSBZ6kwxK3qaQyK01d2rXqMCbGY
         ppWg==
X-Forwarded-Encrypted: i=1; AHgh+Rrv9KILDZlBTQ+znVaUJ3+ot+1BvaGoN/dNKyorLpl0WZo/i6+SZ9NbOhxH3M2Tx4O69PgKN5GZnw==@kvack.org
X-Gm-Message-State: AOJu0Yz3Tb5eBaS05q50bvHbOow49RcZUl3oevIrJ6AoEfaZFWGwzsSq
	O60tYOlzcP1mNErGchweukDCqH8kn2IiV4PbPmDUe79RlBM3MrcWRbT2U0UuRHahBwf8acZjQ4I
	0MPpFJ5nZFV6soA==
X-Received: from wmbdr12.prod.google.com ([2002:a05:600c:608c:b0:490:b58a:2c80])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a4a:b0:495:3e81:770f with SMTP id 5b1f17b1804b1-4953e817874mr72103905e9.15.1784212214740;
 Thu, 16 Jul 2026 07:30:14 -0700 (PDT)
Date: Thu, 16 Jul 2026 14:30:09 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAPHqWGoC/yXMQQqDMBBA0avIrDuQRFDbq5Qu4nSiIyGRTC2Ce
 Pem7fIt/j9AuQgr3JoDCr9FJacKe2mAZp8mRnlWgzOuM73tMOQoGX2MmZAi+7StiiZwa6/jMFh yUNO1cJD9t70//tZtXJhe3xec5wfuKVxBeAAAAA==
X-Change-Id: 20260716-folio-alloc-cleanups-0fe319b881c2
X-Mailer: b4 0.15.2
Message-ID: <20260716-folio-alloc-cleanups-v1-0-5363b8e92d33@google.com>
Subject: [PATCH 0/3] mm: yet more cleanups for page_alloc APIs
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Thomas Gleixner <tglx@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, iommu@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-nfs@vger.kernel.org, netdev@vger.kernel.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E4AD91C0009
X-Stat-Signature: kascu8choak17xhq7eo16sb1fdngqq8f
X-HE-Tag: 1784212216-781890
X-HE-Meta: U2FsdGVkX1/d1L/ebGKDadD0whKfsdaGJ9tsYktkUo6MhJXPyJ7gLEq9vwunb58qqOOMDX2ytsXMOdpQNa8FKSV69TD89f8Hkzf/hANJmXE6upvud4sNeDkZQ5gzJm8AcMH2N5L3MWNwtuXvcGc+yvtaYIaptFvVcauoSdg5XX/A8pq31czXpe+VtOf9OZ69Ou9miPQpdOirSSjyOokYnURFUvw3PBMx1TxPgmSJtU6/HQnFxiuZzgME5sGsgAbsJHDw7Wz+tJNST5O9uocmiGExeYv2sBMrlXSPPeVWMn6X5ko7XTM2uFQ1/Rd9mgDZMZ+qKEHj6B03JB21xlyz+GgMobj+5MkTd+SK9u2kY/eXKTSHaV+7nQO6+UdQfK1OahvZgjNliX67lWDAX8zFCqXWKGK+p4bLZ3QCr63QDOnQPKXIFfmXU1ESMF9C7JCyWyQPTRBRHyQabbE2H64KCoGjKRVHRfJxhH7bkvVryyJ9q6CNuIGK6u1ek7OCDnSXdutq7CmojwGao05ekZtw3rG2sRbtJHfQYehUq4LgzZEe11pifwEOc7KV0et7XCjvMT2QJRQGreMCWSfUzj/cIKJxtwlp6LEKVHg5c9PpRqvmtBVFoYeFQi9FmmsS1AlSoGWPoY4uq+311d6T5aZLNpPPo24eQ6rzX1KmoET+yKIdLUc24Dwr+yL4cEFOVixUZ3e+0RTq+kLteyoob9d7hbAwiuTrc3praCugKDpmTzKtgQgKW1wHyeh5DETp5TzdghUjhTLVuFhOLaZyTkTLxWcubynECWMFBq08TYNrVnEwc44IL16D4Uk6acboqtCbtkhhhDKSIOAiTppHtgjGMSRlu6l7qcqDRsFRxIMkcgNWbJGKup0E//pXgsIhc7DlRgtlcUoUwA6eJemH6gQCiouznmsam0msCYZa5J1uSvl91uA1c1GX6TbNsw4TvEnLS970WytWAp0pHfysAfe
 Qihf6bZR
 QA4b+fYgPnib91mK2qt8TpECSIavttTb9m+GwEcbaRn10pKcoBWEWj+26eotm+1Hv6GGYsly7GuUfCVZzYr9T/8nZOJ7vyGH1eCgl1UzvAew9k/fPgXtb8d2x2j1iLHjUgj1aoSxnMxLoP5o0THn/OtUu2IM3hJJDpbxvp1x4/DQIwJroiOKBFk6nLRZvpWWlMByVzQJs0AQkGFCnYEek88RSBb/YgTDDRP3sR0iOLezoeEfqKkiowBHm5tc8ajzeeFbVunu/pBCiKQ/6D4c6LwOIsD/yTMdgcbQXUnT9XqXscBIqJF3VcA9YnlIkXiBXL+yrwSrWgmq8otUq63ETYIbIHRojoShfAya6e8l1mT3TfRkJODqkgJl4ZVXE/Q2qb9lw3K4ABGmwG9hsJdTVdKjoPT8Z2nIGx3DMnTaHSnESLL3Fv/D1FKvnsORo01MRPzgD1K8opbekBAr8aCfSKfLddC/s8htw+NBGjmz81JJJaMthpitVmZo6oB/Tk6jik1aNJN9FQCvkCaAgOt+3NCv8+e5Q0qjsZ0UMi33BKR7CpOdCiLZ68si6go/dOusXQqzkYBPmWOZbgcpFyC9axx8Tu/kwLw+KlyUQqVLCnUGjreaM1IIgCoSf0qp6XuuyxuO4k94wp5YvtTvB23DEOJSkTCAy++2WwwvE2Gg2VDyGR8Eu6hWNXMIf8JQ/4yMh93Uu8q7Jwg6/HLY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Based on mm-new.

Align some APIs with recent cleanups [0][1], and hide more mm-internal APIs
from public headers.

Part of this was also proposed by Vlastimil right as I was writing it:
https://lore.kernel.org/all/ed4572f4-0074-45c5-993d-7b6533eddc31@kernel.org/

And just like with my other recent patches, this has the ulterior motive
of enabling later incoming patches to add alloc_flags arguments to these
internal functions. (But, I do think these are justified as cleanups in
their own right).

[0]: https://lore.kernel.org/all/20260715-spin-trylock-followup-v3-0-fc4d246f705d@google.com/
[1]: https://lore.kernel.org/all/20260703-alloc-trylock-v5-0-c87b714e19d3@google.com/

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
Brendan Jackman (3):
      mm: move internal mempolicy APIs to new internal header
      mm, treewide: replace __folio_alloc_node() with folio_alloc_node()
      mm: move __folio_alloc() to page_alloc.h

 MAINTAINERS                        |  1 +
 drivers/iommu/iommu-pages.c        |  9 +--------
 drivers/irqchip/irq-loongarch-ir.c |  4 ++--
 include/linux/gfp.h                | 25 +++----------------------
 mm/filemap.c                       |  4 +++-
 mm/mempolicy.c                     |  1 +
 mm/mempolicy.h                     | 31 +++++++++++++++++++++++++++++++
 mm/migrate.c                       |  2 +-
 mm/page_alloc.c                    | 18 +++++++++++++++---
 mm/page_alloc.h                    |  4 ++++
 mm/shmem.c                         |  1 +
 mm/swap_state.c                    |  1 +
 net/sunrpc/svc.c                   |  2 +-
 13 files changed, 65 insertions(+), 38 deletions(-)
---
base-commit: 512c82e906fe2c26023e307c7951d53e90910b57
change-id: 20260716-folio-alloc-cleanups-0fe319b881c2

Best regards,
--  
Brendan Jackman <jackmanb@google.com>


