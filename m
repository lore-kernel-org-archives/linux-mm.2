Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1219C79FBB
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 23:33:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D457A6B008A; Thu, 10 Sep 2026 19:33:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D15F66B008C; Thu, 10 Sep 2026 19:33:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C04A86B0096; Thu, 10 Sep 2026 19:33:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F3966B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 19:33:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4620B14064E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:33:33 +0000 (UTC)
X-FDA: 85199456706.07.E5B5D56
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8CD0B140002
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 23:33:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HNrPLiH8;
	spf=pass (imf26.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789083211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0E1uJRWOdeWeFR64RXVnaSEl2Q3657otbvouJpAZYtg=;
	b=ItpQrKJTCvV6FLlK9/vVu3LIQtSeRxjFu7+ZzeF/fdIo9AhwHI/NQlyNWDcK1qdFl2Hb1R
	aPz1y9Ndm2FqmhsVqvS/0o6SAMy5me4ALxi7LMuVWoKgVlNPatkDyd9PLMdEGu0aw1wyDD
	rWCXQqB9DZYEUd8EKvQfyGJunaXdWPc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HNrPLiH8;
	spf=pass (imf26.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789083211;
	b=L8eGUB+sylr8earbD0QBvTk/0TDxXvkj9ns7M3hYQl9ryAcqlNkvr1cyNvyGpltEV8txle
	Bsi7JWu25Kd8UhBkmDd8WhIw9qQRbGMIfo4J30pwA33NsORgZGbkyocYjhuso1VWVK4LQb
	Gz08KKKwD+2ZA5s9tJ+dmkDut4Cahzs=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so287636a91.2
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789083210; x=1789688010; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0E1uJRWOdeWeFR64RXVnaSEl2Q3657otbvouJpAZYtg=;
        b=HNrPLiH8czyxdMKsNUi7EktZkY9c2NJoHppj10P+mf8HdT24Brg715J8UGCzqOs+PR
         6TyX1s/snJ7ofyFIrU/VVmC4KOgQhmiv52FPAMSkeOE5+yPDJtbXsAcoWPluAqqpKizn
         nhW83p7XtZ2E0O4gyhCXFA8ibGdmEiNh+khnzaHyxdj66xxG/8ggiEZryjua+QklMbyk
         vyfIPMjrlAoz05shye9StYFCJwGmXCdDlmsgK982NXjrM21pf8qeEBDG/EIxWRRTk8oQ
         fbNP/+cqHvtGwvUTsRYOYNjQ0gcGmWo41hw+S58w/YfZ3dPvAU8IPl4Jr6lI6ExZBesa
         uH7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789083210; x=1789688010;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0E1uJRWOdeWeFR64RXVnaSEl2Q3657otbvouJpAZYtg=;
        b=f16oujX64H93A52bHhZTZpMUR5r5KkRqdxuo2hx80B8m4PiTuZOrGghLtpQ1GLQBIt
         vnkV4NuKweQdx0BEXp0V/Xm4POYsc5LDJ8Hb+IA8Sm9WreLDg95hCzytDME9dmoBMMK6
         eINBu9VCnl1Oz9/9YiHlftXS5G3hmddP4E4muQeSM//wbaUTox/ejw59Zz5uLtVNOqHD
         NmEvy2ReM5ktemzVVsf3fZtEAQUFQGHxp3Xy2Vz1XuNdQpwI2MsMrqGcGmwbmdU1ZRjS
         gDCbk71EDay09QB2oedV9nwj36u8GY+SSD+n66VZzFluCRVL3cuYsTvspZAjnmfsZx9g
         adSQ==
X-Forwarded-Encrypted: i=1; AKwUvBxfBB1Ti3ue0IMWtqrPPdHiAoRTHZ8+Ck+joIMQZ5uK9cYW83ni4E7dKPsjDOPYVHNdBONkrztbsg==@kvack.org
X-Gm-Message-State: AFuF++kVks4GnIoG7TP3K+RC5ItIKVt/2I5q409LzNkOv2Q2JIRzW7vh
	daJ9yrv2wPkbN795pN6bY76oxnWUPFkpPBsWUS8sQ91/+BFVLWZCtLTy
X-Gm-Gg: AYBFou2xvMwSCIRySxgnalx5N08jGov1A+8SvTdbvd4JGpRIClhH1c55yidfYDV1aYt
	TTQTa+gfyqDh4bIhb4D0eCPrG/v7XCpokZbq3snC2M/eNN/dj1Zml5RVCzJHhkauTvAUqpa/dHx
	8d2ijuTHmPvpE72cq9E+W2VknZKWyQhXheNaVeZH1L59RmUm48+2HlmGuCVhvxTpX2VuojmsnyF
	Ter1zx2EjbBwg7r+ChdIH+ELqxaXncBZLsczkAY/G5aknngBVI+WlQTd+IlWjypxd3vP6mfnBaq
	307KsEOG4ccbxmLRvuB0eNiT3YnhmdS5XwtEpYbRHG0H2vQR2RwNRi4WLMpqysbDtmuC/2jVfZL
	ovGMaLh/6/0l396BomTKZ5A6/CX7UzNSqe2P8H1Abl8XLhz0X6lLZT7xsjgsRNCkF4CxukEx4ho
	8DAZOEkk3uKbPrFlFzbF33C1Z6lR8sp4y9NnrGpHHeGKh81neyOjpj1o8GsLb/Olbzqw==
X-Received: by 2002:a17:90b:4a8d:b0:39d:8222:6436 with SMTP id 98e67ed59e1d1-39d9bd8f51cmr1753897a91.7.1789083210158;
        Thu, 10 Sep 2026 16:33:30 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:43::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33ba4e95075sm1330595eec.11.2026.09.10.16.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 16:33:29 -0700 (PDT)
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
Subject: [PATCH v5 0/4] selftests: add shared Makefile for BPF selftests and a new memcg test
Date: Thu, 10 Sep 2026 16:32:59 -0700
Message-ID: <20260910233303.1063501-1-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8CD0B140002
X-Stat-Signature: k9p3zm9ig5ux97rabmn6tzss7zq89e8h
X-Rspam-User: 
X-HE-Tag: 1789083211-412052
X-HE-Meta: U2FsdGVkX18GbhVTMK8olfwz7rDeDXmHR7jNQIDm99jwhOMvjS9Xg69Fl5z256ZzkU1QYb1ublG6bXn45MVxsbbs1ZSbZxBd4xiwzL/jyPYiZmmMtzfMB0sLK+7FRYwwsdMXjxQ8jOjWs4IhjrndjsRlceFln6MInBPMQ+Izhkyp26UE+DKiUJkU83Ptqom0O49z8D5mjR7hNPVKn8SIjXIKxGDa0EYVPdj53eh4IE8MVH6hkdt9sN8+QrNRqA1xp5qP4gXxa5rKGCi5uJe1ha6vmv4qCziAR2GCUd3K2s1LInhpoQSbwdc5EdnEHOUqXddZF/EhD6280PS65y+A50aAwlG31mG9dcou9UHwbR/GzN23kMhpeZRocxUFXzjOOYsOoA6RigI0J6RDNgbk2gVZC1jL46U3Oq9x7MbK8qoGeNO8QnGTFSiXeNtPnNHgz6ohBg9Rl9P8lgglWeGg5nON9Q+fhEFtI7HhDNFEMFG2Zk1/a2qesgELpqZkt9gIY7DfRWRFUBmBm5S/GgSLQrL+TOtYRaGlDkn1dMD4rK0um1Y8hhRVvSf9oExe0RHfLgQep2ObEgvqMTAyAG7Gh0NYDfyg3bzAlBjoRKzUMkVmGYzT530CESXPCZbGyPCpJV/S6nSIGIlYE/jZ3eAwvloUuPoPW7HGk5titiFPsGYywXplLrWH0O2DxedFgE3mXjIpWXTlrgxLiutSyX04Oxyq0WJdaa8jnKxmyAWUSGVrsAA78Vsj2pLMcw1l8keMsptve1kNIvzOFd9VFL4Hpd8O+bdT2w/1ew1MnAwDR0fmyQ4tsnt7Acu93OC0KwMaqrVBDh8wIlGjU56WXgojiJhaoD7F+UxHKlgsez7vqVEgL7rhQt4u6v+qFsGUE3NYN/pXmsXxpIJhYNP2ETtW3zjkb0kyer6+QSrXWX0U7EN8pN2964e81fQ6cXymCsCUxeyZ3Tw1afi4kFeNXnW
 XcvS5A3J
 Hz11LJrNvRIIssmSrzkMMlq8LFWfpuf2WCbhHNgW9YYzukL/3LhHw6uRFnW3zMyjTCYNG8gv3nqf1LzWrLf8IPth9E3txdAsliSCB6h7cIopI629fnx7N+e1P/JUym1I4BheAlUX/7yxNzLww0LNBOKX50TGxoyjNMXI0KSfj7DJvrKXkxYblRmcQpw+Cj1yZ1W2vEq0aacTbx1SXktxyEd3v6I6iZexMS7ObCQXKkLpO2KQQCx8exYy1NVKdPnI0ewogTHsPMOy2R38DaheTI35mQOlUrP7X/E68AN0f4qAKQkfhzsuF5/Gnac6dzmlzrUGrATRW2K2Qq3MdhqYKPIh4UyPRvkEscXcO+tkjoD6Xo+vG2fYi9h5KFg5hMj/REIR8WlNfojlolNLMABNfFkRJFJjhi8LeHUnUMwIXhomTbsb78ym1z+NawIzqKajRvk24sxay97C0CHugPIEPfT4ggyvMPRrdtklFrv1kuNnRlcY7Dhb2KwoRlcNrXASObhJlE0WrCAYBiBP97wyVKVXi2CDNDfj0FbVXlbf+szTx7zfU/t0t5bsnJg==
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
Changes since v4:
- Apply Tejun's suggestion: make the vmlinux.h stamp a normal
  prerequisite so dependent BPF objects rebuild in the same make
  invocation when the header changes.
- Fix AI bot suggestion: assert in the BPF selftest that the memcg event
  enum argument types remain unsigned. This assert might not be
  necessary since these enum values are always uint32 on BTF.

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
 .../cgroup/memcg_stat_cross_cpu.bpf.c         | 101 +++
 .../selftests/cgroup/memcg_stat_cross_cpu.h   |  18 +
 .../cgroup/test_memcg_stat_cross_cpu.c        | 755 ++++++++++++++++++
 .../selftests/cgroup/test_memcontrol.c        |  29 +-
 tools/testing/selftests/hid/.gitignore        |   1 +
 tools/testing/selftests/hid/Makefile          | 179 +----
 tools/testing/selftests/hid/progs/hid.c       |   7 +-
 tools/testing/selftests/lib.bpf.mk            | 321 ++++++++
 tools/testing/selftests/sched_ext/Makefile    | 149 +---
 14 files changed, 1388 insertions(+), 316 deletions(-)
 create mode 100644 tools/testing/selftests/cgroup/memcg_stat_cross_cpu.bpf.c
 create mode 100644 tools/testing/selftests/cgroup/memcg_stat_cross_cpu.h
 create mode 100644 tools/testing/selftests/cgroup/test_memcg_stat_cross_cpu.c
 create mode 100644 tools/testing/selftests/lib.bpf.mk

-- 
2.53.0-Meta


