Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01F2ACA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 18:34:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48DE98E000A; Wed, 27 Aug 2025 14:34:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 465418E0001; Wed, 27 Aug 2025 14:34:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A2C98E000A; Wed, 27 Aug 2025 14:34:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2981B8E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:34:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CCAAC118A1C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:34:28 +0000 (UTC)
X-FDA: 83823387816.21.0A3BA6D
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf13.hostedemail.com (Postfix) with ESMTP id F05B120006
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:34:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="GJBGjBJ/";
	spf=pass (imf13.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756319667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8hewu2I4eznp92bIJ77drWHJ5q2PS95ZOTmNM9Op0es=;
	b=st6sEU+VnBE7MwoksjiHXUlBs4uG0+AQXfANghX+q7Jtuj7gBjl5BXRy6QhVxYcJnkAUeL
	qbMgkghakNWCVmB7xOQTn2zw5EehkoeDHLsToW//LKHX/jwsnvii+8lg5I7rI/KNXAtSd7
	xb1/az1Ztr2EzKt5tMALCEPF1pAVgzE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756319667; a=rsa-sha256;
	cv=none;
	b=DrNekIhKvAbbdWxJnkdciKQ9xcK3s5tM5EO8otXn6QAUMZhHRz5pi4cKtW/EULZarqw6+5
	d5jp8wArwQ/rXK8upJwZCXfgOt2adR0LUtTTu0qs9QWGROstKUrs0M/vz8JOGSUY8jGnDm
	RTbNsxE/r2KdOlakYLWQlYSE0YwxBwg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="GJBGjBJ/";
	spf=pass (imf13.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3cb9268511bso94533f8f.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756319665; x=1756924465; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8hewu2I4eznp92bIJ77drWHJ5q2PS95ZOTmNM9Op0es=;
        b=GJBGjBJ/51HtYf5nbDbLDtzmRPMxezVvff2vlIM4t6ukSFOM1UjblWwmEHEoKd6alO
         uAHyCcH/sL9hdMEb7ABFiQG0MimsfmUfw9JqHU3tLd17PVLv08PXzt9pF1mUC/qlwLi6
         THU3OQvYOmYbep6vZoRIktREavmtWDDVg0h9fV3akjIaWRxF5pYxk492QnUa+H/1Y6ml
         Vmp+AXdsLL4YYIpCCbJ9goPgsgurX7u39ke+aGiS/EUS5xaDVq3wdOae3i2/raltTqnT
         eXv/YgpFyU8oVEV3qvDEh/uDvQD3pgKdfbn5JXoSSIo06dRBfljMmelYTK6yzOyLMWkg
         LDog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756319665; x=1756924465;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8hewu2I4eznp92bIJ77drWHJ5q2PS95ZOTmNM9Op0es=;
        b=LPgwZ1NGjOWLaGX3fRCZPJuAXXuLR/lLdQRh+xAFjz6el3peRnign540nYUvRboKzB
         x2MYo4+CS+lgu3FYBjTQnv4O8U9E06zc/u4scmDm7r2/WqAkS6Fj2bUUBmC/l/AlyEtV
         Zn5tdHUNvMOiY8FvJvoCc2jHVp6AdWPIgmL18uX9dtIae3rrj/zkJoglkmkhoXhJlesg
         zrydlFj3Eu9hgN5RiStzSg7yeHPSyGBL9D7q7ttj/pU2lOQPE3dO6R/fiwLM6TC0m+oF
         WLL0MLYBlvPkG03F3NFkKR6uqQ1el6YJGxCzPw9vJrBEd/7G14X1b5JDmo3g11VZNYcr
         A5vQ==
X-Gm-Message-State: AOJu0YyH1ExHcp2+f6Tdm8aPASYoWc1b/qKXxD/SHZr8nkDS+giHvsSG
	SU/eI416TAbSDQAFMbIdE+90EQcN4HAKywxWLg5CqxUeMzKHiYOtplxd
X-Gm-Gg: ASbGnctzNS8vSJMtwhj/GGJ39z0UJeq8xbXdok3ib7FK39gtvtL53dHDuhleBomz7Ei
	645DxsMaYXfrJasSIpV3NlQPuLSuvMPqyqZ+NOKI3P+tu4U53zO9LM53hQT94OzKF2BlRRWilFM
	lquqk8LFrSOdUM62DDopFSwEtoCceW/m3iuP5TYUxL4l1pIu7tttaOEcOQwo38sQ+Q798XMFwYT
	g9KPYe3obZniLBWnwObkpD//EG9hMVM6iJHWR/+zJWY/sXBmgrtWGrxy1jRmONKhXMNZFUEmMzM
	47frUfg45uDnMElgYwskQkQMjNc9hDGdHbpF2N4qR1inCVfEE6BapLNxcsj56bG9exzLiyFcMaO
	AVlHX27G9DLeED02usC4s6kNxOw==
X-Google-Smtp-Source: AGHT+IFvz83WXqrMhGngWZt5jAMD7RqcJWs7fdyEccaxQf2mlcp1tYWLaJIG6b4613PVwXsig7wB6w==
X-Received: by 2002:a05:6000:2386:b0:3cb:46fc:8ea6 with SMTP id ffacd0b85a97d-3cb46fc9122mr5146385f8f.3.1756319665116;
        Wed, 27 Aug 2025 11:34:25 -0700 (PDT)
Received: from localhost ([2a03:2880:31ff:43::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cc18f762b1sm5697732f8f.65.2025.08.27.11.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 11:34:24 -0700 (PDT)
From: Yueyang Pan <pyyjason@gmail.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Usama Arif <usamaarif642@gmail.com>
Cc: linux-mm@kvack.org,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/2] mm/show_mem: Bug fix for print mem alloc info
Date: Wed, 27 Aug 2025 11:34:21 -0700
Message-ID: <cover.1756318426.git.pyyjason@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F05B120006
X-Stat-Signature: qw8ftkznr877u4k7p38hre7fyx5r85rh
X-HE-Tag: 1756319666-211212
X-HE-Meta: U2FsdGVkX1/0r+rkYLXf42YZ3n96Wmd2+ANLVt23veAnNklrCw9vIpt/HL01QyEVfNlBS7rfRnnUH5jpNdeYseqKuajoM592tuc24arwf9bJIk/KkqJJqotnDfplOnocRNhdG0tazn8bJfef433a4psKkQ07SuK1q0t0HXU+M08BU7Nj1MRi8K/lmP/tanfrL7cesZlX1q6Y4f6aJqNtXtihDhffiLRLk4iYtOEyBOlnM/AHOpCcA/UI0b8LKy2sPufn4pRrIGs5FuAPBeY6dwDuXR3w+3ScP4wHlg/Pm/QUznEwZ0h96UlyM4jAfrRr1L4ax32y0/vhOp+aBlc01EaW7c0lxKEtc6Kj94PgOjnyOUh9vT5iV4vH3LPkYMYLBMlYk+aqQ7BSM1pzvDx0bsb5wCb0MOmoiKbcbZXSQo/kPKeeQPawAaPWT6EszO3T30aJr86wOBWuvSK5iEd0wqRUWR1hE+LGWFXyVxTxFrD4jWxKyvLuLnHUk5W3MHkTj6ca1WSyEWinTjLb0oQxhmcKeaWghZrg61Au44sqXCbJx5jl0//nNZJFypUAeptX1oV132hMvzwvlGDIKgSOxOxpJSKZev4pG6115/8RUasa5eqDwaaOUmGj3ktNa5App2dyiXLOPV8MHzfo97NxB+j5i61RtFFtEkPFoP3T1/jDFwmdOJSbsqyUFjIyV5LyXqwTKHygqsplvPPNpBz+XWPJbazA1rY2RA8m5ad1y6By4urpUV9+i4dJlB+VaAqe5Yd6U6vDbVGPd6oX6y6uWO/PiPNVgiHuf/aLiIEDwXfFZdmmg14cUOfi8EhhaBUOkX8af1Zr15eNAykDF01fl3Rn20YbrA6Rf7hLoQCIT+CgyHIe0ioZq5R1qEY5yRh+/VPWFyKM3uUyosK5RzBRIL1AymwOiKLjHBmiLf476/uWMO7J0pJ9O9rqiHzul6uigS3ehJb+G2EPJdscQCD
 sSFsnocN
 1gadI6BsdpWzWKak6pr3r6aVCXbMuLo2vYtabGQOiuv6rlsspyY2eJs3pzp7YP1I4ZM1lA4TGVLg03fxE3BIgqi3MAFWHrQrRjqEVC2b/tKaZV4FE5LQ/cgTBLGVltKpnPGys3PLq5Bk0EK02KWir3Khe28rc4c4YnzZxiQ1FzUwMC7oJ04s81S+ppGGRbK8+Sh59rotDdzK6ZykPz7cpu0frrN6hlnxB3rdxv718ZDlO7lCMsRbTnViCR8pT+XjuRhBey/5VX25FCfQ0Pex/KCNPjj6BSzka5OoGvbkjNBH3IQ/LXGqhLQMQ36Ft1naE7A94fVPRPZWzyO+fQq0VGHPbjVcu7iSwjhVptpgVNUw/RJT0JTAiELA2wUp4qWNJC7rI3ZG44DdfQ6VsjPyCdtxU5nIaZRWU2zZeOVkmbtN6s77CUaCP0Q/BEfPVr5RKBFkKqEK90GLKT9wS70CXtOQl11paG7bFBQzIxqMs3ij4gvAq/swsOHHdgWNa8tAALTvoEZL2M6BSyBDvL3lKj7yhiVWFPugzYeY+S+bIRftpqWBxx+jZAipXaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch set fixes two issues we saw in production rollout. 

The first issue is that we saw all zero output of memory allocation 
profiling information from show_mem() if CONFIG_MEM_ALLOC_PROFILING 
is set and sysctl.vm.mem_profiling=0. In this case, the behaviour 
should be the same as when CONFIG_MEM_ALLOC_PROFILING is unset, 
where show_mem prints nothing about the information. This will make 
further parse easier as we don't have to differentiate what a all 
zero line actually means (Does it mean  0 bytes are allocated 
or simply memory allocation profiling is disabled).

The second issue is that multiple entities can call show_mem() 
which messed up the allocation info in dmesg. We saw outputs like this:  
```
    327 MiB    83635 mm/compaction.c:1880 func:compaction_alloc
   48.4 GiB 12684937 mm/memory.c:1061 func:folio_prealloc
   7.48 GiB    10899 mm/huge_memory.c:1159 func:vma_alloc_anon_folio_pmd
    298 MiB    95216 kernel/fork.c:318 func:alloc_thread_stack_node
    250 MiB    63901 mm/zsmalloc.c:987 func:alloc_zspage
    1.42 GiB   372527 mm/memory.c:1063 func:folio_prealloc
    1.17 GiB    95693 mm/slub.c:2424 func:alloc_slab_page
     651 MiB   166732 mm/readahead.c:270 func:page_cache_ra_unbounded
     419 MiB   107261 net/core/page_pool.c:572 func:__page_pool_alloc_pages_slow
     404 MiB   103425 arch/x86/mm/pgtable.c:25 func:pte_alloc_one
```
The above example is because one kthread invokes show_mem() 
from __alloc_pages_slowpath while kernel itself calls 
oom_kill_process()

Yueyang Pan (2):
  mm/show_mem: No print when not mem_alloc_profiling_enabled()
  mm/show_mem: Add trylock while printing alloc info

 mm/show_mem.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

-- 
2.47.3


