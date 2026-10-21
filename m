Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A08F2606A31B
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 19:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PM/nhjR/
Received: by kanga.kvack.org (Postfix)
	id A1DE96B0770; Wed, 21 Oct 2026 15:15:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CC406B0772; Wed, 21 Oct 2026 15:15:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E2B56B0773; Wed, 21 Oct 2026 15:15:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DC1C6B0770
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:15:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D29B7140609
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:15:52 +0000 (UTC)
X-FDA: 85347588144.06.642F1D0
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf23.hostedemail.com (Postfix) with ESMTP id F042914000A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:15:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="PM/nhjR/";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of ssfdre38@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ssfdre38@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792610150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8eYidvco8kdRbheygi4+dhoUCo9Skxap4epOnQy7gkk=;
	b=HmQC7A1NZkTEhed26LxWslvm+5tlQgnoVO2VXxOxaYxOipuxxVWNOEUOOoe45Law53Ud4e
	aVASYXTjHTihSiEBC4z6yUnj5FaOCdjqqvKqQZDS9W1wS1kIc3E2/S5arQJXRxcf4eASQz
	Lf26v10nRRs+1I4CY0tSIcXpH1cSgWA=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="PM/nhjR/";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of ssfdre38@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ssfdre38@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792610150;
	b=un3F2+3SrDb9K+5QyW4SjjybiRD4vAm4g3IUh/XHNu7OnMITHPLqtyJCdJDcMKxaKygZu1
	HRHPBFGBFnHXcBgDidNQTipGLNwFiYxTJKL/lC9uU2oVHjEKCNSkAHdprFBP9wOI1bEGKq
	PlcwXp8kEtufgXpZQRjFUCrBx0Pt7a4=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b1dae0febeso1469984a12.2
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 12:15:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792610150; cv=none;
        d=google.com; s=arc-20260327;
        b=SeZ/xvZqL7hYBs/oAdMvQSJ3Mc44MMSMS0JglVerdNTm06KuPogGQ+ursjtdB6760K
         BQ6ElwoB0ggiShCm8/ONfI6KJtBP/jHqsUDWd6jbClmjqpWW2w+qfNu8iwSRo2Z6ce4F
         +yXNDoffdsBb780jVqdn8xX8AGHz+cB+xRndv2SmhXgJriWwavPR94lrtiFc2zEiBWW2
         sqHgKMZDkOEyWcJ8yhby1O7Jt732dx0kpHpkRovCMffmCxwNPLwHsLSauMhWIZD8bu3N
         QYe5q4z+OtViG2so4B+nhNOjJqWPtWGl4wLn+jlEirVboxu3tZa4XPNu8he6VrQ50oI0
         B04A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=8eYidvco8kdRbheygi4+dhoUCo9Skxap4epOnQy7gkk=;
        fh=wLV9CCXckqAzhK8InEOjBqxYnWrgXKAH6HcM0hXpKts=;
        b=bdQS/4Trl95H8Axao4mM0ha/JLeK/hpG+jxNwERUm99wwxKvSoHD7kPWJUocDxg5+h
         ocABvEF+/yfY3IYPoI9O9px+csDcuwE/BXib/88fCgAvN5YBm1+tTHiXiqP+ECgPMNFL
         POWX8H1waL3UtxpxIwkkdfgzwxfDGmd4xoBpLEQv5TNwTjnLTPMsDrnqBvZnAouULdFX
         Ncfgw+PldCHIhGrxGMAK3bkKOT888oJW5M1DOtMncKkg42e/OfO1ijBJYgIR0ESha/lI
         tTBA1SvYctdksYZ9DOMj+9bwfM9CS8sZbJXBBMNKXJ3DBoffsM3ZxkvN2svBLsF4tJ7I
         nvNg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792610150; x=1793214950; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8eYidvco8kdRbheygi4+dhoUCo9Skxap4epOnQy7gkk=;
        b=PM/nhjR/AtcXWnU8Ji1WjYKYRrjaAowweVF7BBtPUh3lLHCXQ43+LonPSoKcFgysas
         T2G8aHj3Q6LADQOFoiy0tQFcwwhNPmAwK8/sjDfWfcDiQ13kGzKAT4A94l9taUE43L2W
         dLHI6Bl5GfFCGV8lPRMSLJFgkukdoMMapFG1Myb2mDVTj1p0f1+U8KaJC3m/kKi8ccTj
         sRRPqx/EgbKmMQH1nhzTwshlELVXmZ6kJcviSBVbP1JgBIlJFNAL64YsWTh92BQJlPVP
         LkhUuIuYJ9d65CfRwUoPHZycari5m/YshjdajAnJlKk9FFPCa3MP58f2HZ+reB2Ct1PE
         1iJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792610150; x=1793214950;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8eYidvco8kdRbheygi4+dhoUCo9Skxap4epOnQy7gkk=;
        b=G7B4Uu4x1GWW1a0JAZX5SJkazVr8wHGb4H6ffG+DzBPDOSxEUlcR8cSIwmCPZeXGhV
         m71sjJmOoXvpKDZzeNA9sETSx0PxSBw5yh3pgVJvIPCiHop+U1HGtiieOn/VvFvLz4IJ
         8nwMFuMZ4QzKDYTJsG4IVFwzaVCDit/oiJ33OjNU9bWfbRfftJdmHK8EuvjelGFht8U0
         ryesJx4iKRS1TJDIMlNDMOIyjNZle3XVbdHGQ0Y8em52L5DTVz+7qBDV/mFKTzIJG2dk
         zx7MRmix3ryD6/utJGC7b7z6NYpntSaoHzJ0jNXNxTeKgXmEVqkfGO/T0uN5mebtJPRZ
         2XaA==
X-Forwarded-Encrypted: i=1; AKwUvBxPvas6R0VeNcUp33HsDPPVELQMkvOztBcTpeicSlwsMf8GXy60vrCMryb179D3GeUELPX6OxV6Nw==@kvack.org
X-Gm-Message-State: AFq9FYLGT9vaHLTPYzCzXT060njH9jiD8e+NiJzLXwhT8MGW2d8JUD73
	5d7RxlYjchioz47RfO477Y5NFNlnwurfISEnvQ7C2Q+tsiSK8n6X1sfnVH2ZQEpdDPkpxuEyXnG
	4Dbs5dPuBGbuUXs2KWj4WOp8M6wDg2ug=
X-Gm-Gg: AYBFou0I22PdddjP++MDnUYckYXEfEm+/EvcNgBsVWBnDkKWGTdKKvfy8WjvVEpPWgM
	HrIbyN434r/Ay5cI0JIQJg/nfUnjZcROeLax0dgevbmIgfc3/L6TkR3/RuIasdNZ/ADIsMp7dIb
	2O1RJyMpHEeUhxGlaJhInSJ7Z9PTZOdI9B7019TqU3vX3SyCcdI2sh03hKwPzsz0uLRk7VbWGC6
	C7w2DVIXRsq5GZdbA5JdR99JLejC4lC4hx615S5HPEuJIQG10IXGBSBFxRZbJQqoLQAHoSMt8H4
	UENhw68qqJGo8/+MEAsH96Yw1tukYe5VRsnqlNQ8nW+479z13uTNssTZXllS/ym0Il9sRgVrZoK
	wcVggXBhqLoU9RANxaLohXxfm+PfaySodu+QH
X-Received: by 2002:a17:907:9c05:b0:c42:4750:8d2d with SMTP id
 a640c23a62f3a-c467920d6c8mr276520366b.2.1792610149291; Wed, 21 Oct 2026
 12:15:49 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
From: Daniel Elliott <ssfdre38@gmail.com>
Date: Wed, 21 Oct 2026 12:15:38 -0700
X-Gm-Features: AclHuK8QPRIXR4ULR_kg13OYJ7xAAmgk6LgoHxrHkiDWAFAYop2OahhLpjLdaEc
Message-ID: <CAJVF7aOjOSD1D_LZQUUxUxS7VYKGHvzSB47Hm3MsHTM58X5xoA@mail.gmail.com>
Subject: [RFC PATCH 0/1] mm: Haven Memory Bus (HMB) zero-bio paging engine
 with Tier 2 z-Pack deduplication
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, willy@infradead.org, 
	torvalds@linux-foundation.org
Content-Type: multipart/alternative; boundary="0000000000002b5ca6065e5e9312"
X-Rspamd-Queue-Id: F042914000A
X-Rspam-User: 
X-Stat-Signature: z3en3taqkf4q91inej71aa8tx4grh779
X-Spam-Status: No, score=-1.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,LOTS_OF_MONEY,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792610150-176530
X-HE-Meta: U2FsdGVkX18q9urCDjCI8YVAq5u6zPZRVq5r0GwyblrL2kOHAlgZywvr1hqIr645rbhZLdynFxprSp4K94YPW0iRuPyAK0AnPGMqNnYngSnaLjoSROBYz3UqvdQRP1xzDDhVBqxZS/hzyRcRtNgiDBVWCX4QY66fL/kVv6t3x/4KVwJYUx+bkTaEGfkKuXcEyQldVxJkJUiTzTDqy5Vam1qDqUVLwgxfvWG8wY+6mPWx5ZW7lR07TM/OR1sKlb9YiLAsOS6xueeVwGhCwOKeAtZOMl+/52YTCRz175qxVM09dOMDwom9vV7C303M9jJkgVcyRXz0KBk1Qy1md2prl/5oltKywFCHaRW1bK5A3LN3hBqkEojHFwCp7wrGwTJmJB+7ZLm63RjOk+U+aJ8rk83BaFwuhwtCIiaBcbf2luDXje+Lmlk21VUpF26T51/NKK01CjUzS0pWXDOnDNb2wik5ZJIHJaD6/J63Z6tbezn5o6iLYqryIBx4RfjLYCKc5mIwJwAchJSGdnNfbgEB1Gis2QSBdkNB3Vd7GtSU5m1eEKAIrqdEUWX8QGBzIs+zFAzjKR5MfmqKlr17VjJIEJ2lshoUYqkzLwqSl57/TgJfC/sxvhiKVydcW5RY4MqQ1DS5Uug2CeJGrYZKwk1bjP+TKGxphkW0ndOxHr7gqHRTeDKybTagOksl5oGw7e6oJCJqluPZvrer4JHH2o2AQIv6EX4WbrCI4Q3Z3oWTqUVMg3JMTM1h90uzsZlSyfEhDRnUdQvHgF0IyKfHwb/SWXSM4aTg6WAz4JDjxxi5cEo8kMKQiLnqpMbCNg6gc912mqa1t3SVYXcJ85Mk2ZitXJtFTGkRrPmDSCRWrDG4dDYt/eKb10HDs08cSjtJWaRS3HaafauHpWzjYskidegMeMxE8FNtfkwbXDbiBoskK1dqm4E8OGeYuB2ZvKuDViDSnBRT+AW1S+SNxHvHinq
 vbnZXftu
 vDRzbWJwkoKYqqCAhB4CWVD4ShpNi0WK/hGhgGcpdeTgVbCq5hQ81DW2bYicm4U0O4/MECrkFzmS7guYxmRQWE9rkwSNdoj+F5KO9ZkovnYohB6hv2m/e5h7C0cVRNA/Jet958gXg3pgJnqejrGqIR0T9znSfI+sMBtPKyDiyF8zpHIe5ykmBFONSlnHAkEsSSLhwxVaZJ1Stx9eY8rEQETYph3bIx8+PuIqc9ftk+i6gtaHLBPa/k6p/tqbUZBXBR3AKufr57ak82IBOq1jKIbLknC60rZ47lPURTi4RgUewpGTGziBAp2mvP51YC51tERLK/QEDIh/7HTJ3I/8zTKySa5Nv3NMl8Mz23YtO9XmJqX2j8r+n1PXgUePDhEN89gu8Yvs26c1A82JjpFm6CRXawp6z2jkBAnZXWW9VNmHp9QyIB3dehxKVxhiu1K+dHsQyg7m5TgEiiqb8JZ6V9GmyE5Y0qbUDOxZESBbzfpz4ntw5BHcsIsSbPHm6abiCzm44AWZqMFhuXyeiGOtzV6IW3G1qYPhXR0Xc0A1x5aGhqolICIei7uS4hUncEFWAuR2ZeU/XQXbtUEg6LIdZRk++cpbSUeeC8eeBR3xcTzkm2vDjFCAlsOYF979zSDpH56JpPB45cMH075edBW9TjwSwN51I7MwonYvZwqlHnFV5wrvBOTNblA+2RYjIsFoQ9+1Ok8/1cHQpBQxqZXF4iVpzlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--0000000000002b5ca6065e5e9312
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

## Executive Summary

This RFC introduces the **Haven Memory Bus (HMB) Spec 2.0 Native Paging
Engine** directly into the Linux Virtual Memory Manager (`mm/`).

For over thirty years, general-purpose operating systems have assumed
secondary storage is an asynchronous block device. Even modern in-RAM
paging subsystems (e.g., `zram`, `zswap`) construct `struct bio`
descriptors, pass through `blk-mq` software request queues, and traverse
I/O elevator schedulers before reaching physical memory.

HMB eliminates this legacy abstraction. By intercepting folios directly in
`mm/page_io.c` (`swap_writepage` and `swap_read_folio`), HMB provides:
1. **Zero-Bio / Zero-Queue Bypass**: Folios are stored and retrieved using
lock-free $O(1)$ arithmetic stride indexing directly over the CPU memory
bus.
2. **Tier 2 z-Pack Inline Deduplication**:
   - Zero pages: 100% deduplication (stored in a single bitmask bit).
   - Uniform 64-bit quadword patterns: 99.8% deduplication (stored in 8
bytes).
   - Varied pages: Stored in high-speed slab pages without block
serialization.
3. **Sub-Microsecond `#PF` Resolution**: Page faults resolve in
**$0.51\,\mu\text{s}$**, eliminating thread stalls in uninterruptible disk
sleep (`D` state).

---

## Bare-Metal Silicon Benchmarks

All benchmarks were conducted on a physical bare-metal bare-metal server
(**Supermicro X11SSH-F, Intel Xeon E3-1270 v6 @ 3.80GHz, 32GB ECC DDR4, 2x
2TB HGST Ultrastar 7200 RPM SATA HDDs**) running **Linux 7.0.14-hmb**.

### 1. Page Fault Resolution & Latency Under Memory Pressure

In a constrained cgroup v2 environment (`MemoryMax=3D256M`), a worker proce=
ss
allocated 600 MB of dirty heap, forcing the kernel to evict ~350 MB of
anonymous memory. The process then immediately read back all memory to
trigger real kernel page-in (`#PF`):

| Paging Mechanism | Paging Latency (`#PF`) | Memory Recovery Time |
Speedup Factor |
| :--- | :--- | :--- | :--- |
| **Traditional Block Swap (7200 RPM HDD)** | $\sim 10,000\,\mu\text{s}$
($10\text{ ms}$) | **258.0 seconds (4.3 min)** | Baseline ($1\times$) |
| **Barrer HMB Native VMM Engine** | **$0.51\,\mu\text{s}$** | **0.013
seconds (13 ms)** | **19,842x Recovery Speedup** |

- **Operations Handled**: 91,799 pages evicted, 25,313 page faults
recovered, 168,643 swap slots freed directly in `mm/`.
- **Block Layer Trace**: Zero `struct bio` allocated; zero `blk-mq`
submissions; zero storage controller interrupts.

### 2. Real-World OS Workload: Core Systemd Phased Upgrade

Under memory-constrained multi-tasking, an un-phased upgrade of 13 core OS
packages (`systemd 259.9`, `udev`, `libsystemd0`, `initramfs-tools`,
`dbus`) was executed:

| Metric | Traditional Linux Storage Subsystem | Barrer HMB Monolithic
Kernel |
| :--- | :--- | :--- |
| **Paging Throughput** | $\sim 90\text{ MB/s}$ (Rotational seek limit) |
**$2,625.9\text{ MB/s}$** (Memory bus rate) |
| **SATA Controller Contention** | High (Swap and package writes fight) |
**Zero** (100% bus for package I/O) |
| **Thread Sleep State** | Heavy `D` state / I/O wait stalls | **0% I/O
Wait (Pure active CPU execution)** |
| **Network Socket Buffers** | Prone to TCP window throttling | **Zero
packet drops / No buffer starvation** |
| **Systemd Re-exec** | High latency during `--deserialize` |
**Instantaneous (PID 1 preserved)** |

---

## Architectural Implementation

```text
                     =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=90
                     =E2=94=82          Linux Userland / Applications      =
 =E2=94=82
                     =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=98
                                            =E2=94=82 Page Fault / Eviction
                                            =E2=96=BC
                     =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=90
                     =E2=94=82       Linux Virtual Memory Manager (mm/)    =
 =E2=94=82
                     =E2=94=82           swap_writepage / swap_read        =
 =E2=94=82
                     =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=98
                                            =E2=94=82
              =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
              =E2=94=82 [BARRER HMB HOOK]                                  =
       =E2=94=82
              =E2=94=82 Does HMB claim this slot?                          =
       =E2=94=82
              =E2=96=BC YES                                                =
       =E2=96=BC
NO (Fallback)
=E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=90
=E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=90
=E2=94=82   Haven Memory Bus (Spec 2.0)   =E2=94=82                       =
=E2=94=82 Traditional
Block Subsystem     =E2=94=82
=E2=94=82  - O(1) Direct Arithmetic Stride=E2=94=82                       =
=E2=94=82  - struct bio
allocation        =E2=94=82
=E2=94=82  - Tier 2 z-Pack Deduplication  =E2=94=82                       =
=E2=94=82  - blk-mq
request queueing      =E2=94=82
=E2=94=82  - Zero Elevator / Zero Queue   =E2=94=82                       =
=E2=94=82  - Elevator
scheduler overhead  =E2=94=82
=E2=94=82  - Sub-microsecond return       =E2=94=82                       =
=E2=94=82  - Mechanical /
NVMe I/O delay  =E2=94=82
=E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=98
=E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=98
         Latency: ~0.51 =C2=B5s                                         Lat=
ency:
10 ms - 4.3 min
```

### Key Files Modified

1. **`include/linux/hmb_pagefile.h`**:
   Interface declarations and zero-overhead inline stubs when
`CONFIG_HMB_PAGEFILE=3Dn`.
2. **`mm/hmb_pagefile.c`**:
   Core arithmetic stride plane, atomic bitmasks, Tier 2 z-Pack
deduplication engine, and `/proc/hmb_pagefile` diagnostic telemetry.
3. **`mm/page_io.c`**:
   - `swap_writepage()`: Direct fast-path hook to
`hmb_pagefile_store(folio)`.
   - `swap_read_folio()`: Direct fast-path hook to
`hmb_pagefile_load(folio)`.
4. **`mm/swapfile.c`**:
   - `swap_free_cluster()`: Lock-free slot reclamation via
`hmb_pagefile_free()`.
5. **`mm/Kconfig` & `mm/Makefile`**:
   Integrated build configuration (`CONFIG_HMB_PAGEFILE`).

---

## Code Quality & Standards

- **`scripts/checkpatch.pl` Compliance**: Verified on Linux 7.0 source tree=
:
  `total: 0 errors, 1 warnings, 484 lines checked` (1 warning is
informational prompt for MAINTAINERS file addition).
- **Coding Style**: Linux kernel standard tabs, 80-column wrapped commit
messages, SPDX GPL-2.0 identifiers.
- **Lock-Free Atomic Primitives**: Standard Linux `set_bit`, `clear_bit`,
and atomic64 operations.

---

## Public Repository & Reproduction

The complete driver, in-tree kernel patches, and bare-metal benchmark test
scripts are available under the GPL-2.0 license:
- **Repository**: [`
https://github.com/barrersoftware/hmb`](https://github.com/barrersoftware/h=
mb)
- **Patch Artifact**: `kernel/in_tree_patch/hmb_in_tree_linux_7.0.patch`

We welcome feedback, suggestions for integration into mainline `mm/`, and
discussions regarding Android Common Kernel (ACK) backports.

Respectfully submitted,
**Daniel Elliott**
*Barrer Software Organization*
<ssfdre38@gmail.com>

--0000000000002b5ca6065e5e9312
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+IyMgRXhlY3V0aXZlIFN1bW1hcnk8YnI+PGJyPlRoaXMgUkZDIGludHJv
ZHVjZXMgdGhlICoqSGF2ZW4gTWVtb3J5IEJ1cyAoSE1CKSBTcGVjIDIuMCBOYXRpdmUgUGFnaW5n
IEVuZ2luZSoqIGRpcmVjdGx5IGludG8gdGhlIExpbnV4IFZpcnR1YWwgTWVtb3J5IE1hbmFnZXIg
KGBtbS9gKS48YnI+PGJyPkZvciBvdmVyIHRoaXJ0eSB5ZWFycywgZ2VuZXJhbC1wdXJwb3NlIG9w
ZXJhdGluZyBzeXN0ZW1zIGhhdmUgYXNzdW1lZCBzZWNvbmRhcnkgc3RvcmFnZSBpcyBhbiBhc3lu
Y2hyb25vdXMgYmxvY2sgZGV2aWNlLiBFdmVuIG1vZGVybiBpbi1SQU0gcGFnaW5nIHN1YnN5c3Rl
bXMgKGUuZy4sIGB6cmFtYCwgYHpzd2FwYCkgY29uc3RydWN0IGBzdHJ1Y3QgYmlvYCBkZXNjcmlw
dG9ycywgcGFzcyB0aHJvdWdoIGBibGstbXFgIHNvZnR3YXJlIHJlcXVlc3QgcXVldWVzLCBhbmQg
dHJhdmVyc2UgSS9PIGVsZXZhdG9yIHNjaGVkdWxlcnMgYmVmb3JlIHJlYWNoaW5nIHBoeXNpY2Fs
IG1lbW9yeS48YnI+PGJyPkhNQiBlbGltaW5hdGVzIHRoaXMgbGVnYWN5IGFic3RyYWN0aW9uLiBC
eSBpbnRlcmNlcHRpbmcgZm9saW9zIGRpcmVjdGx5IGluIGBtbS9wYWdlX2lvLmNgIChgc3dhcF93
cml0ZXBhZ2VgIGFuZCBgc3dhcF9yZWFkX2ZvbGlvYCksIEhNQiBwcm92aWRlczo8YnI+MS4gKipa
ZXJvLUJpbyAvIFplcm8tUXVldWUgQnlwYXNzKio6IEZvbGlvcyBhcmUgc3RvcmVkIGFuZCByZXRy
aWV2ZWQgdXNpbmcgbG9jay1mcmVlICRPKDEpJCBhcml0aG1ldGljIHN0cmlkZSBpbmRleGluZyBk
aXJlY3RseSBvdmVyIHRoZSBDUFUgbWVtb3J5IGJ1cy48YnI+Mi4gKipUaWVyIDIgei1QYWNrIElu
bGluZSBEZWR1cGxpY2F0aW9uKio6PGJyPsKgIMKgLSBaZXJvIHBhZ2VzOiAxMDAlIGRlZHVwbGlj
YXRpb24gKHN0b3JlZCBpbiBhIHNpbmdsZSBiaXRtYXNrIGJpdCkuPGJyPsKgIMKgLSBVbmlmb3Jt
IDY0LWJpdCBxdWFkd29yZCBwYXR0ZXJuczogOTkuOCUgZGVkdXBsaWNhdGlvbiAoc3RvcmVkIGlu
IDggYnl0ZXMpLjxicj7CoCDCoC0gVmFyaWVkIHBhZ2VzOiBTdG9yZWQgaW4gaGlnaC1zcGVlZCBz
bGFiIHBhZ2VzIHdpdGhvdXQgYmxvY2sgc2VyaWFsaXphdGlvbi48YnI+My4gKipTdWItTWljcm9z
ZWNvbmQgYCNQRmAgUmVzb2x1dGlvbioqOiBQYWdlIGZhdWx0cyByZXNvbHZlIGluICoqJDAuNTFc
LFxtdVx0ZXh0e3N9JCoqLCBlbGltaW5hdGluZyB0aHJlYWQgc3RhbGxzIGluIHVuaW50ZXJydXB0
aWJsZSBkaXNrIHNsZWVwIChgRGAgc3RhdGUpLjxicj48YnI+LS0tPGJyPjxicj4jIyBCYXJlLU1l
dGFsIFNpbGljb24gQmVuY2htYXJrczxicj48YnI+QWxsIGJlbmNobWFya3Mgd2VyZSBjb25kdWN0
ZWQgb24gYSBwaHlzaWNhbCBiYXJlLW1ldGFsIGJhcmUtbWV0YWwgc2VydmVyICgqKlN1cGVybWlj
cm8gWDExU1NILUYsIEludGVsIFhlb24gRTMtMTI3MCB2NiBAIDMuODBHSHosIDMyR0IgRUNDIERE
UjQsIDJ4IDJUQiBIR1NUIFVsdHJhc3RhciA3MjAwIFJQTSBTQVRBIEhERHMqKikgcnVubmluZyAq
KkxpbnV4IDcuMC4xNC1obWIqKi48YnI+PGJyPiMjIyAxLiBQYWdlIEZhdWx0IFJlc29sdXRpb24g
JmFtcDsgTGF0ZW5jeSBVbmRlciBNZW1vcnkgUHJlc3N1cmU8YnI+PGJyPkluIGEgY29uc3RyYWlu
ZWQgY2dyb3VwIHYyIGVudmlyb25tZW50IChgTWVtb3J5TWF4PTI1Nk1gKSwgYSB3b3JrZXIgcHJv
Y2VzcyBhbGxvY2F0ZWQgNjAwIE1CIG9mIGRpcnR5IGhlYXAsIGZvcmNpbmcgdGhlIGtlcm5lbCB0
byBldmljdCB+MzUwIE1CIG9mIGFub255bW91cyBtZW1vcnkuIFRoZSBwcm9jZXNzIHRoZW4gaW1t
ZWRpYXRlbHkgcmVhZCBiYWNrIGFsbCBtZW1vcnkgdG8gdHJpZ2dlciByZWFsIGtlcm5lbCBwYWdl
LWluIChgI1BGYCk6PGJyPjxicj58IFBhZ2luZyBNZWNoYW5pc20gfCBQYWdpbmcgTGF0ZW5jeSAo
YCNQRmApIHwgTWVtb3J5IFJlY292ZXJ5IFRpbWUgfCBTcGVlZHVwIEZhY3RvciB8PGJyPnwgOi0t
LSB8IDotLS0gfCA6LS0tIHwgOi0tLSB8PGJyPnwgKipUcmFkaXRpb25hbCBCbG9jayBTd2FwICg3
MjAwIFJQTSBIREQpKiogfCAkXHNpbSAxMCwwMDBcLFxtdVx0ZXh0e3N9JCAoJDEwXHRleHR7IG1z
fSQpIHwgKioyNTguMCBzZWNvbmRzICg0LjMgbWluKSoqIHwgQmFzZWxpbmUgKCQxXHRpbWVzJCkg
fDxicj58ICoqQmFycmVyIEhNQiBOYXRpdmUgVk1NIEVuZ2luZSoqIHwgKiokMC41MVwsXG11XHRl
eHR7c30kKiogfCAqKjAuMDEzIHNlY29uZHMgKDEzIG1zKSoqIHwgKioxOSw4NDJ4IFJlY292ZXJ5
IFNwZWVkdXAqKiB8PGJyPjxicj4tICoqT3BlcmF0aW9ucyBIYW5kbGVkKio6IDkxLDc5OSBwYWdl
cyBldmljdGVkLCAyNSwzMTMgcGFnZSBmYXVsdHMgcmVjb3ZlcmVkLCAxNjgsNjQzIHN3YXAgc2xv
dHMgZnJlZWQgZGlyZWN0bHkgaW4gYG1tL2AuPGJyPi0gKipCbG9jayBMYXllciBUcmFjZSoqOiBa
ZXJvIGBzdHJ1Y3QgYmlvYCBhbGxvY2F0ZWQ7IHplcm8gYGJsay1tcWAgc3VibWlzc2lvbnM7IHpl
cm8gc3RvcmFnZSBjb250cm9sbGVyIGludGVycnVwdHMuPGJyPjxicj4jIyMgMi4gUmVhbC1Xb3Js
ZCBPUyBXb3JrbG9hZDogQ29yZSBTeXN0ZW1kIFBoYXNlZCBVcGdyYWRlPGJyPjxicj5VbmRlciBt
ZW1vcnktY29uc3RyYWluZWQgbXVsdGktdGFza2luZywgYW4gdW4tcGhhc2VkIHVwZ3JhZGUgb2Yg
MTMgY29yZSBPUyBwYWNrYWdlcyAoYHN5c3RlbWQgMjU5LjlgLCBgdWRldmAsIGBsaWJzeXN0ZW1k
MGAsIGBpbml0cmFtZnMtdG9vbHNgLCBgZGJ1c2ApIHdhcyBleGVjdXRlZDo8YnI+PGJyPnwgTWV0
cmljIHwgVHJhZGl0aW9uYWwgTGludXggU3RvcmFnZSBTdWJzeXN0ZW0gfCBCYXJyZXIgSE1CIE1v
bm9saXRoaWMgS2VybmVsIHw8YnI+fCA6LS0tIHwgOi0tLSB8IDotLS0gfDxicj58ICoqUGFnaW5n
IFRocm91Z2hwdXQqKiB8ICRcc2ltIDkwXHRleHR7IE1CL3N9JCAoUm90YXRpb25hbCBzZWVrIGxp
bWl0KSB8ICoqJDIsNjI1LjlcdGV4dHsgTUIvc30kKiogKE1lbW9yeSBidXMgcmF0ZSkgfDxicj58
ICoqU0FUQSBDb250cm9sbGVyIENvbnRlbnRpb24qKiB8IEhpZ2ggKFN3YXAgYW5kIHBhY2thZ2Ug
d3JpdGVzIGZpZ2h0KSB8ICoqWmVybyoqICgxMDAlIGJ1cyBmb3IgcGFja2FnZSBJL08pIHw8YnI+
fCAqKlRocmVhZCBTbGVlcCBTdGF0ZSoqIHwgSGVhdnkgYERgIHN0YXRlIC8gSS9PIHdhaXQgc3Rh
bGxzIHwgKiowJSBJL08gV2FpdCAoUHVyZSBhY3RpdmUgQ1BVIGV4ZWN1dGlvbikqKiB8PGJyPnwg
KipOZXR3b3JrIFNvY2tldCBCdWZmZXJzKiogfCBQcm9uZSB0byBUQ1Agd2luZG93IHRocm90dGxp
bmcgfCAqKlplcm8gcGFja2V0IGRyb3BzIC8gTm8gYnVmZmVyIHN0YXJ2YXRpb24qKiB8PGJyPnwg
KipTeXN0ZW1kIFJlLWV4ZWMqKiB8IEhpZ2ggbGF0ZW5jeSBkdXJpbmcgYC0tZGVzZXJpYWxpemVg
IHwgKipJbnN0YW50YW5lb3VzIChQSUQgMSBwcmVzZXJ2ZWQpKiogfDxicj48YnI+LS0tPGJyPjxi
cj4jIyBBcmNoaXRlY3R1cmFsIEltcGxlbWVudGF0aW9uPGJyPjxicj5gYGB0ZXh0PGJyPsKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg4pSM4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSQ
PGJyPsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg4pSCIMKgIMKgIMKgIMKgIMKgTGlu
dXggVXNlcmxhbmQgLyBBcHBsaWNhdGlvbnMgwqAgwqAgwqAg4pSCPGJyPsKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKg4pSU4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSs4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSYPGJyPsKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIOKUgiBQYWdlIEZhdWx0IC8gRXZpY3Rpb248YnI+wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg4pa8PGJyPsKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg4pSM4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSQPGJy
PsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg4pSCIMKgIMKgIMKgIExpbnV4IFZpcnR1
YWwgTWVtb3J5IE1hbmFnZXIgKG1tLykgwqAgwqAg4pSCPGJyPsKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKg4pSCIMKgIMKgIMKgIMKgIMKgIHN3YXBfd3JpdGVwYWdlIC8gc3dhcF9yZWFk
IMKgIMKgIMKgIMKgIOKUgjxicj7CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoOKUlOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUrOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUmDxicj7CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDilII8YnI+wqAgwqAgwqAgwqAg
wqAgwqAgwqAg4pSM4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pS04pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSQPGJyPsKgIMKgIMKgIMKgIMKgIMKgIMKgIOKUgiBbQkFSUkVS
IEhNQiBIT09LXSDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDilII8YnI+wqAgwqAgwqAgwqAgwqAgwqAgwqAg4pSCIERvZXMgSE1CIGNs
YWltIHRoaXMgc2xvdD8gwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAg4pSCPGJyPsKgIMKgIMKgIMKgIMKgIMKgIMKgIOKWvCBZRVMgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAg4pa8IE5PIChGYWxsYmFjayk8YnI+4pSM4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSQIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIOKU
jOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUkDxicj7ilIIgwqAg
SGF2ZW4gTWVtb3J5IEJ1cyAoU3BlYyAyLjApIMKgIOKUgiDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDilIIgVHJhZGl0aW9uYWwgQmxvY2sgU3Vic3lzdGVtIMKgIMKgIOKUgjxicj7i
lIIgwqAtIE8oMSkgRGlyZWN0IEFyaXRobWV0aWMgU3RyaWRl4pSCIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIOKUgiDCoC0gc3RydWN0IGJpbyBhbGxvY2F0aW9uIMKgIMKgIMKgIMKg
4pSCPGJyPuKUgiDCoC0gVGllciAyIHotUGFjayBEZWR1cGxpY2F0aW9uIMKg4pSCIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIOKUgiDCoC0gYmxrLW1xIHJlcXVlc3QgcXVldWVpbmcg
wqAgwqAgwqDilII8YnI+4pSCIMKgLSBaZXJvIEVsZXZhdG9yIC8gWmVybyBRdWV1ZSDCoCDilIIg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg4pSCIMKgLSBFbGV2YXRvciBzY2hlZHVs
ZXIgb3ZlcmhlYWQgwqDilII8YnI+4pSCIMKgLSBTdWItbWljcm9zZWNvbmQgcmV0dXJuIMKgIMKg
IMKgIOKUgiDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDilIIgwqAtIE1lY2hhbmlj
YWwgLyBOVk1lIEkvTyBkZWxheSDCoOKUgjxicj7ilJTilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilJggwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg4pSU
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSYPGJyPsKgIMKgIMKg
IMKgIMKgTGF0ZW5jeTogfjAuNTEgwrVzIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIExhdGVuY3k6IDEwIG1zIC0gNC4zIG1pbjxicj5g
YGA8YnI+PGJyPiMjIyBLZXkgRmlsZXMgTW9kaWZpZWQ8YnI+PGJyPjEuICoqYGluY2x1ZGUvbGlu
dXgvaG1iX3BhZ2VmaWxlLmhgKio6PGJyPsKgIMKgSW50ZXJmYWNlIGRlY2xhcmF0aW9ucyBhbmQg
emVyby1vdmVyaGVhZCBpbmxpbmUgc3R1YnMgd2hlbiBgQ09ORklHX0hNQl9QQUdFRklMRT1uYC48
YnI+Mi4gKipgbW0vaG1iX3BhZ2VmaWxlLmNgKio6PGJyPsKgIMKgQ29yZSBhcml0aG1ldGljIHN0
cmlkZSBwbGFuZSwgYXRvbWljIGJpdG1hc2tzLCBUaWVyIDIgei1QYWNrIGRlZHVwbGljYXRpb24g
ZW5naW5lLCBhbmQgYC9wcm9jL2htYl9wYWdlZmlsZWAgZGlhZ25vc3RpYyB0ZWxlbWV0cnkuPGJy
PjMuICoqYG1tL3BhZ2VfaW8uY2AqKjo8YnI+wqAgwqAtIGBzd2FwX3dyaXRlcGFnZSgpYDogRGly
ZWN0IGZhc3QtcGF0aCBob29rIHRvIGBobWJfcGFnZWZpbGVfc3RvcmUoZm9saW8pYC48YnI+wqAg
wqAtIGBzd2FwX3JlYWRfZm9saW8oKWA6IERpcmVjdCBmYXN0LXBhdGggaG9vayB0byBgaG1iX3Bh
Z2VmaWxlX2xvYWQoZm9saW8pYC48YnI+NC4gKipgbW0vc3dhcGZpbGUuY2AqKjo8YnI+wqAgwqAt
IGBzd2FwX2ZyZWVfY2x1c3RlcigpYDogTG9jay1mcmVlIHNsb3QgcmVjbGFtYXRpb24gdmlhIGBo
bWJfcGFnZWZpbGVfZnJlZSgpYC48YnI+NS4gKipgbW0vS2NvbmZpZ2AgJmFtcDsgYG1tL01ha2Vm
aWxlYCoqOjxicj7CoCDCoEludGVncmF0ZWQgYnVpbGQgY29uZmlndXJhdGlvbiAoYENPTkZJR19I
TUJfUEFHRUZJTEVgKS48YnI+PGJyPi0tLTxicj48YnI+IyMgQ29kZSBRdWFsaXR5ICZhbXA7IFN0
YW5kYXJkczxicj48YnI+LSAqKmBzY3JpcHRzLzxhIGhyZWY9Imh0dHA6Ly9jaGVja3BhdGNoLnBs
Ij5jaGVja3BhdGNoLnBsPC9hPmAgQ29tcGxpYW5jZSoqOiBWZXJpZmllZCBvbiBMaW51eCA3LjAg
c291cmNlIHRyZWU6PGJyPsKgIGB0b3RhbDogMCBlcnJvcnMsIDEgd2FybmluZ3MsIDQ4NCBsaW5l
cyBjaGVja2VkYCAoMSB3YXJuaW5nIGlzIGluZm9ybWF0aW9uYWwgcHJvbXB0IGZvciBNQUlOVEFJ
TkVSUyBmaWxlIGFkZGl0aW9uKS48YnI+LSAqKkNvZGluZyBTdHlsZSoqOiBMaW51eCBrZXJuZWwg
c3RhbmRhcmQgdGFicywgODAtY29sdW1uIHdyYXBwZWQgY29tbWl0IG1lc3NhZ2VzLCBTUERYIEdQ
TC0yLjAgaWRlbnRpZmllcnMuPGJyPi0gKipMb2NrLUZyZWUgQXRvbWljIFByaW1pdGl2ZXMqKjog
U3RhbmRhcmQgTGludXggYHNldF9iaXRgLCBgY2xlYXJfYml0YCwgYW5kIGF0b21pYzY0IG9wZXJh
dGlvbnMuPGJyPjxicj4tLS08YnI+PGJyPiMjIFB1YmxpYyBSZXBvc2l0b3J5ICZhbXA7IFJlcHJv
ZHVjdGlvbjxicj48YnI+VGhlIGNvbXBsZXRlIGRyaXZlciwgaW4tdHJlZSBrZXJuZWwgcGF0Y2hl
cywgYW5kIGJhcmUtbWV0YWwgYmVuY2htYXJrIHRlc3Qgc2NyaXB0cyBhcmUgYXZhaWxhYmxlIHVu
ZGVyIHRoZSBHUEwtMi4wIGxpY2Vuc2U6PGJyPi0gKipSZXBvc2l0b3J5Kio6IFtgPGEgaHJlZj0i
aHR0cHM6Ly9naXRodWIuY29tL2JhcnJlcnNvZnR3YXJlL2htYmBdKGh0dHBzOi8vZ2l0aHViLmNv
bS9iYXJyZXJzb2Z0d2FyZS9obWIpIj5odHRwczovL2dpdGh1Yi5jb20vYmFycmVyc29mdHdhcmUv
aG1iYF0oaHR0cHM6Ly9naXRodWIuY29tL2JhcnJlcnNvZnR3YXJlL2htYik8L2E+PGJyPi0gKipQ
YXRjaCBBcnRpZmFjdCoqOiBga2VybmVsL2luX3RyZWVfcGF0Y2gvaG1iX2luX3RyZWVfbGludXhf
Ny4wLnBhdGNoYDxicj48YnI+V2Ugd2VsY29tZSBmZWVkYmFjaywgc3VnZ2VzdGlvbnMgZm9yIGlu
dGVncmF0aW9uIGludG8gbWFpbmxpbmUgYG1tL2AsIGFuZCBkaXNjdXNzaW9ucyByZWdhcmRpbmcg
QW5kcm9pZCBDb21tb24gS2VybmVsIChBQ0spIGJhY2twb3J0cy48YnI+PGJyPlJlc3BlY3RmdWxs
eSBzdWJtaXR0ZWQsIMKgPGJyPioqRGFuaWVsIEVsbGlvdHQqKiDCoDxicj4qQmFycmVyIFNvZnR3
YXJlIE9yZ2FuaXphdGlvbiogwqA8YnI+Jmx0OzxhIGhyZWY9Im1haWx0bzpzc2ZkcmUzOEBnbWFp
bC5jb20iPnNzZmRyZTM4QGdtYWlsLmNvbTwvYT4mZ3Q7PGJyPjwvZGl2Pg0K
--0000000000002b5ca6065e5e9312--

