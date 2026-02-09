Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C97A9E7E0D0
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 19:06:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3803F6B0093; Mon,  9 Feb 2026 14:06:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 333C86B0099; Mon,  9 Feb 2026 14:06:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 261356B009B; Mon,  9 Feb 2026 14:06:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 13FE86B0093
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:06:18 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4A00F1C14D
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:06:17 +0000 (UTC)
X-FDA: 84425848794.25.A45A440
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9CAF2100008
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:06:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=C0qILITZ;
	spf=pass (imf05.hostedemail.com: domain of 3JjCKaQYKCAMdydjlqjrrjoh.frpolqx0-ppnydfn.ruj@flex--avagin.bounces.google.com designates 209.85.161.74 as permitted sender) smtp.mailfrom=3JjCKaQYKCAMdydjlqjrrjoh.frpolqx0-ppnydfn.ruj@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770663975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=e2HpgCh3GJlzMEOowH+0CKxCLu/yx8DsmALRhJjlfYc=;
	b=cWbb/wYREWMhNMBjgVKjoOyxfIMdUiNmEpTM5kuJ2PgxeO/MkoxijO1AC/Vjrk6bHSmEdv
	JetJUUS7Y6Cx+gB6oyDXIo20z5ZoJYQjZIdKzEbieMl+CJlzuCeoePXRwwDbfpivp7Jff/
	UObm5mrlxiHNBWSOct5MNA8eYCT2RRY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=C0qILITZ;
	spf=pass (imf05.hostedemail.com: domain of 3JjCKaQYKCAMdydjlqjrrjoh.frpolqx0-ppnydfn.ruj@flex--avagin.bounces.google.com designates 209.85.161.74 as permitted sender) smtp.mailfrom=3JjCKaQYKCAMdydjlqjrrjoh.frpolqx0-ppnydfn.ruj@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770663975; a=rsa-sha256;
	cv=none;
	b=ijDZKk0/jREhL5P4E/1gXG3rWIiQtQP23khrWUnjr3VBz8HDNmxSR6xy7Xwd9e7AHMHnc8
	EwvClyW/uLKC8fvNBloGL28b/27j8XGnCVNAvbpnZfYFsDCxwb5CFauxF4z9TgzxgTzRd+
	G3FnC0gfRQ/HAPkNUlnvXEzAeAeUFEo=
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-66317aad908so11386570eaf.3
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 11:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770663974; x=1771268774; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=e2HpgCh3GJlzMEOowH+0CKxCLu/yx8DsmALRhJjlfYc=;
        b=C0qILITZqk6AQQZiWLfNEYhqbeicq67Ytn9wrxsR3p9LYP9VlvSpyACO+7L2kfOMRq
         BPx4nRgpfiboHtpIqD+PtFBF/XmZUi2GvWpsjqkuDhSkZ/SAqa71pnU6xRtU4TzEKEqb
         23OFn2hggWhNifvsaJzMTefJ6/8miwbe2UwveZOGuDer33RqOHQqFLlC2OZAo9fkZ64n
         l98J35gp4+uYQrzgaJW7v2mTgXIelnuq9tp/NCpeCNE9M9/jO1HuS1WFMya42ot8YLfv
         SLD7GQJmqImMCqcsq6pAO+ZxazIacbU+m/e9vVgDtWZuuPJE1hdhEFJsojnLuw5eE54O
         z7Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770663974; x=1771268774;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e2HpgCh3GJlzMEOowH+0CKxCLu/yx8DsmALRhJjlfYc=;
        b=LZM8bRG6SH5HVfGlkPFiVqtlk2WlI7Zb4td6FFb9LuoHnzgC0MtKapqNLNwf4ozJ6R
         yhcUNGQyULMbGKHlkBNg8/DDAQDsK9ne0ZxoGjUsABpDc0Ya2c3mWz2aAm26KVnhHZgh
         ByrwERFBLZmP0Ht/jvAhsRX0FFjG/wAuYvndGpvm2UfM1yrVcIWdS+oV+pDUH5jai+ZT
         T4nTukh4PJWrFKQf7mkvy5yK3YXOrtILbGCyRADvPhVBa73ROmYT2mzKMb6JnV0wIP1E
         Rh+u9OUKOXhEheqvIc/+D1OfZx04c00taTZDQkbPqHXAhzPt3Dg4Wm0XQ4ubwbZLZKP+
         CDMA==
X-Forwarded-Encrypted: i=1; AJvYcCUy4dDd7DeA1y5GGZpHF+B9IMXtxWqzZq84L6uvfBi1ZemngsoFTePRz3QFnl9yyY8FIX+1DXtkcQ==@kvack.org
X-Gm-Message-State: AOJu0Yycvjnb0qZYM6c+clDxnV+mH1NU8+lKbJsrI072yKHWT3j7XV4K
	rOauFweZBXs9aGOLTeJWKYvkGbivwlavT3k9OnmpzKL4TM5YIlukoOwDwrqrf9PRqo8ZrTfvj84
	E89DqrQ==
X-Received: from japv18.prod.google.com ([2002:a02:cbb2:0:b0:5ce:5b3c:f8c3])
 (user=avagin job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:6ae6:b0:663:8c6:97a1
 with SMTP id 006d021491bc7-66d0c85409bmr5061261eaf.61.1770663974501; Mon, 09
 Feb 2026 11:06:14 -0800 (PST)
Date: Mon,  9 Feb 2026 19:06:01 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.239.g8d8fc8a987-goog
Message-ID: <20260209190605.1564597-1-avagin@google.com>
Subject: [PATCH 0/4 v3] exec: inherit HWCAPs from the parent process
From: Andrei Vagin <avagin@google.com>
To: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
	Alexander Mikhalitsyn <alexander@mihalicyn.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Chen Ridong <chenridong@huawei.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Eric Biederman <ebiederm@xmission.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Koutny <mkoutny@suse.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9CAF2100008
X-Stat-Signature: zx17tzkbxm8w83b19egehetyw1y56pij
X-Rspam-User: 
X-HE-Tag: 1770663975-289897
X-HE-Meta: U2FsdGVkX1/Z8zCH2d0n4TLG4VWpJGjYTK6dtWEM5sa8BZhRTxOrxfvWTHzi8ugJEF9wvqFG/43FFmo/X2EOVvNOrTDU9nBsBuMI3A5mH4BvKoxI9ktRP5xi7wU6UJCe48ykXLf/vElI8y712UXxh3frIIvs62k/A29SiKjJv8zLqnwQ2ZUdTlSvZp8IY28dikWUcOxuBgXd5NoL0xgNESIczhce/JOFrE2hAZlBIj8N/RCed33H0M8wcSVLvQI6+nvQYIdbJJrlqWuUE/aruthMrmB9BGJtsGWl597gOSAhMr6OxzwWGBM3UIcOEYPclGujKjigxPp8Duq78UVRCRAJHk4RxiNp9l1NaCS9AH8yeFXF0MnOwGdj04CKQSJTzYgdKiaHt6CpBd20nUWbTiBHkpMc0CJo3TZqRNJ1jDLbau1/XQ9wtTxLAVtUKdXy5AR2Ivg2Lf06MzVVG3AQwgm+HY40ptZFMob54iEwEWbAukvSDVbXM911aaq9jrbdt0A6hK8ONl0Htlr4rvC+EyXQ/vQWp5g1X3m057rlslU7ALZTJPV59975GER2msVWybeBml2nm8ch3xkyzXp5y3/9937fdtOUykFNdCdNl+eQuRvQBCw9wfqFo591sF6hnkJU4YUNP3yWmsGOEPsz81AxzXHAuG7py7mVoPyZutN/sNpEelVZtkeiCiGWHv+HCggUhDWMwE5idQF2H8A4XLXyR24ZNyzWOOpPhyA/ZMd0ZBsvFrmabG4Suwfeje+07S5zOdQsiEt3ssgCI3MYbLQBFg2SK92AImtE9Plizt8UCoQxjYkKkSldJfxfUKn7L/n0ix2ArLS+LfLqKw8GkNvZro+4Imm3lc2++VO5CKKWhehys/9UvgEYLKf7iE1i3IFEhOS3ped/J+rBGyx3/IJm6jHQSpWBcZpxpoTNEU0+cMxUuYAt2QrU4/7USNe/NotPVvRZjWrXz8I+Osh
 D9LspPnu
 ikAqwNv09momNb2hcTqsF0nAe5/uHVsLthuZba9/MfM/xlFtiUE1KGQqf0AvgswfkZwuW7A6R554egebUAhfnnYO2+2NuOcFyRg0fobhk7B991fo9Kuea8aELhx7rFwqd/44ra/eTFolNbFlKWzZMtm6mBYXiyK17Y5WYFqa70yczpBpqArFl+E+bynxvdfmlHPhGjcSI/1j25ei918QOgIVQYV20B1QBnr0G259XNDxXsIVDbcxhPWJQjl1d4TrB7Y/EaHjEiUC/xdnd4cUkkt0lnT8RoBKMZxIN2s3J+T9royW5LLO8bne44hT1EKvGsb5xJpsLKW2CCly0Wm4lk99Ta4H9N7oT4o4Q84Zd2r27SW0OVZJqYNV99Mf9VwAM1uFrw/S7uVIVH01EjPu9ZUhUZ9X2VQF+3mM+O2Mjc171nnIQAM0GYNHdol4FpvcIQkOTXK+pq8XKU5oWLef5rGByYuvgXm44I8386WNH+bKS1crkaqio5pwlqr9cjDASOngJm3em56264oZg/zRCuCK62B1itUp1Qu7dUYEh9x2fUEr58RCYGxhUG1JDc6LTwOH0RFJ5esgv95WY+UZoeXJQUff11F9CY+aZBmCO0D1SEo/ghlm6TUk+MyZ6IlZNWb1iG+1xrFMHEJAQTLIxXl0iPhNnrUTNlU85XR0enIseK2nEyZvWYoWaqQcpRyLTVUOXbZXviVhcO+yZJvp6W/zjx8koE4XTgy472H3MjoMDyIHnYuY3IKbvPyVHLlPZiLjpFqmbkoPex5c80MdEHDkBj2zL6IS1TBmAaUq2xCW6n2XBROkKatB6tEvniYTEKdm9qI/zNPk5nd+DUmHbnbWsO3LhVYARS7ukL+TOp1RR8oc4C8j7kFtzoRjwTLYL7ZfwuDRoEwT6exCNPQuJDI6sPtHx/xkqPC+HBfyoBRuH6Na6JlabG7qjL4/S4gjIPTf4ztJb+ngpEpq75/m+itLtuA==
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

v3: synchronize saved_auxv access with arg_lock

v1: https://lkml.org/lkml/2025/12/5/65
v2: https://lkml.org/lkml/2026/1/8/219

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


