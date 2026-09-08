Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B840CC79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 23:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E28A6B0092; Tue,  8 Sep 2026 19:56:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BA636B0093; Tue,  8 Sep 2026 19:56:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D27D6B0095; Tue,  8 Sep 2026 19:56:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F1EB96B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 19:56:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 86016160785
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 23:56:18 +0000 (UTC)
X-FDA: 85192256436.29.C756E73
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf06.hostedemail.com (Postfix) with ESMTP id CBFD318000C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 23:56:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xxsfyi+j;
	spf=pass (imf06.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788911776;
	b=A+biL/+ICw62dPmOTFJ1wvo+t8FXok+TMm2FwU/B5Ab5ZXU/83CFlPgswQ5xSYeaZwsD1m
	USqh6LGVrxKEBpnDmbAR+krBom3g27+00ecNn82ttWt3w19EIYvC7qJ6xsyXfSPpTKGASW
	UzAaZHE/ah3ESuAhuFa7spfcgRrBXcQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xxsfyi+j;
	spf=pass (imf06.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788911776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=aeaQ8qHK/MyWCciP9ARnOOzHBOTcOWNQ9SeCb5dOpCc=;
	b=4Yyif1yjoPEQZ/URuxiwUiempE7SqOm0NZRuCIXCcmt2b6PaojejEeFH4Tz69VmR2cHgxB
	qFJUPNxXnzMT42GJml7DUBQf+vJQOCxf72SrB2DDCaYZI+pMvWM3EIlHgDUX8PonTprdSa
	ZYCfhMWzgR+8xPK1XY2pn4pAiaZrhRY=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38dfe7eb825so4331458a91.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 16:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788911775; x=1789516575; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aeaQ8qHK/MyWCciP9ARnOOzHBOTcOWNQ9SeCb5dOpCc=;
        b=Xxsfyi+j8HITMYFv4Zlrg/h8HtLQmcSISIfnSOGy8GKLfR7DEe0KhIekBohVtomTMz
         ubOEV8vXegxXiGfcKsFP/cAKKTaOMDg1Pc1qRXGLBu/yEBLKGUr4Pc/f095I4JjPsOML
         0BO08nW2yx3big23ODPlJVwzM6MsA7jWfvnDvtRBFH5R+oW/4BbIMr/E/1Ggzg12Xjan
         W915t8yXixs9VXgb9AdmBZLhFnsi90UzJ6wMbkh0DeIMUrMf2O7YowgpWl4XJ20M3IVI
         EV7HvByLPEIJS9ZS/JSaYVu5DH5j0FTUj7ZB4kf2+EobWDI0TVg3sd4KjzRrjSnyw7Kz
         RMCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788911775; x=1789516575;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aeaQ8qHK/MyWCciP9ARnOOzHBOTcOWNQ9SeCb5dOpCc=;
        b=tUhg9zWanWeHDiCOUw0apJT/FM3Qy5RFgkAiRgs8+72HWLcIP9aFMmqeIaQpOLxpLJ
         xdQEzvBAHgdwX/XOc3KB3i99uc+s09sFVswaPmBwEAz97hAG58ztL1aFzVzJ4qVos5tt
         NdIlf+gyaTHc63+hGQaHPGighQrIENHkNv6/oq1zk+6X/C1QoKJt12HfYOmtbBsgj40h
         YG841hbchWc5CmMRoDs2YR1XzotVKnMdpbFLDOp4Q66BUkd6wuDIm+Wqb22tce+5J3iD
         P2WidCwEzc5xfS9XHWjilG39v6OhabG4pQ+RN9i449LmcthAu6Tj4gb+B6j1r9js4N3I
         IipA==
X-Forwarded-Encrypted: i=1; AKwUvBxNh/YAlB5wGfkZYqH4AvM02X2mLsdffPEL8qKbpx+Wn1mkMs62sPara9cyKSXtL2hN+PK22S1h+A==@kvack.org
X-Gm-Message-State: AFuF++mHADkGhxJaQC3WlkS0SFyTE5WM/unRNlW5hXcd96pi6caLdF0G
	e8dMCxrNiz5UCgb3OguGvnOwsyNKr3iWfC0LCGvW8uB76R9PW/cBs8v3G/aCxw==
X-Gm-Gg: AYBFou273kcF/r7kzb0dyDGme2mY94w7cxLBrD8FNCOm4sfJ3/T78A5kltbxti2LqLv
	CjNWY/qHWmKDged5+iDRXQYW7qu/7XYukNcfcIDdk09OLGXBm3atlsYKE5yk14puUcTbHcNqE1o
	iqceU/dQQ+HbIt8gOTWTH5R1gQ18yfsRILbH/IxwfVqEiNnqCauTVtShdsy8F8HrmMeL9aVE3DD
	ag/kYX/qf7QR4v4Lic3enEh0QgG4/xdNTR9fJUQu7OCw4d4g4vasMTGD1oMBufDeImRzJ4eY+Os
	itcwoiGGlQNeOYfRGWW0MqCk20EV7ptOTxibFM7MDvgTKvmWynh0sHayRcGCOzJXn9YCyzAsO7G
	tkZhlbk1h98kx2pdQpK8+wbqSWIUCcLEGmSe57K/Pk94AyFRo6P/NOjVXtfNs4d3I0V6bcanQC9
	3j9B0ah3y4L9YO+tq5HLYzRwSiGNTCAXQJYReS4Thy5aQkyMu5BIv1yqU=
X-Received: by 2002:a17:90b:4cce:b0:38f:240d:b857 with SMTP id 98e67ed59e1d1-39b260dd4e9mr51323684a91.2.1788911775237;
        Tue, 08 Sep 2026 16:56:15 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:73::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14324410092sm36459946c88.14.2026.09.08.16.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 16:56:14 -0700 (PDT)
From: Ziyang Men <ziyang.meme@gmail.com>
To: Shuah Khan <shuah@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	David Vernet <void@manifault.com>,
	Eduard Zingerman <eddyz87@gmail.com>
Cc: Viktor Malik <vmalik@redhat.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	Mykola Lysenko <mykolal@meta.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Ziyang Men <ziyang.meme@gmail.com>,
	kernel-team@meta.com,
	linux-kselftest@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-input@vger.kernel.org,
	sched-ext@lists.linux.dev,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/4] selftests: add shared Makefile for BPF selftests and new memcg test
Date: Tue,  8 Sep 2026 16:55:48 -0700
Message-ID: <20260908235552.2610256-1-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CBFD318000C
X-Rspam-User: 
X-Stat-Signature: jbunsbra1fzxiqsnrtiwx5jg5shhwpgy
X-HE-Tag: 1788911776-900343
X-HE-Meta: U2FsdGVkX18g3oSH9YYrN6vWkeGuO25XIcTd6dwa7N1ArqRdPZimFaldeuk/1icLI5GZVugYszuBQ+63hwIa1L/J8J0Mq4V4dUvmHS4kHuujy0eo68OVs5BQviz6hyqghb0B1e6qC/zUqmDH/3kCmiqPFzElnndSXFYpT2Sv6AEfPD4MdQ2IJAIng4u5yxDny6K4QprO2SvcGrFCbvwcR4YABUhctA8VZjEAWAi2gMDZLccJ56/Oj41t84oIpdf+Aqs2H+LSx7HpdkLcei1bt+oWE5oSV86mfPGet4ffjFFKGWOYrGfKRWiZthnljobhmv9+6qdFjXZpVy/VuarVNWZ7TdspHGJglrjIMMqZLIi931E0roPpzvxfZRj6hcAr7vBfXKqS0kn7SsDw4Ulcb3irAWiyao+O4pv3QzDNkXBFQDCPZza8gsVwBiFdt3Xrh91D4WyuzyK9NxTrvQT/NgwKGdceQHPv8wo6rhjEok/ymyipIW31pzmISeSsB46CS2fKsfsskfl5KBAVYfYMLri/q60E/Cxs9i/zcyZbi2fEQxEn9xyRlPdEQWMMnBCCf203An1MaeZCI7vUZLF/oCL4I6x5SOC0OORMDW6GJT8/L9+wvcXEx4TyKMUttVGhktLpIoQOqqCmTOiQmuXDFlt5DTzJsX7aC7tmQSqLFWc5az4uqMYnG+WGPHYYBT60sY7Pdg6/FkBeQ39Nh9s0dVOmcQZeualpjO1tJRvkk/i/DwqdG1aHm4pkk1PBvOSyBxmycf0rUo9YHk6SwUMxzEABJSx5rSbLU0jXYRreEfHfF2f5bU5U9yqGArCTLhntcyAlbnvT0FD6XlLXLwvTpxEsz24CkXdhGXcrPZ1DBdsBNQps6R36cxU5eWyCsKYFD2aW15opFWxOX8uH7mxwFQWkYizdZEoDFzabHM4QZ8ENCPqnpTDsF3zHEowySDnnP5o22+H/zjmztyMAgHY
 okzrL9g3
 JfXMCbHCHk+IU/Dgb9BSNthdWbygBN5t8qbrqcfh0BIBDwSNRhKPgf4u0x09Gk05qagj7IEmCVY4h3ERB+74IhppdcrZZPEFjaL/0hltiMvUe4vIq7yI+KufLuqsYchnWxP4WeSwxuOWYYSsNmyhhQpYDmLzf6Ji7pIruJY5sPaYylHsThfsUesJI2xxmx8OnOc9a63WCewxSScYRB9mOo7tZ6LjLr1wJ+WIP8mTod9f4sW0bJZ1KGI/Z52eJnwjTWva+6MZGDMD4O4dBd9vqgk8ssBqnJG3ZE+gG3yFCaf0yOoQrt3/M81FUwbZlOYaoFZ2yZ8yZd+dmWPuvHGX6mly1qp11Mv0dQm2QdVC5JxvfWSBFZo5fXFrVxWT3UgJvSkcmJyz7oGEOZfAuD5Eu9OVwrHidcPeklLrP/tFnJDnxQg9IRhLh44KjHrIGIAdzfmuamyMjFWzdHPkycS4nYT/SoF3XRJzCYQdJuRksULmTel8dZ48uJQKr+PzIR3HZMcki/T5epd5KyPLfZzBTUh5S6zXhv4Vvhn4lkC8ArPzl50hD5dliqzfmLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series refactors the BPF-related build machinery that is currently
duplicated across selftests/{bpf,sched_ext,hid}/. It adds the shared
tools/testing/selftests/lib.bpf.mk fragment and wires up three consumers,
simplifying both existing BPF selftests and future additions.

The series also adds a cgroup memory-controller selftest that complements
the existing coverage.

Patch 1 adds lib.bpf.mk.

Patch 2 adds selftests/cgroup/test_memcg_stat_cross_cpu, which verifies a
cgroup flush by comparing values read through BPF memcg kfuncs with the
corresponding cgroupfs values. The existing bpf/cgroup_iter_memcg test only
checks whether selected values are non-zero.

Patches 3 and 4 replace the duplicated BPF build machinery in
selftests/{hid,sched_ext} with lib.bpf.mk.

===
Changes since v3:
For shared Makefile:
- Track in-tree libbpf headers directly so a single make invocation rebuilds
  BPF objects and skeletons after a header change.
- Restore the target definitions needed by LoongArch and MIPS cross builds.
- Validate output directories and skeleton suffixes, and reject dotted or
  hyphenated source stems before they reach build and cleanup rules.
- Add stamp tracking for vmlinux.h generation while preserving content-based
  header updates.
- Make skeletons and subskeletons explicit outputs, so a missing subskeleton is
  regenerated and both sets participate in the all target.
- Namespace private variables, expand the caller-visible contract, track a
  supplied VMLINUX_H, and remove unnecessary include search paths.

For cgroup selftest:
- Add CONFIG_BPF_EVENTS and probe every required kfunc plus the sleepable
  cgroup iterator before running.
- Bound CPU fanout, cgroup/process count, and total memory use; skip a case
  when the flush threshold would require more than 256 MiB.
- Check CPU discovery, polling, iterator creation, and BPF errors, with clearer
  diagnostics.
- Compare each BPF statistic against two following memory.stat samples, keeping
  exact equality on a quiet subtree while tolerating values that move between
  the two samples.

For hid and sched_ext:
- Remove unused HID locals instead of suppressing warnings, drop obsolete
  variables and comments, tighten cleanup, and correct the generated-output
  description.

===
Changes since v2:
For shared Makefile:
- Use USERCFLAGS and USERLDFLAGS to extend CFLAGS and LDFLAGS.
- Pass OPT_FLAGS/RELEASE and EXTRA_CFLAGS to the libbpf and bpftool sub-makes.
- Use one rule per BPF source instead of a global vpath that also affected the
  caller's normal %.c rules.
- Take HOSTCC/HOSTLD from lib.mk instead of including Makefile.include, which
  also rewrote the caller's AR, LD, and CFLAGS.
- Report a missing vmlinux from the recipe rather than at parse time, so
  "make clean" still works without BTF.

For cgroup selftest:
- Create one cgroup tree, perform one flush, then read through BPF and
  cgroupfs.
- Use common cgroup helpers such as cg_read_key_long() and values_close().
- Use cpu_set_t rather than manually allocated CPU lists.
- Move test_memcontrol.c's anonymous-memory allocator into cgroup_util.
- Address the remaining review feedback.

===
Changes since v1:
- Generalize lib.bpf.mk for source layouts and suffixes, extra headers and
  flags, skeleton suffixes, subskeletons, and configurable output directories.
- Add patch 3 (hid) and patch 4 (sched_ext), converting those directories to
  the shared fragment.

Ziyang Men (4):
  selftests: add shared lib.bpf.mk to build BPF progs and skeletons
  selftests/cgroup: add memcg_stat_cross_cpu correctness test for flush
  selftests/hid: build the BPF program via the shared lib.bpf.mk
  selftests/sched_ext: build BPF schedulers via the shared lib.bpf.mk

 tools/testing/selftests/cgroup/.gitignore     |   8 +
 tools/testing/selftests/cgroup/Makefile       |  46 ++
 tools/testing/selftests/cgroup/config         |   5 +
 .../selftests/cgroup/lib/cgroup_util.c        |  82 ++
 .../cgroup/lib/include/cgroup_util.h          |   3 +
 .../cgroup/memcg_stat_cross_cpu.bpf.c         |  95 +++
 .../selftests/cgroup/memcg_stat_cross_cpu.h   |  18 +
 .../cgroup/test_memcg_stat_cross_cpu.c        | 755 ++++++++++++++++++
 .../selftests/cgroup/test_memcontrol.c        |  29 +-
 tools/testing/selftests/hid/.gitignore        |   1 +
 tools/testing/selftests/hid/Makefile          | 179 +----
 tools/testing/selftests/hid/progs/hid.c       |   7 +-
 tools/testing/selftests/lib.bpf.mk            | 321 ++++++++
 tools/testing/selftests/sched_ext/Makefile    | 149 +---
 14 files changed, 1382 insertions(+), 316 deletions(-)
 create mode 100644 tools/testing/selftests/cgroup/memcg_stat_cross_cpu.bpf.c
 create mode 100644 tools/testing/selftests/cgroup/memcg_stat_cross_cpu.h
 create mode 100644 tools/testing/selftests/cgroup/test_memcg_stat_cross_cpu.c
 create mode 100644 tools/testing/selftests/lib.bpf.mk

-- 
2.53.0-Meta


