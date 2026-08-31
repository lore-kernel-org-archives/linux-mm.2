Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E21FCC61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 11:43:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03E736B0088; Mon, 31 Aug 2026 07:43:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F312C6B008A; Mon, 31 Aug 2026 07:43:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1FC66B008C; Mon, 31 Aug 2026 07:43:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFD456B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:43:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E74491404AA
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:43:05 +0000 (UTC)
X-FDA: 85161378330.05.0F8DF28
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf27.hostedemail.com (Postfix) with ESMTP id 57A3B40002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:43:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf27.hostedemail.com: domain of 3x2iVagkbAEo4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3x2iVagkbAEo4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788176584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=I5LM+0Pjsyiw43Y9OPRtVO7+pR519d5y9NI1syLmG3Y=;
	b=UZry/FEwLbgtGhYIS6qXQKiJb18PBMSYEzhESFxYSDvEG1cZPy8jrenQXZC01bGmfloVp5
	a5z04InXrDX9yUCW17L66yXC5Gh6rcy9pvOmYvOTUBtXSUZyyAHlYnNzKwu/O8bri9iCML
	Mh/qbof0JGdArykEsfpMOcOR9bU5L7k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf27.hostedemail.com: domain of 3x2iVagkbAEo4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3x2iVagkbAEo4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788176584;
	b=s8sc51BaRwbkvGtylfOW2A6tTVwfl5jB6NDsLoPklYA2JOcFkQi0biX/UchZjpcyhIM2Pa
	aJ6xYdPnyKSkTDlxPczfL3EUZhqQFfQ019nzxm36rdq3AMLr4k8oxdaA+ajzhgzHd3X1Xi
	gUoTHFtKS0wZdqRaFDvxIrJ+6vzE+xk=
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4b28deb7ee3so5163194b6e.0
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:43:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788176583; x=1788781383;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=I5LM+0Pjsyiw43Y9OPRtVO7+pR519d5y9NI1syLmG3Y=;
        b=awiBhh9nYZyavo1ahZPavPnbjPgdN56dgns3R7WH8APxshLeiNZ5kirIzAMUSINHOg
         gUuxlBiNWqfI5iHztblmkn8eeSrg2QLtu45fojhVZFh8J/2qsJlxiQCc4i8+le+3aRAz
         ofM1xAEUTeDfZe0xttEGAFy3LBqchG54y8Y8HScP3ojwGiwb+iBQ/wBv0H/ichLT4y2Q
         E7nslgPCrYKHvxtA80iBhRfqo5qTsvBJMARuVtUtiMjrMhsuS3hTnuQV09Rhp/PCOL1J
         qdarocT5ibM1R+C2mMcMNJSlEw1JKcFZFhL391voMrhmGPMIGe3tdJqO70RhwWjtKbxg
         8+yA==
X-Forwarded-Encrypted: i=1; AHgh+Rrp6O8ruB7SNIxZ5+btMHRduQBfAA1JBVVjcOLzjv7Klv+VheMmU4EEGU2dB8Ei999hZt4ZwMjO0w==@kvack.org
X-Gm-Message-State: AFuF++nlmLyxjVOHS6D+lJ9JdAic5OsFS4AoeLmFYIZhmknbFyj1a4PI
	tUMZV1aIXBFMJOdLK/buAtF4bIbUNmgolsGl3999YI4dBUBKS6dD5Uh5UdsEUTb0ETwndvxyN9M
	bU7iLAkho4bl1TKqHSqEhjXcjZZLQ8B1RS7h3NsSphTZExeItexlm+EklZZ0=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:251a:b0:4b3:7c33:456 with SMTP id
 5614622812f47-4b5b81720ddmr416388b6e.11.1788176583352; Mon, 31 Aug 2026
 04:43:03 -0700 (PDT)
Date: Mon, 31 Aug 2026 04:43:03 -0700
In-Reply-To: <20260831084159.410474-1-junjie.cao@intel.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a9568c7.a8e469d2.cbf3.5619.GAE@google.com>
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in __mmap_complete
From: syzbot <syzbot+e4aa91d7f20c34417d4e@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, davem@davemloft.net, dvyukov@google.com, 
	edumazet@google.com, elver@google.com, glider@google.com, horms@kernel.org, 
	jannh@google.com, jhs@mojatatu.com, jiri@resnulli.us, junjie.cao@intel.com, 
	kasan-dev@googlegroups.com, kuba@kernel.org, liam.howlett@oracle.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	netdev@vger.kernel.org, pabeni@redhat.com, pfalcato@suse.de, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz, vinicius.gomes@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: z47d9hpp7cujdet1x6tci6u5kqapuj5e
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 57A3B40002
X-Rspam-User: 
X-HE-Tag: 1788176584-556606
X-HE-Meta: U2FsdGVkX19l/BVQjAgRaOXz8j69CTSfqpFCq/D7l9nGx+GAvKfxptjAba0DLSSbhcyZsleiO6aA843f62wxLlmX1ytB9Cnr4F09O7ZHwsX9RNloVjFAPStCrjOzhBcn5Vm7P6524SlMTA/NzLTj6kA7Ko/SzgIjIghEvXrPr4EeQmzLfTknrlzfBCTElPnBGtaJ/9Mv+EvEk/5FX/lBfcv1vpRB1SmUf0vapZX66oKLlOcX3O5C84wloJsyW1Fa9QfCmA6yCpDuRutFxcSqXhk00FOf5tFB3ZgYPHUP3DLN8TO0okHDl/QP9am5ueOKRaiN+qKwbbsBW/SrJsiTh3o12bfC3DQGktkcAdoBMaQWgbfZYqdPNltuVw5kSqT/BtTXaYJjkZlEIt0b+4FKg8MZBZ8slc1rNkcY6SXzFUeObsMOodz0aHsPcyZ5jV1E+DS93qnSLKMv7QNElEiHNfVTM/lnvTfjnx1bXmmIDwsSZaE/wC+jHMAvadE00J7Sas/2gw5YU/JOOGBh0nxDudFPZDlJPvLnvvBnYDg1swPJvLJsAhczt2lQSF0lluAW0IZu7r0aKJXoK3Ldu1igLnF55q3KDKd9kIsndBGmpyHJNrztA6yTPLao5D0SCTX0Nsif3ndwdRBpNxGIqOVaf2Ze0mIGDISi7rbl1rIHVu4gSk1CTAfzlSt2JG1vvExEs0KzhoH57u8F1YNl0UisqIFbAe0tBnZp/eAiFv5LMaLABhCsTqvWaYjPqwYkiMDp4SzFnLZj5V6HypaQsRL8cu/ynKsB6jnQZfIRQJLmcdd3wBm+HauFlaeHpeJFk/4Kn//zCbFUjWJqbx97fuJE+OrT+cecuacyzhST04rGKCLiGzl6VOCW/9d8MtlZrTWVlBtEmwdicROMVs3qW0xeTArwPKTc7Nati06Fphjp3keh3Yx9er+swHgojECVPEcnnnbRsjuOI4Qp5QvbEFB
 a2ixfXhw
 ZU2upa3c1E6zHmgYk1SdZAkbJu9tz/i6ex5lbkr7olZf1fmSOI1xLuJvkXE8llX7jRwg+bTX9KL0EIwXXT+1B2kgXOj0+JHe2P9MNCw0iYZNgq9aaZuq2gWZ5Zy/0NE5yoct4B2hHaIVyBNm7SBg3rTiOnBLpFttwrWorUBgYC3NUy2jcSR+rX18PEh5qZTb8DZ7IbpHtKQuxAobB+JLrOhxW4m/76yaN3Lrwwst4TpwLWgn1H3vPuCREcLFBqlwyNzVlZ0w9OsU1Swg1dGDlUFvlhxAVaCK+E4V9fexs44pBjJQsYVJFWHJBWoUorT0IMKFdrSnk5oeKfG80pEfJY97WPS3zyAFYKl/nqN7pr0LDKHE5/CvPk3/44bW0HvwtU/nQAFTEj2C/6Gil0Qb1UAm9uivm8JTUQPk11aXWVTKAlM1aNpXXhkcadmQF5BLGwbe4fSDvUFLIA8lxjGyTXQHF/jHFiWFGKKuiw9In05594XDeuAQ3/5wWre87pOe3dWMoNZyH/di2Dcmqg2ybWGqhvzCw1VvcvSUaOlME2s7/uyIfE3o0NxKlUQwwhfWAnvQ1DiMLUU70r35Dt0O200OPmdlzLyGfd5mncShYOnHXMq3h5/x82bZr5VYW3o3PgBlT7zeJ4s7qDCUgV0qKnSkyochIsecCtQzjspCw5yyyZHOCBJ23dc/+vc+dKQQ5hQUnA7slyjjpvMJ9AtvZ2SoGv/5jUARaisG2eHlJ/X0CJKnwCvUFbHLhyYp1qRmrICPIdsxEdE/7IIc7o49litmY5ENaMZhQTxB5svKuuBm0xqdiOXVUI+rKDHoy/+6i56x2hV88lOFP/FSgYJWbBPqt5WJDSfYibLpeVv0VUL7Hd1EKLFl7FIxYfsdOgw+viA+9Uy9yjmUI0qclnpRO+E1zcA20jCjyQBZKLEuwtV8zuIQ5ehX8AUbQY+nPM2/MjlByXKvDOo3NSoaAl6qXgnOHdk6b
 N4MHDd23
 4Fw/GsUKUzJ7Laeza8FkjXInHStyCUq6fmbVtGDzIQM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+e4aa91d7f20c34417d4e@syzkaller.appspotmail.com
Tested-by: syzbot+e4aa91d7f20c34417d4e@syzkaller.appspotmail.com

Tested on:

commit:         1bb784eb Merge branch 'net-phy-fix-cleanup-after-probe..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
console output: https://syzkaller.appspot.com/x/log.txt?x=17e3be25580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5e4e3a0e188a497e
dashboard link: https://syzkaller.appspot.com/bug?extid=e4aa91d7f20c34417d4e
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=171ebe25580000

Note: testing is done by a robot and is best-effort only.

