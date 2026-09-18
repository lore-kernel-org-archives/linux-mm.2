Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB546C982D9
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:11:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8D8C6B0098; Fri, 18 Sep 2026 05:11:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3DF06B0099; Fri, 18 Sep 2026 05:11:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D07A56B009D; Fri, 18 Sep 2026 05:11:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9708D6B0098
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:11:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17387C0597
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:11:18 +0000 (UTC)
X-FDA: 85226314236.07.DD4A101
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6689A180002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:11:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nUTZe7Ri;
	spf=pass (imf24.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789722676;
	b=3+SlpmH5aSHh8M6hu46MvhepiSCgPaJd+iLwUuZPEaspJwHx/feeLtY05hZ+6fo7iVWq7g
	5hv1y7neHReKT7USVvILoG5hCfk6aKPEHtDU4Krbkmgq4RqCnpsYFjvOyGmH0z9DwkVdQz
	LYTrfcR20sx0yXXCw0H1gdF0bdc9Szw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nUTZe7Ri;
	spf=pass (imf24.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789722676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SHLSHkTPbt9kkxq29Sn3Lw/rKmJD8RTBCnKLHusuNiA=;
	b=ZvNZLUuCvb6b58EVYRICCe7hnF8fyC0g9fRjH09XMapAZNwfBn7a0zfgiQMUMhoz3RvYmL
	mT7CfrHTnDmfYpRhoi+rAPtdJsRHpcwAAHBIXPdpjdmoOPqBfFuWXNiLasMVBT/EjeXISG
	MMFEFVg6XVJrIPtuVAzlb1T4htY11VY=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912e2406so2572845e9.1
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789722675; x=1790327475; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SHLSHkTPbt9kkxq29Sn3Lw/rKmJD8RTBCnKLHusuNiA=;
        b=nUTZe7Rimo89lvUI41/YJL+G6REHtY2Ux7DN/5hONxPwbn9t3qhBeDjWthEQFl7XUd
         OBOCs+F827xXwOlTNwhXQl8p3iUd4KHAVMMODaI5tiwg+FuNDfgBvZBBJZKLTcfGhGEm
         bmTaarNBx9MlSSXefkc+VT/+nvzSzxJV1PMVzWXOt7wFfkmpABWh55XrVi/5JLsdkU9y
         oOg0BA6KzaA/B1+VY0kN2zUYPgnMsIcIEsfF+RtszyqpoDGJD6S6p1Ast+ybJQecNjSl
         VjopOXZw536KIYDCM3c03AFsBS+OloxOO9WumT50hNeuogcDarC9CAGOxxF0olhzc1eM
         DPFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789722675; x=1790327475;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SHLSHkTPbt9kkxq29Sn3Lw/rKmJD8RTBCnKLHusuNiA=;
        b=fzo+385ZnQMt0Eh8XlmoDrOM0uEspcwKOewB/oSbL4gS/90lWyUMFSp0HOynZv+pTx
         gelnyL8eWlLM9Nfa2OAduUIxkVQeWMlpI2ju1UwbarA0N2yhxxvR0bqfo47OwXdPXDhs
         i+6etdhVMb6yi7s4KejjtwNzD9UP73iVdogwLZUtzIR917h1BmYYrUG6DwiRU0GuQPy2
         x7yrCmBplDKtLvwdXKidp962BL9YYNjNtYnfFGZlV98cAzmYnKBR4pWLNFQc3b60o/fR
         rpefsWGx2mrlHHH3woEjpKGSCm9aakN8qmpre0LjUtF7/0qi1OdgszTd5OO0wnMrrXy8
         sXxQ==
X-Forwarded-Encrypted: i=1; AKwUvBzndfhduEqjC2fKDxRnm+aQYP+6esoKrX0DVJ675H6XlmGpXT47D0WxhqFLg8aPH2IBCLYMqzxvbQ==@kvack.org
X-Gm-Message-State: AFuF++nPnfE0Ftz7cMciEHn/y5XXZZcyzJDBz4LiFysO0EXsVMVBIjn5
	y0anU/mewFr4RhV4uY1ze+SPBWGeHn1F6+VWDsWyRMgXa4BJTS6l7Po8
X-Gm-Gg: AYBFou1F3kffGKjH7EpyXEi3mfb1Nk5oXOvSMXYTCrxwBInPL1u9NQ1KNMlDIXOwPdT
	1kOiEoUWui1+yuaP/POFJr03+H6Lb5Fg4mUlwWNX6YU47ubue/6bHk0Vd2os76Yj+sLBX7n434n
	E4olpN9PebZN+Xz3gB8TsdKq00qZuPIhY6IrBwYBLz0mhXbDKDHZ2XkaGPZkVz40X2Wg26UADvt
	/Jk1aospCl0p+PbtJaOpEXlj33BTjRKKirTj8m6SVrR6BvUQt8WfPJjwESZCFcG+Wl5lgL52oao
	p/YH0wgj0gvt2G2ZDgSsOsbfJCNWCSh2gtz5aKdHR1fAR5hGXYyanPNdBHu6nc5vzUxEpzK2R27
	+M3TuZYQWxofrGHe1v3lNVouKVoq0DfLBiLc5NpzIdzI3mg5d6ewtVq7ec1Wn4m3NExc1OyGabJ
	fMDiPcoJOHk7Tfvr6Nu7bf5reMe247GvwpKRfo33JT9/bUpTN6BP6dNjWfojyvbna2PImqU8fGs
	A3ntIK/KPEWrovaAQyG0LH8BQ==
X-Received: by 2002:a05:600c:1d06:b0:49e:8222:3451 with SMTP id 5b1f17b1804b1-49fc5001358mr26352405e9.14.1789722674633;
        Fri, 18 Sep 2026 02:11:14 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b4e:8500:290c:210b:1c76:5710])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbd1d0978sm138774275e9.2.2026.09.18.02.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 02:11:13 -0700 (PDT)
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
Subject: [PATCH bpf-next v8 0/5] bpf: Add user memory access kfuncs for mm_struct
Date: Fri, 18 Sep 2026 12:10:53 +0300
Message-ID: <20260918091058.297740-1-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6689A180002
X-Rspam-User: 
X-Stat-Signature: qe66ubftxfg39it1tm7eqkb6kkha4wpg
X-HE-Tag: 1789722676-305624
X-HE-Meta: U2FsdGVkX19BDw43DsRiP/CWU+EZx5QXNMMZZEs8wGB7iwVnecGYM0cwq4cdmzuTz7m8fHwYExUmRCZ5PfSCWXNo5A82zQQrK6fPh1cRPT6UdifT2bxK5YQXkQ0jjSfx5jkzct3XVm5Cafd0hPe5QeEy++lNmHl41AXQuaDfpkKG6EYihy3wrZZ8tzxCOaTIG+6hb5TQHewRtPNqDL/r52zImD3W9N18jMNFiDIL0tGLdqnxfKkQYfE7x+nRABa6BnQKwRuG8AWHlIt4oSPQrpzIxlE2n7024npJtvLfNGwT5E4TR32EpBM5XgvijRMIvW0S9x5jLtD6HguAEeIABuoT/twKV7eDPZKFCuF36iqxXUxxE+/byRGqRx70HHE4oHMRTTV/eAuIm9Sseio6mjtrKx4GOFmXt5CMHhYycoDReQNvRjgqBbGjSnw36gtXN8vjI+VfuwktOLQl92vbq8CWe3616bdjHtv+wXJVt4/e6mhr54PiDtE5NpLFoURAoW8Yy/a4jJF4j0s9X67/q0fT4Qdbpn8QYuZl86s3bdSHzg+Bwoy17D9Qnze8dPSO4Z5+tRVRSKsicPr3Asw2j09SV+iHe9BJ7xWdb6MXHuBHswB6Gg2H3JK0CXMKaQ+kTtzZtWBGv5SXX9bOcFI4zcXVR3tzk3N87FIAzezoBd04pV2uhJ6rejGiKxLV+VjLlshzWPH2y/65MbOiZk9grY5TeXZLgGYknybB8y//8SEJYfhrwQmI3/ZC6vQ78nVK7gW3+1tWkG/pIAtmaO5P3YBgGI6QSBYHzpDy5q928IVJWjdLJBJw8lZqU5/M8s/DBK3i0wvqT4bXv74UU77SkFb5NQ02EdZkEGpFTLfNIHqSefiJFGxSb34hti4Sq+4r15VPHxPvn+BFx8rkepAl6CSO8BRwb9sflJ3EKP1+sXYOeQLC352v6gN1mdbdAxTcELbpzMgkceSIdSYNEEB
 BEkPRQ1Q
 aq7RkUMu8qxUr0K4LVZXPrpf8y1nfMomWcgggN3uucNPzR71Xgn91H3pJZ84Jw/XIQ1gjBQNDVf3iYouoyRBtrarR/vJk8YEpg3+x/X7iHF67yDhQIBEzsOgW3XLjy2YbuXbBMKt1oug9KutRoLu2VJw7Ugjkjr9KOOcnn9nDYAK8pXT/km3faJxD2P0WJF/u10EimxyGohqcSXsJegtro4QFqpbxldsxGhnlM5TmNVnqS3la9Ku5EbhudgOxAklN18vfR3yRmHi4Lo5Fhf7EZO6U+g6/psxBTTAGhqhnp7hRttjD6zKC7bE8SwIl7OozCAXwtWqMCfKVSjF1KzE+T8I1r7lOwxkVGmNhtQ49B8bWpY7RlI1w5Y2Jl/U8eKqKE1vEDkBVALcsIAERD5ZJN7KMUDV5GQb/eUBkhIGjl/EbnLmj12MMZfQFH1CTjshwZlWj96nxIsbwSYo6yYTkfZxgpS8989/E06TZ9eqippnFSZ86tf7z7EXAXk33okg/FW0zIdyL1J5BohZAo3ks8FPZOQfubiE6EpO5Zqm8MihHagVgbLULYPWFcj7eLs1wmQmh
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

Changes in v8:
- Removed CONFIG_BPF_SYSCALL #ifdefs from mm/memory.c and mm/nommu.c.
- Reformatted the selftest to use 120-character lines.
- Removed the CONFIG_MMU check from the selftests.
- Removed the extern declarations from the selftests, as they already 
  exist in vmlinux.h.
- Moved the checks to user space in the selftests.

Changes in v7:
- Use execvpe() instead of a hardcoded /bin/true path in the
  copy_from_user_bprm selftest while retaining the controlled environment.
- Remove the unused bpf_misc.h include.
- Rewrap the invalid-flags kfunc call to stay within 80 columns.
- Fix indent in mm patches.

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

v7:
https://lore.kernel.org/bpf/20260915080255.48929-1-tasos.papagiannnis@gmail.com/

v6:
https://lore.kernel.org/all/20260908135302.74963-1-tasos.papagiannnis@gmail.com/

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
 mm/memory.c                                   |  43 +-----
 mm/nommu.c                                    |  43 +-----
 mm/util.c                                     |  62 +++++++++
 .../bpf/prog_tests/copy_from_user_bprm.c      |  65 +++++++++
 .../selftests/bpf/progs/copy_from_user_bprm.c |  69 ++++++++++
 tools/testing/selftests/bpf/progs/lsm.c       |   5 +-
 11 files changed, 339 insertions(+), 101 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
 create mode 100644 tools/testing/selftests/bpf/progs/copy_from_user_bprm.c


base-commit: 961b8946acb482b6d7a39c266d623e5f9c4e873f
-- 
2.55.0


