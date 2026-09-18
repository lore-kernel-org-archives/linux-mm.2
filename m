Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50995C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:18:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C4C26B008C; Fri, 18 Sep 2026 09:18:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 275196B0092; Fri, 18 Sep 2026 09:18:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 164556B0093; Fri, 18 Sep 2026 09:18:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E04FE6B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:18:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5C546A5D37
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:18:21 +0000 (UTC)
X-FDA: 85226936802.12.31F039C
Received: from mail-wr2-f41.google.com (mail-wr2-f41.google.com [74.125.225.105])
	by imf11.hostedemail.com (Postfix) with ESMTP id 99BE040004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:18:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IT6asUTG;
	spf=pass (imf11.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.105 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789737499;
	b=8QzdF+fWbLLFi4X3A2GRRRu5sLMLo64wDOUFwotzJWJEd3sKv59+wxURixNSV0EAF9j9+C
	qjm9OeI9ntWu7J2YtwY78NN8XNyKxIQYQzoEdmw0yVV/yvUEBb/FuI/KkgkahxzE1itVAo
	BW5b4b1vbKUuZhNjiOUJJFL38szqies=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IT6asUTG;
	spf=pass (imf11.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.105 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789737499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ASNDhQj6stB9jN8HLd03JQLyI4Y3skTrr0meT4GXR2c=;
	b=0UdvuP+doo2IjlvpWIDjevkm8AMoNZ+vnXfGNzaIKebCAP2rCCOF7CKTWV5t9NLBNhEj7o
	0YgpR2z2xCM87tgLrGcSlqwsfWZ6Zld66rgM43zxqoL6z4b3HpGOMKI0i+LpQC6oYgz+sc
	pufSRXg5BGchuEZpixOpZQixngKW70g=
Received: by mail-wr2-f41.google.com with SMTP id ffacd0b85a97d-4834977ae75so392737f8f.3
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789737498; x=1790342298; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ASNDhQj6stB9jN8HLd03JQLyI4Y3skTrr0meT4GXR2c=;
        b=IT6asUTG6itqxMWztpt+6faVRWkYqJJUpMmR4tH11Ocl8UOc/erS5jJrjLydcis1s1
         qsAYbjoBJHx6O4cWd3ThlbI7kjHxXRhea9gZ36bsJKbagi3aoy9liHnbjnOdgxAqaoBZ
         27JhUKxAia8Yiq4msVFWuQCLkuuGdiy1GNm9mHYtal2AD8gTmj+kYSmZ5onsPy6iDbS+
         PNvirrksBnMDEta+qq1uMZ5/K9iEB5ZFoRYttVVX55ek8Qsk2nZbpN0uns2TQFdEiD+X
         rE7SUyNHMJuLrSqXM9ob17igoEiV5/ijQ0z5YvYmPAbAjKxI3NWBZzEv4UnQd6xfcLc5
         cubw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789737498; x=1790342298;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ASNDhQj6stB9jN8HLd03JQLyI4Y3skTrr0meT4GXR2c=;
        b=KywiAnC+LzUTiERZedpJm0DrnstlK5KaIempiE0wQ/ozHReb00gOvW2dpPwzfPu4rW
         /xtuoY6c9m/8/75TS39XazvrJusaLbLlrNPz9gk1q/RqtrTNgS61U4LrkuSSfJ48vf9n
         WkgXk/yRi0cO5FohpDzOZX45jc9XTAQD0cDylYEMPHnmaqEOAyhb4YBncvmtQ51jyC3q
         foPSRMxHHCcVW0l1C9JjSaEB033QJn+aTXwqm4SHn0HJeAPvtBNz0O1s2NmHJtW3tO7T
         Fv98SPS/Rbf4oNpVHFjzSRuW3K8u383dhlyIEyK4WTiYJq6nWoXIvnH3ATW+ZVmmQOaj
         mtUg==
X-Forwarded-Encrypted: i=1; AKwUvBxb1JbWaW4fJh8zC2XeV8G46smlnRXxMvE/2lc9TxssnwQeSknPBMCY3FDfeMfDPBc9JRXaYaeY4g==@kvack.org
X-Gm-Message-State: AFuF++luNK/IKZ6kKSuTyNOw544/wEBrh2qtYNf+46ZzEKBhrb/dTp56
	gKypzaafmEQTZaQelYL3VMCA79hmpeaPHPDIqSmijDmAvrat7N/djMPA
X-Gm-Gg: AYBFou0PsBkfBDPfHYikSCh05xK1grtCRuo2XtyffQpsbCKj6mwyTSB4FiyjYuy7kmV
	Y5p/sbHFCd5N8N8Zu734rRRr3qZHBO7PLZ0b8m42eZakUv+oypQFHGitMZsgK2e4DfZKogtCceN
	Y92O7ChO7b0Pr0kckn0oqR0JxYJ33B9Il0J5p6UGqG8c2ar5uI463zkvRZP3oYmRBr2padnBW0S
	d6Rb+5ihx2JLhp1x4FiIy5F3Zs2kVg6Zmwra6dk/dka+txrn91iKugCvWGJrRsVACkGEmK/F/9Z
	4yKOWqKcphOas6/fTTjrV8CbDoCfYrzPNBAFqAUUxR6E7Yt0UZLCzFbbUIME814bmabOPa8rH6Q
	448kCPiF/iuXzL7XHi0miPE16YGNtflvVaniFlXh0xDtZQCn6RP59GRo7yBe6Rrz/1iRV9NNMp/
	WLExtsBmEoxDS868BSOdUNQH9zqnNpfAOs2Aplxi7kn3n46MtB66ru3RlEbAvtne8GlOq7/j/+P
	X53if7WMQ8ewXo=
X-Received: by 2002:a05:6000:41f5:b0:487:13f1:47ec with SMTP id ffacd0b85a97d-4871e26e2e1mr7725773f8f.21.1789737497812;
        Fri, 18 Sep 2026 06:18:17 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b4e:8500:290c:210b:1c76:5710])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4871feb5de3sm4424549f8f.1.2026.09.18.06.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 06:18:16 -0700 (PDT)
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
Subject: [PATCH bpf-next v9 0/5] bpf: Add user memory access kfuncs for mm_struct
Date: Fri, 18 Sep 2026 16:17:52 +0300
Message-ID: <20260918131757.42802-1-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 99BE040004
X-Rspam-User: 
X-Stat-Signature: afyc3ct4zkb5t91y4s6mgxy7o8x49otc
X-HE-Tag: 1789737499-37580
X-HE-Meta: U2FsdGVkX1/JY8lDWIyMlfkhUFtiB8arhYrHrjjMHYLfniQKKFSW9SF4HGFCgrEjcsu5y9aKzn+M95b5nH8dkM0ymMLJ6723+c7kNgj1rd0KJUs/kjx6brbh4mJXYcVVVPJWboAvDK+fupp8zcrnWoIAwXmLYIgkUuPR56NMx9VGZ3gCzsc44iykCx+UtQn+eMkepmfhcOKJ0ZtX0NRSqfkGEAsdpcocUNSKPIfewK0mP2qYThjlxgzVUSuqowp+vFNdDNinBhgtCR6YqfclYxjzaA6AMGk6rki6bSYV3hEj3G591Nxw8e3EN87Nrvu+NqGdeWLOLNi7l1rudC3Z1ZZ2TP8hj518Yqx9sVXgDsGKU0X3ZCrgGoTG0G/54rZb3ZFRops1F3nW+Os4yUFfavl70D8q1WwfGg4rIv/pGq14GwZefBzkrt2e+EQ0xcY36hn4N+5Q+x4uKXpf6olMsicby17eQRq0rLUEVvZTvatRiyxAvT3bIIjZN9IowYo7gcmRe8U6biok0o8jyCa9Cb/5mJf9xEqW1rx4QuUUJR2/pPt8lJHBhPgZuOOjacjkqjm0xfFkF+LkXykS09xA8yS5nMbpA7W1/QMfQW9AFnN/TIdlW8EcdBbKLimOD2nK1xK6SmQ7caGo0AM4l8/Z6LAHPXa0QtvRzTiAVLLHjZsOsmXLXdZkyMPclMSF8DJE9okg4qacsWpLZ1OVP7yWBbmFMNtaTGfCl/cr7Z/iKEnl3CGryc12RXIfNKwlkZcBMk9egZe9LEcHJ54mxUhjxVMCzM0am3o/MB7XqiCo1MZ1Av1TWuOCWza1C+0m2k1351Geo+Ab7oJG72fD3wdrXNZwWammgwaH9y8pPLcgw/mJFMf+RzM4I/GLl3wcgbWIWgrkCp3RR8+xnj2dDykdLNHpaPLbXsS+ejkfIxO9Aq3Fr4s41aLpzSY+tpy+vdLF9ezzjSg8TwiwYWdNMSs
 hsGf6l1D
 7iEjVlSsXPH6fgrVCpxAgtcffeE+C/ALZLwU5WSuhOkKg7+05hRnOpnwQF18Rp8Fs/k9uXMjFnA7+Z3lxGPuPpYNYfR23x0rTobFznm9fR/x4C8WgY2tBfxBuk4cNoF8k8yYGeunbdkFyAo6Cn7Bkf1CzlI7M7EcyXcEW39SFyRp1Pt+N+a+cmExtsBY0p8h8ELSP4q4fl6URi/a31+qyq2ArM/aQudckp8vZdQMl57Z3vkfzB6p4nE31BwbE4mKho0tfU4EO4UIE6u+4aBcm4qaOKfbK9xsdRrZSedVB6ImXRjk/XAmyc7mWcuhgfd/12/0Q+goSSEgYgbBXGA3JYybtsMg8srGOmi529pJ9dZQO2Ki5bcFVk92T7pCHltwp6DB1OTkDQQniv1Wmc3qTdG9SGc/x/wMU1VoJ2I0DNooqBkCoaxqTCMOtsBXAVq3/sh1OOv6cy27MWF0iBwIRb90lS5092eFu/pLHkkJ4icPiA7WgWgCmAIZ9HuCNyGat9FjX+wpS6O7W5w6gFmLPGysAtkgylSTXQf2pqnIoXMBCPXpDNfZFw+mYkMkLcP7OZiW2
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

Changes in v9:
- Acquire a reference to mm_struct in bpf_copy_from_user_mm() and
  bpf_copy_from_user_mm_str() to protect against concurrent free 
  operations and prevent a potential Use-After-Free in future use-cases.
- Fix indentation in the remaining mm patches.

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

v8:
https://lore.kernel.org/bpf/20260918091058.297740-1-tasos.papagiannnis@gmail.com/

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
 kernel/bpf/helpers.c                          | 154 ++++++++++++++++--
 kernel/bpf/verifier.c                         |   5 +
 mm/internal.h                                 |   3 +
 mm/memory.c                                   |  43 +----
 mm/nommu.c                                    |  43 +----
 mm/util.c                                     |  60 +++++++
 .../bpf/prog_tests/copy_from_user_bprm.c      |  65 ++++++++
 .../selftests/bpf/progs/copy_from_user_bprm.c |  69 ++++++++
 tools/testing/selftests/bpf/progs/lsm.c       |   5 +-
 11 files changed, 361 insertions(+), 101 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/copy_from_user_bprm.c
 create mode 100644 tools/testing/selftests/bpf/progs/copy_from_user_bprm.c


base-commit: 961b8946acb482b6d7a39c266d623e5f9c4e873f
-- 
2.55.0


