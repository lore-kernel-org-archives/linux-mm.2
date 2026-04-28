Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D20DDFF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 16:10:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD52C6B0088; Tue, 28 Apr 2026 12:10:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D855F6B008A; Tue, 28 Apr 2026 12:10:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4DCB6B008C; Tue, 28 Apr 2026 12:10:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A67C56B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 12:10:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3FDAA1603D4
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:10:34 +0000 (UTC)
X-FDA: 84708452388.10.67399E2
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id 512E8A000B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:10:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=baylibre-com.20251104.gappssmtp.com header.s=20251104 header.b="VA/NVNtv";
	spf=pass (imf15.hostedemail.com: domain of aarsenovic@baylibre.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=aarsenovic@baylibre.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777392632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lbYXahYntczB/nVPrXvhc75mV1wHarTG89Ji2kiWuwc=;
	b=sBAlAHSVJuZXen8ZIBlidhlOv6W5t7SaavluCcEdYuPBJ/V0C27eEWOLxWv8aQN0OJxYHP
	DsuHaZhbhsPaovBpKtO+1EBiFjsPUwgcsGX5aseSFMtq2VX0QqnQDtgW1huHMCszqhimOk
	PxdbpZq3zJIOZ1aSi7Uom0w5qqiiT4k=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=baylibre-com.20251104.gappssmtp.com header.s=20251104 header.b="VA/NVNtv";
	spf=pass (imf15.hostedemail.com: domain of aarsenovic@baylibre.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=aarsenovic@baylibre.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777392632; a=rsa-sha256;
	cv=none;
	b=llFK573V8G3P3KNyhUxjKPJOmwhUoN10NLf217YF84gG7cIl8347eW1i+3a6WfIqXEfhrR
	oDS/cwWi1HkCLZ6N/M5KnITTd7ajJkXizVVRBqwlPVkpKQi9ZWoKCWf0ibdm0daNfPcCQB
	pyoGKUoMt0eTqmd4dpcJEdtKRmIfPqo=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so198623895e9.2
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20251104.gappssmtp.com; s=20251104; t=1777392629; x=1777997429; darn=kvack.org;
        h=mime-version:message-id:date:user-agent:organization:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=lbYXahYntczB/nVPrXvhc75mV1wHarTG89Ji2kiWuwc=;
        b=VA/NVNtvQ7LAHgmqXZFc755WP3WrvZPadRPteIj9wdrMOxCxhqX9fbGoL1YlsG+DWe
         HYfYv1aPGdeX714enbZJC5DSUFQk2GzEjVz3JDQ6t9bnQQA00gdHFYIfBNLQXzBYVkRA
         OzyHM7daQvL61bbTCefgwWOtmjKsPNdHoxhZRgAJbw42kAekQrDqo81xzABjbffHF6+T
         5U6gOytBDRUSRZWCa5yQLmt8v55bY/iD6JUN/lV99mCY8lf9rMVRj5+76QsJNNMzwpqK
         hWD6Q3coKuoZOHJFkwUy/5J065zHnOxYR6a1xPZLoqs5+dbPr0DM8D6Cl37iCfFkAbPp
         pEtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777392629; x=1777997429;
        h=mime-version:message-id:date:user-agent:organization:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lbYXahYntczB/nVPrXvhc75mV1wHarTG89Ji2kiWuwc=;
        b=MFzs6TgDk/sKJD4oiTmbhzcD8nzSm9yTLCtNFx1NK7qUwUDGCYLMyXPkaDE/SRD1oL
         /tb3PrRtp3WXxzW/5y9Po+7sQSepV8b2e1fC8lnjMzTSSuYZVGkufUU0nqqCk56VhA06
         4t5qKu5Dh5+FMvnWHbfjJv/vRTcD1PZheJAG0aBSqxxNISS0aWgxqpwgFThf7raSZHh4
         vNT6fl9uDuAaMP9SvAbjPH+ZhZIlUpC3KcEtDJn/HtG3A41UtakTptFRgVECkG5pGwyl
         aXht07JvC8S2LiKBgMg2TPi7SKxceYcTFPq+VxdSYnItSniMPziKLTGtaJRpy7Q5X7tt
         fAng==
X-Gm-Message-State: AOJu0YwhtvEhY+QCm0cC/iWfUD4NUkakbtxE88qqUdIoP+66iW5QsxW3
	n805RXmvCQ3axBL/nNeR0SCuMT3t05cN498qIaS7WvDmmrpp4XxXGQXn7+9bXq3Jx7DcdLNgOFB
	7njh7xlw=
X-Gm-Gg: AeBDievtECXf/CgOCe8ExYNnCQPYoY54oVgTE/REwCBCxY6HXizJvw3vfucNAsXBMKS
	oVldlNJRPvYf6vRDdEPwSE/mNtWQVl87E++T+XbYYRnzI/8XzwjhBxh2s5LeE9Nef92BMdJ3eh1
	BmLnAqC6q6BiWLD0ImUUpl+STc11SG39eWVK9WCX5g+Fm9N25eKiHqVblqXl0Bf2juC9/wkkvYl
	7v2vLl7ERk/nX6J7iF9pHH7pyZQqpzoSai8h6e+e8KErkGa85QfyDEeGptHGG6V6uniFnrytjMQ
	+uke86sHAfrG/DkB73hnPwJgEr8hf2wKjDL2FwMNhSM6a4dHRlFpwd2Dt+eC7WlIC4hwxr/Q52b
	H/g6/TGkXegW0u6STSJ1YP+xiaFBYem2AMVWfdTipacB4FgQNgMJpOXvl42Mlce3vovPHS+GCU7
	4scMc0a7xiUDjUZwLPkXB0Nu9kryMsXD2CTnATq4o=
X-Received: by 2002:a05:600c:3e1a:b0:488:9439:881a with SMTP id 5b1f17b1804b1-48a7b512505mr5103855e9.2.1777392628687;
        Tue, 28 Apr 2026 09:10:28 -0700 (PDT)
Received: from bstg ([146.70.193.12])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4463f4c0b0dsm7947602f8f.23.2026.04.28.09.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 09:10:27 -0700 (PDT)
From: =?utf-8?Q?Arsen_Arsenovi=C4=87?= <aarsenovic@baylibre.com>
To: linux-mm@kvack.org, amd-gfx@lists.freedesktop.org
Cc: cs-tech-ext@baylibre.com
Subject: [BUG] Frequent hangs or WARNINGs when using heterogeneous memory
 with an AMD MI210 GPU
Organization: BayLibre
User-Agent: mu4e 1.14.0; emacs 31.0.50
Date: Tue, 28 Apr 2026 18:10:24 +0200
Message-ID: <86ecjz2hhr.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 512E8A000B
X-Stat-Signature: u3znqqj63feryehcyawuniscbxc7pxjw
X-HE-Tag: 1777392631-168634
X-HE-Meta: U2FsdGVkX1/+J7b8yrwL3jZp3FgY7NjoWBPG4PE1K4+Y6/hZwRn5Jy89h26K5vaGcT/D5dI4D//p7+5+hCfULKKDt++kPX1EZZcuueVrCPgC7FPsQLgu+uLCo2WYTkpfcxtfPCQn/oEK+TNHxXPpYF6iAxrcfoiB5MXNoISZL4jv1tcgY2drjhkEYewulOWqyaiaRYLW3ZGWml5nAj7SiWlqo+EsbphVEH8AkkW3G2VUPzXwT5BgORRm9sLHH0NkpZzQWnjxHJAl0Z4kGT9WaH4CLmnSqLcem8QHBe0VEKfFniFk0X31FinIbS024/tD31yWDM9/YFdpYV6tOtCPm4Ri9aO5tzBy5YUCUrxYLLy83Mi2zF5MYOwh6PkBKofTQACuE1QULIWCLNkrEuPHwZL4JzxRHRhlzHMr0DKMzV+wBeE5PUYijFa/Bhqq97VF+sloB0GfSIeHekFg/KOIPn3fW+c+rkpI+yyDma3/r3K+HcaG7iZ/mB+ihOAUIwUPaEIyYL/aQoq7VgwxZJzaJst+xA6zairQx1gN2cVsHaTrDlFgGkfjoM+D/xF0PbP+icwYVLjLU8XcWZG7Rt2kyQtkuqZfF4WTc5drWKlxmBCM2YCwRROwdS8fqM76dLPeYYB6HYulQCDcCuigMJM92a8yfuYsJmY3tZw9uW9jn/w3PjtjMGqGwpvZqhWNgh4W0mHK1S0NZtzC56ZJhuDmB7Kf18RkP3iJ0SnnpFMeZFb5L8NtxkRKd+34dPTFj65V13r1PUL8tngWxtEscORPLeVy5jeJmlIg7s0iiogblMxQjkP7Mk6u51emsWpY7ZrGpECGcbDpjzGAN/gCBlLgUuBd6lUUJ6fXva63OJEdzdOq0r+emf5sOv2TF9Fbc4Vp7T08QPaRkvMj/v5XnEuxSVhvMdVnBFJUlfPEGCqh28Qdkib3lyTvu+vdDl6IltpR852efXHLjSJQPYzvllU
 X6xdfUkA
 okuHKK457Kq21YTAJpA440MDyNoxhVTfmVuc00+vYLEibA5mzG0tr4bd2oc1cbCIkI44adIiKU9hft/Zn263FcOmxt1Z7e8uSu5NHOo4x6HFiDkPlRIZ0zVRU6S0rZqcpkEZhYV5HYDs5cQ+X+/SpHg8UCMa8o0h+tzJtQ5RlcIiY9MVwjjjfnk5TbIjLwvPi595TPwPCbH/zBFsXtDaVY1u7VN+UlJCLsVfFp8JHWl+fe6Uz7qwHAdJN/gCg+Q1pHMgHxjriH4gZ06qF8Wozcq/dTgpigzKOrLB4UbgrXm/JgsrGxdwU5El923dMC6Ljlmkm/WL1sE+7ybVHTuKWDIdhIWcnB3d549bPG3wBqkDMdT7pK5ddTOsKknTco6w9eA6MbS6e9mlGRHMtVFGIGNbLjSUX20q/OFO6pjlk+OAIGj0O8kyHpyZFdYGtduOe6z/uY0JlvCsGFn3vHa/Wk7IHWru1NSjrR3yQlH7WftQx7o4+igyGJKY4Anv/Zedt4cS2H4bpdxloLABXPeve07THmIaURdyYg/ibJVstDzl813IwZ+D1hCShHw50W52/DGW5q7UjeeG6+GBBiX0gm4XrDjFvQy2ht1jdHaOP9qisVP/S5JWNpyKVcNS281F6XRngMYEjSypqer9l+gbs0GYuMQsrP9FR3vG/BtebwDsmtMwqt+pphQzbxDbpMlCa2aAD9n91cKOF+35A8au6x4oyU4zlCxpJPDUqlkgweomprLn9Y2zFVl4WTGpWnFQRpP9bkbhevpzYvmQZ3Un2JBvV97RoqBNr2W+bAHQOcR+WnC+G730FH7UyBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi!

We work on AMD GPU offloading support in GCC, and, each week, we run a
bunch of OpenMP and OpenACC testsuites, as well as the GCC testsuite, as
well as some benchmarks, to track implementation status.  Occasional CI
instabilities have been hunting us for ~a year, but it only lately
started happening reliably enough not to be a fluke.

Using an AMD Instinct MI210 GPU inside a kvm+qemu virtual machine fails
regularly, yielding either a hard crash or unkillable processes with
kernel messages such as:

  WARNING: mm/memory.c:1753 at unmap_page_range
  BUG: soft lockup - CPU#131 stuck for 104s! [qemu-system-x86:2702946]
  BUG: Bad page state in process check_ps.bash=C2=A0 pfn:10b19b

The hypervisor is running Ubuntu 22.04.5, Linux 6.8.0-110-generic (but,
a distro kernel, I fear).  We have two of such hypervisors, each running
one VM with one MI210 card.  They seem to behave, overall, largely
identically.  The VMs were running a variety of kernel versions, noted
below.

Below, I've described each unique issue we were seeing.  Many of these
are likely the same bug, but since they happened in different kernel
versions, I included all of them.

I'll start with the most recent issue we've seen.  For this one, we have
a concise and reliable reproducer.

We've started seeing the following bugsplats in dmesg (vanilla build of
v7.0.1, local version string set to -arsen, plus AMD ROCm 7.2.2):

  [  414.738977] ------------[ cut here ]------------
  [  414.741303] WARNING: mm/memory.c:1753 at unmap_page_range+0x15f7/0x1dc=
0, CPU#1: a.out/1908
  [  414.745054] Modules linked in: binfmt_misc intel_rapl_msr intel_rapl_c=
ommon nls_iso8859_1 kvm_amd ccp kvm irqbypass input_leds joydev serio_raw m=
ac_hid qemu_fw_cfg dm_multipath sch_fq_codel scsi_dh_rdac scsi_dh_emc scsi_=
dh_alua efi_pstore ip_tables x_tables autofs4 btrfs libblake2b raid10 raid4=
56 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq =
raid1 raid0 linear amdgpu hid_generic amdxcp i2c_algo_bit drm_ttm_helper tt=
m drm_exec drm_panel_backlight_quirks gpu_sched vga16fb drm_suballoc_helper=
 ghash_clmulni_intel video vgastate wmi drm_buddy drm_display_helper usbhid=
 cec ahci psmouse hid i2c_i801 libahci i2c_smbus rc_core lpc_ich bochs aesn=
i_intel
  [  414.775692] CPU: 1 UID: 1267 PID: 1908 Comm: a.out Not tainted 7.0.1-a=
rsen #1 PREEMPT(lazy)
  [  414.780160] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1=
.15.0-1 04/01/2014
  [  414.784479] RIP: 0010:unmap_page_range+0x15f7/0x1dc0
  [  414.786765] Code: ff f6 80 a3 0a 00 00 08 b8 00 00 00 c0 48 0f 44 c2 4=
9 89 46 10 49 c7 46 18 00 00 00 00 e9 20 f4 ff ff 8b 43 50 e9 39 f8 ff ff <=
0f> 0b e9 ab f7 ff ff 48 8b 8d 68 ff ff ff 48 8b 95 28 ff ff ff 48
  [  414.794492] RSP: 0018:ffffd4d684c0b998 EFLAGS: 00010282
  [  414.796480] RAX: 0000000000000001 RBX: 0000000000000001 RCX: 000000000=
0000000
  [  414.798116] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff8e545=
ead96c0
  [  414.799961] RBP: ffffd4d684c0bac0 R08: 0000000000000000 R09: 000000000=
0000000
  [  414.801994] R10: 0000000000000000 R11: 0000000000000000 R12: effff8000=
024ac02
  [  414.803602] R13: fffff7247ffb6a40 R14: fffff7247ffb6a40 R15: ffffd4d68=
4c0bc20
  [  414.805156] FS:  0000000000000000(0000) GS:ffff8e56ac0e1000(0000) knlG=
S:0000000000000000
  [  414.806906] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [  414.808185] CR2: 0000735ef4001058 CR3: 000000013e2ab004 CR4: 000000000=
0770ef0
  [  414.809762] PKRU: 55555554
  [  414.810396] Call Trace:
  [  414.811002]  <TASK>
  [  414.811500]  ? srso_alias_return_thunk+0x5/0xfbef5
  [  414.812678]  unmap_single_vma+0x7d/0xd0
  [  414.813552]  unmap_vmas+0x88/0x160
  [  414.814403]  exit_mmap+0x127/0x400
  [  414.815363]  ? __entry_text_end+0x102539/0x10253d
  [  414.816653]  __mmput+0x52/0x140
  [  414.817468]  mmput+0x34/0x50
  [  414.818330]  do_exit+0x28e/0xb30
  [  414.819155]  do_group_exit+0x34/0x90
  [  414.820045]  get_signal+0xa3a/0xa90
  [  414.820911]  ? srso_alias_return_thunk+0x5/0xfbef5
  [  414.822061]  ? kfd_ioctl+0x492/0x570 [amdgpu]
  [  414.823459]  ? __pfx_kfd_ioctl_wait_events+0x10/0x10 [amdgpu]
  [  414.825004]  arch_do_signal_or_restart+0x2e/0x220
  [  414.826062]  ? srso_alias_return_thunk+0x5/0xfbef5
  [  414.827137]  ? srso_alias_return_thunk+0x5/0xfbef5
  [  414.828224]  exit_to_user_mode_loop+0xb5/0x510
  [  414.829232]  do_syscall_64+0x289/0x1490
  [  414.830115]  ? srso_alias_return_thunk+0x5/0xfbef5
  [  414.831202]  ? exc_page_fault+0x94/0x1c0
  [  414.832369]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
  [  414.833744] RIP: 0033:0x735efb31a9cf
  [  414.834787] Code: Unable to access opcode bytes at 0x735efb31a9a5.
  [  414.836456] RSP: 002b:0000735efa7feb40 EFLAGS: 00000246 ORIG_RAX: 0000=
000000000010
  [  414.838670] RAX: fffffffffffffffc RBX: 0000000000000003 RCX: 0000735ef=
b31a9cf
  [  414.840564] RDX: 0000735efa7fec10 RSI: 00000000c0184b0c RDI: 000000000=
0000003
  [  414.842649] RBP: 00000000c0184b0c R08: 0000000000000003 R09: 0000735ef=
4001060
  [  414.844574] R10: 0000000000004022 R11: 0000000000000246 R12: 0000735ef=
4000bf0
  [  414.846723] R13: 0000735efa7fec10 R14: 0000735ef4000b90 R15: 0000735ef=
4001060
  [  414.848930]  </TASK>
  [  414.849862] Kernel panic - not syncing: kernel: panic_on_warn set ...
  [  414.853035] CPU: 1 UID: 1267 PID: 1908 Comm: a.out Not tainted 7.0.1-a=
rsen #1 PREEMPT(lazy)
  [  414.856998] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1=
.15.0-1 04/01/2014
  [  414.859468] Call Trace:
  [  414.860136]  <TASK>
  [  414.860728]  dump_stack_lvl+0x27/0xa0
  [  414.861701]  dump_stack+0x10/0x20
  [  414.862567]  vpanic+0x4cf/0x540
  [  414.863357]  ? unmap_page_range+0x15f7/0x1dc0
  [  414.864364]  panic+0x57/0x60
  [  414.865019]  check_panic_on_warn+0x4f/0x60
  [  414.866042]  __warn+0xa3/0x1b0
  [  414.866884]  ? unmap_page_range+0x15f7/0x1dc0
  [  414.868026]  __report_bug+0x21b/0x230
  [  414.868936]  ? psi_group_change+0x20a/0x4b0
  [  414.870077]  ? unmap_page_range+0x15f7/0x1dc0
  [  414.871262]  report_bug+0x2c/0xa0
  [  414.872117]  handle_bug+0x141/0x300
  [  414.872896]  exc_invalid_op+0x19/0x80
  [  414.873815]  asm_exc_invalid_op+0x1b/0x20
  [  414.874751] RIP: 0010:unmap_page_range+0x15f7/0x1dc0
  [  414.875864] Code: ff f6 80 a3 0a 00 00 08 b8 00 00 00 c0 48 0f 44 c2 4=
9 89 46 10 49 c7 46 18 00 00 00 00 e9 20 f4 ff ff 8b 43 50 e9 39 f8 ff ff <=
0f> 0b e9 ab f7 ff ff 48 8b 8d 68 ff ff ff 48 8b 95 28 ff ff ff 48
  [  414.879820] RSP: 0018:ffffd4d684c0b998 EFLAGS: 00010282
  [  414.880956] RAX: 0000000000000001 RBX: 0000000000000001 RCX: 000000000=
0000000
  [  414.882487] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff8e545=
ead96c0
  [  414.884033] RBP: ffffd4d684c0bac0 R08: 0000000000000000 R09: 000000000=
0000000
  [  414.885579] R10: 0000000000000000 R11: 0000000000000000 R12: effff8000=
024ac02
  [  414.887102] R13: fffff7247ffb6a40 R14: fffff7247ffb6a40 R15: ffffd4d68=
4c0bc20
  [  414.889647]  ? unmap_page_range+0xc48/0x1dc0
  [  414.890570]  ? srso_alias_return_thunk+0x5/0xfbef5
  [  414.891897]  unmap_single_vma+0x7d/0xd0
  [  414.892742]  unmap_vmas+0x88/0x160
  [  414.893578]  exit_mmap+0x127/0x400
  [  414.894473]  ? __entry_text_end+0x102539/0x10253d
  [  414.895711]  __mmput+0x52/0x140
  [  414.896422]  mmput+0x34/0x50
  [  414.897142]  do_exit+0x28e/0xb30
  [  414.897870]  do_group_exit+0x34/0x90
  [  414.898729]  get_signal+0xa3a/0xa90
  [  414.899586]  ? srso_alias_return_thunk+0x5/0xfbef5
  [  414.900628]  ? kfd_ioctl+0x492/0x570 [amdgpu]
  [  414.901863]  ? __pfx_kfd_ioctl_wait_events+0x10/0x10 [amdgpu]
  [  414.903358]  arch_do_signal_or_restart+0x2e/0x220
  [  414.904385]  ? srso_alias_return_thunk+0x5/0xfbef5
  [  414.905427]  ? srso_alias_return_thunk+0x5/0xfbef5
  [  414.906462]  exit_to_user_mode_loop+0xb5/0x510
  [  414.907437]  do_syscall_64+0x289/0x1490
  [  414.908288]  ? srso_alias_return_thunk+0x5/0xfbef5
  [  414.909325]  ? exc_page_fault+0x94/0x1c0
  [  414.910189]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
  [  414.911299] RIP: 0033:0x735efb31a9cf
  [  414.912183] Code: Unable to access opcode bytes at 0x735efb31a9a5.
  [  414.913528] RSP: 002b:0000735efa7feb40 EFLAGS: 00000246 ORIG_RAX: 0000=
000000000010
  [  414.915463] RAX: fffffffffffffffc RBX: 0000000000000003 RCX: 0000735ef=
b31a9cf
  [  414.917221] RDX: 0000735efa7fec10 RSI: 00000000c0184b0c RDI: 000000000=
0000003
  [  414.918969] RBP: 00000000c0184b0c R08: 0000000000000003 R09: 0000735ef=
4001060
  [  414.920628] R10: 0000000000004022 R11: 0000000000000246 R12: 0000735ef=
4000bf0
  [  414.922291] R13: 0000735efa7fec10 R14: 0000735ef4000b90 R15: 0000735ef=
4001060
  [  414.923835]  </TASK>
  [  414.924479] Kernel Offset: 0x5c00000 from 0xffffffff81000000 (relocati=
on range: 0xffffffff80000000-0xffffffffbfffffff)
  [  414.928531] ---[ end Kernel panic - not syncing: kernel: panic_on_warn=
 set ... ]---

We get this by running the following OpenMP program built for offloading
onto an AMD GPU:

  https://gcc.gnu.org/cgit/gcc/tree/libgomp/testsuite/libgomp.c++/pr119692-=
1-4.C

... built by:

  x86_64-none-linux-gnu-g++ pr119692-1-4.C -foffload=3D-march=3Dgfx90a \
    -Wl,-rpath,/opt/rocm/lib -fopenmp -O2 \
    -DDEFAULT=3D'defaultmap(firstprivate)' \
    -lm -o ./pr119692-1-4.exe

... using trunk GCC configured for amdgcn-amdhsa offloading[1] and
executed as:

  timeout --verbose 10s env HSA_XNACK=3D1 LD_LIBRARY_PATH=3D. ./pr119692-1-=
4.exe

... when the timeout happens (i.e. the program gets stuck for 10 seconds
and then, when 10 seconds pass, timeout sends a SIGTERM to a.out, and
results in the crash above).

Note that SIGINT has the same effect.

HSA_XNACK=3D1 enables page migration from the CPU to the GPU, i.e. when a
page fault happens on the GPU, it retrieves the page and retries.  It is
required for these bugs to trigger.

The RIP referenced above is:

  (gdb) list *(unmap_page_range+0x15f7)
  0xffffffff81713827 is in unmap_page_range (mm/memory.c:1753).
  1748			 * Both device private/exclusive mappings should only
  1749			 * work with anonymous page so far, so we don't need to
  1750			 * consider uffd-wp bit when zap. For more information,
  1751			 * see zap_install_uffd_wp_if_needed().
  1752			 */
  1753			WARN_ON_ONCE(!vma_is_anonymous(vma));
  1754			rss[mm_counter(folio)]--;
  1755			folio_remove_rmap_pte(folio, page, vma);
  1756			folio_put(folio);
  1757		} else if (softleaf_is_swap(entry)) {
  (gdb)

... and the rest of the trace parses out as:

  $ while read -r addr; do ( addr2line -ipe vmlinux "$addr"; addr2line -ipe=
 ./drivers/gpu/drm/amd/amdgpu/amdgpu.ko "$addr" ) | grep -Fv '??'; done < <=
(wl-paste -n | awk '{ if ($3 !=3D "?") print $3; else print $4; } ' | cut -=
d/ -f 1)
  arch/x86/lib/retpoline.S:221
  scripts/module-common.c:19
  mm/memory.c:2135
  scripts/module-common.c:19
  ./include/linux/hugetlb.h:262
   (inlined by) mm/memory.c:2172
  scripts/module-common.c:19
  ./arch/x86/include/asm/jump_label.h:37
   (inlined by) ./include/linux/mmap_lock.h:47
   (inlined by) ./include/linux/mmap_lock.h:618
   (inlined by) mm/mmap.c:1303
  scripts/module-common.c:19
  scripts/module-common.c:19
  kernel/fork.c:1176
  scripts/module-common.c:19
  kernel/fork.c:1199
  drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c:3175
  ./arch/x86/include/asm/bitops.h:202
   (inlined by) ./arch/x86/include/asm/bitops.h:232
   (inlined by) ./include/asm-generic/bitops/instrumented-non-atomic.h:142
   (inlined by) ./include/linux/thread_info.h:133
   (inlined by) kernel/exit.c:582
   (inlined by) kernel/exit.c:964
  scripts/module-common.c:19
  kernel/exit.c:1100
  scripts/module-common.c:19
  kernel/signal.c:2920
  scripts/module-common.c:19
  arch/x86/lib/retpoline.S:221
  scripts/module-common.c:19
  drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_chardev.c:3434
  drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_chardev.c:892
  ./arch/x86/include/asm/current.h:23
   (inlined by) arch/x86/kernel/signal.c:258
   (inlined by) arch/x86/kernel/signal.c:339
  scripts/module-common.c:19
  arch/x86/lib/retpoline.S:221
  scripts/module-common.c:19
  arch/x86/lib/retpoline.S:221
  scripts/module-common.c:19
  kernel/entry/common.c:66
   (inlined by) kernel/entry/common.c:98
  scripts/module-common.c:19
  ./include/linux/irq-entry-common.h:226
   (inlined by) ./include/linux/irq-entry-common.h:256
   (inlined by) ./include/linux/entry-common.h:325
   (inlined by) arch/x86/entry/syscall_64.c:100
  scripts/module-common.c:19
  arch/x86/lib/retpoline.S:221
  scripts/module-common.c:19
  arch/x86/mm/fault.c:1531
  scripts/module-common.c:19
  arch/x86/entry/entry_64.S:130
  scripts/module-common.c:19
  scripts/module-common.c:19

At time of crash, the program in question is stuck in this loop:

  // https://gcc.gnu.org/cgit/gcc/tree/libgomp/plugin/plugin-gcn.c#n2468
  /* Root signal waits with 1ms timeout.  */
  while (hsa_fns.hsa_signal_wait_acquire_fn (s, HSA_SIGNAL_CONDITION_LT, 1,
					     1000 * 1000,
					     HSA_WAIT_STATE_BLOCKED) !=3D 0)
    {
      console_output (kernel, kernargs, false);
    }
  console_output (kernel, kernargs, true);

Most of the wall time of that loop will be spent in
hsa_signal_wait_acquire, which eventually calls the
AMDKFD_IOC_WAIT_EVENTS ioctl.

I'm not sure if this is an MM issue or an AMDGPU one.

The above-described issue is the latest one we discovered, and the only
one that we can reliably reproduce (I tried only on v7.0, v7.0.1, and
v7.0.2).

Worryingly, after reproducing this bug in a VM, we could see the
following on the host:

  watchdog: BUG: soft lockup - CPU#131 stuck for 104s! [qemu-system-x86:270=
2946]
  Modules linked in: 8021q garp mrp cpuid iptable_raw ip6table_nat ip6table=
_filter ip6_tables xt_iprange xt_LOG nf_log_syslog xt_comment dm_snapshot d=
m_bufio iptable_nat iptable_filter veth vxlan ip6_udp_tunnel udp_tunnel xt_=
policy xt_mark xt_bpf vhost_vsock vmw_vsock_virtio_transport_common vsock v=
fio_pci vfio_pci_core vfio_iommu_type1 vfio iommufd vhost_net vhost vhost_i=
otlb tap nf_conntrack_netlink xt_nat br_netfilter xfrm_user xfrm_algo xt_se=
t ip_set xt_addrtype xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_r=
eject_ipv4 xt_tcpudp nft_compat nft_chain_nat nf_nat nf_conntrack nf_defrag=
_ipv6 nf_defrag_ipv4 nfsv3 nfs netfs overlay bridge stp llc bonding tls bin=
fmt_misc nf_tables nfnetlink intel_rapl_msr intel_rapl_common amd64_edac ed=
ac_mce_amd kvm_amd kvm irqbypass snd_pcm snd_timer rapl snd soundcore wmi_b=
mof pcspkr nls_iso8859_1 ipmi_ssif joydev input_leds ccp ptdma k10temp acpi=
_ipmi ipmi_si ipmi_devintf ipmi_msghandler evbug mac_hid dm_multipath sch_f=
q_codel scsi_dh_rdac scsi_dh_emc scsi_dh_alua
   nfsd auth_rpcgss nfs_acl lockd grace msr efi_pstore sunrpc ip_tables x_t=
ables autofs4 btrfs blake2b_generic raid10 raid456 async_raid6_recov async_=
memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 raid0 hid_g=
eneric usbmouse rndis_host cdc_ether usbhid usbnet hid mii crct10dif_pclmul=
 crc32_pclmul polyval_clmulni polyval_generic ghash_clmulni_intel sha256_ss=
se3 sha1_ssse3 igb ahci libahci dca ast i2c_algo_bit bnxt_en xhci_pci i2c_p=
iix4 xhci_pci_renesas wmi aesni_intel crypto_simd cryptd
  CPU: 131 PID: 2702946 Comm: qemu-system-x86 Tainted: G             L     =
6.8.0-106-generic #106~22.04.1-Ubuntu
  Hardware name: Supermicro AS -4124GS-TNR/H12DSG-O-CPU, BIOS 2.8 01/26/2024
  RIP: 0010:pci_mmcfg_read+0xcb/0x110
  Code: 45 31 c9 e9 72 e0 38 00 4c 01 e8 66 8b 00 0f b7 c0 41 89 04 24 eb c=
9 4c 01 e8 8a 00 0f b6 c0 41 89 04 24 eb bb 4c 01 e8 8b 00 <41> 89 04 24 eb=
 b0 e8 ca 8a 06 ff 41 c7 04 24 ff ff ff ff 48 83 c4
  RSP: 0018:ffffce371646fbf8 EFLAGS: 00000286
  RAX: 00000000ffffffff RBX: 0000000004300000 RCX: 0000000000000ffc
  RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
  RBP: ffffce371646fc28 R08: 0000000000000004 R09: ffffce371646fc4c
  R10: 0000000000000043 R11: ffffffff8e375ff0 R12: ffffce371646fc4c
  R13: 0000000000000ffc R14: 0000000000000000 R15: 0000000000000004
  FS:  0000000000000000(0000) GS:ffff8a2e8cf80000(0000) knlGS:0000000000000=
000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 000071e7b2f10e24 CR3: 0000002dab63c006 CR4: 0000000000f70ef0
  PKRU: 55555554
  Call Trace:
   <TASK>
   pci_read+0x55/0x90
   pci_bus_read_config_dword+0x4a/0x90
   pci_read_config_dword+0x27/0x50
   pci_find_next_ext_capability+0x83/0xe0
   pci_find_ext_capability+0x12/0x20
   pci_restore_vc_state+0x3d/0xb0
   pci_restore_state.part.0+0xf6/0x270
   pci_restore_state+0x1e/0x30
   vfio_pci_core_disable+0x40b/0x4b0 [vfio_pci_core]
   vfio_pci_core_close_device+0x64/0xd0 [vfio_pci_core]
   vfio_df_close+0x5a/0xa0 [vfio]
   vfio_df_group_close+0x37/0x80 [vfio]
   vfio_device_fops_release+0x25/0x50 [vfio]
   __fput+0xa3/0x2e0
   ____fput+0xe/0x20
   task_work_run+0x61/0xa0
   do_exit+0x2be/0x530
   ? srso_alias_return_thunk+0x5/0xfbef5
   ? wake_up_state+0x10/0x20
   do_group_exit+0x35/0x90
   __x64_sys_exit_group+0x18/0x20
   x64_sys_call+0x2001/0x2480
   do_syscall_64+0x81/0x170
   entry_SYSCALL_64_after_hwframe+0x78/0x80
  RIP: 0033:0x71e7b36eac31
  Code: Unable to access opcode bytes at 0x71e7b36eac07.
  RSP: 002b:00007ffc7e7ce018 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
  RAX: ffffffffffffffda RBX: 000071e7b3816a00 RCX: 000071e7b36eac31
  RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
  RBP: 0000000000000000 R08: fffffffffffffb60 R09: 0000000000000000
  R10: 000071e7b360d4d0 R11: 0000000000000246 R12: 000071e7b3816a00
  R13: 0000000000000000 R14: 000071e7b381bee8 R15: 000071e7b381bf00
   </TASK>

(and a few other identical messages by the watchdog)

pci_mmcfg_read+0xcb is:

  Reading symbols from /usr/lib/debug/boot/vmlinux-6.8.0-110-generic...
  (gdb) list *(pci_mmcfg_read+0xcb)
  0xffffffff8217750b is in pci_mmcfg_read (/build/linux-hwe-6.8-q4eBc3/linu=
x-hwe-6.8-6.8.0/arch/x86/include/asm/pci_x86.h:220).

... i.e. https://elixir.bootlin.com/linux/v6.8/source/arch/x86/include/asm/=
pci_x86.h#L220
inlined into: https://elixir.bootlin.com/linux/v6.8/source/arch/x86/pci/mmc=
onfig_64.c#L54

... the rest decodes as:

  pci_read+0x55 =3D \
  .../arch/x86/pci/common.c:65
  pci_bus_read_config_dword+0x4a =3D \
  .../drivers/pci/access.c:68 (discriminator 2)
  pci_read_config_dword+0x27 =3D \
  .../drivers/pci/access.c:574
  pci_find_next_ext_capability+0x83 =3D \
  .../drivers/pci/pci.c:589
  pci_find_ext_capability+0x12 =3D \
  .../drivers/pci/pci.c:614
  pci_restore_vc_state+0x3d =3D \
  .../drivers/pci/vc.c:398
  pci_restore_state.part.0+0xf6 =3D \
  .../drivers/pci/pci.c:1923
  pci_restore_state+0x1e =3D \
  .../drivers/pci/pci.c:1940
  vfio_pci_core_disable+0x40b =3D \
  .../drivers/vfio/pci/vfio_pci_core.c:709
  vfio_pci_core_close_device+0x64 =3D \
  .../drivers/vfio/pci/vfio_pci_core.c:735
  vfio_df_close+0x5a =3D \
  .../drivers/vfio/vfio_main.c:549
  vfio_df_group_close+0x37 =3D \
  .../drivers/vfio/group.c:243
  vfio_device_fops_release+0x25 =3D \
  .../drivers/vfio/vfio_main.c:639
  __fput+0xa3 =3D \
  .../fs/file_table.c:377
  ____fput+0xe =3D \
  .../fs/file_table.c:405
  task_work_run+0x61 =3D \
  .../include/linux/sched.h:1990 (discriminator 1)
  do_exit+0x2be =3D \
  .../kernel/exit.c:884
  srso_alias_return_thunk+0x5 =3D \
  .../arch/x86/lib/retpoline.S:182
  wake_up_state+0x10 =3D \
  .../kernel/sched/core.c:4508
  do_group_exit+0x35 =3D \
  .../kernel/exit.c:1006
  __x64_sys_exit_group+0x18 =3D \
  .../kernel/exit.c:1035
  x64_sys_call+0x2001 =3D \
  .../debian/build/build-generic/./arch/x86/include/generated/asm/syscalls_=
64.h:61
  do_syscall_64+0x81 =3D \
  .../arch/x86/entry/common.c:47
  entry_SYSCALL_64_after_hwframe+0x78 =3D \
  .../arch/x86/entry/entry_64.S:130

I confirmed that the pci_mmcfg_read in question is reading reg 0xffc of
the GPU device.

I'll also relay what we know from earlier bugs which seem related, but
for which we lack good reproducers, in chronological order.  In the
following, we were using a mix of ROCm versions, as we tried to
eliminate the runtime libraries as the cause of the trouble.

Among the testsuites we run is <https://github.com/doru1004/omptests>.
With this one, in particular, running the t-unified-* tests, which
indeed use the aforementioned Unified Shared Memory (and ergo use
HSA_XNACK and HMM), tended to reproduce the issues described below.

At some point, we started seeing the following soft lockup in dmesg,
combined with all our tests starting to time out rather than run to
completion:

  [  276.603799] watchdog: BUG: soft lockup - CPU#1 stuck for 82s! [a.out:1=
545]
  [  276.605735] Modules linked in: nfsv3 nfs netfs binfmt_misc intel_rapl_=
msr intel_rapl_common kvm_amd ccp nls_iso8859_1 kvm irqbypass input_leds jo=
ydev serio_raw mac_hid qemu_fw_cfg sch_fq_codel dm_multipath scsi_dh_rdac s=
csi_dh_emc scsi_dh_alua nfsd auth_rpcgss nfs_acl lockd grace efi_pstore sun=
rpc ip_tables x_tables autofs4 btrfs blake2b_generic raid10 raid456 async_r=
aid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c =
raid1 raid0 hid_generic usbhid hid amdgpu(OE) amddrm_ttm_helper(OE) amdttm(=
OE) amddrm_buddy(OE) crct10dif_pclmul amdxcp(OE) crc32_pclmul amddrm_exec(O=
E) amd_sched(OE) polyval_clmulni amdkcl(OE) i2c_algo_bit polyval_generic gh=
ash_clmulni_intel vga16fb drm_suballoc_helper sha256_ssse3 sha1_ssse3 drm_d=
isplay_helper vgastate ahci cec rc_core libahci i2c_i801 lpc_ich bochs drm_=
vram_helper i2c_smbus video drm_ttm_helper psmouse xhci_pci xhci_pci_renesa=
s wmi ttm aesni_intel crypto_simd cryptd
  [  276.625820] CPU: 1 PID: 1545 Comm: a.out Tainted: G      D    OEL     =
6.8.0-100-generic #100~22.04.1-Ubuntu
  [  276.628247] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1=
.15.0-1 04/01/2014
  [  276.630370] RIP: 0010:__pv_queued_spin_lock_slowpath+0x101/0x3b0
  [  276.632057] Code: 75 d0 41 bd 01 00 00 00 41 be 00 01 00 00 3c 02 41 0=
f 94 c0 4c 89 45 c8 41 c6 47 14 00 ba 00 80 00 00 c6 43 01 01 eb 0b f3 90 <=
83> ea 01 0f 84 31 02 00 00 0f b6 03 84 c0 75 ee 44 89 f0 f0 66 44
  [  276.636817] RSP: 0018:ffffd18f83d2b808 EFLAGS: 00000206
  [  276.638341] RAX: 0000000000000003 RBX: fffffa4bc468b9e8 RCX: 000000000=
0000000
  [  276.640293] RDX: 0000000000006cf4 RSI: 0000000000000000 RDI: 000000000=
0000000
  [  276.642245] RBP: ffffd18f83d2b840 R08: 0000000000000000 R09: 000000000=
0000000
  [  276.644203] R10: 0000000000000000 R11: 0000000000000000 R12: 000000000=
0080000
  [  276.646154] R13: 0000000000000001 R14: 0000000000000100 R15: ffff8d37e=
7cb5900
  [  276.648112] FS:  000079bb47300140(0000) GS:ffff8d37e7c80000(0000) knlG=
S:0000000000000000
  [  276.650264] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  [  276.651926] CR2: 000079bb47300ae8 CR3: 00000001ab9d0006 CR4: 000000000=
0770ef0
  [  276.653882] PKRU: 55555554
  [  276.654888] Call Trace:
  [  276.655843]  <TASK>
  [  276.656723]  _raw_spin_lock+0x3f/0x60
  [  276.657939]  __pte_offset_map_lock+0xa3/0x130
  [  276.659308]  migration_entry_wait+0x2e/0x110
  [  276.660653]  do_swap_page+0x677/0xb00
  [  276.661880]  ? srso_alias_return_thunk+0x5/0xfbef5
  [  276.663335]  ? srso_alias_return_thunk+0x5/0xfbef5
  [  276.664789]  ? __pte_offset_map+0x1c/0x1b0
  [  276.666090]  handle_pte_fault+0x17b/0x1d0
  [  276.667375]  __handle_mm_fault+0x64f/0x790
  [  276.668680]  handle_mm_fault+0x18d/0x380
  [  276.669975]  do_user_addr_fault+0x1f9/0x680
  [  276.671302]  exc_page_fault+0x83/0x1b0
  [  276.672531]  asm_exc_page_fault+0x27/0x30
  [  276.673817] RIP: 0010:__get_user_8+0xd/0x20
  [  276.675116] Code: ca e9 62 92 35 00 0f 1f 80 00 00 00 00 90 90 90 90 9=
0 90 90 90 90 90 90 90 90 90 90 90 48 89 c2 48 c1 fa 3f 48 09 d0 0f 01 cb <=
48> 8b 10 31 c0 0f 01 ca e9 31 92 35 00 66 0f 1f 44 00 00 90 90 90
  [  276.679939] RSP: 0018:ffffd18f83d2bb88 EFLAGS: 00050206
  [  276.681470] RAX: 000079bb47300ae8 RBX: ffff8d32949f2900 RCX: 000000000=
0000000
  [  276.683437] RDX: 0000000000000000 RSI: ffffd18f83d2bbc0 RDI: ffff8d329=
49f2900
  [  276.685402] RBP: ffffd18f83d2bbb0 R08: 0000000000000000 R09: 000000000=
0000000
  [  276.687386] R10: 0000000000000000 R11: 0000000000000000 R12: ffffd18f8=
3d2bf58
  [  276.689354] R13: 000079bb4711a9cf R14: ffff8d32949f2900 R15: 000000000=
0000000
  [  276.691318]  ? rseq_get_rseq_cs+0x22/0x280
  [  276.692611]  rseq_ip_fixup+0x69/0x1f0
  [  276.693822]  __rseq_handle_notify_resume+0x2b/0x70
  [  276.695248]  syscall_exit_to_user_mode+0x1ab/0x1e0
  [  276.696663]  do_syscall_64+0x8d/0x170
  [  276.697840]  ? srso_alias_return_thunk+0x5/0xfbef5
  [  276.699247]  ? srso_alias_return_thunk+0x5/0xfbef5
  [  276.700643]  ? kfd_wait_on_events+0x32b/0x560 [amdgpu]
  [  276.702411]  ? srso_alias_return_thunk+0x5/0xfbef5
  [  276.703804]  ? __check_object_size.part.0+0x3a/0x150
  [  276.705224]  ? srso_alias_return_thunk+0x5/0xfbef5
  [  276.706600]  ? __check_object_size+0x23/0x30
  [  276.707876]  ? srso_alias_return_thunk+0x5/0xfbef5
  [  276.709228]  ? kfd_ioctl+0x36a/0x5d0 [amdgpu]
  [  276.710782]  ? __pfx_kfd_ioctl_wait_events+0x10/0x10 [amdgpu]
  [  276.712602]  ? srso_alias_return_thunk+0x5/0xfbef5
  [  276.713970]  ? srso_alias_return_thunk+0x5/0xfbef5
  [  276.715308]  ? arch_exit_to_user_mode_prepare.constprop.0+0x1a/0xe0
  [  276.716979]  ? srso_alias_return_thunk+0x5/0xfbef5
  [  276.718330]  ? syscall_exit_to_user_mode+0x43/0x1e0
  [  276.719692]  ? srso_alias_return_thunk+0x5/0xfbef5
  [  276.721047]  ? do_syscall_64+0x8d/0x170
  [  276.722193]  ? srso_alias_return_thunk+0x5/0xfbef5
  [  276.723545]  ? do_syscall_64+0x8d/0x170
  [  276.724716]  ? do_syscall_64+0x8d/0x170
  [  276.725893]  ? do_syscall_64+0x8d/0x170
  [  276.727039]  ? srso_alias_return_thunk+0x5/0xfbef5
  [  276.728390]  entry_SYSCALL_64_after_hwframe+0x78/0x80
  [  276.729823] RIP: 0033:0x79bb4711a9cf
  [  276.730928] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 10 0=
0 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00 00 0f 05 <=
41> 89 c0 3d 00 f0 ff ff 77 1f 48 8b 44 24 18 64 48 2b 04 25 28 00
  [  276.735543] RSP: 002b:00007ffecb21d060 EFLAGS: 00000246 ORIG_RAX: 0000=
000000000010
  [  276.737506] RAX: 0000000000000000 RBX: 0000000000000003 RCX: 000079bb4=
711a9cf
  [  276.739392] RDX: 00007ffecb21d130 RSI: 00000000c0184b0c RDI: 000000000=
0000003
  [  276.741272] RBP: 00000000c0184b0c R08: 0000000000000005 R09: 000000003=
813e430
  [  276.743157] R10: 000079bb46c751f0 R11: 0000000000000246 R12: 00007ffec=
b21d238
  [  276.745043] R13: 00007ffecb21d130 R14: 00007ffecb21d1e8 R15: 000000003=
813e430
  [  276.746929]  </TASK>

... this was on a Ubuntu 22.04 "HWE" kernel 6.8.0-100-generic
#100~22.04.1-Ubuntu.

The call trace above, in 'crash', is:

  crash> gdb bt
  #0  pv_wait_head_or_lock (node=3D0xffff8d37e7cb5900, lock=3D0xfffffa4bc46=
8b9e8) at /build/linux-hwe-6.8-oekvKq/linux-hwe-6.8-6.8.0/kernel/locking/qs=
pinlock_paravirt.h:434
  #1  __pv_queued_spin_lock_slowpath (lock=3D0xfffffa4bc468b9e8, val=3D<opt=
imized out>) at /build/linux-hwe-6.8-oekvKq/linux-hwe-6.8-6.8.0/kernel/lock=
ing/qspinlock.c:511
  #2  0xffffffff9a0398cf in pv_queued_spin_lock_slowpath (val=3D3, lock=3D0=
x0) at /build/linux-hwe-6.8-oekvKq/linux-hwe-6.8-6.8.0/arch/x86/include/asm=
/paravirt.h:584
  #3  queued_spin_lock_slowpath (val=3D3, lock=3D0x0) at /build/linux-hwe-6=
.8-oekvKq/linux-hwe-6.8-6.8.0/arch/x86/include/asm/qspinlock.h:51
  #4  queued_spin_lock (lock=3D0x0) at /build/linux-hwe-6.8-oekvKq/linux-hw=
e-6.8-6.8.0/include/asm-generic/qspinlock.h:114
  #5  do_raw_spin_lock (lock=3D0x0) at /build/linux-hwe-6.8-oekvKq/linux-hw=
e-6.8-6.8.0/include/linux/spinlock.h:187
  #6  __raw_spin_lock (lock=3D0x0, lock@entry=3D0xfffffa4bc468b9e8) at /bui=
ld/linux-hwe-6.8-oekvKq/linux-hwe-6.8-6.8.0/include/linux/spinlock_api_smp.=
h:134
  #7  _raw_spin_lock (lock=3D0x0, lock@entry=3D0xfffffa4bc468b9e8) at /buil=
d/linux-hwe-6.8-oekvKq/linux-hwe-6.8-6.8.0/kernel/locking/spinlock.c:154
  #8  0xffffffff99241b43 in spin_lock (lock=3D0xfffffa4bc468b9e8) at /build=
/linux-hwe-6.8-oekvKq/linux-hwe-6.8-6.8.0/include/linux/spinlock.h:351
  #9  __pte_offset_map_lock (mm=3D<optimized out>, pmd=3D0xffff8d3286f3c1c8=
, addr=3D133845260173312, ptlp=3Dptlp@entry=3D0xffffd18f83d2b8a8) at /build=
/linux-hwe-6.8-oekvKq/linux-hwe-6.8-6.8.0/mm/pgtable-generic.c:375
  #10 0xffffffff992a7ade in pte_offset_map_lock (ptlp=3D0xffffd18f83d2b8a8,=
 addr=3D<optimized out>, pmd=3D<optimized out>, mm=3D<optimized out>) at /b=
uild/linux-hwe-6.8-oekvKq/linux-hwe-6.8-6.8.0/include/linux/mm.h:2997
  #11 migration_entry_wait (mm=3D<optimized out>, pmd=3D<optimized out>, ad=
dress=3D<optimized out>) at /build/linux-hwe-6.8-oekvKq/linux-hwe-6.8-6.8.0=
/mm/migrate.c:311
  #12 0xffffffff9922bb77 in do_swap_page (vmf=3Dvmf@entry=3D0xffffd18f83d2b=
970) at /build/linux-hwe-6.8-oekvKq/linux-hwe-6.8-6.8.0/mm/memory.c:3832
  #13 0xffffffff9922c18b in handle_pte_fault (vmf=3Dvmf@entry=3D0xffffd18f8=
3d2b970) at /build/linux-hwe-6.8-oekvKq/linux-hwe-6.8-6.8.0/mm/memory.c:5248
  #14 0xffffffff9922c83f in __handle_mm_fault (vma=3Dvma@entry=3D0xffff8d32=
88606900, address=3Daddress@entry=3D133845260176104, flags=3Dflags@entry=3D=
532) at /build/linux-hwe-6.8-oekvKq/linux-hwe-6.8-6.8.0/mm/memory.c:5386
  #15 0xffffffff9922cb1d in handle_mm_fault (vma=3Dvma@entry=3D0xffff8d3288=
606900, address=3Daddress@entry=3D133845260176104, flags=3Dflags@entry=3D53=
2, regs=3Dregs@entry=3D0xffffd18f83d2bad8) at /build/linux-hwe-6.8-oekvKq/l=
inux-hwe-6.8-6.8.0/mm/memory.c:5551
  #16 0xffffffff98ed7eb9 in do_user_addr_fault (regs=3Dregs@entry=3D0xffffd=
18f83d2bad8, error_code=3Derror_code@entry=3D0, address=3Daddress@entry=3D1=
33845260176104) at /build/linux-hwe-6.8-oekvKq/linux-hwe-6.8-6.8.0/arch/x86=
/mm/fault.c:1375
  #17 0xffffffff9a028173 in handle_page_fault (address=3D133845260176104, e=
rror_code=3D0, regs=3D0xffffd18f83d2bad8) at /build/linux-hwe-6.8-oekvKq/li=
nux-hwe-6.8-6.8.0/arch/x86/mm/fault.c:1467
  #18 exc_page_fault (regs=3D0xffffd18f83d2bad8, error_code=3D0) at /build/=
linux-hwe-6.8-oekvKq/linux-hwe-6.8-6.8.0/arch/x86/mm/fault.c:1523
  #19 0xffffffff9a200bc7 in asm_exc_page_fault () at /build/linux-hwe-6.8-o=
ekvKq/linux-hwe-6.8-6.8.0/arch/x86/include/asm/idtentry.h:608

(I have a memory dump of the VM with this process stuck)

We managed to create a reliable reproducer for the above, by launching
all the t-unified-* tests from omptests in parallel, and a timeout of
three minutes.  It seems to frequently get stuck in specifically
t-unified-dpf, though I see nothing particularly special about that
testcase, and invoking it alone does not seem to suffice.

Following that, we tried switching to v7.0rc1.  On that version, our
reproducer script (which just launched t-unified-* in parallel all at
once) stopped reproducing the issue, but we still saw, after some time,
the following:

  [301668.989070] BUG: Bad page state in process check_ps.bash  pfn:10b19b
  [301668.990447] page: refcount:0 mapcount:0 mapping:0000000000000000 inde=
x:0x7b9ebc78a pfn:0x10b19b
  [301668.990452] flags: 0x17ffffc0000080(waiters|node=3D0|zone=3D2|lastcpu=
pid=3D0x1fffff)
  [301668.990458] raw: 0017ffffc0000080 dead000000000100 dead000000000122 0=
000000000000000
  [301668.990485] raw: 00000007b9ebc78a 0000000000000000 00000000ffffffff 0=
000000000000000
  [301668.990487] page dumped because: PAGE_FLAGS_CHECK_AT_PREP flag(s) set
  [301668.990490] Modules linked in: tls nfsv3 nfs netfs binfmt_misc nls_is=
o8859_1 intel_rapl_msr intel_rapl_common kvm_amd ccp kvm irqbypass input_le=
ds joydev mac_hid serio_raw qemu_fw_cfg sch_fq_codel dm_multipath scsi_dh_r=
dac scsi_dh_emc scsi_dh_alua nfsd auth_rpcgss nfs_acl lockd grace efi_pstor=
e sunrpc ip_tables x_tables autofs4 btrfs libblake2b raid10 raid456 async_r=
aid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq raid1 raid=
0 linear amdgpu amdxcp drm_panel_backlight_quirks hid_generic gpu_sched drm=
_buddy drm_ttm_helper ttm video wmi drm_exec i2c_algo_bit drm_suballoc_help=
er drm_display_helper cec vga16fb i2c_i801 usbhid vgastate ahci ghash_clmul=
ni_intel i2c_smbus psmouse i2c_mux hid rc_core libahci lpc_ich bochs aesni_=
intel
  [301668.990615] CPU: 1 UID: 0 PID: 2075298 Comm: check_ps.bash Not tainte=
d 7.0.0-070000rc1-generic #202602222250 PREEMPT(full)
  [301668.990619] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS =
1.15.0-1 04/01/2014
  [301668.990620] Call Trace:
  [301668.990622]  <TASK>
  [301668.990625]  show_stack+0x49/0x60
  [301668.990642]  dump_stack_lvl+0x5f/0x90
  [301668.990651]  dump_stack+0x10/0x18
  [301668.990653]  bad_page.cold+0x91/0xac
  [301668.990658]  __rmqueue_pcplist+0x188/0x2e0
  [301668.990662]  ? alloc_pages_mpol+0x88/0x1b0
  [301668.990665]  ? srso_alias_return_thunk+0x5/0xfbef5
  [301668.990670]  rmqueue_pcplist+0x92/0x190
  [301668.990673]  ? post_alloc_hook+0x85/0x120
  [301668.990676]  rmqueue.isra.0+0x10a6/0x18a0
  [301668.990679]  ? mod_memcg_state+0xe7/0x2a0
  [301668.990684]  ? srso_alias_return_thunk+0x5/0xfbef5
  [301668.990686]  ? __memcg_kmem_charge_page+0x128/0x250
  [301668.990690]  ? srso_alias_return_thunk+0x5/0xfbef5
  [301668.990692]  ? __alloc_frozen_pages_noprof+0x1b7/0x360
  [301668.990697]  get_page_from_freelist+0x1e2/0x720
  [301668.990700]  ? srso_alias_return_thunk+0x5/0xfbef5
  [301668.990702]  ? alloc_pages_mpol+0x88/0x1b0
  [301668.990707]  __alloc_frozen_pages_noprof+0x187/0x360
  [301668.990711]  alloc_pages_mpol+0x88/0x1b0
  [301668.990715]  alloc_pages_noprof+0x59/0xe0
  [301668.990717]  ? srso_alias_return_thunk+0x5/0xfbef5
  [301668.990720]  __pud_alloc+0x31/0x1e0
  [301668.990725]  copy_p4d_range+0x4fd/0x560
  [301668.990728]  ? srso_alias_return_thunk+0x5/0xfbef5
  [301668.990731]  ? __memcg_slab_post_alloc_hook+0x1bd/0x3a0
  [301668.990733]  ? obj_cgroup_charge_account+0x139/0x3e0
  [301668.990738]  copy_page_range+0x199/0x2e0
  [301668.990741]  ? srso_alias_return_thunk+0x5/0xfbef5
  [301668.990746]  dup_mmap+0x39f/0x890
  [301668.990756]  dup_mm.constprop.0+0x6f/0x170
  [301668.990761]  copy_process+0x1670/0x1780
  [301668.990766]  kernel_clone+0xb6/0x4c0
  [301668.990771]  __do_sys_clone+0x68/0xa0
  [301668.990776]  __x64_sys_clone+0x25/0x40
  [301668.990779]  x64_sys_call+0x139b/0x2390
  [301668.990783]  do_syscall_64+0x115/0x5c0
  [301668.990788]  ? srso_alias_return_thunk+0x5/0xfbef5
  [301668.990791]  ? exc_page_fault+0x94/0x1e0
  [301668.990794]  ? srso_alias_return_thunk+0x5/0xfbef5
  [301668.990798]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
  [301668.990800] RIP: 0033:0x7a84194eab57
  [301668.990803] Code: ba 04 00 f3 0f 1e fa 64 48 8b 04 25 10 00 00 00 45 =
31 c0 31 d2 31 f6 bf 11 00 20 01 4c 8d 90 d0 02 00 00 b8 38 00 00 00 0f 05 =
<48> 3d 00 f0 ff ff 77 41 41 89 c0 85 c0 75 2c 64 48 8b 04 25 10 00
  [301668.990805] RSP: 002b:00007ffe0aaaa218 EFLAGS: 00000246 ORIG_RAX: 000=
0000000000038
  [301668.990808] RAX: ffffffffffffffda RBX: 00007a84197c9040 RCX: 00007a84=
194eab57
  [301668.990809] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000=
01200011
  [301668.990811] RBP: 0000000000000000 R08: 0000000000000000 R09: 00005d6a=
7da5717e
  [301668.990812] R10: 00007a8419744a10 R11: 0000000000000246 R12: 00000000=
00000001
  [301668.990813] R13: 00007ffe0aaaa370 R14: 00005d6a7da69bcf R15: 00000000=
00000000
  [301668.990819]  </TASK>
  [301668.990820] Disabling lock debugging due to kernel taint
  [301672.287526] INFO: task kworker/0:1:2042591 blocked for more than 122 =
seconds.
  [301672.291489]       Tainted: G    B               7.0.0-070000rc1-gener=
ic #202602222250
  [301672.293853] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disabl=
es this message.
  [301672.296088] task:kworker/0:1     state:D stack:0     pid:2042591 tgid=
:2042591 ppid:2      task_flags:0x4208060 flags:0x00080000
  [301672.296098] Workqueue: events_freezable amdgpu_amdkfd_restore_userptr=
_worker [amdgpu]
  [301672.296691] Call Trace:
  [301672.296695]  <TASK>
  [301672.296700]  __schedule+0x2b2/0x620
  [301672.296711]  schedule+0x27/0x90
  [301672.296716]  schedule_preempt_disabled+0x15/0x30
  [301672.296721]  __ww_mutex_lock.constprop.0+0x679/0xdb0
  [301672.296730]  __ww_mutex_lock_slowpath+0x16/0x30
  [301672.296735]  ww_mutex_lock+0xef/0x100
  [301672.296744]  drm_exec_lock_obj+0x43/0x230 [drm_exec]
  [301672.296750]  ? drm_exec_init+0x35/0x90 [drm_exec]
  [301672.296755]  drm_exec_prepare_obj+0x20/0x60 [drm_exec]
  [301672.296762]  amdgpu_vm_lock_pd+0x22/0x30 [amdgpu]
  [301672.297217]  validate_invalid_user_pages+0xbf/0x330 [amdgpu]
  [301672.298047]  amdgpu_amdkfd_restore_userptr_worker+0xb9/0x290 [amdgpu]
  [301672.298838]  process_one_work+0x18e/0x3a0
  [301672.298848]  worker_thread+0x188/0x320
  [301672.298852]  ? _raw_spin_unlock_irqrestore+0x11/0x60
  [301672.298858]  ? srso_alias_return_thunk+0x5/0xfbef5
  [301672.298864]  ? __pfx_worker_thread+0x10/0x10
  [301672.298869]  kthread+0xf7/0x130
  [301672.298874]  ? __pfx_kthread+0x10/0x10
  [301672.298878]  ret_from_fork+0x195/0x2a0
  [301672.298884]  ? __pfx_kthread+0x10/0x10
  [301672.298888]  ? __pfx_kthread+0x10/0x10
  [301672.298893]  ret_from_fork_asm+0x1a/0x30
  [301672.298904]  </TASK>
  [301672.298945] INFO: task kworker/0:1:2042591 is blocked on a mutex like=
ly owned by task kworker/2:0:1970590.
  [301672.300900] task:kworker/2:0     state:R  running task     stack:0   =
  pid:1970590 tgid:1970590 ppid:2      task_flags:0x4208060 flags:0x00080000
  [301672.300910] Workqueue: events amdgpu_irq_handle_ih_soft [amdgpu]
  [301672.301192] Call Trace:
  [301672.301195]  <TASK>
  [301672.301199]  ? walk_pmd_range.isra.0+0xdf/0x2b0
  [301672.301207]  ? walk_pud_range.isra.0+0x18c/0x2a0
  [301672.301213]  ? walk_p4d_range+0x16e/0x210
  [301672.301218]  ? srso_alias_return_thunk+0x5/0xfbef5
  [301672.301224]  ? srso_alias_return_thunk+0x5/0xfbef5
  [301672.301227]  ? walk_pgd_range+0xd4/0x280
  [301672.301236]  ? srso_alias_return_thunk+0x5/0xfbef5
  [301672.301240]  ? walk_page_range_mm_unsafe+0x94/0x220
  [301672.301247]  ? walk_page_range+0x2a/0x40
  [301672.301251]  ? hmm_range_fault+0x5c/0xb0
  [301672.301258]  ? amdgpu_hmm_range_get_pages+0x103/0x210 [amdgpu]
  [301672.301759]  ? svm_range_validate_and_map+0x3e8/0xaa0 [amdgpu]
  [301672.302062]  ? srso_alias_return_thunk+0x5/0xfbef5
  [301672.302071]  ? svm_range_restore_pages+0x983/0xdd0 [amdgpu]
  [301672.302375]  ? amdgpu_vm_handle_fault+0xe3/0x370 [amdgpu]
  [301672.302621]  ? amdgpu_gmc_handle_retry_fault+0x64/0x170 [amdgpu]
  [301672.302851]  ? gmc_v9_0_process_interrupt+0xc8/0x190 [amdgpu]
  [301672.303098]  ? amdgpu_irq_dispatch+0x1b2/0x330 [amdgpu]
  [301672.303354]  ? amdgpu_ih_process+0x85/0x1d0 [amdgpu]
  [301672.303612]  ? amdgpu_irq_handle_ih_soft+0x1c/0x30 [amdgpu]
  [301672.303853]  ? process_one_work+0x18e/0x3a0
  [301672.303860]  ? worker_thread+0x188/0x320
  [301672.303864]  ? __pfx_worker_thread+0x10/0x10
  [301672.303869]  ? kthread+0xf7/0x130
  [301672.303873]  ? __pfx_kthread+0x10/0x10
  [301672.303877]  ? ret_from_fork+0x195/0x2a0
  [301672.303882]  ? __pfx_kthread+0x10/0x10
  [301672.303885]  ? __pfx_kthread+0x10/0x10
  [301672.303889]  ? ret_from_fork_asm+0x1a/0x30
  [301672.303898]  </TASK>

Note that check_ps.bash is not one of the processes utilizing the GPU,
it's a completely unrelated process.  We've had a few crashes where
unrelated processes look implicated like the above.

After this, we found the following commit:

  mm: Fix a hmm_range_fault() livelock / starvation problem by Intel's Thom=
as Hellstr=C3=B6m
  https://git.kernel.org/linus/b570f37a2ce480be26c665345c5514686a8a0274

... which seemed related.  This one was in v7.0rc4, so we switched to
that version.

For a few weeks, it seemed like rc4 was stable.

We later decided to upgrade to v7.0 proper, after it was released.  We
tested that kernel on a backup machine by running the reproducers we had
and the testsuites, and it seemed fine, so we updated the machine
running CI to v7.0.

The next day, after our CI run, we saw the following (from journald, so
timestamps are real-time, all on Apr 18th):

  03:37:59: workqueue: amdgpu_irq_handle_ih_soft [amdgpu] hogged CPU for >1=
0000us 67 times, consider switching to WQ_UNBOUND
  03:43:48: BUG: Bad page state in process bash  pfn:10bc45
  03:43:48: page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x71=
601f576 pfn:0x10bc45
  03:43:48: flags: 0x17ffffc0000080(waiters|node=3D0|zone=3D2|lastcpupid=3D=
0x1fffff)
  03:43:48: raw: 0017ffffc0000080 dead000000000100 dead000000000122 0000000=
000000000
  03:43:48: raw: 000000071601f576 0000000000000000 00000000ffffffff 0000000=
000000000
  03:43:48: page dumped because: PAGE_FLAGS_CHECK_AT_PREP flag(s) set
  03:43:48: Modules linked in: tls nfsv3 nfs netfs binfmt_misc intel_rapl_m=
sr intel_rapl_common nls_iso8859_1 kvm_amd ccp joydev input_leds kvm irqbyp=
ass mac_hid serio_raw qemu_fw_cfg dm_multipath scsi_dh_rdac scsi_dh_emc sch=
_fq_codel scsi_dh_alua nfsd auth_rpcgss nfs_acl lockd grace efi_pstore sunr=
pc ip_tables x_tables autofs4 btrf>
  03:43:48: CPU: 0 UID: 2010 PID: 483761 Comm: bash Not tainted 7.0.0-07000=
0-generic #202604122140 PREEMPT(lazy)
  03:43:48: Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0=
-1 04/01/2014
  03:43:48: Call Trace:
  03:43:48:  <TASK>
  03:43:48:  show_stack+0x49/0x60
  03:43:48:  dump_stack_lvl+0x5f/0x90
  03:43:48:  dump_stack+0x10/0x18
  03:43:48:  bad_page.cold+0x91/0xac
  03:43:48:  __rmqueue_pcplist+0x199/0x2e0
  03:43:48:  ? _raw_spin_unlock+0xe/0x40
  03:43:48:  ? srso_alias_return_thunk+0x5/0xfbef5
  03:43:48:  ? rmqueue_pcplist+0x9d/0x190
  03:43:48:  rmqueue_pcplist+0x92/0x190
  03:43:48:  ? post_alloc_hook+0x85/0x120
  03:43:48:  rmqueue.isra.0+0x115d/0x1890
  03:43:48:  ? mod_memcg_state+0xe7/0x2a0
  03:43:48:  ? srso_alias_return_thunk+0x5/0xfbef5
  03:43:48:  ? __memcg_kmem_charge_page+0x128/0x250
  03:43:48:  ? srso_alias_return_thunk+0x5/0xfbef5
  03:43:48:  get_page_from_freelist+0x1e2/0x720
  03:43:48:  ? srso_alias_return_thunk+0x5/0xfbef5
  03:43:48:  ? alloc_pages_mpol+0x88/0x1b0
  03:43:48:  __alloc_frozen_pages_noprof+0x187/0x360
  03:43:48:  alloc_pages_mpol+0x88/0x1b0
  03:43:48:  alloc_pages_noprof+0x59/0xe0
  03:43:48:  ? srso_alias_return_thunk+0x5/0xfbef5
  03:43:48:  __pud_alloc+0x31/0x1b0
  03:43:48:  copy_p4d_range+0x4fd/0x560
  03:43:48:  ? srso_alias_return_thunk+0x5/0xfbef5
  03:43:48:  ? __memcg_slab_post_alloc_hook+0x1bd/0x3a0
  03:43:48:  ? obj_cgroup_charge_account+0x139/0x3e0
  03:43:48:  copy_page_range+0x184/0x2c0
  03:43:48:  ? srso_alias_return_thunk+0x5/0xfbef5
  03:43:48:  dup_mmap+0x39f/0x890
  03:43:48:  dup_mm.constprop.0+0x6f/0x170
  03:43:48:  copy_process+0x15f8/0x1790
  03:43:48:  kernel_clone+0xb6/0x4c0
  03:43:48:  ? srso_alias_return_thunk+0x5/0xfbef5
  03:43:48:  ? security_file_alloc+0xa1/0x1a0
  03:43:48:  ? srso_alias_return_thunk+0x5/0xfbef5
  03:43:48:  __do_sys_clone+0x68/0xa0
  03:43:48:  __x64_sys_clone+0x25/0x40
  03:43:48:  x64_sys_call+0x139b/0x2390
  03:43:48:  do_syscall_64+0x115/0x5a0
  03:43:48:  ? arch_exit_to_user_mode_prepare.isra.0+0xd/0xe0
  03:43:48:  ? srso_alias_return_thunk+0x5/0xfbef5
  03:43:48:  ? do_syscall_64+0x150/0x5a0
  03:43:48:  ? _raw_spin_unlock_irq+0xe/0x50
  03:43:48:  ? srso_alias_return_thunk+0x5/0xfbef5
  03:43:48:  ? do_sigaction+0x15d/0x4b0
  03:43:48:  ? srso_alias_return_thunk+0x5/0xfbef5
  03:43:48:  ? __x64_sys_rt_sigaction+0xbc/0x140
  03:43:48:  ? srso_alias_return_thunk+0x5/0xfbef5
  03:43:48:  ? arch_exit_to_user_mode_prepare.isra.0+0xd/0xe0
  03:43:48:  ? srso_alias_return_thunk+0x5/0xfbef5
  03:43:48:  ? do_syscall_64+0x150/0x5a0
  03:43:48:  ? vfs_write+0x25b/0x490
  03:43:48:  ? srso_alias_return_thunk+0x5/0xfbef5
  03:43:48:  ? __x64_sys_rt_sigprocmask+0xf6/0x160
  03:43:48:  ? srso_alias_return_thunk+0x5/0xfbef5
  03:43:48:  ? srso_alias_return_thunk+0x5/0xfbef5
  03:43:48:  ? srso_alias_return_thunk+0x5/0xfbef5
  03:43:48:  ? _raw_spin_unlock_irq+0xe/0x50
  03:43:48:  ? srso_alias_return_thunk+0x5/0xfbef5
  03:43:48:  ? __x64_sys_rt_sigprocmask+0xf6/0x160
  03:43:48:  ? srso_alias_return_thunk+0x5/0xfbef5
  03:43:48:  ? arch_exit_to_user_mode_prepare.isra.0+0xd/0xe0
  03:43:48:  ? srso_alias_return_thunk+0x5/0xfbef5
  03:43:48:  ? do_syscall_64+0x150/0x5a0
  03:43:48:  ? srso_alias_return_thunk+0x5/0xfbef5
  03:43:48:  ? __handle_mm_fault+0x493/0x720
  03:43:48:  ? srso_alias_return_thunk+0x5/0xfbef5
  03:43:48:  ? count_memcg_events+0x103/0x250
  03:43:48:  ? srso_alias_return_thunk+0x5/0xfbef5
  03:43:48:  ? handle_mm_fault+0x1c0/0x2e0
  03:43:48:  ? srso_alias_return_thunk+0x5/0xfbef5
  03:43:48:  ? srso_alias_return_thunk+0x5/0xfbef5
  03:43:48:  ? arch_exit_to_user_mode_prepare.isra.0+0xd/0x100
  03:43:48:  ? srso_alias_return_thunk+0x5/0xfbef5
  03:43:48:  ? irqentry_exit+0x97/0x5a0
  03:43:48:  ? srso_alias_return_thunk+0x5/0xfbef5
  03:43:48:  ? exc_page_fault+0x94/0x1e0
  03:43:48:  ? common_interrupt+0x61/0xe0
  03:43:48:  entry_SYSCALL_64_after_hwframe+0x76/0x7e
  03:43:48: RIP: 0033:0x71d58daeab57
  03:43:48: Code: ba 04 00 f3 0f 1e fa 64 48 8b 04 25 10 00 00 00 45 31 c0 =
31 d2 31 f6 bf 11 00 20 01 4c 8d 90 d0 02 00 00 b8 38 00 00 00 0f 05 <48> 3=
d 00 f0 ff ff 77 41 41 89 c0 85 c0 75 2c 64 48 8b 04 25 10 00
  03:43:48: RSP: 002b:00007ffefd0d7088 EFLAGS: 00000246 ORIG_RAX: 000000000=
0000038
  03:43:48: RAX: ffffffffffffffda RBX: 000071d58dd5e040 RCX: 000071d58daeab=
57
  03:43:48: RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000012000=
11
  03:43:48: RBP: 0000000000000000 R08: 0000000000000000 R09: 00000000000000=
00
  03:43:48: R10: 000071d58dcd9a10 R11: 0000000000000246 R12: 00000000000000=
01
  03:43:48: R13: 00007ffefd0d71e0 R14: 00005a8bacaaabcf R15: 00000000000000=
00
  03:43:48:  </TASK>
  03:43:48: Disabling lock debugging due to kernel taint
  03:50:43: workqueue: drm_fb_helper_damage_work hogged CPU for >10000us 35=
 times, consider switching to WQ_UNBOUND
  15:05:54: workqueue: send_exception_work_handler [amdgpu] hogged CPU for =
>10000us 67 times, consider switching to WQ_UNBOUND
  16:48:34: workqueue: drm_fb_helper_damage_work hogged CPU for >10000us 67=
 times, consider switching to WQ_UNBOUND

Unfortunately, the builds referenced above were all done with
Ubuntu-built mainline kernels.  They are unpatched, but I don't have
debug info for them.  :/

After downgrading back to v7.0rc4, we saw:

  Apr 24 16:59:22 kernel: BUG: Bad page state in process sh  pfn:107c87
  Apr 24 16:59:22 kernel: page: refcount:0 mapcount:0 mapping:0000000000000=
000 index:0x75d6c3df7 pfn:0x107c87
  Apr 24 16:59:22 kernel: flags: 0x17ffffc0000080(waiters|node=3D0|zone=3D2=
|lastcpupid=3D0x1fffff)
  Apr 24 16:59:22 kernel: raw: 0017ffffc0000080 dead000000000100 dead000000=
000122 0000000000000000
  Apr 24 16:59:22 kernel: raw: 000000075d6c3df7 0000000000000000 00000000ff=
ffffff 0000000000000000
  Apr 24 16:59:22 kernel: page dumped because: PAGE_FLAGS_CHECK_AT_PREP fla=
g(s) set
  Apr 24 16:59:22 kernel: Modules linked in: tls nfsv3 nfs netfs binfmt_mis=
c intel_rapl_msr intel_rapl_common kvm_amd nls_iso8859_1 ccp kvm irqbypass =
input_leds joydev serio_raw mac_hid qemu_fw_cfg dm_multipath sch_fq_codel s=
csi_dh_rdac scsi_dh_emc scsi_dh_alua nfsd auth_rpcgss nfs_acl lockd grace e=
fi_pstore sunrpc ip_tables x_tables autofs4 btrfs libblake2b raid10 raid456=
 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq ra=
id1 raid0 linear amdgpu amdxcp drm_panel_backlight_quirks gpu_sched drm_bud=
dy hid_generic drm_ttm_helper ttm vga16fb ghash_clmulni_intel video vgastat=
e wmi drm_exec i2c_algo_bit drm_suballoc_helper psmouse ahci usbhid drm_dis=
play_helper libahci i2c_i801 cec i2c_smbus i2c_mux rc_core hid lpc_ich boch=
s aesni_intel
  Apr 24 16:59:22 kernel: CPU: 0 UID: 118 PID: 2453645 Comm: sh Not tainted=
 7.0.0-070000rc4-generic #202603152142 PREEMPT(lazy)
  Apr 24 16:59:22 kernel: Hardware name: QEMU Standard PC (Q35 + ICH9, 2009=
), BIOS 1.15.0-1 04/01/2014
  Apr 24 16:59:22 kernel: Call Trace:
  Apr 24 16:59:22 kernel:  <TASK>
  Apr 24 16:59:22 kernel:  show_stack+0x49/0x60
  Apr 24 16:59:22 kernel:  dump_stack_lvl+0x5f/0x90
  Apr 24 16:59:22 kernel:  dump_stack+0x10/0x18
  Apr 24 16:59:22 kernel:  bad_page.cold+0x91/0xac
  Apr 24 16:59:22 kernel:  __rmqueue_pcplist+0x188/0x2e0
  Apr 24 16:59:22 kernel:  rmqueue_pcplist+0x92/0x190
  Apr 24 16:59:22 kernel:  rmqueue.isra.0+0x10a6/0x18a0
  Apr 24 16:59:22 kernel:  get_page_from_freelist+0x1e2/0x720
  Apr 24 16:59:22 kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
  Apr 24 16:59:22 kernel:  ? mod_memcg_state+0xe7/0x2a0
  Apr 24 16:59:22 kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
  Apr 24 16:59:22 kernel:  __alloc_frozen_pages_noprof+0x187/0x360
  Apr 24 16:59:22 kernel:  alloc_pages_mpol+0x88/0x1b0
  Apr 24 16:59:22 kernel:  alloc_pages_noprof+0x59/0xe0
  Apr 24 16:59:22 kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
  Apr 24 16:59:22 kernel:  ? _raw_spin_unlock+0xe/0x40
  Apr 24 16:59:22 kernel:  __pmd_alloc+0x2f/0x1f0
  Apr 24 16:59:22 kernel:  __handle_mm_fault+0x400/0x720
  Apr 24 16:59:22 kernel:  handle_mm_fault+0xe7/0x2e0
  Apr 24 16:59:22 kernel:  __get_user_pages+0x151/0x4d0
  Apr 24 16:59:22 kernel:  get_user_pages_remote+0xe5/0x430
  Apr 24 16:59:22 kernel:  get_arg_page+0x6c/0x130
  Apr 24 16:59:22 kernel:  copy_string_kernel+0xa9/0x1a0
  Apr 24 16:59:22 kernel:  do_execveat_common.isra.0+0x104/0x1a0
  Apr 24 16:59:22 kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
  Apr 24 16:59:22 kernel:  __x64_sys_execve+0x3e/0x70
  Apr 24 16:59:22 kernel:  x64_sys_call+0xc63/0x2390
  Apr 24 16:59:22 kernel:  do_syscall_64+0x115/0x5c0
  Apr 24 16:59:22 kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
  Apr 24 16:59:22 kernel:  ? xas_load+0x11/0x100
  Apr 24 16:59:22 kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
  Apr 24 16:59:22 kernel:  ? xas_find+0x84/0x1c0
  Apr 24 16:59:22 kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
  Apr 24 16:59:22 kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
  Apr 24 16:59:22 kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
  Apr 24 16:59:22 kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
  Apr 24 16:59:22 kernel:  ? _raw_spin_unlock_irqrestore+0x11/0x60
  Apr 24 16:59:22 kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
  Apr 24 16:59:22 kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
  Apr 24 16:59:22 kernel:  ? _raw_spin_unlock+0xe/0x40
  Apr 24 16:59:22 kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
  Apr 24 16:59:22 kernel:  ? filemap_map_pages+0x300/0x450
  Apr 24 16:59:22 kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
  Apr 24 16:59:22 kernel:  ? do_read_fault+0x10a/0x280
  Apr 24 16:59:22 kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
  Apr 24 16:59:22 kernel:  ? wp_page_reuse+0x97/0xc0
  Apr 24 16:59:22 kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
  Apr 24 16:59:22 kernel:  ? do_fault+0x16c/0x2a0
  Apr 24 16:59:22 kernel:  ? pte_offset_map_rw_nolock+0x20/0xa0
  Apr 24 16:59:22 kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
  Apr 24 16:59:22 kernel:  ? handle_pte_fault+0x141/0x1f0
  Apr 24 16:59:22 kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
  Apr 24 16:59:22 kernel:  ? __handle_mm_fault+0x493/0x720
  Apr 24 16:59:22 kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
  Apr 24 16:59:22 kernel:  ? count_memcg_events+0x103/0x250
  Apr 24 16:59:22 kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
  Apr 24 16:59:22 kernel:  ? handle_mm_fault+0x1c0/0x2e0
  Apr 24 16:59:22 kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
  Apr 24 16:59:22 kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
  Apr 24 16:59:22 kernel:  ? arch_exit_to_user_mode_prepare.isra.0+0xd/0x100
  Apr 24 16:59:22 kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
  Apr 24 16:59:22 kernel:  ? irqentry_exit+0x97/0x5a0
  Apr 24 16:59:22 kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
  Apr 24 16:59:22 kernel:  ? exc_page_fault+0x94/0x1e0
  Apr 24 16:59:22 kernel:  entry_SYSCALL_64_after_hwframe+0x76/0x7e
  Apr 24 16:59:22 kernel: RIP: 0033:0x7c02a18eb08b
  Apr 24 16:59:22 kernel: Code: f8 01 0f 8e bd fe ff ff 5b 48 8d 3d 4f 6a 1=
3 00 5d 41 5c e9 87 62 fa ff 0f 1f 80 00 00 00 00 f3 0f 1e fa b8 3b 00 00 0=
0 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 75 ed 12 00 f7 d8 64 89 01 48
  Apr 24 16:59:22 kernel: RSP: 002b:00007ffefcf8cff8 EFLAGS: 00000246 ORIG_=
RAX: 000000000000003b
  Apr 24 16:59:22 kernel: RAX: ffffffffffffffda RBX: 000060a1908d4780 RCX: =
00007c02a18eb08b
  Apr 24 16:59:22 kernel: RDX: 000060a1908d4790 RSI: 000060a1908d4780 RDI: =
000060a1908d47f0
  Apr 24 16:59:22 kernel: RBP: 000060a1908cd027 R08: 000060a1908cd1ff R09: =
000060a1ad3df690
  Apr 24 16:59:22 kernel: R10: 0000000000000004 R11: 0000000000000246 R12: =
000060a1908d4790
  Apr 24 16:59:22 kernel: R13: 00007ffefcf8d0e8 R14: 000060a1908d4790 R15: =
000060a1908d47f0
  Apr 24 16:59:22 kernel:  </TASK>
  Apr 24 16:59:22 kernel: Disabling lock debugging due to kernel taint
  Apr 25 03:47:00 kernel: workqueue: svm_range_restore_work [amdgpu] hogged=
 CPU for >10000us 4 times, consider switching to WQ_UNBOUND
  Apr 25 03:47:00 kernel: workqueue: svm_range_restore_work [amdgpu] hogged=
 CPU for >10000us 5 times, consider switching to WQ_UNBOUND
  Apr 25 07:41:50 kernel: ------------[ cut here ]------------
  Apr 25 07:41:50 kernel: [CRTC:35:crtc-0] vblank wait timed out
  Apr 25 07:41:50 kernel: WARNING: drivers/gpu/drm/drm_atomic_helper.c:1921=
 at drm_atomic_helper_wait_for_vblanks.part.0+0x240/0x260, CPU#2: kworker/2=
:2/3217129
  Apr 25 07:41:50 kernel: Modules linked in: tls nfsv3 nfs netfs binfmt_mis=
c intel_rapl_msr intel_rapl_common kvm_amd nls_iso8859_1 ccp kvm irqbypass =
input_leds joydev serio_raw mac_hid qemu_fw_cfg dm_multipath sch_fq_codel s=
csi_dh_rdac scsi_dh_emc scsi_dh_alua nfsd auth_rpcgss nfs_acl lockd grace e=
fi_pstore sunrpc ip_tables x_tables autofs4 btrfs libblake2b raid10 raid456=
 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq ra=
id1 raid0 linear amdgpu amdxcp drm_panel_backlight_quirks gpu_sched drm_bud=
dy hid_generic drm_ttm_helper ttm vga16fb ghash_clmulni_intel video vgastat=
e wmi drm_exec i2c_algo_bit drm_suballoc_helper psmouse ahci usbhid drm_dis=
play_helper libahci i2c_i801 cec i2c_smbus i2c_mux rc_core hid lpc_ich boch=
s aesni_intel
  Apr 25 07:41:50 kernel: CPU: 2 UID: 0 PID: 3217129 Comm: kworker/2:2 Tain=
ted: G    B               7.0.0-070000rc4-generic #202603152142 PREEMPT(laz=
y)
  Apr 25 07:41:50 kernel: Tainted: [B]=3DBAD_PAGE
  Apr 25 07:41:50 kernel: Hardware name: QEMU Standard PC (Q35 + ICH9, 2009=
), BIOS 1.15.0-1 04/01/2014
  Apr 25 07:41:50 kernel: Workqueue: events drm_fb_helper_damage_work
  Apr 25 07:41:50 kernel: RIP: 0010:drm_atomic_helper_wait_for_vblanks.part=
.0+0x247/0x260
  Apr 25 07:41:50 kernel: Code: ff 84 c0 74 86 48 8d 75 a8 4c 89 ff e8 82 a=
e 45 ff 8b 45 98 85 c0 0f 85 f7 fe ff ff 48 8d 3d 60 25 e8 01 48 8b 53 20 8=
b 73 60 <67> 48 0f b9 3a e9 df fe ff ff e8 ba 4b 66 00 66 2e 0f 1f 84 00 00
  Apr 25 07:41:50 kernel: RSP: 0018:ffffd2e58f4afbd0 EFLAGS: 00010246
  Apr 25 07:41:50 kernel: RAX: 0000000000000000 RBX: ffff8aa4eaa3cbc8 RCX: =
0000000000000000
  Apr 25 07:41:50 kernel: RDX: ffff8aa4c1f81490 RSI: 0000000000000023 RDI: =
ffffffffb96fdf40
  Apr 25 07:41:50 kernel: RBP: ffffd2e58f4afc40 R08: 0000000000000000 R09: =
0000000000000000
  Apr 25 07:41:50 kernel: R10: 0000000000000000 R11: 0000000000000000 R12: =
0000000000000000
  Apr 25 07:41:50 kernel: R13: 0000000000000000 R14: ffff8aa4ec32ca80 R15: =
ffff8aa4c0c2e030
  Apr 25 07:41:50 kernel: FS:  0000000000000000(0000) GS:ffff8aaa6e109000(0=
000) knlGS:0000000000000000
  Apr 25 07:41:50 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  Apr 25 07:41:50 kernel: CR2: 00007017180010b8 CR3: 000000010b8f2002 CR4: =
0000000000770ef0
  Apr 25 07:41:50 kernel: PKRU: 55555554
  Apr 25 07:41:50 kernel: Call Trace:
  Apr 25 07:41:50 kernel:  <TASK>
  Apr 25 07:41:50 kernel:  ? __pfx_autoremove_wake_function+0x10/0x10
  Apr 25 07:41:50 kernel:  drm_atomic_helper_commit_tail+0xa9/0xd0
  Apr 25 07:41:50 kernel:  commit_tail+0x116/0x1b0
  Apr 25 07:41:50 kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
  Apr 25 07:41:50 kernel:  ? drm_atomic_helper_swap_state+0x331/0x3f0
  Apr 25 07:41:50 kernel:  drm_atomic_helper_commit+0x153/0x190
  Apr 25 07:41:50 kernel:  drm_atomic_commit+0xad/0xf0
  Apr 25 07:41:50 kernel:  ? __pfx___drm_printfn_info+0x10/0x10
  Apr 25 07:41:50 kernel:  drm_atomic_helper_dirtyfb+0x1d6/0x2c0
  Apr 25 07:41:50 kernel:  drm_fbdev_shmem_helper_fb_dirty+0x4d/0xd0
  Apr 25 07:41:50 kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
  Apr 25 07:41:50 kernel:  drm_fb_helper_damage_work+0xf2/0x1a0
  Apr 25 07:41:50 kernel:  process_one_work+0x199/0x3c0
  Apr 25 07:41:50 kernel:  worker_thread+0x19d/0x340
  Apr 25 07:41:50 kernel:  ? _raw_spin_unlock_irqrestore+0x11/0x60
  Apr 25 07:41:50 kernel:  ? srso_alias_return_thunk+0x5/0xfbef5
  Apr 25 07:41:50 kernel:  ? __pfx_worker_thread+0x10/0x10
  Apr 25 07:41:50 kernel:  kthread+0xf7/0x130
  Apr 25 07:41:50 kernel:  ? __pfx_kthread+0x10/0x10
  Apr 25 07:41:50 kernel:  ret_from_fork+0x195/0x2a0
  Apr 25 07:41:50 kernel:  ? __pfx_kthread+0x10/0x10
  Apr 25 07:41:50 kernel:  ? __pfx_kthread+0x10/0x10
  Apr 25 07:41:50 kernel:  ret_from_fork_asm+0x1a/0x30
  Apr 25 07:41:50 kernel:  </TASK>
  Apr 25 07:41:50 kernel: ---[ end trace 0000000000000000 ]---
  Apr 25 08:29:46 kernel: workqueue: send_exception_work_handler [amdgpu] h=
ogged CPU for >10000us 131 times, consider switching to WQ_UNBOUND
  Apr 25 08:48:15 kernel: amdgpu 0000:05:00.0: Runlist is getting oversubsc=
ribed due to too many queues. Expect reduced ROCm performance.
  Apr 25 10:40:15 kernel: workqueue: svm_range_restore_work [amdgpu] hogged=
 CPU for >10000us 7 times, consider switching to WQ_UNBOUND

So, safe to say, the issue wasn't fixed in rc4 nor regressed in 7.0.

Same caveat WRT debug info applies to this build.

Thanks in advance, have a lovely day!

[1] https://gcc.gnu.org/wiki/Offloading
=2D-=20
Arsen Arsenovi=C4=87

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEKBAEWCgCyFiEE/uKz0RP8AKMWLWBhUsKUMB6ixJMFAmnw2/AbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyXxSAAAAAAC4AKGlzc3Vlci1mcHJAbm90YXRpb25z
Lm9wZW5wZ3AuZmlmdGhob3JzZW1hbi5uZXRGRUUyQjNEMTEzRkMwMEEzMTYyRDYw
NjE1MkMyOTQzMDFFQTJDNDkzGBxhYXJzZW5vdmljQGJheWxpYnJlLmNvbQAKCRBS
wpQwHqLEk/f0AP41cn0G1YKIZIhPH6mjFnxdAAlcuQxLku4oD3iVzLOZhQEAyxxo
ePwPmZ7bmgAx1t3GlOt2TltEgu3Q4ISQR7CyEgo=
=RFym
-----END PGP SIGNATURE-----
--=-=-=--

