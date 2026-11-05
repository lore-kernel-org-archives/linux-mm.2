Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45BFE606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VxHmbG/j
Received: by kanga.kvack.org (Postfix)
	id 656B36B05B1; Thu,  5 Nov 2026 05:23:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DDF66B05B2; Thu,  5 Nov 2026 05:23:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A96C6B05B3; Thu,  5 Nov 2026 05:23:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 194386B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:23:53 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27BB9C096A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:23:51 +0000 (UTC)
X-FDA: 85400679462.21.304BD18
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9676B20002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:23:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VxHmbG/j";
	spf=pass (imf03.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793874229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7vPiI7uyQG5/hNrt1SoYsN5v0SSwiCd4tGYudI5VrdI=;
	b=7BGEHdMGjJTViDZEGbFDds6FJnFlpWrg0fQzKIQ9wUyphBC0D5Yi7SmptsQv/+ermqgJlQ
	VJdkpFt991V2gNF6Ijz7hp/59/VVeN/NxIBA+DDPAQDAZ2mH2IQjezUFT0q9XhT+QxfK0N
	uWCW+WuxMre0hElA7KGcDxGegF21BP0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793874229;
	b=hf512vIvHXxo3h3iMIPcWSE0ZPAGDTlf6zWQjxCletGJUg312sqy4MJ2PhoSm2a2AfI9s8
	/Gpg7ydbmoVJLZaRxqoX8tF3M5UOLZKeff9/WFQoVfOq6xHBbng988h3B6e4y7+FYHBFnn
	9OH7AXhrXqXXuv4j1M8uKFIqwuQsg+k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VxHmbG/j";
	spf=pass (imf03.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1AB10601DE;
	Thu,  5 Nov 2026 10:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FC291F000C1;
	Thu,  5 Nov 2026 10:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793874228;
	bh=7vPiI7uyQG5/hNrt1SoYsN5v0SSwiCd4tGYudI5VrdI=;
	h=From:To:Cc:Subject:Date;
	b=VxHmbG/jrt+mvpz9g0I9AmxMQqudYtqta93/nPqhZozHrDcZ2TPGeb2/OH1uXp3Hz
	 L6M7yHDEqWYAcXsCWwzUXGcqWQSTq74jUthaoWgvzDQ0WiK58Sf5ie67jVIIG6HGC+
	 Cig10k/kPuAofy4kW2626hNI2iW9m2dTOaocyx1ElFts3sHaQ/Vz1ctk5l2WTJiqgk
	 c3zWsbFtGufTLVsIT//mzDY7Kz2OQZj6zXcSIqcsjwzJShjCp24otbpO7HlceZg39c
	 mcvaI+7JRub8f9LqKatCEg2Zb27TzJpC1EDe/xBsvDr7p4wu57n4/TiZjU/IsHLA+W
	 HaH5qgPU2q6YA==
From: Jiri Olsa <jolsa@kernel.org>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Federico Di Pierro <nierro92@gmail.com>
Subject: [PATCHv3 bpf-next 0/8] bpf: Add user memory kfuncs
Date: Thu,  5 Nov 2026 11:23:34 +0100
Message-ID: <20261105102343.311331-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: qbrgizfbudzzkpwxznmp91ok5ugf8rx7
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9676B20002
X-Rspam-User: 
X-HE-Tag: 1793874229-413156
X-HE-Meta: U2FsdGVkX1/4pbO8WrmpZfSO4F3yjx/WWz9Ls4vpGZ008pAHe59XcTJkyVB5FGIJR1FI0FeY12let9uPo0Fsxc1NeXAdYKYaUidvgxv3EUgPbzSg2YsLcBFVGteJTTQqJsabYKSIuWZgw90bYj6WXWrumETaTsO/p37sPS6t95vWShH89xnFtTIvXasmkB6f0oXhwwvK/flMRNH1MwFttwCkUuLSxeNRbvW+8sZ+4GkmU/BI/9bHBfwo+P0UgRi9SS3/OVYE09BpXHpda39RG+QWxlATkBQpfXgW5abHMf2enPOBYMTdbWUCHskpkNSvDJ4u9+Dalexzf/x4V+mCGVFhL7ICzIOLINmHE5lhS+9QETSwAm5M3Eo3CTg5Qrfp7Avy7ME4JCdTeCf5yvwJW5zLb2lAiv6XUkHSKuNg9oGwcgXfj8sa4F+uoLPX2EsD4tEiKKodZcCdqGRWbyaz+e9uRbeepsz13QCNkVOyxbaelPZ36vM1hOAT4/AT6pdWEolobBk2PppD+UGMRS+xZczR6xFkzmi6+zWFTT+RsV23eyrrxmvj2pmx68QoQ7TqojRc8RTnWISwj0sNsRnYJYGkWNyRaCx1r+Tv1Yh+YsieGOq3D8LEqyg9n9Lh6jU1tt5+7Wk1SjIxXj9mg3JjQ9kAKphpfOXiK5U16SoQHA5uTflBgbTVQIx29t6EL4b4IXUNONQ54ZvkW3qjMeXlQHNjwCf5GeNO56HsL+HB7k/N5zMnkxFZgCuVM2oy+0A8Hns9w3shZXsGo4EALicaH/QbpSH9xQCxUBcO3WzTzqEHlcR2dMMFQaQeslty41PhhWllofLVRDpd8By9xviT7ciXS+nZi3FN7LZmThmM3kGa9s4cHSfVddgjgpVMKxKqvCbOXAA0g6cZh6rYc2f9vyuNnnC+qQ8/KTpZTBJDk46GvVOLL/YZ3ZYeq/TXjaEfCnuBijoHFbXR8DR3+Dw
 xkPL7ymH
 u0lQi8A2+b+g976t1ws6G6tBd9cftudBFLYueJjqo4Ch1th3ARM2jWhoW9Hhe9hloL1rR9lH02Rr15hJkY30mYiCJlkh7zYFQzXsU8dQiD9Ibxxj9B1EqNtJyyr8alHXbruj1eKgA7XtB6eLyJinupjdmnwgW2mxfVfQL4JsLCmQ0thPrg1opDweJEfEIEiec0ZJdQgxYXjqaJey2GBJNar9QSZ9Mpdg88y0KIqvLD6EhsM70w+th2hVkr/nS47r6AUJytUyMV0XPQxfjlH0/bTWpaNGssf3MSDaklfHhbYrGuBEQpJqRGCERyoOPk0c7uFfI+nyBzREyHPQXEtOJTFDQ4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

hi,
BPF programs have no supported interface for creating or removing private
anonymous mappings in the current task. This limits use cases that need normal
or executable memory in a live process, such as replacing a function or
changing environment variables.

Although bpf_probe_write_user() can write to user memory, it disables page
faults during the copy and therefore cannot handle memory that needs to be
faulted in.

This series adds three sleepable kfuncs for those operations:

  - bpf_user_anon_mmap(len, prot) creates a private anonymous mapping in the
    current task and returns its address. The requested protections can include
    execute permission.

  - bpf_copy_to_user(dst, src, len, flags) copies data into the current task’s
    address space, handles page faults, and reports copy errors.

  - bpf_user_munmap(addr, len) removes a mapping.

Together, the kfuncs provide a small interface for allocating, populating,
and removing memory:

  addr = bpf_user_anon_mmap(len, prot);
  ret = bpf_copy_to_user((void *)addr, src, len, flags);
  bpf_user_munmap(addr, len);

This interface lets a BPF program perform the operations in the current task’s
address space without changing bpf_probe_write_user()’s fault behavior or
introducing a separate mapping abstraction.

thanks,
jirka


rfc: https://lore.kernel.org/bpf/20261021195759.119421-1-jolsa@kernel.org/
v1:  https://lore.kernel.org/bpf/20261029212551.56964-1-jolsa@kernel.org/
v2:  https://lore.kernel.org/bpf/20261103075916.100050-1-jolsa@kernel.org/

v3 changes:
- use Alexei's change for checking the const [Aleexi]
- drop ia32 support/hack for vm_mmap [Alexei]
- remove leftover srcptr suffix in kfunc declaration
- drop extra verifier test for non-sleepable kprobe

v2 changes:
- infer read-only from constness of a pointer instead of srcptr
  argument suffix [Andrii]
- rename bpf_user_mmap to bpf_user_anon_mmap [Andrii]
- use arch_validate_prot to validate prot argument in mmap
- add the x86 compat mmap workaround
- assorted small changes

v1 changes:
- follow vm_mmap/vm_munmap design suggested by Alexei
- allow user space write only to current process, because we don't
  have remote task use case and it simplifies security checks
- many changes in tests

---
Jiri Olsa (8):
      bpf: Honor const on generic kfunc memory arguments
      bpf: Add user memory kfuncs
      selftests/bpf: Add get_procmap_info helper
      selftests/bpf: Test const kfunc memory arguments
      selftests/bpf: Test user memory mmap kfuncs
      selftests/bpf: Test user memory page exec
      selftests/bpf: Test bpf_copy_to_user kfunc
      selftests/bpf: Test user memory kfunc errors

 Documentation/bpf/kfuncs.rst                               |  21 ++++
 kernel/bpf/helpers.c                                       | 107 ++++++++++++++++
 kernel/bpf/syscall.c                                       |  10 +-
 kernel/bpf/verifier.c                                      |  24 +++-
 tools/testing/selftests/bpf/prog_tests/kfunc_call.c        |   2 +
 tools/testing/selftests/bpf/prog_tests/user_mem.c          | 349 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/kfunc_call_fail.c        |  10 ++
 tools/testing/selftests/bpf/progs/kfunc_call_test.c        |  14 +++
 tools/testing/selftests/bpf/progs/user_mem.c               | 101 +++++++++++++++
 tools/testing/selftests/bpf/test_kmods/bpf_testmod.c       |  10 ++
 tools/testing/selftests/bpf/test_kmods/bpf_testmod_kfunc.h |   2 +
 tools/testing/selftests/bpf/trace_helpers.c                |  38 +++++-
 tools/testing/selftests/bpf/trace_helpers.h                |   1 +
 13 files changed, 676 insertions(+), 13 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/user_mem.c
 create mode 100644 tools/testing/selftests/bpf/progs/user_mem.c

