Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BBCECD4F54
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 01:13:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 830236B0005; Fri, 29 May 2026 21:13:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E0076B0088; Fri, 29 May 2026 21:13:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CE4F6B008A; Fri, 29 May 2026 21:13:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5800E6B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 21:13:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 07705A02C7
	for <linux-mm@kvack.org>; Sat, 30 May 2026 01:13:51 +0000 (UTC)
X-FDA: 84822314262.07.6EDD58A
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3AEE8140011
	for <linux-mm@kvack.org>; Sat, 30 May 2026 01:13:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lkgGwnQL;
	spf=pass (imf26.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780103629; a=rsa-sha256;
	cv=none;
	b=dYmVzB44DQqZw6i5CQP0yi+gpazElWspQRn1gRXGyQ31XsSFjoEwnR0F4IX7U/zkwhwrgo
	NhAd4yMcFaA+zMi2BRagIhJ1WZPVm6gyQlyYtZoNI742tQr3nr1Ii2ImTRLjAcSz2PlBbM
	Umyl40xzvlhsl8hklBiRISbbVN/IEOg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lkgGwnQL;
	spf=pass (imf26.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780103629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=r/VOFkxmrFjmpK71zHKKmCYWDftYHpEtudi2FU9WHNI=;
	b=UiXrPqlCBZDhQYpygLgemdAc95UkI0jWUQfLKxo2cLFupcMaDGmRvEY8+xaVEhsEMu421+
	nNb4HX0tlz3WjUX+/Gu8msV4fgvJthiJAEKzsx28SMFbS7ZI4gGvPIcZNc6bHS6vPYd1Oj
	S6Ijatobg7SIz1aJBLceuLLPmyUai18=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c8584e80bd3so160614a12.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 18:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780103628; x=1780708428; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=r/VOFkxmrFjmpK71zHKKmCYWDftYHpEtudi2FU9WHNI=;
        b=lkgGwnQLIcZOWcWn9mSWK0eScsuYA63/R56f8ZPocEr+Sc9AVFBf4ED0/vZnMsduAt
         na6giHXGzJPU7kz94xLhOA+pSwrOreGyIlU8WQaZF9K9xXuAd7XpZWI61WamMXCJKfNI
         VcoAoCg+ZLfM/QqkzbUT/981mShbWKK+L650kbvj8eGLmjBaOksqpaCvSAViNBIQTRug
         bff97HzZKpDeWzEF9nAkjv/HhAJIMQlL9N24wxyqNYQpLIUnVklsZnRJESnnCkQ+fp8e
         DoJ3TU1BCPhTUexeu3MG8lhB1RFo+u567nUXn1gjuoPVnaSu+Qd5WB6Hj/H5vybXG1Wi
         tTpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780103628; x=1780708428;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r/VOFkxmrFjmpK71zHKKmCYWDftYHpEtudi2FU9WHNI=;
        b=lLe/sj3wG0+ciUzvluuEWX4cXn30pMU/GnwIA9cC2534WtROTO05VcgDfz7zbum+nq
         iuuWvozVZc3hIozpXYX96hZ6XilRk0wkJL6kHSY4pci9r9WSpYtzgQfkgp1MnAm2E+or
         xTeVQoK5pdQuka6RpydXH96FomUiILVDr2i4eFdZ2UTdD8h7SzOm6XH77mEHidtTPJLO
         PFRSvMBrhPw6Ba59PEUYyZed6e7mQqDKoEJDmxUoF6u2f/wcgInJu8R7ivP+piMGX4NK
         MsfwubW0Sd+f4TcDysLkVQN6Vo4yQ71LW5Itg+Kbf2FEWbWG2Crtbz5YmP2YNpB7o99m
         SUYQ==
X-Forwarded-Encrypted: i=1; AFNElJ+yrRkq/3VIaLahYQDwRwiyZs/CL4oW+fPkUAyTfETta60fIAs0BTjRZuLOiI4ubqnu5+fRod2lMw==@kvack.org
X-Gm-Message-State: AOJu0Yxo4v2iRuBog14UBKI4Ur7YIPNyCDMNGNgEDls2jHPospT0xrRo
	+EHcc/a0T548Z357DRn92A3s9srlOQ3BrHcRGRgFrXUflqWdZWVrcEYm
X-Gm-Gg: Acq92OFCCSzKuxJZ4k0K50PccyAbfNmxaG+dKJB//TNfRqPNZigtVGF5PmgabEGHrkl
	f2e9iMoIxLJbx0MFlfWnIvM0tcqO4M2ZR7wZ3sGa1AMzBkhvfRCkPTAeacyKvxn+GHvanMyUtRh
	9edBzNtnWjKVCDZp6iHmexelKAHz6m909OWB0QMZtQ5VboGyA0bt4EB0dHwLM15xrKBxHdDKoMh
	rY49kvzg6NpqlHJtaLN60afHzihM2NTEGamnd4oHMUz7cFAn0rDXN6fE41WMAcgPajLeHQnyrX7
	7CyWoqDwVE67lbxFhUJi/mxcOdkU/Oxi82L3bjs4xDAUR/2UNHImDHU3d1svpHL+f1IGgE5G7dq
	wtBD5DQYJUY5aYvs9AmxPTaprmAHw1pu5A69I20qPMokh1U3/YeUFXMz+p6mZSVSEqzMk05PguL
	ktJaLQsPdwfeON8DT/ZdU8I8jKGYnvmMGvqAZBVH1XrTxQFFPX2xR7/DYq2cNp8Isz7OhngPrDy
	Jk5q21f1YspmKVw7HOWcwjAIsznPZ1i+kVfsY6Ex65GMQk2XtXNQN9hAyQ80PvhJSI1693k
X-Received: by 2002:a05:6a00:1822:b0:83e:f5d7:6e9a with SMTP id d2e1a72fcca58-8422575060emr1614931b3a.50.1780103627856;
        Fri, 29 May 2026 18:13:47 -0700 (PDT)
Received: from localhost.localdomain ([2601:600:837f:c470:1879:8422:922b:e5d3])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8422b170f31sm431162b3a.33.2026.05.29.18.13.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 29 May 2026 18:13:47 -0700 (PDT)
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: bpf@vger.kernel.org
Cc: daniel@iogearbox.net,
	andrii@kernel.org,
	memxor@gmail.com,
	eddyz87@gmail.com,
	vbabka@suse.cz,
	harry.yoo@oracle.com,
	david@kernel.org,
	tj@kernel.org,
	roman.gushchin@linux.dev,
	peterz@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v2 bpf-next 0/4] bpf,slab: Introduce bpf_arena_alloc() kfuncs
Date: Fri, 29 May 2026 18:13:40 -0700
Message-ID: <20260530011345.99342-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3AEE8140011
X-Stat-Signature: nyfprzw31tha53qen5fpg7bnsgzscwpi
X-HE-Tag: 1780103629-49473
X-HE-Meta: U2FsdGVkX18Y98SwlQjZaTS8Oh5SHxUESONWWHPk1InhcDJnEwDai2HZ1gFXZZsL/zSybyZWJEAtSEWvqUgvj0FZEGMXIw2vlpXJzMjEsi3mroPtEHztT0euCW1HxEreuo8WtcWjLMNz0Yh2wvM6JuiGykqomRcM4N5RJhaqemG15fKlOwdLhufc91fMddwLuvS5PQE1th5o5LpqBlYMPbKgOMfNenRuNDst10vSe0yi6biV1CVsm/1S0CnzEEZPJFqLcPDzjBEnRU2PTWFGhLuySFi4zFbP3QEmaOOEe9OuJCqChGzmViw4EKx6480/D2qw0jHKAiMKhOHu5yxsIQD3kl3ZvQj/F1EiMjy0KfNCSauT3rCilQGhGb/gx2kTKAtyIqYaFRLSWMdxh+sgHk2ITOcbf9RA2y8NE6DA63jaCYCSq7IOiK9or8+2kJDYMlr6h/Q70lHDNQAcA8xjTmQBG0Q7KQCaX0+Idwjtf4Z/gYeDkgz/2DW2pPwPgek71y+a1S93XMlwBQezRbEkw4yvi2tv5lB+uUpEj7/5sWAmaddRiSr12wERPfgMbtHqj7L9uuft8QHZDk327Qe91OIJGG3yQsecfFpLo5mZSz6E51BVK1MEggDmT4iw+Tsrehj8c7DFIVyUGmSh3vTTqUH3LDgr8rqneSxJ7BrekvF8d2x7LcCiZbgu80rOOZJGVFWih8zZH+SzaEc+7zO+es0wwz8k61qiMvv/73LQN+CtzoHnwxyo6RKNmOLFVxCgAzRnV10H5cMFZflxAiSnAz9c7l6vyWg5z3208UjYl+gyyFkc9xVqL/NbZKwlyYmRg9uRKPZDRsfcpG260zDxb2/cB/3H9dIaeSuc/xKNPNUTMhxPpwKKaxuniLK8lTvqNjoiwD0bJn1u7VclJfoAKA3WTObSB41IpYYRLHDSzznDPSsR7K4+Mzw0wTOulrDqxppYgXri72NERAPXuIt
 iYl7VNJ6
 TeB65N8J5Dx57U8IKa2W5s7miEGCQv2aW9Wb8LFA53CYQ289rdu6kCjEA3yzompaP74uIf9vak6iMET3n+ER7zw68/bpXqd/V3pvABxWEMFFy7sfi9nBA7/BdpKahOtCyqL38RumyiY6QOpCol/M1GmVek9U34oLnfoMzhi/1XBuc7rf3BDWOgITN3pWhk3upNYqqWxQoHAXuGiG35LZnhAFRCvD/PrbUDW41kJbmYdZNprU4v17UAz+dzAFsSGow2brs3PoXs0afahmrqxJS98VYS/vIsSYdp7wvFDvj2bn/5evUQWA708pAuSuEouNHBUgDc3lgOb+i4lMakCQQMbx0VCS7vanYm/7vFPU62JNYZpFYtvLP0zbdwQojxI6D5HCzbLywut7HmAGfk2TsoPoTdCpym1pP/K6Q79Xl4v2AG/EjFxm1rZWWnMx/fYJZQ3SOQW/3RojV4EGYv2d8MQ1miJCPU8duP9gZqu5A1lPe1fkWWEWGtKukBS0w8XetLpaGentdL6/1DYK43sdcanZTDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alexei Starovoitov <ast@kernel.org>

v1->v2:
- disable kasan for slab-arena
  Note, patch 1 relies on patch 3 for correctness.
  I didn't squash them, since it's easier to review this way.
- fix issues found by sashiko
v1:
https://lore.kernel.org/bpf/20260529202438.16408-1-alexei.starovoitov@gmail.com/

Let BPF programs and kernel allocate objects in bpf arena via
kvmalloc-style API: bpf_arena_alloc() kfunc.

Currently sched-ext BPF programs implement various allocators
as BPF programs on top of bpf_arena_alloc_pages() kfunc. 
This is inefficient.

Recently sched-ext kernel core introduced scx_arena_alloc() backed
by gen_pool_alloc() to allocate arena memory too.
This is also inefficient and gen_pool_alloc() is not fast enough.

Hence adopt sheaves and slub as allocator.
See patch 3 for algorithm details.

Alexei Starovoitov (4):
  slab: Introduce kmem_cache_alloc_arena_nolock and kfree_arena_nolock
  slub: Pass kmem_cache to alloc_slab_page()
  bpf,slab: Add slub-backed allocator for bpf_arena
  selftests/bpf: Add tests for arena slub-backed allocator

 include/linux/bpf_defs.h                      |  13 +
 include/linux/slab.h                          |  25 ++
 kernel/bpf/Kconfig                            |   3 +
 kernel/bpf/arena.c                            | 425 +++++++++++++++++-
 mm/slab.h                                     |   6 +-
 mm/slab_common.c                              |   2 +-
 mm/slub.c                                     | 266 ++++++++++-
 .../selftests/bpf/prog_tests/arena_slab.c     |  59 +++
 .../prog_tests/arena_slab_freeptr_stale_pcs.c |  28 ++
 .../testing/selftests/bpf/progs/arena_slab.c  | 179 ++++++++
 .../bpf/progs/arena_slab_freeptr_stale_pcs.c  | 120 +++++
 11 files changed, 1088 insertions(+), 38 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/arena_slab.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/arena_slab_freeptr_stale_pcs.c
 create mode 100644 tools/testing/selftests/bpf/progs/arena_slab.c
 create mode 100644 tools/testing/selftests/bpf/progs/arena_slab_freeptr_stale_pcs.c

-- 
2.53.0-Meta


