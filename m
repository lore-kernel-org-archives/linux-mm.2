Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEFBAC5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 07:58:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7C136B064A; Fri, 14 Aug 2026 03:58:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D33FE6B064B; Fri, 14 Aug 2026 03:58:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1B5E6B064C; Fri, 14 Aug 2026 03:58:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8FE3D6B064A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 03:58:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 22CDAA2A9F
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:58:41 +0000 (UTC)
X-FDA: 85099123242.03.D39A857
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf19.hostedemail.com (Postfix) with ESMTP id 722341A0006
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:58:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Xvzkt9N/";
	spf=pass (imf19.hostedemail.com: domain of ziyang.meme@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786694319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=P7NJF3oq4Hw+2dLyF07fyfL2A6PD1tYu7/+/ryOQgrk=;
	b=3/NXUCahXkCRw+c3CaXrMP7u5ywBSYKBYjC469j+klwsuly9JXGJlBUEf5jwvruVie70jy
	egI93Kwl91V/gkqK6xg5C1mFFsM9L1Xkd2cPlvGztMAn52QmUv/c963oPFGMvAHxdqWt7L
	anspbvIqpHFBbrAKpuE8Rf8+4Ea+cbw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786694319;
	b=4gNTOmjCSXFPDAvmfl5NwUmgd1SIctrNRsByR6jheR64h2hNayKRRyJvNVHDTZujrZ57Io
	HLUUEANGdHm3N7UMMQlgDVu/NQbFzP9TqD+LsjAdWlkvSub8t851I3Qoc4G9WUK2aIEWyh
	nQCjrlBXL/0aByKFvGsF27/hvOM7JSs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Xvzkt9N/";
	spf=pass (imf19.hostedemail.com: domain of ziyang.meme@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-66b35d2c4edso1001573d50.2
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 00:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786694318; x=1787299118; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=P7NJF3oq4Hw+2dLyF07fyfL2A6PD1tYu7/+/ryOQgrk=;
        b=Xvzkt9N/OJSixjWz71n2aepojF67wDHnOH0AH8uZj4DrA2IDUcvMwLWG24EtfYH3nl
         WcCDTNh9IxQU8XLkGH2r6xToC9MPFpBSnaWh0dBrgGhRgQaF5YRHiSwkfPzQPyFZpxVI
         YiyHqLF4pzBOkp2d70DZ/BEcripNRbjEWgmrWAy3uvGa2VBEfLtzK0H2YpLDsPr/9dP6
         dFo+sXvdM8roJdbYn3zo7vEYBnWXS9HHi+dY6h0F5Vzapg9ff9cAM7Kl44RLFQF8lkv+
         jKr2E8W1/saoDadqaJdXrxcPnhv1UB2ZyQbPpt9Oc+9YJQS4VXKv79SC7ASzr0zg1YGz
         9TsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786694318; x=1787299118;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P7NJF3oq4Hw+2dLyF07fyfL2A6PD1tYu7/+/ryOQgrk=;
        b=OBU5CkvTIrZihcelQN90a9hi9xD7WDZZHGIJYeRlFpxJeruGiBNLG7qJiLEJ8sx9zg
         ya18dnDdpgQMjUPqOk4xDfyNpFbsi/M+IsZvzcdFn+rDJ/rHNzGIvPQFRoFj+enVuqOw
         fzWAHiUcadLyH9xliBU6C+CuKcJXkjFfzfog6wEwAK9g/EAQqItmqwNlEWx0wmUEVdQ3
         3PhlDOrdpBXUbK2BkdgFY9L04njDOl4ZeDlyfAyin+D1dLZP1sFoidTO2lGqur1UUulu
         uvElGERmd6irexy5TfEwNK6ovW/yLgbJZ2YBOQBlXPYt4wgDJi4LBD39rV6B6mEo4tDF
         Up2Q==
X-Forwarded-Encrypted: i=1; AHgh+Ro7kCxo43hLHzTCy+opCmtN0BUE56BGP+1l9AXYACMXSVicAfgjZ30P9ArTwRU8n4W99cah3E/bzw==@kvack.org
X-Gm-Message-State: AOJu0YzPi9Zo8ozffy1rFpucngHRG28AIjkxITZW/OjD3ZOZbwFk7c03
	gX86bOOS3BHfHhbYQeo0yBoUaqn82KuTI2sOOeMBXEyuM48XSo+7GLG3k4jT6GbX
X-Gm-Gg: AR+sD13OihRQ4GzuE7ZMg3V5kZPf4paf+t39UBabQRe16aNXJAyeraLa+GBJH9UobWN
	JUOYsle4xBz8R74P03F14hha+MVqImFzUaAlz8Mgna50hzC5Tj01TwaTmHmQGd25Uvg2wVumrTB
	hO+G6PEtwGzH5qWk5+qOVzTSgE5RiZByNcFU+FZ01iK5GWaqegYenGhe7+J2EQ2rW7j6Zf3D8P/
	1FaLEgLRVYBvsoRgUAK2VDUeSj3Ro7OyNYdFRCIPxr+Bw9lkNJrAMiT0URyMuqNFz9vFHQ/KYGb
	/pYuXDAgPZ5muEQWeB1LNxYur6VGH8BMgggU6wcY2WQ4IG4VRNgZgBANJlSBo/Mu8dUEOwl9V1B
	mZD1AJN7FYcNQ/tA8+rRaKHVHb4GvQRArncAeH1tqv7c4it0Babz5ogCspT85EgMZCmtuplI1i3
	5QKb1m1hz6cKkEOMke05ZtCN1GXoZJ1PUMNdxGDBY8GuDqrq58AO25+nQ=
X-Received: by 2002:a05:6a20:748a:b0:3c3:a9e1:a819 with SMTP id adf61e73a8af0-3cc71fb5781mr4100219637.24.1786693870755;
        Fri, 14 Aug 2026 00:51:10 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:68::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-141387c6f95sm9201342c88.6.2026.08.14.00.51.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 00:51:10 -0700 (PDT)
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
Subject: [PATCH v3 0/4] selftests: shared lib.bpf.mk for building BPF progs and skeletons
Date: Fri, 14 Aug 2026 00:50:50 -0700
Message-ID: <20260814075054.507089-1-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: k51559am87o5ojt7um5pukg6spw54f8m
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 722341A0006
X-HE-Tag: 1786694319-434778
X-HE-Meta: U2FsdGVkX1+xk5PsU084qw/SEWyoyEwqO+P5KXNMlhTr3UiTAF0BDmjI4bABZOLh6Jmnmv2UcnULPaXYYc/rogJC4JrIcQCbgPtnUPJrgbmm2SF/3s8tLJpeqvYsZi24OUi51ZOEEM/DdLQxf8b0vClN3YrRoa3DQQ6ORvIEaW3B6zi8Hp21sWWuRSTiMAZKm+e6D/h1F0prSak2S3rO4AuXGUB8atkUEFY9+jlDWx4ubINLp76A4HqhU/4XFIV1MkOt69VWzA65kr1Sa1LcfDsfcqWJVpf4sxrd6ra5ZVIhsNoGS1VlNbGFKRXsPuSw+O+A6bD0GzTslx1SPkhMMiHxaINGwTrn5+W6MbOL5awopel9tGESeSG34+I5CsZ87YsYxzLR02gTSX0BwTK65/m5PEb0RfQ/wdx1kWmhrEHqt6orariJJGuiBvuj6t/rym6ufj+IzxopEmJzz60EAUFiKWtEX2vWbXy3KP0c9cNDvi+UPBquLPyJmM+ex6PymEZjCuEttCuf7f0QmLJbqddMTOCRi7rYcI46gle8Qjt8xixKJEco8gNHmpFdgXGiT3As+uvR4QVtLxUS9d3MNCQcYdsFWPo33LCa78QxEbc0d+WleNL/FZvUrKhiB9xjbFbDxMEUGlBZ1pZzzQRwQ4lg7HNexSdWpxu4FVXIZPnpHNbx5YplZ6gyJBtUWX4RLnAsasVG3fPS0dGnqhkirDsG57YvSrzRfiM8JY3rrFiqhlpJpQG/emN4qBwnkyLW1WemX7/1FeEpZVz73Ez0cx0aY9pNXWb/EF+PxMKNaSDb6YFcTBgFCsqbGhn0iAttV/TZqsx5Ec5rzWEr8h1DHfk/BMKqBB1DYQmYeclyPbJLsWSQoGw8xF7ATE2sgGnnSxVqUQ0IGrAANvdZvaf1tyaWbKSv41x2h2dDBcQl5jtUWlNvnGEsb3cASCOC54XCfJWU22O9V5iR+b8UjD6
 M2fz7YZj
 TEO96YsbCnhSeuMBWavXgj2vtySQQUAY3mPpYQfHxRCslMunKCwZprN0tL/dQVz/QYCG2VtZYsucxAoFpvogn0e+Y5KYJEfOk+w5VNMekAV/D4Hk9yQsN4PnhVi8J2wCm70zlOPxC9PlGO1rYZG/N0DRA+PmLlElxeY8VT2RQ/mCb019zj/xjY90iD3jbOZlV6PmS8vPdSK9qiyfZvzXEd1O7eEUJfy7TSG/JV6nA7KKGvCj+4h4S9kcMNpV2OGY5d2Ih0f7CZigoRfHgHc5J0PL/adQJbzTsP+PkyJ/gh8rTaALsfxznmW4t9MASkh1AVIo5q55rw6BRrm44iUxgqLwKIa4uoGggFhBBmUZcjvwhKRTEpjBCoU3mmN9xhGHDBddUWUfFTkeHsFW7nuzyGe6zwTFTt4vNUrL8cdE9vogGOjGZOZ2t5r0RVtEJxnnYeCTgGvMSwQH7QgcDV685uCPEDpZeuRhierdw9BBoTzzcJIuJnGnKjusv9ncF25VqrXbryMdrAUKlp19/OM73JUw0eExL3+1+sqVE+VsOGBzkw6GYm83Vjth9VA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series re-factors the bpf-related toolchain for selftests, which
currently duplicated across selftests/{bpf,sched_ext,hid}/. Unify them
into a single includable fragment, the tools/testing/selftests/lib.bpf.mk,
and wires up three consumers. We believe this will simplify the work for
configuring selftests with the bpf, for both the existing and future ones.

Patch 1 adds lib.bpf.mk mentioned above.

Patch 2 adds a new selftest, selftests/cgroup/test_memcg_stat_cross_cpu,
which checks the cgroup flush happens correctly by comparing the bpf
read value matches the file reading. Existing test
bpf/cgroup_iter_memcg only ensures whether the number is non-zero, which
is trivial in some cases.

Patches 3 and 4 replace the duplicated parts in selftests/{hid,
sched_ext} with the lib.bpf.mk

===
Changes since v2:
For shared Makefile:
- The lib.bpf.mk now use the USERCFLAGS (and USERLDFLAGS) to extend the
  CFLAGS and LDFLAGS. 
- OPT_FLAGS/RELEASE and EXTRA_CFLAGS now reach the libbpf and bpftool
  sub-makes as well.
- One rule per BPF source instead of a vpath, which is global and also
  applied to the caller's own %.c rules.
- HOSTCC/HOSTLD come from lib.mk instead of including Makefile.include,
  which also rewrote the caller's AR, LD and CFLAGS.
- A missing vmlinux is reported by the recipe rather than at parse time,
  so "make clean" still works without BTF.

For cgroup selftest:
- Only one cgroup tree is created, one flush is performed, follows by
  bpf read and file read. 
- More common cgroup functions e.g., cg_read_key_long() and
  value_close(), are used in the selftests.
- Use cpu_set_t rather than manually allocated cpu lists.
- Use test_memcontrol.c's anon allocator and moving it into cgroup_util.
- Other suggestion from the review.

Others:
- Bot reviews are fixed.

===
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

 tools/testing/selftests/cgroup/.gitignore     |   8 +
 tools/testing/selftests/cgroup/Makefile       |  52 ++
 tools/testing/selftests/cgroup/config         |   5 +
 .../selftests/cgroup/lib/cgroup_util.c        |  83 +++
 .../cgroup/lib/include/cgroup_util.h          |   3 +
 .../cgroup/memcg_stat_cross_cpu.bpf.c         |  86 +++
 .../selftests/cgroup/memcg_stat_cross_cpu.h   |  21 +
 .../cgroup/test_memcg_stat_cross_cpu.c        | 596 ++++++++++++++++++
 .../selftests/cgroup/test_memcontrol.c        |  29 +-
 tools/testing/selftests/hid/.gitignore        |   1 +
 tools/testing/selftests/hid/Makefile          | 180 +-----
 tools/testing/selftests/lib.bpf.mk            | 296 +++++++++
 tools/testing/selftests/sched_ext/Makefile    | 146 +----
 13 files changed, 1204 insertions(+), 302 deletions(-)
 create mode 100644 tools/testing/selftests/cgroup/memcg_stat_cross_cpu.bpf.c
 create mode 100644 tools/testing/selftests/cgroup/memcg_stat_cross_cpu.h
 create mode 100644 tools/testing/selftests/cgroup/test_memcg_stat_cross_cpu.c
 create mode 100644 tools/testing/selftests/lib.bpf.mk

-- 
2.53.0-Meta


