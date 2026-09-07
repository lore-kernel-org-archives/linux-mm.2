Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2959C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6A896B0099; Mon,  7 Sep 2026 12:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C418B6B00A9; Mon,  7 Sep 2026 12:52:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B57156B00AA; Mon,  7 Sep 2026 12:52:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8715A6B0099
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:52:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1FFBEA0205
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:52:52 +0000 (UTC)
X-FDA: 85187560584.20.E802E69
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6495714000C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:52:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PfSD51wW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788799970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=u9H98ndHjG+ZTBmwr+gw4XIiGi1/LzmNQdKATV2GZh0=;
	b=n6B9eYLXMYOj+ap08c86hDlLBmflSxt4cpuRnlgssx7PMGANNrxg1Ix4VAhQUQWSunUB6k
	S+oXI+L3YA8wFmvxFox8pSqwJGWq+7oiS5CINj12FyOAqgDd9WCrlW6g1ebfQyhA7NCvMI
	+uOJ7sSjwofui+5Gj9N1UQxBjc9QEH4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PfSD51wW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788799970;
	b=p4XInEBmLA9W7laLvV/6GZUB4rumQ3VcwLWcJ+blaMlOqpZwusVjI/BBQ+N3H6IQxmEO+y
	rjSRC1erALTR0b27HLEddZoNGjOmnljJxxp5v4+DCzji+Ha0KzJWzRJuFxwNWawXAZVRO3
	5xKjs+puDdzjYbL0d6s98KZ7tBxA4bg=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-495590dde14so54084785e9.0
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 09:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788799969; x=1789404769; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=u9H98ndHjG+ZTBmwr+gw4XIiGi1/LzmNQdKATV2GZh0=;
        b=PfSD51wWNDjScmTJ0tUtSfrzVJIvbxixnietxn1DosXRpLnq/Ov2dyUdcWz2Pj6J6U
         KUIfqbTgE8RexUcK0DD620Et2o2sYu0YiRJm3SMSmNHdKvCZ32nNasOdRWO28Ht0OmP3
         3xGoKpzTJzopwGlOOzrOlhXEdYHqnVnMXMedQGVy5+HD+LYBHRGUHLGYaMH49VaCNbIu
         F1fa0EaeEMNc/Q7FvuoENnPoPNZi3cvIAPR+mWYokqmJi2D5h0uH+aS/SI9+au0Y6O6X
         SCCX0M1Dt0ick/aobPiPDSpSFQdlkgydCQqOXln+yydBWCpTsRnXTU0aoUBVLWNl3PoN
         4tnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788799969; x=1789404769;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u9H98ndHjG+ZTBmwr+gw4XIiGi1/LzmNQdKATV2GZh0=;
        b=bdtPB/hDAlToxNJb9+cMhNRpt2SWWb5DC6/mz7M/meBDLRnIDLZFeGd1rBNUVfTaJD
         ccafn3zV7cgZ6JKhhXthAUvjTyMPZJ+UMELmO4/4KDLlCxAeeN39ZwKtn73Lewj7jHZP
         Nx7a7GZ8hZQpygav560oVaXkzdcnE5W3UoPAzAnwOrDcanAsNc247F6OdBVfJbZUmp3d
         WckYOeFEQHz1HksVnuDvIX23lTqhtSZJGgRQfhwZhh2IsZ8ZjYjSRyMnAFNXIqnaTOIw
         olJ88XBbGbeOA0cuiCvzExkA/P9oixfHd0Ic5K/3YuixMt6Qs61hOkB+LSDnbztRncBP
         iOtA==
X-Forwarded-Encrypted: i=1; AKwUvBzKbTSt4ByHCmxYA7LtwSJkiexSo8IH8yjaUoDKOEGEyQ7ELiPbFv18L+L92J7B8bT+dENqL0vHaQ==@kvack.org
X-Gm-Message-State: AFuF++m8lvHQrQmRyHssaw6wv+d70inKMp5i/96pJ93x3eGk61m6XV2u
	/1a5vSKZZP3APL1WOrM5pPOt81qyIH0ls+DOS/Tp7/M+sjL7ZRBmh/7S
X-Gm-Gg: AYBFou24nV/sCXIHpORGKTBWknA4YeXMT+mjUPh1SQC5/kX4Bi3lXUoG8MhgjSxISA2
	GVgjL51i8HTByui36YQRUgLDqhu+OiJfQyBq/41YNRrcjHp3texRzuKE/ExQ8PiC/WroztdCzcJ
	KQ22ppVdPD/Bu7cG1dvKrNhfjP+BEpRk45ZU4n9kcahvhroIvOZFm8jRagx7D7d219BiLXfTUOi
	hoAmE0xalzYzhH9RKT2jG4HpXzoY8TKmv8YpD3TDqpiY9/rfiMoeo9ALaDykwYOw4Sf9cAHHSAD
	mSWZCpLntAnxfjPcyX1Y8ZXWZ8gg84ig8mzegUiGWB/xC219YYHAPup4iaDY/jxIMqAliu3YdIb
	L6UxDle9Q+M5KBd/dMZrhMWNHmPbCTOUn55qNE1H/cMVDXcGSF3Jj7vbZmKFAYFnZpL4n2cFhge
	U75sPFf6cxfo1ShSS1spMChoQd5jTm0z56QftVF+jnkLGVKWoT2v8siwq8di8qZ1wDjcge/rATS
	wVS3GdiJ8JD3A==
X-Received: by 2002:a05:600c:a0a:b0:49c:e1f1:3dd5 with SMTP id 5b1f17b1804b1-49cf81e6cebmr426580115e9.4.1788799968516;
        Mon, 07 Sep 2026 09:52:48 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d03543064sm233022415e9.13.2026.09.07.09.52.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 09:52:48 -0700 (PDT)
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
	tasos.papagiannnis@gmail.com,
	utilityemal77@gmail.com,
	viro@zeniv.linux.org.uk
Subject: [PATCH bpf-next v5 0/7] bpf: Add user memory access kfuncs for mm_struct
Date: Mon,  7 Sep 2026 19:52:13 +0300
Message-ID: <20260907165220.52431-1-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6495714000C
X-Stat-Signature: q113z87nhxcuhkjoaa3jom4rt39sxe79
X-Rspam-User: 
X-HE-Tag: 1788799970-971121
X-HE-Meta: U2FsdGVkX19a1BbBe7P3EacurX5CBSxSJs/5yinoCzDJK+snx8VPqqMXFQlGS9ADATUjwFViqa1DpKrMfWCOnhW5Gh5srWNRWPnhYMuNRdcTX6LX16j2RFfFQECmy7dheRphfvBXHQpVxWoV0WPS4Zylty9cHEISpXPCunQoCptlcGoaYj6vQwvtZq5MGAZSfS2ohZBi1d0ffv6l7H/AviATHWkYyPO78Sfvsycybr97gsyujN+AIOBXYr+I9tAr2NQ4jYNJHmMfn64jy7f+eD/H4Jv+y7InOt/Z5a0ILhCkuuoRLUOAJvy8ejcXBb9WDtutW8z4vmofSMiMI1djonc2Io/0BD9+GEe30fBqiD5AjRel5fflyvrEFTD/+e5TFruuLaP3c1z9z55UVyQxjT7OJinYFCKUR1LEI8gCjvQzE0hOGkAtLxfya5quS8sRj15wlN5x1l1sX+VhRTSsAspzgbzy+lMLKFnpx05HuCGe3cW+CpLPqQY3Ox+gI50dcCWjH7pWxpWi42ZLrojC6ydL4+qe4pPuTmL9MsqDBrWHILZIvV6kpOkUeFBlQZD6Ygw54YzkTPK8yfXlZnOJqPbVLw4o3zTYcCp+BH4BPZHRVxLf+keKeQmYxhXZghARLRrDqA4uAdvOP99JpBwrregeeiOYQWMAXnLIy84AVurllu85Zm69I/s2bP2yUZsCXh2uNEsu0a3iHDB1ftMR+jpAeD0y7b6EEcHY///28ouAIc3j73PaJP8lYuLW0vC5D694pSeZIsmuYTmbrzreNroZkZtx1+QZnfe4IcLSUBBE/jRrielh4QC/Hi1Asy6qDTAUk31f+eyUaZM6BR0z0bRHel1mPwC1ZdIGi+kzdeJoBlukeSAY6fC99vKmWfNV1NyD+si87d+xowoWiGub2cjsmKZNmScLQii0bGChAhT0gr+pkTzPs2yb4n70ldWZhcGZQJYkO9oxvIkMlLC
 X+bI9eBS
 JYGrpb4SOLRGUJMP7+yYGmxXNu4io0ljTCQgdr3VCF4odsxiCT2YS3Kf5u+/MOaNCSH3B8n+pTy8vxr8yOPOVmlVextC+iQbaLGfEqFzLeLl51yVA2g//9E3TZh+TEuvyPxYYaUZMdBIFVrolzqYbMRgBpXwK9jBmhDwqx59YArplsifBVwhVVcbFIiBG/RURk+F3sviO7CrtbFNIk0age8Hj5/oUWdkODTrXruH7vXrBUquq1N47GW7jJSp+zXFWMh75aZ9itHR6YXCk5fSyBd6UAsEdYadfIEC9/nJID55ySiZ27rKNJf4Nvd/VVZ7nHv7zgvt+pTHKlNuqIbcegrZgC3L8IfYydgOc54xr+j4Zuae4EAT0/ZRQavMNrPd6Q9PRGguxQE7q45tOOO/pecimCh1rVSumr/NSI7lqUMIM4OvyCowQe4g3b9qppQy5GUjFHKaIeqDN+lcbRWND1azFkAuw9cL6Ee2dheskpO9sEDFdaFjh++UvGR4T5G0UiMLEUtB3UqEjLd+5B5jf/h7x2LlXuOEzxZsFUfQdh2RD4snkJ59UmjuqGIfNL0ebPAfK
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

Changing bprm->mm to trusted-or-null would otherwise reject existing BPF
programs that read through it without a NULL check. Preserve that behavior
by allowing fault-protected reads through trusted-or-null BTF pointers.
Pointer arithmetic, writes, atomic RMW operations, BPF_LOAD_ACQ accesses,
and passing the pointer to a kfunc that requires a non-NULL trusted
argument continue to require an explicit NULL check.

On NOMMU systems, exec argument and environment strings remain in
bprm->page[] until they are transferred to the new process stack. They
cannot be accessed through bprm->mm at the bprm_check_security hook.
The new kfuncs remain available on NOMMU for address ranges represented
by a supplied struct mm_struct.

The series also adds selftests covering both kfuncs when reading argument
and environment strings, and verifier tests covering trusted-or-null BTF
pointer reads.

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

v4:
https://lore.kernel.org/bpf/20260904145340.40212-1-tasos.papagiannnis@gmail.com/

v3:
https://lore.kernel.org/bpf/20260831092305.42062-1-tasos.papagiannnis@gmail.com/

v2:
https://lore.kernel.org/bpf/20260820131801.68759-1-tasos.papagiannnis@gmail.com/

v1:
https://lore.kernel.org/bpf/20260812111140.7762-1-tasos.papagiannnis@gmail.com/

Anastasios Papagiannis (7):
  mm: Add copy_remote_mm_str()
  exec: Clear bprm->mm before dropping its reference
  bpf: Add user memory access kfuncs for mm_struct
  bpf: Allow reads through trusted-or-null BTF pointers
  selftests/bpf: Cover trusted-or-null BTF pointer reads
  bpf: Mark linux_binprm->mm as trusted-or-null
  selftests/bpf: Test mm_struct user memory kfuncs with linux_binprm

 fs/exec.c                                     |   7 +-
 include/linux/bpf_verifier.h                  |   9 +-
 include/linux/mm.h                            |   2 +
 kernel/bpf/helpers.c                          | 142 ++++++++++++++----
 kernel/bpf/verifier.c                         |  17 ++-
 mm/internal.h                                 |   5 +
 mm/memory.c                                   |  41 +----
 mm/nommu.c                                    |  41 +----
 mm/util.c                                     |  62 ++++++++
 .../selftests/bpf/prog_tests/bpf_iter.c       |   6 +-
 .../bpf/prog_tests/copy_from_user_bprm.c      |  72 +++++++++
 .../prog_tests/test_struct_ops_maybe_null.c   |  13 +-
 .../bpf/prog_tests/tp_btf_nullable.c          |  28 ++++
 .../selftests/bpf/progs/copy_from_user_bprm.c | 123 +++++++++++++++
 .../selftests/bpf/progs/raw_tp_null_fail.c    |  78 +++++++++-
 .../bpf/progs/test_tp_btf_nullable.c          |  45 +++++-
 .../bpf/progs/test_tp_btf_nullable_runtime.c  |  35 +++++
 .../selftests/bpf/progs/verifier_lsm.c        |  18 ++-
 .../selftests/bpf/progs/verifier_vfs_accept.c |  14 ++
 .../selftests/bpf/progs/verifier_vfs_reject.c |  14 --
 .../selftests/bpf/test_kmods/bpf_testmod.c    |   1 +
 .../sched_ext/maybe_null_fail_dsp.bpf.c       |   5 +-
 22 files changed, 631 insertions(+), 147 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
 create mode 100644 tools/testing/selftests/bpf/progs/copy_from_user_bprm.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tp_btf_nullable_runtime.c


base-commit: 1b7415bf70be95b9a1e7e87d544867881065613f
-- 
2.55.0


