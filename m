Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 933A3F483DE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 17:54:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BA356B0092; Mon, 23 Mar 2026 13:54:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0921F6B0093; Mon, 23 Mar 2026 13:54:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F111B6B0095; Mon, 23 Mar 2026 13:54:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E0EF16B0092
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:54:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B267C1B7D04
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:54:04 +0000 (UTC)
X-FDA: 84578076408.09.488A793
Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0CE931C0003
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:54:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rcqK8f+O;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3OX7BaQYKCJAuFu02708805y.w86527EH-664Fuw4.8B0@flex--avagin.bounces.google.com designates 209.85.167.202 as permitted sender) smtp.mailfrom=3OX7BaQYKCJAuFu02708805y.w86527EH-664Fuw4.8B0@flex--avagin.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774288443; a=rsa-sha256;
	cv=none;
	b=TBA0ohFadUhHUfByRS+P24qTnbw4GviGUraAVcdduDh1ZqOUwftci2eJ1HGlNd0uygc6OY
	k95nE7ROFl8GexHaqvLPSxdSNhJbuTYOmhenOwex6Dv5+3XHnVSY0NU82jmogbGqK9OZcd
	tKWeq4m5LAGMIkfgyosIuR/pN+ZXfoA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rcqK8f+O;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3OX7BaQYKCJAuFu02708805y.w86527EH-664Fuw4.8B0@flex--avagin.bounces.google.com designates 209.85.167.202 as permitted sender) smtp.mailfrom=3OX7BaQYKCJAuFu02708805y.w86527EH-664Fuw4.8B0@flex--avagin.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774288443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=A9CUPvPqmkALquwn3kP/A/dGd5HZtJJQeBn1Jn3L+v0=;
	b=r86U3mIKYvoka0RXjGMQ5pnkFmUNB7lJX2h5kco2Z+xh/6MlOYJfV6OfkmOuHrDDrYWTnM
	A0VD94SA3hvgxPPjobkad9b5DJt8wOl8jgNuSuiEwHQ/794+sn6NWpPeGSfApR/PCBcs+F
	sdP6en3yR/4rubwX8ANQJscKm5HxDsM=
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-463a018f61bso13833718b6e.3
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774288442; x=1774893242; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=A9CUPvPqmkALquwn3kP/A/dGd5HZtJJQeBn1Jn3L+v0=;
        b=rcqK8f+OlAZQP9LqjWJXg/23cxla0CeNj8xlUSxX2Im0mkfZVWQezVXcXLzAAU4r5A
         X960fk+0NOfhTka8q/Ip5AOuG2+RbYu4GpAmMtrWlp/e0qqwr+NMJuQsYU1MHHUxJuMn
         v3pAMO/CNfM61mbyrnIfUemTfseqL1DNaYkLcoFrnm8ryUk/NGzv9JFlm6LGDOzVCeMW
         g4yU+I0AUXRjP00C+sbsg2E7RB/DBhqQXn9aNl9AbjfVcjDMT54YO1OoYX8ebq8tHs1Q
         bhFU5ti4RyQKE+OMMPzp+akG/Sb8u0kB0/nZNAjFX/Cteq6j3lFbsdWUHZya+xcy+Pug
         EyuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774288442; x=1774893242;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A9CUPvPqmkALquwn3kP/A/dGd5HZtJJQeBn1Jn3L+v0=;
        b=rEnYDz5us37525UWllhyiu2EeKmIETi1FQmc4VarFyfTf0OQxz6jKYjo6Mtje770xD
         WE10nLXm1+5GXKYqVe7XPPIRX7m4XTEFp83eJwuTImkjZsq7kXRkUme6ZecOqmgkJeAl
         PzKipEG5pFn++oMNUTtgeR2mizqAywn9e3cuOII7eOeqbMyx9Sbc+MqOfN4dL2lexsJO
         ngQSGYo3RRpHvbdGXX3bHGmZL98+1Di5UIREGlWJZyR6ZxW6oGcXcGLpi+Y/DM54EQ5c
         RSx0ra+1HTuHMbsPl9xhwOVHSxVoTO+GGkcdUSxRbbFmrAOW2OsEa0Gc/V5p1hBQBk4s
         9i9w==
X-Forwarded-Encrypted: i=1; AJvYcCVU03zkZUI3G4nmCMHV1zdFQrW/J1l4RP7Dw7hEbNyOsCaE12/8WOWRJkddRiTtCChu2w5yoE+vng==@kvack.org
X-Gm-Message-State: AOJu0YyYBW/3N8z5kzKXoABEwboODV/jtRzAfklP0RKsotoIINA2MXYN
	7qL71GSqmYpO8YjotlNewubUXp44vFOTluBM6CO04v0RniVaBIpcPrCS8SxJyWI4U7r6QJrMH32
	OK81ngw==
X-Received: from jabjy12.prod.google.com ([2002:a05:6638:a30c:b0:5d4:6f13:358c])
 (user=avagin job=prod-delivery.src-stubby-dispatcher) by 2002:a4a:e904:0:b0:67b:d1cc:db3b
 with SMTP id 006d021491bc7-67c22bb5ed4mr10163213eaf.15.1774288441712; Mon, 23
 Mar 2026 10:54:01 -0700 (PDT)
Date: Mon, 23 Mar 2026 17:53:36 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323175340.3361311-1-avagin@google.com>
Subject: [PATCH 0/4 v5] exec: inherit HWCAPs from the parent process
From: Andrei Vagin <avagin@google.com>
To: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Cyrill Gorcunov <gorcunov@gmail.com>, 
	Mike Rapoport <rppt@kernel.org>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, Chen Ridong <chenridong@huawei.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Eric Biederman <ebiederm@xmission.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Michal Koutny <mkoutny@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 0CE931C0003
X-Stat-Signature: hanm4mf1ytgmhhct3ek857oj4w3ew85s
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774288442-438925
X-HE-Meta: U2FsdGVkX19Da7nOkSa4QRvJkBorxN5f3IpMeoCyq6XJ5S1HoI8p/vIm9BcaHfWk3emL6LbPlnpUP/8p35LCUNDNOooBI0qs3/Q/Km3t4JWt7DRjI2CUaF0xhWqvWjRkpK8ZbRaOzHN/LZITj2qnfWYNHYTX4THongYXfID6X7w4E2zkIuKCZ4XoRRVHVS8DRxsSDCutKcLQ6GHPI7SsP74XI4ii3t0hWLLsEyMz6wv1JwEQzGzJkSXWyrVBKB0ZFHo+EjcIfas63AJRKs/ZPkt4Qah3P9qW3eaVd0MWOK3aKB2Eu+z8Pe1NKcrOxVoCaC6q3M+7mVfU/DWyTkoCLBaUrXJQihslL7rzbn2s9u7qa2MZh+vViEErRL0iJHc9qhGdDWf56GsloQTS0QgdY6b7goY7ptlROe4RL3uVGEzCb5dEIh18N7L5DvLR39wK8+vn25rMM6TZO16ikNy772r9Ye5z2YRAN5kpKJ/+VaDOWqAQSWevg1kZb6TsYlISs60kSa5PJXWCAgEzIlMFh3hR8Zo0fLhBrBbKOfMcF4S1etVCpHw5SYw5zIInMtxOzAwey4yNB9hWNKHUv7zF9Rmsp2BkbbRbN+mMEIcOlhB96/DRlZuWmyjcfd1M/qUeCfwYgUWKqa0Om/KZUCJLCfjWYLctFrJX05hwGfxFIjVbCb+KLjddxeX9wU6i1QP+rCgrseoeEsmgJjxVAodeZieZV8mY4Opkss8HztlMe49jlUzUtRDXzoyLbQ7Uog6jbfNCyMGIMrT3ZT6LGyYXTHADlzpgWBgsH1C9bIs7A21Q64GVg57Tf4NYwklJ0cUn86Z/mE/0o6vQ9aMlDD7jnvB+vAVMB4lX/GdvgrsaxAH49d3I8W44WJ+W02R5JmV46HuLXA+kHpzT5HuDNOlSCV1rz7rUsFefmEQ3Q0cmQVMEXxebq3s5i+HlIOmT0jhrl+crAYtQRfCc2golCnx
 OfICM26W
 pN9BZBi18n6UM0Kan19AJ2losQ+ipcDle7B82lF2/8ycZm1kyOBSQNXJfhXaGGClEs4YcAubmFffauGqffBRVizTXHr6nxmv9g/HZxG+sJdjm0te9Ha4CP8WQPB2w75ClYUs4MoBUY9nf1MMme3BNkLmjXAz29ZJJae3aIHpcrDs4s72FX3UaLWLpOu2boLrhlxhbCN5IZLj5k5DhN3RqqM2ep82ljNEKBVDvC9kcj0+FiggwIL0lfQjcO0lZ1pAeGVyvtluBjXge4DIEF3espj6IWTVixBKQ0poH2patbz0jYLTGx53XQkYrhSslPIZg0OVq9YF0qDTBCw23iF2SxCNzgM9LvZXheYHHAc7EBIsV33ixB7ojQZ4XgeTbmywv4PwTIRVa8255snuuGrcmIiqjxUD2QuQR4Jd7sW19KkoYRkUgVHU+HshydmOiumudxWrOuWqp0OYMIgA+EGJJ2vZKTnTwNK9QhowvrzLvtFAEz+C7JXQAw7UxORXuVEHv97J0M/WZXIG7iCEk9bT+TeKHev4uxJeKUq6qcQLzuJr8OnzxNnp/PQFCsO+E32P9ZPv6ogoyO79+HYtUT+7/FxbfGVoK2lci/N+ijyl2EypaeUnnJBkyUewtqdRVCmu33xZebFN6jAEP+yB56/4UdsnIp8S3fyf+fmeU0P0tJ/zuedwY7usfM+FtrePMEjJCii1KSWP7Aa/7/pHozAwuZREYQgwNZ+vLnK+c095NOV2DYXXhyOqPIN6jftMMb5r0w8XodXJWUTi1cwmW86nIG/m/w6JKsgPa9fDJ09Vghi64gLRhjel41SrlMgm7+9uTvR45iySdQwN4uVyfi/S7824XFt8jLRDsywrHaoc/3L7SNpAbcS6FsH2Onp2ZKbJMnV255Oh+nnUgGhnjEi0NgpcKGc19GJkdrUezXMXZRwjVYQZI5L871x1gzu9IFGdHNm8PK/Z8zAyZiOwDP7QgM6lG6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series introduces a mechanism to inherit hardware capabilities
(AT_HWCAP, AT_HWCAP2, etc.) from a parent process when they have been
modified via prctl.

To support C/R operations (snapshots, live migration) in heterogeneous
clusters, we must ensure that processes utilize CPU features available
on all potential target nodes. To solve this, we need to advertise a
common feature set across the cluster.

Initially, a cgroup-based approach was considered, but it was decided
that inheriting HWCAPs from a parent process that has set its own
auxiliary vector via prctl is a simpler and more flexible solution.

This implementation adds a new mm flag MMF_USER_HWCAP, which is set when the
auxiliary vector is modified via prctl(PR_SET_MM_AUXV). When execve() is
called, if the current process has MMF_USER_HWCAP set, the HWCAP values are
extracted from the current auxiliary vector and inherited by the new process.

The first patch fixes AUXV size calculation for ELF_HWCAP3 and ELF_HWCAP4
in binfmt_elf_fdpic and updates AT_VECTOR_SIZE_BASE.

The second patch implements the core inheritance logic in execve().

The third patch adds a selftest to verify that HWCAPs are correctly
inherited across execve().

v5:
 -  Fix reading of HWCAPs from auxiliary vectors of compat processes.
 -  Defer HWCAP masking until ELF table creation (create_elf_tables)
    to handle compat process correctly.
 -  arm64: Disable HWCAP inheritance on architecture switch (e.g.,
    AArch64 to AArch32) by clearing MMF_USER_HWCAP, as HWCAP bits have
    completely different meanings across these architectures.

v4: minor fixes based on feedback from the previous version.
v3: synchronize saved_auxv access with arg_lock

v1: https://lkml.org/lkml/2025/12/5/65
v2: https://lkml.org/lkml/2026/1/8/219
v3: https://lkml.org/lkml/2026/2/9/1233
v4: https://lkml.org/lkml/2026/2/17/963

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chen Ridong <chenridong@huawei.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Koutny <mkoutny@suse.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>

Andrei Vagin (4):
  exec: inherit HWCAPs from the parent process
  arm64: elf: clear MMF_USER_HWCAP on architecture switch
  mm: synchronize saved_auxv access with arg_lock
  selftests/exec: add test for HWCAP inheritance

 arch/arm64/include/asm/elf.h                 |  12 ++-
 fs/binfmt_elf.c                              |  13 ++-
 fs/binfmt_elf_fdpic.c                        |  13 ++-
 fs/exec.c                                    |  54 ++++++++++
 fs/proc/base.c                               |  12 ++-
 include/linux/binfmts.h                      |  11 ++
 include/linux/mm_types.h                     |   3 +-
 kernel/fork.c                                |   8 ++
 kernel/sys.c                                 |  30 +++---
 tools/testing/selftests/exec/.gitignore      |   1 +
 tools/testing/selftests/exec/Makefile        |   1 +
 tools/testing/selftests/exec/hwcap_inherit.c | 105 +++++++++++++++++++
 12 files changed, 234 insertions(+), 29 deletions(-)
 create mode 100644 tools/testing/selftests/exec/hwcap_inherit.c

-- 
2.53.0.959.g497ff81fa9-goog


