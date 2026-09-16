Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71EF6C982C1
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 23:22:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37C086B0088; Wed, 16 Sep 2026 19:22:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32D786B008C; Wed, 16 Sep 2026 19:22:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21C826B0092; Wed, 16 Sep 2026 19:22:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E60A06B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:22:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2121AA01D0
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 23:22:33 +0000 (UTC)
X-FDA: 85221201786.04.9BD833E
Received: from mail-wm1-f98.google.com (mail-wm1-f98.google.com [209.85.128.98])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8066920005
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 23:22:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=everpuredata.com header.s=google header.b=ncZkmmPK;
	spf=pass (imf13.hostedemail.com: domain of tmenninger@everpuredata.com designates 209.85.128.98 as permitted sender) smtp.mailfrom=tmenninger@everpuredata.com;
	dmarc=pass (policy=reject) header.from=everpuredata.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789600951;
	b=FunQMV5ZSKCON0BsLHr6e/unLFz4uY0VJ7L+vQ+acunHotVrRlLiUL04AInzxSvLfwyLTj
	FSzhPlQjL+iXI+Q0CGhK+AcGqPzhZGjQCw5z1PgVB8bAeHwm9rLdKcpoWqMI8QrqZmnUlj
	GiilYLqlIPmylGqaS05NAP03skXj62Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=everpuredata.com header.s=google header.b=ncZkmmPK;
	spf=pass (imf13.hostedemail.com: domain of tmenninger@everpuredata.com designates 209.85.128.98 as permitted sender) smtp.mailfrom=tmenninger@everpuredata.com;
	dmarc=pass (policy=reject) header.from=everpuredata.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789600951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+Mz/ooayWzSCDSVBUMPNqpX+5H+WrF58DE6bDY0Ctws=;
	b=xtNVyrqgt+kITnQa6LdHXGHkUHxkiWAXXmJsm1Q4Uk1Mu9xXgyFtXO3dhkQ6TPYstPimTo
	fGpOwYgkWK80G6VanoiyE/t0V6jQbnwBkDsso4PZ6VMuVasr+thmsSUs8TuSCcCfKt2JTs
	pwEgNr0ZB24LN2cEdCaoFYh4ZXygRUA=
Received: by mail-wm1-f98.google.com with SMTP id 5b1f17b1804b1-49e6a767883so1297195e9.1
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 16:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=everpuredata.com; s=google; t=1789600949; x=1790205749; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+Mz/ooayWzSCDSVBUMPNqpX+5H+WrF58DE6bDY0Ctws=;
        b=ncZkmmPK0Ld07CkMygcmQoOyEAt+3BA0k4L0G7VH3sTV23OLlLt9PlLE1gdYmFgw+L
         oplv/iClh/XMMg24VBtKORUBIZREjPr6gbum9+LAWs1Q8dSo+/zDbej1jmWG+cjzaVJF
         dyDKQI/CpN86CpLcVNb+dnxAqaJizkw8AXBCTgkzj3V0z8TCHjhvDhHH8eqWcOo3dR8Z
         W2u/nm+YnEo7/V3lCEOTS9P3/YQ4NNeZaXDdqmlJjQxI7T/Sr8nKUpZDN00WZmhgQffT
         kc1WKgn8rmzjT18I7SUiTMrVm+EtbvuNiRwmTV4sEoPpYwS8iKDcPFJG54zOZ9Uoa9ZT
         x6BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789600949; x=1790205749;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+Mz/ooayWzSCDSVBUMPNqpX+5H+WrF58DE6bDY0Ctws=;
        b=sxIsn5DEfzsdseeNJe5kvZOfuNuSe1I2JTtPzkqDL3UcB10S9iTjH9ubC9IGn5e3Vr
         RZum1AGf+xvwLqccuLtj774FjpFzTE2n/xAzNhzYRIQ3P4fxSTkWWEpV9cBEU+DfKDi5
         v3JIYuTUC0PegeqD6HvZ2GFUj0vC5xVuWk1ZduhOxfwPw+H+mTg31rTbu4p5Okw6FXqu
         qwjjVH55ZKethtFjA19AKwS5kZ1GeHXzc5bTX8+mkeZov1niCSsOkUkc145Lkg3H5dI+
         VSeg4tZxXXTsAsNHlhtrSMzSZcf0HYftqJjlKpTzmDlhQ3FEssNKhTOGv2VmjuRObfIb
         SnIg==
X-Gm-Message-State: AFuF++mYkX6c+lC525rwV4zasYVjZ9e/BayNprHNaU45VxETt7SSX+JP
	J1BF+NaHOrhSl1yM5OQt5rsU4FELipqeEugFtfP8rWDpJgEdDA9P4nJVFaY/izfIwexHz7A+Wq8
	pfAbRF4ShaKBd8x7IBSvEnccBWS+1sCC5Gh5n
X-Gm-Gg: AYBFou1saeNGTcGNnnxEuip6FjcxbI2xv+8DRO7dAcstpsm5H0Rrw+zaPTLx9UDSPGp
	SwMINtc00rQE7+1nycCGIcnmEm7rBKJ/luny+tyXJNPLhNQ/IxKa3HjXuYAhJ4eoJoaT57TWx38
	zR0YvtiGpnAPZYwjvVM/EB3gAyuDpllNLFrZ4FQ4j0YdtKpbPvoq2tHO/p2gk3e3abGJr0AeC55
	Oz+LxMFZOHZ44fHHeiP4NdqFko8mbOFJXM2v/mTNZXmrasGzL2AnDM8ivo2FTmC38uv48XZeyU/
	T8MSFNFHoJbnT2sV1xpCXSmvuNxb9/w6JKEBFh3NgVCB0+WcH0yNFKEKoE0oF5WCdmJOiNfkWW7
	aQfjA8bmXSffoMhMxSm5aUpXzX7VoIrAwJZN33Z4=
X-Received: by 2002:a05:600c:8b35:b0:49e:6861:50f7 with SMTP id 5b1f17b1804b1-49eac4626c0mr46150355e9.5.1789600948882;
        Wed, 16 Sep 2026 16:22:28 -0700 (PDT)
Received: from c14-smtp-2023.dev.purestorage.com ([208.88.158.129])
        by smtp-relay.gmail.com with ESMTPS id 5b1f17b1804b1-49fbd2499eesm2213885e9.6.2026.09.16.16.22.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 16:22:28 -0700 (PDT)
X-Relaying-Domain: everpuredata.com
Received: from irdv-tmenninger.dev.purestorage.com (irdv-tmenninger.dev.purestorage.com [10.32.149.15])
	by c14-smtp-2023.dev.purestorage.com (Postfix) with ESMTPS id 6F4D834014B;
	Wed, 16 Sep 2026 16:22:27 -0700 (PDT)
From: Tim Menninger <tmenninger@everpuredata.com>
To: linux-mm@kvack.org
Cc: Chuck Lever <cel@kernel.org>,
	linux-nfs@vger.kernel.org,
	Jon Curley <jcurley@everpuredata.com>,
	Eric Badger <ebadger@everpuredata.com>
Subject: [SLUB] nfs_page cmpxchg_double_fail and perf lock perturbation on dual-socket NFS/RDMA
Date: Wed, 16 Sep 2026 23:22:27 +0000
Message-Id: <20260916232227.4098143-1-tmenninger@everpuredata.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8066920005
X-Stat-Signature: xe8usxbaxref4bc7g96ip6nqgg8b4rsb
X-HE-Tag: 1789600950-473787
X-HE-Meta: U2FsdGVkX1+Yn9l1e0iY0oAUYicG7QBXQcO4zFmv6eJtYdMijyW4RYz3GREbnf5R/oGji2fMAyQKleLzPrnXk3RHYbu/SEVNkRxztRVrjBd050hmR+7qGY9KyC2yb+K+7NVrJSiK51cPqxEUlB9W71mPmxQMmU7Okq3d9hfDE2nGxiacHmU4q2OJ2YwjMN1Xx0XD6stGxxTbTLwh6b3BEu+T4d36mSLPmfsB7WPQad8TmXv/qD/oUC2+Ee7y3DN3zq2vM7YA4iZdbBP6EeCfMkxW50ws6/uPdfERaDhBDJ55/zUmTHJ+HKoQcAaKBNn5KVN6Vd2OO2IWbgFPpP6RbI9eowalpi9NchO8uCvU4brbmDyLD0gqBKMrJL7t47Qpies76of5LJ5LgHmsgVg+aQl+4u+y28HI5SDCzCK5/0nJmOQLLAJ//dyJ9wpUXqTkPhyglG9fhVJupoSFWRur8pDOu5Yv6Ikxr8AJww2ZFft2bGjVgqfAJxOlhyYlicB5o/gemFOokFkQBWRPJ5cwiPowAIwTuGa/SbTE2qNcvWmddXBija+y8Wy56dDPlP9u96dpnXZk0czgrz8qBGWpyM55ac6KS/xm2nkF1nsYIf8P3JSTsawxJoKWvLkZoYf2AM7K3uXEOOaf9EZ2WdCw0rAtbK/7SPjXxAIoFGedRDbl5wKd/IiBPaLZ2kXh8CqSxSzLvOkVp2tISxlplrz3FyZ1eZIx65z1pYPA2GIVhvBV83g6C9CnHkYMmp8G8wN0nQ1rzKabGRWjQ09j5ToMZOL+Yea/NMI8bSD+0Mo03cgvWs6bi5EvaHzUym3sgG4ghRg20O9hQ/E2Tl+PqLj01dt7VaXRmGS5MNNG3LBe05fR5ae4pe06Nbu2a4eNB7mct8rvgZY5gjKugC8e2Jda2Tq5VzJ6q4g9DICYsryLhcVIvKejNVNKlA1uXMPAwAB0tg2w1u9X0PpJbNFffms
 9x/hD5OI
 Qbt53rAbegQUkLUzb3GxzARzxBN8ABJno8PS3f481amqiUjEKjT+1ol9umiEvwzjqBVDBmr3gZQNGU0/A7mUpsRGQgx8wyneBc+17Z8XaatogTItulHT/xHIhN9hN5ciXmyOSkIjCOrQAVZV4yfO8JxzPYrwNybiPtqIvmwe6g3OXme0XAj/UQPSI9KE89LapQRTeSsgHcZkQ+l1WCD+See6pJcPtamRcLRKqlQ4kEo3TOHDihth7djCBXJw5uqmtz2o+cGsK5We31ELg2x7b4T44P4Af+PKaCI86UJfti5DO1u/tKL/w/WA8883lFWuiSZ6pplJ6ztkIjH658ehp1SnLy0wtIwSpGSGdQ6UIStK6pxk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Chuck Lever suggested I bring this to linux-mm after we found some SLUB
measurements we could not account for while investigating an NFS/RDMA
throughput regression.

The original NFS discussion is here for context:

    https://lore.kernel.org/linux-nfs/0e2f9688-097c-4bb9-a7ec-82b41bdb3653@slotpi15m67/

The NFS regression itself has been separated from this issue. What
remains interesting here is the behavior of the nfs_page slab cache on
this machine, particularly the measurements with and without perf lock.

The system is:

    Intel Xeon Silver 4516Y+
    2 sockets
    24 cores/socket
    2 threads/core
    96 logical CPUs

    NUMA node0 CPUs: 0-23,48-71
    NUMA node1 CPUs: 24-47,72-95

The workload is a high-throughput NFS/RDMA direct-read workload using
1 MiB I/O, 160 threads, and iodepth 64.

The relevant debug options are all disabled:

    # CONFIG_KASAN is not set
    # CONFIG_PROVE_LOCKING is not set
    # CONFIG_LOCK_STAT is not set
    # CONFIG_DEBUG_SPINLOCK is not set
    # CONFIG_DEBUG_LIST is not set

All measurements below were collected on the unpatched base kernel:

    $ git rev-parse HEAD
    940de590b839f71d6dc846160534bf202401b8b7

    $ uname -r
    7.3.0-rc1-mainline+

The initial observation was a high apparent contention rate on the
nfs_page slab's list_lock. In 10-second perf-lock captures I was seeing
roughly 4.5M contended acquisitions and about 170-185 us of average
reported wait.

Chuck reproduced a similar acquisition rate on a single-node EPYC
system, but saw only about 7 ns average wait and fewer than 100
cmpxchg_double_fail events over a corresponding interval. He suggested
checking cmpxchg_double_fail because __slab_free() drops list_lock and
retries when the freelist cmpxchg fails.

I repeated the measurements in three placement configurations:

    A. workload unpinned, CQs all on node0
    B. workload pinned to node0, CQs all on node0
    C. workload unpinned, CQs balanced across the nodes

Without perf lock, throughput is similar in all three:

    A. unpinned / CQs node0:       ~45.5 GB/s
    B. node0 pinned / CQs node0:   ~45.7 GB/s
    C. unpinned / balanced CQs:    ~45.5 GB/s

During the perf-lock captures, throughput is approximately 25 GB/s.

For each instrumented 10-second window I ran:

    sudo perf lock record -a -g -o "$D/perf-locks.data" -- sleep 10
    mpstat -P ALL 1 10

Before and after the same window I sampled the counters under:

    /sys/kernel/slab/nfs_page/

I also collected separate 10-second counter and mpstat windows under
the same workload configurations without perf lock.

The resulting slab counter deltas were:

                            A               B                 C
                     unpinned/node0    node0/node0   unpinned/balanced

    free_fastpath
    instrumented        655,917,745    457,936,140       328,670,030
    uninstrumented       34,906,233    119,984,226        59,469,931

    free_slowpath
    instrumented        236,735,724      7,720,917       270,716,506
    uninstrumented       85,039,753          2,814        60,145,870

    sheaf_flush
    instrumented         39,842,700     42,706,800         8,341,440
    uninstrumented        1,286,400     13,487,700           887,700

    barn_put_fail
    instrumented            663,994        711,745           139,037
    uninstrumented           21,464        224,762            14,765

    barn_get_fail
    instrumented          4,609,925        840,344         4,651,225
    uninstrumented        1,438,643        224,787         1,017,006

    cmpxchg_double_fail
    instrumented             70,524          8,077            28,062
    uninstrumented            7,471            713             1,503

    alloc_slowpath
    all cases                     0              0                 0

The SLUB counter profile changes substantially with perf lock despite
the lower NFS throughput, and the exact mix depends strongly on
placement.

The uninstrumented node0/node0 run also reproduces the barn/sheaf
relationship Chuck pointed out earlier. The nfs_page sheaf capacity is
60:

    sheaf_flush / 60 = 13,487,700 / 60 = 224,795
    barn_put_fail                      = 224,762

The placement dependence of free_slowpath is also large. It falls from
about 85M events per 10 seconds in the unpinned/node0 case to 2,814 in
the node0/node0 case.

The reported perf-lock result, however, is similar across all three
placements:

                         contentions    total wait    average wait
    unpinned/node0         4,782,839      14.39 min      180.47 us
    node0/node0            4,582,012      14.13 min      185.05 us
    unpinned/balanced      4,572,196      12.81 min      168.14 us

I also revisited an inconsistency Chuck noticed in my earlier
measurements. Previously I had compared aggregate perf-lock wait from
one 10-second capture with CPU utilization measured during a different
window.

I now have paired 10-second mpstat samples for each placement, with and
without perf lock. The node values below are averages of the per-CPU
%idle values for the CPUs in each NUMA node:

                                  system-wide       node0       node1
                                  %idle             %idle       %idle

    A. unpinned / CQs node0
       uninstrumented                 31.46           8.0        54.6
       instrumented                    3.60           0.06        7.1

    B. node0 pinned / CQs node0
       uninstrumented                 84.26          69.2        99.4
       instrumented                   12.07          10.4        13.8

    C. unpinned / balanced CQs
       uninstrumented                 66.86          66.7        66.9
       instrumented                   14.83          19.0        10.6

This resolves the accounting inconsistency in my earlier measurements.
The large aggregate perf-lock wait and high idle percentage had come
from different windows. In the aligned samples, the system is much
busier during the perf-lock capture than in the corresponding
uninstrumented run.

I am still unsure how representative the reported ~170-185 us average
wait is of the uninstrumented workload.

The remaining number I am less sure how to interpret is
cmpxchg_double_fail. In the uninstrumented windows I see:

    unpinned / CQs node0:       7,471 / 10 sec
    node0 pinned / CQs node0:     713 / 10 sec
    unpinned / balanced CQs:    1,503 / 10 sec

compared with fewer than 100 in Chuck's test.

I understand that cmpxchg_double_fail counts failed slab freelist
updates rather than failed logical frees, so I am not sure what the
appropriate denominator is here. In particular, the node0/node0 case
still has 713 failures while sustaining full throughput and only 2,814
free_slowpath events over the interval.

My questions are:

1. Do the uninstrumented cmpxchg_double_fail rates above look abnormal
   for this workload/topology, or are they within the range one would
   expect from this degree of concurrency and NUMA placement?

2. Is there a less invasive way you would recommend measuring the
   nfs_page list_lock/freelist contention? I would like to distinguish
   the steady-state behavior from what is observed during the perf-lock
   capture.

Thanks,
Tim

