Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41737C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 07:50:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 087266B01F4; Thu, 13 Aug 2026 03:50:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 037686B01F5; Thu, 13 Aug 2026 03:50:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E69636B01F6; Thu, 13 Aug 2026 03:50:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B04A76B01F4
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:50:39 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 394D58050A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:50:39 +0000 (UTC)
X-FDA: 85095474198.26.01558E3
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7F1A9140005
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:50:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qf7tLd6y;
	spf=pass (imf23.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786607437;
	b=Jd+30biZ4IIW7aMFuQFCYJixJ8ddzGFPRW1q8akOUZDnZKWXSNBzet5xl5kIXwqNk0ii32
	AAsEXkullsbVwH+7yExSj9yBT4YBhrYatKT/MumVAQrVjX2ac0xQWm5QVURs6XbCjhGlOs
	IuiQ1EUnNrD2kl1DY5ZafCXhiUrvPeo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qf7tLd6y;
	spf=pass (imf23.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786607437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Vybgwr57dhXTQ4T97gW4mcEW3yCv848zk80C4ArbMUM=;
	b=QsVaBSe7dagvJuyvDhtU90fVPt7S4SfIZG4nXH6lLr7pJ9WU5CFLYdDZ0WPZ0eI58x1ny5
	nbhp0IXJhpH+q7SrJD+tvXfwQ7Uy1Z5X820/hikRQtbx38w0he7/eeOSE4n3iVLVDOLnln
	W/FcFoq6xywY9kAoxhDVsvJO/sZA0jA=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cad68425a7so2618315ad.1
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786607436; x=1787212236; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Vybgwr57dhXTQ4T97gW4mcEW3yCv848zk80C4ArbMUM=;
        b=qf7tLd6yoJuEn69YOEFvBONK3zp5nSwlPKbMXMA9FHNcPQ+aV2mfvOzUi6R+LSr0ln
         167qxvdRrbs82BJC53OrhQsImgzQgMAj5Q6U5MjF2IuoTquwdHH3zLSDnKHdO9CiNUsS
         /pZnWw7PRNbAqPV5dCe8cB9sYkWQb7HI+IVuKGqpfznleRN3pnht8OIqRziRMKNXpwyy
         tYmNah76V/uGyDBsoRmlWKzgZlet7Mr8Q91qlDg8NFEsTUN/Gj/YGi5tt2X2FPnCn6vC
         2F6H3gK/NK0fnwxIiSiGMnsCSLnfxpjgLQQByoyYyBJkeMH7yVkBLGFy9XyLWjvv/F5m
         f/+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786607436; x=1787212236;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Vybgwr57dhXTQ4T97gW4mcEW3yCv848zk80C4ArbMUM=;
        b=MQdjpb2EnvkMnEtuKp0tya2FoIuK+YCeJJrWMzmmal1Zw4oMRBsbGEj8jHMLiEQDZo
         T3GJEjIyIDbzMJ+VTXEoWPjP0Baia4Vc7RPEWzauO56p4z+l23d3LOx3XClKVwnCGVuz
         yiANnSDmtqYISeBP8Jqan4VLepK5gmD4IK7+VR3DTBLu3cDwbX02qdxbzF3rS3OQrw++
         DPtGIig8fYN3HUydGXGuuMIbyCheUTQev+T2PkZy11RUMB1YtGkhADUwfDVAEhuUD+sI
         2fMj/lUKJkDOdf14i91hIzR1nKOzAoQ06pMwCsXZpHz+iUaPmFqvrc1v3SgSiHn4OklJ
         AGmw==
X-Forwarded-Encrypted: i=1; AHgh+RqMQH6OjHyAgN9N5EDMQ41RXukI4/v7zL9hy3DYZG0y9Slxh4YqizwKWQD+qZsyxx4KvWWd1y/JAA==@kvack.org
X-Gm-Message-State: AOJu0YxbCe4HnMHh+3/SC/aeWk956KWLJUGI9PYd5ZMb2BSRM9HFbfL8
	ariTgYcwerg8EwQpAdsiW8H8MO5H6FrzTyRzLvb8SOVf2O79UBqyH8Il
X-Gm-Gg: AR+sD11MRzduU1+//8MDmCWGB4c0BycacDXH83dbuZ5MDBCnBMuzzUYZZdqOEpIWs+m
	pBxu0Q/p/f1jwap3gzdvd5J1ZZUy6+9IdzsdvJW5fgbuK3rJAwRF66BWgR6tc37yBgm30fT2OiF
	T/LmeIzlhfxSO3HGvcjymgcrQ3TZv9vKnk835OeFRz1M+cmOsgqmZryvekQpviVGWDeGX7xPKu3
	Tt4BIhYKqoP2xqIZUcLJRZQG9CxULi9Pvzu6YvTteH6VVWCmbnN+VsbR7pWXr0OklucrFC1h00v
	aQJhm+kHyzrqUr1l8q/f6RGI2buQgcf18/cIetiieNL8Zj9SgUFVcesl1bni3gCltWrbVim+Vlw
	0bryImwj57Swt4JxU7xc7c24Kbdwa2asSCM5oKlbcHnn2ONIijuGxKDq9K+rgFNcHnLfR9eJIWQ
	i6r6pLY4VG7pE7V3kjjL2OcWkkN2qkQjsrxc2XX/xiIxDB34h18CJKzPuk9jjDed/qbOsOSCNYy
	KzzQ8alvhQtcIvqKjFFib8nMvhGqBmljM6fVaprDCmjPbVwxt99CfmN3FU5icKInqwvqse2TQmW
	Znz8Uw==
X-Received: by 2002:a17:903:19e6:b0:2cb:2b50:d9da with SMTP id d9443c01a7336-2d389b61bdemr28772985ad.3.1786607436131;
        Thu, 13 Aug 2026 00:50:36 -0700 (PDT)
Received: from debian.lan (n058152058183.netvigator.com. [58.152.58.183])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d37c40d6b0sm5550125ad.40.2026.08.13.00.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 00:50:35 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	zhaonanzhe@xiaomi.com,
	baohua@kernel.org,
	hannes@cmpxchg.org,
	ryncsn@gmail.com,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	hughd@google.com,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v6 0/4] mm: avoid large folio splits when swap is unavailable
Date: Thu, 13 Aug 2026 15:50:21 +0800
Message-ID: <20260813075025.1406585-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7F1A9140005
X-Rspam-User: 
X-Stat-Signature: od9ejkbbmztci1dr1umi47aar5mu64uj
X-Rspamd-Server: rspam06
X-HE-Tag: 1786607437-908414
X-HE-Meta: U2FsdGVkX18U4D2ukHrXd4AJ5PhFnZ1NrOqPrn1mX3xhPNyesFrwPCmdb9ZEOYcvjKWcVc3ac8DKbrwEeTrvzxlYyGfaRbUbMLP1MJ6b/NQrXcWz6XfD0pqUl26S5MlEwZHN4IzGtVqBSbCGOat7EPrb9i1py9LzosyHsi5yL7CSgUy5UnV6HTWxxot/BoJJFQTcV6kQ5fJjNMlNr9XRy/753ZsLVDIYww/dJcXoiTT9x1iR3fDqEiEmovvJcZc2H1QU5LU8ohxSE5iLMHufQUBXwGRTE3wjOTILh9FxT6UDopEPyDDTpoAeT75mCVgPA1aSpsZ/amcoAA6aS/PAvMrWYZpKMNqvWhhRDOqQ82u9LSLQPxAHhX+AjPnRpm9BFCiupNbz8J7fFarTfhU/4fBtwwhbhB5JoW/CuSATY9xrJubqfQ01o3BT5iQgQYdRGJGW2pLg9O/yAWaxXfRLUBBQl818Xz8CZOmqL4ZPRORSWizb+NP4OBkRQKIjEPtjEJFYbI9lpvr46bZRXGGKYe0tzF27aJ3wM/y9tbOEmJNKkm/89alpocQ3iGwVjIdB9KoOKpunqO9paFW3fbQg0SvRvnsjfGksY2YliEGmcSN+59uhDY8c6taFDNmScJQZECS1tlEQiLx/1dDT+rypinCi9JmlLes4+4wuIURRNsf8+XC7ip48Rle3rtno4MREfTGkDq8cvqoStg1dMEG+JtuuIRUDtLnbKtg9D7/BszqNi1O7PuwKugCMWX0laDKF2P6n3r6ufUf4YyfvUsf3NxX7RU2WC+VYOtBp/WfuAOdS2rmFOD2H90xdGRCzsw4q3IZ0rPhQwEqetkGku97UvyBwkUXF9c2sB4aMlt2GFH7OtB/lQhYKf6XmygmKyJCG8hrmtT+Y6F8lJ10ySVsIr52tbE+MTLKadHA8Lej3FrffSw4HB0zoCZ0yVrBKNoWE0dkl1yN+s5CNMTipAGa
 x+McmkBF
 rsUNTe/6CYYGBqiICYK3gK3jKtKAf7MgbvykXz87hPSAcx9wQe05597zMrBePuod4zh/f0lPLqrHcd0lo3cXx/p/L93eNgXd/8fMUN5hmNLM7Kdkdykbscob+/9gSnBefG8u8R78pISm0O5zCPQEN5hImQ30mGRrpDOJ3TPSF1lAeTiBaoiDtFRJBEwUzrrW9D3g5VyOCifdVn1tKSbq9kooY37Vf70UTNEJwUNpsnJkKPqO3RaCeuvWT9rpyKyXHDM7qKwsM9VWj2x+hE78vwvtrCOz+3IvTxr677rCUf1K/m3GicxjzOnkYK8DyQw6Qpt5Ff2TSoeNehwmGjEXwXyq3QwaEaBsgP5MFqBMURGqXh61XE6RJonh7G1x7nNiOKBftcqKyqvbTQfXg2lWgHsqfBIkYagCjVGx6JBDlX1ZMFa5NcHPk02K0wn+7MOtlHbKMGmRyfT4mkkAIqdf3YS+vsu49gEO3VKY3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is v6 of Barry's original RFC patch, "mm: Avoiding split large
folios if swap has no space":

https://lore.kernel.org/r/20260618221720.71768-1-baohua@kernel.org

Barry's RFC showed the no-swap case with MADV_PAGEOUT on 16KB mTHP: the
large-folio split counter increased by 1024 even though no swapout
progress was possible. Skipping the split in that case kept the counter
at 0.

This series makes folio_alloc_swap() classify failures according to
whether splitting a large folio might allow swapout to make progress.
Callers can then avoid destroying the large folio when neither global
swap availability nor the folio's memcg swap hierarchy has capacity for
even a smaller folio.

Patch #1 adds page_counter_margin(), a small helper that computes the
minimum remaining chargeable space across a page_counter hierarchy.

Patch #2 establishes the folio_alloc_swap() return-value contract:

  - -E2BIG: splitting may let smaller folios make progress
  - -ENOSPC: no global swap space is available
  - -ENOMEM: splitting is not expected to help, including when the
    folio's memcg swap hierarchy has no remaining capacity

Patch #3 makes vmscan split a large folio only when folio_alloc_swap()
returns -E2BIG. Other failures keep the existing activation path and
avoid destroying the large folio when no smaller part can be backed by
swap either.

Patch #4 applies the same contract to shmem_writeout(), which currently
splits a large folio on every folio_alloc_swap() failure. It now enters
the split fallback only on -E2BIG; other failures redirty and reactivate
the folio as before.

RFC v5 -> v6:
- Simplify Patch #2's failure handling following Kairui Song's review,
  avoiding additional plumbing through the memcg charge path.
- https://lore.kernel.org/r/20260730122304.2496440-1-xueyuan.chen21@gmail.com

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
 include/linux/swap.h         |  6 ++++++
 mm/memcontrol.c              | 32 ++++++++++++++++++++++++++------
 mm/page_counter.c            | 20 ++++++++++++++++++++
 mm/shmem.c                   |  7 ++++---
 mm/swapfile.c                | 26 +++++++++++++++++++-------
 mm/vmscan.c                  |  7 ++++++-
 7 files changed, 82 insertions(+), 17 deletions(-)


base-commit: c73b725a57f276a3702ca213bde78fca029bc619
-- 
2.47.3

