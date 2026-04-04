Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CAFCE88D8D
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 09:20:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9972D6B0005; Sat,  4 Apr 2026 05:20:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9465F6B0089; Sat,  4 Apr 2026 05:20:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 835406B008A; Sat,  4 Apr 2026 05:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 725D06B0005
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 05:20:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1A0D2C29CA
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 09:20:04 +0000 (UTC)
X-FDA: 84620326728.11.3590925
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3804F8000D
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 09:20:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Uf9AfVwi;
	spf=pass (imf02.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775294402; a=rsa-sha256;
	cv=none;
	b=euPxoe3nmlU5fzCjH005zW9ARUgYh4bnpsuBq5Db5IgnivSpnSxP1p7yKDI9mzdbAtioXM
	dfnFAD36eLPQGzWDIoJCyHSI4hNC8teqUppk5etMMsqIWy3Bez4+gAFmmbTLryJwOv3ajI
	GHvHGS2oI0P4fZG/7ZePrknQLHgbnQ0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775294402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m4D9KIHfQ19G+ih5n0VIDlQHW6gYQM9spmrNFkW8GpA=;
	b=f3Al72eClNmZb7rf5wjkJ7a6bIOWwYmItv6//j8PTc9ltRPIUd8wOC4xyxNOXL6pcs6P70
	WcYRIrL+CP5KXhiCC7LBc0KzJwfVvFKRUT871JwhujCrBGSgITV2rUc2xwtpmURZes4zIT
	wiWPvKExGUsjtYsSItBHqKmrUEwyGDU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Uf9AfVwi;
	spf=pass (imf02.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-2c15849aa2cso2953022eec.0
        for <linux-mm@kvack.org>; Sat, 04 Apr 2026 02:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775294401; x=1775899201; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m4D9KIHfQ19G+ih5n0VIDlQHW6gYQM9spmrNFkW8GpA=;
        b=Uf9AfVwizEJmOT/ncqNJMTEWycDetNAi4zXYu163hn9vn6/YtSWQV4Uu+1WTyZvbxb
         FU/aV9AQiqkGEwj/LD7GRPQesWzwVVR8no0GFu9FdyPHcDGou7XuxotuakrQNLnRghoo
         u8uP1vbqoKXJ65YCQ/z+q0yCenXeNyA+Y+RKictDg4fH7xD+mpleEiV6AAJtDnjiZj9k
         990s2B0uz5vYV3iPk1xIkg2fRsT3z7tayzKyBMMCXb6A3fa/Ap069IPTd483UhAtHnav
         fVORcsjUZ6L+xTJTNdfWX/zX+hOKXaRA9/LDIzaR3/QjXKWToXd+cbT2QhczXvF10bMi
         +M+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775294401; x=1775899201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=m4D9KIHfQ19G+ih5n0VIDlQHW6gYQM9spmrNFkW8GpA=;
        b=EPzPR+1UBkTHpQ3HBOEb3Wc36cGzj2CmoJD3CwG/JsJNS3n31kBHz6cYvmGKUK+0BU
         gdb8Wgk3hU0OIKvnot6f2Av8w8POcBLfDy7/fdekSj860eVUiOHUPUUA3VEIoKXHcTJN
         Xg8/rKL91ocqsXg9NlFcnW7urjfOMZPxNTA9QLjaKoxFgqu7jaIQ6iR8YLaGEX1/kEs+
         EAEtgNeUjAHFk+NvQtrFT3PP2Ev0AgdO0muheGpzLEBPNfdcH3d6dP3IzHKJDdK2kThT
         laSLC73NT7uPFip5MjRXDpUs5ZacdHGtP5xiai7e27rkFfxtFGFX5C7Q/R+IFP9oW6BB
         wfFg==
X-Forwarded-Encrypted: i=1; AJvYcCVEZ3c5Nxl9Nlp1RCDpDSQPnclJG/blXjAQEOI+NTGlSt2e9+5tTTXeZO9POtonFV3R6hZNpSMCKQ==@kvack.org
X-Gm-Message-State: AOJu0YxFBuPWSsvjLN7OLMEMvlNVhx5Kk1UVb4UL4OZMXQstEx7qXBSW
	Eppod2mwQZh0bePVNaASbFQfJmmq09px+6WEraxSROeRvVsVlzADCPvj
X-Gm-Gg: AeBDievbk/gtFlL3pNs4lzqwvIMaR8t8ecGYaAEEg9js4orkkL1d2WPKw4Dd0WgAGuv
	uI2UEluVXr/1WNixfnoH6XQHo2wCGU1cICFhXFLGUE3FA0vGeapYjc+EClge9id0Tb5C+wvyJ3U
	Ro3b4vdPfTv4dYoiHsLfAOJXXl1Gdm0WTqGUuvGEzjGhFXicBvq45AuRF7ufjyTnPFF+QTPckk0
	QmANKYHHOwE2AuA7q5y/4R2VcrvG438IdPMa/qbg1qpZWl6irpBjsONjnE+88cBDD8nFvBKcAL3
	+2MPvLOxj+o2FGw1SVxZKR7oXnkvfpFWBpgtNCWWWsxzBXHSsWfsJ0ME0iXBjOkEoUn3IYAGP7D
	o7u5GmwIk40jTH9w4sPdAQh+Cz3ok9ce3FPQoGBikOvj7SSU4+UsmWGYkK1Wl0ytq+caCm0pDZY
	1Rg5Q6Ajij3KI20g/KUWH+Ug8=
X-Received: by 2002:a05:7300:a287:b0:2c1:74ad:2cd7 with SMTP id 5a478bee46e88-2cbfbf760c4mr2791873eec.27.1775294400761;
        Sat, 04 Apr 2026 02:20:00 -0700 (PDT)
Received: from localhost.localdomain ([2607:f130:0:11a::31])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca78df3b84sm7176920eec.5.2026.04.04.02.19.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 04 Apr 2026 02:20:00 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: 21cnbao@gmail.com
Cc: akpm@linux-foundation.org,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	loongarch@lists.linux.dev,
	surenb@google.com,
	willy@infradead.org,
	wang lian <lianux.mm@gmail.com>,
	Wang Lian <wanglian@kylinos.cn>,
	Kunwu Chan <chentao@kylinos.cn>,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: Re: [RFC PATCH 0/2] mm: continue using per-VMA lock when retrying page faults after I/O
Date: Sat,  4 Apr 2026 17:19:32 +0800
Message-ID: <20260404091936.51961-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <CAGsJ_4wnwAet4svDrxT4sTdp24sweAU-2VyYn3iNPOoaKdXxPw@mail.gmail.com>
References: <CAGsJ_4wnwAet4svDrxT4sTdp24sweAU-2VyYn3iNPOoaKdXxPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3804F8000D
X-Stat-Signature: pdir96hr6aq6qupagj86393pfk3zdu78
X-HE-Tag: 1775294401-94036
X-HE-Meta: U2FsdGVkX1/r6Vr1LAsAwMpQDqiGckxhYpeju+omi+5lTWQdQEbdW0jAn/lzlnkuwb1UotvSYp8eH5NQv8dcp4e0FL9ruw13AujRIi32mzd4IUHQaL+437mtALoJpSuvIOjB8dZZSwpTE+q/jcIxUW8Ce03DnadSwBZQjIUv57mAEX8TF+01meUyTmM0KNqSaJhLsn8d0CvkMrhV10VYZuy1ntgTA9Fpkth4JxnxcsH6GkH7VRfnc3eb1wApgh7AM5TtfyUvHW+JYEbWIzFv7LpnTvPFb/ISTaRthLqlhz/I8jNhOub2wVqyf6dpFdd6FUjd+fT6jYQndGypsrd1JmiwU3kiFhKiVWLkKBswI+BPSwV0Jq41BPfHNGCqilHDIHLcx1XLtoDrLE3OUQWnbQHxfB6mJWuaBM68gn6bdrdSM1tFVxeDOKwkpQeeJgRf+Ul2HDQ39Qh3eX0mXA2JZk6gfbhcGmixya/6gAtQEvGDZUi6SpXXwp0mSPae6SlxwjCP7JLeGcBOtTSRP5Hln/f/PNR9jp34ihtdXSMpwxXWSIWOeLQ2qQHgKGTNCSYc0X0A2thWoKZtxk5hvv4/IeNAtPCmZsrJGIDBC3E/8GolRen21X2oPla5SYVeHCm1Raiv70EzBzyn71IEhXEF2pnXfebHQX+w4xCTTgOXHSHdxPoOMVWsoevi6fRBcnm+8L8e5EOenxX58RNEJoNfKpgnT/XRhMLdtjYHgWkANgFp2/1cB+Fn7zZI8jYtLDdB3QlpADTtLfBtPSObV/Zc5gMdAaCzRiDYATjI9dXAwEiOMeXrdRTdFUWUXVeI7NMQiXe6y5or+bxGuCB9kvCnTmitjxCQEdlbmkQtkSrRv6PAtNE2AQTMAKaoYAE4WDzQ73GVV+WV6zm7Ej0btwr3X+JYZo9ygVWPejA5PrxB1CZ8g2oiWqIChlYq0glOWzOe2kR0G2CqYC4AhN99Dps
 IkdQNldB
 G0kTaLN2dPkt/k7tUnqk6yLMpYLjjUbeAJr4thu8wolBdkSLmeb+VGclp+n/bbTmpUAY01NIbcDOKBwXohwEGulRxgD9rvGrU0Ds5JVZPYpsmrjsufF/4EI6s0mRR0JHoZNjDIqAblxalF8HyC70H8NPT9KJKDGl3fi71VixDynxO6aFwBetT6pO5oSCrMeL/2aur8mClWwMecs+NYrm77CUsUMtxaKZxVn9VTXQKkJoG5RLC5UjA/+hjhE1guROE7EgRJI20x++arcz66DGxA9GHfLIbL+ywAl4SYb7avcZ2/biHVVCMNunYIOdRManjplDspVHQBHXq6YX5JG+o0CjINwo4PclH9ky2S+cGpmtecVHZb/evj1/u7B51rlWoKrHsvmC/ElcoL1jJUXq6haVWLWCyC3TVKBhuYXdIY7dgimjNpSGdOKOvDGaQPOOAB0MpOiLkxZgTzEuf0k5/Y1raBJzTUhP9MgM0gnP2PHSxN4MkW13EIouibQ+zORoeBQols4tyBfa4l0h8jRg/vYpuibcxXvEks5uEsT6+MB92nvNsc7wKWX+EJOk3FHH5dCOn4zyQ5gdCIGXuHkYQcYkwrkPzmPOZrSSBj0c2W2jk1eYE/kzRkPTMNfCIVjoMmctZyE8GjHJg96d1XQ0dAZhiC3z0FcgPd/eC08r4HPS+JHGolRTnSROEZeNk2UskD+4tQf5kl/rcgsJvWb+eHlh79Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,

> If either you or Matthew have a reproducer for this issue, I’d be
> happy to try it out.

Kunwu and I evaluated this series ("mm: continue using per-VMA lock when
retrying page faults after I/O") under a stress scenario specifically
designed to expose the retry behavior in filemap_fault(). This models
the exact situation described by Matthew Wilcox [1], where retries after
I/O fail to make forward progress under memory pressure.

The scenario targets the critical window between I/O completion and
mmap_lock reacquisition. This workload deliberately includes frequent
mmap/munmap operations to simulate a highly contended mmap_lock
environment alongside severe memory pressure (1GB memcg limit). Under
this pressure, folios instantiated by the I/O can be aggressively
reclaimed before the delayed task can re-acquire the lock and install
the PTE, forcing retries to repeat the entire work.

To make this behavior reproducible, we constructed a stress setup that
intentionally extends this interval:
* 256-core x86 system
* 1GB memory cgroup
* 500 threads continuously faulting on a 16MB file

The core reproducer and the execution command are provided below:

#define _GNU_SOURCE 
#include <errno.h> 
#include <fcntl.h> 
#include <pthread.h> 
#include <stdatomic.h> 
#include <stdint.h> 
#include <stdio.h> 
#include <stdlib.h> 
#include <string.h> 
#include <sys/mman.h> 
#include <unistd.h> 
#include <time.h> 

#define THREADS 500 
#define FILE_SIZE (16 * 1024 * 1024) /* 16MB */ 

static _Atomic int g_stop = 0; 
#define RUN_SECONDS 600 

struct worker_arg { 
        long id; 
        uint64_t *counts; 
}; 

void *worker(void *arg) 
{ 
        struct worker_arg *wa = (struct worker_arg *)arg; 
        long id = wa->id; 
        char path[64]; 
        uint64_t local_rounds = 0; 

        snprintf(path, sizeof(path), "./test_file_%d_%ld.dat", 
                 getpid(), id); 
        int fd = open(path, O_RDWR | O_CREAT | O_TRUNC, 0666); 
        if (fd < 0) return NULL; 
        if (ftruncate(fd, FILE_SIZE) < 0) { 
                close(fd); return NULL; 
        } 

        while (!atomic_load_explicit(&g_stop, memory_order_relaxed)) { 
                char *f_map = mmap(NULL, FILE_SIZE, PROT_READ, 
                                   MAP_SHARED, fd, 0); 
                if (f_map != MAP_FAILED) { 
                        /* Pure page cache thrashing */ 
                        for (int i = 0; i < FILE_SIZE; i += 4096) { 
                                volatile unsigned char c = 
                                        (unsigned char)f_map[i]; 
                                (void)c; 
                        } 
                        munmap(f_map, FILE_SIZE); 
                        local_rounds++; 
                } 
        } 
        wa->counts[id] = local_rounds; 
        close(fd); 
        unlink(path); 
        return NULL; 
} 

int main(void) 
{ 
        printf("Pure File Thrashing Started. PID: %d\n", getpid()); 
        pthread_t t[THREADS]; 
        uint64_t local_counts[THREADS]; 
        memset(local_counts, 0, sizeof(local_counts)); 
        struct worker_arg args[THREADS]; 

        for (long i = 0; i < THREADS; i++) { 
                args[i].id = i; 
                args[i].counts = local_counts; 
                pthread_create(&t[i], NULL, worker, &args[i]); 
        } 

        sleep(RUN_SECONDS); 
        atomic_store_explicit(&g_stop, 1, memory_order_relaxed); 

        for (int i = 0; i < THREADS; i++) pthread_join(t[i], NULL); 

        uint64_t total = 0; 
        for (int i = 0; i < THREADS; i++) total += local_counts[i]; 

        printf("Total rounds     : %llu\n", (unsigned long long)total); 
        printf("Throughput       : %.2f rounds/sec\n", 
               (double)total / RUN_SECONDS); 
        return 0; 
}

Command line used for the test:
systemd-run --scope -p MemoryHigh=1G -p MemoryMax=1.2G -p MemorySwapMax=0 \
--unit=mmap-thrash-$$ ./mmap_lock & \
TEST_PID=$!

We also added temporary counters in page fault retries [2]:
- RETRY_IO_MISS   : folio not present after I/O completion
- RETRY_MMAP_DROP : retry fallback due to waiting for I/O

We report representative runs from our 600-second test iterations 
(kernel v7.0-rc3):

| Case                | Total Rounds | Throughput | Miss/Drop(%) | RETRY_MMAP_DROP | RETRY_IO_MISS |
| ------------------- | ------------ | ---------- | ------------ | --------------- | ------------- |
| Baseline (Run 1)    | 22,711       | 37.85 /s   | 45.04        | 970,078         | 436,956       |
| Baseline (Run 2)    | 23,530       | 39.22 /s   | 44.96        | 972,043         | 437,077       |
| With Series (Run A) | 54,428       | 90.71 /s   | 1.69         | 1,204,124       | 20,398        |
| With Series (Run B) | 35,949       | 59.91 /s   | 0.03         | 327,023         | 99            |


Notes:
1. Throughput Improvement: During the 600-second testing window, overall 
   workload throughput can more than double (e.g., Run A jumped from ~38 
   to 90.71 rounds/sec).
2. Elimination of Race Condition: Without the patch, ~45% of retries 
   were invalid because newly fetched folios were evicted during the 
   mmap_lock reacquisition delay. With the per-VMA retry path, the 
   invalidation ratio plummeted to near zero (0.03% - 1.69%).
3. Counter Scaling and Variance: In Run A, because the I/O wait 
   bottleneck is eliminated, the threads advance much faster. Thus, the 
   absolute number of mmap_lock drops naturally scales up with the 
   increased throughput. In Run B, the primary bottleneck shifts to the 
   mmap write-lock contention (lock convoying), causing throughput and 
   total drops to fluctuate. Crucially, the Miss/Drop ratio remains near 
   zero regardless of this variance.

Without this series, almost half of the retries fail to observe
completed I/O results, causing severe CPU and I/O waste. With the
finer-grained VMA lock, the faulting threads bypass the heavily
contended mmap_lock entirely during retries, completing the fault
almost instantly.

This scenario perfectly aligns with the exact concern raised, and these
results show that the patch not only successfully eliminates the retry
inefficiency but also tangibly boosts macro-level system throughput.

[1] https://lore.kernel.org/linux-mm/aSip2mWX13sqPW_l@casper.infradead.org/
[2] https://github.com/lianux-mm/ioretry_test/

Tested-by: Wang Lian <wanglian@kylinos.cn>
Tested-by: Kunwu Chan <chentao@kylinos.cn>
Reviewed-by: Wang Lian <lianux.mm@gmail.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

--
Best Regards,
wang lian

