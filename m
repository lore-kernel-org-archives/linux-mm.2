Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 385ABC624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 14:54:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 497566B0096; Fri,  4 Sep 2026 10:54:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 447E16B0098; Fri,  4 Sep 2026 10:54:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 335FF6B0099; Fri,  4 Sep 2026 10:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 097776B0096
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:54:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 71A9EA2DC0
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:54:13 +0000 (UTC)
X-FDA: 85176375186.02.3BAF9B1
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf22.hostedemail.com (Postfix) with ESMTP id A1DCAC0004
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:54:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iMTl+IMj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788533651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mOAh63HZjbJrLKsptC0uE0W9y4S8sjFit+81Vn7lVzY=;
	b=xBmaeWNkLmhsNb3tsdzOLL/By3wo73epiVFmHY/Vp81NAYCj0KAfBd1QZ0DaWNk0TlhjbH
	VwVfP/eXwFvk8PVfBEYhBryDY1u6qOTv6zpMted1EwWuBILCws3fMfhEqJBF4FtfpCZrXx
	UcsCgu7i8ORG/Y0uTbKpKXF++OtqYWU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iMTl+IMj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788533651;
	b=sPSGLhJJu4qjFMWheZvx97tJ7IJUxse9z/mEixfzpxFgOHrsj32gRMHFPSKXLJBMaQaVOY
	NYMQ0N91SXi5mrLoMW35K/fdg4pqlSf1jAJwBLsLeoX5YNgoNJkwiJjI4/eMZpjTItrISa
	xNIQsUDoIaFJ16EIpFAXx6ILCHsDFEA=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48441fa5c37so742860f8f.3
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 07:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788533650; x=1789138450; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mOAh63HZjbJrLKsptC0uE0W9y4S8sjFit+81Vn7lVzY=;
        b=iMTl+IMjaulmUknerI29AuFcstVatJMbq/CMuvI7vpyNBVrBAXRljERHEuFBoHY2ji
         /K5U2R0raOwkq+HAgxJduoHcH/D6EpaSIFqarMGQCeSOspq/6DdLBiCSu2eZLShbE5vH
         7ytlMC5GffGch6oWDlZRhMUoA9ephBAEbGND0Gm30cuyrAx+BUhIXjsFnihrep7lntgh
         iFOt6EcmcMznQNbMOZbbYXjqnLzw7hbmjqldC8fc8BUvtfTo1Ab9FkqdD0ZPRg8cAEN5
         mj6iYjp245PHapet2jcWhLOstZljE1hesPcgjvKfDS6u37IpG1+xgwpEOHCrzZGFOOtB
         nlcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788533650; x=1789138450;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mOAh63HZjbJrLKsptC0uE0W9y4S8sjFit+81Vn7lVzY=;
        b=SkdPZlvFq6YG8/m0dJU7TWTUJPA9aaF89/p0Zi/sNGytL7yKbibOFXZFfPB0knLigm
         lhCay6zPe+G/9hpOOh19gJOXUNl5lH2VX8onh5GeHhBgds4qSOZI92z6n2Hrtap3r9j2
         uHyNnwTaKpN4/UEPTfSh46JlaynFZvqoPhhV6cQBF/PqAkSvjcUDXn+5GerOusIygmfJ
         4bd90KLQgcOqbvvaZogzWbTo+9gMW/FwWYnfuuUas90zn0r48kW1WOixuld0HUoobyxu
         Fpcq098mQLR7IRBLkaIRIbcYGF0w8wKm1y8HHNlCEEtIRVdlEAK67IphvkRVj+0OkWZZ
         UNqA==
X-Forwarded-Encrypted: i=1; AKwUvBzpTx8IgQKxU0/YTwiYELeC0O/CNMIzU5NEQsDejQe7sVvtg1FSP26MktgekTE56Jf54OG53eKFPg==@kvack.org
X-Gm-Message-State: AFuF++kE9FIa1UtoCkSm3Mz6GnKTd88BpCxv9m1/FEr5rNwSCVVT0J4M
	OccK6ekvmfVn+KGJ2IPfuTXCtUrr48wcRub/leW6Y+LBfV8Nuzv5oxSz
X-Gm-Gg: AYBFou3tVExdzlEcZ/si3GCUESjQm5vfM8c+t6iNpo3ZA/zX3wf7eQ3CacS+uFWyUDv
	Dxq+vI87NPiOPFwGiYGKOATouyyVOLrspExB44yGAz5Ab2CrmN85cQ38LSPRzNdnt4hJUCbzdSj
	lfGbNAEizxAnk07bxDE7RkA6f8zMRxNxWWv3kpToOXGjptT3K4oFbcuYZQSwoHSAddH9NLKkprW
	peKcxm40v7UztWTLyWtobM72xR/RONE+uvpqTOkHXDJFDOewto3WC1viND1r3LI5JXa8aSW8Tmc
	UCm9IbGKrVx1ijAprCPNVW2DYovOQuKA1pxfH0506rehwThEGA8LZxeBUVx5mTTTkNOlJeybAv5
	NWe+k68MiVUwQYuzb1h85GI+VC0MjDcTo17Kb74O4ypKE9rND4KB7lqsduvyp0RxtR871nUJbJE
	OE8AY3/D9MyVV/GUyuCXXdw/1QqwAPWgBoF/FBHP3U0XxehdUH5vy5/aUyp+MAwgayRjb+qi21Y
	dKD5NLt+9cT
X-Received: by 2002:a05:6000:4b11:b0:485:8a46:b3bd with SMTP id ffacd0b85a97d-4858a46b4c8mr4684164f8f.37.1788533649711;
        Fri, 04 Sep 2026 07:54:09 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485885cb03asm6802799f8f.37.2026.09.04.07.54.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 07:54:09 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	kpsingh@kernel.org,
	matt@bobrowski.net,
	song@kernel.org,
	utilityemal77@gmail.com,
	sun.jian.kdev@gmail.com,
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next v4 0/7] bpf: Add user memory access kfuncs for mm_struct
Date: Fri,  4 Sep 2026 17:53:33 +0300
Message-ID: <20260904145340.40212-1-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A1DCAC0004
X-Stat-Signature: m9nr8ssdha7yau7afg73r1f9jmumaiog
X-Rspam-User: 
X-HE-Tag: 1788533651-263826
X-HE-Meta: U2FsdGVkX1/owm9VdLjbnrpPY2HHwwOUPqTuugmoWE29NbXLWaAmnTgizHINmNsWHPN3/Gyngmffo/mnPJf2lx8n+DIbbACNOUCFX4SlrhEzD3ed7V82AFi6/QgzwQqhk1MB8nZ+CWA7QnP3WTWoYu2XKdr9x9OlXDiQl5PMZQyv6Xv9uH5AHLFhPTalRbr+iQbeLYmkJdHVhsgkV4ViUw21IJuoQbeP1iXt5tDl3tGoGQFX5V3mJ3pB5v6t+HP3Iz6fBUVoakVhZOM4ZbEoNwFbbfz+hAoHbufXmV6i/ey5qLQvFurRAMQBcTWAIw+ExglKbmvS9hnTGd4qPy9KKKgStCDQNwwbiDwhzUetLloOaBdiImGnUgAIb4EEnSUiFbKYz90kOOMfRDx22hLxclhsuFblDY9JcS9f5SBIAC/JF6jaAtZCnKoDblGLYqqoKNaVea5wqoncRBi9XiDejtmgum12QFjXwEcUKkmutUh7szDxvAa4QHy6E4WamP8t0b5EfvAd1uJ5xZ9C47gTawW8y/dso+N12UgmbOjfhma52v6fFnYanCHxcUh+ydvxEayitLEhJhMC+Z/LVID1AKqE3so9ZK9OFlaUouut3pulCFC97BuWvH5+GBPVII6+v2gbiWvr1LWO8xkULU+8Y6syJYEOB+oXq2CTmLribJk7egZpLCtPuHy/iDqb0+HpU+8fdKRfjDd3rHeFzc2NgPKyJ0Fi9a2+UXtElC2LH4GobsGPyxUB4KKt5qo3SmsHZbuOE8toMpEzXSRNoy5ESHdnE/AcDOCfBT70M4g0VkxIIw6vZCfzHZKfFXS38QHpxClJC9vN9OVou1xwRSVkzza12G2kjc8htr+Vy2XDG6vhve68k3hq9A6WoeEZYhTPAyMY3qeGUIPkwPTkh9K7fx9YivI1syg8H41o2ZrLi/sUftQ8dZBlbBLyR+YMtb3JWMtLrKzUq0eTS/MPBFz
 kX4X9l71
 wMECoQLjlwe1fr0G1M3y2lBwF7bvimgxgd5At26twSiz8Ja786fdm3Fa5pfKSrUtuEtsWMUnwjWYCJ0qyHfq+HsdtBXj+srp8LtEiDqnKjEVlXQOsgHhE2TyJPSfW0UkBvIN1BeQJyAG75rtAmtIV3uhBezKspzntoWV0i76+h30ond2KnAaVoeuziqusIzNZ3br2493GfQiD35cBOGsUd+oAgwbjxSPBRv3gFwTdliXjC3bgogNvxOEIZL9Qb9gv4LHlQS29hWBHfTh2TxBRT74pd56xCErJK6GhYRcnDfkySuHTKFrkxyBiCr+MhthbXcQqZNUEAgvxJi2jP/vbd6SxRZGLTQYA86Tc/Kttg9baPzhPZFWkBGemQwb7KdwEVeaFokKe24/ywHNZTCsWQFwzcQETGmmt+9G+FBdKmUXAOgTNPVyHysWhHjx16xxPjndqgDSAEpayJvmajTUCxMZCkT5Wy4orawVp0MGBInb8ZsvHHIsDc52g7e6FUrbfR6dwJx2CnuGD+RR+EDckT+1g+BjfJjMBXKF2D0RJLsXzCNnCVLOEi3WIN1+GjERBDgws
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

Changes in v4:
- Add negative verifier tests for atomic RMW and load-acquire accesses
  through trusted-or-null BTF pointers.
- Preserve explicit nullability-marking coverage for tracepoint
  arguments, dentry->d_inode, and sched_ext .dispatch.
- Use the already-nullable mmap_file argument for the negative store
  test, avoiding dependency on the later linux_binprm->mm marking.
- Clarify the bprm->mm lifetime invariant and move its lifetime fix
  before the mm_struct kfunc patch.
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
 mm/memory.c                                   |  33 +++-
 mm/nommu.c                                    |  33 +++-
 .../selftests/bpf/prog_tests/bpf_iter.c       |   6 +-
 .../bpf/prog_tests/copy_from_user_bprm.c      |  72 +++++++++
 .../prog_tests/test_struct_ops_maybe_null.c   |  13 +-
 .../bpf/prog_tests/tp_btf_nullable.c          |  28 ++++
 .../selftests/bpf/progs/copy_from_user_bprm.c | 123 +++++++++++++++
 .../selftests/bpf/progs/raw_tp_null_fail.c    |  75 ++++++++-
 .../bpf/progs/test_tp_btf_nullable.c          |  45 +++++-
 .../bpf/progs/test_tp_btf_nullable_runtime.c  |  35 +++++
 .../selftests/bpf/progs/verifier_lsm.c        |  18 ++-
 .../selftests/bpf/progs/verifier_vfs_accept.c |  14 ++
 .../selftests/bpf/progs/verifier_vfs_reject.c |  14 --
 .../selftests/bpf/test_kmods/bpf_testmod.c    |   1 +
 .../sched_ext/maybe_null_fail_dsp.bpf.c       |   5 +-
 20 files changed, 616 insertions(+), 76 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
 create mode 100644 tools/testing/selftests/bpf/progs/copy_from_user_bprm.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tp_btf_nullable_runtime.c


base-commit: 7bf591f26545f5776a4e42d08c06fd94469766dd
-- 
2.55.0


