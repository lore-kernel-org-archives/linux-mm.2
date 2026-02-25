Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C648FD3775
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:42:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D39866B008A; Wed, 25 Feb 2026 11:41:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB9596B008C; Wed, 25 Feb 2026 11:41:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF2716B0092; Wed, 25 Feb 2026 11:41:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9DC5C6B008A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:41:59 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 477471405E6
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:41:59 +0000 (UTC)
X-FDA: 84483545958.12.270226B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id B85BA80002
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:41:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n+xg12JP;
	spf=pass (imf02.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772037717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xwOhCvX5hfnB7th9RFNwJ77Zve9wqw3uYjbXiHZmzSM=;
	b=6hvyO21xIvD8RgN6x3egBL3/T0jPpZWxtHT+bZsSEk9BAcKXIcWYYY0dZsEBHlNflUcNZi
	Py4cdrocYlUuLaeQeOJwuURHlgxYZglYgrylPiPCqOVDAs5SnMuEDlE3gj1Phk7I7VUn7G
	hUFQpUDQux89bfX577msdty0gdqEmQw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n+xg12JP;
	spf=pass (imf02.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772037717; a=rsa-sha256;
	cv=none;
	b=gqrrg5HxtPVMLmqCOYhV+Pt9TKCoWiP+8CNtJeTczCsnHA+9boEZ7tEUpYddQReqbbeXFr
	CK6IN8IeRHmZESnm4QqseDFglDjvHif3rqDYtHuOkDML4ZjqBD2JPX6j3lLzkJyem08d51
	hyQclWpk6tqJvPz4Ivt2EkIbCIjaz/0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 08FC860126;
	Wed, 25 Feb 2026 16:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3297DC116D0;
	Wed, 25 Feb 2026 16:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772037716;
	bh=RsGWTxEf7XecP10VMIRwvUSVG8Qsr83RzrgZ5IzF8FI=;
	h=From:Subject:Date:To:Cc:From;
	b=n+xg12JPezepMjFSTJolxFs8rNtU/+FapKmNzxdb/yaHfCvOEPJ6mOianSuwJ3HB4
	 jE3Ot5ZU6GHmh11K/S+fwE9WMB6m+Vwp8SokCYu1VmKfKN8aR3eIuhv8R3ybaKjmv0
	 efD4dDCcFNqnMcb/eORXibFrZdR7YGUy+z9AKrSPdZpzcx+qh+1SLmvXULdYsGx3BT
	 lIFy6l+hpnInUBMIomFEw0v7FdyjjUcLg7GjjG3HE2J2UAvtjb9xdMjipwGGgLNiGh
	 XaNqsaakVso0/STbFhI6IO0+eqrYd7vRP3dHDYicVFqkj7cQOyLOoxk5pNOvFOOtw3
	 +vMLUKA5T16mg==
From: Maxime Ripard <mripard@kernel.org>
Subject: [PATCH 0/7] dma-buf: heaps: Turn heaps into modules
Date: Wed, 25 Feb 2026 17:41:48 +0100
Message-Id: <20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MywqEMAxA0V+RrA3U+ADnVwYX0aYa8EVDhwHx3
 y0uz+LeC0yiisGnuCDKT02PPaMqC5gW3mdB9dlAjjpH1KLfGMcUcBE+DdlwO3xaxbBydTPWMvW
 BGHJ+Rgn6f9ff4b4fj1bsG2oAAAA=
X-Change-ID: 20260225-dma-buf-heaps-as-modules-1034b3ec9f2a
To: Sumit Semwal <sumit.semwal@linaro.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Marek Szyprowski <m.szyprowski@samsung.com>, 
 Robin Murphy <robin.murphy@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
 iommu@lists.linux.dev, linux-mm@kvack.org, 
 Maxime Ripard <mripard@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1658; i=mripard@kernel.org;
 h=from:subject:message-id; bh=RsGWTxEf7XecP10VMIRwvUSVG8Qsr83RzrgZ5IzF8FI=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJnz1fxsJSoPiF0/6nFZ8aiH50IR++QHe2acfuV99o3Ur
 b8ySw/bd0xlYRDmZJAVU2R5IhN2enn74ioH+5U/YOawMoEMYeDiFICJmGxgrK+6GlaicfGcTlM7
 j1HSN+2aLWFpC6+58f3Ksl4fWK82++OBaXObyvu/3GDf+lfy4bsblxjrlDyEk+dOmTt1f4tlj+L
 D544WizcUfH6/eWZLdt9O3qyk3guqU24edFvzLdMucMm8krc+AA==
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: B85BA80002
X-Stat-Signature: gf619egtdh7c169gusxbped3rgcfac1q
X-HE-Tag: 1772037717-269622
X-HE-Meta: U2FsdGVkX18QDSF5ooh67WOxEoq4vtVyLCMa4tb71W0Zvrro0L0jk6ErPnjTiNkBPLigpcK7Ja1PGsu42p15DKU8mlhARr3Sk/y9rX3GEwELDFKONYLHX+YYI9UJS7XYfqy05FJz46I6Onk4vwsf24Zk5quMxkRQwwAY2elGCPXT6/VONq6S+0ABt5bfcGrfhgVVRV26Xg4v4vUTG/7N+EnAyDOwHxO3KmisKEt4Lfwp8gpoY0fRAFbC6hB/SsAHGOzQN13rlef9VuVrwqeRGd4iXt3eonWnqSgqeCXfdeuEYhDvpkcMJiWHW2bDcu7BqxOZc3y2tKFJuScEWMmpw7uF9cCS7WZnPft7aEX2Iil0ezz+FXKAZnO5zEC+lBc/UOwODK2sy1tfvu3+EnVD31yKlp99hecTCZHeci34Ks9tEgst5IN0WfBY++TmXXc1xbYO5mLWjg2Sw6jDJbxU0HRj73YbQXmgogT3tIuJVyH0yB9pJWqleXnTq05r+3cci8TquL3tx2fZmY+Ez1GqHOtjIfJlUa6jxX0BKJpEO+sWM0g2mWDTAWUPATrlOCUHeHAYHJ4qvLKRM16oc7l02N/6dy3vy3k3MfmY9SyuSt/2q+O5izr86nc3EEYAEDi0WRJpXtIMRKb6kpq4RTi8XDWmdClQgpOP0JVblSwrv7+woARnKJKW8q2Tn4UEb8GuEh7G//FMgtmBvYHdCB8R0VbYNgWiW8GKmdED2Zl/4YSFliM9jx1U7oZGIK5cd/mXnXJ/eYLAWXMoTxUMfv9KeWZzJBXy2zFRXEW5cAZ1dckqd7VR7f54VgyjD+wx7bMN2pIZ2zqmARhj/3G+hMh5NyzkRS3EBiT0g2jXXtyTxJIbPW0LikHhHChJ4KMzhuhg4HFh6uqUqZA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

The recent introduction of heaps in the optee driver [1] made possible
the creation of heaps as modules.

It's generally a good idea if possible, including for the already
existing system and CMA heaps.

The system one is pretty trivial, the CMA one is a bit more involved,
especially since we have a call from kernel/dma/contiguous.c to the CMA
heap code. This was solved by turning the logic around and making the
CMA heap call into the contiguous DMA code.

Let me know what you think,
Maxime

1: https://lore.kernel.org/dri-devel/20250911135007.1275833-4-jens.wiklander@linaro.org/

Signed-off-by: Maxime Ripard <mripard@kernel.org>
---
Maxime Ripard (7):
      dma: contiguous: Turn heap registration logic around
      mm: cma: Export cma_alloc and cma_release
      mm: cma: Export cma_get_name
      mm: cma: Export dma_contiguous_default_area
      dma-buf: heaps: Export mem_accounting parameter
      dma-buf: heaps: cma: Turn the heap into a module
      dma-buf: heaps: system: Turn the heap into a module

 drivers/dma-buf/dma-heap.c          |  1 +
 drivers/dma-buf/heaps/Kconfig       |  4 ++--
 drivers/dma-buf/heaps/cma_heap.c    | 21 +++++----------------
 drivers/dma-buf/heaps/system_heap.c |  5 +++++
 include/linux/dma-map-ops.h         |  5 +++++
 kernel/dma/contiguous.c             | 27 +++++++++++++++++++++++++--
 mm/cma.c                            |  3 +++
 7 files changed, 46 insertions(+), 20 deletions(-)
---
base-commit: 499a718536dc0e1c1d1b6211847207d58acd9916
change-id: 20260225-dma-buf-heaps-as-modules-1034b3ec9f2a

Best regards,
-- 
Maxime Ripard <mripard@kernel.org>


