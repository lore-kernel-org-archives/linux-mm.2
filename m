Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43FC0C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 14:13:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE73A6B009F; Sun,  5 Jul 2026 10:13:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABEA26B00A0; Sun,  5 Jul 2026 10:13:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D51B6B00A1; Sun,  5 Jul 2026 10:13:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69F886B009F
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 10:13:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CC722400FF
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 14:13:08 +0000 (UTC)
X-FDA: 84954914856.16.5B78FC6
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id E968720004
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 14:13:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qbrvEW9N;
	spf=pass (imf03.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783260786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9Lak4tBsVkZ5HxGSDt8B/CEhdebz90m/2sUmJ2zk2LQ=;
	b=2WDzjZ6vlzElBrDlLFWkFDP9cuc371PyHstA6FMW3040a1FY440Qd8T6fJFXNaYKktuVCh
	6pHLGbC5uXKfLktgZdvyUVLjJRevQeQzkcAhNniidAISQi7mv8m3MiASdr5t5BJ+vsa+x0
	FkB+G1xlgGSOGk/Babs8MgtOHxb0jBc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qbrvEW9N;
	spf=pass (imf03.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783260786;
	b=Cp1knU91vHE+Jvz8mE1TZzvcWQ23unKfMZO0n13iFfJEv+kNaTHp/9SjuHS1UvrKfAYTP7
	G9zvPl7fIfC0uJYKT5QAmfqK3z6NSWoF57YUL5HrchlcDcxmHnWaIaxuFjp/zr0mz7uGBw
	z2/hILD4ceAbOAhpq8Vqg7A60kmZUhM=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2caf4496889so9022745ad.1
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 07:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783260786; x=1783865586; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9Lak4tBsVkZ5HxGSDt8B/CEhdebz90m/2sUmJ2zk2LQ=;
        b=qbrvEW9NGTWjj9KTKUSROagRAm+HX5O/6TGClxzWiN1nu2vTR92FAHcSHQfEJQ9le+
         ypINLsumhBZm/dXbwnxIWWHCgki4DhVeDvNLp8V6J77G8TlB/wXdBC4iLDPUeBjP1FsG
         5e4JdcnUiG3y4Oxv+qD9QbDX5fCQF/afBPg3Eh9TU/ynFVqhWyxWOQwzqyiwCskU32Ys
         ahDH4QVYzGItMpHiP7A+NQ5+bu+wPLjTfcEY4JWM3OefNxjd/hiAeL6f97d65BfJhlag
         6vL723Aekk238YVlTzV00FoK6PPrt1jlz251kAoGFVg5nxwpIx+T+2Zl8tCRfc2RabsT
         EH5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783260786; x=1783865586;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Lak4tBsVkZ5HxGSDt8B/CEhdebz90m/2sUmJ2zk2LQ=;
        b=HwmQnZQdDPjI0ydV6kTdUX5Fzpce2Mz8Zg8P3OnxEGBN/gCRIqJNc6Sp0r14UHdozk
         HDmXxxoyGWgNlY1fmWPJAKj2VSCZ79la1YrDdAqmb9DZKsXW/Yktn5p++IVyIz0olejn
         159vkJvgkYKunbqw1z15kKefuNZK8j4v/4SFyP228OEsFK22Eesd3kTnBiX0JK4LdzSr
         xDSqu+VPjeHuayO2TKfZ+2CXoBcPckFagpyDNbeJA9CMY7vMW9Nw/+tl/TxoaghMRdtR
         8F2q/q0WKfjCgHqPwKfr19mLpq4ZTwVs3PLZLSvgc+FcWYe5WWwOlxJuOiu3hl/LIMf5
         w7MA==
X-Gm-Message-State: AOJu0YyqUXH97/wU/w8SECh3Um6XqI2Hk9SeTINiNfDA9XCgccn8cuu1
	D9goIzN8zvvC+n6i1NxP0nt6QOcmkLzJlPLClLnBilzjWy4wtrCWb/uc
X-Gm-Gg: AfdE7cmxB6JxGU0yayErCBnWK2jKjhdU8PcOfZMg0fG77ngZ4WlDklIlaJPwERvBdVI
	MnaLOz8Pby+14a7YhbK3jH3GwYH/+oCYKEwA/eNp9JOg/3Vf1P1u3FFKsdy4lmFeeHHNgwD9pGR
	V/1PSC3P8sxoYO8qvwV4eS7+ecMr3zBH7xLx1EDfz+NBIrRS/x+U7Par6ZPD+4QzerceQXak1JA
	C7bLffwxMv6Q1jMhhi+UzC8nfOFz28MLd7AUI+fTBpCuti/zNNeGcsJVZtL0FwNU8YhK1d8nfWz
	S2b/sx3bRHLbYN7IdUZyo0jqzLpz17EL2Pqt9I4o1KZxcrahyvR24crDaCYXLUhVx+eYQ+UBjYc
	hFndoIjcJDBIBlLphN4omlwWt04AnGPspZY9M+2qzwY6erBma9O0xd/BHaKrVTcv0OOygnFcKdP
	AmeTp1QGGFh7iyZOoKyLdc7XsLRRkkmVFQoVisAv3GHDPtoJ/9CIUR0rxhb9RmBFE=
X-Received: by 2002:a17:902:ef4d:b0:2cc:6410:91b0 with SMTP id d9443c01a7336-2cc641096eamr42244575ad.8.1783260785665;
        Sun, 05 Jul 2026 07:13:05 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad6f260basm34169155ad.16.2026.07.05.07.12.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2026 07:13:03 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Subject: [PATCH v7 0/3] mm: clean up folio LRU and swap declarations
Date: Sun, 05 Jul 2026 22:12:30 +0800
Message-Id: <20260705-ch-swap-series-plus-folio-lru-cleanup-v7-0-a028e8b5fc3d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAE5mSmoC/5XQyWrDMBSF4VcJWvcWzUNXfY+ShSbHAscyUu20B
 L97lXQRk27c5bmg7wddUY0lxYreDldU4pJqymMb6uWAfG/HU4QU2kYUU4kFI+B7qBc7we87mIa
 5QpeHlGEoM/gh2nGeIBilideM0eBRs6YSu/R173wc2+5T/czl+55d6O3638JCAQNxxnLrqRCOv
 5/ONg2vPp/RrbCwhyox3auypgrnnJCq096YZ5VvVbZX5U31EVNiIsE4/FHFRmV4ryqayiVV1lk
 dA4nPqnyoCu/+V9nUwDvJtZGMabpV13X9ASDF2nwyAgAA
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
 linux-doc@vger.kernel.org, Jianyue Wu <wujianyue000@gmail.com>, 
 Matthew Wilcox <willy@infradead.org>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1783260776; l=3515;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=ZQ9daNpdfqJ2noIQ4x2iiNBox8Y+VpB+RIrWCS/MaZE=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QLysbk4r6/RIlvhNCwMAcUn2JQ0j8sOaPx2KjFB8QaRM/SBLEL6DeUEMIfj5LnK69iJpcxaCiE8
 JpmERuFYSlgI=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E968720004
X-Stat-Signature: uzoeuucisaknkqxfi6xgywtbsh7uy3uh
X-HE-Tag: 1783260786-784191
X-HE-Meta: U2FsdGVkX19yo2M4zahs/dW0wPQxK3gNpJuu+rn+XKOk7EWIhznrGoZDfMoR8ceCIxRI5JivSm1ak4CnjXtADJEAzhDERspphNQo8mnjybUxvNg3wfR3VBsfGNWsYCprT8qlpld5vAYwKtUhPbnSXIgD4Ndtj08QVIekfQ5Awclwsaqrn1dlMqXRm9Cy1C8NFfdp5OsyVUp4wSlFl4Dk8/306CtR7tuRTc2ez/eQi4qTFeQBfEo+hqA0qkTKIvxbVsYPHkGzKM+uxUORA4ohll+pdePBuuVTVJMD5mbKqFxB6Zl5DUSsrfBpBx7vI+aJSDxCPwIfhSE2MBG9H1XQDzMfTgc9Q9ss/OYGp9Yh5wTqNHSOMCeuw2zORDh6RS7hBi0l/DgcwfgkA1Ybk034sYkk2ZocmnevRDN+0ByBeY+CrKNYXsA5KzarXfBk17kH/1/n3BSe/kXGWRJv+/tOju7tQjqvvVW57lOwCD3008xuShGP+i5gmB2UNjel8d9Ot+nRakbgNeCy/d86y6birH4GKoZuOGqXeq6I3OlUu0thm1IzJC2kCi9qFNbELTw1lsgYcs6WySocvef0tTeFYYBDMkz0Hw6xG18pBoctkzuPg7jFZH/wGlRmIetuZS639lQpHF8RqRDM6ZIP0Y8DegvEzb2J4pu3K4XqjU0IH5CsyovJnFS9j9pFVmF/N8iUYDtezcGWKgS/duEHg3GWI7D9XlU1E70QpoEpEzAFCUVESvNW2b0U9lf+lbgJQq1YxVFZdtfRObAIv5uOaO+sSLkTjNuQrI9Lb5s+JJ5zrRJsJ0nJ5XEQH9iLlkb71DICNg8R6I9CDz4KFcpA30pcetO4Mabto9j3qddmpJRUuLAPQxAabTZhMna39sp4knIW2xEyyZzLvk6/EwOg6h+252+QtXMoRgQxLBSHdB+8Zexe+YV8km/TWo/mIMVRXzXKed7oz5aqBBCef9U/PBq
 TJBmNnyR
 YynWnwceJ3rg3ffZ2vjPjcRqukCFxsrlvA0m5gNbevaL/5xWEuSdCvoF7I9ruDHQaNgGkimxYrE8FqGb9iUXPTcnD2fPi2wYhX4ui26oTLwV4jgTgQ8hLPI3/fFVb2N7rnYvXhv7qJbFze1f4izAbk+f95r8MLFdxi6STRuvxRgEYtXEiHlbYvpKtvuvg+AIhykH+w2VZXTHR+NYQFNb1FGJ2N9gU2260U3UXXpN0lb29GUvgAjQWKKPDul3ao5lRAuPXUrxOyJugFq6WKTUdWBQo5YYBt5/aflCk2TVoHzVpyJUn0B2y58HpTovq3OTSuA7BruJKZHGY4+8ULgXYffFEjJl9g7QbW4FPN89+27u30f0uL7qr5Bp5FH9OWnzSZiAWLEygztnLcayRfo2lkQKqGnKqgiAzOVp8AmaOu8LtWO/zK/tJjY0tBbSpCxeXv7Y2Ts2pRNvAYsLyvgZBARajZCTzAKBi8nOS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series splits folio LRU and swap cleanup into three steps:

  - move the page-cluster sysctl next to swap readahead in mm/swap_state.c
  - rename mm/swap.c to mm/folio.c after the swap-specific bits move out
  - move MM-internal reclaim declarations out of include/linux/swap.h

After this series, swap cache and swap-in readahead stay in mm/swap_state.c,
folio LRU helpers live in mm/folio.c, and MM-internal reclaim/workingset
declarations move from include/linux/swap.h to mm/internal.h (public LRU
helpers used outside mm/ remain in swap.h).

The first patch handles the swap-specific page-cluster state before the
file rename, so the rename commit only carries folio LRU code. The last
patch keeps the LRU helpers used outside mm/ in include/linux/swap.h and
moves the internal reclaim/workingset declarations to mm/internal.h.

Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
Changes in v7:
- Rebased onto akpm/mm-unstable (cfb8731f5396).
- Re-tested full build, swap-in readahead smoke test, and run_vmtests.sh on x86.
- Move version-history text below the "---" separator in the cover letter.
- Add Suggested-by and Acked-by Johannes Weiner on patch 1/3.
- Add Suggested-by Matthew Wilcox on patch 2/3.
- Link to v6: https://lore.kernel.org/r/20260701-ch-swap-series-plus-folio-lru-cleanup-v6-0-d4f648963382@gmail.com

Changes in v6:
- Rename mm/swap.c to mm/folio.c instead of folio_lru.c.
- Link to v5: https://lore.kernel.org/r/20260630-ch-swap-series-plus-folio-lru-cleanup-v5-0-4627aba8ed1e@gmail.com

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
      mm: rename swap.c to folio.c
      mm: move reclaim-internal declarations out of swap.h

 Documentation/admin-guide/sysctl/vm.rst |  3 --
 Documentation/core-api/mm-api.rst       |  2 +-
 MAINTAINERS                             |  3 +-
 include/linux/swap.h                    | 76 +++------------------------------
 mm/Makefile                             |  2 +-
 mm/{swap.c => folio.c}                  | 46 ++------------------
 mm/internal.h                           | 67 +++++++++++++++++++++++++++++
 mm/memfd.c                              |  1 +
 mm/swap.h                               |  9 +++-
 mm/swap_state.c                         | 37 ++++++++++++++++
 mm/vmscan.c                             |  2 +-
 11 files changed, 126 insertions(+), 122 deletions(-)
---
base-commit: cfb8731f5396cafde2d60a2e7d9d27cdb4505f45
change-id: 20260531-ch-swap-series-plus-folio-lru-cleanup-d9781c8332dc

Best regards,
-- 
Jianyue Wu <wujianyue000@gmail.com>


