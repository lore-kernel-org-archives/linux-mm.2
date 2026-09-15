Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4CC6C88E73
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 08:03:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55A036B0088; Tue, 15 Sep 2026 04:03:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5315D6B008C; Tue, 15 Sep 2026 04:03:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4487F6B0092; Tue, 15 Sep 2026 04:03:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 182606B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:03:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BF17D80352
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:03:28 +0000 (UTC)
X-FDA: 85215256896.30.037EE80
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0C67840006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:03:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jbcElMYf;
	spf=pass (imf07.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789459407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kcapaBho2kR7enVDRwYTAMH/Ad+5izpm6YLmaU/7cvE=;
	b=pfYDvlu+NQdXPUyyrtvfITieuGFJYZwkuGteOYGKnGIihI10BzJk67Hr/5j9g5XHTVhwdK
	KQo1+RV8ecrLMXmOm6TTZqX2RPrKVxQDEpykET9vKVydKFh4mMp4CLqaIDDhcEM8X7qkuJ
	u7xvJgor8j6CsQDsHUux//Y2WDJHUik=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789459407;
	b=njyVqZ0iGdKgaZ5clOIcYG0cbdAYid2wnrWZqrnw81aIj6p+YH4/pliJO3gfdaJUudPe5H
	zcYMSmPQwa2CvYboTrh75dCNlZtx6Bdh90Fcc8u/3xlHdqEk5aclEFBPRZ6rL6puRP/69g
	to3G9oItecsYjJFRbgA2V7BR2IiTQrA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jbcElMYf;
	spf=pass (imf07.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ccead2aecso11700525e9.0
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 01:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789459405; x=1790064205; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kcapaBho2kR7enVDRwYTAMH/Ad+5izpm6YLmaU/7cvE=;
        b=jbcElMYfBdVkbgDqgaCVDVLVFEMfTlU60n4GI1JNcBwPP9aCT3ITXSSnZKB5NgYZie
         2kkkk2sw4QZsBAe5mQOf1+SYGrezyfLXbkjxNfhNuTC/olywg6dqX5sUsK//EK20p5mi
         fZMlQ+rXEy7SqrG9wQfSzV3MRQM+qrUL0x014DRLFDcGuyPn1IgnPSvvjiLEHj9KFLoO
         qS8StDDJeLtrBKySbJcE0aSjwxstTTfeybiaqwUvFbulhVJJelN+z178zR6SdkooYisd
         9BPpwBL0T22DEzD7rmx2qn7mSCD6EEx1/cH4kGciIAUQQu1cAjqAso4EzsM+Twp6IcKr
         X3qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789459405; x=1790064205;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kcapaBho2kR7enVDRwYTAMH/Ad+5izpm6YLmaU/7cvE=;
        b=YhSiWDqLDJ+a0uSIuAd1AXN/hpheC5sCBEm21TnDN+rA5AJW5BmkkTJN4uoPOzhEni
         kncMP6qpDzH9fA8uK1NXCIEoyCSWDQlr9I7uYTdRmc6g5guyC0pw7lz+fvqKsZ3Na41l
         Lm8QcOsLtirAiOSyTj1LCmfsBHILDMdI9cqON6WqzU+c8tMdSOqzWrsFbXige2Lda/QR
         2KJpTpB3Hb0AhZKCrwEVCXIxXz/NaA8r4KzNP7y8NpG1tkkc6Avs1k7n7iF7yJKJiExi
         OylXF6doorFJTe2Ot3GPQgB9nt0GPFTjNhlehOepe/I7kgJUofOKAV2CG13xFRrabnpV
         2qiA==
X-Forwarded-Encrypted: i=1; AKwUvBxLnq0M9WXuiuGh2A2cPpxzdwg+52UocVj6ZBiqPRrIjqO2fEbmfpLQejQ6eN7SNMKyxkhTSsPo2g==@kvack.org
X-Gm-Message-State: AFuF++kTYzm0NWAzAQLfKtrbqw4+R9b8haUy8bNUY5cPq47tfdtt0/0j
	2A87BpzpfLdCYUkYXJOzTdwq7lOlrqXkCk6AnVpNS/ldyW8gD8ogqfr1
X-Gm-Gg: AYBFou0EZbyrxBuLur3GgJfDjxOq+WuLhcOvJA8BpS/raLTZMezSgkB6i53eSQvJbkw
	VJYxhL6g2OqKOYuZ3Ra+Iu++mMvC59X/SfZZyuPxhL0WOf5K17BUVKo1o/ywODpQSk7Il6B60NO
	UHw8Q6O0MqveKE6iiCV3TonvQfrHgVS8MNvHOOFpX8wWJeIX1t5oYKqqcufaLmqKBsptCRz4Usc
	NuxZZ7+MikXuOUoiSoX9GQCL+LaxUdjwfkBnKrfzTldB1ANwkJpUGGvunxbhP47h8xtSmn9ESAN
	l9Vg2yirG8LxWnrAXUPo6mqPRh0RCRBiruSiNeM5GymXhDIfBuvWFwKFEBmHf4WWwuG1f4/9Qmq
	fdVrXUufwOh1M9IgN6GYNbnSgSO411Jy/OMjpAKHQ0W6s69CkgIinKcXLszXhApvpro3BUtbJwR
	nB2yOec5S9s9tho0E8twBJ7wkpecX5D9cRhEGAWzNYgZ0OHlpwK1L+48o5cxSWjKgfDvO1AiWrp
	K0SQyn4qjvapSg=
X-Received: by 2002:a05:600c:19ca:b0:49c:fc6c:bdfa with SMTP id 5b1f17b1804b1-49e7a66aa96mr72885625e9.17.1789459405211;
        Tue, 15 Sep 2026 01:03:25 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b4e:8500:290c:210b:1c76:5710])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb35c071sm33764675f8f.33.2026.09.15.01.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 01:03:24 -0700 (PDT)
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
Subject: [PATCH bpf-next v7 0/5] bpf: Add user memory access kfuncs for mm_struct
Date: Tue, 15 Sep 2026 11:02:50 +0300
Message-ID: <20260915080255.48929-1-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0C67840006
X-Stat-Signature: fsh4zii9nthmch4mn5n7u8ifw6r4iukt
X-Rspam-User: 
X-HE-Tag: 1789459406-169470
X-HE-Meta: U2FsdGVkX1+x5bqPkJsNtJdim7KzojPpWqlBgaFRyLlHX+PoZO+Bj4JpydvfCeSGAL8DKAjsdl8t67TmXTkuyKysEhhIqTwhJddAc38Sf9gbuQZq74pRfpNWRd3MVBGVDIJ0d+ly2HHwcs7lgC115HXcu39UK1p61O4F20TwdH4i1mdWm0XMMXUwjG3YUNq0EGPXt2HzXg7qUoBTlQ4riOMrzgRZ7I3j+8Gu2HmBl0G2cDVdDLLn205IZSYXUcH6Eqa1J1K2ORDX4egFBG2IjidCb1TQav5p5V/DMksak8VLBiepjtwH07ARCjbF5qJcggzbMeyxeIqy4VrVqcObPd16qCJE2FtsLPKLLX/j2D1ysf08oNqlP/9/b8kYzeNFFqXXdSEGGkgF6gKUB6y7yt77w4mDOBn2hPIQnMqdN2z4TuXteGzGqfeOY62bBDJGScgMnK9l/oHVl4Nsrr9DUh4LNzXRt2l9R3qAaIuOYARBwott/Eh1MTRQ5scE+JHAn8ZyvhOIC2ohNoDekjcRZJSxQ80aaGEMgJLni7zBP/YTAQcLV5ZTiBxKhccRh2BFVQZVi6i7z4SQcZloY6J2b0YyUGxeqFGPdjvkG6iBP6Ot5rk1pKXtztt1hxADNX9GPwHfp0pt9vU0Nb5HrrXX214QhOO5mlArO6wIXqh9Nh8TxWTovlOKHpWMPHHFqNDZ5vC0sg84NPmTFQvuPvqvYtCqWGadFRxKcnM/9oSWAoUPlWj1YZC4KWVRS8g2FOSPVElHAXNbLocOtlEKr1wA1s6+1F6QD3rmIhUy6SwmdJR2AQEGlhFaTsmrEXP4X0yXjNgAkzLj2Gy1glMxUELC19gJZqvGeZO7BK/w0p8oaT1FUnPpgBW7wWKiyTBAyM+WWZGoIYf4XKHtbgC2oikSN38MwbvL7scV/KVLK8tR5bsQXpzmKQ+ogW9gwr7YA1HhOspI4ibZ+uDWOhDNmA2
 XctyoUfF
 wF7tbw94Le/TlrZ3eWxTSMWyx3LzllprnfvZ6bt3uR+hMCnQZ3qtWR9Dc8Hse+lzaNp/cli0Q0ZcRBtr6HEc29BIeEko89dyAiu2VWY/m52TS5m6IRKdBcX2NZUr32kz+hkmXNNK05k15K8qTsNxB0oTIOg7ZL+lbh1SOQc1a4Zpt7enV95I8nfN8fXM+ikF7s7JQGNc3jQHdAg6NCY3Tj2BWzHNSJ2ig3b8bHfnB3HzPG7R1PggiPslr0zGjY8EJpRLMp50fySzjblBJGlUr/i3yaXFE0dOZkdrQT6AjB67YaJUDPAG+D25TdWu+TdrVUONTcAKMK/DuDpT/rouugzLtNvtC/sOUpoOeUcHjVrqDt0/Mcd42YONc8Izu6GqM1tQxBkjIt41ntjyLm8EXVuvsdNhv42HL6WXcxjoRVNoFUFatfIfrtlA+DQQJBRBbrcKmwfub6beZwd3gOGsKcYczZ5Sv7DxLrjj1QbFsSKU3izNZgo+5YI+ZnBtVcdALu8oK3RYn6j+4aFNpQXzCbzGmx0wliv9QEj8AQov4LqMBssg9kKi49Xdje//738zpuK7J
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
 mm/memory.c                                   |  41 +-----
 mm/nommu.c                                    |  41 +-----
 mm/util.c                                     |  62 +++++++++
 .../bpf/prog_tests/copy_from_user_bprm.c      |  72 ++++++++++
 .../selftests/bpf/progs/copy_from_user_bprm.c | 122 ++++++++++++++++
 tools/testing/selftests/bpf/progs/lsm.c       |   5 +-
 11 files changed, 399 insertions(+), 97 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
 create mode 100644 tools/testing/selftests/bpf/progs/copy_from_user_bprm.c


base-commit: 5ef40d69b38a93bc9951dadb1a15c85c597e1a40
-- 
2.55.0


