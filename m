Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99C43C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 04:08:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5140F6B0092; Sun, 12 Jul 2026 00:08:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C5756B0093; Sun, 12 Jul 2026 00:08:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B4306B0095; Sun, 12 Jul 2026 00:08:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 13D266B0092
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 00:08:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8A44A140815
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 04:08:53 +0000 (UTC)
X-FDA: 84978793746.28.C7962A4
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf19.hostedemail.com (Postfix) with ESMTP id B5D9A1A0002
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 04:08:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jGXjB8cx;
	spf=pass (imf19.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783829331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=t37Gu0kxoMG3/ekSSSPa6GLm4FmEdZkOax2Tk1RKTwE=;
	b=ArRhXRHwAQffgs7zFYZN+ErA7QHvKL+IgV+1U9gHqDScXjaGimK64E2OItVRYV/HMNbWOr
	jIR7F8UmLnf+GuDrKCGN8Spt7KBcqaoA6Yrs9edRph4vYSiqZ/LCfpFiT73NBUKuX0YxwJ
	O/9e7wdOptWAScSIWq93NnsMFeOKQ7s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jGXjB8cx;
	spf=pass (imf19.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783829331;
	b=7LdJXA3Ogi8+Efr5hOb3iOWsLOVrmaRHu9hU2ZPAkqkhsA4PdqqtlVQ+U/zKy0UpuzspXY
	p+FmJ55JuPu4lAZb+lyGARSSY2E8GQVhPIuGZxhgycHX5HwH3/zlOxqWU9oAxQG5nN7sEQ
	QhYMAyBKVjqiMpIYEYcD3Ro/BGJrDMI=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38dd55ad76cso262665a91.1
        for <linux-mm@kvack.org>; Sat, 11 Jul 2026 21:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783829330; x=1784434130; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=t37Gu0kxoMG3/ekSSSPa6GLm4FmEdZkOax2Tk1RKTwE=;
        b=jGXjB8cxXzhv+1oGUEUmU3ccJK4oGF6lc6evPqlyvXu4MJWGknvfbIr7hzxBEBecrA
         wM/RkkHaFcIHHpjprKKDrissTclfvrDn3bLXA8ltSPNGfOwsRYwzbcr6w/1HWW4+00cr
         fuTi6yFrBJ1ulwel4jiGv5//NBjaDYQ4QuHcrlVS0Ay2jVhmYpHf5o13/8UVqOh2TPwi
         Z0+7104SBAFJOocvysZ8nHEq/QfhaEY8HwUKTVIqDdGxk0Nc3Y2PbRt4oETbKZH00CHM
         V1z4RFrFzOGDsmqfS5a5BAAoV2iEG0TSUtzWNgx1rmMxdN9Ki7714URFqb5+KKj3Yj1u
         Srdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783829330; x=1784434130;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=t37Gu0kxoMG3/ekSSSPa6GLm4FmEdZkOax2Tk1RKTwE=;
        b=dZMAQABzVgS+7ppq2Vo5rcOUv80uZGIG1kIux9dLEr4sZLSVDzc23l2xVfiSgcwOKs
         hQa7+yKGAihlA4uJf4mFNy6LcqMI2bkcJEETcpiBcsKfY47ob5zD0zjJRydZ2PsaIQnF
         +wn1c9+cE9R8xboYlF7HqB3ni+sKFLsEa6OX0L3GhCvWvTniK2CapL/m2MAUvpT8BftG
         xeP/+ahpTId0rUuRM7Cx0pFUN9kQYTfhrxboD96rhXgWSMIQcGbU+Y2q85uvnKQzKJjE
         sXa51RQ3ttqOmUJj9U9TLOFx0Rddq2VuGt3NW8YkaXhdSHGzg+adECQEnXKgvGDWjGNp
         QNEg==
X-Forwarded-Encrypted: i=1; AHgh+RrD+k9IWByi2ufpqFJQQCeAj0hUB/M6MB3xAs/+P3E7VCz1+IdDyOyEDHFSJc5rQtHQwAYWcwe8fA==@kvack.org
X-Gm-Message-State: AOJu0YxHvqau+lrHVyFubeD4enIWw/DUzQ7hl5YGRkJA6UqTy8+84vBZ
	oRf8vVf7/VKP3lTGAkkiIPFF3/W6qySNiD/L2qRx+aSR/24a0q405erM
X-Gm-Gg: AfdE7ckw/XME6lJ9fMs4IxZee98rxUzBxWe1pb+iV8oZ+Y6Q665J/4DMCgPiolNuQIj
	hrIWGKAT5qW4L8lwcoodiKsDOL9b25BigkArNgzC8Y/UPU78ngrbxrp3GkOBc0kqcbKhA/L71ia
	2jkaDPfFsPtqNDW7fdehVmBbLmaLC5eRnxN2J+Uof6coJCeA4mIIoKUYYp4YRv185HjtTnjcfeT
	wI7eo82gicOV3k46cGhm5Qloxm6rn6x2yZCtEZfFS9T5ef37HFsPlwBgYBBcNrvJJiJDzcGP3/c
	6xydA3bAkMccZkNFdtgf37722NWJRJ7DZHuNKHIQOHbwvMpSkdTtSh2px9qSA0aB3uj5LsiTwXr
	ZZcdaA792pqh6b7ccHWxkYBY9y+rLbEl8BHM5z0yJMs36juCQvWILF+etTpShbqByEIIzLEmmAW
	7AmR4oJrBJXqn9cZGT
X-Received: by 2002:a17:90b:2585:b0:38d:ec55:7aa7 with SMTP id 98e67ed59e1d1-38dec5589c6mr496049a91.19.1783829330453;
        Sat, 11 Jul 2026 21:08:50 -0700 (PDT)
Received: from [127.0.0.2] ([98.35.8.117])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31174839f89sm56808928eec.10.2026.07.11.21.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Jul 2026 21:08:49 -0700 (PDT)
From: Farid Zakaria <farid.m.zakaria@gmail.com>
Subject: [PATCH v2 0/5] binfmt_misc: bpf-backed binary type handlers
Date: Sat, 11 Jul 2026 21:08:13 -0700
Message-Id: <20260711-binfmt-misc-bpf-v2-v2-0-d6591ceaf207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAC4TU2oC/y3NQQ7CIBCF4asY1o4B0lpx5T1MY4QO7aQWGmhQ0
 /TuIrr8XzLfrCxiIIzsvFtZwESRvMsh9ztmhrvrEajLzSSXR94IAZqcnRaYKBrQs4UkgdvaCKu
 UVtixfDgHtPQq6LXNPVBcfHiXH0l81z/HG3j6MBbn596KmwRwaCqtVG1OFRpxGTE4fBx86Fm7b
 dsH8KzV07cAAAA=
X-Change-ID: 20260711-binfmt-misc-bpf-v2-0f5c1f99b9ed
To: Christian Brauner <brauner@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Shuah Khan <shuah@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>, Kees Cook <kees@kernel.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Jonathan Corbet <corbet@lwn.net>, Jann Horn <jannh@google.com>, 
 John Ericson <mail@johnericson.me>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Farid Zakaria <farid.m.zakaria@gmail.com>
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B5D9A1A0002
X-Stat-Signature: e5h9ookt8qaf11x1bg1aa399upjf5yzk
X-HE-Tag: 1783829331-420374
X-HE-Meta: U2FsdGVkX19eFDZ0gAI8CWhcHnFYz2APFFOIWOa2Ycgjo0puM8Dc2DvaYtC6mxkG8ZbhPbEJKXE2BaSv1l/J7M0IGyxAnk5onrfPWjFKXUgw6Oc7Mk65i1VXraMA0mJcAE8TKRbdvp/lRSPTY11TjEk49UKtdSfau4sKjSLqv8lQkURmAMcpiPA0l65M3VhTS37L44IxIV57sr2xII+4QVlXrF1QL7a5FjxI7AHpqQOHktVI0W0W9TsWi9ltdRp5QbmhtrfOUR/KlYg/ridg2yjLDqV1JwDJjsheztU9OZzcpv62SB2U84rJ0L86ZdXIASRSGq1687j2hd9tnBJlVTaxGU/p85Nieth/W3sjFEQTSU7RY07o1tv60mxstu+cIEetkHyYbg50vToUuB+qiZpKplTqgyxXt50APvW5yfEx5j4PWK29Rt7jPRkZJq91QOT730jw20jaekbRCigVj3lKiUw1qw0RSBF8ACSfEd+9xIkPMNeSlhSDIoBEjN2ESJBntMWgRyC/xZCHGrhXAhwC8ZGrmtvraVtYAFptfVcsfr2Cxk0kG69Geay2uAHpJHIwQPMXAF+I8Hb+CRGlc8Pq7II8juB/bG4CAV67WGuK0D0OM7JHRSl4FCtgFcOFp4NhqvfzVkFooKp50GMlUyUJ940aTBkMhzxs4iu8Uga/od3qgISaKxaWW7W4T2aLdwfKjtt6xojv5fL+fBXdlrpnJ41ZfPZuI21bOipNKCWGbe9zBnwuUwvh+mJn7o1bNz2wkouq3i76ZH8zd66Sf/rS9qNuhb5etkGtYVjtm/FYE+C6aeeldDlOHW1QmkJWLDFztgFzdJxYUFc+1Vb7gbd2QB6jUWodqDWVbsJ7wBuarR1e3nlYqTdaOnL1bkGBJaSfXitwFQPwd0cPD2zTXY88WpdNz1/B6uUrNHshLJh/LPzDiOvpqkmdBItctQ1xWu9HFaHf3dY9ZxbYvfz
 b/iCJYGi
 tIEipWwODh48zAiGPq899i6CAAPK9CbSYIbwl1e11DSly0Wc3BgL6UckFZCX0TVdGRjfcCd6wGTVklYJsO2WXR+KYwVEHzaMtbHrynW4YSmlKeLJHPtkO8IJtn07KV3Q1GWPUi39K9NvfONiSojHG6/8nEDqNjqdVgNHknQGsxIJpE6bQZFxGdxdorwdAqWEwfsRo1XkKacNzM4a9ICX51wSA7q/nxAgGTgyr8DrkN//0uMkud+qo8WjIotbwei7X7TRFBub3OlW8/p7McyPKFNr26EgFvW0395C5bPCS/pKXncdoDLoSdfYSIep1cJuYbqINe5TrxykjWBpViN3nLHe/iSQM5z9ILwRX8S6XfQM+KD6GVi2KhOo2q7F56etXTVG9n1+y6GsFJwZXLiUUnMXj3/K5gQR58hzq4c168AKU770h7z+I27IrEvaRjY62LbAEnwHEBDcThVn8VMFjjm8y/S6ePwRkUYfwil0+xHKU+MUfBH0x1pp4xj/G1Pc95QovJ6hTZ8ZHLC2zpT3MOQOwnUFqZu9EYvRIHjM63lk0gge0//ZJSt+1LSWd3fXYw1ULKAzDXaYfR1Lp6SmjbneLAWtlXdHMZt/enISes3bemccLAVRCu1Ob7F/0k6n/Hzj3WtS2+msnCS2ttBjFahsoYMCVLBg4EdWPCqMMa4EL+OH+Dzs0l4LYEtoik9PR/khbQW8E53tpVhMhgckj7IgUrR5AUO7f9u+2AvF/sI8xCEW9K/THmMtQUaflSK8QoXGdXlpo46pXyNzlUZdle4EeXmIwuIcSM2aC/+PHvJx4bArszWuJXMUlV8HOlxCMpqQ+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a continuation of Christian's bpf-backed binfmt_misc POC [1], which he offered
to hand off to me. I am carrying it forward. The kernel design is his and is
unchanged. This series rebases it onto his binfmt_misc locking/cleanup series [2]
and adds selftests (+ fixed from the one's shared), and therefore does
not apply to mainline alone.

As for motivation for this whole change, Christian did a great VL;MR;
write-up [1].

TL;DR: binfmt_misc can match a binary and hand it to a fixed interpreter,
but it can't match programmatically or compute the interpreter per binary.
The Nix community would love to support relocatable binaries, where the
correct loader can only be found relative to the binary itself.
This adds a 'B' handler type: a binfmt_misc_ops struct_ops program that
inspects the binary and picks the interpreter with one new kfunc,
bpf_binprm_set_interp(). 

  bpftool struct_ops register nix_origin.bpf.o /sys/fs/bpf
  echo ':nix-origin:B:nix_origin::::' > /proc/sys/fs/binfmt_misc/register

Patch 5's nix_origin.bpf.c is Christian's example program with a small fix
so it passes the verifier. Christian, happy to add a Co-developed-by: and your
Signed-off-by: if you would like the credit in the trailer.

For those that want to validate this functionality on a NixOS machine,
you may find my flake.nix handy [3]. It builds the kernel, compiles the
bpf objects against its BTF, and runs the selftest on boot,

  # be sure to change virtualisation.sharedDirectories in flake.nix to your checkout
  $ nix build .#nixosConfigurations.micro-vm.config.system.build.vm -o /tmp/vm
  $ NIXPKGS_QEMU_KERNEL_micro_vm=$PWD/arch/x86/boot/bzImage \
  $ NIX_DISK_IMAGE=/tmp/vm.qcow2 \
  $ QEMU_KERNEL_PARAMS="binfmt_autotest console=ttyS0" \
  $ QEMU_OPTS="-nographic -no-reboot" \
  /tmp/vm/bin/run-micro-vm-vm

[1] https://lore.kernel.org/r/20260707-work-bpf-binfmt_misc-v1-0-74b995c84ec1@kernel.org
[2] https://lore.kernel.org/all/20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org/
[3] https://gist.github.com/fzakaria/0155e11a0882bd3d6e63f4070e7fac0c

To: Christian Brauner <brauner@kernel.org>
To: Alexei Starovoitov <ast@kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>
To: Martin KaFai Lau <martin.lau@linux.dev>
To: Shuah Khan <shuah@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Jann Horn <jannh@google.com>
Cc: John Ericson <mail@johnericson.me>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: bpf@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org

Signed-off-by: Farid Zakaria <farid.m.zakaria@gmail.com>
---
Changes in v2:
- Patch 5 adds new tests that validate the functionality:
  - a bpf handler matches a synthetic aarch64 header and routes it to a fixed
     interpreter the program chooses;
  - a handler resolves a "$ORIGIN/..."-relative PT_INTERP to an
     interpreter co-located with the binary (i.e, Nix usecase);
- Patch 3 is rebased to fit the new binfmt_misc code style: the 'B' field parsing is now a
  parse_bpf_fields() helper matching the new parse_{magic,extension}_fields()
  split, and load_misc_binary() keeps the bpf retry loop in the
  __free() cleanup style.
- Link to v1: https://lore.kernel.org/r/20260707-work-bpf-binfmt_misc-v1-0-74b995c84ec1@kernel.org

---
Christian Brauner (4):
      exec: stash a bpf-selected interpreter in struct linux_binprm
      binfmt_misc: add binfmt_misc_ops bpf struct_ops
      binfmt_misc: wire up bpf-backed 'B' entries
      bpf: allow fs kfuncs for binfmt_misc_ops programs

Farid Zakaria (1):
      selftests/exec: add binfmt_misc bpf-backed handler test

 Documentation/admin-guide/binfmt-misc.rst        |  40 +++-
 fs/Kconfig.binfmt                                |  14 ++
 fs/Makefile                                      |   1 +
 fs/binfmt_misc.c                                 | 149 +++++++++++-
 fs/binfmt_misc_bpf.c                             | 275 +++++++++++++++++++++++
 fs/bpf_fs_kfuncs.c                               |  23 +-
 fs/exec.c                                        |   1 +
 include/linux/binfmt_misc.h                      |  49 ++++
 include/linux/binfmts.h                          |   1 +
 tools/testing/selftests/exec/Makefile            |  37 +++
 tools/testing/selftests/exec/binfmt_bpf_app.c    |  12 +
 tools/testing/selftests/exec/binfmt_bpf_interp.c |  15 ++
 tools/testing/selftests/exec/binfmt_misc_bpf.c   | 260 +++++++++++++++++++++
 tools/testing/selftests/exec/bpf_interp.bpf.c    |  52 +++++
 tools/testing/selftests/exec/nix_origin.bpf.c    | 179 +++++++++++++++
 15 files changed, 1091 insertions(+), 17 deletions(-)
---
base-commit: 6203a47c1d78f948cd5e9ad1a4c089745e466870
change-id: 20260711-binfmt-misc-bpf-v2-0f5c1f99b9ed

Best regards,
-- 
Farid Zakaria <farid.m.zakaria@gmail.com>


