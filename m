Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A2D6CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 12:01:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BED986B00D0; Tue, 26 May 2026 08:01:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC5746B00D2; Tue, 26 May 2026 08:01:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADCD16B00D3; Tue, 26 May 2026 08:01:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D9F36B00D0
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:01:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 67B2E1A03FE
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:01:26 +0000 (UTC)
X-FDA: 84809430972.05.47AA827
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7293340024
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:01:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oJX1nGjW;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of luca.boccassi@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779796884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=w/qF9Y2yN8vAfbh3RrIPFK5LawrzDHFyp5ALmuYhln4=;
	b=nf0A7KRCVmj1poqDJ+naOEl3krzcwP3jX2ctLC609RYaB7bevbW4WV68gR5fDVFf7lKxtQ
	4UC3olLf2okHmiLUhKWwDWX9qTzcsJqGcT39Iqc+eLvvyvcUAKaO5xvo5aEIPeKmHUszNC
	wJFpe2UaFIaSsklkvlHMOYN47enHPCM=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oJX1nGjW;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf11.hostedemail.com: domain of luca.boccassi@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779796884; a=rsa-sha256;
	cv=pass;
	b=c9ANuAiXee+9Q566Uoe2HeongLM8WoU6+OEZ74f8en5W35LZiVIJlCi0mzBY461HTJ796R
	nFwIiQWwlnajoc0Bc0qql2V7waJXpg/KH/pb46Nqq8eQPl4uPlcJQarma8RCEAaI2R6s60
	5p73mcwUIoXOmz4KDST5eIZu3s1r/Bw=
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-65c7efdb7d8so10842215d50.3
        for <linux-mm@kvack.org>; Tue, 26 May 2026 05:01:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779796883; cv=none;
        d=google.com; s=arc-20240605;
        b=iEpQsVEDZY96JQ8MZVQFWIgNyJNrmkjJXLD2824V3d2EHIpRMR9cXTJNeu2sfISMyK
         Al475nkvqpUx53EyPClwqXQMURZryviZyWch4vwUdUjZ8guTNp+79pWdx8H4iNiTNqJf
         FVy7zcoklcdT5Z7TxoMGwYVIo+8vMRBwN8A+1inVqp8UZkBueBqGD7dHa7+z0GT1i8mr
         EK6W4o6gi7FGUvf0kGCjU5ufglS2v209oMQTzVmfXsViT8NQ7M715Tn1l4Gz3lyKlF1s
         fKtvIG1fiBvgom7vylAK8/2FsxNySGN+a712T8lkNJaTrI93C9Cl1KYWj6dJKRMUwW3g
         fnJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=w/qF9Y2yN8vAfbh3RrIPFK5LawrzDHFyp5ALmuYhln4=;
        fh=43/hm4pbyvHIG2sQzFGzXDtyACtuBDNRWITE4Pjw5Xk=;
        b=eaXMtaNDYscNiAe9P1ElrNa0o3rmxuBw1vFVH3yTEpFoMiu0XDG09H8Yc/nyKAHPst
         vVsTo3vXng3uzDHjSb0jKSMiabpUxYq1wBCiub5xrPhU6zyfG8w1+Hmc4MhBhUwgmM/O
         i9BNraI/8wVBEGN4CPNbwt814eDHWQGlJTfy+VQ475ZVbpRreU3N/2V3s3Gui/e3Xpm+
         67TtOzz7sYXuBf1463Ly9Wphz9w2NPZklDIzrgk4P9ZYyEaONHeE1Y7e98g1l07NC8Wp
         0tfGCSVJ/deXmd6A5rZj/DLWtuqnA3clvpeUNQ3JRj31Xi66s+ufTH8F7wFR3ltMPAso
         tFNw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779796883; x=1780401683; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=w/qF9Y2yN8vAfbh3RrIPFK5LawrzDHFyp5ALmuYhln4=;
        b=oJX1nGjWCEGWaLl2IM9L2rDQR/7fs246X0IBCPbfSrWxHBETJCBqtho0s++dpb4TPY
         piuvcVASGmSKHQHDvfvWuKGaebjoYJVhXhcE8bfqfHSNrbjBNpVCHePEWCppsQ3rtoD6
         KRMT2NBGq4OJ0PAi5kg2hI0lr+4bW0V+4wLhRI+c3maPG/06kGgSxOlSQ2rBShZHPRMc
         n9kNnd/XTeyRdC9eAbN1oPiaM4yXL++KSdomk+mHIkD7hsOiSziTq26Z3CJn2km0ICPj
         P4KZwCduIgeVlTGDYAe47MEjvtjir2azVAY7YxE5Rm6lnZ6tMXsfOZ5Ewu1OrvvEVkV5
         49fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779796883; x=1780401683;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w/qF9Y2yN8vAfbh3RrIPFK5LawrzDHFyp5ALmuYhln4=;
        b=RwZYmqF13OPuAxfZJCJ0xpzsMK5Dhaeht7/BJBxgBFrowoVgoWdCrEdPFCRdYeGLdN
         lvNQKiNVUqi3kweTykigzEiBkEOU2LZ+AZeV9XS6cWDFcO3ZjBOdEZHk5V2rXFbV82d0
         CRokdOqFafdLCtujcvxPQ5hGjA3jxfJuAGyxwSIE06g8EEQOU2DzVLiE8/NbJHifMNNm
         AjigevNXm3rjQthIPSkkh1BVDjRAxXWz8N8nvFXUFog/awdtTWzEGw9uuloAwvlrqb9u
         fp0lYtk53Gl7dbHU3Un58LuOpEKfTe/Rp6Ld8YrxdtQlldLy1UK9Z3PRLxrciNFDKOHN
         yM+w==
X-Forwarded-Encrypted: i=1; AFNElJ8y+yKvNUtJ4CYkCcNOGoBTtkZwJq6bJ47nGhUCXoFLy3mcvwxrTh1+BvDRpclb2dwoeh7KVmpRgw==@kvack.org
X-Gm-Message-State: AOJu0YzSG4ljnrbOlhTpdQiTKpTiFuJmNtZMjJyX/zVZa/mz2hJKSJRh
	QZF3VMK1afse8ER9RN5fFmS7GO4ecPujXRkrNZxAtjh2Zdv3cuMkvda9hnLOprZWDy6O7pWYwj0
	AA6j1OKcLTNO9p2VjyejS6NMJP2pQALs=
X-Gm-Gg: Acq92OHKxcUBoPhmhpowIxMXTYa43S4Fidg6zO6k2PryGhUvc2F4sm78IEV+xmPzs23
	uAfnbp8abj5QhEi0OplxYa664rTCIfL5mDnMqTBpBGFHppNzQ7nxVYMWxP61kQYXSFc8z4yO8G/
	aJcBlMRuFpf3SSzZYf4I1l86DMcoBBiLFSfmVni7YhpBvY+cEwO3IdZ/tsklbhrF/CkjExK0J2u
	txRv3UKAHHre9PmzdPM7LdIhCs+jWXFySmRYTWNAK+kXwj3qE6rubgYNg5hj7LyS+yZwfzy6b6A
	xp8tqRH2eLDbE8c9qQAIwiwekfrh4hRfHyxK906QiqkGW+C1u0T3
X-Received: by 2002:a05:690e:440b:b0:654:a000:94c0 with SMTP id
 956f58d0204a3-65ec9639cc6mr13512457d50.5.1779796882512; Tue, 26 May 2026
 05:01:22 -0700 (PDT)
MIME-Version: 1.0
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Tue, 26 May 2026 13:01:11 +0100
X-Gm-Features: AVHnY4IecFYuqDLGqiirwU4wwgprvlSe6_3qGLkAaXavpqxYHrR0vACTJJsPcAQ
Message-ID: <CAMw=ZnSaVSzn1RGtiNRG+iNj8M1e12rZtA98i4jL8jYP5UyzWg@mail.gmail.com>
Subject: Occasional 'WARNING: mm/backing-dev.c:636 at cgwb_release_workfn'
 when running mdadm
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Cc: Mike Rapoport <rppt@kernel.org>, Christian Brauner <christian@brauner.io>, regressions@lists.linux.dev, 
	Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ye8m33sej9o3a5kyqoshnuns1pdpe4uf
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7293340024
X-Rspam-User: 
X-HE-Tag: 1779796884-26760
X-HE-Meta: U2FsdGVkX1/zqzHwkhUVr7nwlV4hgxdv5DFEdJT8/JHzlBfW6GEReTnwY3xk4RUhCmb/wBPVb9t5pDX/r2UgH3+X5gZAQQl6DAg1MBhpVo2PDokWgi8ZxnJ+y+6bJVqxOtNFNcaDb1U432hEdWzjXFhyTHStM6KTM7j0RyK5JZEtXYNbFSwW1Aa7d+7SYDyLS9szLOh9yDHeoLfZmj4Lezo0XaYREtJiPecol7RKmaEUp+XIyXJNWpxZVbh3hWMXFlUX1k99t9C5FJvUlpYXJAD3dqTOARJD8SvOQPcEPRZeCIWzrg/m8TTGrcW4qR3k/OEXE5fbwEHvmGqwEAyPuJ5hkwZ1hK12cmDUAPB8Wm5gueZAKyYw1TNEMvHcBT6o+sgO0/p5RZcRzDCyk8EOqeQ9O/0VKlYJJhXsBMdP/2TwmntDSBwXJb67mAIt/tzffe6jgMhW6Q5GF2K875hmKdeCsCI3ylqft5PnnYV1G98JcUgxQADoj9HD9izwfueDbJIYU6qLn0vyA+nj7AsW/LGiA6MuKdnGc9FAjtKCJQgh6N/1fRCO7AJU08MiUV3YOAG68hfOwq2CKgfLP/HSHJqC/KLQcRNaBljo7EfGLKVwlZqCUgmBEkQqkzY/RrJuuisNyS+KiG1kNaFUVgxHs2KeVRFIFC11cIqWCVbnbKGi3qxht1ZnDRjTUqkY/i7wqZVuljGhRywO0ZRUIXCBtVunYccqS0Mmc8zKz06TTeKz9z7dLVa+Q1NokUfM4CnMwYpAZjzELh5on8xFHW1QFQ/p79r6uTKZV5maQbQxiqT+mUOQooofdJ+vyq6J+WOXQm1myrajoJ5tTWVG/8G+0DZEcKYphXcif+zzF8WjLbGgR6x53qyNzEMqfZCTCbB0lMIS0tEmymBlEuvhk34w3VAzuzR5YXg2OgfgVjhsuBM7WhcC4BOspZn7c4vmRNbMZjck/dY72hXAqLMtRzO
 JJUBPugw
 4qIxx6s7a/glisv5KVyIB13zZZfRrfWTZDPMoTksuqXcju24Iy56OpCuRdHClZL2SvyAZg+jcMEcw6Ih0nrxTQWijboHY2kF2sXSPegrD+kdXbIfecBrlTpTC0hdmliHrKRFuqBc91RMV2sTl6CnqBSeUbAHNASzsaKCQBJbKu8RI3No9S+s2haggwRH7//D2+KY9JNIjoXp8ycZkrQpM1qAf5R8CINy8WAf6ZuyAnpWrlXEP31l1BcDAL/G4vURkaLTOTkHObc40FsshXPG1ohzobp29kRRAmINwlXJijGJ7X+CidREEAoTNLHVERIDlNta5wkO6ulWtVJ5wyulrie5OKZ0w2Z2ZIrFjzCUQCaBFuZAOTB5Qhd0n0Vuk9kX6EuNkj7EbwqFelRcw9UoRk5G1rNeBu4ihsz/H7PQU645XXjqjWy8tTbK3SxaNsJEuBll4u6jC9+zK8jABrdXT25ByQsogqsL2oxmK7RnPBQPLZMAQgqmK+scY817yqik/cB4q54yJwn9qM77ZfBk/RLHcBreQW/VTi0bS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, I've been told to report this here.

In our CI test that runs some mdadm commands we occasionally (maybe 1
in 100 runs, not reproducible manually) see the following kernel warn:

[ 15.769393] TEST-64-UDEV-STORAGE.sh[245]: + mdadm -v --stop /dev/md/mdparity
[ 15.786033] ------------[ cut here ]------------
[ 15.788632] !list_empty(&wb->b_attached)
[ 15.788634] WARNING: mm/backing-dev.c:636 at
cgwb_release_workfn+0x142/0x1f0, CPU#0: kworker/0:1/11
[ 15.789235] Modules linked in: raid456 async_raid6_recov async_memcpy
async_pq async_xor async_tx raid1 intel_rapl_msr intel_rapl_common
kvm_amd ccp kvm joydev iTCO_wdt irqbypass mousedev intel_pmc_bxt
ghash_clmulni_intel vfat i2c_i801 fat aesni_intel psmouse i2c_smbus
intel_agp lpc_ich pcspkr i2c_mux virtio_balloon intel_gtt serio_raw
mac_hid tun md_mod dm_mod qemu_fw_cfg vsock_loopback
vmw_vsock_virtio_transport vmw_vsock_virtio_transport_common vsock
virtio_rng
[ 15.790846] CPU: 0 UID: 0 PID: 11 Comm: kworker/0:1 Not tainted
7.0.10-arch1-1 #1 PREEMPT(full)
b38726df0ec1c5aec6f05d4eab858505a5944d02
[ 15.791457] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
Arch Linux 1.17.0-2-2 04/01/2014
[ 15.791842] Workqueue: cgwb_release cgwb_release_workfn
[ 15.792166] RIP: 0010:cgwb_release_workfn+0x142/0x1f0
[ 15.792411] Code: f6 43 d8 01 75 2c 48 83 c4 08 48 89 df 48 c7 c6 00
b2 a8 ba 5b 5d e9 0d 5d dc ff e8 f8 fd ff ff 48 8d 43 b8 48 39 43 b8
74 d6 <0f> 0b f6 43 d8 01 74 d4 0f 0b eb d0 48 89 04 24 e8 69 e6 db ff
48
[ 15.793129] RSP: 0018:ffffccd280063e50 EFLAGS: 00010293
[ 15.793401] RAX: ffff89eecbae4eb8 RBX: ffff89eecbae4f00 RCX: 0000000000000008
[ 15.795755] RDX: ffff89eecbae4d80 RSI: 0000000000000202 RDI: ffff89eecae8a040
[ 15.796172] RBP: ffff89eecae8a000 R08: 0000000000000001 R09: ffffccd28018e010
[ 15.796560] R10: 0000000000000001 R11: fefefefefefefeff R12: ffff89ef3bc322c0
[ 15.796889] R13: ffff89eec083c405 R14: 0000000000000000 R15: ffff89eecbae4f00
[ 15.797298] FS: 0000000000000000(0000) GS:ffff89ef7e367000(0000)
knlGS:0000000000000000
[ 15.797637] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 15.797961] CR2: 000055cd8ab1d960 CR3: 0000000109878004 CR4: 0000000000370ef0
[ 15.798319] Call Trace:
[ 15.798454] <TASK>
[ 15.798572] process_one_work+0x19c/0x3a0
[ 15.798732] worker_thread+0x1b1/0x310
[ 15.798896] ? __pfx_worker_thread+0x10/0x10
[ 15.799164] kthread+0xe1/0x120
[ 15.799330] ? __pfx_kthread+0x10/0x10
[ 15.799536] ret_from_fork+0x2bc/0x350
[ 15.799713] ? __pfx_kthread+0x10/0x10
[ 15.800486] ret_from_fork_asm+0x1a/0x30
[ 15.800666] </TASK>
[ 15.800795] Kernel panic - not syncing: kernel: panic_on_warn set ...
[ 15.801089] CPU: 0 UID: 0 PID: 11 Comm: kworker/0:1 Not tainted
7.0.10-arch1-1 #1 PREEMPT(full)
b38726df0ec1c5aec6f05d4eab858505a5944d02
[ 15.801553] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
Arch Linux 1.17.0-2-2 04/01/2014
[ 15.801863] Workqueue: cgwb_release cgwb_release_workfn
[ 15.802060] Call Trace:
[ 15.802161] <TASK>
[ 15.802264] dump_stack_lvl+0x5d/0x80
[ 15.802440] vpanic+0x20a/0x410
[ 15.802568] ? cgwb_release_workfn+0x142/0x1f0
[ 15.802761] panic+0x6b/0x70
[ 15.802905] check_panic_on_warn.cold+0xf/0x1e
[ 15.803082] __warn.cold+0xa7/0x10c
[ 15.803204] ? cgwb_release_workfn+0x142/0x1f0
[ 15.803361] __report_bug+0x93/0x110
[ 15.803492] ? cgwb_release_workfn+0x142/0x1f0
[ 15.803681] ? cgwb_release_workfn+0x142/0x1f0
[ 15.804541] report_bug+0x29/0x70
[ 15.804701] handle_bug+0x167/0x360
[ 15.804862] ? cgwb_release_workfn+0x142/0x1f0
[ 15.805096] exc_invalid_op+0x1d/0x90
[ 15.805255] asm_exc_invalid_op+0x1a/0x20
[ 15.805449] RIP: 0010:cgwb_release_workfn+0x142/0x1f0
[ 15.806398] Code: f6 43 d8 01 75 2c 48 83 c4 08 48 89 df 48 c7 c6 00
b2 a8 ba 5b 5d e9 0d 5d dc ff e8 f8 fd ff ff 48 8d 43 b8 48 39 43 b8
74 d6 <0f> 0b f6 43 d8 01 74 d4 0f 0b eb d0 48 89 04 24 e8 69 e6 db ff
48
[ 15.807217] RSP: 0018:ffffccd280063e50 EFLAGS: 00010293
[ 15.808511] RAX: ffff89eecbae4eb8 RBX: ffff89eecbae4f00 RCX: 0000000000000008
[ 15.808785] RDX: ffff89eecbae4d80 RSI: 0000000000000202 RDI: ffff89eecae8a040
[ 15.809056] RBP: ffff89eecae8a000 R08: 0000000000000001 R09: ffffccd28018e010
[ 15.809397] R10: 0000000000000001 R11: fefefefefefefeff R12: ffff89ef3bc322c0
[ 15.809687] R13: ffff89eec083c405 R14: 0000000000000000 R15: ffff89eecbae4f00
[ 15.809978] process_one_work+0x19c/0x3a0
[ 15.810154] worker_thread+0x1b1/0x310
[ 15.810325] ? __pfx_worker_thread+0x10/0x10
[ 15.812450] kthread+0xe1/0x120
[ 15.812594] ? __pfx_kthread+0x10/0x10
[ 15.812738] ret_from_fork+0x2bc/0x350
[ 15.812878] ? __pfx_kthread+0x10/0x10
[ 15.813026] ret_from_fork_asm+0x1a/0x30
[ 15.813179] </TASK>
[ 15.813607] Kernel Offset: 0x39400000 from 0xffffffff81000000
(relocation range: 0xffffffff80000000-0xffffffffbfffffff)

I don't have hard data for when it started, but I don't think I've
seen it for more than a couple of months tops. This one was on 7.0.10
on Arch, but I think I've seen it on Rawhide too.

The test script that triggers it:
https://github.com/systemd/systemd/blob/d096763827718083918244eb3b7796bf27876d56/test/units/TEST-64-UDEV-STORAGE.sh#L1191

Is this a known issue? Thanks

-- 
Kind regards,
Luca Boccassi

