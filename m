Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD692CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 11:16:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EB998E0007; Wed,  3 Sep 2025 07:16:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09C398E0001; Wed,  3 Sep 2025 07:16:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED3C88E0007; Wed,  3 Sep 2025 07:16:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D3ACC8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:16:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 70E5CC062C
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 11:16:19 +0000 (UTC)
X-FDA: 83847685278.29.67D5239
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9B6F780011
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 11:16:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E4o6YHMH;
	spf=pass (imf30.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756898177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IawJPEnnD+zQoWDwMg2PB+cX173xGR9WtQhvZ5+6Z1A=;
	b=YttlxjnD19ovgyy9KHTTP1xXaIbHJGSQi0a4OmRlfDJYLZnQ1o6swdVOfE1NudYIYxMsiP
	hznvo2x+CIAcdDc7NWM31gS7cIiFEyP6zGHIwvejpfnRj8czFkFrjzT/ByzzBDxH7nz3rT
	IO7sT1qTGiz+MRoTI5nL8terUEG7p4E=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E4o6YHMH;
	spf=pass (imf30.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756898177; a=rsa-sha256;
	cv=none;
	b=7hYP7kZIzVMfl/XrjZ9zAycgkkxvS3JQWRsfHFf/h2nXQLwbAwjzslnOaHaQtMNRrHVsW+
	K8+30xLEuvRruVim+XNOLLKrbtibjcnclmXo4nfnZ+H8c4WVm0HqnPRpp0Na96Yq4x5xd2
	WlkQS5PclohakNnA2F7B5arA3CSSCYs=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3dce6eed889so547550f8f.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 04:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756898176; x=1757502976; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IawJPEnnD+zQoWDwMg2PB+cX173xGR9WtQhvZ5+6Z1A=;
        b=E4o6YHMHOMnDU/GOAiXU+agnJXGnCpoli2ux39Ik2yEQorxdXuOrlnv+g6bvRd7lTY
         G/FxTbDGvaQK0fedCsvvP0G7z1cts8c9jmg845C0BAII63GA0ZRzYVBF+16trIKARZC3
         f9EMhCsVipnAcuHtGDe7ecjYAZ6RcTo+yvGhSTvu0DA1Lt0BA46geYtO45mxaB54R1SB
         H43FgAiRLxUUirPKjEJOXTFuQhFEeaNtEhzJEJB6rQ4oSohXiCDMaZdrvbfQUF/3TtId
         2XcPIHz94HPTVACSo1CoGHaXOMRI+Ym2Cypb6NS/SV3bcYWv/7Y42yp6X+Yk/jD4a1H9
         UPuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756898176; x=1757502976;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IawJPEnnD+zQoWDwMg2PB+cX173xGR9WtQhvZ5+6Z1A=;
        b=V+RDWoXv2jBVMom4n9wSU2mzuQ1aDrf6SJZFAZtLYYynO533z2Mp3hEYm8Rqk8KwHH
         hoKAbxVw+lif84G6Gx22bDfICkq+C3XDKIapRBzr/8AN1rCksqyZCbYprkG83YygsySt
         UtehI4+biPIH7c0Y/du7A6fjWjQykv95TcYhofI0MQLwFFpAh9lUiiF2Rge0OMWHt26E
         c1gGJY8IJDtTThn7Flk8bUuAHztkMPfObyST9+eqRZF8PD6O5K6OB0ZgheFoOJUpF9j8
         nVJoV0WEIAh66q92Z5IhBZxMdN9rmN1vkIZGS1EDB9j0mWqtYjTgYl5EM2Y5v94W2sMV
         +8Dg==
X-Gm-Message-State: AOJu0YymXWKqQ1HGbg5APhm75O/09OoDa130ibRof5ewUIlmdcD25Dwr
	LKqkZe4okFp7WdEusVhDir9MgbJ67LfiTz4juPQ/9/+H3lYXelJkj5y6
X-Gm-Gg: ASbGncsKp50TZ6fWi2xQB5uBOpnLSqIGDmN5BrzUYXrDbwwExhzii34brp7lLVQW9PN
	b+BMPNkZ8PaJ72RFPCZEYxkfEvwQjiRUDrgk1rS+R582algIYJOCH4vl93UBDwnJ77fuNOdxe5h
	qXb5FFc4cx3qkFQs85oHLlqPge38xD2wPCjkV5ED7iK2CYv10UYxoZMCb3UoquDMyH1TAB1vcNj
	aMFoObhwP6XnuGrTFI7lAdyoHdkOH8jTFzuOuJBiU3nItUABCL8gAgESwimKk7HJ+y4522tpycx
	2AcsiLgUXjqRDx2u4YfK+DRYnT5nlhNEG7p6ZGh/At/ivjXM0GDK+nNtJKzUzfmhOAL5A2CI2mZ
	igex/x5prBxNq3w==
X-Google-Smtp-Source: AGHT+IHNQ21LyL2/gZs64T7xHnH8p7OTsvdJjGM0qkn1zGoDSIWZgH+oIJasMsXQJ3GSsanQDA6gig==
X-Received: by 2002:a05:6000:4203:b0:3dd:ab51:d979 with SMTP id ffacd0b85a97d-3ddab51daacmr1895318f8f.10.1756898175758;
        Wed, 03 Sep 2025 04:16:15 -0700 (PDT)
Received: from localhost ([2a03:2880:31ff:3::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d92d51982bsm8038216f8f.21.2025.09.03.04.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 04:16:15 -0700 (PDT)
From: Yueyang Pan <pyyjason@gmail.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Usama Arif <usamaarif642@gmail.com>
Cc: linux-mm@kvack.org,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] mm/show_mem: Bug fix for print mem alloc info
Date: Wed,  3 Sep 2025 04:16:12 -0700
Message-ID: <cover.1756897825.git.pyyjason@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9B6F780011
X-Rspam-User: 
X-Stat-Signature: huikehjpt5gt3mnrxfr83b9g6d49ggeo
X-Rspamd-Server: rspam09
X-HE-Tag: 1756898177-638663
X-HE-Meta: U2FsdGVkX18j0lUqNfx6u59nqi4tUBjsq1Y6h03/4LHjGjZVMgWCf8BOGMoO9qBo41WyqLlwQKV4AggpYnPYK5vEhDhYYVqMQaJ6DFQOj7LqIO0PwV/LGV6cyGMk090hdGHwvjZr6NrROQDgKSDBgYvGZM6mYuwbYzp63hEvPkvTAemm2r0WUskzvFya79TCo2FpWf5qeViAO1vDQ8b/R/hcYIY6c0Rcv67R2avxmUo2ompO/2R4yt8KNQ1+tvJuaovBpeDK8G5cckz1LMLgCPrXK1Wj4qzgjTHS+pzYhFktdgC7g0qSL/pDtZwQ62nXs/RtmfePX9DxvGALcbZFb93V6/DRUcttZldy7MyisfkOwnlVlZNZQbQE8W/eSAcBg+CW+R3yOi740tDHL7FhoipDtocSwgk34MQogychlQNeU5btI8zkiCkSikzzkjzPLXR3IaHBETcJp2vhUQ5CYCMhHcFsfeodRi3oq9L/NrFbttISHCc9KLxYK7mEuUP7wCvZneZnOqCsbSuzUODVfZ2aULWMuHcvlgZPen58m4gt2OXBr9oxOyWm7Tk7QzvWVBtgsdDL+X/Gtmr1hePIvvOIOL0mgOV3hG11Aztuwr6mv76J+pGAV7GnjqbtrGWSP0z9TjO3SI8UJKkYzHPmr8EPEZV9Tu0ta00JJQeUjurqd+jJzTunhsw9ccvGmeGtQrXh44+PZoXni8fgpMiGmCFcnqTKKgsWTqDquQTq/6eAgsjbZazoag3h9araDZAc7TeyBdA4br7S30qZI44cnuy5LwKX0pWvBtyQMSW+GHqpf3T9XvvPuhgFavrYNC/24yVRL1OmTlUhiEz7+PzdRmVeHmaUnHkln5Ybq4CGNetU1UTYAWPXe5XmwUGBv3YcMm/vjT2hMbbT3NgBQRkABNMZxjgsiSKpqCbS6gpXkLUaGpI6Yh72dJlyWVNI5Urb904nZh+14/YugJqLmCC
 Lb35X4fZ
 uVwpZXpS4tLn9aFc0lsNdLYTIg7Pi4JsaS/pimcYxx7JlHrw97aidT1fh9cdheQzL6ru66MPl3AGUewf4OfatgLbJVG2liXgGYwIw5daW11tZOl+ToDCKBGah3S9CGk2Wk/kgjeGokInZsTLGNTv9iaDtVgue1H1wdAIjUu0Y8Voq7PAHZPqeuyAjT/lMDI/MdiVqTzaslxhD4CHSCRMCKbPlvOa/zr2PF/VSHD0l7lX63FMKwZRS1lKvABvC30CwKzG/3tuhbM2+EH/+z6FfjXqAGER0SwPrtzCgTlGUAHBHYtY8Wv0DIubQI8nWcX5T12tq+5wjutwsb7MxQsu0lXhx8Dq+PkX+G8fArV7AW/QjoDtoeR+JwSxzWFqsrJg26h7jbdhR2tc7s21mBySGSj8Lq0F+jbgLbfs0WWP7bkH2/1SIkpBSfzt/buVIoyTGoqb5V7JAckYo7O/Ox3k95kx9IZiRWkE/EmYu2Qr042H3GacIRj8xp36aT4Tl/lErqtIqVkOlYpTmDFGG3g1Xl5TIXsmMDQ4q3LO4BuNrCR9YsavazQ/X2Z1bWc8zxrvXcxUn6Uhior2WSflRIEAWcoBsZFBf//wIF80Ls4E9Y4ZYrEI=
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
is set and sysctl.vm.mem_profiling=0. This cause ambiguity as we 
don't know what 0B actually means in the output. It can mean either 
memory allocation profiling is temporary disabled or the allocation 
at that position is actually 0. Such ambiguity will make further 
parsing harder as we cannot differentiate between two case.

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

Revision History
=================
Changes from v2 [2]
- Merge status dump with "Memory allocations:" starting line
- Move the definition of spinlock within ifdef 

Changes from v1 [1]
- Dump status of memory allocation profiling instead of disabling 
the output following Vishal's advise.
- Move lock from file scope to within __show_mem() and replace mutex 
with spinlock following Andrew, Vlastimil and Shakeel's advice.

[1] https://lore.kernel.org/linux-mm/cover.1756318426.git.pyyjason@gmail.com/
[2] https://lore.kernel.org/linux-mm/cover.1756827906.git.pyyjason@gmail.com/

Yueyang Pan (2):
  mm/show_mem: Dump the status of the mem alloc profiling  before
    printing
  mm/show_mem: Add trylock while printing alloc info

 mm/show_mem.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

-- 
2.47.3


