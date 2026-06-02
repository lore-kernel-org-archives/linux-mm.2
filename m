Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24531CD5BD1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 01:01:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50BD26B04E6; Mon,  1 Jun 2026 21:01:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E2486B04E7; Mon,  1 Jun 2026 21:01:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F7C16B04E8; Mon,  1 Jun 2026 21:01:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F2196B04E6
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 21:01:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF4E01C0E49
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 01:01:28 +0000 (UTC)
X-FDA: 84833169456.02.B4A3161
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 009E4180005
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 01:01:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lRBncs+O;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780362087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=FgIWtjyKQaN21U6Mb/nUvjYBP4wuDVOY9EMv9kBh4pA=;
	b=PWl9kVyxQPdGuESPHq0bheXQfxNaytddOLholVCaLlAC3EpELjuQia0ZnmVOO+6a3UMJyR
	i9sgX1onFsfdrc5bPEJQdgX3YU2SqmkWEnvzKCDYOs6nr0rpOviTnGosfAQQqownewNSBV
	dxkI4K6egLU9JltGyBq36AhlpQ3S8O8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lRBncs+O;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780362087;
	b=P7M6ethrz7YYTrnQ6M7hMj6BigDrqzMsOzkEYeR30aGpBOUZfVn1H4Kr9Nnh9mXhHAOl62
	PZh4fHNR79E417IDskFD4mOgiqsanRA31b+Umr8HDvzMgyySrKPckI78HwHT1A0pua4mK/
	P1UQsbfmsgym64pxbmhaRtnXx/2BM80=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2c0c2c7d45eso18414375ad.1
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 18:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780362086; x=1780966886; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FgIWtjyKQaN21U6Mb/nUvjYBP4wuDVOY9EMv9kBh4pA=;
        b=lRBncs+OUxSkSdhND4keikTTVoG4migKAiHTFlY0zg9dDJI3TmuEGfViI02z+P9OEG
         PdsxQCwYq7vbrQ8XszWILsrvjSlx1CVaZWyNjNmjSdmVFKW9YAuAP1d9R0/+oJNuf82X
         sye5LkFNE0c10DbN8+cQ6IH6V37gQIertmXvtp6UAsIT8ipJVRQZzu/gXcffgm1pO+Dt
         nsZSxtfgfFjMOmbQAIRNxlNNKBUuchpUJvxiYGZANwmAXbiAkWBwy/a++ewxutwMf6k/
         N41P7NHJod8c/z3D7Cq1D7LSooEXlNOkBiuJzeCMQt7OLVqqI7AZx0+2Qduo7R/Faov3
         liHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780362086; x=1780966886;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FgIWtjyKQaN21U6Mb/nUvjYBP4wuDVOY9EMv9kBh4pA=;
        b=TLlU9ZLOutHOgSLx2alN2JbqUIpiVjNBlnqw3kdyVVEcHNiOOd1MtZCvxWpZmw1ueV
         gHpfZSTFTWOEqWVtGSKB8nmowwXygKfhuU4t8SmOljZTSHd4QiT3USwyvwwbvSajiN8k
         h8F6Tw7XON/fCJ8nG6UTNBYOFe9fMFdRjFw3HtYCP+orMoFpVheWx5a7hb9x/QcVV0/9
         dwEltkFXEU2MlYKiJJzc67EwS7qawloMiAJZoqBEt7o4b3yJlhsMf3lUyMpx5AMD1dg7
         6DcYM4T5h0eTvGw2Q1gvVFI8u3pRK9nEwl6uQY8dxTv0r5Rd2JgbjaXLIemtOF56Z1IH
         1crg==
X-Gm-Message-State: AOJu0YzvjoNrcuykLVkEJt3HYqqA2KuOewpQ1GlzL0gCY+ljln1ucj5T
	t4UjCi3s4vzJ6duIT08bUn9fjV9VdM1MunD2uHYnouWKIFu3KDGZYfKT
X-Gm-Gg: Acq92OEEVVxAh6q+hD1pc9Sbkwkrqb8RPiDwkdZhmgjZD26aywNieqlexUEwiw6Ma4S
	0Ng5FBWqLyftJqank+6j7fGHTWLtNHD6O/y2a9TzFDM9sBqycAQlTx8wYTdwBzi5NQUVpQ3XX1P
	rhdzSJiokfo38BYB2ykRnrc1XeQPp6uDMTkDc0nQo/m4RYCRBoN80yY1gU+5Io+aHhZZwLoLr01
	fXM9zMD1gh2hBYaURi/1cLE+FLQzv9SAG3Cw7a/gQsoKvQsPhQ7EoCNADh0CXfgf0pmSVS+jw9z
	koa5Uy/XqgHAm2Yt5YRrPjuY3xBejgmhRlmtbpkbKfV6wQGZ1PfNDJBw32osC5zdX7SCWM/SRZ6
	/svS01TAsYcevchkuC9STsvL9Uzx91sO5nidBu5wlfTgy9k8NNm/x+KbMfLlDROWCmovQtTgoi5
	CEBcuKJnA0+5mEPnIvDX7MqXfwFwbtXDI0ndmPap1Gz85lhmu9v9x154/9ykX74yoi43ozS4asL
	vBkYSSRvs6uh/UCHvtzaZ1CyZPQHoPN
X-Received: by 2002:a17:903:1c6:b0:2bf:82c:6322 with SMTP id d9443c01a7336-2bf367b1052mr153598185ad.3.1780362085703;
        Mon, 01 Jun 2026 18:01:25 -0700 (PDT)
Received: from NV-J4GCB44.localdomain (nat-hk.nvidia.com. [203.18.50.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf239fd85dsm111693355ad.25.2026.06.01.18.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 18:01:25 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Subject: [PATCH v3 0/3] mm: clean up folio LRU and swap declarations
Date: Tue, 02 Jun 2026 09:01:14 +0800
Message-Id: <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-0-5bbb567f8c99@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAForHmoC/5WNQQ6CMBBFr0Jm7RhoQYGV9zAsylBgkkKbVlBDu
 LsVT+Dy/eS/t0HQnnWAOtnA65UD2zmCPCVAo5oHjdxFBpGKS1rIDGnE8FQOfz90ZgnYW8MWjV+
 QjFbz4rCrrmVGpZSiI4gu53XPr6NzbyKPHB7Wv4/sKr7rv4VVYIpZW6lckSiKNr8Nk2JzJjtBs
 +/7B53+Zv3aAAAA
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1780362076; l=2892;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=tJzrs+/YfdeXvzadpYHmPzbOuLkLOHPLX9Z7ajcWyIk=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QG9tJe98rKRw8+Hz1ehc3D3b6WuuuXTskXUa1cg2qEOm7Og4iMmuNfgZwHLVHt5M1cxz1ew98pJ
 9OO+AwWVb/QU=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 009E4180005
X-Stat-Signature: 4gknzqyda5c756c1i78f3tspoe5uu8nm
X-HE-Tag: 1780362086-427838
X-HE-Meta: U2FsdGVkX19lmUIeV9rrSVGk6WJhaQDavNlEPuLb5jVkZziGbjgk1tdA+Oul7WUgFGpXiFAoyVPgRkDR5rxzrWP7nIbP81RBZV2ZKDr++GfZKaxI8Ng36cCP11cObATaJC87gU1l0Eie7zaWldc7XzigEcNgmK2tZW56iiYne6uxj8qUA+eJ4YvpXUGzl6xLwQC6wOo/eoD5ST5N+DDgsHAXHOOekq3VrSn9v1P7OTk+7dhcBQFLp5mBeEE+2a3ltlI/KAFBjZIBZ/1vFf3pI1vMwgi6MKfJHCp770ikibPfnmbXRG/PznrWxynv/+M5vrrddaybfURuMl4+vagp2RyegVeNICfM5N5gvYn5AxVQWHfBrASlSxmpmyHFyWF1CTX92tDbm05lIwk8weszTfOhWgVTHPFyp2ZRtOkI3b23QLXWRS9fQkA0qMDMbd5TpZo7W8IeFLrcYFehZ0kesbjj/oDNAUR8SB0dZ0We4RK1LALx8yBNVUFTC6yWKH76M/TrCvRdvkNbeUI2akTQME3GB9KD1P5yeMmRSfKPMbmh58u2Q8TiXY5wTJn1hratfbvOtLisO1zJI7hvrw2rqFI4WbjnrggNX3k2I+X/yxoeSoLlDYgfQOijI5GkIoR3dkOV/GauRaS1mrqjySr/uPtqWM9XgcjeGSq1IBDaFnvtjt5cwafMMZk58Lmtru4PKD7x+3hCYncpZJfBsdMuG/NX3ma9rntywyw1Nh9Z0z98Z4dUDp2/tqRd9vi5edSo+p4dMPUvYSx6Clvmf3w0CMVryDNV3sxCbCgJo52x5pKJvK32DL7Pyq+BYI+fSNgjzSV8DQDB82PUs39zA8LFBYI/i5oKEMih5HeCbd6Y0MhdITGtRwXhx4EWHU8FxianInTV41LpXOGbhzwAZzh1e0369P9YqLQgZ7lgz4eCp+bBMUoq9YT+PoF86aFHbtrrgQPUt/cpuBQr98/AEEP
 HW4rdyqk
 i5RmSqq/wZotzg/FA6JBAwSfk16q9a2K1twQIS2CzE1rEgGKFW3ntJz/pXy22zwWf+qRui106fdSkkpnR9x3vWQoos7p2HSOppvfe3itvIQ74B9/FW4fHCyvXQ7HWbGZhc/rftRgAiWw158Ls/NGqgjSc3H2mAxQjqq7pF5Mb2NctaSKzW7RtWNhIupuhXoP3+fp7JrL/GycnkchJ3+Deok67cC/QNlx/sTd7HLa0Qc17if/E27VsegJESvmldry7dczfHSWQZ19UsUP1/7lVTjV7LwAmOJRjthNxKhXoQfGep4+sIafma/GlJKkcGWWqCzqDvfPzoiEG46WJX+8fvWi9blq81fb3rEL3UvvVl7uAit/2+vgCOScw70+d7hTObkbsNVkscqydQWCD9gtLZKB56py42+dPiu5IYHZqz4x43wqp+X2Y381tf2y6b7dGQFJI7nFe1/IlCs6jPjmddk9DPMKFHCU2JTmO
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
Changes in v3:
- Update MAINTAINERS and documentation after mm/swap.c rename to
  mm/folio_lru.c (per David Hildenbrand's review)
- Move swap_readahead_setup() prototype from include/linux/swap.h to
  mm/swap.h (per Barry Song's review).  swap_readahead_setup() is only
  used inside mm/, and mm/vmscan.c already includes mm/swap.h.
- Add a CONFIG_SWAP=n stub for swap_readahead_setup(), because
  swap_state.o is only built when CONFIG_SWAP is enabled while
  kswapd_init() is built unconditionally.
- Link to v2: https://lore.kernel.org/r/20260531-ch-swap-series-plus-folio-lru-cleanup-v2-0-1b9a4ac255b4@gmail.com

---
Jianyue Wu (3):
      mm/swap: colocate page-cluster sysctl with swap readahead
      mm: move folio LRU code out of swap
      mm: move reclaim-internal declarations out of swap.h

 Documentation/admin-guide/sysctl/vm.rst |  2 +-
 Documentation/core-api/mm-api.rst       |  2 +-
 MAINTAINERS                             |  3 +-
 include/linux/swap.h                    | 75 +++------------------------------
 mm/Makefile                             |  2 +-
 mm/{swap.c => folio_lru.c}              | 38 +----------------
 mm/internal.h                           | 65 ++++++++++++++++++++++++++++
 mm/memfd.c                              |  1 +
 mm/swap.h                               |  8 +++-
 mm/swap_state.c                         | 37 ++++++++++++++++
 mm/vmscan.c                             |  2 +-
 11 files changed, 121 insertions(+), 114 deletions(-)
---
base-commit: d7be408821acadd7d713d1da16a6742886799114
change-id: 20260531-ch-swap-series-plus-folio-lru-cleanup-d9781c8332dc

Best regards,
-- 
Jianyue Wu <wujianyue000@gmail.com>


