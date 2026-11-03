Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34605606A32F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 07:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bIrJ53fI
Received: by kanga.kvack.org (Postfix)
	id 206706B00EF; Tue,  3 Nov 2026 02:59:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B7C36B05B1; Tue,  3 Nov 2026 02:59:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CD526B05B2; Tue,  3 Nov 2026 02:59:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC6186B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:59:25 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2B7F9140203
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 07:59:24 +0000 (UTC)
X-FDA: 85393057848.28.AC9DBD8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 98DEB140007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 07:59:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bIrJ53fI;
	spf=pass (imf09.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793692762;
	b=7CdTi9kUFG9Q+uoqLxSq+rRDViUEm142uRZpw2f3aqiZof29z4oceAjAOyrjG0CTsR9Axe
	ECGv6qVhHrHTuuhV6ANqiyAoIln1JGUomx9HV7g6lVSz1dyQOoHAnUcvUwvOmQ1KAYGmtL
	1MBs2nk+HxlwJNqWcdSYqUZdTtzXR3E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bIrJ53fI;
	spf=pass (imf09.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793692762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HHd7MlRl5WO91ptnS5JcS/T/erAUMFbgJZKZpyddZqA=;
	b=07cxPiWB/AAJXfHLlMDiYckscMj0jRmE5iuivSUKnrh4fibtS7i6Rk0l2kxIEQKkprXZ6M
	Hf057o9OR/bi9SJJASXGb0geYqJqipLpuNTKOqOxmhBHmrcqnOuV2wm6fZ5xxoOr5kHgdI
	Qpwn1LWLwgUfUdxW3FB8G4Wy4TUPz2I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 76FDB60008;
	Tue,  3 Nov 2026 07:59:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4ED1F00A15;
	Tue,  3 Nov 2026 07:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793692761;
	bh=HHd7MlRl5WO91ptnS5JcS/T/erAUMFbgJZKZpyddZqA=;
	h=From:To:Cc:Subject:Date;
	b=bIrJ53fILafaxb8rQHVqV7qorWHK5MHmDxuYeMzUQADfF6nMawp9Fc03hAk/0+3qO
	 fw1g/Yn11camVugHMC0VIBW59vXDWAU+/zey6abhOQEgaKBsLmOzZFcJLtVh4ll1H0
	 68C9YisbM2rdeUj6Cx6h8hhuAouqA84yoQfo0cCMvqQEEmCXcsV97lWPMXs3aASxZ8
	 3tHBqLD+t9fH0384hUYi3ZGZwGIt5dIdG6axPQtm5ZIlkYu4i8+5uRUcTqpeguyt5D
	 wAiFB8AS6BVqCi6KnWZ7yG5cmk9KMcMs/X0VlpA+HeaTsua0aa+6yrQFNxLv4rchQk
	 d+zB5YlikaP+w==
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
Subject: [PATCHv2 bpf-next 0/8] bpf: Add user memory kfuncs
Date: Tue,  3 Nov 2026 08:59:07 +0100
Message-ID: <20261103075916.100050-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m7yjupo98a8ooezpu95nacdz1ofxh4qd
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 98DEB140007
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793692762-439747
X-HE-Meta: U2FsdGVkX19qolWmwk2LQ8qu888YMCLAThrUL1vFuMg23eE5EZI9Q9Pzi6CvruNyPJ5E9fH3z8mG4qifQajH3txqS+xlRh2O3jGB5gSpZErZVlmosc3Xzne7gbLYd+kJ9R9iNvYBR+UxeN7pW8k8Mm5jMNq9p3+dV1sOShp92EV38JvgsZOaHZiac6gSk1TfINWMaOyNGh11xmE6yRUeisic3BX2MRuuXT7Ud8HxSdSgeOA7pkIiNrvuEfQa3T42tw5kLsA0+WpltR0RuGx8bFTLW0R0TUWsDRK6NUKIemn9tNAeFSajrlJ4tWRr8pZwZyda6RJxGwkDyCllsHHKM947jvqr1ejt5p1MkWThhnxnWguAnsj4L4oDBFAU8FdkwM+7VGa6/vXgXnWpDmojFv5+4fOuT4G5qoUD4Er3H4lcCYV5itDxwYENHt2M/yjuggn84YD3wL9yeiuZ7j54rIYw6cAUTkx7gyhbfECG3blqgCAieEoh5vr/Wrp3nOA1EUNqIi3dtwT/M/DQLFMIhgiQ+AgrakYecxkae24W3VsNcPvD1wrmu/1eSoHaow06P+5VfpZ0Vr5GEVlmmSlN+1G5Y8vZNGJUT4D/VQs75kwwxqlPs9Xo0G8fbO31RfdlGZprfxuPgmt0K0CbCKwa3wnBrac+3IQQpFW9KnnX7T9645wCIL5H4eyc0MXUxzOVdkQKtwjSMzwCG4ELvc6QJpB08fM6J8bgAblbRFc4PYRWN7vRyrGRRUK5PGIESEGzitIRckLL6FVEW3a5E+KJk5e5opBtHDnCOu9xRP9cLxDoBbquoMslFwTC2BIqg0BOSOgns7QUkAGhs7SSk9QpCj1MjyRtD14gehr+mMgBrEF2hxuKKQhc76XP/nctiM9Fx/Qdn0UyHu73RUt9gcYdfWvRRzPzAEYX+fsxPPEBAlL+ZShOiYsq02+r91pQhnA1anVb5+IXAQV0qVu0jo2
 MupdQ8Xe
 HW5eMnKEzUldh+6KNhcXqZhHG0wosX7/MDbuSDf9+RIiAULu7YRV1OhhN/w694zeUe1Nhljtzw9W37+bg8rVbjmOkEhqcspoAffcEIwtvjiRwDD8SpGR0oP3ccgQUsHESAUWjoetbq/ycwZsJo0aA5FU87i5++ibkAEvMXVOodKKOZRtkrGLlFAtoVOkd7TJs6f9QSMkqVGpjm29Hd5kPzSdzsO3QBCyAudEXJylUInF7A5cZb+kN+x7ap4mufRH0+qN3rfLrHxl8wiSwKVc5Ek5wSP3bYvEfcs2I0hd+qo/iTV5d2WeGEnfOtxNwXCxrP9LiIvUHFc0L/j6NmfzFlTzVag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

hi,
we have few use cases where having the ability to allocate normal or
executable user space memory would help (like to replace function in
live process or change environment variables).

We also need writes to user memory to handle page faults, while the
existing bpf_probe_write_user() helper disables faults during the copy.

This series adds sleepable kfuncs for BPF programs to copy data into the
current task’s address space and to create or remove private anonymous
mappings with optional execute permissions.

rfc: https://lore.kernel.org/bpf/20261021195759.119421-1-jolsa@kernel.org/
v1:  https://lore.kernel.org/bpf/20261029212551.56964-1-jolsa@kernel.org/


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

thanks,
jirka

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

 Documentation/bpf/kfuncs.rst                               |  17 +++++
 kernel/bpf/helpers.c                                       | 132 +++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c                                       |  10 +--
 kernel/bpf/verifier.c                                      |  38 +++++++++-
 tools/testing/selftests/bpf/prog_tests/kfunc_call.c        |   2 +
 tools/testing/selftests/bpf/prog_tests/user_mem.c          | 350 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/kfunc_call_fail.c        |  10 +++
 tools/testing/selftests/bpf/progs/kfunc_call_test.c        |  14 ++++
 tools/testing/selftests/bpf/progs/user_mem.c               | 111 ++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/test_kmods/bpf_testmod.c       |  10 +++
 tools/testing/selftests/bpf/test_kmods/bpf_testmod_kfunc.h |   2 +
 tools/testing/selftests/bpf/trace_helpers.c                |  38 ++++++++--
 tools/testing/selftests/bpf/trace_helpers.h                |   1 +
 13 files changed, 722 insertions(+), 13 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/user_mem.c
 create mode 100644 tools/testing/selftests/bpf/progs/user_mem.c

