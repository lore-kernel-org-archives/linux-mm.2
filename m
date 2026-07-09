Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94530C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 06:42:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 819F06B008A; Thu,  9 Jul 2026 02:42:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CAF36B008C; Thu,  9 Jul 2026 02:42:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E2726B0092; Thu,  9 Jul 2026 02:42:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42CD96B008A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:42:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC5231403D4
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:41:59 +0000 (UTC)
X-FDA: 84968293158.09.063265B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 23E1C160002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:41:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LF1pQ0O5;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783579318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DbmJ4H55ecd8aV4hAdjxFXgHksDpeIB+JXxAmclYzEc=;
	b=Q1nXD3nVV5J6URozVH1em6+rNiJXf3ul7owlenTL2j6UqTw8Z1vnu8QVLIDi0IAg+sJWfQ
	sxBTbVDbM+6JbXN7Se+mCvtL9WcRed1xEq8MApwJCMoWRzFg4jM3yKIMCWr8wFk3ziT9Iz
	r10OgzYUw0SmIBCyW9mJgIvo2LCOFKQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LF1pQ0O5;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783579318;
	b=vRjY+JiiG19QUcopp03Xc/F5xPwPTxAz/Wu0m4laXGKiL2juQAFhjS7rdou/GGpbjBHCdN
	qlrhJohY9mw+wQYjKwTrbxQ6CrZ1ZYEvStllKpT2XyAmaQNeCSdgeKm1wDK1rPQ1Pdd7DE
	y7kspTE6GjkIcg6w/WlaTS+Du1zzDnM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 17A3F41B30;
	Thu,  9 Jul 2026 06:41:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD6A1F000E9;
	Thu,  9 Jul 2026 06:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783579317;
	bh=DbmJ4H55ecd8aV4hAdjxFXgHksDpeIB+JXxAmclYzEc=;
	h=From:Subject:Date:To:Cc;
	b=LF1pQ0O5nJ2Z3Dm1Jm/fh4X8oEOM+VYR0N/Bk2fP0J7a2WkMAL1G6YnSpArGbDDsV
	 06hp/utqBr+CWqg3Ujy9AtP5wZbH9W3d87aCfzk5Gt/pXaVXCrrlTrQRd0jGTZVtPM
	 tgXAL+yxzpcaaPY25BLk7K8JHGzzuxRo3ckGJbWPMlfqB70iuGtS+DEzHDDueNEG4I
	 cdYz2VUjOg1CqmEiPuoBzP+AnCsbw3rThJu+U3Xvyok+GrGuok3fC2zru2/jWL1Zgd
	 ne0W2DbLlV/dj+uFacZ1znnXrCHWhH5qtXCTAA26kU9H+K+U6mm37COv2opKa2Kxmo
	 tM8Dj4NmEGa9w==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 0/3] mm: split a couple of headers from internal.h
Date: Thu, 09 Jul 2026 09:41:46 +0300
Message-Id: <20260709-internal-h-v1-0-956d5092782d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKpCT2oC/yWMyw7CIBBFf6WZtRMpJtT4K8YF0EHGyNQAPpKm/
 y7o8tzcc1YolJkKnIYVMr248CINxt0APlq5EvLcGLTSRk1qQpZKWewdI2oKFIxRh+M4QxMemQJ
 /frHz5c/l6W7kay/0h7OF0GUrPvYppaWmfUoo9IZt+wLt6tKojQAAAA==
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
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 23E1C160002
X-Stat-Signature: r1shhak1sgehfg4m376zzijj73amsfht
X-HE-Tag: 1783579318-343174
X-HE-Meta: U2FsdGVkX195hhyDEooyGRP10jXNZL02i/YDXpnP1x+I4bzD54IBATS/7rGhPDdB00BCa/VBRis3douFWNJ0zOs6VBH9Xq1p5QylMq/oEkmMIxwQFfREZeazBFGdNYuSWFn/nt/1ay9R74pqeiieX8HT2PRl0yAa+koi1b5Hh0Q0MPbxujYunstSce3pFTkGZyf4m0GM+E0Xyn5pqwDSODd+tka5mvkX2osSzhTMF/cSnMZJ+c0W5U0LRIkRo8NFiU5RaQKVvUYz0LnjiLdR6TS2v2BHZQFKyNXxFE2wlPANIpn9YQl+hSR5phci0ZHfDDTZJrC8ksP1v7QqKzlvPDSAc/YwUZxXaapaKDP/QbvVpvnNOHTtgpBtWxzEYj5e7Q4iKsL2rYhz8eA+sWWiwaDZXK7sOb8UXKNG6aKY+WpCEbbB0S8i9Fvujqz6RfA16tfADpaGeO2c58Ki/7w4hqHiusS1edTeqHMkaKjZeD1JsYy6+H0qaXZH3+rdXCoIgoNGpzxhivwb7satOeaYapYH50GbwNAfASNWqf241v0HIEhQuZu/+Zap0hBAS3TzNk4k2PH8fFI/tHfXZlJezx7BX56Rg4EaMFh4q7OxnqDDycnMcmmxjaeFXfgDayemCwZ0mVuAWGMyhlNNG5/JOFuxrVoKdGEJdEB1K6YDpB1qUkNGuluvzRVP2JedqnHKLo7xq6PUv4nJ8wmjDxCYGFErwmjKQ8NqAUZhBQKqL0r3fD5FWD6XtKaHLiopBraUSNGNUWY2DyKPg8iRiW+FqWK4pPjh5BgzILL4tgS++AS+1GNM8cyJbVDlmCmM2iCWlEVk+YqgpWNH/MEpexGovoQGaweF8F9y+z5yZeOr8OKFTM+r894sxFJDlZpz4t924HzCiZbIlSm3asSq1sFLZh/vQPxGpKUrvhQJ0D6NuA07xxubcvznqlHcueE4xCsK4dOvcFMLbGC1iCSGe6V
 +OcY+S28
 RYkvpRA40FRsfsL0GJX7pCe/tJpTajG9NE8wAq7P01evcaw6Lk8xpo7FdRFooGPviXnBbAcnqe/9kGsZlmEPFrgG/Ro72JZIfaps+QzPvmospTd7OH8J0BwszC+jYfm5Ha2QuYyVkb17tbYt2ZhjKJp0turCFrXfd0QTkhRCi0wxANdJrdHQUPW7pPL5hpy0+sllxQn3Q0AcjyCKHhZ1ENdPSnKKelq+9HifI
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
base-commit: 820d5dfede0cd55dcbc89ce96fcfbb11b7c457ba
change-id: 20260707-internal-h-2efef660381d

--
Sincerely yours,
Mike.


