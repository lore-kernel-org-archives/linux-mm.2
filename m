Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6666BC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:53:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D6796B00A0; Tue,  8 Sep 2026 09:53:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AE816B00A1; Tue,  8 Sep 2026 09:53:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C47F6B00A2; Tue,  8 Sep 2026 09:53:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3CED76B00A0
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:53:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D2ED0A0290
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:53:37 +0000 (UTC)
X-FDA: 85190737674.13.FB2DF55
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2BF3A180006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:53:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T9ACCykP;
	spf=pass (imf24.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788875616;
	b=KA8e/UebQQgZmQlU/W7nAynObdknZ22JjQQ1TgRXBfyMdr2igiAvFvtES8XtRG7xPPzjd4
	uF6nK3Hp7LwwzkfEPjKRTXzQTXuy8KbxAVfn+PNuqyoPnRYodzzAG/JQQByR/8QIBLp9gm
	8MVj/NqbRsKcorJ503DxT1ervv6E3B0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T9ACCykP;
	spf=pass (imf24.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788875616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=otL9ZeSyGNhMuE2AATxuE56e68gyPCqm69FwDFFVq2Q=;
	b=0dlQoT/gdfNov2xxOKRcVwQ4bx2bauvxKUbHeeayy9HSVjwk6AlSYM/eY2W0ICbiG4PQX0
	SlZps1LbODvVq1DZT7DScNKTFJSVjn/WxwQfcpELgBIdbqm9dAUwFWFl0zwLqDPPKiIFeK
	/CyUDmBMnA5D3x/6S4HvsOEExw9ZUUI=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49557167508so55655585e9.1
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 06:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788875614; x=1789480414; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=otL9ZeSyGNhMuE2AATxuE56e68gyPCqm69FwDFFVq2Q=;
        b=T9ACCykPceDKdTfrSavW/7XaFph1Aca6Oj3+oVYlXro27JVlnCpaYJ2DDhR0F3MW3o
         MHbgNn5tmxCs1q25prsh4JxioH8K6jc7eR/lG/3mW+qsCcXZSAC7VgsjiyuOKzCIoLck
         G93ovKaX+VHx4OHuAxRy3L04Gis82ATPlTemZvAngorxoSB+fAHIaePFagy/+D+naoFG
         xpzQUGm/0GkLWoh5+0ewyB3mKSiowQbWS11AOrUyOgedBYnDSp4EN28VLgQQtsOoe/K4
         AlAqceTnPZG7hfel9bJvQie44qwaZALJ8YGTopBdFOGAqDyBXAR3hFntZL8FPunPMKh3
         2/1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788875614; x=1789480414;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=otL9ZeSyGNhMuE2AATxuE56e68gyPCqm69FwDFFVq2Q=;
        b=ZRXCjImnKENZjlnYlqDKSkau9UgMMjV2NPUZm1TSp8MY+6avJMBS4q3oj3UcAMz2Vj
         +r4TfEuJv6zX3nd0vReS+SfuA9BVLCfws0xGpN3ABzANgMXhoaYgJaowDDjI3Ckm06B3
         EGcC4bHlWZgooQQg7B/k8fMDllIwuzeU7Z/8PUHBU/9AGw9+x5hUd/fnah5wuD4O61We
         32zQrZOdB2+tbOXd53GmChYYy0L7GYTZ98rwgMZd6wXR+2YeeVBNhy0fh8MecBDXncyC
         r0o8sxZxEYgx4x6x1iyMU8ARPtyz+fBvgpuX7hGrvDCR/+k4eSKHbwzM0F3YEUMfg97s
         7SYQ==
X-Forwarded-Encrypted: i=1; AKwUvBwVK5VfEgFwoLnivszqLvgi/Ik95KNbSCG9fALbL6PF3EfsFn9l3oVAI31JAc8nmHAvo+u45cV/Pg==@kvack.org
X-Gm-Message-State: AFuF++l01Cn9t7qFQ4l2oE7rzYM0u6HyjOflZz06GORLPx7q8fJ+d8AN
	2AnMPd0YSZab3iORV+I1D+zRcEsaCFK0O4jHeIaWkVgi96trC5O9r8g2
X-Gm-Gg: AYBFou3CWjq46O1fuhX2m6tG2ZNZfkVi5SjS6swBEsOB/AWZEnmniDrxL5phK9S6heH
	9LXVuw6CfwkIrxCE9W+XeVwD8YeByvoY5BqeNJ2/XAtbqTB2klhlqyPY17y3zunzqJV/lyTPmyZ
	+HiDv+Bv2bpTp3xmwWj6BiLa8igxZCdQC/Mrj2r7swiMsjjUND1y8fHwgglGDJsNuS9vqOznOmq
	z99cztNLlTGlYh0jbmkX1JoPEpolQCiHrUB1DE+S70X6SkzyoNqqM8uRPO4vwnoi6aYmp/D3nny
	eBeODOvjJb4/AUraV7y0s7DHWs9aSGXUlMy2btvaRgURPfmLqH8wkekcNFuPwdzy1pTONlQNp3h
	z8luCUphA2g5QkvGhDZLCgqePoGrJXsBX6PTwkAPLa08MKoN6T+fIuXxrKTX9km9I7iPqN+/TrV
	hYuZ1EtJbt0Rpn1oMZVHEHitwcikSMt5zMpEHyaOo0+i7AZxMtZvWfFD+pEsDE0aR4mhfHxIeTZ
	A==
X-Received: by 2002:a05:600c:3f12:b0:49c:c8de:96a9 with SMTP id 5b1f17b1804b1-49cf7fdd2dfmr588960425e9.2.1788875614332;
        Tue, 08 Sep 2026 06:53:34 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ce5533ffbsm377235005e9.3.2026.09.08.06.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:53:33 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: bpf@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	andrii@kernel.org,
	ast@kernel.org,
	brauner@kernel.org,
	daniel@iogearbox.net,
	eddyz87@gmail.com,
	kpsingh@kernel.org,
	ljs@kernel.org,
	matt@bobrowski.net,
	memxor@gmail.com,
	song@kernel.org,
	sun.jian.kdev@gmail.com,
	utilityemal77@gmail.com,
	viro@zeniv.linux.org.uk,
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next v6 0/5] bpf: Add user memory access kfuncs for mm_struct
Date: Tue,  8 Sep 2026 16:52:57 +0300
Message-ID: <20260908135302.74963-1-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2BF3A180006
X-Stat-Signature: ioqmd85awfz9733smb9pp14n7oj3s63f
X-HE-Tag: 1788875615-405243
X-HE-Meta: U2FsdGVkX1+u6zvF8JRM7HrPNSygkC3PfkVE3lNHNQPoMUKUJD6LG+AUW7m47uc7nsZxVSB6OZVuq5hOGqKy1xik+ivKtvZmI9rj0tX+1gDdNPw0rwVl7DCf5AFXAcpHWQboPHFRYQAK+YoBlcyzQk72YiFKGMkTf+RpPERbW75mEoVZCpd7jJE2hiXv5InovH3A0cnJ+mEastLihbdby/NmH/RXk7wlN/e/G0pLW6AHDESbQclizusyhHcMliKOXsgA4WKOaki7yvP8vX/gsBqqK+i+jlob7L5FrlruprWVOL1mePdDgreKgKWaDYGWNzGQUgy6Ws1nWGqYEbnNjeEb+dFEr7xrrZ9ZXRWS3Z889pZuvtUCYsTr7r7uGFExEyavlVRT4gmNlnf7NrqAiYxjFS0Mnw3o8nETiV9QdnE7ZvPeJpmqu1U+mmxdvwU/CQGNQmRsrpipDPOKlIex0p4uCH+dcnpyvi11ChJWuuRALmzJ3LYoljL6ncjMcUM369fF2kAjXV8AFJb7vUdVRrGHKhiCn2quTGRYPy4R97jMs8QVSsYCPRSYpS++qt83tp5lW00aml70Koz1f3dstztLLX5Q/5bNXnEclZaqi9o7p8Q9wKnVEYcMYzVBhB6WMKEvN+1/HLS8cP6yBdCaF+8tOlFu8fMslD5ZifVT4YBUZCAXRm8XgB0YtIfaGfuQUHj+8D/8B22loBZaZti7EalyGdD55ikfkfh6mMj8L7IZcBY1gS9tjF7SWLRCn+WlR5c6IycMFe2dSziU12BicXmzAq+ATVm/XeC6pRkUwyfDoLye85HkMWGLZjb3UeCkK9eyXVZUzrKztpgqqS9GWOdmKmPuln5PCPDnM3aScVHy1uMDwb03UigGirGZer6Y6iaCO6HTGL8MmklLD9hsd+hBKbvZh4c7TkUO7xvjGhCKzRrID0s67MXhA9XVob9NUHnaxSZQjafW+kT2Vd/
 bWgsJx2X
 tEqay0lBL9TbI5SnsGjat9TO/S2LNzz0Yiw6YXor3rWeuSmB396vIlpaF4Rxys6QgyPAfiRKFLIljojOOFRDmR1TtDxJr1PuAH6HvB1p/K04NHNnBO3wSiZK+BCS4JKYuxBmufXF5bQbXiLoFCLlHWuMokrXWu080yJ4xP8HcgwQoODVQCvRBlgeBQYvltIGEMrA1q0Lw+iecyyx4UX+0zWjjgnS4NOcXMqfXrhtUOC72VjrUJJQiSqxLhdrbM3zwbS5QvoBQ9wU6RAHw7w5Vc9GdtM/Hg2dAyNxBP2vMRIGNOX9lsOr4ldZmCYjljEvhswVZpTiOW1nX2UjZU+q8IdNRKump1DKVXOCVjAKWIHd//iZxvUihPrCZstjR21WPagm+JiZFyEn71YDA8yIiIrtX/NdJB7dpqg+iV+YqquJan8QT/ujJopU5TGTAlqcDaL6ztUPPofU4y4SCw0fakPexMnxcarFN6Q95tv40rwT7bPvoQ65kkuA+GAcYofxxcVEflO18KCpNyPbT71X/4lZcvuh3NoUqaUOb0ZdYvEmPQg7CIWDQxTu/Zq/Lw+a0aU5L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On MMU systems, during exec, argument and environment strings are copied
into the new address space held by struct linux_binprm before that address
space is installed on the task_struct. Existing BPF user memory helpers
operate on the current address space or one associated with a task_struct.
Because no task_struct refers to the new address space at this point,
programs cannot access these strings from the bprm_check_security LSM
hook.

This series adds two sleepable BPF kfuncs for copying bytes or
NUL-terminated strings from a trusted struct mm_struct. It also marks
linux_binprm->mm as trusted-or-null, allowing BPF LSM programs to pass it
to the kfuncs after a NULL check and inspect exec arguments before
allowing the exec to continue.

To make the trusted-or-null annotation safe, the exec paths are hardened
to clear bprm->mm before dropping the reference it owns.

On NOMMU systems, exec argument and environment strings remain in
bprm->page[] until they are transferred to the new process stack. They
cannot be accessed through bprm->mm at the bprm_check_security hook.
The new kfuncs remain available on NOMMU for address ranges represented
by a supplied struct mm_struct.

The series adds selftests covering both kfuncs while reading argument and
environment strings from linux_binprm during exec.

Changes in v6:
- Drop redundant extern keywords and CONFIG_BPF_SYSCALL guards from the
  remote memory copy declarations.
- Drop the explicit bpf_copy_from_user_mm() prototype and share copy 
  logic through inlineable static internal helpers instead of calling 
  between kfunc/helper entry points.
- Validate flags and zero-length requests before acquiring the task's
  mm, preserving existing behavior and ensuring internal helpers are 
  called only with a live mm.
- Drop the verifier relaxation for unchecked reads through trusted-or-null
  pointers and its tests.
- Fix the existing LSM selftest to explicitly NULL-check bprm->mm after
  marking the field trusted-or-null.

Changes in v5:
- Move the shared wrappers to mm/util.c and handle zero-length requests
  at the entry points.

Changes in v4:
- Add negative verifier tests for atomic RMW and load-acquire accesses
  through trusted-or-null BTF pointers.
- Preserve explicit nullability-marking coverage for tracepoint
  arguments, dentry->d_inode, and sched_ext .dispatch.
- Use the already-nullable mmap_file argument for the negative store
  test, avoiding dependency on the later linux_binprm->mm marking.
- Clarify the bprm->mm lifetime invariant and move its lifetime fix
  before the mm_struct kfunc patch.
- Reword the trusted-or-null read change in imperative mood and remove
  its redundant before-and-after summary.
- Document that the existing task-based user-memory interfaces delegate
  to the new mm-based implementations, reorder the string-copy kfuncs to
  remove an unnecessary declaration, and annotate the remaining
  declaration with __bpf_kfunc.

Changes in v3:
- Replace the linux_binprm-specific kfuncs with generic struct mm_struct
  kfuncs, as suggested by Andrii Nakryiko.
- Move the kfuncs next to the existing user memory helpers and make the
  task-based variants delegate to the new mm-based implementations, as
  suggested by Andrii Nakryiko.
- Clear bprm->mm before dropping its reference on exec error paths.
- Mark linux_binprm->mm as trusted-or-null.
- Allow fault-protected reads through trusted-or-null BTF pointers to
  preserve compatibility with existing BPF programs, as suggested by
  Andrii Nakryiko.
- Add verifier and runtime selftests for trusted-or-null BTF pointer
  reads.
- Rename __copy_remote_vm_str() to __copy_remote_mm_str(), as suggested
  by Andrii Nakryiko.
- Clarify that reading exec strings through bprm->mm is limited to MMU
  systems, while the generic mm-based kfuncs remain available on NOMMU.

Changes in v2:
- Register the kfuncs on NOMMU systems and return -EOPNOTSUPP when called,
  as suggested by Justin Suess.
- Add selftest coverage for reading environment strings, as suggested by
  Justin Suess.
- Clarify that copy_remote_mm_str() leaves the destination untouched when
  called with a zero-length buffer.
- Use sizeof() instead of hardcoded argument lengths in the selftests.
- Use ~0ULL for invalid-flags checks in the selftests.

v5:
https://lore.kernel.org/bpf/20260907165220.52431-1-tasos.papagiannnis@gmail.com/

v4:
https://lore.kernel.org/bpf/20260904145340.40212-1-tasos.papagiannnis@gmail.com/

v3:
https://lore.kernel.org/bpf/20260831092305.42062-1-tasos.papagiannnis@gmail.com/

v2:
https://lore.kernel.org/bpf/20260820131801.68759-1-tasos.papagiannnis@gmail.com/

v1:
https://lore.kernel.org/bpf/20260812111140.7762-1-tasos.papagiannnis@gmail.com/

Anastasios Papagiannis (5):
  mm: Add copy_remote_mm_str()
  exec: Clear bprm->mm before dropping its reference
  bpf: Add user memory access kfuncs for mm_struct
  bpf: Mark linux_binprm->mm as trusted-or-null
  selftests/bpf: Test mm_struct user memory kfuncs with linux_binprm

 fs/exec.c                                     |   7 +-
 include/linux/mm.h                            |   8 +-
 kernel/bpf/helpers.c                          | 130 ++++++++++++++++--
 kernel/bpf/verifier.c                         |   5 +
 mm/internal.h                                 |   3 +
 mm/memory.c                                   |  41 +-----
 mm/nommu.c                                    |  41 +-----
 mm/util.c                                     |  62 +++++++++
 .../bpf/prog_tests/copy_from_user_bprm.c      |  72 ++++++++++
 .../selftests/bpf/progs/copy_from_user_bprm.c | 123 +++++++++++++++++
 tools/testing/selftests/bpf/progs/lsm.c       |   5 +-
 11 files changed, 400 insertions(+), 97 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
 create mode 100644 tools/testing/selftests/bpf/progs/copy_from_user_bprm.c


base-commit: 1b7415bf70be95b9a1e7e87d544867881065613f
-- 
2.55.0


