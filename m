Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4455CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 08:43:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8D168E005D; Fri, 24 Oct 2025 04:43:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3D8A8E0042; Fri, 24 Oct 2025 04:43:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D04FD8E005D; Fri, 24 Oct 2025 04:43:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B651A8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 04:43:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4BD58140DDD
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:43:16 +0000 (UTC)
X-FDA: 84032368392.07.DD7A81A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id E6116140004
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:43:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="CmeR/de2";
	spf=pass (imf09.hostedemail.com: domain of amarkuze@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=amarkuze@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761295394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ihAbQbr27WsLP3ns7L6UlAE71u9nLb/VPSGVkAY4Vro=;
	b=Q5YjKb9kKubqFVaSFqmOKlDJooefNqBygW2/32ddd/BwEmnolKkzZoJFHRzMXLNFmW9l95
	cuBfUj9LFwHicT6s3G/1Wn5ngzcGN5HsBrl68NFPDIppSsPiMFxODAdoLVsEnH7ARSFTNl
	2WwymCOphekqOcj+pGzKD8Gv6DtD/Fk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="CmeR/de2";
	spf=pass (imf09.hostedemail.com: domain of amarkuze@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=amarkuze@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761295394; a=rsa-sha256;
	cv=none;
	b=Y4LQ/ig9fJX+m13T9ogr5kj2aCqJf6DGGDsziVICt/JouLScTdjIKaQMdQ9RIJJwz4DIqj
	pt5wAFvkZx9Qj6Aglq+sipuJnlLh5r3W8TUyRjcrCfs3tBklhOS0DfSY89SZAlfvFsblXS
	B/zeFA8Gp23tIxK/gnpmpyf1vXVCCME=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761295393;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ihAbQbr27WsLP3ns7L6UlAE71u9nLb/VPSGVkAY4Vro=;
	b=CmeR/de2VWCGHccHwd7DD/Hdft6qWVfPSqLuepIdzamfgogpB7YLGrOCblDdYr+1FGQaQu
	GcIQ2sM4YsUcQUOVnlnkitY3cVJkStMredjE7plrTmITUxxupirz/zF7UP8Xg3wiJS1yga
	wrIKjkBd3bij4s2ZcIeOwlIzkyaoA2c=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-43-e49DzwWCPkm7rZT6lkscpw-1; Fri, 24 Oct 2025 04:43:11 -0400
X-MC-Unique: e49DzwWCPkm7rZT6lkscpw-1
X-Mimecast-MFC-AGG-ID: e49DzwWCPkm7rZT6lkscpw_1761295391
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-b6d731278e2so41493266b.1
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 01:43:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761295391; x=1761900191;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ihAbQbr27WsLP3ns7L6UlAE71u9nLb/VPSGVkAY4Vro=;
        b=Hg1TguZmf6ivFwhzv9A2lZIcKhOwBmMd5YwmRaEZWdKj5gPGrdfaYjzJ8OYNBQOMkR
         YSOwMOxO35z6OdzzyoHZvM/eVo+6AbT89SS2owqx7RMURknqW6f+b8xGHgYSlFf98Twe
         Rj85jiBivnM0T2HVIx7fIBqH5Mb12uEKeUnc6iiw7DSl3Aih09XzG9i70aTle+zEx2pE
         94cyIUUfXjvPAx+8IUZzL9cAZP+STUh9992LDUFYYIBV99YvWYIso3IZd9zNUvFt32Zb
         3vU5pFuQ9KaUS4DjGoyZzKFr/L7zIh33HQvxKPRr5NaLc36N5kNsTHNjZYEx/Wr4RPpe
         Xo+w==
X-Forwarded-Encrypted: i=1; AJvYcCW6NbHk8KTfMULtkMs2iXPrGL4+j97KA/1TBCTY7ZFSnqutlkBRNeSDGt0tuMGCJkE7k/jpQ6zdkw==@kvack.org
X-Gm-Message-State: AOJu0YyGJtj7xKd1k0qN/Ud4Ba+R2nODVGPqJ+i0pUBsFMmd2D2P8Rcl
	kXosHv+1NdcyUNTphEO17l3s7TW0Fgxy9DT1Zu/FjG4CYNGDdA2+4I/MN885jy/FLARFlIFhTJ4
	Hm38KKlG5NEpIIueli+2FskZMnDrld99ExhWrZi0T0TVrwcwCZ6SC
X-Gm-Gg: ASbGnctyybmVHYXPRqbj6J0ETOY3bcvE0gtclwIkzCIKhDf/f2uGt8jaOPsS3Z3D+Bi
	qlEHxLWfZ34VrMOQZ0GvRmYdYiSBy9e+M+jWsx+ZEgjtgD2e/2YSNIuOOiIWlQ/5O3i8Y1jErra
	eOu+wfzs8sRUTmzXC9PXE2HRDC6fRE5Dub64OLCHZHB0aDPgDtcsCHjh4bJGTry+LQESRhj2CHk
	R8q77lX2yl5bMEysrSH4eCxq8rc8veu4o0SgkeFW33OHhP2/9LbhwRSBKMTkHI+XXPE/jt13qPD
	VKaTzL/xZ+fC6Sn/obfqHLKdfdkzya5SDUANte71xj7ruQHAxO3V8UMON1T8fnuACL5+W0Bb6zg
	jDZtOLBRoe/Zy+7MbWA4TWTKG/LfO61T0
X-Received: by 2002:a17:906:9f8c:b0:b54:8670:7c2d with SMTP id a640c23a62f3a-b6475511a47mr3482249966b.55.1761295390567;
        Fri, 24 Oct 2025 01:43:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFOHnkb1mB3ffZrYlSB2E6fBCurSJStxVjsCwJbw8nBPqLnI6mTwLJLcTU5DTEn063YP8uWQA==
X-Received: by 2002:a17:906:9f8c:b0:b54:8670:7c2d with SMTP id a640c23a62f3a-b6475511a47mr3482245766b.55.1761295390126;
        Fri, 24 Oct 2025 01:43:10 -0700 (PDT)
Received: from cluster.. (4f.55.790d.ip4.static.sl-reverse.com. [13.121.85.79])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d511d010asm469226866b.11.2025.10.24.01.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 01:43:09 -0700 (PDT)
From: Alex Markuze <amarkuze@redhat.com>
To: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Liam.Howlett@oracle.com,
	amarkuze@redhat.com,
	akpm@linux-foundation.org,
	bsegall@google.com,
	david@redhat.com,
	dietmar.eggemann@arm.com,
	idryomov@gmail.com,
	mingo@redhat.com,
	juri.lelli@redhat.com,
	kees@kernel.org,
	lorenzo.stoakes@oracle.com,
	mgorman@suse.de,
	mhocko@suse.com,
	rppt@kernel.org,
	peterz@infradead.org,
	rostedt@goodmis.org,
	surenb@google.com,
	vschneid@redhat.com,
	vincent.guittot@linaro.org,
	vbabka@suse.cz,
	xiubli@redhat.com,
	Slava.Dubeyko@ibm.com
Subject: [RFC PATCH 0/5] BLOG: per-task logging contexts with Ceph consumer
Date: Fri, 24 Oct 2025 08:42:54 +0000
Message-Id: <20251024084259.2359693-1-amarkuze@redhat.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jIMff8AEygjP440x0FLBQphdpRk827NQaxh-l82tHXo_1761295391
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6mcf6hzh63ibe4f4g5huagpujrr49b8t
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E6116140004
X-HE-Tag: 1761295393-936299
X-HE-Meta: U2FsdGVkX1/oCmzXG5aI4kIFdw6gf58HkSeyF5MvkHdEtkTeeyl1bthJ3v/5wF4jpMkSDf4/rOjll3/vkzgDeEIom5REFNKeY52yOYc9JiIdXDvxmqB/lS+J4Eb3CjDxOeqb5XzUDoVw35sGh277gUXWh++jUIPXMP9vt6xm7nqElsyiZQZklfep4sTJeOgnH/35fjsfA8wfoa84UyTVlTZ5LFHGY0QKDNF63jac6MsvdZFgy351thzvWYDtbD/6WdneFs6wDel4mfgzqQK8cGVGbd2O1PVk1mdTHGi5x9F2IQMTGxBPOx+X2e4X29sauAs5sZq8bFDW17KILQRbxNuur9ZGBQzS6owxbiD6ubaW38PZ5cmZ3b2saxmfdne249fkL08/1Tl1aX9+oRFT7abTVRp0+Y75TnE6XOJAeDD8JhhIPdxaByBKmfP+gn55viJc6BQdwlREgE42KpRREzZh93OhZHVHLDe3Q+ZnEl1G0HpL02CF8lmvxy3mjH0QvVYcUl06pLheakK2PMo2zkWnwhHIdtCCpck4VNd3CFEuh3s/7J8FC8BJeRbnu84vNh+JxlplQfe7E+p6og/EAZQLlWhGelIIj4du152Lr2o+9XYz31Au+J3iJx8/dPof1IuNqmxGg1PAn8ul9cOMksA5I2V0uDslrvREHgpLphod7PF1JF1phkWk1Kqt8vwk6SZ4kcrKvPMb7L9FwhZK4Yn+YvGfmR1CrnS1X29imBYJRBsgBztEseaGcwPxq2jvPLSDUcBKz8GmD/CLXZWFWt8EpsQ2nzkwUHRuqR3Xf9iLI5Fm0eUypB5kPHJwGEf/LUQGsWyBawDk20Fjv4IeZxWhAQmvM0nAp6Bu8rn4vSjtNobo7hcStEVuDST+OI1T1SfUYhvitjk/D8VGRzhJeRJt7/BzKE18Ds3LFPUr8kRqaHTkGgPSC19P3OLYtT3RHXkqCMsHm8z5yJtjpOQ
 YXWL47zR
 18O/Cn6imxYA0FaMmKyH1cZJ2UyMtgoHm56ssmBjqANxAeuV7KA4BUEDylqq3sERlJOc6AZO7ouaeIaD0q4NWn/P3t9uR7+fgApAWh6iy0JzIMmI7yANTfYc1UwT00rgKIU/HCZpUBebhWbEs61xp/w6kZx7e+qseRhf1zn8ydMFE4fnDOQcfVFm9pA30Wx+8a/cJVY2KPQQtYtYlvDVlyPYERQV35uTpe6DyI8yN9VopIIbBDimrb5Pf+rIYRY/ZcsyZuC/fHcmap5ZaldhNXNZrWv1CzJ4g41LwCb9avrz4NXwQPno3lbWrUk3A4Is8mADuX8aU9YbkS6lX+EIM4fN6xt7yvpJuIssVRXwFF/pEPuTMgJgf7O/YL0xmunFGp+MYt0lUrZdzSOjz5GP/sUbOy5XT+V8vhM4Rmf1k2x8tTnsaDqsxedeQnjDoujPGaUBBuBp4UQh9EC9NnqFmlmuYuQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Motivation: improve observability in production by providing subsystemsawith 
a logger that keeps up with their verbouse unstructured logs and aggregating
logs at the process context level, akin to userspace TLS. 

Binary LOGging (BLOG) introduces a task-local logging context: each context
owns a single 512 KiB fragment that cycles through “ready → in use → queued for
readers → reset → ready” without re-entering the allocator. Writers copy the
raw parameters they already have; readers format them later when the log is
inspected.

BLOG borrows ideas from ftrace (captureabinary  data now, format later) but 
unlike ftrace there is no global ring. Each module registers its own logger,
manages its own buffers, and keeps the state small enough for production use.

To host the per-module pointers we extend `struct task_struct` with one
additional `void *`, in line with other task extensions already in the kernel.
Each module keeps independent batches: `alloc_batch` for contexts with
refcount 0 and `log_batch` for contexts that have been filled and are waiting
for readers. The batching layer and buffer management were migrated from the
existing Ceph SAN logging code, so the behaviour is battle-tested; we simply
made the buffer inline so every composite stays within a single 512 KiB
allocation.

The patch series lands the BLOG library first, then wires the task lifecycle,
and finally switches Ceph’s `bout*` logging macros to BLOG so we exercise the
new path.

Patch summary:
  1. sched, fork: wire BLOG contexts into task lifecycle
     - Adds `struct blog_tls_ctx *blog_contexts[BLOG_MAX_MODULES]` to
       `struct task_struct`.
     - Fork/exit paths initialise and recycle contexts automatically.

  2. lib: introduce BLOG (Binary LOGging) subsystem
     - Adds `lib/blog/` sources and headers under `include/linux/blog/`.
     - Each composite (`struct blog_tls_pagefrag`) consists of the TLS
       metadata, the pagefrag state, and an inline buffer sized at
       `BLOG_PAGEFRAG_SIZE - sizeof(struct blog_tls_pagefrag)`.

  3. ceph: add BLOG scaffolding
     - Introduces `include/linux/ceph/ceph_blog.h` and `fs/ceph/blog_client.c`.
     - Ceph registers a logger and maintains a client-ID map for the reader
       callback.

  4. ceph: add BLOG debugfs support
     - Adds `fs/ceph/blog_debugfs.c` so filled contexts can be drained.

  5. ceph: activate BLOG logging
     - Switches `bout*` macros to BLOG, making Ceph the first consumer.

With these patches, Ceph now writes its verbose logging to task-local buffers
managed by BLOG, and the infrastructure is ready for other subsystems that need
allocation-free, module-owned logging.

Alex Markuze (5):
  sched, fork: Wire BLOG contexts into task lifecycle
  lib: Introduce BLOG (Binary LOGging) subsystem
  ceph: Add BLOG scaffolding
  ceph: Add BLOG debugfs support
  ceph: Activate BLOG logging

 fs/ceph/Makefile                   |   2 +
 fs/ceph/addr.c                     | 130 ++---
 fs/ceph/blog_client.c              | 244 +++++++++
 fs/ceph/blog_debugfs.c             | 361 +++++++++++++
 fs/ceph/caps.c                     | 242 ++++-----
 fs/ceph/crypto.c                   |  18 +-
 fs/ceph/debugfs.c                  |  33 +-
 fs/ceph/dir.c                      |  88 ++--
 fs/ceph/export.c                   |  20 +-
 fs/ceph/file.c                     | 130 ++---
 fs/ceph/inode.c                    | 182 +++----
 fs/ceph/ioctl.c                    |   6 +-
 fs/ceph/locks.c                    |  22 +-
 fs/ceph/mds_client.c               | 278 +++++-----
 fs/ceph/mdsmap.c                   |   8 +-
 fs/ceph/quota.c                    |   2 +-
 fs/ceph/snap.c                     |  66 +--
 fs/ceph/super.c                    |  82 +--
 fs/ceph/xattr.c                    |  42 +-
 include/linux/blog/blog.h          | 515 +++++++++++++++++++
 include/linux/blog/blog_batch.h    |  54 ++
 include/linux/blog/blog_des.h      |  46 ++
 include/linux/blog/blog_module.h   | 329 ++++++++++++
 include/linux/blog/blog_pagefrag.h |  33 ++
 include/linux/blog/blog_ser.h      | 275 ++++++++++
 include/linux/ceph/ceph_blog.h     | 124 +++++
 include/linux/ceph/ceph_debug.h    |   6 +-
 include/linux/sched.h              |   7 +
 kernel/fork.c                      |  37 ++
 lib/Kconfig                        |   2 +
 lib/Makefile                       |   2 +
 lib/blog/Kconfig                   |  56 +++
 lib/blog/Makefile                  |  15 +
 lib/blog/blog_batch.c              | 311 ++++++++++++
 lib/blog/blog_core.c               | 772 ++++++++++++++++++++++++++++
 lib/blog/blog_des.c                | 385 ++++++++++++++
 lib/blog/blog_module.c             | 781 +++++++++++++++++++++++++++++
 lib/blog/blog_pagefrag.c           | 124 +++++
 38 files changed, 5163 insertions(+), 667 deletions(-)
 create mode 100644 fs/ceph/blog_client.c
 create mode 100644 fs/ceph/blog_debugfs.c
 create mode 100644 include/linux/blog/blog.h
 create mode 100644 include/linux/blog/blog_batch.h
 create mode 100644 include/linux/blog/blog_des.h
 create mode 100644 include/linux/blog/blog_module.h
 create mode 100644 include/linux/blog/blog_pagefrag.h
 create mode 100644 include/linux/blog/blog_ser.h
 create mode 100644 include/linux/ceph/ceph_blog.h
 create mode 100644 lib/blog/Kconfig
 create mode 100644 lib/blog/Makefile
 create mode 100644 lib/blog/blog_batch.c
 create mode 100644 lib/blog/blog_core.c
 create mode 100644 lib/blog/blog_des.c
 create mode 100644 lib/blog/blog_module.c
 create mode 100644 lib/blog/blog_pagefrag.c

-- 
2.34.1


