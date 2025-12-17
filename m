Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA78BD65C58
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 15:06:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10A3C6B0088; Wed, 17 Dec 2025 10:06:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B7D36B0089; Wed, 17 Dec 2025 10:06:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECEA96B008A; Wed, 17 Dec 2025 10:06:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D98426B0088
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 10:06:32 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 80F1A60C5A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 15:06:32 +0000 (UTC)
X-FDA: 84229289424.05.67DB3AD
Received: from mail-ot1-f79.google.com (mail-ot1-f79.google.com [209.85.210.79])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9BEC1C0013
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 15:06:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of 39cZCaQkbAN4SYZKALLERAPPID.GOOGLEUSERCONTENT.COM@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.79 as permitted sender) smtp.mailfrom=39cZCaQkbAN4SYZKALLERAPPID.GOOGLEUSERCONTENT.COM@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765983990; a=rsa-sha256;
	cv=none;
	b=Gz056kgzhd4BgjuwARQ24y9MlGZdznssmm8/AJbl1pqc165gwJU/oL6NZpnwzAUsNjn1f5
	HjHcsnX6TUQ/CDeYDuDOeCmwO/M8deAS2WQ9IGyzyDDClz29jc6tFPNEDrKOE4XS0gcNfW
	TCdldXwxukrlCM57YuopDKIAd9a3pjc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of 39cZCaQkbAN4SYZKALLERAPPID.GOOGLEUSERCONTENT.COM@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.79 as permitted sender) smtp.mailfrom=39cZCaQkbAN4SYZKALLERAPPID.GOOGLEUSERCONTENT.COM@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765983990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=+LXp+/OiwgJFK4+HBN1KxSKPTjJfUuQ79kirzdSqjQA=;
	b=H4lHcWbHw5HS57MJAlxYRXTdKqeQf6y85MkRlHB7xEwNfM2o/VOr2klvn9/GuyWtuUj8fX
	8dGAaGJFyzvtz2BsPXOPLHmn5cPgn5B8N20+UOQ5O6O1UB11ldg0v4eYhPFLsh8WkvzV3l
	jIk0XiFB8l4jtFv4UJydB6pNfM3VhLE=
Received: by mail-ot1-f79.google.com with SMTP id 46e09a7af769-7c76977192eso14454460a34.3
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:06:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765983989; x=1766588789;
        h=content-transfer-encoding:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+LXp+/OiwgJFK4+HBN1KxSKPTjJfUuQ79kirzdSqjQA=;
        b=KJamHvLQCWCvxJkL3Y/k9VLnPKos5v9CPvkzg9iMPpbDP9mIL1TricNC4qbFF9BZGP
         aFfagWaKdxlvbkHGgVD/HidAohHfeOBYE+dvQebda9Lu2tAZtcIeDfs9wF5AiDVF4ZQ9
         dy9Wynsh851vQqI9QzsgOhFRE6ojGJuO2rjEKQIkYc5EQoP/5iAHRN2juS1oN/jKrqOG
         JiYDPAX1jY97xG4hnxcza/D+4ljVIR9BUDvgvDxrcI3TkvaJRyZzuC5smH5QmYZOny5b
         WDb+mvVBzUe7DdeKFZZm7N+FQ/POR9AqHSNwi+GO+odPHQjK9ei7iPefJS1w6zT7dVzo
         ezsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNykTFOQ0xxpQ5/hC1oFQSgYzT7rq3tD38Ex7/oAHS2ayXZLK7UEIQuEWjA1m2gS0aditXDz0Kgg==@kvack.org
X-Gm-Message-State: AOJu0YwcN0aZkiAVBMAGbrWSqQnPg9LeSij2Gz3IIoErAnvCfJk+0f5R
	IIKahHHAtn3xiFS3fB7m2aNqh5gvbwKJ4oTpHZ/iwBXXPRYr2d0LtXqVZUw/VehvzGe8pisEFj2
	+RNt6W9BQ6MdkJqf/3QKRGvsz27cOmKdxoT0pV6txdHRBJ3/w+GeN9hmA208=
X-Google-Smtp-Source: AGHT+IEepE1vOkZRfZw65Yq1mLKX8fjSXWFd+RCC7vexsDa9QIOBmOOjGkoOx7rg/oWkXOnGdoUhwKHlpGYWuc7/8UmLqU7NJZSW
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4df7:b0:659:9a49:8f11 with SMTP id
 006d021491bc7-65b45151581mr7967725eaf.34.1765983989465; Wed, 17 Dec 2025
 07:06:29 -0800 (PST)
Date: Wed, 17 Dec 2025 07:06:29 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6942c6f5.a70a0220.207337.0063.GAE@google.com>
Subject: [syzbot] [xfs] general protection fault in workingset_refault (3)
From: syzbot <syzbot+ccf9f05f06b4b951f3cd@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axelrasmussen@google.com, cem@kernel.org, 
	david@kernel.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	mhocko@kernel.org, shakeel.butt@linux.dev, syzkaller-bugs@googlegroups.com, 
	weixugc@google.com, yuanchu@google.com, zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9BEC1C0013
X-Stat-Signature: sem3qfr4zu6qeb4rxuc4sae9d6ue589n
X-Rspam-User: 
X-HE-Tag: 1765983990-745917
X-HE-Meta: U2FsdGVkX1/t4JrAUh2DebnJgC/3UN/c2PY1PwDsOsIcVi0uout3CdVo0XWGW6y3XUGs/eINrG+biaz0ti5KojCfNpEYF58WlyQjC7Tw2GtidOElcNYL1P6YodOWEa9kh/IjSUWhYVPaNO8aOApbeiUggRWsOYEiraCgibGsqV1/sEjAEF5UvN3Sa7B5mf6DPoM8ivo/tltHNm16bHFMWdK8HWezdBYnbYRz5Tb+v/cJdilAjC7thOECn6t0dm0l+th+Vwy+9O4ushuvEe287kIC57AmZSiKJMulBPibCou1X+lROOt//R3js9BWfF5k05emLTMPlytcVFU+1qCtulWhscbjAMHEa8wgD7Vlq60xS80yqZwBGO8TbO3cHwCOYiXK7oofKbTZm3EODip0y73wuCmb3niArdie9kj/EzyEtPzHNL4AxZgsx7L1qJ3SqS/bqq9NBwoCfJlF1kZptjMp+OFeMiqMfz+9cbff5pr7m4+MtzINmbjShqsTwfMTcGI3bQqxpEkgXDVQsdzjJj7t3BJwNErr0KqLH31Miw7iGgPnsXBmPJITZoKVnYyToEp5h2X6ZC0BD1fYxRyUQDOaxE5z+n2od93+HFTIEz+m6EgK5U62QMKbZXH/3pn3n4apAxsMiPYdL39uzuVRTCziTHkRqrBTMnRzQ2PGI9SsWiV+AGjHV4hb/Udxin5JJbuG+y9niAmzzAsJHuUuzGYAe0FcntG060REJR2kLS0a60F7o9Ttl3teyTS9ZCowHiNWkj7VYpLW7uuqoI9QJbLBTzmrbtREhCXGlHpBk0sylIyLQEavGrJvqZOaI3kQapQyehpWURWutQ91W4D7eby/SUy29id+wMpGAB2EoGW3oS2ob9Le+K5/ynATBa4Lfxp5TliyytHy8mgXZ3ZEJbo2wIKBL35lzGJwlfLHE4EOz4/jVuNLmnWol/NXPALWZPCbyq1cfMOd7JBMxlz
 +iiX9TNE
 MoPRN67r/CHQGGOZpUe/etg2N9qHFv7LrvFj9u2fhWUB5Vh7aDFgkS+t1x/Hiz0e8alYR62stjjEZqGLhgrDakyz71UBbZ6+RS7/PkIwsUrSjICAZ49c8CuCshXPejAaB518YrpL3i1J871z01HOnK2jtfgZSiAIGhYuXByGzIfz7/FHEFio3gnxz1OTg9vN1ACdtAziTGepCmJkkgbIoO0zM3g6aJMAPOTYcH0Db6iORZEOyq9NEB3RLsgvVPj1+/5VB1rgn7H7KMhkCknb6PSx0+2S79JJ8RnHEME32H/SnP5QwHe7wXvF7Pe2HgGm+eAZuPa0hTcAUfeaqIduE8YKIfGrC5ezjuj7j12IIU9GoQTWrLIZcTQsX/JY229SazAEKi43yVcPropxKG3dax/le4WgFg5EYChbJry5RafC29TXiG5OWHPPna6gmdSsKQhytwPfrziIQ113oWOdFEHl4V5T1rFZIv8Lhmma1ucmU5EIOG43UhDYmf3G2CdqlNWuI/48+7Pm2si4Ga77XyzItx9S6mpIwp0tD85Nd9sHoqlvTbMfjLk0QdmerD48SNPQIafCszQWnYLi8jGBcj/D66t/YpoNSPgDEoHTY0nh2bjk5WjipJlMyWjv/nanSh5yvfcaym9FV3FWgwI7Uun6QnveLnA2rI2D4KUw1XnqeAyzRiA9KTO5BxoJGiF8fMTZmeNQIAN6UhKIcs2t6vwgD/C38YmjuU0gZMGK4oFkMkC6r0S8Uh7uVBtbw2Twos/gSOyXiUALpQ5tkwv9UJYTmzUGahPMwByKOUUCgZ8yvv9+ooH0r05z9FC+ae1eA4tz38iaBg1Phk0MTlkpmDPIWEVrSbIV/UHrHv6oe0WGliOdynzwC1QBXeV9jbbkqX4566dkkadgAa80JDTl3twzUrUL3ss+io82XgEBOOP/TfQTGaH++fGfqVa0mXZx0xXO5ksHsAzobSqr/1N3BcJIn4YbY
 vmk2ks8m
 McxFbFVqwu65pq5vP55kCa7g8zhTbPJtcBCz/Gu73PQYugcQHJeavKCNw6IO9s9WE3p/uq6VtjdW9xdMeWc3kpVgKx7MuSpQJzp+/YY2G8fMAsPBQ5bJ82VfwLYm/CimFx1kFJweS1D9flKF/Fft+eONPlfTjOwtTscNyqMSoA33GvBYgVkj/jNByZumcSvmL65czqJsSlFAuOn7NugWrdbU28vJKuM47/xup032Nd8jx1k5Pvp90Sq9ggpealCwLkZfGZ9p6VoRheIwoG/zV/PVLXZwz3vR7H7iSbby62K8nisrmSQ6QPIsniNyFp/93c9A7IpvBcFQUMTN+FvQXwmyxOsmPh8XbAk+NJwzubIDnr0AYJM4vOuY6RkECMD2dGDGUngZZHFImFBHGtC+9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    ea1013c15392 Merge tag 'bpf-fixes' of git://git.kernel.org.=
.
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=3D16a839b4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D513255d80ab78f2=
b
dashboard link: https://syzkaller.appspot.com/bug?extid=3Dccf9f05f06b4b951f=
3cd
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-=
1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d90=
0f083ada3/non_bootable_disk-ea1013c1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ea4d0b50128d/vmlinux-=
ea1013c1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f2e7f1524121/bzI=
mage-ea1013c1.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit=
:
Reported-by: syzbot+ccf9f05f06b4b951f3cd@syzkaller.appspotmail.com

Zero length message leads to an empty skb
loop0: detected capacity change from 0 to 32768
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
WARNING: The mand mount option has been deprecated and
         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
xfs: Unknown parameter '=EF=BF=BD=04'
Oops: general protection fault, probably for non-canonical address 0xdffffc=
00000009c0: 0000 [#1] SMP KASAN NOPTI
KASAN: probably user-memory-access in range [0x0000000000004e00-0x000000000=
0004e07]
CPU: 0 UID: 0 PID: 5343 Comm: syz.0.0 Not tainted syzkaller #0 PREEMPT(full=
)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16=
.3-2~bpo12+1 04/01/2014
RIP: 0010:mem_cgroup_lruvec include/linux/memcontrol.h:720 [inline]
RIP: 0010:lru_gen_test_recent mm/workingset.c:275 [inline]
RIP: 0010:lru_gen_refault mm/workingset.c:296 [inline]
RIP: 0010:workingset_refault+0x3f8/0x1170 mm/workingset.c:546
Code: 74 0c 48 c7 c7 e0 6a a2 8f e8 04 05 1d 00 4c 8b 35 3d c7 95 0d 49 81 =
c6 78 0c 00 00 4d 8d bd 00 4e 00 00 4c 89 f8 48 c1 e8 03 <42> 0f b6 04 20 8=
4 c0 0f 85 ce 05 00 00 49 63 07 4d 8d 34 c6 4c 89
RSP: 0018:ffffc9000a7b7880 EFLAGS: 00010206
RAX: 00000000000009c0 RBX: 0000000000000383 RCX: 0000000000100000
RDX: ffffc900208d2000 RSI: 0000000000000472 RDI: 0000000000000473
RBP: ffffc9000a7b7998 R08: ffff88801f7524c0 R09: 0000000000000002
R10: 0000000000000406 R11: 0000000000000002 R12: dffffc0000000000
R13: 0000000000000000 R14: ffff88801baf8c78 R15: 0000000000004e00
FS:  00007fbc75e8f6c0(0000) GS:ffff88808d22a000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000040 CR3: 000000001234e000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 filemap_add_folio+0x33f/0x540 mm/filemap.c:981
 do_read_cache_folio+0x32e/0x590 mm/filemap.c:4063
 freader_get_folio+0x3c7/0x830 lib/buildid.c:58
 freader_fetch+0xa3/0x750 lib/buildid.c:101
 __build_id_parse+0x133/0x7d0 lib/buildid.c:289
 do_procmap_query fs/proc/task_mmu.c:733 [inline]
 procfs_procmap_ioctl+0x76f/0xce0 fs/proc/task_mmu.c:813
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbc74f8f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbc75e8f038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007fbc751e5fa0 RCX: 00007fbc74f8f7c9
RDX: 0000200000000180 RSI: 00000000c0686611 RDI: 000000000000000d
RBP: 00007fbc75013f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fbc751e6038 R14: 00007fbc751e5fa0 R15: 00007fff29f355e8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:mem_cgroup_lruvec include/linux/memcontrol.h:720 [inline]
RIP: 0010:lru_gen_test_recent mm/workingset.c:275 [inline]
RIP: 0010:lru_gen_refault mm/workingset.c:296 [inline]
RIP: 0010:workingset_refault+0x3f8/0x1170 mm/workingset.c:546
Code: 74 0c 48 c7 c7 e0 6a a2 8f e8 04 05 1d 00 4c 8b 35 3d c7 95 0d 49 81 =
c6 78 0c 00 00 4d 8d bd 00 4e 00 00 4c 89 f8 48 c1 e8 03 <42> 0f b6 04 20 8=
4 c0 0f 85 ce 05 00 00 49 63 07 4d 8d 34 c6 4c 89
RSP: 0018:ffffc9000a7b7880 EFLAGS: 00010206
RAX: 00000000000009c0 RBX: 0000000000000383 RCX: 0000000000100000
RDX: ffffc900208d2000 RSI: 0000000000000472 RDI: 0000000000000473
RBP: ffffc9000a7b7998 R08: ffff88801f7524c0 R09: 0000000000000002
R10: 0000000000000406 R11: 0000000000000002 R12: dffffc0000000000
R13: 0000000000000000 R14: ffff88801baf8c78 R15: 0000000000004e00
FS:  00007fbc75e8f6c0(0000) GS:ffff88808d22a000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9f4cc08120 CR3: 000000001234e000 CR4: 0000000000352ef0
----------------
Code disassembly (best guess):
   0:	74 0c                	je     0xe
   2:	48 c7 c7 e0 6a a2 8f 	mov    $0xffffffff8fa26ae0,%rdi
   9:	e8 04 05 1d 00       	call   0x1d0512
   e:	4c 8b 35 3d c7 95 0d 	mov    0xd95c73d(%rip),%r14        # 0xd95c752
  15:	49 81 c6 78 0c 00 00 	add    $0xc78,%r14
  1c:	4d 8d bd 00 4e 00 00 	lea    0x4e00(%r13),%r15
  23:	4c 89 f8             	mov    %r15,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 0f b6 04 20       	movzbl (%rax,%r12,1),%eax <-- trapping instruct=
ion
  2f:	84 c0                	test   %al,%al
  31:	0f 85 ce 05 00 00    	jne    0x605
  37:	49 63 07             	movslq (%r15),%rax
  3a:	4d 8d 34 c6          	lea    (%r14,%rax,8),%r14
  3e:	4c                   	rex.WR
  3f:	89                   	.byte 0x89


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

