Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C703B606A320
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 14:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=YkwMSiff
Received: by kanga.kvack.org (Postfix)
	id D76976B00EF; Fri, 30 Oct 2026 10:08:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D27426B05B1; Fri, 30 Oct 2026 10:08:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C16296B05B2; Fri, 30 Oct 2026 10:08:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 958B06B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:08:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8E04FC073F
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:08:33 +0000 (UTC)
X-FDA: 85379472906.02.4E260CA
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 81EBE10000C
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:08:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YkwMSiff;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793369311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OGrdsvz70oET1GgEqFqkefkFXtM+kYm4wLwbKsNMt9o=;
	b=dRG4S29iLugqHhQOkFZNxdMQgJZJO4fzGlvOrvHKokZP6tUB6w7t6Gnpm8j5HNCGsPUGxt
	lbnSaSwdY/33rjT+ynzSrjO5zxtddHw/CFkFVaHE5vpRKyKw5HtcOFFd00H6e3RDqkqRO+
	kt5n29LPS6X7pkEj//hinge5/AeIvAM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YkwMSiff;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793369311;
	b=ozjc0VYsR4lu6uQnYTuuHqnx2DaSOKJRJhqAE4othRM6ajLrQtT8jGRTjd6iEQJpe8v3Pp
	FjMNdsy/Y9uRZV9B+jYmVbUc7sczCayxJGxFGqjSZdl6O9gpnPgTd7OqAtuUH0pT7e+qKR
	RwUXCkqhoad9YpKwQBPaQ3wVuPJk1OU=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ea0efd636dso6619585ad.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793369307; x=1793974107; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OGrdsvz70oET1GgEqFqkefkFXtM+kYm4wLwbKsNMt9o=;
        b=YkwMSiffAuOrnSP6jFz+I/U7aBvPsN8cjq1VsqdyOONAYmt7lScKKsy9f1lka3hiMA
         nd59aWJmSmSrQTDdhS7ADYyd6mxG81p1sxNXEc69HPCUNgJhInPDvnC1AJ7p/5kyJ+R7
         2Sy5rBtjXBLNbhiQ2A3auKiWnNpjJDaLNN/OROdWhgJTqLS6o3NAz6tswT1OZ/kegn6G
         N/+Zx41o4eOv+g8AGi/ilGnuiun8/LY0AeA4Vwwn5GCtTHTwJOQrG8gDuyLOWVnJ6XSc
         XGTe1DEwAb42EUHMHc2FHzUO6Z8u0o89cEc5kQGWfUVTwzxukvGLaTeeGcck2lmCbCub
         +lGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793369307; x=1793974107;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OGrdsvz70oET1GgEqFqkefkFXtM+kYm4wLwbKsNMt9o=;
        b=C28+if+T7e1aRH/qPE+U4nAJGFeMoibTjoLu8UDmbaUPpioFzTCRf8lxnLhUa1CJV3
         YQ71ppfmOgf1XGraU/7faCnD0RhgnfaEtcCnC8HqRBwp86VqtoVyO4QTbgZWcjg+bQxc
         e5iXEaUCRfipA9qnqWZI4aVkHlhELQShRnmNBoZlnLzjoa8sXaja5IO4wzUhnUvsHyNU
         wI81r7AsfUYN67EbnSuDDVTYGlbOrhz5wJxKNwhgshlt2NERSM4lLeg+LXs/+wFSzmFp
         mCugtR4Pqkkn5EjAEOqXEfaENYzhFNqy0lg3iQHADKkdF4djW7TDtlBbKnnnyuqJViVS
         vIKA==
X-Forwarded-Encrypted: i=1; AKwUvByYF3mLZfN7+6/hertD2+hPZ0qoyIxVjoKrM54A8Or5cH5fs15qMH/uTgsq9YqLecH9KKYmff1EAw==@kvack.org
X-Gm-Message-State: AFq9FYL2GwrGceHjfaMOEmS+wuDw8oBWHvBdllCRsGIijVuj3ucpvHIA
	C77fq4XbN9bH48k1mkTr6jqIljxJHe0/toyct37V81y5NAUjxUemgS42IQ7xu7jXMew=
X-Gm-Gg: AYBFou3MHcONy/BaEq9i4sW4xf+IcmUOTLxNjDdtDWfFZCXgrP6NXI4XUN8xzsayfLN
	JI7Tas2w/ywz6NTgAB/TOzzmQlvnG3mwGw3SZqkzSLp13T5YPC4iVCNmqDoiHmgXyr0v2Y6vLg8
	bQrXu0Hi1rD4GnzLbFIXMnPZHF25hiiV9gZTJNg4UzsltBi0yp7g9MF0pGxuZScWFeaDdWu8o4X
	AKu0mgIuZ4kLoCFyaqmFiKwP9CF2mGabN+1lGQuQFom8CzsIgmgtQwyTl3UuOhRzbV0a0OmqLSM
	D1kuq77pN7G9jY7XnjYrmokZURBGhWT5tlNRcv5HlfEL1wPm96kTN2dKIjx4S90yVws2CnN4xPc
	txNRooXfPQ/viw7qraP7Ngw2pyCUv6DrniuU7lN/zeXbEG4j8p0IBtFewhcNuG/27qnn9VPS1Q/
	jiVbsjveb1gRPWNCHibOsAlBXzjda1cpEGyXwSYVSjKetb/Tp3eZwL4tkBLIwFq1WiiWAaE686m
	ofS+SuwwXdvUkcfZfiIoPn7O63qH/2Dvft3NytFqkABKYfcthtJO1KZ0ENcdQhUuQlkSrFwU+3f
	P3cRdBTBbU16HtUYlXSjtBDWHTJUWIHjsA469/iH8W8Y7rw5W/w=
X-Received: by 2002:a17:903:24b:b0:2e3:1bb4:610d with SMTP id d9443c01a7336-2eb364f6800mr27744295ad.50.1793369307550;
        Fri, 30 Oct 2026 07:08:27 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.100])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb3929b27bsm7601795ad.62.2026.10.30.07.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 07:08:26 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: David Hildenbrand <david@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Lance Yang <lance.yang@linux.dev>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <qi.zheng@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	loongarch@lists.linux.dev,
	linux-s390@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 0/4] mm: Simplify device DAX vmemmap optimization plumbing
Date: Fri, 30 Oct 2026 22:07:16 +0800
Message-ID: <20261030140720.1256062-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 81EBE10000C
X-Stat-Signature: 6xnggox8r41bpgrbinyhs5zooz1s4zz4
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793369310-603188
X-HE-Meta: U2FsdGVkX1++Q6JAcHZQrg0zTVqViY2UrsjLRYG3OFT5Dj3CFydtzVh3WNDSeLpUX+fEIUj8NF2VXaUl8Kxj86iPGV6ZGWyKfCnFYtmIQFEaL+xczNf+v6D1lGRbPLGminKgKf6wZSo1dGcKtj+dfBwtdY8PzytkILKdSvyt7k1i1CUXIplKqA6uS/ERfT9++9hffI4ex+15dLCT0dfOjB/NtAxEr5aZNhEQYVNIYYm75Uqx1Zywek3tB/BWU1bFUo3pXoZxnR7IDcjge/60DhWSO9QgVJg9km2VeFwk7jldCfMnIh5xDZypsfZLQ/m8m8+fsk57o5He5pvFzhlg9fRS3kLl2UPWu0qW3JPtTOEhrqCtrGNy4PS1s3Sbk3hBXeNzG/a3Fuw7J1tsr1mY+Rwjm+3T+XZOnn8oFEA20Wx+kjHrUjztcv7LoNEyRjRJ02Am7YUu0xquu4ssnoeoGKnQuxujrRcZlQ8RyasHTfebSQ7sIjC/wgeDw5fnHpvkEwjA5+fXMy8zNvAxLJcG0DIIDUyLP0pg9xqRRX10L9xxDVYOcUkiQzVJJNLjfIuXusj/IdH750yOla009c3w/IAp3JXhuf1k4ytgDwkmVLqAWl1jEOgFiUaTdz2CI342AW3Eba3ShUue6N0N14iXTYpEPCU6WDZsRyvDnyxloTcCzzJgeaPXnGyNz0+SR/ffQWF/ZYv0hbnSFTW1yeN9A9Dv90mi6gIjcfuyACfZvsL4Jq+y+gLNShbmdb/+5h0Zl7rP2W1IblWLO9VtmqwU+dshKANYytGVIrJ4eTmrJwk/A8ZjQj8q9VTR9562qyaBbUHCea4dqB0hixfQrYqgSbm+w7G8QdQMwpiCm0STss9FmH+8VQBiBPN94VdEW3f/9qMElxoRN2WWpO/xT0JZOM5/qPCIm76aKIe/Uc//MGRmopYuD9U0Ezg8jQzBZNuS0XoxuO2nAiXlQaUp968
 pUdV/jjp
 AL3Gw1ubE2gYrI149ge6pYCfEewm8flFNsIg8A5a0jF6Hn8jigvwDByA4coAvBIir0Cpn4Wihwp+nXl/NdnvY931+WqJoIipxim4AycUBCjKqN7mehFFaJNNFgJcJfESCOFCVTN5BIy57gecKzRaOp0w4CyDw0Tb2ujuCPiMbcx7En7a3+aTSmaC+kuEuzY2MAK0CFmi/XLgWx9Q09UxVE2wr/40oYPp1xP4jUBigN+9yawp+4JaKqtziho+48hN2yiBsYecCHDFgy1E9nzr1POqbZdc/0zJSk+CWRA2g0L3wuJkVW6dTSPrmjY8LvU79gWrpIme6sbgJ7qjWTc2gp2HugkvSOCFSfxOWMnxNwSZBgsQCWp0XsgpW+A0cdQZmiaPw46kW92pbUVT/jOWiUbMaH2yYudiS8KoU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

This series is split out from the earlier, larger series "mm: Generalize
HVO for HugeTLB and device DAX" [1]. While the parent series generalizes
vmemmap optimization across HugeTLB and device DAX, this subset addresses
a single, self-contained step: simplifying the device DAX vmemmap
optimization plumbing.

After device DAX was converted to section-based vmemmap optimization,
whether a mapping can be optimized is carried in mem_section, and the
architecture-specific population path can handle any remaining fallback.
The code still retains the DAX-specific vmemmap_can_optimize() helper, a
PowerPC override, and @pgmap arguments threaded through lower-level
vmemmap population and memory-removal interfaces. These duplicate the
section-order policy and keep otherwise generic paths coupled to
dev_pagemap.

This series removes that obsolete plumbing by consolidating the
optimization policy around memory-section metadata and simplifying the
generic and architecture-specific population paths. This also eliminates
dependencies that are no longer needed once the optimization state is
carried by the memory section.

This leaves the section compound order as the single source of truth for
vmemmap optimization and decouples the generic sparse-vmemmap and
memory-hotplug paths from device DAX.

This is another smaller step toward the broader HVO generalization.

[1] https://lore.kernel.org/20260513130542.35604-1-songmuchun@bytedance.com/

Muchun Song (4):
  powerpc/mm: make vmemmap_populate_compound_pages() static
  powerpc/mm: drop powerpc vmemmap_can_optimize()
  mm/sparse-vmemmap: drop vmemmap_can_optimize()
  mm/sparse-vmemmap: drop @pgmap from vmemmap population APIs

 arch/arm64/mm/mmu.c                        |  5 ++-
 arch/loongarch/mm/init.c                   |  5 ++-
 arch/powerpc/include/asm/book3s/64/radix.h | 12 -------
 arch/powerpc/mm/book3s64/radix_pgtable.c   | 23 ++++---------
 arch/powerpc/mm/init_64.c                  |  1 +
 arch/powerpc/mm/mem.c                      |  5 ++-
 arch/riscv/mm/init.c                       |  5 ++-
 arch/s390/mm/init.c                        |  5 ++-
 arch/x86/mm/init_64.c                      |  5 ++-
 include/linux/memory_hotplug.h             |  8 ++---
 include/linux/mm.h                         | 40 +---------------------
 mm/memory_hotplug.c                        | 16 ++++-----
 mm/memremap.c                              |  4 +--
 mm/sparse-vmemmap.c                        | 34 ++++++++++--------
 mm/sparse.c                                |  6 ++--
 15 files changed, 54 insertions(+), 120 deletions(-)


base-commit: 5e6c45aaaf93343c7f8a1cde9797080238af5c1b
-- 
2.54.0


