Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8B5CCA0EFF
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 09:39:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 019458E0002; Sun, 31 Aug 2025 05:39:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0C418E0001; Sun, 31 Aug 2025 05:39:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD3D28E0002; Sun, 31 Aug 2025 05:39:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C50758E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 05:39:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 74AFB1603D8
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:39:39 +0000 (UTC)
X-FDA: 83836555278.20.D10314B
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4FB7540005
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:39:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=FIBxUr+o;
	spf=pass (imf04.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756633177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tARiBeQKogmSx6ScuL3aeyFoXa1hfJ2x9S0wEBpMSiY=;
	b=3YFhzvzrNZb4xfMqkIAdLdVx8lFtpsbkOoMAYV4yeXDuWCOZgod6F3/zZcbXTb9xVr21BX
	+ocVrEvCXCNk6R8a0TLyJxKeA1mCJJGqhUvN8GNlx8/Of1pgvMFm8QjjOu2xPQOEmi6TwJ
	v2qXBXNQX6lP3PW/AhNbF/Bfio//qBU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=FIBxUr+o;
	spf=pass (imf04.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756633177; a=rsa-sha256;
	cv=none;
	b=X8nZssq2uFDOqxKgJsezSCGc18umycGFWrjIVGlJi6mtx+9GANZVEgNob7hcoW+zrjaKmj
	mqOnIVX2sQJFgICvROlMU/Qs1FHVeKkttPpMU0qDpsxvXXNKdjDnAvrkLpkwm7Qh8y7gIU
	rhs4H9fJj8w18n5Lj/QFXLROcFNYvLo=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b0428b537e5so5126366b.3
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 02:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756633176; x=1757237976; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tARiBeQKogmSx6ScuL3aeyFoXa1hfJ2x9S0wEBpMSiY=;
        b=FIBxUr+o7RJCiGs54ApYWgUiDyhaw1nZ/ADyw0iek/J8wdD9sFQTw6viDQ9Kg3eu+A
         ct7po4CHuqVE8irt+Syxn9iEMGeUPRG95MjK8gReSMdPwcFWU171Xg5kJRMrhCKE/Njg
         GygIRPmsefQGD3PIrmKQPsGX68lnKGININIhcZ5v7LWl25b8iDlhFUSkLfoKIGTE5DQQ
         ooUFwPkdm51D5qUkF7Q6BKCZs2FSeJR/a3/jD98nFXRiMrH8tdAilw3ykuO9kWRokBPa
         0wQqllD9vkmxKYJ29dnC4AAuajQ1bXlD9aKKym5g7ItA6RNYjO6Cwj1t7wzOMUrlnexO
         b9tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756633176; x=1757237976;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tARiBeQKogmSx6ScuL3aeyFoXa1hfJ2x9S0wEBpMSiY=;
        b=hJoXXTzTdb+8ZEsmnpc3+GxJpOHytwV8qWQWlVIPPZa3nEo/dj4mOUv39OOKXpxnud
         rZCoZsQxwT0ovwyOVC2fayx7pTyTjNx4iwLzrWAmZUfiOXrmnb9MAE4zgcMGH2XvGud/
         XfmGG5d3ISdzRCjaNiYciZBAK2cg7AUEPtqIRuyF9Q2sfy8/f6Nd4L6zSBAOKQkITbDM
         v6J7qrCQnTSzuuqYvcm1BihjYqDnuppwluDBq4mytmKgAqrByIKXEmmeQ6xGgDySwnuS
         FfNdtRg+yZ+4ZMhSvcVWSjAi4LyyVoccm/CYG7ztZt17kzzYSUSD/y3Z7EKu7IMMgKjJ
         PeJw==
X-Forwarded-Encrypted: i=1; AJvYcCVVdTJQVwVMvsofeIOiWUSub46knIx8mGqzLFECLEdXwfc+JZT1DzD8a9D3UetkH4nM46wGsGYgBg==@kvack.org
X-Gm-Message-State: AOJu0YzcOCtXZJD7PMFGbA6j5lEFTzlUHZZc1DFVBkgwkjpkDIQiShBY
	BRcHO/KraCLxrRgk/Eiv2+Ghtqu8RTcmsbp1mnUQ3eEuHhoakuR9DEX26XeCpJW1mrk=
X-Gm-Gg: ASbGncstEiCi+A8rPXZEApRVVZIEVH34pabv+LW5mh/VcLOxuCKLRCFYCEq8o8sUaQj
	ZLCdmGcM0TsNlE1anbyUxHdzcoaV7etlHConC9gERObxorVBFgBXo5QlVJCY7lpDbsLHD/Pa6v2
	sHt2fUQyO0p0ReAP97nz0mxobC7E1w2TpUbwMMl6ZtJE+VSnV8XWL6Lg0PTDu9NKUhhrUT0xyhZ
	eisYBBjshtq3/P/fLZ2f2DggpDFIYB9LIfsbdt1TJmVffD3Sipa/QhmUze/dhrXk1zCkuTsgrJK
	WEJjOo1MsAPWs+FHJ/SaJv6hMLM/w+dKRArlXfG2rC++s88265TAx3dHWK6ZAC701p6JJUotnS7
	WAS5IGL84h6ZP/V5KsHkOrxyIQGeG/+hG/uJd0fJeJwKzgNhIlUWrW+F5gqncrENkxZtDnDEL9g
	ramm3z1h6rFJy87MqAjPkxnWvPpxkfy8GR
X-Google-Smtp-Source: AGHT+IHG4PxpmR9awAfjHMroFIHguhhrmpkWm97SaLqlciSkKd+OCg3v9JMQYZPVhQ3cfJwo9Iu/1g==
X-Received: by 2002:a17:906:7314:b0:afe:8af3:2ac2 with SMTP id a640c23a62f3a-b01d9730706mr425692466b.39.1756633175692;
        Sun, 31 Aug 2025 02:39:35 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefcbd8656sm597512566b.56.2025.08.31.02.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 02:39:35 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	vishal.moola@gmail.com
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v2 00/12] mm: add `const` to lots of pointer parameters
Date: Sun, 31 Aug 2025 11:39:06 +0200
Message-ID: <20250831093918.2815332-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4FB7540005
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 76cc9aemwu75b8a8m78yqnjr68taaqst
X-HE-Tag: 1756633177-570407
X-HE-Meta: U2FsdGVkX18PcWSDXmJDrqBNJMsPKbDoCERE8kAlpAjt4ek02PMVyfd2LIHSt2AONXNqIDOrywyIx0rHOwxkugbh9tXH9Ag9n1xk/FgLwCcRyzVB8CtarC7D2PKO7KGpUkbmczh6UKQznAuvQAc55ta8LStHH4UraM9m36VJxA6boDjGp1bKnPqZQzgdQNI27Pp+diuCCF0Ig36lhHofagMR2jOTS9f1FKeGY3okSL6wEgzHBU4wkBSDVka4mIzKh+08PcgzjGyka/WTyQdC1b+bLhakaLyh8tswSJ61t+aWCKXP/NgBZiqi/E4JBdwPWTOUpPB1++E8zbdexmaE6A7Pc4ecmCMaZ7IwdtIGq9TVR80tB38nO43rK7c5hwWes90v0rZG/O9M4Yr+NNhjDuAuRFe8AmDAY4qUQv5JMwW/DI5m3w6PNxJBPuxhj+nlwrEaT1jpXY0+nRLrKhBdfJNzvUJBfExyWX5tMLhxFgNXEkopwDESYzt55baQcyjqwmNWhgyJWyRPYE8wgBrw4T9aZqWHduWrf6eNvbq/UoRi9PsoN8bJVPnwLxGcprTkCaBgCepqWq5C7X7nP1CGpszG0JWjX4DeDRRuBxGiFSC4CTHSHDlwdy6mPeQdoYkQiBWU3L53q00vw+UNY73wocYejVMQTWDgHRkX+JMQ+qvE3OccY0ULCUzQC3unoO+8n9ymEbJqGfY5acbCe4DEni/ZztyX1xgAeuYZdERYFsWh89owwm9r6SA48K4t2nRw8BcgqSYgGwMFQ7xF2C/H81IMbzwnwdjwt8neLl3zr9mUKbp8aYPW8R2DTvtcEOoNI/CTEkplBEHOhmzA24siTBMFf5YLUFN7CeZL8UN3EOZ2FMnUBhDhXKbXEvcrkTZ+GkUzAUooI3HqIjDaUQ9syPADXYgfR7zrMLd9QHrmTSydb/0GG+6vIVvWxCbeUGhoDSoRQBht/UCOIxW4aw8
 ngNXzw1/
 31o0AjT1qC/LAf5vz7BJbPtdd3kKzoT8JZxU6vIz/1fpugCgClEQCmpDu4seinbsyJMPPkd1Qi06RwtxuGUYSHz8Sly50/R7Z4cYh1k+lqNnE33usgQ6CRvBKyjh24YYSxTt1btnY6FRP35EIWzvBEdtgAJ2UKXWnT+adUuiMYI1gANGlubUyOdtDiuC2YBjaqWHsB9s45kTnsraCXdcpTbLAHJdq8z66fTgT9LshvGR6v33GpgC+7CL1XWym0Oil8vfEkTMWZFMCk4bz3ThWUYgdghXp+nvxU6ZjRvRIENL+nL/svINMU9ZQW2wuAEv5o3/nGCeguGA4PHVpN6CNIiDqaxKbZJnd2Vx2dRAz/Pwk5QaYLWeQ0XxivWhXk/w+kNBqUnkcZ7Qa5ElzdwESYSmAexUDt57JYWGRSezVdVSNk6k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

This work was initially posted here:
 https://lore.kernel.org/lkml/20250827192233.447920-1-max.kellermann@ionos.com/

.. but got rejected by Lorenzo Stoakes:
 https://lore.kernel.org/lkml/d6bf808d-7d74-4e22-ac4b-a6d1f4892262@lucifer.local/

David Hildenbrand and Lorenzo Stoakes suggested splitting the patch
into smaller chunks.  My second attempt with one smaller patch was met
with agreement:

 https://lore.kernel.org/lkml/20250828130311.772993-1-max.kellermann@ionos.com/

Now this is the rest of the initial patch in small pieces, plus some
more.

Establishing const-correctness in this low-level part of the kernel
enables doing the same in higher-level parts, e.g. filesystems.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
v1-> v2:
- made several parameter values const (i.e. the pointer address, not
  just the pointed-to memory), as suggested by Andrew Morton and
  Yuanchu Xie
- drop existing+obsolete "extern" keywords on lines modified by these
  patches (suggested by Vishal Moola)
- add missing parameter names on lines modified by these patches
  (suggested by Vishal Moola)
- more "const" pointers (e.g. the task_struct passed to
  process_shares_mm())
- add missing "const" to s390, fixing s390 build failure
- moved the mmap_is_legacy() change in arch/s390/mm/mmap.c from 08/12
  to 06/12 (suggested by Vishal Moola)

Max Kellermann (12):
  mm/shmem: add `const` to lots of pointer parameters
  include/pagemap.h: add `const` to lots of pointer parameters
  include/mmzone.h: add `const` to lots of pointer parameters
  include/fs.h: add `const` to several pointer parameters
  mm/oom_kill: add `const` to pointer parameter
  mm/util: add `const` to several pointer parameters
  parisc/sys_parisc.c: add `const` to mmap_upper_limit() parameter
  arch, mm/util: add const to arch_pick_mmap_layout() parameter
  include/mm_types.h: add `const` to several pointer parameters
  include/mm_inline.h: add `const` to lots of pointer parameters
  include/mm.h: add `const` to lots of pointer parameters
  mm/highmem: add `const` to lots of pointer parameters

 arch/arm/include/asm/highmem.h      |  6 +--
 arch/parisc/include/asm/processor.h |  2 +-
 arch/parisc/kernel/sys_parisc.c     |  2 +-
 arch/s390/mm/mmap.c                 |  7 ++--
 arch/sparc/kernel/sys_sparc_64.c    |  5 ++-
 arch/x86/mm/mmap.c                  |  7 ++--
 arch/xtensa/include/asm/highmem.h   |  2 +-
 include/linux/fs.h                  |  7 ++--
 include/linux/highmem-internal.h    | 38 ++++++++++---------
 include/linux/highmem.h             |  8 ++--
 include/linux/mm.h                  | 48 +++++++++++------------
 include/linux/mm_inline.h           | 26 +++++++------
 include/linux/mm_types.h            |  4 +-
 include/linux/mmzone.h              | 42 ++++++++++----------
 include/linux/pagemap.h             | 59 +++++++++++++++--------------
 include/linux/sched/mm.h            |  4 +-
 include/linux/shmem_fs.h            |  4 +-
 mm/highmem.c                        | 10 ++---
 mm/oom_kill.c                       |  3 +-
 mm/shmem.c                          |  6 +--
 mm/util.c                           | 20 ++++++----
 21 files changed, 163 insertions(+), 147 deletions(-)

-- 
2.47.2


