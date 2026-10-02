Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC0E0CA5FE0
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 18:55:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C058D6B0096; Fri,  2 Oct 2026 14:55:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB5C86B0098; Fri,  2 Oct 2026 14:55:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA43B6B0099; Fri,  2 Oct 2026 14:55:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 78C8F6B0096
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:55:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 19F841A07E8
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:55:47 +0000 (UTC)
X-FDA: 85278590334.04.0B26C10
Received: from mail-ed2-f32.google.com (mail-ed2-f32.google.com [74.125.228.96])
	by imf24.hostedemail.com (Postfix) with ESMTP id 35E54180006
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:55:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=epfSMx1u;
	spf=pass (imf24.hostedemail.com: domain of antosha20xx@gmail.com designates 74.125.228.96 as permitted sender) smtp.mailfrom=antosha20xx@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790967345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LNkTda6yyFagzwxVvIs1fSSzlLcgdVCdiWc/DPOusfc=;
	b=drYRgpFySusQG7GCguING+Da8jlT1GUgN/qd+DmXNkk68fudY/3XOcHL/TXFwMoqNBBAmF
	J/w1J4PCBnBFTlMeti4njAGFvMHEVg3Z9/CHXFcagenKwsy8L9dpAME0ar8jm/r1Tyh5jt
	1CrwLN5rmk5p305WYSr6VpfzrvC2C/8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=epfSMx1u;
	spf=pass (imf24.hostedemail.com: domain of antosha20xx@gmail.com designates 74.125.228.96 as permitted sender) smtp.mailfrom=antosha20xx@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790967345;
	b=fM0Pq5bWtGyYQyaoj7D9KN04KLi3cfJiYSsNegPxx+U4p0wsnMur6ZWyFOWk4vgCAqmrWD
	QnynbW2JFK3dyiFPQPo3NrYMJThKj9elTLXNySSyholKR2fXaHFQUFKXbSRxSE/yLjikLx
	8ue9MTaLkGXRYp+bfm01M/397I/shYc=
Received: by mail-ed2-f32.google.com with SMTP id 4fb4d7f45d1cf-6acbdf627ccso294832a12.2
        for <linux-mm@kvack.org>; Fri, 02 Oct 2026 11:55:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790967344; cv=none;
        d=google.com; s=arc-20260327;
        b=gq3CK7EqXH6YcTGxYexik20xv+ikDmI36QyyGxYy02ph+PrkBeWMKrLrcECukZGG4M
         CtPnN4+4Cpl9RuGXWsZy04BWWDAgxbWF/Yu7Ely3Eqgi7S5PGc9qDPhe+HbS19rmIzjm
         Is5VZAlfPJZuwfQ1m3hegXYvXPXZHiMAEH1IvNtVFZRS/iiqxB0OqBiPoee+pmKPNNpN
         xrQKja6GBtxFuLaqIwt51QjPvME+D7OLUQmy3EYuX4xi3qD5/4GYPH7cOK74L5d834rc
         cDa7bHE6iUPqMLgQ9q7x1a209kIFtj8drodNCIViEr6CHBuQjYkDj2G4ypaDGkPzuc4e
         5TjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LNkTda6yyFagzwxVvIs1fSSzlLcgdVCdiWc/DPOusfc=;
        fh=jgWn73aSQIvhkp2mDV6ENDmNlDS3/uChiPo/WOu0Aj4=;
        b=dAGukvaHeyhn6oAiShdFUTByxXweYtsj5P7+0pNnvqfhqxG9P5MB7XIheyhI8ab8oC
         v8lVN172Nqmg8IvCwVIm2W4TtBhmBz/JJVGH0BHlD8v5KEJiPjIn6pW+6llumYy39I8v
         xi5l/K+gr8wsbXfGlt4SfXJE1At3i4k2wi32LuuHMOslPpt9yxWx5bBNgV3QRPYX82L2
         m4Mf81o/P3cGJiT1zOW9PdEUcyjuL+WRUu+16LBmnjR18S7ZJLde0iQHWbl7iOKQIOyD
         IPvmZVO2aAT8emsbt0J/cmzrtHQBcW2Fzf0Zo9YNW1M33dsQG4lSgczYV/uyodNy0PMg
         SaBw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790967344; x=1791572144; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LNkTda6yyFagzwxVvIs1fSSzlLcgdVCdiWc/DPOusfc=;
        b=epfSMx1u3VcaoOFJNwHKmaC1UUd+AF1qMIi7oP+mV91Z4gx2z7yssVmWgyXw92zLLI
         D2SaL2nt6cbwVLR+mSkGE9nIv0TdWJw1rG8unbqj9f19Gm2Pacm+HmH2GIOpefTgLVVv
         oiuXrP6wEMemhb8DSnkZ/9WbKmZ18scwcg5GOf1yNMQLvwwMZ3a0Ykf7Gw/kJeS8fg0y
         SZeRsXlkGY3e54iHIIo3YYxKnv1k5Yc758SK+GIosj2NWFEdxmycygCATZFGifk4u8eB
         CzGaOp3xjvFSL+MAbbzxEiEPBpRy3IeV8mDkr9Fddqaa0CMcq298IRM265GMtlnMqpbY
         3TQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790967344; x=1791572144;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LNkTda6yyFagzwxVvIs1fSSzlLcgdVCdiWc/DPOusfc=;
        b=J2wO4baIs+hmUzNPHiDaID4hm/I+avRHqsC7vPEyLGVyManFTVnLbEk0M8TkCVUNk1
         TxkoGKcx5GL4g4xH+HzTsrjuZhywEsrAQQhCn52oftiMDPPPvJvmyrAICQdP9oTmENt2
         x8MUc/CaoIeNiXvjdWrztmnllQo2FdHPWH1xDsl7Tpskxvpjw/TmJ7zqWW9KwaUegGu+
         /k5797ECw/xxLglSnNHOyg4guDThcahbrLop+UFE+H09PHGCwobyYELp5C6J5nW9Kt+Q
         krFTHnQtyCjzDKrk0ouOf8aicgr/syhGWB/1PHtsmshLkf8bAKgBHcsSKgwBAwjERSQ8
         sRhA==
X-Gm-Message-State: AFq9FYLwOpPuQMYUwuvzlIePIzXYczeaC4ttV8jyhnu224Wv12eVBlhO
	wO1m8+R6ITAgj8h06/uL0hg7ky+Je4LknP2uq5UHFt6M8HVOLQCzP/Yys+8Xpix2rSOnL2rZKkC
	clK+6cqkEdQR6q82v4X3CSC1GBFgNopQ=
X-Gm-Gg: AYBFou2WT250tUBMDxJffUA4t+XwXULGq80lPxHvAK963x1ioMu8zJJ72kZgA14UPXJ
	8Wknb/w7pWh9tR0f2jq8eURvD65vQ9+/J+slNpY1NmOGKnL9Jn6Sj2xLPjiz+kT0d3OLzdcuctk
	RO/ff9SdC5VRWNwq3UsmcbkmN+VqsB1fZsYib7HY+MoE+y2yMaFF3swY9Oi5Dg18+VrqT7b6A9n
	g0/j4RwNq1htLWa7ns2qp/qHM/1DFqwCUyeE5wIgkvyeSuRqi/pJMFfMZ1iXH1BAkvhHNnZ+ES9
	EUqyKXAJouBwt8ZClEUzotXUtc78FrA4ZBgsvubIFLvmmVey0qhBytSc
X-Received: by 2002:a05:6402:50ce:b0:6aa:fc60:60d0 with SMTP id
 4fb4d7f45d1cf-6af9e3183bcmr2645064a12.33.1790967343575; Fri, 02 Oct 2026
 11:55:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAAiJnjqz+OB+PmUQBENS8ThnWHSAFK=p3EA7KPsy5UeabQCn-A@mail.gmail.com>
 <ar_rPzLhXRSA0AfS@gourry-fedora-PF4VCD3F> <CAAiJnjo86U27YwFNSkQNvqxDyGMZomoqHToH3GqWuzqD2+V0Vg@mail.gmail.com>
 <ar_zftIk5caN-5uV@gourry-fedora-PF4VCD3F>
In-Reply-To: <ar_zftIk5caN-5uV@gourry-fedora-PF4VCD3F>
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Fri, 2 Oct 2026 21:55:32 +0300
X-Gm-Features: AclHuK-OPEiDUxmD9Rz4Dp_NTbAcXn7cTqOJk7bQfyeemvZ--NfgdiNOFNhU0po
Message-ID: <CAAiJnjrjtseaUPo5vyqGZeDAt4ST6eqvaXOCWvdaTUsx2D3v5g@mail.gmail.com>
Subject: Re: Poor memory bandwidth performance between NUMA nodes
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 35E54180006
X-Rspam-User: 
X-Stat-Signature: 3mep17zej7ocawntpbyfnfoc4ow56xoq
X-HE-Tag: 1790967345-615638
X-HE-Meta: U2FsdGVkX19OFvJj9YlTzUqr/xzNmoSoJayBcxWLJLC9R0J8DAU+RABB/f7gXdzpMjKaOzr/SIsQ74f1JaAdijiYUQNBCRtMwpEjXsEbzvdA71piaXT02TDJpE2yf2txIBr24EQineIJhiccU1zvw05liDkzMtEAukDgseSV0qsCajzQtCa5wwjPFu4meG8G6Id6wnjVoWligA1dDenmVHi6/ZOqJisDQ3DQ8YQ+pyuCPwGOSrHEDXlV0p1U2Bnw1WJ9lZ795DlX6IVqJ70ceEQFntBnblmkCUiafhORlkUU6+NCE9VE1n1GyXnR9r9SMy086FXuPVfZTBdjy7wPUtq+wlcaPwTCpS8y6ofRzOF6NSyqxHBCrufgup0l0oRfBcExfnIU6oJgzAr4zEexL3B4wHTBwBtXwp0hWe8NTxkvqgzOpOwwZdxEEa5S8LbE+YAaz8g7ZMNa0fnuGqn+Mg9vUlYTQPNdfa0RA/ZxeCJ0eHSo2loZtopJYESxyrvUicgpHxP7rz0njrGBuJfEhK0up/ccPsNpRJKeMJgC4WhfDJOcI5NYtO357sRlBoUpHoQuNhmZexSB5eI23UNQdLRDpXzYZjWkaMreOlil4otD+8uXJZ7z/SWKcZhW2EWtQWy+hD7aquGRuDGLSd6XqXPype3XAB8FuoXS+Ds5tDDnR4mDz07kj+AB7kPPD5E478KwGHs4cC4zr3lwn6fkU7uaHXjih4DIg1v4YkJ9vRpol+1A6BDWFfhlFexos2NER11lwfwt8Sptjot4AtBPEpxeemh1MWKGJEVD75BCfOP+UBC1a2ecbNLGpM7Ml4N1kmn8/bL1LuLoe6OIuF0XuV2ho76uZUD6jLUn0Dp7rKpTVUWgs0OUOUHD1mMtEU3yG3SAgS0mfzAFegM5E4CqdgxPdlp0zXrqzWTGpY/vfJkTBbFr+hVr+RC+VMKr14LP87T5oF4z+724ozy3A2g
 oVCC068F
 R6x3QUzf3Cpj211gaFsu78+MdX/1jNTve60D0xX8xi/PN9DmDALca9IwEh6NlyNDo0vRshagek/8afj5ZQVDwB3P3zsV0Nnh8MgKlrrJZxQvSku4OyKwbVAY40ogjLlH6EwuxJAOhsuiSWhWpA7MBCCzVLlg8Eq98yzM3O7NNmip7tbNTfBBayO48KNtZB2jBk72N2X3K2PZU1xh2H0432P7C/yHoKaGDKTQk3cRDhAlCXm6UleDWI6Xbiir6TwdMl6/lqW39uXeod6u+GFjy8J7d0oFTek0J+FwoYVuO01Y2/imHk10t+lGNeOLiyiD1Y10ORwHjyXipg55sEwDxUW7oOl8lVDgrQTpf0miI7yhkfxtTSDdwqcSx6vgpE8wpQEYWYwaXkPo2xdc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> I'm unfamiliar with Valkey, but you may want to ask how contended those
> pages are if they're actually being used during migration time.

> Do you get this same behavior when migrating the same amount of memory
> allocated by a toy program? (i.e. known idle pages)

I don't think that there is any contention.
There is no processing, etc.
This is a completely idle test server.
I just populated 300GB memory by key-value data store.

Even if I use simple stress-ng instead of Valkey,

[root@localhost ~]# numactl --cpunodebind=3D0 --preferred=3D0 stress-ng
--vm 1 --vm-bytes 300G --vm-hang 0 &
[1] 4353
[root@localhost ~]# stress-ng: info:  [4353] defaulting to a 1 day run
per stressor
stress-ng: info:  [4353] dispatching hogs: 1 vm
stress-ng: info:  [4355] vm: using 300GB per stressor instance (total
300GB of 6.43TB available memory)


[root@localhost ~]# COLUMNS=3D500 numastat -p 4356 | cat

Per-node process memory usage (in MBs) for PID 4356 (stress-ng-vm)
                           Node 0          Node 1          Node 2
    Node 3           Total
                  --------------- --------------- ---------------
--------------- ---------------
Huge                         0.00            0.00            0.00
      0.00            0.00
Heap                         0.06            0.00            0.00
      0.00            0.06
Stack                        0.03            0.00            0.00
      0.00            0.03
Private                 307201.14            0.74            0.00
      0.00       307201.88
----------------  --------------- --------------- ---------------
--------------- ---------------
Total                   307201.23            0.74            0.00
      0.00       307201.97
[root@localhost ~]# man migratepages
[root@localhost ~]# migratepages 4356 0 2

I see even slower (System PMM Write) than 1.4 GB/s,

|---------------------------------------||---------------------------------=
------|
|--            System DRAM Read Throughput(MB/s):        842.67
        --|
|--           System DRAM Write Throughput(MB/s):        851.34
        --|
|--             System PMM Read Throughput(MB/s):        785.27
        --|
|--            System PMM Write Throughput(MB/s):        804.57
        --|
|--                 System Read Throughput(MB/s):       1627.94
        --|
|--                System Write Throughput(MB/s):       1655.91
        --|
|--               System Memory Throughput(MB/s):       3283.85
        --|
|---------------------------------------||---------------------------------=
------|


top - 21:49:22 up  4:53,  3 users,  load average: 0.97, 0.78, 0.61
Tasks: 774 total, 2 running, 772 sleep, 0 d-sleep, 0 stopped, 0 zombie
%Cpu(s):  0.0 us,  1.8 sy,  0.0 ni, 98.2 id,  0.0 wa,  0.0 hi,  0.0 si,  0.=
0 st
MiB Mem : 6839822.+total, 6432377.+free, 422358.2 used,    790.2 buff/cache
MiB Swap:   8192.0 total,   8192.0 free,      0.0 used. 6417463.+avail Mem

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMM=
AND
   4507 root      20   0    2644   1764   1644 R  99.8   0.0   2:20.63
migratepages
   1592 root      20   0   82184   5056   3932 S   0.3   0.0   0:07.26
irqbalance
   4993 root      20   0       0      0      0 I   0.3   0.0   0:00.02
kworker/50:0-events
   4999 root      20   0   10916   6080   3772 R   0.3   0.0   0:00.03 top
      1 root      20   0   25528  15488  10484 S   0.0   0.0   0:02.35 syst=
emd
      2 root      20   0       0      0      0 S   0.0   0.0   0:00.06 kthr=
eadd
      3 root      20   0       0      0      0 S   0.0   0.0   0:00.00
pool_workqueue_release
      4 root       0 -20       0      0      0 I   0.0   0.0   0:00.00
kworker/R-rcu_gp
      5 root       0 -20       0      0      0 I   0.0   0.0   0:00.00
kworker/R-sync_wq

Samples: 26K of event 'cpu/cycles/P', 4000 Hz, Event count (approx.):
21652648047 lost: 0/0 drop: 0/0
Overhead  Shared Object                      Symbol
  21.77%  [kernel]                           [k] copy_mc_fragile
  18.88%  [kernel]                           [k] clear_highpages_kasan_tagg=
ed
  17.81%  [kernel]                           [k] migrate_folio_unmap
   2.67%  [kernel]                           [k] __folio_alloc_noprof
   2.09%  [kernel]                           [k] smp_call_function_many_con=
d
   1.89%  [kernel]                           [k] try_to_migrate_one
   1.74%  [kernel]                           [k] folio_migrate_flags
   1.69%  [kernel]                           [k] page_vma_mapped_walk
   1.14%  [kernel]                           [k] remove_migration_pte
   1.01%  [kernel]                           [k] rmqueue_bulk
   0.88%  [kernel]                           [k] migrate_folio_move
   0.87%  [kernel]                           [k] __mod_memcg_lruvec_state

Samples: 111K of event 'cpu/cycles/P', 4000 Hz, Event count (approx.):
56222244297
copy_mc_fragile  /proc/kcore [Percent: local period]
   0.00 =E2=94=82      cmpl  $0x8,%edx
        =E2=94=82    =E2=86=93 jb    43
        =E2=94=82      testl $0x7,%esi
   0.03 =E2=94=82    =E2=86=93 je    27
        =E2=94=82      movl  %esi,%ecx
        =E2=94=82      andl  $0x7,%ecx
        =E2=94=82      subl  $0x8,%ecx
        =E2=94=82      negl  %ecx
        =E2=94=82      subl  %ecx,%edx
        =E2=94=8219:   movb  (%rsi),%al
        =E2=94=82      movb  %al,(%rdi)
        =E2=94=82      incq  %rsi
        =E2=94=82      incq  %rdi
        =E2=94=82      decl  %ecx
        =E2=94=82    =E2=86=91 jne   19
        =E2=94=8227:   movl  %edx,%ecx
        =E2=94=82      andl  $0x7,%edx
        =E2=94=82      shrl  $0x3, %ecx
   0.02 =E2=94=82    =E2=86=93 je    43
  58.57 =E2=94=8231:   movq  (%rsi),%r8
  12.21 =E2=94=82      movq  %r8,(%rdi)
   4.22 =E2=94=82      addq  $0x8,%rsi
   8.25 =E2=94=82      addq  $0x8,%rdi
   0.53 =E2=94=82      decl  %ecx
  16.06 =E2=94=82    =E2=86=91 jne   31
        =E2=94=8243:   andl  %edx,%edx
   0.02 =E2=94=82    =E2=86=93 je    57
        =E2=94=82      movl  %edx,%ecx
        =E2=94=8249:   movb  (%rsi),%al
        =E2=94=82      movb  %al,(%rdi)
        =E2=94=82      incq  %rsi
        =E2=94=82      incq  %rdi
        =E2=94=82      decl  %ecx
        =E2=94=82    =E2=86=91 jne   49
   0.02 =E2=94=8257:   xorl  %eax,%eax
   0.06 =E2=94=82    =E2=86=90 retq
        =E2=94=82      int3
        =E2=94=82      int3
        =E2=94=82      int3
        =E2=94=82      int3

Samples: 187K of event 'cpu/cycles/P', 4000 Hz, Event count (approx.):
84234492777
clear_highpages_kasan_tagged  /proc/kcore [Percent: local period]
Percent =E2=94=82      nop
   0.03 =E2=94=82      subq 0x1a5067c(%rip),%rdi
   0.01 =E2=94=82      movl %esi,%ecx
        =E2=94=82      xorl %eax,%eax
   0.03 =E2=94=82      sarq $0x6, %rdi
        =E2=94=82      shlq $0xc, %rcx
   0.03 =E2=94=82      shlq $0xc, %rdi
   0.03 =E2=94=82      addq 0x1a50675(%rip),%rdi
  99.72 =E2=94=82      rep  stosb   %al, %es:(%rdi)
   0.09 =E2=94=82      nop
   0.06 =E2=94=82    =E2=86=90 retq
        =E2=94=82      int3
        =E2=94=82      int3
        =E2=94=82      int3
        =E2=94=82      int3
        =E2=94=82      nop

Samples: 223K of event 'cpu/cycles/P', 4000 Hz, Event count (approx.):
88021056491
migrate_folio_unmap  /proc/kcore [Percent: local period]
   0.04 =E2=94=82       movq   %rdi,%rax
        =E2=94=82       movq   %rcx,%rdi
        =E2=94=82       movq   %rbx,0x8(%rsp)
        =E2=94=82       movq   %rcx,%rbx
   0.04 =E2=94=82       movq   %r12,0x18(%rsp)
        =E2=94=82       movq   %rsi,%r12
        =E2=94=82       movq   %rdx,%rsi
        =E2=94=82       movq   %r13,0x20(%rsp)
   0.06 =E2=94=82       movq   %rdx,%r13
        =E2=94=82       movq   %r14,0x28(%rsp)
        =E2=94=82       movl   %r9d,%r14d
        =E2=94=82       movq   %r15,0x30(%rsp)
   0.05 =E2=94=82       movq   %r8,%r15
        =E2=94=82     =E2=86=92 callq  *%rax
   0.05 =E2=94=82       testq  %rax,%rax
        =E2=94=82     =E2=86=93 je     2e3
   0.06 =E2=94=82       movq   %rbp,0x10(%rsp)
   0.04 =E2=94=82       movq   %rax,%rbp
   0.20 =E2=94=82       movq   %rax,(%r15)
   0.07 =E2=94=82       movq   $0x0,0x28(%rax)
  97.01 =E2=94=82       lock
        =E2=94=82       btsq   $0x0,(%rbx)
   0.04 =E2=94=82     =E2=86=93 jb     26b
   0.70 =E2=94=82 67:   movq   (%rbx),%rdx
   0.12 =E2=94=82       testq  $0x2,(%rbx)
   0.04 =E2=94=82     =E2=86=93 je     e2
        =E2=94=82       cmpl   $0x2,%r14d
        =E2=94=82     =E2=86=93 je     d2
        =E2=94=82       movq   0x40(%rsp),%r8
        =E2=94=82       movq   %rbx,%rdi
        =E2=94=82       movl   $0x1,%ecx
        =E2=94=82       xorl   %edx,%edx
        =E2=94=82       xorl   %esi,%esi
        =E2=94=82       movl   $0xfffffff0,%ebx
        =E2=94=82     =E2=86=92 callq  migrate_folio_undo_src
        =E2=94=82       testq  %r12,%r12
        =E2=94=82     =E2=86=93 je     1b0
        =E2=94=82 9d:   movq   %rbp,%rdi
        =E2=94=82       movq   %r13,%rsi
        =E2=94=82     =E2=86=92 callq  *%r12


Anton

