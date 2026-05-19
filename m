Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C826CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 01:28:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8E326B00AD; Mon, 18 May 2026 21:28:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D18686B00AF; Mon, 18 May 2026 21:28:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB9426B00B1; Mon, 18 May 2026 21:28:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A1F726B00AD
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:28:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 514891A0136
	for <linux-mm@kvack.org>; Tue, 19 May 2026 01:28:00 +0000 (UTC)
X-FDA: 84782433120.17.73809E5
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6CAD040003
	for <linux-mm@kvack.org>; Tue, 19 May 2026 01:27:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cruqIgUZ;
	spf=pass (imf27.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779154078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TWeQWtJQMxeeRXnY89NFG6LDLskX6Fx4PPSnkyRbsAw=;
	b=sVvlZXkBfT7aEFLZwglTOmkFjUvtnenxCr8+lgGaMI6xItuqVFvgyZZ5gkWAod+kJjfCum
	8e9tQI0tSCfdkKOUcrqhSuyk3tUkBMFJTstbLxdUyu2NGwBifWSQbeHcByQP/xgojfAVmP
	B25KjvV8uvTBDng0XKhi/8LkjaFZjHQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cruqIgUZ;
	spf=pass (imf27.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779154078; a=rsa-sha256;
	cv=none;
	b=S/SOGjbNSjZ+Y/dG1aPKHGrwaCb7NZrHlq2De+m9ZckUaNHcnlSkxwHxmyfVZrJENtyee3
	KxCa7UzaiNNgtWbKiiL/tSRFceUuohBSzdeeqaLyKzbWI763TCeKqaFj3t5J2ocdQUx0jX
	tZoRJaoq80J6RywhhFegfDjoY5HGA+A=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48fe26a177cso20825405e9.1
        for <linux-mm@kvack.org>; Mon, 18 May 2026 18:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779154077; x=1779758877; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TWeQWtJQMxeeRXnY89NFG6LDLskX6Fx4PPSnkyRbsAw=;
        b=cruqIgUZQ/LZfPRqwR5smuGbEcLbBuyCRdYFG/MQ66oRqIldM+LVV2Ty6aOQTlV+Vf
         k3srHbEypWX+hZ/VKMyDPlIARfbsm7ubxXtYkcpAux+yzNse0nPY5jN/lfSB/PssP114
         +o5chvZz6tGd2jebPihAXExHIMsLqd4s0XwG2Ft7KCYXWXESCBtgZkkGRrh01PM2bnBg
         sLhMXpkHngEwdj1XJP7x0APAqE3dXlKx6+sduOPkCrDmfAR/xp7bGFHVQk9GBWtcdKos
         f4jak8Zj63v85vMFhWTnz6CkxALJowCL2uX6VkEL9fFggu1+t2xAV/RCBNyWb7jgVDLY
         7ZNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779154077; x=1779758877;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TWeQWtJQMxeeRXnY89NFG6LDLskX6Fx4PPSnkyRbsAw=;
        b=ONXm9AR55PPHiWUzLC1LKASMZdaH5rucSrHxjFSuWnFJuuxd7aSFTyfEyve9LQbfMy
         DEtrjYfwYd/KjTWGg+WjXNdtfDYfIngIcAd78xafcsJJZLEJJd4MyzYLSXcBM7aPvj4h
         ySJ3mq72sUceNxuqF8Zc8s1jpIyl/a2mzjA7bOOVW90EXHlcUEVyHkExk58ubhvx8kqk
         LKBVJrTC4B0eJ1y/qFbwaKcVXGOAZDn4BTx1IFIzzbZoetl2YbS6Hyt1LVLUYTIZc5q5
         5xlpY3dhCSc2Vr1hHsQjtt5fYfscFL7u9xLS+aDhl56H22+g71UENxBZtf7Pcrf4IPvk
         J/7Q==
X-Forwarded-Encrypted: i=1; AFNElJ+wXgwZmlPw1KyMVxCVZDz/2n8QZj5DtL/Td5WIY2OtRv+5QLxjY9bgqxLacovyDNiOdryTJ2qshw==@kvack.org
X-Gm-Message-State: AOJu0YxQYUGAnP00bzDA67mqhGf91RSrraUsFWs3BShv50JFQegw6xNc
	A3LiqY9s2TT7BciWEjtIDy7fEz8ElFkJK8oljLE6OqFaHJGWo5gRl1R6
X-Gm-Gg: Acq92OGNnp+iGK5lVhjRjzKVJ+1WpOoDDhsVDpGbF8kn+cu0BcZxqyRoLtfu147F3yI
	ttkPQxEAj40ZjKHYD8tMvREujtI540ldBvfXIeMSlzQMJX/VHb90SGVZbYTCvfuGXT2DqjJR1+w
	SgyvSlUme1NRCK9s9+isJ4PO5bSOilYDtCn3Lifepw0TeBDY8dgMWtFQ98iQ3K+frE0oPnvrtU6
	jGSmy6vEXSD4FKvEmVOUTgJFtJ/JsVHMxpxO+DKDaZ85Y7zCcYTqFHc0At+gkAf+CpaRFjfBYxD
	sSQfdD9UURiJCqWaaa/3+BcaEi6VrlWBxU3aWauqC3wbdLFea0IGowD/HggxM61zQfKfXHLyML1
	TgROQ2YWgEP+K43RE5tdMAMK3Za5T2vtnsHZHNMRFxsSj87XFPLGQQxrYWvlmBc8hYxcmQBNEaf
	JocX6qhKtQP17s4mC5e2m6S7uswZbpytWMj5Ch5Fri
X-Received: by 2002:a05:600c:1d0d:b0:48f:da34:ec4e with SMTP id 5b1f17b1804b1-48fe632343dmr250425635e9.19.1779154076414;
        Mon, 18 May 2026 18:27:56 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:f83:8501:800:cd4:5e2:9556])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9ed2f738sm40548683f8f.16.2026.05.18.18.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 18:27:56 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Leonardo Bras <leobras.c@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Li RongQing <lirongqing@baidu.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Douglas Anderson <dianders@chromium.org>,
	Gary Guo <gary@garyguo.net>,
	Christian Brauner <brauner@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Coiby Xu <coxu@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH v4 0/4] Introduce Per-CPU Work helpers (was QPW)
Date: Mon, 18 May 2026 22:27:46 -0300
Message-ID: <20260519012754.240804-1-leobras.c@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=9299; i=leobras.c@gmail.com; h=from:subject; bh=R2CXmKtrbnfFFYRwuiAv0qD3pZe3w4XoySXfZFi3yow=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLK494QflH1w7EaT7zmFI0+eT+DY+qaHmdulKf3ETu8UO 0mVSjH+jlIWBjEuBlkxRRbZR/NX8XyfknHkyo8FMHNYmUCGMHBxCsBE9oYzMlzmXGXIxl1sICwS V/dYPflDnvoXz8DbbLzKS6/dfhug4cLIcG3Zk327Kidn/WZgcMmNk3q/aJG5yrszGxu3Lsue7P3 4NAsA
X-Developer-Key: i=leobras.c@gmail.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6CAD040003
X-Rspam-User: 
X-Stat-Signature: tfx7xd54bzynr9ajq5714nf8aqi4bxn1
X-HE-Tag: 1779154078-616142
X-HE-Meta: U2FsdGVkX18vYV5rCM43x4juIKJvkmm3MKbLlF+ai+JV8Doe/5cmCJkZ6cCRyL2sKS9SAC5GvD4zzcDn8nUmxq8xI1FKs3ntqBD/FV4pryyRNW8ehuukyPSt0xc4FRH5uutnrqW8BBdRFpgPaw9sPwOgO42+jChipTArOY/VmcplgClbFYo4wHiLocKKzauYa/zg9svW0/8SWOyL+KwMJLG9Shvp9i2KkWyk0/yNY4YAiElM5Mdhu5ecQuTV8SYbAhuAPiRou0bAnACfkYh4EEKUraHWP1Vft575ewHF3qFNgv6yDtBftgGg7mReEFNeRQHrW19HbgBchnf9kBpAclwzgCyJK5bYuLmoJbHRSiMdzl5Adt9f7IpwFxZV2dr/2NB6g/N15/DkuaRvYagYbIoeOW6o37NB9D4X280rK0e8cEDtV5PyjrhfPoFFmEpwhDYvAe+ZbNnFKrqxgjsKoIfiqaCKgCg54jyn5Sl9nxD0Ft4y7tPHD9wylLMAp03MLB4b/0NC6PTksw0hPPul9pzqEPG2bWSxSU0jGaZMOfCO5BbRJabOwX/GjKNtMZib6g/6amWqGqGZ1ftV8s5NeY6nLzcVsWytP/H6PKw+iY379p0ZNGfne4iEAtPv9bXXFI7ToAM6kW2ZI9RkjXGam+QqFOA2Y9JkYr84Aw6Xq+XzQ6Beyh86OCHsJtyxzaTgJRCJzpXZ9ZcLsVYtfpIKzIMdWLdL6DmAqBaTBDrOtmOTTIHwUztu78WmV1hUWKEcOK4sWijrmGL4s3YbDaSQoKW1MUU+hWyiFK138xk7SA/IXltNci7ywfhjIpXsxjBH/fxNUTycPJ9/LQOPKYQrzctA7sC63stS1IXI5gxF3mlUxUqPPyyAylGTeg8SelrLxvoxnft5z8lHX+mLaDGgMCe4+7+goD2seHfhIp+7GKjvojZTVyesiGkSUmVsYIQF0bX649uAYfTgBuOzmUP
 az9xVxMO
 02BcEYZ7ERWA8shkp7ATVDRroQ6azrVgkpfV0fHzIAFsRn93130tzbvlLaTQL7fFJUbgsqut+BMcjUwTNDVOqumqiztlL/pD81n9cYWsKUIbsAs/EzeKRPWxtFXfZXpCSVu0uyGOisHM6XwHKZDtwW3RqRdFtn44rctjwQYmkXKP1CbdxYD68YOPc/RcHpqz6iWW1D97ptLx+U3lXHHCre0k/+Z7m8CMyPqUrCX+/tmfsACrcSAV2s0vSz3cfNFTOLzKlFCou68c9krAWWmnOtBlFX+PcoO8WEsakiihrfPweKnMl+1NlBRkrOouBRTePej8JfcynAU+93ky1rWpY82aPUFOZu6FBbyzAURgB7jsqB8XlZW9fFqbkaO+0GQrmc5GxqZtezqdoAzI9F1Nfb2pc3qYtcKrhnxWrWTrttvVwc0z7KuBy81IRPw0r9fwXNX2EFL83EFgTDXaNDGC8a2JTiSyI/3KbZfTBqrgh06YCE6kqbd86TTrbWWddEr2n0m3gyuePZnXmpTVfwmj1Rk7SzTQA0GgjypXN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The problem:
Some places in the kernel implement a parallel programming strategy
consisting on local_locks() for most of the work, and some rare remote
operations are scheduled on target cpu. This keeps cache bouncing low since
cacheline tends to be mostly local, and avoids the cost of locks in non-RT
kernels, even though the very few remote operations will be expensive due
to scheduling overhead.

On the other hand, for RT workloads this can represent a problem: getting
an important workload scheduled out to deal with remote requests is
sure to introduce unexpected deadline misses.

The idea:
Currently with PREEMPT_RT=y, local_locks() become per-cpu spinlocks.
In this case, instead of scheduling work on a remote cpu, it should
be safe to grab that remote cpu's per-cpu spinlock and run the required
work locally. That major cost, which is un/locking in every local function,
already happens in PREEMPT_RT.

Also, there is no need to worry about extra cache bouncing:
The cacheline invalidation already happens due to schedule_work_on().

This will avoid schedule_work_on(), and thus avoid scheduling-out an
RT workload.

Proposed solution:
A new interface called PerCPU Work (PW), which should replace
Work Queue in the above mentioned use case.

If CONFIG_PWLOCKS=n this interfaces just wraps the current
local_locks + WorkQueue behavior, so no expected change in runtime.

If CONFIG_PWLOCKS=y, and kernel boot option pwlocks=1,
pw_queue_on(cpu,...) will lock that cpu's per-cpu structure
and perform work on it locally. 

v3->v4:
- Mechanism name changed from QPW to PW/PWLOCKS. Helper funcions / API,
  file names and config options renamed accordingly.
- All members of the Per-CPU Work API now start with the same prefix 
  (Frederic Weisbecker)
- Improved style a bit, reviewed documentation

v2->v3:
- Use preempt_disable/preempt_enable on !CONFIG_PREEMPT_RT (Vlastimil Babka).
- Improve documentation to include local_qpw_lock on operations table
  (Leonardo Bras).
- Enable qpw=1 automatically if CPU isolation is enabled (Vlastimil Babka).

v1->v2:
- Introduce local_qpw_lock and unlock functions, move preempt_disable/
  preempt_enable to it (Leonardo Bras). This reduces performance
  overhead of the patch.
- Documentation and changelog typo fixes (Leonardo Bras).
- Fix places where preempt_disable/preempt_enable was not being
  correctly performed.
- Add performance measurements.

RFC->v1:

- Introduce CONFIG_QPW and qpw= kernel boot option to enable
  remote spinlocking and execution even on !CONFIG_PREEMPT_RT
  kernels (Leonardo Bras).
- Move buffer_head draining to separate workqueue (Marcelo Tosatti).
- Convert mlock per-CPU page lists to QPW (Marcelo Tosatti).
- Drop memcontrol convertion (as isolated CPUs are not targets
  of queue_work_on anymore).
- Rebase SLUB against Vlastimil's slab/next.
- Add basic document for QPW (Waiman Long).

The performance numbers, as measured by the following test program,
are as follows (v3, mechanics not changed since then):

CONFIG_PREEMPT_DYNAMIC=y
Unpatched kernel:                       60 cycles
Patched kernel, CONFIG_QPW=n:           62 cycles
Patched kernel, CONFIG_QPW=y, qpw=0:    62 cycles
Patched kernel, CONFIG_QPW=y, qpw=1:    75 cycles

CONFIG_PREEMPT_RT:
Unpatched kernel:                       95 cycles
Patched kernel, CONFIG_QPW=y, qpw=0:    99 cycles
Patched kernel, CONFIG_QPW=y, qpw=1:    97 cycles

kmalloc_bench.c:
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/slab.h>
#include <linux/timex.h>
#include <linux/preempt.h>
#include <linux/irqflags.h>
#include <linux/vmalloc.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Gemini AI");
MODULE_DESCRIPTION("A simple kmalloc performance benchmark");

static int size = 64; // Default allocation size in bytes
module_param(size, int, 0644);

static int iterations = 9000000; // Default number of iterations
module_param(iterations, int, 0644);

static int __init kmalloc_bench_init(void) {
    void **ptrs;
    cycles_t start, end;
    uint64_t total_cycles;
    int i;
    pr_info("kmalloc_bench: Starting test (size=%d, iterations=%d)\n", size, iterations);

    // Allocate an array to store pointers to avoid immediate kfree-reuse optimization
    ptrs = vmalloc(sizeof(void *) * iterations);
    if (!ptrs) {
        pr_err("kmalloc_bench: Failed to allocate pointer array\n");
        return -ENOMEM;
    }

    preempt_disable();
    start = get_cycles();

    for (i = 0; i < iterations; i++) {
        ptrs[i] = kmalloc(size, GFP_ATOMIC);
    }

    end = get_cycles();

    total_cycles = end - start;
    preempt_enable();

    pr_info("kmalloc_bench: Total cycles for %d allocs: %llu\n", iterations, total_cycles);
    pr_info("kmalloc_bench: Avg cycles per kmalloc: %llu\n", total_cycles / iterations);

    // Cleanup
    for (i = 0; i < iterations; i++) {
        kfree(ptrs[i]);
    }
    vfree(ptrs);

    return 0;
}

static void __exit kmalloc_bench_exit(void) {
    pr_info("kmalloc_bench: Module unloaded\n");
}

module_init(kmalloc_bench_init);
module_exit(kmalloc_bench_exit);

The following testcase triggers lru_add_drain_all on an isolated CPU
(that does sys_write to a file before entering its realtime
loop).

/*
 * Simulates a low latency loop program that is interrupted
 * due to lru_add_drain_all. To trigger lru_add_drain_all, run:
 *
 * blockdev --flushbufs /dev/sdX
 *
 */
#define _GNU_SOURCE
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <stdarg.h>
#include <pthread.h>
#include <sched.h>
#include <unistd.h>

int cpu;

static void *run(void *arg)
{
        pthread_t current_thread;
        cpu_set_t cpuset;
        int ret, nrloops;
        struct sched_param sched_p;
        pid_t pid;
        int fd;
        char buf[] = "xxxxxxxxxxx";

        CPU_ZERO(&cpuset);
        CPU_SET(cpu, &cpuset);

        current_thread = pthread_self();   
        ret = pthread_setaffinity_np(current_thread, sizeof(cpu_set_t), &cpuset);
        if (ret) {
                perror("pthread_setaffinity_np failed\n");
                exit(0);
        }

        memset(&sched_p, 0, sizeof(struct sched_param));
        sched_p.sched_priority = 1;
        pid = gettid();
        ret = sched_setscheduler(pid, SCHED_FIFO, &sched_p);
        if (ret) {
                perror("sched_setscheduler");
                exit(0);
        }

        fd = open("/tmp/tmpfile", O_RDWR|O_CREAT|O_TRUNC);
        if (fd == -1) {
                perror("open");
                exit(0);
        }

        ret = write(fd, buf, sizeof(buf));
        if (ret == -1) {
                perror("write");
                exit(0);
        }

        do {
                nrloops = nrloops+2;
                nrloops--;
        } while (1);
}

int main(int argc, char *argv[])
{
        int fd, ret;
        pthread_t thread;
        long val;
        char *endptr, *str;
        struct sched_param sched_p;
        pid_t pid;

        if (argc != 2) {
                printf("usage: %s cpu-nr\n", argv[0]);
                printf("where CPU number is the CPU to pin thread to\n");
                exit(0);
        }
        str = argv[1];
        cpu = strtol(str, &endptr, 10);
        if (cpu < 0) {
                printf("strtol returns %d\n", cpu);
                exit(0);
        }
        printf("cpunr=%d\n", cpu);

        memset(&sched_p, 0, sizeof(struct sched_param));
        sched_p.sched_priority = 1;
        pid = getpid();
        ret = sched_setscheduler(pid, SCHED_FIFO, &sched_p);
        if (ret) {
                perror("sched_setscheduler");
                exit(0);
        }

        pthread_create(&thread, NULL, run, NULL);

        sleep(5000);

        pthread_join(thread, NULL);
}

Leonardo Bras (3):
  Introducing pw_lock() and per-cpu queue & flush work
  swap: apply new pw_queue_on() interface
  slub: apply new pw_queue_on() interface

Marcelo Tosatti (1):
  mm/swap: move bh draining into a separate workqueue

 MAINTAINERS                                   |   7 +
 .../admin-guide/kernel-parameters.txt         |  10 +
 Documentation/locking/pwlocks.rst             |  76 +++++
 init/Kconfig                                  |  35 +++
 kernel/Makefile                               |   2 +
 include/linux/pwlocks.h                       | 265 ++++++++++++++++++
 mm/internal.h                                 |   4 +-
 kernel/pwlocks.c                              |  47 ++++
 mm/mlock.c                                    |  51 +++-
 mm/page_alloc.c                               |   2 +-
 mm/slub.c                                     | 142 +++++-----
 mm/swap.c                                     | 109 ++++---
 12 files changed, 624 insertions(+), 126 deletions(-)
 create mode 100644 Documentation/locking/pwlocks.rst
 create mode 100644 include/linux/pwlocks.h
 create mode 100644 kernel/pwlocks.c


base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
2.54.0

