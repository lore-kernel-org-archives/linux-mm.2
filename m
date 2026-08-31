Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3563C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 10:45:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 075C76B0088; Mon, 31 Aug 2026 06:45:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04D476B008A; Mon, 31 Aug 2026 06:45:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA5496B0099; Mon, 31 Aug 2026 06:45:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF8346B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:45:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6460EA0450
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:45:04 +0000 (UTC)
X-FDA: 85161232128.02.66FAE7B
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf12.hostedemail.com (Postfix) with ESMTP id A233640003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:45:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf12.hostedemail.com: domain of 3LVuVagkbAJQGMN8y992FyDD61.4CC492IG2F0CBH2BH.0CA@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3LVuVagkbAJQGMN8y992FyDD61.4CC492IG2F0CBH2BH.0CA@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788173102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=qhkEAgoqO6ep+MkPIh2UOwEwqFOPQY1XaLq+naxQCEc=;
	b=hyI0tyX7G5puFlG5EF7l1ryOn1DGmstFHb8kFh9OOI2pLW+SKDK+HhCcMVtya3DrCBopzu
	KD1DDdBgzAEtfpOVe5bpZ3ovAXgw+aLZkQ/7quE9VAsoA63kavFLFpnh6/96eLbdUai+tI
	dEclUsILAcXrChYA7i9G5t+6K9e0Clc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788173102;
	b=GtM7uEq6OyF/oawqjDu/4ajETYquton1hjAMnfzkSB355+iHgLfX3ECEiFm+zmivreuO6o
	ZPviwi/rAdmshtOd6rKD8jScpwiutnvVcvj0A8FGGGHShYI6JL8IUki3SGPEHmDX290Itn
	rCz/bdDOinVbQ+RoaLLn1D8xNpqQKPw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf12.hostedemail.com: domain of 3LVuVagkbAJQGMN8y992FyDD61.4CC492IG2F0CBH2BH.0CA@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3LVuVagkbAJQGMN8y992FyDD61.4CC492IG2F0CBH2BH.0CA@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4ab4dd46ddeso2307799b6e.3
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 03:45:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788173101; x=1788777901;
        h=content-transfer-encoding:content-type:to:from:subject:message-id
         :in-reply-to:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qhkEAgoqO6ep+MkPIh2UOwEwqFOPQY1XaLq+naxQCEc=;
        b=gram0plyQ+EuVvhrBXWcY42isWomLez9DMRGOlbneaYExB0G7nX8negUxHg0zaJwSN
         rwH664grQGV567KBXogCkeidTb6dyFc+VA3zBoiLmyjtFYA4MVFuI+SzYsQ++YCperIT
         t7IrQkO2ci7r7zVN5ZStMeHgP9rfsUxQhipkdpP/agW03m7wqwS07GxM+s2FBAe9t7pJ
         VL8cWIr14grnJWmVMX8SjfPPZpFtzA5FBsAEFxWcLxisyczwk4ffsbtTdufq+GG7CKxr
         P8Gx+RfDUUtw1Vdy4BlWyZyd6yoKnfe6dW/O4gHKaEyhAfSRFx+WGZrfJSUW6xCHYmfO
         kNIA==
X-Forwarded-Encrypted: i=1; AHgh+RoSqmusJdqWp8/kGf5GjnTrbqHvJMvtOsyQj/Bk/Lp1s+vSvlzCaXZQvpYP9CZzCpcwGACfV65/lg==@kvack.org
X-Gm-Message-State: AFuF++nGRYO6i9D6FVY3uDbSVYDUAb/mTuSo160yW8aHVlkfyvF5RCyI
	Y2Wb7r0RtIYPNhUwmCGhclQvMIK6Ypw29HuvAiqMNvTAwDQ22duU8opFRHMRPgVCaZQwEdGLAAF
	KjYItD45Ul8zEcpz1GwvLSHYGHwfiyWy2Wm9AeHuA3iMEXRa9rinJyPAanYA=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:178e:b0:4b2:b653:87ff with SMTP id
 5614622812f47-4b39803b2ffmr29583819b6e.7.1788173101570; Mon, 31 Aug 2026
 03:45:01 -0700 (PDT)
Date: Mon, 31 Aug 2026 03:45:01 -0700
In-Reply-To: <20260831084112.410440-1-junjie.cao@intel.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a955b2d.4d659fcc.734b4.004c.GAE@google.com>
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in sys_munmap (2)
From: syzbot <syzbot+8785aaf121cfb2141e0d@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, bigeasy@linutronix.de, davem@davemloft.net, 
	david@kernel.org, edumazet@google.com, harry.yoo@oracle.com, horms@kernel.org, 
	jannh@google.com, jhs@mojatatu.com, jiri@resnulli.us, jpoimboe@kernel.org, 
	junjie.cao@intel.com, kuba@kernel.org, liam.howlett@oracle.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	pabeni@redhat.com, peterz@infradead.org, pfalcato@suse.de, riel@surriel.com, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz, vinicius.gomes@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: nen4gey4asqofreh87ubnyeyj5htzpwe
X-Rspamd-Queue-Id: A233640003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788173102-355314
X-HE-Meta: U2FsdGVkX1/S3Lvfoq5H9tTH8sWH66SaigcJo3bjneWA60lKpCEWmX26hUSN57SJdNRe2sSIxW/ICMfOvzkzX4OaH4bcDUALJkTaKGYoFwfShBT8qaRlzoQ4cLJPd0HxErRjTje9TAQ+BT7auCvmGbUStXnauVKiRSVXfRUUfzn9lxt/pyG/QeBeFMYJUdV4SDzkq/9XLn3n93VQJJdtM3fFVVL5g4lQ3+oT5vzeDqB8tqzddNSU9XoA0z5i3Frpx2WSG36Yf8HnJylh7GU4/992DTCDfhXVHaRn7lu+CCil3lN1uMGrAguJ2O7JruTE6BvRP+c2y+jrjg/IUV4COtYmPLt/iOH4kUlx0BEgGhUeO8kUxSqWtVv2cQ4IxIa59c3IwJDlLsDhDhna2bMiHnSX1kB0IgAUuE7jXRg9d6wxjjcqIXf4P9qQBK7vcg4hlCzBlo7U4AsPaxpSsSCpQS/sNuNJ+Wq1M7PBK8qWECyB9QygOitZThHG60Hh/P14p0N8Lx760zLtEaB5wGPeR+OnxmHqzLNkE0pH3LZd+nQ3BCcUFKsujlcVUGu836tG6H05KGx789h8aW8vVqDW3We8ylIhbKqGmJFP5lgsgD5X03A5uvIz2HiUvuA8bLA9eX7zq5KBxoZ2b4V90iTKsHZu7rYiVrsj0fxkEwENL3I4fPxeMUkxKJpk0RMLsy6DL6Pk3DcdQNJVwBrMg6fNPiUqPxB5RuOBkpu9ClKFCB6xlao8cqCIs/LNs6zdZegbUG1LeACXYtc9SuLTtd6VU08FzuWPpFwc7hEjNko8q6FPbGJqvOucaFdMLxS3AdpViqbZKlLGtU+FaNHQCh4EVDucCssT5/oon2E4S2UAAsheztNxRlPXhMoArkt54G+xFZRYdaGnB0q/2BbgoF/j5f5oFiB1mafzC1YcSBEEBxEvT5KwEyaNxE5XxKb+IN/lQ/FD4rZfrIlyU/txzFX
 GLblt33k
 bLkVqYxhyv6UtjpE4T3MPw9AazT/zCym80H5K7V5Pts0kEAl4mT1zVJ8JwZjcInmd1cw5ChfLwOj+abeaQjlJWPSKog32LZT7UJ2EAHDKDpMTLo/JXXD0RnOQLzOM/hfjPIplsbD5WZdhTYl6x5auozkSL0z3qzxQl/LcHgvx+1CuVmL6/Ssa85hij8iATtcp4jWc3tsvIQTLjqDAm85YesnIgr7yJdeex2hIbVEjl7uh8ZjKgMTP5YITI42AKO0LTzibqvBHrYdBE8o/BZxlBWAp7u/bVP+06HjySbqqLB6rZYkeplF+Pm0ZlU8bQvyVQbMfFa8FTXDtSww8IveaDQssv6kuO34Q21bVkZ/fnD6SXaidPYpMnlWIGIdgU8GOunuinpu4m8M5QY5kd1qXReTRwfvVMVhxbQFTuT2XZF771Fa1g5AakqD2VDfy0Mx6OXarYsBrKOaxyfKzG3I7Lj6fag4flRiqNiH4yj2z5Qp1YnDy9lQeykz/Be0v4xMSwIiLbt+d20D2EjRivVaalD34VdjNPUx9AF2tYeZzijnGpIpdh6wFR+LHyO7oGNjATbnOKAm8m1Gn0htt1r8CdDG5pxsl9tVK2q9jypWtFwrTDA7VVwa+7Mu74ea7bm1JzzeWfvyYx0ydXRhsHKQ3GUjEG7dT4V7N+vRZlKc4VKSSR7HEHLMrerAs0WoC5hd+TeHbuEl9nWcwJJyg5cSDGedumbx6c+hLWxec9teBDNqAo22EdppWz8TraOp4tRJ6rfv58kb5LV0aqtP/CL58tpuZam/ncwLiafkMi+zbuKWAaKN+JxZvuzU7thXsFnCXSUmPORUR2nej5Mnys1neBILKFvZQgXStX/37nbVtN2/3zp/GcDGtuj0Ni72I0SEWpS6LZWCltOpK6KePhhgwH2VJIOU3yXxiFui6dLS6jOOIJyCQ6bF6CYWgrIOdVrIJ7cMs9rHNxfXHQZRdMbtV3ecc8f/f
 oi5UjErG
 8UrogVDGzx+ZLe5ekEmcmzGQ+6KPAji/ajQmCjX6x4KlmzI/+cq00tK3uzMxwaTndCuhyMlogA9W8pxkrCRSV5sBLadbAUTvBV2RZJejDAizUuYITysePUO3TG1QhA4brcAONVVf0scTTpB5NWBQ4vo8sAcSzr+v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

 3.236788][    T1] Mandatory Access Control activated.
[    3.238423][    T1] pnp: PnP ACPI init
[    3.269664][    T1] pnp: PnP ACPI: found 6 devices
[    3.342961][    T1] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xf=
fffff, max_idle_ns: 2085701024 ns
[    3.352346][    T1] NET: Registered PF_INET protocol family
[    3.355095][    T1] IP idents hash table entries: 131072 (order: 8, 1048=
576 bytes, vmalloc)
[    3.367877][    T1] tcp_listen_portaddr_hash hash table entries: 4096 (o=
rder: 7, 294912 bytes, vmalloc)
[    3.370711][    T1] Table-perturb hash table entries: 65536 (order: 6, 2=
62144 bytes, vmalloc)
[    3.373291][    T1] TCP established hash table entries: 65536 (order: 7,=
 524288 bytes, vmalloc)
[    3.385547][    T1] TCP bind hash table entries: 65536 (order: 12, 94371=
84 bytes, vmalloc hugepage)
[    3.393661][    T1] TCP: Hash tables configured (established 65536 bind =
65536)
[    3.397399][    T1] MPTCP token hash table entries: 8192 (order: 8, 7208=
96 bytes, vmalloc)
[    3.400924][    T1] UDP hash table entries: 4096 (order: 8, 1048576 byte=
s, vmalloc)
[    3.404182][    T1] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    3.411572][    T1] RPC: Registered named UNIX socket transport module.
[    3.413199][    T1] RPC: Registered udp transport module.
[    3.414079][    T1] RPC: Registered tcp transport module.
[    3.414926][    T1] RPC: Registered tcp-with-tls transport module.
[    3.415874][    T1] RPC: Registered tcp NFSv4.1 backchannel transport mo=
dule.
[    3.424329][    T1] NET: Registered PF_XDP protocol family
[    3.425489][    T1] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 windo=
w]
[    3.426780][    T1] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff windo=
w]
[    3.427855][    T1] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bff=
ff window]
[    3.429423][    T1] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xfebfef=
ff window]
[    3.432220][    T1] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    3.433681][    T1] PCI: CLS 0 bytes, default 64
[    3.434929][    T1] PCI-DMA: Using software bounce buffering for IO (SWI=
OTLB)
[    3.437630][    T1] software IO TLB: mapped [mem 0x00000000b4400000-0x00=
000000b8400000] (64MB)
[    3.440304][    T1] ACPI: bus type thunderbolt registered
[    3.457158][   T60] kworker/u8:3 (60) used greatest stack depth: 27880 b=
ytes left
[    3.460006][    T1] RAPL PMU: API unit is 2^-32 Joules, 0 fixed counters=
, 10737418240 ms ovfl timer
[    3.483867][    T1] kvm_amd: CPU 1 isn't AMD or Hygon
[    3.484542][   T62] kworker/u8:2 (62) used greatest stack depth: 27160 b=
ytes left
[    3.486256][    T1] clocksource: tsc: mask: 0xffffffffffffffff max_cycle=
s: 0x285ce32725a, max_idle_ns: 440795269150 ns
[    3.488472][    T1] clocksource: Switched to clocksource tsc
[    3.523013][    T1] Initialise system trusted keyrings
[    3.526797][    T1] workingset: timestamp_bits=3D40 (anon: 35) max_order=
=3D21 bucket_order=3D0 (anon: 0)
[    3.535793][    T1] DLM installed
[    3.541986][    T1] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    3.550171][    T1] NFS: Registering the id_resolver key type
[    3.551232][    T1] Key type id_resolver registered
[    3.552038][    T1] Key type id_legacy registered
[    3.553117][    T1] nfs4filelayout_init: NFSv4 File Layout Driver Regist=
ering...
[    3.554408][    T1] nfs4flexfilelayout_init: NFSv4 Flexfile Layout Drive=
r Registering...
[    3.560217][    T1] smbdirect: subsystem loading...
[    3.568727][    T1] smbdirect: subsystem loaded
[    3.585999][    T1] Key type cifs.spnego registered
[    3.587259][    T1] Key type cifs.idmap registered
[    3.593788][    T1] ntfs3: Enabled Linux POSIX ACLs support
[    3.594840][    T1] ntfs3: Read-only LZX/Xpress compression included
[    3.596200][    T1] jffs2: version 2.2. (NAND) (SUMMARY)  =C2=A9 2001-20=
06 Red Hat, Inc.
[    3.599424][    T1] romfs: ROMFS MTD (C) 2007 Red Hat, Inc.
[    3.601080][    T1] QNX4 filesystem 0.2.3 registered.
[    3.602026][    T1] qnx6: QNX6 filesystem 1.0.0 registered.
[    3.604181][    T1] fuse: init (API version 7.46)
[    3.609768][    T1] orangefs_debugfs_init: called with debug mask: :none=
: :0:
[    3.612294][    T1] orangefs_init: module version upstream loaded
[    3.614231][    T1] JFS: nTxBlock =3D 8192, nTxLock =3D 65536
[    3.629821][    T1] SGI XFS with ACLs, security attributes, realtime, sc=
rub, repair, quota, no debug enabled
[    3.638637][    T1] 9p: Installing v9fs 9p2000 file system support
[    3.641019][    T1] NILFS version 2 loaded
[    3.641796][    T1] befs: version: 0.9.3
[    3.643277][    T1] ocfs2: Registered cluster interface o2cb
[    3.645240][    T1] ocfs2: Registered cluster interface user
[    3.646934][    T1] OCFS2 User DLM kernel interface loaded
[    3.669685][    T1] gfs2: GFS2 installed
[    3.684713][    T1] ceph: loaded (mds proto 32)
[    3.699225][    T1] NET: Registered PF_ALG protocol family
[    3.701213][    T1] async_tx: api initialized (async)
[    3.702013][    T1] Key type asymmetric registered
[    3.702812][    T1] Asymmetric key parser 'x509' registered
[    3.703725][    T1] Asymmetric key parser 'pkcs8' registered
[    3.704729][    T1] Key type pkcs7_test registered
[    3.706869][    T1] Block layer SCSI generic (bsg) driver version 0.4 lo=
aded (major 239)
[    3.709629][    T1] io scheduler mq-deadline registered
[    3.710514][    T1] io scheduler kyber registered
[    3.711663][    T1] io scheduler bfq registered
[    3.713717][    T1] raid6: skipped pq benchmark and selected avx512x4
[    3.734548][    T1] input: Power Button as /devices/platform/LNXPWRBN:00=
/input/input0
[    3.738269][    T1] ACPI: button: Power Button [PWRF]
[    3.742091][    T1] input: Sleep Button as /devices/platform/LNXSLPBN:00=
/input/input1
[    3.744908][    T1] ACPI: button: Sleep Button [SLPF]
[    3.747251][  T164] kworker/u8:3 (164) used greatest stack depth: 26904 =
bytes left
[    3.764689][    T1] ioatdma: Intel(R) QuickData Technology Driver 5.00
[    3.797287][    T1] ACPI: \_SB_.LNKC: Enabled at IRQ 11
[    3.798540][    T1] virtio-pci 0000:00:03.0: virtio_pci: leaving for leg=
acy driver
[    3.834047][    T1] ACPI: \_SB_.LNKD: Enabled at IRQ 10
[    3.835198][    T1] virtio-pci 0000:00:04.0: virtio_pci: leaving for leg=
acy driver
[    3.870818][    T1] ACPI: \_SB_.LNKB: Enabled at IRQ 10
[    3.871873][    T1] virtio-pci 0000:00:06.0: virtio_pci: leaving for leg=
acy driver
[    4.463531][    T1] N_HDLC line discipline registered with maxframe=3D40=
96
[    4.466143][    T1] Serial: 8250/16550 driver, 4 ports, IRQ sharing enab=
led
[    4.477632][    T1] 00:02: ttyS0 I/O:0x3f8 (irq =3D 4, base_baud =3D 115=
200) is a 16550A
[    4.494957][    T1] 00:03: ttyS1 I/O:0x2f8 (irq =3D 3, base_baud =3D 115=
200) is a 16550A
[    4.512363][    T1] 00:04: ttyS2 I/O:0x3e8 (irq =3D 6, base_baud =3D 115=
200) is a 16550A
[    4.527464][    T1] 00:05: ttyS3 I/O:0x2e8 (irq =3D 7, base_baud =3D 115=
200) is a 16550A
[    4.558586][    T1] Non-volatile memory driver v1.3
[    4.578432][    T1] usbcore: registered new interface driver xillyusb
[    4.584967][    T1] ACPI: bus type drm_connector registered
[    4.593877][    T1] [drm] Initialized vgem 1.0.0 for vgem on minor 0
[    4.601531][    T1] ------------[ cut here ]------------
[    4.601561][    T1] [PLANE:35:plane-0] pixel format with alpha exposed b=
ut blend mode not setup
[    4.601579][    T1] WARNING: drivers/gpu/drm/drm_mode_config.c:872 at dr=
m_mode_config_validate+0xfb4/0x1be0, CPU#1: swapper/0/1
[    4.605357][    T1] Modules linked in:
[    4.605941][    T1] CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted syz=
kaller #0 PREEMPT(full)=20
[    4.607286][    T1] Hardware name: Google Google Compute Engine/Google C=
ompute Engine, BIOS Google 08/05/2026
[    4.608865][    T1] RIP: 0010:drm_mode_config_validate+0xfbb/0x1be0
[    4.610255][    T1] Code: 00 49 8b 57 18 48 89 f8 48 c1 e8 03 0f b6 04 2=
8 84 c0 74 08 3c 03 0f 8e 00 0b 00 00 48 8d 3d 5c 1f 7e 0b 41 8b b7 c8 00 0=
0 00 <67> 48 0f b9 3a e9 fa fd ff ff 48 8b 5c 24 20 e8 d1 aa 39 fc 48 8d
[    4.613458][    T1] RSP: 0000:ffffc90000067c18 EFLAGS: 00010246
[    4.614327][    T1] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000=
0000000000000
[    4.615493][    T1] RDX: ffff888027a14860 RSI: 0000000000000023 RDI: fff=
fffff91504ba0
[    4.616662][    T1] RBP: dffffc0000000000 R08: 0000000000000001 R09: 000=
0000000000000
[    4.617843][    T1] R10: 0000000000000001 R11: 0000000000000000 R12: fff=
fed1004f77623
[    4.619247][    T1] R13: ffffed1004f77624 R14: 0000000000000001 R15: fff=
f888027bbb028
[    4.620935][    T1] FS:  0000000000000000(0000) GS:ffff888123c65000(0000=
) knlGS:0000000000000000
[    4.622254][    T1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.623267][    T1] CR2: 0000000000000000 CR3: 000000000eb96000 CR4: 000=
00000003526f0
[    4.624414][    T1] Call Trace:
[    4.624912][    T1]  <TASK>
[    4.625427][    T1]  drm_dev_register+0x56e/0x7b0
[    4.626244][    T1]  vkms_create+0x491/0x5b0
[    4.627147][    T1]  ? __pfx_vkms_init+0x10/0x10
[    4.627983][    T1]  vkms_init+0x98/0xe0
[    4.628641][    T1]  do_one_initcall+0x11c/0x6f0
[    4.629391][    T1]  ? __pfx_do_one_initcall+0x10/0x10
[    4.630294][    T1]  ? kernel_init_freeable+0x4ca/0x7b0
[    4.631363][    T1]  kernel_init_freeable+0x6ea/0x7b0
[    4.632148][    T1]  ? __pfx_kernel_init+0x10/0x10
[    4.632889][    T1]  kernel_init+0x21/0x1e0
[    4.633551][    T1]  ? __pfx_kernel_init+0x10/0x10
[    4.634383][    T1]  ret_from_fork+0x730/0xd60
[    4.635179][    T1]  ? __pfx_ret_from_fork+0x10/0x10
[    4.635928][    T1]  ? __switch_to+0x800/0x10f0
[    4.636696][    T1]  ? __pfx_kernel_init+0x10/0x10
[    4.637489][    T1]  ret_from_fork_asm+0x1a/0x30
[    4.638367][    T1]  </TASK>
[    4.638850][    T1] Kernel panic - not syncing: kernel: panic_on_warn se=
t ...
[    4.640061][    T1] CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted syz=
kaller #0 PREEMPT(full)=20
[    4.640168][    T1] Hardware name: Google Google Compute Engine/Google C=
ompute Engine, BIOS Google 08/05/2026
[    4.640168][    T1] Call Trace:
[    4.640168][    T1]  <TASK>
[    4.640168][    T1]  dump_stack_lvl+0x100/0x190
[    4.640168][    T1]  vpanic+0x553/0x970
[    4.640168][    T1]  ? __pfx_vpanic+0x10/0x10
[    4.640168][    T1]  panic+0xd1/0xe0
[    4.640168][    T1]  ? __pfx_panic+0x10/0x10
[    4.640168][    T1]  check_panic_on_warn.cold+0x19/0x34
[    4.640168][    T1]  ? drm_mode_config_validate+0xfb4/0x1be0
[    4.640168][    T1]  __warn.cold+0x191/0x318
[    4.640168][    T1]  __report_bug+0x30f/0x440
[    4.640168][    T1]  ? drm_mode_config_validate+0xfb4/0x1be0
[    4.640168][    T1]  ? __pfx___report_bug+0x10/0x10
[    4.640168][    T1]  ? reacquire_held_locks+0xdd/0x1f0
[    4.640168][    T1]  report_bug_entry+0xe2/0x290
[    4.640168][    T1]  ? drm_mode_config_validate+0xfbb/0x1be0
[    4.640168][    T1]  handle_bug+0x1cd/0x2a0
[    4.640168][    T1]  exc_invalid_op+0x17/0x50
[    4.640168][    T1]  asm_exc_invalid_op+0x1a/0x20
[    4.640168][    T1] RIP: 0010:drm_mode_config_validate+0xfbb/0x1be0
[    4.640168][    T1] Code: 00 49 8b 57 18 48 89 f8 48 c1 e8 03 0f b6 04 2=
8 84 c0 74 08 3c 03 0f 8e 00 0b 00 00 48 8d 3d 5c 1f 7e 0b 41 8b b7 c8 00 0=
0 00 <67> 48 0f b9 3a e9 fa fd ff ff 48 8b 5c 24 20 e8 d1 aa 39 fc 48 8d
[    4.640168][    T1] RSP: 0000:ffffc90000067c18 EFLAGS: 00010246
[    4.640168][    T1] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000=
0000000000000
[    4.640168][    T1] RDX: ffff888027a14860 RSI: 0000000000000023 RDI: fff=
fffff91504ba0
[    4.640168][    T1] RBP: dffffc0000000000 R08: 0000000000000001 R09: 000=
0000000000000
[    4.640168][    T1] R10: 0000000000000001 R11: 0000000000000000 R12: fff=
fed1004f77623
[    4.640168][    T1] R13: ffffed1004f77624 R14: 0000000000000001 R15: fff=
f888027bbb028
[    4.640168][    T1]  ? drm_mode_config_validate+0xf76/0x1be0
[    4.640168][    T1]  drm_dev_register+0x56e/0x7b0
[    4.640168][    T1]  vkms_create+0x491/0x5b0
[    4.640168][    T1]  ? __pfx_vkms_init+0x10/0x10
[    4.640168][    T1]  vkms_init+0x98/0xe0
[    4.640168][    T1]  do_one_initcall+0x11c/0x6f0
[    4.640168][    T1]  ? __pfx_do_one_initcall+0x10/0x10
[    4.640168][    T1]  ? kernel_init_freeable+0x4ca/0x7b0
[    4.640168][    T1]  kernel_init_freeable+0x6ea/0x7b0
[    4.640168][    T1]  ? __pfx_kernel_init+0x10/0x10
[    4.640168][    T1]  kernel_init+0x21/0x1e0
[    4.640168][    T1]  ? __pfx_kernel_init+0x10/0x10
[    4.640168][    T1]  ret_from_fork+0x730/0xd60
[    4.640168][    T1]  ? __pfx_ret_from_fork+0x10/0x10
[    4.640168][    T1]  ? __switch_to+0x800/0x10f0
[    4.640168][    T1]  ? __pfx_kernel_init+0x10/0x10
[    4.640168][    T1]  ret_from_fork_asm+0x1a/0x30
[    4.640168][    T1]  </TASK>
[    4.640168][    T1] Kernel Offset: disabled
[    4.640168][    T1] Rebooting in 86400 seconds..


syzkaller build log:
go env (err=3D<nil>)
AR=3D'ar'
CC=3D'gcc'
CGO_CFLAGS=3D'-O2 -g'
CGO_CPPFLAGS=3D''
CGO_CXXFLAGS=3D'-O2 -g'
CGO_ENABLED=3D'1'
CGO_FFLAGS=3D'-O2 -g'
CGO_LDFLAGS=3D'-O2 -g'
CXX=3D'g++'
GCCGO=3D'gccgo'
GO111MODULE=3D'auto'
GOAMD64=3D'v1'
GOARCH=3D'amd64'
GOAUTH=3D'netrc'
GOBIN=3D''
GOCACHE=3D'/syzkaller/.cache/go-build'
GOCACHEPROG=3D''
GODEBUG=3D''
GOENV=3D'/syzkaller/.config/go/env'
GOEXE=3D''
GOEXPERIMENT=3D''
GOFIPS140=3D'off'
GOFLAGS=3D''
GOGCCFLAGS=3D'-fPIC -m64 -pthread -Wl,--no-gc-sections -fmessage-length=3D0=
 -ffile-prefix-map=3D/tmp/go-build2916329939=3D/tmp/go-build -gno-record-gc=
c-switches'
GOHOSTARCH=3D'amd64'
GOHOSTOS=3D'linux'
GOINSECURE=3D''
GOMOD=3D'/syzkaller/jobs-2/linux/gopath/src/github.com/google/syzkaller/go.=
mod'
GOMODCACHE=3D'/syzkaller/jobs-2/linux/gopath/pkg/mod'
GONOPROXY=3D''
GONOSUMDB=3D''
GOOS=3D'linux'
GOPATH=3D'/syzkaller/jobs-2/linux/gopath'
GOPRIVATE=3D''
GOPROXY=3D'https://proxy.golang.org,direct'
GOROOT=3D'/usr/local/go'
GOSUMDB=3D'sum.golang.org'
GOTELEMETRY=3D'local'
GOTELEMETRYDIR=3D'/syzkaller/.config/go/telemetry'
GOTMPDIR=3D''
GOTOOLCHAIN=3D'auto'
GOTOOLDIR=3D'/usr/local/go/pkg/tool/linux_amd64'
GOVCS=3D''
GOVERSION=3D'go1.26.0'
GOWORK=3D''
PKG_CONFIG=3D'pkg-config'

git status (err=3D<nil>)
HEAD detached at 4cb2b096987
nothing to commit, working tree clean


tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
go list -f '{{.Stale}}' -ldflags=3D"-s -w -X github.com/google/syzkaller/pr=
og.GitRevision=3D4cb2b096987c8122dc6b37eb51200b1ca7991e0f -X github.com/goo=
gle/syzkaller/prog.gitRevisionDate=3D20260727-130118"  ./sys/syz-sysgen | g=
rep -q false || go install -ldflags=3D"-s -w -X github.com/google/syzkaller=
/prog.GitRevision=3D4cb2b096987c8122dc6b37eb51200b1ca7991e0f -X github.com/=
google/syzkaller/prog.gitRevisionDate=3D20260727-130118"  ./sys/syz-sysgen
make .descriptions
tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
bin/syz-sysgen
touch .descriptions
GOOS=3Dlinux GOARCH=3Damd64 go build -ldflags=3D"-s -w -X github.com/google=
/syzkaller/prog.GitRevision=3D4cb2b096987c8122dc6b37eb51200b1ca7991e0f -X g=
ithub.com/google/syzkaller/prog.gitRevisionDate=3D20260727-130118"  -o ./bi=
n/linux_amd64/syz-execprog github.com/google/syzkaller/tools/syz-execprog
mkdir -p ./bin/linux_amd64
g++ -o ./bin/linux_amd64/syz-executor executor/executor.cc \
	-m64 -O2 -pthread -Wall -Werror -Wparentheses -Wunused-const-variable -Wfr=
ame-larger-than=3D16384 -Wno-stringop-overflow -Wno-array-bounds -Wno-forma=
t-overflow -Wno-unused-but-set-variable -Wno-unused-command-line-argument -=
static-pie -std=3Dc++17 -I. -Iexecutor/_include   -DGOOS_linux=3D1 -DGOARCH=
_amd64=3D1 \
	-DHOSTGOOS_linux=3D1 -DGIT_REVISION=3D\"4cb2b096987c8122dc6b37eb51200b1ca7=
991e0f\"
/usr/bin/ld: /tmp/ccr3LZX8.o: in function `Connection::Connect(char const*,=
 char const*)':
executor.cc:(.text._ZN10Connection7ConnectEPKcS1_[_ZN10Connection7ConnectEP=
KcS1_]+0x386): warning: Using 'gethostbyname' in statically linked applicat=
ions requires at runtime the shared libraries from the glibc version used f=
or linking
./tools/check-syzos.sh 2>/dev/null


Error text is too large and was truncated, full error text is at:
https://syzkaller.appspot.com/x/error.txt?x=3D1421d379580000


Tested on:

commit:         a8455260 ipvlan: unregister upper devices outside pnod..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.gi=
t
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D9cc692b98d9b4fd=
b
dashboard link: https://syzkaller.appspot.com/bug?extid=3D8785aaf121cfb2141=
e0d
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Deb=
ian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=3D13ffec155800=
00


