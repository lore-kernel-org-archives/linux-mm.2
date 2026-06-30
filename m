Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B9EDC43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:08:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DDA36B00B2; Mon, 29 Jun 2026 21:08:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68F416B00B5; Mon, 29 Jun 2026 21:08:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57DE56B00B6; Mon, 29 Jun 2026 21:08:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20A056B00B2
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:08:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 986E9140306
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:08:28 +0000 (UTC)
X-FDA: 84934793496.19.484E73A
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf02.hostedemail.com (Postfix) with ESMTP id C2BA780005
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:08:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KofuBjmR;
	spf=pass (imf02.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782781706;
	b=fvYy//wA2hc8eOyaYvcIgaP9BNJByfWu+IeyV3f5vWZueKBepwEZpHyH8OgB2ta/CdFK/Z
	DyYEpoQf+s6pHdzzwDQ/wI5J9OdilF82nVFxFRR35CsZmFmQ/lExp9aCfP13XYLelXz6Oq
	+UFoq2ft+cZSZxKE9W4n/ERxtNoOfyg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782781706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wdNQRJo20C9SfN4nYA84GpNLauxAw8Nhc1XJP6tzcac=;
	b=4LlWL2hEzZD9P64bWvyZ6RYsyWGF3uV7Xt62z274/FQVmUzt8rrCYXXp34rHbbwoN7nTFq
	X6GUG9vsWIMTUehvAtaVgvy/QVBBL23vdZCGnJQX5lNS+yb+MVbHCA+MrY+25fE8Hwg3u7
	TI372c8GTqJXS41b6LM6c1HWjrt2iLk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KofuBjmR;
	spf=pass (imf02.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-842358aaf36so1706155b3a.2
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782781706; x=1783386506; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wdNQRJo20C9SfN4nYA84GpNLauxAw8Nhc1XJP6tzcac=;
        b=KofuBjmR1oBxY5mA+wsJeK6hXV02oiYRThlY/B35XsK3h4TCKKeiJf+GMSZgDv9buf
         bjJKDNT8Fc1fwQvjHGqxTxDw5lxVTyF6oVmFU4ZqaH/iN4b3m4/Hu3g2tBLY9zGcPQ1I
         Jxp+LsKMOeMQo0FZNAtoP6WyLXXGhn2Cs5UaSzUB2isu1raADv0b6vYQHx4DIgJZKiMz
         izCGq4xVYjwJYynvUBAbxl3ixLc5djoXLiEgjNsGVLBsW8tnBrsuy7ikiZZ/CyMj5zJ2
         eXUmBkgUCvCtUh6vKIr5iy+6Oaz8qqBqz7FpD7tz0c6A3ILyAmBhT2ZwqoSv3PeJJxIk
         /eAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782781706; x=1783386506;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wdNQRJo20C9SfN4nYA84GpNLauxAw8Nhc1XJP6tzcac=;
        b=P2EWruea66wPbmGGFM8YLdpqn+/OlQGs01cS6swBtUpIqDFEMKvJz46LHtr/KHmsqH
         WYkUb3xWRg5zYOGdlSJFTSb6fghZ/10PIgmo6bkEHgELO24X0foxAwLEwBvm+gcRVMNN
         57kefBqgOfLQSbfmIOIbAwbjQF6AlRrZLADc4TOqMIcgNQkKVREmwLx2CdocyzPV4PsI
         tr4aKQ+u/w6ddALpldKfCcEbE51HgtbksJQ6hG+6iasQQdGZGDwEMyn11+Kvq2jMlkBU
         sJWGiOSX4Tqf3+e0WQYHA/PJKVXZMACf5CFKTxUVKT+lX5bxGZIbCkF/K8yHGoHfIAYD
         anbg==
X-Gm-Message-State: AOJu0YwxXT2r9/aAUyJkgNSf3JMt7g6rWUDDivlF2sL9Kr9GtVlXbXHk
	X39O0pAGhiMlaJt8d5uvYNNlRHPauiGLxWI9DvbjsrPH7mfpqCLd/2Ms
X-Gm-Gg: AfdE7cn6nlGApr9rWdeH58SVr4nwGqF61x3DwSiC4TpXfVP6zBu6FFeoyKTqo+VXsqI
	PdBAFNZkt7F9yyvFfWQaRxlEO8UyihPfs3wF+8NfhfVXfVYyHft0biihlplcXKGP2TqQtTv6LgH
	l+prdqrjUZHcuhfSDpF6V3aK5ZR83GnFqZTjL6mmE+TujfqaDlatAr8nu2XHW/jUwP76WO/uQG1
	lLT85ES8/E6RHxfxbXFZvMivhtj4JMmlJvhjhekouSYHOy9A+iCKPT0I0e7PSFuOVXZ3HEgt84f
	XC3KT83LLZ37epQkmYSDKdQs8IWU8pE9oCF4S0BueH9B5XDF9jDHMdNPnL74CKVbYTWRnHVLi0/
	4XAEoB5s0s149fha+ioMFZw7VAl6b/INQVemjx6bZ+fcbRrpVcsXEfoNIhf0rsYrqMY7N5r9GGW
	/yowEjq2q9Rt1B4fS6gq5PNl2qu/MZbA+GHePnTN/L56Wef3TYQ9WU2DBjH0E=
X-Received: by 2002:a05:6a00:94c3:b0:842:77ab:35c8 with SMTP id d2e1a72fcca58-8479f3fe486mr1183229b3a.44.1782781705494;
        Mon, 29 Jun 2026 18:08:25 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([203.18.50.8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847a005afbfsm653310b3a.27.2026.06.29.18.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 18:08:24 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Subject: [PATCH v5 0/3] mm: clean up folio LRU and swap declarations
Date: Tue, 30 Jun 2026 09:08:16 +0800
Message-Id: <20260630-ch-swap-series-plus-folio-lru-cleanup-v5-0-4627aba8ed1e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAXQ2oC/5XNyw7CIBCF4VcxrB3DpdTiyvcwLmBKLQmWBmzVN
 H13URdeVro8k8z3TyTZ6Gwim8VEoh1dcqHLQy4XBFvdHSy4Om/CKS+pFAywhXTWPTz/oPdDgiZ
 4F8DHAdBb3Q091GpdMayE4DWSbPXRNu7y6Oz2ebcunUK8PrIjv1//LYwcKDCjdKGRS2mK7eGon
 V9hOJJ7YRQvtaT8V1VkVRpjZLluKlTqWy3eVfGrWmQVLeVMWUZp/aHO83wDSGLS5oYBAAA=
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1782781697; l=4194;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=3EbJt9K+1+sPTDt06QMPG69wrSXSNbIIWZKhplBpBzc=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QDzbourfcQ+2nSZE3R2G0N7uuQMV6PSYXLzXaLG02N8vF0NJCy6bcv3rPqiNoOSs3froJ2KRlrx
 0kR8TAd+U5gM=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Rspamd-Queue-Id: C2BA780005
X-Stat-Signature: zz4df4gnw7j9719t1n75qu5cy5kdjr3o
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782781706-15722
X-HE-Meta: U2FsdGVkX1/9BWd59fc1PDEHfrusyJtk5I/g1SdI24BbECqM4LXtK8Xj2dPC3OGWVyzpkP/3vv0YpwTkLUmubQtplMMolu8z0S7YEdYAzs2HeChIawwV3gITUrL0Q1Csrlj8Ku0Z5K64OKpHi6QLQ/Qm2QqketT5WOCL7VFP957hQQAdqaGx96IqbqWkPQ/uBYhLFzJQYFkiqQELw3ha5lb8x069aB5zvyV/8OYjmDxTrpLIr+4lWtSOF2Ae20O3oC9yDX5kXh0x/pZgt3ZOZIFi31GbkwC5WG3sZENvzufPf6WZ50w3nBE95p4Anwp+lZIKm6TPai7YjrKSkneKYQLnHBiYcD0Ud7ZjZNf83zH1+O2vk6Rx+v1nVeKG7pfhfGD0TXW8siLcFBaQTM6Fsm8YhzBHUGRFJiFhrF4s/2rGW4Yyv0T7LpvE0kpbTmmLkIPpRPGve8nVQz4HEvXjeAKuK8Nsv3UqlcflJSwaAwPvSabJwnM2t+M9r8VMjcJIQESydvVaVHzRvtfEgey8EJXsxCnFua1ES06br8rIh7aL0cRLyqL3BVpZD8+rLcMSpxq4yQiJYtPmJpnheZEzBI6jFkc4kNE+b0dtRaiQnVS53uGgDqFk6QyuOC1zvCW0dwn1ewvWIg2U/U2sqxsV/wFPcYOMu+sFvPaj7dEyWbkM0yL/mlHRygtkn/v54OSF7CuENRSg5UrduDhPHT7Vmj03j9AZZsI1cbsZzfv5bgeI2aSH4IloonPcgdgokNfZ+jEqWA0MDLfb8xSpEfyS6aBkEd0JQ1OQcP0rvVf07xKa5XgjX3epv5M/fzD/qNwjbA05V+DulfZ4xy3ZkVfR0073SJiwSHjL/PkqdW39/9llelincoMKRI/fdAbPdyYYY6bOXq+M/zb/k7PfwJrTF6dVrZDufvMoXVEk9gIpYVQUYrKZVwMAxIpg4Q07d7z8LT45Z8KDzDikrvfl2Wb
 HJ937p3W
 VaXal7EnvvFlqvm1j8kVTk4a9zjL9O0jDj7OS+jI0QHyuoizaU/s9O2FcFeELVN+E075pR/z7sRZEaj2KZ3bEf6ptm5J9tf5Ofm8CB+5FjV+kzkQ1A94pseRo/Jk+aRJ0K8TX4GO19XwXay/CY2JPBQKoQ9RTyijwYon/LwFirpm4eLKm7xL4U0L0y1h8mRrCB2MIJkhQh+pNA9yrKlZ7Lsq52xIae0UBxG9qSY1IwF+Wivtaz+KsyBaGXhOVN/D/IGVrXJNzNoNV0+H4788XBM+ODZPLbU0lmNGve9HBl3Lg+G3tOalwZzm4+agAlgruW9AOixyRxgR3oDQjKQ4ovx5wgyVjx7SEjqw0H0fWRL5rm2BlLIFvgIb9B8nrT2JIVVOtdF8OISuPba71WN0kFpT6AzWVHAfayMg6N0L32mqVKDakHOhf9mEd+hWj24LzzftCbsTSbSLiO90jX7DH19jJW3UvI33lYPcmcZ22Prr+1CmvcaKxCngsMeIJkwNoNTNmojypgAXGZVyc/Wx+Q6JqurujNO3eBNEON68j6LI7iTVB359cvvoHG0OtpXhfh7TqdewC9vNPBNR8zpl2tL9Z0XonkQDzY4gLhdv8q2l18qME/HzC//FWuJUdRbZOfb2gN1GzpGXYINKDgfwuepFEc1oxqa4QOmkYqZKoXOpob6E/KffQvFw+ftR7P1gOsa9AXVgGf5n/JWi/1U+Eca/omilLUTWFuopkMDjp/loZZKr5smYv6Yauoly5erKaBz2eFfY2oUUuGfUFObMUKJr5xIaoHQzXOh1+12JZcUJDQO5nwzOXHadR56ynZ+4qN5qVUOl81iRUl8Fl3Y5oTOe2CBAC2EqxTorHpNg+85wVkKLkIc24vfj1xYDmiTcDiwn6jCrlPIQKskWBH5dCy9s/U5O3tmNh9nGJc8VgHyb7LEAudl0gN0+7hRN4ZHpEOxyh/r+2wlPBF/1EQCR55w1QhRWt
 d15h7PsO
 esh6bKMCXpBrvircR6NB5d+IOx6n7ePrxSKrmXv+Xytv/z2knNN7ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The previous version moved the folio LRU helpers out of mm/swap.c in
one step. Based on review feedback from Johannes, Baoquan and Barry,
split the cleanup into smaller steps:

  - move the page-cluster sysctl next to swap readahead in mm/swap_state.c
  - rename mm/swap.c to mm/folio_lru.c after the swap-specific bits move out
  - move MM-internal reclaim declarations out of include/linux/swap.h

After this series, swap cache and swap-in readahead stay in mm/swap_state.c,
folio LRU helpers live in mm/folio_lru.c, and MM-internal reclaim/workingset
declarations move from include/linux/swap.h to mm/internal.h (public LRU
helpers used outside mm/ remain in swap.h).

The first patch handles the swap-specific page-cluster state before the
file rename, so the rename commit only carries folio LRU code. The last
patch keeps the LRU helpers used outside mm/ in include/linux/swap.h and
moves the internal reclaim/workingset declarations to mm/internal.h.

This series is based on akpm/mm-unstable as of 2026-06-29
(81652c5a65d4).

To: Andrew Morton <akpm@linux-foundation.org>
To: Chris Li <chrisl@kernel.org>
To: Kairui Song <kasong@tencent.com>
To: Kemeng Shi <shikemeng@huaweicloud.com>
To: Nhat Pham <nphamcs@gmail.com>
To: Baoquan He <bhe@redhat.com>
To: Barry Song <baohua@kernel.org>
To: Youngjun Park <youngjun.park@lge.com>
To: Qi Zheng <qi.zheng@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
To: Axel Rasmussen <axelrasmussen@google.com>
To: Yuanchu Xie <yuanchu@google.com>
To: Wei Xu <weixugc@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
To: David Hildenbrand <david@kernel.org>
To: Michal Hocko <mhocko@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
To: Liam R. Howlett <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Hugh Dickins <hughd@google.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
To: Jonathan Corbet <corbet@lwn.net>
To: Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>

Changes in v5:
- Rebased onto akpm/mm-unstable (81652c5a65d4).
- Fix mm/swap.h for CONFIG_SWAP=n after rebase.
- Tested swap-in readahead on x86 with swap: vm.page-cluster present
  and writable, swap in/out under anon memory pressure, page-cluster 0
  and 3 paths, no oops in dmesg; run_vmtests.sh passed.
- Link to v4: https://lore.kernel.org/r/20260603-ch-swap-series-plus-folio-lru-cleanup-v4-0-ce0219e100d9@gmail.com

Changes in v4:
- Address Baoquan He's review on v3: align patch 2 subject with
  rename-only scope; fix vm.rst sysctl documentation; refresh file
  header comments in mm/folio_lru.c and swap.h declaration comments.
- Expand patch 1 commit message on CONFIG_SWAP=n vm.page-cluster
  registration (also on CONFIG_SWAP=n kernels).
- Link to v3: https://lore.kernel.org/all/20260602-ch-swap-series-plus-folio-lru-cleanup-v3-0-5bbb567f8c99@gmail.com

---
Jianyue Wu (3):
      mm/swap: colocate page-cluster sysctl with swap readahead
      mm: rename swap.c to folio_lru.c
      mm: move reclaim-internal declarations out of swap.h

 Documentation/admin-guide/sysctl/vm.rst |  3 --
 Documentation/core-api/mm-api.rst       |  2 +-
 MAINTAINERS                             |  3 +-
 include/linux/swap.h                    | 75 +++------------------------------
 mm/Makefile                             |  2 +-
 mm/{swap.c => folio_lru.c}              | 46 ++------------------
 mm/internal.h                           | 67 +++++++++++++++++++++++++++++
 mm/memfd.c                              |  1 +
 mm/swap.h                               |  9 +++-
 mm/swap_state.c                         | 37 ++++++++++++++++
 mm/vmscan.c                             |  2 +-
 11 files changed, 126 insertions(+), 121 deletions(-)
---
base-commit: 81652c5a65d4ae28e9b18c16ef917a40025c3653
change-id: 20260531-ch-swap-series-plus-folio-lru-cleanup-d9781c8332dc

Best regards,
-- 
Jianyue Wu <wujianyue000@gmail.com>


