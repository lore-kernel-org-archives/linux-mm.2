Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12A1BFCE076
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 19:29:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08FA36B01FE; Thu, 26 Feb 2026 14:29:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 068586B01FF; Thu, 26 Feb 2026 14:29:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB54C6B0200; Thu, 26 Feb 2026 14:29:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D2EE76B01FE
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:29:42 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5A4C413865E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:29:42 +0000 (UTC)
X-FDA: 84487597404.03.FC87D97
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id 98CBFC0002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:29:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TrD0w8q4;
	spf=pass (imf28.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772134180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AADVg9qc0LmRgS4Sxkhna0+iWY0MK1VRsyPEGxGIkaA=;
	b=ynBhIKU+WQw3PQ4zABdLpPV/KKhjn7wxztNHT4Q5H8UO3K3/9xpGxS1Ye4K/kXO2DqiBYB
	ZLEGp2oAdBXK1J6YWcxFrUaJPsRQKfg6yayKzjGjMZRovg4pS71iAeIdt+OYMLY05PRWO8
	4TzxpckGHQ7ugn10fvm1t5s0QoXlbY0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772134180; a=rsa-sha256;
	cv=none;
	b=ta519h6nMmJ/d5Wd9BOg9Hwk0L6dZL/AAEYRqFvXmTCD1YqLm1totnlTNRB9WpbR/o6cQG
	NcICunDuHKQvFAFdxVE/kQ+DlwkiFbvW31Bd9+kw6YYE7X5fZH+WndwUe3JD4qBVLa0xcl
	1KT67zP+hZxRKlWNlfIWjpn8gY+hd2A=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TrD0w8q4;
	spf=pass (imf28.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-464ba2bb3aeso348663b6e.1
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772134179; x=1772738979; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AADVg9qc0LmRgS4Sxkhna0+iWY0MK1VRsyPEGxGIkaA=;
        b=TrD0w8q4eNeWSykx8KuJTNxxWLBsbnK2WOysjXL8kGOb+4gDqYOkvCxdITDxzfsQ1m
         0WJ22urchXXMJzNkBgSWT0t+u1FCQfLzfcv9ru6K2ChMveAzkvo4PfeVuDqiCqTZZtlv
         EE7dAD8CfdDQWLWUuLvk99YJjnhJ+TN0zerLKTWQUZinHezbeNwag0AxS/EscmJKtYVH
         G4bu4jSr9rx2+jqtZLWz3LfLgtYJqeaTx0v7/+VzWZmMCYgmUZoNrFXdZVb+7JIf2m6M
         ya/HErnfuWHaeIcclAJyZ/w0P00o4MM+yUGR+po47QaydmX/+AG/EaVAJluYMsSTk19v
         qxuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772134179; x=1772738979;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AADVg9qc0LmRgS4Sxkhna0+iWY0MK1VRsyPEGxGIkaA=;
        b=CW1R9YFiwjT1kT/V1G5anYcdBduwbQ+b1HTDqLdpXHjF1JebP9F+0wfULEtBz4zNhc
         FpTMCqMS5T++vH4sj77HQ7A2xArSWTuRLjI9IEy5FfY2T6xugafu/QKT3OZ/WulFIk/o
         b8zLoFvjPdVhhZK1FjDTSC10uUVTiAV8ZxfyS5YddkHJo4yDMKTsidmEGnnYFGJmhl9j
         mCL+9fs4gD9QUhNfkive1/NfiG4jr2Cm657o0wgWaFEKanpPUIRHvAa9nS9gWTjX5VGM
         dbrBMge5to1ZOxBUmy5Ld3QQ+sZtNN05VX1KUEZRJnK9hmR1YmZX6/opaK9cBXBtwZiC
         2OaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUijj5ENVZU3RoOrFZlHe19hy49//tToN+Horkxb7H6OEwMPIreHD93/6VY76nxn1kIQW18J2ByqQ==@kvack.org
X-Gm-Message-State: AOJu0Yws+yFN7aXLbPyfFPDgxr7wcB+3UDcdFDuqILTp7gbBMpckp76m
	iBEVcaOQ8kFh3qSrEdMxYcOU+F+jrdxKyv4K8zKOHehPhUoQmoUoveRC
X-Gm-Gg: ATEYQzykEwAeG4XQTEuyBaDaLNa8O2cnTaAtkb5rpgJWkQQTgA/ayHCeqj5aZIW/nBU
	GYfwW6JgHMWJBRdunIK2izbSWp/rcGI+GSar2Maet3+SrFYs/Zi4aIjefznxLdS/1Ad7rAKGczk
	JeD0tN5y4aHhZ5ujtd2mYxNhgwm8gPV6Hfmb9O/LFzsZW7i4RL7+SzT67onh3bG/0Qube+pCuCG
	7O/fg+kTsNzqHMFDbuRKLX+ga/R4jo1jTt9kbiNEfOevDa/huGfHxeesgRfjFr64xQqdh3L0If7
	XaB/T7flW68XJn1XI+TgOXgVn3C1ICW6lxrFpN7h1OJJ8toB9l8s7FVZzrks8n8IbHWCp2y2B+O
	dd821t1+cDCbu4w4xep8QV2E8sWigsW58kqrxCxMT8znMwwgtFFcdElvvLrrk9G0lmQX1/GXnFF
	JEDWem1sOOn/rt/CQ7HrM7kA==
X-Received: by 2002:a05:6808:5143:b0:45f:ea8:4184 with SMTP id 5614622812f47-464bed8fce7mr134294b6e.13.1772134179339;
        Thu, 26 Feb 2026 11:29:39 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:43::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-464bb5e417fsm450688b6e.16.2026.02.26.11.29.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 11:29:37 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 0/8] mm/zswap, zsmalloc: Per-memcg-lruvec zswap accounting
Date: Thu, 26 Feb 2026 11:29:23 -0800
Message-ID: <20260226192936.3190275-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 98CBFC0002
X-Stat-Signature: da4o8eh6turhxiqyi7f39xi8ubnuo1wn
X-Rspam-User: 
X-HE-Tag: 1772134180-319995
X-HE-Meta: U2FsdGVkX1+fa7pczdLJsp7Rgblkxp08tSZBN6rA2bsWxStgVf8t2ejgLPMMfdqJWuwSGbWaiZI/zu7fyPwkrs6V8EtybuaFaBowoY/FQ5qIzP192w8h5y9XimePwI36qTxNliFayx24GjkCWlTnmcIYVmN89NQeOJsUM3v5u4Ntib/MdWXnVvZIIeI0VhgtMzkIPHeNz1/EnrEJzlUDzmL0B7h1ukkE3bKHk4jfkhpD7ar56E7ECG6d4ZOh2Odr/y79yN91vBM8Qrbvjcx2hyMaIlxetAwX478d8hLvPCp2NZrFVHQIiZHf/2nKFrqPV/vsLVRuPkSmXukCRujzwQe3T3ibe/DA42F8EwknHj+40XwmI9XVGxfmAmmapr9W3HouU1wx6XBrJIRJfUQ3lcwS56yjPeVvCekChyofVbfPsMhi04ndzk3g8busg299USry/EDQHSVIaUz0vqe44bxZbSf8vo4V4d/uynrCP7Zpej1PIP+cMIIYHBC11uf1a+zrUDIBhEfbt9IY2mImIItJycvYoCd6QVT/r4Nfiedvv9OXOpP7+e/dpVgIcnIO45oSdhGtP/Ex+PEcZLpUfLauoJqpBaEeAVcsuw0J4ZkYLFSMU7xEp3xYhl1Srvykt1QPWV3eywplsnSRRpAPRvao21vANXpgPCTrfW6Vq9h14VKjGB6ZeG6zDEyKuLWMxdlXjdPWb08ThC/ZGk6IVpbvEW89C003HjWT+/G6x6DfPWrpdlBRANVQC+QF5CqVpK/FBo0kf/9VWoWBnvKYvzdjPsqjGoJ2uWkw2Oqlp0RSc0KmbBiaG25zGdJsogTzYcTrWpLBXLFukYFwIZujftNjYFkW3mVyZ/mKBPHN4jNASvpU8tCV/+RHYUNEw1ydQ2zpGZF3Gl1yMUfrjlO6y9t3vavDqvek3XkzVrB6r0Zx+cZrq/EgNWrnVn2lNjW3oNHnUalUzMywUjLQmQK
 W0WCeSmQ
 /dUb7KpKWMAifMDwJiXmD86skBD6cKHop3rx+AGtfqyga26jjOFWBn5R+0FFX0VNAwGFhihtiAqRu4MN2VRqOW679Lna+wh8a1KVYW2xZVaBaJY631d+yORahuiog4sUtQOyD9YW6HrF2fHfc2gW71K8XNKx3ZnXk5SggrCELx4yalxtuO6HPOOwPw2y6kuqEsbKy7bIb4UlM0jHMVPyklfLfSucfd71VPYh09lQq6JFwCRVV8dtxuqCRiWECvd9nR5ic3h/KdT7chMwNOVuRTIWtxzryN7+dsarS/hTAtKj93SZyM+Eb2YN/eLyqxI2ptVi4w790meQJm87DYBDIZCWfDmKFqTz8Sl9gbADwJUtxmrcPRTTajCF+ueqFg3GChrxX/lToj1jm8mxto+rKaxHpVVU5HQ+41HzjyJ2/JA0cGDhv+kSK17NsElAtg+Mb0MP6qpIGfn+h8GI9b8Yg6qyN89l0lwMeOJutiy8eBOCJO3aaCqtXb7IeD6i8fRphHdZmoSBCeh3tmrYue3qc0t/o+9wO0OD7qO/McID8MYfOgDUFiLEOy+wPqyf01ibBAgYx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

INTRODUCTION
============
The current design for zswap and zsmalloc leaves a clean divide between
layers of the memory stack. At the higher level, we have zswap, which
interacts directly with memory consumers, compression algorithms, and
handles memory usage accounting via memcg limits. At the lower level,
we have zsmalloc, which handles the page allocation and migration of
physical pages.

While this logical separation simplifies the codebase, it leaves
problems for accounting that requires both memory cgroup awareness and
physical memory location. To name a few:

 - On tiered systems, it is impossible to understand how much toptier
   memory a cgroup is using, since zswap has no understanding of where
   the compressed memory is physically stored.
   + With SeongJae Park's work to store incompressible pages as-is in
     zswap [1], the size of compressed memory can become non-trivial,
     and easily consume a meaningful portion of memory.

 - cgroups that restrict memory nodes have no control over which nodes
   their zswapped objects live on. This can lead to unexpectedly high
   fault times for workloads, who must eat the remote access latency
   cost of retrieving the compressed object from a remote node.
   + Nhat Pham addressed this issue via a best-effort attempt to place
     compressed objects in the same page as the original page, but this
     cannot guarantee complete isolation [2].

 - On the flip side, zsmalloc's ignorance of cgroup also makes its
   shrinker memcg-unaware, which can lead to ineffective reclaim when
   pressure is localized to a single cgroup.

Until recently, zpool acted as another layer of indirection between
zswap and zsmalloc, which made bridging memcg and physical location
difficult. Now that zsmalloc is the only allocator backend for zswap and
zram [3], it is possible to move memory-cgroup accounting to the
zsmalloc layer.

Introduce a new per-zpdesc array of objcg pointers to track
per-memcg-lruvec memory usage by zswap, while leaving zram users
unaffected.

This creates one source of truth for NR_ZSWAP, and more accurate
accounting for NR_ZSWAPPED.

This brings sizeof(struct zpdesc) from 56 bytes to 64 bytes, but this
increase in size is unseen by the rest of the system because zpdesc
overlays struct page. Implementation details and care taken to handle
the page->memcg_data field can be found in patch 3.

In addition, move the accounting of memcg charges to the zsmalloc layer,
whose only user is zswap at the moment.

PATCH OUTLINE
=============
Patches 1 and 2 are small cleanups that make the codebase consistent and
easier to digest.

Patches 3, 4, and 5 allocate and populate the new zpdesc->objcgs field
with compressed objects' obj_cgroups. zswap_entry->objcgs is removed,
and redirected to look at the zspage for memcg information.

Patch 6 moves the charging and lifetime management of obj_cgroups to
the zsmalloc layer, which leaves zswap only as a plumbing layer to hand
cgroup information to zsmalloc.

Patches 7 and 8 introduce node counters and memcg-lruvec counters for
zswap. Special care is taken for compressed objects that span multiple
nodes.

[1] https://lore.kernel.org/linux-mm/20250822190817.49287-1-sj@kernel.org/
[2] https://lore.kernel.org/linux-mm/20250402204416.3435994-1-nphamcs@gmail.com/#t3
[3] https://lore.kernel.org/linux-mm/20250829162212.208258-1-hannes@cmpxchg.org/
[4] https://lore.kernel.org/linux-mm/c8bc2dce-d4ec-c16e-8df4-2624c48cfc06@google.com/

Joshua Hahn (8):
  mm/zsmalloc: Rename zs_object_copy to zs_obj_copy
  mm/zsmalloc: Make all obj_idx unsigned ints
  mm/zsmalloc: Introduce objcgs pointer in struct zpdesc
  mm/zsmalloc: Store obj_cgroup pointer in zpdesc
  mm/zsmalloc,zswap: Redirect zswap_entry->obcg to zpdesc
  mm/zsmalloc, zswap: Handle objcg charging and lifetime in zsmalloc
  mm/memcontrol: Track MEMCG_ZSWAPPED in bytes
  mm/vmstat, memcontrol: Track ZSWAP_B, ZSWAPPED_B per-memcg-lruvec

 drivers/block/zram/zram_drv.c |  17 +-
 include/linux/memcontrol.h    |  15 +-
 include/linux/mmzone.h        |   2 +
 include/linux/zsmalloc.h      |   6 +-
 mm/memcontrol.c               |  68 ++------
 mm/vmstat.c                   |   2 +
 mm/zpdesc.h                   |  25 ++-
 mm/zsmalloc.c                 | 282 ++++++++++++++++++++++++++++++++--
 mm/zswap.c                    |  67 ++++----
 9 files changed, 345 insertions(+), 139 deletions(-)

-- 
2.47.3


