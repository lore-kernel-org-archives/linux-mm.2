Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B039C87FCB
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 02:56:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 959166B008A; Wed, 30 Jul 2025 22:56:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E1CA6B008C; Wed, 30 Jul 2025 22:56:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A8FB6B0092; Wed, 30 Jul 2025 22:56:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5DC236B008A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 22:56:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D9D701347CD
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 02:56:07 +0000 (UTC)
X-FDA: 83723045574.16.2EBD68E
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	by imf23.hostedemail.com (Postfix) with ESMTP id 21ABA140002
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 02:56:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of 3RduKaAkbAHIiopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.70 as permitted sender) smtp.mailfrom=3RduKaAkbAHIiopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753930566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=QcXKiPfwmHjQGd9OlGsZJblr9zhP6Wg9iPtuchythkk=;
	b=kSJtvEsmigTXV4Xd9srFXzu5nXPg70tionFW9bCY4aAI5j9sXB2aLKe4vV/kn9BjRfLORN
	KyiePn13e+PsYyYMkqektak90TabB9YsQkEHpgK78d8CIVuMpdUiUDcTUlHWEyAlb6/ARq
	QU8gMZ9ex8SEDPfmmqYyEQY+bfVOIoc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of 3RduKaAkbAHIiopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.70 as permitted sender) smtp.mailfrom=3RduKaAkbAHIiopaQbbUhQffYT.WeeWbUkiUhSedjUdj.Sec@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753930566; a=rsa-sha256;
	cv=none;
	b=4weuWNHoPFg6FD6Bg9pEZsMjUZwNbp1ImWC9W3NpkyQcsr+I6rVCFaQU8IyOxP27Al/ohM
	wLzc8FcjR1QLU7IISSlajrnid0J4ELfuWNav41peo7mDKWldOGME4Kt9hRL0xq6J3PwvJ6
	sU1h4PRbpzz2mRX/neGw6SekiI0odBo=
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-87c467931c1so95257639f.3
        for <linux-mm@kvack.org>; Wed, 30 Jul 2025 19:56:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753930565; x=1754535365;
        h=content-transfer-encoding:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QcXKiPfwmHjQGd9OlGsZJblr9zhP6Wg9iPtuchythkk=;
        b=nu2xgBz6vpTG+X+e8VVHR0R48V8ZF0vmTylTgScClE311bjm4ULo7b5udRQTgs0xh3
         /NkcBPiyGaHPVSjBPdtgzR9y3F+6H1Yg70P+kHykIVVx9J/zSVKEs6bUjpDMRJDP1BQQ
         xJ9rBJloinj6XZ+9E7asNwmf4l/QU59uofv332JzuKCOSt25D1MaIaTzE3hP9mt3ltcK
         GWwpThzLNPlevZ1tqYXs/HFhlZZY6h/Fi5sAkCkA2xlYLyYDh0lDVlwDam5FZFJAsD4e
         aTpmco/tB+bw7IQsSB/sOONjwBjd8loyTx9iAW001IyHHAXeWvqU+18VDE/MJAckb12H
         tROQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXmydfNf6oqAjRdBDvks24FtkIoO+ihIfIkjcZigihf9QUxfuv9vdoI6PHVRKEm7MgWNF9pt9mmw==@kvack.org
X-Gm-Message-State: AOJu0Yz/s+8XRvNc1U1ykJJoblXF5YrjOQby/VPGBHDiFiSEYXnhzMLN
	XH3pbZVyY5B492QPpeGyw5ja+iIfIH5uQYq2OGwRGNZ6JTQGe4JR6pJj1GvkGFSOQHdYG1/FRrp
	0B706LKr70aderV/QZxEPRyOmQYI+0//DcsxTJfPR1IUV4AjQyYmb0mpfxXQ=
X-Google-Smtp-Source: AGHT+IHVOiwNmwDIz7MJoIfXI+MLX29s0YhmFGSgKyKOoRXQCnEwdSMKBr3PMCSfLaFsMf2P9Y3LDfzmACLOHONpZsVUYl084+Pb
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2198:b0:3e3:f95b:bc5c with SMTP id
 e9e14a558f8ab-3e3f95bbe01mr78786285ab.15.1753930565116; Wed, 30 Jul 2025
 19:56:05 -0700 (PDT)
Date: Wed, 30 Jul 2025 19:56:05 -0700
In-Reply-To: <20250731015241.3576-1-hdanton@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <688adb45.a00a0220.26d0e1.0036.GAE@google.com>
Subject: Re: [syzbot] [mm?] BUG: unable to handle kernel paging request in move_pages
From: syzbot <syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, hdanton@sina.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lokeshgidra@google.com, peterx@redhat.com, 
	stable@vger.kernel.org, surenb@google.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 21ABA140002
X-Rspamd-Server: rspam06
X-Stat-Signature: ocdzbudobk77d3y6hdrk7g7broq89ynw
X-HE-Tag: 1753930565-917727
X-HE-Meta: U2FsdGVkX1/aItRBxdJlHyXTf3xAJGZoKSqpDRIEVgBXsTdMCE9Z3Vb97m5G78tm9DWs/LSQ8GxNU81eUykK/rpzqAxbBlGQqv2Wl5EXKs9ncOxTx/FVlCNIYToNHiLeehb8WRocGkECXi5x1yETPWC24Jh7Q1f1OcmBk0kQ9gPoQNF/qnbFhof7GL4ctdwnn+NRiGRBofEaKdC95IVIvqwQjZKd14/QE6xAfu/RFM5uVH/YgG8MBjxSokp9dRM72FoXr+2bq6v6AA6IAK519iPD2sNaG6N9C+RE/29wVt1c779kST3iVBBnAQkFWs5NL3eolRiX8nx5Av6fPXd2MLiRfXU1aoTtlss1uTBXB+b2BfFF9+sF4MIM8/fYkwddKrCUaBe12HQh9bXyrzEWsj/OFsTqGYABzmAtZyQ7gBTASainjQzb/MJ608Gtm7dLRolj1X9TbWbv/EgZlL7mDl+RweWfqzgUGXHWk5B1KIwzx1ZA7CitXgIX2G+eSg+EQpsNHYwAUED/wMA6upWYrd7ejNSX9Iu5tdD1Qir3xbP6v9BDCeYzql5rQ7kSK6cpTTBSpCBLvQxp5kexOu8nX33asze8BH10Glo7PzEXcmdZadsteKYF2M4nz53n1XCYUPaOHLjrVrq7Hznt6YiQteLN4dW8Gls++UNpvZkFLZL/PrrLMnal/hHeF0Q1JEHkQp4OwUDrQ2CwdWmFPfhDIgQJrsMqLicW/3JW39aMtnXzhNf3ArPY7n1LmOdKjRZKno1QtXjLrotSVOGJWJEPwhuEfNLfQpdrCDA+/xeLqDxkMA+x/RMSmLzbiIPAJoQlTo9rPhjwTMaS9HcMGvhdKnfGWxYGmDhgRoYwLsf7bO7jg3O5ybPFPQJ9sW9eXRZEJBJFBghjQ6pwzZ+DEE58mLrBljSA8+OKLn/Ud3qy/dTfPN91ACwUxBcrbBNY6NjEP23FVQv90tFkKr5Vj/X
 hTIqNbf0
 kkDRAlQNsqJtIsbiClg1fAVe/BPQwBb2bLufpEDw+6mu9mof1gpaNpXgPEEQ3jmQp4bsC/s/UndwYLlVIcD/ie3cy2z4P2x6JJdtq8Qv2bCaaYmj6OGSKQmKMJa+Ut6Z11zm3XiJIdclOUU2UlxpJq7xQQzRV9AEIT+4ZNucst8Z/Sh7QwEab5dt/mTwK6kSdZAt9OXOEaVqO+hEy0mfiZ+xBiqF5zOZoAAq7KRkkGS3eDvVfQp3wbJFHxq6B3YMcwH0b++uDoSZMYj8FH3sT80SA5nqooSlPuTQv5mVePFgD5LxKLOVqkTGcEtrdsCe16EWk/Gkvj7ZbU/0nNx/0FJQ2KdLENs8B8D7rM856xVz84PEFcZyI6hGh/hPGDvunV9KzPMzbmeCE9iA+lNVkzOLJAKpwSF9cs4mLvf/0i9o2y8EezxK1EUA2jTTs7oroEfGgVQe/rmfFI3qm3g8B9OSEI4Ap+6yXcf+heAm7GXAH5//lvqwQMXMyqrrTZ8HGxJAPVux0BNfXPR0EUScCC8M16uhVWBm5gfNNfR+btdZ1AVtNDGxikZ1hFMtTAY8NQXrrUDajRATcRJGNF+i72YQpXqNIFbA7w7UZJ0KJ7bSvx9QyqEqtQl293n0upMmASnBlkLpmPMJGg0Uyhf33k7WRxjlBdSLWTGQ4evWh61QhSEtAqapk2/F/z71CmlXWFwl+ET48mChZpYCIIN3SbNw72kV2p1W6BK1qh5A+o+fzRYCc4Qu+6sSkFJXyYKokbSRgrsJdPt8qOMczS/nL5PC5FSAVsC1VzTh1lIWHa2gV2MPwz0SNRT+uG5/VBZW7y+JXAvwUtaZ8WOCkOUCYzyfShOhuHtrAChFYgtIXMlKurPd9MZ+4IgFs95cBwabMinxhjQO/0ej7Ib7fpLCDCcANRzYigSiNJPwOYvMLcf2+fv6hDZFEt8W5Ajd0HcJ42URbKFcLHS6zSwgDIymUD1LbZlju
 zYQwjAzB
 X4DYGzaymQeecr+vHSqRXNHEPXRHePEF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot tried to test the proposed patch but the build/boot failed:


[   28.845257][    T1] Demotion targets for Node 1: null
[   28.850968][    T1] debug_vm_pgtable: [debug_vm_pgtable         ]: Valid=
ating architecture page table helpers
[   31.966884][    T1] Key type .fscrypt registered
[   31.971683][    T1] Key type fscrypt-provisioning registered
[   31.981903][    T1] kAFS: Red Hat AFS client v0.1 registering.
[   32.015243][    T1] Btrfs loaded, assert=3Don, ref-verify=3Don, zoned=3D=
yes, fsverity=3Dyes
[   32.023899][    T1] Key type big_key registered
[   32.028720][    T1] Key type encrypted registered
[   32.033688][    T1] AppArmor: AppArmor sha256 policy hashing enabled
[   32.040442][    T1] ima: No TPM chip found, activating TPM-bypass!
[   32.047114][    T1] Loading compiled-in module X.509 certificates
[   32.084977][    T1] Loaded X.509 cert 'Build time autogenerated kernel k=
ey: 9e306c316bea685e5e2c978a84108ea320e0bb8d'
[   32.096049][    T1] ima: Allocated hash algorithm: sha256
[   32.102136][    T1] ima: No architecture policies found
[   32.108474][    T1] evm: Initialising EVM extended attributes:
[   32.114683][    T1] evm: security.selinux (disabled)
[   32.120010][    T1] evm: security.SMACK64 (disabled)
[   32.125234][    T1] evm: security.SMACK64EXEC (disabled)
[   32.130721][    T1] evm: security.SMACK64TRANSMUTE (disabled)
[   32.136717][    T1] evm: security.SMACK64MMAP (disabled)
[   32.142322][    T1] evm: security.apparmor
[   32.146620][    T1] evm: security.ima
[   32.150513][    T1] evm: security.capability
[   32.155010][    T1] evm: HMAC attrs: 0x1
[   32.161853][    T1] PM:   Magic number: 1:781:764
[   32.167399][    T1] tty ptyp0: hash matches
[   32.171863][    T1] event_source breakpoint: hash matches
[   32.177883][    T1] netconsole: network logging started
[   32.184127][    T1] gtp: GTP module loaded (pdp ctx size 128 bytes)
[   32.196802][    T1] rdma_rxe: loaded
[   32.202557][    T1] cfg80211: Loading compiled-in X.509 certificates for=
 regulatory database
[   32.214150][    T1] Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
[   32.222646][    T1] Loaded X.509 cert 'wens: 61c038651aabdcf94bd0ac7ff06=
c7248db18c600'
[   32.233530][    T1] clk: Disabling unused clocks
[   32.238743][    T1] ALSA device list:
[   32.240606][ T1232] faux_driver regulatory: Direct firmware load for reg=
ulatory.db failed with error -2
[   32.242690][    T1]   #0: Dummy 1
[   32.252694][ T1232] faux_driver regulatory: Falling back to sysfs fallba=
ck for: regulatory.db
[   32.255969][    T1]   #1: Loopback 1
[   32.268969][    T1]   #2: Virtual MIDI Card 1
[   32.277374][    T1] check access for rdinit=3D/init failed: -2, ignoring
[   32.284083][    T1] md: Waiting for all devices to be available before a=
utodetect
[   32.291864][    T1] md: If you don't use raid, use raid=3Dnoautodetect
[   32.298455][    T1] md: Autodetecting RAID arrays.
[   32.303602][    T1] md: autorun ...
[   32.307281][    T1] md: ... autorun DONE.
[   32.462042][    T1] EXT4-fs (sda1): orphan cleanup on readonly fs
[   32.471960][    T1] EXT4-fs (sda1): mounted filesystem 4f91c6db-4997-4bb=
4-91b8-7e83a20c1bf1 ro with ordered data mode. Quota mode: none.
[   32.484967][    T1] VFS: Mounted root (ext4 filesystem) readonly on devi=
ce 8:1.
[   32.495205][    T1] devtmpfs: mounted
[   32.588172][    T1] Freeing unused kernel image (initmem) memory: 26168K
[   32.600162][    T1] Write protecting the kernel read-only data: 215040k
[   32.623912][    T1] Freeing unused kernel image (text/rodata gap) memory=
: 1780K
[   32.638083][    T1] Freeing unused kernel image (rodata/data gap) memory=
: 1392K
[   32.848558][    T1] x86/mm: Checked W+X mappings: passed, no W+X pages f=
ound.
[   32.856738][    T1] x86/mm: Checking user space page tables
[   33.038272][    T1] x86/mm: Checked W+X mappings: passed, no W+X pages f=
ound.
[   33.052334][    T1] Failed to set sysctl parameter 'max_rcu_stall_to_pan=
ic=3D1': parameter not found
[   33.062661][    T1] Run /sbin/init as init process
[   33.861085][ T5182] mount (5182) used greatest stack depth: 24104 bytes =
left
[   33.936286][ T5183] EXT4-fs (sda1): re-mounted 4f91c6db-4997-4bb4-91b8-7=
e83a20c1bf1 r/w.
mount: mounting devtmpfs on /dev failed: Device or resource busy
mount: mounting smackfs on /sys/fs/smackfs failed: No such file or director=
y
mount: mounting selinuxfs on /sys/fs/selinux failed: No such file or direct=
ory
[   34.124544][ T5187] mount (5187) used greatest stack depth: 21768 bytes =
left
Starting syslogd: OK
Starting acpid: OK
Starting klogd: OK
Running sysctl: [   35.067485][ T5215] logger (5215) used greatest stack de=
pth: 20232 bytes left
OK
Populating /dev using udev: [   35.630326][ T5217] udevd[5217]: starting ve=
rsion 3.2.14
[   35.905047][ T5218] udevd[5218]: starting eudev-3.2.14
[   35.910508][ T5217] udevd (5217) used greatest stack depth: 18888 bytes =
left
[   45.256949][ T5311] ------------[ cut here ]------------
[   45.262574][ T5311] AppArmor WARN apparmor_unix_stream_connect: ((({ typ=
eof(*(new_ctx->label)) *__UNIQUE_ID_rcu2215 =3D (typeof(*(new_ctx->label)) =
*)({ do { __attribute__((__noreturn__)) extern void __compiletime_assert_22=
16(void) __attribute__((__error__("Unsupported access size for {READ,WRITE}=
_ONCE()."))); if (!((sizeof((new_ctx->label)) =3D=3D sizeof(char) || sizeof=
((new_ctx->label)) =3D=3D sizeof(short) || sizeof((new_ctx->label)) =3D=3D =
sizeof(int) || sizeof((new_ctx->label)) =3D=3D sizeof(long)) || sizeof((new=
_ctx->label)) =3D=3D sizeof(long long))) __compiletime_assert_2216(); } whi=
le (0); (*(const volatile typeof( _Generic(((new_ctx->label)), char: (char)=
0, unsigned char: (unsigned char)0, signed char: (signed char)0, unsigned s=
hort: (unsigned short)0, signed short: (signed short)0, unsigned int: (unsi=
gned int)0, signed int: (signed int)0, unsigned long: (unsigned long)0, sig=
ned long: (signed long)0, unsigned long long: (unsigned long long)0, signed=
 long long: (signed long long)0, default: ((new_ctx->label)))) *)&((new_ctx=
->label))); }); ;=20
[   45.263241][ T5311] WARNING: security/apparmor/lsm.c:1211 at apparmor_un=
ix_stream_connect+0x5fa/0x650, CPU#1: udevadm/5311
[   45.366388][ T5311] Modules linked in:
[   45.370460][ T5311] CPU: 1 UID: 0 PID: 5311 Comm: udevadm Not tainted 6.=
16.0-next-20250730-syzkaller-g79fb37f39b77-dirty #0 PREEMPT(full)=20
[   45.383250][ T5311] Hardware name: Google Google Compute Engine/Google C=
ompute Engine, BIOS Google 07/12/2025
[   45.393425][ T5311] RIP: 0010:apparmor_unix_stream_connect+0x5fa/0x650
[   45.400386][ T5311] Code: 2b 39 fd 48 89 ef e8 35 4d 00 00 e9 09 fe ff f=
f e8 fb 2a 39 fd 90 48 c7 c7 80 49 fd 8b 48 c7 c6 55 fd c6 8d e8 07 b2 fc f=
c 90 <0f> 0b 90 90 e9 27 fe ff ff e8 d8 2a 39 fd be 02 00 00 00 eb 0a e8
[   45.420317][ T5311] RSP: 0018:ffffc90002fe7ba8 EFLAGS: 00010246
[   45.426486][ T5311] RAX: 9dc56ab1cd53fc00 RBX: 1ffff1100f9680a8 RCX: fff=
f88802573bc00
[   45.434510][ T5311] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000=
0000000000002
[   45.442606][ T5311] RBP: ffff88801ba8f8f8 R08: ffff8880b8724253 R09: 1ff=
ff110170e484a
[   45.450777][ T5311] R10: dffffc0000000000 R11: ffffed10170e484b R12: fff=
f88807cb40540
[   45.458900][ T5311] R13: 1ffff1100652ff20 R14: 0000000000000000 R15: 000=
000000000002f
[   45.466941][ T5311] FS:  00007f76c2063880(0000) GS:ffff8881258ff000(0000=
) knlGS:0000000000000000
[   45.475912][ T5311] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   45.482735][ T5311] CR2: 00007f76c187ae00 CR3: 000000007703c000 CR4: 000=
00000003526f0
[   45.490960][ T5311] Call Trace:
[   45.494279][ T5311]  <TASK>
[   45.497315][ T5311]  security_unix_stream_connect+0xcb/0x2c0
[   45.503280][ T5311]  unix_stream_connect+0x9bc/0x1140
[   45.508693][ T5311]  ? __pfx_unix_stream_connect+0x10/0x10
[   45.514371][ T5311]  ? apparmor_socket_connect+0xd1/0x1c0
[   45.520004][ T5311]  ? bpf_lsm_socket_connect+0x9/0x20
[   45.525337][ T5311]  __sys_connect+0x313/0x440
[   45.530054][ T5311]  ? count_memcg_event_mm+0x21/0x260
[   45.535468][ T5311]  ? __pfx___sys_connect+0x10/0x10
[   45.540839][ T5311]  __x64_sys_connect+0x7a/0x90
[   45.545652][ T5311]  do_syscall_64+0xfa/0x3b0
[   45.550262][ T5311]  ? lockdep_hardirqs_on+0x9c/0x150
[   45.555504][ T5311]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   45.561680][ T5311]  ? clear_bhb_loop+0x60/0xb0
[   45.566469][ T5311]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   45.572402][ T5311] RIP: 0033:0x7f76c18a7407
[   45.577029][ T5311] Code: 48 89 fa 4c 89 df e8 38 aa 00 00 8b 93 08 03 0=
0 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0=
f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
[   45.596931][ T5311] RSP: 002b:00007fff51b7aea0 EFLAGS: 00000202 ORIG_RAX=
: 000000000000002a
[   45.605391][ T5311] RAX: ffffffffffffffda RBX: 00007f76c2063880 RCX: 000=
07f76c18a7407
[   45.613557][ T5311] RDX: 0000000000000013 RSI: 000055c6cf4e5948 RDI: 000=
0000000000003
[   45.621707][ T5311] RBP: 000000000000001e R08: 0000000000000000 R09: 000=
0000000000000
[   45.629803][ T5311] R10: 0000000000000000 R11: 0000000000000202 R12: 000=
07fff51b7af00
[   45.637970][ T5311] R13: 0000000000000000 R14: 0000000000000007 R15: 000=
0000000000000
[   45.646036][ T5311]  </TASK>
[   45.649515][ T5311] Kernel panic - not syncing: kernel: panic_on_warn se=
t ...
[   45.656924][ T5311] CPU: 1 UID: 0 PID: 5311 Comm: udevadm Not tainted 6.=
16.0-next-20250730-syzkaller-g79fb37f39b77-dirty #0 PREEMPT(full)=20
[   45.669550][ T5311] Hardware name: Google Google Compute Engine/Google C=
ompute Engine, BIOS Google 07/12/2025
[   45.679726][ T5311] Call Trace:
[   45.683035][ T5311]  <TASK>
[   45.686086][ T5311]  dump_stack_lvl+0x99/0x250
[   45.690702][ T5311]  ? __asan_memcpy+0x40/0x70
[   45.695331][ T5311]  ? __pfx_dump_stack_lvl+0x10/0x10
[   45.700632][ T5311]  ? __pfx__printk+0x10/0x10
[   45.705252][ T5311]  vpanic+0x281/0x750
[   45.709254][ T5311]  ? __pfx_vpanic+0x10/0x10
[   45.713769][ T5311]  ? is_bpf_text_address+0x292/0x2b0
[   45.719065][ T5311]  ? is_bpf_text_address+0x26/0x2b0
[   45.724280][ T5311]  panic+0xb9/0xc0
[   45.728191][ T5311]  ? __pfx_panic+0x10/0x10
[   45.732652][ T5311]  __warn+0x334/0x4c0
[   45.736661][ T5311]  ? apparmor_unix_stream_connect+0x5fa/0x650
[   45.742751][ T5311]  ? apparmor_unix_stream_connect+0x5fa/0x650
[   45.748855][ T5311]  report_bug+0x2be/0x4f0
[   45.753201][ T5311]  ? apparmor_unix_stream_connect+0x5fa/0x650
[   45.759287][ T5311]  ? apparmor_unix_stream_connect+0x5fa/0x650
[   45.765369][ T5311]  ? apparmor_unix_stream_connect+0x5fc/0x650
[   45.771457][ T5311]  handle_bug+0x84/0x160
[   45.775713][ T5311]  exc_invalid_op+0x1a/0x50
[   45.780229][ T5311]  asm_exc_invalid_op+0x1a/0x20
[   45.785090][ T5311] RIP: 0010:apparmor_unix_stream_connect+0x5fa/0x650
[   45.791785][ T5311] Code: 2b 39 fd 48 89 ef e8 35 4d 00 00 e9 09 fe ff f=
f e8 fb 2a 39 fd 90 48 c7 c7 80 49 fd 8b 48 c7 c6 55 fd c6 8d e8 07 b2 fc f=
c 90 <0f> 0b 90 90 e9 27 fe ff ff e8 d8 2a 39 fd be 02 00 00 00 eb 0a e8
[   45.811507][ T5311] RSP: 0018:ffffc90002fe7ba8 EFLAGS: 00010246
[   45.817614][ T5311] RAX: 9dc56ab1cd53fc00 RBX: 1ffff1100f9680a8 RCX: fff=
f88802573bc00
[   45.825597][ T5311] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000=
0000000000002
[   45.833592][ T5311] RBP: ffff88801ba8f8f8 R08: ffff8880b8724253 R09: 1ff=
ff110170e484a
[   45.841787][ T5311] R10: dffffc0000000000 R11: ffffed10170e484b R12: fff=
f88807cb40540
[   45.849789][ T5311] R13: 1ffff1100652ff20 R14: 0000000000000000 R15: 000=
000000000002f
[   45.857797][ T5311]  ? apparmor_unix_stream_connect+0x5f9/0x650
[   45.863898][ T5311]  security_unix_stream_connect+0xcb/0x2c0
[   45.869723][ T5311]  unix_stream_connect+0x9bc/0x1140
[   45.874965][ T5311]  ? __pfx_unix_stream_connect+0x10/0x10
[   45.880638][ T5311]  ? apparmor_socket_connect+0xd1/0x1c0
[   45.886338][ T5311]  ? bpf_lsm_socket_connect+0x9/0x20
[   45.891652][ T5311]  __sys_connect+0x313/0x440
[   45.896264][ T5311]  ? count_memcg_event_mm+0x21/0x260
[   45.901585][ T5311]  ? __pfx___sys_connect+0x10/0x10
[   45.906836][ T5311]  __x64_sys_connect+0x7a/0x90
[   45.911620][ T5311]  do_syscall_64+0xfa/0x3b0
[   45.916226][ T5311]  ? lockdep_hardirqs_on+0x9c/0x150
[   45.921443][ T5311]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   45.927532][ T5311]  ? clear_bhb_loop+0x60/0xb0
[   45.932230][ T5311]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   45.938138][ T5311] RIP: 0033:0x7f76c18a7407
[   45.942597][ T5311] Code: 48 89 fa 4c 89 df e8 38 aa 00 00 8b 93 08 03 0=
0 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0=
f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
[   45.962764][ T5311] RSP: 002b:00007fff51b7aea0 EFLAGS: 00000202 ORIG_RAX=
: 000000000000002a
[   45.971201][ T5311] RAX: ffffffffffffffda RBX: 00007f76c2063880 RCX: 000=
07f76c18a7407
[   45.979193][ T5311] RDX: 0000000000000013 RSI: 000055c6cf4e5948 RDI: 000=
0000000000003
[   45.987272][ T5311] RBP: 000000000000001e R08: 0000000000000000 R09: 000=
0000000000000
[   45.995541][ T5311] R10: 0000000000000000 R11: 0000000000000202 R12: 000=
07fff51b7af00
[   46.003610][ T5311] R13: 0000000000000000 R14: 0000000000000007 R15: 000=
0000000000000
[   46.011603][ T5311]  </TASK>
[   46.021763][ T5311] Kernel Offset: disabled
[   46.026647][ T5311] Rebooting in 86400 seconds..


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
 -ffile-prefix-map=3D/tmp/go-build3145104381=3D/tmp/go-build -gno-record-gc=
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
GOVERSION=3D'go1.24.4'
GOWORK=3D''
PKG_CONFIG=3D'pkg-config'

git status (err=3D<nil>)
HEAD detached at 44f8051e44
nothing to commit, working tree clean


tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
go list -f '{{.Stale}}' ./sys/syz-sysgen | grep -q false || go install ./sy=
s/syz-sysgen
make .descriptions
tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
bin/syz-sysgen
touch .descriptions
GOOS=3Dlinux GOARCH=3Damd64 go build -ldflags=3D"-s -w -X github.com/google=
/syzkaller/prog.GitRevision=3D44f8051e446824395d02720c745353cd454d9553 -X g=
ithub.com/google/syzkaller/prog.gitRevisionDate=3D20250716-133924"  -o ./bi=
n/linux_amd64/syz-execprog github.com/google/syzkaller/tools/syz-execprog
mkdir -p ./bin/linux_amd64
g++ -o ./bin/linux_amd64/syz-executor executor/executor.cc \
	-m64 -O2 -pthread -Wall -Werror -Wparentheses -Wunused-const-variable -Wfr=
ame-larger-than=3D16384 -Wno-stringop-overflow -Wno-array-bounds -Wno-forma=
t-overflow -Wno-unused-but-set-variable -Wno-unused-command-line-argument -=
static-pie -std=3Dc++17 -I. -Iexecutor/_include   -DGOOS_linux=3D1 -DGOARCH=
_amd64=3D1 \
	-DHOSTGOOS_linux=3D1 -DGIT_REVISION=3D\"44f8051e446824395d02720c745353cd45=
4d9553\"
/usr/bin/ld: /tmp/ccnhngWI.o: in function `Connection::Connect(char const*,=
 char const*)':
executor.cc:(.text._ZN10Connection7ConnectEPKcS1_[_ZN10Connection7ConnectEP=
KcS1_]+0x104): warning: Using 'gethostbyname' in statically linked applicat=
ions requires at runtime the shared libraries from the glibc version used f=
or linking


Error text is too large and was truncated, full error text is at:
https://syzkaller.appspot.com/x/error.txt?x=3D11622cf0580000


Tested on:

commit:         79fb37f3 Add linux-next specific files for 20250730
git tree:       linux-next
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D1f38ce0ee8aa681=
d
dashboard link: https://syzkaller.appspot.com/bug?extid=3Db446dbe27035ef6bd=
6c2
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-=
1~exp1~20250616065826.132), Debian LLD 20.1.7
patch:          https://syzkaller.appspot.com/x/patch.diff?x=3D114e48345800=
00


