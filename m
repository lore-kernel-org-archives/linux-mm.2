Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEB9BCA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 12:42:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81E3A900157; Thu, 14 Aug 2025 08:42:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CF28900023; Thu, 14 Aug 2025 08:42:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70C26900157; Thu, 14 Aug 2025 08:42:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5C7AE900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:42:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0A21011770A
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:42:28 +0000 (UTC)
X-FDA: 83775326376.06.513B84C
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4AE99A0008
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:42:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf25.hostedemail.com: domain of 3sdmdaAkbACgWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.70 as permitted sender) smtp.mailfrom=3sdmdaAkbACgWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755175346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=zz/rWUCteoULmmIxjoLSoJd+Ko3CiZlGW/ae3x/QnaM=;
	b=3t56sZOLewDU3ealXooLROZDTqymDDaZ6tsUAaXttK+PCk4k+O77VSS+cIXox0qLM9T50N
	w4rgXOrqEIYItl4ABa7Dczv6KrzTjTLBfMhFJ30/yjoJ8hB60+KR56XYyCUZpl+VH49xXc
	VPF+S61xUvQu7XwzYKtEEDguaBOV5UE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf25.hostedemail.com: domain of 3sdmdaAkbACgWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.70 as permitted sender) smtp.mailfrom=3sdmdaAkbACgWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755175346; a=rsa-sha256;
	cv=none;
	b=TE9IMHgqAh0sHejrxyKcSaGyLVX0Hcv8s2AkjwZGQ+9XKdSIkLOvQige2GsNq0Jmb4+icR
	bjKNFjXik9hucdpoBwonJakbeF10k65jxROFozOJGnLQRKcZucbS580iXkl5LkUhmhoGT1
	Yy+aDgi2AzpbKzl8g4WJBxQcgTARDhY=
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-88428cc6d2fso206817539f.1
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 05:42:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755175345; x=1755780145;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zz/rWUCteoULmmIxjoLSoJd+Ko3CiZlGW/ae3x/QnaM=;
        b=lgo/PsH1e81kCJl5s/qd7AI3yMtsN6VEJN5tQRJO3m9LYaZoVUUdJEe080WoKxZ+WQ
         WN45FsEC6oUVwtPpuuxi3Nrx4wttAnz+RHlG/SZF7yPStp4tTgzEWUJa/xRJhpzRBZ3c
         KE++duM8Ul8chDwbIlIblUlH0rg4yvhLCRNBnb7K7nwgoBAl8wZ+OQnDAmhrl261cWFi
         TVQHEdGpP4/lcbrMUNSajH6mxkQWBHf+NrYzUBa+ILf6FY/rpRn6RcWdMoeMpfzPjd0g
         Te5dNBDwqQgbkkunJtmKscfx6mB7P10QkvfWUTsw48JPww5Dg1VJa3fMfwil8AZd6hlw
         w7cA==
X-Forwarded-Encrypted: i=1; AJvYcCX4ZVpG80MT4Dia3bmYc8khQTif0+xlzYORTvQr8dIBTkzbFhDrvvBCJQbcYeRdGPnELGxPQ4rvMQ==@kvack.org
X-Gm-Message-State: AOJu0YytFnNtM02bZeaSWn2zI2Ohgkeik1kCI9BtpEv0fcYGH65xBU0P
	NSck3OpD0Xrfh+qEjmSoSa8FpN32A4dQk8oweH3cQwatNVGsdLj/M+jquO5youYzy1CxGmZEtkT
	Ukl9GbJYgvvV7DBxKHqyVl/aosCyU9Dp1IWQhrQgwXDsYUAQC9O9F5Or3eQY=
X-Google-Smtp-Source: AGHT+IEweosvu1I4Kvukd9GFIM0Y6NjElScp+kwI1nztOJX/UAYPDxRdmpBDX403V5EYB8OR4GXmIgWEtXhT+O0AUKiJQYKzkBl6
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1542:b0:881:886b:9bdd with SMTP id
 ca18e2360f4ac-884345d72d2mr526236939f.5.1755175345441; Thu, 14 Aug 2025
 05:42:25 -0700 (PDT)
Date: Thu, 14 Aug 2025 05:42:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <689dd9b1.050a0220.17479b.0007.GAE@google.com>
Subject: [syzbot] Monthly mm report (Aug 2025)
From: syzbot <syzbot+list6c834587f966cfeb9a27@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 91tad3euh9mhtbgh7szd7qikt5guze5p
X-Rspam-User: 
X-Rspamd-Queue-Id: 4AE99A0008
X-Rspamd-Server: rspam05
X-HE-Tag: 1755175346-146236
X-HE-Meta: U2FsdGVkX18ldMU9W5MwyddpQfrRI+JcCPY1h9sxmPyrwQuBP/zy5jCRRUhNZZAb5VHsqYz4x+MA3q3R6XNsa1F4ZPUGZWhxEl4dhm13U8kQTpKqZA5Ko1yVQo3vydYPgB41DZPvSKrAccmVLCtVg9LbQedwTzRzC6z//F+PaB4uaAM3pGsjriiI9gy2e6HG0qqg5gHBzENGZynf7DLpcxbulP4YuZDQe8LHDlieWv7rTs/nbkfi6p8Sg6TXmW5PHp8YWgLKJyLYdGGC+a86fHX08yh8NjMeEizr0xu30T8YWJ3pVG82gQ2dLMG65vEQoeYPkrPt6CvAJckIdSlLW17P6DOK8iKQCQCbuCqlE5Sy5ZlLxYoPfV9VudBtIq21ZsfY8haRvKU6G3Ygl8UqegAQt3PbahS+V0FbyRuoFoYJIKAUOret/+fxGpzzmO9Y3vRRdnWKB57/PbAiUWzZOdy9fe6OnZft2WxrxhU9+aRHVlOYyzimwQWrdO3bJ9Z4f0S4aLweDTO9WKjuSieEzbUjeeHfYQQfrrwDsGBztiYpqw59Km0CsK0TN2isGDNRvJcLOcePHkvHEbVe2viWaGCrtWDlcx4vJWL/EiOKK8++INBNp8CqT8E8IpYN5fXNPXsyzagwfIXF2y9S73YN/T3MbYzi/nvy0dp46URYM8sfLErzA7dq1l2knUYNpqzeX/3BAIqtGkwjzmZj37Zz8MLQONwFSxYHJ5zmP9lWy2tfIo79UweNL9QCe2tiaD+AFV6EgJVi0W0fVq52cV//8w6ZSC4HJHN6HNGLymv5hGkP2v0RPjYFGcgaRBu6VenGcqzIlRCgSDRKc91V3I7M+4gRG8j4IwMpFixQlXKkbCvLH0EnLb9j1co69Trnm1MBgrQyE3ZEXg0fv0f1WX+g3LzgdXankx02xJ5Mx2VC72Wn1Aqc0x8qVeDpcIWnZurFQ6ylkAeVRVMsvP0Hb2o
 XUonF71A
 zSzfX14gL8UrzAQeLsa+iODe1NnsMNaHcwVFEvsXEv7AAFTX+Yu7K1ftJowgKDyeJM1WPkCuXgmnNmwLtMZAD/8YrPigr7MqCO0wI/XUT1EUXqgTjm56+bZmjKbkUPaHMKGDIYpr/zEAJriyfZ9Hbmbp5eImpbIMRVH9ypY5NbraQNNl84FJQXPwdS8fjT/G/hp45f8b2xIwhBOcvZ3DZaGGqgphJJ1sPdMZc3aqFAdax1SMC0RPLloXPssn4NrPSq7bk95gbB35jgZJO1plRom+NKjFm9TwdGjrKtbbAg59ZtU9/LuIlIYd8Ik9en/8KfYLeGUIth4qBTHhM2wf8rQBwN3gLb7iJZLK/uK3YJCawU5zxKVyDzIW2EeOurVQ57kOwxOa/UPZqiQOVN7X/SKn9NExXzvJDlj0s49WeeqYzjTfwX69LioQWdiE629b9zzoeSWDMoQDhEPRrbl6YPZI0sP32nxfaSonD4EtbAswr0Neh2mYmbhgyHNXohN/SU7+jxPkWjJ4BqVIuPNmyg8wbT7UIh/XT/CRA4pVxX7Fq6Xm0hIAVMKFgHl2xrX4lJ+dTPfpTWR4scvgvCHPEwhBPZQRqSPBp9O5hOWvlod1NfXB/9ogZ1fPCdyaiCutBbwOozgvdwagVkzolMbSsh3611wd/fglGq9aqaNka6bfaXKBWULn9OZi2CyTp21/+wNYbXwjDLvJ/kQMpLetXnkEkSJfceeNwGDHGMIOZqndQjZ/B5z9SY8kWUusmH0kF/Fc9SQk3crPezbNYcD7mAMXBu6uwVxdSPf5azAX97Z2fyUPWGXvdqiZaam/q5TcvHo0FNxUUY7Fel8DpBod4QQNqCLzqMd5JnTGO2KE8s65YQv/HmCD8BDax8vQcp9oYYQT9MHLepo0KTsE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello mm maintainers/developers,

This is a 31-day syzbot report for the mm subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/mm

During the period, 10 new issues were detected and 3 were fixed.
In total, 119 issues are still open and 338 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  8289    Yes   WARNING in path_noexec
                   https://syzkaller.appspot.com/bug?extid=3de83a9efcca3f0412ee
<2>  7419    Yes   WARNING in ext4_dirty_folio
                   https://syzkaller.appspot.com/bug?extid=ecab51a4a5b9f26eeaa1
<3>  4019    Yes   INFO: rcu detected stall in worker_thread (9)
                   https://syzkaller.appspot.com/bug?extid=225bfad78b079744fd5e
<4>  3641    Yes   INFO: task hung in page_cache_ra_unbounded (2)
                   https://syzkaller.appspot.com/bug?extid=265e1cae90f8fa08f14d
<5>  2909    Yes   possible deadlock in filemap_fault
                   https://syzkaller.appspot.com/bug?extid=7736960b837908f3a81d
<6>  2729    Yes   possible deadlock in gup_fast_fallback
                   https://syzkaller.appspot.com/bug?extid=63ba90b81c16b86379bd
<7>  653     No    KCSAN: data-race in __filemap_remove_folio / folio_mapping (2)
                   https://syzkaller.appspot.com/bug?extid=606f94dfeaaa45124c90
<8>  576     Yes   INFO: task hung in _vm_unmap_aliases (3)
                   https://syzkaller.appspot.com/bug?extid=fe8f8efd070d727de971
<9>  444     Yes   INFO: rcu detected stall in sys_newfstatat (4)
                   https://syzkaller.appspot.com/bug?extid=1c02a56102605204445c
<10> 442     Yes   INFO: rcu detected stall in dput (8)
                   https://syzkaller.appspot.com/bug?extid=eb9f416500ff134ab699

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

