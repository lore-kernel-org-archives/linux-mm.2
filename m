Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B224606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 21:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mraMajQh
Received: by kanga.kvack.org (Postfix)
	id 49B556B05B1; Thu, 29 Oct 2026 17:26:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44C266B05B2; Thu, 29 Oct 2026 17:26:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 362C76B05B3; Thu, 29 Oct 2026 17:26:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 095FF6B05B1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:25:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 79B85804E0
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:25:59 +0000 (UTC)
X-FDA: 85376946438.21.13B031F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id EBCC940003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:25:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mraMajQh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793309158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DP062HOdIxmMsfdf5fqGA4zyk89BHd1fOXQS/Uon77o=;
	b=orB+918l21HPSRPqDgSFENs9kHBmJABDhvTxMqGS56GYaObJkuZCpHtu6aUOO2+7HjhH6k
	3sFMKoF/fJ3lxECEhwH7X768VqSr8+IDmJYyqI0U9NhtMiLIWm9J7pK0HQ0eJmd6w+VH4l
	H6zBKDRbPZWtJcMOUg4oN0uLUEBRIyc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mraMajQh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793309158;
	b=prRYJcMdSzgPUcLpmD27VUiw1sbU8bOgGa+YmwLRFJVm4EaVCfSES9s/KejPFipBBqGpli
	2nqcy7z82kJ0N5eBmkDryKUEIwkf/BVQML8NkdMFxjMFRcKdPuq+qIaG0H9qasl1twvKFu
	N6moDjF/fXaZ53B0NTUdSpB/iR5aqWQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2CD984120D;
	Thu, 29 Oct 2026 21:25:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593831F01816;
	Thu, 29 Oct 2026 21:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793309157;
	bh=DP062HOdIxmMsfdf5fqGA4zyk89BHd1fOXQS/Uon77o=;
	h=From:To:Cc:Subject:Date;
	b=mraMajQh31xSueAwZmt+bWATDUmUf2XsfHW7HUlpUu9JeVkT70k/Es/1kwdlmPugg
	 mo+lV7jAf3b2gmO0cdiSArsRziXgjUkd487iQ/e1obVwXesfo2MMgOSmLDqYikxesw
	 pAarsg4m6WRwDB6ijnb8juvdZxrMpYzKIQnia6Bs1odnHD5AmYFwiT6iaw1zFdzQmA
	 D8q3Nmp/TJZFrb5IjPWKsf3ywzXt0KZ3yLs44g8qxXEZUcRIFI6wR2sf8imrnn0PaZ
	 GpBeK994E0Y40GAakFJ8A0IIEA9SsM6yMQqz0o1D8RI90olRbauR+fPKoh0Q14h37q
	 xnvg694Sp+WXw==
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
Subject: [PATCH bpf-next 0/8] bpf: Add user memory kfuncs
Date: Thu, 29 Oct 2026 22:25:43 +0100
Message-ID: <20261029212551.56964-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EBCC940003
X-Stat-Signature: 3919abzyhn5yy1bkj8tutpk4mgh7z6a4
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793309157-975655
X-HE-Meta: U2FsdGVkX1/tgo6JMiRpvuVXzM/P+yDsbhNhyzRvoyisNl5sI0vO4nQCGcw5x2DxLHHztX6dwcqVmtvBIC9glnqRoMOahIfCDbpgqbxgQDGxD7rq7CGJTAIxln/K3hp0Hw6+pNFEuER080txVHh6zsKimqWMSZu+HjFPEcq4mUwCAsfH9i1Kxsy7lzZtV4FmXtDHtJ5kB1Cml092BtfG8AFCAfLHr5CLlFMBscsFsPze9qkeliaoLDOQRlRFJlql/CgO8jgVBDpc4trpgF/jT6+Ii3cHsz84PzcUM5fyddcSLY7zRJe22v6cS/OBzNxr2ByvsmHec0qQGBYw/Gorx+VPyFC206PYTfCcOxwbFYOfbywNr8ChsBEHgdLHZhvdDBxrDn6r4Hu+4qtsuskKliXXycLKW6FYEsqlx3SrC8jsEg9PtyTuqyBUF27x7AXRIE+z3dokDRhqZhbuO/HV2r1RbB72hsbwbDFrV2l5HNvZkn+DP/00Hh6KorM0XDr1LXzkrLDBNAYltOKQjL5S14XReK8VS88yvCHzXTWjR3U4sOGD6wD0+BYtt2WijToKXqeTgSdKpi3M/RCKe0J97DoV35RIBRkJTsSIKGG79/MyefRNpsH46zLneGHDY8uwPmJ+EhWbfRS/EUvWc89fsd2KP4ROVV+tbDxWkmthOQ5+StDXZtg67Q8y9BE0Ivr8N2xRKpXmJmjxe+B1fPlar+Yg8CeT6TYShZVzpF8kCEjd9jBRn+L969gfcJepPdyt/ALsb+Sjg69w+FJaiMagsJz2qRk5n8fXzzugfvTBAjRKeybzsT+Azq2Iv8ib78/HoXMCcVNKOfTOGg1RPisULqDt2RxqhxQGdBLj1o8YbRSHwLbgGzAvBPStKrGFUZKQPUGj2v45u/XW1JhtaJCFaxUw1KclOxCMZsGbDAs40YVePLNOQ1/zFPKEJ4UKQSJLKPEOq8WpS9uBK3GFvPS
 Zr64ZU8T
 s6aC5jf1jC4/b/62fPTlboUWe1BFapxHHstwroKPxh4h606JMTSdIebMLj29lGWjSXiBO1fLyHYOpotY2JaiEArOT/QtmuZbzQ8iXK9tfl5vIXxOI2gZRDgaiBqEhHIyr8agSORUpFbuWDwDAbTjQl5suCA8Ye/NBuWqjz/c1BIaLTJowiN1hOJOsv8oE4xRCT9YM24ETK6dKhTOyx5+TPGnwJWo95pxOdJp9gT9ZVH0xwFoQivEHIax3d0X8pTDZvToyTbDUX5LDUsVrx0oJqy9h9ShtU2kHbWokZeQbrNDMiUr5fBty7fRcpx0A4iqF5whmrSkbGj6GFtRW97TBji4dbA==
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

v1 changes:
- follow vm_mmap/vm_munmap design suggested by Alexei
- allow user space write only to current process, because we don't
  have remote task use case and it simplifies security checks
- many changes in tests

thanks,
jirka


---
Jiri Olsa (8):
      bpf: Add __srcptr kfunc argument suffix
      bpf: Add user memory kfuncs
      selftests/bpf: Add get_procmap_info helper
      selftests/bpf: Test __srcptr kfunc arguments
      selftests/bpf: Test user memory mmap kfuncs
      selftests/bpf: Test user memory page exec
      selftests/bpf: Test bpf_copy_to_user kfunc
      selftests/bpf: Test user memory kfunc errors

 Documentation/bpf/kfuncs.rst                               |  41 +++++++
 kernel/bpf/helpers.c                                       | 102 ++++++++++++++++
 kernel/bpf/syscall.c                                       |  10 +-
 kernel/bpf/verifier.c                                      |  20 +++-
 tools/testing/selftests/bpf/prog_tests/kfunc_call.c        |   2 +
 tools/testing/selftests/bpf/prog_tests/user_mem.c          | 338 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/kfunc_call_fail.c        |  10 ++
 tools/testing/selftests/bpf/progs/kfunc_call_test.c        |  14 +++
 tools/testing/selftests/bpf/progs/user_mem.c               | 111 +++++++++++++++++
 tools/testing/selftests/bpf/test_kmods/bpf_testmod.c       |  10 ++
 tools/testing/selftests/bpf/test_kmods/bpf_testmod_kfunc.h |   2 +
 tools/testing/selftests/bpf/trace_helpers.c                |  38 +++++-
 tools/testing/selftests/bpf/trace_helpers.h                |   1 +
 13 files changed, 686 insertions(+), 13 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/user_mem.c
 create mode 100644 tools/testing/selftests/bpf/progs/user_mem.c

