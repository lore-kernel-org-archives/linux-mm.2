Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17A89CD6E56
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 09:50:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F1726B0125; Sun, 31 May 2026 05:50:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A28A6B0126; Sun, 31 May 2026 05:50:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 090806B0127; Sun, 31 May 2026 05:50:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBF596B0125
	for <linux-mm@kvack.org>; Sun, 31 May 2026 05:50:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 955A414055A
	for <linux-mm@kvack.org>; Sun, 31 May 2026 09:50:29 +0000 (UTC)
X-FDA: 84827244978.25.77A2470
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf22.hostedemail.com (Postfix) with ESMTP id C1576C0006
	for <linux-mm@kvack.org>; Sun, 31 May 2026 09:50:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CbJGOHiC;
	spf=pass (imf22.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780221027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9Yb0wiWbpwuP5bkNN987p9Ha2LTPVTx8G0tVLlMasv0=;
	b=mqWlQY2MIHtW/NanWJ208SH+69PsBoVtfAbqngGR08Fg0i1Zs/Dewxp5MiWHh4xSK8t6z2
	64vppPx8E7ApMwOz/NGjLvm55ohJ2DDOfNcwkn5t32rFjs9M/jGps2tasTBXD4TSTUc2/q
	beCbfGGk34K3NI6cvsf0aGBecATDJig=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CbJGOHiC;
	spf=pass (imf22.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780221027; a=rsa-sha256;
	cv=none;
	b=jLladlo+0hJ+1rHs2pLxCcmVmka2VsFx4qcsscdMTq+pwDW3Z9Z1xONcH7CRE847h/k2pS
	q4y0XTy0Cy2TX6ktitC0fXpT/ERNhRB1mcXjyq9yDXRMBbwfB2WiuAocX1MRnjNrGfWupu
	uU/4dDUXLfo+ZalSrmWvt+tjckNG7FM=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-36b8e1760ccso1855559a91.0
        for <linux-mm@kvack.org>; Sun, 31 May 2026 02:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780221026; x=1780825826; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9Yb0wiWbpwuP5bkNN987p9Ha2LTPVTx8G0tVLlMasv0=;
        b=CbJGOHiCDSfUegDysicDdi1mdUbW4KAjYP2qg9NJCq5IWeY36g+79flUVlsSvEnX5Y
         56BuATj93SqCf/VqM5Uy47+s/nssJy0mb2z5yDBGfnmo/q3Dx/n7tVFuxYyl8bXy5OTv
         iBRCjUot1JsjCfNpwZsZ9defZGjbvwUKf/kXvr52lYI23p48OCf5GyD59C2B8Fg0eD+b
         EyqNQVOcc6Y/kxOGl8L6r5xIeTMtmMNC7XEYXBaNPWqRjRbpdykNuYIckH+DfwgFlzop
         z5K7s5kczBFHNHmEOxupRhNKdSOTRoZbWU2487w2mbk49HqbTlWCUe4dcj2XwJ5Iuw/I
         IZ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780221026; x=1780825826;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Yb0wiWbpwuP5bkNN987p9Ha2LTPVTx8G0tVLlMasv0=;
        b=SptfGHc6xkfDiwGQSsIImiGq5zt7lvKXRdB4pHE4mmxpjn6EOimhCNcCxqMtIeuJ7Z
         CFGkOSOi4OuEFW+UeKMndnxUkIG5txQ6+vvbKWTFt5sdMKLUABIx9NRziJFlmeN3eDao
         f1JSS2VwR2MPUBDfTdHwH1nZN5q/zW8JkRplnwfTpFfHZnDOoVJDJrng/1Z0YKaewFZP
         zRNYJLVN3pg1JubQtpr4zmD1HjuDDyrBqJrJc2QFO8pHohJN3sWjMOkjO7SAHIYmFMYi
         Sn7+J38JDkIEkrOqSS/d3zXFDBfIwEaJtuPH02N7aQ+zWTVmEwnrkSCsaILkGZ0NYS1W
         qZrA==
X-Gm-Message-State: AOJu0YyXrOBTVmi5598We/kB5MSVPOuFd8c68dZAnQPR5W3ien3E+MtU
	+0DdATR8jKuDQCIZ3+JR58yCiahWRlHuh32Wh+F2cXMLbi+MakEHmOM8
X-Gm-Gg: Acq92OHhIpgjD1bMbeBjNehzfrPmrDY7AtwaMVF9rbOuMvAiW/OM+4NpE0zpumHLyA0
	L6GUqokkIqkMRvyNJOdj7F0RJ0INS2ngcJ5U3i5AoFVVJeh1yLvGaqozRSmcnichFYkV/wM1pz2
	DWfR6OFPvqReQ8RG6fy7jnIKiDt0x9ot4F0xE+GFs62csXhpBJjid4pToeP6YnVBorykRu3JKdo
	lPnslBpSbzRdqZ6xpQOeflIV+fGTJa0RJLLD14QIHStFoqWsOdRL6VIonJecr45Uj9RsFWsRfai
	d4VBngpVMnin02E1Wqfdi7vOBqqB1ZPSyESkifmEUpOOkX93ystJvAP0DKwJwFCmpPMdgI4I9nQ
	TwP+FpqRqYHXlg9FdeQsekFa27UbHjQda1esBHdcE86zsGW+ymfkM19aDnw3TP6ApRDgMcVaqlQ
	LY2qKi7mHaumiqMlBKCzftX5KNlMvUzr1SulxV3TzYZ53FBoBy//LZMq1V6zGcqFiPMnFCdRJU+
	kVnzcEUTQ==
X-Received: by 2002:a17:90b:3a4e:b0:36b:ba9b:7efb with SMTP id 98e67ed59e1d1-36c4fef39c9mr6340309a91.5.1780221026548;
        Sun, 31 May 2026 02:50:26 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36bbdb5c91bsm4372219a91.1.2026.05.31.02.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 02:50:25 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Subject: [PATCH v2 0/3] mm: clean up folio LRU and swap declarations
Date: Sun, 31 May 2026 17:50:12 +0800
Message-Id: <20260531-ch-swap-series-plus-folio-lru-cleanup-v2-0-1b9a4ac255b4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFQEHGoC/yWNQQqDMBAAvyJ77oImtNp+pXgIm1UXQhKyRAvi3
 xva4xxm5gTlIqzw6k4ovItKig3MrQPaXFwZxTcG05tHf7cD0oZ6uIx/D3OoiksKkjCUihTYxZr
 RP8dpoMla4wlaKxde5PP7vOfr+gJS9SXWdwAAAA==
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C1576C0006
X-Stat-Signature: zcdt9tm4s5b9c4jjie6eo5br631zs87g
X-HE-Tag: 1780221027-862160
X-HE-Meta: U2FsdGVkX1+3ElgAbiodZfiFHQgYFd+M+SmUEcLpNeGSXbFXCk21jkZQfyLo+8olhnCcZ7jVEt9ldRGpTKiOSSiHgOY2aj9vEkrBJHaBlYlSEvb7e5oHW+cd4KQYyTwxMlV6g9IeQMzMw+gHCX99F0AZPOBMmX62dM8qwIOqN/Dfg2FGoxIslXUESuQwNNMxzfVdG0S2K/dmnm75OCCF1jQZfJkixFkp85/HzyDroutJPo0JOYbaWszfo40hrRl3RFzGlFNK4b6c/rPiOrC+EQ9cKYZXD31ONftIXStJXSZ1SQagikjm7QRXyW+RxN5PW2eD4Zo4yiFKXGV/SkbHrvgWGq6s6z+V5+zJOpvyTN8pqycoByq6MX+jibMI6X0Drn0C+8VgjBANHptO1k8ZOg2jN9ZHZYWSVYqPxcGC3vtAbTwLKXCpEyhombPv05lzqeWM2PucKCZ7GKB0YVmeym+0X3J7vc79QRvPLGPt8biINziYgjZljNo9VSywxJDzbjV9nEx/xvSmuj3er+gw2MofFyCBDQg5+JQf4MQGyj4As6lUpubUec8t7gnUuf6e/RCgKvTSwCFhV8v5HPaBo7+Xrs5JzX+zWZiuqUySxTCw9Wf/mZf954kF1sDxg2EbNnlvU7XD840tokDxQx/kupJ/44N/QSnJn/mcTKX6fpZxuW5b8StzHKxDnfH1Ndn53vEoTdFEMyafLK7c5VQI121BWbjFmh5VSxkvOCH0OVCVtLo+CASzuz5SOtGNS9+a/SErFgXzEADLfqmNzI83Swvwt2YbwKyhPO3BI+gweiCv8dkBna0WjY2UGOncny3OnEEl9qzW3JfcWDYKKiQsfuK+LOD1z8H4H/IZfSnNwpzpCPndIQyAu7Hc9Z/Gc0hLZC5RJvoUBlIRRUUDU+QM0h0BUGUOqkMWKNETc/gfTRNyiQHqY+cGtCKAQLC07l2YNn0m7jE/vZ+T+ldaZ64
 M7+e70Zk
 pw4ytjxNuERCLRji9O3+mts/663rZhOWb4RLhClK7d64Q60+UdH4jsjhs2fhrUdKfaUoS4tXYwvkRGkLLV5Vq6wCgLVWoqJA/4qaIWQ4mQog493ectKjghTfC6fSJ2CBYR0tO4Yogo9s7QMcX23V2/9Y8iWVXUf5f+5BuG2jDVs5YHbpOTe9bqQ19f6SHjWFtoKOHm+FInDk4lc+1n19Ju8Hskx1JzFhb0JnlXOFHcRqwMKWEPmFyXmL4APw+a5Np+cRGPrVfFG3n9D7SWbaCoHk/IGiOswn9S0Xgfjmk+XhwlpELKYIqB26gNQYZ353RjnKWCTyWJdjHcO88AWcDWoFdIJ92sEbTPl/P02fDqM1r6KOHPlSk22vm4bOkeer5vunOwGg/LI1JJn25FIebwo+Fgb0P48GPn/xoJB3sFiLICE1StS8fU90veY3TZ7SSslK4JtNdLp33IvI1rrdx8vKHJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a v2 of the previous single-patch cleanup:

  https://lore.kernel.org/r/20260407110002.204755-1-wujianyue000@gmail.com

The previous version moved the folio LRU helpers out of mm/swap.c in
one step. Based on review feedback from Johannes, Baoquan and Barry,
split the cleanup into smaller steps:

  - move the page-cluster sysctl next to swap readahead in mm/swap_state.c
  - rename mm/swap.c to mm/folio_lru.c after the swap-specific bits move out
  - move MM-internal reclaim declarations out of include/linux/swap.h

The first patch handles the swap-specific page-cluster state before the
file rename, so the rename commit only carries folio LRU code. The last
patch keeps the LRU helpers used outside mm/ in include/linux/swap.h and
moves the internal reclaim/workingset declarations to mm/internal.h.

This series is based on Christoph Hellwig's swap_ops series, which
moves swap I/O dispatch behind swap_ops and leaves mm/swap.c with less
swap-specific state. That makes the folio LRU cleanup more natural to
split out on top.

  https://lore.kernel.org/r/20260528124559.2566481-1-hch@lst.de

Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
Jianyue Wu (3):
      mm/swap: colocate page-cluster sysctl with swap readahead
      mm: move folio LRU code out of swap
      mm: move reclaim-internal declarations out of swap.h

 include/linux/swap.h       | 75 ++++------------------------------------------
 mm/Makefile                |  2 +-
 mm/{swap.c => folio_lru.c} | 38 +----------------------
 mm/internal.h              | 66 ++++++++++++++++++++++++++++++++++++++++
 mm/memfd.c                 |  1 +
 mm/swap.h                  |  2 --
 mm/swap_state.c            | 37 +++++++++++++++++++++++
 mm/vmscan.c                |  2 +-
 8 files changed, 113 insertions(+), 110 deletions(-)
---
base-commit: d7be408821acadd7d713d1da16a6742886799114
change-id: 20260531-ch-swap-series-plus-folio-lru-cleanup-d9781c8332dc

Best regards,
-- 
Jianyue Wu <wujianyue000@gmail.com>


