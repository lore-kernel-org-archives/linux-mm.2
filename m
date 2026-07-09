Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00828C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 10:00:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03C466B0096; Thu,  9 Jul 2026 06:00:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 014566B0098; Thu,  9 Jul 2026 06:00:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E20EA6B0099; Thu,  9 Jul 2026 06:00:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB9D66B0096
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:00:15 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4ECA5120464
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:00:15 +0000 (UTC)
X-FDA: 84968792790.24.258F847
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 94F891C0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:00:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HQ91UncX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783591213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Qbt4ekz8xcd03uy7P/OzMvJEFCLZFGb2OtRS59Nxxvw=;
	b=hcttHT7qN7/A7tLqmRkRBPAKPxQZ+1Pg2F6UjwXzqTuXEQIbazcTU9WDsMkzrg3NCh5xWg
	bQXLwj7B36xw8sJHY/2l7mQxl9R2K7UmLAVsDUjxuQLP3LNJG88RvMPS30WkwBTmFOh705
	4t7OuG29u95g0ee8Gc8BYjNjazOI/ek=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HQ91UncX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783591213;
	b=mC68UgRXy6Xq/pA5dY5aoJtEIRPb0c4nHcid0ZIW/ztqn2QJ8Ku5AO7JbpnbwxsftJBror
	auwc78OLeULyUITFI6/1jtQFFena4fQzFP6C7YFeL0varjFYYtRY8cGqIbV9Afo8SpPTiC
	trhmfzIxLsVpZyiAzHJJRk2JokkUSQA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 12CE06001A;
	Thu,  9 Jul 2026 10:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC85F1F000E9;
	Thu,  9 Jul 2026 10:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783591212;
	bh=Qbt4ekz8xcd03uy7P/OzMvJEFCLZFGb2OtRS59Nxxvw=;
	h=From:Subject:Date:To:Cc;
	b=HQ91UncX+cUG+i2RI6m/YzVDE4IRkVEMUzrs+RCV2chjiekRRlFo8RZOiMP4k+T2P
	 +auhgOw3e8TOq1fBwklI3IxXVH6M3XT9UvDSAUyvcYzUnfQm6edwVOBcwccFaXVgfm
	 M8I6oBoAMC4q175jV7n67WUlz1rk+sDE15EOuXB0Hr3c1ngJ7y7nmS45hGyVDeMPb/
	 ZX5WPqGuvq2nXaf0StFaeza79djxGu/NogpMGG0nKjFYUfWMC4PrCB9eqoiY84xxfI
	 qgl/Pi5VP+gw978b9vvfSP1t5pL5tTYj0Xa+bwQsYCW+VoeQbnU4vcQ58Y6LXkfD3U
	 U72n6krj64VvQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH v2 0/3] mm: split a couple of headers from internal.h
Date: Thu, 09 Jul 2026 13:00:02 +0300
Message-Id: <20260709-internal-h-v2-0-695631425968@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACJxT2oC/02OQQ6CMBBFr0K6drTUUMCV9zAsCh2gSlvTVtQQ7
 m6LMXH55s+8Pwvx6BR6csoW4nBWXlkTge0y0o3CDAhKRiaMMk5LWoIyAZ0RE4zAsMeec3qsckn
 iwd1hr16b7NJ82T/aK3YhGdJGKzxC64TpxjTS2gZ90BoMPlM8Kh+se2/PzHnS/Hrr/945Bwp1w
 WVBa1ZWTJ5vMcJpb91AmnVdP0COcLbWAAAA
X-Change-ID: 20260707-internal-h-2efef660381d
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, 
 Alexander Potapenko <glider@google.com>, 
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>, 
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, kasan-dev@googlegroups.com, 
 kexec@lists.infradead.org, linux-cxl@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.16-dev
X-Stat-Signature: fizzduw8mt187aeiny7c373jjq4sxzbp
X-Rspamd-Queue-Id: 94F891C0005
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783591213-316018
X-HE-Meta: U2FsdGVkX18QZmI7nF5f760rgga9C2k7na/+xPdMZdwYmLLTb0RO0cwmjcStZc3mdAtWrTsPAa67VfXavMh+l0KpsDqq4T5nnJGfkLzOWH6CTHnvHkKuAlfIutiOOoi1iOGgiAJgIuMwu8fvyYyfURC5YqrywfYwm19kP+t5rQklywC9x18jmi/P/hMNdx4ebXkILp+57VDZ2DlD586r2JKux2gl/1xvnstcavirgtkgpXAQ8eNJCYRscej8/cnyqe6Uav9zKtQICecCC4j4Qf4OJ9VnMXnZS2XhYem/l5ulSw9TspPSgdkXVVxuLE0GGsq0NLF6yzoHgTl5aSy0ymjzOc4egb4C7rSHctDpOrXAfUR9cBzG2cDsa+D3n82e1ORmph3hBihVNofwMBUTkC2cy2Ffv/w6E6z00q8WVdKFEAcGJPt0NYUbIn8RQVhnrtvhB+3Q35gBPMZBjPzxUsrLlWZI3pnelxu8YyXzbu7/qFynG0XVDEt+jx8IuBQQuD6IdJ5C5KxbFaDHL+ENEDJNNs1yuk1RN9+Hiy/FtY/ItugxCgwJxa2MAZ/MXlTsX8IJKcGt5FnJGzzR7DV9CyinShuji86iPaHEFb03/9GcZdPG58HkRi8ml59wwB8GwC17HGuUpM3twI40uR7zhI6vvMB/MafvsQm3Sbe0jqUDilPLjIk8tNPg899RDkvh4xtcSCn/r74+CO2r+SkBK3V8EerQmfPx9n+DT9qs1C7hHyLu2qCSVHnPgIkGUi6i2elu6ApjDuHMfEhvaT9jI9RianzPlbV0w9UOukF2f4MeXR2ESyEMN4bnanTutEx/pxkCYQj+5weU435ZLYRqPectUszdpoXbywoEuQ2LhUNc+4R1Lzw7GCfi6yqAIwjlmh6vZYH/Hbp5tNb+kf85lzY1xuenlzlqex9tnirxw69O9cA1suDEvJ7VgxaFmlbwnFFkz0UbkfNABvMZZCB
 TBd0m4p1
 wWo9S1WxrlvMSFgW1pdA1oK4sD2Dt7dJ4G1SdST7DCS9yR5FPwx/Rhk+nBxXiHDXBdHNj3ME1K/xZq2s8v2oEnhmX4wbvrI2WikRmS7HbAXmw087QMLcIpyAYPcMgvzlJ0AG885FroPyInvQvL+uvwsMtp0Gi5Xj3JYqydo2DBj6kHro6HjAPifGFYGqNd2qWoPTemXo4cJlM417ZtXRFt55dIm7IABHUBrTRnLrEsyP4JPkuvM03I156K2W/cj9MesF9VVMgfS3JEqGA4Kxji3Asc1bju3EZ2nrND/xpBh674rYWny/fvyVs1FOPeUiilzmcUBJF8k5SYPQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mm/internal.h becomes more and more bloated.

Split declarations related to mm_init, memblock, vmalloc and sparse into
new headers.

---
v2 changes:
* fix fallouts of rebase fixups of checkpatch warnings

v1: https://patch.msgid.link/20260709-internal-h-v1-0-956d5092782d@kernel.org

---
Mike Rapoport (Microsoft) (3):
      mm: split out mm_init and memblock declarations from internal.h
      mm: split out sparse declarations from internal.h
      mm: split out vmalloc declarations from internal.h

 MAINTAINERS                        |   3 +
 kernel/liveupdate/kexec_handover.c |   3 +-
 mm/cma.c                           |   1 +
 mm/execmem.c                       |   1 +
 mm/hugetlb.c                       |   1 +
 mm/internal.h                      | 183 -------------------------------------
 mm/kmsan/hooks.c                   |   1 +
 mm/kmsan/shadow.c                  |   1 +
 mm/memblock.c                      |   1 +
 mm/memory_hotplug.c                |   1 +
 mm/mm_init.c                       |   3 +
 mm/mm_init.h                       | 120 ++++++++++++++++++++++++
 mm/page_alloc.c                    |   1 +
 mm/percpu-vm.c                     |   1 +
 mm/sparse-vmemmap.c                |   2 +
 mm/sparse.c                        |   2 +
 mm/sparse.h                        |  63 +++++++++++++
 mm/vmalloc.c                       |   1 +
 mm/vmalloc.h                       |  46 ++++++++++
 19 files changed, 251 insertions(+), 184 deletions(-)
---
base-commit: 59e34180e138a293260301c139cf7ee800978533
change-id: 20260707-internal-h-2efef660381d

--
Sincerely yours,
Mike.


