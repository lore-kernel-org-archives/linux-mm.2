Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF118C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 13:20:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD1426B0088; Wed, 22 Jul 2026 09:20:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5ABC6B008C; Wed, 22 Jul 2026 09:20:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C49406B0096; Wed, 22 Jul 2026 09:20:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 941C76B0088
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:20:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 066C7A0069
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:20:43 +0000 (UTC)
X-FDA: 85016472366.13.79D4E05
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by imf04.hostedemail.com (Postfix) with ESMTP id 595E14000F
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:20:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of 3qMNgagkbAA05BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3qMNgagkbAA05BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784726441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=0OUYkqz3oMV82NBiRzhZsN3Su7jaCGkuk4svSuitAHk=;
	b=pUMHzlegXFe4KO/lp602RJH8+e/pptrY4hfYRQLUxMxhyGdmZJZjdm9Wvt30I0o25/tP6h
	s6HqKHgsSGox/TxOZGwSCjbqKUUGl5dFMUnQjikOI0ef6wLeUdOpnwlWxu25QhjTxbmtUV
	VGI9HDn6uEMykNxZIe4DvjvYyQS5oDg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784726441;
	b=I3uh1shl7tefew9as3sbHyEsC2pTZQL9A44g4/59izoW6/7Y0jD0BrLs8thbc9eRHr7UQf
	tLD4fE5gmJeuiaN1lD3Xnnv0n9XNP6EFMQz3w7qU0K6yMnk+a0zBZIEr8jqhJd1AOorSyG
	x8nUMYz6HahlQZDBQ6484CnZl34tPcM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of 3qMNgagkbAA05BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3qMNgagkbAA05BCxnyyr4n22vq.t11tyr75r4p106r06.p1z@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-495b8b30310so14475605b6e.1
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 06:20:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784726440; x=1785331240;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=0OUYkqz3oMV82NBiRzhZsN3Su7jaCGkuk4svSuitAHk=;
        b=S65swQNfkMnGmyTifQ70x/cTrX0aO/5GaWFOynXGhezmIT55Nxsl5aBbN8kaJkAbt9
         Gb9a+JTdz3FqiF719m0Tz9q83WmUKveI3KIci1xVOfWjrzQ+kf7ieQ3V/MetLxSK0iBx
         lGhvTktweBzGsgiTpbVxBRM5gkyjDal420D+Cp4cpkfjHKKGUdWB9Iu1jyfjplsU70zl
         oANC/It5/lAU/Ps99RhQBY8s2RBN1jn7Cmqd839DG4a843GgE8QaVXGdhq5eqHWNNRNf
         0bdIieqKTuA8mQwQbfPHDzqMxW9y/eCRCmAd7VKOYLCn/0f5ZV0mHJF/zecMIlxM+PaF
         MliQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpp3qX8vtL/xH9pRQq6LIQUmCYo3QCd6uoizqQzoK3KHhcyBEwIKgOQVu2xkiYBYK1tNfrdjKBbxA==@kvack.org
X-Gm-Message-State: AOJu0Yw23LG1+lO6+F9I2kcob8j6LDYDMWCJb/7WCh8CNx6Us0Q4jVxT
	4LazR/a8FIvehKhtK4vEXhJyEH1LJ90+WT+c9tnMUA/16RIv4DPGvzYm2HxL/S1z7otZVzmgFe1
	CFLS19OMwccjW53vT5tWzz/vEgox5xJcPh/E4xmNkEnRzVkR9cRSzvVVjLdM=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:170b:b0:49b:dcb8:e2b5 with SMTP id
 5614622812f47-4a4d022413dmr11716902b6e.19.1784726440406; Wed, 22 Jul 2026
 06:20:40 -0700 (PDT)
Date: Wed, 22 Jul 2026 06:20:40 -0700
In-Reply-To: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a60c3a8.42649fcc.22d900.0013.GAE@google.com>
Subject: [syzbot ci] Re: arch, mm: create a generic set_memory/change_page_attr
 core
From: syzbot ci <syzbot+ciff95a07853f6d218@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, aou@eecs.berkeley.edu, bp@alien8.de, 
	catalin.marinas@arm.com, chenhuacai@kernel.org, dave.hansen@intel.com, 
	dave.hansen@linux.intel.com, david@kernel.org, hpa@zytor.com, 
	jackmanb@google.com, jgross@suse.com, kevin.brodsky@arm.com, 
	liam@infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, ljs@kernel.org, loongarch@lists.linux.dev, 
	luto@kernel.org, mhocko@suse.com, mingo@kernel.org, mingo@redhat.com, 
	palmer@dabbelt.com, peterz@infradead.org, pjw@kernel.org, rppt@kernel.org, 
	surenb@google.com, tglx@kernel.org, vbabka@kernel.org, will@kernel.org, 
	x86@kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 595E14000F
X-Stat-Signature: rwcas9unrmxf9jegcnhespgrksxzurxz
X-Rspam-User: 
X-HE-Tag: 1784726441-935216
X-HE-Meta: U2FsdGVkX190vPBndErhgVxdHMsFuMtIDuMl+m1YdBetP+o7bj3S5rrsZBdDTlrZEBHk8ql8Pjl8NEPHmxgEPUYGqjxg4HTOMzpmCguVVtxq4AtxEu/TwYeuMnHJiJsNqwVaSGkAOfq2j/10JEBw034IPzrsVsDZIeIq4WWOG3LQC/zR9ErdOAOPUTusScPeVfikIUcZLKkHgkw2gikT2/Jushxv6L2VQEOekm3Xk+3bxqH6u09c/eTyoH9IcWT9d1p7mlqQjydfHEV1K3HOsvE6NzOihrYJ4+ixiJKWwsP6SUM3Gh/dFLq/auyRYwz/co7XeLoBC9pIwhm0J1C1+iPrVzgXaE5icwnyiuvd9vhZRnQPKZfOnTuSMr+uwN69qT6Gla5X1BgOExiTl9d+fOKC9JGdFqXrp2IYQvO4JrgFQiH0wsYuUljUmzSdwi0HXrhBTaTvTUCbLNorrcnDn1m41lxzZxhcr+5fOePlaARhyO4RyPYd1YL0U9gaMUlvErOv2NZk4NLOlnWtiCfKw93nN0ITGftciGnShBIvg3PYX0u+IxpSs48SiJfVvTlLe4mOrfB8nn6Fbs+DWQ+2xgvkFtpEkuq+JlbG4xIJqWHTpSmso6L4gZjyGkG4TI31/VfrvqO3Bv/ZnlCvKrT636XatKZWc/m3HZvGwUlJfli0g4WXmOOjgcqR2bvfP3BiWFhDoXagoZ879pE7+JICaL43cjvD4+07DlvnfUdwMlbAD2ilWhMiYc/WUpgFPGNlVK78Ji6fQextSp6T4HxnUz0wlAGvWHcpSlSuEEBLXu0k/1cQO22xkVj+tqbqBKiSsW+PThhw1RU2sL8mFfyA3wzEkgCm51IGRcNsK6q1vOUgFw66vviuffTQDfy/VHZIUC4Wooqnh5zvrLn1SVR7v5HxINjK986m8rSlrkb7pMYfskvFJRaZJ7NSezHA0oqv1cR3xtvV+Dvpm6Erwrm
 DbGF5Qly
 FRxDFAb3B58eog78K//65pky8/rGHoHYxxmPBCt9IxStl5ewYW6adV7yRtFKQSGurgLv3YYAat/gY5qbqdc1UIoQR3BYY8kfyl6sDEdbQR1KXE1op59Sz8nIW/PWFlu2Ji2b9n8j/xSXefclxIA5PwnbcXFjL5jGxHG/MBCSGQ4Crj+70xk1W4lB+ezQqHhfQkTXF2yXN6J5Xjrd20Hp4KjvpVS2q8TS55Tk4SHBQZoKay321p0/eoCavSRGCfAo5XiJQ9gxVqImUv7/Dtv8QCVRjwBZPcLyPutZHf7Sb/AQ4J2s/XfkK35iYwzssrApleKARpdZ6cpjA3QTYSzMF8vZKjPRbjVTV4TjY8Orug56ZUN2weFsJ1LbEWS7e3hSbkHumWVSBkTQKrUImjVo1e8xzUUvdI6PlkqSKWmD4d5l1REflDIHxMIqObXbjk6QLLJ+l2Jol2L4cOyZ687BxQv4Pgu07A86SsacbIwocppRAhtnF23TF0as6MzGMKtUVknxED584E7HRA7V98He/JlTxTJoyxqmypAdtubr7hkCb500lvySBX/mUvrCSCHFsTdPT7iF9swPZ6NST1gL/QIA6XL524nLlgA5CK27RLyKeSlUK+FuMMbUjFn+VWKmexoqmBR6TPJTYYg+A0Ed72RmGgWbVf7nf8popV/5dnyYHzNl4Jv83B4Q2eEwDcXKr29dwFNTjn5BOkIVxPEmyuH8njFIHWqBCDms1XXUDas8ERLSAT6B+CvjRmLe/OLAb+PcjKcdLvbf0m1RjQbq6ZNqCKXyaVCGroswDW1qLXunTxshMDiSX/eg78yj+XlG94WBkvmFRt5XcDpdNHked8slDW9HrRj90ccZv2F4IkpfaIMZl9X/f6vX6htDdr/dZk24CBiU0LRWiv+NwzUecZNNHQO2im44n44UwaJOtBzq0GvQ4eZxAOBshj/Tfsr/cujmHwkGs8nEYstkVNw15c42OPzxe
 okbd8Hsj
 9N3nyYP5rHECtAAc63QkGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] arch, mm: create a generic set_memory/change_page_attr core
https://lore.kernel.org/all/20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org
* [PATCH RFC 01/18] x86/mm/pat: Don't gate cpa_lock on debug_pagealloc_enabled()
* [PATCH RFC 02/18] x86/mm/pat: fix effective RW computation in lookup_address_in_pgd_attr()
* [PATCH RFC 03/18] x86/mm/pat: replace x86-speficic pg_level with generic pgtable_level
* [PATCH RFC 04/18] x86/mm/pat: use page table accessors for effective RW/NX bits
* [PATCH RFC 05/18] x86/mm/pat: use a generic helper for the large page size
* [PATCH RFC 06/18] x86/mm/pat: introduce an inline helper to check if alias needs update
* [PATCH RFC 07/18] x86/mm/pat: introduce cpa_handle_large_page()
* [PATCH RFC 08/18] x86/mm/pat: use cpa_split_data structure to pass split parameters
* [PATCH RFC 09/18] x86/mm/pat: use a single locked lookup for PTE verification
* [PATCH RFC 10/18] x86/mm/pat: move the large page size calculation to should_split_large_page
* [PATCH RFC 11/18] x86/mm/pat, mm: set_memory: pull change_page_attr() core to mm/
* [PATCH RFC 12/18] x86/pat/mm, mm/set_memory: abstract the CPA page table lock
* [PATCH RFC 13/18] mm/set_memory: read page table entries with pXdp_get()
* [PATCH RFC 14/18] x86/mm/pat, mm: move cpa-test to mm
* [PATCH RFC 15/18] riscv: convert set_memory to the generic CPA implementation
* [PATCH RFC 16/18] riscv: make set_direct_map_*_noflush actually noflush
* [PATCH RFC 17/18] loongarch: convert set_memory to the generic CPA implementation
* [PATCH RFC 18/18] loongarch: make set_direct_map_*_noflush actually noflush

and found the following issue:
WARNING in arch_should_split_large_page

Full report is available here:
https://ci.syzbot.org/series/08799ddb-4fca-4e5c-a2a7-a16eb2845851

***

WARNING in arch_should_split_large_page

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      dc59e4fea9d83f03bad6bddf3fa2e52491777482
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/9a435490-f68f-4ca0-96ae-457a5caa17e6/config

Demotion targets for Node 1: null
debug_vm_pgtable: [debug_vm_pgtable         ]: Validating architecture page table helpers
Key type .fscrypt registered
Key type fscrypt-provisioning registered
kAFS: Red Hat AFS client v0.1 registering.
Btrfs loaded, assert=on, zoned=yes, fsverity=yes
Key type big_key registered
Key type encrypted registered
AppArmor: AppArmor sha256 policy hashing enabled
ima: No TPM chip found, activating TPM-bypass!
Loading compiled-in module X.509 certificates
Loaded X.509 cert 'Build time autogenerated kernel key: dc5bfa299b381f3c121e230b24acaec0874c302b'
ima: Allocated hash algorithm: sha256
ima: No architecture policies found
evm: Initialising EVM extended attributes:
evm: security.selinux (disabled)
evm: security.SMACK64 (disabled)
evm: security.SMACK64EXEC (disabled)
evm: security.SMACK64TRANSMUTE (disabled)
evm: security.SMACK64MMAP (disabled)
evm: security.apparmor
evm: security.ima
evm: security.capability
evm: HMAC attrs: 0x1
PM:   Magic number: 2:551:79
netconsole: network logging started
gtp: GTP module loaded (pdp ctx size 128 bytes)
rdma_rxe: loaded
cfg80211: Loading compiled-in X.509 certificates for regulatory database
Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
Loaded X.509 cert 'wens: 61c038651aabdcf94bd0ac7ff06c7248db18c600'
clk: Disabling unused clocks
ALSA device list:
  #0: Dummy 1
  #1: Loopback 1
  #2: Virtual MIDI Card 1
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
EXT4-fs (sda1): mounted filesystem b4773fba-1738-4da0-8a90-0fe043d0a496 ro with ordered data mode. Quota mode: none.
VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
devtmpfs: mounted
VFS: Pivoted into new rootfs
Freeing unused kernel image (initmem) memory: 26964K
Write protecting the kernel read-only data: 221184k
Testing CPA: undo ffffffff81000000-ffffffff8e800000
------------[ cut here ]------------
CPA detected W^X violation: 00000000000001a1 -> 00000000000001a3 range: 0xffffffff81000000 - 0xffffffff811fffff PFN 1000
WARNING: arch/x86/mm/pat/set_memory.c:601 at arch_should_split_large_page+0x493/0x710, CPU#0: swapper/0/1
Modules linked in:
CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:arch_should_split_large_page+0x49e/0x710
Code: 00 48 8b 44 24 20 48 25 00 f0 ff ff 48 8b 4c 24 08 4c 8d 04 08 49 ff c8 48 8d 3d 4d 66 e1 0e 4c 89 ee 48 89 ea 4c 8b 4c 24 18 <67> 48 0f b9 3a eb 05 e8 46 37 4d 00 4c 89 f7 48 89 ee e8 9b 39 4d
RSP: 0000:ffffc900000679f0 EFLAGS: 00010296
RAX: 0000000000200000 RBX: 0000000000000123 RCX: ffffffff81000000
RDX: 00000000000001a3 RSI: 00000000000001a1 RDI: ffffffff905a8280
RBP: 00000000000001a3 R08: ffffffff811fffff R09: 0000000000001000
R10: 0000000000000003 R11: 0000000000000000 R12: 0000000000000002
R13: 00000000000001a1 R14: 00000000000001a3 R15: 0000000000000002
FS:  0000000000000000(0000) GS:ffff88818d95a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000e946000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __change_page_attr_set_clr+0x936/0x12d0
 change_page_attr_set_clr+0x3ac/0x450
 set_memory_rw+0x8c/0xd0
 mark_rodata_ro+0xf0/0x140
 kernel_init+0x4e/0x1d0
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

