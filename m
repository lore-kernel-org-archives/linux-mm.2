Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25C8CC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:27:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA4396B00BA; Tue, 30 Jun 2026 12:27:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C55E56B00BB; Tue, 30 Jun 2026 12:27:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF78F6B00C1; Tue, 30 Jun 2026 12:27:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7EE786B00BA
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:27:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DC1DA1A0569
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:27:50 +0000 (UTC)
X-FDA: 84937110300.05.751C304
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id 07EDE12000D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:27:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rIIoNIN7;
	spf=pass (imf29.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782836869;
	b=DJSdzN/DMmZTSka/w053syTkhjQbAKmnw5+1+lP9Z5NPzlEkdNDY2v+ynDedUUlac+geeN
	iHKFCcv09g9vKx2vVzl0HosNPgcMFZFzeJWg+WOIpxuj4v7YXKb0agLm1M/J5MIxJ9Y846
	QLiGXR2DVk4Yq4KPHTXIiCdklFW0qTY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782836869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=d3PcY56r3Gc4NP6LZch/40tRd41JkmPS9gpOd8qwacw=;
	b=GjDOS52k/qrOJG+oOjr0mnMaMjiTR590bSEeOicMRpc5f+Eu5CP65Ib6p0+sQvmrKCJz/z
	hwMsr93O69UkwLkGeHrcW2ThWOyyZr2qsMAVxKz+8Qj00OaCoRt7GoNoqS+NL8uHXklCPE
	WvzeuiPGCR1duKpumjaCselwrnS6qQs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rIIoNIN7;
	spf=pass (imf29.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2c9ed0c7fc7so17087975ad.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782836868; x=1783441668; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=d3PcY56r3Gc4NP6LZch/40tRd41JkmPS9gpOd8qwacw=;
        b=rIIoNIN7vuLkAeokLOGlqVNq9fXPe4+MeCIZC34MROafyzgAp+Ol4PzP6lI2M/x2ai
         TxHXTrpSDWzDcnoJWIf+Sof4JX2VrMDjQOsj0hXWeBBm+iBmBwJbpHJncnPum+HRZaKT
         SBjkuSjirNFL+Eo5ccPI9lVIPw3cOLRg3yvzPdxsRECgvKpxtDG/jZHU9lYHqTwjrE/K
         /PE4l9G4zmZv9lTWO5qIYK5cTgOeOWgMSLyh+10V+Sy7KGTGuYML6BSVoSSTRw+JSJZX
         I4LLd3NKf3ZdnGXoMFF4vFUxVoF90YfQbYyxFFdYpXxGEFw28qyRsjLQVwGeniEnTj7x
         91tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782836868; x=1783441668;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d3PcY56r3Gc4NP6LZch/40tRd41JkmPS9gpOd8qwacw=;
        b=ASisQSVb3MrhvQII0sqdPCgDFZlXtSSljdnMKLDs01c7YFkpJeHZQ6+IZRXZ7Hts2a
         kEpzq0QzipI9iEU6Z8EPKHYB7FnDjwadP75reodOrPYKfHSnD2Oe7g3utgFxoEkDYFOi
         ukdUYqTOx1VJE1/jWiHGxZnwO6TxdArrVpFZRFEUdJ/10dG0XGXDnuhZOmqBfTStqGgV
         1W6NGnG5Y2kLy0or/XW4/UTnQOD3+Nvq0NpcZMVzD4mQVVZez8PiL1gkoDSbSfCs0pzN
         uwCd/XelEcFdEhfMr6Qbi8gieLilxA0V9wCXMgHOJqGWtXjXotZzfzpI+XqroWrdVRkt
         jzIQ==
X-Gm-Message-State: AOJu0YzGIv4bju/fbpNj1WzBbgjBcFSCuR2oTohC1Y0EHZewqjppwPfo
	yvXC6mR6ofSkXHgcePSWoNTBrG1gLnc0SKaPY1BVcU1rtpoy+SDyRWKk
X-Gm-Gg: AfdE7ckLAgYIdHNXFTD6pz0elO+Hm88uS+z5kAIiFJLWJp3C+qX4rKa58tav3acQdqT
	qwosxiVIH0PdflSN41bGQbRyTybzthT6s8FJFUvb1bHymJm3yz6rutI9uAxc+SpckcH3PT64moj
	jN62SHD5aOtQnA9bwuQFj+0eCpygTJJaIyJzSPpuidowWIKM6si3lTf7Qdl5IpPVtjbHkf1Eisn
	jcVH9+H8Llh7LqQ+3ZF3T4IdAFa/4MaYsd7pOLiiMJomgfcRdP1nsA8tixw0iwiPq9MxRtrPpb6
	kP2Uo2Y+nssoqlCX6B+1B+ySafIAlxog628haxFOL0KBydr1ICajl7HAV8pYiJAU+9sxhRwOSjJ
	L8PRW3FOpjVFik90UP+KTGIJWfyN/vnnDIo/eE1haifF/tr8xFxOcxfw4ahD8tIL83dlVQWl0FX
	bWbwUPjGI4bTo8L4b+Gw4TBk3fSouhFaVDAHjmycBQwAoAouEcWeid4kCyo8lxO2kjmvMECZCw
X-Received: by 2002:a17:903:19c7:b0:2c8:248a:5dbb with SMTP id d9443c01a7336-2ca5a52fcb9mr11637185ad.7.1782836867835;
        Tue, 30 Jun 2026 09:27:47 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca37c87bcesm17829375ad.29.2026.06.30.09.27.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 09:27:46 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Subject: [PATCH v6 0/3] mm: clean up folio LRU and swap declarations
Date: Wed, 01 Jul 2026 00:27:31 +0800
Message-Id: <20260701-ch-swap-series-plus-folio-lru-cleanup-v6-0-d4f648963382@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHPuQ2oC/5XNy07DMBCF4VepvGaQ74lZ8R6IhS+TxpIbRzYJo
 CrvjlsWRLAJyzPSfP+VVCwRK3k6XUnBNdaYpzb0w4n40U5nhBjaJpxyTZVg4Eeo73aG7z+Y01J
 hyClmSGUBn9BOywzBdD3zvRA8eNKsueAQP+6dl9e2x1jfcvm8Z1d+u/63sHKgwJyx0nqulJPP5
 4uN6dHnC7kVVvGjasqPqqKpyjmndDf03pjfqtyr4qgqm+qRcmaQURr+qGqnCnpUVU2VmnfW2R4
 Dw726bdsXvo/CUNwBAAA=
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1782836859; l=4374;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=ozZ242VPVy2flVhjMUpvLDowV2A3SAEMfd76chEaS/I=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QBW38YUDJC5EEUVI/W3wuOcivo/VsltkPoCjaJuVPuRzifRN6yDdlZpgv7Kaoq6mACvD7+phjlW
 qMJxGX9lJFgM=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Stat-Signature: p67jfd9wm6895jfnpjmoa46uphzznyoh
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 07EDE12000D
X-HE-Tag: 1782836868-790289
X-HE-Meta: U2FsdGVkX18VgCYnJOyB4S+r8GMzXGuWz+w1AiMBmvc3yYRSurwM2moXmA48Zi3gKiMTSASpYYGO2JuZ/RwLkbT7HgIftatRLTtc+3ve7K4lvaPWOW/Zw/7f/mEsCrlO14CHnieMNQWDmUOpoqAQBW5nrXPpLNSCjF7XBMrf1lXFcSzZKOwtgpPeboOYD5WBA6kzUO3pa33ZS/ZCSkg1YNhHmdl6UoyoEo8xSL8Op0Er2LRBQ54IkUrqyZ6CWBdkr+O7IcL1yop8m4HswnvJhvAv/TWNqXaZSupYNSat4gB63VgVvmuI/0bviNvS7N8lPsCcVtz8grj31stvqHKDsw0jzfNcict6pPgwChoC9EyX/fskYseawvqCq7LKPKoCuxI6C4I0/HTSiTbxKbEfh13sKujWA/4cjc7Eks7amtjSWXimq2swXHteAhCPi8xyoMLWuarhdA0vmgZ3ls1QVET7Y9UTgTakK39m+hZ2UOqf8ylL8qWTuz9vE355zlyz42OFOuFGUXGYKShPrD1AS/kmI4K+K9nhjsfQt8JDdQx4cwdtARa8PN5/w14hilYQMMGhyTqUOWzjF/GUA43NaseJVF/aKOZGY7arTQ6ON9etEcktQaI+FQveMUnDfO0qlVNaTlboSN3vhK8w9sTBQeV6C75oQZmwBNQj5hKnyfUJDNtWSp/uzVb6trA6UqS9W9evBHoWKpBojIMYyxKYa58qpwxcdkmN0DD6OfM/6pFtGlaC126z+hQAq5yH4ru7PKN7YZOx2yrD14pjCkXAz1Mj82hWVKJhR20vxHxRktfmTDjwApy3Z/C6atvqza/loG/kF2zlhm+DUj/pJ6YRqMlFROaMQ6TlIgCGxPiT4p6Pvmzw2QclKe0N7KBb9ODSbzuzuVvVlLzXIdVn+7QvYKgjshBhZXTPBZEF9GNB8jM9YXZsnPy1ztBY9myjKHG4mXeFj6i29CnzcaLOC+x
 JBMBlpiy
 vIl4L0pDrpBtP26Pk/DlkFQmZ3FoxqT+1zymiwm/OyBejpclIC7b7rFmfuFI5S6imcJ1J3MzF9SrqEyODOpcEnAkFmXiZRgFeNjeUPi3PxHhaIIu0ru6RHO2uoBj92gV5lUYLHFps1qxzuUfHCb5v0QlZ9wxwpXhEZfbpC5Fk01UYn/gjOmltEKcApZN7O+ldxPe7x9LgGNHlFp7pZkNzbOU2u4J/Fns4uS8rlK87ZYKIsAr2cMgiblF6uLUy2GfzDqI2nztmN5iXwGKr/lSvDeKYtTsXbR5mnsQlA7niwJI+NKJCedrPGkRq+46Op00OW9LLsaAyo+ToTFXNxLQeE5lUiBIA1K/aaLUsOHapEGgmtN0NomcZndk44dlxJtomZ4RVjK56/qTGI7h2CmX0AB96m2YWY4wunqr+oItMpDv6wGSLhkSowxtpKkXWgW0vRWSzDttycRQJe/vH1kuCh7PVnFeC4IqSXOf/2fnobEQh439LT3txIPm74oVnaDjoYyWWKxkZMR4Yil/c0cpKR00McVlHfGpkXYqe+Wb008UhM1kEdptb+xuqYZtozOCroU1QQ2m4DLANc4kn9Nvi3CtlHLh5zVM+1uTIpeA1mAT9lUAMl0MhLb6Y4ep13QsqMtBkoXZ6Q2mvL564SYbIa/buYi1Ik/LjAeaYpLHwNxpVlhWxwJnsKw2f4jdkKG4RNJIK6glKFZOQtBtRdfhoovGLWM+++guB2H3kwDbSfcsqqd9B5AcDrAqhVynFTUfUYMnvR6BiiqLEj4NobyUPCgE3Ysm1BOvmJQwxPWz2bdUyHNKofWeiH8M33BviJHnaigtSsxKVuulj6dRqBjuWKXGWfP/oo/R6SfDlP1Q4m3UsdG9FY2ZZgMTOoJCnqjwuUIuJTygBBnMJbFGG55/F2vg8E8YbiaWBeR74e6hlPZ4LUG2RgwQTcxkx9Bh4UsnlN/rKlsDSXudQEyk/mSrgxtQcyykt
 KBSHV6p4
 rGYEUg1pDUR4n9AYecUypsJGMns95SnHHrZESFV0v/bWTu2ksFmiYA==
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
 include/linux/swap.h                    | 75 +++------------------------------
 mm/Makefile                             |  2 +-
 mm/{swap.c => folio.c}                  | 46 ++------------------
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


