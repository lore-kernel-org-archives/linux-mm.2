Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3E24606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 21:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=nunDMFXp
Received: by kanga.kvack.org (Postfix)
	id 8724A6B0256; Wed, 21 Oct 2026 17:19:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8255B6B025B; Wed, 21 Oct 2026 17:19:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 739276B025F; Wed, 21 Oct 2026 17:19:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 31F3B6B0256
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 17:19:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0FAD9A8265
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:19:17 +0000 (UTC)
X-FDA: 85347899154.15.F1516A6
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id 42DD61A0008
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:19:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nunDMFXp;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of ssfdre38@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ssfdre38@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792617555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=FN6v7SVOkb0MCrKdScdxO3dToDbvk4Fcf6pFsRpJAbU=;
	b=0ZNvax062N4gIhCKbekAdBM8dcrhpXoz5uTs9ToAV1svddpqv+jqIMqanaxhLqhaYKBmvc
	ZZKgoyVNmeS/TUVgcneL/V/Ntz2+jms5c8FgRggQi+9W+E/iH2nb4bb490ox2F2o0UpndX
	vWTbX3njFlwR4WYwzeF2BPqhXFt/ASo=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nunDMFXp;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of ssfdre38@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ssfdre38@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792617555;
	b=VtpqmlU/sVb/Cv3F3YP2PfJN1tFBTI7Xpjk/JACwO4IdF2x5VRCzUI63+Pm0rZIUwyKKNd
	aTTXJrWW8RNfJRB/eALqB7FXJxhGqvYiiyR6XlfGZhrakwd1so06D+rw8oUgQo6I0acTXm
	rLvo/x0b0eS+Cgj9W+RBSbD6rv4RCpI=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c4322d310e7so162564066b.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 14:19:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792617554; cv=none;
        d=google.com; s=arc-20260327;
        b=JzUbu2qACFNAU+B/Gy4KMzoABfl+OyT4ftfQhjQVEqKuNVqIs52ZJ5qkeoSxLtEx5n
         E/bd3FKp0UfXLfwij9WMvxqqSGH8RMGRwDdwae2zgd83cFdg4Igpk1iOzk2NTMbW7+b1
         9WvOEgka/BvWOcX11Gbf4mrCgLVVFPhIAOuD7boe9k3MOZAQsuxYwyndi7NxfzBPT75b
         q+3vLv+lEwU+DfIbsQgDm8ozXcO5ssHE1VVFb2mWol3z/2bzRMR/NNn9ZmZKok/jtYz+
         gZKe9S8KFHyaI+6qdnpbVYRZGTvIbeVVNu+RX2Awqrh+7/zP3SdOVmv7U721qpmZRq5v
         JuSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=FN6v7SVOkb0MCrKdScdxO3dToDbvk4Fcf6pFsRpJAbU=;
        fh=qp37V8M+GWPZE2I/aCg/4FStLZvqWECEV2+vtj6jBug=;
        b=lxYH4TkZTUOCaBP6+DrN8eZK1kQmRfMBSOlleocnwy8oohyy7k5Nn1W8gh9l1yJ2xn
         uZ2VUScNv4ThXo2VMUcO9O6V3w4qBVCQ3GIhnhXr8Fg2IZymvgU1pCHXfmv56sp0r74p
         VCzs5yhTApRgZ5Xu3IkxZIfjhd2bPIQ7PkGfna9bPP7hLJa4sEwyF/zH7Z6VjbJit3aI
         E/8v+Vo//dUCj7osOVEqrdznGupj89WIR07gCEoc/2hx/BIr3jKODr4+dQsWm2+nVH2d
         0VuRQv3xiu3KBdPfNXmMGmS4LptPSIgpck86jFanay9VN5H0aR/T3VlMmMQlYpL86GEW
         HzCA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792617554; x=1793222354; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FN6v7SVOkb0MCrKdScdxO3dToDbvk4Fcf6pFsRpJAbU=;
        b=nunDMFXp8wPhPmr0nmsB5Fs23u9g20l4SDFyBmk4jRd2Ku6uDnQFqjRoFl6G/pmuWA
         y/npehn1trtfDWdZMESuz4V79JClUuBm2Nnu2rWaiKVyYBI6BK8omJY2cnjQGVDGoHMi
         Ykgve8uwUut1WhLrH/dUBJCC9sKSfWjOvQMdzYBzZvdZYANPeTWLpP/kDTEFbov26GMN
         zBHo3WCVHq6iW/OWl3Hadaoih12+LFxbD4/Cq5wP8Dm5mqTNfo4Hl9UtX7tCHizqaDGL
         QID3NDpB1heZ5aqA0h9YEevtC4OZcZSj1k6eNST7xc2XtQNk2JLq7xsWM5u4iGVnoeAR
         o0Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792617554; x=1793222354;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=FN6v7SVOkb0MCrKdScdxO3dToDbvk4Fcf6pFsRpJAbU=;
        b=zt0cnAiYImZFnKq+wJewewWiFxGtYwwM8Gnj4tkh2yXtH/AaUihs8TDITSOUI0/RWg
         KMmHUPBpvNuZcjke1eTlI2JXMymTkLEV0wYZsIX4tFxOPPH3zr+e7nCUxASDPLSmEdTs
         OxArakezwsaweWkDFij8OsOmBXnAkhZltJXl29+rYg0mo3w2Iqjxw9Ezcq2kV3YeXv8P
         hKxI4Z2L8URBEuX/RRLhfzROxG/H+3rxR+51ITMftfJLwAMmYy7OS+/nzhyjsjGyxdKs
         /8iz8YRomY0Un2GucnEhrSKPVBZv+eIYe62fkHl7yZTvX0vtuW0Tfhp89c7xc436YX7H
         9lhg==
X-Forwarded-Encrypted: i=1; AKwUvByNMDSfsq8FPfA0Qxq3oYm5tpeRWeoWi+mrZczV8VhxE95xDCcLLxqFnq3AGLCTLKBhPziMKOADGg==@kvack.org
X-Gm-Message-State: AFq9FYJYdCJ9ypmCgbspvXT+Gc/lrL9NDd/wmitxaODHlbV73etHqFj5
	iJ4ZcV1Ld9grLiRYdvIVMjKmd4S2uBlu07bD6EORd1NkyO0FyEyUX+IlkhvkuWOXMlCqx3n0dEk
	jp3CDLbV0cMJdy3mGRN9Y7xTrk9wbA5yn2U1CegRciQ==
X-Gm-Gg: AYBFou0H6Zvn6ZR0P8hZI2pQzBPdN4SsMTEMibnHu4lSNHcL+GJO5PmezDsxXzuD5Hv
	yeMGUNhVVJbRtQptKspYyUkmynFAHg+CEVMvZHmVVyN8f8ViCE6jh7U2PxYlA4YbIa7oD2mkvEc
	X+QvKDp6NnUSC0jkfNNpdh+WlkylTeGINjEkWZlKS9vOdyIZhoovS+ZDaTWcjiQZUYYBtIywdy4
	I4nU3h9UD031QLwRxp5Jb3Dcs+bKW3E2BGvBuY/QdTlsCIEIIH/EixDJnzEXvvKd0WruFAFVnqs
	ygOyNJt/Dsf3V+9TelKJamOk1xUk2eckzf9lH8u5HdyehazW1yuhBtGe235+GzDxHk4dtgvqkMu
	xNiu1Rva636auJoemVgXr7ST8zhopjOs4r17x
X-Received: by 2002:a17:906:f586:b0:c3e:e677:563a with SMTP id
 a640c23a62f3a-c4679a238b9mr272475566b.47.1792617553383; Wed, 21 Oct 2026
 14:19:13 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
From: Daniel Elliott <ssfdre38@gmail.com>
Date: Wed, 21 Oct 2026 14:19:00 -0700
X-Gm-Features: AclHuK-gS9vHa3pN2O0CqjSUPQ6N_GY41B512MssdU87w8JtS_2P_g2tfw4PdXc
Message-ID: <CAJVF7aNOjMh3edjjrrAPNhLKWmwNMfn-Yp9Mkq4=xSUmFO-UyA@mail.gmail.com>
Subject: [RFC PATCH 0/1] mm: Haven Memory Bus (HMB) zero-bio paging engine
 with Tier 2 z-Pack deduplication
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: "hannes@cmpxchg.org" <hannes@cmpxchg.org>, willy@infradead.org, torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 42DD61A0008
X-Stat-Signature: rbsiz5r7sxrb4kasnztohoyhjwmht1kz
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792617555-507225
X-HE-Meta: U2FsdGVkX19RUgr5s7xWU+v8deu0dxRFkVutw4EdNfdzaa9Z4B92xsCfn25bObGr7YrsU2uHhKPYG4P6qFOB2AF4BqliaEM7GtAb5YWaQjS0S0YI5OtQrHjaR0THd00H2vwKxvsML3ro1OATz6CSrS2dzFotMJjf2RqQVqb6y2m+pKSvdcnko1t5SvSEMvW0vX+B9GCn28kylLSfL93pZWolQmhojbYWn+cq82g2fhLXcap08sJZER2pJ7DAIqVXS9TlL0iEe+lhA11JHoarGnm+zGe67EVoGN9DGd1zXtbD+p/tAdiNDq2/yyt348w6IaBZjH4NzFN52qkFMiyF1NGV/XrcKps9CDqgPZOXUc3Po59H7eb6Kz7tjPfM5BArjGe120e2wm7lh33UwNXEwbnVt1ME6hHX+lo2rvODxbGhByMSfpAWXoMJIPRuqeVnnF/iLQtsKdfHoc2RvchHlXNklnchdrZimA+2WqTd+OokbsXimGGpUR/Lq2fIhwAcECYUll3NcoI2hypV68AvB7TxHZ9CuNcDHuUCacYyWVLinVC/xcBG7mskXgrHz8I7AjCkJWtKXGKq1igiia/uoxgOH3e02VwpbEhCOMzHGWmdoM8lDqO77XlaT5+QH6Il1DtLzE5VVdXxwkGpAN0ZEa2eT6cXlZwOlHHOLtGg19iPLRVgDE0M1rZ7hyrCO3S5pCCBu29RGmwHK9wZUrnEnG0YjbpndriNELigHnx4B2dDjwHRLZCBEaKYwa+CInRO2UoI1h/ZJF99IFTfVDUdC4xsrJYOPS3X7auHU0kigHWK3E4TP/vx5Oj6wYw/olvHgCf0m0jkrFknf6p5M2aIrZvU699ly8FhU6ZFGpdL2JE2j6mYND8O25T8j2hxjWZcMDpxUbTnxES7zTnx8VJvRLGFJAAnZTDXVavPt304b3uquB+DE2u5u7b602bgKFI+TZJRwWiUuypyuQDVX2B
 AfPCjPhc
 nE8v8COzzDRXiB61m+G4TvjE21xqgIILYRKQtydnN0VkDdMaOIfM8N3yxIQvxfMXL344mux1ppB2bYzfd8EbQEZpfRcB4/FHszbYYlhJF62yJRejV2BW921YAH249TJkG8JeYzFhVOsGr7Jnum3HwkYlyJVYszVhUTSIE52vE6TSNofpM12FSy6UDm3+DPVa4A8+GzXRESizQeZUBpiZ/n5dUNO+Ygd8PGFhDKYUVqJ+02FahxYhBQEZA3Rm5nXDp+L4CjCrqr70Tb+rY2rJtvI+AgwJEGfHvX84/BZ6+aJQOSw5qn0ClKt56aGtG0T132GtTM9MF1X8Mav/XdiaGvf5oaI+TUQelrQtidvGa0f8dLyvZwVWOP33fgxf3nn9J2qdayn3KfscfC6vP23JUDrmRIsKMWgXEKue7xXBdwzY2nk7Uxpx7nuFiRNFU82ys7G3iQKU18y6dYY4piStCGDB4XfSO8qRHjGWGikw6MAd1z9LKluQDoDu58uDYPX5qcXAYynvkiQ0qQEH30e5IT/tY9DrBdCBzhUND
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

    Executive Summary
    =================

    This RFC introduces the Haven Memory Bus (HMB) Spec 2.0 Native Paging Engine
    directly into the Linux Virtual Memory Manager (mm/).

    For over thirty years, general-purpose operating systems have
assumed secondary
    storage is an asynchronous block device. Even modern in-RAM paging
subsystems
    (e.g., zram, zswap) construct struct bio descriptors, pass through blk-mq
    software request queues, and traverse I/O elevator schedulers
before reaching
    physical memory.

    HMB eliminates this legacy abstraction. By intercepting folios directly in
    mm/page_io.c (swap_writepage and swap_read_folio), HMB provides:

    1. Zero-Bio / Zero-Queue Bypass: Folios are stored and retrieved using
       lock-free O(1) arithmetic stride indexing directly over the CPU
memory bus.
    2. Tier 2 z-Pack Inline Deduplication:
       - Zero pages: 100% deduplication (stored in a single bitmask bit).
       - Uniform 64-bit quadword patterns: 99.8% deduplication (stored
in 8 bytes).
       - Varied pages: Stored in high-speed slab pages without block
serialization.
    3. Sub-Microsecond #PF Resolution: Page faults resolve in 0.51 us,
eliminating
       thread stalls in uninterruptible disk sleep (D state).


    Bare-Metal Silicon Benchmarks
    =============================

    All benchmarks were conducted on a physical bare-metal server (Supermicro
    X11SSH-F, Intel Xeon E3-1270 v6 @ 3.80GHz, 32GB ECC DDR4, 2x 2TB HGST
    Ultrastar 7200 RPM SATA HDDs) running Linux 7.0.14-hmb.

    1. Page Fault Resolution & Latency Under Memory Pressure

    In a constrained cgroup v2 environment (MemoryMax=256M), a worker process
    allocated 600 MB of dirty heap, forcing the kernel to evict ~350 MB of
    anonymous memory. The process then immediately read back all
memory to trigger
    real kernel page-in (#PF):

    Paging Mechanism                  | Paging Latency | Recovery Time | Speedup
    ----------------------------------+----------------+---------------+--------
    Traditional Swap (7200 RPM HDD)   | ~10,000 us     | 258.0 s
(4.3m)| Baseline
    Barrer HMB Native VMM Engine      |    0.51 us     |   0.013 s     | 19,842x

    - Operations Handled: 91,799 pages evicted, 25,313 page faults recovered,
      168,643 swap slots freed directly in mm/.
    - Block Layer Trace: Zero struct bio allocated; zero blk-mq submissions;
      zero storage controller interrupts.

    2. Real-World OS Workload: Core Systemd Phased Upgrade

    Under memory-constrained multi-tasking, an un-phased upgrade of 13 core OS
    packages (systemd 259.9, udev, libsystemd0, initramfs-tools, dbus)
was executed:

    Metric                   | Traditional Linux Storage | Barrer HMB Kernel
    -------------------------+---------------------------+----------------------
    Paging Throughput        | ~90 MB/s (Rotational seek)| 2,625.9 MB/s (Bus)
    SATA Controller Conflict | High (Swap vs pkg writes) | Zero contention
    Thread Sleep State       | Heavy D-state / I/O wait  | 0% I/O Wait (Active)
    Network Socket Buffers   | Prone to TCP throttling   | Zero packet drops
    Systemd Re-exec          | High latency on deserialize| Instantaneous


    Architectural Implementation
    ============================

                         +----------------------------------------------+
                         |          Linux Userland / Applications       |
                         +----------------------+-----------------------+
                                                | Page Fault / Eviction
                                                v
                         +----------------------------------------------+
                         |       Linux Virtual Memory Manager (mm/)     |
                         |           swap_writepage / swap_read         |
                         +----------------------+-----------------------+
                                                |
                  +-----------------------------+-----------------------------+
                  | [BARRER HMB HOOK]                                         |
                  | Does HMB claim this slot?                                 |
                  v YES
       v NO (Fallback)
    +---------------------------------+
+---------------------------------+
    |   Haven Memory Bus (Spec 2.0)   |                       |
Traditional Block Subsystem     |
    |  - O(1) Direct Arithmetic Stride|                       |  -
struct bio allocation        |
    |  - Tier 2 z-Pack Deduplication  |                       |  -
blk-mq request queueing      |
    |  - Zero Elevator / Zero Queue   |                       |  -
Elevator scheduler overhead  |
    |  - Sub-microsecond return       |                       |  -
Mechanical / NVMe I/O delay  |
    +---------------------------------+
+---------------------------------+
             Latency: ~0.51 us
Latency: 10 ms - 4.3 min


    Key Files Modified
    ------------------
    1. include/linux/hmb_pagefile.h:
       Interface declarations and zero-overhead inline stubs when
       CONFIG_HMB_PAGEFILE=n.
    2. mm/hmb_pagefile.c:
       Core arithmetic stride plane, atomic bitmasks, Tier 2 z-Pack
deduplication
       engine, and /proc/hmb_pagefile diagnostic telemetry.
    3. mm/page_io.c:
       - swap_writepage(): Direct fast-path hook to hmb_pagefile_store(folio).
       - swap_read_folio(): Direct fast-path hook to hmb_pagefile_load(folio).
    4. mm/swapfile.c:
       - swap_free_cluster(): Lock-free slot reclamation via
hmb_pagefile_free().
    5. mm/Kconfig & mm/Makefile:
       Integrated build configuration (CONFIG_HMB_PAGEFILE).


    Code Quality & Standards
    ========================
    - scripts/checkpatch.pl Compliance: Verified on Linux 7.0 source tree:
      total: 0 errors, 1 warnings, 484 lines checked (warning is informational
      prompt for MAINTAINERS file entry).
    - Coding Style: Standard tabs, 80-column line wrapped, SPDX
GPL-2.0 identifiers.
    - Concurrency: Standard Linux set_bit, clear_bit, and atomic64 primitives.


    Public Repositories & Reproduction
    ==================================
    The complete driver, in-tree kernel patches, and test suites are open-source
    under GPL-2.0:
    - Repository: https://github.com/barrersoftware/hmb
    - Linux 7.0 Patch: kernel/in_tree_patch/hmb_in_tree_linux_7.0.patch
    - Android GKI Review:
https://android-review.googlesource.com/c/kernel/common/+/4376433

    We welcome feedback and discussions regarding integration into mainline mm/.

    Respectfully submitted,
    Daniel Elliott
    Barrer Software Organization
    <ssfdre38@gmail.com>

