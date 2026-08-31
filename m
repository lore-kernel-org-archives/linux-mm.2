Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1FC7C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:23:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D23066B008A; Mon, 31 Aug 2026 05:23:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD3C36B008C; Mon, 31 Aug 2026 05:23:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE9796B0098; Mon, 31 Aug 2026 05:23:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9823B6B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:23:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 26C2740403
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:23:40 +0000 (UTC)
X-FDA: 85161027000.10.CC75DD6
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id 793EEC0004
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:23:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pbcm9neR;
	spf=pass (imf28.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788168218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0nZi5lpGroQ1n6Zg4TqX5QiY23WxJ2fmAQc30SHAO+w=;
	b=LZo6Z60tw9xNMLh4qU6McwDmm+E3ScaRLvA0TNHJEYfRTYgj6XqnAPB8ZDlhmuB07omtfd
	9b8rMnfU2CKiXPgL7YJiz3z1zO1TDY2/UaHSebjbsc+5Xtn6MC0vtZg6sKQ5EhG1tqgQPn
	g5EghmCzNLw5jyzm8RzKq14sOHkrl5I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788168218;
	b=U42CZGulvrQ//SU2qnKjowrxTG+JF3Shr9pfHga9v4AhnjsZb7N2ZGR4QypyZvsrNHubgo
	B4445+a9lTB0IsyynQxQ23fqrM6srGJC5bMJHpTtGWJT8g8neSb3/9vi73LFg2WsOgnrEa
	Xs5mJ5EUVN/uJN2X4YQChm3YVzRunWI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pbcm9neR;
	spf=pass (imf28.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4843e9c5960so352375f8f.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788168217; x=1788773017; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0nZi5lpGroQ1n6Zg4TqX5QiY23WxJ2fmAQc30SHAO+w=;
        b=pbcm9neRZRVn66ECACj26qnSSzq9uVmjEYAmaeiG9lsA/Wu4RGk8Cw0AN+EhEXs1mt
         8TO4KPZDIrhEC+nqUHYyoseF6UZOIlMzgwhFLkq3GcAlgk+hrQAj1FneLt6ysUDKEBth
         f86WFUUFTX4D2b5PJEwpip1lnRQx7jXMbVfie9esphr09EHGhPpAC7TpcjOLx3ePv9L7
         eIzediByuXR96/JMm/DK8ir+Mv49SefVc7+5S3d2EDsdQytEUguV7ieFx8l3pleV1mm+
         wLNJVLZNovXztf18FPaV0pJM6jXhs1cGqm29Ha1KqGEqmSkdwfVPmrc+Zitm2TyVXMaF
         usrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788168217; x=1788773017;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0nZi5lpGroQ1n6Zg4TqX5QiY23WxJ2fmAQc30SHAO+w=;
        b=LRncdPjrg9eaVfXzw9NsyNX0eBzSJQJI/fjJL0cc4OgbAcfCybAFJfX+uvbOOGgOfn
         80rmyc7izsLJln4cjBzyqBbE2Qos74dy2O+dFFiq+OurLEz389cMo5jl941WUY6CaIwJ
         w5CDxe/hcbep3IozXtjhwAYgork2kLahydCgPSYwvd+ZPeOGFegXDiZzhddmE+1uvQ+l
         /gBCwYK4nuS6VP72K6mvPelQ+PYiuJW58cMGm9V02g36CGrlP3yDCP8+5Qonx9GG8RqR
         7AkbdzwjqQCeL3qUl9HiiW7tb/iQuVRMGuSS/vh3C1F+ThjuyVTGQAkGZdUf4s8wamiw
         HfBg==
X-Forwarded-Encrypted: i=1; AHgh+RrB3rCIRcK2SfCx9kd6LIygkiVCzIBhuCk9ZmISak1up6EgHxGntHNKgeJHtq5HN5ER76Bf5QCSUA==@kvack.org
X-Gm-Message-State: AFuF++nIKj8cUYDp9sUlWDDSSo7f1IIaEF30OA/mD4Jz6tHuvaNVatxm
	lSJrxrzHVSyPtLuWvegpqMBFnjaqqIVg5hVpg7DsXBkd+Keot1Q0NziY
X-Gm-Gg: AR+sD136nR8ByHjpNAEIXZCaFZPM39bYyzXqYCQ7fU47XTnZi4jLtOhrkL8ADMs5dxR
	VXMja+N6UD2/BVBCIXzTofMl5MhqYBIitiU1Yi+RuLt2iApZCfAzc/nrqqo7FYzUZ0YCqImjIjo
	eNcH+vHeXdB92C8vF1GAmS5J8NZbwqx2hIcVoku8kKNJBxOpivIwmWRpnd8zqegbDYf7ms1X5Wx
	4D7qIWqg6rpVP2wemJB+dMV7/xJnPmBup5s6YdkQdSYpHi8P203V9Jd1cmkx7bBZjpRKDqQU8Zh
	k0xJ9Cm3svM5IXIcRH7Y98zhQi67gAQHIrNmq2erVKDMLOJQEnlVPusFch/HqRRfmLjsfi/iX+9
	nVcC0sOh7j6bDWO7KpFDZRClj9LpC1xWjioH0fr9tL1OaphfTxOGCbymJO6QQ0vJPctBFOGi8rw
	kF6xAOkH+mGRrxEU3SpUyXjB5EkAMAtJ5exrPp6pinBwBdXkB16ryJYJW3UQDhPNbn0dMstlFit
	Q==
X-Received: by 2002:a05:600c:6096:b0:49c:cfad:90c1 with SMTP id 5b1f17b1804b1-49ccfad9180mr218842755e9.14.1788168216864;
        Mon, 31 Aug 2026 02:23:36 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b9500c80asm318248155e9.9.2026.08.31.02.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 02:23:36 -0700 (PDT)
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
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next v3 0/7] bpf: Add user memory access kfuncs for mm_struct
Date: Mon, 31 Aug 2026 12:22:58 +0300
Message-ID: <20260831092305.42062-1-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 793EEC0004
X-Stat-Signature: u3uh5ksauxk3c5u19bnbjuqxz6pbhp8a
X-HE-Tag: 1788168218-45606
X-HE-Meta: U2FsdGVkX198ZyDuOxA+rtmB22h0KP581Sw6tTabM/NnsW6acgo3sq9uOyetgOekYfEzVxYEKQeU1/5RJveIoZrcrXvIh+ldrxfBwrOM7+aU/tIuJoTx7yDXgMNZ8r6xzWIobke7pPHv6MsipozpaLaTaTLKOhwHALZW9VYz8ucLQUHOzs5O3HURFF3gRt9ig0wzX0WpIWmtwV8yfSOPpzFnG1zBLkM2bW17QDCRRZKaMfSHkms+/mlV8ke1Q8M6gE3fmWAw25beQUz0nfbTVXR23Mn8NLfO0leTfRnztyofD/xO49GNg+VoVlUmsbl2bzMh89GULMGnD2HHSM8KGuCvAIxL/ZYGFj3L9Uciv6L39F4snPR1M5RlRerFHD0zxJ/S7oZK0KcgNosJ/d76gj3W2FTZfpTV2kaPwfBOgiDeNwzl6B9xx/aE2836JlCZsLmYRaJoGz6U4i03OYpJAU0Wh1pLKgCoyWFLmMmdNLqwqk9jPWra8yXGkAEr48xBWbfckbyjHZWxZgjSLr9/MvCkYIo9grdruMkZh8UaV///KUhee7cGf/s2+RbIk8Nc72mIR+TN6wZhPcVL4Bj3mH3gQqgArkC3EyTZnLXd+6jlbtoY/zJsqXbsUdoE/K1GgjLJ/gnD02UjplipIVYkP8Dq9/ZidSfLvPrK9sZrU2qmGJbgLLKJr817sRcM+snhgEqzf7+7oEd9rHnNN+zqMC5jime45mxOsEKSCxtc6D1l7xn13s7wV4D7kwDh/kgYZRW82eTtCZjiezAgoDt9QBrgz5NW7lPBIW8DfWpNsf1v6+BAWMDSFvycojleOQn1Snc2D6Zt33bsIW2f2E2dNJ60PhnkgJ5THaI4kyMAkvzWBMdgj85iS24cAf72vw3kZL4mo6Jt889epXHZ02qSYEwOJX/5BiX8ActZE3cZdgBr+yTTHMFbtPOTm3+TA/I81C3nflC2DC51EnbbZux
 bZ+Gqb07
 eJMGMXEGweERbR9T339fBqPLROz06e2YMn2aQyCorQcGee1Ym0y8FD6oGTsPrDWBWsqzEZsZ6CzWGgILd9QFee0MefBUcwp9e4KgqngEUvAE6qZn2IAaKLk4Cau5gXaoGm1CFJTgVhxYAZBv/0IVJmRqIQfoc3mgH1CKYKoLX95/W/2QIl39VDKoUGB8ZizrhQzqdzc2QqBYRUlDk9oii1NT16HBGbl6MYeNykoIEm8Mz9fsLTY4XTWNpMgsTZBZ+MJnZb7poomOeoFjYoTZbg9ikeUgVbv3+QmVwKeTs/nt7KIUaC0lk+1zTu5KKTVIrRAZpEHWeULUpFD7R0zM4+zJGvGRUShX8XR2A2JqzXu2daLKNkIOfmV263UZvbaBob/nEeCqJOBCR/bhfmHwBWe3itf9Z7OwNlNOPw2zmFNIPd7EY9MYNE6fMZwSzdc0CiSU+/ofqNsU2ARJxBnvah6oEsCCGk24qu4D5i6SS+P+ufX08cWZIXHDEa0RYUku0fzcIwnsBx6axljIFMIZFilm9L5qNjoWeiQM0IbbjmmzWpNCUQHELRQo6Sw0Vttn1suGZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On MMU systems, during exec, argument and environment strings are copied
into the new address space held by struct linux_binprm before that address
space is installed on the task_struct. Existing eBPF user memory helpers
only support reading from the old address space (i.e. current process),
and for this reason programs cannot access these strings from the
bprm_check_security LSM hook.

This series adds two sleepable BPF kfuncs for copying bytes or
NUL-terminated strings from a trusted struct mm_struct. It also marks
linux_binprm->mm as trusted-or-null, allowing BPF LSM programs to pass it
to the kfuncs after a NULL check and inspect exec arguments before
allowing the exec to continue.

Changing bprm->mm to trusted-or-null would otherwise reject existing BPF
programs that read through it without a NULL check. Preserve that behavior
by allowing fault-protected reads through trusted-or-null BTF pointers.
Pointer arithmetic, writes, and passing the pointer to a kfunc that
requires a non-NULL trusted argument continue to require an explicit
NULL check.

On NOMMU systems, exec argument and environment strings remain in
bprm->page[] until they are transferred to the new process stack. They
cannot be accessed through bprm->mm at the bprm_check_security hook.
The new kfuncs remain available on NOMMU for address ranges represented
by a supplied struct mm_struct.

The series also adds selftests covering both kfuncs when reading argument
and environment strings, and verifier tests covering trusted-or-null BTF
pointer reads.

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

v2:
https://lore.kernel.org/bpf/20260820131801.68759-1-tasos.papagiannnis@gmail.com/

v1:
https://lore.kernel.org/bpf/20260812111140.7762-1-tasos.papagiannnis@gmail.com/

Anastasios Papagiannis (7):
  mm: Add copy_remote_mm_str()
  bpf: Add user memory access kfuncs for mm_struct
  exec: Clear bprm->mm before dropping its reference
  bpf: Allow reads through trusted-or-null BTF pointers
  selftests/bpf: Cover trusted-or-null BTF pointer reads
  bpf: Mark linux_binprm->mm as trusted-or-null
  selftests/bpf: Test mm_struct user memory kfuncs with linux_binprm

 fs/exec.c                                     |   7 +-
 include/linux/bpf_verifier.h                  |   9 +-
 include/linux/mm.h                            |   2 +
 kernel/bpf/helpers.c                          | 115 ++++++++++++++--
 kernel/bpf/verifier.c                         |  17 ++-
 mm/memory.c                                   |  33 ++++-
 mm/nommu.c                                    |  33 ++++-
 .../selftests/bpf/prog_tests/bpf_iter.c       |   6 +-
 .../bpf/prog_tests/copy_from_user_bprm.c      |  72 ++++++++++
 .../prog_tests/test_struct_ops_maybe_null.c   |  12 +-
 .../bpf/prog_tests/tp_btf_nullable.c          |  28 ++++
 .../selftests/bpf/progs/copy_from_user_bprm.c | 123 ++++++++++++++++++
 .../selftests/bpf/progs/raw_tp_null_fail.c    |  63 ++++++++-
 .../bpf/progs/test_tp_btf_nullable.c          |  17 ++-
 .../bpf/progs/test_tp_btf_nullable_runtime.c  |  35 +++++
 .../selftests/bpf/progs/verifier_lsm.c        |  19 ++-
 .../selftests/bpf/progs/verifier_vfs_accept.c |  13 ++
 .../selftests/bpf/progs/verifier_vfs_reject.c |  14 --
 .../selftests/bpf/test_kmods/bpf_testmod.c    |   1 +
 .../testing/selftests/sched_ext/maybe_null.c  |   6 +-
 20 files changed, 566 insertions(+), 59 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
 create mode 100644 tools/testing/selftests/bpf/progs/copy_from_user_bprm.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tp_btf_nullable_runtime.c


base-commit: d761934c9483ecde93fe99d8705282f716dfee50
-- 
2.55.0


