Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 709F6E9A02B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 18:01:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ADA06B0088; Tue, 17 Feb 2026 13:01:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95AD56B0089; Tue, 17 Feb 2026 13:01:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 866B16B008A; Tue, 17 Feb 2026 13:01:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 71D616B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:01:15 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 02FB38B0C7
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:01:14 +0000 (UTC)
X-FDA: 84454715310.22.6FFE7BD
Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	by imf17.hostedemail.com (Postfix) with ESMTP id AA4974001D
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:01:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yQSaLYEC;
	spf=pass (imf17.hostedemail.com: domain of 356yUaQYKCOYIdIOQVOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--avagin.bounces.google.com designates 209.85.161.73 as permitted sender) smtp.mailfrom=356yUaQYKCOYIdIOQVOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771351272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gd7itJdvcuV3R3SwarzHanDdlNFzzeUJJAZS/H40Dc8=;
	b=NW1joF1Po1xfT93Zc4/0FYBzpfRBVNMJf5FaUjO1BkFvQSDIL5+kQBnVbhguUig4/x1Gya
	1PpBBvAmk61GcupXMhHCr1U4eh9Op6057HmERU7JbsbLXd4mfoAVpIMvvHz2y0nIjDbZQX
	8Si9e+2Gr8etH49EVOHR407D0YkWhvQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yQSaLYEC;
	spf=pass (imf17.hostedemail.com: domain of 356yUaQYKCOYIdIOQVOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--avagin.bounces.google.com designates 209.85.161.73 as permitted sender) smtp.mailfrom=356yUaQYKCOYIdIOQVOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771351272; a=rsa-sha256;
	cv=none;
	b=nVSndRDOcAtQw8Xcpfe/GYJ/ED2bDdpbEWpbwXuFIqlf1ql6na2775SMIRJ3hZRE4rNqPo
	pLpPS/BmSdTwJmR9xHWnxi+JALeeN1EEevMSvJGZnXkWvMrt/0+0DZClClzOyJTWuyUOp9
	RlP/etBswf24sqABu0A0OG8pjh5D3z8=
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-678e130a87fso38908407eaf.3
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771351271; x=1771956071; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gd7itJdvcuV3R3SwarzHanDdlNFzzeUJJAZS/H40Dc8=;
        b=yQSaLYECBkioeKux6k/dLEk1FwhvWIvqNVLLE4J6HhfykD9xET9pe36A15SCxxraXt
         j7GlxKsZRkEfCZCH26uIKiW8n9GBaB8GMHt/x95cgNLAHgU1Hr9S0W+gd5wJ4xrxMRIm
         Pc7ZS5l2VBWSHwZCD/JTVT7FPM4oGK6p1k5xI4SPoXJnK8Kw3VHUQ2fXxRZOTCcAH1dJ
         2kInIeaIap2r+c/oVCeCc783A0riLCqi3uS24ZHXESSwYUMBdTmzE0bItxIYZOQ1Kzon
         MIf9xqAv9cMxq7fjdwa+nh01eDIXOzsAn5l/hYKaUxqHfihg8Xwu/EsGMOZ2YKqyUj10
         Drrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771351271; x=1771956071;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gd7itJdvcuV3R3SwarzHanDdlNFzzeUJJAZS/H40Dc8=;
        b=Fg70LcAkpaoJUzLn7A9cpq4SRiz1CG9UqpiHnsV9u7gCGmAtnC+PnMTIIzTTCg61pq
         CSM58I1LP44/4ZppUCpG0/r0GmcLOukHNOv7WSiYqYfhRn4EYWjji25/fFvbLqZ1+PAG
         jm0Rq070vVHtFacoe/R5Xa2gI+w7oD7ewvT3HnCSyS8nmP9EpdZL43LNUIQUISVmaxTG
         E+7VQr8+uho47WumsAgH/kti4bapGSa/baFIqqW1aGYzgAlqe1EJM89Z/OPL0+l8xOge
         1axv1FjPHlyrK1YdBA/kXXxQfGWT1+pMWjEhCDVVS3obNLJcPOn/FhPakHSVqnkDsejl
         UdZQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6A9CI3X8vIWbf5zjemzpg4rH51XuQU5MCZsLMS+R8mhYOAfqNChlGPHmNXYhHWccV2l5Z56o96g==@kvack.org
X-Gm-Message-State: AOJu0YzuCyzaD7ft35dYsR1XNoAufgiIj0orRha3RW8o5CrGcILVzXs/
	QUurw8TPugWOndJdSHq8lSY//B0k/Q8Ol4bbTwwYRm9LBetSyNmZ6IYbLFDeQzvPfXsp1Wvk8iR
	nK2HwNg==
X-Received: from jabki4.prod.google.com ([2002:a05:6638:a804:b0:5ca:ff1f:79f])
 (user=avagin job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:4b01:b0:679:a4bc:9f8f
 with SMTP id 006d021491bc7-679a4bca251mr287501eaf.61.1771351271099; Tue, 17
 Feb 2026 10:01:11 -0800 (PST)
Date: Tue, 17 Feb 2026 18:01:04 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.310.g728cabbaf7-goog
Message-ID: <20260217180108.1420024-1-avagin@google.com>
Subject: [PATCH 0/4 v4] exec: inherit HWCAPs from the parent process
From: Andrei Vagin <avagin@google.com>
To: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
	Alexander Mikhalitsyn <alexander@mihalicyn.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Chen Ridong <chenridong@huawei.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Eric Biederman <ebiederm@xmission.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Koutny <mkoutny@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 9injmycnsng9io5ukf1gmb4saqrpgf4t
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: AA4974001D
X-HE-Tag: 1771351272-671572
X-HE-Meta: U2FsdGVkX18mSSd6ajtEONYKTCq9gzEX9whgwPknG/jT73pHGE9EJWGNc8VKBIoNy0Ws5AkN5Kh+Xlqgzxcj9Ghj3QmiQ+NQp8PBVEVBGsDIV7sLjTxqHPDw8fDnBv55y1aOynOy3zHBRVjLi0KkxUsFQhqMOzJ2h4Qzrd+lictdZ12vrAcrSZ/sQdwb2tS5ku3VVhAKnQpqVEi2OToqvvWVvCYFSs5sdfPo5EN11fODBVsJqsoewZ3VkVKvcy9Ro+klmmIi582ViLOPK/rJ56ym+LUgN+COSApf+AV9m4JFVawGpGmDnl5hUKvT4UHMxukG6byrjrd2ZdtMNOgxnIDFsjsi0WunoH0fqDXh0ubNuNPkhG2dU2WHSas+h9QBJwupwXSJDvk5A81z2yJZztT9bZQBA55A5Y6yfOxCSj4si53adKL96N9z2DDUzFxDG/P9JotQDvBxRlZFCYKwhHay0sp0w5LRADiLQ5eoBlks0L55zxu+W7y+CfdOPh552ozIXCdlP0q5P+s4wDTGiGY7oLi8nVSMXvGDsNh/2h40KXTLE3PHztd6veCWCN6A53nsAeYnuvsz3HVXjq0L6Wn0Npx+LGFXTNauawLFmlzKuHSCRAR29dMtZ2dWm5nnm5vkm5PjbfC9NDYRKToTqW1oJOE7rHS31Rab4ZjhB/sDMkFJT4KSUSngzqh8giIv7NDeXo0ue7THZy2TTfucSX14BpTG+Qxt/0IT/V5cme4Owx7N5HwEiFKXfvOLYruGbI5ru45jLOgnMj9dhZfLzx8sYoOwBc4/lEj6hyfrHNdgwwec02sJCUC9GvAbdW2pT55jYVFhoGlgzvGsmiyOXCKDVqG+qrlGR/yHlIplLYBTNTEw+s5BAf5lra4IOwHfAlfKHJgoz3gwHmHQnk7d/ePRDSnRP2xcYXymg5XU82TMbKWpHN0zBp0/aqXvAi+bJHqRLLkCZ1MFhnR7KIx
 ntvC3r9n
 Gzsqd5TVn4ai3cxxzpHwwOAVooOJR7I93mgBghzYrGN7hcZhKtB5+vtkcaZq+VplCJHCI68GyK4eyUvY+jE1Fy8hC9kdcVVKQOrJK8olRq+EQWNzckox1mnskBRc0HUGlawHgqwiFMG+r2lqsLGvoT8sExZjE8g+WdaYX3kd6mw0d098aj46JLnVwG/zLDy4t06cQPcvfamOWBa6OWZyhtJCM31UKPc85BvpaWhUgnzBB4tNI3kZMjlOfNos75L8fGzYKoL+RAPBc4BzcIwxaun2QcEsegJviuDSHrID62cq70TOuMH0OYrVMLYkpbcnQy9WrICi0Tj8VwSWpCnNLyJLMxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

v4: minor fixes based on feedback from the previous version.
v3: synchronize saved_auxv access with arg_lock

v1: https://lkml.org/lkml/2025/12/5/65
v2: https://lkml.org/lkml/2026/1/8/219
v3: https://lkml.org/lkml/2026/2/9/1233

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chen Ridong <chenridong@huawei.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Koutny <mkoutny@suse.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>

Andrei Vagin (3):
  binfmt_elf_fdpic: fix AUXV size calculation for ELF_HWCAP3 and ELF_HWCAP4
  exec: inherit HWCAPs from the parent process
  mm: synchronize saved_auxv access with arg_lock
  selftests/exec: add test for HWCAP inheritance

 fs/binfmt_elf.c                              |   8 +-
 fs/binfmt_elf_fdpic.c                        |  14 ++-
 fs/exec.c                                    |  64 ++++++++++++
 fs/proc/base.c                               |  12 ++-
 include/linux/auxvec.h                       |   2 +-
 include/linux/binfmts.h                      |  11 ++
 include/linux/mm_types.h                     |   2 +
 kernel/fork.c                                |   8 ++
 kernel/sys.c                                 |  30 +++---
 tools/testing/selftests/exec/.gitignore      |   1 +
 tools/testing/selftests/exec/Makefile        |   1 +
 tools/testing/selftests/exec/hwcap_inherit.c | 104 +++++++++++++++++++
 12 files changed, 231 insertions(+), 26 deletions(-)
 create mode 100644 tools/testing/selftests/exec/hwcap_inherit.c

-- 
2.52.0.351.gbe84eed79e-goog


