Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BF5BC4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 17:48:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 433F76B009D; Tue, 21 Jul 2026 13:48:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E4C96B009F; Tue, 21 Jul 2026 13:48:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FE286B00A0; Tue, 21 Jul 2026 13:48:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE9756B009D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:48:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8235480266
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:48:39 +0000 (UTC)
X-FDA: 85013518758.24.D01539C
Received: from mail-pj2-f7.google.com (mail-pj2-f7.google.com [74.125.227.135])
	by imf01.hostedemail.com (Postfix) with ESMTP id CE6B640013
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:48:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sR0+rHog;
	spf=pass (imf01.hostedemail.com: domain of ziyang.meme@gmail.com designates 74.125.227.135 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784656117;
	b=CQc+3w+z7XhTYearfN/thuvYSkyvGP26F0SlN1DT5ly/9Qt6nuEHMV9KH4soHDpfnG72RM
	UjP8MegO14kr6Mp5H/tRTeTE2mtBQpI3x2IdqMlbPUNn3Q4KDQs/I3F30qo+5ny0xBQ/nQ
	IrHJxbWkpn/hMYCL4ItquwV0Q6SQpOc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sR0+rHog;
	spf=pass (imf01.hostedemail.com: domain of ziyang.meme@gmail.com designates 74.125.227.135 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784656117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ocH8UcOo4UY0LfArAy9N9P4eBtmhXMCHbqhRio/RB1c=;
	b=vBP7KXrLnFiVEHb0HZCKZvLb8U+ZJaSMZVlrGqO+YRz4e3sRkcFiEiyrVKpg12zrrNIZYX
	IWIJbmFIwmFna9ld9AguZ6oJumjtfF1Sbq3//nyMmcvn21O1QckRhpBiuXe+s6i/tgYVAk
	qPkd4XIb2G6Fmbx0IpCBwMFDy+9z+5s=
Received: by mail-pj2-f7.google.com with SMTP id 98e67ed59e1d1-38dcd98e5easo5876089a91.0
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784656117; x=1785260917; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ocH8UcOo4UY0LfArAy9N9P4eBtmhXMCHbqhRio/RB1c=;
        b=sR0+rHogqVq+qVcwYiB4LRDhJIil/1PYnkcgXC4+wwcaopLUOWVoA6oEHzWhjG6tI4
         6UFjuzj4cxxRdC7fuFxJbu3Xrq88k/Wfg62mOogAuZNtYzw2uXO5aU+RlrayZEKfuWff
         NJzNMYzHWVOgyaMLjo6mUDHxqcb4AAJGmpnPm5kmxQHCnPwAanr0EBqUTQxeq03v6Fwl
         o4WY8nlFpNQMzOb6fxRISKYUQ5xLxMgIpFBho1faGbpwmZrsyTk1vdZb/q3fEX0edvlG
         7I46B4VlmKvOQheWewoP6AsDkqkqDk71tzFI3jAN6zISJPThoGrxiTeo79m/oWrErA+Q
         JeMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784656117; x=1785260917;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ocH8UcOo4UY0LfArAy9N9P4eBtmhXMCHbqhRio/RB1c=;
        b=Vq7Junmp2nT8v8X022dj8aNkBQmLgwIq8sopzBiAQhRc3HAoEm6AKa287xeD6kbmg3
         ji2GIP3vPaHFcBPsAEjAZmwbhgUPHsWT38vuZNy64DN084OBFDCjwAIO4UuwLEJaQjWJ
         CU20qQ2tmQC8ekuJT5VfTcLDeyArlQdI+6SjZo8cEdynrWAUZkhnugOn+DVDofesgcB9
         MG+m/B6GjY9VwQ78OXSOe+qgIBmOrGp/z7dAWTsFEEVBOu9bS6kpjjWKwYW3LgbbSkWB
         uOVOOoNJMH9krufmqEL22p9bkSttSyrq/rHKu6dfk7ZRHGF7Lqa9SSWwMdGQ2OPsjZEM
         w5NQ==
X-Forwarded-Encrypted: i=1; AHgh+RpzgSVccsFAPlT8ghMfM1/xzh0kYTk9WKS3/WaxQSFNVbNEBzXAkqpwqheFn37j3Ry96v6Mc7yzKQ==@kvack.org
X-Gm-Message-State: AOJu0Yywmur+LJEVSjAaRUah8vNdOTFkqPjtP+/e10Li3wJ/E5hpzmXA
	BJeNlW6GqZqaI9lzqsQvSlZmHBirLrGtrRQJ+MgI9RtWw8R5PHZ+/E+T
X-Gm-Gg: AR+sD10DvZv4L5Yaq4snry9QjQYNQpJH3VpevZ7mSY9JPV2DmcKPpcPdX0pskYcPNyO
	9k4zXQa2/J8jLZdh7nugynL60e7QeWiHJ0LzdIE1YEjstJGkX67rGgw9vYpAS0EHsDorZfcDn1z
	Jwj94k6Tjo3ekWWUbtsGHUU4G8ajt6kUSp1yGwkQtzwtCUMV7cKH+Ev5U9a5uQlPL4tZWJVXUr/
	mJrez/6OmKCbTxvC6z6dwX9ZoRHOcQbnM1ZC9u/uqPZJIfDNuoZDbjJ5FnVCh4IwOd9I0a8Nn7k
	bfaStnILo4yXLjKLtAa2FzejynYqdTyH9wn5AnekX0iviR5Jj1zR9NR37t35D4K+HFDbWAD4NJv
	neSvEEfKRgW50MHX09POfvUdqlUogT3d/iUNEcbhJXF7m4w3ze4lbc2Ks282e3NSMG+cCFfdW
X-Received: by 2002:a17:90b:3ccd:b0:38e:11ba:992e with SMTP id 98e67ed59e1d1-38e4b57dd07mr19138219a91.35.1784656116703;
        Tue, 21 Jul 2026 10:48:36 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:68::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13ce29c2c93sm47964768c88.3.2026.07.21.10.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 10:48:36 -0700 (PDT)
From: Ziyang Men <ziyang.meme@gmail.com>
To: Shuah Khan <shuah@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	David Vernet <void@manifault.com>,
	Eduard Zingerman <eddyz87@gmail.com>
Cc: Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	Mykola Lysenko <mykolal@meta.com>,
	Nathan Chancellor <nathan@kernel.org>,
	linux-kselftest@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-input@vger.kernel.org,
	sched-ext@lists.linux.dev,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	bpf@vger.kernel.org,
	llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Ziyang Men <ziyang.meme@gmail.com>
Subject: [PATCH v2 0/4] selftests: shared lib.bpf.mk for building BPF progs and skeletons
Date: Tue, 21 Jul 2026 10:48:29 -0700
Message-ID: <20260721174833.1232771-1-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CE6B640013
X-Stat-Signature: djstizzg1hhro3utyy98x9z7c9tw646t
X-Rspam-User: 
X-HE-Tag: 1784656117-934959
X-HE-Meta: U2FsdGVkX18156YfdQ0t1Pit5DPmLiFyUd0eWx2FgpZCF6+SQoe7jSNQu3xja1HnKrb/RcgpDiQY0YwPSSFLCFwKeHLmnZSfl1h4MPF/1KoHqdmfi5r8Xniugbo3MREfjNpPq72rcavMu/DJHIBHTzIMCgQPvsacDJ4jQYJdwhd1fZ2Lqm2lEraeYlg9PD3ip9WhVvSjEnUeyC4s2Wnt2FGrgPmu8j+AkQgGZuCv0nNREp9e/iLK0cdBReHC8yv2YlmNTLmr/cTbC+VbOmt0288JxyhTSkchK/SpX2iwr1KOc+ccwaoR20pIMjU+8IY9v1TXrnRLhGgd50d27oPe/g4pTo8A85YkwT5393O32nShcfRpNjMXBByQVTyM6Da/4M0wDNNhDj7/bk9ILiI6L2WtgomwzA8wA0xEvCTAEBIJyjGP9FpQnQg11buNolPxi1vLW2BQveqjh0SaKwPi/gtJ5+4+jH4ML+6uip5ce/CbOOHHbIKC7TC5kI1y7oqMwteM6h2f1rr7c2YLFh4MxJd7u4fCGLxJtkj4nncXE5Q/JnoQa1JwMXOQZ5r9vre7aHiz/eoO2azKCijIyWo1gvQlcTiDegavQIjDLs54KY40bmG8YGkpmdKRIaLTau0dsah3IE5iE6ZNyS00pnevYY8FvTQ4Bjc+paokgv5PKKSWiY1o156L3ZW1ekS5lADZ2GuuVgkWw1s30XVCXZ1rNJfNrGcc2lnYARfNvNsEmUGgj7fW4pqnpQkCu19Bl0IkfkRr8VnlBMUuLXcYbEP1FefZpJTNLm6sXaD3YP2jLcV+LX9UWEvmAjaV/7N82It7q9DFL2As/t4YJs+4SaoX8l9IBWXcnKg4SA04x699o4Eg7pitOGzDkHy6QEF2eSntHI1b1WYCRfDESNXOUJxMfsMCGkDGT1aPIHdoTOOu+tNE2RrJWQocLVbkmRAJPX6g3y8yeLZFPk9+2Y6wmdI
 XKETdmRi
 lWt1ezefjOIMV3oHpFs4EXekjoT53AU5/H3HHEYAMPbeSp2/gZ+o1CYp/JKocdMH+CsH00wr3neVQZ2q7l3iVHo5zPas3NRTSKPJxrbdLm/6QCWwJjacn1vwY/Ld9vLi5FTVw3/3P2XRva1lHjDM0Vt8QOPgAUD30N/P/+rGFmC4qtJvwShommUlDD8qSSpUsitgqhoZMihbFKGKOE+5fJohkcdcmZgsE9L8qSKPniZXWJi7xbu/YPev6f/+l5EbVqQebpZ9vEB5MggaNfkrtc5BTnHqcKHKUxQzakem3PwH5e5DYsg1fwgPn5dtQCUJGx+LPkMlZ7KD+MAMEXig+djTyS8nM5apnCQaTDgmGhOSrzPO2ATFPfmiUkM37SbnoG8oqxV2+UNTd6hTvLfJ8XRWr/DLIukgGO15sABFHF65aAilFubSkNOoZAJ9j63kkvJDDFn08CLA/U7RRq4Efxlta6X9Vf0EueYHZQWHC6qukc5Wy2O54gJ9O/CcltyCJffagAUvhWp4oIMaoJWlQ2hjVmYfwZv1Rp/7NivwXBfSpqRWtvt65ZsZQ4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series re-factors the bpf-related toolchain for selftests, which
currently duplicated across selftests/{bpf,sched_ext,hid}/. Unify them
into a single includable fragment, tools/testing/selftests/lib.bpf.mk,
and wires up three consumers. We believe this will simplify the work for
configuraing selftests with the bpf, for both the existing and future ones.

Patch 1 adds lib.bpf.mk: it builds the in-tree libbpf.a and a host
bpftool, generates vmlinux.h from the kernel's BTF, compiles *.bpf.c into
BPF objects and skeletons, and exports the include paths, a bpf_link
helper, and BPF_LDLIBS.  Use can control the behavior by several knobs
(source layout/suffix, extra headers/cflags, skeleton suffix,
subskeletons, output dirs) that can be used commonly in general cases.

Patch 2 adds a new selftest, test_memcg_stat_cross_cpu, under
selftests/cgroup. This test is a memory-cgroup statistics correctness
test that compares the memcg BPF kfuncs against memory.stat over a whole
cgroup subtree charged across many CPUs, and checks the cross-CPU rstat
flush. It is the first in-tree consumer of lib.bpf.mk outside
selftests/bpf.

Patches 3 and 4 convert the duplicated parts in Makefile for two
existing duplicating bpf consumers, the selftests/hid and
selftests/sched_ext, to lib.bpf.mk.  The generated skeletons keep
a byte-identical public API and land in the same locations as before.
The folders build cleanly under both plain make and LLVM=1.

Changes since v1:
  - Generalized lib.bpf.mk (source layout/suffix, extra hdrs/cflags,
    skeleton suffix, subskeletons, configurable output dirs) so it can
    serve hid and sched_ext, not just cgroup.
  - Added patch 3 (hid) and patch 4 (sched_ext), converting those folders
    to the shared fragment.

Ziyang Men (4):
  selftests: add shared lib.bpf.mk to build BPF progs and skeletons
  selftests/cgroup: add memcg_stat_cross_cpu correctness test for flush
  selftests/hid: build the BPF program via the shared lib.bpf.mk
  selftests/sched_ext: build BPF schedulers via the shared lib.bpf.mk

 tools/testing/selftests/cgroup/.gitignore     |   6 +
 tools/testing/selftests/cgroup/Makefile       |  21 +
 tools/testing/selftests/cgroup/config         |   4 +
 .../selftests/cgroup/lib/cgroup_util.c        |  48 ++
 .../cgroup/lib/include/cgroup_util.h          |   1 +
 .../cgroup/memcg_stat_cross_cpu.bpf.c         |  86 ++
 .../selftests/cgroup/memcg_stat_cross_cpu.h   |  27 +
 .../cgroup/test_memcg_stat_cross_cpu.c        | 780 ++++++++++++++++++
 tools/testing/selftests/hid/Makefile          | 182 +---
 tools/testing/selftests/lib.bpf.mk            | 247 ++++++
 tools/testing/selftests/sched_ext/Makefile    | 153 +---
 11 files changed, 1275 insertions(+), 280 deletions(-)
 create mode 100644 tools/testing/selftests/cgroup/memcg_stat_cross_cpu.bpf.c
 create mode 100644 tools/testing/selftests/cgroup/memcg_stat_cross_cpu.h
 create mode 100644 tools/testing/selftests/cgroup/test_memcg_stat_cross_cpu.c
 create mode 100644 tools/testing/selftests/lib.bpf.mk


base-commit: 6eb8711ece2ce27e52e327a5b7a628ed39b97f45
-- 
2.53.0-Meta


