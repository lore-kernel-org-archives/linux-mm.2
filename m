Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8861ECCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 04:55:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBD4E8E0008; Wed,  1 Oct 2025 00:55:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6D8A8E0002; Wed,  1 Oct 2025 00:55:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B83948E0008; Wed,  1 Oct 2025 00:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A43CF8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 00:55:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5BD6944AA6
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:55:13 +0000 (UTC)
X-FDA: 83948331306.02.D928252
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf24.hostedemail.com (Postfix) with ESMTP id 875B5180003
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:55:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=So8vnSLZ;
	spf=pass (imf24.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759294511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ri7WDt45zmQrzY579qfISU4VEl3xx5nuQVZaGHjeynE=;
	b=QPdGDKIiF4xm7vFluuTY5d4N35NOiSc1okizqAejj/xt+42JGog8gAEAQ6cG1DTTjlweNa
	cwd07lo9g048VehS25tAopVeNx0AAvB+pBXvIL8pIXvzoNbnJul6U+AY4jnZdwCfXpFHbj
	Dc7x6mugAs6/IRXoTo9FpY2CEizc4nM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759294511; a=rsa-sha256;
	cv=none;
	b=73mqmZCzgiE1ELBWHca5Rd5DNQbAN4i5TGIeYSRzSJMKT1Ca9tOqQXwhT8DcAkCM6Iw1hh
	xaWbUGrex9W9WjTixkBWZKGn+ijSu4HAPZpHAdSe4h4rHz/qpYWzrk+uY/dFB8cdHwOlPu
	bvAGyUL2eo/iaJs1I1ezQhQfKyJsdFQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=So8vnSLZ;
	spf=pass (imf24.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-76e4fc419a9so6932261b3a.0
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 21:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759294510; x=1759899310; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ri7WDt45zmQrzY579qfISU4VEl3xx5nuQVZaGHjeynE=;
        b=So8vnSLZd29C98wQMg7fLzqhj5bfQVJ8GHFfcr8BYL06wKRWfQDItkbT/w5SiJzffO
         VZIVS36mHpGNKDYROqcvhFnWoKEVXRpDt+IasxxZqifQXJ5i3liZejVRo5jTKND6Hucc
         5Gijc3ScVj5PHztDCXfYpyXymXmcfTUNiOQOrh71bAL3xGwofDLHnU9QzN97W4aFmKDQ
         0RMHw/YNqJJs1QFEMkQ1rLXwgoXSpygt8zRprYxDJZP2sqEPy0jw4IBSqUeOc+AQCLxz
         bnDc/niWtTOs7s36ZKcTLz2fm3U3tnPerZEcDuPvo/KHY1IC4wIhPuRUKgNOvLWP4+Z4
         SEUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759294510; x=1759899310;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ri7WDt45zmQrzY579qfISU4VEl3xx5nuQVZaGHjeynE=;
        b=EQb8EPcVAEEOi5kFFG89wyG1GnpiRfpzgXlx1aH3YecGtGH7kEvKaWrc+my+3ZEAAJ
         Q5r/um+t+Fm5MaISyTaHpE4JPADsLNzgPBDhSqoS2GscZBF703jbKNKFcGUDl+sPPRU5
         gVCzCD3lqxFx+jNpLaMmHzRTZQ4spQLDpget0Qzz7bQFoTLhyWu4k0Fq4tAVcwp3u8gn
         yncaEf1AbQPBwbZ+UimPC60tOwX2KY9JKLDZ98Ot7qLbq3czV1wmwA3i+xcCjs+mWKCo
         /xSVcKzj1VImNRyPrnats5DdyWqy45OeTcPrGsJQHaFJnYochEffIL4y/YgbUaD2GPtt
         bxUA==
X-Forwarded-Encrypted: i=1; AJvYcCUW8cX8pyyMHpl0n+BWPNuel08ysBPpBZHMcCdOCqB/QWb+sH8mznybrvdPkBgsexp1SmGbmvt0fQ==@kvack.org
X-Gm-Message-State: AOJu0YzgriRqcIjerKqreh3+rQJ0dUzeN3vq5la+7PmIVblWJg7L9qek
	2k+eYglRwqqyuNpvWG/8QMzjTV9C4TNr3b/udNym5aFOymMGZRDIQOuR
X-Gm-Gg: ASbGncuI9sazOGU1XEPqjgmZj3I7JyZsKW4jQjid5LLldAhaPTV202KtriHfuNc7F35
	qdEHCVLpM8VlSWEk2T1Yb8BOV/vEzHO6sQWPMY4ecdq3MGQHOWNPz2jU8f0Ge4Znq+dAMVtE7m1
	zryK0tyxP1nGSwHzsUMMsNjZA4Gw8gh0a4Qqbp5uK27m/SgUMT1rweqYQbPg14aIlC+YIZBK5L3
	bnPQp7AZq2PkM79bUWlcFxjwcQ73e6Nk6flMFnEkVol3pg0jyBo4B8PYVopjzjqkw4StkLpeDCR
	71Olwy1kQflJdz97eJTXNfb48Q16PA4kQV4ibgLaSclfEudLNxEcPUG3Vlq6Yqb5K0ljWC+jpBT
	rXQMTB/ys0p35ckW7GY306nYdw0mLVrm4oYZXL328u66AjihDeZuWhfK54q4YrbOJnJvxTy0JTA
	==
X-Google-Smtp-Source: AGHT+IENg8JFMQAvrh08OsAp21v3nqidKkwtj7VlhXv2erEQYAsK9Mahy8m3QZfWW4FUYn06+OTIZQ==
X-Received: by 2002:a05:6a21:99a6:b0:2bd:2798:7ae7 with SMTP id adf61e73a8af0-321e3edc8cbmr3372698637.31.1759294510242;
        Tue, 30 Sep 2025 21:55:10 -0700 (PDT)
Received: from jpkobryn-fedora-PF5CFKNC.lan ([73.222.117.172])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b5f2c1b7608sm1011996a12.5.2025.09.30.21.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 21:55:09 -0700 (PDT)
From: JP Kobryn <inwardvessel@gmail.com>
To: shakeel.butt@linux.dev,
	mkoutny@suse.com,
	yosryahmed@google.com,
	hannes@cmpxchg.org,
	tj@kernel.org,
	akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH] memcg: introduce kfuncs for fetching memcg stats
Date: Tue, 30 Sep 2025 21:54:56 -0700
Message-ID: <20251001045456.313750-1-inwardvessel@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 875B5180003
X-Stat-Signature: gxezn83wrykw67ftiedojyhiidy8oa3c
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759294511-766893
X-HE-Meta: U2FsdGVkX18qlT/tIiJ1chuAswdTYWuOtoIn0jq1lujC5UJkKrIj7mAYfyOe8UBpbCwHN7XG4s5YSE63iYeB0kyu2HDt08H5fEhRF8onyrg/ZLa+9jrZD1qtGEVBMWLl6RJnCWvFoBBUIQlI/SMSxCOPsPIsrW+X7VqyQ7D2+nY8RikNBl/k94hMhAwGV4BWRVUJlKTSAKlaTHeqVAOTDLTB8ShMiZp8tMPBGWc0V/lpLbbMW6qIPetTrtGtoPm0kMgjvfe+1ev3JrAdFKA4PzkLZ2X5GfMQncJZvtAu9tNkf7S7x4ixf7aR/FpMi+VFxhFvRhPtieL3vbfGd6bFwDmlmeWgt28VqnUmoWEw69Z0FwbYdGyttF6kY4UTmx15Td0NxwWKpWMFcoSUM05TntU0d7oQzQz2Mg1rOiGyEgNMGP+J+42fCqZqadcC1VUW93vlFeBkiboNv1MbQ9Tz2QrFxgQTGKnXUvUgSYlENXaq51VXT6b8IYUHwzncc+TyjPf7k3gBT+EYcU2EB45FZG/O6QMdBWcF3+ID56Hb+WxvT1Q7k/M6hbxKC/Hd5H9PvYR0vd0JQt+0C2WUxq+cNUg8ZyXBpIbsbK8hOVUDfJyRbLg9zXucJlI4K3UCczXJyVC3s2nOqOdu/YjdhtEBTM/pA6xUkymD8oJHWz0+Is05NI5wq5vMH/DpYIGvns3hG3/+bGzIZyTTMjSCMldGyz+qTy36NLQ7OGeugzlp/ttvCnSinZ8mnLwXPq5NZ2uwqe1eluF8cRwPR9bSiwNrelGBGRK6TL82lAdFYSbAXxMlq6Ummnrk94UiZn0nh7LKTknUOg+IfcnmUmjryWtxYAal8mmm+edGGx7x0NapXhuMvtlOKmA55GDnuECcQZ9GNAtNBFqrX0qoUvHSEYGpfUm6U2TIxAsLsjWcci5/hoyTTsRYMpME55GI7Z7XbJYGYbDT7sxJJcp0epG5LQc
 YIoT66pB
 7PNmTYoB+MXO+JG6h+qium0LVVGsKQAjLluszzsAbnyeoUPzQbaMlDGeXvvK0hPvwWFNuFm2KVJCeHzFho/m3ByKXpZBCWlM6QWUkdHS/1QeG0OJmwYf3YolGMHl6Vp+syUEIwjfNbb8fPtgZ/mVnlkfgZSvjoxSr7FqMKppF7r6k+AuPyTBz2KO/B8WXSDViv+AHyBxtKyvnJXuqZKbeen7msIcpBxPGXXmrFnevM3wCdLIlweJ7iwlmZMNaQOMtr2K4idTiYveJ/lwNehnQRJmpKNxzCCM5/2R9LY+0hCHxHlOZ3Qyls1k+AJuYeqLC2595bwCCn4gMs5iVbtfUTDbI+kyPQ6kkAQzBQ2nEmWdtFTlMuzQ6IFtbBGpkwp960vaU5DFP1Yjf84QHe3MVhhgVXcoAoTgqyvBqo7BY911iCUogLayGA+ozyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When reading cgroup memory.stat files there is significant work the kernel
has to perform in string formatting the numeric data to text. Once a user
mode program gets this text further work has to be done, converting the
text back to numeric data. This work can be expensive for programs that
periodically sample this data over a large enough fleet.

As an alternative to reading memory.stat, introduce new kfuncs to allow
fetching specific memcg stats from within bpf cgroup iterator programs.
This approach eliminates the conversion work done by both the kernel and
user mode programs. Previously a program could open memory.stat and
repeatedly read from the associated file descriptor (while seeking back to
zero before each subsequent read). That action can now be replaced by
setting up a link to the bpf program once in advance and then reusing it to
invoke the cgroup iterator program each time a read is desired. An example
program can be found here [0].

There is a significant perf benefit when using this approach. In terms of
elapsed time, the kfuncs allow a bpf cgroup iterator program to outperform
the traditional file reading method, saving almost 80% of the time spent in
kernel.

control: elapsed time
real    0m14.421s
user    0m0.183s
sys     0m14.184s

experiment: elapsed time
real    0m3.250s
user    0m0.225s
sys     0m2.916s

control: perf data
22.24% a.out [kernel.kallsyms] [k] vsnprintf
17.35% a.out [kernel.kallsyms] [k] format_decode
12.60% a.out [kernel.kallsyms] [k] string
12.12% a.out [kernel.kallsyms] [k] number
 8.06% a.out [kernel.kallsyms] [k] strlen
 5.21% a.out [kernel.kallsyms] [k] memcpy_orig
 4.26% a.out [kernel.kallsyms] [k] seq_buf_printf
 4.19% a.out [kernel.kallsyms] [k] memory_stat_format
 2.53% a.out [kernel.kallsyms] [k] widen_string
 1.62% a.out [kernel.kallsyms] [k] put_dec_trunc8
 0.99% a.out [kernel.kallsyms] [k] put_dec_full8
 0.72% a.out [kernel.kallsyms] [k] put_dec
 0.70% a.out [kernel.kallsyms] [k] memcpy
 0.60% a.out [kernel.kallsyms] [k] mutex_lock
 0.59% a.out [kernel.kallsyms] [k] entry_SYSCALL_64

experiment: perf data
8.17% memcgstat bpf_prog_c6d320d8e5cfb560_query [k] bpf_prog_c6d320d8e5cfb560_query
8.03% memcgstat [kernel.kallsyms] [k] memcg_node_stat_fetch
5.21% memcgstat [kernel.kallsyms] [k] __memcg_slab_post_alloc_hook
3.87% memcgstat [kernel.kallsyms] [k] _raw_spin_lock
3.01% memcgstat [kernel.kallsyms] [k] entry_SYSRETQ_unsafe_stack
2.49% memcgstat [kernel.kallsyms] [k] memcg_vm_event_fetch
2.47% memcgstat [kernel.kallsyms] [k] __memcg_slab_free_hook
2.34% memcgstat [kernel.kallsyms] [k] kmem_cache_free
2.32% memcgstat [kernel.kallsyms] [k] entry_SYSCALL_64
1.92% memcgstat [kernel.kallsyms] [k] mutex_lock

The overhead of string formatting and text conversion on the control side
is eliminated on the experimental side since the values are read directly
through shared memory with the bpf program. The kfunc/bpf approach also
provides flexibility in how this numeric data could be delivered to a user
mode program. It is possible to use a struct for example, with select
memory stat fields instead of an array. This opens up opportunities for
custom serialization as well since it is totally up to the bpf programmer
on how to lay out the data.

The patch also includes a kfunc for flushing stats. This is not required
for fetching stats, since the kernel periodically flushes memcg stats every
2s. It is up to the programmer if they want the very latest stats or not.

[0] https://gist.github.com/inwardvessel/416d629d6930e22954edb094b4e23347
    https://gist.github.com/inwardvessel/28e0a9c8bf51ba07fa8516bceeb25669
    https://gist.github.com/inwardvessel/b05e1b9ea0f766f4ad78dad178c49703

Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
---
 mm/memcontrol.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8dd7fbed5a94..aa8cbf883d71 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -870,6 +870,73 @@ unsigned long memcg_events_local(struct mem_cgroup *memcg, int event)
 }
 #endif
 
+static inline struct mem_cgroup *memcg_from_cgroup(struct cgroup *cgrp)
+{
+	return cgrp ? mem_cgroup_from_css(cgrp->subsys[memory_cgrp_id]) : NULL;
+}
+
+__bpf_kfunc static void memcg_flush_stats(struct cgroup *cgrp)
+{
+	struct mem_cgroup *memcg = memcg_from_cgroup(cgrp);
+
+	if (!memcg)
+		return;
+
+	mem_cgroup_flush_stats(memcg);
+}
+
+__bpf_kfunc static unsigned long memcg_node_stat_fetch(struct cgroup *cgrp,
+		enum node_stat_item item)
+{
+	struct mem_cgroup *memcg = memcg_from_cgroup(cgrp);
+
+	if (!memcg)
+		return 0;
+
+	return memcg_page_state_output(memcg, item);
+}
+
+__bpf_kfunc static unsigned long memcg_stat_fetch(struct cgroup *cgrp,
+		enum memcg_stat_item item)
+{
+	struct mem_cgroup *memcg = memcg_from_cgroup(cgrp);
+
+	if (!memcg)
+		return 0;
+
+	return memcg_page_state_output(memcg, item);
+}
+
+__bpf_kfunc static unsigned long memcg_vm_event_fetch(struct cgroup *cgrp,
+		enum vm_event_item item)
+{
+	struct mem_cgroup *memcg = memcg_from_cgroup(cgrp);
+
+	if (!memcg)
+		return 0;
+
+	return memcg_events(memcg, item);
+}
+
+BTF_KFUNCS_START(bpf_memcontrol_kfunc_ids)
+BTF_ID_FLAGS(func, memcg_flush_stats)
+BTF_ID_FLAGS(func, memcg_node_stat_fetch)
+BTF_ID_FLAGS(func, memcg_stat_fetch)
+BTF_ID_FLAGS(func, memcg_vm_event_fetch)
+BTF_KFUNCS_END(bpf_memcontrol_kfunc_ids)
+
+static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
+	.owner          = THIS_MODULE,
+	.set            = &bpf_memcontrol_kfunc_ids,
+};
+
+static int __init bpf_memcontrol_kfunc_init(void)
+{
+	return register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING,
+					 &bpf_memcontrol_kfunc_set);
+}
+late_initcall(bpf_memcontrol_kfunc_init);
+
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p)
 {
 	/*
-- 
2.47.3


