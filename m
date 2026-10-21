Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 790FD606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 19:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=e8IKadvl
Received: by kanga.kvack.org (Postfix)
	id 7A5A06B0257; Wed, 21 Oct 2026 15:13:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 756506B0258; Wed, 21 Oct 2026 15:13:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 645EA6B025B; Wed, 21 Oct 2026 15:13:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 352536B0257
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:13:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3376A80635
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:13:25 +0000 (UTC)
X-FDA: 85347581970.04.CD95D57
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5679714000D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:13:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e8IKadvl;
	spf=pass (imf23.hostedemail.com: domain of ssfdre38@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ssfdre38@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792610003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ok17Xc1DEyQ/Ce2eRH1DvaxEYg+rLbLiT+tB6jPCiX4=;
	b=PQ/0X5hPxqjZ5ndQU1YLmyX2kOuK4Ac6+2JMOAtYBJ1fPc5wWUkWoyVCOCgnVpiWn8OnOY
	LLCow/CeLu7WOQH5XVa9tuX3RUxDhYnlfckfqVbJcVxkiU53buPUXnpeEcm9jmHmlrhBK8
	NR5KaDIbIHSzb7raS73xUfefeqnoBr0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792610003;
	b=ilKW4vD+2+8143whmEyszCqic4d4qCEwID81p5sNMih7smRL5VjdgIRgNzA2mMQHvjg3MW
	dClV9R9QoZTmkXyYd62P1BpAHVTSp3lhSHC87FQ9Ot1ph4wC6fPGQopdgMF/d1db6g65W3
	pk7T/u4m1rI3J/2CgTF2RxCkdgiUAoQ=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=e8IKadvl;
	spf=pass (imf23.hostedemail.com: domain of ssfdre38@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ssfdre38@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c423b145922so141049866b.3
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 12:13:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792610002; cv=none;
        d=google.com; s=arc-20260327;
        b=pnZCHCxK1jiv7Beg3hyacVn8wZpnkjfZsK3tctuhNku5ZqL8zMhRuYSyxQsdNEQjga
         E1BQtCF0vDkewfyd/G5YrFm23aRlUxPZM4AKcEMZ5ygEz491srASSs7NczoONTIquSMD
         HWY3Q0bPz+Eo5cH68LWsTFMDxCyOtPET8YEmMSP4JCnnMPOhfmIMiizBTRIjGWeppeCF
         42AZY0Cb2oVuw3qeA/I6vtU62ELj5v1yBRHbKUxlz27qkafEZdiviyolucKGeXDrOm72
         2U1W8AI+F+k7hK/w+v5PaI63mgsvA6eQ5lSPgzjVChRQtUuKY58pMeV36vFMWkrEx/3I
         QnuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=Ok17Xc1DEyQ/Ce2eRH1DvaxEYg+rLbLiT+tB6jPCiX4=;
        fh=c+Po4BXdaHMWkJRBm7lwnqNh9rW/3N0hR4RJvda2/Lk=;
        b=HFuy73zmhwimGqtjIy2V5VZFe3O7E35MsVEE1xgeUI0SP2hdgflShstazsAoPGDqwg
         6yVDmk1Df69xj3w/CS7sqkyFJh5YEJmwCCgkl45HHyTZAR5XFSzWVvJ+XQbxMlJpTX/h
         W8NbzarMhZhZmfdPigo/FemrfoQXEQ+CXDomFS4WfbErht8hrxcSLJQIOqxZBUbqiVpi
         BwSCa/d88EZyq3D6vgBbuk9oXRB+/Ilh3gQeGvhCzwvES48MzkocQz2EzAzQMF3irxJu
         /wo+NLrkk8tVl4Kmv6Ge39lKI1QYzg0Vjx1oUGG2kbrI8zfKaOk7wFiBhBn3PEle3IyO
         9abw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792610002; x=1793214802; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ok17Xc1DEyQ/Ce2eRH1DvaxEYg+rLbLiT+tB6jPCiX4=;
        b=e8IKadvlGqcgLdnt5VAU1JhDRA5EYpdzWzRVWB+7XA4iB25bg7ErpaBC2Lla6UkuSS
         Fwa6c5D2JXyRxFpnEaQje0c4AkDdtQfygXmrcuUV6XRS6+ddE9957f+deCLlyBLpDoRr
         mYJW9NSXSqZXUF1rOJtbvx0+ti184TVWrTx1MQJWntUESahlSQPaPaIjO3TaO4Z7nDun
         10+4kMVrJZJMrQoaFXYwqd+vAZq2mu9VGb35Na/bAnfo3naE3L3BBhuLTvPVDa1nGgeQ
         z+1u8MPYxEbRfsF1GMivs3W3ofSH5OfG2FlEze2JxVDmtqDZ7qJvRoP1rPVDlNh7zEc0
         clMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792610002; x=1793214802;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Ok17Xc1DEyQ/Ce2eRH1DvaxEYg+rLbLiT+tB6jPCiX4=;
        b=UmRsrzqL8KWfNLut0cKNm6o4difbtTps1UNwHGIgkhNkUlDSEeWb271+fDzTiiTHIT
         lXpXAxnKGb4+RzsIM+mN7LYBGfAAeS2yZiyssFZaGh6S3a8MWW6ZNviMe+L5aFgdFEyp
         yTMRTaccSEwey3Uc3t59QqFSg2JrxhsPEjREh4iS/iA7hmkRzekdcxyiZD3FLV73bbmx
         u2epjSWvU48O2GGp5gqtfctuEE306kPccjyvUi7W+Q/KdripUzYPYHcRigI1KfqNgZHD
         wyN+ix8DEjDQbsEwHgTFJAHq4OaCeEM0wUEYnKoJdXbmMptHNrkjWBMhUfVFCk4qtOYr
         FtDw==
X-Gm-Message-State: AFq9FYKU5/0YPR93jRbCMzcOFe4m6NxtKafBG2/3Reds1AMePwxxLk2n
	jOXmMwbAh6wzRe5fY2BFKVsZXZt3Kq0b/BEdG6Y9eQ+BlaGh1M/PpemTlvd4c9ti0gQ+OMgaMFh
	eMG7NtlWLZC0/9LOv9m6/ohzsWtMQIkr7bq8iMUU=
X-Gm-Gg: AYBFou0b+IfRBoy3omRtN43TTUUOAfSlq5cfGq9o7hoNFw0HvJHF7Q1cTiGN5bFHjh+
	V3v8TXZpEio9+br1oWbRPka/MsMr3cG3Th8HuRy+7hFXd/1DBrKsuem/dci8QuEuvegyqi3TEfm
	EL8cpsNipia21xlmvFEnzsdG+0bGiLC7KkTj2RSgKzUyNcplMxk5MBNWhF0GQPYrFIVHPOBlzLY
	qloX6NruSgEuUIl4JW+HO+wvcc3ErEMuDmYC43V2bxHlH+SxETiw5gnFjQQn5NKG6RWoBCeT9OJ
	A8lfqYPPPm77szGk+d7wWqwgcnJYWnmND4yYQvsvPd8BjhPMfeS19Yh/+8pqNUHvl7iSkanNWn0
	Jk/61fLtsTMZjstPIlZ68oVU5l1wSfnozJIWT
X-Received: by 2002:a17:906:f597:b0:c31:c767:adfb with SMTP id
 a640c23a62f3a-c4678ffbd6amr238569466b.0.1792610001416; Wed, 21 Oct 2026
 12:13:21 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
From: Daniel Elliott <ssfdre38@gmail.com>
Date: Wed, 21 Oct 2026 12:13:10 -0700
X-Gm-Features: AclHuK9APs9B0rzbwh6CmWX8cg7Qmjjyk6qaLwf_TIZbyoHXFkA4R80CBYSH_tU
Message-ID: <CAJVF7aMHObs5zGmA0+7apmeRBYjirYwj5uJKqcRTX4areMggGA@mail.gmail.com>
Subject: [RFC PATCH 0/1] mm: Haven Memory Bus (HMB) zero-bio paging engine
 with Tier 2 z-Pack deduplication
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, willy@infradead.org, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, torvalds@linux-foundation.org
Content-Type: multipart/alternative; boundary="0000000000005af969065e5e8a6c"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5679714000D
X-Stat-Signature: mwt154bxdco1obikzaersmpiyejp9ik8
X-Rspam-User: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792610003-220520
X-HE-Meta: U2FsdGVkX1+fxIzd18MX2zsJZpInqfoo/6KrIv231gVeALl+DEQXAMSbZ4+EsUuHP5tynB+PHGkjTGmrGCiDCGPiX2vmt4pkL3V0o446UU8LrZ24s99kSUIuxUiiP/1o55F9paS1U6J19mSkUf7ENd+UR58yFfIPq2GbNtDEpbzPbDfgBuuPcJcZUjxZXM+IAGZkibejL9gLJypJ69Da/Fpo72cBh4zbXaxRM9OCJQyObqMHqPu/yJhOfHIZWWP8QA4vgH4Tq0nBJ2UNxpCzfVE7X3ksEroyF9xGX7DIGu0NmrJO/orZQwB/ob52FgKIXNXN5iBSWIiywj/hlMitgHht8EEPyPVBVE+yNfQejavQxOLSqIPotuCj2UVhnYn7AFYfR29ma3BxX3ecO8CwPoTc0DnGkMaMKidP8Kp5iBrJ/60Io+T3L9lmMzX9Sm4E1K0S1P6XGUMixT6kodWzmX7xsIU5/kAs0sHvLIBkg7pitNtDB6L1AEYpN0jiBed6PPrF8KIpX/l/letGrFDwYXYFqG/ugVIeky9wMYc0rXOaq31ZYt9t9J2IAB5otoJuIAwf/d7bYR7kWF3i3UV1GgNIofiPY6JUNtI2POseEl9NgP2aJmCPOUA9qUgfI5fbH5r589qFdOkWJDkZTuqRJxvHWftpKboy3Y+jy2grJ4wVHQ4qVjXCVhGBERtdSil0TQ71TJVyyo5Ul9Ntz+jWONczX6K88JSZx4Ioi15IN7ZZJgH3QGzpa6DU2OoZXGGxY1LFlhG5QZysx8j+M1QXuQFocUasV7n8bLKkPqjof/URsfEXox32G2VPagQR2+9aN/N4qpr9uWKiNsqOhKl4LDccAO2C8JLcuKil5NnhQoaRqVxRKUoXjKlh6mRxRG3DTmCd/FaNp0o1RjxtfVLXQPiDFRcYjvCztBMFmoiv6+wbSPWZtolgoIPNGBE+C86hHngrd8hvRyJl4sSX5gi
 uKYdNVH7
 FI9eSS0yQ6TqGjXIzmhVvIdxaPMyTXP0UMfGnyreeX0O6oIxz3kM2eAL8Z11i2nzvtAHGvebbVJqCpNTfVnlLfPvcdMHELmIXsFrF1JVtUg95fgCpoqEU3BmBWYSQurFGUmvwHEmBGI4/a3B3MmMjIV1MsZtVVt7DYFFYhEq3j+ilJqmbD8UTTi2eMysyUx0c4/0vsf809PkT6lI46bpec+dy7zQRedk9zkGb47YlF4Qzuh1l15nvsHQldtRRkcxDzMMkLTKo0Ed29ooHcp44jrU8+mVjj8xd6JB3ANJeKqfgtmYaiviYXuFfEKatzMf9fnDyj9wq+q4qnfGXg64dZBIbKXzoWSWX2Bq2TCzX4riiAQj2WkP4l839/miZ8XBmqXRU4CQThqbnLVjPe421cE7MoOCXAUlSr1t4DVSt7vM/nAWzt1S9+t/fkNlMyXYmTF5Df4BOAwv4sH7gtbMy/oigHrQsmD6H6N/CY4m41hiWGabtUtJzu+bAax/yipTxi7cNa7lyD0QyLA0xiRo+vKWFdjE3G75bs7nf9GiPXlRfnLpl+X+P6oYoDotvFJFL7y8kbihciPHeEBxco2V75ProHlvm9MHfmFiLPdjN26XQ8XQOB1cRu9kCVJUmQ/rR3d7kuDlDxiJJaZfP0h3UVZAeHXFZnfgBpuXTt1AGelasv2I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--0000000000005af969065e5e8a6c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Executive Summary
This RFC introduces the Haven Memory Bus (HMB) Spec 2.0 Native Paging
Engine directly into the Linux Virtual Memory Manager (mm/).

For over thirty years, general-purpose operating systems have assumed
secondary storage is an asynchronous block device. Even modern in-RAM
paging subsystems (e.g., zram, zswap) construct struct bio descriptors,
pass through blk-mq software request queues, and traverse I/O elevator
schedulers before reaching physical memory.

HMB eliminates this legacy abstraction. By intercepting folios directly in
mm/page_io.c (swap_writepage and swap_read_folio), HMB provides:

Zero-Bio / Zero-Queue Bypass: Folios are stored and retrieved using
lock-free
O
(
1
)
 arithmetic stride indexing directly over the CPU memory bus.
Tier 2 z-Pack Inline Deduplication:
Zero pages: 100% deduplication (stored in a single bitmask bit).
Uniform 64-bit quadword patterns: 99.8% deduplication (stored in 8 bytes).
Varied pages: Stored in high-speed slab pages without block serialization.
Sub-Microsecond #PF Resolution: Page faults resolve in
0.51
,
=CE=BC
s
, eliminating thread stalls in uninterruptible disk sleep (D state).
Bare-Metal Silicon Benchmarks
All benchmarks were conducted on a physical bare-metal bare-metal server
(Supermicro X11SSH-F, Intel Xeon E3-1270 v6 @ 3.80GHz, 32GB ECC DDR4, 2x
2TB HGST Ultrastar 7200 RPM SATA HDDs) running Linux 7.0.14-hmb.

1. Page Fault Resolution & Latency Under Memory Pressure
In a constrained cgroup v2 environment (MemoryMax=3D256M), a worker process
allocated 600 MB of dirty heap, forcing the kernel to evict ~350 MB of
anonymous memory. The process then immediately read back all memory to
trigger real kernel page-in (#PF):

Paging Mechanism Paging Latency (#PF) Memory Recovery Time Speedup Factor
Traditional Block Swap (7200 RPM HDD)
=E2=88=BC
10
,
000
,
=CE=BC
s
 (
10
 ms
) 258.0 seconds (4.3 min) Baseline (
1
=C3=97
)
Barrer HMB Native VMM Engine
0.51
,
=CE=BC
s
0.013 seconds (13 ms) 19,842x Recovery Speedup
Operations Handled: 91,799 pages evicted, 25,313 page faults recovered,
168,643 swap slots freed directly in mm/.
Block Layer Trace: Zero struct bio allocated; zero blk-mq submissions; zero
storage controller interrupts.
2. Real-World OS Workload: Core Systemd Phased Upgrade
Under memory-constrained multi-tasking, an un-phased upgrade of 13 core OS
packages (systemd 259.9, udev, libsystemd0, initramfs-tools, dbus) was
executed:

Metric Traditional Linux Storage Subsystem Barrer HMB Monolithic Kernel
Paging Throughput
=E2=88=BC
90
 MB/s
 (Rotational seek limit)
2
,
625.9
 MB/s
 (Memory bus rate)
SATA Controller Contention High (Swap and package writes fight) Zero (100%
bus for package I/O)
Thread Sleep State Heavy D state / I/O wait stalls 0% I/O Wait (Pure active
CPU execution)
Network Socket Buffers Prone to TCP window throttling Zero packet drops /
No buffer starvation
Systemd Re-exec High latency during --deserialize Instantaneous (PID 1
preserved)
Architectural Implementation
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
Key Files Modified
include/linux/hmb_pagefile.h: Interface declarations and zero-overhead
inline stubs when CONFIG_HMB_PAGEFILE=3Dn.
mm/hmb_pagefile.c: Core arithmetic stride plane, atomic bitmasks, Tier 2
z-Pack deduplication engine, and /proc/hmb_pagefile diagnostic telemetry.
mm/page_io.c:
swap_writepage(): Direct fast-path hook to hmb_pagefile_store(folio).
swap_read_folio(): Direct fast-path hook to hmb_pagefile_load(folio).
mm/swapfile.c:
swap_free_cluster(): Lock-free slot reclamation via hmb_pagefile_free().
mm/Kconfig & mm/Makefile: Integrated build configuration
(CONFIG_HMB_PAGEFILE).
Code Quality & Standards
scripts/checkpatch.pl Compliance: Verified on Linux 7.0 source tree: total:
0 errors, 1 warnings, 484 lines checked (1 warning is informational prompt
for MAINTAINERS file addition).
Coding Style: Linux kernel standard tabs, 80-column wrapped commit
messages, SPDX GPL-2.0 identifiers.
Lock-Free Atomic Primitives: Standard Linux set_bit, clear_bit, and
atomic64 operations.
Public Repository & Reproduction
The complete driver, in-tree kernel patches, and bare-metal benchmark test
scripts are available under the GPL-2.0 license:

Repository: https://github.com/barrersoftware/hmb
Patch Artifact: kernel/in_tree_patch/hmb_in_tree_linux_7.0.patch
We welcome feedback, suggestions for integration into mainline mm/, and
discussions regarding Android Common Kernel (ACK) backports.

Respectfully submitted,
Daniel Elliott
Barrer Software Organization
ssfdre38@gmail.com

--0000000000005af969065e5e8a6c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+RXhlY3V0aXZlIFN1bW1hcnk8YnI+VGhpcyBSRkMgaW50cm9kdWNlcyB0
aGUgSGF2ZW4gTWVtb3J5IEJ1cyAoSE1CKSBTcGVjIDIuMCBOYXRpdmUgUGFnaW5nIEVuZ2luZSBk
aXJlY3RseSBpbnRvIHRoZSBMaW51eCBWaXJ0dWFsIE1lbW9yeSBNYW5hZ2VyIChtbS8pLjxicj48
YnI+Rm9yIG92ZXIgdGhpcnR5IHllYXJzLCBnZW5lcmFsLXB1cnBvc2Ugb3BlcmF0aW5nIHN5c3Rl
bXMgaGF2ZSBhc3N1bWVkIHNlY29uZGFyeSBzdG9yYWdlIGlzIGFuIGFzeW5jaHJvbm91cyBibG9j
ayBkZXZpY2UuIEV2ZW4gbW9kZXJuIGluLVJBTSBwYWdpbmcgc3Vic3lzdGVtcyAoZS5nLiwgenJh
bSwgenN3YXApIGNvbnN0cnVjdCBzdHJ1Y3QgYmlvIGRlc2NyaXB0b3JzLCBwYXNzIHRocm91Z2gg
YmxrLW1xIHNvZnR3YXJlIHJlcXVlc3QgcXVldWVzLCBhbmQgdHJhdmVyc2UgSS9PIGVsZXZhdG9y
IHNjaGVkdWxlcnMgYmVmb3JlIHJlYWNoaW5nIHBoeXNpY2FsIG1lbW9yeS48YnI+PGJyPkhNQiBl
bGltaW5hdGVzIHRoaXMgbGVnYWN5IGFic3RyYWN0aW9uLiBCeSBpbnRlcmNlcHRpbmcgZm9saW9z
IGRpcmVjdGx5IGluIG1tL3BhZ2VfaW8uYyAoc3dhcF93cml0ZXBhZ2UgYW5kIHN3YXBfcmVhZF9m
b2xpbyksIEhNQiBwcm92aWRlczo8YnI+PGJyPlplcm8tQmlvIC8gWmVyby1RdWV1ZSBCeXBhc3M6
IEZvbGlvcyBhcmUgc3RvcmVkIGFuZCByZXRyaWV2ZWQgdXNpbmcgbG9jay1mcmVlIDxicj5PPGJy
Pig8YnI+MTxicj4pPGJyPsKgYXJpdGhtZXRpYyBzdHJpZGUgaW5kZXhpbmcgZGlyZWN0bHkgb3Zl
ciB0aGUgQ1BVIG1lbW9yeSBidXMuPGJyPlRpZXIgMiB6LVBhY2sgSW5saW5lIERlZHVwbGljYXRp
b246PGJyPlplcm8gcGFnZXM6IDEwMCUgZGVkdXBsaWNhdGlvbiAoc3RvcmVkIGluIGEgc2luZ2xl
IGJpdG1hc2sgYml0KS48YnI+VW5pZm9ybSA2NC1iaXQgcXVhZHdvcmQgcGF0dGVybnM6IDk5Ljgl
IGRlZHVwbGljYXRpb24gKHN0b3JlZCBpbiA4IGJ5dGVzKS48YnI+VmFyaWVkIHBhZ2VzOiBTdG9y
ZWQgaW4gaGlnaC1zcGVlZCBzbGFiIHBhZ2VzIHdpdGhvdXQgYmxvY2sgc2VyaWFsaXphdGlvbi48
YnI+U3ViLU1pY3Jvc2Vjb25kICNQRiBSZXNvbHV0aW9uOiBQYWdlIGZhdWx0cyByZXNvbHZlIGlu
IDxicj4wLjUxPGJyPiw8YnI+zrw8YnI+czxicj4sIGVsaW1pbmF0aW5nIHRocmVhZCBzdGFsbHMg
aW4gdW5pbnRlcnJ1cHRpYmxlIGRpc2sgc2xlZXAgKEQgc3RhdGUpLjxicj5CYXJlLU1ldGFsIFNp
bGljb24gQmVuY2htYXJrczxicj5BbGwgYmVuY2htYXJrcyB3ZXJlIGNvbmR1Y3RlZCBvbiBhIHBo
eXNpY2FsIGJhcmUtbWV0YWwgYmFyZS1tZXRhbCBzZXJ2ZXIgKFN1cGVybWljcm8gWDExU1NILUYs
IEludGVsIFhlb24gRTMtMTI3MCB2NiBAIDMuODBHSHosIDMyR0IgRUNDIEREUjQsIDJ4IDJUQiBI
R1NUIFVsdHJhc3RhciA3MjAwIFJQTSBTQVRBIEhERHMpIHJ1bm5pbmcgTGludXggNy4wLjE0LWht
Yi48YnI+PGJyPjEuIFBhZ2UgRmF1bHQgUmVzb2x1dGlvbiAmYW1wOyBMYXRlbmN5IFVuZGVyIE1l
bW9yeSBQcmVzc3VyZTxicj5JbiBhIGNvbnN0cmFpbmVkIGNncm91cCB2MiBlbnZpcm9ubWVudCAo
TWVtb3J5TWF4PTI1Nk0pLCBhIHdvcmtlciBwcm9jZXNzIGFsbG9jYXRlZCA2MDAgTUIgb2YgZGly
dHkgaGVhcCwgZm9yY2luZyB0aGUga2VybmVsIHRvIGV2aWN0IH4zNTAgTUIgb2YgYW5vbnltb3Vz
IG1lbW9yeS4gVGhlIHByb2Nlc3MgdGhlbiBpbW1lZGlhdGVseSByZWFkIGJhY2sgYWxsIG1lbW9y
eSB0byB0cmlnZ2VyIHJlYWwga2VybmVsIHBhZ2UtaW4gKCNQRik6PGJyPjxicj5QYWdpbmcgTWVj
aGFuaXNtCVBhZ2luZyBMYXRlbmN5ICgjUEYpCU1lbW9yeSBSZWNvdmVyeSBUaW1lCVNwZWVkdXAg
RmFjdG9yPGJyPlRyYWRpdGlvbmFsIEJsb2NrIFN3YXAgKDcyMDAgUlBNIEhERCkJPGJyPuKIvDxi
cj4xMDxicj4sPGJyPjAwMDxicj4sPGJyPs68PGJyPnM8YnI+wqAoPGJyPjEwPGJyPsKgbXM8YnI+
KQkyNTguMCBzZWNvbmRzICg0LjMgbWluKQlCYXNlbGluZSAoPGJyPjE8YnI+w5c8YnI+KTxicj5C
YXJyZXIgSE1CIE5hdGl2ZSBWTU0gRW5naW5lCTxicj4wLjUxPGJyPiw8YnI+zrw8YnI+czxicj4w
LjAxMyBzZWNvbmRzICgxMyBtcykJMTksODQyeCBSZWNvdmVyeSBTcGVlZHVwPGJyPk9wZXJhdGlv
bnMgSGFuZGxlZDogOTEsNzk5IHBhZ2VzIGV2aWN0ZWQsIDI1LDMxMyBwYWdlIGZhdWx0cyByZWNv
dmVyZWQsIDE2OCw2NDMgc3dhcCBzbG90cyBmcmVlZCBkaXJlY3RseSBpbiBtbS8uPGJyPkJsb2Nr
IExheWVyIFRyYWNlOiBaZXJvIHN0cnVjdCBiaW8gYWxsb2NhdGVkOyB6ZXJvIGJsay1tcSBzdWJt
aXNzaW9uczsgemVybyBzdG9yYWdlIGNvbnRyb2xsZXIgaW50ZXJydXB0cy48YnI+Mi4gUmVhbC1X
b3JsZCBPUyBXb3JrbG9hZDogQ29yZSBTeXN0ZW1kIFBoYXNlZCBVcGdyYWRlPGJyPlVuZGVyIG1l
bW9yeS1jb25zdHJhaW5lZCBtdWx0aS10YXNraW5nLCBhbiB1bi1waGFzZWQgdXBncmFkZSBvZiAx
MyBjb3JlIE9TIHBhY2thZ2VzIChzeXN0ZW1kIDI1OS45LCB1ZGV2LCBsaWJzeXN0ZW1kMCwgaW5p
dHJhbWZzLXRvb2xzLCBkYnVzKSB3YXMgZXhlY3V0ZWQ6PGJyPjxicj5NZXRyaWMJVHJhZGl0aW9u
YWwgTGludXggU3RvcmFnZSBTdWJzeXN0ZW0JQmFycmVyIEhNQiBNb25vbGl0aGljIEtlcm5lbDxi
cj5QYWdpbmcgVGhyb3VnaHB1dAk8YnI+4oi8PGJyPjkwPGJyPsKgTUIvczxicj7CoChSb3RhdGlv
bmFsIHNlZWsgbGltaXQpCTxicj4yPGJyPiw8YnI+NjI1Ljk8YnI+wqBNQi9zPGJyPsKgKE1lbW9y
eSBidXMgcmF0ZSk8YnI+U0FUQSBDb250cm9sbGVyIENvbnRlbnRpb24JSGlnaCAoU3dhcCBhbmQg
cGFja2FnZSB3cml0ZXMgZmlnaHQpCVplcm8gKDEwMCUgYnVzIGZvciBwYWNrYWdlIEkvTyk8YnI+
VGhyZWFkIFNsZWVwIFN0YXRlCUhlYXZ5IEQgc3RhdGUgLyBJL08gd2FpdCBzdGFsbHMJMCUgSS9P
IFdhaXQgKFB1cmUgYWN0aXZlIENQVSBleGVjdXRpb24pPGJyPk5ldHdvcmsgU29ja2V0IEJ1ZmZl
cnMJUHJvbmUgdG8gVENQIHdpbmRvdyB0aHJvdHRsaW5nCVplcm8gcGFja2V0IGRyb3BzIC8gTm8g
YnVmZmVyIHN0YXJ2YXRpb248YnI+U3lzdGVtZCBSZS1leGVjCUhpZ2ggbGF0ZW5jeSBkdXJpbmcg
LS1kZXNlcmlhbGl6ZQlJbnN0YW50YW5lb3VzIChQSUQgMSBwcmVzZXJ2ZWQpPGJyPkFyY2hpdGVj
dHVyYWwgSW1wbGVtZW50YXRpb248YnI+wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqDi
lIzilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilIDilIDilIDilJA8YnI+wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqDilIIgwqAgwqAgwqAgwqAgwqBMaW51eCBVc2VybGFuZCAvIEFwcGxpY2F0aW9ucyDC
oCDCoCDCoCDilII8YnI+wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqDilJTilIDilIDi
lIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilKzilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilJg8YnI+wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg4pSCIFBhZ2UgRmF1bHQgLyBFdmljdGlv
bjxicj7CoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDilrw8YnI+wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqDilIzi
lIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilIDilIDilJA8YnI+wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqDilIIgwqAgwqAgwqAgTGludXggVmlydHVhbCBNZW1vcnkgTWFuYWdlciAobW0vKSDCoCDC
oCDilII8YnI+wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqDilIIgwqAgwqAgwqAgwqAg
wqAgc3dhcF93cml0ZXBhZ2UgLyBzd2FwX3JlYWQgwqAgwqAgwqAgwqAg4pSCPGJyPsKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg4pSU4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSs4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSYPGJy
PsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIOKUgjxicj7CoCDCoCDCoCDCoCDCoCDCoCDCoCDilIzilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilLTilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilJA8YnI+wqAg
wqAgwqAgwqAgwqAgwqAgwqAg4pSCIFtCQVJSRVIgSE1CIEhPT0tdIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIOKUgjxicj7CoCDCoCDC
oCDCoCDCoCDCoCDCoCDilIIgRG9lcyBITUIgY2xhaW0gdGhpcyBzbG90PyDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDilII8YnI+wqAgwqAgwqAgwqAgwqAg
wqAgwqAg4pa8IFlFUyDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDilrwgTk8gKEZhbGxiYWNrKTxi
cj7ilIzilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilJAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg4pSM4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSQPGJyPuKUgiDCoCBIYXZlbiBNZW1vcnkgQnVzIChTcGVjIDIuMCkg
wqAg4pSCIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIOKUgiBUcmFkaXRpb25hbCBC
bG9jayBTdWJzeXN0ZW0gwqAgwqAg4pSCPGJyPuKUgiDCoC0gTygxKSBEaXJlY3QgQXJpdGhtZXRp
YyBTdHJpZGXilIIgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg4pSCIMKgLSBzdHJ1
Y3QgYmlvIGFsbG9jYXRpb24gwqAgwqAgwqAgwqDilII8YnI+4pSCIMKgLSBUaWVyIDIgei1QYWNr
IERlZHVwbGljYXRpb24gwqDilIIgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg4pSC
IMKgLSBibGstbXEgcmVxdWVzdCBxdWV1ZWluZyDCoCDCoCDCoOKUgjxicj7ilIIgwqAtIFplcm8g
RWxldmF0b3IgLyBaZXJvIFF1ZXVlIMKgIOKUgiDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDilIIgwqAtIEVsZXZhdG9yIHNjaGVkdWxlciBvdmVyaGVhZCDCoOKUgjxicj7ilIIgwqAt
IFN1Yi1taWNyb3NlY29uZCByZXR1cm4gwqAgwqAgwqAg4pSCIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIOKUgiDCoC0gTWVjaGFuaWNhbCAvIE5WTWUgSS9PIGRlbGF5IMKg4pSCPGJy
PuKUlOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUmCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDilJTilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilJg8YnI+wqAgwqAgwqAgwqAgwqBMYXRlbmN5OiB+MC41MSDCtXMgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
TGF0ZW5jeTogMTAgbXMgLSA0LjMgbWluPGJyPktleSBGaWxlcyBNb2RpZmllZDxicj5pbmNsdWRl
L2xpbnV4L2htYl9wYWdlZmlsZS5oOiBJbnRlcmZhY2UgZGVjbGFyYXRpb25zIGFuZCB6ZXJvLW92
ZXJoZWFkIGlubGluZSBzdHVicyB3aGVuIENPTkZJR19ITUJfUEFHRUZJTEU9bi48YnI+bW0vaG1i
X3BhZ2VmaWxlLmM6IENvcmUgYXJpdGhtZXRpYyBzdHJpZGUgcGxhbmUsIGF0b21pYyBiaXRtYXNr
cywgVGllciAyIHotUGFjayBkZWR1cGxpY2F0aW9uIGVuZ2luZSwgYW5kIC9wcm9jL2htYl9wYWdl
ZmlsZSBkaWFnbm9zdGljIHRlbGVtZXRyeS48YnI+bW0vcGFnZV9pby5jOjxicj5zd2FwX3dyaXRl
cGFnZSgpOiBEaXJlY3QgZmFzdC1wYXRoIGhvb2sgdG8gaG1iX3BhZ2VmaWxlX3N0b3JlKGZvbGlv
KS48YnI+c3dhcF9yZWFkX2ZvbGlvKCk6IERpcmVjdCBmYXN0LXBhdGggaG9vayB0byBobWJfcGFn
ZWZpbGVfbG9hZChmb2xpbykuPGJyPm1tL3N3YXBmaWxlLmM6PGJyPnN3YXBfZnJlZV9jbHVzdGVy
KCk6IExvY2stZnJlZSBzbG90IHJlY2xhbWF0aW9uIHZpYSBobWJfcGFnZWZpbGVfZnJlZSgpLjxi
cj5tbS9LY29uZmlnICZhbXA7IG1tL01ha2VmaWxlOiBJbnRlZ3JhdGVkIGJ1aWxkIGNvbmZpZ3Vy
YXRpb24gKENPTkZJR19ITUJfUEFHRUZJTEUpLjxicj5Db2RlIFF1YWxpdHkgJmFtcDsgU3RhbmRh
cmRzPGJyPnNjcmlwdHMvPGEgaHJlZj0iaHR0cDovL2NoZWNrcGF0Y2gucGwiPmNoZWNrcGF0Y2gu
cGw8L2E+IENvbXBsaWFuY2U6IFZlcmlmaWVkIG9uIExpbnV4IDcuMCBzb3VyY2UgdHJlZTogdG90
YWw6IDAgZXJyb3JzLCAxIHdhcm5pbmdzLCA0ODQgbGluZXMgY2hlY2tlZCAoMSB3YXJuaW5nIGlz
IGluZm9ybWF0aW9uYWwgcHJvbXB0IGZvciBNQUlOVEFJTkVSUyBmaWxlIGFkZGl0aW9uKS48YnI+
Q29kaW5nIFN0eWxlOiBMaW51eCBrZXJuZWwgc3RhbmRhcmQgdGFicywgODAtY29sdW1uIHdyYXBw
ZWQgY29tbWl0IG1lc3NhZ2VzLCBTUERYIEdQTC0yLjAgaWRlbnRpZmllcnMuPGJyPkxvY2stRnJl
ZSBBdG9taWMgUHJpbWl0aXZlczogU3RhbmRhcmQgTGludXggc2V0X2JpdCwgY2xlYXJfYml0LCBh
bmQgYXRvbWljNjQgb3BlcmF0aW9ucy48YnI+UHVibGljIFJlcG9zaXRvcnkgJmFtcDsgUmVwcm9k
dWN0aW9uPGJyPlRoZSBjb21wbGV0ZSBkcml2ZXIsIGluLXRyZWUga2VybmVsIHBhdGNoZXMsIGFu
ZCBiYXJlLW1ldGFsIGJlbmNobWFyayB0ZXN0IHNjcmlwdHMgYXJlIGF2YWlsYWJsZSB1bmRlciB0
aGUgR1BMLTIuMCBsaWNlbnNlOjxicj48YnI+UmVwb3NpdG9yeTogPGEgaHJlZj0iaHR0cHM6Ly9n
aXRodWIuY29tL2JhcnJlcnNvZnR3YXJlL2htYiI+aHR0cHM6Ly9naXRodWIuY29tL2JhcnJlcnNv
ZnR3YXJlL2htYjwvYT48YnI+UGF0Y2ggQXJ0aWZhY3Q6IGtlcm5lbC9pbl90cmVlX3BhdGNoL2ht
Yl9pbl90cmVlX2xpbnV4XzcuMC5wYXRjaDxicj5XZSB3ZWxjb21lIGZlZWRiYWNrLCBzdWdnZXN0
aW9ucyBmb3IgaW50ZWdyYXRpb24gaW50byBtYWlubGluZSBtbS8sIGFuZCBkaXNjdXNzaW9ucyBy
ZWdhcmRpbmcgQW5kcm9pZCBDb21tb24gS2VybmVsIChBQ0spIGJhY2twb3J0cy48YnI+PGJyPlJl
c3BlY3RmdWxseSBzdWJtaXR0ZWQsPGJyPkRhbmllbCBFbGxpb3R0PGJyPkJhcnJlciBTb2Z0d2Fy
ZSBPcmdhbml6YXRpb248YnI+PGEgaHJlZj0ibWFpbHRvOnNzZmRyZTM4QGdtYWlsLmNvbSI+c3Nm
ZHJlMzhAZ21haWwuY29tPC9hPjwvZGl2Pg0K
--0000000000005af969065e5e8a6c--

