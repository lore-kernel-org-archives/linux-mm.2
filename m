Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2A84606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED8CA6B06D9; Tue, 27 Oct 2026 08:08:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E89216B06DB; Tue, 27 Oct 2026 08:08:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC7C56B06DC; Tue, 27 Oct 2026 08:08:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8A496B06D9
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:08:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 50A348099E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:08:59 +0000 (UTC)
X-FDA: 85368285198.20.056D03B
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf18.hostedemail.com (Postfix) with ESMTP id ADE6B1C0009
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:08:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of 3WJTgagkbAGERXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3WJTgagkbAGERXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793102937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=3x0gcGxLoe8xh9zXM3KZqk8OeXnLeLRjDbX8BPObqNg=;
	b=Ff2liJiqtUP9JTHM5C24cJ7pZp/hWYS3GXUuctrGxsnYuziiw1luj0/6gUQdiEZWOrdChS
	CktPVSlGz46rSyDdh3xnM7kQvSK/tVhvSfolmOer+kBuMQyoJiYQDkUzyccBVFRumKTTS3
	Zc3LCE8MqGCjz5aJSSHEWECSgRuLdZ0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of 3WJTgagkbAGERXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3WJTgagkbAGERXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793102937;
	b=yzqeCnx+SOyklM1LgyXXiErQNGexxQSHXORQPiYWoEGi0lKk5YNJqsBdbm/BhtpxzjdZmV
	+tAWJo2LWiRv1ii/GlmSd1MiFZjS/GBgZv2WY82sIh6BgYeat8sqBV3p2r9RhxBeLlmyfv
	07zHGsEx4sw6KGMxMs/owAomubeYdsU=
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4e937c5bd4fso3669462b6e.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:08:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793102937; x=1793707737;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3x0gcGxLoe8xh9zXM3KZqk8OeXnLeLRjDbX8BPObqNg=;
        b=L2dm4Z5tRjEfUpBK5OjyWslsG9ENA82khwvbcnT9lYNZrFDa/d/A39yJbgfQ7obgkC
         gAzWD1TNG7HAcuUuSdHGirxOpClr8GaRKtd9jceMRUvYrATzSi9rj+62whXbdaz2slPh
         pQ7yrAyUiJrjEhhjq2HXuFWYUH2Vwm/mPufaYpghHGTLG9AIlDcqc1mXhp4Z0G/fMQf9
         zmdBLJJ9AxNJ6+lA8jNyjpGKt1/4rr2IsyfAthgiLgeqlnGKVT+0lTOTdxbfrdJKxgL5
         gAeOdaYZLP3c32Q8RlzWCuUEJlZS+ju1XFXW3fjKWC5oLsietedoFwAlN8+Y3+czvdhh
         AdOQ==
X-Forwarded-Encrypted: i=1; AKwUvBwS4o0XDtq/5SkoTIdONyjMO065uIEx84qzMY5aCccko86qzAWTWRla46248l1wjFM/fZ5qQv0A6w==@kvack.org
X-Gm-Message-State: AFq9FYLZo7y8d5smie/M8JhJSgEpUZtIxmDSYxOL1SP7SFBMe9WqxbSL
	otxlrIQUlX0Ouz4YxawRKAtGjSlX6lP4i87Oo+i1s7ZsgHx9ySuiTuQmP9Umjuhcl8ALDUYfBjM
	IbWryWpTuCdsPDzovMRJa4Nm3kTBLL6yH88EGH7BQh44Yuav0+NsWEPc17Eo=
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1822:b0:550:de67:2631 with SMTP id
 5614622812f47-55c00414357mr5845145b6e.63.1793102936555; Tue, 27 Oct 2026
 05:08:56 -0700 (PDT)
Date: Tue, 27 Oct 2026 05:08:56 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae09458.f0fe5aea.79aa1.008e.GAE@google.com>
Subject: [syzbot] [mm?] [usb?] WARNING in corrupted (4)
From: syzbot <syzbot+9fe09db3795456e0b442@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, cl@gentwo.org, hao.li@linux.dev, 
	harry@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-usb@vger.kernel.org, rientjes@google.com, roman.gushchin@linux.dev, 
	syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ADE6B1C0009
X-Stat-Signature: eonftr5zze3xubj3q6hk5t7r37sy6zm8
X-Rspam-User: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793102937-134792
X-HE-Meta: U2FsdGVkX19YFT0gf9kl8cwi+wyMw2PjMqa+ymYHb2E0KXID5bJ7zMH982upfkj5RCZ+RxFq2Fc+UtBbBEkcJXJv2S3Hy3VZIgbs6QGIK2noIP3rw30m4ufwaa5UVnTZgzwv4ROHKX8fFl3BafdecTlYg7Sj0iftYsafz8w3Ud5kC+y28zQVEdsosKnEJqV3RPZGY8+f26DfJEqW+3nTe8KUOBjC7YDs1EbPJ4eKEEAPaadS0QUhYfLQfGent9h/fmijfUIlz1uTZKbLevNTHMp47mXLHwotXGKc1O1w9Z3i9hMSMcO8IsmwLm7JC3ySjk0Kv7R3eFJQm8dXCn53MFmxT4rQkOSN1gzBZ+ys8IyDcccQztIyTqKT+JjRJ5sLpJzBIIp+iiY85MB9V5woC1Rs7OUKSwyRKUhWorvV2rHtii5SteuS6/EnWohiGckLhCKlMg3j/rsH0ud8yTFmqMZ1ONy8woa+2pKUffik7ioaifqUyEPRNV0APE+jauWsfYEMDEBL5Rs618inJki4lzHrTBlclPf6wx0UeH+qhrox3f2RrueLiiPPBCyQNYWj+dlWiqfQVzVGGtfCGL9l+iNrZtpwv1iZ81s3lm4Pi4m9G1PHpPAfx7Kaym01oBk0859Fe5JfJMgBI2myH/AjCJ6ypSOImmeRFSyKmMvZPg77CRE1h4BjB5PR0/75ij3fnViIZe/fALAU1vQjMQwflI1IeqwjZmHlFLiXDgKjmbKB6yDJI0ogQUT1FYTKxVoMIDkix2t8+DfpHdHiQlqZY0f6sCOJhNkbSXw0JZKseLzC/ElE/vVYBNW8LwpektyYYa4GsYoZSwons5RYI2KZvkwWAf7kr92lhJtspw/0bTi7poSl+t2tpiuKKp0OPZMkudKNXYI37+NMAaQPISNaYzvugREO2QObFHoAoOzh0FVXioZ1qBbiMbEWvUqZ53aX1pB5Cxx7E+4gE8iTZ74
 khMWwAx5
 6w/kYhIOoAk0W6Zlu40tS1UUN2l/u+jgb62W5tzfStL8Xs/fTgvgG8PKdYCD7uOy1PqP5QKxoGQi9gc9yB6ssmUSAmTFCDET/xdnjaufSx0WlP7fHSckulh/T9AY1KA6TSM4uQiYH5qM66mErSNK0Nl4oGPTUwCuJaUxVmufI/VuW5XOwbOMG5uySHW3ZhPNFTFmtPF95y97WIVfL4iyI5nBe3HdeY5fB5qhmGkiEo7DsUTI7BczfFNGqiO7s41CxQ+voz2xD8rah8YS5ubCY9uhqVTfJFAn8UYRArKDFQ/G/HmTGWOOasv/LzTkfod7b/IF7hwZD6xP+DVv09qw1JzLyMait2u3+50ZdDMFj3wCzbD5xx16mKSAFRyFPZ3YRgN0U3+rcw2oqA+VjZbynusBP5cbYtffH2+6C852QgCYONUsxV90mkX85dapoAn8cU2lHpN47sAFFkYg8zSMcHpUOvy1vw2moo3H6yl1LSLiEWbbC16ons1vQn+LBRJrl4K+nSLVYiJzvY4Cxfg9jURBdLSm0CI/iR/xeX4sEysn0SQcX9IIUV674/UhRFEF71aXxUAoaDH2L3LK27pGeHOJlI6pR033XlGEn68aFqwDIMUL4O66Zf7EJqzUnVCVlvh6lvwvvrkMdEG4S6jqmvDgEkuexsTxdzDZpm2CPdB7RKkLlbllnx5jCOKC2uaHIyQ2cz4gsrgMvGkSQpbXvSSlmSVGDNvZpuEukJ+XUEGFCJsjcdcZwHron2cDsTr77ojzGDtxO7P2ocUrV9dO7UNKyr4XsGXjadmZdk5gz9aSmL02N7k4W2cu9u+2kIuQkszJ6MDUbIKAMQCS8MNO96CNmG3okK7r4V98/OAR90+Mn/6IKi4/OmGG8y9xhg/F5njm5yaQaIMIK7kCY13kXmaG5WDNTfimPeT8KI28oCwxKPrp7Dj+Emqx4yyPSHiHiufnJYjxjcHih2/r1vXFv74jOiEaM
 rXpnriRp
 QUVGYynWa7HrMa+J/zmmFE6LoLQ4MsAi8edQhThGTIv/KkAQcazUxMBKdjz/qHmpP5y3RsfC9i1vOMsjsLfulkOgHMobMs4r6KNqunUV9SYmCZII7Pakgr25dxUl6WYhgXePaAA8OO0qAJ4Ihy5HSKqU3lNrulNK7JZtCz4q2s7sj4dHwa2y1ySIO5ydvlVEIKSW8TmyG2usv6pijE7E/f44urSGO7DQwuoAhyKHs67K30S0Y6GYltpOzL/1bjuhI/lBiSY6r3AtP9iJfxnTCerxE7+YKrWJQJ2QpI3nD13md5PSEBTKNJbIsxTNfY56DHsuWB9VpatRdc1xKedk0mmi4Q6EyHjWpldZgN68DUXVxGUMOxZYRQXcD8RYYF9QQQCln25TqDDCQMvZT4AN3Unl3+xKzpAv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,

syzbot found the following issue on:

HEAD commit:    5b0764a53235 Merge tag 'drm-next-2026-10-21' of https://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13739fc9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fd1433abd362f255
dashboard link: https://syzkaller.appspot.com/bug?extid=9fe09db3795456e0b442
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11cb9b0d580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/05ac8658d211/disk-5b0764a5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9cfb73243216/vmlinux-5b0764a5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fc45c7faf785/bzImage-5b0764a5.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9fe09db3795456e0b442@syzkaller.appspotmail.com

------------[ cut here ]------------
!PageLargeKmalloc(page)
WARNING: mm/slub.c:6855 at free_large_kmalloc+0x97/0x110 mm/slub.c:6855, CPU#0: kworker/0:1/10


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

