Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 850FA606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 19:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UMKSzXcq
Received: by kanga.kvack.org (Postfix)
	id 959DE6B0777; Wed, 21 Oct 2026 15:58:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90B6D6B0778; Wed, 21 Oct 2026 15:58:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 821486B0779; Wed, 21 Oct 2026 15:58:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 59B4B6B0777
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:58:15 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7EF331C1710
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:58:14 +0000 (UTC)
X-FDA: 85347694908.06.1ED4E15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id DF75BA0003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:58:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UMKSzXcq;
	spf=pass (imf15.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792612693;
	b=fIt/zPH6pudgFmHyLa6kOktxxGGnBG/zF1fQ429FV/lOAVNHtzertUT7Ji766iVsoXlY0Q
	3Q7+o7Wi4ViI2dGOZO/TBXXqBGN2XGDnyM+kzfAQC95obdbF51lAIQVQvzITLxEiZuCgXz
	NOABPuYBlh5LFOvS2mgkJcfskIJKUno=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UMKSzXcq;
	spf=pass (imf15.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792612693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VHWY1315vqdREoDmUpz7R9wTUQOFY+NZIx/UnsphZXk=;
	b=LB7Z+rX41gF2cuTeniXIIqjsx+fULvOIU/tUWflRW5HV8zpgx72I+An3zvP4vADepjyJiy
	Xih7h0d083RqOMlO4loUV04R/ZkS4nF9U+92BSLxlcHmDotYQh62i/lbJw1Y/n6wELgRKD
	Q93l0krPuR7i0s99jwlOHkFNPC5hMLg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 66C3B4348D;
	Wed, 21 Oct 2026 19:58:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651741F000C1;
	Wed, 21 Oct 2026 19:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792612691;
	bh=VHWY1315vqdREoDmUpz7R9wTUQOFY+NZIx/UnsphZXk=;
	h=From:To:Cc:Subject:Date;
	b=UMKSzXcqrpdX3KUaL+oVrhM8PIkOq+TZih80FXRLmP3EzNP4s/u1wd1gP+Tp7FxnI
	 GyDRqyoKhkh7th3vvB29KA9hJ9elb7oVD2yZjvhLlcqz/iYMOAw611BPPWcLAo4ZV4
	 ZQCskznV64SYCjk3gDpMgEbzMbe45U8ZFxITLCvKhXm9EIBUthhA6s/coxztugHFTt
	 qIIUmS/OFnCku9uKkd1RZ+XtBIO3UbBqJ8YCYV6K46bOrLSfXUH5PRLv22bGdjapfk
	 WZNhmStMryK7wQJO9lrMpwaNt6/7iKctbKJmNiZ/ZIp0wTnDJrdD7O6EBeAQ1dIN8I
	 WF1+EV9KmVAfQ==
From: Jiri Olsa <jolsa@kernel.org>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Cc: bpf@vger.kernel.org,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kselftest@vger.kernel.org,
	Shuah Khan <shuah@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>
Subject: [RFC bpf-next 0/9] bpf: Add support to allocate user page
Date: Wed, 21 Oct 2026 21:57:49 +0200
Message-ID: <20261021195759.119421-1-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: DF75BA0003
X-Stat-Signature: ycpxsgb3g7awryu57or4jbu1okskgoxh
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792612692-442972
X-HE-Meta: U2FsdGVkX18Dl3/zWh4i1Wd5A9LlUwlFd8usjPxHle/yLx2Eo7JxrHxK9rbivgM73ioW4nMuTmdZb36I4ExUNMT76mFL7OhYMwEvV9E1PqpYAXOKLl/xCYPi+phgB8A6ZuZC4f6PqIGEQwyZS6/kkyN+PiSd5ap58yEzpK9Fd1DcTmHq7Li8e50AVEYnDpJYKQbcsRc0CXTYFo4uxN0xDFfoDEETbVuJmbuHHknghEKMNU5LDDCOmBVAhjXnr5+hgxG4vwH8+yD1q5RX+IsIPT6H+yC6IjlkVr8LV9gsXCwYBlrczqywmdPpjOZD88L5eaASvhrByigRb3OtPQB/5HtgvDavZlScMVIxF0ivt+o9FGTWkH3sFhaSP/K4RNEhPrj9aQbrjFfwWtZ4BIjEAHroO8gc8xVVTkFHA8B1RC3gpFchl+Bmi15WUUgixG71uZgs1mN8cDc4sXW6nYks0lvVoxRByhUzCstyacd9581FU87K/KHI+1ixLHbnBsOfnZuTCCfuu4dLOWSsunxJ/wLXYidwLAm4gRsRSaZeH3aPeOE2B3csdyyR2l4FON7WPenB98jxXvj9Sm/SmLe7NB84YB3cyvwVO8anDwRq2siZljtPljnwQw7RPIxxnxVTnREkCP4PAmxJcS+K89Um3b2TMDwWkl81fG4mdtPU5surtJzBiapX6I2r5aQfcFgXGk7mfaoJ/p8HgX+BQuJfT+/TWZ3wCJTVCtMM5CIpcpFb+8mDFrivqLBoiTMYVsruZX6opa+PLaEBMXMmaHJXJjATbvwShLW4oX9m7wApZk6WwcPTKZ3nPgLrzGPShJUiSWJkXRjq/wa23ksu9TcpjSmGP6UsMgSQ8WU6/SV8LMP7JF+K2ymK8593aEb4NzhysmMHqSsFyfW9fyNrbdpTZQVyGRPrTos07Lg63PEgGj6uXD3a29t+WJyo2Mpdt0qASwkJtTmJnIZBq469fHF
 euv6jmhE
 kU0XREyTO+sYh4OHkgYQc1Wphs1aEtgUySUiBkDJHyswj7/1jZ03lbFOAAR6uGl70opTB0L/65wdjit1B99APpjPkuKsHKfNXnko8J41o58T+rue2QUBdDOvjmWi+hVzdbPQ6UVaKwwoyHHGl/V1pcxlMk5JuaI3ODwYtjRzgNeNUq4IKGC0I19V9jVa3jYurYpVOjZ2kWs5UKyJ9kGvAV4zzCkIJA6yNRyvzj1RzyDbw8fNkYxeDJf5ly8JhSXRZVOuL9Aa8oQ9ESB5hhgdwV5CP6ht2UiBRwG1BdPZbNkOICG/FRVhena2wPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

hi,
we have few use cases where having the ability to allocate normal
or executable user space memory would help (like to replace function
in live process or change environment variables)

They also need writes to user memory to handle page faults, while
the existing bpf_probe_write_user() helper disables faults during
the copy.

This patchset adds the following kfuncs for sleepable uprobe programs:

  - long bpf_user_page_alloc(unsigned long nr_pages)
    allocate lazy anonymous pages in the current process

  - int bpf_user_page_exec(unsigned long addr)
    make a page readable and executable, provided it was allocated by
    bpf_user_page_alloc()

  - int bpf_probe_write_user_faultable(void __user *unsafe_dst__ign,
                                     const void *src__srcptr, u32 src__sz)
    copy data to user memory while allowing page faults to resolve the
    destination mapping.


I'm not sure it's the best way how to do this, hence the RFC post.

thanks for comments,
jirka


---
Jiri Olsa (9):
      bpf: Add __srcptr kfunc argument suffix
      bpf: Add uprobe faultable user copy kfunc
      mm: Expose locked mprotect operation
      bpf: Add kfuncs to allocate and seal user pages
      selftests/bpf: Add __srcptr kfunc arguments test
      selftests/bpf: Add user page allocation test
      selftests/bpf: Add uprobe user page exec test
      selftests/bpf: Add faultable user page writes test
      selftests/bpf: Add user page failures test

 Documentation/bpf/kfuncs.rst                               |  23 ++++
 include/linux/mm.h                                         |   3 +
 kernel/bpf/helpers.c                                       | 178 +++++++++++++++++++++++++++
 kernel/bpf/verifier.c                                      |  18 ++-
 mm/mprotect.c                                              |  20 ++-
 tools/testing/selftests/bpf/prog_tests/kfunc_call.c        |   2 +
 tools/testing/selftests/bpf/prog_tests/user_page.c         | 346 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/testing/selftests/bpf/progs/kfunc_call_fail.c        |  10 ++
 tools/testing/selftests/bpf/progs/kfunc_call_test.c        |  12 ++
 tools/testing/selftests/bpf/progs/user_page.c              |  61 +++++++++
 tools/testing/selftests/bpf/test_kmods/bpf_testmod.c       |   5 +
 tools/testing/selftests/bpf/test_kmods/bpf_testmod_kfunc.h |   1 +
 12 files changed, 672 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/user_page.c
 create mode 100644 tools/testing/selftests/bpf/progs/user_page.c

