Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 972ACCA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 16:16:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 402046B0098; Fri,  2 Oct 2026 12:16:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B21A6B0099; Fri,  2 Oct 2026 12:16:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A1BB6B009B; Fri,  2 Oct 2026 12:16:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D12A56B0098
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 12:16:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 38062407C6
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 16:16:29 +0000 (UTC)
X-FDA: 85278188898.29.7F6882B
Received: from mail-ed2-f32.google.com (mail-ed2-f32.google.com [74.125.228.96])
	by imf04.hostedemail.com (Postfix) with ESMTP id 645554000D
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 16:16:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=epyd6Tid;
	spf=pass (imf04.hostedemail.com: domain of antosha20xx@gmail.com designates 74.125.228.96 as permitted sender) smtp.mailfrom=antosha20xx@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790957787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=81SrQlvrYJ/nq4GpaZugKxmAIhcZ8Lzg+zQauV1EEn0=;
	b=TaITLjRUrZJFAlJbJpL64FK8krvZow58I98ccouYTWeXdFtBN+qG1IHYB2PIvMbRcDBZVV
	jcK8HH62Hs20zQb5mu+Q41ZiLzp8Io3Tk/bAmYWN5lPL3YG9jiYECFxW9DOEUDi1215L7H
	D+LAMd+X+fmlmvtkPFJIAR2MQqryjfs=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790957787;
	b=YhWXRiKrDp/n0VFKfjYREw60zY3RljsLHQZVhe4BH+7Ssi2P/qVzPaYFJgzZQsff/Po5/5
	mYcNndCaj57B028SzB9b9ec8ZrxCwtbvUefFu6z+u5Vk7F+G9FcfDLF/P8SS/Ml7p7V4WG
	8ov0O5AHvCLgA7nDMztJm0j4o+NDe9c=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=epyd6Tid;
	spf=pass (imf04.hostedemail.com: domain of antosha20xx@gmail.com designates 74.125.228.96 as permitted sender) smtp.mailfrom=antosha20xx@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed2-f32.google.com with SMTP id 4fb4d7f45d1cf-6acb6b726b5so134257a12.0
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 09:16:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790957786; cv=none;
        d=google.com; s=arc-20260327;
        b=Y7Wo9/JhrxTMxJ+spRO2rJHPw5iRJ5G5+uF0fbXLQoG3PtrxwgCQ6+RSBmkDTsG8J/
         nZNYOig8M6jDnYyEjtZ4Ya9C9bEmRIYpxK8d+gp6P2gM75+0AWbtMEf7u3muyAu3DSra
         cYbWElH4FWjWMi5AaNwia7kIK1fTgtMDa44xjMjagdaHZrjgbalq+od3YlAMTXt/Xvcr
         xiQicBuElmmJpaAh1qov473IhhAnohSQhhG9tvEtixuAFXHcehITY1re6ogKO+3EplJr
         QzWCXns+Q87p0RB0e9ARa0nj/b/wiLxoA5zVHGae/bUag+8RtHAUuAI6IZqwNBdWBW6f
         fbAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=81SrQlvrYJ/nq4GpaZugKxmAIhcZ8Lzg+zQauV1EEn0=;
        fh=xhYuKmvLsTYbxIq7wsg/RYlM55oeoIaGFG3gPjSearQ=;
        b=gLR20YYpyKawNrJ71TGgsqH47rSxgDnxh34dYOvWhqeMOfFkrmSDhmiMz1w6QMmzh3
         rtI5yytvDluyv5NqgIbxEhvYiurlcVjnogaoyHCcZVrPpANPc3ye4TWdA/WShqm2epA6
         upPZ4c8YgL8DTkkV/fm2/mC98jfrKg8Sp0w5MMVhF2KfBOuK7xhZ0waitQXg7SuGc+rv
         yzPorHi9hHTu8WDpESA5na8Wtzvrp9ETh/Mc7mRz4ZRLSPf+cUkoVWdSVhrQZmmLGIoo
         8zZbOS0imEvK4SW5baWJaBJthOcPEqvGCKtbhz8/30lqBqdKZYLusLc2pvecy17Z5IWZ
         dytw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790957786; x=1791562586; darn=kvack.org;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=81SrQlvrYJ/nq4GpaZugKxmAIhcZ8Lzg+zQauV1EEn0=;
        b=epyd6TiduMvqmRwA0nRRE3ltxfMBOnCE9FHobzljwlBzoMgUwvPeeuMB2c1OvtC+LN
         JgJH7DSaifi8E514wmgoaALn+R53eaItMwhsbzKqazFVkzz1cgBHP7vM43c/8EIEw+Sj
         w0fCp+SPsl0e6U3afyBjzi96UlCMaM1Ka/sIE11ww0wCUbLEnUIoJveAhRE+pAgBk5t5
         JeLevyCCTkmdTqUaERIjLKw3sHV4VjmmqOmUKZVl+pzuP9eEnywyoyiGR5XGDyXC3w+y
         H8SqUqvO7KeDKKhv1zzOTME3YrBUruppprn7nXWxcMODv7rVyLJQJJ4+lXtxK1iNqIlG
         1Mrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790957786; x=1791562586;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=81SrQlvrYJ/nq4GpaZugKxmAIhcZ8Lzg+zQauV1EEn0=;
        b=OECDS+7uZ/fmOXu4ak4LOG13nNTHI8iSYtG8dDD4EBpwuWRIx1w9BFrhytoJbzml95
         LJvFQ0usuF9qkQfzWFQSKejX5ASEqdj+ny1wXQxJlVoZZpv8KA7odn1uEQ/Kt+tFd9xS
         xITOhcNW4cVEQk2l6bzqcJ3+j6/jdxM3oo3sh9S+N4Qn1vKB0QpX5Dz98qhHUv2dLmCY
         BeU2O+Qa70q0PzZxaGAKmFDiC2iSKdg2E0rQ+EMzgfx53jc2X8pflBA0yt4SMyz+iHSa
         EiHu4XuyVpy9tuTKCQPCqJJewZI067PQ40niaR1mQ2+/S7wVnKgU0OASQU2+3jzP+SLl
         45Tg==
X-Gm-Message-State: AFq9FYIbFMWejDPd5fs9ZtdV3OR0ROzDVPQ5yMZqtOhQgelQzXPiLbSC
	Xg/+7nWc9IvqfCBDtoL1xczuqLZ/fyaVtIrfAHuHU+9XSuHMvmBG5J4THX3lou5xOg1j6xOzJc5
	7DCF6nKA+AoLHGpLwnxSPPLEhsTapf7sEHc0U
X-Gm-Gg: AYBFou0pzghA3cpQK8GtkmXmnxfSHeEYxFuy2gik/wZrsFTYHjdsr1CnCTOoFz8Mnwt
	WpwV7sqb1jfqAc8mwCxknIIXLihw68v0OkXiUl7DpkXYaGRKb6DZMuhnpPuXR+vUem5ZvCbR4R5
	bejnylGRbpxkz6NZte/gL77ezNKtReZzTpckJi/DIUVSz9LKoMQ9eDxTBZrl95YbnesR2Md4kR4
	v22cnp4BVBuPh+Qk1rOCwioI1XD7PIdXmVZsYmk1y6epqtp9fQKn/NBPVDn+hH54CDsDRPzkTHK
	zDXtvA8GJevEiYY1ro0FsylqcZQqwcXs3ek3cNe4jxegxZDY458ogGrY
X-Received: by 2002:a05:6402:4606:b0:6ac:b85d:10f1 with SMTP id
 4fb4d7f45d1cf-6af9e2ea589mr2038154a12.11.1790957784516; Fri, 02 Oct 2026
 09:16:24 -0700 (PDT)
MIME-Version: 1.0
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Fri, 2 Oct 2026 19:16:12 +0300
X-Gm-Features: AclHuK9ozIpKtifV_S9EpGNgj5f1FCCQ1rOkjiABvT5mW0EzReq-wWA8PmAityo
Message-ID: <CAAiJnjqz+OB+PmUQBENS8ThnWHSAFK=p3EA7KPsy5UeabQCn-A@mail.gmail.com>
Subject: Poor memory bandwidth performance between NUMA nodes
To: linux-mm@kvack.org, linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 645554000D
X-Stat-Signature: 6boenwpw4zyoxtsc7ze9jemqomduun7a
X-HE-Tag: 1790957787-515012
X-HE-Meta: U2FsdGVkX1+6aWW7nHkVVwhYu7MJ3C7uJIfy+gBK3jK+PY9msIbatcOMQ8VXnH42AKQ/hG2osd+rrQySnANjdHiCK3wOWgybf1wA3RPZYDlqgcuA4tPMx2+dbxSJjqg9mWsbY4yJ+UYh4NyrDcrUVgBVkZoFDZX98nQi2NrKsw8xl0pHlruenvQLijC9TSajvFOqtPt148NNIyn0damev33DWkLRMeaGaELyovxyj/Coe9OtfcOute3+y7vJIwH/sTlAK//3KxrFKlgf+xxY3Otu98JqpoVixCuN8eCuoT5Iw0k1o5GG8RgzviWNodokTO4R/nK3xIO7V9kl8Jy4KrdnamKd0e8A7jrBpAE3PBSixu8thArR3LKhVHxMgUMGxYTi99V39ZNj6fD9dhZUBHipmfcjAAigP2IrX3QqHkHe7OKLBOkRDnxLhBm5PLvnAxnhByFFv5wPGEmnrU9lSqZ1FFNSbSF1TMiPKtcyx2E1yWsZ/wW+i32PXHal3fmoGmObiBkDk0G8+pcXFU2nKYySHIJbB/L8KPDVSEPnmg8rj6i3dRD7jFnou8tbAi87tpftzTavUZVhIyO+OIXd0xBvfCl7wsL+0KzCx7fkTjrLFAlev7R0LsLu7BLcqALjf9nv0KdvC235XNa94fKe7rmDKEhQV+yygX5Us9MidCWayzjdWM/XL0XaDAmIVw8tyUu2HAZQxLtX71zziMkcBwt3YiwHtaS+4jhUv/sWIPMCqyh11VXX8LOlPnkLjE/u4LYIW3F0eSMm1xKjDXboeD3j0qoKKwkAs2kZfB9wk+/rvUwwWsvAtHutoKGalmD76hZCKxjeEfzhTUoyfcOVrFMr/gY4JSkAkWNgeo957PQmVwWw2jK9aIYjSehncWLzlJDjWvjs8vMUotcIJdhoei8/+ugzdR5mZiKbJMFpydeIh8UrDh9ZqSYOu2/eC1RUoZX2CWjHjTXxHErMTs7
 O5IFxplx
 Zr6B4klxnd+wQB7GNhLwCTIWzZ27GSRDSo//YglGkTcG08OprXnAh5/WXTqFmjnCiJ0qWE3TsFiLAckqs9Ul2eILpLZeR6zc1Cn74bComQo0hPRg/Tk+akiwtw+JNjqiYkTql+lGtMS2pDbW8Z21h5r1cFZ36sWSn/xDX2r7EVT7H29TyqkBWEroJaHazII89g4Val2Y8g6CxmyIzw7BOZ+tHCQTSoKmzvddCD8QODx3D4gMrOvpSGw/HeAooYtoDdxjUlqzs4ccpNl0AxRpKai2mvl+QgKmrwVRnJLstUy8WwV42rUXhyYV4oiL+rgmpvy2WKARN4eKc2+VPMG4Ge2VwDMoRHZn9vlhlzVvmkTrdvqtDCBVVA5tr1R2hMx4sL9W5QVmkO/a3O34=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello

There is Fedora Server 44 (up to date) on HPE DL380g10 socket server
with Optane PMEM DIMMs configured as system RAM for simulating CXL
type3 memory expanders,

[root@localhost anton]# numactl -H
available: 4 nodes (0-3)
node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21
22 23 24 25 26 27
node 0 size: 386590 MB
node 0 free: 337352 MB
node 1 cpus: 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46
47 48 49 50 51 52 53 54 55
node 1 size: 387055 MB
node 1 free: 338582 MB
node 2 cpus:
node 2 size: 3033088 MB
node 2 free: 3033088 MB
node 3 cpus:
node 3 size: 3033088 MB
node 3 free: 3033088 MB
node distances:
node     0    1    2    3
   0:   10   20   25   35
   1:   20   10   35   25
   2:   25   35   10   20
   3:   35   25   20   10
[root@localhost anton]#
[root@localhost anton]# ./Linux/mlc
Intel(R) Memory Latency Checker - v3.13
Measuring idle latencies for sequential access (in ns)...
                Numa node
Numa node            0       1       2       3
       0          82.2   147.0   173.8   237.7
       1         146.7    82.8   238.6   172.2

When I allocate memory in NUMA node 0, for example by using Valkey and
then migrate memory pages from NUMA node 0 -> 2 by using DAMON/DAMOS
Memory Tiering or even simple migratepages command, I see migration
bandwidth 1.4 GB/s.

Could you please help me analyze and improve this bandwidth
performance ?  It may also be useful with the coming CXL (type3
devices) era.

As I mentioned there is no performance difference between DAMON/DAMOS
Memory Tiering or migratepages command (in both cases ~1.4 GB/s), so
below profiling with migratepages command,

top - 12:43:59 up 13 min,  2 users,  load average: 0.65, 0.88, 0.76
Tasks: 757 total, 2 running, 755 sleep, 0 d-sleep, 0 stopped, 0 zombie
%Cpu(s):  0.0 us,  1.8 sy,  0.0 ni, 98.2 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
MiB Mem : 6839822.+total, 6438483.+free, 416313.2 used,    669.8 buff/cache
MiB Swap:   8192.0 total,   8192.0 free,      0.0 used. 6423508.+avail Mem

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMM=
AND
   2935 root      20   0    2644   1764   1644 R  99.7   0.0   0:42.19
migratepages
   2941 root      20   0   10884   6192   3916 R   0.7   0.0   0:00.04 top
   1238 systemd+  20   0   15860   6996   5952 S   0.3   0.0   0:00.37
systemd-oomd
   1928 root      20   0  666268  24448  23440 S   0.3   0.0   0:00.34 rsys=
logd
      1 root      20   0   25840  15532  10492 S   0.0   0.0   0:02.15 syst=
emd
      2 root      20   0       0      0      0 S   0.0   0.0   0:00.02 kthr=
eadd
      3 root      20   0       0      0      0 S   0.0   0.0   0:00.00
pool_workqueue_release
      4 root       0 -20       0      0      0 I   0.0   0.0   0:00.00
kworker/R-rcu_gp


|---------------------------------------||---------------------------------=
------|
|--            System DRAM Read Throughput(MB/s):        759.41
        --|
|--           System DRAM Write Throughput(MB/s):        751.36
        --|
|--             System PMM Read Throughput(MB/s):        701.24
        --|
|--            System PMM Write Throughput(MB/s):       1402.15
        --|
|--                 System Read Throughput(MB/s):       1460.65
        --|
|--                System Write Throughput(MB/s):       2153.50
        --|
|--               System Memory Throughput(MB/s):       3614.15
        --|
|---------------------------------------||---------------------------------=
------|


Samples: 92K of event 'cpu/cycles/P', 4000 Hz, Event count (approx.):
48280162400 lost: 0/0 drop:
Overhead  Shared Object                      Symbol
  49.82%  [kernel]                           [k] migrate_folio_unmap
  16.52%  [kernel]                           [k] clear_highpages_kasan_tagg=
ed
  13.56%  [kernel]                           [k] copy_mc_fragile
   1.80%  [kernel]                           [k] smp_call_function_many_con=
d
   1.06%  [kernel]                           [k] page_vma_mapped_walk
   0.95%  [kernel]                           [k] try_to_migrate_one
   0.94%  [kernel]                           [k] folio_migrate_flags
   0.71%  [kernel]                           [k] rmqueue_bulk
   0.61%  [kernel]                           [k] remove_migration_pte
   0.54%  [kernel]                           [k] __free_one_page
   0.50%  [kernel]                           [k] migrate_folio_move
   0.48%  [kernel]                           [k] folio_batch_move_lru
   0.47%  [kernel]                           [k]
__list_del_entry_valid_or_report


Samples: 37K of event 'cpu/cycles/P', 4000 Hz, Event count (approx.):
33608407521
migrate_folio_unmap  /proc/kcore [Percent: local period]
Percent =E2=94=82       movq   %r13,0x20(%rsp)
   0.02 =E2=94=82       movq   %rdx,%r13
        =E2=94=82       movq   %r14,0x28(%rsp)
        =E2=94=82       movl   %r9d,%r14d
        =E2=94=82       movq   %r15,0x30(%rsp)
   0.01 =E2=94=82       movq   %r8,%r15
        =E2=94=82     =E2=86=92 callq  *%rax
   0.04 =E2=94=82       testq  %rax,%rax
        =E2=94=82     =E2=86=93 je     2e3
   0.01 =E2=94=82       movq   %rbp,0x10(%rsp)
        =E2=94=82       movq   %rax,%rbp
   0.03 =E2=94=82       movq   %rax,(%r15)
        =E2=94=82       movq   $0x0,0x28(%rax)
  99.52 =E2=94=82       lock
        =E2=94=82       btsq   $0x0,(%rbx)
   0.01 =E2=94=82     =E2=86=93 jb     26b
   0.13 =E2=94=82 67:   movq   (%rbx),%rdx
   0.01 =E2=94=82       testq  $0x2,(%rbx)
   0.01 =E2=94=82     =E2=86=93 je     e2
        =E2=94=82       cmpl   $0x2,%r14d
        =E2=94=82     =E2=86=93 je     d2
        =E2=94=82       movq   0x40(%rsp),%r8
        =E2=94=82       movq   %rbx,%rdi
        =E2=94=82       movl   $0x1,%ecx
        =E2=94=82       xorl   %edx,%edx


Anton

