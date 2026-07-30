Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8111BC55160
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 13:34:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 620546B0088; Thu, 30 Jul 2026 09:34:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D1646B008A; Thu, 30 Jul 2026 09:34:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BFB76B008C; Thu, 30 Jul 2026 09:34:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 261EE6B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:34:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AB9A2160165
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:34:44 +0000 (UTC)
X-FDA: 85045538088.12.4F0E4EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id DBA39100010
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:34:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oeZmocRT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785418483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cTKth7UNQeBwmsZO2B2Pp13WvIQsQKMZ6nrWV73pGKM=;
	b=D4w7QdKKTA9eqJfB4Emz4Le/FsxhMAqSmMJX2OYgHjmb1ngYHk9ozumPIP4oNS9BZxRpkl
	6muT5UNcIx+D6aYRMFwNHu0NVSR6uKHHzSOWZXD7ur5RmMEn0/JdrH6czDTPiySdkznirG
	fUL9Oh0PLxKhlEOksRUwi6Y+vveaCIU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oeZmocRT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785418483;
	b=F8Pmg8hImVT3DZLrY9c5sNJ+qoDjf4Rk4wrsUs1RKIKbrzoRe4F5kWeexUqUQPEKtRznkm
	AIPYxBn2IFU7VH8RELXmx4DerS7rSCZAL+m0pRgUTmK1x45CaEODuoJMsW9o4YPICBHRmK
	DT9tpI4U/VMKipdkADlPoAB4AHrXfHQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 10FFC4071D;
	Thu, 30 Jul 2026 13:34:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE221F000E9;
	Thu, 30 Jul 2026 13:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785418481;
	bh=cTKth7UNQeBwmsZO2B2Pp13WvIQsQKMZ6nrWV73pGKM=;
	h=From:Subject:Date:To:Cc;
	b=oeZmocRTJDKm7/UH/6M2EoYytUvah2fMlxFriOxG1INcFHLoBFl+ggFV5uJK30tEQ
	 NQtHGLQ8xlDiwVIfFdoSN+WwbIaAROECahisvdnxdYm4ELvwtBk4bm0AyK4Ga95lOK
	 VRIIfaiOMgFTHC+uGMcc5ahTxyT87qsPdMGyvdMk2pyoT/RRIwZ3fGdFUraLnjYVlY
	 43u6SmbFPDntakSdhbZe0BnnRes+93D8j3e9LBb8kuyBGMdwQZEc7clypNfAgQcp1S
	 M68f0sWObqvXuhw/WrrtRO79N07GJalU462KMbshwv8xCCYcqqLZRO+ahPiynaFDo+
	 /PJivJEAGNU+Q==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/9] binfmt_misc: bind interpreters to a bpf-backed entry
Date: Thu, 30 Jul 2026 15:34:02 +0200
Message-Id: <20260730-work-binfmt_misc-preopen-v1-0-4a0b0da71f16@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMpSa2oC/yWMUQ6CMBAFr0L22yUFFIJXIcbQdiuroSVdRBPC3
 S3yOZP3ZgWhyCRwzVaItLBw8AmKUwZm6P2DkG1iKFVZq6Zs8RPiCzV7N873kcXgFClM5LGtL5X
 TrS2sOkO6J+/4+093t4PlrZ9k5r23L3QvhDr23gy7Wpxgk1f5EYdt+wFB2SGQnQAAAA==
X-Change-ID: 20260729-work-binfmt_misc-preopen-9653fb9d1d04
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 Jonathan Corbet <corbet@lwn.net>, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, 
 jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-3e0c3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3493; i=brauner@kernel.org;
 h=from:subject:message-id; bh=io4rvUC7+JoPMBsCH5pmm5CbseXDfdm4tqym72NwEk4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRlB71bM6l2ccmN36uk9y1vqdhqbFj+XT5qzgXTDQqai
 7ao/VD92FHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjAR9QpGhokyak8Kd06PN9Dw
 nii75EnMjCe3YqrbHladb974muFH+2yG/24yM2O3qC356rI9+0q6vJXrlvDjXwIc/m8NsHmz4uV
 pP3YA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DBA39100010
X-Rspam-User: 
X-Stat-Signature: w7pmcu1yjxs5zsqht8rghqtczu1u4ur1
X-HE-Tag: 1785418482-219140
X-HE-Meta: U2FsdGVkX1+KsNjRYs8iRXKh4R780pCYXkYgmbMdy9RwUpodL3n2gRwIyXOKGnP/tC+7EWvP/rPF/egeiMVdY3kOtpH4Rbd8galTBVlP9dcL4Mf3hC/kA6iZhqQt+QP8s+gT+jUpGHAlyluMi6tS+yugB9YoDLEW66u/jAIbaGH+MhtIRJs9waZ3r+aHe0TDZcgyXMC7IMY9PCfQcRiJBhRmcK7uNOgG8nVHybzQGAnixQPCSCLSe7pyCp5eKy2VwlMrDq7xnfEzuLGRyqO3E6n23PgWFVoFTNA2BQIx768fkY4v8rs3kRO5UW0+gIj5dKOmF+BrW+5J1Ew9c+Ic5psWnRo2JtjgFyWO1lBhNNJT2e2aq3S08FiOIjs0txkPWzCn/0xST9KSgZyclDhYNrLkvvfizpls/TXqrHffZKWTf2fBAiUz3StpOwxeFV39ZYnaTyHVo/5kimbh8wtpriaJ8cBrSNsu+1qJuTqBuwh37FV0SX42PyLxEQEyPKDm13eM5iB1LnrI5QIxU3joGpyZiktzmcnhlijpswIBw5eFquip8VawMSi9faC7pz3YGvVos2wv3lzGONHpqjjuVSIlZ8+bq7yWsmrYh2jEd721lDHckoCjyGTbeyqd+SiB9DCbXTH3MeKDjGlcEvKslDiRFMl4cNrHzaPuuBBkYP2eTwje82Y9yzxBxDLBhVIYNvDa0kg1BgdIwTpa5T+224GkzSLT7Jnlq1e3FJdyh2LaEwQOGhuAWZ2zvmKY13rketkmV4XJSDYovSPJli0tI7bN4YCcIwHIs8MtZeRqEnj+XIlNbfWrJgu9VcsTcUoSYLhmrQF/KR/ZlvPP9EO1ZTPdLsbf94mUS1/NdtPorNlf5E8kaCT7ZoJaGtLHaRaIjerxpuMDtSSkUwd7Xx3Po4kyRq4hJe5vMzYucw91FV/xtm3FDB+1OwKpXTelcQL2rku1bNCrqdTzAG9EI/4
 ATWRErtP
 im4LaMq9/Ms70sdoE+zB2jTP1rIE9RCUZuNczqDdIyoDJiwe0e0F+7a/yaJhWJM34EHixu4jvg1fhZidVGkSYSdC/6FPwYqtd7+SDtBzitYnUrV3cDF38zEafI+pj0LEthjC8H+sdzGLT/1yfxL6+MC2MUbGsw45ewjg+XV7Rvi7DtjoiEt3hJ4rxxdl/Rjsf8OGuKeG0DVyF1VQhCETwgvcMgtejcNWblhJd95SoFR5L2OhCJ9+raVC5U9fpXTNIyaqUh/bgcV5NPRq9EPjt5fgeoe0hyGcD0rxtdF6tmdgXd6ovnBgj+MouYBvbDpe4R8XKh+vLoepaGY84gshP9wVYkwH6YObXScUDhnAR8BLklw8GwlTKSsEcLHgIGq+A2d99PG/BbR8kvoc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A 'B' entry's load program hands the kernel an absolute path and
open_exec() resolves it at exec time in the mount namespace of whoever
runs the binary. So the handler names an interpreter but never gets to
say which file that is. Whoever controls the filesystem view of the exec
does.

Static entries have had the answer for a while. 'F' opens the file at
registration and every exec runs a clone of it. I can't just reuse it as
it stands. It pre-opens the one interpreter named in the register string
and a 'B' entry has no fixed interpreter. The program picks per exec,
and a qemu-user shaped handler wants one per guest architecture. So it
may want a whole set of them and that doesn't fit in a register string.

An entry is matchable the moment it is registered, so everything it
needs has to fit in that one write. Patch 1 adds a 'D' flag that creates
the entry disabled and splits a registration into create and activate:

    echo ':qemu:B::::qemu_user:D' > register
    echo '+aarch64 /usr/bin/qemu-aarch64' > qemu
    echo '+arm /usr/bin/qemu-arm' > qemu
    echo 1 > qemu

Each path is opened by its write, with the credentials the entry file was
opened with. Same open_exec() call, same place as 'F'. The program picks
one per exec with bpf_binprm_select_interp() and gets a clone of the
file. Nothing is resolved again, in any namespace.

A 'D' entry simply isn't hashed until that first '1', so the rcu
insertion that publishes the entry also publishes its interpreters and
the exec side needs no barriers. Reading the entry file doesn't take any
locks either. Bindings are rcu-published and the open file already pins
everything the read looks at. We use paths, not fds which makes the
config remain nice and static and can be shipped via /etc/binfmt.d.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (9):
      binfmt_misc: let a register string create an entry disabled
      selftests/exec: let binfmt_flag_supported() return a bool
      selftests/exec: test registering an entry disabled
      binfmt_misc: document registering an entry disabled
      selftests/exec: share the bpf handler preconditions
      binfmt_misc: carry pre-opened interpreters in struct binfmt_misc_interp
      binfmt_misc: let a 'B' entry bind its interpreters
      selftests/exec: test interpreters bound to a 'B' entry
      binfmt_misc: document interpreters bound by a 'B' entry

 Documentation/admin-guide/binfmt-misc.rst          |  75 +++-
 fs/binfmt_misc.c                                   | 459 +++++++++++++++++----
 fs/binfmt_misc_bpf.c                               |  75 +++-
 fs/exec.c                                          |   2 +
 include/linux/binfmt_misc.h                        |  39 +-
 include/linux/binfmts.h                            |   3 +
 tools/testing/selftests/exec/Makefile              |  11 +-
 tools/testing/selftests/exec/binfmt_bind_interp.c  |  14 +
 tools/testing/selftests/exec/binfmt_misc_bpf.c     | 306 ++++++++++++--
 tools/testing/selftests/exec/binfmt_misc_common.h  |  45 +-
 .../testing/selftests/exec/binfmt_misc_disabled.c  | 172 ++++++++
 .../selftests/exec/binfmt_misc_transparent.c       |   2 +-
 tools/testing/selftests/exec/interp_bind.bpf.c     |  76 ++++
 13 files changed, 1164 insertions(+), 115 deletions(-)
---
base-commit: 4bdcf682a476e8d9f52b2c5c01e998d70e45656c
change-id: 20260729-work-binfmt_misc-preopen-9653fb9d1d04


