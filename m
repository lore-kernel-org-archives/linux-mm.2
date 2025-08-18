Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A53D6CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 13:22:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 428326B00E5; Mon, 18 Aug 2025 09:22:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 400166B00F9; Mon, 18 Aug 2025 09:22:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3439D8E0006; Mon, 18 Aug 2025 09:22:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 233746B00E5
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 09:22:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C999B1A0949
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:22:04 +0000 (UTC)
X-FDA: 83789941368.17.37827A3
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	by imf11.hostedemail.com (Postfix) with ESMTP id 508614000F
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:22:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of 3-iijaAkbACUTZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=3-iijaAkbACUTZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755523323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=jBjSEV5oA+OTjDYadcwIgim28mkwpg9xM7xVheogjjk=;
	b=rYAZFdFu0U7EBywR1v7mvG0FuI02xgKRWKjp531Ii3EUq8C8kqZNVrh3WOcmSSAswOl04D
	sB9aOnG4LOByS7ZQcRO+peKZUzD4IZgVzDSCOGpfdXaKEuG/eeQoCVqGU43NykdJWH6ayU
	yIRc5otuD5xseZdakMmR6JfXZ5a74eg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of 3-iijaAkbACUTZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=3-iijaAkbACUTZaLBMMFSBQQJE.HPPHMFVTFSDPOUFOU.DPN@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755523323; a=rsa-sha256;
	cv=none;
	b=jdA3EZbzFjlyVnbdLjcIHNhrzo5NqX0YIVCXncDyrW3/okFVaabUsaVPqvvr0wACc44glo
	HlSzzUDvdOxLiWvHx4jhTBVBgFhdCF4yfpkT9Y4sN9gL00gzC7vVL5ZFWRM70u+qklShR/
	8e1x0GCGkGTYeh5WuTAI+nQmnDbtlgs=
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3e66b7e4a94so32975695ab.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:22:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755523322; x=1756128122;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jBjSEV5oA+OTjDYadcwIgim28mkwpg9xM7xVheogjjk=;
        b=ugce9//M1H819JPGvZFBDoXzMZjWJqCemfuFaBCni6tfoWFZtsNRbBZ7/0n+6oZzhw
         51y08RtvpLPtHtpwfWx9IFZ3c4A+wMPpvlMoatbjmwRZDzs8u5e2k0dg1hw96NT85qhI
         0Ju9uTZCWTjDS7Gx1ZPOnO2ORfd0sSWltpCcoSTJg8RJ1Tk7ktn5/F2tcjW7t+34bXHe
         mDU4IfYqP9xpuMAGXXUemfSNBFUQnTShe1ipa58g9WB1DJ0pFqDLqyyMSt1SNEARWhCq
         XuABhSbyZjPv9X7qkch5FSO7iO+Y5BkWnwJODcOCwc36aN1qA8Kf31t7F9le7quAVmZ/
         4/uA==
X-Forwarded-Encrypted: i=1; AJvYcCVzcE+YV2C46fSCyup2JEZnlIjjWWrS5Hxk/N8SHTDsm57PAM9O/i6vWN3edXOhqqqAXGIhVmyBGg==@kvack.org
X-Gm-Message-State: AOJu0YzhXODgkyK85/gn8OV5+yWdDSQliLHTiU7yNV29i9/B7q8BUsXP
	Xlx2QAyHs9i4uq8X2Mx355sxJwEziVrWHRaanr79MrhGFGVzGGwSHfnH6cqZNoHDqaCA1wbvcGZ
	uqkSaS/cJ1wG8I+skktOrzanxKO5MD/q9RQyPZVqpNGfIomYsNqbETbxKntY=
X-Google-Smtp-Source: AGHT+IFeHyKsXWMtuvFdAQyvFVMtBa+BrbCcxBxKglSNVT+gHxpEhdduHZnu4ubmttYznpnz/tSDIlpjoG+UjmUHotmvTJdTKxx3
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12e4:b0:3e5:5cee:a9ba with SMTP id
 e9e14a558f8ab-3e5837cd1bfmr171751805ab.5.1755523322445; Mon, 18 Aug 2025
 06:22:02 -0700 (PDT)
Date: Mon, 18 Aug 2025 06:22:02 -0700
In-Reply-To: <f07b06de-77e4-4d50-9d97-18590faf0b10@redhat.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a328fa.050a0220.e29e5.00a9.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in move_page_tables
From: syzbot <syzbot+4d9a13f0797c46a29e42@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@redhat.com, harry.yoo@oracle.com, 
	jannh@google.com, liam.howlett@oracle.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, miko.lenczewski@arm.com, 
	peterx@redhat.com, pfalcato@suse.de, ryan.roberts@arm.com, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 508614000F
X-Stat-Signature: cjfekbpusnm1fi41xe5hm94k9t4tm3eq
X-Rspam-User: 
X-HE-Tag: 1755523323-223536
X-HE-Meta: U2FsdGVkX187qy46rKaplaTM3H1hLIITEkwbuFfFJnVwoePrAHVegKVajBJfwJNL3tomu3r9GASzhD31/88N4K89/ewEZWtTW/RA7LbCMjDKd2k70kxDgJwaRYBSGhkM8XsNM2lkWFtht8PmZifj+2aZXJsts+rz6+cKbgHOWwIaPwH/pa9KI716NxRF7zUDEW6HEyyZoARVo2rgRE2ou711roIfX/Pdcg+nmBJKNelJpemwmPv4e4M+BAxO2jfqW2nPqBf2mEeXmm9w54eWjTMryh+3miV79azlfRe6FNQMiWzN+Xro6REM+uBuTo4/kRFrlOoBzoy1SYAEBvvdf9NT8yMUJhkhymZ/gv41FkpGT8WaUi5lwvHVnGpPGbRXHsg1VXfaBCvVCs+pGOJURtisZtFhRnP1pklpydkNvD3lBc4WivUp4cN1upfaHtRQqUo5DvkAd9kyX2AXOX5O0wYPZx2ye88R0lKwtH6AgIVqrcNZOxhCVEDYPV/d3dPzx4I7RgUPwJAnCD2F2S0m9rMZgy3bBbuffsM6KscvigruJcvmTMLV3czOoiIp5MDKLrgKZD/jP4yZJb7sDLOVdwZ3Jev/fhlBgyrB9UmkG85dD1l4qYTQw6ZNhKFDMnkz496c0Kn7/c3vpYZqcMtJTf0/4iekq3q8pvaFqCXF049MhUKRTiOvZnEWsAMDqdx/aB7oOEW80QdseKNls8lNIlr3nG8hVxBSwR6Sr20ZDyLuAXzn0DmSmdonJrSfm8po7pZyIHg25QIWxT7Ld5BaeRqHDUwke2xlLmwItC4F/vCeEQAkCDTecVSPV8MlNbewz62AYTk9LS+FXs/FyqsTkua9p7+7oL4ATT2P6a/KthlbnWwvyNJwV4KonXLjDfZUW0/Glx8jQZ3eqOHLYtJ3WBlzsEb+xYGB7Lz8XK0NfR2DmQLVMbyjzWt5qEQQlB2jNsSCjvaactsI45xd7Ud
 o/SL90C2
 AgQPQrdIwNGOX2Nt7vHhfNoEUxl0/GGgSH5GZkrTTNT78/70XEVAprS1EBbNdP01KY4YvXXYcX0FU2sPJic3JMJTKEmtXnRhlzqFCsyE/fLUWx/rs/mAFtFNV5xBVR7/IIg2C5h6/bAnfrekNV7eLOysTJUB7juk1u3GYK26ktCko5xcZ+qiqvaPSxQ3fufCc0akOLJJ333Vsq4MUApKroDH4h3rlpaILp1AKtyFzd3f3nnzlIwSbE3E7hMw9xm6AlRAxZ5dHTctNmqHuuORI/7ZGrZgUTT63SzEG5wuaPPf5MtsO0k+bdbw8VnheS4f6qohybaiY+6QnsBLPhmnCcOf6T2H6IlZ4gjWIIvwDAMMOLSSU6nyrZR0d9FtOZgVIDsR4yF9uWZDVd/I67IJFUuTnqAhDONJKjG2iItHVzgKtZYvx0GZoEnpL6cyFMBV9UJnUngUXos+wGd7S401jSaJe+U+7uAOKq2sYVQZX527GJAhD4o0sAPu3kuWpJZwtbFjU3JkLpdSOGnrRGXNlcH94buwpXKDW+DrNsk5uvqrTMT6+5s2P9xSJiEVHS4qlKSgEZsAY72Gi47wfZ7e8SwSh21ZTvzOkqooCi9ZuciSvkSC/ujPWJy9gm5DpxWq7/JkGP1eXPOvSJQkH3GrgdNfHitpBC8NcEQ6VfFZ0CLJhtbUU8W68BzoRgEzqzNqQAWrI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+4d9a13f0797c46a29e42@syzkaller.appspotmail.com
Tested-by: syzbot+4d9a13f0797c46a29e42@syzkaller.appspotmail.com

Tested on:

commit:         eaa49d2c tmp
git tree:       https://github.com/davidhildenbrand/linux.git uffd-wp
console output: https://syzkaller.appspot.com/x/log.txt?x=151c5234580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=247d4d29e685f61c
dashboard link: https://syzkaller.appspot.com/bug?extid=4d9a13f0797c46a29e42
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

