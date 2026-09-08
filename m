Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C9DDC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 02:38:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 398816B008C; Mon,  7 Sep 2026 22:38:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 371B96B0092; Mon,  7 Sep 2026 22:38:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AE436B0093; Mon,  7 Sep 2026 22:38:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0135D6B008C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 22:38:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9069340396
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:38:15 +0000 (UTC)
X-FDA: 85189035750.14.26403EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id E456114000F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:38:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uTPULx+T;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788835089;
	b=7UpHBksYmqcMZitvV2Akp9GXtfHV1tKpBQwRvP/3LGnY2kmFoVujSpYDmJ6PguDm6GVUkj
	ztxw0OROaOsse6grAI50y2iVS6msgrFa23qyLmuafVxBMr1MX5UBDPpBqZDKyv/YzGJOoz
	ukjxJrI2IIq5+XZc1olVnkj0f2OgDfI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uTPULx+T;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788835089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=efZgJABcoG5ggDnZhAKLlrjhxD8FD9hOCVM7mhQeFpU=;
	b=Nk5AWDdbabOdb5vLy5m5TdUYHBgNpSMBnmJdP51NDvl4tcpjkp0YQUJxiFCQYu6su0t3+P
	D1YPduOKwIrNuyN5hihQO8pkz/iMB5nXTdb6ih/veMPqpwrBsgP6tSwFNsCrP/oWO+6i85
	7sHVkZW2r5kIMZzcJ6fqLSTGnQZv6T0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 26580602D1;
	Tue,  8 Sep 2026 02:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 617D11F00A3A;
	Tue,  8 Sep 2026 02:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788835087;
	bh=efZgJABcoG5ggDnZhAKLlrjhxD8FD9hOCVM7mhQeFpU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=uTPULx+T8gxPX+bbiKHFilFF9EHAF5AWTvUS7p8r95JPYvApttPFOFq1Q9LEjEnAj
	 szCy4LqZA05c07jaZhRlFjp7TftqHtTtWLy7c9Z364JLL/EmNXQ1q6NF5z0FAU9IqE
	 g2oS/XYfXxYGZxjyaluL3wXd8edItcIwC69DoRZQ=
Date: Mon, 7 Sep 2026 19:38:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+23b25ba3c6bf971f9c57@syzkaller.appspotmail.com>
Cc: baohua@kernel.org, baoquan.he@linux.dev, chrisl@kernel.org,
 kasong@tencent.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 nphamcs@gmail.com, shikemeng@huaweicloud.com,
 syzkaller-bugs@googlegroups.com, youngjun.park@lge.com
Subject: Re: [syzbot] [mm?] WARNING in swap_put_entries_direct
Message-Id: <20260907193806.3f562237942e4156c3d4d53e@linux-foundation.org>
In-Reply-To: <6a9f6350.6e6c5f9e.28f11f.0005.GAE@google.com>
References: <6a9f6350.6e6c5f9e.28f11f.0005.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: pb6honyqw1af87rz9rs7wm5rwfyf7gys
X-Rspamd-Queue-Id: E456114000F
X-Rspamd-Server: rspam06
X-HE-Tag: 1788835088-282463
X-HE-Meta: U2FsdGVkX1/r3JtwVKY5Z/AvqvplMw0PqF4VHoeIpmi0Z+GANfCXUmflQ8xYlzOjImgi/sARD4iStF1Z01XXiJ2xoU0on4ckc5rpiIYRycfLyOWkmGp6gqXeKh4WN5SghBppFFvmQgItpPsenTLvj8h21ytEKygHBLqDuK0uiKmy3VvAnpelDmU9iM0/GbXMm7QdJ0fCwFVIZBYFsMeF2j2btX1hxq/s7RKoRAkUFXTR3D+PYdwkZc3lOg9h30X4C1ZLnnRtEkZ5kDJjEKvyeZs/MvfrIGrMwjvEA8AE1qE++gs1OKpy/D3+zqJ40Pzenh66KPIf389SIxKAL+/P1PMcprBt9iy7Qm6j1Lc8PUS3uNmeBHDoojahhsK77gH+z8G5c4EyQ9ZcWeW4JYKcjg3DD1v4EvwpzCmGEU4AQSC8ZLY7V/2uUcqPGp5qtfjkMt3qDfWNQ5mzY7P3e6+wLr6nmQPhJrm3wDmoB0v8oJSOYqs2cd/vZN3qVz2TDe1Rb05i9AFSf/1TI4nU8hxWZFuCXyz1Jo+4ef5Rz6YA3j7xvgJL7t272DXbzolCEEXLZS4KjyYi3j6EGerRm1hnGWG3bQsYNYh6VtdnPIvTRtlZ+pb+QTTCdH+QG0K2/3szJznjfg1RsawodvAvxuTC0ssI2sEA2ZrqIgKY9bvsxZ3r6UPiiS+wAWAEE8TWGN7HDZkuOBvAlaFqdRnA4i25OBtI2UV2MOhMpF8rmQF//8C1PL7RU2hy2hOsw6thdzfv1HcFHlLxHA8QmsjwnpSFUSCLiLjik5owsNMvGQ6Q8rNopbB1mpQr75k3+B4km/I9tUCoE4yHB0kcXZ+N833wjJi5P1UwutpwaUr18oiK2jQkYnVq8k5BJfJ1VfSs7e2pgQ7GvsKuMNOopJiaoJEH52arZAd92ot+3TStUCmlDZ0WmpPdt55xGxQHypIOXV4YMgtzwaVh9zhv+JMesPY
 xGL3LUMA
 08k3swNcNzXwZEuhFSaSWyuFqc8cRPvg3aTPmfuPZWlV7kIsyI/JOX8FKv8T31/yotNL/XpqD40HBt9Lbs13GrKHUKa2FA6cBe6TM0Pkpj1vOpr/Pd5HRzTcEXk/e+w19Qxbm5JSTVJVMEh8v0c0NTF/5+um0v7b9yePad3g34aSLzHZbvdrJb0zPKXBC+alj20k3S3wjaAdc2B60aY47A7XSwnmLkf3f31SMicu9r3iOz3kp4tRRkaDINevqvb0NsjS0ETRkn/jfMEBtptSqOpvhI5xT3pdRaFM9g+2iRhRBmqcSEQGlK5IhSjsFLrDFvfIcd76/BCT2ynDtMW4p0R86H3YHmXb6TxNnoGzKasD8rh/jMnKv9j8JRHXygnLy4TOBe0CHJWb2reGl32kJUl5h7NUTtB7Kqk0A9QJDpxGT5PSKnd6JyQFbSvKan5U3YIsbHya5c8WBMVtwsHHOZuUjIH8xXM1Oa9eSJmVSt890RjhSNRdxIOpXkdvyyDDjMxLDRT84RtnKFpQHL6P0GZIkbdZJ+z2VCHPmvZg92Tf7A/1SKea4EBjdaXFyT2gstFAafCmNIf+MbaYGjDUzmaVcR0Yy/4ZyupD79hwYW7QmA6807ierjdll29mq2ykShA7bgpPIwClS5h7qUsDexIRtN9ju64Nu3FOBZtxNclqPSMVwMWf4Za3WSf4raBjuBfcsEVgH7KicB75qwPysiDy4bthbR4LX82qJHC5YV3FCR53FWnZJ7DoJz7p1WXLMuOoVWeul4SZFTQEJ0AHzydZt4jlXrpizSVuByaZlhsB2ncCaoMZAjqQ/cC+3ca6F48v652KJ11AEjYmhF690vgWaFhZFoIJZauuHQQ6hPt6QmJ9Jgccs0Rvwu1+9jCw+GXO8plXrdcYJWcuVBomEktkMSPFi4DrbSiEM4uB9Mj+x06dga5u8A/ymu3UqYAQrb6WNASbJw7PxIzJkv7rfefL3uEFB
 1wuLPd3Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 07 Sep 2026 18:22:24 -0700 syzbot <syzbot+23b25ba3c6bf971f9c57@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    8ab1afb2eb24 Merge tag 'for-7.3/dm-fixes' of git://git.ker..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1034a125580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=85bc5cc2fc7394d9
> dashboard link: https://syzkaller.appspot.com/bug?extid=23b25ba3c6bf971f9c57
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> userspace arch: i386
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-8ab1afb2.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/4767b33b6704/vmlinux-8ab1afb2.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/aa0bdf390bbc/bzImage-8ab1afb2.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+23b25ba3c6bf971f9c57@syzkaller.appspotmail.com
> 
> get_swap_device: Bad swap file entry 7c00000000000002

hm, thanks.

https://syzkaller.appspot.com/x/log.txt?x=1034a125580000 reveals a huge
storm of I/O errors:

[ 1175.396574][ T1132] ata2: SATA link down (SStatus 0 SControl 300)
[ 1175.417415][ T1123] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 1175.421618][ T1123] ata1.00: configured for UDMA/100
[ 1175.447991][ T1137] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[ 1175.456823][ T1137] ata3.00: configured for UDMA/100
[ 1175.614247][ T5836] usb usb50-port1: unable to enumerate USB device
[ 1175.647906][ T5108] Aborting journal on device sda1-8.
[ 1175.651011][T12337] buffer_io_error: 18 callbacks suppressed
[ 1175.651033][T12337] Buffer I/O error on dev sda1, logical block 131072, lost sync page write
[ 1175.657294][T20237] EXT4-fs error (device sda1): ext4_journal_check_start:94: comm syz.5.3709: Detected aborted journal
[ 1175.665579][ T5108] JBD2: I/O error when updating journal superblock for sda1-8.
[ 1175.673842][T20239] EXT4-fs error (device sda1): ext4_journal_check_start:94: comm syz.6.3710: Detected aborted journal
[ 1175.721163][ T5923] Buffer I/O error on dev sda1, logical block 0, lost sync page write
[ 1175.723567][T20239] EXT4-fs (sda1): previous I/O error to superblock detected
[ 1175.730930][ T5923] Buffer I/O error on dev sda1, logical block 0, lost sync page write
[ 1175.731190][T20239] EXT4-fs (sda1): I/O error while writing superblock
[ 1175.731223][T20239] EXT4-fs (sda1): Remounting filesystem read-only
[ 1175.791874][T11112] Read-error on swap-device (8:0:516182)
[ 1175.863539][T10850] Read-error on swap-device (8:0:364134)
[ 1175.888507][T20241] EXT4-fs (sda1): shut down requested (2)
[ 1175.908145][ T5726] Read-error on swap-device (8:0:332990)
[ 1175.908919][ T5923] Read-error on swap-device (8:0:333014)
[ 1175.909235][ T5923] Read-error on swap-device (8:0:313854)
[ 1175.939843][T11112] Read-error on swap-device (8:0:356918)
[ 1175.967225][ T5148] Read-error on swap-device (8:0:364766)
[ 1175.979645][ T5724] Read-error on sw


So I suspect something's wrong with shmem/swap error handling.  ie, the
code which doesn't get tested :(

> ------------[ cut here ]------------
> !si
> WARNING: mm/swapfile.c:2130 at swap_put_entries_direct+0x17d/0x1b0 mm/swapfile.c:2130, CPU#1: udevd/13167


