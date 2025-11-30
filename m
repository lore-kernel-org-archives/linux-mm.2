Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13989D116F3
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 15:51:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 693F86B000D; Sun, 30 Nov 2025 10:51:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66B786B0011; Sun, 30 Nov 2025 10:51:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A87E6B0012; Sun, 30 Nov 2025 10:51:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4796B6B000D
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 10:51:06 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D560B132D7E
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 15:51:05 +0000 (UTC)
X-FDA: 84167712090.02.83085C5
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2A04D1C000A
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 15:51:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of 352csaQkbALgqwxiYjjcpYnngb.emmejcsqcpamlrclr.amk@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=352csaQkbALgqwxiYjjcpYnngb.emmejcsqcpamlrclr.amk@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764517864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=pZQZPvsA+b1aEfkr/eSFp6Mc7KtxI3DMkvE2WO3Y+vA=;
	b=fWbkXSBqXSiyzN9h2UdDdmGwDIkuvBRRRDQJ2tgCsQbZ8SfMWhfWZaJLJ2Rnl8ZgnKuhz9
	OxEoHjfB97kLSuq4EGmNDjOpUIeJPj+sAyIHVpDic6Q2Svr5X91WSCgCMS1Be14t/UI51t
	9Z50lRhaaNI4uimdht2+x71/8m9kj20=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of 352csaQkbALgqwxiYjjcpYnngb.emmejcsqcpamlrclr.amk@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=352csaQkbALgqwxiYjjcpYnngb.emmejcsqcpamlrclr.amk@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764517864; a=rsa-sha256;
	cv=none;
	b=aPk/1ihfiGsjU6ISMLp2XHdvDElsnRIvdcjRrFYRbcNbbqll7yvpFV7rmR4TmVT4GBP2Xh
	wuli6Uxwd+9+jAkPpM+ZEJwju+K7btUiw8DIUrzb+7QwmiPxUzCT5tVLqsOpNDDmvddOqS
	/qSl12Jyp95RIWyJNs9VxFycN96tb6A=
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-433199c7fb4so20804015ab.3
        for <linux-mm@kvack.org>; Sun, 30 Nov 2025 07:51:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764517863; x=1765122663;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pZQZPvsA+b1aEfkr/eSFp6Mc7KtxI3DMkvE2WO3Y+vA=;
        b=TpH/m/xbSZBEk8L/3fRZ2nvKfCZVQGvb78enpClBKT+8+RHzf8jc6imGd4HOYjQNkd
         n1U/lUxPeWGS/4IOU2szbtaZ+DeoPYS9EL2zBHo+0XPouwK34xXn792ocxkGIZJd9G+7
         4e+7mZ5fEsz4LYVgNmV6XWMt5rNNzJ6BMMu98OXbpW+8TnhywXtNL91Cj1hz/kZ12gxy
         IqBkbXeG+BYgtFcRYXOg+mC8R53vKSI63TF5dbWDtoVNFwqavIZUkovPh+PkyjVH2/+9
         Dl11SOqDZ4Ywo4xQQONTYdsxjOWM6XbZnm7PwsNTRF6TXCv+bhG11crlVzrO6HtBjRQZ
         JF7g==
X-Forwarded-Encrypted: i=1; AJvYcCXOHunQTYuBSQ5s9pUK1vlwEjI2bi3gsnmgwy2h7kd/J+wKI2jxOwu5pTZmBiZbnEZ4zkpbb2/Aww==@kvack.org
X-Gm-Message-State: AOJu0Yw3vBuy2yfGLO19valgsvEGVxwJ19PVfOIrc8ZsrxySzsFZld9z
	tjFgRMKBLG+Qzm8d+62D4xz/xa9TsYThA79ASBGPmRRn9VKiCO0UXKjnbmoj6IAuJW+Ug6uWW5K
	Ec8X1LFWkQK582Rvan75dKJOYtKt/IZ4L/ww5aD7CdQX0xLpdKhAlnxBuAHc=
X-Google-Smtp-Source: AGHT+IEmmk9ubAf028hrGiKPi9++Nhmn7ukhITaHj6Iks3+zKps4MCqnc1j5bumu0sk4b5fswov2N05NTj/viY/CsM1CDyCYT5wU
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d9c:b0:433:7abd:96d0 with SMTP id
 e9e14a558f8ab-435b9851daemr263744155ab.3.1764517863270; Sun, 30 Nov 2025
 07:51:03 -0800 (PST)
Date: Sun, 30 Nov 2025 07:51:03 -0800
In-Reply-To: <ff6e08e2-a7c7-4ebf-8f93-03e5ece9b335@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692c67e7.a70a0220.d98e3.0172.GAE@google.com>
Subject: Re: [syzbot] [fs?] [mm?] kernel BUG in __filemap_add_folio
From: syzbot <syzbot+4d3cc33ef7a77041efa6@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, brauner@kernel.org, hare@suse.de, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, mcgrof@kernel.org, ssranevjti@gmail.com, 
	syzkaller-bugs@googlegroups.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 2A04D1C000A
X-Rspamd-Server: rspam02
X-Stat-Signature: bphz5zxngyryp7n6ynepqyjjwu43pky8
X-Rspam-User: 
X-HE-Tag: 1764517863-802189
X-HE-Meta: U2FsdGVkX19+Q6RMRIWxlFWVAVYtDXKNJw4DK0rCxHEXMIUKgiQUx7S/YzZhRKRaThL5a4vbGIzGdXXYwKLpCm10nwSjiJJ2Qw2okx4MNCl7nvayzWBGXGnHkHVxiCGhi3D0OLv1flsyd3MStbF/buVKfBgheI5VWAbaZBE8drbhXhIeOJRED+NrOzi70TzeZ85EHFwPf9IritGtbmjC/qLaoW2vAs0Jfe4Aw5JZAaS31ML/A9pTC8HAtWWrY+SHn8Rp47RHLlDRiVm6UyV6CD6Xwif/TDfK1UndmW7Xqi7YFJpp5y9CXITT45mpjDZ0NCKQ+kzSGQjw1ZnvOZ32vZEMX7gHdsF5abNZKOg0kq9D9S1EJIu1m6/7LMJdRBoyj42apP+gFUJq8HOcuQbx2P4gLI8iqgJcH/nVhVZ14cpWF/xGBQWh2d0JpokBX43swWDsUm7l+5Zuc1l4+58CPiHe9eZ41cJlhUZjc6wcSS9nuFKPtdpsHBFLdySKMAIw8ZQlcmYlO2w4/BN9aTqebpgg8+vnU1JzWcS7mEucL4MSsiMPxsQDBANS1UTPAwHogDM4g8xHl/E3iROD1YAq8SsgbZL01gPNKM/67vMvO6ZvSpxZHxUHjMQRDN8dLV38UQl4QIUVs46F/ZuHAGIiibbLW6rbxwBupRHno90+lg2rORD2hjSam9j50cKXlKjYedvFgyvkg5sD3CRWnt6/iqelvGlTm/FT/2NN8LnFjp0GGQ/WqmyFlSFRWyNELgkhZPZSjDsPNfHr1noS3a7b1vM0GLpqp5lpisxQcRUIGossLCG0Q/R5gN1VRgTexsahMMTmy+92EsA+5mEHOz0Vd00fL5Hck6OsYGXXa98eUPJVZOtSno1BGPrjptF2T1IggT5jHgQbF9kmszKxweaOBdLO6H3YpJwL8YalPchILct/j73KG8cyDFZs3nmBVaa1z256QjUjXEAdXWHsTOL
 bB+hCX6P
 +YCqbPDmi1ihYSAr4qtb5+2Fmewx2xeSxV7cC2r4pqxcOs2yXQ/RcF8JD46eLELumbOZv9lUC5nlVa4AwgRRFkRiy1wlbSQblBLpEe9s/+4n+TPDLdgb6r5oMHlHe2JbMUEo/2ID9jiqg+NaP67MbQxworl50GTymzHJUlTpW/3vabXaRD7JdKPboyqmPq20DtQL6uEOK9BsGQUV3EFaJvhcdwNIseoWgoDKBZhycoGOcoNabMzA5FxjDnaXL5zHmTidwHxJgM6CGbWUCSjh96Svq/1Esgminf5EC1prENNlrymvw0lWXyAJNlqgxEVwfSnBICM0xG21a+n+dl7dzfnLZKSFvWjIqycSuhxM2M5QE5bcuKwWM2B/UxQf2Hf6erVpy4UcmwEeHUOH4DRwIImb1FnYXqfDjOYdkaI5Lr8glY+9zyB13o4/eIxCmILNAUBeEGE1MfOfb15lBPDlPyCEcPsemwvh19dD90QByTJOjSPwxayryGlSusK7snbiuW+rQ9EvTuak3iBg8tk73IlAtS754KYbzswL4JD6rylZjjK+PGKPXrDWow+SMc8/JawRSkToNs1AJ9HP/rg8gjcUq33KAKXoUxyNt0j4LJ5aArp3/MUf2LHjCcYBeeoOOoun8qjvKleb44pEpg+a4Yi3x586bwNH5V2CMZVX/MmoHuYEm18IzEswv2JCWSNAUKI1b2L0bqT8TVyvHYPRWDmH+M5ntj1ZReso8Qugls4eJv7isu6XRpIRm/7/285r1ZDS0fKIixfpTkKnRjslCBHT1wHDVceHR8FJk6s8A5VrC7WhS692FmyQrHBICIWe1yqEcWf8iI9Y+uK8oP0CY8OdfbmfpD1gbAr/Oo06Kf7E14tI33qU4Sn8OqGDrWTGJA4gC7MYpKTl2jV2qh3JoJVFLw0b06YPK+gWp9bacH6F03dmRbtoX8KaxlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
kernel BUG in mpage_readahead

------------[ cut here ]------------
kernel BUG at ./include/linux/pagemap.h:1408!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 1 UID: 0 PID: 18176 Comm: syz-executor317 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:__readahead_folio include/linux/pagemap.h:1408 [inline]
RIP: 0010:readahead_folio include/linux/pagemap.h:1434 [inline]
RIP: 0010:mpage_readahead+0x4ad/0x5a0 fs/mpage.c:367
Code: 5e 41 5f c3 cc cc cc cc e8 b0 19 70 ff 48 89 ef e8 48 06 ad ff e9 54 fe ff ff 4c 8b 6c 24 18 e9 43 ff ff ff e8 94 19 70 ff 90 <0f> 0b e8 8c 19 70 ff 48 c7 c6 00 b6 80 8b 48 89 ef e8 1d 39 ba ff
RSP: 0018:ffffc9000d92f620 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffc9000d92fae8 RCX: ffffffff824c7d14
RDX: ffff88802fe68000 RSI: ffffffff824c809c RDI: 0000000000000004
RBP: 0000000000000004 R08: 0000000000000004 R09: 0000000000000004
R10: 0000000000000001 R11: 0000000000000000 R12: dffffc0000000000
R13: fffff52001b25f61 R14: 0000000000000001 R15: 1ffff92001b25f61
FS:  0000555564bcd380(0000) GS:ffff888124f53000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f08297b0130 CR3: 0000000030a16000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 read_pages+0x1c4/0xc70 mm/readahead.c:163
 page_cache_ra_unbounded+0x66a/0xa10 mm/readahead.c:269
 do_page_cache_ra mm/readahead.c:332 [inline]
 page_cache_ra_order+0xc0b/0xf20 mm/readahead.c:542
 do_sync_mmap_readahead mm/filemap.c:3340 [inline]
 filemap_fault+0x1583/0x29a0 mm/filemap.c:3489
 __do_fault+0x10d/0x490 mm/memory.c:5281
 do_shared_fault mm/memory.c:5780 [inline]
 do_fault mm/memory.c:5854 [inline]
 do_pte_missing+0x1a6/0x3ba0 mm/memory.c:4362
 handle_pte_fault mm/memory.c:6195 [inline]
 __handle_mm_fault+0x1556/0x2aa0 mm/memory.c:6336
 handle_mm_fault+0x589/0xd10 mm/memory.c:6505
 do_user_addr_fault+0x60c/0x1370 arch/x86/mm/fault.c:1336
 handle_page_fault arch/x86/mm/fault.c:1476 [inline]
 exc_page_fault+0x64/0xc0 arch/x86/mm/fault.c:1532
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7f082970586d
Code: 03 00 b9 03 10 12 00 45 31 c0 48 ba 80 00 00 00 00 20 00 00 48 b8 2f 64 65 76 2f 6e 75 6c 48 c7 c6 9c ff ff ff bf 01 01 00 00 <48> 89 02 48 b8 88 00 00 00 00 20 00 00 c7 00 6c 62 30 00 31 c0 e8
RSP: 002b:00007ffff735c180 EFLAGS: 00010246
RAX: 6c756e2f7665642f RBX: 0000000000000000 RCX: 0000000000121003
RDX: 0000200000000080 RSI: ffffffffffffff9c RDI: 0000000000000101
RBP: 00000000000f4240 R08: 0000000000000000 R09: 0000000000002000
R10: 0000000000000013 R11: 0000000000000206 R12: 0000000000079470
R13: 00007ffff735c19c R14: 00007ffff735c1b0 R15: 00007ffff735c1a0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__readahead_folio include/linux/pagemap.h:1408 [inline]
RIP: 0010:readahead_folio include/linux/pagemap.h:1434 [inline]
RIP: 0010:mpage_readahead+0x4ad/0x5a0 fs/mpage.c:367
Code: 5e 41 5f c3 cc cc cc cc e8 b0 19 70 ff 48 89 ef e8 48 06 ad ff e9 54 fe ff ff 4c 8b 6c 24 18 e9 43 ff ff ff e8 94 19 70 ff 90 <0f> 0b e8 8c 19 70 ff 48 c7 c6 00 b6 80 8b 48 89 ef e8 1d 39 ba ff
RSP: 0018:ffffc9000d92f620 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffc9000d92fae8 RCX: ffffffff824c7d14
RDX: ffff88802fe68000 RSI: ffffffff824c809c RDI: 0000000000000004
RBP: 0000000000000004 R08: 0000000000000004 R09: 0000000000000004
R10: 0000000000000001 R11: 0000000000000000 R12: dffffc0000000000
R13: fffff52001b25f61 R14: 0000000000000001 R15: 1ffff92001b25f61
FS:  0000555564bcd380(0000) GS:ffff888124f53000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f08297b0130 CR3: 0000000030a16000 CR4: 00000000003526f0


Tested on:

commit:         6bda50f4 Merge tag 'mips-fixes_6.18_2' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11857514580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f4a1ecf59be91960
dashboard link: https://syzkaller.appspot.com/bug?extid=4d3cc33ef7a77041efa6
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=10dc7cb4580000


