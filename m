Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1748CCD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 14:14:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0602D6B00CC; Tue, 26 May 2026 10:14:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 010F96B00CF; Tue, 26 May 2026 10:14:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E41B36B00D2; Tue, 26 May 2026 10:14:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFC496B00CC
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:14:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9B2691C14AF
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:14:14 +0000 (UTC)
X-FDA: 84809765628.09.5CFFCD0
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7DD96A0013
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:14:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uKChdlCK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WP343+IE;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uKChdlCK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WP343+IE;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779804852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=By6pq7mzk8rDa4F1mBhamlz3pyk/MIS4amE39vNRXPM=;
	b=D8LL4NRUluDioOPZr1B4M2CkPt6a2BwiTFocfKK3w/8Z3e45LaXmpzARN9t6PPTas/MfBM
	Wlnc10E2GZ/TdTaVxLDBF/Oknb/lWk5zOR6y/uTXHLoLkY2P2TJ2Idz+RXvyZmi3ra1F9A
	FtDftSQ2y7BLjbOGswR8K8Hzvxh9qk4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uKChdlCK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WP343+IE;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=uKChdlCK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WP343+IE;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779804852; a=rsa-sha256;
	cv=none;
	b=rpx1DTqZ7B9l201ZbOsQjRK0UD83wZPPqOOJvsdwCThYjmx/0nTeWwBnkOPfZN5BLLTxkK
	lMQauZ8JtobF2prozv5h7y5tPQZbqvl2te4IARgMGThVLc0yos7LjuWV8VJyOyV7qBnrBN
	zeoOPnIFWKF1D2SY66T5KZ9bfktkH9g=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 139696B43C;
	Tue, 26 May 2026 14:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779804851; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=By6pq7mzk8rDa4F1mBhamlz3pyk/MIS4amE39vNRXPM=;
	b=uKChdlCKQQ6v+gq+ibbh5cMuS/wybmtH2KcSezWr2Rij3M5WMic//ffVffC+H+Yc582SS2
	C6qgRkHKhIsJhwIZIJHFOTw76gegJTvToMZPU41YvjfwsyEGVVkrWJYSG9HTnWTfhbaM4l
	hujHi8A29MK7loCglDoVtUI8By+go74=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779804851;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=By6pq7mzk8rDa4F1mBhamlz3pyk/MIS4amE39vNRXPM=;
	b=WP343+IEAQcsH8w01xqJgSm3nQWx7qHkEBJfcAU/DIa9aJfBXmKjtvlKi5nH0Q+9AVmeSW
	IROd5pU1ZL683ADA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1779804851; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=By6pq7mzk8rDa4F1mBhamlz3pyk/MIS4amE39vNRXPM=;
	b=uKChdlCKQQ6v+gq+ibbh5cMuS/wybmtH2KcSezWr2Rij3M5WMic//ffVffC+H+Yc582SS2
	C6qgRkHKhIsJhwIZIJHFOTw76gegJTvToMZPU41YvjfwsyEGVVkrWJYSG9HTnWTfhbaM4l
	hujHi8A29MK7loCglDoVtUI8By+go74=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1779804851;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=By6pq7mzk8rDa4F1mBhamlz3pyk/MIS4amE39vNRXPM=;
	b=WP343+IEAQcsH8w01xqJgSm3nQWx7qHkEBJfcAU/DIa9aJfBXmKjtvlKi5nH0Q+9AVmeSW
	IROd5pU1ZL683ADA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F15C95A248;
	Tue, 26 May 2026 14:14:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HAvlOrKqFWqUIAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 26 May 2026 14:14:10 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 87A63A0EB6; Tue, 26 May 2026 16:14:06 +0200 (CEST)
Date: Tue, 26 May 2026 16:14:06 +0200
From: Jan Kara <jack@suse.cz>
To: Luca Boccassi <luca.boccassi@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Mike Rapoport <rppt@kernel.org>, Christian Brauner <christian@brauner.io>, 
	regressions@lists.linux.dev, Jan Kara <jack@suse.cz>
Subject: Re: Occasional 'WARNING: mm/backing-dev.c:636 at
 cgwb_release_workfn' when running mdadm
Message-ID: <mcm5gloab3zt5duszhtk4p472rsvmrhnesocg2n3kghqunwd5n@2izhebvb2gvo>
References: <CAMw=ZnSaVSzn1RGtiNRG+iNj8M1e12rZtA98i4jL8jYP5UyzWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMw=ZnSaVSzn1RGtiNRG+iNj8M1e12rZtA98i4jL8jYP5UyzWg@mail.gmail.com>
X-Stat-Signature: czffnf7c4iytrmauoyq3fwoz54b9fc4b
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7DD96A0013
X-HE-Tag: 1779804852-595250
X-HE-Meta: U2FsdGVkX19Tqj4I/dEywMNvzqE/lNz0tF7Tgvtx+xS+dcO63w5+85qRUSbGo8W2eCeeud8UYUGou2DIZ5aKIL1bVG4mP+W7sg+ZZlN9v++wmdHsK4zYsqQcFHNKwdLeYLLTq3nxFfIpOmfen2O3Y8WnpdeMYncMrCEPV1/x6MkJ5RHxkaLeeIeA+UbQ+1qaHz7HzEllRGil95JnUMQG3bEMu6w9LKDAC7CRAhghQPeajjjlxQgSs3p3GU888omttr7Tn3oaVIKgbr09NYrE9Hka6Z/X7omGexKl+kiXxkoP5xnNs4FW7s8Quj7CsdyJnW8qtCfVTOfSondWihzb/ANzj2YLKIMh02AIVO8JJbSt6Tv8tO10zSvb0EsLng6pfJKGuiKdswo6qnqzuCVbKfTb95PpUZzZ2QzfjbQNl4e5sz+LmL1VhGT9davRz+MpYb4RWxz3V7m+VD+K2vxEm/1IJLRJeagW+XIYtHTFWg/Bs786IgC810agCGh4KABB/IuGQs7BULuEXWMvA3LceumHondm1mR9IW1y/i3DqaDxwW43kdeh84zihLEYqnbMvbTo94cv7sK2ZyeH+TgvHdHmhMsj3yD+cVTQplLgDKvElY3Kn9knBnul59y1JnOKQXe864ViCx2UA3k6t3yrR/PvhE2aM2Ywyys5O55GidX8ZKIiZFXjvVMX5Pv7dgAOKVbqC8yE30U9l7OodNCbB/TJZlwn5dcQN5gbKu6CDaj448lrEER+B5pJlLE7n+/uUIemf4NoLHx99BAfjbpp47OOk3GgdgWHPg3ljxF9zemiFHxkwTmLZ9mdcCkp3eISnEiMWiTO8w8jTxB9g7O7HD/1WZecEWrge4u78cQU5Y5LsyMVwRcVl80fKXS91/nd4KneGnLD6zJOBaQBHqkXsoh3XpEQp1mvRR3lXFNJ30W4uTkb+vscrHaTrTM01IJsU6XvK799ZusySW0L0hi
 p77R83lC
 3qz8MRI4php5GDAdfhbZRo7MDJPtbmOwCHRdv2F6euF3w1xer9QTSFuncyAgTrHpulNJvw9F/i3fBnYNORILPQe5gMklMau6QEnN4xQdXbL1Uu3I2+4rO2Zcp5OFBZAtbEtPe0JCkja88KQyUPyosdmjJUMcR4BBCaMOqm0YfYXK5ZQAisyeQijJ4JsfQ9OzOs6luSWtkE+91Yalf7azxNpaTHmAMUfQ1qKT56GPEpnp3ysc1DZDxdhTQSPUSjHHpIF1B5FPNYGMZRmlvIOJpFKbbiOdcE2n9GaVWjLqFn+ZfIjoklMBobJUC068UhsckwKW+Ic2Di7hO7EdLjVIO2rUimlIFdvXH2istjC7sK3RF97DkoC1o341QYopcGyB2nU5X716j/RYCXcvAmFt6OVsxlBdH302AgUq1nFy5WDDeYb2EfjMgJpAIUCUNOp+a9ry7bQPno6vh/pRO9LY81m05DqKkl7FIwTuG8OYdODxeR1kdR4QWfmKUDO06hqkFvRzFjX+QG9RE0xhvSeyFvgojPk6yQgC2jv/D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi!

On Tue 26-05-26 13:01:11, Luca Boccassi wrote:
> Hi, I've been told to report this here.
> 
> In our CI test that runs some mdadm commands we occasionally (maybe 1
> in 100 runs, not reproducible manually) see the following kernel warn:
> 
> [ 15.769393] TEST-64-UDEV-STORAGE.sh[245]: + mdadm -v --stop /dev/md/mdparity
> [ 15.786033] ------------[ cut here ]------------
> [ 15.788632] !list_empty(&wb->b_attached)
> [ 15.788634] WARNING: mm/backing-dev.c:636 at

Thanks for report! Interesting. I haven't seen this yet but I suspect my
rework of cgwb inode switching (happened in 6.18) could be responsible for
this.

Since the 7.0.11 kernel we've got a couple of fixups to this code. In
particular 6689f01d6740 ("writeback: Fix use after free in
inode_switch_wbs_work_fn()") and now also fixes sitting in
https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/log/?h=vfs-7.2.writeback

Your script seems to be exercising mount/umount so the above fixes could
indeed be related to your problem. If you can run with a kernel built from
the above branch, it would be great if you can verify the problem got
indeed fixed.

								Honza

> cgwb_release_workfn+0x142/0x1f0, CPU#0: kworker/0:1/11
> [ 15.789235] Modules linked in: raid456 async_raid6_recov async_memcpy
> async_pq async_xor async_tx raid1 intel_rapl_msr intel_rapl_common
> kvm_amd ccp kvm joydev iTCO_wdt irqbypass mousedev intel_pmc_bxt
> ghash_clmulni_intel vfat i2c_i801 fat aesni_intel psmouse i2c_smbus
> intel_agp lpc_ich pcspkr i2c_mux virtio_balloon intel_gtt serio_raw
> mac_hid tun md_mod dm_mod qemu_fw_cfg vsock_loopback
> vmw_vsock_virtio_transport vmw_vsock_virtio_transport_common vsock
> virtio_rng
> [ 15.790846] CPU: 0 UID: 0 PID: 11 Comm: kworker/0:1 Not tainted
> 7.0.10-arch1-1 #1 PREEMPT(full)
> b38726df0ec1c5aec6f05d4eab858505a5944d02
> [ 15.791457] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
> Arch Linux 1.17.0-2-2 04/01/2014
> [ 15.791842] Workqueue: cgwb_release cgwb_release_workfn
> [ 15.792166] RIP: 0010:cgwb_release_workfn+0x142/0x1f0
> [ 15.792411] Code: f6 43 d8 01 75 2c 48 83 c4 08 48 89 df 48 c7 c6 00
> b2 a8 ba 5b 5d e9 0d 5d dc ff e8 f8 fd ff ff 48 8d 43 b8 48 39 43 b8
> 74 d6 <0f> 0b f6 43 d8 01 74 d4 0f 0b eb d0 48 89 04 24 e8 69 e6 db ff
> 48
> [ 15.793129] RSP: 0018:ffffccd280063e50 EFLAGS: 00010293
> [ 15.793401] RAX: ffff89eecbae4eb8 RBX: ffff89eecbae4f00 RCX: 0000000000000008
> [ 15.795755] RDX: ffff89eecbae4d80 RSI: 0000000000000202 RDI: ffff89eecae8a040
> [ 15.796172] RBP: ffff89eecae8a000 R08: 0000000000000001 R09: ffffccd28018e010
> [ 15.796560] R10: 0000000000000001 R11: fefefefefefefeff R12: ffff89ef3bc322c0
> [ 15.796889] R13: ffff89eec083c405 R14: 0000000000000000 R15: ffff89eecbae4f00
> [ 15.797298] FS: 0000000000000000(0000) GS:ffff89ef7e367000(0000)
> knlGS:0000000000000000
> [ 15.797637] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 15.797961] CR2: 000055cd8ab1d960 CR3: 0000000109878004 CR4: 0000000000370ef0
> [ 15.798319] Call Trace:
> [ 15.798454] <TASK>
> [ 15.798572] process_one_work+0x19c/0x3a0
> [ 15.798732] worker_thread+0x1b1/0x310
> [ 15.798896] ? __pfx_worker_thread+0x10/0x10
> [ 15.799164] kthread+0xe1/0x120
> [ 15.799330] ? __pfx_kthread+0x10/0x10
> [ 15.799536] ret_from_fork+0x2bc/0x350
> [ 15.799713] ? __pfx_kthread+0x10/0x10
> [ 15.800486] ret_from_fork_asm+0x1a/0x30
> [ 15.800666] </TASK>
> [ 15.800795] Kernel panic - not syncing: kernel: panic_on_warn set ...
> [ 15.801089] CPU: 0 UID: 0 PID: 11 Comm: kworker/0:1 Not tainted
> 7.0.10-arch1-1 #1 PREEMPT(full)
> b38726df0ec1c5aec6f05d4eab858505a5944d02
> [ 15.801553] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
> Arch Linux 1.17.0-2-2 04/01/2014
> [ 15.801863] Workqueue: cgwb_release cgwb_release_workfn
> [ 15.802060] Call Trace:
> [ 15.802161] <TASK>
> [ 15.802264] dump_stack_lvl+0x5d/0x80
> [ 15.802440] vpanic+0x20a/0x410
> [ 15.802568] ? cgwb_release_workfn+0x142/0x1f0
> [ 15.802761] panic+0x6b/0x70
> [ 15.802905] check_panic_on_warn.cold+0xf/0x1e
> [ 15.803082] __warn.cold+0xa7/0x10c
> [ 15.803204] ? cgwb_release_workfn+0x142/0x1f0
> [ 15.803361] __report_bug+0x93/0x110
> [ 15.803492] ? cgwb_release_workfn+0x142/0x1f0
> [ 15.803681] ? cgwb_release_workfn+0x142/0x1f0
> [ 15.804541] report_bug+0x29/0x70
> [ 15.804701] handle_bug+0x167/0x360
> [ 15.804862] ? cgwb_release_workfn+0x142/0x1f0
> [ 15.805096] exc_invalid_op+0x1d/0x90
> [ 15.805255] asm_exc_invalid_op+0x1a/0x20
> [ 15.805449] RIP: 0010:cgwb_release_workfn+0x142/0x1f0
> [ 15.806398] Code: f6 43 d8 01 75 2c 48 83 c4 08 48 89 df 48 c7 c6 00
> b2 a8 ba 5b 5d e9 0d 5d dc ff e8 f8 fd ff ff 48 8d 43 b8 48 39 43 b8
> 74 d6 <0f> 0b f6 43 d8 01 74 d4 0f 0b eb d0 48 89 04 24 e8 69 e6 db ff
> 48
> [ 15.807217] RSP: 0018:ffffccd280063e50 EFLAGS: 00010293
> [ 15.808511] RAX: ffff89eecbae4eb8 RBX: ffff89eecbae4f00 RCX: 0000000000000008
> [ 15.808785] RDX: ffff89eecbae4d80 RSI: 0000000000000202 RDI: ffff89eecae8a040
> [ 15.809056] RBP: ffff89eecae8a000 R08: 0000000000000001 R09: ffffccd28018e010
> [ 15.809397] R10: 0000000000000001 R11: fefefefefefefeff R12: ffff89ef3bc322c0
> [ 15.809687] R13: ffff89eec083c405 R14: 0000000000000000 R15: ffff89eecbae4f00
> [ 15.809978] process_one_work+0x19c/0x3a0
> [ 15.810154] worker_thread+0x1b1/0x310
> [ 15.810325] ? __pfx_worker_thread+0x10/0x10
> [ 15.812450] kthread+0xe1/0x120
> [ 15.812594] ? __pfx_kthread+0x10/0x10
> [ 15.812738] ret_from_fork+0x2bc/0x350
> [ 15.812878] ? __pfx_kthread+0x10/0x10
> [ 15.813026] ret_from_fork_asm+0x1a/0x30
> [ 15.813179] </TASK>
> [ 15.813607] Kernel Offset: 0x39400000 from 0xffffffff81000000
> (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
> 
> I don't have hard data for when it started, but I don't think I've
> seen it for more than a couple of months tops. This one was on 7.0.10
> on Arch, but I think I've seen it on Rawhide too.
> 
> The test script that triggers it:
> https://github.com/systemd/systemd/blob/d096763827718083918244eb3b7796bf27876d56/test/units/TEST-64-UDEV-STORAGE.sh#L1191
> 
> Is this a known issue? Thanks
> 
> -- 
> Kind regards,
> Luca Boccassi
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

