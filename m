Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7482C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 12:23:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BE426B008A; Thu, 30 Jul 2026 08:23:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 995456B008C; Thu, 30 Jul 2026 08:23:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AB976B0092; Thu, 30 Jul 2026 08:23:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 602246B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:23:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A1EDD1A00E8
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:23:26 +0000 (UTC)
X-FDA: 85045358412.15.51767BA
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id C841C14000F
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:23:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lImL7iie;
	spf=pass (imf23.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785414204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=e+6hzrmSQg0II38t+n9rvv6qBh0adksxkagJYoybTiU=;
	b=Fv2OE+f5pxOLjA4jGa7lJ3b4SLdpHJX2PckCVonO2EKu4UC8HUVk54FPfUmKylY+qz/Nwj
	H61LWDbnzfTUlkxK7uNJBB4kFl6cx+0CximPjU3NlwVQ1hgPtYk6eksMc5ean+juJ3hnEB
	mv+4pnULS+hfTqNWwyNPq7zQ1X+0eC8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785414204;
	b=UndJfgyAAwYDPpZDX0csmk0kwPsAu3vDr6clgNmZVNKcUv9LoggBJuDfUvxAzG+LhFGe9f
	wbLMkIl4wEYiBybzlpDHpKxEsTGRBhdytuG1C/tDKVSO92sZXjj/xuShgUeY5qhVjzy0xW
	vS3jLNJCwbbPKoQdJ+9rgpJs0MtIoCY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lImL7iie;
	spf=pass (imf23.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cb2513ec378so155270a12.3
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785414204; x=1786019004; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=e+6hzrmSQg0II38t+n9rvv6qBh0adksxkagJYoybTiU=;
        b=lImL7iie6jyymKboN8FqCsh2h/aSqFA3eKHTkax1Vg5lDsfZgWJHNp3mEJUGyEgUBu
         hDCIooA6fVrE/Aj3gvq4L4KG5eYxKZyKQxffEI8qlU1rBBW2xl4+jNuAejw99LMzTn0X
         iNb4tC1qdYcqkZava3+eZNqwttBD4q0qQN0jVYg+jr1dEtPdp9H5yEfpMZBr2hhAlLQh
         KHNURoGBgeeVuG/Jfy1/KJ2GBWuT23H8mWUD+S8Km0vuOMjk0qMxffKK32ztEQ0GiRHz
         EubUsRORizSWL6O12bCYlh0KgJXmCJsuLcnih3mxKJC1nCmE8hwIZKGKz5QSH4gYaWCX
         F6eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785414204; x=1786019004;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e+6hzrmSQg0II38t+n9rvv6qBh0adksxkagJYoybTiU=;
        b=RWHrwbJ/gik/obOOuZwZGIuRAWKPr2Y8ZPICKOVhlTRaMSAE21VUc4KcGkTMOZ9VqG
         oL2u7mPjxzr93jnBD7K6egpK6yqhngepg6WxvcF2gh6mZaw02mjUPgyIMrt19+rVL5bV
         BXV7hmusLwS144qTJWw+bLO1+H5hPyFoAT1+6qVbpcpbOShCqM+VkcyEhF/sHl8vEQyu
         dYgmvpf2NEuz2vbiY4mh7X2sozC9TjN4Pixi+88j2O5PtdtIUOyVetU70j9CXFxxGEgi
         zjS7+GYiBwmnQfnj/W+Vef/hFdGYKMDLfVcSEqWMO9OgnVhpSiO9fqUTup5qcqD17DY2
         zz1g==
X-Forwarded-Encrypted: i=1; AHgh+Rqzq+dSPUZlRudwr3nwXCyjCBtt8Tag4b2uvvImQsbAjibm6p1+1CgbKJlZWNy1fUMAC2mDaasq1A==@kvack.org
X-Gm-Message-State: AOJu0YzU92zM9sw0iBWygLIoOAR68uMV76uvuWipxQ+nKC5mZlMmUZLN
	whtfzJaoA97MXiTd3q6UgPnoBUYf5RymmuVNHosdiXzB0jPOrAqxZuCV
X-Gm-Gg: AR+sD13sqViN6l7P9k+6HBYqTHuQDQDkDaVhMXmQtXIb9bCFMUg7kNzhosrtlEaCPa9
	fZFjVx4O2XgzmLYQDN32wEfOOKB+rHBPmpbvLeuyvOjDIkWLV0lMR43YmKXTMQU1iDjGxItnJij
	qoVlV5WKfnZtHdQmT4DQjteRP5rUy+Y8ZeWIUCSTsE6gazD8jZCtZXd49/G3EuBNAiSEZHkPkn4
	M7ar+LqMo1OZoAkKuTwsmVtmOXILQ0CCfxc+uJDWAVpZp779KwSbA4e2xnAJJ3JIU0KovF51Suy
	Mrq//oHX3cXE7KppPKzXuezFwxyTewUT3JCrXRus8bCemKpQH9qZpH0iRAwzQ7LkDoRmbMoSOM1
	5nf47p3WPlLBr853uGQYyU5FlhluLnPKNuToObADKSERc0CtHPTr9PekDMbLNem8JAcVb6EZIo2
	0Is5dB48ch8p5o+pA4IkcYcIMB4tyjs8Msar6KMxsvRmPOEI2nLrYLW86wNCOLlOY2e6yFtRv9g
	zSSWYothgKx99FeaGfneC4qEFPPbBOk7QkuiFIrkG1NMpRBm1VW
X-Received: by 2002:a17:90b:47:b0:38e:ab3f:2c99 with SMTP id 98e67ed59e1d1-38f9be63443mr3215947a91.2.1785414203345;
        Thu, 30 Jul 2026 05:23:23 -0700 (PDT)
Received: from debian.lan ([155.117.85.23])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f9b72d243sm995698a91.10.2026.07.30.05.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 05:23:22 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	zhaonanzhe@xiaomi.com,
	baohua@kernel.org,
	hannes@cmpxchg.org,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com
Subject: [RFC PATCH v5 0/4] mm: avoid large folio splits when swap is unavailable
Date: Thu, 30 Jul 2026 20:23:00 +0800
Message-ID: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C841C14000F
X-Stat-Signature: 6ddqti144s9rpb14ojhqnsi6957pr9nt
X-HE-Tag: 1785414204-913328
X-HE-Meta: U2FsdGVkX19OQm5EQR7ax4xPHJfX/zUNT+1NWugFwdQFo2548QvVdJ3z1H2+SXeeHM3vbcDsZRV2ACK1+peCJNsRxLjbRZ1zqeonJyCKwIFYFapkFHGVtrYdvq4TEtWyJ4lcgqO9omWcfrIfgctSeEhoclLuP0SGM5GJq7NVi4spsoxZbPUBgFsHE1ojFIflrW3NsxyP+EUzEmaTz2/Wv6AmZvBtMZuKqq+X199OAxSG/cfyb6wZcfAOcjq0GFgcFGTWEBY9jiD8U1MxlqxBdHiIjI/Q37mBRl4Azrx6kb2y7EXglpc0WQXb2t+ln9umkZXpRBaTrdIDVyt1KskC3IL51BUbsCaAg/zZr5pGTS8zFIrJjVUouKHPzwtwbuu6GCYKcf7fXmR2K0Tg6lzjS3mku7w9wG7CyzwBF41/TDN6GbyV9WgCAYnVC3TL8h3BAbTgvMRLgJBi6TdPXkEt8kg6TROYoqGe6lLpFdDx7ezAQQxMHPmc1OGP3OlBHCC9Df8l5VnJB1tJnOQxviprfoCVongmw4OWIXyrG6L+iS3eTxzd4FT6R1bl/KGkDmAKwQ3g3s0d4ZzWIRuD6XefgZPORvz1fAdPojKuOaKnrnnSU2gfBgn7d8xwcCEMmvidc8L600JQerx1GA9+2UumHh9RB9WJf5r7D6hsE8nc/hggc4U3gxymqgjtu/Cr6HFVsn+gE8Q8KDuM4fG3IrqkuDEzaSs3pc4vd8wl+POCx0Wk5ZdKkQJ6+fAZO5uNTWurRnBjfsc4ESFUvIO0qKl++m1pErHkWYqS0BGpwWhRJl7uWL8YawVitUf0lBnFMHcoLEXIX206VR+afsrBnfhiv2nA/gQ1J5jYkPdtR5h6Glfb3mIGkjqH2bdUaUULX8qZ9RKuwqXk07s1nvbOi+VzgPe/cQ9Js0l/IdI4be4uFIexGA8/beMUdOlrUFYUYlKdbtjBo7V0DSWZPywlK0g
 MEBo2MHW
 vf6+XimaG4ypNs2M/N9ITCkyGXQzwcDhC4hFGFJKlvjFyb7p6qpCn4ajCjpsLZY6Ja1/tO2S9hs6mKjuyEY/wWb0FEqpVjQWsA6sG94sIG3sa+I/L0RaBlJLat6z2fl2bAEYd/YfhK6xVI52V/eilCwSpoYKHV1K8J/dviAGTZdVqYW3lht9I4VKxSMOi+Mgs1w4J91WLfQmjMC5+aCZbEVaCxQLzGbGZwu1Em0LGBIUPC/hlS9DpUMV/croLReh3uQV1+vycryGJzVji4DZvvkCrGLpKg17ML8TVmyO3HxUcJ7fJO8z1mMKvj2dRYQs1fm/Q0p8895vOgP9en0g8iqv4xjzjd8OeCWNBsnck2kS53Jje0D3H5aV/EpJNJOjIA3ml/heU4+qXRukukLMrfLK4nksug8XTcWGUjFjhPteu/47MBBtC0XWR3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is RFC v5 of Barry's original RFC patch, "mm: Avoiding split large
folios if swap has no space":

https://lore.kernel.org/r/20260618221720.71768-1-baohua@kernel.org

Barry's RFC showed the no-swap case with MADV_PAGEOUT on 16KB mTHP: the
large-folio split counter increased by 1024 even though no swapout
progress was possible. Skipping the split in that case kept the counter
at 0.

This version keeps that behavior, but makes folio_alloc_swap() classify
the failure. The function sees both the swap allocation result and the
memcg swap charge result, so callers only split when a smaller folio
might still be swapped out.

Patch #1 adds page_counter_margin(), a small helper that computes the
minimum remaining chargeable space across a page_counter hierarchy.

Patch #2 lets folio_alloc_swap() distinguish large-folio swap allocation
failures:

  - -E2BIG: splitting may let smaller folios make progress
  - -ENOSPC: no global swap space is available
  - -ENOMEM: splitting is not expected to help, including memcg swap
    charge failures with no remaining swap capacity

Patch #3 makes vmscan split a large folio only when folio_alloc_swap()
returns -E2BIG. Other failures keep the existing activation path and
avoid destroying the large folio when no smaller part can be backed by
swap either.

Patch #4 applies the same contract to shmem_writeout(), which previously
split a large folio on every folio_alloc_swap() failure. It now enters
the split fallback only on -E2BIG; other failures redirty and reactivate
the folio as before.

RFC v4 -> RFC v5:
- Fix Patch #3 to jump to activate_locked, not activate_locked_split, when
  folio_alloc_swap() fails with an error other than -E2BIG. The folio has
  not been split in that case, so activate_locked_split would incorrectly
  adjust nr_scanned and nr_pages as if tail pages had been split out.
- https://lore.kernel.org/r/20260730021630.2235914-1-xueyuan.chen21@gmail.com

RFC v3 -> RFC v4:
- Keep global swap availability and memcg swap margin separate, following
  feedback from Barry Song, Johannes Weiner, and Youngjun Park.
- Handle early rejections and memcg charge failures with the refined
  folio_alloc_swap() return-value contract.
- Apply the requested vmscan and shmem condition layout changes.
- https://lore.kernel.org/r/20260717122514.51514-1-xueyuan.chen21@gmail.com

RFC v2 -> RFC v3:
- Use Johannes Weiner's original page_counter_margin() patch and preserve
  his authorship. Move the mem_cgroup_get_nr_swap_pages() conversion into
  Patch #1 so the helper addition remains a pure refactoring.
- Add Patch #4 to make shmem_writeout() split large folios only on -E2BIG,
  as suggested by Baolin Wang.
- https://lore.kernel.org/r/20260709145124.764807-1-xueyuan.chen21@gmail.com

RFC v1 -> RFC v2:
- Split the RFC into helper, swap allocation, and vmscan patches.
- Add page_counter_margin() and use it for hierarchical memcg swap
  capacity checks.
- Make folio_alloc_swap() return -E2BIG only when a smaller folio may
  still be swapped out.
- Return -ENOSPC for no global swap space and -ENOMEM when splitting is
  not expected to help, including memcg swap exhaustion.
- Make vmscan split large folios only on -E2BIG from folio_alloc_swap().

Barry Song (Xiaomi) (1):
  mm/vmscan: avoid pointless large folio splits without swap

Johannes Weiner (1):
  mm: add page_counter_margin()

Xueyuan Chen (2):
  mm: distinguish large folio swap allocation failures
  mm/shmem: split large folios only on -E2BIG

 include/linux/page_counter.h |  1 +
 include/linux/swap.h         | 16 ++++++++++----
 mm/memcontrol.c              | 41 ++++++++++++++++++++++++++++++------
 mm/page_counter.c            | 20 ++++++++++++++++++
 mm/shmem.c                   |  7 +++---
 mm/swapfile.c                | 32 +++++++++++++++++++++-------
 mm/vmscan.c                  |  7 +++++-
 7 files changed, 101 insertions(+), 23 deletions(-)


base-commit: c73b725a57f276a3702ca213bde78fca029bc619
-- 
2.47.3

